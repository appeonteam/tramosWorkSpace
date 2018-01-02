$PBExportHeader$w_super_vas_reports.srw
$PBExportComments$Window for all  VAS (Vessel Accounting System ) reports generation
forward
global type w_super_vas_reports from mt_w_sheet
end type
type cb_spool from commandbutton within w_super_vas_reports
end type
type dw_vas_loadload from datawindow within w_super_vas_reports
end type
type cb_disb_exp from commandbutton within w_super_vas_reports
end type
type rb_pdf from radiobutton within w_super_vas_reports
end type
type rb_printer from radiobutton within w_super_vas_reports
end type
type st_year from statictext within w_super_vas_reports
end type
type sle_year from singlelineedit within w_super_vas_reports
end type
type cb_print from commandbutton within w_super_vas_reports
end type
type cb_cancel from commandbutton within w_super_vas_reports
end type
type cb_print_preview from commandbutton within w_super_vas_reports
end type
type cb_generate_reports from commandbutton within w_super_vas_reports
end type
type cb_close from commandbutton within w_super_vas_reports
end type
type dw_profit_report from uo_datawindow within w_super_vas_reports
end type
type dw_calc_memo from datawindow within w_super_vas_reports
end type
type cb_print_log from commandbutton within w_super_vas_reports
end type
type uo_vessels from u_drag_drop_boxes within w_super_vas_reports
end type
type uo_profit_centers from u_drag_drop_boxes within w_super_vas_reports
end type
type uo_shiptype from u_drag_drop_boxes within w_super_vas_reports
end type
type uo_voyages from u_drag_drop_boxes within w_super_vas_reports
end type
type uo_reports from u_drag_drop_boxes within w_super_vas_reports
end type
type cbx_time_monitor from checkbox within w_super_vas_reports
end type
type cbx_progress_bar from checkbox within w_super_vas_reports
end type
type dw_vas_log from datawindow within w_super_vas_reports
end type
type dw_calc_memo_extended from datawindow within w_super_vas_reports
end type
type st_zoom from statictext within w_super_vas_reports
end type
type em_zoom from editmask within w_super_vas_reports
end type
type st_test from structure within w_super_vas_reports
end type
end forward

type st_test from structure
    string name
    long number
end type

global type w_super_vas_reports from mt_w_sheet
integer x = 343
integer y = 212
integer width = 3465
integer height = 1720
string title = "VAS Report"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
string icon = "images\TRAMOS.ICO"
event ue_linked ( )
event ue_linked_calc_memo_extended ( )
event ue_linked_calc_memo ( )
event ue_linked_vas_loadload ( )
cb_spool cb_spool
dw_vas_loadload dw_vas_loadload
cb_disb_exp cb_disb_exp
rb_pdf rb_pdf
rb_printer rb_printer
st_year st_year
sle_year sle_year
cb_print cb_print
cb_cancel cb_cancel
cb_print_preview cb_print_preview
cb_generate_reports cb_generate_reports
cb_close cb_close
dw_profit_report dw_profit_report
dw_calc_memo dw_calc_memo
cb_print_log cb_print_log
uo_vessels uo_vessels
uo_profit_centers uo_profit_centers
uo_shiptype uo_shiptype
uo_voyages uo_voyages
uo_reports uo_reports
cbx_time_monitor cbx_time_monitor
cbx_progress_bar cbx_progress_bar
dw_vas_log dw_vas_log
dw_calc_memo_extended dw_calc_memo_extended
st_zoom st_zoom
em_zoom em_zoom
end type
global w_super_vas_reports w_super_vas_reports

type variables
str_progress istr_parm

// Variables used when linked to operations
integer 		ii_vessel_nr
string 		is_voyage_nr
datastore 	ids_TC_disb_exp
string			is_link_report
end variables

forward prototypes
public subroutine uf_redraw_on ()
public subroutine uf_redraw_off ()
public subroutine wf_setbuttons (integer ai_status)
public function decimal uf_other_frt_adr_com (integer ad_calc_id)
public function decimal uf_frt_adr_com (decimal ad_calc_id)
public function decimal uf_dem_adr_com (decimal ad_total_adr_com, decimal ad_frt_adr_com, decimal ad_calc_id, decimal ad_other_frt_adr_com)
public subroutine uf_create_extended_calc_memo (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_calc_memo)
public subroutine wf_print_report (datawindow adw)
public function integer uf_atobviac_port_expenses (ref datastore ads, long al_calc_id)
public function integer uf_loadload_vas (integer ai_vessel, string as_voyage, ref datawindow adw_loadvas)
public function integer of_setloadloadcargosection (long al_calcid, string as_calctype, ref datawindow adw_report)
public function integer of_setactualintake (long al_calcid, ref decimal ad_intake, ref decimal ad_bol_quantity, long ad_cerpid)
public function integer of_move_columns (string as_from, string as_to)
private function integer of_modifyactualloadload ()
private function integer of_reduceactualdayssection_loadload (ref datastore ads_poc, datetime adt_voyagestart)
public subroutine documentation ()
end prototypes

event ue_linked();/////////////////////////////////////////////////////////////
/* Declare local Variables */
String ls_vgrp_desc, ls_m_name
Long ll_row_count, ll_row, ll_vessel_grp_id
Integer li_year, li_key[], li_control_return
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset VAS log datawindow
dw_vas_log.Reset()
IF cbx_progress_bar.checked THEN open(w_vas_progress)
IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_report_type.text = "Generating selected report type 1 of 1"
END IF

		
IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_type.text = "Voyage Profit 1 of 1"
END IF
wf_SetButtons(1)
lu_vas_control = CREATE u_vas_control
lstr_vessel_voyage_list[1].vessel_nr = ii_vessel_nr
lstr_vessel_voyage_list[1].voyage_nr = is_voyage_nr
li_year = integer(left(is_voyage_nr,2))
li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
DESTROY lu_vas_control
IF li_control_return = -2 THEN  /* Generation canceled */
	wf_SetButtons(6)
ELSE
	wf_SetButtons(2)
END IF
ll_row_count = dw_vas_log.RowCount()

// Insert a heading in the log if there if any entries in the log datawindow
If IsValid(w_super_vas_reports) Then
	If dw_vas_log.ModifiedCount() > 0 Then 
		ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
		String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
		lstr_vessel_voyage_list[1].voyage_nr)
	End if
End if

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

if ids_TC_disb_exp.rowCount() > 0 then
	cb_disb_exp.visible = true
else
	cb_disb_exp.visible = false
end if

IF IsValid(w_vas_progress) THEN
	Close(w_vas_progress)
END IF


end event

event ue_linked_calc_memo_extended();/////////////////////////////////////////////////////////////
/* Declare local Variables */
String ls_vgrp_desc, ls_m_name
Long ll_row_count, ll_row, ll_vessel_grp_id
Integer li_year, li_key[], li_control_return
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset VAS log datawindow
dw_vas_log.Reset()
IF cbx_progress_bar.checked THEN open(w_vas_progress)
IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_report_type.text = "Generating selected report type 1 of 1"
END IF

///

IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_type.text = "Voyage Calculation Memo Extended 1 of 1"
END IF
wf_SetButtons(1)
lu_vas_control = CREATE u_vas_control
lstr_vessel_voyage_list[1].vessel_nr = ii_vessel_nr
lstr_vessel_voyage_list[1].voyage_nr = is_voyage_nr
li_year = integer(left(is_voyage_nr, 2))
li_control_return = lu_vas_control.of_master_control( 6, li_key[], lstr_vessel_voyage_list[], li_year, dw_calc_memo_extended)
DESTROY lu_vas_control
IF li_control_return = -2 THEN  /* Generation canceled */
	wf_SetButtons(6)
ELSE
	uf_create_extended_calc_memo(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,dw_calc_memo_extended)
	wf_SetButtons(7)
END IF
ll_row_count = dw_vas_log.RowCount()

// Insert a heading in the log if there if any entries in the log datawindow
If IsValid(w_super_vas_reports) Then
	If dw_vas_log.ModifiedCount() > 0 Then 
		ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
		String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
		lstr_vessel_voyage_list[1].voyage_nr)
	End if
End if

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

IF IsValid(w_vas_progress) THEN
	Close(w_vas_progress)
END IF


end event

event ue_linked_calc_memo();/////////////////////////////////////////////////////////////
/* Declare local Variables */
String ls_vgrp_desc, ls_m_name
Long ll_row_count, ll_row, ll_vessel_grp_id
Integer li_year, li_key[], li_control_return
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset VAS log datawindow
dw_vas_log.Reset()
IF cbx_progress_bar.checked THEN open(w_vas_progress)
IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_report_type.text = "Generating selected report type 1 of 1"
END IF

IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_type.text = "Voyage Calculation Memo 1 of 1"
END IF
wf_SetButtons(1)
lu_vas_control = CREATE u_vas_control
lstr_vessel_voyage_list[1].vessel_nr = ii_vessel_nr
lstr_vessel_voyage_list[1].voyage_nr = is_voyage_nr
li_year = integer(left(is_voyage_nr, 2))
li_control_return = lu_vas_control.of_master_control( 6, li_key[], lstr_vessel_voyage_list[], li_year, dw_calc_memo)
DESTROY lu_vas_control
IF li_control_return = -2 THEN  /* Generation canceled */
	wf_SetButtons(6)
ELSE
	wf_SetButtons(3)
END IF
ll_row_count = dw_vas_log.RowCount()

// Insert a heading in the log if there if any entries in the log datawindow
If IsValid(w_super_vas_reports) Then
	If dw_vas_log.ModifiedCount() > 0 Then 
		ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
		String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
		lstr_vessel_voyage_list[1].voyage_nr)
	End if
End if

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

IF IsValid(w_vas_progress) THEN
	Close(w_vas_progress)
END IF


end event

event ue_linked_vas_loadload();/////////////////////////////////////////////////////////////
/* Declare local Variables */
String ls_vgrp_desc, ls_m_name
Long ll_row_count, ll_row, ll_vessel_grp_id
Integer li_year, li_key[], li_control_return
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

setpointer(hourglass!)

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset VAS log datawindow
dw_vas_log.Reset()
IF cbx_progress_bar.checked THEN open(w_vas_progress)
IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_report_type.text = "Generating selected report type 1 of 1"
END IF

///

IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_type.text = "Voyage Profit (LoadLoad) 1 of 1"
END IF
wf_SetButtons(1)
lu_vas_control = CREATE u_vas_control
lstr_vessel_voyage_list[1].vessel_nr = ii_vessel_nr
lstr_vessel_voyage_list[1].voyage_nr = is_voyage_nr
li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_loadload )
DESTROY lu_vas_control
IF li_control_return = -2 THEN  /* Generation canceled */
	wf_SetButtons(6)
ELSE
	uf_loadload_vas( lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,dw_vas_loadload)
	wf_SetButtons(8)
END IF
ll_row_count = dw_vas_log.RowCount()

// Insert a heading in the log if there if any entries in the log datawindow
If IsValid(w_super_vas_reports) Then
	If dw_vas_log.ModifiedCount() > 0 Then 
		ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
		w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
		String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
		lstr_vessel_voyage_list[1].voyage_nr)
	End if
End if

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

setpointer(arrow!)

IF IsValid(w_vas_progress) THEN
	Close(w_vas_progress)
END IF


end event

public subroutine uf_redraw_on ();

end subroutine

public subroutine uf_redraw_off ();

end subroutine

public subroutine wf_setbuttons (integer ai_status);// This function controls the buttons/datawindows state visible/enabled
//
//  Argument Integer ai_status	1 = Generate/print reports
//											2 = Preview VAS
//											3 = Preview Calv Memo
//											4 = Log window
//											5 = Select
//											6 = Canceled
//											7 = Preview Calc Memo Extended
//											8 = Preview VAS LoadLoad
////////////////////////////////////////////////////////////////////////

//Long ll_dw_height = 1395, ll_dw_width = 2868, ll_dw_x = 10, ll_dw_y = 115
Long ll_dw_height = 2800, ll_dw_width = 4628, ll_dw_x = 10, ll_dw_y = 115

dw_profit_report.Object.Datawindow.Print.Preview = 'Yes'
dw_profit_report.Object.Datawindow.Print.Preview.Zoom = '92'
dw_calc_memo.Object.Datawindow.Print.Preview = 'Yes'
dw_calc_memo.Object.Datawindow.Print.Preview.Zoom = '92'
dw_calc_memo_extended.Object.Datawindow.Print.Preview = 'Yes'
dw_calc_memo_extended.Object.Datawindow.Print.Preview.Zoom = '92'
dw_vas_loadload.Object.Datawindow.Print.Preview = 'Yes'
dw_vas_loadload.Object.Datawindow.Print.Preview.Zoom = '92'
//w_super_vas_reports.SetRedraw( FALSE )

CHOOSE CASE ai_status
	CASE 1
		cb_print_preview.enabled = False
		cb_generate_reports.enabled = False
		cb_close.enabled = False
		cbx_progress_bar.enabled = False
		cbx_time_monitor.enabled = False
		cb_print_log.visible = False
		cb_print.visible = False
		cb_cancel.visible = False
		cb_spool.enabled = False
	CASE 2
		dw_profit_report.visible = True
		dw_profit_report.move( ll_dw_x, ll_dw_y )
		dw_profit_report.height = ll_dw_height
		dw_profit_report.width = ll_dw_width
		this.height = 3028
		this.width = 4654
		cb_print_preview.visible = False
		cb_generate_reports.visible = False
		cb_spool.visible = False
		cb_close.visible = False
		cbx_progress_bar.visible = False
		cbx_time_monitor.visible = False
		cb_print_log.visible = False
		cb_print.visible = True
		cb_cancel.visible = True
	CASE 3
		dw_calc_memo.visible = True
		dw_calc_memo.move( ll_dw_x, ll_dw_y )
		dw_calc_memo.height = ll_dw_height
		dw_calc_memo.width = ll_dw_width
		this.height = 3028
		this.width = 4654
		cb_print_preview.visible = False
		cb_generate_reports.visible = False
		cb_spool.visible = False
		cb_close.Visible = False
		cbx_progress_bar.visible = False
		cbx_time_monitor.visible = False
		cb_print_log.visible = False
		cb_print.visible = True
		cb_cancel.visible = True
	CASE 4
		dw_vas_log.visible = True
		cb_print_preview.visible = False
		cb_generate_reports.visible = False
		cb_spool.visible = False
		cb_close.enabled = True
		cb_close.visible = True
		cbx_progress_bar.visible = False
		cbx_time_monitor.visible = False
		cb_print_log.visible = True
		cb_print.visible = False
		cb_cancel.visible = False
	CASE 5
		dw_profit_report.visible = False
		dw_calc_memo.visible = False
		dw_calc_memo_extended.visible = False
		dw_vas_log.visible = False
		this.height = 1744
		this.width = 3494
		cb_print_preview.enabled = True
		cb_print_preview.visible = True
		cb_generate_reports.enabled = True
		cb_generate_reports.visible = True
		cb_spool.enabled = True
		cb_spool.visible = True
		cb_close.enabled = True
		cb_close.visible = True
		cbx_progress_bar.enabled = True
		cbx_progress_bar.visible = True
		cbx_time_monitor.enabled = True
		cbx_time_monitor.visible = True
		cb_print_log.visible = False
		cb_print.visible = False
		cb_cancel.visible = False
	CASE 6
		dw_profit_report.visible = False
		dw_calc_memo.visible = False
		dw_calc_memo_extended.visible = False
		dw_vas_log.visible = False
		this.height = 1744
		this.width = 3494
		cb_print_preview.enabled = True
		cb_print_preview.visible = True
		cb_generate_reports.enabled = True
		cb_generate_reports.visible = True
		cb_spool.enabled = True
		cb_spool.visible = True
		cb_close.enabled = True
		cb_close.visible = True
		cbx_progress_bar.enabled = True
		cbx_progress_bar.visible = True
		cbx_time_monitor.enabled = True
		cbx_time_monitor.visible = True
		cb_print_log.visible = False
		cb_print.visible = False
		cb_cancel.visible = False
	CASE 7
		dw_calc_memo_extended.visible = True
		dw_calc_memo_extended.move( ll_dw_x, ll_dw_y )
		dw_calc_memo_extended.height = ll_dw_height
		dw_calc_memo_extended.width = ll_dw_width
		this.height = 3028
		this.width = 4654
		cb_print_preview.visible = False
		cb_generate_reports.visible = False
		cb_spool.visible = False
		cb_close.Visible = False
		cbx_progress_bar.visible = False
		cbx_time_monitor.visible = False
		cb_print_log.visible = False
		cb_print.visible = True
		cb_cancel.visible = True
	CASE 8
		dw_vas_loadload.visible = True
		dw_vas_loadload.move( ll_dw_x, ll_dw_y )
		dw_vas_loadload.height = ll_dw_height
		dw_vas_loadload.width = ll_dw_width
		this.height = 3028
		this.width = 4654
		cb_print_preview.visible = False
		cb_generate_reports.visible = False
		cb_spool.visible = False
		cb_close.Visible = False
		cbx_progress_bar.visible = False
		cbx_time_monitor.visible = False
		cb_print_log.visible = False
		cb_print.visible = True
		cb_cancel.visible = True
END CHOOSE

//w_super_vas_reports.SetRedraw( TRUE )

end subroutine

