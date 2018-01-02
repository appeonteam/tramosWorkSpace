$PBExportHeader$n_auto_finish_disbursement.sru
$PBExportComments$This object is used to set disbursement to finished when expenses are settled.
forward
global type n_auto_finish_disbursement from nonvisualobject
end type
end forward

global type n_auto_finish_disbursement from nonvisualobject
end type
global n_auto_finish_disbursement n_auto_finish_disbursement

type variables
private integer	ii_vessel_nr, ii_pcn
private string		is_voyage_nr, is_portcode
private long 		il_agent_nr
end variables

forward prototypes
private function boolean of_isglobalagent (long al_agent_nr)
private function boolean of_inbalance (long al_agent_nr)
private function boolean of_isglobalagentfinished ()
private function boolean of_isvoucherok ()
private function boolean of_isarrivaldeparturedateset (long al_agent_nr)
private function boolean of_ispaymentsettled (long al_agent_nr)
private function integer of_finishnonglobalagent ()
private function integer of_finishglobalagent ()
private function boolean of_isexpensesettled (long al_agent_nr)
public function integer of_finishdisbursement (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn, long al_agent_nr)
private function boolean of_normalexpensesettled (long al_agent_nr)
end prototypes

private function boolean of_isglobalagent (long al_agent_nr);integer	li_importfile

SELECT IMPORT_FILE
	INTO :li_importfile
	FROM AGENTS
	WHERE AGENT_NR = :al_agent_nr;
	
if li_importfile > 0 then return true

return false
end function

private function boolean of_inbalance (long al_agent_nr);/* Find out if expenses and payments are in balance */
decimal {2} 	ld_payment, ld_expense
double			ld_exrate

/* if there are more than one global agent, they can be finished without balance beeing zero */
if of_isglobalagent( al_agent_nr) then return true

SELECT DISB_EX_RATE 
	INTO :ld_exrate
	FROM DISBURSEMENTS
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND PORT_CODE = :is_portcode
	AND PCN = :ii_pcn
	AND AGENT_NR = :al_agent_nr ;

SELECT ISNULL(SUM(EXP_AMOUNT_LOCAL),0) 
	INTO :ld_expense
	FROM DISB_EXPENSES
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND PORT_CODE = :is_portcode
	AND PCN = :ii_pcn
	AND AGENT_NR = :al_agent_nr ;

/* Convert to payment currency for compare */
ld_expense = (ld_expense / ld_exrate) * 100

SELECT ISNULL(SUM(PAYMENT_AMOUNT),0) 
	INTO :ld_payment
	FROM DISB_PAYMENTS
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND PORT_CODE = :is_portcode
	AND PCN = :ii_pcn
	AND AGENT_NR = :al_agent_nr ;

IF ld_payment = ld_expense then return true

return false

end function

private function boolean of_isglobalagentfinished ();/* Find out if there is a global agent present for this port, 
	and if disbursement is finished */

integer 	li_counter

SELECT COUNT(*) 
	INTO :li_counter
	FROM DISBURSEMENTS,
		AGENTS
	WHERE DISBURSEMENTS.AGENT_NR = AGENTS.AGENT_NR
	AND DISBURSEMENTS.VESSEL_NR = :ii_vessel_nr
	AND DISBURSEMENTS.VOYAGE_NR = :is_voyage_nr
	AND DISBURSEMENTS.PORT_CODE = :is_portcode
	AND DISBURSEMENTS.PCN = :ii_pcn
	AND DISBURSEMENTS.DISB_FINISH_DT IS NOT NULL
	AND AGENTS.IMPORT_FILE = 1 ;

if li_counter > 0 then return true

return false
end function

private function boolean of_isvoucherok ();/* 	In order to get a Global Agent "auto" finished there must be at least one global agent 
	registered with expenses of voucher type > 1 (saying if only expenses of voucher type 1
	don't allow "auto" finish   */
integer	li_counter

