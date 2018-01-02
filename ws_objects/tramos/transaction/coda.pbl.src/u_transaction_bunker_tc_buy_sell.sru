﻿$PBExportHeader$u_transaction_bunker_tc_buy_sell.sru
$PBExportComments$Inherited from u_transaction . Generates bunker consumption transaction
forward
global type u_transaction_bunker_tc_buy_sell from u_transaction
end type
end forward

global type u_transaction_bunker_tc_buy_sell from u_transaction
end type
global u_transaction_bunker_tc_buy_sell u_transaction_bunker_tc_buy_sell

type variables

end variables

forward prototypes
public function integer of_fill_transaction ()
public subroutine documentation ()
end prototypes

public function integer of_fill_transaction ();// Set all fields for Bunker TC on DEL/RED that has not been set in default functions.
// Field 7 (Docnum) is not set before file creation.

Integer li_integer, li_period, li_stop = 1
String ls_string, ls_prefix, ls_century, ls_yr, ls_temp_string 
String ls_vessel_ref_nr
Datetime ldt_datetime
Decimal {0} ld_no_decimal
u_broker uo_broker

////// SET KEYS FOR QUERY PURPOSE //////////
if  istr_trans_input.control_no = "Sell" then
	ls_string = "BunkerTCS"
else
	ls_string = "BunkerTCB"