public function decimal uf_other_frt_adr_com (integer ad_calc_id);Datastore lds_calc_misc_claim_frttype_adr_comm, lds_calc_hea_dev_adr_comm
Decimal {2} ld_misc_adr_commission, ld_hea_dev_adr_commission, ld_other_frt_adr_com
Long ll_rows_1, ll_rows_2


// Adr. misc claims type frt
lds_calc_misc_claim_frttype_adr_comm = CREATE datastore
lds_calc_misc_claim_frttype_adr_comm.dataobject = "d_calc_misc_claim_frttype_adr_comm"

lds_calc_misc_claim_frttype_adr_comm.SetTransObject(SQLCA)
ll_rows_1 = lds_calc_misc_claim_frttype_adr_comm.Retrieve(ad_calc_id)

IF ll_rows_1 > 0 THEN
	ld_misc_adr_commission = lds_calc_misc_claim_frttype_adr_comm.GetItemDecimal(1,"sum_adr_com")
END IF

// Adr. hea and dev claims
lds_calc_hea_dev_adr_comm = CREATE datastore
lds_calc_hea_dev_adr_comm.dataobject = "d_calc_hea_dev_adr_comm"

lds_calc_hea_dev_adr_comm.SetTransObject(SQLCA)
ll_rows_2 = lds_calc_hea_dev_adr_comm.Retrieve(ad_calc_id)

IF ll_rows_2 > 0 THEN
	ld_hea_dev_adr_commission = lds_calc_hea_dev_adr_comm.GetItemDecimal(1,"sum_adr_com")
END IF

destroy lds_calc_misc_claim_frttype_adr_comm 
destroy lds_calc_hea_dev_adr_comm

ld_other_frt_adr_com = ld_misc_adr_commission + ld_hea_dev_adr_commission

Return ld_other_frt_adr_com


end function

public function decimal uf_frt_adr_com (decimal ad_calc_id);
/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : 
 Object  : u_vas_fix_calc_est_data
 Event	:  
 Scope   : local
************************************************************************************
 Author  : Teit Aunt 
 Date    : 4-5-98
 Description : Calculate the total frt address commission on a calculation for use in the
 					super VAS. This function only works on cargoes with a CP attached
					to it.
 Arguments   : Calculation ID
 Returns     : Decimal address commission
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
4-5-98	1.0		TA		Initial version
************************************************************************************/

// Variables
Decimal ld_adr_comm, ld_rate, ld_lumpsum, ld_ws_rate, ld_ws_flatrate, ld_total_units &
			,ld_min_1, ld_min_2, ld_over_1, ld_over_2, ld_adr_comm_pct, ld_add_lumpsum &
			,ld_gross_freight, ld_unitprice, ld_calc_id, ld_cerp_id, ld_cerp_id_two  &
			,ld_revers_units
Integer li_type, li_adr_comm_on_add_lumpsum, li_no_cargo, li_count, li_revers_freight &
			,li_done, li_count_two, li_add_lump
String ls_calc_id
long	ll_cargoid[]
Datastore lds_cargo, lds_add_lumpsums

// For test
//Open(w_calc_id)
//ls_calc_id = Message.StringParm
//ld_calc_id = Double(ls_calc_id)

// Create the datastore 
lds_cargo = Create datastore
lds_cargo.Dataobject = "ds_vas_calc_adr"
lds_cargo.SetTransObject(SQLCA)
li_no_cargo = lds_cargo.Retrieve(ad_calc_id)

IF SQLCA.SqlCode <> 0 Then 
	MessageBox("Error","Retrieve error for calculating calc. frt adr. comm.")
	Destroy lds_cargo;
	Return -1
END IF

IF NOT(li_no_cargo > 0) THEN
	// No frt rows from calc. Should not be possible.
	Destroy lds_cargo;
	Return 0
END IF

// Start the calculation
FOR li_count = 1 TO li_no_cargo 
	
	// Get the data to do the calculation
	ld_adr_comm_pct = lds_cargo.GetItemNumber(li_count,"cal_carg_adr_commision")
	li_done = lds_cargo.GetItemNumber(li_count,"creversible")

	If (ld_adr_comm_pct > 0) AND (li_done = 0) Then
	ld_revers_units = 0
	
		// Investigate whether there are reversible freight
		li_revers_freight = lds_cargo.GetItemNumber(li_count,"cal_cerp_cal_cerp_rev_freight")
		If li_revers_freight = 1 Then
			ld_cerp_id = lds_cargo.GetItemNumber(li_count,"cal_cerp_id")

			// Set cargos with same CP to done, and collect units from cargoes, except
			// the one at the row in the current for loop, because units for this row
			// will be collected and added later.
			For li_count_two = li_count + 1 TO li_no_cargo
				If ld_cerp_id = lds_cargo.GetItemNumber(li_count_two,"cal_cerp_id") Then
					lds_cargo.SetItem(li_count_two,"creversible",1)
					ld_revers_units += lds_cargo.GetItemNumber(li_count_two,"cal_carg_total_units")
				End if
			Next
		End if
		
		// Address commission % > 0 so get data to calculate on
		ld_rate = lds_cargo.GetItemNumber(li_count,"cal_carg_freight_rate")
		ld_lumpsum = lds_cargo.GetItemNumber(li_count,"cal_carg_lumpsum")
		ld_ws_rate = lds_cargo.GetItemNumber(li_count,"cal_carg_ws_rate")
		ld_ws_flatrate = lds_cargo.GetItemNumber(li_count,"cal_carg_flatrate")
		ld_total_units = lds_cargo.GetItemNumber(li_count,"cal_carg_total_units")
		ld_total_units += ld_revers_units

		ld_min_1 = lds_cargo.GetItemNumber(li_count,"cal_carg_min_1")
		If IsNull(ld_min_1) Then ld_min_1 = 0

		ld_min_2 = lds_cargo.GetItemNumber(li_count,"cal_carg_min_2")
		If IsNull(ld_min_2) Then ld_min_2 = 0

		ld_over_1 = lds_cargo.GetItemNumber(li_count,"cal_carg_overage_1")
		If IsNull(ld_over_1) Then ld_over_1 = 0
		
		ld_over_2 = lds_cargo.GetItemNumber(li_count,"cal_carg_overage_2")
		If IsNull(ld_over_2) Then ld_over_2 = 0
		
		li_type = lds_cargo.GetItemNumber(li_count,"cal_carg_freight_type")

		SetNull(ld_unitprice)
		SetNull(ld_gross_freight)

		// Calculate gross freight
		CHOOSE CASE li_type
			CASE 3
				// The ratetype is Lumpsum
				ld_gross_freight = ld_lumpsum
			CASE 1,2
				// The ratetype is USD/mt
				ld_unitprice = ld_rate
			CASE 4
				// The ratetype is Worldscale
				ld_unitprice = (ld_ws_rate / 100) * ld_ws_flatrate
		END CHOOSE
		
		If Not IsNull(ld_unitprice) Then
			
			// No minimum 1
			If ld_min_1 = 0 Then
				ld_gross_freight = ld_total_units * ld_unitprice
			End if			
	
			// If total unit < mini 1 then dead freight
			If (ld_min_1 > 0) AND (ld_total_units < ld_min_1) then
				ld_gross_freight = ld_min_1 * ld_unitprice
			End if
		
			// 0 < Minimum 1 < total units
			If (ld_min_1 > 0) AND (ld_min_1 <= ld_total_units) Then
				ld_gross_freight = (ld_min_1 * ld_unitprice) + ((ld_total_units - ld_min_1) * &
							(ld_unitprice * (ld_over_1 / 100)))
			End if
	
			// If 0 < minimum 1 < minimum 2 < total units
			If (ld_min_1 > 0) AND (ld_min_1 < ld_min_2) AND (ld_min_2 < ld_total_units) Then
				ld_gross_freight = (ld_min_1 * ld_unitprice) + ((ld_min_2 - ld_min_1) * &
							(ld_unitprice * (ld_over_1 / 100))) + ((ld_total_units - ld_min_2) * &
							(ld_unitprice * (ld_over_2 / 100))) 
			End if
		End if
		
		ll_cargoid[1] = lds_cargo.getItemNumber(li_count, "cal_carg_id")
		lds_add_lumpsums = create datastore
		lds_add_lumpsums.dataObject="d_calc_lumpsum"
		lds_add_lumpsums.setTransObject( sqlca )
		lds_add_lumpsums.retrieve(ll_cargoid)
		for li_add_lump = 1 to lds_add_lumpsums.rowcount( )
			// Add added lumpsum to gross freight
			if lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_adr_comm")= 1 and not isNull(lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum"))  then
				ld_gross_freight += lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum")
			end if
		next
		
		// Calculate the address commission for the cargo
		ld_adr_comm += ld_gross_freight * (ld_adr_comm_pct / 100)
	End if
NEXT

// Destroy the dataobject
Destroy(lds_cargo)

// Returns
Return(ld_adr_comm)

end function

public function decimal uf_dem_adr_com (decimal ad_total_adr_com, decimal ad_frt_adr_com, decimal ad_calc_id, decimal ad_other_frt_adr_com);
//Datastore lds_calc_misc_claim_adr_comm
Decimal ld_misc_adr_commission, ld_dem_adr
Long ll_rows

//// Adr. misc claims type misc
//lds_calc_misc_claim_adr_comm = CREATE datastore
//lds_calc_misc_claim_adr_comm.dataobject = "d_calc_misc_claim_adr_comm"
//
//lds_calc_misc_claim_adr_comm.SetTransObject(SQLCA)
//ll_rows = lds_calc_misc_claim_adr_comm.Retrieve(ad_calc_id)
//
//IF ll_rows > 0 THEN
//	ld_misc_adr_commission = lds_calc_misc_claim_adr_comm.GetItemDecimal(1,"sum_adr_com")
//END IF

//ld_dem_adr = ad_total_adr_com - ad_frt_adr_com  - ld_misc_adr_commission - ad_other_frt_adr_com
ld_dem_adr = ad_total_adr_com - ad_frt_adr_com  - ad_other_frt_adr_com

//Destroy lds_calc_misc_claim_adr_comm

Return ld_dem_adr
end function

public subroutine uf_create_extended_calc_memo (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_calc_memo);//This function adds calculatede and estimatede columns to the Calculation Memo

n_ds lds_calc_fix_id, lds_calc_total, lds_calc_port_exp
integer li_count, li_counter
long ll_row_count, ll_counter, ll_fix_id, ll_calc_id, ll_counter_port_exp
decimal ld_freight, ld_dem, ld_comm, ld_bunker, ld_misc, ld_port_exp, ld_total_port_exp
decimal ld_adr_comm, ld_frt_comm, ld_other_frt_comm, ld_total_adr_comm
lds_calc_fix_id = create n_ds
lds_calc_fix_id.dataObject = "d_vas_calc_memo_ext_fix_id"
lds_calc_fix_id.setTransObject(SQLCA)

lds_calc_total = create n_ds
lds_calc_total.dataObject = "d_vas_calc_memo_fix_calc_est_total"
lds_calc_total.setTransObject(SQLCA)

lds_calc_port_exp = create n_ds
lds_calc_port_exp.dataObject = "d_estimated_port_expenses"
lds_calc_port_exp.setTransObject(SQLCA)

li_count = lds_calc_fix_id.Retrieve(ai_vessel_nr,as_voyage_nr)

IF li_count > 0 THEN
	ll_fix_id = lds_calc_fix_id.GetItemNumber(1,"cal_calc_cal_calc_fix_id")
	FOR li_counter = 5 TO 6 
		lds_calc_total.Reset()
		li_count = lds_calc_total.Retrieve(li_counter,ll_fix_id)
		IF li_count > 0 THEN
				ll_calc_id = lds_calc_total.GetItemNumber(1,"cal_calc_id")
				ld_comm = lds_calc_total.GetItemNumber(1,"commission")
				ld_frt_comm = uf_frt_adr_com(ll_calc_id) 
				ld_other_frt_comm = uf_other_frt_adr_com(ll_calc_id)
				ld_total_adr_comm = lds_calc_total.GetItemNumber(1,"total_adr_comm")
				ld_adr_comm = uf_dem_adr_com(ld_total_adr_comm, ld_frt_comm, ll_calc_id, ld_other_frt_comm)
				ld_dem = lds_calc_total.GetItemNumber(1,"demurrage") + lds_calc_total.getItemNumber(1, "misc_inco")
				ld_freight = lds_calc_total.GetItemNumber(1,"gross_freight") - ld_dem - ld_frt_comm - ld_other_frt_comm
				ld_dem = ld_dem - ld_adr_comm
				ld_bunker = lds_calc_total.GetItemNumber(1,"total_bunker_exp")
//				ld_misc = lds_calc_total.GetItemNumber(1,"total_misc")
				ld_misc = lds_calc_total.GetItemNumber(1,"misc_exp")
				ld_total_port_exp = lds_calc_total.GetItemNumber(1,"total_port_exp")
			CHOOSE CASE li_counter
			CASE 5
					adw_calc_memo.Object.calc_freight.Expression = string(ld_freight)
					adw_calc_memo.Object.calc_dem_des.Expression = string(ld_dem)
					adw_calc_memo.Object.calc_broker_comm.Expression = string(ld_comm)
					adw_calc_memo.Object.calc_bunker_exp.Expression = string(ld_bunker)
					adw_calc_memo.Object.calc_misc_exp.Expression = string(ld_misc)
					IF adw_calc_memo.GetItemString(1, "port_name") = "no match" THEN
						adw_calc_memo.SetItem(1, "calc_port_exp", ld_total_port_exp)
					ELSE
						ll_row_count = adw_calc_memo.RowCount()
						li_count = lds_calc_port_exp.Retrieve(ll_calc_id)
						IF li_count > 0 THEN
							if f_AtoBviaC_used(ai_vessel_nr,as_voyage_nr) then 	uf_atobviac_port_expenses( lds_calc_port_exp , ll_calc_id )
							ll_counter_port_exp = 1
							for ll_counter = 1 TO ll_row_count
								IF lds_calc_port_exp.GetItemString(ll_counter_port_exp, "cal_caio_port_code") = adw_calc_memo.GetItemString(ll_counter, "port_name") THEN
									ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp")
									adw_calc_memo.SetItem(ll_counter, "calc_port_exp", ld_port_exp)
									IF len(lds_calc_port_exp.GetItemString(ll_counter_port_exp, "vp_1")) > 1 THEN
										ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp_vp_1")
										IF adw_calc_memo.Rowcount() >= ll_counter + 1 THEN
											adw_calc_memo.SetItem(ll_counter+1, "calc_port_exp", ld_port_exp)
										END IF
									END IF
									IF len(lds_calc_port_exp.GetItemString(ll_counter_port_exp, "vp_2")) > 1 THEN
										ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp_vp_2")
										IF adw_calc_memo.Rowcount() >= ll_counter + 2 THEN
											adw_calc_memo.SetItem(ll_counter+2, "calc_port_exp", ld_port_exp)
										END IF
									END IF
									IF len(lds_calc_port_exp.GetItemString(ll_counter_port_exp, "vp_3")) > 1 THEN
										ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp_vp_3")
										IF adw_calc_memo.Rowcount() >= ll_counter + 3 THEN
											adw_calc_memo.SetItem(ll_counter+3, "calc_port_exp", ld_port_exp)
										END IF
									END IF
									ll_counter_port_exp ++
								END IF
							next
						END IF
					END IF
			CASE 6
					adw_calc_memo.Object.est_freight.Expression = string(ld_freight)
					adw_calc_memo.Object.est_dem_des.Expression = string(ld_dem)
					adw_calc_memo.Object.est_broker_comm.Expression = string(ld_comm)
					adw_calc_memo.Object.est_bunker_exp.Expression = string(ld_bunker)
					adw_calc_memo.Object.est_misc_exp.Expression = string(ld_misc)
					IF adw_calc_memo.GetItemString(1, "port_name") = "no match" THEN
						adw_calc_memo.SetItem(1, "est_port_exp", ld_total_port_exp)
					ELSE
						ll_row_count = adw_calc_memo.RowCount()
						li_count = lds_calc_port_exp.Retrieve(ll_calc_id)
						IF li_count > 0 THEN
							if f_AtoBviaC_used(ai_vessel_nr,as_voyage_nr) then 	uf_atobviac_port_expenses( lds_calc_port_exp , ll_calc_id )
							ll_counter_port_exp = 1
							for ll_counter = 1 TO ll_row_count
								IF lds_calc_port_exp.GetItemString(ll_counter_port_exp, "cal_caio_port_code") = adw_calc_memo.GetItemString(ll_counter, "port_name") THEN
									ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp")
									adw_calc_memo.SetItem(ll_counter, "est_port_exp", ld_port_exp)
									IF len(lds_calc_port_exp.GetItemString(ll_counter_port_exp, "vp_1")) > 1 THEN
										ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp_vp_1")
										IF adw_calc_memo.Rowcount() >= ll_counter + 1 THEN
											adw_calc_memo.SetItem(ll_counter+1, "est_port_exp", ld_port_exp)
										END IF
									END IF
									IF len(lds_calc_port_exp.GetItemString(ll_counter_port_exp, "vp_2")) > 1 THEN
										ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp_vp_2")
										IF adw_calc_memo.Rowcount() >= ll_counter + 2 THEN
											adw_calc_memo.SetItem(ll_counter+2, "est_port_exp", ld_port_exp)
										END IF
									END IF
									IF len(lds_calc_port_exp.GetItemString(ll_counter_port_exp, "vp_3")) > 1 THEN
										ld_port_exp = lds_calc_port_exp.GetItemNumber(ll_counter_port_exp, "exp_vp_3")
										IF adw_calc_memo.Rowcount() >= ll_counter + 3 THEN
											adw_calc_memo.SetItem(ll_counter+3, "est_port_exp", ld_port_exp)
										END IF
									END IF
									ll_counter_port_exp ++
								END IF
							next
						END IF
					END IF
			END CHOOSE				
		END IF
	NEXT
