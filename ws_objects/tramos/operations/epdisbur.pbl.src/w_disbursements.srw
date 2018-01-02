$PBExportHeader$w_disbursements.srw
$PBExportComments$This is the main disbursements window.
forward
global type w_disbursements from w_vessel_basewindow
end type
type dw_disb_proc_list from u_datagrid within w_disbursements
end type
type dw_disb_agents_list from uo_datawindow within w_disbursements
end type
type cb_agents_new from commandbutton within w_disbursements
end type
type cb_agents_delete from commandbutton within w_disbursements
end type
type cb_currency_cancel from commandbutton within w_disbursements
end type
type dw_disb_currency from uo_datawindow within w_disbursements
end type
type cb_payment_new from commandbutton within w_disbursements
end type
type cb_payment_delete from commandbutton within w_disbursements
end type
type cb_payment_update from commandbutton within w_disbursements
end type
type dw_disb_payments_list from u_datagrid within w_disbursements
end type
type cb_payment_cancel from commandbutton within w_disbursements
end type
type dw_disb_expenses from uo_datawindow within w_disbursements
end type
type dw_disb_dates from uo_datawindow within w_disbursements
end type
type cb_expense_new from commandbutton within w_disbursements
end type
type cb_expense_delete from commandbutton within w_disbursements
end type
type cb_print_port_expenses from commandbutton within w_disbursements
end type
type cb_print_disb_account from commandbutton within w_disbursements
end type
type cb_currency_update from commandbutton within w_disbursements
end type
type cb_payment_print from commandbutton within w_disbursements
end type
type cb_settle_agent from commandbutton within w_disbursements
end type
type cb_print_agent_balance from commandbutton within w_disbursements
end type
type cb_settle_disb from commandbutton within w_disbursements
end type
type dw_disb_payments from uo_datawindow within w_disbursements
end type
type st_1 from u_topbar_background within w_disbursements
end type
type gb_1 from mt_u_groupbox within w_disbursements
end type
type gb_2 from mt_u_groupbox within w_disbursements
end type
type gb_3 from mt_u_groupbox within w_disbursements
end type
end forward

global type w_disbursements from w_vessel_basewindow
integer x = 0
integer y = 0
integer width = 4608
integer height = 2568
string title = "Disbursements"
boolean maxbox = false
boolean resizable = false
string icon = "images\DISB.ICO"
boolean ib_setdefaultbackgroundcolor = true
dw_disb_proc_list dw_disb_proc_list
dw_disb_agents_list dw_disb_agents_list
cb_agents_new cb_agents_new
cb_agents_delete cb_agents_delete
cb_currency_cancel cb_currency_cancel
dw_disb_currency dw_disb_currency
cb_payment_new cb_payment_new
cb_payment_delete cb_payment_delete
cb_payment_update cb_payment_update
dw_disb_payments_list dw_disb_payments_list
cb_payment_cancel cb_payment_cancel
dw_disb_expenses dw_disb_expenses
dw_disb_dates dw_disb_dates
cb_expense_new cb_expense_new
cb_expense_delete cb_expense_delete
cb_print_port_expenses cb_print_port_expenses
cb_print_disb_account cb_print_disb_account
cb_currency_update cb_currency_update
cb_payment_print cb_payment_print
cb_settle_agent cb_settle_agent
cb_print_agent_balance cb_print_agent_balance
cb_settle_disb cb_settle_disb
dw_disb_payments dw_disb_payments
st_1 st_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_disbursements w_disbursements

type prototypes
Function Integer SndPlaySound ( String filename, Integer flag ) Library "mmsystem.dll" alias for "SndPlaySound;Ansi"
end prototypes

type variables
s_disbursement istr_disb
boolean ib_retrieve_detail, ib_ignoredefaultbutton

end variables

forward prototypes
public subroutine in_balance ()
public function integer of_create_expense99 (datetime adt_date, decimal ad_amount)
public subroutine agent_action (integer li_clicked_row)
public function integer wf_currency_warning ()
public subroutine documentation ()
private function integer _validate_paymentstatus ()
public subroutine wf_set_buttons (string as_action)
end prototypes

public subroutine in_balance ();Decimal {2} ld_payment_sum, ld_disbursement_sum
Long ll_counter
ll_counter = 1


ld_payment_sum = Dec( dw_disb_payments_list.describe("Evaluate('"+    dw_disb_payments_list.Describe("payment_sum.Expression")     +"',"+string(ll_counter)+")" )  )

// ld_disbursement_sum = Dec( dw_disb_expenses.describe("Evaluate('"+    dw_disb_expenses.Describe("disbursement_sum.Expression")     +"',"+string(ll_counter)+")" )  )
// This failed in PB version 5.0 therefore code below
IF dw_disb_expenses.RowCount() > 0 THEN
	ld_disbursement_sum = dw_disb_expenses.Object.sum_disbursement[1]
ELSE
	ld_disbursement_sum = 0
END IF


IF ( ld_payment_sum = ld_disbursement_sum) AND  ( ld_payment_sum <> 0 ) THEN
	dw_disb_dates.SetItem(dw_disb_dates.GetRow(),"disbursements_disb_in_balance", 1)
ELSE
	dw_disb_dates.SetItem(dw_disb_dates.GetRow(),"disbursements_disb_in_balance", 0)
END IF

IF dw_disb_dates.Update() = 1 THEN
	Commit;
ELSE
	RollBack;
	MessageBox("Error","Update of finish date failed!!")	
END IF
end subroutine

public function integer of_create_expense99 (datetime adt_date, decimal ad_amount);decimal {5} ld_disb_rate, ld_input_rate, ld_ex_ex_rate
decimal {2} ld_voyage_rate, ld_payment_rate
decimal {2} ld_amount_usd
string  ls_disb_curr, ls_currency_code
int     li_exp_counter
long    ll_row


ld_disb_rate    = dw_disb_currency.GetItemNumber(1, "disb_ex_rate")
ld_voyage_rate  = dw_disb_currency.GetItemNumber(1, "voyage_ex_rate")
ld_payment_rate = dw_disb_currency.GetItemNumber(1, "payment_ex_rate")
ld_input_rate   = dw_disb_currency.GetItemNumber(1, "input_ex_rate")
ld_ex_ex_rate   = dw_disb_currency.GetItemNumber(1, "ex_ex_rate")

IF (ld_disb_rate = 0) OR (ld_voyage_rate = 0) OR (ld_payment_rate = 0) OR (ld_input_rate = 0) THEN
	MessageBox("Notice", "All rates must be given before you can create a Port Expense.")
	Return -1
END IF

IF dw_disb_expenses.RowCount() < 1 THEN
	
	ls_currency_code = f_select_from_list("dw_currency_list", 1, "Code", 3, "Description", 1, "Select Expense Currency", false)
	
	IF IsNull(ls_currency_code) or ls_currency_code = "" THEN Return -1
	
	dw_disb_currency.SetItem(dw_disb_currency.GetRow(), "disbursement_currency", ls_currency_code)
	
	IF dw_disb_currency.Update() = 1 THEN
		Commit;
	ELSE
		Rollback;
		Return -1
	END IF
END IF

ll_row = dw_disb_expenses.InsertRow(0)

dw_disb_expenses.SetItem(ll_row, "disb_expenses_vessel_nr", istr_disb.vessel_nr)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_voyage_nr", istr_disb.voyage_nr)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_port_code", istr_disb.port_code)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_pcn", istr_disb.pcn)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_agent_nr", istr_disb.agent_nr)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_settled", 0)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_expenses_date", adt_date)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_voucher_nr", 99)
dw_disb_expenses.SetItem(ll_row, "disb_expenses_exp_amount_local", ad_amount)

dw_disb_expenses.AcceptText()

SELECT DISBURSEMENT_CURRENCY INTO :ls_disb_curr
FROM   DISBURSEMENTS
WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
       AGENT_NR = :istr_disb.agent_nr;

/* Set amount USD */
IF  (ls_disb_curr = "USD")  THEN
	ld_amount_usd = ad_amount
ELSE
	ld_amount_usd = ((ad_amount * ld_ex_ex_rate) / ld_voyage_rate) 
END IF

dw_disb_expenses.SetItem(ll_row, "disb_expenses_exp_amount_usd", ld_amount_usd)

SELECT max(EXPENSES_COUNTER) INTO :li_exp_counter
FROM   DISB_EXPENSES
WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND PCN =  :istr_disb.pcn AND
       AGENT_NR = :istr_disb.agent_nr;

IF IsNull(li_exp_counter) THEN
	dw_disb_expenses.SetItem(ll_row, "disb_expenses_expenses_counter", 1)
ELSE
	dw_disb_expenses.SetItem(ll_row, "disb_expenses_expenses_counter", li_exp_counter + 1)
END IF

IF dw_disb_expenses.Update() = 1 THEN
	Commit;
ELSE
	Rollback;
	Return -1
END IF

return 1
end function

public subroutine agent_action (integer li_clicked_row);int  li_agent_in_cargo, li_agent_in_port
datetime ldt_port_arr_dt,ldt_port_dept_dt
boolean lb_viapoint = FALSE
n_exchangerate 	lnv_exchangerate


IF li_clicked_row < 1 THEN return

istr_disb.agent_nr = dw_disb_agents_list.GetItemNumber ( li_clicked_row, "disbursements_agent_nr" )

// If The agent has a cargo, set the port datetimes(arrival,departure) in the disbursements table.
ldt_port_arr_dt  = dw_disb_dates.GetItemDatetime(dw_disb_dates.GetRow(), "disbursements_disb_arr_dt")
ldt_port_dept_dt = dw_disb_dates.GetItemDatetime(dw_disb_dates.GetRow(), "disbursements_disb_dept_dt")

