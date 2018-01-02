$PBExportHeader$u_transaction_expense.sru
$PBExportComments$Inherited from u_transaction . Generates expense transaction
forward
global type u_transaction_expense from u_transaction
end type
end forward

global type u_transaction_expense from u_transaction
end type
global u_transaction_expense u_transaction_expense

type variables
decimal {0} id_amount_local
decimal {0} id_amount_usd
decimal {0} id_amount_dkk
decimal {0} id_sum_amount_local = 0
decimal {0} id_sum_amount_usd = 0
decimal {0} id_sum_amount_dkk = 0
decimal {0} id_handling_commission_local = 0        /* accumulates handling commission */
decimal {0} id_handling_commission_USD = 0
decimal {0} id_handling_commission_DKK = 0
string      is_handling_commission_owner_snr  /* Headovners S# */

datastore ids_disb_expenses

n_ds ids_apost_array[], ids_bpost_array[]

//datetime idt_tcin, idt_tcout
long	il_tcin, il_tcout


end variables

forward prototypes
public function integer of_vessel_tc_or_not ()
public function integer of_fill_transaction ()
public function integer of_handling_commission ()
public function integer of_fill_bpost (integer ai_vessel_type)
public subroutine documentation ()
private function integer of_createbpost (string as_companycode)
private function integer of_extrapostdefaultcompanycode ()
public function integer of_save ()
public subroutine of_reset_data ()
end prototypes

public function integer of_vessel_tc_or_not ();//////////////////////////////////////////////////////////////////////////
//
//   This function find out if if a vessel is APM, TCin, TCout or TCinout
//		and sets relevant cp_dates (idt_tcin, idt_tcout)
//
//		Argument:	none
//
//		Return:	  -1 - Error
//						1 - APM
//						2 - TCin
//						3 - TCout
//						4 - TCinout
//
//////////////////////////////////////////////////////////////////////////

Integer li_internal_tc 
long ll_rows
datastore lds_check_if_tc_vessel

li_internal_tc = 0

lds_check_if_tc_vessel = CREATE datastore
lds_check_if_tc_vessel.DataObject = "d_check_if_tc_vessel"
lds_check_if_tc_vessel.SetTransObject(SQLCA)
ll_rows = lds_check_if_tc_vessel.Retrieve(istr_trans_input.vessel_no, istr_trans_input.disb_port_arr_date)
COMMIT;
CHOOSE CASE ll_rows
	CASE -1	/* Error */
		setNull(il_tcin)
		setNull(il_tcout)
		DESTROY lds_check_if_tc_vessel
		of_messagebox("Retrieval error", "Error retrieving TCHire. Object: u_transaction_expense, Function: of_vessel_tc_or_not")
		Return(-1)
	CASE 0	/* APM */
		setNull(il_tcin)
		setNull(il_tcout)
		DESTROY lds_check_if_tc_vessel
		Return(1)
	CASE 1	/* TCin or TCout */		
		//////////////////////////////////////////Checks if Internal TC///////////////
		IF lds_check_if_tc_vessel.GetItemNumber(1, "internal_tc") = 1 THEN
			setNull(il_tcin)
			setNull(il_tcout)
			DESTROY lds_check_if_tc_vessel
			Return(1)
		END IF		
		//////////////////////////////////////////
		IF lds_check_if_tc_vessel.GetItemNumber(1, "tc_hire_in") = 1 THEN
			il_tcin = lds_check_if_tc_vessel.GetItemNumber(1, "contract_id")
			setNull(il_tcout)
			DESTROY lds_check_if_tc_vessel
			Return(2)
		ELSE
			setNull(il_tcin)
			il_tcout = lds_check_if_tc_vessel.GetItemNumber(1, "contract_id")
			DESTROY lds_check_if_tc_vessel
			Return(3)
		END IF
	CASE IS > 1	/* TCinout or error */
		/* find first tcin record */
		lds_check_if_tc_vessel.SetFilter("tc_hire_in = 1")
		lds_check_if_tc_vessel.Filter()
		IF lds_check_if_tc_vessel.RowCount() > 0 THEN
			il_tcin = lds_check_if_tc_vessel.GetItemNumber(1, "contract_id")
			li_internal_tc = lds_check_if_tc_vessel.GetItemNumber(1, "internal_tc")
		ELSE
			setNull(il_tcin)
			setNull(il_tcout)
			DESTROY lds_check_if_tc_vessel
			of_messagebox("TC Hire Error", "There are more than one TC-Hire-out rate periode defined, but no periode for TC-Hire-in Object: u_transaction_expense, Function: of_vessel_tc_or_not")
			Return(-1)
		END IF
		/* find first tcout record */
		lds_check_if_tc_vessel.SetFilter("tc_hire_in = 0")
		lds_check_if_tc_vessel.Filter()
		IF lds_check_if_tc_vessel.RowCount() > 0 THEN
			il_tcout = lds_check_if_tc_vessel.GetItemNumber(1, "contract_id")
		ELSE
			setNull(il_tcin)
			setNull(il_tcout)
			DESTROY lds_check_if_tc_vessel
			of_messagebox("TC Hire Error", "There are more than one TC-Hire-in rate periode defined, but no periode for TC-Hire-out Object: u_transaction_expense, Function: of_vessel_tc_or_not")
			Return(-1)
		END IF
		////////////////////////////////////Checks if Internal TC///////////////
		lds_check_if_tc_vessel.SetFilter("")
		lds_check_if_tc_vessel.Filter()
		IF lds_check_if_tc_vessel.GetItemNumber(lds_check_if_tc_vessel.rowcount(), "internal_tc") = 1 THEN
			setNull(il_tcin)
			setNull(il_tcout)
			DESTROY lds_check_if_tc_vessel
			Return(1)
		ELSEIF li_internal_tc = 1 THEN
			setNull(il_tcin)
			DESTROY lds_check_if_tc_vessel
			Return(3)
		END IF	
		///////////////////////////////////
		DESTROY lds_check_if_tc_vessel
		Return(4)
END CHOOSE

/* If code comes here there is an error */
DESTROY lds_check_if_tc_vessel
Return(-1)
end function

public function integer of_fill_transaction (); /********************************************************************
   of_fill_transaction
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		18/08/14		CR3698		XSZ004		Modify error message.
		10/04/15		CR3854		XSZ004		Remove the functionality of expenses transfer to TC-Hire when settle in disbursement.
   </HISTORY>
********************************************************************/

boolean  lb_own_agent = FALSE
string   ls_agent_nom_account, ls_agent_sn, ls_century, ls_yr
string   ls_vessel_ref_nr
integer  li_mth, li_non_comm_handled //li_preFunding = 0
long     ll_counter, ll_currentID, ll_oldID, ll_expenses
string   ls_mySQL, ls_f23, ls_coda_el4
u_port   luo_port
u_vessel luo_vessel