END IF
adw_calc_memo.Groupcalc()
DESTROY lds_calc_fix_id
DESTROY lds_calc_total
DESTROY lds_calc_port_exp
end subroutine

public subroutine wf_print_report (datawindow adw);string 	ls_Key_def_printer, ls_Key_pdf_printer
string	ls_DefaultPrinter, ls_PDFdriver, ls_PDFprinter
boolean	lb_printer

ls_Key_def_printer = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows" //WinNT Path
ls_Key_pdf_printer = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices" //NT

if rb_printer.checked then
	lb_printer = true
else
	lb_printer = false
end if

CHOOSE CASE lb_printer
	CASE true /* Printer */
		adw.Print(false)
	CASE false /* PDF file */
		/*Get the current printer*/
		IF RegistryGet (ls_Key_def_printer, "Device", ls_DefaultPrinter) <> 1 THEN
			MessageBox("Error!", "Error getting Default printer from registry key. ~r~nPlease try again "+&
							"or contact System Administrator if the problem recurs.", StopSign!)
			RETURN
		END IF
		
		ls_PDFdriver = uo_global.is_pdfdriver
		if  ls_PDFdriver = "None" then
			MessageBox("Error!", "No PDF printer driver found in TRAMOS.INI file. ~r~nPlease try again "+&
							"or contact the System Administrator if the problem recurs.", StopSign!)
			RETURN
		END IF
			
		/*Get the details of the PDF printer*/
		IF RegistryGet (ls_key_pdf_printer, ls_PDFdriver, ls_pdfPrinter) <> 1 THEN
			MessageBox("Error!", "Error getting PDF printer from registry. ~r~nPlease try again "+&
							"or contact the System Administrator if the problem recurs.", StopSign!)
			RETURN
		END IF
		
		/*Set the default printer to PDF, print, and set the default printer back to the original default*/
		IF RegistrySet(ls_key_def_printer, "Device", ls_PDFdriver+","+ls_pdfPrinter) = 1 THEN
			adw.print(false)
			RegistrySet(ls_key_def_printer, "Device", ls_DefaultPrinter)
		ELSE
			MessageBox("Error!", "Error setting printer to PDF. ~r~nPlease try again or contact the "+&
							"System Administrator if the problem recurs.", StopSign!)
		END IF
END CHOOSE

end subroutine

public function integer uf_atobviac_port_expenses (ref datastore ads, long al_calc_id);/********************************************************************
   uf_atobviac_port_expenses
   <DESC>	</DESC>
   <RETURN>	long	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
   	11/07/2013		CR2759		WWG004		when there are two port of calls of the same port, only the port and purpose
															are same at the same time, then delete the duplicate port.
   </HISTORY>
********************************************************************/

String ls_port_code,  ls_ballast_from, ls_port, ls_previous_port, ls_first_port, ls_port_purpose, ls_previous_purpose
Decimal ld_exp
Boolean lb_reversible
Long ll_est_rows, ll_route_rows, ll_counter, ll_newrow, ll_x
Datastore lds_est_route
long ll_route_row, ll_est_row, ll_insert_row, ll_act_row
boolean lb_add_flag, lb_port_purpose
integer	li_voyage_type, li_count

SELECT VOYAGE_TYPE
	INTO :li_voyage_type 
	FROM VOYAGES
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr;

lds_est_route 		= CREATE Datastore
lds_est_route.dataobject = "d_sq_tb_estimated_route_expenses"
lds_est_route.SetTransObject(SQLCA)

ll_est_rows = ads.rowCount()
ll_route_rows = lds_est_route.Retrieve(al_calc_id)

// husk fjern ballast ports, men kun hvis første havn ikke er den samme
SELECT CAL_CALC.CAL_CALC_BALLAST_FROM, CAL_CAIO.PORT_CODE
	INTO :ls_ballast_from, :ls_first_port
	FROM CAL_CALC, CAL_CARG, CAL_CAIO
	WHERE CAL_CARG.CAL_CALC_ID = CAL_CALC.CAL_CALC_ID
	AND CAL_CAIO.CAL_CARG_ID = CAL_CARG.CAL_CARG_ID
	AND CAL_CALC.CAL_CALC_ID = :al_calc_id
	AND CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER = 1;

for ll_x = 1 to lds_est_route.rowcount( )
	if not isnull(lds_est_route.getItemString(ll_x, "purpose_code")) then
		lb_port_purpose = true
		exit
	end if
next
if not isNull(ls_ballast_from) and ls_ballast_from <> "" then
	if lb_port_purpose then
		lds_est_route.deleterow(1)
		ll_route_rows --
		li_count ++
	else
		if ls_first_port <> ls_ballast_from then
			lds_est_route.deleterow(1)
			ll_route_rows --
			li_count ++
		end if
	end if
end if
//only compare with purporse for single voyage
if li_voyage_type <> 1 then
	lb_port_purpose = false
end if

IF ll_est_rows > 0 THEN 
	//Check if reversible dem.
	SELECT DISTINCT CAL_CERP.CAL_CERP_REV_DEM
		INTO :lb_reversible
		FROM CAL_CERP, CAL_CARG 
		WHERE CAL_CARG.CAL_CALC_ID = :al_calc_id
		AND CAL_CARG .CAL_CERP_ID = CAL_CERP.CAL_CERP_ID;

	// IF Reversible then sum up(exp) rows with identical portcode, and
	// delete row. Note that if reversible, and 2 rows are identical, the first
	// can not have viapoints, and viapoints exp.
	if lb_reversible then
		for ll_counter = 1 to ll_est_rows
			ls_port = ads.GetItemString(ll_counter, "cal_caio_port_code")
			
			ls_port_purpose = ads.GetItemString(ll_counter, "cal_caio_purpose_code")
			if ls_previous_port = ls_port then
				if ls_previous_purpose = ls_port_purpose or ls_previous_purpose = "L" and ls_port_purpose = "D" or ls_previous_purpose = "D" and ls_port_purpose = "L" then
					ld_exp = ads.GetItemDecimal(ll_counter - 1, "exp")
					ld_exp += ads.GetItemDecimal(ll_counter, "exp")
					ads.SetItem(ll_counter,"exp", ld_exp)
					ads.DeleteRow(ll_counter - 1)
					//There are one less row in ds, and ll_counter must adjust to that
					ll_est_rows --
					ll_counter --
				end if
			end if
			
			ls_previous_port = ls_port
			ls_previous_purpose = ls_port_purpose
		next
	end if

	/* Add routing points to estimated port */
	ll_route_row=1
	ll_est_row=1
	do while ll_route_row <= ll_route_rows
		if ll_est_row > ads.rowCount() then
			ll_insert_row = ads.insertRow(0)
			ads.setItem(ll_insert_row, "cal_caio_port_code", lds_est_route.getItemString(ll_route_row, "port_code"))
			ads.setItem(ll_insert_row, "exp", lds_est_route.getItemNumber(ll_route_row, "rp_expenses"))
			ads.setItem(ll_insert_row, "exp_vp_1",0)  // for calculation to be right. using same dw as BP calculations
			ads.setItem(ll_insert_row, "exp_vp_2",0)
			ads.setItem(ll_insert_row, "exp_vp_3",0)
			ll_route_row ++
			ll_est_row ++
		else
			if ads.getItemString(ll_est_row, "cal_caio_port_code") <> lds_est_route.getItemString(ll_route_row, "port_code") then
				ll_insert_row = ads.insertRow(ll_est_row)
				ads.setItem(ll_insert_row, "cal_caio_port_code", lds_est_route.getItemString(ll_route_row, "port_code"))
				ads.setItem(ll_insert_row, "exp", lds_est_route.getItemNumber(ll_route_row, "rp_expenses"))
				ads.setItem(ll_insert_row, "exp_vp_1",0)  // for calculation to be right. using same dw as BP calculations
				ads.setItem(ll_insert_row, "exp_vp_2",0)
				ads.setItem(ll_insert_row, "exp_vp_3",0)
			else
				ll_route_row ++
				ll_est_row ++
			end if
		end if
	loop
END IF

DESTROY lds_est_route ;

Return 1
end function

public function integer uf_loadload_vas (integer ai_vessel, string as_voyage, ref datawindow adw_loadvas);long					ll_fixture_calcID, ll_calc_calcID, ll_est_calcID, ll_load_calcID
long					ll_fixID, ll_rc
string 				ls_fixing_charterer
datawindowchild	ldwc
u_vas_fix_calc_est_data	lnv_loadcalc

setPointer(hourglass!)

open(w_gererate_loadload_splash_window)

/* set invisible */
dw_vas_loadload.object.fixture_itinerary.visible = false
dw_vas_loadload.object.est_itinerary.visible = false

/* Get Estimated calc id */
SELECT CAL_CALC_ID
	INTO :ll_est_calcID
	FROM VOYAGES
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage;
COMMIT;
w_gererate_loadload_splash_window.hpb_1.position = 2

SELECT CAL_CALC_FIX_ID
	INTO :ll_fixID
	FROM CAL_CALC
	WHERE CAL_CALC_ID = :ll_est_calcID;
COMMIT;
w_gererate_loadload_splash_window.hpb_1.position = 4

SELECT CAL_CALC_ID
	INTO :ll_fixture_calcID
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_fixID
	AND CAL_CALC_STATUS = 4;
COMMIT;
w_gererate_loadload_splash_window.hpb_1.position = 6

SELECT CAL_CALC_ID
	INTO :ll_calc_calcID
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_fixID
	AND CAL_CALC_STATUS = 5;
COMMIT;
w_gererate_loadload_splash_window.hpb_1.position = 8
	
SELECT CAL_CALC_ID
	INTO :ll_load_calcID
	FROM CAL_CALC
	WHERE CAL_CALC_FIX_ID = :ll_fixID
	AND CAL_CALC_STATUS = 7;
if isNull(ll_load_calcID) or sqlca.sqlcode <> 0 then
	COMMIT;			//no load load calculation
	return -1
end if
COMMIT;
w_gererate_loadload_splash_window.hpb_1.position = 25

/* Set load load VAS */
lnv_loadcalc = create u_vas_fix_calc_est_data
lnv_loadcalc.of_start_calc_loadload( ll_load_calcID , dw_vas_loadload )
destroy lnv_loadcalc
w_gererate_loadload_splash_window.hpb_1.position = 40

SELECT USERS.FIRST_NAME + " "+USERS.LAST_NAME
	INTO :ls_fixing_charterer
	FROM CAL_CALC, USERS
	WHERE CAL_CALC.CAL_CALC_LAST_EDITED_BY = USERS.USERID
	AND CAL_CALC.CAL_CALC_ID = :ll_fixture_calcID ;
COMMIT;
dw_vas_loadload.setItem(1, "fixing_charterer", ls_fixing_charterer)

of_move_columns( "load", "calc")
of_move_columns( "act", "est_act")
dw_vas_loadload.Object.t_50.text = "Load/Load 'Calculation'"
setPointer(hourglass!)

/* Remove first leg and add leg back to loadport */
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
of_modifyactualloadload( )

/* Retrieve portcall before load */
ll_rc = dw_vas_loadload.getchild( "dw_poc_before_load", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ii_vessel_nr, is_voyage_nr )

/* Retrieve routes */
ll_rc = dw_vas_loadload.getchild( "dw_fixture_route", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_fixture_calcID)
w_gererate_loadload_splash_window.hpb_1.position = 45

ll_rc = dw_vas_loadload.getchild( "dw_calc_route", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_calc_calcID)

ll_rc = dw_vas_loadload.getchild( "dw_est_act_route", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_est_calcID)

ll_rc = dw_vas_loadload.getchild( "dw_act_route", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_est_calcID)

ll_rc = dw_vas_loadload.getchild( "dw_load_route", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_load_calcID)
w_gererate_loadload_splash_window.hpb_1.position = 60

/* Itinerary */
ll_rc = dw_vas_loadload.getchild( "dw_fixture_itinerary", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_fixture_calcID)

ll_rc = dw_vas_loadload.getchild( "dw_est_act_itinerary", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_est_calcID)

ll_rc = dw_vas_loadload.getchild( "dw_act_itinerary", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_est_calcID)

ll_rc = dw_vas_loadload.getchild( "dw_load_itinerary", ldwc)
ldwc.setTransObject(sqlca)
ldwc.retrieve(ll_load_calcID)
w_gererate_loadload_splash_window.hpb_1.position = 70

/* Set Cargo section */
of_setloadloadcargosection( ll_fixture_calcID , "fixture", dw_vas_loadload )
of_setloadloadcargosection( ll_calc_calcID , "calc", dw_vas_loadload )
//of_setloadloadcargosection( ll_est_calcID , "est", dw_vas_loadload )
of_setloadloadcargosection( ll_est_calcID , "act", dw_vas_loadload )
of_setloadloadcargosection( ll_est_calcID , "est_act", dw_vas_loadload )
of_setloadloadcargosection( ll_load_calcID , "load", dw_vas_loadload )
setPointer(hourglass!)
w_gererate_loadload_splash_window.hpb_1.position = 80

/* Port Expenses */
ll_rc = dw_vas_loadload.getchild( "dw_fixture_portexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_fixture_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_calc_portexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_calc_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_est_portexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_est_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_act_portexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_est_calcID)  
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_load_portexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_load_calcID)
setPointer(hourglass!)
w_gererate_loadload_splash_window.hpb_1.position = 90

/* Misc. Expenses */
ll_rc = dw_vas_loadload.getchild( "dw_fixture_miscexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_fixture_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_calc_miscexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_calc_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_est_miscexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_est_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_act_miscexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_est_calcID)  
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_load_miscexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_load_calcID)
setPointer(hourglass!)
w_gererate_loadload_splash_window.hpb_1.position = 95

/* Canal Expenses */
ll_rc = dw_vas_loadload.getchild( "dw_fixture_canalexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_fixture_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_calc_canalexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_calc_calcID)
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_est_canalexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_est_calcID)
setPointer(hourglass!)
w_gererate_loadload_splash_window.hpb_1.position = 98

