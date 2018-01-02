$PBExportHeader$w_proceeding_list.srw
$PBExportComments$This window lists all proceedings for a given vessel.
forward
global type w_proceeding_list from w_vessel_basewindow
end type
type gb_voyagedetails from groupbox within w_proceeding_list
end type
type dw_proceeding_list from u_datagrid within w_proceeding_list
end type
type cb_new_proceeding from commandbutton within w_proceeding_list
end type
type cb_update from commandbutton within w_proceeding_list
end type
type cb_delete from commandbutton within w_proceeding_list
end type
type cb_1 from commandbutton within w_proceeding_list
end type
type cb_cancel from commandbutton within w_proceeding_list
end type
type dw_proceeding from mt_u_datawindow within w_proceeding_list
end type
type rb_all_voyages from radiobutton within w_proceeding_list
end type
type rb_only_this_year from radiobutton within w_proceeding_list
end type
type gb_1 from groupbox within w_proceeding_list
end type
type st_calc from statictext within w_proceeding_list
end type
type st_voyage_type from statictext within w_proceeding_list
end type
type cb_portslists from commandbutton within w_proceeding_list
end type
type cb_refresh from commandbutton within w_proceeding_list
end type
type cb_allocate from commandbutton within w_proceeding_list
end type
type st_topbar_background from u_topbar_background within w_proceeding_list
end type
type cb_options from u_cb_option within w_proceeding_list
end type
end forward

global type w_proceeding_list from w_vessel_basewindow
integer x = 0
integer y = 0
integer width = 3497
integer height = 2588
string title = "Proceeding"
boolean maxbox = false
string icon = "images\PROCEED.ICO"
boolean ib_setdefaultbackgroundcolor = true
event ue_update_cancel pbm_custom33
event ue_set_cancel_1 pbm_custom17
event ue_set_cancel_0 pbm_custom18
event ue_set_off_subs pbm_custom09
gb_voyagedetails gb_voyagedetails
dw_proceeding_list dw_proceeding_list
cb_new_proceeding cb_new_proceeding
cb_update cb_update
cb_delete cb_delete
cb_1 cb_1
cb_cancel cb_cancel
dw_proceeding dw_proceeding
rb_all_voyages rb_all_voyages
rb_only_this_year rb_only_this_year
gb_1 gb_1
st_calc st_calc
st_voyage_type st_voyage_type
cb_portslists cb_portslists
cb_refresh cb_refresh
cb_allocate cb_allocate
st_topbar_background st_topbar_background
cb_options cb_options
end type
global w_proceeding_list w_proceeding_list

type variables
datawindowchild dwc, idwc_portcode, idwc_proctext
s_viap_tracking istr_viap
string is_year 
n_autoschedule inv_autoschedule

CONSTANT STRING is_MODIFYVOYAGETYPE     = "Modify Voyage Type"
CONSTANT STRING is_MODIFYVOYAGENUMBER   = "Modify Voyage Number"
CONSTANT STRING is_DELETECOMPLETEVOYAGE = "Delete Complete Voyage"
CONSTANT STRING is_UPDATEPORTS          = "Update Ports"

long	il_modifyvoyagetypenum
long	il_modifyvoyagenumbernum
long	il_deletevoyagenum
long	il_updateportsnum

long		il_headerheight, il_detailheight
long     il_draggedfrom, il_draggedto
long	il_contypeid[]
end variables

forward prototypes
public subroutine wf_set_calc_and_voyage_type (long fl_row)
public function integer wf_set_allocation_button ()
public subroutine wf_set_input_dt (long calcid, integer vessel, string voyage)
public subroutine wf_set_viap_pcn (integer ai_vessel, string ai_voyage)
public function long wf_get_vv_estimated_port_exp_port_array (integer ai_vessel_nr, string as_voyage_nr, ref string aa_port_code[], ref decimal aa_port_exp[])
public function integer wf_check_at_sea (integer ai_vessel_nr, string as_voyage_nr)
private function integer wf_cancelproceeding (long al_row)
public subroutine documentation ()
public function long wf_get_vv_actual_proc_port_array (integer ai_vessel_nr, string as_voyage_nr, ref string aa_port_code[])
public function integer wf_set_voyage_on_subs (long al_row, integer ai_on_subs)
public function integer wf_proceedinglist_update ()
public subroutine wf_sendmaropsemail (integer ai_vesselnr, string as_port)
private function integer __refresh_poc ()
public subroutine wf_modify_voyagetype ()
public subroutine wf_modify_voyagenumber ()
public subroutine wf_delete_voyagenumber ()
public subroutine wf_updateports ()
public function integer wf_atobviac_proceeding (integer ai_vessel, string as_voyage, boolean ab_update, boolean ab_update_order)
private function integer __checkdragged (long al_draggedfrom, long al_draggedto, long al_maxrow)
public function integer wf_get_max_portorder (string as_voyagenr)
private function datetime wf_unique_procdate ()
public function long wf_get_estimated_route (long al_calc_id, ref string as_port_code[])
public subroutine wf_get_contypeid (string as_column)
public subroutine wf_speed_changed (datawindow adw_proceed, integer ai_row, long al_contypeid)
public function integer __refresh_order (string as_voyage_nr)
public subroutine wf_filter_speed (mt_u_datawindow adw_proceeding)
public function integer wf_check_speed (long al_cal_cons_id)
end prototypes

event ue_update_cancel;
IF dw_proceeding_list.Update() = 1 THEN
	commit;
ELSE
	rollback;
END IF
end event

event ue_set_cancel_1;dw_proceeding_list.SetItem(dw_proceeding_list.GetRow(),"cancel",1)

end event

event ue_set_cancel_0;dw_proceeding_list.SetItem(dw_proceeding_list.GetRow(),"cancel",0)


end event

event ue_set_off_subs;dw_proceeding_list.SetItem(dw_proceeding_list.GetRow(), "voyage_on_subs", 0)
end event

public subroutine wf_set_calc_and_voyage_type (long fl_row);int li_vessel_nr, li_voyage_type, li_voyage_finished
string ls_voyage_nr, ls_calc_desc

if fl_row <= 0 or dw_proceeding_list.rowcount() < fl_row then return

li_vessel_nr = dw_proceeding_list.getitemnumber(fl_row,"vessel_nr")
ls_voyage_nr = dw_proceeding_list.getitemstring(fl_row,"voyage_nr")
SELECT VOYAGES.VOYAGE_TYPE,CAL_CALC.CAL_CALC_DESCRIPTION, VOYAGES.VOYAGE_FINISHED
INTO :li_voyage_type, :ls_calc_desc, :li_voyage_finished
FROM CAL_CALC,            VOYAGES  
WHERE 	( CAL_CALC.CAL_CALC_ID =* VOYAGES.CAL_CALC_ID ) and  
        		( ( VOYAGES.VESSEL_NR = :li_vessel_nr ) AND  
        		( VOYAGES.VOYAGE_NR = :ls_voyage_nr ) )   ;
commit;
if isnull(ls_calc_desc) then 
	st_calc.text = "Calc: No Calculation"
else 
	st_calc.text = "Calc: " + ls_calc_desc
end if

//CR2413 Begin added by ZSW001 on 10/05/2012
if isnull(ls_calc_desc) or li_voyage_finished = 1 then
	cb_options.of_modifymenuitem(il_updateportsnum, false)
else
	cb_options.of_modifymenuitem(il_updateportsnum, true)
end if
//CR2413 End added by ZSW001 on 10/05/2012

CHOOSE CASE li_voyage_type
	CASE 1
		st_voyage_type.text = "Voyage Type: Single Voyage"
	CASE 2
		st_voyage_type.text = "Voyage Type: Time Charter Out"
	CASE 3
		st_voyage_type.text = "Voyage Type: Position Voyage"
	CASE 4
		st_voyage_type.text = "Voyage Type: Off Service/Dock"
	CASE 5
		st_voyage_type.text = "Voyage Type: Idle Days"
	CASE 6
		st_voyage_type.text = "Voyage Type: Laid Up"
	CASE 7
		st_voyage_type.text = "Voyage Type: Idle Voyage"
	CASE ELSE
		st_voyage_type.text = "Voyage Type: "

END CHOOSE
end subroutine

public function integer wf_set_allocation_button ();/* Declare local Variables */
string ls_voyage_nr
long ll_cal_calc_id

/* Get voyage number */
ls_voyage_nr = dw_proceeding_list.getitemstring(dw_proceeding_list.getrow(),"voyage_nr")

select CAL_CALC_ID
into :ll_cal_calc_id
from VOYAGES
where 	VESSEL_NR = :ii_vessel_nr and
		VOYAGE_NR = :ls_voyage_nr   ;
commit;
if isnull( ll_cal_calc_id) then
	cb_allocate.text = "&Allocate"
else
	cb_allocate.text = "De-&Allocate"
end if

/* return OK */
return 1
end function

public subroutine wf_set_input_dt (long calcid, integer vessel, string voyage);String ls_port_code
Boolean lb_boolean
transaction sqlports
u_calc_nvo uo_calc

sqlports = CREATE transaction
uo_global.defaulttransactionobject(sqlports)
CONNECT USING sqlports;

uo_calc = CREATE u_calc_nvo

DECLARE port_cur CURSOR FOR  
    SELECT DISTINCT PROCEED.PORT_CODE  
    FROM PROCEED,  VOYAGES  
    WHERE ( VOYAGES.VESSEL_NR = :vessel) and
		( VOYAGES.VOYAGE_NR = :voyage)  and
		( VOYAGES.VESSEL_NR = PROCEED.VESSEL_NR ) and  
         	( VOYAGES.VOYAGE_NR = PROCEED.VOYAGE_NR ) and 
		(PROCEED.PCN > 0)
    USING sqlports;

OPEN port_cur;

FETCH port_cur INTO :ls_port_code;

DO WHILE sqlports.SQLCode = 0
	lb_boolean = uo_calc.uf_is_port_on_calc(calcid,ls_port_code)
	IF lb_boolean THEN 
		UPDATE PROCEED  
     		SET INPUT_DT = null  
	  		 WHERE ( PROCEED.VESSEL_NR = :vessel ) AND  
   			     		( PROCEED.VOYAGE_NR = :voyage ) AND  
	         			( PROCEED.PORT_CODE = :ls_port_code ) AND
						(PROCEED.CANCEL = 0)   ;
		IF SQLCA.SQLCode = 0 THEN
			COMMIT;
		ELSE
			ROLLBACK;
			Messagebox("Error","Error updating port " + ls_port_code  + " to cargo allowed. Please contact your system administrator.")
		END IF
	END IF

	FETCH port_cur INTO :ls_port_code;
LOOP
CLOSE port_cur;

DISCONNECT USING sqlports;
DESTROY sqlports;
DESTROY uo_calc;
end subroutine

public subroutine wf_set_viap_pcn (integer ai_vessel, string ai_voyage);Integer li_counter = 1, li_stop, li_count,li_upper,li_pcn = 1
String ls_port
DateTime ld_pdt
Transaction psql

uo_global.defaulttransactionobject(psql)
Connect using psql;

li_upper = UpperBound(istr_viap.port)

// Find stop point in array. Stop is viap = 9.
FOR li_count = 1 TO li_upper
	IF istr_viap.viap[li_count] = 9 THEN EXIT
NEXT
li_stop = li_count - 1

 DECLARE proc_cur CURSOR FOR  
 SELECT PROCEED.PORT_CODE, PROCEED.PROC_DATE  
 FROM PROCEED  
 WHERE ( PROCEED.VESSEL_NR = :ai_vessel ) AND  
              ( PROCEED.VOYAGE_NR = :ai_voyage )  AND 
	      (PROCEED.CANCEL = 0)
 ORDER BY PROCEED.PROC_DATE ASC 
USING psql;

OPEN proc_cur;

FETCH proc_cur INTO :ls_port, :ld_pdt;

DO While psql.SQLCode = 0 AND li_counter <= li_stop
	If istr_viap.viap[li_counter] = 1 THEN
		li_pcn --
		UPDATE PROCEED
		SET PCN = :li_pcn, INPUT_DT = GetDate()
		WHERE VESSEL_NR = :ai_vessel AND VOYAGE_NR = :ai_voyage AND
			     PORT_CODE = :ls_port AND PROC_DATE = :ld_pdt; 
		If sqlca.sqlcode = 0 THEN
			Commit;
		Else
			Rollback;
		End if
	End if
	li_counter ++ 
FETCH proc_cur INTO :ls_port, :ld_pdt;
LOOP

CLOSE proc_cur;

Disconnect using psql;
Destroy psql;



end subroutine

public function long wf_get_vv_estimated_port_exp_port_array (integer ai_vessel_nr, string as_voyage_nr, ref string aa_port_code[], ref decimal aa_port_exp[]);//************************************************************************************
// Author    : Bettina Olsen
// Date       :24-03-97
// Description :	Array of estimated port expenses per port
// Arguments : {description/none}
// Returns   : {description/none}  
// Variables : {important variables - usually only used in Open-event scriptcode}
// Other : {other comments}
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//24-03-97		5.0			BHO		INITIAL VERSION
//16-09-98    6.0			LN			Copied from VAS to w_proceeding_list
//************************************************************************************/
long ll_counter = 0, ll_calc_id, ll_ports, ll_empty[]
int i
string ls_port_code, ls_vp_1,ls_vp_2,ls_vp_3
decimal{2} ld_port_expenses, ld_ve_1,ld_ve_2,ld_ve_3
transaction lt_local_transaction

/* Get ballast from via points, but not the actual from ballast and put in start of array */
SELECT VOYAGES.CAL_CALC_ID  
INTO :ll_calc_id  
FROM VOYAGES  
WHERE 	( VOYAGES.VESSEL_NR = :ai_vessel_nr ) AND  
         	( VOYAGES.VOYAGE_NR = :as_voyage_nr )   ;
commit;
SELECT 	CAL_BALL.CAL_BALL_VIA_POINT_1,           isnull(CAL_BALL.CAL_BALL_VIA_EXPENSES_1,0)  ,
		CAL_BALL.CAL_BALL_VIA_POINT_2,           isnull(CAL_BALL.CAL_BALL_VIA_EXPENSES_2,0)  ,
		CAL_BALL.CAL_BALL_VIA_POINT_3,           isnull(CAL_BALL.CAL_BALL_VIA_EXPENSES_3,0)  
INTO :ls_vp_1,:ld_ve_1,:ls_vp_2,:ld_ve_2,:ls_vp_3,:ld_ve_3
FROM CAL_BALL  
WHERE 	( CAL_BALL.CAL_CALC_ID = :ll_calc_id )
ORDER BY CAL_BALL.CAL_BALL_ID ;
commit;
if not isnull(ls_vp_1) then
	ll_counter++
	SELECT PORTS.DISB_PORT_CODE  
    	INTO :aa_port_code[ll_counter]  
    	FROM PORTS  
   	WHERE PORTS.PORT_CODE = :ls_vp_1;
	commit;
	aa_port_exp[ll_counter] = ld_ve_1
	if not isnull(ls_vp_2) then
		ll_counter++
		SELECT PORTS.DISB_PORT_CODE  
    		INTO :aa_port_code[ll_counter]  
    		FROM PORTS  
   		WHERE PORTS.PORT_CODE = :ls_vp_2;
		commit;
		aa_port_exp[ll_counter] = ld_ve_2
		if not isnull(ls_vp_3) then
			ll_counter++
			SELECT PORTS.DISB_PORT_CODE  
    			INTO :aa_port_code[ll_counter]  
    			FROM PORTS  
   			WHERE PORTS.PORT_CODE = :ls_vp_3;
			commit;
			aa_port_exp[ll_counter] = ld_ve_3

		end if
	end if
end if

// Create cursor
lt_local_transaction = create transaction
uo_global.defaulttransactionobject(lt_local_transaction)
connect using lt_local_transaction;
// Investigation of connect
If lt_local_transaction.SQLCode = -1 Then
	MessageBox("Error","Error connecting transaction.")
End if

DECLARE get_port_expenses CURSOR FOR  
SELECT CAL_CAIO.PORT_CODE, CAL_CAIO.CAL_CAIO_EXPENSES,
		CAL_CAIO.CAL_CAIO_VIA_POINT_1,isnull(CAL_CAIO.CAL_CAIO_VIA_EXPENSES_1,0),
		CAL_CAIO.CAL_CAIO_VIA_POINT_2,isnull(CAL_CAIO.CAL_CAIO_VIA_EXPENSES_2,0),
		CAL_CAIO.CAL_CAIO_VIA_POINT_3,isnull(CAL_CAIO.CAL_CAIO_VIA_EXPENSES_3,0)
FROM VOYAGES V, CAL_CALC CC_a, CAL_CALC CC_b, CAL_CARG, CAL_CAIO
WHERE	V.VESSEL_NR= :ai_vessel_nr AND
		V.VOYAGE_NR=:as_voyage_nr AND
		CC_a.CAL_CALC_ID=V.CAL_CALC_ID AND
		(CC_a.CAL_CALC_FIX_ID = CC_b.CAL_CALC_FIX_ID AND CC_b.CAL_CALC_STATUS=6) AND
		CC_b.CAL_CALC_ID=CAL_CARG.CAL_CALC_ID AND
		CAL_CARG.CAL_CARG_ID =CAL_CAIO.CAL_CARG_ID 
ORDER BY CAL_CAIO_ITINERARY_NUMBER 
USING lt_local_transaction;
/* open cursor */
open get_port_expenses;

/* Fetch first */
ll_counter ++
fetch get_port_expenses into :aa_port_code[ll_counter], :aa_port_exp[ll_counter],:ls_vp_1,:ld_ve_1,:ls_vp_2,:ld_ve_2,:ls_vp_3,:ld_ve_3;
if not isnull(ls_vp_1) then
	ll_counter++
	SELECT PORTS.DISB_PORT_CODE  
	INTO :aa_port_code[ll_counter]  
	FROM PORTS  
	WHERE PORTS.PORT_CODE = :ls_vp_1;
	commit;
	aa_port_exp[ll_counter] = ld_ve_1
	if not isnull(ls_vp_2) then
		ll_counter++
		SELECT PORTS.DISB_PORT_CODE  
    		INTO :aa_port_code[ll_counter]  
    		FROM PORTS  
   		WHERE PORTS.PORT_CODE = :ls_vp_2;
		commit;
		aa_port_exp[ll_counter] = ld_ve_2
		if not isnull(ls_vp_3) then
			ll_counter++
			SELECT PORTS.DISB_PORT_CODE  
	    		INTO :aa_port_code[ll_counter]  
	    		FROM PORTS  
	   		WHERE PORTS.PORT_CODE = :ls_vp_3;
			commit;
			aa_port_exp[ll_counter] = ld_ve_3
		end if
	end if
end if

