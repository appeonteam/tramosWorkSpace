$PBExportHeader$n_report_spot_contracts.sru
forward
global type n_report_spot_contracts from mt_n_nonvisualobject
end type
end forward

global type n_report_spot_contracts from mt_n_nonvisualobject
end type
global n_report_spot_contracts n_report_spot_contracts

type variables
mt_n_datastore		ids_voyages
datetime				idt_periodstart, idt_periodend

end variables

forward prototypes
public function long of_getvoyages (integer ai_profitcenter, ref datawindow adw_excluded_vessels, datetime adt_start, datetime adt_end, ref integer ai_contracttype[])
public function integer of_create_report (ref datawindow adw_report, ref datawindow adw_vas_report, ref hprogressbar avpb, boolean ab_estimated, boolean ab_gross_income, integer ai_tcout_index, long al_tcout_days)
private subroutine of_messagebox (string as_title, string as_message)
public subroutine documentation ()
end prototypes

public function long of_getvoyages (integer ai_profitcenter, ref datawindow adw_excluded_vessels, datetime adt_start, datetime adt_end, ref integer ai_contracttype[]);/* This function gets all the voyages that are inside the given date intervals or 
	are overlapping the dates eighter in the beginning or the end.
	Retrieve only voyages for one profitcenter at the time with exclusion 
	of selected vessels.
	Only SPOT voyages are retrieved (COA Market rate, CVS Market rate and SPOT)
	Selects both from POC and POC_EST
*/
long		ll_rows, ll_row
integer	li_contype
string		ls_contype_string
string		ls_excluded_vessels_filter
mt_n_transaction ltr_trans

idt_periodstart	= adt_start
idt_periodend	= adt_end

setNull(ls_excluded_vessels_filter)
ll_row = adw_excluded_vessels.getSelectedRow(0)
do while ll_row > 0
	if isnull(ls_excluded_vessels_filter) then
		ls_excluded_vessels_filter = string(adw_excluded_vessels.getItemNumber(ll_row, "vessel_nr"))
	else
		ls_excluded_vessels_filter += ", "+string(adw_excluded_vessels.getItemNumber(ll_row, "vessel_nr"))
	end if
	ll_row = adw_excluded_vessels.getSelectedRow(ll_row)
loop
if len(ls_excluded_vessels_filter) > 0 then
	ls_excluded_vessels_filter = "vessel_nr not in ("+ls_excluded_vessels_filter+")"
else
	ls_excluded_vessels_filter = ""
end if

//ltr_trans = create mt_n_transaction
//ltr_trans.DBMS = SQLCA.DBMS 
//ltr_trans.Database = SQLCA.Database 
//ltr_trans.LogPass = SQLCA.LogPass
//ltr_trans.Servername = SQLCA.ServerName
//ltr_trans.LogId = SQLCA.LogId
//ltr_trans.AutoCommit = True
//ltr_trans.DBParm = SQLCA.DBParm
ids_voyages.setTrans(sqlca)

ll_rows = ids_voyages.retrieve(ai_profitcenter, adt_start, adt_end)

if ll_rows < 1 then
	MessageBox("Information", "No voyages matching given dates, profitcenter and contract type")
	return c#return.Failure
end if	

/* set excludede vessels filter */
ids_voyages.setfilter(ls_excluded_vessels_filter)
ids_voyages.filter()

/* Filter out all voyages that not have the right type 
	(first build a search string with the types in to speed up searching */
for ll_row = 1 to upperbound(ai_contracttype[])
	ls_contype_string += " "+string(ai_contracttype[ ll_row ])
next

ll_rows = ids_voyages.rowCount()
for ll_row = ll_rows to 1 step -1
	li_contype = ids_voyages.getItemNumber(ll_row, "contract_type")
	if pos( ls_contype_string, string(li_contype)) < 1 then ids_voyages.deleteRow( ll_row )
next	
	
ll_rows = ids_voyages.rowCount()
if ll_rows < 1 then
	MessageBox("Information", "No voyages matching given dates, profitcenter and contract type")
	return c#return.Failure
end if	
return ll_rows
end function