ll_rc = dw_vas_loadload.getchild( "dw_act_canalexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_est_calcID)  
setPointer(hourglass!)

ll_rc = dw_vas_loadload.getchild( "dw_load_canalexp", ldwc)
ldwc.setTransObject(sqlca)
ll_rc = ldwc.retrieve(ll_load_calcID)
setPointer(hourglass!)
w_gererate_loadload_splash_window.hpb_1.position = 100
post close(w_gererate_loadload_splash_window)

return 1
end function

public function integer of_setloadloadcargosection (long al_calcid, string as_calctype, ref datawindow adw_report);/* calculates the detail freight so that all the figures can be shown in detail
	
	as_calctype = "fixture", "calc", "est", "est_act", "act" or "load" and is used to set report variables
*/

datastore	lds_data, lds_add_lumpsums
long			ll_row, ll_rows
decimal 		ld_rate, ld_overage1, ld_min1, ld_overage2, ld_min2, ld_load_quantity, ld_intake
decimal 		ld_base_freight=0, ld_overage=0, ld_dead_freight=0, ld_additional_lumpsum=0, ld_addr_com=0, ld_add_addr_comm=0
string			ls_freightrate
integer		li_add_lump

lds_data = create datastore
lds_data.dataObject="d_sq_tb_vas_loadload_freightcalc"
lds_data.setTransObject( sqlca )

ll_rows = lds_data.retrieve(al_calcID)

for ll_row = 1 to ll_rows
	/* Set rate per ton */
	choose case lds_data.getItemNumber(ll_row, "cal_carg_freight_type")
		case 1  		/* per MT */
			ld_rate = lds_data.getItemNumber(ll_row, "cal_carg_freight_rate")
			ls_freightrate = string(ld_rate, "#,##0.00") + " per MT" 
		case 2  		/* per CBM */
			ld_rate = lds_data.getItemNumber(ll_row, "cal_carg_freight_rate")
			ls_freightrate = string(ld_rate, "#,##0.00") + " per CBM" 
		case 4		/* WS */
			ld_rate = lds_data.getItemNumber(ll_row, "cal_carg_ws_rate") * lds_data.getItemNumber(ll_row, "cal_carg_flatrate") / 100
			ls_freightrate = "WS: "+string(lds_data.getItemNumber(ll_row, "cal_carg_ws_rate"), "#,##0.00") + "%  Rate: "+ string(lds_data.getItemNumber(ll_row, "cal_carg_flatrate"), "#,##0.00") 
		case else		/* Lumpsum */
			ld_rate = 0
			ls_freightrate = "Lumpsum" 
	end choose
	/* set other relevant varaibles */
	ld_overage1 = lds_data.getItemNumber(ll_row, "cal_carg_overage_1")
	ld_min1 = lds_data.getItemNumber(ll_row, "cal_carg_min_1")
	if ld_min1 <= 0 then setNull(ld_min1)
	ld_overage2 = lds_data.getItemNumber(ll_row, "cal_carg_overage_2")
	ld_min2 = lds_data.getItemNumber(ll_row, "cal_carg_min_2")
	if ld_min2 <= 0 then setNull(ld_min2)
	if as_calctype = "act" then
		of_setactualintake( al_calcid , ld_intake, ld_load_quantity, lds_data.getItemNumber(ll_row, "cal_cerp_id"))			
	else
		ld_load_quantity = lds_data.getItemNumber(ll_row, "cal_carg_total_units")
		ld_intake = lds_data.getItemNumber(ll_row, "cal_carg_total_units")
	end if
	
	/* calculate cargo */
	if lds_data.getItemNumber(ll_row, "cal_carg_freight_type")  <> 3 then
		IF Isnull(ld_min2) AND Isnull(ld_min1) THEN
			/* Min_1 og Min_2 ikke indtastet */
			ld_base_freight += ld_load_quantity * ld_rate
			ld_overage += 0
			ld_dead_freight += 0
		ELSEIF IsNull(ld_min2) THEN
			/* Min_2 ikke indtastet */
			IF ld_load_quantity >= ld_min1 THEN
				ld_base_freight += ld_min1 * ld_rate
				ld_overage += (ld_load_quantity - ld_min1) * (ld_rate * ld_overage1/100)
				ld_dead_freight += 0
			ELSE
				ld_base_freight += ld_load_quantity * ld_rate
				ld_overage += 0
				ld_dead_freight += (ld_min1 - ld_load_quantity) * ld_rate
			END IF
		ELSE
			IF ld_load_quantity >= ld_min2 THEN
				ld_base_freight += ld_min1 * ld_rate
				ld_overage += (ld_load_quantity - ld_min2) * (ld_rate * ld_overage2/ 100)  &
								+(ld_min2 - ld_min1) * (ld_rate * ld_overage1/ 100)
				ld_dead_freight = 0
		ELSEIF ld_load_quantity >= ld_min1 THEN
				ld_base_freight += ld_min1 * ld_rate
				ld_overage += (ld_load_quantity - ld_min1) * (ld_rate * ld_overage1/100) 
				ld_dead_freight += 0
			ELSE
				ld_base_freight += ld_load_quantity * ld_rate
				ld_overage += 0
				ld_dead_freight += (ld_min1 - ld_load_quantity) * ld_rate
			END IF	
		END IF		
	else
		ld_base_freight += lds_data.getItemNumber(ll_row, "cal_carg_lumpsum")
	end if
	
	/* calculate addr. commission */
	if lds_data.getItemNumber(ll_row, "cal_carg_adr_commision") > 0 then
		ld_addr_com += (ld_base_freight + ld_overage + ld_dead_freight) * lds_data.getItemNumber(ll_row, "cal_carg_adr_commision")/100
	end if
	
	lds_add_lumpsums = create datastore
	lds_add_lumpsums.dataObject="d_calc_lumpsum"
	lds_add_lumpsums.setTransObject( sqlca )
	lds_add_lumpsums.retrieve(lds_data.getItemNumber(ll_row, "cal_carg_id"))
	for li_add_lump = 1 to lds_add_lumpsums.rowcount( )
		/* add additional lumpsum */
		if not isNull(lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum")) then
			ld_additional_lumpsum += lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum")
		end if
		/* calculate addr. commission */
		if lds_data.getItemNumber(ll_row, "cal_carg_adr_commision") > 0 and  lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_adr_comm")= 1 then
			ld_add_addr_comm += lds_add_lumpsums.getItemNumber(li_add_lump, "cal_lump_add_lumpsum") * lds_data.getItemNumber(ll_row, "cal_carg_adr_commision")/100
		end if
	next
next	

/* set variables in report */
adw_report.setItem(1, as_calctype +"_freight_rate", ls_freightrate)
adw_report.setItem(1, as_calctype +"_intake", ld_load_quantity)
adw_report.setItem(1, as_calctype +"_bol_qty", ld_load_quantity)
adw_report.setItem(1, as_calctype +"_basefreight", ld_base_freight )
adw_report.setItem(1, as_calctype +"_overage", ld_overage )
adw_report.setItem(1, as_calctype +"_deadfreight", ld_dead_freight )
adw_report.setItem(1, as_calctype +"_addlumpsum", ld_additional_lumpsum )
adw_report.setItem(1, as_calctype +"_addrcomm", ld_addr_com )
adw_report.setItem(1, as_calctype +"_add_addrcomm", ld_add_addr_comm )

return 1

end function

public function integer of_setactualintake (long al_calcid, ref decimal ad_intake, ref decimal ad_bol_quantity, long ad_cerpid);/* This function finds actual freight figures */ 
SELECT sum(CD.SHIPS_FIG),   
	sum(CD.TOTAL_BOL_LOAD_QTY)  
INTO :ad_intake,   
	:ad_bol_quantity  
FROM CD,   
	VOYAGES  
WHERE CD.VESSEL_NR = VOYAGES.VESSEL_NR 
AND VOYAGES.VOYAGE_NR = CD.VOYAGE_NR 
AND VOYAGES.CAL_CALC_ID = :al_calcid 
AND CD.CAL_CERP_ID = :ad_cerpid ;
commit;

return 1

end function

public function integer of_move_columns (string as_from, string as_to);/* This function moves data from one column in VAS report to another.

	arguments are column Prefix such as "fixture", "calc", "est_act", "act" or "load" */
	
	
	
dw_vas_loadload.setItem(1, as_to+"_freight", dw_vas_loadload.getItemNumber(1, as_from+"_freight"))
dw_vas_loadload.setItem(1, as_to+"_dem_des", dw_vas_loadload.getItemNumber(1, as_from+"_dem_des"))
dw_vas_loadload.setItem(1, as_to+"_broker_comm", dw_vas_loadload.getItemNumber(1, as_from+"_broker_comm"))
dw_vas_loadload.setItem(1, as_to+"_port_exp", dw_vas_loadload.getItemNumber(1, as_from+"_port_exp"))
dw_vas_loadload.setItem(1, as_to+"_bunk_exp", dw_vas_loadload.getItemNumber(1, as_from+"_bunk_exp"))
dw_vas_loadload.setItem(1, as_to+"_misc_exp", dw_vas_loadload.getItemNumber(1, as_from+"_misc_exp"))
dw_vas_loadload.setItem(1, as_to+"_drc_tc", dw_vas_loadload.getItemNumber(1, as_from+"_drc_tc"))

dw_vas_loadload.setItem(1, as_to+"_days_loading", dw_vas_loadload.getItemNumber(1, as_from+"_days_loading"))
dw_vas_loadload.setItem(1, as_to+"_days_discharge", dw_vas_loadload.getItemNumber(1, as_from+"_days_discharge"))
dw_vas_loadload.setItem(1, as_to+"_days_load_and_disch", dw_vas_loadload.getItemNumber(1, as_from+"_days_load_and_disch"))
dw_vas_loadload.setItem(1, as_to+"_days_bunkering", dw_vas_loadload.getItemNumber(1, as_from+"_days_bunkering"))
dw_vas_loadload.setItem(1, as_to+"_days_canal", dw_vas_loadload.getItemNumber(1, as_from+"_days_canal"))
dw_vas_loadload.setItem(1, as_to+"_days_dry_dock", dw_vas_loadload.getItemNumber(1, as_from+"_days_dry_dock"))
dw_vas_loadload.setItem(1, as_to+"_days_loaded", dw_vas_loadload.getItemNumber(1, as_from+"_days_loaded"))
dw_vas_loadload.setItem(1, as_to+"_days_ballast", dw_vas_loadload.getItemNumber(1, as_from+"_days_ballast"))
dw_vas_loadload.setItem(1, as_to+"_days_other", dw_vas_loadload.getItemNumber(1, as_from+"_days_other"))
dw_vas_loadload.setItem(1, as_to+"_days_idle", dw_vas_loadload.getItemNumber(1, as_from+"_days_idle"))
dw_vas_loadload.setItem(1, as_to+"_days_off_service", dw_vas_loadload.getItemNumber(1, as_from+"_days_off_service"))

dw_vas_loadload.setItem(1, as_to+"_bunkers_fuel", dw_vas_loadload.getItemNumber(1, as_from+"_bunkers_fuel"))
dw_vas_loadload.setItem(1, as_to+"_bunker_fuel_exp", dw_vas_loadload.getItemNumber(1, as_from+"_bunker_fuel_exp"))
dw_vas_loadload.setItem(1, as_to+"_bunkers_diesel", dw_vas_loadload.getItemNumber(1, as_from+"_bunkers_diesel"))
dw_vas_loadload.setItem(1, as_to+"_bunker_diesel_exp", dw_vas_loadload.getItemNumber(1, as_from+"_bunker_diesel_exp"))
dw_vas_loadload.setItem(1, as_to+"_bunkers_gas", dw_vas_loadload.getItemNumber(1, as_from+"_bunkers_gas"))
dw_vas_loadload.setItem(1, as_to+"_bunker_gas_exp", dw_vas_loadload.getItemNumber(1, as_from+"_bunker_gas_exp"))
dw_vas_loadload.setItem(1, as_to+"_bunkers_lshfo", dw_vas_loadload.getItemNumber(1, as_from+"_bunkers_lshfo"))
dw_vas_loadload.setItem(1, as_to+"_bunker_lshfo_exp", dw_vas_loadload.getItemNumber(1, as_from+"_bunker_lshfo_exp"))

return 1
end function

private function integer of_modifyactualloadload ();/*	This function modifies the actual load load calculation. 
	Removes first leg to the first load port and adds the leg from last port back to first loadport

	pv = previous voyage
	cv = current voyage

	in all arrays 1 = HFO, 2 = DO, 3 = GO and 4 = LSHFO
*/
string			ls_startvoyage, ls_startport, ls_endport, ls_firstloadport, ls_workport, ls_lastport, ls_firstloadport_abc, ls_lastport_abc
integer		li_startport_pcn, li_endport_pcn, li_workport_pcn, li_distance
string			ls_bunkertype[4] = {"HFO", "DO", "GO", "LSHFO"}
datastore	lds_poc
decimal {4}  ld_startamount[4], ld_startqty[4], ld_firstloadamount[4], ld_firstloadqty[4]
decimal {4}	ld_liftedamount[4], ld_liftedqty[4], ld_liftedSQLqty[4], ld_liftedSQLamount[4]
decimal {4}	ld_voyage_consumption_qty[4], ld_voyage_consumption_usd[4]
decimal {4}	ld_voyage_avg_bunkerprice[4]
decimal {4}	ld_firstleg_consumption_qty[4], ld_firstleg_consumption_usd[4]
decimal {4}	ld_lastleg_consumption_qty[4], ld_lastleg_consumption_usd[4]
long			ll_rows, ll_row, ll_fuel_index
decimal{2}	ld_subtract_portexpenses, ld_subtract_miscexpenses, ld_work_expenses
decimal {2}	ld_bunkering_days, ld_work_days, ld_ballast_days
string			ls_purpose_code
boolean		lb_firstport_load=false
datetime		ldt_voyagestart, ldt_firstloadport_arrival
n_port_departure_bunker_value	lnv_departurebunker
n_port_arrival_bunker_value	lnv_arrivalbunker
datawindowchild	ldwc
decimal		ld_hfo_consumption, ld_do_consumption, ld_go_consumption, ld_speed
decimal{4} ld_lsfo_consumption
 
/* If voyage not finished, actual part is ignored */
if dw_vas_loadload.getItemNumber(1, "finished") <> 1 then return 1 

/* To calculate how much bunker consumption to reduce */
lds_poc = create datastore
lds_poc.dataobject = "d_sq_tb_vas_loadload_actual_poc"
lds_poc.setTransObject(sqlca)
ll_rows = lds_poc.retrieve(ii_vessel_nr, is_voyage_nr)
for ll_row = 1 to ll_rows
	ls_purpose_code = lds_poc.getItemString(ll_row, "purpose_code")
	choose case ls_purpose_code
		case "L", "L/D"
			if ll_row = 1 then lb_firstport_load = true     // equals to nothing to subtract
			ls_firstloadport = lds_poc.getitemstring(ll_row, "port_code")
			ldt_firstloadport_arrival = lds_poc.getItemDatetime(ll_row, "port_arr_dt")
			if not lb_firstport_load then
				ls_workport = lds_poc.getItemString(ll_row, "port_code")
				li_workport_pcn = lds_poc.getItemNumber(ll_row, "pcn")
				lnv_arrivalbunker = create n_port_arrival_bunker_value 
				for ll_fuel_index = 1 to 4
					lnv_arrivalbunker.of_calculate( ls_bunkertype[ll_fuel_index] , ii_vessel_nr , is_voyage_nr , ls_workport, li_workport_pcn , ld_firstloadamount[ll_fuel_index] )
					ld_firstloadqty[ll_fuel_index] = lds_poc.getItemNumber(ll_row, "arr_"+ls_bunkertype[ll_fuel_index])
				next
			end if
			exit
		case else
			if ll_row = 1 then  //first row start position of voyage
				ls_startvoyage = lds_poc.getItemString(ll_row, "voyage_nr")
				ls_startport = lds_poc.getItemString(ll_row, "port_code")
				li_startport_pcn = lds_poc.getItemNumber(ll_row, "pcn")
				if is_voyage_nr <> ls_startvoyage then
					ldt_voyagestart = lds_poc.getItemDatetime(ll_row, "port_dept_dt")
					lnv_departurebunker = create n_port_departure_bunker_value 
					for ll_fuel_index = 1 to 4
						lnv_departurebunker.of_calculate( ls_bunkertype[ll_fuel_index] , ii_vessel_nr , ls_startvoyage , ls_startport, li_startport_pcn , ld_startamount[ll_fuel_index] )
						ld_startqty[ll_fuel_index] = lds_poc.getItemNumber(ll_row, "dept_"+ls_bunkertype[ll_fuel_index])
					next
					destroy lnv_departurebunker
				else
					ls_workport = lds_poc.getItemString(ll_row, "port_code")
					li_workport_pcn = lds_poc.getItemNumber(ll_row, "pcn")
					ldt_voyagestart = lds_poc.getItemDatetime(ll_row, "port_arr_dt")
					lnv_arrivalbunker = create n_port_arrival_bunker_value 
					for ll_fuel_index = 1 to 4
						lnv_arrivalbunker.of_calculate( ls_bunkertype[ll_fuel_index] , ii_vessel_nr , is_voyage_nr , ls_workport, li_workport_pcn , ld_startamount[ll_fuel_index] )
						ld_startqty[ll_fuel_index] = lds_poc.getItemNumber(ll_row, "arr_"+ls_bunkertype[ll_fuel_index])
					next
					destroy lnv_arrivalbunker
					SELECT SUM(BP_DETAILS.LIFTED_HFO), SUM(BP_DETAILS.PRICE_HFO * BP_DETAILS.LIFTED_HFO) ,
							   SUM(BP_DETAILS.LIFTED_DO), SUM(BP_DETAILS.PRICE_DO * BP_DETAILS.LIFTED_DO) ,
							   SUM(BP_DETAILS.LIFTED_GO), SUM(BP_DETAILS.PRICE_GO * BP_DETAILS.LIFTED_GO) ,
							   SUM(BP_DETAILS.LIFTED_LSHFO), SUM(BP_DETAILS.PRICE_LSHFO * BP_DETAILS.LIFTED_LSHFO) 
						INTO 	:ld_liftedSQLqty[1], :ld_liftedSQLamount[1],
							 	:ld_liftedSQLqty[2], :ld_liftedSQLamount[2],
							 	:ld_liftedSQLqty[3], :ld_liftedSQLamount[3],
							 	:ld_liftedSQLqty[4], :ld_liftedSQLamount[4] 
						FROM BP_DETAILS  
						WHERE BP_DETAILS.VESSEL_NR =  :ii_vessel_nr AND  
							BP_DETAILS.VOYAGE_NR = :ls_startvoyage AND  
							BP_DETAILS.PORT_CODE =:ls_startport AND  
							BP_DETAILS.PCN =  :li_startport_pcn   ;

					for ll_fuel_index = 1 to 4
						if not isNull(ld_liftedSQLamount[ll_fuel_index]) then 
							ld_liftedqty[ll_fuel_index] += ld_liftedSQLqty[ll_fuel_index]
							ld_liftedamount[ll_fuel_index] += ld_liftedSQLamount[ll_fuel_index]
						end if	
					next
					SELECT sum(DISB_EXPENSES.EXP_AMOUNT_USD)  
						INTO :ld_work_expenses  
						FROM DISB_EXPENSES,   
							VOUCHERS  
						WHERE VOUCHERS.VOUCHER_NR = DISB_EXPENSES.VOUCHER_NR and  
							DISB_EXPENSES.VESSEL_NR = :ii_vessel_nr AND  
							DISB_EXPENSES.VOYAGE_NR = :ls_startvoyage AND  
							DISB_EXPENSES.PORT_CODE = :ls_startport AND  
							DISB_EXPENSES.PCN = :li_startport_pcn AND  
							VOUCHERS.PORT_EXPENSE = 1 AND  
							VOUCHERS.VAS_REPORT = 1 ;

					if not isNull(ld_work_expenses) then ld_subtract_portexpenses += ld_work_expenses
					SELECT sum(DISB_EXPENSES.EXP_AMOUNT_USD)  
						INTO :ld_work_expenses  
						FROM DISB_EXPENSES,   
							VOUCHERS  
						WHERE VOUCHERS.VOUCHER_NR = DISB_EXPENSES.VOUCHER_NR and  
							DISB_EXPENSES.VESSEL_NR = :ii_vessel_nr AND  
							DISB_EXPENSES.VOYAGE_NR = :ls_startvoyage AND  
							DISB_EXPENSES.PORT_CODE = :ls_startport AND  
							DISB_EXPENSES.PCN = :li_startport_pcn AND  
							VOUCHERS.PORT_EXPENSE = 0 AND  
							VOUCHERS.VAS_REPORT = 1 ;

					if not isNull(ld_work_expenses) then ld_subtract_miscexpenses += ld_work_expenses
					if ls_purpose_code = "BUN" then
						ld_bunkering_days = (f_datetime2long(lds_poc.getItemdatetime(ll_row, "port_dept_dt")) - f_datetime2long(lds_poc.getItemdatetime(ll_row, "port_arr_dt")))/86400
						dw_vas_loadload.getchild("dw_bunker_purchase", ldwc)
						ldwc.setTransObject(sqlca)
						ldwc.retrieve(ii_vessel_nr, ls_startvoyage, ls_startport, li_startport_pcn)
					end if
				end if
			else
				/* Implementer at hente lifted for øvrige ports */
				ls_workport = lds_poc.getItemString(ll_row, "port_code")
				li_workport_pcn = lds_poc.getItemNumber(ll_row, "pcn")
				SELECT SUM(BP_DETAILS.LIFTED_HFO), SUM(BP_DETAILS.PRICE_HFO * BP_DETAILS.LIFTED_HFO) ,
							SUM(BP_DETAILS.LIFTED_DO), SUM(BP_DETAILS.PRICE_DO * BP_DETAILS.LIFTED_DO) ,
							SUM(BP_DETAILS.LIFTED_GO), SUM(BP_DETAILS.PRICE_GO * BP_DETAILS.LIFTED_GO) ,
							SUM(BP_DETAILS.LIFTED_LSHFO), SUM(BP_DETAILS.PRICE_LSHFO * BP_DETAILS.LIFTED_LSHFO) 
					INTO 	:ld_liftedSQLqty[1], :ld_liftedSQLamount[1],
							:ld_liftedSQLqty[2], :ld_liftedSQLamount[2],
							:ld_liftedSQLqty[3], :ld_liftedSQLamount[3],
							:ld_liftedSQLqty[4], :ld_liftedSQLamount[4] 
					FROM BP_DETAILS  
					WHERE BP_DETAILS.VESSEL_NR =  :ii_vessel_nr AND  
						BP_DETAILS.VOYAGE_NR = :is_voyage_nr AND  
						BP_DETAILS.PORT_CODE =:ls_workport AND  
						BP_DETAILS.PCN =  :li_workport_pcn   ;

				for ll_fuel_index = 1 to 4
					if not isNull(ld_liftedSQLamount[ll_fuel_index]) then 
						ld_liftedqty[ll_fuel_index] += ld_liftedSQLqty[ll_fuel_index]
						ld_liftedamount[ll_fuel_index] += ld_liftedSQLamount[ll_fuel_index]
					end if	
				next	
				SELECT sum(DISB_EXPENSES.EXP_AMOUNT_USD)  
					INTO :ld_work_expenses  
					FROM DISB_EXPENSES,   
						VOUCHERS  
					WHERE VOUCHERS.VOUCHER_NR = DISB_EXPENSES.VOUCHER_NR and  
						DISB_EXPENSES.VESSEL_NR = :ii_vessel_nr AND  
						DISB_EXPENSES.VOYAGE_NR = :is_voyage_nr AND  
						DISB_EXPENSES.PORT_CODE = :ls_workport AND 
						DISB_EXPENSES.PCN = :li_workport_pcn AND  
						VOUCHERS.PORT_EXPENSE = 1 AND  
						VOUCHERS.VAS_REPORT = 1 ;

				if not isNull(ld_work_expenses) then ld_subtract_portexpenses += ld_work_expenses
				SELECT sum(DISB_EXPENSES.EXP_AMOUNT_USD)  
					INTO :ld_work_expenses  
					FROM DISB_EXPENSES,   
						VOUCHERS  
					WHERE VOUCHERS.VOUCHER_NR = DISB_EXPENSES.VOUCHER_NR and  
						DISB_EXPENSES.VESSEL_NR = :ii_vessel_nr AND  
						DISB_EXPENSES.VOYAGE_NR = :is_voyage_nr AND  
						DISB_EXPENSES.PORT_CODE = :ls_workport AND  
						DISB_EXPENSES.PCN = :li_workport_pcn AND  
						VOUCHERS.PORT_EXPENSE = 0 AND  
						VOUCHERS.VAS_REPORT = 1 ;

				if not isNull(ld_work_expenses) then ld_subtract_miscexpenses += ld_work_expenses
				if ls_purpose_code = "BUN" then
					ld_bunkering_days = (f_datetime2long(lds_poc.getItemdatetime(ll_row, "port_dept_dt")) - f_datetime2long(lds_poc.getItemdatetime(ll_row, "port_arr_dt")))/86400
					dw_vas_loadload.getchild("dw_bunker_purchase", ldwc)
					ldwc.setTransObject(sqlca)
					ldwc.retrieve(ii_vessel_nr, is_voyage_nr, ls_workport , li_workport_pcn)
				end if
			end if
	end choose
next
/* If first port is not loadport, calculate first leg consumption */
for ll_fuel_index = 1 to 4
	ld_firstleg_consumption_usd[ll_fuel_index] = ld_startamount[ll_fuel_index] + ld_liftedamount[ll_fuel_index] - ld_firstloadamount[ll_fuel_index]
	ld_firstleg_consumption_qty[ll_fuel_index] = ld_startqty[ll_fuel_index] + ld_liftedqty[ll_fuel_index] - ld_firstloadqty[ll_fuel_index]
next

/* Set expenses i subreport */
if ldwc.rowcount() > 0 then
	dw_vas_loadload.object.dw_bunker_purchase.Object.t_portexp.Text = string(ld_subtract_portexpenses,"#,##0.00")
	dw_vas_loadload.object.dw_bunker_purchase.Object.t_miscexp.Text = string(ld_subtract_miscexpenses,"#,##0.00")
	dw_vas_loadload.object.dw_bunker_purchase.Object.t_bunkerconsumption_qty.Text = string(ld_firstleg_consumption_qty[1] + ld_firstleg_consumption_qty[2] + ld_firstleg_consumption_qty[3] + ld_firstleg_consumption_qty[4],"#,##0.00")
	dw_vas_loadload.object.dw_bunker_purchase.Object.t_bunkerconsumption_exp.Text = string(ld_firstleg_consumption_usd[1] + ld_firstleg_consumption_usd[2] + ld_firstleg_consumption_usd[3] + ld_firstleg_consumption_usd[4],"#,##0.00")
	dw_vas_loadload.object.dw_bunker_purchase.Object.t_daysinport.Text = string(ld_bunkering_days,"#,##0.00")
end if

/* Reduce port- and misc. expenses in VAS Report */
ld_work_expenses = dw_vas_loadload.getItemNumber(1, "est_act_port_exp")
ld_work_expenses += ld_subtract_portexpenses
dw_vas_loadload.setItem(1, "est_act_port_exp", ld_work_expenses )

ld_work_expenses = dw_vas_loadload.getItemNumber(1, "est_act_misc_exp")
ld_work_expenses += ld_subtract_miscexpenses
dw_vas_loadload.setItem(1, "est_act_misc_exp", ld_work_expenses )

/* Reducer bunkerforbrug i VAS report */
ld_voyage_consumption_usd[1] 	= dw_vas_loadload.getItemNumber(1, "est_act_bunker_fuel_exp")
ld_voyage_consumption_qty[1]	= dw_vas_loadload.getItemNumber(1, "est_act_bunkers_fuel")
ld_voyage_consumption_usd[2] 	= dw_vas_loadload.getItemNumber(1, "est_act_bunker_diesel_exp")
ld_voyage_consumption_qty[2]	= dw_vas_loadload.getItemNumber(1, "est_act_bunkers_diesel")
ld_voyage_consumption_usd[3] 	= dw_vas_loadload.getItemNumber(1, "est_act_bunker_gas_exp")
ld_voyage_consumption_qty[3]	= dw_vas_loadload.getItemNumber(1, "est_act_bunkers_gas")
ld_voyage_consumption_usd[4] 	= dw_vas_loadload.getItemNumber(1, "est_act_bunker_lshfo_exp")
ld_voyage_consumption_qty[4]	= dw_vas_loadload.getItemNumber(1, "est_act_bunkers_lshfo")
ld_work_expenses = dw_vas_loadload.getItemNumber(1, "est_act_bunk_exp")

for ll_fuel_index = 1 to 4
	ld_voyage_consumption_usd[ll_fuel_index] -= ld_firstleg_consumption_usd[ll_fuel_index] 
	ld_voyage_consumption_qty[ll_fuel_index] -= ld_firstleg_consumption_qty[ll_fuel_index] 
	ld_work_expenses += ld_firstleg_consumption_usd[ll_fuel_index]  /* added as expenses in vas are negative */
next

dw_vas_loadload.setItem(1, "est_act_bunker_fuel_exp", ld_voyage_consumption_usd[1])
dw_vas_loadload.setItem(1, "est_act_bunkers_fuel", ld_voyage_consumption_qty[1])
dw_vas_loadload.setItem(1, "est_act_bunker_diesel_exp", ld_voyage_consumption_usd[2])
dw_vas_loadload.setItem(1, "est_act_bunkers_diesel", ld_voyage_consumption_qty[2])
dw_vas_loadload.setItem(1, "est_act_bunker_gas_exp", ld_voyage_consumption_usd[3])
dw_vas_loadload.setItem(1, "est_act_bunkers_gas", ld_voyage_consumption_qty[3])
dw_vas_loadload.setItem(1, "est_act_bunker_lshfo_exp", ld_voyage_consumption_usd[4])
dw_vas_loadload.setItem(1, "est_act_bunkers_lshfo", ld_voyage_consumption_qty[4])
dw_vas_loadload.setItem(1, "est_act_bunk_exp", ld_work_expenses )

ld_work_days = dw_vas_loadload.getItemNumber(1, "est_act_days_bunkering")
ld_work_days -= ld_bunkering_days
dw_vas_loadload.setItem(1, "est_act_days_bunkering", ld_work_days )

if not lb_firstport_load then
	of_reduceactualdayssection_loadload( lds_poc , ldt_voyagestart )
end if

/* Calculate Bunker days and bunker usage to sail back to first loadport */

/* Avg. bunkerprice */
for ll_fuel_index = 1 to 4
	if  ld_voyage_consumption_qty[ll_fuel_index] <> 0 then ld_voyage_avg_bunkerprice[ll_fuel_index] = ld_voyage_consumption_usd[ll_fuel_index] / ld_voyage_consumption_qty[ll_fuel_index]  
next

ls_lastport = lds_poc.getItemString(lds_poc.rowcount(), "port_code")

SELECT ATOBVIAC_PORT.ABC_PORTCODE  
	INTO :ls_firstloadport_abc  
	FROM PORTS,   
		ATOBVIAC_PORT  
	WHERE ATOBVIAC_PORT.ABC_PORTID = PORTS.ABC_PORTID and  
		PORTS.PORT_CODE = :ls_firstloadport    ;

SELECT ATOBVIAC_PORT.ABC_PORTCODE  
	INTO :ls_lastport_abc  
	FROM PORTS,   
		ATOBVIAC_PORT  
	WHERE ATOBVIAC_PORT.ABC_PORTID = PORTS.ABC_PORTID and  
		PORTS.PORT_CODE = :ls_lastport    ;


/* If not already active create instance of AtoBviaC distance engine */
if NOT isValid(gnv_atobviac) then gnv_atobviac = create n_atobviac

/* If not open open tables - can take several seconds */
if NOT gnv_atobviac.of_getTableOpen( ) then
	open(w_startup_screen)
	gnv_AtoBviaC.of_OpenTable()
	gnv_AtoBviaC.of_resetToDefaultState()
	close(w_startup_screen)
end if

if isValid(gnv_AtoBviaC) then
li_distance = gnv_AtoBviaC.of_getporttoportdistance(ls_firstloadport_abc, ls_lastport_abc)
else
	MessageBox("Error", "Global variable gnv_AtoBviaC (distance table) not available")
end if

if uo_global.ib_full_speed then
	SELECT top 1 CAL_CONS.CAL_CONS_FO,   
			CAL_CONS.CAL_CONS_DO,   
			CAL_CONS.CAL_CONS_MGO,  
			CAL_CONS.CAL_CONS_LSFO,
			CAL_CONS.CAL_CONS_SPEED  
		INTO :ld_hfo_consumption,   
			:ld_do_consumption,   
			:ld_go_consumption,  
			:ld_lsfo_consumption, 
			:ld_speed  
		FROM CAL_CONS  
		WHERE CAL_CONS.VESSEL_NR = :ii_vessel_nr AND  
			CAL_CONS.CAL_CONS_TYPE = 1  
		ORDER BY CAL_CONS.CAL_CONS_SPEED DESC;
else
	SELECT top 1 CAL_CONS.CAL_CONS_FO,   
			CAL_CONS.CAL_CONS_DO,   
			CAL_CONS.CAL_CONS_MGO,   
			CAL_CONS.CAL_CONS_LSFO,
			CAL_CONS.CAL_CONS_SPEED  
		INTO :ld_hfo_consumption,   
			:ld_do_consumption,   
			:ld_go_consumption,   
			:ld_lsfo_consumption, 
			:ld_speed  
		FROM CAL_CONS  
		WHERE CAL_CONS.VESSEL_NR = :ii_vessel_nr AND  
			CAL_CONS.CAL_CONS_TYPE = 1  
		ORDER BY CAL_CONS.CAL_CONS_SPEED ASC;
end if		

ld_work_days = (li_distance / ld_speed ) / 24

if ld_hfo_consumption > 0 then
	ld_lastleg_consumption_qty[1] = ld_hfo_consumption * ld_work_days
	ld_lastleg_consumption_usd[1] = ld_lastleg_consumption_qty[1] * ld_voyage_avg_bunkerprice[1]
end if
		
if ld_do_consumption > 0 then
	ld_lastleg_consumption_qty[2] = ld_do_consumption * ld_work_days
	ld_lastleg_consumption_usd[2] = ld_lastleg_consumption_qty[2] * ld_voyage_avg_bunkerprice[2]
end if		
		
if ld_go_consumption > 0 then
	ld_lastleg_consumption_qty[3] = ld_go_consumption * ld_work_days
	ld_lastleg_consumption_usd[3] = ld_lastleg_consumption_qty[3] * ld_voyage_avg_bunkerprice[3]
end if		

if ld_lsfo_consumption > 0 then
	ld_lastleg_consumption_qty[4] = ld_lsfo_consumption * ld_work_days
	ld_lastleg_consumption_usd[4] = ld_lastleg_consumption_qty[4] * ld_voyage_avg_bunkerprice[4]
end if
		
/* Set variables in VAS report */
ld_ballast_days = dw_vas_loadload.getItemNumber(1, "est_act_days_ballast")
ld_ballast_days += ld_work_days
dw_vas_loadload.setItem(1, "est_act_days_ballast", ld_ballast_days )

ld_work_expenses = dw_vas_loadload.getItemNumber(1, "est_act_bunk_exp")
for ll_fuel_index = 1 to 4
	ld_voyage_consumption_qty[ll_fuel_index] += ld_lastleg_consumption_qty[ll_fuel_index]
	ld_voyage_consumption_usd[ll_fuel_index] += ld_lastleg_consumption_usd[ll_fuel_index]
	ld_work_expenses -= ld_lastleg_consumption_usd[ll_fuel_index]
next
	
dw_vas_loadload.setItem(1, "est_act_bunker_fuel_exp", ld_voyage_consumption_usd[1])
dw_vas_loadload.setItem(1, "est_act_bunkers_fuel", ld_voyage_consumption_qty[1])
dw_vas_loadload.setItem(1, "est_act_bunker_diesel_exp", ld_voyage_consumption_usd[2])
dw_vas_loadload.setItem(1, "est_act_bunkers_diesel", ld_voyage_consumption_qty[2])
dw_vas_loadload.setItem(1, "est_act_bunker_gas_exp", ld_voyage_consumption_usd[3])
dw_vas_loadload.setItem(1, "est_act_bunkers_gas", ld_voyage_consumption_qty[3])
dw_vas_loadload.setItem(1, "est_act_bunker_lshfo_exp", ld_voyage_consumption_usd[4])
dw_vas_loadload.setItem(1, "est_act_bunkers_lshfo", ld_voyage_consumption_qty[4])
dw_vas_loadload.setItem(1, "est_act_bunk_exp", ld_work_expenses )


destroy lds_poc
return 1
end function

private function integer of_reduceactualdayssection_loadload (ref datastore ads_poc, datetime adt_voyagestart);long		ll_rows, ll_row
decimal	ld_original_days, ld_work_days
datetime	ldt_startdate, ldt_enddate

ll_rows = ads_poc.rowcount()

for ll_row = 1 to ll_rows
	if (ll_row = 1 and ads_poc.getItemString(ll_row, "voyage_nr") <> is_voyage_nr) then continue    //ignore first row if it belongs to previous voyage

	choose case ads_poc.getItemString(ll_row, "purpose_code")
		case "L", "L/D"
			//exit i første omgang sker der ikke noget
		case "BUN"
			ld_original_days = dw_vas_loadload.getItemNumber(1, "est_act_days_bunkering")
			ldt_startdate = ads_poc.getItemDatetime(ll_row, "port_arr_dt")
			ldt_enddate = ads_poc.getItemDatetime(ll_row, "port_dept_dt")
			ld_work_days = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400
			ld_original_days -= ld_work_days 
			dw_vas_loadload.setItem(1, "est_act_days_bunkering", ld_original_days )
		case "CAN"
			ld_original_days = dw_vas_loadload.getItemNumber(1, "est_act_days_canal")
			ldt_startdate = ads_poc.getItemDatetime(ll_row, "port_arr_dt")
			ldt_enddate = ads_poc.getItemDatetime(ll_row, "port_dept_dt")
			ld_work_days = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400
			ld_original_days -= ld_work_days 
			dw_vas_loadload.setItem(1, "est_act_days_canal", ld_original_days )
		case "DOK"
			ld_original_days = dw_vas_loadload.getItemNumber(1, "est_act_days_dry_dock")
			ldt_startdate = ads_poc.getItemDatetime(ll_row, "port_arr_dt")
			ldt_enddate = ads_poc.getItemDatetime(ll_row, "port_dept_dt")
			ld_work_days = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400
			ld_original_days -= ld_work_days 
			dw_vas_loadload.setItem(1, "est_act_days_dry_dock", ld_original_days )			
		case "WD"
			ld_original_days = dw_vas_loadload.getItemNumber(1, "est_act_days_idle")
			ldt_startdate = ads_poc.getItemDatetime(ll_row, "port_arr_dt")
			ldt_enddate = ads_poc.getItemDatetime(ll_row, "port_dept_dt")
			ld_work_days = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400
			ld_original_days -= ld_work_days 
			dw_vas_loadload.setItem(1, "est_act_days_idle", ld_original_days )			
		case else
			ld_original_days = dw_vas_loadload.getItemNumber(1, "est_act_days_other")
			ldt_startdate = ads_poc.getItemDatetime(ll_row, "port_arr_dt")
			ldt_enddate = ads_poc.getItemDatetime(ll_row, "port_dept_dt")
			ld_work_days = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400
			ld_original_days -= ld_work_days 
			dw_vas_loadload.setItem(1, "est_act_days_other", ld_original_days )			
	end choose
	if (ll_row = 1 and ads_poc.getItemString(ll_row, "voyage_nr") = is_voyage_nr) &
	or (ll_row = 2 and ads_poc.getItemString(1, "voyage_nr") <> is_voyage_nr) then
		ldt_startdate 	= adt_voyagestart
	else
		ldt_startdate = ads_poc.getItemDatetime(ll_row -1, "port_dept_dt")
	end if
	ldt_enddate = ads_poc.getItemDatetime(ll_row, "port_arr_dt")

	ld_original_days = dw_vas_loadload.getItemNumber(1, "est_act_days_ballast")
	ld_work_days = (f_datetime2long(ldt_enddate) - f_datetime2long(ldt_startdate))/86400
	ld_original_days -= ld_work_days 
	dw_vas_loadload.setItem(1, "est_act_days_ballast", ld_original_days )			
	
	// STOP LOOP IF FIRST LOADPORT
	choose case ads_poc.getItemString(ll_row, "purpose_code")
	case "L", "L/D"
		exit 
	end choose

next	

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_super)vas_reports
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   	Ref    Author        Comments
  01/01/96 	      	???     		First Version
  04/04/08  CR1171  JSU042       Changed link by F8 to handle 4 digit vessel numbers
  16/12/10	CR2226  JSU042       Ballst port is the same as first part
  13/01/11	CR2197  JMC112	      Change Profit center list
  17/01/11	CR2183  AGL		      Added to MT framework
  11/07/11	CR2490  RMO		      disbursement button text changed
  16/01/13	CR3094  WWA048       Adding a 'Zoom' in VAS report, so the users can adjust the paper size by themselves
  04/06/13  CR2473  LGX001			Fix bug - Calc memo and extended calc memo not available when pressing <F11> & <F12>
											(can be accessed from the VAS report interface)
  11/07/13	CR2759  WWG004			when there are two port of calls of the same port, the expenses for the two
											port of call are added to the first port of call.				
   29/08/14	CR3781	CCY018		The window title match with the text of a menu item.
   25/03/15	CR3879	CCY018		Fix a bug.
   29/10/15	CR3250	CCY018		Add LSFO fuel in calculation module.
********************************************************************/

end subroutine

event open;call super::open;string ls_parm
ls_parm = message.StringParm

is_link_report = left(ls_parm,3)

// Choose correct paper size
IF uo_global.gs_paper_size = "Letter" THEN
	dw_profit_report.DataObject = "d_vas_report_letter"
ELSE
	dw_profit_report.DataObject = "d_vas_report_a4"
END IF

// To store TC-OUT actual disbursement expenses 
ids_TC_disb_exp = CREATE datastore
ids_TC_disb_exp.DataObject = "d_vas_tc_disb"

// Place window in Correct Position 
move(10,10)

if ls_parm = "Normal" then //opened from menu
	// set year field to current year
	sle_year.text = string(today(),"yyyy")
elseif left(ls_parm,3) = "EXT" THEN
	ii_vessel_nr = integer(mid(ls_parm,4,4))
	is_voyage_nr = mid(ls_parm,8,5)
	TriggerEvent("ue_linked_calc_memo_extended")
elseif left(ls_parm,3) = "CAL" THEN
	ii_vessel_nr = integer(mid(ls_parm,4,4))
	is_voyage_nr = mid(ls_parm,8,5)
	TriggerEvent("ue_linked_calc_memo")
elseif left(ls_parm,3) = "LOD" THEN
	ii_vessel_nr = integer(mid(ls_parm,4,4))
	is_voyage_nr = mid(ls_parm,8,5)
	TriggerEvent("ue_linked_vas_loadload")
else
	ii_vessel_nr = integer(mid(ls_parm,4,4))
	is_voyage_nr = mid(ls_parm,8,5)
	TriggerEvent("ue_linked")
end if

uo_shiptype.x = 1657
uo_vessels.x = 2718
end event

on w_super_vas_reports.create
int iCurrent
call super::create
this.cb_spool=create cb_spool
this.dw_vas_loadload=create dw_vas_loadload
this.cb_disb_exp=create cb_disb_exp
this.rb_pdf=create rb_pdf
this.rb_printer=create rb_printer
this.st_year=create st_year
this.sle_year=create sle_year
this.cb_print=create cb_print
this.cb_cancel=create cb_cancel
this.cb_print_preview=create cb_print_preview
this.cb_generate_reports=create cb_generate_reports
this.cb_close=create cb_close
this.dw_profit_report=create dw_profit_report
this.dw_calc_memo=create dw_calc_memo
this.cb_print_log=create cb_print_log
this.uo_vessels=create uo_vessels
this.uo_profit_centers=create uo_profit_centers
this.uo_shiptype=create uo_shiptype
this.uo_voyages=create uo_voyages
this.uo_reports=create uo_reports
this.cbx_time_monitor=create cbx_time_monitor
this.cbx_progress_bar=create cbx_progress_bar
this.dw_vas_log=create dw_vas_log
this.dw_calc_memo_extended=create dw_calc_memo_extended
this.st_zoom=create st_zoom
this.em_zoom=create em_zoom
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_spool
this.Control[iCurrent+2]=this.dw_vas_loadload
this.Control[iCurrent+3]=this.cb_disb_exp
this.Control[iCurrent+4]=this.rb_pdf
this.Control[iCurrent+5]=this.rb_printer
this.Control[iCurrent+6]=this.st_year
this.Control[iCurrent+7]=this.sle_year
this.Control[iCurrent+8]=this.cb_print
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.cb_print_preview
this.Control[iCurrent+11]=this.cb_generate_reports
this.Control[iCurrent+12]=this.cb_close
this.Control[iCurrent+13]=this.dw_profit_report
this.Control[iCurrent+14]=this.dw_calc_memo
this.Control[iCurrent+15]=this.cb_print_log
this.Control[iCurrent+16]=this.uo_vessels
this.Control[iCurrent+17]=this.uo_profit_centers
this.Control[iCurrent+18]=this.uo_shiptype
this.Control[iCurrent+19]=this.uo_voyages
this.Control[iCurrent+20]=this.uo_reports
this.Control[iCurrent+21]=this.cbx_time_monitor
this.Control[iCurrent+22]=this.cbx_progress_bar
this.Control[iCurrent+23]=this.dw_vas_log
this.Control[iCurrent+24]=this.dw_calc_memo_extended
this.Control[iCurrent+25]=this.st_zoom
this.Control[iCurrent+26]=this.em_zoom
end on

on w_super_vas_reports.destroy
call super::destroy
destroy(this.cb_spool)
destroy(this.dw_vas_loadload)
destroy(this.cb_disb_exp)
destroy(this.rb_pdf)
destroy(this.rb_printer)
destroy(this.st_year)
destroy(this.sle_year)
destroy(this.cb_print)
destroy(this.cb_cancel)
destroy(this.cb_print_preview)
destroy(this.cb_generate_reports)
destroy(this.cb_close)
destroy(this.dw_profit_report)
destroy(this.dw_calc_memo)
destroy(this.cb_print_log)
destroy(this.uo_vessels)
destroy(this.uo_profit_centers)
destroy(this.uo_shiptype)
destroy(this.uo_voyages)
destroy(this.uo_reports)
destroy(this.cbx_time_monitor)
destroy(this.cbx_progress_bar)
destroy(this.dw_vas_log)
destroy(this.dw_calc_memo_extended)
destroy(this.st_zoom)
destroy(this.em_zoom)
end on

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_super_vas_reports
end type

type cb_spool from commandbutton within w_super_vas_reports
integer x = 2633
integer y = 28
integer width = 311
integer height = 76
integer taborder = 190
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Spool Print"
end type

event clicked;time 		lt_start, lt_end
IF cbx_time_monitor.checked = TRUE THEN lt_start = now()
///////////////////////////////////////////////////////////////////
/* Declare local Variables */
string 	ls_m_name, ls_vgrp_desc
long 		ll_counter, ll_report_counter, ll_row, ll_row_count, ll_vessel_grp_id, ll_no_of_reports
Integer 	li_year, li_key[], li_control_return
Boolean 	lb_canceled = FALSE
long		ll_printjob
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

li_year = Integer(mid(sle_year.text,3,2))

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset the VAS log datawindow
dw_vas_log.Reset()

//Return if no voyages selected
if uo_voyages.dw_right.rowcount()< 1 then return

// Disable all buttons while generating
wf_SetButtons(1)
cb_spool.enabled = false

ll_no_of_reports = uo_reports.dw_right.rowcount()
if ll_no_of_reports > 0 then 
	MessageBox("Information", "The spool print function is implemented as a service~n~r" &
									+ "to collect all selected VAS reports in one single print~n~r" & 
									+ "job or PDF file.~n~r~n~r" & 
									+ "In order to get this to work, you have to do following two things:~n~r~n~r" &
									+ "1) Select a printer driver to use.~n~r" &
									+ "2) Press button <Preferences> and select Orientation/Landscape.")
									
	ll_printjob = printOpen("VASReport", true)
	if ll_printjob = -1 then
		wf_SetButtons(5)
		cb_spool.enabled=true
		return
	end if	
end if

//Always open prgress window if more than one voyage selected
if uo_voyages.dw_right.rowcount() > 1 then open(w_vas_progress)
		
for ll_report_counter = 1 to ll_no_of_reports 
	IF IsValid(w_vas_progress) THEN
		w_vas_progress.st_report_type.text = "Generating selected report type " + &
														string(ll_report_counter) + " of " + &
														string(ll_no_of_reports)
	END IF
	CHOOSE CASE uo_reports.dw_right.getitemstring(ll_report_counter,1)
		CASE "Voyage Profit"
			for ll_counter = 1 to uo_voyages.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					//Set progress window on top
					w_vas_progress.setPosition(toTop!)
					w_vas_progress.st_type.text = "Voyage Profit " + string(ll_counter) + &
															" of " + string(uo_voyages.dw_right.rowcount())
				END IF

				lu_vas_control = CREATE u_vas_control
				lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(ll_counter,"vessel_nr")
				lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(ll_counter,"voyage_nr")
				li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_profit_report.print(false)
					PrintDataWindow(ll_printJob, dw_profit_report)
				END IF
				
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
						String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
						String(lstr_vessel_voyage_list[1].voyage_nr))
					End if
				End if
			next
		CASE ELSE
			return
	END CHOOSE
	/* Check if inner loop canceled */
	IF lb_canceled THEN 
		wf_SetButtons(6)
		cb_spool.enabled=true
		printCancel( ll_printjob )
		EXIT
	END IF
