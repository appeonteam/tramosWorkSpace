$PBExportHeader$u_nvo_calculator.sru
$PBExportComments$Calculatior - nvo for u_calculation
forward
global type u_nvo_calculator from mt_n_nonvisualobject
end type
type s_cargos from structure within u_nvo_calculator
end type
end forward

type s_cargos from structure
    double d_cargo_units
end type

global type u_nvo_calculator from mt_n_nonvisualobject
end type
global u_nvo_calculator u_nvo_calculator

type variables
Public s_revers_sens istr_revers_sens
end variables

forward prototypes
public function boolean uf_calculate (ref s_calculation_parm astr_parm)
public function boolean uf_valid_d (ref double ad_value)
public function boolean uf_cal_worldscale_route (ref s_calculation_parm astr_parm)
public function double uf_cal_rate (integer ai_ratetype, double ad_units, double ad_value)
private subroutine uf_cal_ports (ref s_calculation_cargo_inout astr_inouts[], ref s_calculation_parm astr_parm, boolean ab_reversible, integer ai_cargo_no)
private subroutine uf_cal_purpose_ports (ref s_calculation_cargo_inout astr_inouts[], ref s_calculation_parm astr_parm, integer ai_cargo_no)
public subroutine documentation ()
public function boolean of_cal_consumption (integer ai_type, double ad_minutes, ref s_calculation_parm astr_parm)
public function boolean of_cal_port_consumption (s_calc_data astr_calc_data, ref s_calculation_parm astr_parm)
public function boolean of_cal_consumption_by_time (ref s_calculation_parm astr_parm, long al_contypeid, double ad_minutes)
public subroutine uf_get_minutes (double ad_units, s_calculation_cargo_inout astr_inout, ref double ad_estimated_minutes, ref double ad_calculated_minutes)
end prototypes

public function boolean uf_calculate (ref s_calculation_parm astr_parm);/********************************************************************
   uf_calculate
   <DESC> Calculates a voyage. </DESC>
   <RETURN>	True if ok	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		 ASTR_PARM  S_CALCULATION_PARM
   </ARGS>
   <USAGE>	
		 All cargoes are processed one-by-one in a loop. During the loop, minutes, 
		 consumption, expenses etc. etc. are added to the result array. Finally consumption 
		 price etc. are calculated after the loop.
		 
		 Notice: On reversible cargoes, only the FIRST cargo for each different C/P is
		 calculated. Subroutines, that processes reversible cargoes, should therefore 
		 
		 automaticly check if they need to do anything specical for the reversible cargoes. 
		 Please check the document about the the "calculation formula" before modifying
		 this code.
	</USAGE>
   <HISTORY>
		Date      	CR-Ref		Author	Comments
		09/08/1996	1     		MI    	First Version.
		18/03/2013	CR2658		WWG004	Remove the EU port and add Idle and Sailing consumption.
		11/11/2013	CR2658UAT	WWG004	Calculate the Idle and Load time.
		09/08/2014	CR3528		XSZ004	Calculate consumption for additional days other, bunkering and idle.	
		29/10/15		CR3250		CCY018	Add LSFO fuel in calculation module.
		17/03/16		CR2362		LHG008	Remove hard-coded days in Canal
		10/08/16		CR4219		LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO).
		07/12/16		CR4050		LHG008	Change additionals Laden and Ballasted logic
   </HISTORY>
********************************************************************/

Integer li_count, li_freight_count, li_add_lump, li_max, li_Count2
Double  ld_tmp, ld_bro_commission_gross, ld_add_commission_gross, ld_unitprice, ld_add, ld_bro_commission_gross_pool
Double  ld_sea_minutes, ld_gear_minutes, ld_gross, ld_commission, ld_adr_commission, ld_tmpunits
Double  ld_org_demurrage, ld_new_demurrage
String  ls_add_lump, ls_tmp

u_calc_laytime uo_calc_laytime
s_calc_data    lstr_calc_data

// I_REVERSIBLE_FREIGHT/I_REVERSIBLE_CP explanation:
//
// The I_REVERSIBLE_FREIGHT and I_REVERSIBLE_CP fields is used to control how 
// and when a cargo is included in the calculation. The fields can have the 
// following values:
// 
// -1: This cargo has already been processed as a part of prior cargo, that
//		 uses the same CP.
// 0 : Normal cargo (not reversible)
// 1 : Reversible cargo 

// Set value for already calculated fields

// Force the number of cargos to 1, if duing a ballast voyage calculation
If astr_parm.b_ballastvoyage Then astr_parm.i_no_cargos = 1

// Build the dataarray for calculating laytime
If not astr_parm.b_ballastvoyage Then

	// Building the laytime data arrray
	// Loop through all cargoes, adding description, reversible flag, and C/P ID
	For li_count = 1 to astr_parm.i_no_cargos 
		lstr_calc_data.str_cargo[li_count].s_description = astr_parm.cargolist[li_count].s_cargo_description
		lstr_calc_data.str_cargo[li_count].b_reversible_demurrage = (astr_parm.cargolist[li_count].i_reversible_cp = 1) & 
			or (astr_parm.cargolist[li_count].i_reversible = 1)
		lstr_calc_data.str_cargo[li_count].b_reversible_freight = False 
		lstr_calc_data.str_cargo[li_count].l_cerp_id = astr_parm.cargolist[li_count].l_cerp_id
	
		// Loop through all ports on this cargo, add units, ratetype,
		// terms, if 'consumption EU port', dem/des values and estimated/calculated time
		li_max = Upperbound(astr_parm.cargolist[li_count].str_inouts)
		For li_count2 = 1 To li_max
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_units = astr_parm.cargolist[li_count].str_inouts[li_count2].d_units
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].i_ratetype = astr_parm.cargolist[li_count].str_inouts[li_count2].l_type
		
			SELECT CAL_RATY_MTDH, CAL_RATY_FACTOR				
			  INTO :lstr_calc_data.str_cargo[li_count].str_port[li_count2].i_usedtype,
					 :lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_ratefactor
			  FROM CAL_RATY  
			 WHERE CAL_RATY_ID = :astr_parm.cargolist[li_count].str_inouts[li_count2].l_terms_id;
				
			COMMIT;
			
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_demurrage	= astr_parm.cargolist[li_count].str_inouts[li_count2].d_demurrage
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_despatch		= astr_parm.cargolist[li_count].str_inouts[li_count2].d_despatch
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_estimated	= astr_parm.cargolist[li_count].str_inouts[li_count2].d_estimated
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_calculated	= astr_parm.cargolist[li_count].str_inouts[li_count2].d_calculated
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].l_contype_id	= astr_parm.cargolist[li_count].str_inouts[li_count2].l_port_cons_id
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].d_notice_time	= astr_parm.cargolist[li_count].str_inouts[li_count2].d_notice_time
			lstr_calc_data.str_cargo[li_count].str_port[li_count2].s_purpose		= astr_parm.cargolist[li_count].str_inouts[li_count2].s_purpose
		Next		
	Next

	// Now, create the calculation object, fetch data into the object and calculate
	uo_calc_laytime = CREATE u_calc_laytime
	uo_calc_laytime.istr_calc_data = lstr_calc_data
	uo_calc_laytime.uf_calculate_laytime(0)
	
	// Move result back to our local structure
	lstr_calc_data = uo_calc_laytime.istr_calc_data

	// and destroy the object
	Destroy uo_calc_laytime
End if

