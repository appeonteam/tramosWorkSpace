$PBExportHeader$n_tc_contract.sru
$PBExportComments$This object covers a whole TC Contract
forward
global type n_tc_contract from nonvisualobject
end type
end forward

global type n_tc_contract from nonvisualobject
end type
global n_tc_contract n_tc_contract

type variables
Private:
/* Datastores for whole TC Contract */

n_ds	ids_contract_detail				/* TC Contract detail (master) */
n_ds	ids_broker_comm					/* Broker Commission (detail) */
n_ds	ids_contract_exp					/* Contract Expenses (detail) */
n_ds	ids_period							/* Contract periods (detail) (submaster)*/
n_ds  ids_non_port_exp           	/* Non-Port Expenses  */
n_ds  ids_settled_payment				/* Settled payments in the contract */

//M5-10 Added by LGX001 on 29/03/2012.
n_ds  ids_final_payment             /* Final payments in the contract */
n_ds  ids_new_draft_payment         /* new / draft payments with locked in the contract */

/* TC contract ID (unique) */
long il_contract_id

/* Vessel Number */
integer ii_vessel_nr

mt_u_datawindow idw_contract			/* TC Contract detail (master) */

Public:										/* Reason why public is that modifiedCount() is used from window */

n_ds	ids_bareboat_management 		/* CODA Elements when TC-in and Bareboat */ 
n_ds	ids_share_member					/* Share Menbers (detail), only available for TC-IN */
end variables

forward prototypes
public function long of_newexpense ()
private function integer of_destroydatastores ()
public function long of_getcontractid ()
public subroutine of_resetall ()
public function integer of_retrieve ()
public subroutine of_setcontractid (long al_id)
public subroutine of_setvesselnr (integer ai_vessel_nr)
public subroutine of_show_fixturenote ()
public function integer of_sharemembers ()
private subroutine of_setredelivery ()
public function datetime of_getRedelivery ()
public function integer of_unfinishtc ()
public function integer of_finishtc ()
public function long of_newbroker ()
public function integer of_update ()
public function integer of_validate ()
public function integer of_newcontract ()
public function integer of_deletecontract ()
public function integer of_deletebroker (long al_rowno)
private function integer of_createdatastores ()
public function integer of_fixture ()
public function integer of_gettcinortcout ()
public function long of_newperiod ()
public function integer of_finishperiod (long al_row)
public function integer of_deleteperiod (long al_rowno)
private subroutine of_validate_opsaperiod ()
public function integer of_getvesselnr ()
public subroutine of_refresh_pcnrlogo (string as_column)
public function integer of_validate_paymentstatus ()
public subroutine documentation ()
public function integer of_sharedatastores (datawindow adw_contract, datawindow adw_brokercomm, datawindow adw_contract_exp, datawindow adw_periods, datawindow adw_non_port_exp)
public function integer of_bareboatmanagement ()
public function integer of_validate_rateperiod_paymentstatus ()
public function integer of_validate_reduce_period (datetime adt_period_end)
public function integer of_modifyvoyagenumber (long al_row, string as_data)
public function integer of_validate_add_period (datetime adt_period_end)
end prototypes

public function long of_newexpense ();long ll_row

if isNull(ii_vessel_nr) then 
	MessageBox("Insert Error", "Can't create new Contract without a vessel selected")
	return -1
end if

/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
if of_validate_paymentstatus() = c#return.Failure then return c#return.Failure

ll_row = ids_contract_exp.insertRow(0)

/* Default values */
if ll_row > 0 then
	if not isNull(il_contract_id) then
		ids_contract_exp.setItem(ll_row, "contract_id", il_contract_id)
	end if
	ids_contract_exp.setItem(ll_row, "expense_monthly", 1)
	ids_contract_exp.setItem(ll_row, "tc_off_service_dependent", 0)
end if

return ll_row
end function

private function integer of_destroydatastores ();DESTROY ids_contract_detail
DESTROY ids_broker_comm
DESTROY ids_contract_exp
DESTROY ids_period
DESTROY ids_share_member
DESTROY ids_non_port_exp
DESTROY ids_final_payment 
DESTROY ids_new_draft_payment
DESTROY ids_bareboat_management

Return 1

end function

public function long of_getcontractid ();return il_contract_id
end function

public subroutine of_resetall ();ids_contract_detail.reset()
ids_broker_comm.reset()
ids_contract_exp.reset()
ids_period.reset()
ids_share_member.reset()
ids_bareboat_management.reset()
return
end subroutine

public function integer of_retrieve ();ids_contract_detail.retrieve(il_contract_id)
ids_broker_comm.retrieve(il_contract_id)
ids_contract_exp.retrieve(il_contract_id)
ids_period.retrieve(il_contract_id)
ids_share_member.retrieve(il_contract_id)
ids_non_port_exp.retrieve(il_contract_id)
ids_bareboat_management.retrieve(il_contract_id)
of_setRedelivery()

of_validate_opsaperiod( )

of_refresh_pcnrlogo("pcnrlogo")

commit;
return 1
end function

public subroutine of_setcontractid (long al_id);il_contract_id = al_id

return
end subroutine

public subroutine of_setvesselnr (integer ai_vessel_nr);ii_vessel_nr = ai_vessel_nr

Return
end subroutine

public subroutine of_show_fixturenote ();openwithparm(w_fixture_note, ids_contract_detail.getItemString(1, "fix_note"))
return
end subroutine

public function integer of_sharemembers ();if ids_share_member.rowCount() = 0 then
	ids_share_member.insertRow(0)
	
	if not isNull(il_contract_id) then
		ids_share_member.setItem(1, "contract_id", il_contract_id)
	end if
	ids_share_member.setItem(1, "apm_company", 0)
	ids_share_member.setitemstatus(1,0,Primary!,NotModified!)
end if
openwithparm(w_share_members, ids_share_member)

return ids_share_member.rowCount()
end function

private subroutine of_setredelivery ();/* this function sets redelivery date + calculated days */

datetime ldt_del, ldt_red
long ll_days
if ids_contract_detail.rowcount() < 1 then return
ldt_del = ids_contract_detail.getItemDatetime(1, "delivery")
ldt_red = ids_period.getItemDatetime(ids_period.rowCount(), "periode_end")
ids_contract_detail.setItem(1, "redelivery", ldt_red)
ll_days = daysafter(date(ldt_del), date(ldt_red))
ids_contract_detail.setItem(1, "calculated_days", ll_days)

// Dette er lavet for at ModifiedCount() skal give det rigtige
// resultat. 
ids_contract_detail.ResetUpdate()

return
end subroutine

public function datetime of_getRedelivery ();return ids_contract_detail.getItemDatetime(1, "redelivery")
end function

public function integer of_unfinishtc ();long 		ll_rows, ll_rowno
datetime ldt_null
string 	ls_null

//only finance profile or "administrator"can finish TC
if (uo_global.ii_user_profile= 3 ) or (uo_global.ii_access_level = 3) then   
	setNull(ldt_null)
	setNull(ls_null)
	// un-finish all periods
	ll_rows = ids_period.rowCount()
	for ll_rowno = 1 to ll_rows
		ids_period.setItem(ll_rowno, "finished", 0)
	next
	//un-finish contract
	ids_contract_detail.setItem(1, "finish_date", ldt_null)
	ids_contract_detail.setItem(1, "finish_user_id", ls_null)
else
	MessageBox("Information", "Only users with Finance profile can un-finish TC")
end if

commit;
return 1
end function

public function integer of_finishtc ();//MessageBox("", "Husk at kode of_finishTC færdig")
// Skal indeholde check for at alle afregninger er lavet
// og final hire fremsendt

long ll_rows, ll_rowno

/* if no data return */
if ids_contract_detail.rowCount() <> 1 then return 1

//only operator profile or "administrator" can finish TC
if (uo_global.ii_user_profile= 2 ) or (uo_global.ii_access_level = 3) then   
	// finish all periods
	ll_rows = ids_period.rowCount()
	for ll_rowno = 1 to ll_rows
		ids_period.setItem(ll_rowno, "finished", 1)
	next
	//finish contract
	ids_contract_detail.setItem(1, "finish_date", today())
	ids_contract_detail.setItem(1, "finish_user_id", uo_global.is_userid)
else
	MessageBox("Information", "Only users with Operator profile can finish TC")
end if

commit;
return 1
end function

public function long of_newbroker ();long ll_row

if isNull(ii_vessel_nr) then 
	MessageBox("Insert Error", "Can't create new Contract without a vessel selected")
	return -1
end if

/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
if of_validate_paymentstatus() = c#return.Failure then return c#return.Failure

ll_row = ids_broker_comm.insertRow(0)

/* Default values */
if ll_row > 0 then
	if not isNull(il_contract_id) then
		ids_broker_comm.setItem(ll_row, "contract_id", il_contract_id)
	end if
	ids_broker_comm.setItem(ll_row, "amount_per_day_or_percent", 0)
	ids_broker_comm.setItem(ll_row, "primary_broker", 0)
	ids_broker_comm.setItem(ll_row, "comm_set_off", 0)
end if

return ll_row
end function

public function integer of_update ();long 				ll_rows, ll_row_no
long				ll_null;setNull(ll_null)
n_tc_payment 	lnv_payment
boolean 			lb_newContract = FALSE

/* No data to update */
if ids_contract_detail.rowCount() < 1 then return 1


if ids_broker_comm.modifiedcount() + ids_contract_exp.modifiedcount() + ids_non_port_exp.modifiedcount() > 0   then 
	if of_validate_paymentstatus() = c#return.Failure then return c#return.Failure
end if

if ids_period.find( "rate <> rate.original or periode_end <> periode_end.original", 1, ids_period.rowcount()) > 0 then
	if of_validate_rateperiod_paymentstatus( ) = c#return.Failure then return c#return.Failure
end if

//ids_non_port_exp.modifiedcount() +  & remove this
if of_validate() = -1 then return -1

/* Update sequence depends on if it is a new contract or an old one 
	if new we have to update detail window first, and set the contract key
	in all subtables.
*/

if ids_contract_detail.update(true, false) = 1 then
	of_setcontractID(ids_contract_detail.getItemNumber(1, "contract_id"))
else
	rollback;
	Return -1
end if

/* If new contract set Contract ID in all subtables */
if ids_contract_detail.getitemstatus(1,0,primary!) = NewModified! then
	lb_newContract = TRUE
	/* Broker Commission */
	ll_rows = ids_broker_comm.RowCount()
	if ll_rows > 0 then
		for ll_row_no = 1 to ll_rows
			ids_broker_comm.setItem(ll_row_no, "contract_id", il_contract_id)
		next
	end if
	/* Contract Expenses */
	ll_rows = ids_contract_exp.RowCount()
	if ll_rows > 0 then
		for ll_row_no = 1 to ll_rows
			ids_contract_exp.setItem(ll_row_no, "contract_id", il_contract_id)
		next
	end if
	/* Periods */
	ll_rows = ids_period.RowCount()
	if ll_rows > 0 then
		for ll_row_no = 1 to ll_rows
			ids_period.setItem(ll_row_no, "contract_id", il_contract_id)
		next
	end if
	/* Share Members */
	ll_rows = ids_share_member.RowCount()
	if ll_rows > 0 then
		for ll_row_no = 1 to ll_rows
			ids_share_member.setItem(ll_row_no, "contract_id", il_contract_id)
		next
	end if
   	/* Bareboat Management */
	ll_rows = ids_bareboat_management.RowCount()
	if ll_rows > 0 then
		for ll_row_no = 1 to ll_rows
			ids_bareboat_management.setItem(ll_row_no, "contract_id", il_contract_id)
		next
	end if

end if

if ids_broker_comm.update(true, false) = 1 then
	if ids_contract_exp.update(true, false) = 1 then
		if ids_period.update(true, false) = 1 then
			if ids_share_member.update(true, false) = 1 then
				if ids_bareboat_management.update(true, false) = 1 then
					ids_contract_detail.ResetUpdate()
					ids_broker_comm.ResetUpdate()		
					ids_contract_exp.ResetUpdate()
					ids_period.ResetUpdate()
					ids_share_member.ResetUpdate()
					ids_bareboat_management.ResetUpdate()
					COMMIT;  
				else
					rollback;
					return -1
				end if
				
			else
				rollback;
				return -1
			end if
		else
			rollback;
			return -1
		end if
	else
		rollback;
		return -1
	end if
else
	rollback;
	return -1
end if

of_setRedelivery()

/* Calculate Payments */
/* Her testes for type af kontrakt og instantieres den rigtige version */
choose case ids_contract_detail.getItemNumber(1, "payment_type") 
	case 0  /* monthly payments payday at 00:00 */
		lnv_payment = create n_monthly_payment_fixed_time
	case 1  /* interval payments payday at delivery time */
		lnv_payment = create n_interval_payment_delivery_time
	case 2  /* monthly payments payday at delivery time */
		lnv_payment = create n_monthly_payment_delivery_time
	case 3  /* half monthly payments payday at delivery time */
		lnv_payment = create n_half_monthly_payment_delivery_time
	case else 
		return -1