next

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

// Make log datawindow visible if there is an entry from execution of VAS
If dw_vas_log.Modifiedcount() > 0 Then
	wf_SetButtons(4)
End if

IF IsValid(w_vas_progress) THEN 
	Close(w_vas_progress)
END IF

/* SetButtons redy for new select */
wf_SetButtons(5)
cb_spool.enabled=true

printClose(ll_printJob)
/////////////////////////////////////////////////////////////
IF cbx_time_monitor.checked = TRUE THEN 
	lt_end = now()
	MessageBox("Information","Report generation = " + string(secondsafter(lt_start, lt_end)) + " sek.")
END IF

parent.post setPosition(toTop!)

end event

type dw_vas_loadload from datawindow within w_super_vas_reports
boolean visible = false
integer x = 2409
integer y = 1272
integer width = 677
integer height = 88
integer taborder = 20
string dataobject = "d_vas_report_loadload"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

type cb_disb_exp from commandbutton within w_super_vas_reports
boolean visible = false
integer x = 3200
integer y = 28
integer width = 329
integer height = 76
integer taborder = 150
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Disb.Inc/Exp."
end type

event clicked;openwithparm(w_show_disb_exp, ids_TC_disb_exp)
end event

type rb_pdf from radiobutton within w_super_vas_reports
integer x = 526
integer y = 60
integer width = 279
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PDF-file"
end type

