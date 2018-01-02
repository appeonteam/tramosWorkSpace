$PBExportHeader$w_print_support_documents_dem.srw
$PBExportComments$Print Laytime Statement
forward
global type w_print_support_documents_dem from w_print_claim_basewindow
end type
type cbx_print_front_page from checkbox within w_print_support_documents_dem
end type
type cb_printer from commandbutton within w_print_support_documents_dem
end type
type cbx_print_statement from checkbox within w_print_support_documents_dem
end type
type cbx_bol from checkbox within w_print_support_documents_dem
end type
type sle_boldate from singlelineedit within w_print_support_documents_dem
end type
type st_8 from statictext within w_print_support_documents_dem
end type
type sle_product from singlelineedit within w_print_support_documents_dem
end type
type st_10 from statictext within w_print_support_documents_dem
end type
type cbx_coa from checkbox within w_print_support_documents_dem
end type
type sle_coa from singlelineedit within w_print_support_documents_dem
end type
type st_11 from statictext within w_print_support_documents_dem
end type
type cbx_lac from checkbox within w_print_support_documents_dem
end type
type cbx_indc from checkbox within w_print_support_documents_dem
end type
type rb_printer from radiobutton within w_print_support_documents_dem
end type
type rb_pdf from radiobutton within w_print_support_documents_dem
end type
type gb_3 from groupbox within w_print_support_documents_dem
end type
type gb_1 from groupbox within w_print_support_documents_dem
end type
type dw_print_group_deductions from mt_u_datawindow within w_print_support_documents_dem
end type
type dw_print_demurrage_statement from mt_u_datawindow within w_print_support_documents_dem
end type
type dw_print_laytime_statement from mt_u_datawindow within w_print_support_documents_dem
end type
type gb_2 from groupbox within w_print_support_documents_dem
end type
end forward

global type w_print_support_documents_dem from w_print_claim_basewindow
integer width = 2373
integer height = 2152
string title = "Print Laytime Statement / Statement of Demurrage"
long backcolor = 67108864
cbx_print_front_page cbx_print_front_page
cb_printer cb_printer
cbx_print_statement cbx_print_statement
cbx_bol cbx_bol
sle_boldate sle_boldate
st_8 st_8
sle_product sle_product
st_10 st_10
cbx_coa cbx_coa
sle_coa sle_coa
st_11 st_11
cbx_lac cbx_lac
cbx_indc cbx_indc
rb_printer rb_printer
rb_pdf rb_pdf
gb_3 gb_3
gb_1 gb_1
dw_print_group_deductions dw_print_group_deductions
dw_print_demurrage_statement dw_print_demurrage_statement
dw_print_laytime_statement dw_print_laytime_statement
gb_2 gb_2
end type
global w_print_support_documents_dem w_print_support_documents_dem

type variables
s_calc_claim istr_claim

boolean 	ib_only_layt, ib_bulk_credit_text = FALSE
boolean 	ib_indc_changed=false
integer	ii_fixrate
string	is_ex_rate
decimal 	id_ex_rate

string	is_calccurrcode
double 	id_amount_local, id_amountusd
end variables

forward prototypes
public subroutine wf_port_amounts ()
public function string wf_space (decimal amount)
public function string wf_getchart ()
public subroutine wf_front_page ()
public subroutine wf_ld_document ()
public subroutine wf_fill_demurrage_statement ()
public function string wf_convert_to_dhm (decimal value)
public subroutine documentation ()
public subroutine wf_print (integer ai_broker_charterer_office)
public function long wf_print_dem ()
public subroutine wf_disble_print (boolean ab_disbleprint)
end prototypes

public subroutine wf_port_amounts ();Integer li_counter, li_pcn,li_des_upper,li_dem_upper,li_count1,li_count2,li_arraycounter
String  ls_port, ls_purp,ls_used,ls_temp,ls_allowed,ls_dem_des_hours_dhm,ls_used_dhm 
Decimal {6} ld_l_all, ld_d_all, ld_l_d_r, ld_d_d_r, ld_daily, ld_allow, ld_des_sum, ld_dem_sum
Decimal {4} ld_bol_quantity, ld_dem_rate, ld_des_rate
Decimal {2} ld_used, ld_dem_des_hours
s_calc_claim lstr_amounts
uo_calc_dem_des_claims uo_calc_claim
Long ll_cpid,ll_calcaioid, ll_calcaioarray[],ll_caioid_upper
String ls_eq_days, ls_dem_des
Boolean  lb_new_caio
	
uo_calc_claim = CREATE uo_calc_dem_des_claims

istr_claim.dem_amount[1] = 0
istr_claim.des_amount[1] = 0

COMMIT;

SELECT DISTINCT CAL_CERP_ID
INTO :ll_cpid
FROM DEM_DES_CLAIMS
WHERE    ( VESSEL_NR = :istr_parm.vessel_nr  ) AND  
         	( VOYAGE_NR =  :istr_parm.voyage_nr ) AND  
         	( CHART_NR = :istr_parm.chart_nr ) AND  
         	( CLAIM_NR = :istr_parm.claim_nr  ) ;

COMMIT;

FOR li_counter = 1 TO istr_parm.dem_des_sets
	li_pcn = dw_print_laytime_statement.GetItemNumber(li_counter,"laytime_statements_pcn")
	ls_port = dw_print_laytime_statement.GetItemString(li_counter,"laytime_statements_port_code")
	ls_purp = dw_print_laytime_statement.GetItemString(li_counter,"poc_purpose_code")

	SELECT DISTINCT CAL_CAIO_ID
	INTO :ll_calcaioid
	FROM CD
	WHERE  (VESSEL_NR = :istr_parm.vessel_nr  ) AND  
         	( VOYAGE_NR =  :istr_parm.voyage_nr ) AND  
         	( CHART_NR = :istr_parm.chart_nr ) AND  
         	(PORT_CODE = :ls_port ) AND  
		(PCN = :li_pcn) AND
		(CAL_CERP_ID =  :ll_cpid) ;

	COMMIT;

	ll_caioid_upper = UpperBound(ll_calcaioarray)

	IF ll_caioid_upper = 0 THEN
		 lb_new_caio = TRUE
		 ll_calcaioarray[1] = ll_calcaioid
	ELSE
		lb_new_caio = TRUE
		FOR li_arraycounter = 1 TO ll_caioid_upper
			IF ll_calcaioarray[li_arraycounter] = ll_calcaioid THEN
				lb_new_caio = FALSE
			END IF
		NEXT
		IF  lb_new_caio THEN
			 ll_calcaioarray[ll_caioid_upper + 1] = ll_calcaioid
		END IF
	END IF	

	SELECT LOAD_LAYTIME_ALLOWED, DISCH_LAYTIME_ALLOWED, 
		      LOAD_DAILY_RATE, DISCH_DAILY_RATE, BOL_LOAD_QUANTITY  
    	 INTO :ld_l_all, :ld_d_all, :ld_l_d_r,  :ld_d_d_r, :ld_bol_quantity
         FROM DEM_DES_CLAIMS
         WHERE CAL_CAIO_ID = :ll_calcaioid;

	COMMIT;
	
	SELECT DES_RATE_DAY, DEM_RATE_DAY
    	 INTO :ld_des_rate, :ld_dem_rate
         FROM DEM_DES_RATES
         WHERE ( VESSEL_NR = :istr_parm.vessel_nr  ) AND  
  	       ( VOYAGE_NR =  :istr_parm.voyage_nr ) AND  
        	 ( CHART_NR = :istr_parm.chart_nr ) AND  
         	( CLAIM_NR = :istr_parm.claim_nr  ) AND  
         	(PORT_CODE = :ls_port ) AND  
         	(SUBSTRING(DEM_DES_PURPOSE,1,1) = :ls_purp) AND  
         	(CONVERT(INT,(SUBSTRING(DEM_DES_PURPOSE,2,1))) = :li_pcn) ;

	 IF ls_purp = "L" THEN 
		ld_allow = ld_l_all 
       	 ELSE
		ld_allow = ld_d_all
	 END IF
	 IF ls_purp = "L" THEN 
		ld_daily = ld_l_d_r 
       	 ELSE
		ld_daily = ld_d_d_r
	 END IF
	dw_print_laytime_statement.SetItem(li_counter,"dem_des_claims_bol_load_quantity",ld_bol_quantity)
	dw_print_laytime_statement.SetItem(li_counter,"compute_0031",ld_daily)

	ls_allowed = wf_convert_to_dhm(ld_allow)

	dw_print_laytime_statement.SetItem(li_counter,"allowed",ls_allowed)
	IF ii_vessel_pc_nr = 3 OR ii_vessel_pc_nr = 5 THEN
		lstr_amounts = uo_calc_claim.uf_bulk_port_claim_amount(istr_parm.vessel_nr, istr_parm.voyage_nr, &
										     istr_parm.chart_nr, istr_parm.claim_nr,ls_port,ls_purp,ll_calcaioid)
	ELSE
		lstr_amounts = uo_calc_claim.uf_tank_port_claim_amount(istr_parm.vessel_nr, istr_parm.voyage_nr, &
										     istr_parm.chart_nr, istr_parm.claim_nr,ls_port,ls_purp,ll_calcaioid)
	END IF
	li_des_upper = Upperbound(lstr_amounts.des_amount)
	ld_des_sum = 0
	IF li_des_upper > 0 THEN
		FOR li_count1 = 1 TO li_des_upper
			ld_des_sum += lstr_amounts.des_amount[li_count1]
			IF lb_new_caio THEN
				istr_claim.des_amount[1] += lstr_amounts.des_amount[li_count1]
			END IF
		NEXT
		IF ld_des_sum > 0 THEN	
			dw_print_laytime_statement.SetItem(li_counter,"compute_0035",ld_des_sum)				
		END IF	
	END IF

	li_dem_upper = Upperbound(lstr_amounts.dem_amount)
	ld_dem_sum = 0
	IF li_dem_upper > 0 THEN
		FOR li_count2 = 1 TO li_dem_upper
			ld_dem_sum += lstr_amounts.dem_amount[li_count2]
			IF lb_new_caio THEN
				istr_claim.dem_amount[1] += lstr_amounts.dem_amount[li_count2]
			END IF
		NEXT 
		IF ld_dem_sum > 0 THEN 
			dw_print_laytime_statement.SetItem(li_counter,"compute_0035",ld_dem_sum)		
		
		END IF
	END IF	

	IF lstr_amounts.dem_minutes <> 0 THEN 
	     dw_print_laytime_statement.SetItem(li_counter,"compute_0033",string(lstr_amounts.dem_hours[1],"#,##0.000000")+ &
		        	" days at " + is_currcode + " " + string(lstr_amounts.dem_rates[1],"#,##0.00")+" pdpr = ")
	     dw_print_laytime_statement.SetItem(li_counter,"compute_0036", "Demurrage")	
	     ld_used = (lstr_amounts.dem_hours[1] * 24) + ld_allow
	     ls_used = String(Round((lstr_amounts.dem_hours[1] * 24) + ld_allow,2))	
	      ls_dem_des = "DEM"
	ELSEIF  lstr_amounts.des_minutes <> 0 THEN 	    
	       dw_print_laytime_statement.SetItem(li_counter,"compute_0033",string(lstr_amounts.des_hours[1],"#,##0.000000")+ &
		        	" days at " + is_currcode + " " + string(lstr_amounts.des_rates[1],"#,##0.00")+" pdpr  = ")	
	       dw_print_laytime_statement.SetItem(li_counter,"compute_0036", "Despatch")	
		ld_used = ld_allow - (lstr_amounts.des_hours[1] * 24) 
	        ls_used = String(Round(ld_allow - (lstr_amounts.des_hours[1] * 24) ,2))
		 ls_dem_des = "DES"
	END IF
	dw_print_laytime_statement.SetItem(li_counter,"compute_0034", is_currcode)	

	ls_used_dhm = wf_convert_to_dhm(Abs(ld_used))
	
	IF ls_dem_des = "DEM" THEN
		ld_dem_des_hours = Round(Abs(ld_used) - ld_allow,2)
		ls_eq_days = string(lstr_amounts.dem_hours[1],"#,##0.000000")