IF dw_disb_proc_list.GetItemNumber(dw_disb_proc_list.GetRow(), "proceed_pcn") < 1 THEN lb_viapoint = TRUE

IF NOT lb_viapoint THEN 
	
	setnull(ldt_port_arr_dt)
	setnull(ldt_port_dept_dt)
	
	SELECT count(*) INTO :li_agent_in_cargo
	FROM   CARGO
	WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
	       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
	       AGENT_NR = :istr_disb.agent_nr;
	
	IF (li_agent_in_cargo > 0)  THEN
		
		SELECT PORT_ARR_DT, PORT_DEPT_DT INTO :ldt_port_arr_dt,:ldt_port_dept_dt
		FROM   POC
		WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
		       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn ;
		
	ELSE
		
		SELECT count(*) INTO :li_agent_in_port
		FROM   POC
		WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
		       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
		       AGENT_NR = :istr_disb.agent_nr;
	
		if li_agent_in_port < 1 then
			
			SELECT count(*) INTO :li_agent_in_port
			FROM   TRA_NCAG
			WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
			       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
			       AGENT_NR = :istr_disb.agent_nr;		
		end if
		
		IF (li_agent_in_port > 0)  THEN
			
			SELECT PORT_ARR_DT, PORT_DEPT_DT INTO :ldt_port_arr_dt,:ldt_port_dept_dt
			FROM   POC
			WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
			       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn ;		
		END IF
	END IF
	
	dw_disb_dates.SetItem(li_clicked_row, "disbursements_disb_arr_dt", ldt_port_arr_dt)
	dw_disb_dates.SetItem(li_clicked_row, "disbursements_disb_dept_dt", ldt_port_dept_dt)
	
	IF dw_disb_dates.Update() = 1 THEN
		Commit;
	ELSE
		Rollback;
	END IF
ELSE	
	IF IsNUll(ldt_port_arr_dt) OR IsNull(ldt_port_dept_dt) THEN
		MessageBox("Input","Please input both arr. and dept. date for this viapoint")
	END IF	
END IF

dw_disb_currency.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)
dw_disb_payments.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)
dw_disb_expenses.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)

// Set Local struct settled date & if date is not null, lock payments and currency modifying //

istr_disb.settled_date     = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt")
istr_disb.expense_currency = dw_disb_currency.GetItemString(1, "disbursement_currency")
istr_disb.port_arr_date    = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_arr_dt")
istr_disb.port_dept_date   = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_dept_dt")

// Set Voyage Rate to todays exchange rate as default if not set already 

IF dw_disb_currency.GetItemNumber(1,"voyage_ex_rate") = 0 THEN
	
	dw_disb_currency.SetItem(1,"voyage_ex_rate", lnv_exchangerate.of_gettodaysdkkrate("USD"))
	
	IF dw_disb_currency.Update() = 1 THEN
		Commit;
	ELSE
		Rollback;
	END IF
END IF

// Set In Balance TRUE or FALSE 

In_Balance()

end subroutine

public function integer wf_currency_warning ();/* This function check some currency code/exrate combinations an gives a warning */
string 	ls_disbursement_curr
decimal	ld_payment_exrate, ld_voyage_exrate

if dw_disb_currency.rowCount() < 1 then return 1
if dw_disb_expenses.rowCount() < 1 then return 1

ls_disbursement_curr = dw_disb_currency.getItemString(1, "disbursement_currency")
if isnull(ls_disbursement_curr) then return 1 /* Can't check without currency code entered */

ld_payment_exrate  	= dw_disb_currency.getItemNumber(1, "payment_ex_rate")
ld_voyage_exrate  	= dw_disb_currency.getItemNumber(1, "voyage_ex_rate")

/* Hvis Disbursement currency code er DKK og payment currency rate er forskellig 
	fra 100.00 skal systemet komme med en advarsel. */
if ls_disbursement_curr = "DKK" and ld_payment_exrate <> 100 then 
	MessageBox("Warning", "Please be aware of that Currency code = 'DKK' and payment exchange rate <> 100")
	return -1
end if
	
/* Hvis currency rate i payment og voyage er den samme, og disbursement currency 
	code ikke er USD, skal sytemet komme med en advarsel. */
if ld_payment_exrate = ld_voyage_exrate then
	if ls_disbursement_curr <> "USD" then
		MessageBox("Warning", "Please be aware of that Currency code <> 'USD' and payment exchange rate = voyage exchange rate")
		return -1
	end if
end if

	
/* Hvis disbursement currency code er USD og currency rate i payment og voyage 
	ikke er ens, skal systemet komme med en advarsel. */
if ld_payment_exrate <> ld_voyage_exrate then
	if ls_disbursement_curr = "USD" then
		MessageBox("Warning", "Please be aware of that Currency code = 'USD' and payment exchange rate <> voyage exchange rate")
		return -1
	end if
end if

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_disbursements
   <OBJECT> Disbursements window</OBJECT>
   <DESC>   n/a</DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
	Date    		Ref    	Author		Comments
	00/00/07		?     	Name Here	First Version
	30/01/12		CR2421	JMC112		Disable payment transactions
	12/06/12		M5-12 	RJH022		Check voucher type that is being set up to be transferred to TC hire (either OA or CA), and open payment (New or Draft status)
	29/08/12		CR2857	LGX001      Add the invoice validation when settling expense
	05/06/14		CR3478	XSZ004		Allow to settle expenses with different invoice number
	28/08/14		CR3781	CCY018		The window title match with the text of a menu item
	31/03/15		CR3854	XSZ004		Adjust UI.
	14/04/15		CR3854	XSZ004		Transfer to T/C-Hire when import/new expenses.
	02/12/16		CR4420	XSZ004		Improve settle expenses function.
********************************************************************/
end subroutine

private function integer _validate_paymentstatus ();/********************************************************************
   _validate_paymentstatus
   <DESC>Check voucher type that is being set up to be transferred to TC hire (either OA or CA), 
	and open payment (New or Draft status)</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	 Author             Comments
   	2012-05-08 M5-12            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_tcinout, ll_voucher_nr, ll_count 
long ll_find_ca_or_oa, ll_count_payment

u_transaction_expense lnv_transaction_expense

lnv_transaction_expense = create u_transaction_expense

istr_disb.port_arr_date = dw_disb_dates.getitemdatetime(dw_disb_dates.getrow(), "disbursements_disb_arr_dt")

lnv_transaction_expense.istr_trans_input.vessel_no = istr_disb.vessel_nr
lnv_transaction_expense.istr_trans_input.disb_port_arr_date = istr_disb.port_arr_date
ll_tcinout = lnv_transaction_expense.of_vessel_tc_or_not()

ll_count = dw_disb_expenses.rowcount()
SELECT  count(*)
INTO :ll_count_payment
FROM NTC_TC_CONTRACT,   
	NTC_TC_PERIOD,
	NTC_PAYMENT  
WHERE ( NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID ) and 
		(NTC_PAYMENT.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID ) and 
		(NTC_PAYMENT.PAYMENT_STATUS <= 2) and 
		(NTC_TC_CONTRACT.VESSEL_NR = :istr_disb.vessel_nr ) AND  
		(NTC_TC_PERIOD.PERIODE_START <= :istr_disb.port_arr_date ) AND  
		(NTC_TC_PERIOD.PERIODE_END > :istr_disb.port_arr_date ) ;

choose case ll_tcinout
	case 2 //tc-in
		 ll_find_ca_or_oa = dw_disb_expenses.find("vouchers_tcin_ca_or_oa<> 0 and disb_expenses_settled= 0 ", 1, ll_count)
	case 3 //tc-out
		 ll_find_ca_or_oa = dw_disb_expenses.find("vouchers_tcout_ca_or_oa<> 0 and disb_expenses_settled =0 ", 1, ll_count)
	case 4 //tc-in-out
		 ll_find_ca_or_oa = dw_disb_expenses.find("vouchers_tcinout_ca_or_oa<> 0 and disb_expenses_settled =0 ", 1, ll_count)
end choose
	
if ll_count_payment <= 0 and ll_find_ca_or_oa >0 then
	 messagebox("Validation", "It is not possible to settle disbursements of voucher types that"+&
										" are being set up to be transferred to TC hire (either OA or CA), "+&
										"because there is no payment with status New or Draft."+&
										"Please contact Finance for assistance with unsettling or unlocking the final hire statement.")
	 dw_disb_expenses.setredraw(false)									
	 dw_disb_expenses.selectrow(0, false)	
	 dw_disb_expenses.selectrow(ll_find_ca_or_oa, true)
	 dw_disb_expenses.scrolltorow(ll_find_ca_or_oa)
	 dw_disb_expenses.setredraw(true)			
	 return c#return.Failure
end if

return c#return.Success

end function

public subroutine wf_set_buttons (string as_action);/********************************************************************
   wf_set_buttons
   <DESC> Control buttons. </DESC>
   <RETURN>
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_action
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		22/05/15		CR3854		XSZ004		Control buttons.
   </HISTORY>
********************************************************************/

datetime ldt_settle_date

//disbursement group
dw_disb_agents_list.enabled = false
dw_disb_currency.enabled    = false
dw_disb_dates.enabled       = false

dw_disb_dates.SetTaborder("disbursements_disb_arr_dt", 0)
dw_disb_dates.Object.disbursements_disb_arr_dt.Background.Mode = 1
dw_disb_dates.SetTaborder("disbursements_disb_dept_dt", 0)
dw_disb_dates.Object.disbursements_disb_dept_dt.Background.Mode = 1