type rb_printer from radiobutton within w_super_vas_reports
integer x = 526
integer width = 279
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Printer"
boolean checked = true
end type

type st_year from statictext within w_super_vas_reports
integer x = 814
integer y = 32
integer width = 151
integer height = 68
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Year :"
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_super_vas_reports
integer x = 974
integer y = 24
integer width = 201
integer height = 76
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

on modified;
/* if the entered year is incorrect in format, set to current year */
if len(sle_year.text) <> 4 or long(sle_year.text) = 0 then
	sle_year.text = string(today(),"yyyy")
else
	uo_voyages.postevent("ue_retrieve")
end if
end on

type cb_print from commandbutton within w_super_vas_reports
boolean visible = false
integer x = 14
integer y = 20
integer width = 247
integer height = 76
integer taborder = 100
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "P&rint"
end type

event clicked;if len(is_voyage_nr) = 5 then 
//	dw_profit_report.print()
	CHOOSE CASE is_link_report
		CASE "VAS"
			wf_print_report(dw_profit_report)
		CASE "EXT"
			wf_print_report(dw_calc_memo_extended)
		CASE "CAL"
			wf_print_report(dw_calc_memo)
		CASE "LOD"
			wf_print_report(dw_vas_loadload )
	END CHOOSE
	close(parent) 
else
	CHOOSE CASE uo_reports.dw_right.getitemstring(1,1)
		CASE "Shiptype Profit"
			//dw_profit_report.print()
			wf_print_report(dw_profit_report)
			//dw_profit_report.visible = false
		CASE "Voyage Profit","Vessel Profit","Shiptype Profit","Profit Center Profit","Department Profit"
			//dw_profit_report.print()
			wf_print_report(dw_profit_report)
			//dw_profit_report.visible = false
		CASE "Voyage Calculation Memo" 
			//dw_calc_memo.print()
			wf_print_report(dw_calc_memo)
		CASE "Voyage Calculation Memo Extended" 
			//dw_calc_memo.print()
			wf_print_report(dw_calc_memo_extended)
		CASE "Voyage Profit (LoadLoad)" 
			//dw_calc_memo.print()
			wf_print_report(dw_vas_loadload)
	END CHOOSE
	messagebox("Information", "The report has been printed")
	////cb_print.visible = False
	////cb_cancel.visible = False
	//cb_print_preview.enabled = true
	//cb_print_preview.visible = true
	//cb_generate_reports.visible = true
	//cb_close.visible = true
	//
	wf_SetButtons(5)
end if
end event

type cb_cancel from commandbutton within w_super_vas_reports
boolean visible = false
integer x = 270
integer y = 20
integer width = 247
integer height = 76
integer taborder = 110
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "C&ancel"
end type

