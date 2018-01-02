$PBExportHeader$u_transaction_claim.sru
$PBExportComments$Inherited from u_transaction . Generates batch commissions
forward
global type u_transaction_claim from u_transaction_nocommit
end type
end forward

global type u_transaction_claim from u_transaction_nocommit
end type
global u_transaction_claim u_transaction_claim

type variables
long il_bpost_row
integer	ii_poolmanager
end variables

forward prototypes
public function integer of_fill_transaction ()
public subroutine documentation ()
public function integer of_default_bpost ()
end prototypes

public function integer of_fill_transaction (); /********************************************************************
   of_fill_transaction
   <DESC> No commits
		Set all fields for Broker commission that has not been set in default functions.
		Field 7 (Docnum) is not set before file creation. 
   </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		18/08/14			CR3698		XSZ004		Modify error message.
		10/12/14			CR3216		XSZ004		Change the word "deductable" to "deductible".
		26/10/16			CR2212		LHG008		Sanctions restrictions
   </HISTORY>
********************************************************************/

string     ls_string, ls_prefix, ls_century, ls_yr, ls_temp_string,ls_claim_acc_nr,ls_claimtype
string     ls_vessel_ref_nr, ls_coda_el4, ls_coda_el3_pool, ls_coda_el4_pool, ls_charter_sn, ls_nominalaccount
datetime   ldt_datetime, ldt_payment_start, ldt_payment_end
integer    li_result_grossfrt, li_integer, li_period, li_non_comm_handled, li_broker
decimal{0} ld_no_decimal
decimal{2} ld_dkk_value, ld_rate
long       ll_debitcreditcode, ll_row, ll_rows, ll_tmp, ll_tmp2

u_charterer    uo_charterer
u_broker       uo_broker
n_exchangerate lnv_exchangerate

////// SET KEYS FOR QUERY PURPOSE //////////

IF ids_apost.SetItem(1,"trans_type","Claims") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.charter_no ) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.claim_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////