cb_agents_new.enabled      = false
cb_currency_update.enabled = false
cb_agents_delete.enabled   = false
cb_currency_cancel.enabled = false
cb_settle_agent.enabled    = false

//payment group
dw_disb_payments_list.enabled = false
dw_disb_payments.modify("datawindow.readonly = yes")

cb_payment_new.enabled         = false
cb_payment_update.enabled      = false
cb_payment_delete.enabled      = false
cb_payment_cancel.enabled      = false
cb_payment_print.enabled       = false
cb_print_agent_balance.enabled = false
cb_print_disb_account.enabled  = false

//expense group
dw_disb_expenses.enabled = false

cb_expense_new.enabled         = false
cb_expense_delete.enabled      = false
cb_settle_disb.enabled         = false
cb_print_port_expenses.enabled = false
	
if as_action = "editagent" or as_action = "newpayment" then

	dw_disb_proc_list.enabled = false
	uo_vesselselect.enabled   = false
	
	if as_action = "newpayment" then
		cb_payment_update.enabled = true
		cb_payment_cancel.enabled = true
		dw_disb_payments.modify("datawindow.readonly = no")
	else
		cb_agents_new.enabled      = true	
		cb_currency_update.enabled = true	
		cb_agents_delete.enabled   = true	
		cb_currency_cancel.enabled = true
		dw_disb_currency.enabled   = true
	end if
elseif as_action = "default" then

	dw_disb_proc_list.enabled = true
	uo_vesselselect.enabled   = true

	dw_disb_agents_list.enabled   = true
	dw_disb_payments_list.enabled = true
	dw_disb_expenses.enabled      = true
	
	if dw_disb_proc_list.getselectedrow(0) > 0 then
		
		cb_agents_new.enabled       = true
		dw_disb_agents_list.enabled = true
		
		if istr_disb.pcn < 1 then		
			dw_disb_dates.enabled = true			
			dw_disb_dates.SetTaborder("disbursements_disb_arr_dt", 100)
			dw_disb_dates.Object.disbursements_disb_arr_dt.Background.Mode = 0
			dw_disb_dates.Object.disbursements_disb_arr_dt.Background.Color = RGB(255, 255, 255)
			dw_disb_dates.SetTaborder("disbursements_disb_dept_dt", 200)
			dw_disb_dates.Object.disbursements_disb_dept_dt.Background.Mode = 0
			dw_disb_dates.Object.disbursements_disb_dept_dt.Background.Color = RGB(255, 255, 255)
		end if	
	end if
	
	if dw_disb_agents_list.getselectedrow(0) > 0 then
		
		dw_disb_currency.enabled = true
		cb_settle_agent.enabled  = true
		cb_agents_delete.enabled = true
		
		cb_print_disb_account.enabled  = true
		cb_print_agent_balance.enabled = true
		cb_payment_new.enabled = true
			
		cb_expense_new.enabled = true
		
		ldt_settle_date = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt")

		if not isnull(ldt_settle_date) then
			dw_disb_currency.Enabled = false
		end if
		
		if dw_disb_expenses.rowcount() > 0 then
			
			if dw_disb_expenses.getselectedrow(0) > 0 then
				if dw_disb_expenses.GetItemNumber(dw_disb_expenses.getselectedrow(0), "disb_expenses_settled") = 0 then 
					cb_expense_delete.Enabled = true
				end if
			end if	
			
			if isnull(ldt_settle_date) then
				cb_settle_disb.enabled = true
			end if
			
			cb_print_port_expenses.enabled = true
			dw_disb_currency.modify("disbursement_currency.visible = 1")
		else
			dw_disb_currency.modify("disbursement_currency.visible = 0")
		end if
		
		
		IF dw_disb_payments.RowCount() > 0 THEN
			
			if dw_disb_payments_list.getselectedrow(0) > 0 then	
	
				if IsNull(dw_disb_payments.GetItemDateTime(dw_disb_payments.GetRow(), "disb_payments_payment_print_date")) then
					cb_payment_delete.Enabled = true
				end if
				
				cb_payment_print.enabled = true
			end if				
			
			dw_disb_currency.modify("payment_currency.visible = 1")			
		ELSE
			dw_disb_currency.modify("payment_currency.visible = 0")
		END IF		
		
	end if
end if

end subroutine

event open;call super::open;n_dw_style_service lnv_style
n_service_manager  lnv_servicemgr

dw_disb_proc_list.SetTransObject(SQLCA)

dw_disb_agents_list.SetTransObject(SQLCA)
dw_disb_agents_list.ShareData(dw_disb_dates)

dw_disb_currency.SetTransObject(SQLCA)

dw_disb_payments.SetTransObject(SQLCA)
dw_disb_payments.ShareData(dw_disb_payments_list)

dw_disb_expenses.SetTransObject(SQLCA)

uo_vesselselect.of_registerwindow( w_disbursements )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

uo_vesselselect.backcolor      = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

lnv_style.of_dwlistformater(dw_disb_proc_list, false)
lnv_style.of_dwlistformater(dw_disb_payments_list, false)

IF (uo_global.ib_rowsindicator) then
	dw_disb_proc_list.SetRowFocusIndicator(FocusRect!)
end if



end event

on w_disbursements.create
int iCurrent
call super::create
this.dw_disb_proc_list=create dw_disb_proc_list
this.dw_disb_agents_list=create dw_disb_agents_list
this.cb_agents_new=create cb_agents_new
this.cb_agents_delete=create cb_agents_delete
this.cb_currency_cancel=create cb_currency_cancel
this.dw_disb_currency=create dw_disb_currency
this.cb_payment_new=create cb_payment_new
this.cb_payment_delete=create cb_payment_delete
this.cb_payment_update=create cb_payment_update
this.dw_disb_payments_list=create dw_disb_payments_list
this.cb_payment_cancel=create cb_payment_cancel
this.dw_disb_expenses=create dw_disb_expenses
this.dw_disb_dates=create dw_disb_dates
this.cb_expense_new=create cb_expense_new
this.cb_expense_delete=create cb_expense_delete
this.cb_print_port_expenses=create cb_print_port_expenses
this.cb_print_disb_account=create cb_print_disb_account
this.cb_currency_update=create cb_currency_update
this.cb_payment_print=create cb_payment_print
this.cb_settle_agent=create cb_settle_agent
this.cb_print_agent_balance=create cb_print_agent_balance
this.cb_settle_disb=create cb_settle_disb
this.dw_disb_payments=create dw_disb_payments
this.st_1=create st_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_disb_proc_list
this.Control[iCurrent+2]=this.dw_disb_agents_list
this.Control[iCurrent+3]=this.cb_agents_new
this.Control[iCurrent+4]=this.cb_agents_delete
this.Control[iCurrent+5]=this.cb_currency_cancel
this.Control[iCurrent+6]=this.dw_disb_currency
this.Control[iCurrent+7]=this.cb_payment_new
this.Control[iCurrent+8]=this.cb_payment_delete
this.Control[iCurrent+9]=this.cb_payment_update
this.Control[iCurrent+10]=this.dw_disb_payments_list
this.Control[iCurrent+11]=this.cb_payment_cancel
this.Control[iCurrent+12]=this.dw_disb_expenses
this.Control[iCurrent+13]=this.dw_disb_dates
this.Control[iCurrent+14]=this.cb_expense_new
this.Control[iCurrent+15]=this.cb_expense_delete
this.Control[iCurrent+16]=this.cb_print_port_expenses
this.Control[iCurrent+17]=this.cb_print_disb_account
this.Control[iCurrent+18]=this.cb_currency_update
this.Control[iCurrent+19]=this.cb_payment_print
this.Control[iCurrent+20]=this.cb_settle_agent
this.Control[iCurrent+21]=this.cb_print_agent_balance
this.Control[iCurrent+22]=this.cb_settle_disb
this.Control[iCurrent+23]=this.dw_disb_payments
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_2
this.Control[iCurrent+27]=this.gb_3
end on

on w_disbursements.destroy
call super::destroy
destroy(this.dw_disb_proc_list)
destroy(this.dw_disb_agents_list)
destroy(this.cb_agents_new)
destroy(this.cb_agents_delete)
destroy(this.cb_currency_cancel)
destroy(this.dw_disb_currency)
destroy(this.cb_payment_new)
destroy(this.cb_payment_delete)
destroy(this.cb_payment_update)
destroy(this.dw_disb_payments_list)
destroy(this.cb_payment_cancel)
destroy(this.dw_disb_expenses)
destroy(this.dw_disb_dates)
destroy(this.cb_expense_new)
destroy(this.cb_expense_delete)
destroy(this.cb_print_port_expenses)
destroy(this.cb_print_disb_account)
destroy(this.cb_currency_update)
destroy(this.cb_payment_print)
destroy(this.cb_settle_agent)
destroy(this.cb_print_agent_balance)
destroy(this.cb_settle_disb)
destroy(this.dw_disb_payments)
destroy(this.st_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_disb_proc_list, "proceed_vessel_nr", "proceed_voyage_nr", True)
end event

event ue_retrieve;call super::ue_retrieve;dw_disb_proc_list.Retrieve(ii_vessel_nr)

ib_retrieve_detail = false

dw_disb_proc_list.ScrollToRow(dw_disb_proc_list.RowCount())

dw_disb_agents_list.Reset()
dw_disb_currency.Reset()
dw_disb_payments.Reset()
dw_disb_expenses.Reset()

