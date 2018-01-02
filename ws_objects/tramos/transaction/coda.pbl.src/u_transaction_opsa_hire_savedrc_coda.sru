$PBExportHeader$u_transaction_opsa_hire_savedrc_coda.sru
$PBExportComments$TC Hire Out Contract with OPSA setup. SaveDRC Hire is posted as extra transaction
forward
global type u_transaction_opsa_hire_savedrc_coda from u_transaction_hire
end type
end forward

global type u_transaction_opsa_hire_savedrc_coda from u_transaction_hire
end type
global u_transaction_opsa_hire_savedrc_coda u_transaction_opsa_hire_savedrc_coda

type variables
long				il_bpost_row
decimal {6}		id_exrate_TC_to_DKK, id_exrate_TC_to_USD
string				is_tc_currency, is_voyage_number[]
datetime			idt_payment_start, idt_payment_end
decimal{0}		id_hire_less_offservice_local   /* Used to calculate Broker Commission */
decimal{4}		id_hire_days_less_offservice	  /* Used to calculate Broker Commission */	
boolean			ib_CODA_settled_before = false  /* Used to control if hire posted to CODA */
n_ds				ids_coda_elements
integer			ii_Arow, ii_Brow
															 
end variables

forward prototypes
private function integer of_setexrate ()
public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end)
public function integer of_getvoyagenr (datetime adt_start, ref string as_voyagenr)
public function integer of_fill_transaction ()
private function integer of_default_bpost ()
private function integer of_bpost ()
end prototypes

private function integer of_setexrate ();decimal {6}		ld_exrate_DKK_to_USD

/* set currency Code */
is_tc_currency = istr_trans_input.settle_tc_payment.getItemString(1, "curr_code")

/* get exrate from TC currency to DKK */
SELECT EX1.EXRATE_DKK  
	INTO :id_exrate_tc_to_DKK  
	FROM NTC_EXCHANGE_RATE EX1  
	WHERE ( EX1.CURR_CODE = :is_tc_currency ) AND  
			( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
										FROM NTC_EXCHANGE_RATE EX2 
										WHERE EX2.CURR_CODE = :is_tc_currency ) );
IF isNull(id_exrate_tc_to_DKK) OR id_exrate_tc_to_DKK = 0 THEN
	of_messagebox("Error", "Cant get Exchange Rate for TC Currency. Object: u_transaction_opsa_hire_savedrc_coda, function: of_setExrate()")
	Return -1
END IF

/* get and set exchange rate from TC currency to USD */
if is_tc_currency = "USD" then
	id_exrate_TC_to_USD = 100
else
	SELECT EX1.EXRATE_DKK  
		INTO :ld_exrate_DKK_to_USD  
		FROM NTC_EXCHANGE_RATE EX1  
		WHERE ( EX1.CURR_CODE = "USD" ) AND  
				( EX1.RATE_DATE = (SELECT max(EX2.RATE_DATE) 
											FROM NTC_EXCHANGE_RATE EX2 
											WHERE EX2.CURR_CODE = "USD" ) );
	IF isNull(ld_exrate_DKK_to_USD) OR ld_exrate_DKK_to_USD = 0 THEN
		of_messagebox("Error", "Cant get Exchange Rate for USD. Object: Object: u_transaction_opsa_hire_savedrc_coda, function: of_setExrate()")
		Return -1 
	END IF
	id_exrate_TC_to_USD = ( id_exrate_TC_to_DKK / ld_exrate_DKK_to_USD ) * 100
end if

return 1

 
end function

public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end);long 				ll_total_minutes, ll_delta_minutes
decimal {0}		ld_amount_local=0, ld_amount_DKK=0, ld_amount_USD=0							/* Used for calc */
decimal {0}		ld_sum_amount_local=0, ld_sum_amount_DKK=0, ld_sum_amount_USD=0			/* Sum of calc   */
decimal {0}		ld_total_amount_local=0, ld_total_amount_DKK=0, ld_total_amount_USD=0	/* Original value to split */
datetime			ldt_calc_start, ldt_calc_end 		
integer			li_month, li_year
string			ls_voyage_nr

