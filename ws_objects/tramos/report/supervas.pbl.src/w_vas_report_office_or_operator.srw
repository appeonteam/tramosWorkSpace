$PBExportHeader$w_vas_report_office_or_operator.srw
$PBExportComments$Window for all  VAS (Vessel Accounting System ) reports generation for a selected offfice or operator
forward
global type w_vas_report_office_or_operator from mt_w_sheet
end type
type cb_spool from commandbutton within w_vas_report_office_or_operator
end type
type st_6 from statictext within w_vas_report_office_or_operator
end type
type st_5 from statictext within w_vas_report_office_or_operator
end type
type st_4 from statictext within w_vas_report_office_or_operator
end type
type st_3 from statictext within w_vas_report_office_or_operator
end type
type st_2 from statictext within w_vas_report_office_or_operator
end type
type st_1 from statictext within w_vas_report_office_or_operator
end type
type dw_single_voyage_without_freight from datawindow within w_vas_report_office_or_operator
end type
type rb_operator from radiobutton within w_vas_report_office_or_operator
end type
type rb_office from radiobutton within w_vas_report_office_or_operator
end type
type uo_operators from u_drag_drop_boxes_office_operator within w_vas_report_office_or_operator
end type
type uo_offices from u_drag_drop_boxes_office_operator within w_vas_report_office_or_operator
end type
type dw_calc_memo_extended from datawindow within w_vas_report_office_or_operator
end type
type rb_pdf from radiobutton within w_vas_report_office_or_operator
end type
type rb_printer from radiobutton within w_vas_report_office_or_operator
end type
type st_year from statictext within w_vas_report_office_or_operator
end type
type sle_year from singlelineedit within w_vas_report_office_or_operator
end type
type cb_print from commandbutton within w_vas_report_office_or_operator
end type
type cb_cancel from commandbutton within w_vas_report_office_or_operator
end type
type cb_print_preview from commandbutton within w_vas_report_office_or_operator
end type
type cb_close from commandbutton within w_vas_report_office_or_operator
end type
type dw_profit_report from uo_datawindow within w_vas_report_office_or_operator
end type
type dw_calc_memo from datawindow within w_vas_report_office_or_operator
end type
type cb_print_log from commandbutton within w_vas_report_office_or_operator
end type
type uo_voyages from u_drag_drop_boxes within w_vas_report_office_or_operator
end type
type uo_reports from u_drag_drop_boxes within w_vas_report_office_or_operator
end type
type cbx_time_monitor from checkbox within w_vas_report_office_or_operator
end type
type cbx_progress_bar from checkbox within w_vas_report_office_or_operator
end type
type dw_vas_log from datawindow within w_vas_report_office_or_operator
end type
type gb_2 from groupbox within w_vas_report_office_or_operator
end type
type gb_3 from groupbox within w_vas_report_office_or_operator
end type
type cb_generate_reports from commandbutton within w_vas_report_office_or_operator
end type
type st_test from structure within w_vas_report_office_or_operator
end type
end forward

type st_test from structure
    string name
    long number
end type

global type w_vas_report_office_or_operator from mt_w_sheet
integer x = 343
integer y = 212
integer width = 3721
integer height = 2508
string title = "VAS Report Office/Operator"
boolean maxbox = false
boolean resizable = false
cb_spool cb_spool
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
dw_single_voyage_without_freight dw_single_voyage_without_freight
rb_operator rb_operator
rb_office rb_office
uo_operators uo_operators
uo_offices uo_offices
dw_calc_memo_extended dw_calc_memo_extended
rb_pdf rb_pdf
rb_printer rb_printer
st_year st_year
sle_year sle_year
cb_print cb_print
cb_cancel cb_cancel
cb_print_preview cb_print_preview
cb_close cb_close
dw_profit_report dw_profit_report
dw_calc_memo dw_calc_memo
cb_print_log cb_print_log
uo_voyages uo_voyages
uo_reports uo_reports
cbx_time_monitor cbx_time_monitor
cbx_progress_bar cbx_progress_bar
dw_vas_log dw_vas_log
gb_2 gb_2
gb_3 gb_3
cb_generate_reports cb_generate_reports
end type
global w_vas_report_office_or_operator w_vas_report_office_or_operator