dw_disb_proc_list.selectrow(0, false)

cb_agents_new.enabled = false

ib_retrieve_detail = false

end event

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve" )
end event

event key;call super::key;string ls_classname
GraphicObject lgo_foucs

if key = keyenter! then
	
	lgo_foucs    = getfocus()
	ls_classname = lgo_foucs.classname()

	if ls_classname = "dw_vessel" then
		ib_ignoredefaultbutton = true
		send(handle(lgo_foucs), 256, 9, 0)
	end if
end if


end event

event closequery;call super::closequery;boolean lb_modified

dw_disb_currency.accepttext()
dw_disb_payments.accepttext()

lb_modified = (dw_disb_currency.modifiedcount() + dw_disb_payments.modifiedcount()) > 0

if lb_modified then
	
	if messagebox("Updates pending", "Data modified but not saved.~nWould you like to update changes?", Question!, yesno!) = 1 then
		if dw_disb_currency.modifiedcount() > 0 then
			cb_currency_update.triggerevent("clicked")
		end if
		
		if dw_disb_payments.modifiedcount() > 0 then
			if cb_payment_update.event clicked() = c#return.failure then
				return 1
			end if
		end if
	end if
end if
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_disbursements
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_disbursements
event ue_char pbm_char
integer x = 23
integer taborder = 10
long backcolor = 22628899
end type

type dw_disb_proc_list from u_datagrid within w_disbursements
integer x = 37
integer y = 256
integer width = 1202
integer height = 2192
integer taborder = 20
string dataobject = "dw_disb_proc_list"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;ib_retrieve_detail = true

if row > 0 and row = this.getrow() then
	this.event rowfocuschanged(row)
end if


end event

event rowfocuschanged;call super::rowfocuschanged;int li_counter = 0

IF currentrow < 1 or not ib_retrieve_detail then return

this.SelectRow(0, FALSE)
this.SelectRow(currentrow, TRUE)

istr_disb.vessel_nr = ii_vessel_nr
istr_disb.voyage_nr = this.GetItemString (currentrow, "proceed_voyage_nr" )
istr_disb.port_code = this.GetItemString (currentrow, "proceed_port_code" )
istr_disb.pcn       = this.GetItemNumber (currentrow, "proceed_pcn" )

dw_disb_agents_list.Reset()
dw_disb_currency.Reset()
dw_disb_payments.Reset()
dw_disb_expenses.Reset()

dw_disb_agents_list.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn)

cb_agents_new.default = TRUE

wf_set_buttons("default")
end event

type dw_disb_agents_list from uo_datawindow within w_disbursements
integer x = 1289
integer y = 304
integer width = 603
integer height = 508
integer taborder = 40
string dataobject = "dw_disb_agents_list"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;IF IsNull(row) THEN row = this.GetRow()  /* Global Agent Import Enhancement */

IF row < 1 THEN Return

this.SelectRow(0,FALSE)
this.SelectRow(row,TRUE)
this.SetRow(row)

dw_disb_dates.ScrolltoRow(row)

agent_action(row)

wf_set_buttons("default")

cb_expense_new.default = TRUE

end event

event doubleclicked;call super::doubleclicked;if row < 1 then return
OpenWithParm(w_agent_disbursement, dw_disb_agents_list.getitemnumber(dw_disb_agents_list.getselectedrow( 0),"disbursements_agent_nr"),w_tramos_main)
end event

type cb_agents_new from commandbutton within w_disbursements
integer x = 1285
integer y = 828
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
boolean enabled = false
string text = "&New"
end type

event clicked;int    li_agent_nr,li_proceed_cancel
long   ll_dw_disb_proc_list_row, ll_dw_disb_agents_list_rowcount, ll_row
string ls_agent_nr

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

li_proceed_cancel = dw_disb_proc_list.GetItemNumber(dw_disb_proc_list.GetRow(),"proceed_cancel")
IF li_proceed_cancel = 1 THEN
	MessageBox("Restriction","You can not choose a new agent on a proceed that has been cancelled.")
	Return
END IF


ls_agent_nr = f_select_from_list("dw_active_agent_list",1,"Short Name",2,"Full Name",3,"New Agent for Disbursement",false)

IF IsNull(ls_agent_nr) or ls_agent_nr = "" THEN Return

li_agent_nr = integer(ls_agent_nr)

// Inserted by FR
f_check_agent(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, li_agent_nr)

ll_dw_disb_proc_list_row =  dw_disb_proc_list.GetRow()

dw_disb_agents_list.InsertRow(0)

ll_dw_disb_agents_list_rowcount = dw_disb_agents_list.RowCount()

dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_vessel_nr", istr_disb.vessel_nr)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_voyage_nr", istr_disb.voyage_nr)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_port_code", istr_disb.port_code)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_pcn", istr_disb.pcn)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_agent_nr", li_agent_nr)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_payment_currency", "USD")
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_ctm_currency", "USD")
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_disbursement_currency", "USD")
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_payment_ex_rate",0)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_voyage_ex_rate",0)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_ctm_ex_rate",0)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_input_ex_rate",100)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_disb_ex_rate",100)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_ex_ex_rate", 0)
dw_disb_agents_list.SetItem(ll_dw_disb_agents_list_rowcount, "disbursements_disb_in_balance", 0)

IF dw_disb_agents_list.Update() = 1 THEN
	Commit;
ELSE
	Rollback;
	dw_disb_agents_list.deleterow(ll_dw_disb_agents_list_rowcount)
	return
END IF

dw_disb_currency.Reset()
dw_disb_payments.Reset()
dw_disb_expenses.Reset()
dw_disb_agents_list.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn)

ll_row = dw_disb_agents_list.RowCount()
ll_row = dw_disb_agents_list.Find("disbursements_agent_nr = " + String(li_agent_nr)  , 1 , ll_row)

dw_disb_agents_list.SelectRow(0, FALSE)
dw_disb_agents_list.SelectRow(ll_row, TRUE)
dw_disb_agents_list.SetRow(ll_row)
dw_disb_agents_list.ScrollToRow(ll_row)

agent_action(ll_row)

dw_disb_currency.post setfocus()

wf_set_buttons("editagent")

cb_currency_update.default = TRUE

end event

type cb_agents_delete from commandbutton within w_disbursements
integer x = 1979
integer y = 828
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
string text = "&Delete"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

IF NOT IsNull(istr_disb.settled_date) THEN
	Messagebox("Delete Message","You cannot delete this Agent Disbursement, as it is Finished")
	Return
END IF

IF (dw_disb_payments.RowCount() > 0)  THEN
	MessageBox("Delete Message","You cannot delete this Agent because there are Payments.")
	Return
END IF

IF (dw_disb_expenses.RowCount() > 0) THEN
	MessageBox("Delete Message","You cannot delete this Agent because there are Expenses.")
	Return
END IF

If MessageBox("Delete Message","You are about to DELETE an Agent.~r~n~r~nAre you sure?",Question!,YesNo!,2) = 2 THEN Return

IF dw_disb_agents_list.DeleteRow(0) = 1 THEN
	IF dw_disb_agents_list.Update() = 1 THEN
		
		Commit;
		
		wf_set_buttons("default")
		
		cb_agents_new.default = true
		
		dw_disb_currency.Reset()
	ELSE
		Rollback;
	END IF
ELSE
	MessageBox("Delete Message","DELETE did not perform!")
END IF
end event

type cb_currency_cancel from commandbutton within w_disbursements
integer x = 2327
integer y = 828
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
string text = "&Cancel"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

dw_disb_currency.ReselectRow(dw_disb_currency.GetRow())

wf_set_buttons("default")

cb_agents_new.default = true

if istr_disb.pcn < 1 then
	dw_disb_dates.Enabled = TRUE
end if
end event

type dw_disb_currency from uo_datawindow within w_disbursements
integer x = 2021
integer y = 380
integer width = 1006
integer height = 432
integer taborder = 60
string dataobject = "dw_disb_currency"
boolean border = false
end type

event itemchanged;call super::itemchanged;decimal{6} lf_payment_ex_rate, lf_new_ex_ex_rate, lf_disb_ex_rate 

dw_disb_currency.AcceptText()

lf_payment_ex_rate = dw_disb_currency.GetItemNumber(dw_disb_currency.GetRow(),"payment_ex_rate")
lf_disb_ex_rate    = dw_disb_currency.GetItemNumber(dw_disb_currency.GetRow(),"disb_ex_rate")

IF (lf_payment_ex_rate <> 0) AND (lf_disb_ex_rate <> 0) THEN
	lf_new_ex_ex_rate = (lf_payment_ex_rate / lf_disb_ex_rate) * 100
	dw_disb_currency.SetItem(dw_disb_currency.GetRow(),"ex_ex_rate",lf_new_ex_ex_rate)
END IF



end event

event editchanged;call super::editchanged;string ls_col_name

ls_col_name = string(dwo.name)

if row > 0 and dec(data) <> this.getitemnumber(row, ls_col_name) and not cb_currency_update.enabled then
	
	dw_disb_payments_list.SelectRow(0, FALSE)
	dw_disb_expenses.SelectRow(0, FALSE)
	
	wf_set_buttons("editagent")
	
	this.setfocus()
	
	cb_currency_update.default = TRUE
end if
end event

type cb_payment_new from commandbutton within w_disbursements
integer x = 1285
integer y = 2228
integer width = 343
integer height = 100
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "N&ew"
end type

event clicked;string     ls_currency_code
decimal{2} ld_payment_rate
DateTime   ldt_null_dt
long       ll_row

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

