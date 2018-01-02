$PBExportHeader$u_vas_control.sru
$PBExportComments$This object is managing all main VAS activities: create/destroy/loop/print etc.
forward
global type u_vas_control from u_vas_key_data
end type
end forward

global type u_vas_control from u_vas_key_data
end type
global u_vas_control u_vas_control

type variables

end variables

forward prototypes
public function integer of_master_control (integer ai_result_type, integer ai_key[], s_vessel_voyage_list astr_vessel_voyage_list[], integer ai_year_yy, ref datawindow adw)
public function integer of_vas_file ()
public subroutine documentation ()
end prototypes

public function integer of_master_control (integer ai_result_type, integer ai_key[], s_vessel_voyage_list astr_vessel_voyage_list[], integer ai_year_yy, ref datawindow adw);u_vas_fix_calc_est_data lu_fix_calc_est_data
u_vas_bunker lu_bunker
u_vas_days lu_days
u_vas_claims lu_claims
u_vas_port_misc_exp lu_port_misc_exp
u_vas_idledays lnv_idle
//u_vas_drc lu_drc
u_vas_file lu_vas_file
u_vas_tc_out lu_vas_tc_out
s_vessel_voyage_list lstr_vessel_voyage_list
long ll_voyage_teller, ll_no_of_voyages, ll_current_index = 1
Integer li_uo_success

setPointer(hourglass!)
of_init_vessel_array()
of_fill_vessel_array(ai_result_type,ai_key[],astr_vessel_voyage_list[],ai_year_yy)
of_reset_vas_data ( )
of_reset_accumulated_array ( )
adw.Reset()

of_set_current_index(ll_current_index)
ll_no_of_voyages = of_get_nr_of_voyages()

IF ll_no_of_voyages = 0 THEN 
	IF ai_result_type = 1 THEN
		adw.object.t_5.text= "NO POC (TC)"
	END IF
END IF

