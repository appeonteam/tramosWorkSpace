$PBExportHeader$u_import_expenses.sru
$PBExportComments$For Global Agent Import file
forward
global type u_import_expenses from nonvisualobject
end type
end forward

global type u_import_expenses from nonvisualobject
end type
global u_import_expenses u_import_expenses

type variables
Datastore ids_disbursement_transactions
Datastore ids_expense_transactions
Datastore ids_rejected_transactions
Datastore ids_temporary_accepted
Datastore ids_temporary_rejected
Datastore ids_vessel_list
mt_n_datastore ids_tc_expenses
Boolean ib_imported = false
Boolean ib_file_imported
Long il_new_row_nr
Decimal {3} id_voy_ex_rate
date	idt_ratedate

end variables

forward prototypes
public subroutine of_load_errors ()
public subroutine of_clear_ds ()
public subroutine of_print_errors ()
public function string of_error_texts (integer al_error_number)
public subroutine of_get_voy_ex_rate (integer ai_vessel, string as_voyage)
public subroutine of_setshareon (ref datawindow adw_accepted, ref datawindow adw_rejected)
public function integer of_import_expenses ()
public function integer of_validate_expenses ()
public subroutine of_move_transaction (ref long al_row, ref long al_rows, integer al_error_number)
public function integer of_validate_rejected ()
public function integer of_rejected_modified (long al_row, string as_columnname, string as_data)
public subroutine of_check_agent ()
public function integer of_update_transactions ()
private function integer of_unfinishdisbursement (s_auto_unfinish_disbursement astr_unfinish[])
private function long of_setvesselnumber ()
public function decimal of_set_exrate (date ratedate)
private subroutine of_voyagenumberchange ()
public subroutine documentation ()
public function integer of_check_expenses ()
public function datetime of_get_port_arr_date (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn)
public function string of_check_tc_expenses (long al_vessel_nr, string as_voyage_nr, long al_voucher_nr, datetime adt_arr_date, ref integer ai_exp_for_oa, ref long al_contract_id)
public function string of_get_disb_currency (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn, integer ai_agent_nr)
public function integer of_save_tc_expenses ()
public subroutine of_set_tc_expenses_id ()
public function string of_insert_tc_expenses (long al_contract_id, integer ai_exp_for_oa, string as_invoice_nr, string as_disb_currency, decimal ad_amount_usd, decimal ad_amount_local, string as_port_code, datetime adt_arr_date, ref long al_insertrow)
public function integer of_settle_expenses ()
end prototypes

public subroutine of_load_errors ();
Integer ll_rows

ll_rows = ids_rejected_transactions.Retrieve()
IF ll_rows = 0 THEN
	MessageBox("Information", "There are no rejected expenses.")
ELSEIF ll_rows = -1 THEN
	MessageBox("Error", "Error retrieving rejected expenses.")
END IF

end subroutine

public subroutine of_clear_ds ();
ids_disbursement_transactions.Reset()
ids_expense_transactions.Reset()
ids_rejected_transactions.Reset()
ids_temporary_accepted.Reset()
ids_temporary_rejected.Reset()
ids_tc_expenses.reset()

ib_imported      = FALSE
ib_file_imported = FALSE
il_new_row_nr    = 0
end subroutine

public subroutine of_print_errors ();
IF ids_rejected_transactions.RowCount() > 0 THEN
	ids_rejected_transactions.Print(TRUE)
ELSE
	MessageBox("Information", "There are no rejected expenses to print.")
END IF
end subroutine

public function string of_error_texts (integer al_error_number);
String ls_error_text

choose case al_error_number
	case 1
		ls_error_text = "Not a global agent. Date : " + String(Today())
	case 2
		ls_error_text = "Select of existing disbursement failed. Date : " + String(Today())
	case 3
		ls_error_text = "It is not possible to create a disbursement, because there is no POC. Date : " + String(Today())
	case 4
		ls_error_text = "The imported global agent is neither a Non Cargo Agent nor a Cargo agent. Date : " + String(Today())
	case 5
		ls_error_text = "Agent not NCAG/Cargo Agent, OR no POC, OR disb.curr./ex.rate not = imported, OR disb.ex.rate not > 0. Date : " + String(Today())
	case 6
		ls_error_text = "Voucher number or Currency code does not exist in TRAMOS. Date : " + String(Today())
	case 7
		ls_error_text = "Exchange rates is not valid. Date : " + String(Today())
	case 8
		ls_error_text = "Echange rate for exchange code USD must be 100. Date : " + String(Today())
	case 9
		ls_error_text = "All expense under the same agent in import file must have the same invoice number. Date : " + String(Today())
	case 10
		ls_error_text = "The import invoice number is different from the existing unsettled expenses in disbursement. Date : " + String(Today())
	case 11
		ls_error_text = "There exists unsettled expenses in database with different invoice numbers under the same agent. Date : " + String(Today())
	case else
		ls_error_text = "Unknown error : " + String(Today())
end choose

return ls_error_text

end function

public subroutine of_get_voy_ex_rate (integer ai_vessel, string as_voyage);


// Changed by request of BJM (APM) 12/11-98
Open(w_voy_ex_rate)
id_voy_ex_rate = Message.DoubleParm	




end subroutine

public subroutine of_setshareon (ref datawindow adw_accepted, ref datawindow adw_rejected);ids_expense_transactions.ShareData(adw_accepted)
ids_rejected_transactions.ShareData(adw_rejected)

Return
end subroutine

public function integer of_import_expenses ();/********************************************************************
   of_import_expenses
   <DESC> This function imports expenses into a instance datastore from a tab delimited file,
 			 specified by the user. 
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	         
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02/06/14		CR3553		XSZ004		Check if the expenses exist in disburesement
   </HISTORY>
********************************************************************/

Integer li_return, li_import_result
String  ls_docname, ls_named, ls_error

li_return = GetFileOpenName("Select File to Import", ls_docname, ls_named, "TXT", "Text Files (*.TXT),*.TXT")
			
if li_return = c#return.success then 
	li_import_result = ids_expense_transactions.ImportFile(ls_docname)

	Choose Case li_import_result
		Case 0
			ls_error = "The importfile has to many rows!"
		case -1
			ls_error = "The importfile has no expenses!"
		Case -2
			ls_error = "The importfile specified is empty!"
		case -3
			ls_error = "The argument for the importfile is invalid!"
		case -4
			ls_error = "The input is invalid!"
		case -5
			ls_error = "The importfile could not be opened!"
		case -6
			ls_error = "The importfile could not be closed!"
		case -7
			ls_error = "There has been errors reading the text!"
		case -8
			ls_error = "The importfile is not a textfile!"
		case -9
			ls_error = "The import has been canceled!"
	End Choose
	
	if li_import_result < 1 then
		li_return = c#return.failure
	else
		ids_vessel_list.retrieve()
		li_return = of_setvesselnumber( )
		
		if li_return > 0 then
			return c#return.failure
		else
			//Ensure voyage numbers are correct
			of_voyagenumberchange( )  
			ids_expense_transactions.Sort()
			
			li_return = of_validate_expenses()
			
			if li_return <> c#return.failure then
				ib_imported = true
				ib_file_imported = true
				ids_temporary_rejected.Reset()
			end if
		end if
	end if
end if

if li_return = c#return.failure then
	if len(ls_error) < 1 then
		ls_error = "Error in the validation process. All import is halted!"
	end if
	messagebox("Error", ls_error)
end if

Return li_return

end function

public function integer of_validate_expenses ();/**************************************************************************************************************
   u_import_expenses
   <OBJECT>		Validate the import record.	</OBJECT>
   <USAGE>		when import disbursement record.			</USAGE>
   <ALSO>				</ALSO>
	<Parameter>
		ld_pay_ex_rate:	Payment rate(Other Curr to DKK)
		ld_voy_ex_rate:	Voyage rate(USD to DKK)
		ld_disb_ex_rate:	Rate from import file
		ld_ex_ex_rate:		Exchange(Other curr to USD)
		ld_amount_usd:		Sum amount
		ld_disb_ex_usd:	Rate reference currency and date from system table.
	</Parameter>
   <HISTORY>
   	Date      	CR-Ref		Author		Comments
		15/08/2012	CR2904		WWG004		Change the disbursement exchange rate and validate import records.
		23/08/2012	CR2915		LGX001		Change the validation for import expenses records.
		08/31/2012 	CR2857		WWG004		Validation the invoice nr under one agent
		07/09/12  	CR2936		JMC112		Correct error. (solved in a fast way, not the perfect solution)
		05/06/14 	CR3478		XSZ004		Allow import expenses with different invoice numbers. 
   </HISTORY>
****************************************************************************************************************/

Integer    li_vessel, li_previous_vessel, li_pcn, li_previous_pcn, li_voucher, li_voucher_ok
Integer    li_agent_nr, li_agent_nr_ok, li_error_nr, li_ncag_agent_nr, li_return
Long       ll_rows, ll_counter, ll_new_disb_row, ll_found
long       ll_progress_teller = 1, ll_progress_rows
Decimal{3} ld_pay_ex_rate, ld_voy_ex_rate, ld_disb_ex_rate, ld_ex_ex_rate, ld_amount_usd, ld_disb_ex_usd, ld_row_rate
String     ls_voyage, ls_previous_voyage, ls_port, ls_previous_port, ls_agent_sn, ls_previous_agent_sn
String     ls_disb_currency, ls_payment_currency, ls_currency,ls_currency_ok, ls_find
Boolean    lb_create_disbursement, lb_create_disbursement_error, lb_new_disb, lb_trans_rejected,lb_update_disb, lb_row_rate_error
DateTime   ldt_arr, ldt_dept