type variables
str_progress istr_parm

// Variables used when linked to operations
integer 		ii_vessel_nr
string 		is_voyage_nr
datastore 	ids_TC_disb_exp
string		is_link_report


end variables

forward prototypes
public subroutine uf_redraw_on ()
public subroutine uf_redraw_off ()
public function decimal uf_other_frt_adr_com (integer ad_calc_id)
public function decimal uf_frt_adr_com (decimal ad_calc_id)
public function decimal uf_dem_adr_com (decimal ad_total_adr_com, decimal ad_frt_adr_com, decimal ad_calc_id, decimal ad_other_frt_adr_com)
public subroutine wf_print_report (datawindow adw)
public subroutine uf_create_extended_calc_memo (integer ai_vessel_nr, string as_voyage_nr, ref datawindow adw_calc_memo)
public subroutine wf_setbuttons (integer ai_status)
public subroutine documentation ()
end prototypes

public subroutine uf_redraw_on ();

end subroutine

public subroutine uf_redraw_off ();

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
Datastore lds_calc_misc_claim_adr_comm
Decimal ld_misc_adr_commission, ld_dem_adr
Long ll_rows

// Adr. misc claims type misc
lds_calc_misc_claim_adr_comm = CREATE datastore
lds_calc_misc_claim_adr_comm.dataobject = "d_calc_misc_claim_adr_comm"

lds_calc_misc_claim_adr_comm.SetTransObject(SQLCA)
ll_rows = lds_calc_misc_claim_adr_comm.Retrieve(ad_calc_id)

IF ll_rows > 0 THEN
	ld_misc_adr_commission = lds_calc_misc_claim_adr_comm.GetItemDecimal(1,"sum_adr_com")
END IF

ld_dem_adr = ad_total_adr_com - ad_frt_adr_com  - ld_misc_adr_commission - ad_other_frt_adr_com

Destroy lds_calc_misc_claim_adr_comm

Return ld_dem_adr
end function

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
			adw.Print(false)
			RegistrySet(ls_key_def_printer, "Device", ls_DefaultPrinter)
		ELSE
			MessageBox("Error!", "Error setting printer to PDF. ~r~nPlease try again or contact the "+&
							"System Administrator if the problem recurs.", StopSign!)
		END IF
END CHOOSE

end subroutine

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
				ld_adr_comm = uf_dem_adr_com(ld_total_adr_comm,ld_frt_comm,ll_calc_id,ld_other_frt_comm)
				ld_dem = lds_calc_total.GetItemNumber(1,"demurrage")
				ld_freight = lds_calc_total.GetItemNumber(1,"gross_freight") - ld_dem - ld_frt_comm - ld_other_frt_comm
				ld_dem = ld_dem - ld_adr_comm
				ld_bunker = lds_calc_total.GetItemNumber(1,"total_bunker_exp")
				ld_misc = lds_calc_total.GetItemNumber(1,"total_misc")
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

public subroutine wf_setbuttons (integer ai_status);// This function controls the buttons/datawindows state visible/enabled
//
//  Argument Integer ai_status	1 = Generate/print reports
//											2 = Preview VAS
//											3 = Preview Calv Memo
//											4 = Log window
//											5 = Select
//											6 = Canceled
//											7 = Preview Calc Memo Extended
////////////////////////////////////////////////////////////////////////

//Long ll_dw_height = 1395, ll_dw_width = 2868, ll_dw_x = 10, ll_dw_y = 115
Long ll_dw_height = 2800, ll_dw_width = 4628, ll_dw_x = 10, ll_dw_y = 115

