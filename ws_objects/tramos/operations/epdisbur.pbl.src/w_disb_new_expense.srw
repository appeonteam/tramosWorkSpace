$PBExportHeader$w_disb_new_expense.srw
$PBExportComments$This window lets the user enter a new expence.
forward
global type w_disb_new_expense from mt_w_response
end type
type cb_delete from mt_u_commandbutton within w_disb_new_expense
end type
type dw_new_expense from u_datagrid within w_disb_new_expense
end type
type cb_new from mt_u_commandbutton within w_disb_new_expense
end type
type cb_update from mt_u_commandbutton within w_disb_new_expense
end type
end forward

global type w_disb_new_expense from mt_w_response
integer x = 672
integer y = 264
integer width = 2880
integer height = 1480
string title = "New Expense"
long backcolor = 81324524
boolean ib_setdefaultbackgroundcolor = true
cb_delete cb_delete
dw_new_expense dw_new_expense
cb_new cb_new
cb_update cb_update
end type
global w_disb_new_expense w_disb_new_expense

type variables
s_disbursement istr_disb
u_import_expenses inv_import_expenses
end variables

forward prototypes
public function integer wf_validate ()
public subroutine documentation ()
public subroutine wf_set_port_exp_id ()
end prototypes

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>	Validate the new expense	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed         
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  When new a expense  </USAGE>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		04/09/2012	CR2857		WWG004		Add validate invoice number
		02/06/2014	CR3696		XSZ004		Not allow inputing settled invoice number.
		07/04/2015	CR3854		XSZ004		Transfer to TC-Hire when new TC expenses.
   </HISTORY>
********************************************************************/

decimal{2} ld_amount_local, ld_amount_usd, ld_input_amount 
integer    li_voucher_nr, li_exp_counter, li_return, li_exp_for_oa
datetime   ldt_exp_dt, ldt_cp_date, ldt_port_arr_dt
string     ls_disb_curr, ls_pay_curr, ls_invoice_nr, ls_error
string     ls_find, ls_reason, ls_first_reason, ls_column_name
long       ll_rowcount, ll_row, ll_find, ll_focus_row, ll_contract_id, ll_first_contract, ll_insertrow
boolean    lb_found_error

datawindow ldw_expenses

if dw_new_expense.AcceptText() <> 1 then return c#return.failure

if not isvalid(inv_import_expenses) then
	inv_import_expenses = create u_import_expenses
end if

ldw_expenses = w_disbursements.dw_disb_expenses

SELECT PAYMENT_CURRENCY
  INTO :ls_pay_curr
  FROM DISBURSEMENTS
 WHERE VESSEL_NR = :istr_disb.vessel_nr AND
       VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND
       PCN       = :istr_disb.pcn AND
       AGENT_NR  = :istr_disb.agent_nr;

SELECT DISBURSEMENT_CURRENCY
  INTO :ls_disb_curr
  FROM DISBURSEMENTS
 WHERE VESSEL_NR = :istr_disb.vessel_nr AND
       VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND
       PCN       = :istr_disb.pcn AND
       AGENT_NR  = :istr_disb.agent_nr;

SELECT max(EXPENSES_COUNTER)
  INTO :li_exp_counter
  FROM DISB_EXPENSES
 WHERE VESSEL_NR = :istr_disb.vessel_nr AND
       VOYAGE_NR = :istr_disb.voyage_nr AND
       PORT_CODE = :istr_disb.port_code AND
       PCN       =  :istr_disb.pcn AND
       AGENT_NR  = :istr_disb.agent_nr;

ll_rowcount = dw_new_expense.Rowcount()