/* While there are more to fetch */
DO WHILE lt_local_transaction.sqlcode = 0
	fetch get_port_expenses into :ls_port_code, :ld_port_expenses,:ls_vp_1,:ld_ve_1,:ls_vp_2,:ld_ve_2,:ls_vp_3,:ld_ve_3;
	if lt_local_transaction.sqlcode = 0 then
		if aa_port_code[ll_counter] = ls_port_code then 
			aa_port_exp[ll_counter] += ld_port_expenses
		else
			ll_counter++
			aa_port_code[ll_counter] = ls_port_code
			aa_port_exp[ll_counter] = ld_port_expenses
			if not isnull(ls_vp_1) then
				ll_counter++
				SELECT PORTS.DISB_PORT_CODE  
				INTO :aa_port_code[ll_counter]  
				FROM PORTS  
				WHERE PORTS.PORT_CODE = :ls_vp_1;
				commit;
				aa_port_exp[ll_counter] = ld_ve_1
				if not isnull(ls_vp_2) then
					ll_counter++
					SELECT PORTS.DISB_PORT_CODE  
    					INTO :aa_port_code[ll_counter]  
    					FROM PORTS  
   					WHERE PORTS.PORT_CODE = :ls_vp_2;
					commit;
					aa_port_exp[ll_counter] = ld_ve_2
					if not isnull(ls_vp_3) then
						ll_counter++
						SELECT PORTS.DISB_PORT_CODE  
				    		INTO :aa_port_code[ll_counter]  
    						FROM PORTS  
   						WHERE PORTS.PORT_CODE = :ls_vp_3;
						commit;
						aa_port_exp[ll_counter] = ld_ve_3
					end if
				end if
			end if
		end if
	end if
LOOP

/* close cursor */
close get_port_expenses;
disconnect using lt_local_transaction;
// Investigation of disconnect
If lt_local_transaction.SQLCode = -1 Then
	MessageBox("Error","Error connecting transaction.")
End if

destroy lt_local_transaction

//for i = 1 to ll_counter
//	messagebox("test",string(ll_counter) + " = " + aa_port_code[i] + " " + string(aa_port_exp[i]))
//next

il_contypeid = ll_empty

ll_ports = upperbound(aa_port_code[])

/* Return number of ports */
return ll_ports

end function

public function integer wf_check_at_sea (integer ai_vessel_nr, string as_voyage_nr);integer li_count

/* If the proceeding is the last check for Idle days at sea on the voyage */
SELECT count(*) INTO :li_count
FROM IDLE_DAYS
WHERE VESSEL_NR = :ai_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = "ATS";
If (li_count > 0) Then 
	MessageBox("Delete","You cannot delete this last Proceeding as there exist Idle Days at sea for the voyage. ~r~n" &
					+"This makes it impossible to delete the voyage.")
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
	return -1
End if

/* If the proceeding is the last check for Off service at sea on the voyage */
SELECT count(*) INTO :li_count
FROM OFF_SERVICES
WHERE VESSEL_NR = :ai_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = "ATS";
IF (li_count > 0) THEN
	MessageBox("Delete","You cannot delete this last Proceeding as there exist Off Services at sea for the voyage.~r~n" &
					+"This makes it impossible to delete the voyage.")
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
	return -1
END IF

return 0
end function

private function integer wf_cancelproceeding (long al_row);string 	ls_voyage_nr, ls_port_code
integer	li_pcn, li_nr
decimal	ld_expenses_local, ld_expenses_USD

dw_proceeding_list.Accepttext()
ls_voyage_nr = dw_proceeding_list.GetItemString(al_row,"voyage_nr")
ls_port_code = dw_proceeding_list.GetItemString(al_row,"port_code")
li_pcn = dw_proceeding_list.GetItemNumber(al_row,"pcn")

/* select to see if there is a Port Of Call on this proceeding */
SELECT count(*)
INTO :li_nr
FROM POC
WHERE VESSEL_NR = :ii_vessel_nr AND &
		VOYAGE_NR = :ls_voyage_nr AND &
		PORT_CODE = :ls_port_code AND &
		PCN = :li_pcn;
commit;
/* if there is a Port Of Call on the proceeding then ... */
IF li_nr = 1 THEN
	/* inform the user that he/she cannot cancel the proceeding */
	messagebox("Warning","There exists an Actual Port Of Call for this Proceeding.~r~n~r~n" + &
								 "You cannot cancel this Proceeding.")		
	/* post event ue_set_cancel_0 to undo settling */
	w_proceeding_list.PostEvent("ue_set_cancel_0")	
	Return -1
END IF

/* select to see if there is an Estimated Port Of Call on this proceeding */
SELECT count(*)
INTO :li_nr
FROM POC_EST
WHERE VESSEL_NR = :ii_vessel_nr AND &
		VOYAGE_NR = :ls_voyage_nr AND &
		PORT_CODE = :ls_port_code AND &
		PCN = :li_pcn;
commit;
/* if there is a Estimated Port Of Call on the proceeding then ... */
IF li_nr = 1 THEN
	/* infor the user that he/she cannot cancel the proceeding */
	messagebox("Warning","There exists an Estimated Port Of Call for this Proceeding.~r~n~r~n" + &
								 "You cannot cancel this Proceeding.")		
	/* post event ue_set_cancel_0 to undo settling */
	w_proceeding_list.PostEvent("ue_set_cancel_0")	
	Return -1
END IF

/* select to see if there are unsettled Disbursement expenses on this proceeding */
SELECT count(*)
INTO :li_nr
FROM DISB_EXPENSES
WHERE VESSEL_NR = :ii_vessel_nr AND &
		VOYAGE_NR = :ls_voyage_nr AND &
		PORT_CODE = :ls_port_code AND &
		PCN = :li_pcn AND
		SETTLED = 0;
commit;
/* if there is a Disbursement on the proceeding then ... */
IF li_nr > 0 THEN
	/* infor the user that he/she cannot cancel the proceeding */
	messagebox("Warning","There exist Un-settled Disbursement expenses for this Proceeding.~r~n~r~n" + &
								 "Delete the expenses and try again.")		
	/* post event ue_set_cancel_0 to undo settling */
	w_proceeding_list.PostEvent("ue_set_cancel_0")	
	/* return from event */
	Return -1
END IF

/* select to see if there are unsettled Disbursement expenses on this proceeding */
SELECT round(sum(EXP_AMOUNT_LOCAL),2),
	round(sum(EXP_AMOUNT_USD),2)
INTO :ld_expenses_local,
	:ld_expenses_USD
FROM DISB_EXPENSES
WHERE VESSEL_NR = :ii_vessel_nr AND &
		VOYAGE_NR = :ls_voyage_nr AND &
		PORT_CODE = :ls_port_code AND &
		PCN = :li_pcn
GROUP BY VESSEL_NR,
		VOYAGE_NR,
		PORT_CODE,
		PCN ;
commit;
/* if there is a Disbursement on the proceeding then ... */
IF ld_expenses_local <> 0 OR ld_expenses_USD <> 0 THEN
	/* infor the user that he/she cannot cancel the proceeding */
	messagebox("Warning","The Balance on the Disbursement expenses for this Proceeding is not equal to 0 (zero).~r~n~r~n" + &
								 "You cannot cancel this proceeding when the balance is not zero. Correct and try again")		
	/* post event ue_set_cancel_0 to undo settling */
	w_proceeding_list.PostEvent("ue_set_cancel_0")	
	/* return from event */
	Return -1
END IF

//check to see if there exists a bunker purchase
SELECT count(*)
INTO :li_nr
FROM BP_DETAILS
WHERE VESSEL_NR = :ii_vessel_nr AND &
		VOYAGE_NR = :ls_voyage_nr AND &
		PORT_CODE = :ls_port_code AND &
		PCN = :li_pcn;
commit;
IF li_nr = 1 THEN
	IF messagebox("Warning","Bunker Purchase exists for this Proceeding.~r~n" + &
								 "This Bunker Purchase will be deleted.~r~n" + &
								 "Do you want to cancel this Proceeding?",Question!,YesNo!,2) = 2 THEN
		w_proceeding_list.PostEvent("ue_set_cancel_0")
		return -1
	ELSE
		DELETE FROM BP_DETAILS
		WHERE VESSEL_NR = :ii_vessel_nr AND &
		VOYAGE_NR = :ls_voyage_nr AND &
		PORT_CODE = :ls_port_code AND &
		PCN = :li_pcn;
		commit;
	END IF
END IF

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_proceeding_list
   <OBJECT> The window containing the proceeding detail</OBJECT>
   <DESC>  Here the user assigns calculations/ports to voyages that
	are then displayed in the port of call</DESC>
   <USAGE>  Called from an icon on the menubar or a menubar option</USAGE>
   <ALSO>   otherobjs</ALSO>
	<HISTORY>
		Date    		Ref   		Author   	Comments
		00/00/07		?     		Name Here	First Version
		06/09/10		1896  		AGL027   	Voyage Attachments, when all proceedings are
														deleted on a voyage that has files attached 
														we must delete from the VOYAGE_DOCUMENT table
														and the main VOYAGE_DOCUMENT_FILES table in the 
														files database.
		08/10/10		2145  		RMO003   	added function to create a unique proceeding date
														if the user creates several proceedings at the 
														same time 
		28/10-10		2165  		RMO003   	Changed delete last proceeding to use of_deletevoyage 
														function in n_voyage object.		
		30/11-10		2207  		JSU042   	Bug fixed
		17/12-10		2228  		RMO003   	Not allowed to modify voyage type if bunker
											   		posted in CODA
		01/04/11		2363  		JSU      	Open Modify Voyage Number button for Brostrom operators
		04/04/11		2363  		JSU      	validations for modifying voyage numbers
		18/04/11		2408  		LCH010   	link proceeding when user clicked speed instr in port of call list
		24/05/11		2408  		LCH010   	set voyage on subs
		11/11/11		2535&2536	TTY004		add validation about POC's autoschedule,and some refers changed in proceeding actions.
		16/02/11		D-CALC		AGL027   	Plug-in port validator functionality
											   		inc. Iteration 5 - fixes to requests.. dated 15/2
		17/02/12		2602  		CONASW   	Added function wf_SendMarOpsEmail()
		23/05/12		2794  		CONASW   	Added vessel as recipient in wf_SendMarOpsEmail()
		19/06/12		CR2831		AGL027   	Removed obsolete code concerned with portvalidator
		20/06/12		2838  		CONASW   	Exclude 3P and T/C vessels from Red-flag Port notifications
		31/07/12		CR2413		ZSW001   	Add function wf_modify_voyagetype(), wf_modify_voyagenumber(), wf_delete_voyagenumber(), wf_updateports()
		02/11/12		CR2962		JMY014   	When Estimated POC is not created, then don't messagebox with the POC information
		19/11/12		CR3002		LGX001   	Make it possible to allocate a voyage when cargo is registered
		14/01/13		CR2958		ZSW001   	no port selected in the proceeding should be forbidden.
		08/01/13		CR3101		CONASW   	Fix Super email address and Brostrom Automail addresses
		29/01/13		CR3002		LGX001   	Remove CR3002 function
		18/03/13		CR2658		LHG008   	Change speed dropdown for dw_proceeding and dw_proceeding_list, add function wf_speed_changed()
		26/03/13		CR3049		LGX001   	Add dragging port funcation and UI changes
		28-03-13		CR2658		WWG004   	New a port, the speed auto insert.
		28-03-13		CR2658		WWG004   	New function wf_get_contypeid().
		15/05/13		CR2690		LGX001   	Change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT											 
		16/09/13		CR3344		AGL027   	Log activity when auto-proceeding is used  
		06/03/14		CR2790		ZSW001   	Fix history issue when creating a new proceeding by admimistrator user profile.
		24/03/14		CR3582		CONASW   	Added SQL to log email in VIMS Email log
		12/09/14		CR3773		XSZ004   	Change icon absolute path to reference path
		17/11/14		CR3782		LHG008   	Fix row scoll issue
		21/01/15		CR3752		CCY018		Hide tce in poc when the voyage is not allocated.
		05/02/15		CR3564		XSZ004		Fix a historical bug.
		25/03/14		CR2680		CCY018		Fix a bug.
		27/09/15		CR4048		XSZ004		Filter inactive Consumption.
		09/11/15		CR4048UAT1	XSZ004		Fix a bug.
		08/09/16    CR4409    	CONASW    	Added email recipient in wf_SendMarOpsEmail()
		26/10/16		CR3320		AGL027		Remove notification that pdf has been generated on voyage number modify
		08/11/16		CR3320		AGL027		Cleaned up of_deletevoyage() function & modified user access to Modify Voyage option
	</HISTORY>
********************************************************************/

end subroutine

public function long wf_get_vv_actual_proc_port_array (integer ai_vessel_nr, string as_voyage_nr, ref string aa_port_code[]);// ************************************************************************************
// Author    : Bettina Olsen
// Date       :02-04-97
// Description :	array of proceeding ports
// Arguments : {description/none}
// Returns   : {description/none}  
// Variables : {important variables - usually only used in Open-event scriptcode}
// Other : {other comments}
//*************************************************************************************
//Development Log 
//DATE		VERSION 	NAME	DESCRIPTION
//-------- 		------- 		----- 		-------------------------------------
//02-04-97		5.0			BHO		INITIAL VERSION
//16-09-98		6.0			LN			Copied from VAS to w_proceeding_list
//************************************************************************************/
long ll_counter = 1
string ls_port_code

declare get_ports cursor for 
	SELECT PROCEED.PORT_CODE
	FROM PROCEED
	WHERE ( PROCEED.VESSEL_NR = :ai_vessel_nr ) and
	( PROCEED.VOYAGE_NR = :as_voyage_nr )
	ORDER BY PROCEED.PROC_DATE  ;
	/* open cursor */
	open get_ports;
	/* Fetch first */
	fetch get_ports into :aa_port_code[ll_counter];
	/* While there are more to fetch */
	DO WHILE sqlca.sqlcode = 0
		fetch get_ports into :ls_port_code;
		if sqlca.sqlcode = 0 then
				if aa_port_code[ll_counter] = ls_port_code then 
			else
				ll_counter++
				aa_port_code[ll_counter] = ls_port_code
			end if
		end if
	LOOP
	/* close cursor */
	close get_ports;


/* Return number of ports */
return ll_counter
end function

public function integer wf_set_voyage_on_subs (long al_row, integer ai_on_subs);/********************************************************************
   wf_set_voyage_on_subs
   <DESC>	update voyages on subs </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, 1 ok
            <LI> c#return.Failure, -1 failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row:selected or clicked row
		ai_on_subs: on subs status
   </ARGS>
   <USAGE>	itemchage in proceeding	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24-05-2011 cr2408       Henry Chen        First Version
   	17-11-2014 CR3782       LHG008            Fix row scoll issue
   </HISTORY>
********************************************************************/

string	ls_voyage_nr
integer	li_vessel_nr, li_rowcount
long  	ll_row

li_vessel_nr = dw_proceeding_list.getitemnumber(al_row, "vessel_nr")
ls_voyage_nr = dw_proceeding_list.getitemstring(al_row, "voyage_nr")

//if exist actual port of call in voyages,can't set on subs
if ai_on_subs = 1 then
	SELECT COUNT(1) INTO :li_rowcount FROM POC WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
	/* inform the user that he/she cannot on subs the voyage */
	if li_rowcount > 0 then
		messagebox("Warning","There is at least one Actual POC for this voyage. You cannot set this voyage on Subs.")
   	/* post event ue_set_off_subs to undo settling */
		this.postevent("ue_set_off_subs")
		return c#return.failure
	end if
	if messagebox("On Subs", "Set this voyage on Subs?", question!, yesno!, 2) <> 1 then
		this.postevent("ue_set_off_subs")
		return c#return.failure
	end if
end if

UPDATE VOYAGES SET VOYAGE_ON_SUBS = :ai_on_subs WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;

If sqlca.sqlcode = 0 THEN
	Commit;
Else
	Rollback;
End if

for ll_row = al_row + 1 to dw_proceeding_list.rowcount()
	if dw_proceeding_list.getitemstring(ll_row, "voyage_nr") = ls_voyage_nr then
		dw_proceeding_list.setitem(ll_row, "voyage_on_subs", ai_on_subs)
		dw_proceeding_list.setitemstatus(ll_row, "voyage_on_subs", primary!, notmodified!)
	else
		exit
	end if
next

return c#return.Success
end function

public function integer wf_proceedinglist_update ();/********************************************************************
   wf_proceedinglist_update
   <DESC>	when any proceedinglist column value has been changed ,do update</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, update success 
            <LI> c#return.Failure, update failure	</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>after proceedlist dw itemchanged,update it 	</USAGE>
   <HISTORY>
   	Date       CR-Ref       				Author             Comments
   	17/11/11   CR2535&CR2536            TTY004        First Version
   </HISTORY>
********************************************************************/
n_service_manager  lnv_svcmgr
n_dw_validation_service lnv_transrules	
integer li_rule	

//check if the proceeding data is duplicate
dw_proceeding_list.accepttext()
lnv_svcmgr.of_loadservice( lnv_transrules, "n_dw_validation_service")
li_rule = lnv_transrules.of_registerruledatetime("proc_date", true, "proceeding date", true)
lnv_transrules.of_setfindclause( "year(proc_date) > 2010" )
if lnv_transrules.of_validate( dw_proceeding_list, true) = c#return.Failure then return c#return.failure

IF dw_proceeding_list.Update() = 1 THEN
	commit;
	return c#return.success
ELSE
	rollback;
	return c#return.failure
END IF	

end function

public subroutine wf_sendmaropsemail (integer ai_vesselnr, string as_port);// This function checks if a port added to a proceeding
// is a "MAROPS Redflag" port. If so, a warning email is sent to the 
// vessel's Vetting Superintendent & others. Returns nothing.
 
// Author: CONASW
// CR Ref: 2602
// Date: 17 Feb 12

// Change Log
// Date: 24 Mar 14. CR: 3582 - Add email to sent mail log in VIMS
// Date: 08 Sep 16. CR: 4490 - Add email CrwMngMT@maersk.com in recipient list
 
String ls_Notes, ls_Subject, ls_Recipients
Integer li_Red=0
 
Select PORT_CODE + ' - ' + PORT_N, VETT_NOTES, VETT_REDFLAG
Into :as_Port,:ls_Notes, :li_Red from PORTS 
Where PORT_CODE=:as_Port;
 
Commit;
 
If li_Red=0 then Return  // Not a Red-flag port
 
// Prepare email
String ls_Body, ls_Vessel, ls_Super, ls_Err, ls_VslEmail, ls_Type
mt_n_stringfunctions ln_str
mt_n_outgoingmail lnvo_Mail
 