// Let all transactions where agent is not global, be or be moved to rejected ds. 
of_check_agent()

// Delete the lines with zero(CR2915) 
do while 1 = 1 
	ll_found = ids_expense_transactions.find("isnull(disb_expenses_exp_amount_local) or disb_expenses_exp_amount_local = 0", 1, ids_expense_transactions.rowcount()) 
	if ll_found > 0 then 
		ids_expense_transactions.deleterow(ll_found)
	else
		exit
	end if
loop

// Count rows here , it can have been changed by check agent function.
ll_rows = ids_expense_transactions.rowcount()

setpointer(HourGlass!)

//Open Progress Window and initialize teller
open(w_import_progress)

IF ll_rows > 0 THEN 
	ll_progress_rows = ll_rows
ELSE
	ll_progress_rows = 1
END IF

FOR ll_counter = 1 TO ll_rows // Loop through all transactions

	lb_new_disb       = false
	lb_trans_rejected = false
	lb_row_rate_error = false
	
	lb_create_disbursement       = false
	lb_create_disbursement_error = false
	
	li_agent_nr_ok = 0
	
	//Get data for check. NEVER CHANGE THE ORDER OF THE COLUMNS IN THE DATASTORES !!!!
	li_vessel 	= ids_expense_transactions.GetItemNumber(ll_counter, 12)
	ls_voyage 	= ids_expense_transactions.GetItemString(ll_counter, 2)
	ls_port     = ids_expense_transactions.GetItemString(ll_counter, 3)
	li_pcn 		= ids_expense_transactions.GetItemNumber(ll_counter, 4)
	ls_agent_sn = ids_expense_transactions.GetItemString(ll_counter, 5)
	ld_row_rate = ids_expense_transactions.GetItemNumber(ll_counter, 10)
	ls_payment_currency = ids_expense_transactions.GetItemString(ll_counter, 8)
	
	// Validate rate of current row(CR2915)
	if isnull(ld_row_rate) or ld_row_rate <= 0 then	
		
		lb_row_rate_error            = true
		lb_create_disbursement_error = true
		
		of_move_transaction(ll_counter, ll_rows, 7)
		li_error_nr = 7
		
	elseif ls_payment_currency = "USD" then
		
		if ld_row_rate <> 100 then 
			lb_row_rate_error = true
			lb_create_disbursement_error = true
			of_move_transaction(ll_counter, ll_rows, 8)
			li_error_nr = 8
					
		end if	
	end if
	
	// FR 10-09-02; funktionskald
	SELECT AGENT_NR INTO :li_ncag_agent_nr
	FROM   AGENTS
	WHERE  AGENT_SN = :ls_agent_sn;
	
	//Get USD exchange rate based on the selected import date
	SELECT EXRATE_USD INTO :ld_disb_ex_usd
	FROM   NTC_EXCHANGE_RATE
	WHERE  CURR_CODE = :ls_payment_currency AND RATE_DATE = :idt_ratedate ;
	
	f_check_agent(li_vessel, ls_voyage, ls_port, li_pcn, li_ncag_agent_nr)	
	
	// Is this a different disb. than last row ?
	if not(li_previous_vessel = li_vessel and ls_previous_voyage = ls_voyage and &
		ls_previous_port = ls_port and li_previous_pcn = li_pcn and &
		ls_previous_agent_sn = ls_agent_sn ) and (lb_row_rate_error = false) then
		
		lb_new_disb = TRUE
		
		// Check if disb. exist, and get disb data for check
		SELECT DISBURSEMENTS.PAYMENT_EX_RATE, DISBURSEMENTS.VOYAGE_EX_RATE,   
				 DISBURSEMENTS.EX_EX_RATE,   
				 DISBURSEMENTS.DISBURSEMENT_CURRENCY, DISBURSEMENTS.DISB_EX_RATE, 
				 DISBURSEMENTS.PAYMENT_CURRENCY, DISBURSEMENTS.AGENT_NR  
		 INTO :ld_pay_ex_rate, :ld_voy_ex_rate, :ld_ex_ex_rate,
			   :ls_disb_currency, :ld_disb_ex_rate, :ls_payment_currency, :li_agent_nr
		 FROM DISBURSEMENTS, AGENTS  
		WHERE ( AGENTS.AGENT_NR = DISBURSEMENTS.AGENT_NR ) AND  
				( ( DISBURSEMENTS.VESSEL_NR = :li_vessel ) AND  
				( DISBURSEMENTS.VOYAGE_NR = :ls_voyage ) AND  
				( DISBURSEMENTS.PORT_CODE = :ls_port ) AND  
				( DISBURSEMENTS.PCN = :li_pcn ) AND  
				( AGENTS.AGENT_SN = :ls_agent_sn ) )   ;
					
		IF SQLCA.SQLCode = -1 THEN // This and all trans for this disb. are errors.
			lb_create_disbursement_error = TRUE
			of_move_transaction(ll_counter, ll_rows, 2)
			li_error_nr = 2
			ROLLBACK;
		ELSEIF SQLCA.SQLCode = 100 THEN // Check if it is possible to create disb.
				
			SELECT AGENT_NR INTO :li_ncag_agent_nr
			FROM   AGENTS
			WHERE  AGENT_SN = :ls_agent_sn;
			
			ls_find = "agent_nr = " + string(li_ncag_agent_nr) + " and port_code = '" + ls_port + &
			          "' and vessel_nr = " + string(li_vessel) + " and voyage_nr = '" + ls_voyage + &
			          "' and pcn = " + string(li_pcn) 
						 
			ll_found = ids_disbursement_transactions.Find(ls_find, 1, ids_disbursement_transactions.RowCount())

			ls_payment_currency = ids_expense_transactions.GetItemString(ll_counter, 8) 
			
			SELECT EXRATE_DKK INTO :ld_pay_ex_rate
			FROM   NTC_EXCHANGE_RATE
			WHERE CURR_CODE = :ls_payment_currency AND RATE_DATE = :idt_ratedate ;
				
			IF ll_found > 0 THEN
				ld_disb_ex_rate 	= ids_disbursement_transactions.GetItemNumber(ll_found, "disb_ex_rate")
				ls_disb_currency 	= ids_disbursement_transactions.GetItemString(ll_found, "disbursement_currency")
				
				IF ls_disb_currency <> ids_expense_transactions.GetItemString(ll_counter, 8) THEN			
					lb_create_disbursement_error = TRUE
					lb_new_disb = TRUE
					of_move_transaction(ll_counter, ll_rows, 5)
					li_error_nr = 5
				END IF
			ELSE
				SELECT PORT_ARR_DT, PORT_DEPT_DT, AGENT_NR INTO :ldt_arr, :ldt_dept, :li_agent_nr_ok
				FROM   POC
				WHERE  VESSEL_NR = :li_vessel AND VOYAGE_NR = :ls_voyage AND
				       PORT_CODE = :ls_port AND PCN = :li_pcn ;
						 
				IF SQLCA.SQLCode <> 0 THEN // No POC, so this and all trans for this disb. are errors.
					lb_create_disbursement_error = TRUE
					of_move_transaction(ll_counter, ll_rows, 3)
					li_error_nr = 3
				END IF
				
				IF NOT(lb_create_disbursement_error) AND (li_agent_nr_ok <> li_ncag_agent_nr OR IsNull(li_agent_nr_ok))THEN
					
					SELECT TRA_NCAG.AGENT_NR INTO :li_agent_nr_ok
					FROM   TRA_NCAG, AGENTS  
					WHERE  (AGENTS.AGENT_NR = TRA_NCAG.AGENT_NR) AND ((TRA_NCAG.VESSEL_NR = :li_vessel ) AND  
					       (TRA_NCAG.VOYAGE_NR = :ls_voyage) AND (TRA_NCAG.PORT_CODE = :ls_port) AND  
					       (TRA_NCAG.PCN = :li_pcn) AND (AGENTS.AGENT_SN = :ls_agent_sn));
							  
					IF SQLCA.SQLCode <> 0 THEN // No Non cargo agent, so check for cargo agent
						
						SELECT CARGO.AGENT_NR INTO :li_agent_nr_ok 
						FROM   CARGO, AGENTS  
						WHERE  (AGENTS.AGENT_NR = CARGO.AGENT_NR) and ((CARGO.VESSEL_NR = :li_vessel) AND  
						       (CARGO.VOYAGE_NR = :ls_voyage) AND (CARGO.PORT_CODE = :ls_port) AND  
						       (CARGO.PCN = :li_pcn) AND (AGENTS.AGENT_SN = :ls_agent_sn));
						
						IF SQLCA.SQLCode <> 0 THEN // Also No Cargo agent, so this and all trans for this disb. are errors.
							lb_create_disbursement_error = TRUE
							of_move_transaction(ll_counter,ll_rows,4)

							li_agent_nr_ok = 0
							li_error_nr    = 4
						END IF			
					END IF
				END IF
					
				IF NOT(lb_create_disbursement_error) THEN	
					// The disb is ready for create
					lb_create_disbursement = TRUE
				ELSE
					ld_disb_ex_rate = 0
					SetNull(ls_disb_currency) 
				END IF
				
			END IF	
		else // Validate exist disb. 
			
			// If voy ex rate but not pay ex rate is known then copy from voy to pay
			IF ld_voy_ex_rate > 0 AND NOT(ld_pay_ex_rate) > 0 THEN 
				
				if ls_payment_currency = "USD" then
					ld_pay_ex_rate = ld_voy_ex_rate
				END IF
				
				lb_update_disb = TRUE
				// IF neither voy or pay ex rate is known get it from istance variable, max received frt, 
				// or user input. If user cancels then stop all import actions.	
			ELSEIF NOT(ld_voy_ex_rate > 0) AND NOT(ld_pay_ex_rate) > 0 THEN
				
				IF NOT(id_voy_ex_rate) > 100 THEN of_get_voy_ex_rate(li_vessel, ls_voyage)
				
				IF NOT(id_voy_ex_rate) > 100 THEN 
					IF IsValid(w_import_progress) THEN close(w_import_progress) //Close progress window
					Return -1 // Stop and clear the import !!!
				END IF
				
				ld_voy_ex_rate = id_voy_ex_rate
				
				if ls_payment_currency = "USD" then ld_pay_ex_rate = id_voy_ex_rate

				lb_update_disb = TRUE
			END IF
			
			// IF disb ex rate ordisb currency differs then reject disb.
			IF ls_disb_currency <> ids_expense_transactions.GetItemString(ll_counter, 8) OR NOT(ld_disb_ex_rate) > 0 THEN
				
				lb_create_disbursement_error = TRUE
					
				of_move_transaction(ll_counter, ll_rows, 5)
				li_error_nr = 5
			END IF
			
			IF lb_update_disb THEN
				ld_ex_ex_rate = ((ld_pay_ex_rate / ld_disb_ex_rate) * 100)
				
				UPDATE DISBURSEMENTS  
				   SET PAYMENT_EX_RATE = :ld_pay_ex_rate,   
					    VOYAGE_EX_RATE = :ld_voy_ex_rate,   
					    EX_EX_RATE = :ld_ex_ex_rate  
				 WHERE ( DISBURSEMENTS.AGENT_NR = :li_agent_nr ) AND  
						 ( DISBURSEMENTS.PORT_CODE = :ls_port ) AND  
						 ( DISBURSEMENTS.VESSEL_NR = :li_vessel ) AND  
						 ( DISBURSEMENTS.VOYAGE_NR = :ls_voyage ) AND  
						 ( DISBURSEMENTS.PCN = :li_pcn ) ;
						 
				IF SQLCA.SQLCode <> 0 THEN
					Rollback;
					MessageBox("Error", "Error updating existing disbursement. All import actions stop")	
					IF IsValid(w_import_progress) THEN close(w_import_progress) //Close progress window
					Return -1
				ELSE
					Commit;
					lb_update_disb = FALSE
				END IF
			END IF
		END IF
			
		// Save disb. key for this row, so it is possible to see if the next row is for the same disb.
		/* //DISABLED 
		li_previous_vessel = li_vessel
		ls_previous_voyage = ls_voyage
		ls_previous_port = ls_port
		li_previous_pcn = li_pcn
		ls_previous_agent_sn = ls_agent_sn
		*/
		
	elseif lb_row_rate_error = false then 
		
		SELECT AGENT_NR INTO :li_ncag_agent_nr
		FROM   AGENTS
		WHERE  AGENT_SN = :ls_agent_sn ;

		ls_find = "agent_nr = " + string(li_ncag_agent_nr) + " and port_code = '" + ls_port + &
		          "' and vessel_nr = " + string(li_vessel) + " and voyage_nr = '" + ls_voyage +&
		          "' and pcn = " + string(li_pcn)
					 
		ll_found = ids_disbursement_transactions.Find(ls_find, 1, ids_disbursement_transactions.RowCount())
		
		IF ll_found > 0 THEN
			
			ld_disb_ex_rate 	= ids_disbursement_transactions.GetItemNumber(ll_found, "disb_ex_rate")
			ls_disb_currency 	= ids_disbursement_transactions.GetItemString(ll_found, "disbursement_currency")
			
			IF ls_disb_currency <> ids_expense_transactions.GetItemString(ll_counter, 8) THEN
				
				lb_create_disbursement_error = TRUE
				lb_new_disb = TRUE
				of_move_transaction(ll_counter, ll_rows, 5)
				li_error_nr = 5
			END IF
		ELSEIF ls_disb_currency <> ids_expense_transactions.GetItemString(ll_counter, 8) THEN
			
			lb_create_disbursement_error = TRUE
			lb_new_disb = TRUE
			of_move_transaction(ll_counter, ll_rows, 5)
			li_error_nr = 5
		END IF
	END IF
	
	IF NOT(lb_create_disbursement_error) THEN // Disb. was ok so now check the rest of the transaction
		
		// Check trans : voucher number, valid date, valid currency code, valid decimal amount and ex rate.
		li_voucher 	= ids_expense_transactions.GetItemNumber(ll_counter, 6)
		ls_currency = ids_expense_transactions.GetItemString(ll_counter, 8)
		
		// Check voucher
		SELECT VOUCHER_NR INTO :li_voucher_ok
		  FROM VOUCHERS
		 WHERE VOUCHER_NR = :li_voucher ;
		
		IF SQLCA.SQLCode <> 0 THEN
			lb_trans_rejected = TRUE
		END IF
		
		// Check currency code
		SELECT CURR_CODE INTO :ls_currency_ok
		  FROM CURRENCY
		 WHERE CURR_CODE = :ls_currency ;
		
		IF SQLCA.SQLCode <> 0 THEN
			lb_trans_rejected = TRUE
		END IF
						
		IF lb_trans_rejected THEN
			of_move_transaction(ll_counter, ll_rows, 6)
			li_error_nr = 6
		ELSEIF NOT(lb_trans_rejected) THEN 
			
			// Fill the rest of the trans data in ids_expense_transaction in row ll_counter
			ld_disb_ex_rate = ids_expense_transactions.GetItemNumber(ll_counter, 10)
	
			if ids_expense_transactions.GetItemString(ll_counter, 8) = "USD" then
				ld_amount_usd = ids_expense_transactions.GetItemNumber(ll_counter, 7)
			else
				ld_amount_usd = ids_expense_transactions.GetItemNumber(ll_counter, 7) * ld_disb_ex_rate / 100
			end if
			
			ids_expense_transactions.SetItem(ll_counter, "disb_expenses_exp_amount_usd", ld_amount_usd)
					
			IF li_agent_nr_ok > 0 THEN
				ids_expense_transactions.SetItem(ll_counter, "disb_expenses_agent_nr", li_agent_nr_ok)
			ELSE				
				ids_expense_transactions.SetItem(ll_counter, "disb_expenses_agent_nr", li_ncag_agent_nr) //,li_agent_nr)
			END IF
			
			ids_expense_transactions.SetItem(ll_counter, "disb_expenses_settled", 0)
			
			IF lb_create_disbursement THEN
				
				// IF there are disb to create, then create in ids_disbursement. AND set lb_create_disb = FALSE
				ll_new_disb_row = ids_disbursement_transactions.InsertRow(0)
				
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "agent_nr", li_agent_nr_ok)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "vessel_nr", li_vessel)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "voyage_nr", ls_voyage)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "port_code", ls_port)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "pcn", li_pcn)
		