IF dw_disb_agents_list.GetSelectedRow(0) < 1 THEN
	MessageBox("Missing selection","Please select an agent first.")
	Return
END IF

IF NOT IsNull(istr_disb.settled_date) THEN
	
	IF Messagebox("Notice","This Disbursement is Finished, are you sure you wish to create a new payment?",Question!,YesNo!,2) = 2 THEN
		Return
	ELSE
		
		SetNull(ldt_null_dt)
		
		dw_disb_dates.SetItem(dw_disb_dates.GetRow(),"disbursements_disb_finish_dt",ldt_null_dt)
		
		SetNull(istr_disb.settled_date)
		
		IF dw_disb_dates.Update() = 1 THEN
			Commit;
			dw_disb_payments.Enabled = TRUE
			cb_settle_agent.Enabled  = TRUE
		ELSE
			Rollback;
			MessageBox("Error","Update of print date failed!!")
			Return
		END IF
	END IF
END IF

//No use for this error(if no rows in dw_disb_payments), so it is set out of function. Leith 14/5-97

IF dw_disb_payments.RowCount() < 1 THEN
	
	ls_currency_code = f_select_from_list("dw_currency_list",1,"Code",3,"Description",1,"Select Payment Currency",false)
	
	IF IsNull(ls_currency_code) or ls_currency_code = "" THEN Return
	
	dw_disb_currency.SetItem(dw_disb_currency.GetRow(),"payment_currency",ls_currency_code)
	
	IF dw_disb_currency.Update() = 1 THEN
		Commit;
		dw_disb_currency.modify("payment_currency.visible=1")
	ELSE
		Rollback;
		Return
	END IF
END IF

dw_disb_payments_list.SelectRow(0, FALSE)

ll_row = dw_disb_payments.InsertRow(0)

dw_disb_payments_list.scrolltorow(ll_row)

/* This code is added so that it is possible to select payment type 
	"Suez Pre-funding Inchcape" if agent = UKINCHCAPE = agent # 1266 */
if dw_disb_agents_list.getItemNumber(dw_disb_agents_list.getRow(), "disbursements_agent_nr") <> 1266 then
	dw_disb_payments.ClearValues("disb_payments_payment_type")
	dw_disb_payments.SetValue("disb_payments_payment_type", 1, "Pre-funding~t1")
	dw_disb_payments.SetValue("disb_payments_payment_type", 2, "Working Capital~t2")
	dw_disb_payments.SetValue("disb_payments_payment_type", 3, "Disbursements~t3")
end if

dw_disb_payments.SetItem(dw_disb_payments.RowCount(),"payment_date",RelativeDate ( Today(), 1 ))
dw_disb_payments.ScrollToRow(dw_disb_payments.RowCount())
dw_disb_payments.SetFocus()
dw_disb_payments.SetColumn("payment_amount")

wf_set_buttons("newpayment")

dw_disb_expenses.SelectRow(0, FALSE)

cb_payment_update.default = true

dw_disb_payments.SetFocus()
dw_disb_payments.SetColumn(2)
end event

type cb_payment_delete from commandbutton within w_disbursements
integer x = 1979
integer y = 2228
integer width = 343
integer height = 100
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Delete"
end type

event clicked;long ll_dw_disb_payments_list_row_nr

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

IF NOT IsNull(istr_disb.settled_date) THEN
	Messagebox("Error","You cannot delete this Payment, as this agent is settled")
	Return
END IF

IF MessageBox("Delete","You are about to DELETE a Payment.~r~n~r~n Are you sure you want to delete this?",Question!,YesNo!,2) = 2 THEN Return

ll_dw_disb_payments_list_row_nr =  dw_disb_payments_list.GetRow()

IF  ll_dw_disb_payments_list_row_nr < 1 THEN Return

IF dw_disb_payments_list.DeleteRow( ll_dw_disb_payments_list_row_nr) = 1 THEN
	IF dw_disb_payments_list.Update() = 1 THEN
		Commit;
	ELSE
		RollBack;
	END IF
END IF

wf_set_buttons("default")

cb_payment_new.default   = TRUE

In_Balance()
end event

type cb_payment_update from commandbutton within w_disbursements
integer x = 1632
integer y = 2228
integer width = 343
integer height = 100
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Update"
end type

event clicked;date       ld_date
decimal{2} ld_payment_amount
integer    li_next_payment_counter, li_check_counter, li_getrow
long       li_row_nr
datetime   ldt_pay_date
string     ls_message, ls_columnname

dw_disb_payments.accepttext()

li_getrow = dw_disb_payments.GetRow()

if li_getrow < 1 then return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF
		
if isnull(dw_disb_payments.getitemnumber(li_getrow, "payment_amount")) then
	ls_columnname = "payment_amount"
	ls_message    = "Please enter payment amount."			
end if
		
if isnull(dw_disb_payments.getItemNumber(li_getrow, "disb_payments_payment_type")) and ls_message = "" then
	ls_columnname = "disb_payments_payment_type"
	ls_message    = "Please select payment type."					
end if

if dw_disb_payments.getItemNumber(li_getrow, "disb_payments_payment_type") = 2 and ls_message = "" then
	ls_columnname = "disb_payments_payment_type"
	ls_message    = "You are not allowed to use type 'Working Capital' any more. Please select another payment type."					
end if

if ls_message <> "" then
	messagebox("Validation Error", ls_message)
	dw_disb_payments.post setfocus()
	dw_disb_payments.post setcolumn(ls_columnname)
	return c#return.failure
end if

li_check_counter = dw_disb_payments.GetItemNumber(dw_disb_payments.GetRow(), "payment_counter")

IF IsNull(li_check_counter ) THEN
	
	li_row_nr =  dw_disb_agents_list.GetRow()
	
	SELECT max(PAYMENT_COUNTER) INTO :li_next_payment_counter
	FROM   DISB_PAYMENTS
	WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
			 PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
			 AGENT_NR = :istr_disb.agent_nr;
	
	li_row_nr =  dw_disb_payments.GetRow()
	
	IF IsNull( li_next_payment_counter) THEN 
		dw_disb_payments.SetItem(li_row_nr, "payment_counter", 1)
	ELSE
		dw_disb_payments.SetItem(li_row_nr, "payment_counter", li_next_payment_counter + 1)
	END IF
	
	dw_disb_payments.SetItem(li_row_nr, "vessel_nr", istr_disb.vessel_nr)
	dw_disb_payments.SetItem(li_row_nr, "voyage_nr", istr_disb.voyage_nr)
	dw_disb_payments.SetItem(li_row_nr, "port_code", istr_disb.port_code )
	dw_disb_payments.SetItem(li_row_nr, "pcn", istr_disb.pcn )
	dw_disb_payments.SetItem(li_row_nr, "agent_nr", istr_disb.agent_nr )
END IF	

IF dw_disb_payments.Update() = 1 THEN
	
	commit;
	
	dw_disb_payments.SetValue("disb_payments_payment_type", 4, "Suez Pre-funding Inchcape~t4")
	
	li_row_nr         = dw_disb_payments.getrow()
	ld_payment_amount = dw_disb_payments.getitemdecimal(li_row_nr, "payment_amount")
	
	if ld_payment_amount = 0 then
		/*set printed date=now*/
		
		ld_date = today()
		dw_disb_payments.Setitem(li_row_nr, "disb_payments_payment_print_date", ld_date)
		
		dw_disb_payments.Update()
		
		commit;
	end if
	
	/* if Suez Pre-funding Inchcape */
	if dw_disb_payments.getItemNumber(dw_disb_payments.GetRow(), "disb_payments_payment_type")= 4 then
		
		ldt_pay_date = dw_disb_payments.getitemdatetime(li_row_nr,"payment_date")
		
		if of_create_expense99( ldt_pay_date, ld_payment_amount) = -1 then
			MessageBox("Create Error", "Create of expense equal to pre-funding failed")
		end if
		
		dw_disb_expenses.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)
	end if
	
	if ld_payment_amount <> 0 then		
		dw_disb_payments.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)
		dw_disb_payments_list.SetRow(dw_disb_payments_list.RowCount())
		dw_disb_payments_list.SelectRow(dw_disb_payments_list.GetRow(), TRUE)
		dw_disb_payments_list.scrolltorow(dw_disb_payments_list.GetRow())
		dw_disb_payments.SetRow(dw_disb_payments.RowCount())
		dw_disb_payments.ScrollToRow(dw_disb_payments.RowCount())
	end if
	
	wf_set_Buttons("default")
	
	cb_payment_print.default = true

	In_Balance()
ELSE
	rollback;
END IF

wf_currency_warning()
end event

type dw_disb_payments_list from u_datagrid within w_disbursements
integer x = 1289
integer y = 1008
integer width = 1719
integer height = 964
integer taborder = 130
string dataobject = "dw_disb_payments_list"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;IF row < 1 THEN return

this.SelectRow(0, FALSE)
this.SelectRow(row, TRUE)
this.SetRow(row)

dw_disb_payments.ScrolltoRow(row)

istr_disb.payment_counter = dw_disb_payments.GetItemNumber(dw_disb_payments.GetRow(), "payment_counter")

dw_disb_expenses.SelectRow(0, false)

wf_set_buttons("default")

cb_payment_print.default = true
end event

type cb_payment_cancel from commandbutton within w_disbursements
integer x = 2327
integer y = 2228
integer width = 343
integer height = 100
integer taborder = 180
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "C&ancel"
end type

event clicked;long li_row_nr

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

li_row_nr =  dw_disb_agents_list.GetRow()