//		ls_eq_days = String((Abs(dec(ls_used)) - ld_allow)/24,"#,##0.0000")
	ELSEIF  ls_dem_des = "DES" THEN
		ld_dem_des_hours = Round(ld_allow - Abs(ld_used),2)
		ls_eq_days = string(lstr_amounts.des_hours[1],"#,##0.000000")
//		ls_eq_days = String(Round(ld_allow - Abs(ld_used),4)/24,"#,##0.0000")
//		ls_eq_days = String(ld_allow - (Abs(dec(ls_used)))/24,"#,##0.0000")
	END IF

	ls_dem_des_hours_dhm = wf_convert_to_dhm(ld_dem_des_hours)
	

	ls_temp = "Used laytime " + ls_used_dhm + " less allowed laytime " + ls_allowed + " equals " + &
		ls_dem_des_hours_dhm  + " equals " + ls_eq_days + " days."
	
	dw_print_laytime_statement.SetItem(li_counter,"compute_0037", ls_temp)	

NEXT

DESTROY uo_calc_claim
end subroutine

public function string wf_space (decimal amount);string ls_space

if amount < -100000 then
	ls_space = " "
elseif amount < -10000 then
	ls_space = "  "
elseif amount < -1000 then
	ls_space = "   "
elseif amount < -100 then
	ls_space = "    "
elseif  amount < -10 then
	ls_space = "     "
elseif amount < 0 then
	ls_space = "      "
end if

if  amount < 1 then
	ls_space = "         "
elseif amount < 10 or amount < -1 then
	ls_space = "      "
	elseif amount < 100 or amount < -10 then
	ls_space = "     "
	elseif amount < 1000 or amount < -100 then
	ls_space = "    "
	elseif amount < 10000 or amount < -1000 then
	ls_space = "   "
	elseif amount < 100000 or amount < -10000 then
	ls_space = "  "
elseif amount < 1000000 or amount < -100000 then
	ls_space = " "
end if

return ls_space

end function

public function string wf_getchart ();// This not the optimal way to do it, but due to some existing code
// this has been done. 
// Used to set alternative chart name on to statements

String name1, aname1


//*************************************************************
// Get Charterer information
//*************************************************************

SELECT CHART_N_1,   
		 CHART_INV_N_1
	INTO :name1, :aname1
    	FROM CHART   
        WHERE CHART_NR = :istr_parm.chart_nr
	USING SQLCA ;
COMMIT USING SQLCA;  

if (cbx_alt_adress.checked) then
	return aname1
else
	return name1
end if

end function

public subroutine wf_front_page ();/*
Created by: FR 210602
Modified by: LGX001 on 22/12/2011. for M5-2 
*/
SetPointer(Hourglass!)
String  bname1
  
/*************************************************************
Get Broker name information
*************************************************************/
SELECT BROKER_NAME   
    	INTO :bname1
    	FROM BROKERS   
	WHERE BROKER_NR = :ii_broker_nr   
	USING SQLCA ;
COMMIT USING SQLCA;   

// Open word using OLE
OLEObject ole_object, ole_Bookmark
ole_object = CREATE OLEObject

// Connect to word
if (ole_object.connecttonewobject("word.application")) = 0 then
	ole_Bookmark = Create oleObject
	ole_Bookmark.ConnectTonewObject("word.application.bookmark")	
	IF FileExists(uo_global.gs_template_path+"\demurrage_frontpage.dot") THEN
		ole_object.documents.add(uo_global.gs_template_path+"\demurrage_frontpage.dot")
	ELSE
		Messagebox("Wrong File Path in System Options","The file path for MS WORD Templates in 'System Options' the field 'File Path to MS Word templates' is not correct", StopSign!)
		Destroy ole_object
		Return	
	END IF		
else
	Messagebox("OLE Error", "Unable to start an OLE server process!", Exclamation!)
	Destroy ole_object
	return
end if

wf_insert_field("Broker", bname1, ole_object, ole_bookmark)
wf_insert_field("Charterer", is_chartfullname,  ole_object, ole_bookmark) 
wf_insert_field("Vesselname", is_vesselname, ole_object, ole_bookmark)
wf_insert_field("Vesselno", string(istr_parm.vessel_nr), ole_object, ole_bookmark)
wf_insert_field("Voyageno", istr_parm.voyage_nr, ole_object, ole_bookmark)
wf_insert_field("CPdate", "CP Date: " + string(idt_cpdate,"dd.mm.yy"), ole_object, ole_bookmark)
wf_insert_field("Today", string(today(),"dd.mm.yy"), ole_object, ole_bookmark)
wf_insert_field("Vesselname", "", ole_object, ole_bookmark)

ole_object.visible = true

Destroy ole_Bookmark

Return
end subroutine

public subroutine wf_ld_document ();SetPointer(Hourglass!)

String 		name1, bname1, ls_infield_l, ls_infield_d
integer 		li_infield_l, li_infield_d, li_timebar
datastore 	lds_load_disch
datetime		ldt_laycanStart, ldt_laycanEnd, ldt_cp
decimal {6}	ld_laytimeAllowed
decimal {2}	ld_demRate

//*************************************************************
// Get Claim information
//*************************************************************
SELECT LAYCAN_START, LAYCAN_END, CP_DATE, TIMEBAR_DAYS
	INTO :ldt_laycanStart, :ldt_laycanEnd, :ldt_cp, :li_timebar
	FROM CLAIMS
	WHERE VESSEL_NR = :istr_parm.vessel_nr
	AND VOYAGE_NR = :istr_parm.voyage_nr
	AND CHART_NR = :istr_parm.chart_nr
	AND CLAIM_NR = :istr_parm.claim_nr 
	USING SQLCA ;
COMMIT USING SQLCA;  

SELECT SUM(ISNULL(LOAD_LAYTIME_ALLOWED,0) + ISNULL(DISCH_LAYTIME_ALLOWED,0))
	INTO :ld_laytimeAllowed
	FROM DEM_DES_CLAIMS
	WHERE VESSEL_NR = :istr_parm.vessel_nr
	AND VOYAGE_NR = :istr_parm.voyage_nr
	AND CHART_NR = :istr_parm.chart_nr
	AND CLAIM_NR = :istr_parm.claim_nr 
	USING SQLCA ;
COMMIT USING SQLCA;  

SELECT TOP 1 DEM_RATE_DAY
	INTO :ld_demRate
	FROM DEM_DES_RATES
	WHERE VESSEL_NR = :istr_parm.vessel_nr
	AND VOYAGE_NR = :istr_parm.voyage_nr
	AND CHART_NR = :istr_parm.chart_nr
	AND CLAIM_NR = :istr_parm.claim_nr 
	ORDER BY RATE_NUMBER
	USING SQLCA ;
COMMIT USING SQLCA;  

//*************************************************************
//Get Broker Information
//*************************************************************
SELECT BROKER_NAME
    	INTO :bname1
    	FROM BROKERS   
	WHERE BROKER_NR = :ii_broker_nr   
	USING SQLCA ;
COMMIT USING SQLCA;  

/******************************************************************************/
/*                    CREATION OF LOAD-/DISCHARGE DOCUMENT IN WORD                     */
/******************************************************************************/
// Open word using OLE
string ls_load_ports, ls_disch_ports
long ll_row, ll_rows

OLEObject ole_object, ole_Bookmark

ole_object = CREATE OLEObject

// Connect to word
if (ole_object.connecttonewobject("word.application")) = 0 then
	ole_Bookmark = Create OleObject
	ole_Bookmark.ConnectTonewObject("word.application.bookmark")	
	IF FileExists(uo_global.gs_template_path+"\load_discharge_document.dot") THEN
		ole_object.documents.add(uo_global.gs_template_path+"\load_discharge_document.dot")
	ELSE
		Messagebox("Wrong File Path in System Options","The file path for MS WORD Templates in 'System Options' the field 'File Path to MS Word templates' is not correct", StopSign!)
		Destroy ole_object
		return
	END IF
else
	Messagebox("OLE Error", "Unable to start an OLE server process!", Exclamation!)
	Destroy ole_object
	return
end if

// Retrieve to find the load and discharge ports
lds_load_disch = CREATE datastore
lds_load_disch.dataobject = "d_load_disch"
lds_load_disch.settransobject(SQLCA)
lds_load_disch.retrieve(istr_parm.vessel_nr,istr_parm.voyage_nr, istr_parm.chart_nr)

if (lds_load_disch.rowcount() < 1) then
	destroy lds_load_disch
	return
end if

li_infield_l = 1
li_infield_d = 1

FOR ll_row = 1 TO lds_load_disch.rowcount()
	if (lds_load_disch.getitemnumber(ll_row, "bol_l_d") = 1) then
		ls_infield_l = "LP" + string(li_infield_l)
		wf_insert_field(ls_infield_l, lds_load_disch.getitemstring(ll_row, "ports_port_n") , ole_object, ole_bookmark)
		li_infield_l++		
	else
		ls_infield_d = "DP" + string(li_infield_d)
		wf_insert_field(ls_infield_d, lds_load_disch.getitemstring(ll_row, "ports_port_n") , ole_object, ole_bookmark)
		li_infield_d++		
	end if