// Ok, now loop through all the cargos.
For li_count = 1 To astr_parm.i_no_cargos
	ld_gross = 0

	// Explain calculation is only for internal use. It creates a verbal 
	// of the calculation process.
	If astr_parm.b_explain_calculation Then
		astr_parm.s_explanation += "Calculating cargo #" + String(li_count)  + "~r~n"
	End if

	If not astr_parm.b_ballastvoyage Then
		// Calculate the rate for this cargo. 
		//
		// The following special processing is added for reversible cargos:
		// Loop through all following cargos, and add the quantity for cargos
		// that uses the same CP as the current. The included cargos will
		// be marked with -1 in the I_REVERSIBLE_FREIGHT field, indicating
		// that the cargo shouldn't be calculated later (when the LI_COUNT
		// reaches that cargo).
				
		CHOOSE CASE astr_parm.cargolist[li_count].i_reversible_freight
			CASE -1
				// This is a reversible freight which have already been calculated
				if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    This cargo freigh have allready been calculated~r~n"
			CASE 0
				// Normal calculation (not reversible), do nothing
			CASE 1
				// This is a reversible freight, include data for other cargos that
				// uses the same CP, by updating the D_TOTALUNITS field

				For li_freight_count = li_count + 1 To astr_parm.i_no_cargos
					If (astr_parm.cargolist[li_count].l_cerp_id = astr_parm.cargolist[li_freight_count].l_cerp_id) Then

						if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    Adding unit for cargo #" + String(li_freight_count) + &
							" (units: " + String(astr_parm.cargolist[li_freight_count].d_totalunits) + "~r~n"
		
						astr_parm.cargolist[li_count].d_totalunits += astr_parm.cargolist[li_freight_count].d_totalunits
						astr_parm.cargolist[li_freight_count].i_reversible_freight = -1
					End if
				Next								
		END CHOOSE

		// If the current cargo isn't marked as already processed (I_REVERSIBLE_CP = -1) Then
		// call UF_CAL_PORTS for this cargo
		If astr_parm.cargolist[li_count].i_reversible_cp <> -1 Then
			if astr_parm.b_explain_calculation then &
				astr_parm.s_explanation += "  Including reversible for cargo " + String(astr_parm.cargolist[li_count].i_reversible_cp) + "~r~n"

			uf_cal_ports(astr_parm.cargolist[li_count].str_inouts, astr_parm, (astr_parm.cargolist[li_count].i_reversible_cp = 1) &
				or (astr_parm.cargolist[li_count].i_reversible = 1), li_count)
				
		Else
			if astr_parm.b_explain_calculation then &
				astr_parm.s_explanation += "  Skipping reversible for cargo " + String(li_count) + "~r~n"
		End if

		// Calculate the purpose 
		uf_cal_purpose_ports(astr_parm.cargolist[li_count].str_inouts, astr_parm, li_count)
		
		if astr_parm.b_explain_calculation then &
			astr_parm.s_explanation += "  Other purpose minutes is now "+String(astr_parm.result.d_otherpurpose_minutes)+"~r~n"
	End if

	// Calculate additional days ballasted at sea 
	astr_parm.d_add_min_ballasted += (astr_parm.cargolist[li_count].d_add_days_ballasted * 1440)
	astr_parm.result.d_add_minutes_ballasted += (astr_parm.cargolist[li_count].d_add_days_ballasted * 1440)
	
	// Calculate additional days ballasted in % 
	astr_parm.i_add_days_ballasted_pcnt_total += astr_parm.cargolist[li_count].i_add_days_ballasted_pcnt

	// Calculate additional days laden at sea 
	astr_parm.d_add_min_loaded += (astr_parm.cargolist[li_count].d_add_days_sea * 1440)
	astr_parm.result.d_add_minutes_laden += (astr_parm.cargolist[li_count].d_add_days_sea * 1440)

	// Calculate additional days laden in % 
	astr_parm.i_add_days_laden_pcnt_total += astr_parm.cargolist[li_count].i_add_days_laden_pcnt

	// Caluclate add days other, idle and bunkering 
	astr_parm.result.d_add_minutes_other += (astr_parm.cargolist[li_count].d_add_days * 1440) 
	astr_parm.result.d_add_minutes_idle += (astr_parm.cargolist[li_count].d_add_days_idle * 1440)
	astr_parm.result.d_add_minutes_bunkering += (astr_parm.cargolist[li_count].d_add_days_bunkering * 1440)

	If not astr_parm.b_ballastvoyage Then
	
		// Calculate total demurrage + despatch for the cargo
		//
		// Comment: Martin Israelsen, 26-2-98
		// 
		// This code validates that the new dem/des calculation (from u_calc_laytime) returns
		// the same value as the old calculation. This code should be removed in the future
		ld_org_demurrage = astr_parm.cargolist[li_count].d_demurrage + astr_parm.cargolist[li_count].d_despatch
		ld_new_demurrage = lstr_calc_data.str_cargo[li_count].d_demurrage + lstr_calc_data.str_cargo[li_count].d_despatch	