dw_profit_report.Object.Datawindow.Print.Preview = 'Yes'
dw_profit_report.Object.Datawindow.Print.Preview.Zoom = '92'
dw_calc_memo.Object.Datawindow.Print.Preview = 'Yes'
dw_calc_memo.Object.Datawindow.Print.Preview.Zoom = '92'
dw_calc_memo_extended.Object.Datawindow.Print.Preview = 'Yes'
dw_calc_memo_extended.Object.Datawindow.Print.Preview.Zoom = '92'

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
	CASE 2
		dw_profit_report.visible = True
		dw_profit_report.move( ll_dw_x, ll_dw_y )
		dw_profit_report.height = ll_dw_height
		dw_profit_report.width = ll_dw_width
		this.height = 3028
		this.width = 4654
		cb_print_preview.visible = False
		cb_generate_reports.visible = False
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
		this.height = 2532
		this.width = 3749
		cb_print_preview.enabled = True
		cb_print_preview.visible = True
		cb_generate_reports.enabled = True
		cb_generate_reports.visible = True
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
		cb_close.Visible = False
		cbx_progress_bar.visible = False
		cbx_time_monitor.visible = False
		cb_print_log.visible = False
		cb_print.visible = True
		cb_cancel.visible = True
END CHOOSE

//w_super_vas_reports.SetRedraw( TRUE )

end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/08/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;// Choose correct paper size
IF uo_global.gs_paper_size = "Letter" THEN
	dw_profit_report.DataObject = "d_vas_report_letter"
ELSE
	dw_profit_report.DataObject = "d_vas_report_a4"
END IF

// Place window in Correct Position 
move(10,10)

sle_year.text = string(today(),"yyyy")

dw_single_voyage_without_freight.setTransObject(SQLCA)
dw_single_voyage_without_freight.POST retrieve(mid(sle_year.text,3,2), uo_global.is_userid )

end event

event activate;call super::activate;w_tramos_main.changemenu(m_tramosmain)
m_tramosmain.mf_setcalclink(dw_single_voyage_without_freight, "vessel_nr", "voyage_nr", True)
end event

on w_vas_report_office_or_operator.create
int iCurrent
call super::create
this.cb_spool=create cb_spool
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_single_voyage_without_freight=create dw_single_voyage_without_freight
this.rb_operator=create rb_operator
this.rb_office=create rb_office
this.uo_operators=create uo_operators
this.uo_offices=create uo_offices
this.dw_calc_memo_extended=create dw_calc_memo_extended
this.rb_pdf=create rb_pdf
this.rb_printer=create rb_printer
this.st_year=create st_year
this.sle_year=create sle_year
this.cb_print=create cb_print
this.cb_cancel=create cb_cancel
this.cb_print_preview=create cb_print_preview
this.cb_close=create cb_close
this.dw_profit_report=create dw_profit_report
this.dw_calc_memo=create dw_calc_memo
this.cb_print_log=create cb_print_log
this.uo_voyages=create uo_voyages
this.uo_reports=create uo_reports
this.cbx_time_monitor=create cbx_time_monitor
this.cbx_progress_bar=create cbx_progress_bar
this.dw_vas_log=create dw_vas_log
this.gb_2=create gb_2
this.gb_3=create gb_3
this.cb_generate_reports=create cb_generate_reports
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_spool
this.Control[iCurrent+2]=this.st_6
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_single_voyage_without_freight
this.Control[iCurrent+9]=this.rb_operator
this.Control[iCurrent+10]=this.rb_office
this.Control[iCurrent+11]=this.uo_operators
this.Control[iCurrent+12]=this.uo_offices
this.Control[iCurrent+13]=this.dw_calc_memo_extended
this.Control[iCurrent+14]=this.rb_pdf
this.Control[iCurrent+15]=this.rb_printer
this.Control[iCurrent+16]=this.st_year
this.Control[iCurrent+17]=this.sle_year
this.Control[iCurrent+18]=this.cb_print
this.Control[iCurrent+19]=this.cb_cancel
this.Control[iCurrent+20]=this.cb_print_preview
this.Control[iCurrent+21]=this.cb_close
this.Control[iCurrent+22]=this.dw_profit_report
this.Control[iCurrent+23]=this.dw_calc_memo
this.Control[iCurrent+24]=this.cb_print_log
this.Control[iCurrent+25]=this.uo_voyages
this.Control[iCurrent+26]=this.uo_reports
this.Control[iCurrent+27]=this.cbx_time_monitor
this.Control[iCurrent+28]=this.cbx_progress_bar
this.Control[iCurrent+29]=this.dw_vas_log
this.Control[iCurrent+30]=this.gb_2
this.Control[iCurrent+31]=this.gb_3
this.Control[iCurrent+32]=this.cb_generate_reports
end on

