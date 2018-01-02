$PBExportHeader$w_bunker_rpt_sm.srw
$PBExportComments$Window for bunker report sharemembers. Let the user enter informations, retrieves the report and print it.
forward
global type w_bunker_rpt_sm from w_bunker_rpt_base
end type
type dw_sharemembers from mt_u_datawindow within w_bunker_rpt_sm
end type
end forward

global type w_bunker_rpt_sm from w_bunker_rpt_base
string title = "Bunker Report Sharemember"
dw_sharemembers dw_sharemembers
end type
global w_bunker_rpt_sm w_bunker_rpt_sm

forward prototypes
public subroutine wf_create_sharemember_report ()
public subroutine wf_filter ()
public subroutine documentation ()
public subroutine wf_settitle (integer ai_type, string as_text)
end prototypes

public subroutine wf_create_sharemember_report ();long ll_row_count, ll_row, ll_new_row, ll_vessel_nr, ll_row_count_sharemembers, ll_row_sharemembers
string ls_voyage_nr, ls_tcowner, ls_snr, ls_vessel_ref_nr
datetime ldt_arr_date
decimal ld_procent, ld_rate
n_ds lds_sharemembers
integer li_hire_in
decimal {1}  ld_time_difference     //time difference between LT and UTC

lds_sharemembers = Create n_ds

lds_sharemembers.dataObject = "d_contract_sharemembers"
lds_sharemembers.setTransObject(SQLCA)

//dw_sharemembers.reset()

ll_row_count = dw_report.RowCount()