FOR ll_voyage_teller = 1 TO ll_no_of_voyages
	setPointer(hourglass!)
	garbageCollect()  /* Cleanup if there are any memory leaks */
	of_Get_Vessel_Array(lstr_vessel_voyage_list) 
	
	
	// Include Voyages with type of 'Idle Days'
	IF lstr_vessel_voyage_list.Voyage_type = ii_IDLEDAYS THEN
		// Create new object for Idle Days. 
		lnv_idle = CREATE u_vas_idledays
		lnv_idle.of_setcommenced_date( )
		lnv_idle.of_setvoyage_enddate()
		lnv_idle.of_start_idledays( )
		lnv_idle.of_accumulate_vas_data()


		if ai_result_type<>6 and ai_result_type<>7 and ai_result_type<>11 then
			lnv_idle.of_SetReport_data ( adw ) 
			lnv_idle.of_setReport_Header_Data ( ai_result_type, adw )
		end if
		DESTROY lnv_idle
		CHOOSE CASE ai_result_type
			CASE 1, 10, 6, 7, 8, 11 // one voyage
				of_reset_vas_data ( )
				of_reset_accumulated_array ( )
			CASE 2,3,4,5 // Accumulate
				of_reset_vas_data ( )
				IF ll_voyage_teller = ll_no_of_voyages THEN
					of_reset_accumulated_array ( )
				END IF
		END CHOOSE
		// We are finished with this voyage. Go to next.
		ll_current_index ++
		of_set_current_index(ll_current_index)
		Continue
	END IF
	
	
	// Exclude TC Out voyages from reports except for voyage profit and Calc. memo 15/05-03m Leith
	IF lstr_vessel_voyage_list.Voyage_type = 2 THEN
		// Create new object for TC Out. Identify relevant contract and get figures....
		lu_vas_tc_out = CREATE u_vas_tc_out
		li_uo_success = lu_vas_tc_out.of_start_tc()
		DESTROY lu_vas_tc_out
		IF li_uo_success = -1 THEN 
			MessageBox("Error","VAS calculation stopped due to fail in u_vas_tc_out OR no POC exists for Voyage")
			Return -1
		ELSEIF li_uo_success = 0 THEN
			MessageBox("Information","The selected TC Out voyage is illegal as the TC Contract is not fixtured.")
			Return -1
		END IF
		of_setvoyage_enddate()
		of_accumulate_vas_data()
		IF ai_result_type = 6 THEN
			of_SetCM_tc_report_data ( adw ) 
			of_SetReport_Header_Data ( ai_result_type, adw )
		ELSEIF ai_result_type = 11 THEN	
			of_setaccruals_tc_reportdata( adw, lstr_vessel_voyage_list )
			of_setreport_header_data ( ai_result_type, adw )
		ELSEIF ai_result_type = 7 THEN
			of_vas_file()
		ELSE
			of_SetReport_data ( adw ) 
			of_SetReport_Header_Data ( ai_result_type, adw )
		END IF
		CHOOSE CASE ai_result_type
			CASE 1, 10, 6, 7, 8, 11 // one voyage
				of_reset_vas_data ( )
				of_reset_accumulated_array ( )
			CASE 2,3,4,5 // Accumulate
				of_reset_vas_data ( )
				IF ll_voyage_teller = ll_no_of_voyages THEN
					of_reset_accumulated_array ( )
				END IF
		END CHOOSE
		// We are finished with this voyage. Go to next.
		ll_current_index ++
		of_set_current_index(ll_current_index)
		Continue
	END IF		
	
	/* Update progress window */
	IF IsValid(w_vas_progress) THEN
		w_vas_progress.st_vessel_voyage.text = "Vessel: " + string(lstr_vessel_voyage_list.vessel_nr) +&
															" - Voyage: " + lstr_vessel_voyage_list.voyage_nr
		Yield()
		IF w_vas_progress.ib_canceled THEN
			w_vas_progress.ib_canceled = FALSE
			of_destroy_vessel_array()
			return -2 /* Loop Canceled */
		END IF
	END IF

	// Set voyage variables used in various uo.
	of_setcommenced_date()
	of_set_tcin_or_apm()
	of_set_port_match()
		
	// Create, start and test return success from uo's, for each voyage
	IF ai_result_type <> 8 THEN
		lu_fix_calc_est_data = CREATE u_vas_fix_calc_est_data	
		li_uo_success = lu_fix_calc_est_data.of_start_calc()
		DESTROY lu_fix_calc_est_data
		IF li_uo_success = -1 AND ai_result_type <> 7 THEN 
			MessageBox(string(lstr_vessel_voyage_list.vessel_nr), lstr_vessel_voyage_list.voyage_nr)
			MessageBox("Error","VAS calculation stopped due to fail in u_fix_calc_est_data")
			Return -1
		END IF
	END IF
	
//	IF ai_result_type = 11 THEN
//		// Supervas is called from menu transfer variations, no bunker is transferred (to coda)
		lu_bunker = CREATE u_vas_bunker	
		li_uo_success = lu_bunker.of_start_bunker()
		DESTROY lu_bunker
		IF li_uo_success = -1 THEN 
			MessageBox("Error","VAS calculation stopped due to fail in u_bunker")
			Return -1
		END IF