dw_disb_payments.SetValue("disb_payments_payment_type", 4, "Suez Pre-funding Inchcape~t4")
dw_disb_payments.Retrieve(istr_disb.vessel_nr,istr_disb.voyage_nr,istr_disb.port_code,istr_disb.pcn,istr_disb.agent_nr)

wf_set_Buttons("default")
	
cb_payment_new.default = TRUE

if istr_disb.pcn < 1 then
	dw_disb_dates.Enabled = TRUE
end if

In_Balance()
end event

type dw_disb_expenses from uo_datawindow within w_disbursements
integer x = 3090
integer y = 304
integer width = 1463
integer height = 2016
integer taborder = 230
string dataobject = "dw_disb_expenses"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event clicked;call super::clicked;IF row < 1 THEN return

this.SelectRow(0, FALSE)
this.SelectRow(row, TRUE)

if cb_settle_disb.enabled then
	cb_settle_disb.default = true
else
	cb_expense_new.default = true
end if

dw_disb_payments_list.SelectRow(0, FALSE)

wf_set_buttons("default")

end event

type dw_disb_dates from uo_datawindow within w_disbursements
integer x = 1902
integer y = 304
integer width = 1115
integer height = 64
integer taborder = 50
boolean enabled = false
string dataobject = "dw_disb_dates"
boolean border = false
end type

event losefocus;call super::losefocus;dw_disb_dates.AcceptText()
IF dw_disb_dates.Update() = 1 THEN
	Commit;
ELSE
	RollBack;
END IF
end event

type cb_expense_new from commandbutton within w_disbursements
integer x = 3168
integer y = 2336
integer width = 343
integer height = 100
integer taborder = 240
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Ne&w"
end type

event clicked;string   ls_currency_code
long     ll_row, ll_row_exp
Integer  li_proceed_cancel
DateTime ldt_null_dt

decimal{5} ld_disb_rate
decimal{2} ld_voyage_rate, ld_payment_rate

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation", "As an external user you do not have access to this functionality.")
	Return
END IF

li_proceed_cancel = dw_disb_proc_list.GetItemNumber(dw_disb_proc_list.GetRow(), "proceed_cancel")

IF li_proceed_cancel = 1 THEN
	MessageBox("Restriction", "You can not create a new expenset on a proceed that has been cancelled.")
	Return
END IF

IF (dw_disb_currency.RowCount() < 1)  THEN
	MessageBox("Missing selection", "Please select an agent first.")
	Return
END IF

ld_disb_rate    = dw_disb_currency.GetItemNumber(1, "disb_ex_rate")
ld_voyage_rate  = dw_disb_currency.GetItemNumber(1, "voyage_ex_rate")
ld_payment_rate = dw_disb_currency.GetItemNumber(1, "payment_ex_rate")

IF NOT IsNull(istr_disb.settled_date) THEN
	
	IF Messagebox("Notice", "This Disbursement is Finished, are you sure you wish to create new Disbursement?",Question!,YesNo!,2) = 2 THEN
		Return
	ELSE
		
		SetNull(ldt_null_dt)
		dw_disb_dates.SetItem(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt", ldt_null_dt)
		SetNull(istr_disb.settled_date)
		
		IF dw_disb_dates.Update() = 1 THEN
			Commit;
			cb_settle_agent.Enabled = TRUE
		ELSE
			Rollback;
			MessageBox("Error", "Update of print date failed!")
			Return
		END IF
	END IF
END IF

IF (ld_disb_rate = 0) OR (ld_voyage_rate = 0) OR (ld_payment_rate = 0)  THEN
	MessageBox("Notice", "All rates must be given before you can create a Port Expense.")
	Return
END IF

IF dw_disb_expenses.RowCount() < 1 THEN
	
	ls_currency_code = f_select_from_list("dw_currency_list", 1, "Code", 3, "Description", 1, "Select Expense Currency", false)
	
	IF IsNull(ls_currency_code) or ls_currency_code = "" THEN Return
	
	dw_disb_currency.SetItem(dw_disb_currency.GetRow(), "disbursement_currency", ls_currency_code)
	
	IF dw_disb_currency.Update() = 1 THEN
		Commit;
	ELSE
		Rollback;
		Return
	END IF
END IF

ll_row     = dw_disb_agents_list.GetRow()
ll_row     = dw_disb_currency.GetRow()
ll_row_exp = dw_disb_expenses.RowCount()

istr_disb.ex_ex_rate     = dw_disb_currency.GetItemNumber(ll_row, "ex_ex_rate")
istr_disb.voyage_ex_rate = dw_disb_currency.GetItemNumber(ll_row, "voyage_ex_rate")

OpenWithParm(w_disb_new_expense, istr_disb)

dw_disb_expenses.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)

ll_row = dw_disb_expenses.RowCount()

IF ll_row <> ll_row_exp THEN Open(w_updated)

IF ll_row > 0 THEN 
	cb_settle_disb.Enabled         = TRUE
	cb_print_port_expenses.Enabled = TRUE
	dw_disb_currency.modify("disbursement_currency.visible=1")
ELSE
	cb_settle_disb.Enabled = FALSE
END IF

In_Balance()
wf_currency_warning()

this.default           = false
cb_settle_disb.default = TRUE

end event

type cb_expense_delete from commandbutton within w_disbursements
integer x = 3515
integer y = 2336
integer width = 343
integer height = 100
integer taborder = 250
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "De&lete"
end type

event clicked;long    ll_row, ll_payment_id, ll_port_exp_id
Integer li_counter, li_voucher_nr, li_exp_counter
Boolean lb_settled
string  ls_message

datetime ldt_due_date, ldt_cp_date

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_disb_expenses.GetRow()

li_voucher_nr  = dw_disb_expenses.GetItemNumber(ll_row, "disb_expenses_voucher_nr")
li_exp_counter = dw_disb_expenses.GetItemNumber(ll_row, "disb_expenses_expenses_counter")
ll_port_exp_id = dw_disb_expenses.getitemnumber(ll_row, "disb_expenses_tc_port_exp_id")

if ll_port_exp_id > 0 then
	
	SELECT PAYMENT_ID INTO :ll_payment_id 
	FROM   NTC_PORT_EXP 
	WHERE  PORT_EXP_ID = :ll_port_exp_id;
	
	SELECT TC_HIRE_CP_DATE, EST_DUE_DATE INTO :ldt_cp_date, :ldt_due_date 
	FROM   NTC_TC_CONTRACT, NTC_PAYMENT
	WHERE  NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID AND 
	       PAYMENT_ID = :ll_payment_id;
	
	ls_message = "You cannot delete the selected expense, because it is included in hire statement:~n" &
	             + "C/P Date (TC Hire contract): " + string(ldt_cp_date, "dd-mm-yy") + "~n" & 
	             + "Hire statement ID: " + string(ll_payment_id) +" with due date: " + string(ldt_due_date, "dd-mm-yy") + "~n~n" &
	             + "You can create the same expense with opposite value and match it in the TC Hire contract."
	
	messagebox("Validation Error", ls_message)
	return
end if

SELECT DISB_EXPENSES.SETTLED INTO :lb_settled  
FROM   DISB_EXPENSES
WHERE  (VESSEL_NR = :istr_disb.vessel_nr) AND (VOYAGE_NR = :istr_disb.voyage_nr ) AND  
       (PORT_CODE = :istr_disb.port_code) AND (PCN = :istr_disb.pcn) AND  
       (EXPENSES_COUNTER = :li_exp_counter) AND (AGENT_NR = :istr_disb.agent_nr) ;


IF lb_settled THEN
	Messagebox("Error","You cannot delete this Expense, as this agent is settled")
	dw_disb_expenses.Retrieve(istr_disb.vessel_nr,istr_disb.voyage_nr,istr_disb.port_code,istr_disb.pcn,istr_disb.agent_nr)
	Return
END IF

IF NOT IsNull(istr_disb.settled_date) THEN
	Messagebox("Error","You cannot delete this Expense, as this agent is settled")
	Return
END IF

IF MessageBox("Delete","You are about to DELETE an Expense.~r~n~r~n Are you sure you want to delete this?",Question!,YesNo!,2) = 2 THEN Return

ll_row =  dw_disb_expenses.GetRow()

IF  ll_row < 1 THEN Return

IF dw_disb_expenses.DeleteRow( ll_row) = 1 THEN
	IF dw_disb_expenses.Update() = 1 THEN
		Commit;
	ELSE
		RollBack;
	END IF
END IF

IF dw_disb_expenses.RowCount() < 1 THEN 
	cb_expense_delete.Enabled = FALSE
	cb_settle_disb.Enabled = FALSE
END IF

cb_expense_delete.Enabled = FALSE

SELECT COUNT(*) INTO :li_counter
FROM   DISB_EXPENSES
WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn;

IF li_counter > 0 THEN
	cb_print_port_expenses.Enabled = TRUE
ELSE
	cb_print_port_expenses.Enabled = FALSE
END IF

In_Balance()

cb_expense_new.default = true
end event

type cb_print_port_expenses from commandbutton within w_disbursements
integer x = 4210
integer y = 2336
integer width = 343
integer height = 100
integer taborder = 270
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print "
end type

event clicked;IF dw_disb_expenses.RowCount() < 1 THEN
	MessageBox("Notice","There are no Disbursements!")
ELSE
	istr_disb.expense_currency = dw_disb_currency.GetItemString(1,"disbursement_currency")
	OpenWithParm(w_disb_print_port_expenses,istr_disb)
END IF
end event