NEXT

Destroy lds_load_disch

wf_insert_field("VNAME", is_vesselname, ole_object, ole_bookmark)
wf_insert_field("VNO", string(istr_parm.vessel_nr), ole_object, ole_bookmark)
wf_insert_field("VOYNO", istr_parm.voyage_nr, ole_object, ole_bookmark)
wf_insert_field("LAYCAN", string(ldt_laycanStart ,"dd-mm-yy hh:mm") + " - "+ string(ldt_laycanEnd ,"dd-mm-yy hh:mm"), ole_object, ole_bookmark)
wf_insert_field("CPDATE", string(ldt_cp ,"dd-mm-yy"), ole_object, ole_bookmark)
wf_insert_field("CHART", is_chartfullname, ole_object, ole_bookmark)
wf_insert_field("BROKER", bname1, ole_object, ole_bookmark)
wf_insert_field("TIMEBAR", string(li_timebar ), ole_object, ole_bookmark)	
wf_insert_field("LAYALLOW", string(ld_laytimeAllowed , "#,###.000000"), ole_object, ole_bookmark)	
wf_insert_field("DEMRATE", string(ld_demRate , "#,###.00"), ole_object, ole_bookmark)	

ole_object.visible = true

Destroy ole_Bookmark
Destroy ole_object

Return
end subroutine

public subroutine wf_fill_demurrage_statement ();/********************************************************************
   wf_fill_demurrage_statement
   <DESC>	</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/07/16		CR4111		XSZ004		Print 'CHO' ports.
   </HISTORY>
********************************************************************/

string  ls_port_code, ls_port_name, ls_currency_code
integer li_pcn, li_claim_nr, li_cnt, li_count
long    ll_row, xx, ll_no_of_rates
long    laytime, laytime_deducted
long    ll_dempercentage = 0
decimal {6} laytime_allowed_load, laytime_allowed_discharge
decimal {2} ld_sum_dem = 0, ld_sum_des = 0, ld_addr_com, ld_addr_com_pct, ld_amount
string  ls_percentage
decimal {2} ld_dem_balance = 0

DataWindowChild dwc
mt_n_datastore lds_print_ports
u_claimbalance luo_claimbalance

uo_calc_dem_des_claims uo_calc_claim
uo_calc_claim = CREATE uo_calc_dem_des_claims

SetPointer(Hourglass!)

SELECT CLAIM_NR, CURR_CODE
	INTO :li_claim_nr, :ls_currency_code
	FROM CLAIMS
	WHERE VESSEL_NR = :istr_parm.vessel_nr
	AND VOYAGE_NR = :istr_parm.voyage_nr
	AND CHART_NR = :istr_parm.chart_nr
	AND (CLAIM_TYPE = "DEM" OR CLAIM_TYPE = "DES");

SELECT IsNull(LOAD_LAYTIME_ALLOWED,0), IsNull(DISCH_LAYTIME_ALLOWED,0)
	INTO :laytime_allowed_load, :laytime_allowed_discharge
	FROM DEM_DES_CLAIMS			
	WHERE VESSEL_NR = :istr_parm.vessel_nr
	AND VOYAGE_NR = :istr_parm.voyage_nr
	AND CHART_NR = :istr_parm.chart_nr
	AND CLAIM_NR = :li_claim_nr; 

SELECT CLAIMS.ADDRESS_COM  
 INTO :ld_addr_com_pct  
 FROM CLAIMS  
WHERE ( CLAIMS.CHART_NR = :istr_parm.chart_nr ) AND  
		( CLAIMS.VESSEL_NR = :istr_parm.vessel_nr ) AND  
		( CLAIMS.VOYAGE_NR = :istr_parm.voyage_nr ) AND  
		( CLAIMS.CLAIM_NR = :li_claim_nr );

dw_print_demurrage_statement.GetChild("report_header", dwc)
dwc.Modify("user_reference.Text='" + uo_global.is_userid+"/-'")

luo_claimbalance = create u_claimbalance
luo_claimbalance.of_claimbalance(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, istr_parm.claim_nr)
ll_dempercentage = luo_claimbalance.of_get_claimpercentage( )
ld_dem_balance	  = luo_claimbalance.of_getvalue_local( )
destroy u_claimbalance

lds_print_ports = create mt_n_datastore
lds_print_ports.dataobject = "d_sp_tb_laytimeports"
lds_print_ports.settransobject(sqlca)

sqlca.autocommit = true
lds_print_ports.retrieve(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr)
sqlca.autocommit = false

if (ii_vessel_pc_nr = 3 OR ii_vessel_pc_nr = 5) then

	dw_print_demurrage_statement.Modify("footer.text='Phone: +45 33 63 33 63. Telex: 19632. Telefax: +45 33 32 25 23'")
	dw_print_demurrage_statement.GetChild("report_bulk", dwc)
	
	lds_print_ports.setfilter("purpose_code = 'L' or purpose_code = 'CHO'")
	lds_print_ports.filter()
	
	li_count = lds_print_ports.rowcount()
	
	for li_cnt = 1 to li_count
		
		ll_row = dwc.InsertRow(0)
		
		ls_port_code = lds_print_ports.getitemstring(li_cnt, "port_code")
		li_pcn       = lds_print_ports.getitemnumber(li_cnt, "pcn")
		ls_port_name = lds_print_ports.getitemstring(li_cnt, "port_n")
		
		dwc.SetItem(ll_row,"port_name", ls_port_name)
		laytime = 0
		
		SELECT LAY_MINUTES
		  INTO :laytime
		  FROM LAYTIME_STATEMENTS
		 WHERE VESSEL_NR = :istr_parm.vessel_nr
		   AND VOYAGE_NR = :istr_parm.voyage_nr
		   AND CHART_NR = :istr_parm.chart_nr
		   AND PORT_CODE = :ls_port_code
		   AND PCN = :li_pcn;
			
		IF IsNull(laytime) THEN laytime = 0
		
		 laytime_deducted = 0
		 
		SELECT SUM(DEDUCTION_MINUTES)
			INTO :laytime_deducted
			FROM LAY_DEDUCTIONS
			WHERE VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND CHART_NR = :istr_parm.chart_nr
			AND PORT_CODE = :ls_port_code
			AND PCN = :li_pcn; 
  				
		IF IsNull(laytime_deducted) THEN laytime_deducted = 0
		
		dwc.SetItem(ll_row,"load_minutes",laytime - laytime_deducted)
		dwc.SetItem(ll_row,"load_allowed",Round(laytime_allowed_load * 60, 0))
		dwc.SetItem(ll_row,"disch_allowed",Round(laytime_allowed_discharge * 60, 0))
	next
	
	lds_print_ports.setfilter("purpose_code = 'D' or purpose_code = 'L/D'")
	lds_print_ports.filter()
	
	li_count = lds_print_ports.rowcount()
	
	for li_cnt = 1 to li_count 
		ll_row = dwc.InsertRow(0)
		
		ls_port_code = lds_print_ports.getitemstring(li_cnt, "port_code")
		li_pcn       = lds_print_ports.getitemnumber(li_cnt, "pcn")
		ls_port_name = lds_print_ports.getitemstring(li_cnt, "port_n")
		
		dwc.SetItem(ll_row,"port_name", ls_port_name)
		laytime = 0
		
		SELECT LAY_MINUTES
		INTO :laytime
		FROM LAYTIME_STATEMENTS
		WHERE VESSEL_NR = :istr_parm.vessel_nr
		AND VOYAGE_NR = :istr_parm.voyage_nr
		AND CHART_NR = :istr_parm.chart_nr
		AND PORT_CODE = :ls_port_code
		AND PCN = :li_pcn;
		
		IF IsNull(laytime) THEN laytime = 0
		
		laytime_deducted = 0
		
		SELECT SUM(DEDUCTION_MINUTES)
			INTO :laytime_deducted
			FROM LAY_DEDUCTIONS
			WHERE VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND CHART_NR = :istr_parm.chart_nr
			AND PORT_CODE = :ls_port_code
			AND PCN = :li_pcn; 
		
		IF IsNull(laytime_deducted) THEN laytime_deducted = 0
		
		dwc.SetItem(ll_row,"disch_minutes",laytime - laytime_deducted)
		dwc.SetItem(ll_row,"load_allowed",Round(laytime_allowed_load * 60, 0))
		dwc.SetItem(ll_row,"disch_allowed",Round(laytime_allowed_discharge * 60, 0))
	next
	
	/* Fill in Debit Note  */
	istr_claim = uo_calc_claim.uf_get_bulk_amount ( istr_parm.vessel_nr,  istr_parm.voyage_nr, istr_parm.chart_nr,li_claim_nr )
	
	/* Find out if there is demurrage */
	IF istr_claim.dem_minutes <> 0 THEN
		
		dw_print_demurrage_statement.GetChild("report_demurrage", dwc)
		
		ll_row = dwc.InsertRow(0)
		
		dwc.SetItem(ll_row,"line_1",string(truncate(istr_claim.dem_minutes / 1440 , 0)) + " days, " &
			+ string(truncate((istr_claim.dem_minutes - (truncate(istr_claim.dem_minutes / 1440 , 0) * 1440 )) / 60 , 0 )) + " hours and " &
			+ string(mod((istr_claim.dem_minutes - (truncate(istr_claim.dem_minutes / 1440 , 0) * 1440 )), 60))+ " minutes equal to")
	 	
		ll_no_of_rates = UpperBound(istr_claim.dem_amount)
		 
		FOR xx = 1 TO ll_no_of_rates
			
			ll_row = dwc.InsertRow(0)
			
			if ll_dempercentage > 0 then
				ls_percentage = string(ll_dempercentage)+"% of "
			else
				ls_percentage = ""
				ld_dem_balance = istr_claim.dem_amount[xx]
			end if	
			
			if ii_fixrate = 0 then
				dwc.SetItem(ll_row,"line_1", ls_percentage + string(istr_claim.dem_hours[xx],"#,##0.000000")+" days at " &
					+ ls_currency_code + " " &
					+ string(istr_claim.dem_rates[xx],"#,##0.00")+" pdpr = ")
			else
				dwc.SetItem(ll_row,"line_1", ls_percentage + string(istr_claim.dem_hours[xx],"#,##0.000000")+" days at " &
					+ is_calccurrcode + " " &
					+ string(istr_claim.dem_rates[xx]/id_ex_rate ,"#,##0.00")+" * " + is_ex_rate +"  pdpr = ")				
			end if
			
			dwc.SetItem(ll_row,"currency", ls_currency_code)
			dwc.SetItem(ll_row,"amount", ld_dem_balance)
			ld_sum_dem +=  ld_dem_balance					 
		NEXT
		
		istr_transaction_input.amount_local = dec(string(ld_sum_dem ,"#,##0.00"))
		istr_transaction_input.payment_amount =  istr_transaction_input.amount_local
		istr_transaction_input.comm_amount = 0
		
		
	END IF
	/* Find out if there is despatch */
	IF istr_claim.des_minutes <> 0 THEN
		
		dw_print_demurrage_statement.GetChild("report_despatch", dwc)
		
		ll_row = dwc.InsertRow(0)
		
		dwc.SetItem(ll_row,"line_1",string(truncate(istr_claim.des_minutes / 1440 , 0)) + " days, " &
			+ string(truncate((istr_claim.des_minutes - (truncate(istr_claim.des_minutes / 1440 , 0) * 1440)) / 60 , 0)) + " hours and " &
			+ string(mod((istr_claim.des_minutes - (truncate(istr_claim.des_minutes / 1440 , 0) * 1440)), 60))+ " minutes equal to")
	 	
		ll_no_of_rates = UpperBound(istr_claim.des_amount)
		
		FOR xx = 1 TO ll_no_of_rates
			
			ll_row = dwc.InsertRow(0)
			
			if ii_fixrate = 0 then
				dwc.SetItem(ll_row,"line_1",string(istr_claim.des_hours[xx],"#,##0.000000")+" days at " &
					+ ls_currency_code + " " &
					+ string(istr_claim.des_rates[xx],"#,##0.00")+" pdpr = ")
			else
				dwc.SetItem(ll_row,"line_1",string(istr_claim.des_hours[xx],"#,##0.000000")+" days at " &
					+ is_calccurrcode + " " &
					+ string(istr_claim.des_rates[xx]/id_ex_rate ,"#,##0.00")+" * " + is_ex_rate +" pdpr = ")
			end if
			
			dwc.SetItem(ll_row,"currency", ls_currency_code)
			dwc.SetItem(ll_row,"amount", istr_claim.des_amount[xx])
			
			ld_sum_des +=  istr_claim.des_amount[xx]
		NEXT
	END IF
	
	dw_print_demurrage_statement.GetChild("report_bulk", dwc)
	
	IF (ld_sum_dem - ld_sum_des) < 0 THEN 
		 dwc.Modify("debit_text.text='CREDIT NOTE'")
		 ib_bulk_credit_text = TRUE
	END IF