FOR ll_row = 1 TO ll_rowcount
	
	ldt_exp_dt = dw_new_expense.GetItemDateTime(ll_row, "expenses_date")
	
	IF IsNull(ldt_exp_dt) THEN
		ls_error       = "Please enter expense date."
		ll_focus_row   = ll_row
		ls_column_name = "expenses_date"
		exit
	END IF
	
	li_voucher_nr = dw_new_expense.GetItemNumber(ll_row, "voucher_nr")
	
	IF IsNull(li_voucher_nr) or li_voucher_nr = 0 THEN
		ls_error       = "Please enter Voucher No."
		ll_focus_row   = ll_row
		ls_column_name = "voucher_nr"
		exit
	END IF

	ld_input_amount = dw_new_expense.GetItemNumber(ll_row, "input_amount")
	
	IF IsNull(ld_input_amount) THEN
		ls_error       = "Please enter Input amount."
		ll_focus_row   = ll_row
		ls_column_name = "input_amount"
		exit
	END IF

	ld_amount_local = dw_new_expense.GetItemNumber(ll_row, "exp_amount_local")
	
	IF IsNull(ld_amount_local) THEN
		ls_error       = "Please enter Local amount."
		ll_focus_row   = ll_row
		ls_column_name = "input_amount"
		exit
	END IF
	
	ls_invoice_nr = dw_new_expense.getitemstring(ll_row, "disb_invoice_nr")
	
	if trim(ls_invoice_nr) = "" or isnull(ls_invoice_nr) then
		ls_invoice_nr = ""
		ls_find       = "(isnull(disb_expenses_disb_invoice_nr) or disb_expenses_disb_invoice_nr = '')"
	else
		ls_find = "disb_expenses_disb_invoice_nr = '" + ls_invoice_nr + "'"
	end if
	
	ls_find = ls_find + " and disb_expenses_settled = 1"
	ll_find = ldw_expenses.find(ls_find, 1, ldw_expenses.rowcount())
	
	if ll_find > 0 then
		ls_error += ls_invoice_nr + "~n"
		if not lb_found_error then
			lb_found_error = true
			ll_focus_row   = ll_row
		end if
	end if
	
	if ll_row = ll_rowcount and len(ls_error) > 0 then
		ls_error       = "There is already a settled expense with invoice number(s):~n" + ls_error
		ls_column_name = "disb_invoice_nr"
	end if
	
	/* Set amount USD */
	IF  (ls_disb_curr = "USD")  THEN
		ld_amount_usd = ld_amount_local
	ELSE
		ld_amount_usd = ((ld_amount_local * istr_disb.ex_ex_rate) / istr_disb.voyage_ex_rate) 
	END IF

	dw_new_expense.SetItem(ll_row, "exp_amount_usd", ld_amount_usd)

	IF IsNull(li_exp_counter) THEN
		dw_new_expense.SetItem(ll_row, "expenses_counter", ll_row)
	ELSE
		dw_new_expense.SetItem(ll_row, "expenses_counter", li_exp_counter + ll_row)
	END IF
NEXT

if trim(ls_error) = "" then	
	
	ldt_port_arr_dt = inv_import_expenses.of_get_port_arr_date(istr_disb.vessel_nr, istr_disb.voyage_nr, istr_disb.port_code, istr_disb.pcn)
	
	for ll_row = 1 TO ll_rowcount
		
		li_voucher_nr   = dw_new_expense.getitemnumber(ll_row, "voucher_nr")
		ls_invoice_nr   = dw_new_expense.getitemstring(ll_row, "disb_invoice_nr")
		ld_amount_usd   = dw_new_expense.GetItemNumber(ll_row, "exp_amount_usd")
		ld_amount_local = dw_new_expense.GetItemNumber(ll_row, "exp_amount_local")
		ls_reason       = inv_import_expenses.of_check_tc_expenses(istr_disb.vessel_nr, istr_disb.voyage_nr, li_voucher_nr, ldt_port_arr_dt, li_exp_for_oa, ll_contract_id)
		
		if isnull(ls_invoice_nr) then ls_invoice_nr = ""		
		
		if ls_reason = "No transfer" then
			dw_new_expense.setitem(ll_row, "tc_port_exp_id", 0)
		elseif ls_reason <> "" then		
			
			if ls_first_reason = "" then
				
				ls_first_reason   = ls_reason
				ll_first_contract = ll_contract_id
				ll_focus_row      = ll_row
				ls_column_name    = "voucher_nr"
			end if

			if ls_first_reason = ls_reason then
				if ls_reason = "No TC link" then
					ls_error += "Voucher No: " + string(li_voucher_nr) + ", Amount: " + string(ld_amount_local) + ", Invoice No: " + ls_invoice_nr + "~n"
				elseif ll_first_contract = ll_contract_id then
					ls_error += "Voucher No: " + string(li_voucher_nr) + ", Amount: " + string(ld_amount_local) + ", Invoice No: " + ls_invoice_nr + "~n"
				end if
			end if
		else
			
			ls_reason = inv_import_expenses.of_insert_tc_expenses(ll_contract_id, li_exp_for_oa, ls_invoice_nr, ls_disb_curr, &
														 ld_amount_usd, ld_amount_local, istr_disb.port_code, ldt_port_arr_dt, ll_insertrow)
		   
			if ls_reason <> "" then
				if ls_first_reason = "" then
					
					ls_first_reason = ls_reason
					ll_focus_row    = ll_row
					ls_column_name  = "voucher_nr"					
					ls_error       += ls_invoice_nr + "~n"
					
				elseif ls_first_reason = ls_reason then
					
					ls_error += ls_invoice_nr + "~n"
				end if
			else
				dw_new_expense.setitem(ll_row, "row_number", ll_row)
				inv_import_expenses.ids_tc_expenses.setitem(ll_insertrow, "row_number", ll_row)
			end if
		end if
	next
	
	if len(ls_error) > 0 then
		if ls_first_reason = "No TC link" then
			
			ls_error = "You cannot create the below expense(s), because there is no TC Hire contract they could be transferred to:~n" &
			            + ls_error + "~nYou can use a different voucher number or ask Operations to create a DEL Port of Call and connect it to the relevant TC Hire contract."
		
		elseif ls_first_reason = "No New/Draft HS" then
			
			SELECT TC_HIRE_CP_DATE INTO :ldt_cp_date 
			FROM   NTC_TC_CONTRACT
			WHERE  NTC_TC_CONTRACT.CONTRACT_ID = :ll_first_contract;
			
			ls_error = "You cannot create the below expense(s), because the TC Hire contract with C/P Date " + string(ldt_cp_date, "dd-mm-yy") + " does not have any hire statement in status New or Draft:~n" & 
			            + ls_error + "~nContact Finance to unsettle a hire statement and Operations to set it to Draft."
		else
			ls_error = "The below expense(s) cannot be created because no exchange rate:~n" + ls_error
		end if
	end if
