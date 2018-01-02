$PBExportHeader$u_atobviac_calc_rate.sru
$PBExportComments$This object is serving as a base for all other calc-objects. After implementing AtoBviaC distance table.
forward
global type u_atobviac_calc_rate from mt_n_nonvisualobject
end type
end forward

global type u_atobviac_calc_rate from mt_n_nonvisualobject
end type
global u_atobviac_calc_rate u_atobviac_calc_rate

forward prototypes
public function double of_calc_rate (s_calculation_parm astr_calc_parm, double ad_tce, integer ai_cargo_no[])
public subroutine documentation ()
end prototypes

public function double of_calc_rate (s_calculation_parm astr_calc_parm, double ad_tce, integer ai_cargo_no[]);/********************************************************************
   u_atobviac_calc_compact
   <OBJECT>		Calculate Rate when change TCE/Day	</OBJECT>
   <USAGE>		Call from of_change_tceday			</USAGE>
   <ALSO>		NA			</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	01/11/2013	CR2658		WWG004		First Version
	30/10/2015	CR3250		CCY018		Add LSFO fuel in calculation module.
   </HISTORY>
********************************************************************/

double	ld_rate, ld_net_day, ld_global_net_result, ld_local_net_result, ld_global_costs
double	ld_other_local_net_results, ld_sum_local_net_result
double	ld_tmp2, ld_tmp3, ld_tmp4, ld_tmp5
double	ld_addrlumpsumamount, ld_broklumpsumamount, ld_lumpsum
double	ld_allcomms_pc, ld_brokcomm_pc, ld_addrcomm_pc
integer	li_lumpsum, li_totallumpsums

// Calculate net per day 
If (astr_calc_parm.d_tc = 0) And (astr_calc_parm.d_drc > 0) Then
	ld_net_day =  (ad_tce * (1 - (astr_calc_parm.d_budget_comm / 100))) / c#decimal.AvgMonthDays - (astr_calc_parm.d_drc + astr_calc_parm.d_oa)
ElseIf (astr_calc_parm.d_tc > 0) And (astr_calc_parm.d_drc = 0) then
	ld_net_day =  (ad_tce * (1 - (astr_calc_parm.d_budget_comm / 100))) / c#decimal.AvgMonthDays - (astr_calc_parm.d_tc + astr_calc_parm.d_oa)
ElseIf (astr_calc_parm.d_tc = 0) And (astr_calc_parm.d_drc = 0) Then
	ld_net_day =  (ad_tce * (1 - (astr_calc_parm.d_budget_comm / 100))) / c#decimal.AvgMonthDays -  astr_calc_parm.d_oa
End If

// Calculate Global net result
ld_global_net_result = ld_net_day * (astr_calc_parm.result.d_minutes_total / 1440)

// Calculate Global costs
ld_global_costs = astr_calc_parm.result.d_canal_expenses + &
						astr_calc_parm.result.d_fo_expenses + &
						astr_calc_parm.result.d_do_expenses + astr_calc_parm.result.d_mgo_expenses + astr_calc_parm.result.d_lsfo_expenses + &
						((astr_calc_parm.d_oa  + astr_calc_parm.d_drc + astr_calc_parm.d_tc) * &
						(astr_calc_parm.result.d_minutes_total / 1440))

// Calculate sum of local net results (global net + global costs - misc income) 
If astr_calc_parm.i_no_cargos > 1 Then
	ld_sum_local_net_result = ld_global_net_result + ld_global_costs - astr_calc_parm.result.d_misc_income
Else
	ld_sum_local_net_result = ld_global_net_result + ld_global_costs - &
		astr_calc_parm.result.d_misc_income - astr_calc_parm.result.d_gross_freight_misc
End if	

// Calculate other local net results. Take net resullt of original calculation and 
//subtract other original local net results 
If astr_calc_parm.i_no_cargos > 1 Then
	ld_other_local_net_results = astr_calc_parm.result.d_net_result - &
		astr_calc_parm.result.d_misc_income - &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_local_net_result + ld_global_costs 
Else
	ld_other_local_net_results = 0
End If

// Calculate local net result
ld_local_net_result = ld_sum_local_net_result - ld_other_local_net_results

//Determin if there is dead freight, or min, min2, overage1 and overage2 and calculate quantity to fit 
If astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 > astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits then
	astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits = astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1
Elseif astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 > 0 and  &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1< &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits and &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 = 0 Then
	
	astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits = &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 + &
		((astr_calc_parm.cargolist[ai_cargo_no[1]].i_overage_1 / 100) * &
		(astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits - &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1))