Select VESSEL_REF_NR + ' - ' + VESSEL_NAME, DEPTNOTE, VESSEL_EMAIL, TYPE_NAME
Into :ls_Vessel, :ls_Super, :ls_VslEmail, :ls_Type
From VESSELS Inner Join VETT_VSLTYPE On VESSELS.VETT_TYPE=VETT_VSLTYPE.TYPE_ID 
Inner Join USERS On VETT_RESP=USERID Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID
Where VESSEL_NR=:ai_vesselnr;
 
Commit;
 
// Exit if vessel type is 3P or T/C
If Pos(ls_Type, "3P")>0 or Pos(ls_Type, "T/C")>0 then Return
 
// Exit if no super email for vessel
If ls_Super = "" or IsNull(ls_Super) Then Return
 
// Check for Brostrom Automail addr
ls_VslEmail = Trim(Lower(ls_VslEmail), True)
If Left(ls_VslEmail, 8) = "automail" Then ls_VslEmail = "master" + Right(ls_VslEmail, Len(ls_VslEmail) - 8)
 
lnvo_Mail = Create mt_n_outgoingmail
 
// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Good-day,<br/><br/>This is an automatic notification email. A MAROPS Redflag port was added to a vessel's itinerary:<br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;' cellpadding='3'><tr><td>Vessel:</td><td>" + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Port Code/Name:</td><td>" + as_Port + "</td></tr>"
ls_Body += "<tr><td valign='top'>Red-Flag Reason:</td><td>" + ln_str.of_HtmlEncode(ls_Notes) + "</td></tr>"
ls_Body += "</table><br/><br/>Best Regards,<br/>VIMS</body></html>"
 
// Subject
ls_Subject = "Notification for MAROPS Red Flag Port (" + ls_Vessel + ")"
 
// Create and send email
lnvo_Mail = Create mt_n_outgoingmail
If lnvo_Mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_Super, ls_Subject, ls_Body, ls_Err) < 1 then Return
lnvo_Mail.of_SetCreator(uo_Global.is_UserID, ls_Err)
lnvo_Mail.of_AddReceiver(ls_VslEmail, ls_Vessel, ls_Err)
lnvo_Mail.of_AddReceiver("CrwMngMT@maersk.com", "Crew Management MT", ls_Err)  // CR4490

If lnvo_Mail.of_SendMail(ls_Err)<1 Then 
	Messagebox("Email Error", "An error occurred when sending an email notification to the vessel's superintendent", Exclamation!)
Else
	ls_Recipients = ls_Super+"; "+ls_VslEmail+"; CrwMngMT@maersk.com"

	// Log email
	Insert Into VETT_MAILLOG(MAILSENT,SUBJECT,RECIPIENTS,BODY)
	Values(GetDate(),:ls_Subject,:ls_Recipients,:ls_Body);
	
	Commit;
End If

Destroy lnvo_Mail
end subroutine

private function integer __refresh_poc ();/********************************************************************
   __refresh_poc
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, have been do refresh
           	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	when changed proceeding speed,change proc_date, cancel or delete a proceeding  ,after do autoschedule
	         refresh data in POC if it has been Opened.</USAGE>
   <HISTORY>
   	Date       CR-Ref       				Author             Comments
   	06/02/12   CR2535&CR2536            TTY004        First Version
   </HISTORY>
********************************************************************/
if isvalid(w_port_of_call) then
	if this.ii_vessel_nr = w_port_of_call.ii_vessel_nr then
		w_port_of_call.cb_refresh. event clicked()
		dw_proceeding_list.post setfocus()
	end if
end if 
return c#return.success
end function

public subroutine wf_modify_voyagetype ();/********************************************************************
   wf_modify_voyagetype
   <DESC>	Modify Voyage Type	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
	</HISTORY>
********************************************************************/

double				ld_calcid
long					ll_row
decimal 				ld_bunker_posted
s_vessel_voyage 	lstr_ves_voy
s_voyage_return lstr_return

n_auto_proceeding lnv_auto_proceeding

ll_row = dw_proceeding_list.getRow()
if ll_row < 1 then 
	MessageBox("Select Error", "Please select a voyage to modify.")
	return
end if

lstr_ves_voy.vessel_nr = ii_vessel_nr
lstr_ves_voy.voyage_nr = dw_proceeding_list.GetItemString(ll_row,"voyage_nr")
//lstr_ves_voy.new = false
lstr_ves_voy.type_name = "Allocated"

/* Check if this voyage is allocated to a calculation. Modify not allowed */
SELECT VOYAGES.CAL_CALC_ID  
	INTO :ld_calcid  
	FROM VOYAGES
	WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr
		AND VOYAGE_NR = :lstr_ves_voy.voyage_nr;

if ld_calcid > 1 then
	MessageBox("Information", "This voyage is allocated to a calculation. Please de-allocate before changing voyage type.")
	return
end if

/* Check if there are registred bunker on DEL/RED port. Modify not allowed */
setNull(ld_calcid)
SELECT BP_DETAILS.PCN  
	INTO :ld_calcid  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.PORT_CODE = POC.PORT_CODE
		AND BP_DETAILS.VESSEL_NR = POC.VESSEL_NR 
		AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR 
		AND BP_DETAILS.PCN = POC.PCN 
		AND POC.VESSEL_NR = :lstr_ves_voy.vessel_nr
		AND POC.VOYAGE_NR = :lstr_ves_voy.voyage_nr
		AND POC.PURPOSE_CODE in ("DEL", "RED") ;

if not isNull(ld_calcid) then
	MessageBox("Information", "This is registered Bunker Purchase on delivery/redelivery port(s). Please delete before changing voyage type.")
	return
end if

/* Check if there is posted any bunker to CODA. Modify not allowed */
SELECT VOYAGES.BUNKER_POSTED_HFO +   
	VOYAGES.BUNKER_POSTED_DO +   
	VOYAGES.BUNKER_POSTED_GO +   
	VOYAGES.BUNKER_POSTED_LSHFO +   
	VOYAGES.BUNKER_POSTED_BUY +   
	VOYAGES.BUNKER_POSTED_LOSSPROFIT +   
	VOYAGES.BUNKER_POSTED_OFFSERVICE +   
	VOYAGES.BUNKER_POSTED_SELL  
INTO :ld_bunker_posted  
FROM VOYAGES   
WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr
	AND VOYAGE_NR = :lstr_ves_voy.voyage_nr ;

if ld_bunker_posted <> 0 then
	MessageBox("Information", "There exist bunker postings on this voyage. Please correct before changing voyage type.")
	return
end if

openwithparm(w_voyage, lstr_ves_voy)
lstr_return = message.powerobjectparm
if lstr_return.ab_autocreateproceeding and lstr_return.al_return > 1 then
	lnv_auto_proceeding = create n_auto_proceeding
	lnv_auto_proceeding.of_auto_proceeding(lstr_ves_voy.vessel_nr, lstr_ves_voy.voyage_nr)
	destroy lnv_auto_proceeding
end if	

/* Re-Retrieve proceeding list dw */
this.triggerevent("ue_retrieve")

end subroutine

public subroutine wf_modify_voyagenumber ();/********************************************************************
   wf_modify_voyagenumber
   <DESC>	Modify Voyage Number	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_begin_tran = "begin transaction"
string 	ls_end_tran = "commit transaction"
string	ls_rollback = "rollback transaction"
n_voyage		lnv_voyage
boolean 			lbl_modify = true

lnv_voyage = create n_voyage

EXECUTE IMMEDIATE :ls_begin_tran using sqlca;

//operators are only allowed to change voyage numbers when there is no incoming/outgoing payments/espenses
//need to be removed when the swopping vessel funtion is in place
if uo_global.ii_user_profile = 2 then
	if lnv_voyage.of_modifyvoyagevalidation(dw_proceeding_list) = -1 then
		lbl_modify = false
		destroy lnv_voyage
		EXECUTE IMMEDIATE :ls_rollback using sqlca;
		return
	end if
end if

if lnv_voyage.of_modifyvoyage(dw_proceeding_list) = 1 then
	destroy lnv_voyage
	EXECUTE IMMEDIATE :ls_end_tran using sqlca;  // ending nested transaction
	commit; // ending primary transaction
else
	destroy lnv_voyage
	EXECUTE IMMEDIATE :ls_rollback using sqlca;
end if

this.postevent("ue_retrieve")

end subroutine

public subroutine wf_delete_voyagenumber ();/********************************************************************
   wf_delete_voyagenumber
   <DESC>	Delete Whole Voyage	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

n_voyage		lnv_voyage

lnv_voyage = create n_voyage
lnv_voyage.of_deletevoyage(dw_proceeding_list)
destroy lnv_voyage

this.postevent("ue_retrieve")

end subroutine

public subroutine wf_updateports ();/********************************************************************
   wf_updateports
   <DESC>	auto create proceeding and estimate ports	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2012   CR2413       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_selectedrow, ll_vessel_nr, ll_return, ll_ori_proceedingcount, ll_cur_proceedingcount, ll_ori_estcount, ll_cur_estcount
string	ls_voyage_nr, ls_msg

n_auto_proceeding		lnv_auto_proceeding

ll_selectedrow = dw_proceeding_list.getselectedrow(0)
if ll_selectedrow <= 0 then return

//get vessels number and voyages number
ll_vessel_nr = dw_proceeding_list.getitemnumber(ll_selectedrow, "vessel_nr")
ls_voyage_nr = dw_proceeding_list.getitemstring(ll_selectedrow, "voyage_nr")

//get the amount of proceeding and estimated ports of the voyage before auto proceeding
SELECT count(*) INTO :ll_ori_proceedingcount FROM PROCEED WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
SELECT count(*) INTO :ll_ori_estcount        FROM POC_EST WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;

lnv_auto_proceeding = create n_auto_proceeding
ll_return = lnv_auto_proceeding.of_auto_proceeding(ll_vessel_nr, ls_voyage_nr)
destroy lnv_auto_proceeding

//get the amount of proceeding and estimated ports of the voyage after auto proceeding
SELECT count(*) INTO :ll_cur_proceedingcount FROM PROCEED WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
SELECT count(*) INTO :ll_cur_estcount        FROM POC_EST WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;

if ll_return >= 0 then
	if ll_ori_proceedingcount = ll_cur_proceedingcount and ll_cur_estcount = ll_ori_estcount then
		messagebox("No Action", "Voyage already has full itinerary expected.")
	else
		if ll_cur_estcount = ll_ori_estcount then
			ls_msg = string(ll_return) + " new proceeding(s) have been created."
		else
			ls_msg = string(ll_return) + " new proceeding(s) and " + string(ll_cur_estcount - ll_ori_estcount) + " new estimated port(s) have been created."
		end if
		
		messagebox("Success", ls_msg)
		this.triggerevent("ue_retrieve")
		__refresh_poc()
	end if
else
	if ll_ori_proceedingcount <> ll_cur_proceedingcount or ll_cur_estcount <> ll_ori_estcount then
		this.triggerevent("ue_retrieve")
		__refresh_poc()
	end if
end if

end subroutine

public function integer wf_atobviac_proceeding (integer ai_vessel, string as_voyage, boolean ab_update, boolean ab_update_order);long ll_via_nr, ll_return
integer li_port_via_or_canal  // 0=port 1=via-point 2=canal
string ls_portcode
datetime ldt_procdate

ls_portcode = dw_proceeding.getItemString(1, "port_code")
ldt_procdate = dw_proceeding.getitemdatetime(1, "proc_date")
SELECT VIA_POINT  
	INTO :li_port_via_or_canal 
	FROM PORTS 
	WHERE PORT_CODE = :ls_portcode ;

if li_port_via_or_canal > 0 then
	SELECT count(*)
		INTO :ll_via_nr
		FROM PROCEED 
		WHERE VESSEL_NR = :ai_vessel
		AND VOYAGE_NR = :as_voyage
		AND PCN < 1;
	
	if ll_via_nr <> 0 then
		SELECT min(PCN)
			INTO :ll_via_nr
			FROM PROCEED 
			WHERE VESSEL_NR = :ai_vessel
			AND VOYAGE_NR = :as_voyage
			AND PCN < 1;
		ll_via_nr --
	end if
	
	dw_proceeding.setItem(1, "pcn", ll_via_nr)
	dw_proceeding.setItem(1, "input_dt", today())
end if

if ab_update = false then return 1
if inv_autoschedule.of_checkautoschedule_proceeding(ii_vessel_nr, as_voyage, ldt_procdate) then
	inv_autoschedule.of_get_proceed_poc(ii_vessel_nr, is_year)
end if 
/* If update of row is OK, then... */
IF dw_proceeding.update() = 1 THEN
	
	if ab_update_order and dw_proceeding_list.update() <> 1 then
		rollback;
		ll_return = c#return.Failure		   
	else	
		/* commit transaction */
		
		commit;
		/* set window into use state */
		inv_autoschedule.of_distancechanged(ii_vessel_nr, as_voyage, is_year)

		uo_vesselselect.enabled = TRUE
		dw_proceeding_list.enabled = TRUE
		cb_update.enabled = FALSE
		cb_cancel.enabled = FALSE
		cb_delete.enabled = TRUE
		cb_new_proceeding.enabled = TRUE
		/* clear the input datawindow */
		dw_proceeding.Reset()
		
		ll_return = c#return.Success
		/* re-retrieve proceeding list datawindow */
		this.PostEvent("ue_retrieve")
	end if
/* else if update is NOT OK , then rollback transacion */
ELSE
	rollback;
	ll_return = c#return.Failure
END IF

return ll_return

end function

private function integer __checkdragged (long al_draggedfrom, long al_draggedto, long al_maxrow);/********************************************************************
   __checkdragged
   <DESC> validate the dragging operation </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_draggedfrom
		al_draggedto
		al_maxrow
   </ARGS>
   <USAGE>Validate order:
	       1. itinerary
			 2. poc
			 3. proceeding	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08/04/2013 CR3049         LGX001        First Version
   </HISTORY>
********************************************************************/
datetime ldt_new_procdate
string ls_voyage, ls_port
integer li_pcn, li_count_act, li_count_est
long ll_lastport_row, ll_calcid, ll_count, ll_found

mt_n_datastore lds_itinerary

if al_draggedfrom = al_maxrow then
	ll_lastport_row = al_maxrow -1
elseif al_draggedto = al_maxrow then
	ll_lastport_row = al_draggedfrom
end if

if ll_lastport_row > 0 then
	
	ll_calcid = dw_proceeding_list.getitemnumber(ll_lastport_row, "voyages_cal_calc_id")
	ls_port 	 = dw_proceeding_list.getitemstring(ll_lastport_row, "port_code")
	
	if ll_calcid > 1 then
		lds_itinerary = create mt_n_datastore
		lds_itinerary.dataobject = "d_sq_tb_validatoritin"
		lds_itinerary.settransobject(sqlca)
		lds_itinerary.retrieve(ll_calcid)
		
		ll_count = lds_itinerary.rowcount( )
		if ll_count > 0 then
			ll_found = lds_itinerary.find("port_code = '" + ls_port +"'", ll_count, 1)
			if ll_found > 0 then
				if lds_itinerary.getitemstring(ll_found, "purpose_code") = 'L' or lds_itinerary.getitemstring(ll_found, "purpose_code") = 'L/D' then
					messagebox("Validation", "You cannot set a load port as the last port.")
					destroy lds_itinerary
					return c#return.Failure
				end if		
			end if			
		end if
		destroy lds_itinerary
	end if

	ls_voyage = dw_proceeding_list.getitemstring(ll_lastport_row, "voyage_nr")
	ls_port 	 = dw_proceeding_list.getitemstring(ll_lastport_row, "port_code")
	li_pcn 	 = dw_proceeding_list.getitemnumber(ll_lastport_row, "pcn")
	
	SELECT COUNT(*) INTO :li_count_act
	FROM POC
	WHERE POC.VESSEL_NR = :ii_vessel_nr AND
			POC.VOYAGE_NR = :ls_voyage 	AND
			POC.PORT_CODE = :ls_port 		AND
			POC.PCN 		  = :li_PCN			AND
			POC.PURPOSE_CODE IN ("L", "L/D"); 
	
	SELECT COUNT(*) INTO :li_count_est
	FROM POC_EST
	WHERE POC_EST.VESSEL_NR = :ii_vessel_nr AND
			POC_EST.VOYAGE_NR = :ls_voyage 	 AND
			POC_EST.PORT_CODE = :ls_port 		 AND
			POC_EST.PCN 		= :li_PCN 		 AND
			POC_EST.PURPOSE_CODE IN ("L", "L/D");
	
	if li_count_act + li_count_est > 0 then
		messagebox("Validation", "You cannot set a load port as the last port.")
		return c#return.Failure
	end if
	
end if

ls_voyage = dw_proceeding_list.getitemstring(al_draggedfrom, "voyage_nr")
ls_port 	 = dw_proceeding_list.getitemstring(al_draggedfrom, "port_code")
li_pcn 	 = dw_proceeding_list.getitemnumber(al_draggedfrom, "pcn")
ldt_new_procdate = dw_proceeding_list.getitemdatetime(al_draggedto, "proc_date")

if inv_autoschedule.of_validate_proceeding(ii_vessel_nr, ls_voyage, li_pcn, ls_port, ldt_new_procdate) then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer wf_get_max_portorder (string as_voyagenr);/********************************************************************
   wf_get_max_port_order
   <DESC> get max  port order	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_voyage
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/03/2013 CR3049            LGX001        First Version
   </HISTORY>
********************************************************************/

long ll_found, ll_max_portorder = 0

ll_found = dw_proceeding_list.find("voyage_nr = '" + as_voyagenr + "'", dw_proceeding_list.rowcount(), 1)
if ll_found > 0 then
	ll_max_portorder = dw_proceeding_list.getitemnumber(ll_found, "port_order")
end if

ll_max_portorder ++

return ll_max_portorder
end function

private function datetime wf_unique_procdate ();/********************************************************************
   wf_unique_procdate
   <DESC> Get unique proc date	</DESC>
   <RETURN>	datetime:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24/04/2013 CR3049       LGX001        First Version
   </HISTORY>
********************************************************************/
 
datetime ldt_procdate 

SELECT DATEADD(MINUTE, 1, MAX(PROC_DATE))  
INTO :ldt_procdate
FROM 
(SELECT PROC_DATE
	FROM PROCEED
  WHERE VESSEL_NR = :ii_vessel_nr
 UNION ALL
 SELECT GETDATE()) A;
 
return ldt_procdate
end function

public function long wf_get_estimated_route (long al_calc_id, ref string as_port_code[]);/********************************************************************
   wf_get_estimated_route
   <DESC>	Get the ports according route	</DESC>
   <ARGS>   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author       Comments
   	28/03/2013		CR2658		WWG004       Get the consumption id.
	</HISTORY>
********************************************************************/

