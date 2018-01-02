$PBExportHeader$w_cargo.srw
$PBExportComments$This window lets the user operate with cargo data.
forward
global type w_cargo from w_vessel_basewindow
end type
type dw_cargo_list from uo_datawindow within w_cargo
end type
type cb_cancel_bol from mt_u_commandbutton within w_cargo
end type
type dw_bol_total_load from uo_datawindow within w_cargo
end type
type dw_bol_total_disch from uo_datawindow within w_cargo
end type
type cb_update_cargo from mt_u_commandbutton within w_cargo
end type
type cb_new_bol from mt_u_commandbutton within w_cargo
end type
type cb_update_bol from mt_u_commandbutton within w_cargo
end type
type cb_new_agent from mt_u_commandbutton within w_cargo
end type
type dw_poc_list_for_cargo from uo_datawindow within w_cargo
end type
type cb_cancel_cargo from mt_u_commandbutton within w_cargo
end type
type cb_delete_charter from mt_u_commandbutton within w_cargo
end type
type gb_1 from groupbox within w_cargo
end type
type cb_refresh from mt_u_commandbutton within w_cargo
end type
type gb_3 from groupbox within w_cargo
end type
type cb_delete_bol from mt_u_commandbutton within w_cargo
end type
type st_background from u_topbar_background within w_cargo
end type
type cb_new_cargo from mt_u_commandbutton within w_cargo
end type
type cb_delete_cargo from mt_u_commandbutton within w_cargo
end type
type dw_cargo_detail_list from u_datagrid within w_cargo
end type
type cb_update_charter from mt_u_commandbutton within w_cargo
end type
type cb_cancel_charter from mt_u_commandbutton within w_cargo
end type
type gb_2 from groupbox within w_cargo
end type
type dw_bol from uo_datawindow within w_cargo
end type
type gb_4 from groupbox within w_cargo
end type
type dw_pctc_rob from u_datagrid within w_cargo
end type
end forward

global type w_cargo from w_vessel_basewindow
integer x = 9
integer y = 124
integer width = 4599
integer height = 2360
string title = "Cargo"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "images\CARGO.ICO"
boolean ib_setdefaultbackgroundcolor = true
event ue_refresh_totals pbm_custom72
dw_cargo_list dw_cargo_list
cb_cancel_bol cb_cancel_bol
dw_bol_total_load dw_bol_total_load
dw_bol_total_disch dw_bol_total_disch
cb_update_cargo cb_update_cargo
cb_new_bol cb_new_bol
cb_update_bol cb_update_bol
cb_new_agent cb_new_agent
dw_poc_list_for_cargo dw_poc_list_for_cargo
cb_cancel_cargo cb_cancel_cargo
cb_delete_charter cb_delete_charter
gb_1 gb_1
cb_refresh cb_refresh
gb_3 gb_3
cb_delete_bol cb_delete_bol
st_background st_background
cb_new_cargo cb_new_cargo
cb_delete_cargo cb_delete_cargo
dw_cargo_detail_list dw_cargo_detail_list
cb_update_charter cb_update_charter
cb_cancel_charter cb_cancel_charter
gb_2 gb_2
dw_bol dw_bol
gb_4 gb_4
dw_pctc_rob dw_pctc_rob
end type
global w_cargo w_cargo

type variables

string is_voyage_nr
integer	ii_profitcenter
string is_purpose_code
boolean   ib_pc_mtbe_mandatory, ib_pc_bio_mandatory, ib_pc_dye_marked_mandatory 
boolean ib_lockwindow
boolean ib_validate_cargo_temp
decimal {2} id_temp_difference
boolean ib_accepttext

integer ii_pre_vesselnr
mt_u_datawindow idw_focus

n_messagebox inv_messagebox

private u_dddw_search inv_dddw_search_agent, inv_dddw_search_chart, inv_dddw_search_grade
private u_dddw_search inv_dddw_search_load, inv_dddw_search_disch, inv_dddw_search_bol, inv_dddw_search_ld
private mt_n_datastore ids_itin_proceed
end variables

forward prototypes
public subroutine set_counter ()
public subroutine documentation ()
public subroutine wf_setcargocolumns ()
public subroutine wf_seteditmode (boolean ab_editmode, ref datawindow adw)
private function integer wf_checkdatamodified ()
public subroutine wf_refreshchartdddw (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn, string as_purpose_code, long al_cal_calc_id, integer ai_voyage_type)
public subroutine registercolumns ()
public subroutine wf_showcptext ()
public subroutine wf_showpctcdw (integer xpos, integer ypos)
public subroutine wf_getcontractinfo (integer ai_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn, ref integer ai_chartnr, ref string as_cptext)
public subroutine wf_get_newbuttonstatus (ref boolean ab_newchart, ref boolean ab_newcargo, ref boolean ab_newbol, boolean ab_editmode, string as_target)
public subroutine wf_get_deletebuttonstatus (ref boolean ab_deletechart, ref boolean ab_deletecargo, ref boolean ab_deletebol, boolean ab_editmode, string as_target)
end prototypes

event ue_refresh_totals;string ls_voyage_nr
long ll_vessel_nr
Decimal {3} ld_load, ld_disch, ld_bal
Integer li_load_count, li_disch_count

dw_bol_total_load.setredraw(false)
dw_bol_total_disch.setredraw(false)
ll_vessel_nr = uo_global.getvessel_nr()
ls_voyage_nr = dw_poc_list_for_cargo.getItemstring(dw_poc_list_for_cargo.GetRow(), "poc_voyage_nr")
is_voyage_nr = ls_voyage_nr
li_load_count = dw_bol_total_load.retrieve(ll_vessel_nr, ls_voyage_nr,1)
li_disch_count = dw_bol_total_disch.retrieve(ll_vessel_nr, ls_voyage_nr,0)

if li_load_count > 0 then ld_load = dw_bol_total_load.getitemnumber(1,"total_quantity")
if li_disch_count > 0 then ld_disch = dw_bol_total_disch.getitemnumber(1,"total_quantity")
ld_bal = ld_load - ld_disch
dw_bol_total_disch.SetItem(1, "rest_quantity", ld_bal)
dw_bol_total_load.setredraw(true)
dw_bol_total_disch.setredraw(true)

end event

public subroutine set_counter ();
end subroutine

public subroutine documentation ();/********************************************************************
   w_cargo
   <OBJECT> mainly use display</OBJECT>
   <USAGE>display agent,cargo,cd,all the systems bill of laidings  ,and  update agent,cd,bol	</USAGE>
   <ALSO>datawindow  dw_poc_list_for_cargo,dw_cargo_list,dw_cargo_detail_list,dw_bol
	dataobject  dw_poc_list_for_cargo,dw_cargo_list,dw_cargo_detail_list,dw_bol
	button   cb_new_agent,cb_new_cargo
	</ALSO>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		2011-06-02		CR2407		RJH022		change the DataWindow display style to Grid for UI update
		2011-07-28		2055  		CONASW		Changed validation code in wf_validatecargotemp()
		2011-09-05		D3-1  		RJH022		add update and cancel button,auto adjust window size
		2012-02-10		M5-6  		WWG004		Add a validation to B/L date.
		2013-02-18		CR3157		LGX001		Fix a bug when deleting the cargo detail
		2013-02-19		CR3148		LGX001		Fix a bug when change the chart in the CP while this window is opening
		12/09/14  		CR3773		XSZ004		Change icon absolute path to reference path
		2014-12-19		CR3789		LHG008		Fix the bug for grade selection incorrect if the grade have different grade group
		21/09/16			CR4224		CCY018		Adjust UI
		17/03/17			CR4572		XSZ004		Apply latest standard for dddw column
		01/12/17			CR4577		CCY018		Change the text of two validation error messages
	</HISTORY>
********************************************************************/





end subroutine

public subroutine wf_setcargocolumns ();//********************************************************************
//   wf_setcargocolumns
//   <DESC> It is to control "MTBE BIO DYE" column's visibility based on the setting in profit center. </DESC>
//   <RETURN>	(None):
//   <ACCESS> public </ACCESS>
//   <ARGS>
//   </ARGS>
//   <USAGE>
//		cb_refresh.clicked()
//		dw_poc_list_for_cargo.clicked()
//   </USAGE>
//   <HISTORY>
//   	Date           CR-Ref         Author             Comments
//   	2011-09-15     D3-1           RJH022        First Version
//		05/09/16		   CR4224       CCY018        UX standards
//   </HISTORY>
//********************************************************************/

integer li_pcnr
constant int  li_startposx = 37
constant int  li_windowmargin = 74
n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")

dw_cargo_detail_list.setredraw(false) 
dw_cargo_detail_list.dataobject = dw_cargo_detail_list.dataobject
dw_cargo_detail_list.settransobject(sqlca)

dw_cargo_detail_list.of_ignoreredraw( true )
dw_cargo_detail_list.of_setallcolumnsresizable(true)
dw_cargo_detail_list.of_setcolumnorder()
dw_cargo_detail_list.of_setallcolumnsresizable(false) 

if ii_vessel_nr > 0 then
	li_pcnr = uo_vesselselect.of_getvesselpc( )
else
	/* use default users pc */
	li_pcnr = uo_global.get_profitcenter_no( )
end if	

SELECT VALIDATE_CARGO_TEMP, NOTIFY_ON_TEMP_DIFF, PC_CD_MTBE_MANDATORY, PC_CD_BIO_MANDATORY, PC_CD_DYE_MANDATORY
INTO :ib_validate_cargo_temp, :id_temp_difference, :ib_pc_mtbe_mandatory, :ib_pc_bio_mandatory, :ib_pc_dye_marked_mandatory
FROM PROFIT_C
WHERE PC_NR = :li_pcnr;

// If MTBE/ETBE option is disabled in profit center setting, the MTBE/ETBE column in Cargo detail will not be shown. Otherwise, it will be shown.
if ib_pc_mtbe_mandatory and (is_purpose_code ='L' or is_purpose_code='L/D') then
	dw_cargo_detail_list.modify("cd_mtbe_etbe_status_t.visible = '1'")
else
	dw_cargo_detail_list.modify("cd_mtbe_etbe_status.visible = '0'") 
	dw_cargo_detail_list.modify("cd_mtbe_etbe_status_t.visible = '0'")
	dw_cargo_detail_list.modify("cd_mtbe_etbe.visible = '0'")
	dw_cargo_detail_list.modify("computer_percent_mtbe.visible = '0'")
end if

// If Bio option is disabled in profit center setting, the Bio column in Cargo detail will not be shown. Otherwise, it will be shown.
if ib_pc_bio_mandatory and (is_purpose_code ='L' or is_purpose_code='L/D') then
	dw_cargo_detail_list.modify("cd_bio_status_t.visible = '1'")
else
	dw_cargo_detail_list.modify("cd_bio_status.visible = '0'")
	dw_cargo_detail_list.modify("cd_bio.visible = '0'")
 	dw_cargo_detail_list.modify("cd_bio_status_t.visible = '0'")
	dw_cargo_detail_list.modify("computer_percent_bio.visible = '0'")
end if

// If DYE/Marked option is disabled in profit center setting, the DYE/Marked column in Cargo detail will not be shown. Otherwise, it will be shown.
if ib_pc_dye_marked_mandatory = false or is_purpose_code ='D' then
	dw_cargo_detail_list.modify("cd_dye_marked.visible = '0'")
end if

dw_cargo_detail_list.modify("datawindow.processing = '0'")
dw_cargo_detail_list.modify("cd_cal_caio_id.width = '741~tlong(describe(~"cargo_desc.width~"))' cd_cal_caio_id.x = '183~tlong(describe(~"cargo_desc.x~"))'")
dw_cargo_detail_list.modify("load_cargo_detail_id.width = '741~tlong(describe(~"cargo_desc.width~"))' load_cargo_detail_id.x = '183~tlong(describe(~"cargo_desc.x~"))'")
 
dw_cargo_detail_list.modify("cd_cal_caio_id.visible = '0~tif(currentRow() = getrow() and isRowNew() and l_d=~"L~", 1, 0)'")
dw_cargo_detail_list.modify("load_cargo_detail_id.visible = '0~tif(currentRow() = getrow() and isRowNew() and l_d = ~"D~", 1, 0)'")
dw_cargo_detail_list.modify("datawindow.processing = '1'")

lnv_style.of_dwlistformater(dw_cargo_detail_list, false)
lnv_style.of_autoadjustdddwwidth(dw_cargo_detail_list, "grade_property")

//if ib_pc_dye_marked_mandatory = true and ib_pc_bio_mandatory = true and ib_pc_mtbe_mandatory = true and (is_purpose_code ='L' or is_purpose_code ='L/D') then
//	dw_cargo_detail_list.width = gb_1.x + gb_1.width - li_startposx - li_windowmargin
//else
//	dw_cargo_detail_list.width = cb_cancel_charter.x + cb_cancel_charter.width - dw_cargo_detail_list.x // li_startposx - li_windowmargin
//end if
dw_cargo_detail_list.of_ignoreredraw( false )
dw_cargo_detail_list.setredraw(true)

////End modified by RJH022 on 2011-08-30

end subroutine

public subroutine wf_seteditmode (boolean ab_editmode, ref datawindow adw);/********************************************************************
   wf_seteditmode
   <DESC>If MTBE/BIO/DYE column or bill of landing is modified, all the objects in the window will be disable except Update and Cancel button. </DESC>
   <RETURN>	(None):      
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_editmode true unlock objects, false lock objects
		adw
   </ARGS>
   <USAGE>when user modify cargo detail or bol ,it call this function lock some of objects</USAGE>
   <HISTORY>
   	Date          CR-Ref          Author             Comments
   	2011-09-09    D3-1            RJH022        First Version
	05/09/16		  CR4224       CCY018         UX standards
   </HISTORY>
********************************************************************/

long ll_chart_row, ll_cargo_row, ll_bol_row, ll_findrow, ll_rowcount
long ll_cargo_detail_id, ll_agent, ll_cerp_id
integer li_chart
boolean lb_newchart, lb_newcargo, lb_newbol

if uo_global.ii_access_level = c#usergroup.#EXTERNAL_APM then return

wf_get_newbuttonstatus(lb_newchart, lb_newcargo, lb_newbol, ab_editmode, classname(adw))

if not ab_editmode then
	cb_refresh.enabled = ab_editmode
	uo_vesselselect.enabled = ab_editmode
//	dw_poc_list_for_cargo.enabled = ab_editmode
//	dw_cargo_list.enabled = ab_editmode
//	dw_cargo_detail_list.enabled = ab_editmode
//	dw_bol.enabled = ab_editmode
	cb_new_agent.enabled = ab_editmode
	cb_new_cargo.enabled = ab_editmode
	cb_new_bol.enabled = ab_editmode
	cb_update_charter.enabled = ab_editmode
	cb_update_cargo.enabled = ab_editmode
	cb_update_bol.enabled = ab_editmode
	cb_delete_charter.enabled = ab_editmode
	cb_delete_cargo.enabled = ab_editmode
	cb_delete_bol.enabled = ab_editmode
	cb_cancel_charter.enabled = ab_editmode
	cb_cancel_cargo.enabled = ab_editmode
	cb_cancel_bol.enabled = ab_editmode
	
	if classname(adw) ='dw_bol' then
		cb_new_bol.enabled = lb_newbol
		cb_update_bol.enabled = not ab_editmode
		cb_cancel_bol.enabled = not ab_editmode
		cb_delete_bol.enabled = dw_bol.getselectedrow(0) > 0
		
		dw_poc_list_for_cargo.enabled = ab_editmode
		dw_cargo_list.enabled = ab_editmode
		dw_cargo_detail_list.enabled = ab_editmode
		dw_bol.enabled = true
	elseif classname(adw) ='dw_cargo_detail_list' then
		cb_new_cargo.enabled = lb_newcargo
		cb_update_cargo.enabled = not ab_editmode
		cb_cancel_cargo.enabled = not ab_editmode
		cb_delete_cargo.enabled = dw_cargo_detail_list.getselectedrow(0) > 0
		dw_cargo_detail_list.enabled = true
		
		dw_poc_list_for_cargo.enabled = ab_editmode
		dw_cargo_list.enabled = ab_editmode
		dw_bol.enabled = ab_editmode
	elseif classname(adw) ='dw_cargo_list' then
		cb_new_agent.enabled = lb_newchart
		cb_update_charter.enabled = not ab_editmode
		cb_cancel_charter.enabled = not ab_editmode
		cb_delete_charter.enabled =  dw_cargo_list.getselectedrow(0) > 0
		dw_cargo_list.enabled = true
		
		dw_poc_list_for_cargo.enabled = ab_editmode
		dw_cargo_detail_list.enabled = ab_editmode
		dw_bol.enabled = ab_editmode
	elseif classname(adw) ='dw_poc_list_for_cargo' then
		
	end if
end if

if ab_editmode then
	cb_refresh.enabled = ab_editmode
	uo_vesselselect.enabled = ab_editmode
	dw_poc_list_for_cargo.enabled = ab_editmode
	dw_cargo_list.enabled = ab_editmode
	dw_cargo_detail_list.enabled = ab_editmode
	dw_bol.enabled = ab_editmode
	cb_new_agent.enabled = lb_newchart
	cb_new_cargo.enabled = lb_newcargo
	cb_new_bol.enabled = lb_newbol
	cb_update_charter.enabled = false
	cb_update_cargo.enabled = false
	cb_update_bol.enabled = false
	cb_cancel_charter.enabled = false
	cb_cancel_cargo.enabled = false
	cb_cancel_bol.enabled = false
	
	ll_chart_row = dw_cargo_list.getselectedrow(0)
	ll_cargo_row = dw_cargo_detail_list.getselectedrow(0)
	ll_bol_row = dw_bol.getselectedrow(0) 
	
	ll_rowcount = dw_bol.rowcount()
//	if ll_rowcount > 0 and ll_cargo_row > 0 then
//		ll_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_cargo_row, "cargo_detail_id")
//		ll_findrow = dw_bol.find("cargo_detail_id = " + string(ll_cargo_detail_id), 1, ll_rowcount)
//		if ll_findrow = 0 then
//			dw_cargo_detail_list.selectrow( 0, false)
//		end if
//	end if
	
	ll_rowcount = dw_cargo_detail_list.rowcount()
//	if ll_rowcount > 0 and ll_chart_row > 0 then
//		ll_cerp_id = dw_cargo_list.getitemnumber(ll_chart_row, "cargo_cal_cerp_id")
//		ll_agent = dw_cargo_list.getitemnumber(ll_chart_row, "agent_nr")
//		li_chart = dw_cargo_list.getitemnumber(ll_chart_row, "chart_nr")
//		ll_findrow = dw_cargo_detail_list.find("chart_nr = " + string(li_chart) + " and cd_cal_cerp_id = " + string(ll_cerp_id) + " and agent_nr = " + string(ll_agent), 1, ll_rowcount)
//		if ll_findrow = 0 then
//			dw_cargo_list.selectrow(0, false)
//		end if
//	end if
	
	cb_delete_bol.enabled = dw_bol.getselectedrow(0) > 0 
	cb_delete_cargo.enabled = dw_cargo_detail_list.getselectedrow(0) > 0
	cb_delete_charter.enabled = dw_cargo_list.getselectedrow(0) > 0
end if

ib_lockwindow = not ab_editmode
end subroutine

private function integer wf_checkdatamodified ();/********************************************************************
   wf_checkdatamodified
   <DESC>If user try close the window, and any field in Cargo or Bill of Lading is modified, a message will pop up to ask user to save before close.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref          Author             Comments
   	2011-09-23 D3-1            RJH022             First Version
	05/09/16		CR4224       CCY018        	 UX standards
   </HISTORY>
********************************************************************/
 
 integer li_rtn
 
 li_rtn = 0
 
 dw_cargo_list.accepttext( )
 if dw_cargo_list.modifiedcount( ) > 0 then
	li_rtn = messagebox(inv_messagebox.is_TYPE_UNSAVED_DATA, "You have modified Charterer list data.~r~n~r~nWould you like to save before continuing?", Exclamation!, YesNoCancel!, 1) 
	if li_rtn = 1 then
		if cb_update_charter.event clicked() = c#return.Failure then return 3
	end if
 end if
 
dw_cargo_detail_list.acceptText()
if dw_cargo_detail_list.ModifiedCount() > 0 then
	li_rtn = messagebox(inv_messagebox.is_TYPE_UNSAVED_DATA, "You have modified Cargo Grade list data.~r~n~r~nWould you like to save before continuing?", Exclamation!, YesNoCancel!, 1) 
	if li_rtn = 1 then
		if cb_update_cargo.event clicked() = c#return.Failure then return 3
	end if
end if

dw_bol.acceptText()
if dw_bol.ModifiedCount() > 0 THEN
	li_rtn = messagebox(inv_messagebox.is_TYPE_UNSAVED_DATA, "You have modified Bill of lading data.~r~n~r~nWould you like to save before continuing?", Exclamation!, YesNoCancel!, 1) 
	if li_rtn = 1 then
     	if cb_update_bol.event clicked() = c#return.Failure then return 3
	end if