ELSE
	dw_print_demurrage_statement.Modify("footer.text='Phone: +45 33 63 33 63. Telex: 19632. Telefax: +45 33 63 48 78 / 33 15 23 23'")
	dw_print_demurrage_statement.GetChild("report_tank", dwc)
	
	li_count = lds_print_ports.rowcount()
	
	for li_cnt = 1 to li_count
		ll_row = dwc.InsertRow(0)
		
		ls_port_code = lds_print_ports.getitemstring(li_cnt, "port_code")
		li_pcn       = lds_print_ports.getitemnumber(li_cnt, "pcn")
		ls_port_name = lds_print_ports.getitemstring(li_cnt, "port_n")
		
		dwc.SetItem(ll_row,"port_name", ls_port_name)
		laytime = 0
		
		SELECT LAY_MINUTES
			INTO :laytime
			FROM LAYTIME_STATEMENTS
			WHERE VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND CHART_NR = :istr_parm.chart_nr
			AND PORT_CODE = :ls_port_code
			AND PCN = :li_pcn; 

		IF IsNull(laytime) THEN laytime = 0
		
		laytime_deducted = 0
		
		SELECT SUM(DEDUCTION_MINUTES)
			INTO :laytime_deducted
			FROM LAY_DEDUCTIONS
			WHERE VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND CHART_NR = :istr_parm.chart_nr
			AND PORT_CODE = :ls_port_code
			AND PCN = :li_pcn;  

		IF IsNull(laytime_deducted) THEN laytime_deducted = 0
		
		dwc.SetItem(ll_row,"minutes",laytime - laytime_deducted)
		dwc.SetItem(ll_row,"allowed",Round((laytime_allowed_discharge + laytime_allowed_load) * 60, 0))	     
	NEXT
	
	/* Fill in Debit Note  */
	dw_print_demurrage_statement.GetChild("report_demurrage", dwc)
	
	ll_row = dwc.InsertRow(0)
	
	istr_claim = uo_calc_claim.uf_get_tank_amount ( istr_parm.vessel_nr,  istr_parm.voyage_nr, istr_parm.chart_nr,li_claim_nr )
	
	dwc.SetItem(ll_row,"line_1",string(truncate(istr_claim.dem_minutes / 1440 , 0)) + " days, " &
		+ string(truncate((istr_claim.dem_minutes - (truncate(istr_claim.dem_minutes / 1440 , 0) * 1440)) / 60 , 0)) + " hours and " &
		+ string(mod((istr_claim.dem_minutes - (truncate(istr_claim.dem_minutes / 1440 , 0) * 1440)), 60))+ " minutes equal to")
 	
	ll_no_of_rates = UpperBound(istr_claim.dem_amount)
	 
	FOR xx = 1 TO ll_no_of_rates
		
		ll_row = dwc.InsertRow(0)
		
		if ll_dempercentage > 0 then
			ls_percentage = string(ll_dempercentage)+"% of "
		else
			ls_percentage = ""
			ld_dem_balance = istr_claim.dem_amount[xx]
		end if	
		
		if ii_fixrate = 0 then
			dwc.SetItem(ll_row,"line_1", ls_percentage + string(istr_claim.dem_hours[xx],"#,##0.000000")+" days at " &
				+ ls_currency_code + " " &
				+ string(istr_claim.dem_rates[xx],"#,##0.00")+" pdpr = ")
		else
			dwc.SetItem(ll_row,"line_1", ls_percentage + string(istr_claim.dem_hours[xx],"#,##0.000000")+" days at " &
				+ is_calccurrcode + " " &
				+ string(istr_claim.dem_rates[xx]/id_ex_rate ,"#,##0.00")+" * " +is_ex_rate + " pdpr = ")
		end if
		
		dwc.SetItem(ll_row,"currency", ls_currency_code)
		dwc.SetItem(ll_row,"amount",  ld_dem_balance)
		ld_amount += ld_dem_balance      
		id_amountusd = ld_amount
		id_amount_local += ld_dem_balance    
	NEXT
	
	istr_transaction_input.amount_local = dec(string(id_amount_local,"#,##0.00"))  
	
	if (cbx_lac.checked) then
		
		ll_row = dwc.insertrow(0)
		
		if (ld_addr_com_pct >= 0) and not isnull(ld_addr_com_pct) then
			dwc.setitem(ll_row, "line_1", "Less addr. commission "+ string(ld_addr_com_pct,"#,##0.00") + " pct.")
			dwc.setitem(ll_row, "currency", ls_currency_code)
			ld_addr_com = ld_amount * (ld_addr_com_pct/100)
			dwc.setitem(ll_row, "amount", -ld_addr_com)
		end if
	end if
	
	istr_transaction_input.comm_amount = dec(string(ld_addr_com,"#,##0.00"))
	istr_transaction_input.payment_amount = dec(string(istr_transaction_input.amount_local - istr_transaction_input.comm_amount,"#,##0.00"))
	
END IF

DESTROY uo_calc_claim
destroy lds_print_ports

Return
end subroutine

public function string wf_convert_to_dhm (decimal value);String ls_allowed

ls_allowed = String(Int(value/24)) + " D " + String(Int(Mod(Abs(value),24))) + " H " + String(Round((Mod(Abs(value),24) - &
	                     Int(Mod(Abs(value),24))) * 60,0)) + " M"

Return ls_allowed

end function

public subroutine documentation ();/********************************************************************
   ObjectName: (w_print_laytime_statement have replaced with w_print_support_documents_dem)
	            w_print_support_documents_dem
   <OBJECT> (Print laytime statement/demurrage claims.)	Print support documents of AX invoice </OBJECT>
   <USAGE>	Connected to w_claims. 
		- demurrage_letter_charterer_handy.dot, demurrage_letter_broker_handy.dot
		- demurrage_letter_broker_star.dot, demurrage_letter_charterer_star.dot
		- demurrage_letter_charterer_swift.dot, demurrage_letter_broker_swift.dot
		- demurrage_letter_charterer_brostrom.dot, demurrage_letter_broker_brostrom.dot
		- demurrage_letter_charterer_shipet.dot, demurrage_letter_broker_shipet.dot
	</USAGE>
   <ALSO>		</ALSO>
<HISTORY> 
	Date    	CR-Ref	Author	Comments
	??/??/??	      	      	First Version
	24/02/11	CR2293	JMC   	Parent window changed. Print in multi currencies. Add brostrom logo.
	02/03/11	CR2293	JMC   	Added option "Charterer on behalf of Shipet"
	14/04/11	CR2316	JMC   	Make bank details editable
	27/04/11	CR2316	JMC   	Bank accounts
	27/04/11	CR2375	JMC   	Vat_nr from profit center
	19/05/11	CR2430	JMC   	Shipet template uses selected bank account detail
	29/08/11	CR2485	JMC   	Vat_nr from selection profit center
	19/10/11	CR2485	AGL   	Amendment to address header/footer for BTSG exception
	20/12/11	M5-2  	LGX001	Print the supporting documents of AX invoice
	09/01/12	M5-2  	JMC   	Added business logic for "Send data to AX"
	02/02/12	M5-2  	LGX001	setting the invoice NR must be after calling parent.wf_send_to_ax(s_transaction_input)
	29/09/12	CR2592	LGX001	Do not allow to send invoice to AX when DEM claim has negative balance.
	30/10/12	CR2949	LGX001	When DEM claim has negative balance AND xy% is entered AND when "show in VAS" has been checked,
	        	      	      	it must be possible for Finance users of business unit Demurrage to print and “Send invoice to AX”,
	11/06/13	CR2877	ZSW001	Add reutrn value for function wf_print_dem()
	11/10/13	CR2877	ZSW001	Enabled the close button after printing
	13/06/14	CR3700	LHG008	If resend invoice data to AX, force user to select an anadjustment reason
	09/12/14	CR3216	XSZ004	Enable to select deductible brokers when sending invoice data.
	21/07/16	CR4111	XSZ004	Print 'CHO' ports.	
	19/09/16	CR2212	LHG008	Sanctions restrictions
	25/10/16		CR3385		HXH010		Update forwarding date when (Re)send invoice data to AX
</HISTORY>    
********************************************************************/