if month(date(adt_start)) = month(date(adt_end)) then return 1

ld_total_amount_local 	= ids_bpost.getItemNumber(al_row, "f30_valuedoc")
ld_total_amount_DKK 		= ids_bpost.getItemNumber(al_row, "f32_valuehome")
ld_total_amount_USD 		= ids_bpost.getItemNumber(al_row, "f34_vatamo_or_valdual")

ll_total_minutes = (f_datetime2long(adt_end) - f_datetime2long(adt_start))/60

ldt_calc_start = adt_start
do while month(date(ldt_calc_start)) <> month(date(f_long2datetime(f_datetime2long(adt_end)-1)))
	li_month = month(date(ldt_calc_start)) +1
	li_year  = year(date(ldt_calc_start))
	if li_month = 13 then
		li_month = 1
		li_year ++
	end if
	
	ldt_calc_end = datetime(date(li_year, li_month, 1))
	ll_delta_minutes = (f_datetime2long(ldt_calc_end) - f_datetime2long(ldt_calc_start))/60
	/* Calculate periode values */
	ld_amount_local = (ld_total_amount_local / ll_total_minutes ) * ll_delta_minutes
	ld_sum_amount_local += ld_amount_local
	ld_amount_DKK = (ld_total_amount_DKK / ll_total_minutes ) * ll_delta_minutes
	ld_sum_amount_DKK += ld_amount_DKK
	ld_amount_USD = (ld_total_amount_USD / ll_total_minutes ) * ll_delta_minutes
	ld_sum_amount_USD += ld_amount_USD
	/* Create new record and copy values from original row */
	IF of_default_bpost() = -1 then return -1
	ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_bpost.getItemString(al_row, "f13_el3_b")) 
	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_bpost.getItemString(al_row, "f14_el4_b"))
	ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_bpost.getItemNumber(al_row, "f29_debitcredit"))
	ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ids_bpost.getItemString(al_row, "f41_linedesr"))
	/* Set aktivitetsperiode inden skift  og beløb */
	ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_calc_start, "YYYYMM"))
	/* Set field no. 16 (Element 6) */
	IF of_getVoyagenr(ldt_calc_start, ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_periodiser_bpost")
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_periodiser_bpost")
		Return(-1)
	END IF
	ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_amount_local))
	ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_amount_DKK))
	ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_amount_USD))
	
	ldt_calc_start = ldt_calc_end