public function integer of_create_report (ref datawindow adw_report, ref datawindow adw_vas_report, ref hprogressbar avpb, boolean ab_estimated, boolean ab_gross_income, integer ai_tcout_index, long al_tcout_days);/********************************************************************
   of_create_report
   <DESC>	Use the VAS report data to make sopt_contracts report	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_report              spot_contract report
		adw_vas_report          VAS_report
		avpb                    progessbar display  guage  
		ab_estimated            estimated column's prefix ,vas option
		ab_gross_income         gross_income compute,vas option
		ai_tcout_index          TC-outindex ,vas option
		al_tcout_days           TC-contract type ,vas option
   </ARGS>
   <USAGE>	called from w_report_sport_contracts.cb_retrieve	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             	Comments
																 	(1)initial Version
   	02/08/11   	CR2480		TTY004             	(2)Add Demurrage and vas_idle_days column
   	10/07/12   	CR2609      LGX001             	(3)Fixed bug when voyage type is tc out
		04/05/14   	CR3333	   CCY018     		  		provide same validation window when voyage length < 0.5 days (same with 0 days)
		20/03/15		CR4003		AGL027					fix minor issue with TC-Out fixure user
		31/03/15    CR4012		AGL027					bug from previous modification when user selects particular criteria.
		23/11/15		CR4139		AGL027					impacts splitting TC-Out contracts into just voyage number without joins.  Adding 2 columns to assist user in analysis.
   </HISTORY>
********************************************************************/

long 						ll_rows, ll_row, ll_tce_row
u_vas_control 			lu_vas_control
s_vessel_voyage_list lstr_vessel_voyage_list[]
integer 					li_year, li_key[], li_control_return, li_vesseltype
string					ls_prefix, ls_contracttype, ls_charterer, ls_vesselfullname
datetime					ldt_voyagestart, ldt_voyageend, ldt_cpdate
decimal {4}				ld_voyagedays, ld_vas_offservicedays, ld_perioddays
decimal {2}				ld_vas_result, ld_period_result, ld_tcday_excl_offservice
string 					ls_vesselname, ls_vesseltype, ls_gradegroup, ls_gradename, ls_loadport, ls_loadarea,  ls_dischargeport, ls_dischargearea, ls_fixuser
decimal					ld_test_calcid
long						ll_test_type, ll_tcout_duration, ll_contractid
boolean					lb_tcout = false




ll_rows = ids_voyages.rowCount()

if ab_estimated then 
	ls_prefix = "est_act_"
else
	ls_prefix = "act_"
end if