end if

return li_rtn
end function

public subroutine wf_refreshchartdddw (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn, string as_purpose_code, long al_cal_calc_id, integer ai_voyage_type);/********************************************************************
   wf_refreshchartdddw
   <DESC>		</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	05/09/16		CR4224            CCY018        First Version
   </HISTORY>
********************************************************************/

integer li_char_nr
long ll_row, ll_caioid_array[]
string ls_filter, ls_sql_string, ls_cp_text
datetime ldt_port_arrival_datetime
datawindowchild ldwc_chart

ll_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_row < 1 then return

if dw_cargo_list.getchild("chart_nr", ldwc_chart) <> 1 then return
ldwc_chart.settransobject( sqlca)

if ai_voyage_type = 2 then
	wf_getcontractinfo(ai_vessel_nr, as_voyage_nr, as_port_code, ai_pcn, li_char_nr, ls_cp_text)

	if not isnull(li_char_nr) and li_char_nr > 0 then
		ls_sql_string = ' SELECT DISTINCT CHART.CHART_SN,    CHART.CHART_N_1,   ' + &
						'"'	+	ls_cp_text + '",    CHART.CHART_NR,    ' + &
						'	         1   ' + &
						'	    FROM    CHART   ' + &
						'	WHERE CHART.CHART_NR = ' + string(li_char_nr) + &
						'		ORDER BY CHART.CHART_SN ASC   '
		
		ldwc_chart.modify("DataWindow.Table.Select='" + ls_sql_string + "'")
		ldwc_chart.retrieve(ll_caioid_array)
	end if
else
	if al_cal_calc_id = 1 then
		ls_sql_string = ' SELECT DISTINCT CHART.CHART_SN,    CHART.CHART_N_1,   ' + &
						'		"No CP",    CHART.CHART_NR,    ' + &
						'	         1   ' + &
						'	    FROM    CHART   ' + &
						'		ORDER BY CHART.CHART_SN ASC   '
						
		ldwc_chart.modify("DataWindow.Table.Select='" + ls_sql_string + "'")
		ldwc_chart.retrieve(ll_caioid_array)
	else
		ls_filter = "port_code = '" + as_port_code + "' and pcn = " + string(ai_pcn)
		ids_itin_proceed.setfilter(ls_filter)
		ids_itin_proceed.filter()
		if ids_itin_proceed.rowcount( ) > 0 then
			ll_caioid_array = ids_itin_proceed.object.cal_caio_id.primary.current
		end if
		
		ls_sql_string = ' SELECT DISTINCT CHART.CHART_SN,' + &
         					' CHART.CHART_N_1,   CAL_CERP.CAL_CERP_DESCRIPTION,' + &  
         					' CHART.CHART_NR,   CAL_CERP.CAL_CERP_ID '+ &
		 					' FROM  CAL_CARG,   CAL_CERP,   CHART,   CAL_CAIO ' + &
							' WHERE ( CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID ) and  ' + &
							' ( CHART.CHART_NR = CAL_CERP.CHART_NR ) and  ' + &
							' ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) and  ' + &
							' ( CAL_CAIO.CAL_CAIO_ID IN ( :aan_caio_id ) )  ' + & 
							' ORDER BY CHART.CHART_SN ASC '  

		ldwc_chart.modify("DataWindow.Table.Select='" + ls_sql_string + "'")
		
		if upperbound(ll_caioid_array) > 0 then
			ldwc_chart.retrieve(ll_caioid_array)
		end if
	end if
	
end if



end subroutine

public subroutine registercolumns ();
end subroutine

public subroutine wf_showcptext ();/********************************************************************
   wf_showcptext
   <DESC>show tc-out cp text</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_voyage_type, li_pcn, li_chartnr
long ll_port_row, ll_row
string ls_voyage_nr, ls_port_code, ls_cp_text
datetime ldt_port_arrival_datetime

ll_port_row = dw_poc_list_for_cargo.getrow()
if ll_port_row < 1 then return
if dw_cargo_list.rowcount() < 1 then return

ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")

SELECT VOYAGE_TYPE 
INTO :li_voyage_type
FROM VOYAGES
WHERE VESSEL_NR = :ii_vessel_nr
AND VOYAGE_NR = :ls_voyage_nr;

if li_voyage_type <> 2 then return

wf_getcontractinfo(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, li_chartnr, ls_cp_text)

for ll_row = 1 to dw_cargo_list.rowcount()
	dw_cargo_list.setitem(ll_row, "cal_cerp_description", ls_cp_text)
	dw_cargo_list.setitemstatus(ll_row, "cal_cerp_description", primary!, notmodified!)
next


end subroutine

public subroutine wf_showpctcdw (integer xpos, integer ypos);/********************************************************************
   wf_showpctcdw
   <DESC>	Description	</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/09/16 	CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_dw_width, ll_dw_height, ll_dw_x, ll_dw_y

if ii_profitcenter <> 3 then return
if dw_pctc_rob.visible then return

ll_dw_width = dw_pctc_rob.width
ll_dw_height = dw_pctc_rob.height

ll_dw_x =gb_1.x - ll_dw_width - 10
ll_dw_y =  dw_bol_total_disch.y

dw_pctc_rob.move(ll_dw_x , ll_dw_y)
dw_pctc_rob.retrieve(ii_vessel_nr)
dw_pctc_rob.visible = true
end subroutine

public subroutine wf_getcontractinfo (integer ai_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn, ref integer ai_chartnr, ref string as_cptext);/********************************************************************
   wf_getcontractinfo
   <DESC>	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vesselnr
		as_voyagenr
		as_portcode
		ai_pcn
		al_contractid
		as_cptext
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19/10/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

datetime ldt_port_arrival_datetime

SELECT PORT_ARR_DT
INTO :ldt_port_arrival_datetime
FROM POC
WHERE 	VESSEL_NR = :ai_vesselnr
AND	VOYAGE_NR = :as_voyagenr
AND	PORT_CODE = :as_portcode
AND PCN = :ai_pcn;
			
/* Get charterer nr for tc hire that has port arrival date in tc hires start and end date */
SELECT NTC_TC_CONTRACT.CHART_NR, NTC_TC_CONTRACT.TC_HIRE_CP_TEXT
INTO  :ai_chartnr, :as_cptext
FROM NTC_TC_CONTRACT,   
		NTC_TC_PERIOD  
WHERE  NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID   
AND	NTC_TC_CONTRACT.VESSEL_NR = :ai_vesselnr
AND	NTC_TC_CONTRACT.TC_HIRE_IN = 0   
AND	NTC_TC_PERIOD.PERIODE_START <= :ldt_port_arrival_datetime   
AND	NTC_TC_PERIOD.PERIODE_END > :ldt_port_arrival_datetime;

if isnull(as_cptext) then as_cptext = ''

end subroutine

public subroutine wf_get_newbuttonstatus (ref boolean ab_newchart, ref boolean ab_newcargo, ref boolean ab_newbol, boolean ab_editmode, string as_target);/********************************************************************
   wf_get_newbuttonstatus
   <DESC></DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_newchart
		ab_newcargo
		ab_newbol
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19/10/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_vessel_nr, li_pcn, li_voyage_type, li_chart_nr, li_port_order
long ll_portrow, ll_chartrow, ll_cargorow, ll_cal_calc_id, ll_index, ll_count, ll_caioid_array[]
long ll_cerp_id, ll_agent_nr, ll_load_cargo_detail_id
string ls_voyage_nr, ls_port_code, ls_purpose_code, ls_cptext, ls_filter, ls_ld
datetime ldt_port_arrival_datetime
mt_n_datastore lds_ds

ab_newchart = false
ab_newcargo = false
ab_newbol = false
	
//cb_new_agent
ll_portrow = dw_poc_list_for_cargo.getselectedrow(0)
if ll_portrow <= 0 then return
if not isvalid(ids_itin_proceed) then return

lds_ds = create mt_n_datastore

li_vessel_nr = dw_poc_list_for_cargo.getitemnumber(ll_portrow, "poc_vessel_nr")
ls_voyage_nr = dw_poc_list_for_cargo.getItemstring(ll_portrow, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_portrow, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_portrow, "poc_pcn")
ls_purpose_code = dw_poc_list_for_cargo.getitemstring(ll_portrow, "poc_purpose_code")
ll_cal_calc_id = dw_poc_list_for_cargo.getitemnumber(ll_portrow, "voyages_cal_calc_id")

ls_filter = "port_code = '" + ls_port_code + "' and pcn = " + string(li_pcn)
ids_itin_proceed.setfilter(ls_filter)
ids_itin_proceed.filter()
if ids_itin_proceed.rowcount( ) > 0 then
	ll_caioid_array = ids_itin_proceed.object.cal_caio_id.primary.current
end if

if ab_editmode or (not ab_editmode and as_target = "dw_cargo_list" ) then
	SELECT VOYAGE_TYPE 
	INTO :li_voyage_type
	FROM VOYAGES
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr;
	
	if li_voyage_type = 2 then
		wf_getcontractinfo(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, li_chart_nr, ls_cptext)
		
		if not isnull(li_chart_nr) and li_chart_nr > 0 then ab_newchart = true	
	else
		if ll_cal_calc_id = 1 then
			ab_newchart = true
		else
			lds_ds.dataobject = "d_cargo_chart_list_dddw"
			lds_ds.settransobject(sqlca)
			
			if upperbound(ll_caioid_array) > 0 then
				ll_count = lds_ds.retrieve(ll_caioid_array)
				if ll_count > 0 then ab_newchart = true	
			end if
			
		end if
	end if
end if

//cb_new_cargo
ll_chartrow = dw_cargo_list.getselectedrow(0)
if ll_chartrow <= 0 then 
	destroy lds_ds
	return
end if

if ab_editmode or (not ab_editmode and as_target = "dw_cargo_detail_list" ) then
	if ls_purpose_code = "L" then
		ab_newcargo = true
	else
		ll_cerp_id = dw_cargo_list.getitemnumber(ll_chartrow, "cargo_cal_cerp_id")
		ll_agent_nr = dw_cargo_list.getitemnumber(ll_chartrow, "agent_nr")
		li_chart_nr = dw_cargo_list.getitemnumber(ll_chartrow, "chart_nr")
		
		if ls_purpose_code = "L/D" then
			if ll_cerp_id > 1 then
				lds_ds.dataobject = "d_dddw_cargo_detail_choice_list"
				lds_ds.settransobject(sqlca)
				if upperbound(ll_caioid_array) > 0 then
					ll_count = lds_ds.retrieve(ll_caioid_array, ll_cerp_id) 
					if ll_count > 0 then ab_newcargo = true
				end if
			else
				ab_newcargo = true
			end if
		end if
		
		if not ab_newcargo then
			SELECT PORT_ORDER INTO :li_port_order
			FROM PROCEED
			WHERE VESSEL_NR = :li_vessel_nr
			AND VOYAGE_NR = :ls_voyage_nr
			AND PORT_CODE = :ls_port_code
			AND PCN = :li_pcn;
			
			lds_ds.dataobject = "d_dddw_cargo_detail_dischcargo"
			lds_ds.settransobject(sqlca)
			ll_count = lds_ds.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, li_port_order, ll_cerp_id, li_chart_nr, ll_agent_nr)
			if ll_count > 0 then ab_newcargo = true
		end if
	end if
end if

ll_cargorow = dw_cargo_detail_list.getselectedrow(0)
if ll_cargorow <= 0 then
	destroy lds_ds
	return
end if

if ab_editmode or (not ab_editmode and as_target = "dw_bol" ) then
	ls_ld = dw_cargo_detail_list.getitemstring(ll_cargorow, "l_d")
	ll_load_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_cargorow, "load_cargo_detail_id")
	if ls_ld <> "D" then
		ab_newbol = true
	else
		lds_ds.dataobject = "d_dddw_cargo_select_blno"
		lds_ds.settransobject(sqlca)
		ll_count = lds_ds.retrieve(ll_load_cargo_detail_id)
		if ll_count > 0 then ab_newbol = true
	end if
end if

destroy lds_ds

end subroutine

public subroutine wf_get_deletebuttonstatus (ref boolean ab_deletechart, ref boolean ab_deletecargo, ref boolean ab_deletebol, boolean ab_editmode, string as_target);
integer li_vessel_nr, li_pcn, li_chart_nr, li_bol_nr, li_l_d
long ll_portrow, ll_chartrow, ll_cargorow, ll_bolrow, ll_agent_nr, ll_cerp_id, ll_count, ll_cargodetailid
string ls_purpose_code, ls_voyage_nr, ls_port_code, ls_ld
dwitemstatus ldws_status
mt_n_datastore lds_ds

ab_deletechart = false
ab_deletecargo = false
ab_deletebol = false

ll_portrow = dw_poc_list_for_cargo.getselectedrow(0)
ll_chartrow = dw_cargo_list.getselectedrow(0)
if ll_portrow <= 0 then return
if ll_chartrow <= 0 then return

lds_ds = create mt_n_datastore

ls_purpose_code = dw_poc_list_for_cargo.getitemstring(ll_portrow, "poc_purpose_code")
ldws_status = dw_cargo_list.getitemstatus(ll_chartrow, 0, primary!)

li_vessel_nr = dw_cargo_list.getitemnumber(ll_chartrow, "vessel_nr")
ls_voyage_nr = dw_cargo_list.getitemstring(ll_chartrow, "voyage_nr")
ls_port_code = dw_cargo_list.getitemstring(ll_chartrow, "port_code")
li_pcn = dw_cargo_list.getitemnumber(ll_chartrow, "pcn")
li_chart_nr = dw_cargo_list.getitemnumber(ll_chartrow, "chart_nr")
ll_agent_nr = dw_cargo_list.getitemnumber(ll_chartrow, "agent_nr")
ll_cerp_id = dw_cargo_list.getitemnumber(ll_chartrow, "cargo_cal_cerp_id")

//cb_delete_charter
if ab_editmode or (not ab_editmode and as_target = "dw_cargo_list" ) then
	if ldws_status = new! or ldws_status = newmodified! or ls_purpose_code = "D" then
		ab_deletechart = true
	else
		lds_ds.dataobject = "d_sq_gr_chart_loadtodischargelist"
		lds_ds.settransobject( sqlca)
		ll_count = lds_ds.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, ll_cerp_id, li_chart_nr, ll_agent_nr)
		if ll_count = 0 then ab_deletechart = true
	end if
end if

ll_cargorow = dw_cargo_detail_list.getselectedrow(0)
if ll_cargorow <= 0 then 
	destroy lds_ds
	return
end if

//cb_delete_cargo
if ab_editmode or (not ab_editmode and as_target = "dw_cargo_detail_list" ) then
	ldws_status = dw_cargo_detail_list.getitemstatus(ll_cargorow, 0, primary!)
	ll_cargodetailid = dw_cargo_detail_list.getitemnumber(ll_cargorow, "cargo_detail_id")
	ls_ld = dw_cargo_detail_list.getitemstring(ll_cargorow, "l_d")
	if ldws_status = new! or ldws_status = newmodified! or ls_ld = "D" then
		ab_deletecargo = true
	else
		lds_ds.dataobject = "d_sq_gr_cargo_loadtodischarge"
		lds_ds.settransobject(sqlca)
		ll_count = lds_ds.retrieve(ll_cargodetailid)
		if ll_count = 0 then ab_deletecargo = true
	end if
end if

ll_bolrow = dw_bol.getselectedrow(0)
if ll_bolrow <= 0 then 
	destroy lds_ds
	return
end if

//cb_delete_bol
if ab_editmode or (not ab_editmode and as_target = "dw_bol" ) then
	ldws_status = dw_bol.getitemstatus(ll_bolrow, 0, primary!)
	ll_cargodetailid = dw_bol.getitemnumber(ll_bolrow, "cargo_detail_id")
	li_bol_nr = dw_bol.getitemnumber(ll_bolrow, "bol_nr")
	li_l_d = dw_bol.getitemnumber(ll_bolrow, "l_d") 
	
	if ldws_status = new! or ldws_status = newmodified! or li_l_d = 0 then
		ab_deletebol = true
	else
		lds_ds.dataobject = "d_sq_gr_bol_loadtodischarge"
		lds_ds.settransobject(sqlca)
		ll_count = lds_ds.retrieve(ll_cargodetailid, li_bol_nr)
		if ll_count = 0 then ab_deletebol = true
	end if
end if

destroy lds_ds


end subroutine

event ue_insert;call super::ue_insert;/* Insert for bol */ 
string	ls_voyage_nr, ls_port_code, ls_layout, ls_grade, ls_group
long		ll_cerp_id,  ll_row, ll_cargo_detail_id, ll_load_cargo_detail_id, ll_findrow
int		li_max_bol_nr, li_bol_max, li_chart_nr, li_pcn, li_agent_nr, li_nor_from_poc, li_dirty_product
datetime	ldt_arrival, ldt_departure, ldt_berthing, ldt_boldate
string	ls_purposecode, ls_l_d, ls_port_name
datawindowchild ldwc_blnr

ll_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_row < 1 then return
ldt_arrival = dw_poc_list_for_cargo.getitemdatetime(ll_row , "poc_port_arr_dt")
ldt_departure = dw_poc_list_for_cargo.getitemdatetime(ll_row, "poc_port_dept_dt")
ldt_berthing = dw_poc_list_for_cargo.getitemdatetime(ll_row, "poc_port_berthing_time")
ls_port_name = dw_poc_list_for_cargo.getitemstring(ll_row, "proceed_proc_text")

ll_row = dw_cargo_list.getselectedrow(0)
if ll_row < 1 then return

ls_voyage_nr = dw_cargo_list.getitemstring(ll_row, "voyage_nr")
ls_port_code = dw_cargo_list.getitemstring(ll_row, "port_code")
li_pcn = dw_cargo_list.getitemnumber(ll_row, "pcn")
li_agent_nr = dw_cargo_list.getitemnumber(ll_row, "agent_nr")
li_chart_nr = dw_cargo_list.getitemnumber(ll_row, "chart_nr")

ll_row = dw_cargo_detail_list.getselectedrow(0)
if ll_row < 1 then return

ls_l_d = trim(dw_cargo_detail_list.getitemstring(ll_row, "l_d"))
ls_layout = dw_cargo_detail_list.getitemstring(ll_row, "layout")
ls_grade = dw_cargo_detail_list.getitemstring(ll_row, "grade_name")
ls_group = dw_cargo_detail_list.getitemstring(ll_row, "grade_group")
ll_cerp_id = dw_cargo_detail_list.getitemnumber(ll_row, "cd_cal_cerp_id")
ll_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_row, "cargo_detail_id")
ll_load_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_row, "load_cargo_detail_id")

SELECT GROUPS.DIRTY_PRODUCT  
INTO :li_dirty_product  
FROM GROUPS  
WHERE GROUPS.GRADE_GROUP = :ls_group ;

dw_bol.setfocus()
idw_focus = dw_bol
ll_row = dw_bol.insertrow(0)

dw_bol.setrow(ll_row)
dw_bol.scrolltorow(ll_row)

if ls_l_d = "D" then dw_bol.event ue_refreshdddw()

setnull(ldt_boldate)
SELECT RECIEVED
  INTO :ldt_boldate
  FROM BOL
 WHERE CARGO_DETAIL_ID = :ll_cargo_detail_id 
   AND BOL_NR = (SELECT min(BOL_NR) FROM BOL WHERE CARGO_DETAIL_ID = :ll_cargo_detail_id);

if isnull(ldt_boldate) then
	ll_findrow = dw_bol.find("cargo_detail_id = " + string(ll_cargo_detail_id) + " and not isnull(recieved)", 1, dw_bol.rowcount())
	if ll_findrow > 0 then ldt_boldate = dw_bol.getitemdatetime(ll_findrow, "recieved")
end if

if not isnull(ldt_boldate) then
	dw_bol.setitem(ll_row, "recieved", ldt_boldate)
end if

dw_bol.setitem(ll_row, "vessel_nr", ii_vessel_nr)
dw_bol.setitem(ll_row, "voyage_nr", ls_voyage_nr)
dw_bol.setitem(ll_row, "port_code", ls_port_code)
dw_bol.setitem(ll_row, "pcn", li_pcn)
dw_bol.setitem(ll_row, "agent_nr", li_agent_nr)
dw_bol.setitem(ll_row, "chart_nr", li_chart_nr)
dw_bol.setitem(ll_row, "layout", ls_layout)
//dw_bol.setitem(ll_row, "layout_bl", ls_layout)
dw_bol.setitem(ll_row, "grade_name", ls_grade)
dw_bol.setitem(ll_row, "grade_group", ls_group)
dw_bol.setitem(ll_row, "rate_type", 0)
dw_bol.setitem(ll_row, "gear", 0)
dw_bol.setitem(ll_row, "cal_cerp_id", ll_cerp_id)
dw_bol.setitem(ll_row, "cargo_detail_id", ll_cargo_detail_id)
dw_bol.setitem(ll_row, "all_fast_dt", ldt_berthing )
dw_bol.setitem(ll_row, "departure_dt", ldt_departure )
dw_bol.setitem(ll_row, "temp_type", 0)
if ib_validate_cargo_temp then
	dw_bol.setitem(ll_row, "validate_cargo_temp", 1)