end subroutine

public subroutine wf_print (integer ai_broker_charterer_office);/*
This function creates two word files (demurrage letter to charterer and demurrage letter
to broker. The word files are created using OLE objects. 

Wordfiles needed:		demurrage_letter_broker_star.doc
							demurrage_letter_charterer_star.doc
							demurrage_letter_broker_handy.doc
							demurrage_letter_charterer_handy.doc

Argument:	ai_broker_charterer_office
				1 = broker letter
				2 = charterer letter
				3 = office letter
				
Created by: FR 21/06-02
Modified by: FR 11/10-02
Modified by: REM 25/11-03
Modified by: LGX001 15/12-11  for M5-2
*/

SetPointer(Hourglass!)

String name1, adr1, adr2, adr3, country, chart
String aname1, aadr1, aadr2, aadr3, acountry, avat
String bname1, badr1, badr2, badr3, bcountry 

decimal{2} ld_addr_com_pct, ld_amount

string ls_subject, ls_date, ls_amount, ls_dhm
OLEObject ole_object, ole_Bookmark

////*************************************************************
//// Get Charterer information
////*************************************************************

SELECT CHART_N_1,	CHART_A_1, CHART_A_2, CHART_A_3, CHART_C,  
		 CHART_INV_N_1, CHART_INV_A_1, CHART_INV_A_2, CHART_INV_A_3, CHART_INV_C  				 					 
	INTO :name1, :adr1, :adr2, :adr3, :country,  
		  :aname1, :aadr1, :aadr2, :aadr3, :acountry  
   FROM CHART   
   WHERE CHART_NR = :istr_parm.chart_nr
	USING SQLCA ;
if SQLCA.SQLCode = -1 then
	MessageBox("Database Read Error", "Error reading from table CHART.~n~rSQLErrText="+SQLCA.SQLErrText)
end if
COMMIT USING SQLCA;  

if ai_broker_charterer_office = 1 then
	SELECT BROKER_NAME, BROKER_A_1, BROKER_A_2, BROKER_A_3, BROKER_C  
  		INTO :bname1, :badr1, :badr2, :badr3, :bcountry  
  		FROM BROKERS   
		WHERE BROKER_NR = :ii_broker_nr   
		USING SQLCA ;
	if SQLCA.SQLCode = -1 then
		MessageBox("Database Read Error", "Error reading from table BROKERS.~n~rSQLErrText="+SQLCA.SQLErrText)
	end if
	COMMIT USING SQLCA;  
end if
	
if ai_broker_charterer_office = 3 then
  	SELECT OFFICE_NAME, OFFICE_A_1, OFFICE_A_2, OFFICE_A_3, OFFICE_C  
		INTO :bname1, :badr1, :badr2, :badr3, :bcountry  
		FROM OFFICES   
		WHERE OFFICE_NR = :ii_office_nr   
		USING SQLCA ;
	if SQLCA.SQLCode = -1 then
		MessageBox("Database Read Error", "Error reading from table OFFICES.~n~rSQLErrText="+SQLCA.SQLErrText)
	end if
	COMMIT USING SQLCA;  
END IF

// Inserted by FR 160802 - Need the get the addr. commission - START

SELECT CLAIMS.ADDRESS_COM  
	INTO :ld_addr_com_pct  
	FROM CLAIMS  
	WHERE ( CLAIMS.CHART_NR = :istr_parm.chart_nr ) AND  
		( CLAIMS.VESSEL_NR = :istr_parm.vessel_nr ) AND  
		( CLAIMS.VOYAGE_NR = :istr_parm.voyage_nr ) AND  
		( CLAIMS.CLAIM_NR = :istr_parm.claim_nr  )
	USING SQLCA;
if SQLCA.SQLCode = -1 then
	MessageBox("Database Read Error", "Error reading from table CLAIMS.~n~rSQLErrText="+SQLCA.SQLErrText)
end if
COMMIT USING SQLCA;

// Open word using OLE
if wf_get_template(ole_object, ole_bookmark) <= 0 then return

// Inserted by FR 160802 - Need the get the addr. commission - END
if cbx_alt_adress.checked  then
	// LS_SUBJECT
	ls_subject = (is_vesselname +" - Charter Party dated "+string(idt_cpdate,"d mmmm yyyy"))
else
	// LS_SUBJECT
	ls_subject = (is_vesselname +" - Charter Party dated "+string(idt_cpdate,"d mmmm yyyy") +" - " + is_chartfullname)
end if

// Strings to be put in the letter

// LS_DATE
ls_date = string(today(), "d mmmm yyyy")

// Kode til håndtering af adresse kommission og euro

if(cbx_lac.checked) then 
	if(ld_addr_com_pct >= 0) and not isnull(ld_addr_com_pct) then
		ld_amount = dec(string(istr_claim.claim_amount,"#,###.00")) - dec(string((dec(string(istr_claim.claim_amount, "#,###.00")) * (ld_addr_com_pct/ 100)),"#,###.00"))
	end if
else
	ld_amount = istr_claim.claim_amount
end if

ls_amount = ( is_currcode +" "+string(ld_amount,"#,###.00"))			

// LS_DHM
ls_dhm = (string(truncate(istr_claim.dem_minutes / 1440 , 0),"0") + " days, " &
			+ string(truncate((istr_claim.dem_minutes - (truncate(istr_claim.dem_minutes / 1440 , 0) * 1440)) / 60 , 0),"0") + " hours and " &
			+ string(mod((istr_claim.dem_minutes - (truncate(istr_claim.dem_minutes / 1440 , 0) * 1440)), 60),"00")+ " minutes")

if (ai_broker_charterer_office = 1)  or (ai_broker_charterer_office = 3)then
	wf_insert_field("Name1", bname1, ole_object, ole_bookmark)
	wf_insert_field("Name2", badr1, ole_object, ole_bookmark)
	wf_insert_field("Name3", badr2, ole_object, ole_bookmark)
	wf_insert_field("Name4", badr3, ole_object, ole_bookmark)
	wf_insert_field("Name5", bcountry, ole_object, ole_bookmark)
else
	if (cbx_alt_adress.checked) then
		wf_insert_field("Name1", aname1, ole_object, ole_bookmark)
		wf_insert_field("Name2", aadr1, ole_object, ole_bookmark)
		wf_insert_field("Name3", aadr2, ole_object, ole_bookmark)
		wf_insert_field("Name4", aadr3, ole_object, ole_bookmark)
		wf_insert_field("Name5", acountry, ole_object, ole_bookmark)
	else
		wf_insert_field("Name1", name1, ole_object, ole_bookmark)
	end if
end if

wf_insert_field("Date", ls_date, ole_object, ole_bookmark)
wf_insert_field("Section", is_profitcenter_name, ole_object, ole_bookmark)
wf_insert_field("Initials", is_userfullname, ole_object, ole_bookmark)
wf_insert_field("Subject", ls_subject, ole_object, ole_bookmark)
wf_insert_field("DHM", ls_dhm, ole_object, ole_bookmark)
wf_insert_field("Signer", is_userfullname, ole_object, ole_bookmark)

if dw_paymentcurr.visible = true then
	wf_insert_field("Amount_sanction", "~r~n" + ls_amount, ole_object, ole_bookmark)
	wf_set_sanctioninfo(ld_amount)
	wf_insert_field("sanction_line1", istr_transaction_input.s_sanction_line_1, ole_object, ole_Bookmark)
	wf_insert_field("sanction_line2", istr_transaction_input.s_sanction_line_2 + "~r~n", ole_object, ole_Bookmark)
else
	wf_insert_field("Amount", ls_amount, ole_object, ole_bookmark)
end if

// To be on top
wf_insert_field("Name1", "", ole_object, ole_bookmark)

ole_object.visible = true

Destroy ole_Bookmark
Destroy ole_object


Return
end subroutine

public function long wf_print_dem ();/********************************************************************
   wf_print_dem
   <DESC>  </DESC>
   <RETURN>		
	</RETURN>          	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
   	Date    		CR-Ref		Author		Comments
   	10/12/14		CR3216		XSZ004		Enable to select deductible brokers when sending invoice data.
		19/09/16  	CR2212		LHG008		Sanctions restrictions
	25/10/16		CR3385		HXH010		Update forwarding date when (Re)send invoice data to AX
   </HISTORY>
********************************************************************/

string     ls_port, ls_dem_des, ls_DefaultPrinter, ls_PDFprinter, ls_invoice_nr
string     customervat_nr, acustomervat_nr, ls_broker_name, ls_currency_code
integer    li_counter, li_row, li_pc_nr, li_statictextheight=60, li_broker_nr
long       ll_printjob, ll_row, ll_rows, ll_calcid, ll_counter, ll_insertrow
decimal    ld_amount, ld_des1, ld_des2, ld_dem1, ld_dem2
decimal    customer_apl_vat_rate, acustomer_apl_vat_rate
decimal    ld_comm_amountusd, ld_comm_amount, ld_broker_cms_amt
decimal{2} ld_amount_local
boolean    lb_continue, lb_stop

DataWindowChild dwc, ldwc_demurrage, ldwc_despatch
mt_n_datastore  lnv_getfixrate
mt_u_datawindow ldw_stat

id_ex_rate = 0
ldw_stat   = dw_print_demurrage_statement

lnv_getfixrate = create mt_n_datastore

SELECT CAL_CALC_ID INTO :ll_calcid 
FROM   VOYAGES 
WHERE  VESSEL_NR = :istr_parm.vessel_nr AND VOYAGE_NR = :istr_parm.voyage_nr ;

lnv_getfixrate.dataobject = "d_sq_tb_getfixrate"
lnv_getfixrate.settrans( SQLCA)
lnv_getfixrate.retrieve(istr_parm.vessel_nr, ll_calcid, istr_parm.chart_nr)

ii_fixrate = 0

if lnv_getfixrate.rowcount( )  = 1 then
	ii_fixrate = lnv_getfixrate.getitemnumber( 1, "cal_carg_fix_exrate")
	is_calccurrcode =  lnv_getfixrate.getitemstring( 1, "cal_carg_cal_carg_curr_code")
	
	if ii_fixrate = 1 and is_calccurrcode <>  is_currcode then
		id_ex_rate = lnv_getfixrate.getitemnumber( 1, "cal_carg_fixed_exrate") /100
		is_ex_rate = string(id_ex_rate) 
	else
		ii_fixrate = 0
	end if