n_ds lds_route
long ll_rows, ll_row, ll_contypeid[]

lds_route = create n_ds
lds_route.dataObject = "d_sq_tb_route_match"
lds_route.setTransObject( sqlca )

ll_rows = lds_route.retrieve( al_calc_id )

lds_route.setsort("port_sequence A")
lds_route.sort()

for ll_row = 1 to ll_rows
	as_port_code[ll_row] = lds_route.getItemString(ll_row, "port_code")
	ll_contypeid[ll_row]	= lds_route.getItemnumber(ll_row, "cal_cons_id")
next

destroy lds_route

il_contypeid[] = ll_contypeid[]

return UpperBound(as_port_code)
end function

public subroutine wf_get_contypeid (string as_column);/********************************************************************
   wf_get_contypeid
   <DESC>	Get the new contype id			</DESC>
   <RETURN>	(none):								</RETURN>
   <ACCESS> public								</ACCESS>
   <ARGS>	as_column: The changed column	</ARGS>
   <USAGE>	Get the new contypeid when change port code or port text	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		03-18-2013	CR2658		WWG004	First Version
   </HISTORY>
********************************************************************/

long	ll_sel_row, ll_contype

choose case as_column
	case "port_code"
		ll_sel_row = idwc_portcode.getrow()
	case "proc_text"
		ll_sel_row = idwc_proctext.getrow()
end choose

if ll_sel_row > 0 and upperbound(il_contypeid) > 0 then
	ll_contype = il_contypeid[ll_sel_row]
	dw_proceeding.setitem(1, "cal_cons_id", ll_contype)
	wf_speed_changed(dw_proceeding, 1, ll_contype)
end if

end subroutine

public subroutine wf_speed_changed (datawindow adw_proceed, integer ai_row, long al_contypeid);/********************************************************************
   wf_speed_changed
   <DESC>	when speed changed, synchronize speed and consumption	</DESC>
   <RETURN>	(none):								</RETURN>
   <ACCESS> public								</ACCESS>
   <ARGS>	al_contypeid: New contypeid	</ARGS>
   <USAGE>	call when speed("cal_cons_id") changed	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		03-18-2013	CR2658		LHG008	First Version
   </HISTORY>
********************************************************************/

datawindowchild	ldwc_child
long					ll_cal_cons_id, ll_find
decimal{2}			ld_speed, ld_consumption

if adw_proceed.getchild('cal_cons_id', ldwc_child) > 0 then
	ll_find = ldwc_child.find('cal_cons_id = ' + string(al_contypeid), 1, ldwc_child.rowcount())
	if ll_find > 0 then
		ld_speed 		= ldwc_child.getitemnumber(ll_find, 'cal_cons_speed')
		ld_consumption = ldwc_child.getitemnumber(ll_find, 'cal_cons_fo')
		
		adw_proceed.setitem(ai_row, "speed", ld_speed)
		adw_proceed.setitem(ai_row, "consumption", ld_consumption)
		adw_proceed.setitem(ai_row, "cal_cons_id", al_contypeid)
		
		ldwc_child.selectrow(ll_find, true)
	end if
end if
end subroutine

public function integer __refresh_order (string as_voyage_nr);long ll_voyagestart, ll_voyageend
long ll_newindex, ll_oldindex
long ll_row, ll_rowcount

ll_rowcount = dw_proceeding_list.rowcount()
ll_voyagestart = dw_proceeding_list.find("voyage_nr = '" + as_voyage_nr + "'", 1, ll_rowcount )
ll_voyageend 	= dw_proceeding_list.find("voyage_nr = '" + as_voyage_nr + "'", ll_rowcount, 1)	

for ll_row = ll_voyagestart to ll_voyageend
	ll_oldindex = dw_proceeding_list.getitemnumber(ll_row, "port_order")
	ll_newindex = ll_row - ll_voyagestart + 1
	
	if IsNull(ll_oldindex) then
		dw_proceeding_list.setitem(ll_row, "port_order", ll_newindex)
	elseif ll_oldindex <> ll_newindex then
		dw_proceeding_list.setitem(ll_row, "port_order", ll_newindex)
	end if
next

return 1
end function

public subroutine wf_filter_speed (mt_u_datawindow adw_proceeding);/********************************************************************
   wf_filter_speed
   <DESC> 	</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date    		CR-Ref		Author		Comments
   	26/08/15		CR4048		XSZ004		First Version
   </HISTORY>
********************************************************************/

long   ll_row, ll_cons_id
string ls_filter

datawindowchild ldwc_speed

ll_row = adw_proceeding.getrow()

if ll_row > 0 then
	adw_proceeding.getChild("cal_cons_id", ldwc_speed)
	
	ll_cons_id = adw_proceeding.getitemnumber(ll_row, "cal_cons_id")
	
	if isnull(ll_cons_id) then ll_cons_id = 0
	
	ls_filter  = "cal_cons_active = 1 or cal_cons_id = " + string(ll_cons_id)
	
	ldwc_speed.setfilter(ls_filter)	
	ldwc_speed.filter()
	
end if
end subroutine

public function integer wf_check_speed (long al_cal_cons_id);/*************************************************************
   wf_check_speed
   <DESC>		</DESC>
   <RETURN>	integer:
            <LI> c#return.success, ok
            <LI> c#return.failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
   	13/10/15		CR4048		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_ret, li_findrow
mt_n_datastore lds_speed

lds_speed = create mt_n_datastore
lds_speed.dataobject = "d_dddw_proceeding_vesselspeed"

lds_speed.settransobject(sqlca)
lds_speed.retrieve(ii_vessel_nr)

if isnull(al_cal_cons_id) then al_cal_cons_id = 0

li_findrow = lds_speed.find("cal_cons_active = 1 and cal_cons_id = " + string(al_cal_cons_id), 1, lds_speed.rowcount())

if li_findrow > 0 then
	li_ret = c#return.success
else
	messagebox("Error", "Selected speed is marked as inactive, Please select another speed.")
	li_ret = c#return.failure
end if

return li_ret
end function

event ue_update;call super::ue_update;/********************************************************************
   ue_update
   <DESC> Validates and updates the new row, creates voyage if required. </DESC>
   <RETURN>	
	</RETURN>          	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		30/07/96		3.0   		PBT   		System 3.
		21/11/96		3.0   		PBT   		Handling of finished voyages.
		14/03/05		14.0  		RMO   		Implementing AtoBviaC distance table.
		05/02/15		CR3564		XSZ004		Fix a historical bug.
   </HISTORY>
********************************************************************/

boolean lb_boolean, lb_finished, lb_create_estpoc, lb_update_proc_date = false
String  ls_find_str, ls_port_code , ls_proc_text,ls_ret_string
int     li_max_call_nr , li_count, li_viap_index, li_stop,li_min_pcn
long    ll_ret_code, ll_upper_viap, ll_found, ll_return, ll_port_order, ll_row, ll_max_orderrow, ll_portorder_list[], ll_cal_cons_id
string  ls_exp
datetime ldt_null, ldt_procdate, ldt_new_procdate, ldt_procdate_list[]

s_voyage_return lstr_return
s_vessel_voyage lstr_ves_voy

n_voyage     lnv_voyages
u_calc_nvo   uo_calc_nvo
u_tramos_nvo uo_tram

n_auto_proceeding  lnv_auto_proceeding
n_object_usage_log lnv_uselog

setnull(ldt_null)
lstr_return.ab_autocreateproceeding = false

/* accept latest inputed field */
if dw_proceeding.AcceptText() <> 1 then return

if dw_proceeding.rowcount() < 1 then return

/* get data in fields from new row */
lstr_ves_voy.vessel_nr = dw_proceeding.getitemnumber( 1, "vessel_nr")
lstr_ves_voy.voyage_nr = dw_proceeding.GetItemString(1, "voyage_nr")
//lstr_ves_voy.new = TRUE
lstr_ves_voy.type_name = "New"
ls_port_code = dw_proceeding.GetItemString(1, "port_code")
ls_proc_text = dw_proceeding.GetItemString(1, "proc_text")
ldt_procdate = dw_proceeding.GetItemdatetime(1, "proc_date")
ldt_new_procdate = ldt_procdate

//Voyage_nr need to be 5 or 7 diginal numbers
if len(lstr_ves_voy.voyage_nr) <> 5 and  len(lstr_ves_voy.voyage_nr) <> 7 then
	messagebox("Info","Voyage number format is YYXXX or YYXXX-XX(for TC Out),~r~nPlease try again.")
	return
end if

/* Find out if this voyage is finished and inform user if it is */
select VOYAGE_FINISHED
	into :lb_finished
	from VOYAGES
	where 	VESSEL_NR = :lstr_ves_voy.vessel_nr and
			VOYAGE_NR = :lstr_ves_voy.voyage_nr;
if lb_finished then
	messagebox("Notice","This voyage has been finished.~r~nNo new proceedings can be created on it.")
	return
end if

/* If proceeding text and code is null, inform user and quit update */
IF IsNull(ls_proc_text) AND IsNull(ls_port_code) THEN
	messagebox("Input Error","Please enter either a Proceeding Text or Port Code.")
	dw_proceeding.setcolumn("port_code")
	dw_proceeding.setfocus()
	return
END IF

/* check for duplicate entry in main list datawindow */
ll_found = dw_proceeding_list.find("proc_date=datetime('" + string(dw_proceeding.getitemdatetime(1,"proc_date"))+ "')",1, dw_proceeding_list.rowcount())
if ll_found>0 then 
	_addmessage( this.classdefinition, "ue_update()", "The data inside proceeding date can not be a duplicate", "non mt_dw_validation_service call")
	Return
end if

/*Test for port code */
IF Not(IsNull(ls_port_code)) AND Not(f_port_code_lookup(ls_port_code)) THEN
	MessageBox("Error","Incorrect port code.")
	dw_proceeding.setcolumn("port_code")
	dw_proceeding.setfocus()
	Return
END IF

/* If speed, speed instruction and consumption are null, inform user and quit */
if uo_global.ib_pocautoschedule then
	if isnull(dw_proceeding.GetItemnumber(1,"speed")) then
		messagebox("Input Error", "Please select a speed.")
		dw_proceeding.setcolumn("cal_cons_id")
		dw_proceeding.setfocus()
		return
	end if 
else 
   if isNull(dw_proceeding.GetItemnumber(1, "cal_cons_id"))  AND &
	IsNull(dw_proceeding.GetItemString(1, "speed_instr")) THEN
	   messagebox("Input Error", "Please select a speed or enter a speed instruction.")
		dw_proceeding.setcolumn("cal_cons_id")
		dw_proceeding.setfocus()
	   return
   end if 
end if 

ll_cal_cons_id = dw_proceeding.GetItemnumber(1,"cal_cons_id")

if ll_cal_cons_id > 0 then
	if wf_check_speed(ll_cal_cons_id) <> c#return.success then return
end if

/* If proceeding text is null, copy port name for port code into proceeding text */
IF IsNull(ls_proc_text) THEN
	SELECT PORT_N
		INTO :ls_proc_text
		FROM PORTS
		WHERE PORT_CODE = :ls_port_code;
/* else if port code is null, set it to " " (port = none) */
ELSE 
	IF IsNull(ls_port_code) THEN ls_port_code = " "
END IF	

/* if this is a TC-OUT voyage check if it is the first voyage fro this vessel
	cant be true */
if len(trim(lstr_ves_voy.voyage_nr)) > 5 then
	SELECT count(*) 
		INTO :li_count
		FROM VOYAGES
		WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr AND
				VOYAGE_NR+"00" < :lstr_ves_voy.voyage_nr;
	if li_count = 0 then
		messagebox("Input Error","You cannot have a TC-Out voyage as the first voyage. Please corerct.")
		return
	end if
end if

/* check to see how many voyages have the entered voyage number */
SELECT count(*) 
	INTO :li_count
	FROM VOYAGES
	WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr AND
			VOYAGE_NR = :lstr_ves_voy.voyage_nr;

//M5-1 Begin added by ZSW001 on 02/04/2012
lnv_voyages = create n_voyage
ll_return = lnv_voyages.of_checkvoyage(lstr_ves_voy.vessel_nr, lstr_ves_voy.voyage_nr)
destroy lnv_voyages

if ll_return < 0 then return
//M5-1 End added by ZSW001 on 02/04/2012

lb_create_estpoc = (li_count >= 1)

/* If there are no voyage numbers (ie. new voyage number given) then... */
IF li_count < 1 THEN
	/* If user wants to create new voyage, then... */
	IF MessageBox("New Voyage","Voyage Nr : " + string(lstr_ves_voy.voyage_nr) +  &
					" is new.~r~n Do you wish to create it?",Question!,YesNo!) = 1 THEN 
		/* open window to create new voyage */
		OpenWithParm(w_voyage,lstr_ves_voy)
		
		lstr_return = message.powerobjectparm
		ll_ret_code = lstr_return.al_return
		
		/* If return code from voyage window is -1, then cancel update and quit */
		/* if ret code is -1 (cancel of window) then return */
		if ll_ret_code = -1 then return

		/* If port code is given and a calc id has been chosen then... */
		If not isnull(ls_port_code) and not ls_port_code = " " and ll_ret_code > 1 then
			/* create calc nvo */
			uo_calc_nvo = create u_calc_nvo
			/* see if port is on calc */
			lb_boolean = uo_calc_nvo. uf_is_port_on_calc(ll_ret_code , ls_port_code )
			/* destroy calc nvo */
			destroy uo_calc_nvo
			/* if port code is not in the calcs list, then */
			if not lb_boolean then
				/* Inform user of problem, remove voyage from voyages table and quit update */
				Messagebox("Notice","The port you have chosen does not exist on the calculation " + &
								"you have chosen, please correct the problem and try again.")
				DELETE 
				FROM VOYAGES
				WHERE 	VESSEL_NR = :lstr_ves_voy.vessel_nr AND
						VOYAGE_NR = :lstr_ves_voy.voyage_nr;
				commit;
				return
			ELSE 
				dw_proceeding.setitem(1,"input_dt",ldt_null)
			end if
		end if
		
	/* else quit update */
	ELSE	
		Return
	END IF
END IF

int li_voy_type
select VOYAGE_TYPE
	INTO :Li_VOY_TYPE
	FROM VOYAGES
	WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr AND
			VOYAGE_NR = :lstr_ves_voy.voyage_nr    ;
if li_voy_type = 2 then dw_proceeding.setitem(1,"input_dt",ldt_null)

/* if Tramos/Calc intergration has not been set on then set input date to NULL(used to show no cargo icon) */
if NOT gb_tram_calc_is_interfaced then
	dw_proceeding.setitem(1,"input_dt",ldt_null)
end if

/* set search string to search proceeding list datawindow for this voyage and port */
ls_find_str = "voyage_nr = '" + 	lstr_ves_voy.voyage_nr + "' and port_code = '" + ls_port_code + "'"
/* If there exists this port on this voyage number already, set new PCN to  max PCN for voyage + 1 */
IF dw_proceeding_list.find(ls_find_str,1,dw_proceeding_list.RowCount()) <> 0 THEN
	SELECT 	max(PCN) 
		INTO 		:li_max_call_nr
		FROM 		PROCEED
		WHERE 	VESSEL_NR = :lstr_ves_voy.vessel_nr AND
					VOYAGE_NR = :lstr_ves_voy.voyage_nr AND
					PORT_CODE = :ls_port_code;
	li_max_call_nr = li_max_call_nr + 1
/* else set new PCN to 1 */
ELSE
	li_max_call_nr = 1
END IF
/* Set values for PCN, proceeding text and code */
/* We dont mark viapoints before after update later in script. */
dw_proceeding.SetItem(1,"PCN",li_max_call_nr)	
dw_proceeding.SetItem(1,"proc_text",ls_proc_text)
dw_proceeding.SetItem(1,"port_code",ls_port_code)
dw_proceeding.setitem(1, "created_by", uo_global.is_userid)		//CR2413 Added by ZSW001 on 11/05/2012.

//set port order as needed
ll_port_order = dw_proceeding.getitemnumber(1, "port_order")
if ll_port_order <= 0 then
	ll_port_order = 1
	dw_proceeding.setitem(1, "port_order", ll_port_order)
elseif ll_port_order > wf_get_max_portorder(lstr_ves_voy.voyage_nr) then
	ll_port_order = wf_get_max_portorder(lstr_ves_voy.voyage_nr)
	dw_proceeding.setitem(1, "port_order", ll_port_order)
end if

ls_exp = "voyage_nr = " + "'" + lstr_ves_voy.voyage_nr + "'"
ll_max_orderrow = dw_proceeding_list.find(ls_exp, dw_proceeding_list.rowcount( ), 1)
ls_exp = "voyage_nr = " + "'" + lstr_ves_voy.voyage_nr + "'" + " and port_order = " + string(ll_port_order)
ll_found = dw_proceeding_list.find(ls_exp, 1, dw_proceeding_list.rowcount( ))

if ll_found > 0 then
	ldt_new_procdate = dw_proceeding_list.getitemdatetime(ll_found, "proc_date")
	dw_proceeding.setitem(1, "proc_date", ldt_new_procdate)
	ll_portorder_list = dw_proceeding_list.object.port_order[ll_found, ll_max_orderrow]
	
	if ll_max_orderrow - ll_found >= 1 then
		ldt_procdate_list = dw_proceeding_list.object.proc_date[ll_found + 1, ll_max_orderrow]
		ldt_procdate_list[upperbound(ldt_procdate_list) + 1] = ldt_procdate
	else			
	   ldt_procdate_list[1] = ldt_procdate
	end if
	
	for ll_row = 1 to upperbound(ll_portorder_list)
		ll_portorder_list[ll_row] = ll_portorder_list[ll_row] + 1
	next
	
	// set port order & proceed date
	dw_proceeding_list.object.port_order[ll_found, ll_max_orderrow] = ll_portorder_list
	dw_proceeding_list.object.proc_date[ll_found, ll_max_orderrow] = ldt_procdate_list
	
	lb_update_proc_date = true
end if

if f_AtoBviaC_used(lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr) then
	ll_return = wf_atobviac_proceeding(lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr, true, lb_update_proc_date)