event clicked;/* Clear print and cancel buttons */
//cb_print.visible = False
//cb_cancel.visible = False
//cb_print_preview.enabled = true
//cb_print_preview.visible = true
//cb_generate_reports.visible = true
//cb_close.visible = true
//
////dw_pc_profit_report_breakdown.visible = False
////dw_vg_profit_report_breakdown.visible = False
////dw_v_profit_report_breakdown.visible = False
//dw_profit_report.visible = False
//dw_calc_memo.visible = False

if len(is_voyage_nr) = 5 then 
	close(parent) 
else
	cb_disb_exp.visible = false
	wf_SetButtons(5)
end if
end event

type cb_print_preview from commandbutton within w_super_vas_reports
event ue_set_state pbm_custom12
integer x = 2121
integer y = 28
integer width = 242
integer height = 76
integer taborder = 120
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Preview"
end type

event ue_set_state;/* Local Variables */
boolean lb_ok_to_preview = FALSE


if uo_reports.dw_right.rowcount() > 0 and uo_reports.dw_right.rowcount() < 2 then
	CHOOSE CASE uo_reports.dw_right.getitemstring(1,1)
	CASE "Department Profit"
		If uo_profit_centers.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Profit Center Profit"
		If uo_profit_centers.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Shiptype Profit"
		If uo_shiptype.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Vessel Profit"
		If uo_vessels.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Voyage Profit"
		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Voyage Calculation Memo"
		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Voyage Calculation Memo Extended"
		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Voyage Profit (LoadLoad)"
		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE else
		lb_ok_to_preview = False
	END CHOOSE
end if

if lb_ok_to_preview then
	this.enabled = True
else
	this.enabled = false
end if
end event

event clicked;time lt_start, lt_end
IF cbx_time_monitor.checked = TRUE THEN lt_start = now()
/////////////////////////////////////////////////////////////
/* Declare local Variables */
String ls_shiptype_name, ls_m_name
Long ll_row_count, ll_row, ll_shiptype_id
Integer li_year, li_key[], li_control_return
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

ids_TC_disb_exp.reset()

li_year = Integer(mid(sle_year.text,3,2))

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset VAS log datawindow
dw_vas_log.Reset()
IF cbx_progress_bar.checked THEN open(w_vas_progress)
IF IsValid(w_vas_progress) THEN
	w_vas_progress.st_report_type.text = "Generating selected report type 1 of 1"
END IF

CHOOSE CASE uo_reports.dw_right.getitemstring(1,1)
	CASE "Department Profit"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Department Profit"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		li_control_return = lu_vas_control.of_master_control( 5, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			wf_SetButtons(2)
		END IF
		ll_row_count = dw_vas_log.RowCount()

		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Department Profit for year "&
				+string(li_year))
			End if
		End if

	CASE "Profit Center Profit"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Profit Center Profit 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		li_key[1] = uo_profit_centers.dw_right.GetItemNumber(1,"pc_nr")
		li_control_return = lu_vas_control.of_master_control( 4, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			wf_SetButtons(2)
		END IF
		ll_row_count = dw_vas_log.RowCount()

		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Profit Center Profit for PC No. "+ &
				String(li_key[1])+" and Year "+ String(li_year))
			End if
		End if

	CASE "Shiptype Profit"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Shiptype Profit 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		li_key[1] = uo_shiptype.dw_right.GetItemNumber(1,"cal_vest_type_id")
		li_control_return = lu_vas_control.of_master_control( 3, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			wf_SetButtons(2)
		END IF
		ll_row_count = dw_vas_log.RowCount()
		
		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				ll_shiptype_id = li_key[1]

				SELECT CAL_VEST_TYPE_ID
				INTO :ls_shiptype_name
				FROM CAL_VEST
				WHERE CAL_VEST_TYPE_ID = :ll_shiptype_id ;
				COMMIT;
				
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Shiptype Profit for Shiptype No. "+ &
				ls_shiptype_name )
			End if
		End if

	CASE "Vessel Profit"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Vessel Profit 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		li_key[1] = uo_vessels.dw_right.GetItemNumber(1,"vessel_nr")
		li_control_return = lu_vas_control.of_master_control( 2, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			wf_SetButtons(2)
		END IF
		ll_row_count = dw_vas_log.RowCount()

		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Vessel Profit for Vessel No. "+ &
				String(li_key[1])+" and the Year "+ string(li_year))
			End if
		End if
		
	CASE "Voyage Profit"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Voyage Profit 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(1,"vessel_nr")
//		IF Len(uo_voyages.dw_right.GetItemString(1,3)) > 0 THEN
//			lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,3),4)	
//		ELSE
//			lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(1,2)
//		END IF
		lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,"voyage_nr"),5)
		li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			wf_SetButtons(2)
		END IF
		ll_row_count = dw_vas_log.RowCount()

		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
				String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
				lstr_vessel_voyage_list[1].voyage_nr)
			End if
		End if

	CASE "Voyage Calculation Memo"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Voyage Calculation Memo 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(1,"vessel_nr")
//		IF Len(uo_voyages.dw_right.GetItemString(1,3)) > 0 THEN
//			lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,3),4)	
//		ELSE
//			lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(1,2)
//		END IF
		lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,"voyage_nr"),5)
		li_control_return = lu_vas_control.of_master_control( 6, li_key[], lstr_vessel_voyage_list[], li_year, dw_calc_memo)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			wf_SetButtons(3)
		END IF
		ll_row_count = dw_vas_log.RowCount()
		
		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
				uo_voyages.dw_right.getitemString(1,"vessel_ref_nr")+" and Voyage No. "+ &
				String(uo_voyages.dw_right.getitemstring(1,"voyage_nr")))
			End if
		End if

	CASE "Voyage Calculation Memo Extended"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Voyage Calculation Memo Extended 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(1,"vessel_nr")
//		IF Len(uo_voyages.dw_right.GetItemString(1,3)) > 0 THEN
//			lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,3),4)	
//		ELSE
//			lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(1,2)
//		END IF
		lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,"voyage_nr"),5)
		li_control_return = lu_vas_control.of_master_control( 6, li_key[], lstr_vessel_voyage_list[], li_year, dw_calc_memo_extended)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			uf_create_extended_calc_memo(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,dw_calc_memo_extended)
			wf_SetButtons(7)
		END IF
		ll_row_count = dw_vas_log.RowCount()
		
		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
				uo_voyages.dw_right.getitemString(1,"vessel_ref_nr")+" and Voyage No. "+ &
				String(uo_voyages.dw_right.getitemstring(1,"voyage_nr")))
			End if
		End if
	CASE "Voyage Profit (LoadLoad)"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Voyage Profit (LoadLoad) 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(1,"vessel_nr")
//		IF Len(uo_voyages.dw_right.GetItemString(1,3)) > 0 THEN
//			lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,3),4)	
//		ELSE
//			lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(1,2)
//		END IF
		lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,"voyage_nr"),5)
		li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_loadload)
		DESTROY lu_vas_control
		IF li_control_return = -2 THEN  /* Generation canceled */
			wf_SetButtons(6)
		ELSE
			uf_loadload_vas( lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,dw_vas_loadload)
			wf_SetButtons(8)
		END IF
		ll_row_count = dw_vas_log.RowCount()

		// Insert a heading in the log if there if any entries in the log datawindow
		If IsValid(w_super_vas_reports) Then
			If dw_vas_log.ModifiedCount() > 0 Then 
				ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
				w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
				uo_voyages.dw_right.getitemString(1,"vessel_ref_nr")+" and Voyage No. "+ &
				String(uo_voyages.dw_right.getitemstring(1,"voyage_nr")))
			End if
		End if

	CASE ELSE
		return
END CHOOSE

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

If dw_vas_log.ModifiedCount() > 0 Then
	wf_SetButtons(4)
End if
IF IsValid(w_vas_progress) THEN
	Close(w_vas_progress)
END IF

if ids_TC_disb_exp.rowCount() > 0 then
	cb_disb_exp.visible = true
else
	cb_disb_exp.visible = false
end if

/////////////////////////////////////////////////////////////
IF cbx_time_monitor.checked = TRUE THEN 
	lt_end = now()
	MessageBox("Information","Report generation = " + string(secondsafter(lt_start, lt_end)) + " sek.")
END IF	
end event

type cb_generate_reports from commandbutton within w_super_vas_reports
integer x = 2377
integer y = 28
integer width = 242
integer height = 76
integer taborder = 130
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate"
end type

event clicked;time lt_start, lt_end
IF cbx_time_monitor.checked = TRUE THEN lt_start = now()
///////////////////////////////////////////////////////////////////
/* Declare local Variables */
string ls_m_name, ls_shiptype_name
long ll_counter, ll_report_counter, ll_row, ll_row_count, ll_shiptype_id, ll_no_of_reports
Integer li_year, li_key[], li_control_return
Boolean lb_canceled = FALSE
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

li_year = Integer(mid(sle_year.text,3,2))

// Disable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,False)

// Reset the VAS log datawindow
dw_vas_log.Reset()
IF cbx_progress_bar.checked THEN open(w_vas_progress)

// Disable all buttons while generating
wf_SetButtons(1)

ll_no_of_reports = uo_reports.dw_right.rowcount()
for ll_report_counter = 1 to ll_no_of_reports 
	IF IsValid(w_vas_progress) THEN
		w_vas_progress.st_report_type.text = "Generating selected report type " + &
														string(ll_report_counter) + " of " + &
														string(ll_no_of_reports)
	END IF
	CHOOSE CASE uo_reports.dw_right.getitemstring(ll_report_counter,1)
		CASE "Department Profit"
			IF IsValid(w_vas_progress) THEN
				w_vas_progress.st_type.text = "Department Profit"
			END IF
			lu_vas_control = CREATE u_vas_control
			li_control_return = lu_vas_control.of_master_control( 5, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
			DESTROY lu_vas_control
			IF li_control_return = -2 THEN /* Generation canceled */
				lb_canceled = TRUE
			ELSE
				//dw_profit_report.print(false)
				wf_print_report(dw_profit_report)
			END IF
				
			ll_row_count = dw_vas_log.RowCount()

			// Insert a heading in the log if there if any entries in the log datawindow
			If IsValid(w_super_vas_reports) Then
				If dw_vas_log.ModifiedCount() > 0 Then 
					ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
					w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
					w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Department Profit")
				End if
			End if
			
	CASE "Profit Center Profit"
			FOR ll_counter = 1 TO uo_profit_centers.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Profit Center Profit " + string(ll_counter) + &
															" of " + string(uo_profit_centers.dw_right.rowcount())
				END IF
				lu_vas_control = CREATE u_vas_control
				li_key[1] = uo_profit_centers.dw_right.GetItemNumber(ll_counter,"pc_nr")
				li_control_return = lu_vas_control.of_master_control( 4, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_profit_report.print(false)
					wf_print_report(dw_profit_report)
				END IF
				
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				IF IsValid(w_super_vas_reports) THEN
					IF dw_vas_log.ModifiedCount() > 0 THEN 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Profit Center Profit for PC No. "+ &
						String(li_key[1])+" and Year " + String(li_year))
					END IF
				END IF
			NEXT

		CASE "Shiptype Profit"
			FOR ll_counter = 1 TO uo_shiptype.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Shiptype Profit " + string(ll_counter) + &
															" of " + string(uo_shiptype.dw_right.rowcount())
				END IF

				lu_vas_control = CREATE u_vas_control
				li_key[1] = uo_shiptype.dw_right.GetItemNumber(ll_counter,"cal_vest_type_id")
				li_control_return = lu_vas_control.of_master_control( 3, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_profit_report.print(false)
					wf_print_report(dw_profit_report)
				END IF
				
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						ll_shiptype_id = li_key[1]
		
						SELECT CAL_VEST_TYPE_ID
						INTO :ls_shiptype_name
						FROM CAL_VEST
						WHERE CAL_VEST_TYPE_ID = :ll_shiptype_id ;
						COMMIT;
						
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Shiptype Profit for Shiptype No. "+ &
						ls_shiptype_name )
					End if
				End if
			NEXT

		CASE "Vessel Profit"
			for ll_counter = 1 to uo_vessels.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Vessel Profit " + string(ll_counter) + &
															" of " + string(uo_vessels.dw_right.rowcount())
				END IF

				lu_vas_control = CREATE u_vas_control
				li_key[1] = uo_vessels.dw_right.GetItemNumber(ll_counter, "vessel_nr")
				li_control_return = lu_vas_control.of_master_control( 2, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_profit_report.print(false)
					wf_print_report(dw_profit_report)
				END IF
				
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Vessel Profit for Vessel No. "+ &
						String(li_key[1])+" and the Year "+ String(li_year))
					End if
				End if
			next

		CASE "Voyage Profit"
			for ll_counter = 1 to uo_voyages.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Voyage Profit " + string(ll_counter) + &
															" of " + string(uo_voyages.dw_right.rowcount())
				END IF

				lu_vas_control = CREATE u_vas_control
				lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(ll_counter,"vessel_nr")
				
//				IF Len(uo_voyages.dw_right.GetItemString(ll_counter,3)) > 0 THEN
//					lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,3),4)	
//				ELSE
//					lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(ll_counter,2)
//				END IF
				lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,"voyage_nr"),5)

				li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_profit_report)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_profit_report.print(false)
					wf_print_report(dw_profit_report)
				END IF
				
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
						String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
						String(lstr_vessel_voyage_list[1].voyage_nr))
					End if
				End if
			next
			
		CASE "Voyage Calculation Memo"
			for ll_counter = 1 to uo_voyages.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Voyage Calculation Memo " + string(ll_counter) + &
															" of " + string(uo_voyages.dw_right.rowcount())
				END IF

				lu_vas_control = CREATE u_vas_control
				lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(ll_counter,"vessel_nr")
//				IF Len(uo_voyages.dw_right.GetItemString(ll_counter,3)) > 0 THEN
//					lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,3),4)	
//				ELSE
//					lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(ll_counter,2)
//				END IF
				lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,"voyage_nr"),5)
				li_control_return = lu_vas_control.of_master_control( 6, li_key[], lstr_vessel_voyage_list[], li_year, dw_calc_memo)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_calc_memo.print(false)
					wf_print_report(dw_calc_memo)
					// Reset fields after print	
					dw_calc_memo.Object.charterers.Text=''
					dw_calc_memo.Object.brokers.Text=''
					dw_calc_memo.Object.est_act_freight.Expression='0'
					dw_calc_memo.Object.act_freight.Expression='0'
					dw_calc_memo.Object.est_act_dem_des.Expression='0'
					dw_calc_memo.Object.act_dem_des.Expression='0'
					dw_calc_memo.Object.est_act_broker_comm.Expression='0'
					dw_calc_memo.Object.act_broker_comm.Expression='0'
					dw_calc_memo.Object.est_act_bunker_exp.Expression='0'
					dw_calc_memo.Object.act_bunker_exp.Expression='0'
					dw_calc_memo.Object.est_act_misc_exp.Expression='0'
					dw_calc_memo.Object.act_misc_exp.Expression='0'
				END IF
			
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
						uo_voyages.dw_right.getitemString(ll_counter,"vessel_ref_nr")+" and Voyage No. "+ &
						String(uo_voyages.dw_right.getitemstring(ll_counter,"voyage_nr")))
					End if
				End if
			next

		CASE "Voyage Calculation Memo Extended"
			for ll_counter = 1 to uo_voyages.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Voyage Calculation Memo " + string(ll_counter) + &
															" of " + string(uo_voyages.dw_right.rowcount())
				END IF

				lu_vas_control = CREATE u_vas_control
				lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(ll_counter,"vessel_nr")
//				IF Len(uo_voyages.dw_right.GetItemString(ll_counter,3)) > 0 THEN
//					lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,3),4)	
//				ELSE
//					lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(ll_counter,2)
//				END IF
				lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(1,"voyage_nr"),5)
				li_control_return = lu_vas_control.of_master_control( 6, li_key[], lstr_vessel_voyage_list[], li_year, dw_calc_memo_extended)

				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					//dw_calc_memo.print(false)
					//Loop for alle havne//
					uf_create_extended_calc_memo(lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,dw_calc_memo_extended)
					dw_calc_memo_extended.GroupCalc()
					//
					wf_print_report(dw_calc_memo_extended)
					// Reset fields after print	
					dw_calc_memo_extended.Object.charterers.Text=''
					dw_calc_memo_extended.Object.brokers.Text=''
					dw_calc_memo_extended.Object.est_act_freight.Expression='0'
					dw_calc_memo_extended.Object.act_freight.Expression='0'
					dw_calc_memo_extended.Object.est_act_dem_des.Expression='0'
					dw_calc_memo_extended.Object.act_dem_des.Expression='0'
					dw_calc_memo_extended.Object.est_act_broker_comm.Expression='0'
					dw_calc_memo_extended.Object.act_broker_comm.Expression='0'
					dw_calc_memo_extended.Object.est_act_bunker_exp.Expression='0'
					dw_calc_memo_extended.Object.act_bunker_exp.Expression='0'
					dw_calc_memo_extended.Object.est_act_misc_exp.Expression='0'
					dw_calc_memo_extended.Object.act_misc_exp.Expression='0'
				END IF
				ll_row_count = dw_vas_log.RowCount()

				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit for Vessel No. "+ &
						uo_voyages.dw_right.getitemString(ll_counter,"vessel_ref_nr")+" and Voyage No. "+ &
						String(uo_voyages.dw_right.getitemstring(ll_counter,"voyage_nr")))
					End if
				End if
			next
		CASE "Voyage Profit (LoadLoad)"
			for ll_counter = 1 to uo_voyages.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
					w_vas_progress.st_type.text = "Voyage Profit (LoadLoad) 1 of 1"
				END IF
				wf_SetButtons(1)
				lu_vas_control = CREATE u_vas_control
				lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(ll_counter,"vessel_nr")