else
	messagebox("Error","It is not possible to get exchange rate from fixture. Please contact system administrator.")
	ii_fixrate = 0
end if

destroy(lnv_getfixrate)

if id_ex_rate = 0 then id_ex_rate = 1 

if len(PrintGetPrinter()) < 6 then printSetup()

if (cbx_print_front_page.checked) then
	wf_front_page()
end if

if cbx_bol.checked then
	UPDATE DEM_DES_CLAIMS
	SET    PRINT_BOL_DATE_TEXT = :sle_boldate.text, 
	       PRINT_PRODUCT_TEXT = :sle_product.text
	WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
	       CHART_NR  = :istr_parm.chart_nr  AND
	       VOYAGE_NR = :istr_parm.voyage_nr AND
	       CLAIM_NR  = :istr_parm.claim_nr  AND
	       DEM_DES_SETTLED <> 0
	USING  SQLCA; 	
end if

if cbx_coa.checked then
	UPDATE DEM_DES_CLAIMS
	SET    PRINT_COA_TEXT = :sle_coa.text
	WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
	       CHART_NR  = :istr_parm.chart_nr  AND
	       VOYAGE_NR = :istr_parm.voyage_nr AND
	       CLAIM_NR  = :istr_parm.claim_nr  AND
	       DEM_DES_SETTLED <> 0
	USING  SQLCA;		
end if

if ib_indc_changed then
	UPDATE DEM_DES_CLAIMS
	SET    INDC = :cbx_indc.checked
	WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
	       CHART_NR  = :istr_parm.chart_nr  AND
	       VOYAGE_NR = :istr_parm.voyage_nr AND
	       CLAIM_NR  = :istr_parm.claim_nr  AND
	       DEM_DES_SETTLED <> 0
	USING  SQLCA;
	
	ib_indc_changed = false
end if

if dw_print_laytime_statement.rowcount() < 1 then
	if cbx_print_front_page.checked then
		return c#return.Failure
	else
		MessageBox("Information", "You can't print Demurrage Claims until Laytime entered!")
		return c#return.Failure
	end if
end if

/* Get default printer */
ls_DefaultPrinter = printGetPrinter()

/* When PDF print, select printername from ini-file and set driver for next printjob */
if rb_pdf.checked then
	ls_PDFprinter = uo_global.is_pdfdriver
	if  ls_PDFprinter = "None" then
		MessageBox("Error!", "No PDF printer driver found in TRAMOS.INI file. ~r~nPlease try again "+&
						"or contact the System Administrator if the problem recurs.", StopSign!)
		return c#return.Failure
	END IF

	printSetPrinter(ls_PDFprinter)
end if

If uo_global.gs_template_path = "" Then
	Messagebox("Missing File Path in System Options","You have not inserted details in 'System Options' the field 'File Path to MS Word templates'", StopSign!)
	return c#return.Failure
End If

setpointer(hourglass!)

cb_print.enabled = false
cb_close.enabled = false

// Print STATEMENT OF DEMURRAGE
IF not ib_only_layt THEN
	wf_fill_demurrage_statement()
	
	ldw_stat.GetChild("report_demurrage", ldwc_demurrage)
	ldw_stat.GetChild("report_demurrage", ldwc_despatch)
	
	ldwc_demurrage.modify("DataWindow.Summary.Height=108")
	ldwc_despatch.modify("DataWindow.Summary.Height=108") 
	
END IF

SetPointer(Hourglass!)

IF ib_only_layt THEN
	ldw_stat.Modify("dw_print_demurrage_tank.Visible = 0")
	ldw_stat.Modify("dw_print_demurrage_bulk.Visible = 0")
	ldw_stat.Modify("dw_print_demurrage_debitnote.Visible = 0")
	ldw_stat.Modify("dw_print_despatch_debitnote.Visible = 0")
	ldw_stat.GetChild("report_summary", dwc)
	
	FOR li_counter = 1 TO istr_parm.dem_des_sets
		dwc.Insertrow(0)
		ls_port = dw_print_laytime_statement.GetItemString(li_counter,"ports_port_n")
		dwc.SetItem(li_counter,"port",ls_port)
		
		ld_amount = dw_print_laytime_statement.GetItemDecimal(li_counter,"compute_0035")
		ls_dem_des = dw_print_laytime_statement.GetItemString(li_counter,"compute_0036")
		IF ls_dem_des = "Demurrage" THEN
			dwc.SetItem(li_counter,"dem",ld_amount)
		
		ELSEIF ls_dem_des = "Despatch" THEN
			dwc.SetItem(li_counter,"des",ld_amount)
		
		END IF
	NEXT
	
	dwc.SetSort("port A")
	dwc.Sort()
	
	lb_continue = TRUE
	li_row      = 1
	
	DO WHILE lb_continue 
		lb_stop = FALSE
		
		IF dwc.RowCount() < (li_row + 1) THEN
			lb_stop = TRUE
			lb_continue = FALSE
		END IF
		
		DO WHILE NOT lb_stop			
			IF	dwc.GetItemString(li_row,"port") = dwc.GetItemString((li_row+1),"port") THEN
				ld_dem1 = dwc.GetItemDecimal(li_row,"dem")
				IF IsNull(ld_dem1) THEN ld_dem1 = 0
				ld_dem2 = dwc.GetItemDecimal((li_row+1),"dem") 
				IF IsNull(ld_dem2) THEN ld_dem2 = 0
				ld_des1 = dwc.GetItemDecimal(li_row,"des") 
				IF IsNull(ld_des1) THEN ld_des1 = 0
				ld_des2 =dwc.GetItemDecimal((li_row+1),"des") 
				IF IsNull(ld_des2) THEN ld_des2 = 0
				IF ld_dem1 = ld_dem2 AND ld_des1 = ld_des2 THEN
					 dwc.Deleterow((li_row+1))
				END IF
			ELSE
				lb_stop = TRUE
			END IF
			
			IF  dwc.RowCount() < (li_row + 1) THEN
				 lb_stop = TRUE
				 lb_continue = FALSE
			END IF
		LOOP
		
		li_row += 1	
	LOOP
ELSE
	ldw_stat.Modify("report_summary.Visible = 0")
END IF
 
// Set reference number
ldw_stat.object.report_header.object.t_ref.text = "Ref: " + is_userfullname + " / " + String(Today(), "ddmmmyy")

SELECT CHART_VAT_NR, CHART_INV_VAT_NR, CHART_APL_VAT_RATE, CHART_INV_APL_VAT_RATE
INTO   :customervat_nr, :acustomervat_nr, :customer_apl_vat_rate, :acustomer_apl_vat_rate
FROM   CHART
WHERE  CHART_NR = :istr_parm.chart_nr;
	
if cbx_alt_adress.checked then
	ldw_stat.Modify("vatno.text='"+acustomervat_nr+"'")
	ldw_stat.Modify("aplvatrate.text='"+string(acustomer_apl_vat_rate)+"%'")
else
	ldw_stat.Modify("vatno.text='"+customervat_nr+"'")
	ldw_stat.Modify("aplvatrate.text='"+string(customer_apl_vat_rate)+"%'")
end if

ldw_stat.getchild("report_header",dwc)
	
if (cbx_bol.checked) then
	dwc.setitem(1,"bl_date", sle_boldate.text )
	dwc.setitem(1,"grade", sle_product.text )
	ldw_stat.object.report_header.Object.bl_date.Visible="1"
	ldw_stat.object.report_header.Object.grade.Visible="1"
	ldw_stat.object.report_header.Object.t_bl_date.Visible="1"
	ldw_stat.object.report_header.Object.t_grade.Visible="1"
end if

if (cbx_coa.checked) then
	dwc.setitem(1,"coa", sle_coa.text )
	ldw_stat.object.report_header.Object.coa.Visible="1"
	ldw_stat.object.report_header.Object.t_coa.Visible="1"
end if

if (cbx_indc.checked) then
	dwc.setitem(1,"indc", "In direct continuation" )
	ldw_stat.object.report_header.Object.indc.Visible="1"
	ldw_stat.object.report_header.Object.claims_laycan_start.Visible="0"
	ldw_stat.object.report_header.Object.t_9.Visible="0"
	ldw_stat.object.report_header.Object.claims_laycan_end.Visible="0"
End if

ll_rows    = dw_brokers.rowcount()
ll_counter = 1

if ll_rows > 0 then
	SELECT CURR_CODE INTO :ls_currency_code
	FROM   CLAIMS
	WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
	       VOYAGE_NR = :istr_parm.voyage_nr AND
	       CHART_NR  = :istr_parm.chart_nr  AND
	       CLAIM_TYPE = "DEM";
	
	dw_print_demurrage_statement.GetChild("report_demurrage", dwc)
	
	FOR ll_row= ll_rows TO 1 step -1		
		if (dw_brokers.isselected(ll_row)) then
			
			li_broker_nr   = dw_brokers.getitemnumber(ll_row, "brokers_broker_nr")
			ls_broker_name = dw_brokers.getitemstring(ll_row, "brokers_broker_name")
			
			SELECT sum(COMMISSIONS.COMM_AMOUNT)  , round(sum(COMMISSIONS.COMM_AMOUNT_LOCAL_CURR), 2)  
			INTO   :ld_comm_amountusd, :ld_comm_amount
			FROM   COMMISSIONS, CLAIMS  
			WHERE  ( CLAIMS.CHART_NR  = COMMISSIONS.CHART_NR )  and  
			       ( CLAIMS.VESSEL_NR = COMMISSIONS.VESSEL_NR ) and  
			       ( CLAIMS.VOYAGE_NR = COMMISSIONS.VOYAGE_NR ) and  
			       ( CLAIMS.CLAIM_NR  = COMMISSIONS.CLAIM_NR )  and  
			       ( (COMMISSIONS.VESSEL_NR = :istr_parm.vessel_nr ) AND  
			       ( COMMISSIONS.VOYAGE_NR  = :istr_parm.voyage_nr ) AND  
			       ( COMMISSIONS.CHART_NR   = :istr_parm.chart_nr )  AND  
			       ( COMMISSIONS.BROKER_NR  = :li_broker_nr )        AND  
			       ( CLAIMS.CLAIM_TYPE = "DEM" ))
			USING  SQLCA;
			
			if cbx_print_statement.checked = true then
				ll_insertrow = dwc.insertrow(0)
				dwc.setitem(ll_insertrow, "line_1", ls_broker_name)
				dwc.setitem(ll_insertrow, "currency", ls_currency_code)
				dwc.setitem(ll_insertrow, "amount", -ld_comm_amount)
			end if
			
			ld_broker_cms_amt += ld_comm_amount
			
			istr_transaction_input.broker_amount_array[ll_counter] = ld_comm_amount
			istr_transaction_input.broker_id_array[ll_counter]     = li_broker_nr
			
			ll_counter += 1
		end if
	NEXT