st_status.text = "Generating sharemember report rows..."
FOR ll_row = 1 TO ll_row_count
	hpb_1.position 	= ll_row_count + ll_row
	ll_vessel_nr 		= dw_report.GetItemNumber(ll_row, "vessel")
	ls_vessel_ref_nr 	= dw_report.GetItemString(ll_row, "vessel_ref_nr")
	ls_voyage_nr 		= dw_report.GetItemString(ll_row, "voyage")
	ld_rate				= 0
	ls_tcowner			= "NO TC Contract"
	ls_snr				= ""
	li_hire_in			= 0
	setNull( ld_time_difference )

	SELECT min(PORT_ARR_DT) 
	INTO :ldt_arr_date 
	FROM POC WHERE VESSEL_NR=:ll_vessel_nr AND VOYAGE_NR=:ls_voyage_nr;
	
	SELECT LT_TO_UTC_DIFFERENCE 
	INTO :ld_time_difference
	FROM POC WHERE VESSEL_NR=:ll_vessel_nr AND VOYAGE_NR=:ls_voyage_nr and PURPOSE_CODE = "RED";

	if not isnull(ld_time_difference) then 
		ldt_arr_date  = f_long2datetime(f_datetime2long(ldt_arr_date) + ld_time_difference *3600)
	else
		SELECT LT_TO_UTC_DIFFERENCE 
		INTO :ld_time_difference
		FROM POC WHERE VESSEL_NR=:ll_vessel_nr AND VOYAGE_NR=:ls_voyage_nr and PURPOSE_CODE = "DEL";

		if not isnull(ld_time_difference) then 
			ldt_arr_date  = f_long2datetime(f_datetime2long(ldt_arr_date) + ld_time_difference *3600)
		end if
	end if	
	
	
	SELECT isNull(NTC_TC_PERIOD.RATE,0), isNull(TCOWNERS.TCOWNER_N_1,""), TC_HIRE_IN, TCOWNERS.NOM_ACC_NR  
   INTO :ld_rate, :ls_tcowner, :li_hire_in, :ls_snr  
   FROM NTC_TC_CONTRACT, NTC_TC_PERIOD, TCOWNERS  
   WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID and
			TCOWNERS.TCOWNER_NR = NTC_TC_CONTRACT.TCOWNER_NR and
         NTC_TC_CONTRACT.VESSEL_NR = :ll_vessel_nr AND  
         NTC_TC_CONTRACT.TC_HIRE_IN = 1 AND  
         NTC_TC_PERIOD.PERIODE_START <= :ldt_arr_date AND  
         NTC_TC_PERIOD.PERIODE_END > :ldt_arr_date ;

	ll_row_count_sharemembers = lds_sharemembers.Retrieve(ll_vessel_nr, ldt_arr_date)
	
	/* TC-in, share members and rate > 0 -> fordel efter share pct */
	IF ll_row_count_sharemembers > 0 THEN
		IF lds_sharemembers.GetItemNumber(1, "ntc_tc_period_rate") > 0 THEN
			FOR ll_row_sharemembers = 1 TO ll_row_count_sharemembers
				ll_new_row = dw_sharemembers.InsertRow(0)
				ld_procent = lds_sharemembers.GetItemNumber(ll_row_sharemembers, "ntc_share_member_percent_share")
				dw_sharemembers.SetItem(ll_new_row,"vessel_nr", ll_vessel_nr)
				dw_sharemembers.SetItem(ll_new_row,"vessel_ref_nr", ls_vessel_ref_nr)
				dw_sharemembers.SetItem(ll_new_row,"vessel_name_1",dw_report.GetItemString(ll_row, "vessel_name"))  
				dw_sharemembers.SetItem(ll_new_row,"voyage_nr", ls_voyage_nr) 
				dw_sharemembers.SetItem(ll_new_row,"dept_hfo",dw_report.GetItemNumber(ll_row, "dept_hfo")*(ld_procent/100)) 
				dw_sharemembers.SetItem(ll_new_row,"dept_do",dw_report.GetItemNumber(ll_row, "dept_do")*(ld_procent/100))  
				dw_sharemembers.SetItem(ll_new_row,"dept_go",dw_report.GetItemNumber(ll_row, "dept_go")*(ld_procent/100)) 
				dw_sharemembers.SetItem(ll_new_row,"dept_lshfo",dw_report.GetItemNumber(ll_row, "dept_lshfo")*(ld_procent/100)) 
				dw_sharemembers.SetItem(ll_new_row,"value_hfo",dw_report.GetItemNumber(ll_row, "USD_value_hfo")*(ld_procent/100))  
				dw_sharemembers.SetItem(ll_new_row,"value_do",dw_report.GetItemNumber(ll_row, "USD_value_do")*(ld_procent/100))  
				dw_sharemembers.SetItem(ll_new_row,"value_go",dw_report.GetItemNumber(ll_row, "USD_value_go")*(ld_procent/100))
				dw_sharemembers.SetItem(ll_new_row,"value_lshfo",dw_report.GetItemNumber(ll_row, "USD_value_lshfo")*(ld_procent/100))  
				dw_sharemembers.SetItem(ll_new_row,"value_hfo_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_hfo")*(ld_procent/100)) 
				dw_sharemembers.SetItem(ll_new_row,"value_do_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_do")*(ld_procent/100))
				dw_sharemembers.SetItem(ll_new_row,"value_go_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_go")*(ld_procent/100))
				dw_sharemembers.SetItem(ll_new_row,"value_lshfo_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_lshfo")*(ld_procent/100)) 
				dw_sharemembers.SetItem(ll_new_row,"profit_center",dw_report.GetItemString(ll_row, "pcname")) 
				dw_sharemembers.SetItem(ll_new_row,"comments",dw_report.GetItemString(ll_row, "comment")) 
				dw_sharemembers.SetItem(ll_new_row,"sharemember",lds_sharemembers.GetItemString(ll_row_sharemembers, "share_owner"))
				dw_sharemembers.SetItem(ll_new_row,"account_nr",lds_sharemembers.GetItemString(ll_row_sharemembers, "share_owner_snr"))
				dw_sharemembers.SetItem(ll_new_row,"imo_number", dw_report.GetItemNumber(ll_row, "imo_number"))
			NEXT
			CONTINUE
		END IF
	END IF
	
	/* TC-in, rate = 0 -> alt til owner */
	IF li_hire_in = 1 and ld_rate = 0 THEN
		ll_new_row = dw_sharemembers.InsertRow(0)
		dw_sharemembers.SetItem(ll_new_row,"vessel_nr", ll_vessel_nr)
		dw_sharemembers.SetItem(ll_new_row,"vessel_ref_nr", ls_vessel_ref_nr)
		dw_sharemembers.SetItem(ll_new_row,"vessel_name_1",dw_report.GetItemString(ll_row, "vessel_name"))  
		dw_sharemembers.SetItem(ll_new_row,"voyage_nr", ls_voyage_nr) 
		dw_sharemembers.SetItem(ll_new_row,"dept_hfo",dw_report.GetItemNumber(ll_row, "dept_hfo")) 
		dw_sharemembers.SetItem(ll_new_row,"dept_do",dw_report.GetItemNumber(ll_row, "dept_do"))  
		dw_sharemembers.SetItem(ll_new_row,"dept_go",dw_report.GetItemNumber(ll_row, "dept_go")) 
		dw_sharemembers.SetItem(ll_new_row,"dept_lshfo",dw_report.GetItemNumber(ll_row, "dept_lshfo")) 
		dw_sharemembers.SetItem(ll_new_row,"value_hfo",dw_report.GetItemNumber(ll_row, "USD_value_hfo"))  
		dw_sharemembers.SetItem(ll_new_row,"value_do",dw_report.GetItemNumber(ll_row, "USD_value_do"))  
		dw_sharemembers.SetItem(ll_new_row,"value_go",dw_report.GetItemNumber(ll_row, "USD_value_go"))
		dw_sharemembers.SetItem(ll_new_row,"value_lshfo",dw_report.GetItemNumber(ll_row, "USD_value_lshfo"))  
		dw_sharemembers.SetItem(ll_new_row,"value_hfo_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_hfo")) 
		dw_sharemembers.SetItem(ll_new_row,"value_do_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_do"))
		dw_sharemembers.SetItem(ll_new_row,"value_go_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_go"))
		dw_sharemembers.SetItem(ll_new_row,"value_lshfo_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_lshfo")) 
		dw_sharemembers.SetItem(ll_new_row,"profit_center",dw_report.GetItemString(ll_row, "pcname")) 
		dw_sharemembers.SetItem(ll_new_row,"comments",dw_report.GetItemString(ll_row, "comment")) 
		dw_sharemembers.SetItem(ll_new_row,"sharemember",ls_tcowner)
		dw_sharemembers.SetItem(ll_new_row,"account_nr",ls_snr)
		dw_sharemembers.SetItem(ll_new_row,"imo_number", dw_report.GetItemNumber(ll_row, "imo_number"))
	ELSE
		/* TC-out or no share members and rate > 0 -> alt til "APM CPH" */
		ll_new_row = dw_sharemembers.InsertRow(0)
		dw_sharemembers.SetItem(ll_new_row,"vessel_nr", ll_vessel_nr)
		dw_sharemembers.SetItem(ll_new_row,"vessel_ref_nr", ls_vessel_ref_nr)
		dw_sharemembers.SetItem(ll_new_row,"vessel_name_1",dw_report.GetItemString(ll_row, "vessel_name"))  
		dw_sharemembers.SetItem(ll_new_row,"voyage_nr", ls_voyage_nr) 
		dw_sharemembers.SetItem(ll_new_row,"dept_hfo",dw_report.GetItemNumber(ll_row, "dept_hfo")) 
		dw_sharemembers.SetItem(ll_new_row,"dept_do",dw_report.GetItemNumber(ll_row, "dept_do"))  
		dw_sharemembers.SetItem(ll_new_row,"dept_go",dw_report.GetItemNumber(ll_row, "dept_go")) 
		dw_sharemembers.SetItem(ll_new_row,"dept_lshfo",dw_report.GetItemNumber(ll_row, "dept_lshfo")) 
		dw_sharemembers.SetItem(ll_new_row,"value_hfo",dw_report.GetItemNumber(ll_row, "USD_value_hfo"))  
		dw_sharemembers.SetItem(ll_new_row,"value_do",dw_report.GetItemNumber(ll_row, "USD_value_do"))  
		dw_sharemembers.SetItem(ll_new_row,"value_go",dw_report.GetItemNumber(ll_row, "USD_value_go"))
		dw_sharemembers.SetItem(ll_new_row,"value_lshfo",dw_report.GetItemNumber(ll_row, "USD_value_lshfo"))  
		dw_sharemembers.SetItem(ll_new_row,"value_hfo_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_hfo")) 
		dw_sharemembers.SetItem(ll_new_row,"value_do_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_do"))
		dw_sharemembers.SetItem(ll_new_row,"value_go_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_go"))
		dw_sharemembers.SetItem(ll_new_row,"value_lshfo_dkr",dw_report.GetItemNumber(ll_row, "DKK_value_lshfo")) 
		dw_sharemembers.SetItem(ll_new_row,"comments",dw_report.GetItemString(ll_row, "comment")) 
		dw_sharemembers.SetItem(ll_new_row,"profit_center",dw_report.GetItemString(ll_row, "pcname")) 
		dw_sharemembers.SetItem(ll_new_row,"sharemember","APM CPH")
		dw_sharemembers.SetItem(ll_new_row,"account_nr","")
		dw_sharemembers.SetItem(ll_new_row,"imo_number", dw_report.GetItemNumber(ll_row, "imo_number"))
	END IF
