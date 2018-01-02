$PBExportHeader$u_transaction_estimate_tcout.sru
$PBExportComments$tc-out estimation transaction
forward
global type u_transaction_estimate_tcout from u_transaction
end type
end forward

global type u_transaction_estimate_tcout from u_transaction
end type
global u_transaction_estimate_tcout u_transaction_estimate_tcout

type variables
s_tcoutestimate	istr_est
long 	il_bpost_row
mt_n_datastore	ids_defaultvaluesax
end variables

forward prototypes
public subroutine documentation ()
public subroutine of_messagebox (string as_title, string as_message)
public function integer of_generate_transaction (s_tcoutestimate astr_est)
private function integer of_default_bpost (s_transcategory astr_cat)
public function integer of_buildcategory (ref s_transcategory astr_cat[], string as_name, string as_account, string as_debitcredit, decimal ad_amount)
public function integer of_fill_transaction ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: u_transaction_estimate_tcout
	
	<OBJECT>
		Object to handle tc-out estimations for AX finance system.
		Generates transactions using ancestor methods from u_transaction.
		Does not use the default transaction object.  
		of_generate_transaction() replaced to work with specific structure.
		
	</OBJECT>
   	<DESC>
		Generates transactions in following structure:
		
			APOST - single a post entry.
			BPOST
			..
			BPOST
			BPOST
			
	</DESC>
   	<USAGE>
		Called from the axestimates library.  
		It can be used by server application axestimates or
		from a finance control panel option
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
		Date       		CR-Ref		Author   		Comments
		15/11/12  		CR2775		AGL   			First Version
		10-08-2017		CR4629		XSZ004			Add first load port arrival date to AX voyage estimates  
********************************************************************/
end subroutine

public subroutine of_messagebox (string as_title, string as_message);if not (istr_est.b_client) then /* AX Estimate server application */
	super::of_messagebox(as_title,as_message)
end if
istr_est.s_errormessage = as_title + ":" + as_message
istr_est.i_errorcode = -5
end subroutine

public function integer of_generate_transaction (s_tcoutestimate astr_est);integer li_flagposttransaction, li_return

istr_est = astr_est

/* Set input parameters accessible for all functions within object */
SELECT PROFIT_C.POST_TRANSACTION, PROFIT_C.CODA_COMPANY_CODE, getdate()
INTO :li_flagposttransaction, :is_codacompanycode, :idt_serverdate
FROM VESSELS, PROFIT_C
WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND
	VESSEL_NR = :istr_est.i_vesselnr;


if li_flagposttransaction=0  then
	of_messagebox("Transaction Generation","This expense will be not posted in CODA! (Posting was disabled for this profit center!)")
  return c#return.NoAction
end if

/* Insert a new line in A-post datawindow */
if ids_apost.InsertRow(0) = -1 then
	of_messagebox("Generate transaction error","Unable to insert row in A-post datawindow. Object: u_transaction, Function: of_generate_transaction")
	return c#return.Failure
end if

/* Default values for all transactions */
if of_default_values() <> 1 then
	of_messagebox("Generate transaction error","Unable to fill default values. Object: u_transaction, Function: of_generate_transaction")
	return c#return.Failure
end if

/* Default values for AX/CODA transactions */
if of_default_CODA() <> 1 then
	of_messagebox("Generate transaction error","Unable to fill CODA default values. Object: u_transaction, Function: of_generate_transaction")
	return c#return.Failure
end if

/* Write this function for each object of type u_transactions */
li_return = of_fill_transaction()

if li_return <> 1 and li_return <> 10 then
	of_messagebox("Generate transaction error","Unable to fill specific values. Object: u_transaction, Function: of_generate_transaction")
	return c#return.Failure
elseif li_return = 10 then
	// Return 10 means that it is a Bunker transaction on a re-finished voyage
	//with no change so no transaction => stop before save and return OK
	return c#return.NoAction
end if

/* Save transactions */
if of_save() <> 1 then
	of_messagebox("Generate transaction error","Unable to save transactions. Object: u_transaction, Function: of_generate_transaction")
	return c#return.Failure
end if

return c#return.Success
end function

private function integer of_default_bpost (s_transcategory astr_cat);string ls_century, ls_temp_string,  ls_vessel_ref_nr, ls_string
datetime ldt_datetime