//		astr_parm.result.d_demurrage += ld_new_demurrage //Correct error first !!

		astr_parm.result.d_demurrage += ld_org_demurrage


		SetNull(ld_unitprice)

		// Calculate gross freight, if I_REVERSIBLE_FREIGHT <> -1.
		// Get either the unitprice, or a gross value
		If astr_parm.cargolist[li_count].i_reversible_freight <> -1 Then
			CHOOSE CASE astr_parm.cargolist[li_count].i_rate_type 
				CASE 1,2  // $ pr. unit - gross_freight = total units * unit rate
					ld_unitprice = astr_parm.cargolist[li_count].d_unitrate
				CASE 3  // lumpsum
					ld_gross = astr_parm.cargolist[li_count].d_lumpsum 
				CASE 4   // ws rate
					If astr_parm.cargolist[li_count].i_local_flatrate = 0 Then
						ld_unitprice = ((astr_parm.cargolist[li_count].d_wsrate/100) * astr_parm.cargolist[li_count].d_flatrate) 

						if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    Flatrate: "+String(ld_unitprice,"#,##0.00")+ &
							" as ("+String(astr_parm.cargolist[li_count].d_wsrate)+"/100) * "+String(astr_parm.cargolist[li_count].d_flatrate,"#,##0.00")+"~r~n"
					Else
						ld_unitprice = ((astr_parm.cargolist[li_count].d_wsrate/100) * astr_parm.cargolist[li_count].d_flatrate) 

						if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    Local flatrate: "+String(ld_unitprice,"#,##0.00")+ &
							" as ("+String(astr_parm.cargolist[li_count].d_wsrate)+"/100) * "+String(astr_parm.cargolist[li_count].d_flatrate,"#,##0.00")+"~r~n"
					End if	
				CASE ELSE
					astr_parm.result.s_errortext = "Error in ratetype - illegal ratetype defined"
					Return(false)
			END CHOOSE

			// If unitprice is given, then calculate the grossfreight, including the
			// min/overage fields (this means calculating with dead freight).
			If not isNull(ld_unitprice) Then
				ld_tmpunits = astr_parm.cargolist[li_count].d_totalunits

				// If number of units is lesser than MIN1, then set the number
				// of units to MIN1.
				If (ld_tmpunits < astr_parm.cargolist[li_count].d_min_1) Then
					ld_tmpunits = astr_parm.cargolist[li_count].d_min_1

					if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    Deadfreight units: " + String(ld_tmpunits, "#,##0.00")
				Else
					// If number of units is larger than MIN 2 (and MIN2 > 0), then calculate the
					// freight for the difference between MIN2 and number of units and multiply
					// it with the OVERAGE 2 factor.
					If (ld_tmpunits > astr_parm.cargolist[li_count].d_min_2) and (astr_parm.cargolist[li_count].d_min_2>0)  Then
						ld_tmp = ld_tmpunits - astr_parm.cargolist[li_count].d_min_2
						ld_gross += (ld_tmp * ld_unitprice) * (astr_parm.cargolist[li_count].i_overage_2 / 100)

						if astr_parm.b_explain_calculation then 	astr_parm.s_explanation += "    Overage 2 units: "+String(ld_tmp,"#,##0.00")+ &
							" to: "+String(ld_unitprice,"#,##0.00")+"$ with overage pct: "+String(astr_parm.cargolist[li_count].i_overage_2 / 100,"#,##0.00")
	
						// Substract the calculated units for MIN2 from the number of units, so
						// the rest of the calculation calculates for MIN1
						ld_tmpunits -= ld_tmp
					End if

					// If number of units is larger than MIN1 (and MIN1 > 0), then calculate the
					// freight for the difference between MIN1 and number of units and multiply
					// it with the OVERAGE1 factor.
					If (ld_tmpunits > astr_parm.cargolist[li_count].d_min_1) and (astr_parm.cargolist[li_count].d_min_1>0) Then
						ld_tmp = ld_tmpunits - astr_parm.cargolist[li_count].d_min_1
						ld_gross += (ld_tmp * ld_unitprice) * (astr_parm.cargolist[li_count].i_overage_1 / 100)

						if astr_parm.b_explain_calculation then 	astr_parm.s_explanation += "    Overage 1 units: "+String(ld_tmp,"#,##0.00")+ &
							" to: "+String(ld_unitprice,"#,##0.00")+"$ with overage pct: "+String(astr_parm.cargolist[li_count].i_overage_1 / 100,"#,##0.00")

						// Substract the calculated units for MIN1 from the number of units, so
						// the rest of the calculation calculates for the quantity below MIN1
						ld_tmpunits -= ld_tmp
					End if
				End if

				if astr_parm.b_explain_calculation then 	astr_parm.s_explanation += "    Normal freight "+ String(ld_tmpunits,"#,##0.00") + " * "+String(ld_unitprice,"#,##0.00")+"$~r~n"

				// Calculate the freight for the rest of the units (MIN1 + MIN2 is already substracted)
				ld_gross  += ld_tmpunits * ld_unitprice

				if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    = Cargo gross freigth "+String(ld_gross,"#,##0.00")+"~r~n"
			Else
				if astr_parm.b_explain_calculation then astr_parm.s_explanation += "This cargo's unitprice is NULL ~r~n"
			End if

			// Add the demurrage (if any) to the gross freight
			ld_gross += astr_parm.cargolist[li_count].d_demurrage/ 1440

			if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    + demurrage: "+String(astr_parm.cargolist[li_count].d_demurrage/ 1440,"#,##0.00")+" ~r~n"

			// Return error if invalid gross freight
			If not uf_valid_d(ld_gross) Then
				astr_parm.result.s_errortext = "Error in data, cannot calculate gross freigt"
				Return(false)
			End if
		
			// If we shouldn't calculate address commission on lumpsum 
			// (I_ADR_COMMISSION_ON_LUMPSUM = 0) then set the LD_COMMISSION_GROSS 
			// to the LD_GROSS value. LD_COMMISSION_GROSS is used to calculate
			// the commission. 
			ld_add_commission_gross = ld_gross
			ld_bro_commission_gross = ld_gross
			ld_bro_commission_gross_pool = ld_gross
			for li_add_lump = 1 to upperbound(astr_parm.cargolist[li_count].d_add_lumpsum)
				If IsNull(astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump]) Then astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump] = 0
				ld_gross += astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump]// Add the additional lumpsum to the LD_GROSS
				If astr_parm.cargolist[li_count].i_adr_commission_on_lumpsum[li_add_lump] = 1 Then 
					ld_add_commission_gross += astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump] 
				end if
				If astr_parm.cargolist[li_count].i_bro_commission_on_lumpsum[li_add_lump] = 1 Then 
					ld_bro_commission_gross += astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump] 
				end if
				ld_bro_commission_gross_pool += astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump] 
				ls_add_lump += String(astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump],"#,##0.00") + ", "
			next	
			
			if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    + Add. lumpsum "+ls_add_lump+"~r~n"			
			if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    = Cargo gross freigth "+String(ld_gross,"#,##0.00")+"~r~n"

			// And add the gross freight to the total gross freight for the calculation
			astr_parm.result.d_gross_freight += ld_gross
			// Save gross freight for this cargo in the ASTR_PARM structur 
			// for use in reversible calculation
			astr_parm.cargolist[li_count].d_local_gross_freight = ld_gross
			
			// Now calculate the commission, first the broker commission
			ld_commission = &
			((astr_parm.cargolist[li_count].d_commission_percent - astr_parm.cargolist[li_count].d_commission_percent_pool) * ld_bro_commission_gross)/100 + &
			(astr_parm.cargolist[li_count].d_commission_percent_pool * ld_bro_commission_gross_pool)/100
			astr_parm.result.d_commission += ld_commission
			// and add broker commission from misc. claims 
			astr_parm.result.d_commission += astr_parm.cargolist[li_count].d_claims_broker_comm

			// Save the (local) commission for use by the reversible calculation
			astr_parm.cargolist[li_count].d_broker_comm = ld_commission
			astr_parm.cargolist[li_count].d_broker_comm += astr_parm.cargolist[li_count].d_claims_broker_comm

			if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    Commission "+String(ld_commission,"#,##0.00")+"~r~n"

			// now calculate adresse commission
			ld_adr_commission = &
			(astr_parm.cargolist[li_count].d_adr_commission_percent * ld_add_commission_gross)/100
			astr_parm.result.d_adr_commission += ld_adr_commission
			// and add adrs comm from misc. claims
			astr_parm.result.d_adr_commission += astr_parm.cargolist[li_count].d_claims_adrs_comm

			// Save the (local) commission for use by the reversible calculation
			astr_parm.cargolist[li_count].d_adrs_comm = ld_adr_commission
			astr_parm.cargolist[li_count].d_adrs_comm += astr_parm.cargolist[li_count].d_claims_adrs_comm

			if astr_parm.b_explain_calculation then astr_parm.s_explanation += "    Addr. Commission "+String(ld_commission,"#,##0.00")+"~r~n"

			// Check that the commission is valid
			If IsNull(ld_adr_commission) Then
				astr_parm.result.s_errortext = "Error in data, cannot calculate commission"
				Return(false)
			End if

		End if // reversible freight <>-1

		// Find total misc income
		astr_parm.result.d_misc_income += astr_parm.cargolist[li_count].d_claims_misc_income
		// Add misc. claims gross freight to total gross freight
		astr_parm.result.d_gross_freight += astr_parm.cargolist[li_count].d_claims_gross_freight
		// Add misc. claims gross freight to total gross freight misc for use in revers calculation
		astr_parm.result.d_gross_freight_misc += astr_parm.cargolist[li_count].d_claims_gross_freight
		// Add additional income to total misc income - shown in result
		astr_parm.result.d_misc_income += astr_parm.cargolist[li_count].d_add_income

		// Calculate laytime - as for reversible freight, we include cargos that
		// is reversible with the current cargo, and marks them with -1, so 
		// they won't be calculated later on
		CHOOSE CASE astr_parm.cargolist[li_count].i_reversible_cp
			CASE -1
				// This was a reversible cp, which have been calculated
			CASE 0
				// Normal, do nothing
			CASE 1
				// This is a reversible freight, include data for others 
				For li_freight_count = li_count + 1 To astr_parm.i_no_cargos

					if astr_parm.b_explain_calculation then & 
						astr_parm.s_explanation += "  Checking "+String(li_count)+"/"+String(astr_parm.cargolist[li_count].l_cerp_id) + &
						" to "+String(li_freight_count)+"/"+String(astr_parm.cargolist[li_freight_count].l_cerp_id)+"~r~n"
	
					If (astr_parm.cargolist[li_count].l_cerp_id = astr_parm.cargolist[li_freight_count].l_cerp_id) Then
						astr_parm.cargolist[li_freight_count].i_reversible_cp = -1
					End if
				Next								
		END CHOOSE
	Else
		// Ballast voyage. Only gross freight is calculated  
		for li_add_lump = 1 to upperbound(astr_parm.cargolist[li_count].d_add_lumpsum)
			If IsNull(astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump]) Then astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump] = 0
			ld_gross += astr_parm.cargolist[li_count].d_add_lumpsum[li_add_lump]  
		next
		astr_parm.result.d_gross_freight += ld_gross
		astr_parm.cargolist[li_count].d_local_gross_freight = ld_gross
	End if

	// Now add the additional Fuel units to the total fuel units
	astr_parm.result.d_fo_units += astr_parm.cargolist[li_count].d_add_fo
	astr_parm.result.d_do_units += astr_parm.cargolist[li_count].d_add_do
	astr_parm.result.d_mgo_units += astr_parm.cargolist[li_count].d_add_mgo
	astr_parm.result.d_lsfo_units += astr_parm.cargolist[li_count].d_add_lsfo

	// and add the misc. additional expenses and total expenses
	astr_parm.result.d_misc_add_expenses += astr_parm.cargolist[li_count].d_add_expenses
	astr_parm.result.d_total_expenses += astr_parm.cargolist[li_count].d_expenses + Abs((astr_parm.cargolist[li_count].d_despatch / 1440))

	//For sensitivity reversible calculation
	astr_parm.cargolist[li_count].d_local_total_costs = astr_parm.cargolist[li_count].d_expenses + &
		astr_parm.cargolist[li_count].d_broker_comm + astr_parm.cargolist[li_count].d_adrs_comm + &
		Abs((astr_parm.cargolist[li_count].d_despatch / 1440)) + astr_parm.cargolist[li_count].d_add_expenses
	astr_parm.cargolist[li_count].d_local_net_result = astr_parm.cargolist[li_count].d_local_gross_freight -  &
		astr_parm.cargolist[li_count].d_local_total_costs
Next


// Comment: Martin Israelsen, 26-2-98
//
// The following code controls that the old Laytime and new laytime calculation
// returns the same result. This code should be removed in the future.

If astr_parm.result.d_load_minutes <> lstr_calc_data.d_load_minutes then &
	ls_tmp += "loadminutes: "+String(astr_parm.result.d_load_minutes) + " " + String(lstr_calc_data.d_load_minutes)+"~r~n"
If astr_parm.result.d_disch_minutes <> lstr_calc_data.d_disch_minutes then &
	ls_tmp += "dischminutes: "+String(astr_parm.result.d_disch_minutes)+" "+String(lstr_calc_data.d_disch_minutes)+"~r~n"
If astr_parm.result.d_load_minutes_gear <> lstr_calc_data.d_load_minutes_gear then &
	ls_tmp += "loadminutes gear: "+String(astr_parm.result.d_load_minutes_gear)+" "+String(lstr_calc_data.d_load_minutes_gear)+"~r~n"
If astr_parm.result.d_disch_minutes_gear <> lstr_calc_data.d_disch_minutes_gear then &
	ls_tmp += "dischminutes gear: "+String(astr_parm.result.d_disch_minutes_gear)+" "+String(lstr_calc_data.d_disch_minutes_gear)+"~r~n"

// Set values from the new laytime calculation
astr_parm.result.d_load_minutes = lstr_calc_data.d_load_minutes
astr_parm.result.d_disch_minutes = lstr_calc_data.d_disch_minutes
astr_parm.result.d_load_minutes_gear = lstr_calc_data.d_load_minutes_gear
astr_parm.result.d_disch_minutes_gear = lstr_calc_data.d_disch_minutes_gear

// For use in the calculation misc. income (from claims) is added to gross freight. 
// It is subtracted after the calculation and shown in its own field. See down below
astr_parm.result.d_gross_freight += astr_parm.result.d_misc_income

