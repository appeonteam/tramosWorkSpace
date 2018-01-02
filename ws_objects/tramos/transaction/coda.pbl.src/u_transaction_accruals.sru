$PBExportHeader$u_transaction_accruals.sru
$PBExportComments$Used in the accruals processing.  For income and expenses.
forward
global type u_transaction_accruals from u_transaction
end type
end forward

global type u_transaction_accruals from u_transaction
end type
global u_transaction_accruals u_transaction_accruals

forward prototypes
public subroutine documentation ()
public function integer of_fill_transaction ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_accruals
  
   <OBJECT> Used inside the w_variations_input window, used to assist in gneration of ACCRUALS</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   u_transaction_additonalposts</ALSO>
    Date   	Ref    		Author      Comments
  20/01/11 	CR2183      AGL 		 	First Version
  01/03/11	CR2288		AGL			Tidy up logic within	
  23/05/11  CR2464		AGL			Included negative receivable/payable & split bunker into Income on  TC-Out
********************************************************************/


end subroutine

public function integer of_fill_transaction ();/* 
AGL 
TODO:  this is a copy of original u_transaction_variation objects of_fill_transaction.
The only task inside this object in to update this.
*/

// Set all fields for Calculations that has not been set in default functions.
// Field 7 (Docnum) is not set before file creation.

Integer li_result_grossfrt, li_integer, li_period, li_year, li_month, li_day, li_voyage_type
String ls_string, ls_prefix, ls_century, ls_yr, ls_temp_string, ls_userinput
String ls_gl_apost, ls_gl_bpost, ls_port, ls_amount, ls_nominal    
String ls_vessel_ref_nr
Datetime ldt_datetime
Decimal {0} ld_no_decimal, ld_no_decimal_home
Decimal {2} ld_exrate, ld_amount

/* set the variables port, gl, nominal and amount. */

ld_amount = istr_trans_input.variations_amount

CHOOSE CASE istr_trans_input.variations_nomdescription
	CASE "freightinc"
		/* freight/tc income */										
		if istr_trans_input.variations_voyagetype = 2 then
			SetNull(ls_port)
			if istr_trans_input.variations_ignoreddays>0 then
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_part_gl")	
			else
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_full_gl")
			end if
			ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_rec_gl")
			ls_nominal = ids_default_values.GetItemString(1,"ntc_hire_na")
		else
			SetNull(ls_port)
			if istr_trans_input.variations_ignoreddays>0 then
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_part_gl")	
			else
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_full_gl")
			end if
			ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_rec_gl")
			ls_nominal = ids_default_values.GetItemString(1,"calc_frt_nominal")
		end if

	CASE "miscinc"
		/* demurrage/misc. income */								
		if istr_trans_input.variations_voyagetype = 2 then
			SetNull(ls_port)
			if istr_trans_input.variations_ignoreddays>0 then
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_part_gl")	
			else
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_full_gl")
			end if
			ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_rec_gl")
			ls_nominal = ids_default_values.GetItemString(1,"ntc_hire_misc_income")
		else
			SetNull(ls_port)
			if istr_trans_input.variations_ignoreddays>0 then
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_part_gl")	
			else
				ls_gl_apost = ids_default_values.GetItemString(1,"accruals_apost_rec_full_gl")
			end if
			ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_rec_gl")
			ls_nominal = ids_default_values.GetItemString(1,"calc_dem_nominal")
		end if

	CASE "comm"
		/* commisions */						
		/* was commented out previously */
		SetNull(ls_port)
		ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_pay_gl")
		ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_pay_gl")
		ls_nominal = ids_default_values.GetItemString(1,"commission_acc")

	CASE "miscexp"
		/* misc. expense */				
		if istr_trans_input.variations_voyagetype = 2 then
			SetNull(ls_port)
			ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_pay_gl")
			ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_pay_gl")
			ls_nominal = ids_default_values.GetItemString(1,"ntc_hire_misc_expenses")
		else
			SetNull(ls_port)
			ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_pay_gl")
			ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_pay_gl")
			ls_nominal = ids_default_values.GetItemString(1,"calc_misc_nominal")
		end if

	CASE "bunker"
		/* bunker expense */		
		SetNull(ls_port)
		ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_pay_gl")
		ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_pay_gl")
		ls_nominal = ids_default_values.GetItemString(1,"bunker_b_hfo_acc")
	
	CASE ELSE  /* port expense */
		ls_port   = istr_trans_input.port
		ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_pay_gl")
		ls_gl_bpost = ids_default_values.GetItemString(1,"calc_b_accruals_pay_gl")
		ls_nominal = ids_default_values.GetItemString(1,"calc_port_nominal")

END CHOOSE

if isnull(ld_amount) then ld_amount = 0

