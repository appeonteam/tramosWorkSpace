$PBExportHeader$w_print_support_documents.srw
$PBExportComments$Print freight invoices using OLE for Word
forward
global type w_print_support_documents from w_print_claim_basewindow
end type
end forward

global type w_print_support_documents from w_print_claim_basewindow
integer width = 2341
integer height = 1440
string title = "Print Freight"
end type
global w_print_support_documents w_print_support_documents

forward prototypes
public subroutine documentation ()
public function long wf_print_freight ()
public function long wf_print_misc ()
public function long wf_print_dev_hea ()
public subroutine wf_disble_print (boolean ab_disbleprint)
end prototypes

public subroutine documentation ();/********************************************************************
   w_print_support_documents
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		12-19-2011	M5-2  		LGX001		print support documents according to the claims type
		01-09-2012	M5-2  		JMC112		Modified functions: wf_print_freight, wf_print_misc,
		          	      		      		wf_print_dev_hea:
		          	      		      		- fill in transaction structure: s_transaction_input
		          	      		      		- call parent.wf_send_to_ax(s_transaction_input)
		02-02-2012	M5-2  		LGX001		setting the invoice NR must be after calling parent.wf_send_to_ax(s_transaction_input)
		15-02-2012	M5-6  		WWG004		Change print template.
		22-06-2012	CR2834		AGL027		Fix error on MISC claims - when setting broker commission on multiple claims with same type.
		31/10/2012	CR3009		LGX001		Ax_invoice_text should be printed in support document also
		11/06/2013	CR2877		ZSW001		Add reutrn value for function wf_print_dev_hea(), wf_print_freight() and wf_print_misc()
		01/08/2013	CR3305		ZSW001		Fix bug for DEV claim make A transaction equal B transactions.
		12/08/2013	CR2918		ZSW001		When supporting documents are printed after AX invoice has been received, 
											   		the invoice number should be referenced at the top of the supporting documents
		13/06/2014	CR3700		LHG008		If resend invoice data to AX, force user to select an anadjustment reason
		29/07/15  	CR3226		XSZ004		Change label for Bunkers type.
		17/02/16  	CR4289		XSZ004		Fix a bug.
		12/06/16  	CR3117		XSZ004		Change freight claim supporting documents.
		19/09/16  	CR2212		LHG008		Sanctions restrictions
		25/10/16		CR3385		HXH010		Update forwarding date when (Re)send invoice data to AX 
		28/11/17		CR4652		HHX010		Address and broker commission should never be calculated for the bunker parts of a claim
	</HISTORY>
********************************************************************/

end subroutine

public function long wf_print_freight ();/* This function creates support word files .
   The word files are created using OLE objects.*/

string 	ls_subject, ls_date, ls_total_amount, ls_loadports, ls_dischports, ls_overage, ls_bldate 
string 	ls_grade, ls_amount_usd, ls_amount_local, ls_calccurrcode, ls_ex_rate, ls_vessel_imo

long 		ll_row, ll_rows, ll_index=0, ll_cal_cerp_id, ll_fixrate, ll_counter, ll_vessel_imo

decimal 	ld_customer_apl_vat_rate 
decimal ld_ex_rate
decimal{3} ld_quantity, ld_total_quantity 
decimal{2} ld_broker_cms_amt, ld_comm_amountusd, ld_comm_amount, ld_broker_cms_amt_usd, ld_amount_local

datetime	ldt_cp_date, ldt_value_date, ldt_checknull

datastore	lds_load_disch
OLEObject	ole_object, ole_Bookmark
n_claims_transaction	lnv_claimtransaction

// Clone properties of uo_afc and uo_frt_balance from w_claims
string		ls_add_lumps, ls_add_lump_comments, ls_lumpsum_comment[]
double	ld_ws, ld_ws_rate, ld_per_mt, ld_addr_com_pct,ld_main_lumpsum, ld_lumpsum[], ld_lumpsum_sum
double	ld_min1, ld_min2, ld_bol_quantity
double	ld_overage1, ld_overage2, ld_received
double	ld_base_freight, ld_overage, ld_dead_freight, ld_freight, ld_addr_com, ld_net_freight, ld_balance
integer	li_add_lump

long	ll_calcid
mt_n_datastore	lnv_getfixrate

SetPointer(Hourglass!)

ld_ex_rate = 0

lnv_getfixrate = create mt_n_datastore

SELECT CAL_CALC_ID INTO :ll_calcid FROM VOYAGES WHERE VESSEL_NR = :istr_parm.vessel_nr AND VOYAGE_NR = :istr_parm.voyage_nr ;

lnv_getfixrate.dataobject = "d_sq_tb_getfixrate"
lnv_getfixrate.settrans( SQLCA)
lnv_getfixrate.retrieve(istr_parm.vessel_nr, ll_calcid, istr_parm.chart_nr)

ll_fixrate = 0

if lnv_getfixrate.rowcount( )  = 1 then
	ll_fixrate = lnv_getfixrate.getitemnumber( 1, "cal_carg_fix_exrate")
	ls_calccurrcode =  lnv_getfixrate.getitemstring( 1, "cal_carg_cal_carg_curr_code")
	
	if ll_fixrate = 1 and ls_calccurrcode <>  is_currcode then
		ld_ex_rate = lnv_getfixrate.getitemnumber( 1, "cal_carg_fixed_exrate") /100
		ls_ex_rate = string(ld_ex_rate) 
	else
		ll_fixrate = 0
	end if
else
	messagebox("Error","It is not possible to get exchange rate from fixture. Please contact system administrator.")
	ll_fixrate = 0
end if

destroy(lnv_getfixrate)

if ld_ex_rate = 0 then ld_ex_rate = 1 

/********************* NEW *************************/

if  isvalid(w_claims) = false then
	MessageBox("Error", "Invalid Operation!")
	return c#return.Failure
end if

If w_claims.dw_afc.visible then
	ld_ws = w_claims.uo_afc.id_ws
	ld_ws_rate = w_claims.uo_afc.id_ws_rate	
	ld_per_mt = w_claims.uo_afc.id_per_mt	
	ld_lumpsum = w_claims.uo_afc.id_lumpsum
	ls_lumpsum_comment = w_claims.uo_afc.is_lumpsum_comment
	ld_addr_com_pct = w_claims.uo_afc.id_addr_com_pct
	ld_main_lumpsum = w_claims.uo_afc.id_main_lumpsum	
	ld_min1 = w_claims.uo_afc.id_min1
	ld_min2 = w_claims.uo_afc.id_min2
	ld_bol_quantity = w_claims.uo_afc.id_bol_quantity
	ld_overage = w_claims.uo_afc.id_overage
	ld_overage1 = w_claims.uo_afc.id_overage1
	ld_overage2 = w_claims.uo_afc.id_overage2
	ld_received = w_claims.uo_afc.id_received
	ld_base_freight = w_claims.uo_afc.id_base_freight
	ld_dead_freight = w_claims.uo_afc.id_dead_freight
	ld_freight = w_claims.uo_afc.id_freight
	ld_addr_com = w_claims.uo_afc.id_addr_com
	ld_net_freight = w_claims.uo_afc.id_net_freight
	ld_balance = w_claims.uo_afc.id_balance
	ldt_cp_date = w_claims.dw_claim_base.getitemdatetime(1,"cp_date")
