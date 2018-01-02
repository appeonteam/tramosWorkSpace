$PBExportHeader$w_atobviac_calc_sensitivity.srw
$PBExportComments$Window for sensitivity
forward
global type w_atobviac_calc_sensitivity from mt_w_popupbox
end type
type dw_opencalcs from mt_u_datawindow within w_atobviac_calc_sensitivity
end type
type st_interval_size from uo_st_base within w_atobviac_calc_sensitivity
end type
type sle_interval_size from uo_sle_base within w_atobviac_calc_sensitivity
end type
type lb_cargos from uo_lb_base within w_atobviac_calc_sensitivity
end type
type st_3 from uo_st_base within w_atobviac_calc_sensitivity
end type
type lb_variables from uo_lb_base within w_atobviac_calc_sensitivity
end type
type cb_print from uo_cb_base within w_atobviac_calc_sensitivity
end type
type cb_calculate from uo_cb_base within w_atobviac_calc_sensitivity
end type
type dw_calc_sensitivity from u_datawindow_sqlca within w_atobviac_calc_sensitivity
end type
type lb_ports from uo_lb_base within w_atobviac_calc_sensitivity
end type
type st_4 from uo_st_base within w_atobviac_calc_sensitivity
end type
type sle_tc_value from uo_sle_base within w_atobviac_calc_sensitivity
end type
type st_tc_value from uo_st_base within w_atobviac_calc_sensitivity
end type
type sle_net_day from uo_sle_base within w_atobviac_calc_sensitivity
end type
type sle_gross_day from uo_sle_base within w_atobviac_calc_sensitivity
end type
type st_gross_day from uo_st_base within w_atobviac_calc_sensitivity
end type
type st_net_day from uo_st_base within w_atobviac_calc_sensitivity
end type
type st_1 from uo_st_base within w_atobviac_calc_sensitivity
end type
type cbx_tc_day from checkbox within w_atobviac_calc_sensitivity
end type
end forward

global type w_atobviac_calc_sensitivity from mt_w_popupbox
integer width = 2414
integer height = 1804
long backcolor = 32304364
string is_title = "Calculation Sensitivity"
dw_opencalcs dw_opencalcs
st_interval_size st_interval_size
sle_interval_size sle_interval_size
lb_cargos lb_cargos
st_3 st_3
lb_variables lb_variables
cb_print cb_print
cb_calculate cb_calculate
dw_calc_sensitivity dw_calc_sensitivity
lb_ports lb_ports
st_4 st_4
sle_tc_value sle_tc_value
st_tc_value st_tc_value
sle_net_day sle_net_day
sle_gross_day sle_gross_day
st_gross_day st_gross_day
st_net_day st_net_day
st_1 st_1
cbx_tc_day cbx_tc_day
end type
global w_atobviac_calc_sensitivity w_atobviac_calc_sensitivity

type variables
Public u_atobviac_calculation iuo_calculation
Public s_calc_sensitivity istr_calc_sensitivity
Public integer ii_no_of_ports
Public integer ii_port_no
Public char ic_load_disch
Public s_port_parm istr_port_parm
Private integer ii_number_of_cargoes
Private integer ii_no_of_loadports
private boolean _ib_modified=true
private long il_handle
private boolean _ib_exists

end variables

forward prototypes
public subroutine wf_reversible_demurrage (s_port_parm astr_port_parm)
public subroutine wf_reversible_freight (s_port_parm astr_port_parm, string as_variable, boolean ab_type_two)
public function boolean wf_sensitivity ()
protected function decimal wf_find_rate (ref s_calculation_parm astr_calc_parm, double ad_tc_eqv, integer ai_cargo_no[], string as_var_type)
public subroutine documentation ()
public function integer wf_setmodified (boolean ab_modified)
public function integer _loadopencalcs ()
private function integer _generate (u_atobviac_calculation auo_calc)
private function integer _resetcalc (string as_message, boolean ab_calculated, boolean ab_modifiedflag, boolean ab_showmessages)
end prototypes

public subroutine wf_reversible_demurrage (s_port_parm astr_port_parm);/****************************************************************************
Author		: TA
Date			: Maj 1997
Description	: If there is reversible demurrage on the cargo of the calculation
				  there is only demurrage amount in the first loadport's demurrage
				  field. This funktion finds the right port number to do the calculation
				  on.
Arguments	: astr_port_parm	:	The data for the port calculation
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-5-97	1.0		TA		Initial version
****************************************************************************/
string ls_port_name, ls_purpose
integer li_found, li_revers, li_rev_dem, li_cnt
long ll_cerp_id, ll_tmp_cp
boolean lb_doit

// Get the selected port number to do sensitivity on
ii_port_no = lb_ports.SelectedIndex()
If IsNull(ii_port_no) Then ii_port_no = 0

// Get the purpose of the port
ls_port_name = lb_ports.SelectedItem()
li_found = Pos(ls_port_name, "  (")
ls_purpose = Trim(Mid(ls_port_name, li_found + 2, 10))

// Find out if there is reversible demurrage on the C/P
ll_cerp_id = iuo_calculation.uf_get_cerp_id(istr_port_parm.i_cargo_no[1])
li_revers = iuo_calculation.uf_get_reversible(istr_port_parm.i_cargo_no[1])

SELECT CAL_CERP.CAL_CERP_REV_DEM
INTO  :li_rev_dem
FROM CAL_CERP
WHERE CAL_CERP.CAL_CERP_ID =:ll_cerp_id;
COMMIT;

lb_doit = true
li_cnt = 1
ic_load_disch = ""
CHOOSE CASE ls_purpose
	CASE "(load)"
		If ii_port_no > -1 Then
			ic_load_disch = "l"
		End If
		
		// There is reversible demurrage on the port
		If li_rev_dem = 1 then 
			DO WHILE lb_doit
				ll_tmp_cp = iuo_calculation.uf_get_cerp_id(li_cnt)
				If ll_tmp_cp = ll_cerp_id Then
					istr_port_parm.i_cargo_no[1] = li_cnt
					lb_doit = false
				End if
				li_cnt ++
			LOOP
		End if
		
		// The cargo is reversible
		If li_revers = 1 Then
			iuo_calculation.uf_select_cargo(istr_port_parm.i_cargo_no[1])
			ii_port_no = iuo_calculation.uf_get_first_loadport()
		End if
	CASE "(disch)"
		If ii_port_no > -1 Then
			ic_load_disch = "d"
			// Finds the number of loadports
			ii_port_no = ii_port_no - ii_no_of_loadports
		End if
		
		// The C/P is reversible
		If li_rev_dem = 1 then 
			DO WHILE lb_doit
				ll_tmp_cp = iuo_calculation.uf_get_cerp_id(li_cnt)
				If ll_tmp_cp = ll_cerp_id Then
					istr_port_parm.i_cargo_no[1] = li_cnt
					lb_doit = false
				End if
				li_cnt ++
			LOOP
		End if
		
		// If the cargo is reversible
		If li_revers = 1 Then
			ii_port_no = 1
		End If
	CASE ELSE
		If ii_port_no > -1 Then
			ic_load_disch = "l"
		End If
END CHOOSE


end subroutine

public subroutine wf_reversible_freight (s_port_parm astr_port_parm, string as_variable, boolean ab_type_two);/****************************************************************************
Author		: TA
Date			: May 1996
Description	: If it is reversible freight cargo the numbers to be used in the 
				  calculation is only available on the first cargo in the calculation. 
				  This funktion finds the right cargo.
Arguments	: astr_port_parm	: Contains all port data.
				  as_variable		: The ratetype on the cargo.
				  ab_type_two		: 
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-5-97	1.0		TA		Initial version
****************************************************************************/
long ll_cerp_id, ll_tmp_cp
integer li_reversible, li_cnt
boolean lb_doit


If ((istr_port_parm.i_no_of_selected <= 1) and ((as_variable = "T/C month") Or (as_variable = "Rate") Or &
					(as_variable = "Lumpsum") Or (as_variable = "Worldscale"))) Or ab_type_two Then

	// Finds the cerpid on the cargo
	ll_cerp_id = iuo_calculation.uf_get_cerp_id(istr_port_parm.i_cargo_no[1])

	// Check to see if it is reversible freight
	SELECT CAL_CERP.CAL_CERP_REV_FREIGHT
	INTO  :li_reversible
	FROM CAL_CERP
	WHERE CAL_CERP.CAL_CERP_ID =:ll_cerp_id;
	COMMIT;
	
	lb_doit = true
	li_cnt = 1
	If li_reversible = 1 Then
		// Find the C/P id and compare it with each cargo cp. The first with the same id
		// will have the numbers to do the calculation on
		DO WHILE lb_doit
			ll_tmp_cp = iuo_calculation.uf_get_cerp_id(li_cnt)
			If ll_tmp_cp = ll_cerp_id Then
				istr_port_parm.i_cargo_no[1] = li_cnt
				lb_doit = false
			End if
			li_cnt ++
		LOOP
	End if
End if


end subroutine