else
	dw_bol.setitem(ll_row, "validate_cargo_temp", 0)
end if
dw_bol.setitemstatus(ll_row, "validate_cargo_temp", primary!, notmodified!)
dw_bol.setitem(ll_row, "dirty_product", li_dirty_product)
dw_bol.setitemstatus(ll_row, "dirty_product", primary!, notmodified!)

if ls_l_d = 'L'  then
	SELECT max(BOL_NR)
	INTO :li_bol_max
	FROM BOL
	WHERE	VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr;
	
	if isnull(li_bol_max) then li_bol_max = 0
	li_max_bol_nr = dw_bol.getitemnumber(1, "max_bol_nr")
	if li_max_bol_nr > li_bol_max then li_bol_max = li_max_bol_nr

	dw_bol.setitem(ll_row, "l_d", 1)
	dw_bol.setitem(ll_row, "bol_nr", li_bol_max + 1)
	dw_bol.settaborder("bol_nr", 0)
	dw_bol.setitem(ll_row, "port_name", ls_port_name)
	dw_bol.setitem(ll_row, "layout_bl", ls_layout)
elseif ls_l_d = 'D' then
	SELECT PORTS.PORT_N into :ls_port_name
	FROM PORTS, CD 
	WHERE PORTS.PORT_CODE = CD.PORT_CODE 
	AND CD.CARGO_DETAIL_ID = :ll_load_cargo_detail_id;
	
	dw_bol.setitem(ll_row,"l_d",0)
	dw_bol.settaborder("bol_nr", 10)
	dw_bol.setcolumn("bol_nr")
	dw_bol.setitem(ll_row, "port_name", ls_port_name)
	
	dw_bol.getchild("bol_nr", ldwc_blnr)
	if ldwc_blnr.rowcount() = 1 then
		dw_bol.setitem(ll_row, "bol_nr", ldwc_blnr.getitemnumber(1, "bol_nr"))
		dw_bol.setitem(ll_row, "recieved", ldwc_blnr.getitemdatetime(1, "recieved"))
		dw_bol.setitem(ll_row, "bol_quantity", ldwc_blnr.getitemnumber(1, "remain_qty"))
		dw_bol.setitem(ll_row, "temp_type", ldwc_blnr.getitemnumber(1, "temp_type"))
		dw_bol.setitem(ll_row, "layout_bl", ldwc_blnr.getitemstring(1, "layout_bl"))
	end if
end if

dw_bol.setitemstatus(ll_row, "port_name", primary!, notmodified!)
 
//SELECT PROFIT_C.BOL_NOR_DATE_FROM_POC
//INTO :li_nor_from_poc
//FROM VESSELS, PROFIT_C
//WHERE VESSELS.PC_NR = PROFIT_C.PC_NR
//AND VESSELS.VESSEL_NR = :ii_vessel_nr ;
//
//if li_nor_from_poc = 1 then
//	dw_bol.setitem(ll_row,"nor_dt", ldt_arrival )
//end if	

if not ib_lockwindow  then
	wf_seteditmode(false, dw_bol)
end if

dw_bol.setfocus( )
if ls_l_d = 'D' then
	dw_bol.setcolumn("bol_nr")
else
	dw_bol.setcolumn("layout_bl")
end if

end event

event ue_retrieve;call super::ue_retrieve;/* retrieve for whole window */

string ls_voyage_nr, ls_port_code, ls_layout, ls_grade,ls_l_d
long ll_rc
int li_pcn
long ll_agent_nr, ll_chart_nr, ll_cerp_id, ll_cargo_detail_id
string ls_find_str, ls_shipfig, ls_mtbe_etbe
int li_row


dw_poc_list_for_cargo.retrieve(ii_vessel_nr)	
dw_poc_list_for_cargo.setfocus()

dw_bol.reset()
dw_bol_total_disch.reset()
dw_bol_total_load.reset()
dw_cargo_detail_list.reset()
dw_cargo_list.reset()

if dw_poc_list_for_cargo.rowcount() < 1 then		
	return
end if

if uo_global.getparm() = 1 then
	uo_global.setparm(0)
	ls_voyage_nr = uo_global.getvoyage_nr()
	ls_port_code = uo_global.getport_code()
	li_pcn       = uo_global.getpcn()
	ls_find_str = 	"poc_voyage_nr = '" + &   
						  	ls_voyage_nr + &	
							"' and poc_port_code = '" + &
							ls_port_code + "'" + &
							" and poc_pcn = " + &
							string(li_pcn)
	li_row = dw_poc_list_for_cargo.find(ls_find_str,1,dw_poc_list_for_cargo.rowcount())
else
	li_row = dw_poc_list_for_cargo.rowcount()
end if

if li_row > 0 then
	dw_poc_list_for_cargo.event clicked(0, 0, li_row, dw_poc_list_for_cargo.object)
end if

uo_vesselselect.dw_vessel.setfocus()

end event

event ue_update;call super::ue_update;long ll_row, ll_count, ll_bol_id, ll_currentrow
integer li_vessel_nr, li_pcn, li_l_d, li_chartnr, li_cp_chartnr, li_return, li_jump_chart, li_dirty_product, li_bol_max, li_bol_nr
integer li_errcol
long	ll_dischcargo_detailID, ll_cargo_detail_id
decimal	ld_min_loadtemperature, ld_max_dischargetemperature, ld_cur_temperature
datetime	ldt_bldate
long ll_cerpid, ll_selectrow, ll_port_row, ll_findrow, ll_errrow
string ls_voyage_nr, ls_port_code, ls_gradename, ls_message, ls_sortstring
n_service_manager	lnv_svcmgr
n_dw_validation_service 	lnv_validation

u_jump_claims luo_jump_claims

ib_accepttext = true
if dw_bol.accepttext() <> 1 then
	ib_accepttext = false
	dw_bol.setfocus()	
	return c#return.Failure
end if
ib_accepttext = false

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_port_row < 1 then return c#return.Failure

idw_focus = dw_bol

lnv_svcmgr.of_loadservice( lnv_validation, "n_dw_validation_service")
lnv_validation.of_registerrulenumber("bol_nr", true, "B/L No")
lnv_validation.of_registerrulestring("layout_bl", true, "Layout")
//lnv_validation.of_registerruledatetime("recieved", true, "B/L Date")
lnv_validation.of_registerrulenumber("bol_quantity", true, "Quantity")
if lnv_validation.of_validate(dw_bol, ls_message, ll_errrow, li_errcol) = c#return.Failure then 
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, ls_message, this)
	dw_bol.setfocus()
	dw_bol.setrow(ll_errrow)
	dw_bol.scrolltorow(ll_errrow)
	dw_bol.setColumn(li_errcol)
	
	return c#return.Failure
end if

li_vessel_nr = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_vessel_nr")
ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")

li_jump_chart = 0
	
for ll_row = 1 to dw_bol.rowcount()	
	if dw_bol.getitemstatus(ll_row, 0, primary!) = notmodified! then continue
	
	li_l_d = dw_bol.getitemnumber(ll_row, "l_d")
	if li_l_d = 1 then
		ldt_bldate = dw_bol.getitemdatetime(ll_row, "recieved")
		if isnull(ldt_bldate) then
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The B/L Date cannot be empty.", this)
			dw_bol.setfocus()
			dw_bol.setrow(ll_row)
			dw_bol.scrolltorow(ll_row)
			dw_bol.setColumn("recieved")
			
			return c#return.Failure
		end if
	end if
	
	li_dirty_product = dw_bol.getitemnumber(ll_row, "dirty_product")

	if ib_validate_cargo_temp and li_dirty_product = 1 then
		if isnull(dw_bol.getItemNumber(ll_row,"cargo_temp"))  then
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The Cargo Temperature cannot be empty.", this)
			dw_bol.setfocus()
			dw_bol.setrow(ll_row)
			dw_bol.scrolltorow(ll_row)
			dw_bol.setColumn("cargo_temp")
			
			return c#return.Failure
		end if
		
		if li_jump_chart > 0 then continue
		
		ls_gradename = dw_bol.getitemstring(ll_row, "grade_name")
		ll_cerpid = dw_bol.getitemnumber(ll_row, "cal_cerp_id")
		li_chartnr = dw_bol.getitemnumber(ll_row, "chart_nr")
		ld_cur_temperature = dw_bol.getitemnumber(ll_row, "cargo_temp")
		li_l_d = dw_bol.getitemnumber(ll_row, "l_d")
		ll_bol_id = dw_bol.getitemnumber(ll_row, "bol_id")
		if isnull(ll_bol_id) then ll_bol_id = 0
		
		SELECT count(*)
		INTO :ll_count
		FROM CLAIMS
		WHERE VESSEL_NR = :li_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr
		AND CHART_NR = :li_chartnr
		AND CLAIM_TYPE = "HEA";
		
		if ll_count = 0 then
			/* Get minimum load temperature for this cargo */
			SELECT min(CARGO_TEMP) 
			INTO :ld_min_loadtemperature
			FROM BOL 
			WHERE VESSEL_NR = :li_vessel_nr
			AND VOYAGE_NR = :ls_voyage_nr
			AND GRADE_NAME = :ls_gradename
			AND CAL_CERP_ID = :ll_cerpid 
			AND L_D = 1
			AND BOL_ID <> :ll_bol_id;
			
			/* Get maximum discharge temperature for this cargo */
			SELECT max(CARGO_TEMP) 
			INTO :ld_max_dischargetemperature
			FROM BOL
			WHERE VESSEL_NR = :li_vessel_nr
			AND VOYAGE_NR = :ls_voyage_nr
			AND GRADE_NAME = :ls_gradename
			AND CAL_CERP_ID = :ll_cerpid 
			AND L_D = 0
			AND BOL_ID <> :ll_bol_id;
			
			if li_l_d = 1 then
				if isnull(ld_min_loadtemperature) or ld_cur_temperature < ld_min_loadtemperature then ld_min_loadtemperature = ld_cur_temperature
			else
				if isnull(ld_max_dischargetemperature) or ld_cur_temperature > ld_max_dischargetemperature then ld_max_dischargetemperature = ld_cur_temperature
			end if
			
			if IsNull(ld_min_loadtemperature) or Isnull(ld_max_dischargetemperature) then
				// Do nothing !
			else
				if ld_max_dischargetemperature - ld_min_loadtemperature >= id_temp_difference then
					li_jump_chart = li_chartnr
				end if
			end if
			
		end if	
	end if
	
	// CR3148 
	li_chartnr = dw_bol.getitemnumber(ll_row, "chart_nr")
	ll_cerpid  = dw_bol.getitemnumber(ll_row, "cal_cerp_id")
	if ll_cerpid > 1 then
		SELECT CHART_NR INTO :li_cp_chartnr FROM CAL_CERP WHERE CAL_CERP_ID = :ll_cerpid;
		if li_cp_chartnr <> li_chartnr then
			dw_bol.setitem(ll_row, "chart_nr", li_cp_chartnr)
		end if
	end if
next

SELECT max(BOL_NR)
INTO :li_bol_max
FROM BOL
WHERE	VESSEL_NR = :li_vessel_nr
AND VOYAGE_NR = :ls_voyage_nr;

for ll_row = 1 to dw_bol.rowcount()	
	if dw_bol.getitemstatus(ll_row, 0, primary!) <> newmodified! then continue
	if dw_bol.getitemnumber(ll_row, "l_d") = 0 then continue
	
	li_bol_nr = dw_bol.getitemnumber(ll_row, "bol_nr")
	if li_bol_nr <=  li_bol_max then
		dw_bol.setitem(ll_row, "bol_nr", li_bol_max + 1)
	end if
	
	li_bol_max++
next


if dw_bol.update() = 1 then
	commit;

	//sort after update
	idw_focus = dw_poc_list_for_cargo	
	
	ll_selectrow = dw_bol.getselectedrow(0)
	if ll_selectrow > 0 then
		ll_bol_id = dw_bol.getitemnumber(ll_selectrow, "bol_id")
	end if
	
	dw_bol.setredraw(false)
	ls_sortstring = dw_bol.Describe("Datawindow.Table.sort")
	if ls_sortstring = "?" then dw_bol.setsort("bol_nr A")
	dw_bol.sort()
	if ls_sortstring = "?" then dw_bol.setsort("")
	if ll_selectrow > 0 then
		ll_findrow = dw_bol.find("bol_id = " + string(ll_bol_id), 1, dw_bol.rowcount())
		if ll_findrow > 0 then
			dw_bol.setrow(ll_findrow)
			dw_bol.scrolltorow(ll_findrow)
		end if
	end if
	dw_bol.setredraw(true)
	
	//refresh cargo
	ll_selectrow = dw_cargo_detail_list.getselectedrow(0)
	if ll_selectrow > 0 then
		ll_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_selectrow, "cargo_detail_id")
	end if
	
	dw_cargo_detail_list.setredraw(false)
	
	dw_cargo_detail_list.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	dw_cargo_detail_list.selectrow(0, false)
	if ll_selectrow > 0 then
		ll_findrow = dw_cargo_detail_list.find("cargo_detail_id = " + string(ll_cargo_detail_id), 1, dw_cargo_detail_list.rowcount())
		if ll_findrow > 0 then
			ll_currentrow = dw_cargo_detail_list.getrow()
			dw_cargo_detail_list.setrow(ll_findrow)
			dw_cargo_detail_list.scrolltorow(ll_findrow)
			if ll_currentrow = ll_findrow then dw_cargo_detail_list.event rowfocuschanged(ll_findrow)
		end if
	end if
	
	dw_cargo_detail_list.setredraw(true)
			
	if ii_profitcenter = 3 then
		dw_pctc_rob.post retrieve(ii_vessel_nr)
	end if
	
	wf_seteditmode(true, dw_bol)
else
	rollback;
end if

//dw_bol.setfocus()


if ib_validate_cargo_temp and li_jump_chart > 0 then
	if messageBox("Information", "The difference between the Load and Discharge Temperature is more~r~n" &
										+"than specified allowance.~r~n~r~nLoad Temp: ~t"+string(ld_min_loadtemperature) &
										+"~r~nDisch. Temp: ~t"+string(ld_max_dischargetemperature) &
										+"~r~nAllowance: ~t"+string(id_temp_difference ) &
										+"~r~n~r~nWould you like to jump to the Claims Module and create a Heating Claim now?",Question!,YesNo!,1) = 1 then
		luo_jump_claims = CREATE u_jump_claims
		luo_jump_claims.of_createHeatingClaim(li_vessel_nr, ls_voyage_nr, li_jump_chart) 
		DESTROY luo_jump_claims
	end if
end if

return c#return.Success

end event

event open;call super::open;
n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style

Move(0,0)

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")

lnv_style.of_dwlistformater(dw_poc_list_for_cargo, false)
lnv_style.of_dwlistformater(dw_cargo_list, false)
lnv_style.of_dwlistformater(dw_bol, false)
lnv_style.of_autoadjustdddwwidth(dw_cargo_list)
lnv_style.of_autoadjustdddwwidth(dw_bol)
dw_cargo_detail_list.of_setallcolumnsresizable(true)

inv_dddw_search_chart = CREATE u_dddw_search
inv_dddw_search_chart.of_register(dw_cargo_list, "chart_nr", "chart_chart_sn", true, true)

inv_dddw_search_agent = CREATE u_dddw_search
inv_dddw_search_agent.of_register(dw_cargo_list, "agent_nr", "agent_sn", true, true)

inv_dddw_search_grade = CREATE u_dddw_search
inv_dddw_search_grade.of_register(dw_cargo_detail_list, "grade_property", "grade_name", false, true)

inv_dddw_search_load = CREATE u_dddw_search
inv_dddw_search_load.of_register(dw_cargo_detail_list, "cd_cal_caio_id", "cal_carg_description", true, true)

inv_dddw_search_disch = CREATE u_dddw_search
inv_dddw_search_disch.of_register(dw_cargo_detail_list, "load_cargo_detail_id", "cal_carg_description", false, true)

inv_dddw_search_ld = CREATE u_dddw_search
inv_dddw_search_ld.of_register(dw_cargo_detail_list, "l_d", "l_d", false, true)

inv_dddw_search_bol = CREATE u_dddw_search
inv_dddw_search_bol.of_register(dw_bol, "bol_nr", "bol_nr", true, true)

dw_bol_total_load.object.datawindow.color =string(c#color.MT_FORM_BG)
dw_bol_total_disch.object.datawindow.color =string(c#color.MT_FORM_BG)

uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT

uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

dw_poc_list_for_cargo.settransobject(sqlca)
dw_cargo_detail_list.settransobject(sqlca)
dw_cargo_list.settransobject(sqlca)
dw_bol.settransobject(sqlca)
dw_bol_total_load.settransobject(sqlca)
dw_bol_total_disch.settransobject(sqlca)
dw_pctc_rob.settransobject(sqlca)
ii_vessel_nr = uo_global.getvessel_nr()
 
 wf_setcargocolumns()

uo_vesselselect.of_registerwindow(w_cargo)
uo_vesselselect.of_setcurrentvessel(uo_global.getvessel_nr())
uo_vesselselect.dw_vessel.setColumn("vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
 
ids_itin_proceed = create mt_n_datastore 
ids_itin_proceed.dataobject = "d_sp_gr_itin_proceed_matchlist"
ids_itin_proceed.settrans( sqlca)

if uo_global.ii_access_level = c#usergroup.#EXTERNAL_APM then
	dw_cargo_list.Object.Datawindow.ReadOnly="Yes"
	dw_cargo_detail_list.Object.Datawindow.ReadOnly="Yes"
	dw_bol.Object.Datawindow.ReadOnly="Yes"	
end if

uo_vesselselect.dw_vessel.setfocus()

end event

event ue_delete;call super::ue_delete;integer li_l_d, li_bol_nr
long ll_row, ll_count, ll_index, ll_cargo_detail_id, ll_bol_id, ll_cargorow
dec{4} ld_total_quantity 
string ls_portname, ls_portname_str, ls_errtext
dwitemstatus ldws_status
mt_n_datastore lds_bol
 

ll_row = dw_bol.getselectedrow(0)
if ll_row < 1 then return

idw_focus = dw_poc_list_for_cargo

ldws_status = dw_bol.getitemstatus(ll_row, 0, primary!)
if ldws_status = new! or ldws_status = newmodified! then
	dw_bol.setredraw(false)
	
	dw_bol.deleterow(ll_row)
	dw_bol.selectrow(0, false)
	
	dw_bol.setredraw(true)
	
	if dw_bol.modifiedcount() > 0 then
		wf_seteditmode(false, dw_bol)
	else
		wf_seteditmode(true, dw_bol)
	end if
	
	dw_poc_list_for_cargo.setfocus()
	return
end if

ll_bol_id = dw_bol.getitemnumber(ll_row, "bol_id")
ll_cargo_detail_id = dw_bol.getitemnumber(ll_row, "cargo_detail_id")
li_bol_nr = dw_bol.getitemnumber(ll_row, "bol_nr")

ll_count = 0
li_l_d = dw_bol.getitemnumber(ll_row, "l_d") 
if li_l_d = 1 then
	lds_bol = create mt_n_datastore
	lds_bol.dataobject = "d_sq_gr_bol_loadtodischarge"
	lds_bol.settransobject(sqlca)
	ll_count = lds_bol.retrieve(ll_cargo_detail_id, li_bol_nr)
	if ll_count > 0 then
		for ll_index = 1 to ll_count
			ls_portname = lds_bol.getitemstring(ll_index, "ports_port_n")
			if ls_portname_str = "" then
				ls_portname_str = ls_portname
			else
				ls_portname_str += ", " + ls_portname
			end if
		next
		
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, "This B/L has already been discharged in port(s) " + ls_portname_str + ". You need to delete them first to continue.", this)
		return
	end if
end if

if ll_count = 0 then
	if inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "the selected B/L", this) = 2 then 
		return
	end if
end if

DELETE FROM BOL
WHERE BOL_ID = :ll_bol_id;
if sqlca.sqlcode = 0 then
	commit;
	
	SELECT isnull(sum(BOL_QUANTITY), 0) INTO :ld_total_quantity
	FROM BOL 
	WHERE  CARGO_DETAIL_ID = :ll_cargo_detail_id;
	
	ll_cargorow = dw_cargo_detail_list.getselectedrow(0)
	if ll_cargorow > 0 then
		if li_l_d = 1 then
			dw_cargo_detail_list.setitem(ll_cargorow, "bol_l", ld_total_quantity)
			dw_cargo_detail_list.setitemstatus(ll_cargorow, "bol_l", Primary!, NotModified!)
		else
			dw_cargo_detail_list.setitem(ll_cargorow, "bol_d", ld_total_quantity)
			dw_cargo_detail_list.setitemstatus(ll_cargorow, "bol_d", Primary!, NotModified!)
		end if
	end if
	
	dw_bol.setredraw(false)
	dw_bol.rowsdiscard(ll_row, ll_row, primary!)
	dw_bol.selectrow(0, false)
	dw_bol.setredraw(true)
	
	if ii_profitcenter = 3 then
		dw_pctc_rob.post retrieve(ii_vessel_nr)
	end if
	
	if dw_bol.modifiedcount() > 0 then
		wf_seteditmode(false, dw_bol)
	else
		wf_seteditmode(true, dw_bol)
	end if
	
else
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messageBox("Error", "Delete failed." + ls_errtext)
end if

dw_poc_list_for_cargo.setfocus()

end event

on w_cargo.create
int iCurrent
call super::create
this.dw_cargo_list=create dw_cargo_list
this.cb_cancel_bol=create cb_cancel_bol
this.dw_bol_total_load=create dw_bol_total_load
this.dw_bol_total_disch=create dw_bol_total_disch
this.cb_update_cargo=create cb_update_cargo
this.cb_new_bol=create cb_new_bol
this.cb_update_bol=create cb_update_bol
this.cb_new_agent=create cb_new_agent
this.dw_poc_list_for_cargo=create dw_poc_list_for_cargo
this.cb_cancel_cargo=create cb_cancel_cargo
this.cb_delete_charter=create cb_delete_charter
this.gb_1=create gb_1
this.cb_refresh=create cb_refresh
this.gb_3=create gb_3
this.cb_delete_bol=create cb_delete_bol
this.st_background=create st_background
this.cb_new_cargo=create cb_new_cargo
this.cb_delete_cargo=create cb_delete_cargo
this.dw_cargo_detail_list=create dw_cargo_detail_list
this.cb_update_charter=create cb_update_charter
this.cb_cancel_charter=create cb_cancel_charter
this.gb_2=create gb_2
this.dw_bol=create dw_bol
this.gb_4=create gb_4
this.dw_pctc_rob=create dw_pctc_rob
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cargo_list
this.Control[iCurrent+2]=this.cb_cancel_bol
this.Control[iCurrent+3]=this.dw_bol_total_load
this.Control[iCurrent+4]=this.dw_bol_total_disch
this.Control[iCurrent+5]=this.cb_update_cargo
this.Control[iCurrent+6]=this.cb_new_bol
this.Control[iCurrent+7]=this.cb_update_bol
this.Control[iCurrent+8]=this.cb_new_agent
this.Control[iCurrent+9]=this.dw_poc_list_for_cargo
this.Control[iCurrent+10]=this.cb_cancel_cargo
this.Control[iCurrent+11]=this.cb_delete_charter
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.cb_refresh
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.cb_delete_bol
this.Control[iCurrent+16]=this.st_background
this.Control[iCurrent+17]=this.cb_new_cargo
this.Control[iCurrent+18]=this.cb_delete_cargo
this.Control[iCurrent+19]=this.dw_cargo_detail_list
this.Control[iCurrent+20]=this.cb_update_charter
this.Control[iCurrent+21]=this.cb_cancel_charter
this.Control[iCurrent+22]=this.gb_2
this.Control[iCurrent+23]=this.dw_bol
this.Control[iCurrent+24]=this.gb_4
this.Control[iCurrent+25]=this.dw_pctc_rob
end on

on w_cargo.destroy
call super::destroy
destroy(this.dw_cargo_list)
destroy(this.cb_cancel_bol)
destroy(this.dw_bol_total_load)
destroy(this.dw_bol_total_disch)
destroy(this.cb_update_cargo)
destroy(this.cb_new_bol)
destroy(this.cb_update_bol)
destroy(this.cb_new_agent)
destroy(this.dw_poc_list_for_cargo)
destroy(this.cb_cancel_cargo)
destroy(this.cb_delete_charter)
destroy(this.gb_1)
destroy(this.cb_refresh)
destroy(this.gb_3)
destroy(this.cb_delete_bol)
destroy(this.st_background)
destroy(this.cb_new_cargo)
destroy(this.cb_delete_cargo)
destroy(this.dw_cargo_detail_list)
destroy(this.cb_update_charter)
destroy(this.cb_cancel_charter)
destroy(this.gb_2)
destroy(this.dw_bol)
destroy(this.gb_4)
destroy(this.dw_pctc_rob)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_poc_list_for_cargo, "poc_vessel_nr", "poc_voyage_nr", True)


