$PBExportHeader$u_vas_port_misc_exp.sru
$PBExportComments$Uo used for VAS Port and misc exp. actual, and est/act.
forward
global type u_vas_port_misc_exp from u_vas_key_data
end type
end forward

global type u_vas_port_misc_exp from u_vas_key_data
end type
global u_vas_port_misc_exp u_vas_port_misc_exp

type variables
s_vessel_voyage_list  istr_vv_list
Decimal id_act_misc_claims = 0
Decimal id_est_act_misc_claims = 0
Decimal id_est_misc_claims = 0
Decimal id_act_misc_exp = 0
Decimal id_est_act_misc_exp = 0
Decimal id_est_misc_exp = 0
Decimal id_act_port_exp = 0
Decimal  id_est_act_port_exp = 0
datetime idt_tchire_cp_date


end variables

forward prototypes
public function integer of_start_port_misc_exp ()
public function boolean of_exists_all_frt ()
public function decimal of_get_days_between (datetime adt_start, datetime adt_end)
public function integer of_port_expenses ()
public function integer of_misc_expenses ()
public function integer of_port_expenses_atobviac ()
private subroutine documentation ()
end prototypes

public function integer of_start_port_misc_exp ();Decimal ld_tc_misc_act
Datetime ldt_voyage_start, ldt_voyage_end

// Get standard data
of_get_vessel_array(istr_vv_list)

// Get port exp for instance variables
of_port_expenses()

// Get misc expenses for instance variables
of_misc_expenses()

// Set actual port and misc expenses
of_setport_expenses(5,id_act_port_exp)
of_setmisc_expenses(5,(id_act_misc_exp - id_act_misc_claims))

// Set est/act port and misc expenses
of_setport_expenses(4,id_est_act_port_exp)

IF of_exists_all_frt() THEN
	of_setmisc_expenses(4,(id_est_act_misc_exp - id_est_act_misc_claims))
ELSE
	of_setmisc_expenses(4,(id_est_act_misc_exp - id_est_misc_claims))
END IF

Return 1
end function

public function boolean of_exists_all_frt ();long ll_chart_nr,ll_claim_nr
boolean lb_found = TRUE
long ll_rows,ll_counter
Datastore lds_cp_charters

lds_cp_charters = CREATE datastore
lds_cp_charters.DataObject = "d_cp_charters" 
lds_cp_charters.SetTransObject(SQLCA)
ll_rows = lds_cp_charters.Retrieve(istr_vv_list.calc_id)

// IF there is no CP in datastore, there has been an error. Then take from actual
If NOT(ll_rows > 0) THEN 
	DESTROY lds_cp_charters ;
	Return TRUE
END IF