else
	wf_atobviac_proceeding(lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr, false, false)   // to set via point number from start if possible
		
	/* If update of row is OK, then... */
   if inv_autoschedule.of_checkautoschedule_proceeding(ii_vessel_nr, lstr_ves_voy.voyage_nr, ldt_new_procdate) then
		inv_autoschedule.of_get_proceed_poc(lstr_ves_voy.vessel_nr, is_year)
	end if 
	IF dw_proceeding.update() = 1 THEN
		
		if lb_update_proc_date and dw_proceeding_list.update() <> 1 then
			rollback;
			ll_return = c#return.Failure
		else
			//commit transaction
			commit;
			/* set window into use state */
			uo_vesselselect.enabled = TRUE
			dw_proceeding_list.enabled = TRUE
			cb_update.enabled = FALSE
			cb_cancel.enabled = FALSE
			cb_delete.enabled = TRUE
			cb_new_proceeding.enabled = TRUE
			/* clear the input datawindow */
			dw_proceeding.Reset()
			/* call update window */
			OpenWithParm(w_updated,0,w_tramos_main)
			
			// update istr_viap
			uo_tram = CREATE u_tramos_nvo
			ls_ret_string = uo_tram.uf_check_proceed_itenerary(lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr,FALSE)
			DESTROY uo_tram;
			
			ll_upper_viap = UpperBound(istr_viap.port)
		
			FOR li_count = 1 TO ll_upper_viap
				IF istr_viap.viap[li_count] = 9 THEN EXIT
			NEXT
			
			li_stop = li_count
		
			// Check if there is a match
			If ls_ret_string <> "0" AND ls_ret_string <> "-1" THEN
				// Check if it is a new voyage. IF yes update the one proceed's pcn = 0 if it is a viap.
				IF istr_viap.viap[1] = 1 AND istr_viap.viap[2] > 1 THEN 
					UPDATE PROCEED
					SET PCN = 0,  INPUT_DT = GetDate()  
					WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr  AND VOYAGE_NR = :lstr_ves_voy.voyage_nr ;
					IF SQLCA.SQLCode = 0 THEN
						COMMIT;
					ELSE
						ROLLBACK;
					END IF
				ELSE 
					// Find index that correspond to last updated proceed. Is highest index with 0 or 1 in istr_viap.viap
					IF istr_viap.viap[li_stop - 1] < 2 THEN
						li_viap_index = li_stop - 1
					ELSE
						li_viap_index = li_stop - 2
					END IF
					If istr_viap.viap[li_viap_index] = 1 THEN 
						// Update pcn to min -1
						li_min_pcn = 1
						SELECT MIN(PCN)
						INTO :li_min_pcn
						FROM PROCEED
						WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr  AND VOYAGE_NR = :lstr_ves_voy.voyage_nr ;
						IF SQLCA.SQLCode <> -1 THEN
						  COMMIT;
						  li_min_pcn --
						  UPDATE PROCEED
						  SET PCN = :li_min_pcn,  INPUT_DT = GetDate()  
						  WHERE VESSEL_NR = :lstr_ves_voy.vessel_nr  AND 
								  VOYAGE_NR = :lstr_ves_voy.voyage_nr AND PROC_DATE = 
									(  SELECT MAX(PROCEED.PROC_DATE)  
										 FROM PROCEED  
										 WHERE  PROCEED.VESSEL_NR =  :lstr_ves_voy.vessel_nr  AND  
																	PROCEED.VOYAGE_NR =  :lstr_ves_voy.voyage_nr );
						  IF SQLCA.SQLCode = 0 THEN
							 COMMIT;
						  ELSE
							 ROLLBACK;
						  END IF
						ELSE
						  ROLLBACK;
						END IF
					END IF
				END IF
			END IF	
			inv_autoschedule.of_distancechanged(ii_vessel_nr, lstr_ves_voy.voyage_nr, is_year)
			
			ll_return = c#return.Success
			
			/* re-retrieve proceeding list datawindow */
			this.PostEvent("ue_retrieve")
		end if
	/* else if update is NOT OK , then rollback transacion */
	else
		rollback;
		ll_return = c#return.Failure
	end if
end if

if ll_return = c#return.Success then
	if lstr_return.ab_autocreateproceeding then
		// log activity
		lnv_uselog.uf_log_object("Auto-create Proceedings")		
		lnv_auto_proceeding = create n_auto_proceeding
		lnv_auto_proceeding.of_auto_proceeding( lstr_ves_voy.vessel_nr, lstr_ves_voy.voyage_nr)
		destroy lnv_auto_proceeding
	end if
end if
if lb_create_estpoc then
	lnv_auto_proceeding = create n_auto_proceeding
	lnv_auto_proceeding.of_create_estpoc(lstr_ves_voy.vessel_nr, lstr_ves_voy.voyage_nr, ls_port_code, li_max_call_nr, 1)
	destroy lnv_auto_proceeding
end if

__refresh_poc()

//wf_autoschedule_refers(lstr_ves_voy.voyage_nr, ls_port_code, 1, "new")
/* Set new button as default */
cb_new_proceeding.default = TRUE
/* Enable allocate button */
cb_allocate.enabled = True

dw_proceeding.Modify("port_code.TabSequence=22")
dw_proceeding.SetTabOrder("proc_text",35)

Post wf_SendMarOpsEmail(lstr_ves_voy.vessel_nr, ls_Port_Code)

wf_set_calc_and_voyage_type(dw_proceeding_list.getselectedrow(0))

end event

event ue_insert;call super::ue_insert;/************************************************************************************
Author    : Peter Bendix-Toft
 Date       : 30-07-96
 Description : This event inserts a new proceeding.
 Arguments : {description/none}
 Returns   : {description/none}  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96 	3.0		PBT		System 3
14-03-05		14.0		RMO		Implemented AtoBviaC distance table
04-10-11		cr2282 	AGL		Refactored and included new portvalidator object
22-03-13		cr3049   LGX001	Hiden proc date and add port order col
28-03-13		CR2658	WWG004	New a port, the speed auto insert.
************************************************************************************/

datawindowchild dwc1, dwc2
string ls_max_voyage_nr, ls_null, ls_voyage_nr, ls_port_code_array[]
string ls_port_name,ls_return,ls_fix_port_name, ls_portcode
int li_vessel_nr, li_estimated_ports, li_counter, li_retval
long ll_row, ll_calc_id, ll_contype
setnull(ls_null)
decimal{2} ld_port_exp[]
boolean lb_stop = true,lb_admin = false
u_tramos_nvo uo_tram
n_portvalidator lnv_validator

if uo_global.ii_access_level = 3 then lb_admin = true

/* get current vessel number */
li_vessel_nr = ii_vessel_nr
/* If no vessel is chosen, escape event */
if li_vessel_nr = 0 OR isnull(li_vessel_nr) then return

/* Set window to insert state, by locking some objects and unlocking others etc.*/
dw_proceeding_list.accepttext()
uo_vesselselect.enabled = FALSE
dw_proceeding_list.enabled = FALSE
cb_new_proceeding.enabled = FALSE
cb_update.enabled = TRUE
cb_cancel.enabled = TRUE
cb_delete.enabled = FALSE
cb_options.of_modifymenuitem(il_updateportsnum, false)
dw_proceeding_list.SelectRow(0,FALSE)

/* Get row count for proceeding list dw */ 
ll_row = dw_proceeding_list.RowCount()

/* If there are some proceeding already then */
if ll_row  > 0 then
	/* update voyage number drop down list box with already existing voyage numbers */
	dwc.Retrieve(li_vessel_nr)
/* else if there are no rows then */
elseif ll_row = 0 then
	/* clear drop down list box and place one empty line in it */
	dwc.Reset()
	dwc.InsertRow(0)
	dwc.SetItem(1,"voyage_nr","voy nr")
end if

/* Insert the new row in the input datawindow */
dw_proceeding.InsertRow(0)

wf_filter_speed(dw_proceeding)

/* set several values automatically in the new row */
if dw_proceeding_list.rowcount() > 0 then
	ls_voyage_nr = dw_proceeding_list.getitemstring(dw_proceeding_list.GetRow(),"voyage_nr")
end if 

dw_proceeding.setitem(1,"voyage_nr",ls_voyage_nr)
dw_proceeding.setitem (1,"vessel_nr",li_vessel_nr)

dw_proceeding.setitem(1,"proc_date", wf_unique_procdate())
dw_proceeding.setitem(1,"fwo",0)
dw_proceeding.setitem(1,"cancel",0)

/* Turn off redraw */
dw_proceeding.setredraw(false)
/* set focus to input datawindow */
dw_proceeding.SetFocus()
/* make update button default */
cb_update.default = true
/* Disenable allocate button */
cb_allocate.enabled = false

/* Set port code and port name dddw's to full list or calc list */
if dw_proceeding_list.rowcount() > 0 then
		setnull(ll_calc_id)
		dw_proceeding.setitem(1,"port_code",ls_null)
		dw_proceeding.setitem(1,"proc_text",ls_null)
		dw_proceeding.SetTabOrder("proc_text",35)
		if Year(Today()) > 1999 then
			SELECT max(VOYAGE_NR)
			INTO :ls_max_voyage_nr
			FROM VOYAGES
			WHERE VESSEL_NR = :li_vessel_nr AND CONVERT(INT,SUBSTRING(VOYAGE_NR,1,5)) < 90000 ;
		else
			SELECT max(VOYAGE_NR)
			INTO :ls_max_voyage_nr
			FROM VOYAGES
			WHERE VESSEL_NR = :li_vessel_nr;
		end if
		ls_voyage_nr = dw_proceeding.GetText()		
		if not (ls_voyage_nr = "") and not IsNull(ls_voyage_nr) then 
			SELECT CAL_CALC_ID
			INTO :ll_calc_id	
			FROM VOYAGES
			WHERE 	VESSEL_NR = :li_vessel_nr AND
					VOYAGE_NR = :ls_voyage_nr;
			dw_proceeding.GetChild("port_code",dwc1)
			dw_proceeding.GetChild("proc_text",dwc2)
			dwc1.settransobject(sqlca)
			dwc2.settransobject(sqlca)
			if isnull(ll_calc_id) or ll_calc_id = 1 then
				uf_sharechild("dw_ports_list",dwc1)
				uf_sharechild("dw_port_name_list_share",dwc2)
				lb_stop = false
			elseif lb_admin then
				dwc1.sharedataoff()
				dwc2.sharedataoff()
				dwc1.reset()
				dwc2.reset()	
				if f_AtoBviaC_used(li_vessel_nr,ls_voyage_nr) then
					li_estimated_ports = wf_get_estimated_route( ll_calc_id, ls_port_code_array)
				else
					li_estimated_ports = wf_get_vv_estimated_port_exp_port_array(li_vessel_nr,ls_voyage_nr,ls_port_code_array,ld_port_exp)
				end if
				for li_counter = 1 to li_estimated_ports
					dwc1.insertrow(0)
					dwc1.setitem(li_counter,1,ls_port_code_array[li_counter])				
					dwc2.insertrow(0)
					dwc2.setitem(li_counter,2,ls_port_code_array[li_counter])			
				   if IsNull(ls_port_code_array[li_counter]) OR ls_port_code_array[li_counter] = "" then
						ls_port_name = "No Code (viap/canal)"
					else		
						SELECT PORTS.PORT_N  
						INTO :ls_port_name
						FROM PORTS  
						WHERE PORTS.PORT_CODE = :ls_port_code_array[li_counter];
					end if
					dwc1.setitem(li_counter,2,ls_port_name)
					dwc2.setitem(li_counter,1,ls_port_name)
				next 
			elseif not(lb_admin) then
				if f_AtoBviaC_used(li_vessel_nr,ls_voyage_nr) then
					lnv_validator = create n_portvalidator
					li_retval = lnv_validator.of_start( "PROCINSERT", li_vessel_nr, ls_voyage_nr, 3, ls_portcode)
					ll_contype = lnv_validator.il_contypeid
					destroy lnv_validator
				else
					/* check proceeditinerary instead */		
					/* prior v27.00.0 validation logic (TODO: Make it obsolete when we can! ) */
					uo_tram = CREATE u_tramos_nvo
					ls_portcode = uo_tram.uf_check_proceed_itenerary(li_vessel_nr,ls_voyage_nr,TRUE)
					DESTROY uo_tram;
					
					if ls_return = "-1" then
						li_retval=c#return.Failure
					elseif ls_return = "0" then
						li_retval=c#return.NoAction
					elseif ls_return = "1" then
						li_retval=c#return.Success
					end if
				end if
				
				if ls_portcode<>"" or li_retval = c#return.NoAction then
					
					dw_proceeding.setitem(1,"port_code",ls_portcode)				
					dw_proceeding.setitem(1, "cal_cons_id", ll_contype)
					wf_filter_speed(dw_proceeding)
					wf_speed_changed(dw_proceeding, 1, ll_contype)
					
					SELECT PORTS.PORT_N INTO :ls_fix_port_name
					  FROM PORTS
					 WHERE PORT_CODE = :ls_portcode;
					 
					dw_proceeding.setitem(1,"proc_text",ls_fix_port_name)
					dw_proceeding.settaborder("port_code",0)
					dw_proceeding.settaborder("proc_text",0)
					this.setfocus()
				
				elseif li_retval = c#return.Failure then
					if messagebox("New Voyage","Do you want to create a new voyage?",Question!,YesNo!,2) = 1 then
						if len(ls_max_voyage_nr) > 5 then
							ls_max_voyage_nr = String((long(ls_max_voyage_nr) + 1), "0000000")
						else
							ls_max_voyage_nr = String((long(ls_max_voyage_nr) + 1), "00000")
						end if	
						dw_proceeding.SetItem(1,"voyage_nr",ls_max_voyage_nr)
						uf_sharechild("dw_ports_list",dwc1)
						uf_sharechild("dw_port_name_list_share",dwc2)
						lb_stop = false
					else
						cb_cancel.triggerevent(clicked!)
						dw_proceeding.setredraw(true)
						return
					end if
				elseif li_retval = c#return.Success then
					messagebox("Finished Voyage","There are no more ports in itinerary without proceedings.")
					if messagebox("New Voyage","Do you want to create a new voyage?",Question!,YesNo!,2) = 1 then
						if len(ls_max_voyage_nr) > 5 then
							ls_max_voyage_nr = String((long(ls_max_voyage_nr) + 1), "0000000")
						else
							ls_max_voyage_nr = String((long(ls_max_voyage_nr) + 1), "00000")
						end if	
						dw_proceeding.SetItem(1,"voyage_nr",ls_max_voyage_nr)
						uf_sharechild("dw_ports_list",dwc1)
						uf_sharechild("dw_port_name_list_share",dwc2)
						lb_stop = false
					else
						cb_cancel.triggerevent(clicked!)
						dw_proceeding.setredraw(true)
						return
					end if
				
				end if
				lb_stop = false
			end if
		end if
	/* Set next proceeding port default from calculation */
	
	IF lb_stop THEN
		string ls_act_ports[],ls_est_ports[], ls_next_port, ls_port_text
		decimal{2} ld_est_port_exp[]
		long ll_act_pos = 1,ll_ub_est,ll_ub_act, ll_est_counter, ll_act_counter, ll_found_at
		boolean lb_found
		if f_AtoBviaC_used(li_vessel_nr,ls_voyage_nr) then
			ll_ub_est = wf_get_estimated_route( ll_calc_id, ls_est_ports)
		else
			ll_ub_est = wf_get_vv_estimated_port_exp_port_array(li_vessel_nr,ls_voyage_nr,ls_est_ports,ld_est_port_exp)
		end if
//		ll_ub_act = lu_vas.uf_get_vv_actual_proc_port_array(li_vessel_nr,ls_voyage_nr,ls_act_ports)
		for ll_est_counter = 1 to ll_ub_est
			lb_found = false
			for ll_act_counter = ll_act_pos to ll_ub_act
				if ls_act_ports[ll_act_counter] = ls_est_ports[ll_est_counter] then
					lb_found = true
					ll_found_at = ll_act_counter
					ll_act_counter = ll_ub_act
				end if
			next
			if lb_found then
				ll_act_pos = ll_found_at + 1
				ls_next_port = ls_null
			else
				ls_next_port = ls_est_ports[ll_est_counter]
				
				if ll_est_counter <= upperbound(il_contypeid) then
					ll_contype = il_contypeid[ll_est_counter]
				end if
				
				ll_est_counter = ll_ub_est
			end if
		next
		select PORT_N
		into :ls_port_text
		from PORTS
		where PORT_CODE = :ls_next_port;
		commit;
		dw_proceeding.setitem(1, "port_code", ls_next_port)		
		dw_proceeding.setitem(1, "proc_text", ls_port_text)
		
		if ll_contype > 0 then
			dw_proceeding.setitem(1, "cal_cons_id", ll_contype)
			wf_filter_speed(dw_proceeding)
			wf_speed_changed(dw_proceeding, 1, ll_contype)
		end if
	END IF
end if

ls_voyage_nr = dw_proceeding.getitemstring(1, "voyage_nr")
dw_proceeding.setitem(1, "port_order", wf_get_max_portorder(ls_voyage_nr))

dw_proceeding.setcolumn("voyage_nr")
/* Turn on redraw */
dw_proceeding.setredraw(TRUE)

dw_proceeding.getchild("port_code", idwc_portcode)
dw_proceeding.getchild("proc_text", idwc_proctext)
end event

event open;call super::open;n_service_manager		lnv_service_manager
n_dw_style_service	lnv_dwstyle

this.Move(0,0)
dw_proceeding_list.SetTransObject(SQLCA)
dw_proceeding.SetTransObject(SQLCA)
//dw_proceeding_list.ib_auto = true
dw_proceeding.GetChild("voyage_nr",dwc)
dwc.SetTransObject(SQLCA)
inv_autoschedule = create n_autoschedule
/* Function access control... */
/* administrators */       
if uo_global.ii_access_level = 3 then
	cb_options.of_modifymenuitem(il_deletevoyagenum, true)
	//cb_modify_voyagetype.visible=true     //due to CR2023
else
	cb_options.of_modifymenuitem(il_deletevoyagenum, false)
	//cb_modify_voyagetype.visible=false     //due to CR2023
end if
is_year = right(string(today(),'yyyy'), 2)
/* Administrator and Finance Profile */
/* open the feature for brostrom operators by JSU
need to be removed when the swopping vessel funtion is in place*/
integer li_bu_id
SELECT BU_ID
INTO :li_bu_id
FROM USERS
WHERE USERID = :uo_global.is_userid
;
COMMIT;


if uo_global.ii_access_level > 0 then
	cb_options.of_modifymenuitem(il_modifyvoyagenumbernum, true)
else
	cb_options.of_modifymenuitem(il_modifyvoyagenumbernum, false)
end if

uo_vesselselect.of_registerwindow( w_proceeding_list )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

//CR2413 Begin added by ZSW001 on 24/05/2012
uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)
//CR2413 End added by ZSW001 on 24/05/2012

lnv_service_manager.of_loadservice(lnv_dwstyle, "n_dw_style_service")
lnv_dwstyle.of_dwlistformater(dw_proceeding_list, false)

end event

event ue_delete;/********************************************************************
   event ue_delete( /*unsignedlong wparam*/, /*long lparam */)
   <DESC>   Called when a sigle proceeding is deleted</DESC>
   <RETURN> n/a</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   wparam: Not used
            lparam: Not used</ARGS>
   <USAGE>  on a button click event for example.</USAGE>