end event

event ue_vesselselection;call super::ue_vesselselection;boolean lb_visible

dw_poc_list_for_cargo.Reset()
dw_cargo_list.Reset()
dw_cargo_detail_list.Reset()
dw_bol.Reset()

wf_seteditmode(true, dw_poc_list_for_cargo)

SELECT PC_NR INTO :ii_profitcenter FROM VESSELS WHERE VESSEL_NR = :ii_vessel_nr;
if ii_profitcenter = 3 then 
	dw_pctc_rob.retrieve(ii_vessel_nr)
else
	dw_pctc_rob.visible = false
	dw_pctc_rob.reset()
end if

postevent("ue_retrieve")




end event

event close;call super::close;destroy ids_itin_proceed
destroy inv_dddw_search_agent
destroy inv_dddw_search_chart
destroy inv_dddw_search_grade
destroy inv_dddw_search_load
destroy inv_dddw_search_disch
destroy inv_dddw_search_bol
destroy inv_dddw_search_ld
end event

event key;call super::key;/********************************************************************
   key
   <DESC>When inputing a new vessel, press the Enter key will execute to select a vessel, instead of execute the default keyboard focus button.	</DESC>
   <RETURN>	long:
            </RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		key
		keyflags
   </ARGS>
   <USAGE>when user enter key,the event is called</USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2011-11-24 D3-1            RJH022        First Version
   </HISTORY>
********************************************************************/

graphicobject	lgo_foucs
if key = keyenter! then
	lgo_foucs = getfocus()
	if lgo_foucs.classname() = 'dw_vessel' then
		send(handle(lgo_foucs),256,9,0)
	end if
end if
return  c#return.Success
end event

event closequery;call super::closequery;if wf_checkdatamodified() = 3 then
	return 1 
else
	 return 0
end if
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_cargo
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_cargo
integer x = 23
integer taborder = 10
end type

type dw_cargo_list from uo_datawindow within w_cargo
event ue_refreshdddw ( )
event ue_rowchanged ( long currentrow )
integer x = 2139
integer y = 328
integer width = 1824
integer height = 388
integer taborder = 40
string dataobject = "dw_cargo_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event ue_refreshdddw();/********************************************************************
   ue_refreshdddw
   <DESC>	Description	</DESC>
   <RETURN>	(None)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	05/09/16		CR4224           CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_agent_nr, ll_row
string ls_filter
datawindowchild	ldwc_child

ll_row = this.getrow()
if ll_row < 1 then return

if this.getchild("agent_nr", ldwc_child) = 1 then
	ll_agent_nr = this.getitemnumber(ll_row, "agent_nr")
	if isnull(ll_agent_nr) or ll_agent_nr = 0 then
		ls_filter = "agent_active = 1"
	else
		ls_filter = "(agent_active = 1 or agent_nr = " + string(ll_agent_nr) + ")"
	end if
	
	ldwc_child.setfilter(ls_filter)
	ldwc_child.filter()
end if




end event

event ue_rowchanged(long currentrow);/********************************************************************
   ue_rowchanged
   <DESC>row highlight, filter</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		currentrow
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

string 	ls_voyage_nr, ls_port_code, ls_layout, ls_grade, ls_filter
long 		ll_cerp_id, ll_cargo_detail_id, ll_agent_nr, ll_selectrow
int 		li_pcn, li_chart
dwitemstatus ldws_status, ldws_status_select
mt_n_datastore lds_cargo, lds_bol


if isnull(currentrow) or currentrow < 1 then return
 
this.selectrow(0, false)
this.selectrow(currentrow, true)

if idw_focus.classname() <> this.classname() then return

ldws_status = this.getitemstatus(currentrow, 0, primary!)

if ldws_status = New! or ldws_status = NewModified! then
	ls_filter = "chart_nr = " + string(0)
	dw_cargo_detail_list.setfilter(ls_filter)
	dw_cargo_detail_list.filter()
	dw_bol.setfilter(ls_filter)
	dw_bol.filter()
else
	ls_voyage_nr = this.getitemstring(currentrow, "voyage_nr")
	ls_port_code = this.getitemstring(currentrow, "port_code")
	li_pcn = this.getitemnumber(currentrow, "pcn")
	ll_agent_nr = this.getitemnumber(currentrow, "agent_nr")
	li_chart = this.getitemnumber(currentrow, "chart_nr")
	ll_cerp_id = this.getitemnumber(currentrow, "cargo_cal_cerp_id")
	
	ls_filter = "chart_nr = " + string(li_chart) + " and cd_cal_cerp_id = " + string(ll_cerp_id) + " and agent_nr = " + string(ll_agent_nr)
	dw_cargo_detail_list.setfilter(ls_filter)
	dw_cargo_detail_list.filter()
	dw_cargo_detail_list.selectrow(0, false)
	
	 ls_filter = "chart_nr = " + string(li_chart) + " and cal_cerp_id = " + string(ll_cerp_id) + " and agent_nr = " + string(ll_agent_nr)
	dw_bol.setfilter(ls_filter)
	dw_bol.filter()
	dw_bol.selectrow(0, false)
end if

if not ib_lockwindow then
	wf_seteditmode(true, dw_cargo_list)
else
	wf_seteditmode(false, dw_cargo_list)
end if

//this.setfocus()
end event

event clicked;long ll_row, ll_selectrow, ll_agent_nr, ll_cerp_id, ll_rowid
integer li_chart_nr
dwitemstatus ldws_status

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

if row = 0 then 
	if dwo.type = "text" then
		idw_focus = dw_poc_list_for_cargo
		
		ll_selectrow = this.getselectedrow(0)
		if ll_selectrow > 0 then
			ll_rowid = this.getrowidfromrow(ll_selectrow)
		end if
		
		super::event clicked(xpos, ypos, row, dwo)
		
		if ll_selectrow > 0 and ll_rowid > 0 then
			ll_selectrow = this.getrowfromrowid(ll_rowid)
			
			if ll_selectrow > 0 then
				this.setrow(ll_selectrow)
				this.scrolltorow(ll_selectrow)
			end if
		end if
	end if
	
	return
end if

idw_focus = this

ll_row = this.getrow()
 
if ll_row <> row then
	this.setrow(row)
	this.scrolltorow(row)
end if

if ll_row = row then this.event rowfocuschanged(row)

end event

event constructor;call super::constructor;this.modify("agent_nr_1.width = '0~tlong(describe(~"agent_nr.width~"))' agent_nr_1.x = '0~tlong(describe(~"agent_nr.x~"))'")
this.modify("chart_chart_sn.width = '0~tlong(describe(~"chart_nr.width~"))' chart_chart_sn.x = '0~tlong(describe(~"chart_nr.x~"))'")
this.modify("datawindow.processing = '0' agent_nr_1.visible = '1~tif(currentRow() = getrow() and isRowNew(), 0, 1)' datawindow.processing = '1'")
this.modify("datawindow.processing = '0' chart_chart_sn.visible = '1~tif(currentRow() = getrow() and isRowNew(), 0, 1)' datawindow.processing = '1'")


end event

event editchanged;call super::editchanged;if ib_lockwindow = false then
	wf_seteditmode(false, dw_cargo_list)
	dw_cargo_list.setfocus()
end if

choose case dwo.name
	case "agent_nr"
		inv_dddw_search_agent.uf_editchanged()
	case "chart_nr"
		inv_dddw_search_chart.uf_editchanged()
end choose

end event

event rowfocuschanged;call super::rowfocuschanged;
if isnull(currentrow) or currentrow < 1 then return

this.event ue_refreshdddw()
this.event ue_rowchanged(currentrow)

end event

event itemchanged;call super::itemchanged;
long ll_row
datawindowchild ldwc_chart, ldwc_agent

if row < 1 then return

if dwo.name = "chart_nr" then
	if inv_dddw_search_chart.uf_itemchanged() = 1 then
		return 2
	else
		if not isnull(data) and data <> "" then
			this.getchild("chart_nr", ldwc_chart)
			ll_row = ldwc_chart.getrow()
			if ll_row > 0 then
				this.setitem(row, "chart_chart_sn", ldwc_chart.getitemstring(ll_row, "chart_chart_sn"))
				this.setitem(row, "cal_cerp_description", ldwc_chart.getitemstring(ll_row, "cal_cerp_cal_cerp_description"))
				this.setitem(row, "cargo_cal_cerp_id", ldwc_chart.getitemnumber(ll_row, "cal_cerp_cal_cerp_id"))
				this.setitemstatus(row, "chart_chart_sn", primary!, notmodified!)
				this.setitemstatus(row, "cal_cerp_description", primary!, notmodified!)
			end if
		end if
	end if
end if

if dwo.name = "agent_nr" then
	if not isnull(data) and data <> "" then
		this.getchild("agent_nr", ldwc_agent)
		ll_row = ldwc_agent.find("agent_nr = " + data, 1, ldwc_agent.rowcount())
		if ll_row > 0 then
			
		else
			return 2
		end if
	end if
end if

if not ib_lockwindow then
	wf_seteditmode(false, dw_cargo_list)
	dw_cargo_list.setfocus()
end if
end event

event getfocus;call super::getfocus;idw_focus = this
end event

event retrieveend;call super::retrieveend;wf_showcptext()
end event

event itemerror;call super::itemerror;string ls_coltitle, ls_colname
int li_return

this.selecttext(1, len(data))

ls_colname = dwo.name

if ls_colname = "agent_nr" or ls_colname = "chart_nr" then
	li_return = 3
else
	li_return = 1
end if

return li_return

end event

event ue_set_column;call super::ue_set_column;string ls_columnname

ls_columnname = this.getcolumnname()

if ls_columnname = "chart_nr" or ls_columnname = "agent_nr" then
	this.of_set_column()
end if
end event

type cb_cancel_bol from mt_u_commandbutton within w_cargo
integer x = 4165
integer y = 2116
integer taborder = 180
boolean enabled = false
string text = "&Cancel"
boolean cancel = true
end type

event clicked;integer li_pcn
long ll_port_row, ll_row, ll_findrow, ll_bol_id, ll_currentrow
string ls_voyage_nr, ls_port_code
dwitemstatus ldws_status

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_port_row < 1 then return

idw_focus = dw_poc_list_for_cargo

ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")

ll_row = dw_bol.getselectedrow(0)
if ll_row > 0 then
	ldws_status = dw_bol.getitemstatus(ll_row, 0, primary!)
	ll_bol_id = dw_bol.getitemnumber(ll_row, "bol_id")
end if

dw_bol.setredraw(false)

dw_bol.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
if ldws_status = new! or ldws_status = newmodified! then
	ll_findrow = 0
else
	ll_findrow = dw_bol.find("bol_id = " + string(ll_bol_id), 1, dw_bol.rowcount())
end if
dw_bol.selectrow(0, false)
if ll_findrow > 0 then
	ll_currentrow = dw_bol.getrow()
	dw_bol.setrow(ll_findrow)
	dw_bol.scrolltorow(ll_findrow)
	if ll_findrow = ll_currentrow then dw_bol.event rowfocuschanged(ll_findrow)
end if

dw_bol.setredraw(true)

wf_seteditmode(true, dw_bol)
dw_poc_list_for_cargo.setfocus()
end event

type dw_bol_total_load from uo_datawindow within w_cargo
integer x = 4059
integer y = 320
integer width = 457
integer height = 96
integer taborder = 0
string dataobject = "dw_bol_total"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;
wf_showpctcdw(xpos, ypos)

end event

type dw_bol_total_disch from uo_datawindow within w_cargo
integer x = 4059
integer y = 440
integer width = 457
integer height = 172
integer taborder = 0
string dataobject = "dw_bol_total"
boolean border = false
end type

event rbuttondown;call super::rbuttondown;
wf_showpctcdw(xpos, ypos)

end event

type cb_update_cargo from mt_u_commandbutton within w_cargo
integer x = 3470
integer y = 1352
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string text = "&Update"
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>	only mtbe,bio,dye was updated	 </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	update cargo only mtbe,bio,dye	</USAGE>
   <HISTORY>
   	Date           CR-Ref       Author             Comments
   	2011-09-01  D3-1          RJH022        First Version
	21/09/16			CR4224		CCY018		Adjust UI
	01/12/17			CR4577		CCY018		Change the text of two validation error messages
   </HISTORY>
********************************************************************/

integer li_vessel_nr, li_pcn, li_chart_nr, li_dirty_org, li_dirty, li_errcol, li_bolcount, li_dbolcount
long ll_row, ll_index, ll_count, ll_port_row, ll_findrow, ll_cargo_detail_id, ll_bol_id, ll_selectrow, ll_agent_nr, ll_cerp_id
long ll_count_L, ll_currentrow, ll_seq, ll_errrow
string ls_voyage_nr, ls_port_code, ls_ld, ls_layout, ls_grade, ls_grade_group, ls_findstr, ls_group_org, ls_arr_port[]
string ls_cargo_desc, ls_errmsg
string ls_message
boolean lb_found, lb_newrow
dwitemstatus ldws_status, ldws_groupstatus
n_service_manager	lnv_svcmgr
n_dw_validation_service 	lnv_validation
mt_n_stringfunctions ln_strfun

ib_accepttext = true
if dw_cargo_detail_list.accepttext()<> 1 then 
	ib_accepttext = false
	dw_cargo_detail_list.setfocus()	
	return c#return.Failure
end if
ib_accepttext = false

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_port_row < 1 then return c#return.Failure

lnv_svcmgr.of_loadservice( lnv_validation, "n_dw_validation_service")
lnv_validation.of_registerrulestring("l_d", true, "L/D")
lnv_validation.of_registerrulestring("cargo_desc", true, "Calculation Cargo")
lnv_validation.of_registerrulestring("layout", true, "Layout")
lnv_validation.of_registerrulestring("grade_property", true, "Grade")
lnv_validation.of_registerruledecimal("cd_mtbe_etbe", false, 0, 100, "MTBE/ETBE/ATBE")
lnv_validation.of_registerruledecimal("cd_bio", false, 0, 100, "Bio")

if lnv_validation.of_validate(dw_cargo_detail_list, ls_message, ll_errrow, li_errcol) = c#return.Failure then 
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, ls_message, parent)
	dw_cargo_detail_list.setfocus()
	dw_cargo_detail_list.setrow(ll_errrow)
	dw_cargo_detail_list.scrolltorow(ll_errrow)
	if dw_cargo_detail_list.describe("#" + string(li_errcol) + ".Name") = "cargo_desc" then
		if ll_errrow > 0 then
			if dw_cargo_detail_list.getitemstring(ll_errrow, "l_d") = "L" then
				dw_cargo_detail_list.setcolumn("cd_cal_caio_id")
			else
				dw_cargo_detail_list.setcolumn("load_cargo_detail_id")
			end if
		end if
	else
		dw_cargo_detail_list.setcolumn(li_errcol)
	end if
	
	return c#return.Failure
end if

li_vessel_nr = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_vessel_nr")
ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")