on w_vas_report_office_or_operator.destroy
call super::destroy
destroy(this.cb_spool)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_single_voyage_without_freight)
destroy(this.rb_operator)
destroy(this.rb_office)
destroy(this.uo_operators)
destroy(this.uo_offices)
destroy(this.dw_calc_memo_extended)
destroy(this.rb_pdf)
destroy(this.rb_printer)
destroy(this.st_year)
destroy(this.sle_year)
destroy(this.cb_print)
destroy(this.cb_cancel)
destroy(this.cb_print_preview)
destroy(this.cb_close)
destroy(this.dw_profit_report)
destroy(this.dw_calc_memo)
destroy(this.cb_print_log)
destroy(this.uo_voyages)
destroy(this.uo_reports)
destroy(this.cbx_time_monitor)
destroy(this.cbx_progress_bar)
destroy(this.dw_vas_log)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.cb_generate_reports)
end on

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_vas_report_office_or_operator
end type

type cb_spool from commandbutton within w_vas_report_office_or_operator
integer x = 3177
integer y = 28
integer width = 311
integer height = 76
integer taborder = 160
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
string	ls_spoolfile
long 		ll_printjob
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

//Set Spool PrintJob name / PDF filename
if rb_office.checked then
	ls_spoolfile = uo_offices.dw_right.getItemString(1, "office_name")
else
	ls_spoolfile = uo_operators.dw_right.getItemString(1, "created_by")
end if	

ll_no_of_reports = uo_reports.dw_right.rowcount()
if ll_no_of_reports > 0 then 
	MessageBox("Information", "The spool print function is implemented as a service~n~r" &
									+ "to collect all selected VAS reports in one single print~n~r" & 
									+ "job or PDF file.~n~r~n~r" & 
									+ "In order to get this to work, you have to do following two things:~n~r~n~r" &
									+ "1) Select a printer driver to use.~n~r" &
									+ "2) Press button <Preferences> and select Orientation/Landscape.")
									
	ll_printjob = printOpen("VASReport "+ls_spoolfile, true)
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

type st_6 from statictext within w_vas_report_office_or_operator
integer x = 2203
integer y = 2108
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<F12> =  Ext. CalcMemo"
boolean focusrectangle = false
end type

type st_5 from statictext within w_vas_report_office_or_operator
integer x = 2203
integer y = 2032
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<F11> =  CalcMemo"
boolean focusrectangle = false
end type

type st_4 from statictext within w_vas_report_office_or_operator
integer x = 2203
integer y = 1956
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<F10> =  Est. Calculation"
boolean focusrectangle = false
end type

type st_3 from statictext within w_vas_report_office_or_operator
integer x = 2203
integer y = 1880
integer width = 576
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<F9>   =  Calc. Calculation"
boolean focusrectangle = false
end type

type st_2 from statictext within w_vas_report_office_or_operator
integer x = 2203
integer y = 1804
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<F8>   =  VAS"
boolean focusrectangle = false
end type

type st_1 from statictext within w_vas_report_office_or_operator
integer x = 2208
integer y = 1664
integer width = 722
integer height = 124
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Use following keys to view VAS or Calculation"
boolean focusrectangle = false
end type