end choose
if lb_newContract then
	lnv_payment.of_createPayments(il_contract_id)
else
	lnv_payment.of_dependentcontractexpensesmodified( il_contract_id, ll_null)
	lnv_payment.of_modifyPayments(il_contract_id)
end if

if isValid(lnv_payment) then destroy lnv_payment

/* Check if Contract and OPSA setup are equal if any OPSA setup */
of_validate_opsaperiod( )

/*Refresh dropdown datawindow Print on behalf of*/
of_refresh_pcnrlogo("pcnrlogo")

return 1
end function

public function integer of_validate ();long 			ll_rows, ll_rowno, ll_counter, li_periods, li_period, ll_final_row, ll_current_row
integer 		li_primary_broker 
datetime 	ldt_start, ldt_end, ldt_start_original, ldt_end_original,  ldt_settled_date 			/* used when validating periodes */
decimal		ld_test						/* variable used for validation test */
datetime		ldt_delivery, ldt_redelivery, ldt_delivery_old, ldt_redelivery_old
boolean		lb_offservice_conflict = false
long			ll_last_row, ll_draft_row
n_ds			lds_data
decimal{1}	ld_lt_to_utc_difference
datetime		ldt_due_date
long 			ll_local_time, ll_found
datetime		ldt_check_delivery, ldt_check_redelivery
decimal{1}	ld_del_lt_to_utc_difference, ld_red_lt_to_utc_difference, ld_cur_del_lt_to_utc_difference, ld_cur_red_lt_to_utc_difference

/* First of all accept the data */
ids_contract_detail.acceptText()
ids_broker_comm.acceptText()
ids_contract_exp.acceptText()
ids_period.acceptText()
ids_bareboat_management.accepttext( )
/* First check if there are any data, in the datastores */
/****** START 1st check ********/
if ids_contract_detail.getitemstatus(1,0,Primary!) = New! then 
	MessageBox("Validation Error", "No data entered for Contract!")
	return -1
end if
ll_rows = ids_broker_comm.RowCount()
if ll_rows > 0 then
	for ll_rowno = 1 to ll_rows
		if ids_broker_comm.getitemstatus(1,0,Primary!) = New! then 
			MessageBox("Validation Error", "No data entered for Broker Commission!, row no. "+string(ll_rowno))
			return -1
		end if
	next
end if
ll_rows = ids_contract_exp.RowCount()
if ll_rows > 0 then
	for ll_rowno = 1 to ll_rows
		if ids_contract_exp.getitemstatus(1,0,Primary!) = New! then 
			MessageBox("Validation Error", "No data entered for Contract Expenses!, row no. "+string(ll_rowno))
			return -1
		end if
	next
end if
ll_rows = ids_period.RowCount()
if ll_rows > 0 then
	for ll_rowno = 1 to ll_rows
		if ids_period.getitemstatus(1,0,Primary!) = New! then 
			MessageBox("Validation Error", "No data entered for Periode!, row no. "+string(ll_rowno))
			return -1
		end if
	next
end if
/****** END 1st check   ********/

/****** START 2nd check (Contract Detail) ********/
if ids_contract_detail.getItemNumber(1, "tc_hire_in") = 1 then
	if isNull(ids_contract_detail.getItemNumber(1, "tcowner_nr")) then
		MessageBox("Validation Error", "You can't hire IN a vessel without a Headowner")
		return -1
	end if
	if ids_contract_detail.getItemNumber(1, "share_member") > 0 and &
		ids_contract_detail.getItemNumber(1, "hired_by_pool") > 0 then 
		MessageBox("Validation Error", "You can't have both Share Members and Hired by Pool at the same time")
		return -1
	end if
	if ids_contract_detail.getItemNumber(1, "pure_management") > 0 and &
		ids_contract_detail.getItemNumber(1, "hired_by_pool") > 0 then 
		MessageBox("Validation Error", "You can't have both Hired by Pool and Pure Management at the same time")
		return -1
	end if
	
else   /* TC-Out */
	if isNull(ids_contract_detail.getItemNumber(1, "chart_nr")) then
		MessageBox("Validation Error", "You can't hire OUT a vessel without selecting a Charterer")
		return -1
	end if
	if isNull(ids_contract_detail.getItemNumber(1, "contract_tcowner_nr")) then
		MessageBox("Validation Error", "You can't hire OUT a vessel without selecting a TC Owner")
		return -1
	end if
	if ids_contract_detail.getItemNumber(1, "share_member") > 0 then 
		MessageBox("Validation Error", "You can't have Share Members on a TC-Out Contract")
		return -1
	end if
	if ids_contract_detail.getItemNumber(1, "hired_by_pool") > 0 then 
		MessageBox("Validation Error", "You can't have Hired by Pool on a TC-Out Contract")
		return -1
	end if
end if	

if isNull(ids_contract_detail.getItemDateTime(1, "cp_date")) then
	MessageBox("Validation Error", "Please enter a CP Date")
	return -1
end if
	
if isNull(ids_contract_detail.getItemDateTime(1, "Delivery")) then
	MessageBox("Validation Error", "Please enter a Delivery Date")
	return -1
end if

if Year(date(ids_contract_detail.getItemDateTime(1, "Delivery"))) < 1990 then
	MessageBox("Validation Error", "Delivery Date cant be before 01. January 1990")
	return -1
end if


choose case ids_contract_detail.getItemNumber(1, "payment_type")
	case 0, 2   /* Monthly */
		if isNull(ids_contract_detail.getItemNumber(1, "payment")) then
			MessageBox("Validation Error", "Please enter Payment details")
			return -1
		end if

		if ids_contract_detail.getItemNumber(1, "payment") < 1 then
			MessageBox("Validation Error", "Payment date/interval can't be less than 1.")
			return -1
		end if
		
		if ids_contract_detail.getItemNumber(1, "payment") > 31 then
			MessageBox("Validation Error", "Payment details not correct entered. Date can't be greater than 31")
			return -1
		end if

		if abs(ids_contract_detail.getItemNumber(1, "payment_due_days")) > 31 then
			MessageBox("Validation Error", "Payment due days (+/-) not correct entered. Days can't be greater/less than 31")
			return -1
		end if

	case 1   /* Interval */
		if isNull(ids_contract_detail.getItemNumber(1, "payment")) then
			MessageBox("Validation Error", "Please enter Payment details")
			return -1
		end if

		if ids_contract_detail.getItemNumber(1, "payment") < 1 then
			MessageBox("Validation Error", "Payment date/interval can't be less than 1.")
			return -1
		end if
		
		if abs(ids_contract_detail.getItemNumber(1, "payment_due_days")) > &
					ids_contract_detail.getItemNumber(1, "payment") then
			MessageBox("Validation Error", "Payment due days (+/-) not correct entered. Days can't be greater/less than payment interval.")
			return -1
		end if
		
	case 3   /* Half monthly */
		if ids_contract_detail.getItemNumber(1, "payment") <> 0 then
			MessageBox("Validation Error", "Payment date/interval can't be less than 1.")
			return -1
		end if
end choose

if isNull(ids_contract_detail.getItemNumber(1, "office_nr")) then
	MessageBox("Validation Error", "Please select an Office")
	return -1
end if

ld_test = ids_contract_detail.getItemNumber(1, "adr_comm")
if not isnull(ld_test) then
	if ld_test < 0 then
		MessageBox("Validation Error", "Address Commission can't be less than 0")
		return -1
	end if
end if

if isNull(ids_contract_detail.getItemNumber(1, "statement_logo")) then
	MessageBox("Validation Error", "Please select Statement Logo")
	return -1
end if
if ids_contract_detail.getItemNumber(1, "statement_logo") = 1 and isnull(ids_contract_detail.getitemstring(1,"pc_nr")) then
	if isNull(ids_contract_detail.getItemstring(1, "statement_logo_text")) then
		MessageBox("Validation Error", "You can't use Maersk Star as header without Logo text")
		return -1
	end if
end if
if ids_contract_detail.getItemNumber(1, "statement_logo") = 3 then
	if isNull(ids_contract_detail.getItemstring(1, "statement_logo_text")) then
		MessageBox("Validation Error", "You can't use Comp. Logo as header without entering Comp. name")
		return -1
	end if
end if
/****** END 2nd check (Contract Detail)   ********/

/****** START 3rd check (Broker Commission) ********/
ll_rows = ids_broker_comm.rowCount()
li_primary_broker = 0
for ll_rowno = 1 to ll_rows
	if isNull(ids_broker_comm.getItemNumber(ll_rowno, "broker_nr")) then
		MessageBox("Validation Error", "Please select broker in row #: "+ string(ll_rowno))
		return -1
	end if
	if isNull(ids_broker_comm.getItemNumber(ll_rowno, "broker_comm")) then
		MessageBox("Validation Error", "Please enter commission percent for broker in row #: "+ string(ll_rowno))
		return -1
	end if
	if ids_broker_comm.getItemNumber(ll_rowno, "amount_per_day_or_percent") = 0 then
		if ids_broker_comm.getItemNumber(ll_rowno, "broker_comm") > 100 or &
			ids_broker_comm.getItemNumber(ll_rowno, "broker_comm") < 0 then
				MessageBox("Validation Error", "Commission percent < 0% or > 100% for broker in row #: "+ string(ll_rowno))
				return -1
		end if
	else
		if ids_broker_comm.getItemNumber(ll_rowno, "broker_comm") < 0 then
				MessageBox("Validation Error", "Commission per Day < 0 for broker in row #: "+ string(ll_rowno))
				return -1
		end if
	end if		
	if ids_broker_comm.getItemNumber(ll_rowno, "primary_broker") = 1 then
		li_primary_broker ++
	end if
next

if li_primary_broker > 1 then
	MessageBox("Validation Error", "You are only allowed to have one primary Broker")
	return -1
end if
/****** END 3rd check (Broker Commission)   ********/

/****** START 4th check (Contract Expenses) ********/
ll_rows = ids_contract_exp.rowCount()
for ll_rowno = 1 to ll_rows
	if isNull(ids_contract_exp.getItemNumber(ll_rowno, "exp_type_id")) then
		MessageBox("Validation Error", "Please select Contract expense type in row #: "+ string(ll_rowno))
		return -1
	end if
	if isNull(ids_contract_exp.getItemNumber(ll_rowno, "expense_amount")) then
		MessageBox("Validation Error", "Please enter expense amount in row #: "+ string(ll_rowno))
		return -1
	end if
next
/*  Ensure that the same expense type is not used more than once on each contract */
if ll_rows > 1 then
	ids_contract_exp.setSort("exp_type_id A")
	ids_contract_exp.sort()
	for ll_rowno = 2 to ll_rows
		if ids_contract_exp.getItemNumber(ll_rowno - 1, "exp_type_id") =  ids_contract_exp.getItemNumber(ll_rowno, "exp_type_id") then
			MessageBox("Validation Error", "You may not use the same Contract expense type more than once on each contract.~r~nType in row #: "+ string(ll_rowno)+" is equal to another row")
			return -1
		end if
	next
end if	
/****** END 4th check (Contract Expenses)   ********/

/****** START 5th check (Periods) ********/
ll_rows = ids_period.rowCount()
if ll_rows < 1 then 
	MessageBox("Validation Error", "You can't create TC Contract without periods")
	return -1
end if

li_period = ids_settled_payment.retrieve(il_contract_id)
ll_final_row = ids_final_payment.retrieve(il_contract_id)
ll_draft_row = ids_new_draft_payment.retrieve(il_contract_id)