loop	
/* Calculate rest amount to update original record with */
ld_amount_local = ld_total_amount_local - ld_sum_amount_local
ld_amount_DKK = ld_total_amount_DKK - ld_sum_amount_DKK
ld_amount_USD = ld_total_amount_USD - ld_sum_amount_USD
ids_bpost.SetItem(al_row,"f11_el1_b", string(ldt_calc_start, "YYYYMM"))
/* Set field no. 16 (Element 6) */
IF of_getVoyagenr(ldt_calc_start, ls_voyage_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_periodiser_bpost")
	Return(-1)
END IF
IF ids_bpost.SetItem(al_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_periodiser_bpost")
	Return(-1)
END IF
ids_bpost.SetItem(al_row, "f30_valuedoc", abs(ld_amount_local))
ids_bpost.SetItem(al_row, "f32_valuehome", abs(ld_amount_DKK))
ids_bpost.SetItem(al_row, "f34_vatamo_or_valdual", abs(ld_amount_USD))

return 1

end function

public function integer of_getvoyagenr (datetime adt_start, ref string as_voyagenr);long 	ll_yy
long	ll_contractID

ll_yy = year(date(adt_start)) - 1999
ll_contractID = istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")

if upperbound(is_voyage_number) < ll_yy then 
	SELECT NTC_TC_PERIOD.TCOUT_VOYAGE_NR  
		INTO :is_voyage_number[ll_yy]  
		FROM NTC_TC_PERIOD  
		WHERE NTC_TC_PERIOD.CONTRACT_ID = :ll_contractID AND
				NTC_TC_PERIOD.PERIODE_START <= :adt_start AND  
				NTC_TC_PERIOD.PERIODE_END > :adt_start  ;
else
	if is_voyage_number[ll_yy] = "" then
			SELECT NTC_TC_PERIOD.TCOUT_VOYAGE_NR  
				INTO :is_voyage_number[ll_yy]  
				FROM NTC_TC_PERIOD  
				WHERE NTC_TC_PERIOD.CONTRACT_ID = :ll_contractID AND
						NTC_TC_PERIOD.PERIODE_START <= :adt_start AND  
						NTC_TC_PERIOD.PERIODE_END > :adt_start  ;
	end if
end if
if isNULL(is_voyage_number[ll_yy]) or is_voyage_number[ll_yy]= "" then
	OpenWithParm(w_enter_coda_voyagenr, ll_yy)
	is_voyage_number[ll_yy] = Message.StringParm
	IF is_voyage_number[ll_yy] = "0" THEN Return -1
end if
	
as_voyagenr = is_voyage_number[ll_yy]
return 1
end function

public function integer of_fill_transaction ();decimal {0}		ld_sum_amount_local, ld_sum_amount_DKK, ld_sum_amount_USD
long				ll_row, ll_rows
string 			ls_vessel_ref_nr, ls_voyage_nr

/* get CODA elements for SaveDRC Hire */ 
if ids_coda_elements.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id"), 5) <> 2 then return -1
if ids_coda_elements.getItemString(1, "opsa_a_or_b_post") = "A" then
	ii_Arow = 1
	ii_Brow = 2
else
	ii_Arow = 2
	ii_Brow = 1
end if

/* Set the TC currency and the exchange rates */
IF of_setExrate() = -1 then Return -1

////// SET KEYS FOR QUERY PURPOSE //////////////////////////////////////////////////////
IF ids_apost.SetItem(1,"trans_type","TCCODARec") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_opsa_hire_savedrc_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.agent_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_opsa_hire_savedrc_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.pcn) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_opsa_hire_savedrc_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF
////////////////////////////////////////////////////////////////////////////////////////


/////// SET STANDARD VALUES ////////////////////////////////////////////////////////////

/* Set field no. 6  DocCode  */
IF ids_apost.SetItem(1, "f06_doccode", ids_default_values.GetItemString(1, "doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 9 DocDate */
IF ids_apost.SetItem(1, "f09_docdate", istr_trans_input.doc_date) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 09 (Docdate) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 13  General Ledger Account  */
IF ids_apost.SetItem(1, "f13_el3", ids_coda_elements.getItemString(ii_Arow, "opsa_el3") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Own) (Element 3) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 14  Nominal Account  */
IF ids_apost.SetItem(1, "f14_el4",  ids_coda_elements.getItemString(ii_Arow, "opsa_el4") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Foreign) (Element 4) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 15  Vessel, Department or Agent  */
/* Change made by REM 01-11-02, alphanumeric vessel number */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	//COMMIT;   no commit as part of LUW
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

if isNull( ids_coda_elements.getItemString(ii_Arow, "opsa_el5")) then
	IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
		Return(-1)
	END IF
else
	IF ids_apost.SetItem(1,"f15_el5", ids_coda_elements.getItemString(ii_Arow, "opsa_el5")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
		Return(-1)
	END IF
end if

/* Set field no. 16 Voyage  (Element 6) 
	Voyagenumber set after bpost as date is set in of_bpost() */
	
/* Set field no. 17  PortCode  */
if isNull( ids_coda_elements.getItemString(ii_Arow, "opsa_el7")) then
	IF ids_apost.SetItem(1, "f17_el7", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
		Return(-1)
	END IF
else
	IF ids_apost.SetItem(1, "f17_el7", ids_coda_elements.getItemString(ii_Arow, "opsa_el7")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
		Return(-1)
	END IF
end if

/* Set field no. 19  Supplier identification (always blank)  */
IF ids_apost.SetItem(1, "f19_custsupp", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 20  (always blank)  */
IF ids_apost.SetItem(1, "f20_invoicenr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 20 (Invoice No.) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 21 Voucher no. (always blank) */
IF ids_apost.SetItem(1, "f21_vouchernr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 21 (Voucher No.) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control no. (always blank) */
IF ids_apost.SetItem(1, "f22_controlnr", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 22 (Control No.) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 23  APM Supplier - same as nominal account (always blank)   */
IF ids_apost.SetItem(1, "f23_paytype_or_sup", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 23 (APM Supplier) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 28  Currency Code  */
IF ids_apost.SetItem(1, "f28_curdoc", is_tc_currency) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 28 (CurDoc) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 41  Linedescr  */
/* This text must never be changed as it is used to identify the transaction in the log */
IF ids_apost.SetItem(1, "f41_linedesr", "TC OPSA DRC (Hire)") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field PaymentID */
istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")
IF ids_apost.SetItem(1, "payment_id", istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field Payment_ID for A-post. Object:  u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/**************************************************************************************/
/* GENERER ALLE B-POSTERINGERNE OG OPSUMMER HVAD DER SÅ SKAL STÅ I A-POST             */
/**************************************************************************************/

///* Kald B-post for Hire */
IF of_bpost() = -1 THEN Return(-1)

/* Set field no. 11  Activity Periode  */
IF ids_apost.SetItem(1, "f11_el1", string(idt_payment_start, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 16 Voyage  (Element 6) */
if isNull(ids_coda_elements.getItemString(ii_Arow, "opsa_el6")) then
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for A-post. Object: u_transaction_opsa_hire_saveDRC_coda, function: of_fill_transaction")
		Return(-1)
	END IF
	IF ids_apost.SetItem(1, "f16_el6", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (Element 6) for A-post. Object: u_transaction_opsa_hire_saveDRC_coda, function: of_fill_transaction")
		Return(-1)
	END IF
else
	IF ids_apost.SetItem(1, "f16_el6", ids_coda_elements.getItemString(ii_Arow, "opsa_el6")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for A-post. Object: u_transaction_opsa_hire_saveDRC_coda, function: of_fill_transaction")
		Return(-1)
	END IF
end if	

/* Set field no. 08 DocLineNumber for all B-posts */
ll_rows = ids_bpost.rowCount()
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		IF ids_bpost.SetItem(ll_row, "f08_doclinenum_b", ll_row +1) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 08 (Doclinenumber) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_bpost")
			Return(-1)
		end if
		IF ids_bpost.getItemNumber(ll_row, "f29_debitcredit") = 160 then
			ld_sum_amount_local += ids_bpost.getItemDecimal(ll_row, "f30_valuedoc")
			ld_sum_amount_DKK += ids_bpost.getItemDecimal(ll_row, "f32_valuehome")
			ld_sum_amount_USD += ids_bpost.getItemDecimal(ll_row, "f34_vatamo_or_valdual")
		ELSE
			ld_sum_amount_local -= ids_bpost.getItemDecimal(ll_row, "f30_valuedoc")
			ld_sum_amount_DKK -= ids_bpost.getItemDecimal(ll_row, "f32_valuehome")
			ld_sum_amount_USD -= ids_bpost.getItemDecimal(ll_row, "f34_vatamo_or_valdual")
		END IF
	next
end if

/* Set field no. 29 (DebitCredit) */
IF ld_sum_amount_local > 0 THEN
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
		Return(-1)
	END IF
ELSE
	IF ids_apost.SetItem(1, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_apost.SetItem(1, "f30_valuedoc", abs(ld_sum_amount_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_apost.SetItem(1, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
IF ids_apost.SetItem(1, "f32_valuehome", abs(ld_sum_amount_DKK)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_apost.SetItem(1, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
IF ids_apost.SetItem(1, "f34_vatamo_or_valdual", abs(ld_sum_amount_USD)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_apost.SetItem(1, "f35_vattyp_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for A-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_fill_transaction")
	Return(-1)
END IF

Return(1)
end function

private function integer of_default_bpost ();/* Insert new B-post */
il_bpost_row = ids_bpost.InsertRow(0)

/* Set field no. 03 (Fiscal Year) */
IF ids_bpost.SetItem(il_bpost_row, "f03_yr", ids_apost.GetItemNumber(1, "f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 03 (Fiscal Year) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 04 (Period) */
IF ids_bpost.SetItem(il_bpost_row, "f04_period", ids_apost.GetItemNumber(1, "f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 04 (Period) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 12 (Element 2) */
IF ids_bpost.SetItem(il_bpost_row, "f12_el2_b", ids_apost.GetItemString(1, "f12_el2")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 12 (Element 2) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 18 (Element 8) (Always Blank) */
IF ids_bpost.SetItem(il_bpost_row, "f18_el8_b", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 18 (NULL) (Element 8) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 19 (Customer or Supplier) */
IF ids_bpost.SetItem(il_bpost_row, "f19_custsupp", ids_apost.GetItemString(1, "f19_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 19 (CustSupp) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 27 (linetype) */
IF ids_bpost.SetItem(il_bpost_row, "f27_linetype", ids_default_values.GetItemNumber(1, "linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 27 (Linetype) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 31 (Valuedoc_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 31 (Valuedoc_dp) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 33 (Valuehome_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no. 35 (Valuedual_dp) */
IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
	Return(-1)
END IF

return(1)
end function

private function integer of_bpost ();/* Transaction for SaveDRC Hire  */

n_ds			lds_hire_detail
long			ll_rows
decimal{0}	ld_hire_local, ld_hire_DKK, ld_hire_USD, ld_adrcomm
string			ls_voyage_nr

lds_hire_detail = create n_ds
lds_hire_detail.dataObject = "d_payment_settle_hire"
lds_hire_detail.setTransObject(SQLCA)
ll_rows = lds_hire_detail.retrieve(istr_trans_input.settle_tc_payment.getItemNumber(1, "payment_id"))
if ll_rows < 1 then
	of_messagebox("Retrival error", "Can't retrieve any hire detail. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
end if

idt_payment_start = lds_hire_detail.getItemDatetime(1, "periode_start")
idt_payment_end	= lds_hire_detail.getItemDatetime(ll_rows, "periode_end")

/* Create row and set defaults */
IF of_default_bpost() = -1 then return -1

/* Set field no. 11 (Element 1) */
IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(idt_payment_start, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Set field no. 13 (Element 3) */
IF ids_bpost.SetItem(il_bpost_row, "f13_el3_b",  ids_coda_elements.getItemString(ii_Brow, "opsa_el3")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 13 (Element 3) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Set field no. 14 (Element 4) */
IF	ids_bpost.SetItem(il_bpost_row, "f14_el4_b",ids_coda_elements.getItemString(ii_Brow, "opsa_el4")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 14 (Element 4) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Set field no. 15 (Element 5) */
if isNull(ids_coda_elements.getItemString(ii_Brow, "opsa_el5")) then
	IF ids_bpost.SetItem(il_bpost_row, "f15_el5_b", ids_apost.GetItemString(1, "f15_el5")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 15 (NULL) (Element 5) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
		Return(-1)
	END IF
else
	IF ids_bpost.SetItem(il_bpost_row, "f15_el5_b", ids_coda_elements.getItemString(ii_Brow, "opsa_el5")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 15 (NULL) (Element 5) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_default_bpost")
		Return(-1)
	END IF
end if

/* Set field no. 16 (Element 6) */
if isNull(ids_coda_elements.getItemString(ii_Brow, "opsa_el6")) then
	IF of_getVoyagenr(idt_payment_start, ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_default_values.GetItemString(1, "prefix_voyage") + ls_voyage_nr) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
else
	IF ids_bpost.SetItem(il_bpost_row, "f16_el6_b", ids_coda_elements.getItemString(ii_Brow, "opsa_el6")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 16 (NULL) (Element 6) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
end if	

/* Set field no. 17 (Element 7) (Always Blank) */
if isNull(ids_coda_elements.getItemString(ii_Brow, "opsa_el7")) then
	IF ids_bpost.SetItem(il_bpost_row, "f17_el7_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (NULL) (Element 7) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
else
	IF ids_bpost.SetItem(il_bpost_row, "f17_el7_b", ids_coda_elements.getItemString(ii_Brow, "opsa_el7")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 17 (NULL) (Element 7) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
end if	

/* Calculate hire */
n_opsa_calculation 	lnv_opsa
lnv_opsa = create n_opsa_calculation
decimal {2} ld_hire_amount

if lnv_opsa.of_setrates( istr_trans_input.settle_tc_payment.getItemNumber(1, "contract_id")) = -1 then
	of_messagebox("Retrieve Error", "Retrieval of Bareboat rates failed for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	destroy  lnv_opsa
	return -1
end if
if istr_trans_input.settle_tc_payment.getItemNumber(1, "monthly_rate") = 1 then
	if lnv_opsa.of_calcAmountMonthlyRate( idt_payment_start , idt_payment_end , ld_hire_amount, 3 ) = -1 then
		of_messagebox("Calculation Error", "Error calculating Bareboat hire for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		destroy  lnv_opsa
		return -1
	end if
else
	if lnv_opsa.of_calcAmountDailyRate( idt_payment_start , idt_payment_end , ld_hire_amount, 3 ) = -1 then
		of_messagebox("Calculation Error", "Error calculating Bareboat hire for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		destroy  lnv_opsa
		return -1
	end if
end if	

ld_hire_local = ld_hire_amount * 100	//remove decimal places
destroy  lnv_opsa

/* Set field no. 29 (DebitCredit) */
IF ld_hire_local > 0 THEN
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_credit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
ELSE
	IF ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_default_values.GetItemNumber(1, "debitcredit_debit")) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
		Return(-1)
	END IF
END IF

/* Set field no. 30 (Valuedoc) */
IF ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_hire_local)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Set field no. 32 (Valuehome) */
ld_hire_DKK = ld_hire_local * id_exrate_TC_to_DKK / 100
IF ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_hire_DKK)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Set field no. 34 (Valuedual) */
ld_hire_USD = ld_hire_local * id_exrate_TC_to_USD / 100
IF ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_hire_usd)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (Valuedual) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Set field no. 41 (Linedescr) */
/* This text must never be changed as it is used to identify the transaction in the log */
IF ids_bpost.SetItem(il_bpost_row, "f41_linedesr", "TC OPSA DRC (Hire)") <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 41 (Linedescr) for B-post. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

/* Periodiser transaction hvis nødvendigt */
if of_periodiser_bpost(il_bpost_row, idt_payment_start, idt_payment_end) = -1 then
	of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_opsa_hire_savedrc_coda, function: of_bpost")
	Return(-1)
END IF

return(1)
end function

on u_transaction_opsa_hire_savedrc_coda.create
call super::create
end on

on u_transaction_opsa_hire_savedrc_coda.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_coda_elements = create n_ds
ids_coda_elements.DataObject = "d_opsa_posting_element"
ids_coda_elements.setTransObject(sqlca)

end event