Else
	ld_ws = w_claims.uo_frt_balance.id_ws
	ld_ws_rate = w_claims.uo_frt_balance.id_ws_rate
	ld_per_mt = w_claims.uo_frt_balance.id_per_mt
	ld_lumpsum = w_claims.uo_frt_balance.id_lumpsum
	ls_lumpsum_comment = w_claims.uo_frt_balance.is_lumpsum_comment
	ld_addr_com_pct = w_claims.uo_frt_balance.id_addr_com_pct
	ld_main_lumpsum = w_claims.uo_frt_balance.id_main_lumpsum
	ld_min1 = w_claims.uo_frt_balance.id_min1
	ld_min2 = w_claims.uo_frt_balance.id_min2
	ld_bol_quantity = w_claims.uo_frt_balance.id_bol_quantity
	ld_overage = w_claims.uo_frt_balance.id_overage
	ld_overage1 = w_claims.uo_frt_balance.id_overage1
	ld_overage2 = w_claims.uo_frt_balance.id_overage2
	ld_received = w_claims.uo_frt_balance.id_received
	ld_base_freight = w_claims.uo_frt_balance.id_base_freight
	ld_dead_freight = w_claims.uo_frt_balance.id_dead_freight
	ld_freight = w_claims.uo_frt_balance.id_freight
	ld_addr_com = w_claims.uo_frt_balance.id_addr_com
	ld_net_freight = w_claims.uo_frt_balance.id_net_freight
	ld_balance = w_claims.uo_frt_balance.id_balance	
	ldt_cp_date = w_claims.dw_claim_base.getitemdatetime(1,"cp_date")
End If