/* loop through all voyages */
lu_vas_control = CREATE u_vas_control
for ll_row = 1 to ll_rows
	
	setnull(ldt_cpdate)
	setnull(ll_contractid)
	
	ls_fixuser = ""  // reset value so it is not reused 
	
	lb_tcout = false
	lstr_vessel_voyage_list[1].vessel_nr = ids_voyages .getItemNumber(ll_row, "vessel_nr")
	lstr_vessel_voyage_list[1].voyage_nr = ids_voyages.getItemString(ll_row, "voyage_nr")
	li_year = integer(mid(lstr_vessel_voyage_list[1].voyage_nr,1,2))

	adw_vas_report.reset()
	//commit;
	avpb.position = ll_row
	
	SELECT CAL_CALC_ID, VOYAGE_TYPE, '(' + VESSEL_REF_NR + ') ' + VESSEL_NAME INTO :ld_test_calcid, :ll_test_type, :ls_vesselfullname  FROM VOYAGES, VESSELS 
	WHERE 
	VESSELS.VESSEL_NR = VOYAGES.VESSEL_NR and
	VOYAGES.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr AND VOYAGES.VOYAGE_NR like :lstr_vessel_voyage_list[1].voyage_nr+"%" ;
	
	if ld_test_calcid < 2 and ll_test_type <> 2 then continue   // if voyage not allocated to calculation continue

	li_control_return = lu_vas_control.of_master_control( 10, li_key[], lstr_vessel_voyage_list[], li_year, adw_vas_report)

	if adw_vas_report.rowcount() < 1 then
		of_MessageBox (ls_contracttype + " - Error", "It is not possible to draw a VAS report for below~r~n" &
						+"Vessel and Voyage. Please correct voyage and re-run report~r~n~r~n" &
						+"Vessel:  "+ids_voyages.getItemString(ll_row, "vessel_ref_nr")+"~r~n" &
						+"Voyage:  "+lstr_vessel_voyage_list[1].voyage_nr)
		//adw_report.deleterow(ll_tce_row)
		continue 
	end if
	
	ll_tce_row = adw_report.insertrow(0)
	adw_report.setItem(ll_tce_row, "vessel_nr", ids_voyages.getItemString(ll_row, "vessel_ref_nr"))
	adw_report.setItem(ll_tce_row, "voyage_nr", lstr_vessel_voyage_list[1].voyage_nr)
	// get current voyage started date(CR2609)
	ldt_voyagestart = adw_vas_report.getItemDatetime(1, "voyage_startdate")
	choose case ids_voyages.getItemNumber(ll_row, "contract_type")
		case 1
			ls_contracttype = "SPOT"
		case 2 
			ls_contracttype = "COA Fixed rate"
		case 7 
			ls_contracttype = "COA Market rate"
		case 3 
			ls_contracttype = "CVS Fixed rate"
		case 8 
			ls_contracttype = "CVS Market rate"
		case 5, 99  
			ls_contracttype = "T/C Out"
			
			lb_tcout = true

			if adw_vas_report.rowcount()>0 then
				SELECT NTC_TC_PERIOD.CONTRACT_ID, NTC_TC_CONTRACT.TC_HIRE_CP_DATE  
				INTO :ll_contractid, :ldt_cpdate 
				FROM NTC_TC_PERIOD,   NTC_TC_CONTRACT  
				WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_TC_PERIOD.CONTRACT_ID  and  
					NTC_TC_CONTRACT.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr  AND
					NTC_TC_CONTRACT.TC_HIRE_IN = 0 AND
					NTC_TC_PERIOD.PERIODE_START <=:ldt_voyagestart AND  
					NTC_TC_PERIOD.PERIODE_END > :ldt_voyagestart ;				
			
				
				if ai_tcout_index<>0 then
					//check the duration of the contract
					//ll_tcout_duration
					
					if isnull(ll_contractid) then
						messagebox("Error", "Contract not found!")
						return c#return.Failure
					end if
					
					SELECT datediff( dd , min(NTC_TC_PERIOD.PERIODE_START),  max(NTC_TC_PERIOD.PERIODE_END ) )
					INTO :ll_tcout_duration 
					FROM NTC_TC_PERIOD  
					WHERE NTC_TC_PERIOD.CONTRACT_ID = :ll_contractid    ;
				
					if ai_tcout_index >= 10 and ll_tcout_duration>al_tcout_days then
							ls_contracttype = "T/C Out > " + string(al_tcout_days) + " days"			
					elseif (ai_tcout_index - 10 = 1 or  ai_tcout_index - 10 = -9) and  ll_tcout_duration<=al_tcout_days then
						 ls_contracttype = "T/C Out SPOT"
					else
						adw_report.deleterow(ll_tce_row)
						continue 
					end if
				end if
			
			end if	
		case else
			ls_contracttype = "Unknown"
	end choose
	
	
	adw_report.setItem(ll_tce_row, "contract_type", ls_contracttype )
	ldt_voyagestart = adw_vas_report.getItemDatetime(1, "voyage_startdate")
	adw_report.setItem(ll_tce_row, "voyage_startdate", ldt_voyagestart )
	ldt_voyageend = adw_vas_report.getItemDatetime(1, "voyage_enddate")
	adw_report.setItem(ll_tce_row, "voyage_enddate", ldt_voyageend )
	adw_report.setitem(ll_tce_row, "demurrage", adw_vas_report.getitemnumber(1, ls_prefix+"dem_des"))
	adw_report.setItem(ll_tce_row, "vas_total_days", adw_vas_report.getItemNumber(1, ls_prefix+"days_total_prior_off_idle"))
	ld_vas_offservicedays = adw_vas_report.getItemNumber(1, ls_prefix+"days_off_service")
	adw_report.setItem(ll_tce_row, "vas_offservice_days", ld_vas_offservicedays )
	adw_report.setitem(ll_tce_row, "vas_idle_days", adw_vas_report.getitemnumber(1 ,ls_prefix+"days_idle"))
	/* which figure to use from VAS report */
	if ab_gross_income then
		ld_vas_result = adw_vas_report.getItemNumber(1, ls_prefix+"gross_income")
	else	
		ld_vas_result = adw_vas_report.getItemNumber(1, ls_prefix+"result_before_drc_tc")
	end if
	adw_report.setItem(ll_tce_row, "vas_result", ld_vas_result )
	ld_voyagedays =  (f_datetime2long( ldt_voyageend ) - f_datetime2long( ldt_voyagestart ))/86400	
	adw_report.setItem(ll_tce_row, "voyage_days", ld_voyagedays )
	if abs(ld_voyagedays - ld_vas_offservicedays) < 0.5 then
		messageBox("Divide by Zero", "This voyage length is 0 (zero) days. TC per day may therefore~n~rnot be correct as we in this case set the length to 1.~n~r~n~rVessel: "+ids_voyages.getItemString(ll_row, "vessel_ref_nr")+ "~n~rVoyage:"+ lstr_vessel_voyage_list[1].voyage_nr)
		ld_tcday_excl_offservice = ld_vas_result / 1
	else
		ld_tcday_excl_offservice = ld_vas_result / (ld_voyagedays - ld_vas_offservicedays)
	end if		
	adw_report.setItem(ll_tce_row, "tcday_excl_offservice", ld_tcday_excl_offservice )
	adw_report.setItem(ll_tce_row, "tcout_contract_id", ll_contractid )
	adw_report.setItem(ll_tce_row, "tcout_cpdate", ldt_cpdate )

	/* Get vesselname and type */
	SELECT VESSELS.VESSEL_NAME,   
		VESSELS.CAL_VEST_TYPE_ID,   
		CAL_VEST.CAL_VEST_TYPE_NAME  
	INTO :ls_vesselname,   
		:li_vesseltype,   
		:ls_vesseltype  
	FROM CAL_VEST,   
		VESSELS  
	WHERE VESSELS.CAL_VEST_TYPE_ID = CAL_VEST.CAL_VEST_TYPE_ID  
	AND VESSELS.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr  ;
	//COMMIT;
	adw_report.setItem(ll_tce_row, "vessel_name", ls_vesselname )
	adw_report.setItem(ll_tce_row, "vesseltypeid", li_vesseltype )
	adw_report.setItem(ll_tce_row, "vesseltype", ls_vesseltype )
	
	/* Calculate voyage contribution to period */
	if ldt_voyagestart < idt_periodstart then ldt_voyagestart = idt_periodstart
	if ldt_voyageend > idt_periodend then ldt_voyageend = idt_periodend
	ld_perioddays =  (f_datetime2long( ldt_voyageend ) - f_datetime2long( ldt_voyagestart ))/86400	// only for calc purpose
	ld_period_result = ld_tcday_excl_offservice * ld_perioddays
	adw_report.setItem(ll_tce_row, "period_days", ld_perioddays)
	adw_report.setItem(ll_tce_row, "period_result", ld_period_result )

	/* Get grade/cargo information - grade name of cargo with highest quantity */
	SELECT top 1 CD.GRADE_GROUP,   
		CD.GRADE_NAME,
		CD.PORT_CODE,
		CHART.CHART_N_1
	INTO :ls_gradegroup,   
		:ls_gradename,
		:ls_loadport,
		:ls_charterer
	FROM BOL,   
		CD,
		CHART
	WHERE CD.CARGO_DETAIL_ID = BOL.CARGO_DETAIL_ID  and  
		CD.CHART_NR = CHART.CHART_NR and
	 	BOL.L_D = 1  AND  
	 	CD.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr  AND  
	 	CD.VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr    
	ORDER BY CD.TOTAL_BOL_LOAD_QTY DESC  ;
	if isNull(ls_gradegroup) or ls_gradegroup= "" or sqlca.sqlcode= 100 then ls_gradegroup = "Unknown"
	if isNull(ls_gradename) or ls_gradename = "" or sqlca.sqlcode= 100 then ls_gradename = "Unknown"
	if isNull(ls_charterer) or ls_charterer= "" or sqlca.sqlcode= 100 then ls_charterer = "Unknown"
	if isNull(ls_loadport) or ls_loadport= "" or sqlca.sqlcode= 100 then setNull(ls_loadport)
	
	COMMIT;
	adw_report.setItem(ll_tce_row, "grade_group", ls_gradegroup )
	adw_report.setItem(ll_tce_row, "grade_name", ls_gradename )
	
	/* Select load area */
	if isNull(ls_loadport) or ls_loadport= "" then 
		ls_loadarea = "Unknown"
	else
		SELECT AREA.AREA_NAME  
				INTO :ls_loadarea  
			FROM AREA,   
			AREA_PORTS  
			WHERE AREA_PORTS.AREA_PK = AREA.AREA_PK  and  
				AREA_PORTS.PORT_CODE = :ls_loadport AND  
				AREA_PORTS.PRIMARY_AREA = 1 ;
		if sqlca.sqlcode= 100 then ls_loadarea = "Unknown"
		//COMMIT;
	end if
	adw_report.setItem(ll_tce_row, "load_area",ls_loadarea )
	
	/* Get grade/cargo information - grade name of cargo with highest quantity */
	SELECT top 1 
		CD.PORT_CODE
	INTO :ls_dischargeport
	FROM BOL,   
		CD,
		CHART
	WHERE CD.CARGO_DETAIL_ID = BOL.CARGO_DETAIL_ID  and  
      	CD.CHART_NR = CHART.CHART_NR and
	 	BOL.L_D = 0  AND  
	 	CD.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr  AND  
	 	CD.VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr    
	ORDER BY CD.TOTAL_BOL_LOAD_QTY DESC  ;
	if isNull(ls_dischargeport) or ls_dischargeport= "" or sqlca.sqlcode= 100 then setNull(ls_dischargeport)
	
	
	/* Select discharge area */
	if isNull( ls_dischargeport ) or ls_dischargeport = "" then 
		ls_dischargearea = "Unknown"
	else
		SELECT AREA.AREA_NAME  
			INTO :ls_dischargearea  
		 FROM AREA,   
				AREA_PORTS  
			WHERE AREA_PORTS.AREA_PK = AREA.AREA_PK  and  
				AREA_PORTS.PORT_CODE = :ls_dischargeport AND  
				AREA_PORTS.PRIMARY_AREA = 1 ;
		if sqlca.sqlcode= 100 then ls_dischargearea = "Unknown"
		//COMMIT;
	end if
	adw_report.setItem(ll_tce_row, "discharge_area",  ls_dischargearea )
	
	/* Charterers */
	if lb_tcout then
		
		SELECT CHART.CHART_N_1, NTC_TC_CONTRACT.FIXTURE_USER_ID
		INTO :ls_charterer, :ls_fixuser
		FROM NTC_TC_CONTRACT,
			NTC_TC_PERIOD,
			CHART
		WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_TC_PERIOD.CONTRACT_ID
		AND NTC_TC_CONTRACT.CHART_NR = CHART.CHART_NR
		AND NTC_TC_CONTRACT.TC_HIRE_IN = 0
		AND NTC_TC_CONTRACT.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr
		AND NTC_TC_PERIOD.PERIODE_START <= :ldt_voyagestart
		and NTC_TC_PERIOD.PERIODE_END > :ldt_voyagestart;
		//COMMIT;
	end if
	adw_report.setItem(ll_tce_row, "charterers", ls_charterer)
	//COMMIT;
	
	if lb_tcout=false then
		SELECT CAL_CALCA.CAL_CALC_LAST_EDITED_BY
		INTO :ls_fixuser
		FROM CAL_CALC CAL_CALCA,
			CAL_CALC CAL_CALCB,
			VOYAGES
		  WHERE ( VOYAGES.CAL_CALC_ID = CAL_CALCB.CAL_CALC_ID ) and
			CAL_CALCB.CAL_CALC_FIX_ID = CAL_CALCA.CAL_CALC_FIX_ID and	
			CAL_CALCA.CAL_CALC_STATUS = 4 and
			VOYAGES.VOYAGE_NR = :lstr_vessel_voyage_list[1].voyage_nr  and
			VOYAGES.VESSEL_NR = :lstr_vessel_voyage_list[1].vessel_nr ;
	end if	
	// Whether from TC-Out contract or Calculation
	adw_report.setItem(ll_tce_row, "charterersUser", ls_fixuser)
	
