$PBExportHeader$u_transaction_bunker.sru
$PBExportComments$Inherited from u_transaction . Generates bunker consumption transaction
forward
global type u_transaction_bunker from u_transaction
end type
end forward

global type u_transaction_bunker from u_transaction
end type
global u_transaction_bunker u_transaction_bunker

type variables
long   il_bpost_row
end variables

forward prototypes
public function integer of_fill_transaction ()
private function integer of_default_bpost ()
public subroutine documentation ()
end prototypes

public function integer of_fill_transaction ();// Set all fields for Bunker Consumption that has not been set in default functions.
// Field 7 (Docnum) is not set before file creation., li_temp_integer
String 		ls_string, ls_prefix, ls_century, ls_yr, ls_temp_string 
String 		ls_vessel_ref_nr
Boolean		lb_first_bpost=true
Datetime 	ldt_datetime
Integer 		li_period, li_debit_kredit, li_trans_rows, li_row
Decimal {0} ld_no_decimal
decimal {2}	ld_bunker_amount_b_sum, ld_bunker_ton_b_sum
string		ls_message, ls_subject, ls_errorMessage

long ll_email_row
string ls_receivermail[]
n_bunker_posting_control lnv_bunkerControl
mt_n_outgoingmail  lnv_mail

Boolean	lb_email_error,	lb_nonMThandled = false

////// SET KEYS FOR QUERY PURPOSE //////////

IF ids_apost.SetItem(1,"trans_type","Bunker") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////

/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_bunker, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 9  DocDate  */
IF ids_apost.SetItem(1,"f09_docdate", DateTime(Today(), Now())) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 09 (DocDate) for A-post. Object: u_transaction_bunker, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 11  Element 1  */
SELECT MAX(POC.PORT_DEPT_DT)
	INTO	:ldt_datetime
	FROM	POC
	WHERE	VESSEL_NR = :istr_trans_input.vessel_no AND
				substring(POC.VOYAGE_NR, 1, 5) =	:istr_trans_input.voyage_no ;
COMMIT;