//Code only for supporting document
if cbx_print.checked = true then
	
	ls_add_lumps = ""
	for li_add_lump =1 to upperbound(ld_lumpsum)
		ld_lumpsum_sum += ld_lumpsum[li_add_lump]
		if ls_add_lumps = "" then
			ls_add_lumps  = string(ld_lumpsum[li_add_lump],"#,##0.00")
		else
			ls_add_lumps  =  ls_add_lumps + "~r~n" + string(ld_lumpsum[li_add_lump],"#,##0.00")	
		end if
	next
	ls_add_lump_comments = ""
	for li_add_lump =1 to upperbound(ls_lumpsum_comment)
		if ls_add_lump_comments = "" then
			ls_add_lump_comments = "Additional lumpsum "+ string(li_add_lump)+": " + ls_lumpsum_comment[li_add_lump]
		else
			ls_add_lump_comments  =  ls_add_lump_comments + "~r~n" + "Additional lumpsum "+ string(li_add_lump)+": " + ls_lumpsum_comment[li_add_lump]
		end if
	next	
		
	// Open word using OLE
	if wf_get_template(ole_object, ole_bookmark )  <= 0 then return c#return.Failure
	
	if not isnull(is_axfreetext) then
		wf_insert_field("customer_reference", "CUSTOMER REFERENCE:", ole_object, ole_Bookmark)
		wf_insert_field("ax_free_text", is_axfreetext, ole_object, ole_Bookmark)
	end if
	
	/* Get Date, Section and Initials  Set in document */
	ls_date = string(today(), "d mmmm yyyy")
	wf_insert_field("Date", ls_date, ole_object, ole_Bookmark)
	wf_insert_field("Initials", is_userfullname, ole_object, ole_Bookmark)
	wf_insert_field("Section", is_profitcenter_name, ole_object, ole_Bookmark)
	//ls_invoice = string(f_get_vsl_ref(istr_parm.vessel_nr)) + "-" + istr_parm.voyage_nr + "-FRT-" + string(istr_parm.claim_nr)
	//wf_insert_field("Invoice_nr", is_invoice, ole_object, ole_Bookmark)
	
	SELECT IMO_NUMBER INTO :ll_vessel_imo FROM VESSELS WHERE VESSEL_NR = :istr_parm.vessel_nr;
	
	if isnull(ll_vessel_imo) then
		ls_vessel_imo = ""
	else 
		ls_vessel_imo = string(ll_vessel_imo)
	end if
	
	ls_subject = is_vesselname + " (IMO " + ls_vessel_imo + ") - " + is_chartfullname + " Charter Party Dated "+string(ldt_cp_date,"d mmmm yyyy") +" " 
	wf_insert_field("Subject", ls_subject, ole_object, ole_Bookmark)
	
	/* Get load/discharge port, product and quantity and set tehm in document */
	lds_load_disch = CREATE datastore
	lds_load_disch.dataobject = "d_sq_tb_freight_invoice_cargo"
	lds_load_disch.settransobject(SQLCA)
	lds_load_disch.retrieve(istr_parm.vessel_nr,istr_parm.voyage_nr, istr_parm.chart_nr)
	
	wf_insert_field("Loadport", "Loaded", ole_object, ole_Bookmark)
	wf_insert_field("Dischport", "Discharged", ole_object, ole_Bookmark)
		
	ld_total_quantity = 0
	
	do while lds_load_disch.rowCount() > 0
		
		ll_index ++
		
		ld_quantity   = 0
		ls_loadports  = ""
		ls_dischports = ""
		
		lds_load_disch.sort()
		
		ls_grade = lds_load_disch.getItemString(1, "grade_name")
		
		lds_load_disch.setFilter("grade_name='"+ls_grade+"'")
		lds_load_disch.filter()
		
		ls_bldate = lds_load_disch.describe("evaluate('compute_bldate', 1)")
		ll_rows   = lds_load_disch.rowcount()
		
		for ll_row = 1 to ll_rows
			/* Check if discharge port is empty */
			ldt_checknull = lds_load_disch.getItemDatetime(ll_row, "port_dept_dt")
			if isNull(ldt_checknull) then 
				ls_date = ""
			else
				ls_date = " - "+string(ldt_checknull, "d mmm yyyy")
			end if
	
			if lds_load_disch.getItemNumber(ll_row, "bol_l_d") = 1 then
				ld_quantity += lds_load_disch.getItemNumber(ll_row, "quantity")
				ld_total_quantity += lds_load_disch.getItemNumber(ll_row, "quantity")
				if Len(ls_loadports) > 0 then ls_loadports += "~n"
				ls_loadports += lds_load_disch.getItemString(ll_row, "port_n") +"~n"+string(lds_load_disch.getItemDatetime(ll_row, "port_arr_dt"),"d mmm yyyy")+ls_date
			else
				if Len(ls_dischports) > 0 then ls_dischports += "~n"
				ls_dischports += lds_load_disch.getItemString(ll_row, "port_n") +"~n"+string(lds_load_disch.getItemDatetime(ll_row, "port_arr_dt"),"d mmm yyyy")+ls_date
			end if			
		next
		
		if ls_bldate <> "" then
			ls_bldate = "~n" + ls_bldate
		end if
		
		wf_insert_field("quantity" + string(ll_index), ls_grade + "~n" + string(ld_quantity, "#,##0.000")+" mts " + ls_bldate, ole_object, ole_Bookmark)
		wf_insert_field("loadport" + string(ll_index), ls_loadports, ole_object, ole_Bookmark)
		wf_insert_field("dischport" + string(ll_index), ls_dischports, ole_object, ole_Bookmark)
		
		for ll_row = 1 to ll_rows
			lds_load_disch.deleterow(1)
		next
		lds_load_disch.setFilter("")
		lds_load_disch.filter()
		lds_load_disch.sort( )
	loop
	
	ll_index ++
	ls_dischports = ""
	
	lds_load_disch.dataobject = "d_sq_gr_dischargepoc"
	
	sqlca.autocommit = true
	
	lds_load_disch.settransobject(sqlca)
	lds_load_disch.retrieve(istr_parm.vessel_nr,istr_parm.voyage_nr, string(istr_parm.chart_nr))
	
	sqlca.autocommit = false
	
	ll_rows = lds_load_disch.rowcount()
	
	for ll_row = 1 to ll_rows
		
		ldt_checknull = lds_load_disch.getItemDatetime(ll_row, "poc_port_dept_dt")
		
		if isNull(ldt_checknull) then 
			ls_date = ""
		else
			ls_date = " - " + string(ldt_checknull, "d mmm yyyy")
		end if
		
		if Len(ls_dischports) > 0 then ls_dischports += "~n"
		
		ls_dischports += lds_load_disch.getItemString(ll_row, "ports_port_n") + "~n" + string(lds_load_disch.getItemDatetime(ll_row, "poc_port_arr_dt"), "d mmm yyyy") + ls_date
	
	next
	
	wf_insert_field("dischport" + string(ll_index), ls_dischports, ole_object, ole_Bookmark)
	
	destroy lds_load_disch
	
	wf_insert_field("TOTQuantity",string(ld_total_quantity, "#,##0.000")+" mts", ole_object, ole_Bookmark)
	
	/* Build and set overage string in document */
	if not isnull(ld_min1) then
			ls_overage = "(Overage " + string(ld_min1,"#,###.000") + " mts " + &
			string(ld_overage1,"#,###.00") + "%"
		if not isnull (ld_min2) then
			ls_overage += ", " + string(ld_min2,"#,###.000") + " mts " + &
			string(ld_overage2,"#,###.00") + "%"
		end if
	end if
	if len(ls_overage) > 5 then ls_overage += ")"
	
	// bunker adjustment / escalation added to overage line 
	s_frt_data lstr_frt_data[25]
	
	SELECT CAL_CERP_ID
	INTO :ll_cal_cerp_id
	FROM FREIGHT_CLAIMS
	WHERE VESSEL_NR = :istr_parm.vessel_nr
	AND VOYAGE_NR = :istr_parm.voyage_nr
	AND CHART_NR = :istr_parm.chart_nr
	AND CLAIM_NR = :istr_parm.claim_nr;
	COMMIT;
	u_calc_nvo uo_calc_nvo
	uo_calc_nvo = create u_calc_nvo
	uo_calc_nvo.uf_frt_data(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, ll_cal_cerp_id , lstr_frt_data )
	destroy uo_calc_nvo
	if lstr_frt_data[1].bunker_escalation > 0 then
		ls_overage += " (Bunker Adjustment: "+string(lstr_frt_data[1].mts,"#,##0.00") +" + " +string(lstr_frt_data[1].bunker_escalation,"#,##0.00")+" = " +string(lstr_frt_data[1].mts + lstr_frt_data[1].bunker_escalation,"#,##0.00")+")"
	elseif lstr_frt_data[1].bunker_escalation < 0 then
		ls_overage += " (Bunker Adjustment: "+string(lstr_frt_data[1].mts,"#,##0.00") +" - " +string(abs(lstr_frt_data[1].bunker_escalation),"#,##0.00")+" = " +string(lstr_frt_data[1].mts + lstr_frt_data[1].bunker_escalation,"#,##0.00")+")"
	end if
	
	if len(ls_overage) > 5 then wf_insert_field("overage", ls_overage, ole_object, ole_Bookmark)
	
	/* Build detail freight calculation */
	// We do have 5 possible combinations + overage 1 and 2:
	//	1. Lumpsum, if > 0 and <> null 
	//		ld_main_lumpsum
	//	2. WS, if WS > 0 and <> null
	//		2.1 WS + add. lump, (if WS > 0 and <> null) then add. lump if add.lump > 0 and <> null
	//	3. $ pr. ton, if $ pr. ton > 0 and <> null
	//		3.1 $ pr. ton + add. lump (if $ pr. ton > 0 and <> null) then add. lump if add.lump > 0 and <> null
		
	wf_insert_field("equal1", "=", ole_object, ole_Bookmark)								/* always set. must be at least one combination present */
	wf_insert_field("currency1", is_currcode, ole_object, ole_Bookmark)
	
	 /* WS Filled in */
	if Not IsNull(ld_ws) then
			
		IF Isnull(ld_min2) and Isnull(ld_min1) THEN	
			/* Min_1 og Min_2 ikke indtastet */
			wf_insert_field("detail1",string(ld_bol_quantity, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+")", ole_object, ole_Bookmark)
			wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
			if upperbound(ld_lumpsum) > 0 then 
				wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
				wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
				wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
			end if	
		
		ELSEIF IsNull(ld_min2) THEN
			/* Min_2 ikke indtastet */
			if ld_bol_quantity >= ld_min1 then
				wf_insert_field("detail1",string(ld_min1, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+")", ole_object, ole_Bookmark)
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("detail2",string(ld_bol_quantity - ld_min1, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+") * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_overage,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", ls_add_lumps , ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
				
			else	
				wf_insert_field("detail1",string(ld_bol_quantity, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+")", ole_object, ole_Bookmark)
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("detail2",string(ld_min1 - ld_bol_quantity, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+") - Deadfreight", ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_dead_freight,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
				
			end if
			
		ELSE
				
			IF ld_bol_quantity >= ld_min2 THEN
				wf_insert_field("detail1",string(ld_min1, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+")", ole_object, ole_Bookmark)
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("detail2",string(ld_min2 - ld_min1, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+") * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string((((ld_min2 - ld_min1) * (ld_overage1 * ld_ws / 10000) * ld_ws_rate)),"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3", CharA(13) + CharA(10) + ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", CharA(13) + CharA(10) + ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", CharA(13) + CharA(10) + "=", ole_object, ole_Bookmark)
				end if
				wf_insert_field("detail3",string(ld_bol_quantity - ld_min2, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+") * "+string(ld_overage2/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount3", string((((ld_bol_quantity - ld_min2) * (ld_overage2 * ld_ws / 10000) * ld_ws_rate)),"#,##0.00"), ole_object, ole_Bookmark)	
				
			ELSEIF ld_bol_quantity >= ld_min1 THEN
				wf_insert_field("detail1",string(ld_min1, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+")", ole_object, ole_Bookmark)
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("detail2",string(ld_bol_quantity - ld_min1, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+") * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_overage,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
				
			ELSE
				wf_insert_field("detail1",string(ld_bol_quantity, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+")", ole_object, ole_Bookmark)
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("detail2",string(ld_min1 - ld_bol_quantity, "#,##0.000")+" mts * WS ( "+string(ld_ws)+") * Flatrate ("+string(ld_ws_rate,"#,###.###")+") - Deadfreight", ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_dead_freight,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
			END IF
				
		END IF	
	
	/* Per mt filled in */
	ELSEIF Not IsNull(ld_per_mt) THEN		
			
		if Isnull(ld_min2) and Isnull(ld_min1) then	
			/* Min_1 og Min_2 ikke indtastet */
			if  ll_fixrate = 1 then
				wf_insert_field("detail1", string(ld_bol_quantity, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate  ,"#,###.00")+ " * " + ls_ex_rate + " per mt", ole_object, ole_Bookmark)
			else
				wf_insert_field("detail1",string(ld_bol_quantity, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt ,"#,###.00")+" per mt", ole_object, ole_Bookmark)
			end if
			wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
			if upperbound(ld_lumpsum) > 0 then 
				wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
				wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
				wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
			end if	
				
		elseif IsNull(ld_min2) then
			/* Min_2 ikke indtastet */
			IF ld_bol_quantity >= ld_min1 THEN
				if  ll_fixrate = 1 then
					wf_insert_field("detail1", string(ld_min1, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate + " per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2",string(ld_bol_quantity - ld_min1, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate+" per mt * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				else
					wf_insert_field("detail1",string(ld_min1, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2",string(ld_bol_quantity - ld_min1, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				end if
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)	
				
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_overage,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3",ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
				
			else
				
				if  ll_fixrate = 1 then
					wf_insert_field("detail1", string(ld_bol_quantity, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00") + " * " + ls_ex_rate +" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2", string(ld_min1 - ld_bol_quantity, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate +" per mt - Deadfreight", ole_object, ole_Bookmark)
				else
					wf_insert_field("detail1",string(ld_bol_quantity, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2",string(ld_min1 - ld_bol_quantity, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt - Deadfreight", ole_object, ole_Bookmark)
				end if
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_dead_freight,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
			end if
		else
			/**/
			IF ld_bol_quantity >= ld_min2 THEN
				if  ll_fixrate = 1 then
					wf_insert_field("detail1", string(ld_min1, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate +" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2", string(ld_min2 - ld_min1, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate +" per mt * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				else
					wf_insert_field("detail1", string(ld_min1, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2",string(ld_min2 - ld_min1, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)				
				end if
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(((ld_min2 - ld_min1) * (ld_overage1/100 * ld_per_mt)),"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",CharA(13) + CharA(10) + ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3",CharA(13) + CharA(10) + ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", CharA(13) + CharA(10)+ "=", ole_object, ole_Bookmark)
				end if
				if  ll_fixrate = 1 then
					wf_insert_field("detail3",string(ld_bol_quantity - ld_min2, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate+" per mt * "+string(ld_overage2/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				else
					wf_insert_field("detail3", string(ld_bol_quantity - ld_min2, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt * "+string(ld_overage2/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				end if
				wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount3", string(((ld_bol_quantity - ld_min2) * (ld_overage2/100 * ld_per_mt)),"#,##0.00"), ole_object, ole_Bookmark)
			
			ELSEIF ld_bol_quantity >= ld_min1 THEN
				if  ll_fixrate = 1 then
					wf_insert_field("detail1",  string(ld_min1, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate+" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2", string(ld_bol_quantity - ld_min1, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate+" per mt * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				else
					wf_insert_field("detail1",string(ld_min1, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+"per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2",string(ld_bol_quantity - ld_min1, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt * "+string(ld_overage1/100,"###.00%")+" - Overage", ole_object, ole_Bookmark)
				end if
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_overage,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3", ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
				
			ELSE
				if  ll_fixrate = 1 then
					wf_insert_field("detail1", string(ld_bol_quantity, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate+" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2", string(ld_min1 - ld_bol_quantity, "#,##0.000")+" mts * " + ls_calccurrcode + " "+string(ld_per_mt/ld_ex_rate,"#,###.00")+ " * " + ls_ex_rate+" per mt - Deadfreight", ole_object, ole_Bookmark)
				else
					wf_insert_field("detail1",string(ld_bol_quantity, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt", ole_object, ole_Bookmark)
					wf_insert_field("detail2",string(ld_min1 - ld_bol_quantity, "#,##0.000")+" mts * " + is_currcode + " "+string(ld_per_mt,"#,###.00")+" per mt - Deadfreight", ole_object, ole_Bookmark)
				end if
				wf_insert_field("amount1", string((ld_base_freight - ld_lumpsum_sum),"#,##0.00"), ole_object, ole_Bookmark)
				wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
				wf_insert_field("amount2", string(ld_dead_freight,"#,##0.00"), ole_object, ole_Bookmark)
				if upperbound(ld_lumpsum) > 0 then 
					wf_insert_field("detail3",ls_add_lump_comments, ole_object, ole_Bookmark)
					wf_insert_field("amount3",ls_add_lumps, ole_object, ole_Bookmark)
					wf_insert_field("equal3", "=", ole_object, ole_Bookmark)
				end if	
			END IF	
		END IF		
	
	/* Lumpsum filled in */
	ELSEIF Not Isnull(ld_main_lumpsum) THEN
		
		wf_insert_field("detail1", "Freight lumpsum", ole_object, ole_Bookmark)
		wf_insert_field("amount1", string(ld_main_lumpsum,"#,##0.00"), ole_object, ole_Bookmark)
		if upperbound(ld_lumpsum) > 0 then 
			wf_insert_field("detail2",ls_add_lump_comments, ole_object, ole_Bookmark)
			wf_insert_field("amount2", ls_add_lumps, ole_object, ole_Bookmark)
			wf_insert_field("equal2", "=", ole_object, ole_Bookmark)
		end if
		
	ELSE
		MessageBox("Generation error", "Not possible to generate freight invoice. Please contact system administrator")
	END IF
	
	/* Address commission */
	if (ld_addr_com_pct > 0) then
		wf_insert_field("adrcomm", "Less address commission " + string(ld_addr_com_pct,"#,##0.00") + " pct", ole_object, ole_Bookmark)
		wf_insert_field("amount4",  "-" + String(ld_addr_com, "#,##0.00"), ole_object, ole_Bookmark)
	end if
end if


//CALCULATION OF BROKER COMMISSION - START	
ll_rows = dw_brokers.rowcount()
ll_counter= 1
if (ll_rows > 0) then
	FOR ll_row= ll_rows TO 1 step -1
		if (dw_brokers.isselected(ll_row)) then
			ii_broker_nr = dw_brokers.getitemnumber(ll_row, "brokers_broker_nr")
			
			SELECT sum(COMMISSIONS.COMM_AMOUNT)  , sum(COMMISSIONS.COMM_AMOUNT_LOCAL_CURR)  
			INTO :ld_comm_amountusd, :ld_comm_amount
			FROM COMMISSIONS,   
					CLAIMS  
			WHERE ( CLAIMS.CHART_NR = COMMISSIONS.CHART_NR ) and  
					( CLAIMS.VESSEL_NR = COMMISSIONS.VESSEL_NR ) and  
					( CLAIMS.VOYAGE_NR = COMMISSIONS.VOYAGE_NR ) and  
					( CLAIMS.CLAIM_NR = COMMISSIONS.CLAIM_NR ) and  
					( ( COMMISSIONS.VESSEL_NR = :istr_parm.vessel_nr ) AND  
					( COMMISSIONS.VOYAGE_NR = :istr_parm.voyage_nr ) AND  
					( COMMISSIONS.CHART_NR = :istr_parm.chart_nr ) AND  
					( COMMISSIONS.BROKER_NR = :ii_broker_nr ) AND  
					( CLAIMS.CLAIM_TYPE = "FRT" ) ) 
					USING SQLCA;
			COMMIT USING SQLCA;
			
			if cbx_print.checked = true then
				wf_insert_field("brokercomm", "~r" + dw_brokers.getitemstring(ll_row, "brokers_broker_name"),ole_object, ole_Bookmark)
				wf_insert_field("amount5", "~r-" + string(ld_comm_amount, "#,###.00"), ole_object, ole_Bookmark)
			end if
			
			ld_broker_cms_amt += dec(string(ld_comm_amount, "#,###.00"))
			ld_broker_cms_amt_usd += dec(string(ld_comm_amountusd, "#,###.00"))
			
			istr_transaction_input.broker_amount_array[ll_counter]=dec(string(ld_comm_amount, "#,###.00"))
			istr_transaction_input.broker_id_array[ll_counter] = ii_broker_nr
			ll_counter+=1
		end if
	NEXT
End if
		


ls_total_amount = string((dec(string(ld_freight,"#,###.00")) &
											- dec(string(ld_addr_com,"#,###.00")) &
											- dec(string(ld_broker_cms_amt,"#,###.00"))),"#,###.00")

wf_set_sanctioninfo(dec(ls_total_amount))

if cbx_sendax.checked = true then 
    //Proccess Transaction
	istr_transaction_input.payment_amount = dec(ls_total_amount)					//TOTAL AMOUNT
	istr_transaction_input.amount_local= dec(string(ld_freight,"#,###.00")) 		//INVOICE AMOUNT
	istr_transaction_input.comm_amount =dec(string(ld_addr_com,"#,###.00")) 	//ADDRESS COMMISSION
	wf_set_forwarding_date()
	wf_send_to_ax()
end if

if cbx_print.checked = true then
	ld_amount_local = dec(ld_freight)
	/* Get/generate Invoice number(is_invoice). M5-2 Added by LGX001 on 23/12/2011. */
	if this.wf_get_invoice(ld_amount_local) = c#return.Failure then
		messagebox("Database Read Error", "Error reading from table claims.~r~nSQLErrText=" + SQLCA.SQLErrText)
		
		Destroy ole_Bookmark
		Destroy ole_object
		
		cb_close.enabled = true
		cb_close.triggerevent(clicked!)
		return c#return.Failure
	end if
	
	wf_insert_field("Invoice_nr", is_invoice, ole_object, ole_Bookmark)
	
	/* Total amount and curerncy */
	wf_insert_field("currency2", is_currcode, ole_object, ole_Bookmark)
	//wf_insert_field("currency3", is_currcode, ole_object, ole_Bookmark)
	
	wf_insert_field("amount6", ls_total_amount, ole_object, ole_Bookmark)
	
	if dw_paymentcurr.visible = true then
		wf_insert_field("sanction_line1", istr_transaction_input.s_sanction_line_1, ole_object, ole_Bookmark)
		wf_insert_field("sanction_line2", istr_transaction_input.s_sanction_line_2, ole_object, ole_Bookmark)
	end if
	
	ole_object.visible = True
	
	ole_Bookmark.disconnectobject()
	Destroy ole_Bookmark
	Destroy ole_object
end if

Return c#return.Success

end function

public function long wf_print_misc ();string 	currency_code, ls_vatnr, ls_invoice
string 	ls_subject, ls_date, ls_amount, ls_total_amount
string	ls_claim1, ls_addr, ls_addr_amount

decimal	ld_claim_amount
decimal	ld_customer_apl_vat_rate, ld_acustomer_apl_vat_rate, ld_addr_amount, ld_bunker_amount
decimal{2} ld_broker_cms_amt, ld_comm_amount, ld_amount_local

long 		ll_row, ll_broker_nr, ll_rows, ll_counter

oleobject 	ole_object, ole_bookmark


setpointer(hourglass!)

if  isvalid(w_claims) = false then
	messagebox("Error", "Invalid Operation!")
	return c#return.Failure
end if


//ls_invoice = string(f_get_vsl_ref(istr_parm.vessel_nr)) + "-" + istr_parm.voyage_nr + "-" + istr_parm.claim_type +"-" + string(istr_parm.claim_nr)


/**********************************************************************/
/*     CREATION OF INVOICE SUPPORT DOCUMENTS                          */
/**********************************************************************/

if cbx_print.checked = true then
	if wf_get_template(ole_object, ole_bookmark)  <= 0 then return c#return.Failure
end if

ls_claim1 = istr_parm.claim_type
SELECT CLAIM_TYPES.CLAIM_DESC INTO :ls_claim1 FROM CLAIM_TYPES
WHERE CLAIM_TYPES.CLAIM_TYPE = :istr_parm.claim_type 	COMMIT using sqlca;	

ld_claim_amount = w_claims.dw_claim_base.getitemnumber(1, "claim_amount")

ls_amount = string(ld_claim_amount, "#,###.00")

ls_addr = "Less address commission " + string(w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com"), "#,###.00") + " pct"

if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_price")) then
	ld_bunker_amount = dec(string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_price"),"#,###.00")) 
end if
if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_price")) then
	ld_bunker_amount +=dec(string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_price"),"#,###.00")) 
end if
if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_price")) then
	ld_bunker_amount += dec(string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_price"),"#,###.00")) 
end if
if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_price")) then
	ld_bunker_amount += dec(string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_price"),"#,###.00")) 
end if

if not isnull(w_claims.dw_claim_base.getitemnumber(1, "claims_address_com")) then	
	ld_addr_amount = dec(string((ld_claim_amount  - ld_bunker_amount) * (w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com")/100),"#,###.00")) 
	ls_addr_amount = string(ld_addr_amount, "#,###.00")
else
	ls_addr_amount = ""
	ls_addr = ""
end if

//CALCULATION OF BROKER COMMISSION - START	

ll_rows = dw_brokers.rowcount()

ll_counter= 1

if (ll_rows > 0) then
	for ll_row = ll_rows to 1 step -1
		if (dw_brokers.isselected(ll_row)) then
			ll_broker_nr = dw_brokers.getitemnumber(ll_row, "brokers_broker_nr")
			
			SELECT  sum(COMMISSIONS.COMM_AMOUNT_LOCAL_CURR)
				INTO :ld_comm_amount
				FROM COMMISSIONS,
				CLAIMS
				WHERE ( CLAIMS.CHART_NR = COMMISSIONS.CHART_NR ) AND
				( CLAIMS.VESSEL_NR = COMMISSIONS.VESSEL_NR ) AND
				( CLAIMS.VOYAGE_NR = COMMISSIONS.VOYAGE_NR ) AND
				( CLAIMS.CLAIM_NR = COMMISSIONS.CLAIM_NR ) AND
				( ( COMMISSIONS.VESSEL_NR = :istr_parm.vessel_nr ) AND
				( COMMISSIONS.VOYAGE_NR = :istr_parm.voyage_nr ) AND
				( COMMISSIONS.CHART_NR = :istr_parm.chart_nr ) AND
				( COMMISSIONS.BROKER_NR = :ll_broker_nr ) AND
				( CLAIMS.CLAIM_TYPE = :istr_parm.claim_type ) AND
				( CLAIMS.CLAIM_NR = :istr_parm.claim_nr  ))
				using sqlca;
			COMMIT using sqlca;
			if cbx_print.checked = true then
				wf_insert_field("Deduction2", "~r" + dw_brokers.getitemstring(ll_row, "brokers_broker_name"), ole_object, ole_bookmark)
				wf_insert_field("AmountUSD3", "~r" + string(ld_comm_amount , "#,###.00"), ole_object, ole_bookmark)
			end if
			ld_broker_cms_amt += dec(string(ld_comm_amount, "#,###.00"))
					
			istr_transaction_input.broker_amount_array[ll_counter]=dec(string(ld_comm_amount, "#,###.00"))
			istr_transaction_input.broker_id_array[ll_counter] = ll_broker_nr
			ll_counter+=1
			
		end if
	next
end if

//CALCULATION OF BROKER COMMISSION - END	

// Strings to be put in the letter

// LS_SUBJECT
ls_subject = is_vesselname +" - " + is_chartfullname + " Charter Party dated "+string(idt_cpdate, "d mmmm yyyy") +" " 

// LS_DATE
ls_date = string(today(), "d mmmm yyyy")

// LS_TOTAL_AMOUNT
ls_total_amount = string((dec(string(ld_claim_amount, "#,###.00")) &
	- dec(string(ld_addr_amount, "#,###.00")) - dec(string(ld_broker_cms_amt, "#,###.00"))), "#,###.00")

// Used in wf_forwarding date inserted 051102
// Can be used because we know wf_forwarding only adds comments when in EURO
is_amount_local = string((dec(string(w_claims.dw_claim_base.getitemdecimal(1, "claim_amount"), "#,###.00")) &
	- dec(string(ld_addr_amount, "#,###.00")) - dec(string(ld_broker_cms_amt, "#,###.00"))), "#,###.00")
is_amount_usd = ls_total_amount

wf_set_sanctioninfo(dec(ls_total_amount))

if cbx_sendax.checked = true then 
    //Proccess Transaction
	istr_transaction_input.payment_amount = dec(ls_total_amount)
	istr_transaction_input.amount_local = dec(ls_amount)
	istr_transaction_input.comm_amount =dec(ls_addr_amount)
	wf_set_forwarding_date()
	wf_send_to_ax()
end if



if cbx_print.checked = true then
	//M5-2 Added by LGX001 on 23/12/2011. INVOICE  set is_invoice
	ld_amount_local = dec(ls_amount)
	if this.wf_get_invoice(ld_amount_local) = c#return.Failure then
		messagebox("Database Read Error", "Error reading from table claims.~r~nSQLErrText=" + SQLCA.SQLErrText)
		Destroy ole_Bookmark
		Destroy ole_object
		
		cb_close.enabled = true
		cb_close.triggerevent(clicked!)
		
		return c#return.Failure
	end if
	
	if not isnull(is_axfreetext) then
		wf_insert_field("customer_reference", "CUSTOMER REFERENCE:", ole_object, ole_Bookmark)
		wf_insert_field("ax_free_text", is_axfreetext, ole_object, ole_Bookmark)
	end if
	
	//M5-6 added by WWG004 on 15/02/2012. Change desc: change print template
	ls_invoice = "SUPPORTING DOCUMENT TO REFERENCE: " + is_invoice
	
	wf_insert_field("Section", is_profitcenter_name, ole_object, ole_bookmark)// profitcenter, ole_object, ole_bookmark)
	wf_insert_field("Date", ls_date, ole_object, ole_bookmark)
	wf_insert_field("Initials",is_userfullname, ole_object, ole_bookmark)//    uo_global.is_userid, ole_object, ole_bookmark)
	wf_insert_field("Subject", ls_subject, ole_object, ole_bookmark)
	wf_insert_field("Invoice", ls_invoice, ole_object, ole_bookmark)
	wf_insert_field("Claimtype", upper(ls_claim1) + " INVOICE", ole_object, ole_bookmark)
	wf_insert_field("Claimtype2", ls_claim1 + " amount", ole_object, ole_bookmark)
	//wf_insert_field("Claimtype3", ls_claim1, ole_object, ole_bookmark)
	wf_insert_field("Deduction1", ls_addr, ole_object, ole_bookmark)
	
	wf_insert_field("AmountUSD1", ls_amount, ole_object, ole_bookmark)
	wf_insert_field("AmountUSD2", ls_addr_amount, ole_object, ole_bookmark)
	wf_insert_field("AmountUSD4", ls_total_amount, ole_object, ole_bookmark)
	
	wf_insert_field("Currency1", is_currcode , ole_object, ole_bookmark)
	wf_insert_field("Currency2", is_currcode, ole_object, ole_bookmark)
	//wf_insert_field("Currency3", is_currcode, ole_object, ole_bookmark)
	
	wf_insert_field("Name1", "", ole_object, ole_bookmark)
	
	if dw_paymentcurr.visible = true then
		wf_insert_field("sanction_line1", istr_transaction_input.s_sanction_line_1, ole_object, ole_Bookmark)
		wf_insert_field("sanction_line2", istr_transaction_input.s_sanction_line_2, ole_object, ole_Bookmark)
	end if
	
   ole_object.visible = True

	Destroy ole_Bookmark
	Destroy ole_object

end if

return c#return.Success

end function

public function long wf_print_dev_hea ();string 		ls_subject, ls_date, ls_amount, ls_total_amount
string		ls_claim1, ls_claim2, ls_addr, ls_addr_amount, ls_dev_hea, ls_invoice
decimal 		ld_customer_apl_vat_rate, ld_acustomer_apl_vat_rate
decimal{2} 	ld_broker_cms_amt, ld_comm_amount_usd, ld_comm_amount, ld_amount_local
long 			ll_row, ll_broker_nr, ll_rows, ll_counter
oleobject 	ole_object, ole_bookmark

setpointer(hourglass!)


//ls_invoice = string(f_get_vsl_ref(istr_parm.vessel_nr)) + "-" + istr_parm.voyage_nr + "-" + istr_parm.claim_type +"-" + string(istr_parm.claim_nr)


/********************************************************/
/*     CREATION OF  INVOICE SUPPORT DOCUMENTS           */
/********************************************************/
if cbx_print.checked = true then 
	if wf_get_template(ole_object, ole_bookmark)  <= 0 then return c#return.Failure
end if

if (istr_parm.claim_type = "HEA") then
	ls_claim1 = "HEATING"
	ls_claim2 = "Heating"
else
	ls_claim1 = "DEVIATION"
	ls_claim2 = "Deviation"
end if

if isvalid(w_claims) then
	ls_dev_hea += ls_claim2 + " amount"
	//ls_amount = String(w_claims.dw_hea_dev_claim.getitemdecimal(1,"hea_dev_amount")*ld_ex_rate,"#,###.00")
	//seperate time and bunkers
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day")) then
		ls_amount += "~r" + string((w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day"))/24, "#,##0.00")
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_price")) then
		ls_amount += "~r" + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_price"), "#,##0.00")
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_price")) then
		ls_amount += "~r" + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_price"), "#,##0.00")
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_price")) then
		ls_amount += "~r" + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_price"), "#,##0.00")
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_price")) then
		ls_amount += "~r" + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_ton")*w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_price"), "#,##0.00")
	end if
	
	// if no address commission then it should not be on the claim
	if isnull(w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com")) then
		ls_addr = ""
	else
		ls_addr = "Less address commission " + string(w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com"), "#,##0.00") + " pct"
	end if
	
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day")) then
		ls_dev_hea += "~r" + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours"), "#,##0.0000") + " hours * " + &
			string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day"), "#,##0.00") + " per day"
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_price")) then
		ls_dev_hea += "~rHSFO: " + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_ton"), "#,##0.0000") + " mt * " + &
			string (w_claims.dw_hea_dev_claim.getitemdecimal(1, "hfo_price"), "#,##0.0000") + " per mt"
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_price")) then
		ls_dev_hea += "~rLSGO: " + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_ton"), "#,##0.0000") + " mt * " + &
			string (w_claims.dw_hea_dev_claim.getitemdecimal(1, "do_price"), "#,##0.0000") + " per mt"
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_price")) then
		ls_dev_hea += "~rHSGO: " + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_ton"), "#,##0.0000") + " mt * " + &
			string (w_claims.dw_hea_dev_claim.getitemdecimal(1, "go_price"), "#,##0.0000") + " per mt"
	end if
	if not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_ton")) and not isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_price")) then
		ls_dev_hea += "~rLSFO: " + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_ton"), "#,##0.0000") + " mt * " + &
			string (w_claims.dw_hea_dev_claim.getitemdecimal(1, "lshfo_price"), "#,##0.0000") + " per mt"
	end if
	
	if not isnull(w_claims.dw_claim_base.getitemnumber(1, "claims_address_com")) then
		if isnull(w_claims.dw_hea_dev_claim.getitemnumber(1, "hea_dev_hours")) or isnull(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day")) then
			ls_addr_amount = ""
			ls_addr = ""
		else
			ls_addr_amount = string( &
				(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours") * &
				(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day")/24)  * (w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com")/100)) &
				, "#,##0.00")
			ls_addr += "~r" + string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours"), "#,##0.00") + " hours * " + &
				string(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day"), "#,##0.00") + " per day"
		end if
	end if
	
end if

//CALCULATION OF BROKER COMMISSION - START	

ll_rows = dw_brokers.rowcount()
ll_counter = 1

if (ll_rows > 0) then
	for ll_row = ll_rows to 1 step -1
		if (dw_brokers.isselected(ll_row)) then
			ll_broker_nr = dw_brokers.getitemnumber(ll_row, "brokers_broker_nr")

			SELECT sum(COMMISSIONS.COMM_AMOUNT), sum(COMMISSIONS.COMM_AMOUNT_LOCAL_CURR)
				INTO :ld_comm_amount_usd, :ld_comm_amount
				FROM COMMISSIONS,
				CLAIMS
				WHERE ( CLAIMS.CHART_NR = COMMISSIONS.CHART_NR ) AND
				( CLAIMS.VESSEL_NR = COMMISSIONS.VESSEL_NR ) AND
				( CLAIMS.VOYAGE_NR = COMMISSIONS.VOYAGE_NR ) AND
				( CLAIMS.CLAIM_NR = COMMISSIONS.CLAIM_NR ) AND
				( ( COMMISSIONS.VESSEL_NR = :istr_parm.vessel_nr ) AND
				( COMMISSIONS.VOYAGE_NR = :istr_parm.voyage_nr ) AND
				( COMMISSIONS.CHART_NR = :istr_parm.chart_nr ) AND
				( COMMISSIONS.BROKER_NR = :ll_broker_nr ) AND
				( CLAIMS.CLAIM_TYPE = :istr_parm.claim_type ) AND
				( CLAIMS.CLAIM_NR = :istr_parm.claim_nr))
				using sqlca;
			COMMIT using sqlca;
			
			if cbx_print.checked = true then
				wf_insert_field("Deduction2", "~r" + dw_brokers.getitemstring(ll_row, "brokers_broker_name"), ole_object, ole_bookmark)
				wf_insert_field("AmountUSD3", "~r" + string(ld_comm_amount , "#,##0.00"), ole_object, ole_bookmark)
			end if
			
			ld_broker_cms_amt += dec(string(ld_comm_amount, "#,##0.00"))
				
			istr_transaction_input.broker_amount_array[ll_counter]=dec(string(ld_comm_amount, "#,###.00"))
			istr_transaction_input.broker_id_array[ll_counter] = ll_broker_nr
			ll_counter+=1
			
		end if
	next
end if
//CALCULATION OF BROKER COMMISSION - END	

// LS_SUBJECT
ls_subject = is_vesselname +" - " + is_chartfullname + " Charter Party dated "+string(idt_cpdate, "d mmmm yyyy") +" " 

// LS_DATE
ls_date = string(today(), "d mmmm yyyy")

// LS_TOTAL_AMOUNT
ls_total_amount = string(dec(string(w_claims.dw_hea_dev_claim.getitemnumber(1, "hea_dev_amount"), "#,###.00")) &
	- dec(string( (w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours") * &
	(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day")/24)  * (w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com")/100)) &
	, "#,###.00")) - dec(string(ld_broker_cms_amt, "#,###.00")), "#,###.00")

// Can be used because we know it is going to be used for only euro
is_amount_local = string(dec(string(w_claims.dw_hea_dev_claim.getitemnumber(1, "hea_dev_amount"), "#,###.00")) &
	- dec(string( (w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_hours") * &
	(w_claims.dw_hea_dev_claim.getitemdecimal(1, "hea_dev_price_pr_day")/24)  * (w_claims.dw_claim_base.getitemdecimal(1, "claims_address_com")/100)) &
	, "#,###.00")) - dec(string(ld_broker_cms_amt, "#,###.00")), "#,###.00")

is_amount_usd = ls_total_amount

wf_set_sanctioninfo(dec(ls_total_amount))

if cbx_sendax.checked = true then 
    //Proccess Transaction
	istr_transaction_input.payment_amount = dec(ls_total_amount)
	istr_transaction_input.comm_amount =dec(ls_addr_amount)
	//istr_transaction_input.amount_local = dec(ls_amount)
	istr_transaction_input.amount_local = dec(string(istr_transaction_input.payment_amount + istr_transaction_input.comm_amount + ld_broker_cms_amt,"#,##0.00"))
	
	wf_set_forwarding_date()
	
	wf_send_to_ax()
	
end if

if cbx_print.checked = true then
	// M5-2 Added by LGX001 on 23/12/2011. INVOICE  set is_invoice
	ld_amount_local = w_claims.dw_hea_dev_claim.getitemnumber(1, "hea_dev_amount")
	if this.wf_get_invoice(ld_amount_local) = c#return.Failure then
		messagebox("Database Read Error", "Error reading from table claims.~r~nSQLErrText=" + SQLCA.SQLErrText)
		destroy ole_Bookmark
		destroy ole_object
		cb_close.enabled = true
		cb_close.triggerevent(clicked!)
		return c#return.Failure
	end if
	
	if not isnull(is_axfreetext) then
		wf_insert_field("customer_reference", "CUSTOMER REFERENCE:", ole_object, ole_Bookmark)
		wf_insert_field("ax_free_text", is_axfreetext, ole_object, ole_Bookmark)
	end if
	
	//M5-6 added by WWG004 on 15/02/2012. Change desc: change print template
	ls_invoice = "SUPPORTING DOCUMENT TO REFERENCE: " + is_invoice
	
	wf_insert_field("Section", is_profitcenter_name, ole_object, ole_bookmark) //profitcenter, ole_object, ole_bookmark)
	wf_insert_field("Date", ls_date, ole_object, ole_bookmark)
	wf_insert_field("Initials", is_userfullname, ole_object, ole_bookmark)
	wf_insert_field("Subject", ls_subject, ole_object, ole_bookmark)
	wf_insert_field("Invoice", ls_invoice, ole_object, ole_bookmark)
	wf_insert_field("Claimtype", ls_claim1 + " INVOICE", ole_object, ole_bookmark)
	wf_insert_field("Claimtype2", ls_dev_hea, ole_object, ole_bookmark) //context
	//wf_insert_field("Claimtype3", ls_claim2, ole_object, ole_bookmark)
	wf_insert_field("Deduction1", ls_addr, ole_object, ole_bookmark)
	
	wf_insert_field("AmountUSD1", ls_amount, ole_object, ole_bookmark) //anount
	wf_insert_field("AmountUSD2", ls_addr_amount, ole_object, ole_bookmark)
	wf_insert_field("AmountUSD4", ls_total_amount, ole_object, ole_bookmark)
	
	wf_insert_field("Currency1", is_currcode , ole_object, ole_bookmark)
	wf_insert_field("Currency2", is_currcode, ole_object, ole_bookmark)
	//wf_insert_field("Currency3", is_currcode, ole_object, ole_bookmark)

	
	if dw_paymentcurr.visible = true then
		wf_insert_field("sanction_line1", istr_transaction_input.s_sanction_line_1, ole_object, ole_Bookmark)
		wf_insert_field("sanction_line2", istr_transaction_input.s_sanction_line_2, ole_object, ole_Bookmark)
	end if
	
   ole_object.visible = True
	 
	Destroy ole_Bookmark
	Destroy ole_object

end if

return c#return.Success

end function

public subroutine wf_disble_print (boolean ab_disbleprint);if ab_disbleprint then
	cb_print.enabled = false
else
	cb_print.enabled = (cbx_sendax.checked or cbx_print.checked)
end if
end subroutine

on w_print_support_documents.create
call super::create
end on

on w_print_support_documents.destroy
call super::destroy
end on

type st_hidemenubar from w_print_claim_basewindow`st_hidemenubar within w_print_support_documents
end type

type dw_claim_sent from w_print_claim_basewindow`dw_claim_sent within w_print_support_documents
integer x = 37
integer y = 1000
integer taborder = 50
end type

type cbx_print from w_print_claim_basewindow`cbx_print within w_print_support_documents
integer x = 37
integer y = 1156
integer width = 713
integer taborder = 70
end type

type cbx_office from w_print_claim_basewindow`cbx_office within w_print_support_documents
boolean visible = false
integer x = 1061
integer y = 272
boolean enabled = false
end type

type cbx_alt_adress from w_print_claim_basewindow`cbx_alt_adress within w_print_support_documents
boolean visible = false
integer x = 896
integer y = 224
integer width = 165
integer height = 48
end type

type st_9 from w_print_claim_basewindow`st_9 within w_print_support_documents
boolean visible = false
integer x = 1335
integer y = 128
integer width = 73
integer height = 48
boolean enabled = false
string text = "Print freight invoice"
end type

type st_7 from w_print_claim_basewindow`st_7 within w_print_support_documents
integer x = 37
integer y = 476
integer width = 1042
end type

type dw_brokers from w_print_claim_basewindow`dw_brokers within w_print_support_documents
integer x = 37
integer y = 540
integer width = 2258
integer height = 368
integer taborder = 20
end type

type cbx_charterer from w_print_claim_basewindow`cbx_charterer within w_print_support_documents
boolean visible = false
integer x = 869
integer y = 288
boolean enabled = false
end type

type cbx_broker from w_print_claim_basewindow`cbx_broker within w_print_support_documents
boolean visible = false
integer x = 599
integer y = 288
boolean enabled = false
end type

type cb_print from w_print_claim_basewindow`cb_print within w_print_support_documents
integer x = 1609
integer y = 1232
integer taborder = 80
end type

type cb_close from w_print_claim_basewindow`cb_close within w_print_support_documents
integer x = 1957
integer y = 1232
integer taborder = 90
end type

type dw_chart from w_print_claim_basewindow`dw_chart within w_print_support_documents
integer x = 37
integer y = 96
integer width = 2258
integer height = 368
boolean ib_setdefaultbackgroundcolor = true
end type

type dw_duedate from w_print_claim_basewindow`dw_duedate within w_print_support_documents
integer x = 859
integer y = 924
integer taborder = 40
end type

type st_charterer from w_print_claim_basewindow`st_charterer within w_print_support_documents
integer y = 32
end type

type cbx_sendax from w_print_claim_basewindow`cbx_sendax within w_print_support_documents
integer x = 37
integer y = 928
integer taborder = 30
end type

type dw_paymentcurr from w_print_claim_basewindow`dw_paymentcurr within w_print_support_documents
integer x = 1545
integer y = 928
end type

type p_infoax from w_print_claim_basewindow`p_infoax within w_print_support_documents
integer x = 640
integer y = 924
end type

type dw_info from w_print_claim_basewindow`dw_info within w_print_support_documents
end type