NEXT

dw_sharemembers.Sort()
dw_sharemembers.GroupCalc()

DESTROY lds_sharemembers
end subroutine

public subroutine wf_filter ();string ls_filter

if cbx_exclude.checked then
	ls_filter = "NOT (dept_hfo=0 and dept_go=0 and dept_do=0 and dept_lshfo=0)"
else
	ls_filter = ""
end if

dw_sharemembers.setFilter(ls_filter)
dw_sharemembers.filter()
dw_sharemembers.groupcalc()

if dw_sharemembers.rowcount() > 0 then
	cb_saveas.enabled = true
	cb_print.enabled = true
else
	cb_saveas.enabled = false
	cb_print.enabled = false
end if
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_bunker_rpt_sm
	
	<OBJECT>
		Decendent object of w_bunker_base a member of report group for Bunker Stock.  
	</OBJECT>
  	<DESC>
		Standard report with Sharemember data concerned with Bunker Stock
	</DESC>
   	<USAGE>
		Pulled from menu item "Reports>Bunker Report>Bunker Report Sharemember"
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		24/05/12 	cr#2777	AGL      		First Version, copy of w_bunker_report_sharemember & w_bunker_report
		20/12/16		CR2879	CCY018		Adjust UI
********************************************************************/
end subroutine