/* 	First check current agent */
SELECT COUNT(*)
	INTO :li_counter
	FROM DISB_EXPENSES
	WHERE	VESSEL_NR = :ii_vessel_nr AND
			VOYAGE_NR = :is_voyage_nr AND
			PORT_CODE = :is_portcode AND
			PCN = :ii_pcn AND
			AGENT_NR = :il_agent_nr AND
			VOUCHER_NR > 1;

IF li_counter > 0 THEN return true

/* If not OK, check if there are other Global Agents where this rule is fulfilled */
SELECT COUNT(*)
	INTO :li_counter
	FROM DISB_EXPENSES D, AGENTS A 
	WHERE	D.AGENT_NR = A.AGENT_NR AND
			D.VESSEL_NR = :ii_vessel_nr AND
			D.VOYAGE_NR = :is_voyage_nr AND
			D.PORT_CODE = :is_portcode AND
			D.PCN = :ii_pcn AND
			A.AGENT_NR <> :il_agent_nr AND
			A.IMPORT_FILE = 1 AND
			VOUCHER_NR > 1;

IF li_counter > 0 THEN return true

return false

end function

private function boolean of_isarrivaldeparturedateset (long al_agent_nr);/* Checks if there are both arrival and departure dates for this disbursement */

datetime ldt_arrival, ldt_departure

SELECT DISB_ARR_DT, DISB_DEPT_DT
	INTO :ldt_arrival, :ldt_departure
	FROM DISBURSEMENTS
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND PORT_CODE = :is_portcode
	AND PCN = :ii_pcn
	AND AGENT_NR = :al_agent_nr ;
	
if isNull(ldt_arrival) or isNull(ldt_departure) then return false

return true
end function

private function boolean of_ispaymentsettled (long al_agent_nr);/* Checks if there all payments are settled for this disbursement/agent */

integer	li_counter

SELECT COUNT(*)
	INTO :li_counter
	FROM DISB_PAYMENTS
	WHERE	VESSEL_NR = :ii_vessel_nr AND
			VOYAGE_NR = :is_voyage_nr AND
			PORT_CODE = :is_portcode AND
			PCN = :ii_pcn AND
			AGENT_NR = :al_agent_nr AND
			PAYMENT_PRINT_DATE is NULL;

IF li_counter > 0 THEN return false

return true

end function

private function integer of_finishnonglobalagent ();datetime ldt_now

/* if no global agent finished, this agent can not be finished */
if of_isGlobalAgentFinished() = false then return 1

/* if balance <> 0 , this agent can not be finished */
if of_inBalance(il_agent_nr) = false then return 1

ldt_now = datetime(today(), now())

UPDATE DISBURSEMENTS
	SET DISB_FINISH_DT = :ldt_now
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND PORT_CODE = :is_portcode
	AND PCN = :ii_pcn
	AND AGENT_NR = :il_agent_nr ;
IF SQLCA.SQLCode <> 0 then return -1

return 1
end function

private function integer of_finishglobalagent ();long		ll_rows, ll_row, ll_NON_Global_Agent
datetime ldt_now
n_ds		lds_disbData

/* If only expenses on voucher 1, this agent can not be finished */
if of_isVoucherOK() = false then return 1

/* finish global agent */
ldt_now = datetime(today(), now())
UPDATE DISBURSEMENTS
	SET DISB_FINISH_DT = :ldt_now
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND PORT_CODE = :is_portcode
	AND PCN = :ii_pcn
	AND AGENT_NR = :il_agent_nr ;
IF SQLCA.SQLCode <> 0 then return -1

