$PBExportHeader$u_transaction_commission_batch.sru
$PBExportComments$Inherited from u_transaction . Generates batch commissions
forward
global type u_transaction_commission_batch from u_transaction
end type
end forward

global type u_transaction_commission_batch from u_transaction
end type
global u_transaction_commission_batch u_transaction_commission_batch

forward prototypes
public function integer of_fill_transaction ()
public subroutine documentation ()
end prototypes

public function integer of_fill_transaction ();// Set all fields for Batch commission that has not been set in default functions.
// Field 7 (Docnum) is not set before file creation.

Integer li_result_grossfrt, li_integer, li_period
String ls_string, ls_prefix, ls_century, ls_yr, ls_temp_string
String ls_vessel_ref_nr
Datetime ldt_datetime
Decimal {0} ld_no_decimal
u_broker uo_broker

////// SET KEYS FOR QUERY PURPOSE //////////

IF ids_apost.SetItem(1,"trans_type","CommBatch") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.broker_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.claim_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////

/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_commission_batch, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 9 doc. date */
IF ids_apost.SetItem(1,"f09_docdate", istr_trans_input.doc_date) <> 1 THEN
	of_messagebox("Set value error", "Cant set docdate for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
//IF NOT(isNull(istr_trans_input.tc_cp_date)) THEN	
//	SELECT	TCCOMMISSION.TCCOMM_SET_OFF_DT  
//	INTO 		:ldt_datetime  
//	FROM 		TCCOMMISSION  
//	WHERE 	VESSEL_NR = 		:istr_trans_input.vessel_no 	AND
//		 		TCHIRE_CP_DATE = 	:istr_trans_input.tc_cp_date 	AND
//		 		BROKER_NR = 		:istr_trans_input.broker_no 	AND
//		 		TCINVOICE_NR = 	:istr_trans_input.comm_inv_no AND
//		 		TCCOMM_AMOUNT = 	:istr_trans_input.comm_amount;
//	Commit;	
//ELSE	
//	SELECT	CLAIMS.DISCHARGE_DATE  
//	INTO 		:ldt_datetime
//	FROM 		CLAIMS  
//	WHERE 	CLAIMS.VESSEL_NR = 	:istr_trans_input.vessel_no 	AND
//				CLAIMS.VOYAGE_NR = 	:istr_trans_input.voyage_no 	AND
//				CLAIMS.CHART_NR =		:istr_trans_input.charter_no 	AND
//				CLAIMS.CLAIM_NR = 	:istr_trans_input.claim_no ;
//	Commit;
//END IF
//
IF ids_apost.SetItem(1,"f11_el1", String(today(),"YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.1 for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3 */
IF ids_apost.SetItem(1,"f13_el3", ids_default_values.GetItemString(1,"own_agent_pay_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4 */
uo_broker = CREATE u_broker
uo_broker.of_getbroker(istr_trans_input.broker_no)

ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_own")
ls_string = ls_prefix + uo_broker.of_getNominalAccount()

Destroy uo_broker;

IF LEN(ls_string) < 4 OR LEN(ls_string) > 6 THEN
	of_messagebox("Error","Broker NR :" + String(istr_trans_input.broker_no) + " has invalid nominal acc. nr : " + ls_string)
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f14_el4", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5 */
IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"batch_vessel_nr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 16  Element 6 (always blank)*/
IF ids_apost.SetItem(1,"f16_el6", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (voyage ID) for A-post. Object: u_transaction_commission_batch, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.17 Element 7 (always blank)*/
IF ids_apost.SetItem(1,"f17_el7", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set el.7 for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp (always blank)*/
IF ids_apost.SetItem(1,"f19_custsupp", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Custsupp for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.20 Invoice number )*/
IF ids_apost.SetItem(1,"f20_invoicenr", istr_trans_input.comm_inv_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set Invoicenr for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 21 Voucher nr. */
IF ids_apost.SetItem(1,"f21_vouchernr", istr_trans_input.agent_voucher_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set Voucher nr for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control nr. */
IF ids_apost.SetItem(1,"f22_controlnr", istr_trans_input.control_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set Control nr for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.23 APM Supplier )*/
uo_broker = CREATE u_broker
uo_broker.of_getbroker(istr_trans_input.broker_no)

ls_string = ls_prefix + uo_broker.of_getNominalAccount()

Destroy uo_broker;

IF ids_apost.SetItem(1,"f23_paytype_or_sup", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set APM Supplier for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.28 Curdoc )*/
IF NOT(isNull(istr_trans_input.tc_cp_date)) THEN	
	SELECT 	CURR_CODE  
	INTO 		:ls_string  
	FROM 		TCHIRES 
	WHERE 	VESSEL_NR = :istr_trans_input.vessel_no 	AND
				TCHIRE_CP_DATE = :istr_trans_input.tc_cp_date;
	Commit;	
ELSE	
	SELECT	CLAIMS.CURR_CODE  
	INTO 		:ls_string
	FROM 		CLAIMS  
	WHERE 	CLAIMS.VESSEL_NR = :istr_trans_input.vessel_no 	AND
				SUBSTRING(CLAIMS.VOYAGE_NR,1,5) = 	:istr_trans_input.voyage_no 	AND
				CLAIMS.CHART_NR =	:istr_trans_input.charter_no 	AND
				CLAIMS.CLAIM_NR =	:istr_trans_input.claim_no ;
	Commit;
END IF

IF ids_apost.SetItem(1,"f28_curdoc", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set Curdoc for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 and 30 DebitCredit and Valuedoc )*/
IF istr_trans_input.comm_amount >= 0 THEN
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit")
	ld_no_decimal = 100 * Round(istr_trans_input.comm_amount,2)	
ELSE
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit") 
	ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.comm_amount,2)))
END IF
	
IF ids_apost.SetItem(1,"f29_debitcredit", li_integer) <> 1 THEN
	of_messagebox("Set value error", "Cant set debitcredit for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF
	
IF ids_apost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr", ids_default_values.GetItemString(1,"default_comments_commibatch")) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF


///// SET B POSTS /////////////////////////////////////

ids_bpost.InsertRow(0)

/* Set field no.3 Year*/
IF ids_bpost.SetItem(1,"f03_yr", ids_apost.GetItemNumber(1,"f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set year for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.4 Period*/
IF ids_bpost.SetItem(1,"f04_period", ids_apost.GetItemNumber(1,"f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set period for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF



/* Set field no.8 Doclinenum*/
IF ids_bpost.SetItem(1,"f08_doclinenum_b", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set doclinenum for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
IF Left(istr_trans_input.voyage_no,2) >= "50" THEN
	ls_century = "19"
ELSE
	ls_century = "20"
END IF

SELECT 	MIN(POC.PORT_ARR_DT)
INTO		:ldt_datetime
FROM		POC
WHERE		VESSEL_NR = :istr_trans_input.vessel_no AND
			substring(POC.VOYAGE_NR, 1, 5) =	Substring(:istr_trans_input.voyage_no,1,5);
COMMIT;

ls_temp_string = string(ldt_datetime, "YYYY")

IF ls_temp_string <> (ls_century + Left(istr_trans_input.voyage_no,2)) THEN
	ls_string = (ls_century + Left(istr_trans_input.voyage_no,2) + "01")
ELSE
	ls_string = string(ldt_datetime, "YYYYMM")
END IF

IF ids_bpost.SetItem(1,"f11_el1_b", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(1,"f12_el2_b", ids_default_values.GetItemString(1,"el2_cms_b")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(1,"f13_el3_b", ids_default_values.GetItemString(1,"commission_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4*/
IF ids_bpost.SetItem(1,"f14_el4_b", ids_default_values.GetItemString(1,"commission_acc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5*/
/* Change made by REM 01-11-02, alphanumeric vessel number */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	COMMIT;
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_commission_batch, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f15_el5_b", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (vessel ID) for B-post. Object: u_transaction_commission_batch, function: of_fill_transaction")
	Return(-1)
END IF
//IF ids_bpost.SetItem(1,"f15_el5_b", ids_default_values.GetItemString(1,"prefix_vessel") + string(istr_trans_input.vessel_no,"000")) <> 1 THEN
//	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_commission_batch, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(1,"f16_el6_b", ids_default_values.GetItemString(1,"prefix_voyage") + istr_trans_input.voyage_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp*/
IF ids_bpost.SetItem(1,"f19_custsupp", ids_apost.GetItemString(1,"f19_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 19 for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(1,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
IF istr_trans_input.comm_amount >= 0 THEN
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit")
	ld_no_decimal = 100 * Round(istr_trans_input.comm_amount,2)	
ELSE
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
	ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.comm_amount,2)))
END IF

IF ids_bpost.SetItem(1,"f29_debitcredit", li_integer) <> 1 THEN
	of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.31 Valuedoc dp*/
IF ids_bpost.SetItem(1,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_commission_batch, &
									function: of_fill_transaction")
	Return(-1)
END IF



Return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_commission_batch
   <OBJECT> CODA transaction</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
  14/02/2011	2277	JMC		f03 and f04 fields are defined in default_coda function
********************************************************************/
end subroutine

on u_transaction_commission_batch.create
call super::create
end on

on u_transaction_commission_batch.destroy
call super::destroy
end on