end if
IF ids_apost.SetItem(1,"trans_type",ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////
 
/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_bunker_tc_buy_sell, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 9  DocDate  */
IF ids_apost.SetItem(1,"f09_docdate", DateTime(Today(), Now())) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 09 (DocDate) for A-post. Object: u_transaction_bunker_tc_buy_sell, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 11  Element 1  */
SELECT 	MAX(POC.PORT_DEPT_DT)
INTO		:ldt_datetime
FROM		POC
WHERE		VESSEL_NR = :istr_trans_input.vessel_no AND
			substring(POC.VOYAGE_NR, 1,5) =	Substring(:istr_trans_input.voyage_no,1,5) ;
COMMIT;

IF IsNull(ldt_datetime) THEN
	SELECT 	MAX(POC.PORT_ARR_DT)
	INTO		:ldt_datetime
	FROM		POC
	WHERE		VESSEL_NR = :istr_trans_input.vessel_no AND
				substring(POC.VOYAGE_NR, 1, 5) =	Substring(:istr_trans_input.voyage_no,1,5) ;
	COMMIT;
END IF

IF ids_apost.SetItem(1,"f11_el1", string(ldt_datetime, "YYYYMM")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 1 for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3 */
IF ids_apost.SetItem(1,"f13_el3", ids_default_values.GetItemString(1,"bunker_a_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4 */
IF ids_apost.SetItem(1,"f14_el4", ids_default_values.GetItemString(1,"bunker_a_acc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_bunker_tc_buy_sell, &
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
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_bunker_tc_buy_sell, function: of_fill_transaction")
	Return(-1)
END IF
	
ls_string = ls_prefix + ls_vessel_ref_nr
//ls_string = ls_prefix + string(istr_trans_input.vessel_no,"000")

IF ids_apost.SetItem(1,"f15_el5", ls_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control no. */
	IF ids_apost.SetItem(1, "f22_controlnr", istr_trans_input.control_no) <> 1 THEN
		of_messagebox("Set value error", "Cant set Field 22 (Control No.) for A-post. Object: u_transaction_bunker_tc_buy_sell, function: of_fill_transaction")
		Return(-1)
	END IF
	
/* Set field no.16 Element 6*/
IF ids_apost.SetItem(1,"f16_el6", ids_default_values.GetItemString(1,"prefix_voyage") &
									+ istr_trans_input.voyage_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.28 Curdoc )*/
IF ids_apost.SetItem(1,"f28_curdoc", "USD") <> 1 THEN
	of_messagebox("Set value error", "Cant set Curdoc for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 and 30 DebitCredit and Valuedoc )*/
IF istr_trans_input.amount_usd >= 0 THEN
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit")
	ld_no_decimal = 100 * Round(istr_trans_input.amount_usd, 2)	
ELSE
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit") 
	ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.amount_usd,2)))
END IF
	
IF ids_apost.SetItem(1,"f29_debitcredit", li_integer) <> 1 THEN
	of_messagebox("Set value error", "Cant set debitcredit for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF
	
IF ids_apost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.36 Bunker ton*/
IF ids_apost.SetItem(1,"f36_bunkerton", (istr_trans_input.bunker_ton)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Bunker Ton for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr",ids_default_values.GetItemString(1,"default_comments_bunker")) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF


///// SET B POST /////////////////////////////////////

ids_bpost.InsertRow(0)

/* Set field no.3 Year*/
IF ids_bpost.SetItem(1,"f03_yr", ids_apost.GetItemNumber(1,"f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set year for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.4 Period*/
IF ids_bpost.SetItem(1,"f04_period", ids_apost.GetItemNumber(1,"f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set period for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.8 Doclinenum*/
IF ids_bpost.SetItem(1, "f08_doclinenum_b", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set doclinenum for B-post. Object: u_transaction_bunker_tc_buy_sell, &
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
	of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(1,"f12_el2_b", ids_default_values.GetItemString(1,"el2_coda_b")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(1,"f13_el3_b", ids_default_values.GetItemString(1,"charterer_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4*/	
istr_trans_input.owner_charter_nom_acc = ids_default_values.GetItemString(1,"ntc_bunker_unsettled")

if isnull(istr_trans_input.owner_charter_nom_acc) then
	MessageBox("Retrieval Error", "Not able to retrieve Bunker Unsettled nominal account number.~r~n~r~n" &
					+ "Object: u_transaction_bunker_tc_buy_sell, Function: of_fill_transaction")
	return (-1)
end if
	
IF ids_bpost.SetItem(1,"f14_el4_b", istr_trans_input.owner_charter_nom_acc) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
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
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_bunker_tc_buy_sell, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f15_el5_b", ls_prefix + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF
//IF ids_bpost.SetItem(1,"f15_el5_b", ls_prefix + string(istr_trans_input.vessel_no,"000")) <> 1 THEN
//	of_messagebox("Set value error", "Cant set el.5 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(1,"f16_el6_b", ids_default_values.GetItemString(1,"prefix_voyage") &
									+ Left(istr_trans_input.voyage_no,5)) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(1,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

///* Set field no.29 and 30 DebitCredit and Valuedoc (29 opposite of A)*/
IF istr_trans_input.amount_usd >= 0 THEN
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_credit")
	ld_no_decimal = 100 * Round(istr_trans_input.amount_usd,2)	
ELSE
	li_integer = ids_default_values.GetItemNumber(1,"debitcredit_debit") 
	ld_no_decimal = 100 * (-1 * (Round(istr_trans_input.amount_usd,2)))
END IF
	
IF ids_bpost.SetItem(1,"f29_debitcredit", li_integer) <> 1 THEN
	of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_bpost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.31 Valuedoc dp*/
IF ids_bpost.SetItem(1,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_bunker_tc_buy_sell, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.36 Bunker ton ****** always NULL in b-post */
//IF ids_bpost.SetItem(1,"f36_bunkerton", istr_trans_input.bunker_ton) <> 1 THEN
//	of_messagebox("Set value error", "Cant set Bunker Ton for B-post. Object: u_transaction_bunker_tc_buy_sell, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF


Return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_bunker_tc_buy_sell
   <OBJECT> Post of bunker  - CODA transaction</OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
  14/02/2012	2277	JMC		f03 and f04 fields are defined in default_coda function
  25/03/2012	2277	JMC		Add information "Buy" and "Sell" in Field 22
  27/03/2012	FIN    JMC		Split Buy and Sell transactions
  10/07/2012	2850	JMC		Reactivate code to display voyage number in A-post
  07/11/2012	2780	LHC010	change the F14,element 4 to <<TC bunker Unsettled>> default transaction values in bpost 
********************************************************************/
end subroutine

on u_transaction_bunker_tc_buy_sell.create
call super::create
end on

on u_transaction_bunker_tc_buy_sell.destroy
call super::destroy
end on