// SET B POSTS (first all default values) /////////////////
il_bpost_row = ids_bpost.InsertRow(0)

/* Set General fields for row no. 1*/
/* Set field no.3 Year*/
if ids_bpost.SetItem(il_bpost_row,"f03_yr", ids_apost.GetItemNumber(1,"f03_yr")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f03_yr' for B-post. u_transaction_estimate.of_default_bpost()")
	return(-1)
end if

/* Set field no.4 Period*/
if ids_bpost.SetItem(il_bpost_row,"f04_period", ids_apost.GetItemNumber(1,"f04_period")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f04_period' for B-post. u_transaction_estimate.of_default_bpost()")
	return(-1)
end if
												
												
if ids_bpost.SetItem(il_bpost_row,"f11_el1_b", ids_apost.GetItemString(1,"f11_el1")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f11_el1_b' for B-post. u_transaction_estimate.of_default_bpost()")	
	return(-1)
end if

/* Set field no.12 Element 2*/
if ids_bpost.SetItem(il_bpost_row,"f12_el2_b", ids_apost.GetItemString(1,"f12_el2")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f12_el2_b' for B-post. u_transaction_estimate.of_default_bpost()")	

	return(-1)
end if

/* Set field no.13 Element 3*/
if ids_bpost.SetItem(il_bpost_row,"f13_el3_b", astr_cat.s_account) <> 1 then
	of_messagebox("Set value error", "can not set column 'f13_el3_b' for B-post. u_transaction_estimate.of_default_bpost()")	
	return(-1)
end if

/* Set field no.15 Element 5*/
if ids_bpost.SetItem(il_bpost_row,"f15_el5_b", ids_apost.getItemString(1, "f15_el5")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f15_el5_b' for B-post. u_transaction_estimate.of_default_bpost()")	
	return(-1)
end if

/* Set field no.16 Element 6*/
if ids_bpost.SetItem(il_bpost_row,"f16_el6_b", ids_apost.getItemString(1, "f16_el6")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f16_el6_b' for B-post. u_transaction_estimate.of_default_bpost()")	
	return(-1)
end if

/* Set field no.27 Linetype*/
if ids_bpost.SetItem(il_bpost_row,"f27_linetype", ids_default_values.GetItemNumber(1,"linetype_analyses_bpost")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f27_linetype' for B-post. u_transaction_estimate.of_default_bpost()")	
	return(-1)
end if

/* Set field no.31 Valuedoc dp*/
if ids_bpost.SetItem(il_bpost_row,"f31_valuedoc_dp", 2) <> 1 THEN
	of_messagebox("Set value error", "can not set column 'f31_valuedoc_dp' for B-post. u_transaction_estimate.of_default_bpost()")
	return(-1)
end if


if ids_bpost.SetItem(il_bpost_row,"f29_debitcredit", ids_default_values.GetItemNumber(1,"debitcredit_" + astr_cat.s_debitcredit)) <> 1 then
	of_messagebox("Set value error", "can not set column 'f29_debitcredit' for B-post. u_transaction_estimate.of_default_bpost()")	
	return(-1)
end if

return 1
end function

public function integer of_buildcategory (ref s_transcategory astr_cat[], string as_name, string as_account, string as_debitcredit, decimal ad_amount);integer li_categoryindex

li_categoryindex = upperbound(astr_cat) + 1

astr_cat[li_categoryindex].s_name = as_name
astr_cat[li_categoryindex].s_account = as_account
astr_cat[li_categoryindex].s_debitcredit = as_debitcredit
if isnull(ad_amount) then
	astr_cat[li_categoryindex].d_amount = 0
else
	astr_cat[li_categoryindex].d_amount = ad_amount
end if

return c#return.Success
end function

public function integer of_fill_transaction ();/********************************************************************
   of_fill_transaction
   <DESC></DESC>
   <RETURN>	(none)  </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date       		CR-Ref		Author		Comments
		03-08-2017		CR4629		XSZ004		Add first load port arrival date to AX voyage estimates
   </HISTORY>
********************************************************************/

integer 				li_integer
string 				ls_gl_apost, ls_prefix, ls_voyagenr, ls_vesselnr    
long 					ll_periodindex, ll_categoryindex, ll_row
decimal {0} 		ld_no_decimal, ld_no_decimal_home, ld_brokercomm_nodp, ld_amount_nodp
decimal {2} 		ld_amount
decimal {4} 		ld_creditsum, ld_debitsum, ld_brokercomm

s_transcategory 	lstr_category[]
n_esttcout			lnv_tcoutfunc

/* create the categories for tc-out estimates */

/* 1:M - for each hire */
of_buildcategory(lstr_category, "freight", ids_defaultvaluesax.getitemstring(1,"ax_cat_freight_est"), "debit", 0.0)
of_buildcategory(lstr_category, "miscexpenses", ids_defaultvaluesax.getitemstring(1,"ax_cat_miscexp_est"), "credit", 0.0)
of_buildcategory(lstr_category, "miscincome", ids_defaultvaluesax.getitemstring(1,"ax_cat_miscincome_est"), "debit",  0.0)
of_buildcategory(lstr_category, "commission", ids_defaultvaluesax.getitemstring(1,"ax_cat_comm_est"), "credit", 0.0) 

/* A-Post part 1 standard values */
ls_gl_apost = ids_defaultvaluesax.getitemstring(1,"ax_cat_est")	

/* set the key for query purpose */
if ids_apost.SetItem(1,"trans_type","Estimates") <> 1 then
	of_messagebox("Set value error", "can not set column 'trans_type' for A-post. u_transaction_estimate.of_fill_transaction()")
	return(-1)
end if 

/* Set field no. 6  Doccode  */
if ids_apost.SetItem(1,"f06_doccode", ids_default_values.getitemstring(1,"doccode_coda_variations")) <> 1 then
	of_messagebox("Set value error", "can not set column 'f06_doccode' for A-post. u_transaction_estimate.of_fill_transaction()")
	return(-1)
end if 

/* Set field no. 9 doc. date */
if ids_apost.SetItem(1,"f09_docdate", DateTime(Today(), Now())) <> 1 then
	of_messagebox("Set value error", "can not set column 'f09_docdate' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

if ids_apost.SetItem(1,"f11_el1", istr_est.s_activityperiod) <> 1 then
	of_messagebox("Set value error", "can not set column 'f11_el1' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.13 Element 3 */
if ids_apost.SetItem(1,"f13_el3", ls_gl_apost) <> 1 then
	of_messagebox("Set value error", "can not set column 'f13_el3' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.14 Element 4 Charterer nominal account */
if ids_apost.SetItem(1,"f14_el4", istr_est.s_chartnomaccnr) <> 1 then
	of_messagebox("Set value error", "can not set column 'f14_el4' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.15 Element 5 */
ls_prefix = ids_default_values.getitemstring(1,"prefix_vessel")
ls_vesselnr = ls_prefix + left(istr_est.s_key,3)

if ids_apost.SetItem(1,"f15_el5", ls_vesselnr) <> 1 then
	of_messagebox("Set value error", "can not set column 'f15_el5' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.17 Element 7*/
if ids_apost.SetItem(1,"f17_el7", string(istr_est.l_contractid)) <> 1 then
	of_messagebox("Set value error", "can not set column 'f17_el7' for A-post. u_transaction_estimate.of_fill_transaction()")
	return(-1)
end if 

/* Set field no.23 APM Supplier (here for the TC Owner nominal account) */
if ids_apost.SetItem(1,"f23_paytype_or_sup", istr_est.s_tcownernomaccnr) <> 1 then
	of_messagebox("Set value error", "can not set column 'f23_paytype_or_sup' for A-post. u_transaction_estimate.of_fill_transaction()")
	return(-1)
end if 

if ids_apost.SetItem(1,"f26_orderno", string(istr_est.dt_firstarrival, "dd-mm-yy hh:mm:ss")  ) <> 1 then
	of_messagebox("Set value error", "can not set column 'f26_orderno' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if

/* Set field no.27 linetype )*/
if ids_apost.SetItem(1,"f27_linetype", istr_est.i_localtime) <> 1 then
	of_messagebox("Set value error", "can not set column 'f28_curdoc' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.28 Curdoc )*/
if ids_apost.SetItem(1,"f28_curdoc", istr_est.s_currcode) <> 1 then
	of_messagebox("Set value error", "can not set column 'f28_curdoc' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.37 M2 (in pool flag) )*/
if ids_apost.SetItem(1,"f37_m2", istr_est.i_inpool) <> 1 then
	of_messagebox("Set value error", "can not set column 'f37_m2' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.38 Heads (bare boat flag) )*/
if ids_apost.SetItem(1,"f38_heads", istr_est.i_bareboat) <> 1 then
	of_messagebox("Set value error", "can not set column 'f38_heads' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

/* Set field no.41 LineDescription */
if ids_apost.SetItem(1,"f41_linedesr", "TC-out estimates") <> 1 then
	of_messagebox("Set value error", "can not set column 'f41_linedesr' for A-post. u_transaction_estimate.of_fill_transaction()")	
	return(-1)
end if 

if not isnull(istr_est.dtm_cerpstart) then
	/* Set field no.43 CP Date*/
	if ids_apost.SetItem(1,"f43_due_or_payment_date", istr_est.dtm_cerpstart) <> 1 then
		of_messagebox("Set value error", "can not set column 'f43_due_or_payment_date' for A-post. u_transaction_estimate.of_fill_transaction()")		
		return(-1)
	end if 
end if	


/* data found using n_esttcout object functions */
lnv_tcoutfunc = create n_esttcout
ls_voyagenr = lnv_tcoutfunc.of_get_voyage_number(istr_est.str_hire)
ld_no_decimal_home = 100 * Round(lnv_tcoutfunc.of_get_amount_sum(istr_est.str_hire,"freight"),2)	

/* Set field no.16 Element 6 (voyage) */
if ids_apost.SetItem(1,"f16_el6", ids_default_values.getitemstring(1,"prefix_voyage") + ls_voyagenr) <> 1 then
	of_messagebox("Set value error", "can not set column 'f16_el6' for A-post. u_transaction_estimate.of_fill_transaction()")
	destroy lnv_tcoutfunc
	return(-1)
end if 

/* Set field no.18 Element 8 (end date) */
if ids_apost.SetItem(1,"f18_el8", string(lnv_tcoutfunc.of_get_voyage_end(istr_est.str_hire), "dd-mm-yy hh:mm:ss")  ) <> 1 then
	of_messagebox("Set value error", "can not set column 'f18_el8' for A-post. u_transaction_estimate.of_fill_transaction()")	
	destroy lnv_tcoutfunc
	return(-1)
end if 

/* Set field no.25 dateofissue (start date) */
if ids_apost.SetItem(1,"f25_paymethod_or_dateofissue", string(lnv_tcoutfunc.of_get_voyage_start(istr_est.str_hire), "dd-mm-yy hh:mm:ss")  ) <> 1 then
	of_messagebox("Set value error", "can not set column 'f25_paymethod_or_dateofissue' for A-post. u_transaction_estimate.of_fill_transaction()")
	destroy lnv_tcoutfunc	
	return(-1)
end if 

ld_brokercomm = lnv_tcoutfunc.of_get_broker_comm(istr_est)
ld_brokercomm_nodp = round(ld_brokercomm,2) * 100

destroy lnv_tcoutfunc


/* B-Post detail processing */
for ll_categoryindex = 1 to upperbound(lstr_category)

	if lstr_category[ll_categoryindex].s_name = "commission" then
		
		if ld_brokercomm_nodp > 0 then
			/* broker commission will have no more than 1 B-POST */
			of_default_bpost(lstr_category[ll_categoryindex])
			
			if ids_bpost.SetItem(il_bpost_row,"f41_linedesr", lstr_category[ll_categoryindex].s_name ) <> 1 then
				of_messagebox("Set value error", "can not set column 'f41_linedesr' for B-post. u_transaction_estimate.of_fill_transaction()")
				return(-1)
			end if
			if ids_bpost.SetItem(il_bpost_row,"f30_valuedoc", ld_brokercomm_nodp) <> 1 then
				of_messagebox("Set value error", "can not set column 'f30_valuedoc' for B-post. u_transaction_estimate.of_fill_transaction()")
				return(-1)
			end if
			ld_creditsum += ld_brokercomm
		end if
		
	else

		/* for each period we attempt to create a B-POST */
		for ll_periodindex = 1 to upperbound(istr_est.str_hire)

			CHOOSE CASE lstr_category[ll_categoryindex].s_name
				CASE "freight"
					ld_amount_nodp = (round(istr_est.str_hire[ll_periodindex].d_amount,2) * 100 )
				CASE "miscexpenses"
					ld_amount_nodp = (round(istr_est.str_hire[ll_periodindex].d_miscexp_amount,2) * 100 )					
				CASE "miscincome"
					ld_amount_nodp = (round(istr_est.str_hire[ll_periodindex].d_miscinc_amount,2) * 100 )	+ (round(istr_est.str_hire[ll_periodindex].d_contractexp_amount,2) * 100 )				
			END CHOOSE		
	
			/* only create B-POST if value in amount and voyage number is valid */
			
			if ld_amount_nodp > 0 and istr_est.str_hire[ll_periodindex].s_voyagenr = ls_voyagenr then
				
				of_default_bpost(lstr_category[ll_categoryindex])
				
				/* Set field no.18 (periode end date) */
				if ids_bpost.SetItem(il_bpost_row,"f18_el8_b", string(istr_est.str_hire[ll_periodindex].dtm_end, "dd-mm-yy hh:mm:ss")  ) <> 1 then
					of_messagebox("Set value error", "can not set column 'f18_el8_b' on " + lstr_category[ll_categoryindex].s_name + " for B-post. u_transaction_estimate.of_fill_transaction()")					
					return(-1)
				end if
				
				/* Set field no.20 Invoice Number (periode start date) */
				if ids_bpost.SetItem(il_bpost_row,"f20_invoicenr", string(istr_est.str_hire[ll_periodindex].dtm_start, "dd-mm-yy hh:mm:ss")  ) <> 1 then
					of_messagebox("Set value error", "can not set column 'f20_invoicenr' on " + lstr_category[ll_categoryindex].s_name + " for B-post. u_transaction_estimate.of_fill_transaction()")					
					return(-1)
				end if
				
				/* Set field no.41 Line descriptor */				
				if ids_bpost.SetItem(il_bpost_row,"f41_linedesr", lstr_category[ll_categoryindex].s_name ) <> 1 then
					of_messagebox("Set value error", "can not set column 'f41_linedesr' on " + lstr_category[ll_categoryindex].s_name + " for B-post. u_transaction_estimate.of_fill_transaction()")										
					return(-1)
				end if
				
				/* Set field no.30 Value Doc */				
				if ids_bpost.SetItem(il_bpost_row,"f30_valuedoc", ld_amount_nodp) <> 1 then
					of_messagebox("Set value error", "can not set column 'f30_valuedoc' on " + lstr_category[ll_categoryindex].s_name + " for B-post. u_transaction_estimate.of_fill_transaction()")															
					return(-1)
				end if

				/* additionals if type freight */
				if lstr_category[ll_categoryindex].s_name = "freight" then
					ld_amount_nodp = round(istr_est.str_hire[ll_periodindex].d_rate,2) * 100
					/* Set field no.32 Value Home (rate) */				
					if ids_bpost.SetItem(il_bpost_row,"f32_valuehome", ld_amount_nodp) <> 1 then
						of_messagebox("Set value error", "can not set column 'f32_valuehome' on " + lstr_category[ll_categoryindex].s_name + " for B-post. u_transaction_estimate.of_fill_transaction()")															
						return(-1)
					end if
					/* Set field no.33 Value Home DP (rate dp) */				
					if ids_bpost.SetItem(il_bpost_row,"f33_valuehome_dp", 2) <> 1 then
						of_messagebox("Set value error", "can not set column 'f32_valuehome_dp' on " + lstr_category[ll_categoryindex].s_name + " for B-post. u_transaction_estimate.of_fill_transaction()")															
						return(-1)
					end if
				end if				
				
				/* apply to debit/credit totals*/
				if lstr_category[ll_categoryindex].s_debitcredit = "debit" then
					ld_debitsum += istr_est.str_hire[ll_periodindex].d_amount
				else
					ld_creditsum += istr_est.str_hire[ll_periodindex].d_amount
				end if
				
			end if
			
		next
		
	end if	
		
next

/* Set field no.8 Doclinenum in B-row */
for ll_row = 1 to ids_bpost.RowCount()
	if ids_bpost.SetItem(ll_row, "f08_doclinenum_b", ll_row + 1) <> 1 then
		of_messagebox("Set value error", "can not set column 'f08_doclinenum_b' for B-post. u_transaction_estimate.of_fill_transaction()")		
		return(-1)
	end if
next

/* settle A-Post part 2 remaining totals */
if ld_creditsum=0.0 and ld_debitsum=0.0 then
	/* we have no figures for a transaction so cancel */
	of_messagebox("Set value error", "No estimated amounts available for this vessel/voyage. u_transaction_estimate.of_fill_transaction()")
	return (-1)
end if	

if isnull(ld_creditsum) then ld_creditsum=0
if isnull(ld_debitsum) then ld_debitsum=0

ld_amount = ld_creditsum - ld_debitsum
if isnull(ld_amount) then ld_amount = 0

/* Set field no.29, 30, 31, 32, 33 DebitCredit, Valuedoc, Value home, decimal points */
if ld_amount >= 0 then
	li_integer = ids_default_values.getitemnumber(1,"debitcredit_debit")
	ld_no_decimal = 100 * Round(ld_amount,2)	
else
	li_integer = ids_default_values.getitemnumber(1,"debitcredit_credit") 
	ld_no_decimal = 100 * (-1 * (Round(ld_amount,2)))
end if 

if ids_apost.SetItem(1,"f29_debitcredit", li_integer) <> 1 then
	of_messagebox("Set value error", "can not set column 'f29_debitcredit' for A-post. u_transaction_estimate.of_fill_transaction()")											
	return(-1)
end if 

if ids_apost.SetItem(1,"f30_valuedoc", ld_no_decimal) <> 1 then
	of_messagebox("Set value error", "can not set column 'f30_valuedoc' for A-post. u_transaction_estimate.of_fill_transaction()")											
	return(-1)
end if 


/* Set field no.31 Valuedoc dp*/
if ids_apost.SetItem(1,"f31_valuedoc_dp", 2) <> 1 then
	of_messagebox("Set value error", "can not set column 'f31_valuedoc_dp' for A-post. u_transaction_estimate.of_fill_transaction()")											
	return(-1)
end if 

/* Set field no.32 Valuehome (hire sum) value calculated earlier */
if ids_apost.SetItem(1,"f32_valuehome", ld_no_decimal_home) <> 1 then
	of_messagebox("Set value error", "can not set column 'f32_valuehome' for A-post. u_transaction_estimate.of_fill_transaction()")											
	return(-1)
end if 


/* Set field no.33 Valuehome dp (hire sum)*/
if ids_apost.SetItem(1,"f33_valuehome_dp", 2) <> 1 then
	of_messagebox("Set value error", "can not set column 'f33_valuehome_dp' for A-post. u_transaction_estimate.of_fill_transaction()")											
	return(-1)
end if 

return 1
end function

on u_transaction_estimate_tcout.create
call super::create
end on

on u_transaction_estimate_tcout.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_apost = create n_ds
ids_bpost = create n_ds
ids_default_values = create n_ds
ids_defaultvaluesax = create mt_n_datastore

ids_apost.dataobject = "d_trans_log_main_a"
ids_bpost.dataobject = "d_trans_log_b"
ids_default_values.DataObject = "d_default_values_maintenance"
ids_defaultvaluesax.dataobject = "d_sq_ff_ax_default_values"

ids_apost.settransobject(SQLCA)
ids_bpost.settransobject(SQLCA)
ids_default_values.settransobject(SQLCA)
ids_defaultvaluesax.settransobject(SQLCA)

if ids_default_values.retrieve() <> 1 then
	of_messagebox("Retrieval error", "No default values for transactions found. Object: u_transactions_estimate, Event: constructor.")
	return
end if

if ids_defaultvaluesax.retrieve() <> 1 then
	of_messagebox("Retrieval error", "No default values for ax transactions found. Object: u_transactions_estimate, Event: constructor.")
	return
end if

end event

event destructor;call super::destructor;destroy ids_apost
destroy ids_bpost
destroy ids_default_values
destroy ids_defaultvaluesax
end event

