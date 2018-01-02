$PBExportHeader$n_tc_nonportexp.sru
$PBExportComments$Used by Non-Port Exp datawindow in w_tc_contract
forward
global type n_tc_nonportexp from nonvisualobject
end type
end forward

global type n_tc_nonportexp from nonvisualobject
end type
global n_tc_nonportexp n_tc_nonportexp

type variables

end variables

forward prototypes
public function integer of_deleterow (datawindow adw_npe, integer al_row)
public function integer of_insertrow (datawindow adw_npe)
private function integer of_validate (datawindow adw_nonportexp, long al_contractid)
public function integer of_update (datawindow adw_nonportexp, long al_contractid)
public subroutine documentation ()
end prototypes

public function integer of_deleterow (datawindow adw_npe, integer al_row);/********************************************************************
   of_deleterow
   <DESC>Deletes the specified row from the datawindow (Non-Port Expenses).</DESC>
   <RETURN>	(none)  
   <ACCESS> </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		06/09/16		CR3979		XSZ004		Fix bug.	      
   </HISTORY>
********************************************************************/

string ls_type, ls_amount, ls_mySQL
long   ll_delPaymentID, ll_non_port_id

IF adw_npe.getitemnumber(al_row, "trans_to_coda") > 0 THEN
	/*the record has a status > 2 (i.e. settled) and is therefore not allowed to be deleted. */
	Messagebox("Operation Not Allowed", "This Non-Port Expense is posted in CODA "&
					+"and therefore it cannot be deleted.", StopSign!)
	RETURN -1
END IF

ls_type   = String(adw_npe.getitemstring(al_row,"type_desc"))
ls_amount = String(adw_npe.getitemnumber(al_row,"amount"))

IF IsNull(ls_type) THEN ls_type = "N/A"
IF IsNull(ls_amount) THEN ls_amount = "N/A"

IF MessageBox("Confirm Delete", "Are you sure you want to delete the record in "+&
					"row # "+ String(al_row) + " (Type: " + ls_type + " , amount: " +&
					ls_amount + " " + &
					adw_npe.getitemstring(al_row,"curr_code") + ")?",Exclamation!, &
					YesNo!, 2) = 1 THEN
					
	ll_delPaymentID = adw_npe.getItemNumber(al_row, "payment_id")
	ll_non_port_id  = adw_npe.getItemNumber(al_row, "non_port_id")
	
	if ll_non_port_id > 0 then
		
		DELETE FROM NTC_NON_PORT_EXP_BROKER_COMM WHERE NON_PORT_ID = :ll_non_port_id;
		DELETE FROM NTC_NON_PORT_EXP WHERE NON_PORT_ID = :ll_non_port_id;
		
		adw_npe.rowsdiscard(al_row, al_row, primary!)
		
		IF sqlca.sqlcode <> 0 THEN
			
			ROLLBACK;		
			MessageBox("Update error", "An error occured while updating the database.~r~n"+&
							"Please try again, or contact the System Administrator, if the "+&
							"problems recurs (reference: n_tc_nonportexp.of_deleterow)", StopSign!)
			RETURN -1
		END IF
	else
		adw_npe.deleterow(al_row)
	end if
ELSE //user does not want to delete
	RETURN -1
END IF

if ll_non_port_id > 0 then
	if not isNull(ll_delPaymentID) then
		ls_mySQL = "sp_paymentBalance " + string(ll_delPaymentID)
		EXECUTE IMMEDIATE :ls_mySQL using sqlca;
		if sqlca.sqlcode <> 0 then
			
			rollback;		
			MessageBox("Update Failed", "Update of Payment Balance via SP failed - 1 (n_tc_nonportexp.of_deleterow()")
			return -1
		end if
	end if
	
	COMMIT;
	
	if isValid(w_tc_payments) then
		w_tc_payments.PostEvent("ue_refresh")
	end if
end if

RETURN 1
end function

public function integer of_insertrow (datawindow adw_npe);/*Inserts a row in the datawindow (Non-Port Expense) and sets default values*/

LONG	ll_row

	ll_row = adw_npe.insertrow(0)
	/* set default values */
	adw_npe.setitem(ll_row, "type_desc", "Select type...")
	adw_npe.setitem(ll_row, "exp_comment", "Enter comment...")
	adw_npe.setitem(ll_row, "final_hire", 0)
	adw_npe.setitem(ll_row, "use_in_vas", 1)
	adw_npe.setitem(ll_row, "income", 0)
	adw_npe.setitem(ll_row, "curr_code", "USD")
	adw_npe.setitem(ll_row, "ex_rate_tc", 100)
	adw_npe.setitem(ll_row, "trans_to_coda", 0)
	adw_npe.setitem(ll_row, "address_commission_pct", 0)
	adw_npe.setitem(ll_row, "address_commission", 0)
	adw_npe.setitem(ll_row, "set_off_broker_comm_pct", 0)
	adw_npe.setitem(ll_row, "set_off_broker_comm", 0)
	adw_npe.setitem(ll_row, "count_broker_comm", 0)
	adw_npe.scrolltorow(ll_row)
	