for ll_rowno = 1 to ll_rows
	if isNull(ids_period.getItemNumber(ll_rowno, "rate")) then
		MessageBox("Validation Error", "Please enter rate in row #: "+ string(ll_rowno))
		return -1
	end if
	if ids_period.getItemNumber(ll_rowno, "rate") < 0 then
		MessageBox("Validation Error", "Rate can't be less than 0 in row #: "+ string(ll_rowno))
		return -1
	end if
	ldt_start = ids_period.getItemDatetime(ll_rowno, "periode_start")
	ldt_end   = ids_period.getItemDatetime(ll_rowno, "periode_end")
	if isNull(ldt_start) OR isNull(ldt_end) then
		MessageBox("Validation Error", "Please enter date in row #: "+ string(ll_rowno))
		return -1
	end if
	// enddate must be greater than startdate
	if ldt_end <= ldt_start then
		MessageBox("Validation Error", "Enddate must be greater than startdate in row #: "+ string(ll_rowno))
		return -1
	end if
	// checks that end date not overlaps year shift
	if ldt_end > datetime(date(year(date(ldt_start))+1,1,1)) then
		MessageBox("Validation Error", "End date must not overlap a year shift in row #: "+ string(ll_rowno))
		return -1
	end if
	ld_test = ids_period.getItemNumber(ll_rowno, "est_off_days")
	if not isnull(ld_test) then
		if ld_test < 0 then
			MessageBox("Validation Error", "Estimated Off-days can't be less than 0 in row #: "+ string(ll_rowno))
			return -1
		end if
	end if
	ld_test = ids_period.getItemNumber(ll_rowno, "allowance")
	if not isnull(ld_test) then
		if ld_test < 0 then
			MessageBox("Validation Error", "Allowance can't be less than 0 in row #: "+ string(ll_rowno))
			return -1
		end if
	end if
	// check that voyage number is correct if entered and TC-OUT contract
	if not isnull(ids_period.getItemString(ll_rowno, "tcout_voyage_nr")) then
		if ids_contract_detail.getItemNumber(1, "tc_hire_in") = 0 then
			if len(ids_period.getItemString(ll_rowno, "tcout_voyage_nr")) <> 5 then
				MessageBox("Validation Error", "Voyage number must be exactly 5 digits in row #: "+ string(ll_rowno))
				return -1
			end if
			if mid(string(year(date(ldt_start))),3,4) <> mid(ids_period.getItemString(ll_rowno, "tcout_voyage_nr"),1,2) then
				MessageBox("Validation Error", "Voyage number must follow periode year in row #: "+ string(ll_rowno))
				return -1
			end if
		else
			/* if TC-IN and voyage number entered, clear it! */
			ids_period.setItem(ll_rowno, "tcout_voyage_nr", "")
		end if
	end if
	
next

/****** END 5th check (Periods)   ********/

/****** END 6th check (Bareboat Management)   ********/
if ids_contract_detail.getItemNumber(1, "bareboat") = 1 and ids_contract_detail.getItemNumber(1, "tc_hire_in") = 1 then
	if ids_bareboat_management.rowCount() <> 2 then
		MessageBox("Validation Error", "You can't create TC Contract with combination TC Hire IN / Bareboat, without entering CODA Elements")
		return -1
	end if
else
	/* all other combinations don't need the combination and therefore are Deleted */
	ids_bareboat_management.deleterow(0)
	ids_bareboat_management.deleterow(0)
end if	
/****** END 6th check (Bareboat Management)   ********/

/****** START check that there are no Contracts of same type overlapping ******/
if not isvalid(lds_data) then
	lds_data = CREATE n_ds
end if
lds_data.DataObject = "d_tc_validate_contract_period"
lds_data.setTransObject(SQLCA)
ll_rows = lds_data.retrieve(ii_vessel_nr, ids_contract_detail.getItemNumber(1, "tc_hire_in"))
ldt_start 	  = ids_contract_detail.getItemDateTime(1, "delivery")
ll_last_row   = ids_period.RowCount()
ldt_end		  = ids_period.getItemDatetime(ll_last_row, "periode_end")
ll_local_time = ids_contract_detail.getitemnumber(1, "local_time")
if ll_rows > 0 then
	//UTC time
	if ll_local_time = 0 then
		ll_found = lds_data.find("contract_id = " + string(il_contract_id), 1, ll_rows)
		if ll_found > 0 then
			ld_cur_del_lt_to_utc_difference = lds_data.getitemnumber(ll_found, "del_lt_to_utc_difference")
			ld_cur_red_lt_to_utc_difference = lds_data.getitemnumber(ll_found, "red_lt_to_utc_difference")
		end if
		if ld_cur_del_lt_to_utc_difference <> 0 then
			ldt_start = f_long2datetime(f_datetime2long(ldt_start) - (ld_cur_del_lt_to_utc_difference * 3600))
		end if
		if ld_cur_red_lt_to_utc_difference <> 0 then
			ldt_end = f_long2datetime(f_datetime2long(ldt_end) - (ld_cur_red_lt_to_utc_difference * 3600))
		end if
	end if
		
	for ll_rowno = 1 to ll_rows
		ldt_check_delivery  			 = lds_data.getitemdatetime(ll_rowno, "delivery")
		ld_del_lt_to_utc_difference = lds_data.getitemnumber(ll_rowno, "del_lt_to_utc_difference")
		ldt_check_redelivery 		 = lds_data.getitemdatetime(ll_rowno, "redelivery")
		ld_red_lt_to_utc_difference = lds_data.getitemnumber(ll_rowno, "red_lt_to_utc_difference")
		if ld_del_lt_to_utc_difference <> 0 then
			ldt_check_delivery = f_long2datetime(f_datetime2long(ldt_check_delivery) - (ld_del_lt_to_utc_difference * 3600))
		end if
		if ld_red_lt_to_utc_difference <> 0 then
			ldt_check_redelivery = f_long2datetime(f_datetime2long(ldt_check_redelivery) - (ld_red_lt_to_utc_difference * 3600))
		end if
				
		if  (ldt_start <= ldt_check_delivery   and ldt_end <= ldt_check_delivery) or &
		    (ldt_start >= ldt_check_redelivery and ldt_end >= ldt_check_redelivery) then 
			 //Dates OK	 
		else
			if lds_data.getItemNumber(ll_rowno, "contract_id") = il_contract_id then
				// OK
			else
				messagebox("Validation Error", "You can't have more than one Contract covering the same period")
				destroy lds_data
				return -1
			end if
		end if	
	next
	destroy lds_data
end if
/****** END check that there are no Contracts of same type overlapping ******/

/****** If delivery/re-delivery date is changed update POC Arrival date   ******/
/* Delivery - The POC that will be updates is only the one connected to Contract if any */
/* Only modify POC if there is a contract ID ( when a new contract is created there is no contract ID */
if not isNull(il_contract_id) then
	/* if switch of contract between LT and UTC dates in POC must be reset */
   	if ids_contract_detail.getItemStatus(1, "local_time", Primary!) = DataModified! then
		ids_contract_detail.setItemStatus(1, "Delivery", Primary!, DataModified!)
		ids_period.setItemStatus(ids_period.rowCount(), "periode_end", Primary!, DataModified!)
	end if
	if ids_contract_detail.getItemNumber(1, "local_time") = 1 then
	 	/* Local Time Contract dates in POC and Contract are equal */
		if  ids_contract_detail.getItemStatus(1, "Delivery", Primary!) = DataModified! then
			ldt_delivery = ids_contract_detail.getItemDatetime(1, "Delivery")
			SELECT PORT_DEPT_DT
			INTO :ldt_delivery_old
			FROM POC
			WHERE CONTRACT_ID = :il_contract_id 
				AND PURPOSE_CODE = "DEL";
			if SQLCA.sqlcode = 0 then 
				if ldt_delivery > ldt_delivery_old then
					messagebox("Information","You have changed the period start date, the arrival date in the Port of Call will be changed accordingly, but the depature date is before the arrival date, please change the departure date in the port of call first if you still want to change this period start date.")
					return -1
				else
					UPDATE POC 
						SET PORT_ARR_DT = :ldt_delivery,
							LT_TO_UTC_DIFFERENCE = 0
						WHERE CONTRACT_ID = :il_contract_id 
						AND PURPOSE_CODE = "DEL" ;
					if sqlca.sqlcode <> 0 then
						MessageBox("POC Update Error", "Update of Port Arrival Date in POC failed!")
						return -1
					end if
				end if
			end if
		end if
		/* Re-delivery - The POC that will be updates is only the one connected to Contract if any */
		if  ids_period.getItemStatus(ids_period.rowCount(), "periode_end", Primary!) = DataModified! OR &
			 ids_period.getItemStatus(ids_period.rowCount(), "periode_end", Primary!) = NewModified! then
			ldt_redelivery = ids_period.getItemDatetime(ids_period.rowCount(), "periode_end")
			SELECT PORT_ARR_DT
			INTO :ldt_redelivery_old
			FROM POC
			WHERE CONTRACT_ID = :il_contract_id 
				AND PURPOSE_CODE = "RED";
			if SQLCA.sqlcode = 0 then 
				if ldt_redelivery_old > ldt_redelivery then
					messagebox("Information","You have changed the period end date, the departure date in the Port of Call will be changed accordingly, but the depature date is before the arrival date, please change the arrival date in the Port of Call first if you still want to change this period end date.")
					return -1
				else	
					UPDATE POC 
						SET PORT_DEPT_DT = :ldt_redelivery,
							LT_TO_UTC_DIFFERENCE = 0
						WHERE CONTRACT_ID = :il_contract_id 
						AND PURPOSE_CODE = "RED" ;
					if sqlca.sqlcode <> 0 then
						MessageBox("POC Update Error", "Update of Port Departure Date in POC failed!")
						return -1
					end if
				end if
			end if
		end if
	else
		/* UTC Contract POC dates must be calculated, based on difference */
		if  ids_contract_detail.getItemStatus(1, "Delivery", Primary!) = DataModified! then
			ldt_delivery = ids_contract_detail.getItemDatetime(1, "Delivery")
			SELECT LT_TO_UTC_DIFFERENCE INTO :ld_lt_to_utc_difference FROM POC WHERE CONTRACT_ID = :il_contract_id AND PURPOSE_CODE = "DEL";
			if sqlca.sqlcode = 0 then
				ldt_delivery = f_long2datetime(f_datetime2long(ldt_delivery ) - (ld_lt_to_utc_difference * 3600))
				SELECT PORT_DEPT_DT
				INTO :ldt_delivery_old
				FROM POC
				WHERE CONTRACT_ID = :il_contract_id 
					AND PURPOSE_CODE = "DEL";
				if SQLCA.sqlcode = 0 then 
					if ldt_delivery > ldt_delivery_old then
						messagebox("Information","You have changed the period start date, the arrival date in the Port of Call will be changed accordingly, but the depature date is before the arrival date, please change the departure date in the port of call first if you still want to change this period start date.")
						return -1
					else				
						UPDATE POC 
							SET PORT_ARR_DT = :ldt_delivery
							WHERE CONTRACT_ID = :il_contract_id 
							AND PURPOSE_CODE = "DEL" ;
						if sqlca.sqlcode <> 0 then
							MessageBox("POC Update Error", "Update of Port Arrival Date in POC failed!")
							return -1
						end if
						MessageBox("Information", "Please be aware of that the Arrival date in Port of Call~n~r" &
														+"will be changed to "+string(ldt_delivery, "dd/mm-yy hh:mm")+".~n~r~n~r" &
														+"The calculation is basis a LT to UTC difference of "+string(ld_lt_to_utc_difference)+" hours. ", Information!)
					end if
				end if
			end if
		end if
		/* Re-delivery - The POC that will be updates is only the one connected to Contract if any */
		if  ids_period.getItemStatus(ids_period.rowCount(), "periode_end", Primary!) = DataModified! OR &
			 ids_period.getItemStatus(ids_period.rowCount(), "periode_end", Primary!) = NewModified! then
			ldt_redelivery = ids_period.getItemDatetime(ids_period.rowCount(), "periode_end")
			SELECT LT_TO_UTC_DIFFERENCE INTO :ld_lt_to_utc_difference FROM POC WHERE CONTRACT_ID = :il_contract_id AND PURPOSE_CODE = "RED";
			if sqlca.sqlcode = 0 then
				ldt_redelivery = f_long2datetime(f_datetime2long(ldt_redelivery ) - (ld_lt_to_utc_difference * 3600))
				SELECT PORT_ARR_DT
				INTO :ldt_redelivery_old
				FROM POC
				WHERE CONTRACT_ID = :il_contract_id 
					AND PURPOSE_CODE = "RED";
				if SQLCA.sqlcode = 0 then 
					if ldt_redelivery_old > ldt_redelivery then
						messagebox("Information","You have changed the period end date, the departure date in the Port of Call will be changed accordingly, but the depature date is before the arrival date, please change the arrival date in the Port of Call first if you still want to change this period end date.")
						return -1
					else	
						UPDATE POC 
							SET PORT_DEPT_DT = :ldt_redelivery
							WHERE CONTRACT_ID = :il_contract_id 
							AND PURPOSE_CODE = "RED" ;
						if sqlca.sqlcode <> 0 then
							MessageBox("POC Update Error", "Update of Port Departure Date in POC failed!")
							return -1
						end if
						MessageBox("Information", "Please be aware of that the Departure date in Port of Call~n~r" &
														+"will be changed to "+string(ldt_redelivery, "dd/mm-yy hh:mm")+".~n~r~n~r" &
														+"The calculation is basis a LT to UTC difference of "+string(ld_lt_to_utc_difference)+" hours. ", Information!)
					end if
				end if
			end if
		end if
	end if
end if
/****** END updating POC delivery/redelivery dates ******/ 

/****** Start Check if a TC-out contract starts before TC-in contract *****/
/* In this case show a warning message to the user. Could be because of LT/UTC time difference 
	Check only relevant when delivery modified */