//	END IF
	
	IF ai_result_type <> 8 THEN	
		lu_days = CREATE u_vas_days	
		li_uo_success = lu_days.of_start_days()
		DESTROY lu_days
		IF li_uo_success = -1 THEN 
			MessageBox("Error","VAS calculation stopped due to fail in u_days")
			Return -1
		END IF
		of_setvoyage_enddate()
		lu_claims = CREATE u_vas_claims	
			li_uo_success = lu_claims.of_start_claims()	
			/* accruals process - save the total number of unforwarded demurrage claims into structure */
			lstr_vessel_voyage_list.demunforwarded = lu_claims.istr_vv_list.demunforwarded
			DESTROY lu_claims
		IF li_uo_success = -1 THEN 
			MessageBox("Error","VAS calculation stopped due to fail in u_claims")
			Return -1
		END IF
			
		lu_port_misc_exp = CREATE u_vas_port_misc_exp	
		li_uo_success = lu_port_misc_exp.of_start_port_misc_exp()
		DESTROY lu_port_misc_exp
		IF li_uo_success = -1 THEN 
			MessageBox("Error","VAS calculation stopped due to fail in u_port_misc_exp")
			Return -1
		END IF
	END IF		

	// Either accumulate, fill calc. memo or build VAS File
	CHOOSE CASE ai_result_type
		CASE 1 // vessel/voyage print
			of_accumulate_vas_data()
			of_SetReport_data ( adw ) 
			of_SetReport_Header_Data ( ai_result_type, adw )
			of_reset_vas_data ( )
			of_reset_accumulated_array ( )
		CASE 10 // vessel/voyage print
			of_accumulate_vas_data()
			of_SetReport_data ( adw )
			adw.setItem(1, "voyage_startdate", of_getCurrent_startDate())
			adw.setItem(1, "voyage_enddate", of_getCurrent_endDate())
			of_reset_vas_data ( )
			of_reset_accumulated_array ( )
		CASE 2,3,4,5 // Accumulate
			of_accumulate_vas_data()
			of_reset_vas_data ( )
			IF ll_voyage_teller = ll_no_of_voyages THEN
				of_SetReport_data ( adw ) 
				of_SetReport_Header_Data ( ai_result_type, adw )
				of_reset_accumulated_array ( )
				adw.Object.t_no_of_voyages.Text="Voyages included = "+string(ll_no_of_voyages, "#,##0")
			END IF
		CASE 6 // Calculation memo
			of_accumulate_vas_data()
			of_setcm_report_data(adw)
			of_SetReport_Header_Data ( ai_result_type, adw )
			of_reset_accumulated_array ( )
		CASE 7 // VAS File
			of_vas_file()
			of_reset_vas_data ( )
			of_reset_accumulated_array ( )
		CASE 8 // Bunker transaction for CODA
			// If bunker transaction object is valid then set data for object
			adw.InsertRow(0)				 
			adw.SetItem(1,"hfo_amount",of_gethfo_expenses(5,TRUE))	
			adw.SetItem(1,"do_amount",of_getdo_expenses(5,TRUE))
			adw.SetItem(1,"go_amount",of_getgo_expenses(5,TRUE))
			adw.SetItem(1,"lshfo_amount",of_getlshfo_expenses(5,TRUE))
			adw.SetItem(1,"hfo_ton",of_gethfo_ton(5,TRUE))
			adw.SetItem(1,"do_ton",of_getdo_ton(5,TRUE))		
			adw.SetItem(1,"go_ton",of_getgo_ton(5,TRUE))
			adw.SetItem(1,"lshfo_ton",of_getlshfo_ton(5,TRUE))
			of_reset_vas_data ( )
			of_reset_accumulated_array ( )
		CASE 11 // Accruals
			of_accumulate_vas_data()
			of_setaccruals_reportdata(adw,lstr_vessel_voyage_list) 
			of_SetReport_Header_Data ( ai_result_type, adw )
			of_reset_vas_data ( )
			of_reset_accumulated_array ( )

END CHOOSE
	
	/* Update progress window */
	IF IsValid(w_vas_progress) THEN
		w_vas_progress.uo_progress_bar.uf_Set_position(ll_voyage_teller * 100 /ll_no_of_voyages)
		Yield()
		IF w_vas_progress.ib_canceled THEN
			w_vas_progress.ib_canceled = FALSE
			of_destroy_vessel_array()
			setPointer(arrow!)
			return -2 /* Loop Canceled */
		END IF
	END IF
	// Set index to next voyage
	ll_current_index ++
	of_set_current_index(ll_current_index)