Elseif astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 > 0 and  &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 < &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 and &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 > 0 and  &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 < &
		 astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits  Then
					
	astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits = &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 + &
		((astr_calc_parm.cargolist[ai_cargo_no[1]].i_overage_1 / 100) * &
		(astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 - &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1))  +  &
		((astr_calc_parm.cargolist[ai_cargo_no[1]].i_overage_2 / 100) *  &
		(astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits - &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2))  
End If

// Part results, to make the calculation of the different rates easier
ld_brokcomm_pc		= astr_calc_parm.cargolist[ai_cargo_no[1]].d_commission_percent / 100
ld_addrcomm_pc		= astr_calc_parm.cargolist[ai_cargo_no[1]].d_adr_commission_percent / 100
ld_allcomms_pc		= ld_brokcomm_pc + ld_addrcomm_pc
li_totallumpsums	= upperbound(astr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum)

for li_lumpsum = 1 to li_totallumpsums 
	if astr_calc_parm.cargolist[ai_cargo_no[1]].i_adr_commission_on_lumpsum[li_lumpsum] = 1 then
		ld_addrlumpsumamount += astr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum[li_lumpsum] 
	end if
	
	if astr_calc_parm.cargolist[ai_cargo_no[1]].i_bro_commission_on_lumpsum[li_lumpsum] = 1 then
		ld_broklumpsumamount += astr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum[li_lumpsum] 
	end if
	
	ld_lumpsum += astr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum[li_lumpsum] 
next

// save the real lumpsum amounts with
If ld_addrlumpsumamount > 0 Then ld_addrlumpsumamount = ld_addrlumpsumamount * ld_addrcomm_pc
If ld_broklumpsumamount > 0 Then ld_broklumpsumamount = ld_broklumpsumamount * ld_brokcomm_pc		

ld_tmp2 = ld_local_net_result - ld_lumpsum + &
			 astr_calc_parm.cargolist[ai_cargo_no[1]].d_expenses + &
			 (Abs(astr_calc_parm.cargolist[ai_cargo_no[1]].d_despatch) / 1440 ) + &
			 astr_calc_parm.cargolist[ai_cargo_no[1]].d_add_expenses 
					
ld_tmp3 = astr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits

ld_tmp4 = (astr_calc_parm.cargolist[ai_cargo_no[1]].d_demurrage / 1440) * (ld_allcomms_pc - 1)

ld_tmp5 = (astr_calc_parm.cargolist[ai_cargo_no[1]].d_claims_broker_comm + &
			 astr_calc_parm.cargolist[ai_cargo_no[1]].d_claims_adrs_comm)

CHOOSE CASE astr_calc_parm.cargolist[ai_cargo_no[1]].i_rate_type
	CASE 1,2	//Calculate rate 1 = Per mt; 2 = Per cbm
		ld_rate = (ld_tmp2 + ld_tmp4 + ld_addrlumpsumamount + ld_broklumpsumamount &
				  + ld_tmp5 ) / ( ld_tmp3 * ( 1 - ld_allcomms_pc ) )
	CASE 3 //Calculation Lumpsum
		ld_rate = (ld_tmp2 + ((astr_calc_parm.cargolist[ai_cargo_no[1]].d_demurrage / 1440) * (ld_allcomms_pc - 1)) + &
					 ld_addrlumpsumamount + ld_broklumpsumamount + ld_tmp5 ) / ( 1 - ld_allcomms_pc )	
	CASE 4 //WS Calculated
		ld_rate = ((ld_tmp2 + ((astr_calc_parm.cargolist[ai_cargo_no[1]].d_demurrage / 1440) * (ld_allcomms_pc - 1)) + &
					 ld_addrlumpsumamount + ld_broklumpsumamount + ld_tmp5)  * 100) / (((1 - ld_allcomms_pc) * ld_tmp3 ) * &
					 astr_calc_parm.cargolist[ai_cargo_no[1]].d_flatrate)
END CHOOSE

return(ld_rate)
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_atobviac_calc_rate
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
  19/02/13	CR3167	AGL027		Added new _addmessage() function to control icon displayed
  30/10/15	CR3250	CCY018		Add LSFO fuel in calculation module.
********************************************************************/

end subroutine

on u_atobviac_calc_rate.create
call super::create
end on

on u_atobviac_calc_rate.destroy
call super::destroy
end on