public function boolean wf_sensitivity ();/***********************************************************************
Author    :Teit Aunt 
Date       : 15-8-96
Description : 
Arguments : 
Returns   :   
************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------
11-5-97		4.0			TA		Modification to handle many cargoes
Feb 97		3.0			TA		Modification to handle bunker

Dec 97		2.0			TA		Modification to handle revers calculation
20-8-96		1.1			TA		Put in  function
15-8-96		1.0 			TA		Initial version
***********************************************************************/
// Variables
Double ld_q_1, ld_q_2, ld_q_p_no, ld_step, ld_tc_value, ld_value, ld_gross_day &
			, ld_ar_tmp, ld_tp, ld_tmp4, ld_eqv_rate, ld_net_day, ld_tmp2, ld_tmp3
Integer li_state,li_int, li_no, li_tmp1, li_quant
String ls_cargo_multi_name, ls_var_type, ls_cargo_name, ls_port_name &
			, ls_disch_port_name, ls_variable, ls_original_var, ls_header, ls_purpose
Long ll_rownum
Boolean lb_sens, lb_type_two, lb_small, lb_result, lb_null, lb_quant
boolean lb_modifiedflag, lb_showmessages, lb_calculatedflag
pointer oldpointer

// Arrays and structures
String s_cargo_name[]
Double d_disch_quantity_org[10,7], d_load_quantity_org[10,7], step_array[13,7], ld_varval[7]
Double ld_other_var[7], d_step_val[], d_null_val[], ld_orig_var[7]
s_calculation_parm astr_calc_parm, lstr_parm


lb_sens = True
lb_type_two = False

/* hide modifications to selected calculation window */
oldpointer = SetPointer(HourGlass!)
lb_modifiedflag = iuo_calculation.ib_modified
lb_calculatedflag = iuo_calculation.ib_calculated
lb_showmessages = iuo_calculation.ib_show_messages
iuo_calculation.ib_show_messages = false



// Gets the selected cargo names to do sensitivity on
ls_cargo_name = lb_cargos.SelectedItem()
For li_int = 1 to ii_number_of_cargoes + 1
	li_state = lb_cargos.State(li_int)
	If li_state = 1 Then
		s_cargo_name[li_int] = lb_cargos.Text(li_int)
	End if
Next

// Get port name for header
ls_port_name = lb_ports.SelectedItem()

ld_step = 0
// Get the stepvalue of variable to investigate
ld_step = double(sle_interval_size.Text)

// Get the variable to do sensitivity on
ls_variable = lb_variables.SelectedItem()
istr_calc_sensitivity.s_variable_name = ls_variable

// Call wf_reversible_freight to see if there is reversible freight 
//and set the right cargo and port as the ones beeing investigated
wf_reversible_freight(istr_port_parm,ls_variable,lb_type_two)

// Call wf_reversible_demurrage to see if there is rev. demurrage, 
//and set the right cargo and port as the ones beeing investigated
If Not IsNull(ld_step) And (ld_step > 0) And ((ls_variable = "Loadrate") Or &
					(ls_variable = "Despatch") Or (ls_variable = "Dischrate"))  Then
	wf_reversible_demurrage(istr_port_parm)
End If

// Get value in T/C month
ld_tc_value = double(sle_tc_value.Text)
If Not IsNull(ld_tc_value) And (ld_tc_value > 0) Then
	lb_type_two = True
	ls_var_type = "T/C month"
	// If TC day then multiply with 30.416 to make it tc_month for the calculation
	If cbx_tc_day.Checked = true then
		ld_value = ld_tc_value * c#decimal.AvgMonthDays
	Else
		ld_value = ld_tc_value
	End if
End If

// Get values of Gross day and net day
ld_gross_day = double(sle_gross_day.Text)
If Not IsNull(ld_gross_day) And (ld_gross_day > 0 ) Then
	ld_net_day = ld_gross_day * c#decimal.GrossToNetRate
	lb_type_two = True
	ls_var_type = "Net day"
	ld_value = ld_net_day
End If
ld_net_day = double(sle_net_day.Text)
If Not IsNull(ld_net_day) And (ld_net_day > 0) Then
	lb_type_two = True
	ls_var_type = "Net day"
	ld_value = ld_net_day
End If

// Disable buttons on window
cb_calculate.Enabled = false
cb_print.Enabled = false
//cb_close.Enabled  = false