RETURN 1
end function

private function integer of_validate (datawindow adw_nonportexp, long al_contractid);/*--------------------------------------------------------
Validation for the Non-Port Expense datawindow.
Checks if any of the mandatory fields are left blank.

And calculate Address and Broker Commissions
----------------------------------------------------------*/
LONG				ll_row, ll_rows,  ll_type
STRING			ls_curr
DATETIME		ldt_activity, ldt_contract_start, ldt_contract_end
DECIMAL {2}	ld_commission, ld_commission_pct, ld_amount
DECIMAL			ld_rate

/* Reset filter if rows filtered out, and reset radiobutton */
if adw_nonportexp.filteredCount() > 0 then
	MessageBox("Filtered Rows", "There are rows hidden because of filtered out. In order to validate data correctly filter will be reset!")
	adw_nonportexp.setFilter("")
	adw_nonportexp.filter()
end if
if isValid(w_tc_contract) then w_tc_contract.tab_tc.tp_non_port_exp.rb_inc_exp.checked = true

SELECT DELIVERY INTO :ldt_contract_start FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :al_contractid;
if sqlca.sqlcode <> 0 then
		Messagebox("Validation error", "Select of TC Contract Delivery date failed!", StopSign!)
		return -1
end if
SELECT MAX(PERIODE_END) INTO :ldt_contract_end FROM NTC_TC_PERIOD WHERE CONTRACT_ID = :al_contractid;
if sqlca.sqlcode <> 0 then
		Messagebox("Validation error", "Select of TC Contract Redelivery date failed!", StopSign!)
		return -1
end if
/* Prepare dates for validation - ignore day and time */
ldt_contract_start = datetime(date(year(date(ldt_contract_start)), month(date(ldt_contract_start)),1), time(0,0,0))
ldt_contract_end = datetime(date(year(date(ldt_contract_end)), month(date(ldt_contract_end)),1), time(0,0,0))

ll_rows = adw_nonportexp.rowcount()

FOR ll_row = 1 to ll_rows
	IF adw_nonportexp.getitemstatus(ll_row,0,Primary!) <> NotModified! THEN
		/* Validate */
		ll_type = adw_nonportexp.getitemNumber(ll_row,"exp_type_id")
		ld_amount = adw_nonportexp.getitemnumber(ll_row,"amount")
		ls_curr = adw_nonportexp.getitemstring(ll_row,"curr_code")
		ld_rate = adw_nonportexp.getitemnumber(ll_row,"ex_rate_tc")
		ldt_activity = adw_nonportexp.getItemDatetime(ll_row, "activity_period")
		IF IsNull(ll_type) OR IsNull(ld_amount) OR IsNull(ls_curr) OR IsNull(ld_rate) OR isNull(ldt_activity) THEN
			Messagebox("Validation error", "Please note that blue fields are mandatory.~r~n"+&
							"Values are required in row # " + string(ll_row), StopSign!)
			RETURN -1
		END IF
		if ldt_activity < ldt_contract_start or ldt_activity > ldt_contract_end then
			Messagebox("Validation error", "Activity period in row # " + string(ll_row)+ " must be inside Contract period.", StopSign!)
			RETURN -1
		END IF
		IF ld_amount < 0 THEN
			Messagebox("Validation error", "Expense amount in row # " + string(ll_row)+ " must be greater than 0 (zero).", StopSign!)
			RETURN -1
		END IF
		/*	Calculate  address commission */
		ld_commission_pct = adw_nonportexp.getItemDecimal(ll_row, "address_commission_pct")
		if ld_commission_pct > 0 then
			ld_commission = ld_amount * ld_commission_pct/100
		else
			ld_commission = 0
		end if
		adw_nonportexp.setItem(ll_row, "address_commission", ld_commission )
		/*	Calculate Broker commission set-off */
		ld_commission_pct = adw_nonportexp.getItemDecimal(ll_row, "set_off_broker_comm_pct")
		if ld_commission_pct > 0 then
			ld_commission = ld_amount * ld_commission_pct/100
		else
			ld_commission = 0
		end if
		adw_nonportexp.setItem(ll_row, "set_off_broker_comm", ld_commission )
	END IF
NEXT

RETURN 1
end function

public function integer of_update (datawindow adw_nonportexp, long al_contractid);/*Updates the datawindow (Non-Port Expense)*/

STRING 			ls_curr, ls_mySQL
LONG 				ll_contractid, ll_rows, ll_row, ll_lastunpaid, ll_firstunpaid, ll_paymentsToUpdate[]
n_tc_payment	lnv_tc_payment