end if

if len(ls_error) > 0 then
	dw_new_expense.POST ScrollToRow(ll_focus_row)
	dw_new_expense.POST SetColumn(ls_column_name)
	dw_new_expense.POST SetFocus()
	
	messagebox("Validation Error", ls_error)
	
	li_return = c#return.failure
else
	li_return = c#return.success
end if

return  li_return
end function

public subroutine documentation ();/*******************************************************************************************************
	ObjectName: w_disb_new_expense
	<OBJECT> New expenses. </OBJECT>
	<DESC>  </DESC>
	<USAGE> When new an expense, this will work.</USAGE>
	<ALSO>   </ALSO>
 	<HISTORY>
		Date   		Ref   		Author      Comments
		15/08/12 	CR2857      WWG004      Add a validation for new a expense.
		30/05/2014	CR3696		XSZ004		Not allow inputing settled invoice number.
		07/04/2015	CR3854		XSZ004		Transfer to TC-Hire when new TC expenses.
 	</HISTORY>
*********************************************************************************************************/
end subroutine

public subroutine wf_set_port_exp_id ();/********************************************************************
   wf_set_expenses_id
   <DESC>  </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		22/05/15		CR3854		XSZ004		First Version.
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount, ll_findrow, ll_row_number, ll_port_exp_id

ll_rowcount = inv_import_expenses.ids_tc_expenses.rowcount()

if ll_rowcount > 0 then
	
	for ll_row = 1 to ll_rowcount
		
		ll_row_number = inv_import_expenses.ids_tc_expenses.getitemnumber(ll_row, "row_number")
		ll_findrow = dw_new_expense.find("row_number = " + string(ll_row_number), 1, dw_new_expense.rowcount())
		
		if ll_findrow > 0 then
			ll_port_exp_id = inv_import_expenses.ids_tc_expenses.getitemnumber(ll_row, "port_exp_id")
			dw_new_expense.setitem(ll_findrow, "tc_port_exp_id", ll_port_exp_id)
		end if
	next
end if
end subroutine

event open;call super::open;n_service_manager  lnv_servicemgr
n_dw_style_service lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_new_expense, false)

istr_disb = Message.PowerObjectParm

dw_new_expense.SetTransObject(SQLCA)

end event

on w_disb_new_expense.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.dw_new_expense=create dw_new_expense
this.cb_new=create cb_new
this.cb_update=create cb_update
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.dw_new_expense
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.cb_update
end on

on w_disb_new_expense.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.dw_new_expense)
destroy(this.cb_new)
destroy(this.cb_update)
end on

event closequery;call super::closequery;if dw_new_expense.modifiedcount() + dw_new_expense.deletedcount() > 0 then
	if messagebox("Updates Pending", "Data has been changed, but not saved. ~n~nWould you like to save data?", Question!, YesNo!, 1) = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_disb_new_expense
end type

type cb_delete from mt_u_commandbutton within w_disb_new_expense
integer x = 2491
integer y = 1268
integer taborder = 30
string text = "&Delete"
end type

event clicked;dw_new_expense.Deleterow(dw_new_expense.GetRow())
end event

type dw_new_expense from u_datagrid within w_disb_new_expense
event ue_keydown pbm_dwnkey
integer x = 37
integer y = 32
integer width = 2798
integer height = 1220
integer taborder = 50
string dataobject = "dw_disb_new_expense"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event ue_keydown;IF key = KeySpaceBar! THEN 
	CHOOSE CASE this.getColumnName()
		CASE "voucher_nr"
			this.Event DoubleClicked(0,0, this.getRow(), this.object.voucher_nr)
	END CHOOSE
End IF
end event

event itemchanged;decimal ld_input_ex_rate
decimal {2} ld_local_amount
string  ls_voucher_name
integer li_voucher_nr

if this.getColumnName() = "input_amount" then
	SELECT INPUT_EX_RATE INTO :ld_input_ex_rate
	FROM   DISBURSEMENTS
	WHERE  VESSEL_NR = :istr_disb.vessel_nr AND
	       VOYAGE_NR = :istr_disb.voyage_nr AND
	       PORT_CODE = :istr_disb.port_code AND
	       PCN = :istr_disb.pcn AND
	       AGENT_NR = :istr_disb.agent_nr;
	
	ld_local_amount = ((dec(data) * ld_input_ex_rate) / 100) 
	this.SetItem(row, "exp_amount_local", ld_local_amount)
end if

if this.getColumnName() = "voucher_nr" then
	li_voucher_nr = Integer(data)
	
	SELECT VOUCHER_NAME INTO :ls_voucher_name
	FROM   VOUCHERS
	WHERE  VOUCHER_NR = :li_voucher_nr;
	
	if len(ls_voucher_name) > 0 then
		dw_new_expense.SetItem(row, "voucher_name", ls_voucher_name)
	else
		return 2
	end if
end if
end event

event doubleclicked;string ls_voucher_nr, ls_voucher_name
integer li_voucher_nr

if row < 1 then return

ls_voucher_nr = f_select_from_list("d_select_voucher", 1, "Number", 2, "Name", 1, "Select Voucher", false)

IF IsNull(ls_voucher_nr) or ls_voucher_nr = "0" or ls_voucher_nr = "" THEN
	dw_new_expense.SetFocus()
	dw_new_expense.SetColumn("voucher_nr")
ELSE
	li_voucher_nr = Integer(ls_voucher_nr)
	
	SELECT VOUCHER_NAME INTO :ls_voucher_name FROM VOUCHERS WHERE VOUCHER_NR = :li_voucher_nr;

	dw_new_expense.SetItem(row, "voucher_name", ls_voucher_name)
	dw_new_expense.SetItem(row, "voucher_nr", Integer(ls_voucher_nr))
	dw_new_expense.SetFocus()
	dw_new_expense.SetColumn("exp_amount_local")
END IF



end event

event dberror;IF sqldbcode=2601 THEN
 	Messagebox("Error Updating", "Somebody is updating the same Vessel, Voyage, Port and Agent. Please try again!")
	RETURN 1
ELSE
	RETURN 0
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.setrow(currentrow)
end if
end event

type cb_new from mt_u_commandbutton within w_disb_new_expense
integer x = 1797
integer y = 1268
integer taborder = 20
string text = "&New"
boolean default = true
end type

event clicked;long ll_row

ll_row = dw_new_expense.InsertRow(0)

dw_new_expense.SetItem(ll_row,"vessel_nr",istr_disb.vessel_nr)
dw_new_expense.SetItem(ll_row,"voyage_nr",istr_disb.voyage_nr)
dw_new_expense.SetItem(ll_row,"port_code",istr_disb.port_code)
dw_new_expense.SetItem(ll_row,"pcn",istr_disb.pcn)
dw_new_expense.SetItem(ll_row,"agent_nr",istr_disb.agent_nr)
dw_new_expense.SetItem(ll_row,"settled",0)
dw_new_expense.SetItem(ll_row,"expenses_date",now())

if dw_new_expense.rowcount() > 1 then
	dw_new_expense.SetItem(ll_row,"disb_invoice_nr",dw_new_expense.GetItemString(ll_row - 1,"disb_invoice_nr"))
end if

dw_new_expense.SetFocus()
dw_new_expense.SetColumn("voucher_nr")
dw_new_expense.ScrollToRow(ll_row)
	

end event

type cb_update from mt_u_commandbutton within w_disb_new_expense
integer x = 2144
integer y = 1268
integer taborder = 20
string text = "&Update"
end type

event clicked;int li_return

li_return = wf_validate()

if li_return = c#return.success then
	
	if inv_import_expenses.of_save_tc_expenses() = c#return.success then
		
		wf_set_port_exp_id()
		
		IF dw_new_expense.Update() = 1 THEN
			
			commit;
			
			if isValid(w_tc_payments) then
				w_tc_payments.PostEvent("ue_refresh")
			end if
			
			if isValid(w_tc_contract) then
				w_tc_contract.PostEvent("ue_refresh")
			end if
			
			Close(parent)
		ELSE
			Rollback;
			li_return = c#return.failure
			destroy inv_import_expenses
		END IF
		
	end if	
end if

return  li_return
end event