********************************************************************/

int li_vessel_number
string ls_voyage_nr
string ls_port_code
int li_pcn
long ll_row, ll_calc_id, ll_selectedrow
int li_count
boolean lb_last_proceeding = FALSE, lb_cancel 
mt_n_datastore lds_att
datetime ldt_procdate
long ll_att_row, ll_file_id, ll_voyagestart, ll_voyageend
n_voyage		lnv_voyage

IF dw_proceeding_list.RowCount() < 1 THEN return
ll_row = dw_proceeding_list.Getselectedrow(0)
li_vessel_number = ii_vessel_nr
/* The following is placed in the code because PB is acting strange */
if ll_row < 1 then
	messagebox("Notice","Please click a row before deleting.")
	return
end if

lds_att = create mt_n_datastore
lds_att.dataobject = "d_sq_tb_voyage_file_listing"
lds_att.settransobject(SQLCA)

ls_voyage_nr = dw_proceeding_list.GetItemString(ll_row,"voyage_nr")
ls_port_code = dw_proceeding_list.GetItemString(ll_row,"port_code")
li_pcn = dw_proceeding_list.GetItemNumber(ll_row,"pcn")
ldt_procdate = dw_proceeding_list.getitemdatetime(ll_row, "proc_date")
lb_cancel = (dw_proceeding_list.getitemnumber(ll_row, "cancel") = 1)
//sql
SELECT count(*) INTO :li_count
FROM POC
WHERE VESSEL_NR = :li_vessel_number AND
		VOYAGE_NR = :ls_voyage_nr AND
		PORT_CODE = :ls_port_code AND
		PCN       = :li_pcn;
IF (li_count > 0) THEN
	MessageBox("Delete Proceeding","You cannot delete this Proceeding, because there exists a Port Of Call.")
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
	return
END IF	

SELECT count(*) INTO :li_count
FROM POC_EST
WHERE VESSEL_NR = :li_vessel_number AND
		VOYAGE_NR = :ls_voyage_nr AND
		PORT_CODE = :ls_port_code AND
		PCN       = :li_pcn;
IF (li_count > 0) THEN
	MessageBox("Delete Proceeding","You cannot delete this Proceeding, because there exists an Estimated Port Of Call.")
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
	return
END IF	

SELECT count(*) INTO :li_count
FROM BP_DETAILS
WHERE VESSEL_NR = :li_vessel_number AND
		VOYAGE_NR = :ls_voyage_nr AND
		PORT_CODE = :ls_port_code AND
		PCN       = :li_pcn;
IF (li_count > 0) THEN
	MessageBox("Delete Proceeding","You cannot delete this Proceeding, because there exists a Bunker Purchase.")
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
	return
END IF	

/* Test to see if there is a disbursement an exit delete if there is */
SELECT count(*) INTO :li_count
FROM DISBURSEMENTS
WHERE VESSEL_NR = :li_vessel_number AND
		VOYAGE_NR = :ls_voyage_nr AND
		PORT_CODE = :ls_port_code AND
		PCN       = :li_pcn;
IF (li_count > 0) THEN
	MessageBox("Delete Proceeding","You cannot delete this Proceeding, because there exists a Disbursement.")
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
	return
END IF	

/* Test of idle days/off-services only make test if the portcode is the last unique code */
/* Idle days and off-services are linked with vessel, voyage, portcode (and not pcn) - therefore */
/* Test to see if there is a Idle days */
SELECT count(*) INTO :li_count
FROM PROCEED
WHERE VESSEL_NR = :li_vessel_number AND
		VOYAGE_NR = :ls_voyage_nr AND
		PORT_CODE = :ls_port_code;
IF (li_count = 1) THEN
	SELECT count(*) INTO :li_count
	FROM IDLE_DAYS
	WHERE VESSEL_NR = :li_vessel_number AND
			VOYAGE_NR = :ls_voyage_nr AND
			PORT_CODE = :ls_port_code;
	IF (li_count > 0) THEN
		MessageBox("Delete Proceeding","You cannot delete this Proceeding, because there exist Idle Days.")
		cb_delete.default = FALSE
		cb_new_proceeding.default = TRUE
		return
	END IF	
	
	/* Test to see if there is a Off Service */
	SELECT count(*) INTO :li_count
	FROM OFF_SERVICES
	WHERE VESSEL_NR = :li_vessel_number AND
			VOYAGE_NR = :ls_voyage_nr AND
			PORT_CODE = :ls_port_code;
	IF (li_count > 0) THEN
		MessageBox("Delete Proceeding","You cannot delete this Proceeding, because there exist Off Services.")
		cb_delete.default = FALSE
		cb_new_proceeding.default = TRUE
		return
	END IF	
END IF

IF MessageBox("Delete Proceeding","You are not cancelling this Proceeding.~r~n" + &
  							  "You are about to DELETE this Proceeding.~r~n" + &
							  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN 
	return
	cb_delete.default = FALSE
	cb_new_proceeding.default = TRUE
END IF
SELECT count(*)
INTO :li_count
FROM PROCEED
WHERE VESSEL_NR = :li_vessel_number AND
		VOYAGE_NR = :ls_voyage_nr;

if li_count = 1 then // last proceeding
	lb_last_proceeding = TRUE
	if wf_check_at_sea(li_vessel_number, ls_voyage_nr) = -1 then return
end if

/* If everything OK delete */ 
/* If last proceeding - delete whole voyage */
if lb_last_proceeding then 
	lnv_voyage = create n_voyage
	if not lb_cancel then//if the row has been canceled do not need do autoschedule
		if inv_autoschedule.of_checkautoschedule_proceeding(ii_vessel_nr, ls_voyage_nr, ldt_procdate) then
				inv_autoschedule.of_get_proceed_poc(ii_vessel_nr, is_year)
		end if
	end if
	IF lnv_voyage.of_deletevoyage(dw_proceeding_list) = 1 THEN
		IF dw_proceeding_list.DeleteRow(ll_row) = 1 THEN
			dw_proceeding_list.resetUpdate( )
			IF ll_row > 1 THEN
				dw_proceeding_list.Selectrow(0, FALSE)
				dw_proceeding_list.Selectrow(ll_row - 1, TRUE)
				dw_proceeding_list.Setrow(ll_row - 1)
				dw_proceeding_list.ScrolltoRow(ll_row - 1)
			ELSE
				cb_delete.enabled = FALSE
			END IF
			commit;
			if not lb_cancel then//if the row has been canceled do not need do autoschedule
				inv_autoschedule.of_distancechanged(ii_vessel_nr, ls_voyage_nr, is_year)
				__refresh_poc()
			end if
		ELSE
			rollback;
		END IF
	END IF

	destroy lnv_voyage
else
	/* if not last proceeding - only delete that line */
	IF dw_proceeding_list.DeleteRow(ll_row) = 1 THEN
		if not lb_cancel then//if the row has been canceled do not need do autoschedule
			if inv_autoschedule.of_checkautoschedule_proceeding(ii_vessel_nr, ls_voyage_nr, ldt_procdate) then
				 inv_autoschedule.of_get_proceed_poc(ii_vessel_nr, is_year)
			end if
		end if
		
		//reset port order
		__refresh_order(ls_voyage_nr)
		
		IF dw_proceeding_list.Update() = 1 THEN
			IF ll_row > 1 THEN
				dw_proceeding_list.Selectrow(0, FALSE)
				dw_proceeding_list.Selectrow(ll_row - 1, TRUE)
				dw_proceeding_list.Setrow(ll_row - 1)
				dw_proceeding_list.ScrolltoRow(ll_row - 1)
			ELSE
				cb_delete.enabled = FALSE
			END IF
			commit;
			if not lb_cancel then //if the row has been canceled do not need do autoschedule
				inv_autoschedule.of_distancechanged(ii_vessel_nr, ls_voyage_nr, is_year)
				__refresh_poc()
			end if
		ELSE
			rollback;
		END IF
	ELSE
		messageBox("Error","Delete failed.")
	END IF
end if

wf_set_calc_and_voyage_type(dw_proceeding_list.getselectedrow(0))

end event

event ue_retrieve;call super::ue_retrieve;long    ll_row,ll_findrow
integer li_pcn
string  ls_voyage_nr,ls_port_code,ls_find_str

datawindowchild ldwc_speed

dw_proceeding_list.setredraw(FALSE)

dw_proceeding_list.getChild("speed_display", ldwc_speed)
ldwc_speed.settransobject(sqlca)
ldwc_speed.retrieve(ii_vessel_nr)

dw_proceeding_list.getChild("cal_cons_id", ldwc_speed)
ldwc_speed.settransobject(sqlca)
ldwc_speed.retrieve(ii_vessel_nr)

dw_proceeding.getChild("cal_cons_id", ldwc_speed)
ldwc_speed.settransobject(sqlca)
ldwc_speed.retrieve(ii_vessel_nr)
ldwc_speed.setfilter("cal_cons_active = 1" )	
ldwc_speed.filter()

if rb_only_this_year.checked then 
   dw_proceeding_list.Retrieve(ii_vessel_nr,right(string(today(), 'yyyy'), 2))
else 
	dw_proceeding_list.Retrieve(ii_vessel_nr,'')
end if 

ll_row = dw_proceeding_list.RowCount()

IF ll_row > 0 THEN
	//if port of call list to open in proceeding retrieve
	if uo_global.getparm( ) = 1 then
		
		ls_voyage_nr = uo_global.getvoyage_nr( )
		ls_port_code = uo_global.getport_code( )
		li_pcn       = uo_global.getpcn( )
		
		ls_find_str = 	"voyage_nr = '" + ls_voyage_nr + &	
							"' and port_code = '" + ls_port_code + "'" + &
							" and pcn = " + string(li_pcn)
		
		ll_findrow = dw_proceeding_list.find(ls_find_str,1,ll_row)
		
		if ll_findrow > 0 then
			dw_proceeding_list.SelectRow(0,FALSE)
			dw_proceeding_list.SelectRow(ll_findrow,TRUE)
			dw_proceeding_list.post setrow(ll_findrow)
			dw_proceeding_list.ScrollToRow(ll_findrow)
		end if
		
		uo_global.setparm(0)
		
	else
		dw_proceeding_list.SelectRow(0,FALSE)
		dw_proceeding_list.SelectRow(ll_row,TRUE)
		dw_proceeding_list.setrow(ll_row)
		dw_proceeding_list.ScrollToRow(ll_row)
	end if
	
	cb_delete.enabled = TRUE
	
	if dw_proceeding_list.getselectedrow(0) > 0 then
		ll_row = dw_proceeding_list.getselectedrow(0)
	end if
	
	if isnull(dw_proceeding_list.getitemnumber(ll_row,"voyages_cal_calc_id"))  or &
		(dw_proceeding_list.getitemnumber(ll_row,"voyages_cal_calc_id") < 2) then
		cb_allocate.text = "&Allocate"
	else
		cb_allocate.text = "De-&Allocate"
	end if
	
	wf_set_calc_and_voyage_type(ll_row)
	
ELSE
	cb_options.of_modifymenuitem(il_updateportsnum, false)		
	cb_delete.enabled = FALSE
	st_calc.text = ""
END IF

if dw_proceeding_list.rowcount( ) > 0 then
	dw_proceeding_list.object.speed_display.current = dw_proceeding_list.object.cal_cons_id.current
end if

dw_proceeding_list.setredraw(TRUE)





end event

on w_proceeding_list.create
int iCurrent
call super::create
this.gb_voyagedetails=create gb_voyagedetails
this.dw_proceeding_list=create dw_proceeding_list
this.cb_new_proceeding=create cb_new_proceeding
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.dw_proceeding=create dw_proceeding
this.rb_all_voyages=create rb_all_voyages
this.rb_only_this_year=create rb_only_this_year
this.gb_1=create gb_1
this.st_calc=create st_calc
this.st_voyage_type=create st_voyage_type
this.cb_portslists=create cb_portslists
this.cb_refresh=create cb_refresh
this.cb_allocate=create cb_allocate
this.st_topbar_background=create st_topbar_background
this.cb_options=create cb_options
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_voyagedetails
this.Control[iCurrent+2]=this.dw_proceeding_list
this.Control[iCurrent+3]=this.cb_new_proceeding
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.dw_proceeding
this.Control[iCurrent+9]=this.rb_all_voyages
this.Control[iCurrent+10]=this.rb_only_this_year
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.st_calc
this.Control[iCurrent+13]=this.st_voyage_type
this.Control[iCurrent+14]=this.cb_portslists
this.Control[iCurrent+15]=this.cb_refresh
this.Control[iCurrent+16]=this.cb_allocate
this.Control[iCurrent+17]=this.st_topbar_background
this.Control[iCurrent+18]=this.cb_options
end on

on w_proceeding_list.destroy
call super::destroy
destroy(this.gb_voyagedetails)
destroy(this.dw_proceeding_list)
destroy(this.cb_new_proceeding)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.cb_1)
destroy(this.cb_cancel)
destroy(this.dw_proceeding)
destroy(this.rb_all_voyages)
destroy(this.rb_only_this_year)
destroy(this.gb_1)
destroy(this.st_calc)
destroy(this.st_voyage_type)
destroy(this.cb_portslists)
destroy(this.cb_refresh)
destroy(this.cb_allocate)
destroy(this.st_topbar_background)
destroy(this.cb_options)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_proceeding_list, "vessel_nr", "voyage_nr", True)

end event

event ue_vesselselection;call super::ue_vesselselection;if uo_global.getparm() = 1 then
	if left(uo_global.getvoyage_nr(),2) <> right(string(today(),"yyyy"),2) then
		rb_all_voyages.checked = true
		rb_only_this_year.checked = false
		rb_all_voyages.event clicked( )
		return
	end if
end if

postevent("ue_retrieve")

end event

event close;call super::close;dw_proceeding_list.accepttext()
if isvalid(inv_autoschedule) then destroy inv_autoschedule
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_proceeding_list
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_proceeding_list
integer x = 23
integer taborder = 10
end type

type gb_voyagedetails from groupbox within w_proceeding_list
integer x = 1797
integer width = 896
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Voyage Details"
end type

type dw_proceeding_list from u_datagrid within w_proceeding_list
event ue_show_modified ( )
event ue_mousemove pbm_dwnmousemove
event ue_retrieve ( integer ai_vesselnr )
integer x = 37
integer y = 256
integer width = 3387
integer height = 1968
integer taborder = 30
string dragicon = "images\DRAG.ICO"
string dataobject = "dw_proceeding_list"
boolean vscrollbar = true
boolean border = false
end type

event ue_show_modified();integer 	li_count, li_pcn
long 		ll_row
string		ls_port_code, ls_voyage_nr

ll_row = this.getRow()
ls_voyage_nr = dw_proceeding_list.GetItemString(ll_row,"voyage_nr")
ls_port_code = dw_proceeding_list.GetItemString(ll_row,"port_code")
li_pcn = dw_proceeding_list.GetItemNumber(ll_row,"pcn")

if this.getItemNumber(ll_row, "proceed_show_vp") = 0 then
	SELECT COUNT(*)
		INTO :li_count
		FROM POC_EST
		WHERE VESSEL_NR = :ii_vessel_nr AND 
			VOYAGE_NR = :ls_voyage_nr AND 
			PORT_CODE = :ls_port_code AND 
			PCN = :li_pcn;
	if li_count > 0 then
		MessageBox("Information", "There exists Estimated Port of Call data. Please delete them before changing via-point.")
		this.setItem(ll_row, "proceed_show_vp", 1)
		return
	end if
	SELECT COUNT(*)
		INTO :li_count
		FROM POC
		WHERE VESSEL_NR = :ii_vessel_nr AND 
			VOYAGE_NR = :ls_voyage_nr AND 
			PORT_CODE = :ls_port_code AND 
			PCN = :li_pcn;
	if li_count > 0 then
		MessageBox("Information", "There exists Actual Port of Call data. Please delete them before changing via-point.")
		this.setItem(ll_row, "proceed_show_vp", 1)
		return
	end if
end if		

end event

event ue_retrieve(integer ai_vesselnr);this.retrieve(ai_vesselnr)
end event

event itemchanged;call super::itemchanged;integer li_count, li_consumption, li_pos, li_flag = 0
string  ls_voyage_nr, ls_port_code
int     li_pcn, li_retval

datetime   ldt_procdate
decimal{2} ldc_speed, ldc_original_speed

mt_n_datastore  lds_proceed_by_vessel_by_voyage
u_tramos_nvo    uo_tram
n_portvalidator lnv_validator

if row < 1 then return

/* There are only 6 columns having taborder, and changes to only three of them triggers an action */
ls_voyage_nr = this.getitemstring(row, "voyage_nr")
ls_port_code = this.getitemstring(row, "port_code")
li_pcn       = this.getitemnumber(row, "pcn")
ldt_procdate = this.getitemdatetime(row, "proc_date")

uo_global.setvoyage_nr(ls_voyage_nr)
uo_global.setport_code(ls_port_code)
uo_global.setpcn(li_pcn)

choose case dwo.name
	case "proceed_show_vp" 
		
		if this.getitemnumber(row, "voyage_finished") = 1 or this.getitemnumber(row, "pcn") > 0 then return 2
		
		this.postevent ("ue_show_modified" )
		parent.post wf_proceedinglist_update()
		
	case "cancel" 
		
		if this.getitemnumber(row, "cancel") = 1 or this.getitemnumber(row, "voyage_finished") = 1 then return 2
		
		if MessageBox("Cancel","Set this proceeding Cancelled?",Question!,YesNo!,2) = 1 then
			
			if wf_cancelproceeding(row ) = 1 then
				
				parent.triggerEvent("ue_set_cancel_1")
				
				//check if need do autoschedule or not
				if inv_autoschedule.of_checkautoschedule_proceeding(ii_vessel_nr, ls_voyage_nr, ldt_procdate) then
					inv_autoschedule.of_get_proceed_poc(ii_vessel_nr, is_year)
				end if 
				
		      wf_proceedinglist_update()
				
				inv_autoschedule.of_distancechanged(ii_vessel_nr, ls_voyage_nr, is_year)
				
				__refresh_poc()
				
				return 
			else
				parent.PostEvent("ue_set_cancel_0")	
			end if
			
		else
			parent.PostEvent("ue_set_cancel_0")
		end if
		
		this.setrow(row)
		
		parent.post wf_proceedinglist_update()
		
	case "voyage_on_subs"
		
		if this.getitemnumber(row, "port_order") <> 1 then return 2
		
		if wf_set_voyage_on_subs(row,integer(data)) <> 1 then return
		
	case "cal_cons_id"
		
		if wf_check_speed(long(data)) <> c#return.success then return 2
		
		wf_speed_changed(dw_proceeding_list, row, long(data))
		
		ldc_original_speed = this.getitemnumber(row, "speed", primary!, true)
		ldc_speed          = this.getitemnumber(row, "speed")
		
		if ldc_speed <> ldc_original_speed then		
			inv_autoschedule.of_speedchanged(this, ii_vessel_nr, ls_voyage_nr, row, is_year)		
		end if
		
		this.setitem(row, "speed_display", long(data))
			
		wf_filter_speed(this)
		
      wf_proceedinglist_update()
		
		uo_global.setparm(1)
		
		__refresh_poc()

	case else
		wf_proceedinglist_update()