IF ids_apost.SetItem(1,"f11_el1", string(ldt_datetime, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3 */
IF ids_apost.SetItem(1,"f13_el3", ids_default_values.GetItemString(1,"bunker_a_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4 */
IF ids_apost.SetItem(1,"f14_el4", ids_default_values.GetItemString(1,"bunker_a_acc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5 */
ls_prefix = ids_default_values.GetItemString(1,"prefix_vessel")
/* Change made by REM 01-11-02, alphanumeric vessel number */
SELECT VESSEL_REF_NR 
	INTO :ls_vessel_ref_nr 
	FROM VESSELS 
	WHERE VESSEL_NR = :istr_trans_input.vessel_no;
IF SQLCA.SQLCode = 0 THEN
	COMMIT;
ELSE
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF
	
ls_string = ls_prefix + ls_vessel_ref_nr
//ls_string = ls_prefix + string(istr_trans_input.vessel_no,"000")

IF ids_apost.SetItem(1,"f15_el5", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.16 Element 6*/
IF ids_apost.SetItem(1,"f16_el6", ids_default_values.GetItemString(1,"prefix_voyage")+ istr_trans_input.voyage_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.28 Curdoc )*/
IF ids_apost.SetItem(1,"f28_curdoc", "USD") <> 1 THEN
	of_messagebox("Set value error", "Cant set Curdoc for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr",ids_default_values.GetItemString(1,"default_comments_bunker")) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Start filling in values for each bunker type . Starting with HFO, DO, GO, LSHFO */
/* Fill HFO b-post if bunker type used */
if isNull(istr_trans_input.s_bunker_values.hfo_amount) then istr_trans_input.s_bunker_values.hfo_amount = 0
if isNull(istr_trans_input.s_bunker_values.do_amount) then istr_trans_input.s_bunker_values.do_amount = 0
if isNull(istr_trans_input.s_bunker_values.go_amount) then istr_trans_input.s_bunker_values.go_amount = 0
if isNull(istr_trans_input.s_bunker_values.lshfo_amount) then istr_trans_input.s_bunker_values.lshfo_amount = 0
if istr_trans_input.s_bunker_values.hfo_amount <> 0 then
	if of_default_bpost() = -1 then
		return -1
	end if
	/* Set field no. 14 Element 4 */
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1, "bunker_b_hfo_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(HSFO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
	IF istr_trans_input.s_bunker_values.hfo_amount >= 0 THEN
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit")
		ld_no_decimal = 100 * Round(istr_trans_input.s_bunker_values.hfo_amount,2)	
	ELSE
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
		ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.s_bunker_values.hfo_amount,2)))
	END IF
	ld_bunker_amount_b_sum +=istr_trans_input.s_bunker_values.hfo_amount
	/* Set field no.36 Bunker ton*/
	IF ids_bpost.SetItem(il_bpost_row,"f36_bunkerton", istr_trans_input.s_bunker_values.hfo_ton) <> 1 THEN
		of_messagebox("Set value error", "Cant set Bunker Ton for B-post(HSFO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	ld_bunker_ton_b_sum += istr_trans_input.s_bunker_values.hfo_ton
	/* Set field no.29 debit/credit */
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", li_debit_kredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post(HSFO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.30 valuedoc */
	IF ids_bpost.SetItem(il_bpost_row ,"f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post(HSFO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
END IF
/* Fill DO b-post if bunker type used */
if istr_trans_input.s_bunker_values.do_amount <> 0 then
	if of_default_bpost() = -1 then
		return -1
	end if
	/* Set field no. 14 Element 4 */
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1, "bunker_b_do_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(LSGO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
	IF istr_trans_input.s_bunker_values.do_amount >= 0 THEN
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit")
		ld_no_decimal = 100 * Round(istr_trans_input.s_bunker_values.do_amount,2)	
	ELSE
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
		ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.s_bunker_values.do_amount,2)))
	END IF
	ld_bunker_amount_b_sum +=istr_trans_input.s_bunker_values.do_amount
	/* Set field no.36 Bunker ton*/
	IF ids_bpost.SetItem(il_bpost_row,"f36_bunkerton", istr_trans_input.s_bunker_values.do_ton) <> 1 THEN
		of_messagebox("Set value error", "Cant set Bunker Ton for B-post(LSGO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	ld_bunker_ton_b_sum += istr_trans_input.s_bunker_values.do_ton
	/* Set field no.29 debit/credit */
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", li_debit_kredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post(LSGO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.30 valuedoc */
	IF ids_bpost.SetItem(il_bpost_row ,"f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post(LSGO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
END IF
/* Fill GO b-post if bunker type used */
if istr_trans_input.s_bunker_values.go_amount <> 0 then
	if of_default_bpost() = -1 then
		return -1
	end if
	/* Set field no. 14 Element 4 */
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1, "bunker_b_go_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(HSGO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
	IF istr_trans_input.s_bunker_values.go_amount >= 0 THEN
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit")
		ld_no_decimal = 100 * Round(istr_trans_input.s_bunker_values.go_amount,2)	
	ELSE
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
		ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.s_bunker_values.go_amount,2)))
	END IF
	ld_bunker_amount_b_sum +=istr_trans_input.s_bunker_values.go_amount
	/* Set field no.36 Bunker ton*/
	IF ids_bpost.SetItem(il_bpost_row,"f36_bunkerton", istr_trans_input.s_bunker_values.go_ton) <> 1 THEN
		of_messagebox("Set value error", "Cant set Bunker Ton for B-post(HSGO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	ld_bunker_ton_b_sum += istr_trans_input.s_bunker_values.go_ton
	/* Set field no.29 debit/credit */
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", li_debit_kredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post(HSGO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.30 valuedoc */
	IF ids_bpost.SetItem(il_bpost_row ,"f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post(HSGO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
END IF
/* Fill LSHFO b-post if bunker type used */
if istr_trans_input.s_bunker_values.lshfo_amount <> 0 then
	if of_default_bpost() = -1 then
		return -1
	end if
	/* Set field no. 14 Element 4 */
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1, "bunker_b_lshfo_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(LSFO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
	IF istr_trans_input.s_bunker_values.lshfo_amount >= 0 THEN
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit")
		ld_no_decimal = 100 * Round(istr_trans_input.s_bunker_values.lshfo_amount,2)	
	ELSE
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
		ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.s_bunker_values.lshfo_amount,2)))
	END IF
	ld_bunker_amount_b_sum +=istr_trans_input.s_bunker_values.lshfo_amount
	/* Set field no.36 Bunker ton*/
	IF ids_bpost.SetItem(il_bpost_row,"f36_bunkerton", istr_trans_input.s_bunker_values.lshfo_ton) <> 1 THEN
		of_messagebox("Set value error", "Cant set Bunker Ton for B-post(LSFO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	ld_bunker_ton_b_sum += istr_trans_input.s_bunker_values.lshfo_ton
	/* Set field no.29 debit/credit */
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", li_debit_kredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post(LSFO). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.30 valuedoc */
	IF ids_bpost.SetItem(il_bpost_row ,"f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post(LSFO). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
END IF

 /* Start filling in values for offservices if they shall be posted */
/* First offService B-post */
if istr_trans_input.s_bunker_values.offservice_amount <> 0 then
	// find out if profitcenter is marked as "non-MT commercially handled"
	SELECT P.NON_APM_COMM_HANDLED
	INTO :lb_nonMThandled
	FROM PROFIT_C P, VESSELS V
	WHERE P.PC_NR = V.PC_NR
	AND V.VESSEL_NR = :istr_trans_input.vessel_no; 
	
	if of_default_bpost() = -1 then
		return -1
	end if
	/* Set field no.13 Element 3*/
	IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"bunker_a_gl")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 3 for B-post(1st offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no. 14 Element 4 */
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1, "bunker_a_acc")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(1st offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no. 16 Element 6 */
	IF ids_bpost.SetItem(il_bpost_row,"f16_el6_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(1st offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
	IF istr_trans_input.s_bunker_values.offservice_amount >= 0 THEN
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_credit")
		ld_no_decimal = 100 * Round(istr_trans_input.s_bunker_values.offservice_amount,2)	
	ELSE
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit") 
		ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.s_bunker_values.offservice_amount,2)))
	END IF
	/* Set field no.36 Bunker ton (zero for offservice) */
	IF ids_bpost.SetItem(il_bpost_row,"f36_bunkerton", 0) <> 1 THEN
		of_messagebox("Set value error", "Cant set Bunker Ton for B-post(1st offservice). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 debit/credit */
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", li_debit_kredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post(1st offservice). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.30 valuedoc */
	IF ids_bpost.SetItem(il_bpost_row ,"f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post(1st offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.41 LineDescription */
	IF ids_bpost.SetItem(il_bpost_row,"f41_linedesr","Bunkers Off Services") <> 1 THEN
		of_messagebox("Set value error", "Cant set LineDesr for B-post(1st offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Second offService B-post */
	if of_default_bpost() = -1 then
		return -1
	end if
	/* Set field no.13 Element 3*/
	if istr_trans_input.s_bunker_values.apmvessel_or_tcinzero = true then 
		/* APM Vessel */
		IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"bunker_b_gl")) <> 1 THEN
			of_messagebox("Set value error", "Cant set el. 3 for B-post(2nd offservice). Object: u_transaction_bunker, function: of_fill_transaction")
			Return(-1)
		END IF
	else
		/* TC-IN Rate Zero */
		IF lb_nonMThandled then
			IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"bunker_b_gl")) <> 1 THEN
				of_messagebox("Set value error", "Cant set el. 3 for B-post(2nd offservice). Object: u_transaction_bunker, function: of_fill_transaction")
				Return(-1)
			END IF
		ELSE			
			IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"charterer_gl")) <> 1 THEN
				of_messagebox("Set value error", "Cant set el. 3 for B-post(2nd offservice). Object: u_transaction_bunker, function: of_fill_transaction")
				Return(-1)
			END IF
		end if
	end if
	
	/* Set field no. 14 Element 4 */
	IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1, "bunker_offservice")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(2nd offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF

	/* Set field no. 16 Element 6 */
	IF ids_bpost.SetItem(il_bpost_row,"f16_el6_b", "") <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 4 for B-post(1st offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
	IF istr_trans_input.s_bunker_values.offservice_amount >= 0 THEN
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit")
	ELSE
		li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
	END IF
	/* Set field no.36 Bunker ton*/
	IF ids_bpost.SetItem(il_bpost_row,"f36_bunkerton", 0) <> 1 THEN
		of_messagebox("Set value error", "Cant set Bunker Ton for B-post(2nd offservice). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.29 debit/credit */
	IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", li_debit_kredit) <> 1 THEN
		of_messagebox("Set value error", "Cant set DebitCredit for B-post(2nd offservice). Object: u_transaction_bunker, 	function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.30 valuedoc (same value as 1st offservice post) */
	IF ids_bpost.SetItem(il_bpost_row ,"f30_valuedoc", ld_no_decimal) <> 1 THEN
		of_messagebox("Set value error", "Cant set Valuedoc for B-post(2nd offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	/* Set field no.41 LineDescription */
	IF ids_bpost.SetItem(il_bpost_row,"f41_linedesr","Bunkers Off Services") <> 1 THEN
		of_messagebox("Set value error", "Cant set LineDesr for B-post(2nd offservice). Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
	
	/* if TC_IN Rate Zero there shall be sent a message to finance responsible person via tramos mail */
	if istr_trans_input.s_bunker_values.apmvessel_or_tcinzero = false then
		if lb_nonMThandled then
			ls_subject = "V"+ls_vessel_ref_nr+" T"+istr_trans_input.voyage_no+" Bunker during Off Service posted!"
			ls_message = "Bunker during Off Service has been posted to P&L account in CODA as per below " + "~r~n" &
								+"(Note: invoice to Head-Owner in this case is NOT Required)"+ "~r~n~r~n" &
								+"Vessel = " + ls_vessel_ref_nr + "~r~n" &
								+"Voyage = " +istr_trans_input.voyage_no+ "~r~n" &
								+"Account = "+ids_default_values.GetItemString(1,"bunker_b_gl")+"."+ids_default_values.GetItemString(1, "ntc_off_service_na")+ "~r~n" &
								+"Debit/Credit = " +string(li_debit_kredit)+ "~r~n" &
								+"Amount = "+ string(ld_no_decimal/100, "#,##0.00") + "~r~n~r~n" &
								+"Remember to control that all purchases in TRAMOS, before the date of the~r~n" &
								+"bunkers during Off Service matches CODA. If purchases have not been~r~n" &
								+"posted to CODA, do not send invoice yet."
		else
			ls_subject = "V"+ls_vessel_ref_nr+" T"+istr_trans_input.voyage_no+" Invoice Bunker during Off Service!"
			ls_message = "Remember to Invoice Bunker during Off Service that is posted in CODA~r~n~r~n" &
								+"Vessel = " + ls_vessel_ref_nr + "~r~n" &
								+"Voyage = " +istr_trans_input.voyage_no+ "~r~n" &
								+"Headowner(S#) = "+istr_trans_input.s_bunker_values.headowner_snumber+ "~r~n" &
								+"Debit/Credit = " +string(li_debit_kredit)+ "~r~n" &
								+"Amount = "+ string(ld_no_decimal/100, "#,##0.00") + "~r~n~r~n" &
								+"Remember to control that all purchases in TRAMOS, before the date of the~r~n" &
								+"bunkers during Off Service matches CODA. If purchases have not been~r~n" &
								+"posted to CODA, do not send invoice yet."
		end if
		
		lnv_bunkerControl = create n_bunker_posting_control
		lnv_bunkerControl.of_get_office_fin_emailaddr(istr_trans_input.vessel_no, istr_trans_input.full_voyage_no, ls_receivermail)
		destroy lnv_bunkerControl
		
		lb_email_error = true 
		if upperbound(ls_receivermail) > 0 then
			lnv_mail = create mt_n_outgoingmail
			if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receivermail[1], ls_subject, ls_message, ls_errorMessage) = c#return.Success then
				for ll_email_row = 2 to upperbound(ls_receivermail)
					 lnv_mail.of_addreceiver(ls_receivermail[ll_email_row], ls_errorMessage)
				next							
				if lnv_mail.of_sendmail(ls_errorMessage) = c#return.Success then lb_email_error = false
			end if
			destroy lnv_mail
		end if
		if lb_email_error then
			of_messagebox("Send mail to finance responsible failed", ls_errorMessage)
			return -1
		end if
	end if
END IF

/////////////////////// set a-post values //////////////////////////
/* Set field no.29 and 30 DebitCredit and Valuedoc )*/
IF ld_bunker_amount_b_sum >= 0 THEN
	li_debit_kredit= ids_default_values.GetItemNumber(1,"debitcredit_credit")
	ld_no_decimal = 100 * Round(ld_bunker_amount_b_sum, 2)	
ELSE
	li_debit_kredit = ids_default_values.GetItemNumber(1,"debitcredit_debit") 
	ld_no_decimal = 100 * (-1 * (Round(ld_bunker_amount_b_sum,2)))
END IF
	
IF ids_apost.SetItem(1,"f29_debitcredit", li_debit_kredit) <> 1 THEN
	of_messagebox("Set value error", "Cant set debitcredit for A-post. Object: u_transaction_bunker, 	function: of_fill_transaction")
	Return(-1)
END IF
	
IF ids_apost.SetItem(1,"f30_valuedoc",ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.36 Bunker ton*/
IF ids_apost.SetItem(1,"f36_bunkerton", ld_bunker_ton_b_sum ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Bunker Ton for A-post. Object: u_transaction_bunker, function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.8 Doclinenum in B-row */
FOR li_row = 1 to ids_bpost.RowCount()
	IF ids_bpost.SetItem(li_row, "f08_doclinenum_b", li_row + 1) <> 1 THEN
		of_messagebox("Set value error", "Cant set doclinenum for B-post. Object: u_transaction_bunker, function: of_fill_transaction")
		Return(-1)
	END IF
NEXT

Return 1
end function

private function integer of_default_bpost ();string ls_century, ls_temp_string,  ls_vessel_ref_nr, ls_string
datetime ldt_datetime

// SET B POSTS (first all default values) /////////////////
il_bpost_row = ids_bpost.InsertRow(0)

/* Set General fields for row no. 1*/
/* Set field no.3 Year*/
IF ids_bpost.SetItem(il_bpost_row,"f03_yr", ids_apost.GetItemNumber(1,"f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set year for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.4 Period*/
IF ids_bpost.SetItem(il_bpost_row,"f04_period", ids_apost.GetItemNumber(1,"f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set period for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
IF Left(istr_trans_input.voyage_no,2) >= "50" THEN
	ls_century = "19"
ELSE
	ls_century = "20"
END IF

SELECT MIN(POC.PORT_ARR_DT)
	INTO	:ldt_datetime
	FROM	POC
	WHERE	VESSEL_NR = :istr_trans_input.vessel_no AND
				substring(POC.VOYAGE_NR, 1, 5) =	Substring(:istr_trans_input.voyage_no,1, 5);
COMMIT;

ls_temp_string = string(ldt_datetime, "YYYY")

IF ls_temp_string <> (ls_century + Left(istr_trans_input.voyage_no,2)) THEN
	ls_string = (ls_century + Left(istr_trans_input.voyage_no,2) + "01")
ELSE
	ls_string = string(ldt_datetime, "YYYYMM")
END IF

IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(il_bpost_row,"f12_el2_b", ids_default_values.GetItemString(1,"el2_coda_b")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"bunker_b_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.15 Element 5*/
IF ids_bpost.SetItem(il_bpost_row,"f15_el5_b", ids_apost.getItemString(1, "f15_el5")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(il_bpost_row,"f16_el6_b", ids_default_values.GetItemString(1,"prefix_voyage") &
									+ istr_trans_input.voyage_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(il_bpost_row,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_bunker, 	function: of_default_bpost")
	Return(-1)
END IF

/* Set field no.31 Valuedoc dp*/
IF ids_bpost.SetItem(il_bpost_row,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_bunker, function: of_default_bpost")
	Return(-1)
END IF

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_bunker
   <OBJECT> Post of bunker consumption - CODA transaction</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   otherobjs</ALSO>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		00/00/07		?     		Name Here	First Version
		14/02-11		2277  		JMC			f03 and f04 fields are defined in default_coda function
		13/05-11		2390  		RMO003		Bunke during off-service on 'Non-MT commercially handled' vessels
		19/04-12		2758  		JMC			Changed nominal account for bunker off service
		15/05/13		2690   		LGX001		1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
														2.change "@maersk.com" 			 as C#EMAIL.DOMAIN
		23/01/14		2921UAT		LGX001		if TC_IN Rate Zero there shall be sent a message to finance responsible person via tramos mail
														The following is the order of getting finance email address :
														1. On single, position voyage (i.e. all types with 5-digit voyage numbers, except for Idle voyage) 
															vessel-voyage > allocated calculation > CP attached to calculation > office.
														2. on TC voyages (ie. 7-digit voyage numbers)
															vessel-voyage > connected TC-out contract (use F2 as user in application) > office.
														3.Only if the above steps fail, the email address of the Finance responsible as per Vessels system table should be used.
		27/07/15		XSZ004		CR3226		Change label for Bunkers type.
	</HISTORY>
********************************************************************/
end subroutine

on u_transaction_bunker.create
call super::create
end on

on u_transaction_bunker.destroy
call super::destroy
end on