lds_disbData = create n_ds
lds_disbData.dataObject = "d_auto_finish_disbursement"
lds_disbData.setTransObject(SQLCA)
ll_rows = lds_disbData.retrieve( ii_vessel_nr, is_voyage_nr, is_portcode, ii_pcn, il_agent_nr )
for ll_row = 1 to ll_rows
	ll_NON_Global_Agent = lds_disbData.getItemNumber(ll_row, "agent_nr")
	if NOT of_isArrivalDepartureDateSet(ll_NON_Global_Agent) then continue
	if NOT of_isPaymentSettled(ll_NON_Global_Agent) then continue
	if NOT of_isExpenseSettled(ll_NON_Global_Agent) then continue
	if NOT of_inBalance(ll_NON_Global_Agent) then continue

	UPDATE DISBURSEMENTS
		SET DISB_FINISH_DT = :ldt_now
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :is_voyage_nr
		AND PORT_CODE = :is_portcode
		AND PCN = :ii_pcn
		AND AGENT_NR = :ll_NON_Global_Agent ;
	IF SQLCA.SQLCode <> 0 then 
		destroy lds_disbData
		return -1
	end if
next

destroy lds_disbData
return 1

end function

private function boolean of_isexpensesettled (long al_agent_nr);/* Checks if all expenses are settled for this disbursement/agent */

integer	li_counter

SELECT COUNT(*)
	INTO :li_counter
	FROM DISB_EXPENSES
	WHERE	VESSEL_NR = :ii_vessel_nr AND
			VOYAGE_NR = :is_voyage_nr AND
			PORT_CODE = :is_portcode AND
			PCN = :ii_pcn AND
			AGENT_NR = :al_agent_nr AND
			SETTLED = 0;

IF li_counter > 0 THEN return false

return true
end function

public function integer of_finishdisbursement (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn, long al_agent_nr);integer		li_rc

ii_vessel_nr 		= ai_vessel_nr
is_voyage_nr 	= as_voyage_nr
is_portcode 		= as_portcode
ii_pcn				= ai_pcn
il_agent_nr		= al_agent_nr

/* if dates not set then no automatic finish. This is not an error therefore return 1 */
if NOT of_isArrivalDepartureDateSet(al_agent_nr) then
	rollback;
	return 1
end if

/* if all expense not settled no automatic finish. This is not an error therefore return 1 */
if NOT of_isExpenseSettled(al_agent_nr) then
	rollback;
	return 1
end if

/* if all payments not settled no automatic finish. This is not an error therefore return 1 */
if NOT of_isPaymentSettled(al_agent_nr) then
	rollback;
	return 1
end if

/* find out if Global agent or not and go on. 
	if global agent non global agents are also finished */
if of_isGlobalAgent(al_agent_nr) then
	/* first check if any 'Normal' Port Expenses settled. If not don't settle anything
		new rule Change Request #1103. Only finish then there is a 'Normal' Port Expense 
		settled */
	if of_normalExpenseSettled(al_agent_nr) then	
		li_rc = of_finishGlobalAgent()
	else
		rollback;
		return 1
	end if
else
	li_rc = of_finishNONglobalAgent()
end if

if li_rc = 1 then 
	Commit;
else
	MessageBox("Finish Error", "Procedure to set disbursement as finished failed. (n_auto_finish_disbursement.offinishDisbursement())")
	rollback;
end if

return li_rc
end function

private function boolean of_normalexpensesettled (long al_agent_nr);/* Checks if there is a 'Normal' Expense settled 
	unlike 'T.O.' or 'Crew' Expenses */

integer	li_counter

SELECT COUNT(DISB_EXPENSES.VOUCHER_NR)
	INTO :li_counter
	FROM DISB_EXPENSES,
		VOUCHERS
	WHERE	DISB_EXPENSES.VOUCHER_NR = VOUCHERS.VOUCHER_NR
	AND DISB_EXPENSES.VESSEL_NR = :ii_vessel_nr 
	AND DISB_EXPENSES.VOYAGE_NR = :is_voyage_nr 
	AND DISB_EXPENSES.PORT_CODE = :is_portcode 
	AND DISB_EXPENSES.PCN = :ii_pcn 
	AND DISB_EXPENSES.AGENT_NR = :al_agent_nr
	AND VOUCHERS.PORT_EXPENSE = 1
	AND VOUCHERS.ACCOUNTING_EXPENSE_TYPE = 0;

/* If 'Normal' expense settled return true */
IF li_counter > 0 THEN return true

return false
end function

on n_auto_finish_disbursement.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_auto_finish_disbursement.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