end choose






end event

event retrieveend;call super::retrieveend;long lrow, lmaxrow
string val, oldval

lmaxrow = this.rowcount()
if lmaxrow=0 then return

oldval = this.getitemstring(1,'voyage_nr')
for lrow = 2 to lmaxrow
	val = this.getitemstring(lrow,'voyage_nr')
	if val<>oldval then
		this.setitem(lrow,'isline',1)
		oldval = val
	end if
next
end event

event clicked;call super::clicked;s_chart_comment_parm	lstr_parm

il_draggedfrom = 0
il_draggedto = 0

if row > 0 then
	this.selectrow(0, false)
	this.selectrow(row, true)
	this.setrow(row)
	wf_set_calc_and_voyage_type(row)
	if isnull(this.getitemnumber(row, "voyages_cal_calc_id"))  or &
		(this.getitemnumber(row, "voyages_cal_calc_id") < 2) then
		cb_allocate.text = "&Allocate"
	else
		cb_allocate.text = "De-&Allocate"
	end if
		
	if dwo.name = "p_comment" then
		if not isvalid(w_chart_comment_popup) then
			lstr_parm.chart_nr = false
			lstr_parm.recid = this.getitemnumber(row, "voyages_cal_calc_id")
			openwithparm(w_chart_comment_popup, lstr_parm)
		end if
	end if
			
	if not (this.getitemnumber(row, "cancel") = 1 or this.getitemnumber(row, "voyage_finished") = 1) then
		if dwo.name = "port_order" then
			this.drag(begin!)
			il_draggedfrom = row
		end if		
	end if
	
end if

end event

event itemerror;call super::itemerror;MessageBox("Date Error Warning","You have set Acknowledge date earlier than Proceeding date.~r~nThis Date will be ignored.")
Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 and currentrow <> this.getselectedrow(0) then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	
	wf_set_calc_and_voyage_type(currentrow)
	
	if isnull(this.getitemnumber(currentrow, "voyages_cal_calc_id")) or &
		(this.getitemnumber(currentrow, "voyages_cal_calc_id") < 2) then
		cb_allocate.text = "&Allocate"
	else
		cb_allocate.text = "De-&Allocate"
	end if

end if

wf_filter_speed(this)


end event

event dragdrop;this.modify("r_position.visible = 0")
end event

event dragenter;call super::dragenter;this.modify("r_position.visible = 0")
end event

event dragwithin;call super::dragwithin;long		ll_count, ll_row, ll_min, ll_max, ll_rowpos
string	ls_voyagenr, ls_modify, ls_band


ll_count = this.rowcount()
ls_voyagenr = this.getitemstring(il_draggedfrom, "voyage_nr")
ll_min = this.find("voyage_nr = '" + ls_voyagenr + "'", 1, ll_count)
ll_max = this.find("voyage_nr = '" + ls_voyagenr + "'", ll_count, 1)
ll_row = row	

il_draggedto = 0

if ll_row  < il_draggedfrom  then
	ll_row --
end if	

if row <= 0 then
	ls_band = this.getbandatpointer()
	if left(ls_band, 6) = "footer" or left(ls_band, 6) = "detail" or left(ls_band, 10) = "foreground" then
		ll_row = long(this.describe("evaluate('last(getrow() for page)', 0)"))
	end if
end if

ll_rowpos = ll_row * il_detailheight - long(this.describe("datawindow.verticalscrollposition"))
if ll_rowpos >= 0 then
	if (ll_min <= ll_row and ll_row <= ll_max and ll_row > 0  or ll_min - ll_row = 1) then 
		ls_modify += "r_position.brush.color = 134217856 "
		il_draggedto = ll_row
	else
		ls_modify += "r_position.brush.color = 10789024 "
	end if
	if il_draggedfrom = row then
		ls_modify += "r_position.visible = 0 r_position.y = " + string(il_headerheight + ll_rowpos)
	else
		ls_modify += "r_position.visible = 1 r_position.y = " + string(il_headerheight + ll_rowpos)
	end if
	this.modify(ls_modify)
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;long	  ll_vesselnr, ll_voyagestart, ll_voyageend, ll_count, ll_targetrow
integer li_pcn
string	ls_voyagenr, ls_modify, ls_port_code, ls_band
datetime ldt_new_procdate, ldt_original_procdate
datetime ldt_procdate_list[]
pointer lp_oldpointer

ls_band = this.getbandatpointer()
if left(ls_band, 10) = "background" then
	this.modify("r_position.visible = 0")
	return
end if

if il_draggedfrom = 0 or il_draggedto = 0  or il_draggedfrom = il_draggedto  or il_draggedfrom - il_draggedto = 1 then
	this.modify("r_position.visible = 0")
	return
end if

this.setredraw(false)

ls_voyagenr = this.getitemstring(il_draggedfrom, "voyage_nr")
ls_port_code = this.getitemstring(il_draggedfrom, "port_code")
li_pcn = this.getitemnumber(il_draggedfrom, "pcn")

ll_count = this.rowcount()
ll_voyagestart = this.find("voyage_nr = '" + ls_voyagenr + "'", 1, ll_count)
ll_voyageend 	= this.find("voyage_nr = '" + ls_voyagenr + "'", ll_count, 1)

ldt_procdate_list = this.object.proc_date[ll_voyagestart, ll_voyageend]

if il_draggedto >= ll_voyagestart and il_draggedto <= ll_voyageend or ll_voyagestart - il_draggedto = 1 then
	
	lp_oldpointer = setpointer(HourGlass!)
	
	if il_draggedto >= il_draggedfrom then  //drag down
		ll_targetrow = il_draggedto	
	else												// drag up
		ll_targetrow = il_draggedto + 1		
	end if
	
	if __checkdragged(il_draggedfrom, ll_targetrow, ll_voyageend) =  c#return.Success then
		
		//check if need do autoschedule or not
		ldt_new_procdate = this.getitemdatetime(ll_targetrow, "proc_date")
		ldt_original_procdate = this.getitemdatetime(il_draggedfrom, "proc_date", primary!, true)
		if inv_autoschedule.of_checkautoschedule_proceeding(ii_vessel_nr, ls_voyagenr, ldt_original_procdate, ldt_new_procdate) then 
			inv_autoschedule.of_get_proceed_poc(ii_vessel_nr, is_year)
		end if
		
		//finished the drag data change
		this.rowsmove(il_draggedfrom, il_draggedfrom, Primary!, this, il_draggedto + 1, Primary!)
		this.object.proc_date[ll_voyagestart, ll_voyageend] = ldt_procdate_list
		__refresh_order(ls_voyagenr)

		//update data
		wf_proceedinglist_update()
		inv_autoschedule.of_distancechanged(ii_vessel_nr, ls_voyagenr, is_year)
		
		uo_global.setvoyage_nr(ls_voyagenr)
		uo_global.setport_code(ls_port_code)
		uo_global.setpcn(li_pcn)
		uo_global.setparm(1)
		
		//refresh data
		parent.triggerevent("ue_retrieve")
		__refresh_poc()
		
		setpointer(lp_oldpointer)

	end if
end if

il_draggedfrom = 0
il_draggedto = 0

this.modify("r_position.visible = 0")
this.setredraw(true)


end event

event constructor;call super::constructor;il_headerheight = long(this.describe("datawindow.header.height"))
il_detailheight = long(this.describe("datawindow.detail.height"))

this.modify("speed_display.width = '0~tlong(describe(~"cal_cons_id.width~"))' speed_display.x = '0~tlong(describe(~"cal_cons_id.x~"))'")
this.modify("datawindow.processing = '0' speed_display.visible = '1~tif(currentRow() = getrow(), 0, 1)' datawindow.processing = '1'")
this.modify("datawindow.processing = '0' cal_cons_id.visible = '0~tif(currentRow() = getrow(), 1, 0)' datawindow.processing = '1'")


end event

event rbuttondown;call super::rbuttondown;il_draggedto = 0
this.modify("r_position.visible = 0")
end event

type cb_new_proceeding from commandbutton within w_proceeding_list
integer x = 2048
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
boolean default = true
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this function.")
	Return
END IF

/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

parent.TriggerEvent("ue_insert")


end event

type cb_update from commandbutton within w_proceeding_list
integer x = 2395
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Update"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this function.")
	Return
END IF

parent.TriggerEvent("ue_update")

end event

type cb_delete from commandbutton within w_proceeding_list
integer x = 2743
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this function.")
	Return
END IF

/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

parent.TriggerEvent("ue_delete")

end event

type cb_1 from commandbutton within w_proceeding_list
integer x = 3081
integer y = 32
integer width = 343
integer height = 100
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;string ls_bcolor, modstring
/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if
if dw_proceeding_list.rowcount() < 1 then
	messagebox("Notification","There are no Proceedings to Print.")
	return
end if
dw_proceeding_list.setredraw(false)
ls_bcolor = dw_proceeding_list.Describe("datawindow.color")
dw_proceeding_list.Modify("datawindow.Color=16777215")
dw_proceeding_list.modify("vessels_vessel_name.visible=1")
dw_proceeding_list.Modify("datawindow.Header.Height=165")
dw_proceeding_list.print()
modstring = "datawindow.Color="+ls_bcolor
dw_proceeding_list.Modify(modstring)
dw_proceeding_list.modify("vessels_vessel_name.visible=0")
dw_proceeding_list.Modify("datawindow.Header.Height=69")
dw_proceeding_list.setredraw(true)

end event

type cb_cancel from commandbutton within w_proceeding_list
integer x = 3090
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Cancel"
end type

event clicked;uo_vesselselect.enabled = TRUE
cb_update.enabled = FALSE
dw_proceeding_list.enabled = TRUE
cb_new_proceeding.enabled = TRUE
cb_cancel.enabled = FALSE
cb_delete.enabled = TRUE
dw_proceeding.Reset()
dw_proceeding_list.SelectRow(0,FALSE)
dw_proceeding_list.SelectRow(dw_proceeding_list.RowCount(),TRUE)
dw_proceeding_list.ScrollToRow(dw_proceeding_list.RowCount())
dw_proceeding_list.SetFocus()
cb_new_proceeding.default = TRUE
dw_proceeding.Modify("port_code.TabSequence=22")
dw_proceeding.SetTabOrder("proc_text",35)
/* Enable allocate button */
cb_allocate.enabled = True

wf_set_calc_and_voyage_type(dw_proceeding_list.getselectedrow(0))

end event

type dw_proceeding from mt_u_datawindow within w_proceeding_list
event ue_posted_tab pbm_custom08
integer x = 37
integer y = 2252
integer width = 2409
integer height = 76
integer taborder = 40
string dataobject = "dw_proceeding"
boolean border = false
end type

on ue_posted_tab;call mt_u_datawindow::ue_posted_tab;string ls_null
setnull(ls_null)
dw_proceeding.setitem(1,"port_code",ls_null)
dw_proceeding.setitem(1,"proc_text",ls_null)
dw_proceeding.setcolumn("port_code")
dw_proceeding.setfocus()

end on

event itemchanged;call super::itemchanged;
string		ls_proc_text, ls_searchstring, ls_port_code , ls_voyage_nr, ls_null, ls_speedexp
string		ls_port_code_array[], ls_port_name,ls_return,ls_fix_port_name, ls_portcode
string		ls_act_ports[],ls_est_ports[], ls_next_port, ls_port_text
long			ll_calc_id, ll_found, ll_contype, ll_sel_row
long			ll_act_pos = 1,ll_ub_est,ll_ub_act, ll_est_counter, ll_act_counter, ll_found_at
datetime		ldt_null
decimal{2}	ld_port_exp[], ld_est_port_exp[]
int			li_estimated_ports, li_retval, li_counter, li_pos
Boolean		lb_admin = FALSE, lb_stop = TRUE
boolean		lb_boolean, lb_found
long			ll_null

datawindowchild	dwc1, dwc2
datawindowchild	dwc_proc_text
u_calc_nvo			uo_calc_nvo
u_tramos_nvo		uo_tram
n_portvalidator	lnv_validator

setnull(ldt_null)
setnull(ll_null)

this.accepttext()

IF uo_global.ii_access_level = 3 THEN lb_admin = TRUE
setnull(ls_null)
CHOOSE CASE dw_proceeding.GetColumnName()
	CASE "port_code"
		ls_port_code = dw_proceeding.GetText()
		/* Ports marked as inactice shall not be accepted */
		ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_port_code+"'", 1, 99999)
		if ll_found > 0 then
			if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "port_active") = 0 then
				Messagebox("Port Code Selection", "The selected portcode '"+ls_port_code+"' is inactive. Please select another port.")
				this.POST setcolumn( "port_code" )
				Return 2
			end if
		end if
		// START - Added by FR 04-11-02, IT SHOULD ONLY BE POSSIBLE TO SELECT PORT CODES WITH 3 IN LENGTH
		IF (len(ls_port_code) <> 3) then
			Messagebox("Port Code Selection", "For proceeding please select a port code with length 3 of characters.")
			this.POST setcolumn( "port_code" )
			Return 2
		end if
		// END - Added by FR 04-11-02, IT SHOULD ONLY BE POSSIBLE TO SELECT PORT CODES WITH 3 IN LENGTH		
		/* get voyage number */
		ls_voyage_nr = getitemstring(1,"voyage_nr")
		IF ls_port_code <> "(none)" THEN
			SELECT PORT_N INTO :ls_proc_text FROM PORTS WHERE PORT_CODE = :ls_port_code and PORT_CODE <> '';
			IF SQLCA.SQLCode = 0 THEN
				dw_proceeding.SetItem(1,"proc_text",ls_proc_text)
 				dw_proceeding.SetTabOrder("proc_text",0)
			ELSE
				MessageBox("Error","Port Code not found, try another code.")
				this.postevent("ue_posted_tab")
				return 2
			END IF
		END IF		

		/* get calc id */
		SELECT CAL_CALC_ID
		INTO :ll_calc_id	
		FROM VOYAGES
		WHERE 	VESSEL_NR = :ii_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr;
		commit;
		if isnull(LL_calc_id) OR LL_CALC_ID = 0 then dw_proceeding.setitem(1,"input_dt",now())
		/* If calc id is not null then... */
		if not isnull(ll_calc_id) and ll_calc_id <> 0 and ll_calc_id <> 1 then
			wf_get_contypeid("port_code")
			/* create calc nvo */
			uo_calc_nvo = create u_calc_nvo
			/* see if port is on calc */
			lb_boolean = uo_calc_nvo. uf_is_port_on_calc(ll_calc_id , ls_port_code )
			/* if port code is not in the calcs list, then */
			if not lb_boolean then
				/* Inform user of error */
				messagebox("Warning","Port is not on a Calculation.~r~n This can corrupt the system.")
				IF lb_admin THEN
					dw_proceeding.setitem(1,"input_dt",ldt_null)
				ELSE
					dw_proceeding.setitem(1,"input_dt",now())
				END IF
//				dw_proceeding.setitem(1,"fwo",1)
			else
				dw_proceeding.setitem(1,"input_dt",ldt_null)
			end if
			/* destroy calc nvo */
			destroy uo_calc_nvo
		end if
	CASE "proc_text"		
		ls_proc_text = dw_proceeding.GetText()
		//IF (ls_proc_text = "(none)") OR IsNull(ls_proc_text) THEN Return
		/* get voyage number */
		ls_voyage_nr = getitemstring(1,"voyage_nr")
		dw_proceeding.GetChild("proc_text",dwc_proc_text)
//		ls_searchstring = "port_n = '"+ls_proc_text+"'"
//		IF dwc_proc_text.DwFind(ls_searchstring,1,dwc.RowCount()) > 0 THEN
		SELECT PORT_CODE INTO :ls_port_code FROM PORTS WHERE PORT_N = :ls_proc_text;
		commit;
		IF SQLCA.SQLCode = 0 THEN
			/* Ports marked as inactice shall not be accepted */
			ll_found = w_share.dw_calc_port_dddw.find("port_code='"+ls_port_code+"'", 1, 99999)
			if ll_found > 0 then
				if w_share.dw_calc_port_dddw.getItemNumber(ll_found, "port_active") = 0 then
					Messagebox("Port Code Selection", "The selected portcode '"+ls_port_code+"' is inactive. Please select another port.")
					this.POST setcolumn( "port_code" )
					Return 2
				end if
			end if
			// START - Added by FR 04-11-02, IT SHOULD ONLY BE POSSIBLE TO SELECT PORT CODES WITH 2 IN LENGTH
			IF (len(ls_port_code) <> 3) then
				Messagebox("Port Code Selection", "For Proceeding please select a port code with length 3 of characters.")
				Return 2
			end if
			// END - Added by FR 04-11-02, IT SHOULD ONLY BE POSSIBLE TO SELECT PORT CODES WITH 2 IN LENGTH	
			dw_proceeding.SetItem(1,"port_code",ls_port_code)
 			dw_proceeding.SetTabOrder("proc_text",0)
		END IF
		/* get calc id */
		SELECT CAL_CALC_ID
		INTO :ll_calc_id	
		FROM VOYAGES
		WHERE 	VESSEL_NR = :ii_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr;
		commit;
		if isnull(ll_calc_id) OR ll_calc_id = 0 then dw_proceeding.setitem(1,"input_dt",now())
		/* If calc id is not null then... */
		if not isnull(ll_calc_id) and ll_calc_id <> 0 and ll_calc_id <> 1 then
			wf_get_contypeid("proc_text")		
			/* create calc nvo */
			uo_calc_nvo = create u_calc_nvo
			/* see if port is on calc */
			lb_boolean = uo_calc_nvo. uf_is_port_on_calc(ll_calc_id , ls_port_code )
			/* if port code is not in the calcs list, then */
			if not lb_boolean then
				/* Inform user of error */
				messagebox("Warning","Port is not on a Calculation.~r~n This can corrupt the system.")
				IF lb_admin THEN
					dw_proceeding.setitem(1,"input_dt",now())
				ELSE
					dw_proceeding.setitem(1,"input_dt",ldt_null)
				END IF
