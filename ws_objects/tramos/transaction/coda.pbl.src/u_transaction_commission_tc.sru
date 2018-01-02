$PBExportHeader$u_transaction_commission_tc.sru
$PBExportComments$Inherited from u_transaction . Generates tc commissions
forward
global type u_transaction_commission_tc from u_transaction
end type
end forward

global type u_transaction_commission_tc from u_transaction
end type
global u_transaction_commission_tc u_transaction_commission_tc

forward prototypes
public function integer of_fill_transaction ()
end prototypes

public function integer of_fill_transaction ();// Set all fields for TC commission that has not been set in default functions.
// Field 7 (Docnum) is not set before file creation.

Integer li_result_grossfrt, li_integer
String ls_string, ls_prefix
Datetime ldt_datetime
Decimal {0} ld_no_decimal
u_broker uo_broker

////// SET KEYS FOR QUERY PURPOSE //////////

IF ids_apost.SetItem(1,"trans_type","CommTC") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.broker_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////

/* Set field no. 9 doc. date */
IF ids_apost.SetItem(1,"f09_docdate", today()) <> 1 THEN
	of_messagebox("Set value error", "Cant set docdate for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
IF ids_apost.SetItem(1,"f11_el1", String(today(),"YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.1 for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3 */
uo_broker = CREATE u_broker
uo_broker.of_getbroker(istr_trans_input.broker_no)

IF uo_broker.of_Own() THEN
	ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_own")
	ls_string = ids_default_values.GetItemString(1,"own_agent_pay_gl")
ELSE
	ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_foreign")
	ls_string = ids_default_values.GetItemString(1,"foreign_agent_pay_gl")
END IF

IF ids_apost.SetItem(1,"f13_el3", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Destroy uo_broker
	Return(-1)
END IF

/* Set field no.14 Element 4 */
ls_string = ls_prefix + uo_broker.of_getNominalAccount()

Destroy uo_broker

IF LEN(ls_string) < 4 OR LEN(ls_string) > 6 THEN
	of_messagebox("Error","Broker NR :" + String(istr_trans_input.broker_no) + " has invalid nominal acc. nr : " + ls_string)
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f14_el4", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp )*/
IF ids_apost.SetItem(1,"f19_custsupp", ls_prefix) <> 1 THEN
	of_messagebox("Set value error", "Cant set Custsupp for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.20 Invoice number )*/
IF ids_apost.SetItem(1,"f20_invoicenr", istr_trans_input.comm_inv_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set Invoicenr for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.23 Paytype code )*/
IF ids_apost.SetItem(1,"f23_paytype_or_sup", ids_default_values.GetItemString(1,"paytypcod_commitc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set paytype code for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.28 Curdoc )*/
SELECT CURR_CODE  
INTO :ls_string  
FROM TCHIRES 
WHERE VESSEL_NR = :istr_trans_input.vessel_no AND
			TCHIRE_CP_DATE = :istr_trans_input.tc_cp_date;
Commit;

IF ids_apost.SetItem(1,"f28_curdoc", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set Curdoc for A-post. Object: u_transaction_commission_tc, &
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
	of_messagebox("Set value error", "Cant set debitcredit for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF
	
IF ids_apost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr", ids_default_values.GetItemString(1,"default_comments_commitc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.43 Due Date*/
IF ids_apost.SetItem(1,"f43_due_or_payment_date", RelativeDate(Today(),2)) <> 1 THEN
	of_messagebox("Set value error", "Cant set DueDate for A-post. Object: u_transaction_commission_tc, &
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
	of_messagebox("Set value error", "Cant set doclinenum for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
SELECT TCCOMMISSION.TCCOMM_SET_OFF_DT  
INTO :ldt_datetime  
FROM TCCOMMISSION  
WHERE VESSEL_NR = :istr_trans_input.vessel_no AND
		 TCHIRE_CP_DATE = :istr_trans_input.tc_cp_date AND
		 BROKER_NR = :istr_trans_input.broker_no AND
		 TCINVOICE_NR = :istr_trans_input.comm_inv_no AND
		 TCCOMM_AMOUNT = :istr_trans_input.comm_amount;
Commit;

IF ids_bpost.SetItem(1,"f11_el1_b", String(ldt_datetime,"YYYYMM") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(1,"f12_el2_b", ids_default_values.GetItemString(1,"el2_cms_b")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(1,"f13_el3_b", ids_default_values.GetItemString(1,"commission_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4*/
IF ids_bpost.SetItem(1,"f14_el4_b", ids_default_values.GetItemString(1,"commission_acc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5*/
IF ids_bpost.SetItem(1,"f15_el5_b", ids_apost.GetItemString(1,"f15_el5")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(1,"f16_el6_b", ids_apost.GetItemString(1,"f16_el6")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.17 Element 7*/
IF ids_bpost.SetItem(1,"f17_el7_b", ids_apost.GetItemString(1,"f17_el7")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.7 for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Cust Supp*/
IF ids_bpost.SetItem(1,"f19_custsupp", ids_default_values.GetItemString(1,"default_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Cust Supp for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(1,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_commission_tc, &
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
	of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_commission_tc, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_commission_tc, &
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

on u_transaction_commission_tc.create
TriggerEvent( this, "constructor" )
end on

on u_transaction_commission_tc.destroy
TriggerEvent( this, "destructor" )
end on