s_batch_input          lstr_batch_input
s_w_print_disb_account lstr_settle_window

//In order to solve the task that some expenses can generate transactions for more than one company 
ids_apost_array[1].object.data[1,1,1,56] = ids_apost.object.data[1,1,1,56]
ids_apost = ids_apost_array[1]

//SET KEYS FOR QUERY PURPOSE
IF ids_apost.SetItem(1,"trans_type","DisbExp") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_expense, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.agent_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_expense, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.pcn) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_expense, &
									function: of_fill_transaction")
	Return(-1)
END IF

//Get agent information .
u_agent luo_agent
luo_agent = CREATE u_agent

IF luo_agent.of_getAgent(istr_trans_input.agent_no) <> 1 THEN
	of_messagebox("Get value error", "Cant get agent information. Object: u_transaction_expense, function: of_fill_transaction")
	DESTROY luo_agent
	Return(-1)
END IF

lb_own_agent = luo_agent.of_own()
ls_agent_nom_account = luo_agent.of_getNominalAccount()
lstr_settle_window.agent_name = luo_agent.of_getShortName()

DESTROY luo_agent

IF LEN(ls_agent_nom_account) < 3 OR LEN(ls_agent_nom_account) > 5 THEN
	if ls_agent_nom_account = "" then 
		ls_agent_nom_account = "missing"
	end if
	
	of_messagebox("Error", "Agent with short name: " + lstr_settle_window.agent_name + " has an invalid nominal account number: " + ls_agent_nom_account + ".")
	Return(-1)
END IF