type dw_single_voyage_without_freight from datawindow within w_vas_report_office_or_operator
event ue_filter ( )
integer x = 41
integer y = 1660
integer width = 2135
integer height = 696
integer taborder = 20
string title = "none"
string dataobject = "d_single_voyage_without_freight"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_filter();string 	ls_filter
long 		ll_row, ll_rows

ll_rows = uo_offices.dw_right.rowcount()
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		if len(ls_filter) > 0 then
			ls_filter += " or "
		end if
		ls_filter += "office='"+uo_offices.dw_right.getitemstring( ll_row, "office_name")+"'"
	next
else
	ls_filter = ""
end if

this.setFilter(ls_filter)
this.filter()


end event

event rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

type rb_operator from radiobutton within w_vas_report_office_or_operator
integer x = 3163
integer y = 452
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Operator"
end type

event clicked;uo_operators.enabled = true
uo_offices.enabled = false
uo_voyages.dw_left.reset()
uo_voyages.dw_right.reset()
uo_offices.post event constructor()
end event

type rb_office from radiobutton within w_vas_report_office_or_operator
integer x = 3163
integer y = 368
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Office"
boolean checked = true
end type

event clicked;uo_offices.enabled = true
uo_operators.enabled = false
uo_voyages.dw_left.reset()
uo_voyages.dw_right.reset()
uo_operators.post event constructor() 
end event

type uo_operators from u_drag_drop_boxes_office_operator within w_vas_report_office_or_operator
integer x = 14
integer y = 856
integer taborder = 160
boolean enabled = false
end type

event constructor;call super::constructor;this.uf_set_frame_label("Operators")
this.uf_setleft_datawindow("d_claim_operators")
this.uf_setright_datawindow("d_claim_operators")
this.uf_set_sort("A",1,1)

end event

event ue_retrieve;call super::ue_retrieve;this.dw_left.retrieve(mid(sle_year.text,3,2))
end event

on uo_operators.destroy
call u_drag_drop_boxes_office_operator::destroy
end on

event ue_dw_changed;call super::ue_dw_changed;/* Post voyages object retrieve */
uo_voyages.postevent("ue_retrieve")


end event

type uo_offices from u_drag_drop_boxes_office_operator within w_vas_report_office_or_operator
integer x = 14
integer y = 120
integer width = 1847
integer taborder = 150
end type

event constructor;call super::constructor;this.uf_set_frame_label("Offices")
this.uf_setleft_datawindow("d_claim_offices")
this.uf_setright_datawindow("d_claim_offices")
this.uf_set_sort("A",2,1)
this.uf_set_sort("A",1,2)


end event

event ue_retrieve;call super::ue_retrieve;this.dw_left.retrieve(mid(sle_year.text,3,2))
end event

on uo_offices.destroy
call u_drag_drop_boxes_office_operator::destroy
end on

event ue_dw_changed;call super::ue_dw_changed;/* Post voyages object retrieve */
uo_voyages.postevent("ue_retrieve")
dw_single_voyage_without_freight.postevent("ue_filter")

end event

type dw_calc_memo_extended from datawindow within w_vas_report_office_or_operator
boolean visible = false
integer x = 3173
integer y = 1268
integer width = 494
integer height = 100
integer taborder = 30
string dataobject = "d_vas_calc_memo_extended"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rb_pdf from radiobutton within w_vas_report_office_or_operator
integer x = 777
integer y = 60
integer width = 343
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

type rb_printer from radiobutton within w_vas_report_office_or_operator
integer x = 777
integer width = 343
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

type st_year from statictext within w_vas_report_office_or_operator
integer x = 1234
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

type sle_year from singlelineedit within w_vas_report_office_or_operator
integer x = 1390
integer y = 24
integer width = 201
integer height = 76
integer taborder = 50
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

event modified;
/* if the entered year is incorrect in format, set to current year */
if len(sle_year.text) <> 4 or long(sle_year.text) = 0 then
	sle_year.text = string(today(),"yyyy")