//				IF Len(uo_voyages.dw_right.GetItemString(ll_counter,3)) > 0 THEN
//					lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,3),4)	
//				ELSE
//					lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(ll_counter,2)
//				END IF
				lstr_vessel_voyage_list[1].voyage_nr = Left(uo_voyages.dw_right.GetItemString(ll_counter,"voyage_nr"),5)
				li_control_return = lu_vas_control.of_master_control( 1, li_key[], lstr_vessel_voyage_list[], li_year, dw_vas_loadload)
				DESTROY lu_vas_control
				IF li_control_return = -2 THEN /* Generation canceled */
					lb_canceled = TRUE
					EXIT
				ELSE
					if uf_loadload_vas( lstr_vessel_voyage_list[1].vessel_nr,lstr_vessel_voyage_list[1].voyage_nr,dw_vas_loadload) = -1 then continue
					wf_print_report(dw_vas_loadload)
				END IF
				ll_row_count = dw_vas_log.RowCount()
		
				// Insert a heading in the log if there if any entries in the log datawindow
				If IsValid(w_super_vas_reports) Then
					If dw_vas_log.ModifiedCount() > 0 Then 
						ll_row = w_super_vas_reports.dw_vas_log.InsertRow(ll_row_count + 1)
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"function_name","REPORT TYPE")
						w_super_vas_reports.dw_vas_log.SetItem(ll_row,"message","Voyage Profit LoadLoad for Vessel No. "+ &
						String(lstr_vessel_voyage_list[1].vessel_nr)+" and Voyage No. "+ &
						lstr_vessel_voyage_list[1].voyage_nr)
					End if
				End if
			next
		CASE ELSE
			return
	END CHOOSE
	/* Check if inner loop canceled */
	IF lb_canceled THEN 
		wf_SetButtons(6)
		EXIT
	END IF
next

// Enable the exit button in the menu
ls_m_name = "m_exit"
uo_global.uf_set_menu(ls_m_name,True)

// Make log datawindow visible if there is an entry from execution of VAS

If dw_vas_log.Modifiedcount() > 0 Then
	wf_SetButtons(4)
End if

IF IsValid(w_vas_progress) THEN 
	Close(w_vas_progress)
END IF

/* SetButtons redy for new select */
wf_SetButtons(5)

/////////////////////////////////////////////////////////////
IF cbx_time_monitor.checked = TRUE THEN 
	lt_end = now()
	MessageBox("Information","Report generation = " + string(secondsafter(lt_start, lt_end)) + " sek.")
END IF
end event

type cb_close from commandbutton within w_super_vas_reports
integer x = 2962
integer y = 28
integer width = 242
integer height = 76
integer taborder = 140
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;// Close the window or close the log datawindow

If dw_vas_log.Visible = True Then
	dw_vas_log.Visible = False
	cb_print_log.Visible = False
	dw_vas_log.BringToTop = False
	If dw_profit_report.Visible = True Then
		cb_print.visible = True
		cb_cancel.visible = True
		cb_print_preview.enabled = false
		cb_print_preview.visible = false
		cb_generate_reports.visible = false
		cb_close.visible = false
	End if
Else	
	close(parent)
End if
end event

type dw_profit_report from uo_datawindow within w_super_vas_reports
boolean visible = false
integer x = 2409
integer y = 1380
integer width = 672
integer height = 116
integer taborder = 10
string dataobject = "d_vas_report_a4"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_calc_memo from datawindow within w_super_vas_reports
boolean visible = false
integer x = 2409
integer y = 1032
integer width = 494
integer height = 96
integer taborder = 30
string dataobject = "d_vas_calc_memo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_print_log from commandbutton within w_super_vas_reports
boolean visible = false
integer x = 2121
integer y = 28
integer width = 498
integer height = 76
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print Log"
end type

event clicked;dw_vas_log.Print()
end event

type uo_vessels from u_drag_drop_boxes within w_super_vas_reports
integer x = 2181
integer y = 140
integer taborder = 170
end type

event ue_retrieve;call super::ue_retrieve;/* Declare local variables */
Int ll_select_shiptypes[], ll_select_profitcenters[]
long ll_rows_in_right_dw_of_shiptypes, ll_rows_in_right_dw_of_profitcenters, ll_counter

/* Set redraw for this object off */
uf_redraw_off()

/* If there are no vessel groups chosen, stop processing */
if uo_shiptype.dw_right.rowcount() < 1 then 
	uf_redraw_on()
	return
end if

/* Allocate array memory for better performance */
ll_select_shiptypes[uo_shiptype.dw_right.rowcount()] = 0
ll_select_profitcenters[uo_profit_centers.dw_right.rowcount()] = 0

/* Get amount of profit centers  and vessel groups chosen */
ll_rows_in_right_dw_of_shiptypes = uo_shiptype.dw_right.rowcount()
ll_rows_in_right_dw_of_profitcenters = uo_profit_centers.dw_right.rowcount()

/* Set array to chosen vessel groups */
for ll_counter = 1 to ll_rows_in_right_dw_of_profitcenters
	ll_select_profitcenters[ll_counter] = uo_profit_centers.dw_right.getitemnumber(ll_counter,"pc_nr")
next

/* Set array to chosen vessel groups */
for ll_counter = 1 to ll_rows_in_right_dw_of_shiptypes
	ll_select_shiptypes[ll_counter] = uo_shiptype.dw_right.getitemnumber(ll_counter,"cal_vest_type_id")
next

/* Retrieve left dw in this object */
this.dw_left.retrieve(ll_select_profitcenters, ll_select_shiptypes)

/* sort dw's */
this.uf_sort()

/* Set redraw for this object on */
uf_redraw_on()
end event

on ue_dw_changed;call u_drag_drop_boxes::ue_dw_changed;/* Post voyages object retrieve */
uo_voyages.postevent("ue_retrieve")


end on

event constructor;call super::constructor;this.uf_set_frame_label("Vessels")
this.uf_setleft_datawindow("d_rb_vessel_number")
this.uf_setright_datawindow("d_rb_vessel_number")
this.uf_set_left_dw_width(50)
this.uf_set_right_dw_width(50)
this.uf_set_height(92)
end event

on uo_vessels.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 3","dragenter")
end event

type uo_profit_centers from u_drag_drop_boxes within w_super_vas_reports
integer x = 14
integer y = 140
integer width = 1152
integer height = 740
integer taborder = 40
end type

event ue_dw_changed;call super::ue_dw_changed;/* Post vessels object retrieve */
uo_shiptype.postevent("ue_retrieve")
end event

event ue_retrieve;call super::ue_retrieve;/* set redraw off */
uf_redraw_off()

/* retrieve left dw */
this.dw_left.retrieve( uo_global.is_userid )

/* sort dw's */
this.uf_sort()

/* set redraw on */
uf_redraw_on()


end event

event constructor;call super::constructor;this.uf_set_frame_label("Profit Centers")
this.uf_setleft_datawindow("d_profit_center_name")
this.uf_setright_datawindow("d_profit_center_name")
/* remove the standard header from dwobject */
this.dw_left.modify("DataWindow.Header.height=0")
this.dw_right.modify("DataWindow.Header.height=0")
this.uf_set_left_dw_width(155)
this.uf_set_right_dw_width(155)
this.uf_set_height(92)

end event

on uo_profit_centers.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 1","dragenter")
end event

event dragleave;call super::dragleave;messagebox("nr 1","dragleave")
end event

type uo_shiptype from u_drag_drop_boxes within w_super_vas_reports
integer x = 1120
integer y = 140
integer taborder = 160
end type

event ue_retrieve;call super::ue_retrieve;/* Declare local variables */
Int li_select_array[]
long ll_rows_in_right_dw, ll_counter

/* Set redraw for this object off */
uf_redraw_off()

/* If there are no profit centers chosen, stop processing */
if uo_profit_centers.dw_right.rowcount() < 1 then 
	uf_redraw_on()
	return
end if

/* Allocate array memory for better performance */
li_select_array[uo_profit_centers.dw_right.rowcount()] = 0

/* Get amount of chosen rows */
ll_rows_in_right_dw = uo_profit_centers.dw_right.rowcount()

/* Set array to chosen profit centers */
for ll_counter = 1 to ll_rows_in_right_dw
	li_select_array[ll_counter] = uo_profit_centers.dw_right.getitemnumber(ll_counter,"pc_nr")
next

/* Retrieve left dw in this object */
this.dw_left.retrieve(li_select_array)

/* sort dw's */
this.uf_sort()

/* Set redraw for this object on */
uf_redraw_on()
end event

on ue_dw_changed;call u_drag_drop_boxes::ue_dw_changed;/* Post voyages object retrieve */
uo_vessels.postevent("ue_retrieve")

end on

event constructor;call super::constructor;this.uf_set_frame_label("Shiptype")
this.uf_setleft_datawindow("d_sq_tb_shiptypes_profitcenter")
this.dw_left.Object.DataWindow.Color=string(rgb(255,255,255))
this.uf_setright_datawindow("d_sq_tb_shiptypes_profitcenter")
this.dw_right.Object.DataWindow.Color=string(rgb(255,255,255))
this.uf_set_left_dw_width(90)
this.uf_set_right_dw_width(90)
this.uf_set_height(92)
end event

on uo_shiptype.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 2","dragenter")
end event

event dragleave;call super::dragleave;messagebox("nr 2","dragenter")
end event

type uo_voyages from u_drag_drop_boxes within w_super_vas_reports
integer x = 14
integer y = 852
integer width = 1157
integer taborder = 200
end type

event ue_retrieve;call super::ue_retrieve;/* Declare local variables */
Int li_select_array[], li_vessel, li_found, li_vv_rows
long ll_rows_in_right_dw, ll_counter,  ll_tc_rows, ll_row
String ls_voyage, ls_find, ls_old_voyage_nr
datastore lds_modified_tco

/* Set redraw for this object off */
uf_redraw_off()

/* If there are vessels chosen, stop processing */
if uo_vessels.dw_right.rowcount() < 1 then 
	uf_redraw_on()
	return
end if

/* Allocate array memory for better performance */
li_select_array[uo_vessels.dw_right.rowcount()] = 0

/* Get amount of chosen rows */
ll_rows_in_right_dw = uo_vessels.dw_right.rowcount()

/* Set array to chosen profit centers */
for ll_counter = 1 to ll_rows_in_right_dw
	li_select_array[ll_counter] = uo_vessels.dw_right.getitemnumber(ll_counter,"vessel_nr")
next

/* Retrieve left dw in this object */
li_vv_rows = this.dw_left.retrieve(li_select_array,sle_year.text)

// Check for TC Out voyages that have been modified. 
// If any then insert dat in dw. for selection

lds_modified_tco = CREATE datastore
lds_modified_tco.dataobject = "d_vas_tc_modified_voyages"
lds_modified_tco.SetTransObject(SQLCA)
ll_tc_rows = lds_modified_tco.Retrieve(li_select_array,Integer(Right(sle_year.text,2)) + 1)
FOR ll_counter = 1 TO ll_tc_rows
	li_vessel = lds_modified_tco.GetItemNumber(ll_counter,"voyages_vessel_nr")
	ls_voyage = lds_modified_tco.GetItemString(ll_counter,"voyages_voyage_nr")
	ls_old_voyage_nr = Left(lds_modified_tco.GetItemString(ll_counter,"voyages_old_voyage_nr"),5)
		
	ls_find = "vessel_nr = Integer('" + String(li_vessel) + "') AND voyage_nr = '" + ls_old_voyage_nr + "'"
	li_found = this.dw_left.Find(ls_find,1,li_vv_rows)
	IF NOT(li_found > 0) THEN
		ll_row = this.dw_left.InsertRow(0)
		this.dw_left.SetItem(ll_row,"vessel_nr",li_vessel)
		this.dw_left.SetItem(ll_row,"voyage_nr",ls_old_voyage_nr)
		this.dw_left.SetItem(ll_row,"newtcvoyagenr",ls_voyage)
	END IF
NEXT

Destroy lds_modified_tco;

/* sort dw's */
this.uf_sort()

/* Set redraw for this object on */
uf_redraw_on()


end event

on ue_dw_changed;call u_drag_drop_boxes::ue_dw_changed;/* Post reports object retrieve */
uo_reports.postevent("ue_retrieve")
end on

event constructor;call super::constructor;this.uf_set_frame_label("Voyages")
this.uf_setleft_datawindow("d_rb_voyages")
this.uf_setright_datawindow("d_rb_voyages")
this.uf_set_left_dw_width(90)
this.uf_set_right_dw_width(90)
this.uf_set_sort("A",1,1)
this.uf_set_sort("A",2,2)



end event

on uo_voyages.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 4","dragenter")
end event

type uo_reports from u_drag_drop_boxes within w_super_vas_reports
integer x = 1147
integer y = 852
integer taborder = 60
end type

event ue_retrieve;call super::ue_retrieve;/* Set redraw off */
uf_redraw_off()

/* Set Departmental reports in choice */
if uo_global.ii_access_level > -2 then  //External User can't access department,Profitcenter and vessel group report
	if uo_profit_centers.dw_right.rowcount() > 0 then
		this.dw_left.setitem(this.dw_left.insertrow(0),1,"Department Profit")
	end if

	/* If 1 or more Profit centers are selected give possibilty of choosing relevant reports */
	if uo_profit_centers.dw_right.rowcount() > 0 then
		this.dw_left.setitem(this.dw_left.insertrow(0),1,"Profit Center Profit")
	end if
	
	/* If 1 or more vessel groups selected give possibilty of choosing relevant reports */
	if uo_shiptype.dw_right.rowcount() > 0 then
		this.dw_left.setitem(this.dw_left.insertrow(0),1,"Shiptype Profit")
	end if
end if
/* If 1 or more vessels selected give possibilty of choosing relevant reports */
if uo_vessels.dw_right.rowcount() > 0 then
	this.dw_left.setitem(this.dw_left.insertrow(0),1,"Vessel Profit")
end if

/* If 1 or more voyages selected give possibilty of choosing relevant reports */
if uo_voyages.dw_right.rowcount() > 0 then
	this.dw_left.setitem(this.dw_left.insertrow(0),1,"Voyage Profit")
	this.dw_left.setitem(this.dw_left.insertrow(0),1,"Voyage Calculation Memo")
	this.dw_left.setitem(this.dw_left.insertrow(0),1,"Voyage Calculation Memo Extended")
	this.dw_left.setitem(this.dw_left.insertrow(0),1,"Voyage Profit (LoadLoad)")
end if

/* Post this objects changed event */
this.postevent("eu_changed")

/* sort dws */
this.uf_sort()

/* Set redraw on */
uf_redraw_on()


end event

on ue_dw_changed;call u_drag_drop_boxes::ue_dw_changed;/* post event to set preview button on or off */
cb_print_preview.postevent("ue_set_state")

end on

on constructor;call u_drag_drop_boxes::constructor;this.uf_set_frame_label("Reports")
this.uf_setleft_datawindow("d_rb_reports")
this.uf_setright_datawindow("d_rb_reports")
this.uf_set_left_dw_width(173)
this.uf_set_right_dw_width(173)
end on

on uo_reports.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 5","dragenter")
end event

type cbx_time_monitor from checkbox within w_super_vas_reports
integer x = 1655
integer y = 76
integer width = 443
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Time Monitor"
end type

type cbx_progress_bar from checkbox within w_super_vas_reports
integer x = 1655
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Progress Bar"
end type

type dw_vas_log from datawindow within w_super_vas_reports
boolean visible = false
integer y = 120
integer width = 2885
integer height = 1412
integer taborder = 180
string dataobject = "d_vas_log"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type dw_calc_memo_extended from datawindow within w_super_vas_reports
boolean visible = false
integer x = 2409
integer y = 872
integer width = 494
integer height = 372
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_vas_calc_memo_extended"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type st_zoom from statictext within w_super_vas_reports
integer x = 1193
integer y = 32
integer width = 151
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Zoom:"
boolean focusrectangle = false
end type

type em_zoom from editmask within w_super_vas_reports
event ue_change pbm_enchange
integer x = 1353
integer y = 24
integer width = 270
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
string text = "100"
borderstyle borderstyle = stylelowered!
string mask = "##0%"
boolean spin = true
string minmax = "0~~"
end type

event ue_change;string	ls_syntax

ls_syntax = "datawindow.zoom = '" + left(em_zoom.text, len(em_zoom.text) - len('%')) + "'"

if isvalid(dw_profit_report) then dw_profit_report.modify(ls_syntax)
if isvalid(dw_calc_memo_extended) then dw_calc_memo_extended.modify(ls_syntax)
if isvalid(dw_calc_memo) then dw_calc_memo.modify(ls_syntax)
if isvalid(dw_vas_loadload) then dw_vas_loadload.modify(ls_syntax)

end event