for ll_row = 1 to dw_cargo_detail_list.rowcount()
	ls_ld = dw_cargo_detail_list.getitemstring(ll_row, "l_d")
	ldws_status = dw_cargo_detail_list.getitemstatus(ll_row, 0, primary!)
	ldws_groupstatus = dw_cargo_detail_list.getitemstatus(ll_row, "grade_group", primary!)
	ls_layout = dw_cargo_detail_list.getitemstring(ll_row, "layout")
	ls_grade = dw_cargo_detail_list.getitemstring(ll_row, "grade_name")
	ls_grade_group = dw_cargo_detail_list.getitemstring(ll_row, "grade_group", primary!, false)
	ls_group_org = dw_cargo_detail_list.getitemstring(ll_row, "grade_group", primary!, true)
	ll_agent_nr = dw_cargo_detail_list.getitemnumber(ll_row, "agent_nr")
	ll_cerp_id = dw_cargo_detail_list.getitemnumber(ll_row, "cd_cal_cerp_id")
	li_chart_nr = dw_cargo_detail_list.getitemnumber(ll_row, "chart_nr")
	ll_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_row, "cargo_detail_id")
	ls_cargo_desc = dw_cargo_detail_list.getitemstring(ll_row, "cargo_desc")
	
	if ldws_status = notmodified! then continue
	
	ls_findstr = "l_d='" + ls_ld + "' and cd_cal_cerp_id = " + string(ll_cerp_id) + " and chart_nr = " + string(li_chart_nr) + " and agent_nr = " + string(ll_agent_nr)
	ls_findstr += " and grade_name = '" + ls_grade +  "' and layout = '" + ls_layout + "' and getrow() <> " + string(ll_row)
	ll_findrow = dw_cargo_detail_list.find(ls_findstr, 1, dw_cargo_detail_list.rowcount())
	
	if ll_findrow > 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You are attempting to create a duplicate!", parent)
		return c#return.Failure
	end if
	
	if ls_ld = "L" then
		SELECT COUNT(*)
		INTO :ll_count_L
		FROM CD
		WHERE CD.VESSEL_NR = :li_vessel_nr
		AND CD.VOYAGE_NR = :ls_voyage_nr
		AND CD.CHART_NR = :li_chart_nr
		AND CD.AGENT_NR = :ll_agent_nr
		AND CD.LAYOUT = :ls_layout
		AND CD.GRADE_NAME = :ls_grade
		AND CD.L_D = "L"
		AND CD.CARGO_DETAIL_ID <> :ll_cargo_detail_id;
		
		if ll_count_L <> 0 then
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The layout has been used before, please input another layout!", parent)
			dw_cargo_detail_list.setfocus()
			dw_cargo_detail_list.setrow(ll_row)
			dw_cargo_detail_list.scrolltorow(ll_row)
			dw_cargo_detail_list.setcolumn("layout")
			return c#return.Failure
		end if
		
		if ldws_status = DataModified! and ldws_groupstatus = DataModified! and ls_grade_group <> ls_group_org then
			SELECT DIRTY_PRODUCT into :li_dirty_org 
			FROM GROUPS
			WHERE GRADE_GROUP = :ls_group_org;
			
			SELECT DIRTY_PRODUCT into :li_dirty
			FROM GROUPS
			WHERE GRADE_GROUP = :ls_grade_group;
			
			if not (li_dirty_org = 0 and li_dirty = 1) then continue
			
			ls_errmsg = "The Grade you have selected requires Cargo Temperature to be entered in the related Bill(s) of Lading in all load and discharge ports. &
					~r~n~r~nCancel the Grade change and enter Cargo Temperature on all related Bill(s) of Lading before selecting this Grade."
			
			SELECT COUNT(1) INTO :li_bolcount
			FROM BOL 
			WHERE CARGO_DETAIL_ID = :ll_cargo_detail_id
			AND CARGO_TEMP IS NULL;
			
			SELECT COUNT(1) INTO :li_dbolcount
			FROM CD, BOL
			WHERE CD.L_D = 'D'
			AND CD.LOAD_CARGO_DETAIL_ID = :ll_cargo_detail_id
			AND BOL.CARGO_DETAIL_ID = CD.CARGO_DETAIL_ID
			AND CARGO_TEMP IS NULL;
			if li_bolcount > 0 or li_dbolcount > 0 then
				inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, ls_errmsg, parent)
				dw_cargo_detail_list.setfocus()
				dw_cargo_detail_list.setrow(ll_row)
				dw_cargo_detail_list.scrolltorow(ll_row)
				dw_cargo_detail_list.setcolumn("grade_property")
				return c#return.Failure
			end if

		end if
		
	end if
next

dw_cargo_detail_list.event ue_changelayoutgrade()

lb_newrow = false
ll_selectrow = dw_cargo_detail_list.getselectedrow(0)
if ll_selectrow > 0 then
	ldws_status = dw_cargo_detail_list.getitemstatus(ll_selectrow, 0, primary!)
	if ldws_status = new! or ldws_status = newmodified! then lb_newrow = true
end if

idw_focus = dw_poc_list_for_cargo
if dw_cargo_detail_list.update() = 1 then
	commit;
	
	//refresh cargo
	ll_selectrow = dw_cargo_detail_list.getselectedrow(0)
	if ll_selectrow > 0 then
		ll_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_selectrow, "cargo_detail_id")
		
		if lb_newrow then
			dw_bol.setfilter("cargo_detail_id = " + string(ll_cargo_detail_id))
		end if
	end if
	
	dw_cargo_detail_list.setredraw(false)
	dw_bol.setredraw(false)
	
	dw_cargo_detail_list.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	dw_cargo_detail_list.selectrow(0, false)
	if ll_selectrow > 0 then
		ll_findrow = dw_cargo_detail_list.find("cargo_detail_id = " + string(ll_cargo_detail_id), 1, dw_cargo_detail_list.rowcount())
		if ll_findrow > 0 then
			ll_currentrow = dw_cargo_detail_list.getrow()
			dw_cargo_detail_list.setrow(ll_findrow)
			dw_cargo_detail_list.scrolltorow(ll_findrow)
			if ll_currentrow = ll_findrow then dw_cargo_detail_list.event rowfocuschanged(ll_findrow)
		end if
	end if
	
	dw_cargo_detail_list.setredraw(true)
	
	//refresh bol
	ll_selectrow = dw_bol.getselectedrow(0)
	if ll_selectrow > 0 then
		ll_bol_id = dw_bol.getitemnumber(ll_selectrow, "bol_id")
	end if	
	
	dw_bol.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	dw_bol.selectrow(0, false)
	if ll_selectrow > 0 then
		ll_findrow = dw_bol.find("bol_id = " + string(ll_bol_id), 1, dw_bol.rowcount())
		if ll_findrow > 0 then
			ll_currentrow = dw_cargo_detail_list.getrow()
			dw_bol.setrow(ll_findrow)
			dw_bol.scrolltorow(ll_findrow)
			if ll_currentrow = ll_findrow then dw_bol.event rowfocuschanged(ll_findrow)
		end if
	end if
	
	dw_bol.setredraw(true)
	
	wf_seteditmode(true, dw_cargo_detail_list)
else
	rollback;
end if

return c#return.Success

end event

type cb_new_bol from mt_u_commandbutton within w_cargo
integer x = 3122
integer y = 2116
integer taborder = 150
boolean bringtotop = true
boolean enabled = false
string text = "Ne&w"
end type

event clicked;
if dw_cargo_detail_list.getselectedrow (0) < 1 then return

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.setfocus()
	return
end if

ib_accepttext = true
if dw_bol.accepttext() <> 1 then
	ib_accepttext = false
	dw_bol.setfocus()	
	return 
end if
ib_accepttext = false

parent.triggerevent("ue_insert")

parent.postevent("ue_refresh_totals")

end event

type cb_update_bol from mt_u_commandbutton within w_cargo
integer x = 3470
integer y = 2116
integer taborder = 160
boolean bringtotop = true
boolean enabled = false
string text = "&Update"
end type

event clicked;integer li_return

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return c#return.Failure
end if

li_return = parent.event ue_update(message.wordparm, message.longparm)
parent.PostEvent("ue_refresh_totals")

return li_return
end event

type cb_new_agent from mt_u_commandbutton within w_cargo
integer x = 2578
integer y = 732
integer taborder = 50
boolean bringtotop = true
boolean enabled = false
string text = "&New"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_cargo
  
 Object     : cb_new_agent
  
 Event	 : clicked

 Scope     : Local

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 16-07-96

 Description : This event new a row, so that user
can choose a charterer and an agent for a cargo discharge or load.

 Arguments : none

 Returns   : none

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-07-96 		3.0		 	PBT		Modified for version 3
31-07-96		3.0			PBT		System 3
21/09/16			CR4224		CCY018		Adjust UI
************************************************************************************/

string ls_find_str, ls_voyage_nr, ls_port_code, ls_agent_name, ls_purpose_code
long ll_port_row, ll_newrow, ll_cal_calc_id, ll_agent_nr, ll_default_agent_nr
int li_vessel_nr, li_pcn, li_voyage_type
decimal{2} ld_max_amount
datawindowchild ldwc_chart

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.setfocus()
	return
end if

ib_accepttext = true
if dw_cargo_list.accepttext() = -1 then
	ib_accepttext = false
	dw_cargo_list.setfocus()	
	return
end if
ib_accepttext = false

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_port_row < 1 then return

li_vessel_nr = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_vessel_nr")
ls_voyage_nr = dw_poc_list_for_cargo.getItemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")
ls_purpose_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_purpose_code")
ll_cal_calc_id = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "voyages_cal_calc_id")

SELECT VOYAGE_TYPE 
INTO :li_voyage_type
FROM VOYAGES
WHERE VESSEL_NR = :li_vessel_nr
AND VOYAGE_NR = :ls_voyage_nr;

wf_refreshchartdddw(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, ls_purpose_code, ll_cal_calc_id, li_voyage_type)

idw_focus = dw_cargo_list
ll_newrow = dw_cargo_list.insertrow(0)
dw_cargo_list.setrow(ll_newrow)
dw_cargo_list.scrolltorow(ll_newrow)

dw_cargo_list.setitem(ll_newrow, "vessel_nr", li_vessel_nr)
dw_cargo_list.setitem(ll_newrow, "voyage_nr", ls_voyage_nr)
dw_cargo_list.setitem(ll_newrow, "port_code", ls_port_code)
dw_cargo_list.setitem(ll_newrow, "pcn", li_pcn)

if dw_cargo_list.getchild("chart_nr", ldwc_chart) <> 1 then return
if ldwc_chart.rowcount() = 1 then
	dw_cargo_list.setitem(ll_newrow, "chart_nr", ldwc_chart.getitemnumber(1, "chart_chart_nr"))
	dw_cargo_list.setitem(ll_newrow, "chart_chart_sn", ldwc_chart.getitemstring(1, "chart_chart_sn"))
	dw_cargo_list.setitem(ll_newrow, "cal_cerp_description", ldwc_chart.getitemstring(1, "cal_cerp_cal_cerp_description"))
	dw_cargo_list.setitem(ll_newrow, "cargo_cal_cerp_id", ldwc_chart.getitemnumber(1, "cal_cerp_cal_cerp_id"))
	dw_cargo_list.modify("chart_nr.TabSequence=0")
else
	dw_cargo_list.modify("chart_nr.TabSequence=10")
end if

ll_default_agent_nr = uo_global.ii_defaultagentnr
if not isnull(ll_default_agent_nr) and ll_default_agent_nr > 0 then 
	ll_agent_nr = ll_default_agent_nr
else
	SELECT TOP 1 SUM(DISB_PAYMENTS.PAYMENT_AMOUNT), DISB_PAYMENTS.AGENT_NR
	INTO :ld_max_amount, :ll_agent_nr
	FROM DISB_PAYMENTS  , AGENTS
	WHERE ( DISB_PAYMENTS.VESSEL_NR = :li_vessel_nr ) AND  
				( DISB_PAYMENTS.VOYAGE_NR = :ls_voyage_nr ) AND  
				( DISB_PAYMENTS.PORT_CODE = :ls_port_code) AND  
				( DISB_PAYMENTS.PCN = :li_pcn)   
	GROUP BY DISB_PAYMENTS.VESSEL_NR, DISB_PAYMENTS.VOYAGE_NR, DISB_PAYMENTS.PORT_CODE, DISB_PAYMENTS.PCN, DISB_PAYMENTS.AGENT_NR
	ORDER BY SUM(DISB_PAYMENTS.PAYMENT_AMOUNT) DESC ;
	
	if not isnull(ll_agent_nr) and ll_agent_nr > 0 then
		if not f_agent_active(ll_agent_nr) then ll_agent_nr = 0
	end if
end if
	

if not isnull(ll_agent_nr) and ll_agent_nr > 0 then
	dw_cargo_list.setitem(ll_newrow, "agent_nr", ll_agent_nr)
	dw_cargo_list.event ue_refreshdddw()
end if
	
if not ib_lockwindow  then
	wf_seteditmode(false, dw_cargo_list)
end if

dw_cargo_list.setfocus()
if ldwc_chart.rowcount() = 1 then
	dw_cargo_list.setcolumn("agent_nr")
else
	dw_cargo_list.setcolumn("chart_nr")
end if


	
end event

type dw_poc_list_for_cargo from uo_datawindow within w_cargo
integer x = 37
integer y = 264
integer width = 2034
integer height = 584
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_poc_list_for_cargo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;
string 	ls_voyage_nr, ls_port_code
int 		li_pcn, li_voyage_type
long     ll_cal_calc_id
boolean lb_autocommit

/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

if row < 1 then return

this.setfocus() 

dw_cargo_list.reset()
dw_cargo_detail_list.reset()
dw_bol.reset()

this.setrow(row)
this.scrolltorow(row)
this.selectrow(0, false)
this.selectrow(row, true)

ls_voyage_nr = this.getitemstring(row, "poc_voyage_nr")
ls_port_code = this.getitemstring(row, "poc_port_code")
li_pcn = this.getitemnumber(row, "poc_pcn")
is_purpose_code= this.getitemstring(row, "poc_purpose_code")
ll_cal_calc_id = this.getitemnumber(row, "voyages_cal_calc_id")

SELECT VOYAGE_TYPE 
INTO :li_voyage_type
FROM VOYAGES
WHERE VESSEL_NR = :ii_vessel_nr
AND VOYAGE_NR = :ls_voyage_nr;

wf_setcargocolumns()

if ii_pre_vesselnr <> ii_vessel_nr or is_voyage_nr <> ls_voyage_nr then
	if li_voyage_type <> 2 and ll_cal_calc_id > 1 then
		ids_itin_proceed.setfilter("")
		ids_itin_proceed.retrieve(ii_vessel_nr,ls_voyage_nr)
	end if
	
	ii_pre_vesselnr = ii_vessel_nr
end if

dw_cargo_detail_list.setfilter("")
dw_bol.setfilter("")
 
 dw_cargo_list.setredraw(false)
 dw_cargo_detail_list.setredraw(false)
 dw_bol.setredraw(false)
 
if dw_cargo_list.retrieve(ii_vessel_nr,ls_voyage_nr,ls_port_code,li_pcn) > 0 then
	if dw_cargo_detail_list.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn) > 0 then
		dw_bol.Retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn) 
	end if
end if

dw_cargo_list.selectrow(0, false)
dw_cargo_detail_list.selectrow(0, false)
dw_bol.selectrow(0, false)

 dw_cargo_list.setredraw(true)
 dw_cargo_detail_list.setredraw(true)
 dw_bol.setredraw(true)

wf_seteditmode(true, dw_poc_list_for_cargo)

dw_poc_list_for_cargo.setfocus()

if ii_pre_vesselnr <> ii_vessel_nr or is_voyage_nr <> ls_voyage_nr then
	parent.PostEvent("ue_refresh_totals")
end if

end event

event buttonclicked;call super::buttonclicked;integer li_port_order, li_voyage_type, li_chart_nr
long ll_findrow, ll_agent_nr, ll_caio_id[], ll_cerp_id[]
string ls_cptext
s_cargo_discharge lst_cargo
mt_n_datastore lds_cerp
u_jump_claims luo_jump_claims

if row < 1 then return
if uo_global.ii_access_level = c#usergroup.#EXTERNAL_APM then return
if dwo.name <> "b_disch" then return

lst_cargo.vessel_nr = this.getitemnumber(row, "poc_vessel_nr")
lst_cargo.voyage_nr = this.getItemstring(row, "poc_voyage_nr")
lst_cargo.port_code = this.getItemstring(row, "poc_port_code")
lst_cargo.pcn = this.getitemnumber(row, "poc_pcn")

SELECT PROCEED.PORT_ORDER, VOYAGES.VOYAGE_TYPE INTO :lst_cargo.port_order, :li_voyage_type
FROM PROCEED, VOYAGES
WHERE VOYAGES.VESSEL_NR = PROCEED.VESSEL_NR
AND VOYAGES.VOYAGE_NR = PROCEED.VOYAGE_NR
AND PROCEED.VESSEL_NR = :lst_cargo.vessel_nr
AND PROCEED.VOYAGE_NR = :lst_cargo.voyage_nr
AND PROCEED.PORT_CODE = :lst_cargo.port_code
AND PROCEED.PCN = :lst_cargo.pcn;

lds_cerp = create mt_n_datastore
lds_cerp.dataobject = "d_sq_gr_cargo_portcerplist"
lds_cerp.settransobject( sqlca)

if li_voyage_type <> 2 then
	ids_itin_proceed.setfilter("port_code = '" + lst_cargo.port_code + "' and pcn = " + string(lst_cargo.pcn))
	ids_itin_proceed.filter()
	if ids_itin_proceed.rowcount( ) > 0 then
		ll_caio_id = ids_itin_proceed.object.cal_caio_id.primary.current
		lds_cerp.retrieve(ll_caio_id)
		if lds_cerp.rowcount() > 0 then
			ll_cerp_id = lds_cerp.object.cal_carg_cal_cerp_id.primary.current
		end if
	end if
	
	if dw_cargo_list.rowcount() > 0 then
		if dw_cargo_list.rowcount() = 1 then
			ll_agent_nr = dw_cargo_list.getitemnumber(1, "agent_nr")
		else
			if upperbound(ll_cerp_id) > 0 then
				ll_findrow = dw_cargo_list.find("cargo_cal_cerp_id = " + string(ll_cerp_id[1]), 1, dw_cargo_list.rowcount())
				if ll_findrow = 0 then
					ll_agent_nr = dw_cargo_list.getitemnumber(1, "agent_nr")
				else 
					ll_agent_nr = dw_cargo_list.getitemnumber(ll_findrow, "agent_nr")
				end if
			end if
		end if
	end if
else
	wf_getcontractinfo(lst_cargo.vessel_nr, lst_cargo.voyage_nr, lst_cargo.port_code, lst_cargo.pcn, li_chart_nr, ls_cptext)
	lst_cargo.chart_nr = li_chart_nr
	
	if dw_cargo_list.rowcount() > 0 then
		ll_agent_nr = dw_cargo_list.getitemnumber(1, "agent_nr")
	end if
end if

lst_cargo.agent_nr = ll_agent_nr

if upperbound(ll_cerp_id) = 0 then ll_cerp_id[1] = 0
lst_cargo.cerp_id = ll_cerp_id

lst_cargo.jump_chartnr = 0
lst_cargo.return_flag = 0
openwithparm(w_cargo_dischage, lst_cargo)

lst_cargo = message.powerobjectparm
if not isvalid(lst_cargo) then return

if lst_cargo.return_flag = 1 then
	this.event clicked(0, 0, row, this.object)
	parent.PostEvent("ue_refresh_totals")
	
	if lst_cargo.jump_chartnr > 0 then
		if messageBox("Information", "The difference between the Load and Discharge Temperature is more~r~n" &
										+"than specified allowance.~r~n~r~nLoad Temp: ~t"+string(lst_cargo.min_temp) &
										+"~r~nDisch. Temp: ~t"+string(lst_cargo.max_temp) &
										+"~r~nAllowance: ~t"+string(lst_cargo.diff_temp ) &
										+"~r~n~r~nWould you like to jump to the Claims Module and create a Heating Claim now?",Question!,YesNo!,1) = 1 then
			luo_jump_claims = CREATE u_jump_claims
			luo_jump_claims.of_createHeatingClaim(lst_cargo.vessel_nr, lst_cargo.voyage_nr, lst_cargo.jump_chartnr) 
			DESTROY luo_jump_claims
		end if
	end if
end if
end event

event getfocus;call super::getfocus;idw_focus = this
end event

type cb_cancel_cargo from mt_u_commandbutton within w_cargo
integer x = 4165
integer y = 1352
integer taborder = 130
boolean bringtotop = true
boolean enabled = false
string text = "&Cancel"
end type

event clicked;integer li_pcn
long ll_port_row, ll_row, ll_findrow, ll_cargo_detail_id, ll_currentrow
string ls_voyage_nr, ls_port_code
dwitemstatus ldws_status

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_port_row < 1 then return

idw_focus = dw_poc_list_for_cargo

ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")

ll_row = dw_cargo_detail_list.getselectedrow(0)
if ll_row > 0 then
	ldws_status = dw_cargo_detail_list.getitemstatus(ll_row, 0, primary!)
	ll_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_row, "cargo_detail_id")
end if

dw_cargo_detail_list.setredraw(false)

dw_cargo_detail_list.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
if ldws_status = new! or ldws_status = newmodified! then
	ll_findrow = 0
else
	ll_findrow = dw_cargo_detail_list.find("cargo_detail_id = " + string(ll_cargo_detail_id), 1, dw_cargo_detail_list.rowcount())
end if

dw_cargo_detail_list.selectrow(0, false)
if ll_findrow > 0 then
	ll_currentrow = dw_cargo_detail_list.getrow()
	dw_cargo_detail_list.scrolltorow(ll_findrow)
	if ll_currentrow = ll_findrow then dw_cargo_detail_list.event rowfocuschanged(ll_findrow)
end if

dw_cargo_detail_list.setredraw(true)

wf_seteditmode(true, dw_cargo_detail_list)

dw_poc_list_for_cargo.setfocus()
end event

type cb_delete_charter from mt_u_commandbutton within w_cargo
integer x = 3273
integer y = 732
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string text = "De&lete"
end type

event clicked;//
string ls_purpose_code, ls_voyage_nr, ls_port_code, ls_errtext
string ls_description, ls_pre_description, ls_description_str, ls_portname, ls_pre_portname, ls_portname_str
int li_vessel_nr, li_pcn, li_chart_nr, li_claim_nr
n_calc_demurrage lnv_calc_demurrage
boolean lb_onlyone = false
long ll_row, ll_find, ll_agent_nr, ll_cerp_id, ll_index, ll_count, ll_port_row
mt_n_datastore lds_loadcargo
dwitemstatus ldws_status

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
ll_row = dw_cargo_list.getSelectedRow (0)
if ll_port_row < 1 or ll_row < 1 then 
	return
end if

idw_focus = dw_poc_list_for_cargo