End if

If (cbx_sendax.checked) then
	if ld_broker_cms_amt > 0 then
		istr_transaction_input.payment_amount = istr_transaction_input.payment_amount - ld_broker_cms_amt
	end if
	
	wf_set_sanctioninfo(istr_transaction_input.payment_amount)
	
	wf_set_forwarding_date()
	
	wf_send_to_ax()
	
end if

If (cbx_print_statement.checked)  then
	/* get invoice no */
	ld_amount_local = istr_transaction_input.amount_local
	if this.wf_get_invoice(ld_amount_local) = c#return.Failure then
		messagebox("Database Read Error", "Error reading from table claims.~r~nSQLErrText=" + SQLCA.SQLErrText)
		cb_close.enabled = true
		cb_close.triggerevent(clicked!)
		return c#return.Failure
	end if
	
	if ii_vessel_pc_nr = 3 OR ii_vessel_pc_nr = 5 then
		ldw_stat.getchild("report_bulk",dwc)
	else
		ldw_stat.getchild("report_tank",dwc)
	end if
	
	dw_print_demurrage_statement.GetChild("report_demurrage", dwc)
	if dw_paymentcurr.visible = true then
		wf_set_sanctioninfo(istr_transaction_input.payment_amount)
		dwc.modify("t_sanction_line1.Text='" + istr_transaction_input.s_sanction_line_1 + "'")
		dwc.modify("t_sanction_line2.Text='" + istr_transaction_input.s_sanction_line_2 + "'")
		dwc.modify("DataWindow.Summary.Height=376")
	end if
	
	dwc.modify("invnr.Text='" + is_invoice + "'")
	
	/* open printjob */
	ll_printJob = PrintOpen()
	printDataWindow(ll_printJob, ldw_stat)
	

	// Print LAYTIME STATEMENT
	ll_rows = dw_print_laytime_statement.rowcount()
	FOR ll_row=1 TO ll_rows
		dw_print_laytime_statement.setitem(ll_row, "chart_chart_n_1", wf_getchart())
	NEXT
	
	PrintDataWindow(ll_printjob, dw_print_laytime_statement)
	
	// Print GROUP DEDUCTIONS
	If dw_print_group_deductions.RowCount() > 0 THEN
		ll_rows = dw_print_group_deductions.rowcount()
		FOR ll_row=1 TO ll_rows
			dw_print_group_deductions.setitem(ll_row, "chart_chart_n_1", wf_getchart())
		NEXT
		
		PrintDataWindow(ll_printjob, dw_print_group_deductions)
	End If
	
	/* Close printjob and print */
	PrintClose(ll_printJob)	
End If

/*Set the default printer back to the original default*/
printSetPrinter(ls_DefaultPrinter)	

if (cbx_broker.checked) then
	is_templateprefix = 'demurrage_letter_broker'
	wf_print(1)
end if

if (cbx_charterer.checked) then
	is_templateprefix = 'demurrage_letter_charterer'
	wf_print(2)
end if

if (cbx_office.checked) then
	is_templateprefix = 'demurrage_letter_broker'
	wf_print(3)
end if

cb_close.enabled = true

return c#return.Success

end function

public subroutine wf_disble_print (boolean ab_disbleprint);if ab_disbleprint then
	cb_print.enabled = false
else
	cb_print.enabled = (cbx_sendax.checked or cbx_print_statement.checked or cbx_broker.checked or cbx_charterer.checked or cbx_office.checked or cbx_print_front_page.checked)
end if
end subroutine

on w_print_support_documents_dem.create
int iCurrent
call super::create
this.cbx_print_front_page=create cbx_print_front_page
this.cb_printer=create cb_printer
this.cbx_print_statement=create cbx_print_statement
this.cbx_bol=create cbx_bol
this.sle_boldate=create sle_boldate
this.st_8=create st_8
this.sle_product=create sle_product
this.st_10=create st_10
this.cbx_coa=create cbx_coa
this.sle_coa=create sle_coa
this.st_11=create st_11
this.cbx_lac=create cbx_lac
this.cbx_indc=create cbx_indc
this.rb_printer=create rb_printer
this.rb_pdf=create rb_pdf
this.gb_3=create gb_3
this.gb_1=create gb_1
this.dw_print_group_deductions=create dw_print_group_deductions
this.dw_print_demurrage_statement=create dw_print_demurrage_statement
this.dw_print_laytime_statement=create dw_print_laytime_statement
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_print_front_page
this.Control[iCurrent+2]=this.cb_printer
this.Control[iCurrent+3]=this.cbx_print_statement
this.Control[iCurrent+4]=this.cbx_bol
this.Control[iCurrent+5]=this.sle_boldate
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.sle_product
this.Control[iCurrent+8]=this.st_10
this.Control[iCurrent+9]=this.cbx_coa
this.Control[iCurrent+10]=this.sle_coa
this.Control[iCurrent+11]=this.st_11
this.Control[iCurrent+12]=this.cbx_lac
this.Control[iCurrent+13]=this.cbx_indc
this.Control[iCurrent+14]=this.rb_printer
this.Control[iCurrent+15]=this.rb_pdf
this.Control[iCurrent+16]=this.gb_3
this.Control[iCurrent+17]=this.gb_1
this.Control[iCurrent+18]=this.dw_print_group_deductions
this.Control[iCurrent+19]=this.dw_print_demurrage_statement
this.Control[iCurrent+20]=this.dw_print_laytime_statement
this.Control[iCurrent+21]=this.gb_2
end on

on w_print_support_documents_dem.destroy
call super::destroy
destroy(this.cbx_print_front_page)
destroy(this.cb_printer)
destroy(this.cbx_print_statement)
destroy(this.cbx_bol)
destroy(this.sle_boldate)
destroy(this.st_8)
destroy(this.sle_product)
destroy(this.st_10)
destroy(this.cbx_coa)
destroy(this.sle_coa)
destroy(this.st_11)
destroy(this.cbx_lac)
destroy(this.cbx_indc)
destroy(this.rb_printer)
destroy(this.rb_pdf)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.dw_print_group_deductions)
destroy(this.dw_print_demurrage_statement)
destroy(this.dw_print_laytime_statement)
destroy(this.gb_2)
end on

event open;call super::open;long   ll_counter, ll_vsl, ll_businessunit, ll_showinvas = 0
string ls_voy, ls_port
int    li_sets

u_claimbalance luo_claimbalance

/* First check that there no ports where difference between commenced and completed*/
SELECT TOP 1 VESSEL_NR, VOYAGE_NR, PORT_CODE
INTO   :ll_vsl, :ls_voy,: ls_port
FROM   LAYTIME_STATEMENTS
WHERE  DATEDIFF(MI, LAY_COMMENCED, LAY_COMPLETED) <> LAY_MINUTES and
       VESSEL_NR = :istr_parm.vessel_nr AND
       VOYAGE_NR = :istr_parm.voyage_nr AND
       CHART_NR  = :istr_parm.chart_nr;
		 
if ll_vsl <> 0 then
	MessageBox("Validation Error", "There is a mismatch between Commenced, Completed and Laytime minutes for:"&
											+"~r~n~r~nVessel: "+string(ll_vsl) &
											+"~r~nVoyage: "+ls_voy &
											+"~r~nPortCode: "+ls_port) 
	close(this)
	return
end if											

f_Center_Window(This)

if isnull(ii_office_nr) then
	cbx_office.enabled = false
end if

if isnull(ii_broker_nr) then
	cbx_broker.enabled = false
end if

SELECT COUNT(*) INTO :ll_counter
FROM   DEM_DES_CLAIMS
WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
       CHART_NR = :istr_parm.chart_nr AND
       VOYAGE_NR = :istr_parm.voyage_nr AND
       CLAIM_NR = :istr_parm.claim_nr 
USING  SQLCA;
COMMIT USING SQLCA;	

IF ll_counter > 1 THEN
	dw_print_laytime_statement.DataObject="dw_print_laytime_statement_new"
END IF

dw_print_laytime_statement.SetTransObject(SQLCA)
dw_print_demurrage_statement.SetTransObject(SQLCA)
dw_print_group_deductions.SetTransObject(SQLCA)


SELECT PRINT_BOL_DATE_TEXT, PRINT_PRODUCT_TEXT, isnull(PRINT_COA_TEXT, ""), INDC
INTO   :sle_boldate.text, :sle_product.text, :sle_coa.text, :cbx_indc.checked
FROM   DEM_DES_CLAIMS
WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
       CHART_NR = :istr_parm.chart_nr AND
       VOYAGE_NR = :istr_parm.voyage_nr AND
       CLAIM_NR = :istr_parm.claim_nr AND
       DEM_DES_SETTLED <> 0
USING  SQLCA;
COMMIT USING SQLCA; 			

if len(sle_boldate.text) > 2 then 
	cbx_bol.checked = true
	sle_boldate.enabled = true
	sle_product.enabled = true
end if

if len(sle_coa.text) > 0 then 
	cbx_coa.checked = true
	sle_coa.enabled = true
end if

SELECT COUNT(*) INTO :li_sets
FROM   DEM_DES_CLAIMS
WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
       CHART_NR  = :istr_parm.chart_nr AND
       VOYAGE_NR = :istr_parm.voyage_nr AND
       CLAIM_NR  = :istr_parm.claim_nr AND
       DEM_DES_SETTLED <> 0
USING  SQLCA;
COMMIT USING SQLCA; 			

istr_parm.dem_des_sets = li_sets

SELECT SHOW_IN_VAS INTO :ll_showinvas
FROM   CLAIMS
WHERE  VESSEL_NR = :istr_parm.vessel_nr AND
       CHART_NR = :istr_parm.chart_nr AND
       VOYAGE_NR = :istr_parm.voyage_nr AND
       CLAIM_NR = :istr_parm.claim_nr;