If astr_parm.b_explain_calculation Then
	astr_parm.s_explanation += "Misc. income: "+string(astr_parm.result.d_misc_income)+" ~r~n~r~n"
	astr_parm.s_explanation += "Misc. income is added to gross freight. Gross freight:&
									   "+string(astr_parm.result.d_gross_freight )+" ~r~n~r~n"
	astr_parm.s_explanation += "End of cargo calculation ~r~n~r~n"
	astr_parm.s_explanation += "Total Gross freigth: "+String(astr_parm.result.d_gross_freight,"#,##0.00")+"~r~n"
	astr_parm.s_explanation += "Total demurrage: "+String(astr_parm.result.d_demurrage / 1440,"#,##0.00")+"~r~n"
End if

// Add additional expenses to total expenses 
astr_parm.result.d_total_expenses += astr_parm.result.d_misc_add_expenses

// Add minutes from cho purpose
astr_parm.result.d_otherpurpose_minutes += lstr_calc_data.d_cho_minutes + astr_parm.d_noticetime_choports
astr_parm.result.d_port_minutes_other += lstr_calc_data.d_cho_minutes + astr_parm.d_noticetime_choports

// Add minutes from other purposes on caio 
astr_parm.result.d_add_minutes_other += astr_parm.result.d_otherpurpose_minutes + astr_parm.result.d_otherpurpose_minutes_gear

// Add the total noticetime for all cargoes to loadtime and dischtime 
astr_parm.result.d_load_minutes += astr_parm.d_noticetime_loadports
astr_parm.result.d_disch_minutes += astr_parm.d_noticetime_dischports

// Calculate the total costs... 
astr_parm.d_global_costs = astr_parm.result.d_canal_expenses + astr_parm.result.d_fo_expenses + &
	astr_parm.result.d_do_expenses + astr_parm.result.d_mgo_expenses + astr_parm.result.d_lsfo_expenses + (astr_parm.d_oa + astr_parm.d_drc + &
	astr_parm.d_tc) * (astr_parm.result.d_minutes_total / 1440)

// ...the total laytime...
astr_parm.result.d_total_laytime += astr_parm.result.d_load_minutes + astr_parm.result.d_load_minutes_gear + &
	astr_parm.result.d_disch_minutes + astr_parm.result.d_disch_minutes_gear 
astr_parm.result.d_minutes_in_port += astr_parm.result.d_total_laytime + astr_parm.result.d_add_minutes_other 

// ...the total gear minutes...
ld_gear_minutes = astr_parm.result.d_load_minutes_gear + astr_parm.result.d_disch_minutes_gear	+ astr_parm.result.d_otherpurpose_minutes_gear		

// ...and the total expenses
astr_parm.result.d_total_expenses += astr_parm.result.d_canal_expenses 

// Add the itinerary additional days ballasted in %
ld_add = ((astr_parm.i_add_days_ballasted_pcnt_total / 100) * astr_parm.d_minutes_ballasted)

// Total additional days ballasted
astr_parm.d_add_min_ballasted += ld_add
astr_parm.result.d_add_minutes_ballasted += ld_add

// Add the itinerary additional days laden in %
ld_add = ((astr_parm.i_add_days_laden_pcnt_total / 100) * astr_parm.d_minutes_loaded)

// Total additional days laden
astr_parm.d_add_min_loaded += ld_add
astr_parm.result.d_add_minutes_laden += ld_add

// Calculate the total time 
astr_parm.result.d_minutes_total = astr_parm.result.d_minutes_in_canal + astr_parm.d_minutes_loaded + &
	astr_parm.result.d_add_minutes_laden + astr_parm.d_minutes_ballasted  + &
	astr_parm.result.d_add_minutes_ballasted + astr_parm.result.d_minutes_in_port + &
	astr_parm.result.d_add_minutes_idle + astr_parm.result.d_add_minutes_bunkering

// Calculate consumption for at port
if not of_cal_port_consumption(lstr_calc_data, astr_parm) then
	astr_parm.result.s_errortext = "Constype cannot be empty"
	return false
end if