/* test negative receivable/payable and set the gl post for all nom types accordingly */
if ld_amount < 0 then
	CHOOSE CASE istr_trans_input.variations_nomdescription
		CASE "freightinc", "miscinc"
			ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_neg_rec_gl")		
		CASE "comm", "miscexp", "bunker"
			ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_neg_pay_gl")		
		CASE ELSE /* port expense */
			ls_gl_apost = ids_default_values.GetItemString(1,"calc_a_accruals_neg_pay_gl")		
	END CHOOSE
end if		


////// SET KEYS FOR QUERY PURPOSE //////////

IF ids_apost.SetItem(1,"trans_type","Calc") <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////

/* Set field no. 3  Accounting Year  */
li_year = istr_trans_input.variations_year
li_month = istr_trans_input.variations_month
// ld_exrate = istr_trans_input.variations_exrate

IF ids_apost.SetItem(1,"f03_yr", li_year) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 03 (Accounting year) for A-post. Object: u_transaction_variation, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 4 Accounting period  */
IF ids_apost.SetItem(1,"f04_period", li_month) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 04 (Accounting period) for A-post. Object: u_transaction, function: of_default_cms")
	Return(-1)
END IF
 
/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_coda_variations")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_variation, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 9 doc. date */

CHOOSE CASE li_month
	CASE 1,3,5,7,8,10,12
		li_day = 31
	CASE 2
		li_day = 28
	CASE ELSE
		li_day = 30
END CHOOSE
	