public subroutine wf_settitle (integer ai_type, string as_text);/********************************************************************
   wf_settitle
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_type
		as_text
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/12/16		CR2879		CCY018		First Version
   </HISTORY>
********************************************************************/

if ai_type = 1 then
	dw_sharemembers.object.t_header.text = as_text
end if
end subroutine

on w_bunker_rpt_sm.create
int iCurrent
call super::create
this.dw_sharemembers=create dw_sharemembers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_sharemembers
end on

on w_bunker_rpt_sm.destroy
call super::destroy
destroy(this.dw_sharemembers)
end on

type st_hidemenubar from w_bunker_rpt_base`st_hidemenubar within w_bunker_rpt_sm
end type

type cbx_excludetcout from w_bunker_rpt_base`cbx_excludetcout within w_bunker_rpt_sm
boolean visible = false
integer taborder = 0
end type

type cbx_exclude from w_bunker_rpt_base`cbx_exclude within w_bunker_rpt_sm
end type

type st_status from w_bunker_rpt_base`st_status within w_bunker_rpt_sm
end type

type hpb_1 from w_bunker_rpt_base`hpb_1 within w_bunker_rpt_sm
end type

type cb_saveas from w_bunker_rpt_base`cb_saveas within w_bunker_rpt_sm
end type

event cb_saveas::clicked;n_dataexport lnv_exp
	
if dw_sharemembers.rowcount() > 0 then
	dw_saveas.object.data.primary = dw_sharemembers.object.data.primary
	lnv_exp.of_export(dw_saveas)
	dw_saveas.reset()
end if
end event

type st_1 from w_bunker_rpt_base`st_1 within w_bunker_rpt_sm
end type

type dw_date from w_bunker_rpt_base`dw_date within w_bunker_rpt_sm
end type

type cb_print from w_bunker_rpt_base`cb_print within w_bunker_rpt_sm
end type

event cb_print::clicked;dw_sharemembers.print(true)
end event

type cb_retrieve from w_bunker_rpt_base`cb_retrieve within w_bunker_rpt_sm
end type

event cb_retrieve::clicked;dw_imolist.visible = false
setpointer(HourGlass!)
dw_report.reset()
dw_sharemembers.reset()
wf_retrieve(parent.classname())

if dw_report.rowcount() > 0 then
	wf_create_sharemember_report( )
	wf_filter( )
	st_status.text = "Report generated..."
else
	cb_saveas.enabled = false
	cb_print.enabled = false
end if

setpointer(Arrow!)



end event

type dw_finresp from w_bunker_rpt_base`dw_finresp within w_bunker_rpt_sm
end type

type dw_saveas from w_bunker_rpt_base`dw_saveas within w_bunker_rpt_sm
string dataobject = "d_ex_tb_bunker_rpt_sm_saveas"
end type

type dw_imolist from w_bunker_rpt_base`dw_imolist within w_bunker_rpt_sm
end type

type cbx_selectall_pc from w_bunker_rpt_base`cbx_selectall_pc within w_bunker_rpt_sm
end type

type gb_profitcenter from w_bunker_rpt_base`gb_profitcenter within w_bunker_rpt_sm
end type

type dw_pc from w_bunker_rpt_base`dw_pc within w_bunker_rpt_sm
end type

type gb_criteria from w_bunker_rpt_base`gb_criteria within w_bunker_rpt_sm
end type

type st_3 from w_bunker_rpt_base`st_3 within w_bunker_rpt_sm
end type

type rb_finresp from w_bunker_rpt_base`rb_finresp within w_bunker_rpt_sm
end type

type rb_vessel from w_bunker_rpt_base`rb_vessel within w_bunker_rpt_sm
end type

type sle_vessels from w_bunker_rpt_base`sle_vessels within w_bunker_rpt_sm
end type

type cb_sel_vessel from w_bunker_rpt_base`cb_sel_vessel within w_bunker_rpt_sm
end type

type dw_info from w_bunker_rpt_base`dw_info within w_bunker_rpt_sm
end type

type dw_report from w_bunker_rpt_base`dw_report within w_bunker_rpt_sm
boolean visible = false
integer width = 786
integer height = 556
integer taborder = 0
end type

type dw_sharemembers from mt_u_datawindow within w_bunker_rpt_sm
integer x = 27
integer y = 636
integer width = 4544
integer height = 1704
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_ex_tb_bunker_rpt_sm"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