//Set field no. 6  DocCode.
IF ids_apost.SetItem(1, "f06_doccode", ids_default_values.GetItemString(1, "doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Find out if expenses have to be settled as Batch
   and get/set Field 9 (Docdate) - Field 21 (Vouchernr) and Field 22 (Controlnr) */
IF lb_own_agent THEN
	open(w_batch_input)
	lstr_batch_input = Message.PowerObjectParm
	IF IsNull(lstr_batch_input.voucher_no) AND IsNull(lstr_batch_input.control_no) AND IsNull(lstr_batch_input.docdate) THEN
		Return(-1)
	END IF
	
	//Set field no. 9 DocDate.
	IF ids_apost.SetItem(1, "f09_docdate", lstr_batch_input.docdate) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 09 (Docdate) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
	
	//Set field no. 21 Voucher no.
	IF ids_apost.SetItem(1, "f21_vouchernr", lstr_batch_input.voucher_no) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 21 (Voucher No.) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
	
	//Set field no. 22 Control no.
	IF ids_apost.SetItem(1, "f22_controlnr", lstr_batch_input.control_no) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 22 (Control No.) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	//Set field no. 9 DocDate.
	IF ids_apost.SetItem(1, "f09_docdate", datetime(today(), now())) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 09 (Docdate) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
	
	//Set field no. 21 Voucher no.
	IF ids_apost.SetItem(1, "f21_vouchernr", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 21 (Voucher No.) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
	
	//Set field no. 22 Control no.
	IF ids_apost.SetItem(1, "f22_controlnr", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 22 (Control No.) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

//Set field no. 11  Activity Periode.
IF ids_apost.SetItem(1, "f11_el1", string(today(), "yyyymm")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 13  General Ledger Account
IF lb_own_agent THEN
	IF ids_apost.SetItem(1, "f13_el3", ids_default_values.GetItemString(1, "own_agent_pay_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Own) (Element 3) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f13_el3", ids_default_values.GetItemString(1, "foreign_agent_rec_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Foreign) (Element 3) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

//Set field no. 14  Nominal Account.
SELECT NON_APM_COMM_HANDLED, CODA_EL4 INTO :li_non_comm_handled, :ls_coda_el4
FROM   VESSELS, PROFIT_C
WHERE  VESSELS.PC_NR =  PROFIT_C.PC_NR AND VESSELS.VESSEL_NR = :istr_trans_input.vessel_no ;

//If Vessel non apm commercially handled, then el4= CODA el4 defined by profit center.
if li_non_comm_handled=1 then
	IF ids_apost.SetItem(1, "f14_el4", ls_coda_el4 ) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
else
	IF lb_own_agent THEN
		IF ids_apost.SetItem(1, "f14_el4", ids_default_values.GetItemString(1, "prefix_supplier_own") + ls_agent_nom_account ) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Own) (Element 4) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
			Return(-1)
		END IF
	ELSE
		IF ids_apost.SetItem(1, "f14_el4", ids_default_values.GetItemString(1, "prefix_supplier_foreign") + ls_agent_nom_account ) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Foreign) (Element 4) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
			Return(-1)
		END IF
	END IF
end if


//Set field no. 15  Vessel, Department or Agent.
IF lb_own_agent THEN
	IF ids_apost.SetItem(1, "f15_el5", ids_default_values.GetItemString(1, "batch_vessel_nr")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 15 (Own) (Element 5) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	SELECT VESSEL_REF_NR 
		INTO :ls_vessel_ref_nr 
		FROM VESSELS 
		WHERE VESSEL_NR = :istr_trans_input.vessel_no;
	IF SQLCA.SQLCode = 0 THEN
		COMMIT;
	ELSE
		of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_expenses, function: of_fill_transaction")
		Return(-1)
	END IF
	
	IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

//Set field no. 16  Voyage.
IF lb_own_agent THEN
	IF ids_apost.SetItem(1, "f16_el6", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (Own) (Element 6) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f16_el6", ids_default_values.GetItemString(1, "prefix_voyage") + left(istr_trans_input.voyage_no,5)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

//Set field no. 17  PortCode.
IF lb_own_agent THEN
	IF ids_apost.SetItem(1, "f17_el7", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (Own) (Element 7) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f17_el7", ids_default_values.GetItemString(1, "prefix_port") + istr_trans_input.port) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF	

//Set field no. 19  Supplier identification (always blank)
IF ids_apost.SetItem(1, "f19_custsupp", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 20  (When TC-OUT voyage voyage_nr else blank).
IF len(trim(istr_trans_input.voyage_no)) > 5 THEN
	IF ids_apost.SetItem(1, "f20_invoicenr", ids_default_values.GetItemString(1, "prefix_voyage") + left(istr_trans_input.voyage_no,5)+"-"+mid(istr_trans_input.voyage_no,6,2)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 20 (Invoice No.) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

//Set field no. 23  APM Supplier - same as nominal account.
IF lb_own_agent THEN
	ls_f23 = ids_default_values.GetItemString(1, "prefix_supplier_own") + ls_agent_nom_account 
else
	ls_f23 =  ids_default_values.GetItemString(1, "prefix_supplier_foreign") + ls_agent_nom_account 
end if

IF ids_apost.SetItem(1, "f23_paytype_or_sup", ls_f23) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 23 (APM Supplier) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 28  Currency Code.
IF ids_apost.SetItem(1, "f28_curdoc", istr_trans_input.disb_currency_code) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 28 (CurDoc) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 41  Linedescr. 
IF ids_apost.SetItem(1, "f41_linedesr", ids_default_values.GetItemString(1, "default_comments")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Find vessel is APM, TCin, TCout, TCinout or Error 
   Function call returning values 1, 2, 3, 4 or -1 */
	
integer li_vessel_type

li_vessel_type = of_vessel_tc_or_not()

IF li_vessel_type = -1 THEN
	Return(-1)
END IF

//Run all B-posterne igennem for driftskontering Kald funktion der opsummerer 
IF of_fill_bpost(li_vessel_type) = -1 THEN
	Return(-1)
END IF

//Post handling commission
if id_handling_commission_local <> 0 then
	if of_handling_commission() = -1 then
		return -1
	end if
end if

//HUSK AT INDSÆTTE BELØB EFTER BPOSTERNE ER OPDATERET                                                                                    */

// Set field no. 29 (DebitCredit)
IF id_sum_amount_local < 0 THEN
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_apost.SetItem(1, "f30_valuedoc", abs(id_sum_amount_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_apost.SetItem(1, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
IF ids_apost.SetItem(1, "f32_valuehome", abs(id_sum_amount_dkk)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_apost.SetItem(1, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
IF ids_apost.SetItem(1, "f34_vatamo_or_valdual", abs(id_sum_amount_usd)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_apost.SetItem(1, "f35_vattyp_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for A-post. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

/* Get values to fill window (w_print_disbursement_account) */
luo_port = CREATE u_port
IF luo_port.of_getPort(istr_trans_input.port) <> 1 THEN
	of_messagebox("Get value error", "Cant get port information. Object: u_transaction_expense, function: of_fill_transaction")
	DESTROY luo_port
	Return(-1)
END IF

lstr_settle_window.port_name = luo_port.of_getPortName()

DESTROY luo_port

luo_vessel = CREATE u_vessel
IF luo_vessel.of_getVessel(istr_trans_input.vessel_no) <> 1 THEN
	of_messagebox("Get value error", "Cant get Vessel information. Object: u_transaction_expense, function: of_fill_transaction")
	DESTROY luo_vessel
	Return(-1)
END IF

lstr_settle_window.vessel_name = luo_vessel.of_getVesselName()
lstr_settle_window.vessel_ref_nr = luo_vessel.of_getVesselRefNr()

DESTROY luo_vessel

lstr_settle_window.vessel_nr = istr_trans_input.vessel_no
lstr_settle_window.voyage_nr = istr_trans_input.voyage_no
lstr_settle_window.port_code = istr_trans_input.port
lstr_settle_window.pcn = istr_trans_input.pcn
lstr_settle_window.agent_no = istr_trans_input.agent_no

//Verify that settling is OK
if istr_trans_input.b_showmsg then
	OpenWithParm(w_print_disbursement_account, lstr_settle_window)
	
	IF message.DoubleParm <> 1 THEN
		Return(-1)
	END IF
end if

//Update expenses + transfer to TC Hire.
ids_disb_expenses.AcceptText()
IF ids_disb_expenses.Update() = -1 THEN
	Rollback;
	of_messagebox("Update Error", "Cant update disbursement expenses. Object: u_transaction_expense, function: of_fill_transaction")
	Return(-1)
END IF

Return(1)
end function

public function integer of_handling_commission ();/* This function is for posting handling commission */

long 		ll_brow 
string	ls_department_code
string	ls_null
setNull(ls_null)

/* insert debit b-post */
ll_brow = ids_bpost.insertRow(0)
ids_bpost.object.data[ll_brow, 1, ll_brow, 25] = ids_bpost.object.data[1,1,1,25]
ids_bpost.setItem(ll_brow, "f08_doclinenum_b", ll_brow + 1)
ids_bpost.setItem(ll_brow, "f11_el1_b", ids_apost.getItemString(1, "f11_el1"))
ids_bpost.setItem(ll_brow, "f13_el3_b", ids_apost.getItemString(1, "f13_el3"))
ids_bpost.setItem(ll_brow, "f14_el4_b", is_handling_commission_owner_snr)
ids_bpost.setItem(ll_brow, "f15_el5_b", ids_apost.getItemString(1, "f15_el5"))
ids_bpost.setItem(ll_brow, "f16_el6_b", ids_apost.getItemString(1, "f16_el6"))
ids_bpost.setItem(ll_brow, "f17_el7_b", ids_apost.getItemString(1, "f17_el7"))
if id_handling_commission_local >= 0 then
	ids_bpost.setItem(ll_brow, "f29_debitcredit", 161)
else
	ids_bpost.setItem(ll_brow, "f29_debitcredit", 160)
end if
ids_bpost.setItem(ll_brow, "f30_valuedoc", abs(id_handling_commission_local))
ids_bpost.setItem(ll_brow, "f32_valuehome", abs(id_handling_commission_DKK))
ids_bpost.setItem(ll_brow, "f34_vatamo_or_valdual", abs(id_handling_commission_USD))
ids_bpost.setItem(ll_brow, "f41_linedesr", "Handle Comm. "+ids_apost.getItemString(1, "f15_el5"))
ids_bpost.setItem(ll_brow, "resp_comp_or_dept", ls_null)

/* insert credit b-post */
ll_brow = ids_bpost.insertRow(0)
ids_bpost.object.data[ll_brow, 1, ll_brow, 25] = ids_bpost.object.data[1,1,1,25]
ids_bpost.setItem(ll_brow, "f08_doclinenum_b", ll_brow + 1)
ids_bpost.setItem(ll_brow, "f13_el3_b", "015")
ids_bpost.setItem(ll_brow, "f14_el4_b", "17350")
SELECT PROFIT_C.PC_DEPT_CODE  
	INTO :ls_department_code  
   FROM PROFIT_C, VESSELS  
   WHERE VESSELS.PC_NR = PROFIT_C.PC_NR and  
         VESSELS.VESSEL_NR = :istr_trans_input.vessel_no ;
ids_bpost.setItem(ll_brow, "f15_el5_b", ls_department_code)
ids_bpost.setItem(ll_brow, "f16_el6_b", ls_null)
ids_bpost.setItem(ll_brow, "f17_el7_b", ls_null)
if id_handling_commission_local >= 0 then
	ids_bpost.setItem(ll_brow, "f29_debitcredit", 160)
else
	ids_bpost.setItem(ll_brow, "f29_debitcredit", 161)
end if
ids_bpost.setItem(ll_brow, "f30_valuedoc", abs(id_handling_commission_local))
ids_bpost.setItem(ll_brow, "f32_valuehome", abs(id_handling_commission_DKK))
ids_bpost.setItem(ll_brow, "f34_vatamo_or_valdual", abs(id_handling_commission_USD))
ids_bpost.setItem(ll_brow, "f41_linedesr", "Handle Comm. "+ids_apost.getItemString(1, "f15_el5"))
ids_bpost.setItem(ll_brow, "resp_comp_or_dept", ls_null)

return 1


end function

public function integer of_fill_bpost (integer ai_vessel_type); /********************************************************************
   of_fill_bpost
   <DESC>	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS> ai_vessel_type 1 = APM, 2 = TCin, 3 = TCout, 4 = TCinout
	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		10/04/15		CR3854		XSZ004		Remove the functionality of expenses transfer to TC-Hire when settle in disbursement.
   </HISTORY>
********************************************************************/

string  ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept , ls_century, ls_string, ls_temp_string
string  ls_vessel_ref_nr, ls_port_name, ls_tc_currency, ls_disb_currency
string  ls_Profitcenter_CODA_EL4, ls_profitcenter_CMS_EL4
string  ls_voucher_name, ls_illegal_message  //holds an explanation for the illegal combination
integer li_ca_or_oa                          //0=no, 1=CA, 2=OA 
integer li_continue, li_illegal_combination  // used with the check mark illegal combination
integer li_TO_management, li_CREW_management //0 = Copenhagen, 1= 3rd party, 2 = Owner
integer li_original_vessel_type              //used in special roles for IOM_SIN_VESSELS 
integer li_voyage_type, li_counter, li_non_comm_handled, li_tcin_post_default_companycode
long    ll_total_rows, ll_exp_row, ll_bpost_row, ll_tcexp_row, ll_current_voucher_no, ll_amount_dkk
long    ll_paymentID, ll_contractID
boolean lb_iom_sin_vessel = FALSE, lb_brostrom_mt_vessel = FALSE
boolean lb_TO_expense= false, lb_CREW_expense=false, lb_bareboat=false
boolean lb_CPH_CREW_managed=false, lb_CPH_TO_managed=false
decimal {6} ld_exrate_tc, ld_exrate_disb, ld_exrate_exp 
datetime ldt_voyage_start

u_voucher            luo_voucher
n_tc_payment         lnv_payment
u_iom_sin_vessel     luo_iom_sin_vessel
u_brostrom_mt_vessel luo_brostrom_mt_vessel

luo_voucher            = CREATE u_voucher
luo_iom_sin_vessel     = CREATE u_iom_sin_vessel
luo_brostrom_mt_vessel = CREATE u_brostrom_mt_vessel

n_exchangerate	lnv_exchangerate

li_original_vessel_type = ai_vessel_type

ll_total_rows = ids_disb_expenses.Retrieve(istr_trans_input.vessel_no, istr_trans_input.voyage_no, istr_trans_input.port, istr_trans_input.pcn, istr_trans_input.agent_no)

if ai_vessel_type = 2 then
	SELECT BAREBOAT INTO :lb_bareboat 
	FROM   NTC_TC_CONTRACT 
	WHERE  CONTRACT_ID = :il_tcin;
	
	SELECT THIRD_PARTY INTO :li_TO_management 
	FROM   NTC_BAREBOAT_MANAGEMENT 
	WHERE  MANAGEMENT_TYPE = 1 AND CONTRACT_ID = :il_tcin;
	
	SELECT THIRD_PARTY INTO :li_CREW_management 
	FROM   NTC_BAREBOAT_MANAGEMENT 
	WHERE  MANAGEMENT_TYPE = 2 AND CONTRACT_ID = :il_tcin;
end if

IF ll_total_rows < 1 THEN
	of_messagebox("Retrieval error", "Cant retrieve expenses. Object: u_transaction_expense, Function: of_fill_bpost")
	DESTROY luo_voucher
	DESTROY luo_iom_sin_vessel
	DESTROY luo_brostrom_mt_vessel
	Return(-1)
END IF

setNull(is_handling_commission_owner_snr)

id_handling_commission_local = 0
id_handling_commission_USD   = 0
id_handling_commission_DKK   = 0

FOR ll_exp_row = 1 TO ll_total_rows
	//Clear variables
	SetNull(ls_el3)
	SetNull(ls_el4)
	SetNull(ls_el5)
	SetNull(ls_el6)
	SetNull(ls_el7)
	SetNull(ls_resp_dept)
	SetNull(li_ca_or_oa)
	
	ll_amount_dkk = 0


	//Get current voucher nr
	ll_current_voucher_no = ids_disb_expenses.GetItemNumber(ll_exp_row, "voucher_nr")
	luo_voucher.of_getVoucher(ll_current_voucher_no)

	/* Get information to be able to find out if this vessel is on TC-IN and BAREBOAT Contract
		and where Technical Management or Crew Management is laid out to 3rd party.
		In this cases the accounting string elements come from TC-contract */
		
	SELECT ACCOUNTING_EXPENSE_TYPE INTO :li_counter 
	FROM   VOUCHERS 	
	WHERE  VOUCHER_NR = :ll_current_voucher_no;
	
	if li_counter = 1 then
		lb_TO_expense   = true
		lb_CREW_expense = false
		
	elseif li_counter = 2 then	
		
		lb_TO_expense   = false
		lb_CREW_expense = true
	else
		lb_TO_expense = false
		lb_CREW_expense = false
	end if
	
	if ai_vessel_type = 2 and lb_bareboat and lb_TO_expense and li_TO_management=0  then
		/* TC-IN, Bareboat, TO Expense and Copenhagen Management  */
		luo_voucher.of_getAPMElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name,  ls_illegal_message)
	elseif ai_vessel_type = 2 and lb_bareboat and lb_TO_expense and li_TO_management=1  then
		
		/* TC-IN, Bareboat, TO Expense and 3rd Party Management  */
		
		SELECT CODA_EL3, CODA_EL4, CODA_EL5, CODA_EL6, CODA_EL7 INTO :ls_el3, :ls_el4, :ls_el5, :ls_el6, :ls_el7
		FROM   NTC_BAREBOAT_MANAGEMENT 
		WHERE  MANAGEMENT_TYPE = 1 AND CONTRACT_ID = :il_tcin;
		
		li_ca_or_oa   = 0 /* No transfer to TC-Hire in this case */
		ls_resp_dept  = "INVOICE ?"
		ll_amount_dkk = 0
		
		li_illegal_combination = 1
		ls_voucher_name        = luo_voucher.of_getVouchername( )
		ls_illegal_message     = "Please remember to issue invoice to Technical Manager."
		
	elseif ai_vessel_type = 2 and lb_bareboat and lb_CREW_expense and li_CREW_management=0  then
		/* TC-IN, Bareboat, CREW Expense and Copenhagen Management  */
		luo_voucher.of_getAPMElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name,  ls_illegal_message)
	elseif ai_vessel_type = 2 and lb_bareboat and lb_CREW_expense and li_CREW_management=1  then
		
		/* TC-IN, Bareboat, CREW Expense and 3rd Party Management  */
		
		SELECT CODA_EL3, CODA_EL4, CODA_EL5, CODA_EL6, CODA_EL7 INTO :ls_el3, :ls_el4, :ls_el5, :ls_el6, :ls_el7
		FROM   NTC_BAREBOAT_MANAGEMENT 
		WHERE  MANAGEMENT_TYPE = 2 AND CONTRACT_ID = :il_tcin;
		
		li_ca_or_oa   = 0 //No transfer to TC-Hire in this case
		ls_resp_dept  = "INVOICE ?"
		ll_amount_dkk = 0
		li_illegal_combination = 1
		ls_voucher_name        = luo_voucher.of_getVouchername( )
		ls_illegal_message     = "Please remember to issue invoice to Crew Manager."
		
	else //most common scenario
		
		// If Vessel non apm commercially handled, then ignore iom-sin settings 
		SELECT NON_APM_COMM_HANDLED, TC_IN_POST_DEFAULT_COMPANY, CODA_EL4, CMS_EL4
		INTO :li_non_comm_handled, :li_tcin_post_default_companycode, :ls_profitcenter_CODA_EL4, :ls_profitcenter_CMS_EL4
		FROM VESSELS, PROFIT_C
		WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND VESSELS.VESSEL_NR =  :istr_trans_input.vessel_no ;
		
		IF li_non_comm_handled = 1 THEN	
			lb_iom_sin_vessel = false
		else

			//First find out if vessel in table IOM_SIN_VESSELS.
			lb_iom_sin_vessel = luo_iom_sin_vessel.of_getVessel(istr_trans_input.vessel_no)
		
			//Implementation changed by REM when this functionality where made dynamic.
			IF lb_iom_sin_vessel AND lb_TO_expense THEN  
				ai_vessel_type = 1  //Set vessel type to APM vessel.
			ELSE
				ai_vessel_type = li_original_vessel_type	
			END IF
		end if
		
		//First find out if vessel in table Broström MT vessel setup.
		lb_brostrom_mt_vessel = luo_brostrom_mt_vessel.of_vesselExists(istr_trans_input.vessel_no)
		
		//Get elements from voucher table.
		CHOOSE CASE ai_vessel_type
			CASE 1
				luo_voucher.of_getAPMElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name,  ls_illegal_message)
			CASE 2
				luo_voucher.of_getTCinElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name, ls_illegal_message)
			CASE 3
				luo_voucher.of_getTCoutElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name, ls_illegal_message)
			CASE 4
				luo_voucher.of_getTCinoutElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name, ls_illegal_message)
		END CHOOSE
	
		//Get IOM/SIN Accounting strings.
						
		IF lb_iom_sin_vessel AND lb_CREW_expense THEN  
			luo_iom_sin_vessel.of_getCrewElement(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7) //Elements from table IOM_SIN_VESSELS.
			
			li_ca_or_oa   = 0 //No transfer to TC-Hire in this case
			ls_resp_dept  = ls_el4
			ll_amount_dkk = 0
			li_illegal_combination = 0
		END IF

		IF lb_iom_sin_vessel AND lb_TO_expense THEN  
			// Check if special rule for TO selected, else use normal rule for TO expenses on iomsin vessels
			if luo_iom_sin_vessel.of_getTOElement(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, istr_trans_input.disb_port_arr_date ) = 1 then  /* Elements from table IOM_SIN_VESSELS */
				li_ca_or_oa   = 0 //No transfer to TC-Hire in this case 
				ls_resp_dept  = ls_el4
				ll_amount_dkk = 0
				li_illegal_combination = 0
			end if
		END IF
		
		//Get Brostrom/MT Accounting strings
					
		IF lb_brostrom_mt_vessel AND lb_CREW_expense THEN  
			luo_brostrom_mt_vessel.of_getCrewElement(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7)  
			li_ca_or_oa   = 0 //No transfer to TC-Hire in this case
			ls_resp_dept  = ls_el4
			ll_amount_dkk = 0
			li_illegal_combination = 0
		END IF

		IF lb_brostrom_mt_vessel AND lb_TO_expense THEN  
			if luo_brostrom_mt_vessel.of_getTOElement(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7 ) = 1 then  
				li_ca_or_oa   = 0 //No transfer to TC-Hire in this case
				ls_resp_dept  = ls_el4
				ll_amount_dkk = 0
				li_illegal_combination = 0
			end if
		END IF
		
		/* Find out is T.O. or Crew is managed by Copenhagen 
		   if yes, use the APM accountring string from voucher */

		if lb_CREW_expense then
			
			SELECT VESSEL_CPH_CREW_MANAGED INTO :lb_CPH_CREW_managed
			FROM   VESSELS
			WHERE  VESSELS.VESSEL_NR =  :istr_trans_input.vessel_no ;
			
			if lb_CPH_CREW_managed then 
				luo_voucher.of_getAPMElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name,  ls_illegal_message)
				
				li_ca_or_oa   = 0          //No transfer to TC-Hire in this case
				ls_resp_dept  = ""         //Not used in this case
				ll_amount_dkk = 0          //Not used in this case
				li_illegal_combination = 0 //Not used in this case
			end if
		end if
		
		if lb_TO_expense then
			
			SELECT VESSEL_CPH_TO_MANAGED INTO :lb_CPH_TO_managed
			FROM   VESSELS
			WHERE  VESSELS.VESSEL_NR =  :istr_trans_input.vessel_no ;
			
			if lb_CPH_TO_managed then 
				luo_voucher.of_getAPMElements(ls_el3, ls_el4, ls_el5, ls_el6, ls_el7, ls_resp_dept, ll_amount_dkk, li_ca_or_oa, li_illegal_combination, ls_voucher_name,  ls_illegal_message)
				li_ca_or_oa = 0 //No transfer to TC-Hire in this case
			end if
		end if

	end if

	ll_bpost_row = of_createBpost ( is_codacompanycode )
	
	/* Set field no. 03 (Fiscal Year) */
	IF ids_bpost.SetItem(ll_bpost_row, "f03_yr", ids_apost.GetItemNumber(1, "f03_yr")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 03 (Fiscal Year) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	/* Set field no. 04 (Period) */
	IF ids_bpost.SetItem(ll_bpost_row, "f04_period", ids_apost.GetItemNumber(1, "f04_period")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 04 (Period) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	/* Set field no. 08 DocLineNumber */
	IF ids_bpost.SetItem(ll_bpost_row, "f08_doclinenum_b", ll_exp_row +1) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 08 (Doclinenumber) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	/* Set field no. 11 (Element 1) */
	IF Left(istr_trans_input.voyage_no,2) >= "50" THEN
		ls_century = "19"
	ELSE
		ls_century = "20"
	END IF

	SELECT min( POC.PORT_ARR_DT) INTO :ldt_voyage_start  
	FROM   POC  
	WHERE  (POC.VESSEL_NR = :istr_trans_input.vessel_no) AND (POC.VOYAGE_NR = :istr_trans_input.voyage_no);
			 
	IF SQLCA.SQLCode <> 0 THEN
		of_messagebox("Retrieval error", "Cant get voyage startdate for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	ls_temp_string = string(ldt_voyage_start, "YYYY")

	IF ls_temp_string <> (ls_century + Left(istr_trans_input.voyage_no,2)) THEN
		ls_string = (ls_century + Left(istr_trans_input.voyage_no,2) + "01")
	ELSE
		ls_string = string(ldt_voyage_start, "YYYYMM")
	END IF

	IF ids_bpost.SetItem(ll_bpost_row,"f11_el1_b", ls_string) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	/* Set field no. 12 (Element 2) */
	IF ids_bpost.SetItem(ll_bpost_row, "f12_el2_b", ids_apost.GetItemString(1, "f12_el2")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 12 (Element 2) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 13 (Element 3)
	IF ids_bpost.SetItem(ll_bpost_row, "f13_el3_b", ls_el3) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	/* Set field no. 14 (Element 4)
	   Se also at the end of the script, Element 4 NULL functionality implemented */
	IF	ids_bpost.SetItem(ll_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 15 (Element 5)
	IF IsNull(ls_el5) THEN
		//Change made by REM 01-11-02, alphanumeric vessel number
		SELECT VESSEL_REF_NR INTO :ls_vessel_ref_nr 
		FROM   VESSELS 
		WHERE  VESSEL_NR = :istr_trans_input.vessel_no;
		
		IF SQLCA.SQLCode = 0 THEN
			COMMIT;
		ELSE
			of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_expenses, function: of_fill_transaction")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
		
		IF ids_bpost.SetItem(ll_bpost_row, "f15_el5_b", ids_default_values.GetItemString(1, "prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 15 (NULL) (Element 5) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(ll_bpost_row, "f15_el5_b", ls_el5) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 15 (NOT NULL) (Element 5) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	END IF		

	/* Set field no. 16 (Element 6) */
	IF IsNull(ls_el6) THEN
		IF ids_bpost.SetItem(ll_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + left(istr_trans_input.voyage_no,5)) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(ll_bpost_row, "f16_el6_b", ls_el6) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 16 (NOT NULL) (Element 6) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	END IF		

	//Set field no. 17 (Element 7)
	IF IsNull(ls_el7) THEN
		IF ids_bpost.SetItem(ll_bpost_row, "f17_el7_b", ids_default_values.GetItemString(1, "prefix_port") + istr_trans_input.port) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 17 (NULL) (Element 7) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(ll_bpost_row, "f17_el7_b", ls_el7) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 17 (NOT NULL) (Element 7) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	END IF		

	//Set field no. 18 (Element 8)
	IF ids_bpost.SetItem(ll_bpost_row, "f18_el8_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 18 (NULL) (Element 8) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 19 (Customer or Supplier)
	IF ids_bpost.SetItem(ll_bpost_row, "f19_custsupp", ids_apost.GetItemString(1, "f19_custsupp")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 19 (CustSupp) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 20 (Invoice number)
	
	ids_bpost.SetItem(ll_bpost_row, "f20_invoicenr", ids_disb_expenses.GetItemString(ll_exp_row, "disb_invoice_nr"))
	
	//Set field no. 27 (linetype)
	IF ids_bpost.SetItem(ll_bpost_row, "f27_linetype", ids_default_values.GetItemNumber(1, "linetype_analyses_bpost")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 27 (Linetype) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Get amounts and calculate DKK and sum for all
	id_amount_local     = (Round(ids_disb_expenses.GetItemNumber(ll_exp_row, "exp_amount_local"),2) ) * 100
	id_sum_amount_local = id_sum_amount_local + id_amount_local
	
	id_amount_usd     = (Round(ids_disb_expenses.GetItemNumber(ll_exp_row, "exp_amount_usd"),2) ) * 100
	id_sum_amount_usd = id_sum_amount_usd + id_amount_usd

	id_amount_dkk     = (Round(id_amount_local * istr_trans_input.disb_ex_rate_to_dkk / 100,0)) 
	id_sum_amount_dkk = id_sum_amount_dkk + id_amount_dkk

	//Set field no. 29 (DebitCredit)
 	IF id_amount_local < 0 THEN
		IF ids_bpost.SetItem(ll_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	ELSE
		IF ids_bpost.SetItem(ll_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	END IF
	
	//Set field no. 30 (Valuedoc) 
	IF ids_bpost.SetItem(ll_bpost_row, "f30_valuedoc", abs(id_amount_local)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF
	
	//Set field no. 31 (Valuedoc_dp)
	IF ids_bpost.SetItem(ll_bpost_row, "f31_valuedoc_dp", 2) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 32 (Valuehome)
	IF ids_bpost.SetItem(ll_bpost_row, "f32_valuehome", abs(id_amount_dkk)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF
	
	//Set field no. 33 (Valuehome_dp)
	IF ids_bpost.SetItem(ll_bpost_row, "f33_valuehome_dp", 2) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 34 (Valuedual)
	IF ids_bpost.SetItem(ll_bpost_row, "f34_vatamo_or_valdual", abs(id_amount_usd)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF
	
	//Set field no. 35 (Valuedual_dp)
	IF ids_bpost.SetItem(ll_bpost_row, "f35_vattype_or_valdual_dp", 2) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field no. 21 (voucher number)
	IF ids_bpost.SetItem(ll_bpost_row, "f21_vouchernr", string(ll_current_voucher_no)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 21 (voucher number) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF


	IF ids_bpost.setItem(ll_bpost_row, "f41_linedesr","Disbursement exp.") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 41 (Linedesr) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
		DESTROY luo_voucher
		DESTROY luo_iom_sin_vessel
		Return(-1)
	END IF

	//Set field Responsible Company or Department
	IF ABS(id_amount_dkk) > (ll_amount_dkk * 100) THEN
		
		IF ids_bpost.SetItem(ll_bpost_row, "resp_comp_or_dept", ls_resp_dept) <> 1 THEN
			of_messagebox("Set value error", "Cant set Responsible Company or Department. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	END IF	
	
	//Set Settled value for current expense.
	ids_disb_expenses.SetItem(ll_exp_row, "settled", 1)
	
	//Get payment id.
	IF (li_ca_or_oa = 1 and (ai_vessel_type = 3 OR ai_vessel_type = 4)) or &
	   (li_ca_or_oa = 2 and (ai_vessel_type = 2 OR ai_vessel_type = 4)) THEN
		
		ll_paymentID = ids_disb_expenses.getitemnumber(ll_exp_row, "payment_id")
		
		if isnull(ll_paymentID) then
			
			lnv_payment  = create n_tc_payment
			
			if li_ca_or_oa = 1 and (ai_vessel_type = 3 OR ai_vessel_type = 4) then
				ll_paymentID = lnv_payment.of_getFirstPartpaid(il_tcout)
			elseif li_ca_or_oa = 2 and (ai_vessel_type = 2 OR ai_vessel_type = 4) then
				ll_paymentID = lnv_payment.of_getFirstPartpaid(il_tcin)
			end if
			
			destroy lnv_payment
			
			IF ll_paymentID = -1 THEN
				of_messagebox("Error", "Cant get Payment ID for Expenses transferred to TC Hire. Object: u_transaction_expense, function: of_fill_bpost")
				DESTROY luo_voucher
				DESTROY luo_iom_sin_vessel
				Return(-1)
			END IF
			
		end if		
	END IF

	//Set field no. 14 (Element 4) NULL function implementation.
	IF isNull(ls_el4) THEN
		/* Change made by REM 20-10-03, new rules implemented. If element 4 = NULL
		   and transfer to TC Hire for C/A S# from Charterer, if O/A S# from Owner */
			
		SELECT NTC_PAYMENT.CONTRACT_ID INTO :ll_contractID  
		FROM   NTC_PAYMENT  
		WHERE  NTC_PAYMENT.PAYMENT_ID = :ll_paymentID;
		
		IF SQLCA.SQLCode <> 0 THEN
			of_messagebox("Retrieval error", "Cant get TC Contract ID. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
		
		if li_ca_or_oa = 1 then
			
			SELECT "S"+CHART.NOM_ACC_NR INTO :ls_el4  
			FROM   CHART, NTC_TC_CONTRACT  
			WHERE  ( NTC_TC_CONTRACT.CHART_NR = CHART.CHART_NR ) and ( NTC_TC_CONTRACT.CONTRACT_ID = :ll_contractID ) ;
			
			IF SQLCA.SQLCode <> 0 THEN
				of_messagebox("Retrieval error", "Cant get Charterer S-number type for B-post. Object: u_transaction_expense, function: of_fill_bpost")
				DESTROY luo_voucher
				DESTROY luo_iom_sin_vessel
				Return(-1)
			END IF
		ELSE
			SELECT "S"+TCOWNERS.NOM_ACC_NR INTO :ls_el4  
			FROM   TCOWNERS, NTC_TC_CONTRACT  
			WHERE  (NTC_TC_CONTRACT.TCOWNER_NR = TCOWNERS.TCOWNER_NR) and (NTC_TC_CONTRACT.CONTRACT_ID = :ll_contractID);
			
			IF SQLCA.SQLCode <> 0 THEN
				of_messagebox("Retrieval error", "Cant get Owners S-number type for B-post. Object: u_transaction_expense, function: of_fill_bpost")
				DESTROY luo_voucher
				DESTROY luo_iom_sin_vessel
				Return(-1)
			END IF
		END IF
		
		IF	ids_bpost.SetItem(ll_bpost_row, "f14_el4_b", ls_el4) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_expense, function: of_fill_bpost")
			DESTROY luo_voucher
			DESTROY luo_iom_sin_vessel
			Return(-1)
		END IF
	END IF
	
	if li_tcin_post_default_companycode = 1 and li_ca_or_oa > 0 and not isnull(il_tcin) then
		
		ll_bpost_row = of_createBpost ( ids_default_values.getItemString(1, "cmpcode") )
		
		of_extrapostdefaultcompanycode( )
	end if	
NEXT 

DESTROY luo_voucher
DESTROY luo_iom_sin_vessel
return(1)
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_expense
   <OBJECT> Post ofdisbursements - CODA transaction</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
	<HISTORY> 
		Date   		CR-ref 	Author		Comments
		00/00/07 	?     	Name Here	First Version
		14/02/2011	2277  	JMC			f03 and f04 fields are defined in default_coda function
		12/11/2011	2322  	RMO			expenses transferred to the TC-in contract are posted on both
		          	      	      		the profitcenter company code, and the defaulr company code
		         	      	      		(added array of datastores to be able to handle more than one
		          	      	      		set of transactions, and rewritten the save function)
		13/11/2011	2323  	RMO			implemented functionality that handles posting of Crew & T.O.
		          	      	      		expenses on vessels with "Broström/MT" setup
		16/05/2011	2426  	RMO			docline number in b-post not always in sequence in additional
		          	      	      		posting to default company code
		28/06/2011	2453  	RMO			posting Crew and T.O. expenses on vessels managed by
		          	      	      		Copenhagen as APM vessels
		25/03/2012	FIN   	JMC			Add voucher number in field 21
		18/08/2014	CR3698	XSZ004		Modify error message.
		10/04/15  	CR3854	XSZ004		Remove the functionality of expenses transfer to TC-Hire when settle in disbursement.
	</HISTORY> 
********************************************************************/
end subroutine

private function integer of_createbpost (string as_companycode);long ll_index
long ll_rows, ll_row
boolean lb_found = false

ll_rows = upperbound(ids_apost_array)
for ll_row = 1 to ll_rows
	if as_companycode = ids_apost_array[ll_row].getItemString(1, "f02_cmpcode") then 
		lb_found = true
		ll_index = ll_row
		exit
	end if
next
if NOT lb_found then
	ll_index = upperBound(ids_apost_array) +1
	ids_apost_array[ll_index] = create n_ds
	ids_apost_array[ll_index].dataObject = "d_trans_log_main_a"
	ids_apost_array[ll_index].object.data[1,1,1,56] = ids_apost.object.data[1,1,1,56]
	ids_apost_array[ll_index].setItem(1, "f02_cmpcode", as_companyCode)
	ids_bpost_array[ll_index] = create n_ds
	ids_bpost_array[ll_index].dataObject="d_trans_log_b"
	ids_apost_array[ll_index].SetTransObject(SQLCA)
ids_bpost_array[ll_index].SetTransObject(SQLCA)
end if

ids_apost = ids_apost_array[ll_index]
ids_bpost = ids_bpost_array[ll_index]

return ids_bpost.insertRow(0)
end function

private function integer of_extrapostdefaultcompanycode ();long ll_index
long ll_datawindows, ll_datawindow
long ll_browarray, ll_brow
boolean lb_found = false
string ls_tcownerAccount

ll_datawindows = upperbound(ids_apost_array)
for ll_datawindow = 1 to ll_datawindows
	if is_codacompanycode = ids_apost_array[ll_datawindow].getItemString(1, "f02_cmpcode") then 
		lb_found = true
		ll_index = ll_datawindow
		exit
	end if
next
if NOT lb_found then return c#return.failure

ll_browarray = ids_bpost_array[ll_datawindow].rowCount()
ll_brow = ids_bpost.rowcount( )

ids_bpost.object.data[ll_brow,1,ll_brow, 25] = ids_bpost_array[ll_datawindow].object.data[ll_browarray,1,ll_browarray,25]

SELECT TCOWNERS.NOM_ACC_NR  
    INTO :ls_tcownerAccount  
    FROM NTC_TC_CONTRACT,   
         TCOWNERS  
   WHERE TCOWNERS.TCOWNER_NR = NTC_TC_CONTRACT.TCOWNER_NR 
   AND NTC_TC_CONTRACT.CONTRACT_ID = :il_tcin ;
if isNull(ls_tcownerAccount) then return c#return.failure

ids_bpost.setItem(ll_brow, "f14_el4_b", ids_default_values.getItemString(1, "prefix_supplier_foreign")+ls_tcownerAccount)

ids_apost = ids_apost_array[1]
ids_bpost = ids_bpost_array[1]

return c#return.success
end function

public function integer of_save ();/* Saves the transactions (datastores) in transaction log */
long 	ll_transkey, ll_brows, ll_brow
long	ll_datawindows, ll_datawindow
decimal {0} ld_valueDoc, ld_valueHome, ld_valueDual

ll_datawindows = upperBound(ids_apost_array)

// Check and populate A-post amounts
for ll_datawindow = 1 to ll_datawindows
 	if isNull(ids_apost_array[ll_datawindow].getItemDecimal(1, "f30_valuedoc"))  then
		ll_brows = ids_bpost_array[ll_datawindow].RowCount()
		ld_valueDoc = 0
		ld_valueDual = 0
		ld_valueHome = 0
		for ll_brow = 1 to ll_brows
			if ids_bpost_array[ll_datawindow].getItemNumber(ll_brow, "f29_debitcredit") &
			= ids_default_values.getItemNumber(1, "debitcredit_debit") then
				ld_valueDoc += ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f30_valuedoc")
				ld_valueHome += ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f32_valuehome")
				ld_valueDual += ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f34_vatamo_or_valdual")
			else
				ld_valueDoc -= ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f30_valuedoc")
				ld_valueHome -= ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f32_valuehome")
				ld_valueDual -= ids_bpost_array[ll_datawindow].getItemDecimal(ll_brow, "f34_vatamo_or_valdual")
			end if				
		next
		if ld_valueDoc >= 0 then
			// Credit 
			ids_apost_array[ll_datawindow].setItem(1, "f29_debitcredit", ids_default_values.getItemNumber(1, "debitcredit_credit"))
		else
			// Debit
			ids_apost_array[ll_datawindow].setItem(1, "f29_debitcredit", ids_default_values.getItemNumber(1, "debitcredit_debit"))
		end if	
		// Set values
		ids_apost_array[ll_datawindow].setItem(1, "f30_valuedoc", abs(ld_valueDoc) )
		ids_apost_array[ll_datawindow].setItem(1, "f31_valuedoc_dp", 2 )
		ids_apost_array[ll_datawindow].setItem(1, "f32_valuehome", abs(ld_valueHome) )
		ids_apost_array[ll_datawindow].setItem(1, "f33_valuehome_dp", 2 )
		ids_apost_array[ll_datawindow].setItem(1, "f34_vatamo_or_valdual", abs(ld_valueDual) )
		ids_apost_array[ll_datawindow].setItem(1, "f35_vattyp_or_valdual_dp", 2 )
	end if
next

// Update All A-posts and B-posts
for ll_datawindow = 1 to ll_datawindows
	IF ids_apost_array[ll_datawindow].RowCount() = 1 THEN
		IF ids_bpost_array[ll_datawindow].RowCount() > 0 THEN
			/* Save apost and fill transkey in bpost and save bpost */
			IF ids_apost_array[ll_datawindow].Update() = 1 THEN
				ll_transkey = ids_apost_array[ll_datawindow].GetItemNumber(1,"trans_key")
				IF IsNull(ll_transkey) OR ll_transkey = 0 THEN
					of_messagebox("Generate transaction error", "No value found for transaction key")
					ROLLBACK;
					Return(-1)
				ELSE
					ll_brows = ids_bpost_array[ll_datawindow].RowCount()
					FOR ll_brow = 1 TO ll_brows
						ids_bpost_array[ll_datawindow].SetItem( ll_brow, "trans_key", ll_transkey )
						ids_bpost_array[ll_datawindow].SetItem( ll_brow, "f08_doclinenum_b", ll_brow +1 )
					NEXT
					ids_bpost_array[ll_datawindow].AcceptText()
					IF ids_bpost_array[ll_datawindow].Update() = 1 THEN
						continue					
					ELSE
						ROLLBACK;
						of_messagebox("Error","ids_Apost ok, but ids_Bpost went wrong in update")
						Return(-1)
					END IF
				END IF
			ELSE
				of_messagebox("Error","Update of ids_Apost went wrong" + SQLCA.SqlErrText)
				ROLLBACK;
				Return(-1)
			END IF
		ELSE
			of_messagebox("Generate transaction error", "No rows found in B-post")
			Return(-1)
		END IF
	ELSE
		of_messagebox("Generate transaction error", "Non or too many rows found in A-post")
		Return(-1)
	END IF
next
COMMIT;
end function

public subroutine of_reset_data ();/********************************************************************
   of_reset_data
   <DESC> Initial data</DESC>
   <RETURN>	
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		01/12/16		CR4420		XSZ004		First Version
   </HISTORY>
********************************************************************/

n_ds lds_apost_array[], lds_bpost_array[]

id_amount_local = 0
id_amount_usd   = 0
id_amount_dkk   = 0

id_sum_amount_local = 0
id_sum_amount_usd   = 0
id_sum_amount_dkk   = 0

id_handling_commission_local = 0  
id_handling_commission_USD   = 0
id_handling_commission_DKK   = 0

is_handling_commission_owner_snr = "" 

ids_disb_expenses.reset()
ids_apost.reset()
ids_bpost.reset()

lds_apost_array[1] = CREATE n_ds
lds_bpost_array[1] = CREATE n_ds

lds_apost_array[1].DataObject = "d_trans_log_main_a"
lds_bpost_array[1].DataObject = "d_trans_log_b"

lds_apost_array[1].SetTransObject(SQLCA)
lds_bpost_array[1].SetTransObject(SQLCA)

ids_apost_array = lds_apost_array
ids_bpost_array = lds_bpost_array
end subroutine

on u_transaction_expense.create
call super::create
end on

on u_transaction_expense.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_apost_array[1] = CREATE n_ds
ids_bpost_array[1] = CREATE n_ds

ids_apost_array[1].DataObject = "d_trans_log_main_a"
ids_bpost_array[1].DataObject = "d_trans_log_b"
ids_apost_array[1].SetTransObject(SQLCA)
ids_bpost_array[1].SetTransObject(SQLCA)

ids_disb_expenses = CREATE datastore
ids_disb_expenses.DataObject = "d_coda_disb_expenses"
ids_disb_expenses.SetTransObject(SQLCA)



end event

event destructor;call super::destructor;long ll_row

DESTROY ids_disb_expenses

for ll_row = upperbound(ids_apost_array) to 1 step -1
	DESTROY ids_apost_array[ll_row] 
	DESTROY ids_bpost_array[ll_row]
next

end event