ldws_status = dw_cargo_list.getitemstatus(ll_row, 0, primary!)
if ldws_status = new! or ldws_status = newmodified! then
	dw_cargo_list.setredraw(false)
	dw_cargo_list.deleterow(ll_row)
	dw_cargo_list.selectrow(0, false)
	dw_cargo_list.setredraw(true)
	
	if dw_cargo_list.modifiedcount() > 0 then
		wf_seteditmode(false, dw_cargo_list)
	else
		wf_seteditmode(true, dw_cargo_list)
	end if
		
	dw_poc_list_for_cargo.setfocus()
	return
end if

li_vessel_nr = dw_cargo_list.getitemnumber(ll_row, "vessel_nr")
ls_voyage_nr = dw_cargo_list.getitemstring(ll_row, "voyage_nr")
ls_port_code = dw_cargo_list.getitemstring(ll_row, "port_code")
li_pcn = dw_cargo_list.getitemnumber(ll_row, "pcn")
li_chart_nr = dw_cargo_list.getitemnumber(ll_row, "chart_nr")
ll_agent_nr = dw_cargo_list.getitemnumber(ll_row, "agent_nr")
ll_cerp_id = dw_cargo_list.getitemnumber(ll_row, "cargo_cal_cerp_id")

ls_purpose_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_purpose_code")

ll_count = 0
if ls_purpose_code <> "D" then
	lds_loadcargo = create mt_n_datastore
	lds_loadcargo.dataobject = "d_sq_gr_chart_loadtodischargelist"
	lds_loadcargo.settransobject( sqlca)
	lds_loadcargo.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, ll_cerp_id, li_chart_nr, ll_agent_nr)
	ll_count = lds_loadcargo.rowcount()
	
	if ll_count > 0 then
		for ll_index = 1 to ll_count
			ls_description = lds_loadcargo.getitemstring(ll_index, "carg_description")
			if ls_pre_description <> ls_description then
				if ls_description_str = "" then
					ls_description_str = ls_description
				else
					ls_description_str += ", " + ls_description
				end if
				
				ls_pre_description = ls_description
			end if
		next
		
		lds_loadcargo.setsort("ports_port_n")
		lds_loadcargo.sort()
		for ll_index = 1 to ll_count
			ls_portname = lds_loadcargo.getitemstring(ll_index, "ports_port_n")
			if ls_pre_portname <> ls_portname then
				if ls_portname_str = "" then
					ls_portname_str = ls_portname
				else
					ls_portname_str += ", " + ls_portname
				end if
				
				ls_pre_portname = ls_portname
			end if
		next
		
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, "The Cargo Grade(s) " + ls_description_str + " has/have already been discharged in port(s) " + ls_portname_str + ". You need to delete them first to continue.", parent)
		destroy lds_loadcargo
		return
	end if
	
	destroy lds_loadcargo
end if

if ll_count = 0 then
	SELECT COUNT(1) INTO :ll_count
	FROM CD
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND PORT_CODE = :ls_port_code
	AND PCN = :li_pcn
	AND CAL_CERP_ID = :ll_cerp_id
	AND CHART_NR = :li_chart_nr
	AND AGENT_NR = :ll_agent_nr;

	if ll_count > 0 then 
		if messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "There exists at least one Cargo Grade for this Charterer/Agent, which will also be deleted.~r~n~r~nDo you want to continue?", Exclamation!, YesNo!, 2) = 2 then 
			return	
		end if
	else
		if inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "the selected Charterer/Agent", parent) = 2 then 
			return
		end if
	end if
end if

if dw_cargo_list.rowcount() = 1 then
	lb_onlyone = true
else
	if ll_row > 1 then
		ll_find = dw_cargo_list.find("chart_nr = " + string(li_chart_nr) , 1, ll_row - 1 )
	end if
	if ll_find = 0 then 
		if ll_row < dw_cargo_list.rowcount() then
			ll_find = dw_cargo_list.find("chart_nr = " + string(li_chart_nr) , ll_row + 1, dw_cargo_list.rowcount())
		end if
	end if
	lb_onlyone = (ll_find = 0 )
end if

if lb_onlyone = true then
	SELECT count(*) INTO :ll_count
	FROM LAYTIME_STATEMENTS 
	WHERE LAYTIME_STATEMENTS.VESSEL_NR = :li_vessel_nr AND
			LAYTIME_STATEMENTS.VOYAGE_NR = :ls_voyage_nr AND
			LAYTIME_STATEMENTS.PORT_CODE = :ls_port_code AND
			LAYTIME_STATEMENTS.PCN = :li_pcn AND
			LAYTIME_STATEMENTS.CHART_NR = :li_chart_nr;
			
	if ll_count > 0 then
		if messagebox("Confirm delete", "Entered laytime will be lost.~r~n~r~nDo you want to continue?", Exclamation!, YesNo!, 2) = 2 then 
			return
		end if
		  
		SELECT CLAIM_NR  INTO :li_claim_nr 
		FROM DEM_DES_CLAIMS 
		WHERE VESSEL_NR = :li_vessel_nr  AND VOYAGE_NR = :ls_voyage_nr  AND CHART_NR = :li_chart_nr; 
		  
		/* Laytime deduction */
		DELETE FROM LAY_DEDUCTIONS 
		WHERE VESSEL_NR = :li_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr AND
				PORT_CODE = :ls_port_code AND
				PCN = :li_pcn  AND
			    CHART_NR = :li_chart_nr ;
		if sqlca.sqlcode <> 0 then
			ls_errtext = sqlca.sqlerrtext
			rollback;
			messageBox("Error", "Delete failed." + ls_errtext)
			return
		end if
				 
		/* Laytime Statements */
		DELETE FROM LAYTIME_STATEMENTS 
		WHERE VESSEL_NR = :li_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr AND
				PORT_CODE = :ls_port_code AND
				PCN = :li_pcn  AND
				CHART_NR = :li_chart_nr;  
				
		if sqlca.sqlcode <> 0 then
			ls_errtext = sqlca.sqlerrtext
			rollback;
			messageBox("Error", "Delete failed." + ls_errtext)
			return
		end if
		
		lnv_calc_demurrage.of_recalc_demurrage(li_vessel_nr, ls_voyage_nr, ls_port_code , li_chart_nr, li_claim_nr)  
	end if
end if

DELETE FROM BOL
WHERE CARGO_DETAIL_ID IN (SELECT CARGO_DETAIL_ID FROM CD
										WHERE VESSEL_NR = :li_vessel_nr
										AND VOYAGE_NR = :ls_voyage_nr
										AND PORT_CODE = :ls_port_code
										AND PCN = :li_pcn
										AND CAL_CERP_ID = :ll_cerp_id
										AND CHART_NR = :li_chart_nr
										AND AGENT_NR = :ll_agent_nr);

if sqlca.sqlcode = 0 then
	DELETE FROM CD_ATT WHERE CARGO_DETAIL_ID IN (SELECT CARGO_DETAIL_ID FROM CD
											WHERE VESSEL_NR = :li_vessel_nr
											AND VOYAGE_NR = :ls_voyage_nr
											AND PORT_CODE = :ls_port_code
											AND PCN = :li_pcn
											AND CAL_CERP_ID = :ll_cerp_id
											AND CHART_NR = :li_chart_nr
											AND AGENT_NR = :ll_agent_nr);
else
	ls_errtext = sqlca.sqlerrtext
end if

if sqlca.sqlcode = 0 then
	DELETE FROM CD
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND PORT_CODE = :ls_port_code
	AND PCN = :li_pcn
	AND CAL_CERP_ID = :ll_cerp_id
	AND CHART_NR = :li_chart_nr
	AND AGENT_NR = :ll_agent_nr;
else
	ls_errtext = sqlca.sqlerrtext
end if

if sqlca.sqlcode = 0 then	
	DELETE FROM CARGO
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND PORT_CODE = :ls_port_code
	AND PCN = :li_pcn
	AND CAL_CERP_ID = :ll_cerp_id
	AND CHART_NR = :li_chart_nr
	AND AGENT_NR = :ll_agent_nr;
else
	ls_errtext = sqlca.sqlerrtext
end if
		
if sqlca.sqlcode = 0 then
	commit;
	
	dw_cargo_list.setredraw(false)
	dw_cargo_detail_list.setredraw(false)
	dw_bol.setredraw(false)
	
	dw_cargo_list.rowsdiscard(ll_row, ll_row, primary!)
	dw_cargo_detail_list.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	dw_bol.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	
	dw_cargo_list.selectrow(0, false)
	dw_cargo_detail_list.selectrow(0, false)
	dw_bol.selectrow(0, false)
	
	dw_cargo_list.setredraw(true)
	dw_cargo_detail_list.setredraw(true)
	dw_bol.setredraw(true)
	
	if dw_cargo_list.modifiedcount() > 0 then
		wf_seteditmode(false, dw_cargo_list)
	else
		wf_seteditmode(true, dw_cargo_list)
	end if
	
	parent.postevent("ue_refresh_totals")
else
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messageBox("Error", "Delete failed." + ls_errtext)
end if
	
dw_poc_list_for_cargo.setfocus()
end event

type gb_1 from groupbox within w_cargo
event ue_rbuttondown pbm_rbuttondown
integer x = 4023
integer y = 256
integer width = 530
integer height = 384
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Voyage Totals"
end type

event ue_rbuttondown;wf_showpctcdw(xpos, ypos)
end event

type cb_refresh from mt_u_commandbutton within w_cargo
integer x = 4210
integer y = 32
integer taborder = 20
boolean bringtotop = true
string text = "&Refresh"
end type

event clicked;/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

ii_pre_vesselnr = 0
parent.event ue_vesselselection( ii_vessel_nr )

end event

type gb_3 from groupbox within w_cargo
integer x = 2103
integer y = 264
integer width = 1897
integer height = 588
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Charterer"
end type

type cb_delete_bol from mt_u_commandbutton within w_cargo
integer x = 3817
integer y = 2116
integer taborder = 170
boolean enabled = false
string text = "&Delete"
boolean cancel = true
end type

event clicked;
/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

parent.triggerevent("ue_delete")
parent.postevent("ue_refresh_totals")


 
end event

type st_background from u_topbar_background within w_cargo
integer width = 4590
integer height = 232
end type

type cb_new_cargo from mt_u_commandbutton within w_cargo
integer x = 3122
integer y = 1352
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string text = "N&ew"
end type

event clicked;
integer li_vessel_nr, li_chart_nr, li_pcn, li_cp_charter
string	ls_voyage_nr, ls_port_code, ls_purpose_code, ls_l_d, ls_filter, ls_sql_str, ls_group, ls_grade
long 		ll_row, ll_newrow, ll_ret_code, ll_find_row, ll_cerp_id, ll_agent_nr, ll_caio_id
long ll_count_l, ll_count_d, ll_caioid_array[]
boolean	lb_rev
datawindowchild ldwc_cargo
mt_n_datastore lds_cargo

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.setfocus()
	return
end if

ib_accepttext = true
if dw_cargo_detail_list.accepttext()<> 1 then 
	ib_accepttext = false
	dw_cargo_detail_list.setfocus()
	return
end if
ib_accepttext = false

ll_row = dw_cargo_list.getselectedrow(0)
if ll_row < 1 then return 
 
li_vessel_nr = dw_cargo_list.getitemnumber(ll_row, "vessel_nr")
ls_voyage_nr = dw_cargo_list.getitemstring(ll_row, "voyage_nr")
ls_port_code = dw_cargo_list.getitemstring(ll_row, "port_code")
li_pcn = dw_cargo_list.getItemnumber(ll_row, "pcn")
ll_cerp_id = dw_cargo_list.getitemnumber(ll_row, "cargo_cal_cerp_id")
ll_agent_nr = dw_cargo_list.getitemnumber(ll_row, "agent_nr")
li_chart_nr = dw_cargo_list.getitemnumber(ll_row, "chart_nr")
ls_purpose_code = dw_poc_list_for_cargo.getitemstring(dw_poc_list_for_cargo.getselectedrow(0), "poc_purpose_code")

if ll_cerp_id > 1 then
	SELECT CAL_CERP.CAL_CERP_REV_DEM, CAL_CERP.CHART_NR
	INTO :lb_rev, :li_cp_charter
	FROM CAL_CERP  
	WHERE CAL_CERP.CAL_CERP_ID = :ll_cerp_id ;
	
	if not lb_rev and dw_cargo_detail_list.rowcount() > 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, "This cargo is connected to a non-reversible CP in the." + &
					"calculation module." + &
					"You can therefore not create more than one Cargo per charterer" +&
					"for this port. You must create an extra Port of Call.", parent)
		return
	end if
	
	// CR3148 charterter has been changed during this window(w_cargo) is opened
	if li_chart_nr <> li_cp_charter then
		li_chart_nr = li_cp_charter
	end if
end if

//idw_focus = dw_cargo_detail_list
dw_cargo_detail_list.setfocus()
ll_newrow = dw_cargo_detail_list.insertrow(0)
dw_cargo_detail_list.setrow(ll_newrow)
dw_cargo_detail_list.scrolltorow(ll_newrow)

if ls_purpose_code = "L/D" and ll_cerp_id > 1 then
	ls_filter = "port_code = '" + ls_port_code + "' and pcn = " + string(li_pcn)
	ids_itin_proceed.setfilter(ls_filter)
	ids_itin_proceed.filter()
	if ids_itin_proceed.rowcount( ) > 0 then
		ll_caioid_array = ids_itin_proceed.object.cal_caio_id.primary.current
		
		lds_cargo = create mt_n_datastore
		lds_cargo.dataobject = "d_dddw_cargo_detail_choice_list"
		lds_cargo.settransobject(sqlca)
		ll_count_l = lds_cargo.retrieve(ll_caioid_array, ll_cerp_id) 
		
		ls_sql_str = "SELECT CAL_CARG.CAL_CARG_DESCRIPTION, " + &   
						"CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS, " + &   
						"CAL_CAIO.CAL_CAIO_ID " + &  
						"FROM CAL_CARG, " + & 
						"		CAL_CAIO " + &
						"WHERE ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) " + &  
						"AND CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS < 0 " + &
						"AND      ( CAL_CAIO.CAL_CAIO_ID in( :aan_caio_id) ) " +&
						"AND CAL_CARG.CAL_CERP_ID = :an_cerp_id " + &
						"ORDER BY CAL_CARG.CAL_CARG_DESCRIPTION ASC "
		
		lds_cargo.modify("DataWindow.Table.Select='" + ls_sql_str + "'")
		ll_count_d = lds_cargo.retrieve(ll_caioid_array, ll_cerp_id) 
		
		if ll_count_l > 0 and ll_count_d = 0 then ls_purpose_code = "L"
		if ll_count_l = 0 and ll_count_d > 0 then ls_purpose_code = "D"

	end if
end if

if ls_purpose_code = "L/D" then 
	dw_cargo_detail_list.event ue_refreshdddw("D")
	dw_cargo_detail_list.getchild("load_cargo_detail_id", ldwc_cargo)
	if ldwc_cargo.rowcount() = 0 then ls_purpose_code = "L"
end if

if ls_purpose_code <> "L/D" then 
	dw_cargo_detail_list.setitem(ll_newrow, "l_d", ls_purpose_code)
	dw_cargo_detail_list.event ue_refreshdddw(ls_purpose_code)
	if ls_purpose_code = "L" then
		dw_cargo_detail_list.getchild("cd_cal_caio_id", ldwc_cargo)
		if ll_cerp_id > 1 then
			dw_cargo_detail_list.modify("cd_cal_caio_id.TabSequence=10")
			dw_cargo_detail_list.setcolumn("cd_cal_caio_id")
		else
			dw_cargo_detail_list.modify("cd_cal_caio_id.TabSequence=0")
			dw_cargo_detail_list.setcolumn("layout")
		end if
	else
		dw_cargo_detail_list.getchild("load_cargo_detail_id", ldwc_cargo)
		dw_cargo_detail_list.modify("load_cargo_detail_id.TabSequence=10")
		dw_cargo_detail_list.setcolumn("load_cargo_detail_id")
	end if
	//dw_cargo_detail_list.modify("l_d.TabSequence=0")
	dw_cargo_detail_list.setitem(ll_newrow, "ld_protect", 1)
else
	dw_cargo_detail_list.getchild("cd_cal_caio_id", ldwc_cargo)
	ldwc_cargo.reset()
	//dw_cargo_detail_list.modify("l_d.TabSequence=10")
	dw_cargo_detail_list.setitem(ll_newrow, "ld_protect", 0)
	dw_cargo_detail_list.post setcolumn("l_d")
end if

dw_cargo_detail_list.setitem(ll_newrow, "vessel_nr", li_vessel_nr)
dw_cargo_detail_list.setitem(ll_newrow, "voyage_nr", ls_voyage_nr)
dw_cargo_detail_list.setitem(ll_newrow, "port_code", ls_port_code)
dw_cargo_detail_list.setitem(ll_newrow, "pcn", li_pcn)
dw_cargo_detail_list.setitem(ll_newrow, "chart_nr", li_chart_nr)
dw_cargo_detail_list.setitem(ll_newrow, "agent_nr", ll_agent_nr)
dw_cargo_detail_list.setitem(ll_newrow, "cd_cal_cerp_id", ll_cerp_id)
dw_cargo_detail_list.setitem(ll_newrow, "surveyor_fig", 0)


if ldwc_cargo.rowcount() = 1 then
	if ls_purpose_code = "L" then
		dw_cargo_detail_list.setitem(ll_newrow, "cargo_desc", ldwc_cargo.getitemstring(1, "cal_carg_description"))
		dw_cargo_detail_list.setitem(ll_newrow, "cd_cal_caio_id", ldwc_cargo.getitemnumber(1, "cal_caio_id"))
		dw_cargo_detail_list.setitem(ll_newrow, "ships_fig", ldwc_cargo.getitemnumber(1, "number_of_units"))
		
		dw_cargo_detail_list.setcolumn("cd_cal_caio_id")
	else
		ls_group = ldwc_cargo.getitemstring(1, "cd_grade_group")
		ls_grade = ldwc_cargo.getitemstring(1, "cd_grade_name")
		
		dw_cargo_detail_list.setitem(ll_newrow, "cargo_desc", ldwc_cargo.getitemstring(1, "cal_carg_description"))
		dw_cargo_detail_list.setitem(ll_newrow, "cd_cal_caio_id", ldwc_cargo.getitemnumber(1, "cal_caio_id"))
		dw_cargo_detail_list.setitem(ll_newrow, "ships_fig", ldwc_cargo.getitemnumber(1, "cd_ships_fig"))
		dw_cargo_detail_list.setitem(ll_newrow, "layout", ldwc_cargo.getitemstring(1, "cd_layout"))
		dw_cargo_detail_list.setitem(ll_newrow, "grade_name", ls_grade)
		dw_cargo_detail_list.setitem(ll_newrow, "grade_group", ls_group)
		dw_cargo_detail_list.setitem(ll_newrow, "load_cargo_detail_id", ldwc_cargo.getitemnumber(1, "cd_cargo_detail_id"))
		dw_cargo_detail_list.setitem(ll_newrow, "surveyor_fig", ldwc_cargo.getitemnumber(1, "cd_surveyor_fig"))
		
		dw_cargo_detail_list.setitem(ll_newrow, "grade_property", ls_group + " " +  ls_grade) //GRADE_GROUP + ' ' + GRADE_NAME
		dw_cargo_detail_list.setitemstatus(ll_newrow, "grade_property", Primary!, NotModified!)
		
		dw_cargo_detail_list.setcolumn("load_cargo_detail_id")
	end if
	
	dw_cargo_detail_list.setitemstatus(ll_newrow, "cargo_desc", Primary!, NotModified!)
end if

if not ib_lockwindow  then
	wf_seteditmode(false, dw_cargo_detail_list)
end if

dw_cargo_detail_list.setfocus()

end event

type cb_delete_cargo from mt_u_commandbutton within w_cargo
integer x = 3817
integer y = 1352
integer taborder = 120
boolean enabled = false
string text = "Dele&te"
end type

event clicked;
integer li_pcn, li_vessel_nr
long ll_row, ll_cargodetailid
decimal{2} ld_shipsfig
long ll_calc_id, ll_count, ll_index
string ls_grade,ls_layout, ls_voyage_nr, ls_port_code, ls_ld, ls_port_str, ls_port_name, ls_errtext
dwitemstatus ldws_status
mt_n_datastore lds_cargo

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

ll_row = dw_cargo_detail_list.getselectedrow(0) 
if ll_row < 1 then return

idw_focus = dw_poc_list_for_cargo

ldws_status = dw_cargo_detail_list.getitemstatus(ll_row, 0, primary!)
if ldws_status = new! or ldws_status = newmodified! then
	dw_cargo_detail_list.setredraw(false)
	dw_cargo_detail_list.deleterow(ll_row)
	dw_cargo_detail_list.selectrow(0, false)
	dw_cargo_detail_list.setredraw(true)
	
	if dw_cargo_detail_list.modifiedcount() > 0 then
		wf_seteditmode(false, dw_cargo_detail_list)
	else
		wf_seteditmode(true, dw_cargo_detail_list)
	end if
	
	dw_poc_list_for_cargo.setfocus()
	return