//				IF voy ex rate is unknown get from max frt received or user input, else stop all import
				IF NOT(id_voy_ex_rate) > 100 THEN of_get_voy_ex_rate(li_vessel, ls_voyage)
				
				IF NOT(id_voy_ex_rate) > 100 THEN 
					IF IsValid(w_import_progress) THEN close(w_import_progress) //Close progress window
					Return -1 // Stop and clear the import !!!
				END IF
				
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "voyage_ex_rate", id_voy_ex_rate)

				if ls_payment_currency = "USD" then
					ld_pay_ex_rate = id_voy_ex_rate
				end if

				ids_disbursement_transactions.SetItem(ll_new_disb_row, "payment_ex_rate", ld_pay_ex_rate)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "ctm_ex_rate", 0)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "disb_ex_rate", ld_disb_ex_usd)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "ex_ex_rate", ((ld_pay_ex_rate / ld_disb_ex_rate) * 100))
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "disb_arr_dt", ldt_arr)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "disb_dept_dt", ldt_dept)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "disb_in_balance", 0)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "disbursement_currency", ls_currency)
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "payment_currency", "USD")
				ids_disbursement_transactions.SetItem(ll_new_disb_row, "ctm_currency", "USD")
				
				lb_create_disbursement = FALSE
			END IF
		END IF
	elseif lb_create_disbursement_error and not(lb_new_disb) and not(lb_row_rate_error) then
		// This is for the same disb, as previous row, which had a disb. with error, so reject this trans.
		// But if it is a new disb the first trans is rejected in the disb. handling code, so
		// only reject, if it is a new row for same disb.
		of_move_transaction(ll_counter,ll_rows,li_error_nr)
	end if
	
	/* Update progress window */
	IF IsValid(w_import_progress) THEN
		w_import_progress.uo_progress_bar.uf_Set_Position(ll_progress_teller * 100 / ll_progress_rows)
		ll_progress_teller ++
	END IF
NEXT

li_return = of_check_expenses()

ids_expense_transactions.Sort()

IF IsValid(w_import_progress) THEN close(w_import_progress) //Close progress window

Return li_return

end function

public subroutine of_move_transaction (ref long al_row, ref long al_rows, integer al_error_number);
il_new_row_nr = ids_rejected_transactions.InsertRow(0)

ids_rejected_transactions.Object.Data[il_new_row_nr, 1, il_new_row_nr, 13] = ids_expense_transactions.Object.Data[al_row, 1, al_row, 13]