/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_claim, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 9 doc. date */
IF ids_apost.SetItem(1,"f09_docdate", datetime(today(), now())) <> 1 THEN
	of_messagebox("Set value error", "Cant set docdate for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 10 SANCTION_LINE_1
IF ids_apost.SetItem(1, "f10_destination", istr_trans_input.s_sanction_line_1) <> 1 THEN
	of_messagebox("Set value error", "Cant set SANCTION_LINE_1 for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/*Set field no.25 Element F25_PAYMETHOD_OR_DATEOFISSUE*/
IF ids_apost.SetItem(1,"f25_paymethod_or_dateofissue", string(istr_trans_input.tc_cp_date, "dd-mm-yyyy")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.25 for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
IF ids_apost.SetItem(1,"f11_el1", string(istr_trans_input.payment_end ,"YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.1 for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.43 Payment date */
IF ids_apost.SetItem(1,"f43_due_or_payment_date", istr_trans_input.payment_end) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 43 for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no. 14  Nominal Account  */
SELECT NON_APM_COMM_HANDLED, CODA_EL4, CODA_EL3_POOL, CODA_EL4_POOL
INTO :li_non_comm_handled, :ls_coda_el4, :ls_coda_el3_pool, :ls_coda_el4_pool
FROM VESSELS, PROFIT_C
WHERE  VESSELS.PC_NR =  PROFIT_C.PC_NR
	AND VESSELS.VESSEL_NR = :istr_trans_input.vessel_no ;

ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_foreign")

uo_charterer = create u_charterer
uo_charterer.of_getcharterer(istr_trans_input.charter_no)

ls_nominalaccount = uo_charterer.of_getnominalaccount()
ls_string         = ls_prefix + ls_nominalaccount

IF LEN(ls_string) < 4 OR LEN(ls_string) > 6  THEN
	SELECT CHART_SN INTO:ls_charter_sn 
	FROM   CHART 
	WHERE  CHART_NR = :istr_trans_input.charter_no;
	
	if ls_nominalaccount = "" then
		ls_nominalaccount = "missing"
	end if
	
	of_messagebox("Error", "Charterer with short name: " + ls_charter_sn + " has an invalid nominal account number: " + ls_nominalaccount + ".")
	Return(-1)
END IF

IF ids_apost.SetItem(1, "f14_el4",ls_string ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.23 APM Supplier*/
IF ids_apost.SetItem(1, "f23_paytype_or_sup","" ) <> 1 THEN
	of_messagebox("Set value error", "Cant set APM Supplier for A-post. Object: u_transaction_claim, &
								function: of_fill_transaction")
	Return(-1)
END IF

Destroy uo_charterer;

/* Set field no.13 Element 3 */
ls_temp_string = ids_default_values.GetItemString(1,"charterer_gl")

IF ids_apost.SetItem(1,"f13_el3", ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5 */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 16  Element 6 */
ls_temp_string= ids_default_values.GetItemString(1, "prefix_voyage") + left(istr_trans_input.voyage_no,5)

IF ids_apost.SetItem(1, "f16_el6",ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF
	

/* Set field no.17 Element 7 */
ls_temp_string = ""

if istr_trans_input.port <> "" then
	ls_temp_string =  ids_default_values.GetItemString(1, "prefix_port") + istr_trans_input.port 
end if
IF ids_apost.SetItem(1, "f17_el7", ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 18 SANCTION_LINE_2
IF ids_apost.SetItem(1, "f18_el8", istr_trans_input.s_sanction_line_2) <> 1 THEN
	of_messagebox("Set value error", "Cant set SANCTION_LINE_2 for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp (always blank)*/ 
IF ids_apost.SetItem(1,"f19_custsupp",  ids_default_values.GetItemString(1, "prefix_supplier_foreign")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Custsupp for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.20 Invoice number */
IF ids_apost.SetItem(1,"f20_invoicenr",istr_trans_input.ax_invoice_nr ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Invoicenr for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 21 Voucher nr. (always blank) */
IF ids_apost.SetItem(1,"f21_vouchernr","") <> 1 THEN
	of_messagebox("Set value error", "Cant set Voucher nr for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control nr.(always blank) */
IF ids_apost.SetItem(1,"f22_controlnr","") <> 1 THEN
	of_messagebox("Set value error", "Cant set Control nr for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.26 */
if not isnull(istr_trans_input.ax_invoice_text) then
	if ids_apost.setitem(1,"f26_orderno", istr_trans_input.ax_invoice_text) <> 1 THEN
		of_messagebox("Set value error", "Cannot set DebitCredit for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
		return(-1)
	end if
end if

/* Set field no.28 Curdoc )*/
IF ids_apost.SetItem(1, "f28_curdoc",istr_trans_input.currency_code ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 28 (CurDoc) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 DebitCredit */
if istr_trans_input.payment_amount >=0 then
	ll_debitcreditcode = ids_default_values.GetItemNumber(1, "debitcredit_debit")
else
	ll_debitcreditcode =  ids_default_values.GetItemNumber(1, "debitcredit_credit")
end if

IF ids_apost.SetItem(1, "f29_debitcredit",ll_debitcreditcode) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.30 Value in document currency */ 
IF ids_apost.SetItem(1, "f30_valuedoc", abs(istr_trans_input.payment_amount*100)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.32 Value in local currency DKK (local to DKK)*/
ld_rate = lnv_exchangerate.of_gettodaysdkkrate( istr_trans_input.currency_code )
if ld_rate <= 0 then
	of_messagebox("Get exchange rate", "Cant get exchange rate. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
end if	

ld_dkk_value = istr_trans_input.payment_amount * ld_rate

IF ids_apost.SetItem(1, "f32_valuehome", abs(ld_dkk_value)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.33 */ 
IF ids_apost.SetItem(1, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.35 */ 
IF ids_apost.SetItem(1, "f35_vattyp_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (vattyp_or_valdual_dp) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.34 Value in USD */ 
//IF ids_apost.SetItem(1, "f34_vatamo_or_valdual", 0) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Field 34 (vatamo_or_valdual) for A-post. Object: u_transaction_claim, function: of_fill_transaction")
//	Return(-1)
//END IF

//if isnull(istr_trans_input.tc_cp_date) = true then
//	ls_temp_string  =  ids_default_values.GetItemString(1,"default_comments_commiclaim")
//else 
//	ls_temp_string  =  ids_default_values.GetItemString(1,"default_comments_commitc")
//end if

/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr","Claims") <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

//Set field no. 42 SANCTION_CURRENCY
IF ids_apost.SetItem(1, "f42_location", istr_trans_input.s_sanction_currency) <> 1 THEN
	of_messagebox("Set value error", "Cant set SANCTION_CURRENCY for A-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1, "payment_id", istr_trans_input.payment_id ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field Payment_ID for A-post. Object: u_transaction_hire_pay_coda, function: of_fill_transaction")
	Return(-1)
END IF

///// SET B POSTS /////////////////////////////////////

//1. GROSS AMOUNT

IF of_default_bpost() = -1 then return -1
		

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"charterer_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4*/

SELECT NOM_ACC_NR,  CLAIMS.CLAIM_TYPE
INTO :ls_claim_acc_nr, :ls_claimtype
FROM CLAIM_TYPES, CLAIMS
WHERE CLAIM_TYPES.CLAIM_TYPE = CLAIMS.CLAIM_TYPE
AND CLAIM_ID =:istr_trans_input.payment_id ;

IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ls_claim_acc_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 */
if istr_trans_input.amount_local >=0 then
	ll_debitcreditcode = ids_default_values.GetItemNumber(1, "debitcredit_credit") 
else
	ll_debitcreditcode =  ids_default_values.GetItemNumber(1, "debitcredit_debit")
end if
IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", ll_debitcreditcode) <> 1 THEN
	of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 30 */
IF ids_bpost.SetItem(il_bpost_row,"f30_valuedoc", abs(istr_trans_input.amount_local*100)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.41 LineDescription */
IF ids_bpost.SetItem(il_bpost_row,"f41_linedesr", ls_claimtype) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF


//2. ADDRESS COMMISSION

if abs(istr_trans_input.comm_amount*100)>0 then
	
	IF of_default_bpost() = -1 then return -1
	
	/* Set field no.13 Element 3*/
	IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"charterer_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no.14 Element 4*/
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b",  ids_default_values.GetItemString(1,"adress_comm_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no.29 */
	if istr_trans_input.comm_amount >=0 then
		ll_debitcreditcode = ids_default_values.GetItemNumber(1, "debitcredit_debit") 
	else
		ll_debitcreditcode =  ids_default_values.GetItemNumber(1, "debitcredit_credit")
	end if
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", ll_debitcreditcode) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no. 30 */
	IF ids_bpost.SetItem(il_bpost_row,"f30_valuedoc", abs(istr_trans_input.comm_amount*100)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	IF ids_bpost.SetItem(il_bpost_row,"f41_linedesr", "Address Commission") <> 1 THEN
		of_messagebox("Set value error", "Cant set LineDesr for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF	
end if

//3. DEDUCTIBLE BROKERS

for li_broker = 1 to upperbound(istr_trans_input.broker_amount_array)

if abs( istr_trans_input.broker_amount_array[li_broker]*100) > 0 then
	
	IF of_default_bpost() = -1 then return -1
	
	/* Set field no.13 Element 3*/
	IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"broker_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no.14 Element 4*/	 

	uo_broker = CREATE u_broker
	uo_broker.of_getbroker( istr_trans_input.broker_id_array[li_broker])
	
	IF uo_broker.of_Own() THEN
		ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_own")
	ELSE
		ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_foreign")
	END IF
	
	/* CR2859: 	In B-post of type "Deductible Broker", the field F14 El4 B must carry the value from 
					Transaction Defaults > Nominal Accounts > Commission instead of the customer S-account. */
	
//	ls_string = ls_prefix + uo_broker.of_getNominalAccount()
	ls_string = ids_default_values.getitemstring(1, "commission_acc")

	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b",ls_string) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no.29 */
	if istr_trans_input.broker_amount_array[li_broker] >=0 then
		ll_debitcreditcode = ids_default_values.GetItemNumber(1, "debitcredit_debit") 
	else
		ll_debitcreditcode =  ids_default_values.GetItemNumber(1, "debitcredit_credit")
	end if
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", ll_debitcreditcode) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no. 30 */
	IF ids_bpost.SetItem(il_bpost_row,"f30_valuedoc", abs( istr_trans_input.broker_amount_array[li_broker]*100)) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF

	IF ids_bpost.SetItem(il_bpost_row,"f41_linedesr", "Deductible Broker") <> 1 THEN
		of_messagebox("Set value error", "Cant set LineDesr for B-post. Object: u_transaction_claim, &
										function: of_fill_transaction")
		Return(-1)
	END IF
  end if
next


/* Set field no. 08 DocLineNumber for all B-posts */
ll_rows = ids_bpost.rowCount()
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		IF ids_bpost.SetItem(ll_row, "f08_doclinenum_b", ll_row +1) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 08 (Doclinenumber) for B-post. Object: u_transaction_claim, function: of_fill_bpost")
			Return(-1)
		end if
	next
end if


Return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_claim
   <OBJECT> 	</OBJECT>
   <USAGE> 
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
	Date    		CR-Ref		Author				Comments
	01/02/11		CR2264		Joana Carvalho		First Version.
	26/03/12		FIN   		JMC112				Add cp_date in field 25.
	14/09/12		CR2934		LGX001				Add ax_invoice_text in field 26.
	18/08/14		CR3698		XSZ004				Modify error message.
	10/12/14		CR3216		XSZ004				Change the word "deductable" to "deductible".
	26/10/16		CR2212		LHG008				Sanctions restrictions
</HISTORY>    
********************************************************************/
end subroutine

public function integer of_default_bpost ();string	ls_temp_string
/* Insert new B-post */
il_bpost_row = ids_bpost.InsertRow(0)

/* Set field no.3 Year*/
IF ids_bpost.SetItem(il_bpost_row,"f03_yr", ids_apost.GetItemNumber(1,"f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set year for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.4 Period*/
IF ids_bpost.SetItem(il_bpost_row,"f04_period", ids_apost.GetItemNumber(1,"f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set period for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1*/
IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b",  ids_apost.GetItemstring(1,"f11_el1")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(il_bpost_row,"f12_el2_b",ids_apost.GetItemString(1,"f12_el2")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5*/
IF ids_bpost.SetItem(il_bpost_row,"f15_el5_b",ids_apost.GetItemString(1, "f15_el5") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (vessel ID) for B-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(il_bpost_row,"f16_el6_b", ids_apost.GetItemString(1, "f16_el6") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.17 Element 7*/
if ii_poolmanager = 1 then
	ls_temp_string = "POOLCOM"
else
	ls_temp_string =  ids_apost.GetItemString(1, "f17_el7")
end if
IF ids_bpost.SetItem(il_bpost_row,"f17_el7_b",ls_temp_string ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.7 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp*/
IF ids_bpost.SetItem(il_bpost_row,"f19_custsupp", ids_apost.GetItemString(1,"f19_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 19 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.20 Invoice nr*/
IF ids_bpost.SetItem(il_bpost_row,"f20_invoicenr", ids_apost.GetItemString(1,"f20_invoicenr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 20 for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(il_bpost_row,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.31 Valuedoc dp*/
IF ids_bpost.SetItem(il_bpost_row,"f31_valuedoc_dp",ids_apost.GetItemNumber(1,"f31_valuedoc_dp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.32 Value home*/
IF ids_bpost.SetItem(il_bpost_row,"f32_valuehome",0) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuehome for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.33 */ 
IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.34 Value dual*/
IF ids_bpost.SetItem(il_bpost_row,"f34_vatamo_or_valdual",0) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedual for B-post. Object: u_transaction_claim, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.35 */ 
IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_claim, function: of_fill_transaction")
	Return(-1)
END IF



Return 1
end function

on u_transaction_claim.create
call super::create
end on

on u_transaction_claim.destroy
call super::destroy
end on