end if

li_vessel_nr = dw_cargo_detail_list.getitemnumber(ll_row, "vessel_nr")
ls_voyage_nr = dw_cargo_detail_list.getitemstring(ll_row, "voyage_nr")
ls_port_code = dw_cargo_detail_list.getitemstring(ll_row, "port_code")
li_pcn = dw_cargo_detail_list.getitemnumber(ll_row, "pcn")
ls_layout = dw_cargo_detail_list.getitemstring(ll_row, "layout")
ls_grade  = dw_cargo_detail_list.getitemstring(ll_row, "grade_name")
ll_calc_id   = dw_cargo_detail_list.getitemnumber(ll_row, "cd_cal_cerp_id")
ll_cargodetailid = dw_cargo_detail_list.getitemnumber(ll_row, "cargo_detail_id")
ls_ld = dw_cargo_detail_list.getitemstring(ll_row, "l_d")

ll_count = 0
if ls_ld = "L" then
	lds_cargo = create mt_n_datastore
	lds_cargo.dataobject = "d_sq_gr_cargo_loadtodischarge"
	lds_cargo.settransobject(sqlca)
	ll_count = lds_cargo.retrieve(ll_cargodetailid)
	
	if ll_count > 0 then
		for ll_index = 1 to ll_count
			ls_port_name = lds_cargo.getitemstring(ll_index, "ports_port_n")
			if ls_port_str = "" then
				ls_port_str = ls_port_name
			else
				ls_port_str += ", " + ls_port_name
			end if
			
		next
		
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_GENERAL_ERROR, "This Cargo Grade has already been discharged in port(s) " + ls_port_str + ". You need to delete them first to continue.", parent)
		destroy lds_cargo
		return
	end if
	
	destroy lds_cargo
end if

if ll_count = 0 then
	SELECT COUNT(1) INTO :ll_count
	FROM BOL 
	WHERE CARGO_DETAIL_ID = :ll_cargodetailid;
	
	if ll_count > 0 then 
		if messagebox("Confirm delete", "There exists at least one Bill of Lading for this Cargo Grade, which will also be deleted.~r~n~r~nDo you want to continue?", Exclamation!, YesNo!, 2) = 2 then 
			return	
		end if
	else
		if inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_CONFIRM_DELETE, "the selected Cargo Grade", parent) = 2 then 
			return
		end if
	end if
end if

DELETE FROM CD_ATT
WHERE CARGO_DETAIL_ID = :ll_cargodetailid;

if sqlca.sqlcode = 0 then
	DELETE FROM BOL 
	WHERE CARGO_DETAIL_ID = :ll_cargodetailid;
else
	ls_errtext = sqlca.sqlerrtext
end if

if sqlca.sqlcode = 0 then
	DELETE FROM CD 
	WHERE CARGO_DETAIL_ID = :ll_cargodetailid;
else
	ls_errtext = sqlca.sqlerrtext
end if

if sqlca.sqlcode = 0 then
	commit;
	
	dw_cargo_detail_list.setredraw(false)
	dw_bol.setredraw(false)
	
	dw_cargo_detail_list.rowsdiscard(ll_row, ll_row, primary!)
	dw_bol.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	
	dw_cargo_detail_list.selectrow(0, false)
	dw_bol.selectrow(0, false)
	
	dw_cargo_detail_list.setredraw(true)
	dw_bol.setredraw(true)
	
	if dw_cargo_detail_list.modifiedcount() > 0 then
		wf_seteditmode(false, dw_cargo_detail_list)
	else
		wf_seteditmode(true, dw_cargo_detail_list)
	end if
	
	parent.postevent("ue_refresh_totals")
else
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messageBox("Error", "Delete failed." + ls_errtext)
end if

dw_poc_list_for_cargo.setfocus()
end event

type dw_cargo_detail_list from u_datagrid within w_cargo
event ue_refreshdddw ( string as_ld )
event ue_rowchanged ( long currentrow )
event ue_display_error_code ( ref dwbuffer adwbuffer,  long arow,  integer aerrorcode,  string aerrormessage )
event ue_changelayoutgrade ( )
integer x = 73
integer y = 944
integer width = 4434
integer height = 392
integer taborder = 90
string dataobject = "dw_cargo_detail_list"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event ue_refreshdddw(string as_ld);/********************************************************************
   ue_refreshdddw
   <DESC>	</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_pcn, li_vessel_nr, li_port_order, li_chart_nr
long ll_row, ll_portrow, ll_chartrow, ll_cerp_id, ll_agent_nr
long ll_caioid_array[], ll_null
string ls_voyage_nr, ls_port_code, ls_ld, ls_sql_string, ls_filter
datawindowchild	ldwc_cargo

n_service_manager lnv_serviceMgr
n_dw_style_service lnv_style

ll_row = this.getselectedrow(0)
ll_portrow = dw_poc_list_for_cargo.getselectedrow(0)
ll_chartrow = dw_cargo_list.getselectedrow(0)

if ll_row < 1 then return
if ll_portrow < 1 then return
if ll_chartrow < 1 then return

lnv_serviceMgr.of_loadservice(lnv_style, "n_dw_style_service")

li_vessel_nr = dw_poc_list_for_cargo.getitemnumber(ll_portrow, "poc_vessel_nr")
ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_portrow, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_portrow, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_portrow, "poc_pcn")
ls_ld = as_ld
if isnull(ls_ld) then return

ll_cerp_id = dw_cargo_list.getitemnumber(ll_chartrow, "cargo_cal_cerp_id")
li_chart_nr = dw_cargo_list.getitemnumber(ll_chartrow, "chart_nr")
ll_agent_nr = dw_cargo_list.getitemnumber(ll_chartrow, "agent_nr")

if ls_ld = "L" then
	if ll_cerp_id > 1 then
		this.getchild("cd_cal_caio_id", ldwc_cargo)
		ldwc_cargo.settransobject(sqlca)
		
		ls_filter = "port_code = '" + ls_port_code + "' and pcn = " + string(li_pcn)
		ids_itin_proceed.setfilter(ls_filter)
		ids_itin_proceed.filter()
		if ids_itin_proceed.rowcount( ) > 0 then
			ll_caioid_array = ids_itin_proceed.object.cal_caio_id.primary.current
		end if
		
		 if upperbound(ll_caioid_array) > 0 then
			ldwc_cargo.retrieve(ll_caioid_array, ll_cerp_id)
		end if
	else
		setnull(ll_null)
		this.getchild("cd_cal_caio_id", ldwc_cargo)
		ldwc_cargo.reset()
		ldwc_cargo.insertrow(0)
		ldwc_cargo.setitem(1, "cal_carg_description", "No Calculation")
		ldwc_cargo.setitem(1, "number_of_units", 0)
		ldwc_cargo.setitem(1, "cal_caio_id", ll_null)
	end if
else
	SELECT PORT_ORDER INTO :li_port_order
	FROM PROCEED
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND PORT_CODE = :ls_port_code
	AND PCN = :li_pcn;
	
	this.getchild("load_cargo_detail_id", ldwc_cargo)
	ldwc_cargo.settransobject(sqlca)
	ldwc_cargo.retrieve(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, li_port_order, ll_cerp_id, li_chart_nr, ll_agent_nr)
end if





end event

event ue_rowchanged(long currentrow);/********************************************************************
   ue_rowchanged
   <DESC>row highlight, filter</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		currentrow
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_chart_nr
string	ls_filter, ls_find, ls_l_d
long	ll_cerp_id, ll_cargo_detail_id, ll_agent_nr, ll_findrow, ll_preselectrow, ll_load_cargo_detail_id, ll_currentrow
dwitemstatus ldws_status
datawindowchild ldwc_blno

this.selectrow(0, false)
this.selectrow(currentrow, true)

if idw_focus.classname() <> this.classname() then return
 
ll_cargo_detail_id = this.getitemnumber(currentrow, "cargo_detail_id")	
if isnull(ll_cargo_detail_id) then ll_cargo_detail_id = 0
li_chart_nr = this.getitemnumber( currentrow, "chart_nr")
ll_cerp_id = this.getitemnumber( currentrow, "cd_cal_cerp_id")
ll_agent_nr = this.getitemnumber( currentrow, "agent_nr")
ll_load_cargo_detail_id = this.getitemnumber( currentrow, "load_cargo_detail_id")
ls_l_d = this.getitemstring(currentrow, "l_d")

ldws_status = this.getitemstatus(currentrow, 0, primary!)
if ldws_status = New! or ldws_status = NewModified! then
	ls_filter = "cargo_detail_id = " + string(ll_cargo_detail_id)
	dw_bol.setfilter(ls_filter)
	dw_bol.filter()
else
	ls_find = "chart_nr = " + string(li_chart_nr) + " and agent_nr = " + string(ll_agent_nr) + " and  cargo_cal_cerp_id = " + string(ll_cerp_id)
	ll_findrow = dw_cargo_list.find(ls_find, 1, dw_cargo_list.rowcount())
	if ll_findrow > 0 then
		if ll_findrow <> dw_cargo_list.getselectedrow(0) then
			ll_currentrow = dw_cargo_list.getrow()
			dw_cargo_list.setrow(ll_findrow)
			dw_cargo_list.scrolltorow(ll_findrow)
			if ll_currentrow = ll_findrow then dw_cargo_list.event rowfocuschanged(ll_findrow)
		end if
	else
		dw_cargo_list.selectrow(0, false)
	end if
	
	ls_filter = "cargo_detail_id = " + string(ll_cargo_detail_id)
	dw_bol.setfilter(ls_filter)
	dw_bol.filter()
	
	dw_bol.selectrow(0, false)
end if

if not ib_lockwindow then
	wf_seteditmode(true, dw_cargo_detail_list)
else
	wf_seteditmode(false, dw_cargo_detail_list)
end if

//this.setfocus()
end event

event ue_display_error_code(ref dwbuffer adwbuffer, long arow, integer aerrorcode, string aerrormessage);Boolean lb_showerror

If uo_global.ib_developer  Then
	lb_showerror = true // Force full debug info if developer
End if

CHOOSE CASE aerrorcode
	CASE 233
		MessageBox("Update Error",  &
		"Please populate the mandatory fields before updating! ~r", StopSign!)
	CASE 229
		MessageBox("Update Error",  &
		"You do not have access to this Functionality!", StopSign!)
	CASE 546 //30002
		MessageBox("Update Error",  &
		"You are using a value that does not exist in the system!~nThis is probably a drop down list box you have written a wrong value/string in!", StopSign!)
	CASE 2601
		MessageBox("Update Error",  &
		"You are attempting to create a duplicate!", StopSign!)
	CASE 30006
		MessageBox("Update Error",  &
		"There exists dependent data on what you are deleting!~r~nThis operation cannot be performed!~rFor example, you are deleting a system type that is used in the system!", StopSign!)
	CASE ELSE
		lb_showerror = true
END CHOOSE

If lb_showerror then
		
	string err_type,err_msg
	long row
	
	choose case adwbuffer
		case delete!
			err_type = "Deleting"
		case primary!
			
			choose case this.getItemstatus(arow, 0, adwbuffer)
				Case New!, newmodified!
					err_type = "Inserting"
				Case Else
					err_type = "Updating"
			End choose
	end choose

	err_msg = "Error while "+err_type+" row "+string(row)
	err_msg = err_msg + "~r~nData Base error Number is: " + string(aErrorCode )
	err_msg = err_msg + "~r~nData Base error Message is:~r~n~r~n" + aerrormessage

	window win
	If Parent.TypeOf() = Window! Then
		win = parent
		f_error_box(win.title,err_msg)
	Else
		f_error_box("unknown parent", err_msg)
	End if

	this.setfocus()
	this.setrow(row)
	this.scrolltorow(row)
End if

end event

event ue_changelayoutgrade();/********************************************************************
   ue_changelayoutgrade
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10/11/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_index, ll_cargo_detail_id, ll_find, ll_count, ll_load_cargo_detail_id
string ls_ld, ls_ld_d, ls_layout, ls_grade, ls_group
dwitemstatus ldws_status, ldws_status_d, ldws_layout, ldws_grade, ldws_group

ll_count = this.rowcount()
for ll_row = 1 to ll_count
	ldws_status = this.getitemstatus(ll_row, 0, primary!)
	ls_ld = this.getitemstring(ll_row, "l_d")
	
	if ldws_status <> datamodified! then continue
	if ls_ld <> "L" then continue
	
	ldws_layout = this.getitemstatus(ll_row, "layout", primary!)
	ldws_grade = this.getitemstatus(ll_row, "grade_name", primary!)
	ldws_group = this.getitemstatus(ll_row, "grade_group", primary!)
	ll_cargo_detail_id = this.getitemnumber(ll_row, "cargo_detail_id")
	ls_layout = this.getitemstring(ll_row, "layout")
	ls_grade = this.getitemstring(ll_row, "grade_name")
	ls_group = this.getitemstring(ll_row, "grade_group") 
	
	for ll_index = 1 to ll_count
		ls_ld_d = this.getitemstring(ll_index, "l_d")
		ll_load_cargo_detail_id = this.getitemnumber(ll_index, "load_cargo_detail_id")
		if ls_ld_d <> "D" then continue
		if ll_load_cargo_detail_id <> ll_cargo_detail_id then continue
		
		ldws_status_d = this.getitemstatus(ll_index, 0, primary!)
		if ldws_layout = datamodified! then
			if ldws_status_d = new! or ldws_status_d = newmodified! then
				this.setitem(ll_index, "layout", ls_layout)
			end if
		end if
		
		if ldws_grade = datamodified! then
			if ldws_status_d = new! or ldws_status_d = newmodified! then
				this.setitem(ll_index, "grade_name", ls_grade)
			end if
		end if
		
		if ldws_group = datamodified! then
			if ldws_status_d = new! or ldws_status_d = newmodified! then
				this.setitem(ll_index, "grade_group", ls_group)
			end if
		end if

	next
next
end event

event clicked;
integer li_chart_nr
string	ls_filter, ls_find, ls_l_d
long	ll_cerp_id, ll_cargo_detail_id, ll_agent_nr, ll_findrow, ll_load_cargo_detail_id, ll_row, ll_selectrow, ll_rowid
dwitemstatus ldws_status
datawindowchild ldwc_blno

if row = 0 then
	if dwo.type = "text" then
		idw_focus = dw_poc_list_for_cargo
		
		ll_selectrow = this.getselectedrow(0)
		if ll_selectrow > 0 then
			ll_rowid = this.getrowidfromrow(ll_selectrow)
		end if
		
		super::event clicked(xpos, ypos, row, dwo)
		
		if ll_selectrow > 0 and ll_rowid > 0 then
			ll_selectrow = this.getrowfromrowid(ll_rowid)
			
			if ll_selectrow > 0 then
				this.setrow(ll_selectrow)
				this.scrolltorow(ll_selectrow)
			end if
		end if
		
	end if
	
	return
end if

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

idw_focus = this

ll_row = this.getrow()

if ll_row <> row then
	this.setrow(row)
	this.scrolltorow(row)
end if

if ll_row = row then this.event rowfocuschanged(row)



end event

event editchanged;call super::editchanged;
if ib_lockwindow = false then
	wf_seteditmode(false, dw_cargo_detail_list)
	dw_cargo_detail_list.setfocus()
end if

choose case dwo.name
	case "grade_property"
		inv_dddw_search_grade.uf_editchanged()
	case "cd_cal_caio_id"
		inv_dddw_search_load.uf_editchanged()
	case "load_cargo_detail_id"
		inv_dddw_search_disch.uf_editchanged()
	case "l_d"
		inv_dddw_search_ld.uf_editchanged()
end choose
end event

event itemchanged;call super::itemchanged;
dec{2} ld_mtbe, ld_bio, ld_mtbe_original, ld_bio_original
long ll_row, ll_cal_caio_id, ll_null, ll_cerp_id
string ls_ld, ls_null, ls_group, ls_grade
datawindowchild	ldwc_cargo, ldwc_grade

if row < 1 then return

setnull(ls_null)
setnull(ll_null)

choose case dwo.name
	case "l_d"
		if inv_dddw_search_ld.uf_itemchanged() = 1 then return 2
		if isnull(data) or data = "" then return
		
		this.getchild("l_d", ldwc_cargo)
		ll_row = ldwc_cargo.getrow()
		if ll_row <= 0 then return 
		
		ls_ld = ldwc_cargo.getitemstring(ll_row, "l_d")
		
		this.event ue_refreshdddw(ls_ld)
		ll_cerp_id = this.getitemnumber(row, "cd_cal_cerp_id")
		if ls_ld = "L" then
			this.getchild("cd_cal_caio_id", ldwc_cargo)
			if ll_cerp_id > 1 then
				this.modify("cd_cal_caio_id.TabSequence=10")
			else
				this.modify("cd_cal_caio_id.TabSequence=0")
			end if
		else
			this.getchild("load_cargo_detail_id", ldwc_cargo)
			this.modify("load_cargo_detail_id.TabSequence=10")
		end if
		
		if ldwc_cargo.rowcount() = 1 then
			if ls_ld = "L" then
				this.setitem(row, "cd_cal_caio_id", ldwc_cargo.getitemnumber(1, "cal_caio_id"))
				this.setitem(row, "ships_fig", ldwc_cargo.getitemnumber(1, "number_of_units"))
				this.setitem(row, "load_cargo_detail_id", ll_null)
				this.setitem(row, "cargo_desc", ldwc_cargo.getitemstring(1, "cal_carg_description"))
				this.setitem(row, "grade_name", ls_null)
				this.setitem(row, "grade_property", ls_null)
				this.setitem(row, "layout", ls_null)
				this.setitem(row, "grade_group", ls_null)
			else
				ls_group = ldwc_cargo.getitemstring(1, "cd_grade_group")
				ls_grade = ldwc_cargo.getitemstring(1, "cd_grade_name")
				this.setitem(row, "cd_cal_caio_id", ldwc_cargo.getitemnumber(1, "cal_caio_id"))
				this.setitem(row, "ships_fig", ldwc_cargo.getitemnumber(1, "cd_ships_fig"))
				this.setitem(row, "layout", ldwc_cargo.getitemstring(1, "cd_layout"))
				this.setitem(row, "grade_name", ls_grade)
				this.setitem(row, "grade_group", ls_group)
				this.setitem(row, "load_cargo_detail_id", ldwc_cargo.getitemnumber(1, "cd_cargo_detail_id"))
				this.setitem(row, "surveyor_fig", ldwc_cargo.getitemnumber(1, "cd_surveyor_fig"))
				this.setitem(row, "cargo_desc", ldwc_cargo.getitemstring(1, "cal_carg_description"))
				this.setitem(row, "grade_property", ls_group + " " + ls_grade)
				this.setitemstatus(row, "grade_property", Primary!, NotModified!)
			end if
			this.setitemstatus(row, "cargo_desc", Primary!, NotModified!)
		else
			this.setitem(row, "cd_cal_caio_id", ll_null)
			this.setitem(row, "load_cargo_detail_id", ll_null)
			this.setitem(row, "cargo_desc", ls_null)
			this.setitem(row, "grade_name", ls_null)
			this.setitem(row, "layout", ls_null)
			this.setitem(row, "grade_group", ls_null)
			this.setitem(row, "grade_property", ls_null)
		end if
		
	
	case "cd_cal_caio_id"	
		if inv_dddw_search_load.uf_itemchanged() = 1 then
			return 2
		else
			if isnull(data) or data = "" then
				this.setitem(row, "cargo_desc", "")
			else
				this.getchild("cd_cal_caio_id", ldwc_cargo)
				ll_row = ldwc_cargo.getrow()
				if ll_row > 0 then
					this.setitem(row, "cargo_desc", ldwc_cargo.getitemstring(ll_row, "cal_carg_description"))
					this.setitem(row, "ships_fig", ldwc_cargo.getitemnumber(ll_row, "number_of_units"))
					this.setitem(row, "load_cargo_detail_id", ll_null)
					
					this.setitemstatus(row, "cargo_desc", Primary!, NotModified!)
				end if
			end if
		end if
	case "load_cargo_detail_id"
		if inv_dddw_search_disch.uf_itemchanged() = 1 then
			return 2
		else
			if isnull(data) or data = "" then
				this.setitem(row, "cargo_desc", "")
			else
				this.getchild("load_cargo_detail_id", ldwc_cargo)
				ll_row = ldwc_cargo.getrow()
				if ll_row > 0 then
					ls_group = ldwc_cargo.getitemstring(ll_row, "cd_grade_group")
					ls_grade = ldwc_cargo.getitemstring(ll_row, "cd_grade_name")
					this.setitem(row, "cd_cal_caio_id", ldwc_cargo.getitemnumber(ll_row, "cal_caio_id"))
					this.setitem(row, "ships_fig", ldwc_cargo.getitemnumber(ll_row, "cd_ships_fig"))
					this.setitem(row, "layout", ldwc_cargo.getitemstring(ll_row, "cd_layout"))
					this.setitem(row, "grade_name", ls_grade)
					this.setitem(row, "grade_group", ls_group)
					this.setitem(row, "cargo_desc", ldwc_cargo.getitemstring(ll_row, "cal_carg_description"))
					this.setitem(row, "surveyor_fig", ldwc_cargo.getitemnumber(ll_row, "cd_surveyor_fig"))
					this.setitem(row, "grade_property", ls_group + " " + ls_grade)
					this.setitemstatus(row, "grade_property", Primary!, NotModified!)
					this.setitemstatus(row, "cargo_desc", Primary!, NotModified!)
				end if
			end if
		end if

	case "grade_property"
		if inv_dddw_search_grade.uf_itemchanged() = 1 then
			return 2
		else
			if not isnull(data) and data <> "" then
				this.getchild("grade_property", ldwc_grade)
				ll_row = ldwc_grade.getrow()
				if ll_row > 0 then
					this.setitem(row, "grade_group", ldwc_grade.getitemstring(ll_row, "grade_group"))
					this.setitem(row, "grade_name", ldwc_grade.getitemstring(ll_row, "grade_name"))
					this.setitemstatus(row, "grade_property", Primary!, NotModified!)
				else
					return 1
				end if
			end if
		end if
	case 'cd_mtbe_etbe_status'
		if data = '1' then
			ld_mtbe_original = this.getitemdecimal(row,"cd_mtbe_etbe", primary!, true)
			if ld_mtbe_original > 0 then
				this.setitem(row, "cd_mtbe_etbe", ld_mtbe_original)
			else
				this.setitem(row, "cd_mtbe_etbe", 0.00)
			end if
		else
			setnull(ld_mtbe)
			this.setitem(row, "cd_mtbe_etbe", ld_mtbe)
		end if
	case 'cd_bio_status'
		if data= '1' then
			ld_bio_original = this.getitemdecimal(row,"cd_bio", primary!, true)
			if ld_bio_original > 0 then
				this.setitem(row, "cd_bio", ld_bio_original)
			else
				this.setitem(row, "cd_bio", 0.00)
			end if
		else
			setnull(ld_bio)
			this.setitem(row, "cd_bio", ld_bio)
		end if
	case 'cd_mtbe_etbe'
		ld_mtbe = dec(data)
//		if ld_mtbe > 100 or ld_mtbe < 0 then
//			messagebox("Validation error", "MTBE/ETBE has to be between 0 and 100%.", stopsign!, ok!)
//			return 1
//		end if
	case 'cd_bio'
		ld_bio = dec(data)
//		if ld_bio > 100 or ld_bio < 0 then
//			messagebox("Validation error", "Bio has to be between 0 and 100%.", stopsign!, ok!)
//			return 1
//		end if
end choose

if ib_lockwindow = false then
	wf_seteditmode(false, dw_cargo_detail_list)
	dw_cargo_detail_list.setfocus()
end if
end event

event resize;call super::resize;//integer li_x, li_dwx
//constant integer li_buttonsize = 343 + 4 
//li_dwx = this.width
//gb_2.width = li_dwx + 74
//li_x = gb_2.x + gb_2.width + 4 - 32
//cb_cancel_cargo.x =  li_x - li_buttonsize *1
//cb_delete_cargo.x =   li_x - li_buttonsize *2
//cb_update_cargo.x =  li_x - li_buttonsize *3
//cb_new_cargo.x =  li_x - li_buttonsize *4
end event

event itemfocuschanged;call super::itemfocuschanged;if dwo.name ='cd_mtbe_etbe' or dwo.name = 'cd_bio' then
	 this.post selecttext(1,5)
end if
end event

event rowfocuschanged;call super::rowfocuschanged;string ls_ld
dwitemstatus ldws_status

if isnull(currentrow) or currentrow < 1 then return

this.event ue_rowchanged(currentrow)

ldws_status = this.getitemstatus(currentrow, 0, primary!)
ls_ld = this.getitemstring(currentrow, "l_d")

if ldws_status = new! or ldws_status = newmodified! then
	this.event ue_refreshdddw(ls_ld)
end if


end event

event getfocus;call super::getfocus;long ll_selectrow
string ls_colname, ls_text
dwitemstatus ldws_status

idw_focus = this

this.settaborder("l_d", 10)
this.settaborder("cd_cal_caio_id", 20)
this.settaborder("load_cargo_detail_id", 30)
this.settaborder("layout", 40)
this.settaborder("grade_property", 50)
this.settaborder("grade_group", 60)
this.settaborder("cd_mtbe_etbe_status", 70)
this.settaborder("cd_mtbe_etbe", 80)
this.settaborder("cd_bio_status", 90)
this.settaborder("cd_bio", 100)
this.settaborder("cd_dye_marked", 110)

ll_selectrow = this.getselectedrow(0)
ls_colname = this.getcolumnname()
ldws_status = this.getitemstatus(ll_selectrow, 0, primary!)
ls_text = this.gettext()
this.modify("l_d.protect='0~tif(isRowNew() and ld_protect = 0, 0, 1)' ")
if (ldws_status = new! or ldws_status = newmodified!) and ls_colname = "l_d" and ls_text <> "L" and ls_text <> "D" then
	this.settext(ls_text)
	this.selecttext(1, len(ls_text))
end if

if keydown(KeyTab!) then
	this.setcolumn("l_d")
end if

end event

event ue_lbuttondown;//
end event

event itemerror;call super::itemerror;string ls_colname

this.selecttext(1, len(data))

ls_colname = dwo.name

if ls_colname = "l_d" or ls_colname = "grade_property" or ls_colname = "cd_cal_caio_id" or ls_colname = "load_cargo_detail_id" then
	return 3
else
	return 0
end if
end event

event losefocus;call super::losefocus;integer li_col
string ls_colarr[]

ls_colarr[1] = "l_d"
ls_colarr[2] = "cd_cal_caio_id"
ls_colarr[3] = "load_cargo_detail_id"
ls_colarr[4] = "layout"
ls_colarr[5] = "grade_property"
ls_colarr[6] = "grade_group"
ls_colarr[7] = "cd_mtbe_etbe_status"
ls_colarr[8] = "cd_mtbe_etbe"
ls_colarr[9] = "cd_bio_status"
ls_colarr[10] = "cd_bio"
ls_colarr[11] = "cd_dye_marked"

for li_col = 1 to upperbound(ls_colarr)
	if this.getcolumnname() <> ls_colarr[li_col] then
		this.settaborder(ls_colarr[li_col], 0)
	end if
next
end event

event dberror;event ue_display_error_code(buffer, row, sqldbcode, sqlerrtext)
return 1
end event

event ue_set_column;call super::ue_set_column;string ls_colname

ls_colname = this.getcolumnname()

if ls_colname = "l_d" or ls_colname = "grade_property" or ls_colname = "cd_cal_caio_id" or ls_colname = "load_cargo_detail_id" then
	this.of_set_column()
end if
end event

type cb_update_charter from mt_u_commandbutton within w_cargo
integer x = 2926
integer y = 732
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "&Update"
end type

event clicked;call super::clicked;
long ll_agent_nr
long ll_row, ll_errrow, ll_chart_nr, ll_rowid
integer li_errcol
string ls_message, ls_sortstring
n_service_manager	lnv_svcmgr
n_dw_validation_service 	lnv_validation

ib_accepttext = true
if dw_cargo_list.accepttext() = -1 then
	ib_accepttext = false
	dw_cargo_list.setfocus()	
	return c#return.Failure
end if
ib_accepttext = false

lnv_svcmgr.of_loadservice( lnv_validation, "n_dw_validation_service")
lnv_validation.of_registerrulenumber("chart_nr", true, "Charterer")
lnv_validation.of_registerrulenumber("agent_nr", true, "Agent")

if lnv_validation.of_validate(dw_cargo_list, ls_message, ll_errrow, li_errcol) = c#return.Failure then 
	inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, ls_message, parent)
	dw_cargo_list.setfocus()
	dw_cargo_list.setrow(ll_errrow)
	dw_cargo_list.scrolltorow(ll_errrow)
	dw_cargo_list.setcolumn(li_errcol)
	
	return c#return.Failure
end if

for ll_row = 1 to dw_cargo_list.rowcount()
	if dw_cargo_list.getitemstatus(ll_row, 0, primary!) = NewModified! then
		ll_chart_nr = dw_cargo_list.getitemnumber(ll_row, "chart_nr")
		ll_agent_nr = dw_cargo_list.getitemnumber(ll_row, "agent_nr")
		if not f_chart_active(ll_chart_nr) then
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "The Charterer is inactive.", parent)
			dw_cargo_list.setfocus()
			dw_cargo_list.setrow(ll_row)
			dw_cargo_list.scrolltorow(ll_row)
			dw_cargo_list.setcolumn("chart_nr")
			return c#return.Failure
		end if
		
		if not f_agent_active(ll_agent_nr) then 
			inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, "You have selected an inactive agent. Select an active agent to continue.", parent)
			dw_cargo_list.setfocus()
			dw_cargo_list.setrow(ll_row)
			dw_cargo_list.scrolltorow(ll_row)
			dw_cargo_list.setcolumn("agent_nr")
			return c#return.Failure
		end if
	end if
next

if dw_cargo_list.update() = 1 then
	commit;
	
	ll_row =  dw_cargo_list.getselectedrow(0)
	if ll_row > 0 then 
		dw_cargo_list.event ue_rowchanged(ll_row)	//set the correct filter after new a row
		ll_rowid = dw_cargo_list.getrowidfromrow(ll_row)
	end if
	
	//sort after update
	idw_focus = dw_poc_list_for_cargo
	ls_sortstring = dw_cargo_list.Describe("Datawindow.Table.sort")
	if ls_sortstring = "?" then dw_cargo_list.setsort("chart_chart_sn A")
	dw_cargo_list.sort()
	if ls_sortstring = "?" then dw_cargo_list.setsort("")
	if ll_rowid > 0 then
		ll_row = dw_cargo_list.getrowfromrowid(ll_rowid)
		if ll_row > 0 then
			dw_cargo_list.setrow(ll_row)
			dw_cargo_list.scrolltorow(ll_row)
		end if
	end if
	
	wf_seteditmode(true, dw_cargo_list)
else
	rollback;
end if

dw_cargo_list.setfocus()
return c#return.Success
end event

type cb_cancel_charter from mt_u_commandbutton within w_cargo
integer x = 3621
integer y = 732
integer taborder = 80
boolean bringtotop = true
boolean enabled = false
string text = "&Cancel"
end type

event clicked;call super::clicked;
integer li_pcn, li_chart_nr
long ll_row, ll_port_row, ll_cerp_id, ll_agent_nr, ll_findrow, ll_currentrow
string ls_voyage_nr, ls_port_code, ls_findstr, ls_filterstr
dwitemstatus ldws_status

ll_port_row = dw_poc_list_for_cargo.getselectedrow(0)
if ll_port_row < 1 then return

idw_focus = dw_poc_list_for_cargo

ls_voyage_nr = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_voyage_nr")
ls_port_code = dw_poc_list_for_cargo.getitemstring(ll_port_row, "poc_port_code")
li_pcn = dw_poc_list_for_cargo.getitemnumber(ll_port_row, "poc_pcn")

ll_row = dw_cargo_list.getselectedrow(0)
if ll_row > 0 then
	ldws_status = dw_cargo_list.getitemstatus(ll_row, 0, primary!)
	li_chart_nr = dw_cargo_list.getitemnumber(ll_row, "chart_nr")
	ll_cerp_id = dw_cargo_list.getitemnumber(ll_row, "cargo_cal_cerp_id")
	ll_agent_nr = dw_cargo_list.getitemnumber(ll_row, "agent_nr")
end if

dw_cargo_list.setredraw(false)

dw_cargo_list.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
if ldws_status = new! or ldws_status = newmodified! then
	ll_findrow = 0
else
	ls_findstr = "chart_nr = " + string(li_chart_nr) + " and cargo_cal_cerp_id = " + string(ll_cerp_id) + " and agent_nr = " + string(ll_agent_nr)
	ll_findrow = dw_cargo_list.find(ls_findstr, 1, dw_cargo_list.rowcount())
end if

dw_cargo_list.selectrow(0, false)
if ll_findrow > 0 then
	ll_currentrow = dw_cargo_list.getrow()
	dw_cargo_list.scrolltorow(ll_findrow)
	if ll_findrow = ll_currentrow then dw_cargo_list.event rowfocuschanged(ll_findrow)
end if

dw_cargo_list.setredraw(true)

wf_seteditmode(true, dw_cargo_list)

dw_poc_list_for_cargo.setfocus()



end event

type gb_2 from groupbox within w_cargo
integer x = 37
integer y = 880
integer width = 4507
integer height = 604
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Cargo Grade"
end type

type dw_bol from uo_datawindow within w_cargo
event ue_refreshdddw ( )
event ue_rowchanged ( long currentrow )
integer x = 73
integer y = 1580
integer width = 4434
integer height = 520
integer taborder = 140
string dataobject = "d_sq_gr_bol"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_editmaskselect = true
end type

event ue_refreshdddw();/********************************************************************
   ue_refreshdddw
   <DESC></DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_load_cargo_detail_id
string ls_l_d
datawindowchild ldwc_blno

ll_row = dw_cargo_detail_list.getselectedrow(0)
if ll_row < 1 then return

ls_l_d = dw_cargo_detail_list.getitemstring(ll_row, "l_d")

if ls_l_d = "D" then
	ll_load_cargo_detail_id = dw_cargo_detail_list.getitemnumber(ll_row, "load_cargo_detail_id")
	dw_bol.getchild("bol_nr", ldwc_blno)
	ldwc_blno.settransobject(sqlca)
	ldwc_blno.retrieve(ll_load_cargo_detail_id)
end if	
end event

event ue_rowchanged(long currentrow);/********************************************************************
   ue_rowchanged
   <DESC>row highlight, filter</DESC>
   <RETURN>	(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		currentrow
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21/09/16		CR4224		CCY018		First Version
   </HISTORY>
********************************************************************/