else
	uo_voyages.postevent("ue_retrieve")
	dw_single_voyage_without_freight.POST retrieve(mid(sle_year.text,3,2))
end if
end event

type cb_print from commandbutton within w_vas_report_office_or_operator
boolean visible = false
integer x = 146
integer y = 20
integer width = 247
integer height = 76
integer taborder = 70
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

type cb_cancel from commandbutton within w_vas_report_office_or_operator
boolean visible = false
integer x = 407
integer y = 20
integer width = 247
integer height = 76
integer taborder = 80
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
	wf_SetButtons(5)
end if
end event

type cb_print_preview from commandbutton within w_vas_report_office_or_operator
event ue_set_state pbm_custom12
integer x = 2121
integer y = 28
integer width = 242
integer height = 76
integer taborder = 90
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
//	CASE "Department Profit"
//		If uo_profit_centers.dw_right.rowcount() = 1 then lb_ok_to_preview = True
//	CASE "Profit Center Profit"
//		If uo_profit_centers.dw_right.rowcount() = 1 then lb_ok_to_preview = True
//	CASE "Shiptype Profit"
//		If uo_shiptype.dw_right.rowcount() = 1 then lb_ok_to_preview = True
//	CASE "Vessel Profit"
//		If uo_vessels.dw_right.rowcount() = 1 then lb_ok_to_preview = True
	CASE "Voyage Profit"
		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
//	CASE "Voyage Calculation Memo"
//		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
//	CASE "Voyage Calculation Memo Extended"
//		If uo_voyages.dw_right.rowcount() = 1 then lb_ok_to_preview = True
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
String ls_vgrp_desc, ls_m_name
Long ll_row_count, ll_row, ll_vessel_grp_id
Integer li_year, li_key[], li_control_return
s_vessel_voyage_list lstr_vessel_voyage_list[]
u_vas_control lu_vas_control

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

	CASE "Voyage Profit"
		IF IsValid(w_vas_progress) THEN
			w_vas_progress.st_type.text = "Voyage Profit 1 of 1"
		END IF
		wf_SetButtons(1)
		lu_vas_control = CREATE u_vas_control
		lstr_vessel_voyage_list[1].vessel_nr = uo_voyages.dw_right.GetItemNumber(1,"vessel_nr")
		lstr_vessel_voyage_list[1].voyage_nr = uo_voyages.dw_right.GetItemString(1,"voyage_nr")
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

/////////////////////////////////////////////////////////////
IF cbx_time_monitor.checked = TRUE THEN 
	lt_end = now()
	MessageBox("Information","Report generation = " + string(secondsafter(lt_start, lt_end)) + " sek.")
END IF	
end event

type cb_close from commandbutton within w_vas_report_office_or_operator
integer x = 2633
integer y = 28
integer width = 242
integer height = 76
integer taborder = 110
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

type dw_profit_report from uo_datawindow within w_vas_report_office_or_operator
boolean visible = false
integer x = 3072
integer y = 1368
integer width = 448
integer height = 296
integer taborder = 10
string dataobject = "d_vas_report_a4"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type dw_calc_memo from datawindow within w_vas_report_office_or_operator
boolean visible = false
integer x = 3045
integer y = 1084
integer width = 494
integer height = 160
integer taborder = 20
string dataobject = "d_vas_calc_memo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_print_log from commandbutton within w_vas_report_office_or_operator
boolean visible = false
integer x = 2121
integer y = 28
integer width = 498
integer height = 76
integer taborder = 60
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

type uo_voyages from u_drag_drop_boxes within w_vas_report_office_or_operator
integer x = 1861
integer y = 120
integer width = 1157
integer taborder = 150
end type

event ue_retrieve;call super::ue_retrieve;integer 	li_office_array[]
long 		ll_row, ll_rows
string	ls_operator_array[]