NEXT

of_destroy_vessel_array()
setPointer(arrow!)

return 0
end function

public function integer of_vas_file ();Integer li_uo_success
u_vas_file lu_vas_file

// If vas window is valid then get vessel/voyage data for vas file
IF IsValid(w_generate_supervasfile) THEN 
	lu_vas_file = CREATE u_vas_file
	li_uo_success = lu_vas_file.of_start_file(w_generate_supervasfile.istr_vas_file, & 
								w_generate_supervasfile.ii_first_voyage)
	DESTROY lu_vas_file
	IF li_uo_success = -1 THEN 
		MessageBox("Error","VAS calculation stopped due to fail in u_vas_file")
		Return -1
	END IF
ELSE
	//Copy done by FR 130602 
	// If vas window is valid then get vessel/voyage data for vas file
	IF IsValid(w_generate_supervasfile2) THEN 
		lu_vas_file = CREATE u_vas_file
		li_uo_success = lu_vas_file.of_start_file(w_generate_supervasfile2.istr_vas_file, & 
																w_generate_supervasfile2.ii_first_voyage)
		DESTROY lu_vas_file
		IF li_uo_success = -1 THEN 
			MessageBox("Error","VAS calculation stopped due to fail in u_vas_file")
			Return -1
		END IF
	ELSE
		IF IsValid(w_generate_supervasfile3) THEN 
			lu_vas_file = CREATE u_vas_file
			li_uo_success = lu_vas_file.of_start_file_act(w_generate_supervasfile3.istr_vas_file, & 
																w_generate_supervasfile3.ii_first_voyage)
			DESTROY lu_vas_file
			IF li_uo_success = -1 THEN 
				MessageBox("Error","VAS calculation stopped due to fail in u_vas_file")
				Return -1
			END IF
		ELSE
			IF IsValid(w_generate_supervasfile_control) THEN 
				lu_vas_file = CREATE u_vas_file
				li_uo_success = lu_vas_file.of_start_file_control(w_generate_supervasfile_control.istr_vas_file, & 
																	w_generate_supervasfile_control.ii_first_voyage)
				DESTROY lu_vas_file
				IF li_uo_success = -1 THEN 
					MessageBox("Error","VAS calculation stopped due to fail in u_vas_file")
					Return -1
				END IF
			ELSE
				IF IsValid(w_generate_supervasfile_table) THEN 
					lu_vas_file = CREATE u_vas_file
					li_uo_success = lu_vas_file.of_start_file(w_generate_supervasfile_table.istr_vas_file, & 
																		w_generate_supervasfile_table.ii_first_voyage)
					DESTROY lu_vas_file
					IF li_uo_success = -1 THEN 
						MessageBox("Error","VAS calculation stopped due to fail in u_vas_file")
						Return -1
					END IF
				ELSE
					MessageBox("Error","Window for generation of vas file is not present. (object: u_vas_control, function: of_vas_file)")
					Return -1
				END IF
			END IF
		END IF
	END IF
	
end if

Return 1
end function

public subroutine documentation ();
/********************************************************************
   ObjectName: u_vas_control
   <OBJECT> Object inherited from main u_vas_key_data, this object called directly using function
	of_master_control() to generate VAS report</OBJECT>
   <DESC>Business logic in generating multiple formats of VAS</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   many. inc. u_vas_key_data, u_vas_idledays</ALSO>
    Date   Ref    Author        Comments
  02/02/11 ?		AGL		Started documentation header  	
  02/02/11 ?		AGL		Added ACCRUAL functionality  	
  								Amend function of_master_control() to accommodate new VAS result type 11 for Accruals
  19/08/11 2489	AGL	small change to function of_master_control() to maintain demunforwarded value to be used with Accruals								  
  
********************************************************************/

end subroutine

on u_vas_control.create
call super::create
end on

on u_vas_control.destroy
call super::destroy
end on