next

DESTROY lu_vas_control
return c#return.Success
end function

private subroutine of_messagebox (string as_title, string as_message);/* If the capture window is open, store the messages there, otherwise show the messsagebox */
if isValid(w_messagebox_capture) then
	w_messagebox_capture.wf_addmessage(as_title, as_message)
else
	messageBox(as_title, as_message)
end if

end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: n_report_spot_contracts
	
	<OBJECT>
		non visual controlling business logic of pulling data for report
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		w_report_spot_contracts
	</ALSO>
    	Date   		Ref    		Author   		Comments
 	06/05/11 	cr#???		AGL      	First Version - moved object into mt framework
  	06/05/11 	cr#2274		AGL      	Changed error message for TC-outs to provide vessel/voyage nr's	
	13/05/11		cr#2424		AGL			Use only 1 method for error capture window.  
	02/08/11    cr#2480     TTY004		Get Demurrage and idle days column for export to xls
	10/07/12    cr#2609     LGX001      Fixed the bug in report of 
													SPOT/Contract vessel earning report when voyage type is tc out
	04/05/14    CR3333	   CCY018      provide same validation window when voyage length < 0.5 days (same with 0 days)
	20/03/15		CR4003		AGL027		fix minor issue with TC-Out fixure user
	31/03/15		CR4012		AGL027		Issue from previous fix when additional particular criteria selected
	05/10/15		CR4139		AGL027		Impacts splitting TC-Out contracts into just voyage number without joins.  Adding 2 columns to assist user in analysis.
********************************************************************/
end subroutine

on n_report_spot_contracts.create
call super::create
end on

on n_report_spot_contracts.destroy
call super::destroy
end on

event constructor;ids_voyages = create mt_n_datastore
ids_voyages.dataObject = "d_sq_tb_spot_voyages"

end event

event destructor;destroy ids_voyages
end event