uf_redraw_off()
/* fill array */
if rb_office.checked then
	if this.dw_left.dataobject <> "d_office_voyages" then
		this.uf_setleft_datawindow("d_office_voyages")
		this.uf_setright_datawindow("d_office_voyages")
	end if	
	ll_rows = uo_offices.dw_right.rowcount()
	for ll_row = 1 to ll_rows
		li_office_array[ll_row] = uo_offices.dw_right.getitemnumber( ll_row, "office_nr")
	next
	if ll_rows > 0 then 
		this.dw_left.retrieve(li_office_array, mid(sle_year.text,3,2), uo_global.is_userid )
	else
		this.dw_left.reset()
		this.dw_right.reset()
	end if	
else
	if this.dw_left.dataobject <> "d_operator_voyages" then
		this.uf_setleft_datawindow("d_operator_voyages")
		this.uf_setright_datawindow("d_operator_voyages")
	end if	
	ll_rows = uo_operators.dw_right.rowcount()
	for ll_row = 1 to ll_rows
		ls_operator_array[ll_row] = uo_operators.dw_right.getitemString( ll_row, "created_by")
	next
	if ll_rows > 0 then 
		this.dw_left.retrieve(ls_operator_array, mid(sle_year.text,3,2), uo_global.is_userid)
	else
		this.dw_left.reset()
		this.dw_right.reset()
	end if	
end if
this.uf_sort()
uf_redraw_on()


end event

on ue_dw_changed;call u_drag_drop_boxes::ue_dw_changed;/* Post reports object retrieve */
uo_reports.postevent("ue_retrieve")
end on

event constructor;call super::constructor;this.uf_set_frame_label("Voyages")
this.uf_setleft_datawindow("d_office_voyages")
this.uf_setright_datawindow("d_office_voyages")
this.uf_set_sort("A",1,1)
this.uf_set_sort("A",2,2)




end event

on uo_voyages.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 4","dragenter")
end event

type uo_reports from u_drag_drop_boxes within w_vas_report_office_or_operator
integer x = 1861
integer y = 856
integer taborder = 40
end type

event ue_retrieve;call super::ue_retrieve;/* Set redraw off */
uf_redraw_off()

this.dw_right.setitem(this.dw_right.insertrow(0),1,"Voyage Profit")

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

event constructor;call super::constructor;this.uf_set_frame_label("Reports")
this.uf_setleft_datawindow("d_rb_reports")
this.uf_setright_datawindow("d_rb_reports")
//this.uf_set_left_dw_width(173)
//this.uf_set_right_dw_width(173)
end event

on uo_reports.destroy
call u_drag_drop_boxes::destroy
end on

event dragenter;call super::dragenter;messagebox("nr 5","dragenter")
end event

type cbx_time_monitor from checkbox within w_vas_report_office_or_operator
integer x = 1627
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

type cbx_progress_bar from checkbox within w_vas_report_office_or_operator
integer x = 1627
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

type dw_vas_log from datawindow within w_vas_report_office_or_operator
boolean visible = false
integer y = 120
integer width = 2885
integer height = 1412
integer taborder = 140
string dataobject = "d_vas_log"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
end type

type gb_2 from groupbox within w_vas_report_office_or_operator
integer x = 3104
integer y = 288
integer width = 457
integer height = 284
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selection by..."
end type

type gb_3 from groupbox within w_vas_report_office_or_operator
integer x = 18
integer y = 1596
integer width = 2981
integer height = 784
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Single voyages without freight claim"
end type

type cb_generate_reports from commandbutton within w_vas_report_office_or_operator
integer x = 2377
integer y = 28
integer width = 242
integer height = 76
integer taborder = 100
boolean bringtotop = true
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
string ls_m_name, ls_vgrp_desc
long ll_counter, ll_report_counter, ll_row, ll_row_count, ll_vessel_grp_id, ll_no_of_reports
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
		CASE "Voyage Profit"
			for ll_counter = 1 to uo_voyages.dw_right.rowcount()
				IF IsValid(w_vas_progress) THEN
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