IF of_validate(adw_nonportexp, al_contractid) = -1 THEN RETURN -1

SELECT CURR_CODE
	INTO :ls_curr
	FROM NTC_TC_CONTRACT
	WHERE CONTRACT_ID = :al_contractid
COMMIT;

lnv_tc_payment = CREATE n_tc_payment /*to be able to use of_getfirstunpaid and of_getlastunpaid*/

ll_rows = adw_nonportexp.rowcount()
ll_lastunpaid = lnv_tc_payment.of_getlastunpaid(al_contractid)
ll_firstunpaid = lnv_tc_payment.of_getfirstunpaid(al_contractid)
DESTROY lnv_tc_payment

/*Set the payment ID for (modified) Non-Port Expenses*/
FOR ll_row = 1 to ll_rows 
	IF adw_nonportexp.getitemstatus(ll_row,0,Primary!) <> NotModified!  AND &
		adw_nonportexp.getitemNumber(ll_row, "trans_to_coda") <> 1 THEN 
		IF adw_nonportexp.getitemstring(ll_row,"curr_code") <> ls_curr AND adw_nonportexp.getitemnumber(ll_row,"ex_rate_tc") = 100 THEN
			IF MessageBox("Warning","Row " + String(ll_row) + ": Contract Currency is " + ls_curr + " and Non-Port Expense is : " + adw_nonportexp.getitemstring(ll_row,"curr_code") + &
			" and you have entered 100 as ex. rate. Is this correct ?!", Question!,YesNo!,2) = 2 THEN
				RETURN -1		
			END IF
		END IF
		
		IF adw_nonportexp.getitemnumber(ll_row,"final_hire") = 1 THEN //attach to final hire
			IF ll_lastunpaid > 0 THEN
				adw_nonportexp.setitem(ll_row,"payment_id", ll_lastunpaid)
				ll_paymentsToUpdate[upperBound( ll_paymentsToUpdate[]) +1] = ll_lastunpaid
				if adw_nonportexp.getitemNumber(ll_row,"payment_id", primary!, true) <> adw_nonportexp.getitemNumber(ll_row,"payment_id", primary!,  false) then
					/* if next/final modified both payments has to be updated */ 	
					 ll_paymentsToUpdate[upperBound( ll_paymentsToUpdate[]) +1] = adw_nonportexp.getitemNumber(ll_row,"payment_id",  primary!, true)
				end if				 
			ELSE /*of_getlastunpaid did not return a value - i.e. no un-settled payments exist 
					for the contract (error message is given by of_getlastunpaid)*/
				RETURN -1
			END IF //ll_lastunpaid>0
		ELSE //final_hire = 0 - attach to first un-settled
			IF ll_firstunpaid > 0 THEN
				adw_nonportexp.setitem(ll_row,"payment_id",ll_firstunpaid)
				ll_paymentsToUpdate[upperBound( ll_paymentsToUpdate[]) +1] = ll_firstunpaid
				if adw_nonportexp.getitemNumber(ll_row,"payment_id", primary!,  true) <> adw_nonportexp.getitemNumber(ll_row,"payment_id", primary!,  false) then
					/* if next/final modified both payments has to be updated */ 	
					 ll_paymentsToUpdate[upperBound( ll_paymentsToUpdate[]) +1] = adw_nonportexp.getitemNumber(ll_row,"payment_id", primary!,  true)
				end if				 
			ELSE /*of_getfirstunpaid did not return a value - i.e. no un-settled payments exist
					for the contract (error message is given by of_getfirstunpaid)*/
				RETURN -1
			END IF //ll_firstunpaid > 0
		END IF //attach to final hire
	END IF //check for modification of row
NEXT

/* Update the database (including check for successful update)*/
IF adw_nonportexp.update() <> 1 THEN
	MessageBox("Update error", "An error occured while updating the database.~r~n"+&
					"Please try again, or contact the System Administrator, if the problems recurs", StopSign!)
	ROLLBACK;
	RETURN -1
END IF

/* Update Payment Balance */
ll_rows = upperBound( ll_paymentsToUpdate[])
for ll_row = 1 to ll_rows
	ls_mySQL = "sp_paymentBalance " + string(ll_paymentsToUpdate[ll_row])
	EXECUTE IMMEDIATE :ls_mySQL using sqlca;
	if sqlca.sqlcode <> 0 then
		MessageBox("Update Failed", "Update of Payment Balance via SP failed - 1 (n_tc_nonportexp.of_update()")
		rollback;
		return -1
	end if
next

commit;

if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if

RETURN 1
end function

public subroutine documentation ();/********************************************************************
   n_tc_nonportexp
   <OBJECT </OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
		Date    			CR-Ref		Author		Comments
		06/09/16			CR3979		XSZ004		Fix bug.
   </HISTORY>
********************************************************************/
end subroutine

on n_tc_nonportexp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tc_nonportexp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