ids_expense_transactions.DeleteRow(al_row)

ids_rejected_transactions.SetItem(il_new_row_nr, "error_text", of_error_texts(al_error_number))

al_row --
al_rows --

end subroutine

public function integer of_validate_rejected ();/********************************************************************
   of_validate_rejected
   <DESC> 
		This function is called when the user wants to validate rejected trans. IF there are any trans. that has been
		validated and is stored in ids_expense_transactions save them temporarely, move the rejected from ids_rejected
		to ids_expenses_transaction, and validate them. Then move the temporarely stored transactions back to 
	 	ids_expense_transactions.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	         
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		16/04/15		CR3854		XSZ004		Transfer to T/C-Hire when import/new expenses.
   </HISTORY>
********************************************************************/

Boolean	lb_temporary
Integer	li_return
Long 		ll_expense_rows, ll_temp_rows, ll_counter, ll_rejected_transactions

IF IsValid(w_expense_import.dw_rejected) THEN w_expense_import.dw_rejected.AcceptText()

ll_temp_rows = ids_expense_transactions.Rowcount() 

ll_rejected_transactions = ids_rejected_transactions.Rowcount()

IF ll_temp_rows > 0 THEN
	
	lb_temporary = TRUE
	
	FOR ll_counter = 1 TO ll_temp_rows
		ids_temporary_accepted.InsertRow(0)
	NEXT
	
	ids_temporary_accepted.Object.Data = ids_expense_transactions.Object.Data
	ids_expense_transactions.Reset()
END IF

FOR ll_counter = 1 TO ll_rejected_transactions
	ids_expense_transactions.InsertRow(0)
NEXT

ids_expense_transactions.Object.Data[1, 1, ll_rejected_transactions, 13] = &
						ids_rejected_transactions.Object.Data[1, 1, ll_rejected_transactions, 13]
	
// This will be updated later
IF NOT(ids_temporary_rejected.RowCount() > 0) AND NOT(ib_file_imported) THEN
	
	FOR ll_counter = 1 TO ll_rejected_transactions
		ids_temporary_rejected.InsertRow(0)
	NEXT
	
	ids_temporary_rejected.Object.Data = ids_rejected_transactions.Object.Data
	ids_temporary_rejected.ResetUpdate()
END IF

ids_rejected_transactions.Reset()
	
if lb_temporary then
	
	ll_expense_rows = ids_expense_transactions.RowCount()
	
	for ll_counter = 1 to ll_temp_rows
			ids_expense_transactions.InsertRow(0)
	next
	
	ids_expense_transactions.Object.Data[(ll_expense_rows + 1), 1, (ll_expense_rows+ll_temp_rows), 19] = & 
										ids_temporary_accepted.Object.Data[1, 1, ll_temp_rows, 19]
end if

ids_tc_expenses.reset()

li_return = of_validate_expenses()

if li_return = -1 then
	return -1
end if

if ids_expense_transactions.RowCount() > 0 then ib_imported = true

return 0
end function

public function integer of_rejected_modified (long al_row, string as_columnname, string as_data);/********************************************************************
   of_rejected_modified
   <DESC> if the user changes a field this function will change all other similar records </DESC>
   <RETURN>
       li_return    
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
		as_columnname
		as_data
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02/06/14		CR3424		XSZ004		List records when modifying any single record within the same combination
   </HISTORY>
********************************************************************/

string ls_filter, ls_column_title, ls_invoice_nr
long   ll_findrow
int    li_return

s_verify_rejected    lstr_parm

ls_invoice_nr = ids_rejected_transactions.getItemString(al_row, "disb_invoice_nr")

if isnull(ls_invoice_nr) or trim(ls_invoice_nr) = "" then
	ls_filter  = "isnull(disb_invoice_nr) or disb_invoice_nr = ''"
else
	ls_filter  = "disb_invoice_nr = '" + ls_invoice_nr + "'"
end if
	
ll_findrow = ids_rejected_transactions.find(ls_filter, 1, ids_rejected_transactions.rowcount())
ll_findrow = ids_rejected_transactions.find(ls_filter, ll_findrow + 1, ids_rejected_transactions.rowcount() + 1)

if ll_findrow > 0 then
	ls_column_title         = ids_rejected_transactions.describe(as_columnname + "_t.text")
	lstr_parm.as_message    = "Do you want to change the listed expenses' " + ls_column_title + " to " + as_data + "?"
	lstr_parm.ads_rejected  = ids_rejected_transactions
	lstr_parm.as_filter     = ls_filter
	lstr_parm.as_columnName	= as_columnName
	lstr_parm.as_data       = as_data
	lstr_parm.al_order_no   = ids_rejected_transactions.getitemnumber(al_row, "order_no")

	w_expense_import.dw_rejected.SetRedraw(false)
	
	openwithparm(w_verify_change, lstr_parm)
	li_return = message.doubleparm
	
	w_expense_import.dw_rejected.SetRedraw(true)
end if

return li_return

end function

public subroutine of_check_agent ();Long		ll_rows, ll_counter
String	ls_shortname = " ", ls_previous_shortname = " "
Integer	li_import

ll_rows = ids_expense_transactions.RowCount()

FOR ll_counter = 1 TO ll_rows
	
	ls_shortname = ids_expense_transactions.GetItemString(ll_counter, "agents_agent_sn")
	
	IF ls_shortname <> ls_previous_shortname THEN
		SELECT IMPORT_FILE
		INTO :li_import
		FROM AGENTS
		WHERE AGENT_SN = :ls_shortname ;
		IF SQLCA.SQLCode <> 0 THEN
			li_import = 0
		END IF
		Commit;
	END IF
	
	ls_previous_shortname = ls_shortname
	
	IF li_import <> 1 OR IsNull(li_import) THEN
		of_move_transaction(ll_counter, ll_rows, 1)
	END IF
		
NEXT
end subroutine

public function integer of_update_transactions ();integer li_vessel_nr, li_pcn, li_agent_nr
integer li_prev_vessel_nr = 0, li_prev_pcn = 0, li_prev_agent_nr = 0
string  ls_voyage_nr, ls_port, ls_prev_voyage_nr = "", ls_prev_port = "", ls_errortext
long    ll_no_of_rows, ll_current_row, ll_expense_counter, ll_found, ll_index
boolean lb_updated

s_auto_unfinish_disbursement lstr_unfinish[]

ll_no_of_rows = ids_expense_transactions.RowCount()

// Set expense counter
FOR ll_current_row = 1 TO ll_no_of_rows
	
	if not isnull(ids_expense_transactions.getitemstring(ll_current_row, "reason")) then
		ids_expense_transactions.setitemstatus(ll_current_row, 0, primary!, notmodified!)
		continue
	end if
	
	li_vessel_nr = ids_expense_transactions.GetItemNumber(ll_current_row, "disb_expenses_vessel_nr")
	ls_voyage_nr = ids_expense_transactions.GetItemString(ll_current_row, "disb_expenses_voyage_nr")
	ls_port      = ids_expense_transactions.GetItemString(ll_current_row, "disb_expenses_port_code")
	li_pcn       = ids_expense_transactions.GetItemNumber(ll_current_row, "disb_expenses_pcn")
	li_agent_nr  = ids_expense_transactions.GetItemNumber(ll_current_row, "disb_expenses_agent_nr")
	
	IF li_vessel_nr = li_prev_vessel_nr AND ls_voyage_nr = ls_prev_voyage_nr AND &
		ls_port = ls_prev_port AND li_pcn = li_prev_pcn AND li_agent_nr = li_prev_agent_nr THEN
		
		ll_expense_counter ++
	ELSE

		ll_index                          = upperBound(lstr_unfinish) + 1
		lstr_unfinish[ll_index].vessel_nr = li_vessel_nr
		lstr_unfinish[ll_index].voyage_nr = ls_voyage_nr
		lstr_unfinish[ll_index].port_code = ls_port
		lstr_unfinish[ll_index].pcn       = li_pcn
		lstr_unfinish[ll_index].agent_nr  = li_agent_nr
		
		SELECT ISNULL(MAX(EXPENSES_COUNTER),0) INTO :ll_expense_counter
		FROM   DISB_EXPENSES
		WHERE  VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr AND
		       PORT_CODE = :ls_port AND PCN = :li_pcn AND AGENT_NR = :li_agent_nr ;
				
		IF SQLCA.SQLCode = 100 THEN ll_expense_counter = 1
		
		IF SQLCA.SQLCode = 0 THEN ll_expense_counter ++
		
		IF SQLCA.SQLCode = -1 THEN
			Rollback;
			MessageBox("Error", "This import will fail. Please contact SystemOwner.")
			Return -1
		END IF  
	END IF
	
	ids_expense_transactions.SetItem(ll_current_row, "disb_expenses_expenses_counter", ll_expense_counter)

	li_prev_vessel_nr = li_vessel_nr 
	ls_prev_voyage_nr = ls_voyage_nr
	ls_prev_port      = ls_port 
	li_prev_pcn       = li_pcn 
	li_prev_agent_nr  = li_agent_nr 
NEXT

lb_updated = false