// Investigate what kind of sensitivity to do
If Not(lb_type_two) Then
	// This is normal sensitivity where one of the factores is varied 20 times to see how it
	// influence the result.
	// Validate that doing sensitivity is okay 
	If (IsNull(ld_step) or (ld_step = 0) Or IsNull(ls_variable) or (ls_variable = "")) Then
		_resetcalc("There has to be a Cargo, a variable and a step value to do a sensitivity analysis!",lb_calculatedflag, lb_modifiedflag,lb_showmessages)				
		lb_sens = False
		Goto Stop
	Else
		// Clean out previouse sensitivity calculation in data window
		dw_calc_sensitivity.Reset()

		// Call the calculation to get the current values in the calculation, and 
		// structure for doing revers calculation
		If Not (iuo_calculation.uf_sensitivity(0,istr_port_parm.i_cargo_no[], &
					istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
			_resetcalc("No calculation data fetched !",lb_calculatedflag, lb_modifiedflag,lb_showmessages)	
		End If
	
		If ls_variable = "T/C month" Then
			iuo_calculation.uf_sensitivity(1,istr_port_parm.i_cargo_no[],istr_calc_sensitivity, &
						ic_load_disch,ii_port_no,astr_calc_parm)
		End If

		// Retrieve the value of the variable(s) that sensitivity is done on
		For li_no = 1 To istr_port_parm.i_no_of_selected
		CHOOSE CASE ls_variable
			CASE "Rate"
				ld_varval[li_no] = istr_calc_sensitivity.d_rate[li_no]
			CASE "Lumpsum"
				ld_varval[li_no] = istr_calc_sensitivity.d_lumpsum[li_no]
			CASE "Worldscale"
				ld_varval[li_no] = istr_calc_sensitivity.d_worldscale[li_no]
			CASE "T/C month"
				ld_varval[li_no] = istr_calc_sensitivity.d_tc
			CASE "Loadrate"
				ld_varval[li_no] = istr_calc_sensitivity.d_loadrate[li_no]
			CASE "Quantity"
				//Get quantity for all the different loadports (could be dischports instead)
				ld_ar_tmp = UpperBound(istr_calc_sensitivity.d_load_quantity[])
				FOR ld_tp = 1 TO ld_ar_tmp
					ld_varval[li_no] += istr_calc_sensitivity.d_load_quantity[ld_tp,li_no]
				NEXT
			CASE "Dischrate"
				ld_varval[li_no] = istr_calc_sensitivity.d_dischrate[li_no]
			CASE "Despatch"
				ld_varval[li_no] = istr_calc_sensitivity.d_despatch[li_no]
			CASE "Bunker"
				ld_varval[li_no] = istr_calc_sensitivity.d_fo_price[li_no]
		END CHOOSE
		Next

		// Save original result for the tc-eqv 
		ls_original_var = ls_variable
		ld_other_var[] = ld_varval[]

		// Insert the step values into array that will be added or subtracted from
		// the variable
		d_step_val[] = d_null_val[]
		For li_no = 1 To istr_port_parm.i_no_of_selected
		ld_tmp2 = ld_varval[li_no]
		FOR li_tmp1 = 5 TO 1  STEP -1
			ld_tmp3 = ld_tmp2 - ld_step
			// T/C month i a result so the equivalent 'rate' has to be calculated
			If ls_variable = "T/C month" Then 
				ls_var_type = ls_variable
				// Finding the equivalent 'rate' value
				step_array[li_tmp1,li_no] = wf_find_rate(astr_calc_parm, &
							ld_tmp3,istr_port_parm.i_cargo_no[],ls_var_type)
			Else
				step_array[li_tmp1,li_no] = ld_tmp3
			End If	
			// Null in the array will cause the datawindow to insert an empty row (gray), 
			// and no calculation will be done
			If step_array[li_tmp1,li_no] < 0 Then
				SetNull(step_array[li_tmp1,li_no])
			End If
			// The quantity may not be negative
			If (step_array[li_tmp1,li_no] = 0) And (ls_variable = "Quantity") Then
				SetNull(step_array[li_tmp1,li_no])
			End If
			// A lumpsum may not be negative
			If (ls_variable = "Lumpsum") And (step_array[li_tmp1,li_no] = 0) Then
				SetNull(step_array[li_tmp1,li_no])
			End if
			ld_tmp2 = ld_tmp3
		NEXT
		Next
		FOR li_tmp1 = 5 TO 1  STEP -1   // Counter used in quantity
			ld_tmp4 -= ld_step
			d_step_val[li_tmp1] = ld_tmp4
		NEXT

		For li_no = 1 To istr_port_parm.i_no_of_selected
		ld_tmp2 = ld_varval[li_no]
		FOR li_tmp1 = 6 TO 10 
			ld_tmp3 = ld_tmp2 + ld_step
			If ls_variable = "T/C month" Then 
				ls_var_type = ls_variable
				step_array[li_tmp1,li_no] = wf_find_rate(astr_calc_parm,ld_tmp3, &
													istr_port_parm.i_cargo_no[],ls_var_type)
			Else
				step_array[li_tmp1,li_no] = ld_tmp3
			End If	
			ld_tmp2 = ld_tmp3
		NEXT
		Next
		ld_tmp4 = 0
		FOR li_tmp1 = 6 TO 10    //Counter used in quantity
			ld_tmp4 += ld_step
			d_step_val[li_tmp1] = ld_tmp4
		NEXT
		
		// Insert text into header on data window
		ll_rownum = dw_calc_sensitivity.InsertRow(0)
		dw_calc_sensitivity.SetItem(ll_rownum,"step",- 3333333)
		If ls_port_name <> "" Then
			ls_header = "Cargo name: " + ls_cargo_name +  "    Port name: " + ls_port_name +  "    Variable: " + ls_variable
		Else
			For li_no = 1 To istr_port_parm.i_no_of_selected
				ls_cargo_multi_name += s_cargo_name[li_no] + ", "
			Next
			ls_header = "Cargo name: " + ls_cargo_multi_name +  "    Variable: " + ls_variable
		End If
		dw_calc_sensitivity.Modify("ftf_header.text = ' "+ls_header+" ' ")
	
		
		// Is calculation possible ? If yes do sensitivity else give error message
		lb_result = True
		lstr_parm.i_function_code = 2
	
		lb_result = iuo_calculation.uf_process(lstr_parm, true)
		If not lb_result then MessageBox("CAL ERROR: ", lstr_parm.result.s_errortext)

		// Change variable if it is T/C month to the relevant rate type 
		If ls_variable = "T/C month" Then
			If astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 1 Or &
					astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 2 Then
				ls_variable = "Rate"
				istr_calc_sensitivity.s_variable_name = ls_variable
			ElseIf astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 3 Then
				ls_variable =  "Lumpsum"
				istr_calc_sensitivity.s_variable_name = ls_variable
			ElseIf astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 4 Then
				ls_variable = "Worldscale"
				istr_calc_sensitivity.s_variable_name = ls_variable
			End If 
		End If

		// Save original values in ports quantity
		d_disch_quantity_org[] = istr_calc_sensitivity.d_disch_quantity[] 
		d_load_quantity_org[] = istr_calc_sensitivity.d_load_quantity[]


		// Do the calculation 
		If lb_result Then
			FOR li_int = 1 TO 5	// Insert values smaller than original value 
				For li_no = 1 To istr_port_parm.i_no_of_selected
					If IsNull(step_array[li_int,li_no]) Then
						lb_null = true
					End if
				Next
				If Not(lb_null) Then
					For li_no = 1 To istr_port_parm.i_no_of_selected
						CHOOSE CASE ls_variable
							CASE "Rate"
								istr_calc_sensitivity.d_rate[li_no] = step_array[li_int,li_no]
							CASE "Lumpsum"
								istr_calc_sensitivity.d_lumpsum[li_no] = step_array[li_int,li_no]
							CASE "Worldscale"
								istr_calc_sensitivity.d_worldscale[li_no] = step_array[li_int,li_no]
							CASE "Quantity"
								lb_small = false
								ld_q_p_no = 1
								ld_q_1 = ld_varval[li_no] - step_array[li_int,li_no] // Find load difference between new and old total quantity
								istr_calc_sensitivity.d_load_quantity[] = d_load_quantity_org[] // Get original values
								DO   //Quantity on loadports
									If istr_calc_sensitivity.d_load_quantity[ld_q_p_no,li_no] > 0 Then
										If ld_q_1 >= istr_calc_sensitivity.d_load_quantity[ld_q_p_no,li_no] Then
											ld_q_2 = ld_q_1 - istr_calc_sensitivity.d_load_quantity[ld_q_p_no,li_no]
											istr_calc_sensitivity.d_load_quantity[ld_q_p_no,li_no] = 1
											ld_q_1 = ld_q_2 + 1
											lb_small = true
											ld_q_p_no += 1
										Else
											istr_calc_sensitivity.d_load_quantity[ld_q_p_no,li_no] -= ld_q_1
											ld_q_1 = 0
										End if
									Else  // Ioad port has an other purpose than loading when quantity = 0 so skip
										ld_q_p_no += 1
									End if	
							LOOP UNTIL (ld_q_1 = 0)
								ld_q_p_no = 1
								lb_small = false
								ld_q_1 = ld_varval[li_no]  - step_array[li_int,li_no]
								istr_calc_sensitivity.d_disch_quantity[]  = d_disch_quantity_org[]  
								DO  //Quantity on dischports
									If ld_q_1 >= Abs(istr_calc_sensitivity.d_disch_quantity[ld_q_p_no,li_no]) Then
										ld_q_2 = ld_q_1 + istr_calc_sensitivity.d_disch_quantity[ld_q_p_no,li_no]
										istr_calc_sensitivity.d_disch_quantity[ld_q_p_no,li_no] = -1
										ld_q_1 = ld_q_2 + 1
										lb_small = true
										ld_q_p_no += 1
									Else
										istr_calc_sensitivity.d_disch_quantity[ld_q_p_no,li_no] += ld_q_1 
										ld_q_1 = 0
									End if
								LOOP UNTIL (ld_q_1 = 0)
							CASE "Loadrate"
								istr_calc_sensitivity.d_loadrate[li_no] = step_array[li_int,li_no]
							CASE "Dischrate"
								istr_calc_sensitivity.d_dischrate[li_no] = step_array[li_int,li_no]
							CASE "Despatch"
								istr_calc_sensitivity.d_despatch[li_no] = step_array[li_int,li_no]
							CASE "Bunker"
								istr_calc_sensitivity.d_fo_price[li_no] = step_array[li_int,li_no]
						END CHOOSE		
						Next
						// Call the calculation with the new values to do calculation on
						If Not (iuo_calculation.uf_sensitivity(1,istr_port_parm.i_cargo_no[], &
							istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
							_resetcalc("No calculation done",lb_calculatedflag, lb_modifiedflag,lb_showmessages)	
						End If
				
						ll_rownum = dw_calc_sensitivity.InsertRow(0)
						dw_calc_sensitivity.ScrollToRow(ll_rownum)
			
						If istr_port_parm.i_no_of_selected >1 Then
							dw_calc_sensitivity.SetItem(ll_rownum,"step",d_step_val[li_int])
						Else
							dw_calc_sensitivity.SetItem(ll_rownum,"step",step_array[li_int,1])
						End if
						// Insert result values from the calculation into the data window
						dw_calc_sensitivity.SetItem(ll_rownum,"gross_day",istr_calc_sensitivity.d_day_gross)
						dw_calc_sensitivity.SetItem(ll_rownum,"net_day",istr_calc_sensitivity.d_day_net)
						dw_calc_sensitivity.SetItem(ll_rownum,"tc_month",istr_calc_sensitivity.d_tc)
					Else
						ll_rownum = dw_calc_sensitivity.InsertRow(0)
						dw_calc_sensitivity.ScrollToRow(ll_rownum)
		
						dw_calc_sensitivity.SetItem(ll_rownum,"step"," * ")
						dw_calc_sensitivity.SetItem(ll_rownum,"gross_day"," * ")
						dw_calc_sensitivity.SetItem(ll_rownum,"net_day"," * ")
						dw_calc_sensitivity.SetItem(ll_rownum,"tc_month"," * ")
					End If
					lb_null = False
				NEXT
	
				// Insert row with step = 0, gives empty row 
				dw_calc_sensitivity.InsertRow(0)

			// Insert original values of calculation
			If ls_original_var = "T/C month" Then
				ls_var_type = ls_original_var
				ld_orig_var[1] = wf_find_rate(astr_calc_parm, ld_other_var[1], &
						istr_port_parm.i_cargo_no[],ls_var_type)
			else
				ld_orig_var[] = ld_other_var[]
			end if

			For li_no = 1 To istr_port_parm.i_no_of_selected
			CHOOSE CASE ls_variable
				CASE "Rate"
					istr_calc_sensitivity.d_rate[li_no] = ld_orig_var[li_no]
				CASE "Lumpsum"
					istr_calc_sensitivity.d_lumpsum[li_no] = ld_orig_var[li_no]
				CASE "Worldscale"
					istr_calc_sensitivity.d_worldscale[li_no] = ld_orig_var[li_no]
				CASE "Quantity"
					istr_calc_sensitivity.d_load_quantity[] = d_load_quantity_org[]
					istr_calc_sensitivity.d_disch_quantity[] = d_disch_quantity_org[]
				CASE "Loadrate"
					istr_calc_sensitivity.d_loadrate[li_no] = ld_orig_var[li_no]
				CASE "Dischrate"
					istr_calc_sensitivity.d_dischrate[li_no] = ld_orig_var[li_no]
				CASE "Despatch"
					istr_calc_sensitivity.d_despatch[li_no] = ld_orig_var[li_no]
				CASE "Bunker"
					istr_calc_sensitivity.d_fo_price[li_no] = ld_orig_var[li_no]
			END CHOOSE	
			Next	

			If Not (iuo_calculation.uf_sensitivity(1,istr_port_parm.i_cargo_no[],istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
				_resetcalc("No calculation done",lb_calculatedflag, lb_modifiedflag,lb_showmessages)	
			End If

			ll_rownum = dw_calc_sensitivity.InsertRow(0)
			dw_calc_sensitivity.ScrollToRow(ll_rownum)
		
			If istr_port_parm.i_no_of_selected > 1 then
				dw_calc_sensitivity.SetItem(ll_rownum,"step", 0)
			Else
				dw_calc_sensitivity.SetItem(ll_rownum,"step",ld_orig_var[1])
			End if
			dw_calc_sensitivity.SetItem(ll_rownum,"gross_day",istr_calc_sensitivity.d_day_gross)
			dw_calc_sensitivity.SetItem(ll_rownum,"net_day",istr_calc_sensitivity.d_day_net)
			dw_calc_sensitivity.SetItem(ll_rownum,"tc_month",istr_calc_sensitivity.d_tc)
		
			// Insert row with step = 0, gives empty row 
			dw_calc_sensitivity.InsertRow(0)
		
			integer li_count = 0
			li_int = 6
			FOR li_count = 9 TO 13  //Calculate the values lager than the original
				For li_no = 1 to istr_port_parm.i_no_of_selected
				CHOOSE CASE ls_variable
					CASE "Rate"
						istr_calc_sensitivity.d_rate[li_no] = step_array[li_int,li_no]
					CASE "Lumpsum"
						istr_calc_sensitivity.d_lumpsum[li_no] = step_array[li_int,li_no]
					CASE "Worldscale"
						istr_calc_sensitivity.d_worldscale[li_no] = step_array[li_int,li_no]
					CASE "Quantity"
						// 1. Find load difference between new and old total quantity
						// 2. Add load difference to quantity in first load port, subtract from first disch port
						ld_q_1 = step_array[li_int,li_no] - ld_varval[li_no]
						istr_calc_sensitivity.d_load_quantity[] = d_load_quantity_org[] // Get original values
						istr_calc_sensitivity.d_disch_quantity[] = d_disch_quantity_org[] // Get original values
						li_quant = 1
						lb_quant = true
						DO UNTIL Not(lb_quant)
							If istr_calc_sensitivity.d_load_quantity[li_quant, li_no] > 0 Then
								istr_calc_sensitivity.d_load_quantity[li_quant, li_no] += ld_q_1
								lb_quant = false
							Else
								li_quant += 1
							End if
						LOOP
						istr_calc_sensitivity.d_disch_quantity[1 ,li_no] -= ld_q_1
					CASE "Loadrate"
						istr_calc_sensitivity.d_loadrate[li_no] = step_array[li_int,li_no]
					CASE "Dischrate"
						istr_calc_sensitivity.d_dischrate[li_no] = step_array[li_int,li_no]
					CASE "Despatch"
						istr_calc_sensitivity.d_despatch[li_no] = step_array[li_int,li_no]
					CASE "Bunker"
						istr_calc_sensitivity.d_fo_price[li_no] = step_array[li_int,li_no]
				END CHOOSE	
				Next		
				// Call calculation with new values
				If Not (iuo_calculation.uf_sensitivity(1,istr_port_parm.i_cargo_no[],istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
					_resetcalc("No calculation done",lb_calculatedflag, lb_modifiedflag,lb_showmessages)	
				End If
			
				ll_rownum = dw_calc_sensitivity.InsertRow(0)
				dw_calc_sensitivity.ScrollToRow(ll_rownum)
				// Inser values into data window
				If istr_port_parm.i_no_of_selected > 1 Then
					dw_calc_sensitivity.SetItem(ll_rownum,"step",d_step_val[li_int])
				Else
					dw_calc_sensitivity.SetItem(ll_rownum,"step",step_array[li_int,1])
				End if
				dw_calc_sensitivity.SetItem(ll_rownum,"gross_day",istr_calc_sensitivity.d_day_gross)
				dw_calc_sensitivity.SetItem(ll_rownum,"net_day",istr_calc_sensitivity.d_day_net)
				dw_calc_sensitivity.SetItem(ll_rownum,"tc_month",istr_calc_sensitivity.d_tc)
				li_int ++
			NEXT
		
			lb_sens = True	
		Else
			MessageBox("Error","Calculation not right. Could not do sensitivity!")
		End If
	End if
Else
	// This is reversible sensitivity e.i. which rate gives the result I want?
	If IsNull(istr_port_parm.i_cargo_number) Or (istr_port_parm.i_cargo_number = 0) Then
		_resetcalc("You have to choose a Cargo to do a Sensitivity Analysis",lb_calculatedflag, lb_modifiedflag,lb_showmessages)
		Goto Stop
	End if

	// If it is a reversible freight the cargo number has to changed to the first 
	// of the reversible freight cargoes because this is the numbers used in the calculation
	wf_reversible_freight(istr_port_parm,ls_variable,lb_type_two)

	// Reset datawindow 
	dw_calc_sensitivity.Reset()

	// Get parameters for calculation 
	If Not (iuo_calculation.uf_sensitivity(0,istr_port_parm.i_cargo_no[],istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
//		iuo_calculation.ib_modified = lb_modifiedflag
//		iuo_calculation.ib_show_messages = lb_showmessages		
//		MessageBox("Error","No calculation data fetched !")
		_resetcalc("No calculation data fetched !",lb_calculatedflag, lb_modifiedflag,lb_showmessages)		
	End If

	If Not (iuo_calculation.uf_sensitivity(1,istr_port_parm.i_cargo_no[],istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
		lb_sens = False
		Goto Stop
	End If

	CHOOSE CASE astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type
		CASE 1,2
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_lumpsum)
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_wsrate)
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_flatrate)
		CASE 3
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_wsrate)
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_flatrate)
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_unitrate)
		CASE 4
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_lumpsum)
			SetNull(astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_unitrate)
	END CHOOSE

	// Calculate the rate that goes with a specific TC eqv. 
	ld_eqv_rate = wf_find_rate(astr_calc_parm, ld_value, istr_port_parm.i_cargo_no[],ls_var_type)

	// Test to see if the total commission is above 99,999 % 
	If (astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_commission_percent + &
		astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].d_adr_commission_percent) > 99.99 Then
		_resetcalc("The total commission on the Cargo has to be below 100 % !!!!",lb_calculatedflag, lb_modifiedflag,lb_showmessages)	
		Goto Stop
	End if

	// Test to see if rate is positive. If not go to stop because calculation can't be done 
	If ld_eqv_rate < 0 Then
		_resetcalc("To get the specified result the rate has to be negative ! ~r~nCalculation can not be done",lb_calculatedflag, lb_modifiedflag,lb_showmessages)									
		Goto Stop
	End if
	// Send the right variable name to the calculation
	If astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 1 Or &
			astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 2 Then
		istr_calc_sensitivity.d_rate[1] = ld_eqv_rate 
		istr_calc_sensitivity.s_variable_name = "Rate"
	ElseIf astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 3 Then
		istr_calc_sensitivity.d_lumpsum[1] = ld_eqv_rate 
		istr_calc_sensitivity.s_variable_name = "Lumpsum"
	ElseIf astr_calc_parm.cargolist[istr_port_parm.i_cargo_number].i_rate_type = 4 Then
		istr_calc_sensitivity.d_worldscale[1]= ld_eqv_rate 
		istr_calc_sensitivity.s_variable_name = "Worldscale"
	End If 

	If Not (iuo_calculation.uf_sensitivity(1,istr_port_parm.i_cargo_no[],istr_calc_sensitivity,ic_load_disch,ii_port_no,astr_calc_parm)) Then
		_resetcalc("No calculation done", lb_calculatedflag, lb_modifiedflag,lb_showmessages)	
		lb_sens = false
		Goto Stop		
	End If
	// Insert the result into the data window
	ll_rownum = dw_calc_sensitivity.InsertRow(0)
	dw_calc_sensitivity.ScrollToRow(ll_rownum)

	dw_calc_sensitivity.SetItem(ll_rownum,"step",ld_eqv_rate)
	dw_calc_sensitivity.SetItem(ll_rownum,"gross_day",istr_calc_sensitivity.d_day_gross)
	dw_calc_sensitivity.SetItem(ll_rownum,"net_day",istr_calc_sensitivity.d_day_net)
	dw_calc_sensitivity.SetItem(ll_rownum,"tc_month",istr_calc_sensitivity.d_tc)
End if

Stop:

istr_port_parm.i_cargo_number = 0
lb_cargos.SetState(0, false)
cb_calculate.Enabled = true
cb_print.Enabled = true

lb_ports.Reset()
lb_variables.Reset()
sle_interval_size.Text = ""
lb_cargos.SetFocus()

/* reset existing calculation settings to normal */
_resetcalc("", lb_calculatedflag,lb_modifiedflag,lb_showmessages)	

SetPointer(oldpointer)

return(lb_sens)
end function

protected function decimal wf_find_rate (ref s_calculation_parm astr_calc_parm, double ad_tc_eqv, integer ai_cargo_no[], string as_var_type);/****************************************************************************
Author		: TA
Date			: October 1996
Description	: Find the rate for a given T/C month or net day and returns the 
				  result in the rate type specified, e.i. rate, worldscale or 
				  lumpsum
Arguments	: astr_calc_parm	: structure s_calculation_parm.
				  ad_tc_eqv			: The result of the calculation, is the starting point
				  						  of the backwards calculation.
				  ai_cargo_no[]	: The number of the cargo in the calculation.
				  as_var_type		: The type of result the calculation shall calculate
				  						  backwards on, e.i. T/C month or net day.
Returns		: Decimal			: ld_rate is the rate for the ratetype specified.
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
****************************************************************************/
double ld_rate, ld_net_day, ld_global_net_result, ld_local_net_result, ld_global_costs, ld_other_local_net_results
double ld_sum_local_net_result
s_calculation_parm lstr_calc_parm

lstr_calc_parm = astr_calc_parm

// Calculate net per day 
If (as_var_type = "T/C month") Then
	If (lstr_calc_parm.d_tc = 0) And (lstr_calc_parm.d_drc > 0) Then
		ld_net_day =  (ad_tc_eqv * (1 - (lstr_calc_parm.d_budget_comm / 100))) / c#decimal.AvgMonthDays - (lstr_calc_parm.d_drc + lstr_calc_parm.d_oa)
	ElseIf (lstr_calc_parm.d_tc > 0) And (lstr_calc_parm.d_drc = 0) then
		ld_net_day =  (ad_tc_eqv * (1 - (lstr_calc_parm.d_budget_comm / 100))) / c#decimal.AvgMonthDays - (lstr_calc_parm.d_tc + lstr_calc_parm.d_oa)
	ElseIf (lstr_calc_parm.d_tc = 0) And (lstr_calc_parm.d_drc = 0) Then
		ld_net_day =  (ad_tc_eqv * (1 - (lstr_calc_parm.d_budget_comm / 100))) / c#decimal.AvgMonthDays -  lstr_calc_parm.d_oa
	End If
Elseif (as_var_type = "Net day") Then
	ld_net_day = ad_tc_eqv
End If

// Calculate Global net result
ld_global_net_result = ld_net_day * (lstr_calc_parm.result.d_minutes_total / 1440)

// Calculate Global costs
ld_global_costs = lstr_calc_parm.result.d_canal_expenses + &
											lstr_calc_parm.result.d_fo_expenses + &
				lstr_calc_parm.result.d_do_expenses + lstr_calc_parm.result.d_mgo_expenses + lstr_calc_parm.result.d_lsfo_expenses + &
					((lstr_calc_parm.d_oa  + lstr_calc_parm.d_drc + lstr_calc_parm.d_tc) * &
					(lstr_calc_parm.result.d_minutes_total / 1440))

// Calculate sum of local net results (global net + global costs - misc income) 
If astr_calc_parm.i_no_cargos > 1 Then
	ld_sum_local_net_result = ld_global_net_result + ld_global_costs - &
													astr_calc_parm.result.d_misc_income
Else
	ld_sum_local_net_result = ld_global_net_result + ld_global_costs - &
			astr_calc_parm.result.d_misc_income - astr_calc_parm.result.d_gross_freight_misc
End if	

// Calculate other local net results. Take net resullt of original calculation and 
//subtract other original local net results 
If astr_calc_parm.i_no_cargos > 1 Then
	ld_other_local_net_results = astr_calc_parm.result.d_net_result - &
		astr_calc_parm.result.d_misc_income - &
		astr_calc_parm.cargolist[ai_cargo_no[1]].d_local_net_result + ld_global_costs 
Else
	ld_other_local_net_results = 0
End If

// Calculate local net result
ld_local_net_result = ld_sum_local_net_result - ld_other_local_net_results

// Determin if there is dead freight, or min, min2, overage1 and overage2 and 
//calculate quantity to fit 
If lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 > &
				lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits then
				
	lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits = &
				lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1

Elseif 	0 < lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1  and  &
		lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1< &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits and &
			 		lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 = 0 Then
		
		lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits = &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 + &
					((lstr_calc_parm.cargolist[ai_cargo_no[1]].i_overage_1 / 100) * &
					(lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits - &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1))

Elseif 	0 < lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1  and  &
		lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 < &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 and &
					0 < lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2  and  &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 < &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits  Then
					
		lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits = &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1 + &
					((lstr_calc_parm.cargolist[ai_cargo_no[1]].i_overage_1 / 100) * &
					(lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2 - &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_1))  +  &
					((lstr_calc_parm.cargolist[ai_cargo_no[1]].i_overage_2 / 100) *  &
					(lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits - &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_min_2))  
End If

// Part results, to make the calculation of the different rates easier
double ld_tmp2, ld_tmp3, ld_tmp4, ld_tmp5
double ld_addrlumpsumamount, ld_broklumpsumamount, ld_lumpsum
double ld_allcomms_pc, ld_brokcomm_pc, ld_addrcomm_pc
integer li_index, li_totallumpsums

ld_brokcomm_pc = lstr_calc_parm.cargolist[ai_cargo_no[1]].d_commission_percent / 100
ld_addrcomm_pc = lstr_calc_parm.cargolist[ai_cargo_no[1]].d_adr_commission_percent / 100
ld_allcomms_pc = ld_brokcomm_pc + ld_addrcomm_pc
li_totallumpsums = upperbound(lstr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum)

for li_index = 1 to li_totallumpsums 
	if astr_calc_parm.cargolist[ai_cargo_no[1]].i_adr_commission_on_lumpsum[li_index] = 1 then
		ld_addrlumpsumamount += lstr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum[li_index] 
	end if
	if astr_calc_parm.cargolist[ai_cargo_no[1]].i_bro_commission_on_lumpsum[li_index] = 1 then
		/* why is d_adr_lumpsum named so?? */
		ld_broklumpsumamount += lstr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum[li_index] 
	end if
	ld_lumpsum += lstr_calc_parm.cargolist[ai_cargo_no[1]].d_add_lumpsum[li_index] 
next

/* save the real lumpsum amounts with % */
If ld_addrlumpsumamount > 0 Then ld_addrlumpsumamount = ld_addrlumpsumamount * ld_addrcomm_pc
If ld_broklumpsumamount > 0 Then ld_broklumpsumamount = ld_broklumpsumamount * ld_brokcomm_pc		


ld_tmp2 = ld_local_net_result - ld_lumpsum + &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_expenses +&
			 		(Abs(lstr_calc_parm.cargolist[ai_cargo_no[1]].d_despatch  ) / 1440 ) + &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_add_expenses 
					
ld_tmp3 = lstr_calc_parm.cargolist[ai_cargo_no[1]].d_totalunits

ld_tmp4 = ( lstr_calc_parm.cargolist[ai_cargo_no[1]].d_demurrage / 1440 ) * ( ld_allcomms_pc - 1)

ld_tmp5 = (lstr_calc_parm.cargolist[ai_cargo_no[1]].d_claims_broker_comm + &
					lstr_calc_parm.cargolist[ai_cargo_no[1]].d_claims_adrs_comm)



CHOOSE CASE astr_calc_parm.cargolist[ai_cargo_no[1]].i_rate_type
	CASE 1,2	
		/* Calculate rate ($ / MT)  */
		ld_rate = (ld_tmp2 + ld_tmp4 + ld_addrlumpsumamount + ld_broklumpsumamount &
			+ ld_tmp5 ) / ( ld_tmp3 * ( 1 - ld_allcomms_pc ) )
		
	CASE 3
		/* Calculation Lumpsum */
		ld_rate = ( ld_tmp2 + ( ( lstr_calc_parm.cargolist[ai_cargo_no[1]].d_demurrage / &
							1440) * (ld_allcomms_pc - 1)) + &
							ld_addrlumpsumamount + ld_broklumpsumamount + &
							ld_tmp5 ) / ( 1 - ld_allcomms_pc )	
	CASE 4
		/* WS Calculated */
		ld_rate = ( ( ld_tmp2 + ( ( lstr_calc_parm.cargolist[ai_cargo_no[1]].d_demurrage / &
						1440 ) * ( ld_allcomms_pc - 1 ) )  + &
						ld_addrlumpsumamount + ld_broklumpsumamount + &
						ld_tmp5 )  * 100 ) / ( ( ( 1 - ld_allcomms_pc) * ld_tmp3 ) * &
						astr_calc_parm.cargolist[ai_cargo_no[1]].d_flatrate)
	CASE ELSE					
		/* Do nothing */
END CHOOSE

return(ld_rate)
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_atobviac_calc_sensitivity
	
	<OBJECT>
		Object Description
	</OBJECT>
   	<DESC>
		Revised window for sensitivity calculations
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		u_atobviac_calculation
	</ALSO>
    	Date   		Ref    		Author   		Comments
  	14/10/11 	D-CALC	AGL      		First Version inside MT framework
	29/11/11		D-CALC	AGL			Allow users ability to switch through multiple calculations  
	02/11/15		CR3250	CCY018		Add LSFO fuel in calculation module.
	14/01/16		CR3248	LHG008		ECA zone implementation
********************************************************************/
end subroutine

public function integer wf_setmodified (boolean ab_modified);_ib_modified = ab_modified
if _ib_modified = true then p_refresh.visible = true
return c#return.Success
end function

public function integer _loadopencalcs ();/********************************************************************
   _localopencalcs()
<DESC>   
	Used to build dropdown data list of calculations currently open.
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	n/a
</ARGS>
<USAGE>
	when window is activated this refreshes the datawidow dddw content.
</USAGE>
********************************************************************/w_atobviac_calc_calculation lw_calcactive
u_atobviac_calculation luo_dummy
window			lw_parent, lw_sheet, lw_currentsheet
boolean 			lb_valid , lb_firstsheet = true , lb_found=false
integer li_index=0

/* maybe already cleared?  */
datawindowchild ldwc
integer li_row
dw_opencalcs.getchild("calchandle",ldwc)
ldwc.reset()

lw_parent = w_tramos_main
lw_sheet = lw_parent.getfirstsheet()
lb_valid = isvalid(lw_sheet)
/* reset calculation object */
iuo_calculation = luo_dummy
_ib_exists = false

do while lb_Valid
	li_index++
	if lw_sheet.classname( ) = "w_atobviac_calc_calculation" then
		if lb_firstsheet then
			lw_calcactive = lw_parent.getfirstsheet()
		else	
			lw_calcactive = lw_parent.getnextsheet(lw_currentsheet)	
		end if
		li_row = ldwc.insertrow(0)
		ldwc.setitem( li_row, "id" , lw_calcactive.uo_calculation.uf_get_calc_id() )
		ldwc.setitem( li_row, "calchandle" ,  handle(lw_calcactive) )
		ldwc.setitem( li_row, "name",  "#" + string(lw_calcactive.wf_cpact_get_winid(),"00") + " - " + lw_calcactive.title )
		if il_handle>0 and handle(lw_calcactive)=il_handle then
			_ib_exists =true
		end if	
	end if
	lw_currentsheet = lw_sheet
	lw_sheet = lw_parent.getnextsheet(lw_currentsheet)	
	lb_valid = isvalid (lw_sheet)
	lb_firstsheet = false
loop

ldwc.sort( )
p_refresh.visible=false

return c#return.Success
end function

private function integer _generate (u_atobviac_calculation auo_calc);/************************************************************************************
Author    :Teit Aunt 
Date       : 9-8-96
Description : Take the calculation which is the current one and pass it to the 
				  sensitivity window. The user chose the variable that he wants to 
				  investigate and enters the step interval value for the calculation.
				  The resulting values are returned to the sensitivity window. 
Arguments : The calculation
Returns   :   A new
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------------------
15-8-96		1.1			TA		List box of cargos
9-8-96		1.0 			TA		Initial version
************************************************************************************/

integer  li_count, li_rate_type, li_profitcenter_no
string ls_tmp, ls_rate_type

lb_cargos.reset()

// Recieves the calculation as an argument
iuo_calculation = auo_calc

// Puts number of cargoes into variable
ii_number_of_cargoes = iuo_calculation.uf_get_no_cargos()

// Gets the cargo description and append the type of cargo to it
For li_count = 1 To ii_number_of_cargoes
	ls_tmp = iuo_calculation.uf_get_cargo_description(li_count)
	li_rate_type = iuo_calculation.uf_get_rate_type(li_count)

	CHOOSE CASE li_rate_type
		CASE 1
			ls_rate_type = "(Rate)"
		CASE 2
			ls_rate_type = "(Rate)"
		CASE 3
			ls_rate_type = "(Lump)"
		CASE 4
			ls_rate_type = "(WS)"
	END CHOOSE

	ls_tmp = ls_tmp + '  ' +  ls_rate_type

	lb_cargos.InsertItem(ls_tmp,li_count)
Next

// Finds profitcenter of user. If tank pc.no then set TC day as true, else as false.
li_profitcenter_no = uo_global.get_profitcenter_no()
CHOOSE CASE li_profitcenter_no
	CASE 2,4,10
		st_tc_value.text = "TC Day:"
		cbx_tc_day.Checked = true
END CHOOSE

lb_cargos.SelectItem(1)

return 1
end function

private function integer _resetcalc (string as_message, boolean ab_calculated, boolean ab_modifiedflag, boolean ab_showmessages);if isvalid(iuo_calculation) then
	iuo_calculation.ib_modified = ab_modifiedflag
	iuo_calculation.ib_show_messages = ab_showmessages
	iuo_calculation.ib_calculated = ab_calculated
	iuo_calculation.uo_calc_itinerary.uf_clear_cache()
	
end if
if as_message<>"" then
	messagebox("Error",as_message)
end if	

return c#return.Success

end function

event open;call super::open;/************************************************************************************
Author    :Teit Aunt 
Date       : 9-8-96
Description : Take the calculation which is the current one and pass it to the 
				  sensitivity window. The user chose the variable that he wants to 
				  investigate and enters the step interval value for the calculation.
				  The resulting values are returned to the sensitivity window. 
Arguments : The calculation
Returns   :   A new
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------------------
15-8-96		1.1			TA		List box of cargos
9-8-96		1.0 			TA		Initial version
************************************************************************************/

integer  li_count, li_rate_type, li_profitcenter_no
string ls_tmp, ls_rate_type
u_atobviac_calculation luo_calculation

dw_opencalcs.insertrow(0)
n_service_manager lnv_serviceMgr
n_dw_style_service   lnv_style

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_calc_sensitivity,false)

end event

on w_atobviac_calc_sensitivity.create
int iCurrent
call super::create
this.dw_opencalcs=create dw_opencalcs
this.st_interval_size=create st_interval_size
this.sle_interval_size=create sle_interval_size
this.lb_cargos=create lb_cargos
this.st_3=create st_3
this.lb_variables=create lb_variables
this.cb_print=create cb_print
this.cb_calculate=create cb_calculate
this.dw_calc_sensitivity=create dw_calc_sensitivity
this.lb_ports=create lb_ports
this.st_4=create st_4
this.sle_tc_value=create sle_tc_value
this.st_tc_value=create st_tc_value
this.sle_net_day=create sle_net_day
this.sle_gross_day=create sle_gross_day
this.st_gross_day=create st_gross_day
this.st_net_day=create st_net_day
this.st_1=create st_1
this.cbx_tc_day=create cbx_tc_day
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_opencalcs
this.Control[iCurrent+2]=this.st_interval_size
this.Control[iCurrent+3]=this.sle_interval_size
this.Control[iCurrent+4]=this.lb_cargos
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.lb_variables
this.Control[iCurrent+7]=this.cb_print
this.Control[iCurrent+8]=this.cb_calculate
this.Control[iCurrent+9]=this.dw_calc_sensitivity
this.Control[iCurrent+10]=this.lb_ports
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.sle_tc_value
this.Control[iCurrent+13]=this.st_tc_value
this.Control[iCurrent+14]=this.sle_net_day
this.Control[iCurrent+15]=this.sle_gross_day
this.Control[iCurrent+16]=this.st_gross_day
this.Control[iCurrent+17]=this.st_net_day
this.Control[iCurrent+18]=this.st_1
this.Control[iCurrent+19]=this.cbx_tc_day
end on

on w_atobviac_calc_sensitivity.destroy
call super::destroy
destroy(this.dw_opencalcs)
destroy(this.st_interval_size)
destroy(this.sle_interval_size)
destroy(this.lb_cargos)
destroy(this.st_3)
destroy(this.lb_variables)
destroy(this.cb_print)
destroy(this.cb_calculate)
destroy(this.dw_calc_sensitivity)
destroy(this.lb_ports)
destroy(this.st_4)
destroy(this.sle_tc_value)
destroy(this.st_tc_value)
destroy(this.sle_net_day)
destroy(this.sle_gross_day)
destroy(this.st_gross_day)
destroy(this.st_net_day)
destroy(this.st_1)
destroy(this.cbx_tc_day)
end on

event activate;call super::activate;datawindowchild ldwc
integer li_row

if _ib_modified then
	dw_opencalcs.enabled=true
	lb_cargos.enabled = true
	cb_calculate.enabled = true
	_loadopencalcs()
	if not(_ib_exists) then
		dw_opencalcs.getchild("calchandle",ldwc)		
		if ldwc.rowcount() > 0 then		
			dw_opencalcs.setitem(1,"calchandle",ldwc.getitemnumber(1,"calchandle"))
			dw_opencalcs.postevent("itemchanged")
		else
			ldwc.reset()
			li_row = ldwc.insertrow( 0 )
			ldwc.setitem( li_row, "calchandle", 0)
			ldwc.setitem( li_row, "name", "no open calculations available")
			ldwc.setitem( li_row, "id", -1)
			dw_opencalcs.setitem(1,"calchandle",0)
			dw_opencalcs.enabled=false
			lb_cargos.enabled = false
			cb_calculate.enabled = false
			return
		end if	
		_ib_modified = false
	else
		if il_handle = 0 then
			il_handle=ldwc.getitemnumber(1,"calchandle")
		end if
		dw_opencalcs.setitem(1,"calchandle",il_handle)
		dw_opencalcs.postevent("itemchanged")
	end if	
	dw_opencalcs.selectrow(0,false)
	dw_opencalcs.selectrow(1,true)
end if

end event

type st_hidemenubar from mt_w_popupbox`st_hidemenubar within w_atobviac_calc_sensitivity
end type

type r_styledborder from mt_w_popupbox`r_styledborder within w_atobviac_calc_sensitivity
end type

type p_close from mt_w_popupbox`p_close within w_atobviac_calc_sensitivity
end type

type p_refresh from mt_w_popupbox`p_refresh within w_atobviac_calc_sensitivity
boolean visible = false
end type

type st_title from mt_w_popupbox`st_title within w_atobviac_calc_sensitivity
end type

type st_spacer from mt_w_popupbox`st_spacer within w_atobviac_calc_sensitivity
end type

type dw_opencalcs from mt_u_datawindow within w_atobviac_calc_sensitivity
event ue_command pbm_command
integer x = 50
integer y = 108
integer width = 1957
integer height = 88
integer taborder = 80
string dataobject = "d_ex_ff_opencalcs"
boolean border = false
end type

event clicked;call super::clicked;//of_loadopencalcs()
end event

event itemchanged;call super::itemchanged;w_atobviac_calc_calculation lw_calcactive
u_atobviac_calculation luo_dummy
window			lw_parent, lw_sheet, lw_currentsheet
boolean 			lb_valid , lb_firstsheet = true
integer li_index
long ll_oldhandle

/* maybe already cleared?  */
datawindowchild ldwc
integer li_row
dw_opencalcs.getchild("calchandle",ldwc)

lw_parent = w_tramos_main
lw_sheet = lw_parent.getfirstsheet()
lb_valid = isvalid(lw_sheet)
/* reset calculation object */
iuo_calculation = luo_dummy
_ib_exists = false

ll_oldhandle = il_handle
il_handle = ldwc.getitemnumber(ldwc.getrow(),"calchandle")

boolean lb_test

do while lb_Valid
	if lw_sheet.classname( ) = "w_atobviac_calc_calculation" then
		if lb_firstsheet then
			lw_calcactive = lw_parent.getfirstsheet()
		else	
			lw_calcactive = lw_parent.getnextsheet(lw_currentsheet)	
		end if
		if ll_oldhandle=	handle(lw_calcactive) then	
			_ib_exists=true
		end if
		if il_handle = handle(lw_calcactive) then
			_generate(lw_calcactive.uo_calculation)
		end if	
	end if
	lw_currentsheet = lw_sheet
	lw_sheet = lw_parent.getnextsheet(lw_currentsheet)	
	lb_valid = isvalid (lw_sheet)
	lb_firstsheet = false
loop

if not isnull(iuo_calculation) then
	lb_test = iuo_calculation.enabled
end if

lb_cargos.triggerevent("selectionchanged") 
dw_calc_sensitivity.reset()
end event

type st_interval_size from uo_st_base within w_atobviac_calc_sensitivity
integer x = 1678
integer y = 640
integer width = 201
integer height = 48
long backcolor = 32304364
string text = "Interval:"
alignment alignment = left!
end type

type sle_interval_size from uo_sle_base within w_atobviac_calc_sensitivity
integer x = 1682
integer y = 688
integer width = 347
integer height = 72
integer taborder = 40
boolean border = false
borderstyle borderstyle = stylebox!
end type

type lb_cargos from uo_lb_base within w_atobviac_calc_sensitivity
integer x = 50
integer y = 268
integer width = 677
integer height = 492
integer taborder = 10
boolean border = false
boolean sorted = false
boolean multiselect = true
end type

event selectionchanged;call super::selectionchanged;/****************************************************************************
Author		: TA
Date			: October 1996
Description	: Populate the variables listbox with the types of variables 
				  appropriate to the selected cargo. The other fields in the 
				  window are reset and unlocked.
Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
april 96	2.0		TA		Modified to handel one or more cargoes
****************************************************************************/
integer li_count, li_no_of_ports,li_cargo_no, li_tmp, li_state
integer li_rate, li_ws, li_lumpsum, li_tmp2, li_pos
string ls_port_name_purpose, ls_rate, ls_lump, ls_ws, ls_tc_eqv, ls_quantity, ls_text, ls_var, ls_bunker
string ls_port_name, ls_purpose
integer null_array[]

istr_port_parm.i_cargo_no[] = null_array[]
istr_port_parm.i_port_no = 0

istr_port_parm.i_no_of_selected  = 0
istr_port_parm.i_no_of_selected = lb_cargos.TotalSelected()

// Variables for the variable listbox
ls_rate = "Rate"
ls_ws = "Worldscale"
ls_lump = "Lumpsum"
ls_tc_eqv = "T/C month"
ls_quantity = "Quantity"
ls_bunker = "Bunker"

// If only one cargo is selected then
If istr_port_parm.i_no_of_selected = 1 Then
	li_tmp2 = 1
	istr_port_parm.i_cargo_no[li_tmp2] = lb_cargos.SelectedIndex()

	ls_text = lb_cargos.Text(istr_port_parm.i_cargo_no[li_tmp2])
	lb_variables.Reset()
	
	// Populate the variables list window acording to the cargo type
	If Pos(ls_text,"(Rate)") > 0 Then
		lb_variables.AddItem( ls_rate)
		lb_variables.AddItem( ls_tc_eqv)
		lb_variables.AddItem( ls_quantity)
		lb_variables.AddItem( ls_bunker)
	End if		 
	If Pos(ls_text,"(WS)") > 0 Then 
		lb_variables.AddItem( ls_ws)
		lb_variables.AddItem( ls_tc_eqv)
		lb_variables.AddItem( ls_quantity)
		lb_variables.AddItem( ls_bunker)
	End if
	If Pos(ls_text,"(Lump)") > 0 Then 
		lb_variables.AddItem( ls_lump)
		lb_variables.AddItem( ls_tc_eqv)
		lb_variables.AddItem( ls_quantity)
		lb_variables.AddItem( ls_bunker)
	End if

	lb_ports.Enabled = True
	lb_ports.Reset()
	
	li_cargo_no = lb_cargos.SelectedIndex()
	istr_port_parm.i_cargo_number = li_cargo_no

	li_no_of_ports = iuo_calculation.uf_get_no_loadports(li_cargo_no)
	ii_no_of_loadports = li_no_of_ports
	
	// Get the name and purpose of a load port and append it to the name
	For li_count = 1 to li_no_of_ports
		istr_port_parm.i_port_no = li_count
		ls_port_name_purpose = iuo_calculation.uf_get_lport_name_purpose(istr_port_parm)
		li_pos = Pos(ls_port_name_purpose,"&&")
		ls_port_name = Left(ls_port_name_purpose, li_pos - 1)
		ls_purpose  = Mid(ls_port_name_purpose, li_pos + 2, 5)
		If ls_purpose = "L" then 
			ls_purpose = "(load)"
		Else
			ls_purpose = "(" + ls_purpose + ")"
		End if
		ls_port_name_purpose = ls_port_name + "  "+ ls_purpose
		lb_ports.AddItem(ls_port_name_purpose)
	Next

	// Get the name and purpose of a disch port and append it to the name
	li_no_of_ports = iuo_calculation.uf_get_no_dischports(li_cargo_no)
	For li_count = 1  to li_no_of_ports
		istr_port_parm.i_port_no = li_count
		ls_port_name_purpose = iuo_calculation.uf_get_dport_name_purpose(istr_port_parm)
		li_pos = Pos(ls_port_name_purpose,"&&")
		ls_port_name = Left(ls_port_name_purpose, li_pos - 1)
		ls_purpose  = "(disch)"
		ls_port_name_purpose = ls_port_name + "  "+ ls_purpose
		lb_ports.AddItem(ls_port_name_purpose)
	Next
	
	// Reset and enable the fields and buttons in the window
	ls_port_name_purpose = ""

	sle_interval_size.visible = true
	//st_interval_size.visible = true
	sle_tc_value.visible = true
	//st_tc_value.visible = true
	sle_net_day.visible = true
	//st_net_day.visible = true	
	sle_gross_day.visible = true
	//st_gross_day.visible = true	
	lb_variables.enabled = true
	sle_tc_value.Text = ""
	sle_interval_size.Text = ""
	sle_net_day.text = ""
	sle_gross_day.text = ""
	
	// The number of ports selected is larger than one
	Elseif istr_port_parm.i_no_of_selected > 1 then
	lb_ports.Enabled = false
	lb_ports.Reset()
	lb_variables.Reset()
	li_rate = 0
	li_ws = 0
	li_lumpsum = 0
	li_tmp2 = 1
	
	// Finds out the rate type on the cargo 
	For li_tmp = 1 to ii_number_of_cargoes + 1
		li_state = lb_cargos.State(li_tmp)
		If li_state = 1 Then
		istr_port_parm.i_cargo_no[li_tmp2] = li_tmp
		li_tmp2 ++
		ls_text = lb_cargos.Text(li_tmp)
		If Pos(ls_text,"(Rate)") > 0 Then li_rate ++
		If Pos(ls_text,"(WS)") > 0 Then li_ws ++
		If Pos(ls_text,"(Lump)") > 0 Then li_lumpsum ++
		End if				
	Next
	
	// Populate the variable window with the appropriat variable type
	If (li_rate > 0) and (li_ws = 0) and (li_lumpsum = 0) Then
		ls_var = "Rate"
		lb_variables.AddItem( ls_var)
		lb_variables.SelectItem(1)
	Elseif (li_rate = 0) and (li_ws > 0) and (li_lumpsum = 0)  Then
		ls_var = "Worldscale"
		lb_variables.AddItem(ls_var)
		lb_variables.SelectItem(1)
	Elseif (li_rate = 0) and (li_ws = 0) and (li_lumpsum > 0) Then
		ls_var = "Lumpsum"
		lb_variables.AddItem(ls_var)
		lb_variables.SelectItem(1)
	Else
		MessageBox("Error","The selected cargoes must have the same rate type")
	End if


	// Reset and enable the fields in the window	
	sle_interval_size.visible = true
	//st_interval_size.visible = true
	sle_tc_value.visible = false
	//st_tc_value.visible = false
	sle_net_day.visible = false
	//st_net_day.visible = false
	sle_gross_day.visible = false
	//st_gross_day.visible = false	

	sle_tc_value.Text = ""
	sle_interval_size.Text = ""
	sle_net_day.text = ""
	sle_gross_day.text = ""
	lb_variables.Enabled = True
	
// No cargo is selected
Elseif istr_port_parm.i_no_of_selected = 0 then
	lb_variables.Reset()
	lb_ports.Reset()
	sle_interval_size.visible = false
	sle_tc_value.visible = False
	sle_net_day.visible = false
	sle_gross_day.visible = False
	sle_net_day.Text = ""
	sle_gross_day.Text = ""
	sle_tc_value.Text = ""
	sle_interval_size.Text = ""
End if

end event

type st_3 from uo_st_base within w_atobviac_calc_sensitivity
integer x = 50
integer y = 204
integer width = 238
integer height = 64
long backcolor = 32304364
string text = "Cargoes:"
alignment alignment = left!
end type

type lb_variables from uo_lb_base within w_atobviac_calc_sensitivity
integer x = 1275
integer y = 268
integer width = 366
integer height = 492
integer taborder = 30
boolean border = false
boolean sorted = false
end type

event selectionchanged;call super::selectionchanged;/****************************************************************************
Author		: TA
Date			: October 1996
Description	: If a variable on the cargo level is choosen the ports listbox
				  is cleared
Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
****************************************************************************/
String ls_variable




sle_tc_value.visible = false
//st_tc_value.visible = false
sle_net_day.visible = false
//st_net_day.visible = false
sle_gross_day.visible = false
//st_gross_day.visible = false	

sle_interval_size.text = ""

ls_variable = lb_variables.SelectedItem()

CHOOSE CASE ls_variable
	CASE "Lumpsum","Rate","Worldscale","Bunker","Quantity","T/C month"
		lb_ports.Reset()
		ii_port_no = -1
END CHOOSE



end event

type cb_print from uo_cb_base within w_atobviac_calc_sensitivity
integer x = 2098
integer y = 656
integer width = 274
integer height = 96
integer taborder = 100
string text = "&Print"
end type

event clicked;call super::clicked;/****************************************************************************
Author		: TA
Date			: 30-8-96
Description	: Prints the current calculation and the contents of the sensitivity
				  data window.
Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
Nov 1996	1.0		TA		Initial version
30/12/15		CR3248		CCY018		New itinerary UI.
****************************************************************************/
s_calc_print lstr_calc_print

lstr_calc_print.dw_calc = iuo_calculation.uo_calc_summary.dw_calc_summary
lstr_calc_print.dw_cargos = iuo_calculation.uo_calc_cargos.dw_cargo_summary
lstr_calc_print.dw_sensitivity = dw_calc_sensitivity
lstr_calc_print.s_header = dw_calc_sensitivity.Describe("ftf_header.text")

/* Get data from itinerary - are only there when the window is active */
iuo_calculation.uo_calc_itinerary.uf_retrieve()
lstr_calc_print.dw_calc_itinerary = iuo_calculation.uo_calc_itinerary.tab_itinerary.tp_itinerary.dw_itinerary

OpenWithParm(w_atobviac_calc_invisible_print,lstr_calc_print)
	

end event

type cb_calculate from uo_cb_base within w_atobviac_calc_sensitivity
integer x = 2098
integer y = 528
integer width = 279
integer height = 96
integer taborder = 90
string text = "&Calculate"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************
Author    :Teit Aunt 
Date       : 15-8-96
Description : Calls the wf_sensitivity funktion to start doing sensitivity
Arguments : None
Returns   : None
*************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
15-8-96		1.0 			TA		Initial version
************************************************************************/
wf_sensitivity()

end event

type dw_calc_sensitivity from u_datawindow_sqlca within w_atobviac_calc_sensitivity
integer x = 59
integer y = 804
integer width = 2304
integer height = 964
string dataobject = "d_calc_sensitivity"
boolean border = false
end type

type lb_ports from uo_lb_base within w_atobviac_calc_sensitivity
integer x = 782
integer y = 268
integer width = 439
integer height = 492
integer taborder = 20
boolean border = false
boolean sorted = false
end type

event selectionchanged;call super::selectionchanged;/****************************************************************************
Author		: TA
Date			: October 1996
Description	: Insert the variables for doing sensitivity on a port acording to
				  the profit center of the user
Arguments	: None
Returns		: cargo
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
****************************************************************************/
integer li_found
long ll_profit_center
string ls_load, ls_disch, ls_des, ls_tmp, ls_purpose

lb_variables.Reset()

ls_load = "Loadrate"
ls_des = "Despatch"
ls_disch = "Dischrate"

// Find users profitcenter
ll_profit_center = uo_global.get_profitcenter_no( )

ls_tmp = lb_ports.SelectedItem()
li_found = Pos(ls_tmp, "  ")
ls_purpose = Trim(Mid(ls_tmp,li_found + 2, 10))

// Insert purpose in variables
CHOOSE CASE ls_purpose
	CASE "(load)"
		If (ll_profit_center = 3 or ll_profit_center = 5) Then
			lb_variables.AddItem(ls_load)
			lb_variables.AddItem(ls_des)
		Else
			lb_variables.AddItem(ls_load)
		End if
	CASE "(disch)"
		If (ll_profit_center = 3 or ll_profit_center = 5) Then
			lb_variables.AddItem(ls_disch)
			lb_variables.AddItem(ls_des)
		Else
			lb_variables.AddItem(ls_disch)
		End if
	CASE ELSE
		lb_variables.AddItem(ls_load)
END CHOOSE

ii_port_no = lb_ports.SelectedIndex()

sle_tc_value.visible = false
sle_gross_day.visible = true
sle_interval_size.visible = true
sle_net_day.visible = true
//st_tc_value.visible = false

end event

type st_4 from uo_st_base within w_atobviac_calc_sensitivity
integer x = 777
integer y = 204
integer width = 256
integer height = 48
long backcolor = 32304364
string text = "Ports:"
alignment alignment = left!
end type

type sle_tc_value from uo_sle_base within w_atobviac_calc_sensitivity
integer x = 1678
integer y = 268
integer width = 347
integer height = 72
integer taborder = 50
boolean border = false
borderstyle borderstyle = stylebox!
end type

event getfocus;call super::getfocus;/****************************************************************************
Author		: TA
Date			: October 1996
Description	: When a number is entered variables and ports list box is cleared
				  and disabled, and gross and net day fields are disabled
Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
****************************************************************************/
sle_interval_size.visible = false
sle_net_day.visible = false
sle_gross_day.visible = false

lb_variables.Enabled = False
lb_variables.Reset()

lb_ports.Enabled = False
lb_ports.Reset()


end event

type st_tc_value from uo_st_base within w_atobviac_calc_sensitivity
integer x = 1669
integer y = 208
integer width = 256
integer height = 48
long backcolor = 32304364
string text = "T/C month:"
alignment alignment = left!
end type

type sle_net_day from uo_sle_base within w_atobviac_calc_sensitivity
integer x = 1678
integer y = 408
integer width = 347
integer height = 72
integer taborder = 60
boolean border = false
borderstyle borderstyle = stylebox!
end type

event getfocus;call super::getfocus;/****************************************************************************
Author		: TA
Date			: October 1996
Description	: When a number is entered variables and ports list box is cleared
				  and disabled, and gross day and T/C value fields are disabled
Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
****************************************************************************/

sle_interval_size.visible = false
//st_interval_size.visible = false
sle_tc_value.visible = false
//st_tc_value.visible = false
sle_gross_day.visible = false
//st_gross_day.visible = false	




lb_variables.Enabled = False
lb_variables.Reset()

lb_ports.Enabled = False
lb_ports.Reset()


end event

type sle_gross_day from uo_sle_base within w_atobviac_calc_sensitivity
integer x = 1678
integer y = 548
integer width = 347
integer height = 72
integer taborder = 80
boolean border = false
borderstyle borderstyle = stylebox!
end type

event getfocus;call super::getfocus;/****************************************************************************
Author		: TA
Date			: October 1996
Description	: When a number is entered variables and ports list box is cleared
				  and disabled, and net day and T/C value fields are disabled
Arguments	: None
Returns		: None
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
10-10-96	1.0		TA		Initial version
****************************************************************************/

sle_interval_size.visible = false
//st_interval_size.visible = false
sle_tc_value.visible = false
//st_tc_value.visible = false
sle_net_day.visible = false
//st_net_day.visible = false	


lb_variables.Enabled = False
lb_variables.Reset()

lb_ports.Enabled = False
lb_ports.Reset()


end event

type st_gross_day from uo_st_base within w_atobviac_calc_sensitivity
integer x = 1678
integer y = 496
integer height = 48
long backcolor = 32304364
string text = "Gross day:"
alignment alignment = left!
end type

type st_net_day from uo_st_base within w_atobviac_calc_sensitivity
integer x = 1678
integer y = 352
integer width = 238
integer height = 48
long backcolor = 32304364
string text = "Net day:"
alignment alignment = left!
end type

type st_1 from uo_st_base within w_atobviac_calc_sensitivity
integer x = 1275
integer y = 208
integer width = 279
integer height = 48
long backcolor = 32304364
string text = "Parameter:"
end type

type cbx_tc_day from checkbox within w_atobviac_calc_sensitivity
integer x = 2103
integer y = 280
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 32304364
string text = "T/C day"
end type

event clicked;If st_tc_value.text = "T/C month:" then
	st_tc_value.text = "T/C day:"
Else
	st_tc_value.text = "T/C month:"
End if
end event