integer li_chart_nr
long ll_cerp_id, ll_agent_nr, ll_cargo_detail_id, ll_findrow, ll_currentrow
dwitemstatus ldws_status

if isnull(currentrow)  or currentrow < 1 then return

this.selectrow(0, false)
this.selectrow(currentrow, true)

if idw_focus.classname() <> this.classname() then return

ldws_status = this.getitemstatus(currentrow, 0, primary!)
if ldws_status = new! or ldws_status = newmodified! then
else
	li_chart_nr = this.getitemnumber(currentrow, "chart_nr")
	ll_cerp_id = this.getitemnumber(currentrow, "cal_cerp_id")
	ll_agent_nr = this.getitemnumber(currentrow, "agent_nr")
	ll_cargo_detail_id = this.getitemnumber(currentrow, "cargo_detail_id")
	
	ll_findrow = dw_cargo_detail_list.find("cargo_detail_id = " + string(ll_cargo_detail_id), 1, dw_cargo_detail_list.rowcount())
	if ll_findrow > 0 then
		ll_currentrow = dw_cargo_detail_list.getrow()
		dw_cargo_detail_list.setrow(ll_findrow)
		dw_cargo_detail_list.scrolltorow(ll_findrow)
		if ll_currentrow = ll_findrow then dw_cargo_detail_list.event rowfocuschanged(ll_findrow)
	end if
	
	ll_findrow = dw_cargo_list.find("chart_nr=" + string(li_chart_nr) + " and agent_nr = " + string(ll_agent_nr) + " and  cargo_cal_cerp_id = " + string(ll_cerp_id), 1, dw_cargo_list.rowcount())
	if ll_findrow > 0 then
		ll_currentrow = dw_cargo_list.getrow()
		dw_cargo_list.setrow(ll_findrow)
		dw_cargo_list.scrolltorow(ll_findrow)
		if ll_currentrow = ll_findrow then dw_cargo_list.event rowfocuschanged(ll_findrow)
	end if
end if

if not ib_lockwindow then
	wf_seteditmode(true, dw_bol)
else
	wf_seteditmode(false, dw_bol)
end if

//this.setfocus()
end event

event getfocus;call super::getfocus;long ll_selectrow
string ls_colname, ls_coltype

idw_focus = this

this.settaborder("bol_nr", 10)
this.settaborder("layout_bl", 20)
this.settaborder("recieved", 30)
this.settaborder("all_fast_dt", 40)
this.settaborder("departure_dt", 50)
this.settaborder("bol_quantity", 60)
this.settaborder("cargo_temp", 70)
this.settaborder("temp_type", 80)

//this.modify("bol_nr.protect='0~tif( l_d = 0 and isRowNew(), 0, 1)' ")

if keydown(KeyTab!) then
	this.setcolumn("bol_nr")
end if



end event

event clicked;
integer li_chart_nr
long ll_cerp_id, ll_agent_nr, ll_cargo_detail_id, ll_findrow, ll_row
long ll_selectrow, ll_bol_id, ll_rowid
dwitemstatus ldws_status

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

if row = 0 then
	if dwo.type = "text" then
		idw_focus = dw_poc_list_for_cargo
		
		ll_selectrow = this.getselectedrow(0)
		if ll_selectrow > 0 then
			ll_rowid = this.getrowidfromrow(ll_selectrow)
		end if
		
		super::event clicked(xpos, ypos, row, dwo)
		
		if ll_selectrow > 0 and ll_rowid > 0 then
			ll_selectrow = this.getrowfromrowid(ll_rowid)
			
			if ll_selectrow > 0 then
				this.setrow(ll_selectrow)
				this.scrolltorow(ll_selectrow)
			end if
		end if
	end if
	
	return
end if


idw_focus = this

ll_row = this.getrow()

if ll_row <> row then
	this.setrow(row)
	this.scrolltorow(row)
end if

if ll_row = row then this.event rowfocuschanged(row)

end event

event itemchanged;call super::itemchanged;
long ll_row
datawindowchild ldwc_bolnr

if row < 1 then return

if dwo.name = "bol_nr" then
	if inv_dddw_search_bol.uf_itemchanged() = 1 then
		return 2
	else
		if not isnull(data) or data <> "" then
			this.getchild("bol_nr", ldwc_bolnr)
			ll_row =  ldwc_bolnr.getrow()
			if ll_row > 0 then
				this.setitem(row, "layout_bl", ldwc_bolnr.getitemstring(ll_row, "layout_bl"))
				this.setitem(row, "recieved", ldwc_bolnr.getitemdatetime(ll_row, "recieved"))
				this.setitem(row, "bol_quantity", ldwc_bolnr.getitemnumber(ll_row, "remain_qty"))
				this.setitem(row, "temp_type", ldwc_bolnr.getitemnumber(ll_row, "temp_type"))
			end if
		end if
	end if
end if

if ib_lockwindow = false then
	wf_seteditmode(false, dw_bol)
	dw_bol.setfocus()
end if


 

end event

event editchanged;call super::editchanged;if ib_lockwindow = false then
	wf_seteditmode(false, dw_bol)
	dw_bol.setfocus()
end if

end event

event rowfocuschanged;call super::rowfocuschanged;long ll_row

this.event ue_rowchanged(currentrow)

ll_row = this.getselectedrow(0)
if ll_row < 1 then return 

if this.getitemnumber(ll_row, "l_d") = 0 then this.event ue_refreshdddw()


end event

event itemerror;call super::itemerror;string ls_colname

this.selecttext(1, len(data))

ls_colname = dwo.name

if ls_colname = "bol_nr" then
	return 3
end if

return 0
end event

event losefocus;call super::losefocus;integer li_col
string ls_colname, ls_coltype, ls_colarr[]

ls_colname = this.getcolumnname()
ls_coltype =  lower(this.describe(ls_colname + ".ColType"))
if ls_coltype = "date" or ls_coltype = "datetime" then return

ls_colarr[1] = "bol_nr"
ls_colarr[2] = "layout_bl"
ls_colarr[3] = "recieved"
ls_colarr[4] = "all_fast_dt"
ls_colarr[5] = "departure_dt"
ls_colarr[6] = "bol_quantity"
ls_colarr[7] = "cargo_temp"
ls_colarr[8] = "temp_type"


for li_col = 1 to upperbound(ls_colarr)
	if this.getcolumnname() <> ls_colarr[li_col] then
		this.settaborder(ls_colarr[li_col], 0)
	end if
next
end event

event ue_set_column;call super::ue_set_column;string ls_columnname

ls_columnname = this.getcolumnname()

if ls_columnname = "bol_nr" then 
	this.of_set_column()
end if
end event

type gb_4 from groupbox within w_cargo
integer x = 37
integer y = 1516
integer width = 4507
integer height = 732
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
string text = "Bill Of Lading"
end type

type dw_pctc_rob from u_datagrid within w_cargo
boolean visible = false
integer x = 827
integer y = 1372
integer width = 1531
integer height = 780
integer taborder = 190
boolean bringtotop = true
string dataobject = "d_sq_tb_pctc_rob"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_lbuttondown;//
end event

event clicked;this.visible = false
end event