if cbx_sendax.enabled then
	luo_claimbalance = create u_claimbalance
	luo_claimbalance.of_claimbalance(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, istr_parm.claim_nr)
	
	if dec(luo_claimbalance.st_balance_usd.text) < 0 then
		if luo_claimbalance.of_get_claimpercentage( ) <= 0 then
			cbx_sendax.enabled = false
		elseif ll_showinvas = 1 then
			SELECT BU_ID INTO :ll_businessunit 
			FROM   USERS 
			WHERE  USERID = :uo_global.is_userid;
			
			// business unit - demurrage
			if isnull(ll_businessunit) then ll_businessunit = 0
			//users and Demurrage /superusers/administrators
			if not ((uo_global.ii_access_level = 1 and ll_businessunit = 11) or uo_global.ii_access_level = 2 or uo_global.ii_access_level = 3) then
				cbx_sendax.enabled = false			 
			end if
		
		else//ll_showinvas = 0
			cbx_sendax.enabled = false
		end if
	end if
	destroy luo_claimbalance
end if

PostEvent("ue_retrieve")

//if sle_coa.enabled = false then sle_coa.backcolor = c#color.MT_FORM_BG

end event

event ue_retrieve;call super::ue_retrieve;integer li_rows
SetPointer(HourGlass!)

dw_print_laytime_statement.Retrieve(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr)

If istr_parm.dem_des_sets > 1 THEN
	ib_only_layt = TRUE
	dw_print_laytime_statement.Modify("cp_rate.Visible = 0")
	dw_print_laytime_statement.Modify("compute_0031.Visible = 1")
	dw_print_laytime_statement.Modify("compute_0033.Visible = 1")
	dw_print_laytime_statement.Modify("compute_0034.Visible = 1")
	dw_print_laytime_statement.Modify("compute_0035.Visible = 1")
	dw_print_laytime_statement.Modify("compute_0036.Visible = 1")
	dw_print_laytime_statement.Modify("compute_0037.Visible = 1")

	li_rows =	 dw_print_laytime_statement.RowCount()
	istr_parm.dem_des_sets =  li_rows
	IF istr_parm.dem_des_sets > 0 THEN wf_port_amounts()	
END IF
	
dw_print_demurrage_statement.Retrieve(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr)
COMMIT USING SQLCA;
dw_print_group_deductions.Retrieve(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr)
COMMIT USING SQLCA;

SetPointer(Arrow!)
end event

type st_hidemenubar from w_print_claim_basewindow`st_hidemenubar within w_print_support_documents_dem
end type

type dw_claim_sent from w_print_claim_basewindow`dw_claim_sent within w_print_support_documents_dem
integer x = 73
integer y = 1024
integer taborder = 50
end type

event dw_claim_sent::ue_dwkeypress;if keyflags = 1 then
	if key = keytab! and this.getcolumnname() = "adj_type_id" then setfocus(cbx_lac)
end if
end event

type cbx_print from w_print_claim_basewindow`cbx_print within w_print_support_documents_dem
boolean visible = false
integer x = 1024
integer y = 1680
integer width = 695
end type

type cbx_office from w_print_claim_basewindow`cbx_office within w_print_support_documents_dem
integer x = 658
integer y = 1824
integer width = 238
integer taborder = 180
end type

event cbx_office::clicked;call super::clicked;if this.checked then
	cbx_alt_adress.enabled = true
elseif (cbx_broker.checked  or cbx_charterer.checked) then
	cbx_alt_adress.enabled = true
else
	cbx_alt_adress.enabled = false
	cbx_alt_adress.checked = false
end if
end event

type cbx_alt_adress from w_print_claim_basewindow`cbx_alt_adress within w_print_support_documents_dem
boolean visible = false
integer x = 951
integer y = 1680
integer width = 768
boolean enabled = false
string text = "Use alternative invoice address"
end type

type st_9 from w_print_claim_basewindow`st_9 within w_print_support_documents_dem
boolean visible = false
integer x = 1737
integer y = 1672
integer width = 585
integer height = 48
boolean enabled = false
string text = "Print cover letter for"
end type

type st_7 from w_print_claim_basewindow`st_7 within w_print_support_documents_dem
integer x = 37
integer y = 476
end type

type dw_brokers from w_print_claim_basewindow`dw_brokers within w_print_support_documents_dem
integer x = 37
integer y = 544
integer width = 2277
integer height = 360
integer taborder = 20
end type

type cbx_charterer from w_print_claim_basewindow`cbx_charterer within w_print_support_documents_dem
integer x = 329
integer y = 1824
integer width = 311
integer taborder = 170
boolean checked = false
end type

event cbx_charterer::clicked;call super::clicked;if this.checked then
	cbx_alt_adress.enabled = true
elseif (cbx_office.checked  or cbx_broker.checked) then
	cbx_alt_adress.enabled = true
else
	cbx_alt_adress.enabled = false
	cbx_alt_adress.checked = false
end if
end event

type cbx_broker from w_print_claim_basewindow`cbx_broker within w_print_support_documents_dem
integer x = 73
integer y = 1824
integer width = 238
integer taborder = 160
end type

event cbx_broker::clicked;call super::clicked;if this.checked then
	cbx_alt_adress.enabled = true
elseif (cbx_office.checked  or cbx_charterer.checked) then
	cbx_alt_adress.enabled = true
else
	cbx_alt_adress.enabled = false
	cbx_alt_adress.checked = false
end if
	
		
end event

type cb_print from w_print_claim_basewindow`cb_print within w_print_support_documents_dem
integer x = 1632
integer y = 1936
integer taborder = 210
end type

type cb_close from w_print_claim_basewindow`cb_close within w_print_support_documents_dem
integer x = 1979
integer y = 1936
integer taborder = 220
end type

type dw_chart from w_print_claim_basewindow`dw_chart within w_print_support_documents_dem
integer x = 37
integer y = 96
integer width = 2277
string title = ""
boolean ib_setdefaultbackgroundcolor = true
end type

type dw_duedate from w_print_claim_basewindow`dw_duedate within w_print_support_documents_dem
integer x = 1733
integer y = 956
integer taborder = 60
end type

type st_charterer from w_print_claim_basewindow`st_charterer within w_print_support_documents_dem
integer y = 32
end type

type cbx_sendax from w_print_claim_basewindow`cbx_sendax within w_print_support_documents_dem
integer x = 73
integer y = 960
integer taborder = 30
end type

type dw_paymentcurr from w_print_claim_basewindow`dw_paymentcurr within w_print_support_documents_dem
integer x = 1536
integer y = 1040
integer taborder = 70
end type

type p_infoax from w_print_claim_basewindow`p_infoax within w_print_support_documents_dem
integer x = 681
integer y = 956
end type

type dw_info from w_print_claim_basewindow`dw_info within w_print_support_documents_dem
end type

type cbx_print_front_page from checkbox within w_print_support_documents_dem
integer x = 951
integer y = 1824
integer width = 503
integer height = 56
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print front page"
end type

event clicked;wf_disble_print()
end event

type cb_printer from commandbutton within w_print_support_documents_dem
integer x = 37
integer y = 1936
integer width = 343
integer height = 100
integer taborder = 200
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Printer..."
end type

event clicked;printSetup()
end event

type cbx_print_statement from checkbox within w_print_support_documents_dem
integer x = 73
integer y = 1184
integer width = 731
integer height = 56
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print supporting documents"
end type

event clicked;rb_pdf.enabled = this.checked
if NOT this.checked then 
	rb_printer.checked = true
end if
wf_disble_print()
end event

type cbx_bol from checkbox within w_print_support_documents_dem
integer x = 73
integer y = 1460
integer width = 485
integer height = 56
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "B/L date / Product"
end type

event clicked;sle_boldate.enabled = this.checked
sle_product.enabled = this.checked
end event

type sle_boldate from singlelineedit within w_print_support_documents_dem
integer x = 576
integer y = 1444
integer width = 343
integer height = 72
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_8 from statictext within w_print_support_documents_dem
integer x = 933
integer y = 1444
integer width = 59
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "/"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_product from singlelineedit within w_print_support_documents_dem
integer x = 997
integer y = 1444
integer width = 791
integer height = 72
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_print_support_documents_dem
integer x = 142
integer y = 1540
integer width = 1518
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "(B/L date and Product will, if entered be printed on Statement of Demurrage)"
boolean focusrectangle = false
end type

type cbx_coa from checkbox within w_print_support_documents_dem
integer x = 73
integer y = 1624
integer width = 229
integer height = 56
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "COA"
end type

event clicked;sle_coa.enabled = this.checked

end event

type sle_coa from singlelineedit within w_print_support_documents_dem
integer x = 293
integer y = 1608
integer width = 786
integer height = 72
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within w_print_support_documents_dem
integer x = 1097
integer y = 1624
integer width = 1207
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "(COA will, if entered be printed on Statement of Demurrage)"
boolean focusrectangle = false
end type

type cbx_lac from checkbox within w_print_support_documents_dem
integer x = 896
integer y = 960
integer width = 677
integer height = 56
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Less address commission"
end type

type cbx_indc from checkbox within w_print_support_documents_dem
integer x = 896
integer y = 1184
integer width = 645
integer height = 56
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "In direct continuation"
end type

event clicked;ib_indc_changed = true
end event

type rb_printer from radiobutton within w_print_support_documents_dem
integer x = 110
integer y = 1336
integer width = 238
integer height = 56
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Printer"
boolean checked = true
end type

type rb_pdf from radiobutton within w_print_support_documents_dem
integer x = 366
integer y = 1336
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "PDF-file"
end type

type gb_3 from groupbox within w_print_support_documents_dem
integer x = 73
integer y = 1264
integer width = 585
integer height = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print to..."
end type

type gb_1 from groupbox within w_print_support_documents_dem
integer x = 37
integer y = 904
integer width = 2286
integer height = 812
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type dw_print_group_deductions from mt_u_datawindow within w_print_support_documents_dem
boolean visible = false
integer x = 1591
integer y = 904
integer width = 219
integer height = 80
integer taborder = 250
string dataobject = "dw_print_group_deductions"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_print_demurrage_statement from mt_u_datawindow within w_print_support_documents_dem
boolean visible = false
integer x = 1390
integer y = 872
integer width = 274
integer height = 128
integer taborder = 240
string dataobject = "dw_print_demurrage_tank_bulk"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_print_laytime_statement from mt_u_datawindow within w_print_support_documents_dem
boolean visible = false
integer x = 1737
integer y = 872
integer width = 256
integer height = 112
integer taborder = 230
string dataobject = "dw_print_laytime_statement"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_print_support_documents_dem
integer x = 37
integer y = 1736
integer width = 878
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print cover letter for"
end type