if  (ids_contract_detail.getItemStatus(1, "Delivery", Primary!) = DataModified! &
or ids_contract_detail.getItemStatus(1, "Delivery", Primary!) = NewModified! ) &
and ids_contract_detail.getItemNumber(1, "tc_hire_in") = 0 then
	ldt_delivery = ids_contract_detail.getItemDatetime(1, "Delivery")
	SELECT COUNT(*)
		INTO :ll_counter
		FROM NTC_TC_CONTRACT
		WHERE VESSEL_NR = :ii_vessel_nr
		AND TC_HIRE_IN = 1
		AND DELIVERY > :ldt_delivery ;
	if ll_counter > 0 then
		MessageBox("Information", "Please be aware of that the Delivery date on this Contract~n~r" &
											+"is before the Delivery date on the TC-IN contract.~n~r~n~r" &
											+"Can be because of one contract in LT and the other in UTC. ", Information!)
	end if		
end if
/****** Start Check if a TC-out contract starts before TC-in contract *****/


/****** START check against Off-services ******/
if not isvalid(lds_data) then
	lds_data = CREATE n_ds
end if
lds_data.DataObject = "d_list_unsettled_offservice"
lds_data.setTransObject(SQLCA)
ll_rows = lds_data.retrieve(il_contract_id)
if ll_rows > 0 then
	ldt_start 	= ids_contract_detail.getItemDateTime(1, "delivery")
	ll_last_row = ids_period.RowCount()
	ldt_end		= ids_period.getItemDatetime(ll_last_row, "periode_end")
	for ll_rowno = 1 to ll_rows
		if not( lds_data.getItemDatetime(ll_rowno, "start_date") >= ldt_start and &
				  lds_data.getItemDatetime(ll_rowno, "end_date") <= ldt_end) then
			lds_data.setItem(ll_rowno, "color", 1)	  
			lb_offservice_conflict = true
		end if	
	next
	if lb_offservice_conflict then
		openwithparm(w_show_contract_offservice_mismatch, lds_data)
		destroy lds_data
		return -1
	end if
end if
/****** END check against Off-services ******/

return 1
end function

public function integer of_newcontract ();/* Creates a new TC Contract, and sets all default values */

string ls_tcowner_name, ls_account, ls_statementlogotext
integer li_tcowner_nr, li_pcnr, li_statementlogo

if isNull(ii_vessel_nr) then 
	MessageBox("Insert Error", "Can't create new Contract without a vessel selected")
	return -1
end if

/* Clear the TC Contract ID */
setnull(il_contract_id)

of_resetAll()
ids_contract_detail.insertRow(0)

ids_contract_detail.setItem(1, "vessel_nr", ii_vessel_nr)
ids_contract_detail.setItem(1, "tc_hire_in", 1)
ids_contract_detail.setItem(1, "in_pool", 0)
ids_contract_detail.setItem(1, "bareboat", 0)
ids_contract_detail.setItem(1, "curr_code", "USD")
SELECT TCOWNERS.TCOWNER_NR, TCOWNERS.TCOWNER_N_1, TCOWNERS.NOM_ACC_NR  
 INTO :li_tcowner_nr, :ls_tcowner_name, :ls_account  
 FROM TCOWNERS, VESSELS  
WHERE ( VESSELS.TCOWNER_NR = TCOWNERS.TCOWNER_NR ) and  
		( ( VESSELS.VESSEL_NR = :ii_vessel_nr ));
if SQLCA.SQLCode = 100 then /* Not found */
	setNull(li_tcowner_nr)
	setNull(ls_tcowner_name)
	setNull(ls_account)
end if

SELECT VESSELS.PC_NR,STATEMENT_LOGO,CASE WHEN STATEMENT_LOGO IN(1,3) THEN ISNULL(STATEMENT_LOGO_TEXT,'') ELSE '' END
INTO :li_pcnr, :li_statementlogo, :ls_statementlogotext 
FROM VESSELS,PROFIT_C 
WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND VESSEL_NR = :ii_vessel_nr;
/*Insert vessels's PC*/
ids_contract_detail.setitem(1, "pc_nr", li_pcnr)
ids_contract_detail.setitem(1, "statement_logo", li_statementlogo)
ids_contract_detail.setitem(1, "statement_logo_text", ls_statementlogotext)
ids_contract_detail.setitem(1, "pcnrlogo", string(li_pcnr) + string(li_statementlogo) + lower(ls_statementlogotext))

ids_contract_detail.setItem(1, "tcowner_nr", li_tcowner_nr)
ids_contract_detail.setItem(1, "tcowner_n_1", ls_tcowner_name)
ids_contract_detail.setItem(1, "tcowners_nom_acc_nr", ls_account)
ids_contract_detail.setItem(1, "local_time", 1)
ids_contract_detail.setItem(1, "payment_type", 0)
ids_contract_detail.setItem(1, "payment_due_days", 0)
ids_contract_detail.setItem(1, "monthly_rate", 0)
ids_contract_detail.setItem(1, "hired_by_pool", 0)

of_newPeriod()
/*Refresh dropdown datawindow Print on behalf of*/
of_refresh_pcnrlogo("pcnrlogo")

commit;
return 1
end function

public function integer of_deletecontract ();/********************************************************************
   of_deletecontract
   <DESC>
		
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-03-2015 CR3930      KSH092              revert sent to AX data when delete contract
   </HISTORY>
********************************************************************/

long 	ll_counter, ll_paymentid
string ls_invoice_nr, ls_finemail, ls_sqlerrtext, ls_sqldbcode, ls_sqlcode
int li_row, li_rc, li_tc_in
mt_n_datastore lds_payment
n_tc_transaction	lnv_tc_transaction

if isNull(il_contract_id) then return -1