type cb_print_disb_account from commandbutton within w_disbursements
integer x = 2674
integer y = 2336
integer width = 343
integer height = 100
integer taborder = 210
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Print Acco&unt"
end type

event clicked;IF (dw_disb_payments_list.RowCount() < 1) OR (dw_disb_expenses.RowCount() < 1 ) THEN 
	MessageBox("Error","There must exist both Payments and Expenses~r~nto generate a Disbursement Account")
	Return
END IF

SELECT PAYMENT_CURRENCY INTO :istr_disb.payment_currency
FROM   DISBURSEMENTS
WHERE	 VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
		 PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
		 AGENT_NR = :istr_disb.agent_nr;

SELECT DISBURSEMENT_CURRENCY INTO :istr_disb.expense_currency
FROM   DISBURSEMENTS
WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
		 PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
		 AGENT_NR = :istr_disb.agent_nr;

OpenWithParm(w_disb_print_disb_account,istr_disb)
end event

type cb_currency_update from commandbutton within w_disbursements
integer x = 1632
integer y = 828
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
boolean enabled = false
string text = "&Update"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

dw_disb_currency.acceptText()

wf_currency_warning()

IF dw_disb_currency.Update () = 1 THEN
	
	commit;

	if istr_disb.pcn < 1 then
		dw_disb_dates.Enabled = TRUE
	end if
	
	wf_set_buttons("default")
	
	dw_disb_expenses.Retrieve(istr_disb.vessel_nr,istr_disb.voyage_nr,istr_disb.port_code,istr_disb.pcn,istr_disb.agent_nr)
	
	cb_expense_new.default = TRUE
ELSE
	Rollback;
END IF


end event

type cb_payment_print from commandbutton within w_disbursements
integer x = 2674
integer y = 2228
integer width = 343
integer height = 100
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Settle"
end type

event clicked;integer  li_pay_type, li_trans_ok
long     ll_ret_code
datetime ldt_print_date
u_agent  lnv_agent

n_auto_finish_disbursement lnv_auto_finish


if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation", "As an external user you do not have access to this functionality.")
	Return
END IF

if wf_currency_warning() = -1 then return

/* Check if agent is blocked by AX */
lnv_agent = create u_agent
lnv_agent.of_getagent( istr_disb.agent_nr )

if lnv_agent.of_blocked( ) then
	MessageBox("Error", "Agent is Blocked by AX and cannot be settled",StopSign!)
	destroy lnv_agent
	return
end if

destroy lnv_agent

ldt_print_date = dw_disb_payments.GetItemDateTime(dw_disb_payments.GetRow(), "disb_payments_payment_print_date")

IF NOT IsNull(ldt_print_date) &
		AND ( dw_disb_payments.GetItemNumber(dw_disb_payments.GetRow(), "disb_payments_payment_in_log") = 0 & 
		OR IsNull(dw_disb_payments.GetItemNumber(dw_disb_payments.GetRow(), "disb_payments_payment_in_log")) )THEN
	
	IF MessageBox("Notice", "This Payment was printed on paper the "+string(ldt_print_date,"dd-mmm-yyyy")+".~r~nDo you really want to make CMS transaction ?",Question!,YesNo!) = 2 THEN 
		Return
	END IF
	
ELSEIF dw_disb_payments.GetItemNumber(dw_disb_payments.GetRow(), "disb_payments_payment_in_log") = 1 THEN
	MessageBox("Message", "You cannot print/transfer to CMS, because payment transaction has " &
					+ "already been transferred.")
	Return
END IF

IF NOT IsNull(istr_disb.settled_date) THEN
	Messagebox("Error", "You cannot Print Payment as this agent is settled")
	dw_disb_agents_list.SetFocus()
	Return
END IF

IF NOT IsNull(ldt_print_date) THEN
	IF MessageBox("Notice","This Payment was printed on the "+string(ldt_print_date,"dd-mmm-yyyy")+".~r~nDo you really want to print again?",Question!,YesNo!) = 2 THEN 
		Return
	END IF
END IF

istr_disb.payment_counter = dw_disb_payments.GetItemNumber(dw_disb_payments.GetRow(), "payment_counter")
istr_disb.pay_date        = dw_disb_payments.GetItemDateTime(dw_disb_payments.GetRow(), "payment_date")
istr_disb.descr           = dw_disb_payments.GetItemString(dw_disb_payments.GetRow(), "payment_desc")
istr_disb.amount          = dw_disb_payments.GetItemDecimal(dw_disb_payments.GetRow(), "payment_amount")
istr_disb.port_arr_date   = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_arr_dt")

if Messagebox("Settle account", "Are you sure you want to settle payment~n~nDescription: " + istr_disb.descr + "~nAmount: " & 
+ string(istr_disb.amount, "#,###.00"), Exclamation!, OKCancel!) = 2 then return

dw_disb_payments.SetItem(dw_disb_payments.GetRow(), "disb_payments_payment_print_date",Today())
dw_disb_payments.SetItem(dw_disb_payments.GetRow(), "disb_payments_payment_in_log",1)

IF dw_disb_payments.Update() = 1 THEN
	
	Commit;
	
	lnv_auto_finish = create n_auto_finish_disbursement
	
	ll_ret_code = lnv_auto_finish.of_finishDisbursement(istr_disb.vessel_nr, &
														istr_disb.voyage_nr, &
														istr_disb.port_code, &
														istr_disb.pcn, &
														istr_disb.agent_nr)
	destroy lnv_auto_finish
	
	if ll_ret_code = 1 then
		
		dw_disb_agents_list.retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code,istr_disb.pcn)
		
		ll_ret_code = dw_disb_agents_list.find("disbursements_agent_nr = " + string(istr_disb.agent_nr), 1, 99999) 
		
		if ll_ret_code > 0 then
			dw_disb_agents_list.event clicked(0, 0, ll_ret_code, dw_disb_agents_list.object)
		end if		
	end if
	
	cb_payment_delete.enabled = FALSE
	
ELSE
	RollBack;
	MessageBox("Error", "Date of when this payment was generated has not been set!!!")
END IF

end event

type cb_settle_agent from commandbutton within w_disbursements
integer x = 2674
integer y = 828
integer width = 343
integer height = 100
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Finish"
end type

event clicked;long    ll_unsettled_disbursements, ll_ret_code, ll_unprinted_payments, ll_apm_acc_nr
int     li_ret_code, li_rows, li_global, li_rc
string  ls_currency_code
Boolean lb_global
decimal {2} ld_payment_sum, ld_disbursement_sum

n_auto_finish_disbursement lnv_auto_finish

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation", "As an external user you do not have access to this functionality.")
	Return
END IF

// Make sure agent is not already settled 
IF NOT IsNull(istr_disb.settled_date) THEN
	Messagebox("Notice", "You cannot Finish Disbursement as the Disbursement is already finished")
	dw_disb_agents_list.SetFocus()
	Return
END IF