if MessageBox("Update Expenses", "Do you want to update Disbursements with the accepted expenses?", Question!, YesNo!) = 1 then
	
	if of_save_tc_expenses() = c#return.success then
		
		of_set_tc_expenses_id()
		
		IF ids_disbursement_transactions.Update(TRUE, FALSE) = 1 THEN
			IF ids_expense_transactions.Update(TRUE, FALSE) = 1 THEN
				IF ids_temporary_rejected.RowCount() > 0 THEN
					
					Long   ll_exp_rows, ll_counter
					String ls_keyident
					
					ll_exp_rows = ids_expense_transactions.RowCount()
					
					FOR ll_counter = 1 to ll_exp_rows
						
						ls_keyident = String(ids_expense_transactions.GetItemNumber(ll_counter, "keyident"))
						ll_found    = ids_temporary_rejected.Find("keyident = " + ls_keyident, 1, ids_temporary_rejected.RowCount())
						
						IF ll_found > 0 THEN 
							ids_temporary_rejected.DeleteRow(ll_found)
						ELSE
							ls_errortext = SQLCA.SQLErrText
							RollBack;
							MessageBox("Error", "Error updating REJECTED_IMPORT_EXPENSES. Probably a problem with autoincrement key. Please contact system administrator.~r~nSQLErrText: " + ls_errortext)
							Return -1
						END IF	
					NEXT		
					
					IF	ids_temporary_rejected.Update(TRUE, FALSE) = 1 THEN						
						lb_updated = true
						ids_temporary_rejected.ResetUpdate()							
					ELSE
						ls_errortext = SQLCA.SQLErrText
						RollBack;
						MessageBox("Error", "Update aborted, because update rejected failed.~r~nSQLErrText: " + ls_errortext)
					END IF
				ELSEIF ids_rejected_transactions.Update(TRUE, FALSE) = 1 THEN					
					lb_updated = true				
					ids_rejected_transactions.ResetUpdate()					
				Else
					ls_errortext = SQLCA.SQLErrText
					Rollback;
					MessageBox("Error", "Update aborted, because update rejected failed.~r~nSQLErrText: " + ls_errortext)
				END IF
			ELSE
				ls_errortext = SQLCA.SQLErrText
				Rollback;
				MessageBox("Error", "Update aborted, because update expenses failed.~r~nSQLErrText: " + ls_errortext)
			END IF
		ELSE
			ls_errortext = SQLCA.SQLErrText
			Rollback;
			MessageBox("Error", "Update aborted, because update disbursement failed.~r~nSQLErrText: " + ls_errortext)
		END IF
	end if
end if

if lb_updated then
	
	commit;
	
	ids_disbursement_transactions.ResetUpdate()
	ids_expense_transactions.ResetUpdate()
	ids_tc_expenses.resetupdate()
	
	of_unfinishDisbursement(lstr_unfinish)
	
	if of_settle_expenses() <> c#return.failure then
		MessageBox("Information", "Update completed. Clearing data display.")
	end if
	
	of_clear_ds()
	
	if isValid(w_tc_payments) then
		w_tc_payments.PostEvent("ue_refresh")
	end if
	
	if isValid(w_tc_contract) then
		w_tc_contract.PostEvent("ue_refresh")
	end if
end if

Return 0
end function

private function integer of_unfinishdisbursement (s_auto_unfinish_disbursement astr_unfinish[]);long		ll_rows, ll_row
datetime	ldt_null

setNull(ldt_null)
ll_rows = upperBound(astr_unfinish)

for ll_row = 1 to ll_rows
	UPDATE DISBURSEMENTS
		SET DISB_FINISH_DT = :ldt_null
		WHERE VESSEL_NR = :astr_unfinish[ll_row].vessel_nr
		AND VOYAGE_NR = :astr_unfinish[ll_row].voyage_nr
		AND PORT_CODE = :astr_unfinish[ll_row].port_code
		AND PCN = :astr_unfinish[ll_row].pcn
		AND AGENT_NR = :astr_unfinish[ll_row].agent_nr ;
	IF SQLCA.SQLCode = 0 then 
		commit;
	end if
next

/* Refresh disbursement window if open */
if isValid(w_disbursements) then
	w_disbursements.dw_disb_proc_list.event Clicked(0, 0, w_disbursements.dw_disb_proc_list.getRow(), w_disbursements.dw_disb_proc_list.object)
end if

return 1
end function

private function long of_setvesselnumber ();/* Returns the row number if something goes wrong else 0 */

string	ls_vessel_ref_nr
long		ll_vessel_nr
long		ll_rows, ll_row, ll_found

ll_rows = ids_expense_transactions.rowcount( )

for ll_row = 1 to ll_rows
	
	ls_vessel_ref_nr = ids_expense_transactions.getItemString(ll_row, "vessel_ref_nr")
	if isnull(ls_vessel_ref_nr) then 
		ls_vessel_ref_nr = ""
	end if
	
	ll_found = ids_vessel_list.find("vessel_ref_nr = '" + ls_vessel_ref_nr + "'", 1, 9999999)
	if ll_found < 1 then 
		messagebox("Error", "Vessel number <" + string(ls_vessel_ref_nr) + "> can not be found. All import is halted!")
		return ll_row
	end if
	
	ll_vessel_nr = ids_vessel_list.getItemNumber(ll_found, "vessel_nr")
	ids_expense_transactions.setItem(ll_row, "disb_expenses_vessel_nr", ll_vessel_nr)
next	

return 0


end function

public function decimal of_set_exrate (date ratedate);if isnull(ratedate) then
	messagebox("Info", "Please enter a exchange rate date!")
	return -1
elseif ratedate > Today ( ) then
	ratedate = Today ( )
end if

idt_ratedate = ratedate

SELECT EXRATE_DKK
INTO :id_voy_ex_rate
FROM NTC_EXCHANGE_RATE
WHERE RATE_DATE = :ratedate 
AND CURR_CODE = "USD";

if sqlca.sqlcode <> 0 then
	messagebox("Info", "Can't find the exchange rate, please input another date!")
	return -1
end if
commit;

return id_voy_ex_rate
end function

private subroutine of_voyagenumberchange ();/* Run through all the imported rows and check the voyage number 
	Find out if voyage number is in old format, and has to be converted
	to "new" format 
	If before 2011 add one digit (ex. T1050->T10050) */

long 		ll_rows, ll_row
string	ls_voyage
integer	li_year

ll_rows = ids_expense_transactions.rowCount()

for ll_row = 1 to ll_rows
	ls_voyage = ids_expense_transactions.getItemString(ll_row, "disb_expenses_voyage_nr")
	ls_voyage = trim(ls_voyage)
	/* if voyage number length 4 or 6 old single or tc-out voyage, add digit */
	if len(ls_voyage) = 4 &
	or len(ls_voyage) = 6  then
		if left(ls_voyage, 1) = "9" then
			li_year = 1900 
		else 
			li_year = 2000
		end if
		li_year += integer(mid(ls_voyage, 1, 2))
		if li_year < 2011 then
			ls_voyage = left(ls_voyage,2) + "0" + right(ls_voyage,len(ls_voyage) -2)
			ids_expense_transactions.setItem(ll_row, "disb_expenses_voyage_nr", ls_voyage )
		end if
	end if	
next



end subroutine

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: u_import_expenses
   <OBJECT> All logics for import expenses. </OBJECT>
   <DESC>  </DESC>
   <USAGE> When import an expense, this will work.</USAGE>
   <ALSO>   </ALSO>
	<HISTORY>
		Date   		Ref   		Author      Comments
		15/08/12 	CR2904      WWG004      Change the validation for import expenses records.
		23/08/12    CR2915      LGX001      Change the validation for import expenses records.
		03/09/2012	CR2857		WWG004		Restructing code
		07/09/12		CR2936		JMC112		Correct error. (solved in a fast way, not the perfect solution)
		02/06/14		CR3553		XSZ004		Check if the expenses exist in disburesement
		02/06/14		CR3424		XSZ004		Fix the error when modifying rejected rows
		05/06/14		CR3478		XSZ004		Allow to import expenses with different invoice number
		24/03/15		CR3854		XSZ004		Transfer to T/C-Hire when import/new expenses.
		29/06/15		CR4099		XSZ004		Fix UTC.	
		12-12-16		CR4420		XSZ004		Auto settle expenses.
	</HISTORY>
*********************************************************************************************************/
end subroutine

public function integer of_check_expenses ();/********************************************************************
   of_check_expenses
   <DESC> Check if there are exist in disbursements </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed         
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02/06/14		CR3553		XSZ004		First Version
		07/04/15		CR3854		XSZ004		Transfer to TC-Hire when import TC expenses.
   </HISTORY>
********************************************************************/

long   ll_agent_nr, ll_vessel_nr, ll_pcn, ll_voucher_nr, ll_contract_id, ll_insertrow 
long   ll_row, ll_findrow, ll_rowcount, ll_expenses_rowcount
string ls_invoice_nr, ls_port_code, ls_voyage_nr, ls_find, ls_reason, ls_disb_currency
int    li_settled, li_return, li_exp_for_oa

decimal  ld_amount_usd, ld_amount_local
datetime ldt_port_arr_date, ldt_cp_date

mt_n_datastore lds_temp_expenses

lds_temp_expenses = create mt_n_datastore
lds_temp_expenses.dataobject = "d_sq_gr_temp_expenses"
lds_temp_expenses.settransobject(sqlca)

