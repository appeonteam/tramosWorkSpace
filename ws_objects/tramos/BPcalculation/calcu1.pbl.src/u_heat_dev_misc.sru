$PBExportHeader$u_heat_dev_misc.sru
$PBExportComments$User object for calculating heating, deviation, misc. claims for a cargo
forward
global type u_heat_dev_misc from u_calc_base_sqlca
end type
end forward

global type u_heat_dev_misc from u_calc_base_sqlca
integer width = 878
integer height = 568
end type
global u_heat_dev_misc u_heat_dev_misc

forward prototypes
public function boolean uf_calculate (ref s_hea_dev_misc_parm as_hea_dev_misc_parm)
private subroutine documentation ()
end prototypes

public function boolean uf_calculate (ref s_hea_dev_misc_parm as_hea_dev_misc_parm);boolean lb_tmp
integer li_max, li_tmp, li_bro_comm_pool
double ld_heat_dev, ld_misc, ld_heat_dev_time
decimal ld_commission_percent_pool

// Calculate heating and deviation for the cargo
li_max = UpperBound(as_hea_dev_misc_parm.array_heat_dev[])
For li_tmp = 1 to li_max
	CHOOSE CASE as_hea_dev_misc_parm.array_heat_dev[li_tmp].s_claim_type
		CASE "HEA", "DEV"
			ld_heat_dev = as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hfo_ton * & 
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hfo_price + &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_do_ton * &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_do_price + &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_go_ton * &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_go_price +&
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_lshfo_ton * &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_lshfo_price

			ld_heat_dev += (as_hea_dev_misc_parm.array_heat_dev[li_tmp].i_hea_dev_hours / 24) * &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hea_dev_price_day
						
			ld_heat_dev_time = (as_hea_dev_misc_parm.array_heat_dev[li_tmp].i_hea_dev_hours / 24) * &
						as_hea_dev_misc_parm.array_heat_dev[li_tmp].d_hea_dev_price_day
			//pool manager broker commission
			SELECT POOL_MANAGER_COMMISSION
			INTO :li_bro_comm_pool
			FROM CLAIM_TYPES
			WHERE CLAIM_TYPE = :as_hea_dev_misc_parm.array_heat_dev[li_tmp].s_claim_type
			;
			COMMIT;
			If li_bro_comm_pool = 1 Then
				as_hea_dev_misc_parm.d_broker_comm_amount += (ld_heat_dev_time / 100) * &
							as_hea_dev_misc_parm.d_broker_comm_pct_pool
			end if
			//broker commission
			if as_hea_dev_misc_parm.array_heat_dev[li_tmp].i_broker_comm_hours = 1 then
				as_hea_dev_misc_parm.d_broker_comm_amount += (ld_heat_dev_time / 100) * &
							(as_hea_dev_misc_parm.d_broker_comm_pct - as_hea_dev_misc_parm.d_broker_comm_pct_pool)
			end if
			//address commisssion
			If as_hea_dev_misc_parm.array_heat_dev[li_tmp].i_addrs_comm_hours = 1 Then
				as_hea_dev_misc_parm.d_addrs_comm_amount += (ld_heat_dev_time / 100 ) * &
							as_hea_dev_misc_parm.d_addrs_comm_pct
			End if

	END CHOOSE
	
	If as_hea_dev_misc_parm.array_heat_dev[li_tmp].i_gross_freight_yes = 1 Then
		as_hea_dev_misc_parm.d_gross_freight_amount += ld_heat_dev
	Else
		as_hea_dev_misc_parm.d_misc_income_amount += ld_heat_dev
	End if
Next

// Calculate the misc claims for the cargo
li_max = UpperBound(as_hea_dev_misc_parm.array_misc_claims[])
For li_tmp = 1 to li_max
	ld_misc = as_hea_dev_misc_parm.array_misc_claims[li_tmp].d_claim_amount
	
	//address commission
	If as_hea_dev_misc_parm.array_misc_claims[li_tmp].i_addrs_comm_claim = 1 then
		as_hea_dev_misc_parm.d_addrs_comm_amount += (ld_misc / 100 ) * &
				as_hea_dev_misc_parm.d_addrs_comm_pct
	End if
	
	//broker commission
	If as_hea_dev_misc_parm.array_misc_claims[li_tmp].i_broker_comm_claim = 1 then				
			as_hea_dev_misc_parm.d_broker_comm_amount += (ld_misc / 100) * &
					(as_hea_dev_misc_parm.d_broker_comm_pct - as_hea_dev_misc_parm.d_broker_comm_pct_pool)
	End if
	
	//pool manager broker commission
	SELECT POOL_MANAGER_COMMISSION
	INTO :li_bro_comm_pool
	FROM CLAIM_TYPES
	WHERE CLAIM_TYPE = :as_hea_dev_misc_parm.array_misc_claims[li_tmp].s_claim_type
	;
	COMMIT;
	if li_bro_comm_pool = 1 then
			as_hea_dev_misc_parm.d_broker_comm_amount += (ld_misc / 100) * &
					as_hea_dev_misc_parm.d_broker_comm_pct_pool
	end if
			
	If as_hea_dev_misc_parm.array_misc_claims[li_tmp].i_gross_freight_yes = 1 Then
		as_hea_dev_misc_parm.d_gross_freight_amount += ld_misc
	Else
		as_hea_dev_misc_parm.d_misc_income_amount += ld_misc
	End if
Next
return(lb_tmp)
end function

private subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
   <OBJECT> 	Object Description	</OBJECT>
   <USAGE>  	Object Usage	</USAGE>
   <ALSO>   	other Objects	</ALSO>
<HISTORY> 
   Date		CR-Ref	   Author	     Comments
 06/10/10	CR2129    Jing Sun     Align the way of calculating broker commision 
 											to be the same as in the operation part
</HISTORY>    
********************************************************************/
end subroutine

on u_heat_dev_misc.create
call super::create
end on

on u_heat_dev_misc.destroy
call super::destroy
end on