// Make sure port dates are set NOT null 
IF IsNull(dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_dept_dt")) OR IsNull(dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(),"disbursements_disb_arr_dt")) THEN
	MessageBox("Notice", "You can only Finish Disbursement if Port dates are set!")
	Return
END IF

// Make sure all disbursements are settled 
SELECT COUNT(*) INTO : ll_unsettled_disbursements
FROM   DISB_EXPENSES
WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
       AGENT_NR = :istr_disb.agent_nr AND SETTLED = 0;

IF  ll_unsettled_disbursements > 0 THEN
	MessageBox("Error", "You cannot finish this Disbursement as there are~r~noutstanding Disbursements to be settled.~r~n~r~nSettle disbursements first!")
	Return
END IF

// Make sure all payments are printed
SELECT COUNT(*) INTO : ll_unprinted_payments
FROM   DISB_PAYMENTS
WHERE  VESSEL_NR = :istr_disb.vessel_nr AND VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND PCN = :istr_disb.pcn AND
       AGENT_NR = :istr_disb.agent_nr AND PAYMENT_PRINT_DATE is NULL;

IF  ll_unprinted_payments > 0 THEN
	MessageBox("Notice","You cannot Finish this Disbursement as there are~r~nUnsettled Payments.~r~n~r~nSettle Payments before finish!")
	Return
END IF

// Set Payment and disbursement totals 
IF dw_disb_payments_list.RowCount() < 1 THEN
	
	ld_payment_sum = 0
	
	/* Set payment Currency */
	IF dw_disb_payments.RowCount() < 1 THEN
		
		ls_currency_code = f_select_from_list("dw_currency_list", 1, "Code", 3, "Description", 1, "Select Payment Currency", false)
		
		IF IsNull(ls_currency_code) or ls_currency_code = "" THEN Return
		
		dw_disb_currency.SetItem(dw_disb_currency.GetRow(), "payment_currency", ls_currency_code)
		
		IF dw_disb_currency.Update() = 1 THEN
			Commit;
			dw_disb_currency.modify("payment_currency.visible = 1")
		ELSE
			Rollback;
			Return
		END IF
	END IF
ELSE
	ld_payment_sum = dw_disb_payments_list.GetItemNumber(1, "payment_sum")
END IF

IF dw_disb_expenses.RowCount() < 1 THEN
	ld_disbursement_sum = 0
ELSE
	ld_disbursement_sum = dw_disb_expenses.GetItemNumber(1, "disbursement_sum")
END IF

SELECT IMPORT_FILE INTO :li_global
FROM   AGENTS
WHERE  AGENT_NR = :istr_disb.agent_nr ;

IF SQLCA.SQLCode = 0 THEN
	IF li_global = 1 THEN lb_global = TRUE
END IF

/* Test if payments are larger than disbursements, and give a warning 
	If this agent is a global agent then it is ok */

IF lb_global THEN
 // ok to finish disbursement
ELSE
	IF ld_payment_sum > ld_disbursement_sum THEN
		IF MessageBox("Notice", "Please be aware of that the balance is in your favour. ~r~n~r~nFinish Disbursement now?", Question!, YesNo!, 2) = 1 THEN
			
			dw_disb_dates.SetItem(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt", Now())
			
			IF dw_disb_dates.Update() = 1 THEN
				Commit;
			ELSE
				RollBack;
				MessageBox("Error", "Update of finish date failed!")	
			END IF
		ELSE
			Return
		END IF
	END IF
END IF

/*Test if this agent is a global agent. In this case it is allowed to finish disbursement
  although expenses > payments, because there will not be any payments in TRAMOS*/

IF lb_global THEN
	IF MessageBox("Agent Settle","This is a global Agent. ~r~n~r~nFinish Disbursement now?", Question!, YesNo!) = 1 THEN

	   /* New implementation of finish voyage fro global agents */ 
		
		lnv_auto_finish = create n_auto_finish_disbursement
		
		li_rc = lnv_auto_finish.of_finishDisbursement(istr_disb.vessel_nr, &
															istr_disb.voyage_nr, &
															istr_disb.port_code, &
															istr_disb.pcn, &
															istr_disb.agent_nr)
		destroy lnv_auto_finish
		
		if li_rc = 1 then
			
			dw_disb_agents_list.retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn)
			li_rc = dw_disb_agents_list.find("disbursements_agent_nr = " + string(istr_disb.agent_nr), 1, 99999) 
			
			if li_rc > 0 then
				dw_disb_agents_list.event clicked(0, 0, li_rc, dw_disb_agents_list.object)
			end if
		end if
		
		Return		
	ELSE
		Return
	END IF
END IF

/* Test if payments are equal to disbursements 
   if they are, then set settled date if settling OK  */

IF ld_payment_sum = ld_disbursement_sum THEN
	
	IF MessageBox("Agent Settle", "Agent payments and disbursements are equal. ~r~n~r~nFinish Disbursement now?",Question!,YesNo!) = 1 THEN
		
		dw_disb_dates.SetItem(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt", Now())
		
		istr_disb.settled_date = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt")
		
		IF dw_disb_dates.Update() = 1 THEN
			Commit;
			In_Balance()
		ELSE
			RollBack;
			MessageBox("Error","Update of finish date failed!!")	
		END IF
		
		dw_disb_payments.Enabled = FALSE
		dw_disb_currency.Enabled = FALSE
		Return		
	ELSE
		Return
	END IF
END IF


/* Test if disbursements are greater than payments     
   If they are, ask if the system should generate the    
   last payment and then set settled date if settling OK */

IF ld_payment_sum < ld_disbursement_sum THEN
	
	CHOOSE CASE MessageBox("Notice", "Disbursements are greater than payments.~r~n~r~nShould the system generate the last payment for you?",Question!,YesNoCancel!)
		CASE 1
			istr_disb.last_payment = ld_disbursement_sum - ld_payment_sum
			
			SELECT AGENTS.NOM_ACC_NR INTO :ll_apm_acc_nr  
			FROM   AGENTS  
			WHERE  AGENTS.AGENT_NR = :istr_disb.agent_nr ;
			
			If ll_apm_acc_nr >= gl_batch  then
				istr_disb.is_batch = false
			else 
				istr_disb.is_batch = true
			end if
			
			OpenWithParm(w_disb_last_payment, istr_disb)	
			
			li_ret_code = Message.DoubleParm
			
			IF li_ret_code = 1 THEN
				dw_disb_payments.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)
				
				li_rows = dw_disb_payments.RowCount()
				istr_disb.payment_counter = dw_disb_payments.GetItemNumber(li_rows, "payment_counter")
				
				If ll_apm_acc_nr >=gl_batch  then
					istr_disb.payment_counter = dw_disb_payments.GetItemNumber(li_rows, "payment_counter")
					istr_disb.pay_date        = dw_disb_payments.GetItemDateTime(li_rows, "payment_date")
					istr_disb.descr           = dw_disb_payments.GetItemString(li_rows, "payment_desc")
					istr_disb.amount          = dw_disb_payments.GetItemDecimal(li_rows, "payment_amount")
					istr_disb.port_arr_date   = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_arr_dt")
					
					OpenWithParm(w_disb_print_payment, istr_disb)
					
					ll_ret_code = Message.DoubleParm
				else
					ll_ret_code = 1
				end if	
				
				IF ll_ret_code = 1 THEN
					
					dw_disb_payments.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn, istr_disb.agent_nr)
					dw_disb_dates.SetItem(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt", Now())
					
					IF dw_disb_dates.Update() = 1 THEN
						Commit;
					ELSE
						RollBack;
						MessageBox("Error","Update of finish date failed!!")	
					END IF
					
					dw_disb_payments.SetItem(dw_disb_payments.RowCount(),"disb_payments_payment_print_date",Now())
					dw_disb_payments.SetItem(dw_disb_payments.GetRow(),"disb_payments_payment_in_log",1)
					
					IF dw_disb_payments.Update() = 1 THEN
						Commit;
						dw_disb_payments.Enabled = FALSE
						dw_disb_currency.Enabled = FALSE
						cb_settle_disb.Enabled   = FALSE
					ELSE
						Rollback;
						MessageBox("Error", "Update of print date failed!!")
						Return
					END IF
				ELSE
					dw_disb_payments.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn,istr_disb.agent_nr)
				END IF
			END IF
			
			In_Balance()	
			Return		
		CASE 2
			dw_disb_dates.SetItem(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt", Now())
			
			IF dw_disb_dates.Update() = 1 THEN
				Commit;
				dw_disb_payments.Enabled = FALSE
				dw_disb_currency.Enabled = FALSE
				cb_settle_disb.Enabled   = FALSE
			ELSE
				RollBack;
				MessageBox("Error","Update of finish date failed!!")	
			END IF
			In_Balance()
	END CHOOSE
	
	istr_disb.settled_date = dw_disb_dates.GetItemDateTime(dw_disb_dates.GetRow(), "disbursements_disb_finish_dt")
END IF
Return








end event

type cb_print_agent_balance from commandbutton within w_disbursements
integer x = 2327
integer y = 2336
integer width = 343
integer height = 100
integer taborder = 200
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Print &Balance"
end type

event clicked;OpenWithParm(w_disb_print_agent_balance,istr_disb)
end event

type cb_settle_disb from commandbutton within w_disbursements
integer x = 3863
integer y = 2336
integer width = 343
integer height = 100
integer taborder = 260
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Se&ttle"
end type

event clicked;int li_i, li_rowcount, li_autofinish, li_findrow
string ls_errormsg

mt_n_datastore lds_unsettle_disb
n_settle_expenses lnv_settle_exp

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation", "As an external user you do not have access to this functionality.")
	Return
END IF

lds_unsettle_disb = create mt_n_datastore

lds_unsettle_disb.dataobject = "d_sq_gr_unsettledagents"
lds_unsettle_disb.settransobject(sqlca)
lds_unsettle_disb.retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code,istr_disb.pcn, istr_disb.agent_nr)

li_rowcount = lds_unsettle_disb.rowcount()

if li_rowcount > 0 then
		
	lds_unsettle_disb.setitem(1, "selected", "Yes")
	
	lnv_settle_exp = create n_settle_expenses
	lnv_settle_exp.of_settle_expenses(lds_unsettle_disb, li_autofinish, true)
	
	li_findrow = lds_unsettle_disb.find("reason <> ''", 1, li_rowcount)
	
	if li_findrow > 0 then
		
		ls_errormsg = lds_unsettle_disb.getitemstring(li_findrow, "reason")
		
		if pos(ls_errormsg, "Update error") < 1 then
			messagebox("Notice", ls_errormsg)
		end if
	else
		
		w_disbursements.setRedraw(false)
		
		if li_autofinish = 1 then
			dw_disb_agents_list.retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn)
		
			li_findrow = dw_disb_agents_list.find("disbursements_agent_nr = "+string(istr_disb.agent_nr), 1, 99999) 
		
			if li_findrow > 0 then
					dw_disb_agents_list.event clicked(0, 0, li_findrow, dw_disb_agents_list.object)
			end if
		end if
	
		dw_disb_expenses.Retrieve(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code,istr_disb.pcn, istr_disb.agent_nr)
		
		w_disbursements.setRedraw(true)
	end if
else
	messagebox("Notice", "There are no Disbursements to be settled.")
end if

destroy lds_unsettle_disb
destroy lnv_settle_exp

this.default           = false
cb_payment_new.default = TRUE
end event

type dw_disb_payments from uo_datawindow within w_disbursements
integer x = 1285
integer y = 1984
integer width = 1737
integer height = 272
integer taborder = 140
string dataobject = "dw_disb_payments"
boolean border = false
end type

type st_1 from u_topbar_background within w_disbursements
integer height = 232
end type

type gb_1 from mt_u_groupbox within w_disbursements
integer x = 3058
integer y = 240
integer width = 1527
integer height = 2208
integer taborder = 220
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = "Expenses"
end type

type gb_2 from mt_u_groupbox within w_disbursements
integer x = 1262
integer y = 944
integer width = 1783
integer height = 1504
integer taborder = 120
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = "Payments"
end type

type gb_3 from mt_u_groupbox within w_disbursements
integer x = 1262
integer y = 240
integer width = 1783
integer height = 704
integer taborder = 30
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = "Disbursements"
end type