// Calculate for additional days in port
of_cal_consumption(c#consumptiontype.il_ATPORT_GENERAL, astr_parm.result.d_otherpurpose_minutes + astr_parm.result.d_otherpurpose_minutes_gear - astr_parm.result.d_port_minutes_other, astr_parm)

for li_count = 1 to astr_parm.i_no_cargos
	// Calculate consumption for additional day ballasted at sea
	if not of_cal_consumption_by_time(astr_parm, astr_parm.cargolist[li_count].l_ballast_cons_id, astr_parm.cargolist[li_count].d_add_days_ballasted * 1440) then
		astr_parm.result.s_errortext = "Sailing Ballasted at sea consumption not defined for this vessel"
		return(false)
	end if
	
	// Calculate consumption for additional day laden at sea
	if not of_cal_consumption_by_time(astr_parm, astr_parm.cargolist[li_count].l_laden_cons_id, astr_parm.cargolist[li_count].d_add_days_sea * 1440) then
		astr_parm.result.s_errortext = "Sailing Laden at sea consumption not defined for this vessel"
		return(false)
	end if
	
	// Calculate consumption for additional days other, bunkering and idle
	if astr_parm.cargolist[li_count].d_add_days_idle <> 0 then
		of_cal_consumption_by_time(astr_parm, astr_parm.cargolist[li_count].l_idle_cons_id, astr_parm.cargolist[li_count].d_add_days_idle * 1440)
	end if
	
	if astr_parm.cargolist[li_count].d_add_days_bunkering <> 0 then
		of_cal_consumption_by_time(astr_parm, astr_parm.cargolist[li_count].l_bunker_cons_id, astr_parm.cargolist[li_count].d_add_days_bunkering * 1440)
	end if
	
	if astr_parm.cargolist[li_count].d_add_days <> 0 then
		of_cal_consumption_by_time(astr_parm, astr_parm.cargolist[li_count].l_various_cons_id, astr_parm.cargolist[li_count].d_add_days * 1440)
	end if
next

//Add additional consumption for itinerary
astr_parm.result.d_fo_units	+= astr_parm.d_fo_laden_atsea * astr_parm.i_add_days_laden_pcnt_total / 100
astr_parm.result.d_do_units	+= astr_parm.d_do_laden_atsea * astr_parm.i_add_days_laden_pcnt_total / 100
astr_parm.result.d_mgo_units	+= astr_parm.d_mgo_laden_atsea * astr_parm.i_add_days_laden_pcnt_total / 100
astr_parm.result.d_lsfo_units	+= astr_parm.d_lsfo_laden_atsea * astr_parm.i_add_days_laden_pcnt_total / 100
astr_parm.result.d_fo_units	+= astr_parm.d_fo_ballasted_atsea * astr_parm.i_add_days_ballasted_pcnt_total / 100
astr_parm.result.d_do_units	+= astr_parm.d_do_ballasted_atsea * astr_parm.i_add_days_ballasted_pcnt_total / 100
astr_parm.result.d_mgo_units	+= astr_parm.d_mgo_ballasted_atsea * astr_parm.i_add_days_ballasted_pcnt_total / 100
astr_parm.result.d_lsfo_units	+= astr_parm.d_lsfo_ballasted_atsea * astr_parm.i_add_days_ballasted_pcnt_total / 100

// Calculate FO prices
astr_parm.result.d_fo_expenses	= astr_parm.result.d_fo_units * astr_parm.d_fo_price
astr_parm.result.d_do_expenses	= astr_parm.result.d_do_units * astr_parm.d_do_price
astr_parm.result.d_mgo_expenses	= astr_parm.result.d_mgo_units * astr_parm.d_mgo_price
astr_parm.result.d_lsfo_expenses	= astr_parm.result.d_lsfo_units * astr_parm.d_lsfo_price

// Total costs depending on TC and DRC values
If ((astr_parm.d_tc = 0) And (astr_parm.d_drc > 0 )) Then
	astr_parm.result.d_total_costs = astr_parm.result.d_commission + astr_parm.result.d_adr_commission + &
		astr_parm.result.d_total_expenses + &
		astr_parm.result.d_fo_expenses + astr_parm.result.d_do_expenses + astr_parm.result.d_mgo_expenses + astr_parm.result.d_lsfo_expenses + &
		((astr_parm.d_drc + astr_parm.d_oa) * (astr_parm.result.d_minutes_total / 1440))
ElseIf ((astr_parm.d_drc = 0) And (astr_parm.d_tc > 0 )) Then
	astr_parm.result.d_total_costs = astr_parm.result.d_commission + astr_parm.result.d_adr_commission + &
		astr_parm.result.d_total_expenses + &
		astr_parm.result.d_fo_expenses + astr_parm.result.d_do_expenses + astr_parm.result.d_mgo_expenses + astr_parm.result.d_lsfo_expenses + &
		((astr_parm.d_tc + astr_parm.d_oa) * (astr_parm.result.d_minutes_total / 1440))
Elseif ((astr_parm.d_tc = 0) And (astr_parm.d_drc = 0 )) Then
	astr_parm.result.d_total_costs = astr_parm.result.d_commission + astr_parm.result.d_adr_commission + &
		astr_parm.result.d_total_expenses + ( astr_parm.d_oa * (astr_parm.result.d_minutes_total / 1440) ) + &
		astr_parm.result.d_fo_expenses + astr_parm.result.d_do_expenses + astr_parm.result.d_mgo_expenses  + astr_parm.result.d_lsfo_expenses
End If

// Calculate the NET result...
astr_parm.result.d_net_result = astr_parm.result.d_gross_freight - astr_parm.result.d_total_costs

// ...and the NET/DAY result
If astr_parm.result.d_minutes_total > 0 Then
	astr_parm.result.d_net_day = (astr_parm.result.d_net_result / astr_parm.result.d_minutes_total) * 1440
Else
	astr_parm.result.d_net_day = 0
End if

// Calculate the gross day result
astr_parm.result.d_gross_day = (astr_parm.result.d_net_day / c#decimal.GrossToNetRate)

// And update the DRC, OA, CAP and TC values. These are not allowed to be NULL
If IsNull(astr_parm.d_drc) Then astr_parm.d_drc = 0
If IsNull(astr_parm.d_oa) Then astr_parm.d_oa = 0
If IsNull(astr_parm.d_cap) Then astr_parm.d_cap = 0
If IsNull(astr_parm.d_tc) Then astr_parm.d_tc = 0

// Calculate T/C month 
astr_parm.result.d_tc_eqv = ((astr_parm.result.d_net_day + astr_parm.d_tc + astr_parm.d_drc + astr_parm.d_oa) * c#decimal.AvgMonthDays) / (1 - (astr_parm.d_budget_comm/100))
astr_parm.result.d_after_drc_oa = astr_parm.result.d_net_day
astr_parm.result.d_after_drc_oa_cap = astr_parm.result.d_net_day - astr_parm.d_cap

// Add gear time to total time (for display=
astr_parm.result.d_disch_minutes += astr_parm.result.d_disch_minutes_gear 
astr_parm.result.d_load_minutes += astr_parm.result.d_load_minutes_gear 

// Subtract misc. income from gross freight
astr_parm.result.d_gross_freight -= astr_parm.result.d_misc_income

// And we're finally done
Return(true)


end function

public function boolean uf_valid_d (ref double ad_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Validates a double value. Returns true if it's value (not NULL) and
 					not below zero.

 Arguments : AD_VALUE as double

 Returns   : True if valud  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If IsNull(ad_value) Then Return(false)
If ad_value < 0 Then Return(false)
Return(true)
end function

public function boolean uf_cal_worldscale_route (ref s_calculation_parm astr_parm);
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Calculates the worldscale route, based on data given in ASTR_PARM.
 					If a matching worldscale route isn't found, a dialog is shown to
					the users requesting the rate for the given route. 

 Arguments : ASTR_PARM as S_CALCULATION_PARM

 Returns   : True if (Worldscale rate is found)

*************************************************************************************
Development Log 
DATE			VERSION 	NAME			DESCRIPTION
-------- 	------- 	----- 		-------------------------------------
18/10/2012 	CR2797   LGX001      it will always have only one record in flatrate table for a specific year.  
22/08/2017	CR4221	HHX010	    Ignore interim ports
************************************************************************************/

Integer li_count, li_port_count, li_port_count2, li_max, li_tmp, li_no_ports
s_calculation_ports lstr_ports[]
String ls_tmp, ls_route, ls_route_show
s_calculation_ws lstr_ws
Double ld_rate

// Loop through all cargos in the ASTR_PARM, and check the ratetype for each cargo.
For li_count = 1 To astr_parm.i_no_cargos
	ls_route = ""

	// Continue processing if the cargo uses Worldscale (ratetype 4)
	If astr_parm.cargolist[li_count].i_rate_type = 4 Then  
		
		// This cargo uses WS. Now loop through all ports and build an array
		// over the ports used on this cargo.
		li_no_ports =  0

		li_max = UpperBound(astr_parm.cargolist[li_count].str_inouts)
		For li_port_count = 1 To li_max 
			If astr_parm.cargolist[li_count].str_inouts[li_port_count].d_units<>0 and astr_parm.cargolist[li_count].str_inouts[li_port_count].l_cal_caio_interim_port = 0 Then
				li_no_ports ++
				lstr_ports[li_no_ports].i_itinerary_number = astr_parm.cargolist[li_count]. &
										str_inouts[li_port_count].i_itinerary_number 
				lstr_ports[li_no_ports].s_port = astr_parm.cargolist[li_count]. &
										str_inouts[li_port_count].s_port
			End if
		Next
		
		// Sort the ports array according to the itinerary number. For simplicity
		// we use the good old buble sort. The number of ports are typically limited
		// so performace shouldn't be a problem.
		For li_port_count = 1 To li_no_ports

			For li_port_count2 = li_port_count + 1 To li_no_ports
				If lstr_ports[li_port_count].i_itinerary_number > lstr_ports[li_port_count2].i_itinerary_number Then
					
					ls_tmp = lstr_ports[li_port_count].s_port
					li_tmp = lstr_ports[li_port_count].i_itinerary_number
					lstr_ports[li_port_count].s_port = lstr_ports[li_port_count2].s_port
					lstr_ports[li_port_count].i_itinerary_number = lstr_ports[li_port_count2].i_itinerary_number
					lstr_ports[li_port_count2].s_port = ls_tmp										
					lstr_ports[li_port_count2].i_itinerary_number = li_tmp
				End if
			Next			

		Next

		// Add all the ports together to one string, containing the WS route
		For li_port_count = 1 To li_no_ports
			ls_route +=  lstr_ports[li_port_count].s_port
			if li_port_count = 1 then
				ls_route_show = lstr_ports[li_port_count].s_port
			else
				ls_route_show = ls_route_show + " - " + lstr_ports[li_port_count].s_port
			end if
		Next

		// Check to see if local flatrate is used, if not try getting the value from 
		// CAL_WSCA (Worldscale) table, using the WS-route as the WHERE clause.
		If astr_parm.cargolist[li_count].i_local_flatrate = 0 Then
			SELECT CAL_WSCA_RATE
			INTO :ld_rate
			FROM CAL_WSCA
			WHERE CAL_WSCA_PORT_LIST = :ls_route AND
				CAL_WSCA_YEAR = :astr_parm.i_ws_year;
	
			// Route wasn't found, prompt user for the WS flarrate.
			if sqlca.sqlcode < 0 then
				astr_parm.result.s_errortext = "The " + ls_route_show +" route has more than one flatrates in the selected year. Please delete from System Tables > General > Flatrates."
				return(false)
			elseif sqlca.sqlcode = 100 Then
				lstr_ws.s_portlist = ls_route
				lstr_ws.i_year = astr_parm.i_ws_year
				openwithparm(w_calc_worldscale_enter, lstr_ws)
				ld_rate = message.doubleparm
				// Return error if rate wasn't given in the W_CALC_WORLDSCALE window
				if not ld_rate > 0 then 
					astr_parm.result.s_errortext = "Unable to calculate WS-rate"
					return(false)
				end if
			end if

		// Return the flatrate to the calculation 
		astr_parm.cargolist[li_count].d_flatrate = ld_rate
	End if 
      End if			

		COMMIT;

Next

// We passed through - return true
Return(true)


end function

public function double uf_cal_rate (integer ai_ratetype, double ad_units, double ad_value);/***********************************************************************************

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
		ld_min = (ad_value * 60) 
	CASE 1  // MTS/hour
		ld_min = (ad_units / ad_value) * 60
	CASE 2  // Cubicmeters/hour
		ld_min = (ad_units / ad_value) * 60
	CASE 3 // Cubic feet/hour
		ld_min = (ad_units / ad_value) * 60
	CASE 4  //  Days
		ld_min = (ad_value * 1440) 
	CASE 5  // MTS/day
		ld_min = ((ad_units * 1440) / ad_value) 
	CASE 6  // Cubicmeters/Day
		ld_min = ((ad_units * 1440) / ad_value) 
	CASE 7 //  Cubicfeet/Day
		ld_min = ((ad_units * 1440) / ad_value) 
	CASE ELSE
		ld_min = 0
END CHOOSE

Return(ld_min)
end function

private subroutine uf_cal_ports (ref s_calculation_cargo_inout astr_inouts[], ref s_calculation_parm astr_parm, boolean ab_reversible, integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : August 1996

 Description : Calculates estimated/calculated time in ports, and demurrage/despatch 
 					where applicable. IMPORTANT: When calculating a reversible cargo,
					this routine automatically includes other cargos that is reversible
					with the cargo given in AI_CARGO_NO, so this function is called for 
					each cargo, except for reversible cargoes, where this function only 
					should be called for the FIRST cargo on each C/P. 
					
					AB_REVERSIBLE should be true if reversible.
					
 Arguments : ASTR_INOUTS[] as S_CALCULATION_CARGO_INOUT REF, 
 				 ASTR_PARM as S_CALCULATION_PARM REF, 
				 AB_REVERSIBLE as boolean, 
				 AI_CARGO_NO as integer

 Returns   : None  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
19/03/13		CR2658	WWG004	Add at port consumption.  
01/07/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO).
************************************************************************************/

Integer	li_max, li_count, li_mtdh, li_profit_center, li_term, li_freight_count
integer	li_first_disch, li_first_load, li_first_cho, li_firstcargo_cho
Double	ld_factor, ld_minutes, ld_calculated, ld_units, ld_eiu_time, ld_eiu_time_dif
Double	ld_estimated_minutes, ld_calculated_minutes, ld_time_dif
s_calculation_cargo_inout lstr_inout

// Get the number of entries in the ASTR_INOUTS array, and get the LI_PROFIT_CENTER
// number, which is used when calculating the demurrage/despatch
li_max = UpperBound(astr_inouts)
li_profit_center = uo_global.get_profitcenter_no( )

// If reversible then execute the following code.
If ab_reversible Then
	
	// Calculate first total quantity, and find first load port and first dischport. First
	// loadport and dischport numbers are used to get the terms information later when
	// needed. First loadport is stored in the LI_FIRST_LOAD variable, first dischport
	// is stored in the LI_FIRST_DISCH variable. LD_UNITS is the sum of units for this
	// cargo.
	// 
	// NOTE: Loadports will ALWAYS be stored first in the ASTR_INOUTS array.
	
	for li_count = 1 to li_max
		if astr_inouts[li_count].d_units > 0 then
			ld_units += astr_inouts[li_count].d_units
			if li_first_load = 0 then
				li_first_load = li_count
			else
				astr_inouts[li_first_load].d_calculated += astr_inouts[li_count].d_calculated
				astr_inouts[li_first_load].d_estimated += astr_inouts[li_count].d_estimated
			end if
		elseif astr_inouts[li_count].d_units < 0 then
			if li_first_disch = 0 then
				li_first_disch = li_count
			else
				astr_inouts[li_first_disch].d_calculated += astr_inouts[li_count].d_calculated
				astr_inouts[li_first_disch].d_estimated += astr_inouts[li_count].d_estimated
			end if
		elseif astr_inouts[li_count].s_purpose = "CHO" then
			if li_first_cho = 0 then
				lstr_inout = astr_inouts[li_count]
				li_first_cho = li_count
				li_firstcargo_cho = ai_cargo_no
			else
				lstr_inout.d_calculated += astr_inouts[li_count].d_calculated
				lstr_inout.d_estimated += astr_inouts[li_count].d_estimated
			end if
		end if
	next
	
	// If this cargo is reversible then check to see if we should include quantity
	// from other cargos in this calculation. All cargos that uses the same CP
	// should be included in this cargo. 
	If astr_parm.cargolist[ai_cargo_no].i_reversible_cp = 1 Then
		
		// Loop through all cargoes from the NEXT cargo (this + 1) and compare
		// the CP id. If the CP id is the same, then count the total quantity
		// for that cargo and add it to the total quantity in LD_UNITS.
		For li_freight_count = ai_cargo_no + 1 To astr_parm.i_no_cargos
	
			If (astr_parm.cargolist[ai_cargo_no].l_cerp_id = astr_parm.cargolist[li_freight_count].l_cerp_id) Then
				
				// Same CP, Include quantity for this. Loop through ports and add
				// all LOAD units to the total unit variable.
				li_max = Upperbound(astr_parm.cargolist[li_freight_count].str_inouts)
				for li_count = 1 to  li_max
					if astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_units > 0 then
						ld_units += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_units
						astr_inouts[li_first_load].d_calculated += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_calculated
						astr_inouts[li_first_load].d_estimated += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_estimated
						
					elseif astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_units < 0 then
						astr_inouts[li_first_disch].d_calculated += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_calculated
						astr_inouts[li_first_disch].d_estimated += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_estimated
						
					elseif astr_parm.cargolist[li_freight_count].str_inouts[li_count].s_purpose = "CHO" then
						if li_first_cho = 0 then
							lstr_inout = astr_parm.cargolist[li_freight_count].str_inouts[li_count]
							li_first_cho = li_count
							li_firstcargo_cho = li_freight_count
						else
							lstr_inout.d_calculated += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_calculated
							lstr_inout.d_estimated += astr_parm.cargolist[li_freight_count].str_inouts[li_count].d_estimated
						end if
					end if
				Next
			End if
		Next								
	End if
	
	// Calculate load estimated, calculated and gear minutes, and add to appropriate 
	// variable (ld_estimated_minutes etc). If 'At EU port', then add the minutes to
	// the D_LOAD_MINUTES_GEAR, otherwise add the minutes to the D_LOAD_MINUTES
	uf_get_minutes(ld_units, astr_inouts[li_first_load], ld_estimated_minutes, ld_calculated_minutes)
	
	// and do the same for the dischports...
	uf_get_minutes(ld_units, astr_inouts[li_first_disch], ld_estimated_minutes, ld_calculated_minutes) 
	
	// CHO
	if li_first_cho > 0 then
		uf_get_minutes(0, lstr_inout, ld_estimated_minutes, ld_calculated_minutes)
		astr_parm.cargolist[li_firstcargo_cho].str_inouts[li_first_cho] = lstr_inout
	end if
	
	// If calculated value is given, ld_calculated_minutes will be greater than zero,
	// now calculate difference and possible dem/des
	If ld_calculated_minutes > 0 Then
		
		// Calculate LL_TIME_DIF, Example:
		// Calculated:   Estimated:  LL_TIME_DIF:  Demurrage or Despatch:
		// 100           200         -100			 Despatch 
		// 200			  100         100           Demurage
		// 100			  100         0             None
		// Despatch is only calculated if the user is from a bulk profit center (3 or 5)
		
		ld_time_dif =  ld_calculated_minutes - ld_estimated_minutes 
		
		If ld_time_dif > 0 Then // Estimated > Calculated, calculate demurrage
			astr_parm.cargolist[ai_cargo_no].d_demurrage += ld_time_dif  * astr_inouts[li_first_load].d_demurrage			
		Elseif ld_time_dif < 0 Then  // Estimated < Calculated, calculate despatch if Bulk profitcenter
			If (li_profit_center = 3) Or (li_profit_center = 5) Then  
	
				// Get the calculation factor and UU/EIU status from the CAL_RATY table.
				// Note: MTDH should actually be called UU/EIU status, the database could not
				// be changed, so instead a obsolete field is used for this value
	
				SELECT CAL_RATY_MTDH,
					CAL_RATY_FACTOR				
				INTO :li_mtdh,
					:ld_factor
				FROM CAL_RATY  
				WHERE CAL_RATY_ID = :astr_inouts[li_first_load].l_terms_id;

				// Calculate despatch according to UU/EIU
				If li_mtdh <> 1 Then  // UU
					astr_parm.cargolist[ai_cargo_no].d_despatch += ld_time_dif * astr_inouts[li_first_load].d_despatch
				Else	//  Calculate despatch according to EIU rulez
					// This calculation follow a business rule defined by the BULK department.
					// Please check the helpfile for the explanation of this calculation.
					ld_eiu_time = (ld_calculated_minutes / ld_factor)
					ld_eiu_time_dif = (0 - (ld_estimated_minutes - ld_eiu_time))  // To change the sign (0 -) !!
					astr_parm.cargolist[ai_cargo_no].d_despatch += ld_eiu_time_dif  * astr_inouts[li_first_load].d_despatch
				End If
			End If
	
		End if
	End if

Else
		
	For li_count = 1 To li_max 
		
		// Non-reversible
		//
		// This sections loops through all load/disch ports, and calculated estimated,
		// calculated and gear time for each port. The result is added to the result
		// parameter.
		//
		// The following code uses much of the same code as in the reversible calculation
		
		ld_units = astr_inouts[li_count].d_units
	
		// Do not calculate other purpose ports
	//	If astr_inouts[li_count].d_units = 0 Then Continue 
	
		// Get the calculation factor and UU/EIU status from the CAL_RATY table.
		// Note: MTDH should actually be called UU/EIU status, the database could not
		// be changed, so instead a obsolete field is used for this value
		SELECT CAL_RATY_FACTOR,
				 CAL_RATY_MTDH 
		 INTO :ld_factor,
				:li_mtdh
		 FROM CAL_RATY  
		WHERE CAL_RATY_ID = :astr_inouts[li_count].l_terms_id;
	
		li_term = astr_inouts[li_count].l_type
	
		// Calculate estimated minutes
		If astr_inouts[li_count].d_estimated > 0 Then
			ld_minutes = uf_cal_rate(li_term, Abs(ld_units), astr_inouts[li_count].d_estimated) * ld_factor
		Else
			ld_minutes = 0
		End If
	
		// If calculated value is given (>0), and there's a difference between
		// estimated and calculated, then calculate possible demurrage/despatch.
		If (astr_inouts[li_count].d_calculated>0) And (astr_inouts[li_count].d_estimated<>astr_inouts[li_count].d_calculated) Then
	
			// Calculate LL_TIME_DIF, Example:
			// Calculated:   Estimated:  LL_TIME_DIF:  Demurrage or Despatch:
			// 100           200         -100			 Despatch 
			// 200			  100         100           Demurage
			// 100			  100         0             None
			// Despatch is only calculated if the user is from a bulk profit center (3 or 5)
			
			ld_calculated = uf_cal_rate(li_term, Abs(ld_units), astr_inouts[li_count].d_calculated) * ld_factor
			ld_time_dif = ld_minutes - ld_calculated
			ld_time_dif = 0 - ld_time_dif
	
			If ld_time_dif > 0 Then // Estimated > Calculated, calculate demurrage
				astr_parm.cargolist[ai_cargo_no].d_demurrage += ld_time_dif  * astr_inouts[li_count].d_demurrage
			ElseIf ld_time_dif = 0 Then // ld_time_dif = 0, don't add anything
				astr_parm.cargolist[ai_cargo_no].d_demurrage += 0
			Else  // Estimated < Calculated, calculate despatch if Bulk profitcenter
				If (li_profit_center = 3) Or (li_profit_center = 5) Then
					If li_mtdh <> 1 Then  // UU
						astr_parm.cargolist[ai_cargo_no].d_despatch += ld_time_dif * astr_inouts[li_count].d_despatch
					Else //  EIU
						ld_eiu_time = (ld_calculated / ld_factor)
						ld_eiu_time_dif = (0 - (ld_minutes - ld_eiu_time))  // To change the sign (0 -) !!
						astr_parm.cargolist[ai_cargo_no].d_despatch += ld_eiu_time_dif  * astr_inouts[li_count].d_despatch
					End If
				End If
			End If
	
			ld_minutes = ld_calculated
		End if
		
		// Add calculated time to result fields.
		if ld_units > 0 then
			astr_parm.result.d_load_minutes += ld_minutes
		elseif ld_units < 0 then
			astr_parm.result.d_disch_minutes += ld_minutes
		end if
	Next

End if


end subroutine

private subroutine uf_cal_purpose_ports (ref s_calculation_cargo_inout astr_inouts[], ref s_calculation_parm astr_parm, integer ai_cargo_no);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : TA
   
 Date       : 1996

 Description : Calculates time used in other purpose-ports

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
19/03/13		CR2658	WWG004	Remove the EU port laytime. 
01/07/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO).
************************************************************************************/

Integer	li_max, li_count
Double	ld_minutes

li_max = Upperbound(astr_inouts)
For li_count = 1 To li_max 
	If astr_inouts[li_count].d_units = 0 Then
		
		if astr_inouts[li_count].s_purpose = "CHO" Then
			/*CHO logic same as L/D. The minutes calculate by uf_cal_ports, the result will be add to 
			astr_parm.result.d_otherpurpose_minutes and astr_parm.result.d_port_minutes_other */
			continue
		end if
		
		//add notice minutes
		ld_minutes = astr_inouts[li_count].d_notice_time * 60
		
		If astr_inouts[li_count].s_purpose = "BUN" Then
			astr_parm.result.d_add_minutes_bunkering += ld_minutes
			astr_parm.result.d_port_minutes_bunkering += ld_minutes
		Elseif astr_inouts[li_count].s_purpose = "CAN" Then
			astr_parm.result.d_minutes_in_canal += ld_minutes
			astr_parm.result.d_port_minutes_incanal += ld_minutes
		Elseif astr_inouts[li_count].s_purpose = "WD" Then
			astr_parm.result.d_add_minutes_idle += ld_minutes
			astr_parm.result.d_port_minutes_idle += ld_minutes
		Elseif astr_inouts[li_count].s_purpose = "DOK" Then
			astr_parm.result.d_otherpurpose_minutes += ld_minutes
			astr_parm.result.d_port_minutes_other += ld_minutes
			astr_parm.result.d_dok_minutes += ld_minutes
		Else
			astr_parm.result.d_otherpurpose_minutes += ld_minutes
			astr_parm.result.d_port_minutes_other += ld_minutes
		End if
	End if
Next
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Description	</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		18/10/2012		CR2797		LGX001      it will always have only one record in flatrate table for a specific year.
		19/10/2013		CR2658 		WWG004		remove at EU PORT 
		09/08/2014		CR3528		XSZ004		Calculate consumption for additional days other, bunkering and idle.
		29/10/2015		CR3250		CCY018		Add LSFO fuel in calculation module.
		17/03/2016		CR2362		LHG008		Remove hard-coded days in Canal
		01/07/2016		CR4219		LHG008		Accuracy and improvement in DEM and DEV claims handling(CHO).
		22/08/2017		CR4221		HHX010		Ignore interim ports
   </HISTORY>
********************************************************************/
 
 
  
end subroutine

public function boolean of_cal_consumption (integer ai_type, double ad_minutes, ref s_calculation_parm astr_parm);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 6/10-97

 Description : Calculates consumption for AD_MINUTES with AI_TYPE consumption type, 
 					and updates the ASTR_PARM structure. 
 					
 Arguments : AI_TYPE as Integer, AD_MINUTES as double, ASTR_PARM as S_CALCULATION_PARM

 Returns   : True if ok  

*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 	------- 	----- 	-------------------------------------
18/03/13		CR2658	WWG004	Change calculation for ports.  
29/10/15		CR3250	CCY018		Add LSFO fuel in calculation module.
************************************************************************************/

Integer	li_count, li_row
long		ll_contype_id

// Exit if there's nothing to do (minutes = 0).
If ad_minutes = 0 Then Return(true)  

CHOOSE CASE ai_type
	CASE c#consumptiontype.il_SAILING_BALLAST //Addational Ballast
		ll_contype_id = astr_parm.cargolist[1].l_ballast_cons_id
		if not of_cal_consumption_by_time(astr_parm, ll_contype_id, ad_minutes) then
			return false
		end if
	CASE c#consumptiontype.il_SAILING_LADEN //Addational Laden
		ll_contype_id = astr_parm.cargolist[1].l_laden_cons_id
		if not of_cal_consumption_by_time(astr_parm, ll_contype_id, ad_minutes) then
			return false
		end if
	CASE ELSE
		// Find consumption entry for used speed given in AI_TYPE
		For li_count = 1 To astr_parm.i_nospeeds
			If astr_parm.speedlist[li_count].i_type = ai_type Then
				li_row = li_count
				Exit
			End if
		Next
		
		If li_row = 0 Then 
			Return(false)
		Else
			astr_parm.result.d_fo_units += (astr_parm.speedlist[li_row].d_fo * ad_minutes) / 1440
			astr_parm.result.d_do_units += (astr_parm.speedlist[li_row].d_do * ad_minutes) / 1440
			astr_parm.result.d_mgo_units += (astr_parm.speedlist[li_row].d_mgo * ad_minutes) / 1440
			astr_parm.result.d_lsfo_units += (astr_parm.speedlist[li_row].d_lsfo * ad_minutes) / 1440
		
			Return(true)
		End if
END CHOOSE
end function

public function boolean of_cal_port_consumption (s_calc_data astr_calc_data, ref s_calculation_parm astr_parm);/********************************************************************
   of_cal_port_consumption
   <OBJECT>		Calculate At port consumtpion	</OBJECT>
   <USAGE>		Call from uf_calcate 			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author			Comments
   	20/03/2013	CR2658		WWG004			First Version
		07/07/2016	CR4219		LHG008			Accuracy and improvement in DEM and DEV claims handling(CHO).
   </HISTORY>
********************************************************************/

double	ld_est_minutes, ld_act_minutes, ld_notice_minutes, ld_minutes, ld_atport_minutes
double	ld_units
integer	li_cargo, li_port_count, li_freight_count
integer	li_loadports_count, li_dischports_count, li_choport_count
integer	li_load_port, li_disch_port, li_cho_port
long		ll_contype_id
Boolean	lb_reversible, lb_continue

s_calc_cargo_data lstr_cargo

for li_cargo = 1 to astr_calc_data.i_number_of_cargoes
	
	lstr_cargo = astr_calc_data.str_cargo[li_cargo]
	lb_reversible = lstr_cargo.b_reversible_demurrage
	
	//Reversible calculate the load ports and discharge ports, the estimate time will be average calculate
	if lb_reversible then
		li_loadports_count	= 0
		li_dischports_count	= 0
		li_choport_count = 0
		
		li_load_port	= 0
		li_disch_port	= 0
		li_cho_port = 0
		
		for li_port_count = 1 to upperbound(lstr_cargo.str_port)
			ld_units = lstr_cargo.str_port[li_port_count].d_units
			if ld_units > 0 then	//Load ports count
				if li_load_port = 0 then li_load_port = li_port_count
				li_loadports_count ++
			elseif ld_units < 0 then	//Discharge ports count
				if li_disch_port = 0 then li_disch_port = li_port_count
				li_dischports_count ++
			elseif lstr_cargo.str_port[li_port_count].s_purpose = "CHO" then
				if li_cho_port = 0 then li_cho_port = li_port_count
				li_choport_count ++
			end if
		next
		
		for li_freight_count = 1 to astr_calc_data.i_number_of_cargoes
			
			if li_freight_count <> li_cargo and &
				astr_calc_data.str_cargo[li_freight_count].l_cerp_id = astr_calc_data.str_cargo[li_cargo].l_cerp_id then
				
				if li_freight_count < li_cargo then
					lb_continue = true
					exit
				else
					// Same CP, Include the cargo into lstr_cargo
					for li_port_count = 1 to upperbound(astr_calc_data.str_cargo[li_freight_count].str_port)
						lstr_cargo.str_port[upperbound(lstr_cargo.str_port) +1] = astr_calc_data.str_cargo[li_freight_count].str_port[li_port_count]
						
						if astr_calc_data.str_cargo[li_freight_count].str_port[li_port_count].d_units > 0 then
							li_loadports_count ++
						elseif astr_calc_data.str_cargo[li_freight_count].str_port[li_port_count].d_units < 0 then
							li_dischports_count ++
						elseif astr_calc_data.str_cargo[li_freight_count].str_port[li_port_count].s_purpose = "CHO" then
							if li_cho_port = 0 then li_cho_port = upperbound(lstr_cargo.str_port)
							li_choport_count ++
						end if
					next
				end if
			end if
		next
		
		//Already been calculated
		if lb_continue then continue
	end if
	
	for li_port_count = 1 to upperbound(lstr_cargo.str_port)
		ld_atport_minutes = 0
		
		if lb_reversible then	//Average the estimate and actual time
			ld_units = lstr_cargo.str_port[li_port_count].d_units
			if ld_units > 0 then	//All load ports' estimeate and actual time are average the first load port's
				ld_est_minutes	= lstr_cargo.str_port[li_load_port].d_estimated_minutes / li_loadports_count
				ld_act_minutes	= lstr_cargo.str_port[li_load_port].d_calculated_minutes / li_loadports_count
			elseif ld_units < 0 then	//All discharge ports' estimeate and actual time are average the first discharge port's
				ld_est_minutes	= lstr_cargo.str_port[li_disch_port].d_estimated_minutes / li_dischports_count
				ld_act_minutes	= lstr_cargo.str_port[li_disch_port].d_calculated_minutes / li_dischports_count
			elseif lstr_cargo.str_port[li_port_count].s_purpose = "CHO" and li_cho_port > 0 then
				ld_est_minutes	= lstr_cargo.str_port[li_cho_port].d_estimated_minutes / li_choport_count
				ld_act_minutes	= lstr_cargo.str_port[li_cho_port].d_calculated_minutes / li_choport_count
			else	//Other purpose
				ld_est_minutes	= lstr_cargo.str_port[li_port_count].d_estimated_minutes
				ld_act_minutes	= lstr_cargo.str_port[li_port_count].d_calculated_minutes
			end if
		else	//Calculate each ports' estimate and actual time
			ld_est_minutes	= lstr_cargo.str_port[li_port_count].d_estimated_minutes
			ld_act_minutes	= lstr_cargo.str_port[li_port_count].d_calculated_minutes
		end if
		
		ld_notice_minutes	= lstr_cargo.str_port[li_port_count].d_notice_minutes
		ll_contype_id		= lstr_cargo.str_port[li_port_count].l_contype_id
		
		if isnull(ll_contype_id) then return false
		
		if (ld_est_minutes = 0 and ld_act_minutes = 0 and ld_notice_minutes = 0) then continue
		
		//If the Actual is inputed then use the acutal time.
		if ld_act_minutes > 0 then
			ld_minutes = ld_act_minutes
		else
			ld_minutes = ld_est_minutes
		end if
		
		ld_atport_minutes = ld_minutes + ld_notice_minutes
		
		//Calculate the consumption
		if not of_cal_consumption_by_time(astr_parm, ll_contype_id, ld_atport_minutes) then
			return false
		end if
	next
next	

return true
end function

public function boolean of_cal_consumption_by_time (ref s_calculation_parm astr_parm, long al_contypeid, double ad_minutes);/********************************************************************
   of_cal_consumption_by_time
   <OBJECT>		Use time and consupmtion type id to calculate the bunker.	</OBJECT>
   <USAGE>		When calculate bunker.			</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	09/04/2013	CR2658		WWG004		First Version
		07/11/2013	CR2658UAT	WWG004		If the At port Load/Discharg not defind, return false
		29/10/15		CR3250		CCY018		Add LSFO fuel in calculation module.
		18/03/2016	CR2362		LHG008		Fix a system error when recalculate older calculation
		07/12/2016	CR4050		LHG008		Change additionals Laden and Ballasted logic
   </HISTORY>
********************************************************************/

integer	li_find_conid, li_cons_rows

if isnull(ad_minutes) or ad_minutes = 0 then return true

if isvalid(astr_parm.ds_speed_list) then
	li_cons_rows = astr_parm.ds_speed_list.rowcount()
	
	li_find_conid = astr_parm.ds_speed_list.find("cal_cons_id = " + string(al_contypeid), 1, li_cons_rows)
	
	if li_find_conid > 0 then
		astr_parm.result.d_mgo_units	+= astr_parm.ds_speed_list.getitemnumber(li_find_conid, "cal_cons_mgo") * ad_minutes / 1440
		astr_parm.result.d_do_units	+= astr_parm.ds_speed_list.getitemnumber(li_find_conid, "cal_cons_do") * ad_minutes / 1440
		astr_parm.result.d_fo_units	+= astr_parm.ds_speed_list.getitemnumber(li_find_conid, "cal_cons_fo") * ad_minutes / 1440
		astr_parm.result.d_lsfo_units	+= astr_parm.ds_speed_list.getitemnumber(li_find_conid, "cal_cons_lsfo") * ad_minutes / 1440
		
		return true
	end if
else
	// Find consumption entry for used speed given in AI_TYPE
	For li_find_conid = 1 To astr_parm.i_nospeeds
		If astr_parm.speedlist[li_find_conid].l_contype_id = al_contypeid Then
			astr_parm.result.d_fo_units += (astr_parm.speedlist[li_find_conid].d_fo * ad_minutes) / 1440
			astr_parm.result.d_do_units += (astr_parm.speedlist[li_find_conid].d_do * ad_minutes) / 1440
			astr_parm.result.d_mgo_units += (astr_parm.speedlist[li_find_conid].d_mgo * ad_minutes) / 1440
			astr_parm.result.d_lsfo_units += (astr_parm.speedlist[li_find_conid].d_lsfo * ad_minutes) / 1440
			
			return true
		end if
	Next
end if

return false
end function

public subroutine uf_get_minutes (double ad_units, s_calculation_cargo_inout astr_inout, ref double ad_estimated_minutes, ref double ad_calculated_minutes);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS + TA
   
 Date       : 1996

 Description : Calculates the number of minutes used in each port. Takes the number
 					of units in AD_UNITS and the ports in ASTR_INOUT. Minutes used is
					returned in the three fields AD_ESTIMATED_MINUTES, 
					AD_CALCULATED_MINUTES

 Arguments : AD_UNITS as double, 
 				 ASTR_INOUT as S_CALCULATION_CARGO_INOUT,
				 AD_ESTIMATED_MINUTES as double REF,
				 AD_CALCULATED_MINUTES as double REF

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer	li_mtdh
Double	ld_factor, ld_calculated, ld_estimated

// Get the calculation factor and UU/EIU status from the CAL_RATY table.
// Note: MTDH should actually be called UU/EIU status, the database could not
// be changed, so instead a obsolete field was used for this value
SELECT CAL_RATY_FACTOR, CAL_RATY_MTDH 
  INTO :ld_factor, :li_mtdh
  FROM CAL_RATY  
 WHERE CAL_RATY_ID = :astr_inout.l_terms_id;
COMMIT;

// If the estimated time for this port is given, then call UF_CAL_RATE to calculate
// the rate for this port. Add the result to the AD_ESTIMATED_MINUTES.
If astr_inout.d_estimated > 0 Then
	ld_estimated = uf_cal_rate(astr_inout.l_type, ad_units, astr_inout.d_estimated) * ld_factor
	ad_estimated_minutes += ld_estimated
End if

// If the calculated time for this port is given, then call UF_CAL_RATE to calculate
// the rate for this port. Add the result to the AD_CALCULATED_MINUTES.
If astr_inout.d_calculated > 0 Then
	ld_calculated = uf_cal_rate(astr_inout.l_type, ad_units, astr_inout.d_calculated) * ld_factor
	ad_calculated_minutes += ld_calculated
End if

end subroutine

on u_nvo_calculator.create
call super::create
end on

on u_nvo_calculator.destroy
call super::destroy
end on