//				dw_proceeding.setitem(1,"fwo",1)
			else
				dw_proceeding.setitem(1,"input_dt",ldt_null)
			end if
			/* destroy calc nvo */
			destroy uo_calc_nvo
		end if
	CASE "voyage_nr"
		setnull(ll_calc_id)
		dw_proceeding.setitem(1,"port_code",ls_null)
		dw_proceeding.setitem(1,"proc_text",ls_null)
		dw_proceeding.SetTabOrder("port_code",0)
		dw_proceeding.SetTabOrder("proc_text",35)
		dw_proceeding.setitem(1, "cal_cons_id", ll_null)
		dw_proceeding.setitem(1, "speed", ll_null)
		dw_proceeding.setitem(1, "consumption", ll_null)
		dw_proceeding.setitem(1, "speed_instr", ls_null)
		ls_voyage_nr = dw_proceeding.GetText()		
		IF (ls_voyage_nr = "") OR IsNull(ls_voyage_nr) THEN Return
		SELECT CAL_CALC_ID
		INTO :ll_calc_id	
		FROM VOYAGES
		WHERE 	VESSEL_NR = :ii_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr;
		commit;
		dw_proceeding.GetChild("port_code",dwc1)
		dw_proceeding.GetChild("proc_text",dwc2)
		dwc1.settransobject(sqlca)
		dwc2.settransobject(sqlca)
		if isnull(ll_calc_id) or ll_calc_id = 1 then
			dw_proceeding.SetTabOrder("port_code",34)
			uf_sharechild("dw_ports_list",dwc1)
			uf_sharechild("dw_port_name_list_share",dwc2)
			lb_stop = FALSE			
		elseif lb_admin then
			dwc1.sharedataoff()
			dwc2.sharedataoff()
			dwc1.reset()
			dwc2.reset()	
			if f_AtoBviaC_used(ii_vessel_nr,ls_voyage_nr) then
				li_estimated_ports = wf_get_estimated_route( ll_calc_id, ls_port_code_array)
			else
				li_estimated_ports = wf_get_vv_estimated_port_exp_port_array(ii_vessel_nr,ls_voyage_nr,ls_port_code_array,ld_port_exp)
			end if
			for li_counter = 1 to li_estimated_ports
				dwc1.insertrow(0)
				dwc1.setitem(li_counter,1,ls_port_code_array[li_counter])				
				dwc2.insertrow(0)
				dwc2.setitem(li_counter,2,ls_port_code_array[li_counter])		
			     IF IsNull(ls_port_code_array[li_counter]) OR ls_port_code_array[li_counter] = "" THEN
				ls_port_name = "No Code (Viap/canal)"
			     ELSE	
				SELECT PORTS.PORT_N  
				INTO :ls_port_name
				FROM PORTS  
				WHERE PORTS.PORT_CODE = :ls_port_code_array[li_counter];
				COMMIT;
			     END IF
				dwc1.setitem(li_counter,2,ls_port_name)
				dwc2.setitem(li_counter,1,ls_port_name)
			next
			dw_proceeding.SetTabOrder("port_code",34)
		  elseif Not(lb_admin) then
				if f_AtoBviaC_used(ii_vessel_nr,ls_voyage_nr) then
					lnv_validator = create n_portvalidator
					li_retval		= lnv_validator.of_start( "PROCITEMCHANGED", ii_vessel_nr, ls_voyage_nr, 3, ls_portcode)
					ll_contype 		= lnv_validator.il_contypeid  
					destroy lnv_validator
				else
					uo_tram = CREATE u_tramos_nvo
					ls_return = uo_tram.uf_check_proceed_itenerary(ii_vessel_nr,ls_voyage_nr,TRUE)
					DESTROY uo_tram
					if ls_return = "-1" then
						li_retval=c#return.Failure
					elseif ls_return = "0" then
						li_retval=c#return.NoAction
					elseif ls_return = "1" then
						li_retval=c#return.Success
					else	
						ls_portcode = ls_return
					end if
				end if
				if li_retval=c#return.Failure then
					cb_cancel.triggerevent(clicked!)
				elseif li_retval=c#return.Success then
					MessageBox("Finished?","There are no more ports in itinerary without proceedings.")
					cb_cancel.triggerevent(clicked!)
				else
					dw_proceeding.SetItem(1,"port_code",ls_portcode)
					dw_proceeding.setitem(1, "cal_cons_id", ll_contype)
					SELECT PORTS.PORT_N
					INTO :ls_fix_port_name
					FROM PORTS
					WHERE PORT_CODE = :ls_portcode;
					dw_proceeding.SetItem(1,"proc_text",ls_fix_port_name)
					dw_proceeding.SetTabOrder("port_code",0)
					dw_proceeding.SetTabOrder("proc_text",0)
				end if
				lb_stop = false			
		  end if
		IF lb_stop THEN
			/* Set next proceeding port default from calculation */
			ll_ub_est = wf_get_vv_estimated_port_exp_port_array(ii_vessel_nr,ls_voyage_nr,ls_est_ports,ld_est_port_exp)
			ll_ub_act = wf_get_vv_actual_proc_port_array(ii_vessel_nr,ls_voyage_nr,ls_act_ports)
			for ll_est_counter = 1 to ll_ub_est
				lb_found = false
				for ll_act_counter = ll_act_pos to ll_ub_act
					if ls_act_ports[ll_act_counter] = ls_est_ports[ll_est_counter] then
						lb_found = true
						ll_found_at = ll_act_counter
						ll_act_counter = ll_ub_act
					end if
				next
				if lb_found then
					ll_act_pos = ll_found_at + 1
					ls_next_port = ls_null
				else
					ls_next_port 	= ls_est_ports[ll_est_counter]
					ll_est_counter = ll_ub_est
				end if
			next
			select PORT_N
			into :ls_port_text
			from PORTS
			where PORT_CODE = :ls_next_port;
			commit;
			dw_proceeding.setitem(1, "port_code", ls_next_port)		
			dw_proceeding.setitem(1, "proc_text", ls_port_text)
			dw_proceeding.setitem(1, "cal_cons_id", ll_contype)
		end if
		
		dw_proceeding.setitem(1, "port_order", wf_get_max_portorder(ls_voyage_nr))
		
	case "cal_cons_id"
		wf_filter_speed(this)
		wf_speed_changed(dw_proceeding, row, long(data))
	case "port_order"
		if long(data) <= 0 then
			this.post setitem(1, "port_order", 1)
		end if
		
END CHOOSE


end event

on clicked;call mt_u_datawindow::clicked;this.selectrow(0,false)
end on

type rb_all_voyages from radiobutton within w_proceeding_list
integer x = 1317
integer y = 64
integer width = 370
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "All"
end type

event clicked;/* Local Variables */
/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if
is_year = ''
parent.triggerevent("ue_retrieve")

end event

type rb_only_this_year from radiobutton within w_proceeding_list
integer x = 1317
integer y = 128
integer width = 439
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Only This Year"
boolean checked = true
end type

event clicked;/* Local Variables */

/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if
is_year = right(string(today(),'yyyy'), 2)
parent.triggerevent("ue_retrieve")




end event

type gb_1 from groupbox within w_proceeding_list
integer x = 1275
integer width = 489
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Show Voyages"
end type

type st_calc from statictext within w_proceeding_list
integer x = 1847
integer y = 64
integer width = 809
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Calc:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_voyage_type from statictext within w_proceeding_list
integer x = 1847
integer y = 128
integer width = 809
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
boolean enabled = false
string text = "Voyage Type:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_portslists from commandbutton within w_proceeding_list
boolean visible = false
integer x = 2615
integer y = 2248
integer width = 343
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Ports lists"
end type

on clicked;open(w_update_proceed)
end on

type cb_refresh from commandbutton within w_proceeding_list
integer x = 2734
integer y = 32
integer width = 343
integer height = 100
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if
parent.SetRedraw(FALSE)
parent.PostEvent("ue_retrieve")
parent.SetRedraw(TRUE)

end event

type cb_allocate from commandbutton within w_proceeding_list
integer x = 1701
integer y = 2352
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Allocate"
end type

event clicked;/************************************************************************************
 Author    : Peter Bendix-Toft
 Date       : 30-07-96
 Description : Allocate to calculation: open the voyage window if there are no cargoes on the
			voyage, and only if the voyage does not already have
			 a calculation.
			De-Allocate calculation: de-allocates a voyage from calculation if there´s no 
								Port of Calls or claims.
 Arguments : {description/none}
 Returns   : {description/none}  
 Variables : {important variables - usually only used in Open-event scriptcode}
 Other : {other comments}
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
30-07-96 		3.0			PBT		system 3 Modification
09-01-96							BO			appending disallocating-facility
								 				to the command button.
************************************************************************************/

long ll_row_nr , ll_calc_id , ll_ret_code , ll_temp_counter,ll_new_vessel
string ls_text, ls_voyage_notes, ls_update_voyage_notes, ls_rollback = "rollback transaction",ls_update_proceed, ls_begin_tran = "begin transaction",ls_end_tran = "commit transaction"
string ls_update_voy, ls_names
boolean lb_port_of_calls, lb_claims
datetime ld_date

s_voyage_return lstr_return
s_vessel_voyage lstr_ves_voy
n_auto_proceeding	lnv_auto_proceeding
n_object_usage_log lnv_uselog

lstr_return.ab_autocreateproceeding = false

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this function.")
	Return
END IF

/* Test to see if intergration is turned on or off */
if NOT gb_tram_calc_is_interfaced then
messagebox("Warning","Tramos has not been interfaced to Calculation module yet.")
return
end if

/* get highlighted row */
ll_row_nr = dw_proceeding_list.getrow()

/* If no row return */
if ll_row_nr = 0 then return

/* get vessel and voyage numbers and voyage_type */
lstr_ves_voy.vessel_nr = dw_proceeding_list.getitemnumber(ll_row_nr,"vessel_nr")
lstr_ves_voy.voyage_nr = dw_proceeding_list.getitemstring(ll_row_nr,"voyage_nr")
lstr_ves_voy.new = FALSE
lstr_ves_voy.type_name = "Allocated"


/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

choose case this.text
	case "&Allocate"
		/*Here comes the allocation part*/
		/* if voyage is a TC Out, return */
		if dw_proceeding_list.getitemnumber(ll_row_nr,"voyages_voyage_type") = 2 then return
		/* get calc id for vessel - voyage */
		SELECT CAL_CALC_ID
		INTO :ll_calc_id	
		FROM VOYAGES
		WHERE 	VESSEL_NR = :lstr_ves_voy.vessel_nr AND
				VOYAGE_NR = :lstr_ves_voy.voyage_nr;
		commit;
		/* If voyage has real calc id, return */
		if ll_calc_id > 1 then return
		/* Test to see if there are cargo's on the voyage, return if there are */
		SELECT COUNT(*)
		INTO :ll_temp_counter
		FROM CARGO
		WHERE 	VESSEL_NR = :lstr_ves_voy.vessel_nr and
				VOYAGE_NR = :lstr_ves_voy.voyage_nr;
		commit;
		if ll_temp_counter > 0 then
			messagebox("Notice", "You cannot allocate this voyage to a calculation, because there is cargo registered.")
			return
		end if
		/* if there is a calc id, return */  //and not ll_calc_id = 0 then return
		if not isnull(ll_calc_id ) and not ll_calc_id = 1 then 	return
		/* open window to modify voyage */	
		OpenWithParm(w_voyage,lstr_ves_voy)
		lstr_return = message.powerobjectparm
		ll_ret_code = lstr_return.al_return		
		
		/* If return code from voyage window is -1, then cancel update and quit */
			
		/* if ret code is -1or 0  (cancel of window or no calc chosen ) then return */
		if ll_ret_code = -1 or ll_ret_code = 0 then return
		/*Set button text */
		this.text = "De-&Allocate"
		// Set input_dt = NULL if port on calc, so that cargo is allowed. Leith ver 4.05 30/6-97
		SELECT CAL_CALC_ID
		INTO :ll_calc_id	
		FROM VOYAGES
		WHERE 	VESSEL_NR = :lstr_ves_voy.vessel_nr AND
				VOYAGE_NR = :lstr_ves_voy.voyage_nr;
		commit;
		if f_AtoBviaC_used(lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr) then
			//
		else
			wf_set_viap_pcn(lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr)
		end if
		wf_set_input_dt(ll_calc_id, lstr_ves_voy.vessel_nr,lstr_ves_voy.voyage_nr)
		
		if lstr_return.ab_autocreateproceeding then
			// log activity
			lnv_uselog.uf_log_object("Auto-create Proceedings")
			lnv_auto_proceeding = create n_auto_proceeding
			lnv_auto_proceeding.of_auto_proceeding(lstr_ves_voy.vessel_nr, lstr_ves_voy.voyage_nr)
			destroy lnv_auto_proceeding
			__refresh_poc()
		end if			
	case "De-&Allocate"
		/*If there is Port of Calls where purpos= L,D or L/D*/
		SELECT isnull(COUNT(PURPOSE_CODE),0)
		into :lb_port_of_calls
		FROM POC
		WHERE 	VOYAGE_NR=:lstr_ves_voy.voyage_nr AND 
				VESSEL_NR=:lstr_ves_voy.vessel_nr AND 
				(PURPOSE_CODE='L' OR PURPOSE_CODE='D' or PURPOSE_CODE = "L/D");
		commit;
		if lb_port_of_calls then
			Messagebox("Notification","You cannot de-allocate, there are registered Port of Calls on this voyage.")
			rollback;
			return
		end if

		/*If there is Claims*/
		SELECT isnull(COUNT(VESSEL_NR),0)
		into :lb_claims
		FROM CLAIMS
		WHERE VOYAGE_NR=:lstr_ves_voy.voyage_nr AND VESSEL_NR=:lstr_ves_voy.vessel_nr;
		commit;
		if lb_claims then
			Messagebox("Notification","You cannot de-allocate, there are registered Claims on this voyage.")
			rollback;
			return
		end if

		/* Give the user a chance to stop the action,default=No */
		if Messagebox("Warning","You are about to de-allocate Voyage Number "  +lstr_ves_voy.voyage_nr+&
					 ". All proceedings on this voyage will be redefined as non-cargo ports."+&
					"~r~nDo you want to do this?",Question!,yesNo!,2) = 1 then 
			EXECUTE IMMEDIATE :ls_begin_tran using sqlca;
			/*Modify in Proceeding,Insert date + time, where inputdt = null*/
	       		ld_date =datetime(today(),now())
			ls_update_proceed = "UPDATE PROCEED SET  INPUT_DT = '" + string(ld_date,"mm-dd-yy hh:mm") +"'  WHERE VESSEL_NR= " +string(lstr_ves_voy.vessel_nr) + "AND VOYAGE_NR= '" +lstr_ves_voy.voyage_nr+"' AND INPUT_DT= NULL"
			EXECUTE IMMEDIATE: ls_update_proceed using sqlca;
			if sqlca.sqlcode <> 0 then
				messagebox("De-allocation Error1","The Voyage has not been de-allocated from a calculation."+&
							" The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " &
							+ sqlca.sqlerrtext)
				EXECUTE IMMEDIATE:ls_rollback using sqlca;
				return
			end if						
			 /*Modify in Voyage-table, set cal_calc_id=null*/
			ls_update_voy = "UPDATE VOYAGES SET  CAL_CALC_ID = null  WHERE VESSEL_NR= " +string(lstr_ves_voy.vessel_nr) + "AND VOYAGE_NR= '" +lstr_ves_voy.voyage_nr+"'"
			EXECUTE IMMEDIATE: ls_update_voy using sqlca;
			if sqlca.sqlcode <> 0 then
				messagebox("De-allocation Error2","The Voyage has not been de-allocated from a calculation."+&
							" The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = "&
							 + sqlca.sqlerrtext)
				EXECUTE IMMEDIATE:ls_rollback using sqlca;
				return			
			end if						
		
			/* Here comes the part where we insert some text about the de_allocation in the voyages table */	
			SELECT FIRST_NAME + " " + LAST_NAME INTO :ls_names FROM USERS WHERE USERID=:uo_global.is_userid;
			ls_text=" ~r~nSystem Message:The voyage was de-allocated from a calculation on the "+string(today())  + " by "+ls_names
			/*We get the field voyage_notes */
			SELECT VOYAGE_NOTES INTO :ls_voyage_notes  FROM VOYAGES WHERE VOYAGE_NR=' :lstr_ves_voy.vessel_nr+'  AND VESSEL_NR= :ll_new_vessel;
			If IsNull(ls_voyage_notes) Then ls_voyage_notes = ""
			/* We append our text about the change of voyagenumber to the text already written in the field */
			ls_voyage_notes= ls_voyage_notes + ls_text
			ls_update_voyage_notes="UPDATE VOYAGES SET VOYAGE_NOTES ='"+ls_voyage_notes+"'  WHERE VOYAGE_NR='"+lstr_ves_voy.voyage_nr+"' AND VESSEL_NR="+string(lstr_ves_voy.vessel_nr)
			EXECUTE IMMEDIATE: ls_update_voyage_notes using sqlca;
			if sqlca.sqlcode <> 0 then
				messagebox("De-allocation Error3","The Voyage has not been de-allocated from a calculation."+&
							" The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = "&
							 + sqlca.sqlerrtext)
				EXECUTE IMMEDIATE:ls_rollback using sqlca;
				/* Set pointer back to arrow */
				setpointer(arrow!)
				return
			end if
		Messagebox("Notification","The de-allocation was completed succesfully.")
		EXECUTE IMMEDIATE :ls_end_tran using sqlca;
		/*end if*/
		end if
	/*Set button text*/
	this.text =  "&Allocate"	
	__refresh_poc()
end choose

/* Re-Retrieve proceeding list dw */
parent.triggerevent("ue_retrieve")
		

end event

type st_topbar_background from u_topbar_background within w_proceeding_list
integer height = 232
end type

type cb_options from u_cb_option within w_proceeding_list
integer x = 37
integer y = 2352
integer taborder = 60
boolean bringtotop = true
string text = "Options >>"
end type

event constructor;call super::constructor;il_modifyvoyagetypenum   = of_addmenuitem(is_MODIFYVOYAGETYPE)
il_modifyvoyagenumbernum = of_addmenuitem(is_MODIFYVOYAGENUMBER)
il_deletevoyagenum       = of_addmenuitem(is_DELETECOMPLETEVOYAGE)
of_addmenuitem("-")
il_updateportsnum        = of_addmenuitem(is_UPDATEPORTS)

end event

event ue_command;call super::ue_command;choose case as_text
	case is_MODIFYVOYAGETYPE
		wf_modify_voyagetype()
	case is_MODIFYVOYAGENUMBER
		wf_modify_voyagenumber()
	case is_DELETECOMPLETEVOYAGE
		wf_delete_voyagenumber()
	case is_UPDATEPORTS
		wf_updateports()
end choose

end event

