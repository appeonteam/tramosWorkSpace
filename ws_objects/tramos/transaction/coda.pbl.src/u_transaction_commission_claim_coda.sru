$PBExportHeader$u_transaction_commission_claim_coda.sru
$PBExportComments$Inherited from u_transaction . Generates batch commissions
forward
global type u_transaction_commission_claim_coda from u_transaction_nocommit
end type
end forward

global type u_transaction_commission_claim_coda from u_transaction_nocommit
end type
global u_transaction_commission_claim_coda u_transaction_commission_claim_coda

type variables
long il_bpost_row
integer	ii_poolmanager
end variables

forward prototypes
public function integer of_fill_transaction ()
public subroutine documentation ()
public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end)
public function integer of_default_bpost ()
public function integer of_sharemember ()
end prototypes

public function integer of_fill_transaction (); /********************************************************************
	of_fill_transaction
	<DESC>No commits
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
		19/08/2014		CR3698		XSZ004		Modify error message
	</HISTORY>
********************************************************************/

string     ls_string, ls_prefix, ls_century, ls_yr, ls_temp_string, ls_broker_sn
string     ls_vessel_ref_nr, ls_coda_el4,	ls_coda_el3_pool, ls_coda_el4_pool, ls_nominalaccount
datetime   ldt_datetime, ldt_payment_start, ldt_payment_end
integer    li_result_grossfrt, li_integer, li_period, li_non_comm_handled
decimal{0} ld_no_decimal
decimal{2} ld_dkk_value, ld_rate
long       ll_debitcreditcode, ll_row, ll_rows, ll_tmp, ll_tmp2

u_broker       uo_broker
n_exchangerate lnv_exchangerate

////// SET KEYS FOR QUERY PURPOSE //////////

if isnull(istr_trans_input.tc_cp_date) = true then 	ls_temp_string = "CommClaimC" else ls_temp_string = "TCCODAComm"