// IF a CP charter has no FRT in operations, then return false.
FOR ll_counter = 1 TO ll_rows
	ll_chart_nr = lds_cp_charters.GetItemNumber(ll_counter,"chart_nr")
	SELECT CLAIMS.CLAIM_NR  
   INTO :ll_claim_nr  
   FROM CLAIMS  
   WHERE ( CLAIMS.VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
         ( CLAIMS.VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
         ( CLAIMS.CHART_NR = :ll_chart_nr ) AND  
         ( CLAIMS.CLAIM_TYPE = 'FRT' )   ;
	
	if sqlca.sqlcode <> 0 then 
		lb_found = FALSE
		exit
	end if	
	commit;
NEXT

DESTROY lds_cp_charters ;

return lb_found

end function

public function decimal of_get_days_between (datetime adt_start, datetime adt_end);decimal ld_minutes

ld_minutes = (daysafter(date(adt_start),date(adt_end)) * 24 * 60)
ld_minutes = ld_minutes -       (hour( time(adt_start)) * 60) - minute(time(adt_start)) - (second(time(adt_start))/60)
ld_minutes = ld_minutes +       (hour( time(adt_end)) * 60) + minute(time(adt_end)) + (second(time(adt_end))/60)

return ld_minutes / 60 / 24
end function

public function integer of_port_expenses ();/********************************************************************
   of_port_expenses
   <DESC>	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
   	11/07/2013		CR2759		WWG004		when there are two port of calls of the same port, only the port and purpose
															are same at the same time, then delete the duplicate port.
   </HISTORY>
********************************************************************/

String ls_vp_1, ls_vp_2, ls_vp_3, ls_port_code, ls_caio_port, ls_bal, ls_port_purpose, ls_previous_purpose
String ls_port, ls_previous_port
Decimal ld_ve_1, ld_ve_2, ld_ve_3, ld_exp
Boolean lb_match, lb_bal = FALSE, lb_donew = FALSE, lb_reversible
Long ll_act_rows, ll_est_rows, ll_counter, ll_stop = 0, ll_newrow
Integer li_pcn, li_disb_finish, li_disb_count
Datetime ldt_disb_finish_dt
Datastore lds_act_port_exp, lds_est_port_exp
/* *************************************************************************************************
	THIS FUNCTION ONLY HANDLES VOYAGES ALLOCATED TO CALCULATIONS
	USING BP-DISTANCE TABLE.
	
	ALL NEVER ARE REDIRECTED TO OF_PORT_EXPENSES_ATOBVIAC
***************************************************************************************************/
if f_AtoBviaC_used(istr_vv_list.vessel_nr,istr_vv_list.voyage_nr) then
	return of_port_expenses_atobviac( )
end if
	

// Initiate and retrieve datastores
lds_act_port_exp = CREATE Datastore
lds_est_port_exp = CREATE Datastore

IF of_get_tcin_or_apm() THEN
	lds_act_port_exp.dataobject = "d_actual_port_expenses_apm"
ELSE
	lds_act_port_exp.dataobject = "d_actual_port_expenses_not_apm"
END IF

lds_est_port_exp.dataobject = "d_estimated_port_expenses"

lds_act_port_exp.SetTransObject(SQLCA)
lds_est_port_exp.SetTransObject(SQLCA)
ll_act_rows = lds_act_port_exp.Retrieve(istr_vv_list.vessel_nr,istr_vv_list.voyage_nr)
ll_est_rows = lds_est_port_exp.Retrieve(istr_vv_list.calc_id)

// Get data for first entries in datastore lds_est_port_exp. Only if any ballast vp 
// The SQLCode is -1 when there is both TO and FROM ballast, because then there are 
// more than one rows in the result set. As long as in gets the first (TO ballast)
// this is ok.
SELECT CAL_BALL.PORT_CODE,
		 CAL_BALL.CAL_BALL_VIA_POINT_1, isnull(CAL_BALL.CAL_BALL_VIA_EXPENSES_1,0) ,
		 CAL_BALL.CAL_BALL_VIA_POINT_2, isnull(CAL_BALL.CAL_BALL_VIA_EXPENSES_2,0) ,
		 CAL_BALL.CAL_BALL_VIA_POINT_3, isnull(CAL_BALL.CAL_BALL_VIA_EXPENSES_3,0)  
INTO :ls_bal,:ls_vp_1,:ld_ve_1,:ls_vp_2,:ld_ve_2,:ls_vp_3,:ld_ve_3
FROM CAL_BALL, CAL_CALC  
WHERE 	CAL_BALL.CAL_CALC_ID = :istr_vv_list.calc_id  AND
			CAL_BALL.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID AND
			CAL_CALC.CAL_CALC_BALLAST_FROM = CAL_BALL.PORT_CODE
			ORDER BY CAL_BALL.CAL_BALL_ID ASC;

// If there are any ballast viap. exp. then insert in datastore.
IF LEN(ls_bal) > 1 AND (LEN(ls_vp_1) > 1 OR  LEN(ls_vp_2) > 1 OR LEN(ls_vp_3) > 1) THEN
	IF ll_est_rows > 0 THEN
		lds_est_port_exp.InsertRow(1)
	ELSE
		lds_est_port_exp.InsertRow(0)
	END IF
	lds_est_port_exp.SetItem(1,"vp_1",ls_vp_1)
	lds_est_port_exp.SetItem(1,"vp_2",ls_vp_2)
	lds_est_port_exp.SetItem(1,"vp_3",ls_vp_3)
	lds_est_port_exp.SetItem(1,"exp_vp_1",ld_ve_1)
	lds_est_port_exp.SetItem(1,"exp_vp_2",ld_ve_2)
	lds_est_port_exp.SetItem(1,"exp_vp_3",ld_ve_3)
	lb_bal = TRUE
	ll_est_rows ++
END IF

// Check if itinery and proceed match	

lb_match = of_get_port_match()

//for ll_x = 1 to lds_est_route.rowcount( )
//	if not isnull(lds_est_route.getitemstring(ll_x, "purpose_code")) then
//		lb_port_purpose = true
//		exit
//	end if
//next

// IF no match then take largest of total sum actual, and estimated, else insert 
// estimated data in datastore actual, where formulas will calculate the correct 
// amount for port expenses.
IF NOT(lb_match) THEN
	IF of_getport_expenses(3,TRUE) > lds_act_port_exp.GetItemDecimal(1,"sum_amount_usd") THEN
		of_setport_expenses(4,of_getport_expenses(3,TRUE))
	ELSE
		of_setport_expenses(4,lds_act_port_exp.GetItemDecimal(1,"sum_amount_usd"))
	END IF
	id_est_act_port_exp = of_getport_expenses(4,TRUE)
ELSE 
	// There is match, so all est ports and viapoints exists, in same order in proceed
	// as in estimated itinerary. So datastore with est data can be directly transferred
	// to datastore with actual data.
	IF ll_est_rows > 0 THEN 
		//Check if reversible dem.
		SELECT DISTINCT CAL_CERP.CAL_CERP_REV_DEM
		INTO :lb_reversible
		FROM CAL_CERP, CAL_CARG 
		WHERE CAL_CARG.CAL_CALC_ID = :istr_vv_list.calc_id
		AND CAL_CARG .CAL_CERP_ID = CAL_CERP.CAL_CERP_ID;
	
		// IF Reversible then sum up(exp) rows with identical portcode, and
		// delete row. Note that if reversible, and 2 rows are identical, the first
		// can not have viapoints, and viapoints exp.
		if lb_reversible then
			for ll_counter = 1 TO ll_est_rows
				ls_port = lds_est_port_exp.GetItemString(ll_counter,"cal_caio_port_code")
				IF ls_previous_port = ls_port then
					if ls_previous_purpose = ls_port_purpose or ls_previous_purpose = "L" and ls_port_purpose = "D" or ls_previous_purpose = "D" and ls_port_purpose = "L" then
						ld_exp = lds_est_port_exp.GetItemDecimal(ll_counter - 1, "exp")
						ld_exp += lds_est_port_exp.GetItemDecimal(ll_counter, "exp")
						lds_est_port_exp.SetItem(ll_counter,"exp", ld_exp)
						lds_est_port_exp.DeleteRow(ll_counter - 1)
						//There are one less row in ds, and ll_counter must adjust to that
						ll_est_rows --
						ll_counter --
					end if
				end if
				
				ls_previous_port = ls_port
				ls_previous_purpose = ls_port_purpose
			next
		end if
		
		ll_est_rows = lds_est_port_exp.RowCount()
		For ll_counter = 1 TO ll_est_rows
			// ll_stop is used to manage so only those est data is transferred
			// to datastore with actual data, where there is proceedings done. 
			// Thereafter the remaining est exp are inserted as new rows in lds_act_port_exp
			IF ll_stop = ll_act_rows THEN 
				lb_donew = TRUE
			END IF
			ld_exp =lds_est_port_exp.GetItemDecimal(ll_counter,"exp")
			ld_ve_1 =lds_est_port_exp.GetItemDecimal(ll_counter,"exp_vp_1")
			ld_ve_2 =lds_est_port_exp.GetItemDecimal(ll_counter,"exp_vp_2")
			ld_ve_3 =lds_est_port_exp.GetItemDecimal(ll_counter,"exp_vp_3")
			ls_caio_port =lds_est_port_exp.GetItemString(ll_counter,"cal_caio_port_code")
			ls_vp_1 =lds_est_port_exp.GetItemString(ll_counter,"vp_1")
			ls_vp_2 =lds_est_port_exp.GetItemString(ll_counter,"vp_2")
			ls_vp_3 =lds_est_port_exp.GetItemString(ll_counter,"vp_3")
			IF ld_exp > 0 THEN
				IF lb_donew THEN
					// no more act rows, so now insert row, for calc est exp
					ll_newrow = lds_act_port_exp.InsertRow(0)
					lds_act_port_exp.SetItem(ll_newrow,"proceed_port_code",ls_caio_port)
					lds_act_port_exp.SetItem(ll_newrow,"calc_port_expenses",ld_exp)
				ELSE
					lds_act_port_exp.SetItem(ll_stop + 1,"calc_port_expenses",ld_exp)
				END IF	
			END IF
			// If there is ballast viapoints, the first rows "exp" is empty, because
			// ballast from is not in proceed, therefore ll_stop must be neutral
			// so ll_stop -- and ll_stop ++ is equal.
			IF ll_counter = 1 AND lb_bal THEN ll_stop --
			ll_stop ++
			IF ll_stop = ll_act_rows THEN 
				lb_donew = TRUE
			END IF
			IF LEN(ls_vp_1) > 1 THEN
				IF lb_donew THEN
					// no more act rows, so now insert row, for calc est exp
					ll_newrow = lds_act_port_exp.InsertRow(0)
					lds_act_port_exp.SetItem(ll_newrow,"proceed_port_code",ls_vp_1)
					lds_act_port_exp.SetItem(ll_newrow,"calc_port_expenses",ld_ve_1)
				ELSE
					lds_act_port_exp.SetItem(ll_stop + 1,"calc_port_expenses",ld_ve_1)
				END IF	
			END IF
			// If there is viapoint ll_stop must increment
			IF LEN(ls_vp_1) > 1 THEN ll_stop ++
			IF ll_stop = ll_act_rows THEN 
				lb_donew = TRUE
			END IF
			IF LEN(ls_vp_2) > 1 THEN
				IF lb_donew THEN
					// no more act rows, so now insert row, for calc est exp
					ll_newrow = lds_act_port_exp.InsertRow(0)
					lds_act_port_exp.SetItem(ll_newrow,"proceed_port_code",ls_vp_2)
					lds_act_port_exp.SetItem(ll_newrow,"calc_port_expenses",ld_ve_2)
				ELSE
					lds_act_port_exp.SetItem(ll_stop + 1,"calc_port_expenses",ld_ve_2)
				END IF	
			END IF
			IF LEN(ls_vp_2) > 1 THEN ll_stop ++
			IF ll_stop = ll_act_rows THEN 
				lb_donew = TRUE
			END IF	
			IF LEN(ls_vp_3) > 1 THEN
				IF lb_donew THEN
					// no more act rows, so now insert row, for calc est exp
					ll_newrow = lds_act_port_exp.InsertRow(0)
					lds_act_port_exp.SetItem(ll_newrow,"proceed_port_code",ls_vp_3)
					lds_act_port_exp.SetItem(ll_newrow,"calc_port_expenses",ld_ve_3)
				ELSE
					lds_act_port_exp.SetItem(ll_stop + 1,"calc_port_expenses",ld_ve_3)
				END IF	
			END IF
			IF LEN(ls_vp_3) > 1 THEN ll_stop ++
			IF ll_stop = ll_act_rows THEN 
				lb_donew = TRUE
			END IF	
		NEXT
	END IF
	// Now set flag for disb.port finished in datastore, and then get result for est/act.
	// The new inserted rows can not be finished, beacuse there are no act.
	IF ll_act_rows > 0 THEN
		FOR ll_counter = 1 TO ll_act_rows
			ls_port_code = lds_act_port_exp.GetItemString(ll_counter,"proceed_port_code")
			li_pcn = lds_act_port_exp.GetItemNumber(ll_counter,"proceed_pcn")
			SELECT Count(DISB_FINISH_DT)  
    		INTO :li_disb_count
    		FROM DISBURSEMENTS  
   		WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
         		( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
         		( PORT_CODE = :ls_port_code ) AND  
         	   ( PCN = :li_pcn ) ;

			IF li_disb_count > 0 THEN
				SELECT Distinct DISB_FINISH_DT  
				INTO :ldt_disb_finish_dt  
				FROM DISBURSEMENTS  
				WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
						( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
						( PORT_CODE = :ls_port_code ) AND  
						( PCN = :li_pcn ) AND
						( DISB_FINISH_DT IS NULL) ;
				
				IF SQLCA.SQLCode = 100 THEN 
					li_disb_finish = 1 
				ELSE
					SetNull(li_disb_finish)
				END IF
			ELSE
				SetNull(li_disb_finish)
			END IF
			lds_act_port_exp.SetItem(ll_counter,"disb_finished",li_disb_finish)
		NEXT
	END IF
END IF

id_act_port_exp = lds_act_port_exp.GetItemDecimal(1,"sum_amount_usd")

IF lb_match THEN  
  id_est_act_port_exp = lds_act_port_exp.GetItemDecimal(1,"sum_amount")
END IF

// If this is calc memo, then save port exp datastore in shared datastore
// so the data is available for the set calc memo report function
IF of_get_result_type() = 6 or of_get_result_type() = 11 THEN
	of_init_calcmemo_port_exp(lds_act_port_exp)
END IF

DESTROY lds_act_port_exp ;
DESTROY lds_est_port_exp ;

Return 1
end function

public function integer of_misc_expenses ();/********************************************************************
   of_misc_expenses
   <DESC>	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
   	11/07/2013		CR2759		WWG004		when there are two port of calls of the same port, only the port and purpose
															are same at the same time, then delete the duplicate port.
   </HISTORY>
********************************************************************/

Datastore lds_misc_exp, lds_est_misc_exp, lds_est_route
Long ll_act_misc_rows, ll_counter, ll_est_misc_rows
Long ll_est_counter, ll_rest_counter, ll_newrow, ll_x
double ld_trans_r_amount, ld_trans_amount
Decimal ld_est_misc_income, ld_bunker_loss
Integer li_charter, li_claim, li_pcn, li_disb_finish, li_disb_count
Boolean lb_match
String ls_port_code, ls_port, ls_previous_port, ls_port_purpose, ls_previous_purpose
Datetime ldt_disb_finish_dt  
Decimal ld_exp
boolean lb_port_purpose

lds_est_misc_exp = CREATE Datastore
lds_est_misc_exp.dataobject = "d_estimated_misc_expenses"
lds_est_misc_exp.SetTransObject(SQLCA)
ll_est_misc_rows = lds_est_misc_exp.Retrieve(istr_vv_list.calc_id)

lds_misc_exp = CREATE Datastore
lds_misc_exp.dataobject = "d_actual_misc_expenses_apm"
lds_misc_exp.SetTransObject(SQLCA)
ll_act_misc_rows = lds_misc_exp.Retrieve(istr_vv_list.vessel_nr,istr_vv_list.voyage_nr)

lds_est_route = CREATE Datastore
lds_est_route.dataobject = "d_sq_tb_estimated_route_expenses"
lds_est_route.settransobject( sqlca)
lds_est_route.Retrieve(istr_vv_list.calc_id)

////////// Misc exp    /////////////

lb_match = of_get_port_match()
	
// IF no match then take largest of total sum actual exp, and estimated exp, else insert 
// estimated data in datastore actual, where formulas will calculate the correct 
// amount for misc expenses.
id_act_misc_exp = lds_misc_exp.GetItemDecimal(1,"sum_amount_usd")
IF NOT(lb_match) THEN
	IF NOT(ll_est_misc_rows > 0) THEN
		id_est_act_misc_exp = id_act_misc_exp
	ELSEIF  lds_est_misc_exp.GetItemDecimal(1,"sum_exp") > id_act_misc_exp THEN
		id_est_act_misc_exp = lds_est_misc_exp.GetItemDecimal(1,"sum_exp")
	ELSE
		id_est_act_misc_exp = id_act_misc_exp
	END IF
ELSE 
	for ll_x = 1 to lds_est_route.rowcount( )
		if not isnull(lds_est_route.getitemstring(ll_x, "purpose_code")) then
			lb_port_purpose = true
			exit
		end if
	next
	IF ll_est_misc_rows > 0 THEN
		// If there is 2 cargos on a calulation with the same load and discharge port then add the total misc exp. and delete one row
	
		for ll_counter = 1 to ll_est_misc_rows
			ls_port = lds_est_misc_exp.GetItemString(ll_counter,"cal_caio_port_code")
			ls_port_purpose = lds_est_misc_exp.GetItemString(ll_counter, "cal_caio_purpose_code")
			if ls_previous_port = ls_port then
				if ls_previous_purpose = ls_port_purpose or ls_previous_purpose = "L" and ls_port_purpose = "D" or ls_previous_purpose = "D" and ls_port_purpose = "L" then
					ld_exp = lds_est_misc_exp.GetItemDecimal(ll_counter - 1, "miscexp")
					ld_exp += lds_est_misc_exp.GetItemDecimal(ll_counter, "miscexp")
					lds_est_misc_exp.SetItem(ll_counter,"miscexp", ld_exp)
					lds_est_misc_exp.DeleteRow(ll_counter - 1)
					//There are one less row in ds, and ll_counter must adjust to that
					ll_est_misc_rows --
					ll_counter --
				end if
			end if
		
			ls_previous_port = ls_port
			ls_previous_purpose = ls_port_purpose
		next
		
		//CR2246, set misc. expenses for lds_misc_exp, which is used for EST/ACT figure
		For ll_est_counter = 1 TO ll_est_misc_rows
			For ll_counter = 1 TO ll_act_misc_rows
				IF lds_misc_exp.getitemstring(ll_counter, "proceed_port_code") = lds_est_misc_exp.getitemstring(ll_est_counter, "cal_caio_port_code") and lds_misc_exp.getitemnumber(ll_counter, "misc_flag") = 0 THEN
					lds_misc_exp.SetItem(ll_counter,"calc_misc_exp", &
						lds_est_misc_exp.GetItemDecimal(ll_est_counter,"miscexp"))
						lds_misc_exp.setitem(ll_counter, "misc_flag", 1)
						EXIT
				END IF
			NEXT
		NEXT
	END IF
	
	// Now set flag for disb.port finished in datastore, and then get result for est/act.
	IF ll_act_misc_rows > 0 THEN
		FOR ll_counter = 1 TO ll_act_misc_rows
			ls_port_code = lds_misc_exp.GetItemString(ll_counter,"proceed_port_code")
			li_pcn = lds_misc_exp.GetItemNumber(ll_counter,"proceed_pcn")
			SELECT Count(DISB_FINISH_DT)  
    		INTO :li_disb_count
    		FROM DISBURSEMENTS  
   		WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
         		( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
         		( PORT_CODE = :ls_port_code ) AND  
         	   ( PCN = :li_pcn ) ;

			IF li_disb_count > 0 THEN
				SELECT Distinct DISB_FINISH_DT  
				INTO :ldt_disb_finish_dt  
				FROM DISBURSEMENTS  
				WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
						( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
						( PORT_CODE = :ls_port_code ) AND  
						( PCN = :li_pcn ) AND
						( DISB_FINISH_DT IS NULL) ;
				
				IF SQLCA.SQLCode = 100 THEN 
					li_disb_finish= 1
				ELSE
					SetNull(li_disb_finish)
				END IF
			ELSE
				SetNull(li_disb_finish)
			END IF
			lds_misc_exp.SetItem(ll_counter,"disb_finished",li_disb_finish)
		NEXT
	END IF
END IF

IF lb_match THEN
 id_est_act_misc_exp = lds_misc_exp.GetItemDecimal(1,"sum_amount") // Her setter den det til 20000
END IF


/* Bunker Loss / Profit only add Profit = value > 0 */
SELECT sum(BUNKER_POSTED_LOSSPROFIT) 
	INTO :ld_bunker_loss  
	FROM VOYAGES  
	WHERE  VOYAGES.VESSEL_NR = :istr_vv_list.vessel_nr  AND  
		VOYAGES.VOYAGE_NR = :istr_vv_list.voyage_nr   ;

if isNull(ld_bunker_loss) then ld_bunker_loss = 0
if ld_bunker_loss < 0 then 
	ld_bunker_loss = abs(ld_bunker_loss)
else
	ld_bunker_loss = 0   //will in this case be added to demurrage as income
end if

id_act_misc_exp += ld_bunker_loss

// No est so est_act = act
id_est_act_misc_exp += ld_bunker_loss

DESTROY lds_est_misc_exp ;
DESTROY lds_misc_exp ;

Return 1
end function

public function integer of_port_expenses_atobviac ();/********************************************************************
   of_port_expenses_atobviac
   <DESC>	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
   	11/07/2013		CR2759		WWG004		when there are two port of calls of the same port, only the port and purpose
															are same at the same time, then delete the duplicate port.
   </HISTORY>
********************************************************************/

/* *************************************************************************************************
	THIS FUNCTION ONLY HANDLES VOYAGES ALLOCATED TO CALCULATIONS
	USING AtoBviaC-DISTANCE TABLE.
	(is called from of_port_expenses( ))	
***************************************************************************************************/
String ls_port_code,  ls_ballast_from, ls_port, ls_previous_port, ls_first_port, ls_port_purpose, ls_previous_purpose
Decimal ld_exp
Boolean lb_match, lb_reversible
Long ll_act_rows, ll_est_rows, ll_route_rows, ll_counter, ll_newrow
Integer li_disb_finish, li_pcn, li_disb_count
Datetime ldt_disb_finish_dt
Datastore lds_act_port_exp, lds_est_port_exp, lds_est_route
long ll_route_row, ll_est_row, ll_insert_row, ll_act_row, ll_x
boolean lb_port_purpose
integer	li_voyage_type, li_count

SELECT VOYAGE_TYPE
	INTO :li_voyage_type 
	FROM VOYAGES
	WHERE VESSEL_NR = :istr_vv_list.vessel_nr
	AND VOYAGE_NR = :istr_vv_list.voyage_nr;

// Initiate and retrieve datastores
lds_act_port_exp 	= CREATE Datastore
lds_est_port_exp 	= CREATE Datastore
lds_est_route 		= CREATE Datastore

IF of_get_tcin_or_apm() THEN
	lds_act_port_exp.dataobject = "d_actual_port_expenses_apm"
ELSE
	lds_act_port_exp.dataobject = "d_actual_port_expenses_not_apm"
END IF

lds_est_port_exp.dataobject = "d_estimated_port_expenses"
lds_est_route.dataobject = "d_sq_tb_estimated_route_expenses"

lds_act_port_exp.SetTransObject(SQLCA)
lds_est_port_exp.SetTransObject(SQLCA)
lds_est_route.SetTransObject(SQLCA)
ll_act_rows = lds_act_port_exp.Retrieve(istr_vv_list.vessel_nr,istr_vv_list.voyage_nr)

ll_est_rows = lds_est_port_exp.Retrieve(istr_vv_list.calc_id)

ll_route_rows = lds_est_route.Retrieve(istr_vv_list.calc_id)

// husk fjern ballast ports, men kun hvis første havn ikke er den samme
SELECT CAL_CALC.CAL_CALC_BALLAST_FROM, CAL_CAIO.PORT_CODE
	INTO :ls_ballast_from, :ls_first_port
	FROM CAL_CALC, CAL_CARG, CAL_CAIO
	WHERE CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID
	AND CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID
	AND CAL_CALC.CAL_CALC_ID = :istr_vv_list.calc_id
	AND CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER = 1;

// Check if itinery and proceed match	
lb_match = of_get_port_match()

// IF no match then take largest of total sum actual, and estimated, else insert 
// estimated data in datastore actual, where formulas will calculate the correct 
// amount for port expenses.
if not (lb_match) then
	if of_getport_expenses(3,TRUE) > lds_act_port_exp.GetItemDecimal(1,"sum_amount_usd") then
		of_setport_expenses(4,of_getport_expenses(3,TRUE))
	else
		of_setport_expenses(4,lds_act_port_exp.GetItemDecimal(1,"sum_amount_usd"))
	end if
	id_est_act_port_exp = of_getport_expenses(4,TRUE)
	return 1
end if

for ll_x = 1 to lds_est_route.rowcount( )
	if not isnull(lds_est_route.getitemstring(ll_x, "purpose_code")) then
		lb_port_purpose = true
		exit
	end if
next
if not isNull(ls_ballast_from) and ls_ballast_from <> "" then
	if lb_port_purpose then
		lds_est_route.deleterow(1)
		ll_route_rows --
		li_count ++
	else
		if ls_first_port <> ls_ballast_from then
			lds_est_route.deleterow(1)
			ll_route_rows --
			li_count ++
		end if
	end if
end if
//only compare with purporse for single voyage
if li_voyage_type <> 1 then
	lb_port_purpose = false
end if

// There is match, so all est ports and viapoints exists, in same order in proceed
// as in estimated itinerary. So datastore with est data can be directly transferred
// to datastore with actual data.

IF ll_est_rows > 0 THEN 
	//Check if reversible dem.
	SELECT DISTINCT CAL_CERP.CAL_CERP_REV_DEM
		INTO :lb_reversible
		FROM CAL_CERP, CAL_CARG 
		WHERE CAL_CARG.CAL_CALC_ID = :istr_vv_list.calc_id
		AND CAL_CARG .CAL_CERP_ID = CAL_CERP.CAL_CERP_ID;
	COMMIT;
	// IF Reversible then sum up(exp) rows with identical portcode, and
	// delete row. Note that if reversible, and 2 rows are identical, the first
	// can not have viapoints, and viapoints exp.
	if lb_reversible then
		for ll_counter = 1 to ll_est_rows
			ls_port = lds_est_port_exp.GetItemString(ll_counter,"cal_caio_port_code")
			ls_port_purpose = lds_est_port_exp.GetItemString(ll_counter,"cal_caio_purpose_code")
			
			if ls_previous_port = ls_port then
				if ls_previous_purpose = ls_port_purpose or ls_previous_purpose = "L" and  ls_port_purpose = "D"  or ls_previous_purpose = "D" and ls_port_purpose = "L" then
					ld_exp = lds_est_port_exp.GetItemDecimal(ll_counter - 1, "exp")
					ld_exp += lds_est_port_exp.GetItemDecimal(ll_counter, "exp")
					lds_est_port_exp.SetItem(ll_counter, "exp", ld_exp)
					lds_est_port_exp.DeleteRow(ll_counter - 1)
					//There are one less row in ds, and ll_counter must adjust to that
					ll_est_rows --
					ll_counter --
				end if
			end if
			
			ls_previous_port = ls_port
			ls_previous_purpose = ls_port_purpose
		next
	end if
	
	/* Add routing points to estimated port */
	ll_route_row=1
	ll_est_row=1
	do while ll_route_row <= ll_route_rows
		if ll_est_row > lds_est_port_exp.rowCount() then
			ll_insert_row = lds_est_port_exp.insertRow(0)
			lds_est_port_exp.setItem(ll_insert_row, "cal_caio_port_code", lds_est_route.getItemString(ll_route_row, "port_code"))
//			lds_est_port_exp.setItem(ll_insert_row, "exp", lds_est_route.getItemNumber(ll_route_row, "rp_expenses"))
			lds_est_port_exp.setItem(ll_insert_row, "exp", 0 )
			lds_est_port_exp.setItem(ll_insert_row, "exp_vp_1",0)  // for calculation to be right. using same dw as BP calculations
			lds_est_port_exp.setItem(ll_insert_row, "exp_vp_2",0)
			lds_est_port_exp.setItem(ll_insert_row, "exp_vp_3",0)
			ll_route_row ++
			ll_est_row ++
		else
			if lds_est_port_exp.getItemString(ll_est_row, "cal_caio_port_code") <> lds_est_route.getItemString(ll_route_row, "port_code") then
				ll_insert_row = lds_est_port_exp.insertRow(ll_est_row)
				lds_est_port_exp.setItem(ll_insert_row, "cal_caio_port_code", lds_est_route.getItemString(ll_route_row, "port_code"))
				lds_est_port_exp.setItem(ll_insert_row, "exp", lds_est_route.getItemNumber(ll_route_row, "rp_expenses"))
				lds_est_port_exp.setItem(ll_insert_row, "exp_vp_1",0)  // for calculation to be right. using same dw as BP calculations
				lds_est_port_exp.setItem(ll_insert_row, "exp_vp_2",0)
				lds_est_port_exp.setItem(ll_insert_row, "exp_vp_3",0)
			else
				ll_route_row ++
				ll_est_row ++
			end if
		end if
	loop
	/* Set estimated expenses in actual dw and add ports not already entered in proceeding */
	ll_act_row=1
	ll_est_rows = lds_est_route.rowCount()
	ll_est_row=1
	do while ll_est_row <= ll_est_rows
		if ll_act_row > lds_act_port_exp.rowCount() then
			ll_insert_row = lds_act_port_exp.insertRow(0)
			lds_act_port_exp.setItem(ll_insert_row, "proceed_port_code", lds_est_port_exp.getItemString(ll_est_row, "cal_caio_port_code"))
			lds_act_port_exp.setItem(ll_insert_row, "calc_port_expenses", lds_est_port_exp.getItemNumber(ll_est_row, "exp"))
			ll_act_row ++
			ll_est_row ++
		else
			if lds_est_port_exp.getItemString(ll_est_row, "cal_caio_port_code") <> lds_act_port_exp.getItemString(ll_act_row, "proceed_port_code") then
				ll_insert_row = lds_act_port_exp.insertRow(ll_act_row)
				lds_act_port_exp.setItem(ll_insert_row, "proceed_port_code", lds_est_port_exp.getItemString(ll_est_row, "cal_caio_port_code"))
				lds_act_port_exp.setItem(ll_insert_row, "calc_port_expenses", lds_est_port_exp.getItemNumber(ll_est_row, "exp"))
			else
				lds_act_port_exp.setItem(ll_act_row, "calc_port_expenses", lds_est_port_exp.getItemNumber(ll_est_row, "exp"))
				ll_act_row ++
				ll_est_row ++
			end if
		end if
	loop
END IF

// Now set flag for disb.port finished in datastore, and then get result for est/act.
// The new inserted rows can not be finished, beacuse there are no act.
IF ll_act_rows > 0 THEN
	FOR ll_counter = 1 TO ll_act_rows
		ls_port_code = lds_act_port_exp.GetItemString(ll_counter,"proceed_port_code")
		li_pcn = lds_act_port_exp.GetItemNumber(ll_counter,"proceed_pcn")
		SELECT Count(DISB_FINISH_DT)  
		INTO :li_disb_count
		FROM DISBURSEMENTS  
		WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
				( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
				( PORT_CODE = :ls_port_code ) AND  
				( PCN = :li_pcn ) ;

		IF li_disb_count > 0 THEN
			SELECT Distinct DISB_FINISH_DT  
			INTO :ldt_disb_finish_dt  
			FROM DISBURSEMENTS  
			WHERE ( VESSEL_NR = :istr_vv_list.vessel_nr ) AND  
					( VOYAGE_NR = :istr_vv_list.voyage_nr ) AND  
					( PORT_CODE = :ls_port_code ) AND  
					( PCN = :li_pcn ) AND
					( DISB_FINISH_DT IS NULL) ;
			
			IF SQLCA.SQLCode = 100 THEN 
				li_disb_finish = 1 
			ELSE
				SetNull(li_disb_finish)
			END IF
		ELSE
			SetNull(li_disb_finish)
		END IF
		lds_act_port_exp.SetItem(ll_counter,"disb_finished",li_disb_finish)
	NEXT
END IF

if lds_act_port_exp.rowCount() > 0 then
	id_act_port_exp = lds_act_port_exp.GetItemDecimal(1,"sum_amount_usd")
else
	id_act_port_exp = 0
end if

IF lb_match THEN  
  id_est_act_port_exp = lds_act_port_exp.GetItemDecimal(1,"sum_amount")
END IF

// If this is calc memo, then save port exp datastore in shared datastore
// so the data is available for the set calc memo report function
IF of_get_result_type() = 6 OR of_get_result_type() = 11 THEN
	of_init_calcmemo_port_exp(lds_act_port_exp)
END IF

DESTROY lds_act_port_exp ;
DESTROY lds_est_port_exp ;

Return 1
end function

private subroutine documentation ();/********************************************************************
   ObjectName: u_vas_port_misc_exp
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    Author        Comments
  16/12/10	CR2226  JSU042       Ballst port is the same as first part
  07/01/11   CR2246  JSU042       error fix
  02/02/11   CR????	AGL027		Accommodated VAS report 11 for Accruals.
  11/07/13	CR2759	WWG004		when there are two port of calls of the same port, only the port and purpose
											are same at the same time, then delete the duplicate port.
  25/03/15	CR3879	CCY018		Fix a bug.
********************************************************************/
end subroutine

on u_vas_port_misc_exp.create
call super::create
end on

on u_vas_port_misc_exp.destroy
call super::destroy
end on