for ll_row = 1 to ids_expense_transactions.rowcount()
	lds_temp_expenses.insertrow(ll_row)
	lds_temp_expenses.setitem(ll_row, "vessel_nr", ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_vessel_nr"))
	lds_temp_expenses.setitem(ll_row, "voyage_nr", ids_expense_transactions.getitemstring(ll_row, "disb_expenses_voyage_nr"))
	lds_temp_expenses.setitem(ll_row, "port_code", ids_expense_transactions.getitemstring(ll_row, "disb_expenses_port_code"))
	lds_temp_expenses.setitem(ll_row, "pcn", ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_pcn"))
	lds_temp_expenses.setitem(ll_row, "agent_nr", ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_agent_nr"))
	lds_temp_expenses.setitem(ll_row, "invoice_nr", ids_expense_transactions.getitemstring(ll_row, "disb_expenses_disb_invoice_nr"))
next

if lds_temp_expenses.update() = 1 then
	commit;
	li_return = c#return.success
	ll_rowcount = lds_temp_expenses.retrieve()
else
	rollback;
	li_return = c#return.failure
end if

if li_return = c#return.success then	
	ll_expenses_rowcount = ids_expense_transactions.rowcount()
	
	for ll_row = 1 to ll_rowcount
		ll_vessel_nr  = lds_temp_expenses.getitemnumber(ll_row, "vessel_nr")
		ls_voyage_nr  = lds_temp_expenses.getitemstring(ll_row, "voyage_nr")
		ls_port_code  = lds_temp_expenses.getitemstring(ll_row, "port_code")
		ll_pcn		  = lds_temp_expenses.getitemnumber(ll_row, "pcn")
		ll_agent_nr	  = lds_temp_expenses.getitemnumber(ll_row, "agent_nr")
		ls_invoice_nr = lds_temp_expenses.getitemstring(ll_row, "invoice_nr")
		
		ls_find    = " disb_expenses_vessel_nr = " +string(ll_vessel_nr) + " and disb_expenses_voyage_nr = '" + ls_voyage_nr + "' and " + &
		             " disb_expenses_port_code = '" + ls_port_code + "' " + "and disb_expenses_pcn = " +string(ll_pcn) + " and " + &
		             " disb_expenses_agent_nr = " + string(ll_agent_nr) +  " and isnull(reason)"
						 
		if trim(ls_invoice_nr) = "" or isnull(ls_invoice_nr) then
			ls_find = ls_find + " and (isnull(disb_expenses_disb_invoice_nr) or disb_expenses_disb_invoice_nr = '')"
		else
			ls_find = ls_find + " and disb_expenses_disb_invoice_nr = '" + ls_invoice_nr + "'"
		end if
		
		ll_findrow = ids_expense_transactions.find(ls_find, 1, ll_expenses_rowcount)
		
		if ll_findrow > 0 then
			li_settled = lds_temp_expenses.getitemnumber(ll_row, "settled")
			if li_settled = 1 then
				ids_expense_transactions.setitem(ll_findrow, "reason", "Settled")
			elseif li_settled = 0 then
				ids_expense_transactions.setitem(ll_findrow, "reason", "Duplicated")
			end if	
		end if
	next
	
	if ll_expenses_rowcount > 0 then
		
		for ll_row = 1 to ll_expenses_rowcount
			
			if not isnull(ids_expense_transactions.getitemstring(ll_row, "reason")) then continue
			
			ll_vessel_nr  = ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_vessel_nr")
			ls_voyage_nr  = ids_expense_transactions.getitemstring(ll_row, "disb_expenses_voyage_nr")
			ll_voucher_nr = ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_voucher_nr")
			ls_port_code  = ids_expense_transactions.getitemstring(ll_row, "disb_expenses_port_code")
			ll_pcn		  = ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_pcn")
			ll_agent_nr	  = ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_agent_nr")
			ls_invoice_nr = ids_expense_transactions.getitemstring(ll_row, "disb_expenses_disb_invoice_nr")
			
			ldt_port_arr_date = of_get_port_arr_date(ll_vessel_nr, ls_voyage_nr, ls_port_code, ll_pcn)
			ls_reason = of_check_tc_expenses(ll_vessel_nr, ls_voyage_nr, ll_voucher_nr, ldt_port_arr_date, li_exp_for_oa, ll_contract_id)
		
			if ls_reason = "No transfer" then
				ids_expense_transactions.setitem(ll_row, "disb_expenses_tc_port_exp_id", 0)
			elseif ls_reason <> "" then
				if ls_reason = "No New/Draft HS" then
					SELECT TC_HIRE_CP_DATE INTO :ldt_cp_date 
					FROM   NTC_TC_CONTRACT 
					WHERE  CONTRACT_ID = :ll_contract_id;
					ids_expense_transactions.setitem(ll_row, "cp_date", string(ldt_cp_date, "dd-mm-yy"))
				end if
				ids_expense_transactions.setitem(ll_row, "reason", ls_reason)
			else
				ld_amount_usd    = ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_exp_amount_usd")
				ld_amount_local  = ids_expense_transactions.getitemnumber(ll_row, "disb_expenses_exp_amount_local")
				ls_disb_currency = of_get_disb_currency(ll_vessel_nr, ls_voyage_nr, ls_port_code, ll_pcn, ll_agent_nr)
			
				ls_reason = of_insert_tc_expenses(ll_contract_id, li_exp_for_oa, ls_invoice_nr, ls_disb_currency, &
														 	ld_amount_usd, ld_amount_local, ls_port_code, ldt_port_arr_date, ll_insertrow)
				if ls_reason <> "" then
					ids_expense_transactions.setitem(ll_findrow, "reason", ls_reason)
				else
					ids_tc_expenses.setitem(ll_insertrow, "row_number", ll_row )
					ids_expense_transactions.setitem(ll_row, "row_number", ll_row)
				end if
			end if
		next
	end if	
	
	DELETE FROM TEMP_DISB_EXPENSES;
	if sqlca.sqlcode = 0 then
		commit;
	else
		rollback;
		li_return = c#return.failure
	end if
end if

destroy lds_temp_expenses
return  li_return
end function

public function datetime of_get_port_arr_date (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn);/********************************************************************
   of_get_port_arr_date
   <DESC> Get port arrive date </DESC>
   <RETURN>
		datetime
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		as_port_code
		ai_pcn
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		27/03/15		CR3854		XSZ004		First Version
		29/06/15		CR4099		XSZ004		Fix UTC.	
   </HISTORY>
********************************************************************/

datetime ldt_arr_date
int      li_count

setnull(ldt_arr_date)

SELECT count(*) INTO :li_count
FROM   POC, NTC_TC_CONTRACT 
WHERE  POC.VESSEL_NR = :al_vessel_nr and POC.VOYAGE_NR = :as_voyage_nr and 
       PCN = :ai_pcn and PORT_CODE = :as_port_code and PURPOSE_CODE = 'DEL' and
       POC.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID and NTC_TC_CONTRACT.LOCAL_TIME = 0;
		 
if li_count > 0 then
	
	SELECT dateadd(mi, LT_TO_UTC_DIFFERENCE*60, PORT_ARR_DT) INTO :ldt_arr_date
	FROM   POC 
	WHERE  VESSEL_NR = :al_vessel_nr and VOYAGE_NR = :as_voyage_nr and 
	       PCN = :ai_pcn and PORT_CODE = :as_port_code;
else		 
	SELECT PORT_ARR_DT INTO :ldt_arr_date
	FROM   POC 
	WHERE  VESSEL_NR = :al_vessel_nr and VOYAGE_NR = :as_voyage_nr and 
	       PCN = :ai_pcn and PORT_CODE = :as_port_code;
end if
		
return ldt_arr_date
end function

public function string of_check_tc_expenses (long al_vessel_nr, string as_voyage_nr, long al_voucher_nr, datetime adt_arr_date, ref integer ai_exp_for_oa, ref long al_contract_id);/********************************************************************
   of_check_tc_expenses
   <DESC> Check if the expenses can transfer to TC-Hire </DESC>
   <RETURN>	
		string
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		al_voucher_nr
		adt_arr_date
		ai_exp_for_oa
		al_contract_id
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		27/03/15		CR3854		XSZ004		First Version.
		29/06/15		CR4099		XSZ004		Fix UTC.	
   </HISTORY>
********************************************************************/

long    ll_tcin_contract_id, ll_tcout_contract_id, ll_contract_id
integer li_non_comm_handled, li_accounting_exp_type, li_ca_or_oa //0=no, 1=CA, 2=OA
integer li_counter, li_vessel_type, li_original_vessel_type      //used in special roles for IOM_SIN_VESSELS
integer li_TO_management, li_CREW_management                     //0 = Copenhagen, 1= 3rd party, 2 = Owner 
boolean lb_iom_sin_vessel, lb_brostrom_mt_vessel, lb_found_contract
boolean lb_TO_expense, lb_CREW_expense, lb_bareboat, lb_CPH_CREW_managed, lb_CPH_TO_managed
string  ls_reason, ls_tcout_voyage

mt_n_datastore         lds_voucher
u_iom_sin_vessel       luo_iom_sin_vessel
u_brostrom_mt_vessel   luo_brostrom_mt_vessel
u_transaction_expense  lnv_transaction_expense

lb_found_contract = true

lds_voucher = create mt_n_datastore

lds_voucher.dataobject = "dw_voucher"
lds_voucher.settransobject(sqlca)
lds_voucher.retrieve(al_voucher_nr)

if isnull(adt_arr_date) then
	if len(trim(as_voyage_nr)) > 5 then
		if lds_voucher.GetItemNumber(1, "tcout_ca_or_oa") = 1 or lds_voucher.GetItemNumber(1, "tcinout_ca_or_oa") = 1 then
			lb_found_contract = false
		end if
	else
		if lds_voucher.GetItemNumber(1, "tcin_ca_or_oa") = 2 then
			lb_found_contract = false
		end if
	end if
end if

if not lb_found_contract then
	ls_reason = "No TC link"
	destroy lds_voucher
	return ls_reason
end if

lnv_transaction_expense = create u_transaction_expense

lnv_transaction_expense.istr_trans_input.vessel_no = al_vessel_nr
lnv_transaction_expense.istr_trans_input.disb_port_arr_date = adt_arr_date

li_vessel_type = lnv_transaction_expense.of_vessel_tc_or_not()

if li_vessel_type > 1 then
	
	ll_tcin_contract_id     = lnv_transaction_expense.il_tcin
	ll_tcout_contract_id    = lnv_transaction_expense.il_tcout
	li_original_vessel_type = li_vessel_type
	
	if li_vessel_type = 2 then
		SELECT BAREBOAT    INTO :lb_bareboat FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_tcin_contract_id;
		SELECT THIRD_PARTY INTO :li_TO_management FROM NTC_BAREBOAT_MANAGEMENT WHERE MANAGEMENT_TYPE = 1 AND CONTRACT_ID = :ll_tcin_contract_id;
		SELECT THIRD_PARTY INTO :li_CREW_management FROM NTC_BAREBOAT_MANAGEMENT WHERE MANAGEMENT_TYPE = 2 AND CONTRACT_ID = :ll_tcin_contract_id;
	end if
	
	li_ca_or_oa = 0
	
	/* Get information to be able to find out if this vessel is on TC-IN and BAREBOAT Contract
		and where Technical Management or Crew Management is laid out to 3rd party.
		In this cases the accounting string elements come from TC-contract */
	
	li_accounting_exp_type = lds_voucher.getitemnumber(1, "accounting_expense_type")
	
	if li_accounting_exp_type = 1 then
		lb_TO_expense   = true
	elseif li_accounting_exp_type = 2 then
		lb_CREW_expense = true
	end if
	
	if li_vessel_type = 2 and lb_bareboat and &
		((lb_TO_expense and li_TO_management < 2) or (lb_CREW_expense and li_CREW_management < 2)) then
		li_ca_or_oa = 0 
	else
		
		luo_iom_sin_vessel     = CREATE u_iom_sin_vessel
		luo_brostrom_mt_vessel = CREATE u_brostrom_mt_vessel
		
		//If Vessel non apm commercially handled, then ignore iom-sin settings
		SELECT NON_APM_COMM_HANDLED INTO :li_non_comm_handled 
		FROM   VESSELS, PROFIT_C
		WHERE  VESSELS.PC_NR = PROFIT_C.PC_NR AND VESSELS.VESSEL_NR = :al_vessel_nr;
		
		IF li_non_comm_handled = 1 THEN	
			lb_iom_sin_vessel = false
		else
			// First find out if vessel in table IOM_SIN_VESSELS
			lb_iom_sin_vessel = luo_iom_sin_vessel.of_getVessel(al_vessel_nr)
		
			IF lb_iom_sin_vessel AND lb_TO_expense THEN
				//Set vessel type to APM vessel
				li_vessel_type = 1 
			ELSE
				li_vessel_type = li_original_vessel_type
			END IF
		end if
		
		CHOOSE CASE li_vessel_type
			CASE 1
				li_ca_or_oa = 0
			CASE 2
				li_ca_or_oa = lds_voucher.GetItemNumber(1, "tcin_ca_or_oa")
			CASE 3
				li_ca_or_oa = lds_voucher.GetItemNumber(1, "tcout_ca_or_oa")
			CASE 4
				li_ca_or_oa = lds_voucher.GetItemNumber(1, "tcinout_ca_or_oa")
		END CHOOSE
				
		IF lb_iom_sin_vessel AND lb_CREW_expense THEN  
			li_ca_or_oa = 0
		END IF	
		
		//First find out if vessel in table Broström MT vessel setup
		lb_brostrom_mt_vessel = luo_brostrom_mt_vessel.of_vesselExists(al_vessel_nr)
		
		IF lb_brostrom_mt_vessel AND (lb_CREW_expense or lb_TO_expense)THEN   
			li_ca_or_oa = 0
		END IF
		
		/* Find out is T.O. or Crew is managed by Copenhagen
			if yes, use the APM accountring string from voucher*/
			
		if lb_CREW_expense or lb_TO_expense then
			
			SELECT VESSEL_CPH_CREW_MANAGED, VESSEL_CPH_TO_MANAGED INTO :lb_CPH_CREW_managed, :lb_CPH_TO_managed
			FROM   VESSELS
			WHERE  VESSELS.VESSEL_NR = :al_vessel_nr;
			
			if (lb_CREW_expense and lb_CPH_CREW_managed) or (lb_TO_expense and lb_CPH_TO_managed) then
				li_ca_or_oa = 0
			end if
		end if
		
		destroy u_iom_sin_vessel
		destroy u_brostrom_mt_vessel
	end if
	
	choose case li_ca_or_oa
		case 1
			if (li_vessel_type = 3 or li_vessel_type = 4) and len(trim(as_voyage_nr)) > 5 then		
				ll_contract_id = ll_tcout_contract_id	
				ai_exp_for_oa  = 0
			end if
		case 2
			if li_vessel_type = 2 or li_vessel_type = 4 then		
				ll_contract_id = ll_tcin_contract_id
				ai_exp_for_oa  = 1
			end if
		case else
			ll_contract_id = 0
	end choose
	
	if ll_contract_id > 0 then
		
		al_contract_id = ll_contract_id
		
		SELECT COUNT(*) INTO :li_counter 
		FROM   POC, NTC_TC_CONTRACT
		WHERE  PURPOSE_CODE = 'DEL' AND NTC_TC_CONTRACT.CONTRACT_ID = POC.CONTRACT_ID AND
		       POC.VESSEL_NR = :al_vessel_nr AND NTC_TC_CONTRACT.CONTRACT_ID = :ll_contract_id;
		
		if li_counter > 0 then
			if li_ca_or_oa = 1 then
				
				SELECT ISNULL(TCOUT_VOYAGE_NR, '') INTO :ls_tcout_voyage
				FROM   NTC_TC_PERIOD, NTC_TC_CONTRACT
				WHERE  NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID AND NTC_TC_CONTRACT.CONTRACT_ID = :ll_contract_id AND
						 NTC_TC_PERIOD.PERIODE_START <= :adt_arr_date AND NTC_TC_PERIOD.PERIODE_END >= :adt_arr_date AND
						 NTC_TC_CONTRACT.VESSEL_NR = :al_vessel_nr;
					
				if trim(ls_tcout_voyage) <> "" and trim(ls_tcout_voyage) <> left(as_voyage_nr, 5) then
					ls_reason = "No TC link"
				end if
			end if	
		else
			ls_reason = "No TC link"
		end if
		
		if ls_reason = "" then
			
			SELECT COUNT(*) INTO :li_counter 
			FROM   NTC_PAYMENT
			WHERE  NTC_PAYMENT.CONTRACT_ID = :ll_contract_id AND PAYMENT_STATUS < 3;
			
			if li_counter < 1 then
				ls_reason = "No New/Draft HS"
			end if
		end if
	else
		ls_reason = "No transfer"
	end if
else
	ls_reason = "No transfer"
end if

destroy lnv_transaction_expense
destroy lds_voucher

return ls_reason
end function

public function string of_get_disb_currency (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn, integer ai_agent_nr);/********************************************************************
   of_get_disb_currency
   <DESC> Get disbursement currency </DESC>
   <RETURN>
		string
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		as_port_code
		ai_pcn
		ai_agent_nr
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		03/04/15		CR3854		XSZ004		First Version
   </HISTORY>
********************************************************************/

string ls_find, ls_disb_currency
long   ll_found

ls_find = "agent_nr = " + string(ai_agent_nr) + " and port_code = '" + as_port_code + &
			 "' and vessel_nr = " + string(al_vessel_nr) + &
          " and voyage_nr = '" + as_voyage_nr + "' and pcn = " + string(ai_pcn)
			 
ll_found = ids_disbursement_transactions.Find(ls_find, 1, ids_disbursement_transactions.RowCount())

if ll_found > 0 then
	ls_disb_currency = ids_disbursement_transactions.getitemstring(ll_found, "disbursement_currency")
else
	SELECT DISBURSEMENT_CURRENCY INTO :ls_disb_currency 
	FROM   DISBURSEMENTS 
	WHERE  VESSEL_NR = :al_vessel_nr AND VOYAGE_NR = :as_voyage_nr AND 
	       PORT_CODE = :as_port_code AND AGENT_NR = :ai_agent_nr AND PCN = :ai_pcn;
end if

return ls_disb_currency
end function

public function integer of_save_tc_expenses ();/********************************************************************
   of_save_tc_expenses
   <DESC> Update TC-Hire expenses and update payment balance </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed         
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		03/04/14		CR3854		XSZ004		First Version
   </HISTORY>
********************************************************************/

long   ll_previous_id, ll_current_id, ll_count, ll_row
int    li_return = c#return.success
string ls_mysql, ls_error

if ids_tc_expenses.Update(TRUE, FALSE) = 1 then
	
	ll_count       = ids_tc_expenses.rowCount()
   ll_previous_id = 0
	
	for ll_row = 1 to ll_count		
		ll_current_id     = ids_tc_expenses.getItemNumber(ll_row, "payment_id")	
		if ll_previous_id = ll_current_id then continue
		
		ls_mysql = "sp_paymentBalance " + string(ll_current_id)
		
		EXECUTE IMMEDIATE :ls_mysql;//Update payment balance.
		
		if sqlca.sqlcode <> 0 then
			ls_error = "Update aborted, because update payment balance failed.~r~nSQLErrText: " + sqlca.SQLErrText
			li_return = c#return.failure
			exit
		end if	
		ll_previous_id = ll_current_id
	next
else
	ls_error  = "Update aborted, because update TC-Hire expenses failed.~r~nSQLErrText: " + sqlca.SQLErrText
	li_return = c#return.failure
end if

if li_return = c#return.success then	
	//commit; No commit as part of LUW.
else
	rollback;
	MessageBox("Error", ls_error)
end if

return li_return
end function

public subroutine of_set_tc_expenses_id ();/********************************************************************
   of_set_expenses_id
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

ll_rowcount = ids_tc_expenses.rowcount()

if ll_rowcount > 0 then
	
	for ll_row = 1 to ll_rowcount
		
		ll_row_number = ids_tc_expenses.getitemnumber(ll_row, "row_number")
		ll_findrow = ids_expense_transactions.find("row_number = " + string(ll_row_number), 1, ids_expense_transactions.rowcount())
		
		if ll_findrow > 0 then
			ll_port_exp_id = ids_tc_expenses.getitemnumber(ll_row, "port_exp_id")
			ids_expense_transactions.setitem(ll_findrow, "disb_expenses_tc_port_exp_id", ll_port_exp_id)
		end if
	next
end if
end subroutine

public function string of_insert_tc_expenses (long al_contract_id, integer ai_exp_for_oa, string as_invoice_nr, string as_disb_currency, decimal ad_amount_usd, decimal ad_amount_local, string as_port_code, datetime adt_arr_date, ref long al_insertrow);/********************************************************************
   of_insert_tc_expenses
   <DESC> Insert data to TC expenses datastore </DESC>
   <RETURN>
		string
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_contract_id
		ai_exp_for_oa
		as_invoice_nr
		as_disb_currency
		ad_amount_local
		as_port_code
		adt_arr_date
		al_insertrow
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02/04/15		CR3854		XSZ004		First Version
   </HISTORY>
********************************************************************/

long    ll_payment_id, ll_insertrow
string  ls_tc_currency, ls_exp_desc, ls_reason, ls_port_name
integer li_exp_for_oa

decimal{6} ld_exrate_tc, ld_exrate_disb, ld_exrate_exp
decimal{2} ld_exp_amount

n_exchangerate lnv_exchangerate
n_tc_payment   lnv_payment

lnv_payment   = create n_tc_payment
ll_payment_id = lnv_payment.of_get_Firstnewordraft(al_contract_id)

IF ll_payment_id = -1 THEN
	ls_reason = "No New/Draft HS"
else
		
	SELECT NTC_TC_CONTRACT.CURR_CODE INTO :ls_tc_currency  
	FROM   NTC_TC_CONTRACT  
	WHERE  NTC_TC_CONTRACT.CONTRACT_ID = :al_contract_id;
	
	if as_disb_currency = ls_tc_currency then
		ld_exrate_exp = 100
	elseif ls_tc_currency = "USD" then
		ld_exrate_exp = (ad_amount_usd/ad_amount_local)*100
	else
		
		ld_exrate_tc = lnv_exchangerate.of_gettodaysdkkrate(ls_tc_currency)
		ld_exrate_disb = lnv_exchangerate.of_gettodaysdkkrate(as_disb_currency)
		
		if ld_exrate_tc <= 0 or ld_exrate_disb <= 0 then
			ls_reason = "No exchange rate"
		else
			ld_exrate_exp = ( ld_exrate_disb / ld_exrate_tc ) * 100
		end if
	end if
	
	if ls_reason = "" then
		ll_insertrow = ids_tc_expenses.InsertRow(0)
		
		SELECT PORT_N INTO :ls_port_name 
		FROM   PORTS 
		WHERE  PORT_CODE = :as_port_code;
		
		ls_exp_desc   = ls_port_name + " - " + String(adt_arr_date, "dd-mmm-yy")
		
		ids_tc_expenses.SetItem(ll_insertrow, "payment_id", ll_payment_id)
		ids_tc_expenses.SetItem(ll_insertrow, "curr_code", as_disb_currency)	
		ids_tc_expenses.SetItem(ll_insertrow, "exp_desc", ls_exp_desc)
		ids_tc_expenses.setItem(ll_insertrow, "disb_invoice_nr", as_invoice_nr)		
		ids_tc_expenses.SetItem(ll_insertrow, "ex_rate_tc", ld_exrate_exp)
		ids_tc_expenses.SetItem(ll_insertrow, "exp_amount", ad_amount_local)
		ids_tc_expenses.SetItem(ll_insertrow, "exp_for_oa", ai_exp_for_oa)
		ids_tc_expenses.setitem(ll_insertrow, "new_flag", 1)
		
		al_insertrow = ll_insertrow
	end if
end if
	
destroy lnv_payment

return ls_reason
end function

public function integer of_settle_expenses ();/********************************************************************
   of_settle_expenses
   <DESC> Settle expenses </DESC>
   <RETURN>	
		integer
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02-12-16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_ret, li_not_use, li_disb_count, li_exp_count, li_cnt, li_findrow
int li_vesselnr, li_pcn, li_agentnr
string ls_voyagenr, ls_portcode, ls_findstr, ls_msg

mt_n_datastore lds_unsettle_disb
n_settle_expenses lnv_settle_exp

lds_unsettle_disb = create mt_n_datastore
lds_unsettle_disb.dataobject = "d_unsettled_agents"
lds_unsettle_disb.settransobject(sqlca)
lds_unsettle_disb.retrieve()

li_exp_count  = ids_expense_transactions.rowcount()
li_disb_count = lds_unsettle_disb.rowcount()

for li_cnt = 1 to li_disb_count
	li_vesselnr = lds_unsettle_disb.GetItemNumber(li_cnt, "disbursements_vessel_nr")
	ls_voyagenr = lds_unsettle_disb.GetItemString(li_cnt, "voyage_nr")
	ls_portcode  = lds_unsettle_disb.GetItemString(li_cnt, "port_code")
	li_pcn       = lds_unsettle_disb.GetItemNumber(li_cnt, "pcn")
	li_agentnr  = lds_unsettle_disb.getitemnumber(li_cnt, "disbursements_agent_nr")
	
	ls_findstr = "disb_expenses_vessel_nr = " + string(li_vesselnr) + " and disb_expenses_voyage_nr = '" + ls_voyagenr + "' " + &
				    " and disb_expenses_port_code = '" + ls_portcode + "' and disb_expenses_pcn = " + string(li_pcn) + &
					 " and disb_expenses_agent_nr = " + string(li_agentnr) + "and isnull(reason)"
	
	li_findrow = ids_expense_transactions.find(ls_findstr, 1, li_exp_count)
	
	if li_findrow > 0 then
		lds_unsettle_disb.setitem(li_cnt, "selected", "Yes")
	end if
next

lnv_settle_exp = create n_settle_expenses

lnv_settle_exp.of_settle_expenses(lds_unsettle_disb, li_not_use, false)

li_findrow = lds_unsettle_disb.find("reason <> ''", 1, li_disb_count)

if li_findrow > 0 then
	ls_msg = "The selected disbursement expenses have been imported but some were not settled.~n~n" + &
			   "Do you want to open the Unsettled Agents report to review these expenses?"
				
	li_ret = messagebox("Disbursements not settled", ls_msg,  Question!, YesNo!, 1)
	
	if li_ret = 1 then
		if isvalid(w_unsettled_agents) then
			w_unsettled_agents.cb_refresh.event clicked()
			w_unsettled_agents.bringtotop = true
		else
			opensheet(w_unsettled_agents, w_tramos_main, 0, Original!)
		end if
	end if
	
	li_ret = c#return.failure
end if

destroy lds_unsettle_disb
destroy lnv_settle_exp

return li_ret
end function

on u_import_expenses.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_import_expenses.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
Destroy ids_expense_transactions
Destroy ids_rejected_transactions
Destroy ids_disbursement_transactions
Destroy ids_temporary_accepted
Destroy ids_temporary_rejected
Destroy ids_vessel_list
Destroy ids_tc_expenses
end event

event constructor;
ids_disbursement_transactions = CREATE datastore
ids_disbursement_transactions.DataObject = "d_disbursement_transactions"
ids_disbursement_transactions.SetTransObject(SQLCA)

ids_expense_transactions = CREATE datastore
ids_expense_transactions.DataObject = "d_expense_transactions"
ids_expense_transactions.SetTransObject(SQLCA)

ids_rejected_transactions = CREATE datastore
ids_rejected_transactions.DataObject = "d_rejected_transactions"
ids_rejected_transactions.SetTransObject(SQLCA)

ids_temporary_accepted = CREATE datastore
ids_temporary_accepted.DataObject = "d_expense_transactions"
ids_temporary_accepted.SetTransObject(SQLCA)

ids_temporary_rejected = CREATE datastore
ids_temporary_rejected.DataObject = "d_rejected_transactions"
ids_temporary_rejected.SetTransObject(SQLCA)

ids_vessel_list = CREATE datastore
ids_vessel_list.DataObject = "d_sq_tb_find_vessel_nr"
ids_vessel_list.SetTransObject(SQLCA)

ids_tc_expenses = CREATE mt_n_datastore
ids_tc_expenses.DataObject = "d_disb_to_tc_port_exp"
ids_tc_expenses.SetTransObject(SQLCA)








end event