IF ids_apost.SetItem(1,"f09_docdate", Date(li_year,li_month,li_day)  ) <> 1 THEN
	of_messagebox("Set value error", "Cant set docdate for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f11_el1", String(li_year,"0000") + String(li_month,"00")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.1 for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF



/* Set field no.13 Element 3 */
IF ids_apost.SetItem(1,"f13_el3", ls_gl_apost) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4 */

IF ids_apost.SetItem(1,"f14_el4", ls_nominal) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
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
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_variation, function: of_fill_transaction")
	Return(-1)
END IF
	
ls_string = ls_prefix + ls_vessel_ref_nr
//ls_string = ls_prefix + string(istr_trans_input.vessel_no,"000")

IF ids_apost.SetItem(1,"f15_el5", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.16 Element 6*/
IF ids_apost.SetItem(1,"f16_el6", ids_default_values.GetItemString(1,"prefix_voyage") + LEFT(istr_trans_input.voyage_no,5)) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF istr_trans_input.variations_nomdescription = "portexp" THEN
	/* Set field no.17 Element 7. The counter will not be > 4 for TC Out so in this case this field is blank*/
	IF ids_apost.SetItem(1,"f17_el7", ids_default_values.GetItemString(1,"prefix_port") + ls_port) <> 1 THEN
		of_messagebox("Set value error", "Cant set el.6 for A-post. Object: u_transaction_variation, &
										function: of_fill_transaction")
		Return(-1)
	END IF
END IF

/* Set field no.28 Curdoc )*/
IF ids_apost.SetItem(1,"f28_curdoc", "USD") <> 1 THEN
	of_messagebox("Set value error", "Cant set Curdoc for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29, 30, 31, 32, 33 DebitCredit, Valuedoc, Value home, decimal points */
IF istr_trans_input.variations_nomdescription = "freightinc" OR istr_trans_input.variations_nomdescription = "miscinc" then
	IF ld_amount >= 0 THEN
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit")
		ld_no_decimal = 100 * Round(ld_amount,2)	
		//ld_no_decimal_home = Round((ld_amount * ld_exrate),2)
	ELSE
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
		ld_no_decimal = 100 * (-1 * (Round(ld_amount,2)))
		//ld_no_decimal_home = -1 * Round((ld_amount * ld_exrate),2)
	END IF
ELSE	
	IF ld_amount >= 0 THEN
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit")
		ld_no_decimal = 100 * Round(ld_amount,2)	
		//ld_no_decimal_home = Round((ld_amount * ld_exrate),2)
	ELSE
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit") 
		ld_no_decimal = 100 * (-1 * (Round(ld_amount,2)))
		//ld_no_decimal_home = -1 * Round((ld_amount * ld_exrate),2)
	END IF
END IF


IF ids_apost.SetItem(1,"f29_debitcredit", li_integer) <> 1 THEN
	of_messagebox("Set value error", "Cant set DebitCredit for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.31 Valuedoc dp*/
IF ids_apost.SetItem(1,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

///* Set field no.32 Valuehome*/
//IF ids_apost.SetItem(1,"f32_valuehome", ld_no_decimal_home) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Valuehome for A-post. Object: u_transaction_variation, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF

/* Set field no.33 Valuehome dp*/
//IF ids_apost.SetItem(1,"f33_valuehome_dp", 2) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Valuehome dp for A-post. Object: u_transaction_variation, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF


/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr", ids_default_values.GetItemString(1,"default_comments_variations")) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF


///// SET B POSTS /////////////////////////////////////

ids_bpost.InsertRow(0)
	
/* Set field no.3 Year*/
IF ids_bpost.SetItem(1,"f03_yr", li_year) <> 1 THEN
	of_messagebox("Set value error", "Cant set year for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.4 Period*/
IF ids_bpost.SetItem(1,"f04_period", li_month) <> 1 THEN
	of_messagebox("Set value error", "Cant set period for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.8 Doclinenum*/
IF ids_bpost.SetItem(1,"f08_doclinenum_b", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set doclinenum for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
IF li_voyage_type = 2 THEN
	ls_string = ids_apost.GetItemString(1,"f11_el1")
ELSE
	SELECT 	MAX(POC.PORT_DEPT_DT)
	INTO		:ldt_datetime
	FROM		POC
	WHERE	VESSEL_NR = :istr_trans_input.vessel_no AND
			substring(POC.VOYAGE_NR, 1, 5) =	Substring(:istr_trans_input.voyage_no,1,5);
	IF SQLCA.SQLCODE <> 0 OR IsNull(ldt_datetime) THEN
		Commit;
		SELECT 	MAX(POC.PORT_DEPT_DT)
		INTO		:ldt_datetime
		FROM		POC
		WHERE	VESSEL_NR = :istr_trans_input.vessel_no AND
				substring(POC.VOYAGE_NR, 1, 5) <	:istr_trans_input.voyage_no;
		COMMIT;	
	ELSE
		COMMIT;
	END IF
	
	ls_string = string(ldt_datetime, "YYYYMM")
END IF	
IF ids_bpost.SetItem(1,"f11_el1_b", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(1,"f12_el2_b", ids_default_values.GetItemString(1,"el2_coda_b")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(1,"f13_el3_b", ls_gl_bpost ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.14 Element 4*/
IF ids_bpost.SetItem(1,"f14_el4_b", ls_nominal) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_variation, &
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
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_variation, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f15_el5_b", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF
//IF ids_bpost.SetItem(1,"f15_el5_b", ids_default_values.GetItemString(1,"prefix_vessel") + string(istr_trans_input.vessel_no,"000")) <> 1 THEN
//	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_variation, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(1,"f16_el6_b", ids_default_values.GetItemString(1,"prefix_voyage") + LEFT(istr_trans_input.voyage_no,5)) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF istr_trans_input.variations_nomdescription = "portexp" THEN
	/* Set field no.17 Element 7*/
	IF ids_bpost.SetItem(1,"f17_el7_b", ids_default_values.GetItemString(1,"prefix_port") + ls_port) <> 1 THEN
		of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_variation, &
										function: of_fill_transaction")
		Return(-1)
	END IF
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(1,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_variation, &
								function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/

IF istr_trans_input.variations_nomdescription = "freightinc" OR istr_trans_input.variations_nomdescription = "miscinc" then
	IF ld_amount >= 0 THEN
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit")
		ld_no_decimal = 100 * Round(ld_amount,2)	
		ld_no_decimal_home = Round((ld_amount * ld_exrate),2)
	ELSE
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit") 
		ld_no_decimal = 100 * (-1 * (Round(ld_amount,2)))
		ld_no_decimal_home = -1 * Round((ld_amount * ld_exrate),2)
	END IF
ELSE
		IF ld_amount >= 0 THEN
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit")
		ld_no_decimal = 100 * Round(ld_amount,2)	
		ld_no_decimal_home = Round((ld_amount * ld_exrate),2)
	ELSE
		li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
		ld_no_decimal = 100 * (-1 * (Round(ld_amount,2)))
		ld_no_decimal_home = -1 * Round((ld_amount * ld_exrate),2)
	END IF
END IF


IF ids_bpost.SetItem(1,"f29_debitcredit", li_integer) <> 1 THEN
	of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.31 Valuedoc dp*/
IF ids_bpost.SetItem(1,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_variation, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.32 Valuehome*/
//IF ids_bpost.SetItem(1,"f32_valuehome", ld_no_decimal_home) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Valuehome for B-post. Object: u_transaction_variation, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF

/* Set field no.33 Valuehome dp*/
//IF ids_bpost.SetItem(1,"f33_valuehome_dp", 2) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Valuehome dp for B-post. Object: u_transaction_variation, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF


Return 1
end function

on u_transaction_accruals.create
call super::create
end on

on u_transaction_accruals.destroy
call super::destroy
end on

