$PBExportHeader$n_settle_expenses.sru
forward
global type n_settle_expenses from mt_n_nonvisualobject
end type
end forward

global type n_settle_expenses from mt_n_nonvisualobject
end type
global n_settle_expenses n_settle_expenses

type variables
n_messagebox inv_messagebox
end variables

forward prototypes
public subroutine documentation ()
public function string of_validate (integer ai_agentnr, string as_disb_currency, decimal ad_payment_exrate, decimal ad_voyage_exrate, datetime adt_settledate, datetime adt_disb_arrive, datetime adt_disb_dept)
public function integer of_get_flagposttransaction (integer ai_vesselnr)
public subroutine of_settle_expenses (mt_n_datastore ads_unsettle_disb, ref integer ai_autofinish, boolean ab_showmsg)
end prototypes

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: n_settle_expenses
   <OBJECT> Settle expenses. </OBJECT>
   <DESC>  </DESC>
   <USAGE> When settle expense, this will work.</USAGE>
   <ALSO>   </ALSO>
	<HISTORY>
		Date   		CR-Ref   		Author      Comments
		30/11/16		CR4420			XSZ004		First version.
	</HISTORY>
*********************************************************************************************************/
end subroutine

public function string of_validate (integer ai_agentnr, string as_disb_currency, decimal ad_payment_exrate, decimal ad_voyage_exrate, datetime adt_settledate, datetime adt_disb_arrive, datetime adt_disb_dept);/********************************************************************
   of_validate
   <DESC> </DESC>
   <RETURN>	
		String
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_agentnr
		as_disb_currency
		ad_payment_exrate
		ad_voyage_exrate
		adt_settledate
		adt_disb_arrive
		adt_disb_dept
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		01/12/16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

string ls_msg
int    li_blocked

ls_msg = ""

if not isnull(as_disb_currency) then
	
	if as_disb_currency = "DKK" and ad_payment_exrate <> 100 then 
		ls_msg = "Please be aware of that Currency code = 'DKK' and payment exchange rate <> 100"
	end if
	
	if (ad_payment_exrate = ad_voyage_exrate and as_disb_currency <> "USD") and ls_msg = "" then
		ls_msg = "Please be aware of that Currency code <> 'USD' and payment exchange rate = voyage exchange rate"
	end if
	
	if (ad_payment_exrate <> ad_voyage_exrate and as_disb_currency = "USD") and ls_msg = "" then
		ls_msg = "Please be aware of that Currency code = 'USD' and payment exchange rate <> voyage exchange rate"
	end if
end if

SELECT AGENT_BLOCKED INTO:li_blocked FROM AGENTS WHERE AGENT_NR = :ai_agentnr;

if li_blocked > 0 and ls_msg = "" then
	ls_msg = "Agent is Blocked by AX and cannot be settled"
end if 

if not isnull(adt_settledate) and ls_msg = "" then
	ls_msg = "You cannot Settle Disbursements, as this agent is settled"
end if

if (isnull(adt_disb_arrive) or isnull(adt_disb_dept)) and ls_msg = "" then
	ls_msg = "Both Port Arrival and Departure dates must be set before settling of disbursements can take place!"
end if

return ls_msg
end function

public function integer of_get_flagposttransaction (integer ai_vesselnr);/********************************************************************
   of_get_flagposttransaction
   <DESC> </DESC>
   <RETURN>	
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		01/12/16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_flagposttransaction, li_ret

SELECT PROFIT_C.POST_TRANSACTION 
  INTO :li_flagposttransaction
  FROM VESSELS, PROFIT_C
 WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND VESSEL_NR = :ai_vesselnr;
 

 return li_flagposttransaction

end function

public subroutine of_settle_expenses (mt_n_datastore ads_unsettle_disb, ref integer ai_autofinish, boolean ab_showmsg);/********************************************************************
   of_settle_expenses
   <DESC> </DESC>
   <RETURN>	
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_unsettle_disb
		ai_autofinish
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		01/12/16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

int      li_count, li_cnt, li_agentnr, li_flagposttransaction, li_ret, li_findrow
String   ls_disb_currency, ls_msg, ls_selected
decimal  ld_payment_exrate, ld_voyage_exrate
datetime ldt_sttledate, ldt_disb_arrive, ldt_disb_dept

u_transaction_expense      luo_tran_exp
s_transaction_input        lstr_tran_input
n_auto_finish_disbursement lnv_auto_finish

luo_tran_exp = create u_transaction_expense
lnv_auto_finish = create n_auto_finish_disbursement

li_count = ads_unsettle_disb.rowcount()

SetPointer(HourGlass!)

for li_cnt = 1 to li_count	
	
	ls_selected = ads_unsettle_disb.getitemstring(li_cnt, "selected")
	
	if ls_selected <> "Yes" then
		continue
	end if
	
	li_agentnr      = ads_unsettle_disb.getitemnumber(li_cnt, "disbursements_agent_nr")
	ldt_sttledate   = ads_unsettle_disb.getitemdatetime(li_cnt, "disb_finish_dt")
	ldt_disb_dept   = ads_unsettle_disb.getitemdatetime(li_cnt, "disb_dept_dt")
	ldt_disb_arrive = ads_unsettle_disb.getitemdatetime(li_cnt, "disb_arr_dt")
	
	ls_disb_currency  = ads_unsettle_disb.getitemstring(li_cnt, "disbursements_disbursement_currency")
	ld_payment_exrate = ads_unsettle_disb.getitemnumber(li_cnt, "disbursements_payment_ex_rate")
	ld_voyage_exrate  = ads_unsettle_disb.getitemnumber(li_cnt, "disbursements_voyage_ex_rate")

	ls_msg = of_validate(li_agentnr, ls_disb_currency, ld_payment_exrate, ld_voyage_exrate, ldt_sttledate, ldt_disb_arrive, ldt_disb_dept)
	
	if ls_msg <> "" then
		ads_unsettle_disb.setitem(li_cnt, "reason", ls_msg)
		continue
	end if
	
	lstr_tran_input.b_showmsg   = ab_showmsg
	lstr_tran_input.coda_or_cms = TRUE
	lstr_tran_input.vessel_no   = ads_unsettle_disb.GetItemNumber(li_cnt, "disbursements_vessel_nr")
	lstr_tran_input.voyage_no   = ads_unsettle_disb.GetItemString(li_cnt, "voyage_nr")
	lstr_tran_input.port        = ads_unsettle_disb.GetItemString(li_cnt, "port_code")
	lstr_tran_input.pcn         = ads_unsettle_disb.GetItemNumber(li_cnt, "pcn")
	
	lstr_tran_input.agent_no            = li_agentnr
	lstr_tran_input.disb_port_arr_date  = ldt_disb_arrive
	lstr_tran_input.disb_currency_code  = ls_disb_currency
	lstr_tran_input.disb_ex_rate_to_dkk = ads_unsettle_disb.GetItemNumber(li_cnt, "disbursements_ex_ex_rate")
	
	li_flagposttransaction = of_get_flagposttransaction(lstr_tran_input.vessel_no)
	
	if li_flagposttransaction = 1 then
		luo_tran_exp.of_reset_data()
		li_ret = luo_tran_exp.of_generate_transaction(lstr_tran_input)
	else
		UPDATE DISB_EXPENSES
			SET SETTLED = 1
		 WHERE VESSEL_NR = :lstr_tran_input.vessel_no AND  
				 VOYAGE_NR = :lstr_tran_input.voyage_no AND  
				 PORT_CODE = :lstr_tran_input.port AND  
				 PCN = :lstr_tran_input.pcn AND  
				 AGENT_NR = :lstr_tran_input.agent_no;
		
		if sqlca.sqlcode = 0 then
			li_ret = c#return.success
		else
			li_ret = c#return.failure
		end if
					 
	end if
	
	if li_ret = c#return.success then
		ai_autofinish = lnv_auto_finish.of_finishDisbursement(lstr_tran_input.vessel_no, lstr_tran_input.voyage_no, lstr_tran_input.port, &
																				lstr_tran_input.pcn, lstr_tran_input.agent_no)
		
		if ai_autofinish = c#return.success then
			li_ret = c#return.success
		else
			li_ret = c#return.failure
		end if
	end if
	
	if li_ret = c#return.success then
		commit;
		ads_unsettle_disb.deleterow(li_cnt)
		li_cnt --
		li_count --
	else
		ls_msg = "Update error, " + sqlca.sqlerrtext
		rollback;
		ads_unsettle_disb.setitem(li_cnt, "reason", ls_msg)
	end if

next

SetPointer(Arrow!)

destroy luo_tran_exp
destroy lnv_auto_finish
end subroutine

on n_settle_expenses.create
call super::create
end on

on n_settle_expenses.destroy
call super::destroy
end on