IF ids_apost.SetItem(1,"trans_type",ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set transaction type for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"ch_br_ag_nr", istr_trans_input.broker_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set broker nr for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"claim_pcn_nr",istr_trans_input.claim_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set claim nr for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

///// SET A POSTS /////////////////////////////////////

/* Set field no. 6  Doccode  */
IF ids_apost.SetItem(1,"f06_doccode", ids_default_values.GetItemString(1,"doccode_coda_trans")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 06 (Doccode) for A-post. Object: u_transaction_commission_claim_coda, function: of_default_cms")
	Return(-1)
END IF

/* Set field no. 9 doc. date */
IF ids_apost.SetItem(1,"f09_docdate", datetime(today(), now())) <> 1 THEN
	of_messagebox("Set value error", "Cant set docdate for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.11 Element 1 */
//IF ids_apost.SetItem(1,"f11_el1", string(today(),"YYYYMM")) <> 1 THEN
//	of_messagebox("Set value error", "Cant set el.1 for A-post. Object: u_transaction_commission_claim_coda, &
//									function: of_fill_transaction")
//	Return(-1)
//END IF

/* Set field no. 14  Nominal Account  */
SELECT NON_APM_COMM_HANDLED, CODA_EL4, CODA_EL3_POOL, CODA_EL4_POOL
INTO :li_non_comm_handled, :ls_coda_el4, :ls_coda_el3_pool, :ls_coda_el4_pool
FROM VESSELS, PROFIT_C
WHERE  VESSELS.PC_NR =  PROFIT_C.PC_NR
	AND VESSELS.VESSEL_NR = :istr_trans_input.vessel_no ;

uo_broker = CREATE u_broker
uo_broker.of_getbroker(istr_trans_input.broker_no)

IF uo_broker.of_Own() THEN
	ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_own")
ELSE
	ls_prefix = ids_default_values.GetItemString(1,"prefix_supplier_foreign")
END IF

ii_poolmanager = uo_broker.ids_broker.getitemnumber(1, "broker_pool_manager")

if ii_poolmanager = 1 then
	ls_string = ls_coda_el4_pool
elseif li_non_comm_handled = 1 then 
	ls_string = ls_coda_el4
else
	ls_nominalaccount = uo_broker.of_getNominalAccount()
	ls_string         = ls_prefix + ls_nominalaccount
	
	IF LEN(ls_string) < 4 OR LEN(ls_string) > 6  THEN
		SELECT BROKER_SN INTO :ls_broker_sn 
		FROM   BROKERS 
		WHERE  BROKER_NR = :istr_trans_input.broker_no;
		
		if ls_nominalaccount = "" then 
			ls_nominalaccount = "missing"
		end if
		
		of_messagebox("Error","Broker with short name: " + ls_broker_sn + " has an invalid nominal account number: " + ls_nominalaccount + ".")
		Return(-1)
	END IF
end if

IF ids_apost.SetItem(1, "f14_el4",ls_string ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.4 for A-post. Object: u_transaction_commission_claim, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.23 APM Supplier*/
ls_string = ls_prefix + uo_broker.of_getNominalAccount()

IF ids_apost.SetItem(1, "f23_paytype_or_sup",ls_string ) <> 1 THEN
	of_messagebox("Set value error", "Cant set APM Supplier for A-post. Object: u_transaction_commission_claim_coda, &
								function: of_fill_transaction")
	Return(-1)
END IF

Destroy uo_broker;

/* Set field no.13 Element 3 */
if ii_poolmanager = 1 then
	ls_temp_string = ls_coda_el3_pool
else
	ls_temp_string = ids_default_values.GetItemString(1,"agent_gl")
end if

IF ids_apost.SetItem(1,"f13_el3", ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.3 for A-post. Object: u_transaction_commission_claim_coda, &
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
	of_messagebox("Retrieval error", "Alphanumeric Reference Number for vessel not found. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

IF ids_apost.SetItem(1,"f15_el5", ids_default_values.GetItemString(1,"prefix_vessel") + ls_vessel_ref_nr) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (Foreign) (Element 5) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 16  Element 6 */
ls_temp_string =trim(istr_trans_input.voyage_no)

if ls_temp_string <>"REV" then
	if ls_temp_string = "" then ls_temp_string="REV" else ls_temp_string= ids_default_values.GetItemString(1, "prefix_voyage") + left(istr_trans_input.voyage_no,5)
end if
IF ids_apost.SetItem(1, "f16_el6",ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 16 (Foreign) (Element 6) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF
	

/* Set field no.17 Element 7 */
ls_temp_string = ""
if ii_poolmanager = 1 then
	ls_temp_string = "POOLCOM"
else
	if istr_trans_input.port <> "" then
		ls_temp_string =  ids_default_values.GetItemString(1, "prefix_port") + istr_trans_input.port 
	end if
end if
IF ids_apost.SetItem(1, "f17_el7", ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 17 (Foreign) (Element 7) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp (always blank)*/
IF ids_apost.SetItem(1,"f19_custsupp", "") <> 1 THEN
	of_messagebox("Set value error", "Cant set Custsupp for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.20 Invoice number */
IF ids_apost.SetItem(1,"f20_invoicenr",istr_trans_input.comm_inv_no) <> 1 THEN
	of_messagebox("Set value error", "Cant set Invoicenr for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 21 Voucher nr. (always blank) */
IF ids_apost.SetItem(1,"f21_vouchernr","") <> 1 THEN
	of_messagebox("Set value error", "Cant set Voucher nr for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 22 Control nr.(always blank) */
IF ids_apost.SetItem(1,"f22_controlnr","") <> 1 THEN
	of_messagebox("Set value error", "Cant set Control nr for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.28 Curdoc )*/
IF ids_apost.SetItem(1, "f28_curdoc",istr_trans_input.disb_currency_code ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 28 (CurDoc) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 DebitCredit */
if istr_trans_input.comm_amount>=0 then
	ll_debitcreditcode = ids_default_values.GetItemNumber(1, "debitcredit_credit")
else
	ll_debitcreditcode =  ids_default_values.GetItemNumber(1, "debitcredit_debit")
end if

IF ids_apost.SetItem(1, "f29_debitcredit",ll_debitcreditcode) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 29 (DebitCredit) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.30 Value in document currency */ 
IF ids_apost.SetItem(1, "f30_valuedoc", abs(istr_trans_input.amount_local*100)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 30 (Valuedoc) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.32 Value in local currency DKK (local to DKK)*/
ld_rate = lnv_exchangerate.of_gettodaysdkkrate( istr_trans_input.disb_currency_code )
if ld_rate <= 0 then
	of_messagebox("Get exchange rate", "Cant get exchange rate. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
end if	

ld_dkk_value = istr_trans_input.amount_local * ld_rate

IF ids_apost.SetItem(1, "f32_valuehome", abs(ld_dkk_value)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 32 (Valuehome) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.33 */ 
IF ids_apost.SetItem(1, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.35 */ 
IF ids_apost.SetItem(1, "f35_vattyp_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (vattyp_or_valdual_dp) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.34 Value in USD */ 
IF ids_apost.SetItem(1, "f34_vatamo_or_valdual", abs(istr_trans_input.comm_amount*100)) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 34 (vatamo_or_valdual) for A-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

if isnull(istr_trans_input.tc_cp_date) = true then
	ls_temp_string  =  ids_default_values.GetItemString(1,"default_comments_commiclaim")
else 
	ls_temp_string  =  ids_default_values.GetItemString(1,"default_comments_commitc")
end if
if ii_poolmanager = 1 then ls_temp_string = "Pool " + ls_temp_string

/* Set field no.41 LineDescription */
IF ids_apost.SetItem(1,"f41_linedesr",ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF


///// SET B POSTS /////////////////////////////////////

IF of_default_bpost() = -1 then return -1
	
	
if isnull(istr_trans_input.tc_cp_date) = true then

	/* Set field no.11 Element 1 */
	SELECT 	MIN(POC.PORT_ARR_DT)
	INTO		:ldt_datetime
	FROM		POC
	WHERE		VESSEL_NR = :istr_trans_input.vessel_no AND
				substring(POC.VOYAGE_NR, 1, 5) =	Substring(:istr_trans_input.voyage_no,1,5);
	//COMMIT;
	
	ls_temp_string = string(ldt_datetime, "YYYY")
	
	IF Left(istr_trans_input.voyage_no,2) >= "50" THEN
		ls_century = "19"
	ELSE
		ls_century = "20"
	END IF
		
	IF ls_temp_string <> (ls_century + Left(istr_trans_input.voyage_no,2)) THEN
		ls_string = (ls_century + Left(istr_trans_input.voyage_no,2) + "01")
	ELSE
		ls_string = string(ldt_datetime, "YYYYMM")
	END IF
	
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ls_string) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_commission_claim_coda, &
										function: of_fill_transaction")
		Return(-1)
	END IF

else
	//TCHIRE 	
	 ldt_payment_start = istr_trans_input.payment_start
	 ldt_payment_end = istr_trans_input.payment_end
	 
	IF ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_payment_start, "YYYYMM")) <> 1 THEN
		of_messagebox("Set value error", "Cant set el. 1 for B-post. Object: u_transaction_commission_claim_coda, &
										function: of_fill_transaction")
		Return(-1)
	END IF

end if

/* Set field no.13 Element 3*/
IF ids_bpost.SetItem(il_bpost_row,"f13_el3_b", ids_default_values.GetItemString(1,"commission_gl")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 3 for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.14 Element 4*/
IF ids_bpost.SetItem(il_bpost_row,"f14_el4_b", ids_default_values.GetItemString(1,"commission_acc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 4 for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.29 */
if istr_trans_input.comm_amount>=0 then
	ll_debitcreditcode = ids_default_values.GetItemNumber(1, "debitcredit_debit")
else
	ll_debitcreditcode =  ids_default_values.GetItemNumber(1, "debitcredit_credit")
end if
IF ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", ll_debitcreditcode) <> 1 THEN
	of_messagebox("Set value error", "Cant set DebitCredit for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no. 30 */
IF ids_bpost.SetItem(il_bpost_row,"f30_valuedoc",  ids_apost.GetItemNumber(1,"f30_valuedoc")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.32 Value home*/
IF ids_bpost.SetItem(il_bpost_row,"f32_valuehome",ids_apost.GetItemNumber(1,"f32_valuehome")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuehome for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.33 Value home dp*/
IF ids_bpost.SetItem(il_bpost_row,"f33_valuehome_dp",ids_apost.GetItemNumber(1,"f33_valuehome_dp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuehome dp for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.34 Value dual*/
IF ids_bpost.SetItem(il_bpost_row,"f34_vatamo_or_valdual",ids_apost.GetItemNumber(1,"f34_vatamo_or_valdual")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedual for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.35 Value dual dp*/
IF ids_bpost.SetItem(il_bpost_row,"f35_vattype_or_valdual_dp",ids_apost.GetItemNumber(1,"f35_vattyp_or_valdual_dp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedual dp for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

if isnull(istr_trans_input.tc_cp_date) = false then
	//TCHIRE
	
	/* Periodiser transaction hvis nødvendigt */
	if of_periodiser_bpost(il_bpost_row, ldt_payment_start, ldt_payment_end) = -1 then
		of_messagebox("Error", "Can't break B-post into periods. Object: u_transaction_hire_pay_coda, function: of_commissionhire_bpost")
		Return(-1)
	END IF
	
	/* Kald funktion for Share Members der fordeler alt som har GL kontonummer "010" eller "020" */
	IF of_shareMember() = -1 then Return -1
end if


/* Set field no.11 Element 1 */
ll_tmp = Long( left(ids_bpost.Getitemstring(1,"f11_el1_b"),4))
ll_tmp2 = Long(string(today(),"YYYY"))
if ll_tmp < ll_tmp2 then
	ls_temp_string = left(ids_bpost.Getitemstring(1,"f11_el1_b"), 4) + "12"
else
	ls_temp_string =  string(today(),"YYYYMM")
end if

IF ids_apost.SetItem(1,"f11_el1", ls_temp_string) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.1 for A-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no. 08 DocLineNumber for all B-posts */
ll_rows = ids_bpost.rowCount()
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		IF ids_bpost.SetItem(ll_row, "f08_doclinenum_b", ll_row +1) <> 1 THEN
			of_messagebox("Set value error", "Cant set Field 08 (Doclinenumber) for B-post. Object: u_transaction_commission_claim_coda, function: of_fill_bpost")
			Return(-1)
		end if
	next
end if


Return 1
end function

public subroutine documentation ();/********************************************************************
	ObjectName: u_transaction_commission_claim
	<OBJECT> CODA Transaction for broker (claim) commission	</OBJECT>
	<USAGE> Sette broker commission in CODA	</USAGE>
	<ALSO>	</ALSO>
	<HISTORY> 
		Date      		CR-Ref	Author        		Comments
		01/02/2011		CR2264	Joana Carvalho		First Version
		07/03/2011		cr2264	RMO003        		fixed error in claims pool commission 
		          		      	              		currency code and exchange rate missing 
		          		      	              		improved error handling
		28/03/2011		CR2264	JMC           		Changes on element 3 and 4 - APost.
		26/04/2011		CR2337	JMC           		El1 changed
		19/08/2014		CR3698	XSZ004        		Modify error message
	</HISTORY>
********************************************************************/
end subroutine

public function integer of_periodiser_bpost (long al_row, datetime adt_start, datetime adt_end);long 				ll_total_minutes, ll_delta_minutes
decimal {0}		ld_comm_amount=0, ld_comm_amount_dkk=0, ld_comm_amount_usd=0
decimal {0}		ld_sum_comm_amount=0, ld_sum_comm_amount_dkk=0, ld_sum_comm_amount_usd=0
decimal {0}		ld_total_comm_amount=0, ld_total_comm_amount_dkk=0, ld_total_comm_amount_usd=0
datetime			ldt_calc_start, ldt_calc_end 		
integer			li_month, li_year

if month(date(adt_start)) = month(date(adt_end)) then return 1

ld_total_comm_amount 	= ids_bpost.getItemNumber(al_row, "f30_valuedoc")
ld_total_comm_amount_dkk 	= ids_bpost.getItemNumber(al_row, "f32_valuehome")
ld_total_comm_amount_usd 	= ids_bpost.getItemNumber(al_row, "f34_vatamo_or_valdual")

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
	ld_comm_amount = (ld_total_comm_amount / ll_total_minutes ) * ll_delta_minutes
	ld_sum_comm_amount += ld_comm_amount
	
	ld_comm_amount_dkk = (ld_total_comm_amount_dkk / ll_total_minutes ) * ll_delta_minutes
	ld_sum_comm_amount_dkk += ld_comm_amount_dkk
	
	ld_comm_amount_usd = (ld_total_comm_amount_usd / ll_total_minutes ) * ll_delta_minutes
	ld_sum_comm_amount_usd += ld_comm_amount_usd
	
	/* Create new record and copy values from original row */
	IF of_default_bpost() = -1 then return -1
	
	ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_bpost.getItemString(al_row, "f13_el3_b")) 
	ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_bpost.getItemString(al_row, "f14_el4_b"))
	ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_bpost.getItemNumber(al_row, "f29_debitcredit"))
	ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ids_bpost.getItemString(al_row, "f41_linedesr"))
	
	/* Set aktivitetsperiode inden skift  og beløb */
	ids_bpost.SetItem(il_bpost_row,"f11_el1_b", string(ldt_calc_start, "YYYYMM"))
	
	ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_comm_amount))
	ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_comm_amount_dkk))
	ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_comm_amount_usd))
	
	ldt_calc_start = ldt_calc_end
loop	

/* Calculate rest amount to update original record with */
ids_bpost.SetItem(al_row,"f11_el1_b", string(ldt_calc_start, "YYYYMM"))

ld_comm_amount = ld_total_comm_amount - ld_sum_comm_amount
ids_bpost.SetItem(al_row, "f30_valuedoc", abs(ld_comm_amount))

ld_comm_amount_dkk = ld_total_comm_amount_dkk - ld_sum_comm_amount_dkk
ids_bpost.SetItem(al_row, "f32_valuehome", abs(ld_comm_amount_dkk))

ld_comm_amount_usd = ld_total_comm_amount_usd - ld_sum_comm_amount_usd 
ids_bpost.SetItem(al_row, "f34_vatamo_or_valdual", abs(ld_comm_amount_usd))


return 1

end function

public function integer of_default_bpost ();string	ls_temp_string
/* Insert new B-post */
il_bpost_row = ids_bpost.InsertRow(0)

/* Set field no.3 Year*/
IF ids_bpost.SetItem(il_bpost_row,"f03_yr", ids_apost.GetItemNumber(1,"f03_yr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set year for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.4 Period*/
IF ids_bpost.SetItem(il_bpost_row,"f04_period", ids_apost.GetItemNumber(1,"f04_period")) <> 1 THEN
	of_messagebox("Set value error", "Cant set period for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.12 Element 2*/
IF ids_bpost.SetItem(il_bpost_row,"f12_el2_b",ids_apost.GetItemString(1,"f12_el2")) <> 1 THEN
	of_messagebox("Set value error", "Cant set el. 2 for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.15 Element 5*/
IF ids_bpost.SetItem(il_bpost_row,"f15_el5_b",ids_apost.GetItemString(1, "f15_el5") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 15 (vessel ID) for B-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.16 Element 6*/
IF ids_bpost.SetItem(il_bpost_row,"f16_el6_b", ids_apost.GetItemString(1, "f16_el6") ) <> 1 THEN
	of_messagebox("Set value error", "Cant set el.6 for B-post. Object: u_transaction_commission_claim_coda, &
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
	of_messagebox("Set value error", "Cant set el.7 for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.19 Custsupp*/
IF ids_bpost.SetItem(il_bpost_row,"f19_custsupp", ids_apost.GetItemString(1,"f19_custsupp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 19 for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.20 Invoice nr*/
IF ids_bpost.SetItem(il_bpost_row,"f20_invoicenr", ids_apost.GetItemString(1,"f20_invoicenr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set field 20 for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.27 Linetype*/
IF ids_bpost.SetItem(il_bpost_row,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 THEN
	of_messagebox("Set value error", "Cant set linetype for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.31 Valuedoc dp*/
IF ids_bpost.SetItem(il_bpost_row,"f31_valuedoc_dp",ids_apost.GetItemNumber(1,"f31_valuedoc_dp")) <> 1 THEN
	of_messagebox("Set value error", "Cant set Valuedoc dp for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.33 */ 
IF ids_bpost.SetItem(il_bpost_row, "f33_valuehome_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 33 (Valuehome_dp) for B-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF

/* Set field no.35 */ 
IF ids_bpost.SetItem(il_bpost_row, "f35_vattype_or_valdual_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "Cant set Field 35 (Valuedual_dp) for B-post. Object: u_transaction_commission_claim_coda, function: of_fill_transaction")
	Return(-1)
END IF


/* Set field no.41 LineDescription */
IF ids_bpost.SetItem(il_bpost_row,"f41_linedesr",  ids_apost.GetItemString(1,"f41_linedesr")) <> 1 THEN
	of_messagebox("Set value error", "Cant set LineDesr for B-post. Object: u_transaction_commission_claim_coda, &
									function: of_fill_transaction")
	Return(-1)
END IF

Return 1
end function

public function integer of_sharemember ();decimal {0}		ld_comm_amount=0, ld_comm_amount_dkk=0,  ld_comm_amount_usd=0
decimal {0}		ld_sum_comm_amount=0, ld_sum_comm_amount_dkk=0,  ld_sum_comm_amount_usd=0
decimal {0}		ld_total_comm_amount=0, ld_total_comm_amount_dkk=0, ld_total_comm_amount_usd=0

decimal {8}		ld_share_pct
n_ds				lds_member
long				ll_members, ll_trans, ll_member_row, ll_tran_row
string			ls_el4, ls_owner_prefix
integer			li_apm_company
double			ld_contract_id

lds_member = create n_ds
lds_member.dataObject = "d_payment_settle_share_member"
lds_member.setTransObject(SQLCA)
SELECT CONTRACT_ID INTO :ld_contract_id FROM NTC_PAYMENT WHERE PAYMENT_ID = :istr_trans_input.payment_id;
ll_members = lds_member.retrieve(ld_contract_id)

/* If no Members registred, nothing to share */
if ll_members < 1 then 
	destroy lds_member
	return 1
end if

/* There are members */
/* Get number of B-posts to check */
ll_trans = ids_bpost.rowCount()
if ll_trans < 1 then
	destroy lds_member
	of_messagebox("Set value error", "Cant set Field 11 (Element 1) for B-post. Object: u_transaction_commission_claim_coda, function: of_sharemember")
	Return(-1)
end if

ls_owner_prefix = ids_default_values.GetItemString(1, "prefix_supplier_foreign")

for ll_tran_row = 1 to ll_trans

	/* only split if GL account = "010" or "020" */
	if ids_bpost.getItemString(ll_tran_row, "f13_el3_b") <> "010" AND &
		ids_bpost.getItemString(ll_tran_row, "f13_el3_b") <> "020" then CONTINUE
		
	ld_total_comm_amount 	= ids_bpost.getItemNumber(ll_tran_row, "f30_valuedoc")
	ld_total_comm_amount_dkk 	= ids_bpost.getItemNumber(ll_tran_row, "f32_valuehome")
	ld_total_comm_amount_usd	= ids_bpost.getItemNumber(ll_tran_row, "f34_vatamo_or_valdual")
	
	ld_sum_comm_amount = 0
	ld_sum_comm_amount_dkk = 0
	ld_sum_comm_amount_usd = 0
	
	for ll_member_row = 1 to ll_members
		ld_share_pct		= lds_member.getItemDecimal(ll_member_row, "percent_share")
		ls_el4 				= lds_member.getItemString(ll_member_row, "nom_acc_nr")
		li_apm_company		= lds_member.getItemNumber(ll_member_row, "apm_company")
		/* If last row in Share Members update original b-post with rest */
		if ll_member_row = ll_members then CONTINUE

		/* Calculate share values */
		ld_comm_amount = ld_total_comm_amount * ld_share_pct / 100
		ld_sum_comm_amount += ld_comm_amount
		
		ld_comm_amount_dkk = ld_total_comm_amount_dkk * ld_share_pct / 100
		ld_sum_comm_amount_dkk += ld_comm_amount_dkk
		
		ld_comm_amount_usd = ld_total_comm_amount_usd * ld_share_pct / 100
		ld_sum_comm_amount_usd += ld_comm_amount_usd
		
		/* Create new record and copy values from original row */
		IF of_default_bpost() = -1 then return -1
		
		ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ids_bpost.getItemString(ll_tran_row, "f11_el1_b"))
		if li_apm_company = 1 then 
			ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_bpost.getItemString(ll_tran_row, "f13_el3_b")) 
			ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ids_bpost.getItemString(ll_tran_row, "f14_el4_b"))
		else
			ids_bpost.SetItem(il_bpost_row, "f13_el3_b", ids_default_values.GetItemString(1, "agent_gl")) 
			ids_bpost.SetItem(il_bpost_row, "f14_el4_b", ls_owner_prefix+ls_el4)
		end if			
		ids_bpost.SetItem(il_bpost_row, "f29_debitcredit", ids_bpost.getItemNumber(ll_tran_row, "f29_debitcredit"))
		ids_bpost.SetItem(il_bpost_row, "f41_linedesr", ids_bpost.getItemString(ll_tran_row, "f41_linedesr"))

		/* Set beløb */
		ids_bpost.SetItem(il_bpost_row, "f30_valuedoc", abs(ld_comm_amount))
		ids_bpost.SetItem(il_bpost_row, "f32_valuehome", abs(ld_comm_amount_dkk))
		ids_bpost.SetItem(il_bpost_row, "f34_vatamo_or_valdual", abs(ld_comm_amount_usd))
		
	next /* ll_member_row */

	/* Calculate rest amount to update original record with */
	ld_comm_amount = ld_total_comm_amount - ld_sum_comm_amount
	ld_comm_amount_dkk = ld_total_comm_amount_dkk - ld_sum_comm_amount_dkk
	ld_comm_amount_usd = ld_total_comm_amount_usd - ld_sum_comm_amount_usd
	
	if li_apm_company = 0 then /* not APM Company change accounts */
		ids_bpost.SetItem(ll_tran_row, "f13_el3_b", ids_default_values.GetItemString(1, "agent_gl")) 
		ids_bpost.SetItem(ll_tran_row, "f14_el4_b", ls_owner_prefix+ls_el4)
	end if			

	ids_bpost.SetItem(ll_tran_row, "f30_valuedoc", abs(ld_comm_amount))
	ids_bpost.SetItem(ll_tran_row, "f32_valuehome", abs(ld_comm_amount_dkk))
	ids_bpost.SetItem(ll_tran_row, "f34_vatamo_or_valdual", abs(ld_comm_amount_usd))

next /* ll_tran_row */

destroy lds_member
return 1

end function

on u_transaction_commission_claim_coda.create
call super::create
end on

on u_transaction_commission_claim_coda.destroy
call super::destroy
end on