IF MessageBox("Delete","You are about to DELETE a TC Contract!~r~n" + &
				  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return -1

/* Check if there are payments with status > 2 (final, part-paid, paid) */
SELECT count(*)  
  INTO :ll_counter  
  FROM NTC_PAYMENT  
  WHERE ( NTC_PAYMENT.CONTRACT_ID = :il_contract_id ) AND  
        ( NTC_PAYMENT.PAYMENT_STATUS > 2 );

if ll_counter > 0 then
	MessageBox("Delete Error", "You cannot delete the TC contract, because there is at least one settled Hire Statement.") 
	return -1 
end if
	
/* Check if there are off-services transferred from operation */
SELECT count(NTC_OFF_SERVICE.OFF_SERVICE_ID)  
  INTO :ll_counter  
  FROM NTC_OFF_SERVICE,   
       NTC_PAYMENT  
  WHERE ( NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID ) and  
         ( ( NTC_PAYMENT.CONTRACT_ID = :il_contract_id ));

if ll_counter > 0 then
	MessageBox("Delete Error", "You cannot delete the TC contract, because there is at least one transferred Off-Hire.") 
	return -1 
end if

/* Check if there are port expenses transferred from disbursements */
SELECT count(NTC_PORT_EXP.PORT_EXP_ID)  
  INTO :ll_counter  
  FROM NTC_PORT_EXP,   
       NTC_PAYMENT  
  WHERE ( NTC_PAYMENT.PAYMENT_ID = NTC_PORT_EXP.PAYMENT_ID ) and  
         ( ( NTC_PAYMENT.CONTRACT_ID = :il_contract_id ));

if ll_counter > 0 then
	MessageBox("Delete Error", "You cannot delete the TC contract, because there is at least one transferred Port Expense.") 
	return -1 
end if

/* Check if there are lifted bunker on delivery/redelivery attached to contract */
SELECT count(BP_DETAILS.PAYMENT_ID)  
	INTO :ll_counter  
   FROM BP_DETAILS,   
         NTC_PAYMENT  
   WHERE ( NTC_PAYMENT.PAYMENT_ID = BP_DETAILS.PAYMENT_ID ) and  
         ( ( NTC_PAYMENT.CONTRACT_ID = :il_contract_id ));

if ll_counter > 0 then
	MessageBox("Delete Error", "You cannot delete the TC contract, because there is at least one Lifted Bunker on Delivery/Redelivery.") 
	return -1 
end if

/* Check if there are settled commission attached to contract */
SELECT count(*)
  INTO :ll_counter
  FROM NTC_PAYMENT, NTC_COMMISSION
 WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID AND
       NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL AND
       NTC_PAYMENT.CONTRACT_ID = :il_contract_id;
if ll_counter > 0 then
	messagebox("Delete Error", "You cannot delete the TC contract, because there is at least one settled Commissions.")
	return c#return.Failure
end if

/***********************************************************************/
/* Now it is OK to delete all contract related tables in reverse order */
/***********************************************************************/

if w_tc_contract.wf_deleteattachment() < 1 then
	return -1
end if

DELETE FROM NTC_COMMISSION WHERE NTC_COMMISSION.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID FROM NTC_PAYMENT WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if sqlca.sqlcode <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Delete Error", "Error while deleting table NTC_COMMISSION. ~r~n~r~n" + ls_sqlerrtext )
	return -1
end if

DELETE 
	FROM NTC_NON_PORT_EXP  
   WHERE NTC_NON_PORT_EXP.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_NON_PORT_EXP. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_PAY_CONTRACT_EXP  
   WHERE NTC_PAY_CONTRACT_EXP.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAY_CONTRACT_EXP. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_PAYMENT_DETAIL  
   WHERE NTC_PAYMENT_DETAIL.PAYMENT_ID IN (SELECT NTC_PAYMENT.PAYMENT_ID 
														FROM NTC_PAYMENT 
														WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAYMENT_DETAIL. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

lds_payment = create mt_n_datastore
lds_payment.dataobject = 'd_sq_tb_table_ntc_payment_all'
lds_payment.settransobject(sqlca)
lds_payment.retrieve(il_contract_id)
lnv_tc_transaction = create n_tc_transaction

SELECT TC_HIRE_IN
INTO   :li_tc_in
FROM NTC_TC_CONTRACT
WHERE CONTRACT_ID = :il_contract_id;

if li_tc_in = 0  then//TC out
	for li_row = 1 to lds_payment.rowcount()
		ll_paymentid = lds_payment.getitemnumber(li_row,'payment_id')
		ls_invoice_nr = trim(lds_payment.getitemstring(li_row,'invoice_nr'))
		if isnull(ls_invoice_nr) or trim(ls_invoice_nr) = "" then
			UPDATE TRANS_LOG_MAIN_A
			SET PAYMENT_ID = NULL
			WHERE PAYMENT_ID = :ll_paymentid and
					TRANS_TYPE like "TCCODA%";
			if sqlca.sqlcode < 0 then
				ls_sqlerrtext = sqlca.sqlerrtext
				ls_sqldbcode = string(sqlca.SQLDBCode)
				ls_sqlcode = string(sqlca.SQLCode)
				ROLLBACK;
				messageBox("DB Error", "SqlCode   = "+ls_sqlcode + &
									  "~n~rSql DB Code = "+ls_sqldbcode + &
									  "~n~rSql ErrText = "+ls_sqlerrtext)
				destroy lds_payment
				return c#return.Failure
			end if
		else
			li_rc = lnv_tc_transaction.of_credit_note(ll_paymentid,ls_invoice_nr,ls_finemail)
			if li_rc = c#return.Failure then
				rollback;
				if ls_finemail="" then ls_finemail = "unknown"
				messagebox("Error","The invoice data has not been sent to AX, because the credit note creation failed." + c#string.cr + c#string.cr +"A notification email has been sent to " +  ls_finemail + "." + c#string.cr + "Please contact Finance for further assistance.")
				destroy lds_payment
				return c#return.Failure
			end if
		end if
			
	next
end if
destroy lnv_tc_transaction
DELETE 
	FROM NTC_PAYMENT  
   WHERE NTC_PAYMENT.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_PAYMENT. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_EST_INCOME_EXP  
   WHERE NTC_EST_INCOME_EXP.TC_PERIODE_ID IN (SELECT NTC_TC_PERIOD.TC_PERIODE_ID
																FROM NTC_TC_PERIOD
																WHERE NTC_TC_PERIOD.CONTRACT_ID =:il_contract_id);
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_EST_INCOME_EXP. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_TC_PERIOD  
   WHERE NTC_TC_PERIOD.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_PERIOD. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_CONTRACT_EXPENSE  
   WHERE NTC_CONTRACT_EXPENSE.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_CONTRACT_EXPENSE. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_CONT_BROKER_COMM  
   WHERE NTC_CONT_BROKER_COMM.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_CONT_BROKER_COMM. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_SHARE_MEMBER  
   WHERE NTC_SHARE_MEMBER.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_SHARE_MEMBER. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_BAREBOAT_MANAGEMENT  
   WHERE NTC_BAREBOAT_MANAGEMENT.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_BAREBOAT_MANAGEMENT. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_OPSA_PERIOD  
   WHERE NTC_OPSA_PERIOD.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_OPSA_PERIOD. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_OPSA_POSTING_ELEMENT  
   WHERE NTC_OPSA_POSTING_ELEMENT.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_OPSA_POSTING_ELEMENT. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_OPSA_TRANSFER_POSTING  
   WHERE NTC_OPSA_TRANSFER_POSTING.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_OPSA_TRANSFER_POSTING. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

DELETE 
	FROM NTC_TC_ACTION_LOG  
   WHERE NTC_TC_ACTION_LOG.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then 
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_ACTION_LOG. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

UPDATE POC 
	SET CONTRACT_ID = NULL
	WHERE CONTRACT_ID = :il_contract_id;
if sqlca.sqlcode <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("POC Update Error", "Update of ContractID in POC failed!. ~r~n~r~n" + ls_sqlerrtext)
	return -1
end if

DELETE 
	FROM NTC_TC_CONTRACT  
   WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id;
if SQLCA.SQLCODE <> 0 then
	ls_sqlerrtext = sqlca.sqlerrtext
	rollback;
	MessageBox("Delete Error", "Error while deleting table NTC_TC_CONTRACT. ~r~n~r~n" + ls_sqlerrtext)
	return -1 
end if

COMMIT;
setNull(il_contract_id)
of_resetAll()
destroy lds_payment
return 1
end function

public function integer of_deletebroker (long al_rowno);/* Deletes the broker and alle commissions that are not settled, and related to thic contract */

long 	ll_broker_nr
string	ls_comment = "" 

if al_rowno < 1 then 
	MessageBox("Delete Error", "Please select a Broker")
	return -1
end if

/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
if of_validate_paymentstatus() = c#return.Failure then return c#return.Failure

IF MessageBox("Delete Error","You are about to DELETE a Broker and all commissions that are not settled!~r~n~r~n" + &
				  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return -1

if isNull(il_contract_id) then return 1
ll_broker_nr = ids_broker_comm.getItemNumber(al_rowno, "broker_nr")

/* Check if broker is used on a NOT settled non port expense  */
SELECT NTC_NON_PORT_EXP.COMMENT  
INTO :ls_comment
FROM NTC_NON_PORT_EXP,   
	NTC_NON_PORT_EXP_BROKER_COMM,   
	NTC_PAYMENT  
WHERE NTC_NON_PORT_EXP_BROKER_COMM.NON_PORT_ID = NTC_NON_PORT_EXP.NON_PORT_ID  
AND NTC_PAYMENT.PAYMENT_ID = NTC_NON_PORT_EXP.PAYMENT_ID 
AND NTC_PAYMENT.CONTRACT_ID = :il_contract_id  
AND NTC_NON_PORT_EXP_BROKER_COMM.BROKER_NR = :ll_broker_nr
AND NTC_NON_PORT_EXP.TRANS_TO_CODA = 0;

if ls_comment <> "" then 
	MessageBox("Delete Error", "You are not allowed to delete a Broker that is used on a NOT Settled Non-Port Expense.~r~n~r~n" &
									+"You have to remove the Broker from the Non-Port Expense before deleting the Broker from the Contract.~r~n~r~n" &
									+ "Non-Port Expense Comment = '"+ ls_comment +"'")
	return -1
end if

/* Delete all future commissions that are not settled */
DELETE NTC_COMMISSION  
	FROM NTC_COMMISSION,   
		NTC_PAYMENT  
	WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID and  
		NTC_COMMISSION.BROKER_NR = :ll_broker_nr AND  
		NTC_PAYMENT.CONTRACT_ID = :il_contract_id and
		NTC_COMMISSION.COMM_SETTLE_DATE is NULL;

return ids_broker_comm.deleteRow(al_rowno)


end function

private function integer of_createdatastores ();/* Create alle datastores, sets the dataobject and link to transaction
	returns:		-1=failed / 1=OK
*/

ids_contract_detail = CREATE n_ds
ids_contract_detail.dataObject = "d_tc_contract"
ids_contract_detail.setTransObject(SQLCA)

ids_broker_comm = CREATE n_ds
ids_broker_comm.dataObject = "d_tc_brokercomm"
ids_broker_comm.setTransObject(SQLCA)

ids_contract_exp = CREATE n_ds
ids_contract_exp.dataObject = "d_tc_contract_expenses"
ids_contract_exp.setTransObject(SQLCA)

ids_period = CREATE n_ds
ids_period.dataObject = "d_tc_periode"
ids_period.setTransObject(SQLCA)

ids_share_member = CREATE n_ds
ids_share_member.dataObject = "d_tc_contract_share_members"
ids_share_member.setTransObject(SQLCA)

ids_non_port_exp = CREATE n_ds
ids_non_port_exp.dataObject = "d_tc_non_port_expenses"
ids_non_port_exp.setTransObject(SQLCA)

ids_bareboat_management = CREATE n_ds
ids_bareboat_management.dataObject = "d_tc_bareboat_management"
ids_bareboat_management.setTransObject(SQLCA)

ids_settled_payment = CREATE n_ds
ids_settled_payment.dataObject = "d_settled_payment"
ids_settled_payment.setTransObject(SQLCA)

ids_new_draft_payment = CREATE n_ds
ids_new_draft_payment.dataObject = "d_sq_gr_payment_new_draft"
ids_new_draft_payment.setTransObject(SQLCA)

ids_final_payment = CREATE n_ds
ids_final_payment.dataObject = "d_sq_gr_payment_final"
ids_final_payment.setTransObject(SQLCA)

return 1
end function

public function integer of_fixture ();long 		ll_rows, ll_rowno
string 	ls_note
string	ls_text 

/* Check Pool Commission */
if MessageBox("Warning", "Important for Broström, Handytankers and MR:" &
	+ "~r~n~r~nFor all voyages starting after 01-08-2015,~r~nHave you checked that pool commission has NOT been entered?", Question!, YesNo!,2) = 2 then 
	return 1
end if

/* if no data return */
if ids_contract_detail.rowCount() <> 1 then return 1

if not isNull(ids_contract_detail.getItemString(1, "fixture_user_id")) then
	MessageBox("Information", "Contract already fixtured")
	return 1
end if

//only Chartering profile or "administrator" can fixture TC
if (uo_global.ii_user_profile = 1) or (uo_global.ii_access_level = 3) then   
	ids_contract_detail.setItem(1, "fix_date", today())
	ids_contract_detail.setItem(1, "fixture_user_id", uo_global.is_userid)
	// Build TC Hire Fixture Note 
	ls_note += "TC Hire:~t~t"
	if ids_contract_detail.getItemNumber(1, "tc_hire_in") = 1 then
		ls_note += "IN"
	else
		ls_note += "OUT"
	end if

	ls_note += "~r~nPool:~t~t~t"
	if ids_contract_detail.getItemNumber(1, "in_pool") = 1 then
		ls_note += "Yes"
	else
		ls_note += "No"
	end if

	ls_note += "~r~nBareboat:~t~t"
	if ids_contract_detail.getItemNumber(1, "bareboat") = 1 then
		ls_note += "Yes"
	else
		ls_note += "No"
	end if

	ls_note += "~r~nC/P date:~t~t"
	ls_note += string(ids_contract_detail.getItemDatetime(1, "cp_date"), "dd-mmm-yyyy")

	ls_note += "~r~nC/P text:~t~t"
	ls_text += ids_contract_detail.getItemString(1, "cp_text")
	if not isNull(ls_text) and ls_text <> "" then ls_note += ls_text 

	ls_note += "~r~nCurrency:~t~t"
	ls_note += ids_contract_detail.getItemString(1, "curr_code")
	
	ls_note += "~r~nCharterer:~t~t"
	ls_text = ids_contract_detail.getItemString(1, "chart_n_1")
	if not isNull(ls_text) and ls_text <> "" then ls_note += ls_text 
	
	ls_note += "~r~nHeadowner:~t~t"
	ls_text = ids_contract_detail.getItemString(1, "tcowner_n_1")
	if not isNull(ls_text) then ls_note += ls_text 

	ls_note += "~r~nTC Owner:~t~t"
	ls_text = ids_contract_detail.getItemString(1, "tcowners2_tcowner_n_1")
	if not isNull(ls_text) then ls_note += ls_text 

	ls_note += "~r~nOffice:~t~t~t"
	ls_text = ids_contract_detail.getItemString(1, "office_name")
	if not isNull(ls_text) then ls_note += ls_text 
	
	ls_note += "~r~nDelivery:~t~t"
	ls_note += string(ids_contract_detail.getItemDatetime(1, "delivery"), "dd-mmm-yyyy hh:mm")
	if ids_contract_detail.getItemNumber(1, "local_time") = 1 then
		ls_note += " LT"
	else
		ls_note += " UTC"
	end if
	
	ls_note += "~r~nPayment:~t~t"
	choose case ids_contract_detail.getItemNumber(1, "payment_type")
		case 0 			/* Monthly at 00:00 */
			ls_note += "Monthly payments, every " &
					  + string(ids_contract_detail.getItemNumber(1, "payment")) &
					  + " at 00:00"
		case 1			/* Interval payments delivery time */  
			ls_note += "Payments every " &
					  + string(ids_contract_detail.getItemNumber(1, "payment")) &
					  + " day at delivery time"
		case 2 			/* Monthly at delivery time */
			ls_note += "Monthly payments, every " &
					  + string(ids_contract_detail.getItemNumber(1, "payment")) &
					  + " at delivery time"
		case 3 			/* Half Monthly at delivery time */
			ls_note += "Half monthly payments at delivery time"
		case else
			ls_note += "Error"
	end choose
	if ids_contract_detail.getItemNumber(1, "monthly_rate") = 1 then
		ls_note += ", Monthly rate"
	else
		ls_note += ", Daily rate"
	end if
	ls_note += ", Duedate moved " + string(ids_contract_detail.getItemNumber(1, "payment_due_days"))+ " day(s)"
	
	ls_note += "~r~nAddr. comm.:~t~t"
	ls_note += string(ids_contract_detail.getItemNumber(1, "adr_comm"), "#,##0.00") + " %"

	ls_note += "~r~nOption period:~t~t"
	ls_text += ids_contract_detail.getItemString(1, "option_period") 
	if not isNull(ls_text) and ls_text <> "" then ls_note += ls_text 
	
	/* Brokers */
	ls_note += "~r~n~r~nBroker Information:"
	ll_rows = ids_broker_comm.rowCount()
	for ll_rowno = 1 to ll_rows
		ls_note += "~r~n"
		ls_text = ids_broker_comm.getItemString(ll_rowno, "broker_name")
		ls_note += ls_text + space(35 - len(ls_text)) + "~t"
		if ids_broker_comm.getItemNumber(ll_rowno, "amount_per_day_or_percent") = 0 then
			ls_note += string(ids_broker_comm.getItemNumber(ll_rowno, "broker_comm"), "#,##0.00") + "%~t"
		else
			ls_note += string(ids_broker_comm.getItemNumber(ll_rowno, "broker_comm"), "#,##0.00") + " per day~t"			
		end if
		if ids_broker_comm.getItemNumber(ll_rowno, "primary_broker") = 1 then
			ls_note += "Primary broker~t"
		end if
		if ids_broker_comm.getItemNumber(ll_rowno, "comm_set_off") = 1 then
			ls_note += "Commission Set-off in hire"
		end if
	next
	/* Contract Expenses */
	ls_note += "~r~n~r~nContract Expenses:"
	ll_rows = ids_contract_exp.rowCount()
	for ll_rowno = 1 to ll_rows
		ls_note += "~r~n"
		ls_text = ids_contract_exp.getItemString(ll_rowno, "type_desc")
		if len(ls_text) > 30 then
			ls_text = mid(ls_text, 1, 30)
		end if
		ls_note += ls_text + space(30 - len(ls_text)) + "~t"
		ls_text = string(ids_contract_exp.getItemNumber(ll_rowno, "expense_amount"), "#,##0.00")
		ls_note += space(15 - len(ls_text)) + ls_text + "~t" 
		if ids_contract_exp.getItemNumber(ll_rowno, "expense_monthly") = 1 then
			ls_note += "Monthly expense"
		else
			ls_note += "Daily expense"
		end if
	next
	/* Periods */
	ls_note += "~r~n~r~nPeriods:"
	ls_note += "~r~n~Rate           ~tDate                         ~tOff-days Allowance         ~tEst.expenses   Est.income"
	ll_rows = ids_period.rowCount()
	for ll_rowno = 1 to ll_rows
		ls_note += "~r~n"
		ls_text = string(ids_period.getItemNumber(ll_rowno, "rate"), "#,##0.00")
		ls_note += space(15 - len(ls_text)) + ls_text + "~t" 
		ls_note += string(ids_period.getItemDatetime(ll_rowno, "periode_start"), "dd/mm-yy hh:mm")
		ls_note += "-" + string(ids_period.getItemDatetime(ll_rowno, "periode_end"), "dd/mm-yy hh:mm") + "~t"
		ls_text = string(ids_period.getItemNumber(ll_rowno, "est_off_days"), "#,##0")
		ls_note += space(8 - len(ls_text)) + ls_text + " " 
		ls_text = string(ids_period.getItemNumber(ll_rowno, "allowance"), "#,##0;;0;0")
		ls_note += space(5 - len(ls_text)) + ls_text  
		if ids_period.getItemNumber(ll_rowno, "allowance_type" ) = 1 then
			ls_note += " per incident~t"
		else
			ls_note += " per month   ~t"
		end if
		ls_text = string(ids_period.getItemNumber(ll_rowno, "est_expenses"), "#,##0.00")
		ls_note += space(12 - len(ls_text)) + ls_text + " "  
		ls_text = string(ids_period.getItemNumber(ll_rowno, "est_income"), "#,##0.00")
		ls_note += space(12 - len(ls_text)) + ls_text + " "  
		if ids_period.getItemNumber(ll_rowno, "internal_tc") = 1 then
			ls_note += "Internal TC"
		end if
	next
	/* NON Port Expenses */
	ls_note += "~r~n~r~nNon-Port Expenses:"
	ls_note += "~r~n~Exp./Inc.   Type Description                                  Comment                                           Act.Period Payment   Amount         Curr.   Exc.Rate       Use in VAS"
	ll_rows = ids_non_port_exp.rowCount()
	for ll_rowno = 1 to ll_rows
		ls_note += "~r~n"
		if ids_non_port_exp.getItemNumber(ll_rowno, "income") = 1 then
			ls_note += "Income      "
		else
			ls_note += "Expense     "
		end if			
		ls_text = ids_non_port_exp.getItemString(ll_rowno, "type_desc")
		ls_note += ls_text + space(50 - len(ls_text))  
		ls_text = ids_non_port_exp.getItemString(ll_rowno, "exp_comment")
		ls_note += ls_text + space(50 - len(ls_text)) 
		ls_note += string(ids_non_port_exp.getItemDatetime(ll_rowno, "activity_period"), "mm-yyyy    ")
		if ids_non_port_exp.getItemNumber(ll_rowno, "final_hire") = 1 then
			ls_note += "Final     "
		else
			ls_note += "Next      "
		end if			
		ls_text = string(ids_non_port_exp.getItemNumber(ll_rowno, "amount"), "#,##0.00")
		ls_note += ls_text + space(15 - len(ls_text)) 
		ls_text = ids_non_port_exp.getItemString(ll_rowno, "curr_code")
		ls_note += ls_text + space(8 - len(ls_text)) 
		ls_text = string(ids_non_port_exp.getItemNumber(ll_rowno, "ex_rate_tc"), "#,##0.0000")
		ls_note += ls_text + space(15 - len(ls_text))  
		if ids_non_port_exp.getItemNumber(ll_rowno, "use_in_vas") = 1 then
			ls_note += "Yes"
		else
			ls_note += "No"
		end if			
	next
	/* Share Members */
	ls_note += "~r~n~r~nShare Members:"
	ll_rows = ids_share_member.rowCount()
	for ll_rowno = 1 to ll_rows
		ls_note += "~r~n"
		ls_text = ids_share_member.getItemString(ll_rowno, "tcowner_ln")
		ls_note += ls_text + space(35 - len(ls_text)) + "~t"
		ls_note += string(ids_share_member.getItemNumber(ll_rowno, "percent_share"), "#,##0.00") + "%~t"
		if ids_share_member.getItemNumber(ll_rowno, "apm_company") = 1 then ls_note += "A.P. Møller - Mærsk A/S"
	next
	/* Hired by Pool */
	ls_note += "~r~nHired by Pool:~t~t"
	if ids_contract_detail.getItemNumber(1, "hired_by_pool") = 1 then
		ls_note += "Yes"
	else
		ls_note += "No"
	end if

	ids_contract_detail.setItem(1, "fix_note", ls_note)	
else
	MessageBox("Information", "Only users with Charterer profile can fixture TC")
end if

commit;
return 1
end function

public function integer of_gettcinortcout ();if ids_contract_detail.rowCount() < 1 then
	MessageBox("Information", "No current Contract active. Please select one and try again.")
	return -1
end if

return ids_contract_detail.getItemNumber(1, "tc_hire_in")
end function

public function long of_newperiod ();long ll_row
datetime ldt_period_end_org
LONG li_payment_id,li_payment_status

if isNull(ii_vessel_nr) then 
	MessageBox("Insert Error", "Can't create new Contract without a vessel selected")
	return -1
end if

if ids_period.rowcount() > 0 then
	if not isnull(il_contract_id) then
		SELECT MAX(PAYMENT_ID)
		INTO :LI_PAYMENT_ID
		FROM NTC_PAYMENT
		WHERE CONTRACT_ID = :il_contract_id;
		
		SELECT PAYMENT_STATUS
		INTO :LI_PAYMENT_STATUS
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID = :LI_PAYMENT_ID;
		if li_payment_status > 2 then
			ldt_period_end_org = ids_period.getitemdatetime(ids_period.rowcount(),'periode_end',Primary!,true)
			if of_validate_add_period(ldt_period_end_org) = c#return.Failure then return c#return.Failure
		end if
	end if
end if

ll_row = ids_period.insertRow(0)

/* Default values */
if ll_row > 0 then
	if not isNull(il_contract_id) then
		ids_period.setItem(ll_row, "contract_id", il_contract_id)
	end if
	ids_period.setItem(ll_row, "allowance_type", 0)
	ids_period.setItem(ll_row, "internal_tc", 0)
	ids_period.setItem(ll_row, "finished", 0)
end if

/* Set Startdate equals previous enddate */
if ll_row > 1 then  
	ids_period.setItem(ll_row, "periode_start", &
					ids_period.getItemDatetime(ll_row - 1, "periode_end"))
end if	

return ll_row
end function

public function integer of_finishperiod (long al_row);// al_row equals the periode to close

/* if no data return */
if ids_period.rowCount() < 1 then return 1

//only operator profile or "administrator"can finish TC
if (uo_global.ii_user_profile = 2) or (uo_global.ii_access_level = 3) then   
	if ids_period.getItemNumber(al_row, "finished") = 1 then
		ids_period.setItem(al_row, "finished", 0)
	else
		ids_period.setItem(al_row, "finished", 1)
	end if
else
	MessageBox("Information", "Only users with Operator profile can finish/un-finish periode")
end if

COMMIT;
return 1
end function

public function integer of_deleteperiod (long al_rowno);datetime		ldt_redelivery,ldt_period_start,ldt_period_end
long			ll_counter, li_period, ll_final_row, ll_draft_row ,ll_count
 

if ids_period.rowCount() < 2 then
	MessageBox("Delere Error", "You must have at least one period defined")
	return -1
else	
	if ids_period.getItemNumber(al_rowno, "est_expenses")>0 or ids_period.getItemNumber(al_rowno, "est_income")>0 then
		messagebox("Delete Error","Before you can delete this period you must remove all estimates first.")
		return -1
	end if	
end if


ldt_period_start = ids_period.getitemdatetime(al_rowno,'periode_start',Primary!,true)
ldt_period_end = ids_period.getitemdatetime(al_rowno,'periode_end',Primary!,true)
SELECT count(*)
INTO :ll_count
FROM NTC_PAYMENT P,NTC_PAYMENT_DETAIL PD
WHERE ((PD.PERIODE_START >= :LDT_PERIOD_START AND PD.PERIODE_END < :LDT_PERIOD_END) or
				       (PD.PERIODE_START <=:LDT_period_start AND PD.PERIODE_END >:LDT_PERIOD_start) OR
						 (PD.PERIODE_START <:LDT_period_end AND PD.PERIODE_END >=:LDT_PERIOD_END)) AND 
P.PAYMENT_STATUS > 2 and P.CONTRACT_ID = :il_contract_id AND P.PAYMENT_ID = PD.PAYMENT_ID;
if ll_count > 0 then
	messagebox('Validation','There is at least one hire statement affected, which is in status Final, Part Paid or Paid.~n~r~n~r' &
								  +'Set all affected hire statements to Draft before you modify the selected period.')
	return c#return.Failure
end if

if ids_period.rowcount() = al_rowno then
	if of_validate_reduce_period(ldt_period_start) = c#return.Failure then
		return c#return.Failure
	end if
end if

if al_rowno = 1 then
	ids_period.setItem(2, "periode_start", &
							  ids_period.getItemDatetime(1, "periode_start"))
elseif al_rowno = ids_period.rowcount() and not isNull(il_contract_id) then
	/* Set POC redelivery date equals last period end */
	ldt_redelivery = ids_period.getItemDatetime(al_rowno -1, "periode_end")
	UPDATE POC 
		SET PORT_DEPT_DT = :ldt_redelivery
		WHERE CONTRACT_ID = :il_contract_id 
		AND PURPOSE_CODE = "RED" ;
	if sqlca.sqlcode <> 0 then
		rollback;
		MessageBox("POC Update Error", "Update of Port Departure Date in POC failed!")
		return -1
	end if
else
	ids_period.setItem(al_rowno +1, "periode_start", &
							  ids_period.getItemDatetime(al_rowno -1, "periode_end"))
end if

return ids_period.deleteRow(al_rowno)
end function

private subroutine of_validate_opsaperiod ();/* This function validates contract periods against OPSA periods 
	If periods are not the same, give the user a warning message.
	The check will be performed when a contract is retrieved, and 
	when it is saved.
	ONLY WARNING*/

datetime 	ldt_contractStart, ldt_contractEnd, ldt_opsaStart, ldt_opsaEnd
integer		li_hire_in, li_opsa_setup

SELECT TC_HIRE_IN, OPSA_SETUP
	INTO :li_hire_in, :li_opsa_setup
	FROM NTC_TC_CONTRACT
	WHERE CONTRACT_ID = :il_contract_id ;

if li_hire_in = 0 and li_opsa_setup = 1 then
	SELECT MIN(PERIODE_START), MAX(PERIODE_END)
		INTO :ldt_contractStart, :ldt_contractEnd
		FROM NTC_TC_PERIOD
		WHERE CONTRACT_ID = :il_contract_id ;
	
	SELECT MIN(OPSA_PERIOD_START), MAX(OPSA_PERIOD_END)
		INTO :ldt_opsaStart, :ldt_opsaEnd
		FROM NTC_OPSA_PERIOD
		WHERE CONTRACT_ID = :il_contract_id ;

	if (ldt_contractStart <> ldt_opsaStart) &
	or (ldt_contractEnd <> ldt_opsaEnd) &
	or isNull(ldt_opsaStart) &
	or isNull(ldt_opsaEnd) then
		MessageBox("Information", "TC Contract Periods and OPSA Periods mismatch. Please ask finance department to fix this!")
	end if
end if

return 
end subroutine

public function integer of_getvesselnr ();/* Returns the current contract vessel number */

return ii_vessel_nr
end function

public subroutine of_refresh_pcnrlogo (string as_column);/********************************************************************
   of_refresh_pcnrlogo
   <DESC>	Description	</DESC>
   <RETURN>	(none):Refresh 'pcnrlogo' dropdown datawindow data
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		as_column
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30-09-2011 2485         LHC010        First Version
   </HISTORY>
********************************************************************/
integer li_findrow, li_insertrow, li_pcnr, li_statementlogo, li_getrow, li_null
string ls_statementlogotext, ls_findstring, ls_templatename, ls_pcname, ls_orilogotext
datawindowchild ldwc_pcnrlogo

setnull(li_null)

idw_contract.getchild(as_column, ldwc_pcnrlogo)
ldwc_pcnrlogo.settransobject(sqlca)
ldwc_pcnrlogo.retrieve( uo_global.is_userid )

li_getrow = idw_contract.getrow()

if li_getrow <= 0 then return

li_pcnr = idw_contract.getitemnumber(li_getrow, "pc_nr")
li_statementlogo = idw_contract.getitemnumber(li_getrow, "statement_logo")
/*if Statement logo is Maersk Star or Enter Company Name..., Statement text*/
if li_statementlogo = 1 or li_statementlogo = 3 then
	ls_statementlogotext = idw_contract.getitemstring(li_getrow, "statement_logo_text")
end if

ls_orilogotext  = ls_statementlogotext
ls_templatename = ls_statementlogotext

ls_statementlogotext = lower(trim(ls_statementlogotext))

if not isnull(li_pcnr) then ls_findstring += string(li_pcnr)

ls_findstring += string(li_statementlogo)

if not isnull(ls_statementlogotext) and not isnull(li_pcnr) then ls_findstring += ls_statementlogotext

li_findrow = ldwc_pcnrlogo.find("compute_pcnrlogo = '" + ls_findstring + "'", 1, ldwc_pcnrlogo.rowcount())
if li_findrow <= 0 and li_pcnr >= 0 then
	li_insertrow = ldwc_pcnrlogo.insertrow(0)
	
	choose case li_statementlogo
		case 1, 3
			if isnull(ls_statementlogotext) or len(ls_statementlogotext) <= 0 then
				ls_templatename = 'Maersk Star'
			else
				ls_templatename = 'Maersk Star - ' + ls_templatename
			end if
		case 2
			ls_templatename = 'Handytankers'
		case 8
			ls_templatename = 'Broström'
		case 9
			ls_templatename = 'Swift Tankers'
		case 10
			ls_templatename = 'Broström Singapore'
	end choose
	
	SELECT PC_NAME into :ls_pcname from PROFIT_C where PC_NR = :li_pcnr;
	//Insert history statement if dropdown is not data.
	ldwc_pcnrlogo.setitem( li_insertrow, "pc_nr", li_pcnr)
	ldwc_pcnrlogo.setitem( li_insertrow, "pc_name", ls_pcname )
	ldwc_pcnrlogo.setitem( li_insertrow, "templatename", ls_templatename)
	ldwc_pcnrlogo.setitem( li_insertrow, "statement_logo", li_statementlogo )
	ldwc_pcnrlogo.setitem( li_insertrow, "statement_logo_text", ls_orilogotext )
	ldwc_pcnrlogo.sort()
	
	li_findrow = ldwc_pcnrlogo.find("compute_pcnrlogo = '" + ls_findstring + "'", 1, ldwc_pcnrlogo.rowcount())
end if

/*Insert Vessel's PC*/
li_insertrow = ldwc_pcnrlogo.insertrow(0)
ldwc_pcnrlogo.setitem( li_insertrow, "pc_nr", li_null)
ldwc_pcnrlogo.setitem( li_insertrow, "pc_name", "Vessel's PC" )
ldwc_pcnrlogo.setitem( li_insertrow, "templatename", "Maersk Star" )
ldwc_pcnrlogo.setitem( li_insertrow, "statement_logo", 1 )

if li_findrow > 0 then
	ldwc_pcnrlogo.scrolltorow(li_findrow)
	ldwc_pcnrlogo.setrow(li_findrow)
end if

end subroutine

public function integer of_validate_paymentstatus ();/********************************************************************
   of_validate_paymentstatus
   <DESC>
		There is no payment with status New or Draft in the TC contract, before Tramos can save this change.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-05-2012 M5-12        LHC010        First Version
		26-06-2012 2851			LGX001        It is possible to create a new contract with at least 1 period record
		30-07-2013 2861			LGX001		1.When all payments are unlocked and no payment has status New or Draft, but the last payment has status
															Final, the error message must say: 'Tramos can not save this change, because there is no payment with
															status New or Draft in the TC contract. Please contact an Operator to set the last payment to Draft.'
														2.Only when all payments are locked and/or Paid or Part-Paid, the current error message should be shown
														3.restruct the source code
   </HISTORY>
********************************************************************/
long 	ll_rowcount, ll_lastrow_status, ll_lastrow_locked,ll_row,ll_count,ll_cont_exp_id
mt_n_datastore lds_payment

//this is a new contract then return success
if isNull(il_contract_id) then return c#return.Success
lds_payment = create mt_n_datastore
lds_payment.dataobject = "d_sq_gr_check_payment_status"
lds_payment.settransobject(sqlca)
ll_rowcount = lds_payment.retrieve(il_contract_id)

//Check if there are payments with status <= 2 (New, Draft) 
if lds_payment.find("payment_status <= 2", 1, ll_rowcount) <= 0 then
	//all payments are unlocked and no payment has status New or Draft, but the last payment has status Final
	if ll_rowcount > 0 then
		ll_lastrow_status = lds_payment.getitemnumber(ll_rowcount, "payment_status")
		ll_lastrow_locked = lds_payment.getitemnumber(ll_rowcount, "locked")
	end if
	if ll_lastrow_status = 3  and ll_lastrow_locked = 0 then
		messagebox("Validation", "Tramos can not save this change, because there is no payment with status New or Draft " + &
						"in the TC contract. Please contact an Operator to set the last payment to Draft." )
	else		
		messagebox("Validation", "There is no payment with status New or Draft in the TC contract, " + &
						"before Tramos can save this change. Please contact Finance for assistance " + &
						"with unsettling or unlocking the final hire statement.") 
	end if
	destroy lds_payment
	
	return c#return.Failure
end if	
destroy lds_payment

return c#return.Success

end function

public subroutine documentation ();/********************************************************************
   n_tc_contract
   <OBJECT>	TC contracts	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	31/10/2013   CR3269       ZSW001        Improve the error message when deleting TC contracts with settled commissions
		10/12/2014   CR3565       KSH092        Remove OPSA setup
		10/12/2014   CR2773       KSH092        Remove "Estimated Owner/Charterer Expenses"
		07/04/2015   CR3926       KSH092         A change (by user) in a T/C-Hire (In & Out) contract that affects a hire statement in status Final/Part-Paid/Paid must not be allowed
		16/07/2015   CR4104       LHG008        Change messagebox content for pool commission checking when do fixture
		21/12/2016	 CR4390		  KSH092			 Change default value is daily rate when create new contact
   </HISTORY>
********************************************************************/

end subroutine

public function integer of_sharedatastores (datawindow adw_contract, datawindow adw_brokercomm, datawindow adw_contract_exp, datawindow adw_periods, datawindow adw_non_port_exp);ids_contract_detail.sharedata(adw_contract)
ids_broker_comm.sharedata(adw_brokercomm)
ids_contract_exp.sharedata(adw_contract_exp)
ids_period.sharedata(adw_periods)
ids_non_port_exp.sharedata( adw_non_port_exp )


idw_contract = adw_contract

return 1

end function

public function integer of_bareboatmanagement ();/* This function is for maintaining CODA Elements when register TC-in Contracts
	and where bateboat is selected
	This function must only be available for TC-IN Contracts where bareboat checkmark is true */
long ll_row

if ids_contract_detail.rowCount() < 1 then return 1

if ids_bareboat_management.rowCount() = 0 then
	ids_bareboat_management.insertRow(0)
	ids_bareboat_management.insertRow(0)
	ids_bareboat_management.setItem(1, "contract_id", il_contract_id)
	ids_bareboat_management.setItem(2, "contract_id", il_contract_id)
	ids_bareboat_management.setItem(1, "management_type", 1)
	ids_bareboat_management.setItem(2, "management_type", 2)
	ids_bareboat_management.setItem(1, "third_party", 0)
	ids_bareboat_management.setItem(2, "third_party", 0)
elseif	ids_bareboat_management.rowCount() = 1 then
	ll_row = ids_bareboat_management.insertRow(0)
	ids_bareboat_management.setItem(ll_row, "contract_id", il_contract_id)
	if ids_bareboat_management.getItemNumber(1, "management_type") = 1 then
		ids_bareboat_management.setItem(ll_row, "management_type", 2)
	else
		ids_bareboat_management.setItem(ll_row, "management_type", 1)
	end if
	ids_bareboat_management.setItem(ll_row, "third_party", 0)
end if
openwithparm(w_bareboat_management, ids_bareboat_management )

return 1
end function

public function integer of_validate_rateperiod_paymentstatus ();/********************************************************************
   of_validate_rateperiod_paymentstatus
   <DESC>
		There is no payment with status Final\Part-paid\Paid in the Period, before Tramos can save this change.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-03-2015 CR2897       KSH092       First Version
		
   </HISTORY>
********************************************************************/

long ll_row,ll_count,ll_paymentid
int li_paymentstatus
dec  ldc_rate,ldc_rate_org
datetime ldt_period_start,ldt_period_end,ldt_period_end_org

if isNull(il_contract_id) then return c#return.Success

for ll_row = 1 to ids_period.rowcount()
	
	if ids_period.getitemstatus(ll_row,0,Primary!) <> NewModified! then
		
		ldc_rate = ids_period.getitemdecimal(ll_row,'rate')
		ldc_rate_org = ids_period.getitemdecimal(ll_row,'rate',Primary!,true)
		ldt_period_start = ids_period.getitemdatetime(ll_row,'periode_start')
		ldt_period_end = ids_period.getitemdatetime(ll_row,'periode_end')
		ldt_period_end_org = ids_period.getitemdatetime(ll_row,'periode_end',Primary!,true)
		if isnull(ldc_rate) then ldc_rate = 0
		if isnull(ldc_rate_org) then ldc_rate_org = 0
		if ldc_rate <> ldc_rate_org then
			SELECT count(*)
			INTO :ll_count
			FROM NTC_PAYMENT P,NTC_PAYMENT_DETAIL PD
			WHERE PD.PERIODE_START >= :LDT_PERIOD_START AND PD.PERIODE_END <= :LDT_PERIOD_END AND 
			P.PAYMENT_STATUS > 2 and P.CONTRACT_ID = :il_contract_id AND P.PAYMENT_ID = PD.PAYMENT_ID;
			if ll_count > 0 then
				messagebox('Validation','There is at least one hire statement affected, which is in status Final, Part Paid or Paid.~n~r~n~r' &
				           +'Set all affected hire statements to Draft before you modify the selected period.')
				return c#return.Failure
			end if
		end if
		if ldt_period_end <> ldt_period_end_org then
			if ldt_period_end > ldt_period_end_org then//add period
				SELECT count(*)
				INTO :ll_count
				FROM NTC_PAYMENT P,NTC_PAYMENT_DETAIL PD
				 WHERE ((PD.PERIODE_START >= :LDT_PERIOD_END_ORG AND PD.PERIODE_END < :LDT_PERIOD_END) or
				       (PD.PERIODE_START <=:LDT_period_end_org AND PD.PERIODE_END >:LDT_PERIOD_END_ORG) OR
						 (PD.PERIODE_START <:LDT_period_end AND PD.PERIODE_END >=:LDT_PERIOD_END))
				 AND 
				P.PAYMENT_STATUS > 2 and P.CONTRACT_ID = :il_contract_id AND P.PAYMENT_ID = PD.PAYMENT_ID;
				if ll_count > 0 then
					messagebox('Validation','There is at least one hire statement affected, which is in status Final, Part Paid or Paid.~n~r~n~r' &
								  +'Set all affected hire statements to Draft before you modify the selected period.')
					return c#return.Failure
				end if
				//add period
				if ll_row = ids_period.rowcount() then
					if of_validate_add_period(ldt_period_end_org) = c#return.Failure then
						return c#return.Failure
					end if
				end if
			else//reduce period
				SELECT count(*)
				INTO :ll_count
				FROM NTC_PAYMENT P,NTC_PAYMENT_DETAIL PD
				WHERE ((PD.PERIODE_START >= :LDT_PERIOD_END AND PD.PERIODE_END < :LDT_PERIOD_END_ORG) OR
				  (PD.PERIODE_START < :LDT_period_end_org AND PD.PERIODE_END >= :LDT_PERIOD_END_ORG) OR
						 (PD.PERIODE_START <= :LDT_period_end AND PD.PERIODE_END > :LDT_PERIOD_END))
				AND 
				P.PAYMENT_STATUS > 2 and P.CONTRACT_ID = :il_contract_id AND P.PAYMENT_ID = PD.PAYMENT_ID;
				if ll_count > 0 then
					messagebox('Validation','There is at least one hire statement affected, which is in status Final, Part Paid or Paid.~n~r~n~r' &
								  +'Set all affected hire statements to Draft before you modify the selected period.')
					return c#return.Failure
				end if
				//after delete payment,max payment status
				if ll_row = ids_period.rowcount() then
					if of_validate_reduce_period(ldt_period_end) = c#return.Failure then
						return c#return.Failure
					end if
				end if
			end if
		end if
	end if
next

return c#return.Success
end function

public function integer of_validate_reduce_period (datetime adt_period_end);/********************************************************************
   of_validate_reduce_period( /*datetime adt_period_end */)
   <DESC>
	Do validation before saving: if reduce Period, then validate if the deleted HS was linked to data like Port exp, no port exp, off-hire, etc.  
	1. If yes, validation passes;
	2. If not, search for New/Draft HS; if the New/Draft HS exists, then reallocate it; otherwise no change should be made.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-04-2015 CR3926       KSH092       First Version
		
   </HISTORY>
********************************************************************/

int li_paymentstatus,li_count,li_portexp,li_nonportexp,li_bpdetail,li_offhire,li_settle_comm,li_transfer
long ll_paymentid

SELECT MAX(P.PAYMENT_ID)
INTO :ll_paymentID
FROM NTC_PAYMENT_DETAIL NPD, NTC_PAYMENT P, NTC_TC_CONTRACT M  
WHERE M.CONTRACT_ID = P.CONTRACT_ID 
AND NPD.PAYMENT_ID = P.PAYMENT_ID
AND NPD.PERIODE_START < :adt_period_end  
AND NPD.PERIODE_END >= :adt_period_end
AND NPD.PAYMENT_ID IN (SELECT PAYMENT_ID 
						FROM NTC_PAYMENT 
						WHERE CONTRACT_ID = :il_contract_id);
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "Error while selecting paymentstatus, SQL 1. (n_tc_contract.of_validate_rateperiod_paymentstatus())"+&  
	"~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
	"~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
	"~n~rSql ErrText = "+string(sqlca.SQLErrText))
	return -1
end if
SELECT PAYMENT_STATUS
INTO :LI_PAYMENTSTATUS
FROM NTC_PAYMENT WHERE PAYMENT_ID = :LL_PAYMENTID;


if li_paymentstatus > 2 then//the last HS status is final,part paid or paid
   // PORT EXP
	SELECT COUNT(*)
	INTO :LI_PORTEXP
	FROM NTC_PORT_EXP,NTC_PAYMENT
	WHERE NTC_PORT_EXP.PAYMENT_ID > :LL_PAYMENTID AND NTC_PAYMENT.PAYMENT_ID = NTC_PORT_EXP.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :IL_CONTRACT_ID;
	// NON PORT EXP
	SELECT COUNT(*)
	INTO :LI_NONPORTeXP
	FROM NTC_NON_PORT_EXP,NTC_PAYMENT
	WHERE NTC_NON_PORT_EXP.PAYMENT_ID > :LL_PAYMENTID  AND NTC_PAYMENT.PAYMENT_ID = NTC_NON_PORT_EXP.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :IL_CONTRACT_ID;
	//BP 
	SELECT COUNT(*)
	INTO :LI_bpdetail
	FROM BP_DETAILS,NTC_PAYMENT
	WHERE BP_DETAILS.PAYMENT_ID > :LL_PAYMENTID  AND NTC_PAYMENT.PAYMENT_ID = BP_DETAILS.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :IL_CONTRACT_ID;
	//OFF HIRE
	SELECT COUNT(*)
	INTO :LI_offhire
	FROM NTC_OFF_SERVICE,NTC_PAYMENT
	WHERE NTC_OFF_SERVICE.PAYMENT_ID > :LL_PAYMENTID  AND NTC_PAYMENT.PAYMENT_ID = NTC_OFF_SERVICE.PAYMENT_ID AND NTC_PAYMENT.CONTRACT_ID = :IL_CONTRACT_ID;
	//TC Commission
	SELECT COUNT(*)
	INTO :LI_SETTLE_COMM
	FROM NTC_COMMISSION, NTC_PAYMENT  
	WHERE NTC_PAYMENT.PAYMENT_ID = NTC_COMMISSION.PAYMENT_ID
	AND NTC_PAYMENT.PAYMENT_ID > :ll_paymentID 
	AND NTC_PAYMENT.CONTRACT_ID = :IL_CONTRACT_ID 
	AND NTC_COMMISSION.COMM_SETTLE_DATE IS NOT NULL;
	
	//Transfer
	SELECT COUNT(*)
	INTO :li_TRANSFER
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID > :LL_PAYMENTID AND CONTRACT_ID = :IL_CONTRACT_ID AND ISNULL(TRANSFER_FROM_PREVIOUS,0) > 0 ;
	if li_transfer > 0 then
		messagebox('Validation','You cannot modify the selected period, because there is at least one hire statement with transferred amounts.~n~r~n~r' &
						+'In order to proceed you must clear the transferred amount(s).')

		return c#return.Failure
	end if
	
	if li_portexp > 0  or li_nonportexp > 0 or li_bpdetail > 0 or li_offhire > 0 or li_settle_comm > 0 or li_transfer > 0 then
		SELECT COUNT(*)
		INTO :LI_COUNT
		FROM NTC_PAYMENT
		WHERE NTC_PAYMENT.CONTRACT_ID = :IL_CONTRACT_ID AND PAYMENT_ID < :LL_PAYMENTID AND PAYMENT_STATUS < 3;
		if li_count < 1 then
			messagebox('Validation','There is at least one hire statement with Port Expenses, Non-Port Expenses, Off-Hire, Bunkers on (re)delivery or settled Commissions that cannot be moved, because there is no other hire statement in status New or Draft.~n~r~n~r' &
							+'Set any hire statement to Draft before you modify the selected period.')

			return c#return.Failure
		else
			return c#return.Success
		end if
	else
		return C#return.Success
	end if
else
	return C#return.Success
end if
return C#return.Success
end function

public function integer of_modifyvoyagenumber (long al_row, string as_data);/* This function is used to modify TC Commissions voyagenumber connected to all
	payments matching the period where voyagenumber is changed.
	Only valid for TC Out contracts
	Will only show window if any commissions to be changed */
	
n_ds 			lds_data
integer		li_vessel,li_additional_days
datetime		ldt_start, ldt_end
string		ls_voyage, ls_vessel_ref_nr
long			ll_contractID, ll_rows

if ids_contract_detail.getItemNumber(1, "tc_hire_in")=1 then return 1  // No changes of voyagenumber when tc-in

ll_contractID = ids_contract_detail.getItemNumber(1, "contract_id")
if isNull(ll_contractID) then return 1 // This is a new contract - no payments can have been settled

li_vessel 		= ids_contract_detail.getItemNumber(1, "vessel_nr")
SELECT VESSEL_REF_NR INTO :ls_vessel_ref_nr FROM VESSELS WHERE VESSEL_NR = :li_vessel;

ls_voyage 		= as_data
ldt_start		= ids_period.getItemDatetime(al_row, "periode_start")
ldt_end			= ids_period.getItemDatetime(al_row, "periode_end")

/* Validate Voyage Number */
if len(ls_voyage) <> 5 then
	MessageBox("Validation Error", "Voyage number must be exactly 5 digits.")
	return -1
end if
if mid(string(year(date(ldt_start))),3,4) <> mid(ls_voyage,1,2) then
	MessageBox("Validation Error", "Voyage number must follow periode year. ")
	return -1
end if

lds_data = create n_ds
lds_data.dataObject = "d_ntc_comm_modify_voyage"
lds_data.setTransObject(sqlca)
SELECT isnull(NTC_TC_CONTRACT.PAYMENT_DUE_DAYS,0)  
INTO :li_additional_days  
FROM NTC_TC_CONTRACT  
WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id ;
if li_additional_days <> 0 then
	ldt_start = datetime(relativeDate(date(ldt_start), li_additional_days))
end if
ll_rows = lds_data.retrieve(ll_contractID, ldt_start, ldt_end, ls_voyage)
if ll_rows < 1 then 
	destroy lds_data
	return 1
end if
lds_data.setItem(1, "show_vessel_nr", li_vessel)
lds_data.setItem(1, "show_vessel_ref_nr", ls_vessel_ref_nr)
lds_data.setItem(1, "show_voyage_nr", ls_voyage)

openwithparm(w_ntc_comm_modify_voyage, lds_data)

destroy lds_data
return 1
end function

public function integer of_validate_add_period (datetime adt_period_end);/********************************************************************
   of_validate_add_period( /*datetime adt_period_end */)
   <DESC>
	Do validation before saving: if add Period, then validate if effect final/paid/part paid hire statement is not allow.  

	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-05-2015 CR3926       KSH092       First Version
		
   </HISTORY>
********************************************************************/

int li_paymentstatus,li_additional_days,li_payday,li_interval,li_day,li_month,li_year
long ll_paymentid,ll_no_of_days
datetime ldt_duedate,ldt_duedate_next,ldt_delivery,ldt_period_end
time 		lt_time,lt_delivery
n_tc_payment 	lnv_payment

SELECT MAX(P.PAYMENT_ID)
INTO :ll_paymentID
FROM NTC_PAYMENT_DETAIL NPD, NTC_PAYMENT P, NTC_TC_CONTRACT M  
WHERE M.CONTRACT_ID = P.CONTRACT_ID 
AND NPD.PAYMENT_ID = P.PAYMENT_ID
AND NPD.PERIODE_START < :adt_period_end  
AND NPD.PERIODE_END >= :adt_period_end
AND NPD.PAYMENT_ID IN (SELECT PAYMENT_ID 
						FROM NTC_PAYMENT 
						WHERE CONTRACT_ID = :il_contract_id);
if sqlca.SQLCode <> 0 then 
	MessageBox("DB Error", "Error while selecting paymentid, SQL 1. (n_tc_contract.of_validate_add_period())"+&  
	"~n~r~n~rSqlCode         = "+string(sqlca.SQLCode)+&
	"~n~rSql DB Code = "+string(sqlca.SQLDBCode)+&
	"~n~rSql ErrText = "+string(sqlca.SQLErrText))
	return c#return.Failure
end if

SELECT PAYMENT_STATUS
INTO :li_paymentstatus
FROM NTC_PAYMENT
WHERE PAYMENT_ID = :ll_paymentid AND CONTRACT_ID = :il_contract_id;

if li_paymentstatus > 2 then

	SELECT MAX(PERIODE_END)
	INTO :LDT_PERIOD_END
	FROM NTC_PAYMENT_DETAIL,NTC_PAYMENT 
	WHERE NTC_PAYMENT_DETAIL.PAYMENT_ID = :LL_PAYMENTID AND
		NTC_PAYMENT_DETAIL.PAYMENT_ID = NTC_PAYMENT.PAYMENT_ID AND
		NTC_PAYMENT.CONTRACT_ID = :il_contract_id;
		
	SELECT EST_DUE_DATE
	INTO :ldt_duedate
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID = :ll_paymentID;
	
	SELECT isnull(NTC_TC_CONTRACT.PAYMENT_DUE_DAYS,0)  
	INTO :li_additional_days  
	FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id ;
	
	ldt_duedate = datetime(relativeDate(date(ldt_duedate), -li_additional_days))
	
	SELECT NTC_TC_CONTRACT.PAYMENT,   
		NTC_TC_CONTRACT.PAYMENT,
		NTC_TC_CONTRACT.DELIVERY
	INTO :li_payday,   
			:li_interval,
			:ldt_delivery
	FROM NTC_TC_CONTRACT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = :il_contract_id;

	lnv_payment = create n_tc_payment
	
	choose case ids_contract_detail.getItemNumber(1, "payment_type") 
		case 0  /* monthly payments payday at 00:00 */
			li_day = li_payday
			li_month = month(date(ldt_duedate))
			li_year = year(date(ldt_duedate))
			if datetime(date(li_year, li_month, li_day)) > ldt_duedate then
					ldt_duedate = 	datetime(date(li_year, li_month, li_day))
				else
					if li_month = month(date(ldt_duedate)) then li_month ++
					if li_month = 13 then
						li_month = 1
						li_year ++
					end if
					choose case li_month
						case 2
			//				if li_day > 28 then
							if li_payday > 28 then
								if lnv_payment.of_isleapyear(date(li_year, li_month, 10 )) then
									li_day = 29
								else
									li_day = 28
								end if
							end if
						case 4,6,9,11
			//				if li_day > 30 then
							if li_payday > 30 then
								li_day = 30
							end if
						case 1,3,5,7,8,10,12
							if li_payday = 31 then
								li_day = 31
							end if
					end choose
				end if
				ldt_duedate_next = datetime(date(li_year, li_month, li_day))
			case 1  /* interval payments payday at delivery time */
				lt_time = Time(ldt_duedate)
				ldt_duedate_next = DateTime(RelativeDate(Date(ldt_duedate),li_interval), lt_time)
			case 2  /* monthly payments payday at delivery time */
				li_day = li_payday
				li_month = month(date(ldt_duedate))
				li_year = year(date(ldt_duedate))
				lt_delivery = time(ldt_delivery)
				
				if li_month = month(date(ldt_duedate)) then li_month ++
				if li_month = 13 then
					li_month = 1
					li_year ++
				end if
				choose case li_month
					case 2
		//				if li_day > 28 then
						if li_payday > 28 then
							if lnv_payment.of_isleapyear(date(li_year, li_month, 10 )) then
								li_day = 29
							else
								li_day = 28
							end if
						end if
					case 4,6,9,11
		//				if li_day > 30 then
						if li_payday > 30 then
							li_day = 30
						end if
					case 1,3,5,7,8,10,12
						if li_payday = 31 then
							li_day = 31
						end if
				end choose
				
				ldt_duedate_next = datetime(date(li_year, li_month, li_day), lt_delivery)
		case 3  /* half monthly payments payday at delivery time */
			ll_no_of_days = (lnv_payment.of_lastDayofMonth(date(ldt_duedate))/2) * 86400
			ldt_duedate_next = f_long2datetime((f_datetime2long(ldt_duedate) + ll_no_of_days))
		case else 
			return c#return.Failure
	end choose
   
	 if LDT_PERIOD_END <> ldt_duedate_next then
		messagebox('Validation','There is at least one hire statement affected, which is in status Final, Part Paid or Paid.~n~r~n~r' &
								  +'Set all affected hire statements to Draft before you modify the selected period.')
		return c#return.Failure
	 end if
end if
	

return c#return.Success
end function

on n_tc_contract.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tc_contract.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_createDatastores()
setNull(ii_vessel_nr)
setNull(il_contract_id)
end event

event destructor;of_destroyDatastores()
end event

