$PBExportHeader$w_disb_print_agent_balance.srw
$PBExportComments$This window lets the user view the agent balance (by 77 number) and lets the user print the balance.
forward
global type w_disb_print_agent_balance from w_print_basewindow
end type
end forward

global type w_disb_print_agent_balance from w_print_basewindow
event ue_autoclose pbm_custom74
end type
global w_disb_print_agent_balance w_disb_print_agent_balance

type variables
s_disbursement lstr_disb
end variables

on ue_autoclose;call w_print_basewindow::ue_autoclose;close(this)
end on

event open;call super::open;lstr_disb = Message.PowerObjectParm
string ls_agent_apm_account_nr
long ll_rows, ll_counter
double ld_ex_rate
decimal {2} ld_payment_in_local_curr, ld_disbursement_in_local_curr, ld_balance, ld_pete_balance = 0
datawindowchild dwc_1, dwc_2

ii_startup = 2
ib_autoclose = TRUE

SELECT NOM_ACC_NR
INTO :ls_agent_apm_account_nr
FROM AGENTS
WHERE AGENT_NR = :	lstr_disb.agent_nr;
commit;
dw_print.Retrieve(ls_agent_apm_account_nr)
commit;

IF dw_print.GetChild("rep_1",dwc_1) = -1 THEN messagebox("","dwchild_1 get failed")
IF dw_print.GetChild("rep_2",dwc_2) = -1 THEN messagebox("","dwchild_2 get failed")
ll_counter = 1
ll_rows = dwc_1.RowCount()
IF (ll_rows < 1) THEN 
	Messagebox("Notice","There are no payments for this Agent!")
	this.postevent("ue_autoclose")
	return
end if
if dwc_1.RowCount() <> dwc_2.RowCount() then
	Messagebox("Notice","This Agent has somewhere been used twice on the same port of call. " + &
				"The system has been placed in an unstable situation. Please correct the problem!")
	this.postevent("ue_autoclose")
	return
end if
setpointer(Hourglass!)
DO
	ld_ex_rate = Double( dwc_2.describe("Evaluate('"+    dwc_2.Describe("reverse_ex_rate.Expression")     +"',"+string(ll_counter)+")" )  )
	dwc_1.SetItem(ll_counter,"disbursements_disb_ex_rate",ld_ex_rate*100)
	
	ld_payment_in_local_curr = dwc_1.GetItemNumber(ll_counter,"payment_in_local_curr")
	if Isnull(ld_payment_in_local_curr) then ld_payment_in_local_curr = 0

	ld_disbursement_in_local_curr  = dwc_2.GetItemNumber(ll_counter,"disbursement_in_local_curr")
	if isnull(ld_disbursement_in_local_curr) then ld_disbursement_in_local_curr = 0
	ld_balance = round(((ld_payment_in_local_curr * ld_ex_rate) - ld_disbursement_in_local_curr ),2)
//	if isnull(ld_payment_in_local_curr) and not isnull(ld_disbursement_in_local_curr) then ld_balance = 0 - ld_disbursement_in_local_curr
	dwc_2.SetItem(ll_counter,"currency_total",ld_balance)
	ld_pete_balance = ld_pete_balance + ld_balance
	ll_counter++
LOOP UNTIL ll_counter = ll_rows  +1
dwc_2.groupcalc()
setpointer(arrow!)
end event

on w_disb_print_agent_balance.create
call w_print_basewindow::create
end on

on w_disb_print_agent_balance.destroy
call w_print_basewindow::destroy
end on

type dw_print from w_print_basewindow`dw_print within w_disb_print_agent_balance
string DataObject="dw_disb_print_agent_balance_report"
end type

