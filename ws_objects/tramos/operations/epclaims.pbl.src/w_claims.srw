$PBExportHeader$w_claims.srw
$PBExportComments$Claims Main Window. Displays : list of Claims for one vessel, Claim Base Info, Dem_des Claims... Includes a lot of Hidden Dw.
forward
global type w_claims from w_vessel_basewindow
end type
type gb_dem_rate from mt_u_groupbox within w_claims
end type
type cb_update from commandbutton within w_claims
end type
type cb_cancel from commandbutton within w_claims
end type
type cb_delete from commandbutton within w_claims
end type
type cb_print from commandbutton within w_claims
end type
type cb_afc from commandbutton within w_claims
end type
type cb_deviation from commandbutton within w_claims
end type
type cb_heating from commandbutton within w_claims
end type
type cb_freight from commandbutton within w_claims
end type
type cb_misc from commandbutton within w_claims
end type
type cb_demurrage from commandbutton within w_claims
end type
type cb_refresh_claim from commandbutton within w_claims
end type
type cb_delete_received from commandbutton within w_claims
end type
type cb_new_received from commandbutton within w_claims
end type
type cb_close_bulk from commandbutton within w_claims
end type
type uo_balance from u_claimbalance within w_claims
end type
type cb_unlock from commandbutton within w_claims
end type
type cb_new from u_cb_option within w_claims
end type
type st_1 from u_topbar_background within w_claims
end type
type dw_add_lumpsums from datawindow within w_claims
end type
type cb_scroll_prior_dem from commandbutton within w_claims
end type
type st_dem_count from statictext within w_claims
end type
type st_dem_total from statictext within w_claims
end type
type cb_scroll_next_dem from commandbutton within w_claims
end type
type cb_l_d_amount from commandbutton within w_claims
end type
type cb_afc_update_recieved from commandbutton within w_claims
end type
type cb_dem_des_new_rate from commandbutton within w_claims
end type
type cb_dem_des_delete_rate from commandbutton within w_claims
end type
type cb_broker from commandbutton within w_claims
end type
type dw_claim_base from uo_datawindow within w_claims
end type
type gb_base_claim from mt_u_groupbox within w_claims
end type
type cb_delete_action from commandbutton within w_claims
end type
type cb_new_action from commandbutton within w_claims
end type
type cb_update_action from commandbutton within w_claims
end type
type cb_cancel_action from commandbutton within w_claims
end type
type cb_delete_afc_recieved from commandbutton within w_claims
end type
type cb_new_afc_recieved from commandbutton within w_claims
end type
type cb_scroll_prior from commandbutton within w_claims
end type
type st_afc_count from statictext within w_claims
end type
type st_afc_total from statictext within w_claims
end type
type dw_add_lumpsums_afc from datawindow within w_claims
end type
type dw_afc_bol from datawindow within w_claims
end type
type dw_afc_recieved from datawindow within w_claims
end type
type dw_bulk_amounts from datawindow within w_claims
end type
type dw_dem_des_rates from uo_datawindow within w_claims
end type
type dw_list_claims from u_datagrid within w_claims
end type
type cb_scroll_next from commandbutton within w_claims
end type
type dw_freight_received from uo_datawindow within w_claims
end type
type p_dot from picture within w_claims
end type
type cb_office from commandbutton within w_claims
end type
type dw_freight_claim from uo_datawindow within w_claims
end type
type dw_dem_des_claim from uo_datawindow within w_claims
end type
type dw_afc from datawindow within w_claims
end type
type uo_frt_balance from uo_freight_balance within w_claims
end type
type gb_freight_balance from mt_u_groupbox within w_claims
end type
type uo_afc from uo_afc_freight_balance within w_claims
end type
type gb_dem_claim from mt_u_groupbox within w_claims
end type
type dw_hea_dev_claim from uo_datawindow within w_claims
end type
type gb_freight_claim from mt_u_groupbox within w_claims
end type
type gb_dev_claim from mt_u_groupbox within w_claims
end type
type uo_att_actions from u_fileattach within w_claims
end type
type st_setexrate from statictext within w_claims
end type
end forward

shared variables

end variables

global type w_claims from w_vessel_basewindow
integer width = 4393
integer height = 2568
string title = "Claims"
boolean maxbox = false
boolean resizable = false
string icon = "images\claims.ico"
boolean ib_setdefaultbackgroundcolor = true
event ue_afc_update pbm_custom16
event ue_afc_delete pbm_custom17
event ue_reload ( s_vessel_voyage_chart_claim astr_newdata )
gb_dem_rate gb_dem_rate
cb_update cb_update
cb_cancel cb_cancel
cb_delete cb_delete
cb_print cb_print
cb_afc cb_afc
cb_deviation cb_deviation
cb_heating cb_heating
cb_freight cb_freight
cb_misc cb_misc
cb_demurrage cb_demurrage
cb_refresh_claim cb_refresh_claim
cb_delete_received cb_delete_received
cb_new_received cb_new_received
cb_close_bulk cb_close_bulk
uo_balance uo_balance
cb_unlock cb_unlock
cb_new cb_new
st_1 st_1
dw_add_lumpsums dw_add_lumpsums
cb_scroll_prior_dem cb_scroll_prior_dem
st_dem_count st_dem_count
st_dem_total st_dem_total
cb_scroll_next_dem cb_scroll_next_dem
cb_l_d_amount cb_l_d_amount
cb_afc_update_recieved cb_afc_update_recieved
cb_dem_des_new_rate cb_dem_des_new_rate
cb_dem_des_delete_rate cb_dem_des_delete_rate
cb_broker cb_broker
dw_claim_base dw_claim_base
gb_base_claim gb_base_claim
cb_delete_action cb_delete_action
cb_new_action cb_new_action
cb_update_action cb_update_action
cb_cancel_action cb_cancel_action
cb_delete_afc_recieved cb_delete_afc_recieved
cb_new_afc_recieved cb_new_afc_recieved
cb_scroll_prior cb_scroll_prior
st_afc_count st_afc_count
st_afc_total st_afc_total
dw_add_lumpsums_afc dw_add_lumpsums_afc
dw_afc_bol dw_afc_bol
dw_afc_recieved dw_afc_recieved
dw_bulk_amounts dw_bulk_amounts
dw_dem_des_rates dw_dem_des_rates
dw_list_claims dw_list_claims
cb_scroll_next cb_scroll_next
dw_freight_received dw_freight_received
p_dot p_dot
cb_office cb_office
dw_freight_claim dw_freight_claim
dw_dem_des_claim dw_dem_des_claim
dw_afc dw_afc
uo_frt_balance uo_frt_balance
gb_freight_balance gb_freight_balance
uo_afc uo_afc
gb_dem_claim gb_dem_claim
dw_hea_dev_claim dw_hea_dev_claim
gb_freight_claim gb_freight_claim
gb_dev_claim gb_dev_claim
uo_att_actions uo_att_actions
st_setexrate st_setexrate
end type
global w_claims w_claims

type variables
integer  ii_claim_nr

long il_last_row,il_charter_nr, ii_cerp_id
Integer ii_dem_des
String is_voyage_nr, is_port_array[100], is_ori_net_freight
s_afc_del_freight_received del_freight_rec[50]
s_port_array istr_port_array
Boolean ib_calc_yes_no, ib_broker_set 
Boolean ib_set_dem_part_amount
Decimal id_adrs_comm
Boolean ibl_new, ib_dw_has_focus

boolean ib_claim_amount_changed = false
boolean ib_claim_amount_usd_changed = false

decimal {6} id_fixed_exrate = 0

private boolean _ib_updatefailure /*If data has been modified but the update failed or did not pass the validation*/

boolean ib_ignoredefaultbutton

constant string COLUMN_CURRENCY_CODE = "curr_code"
constant string COLUMN_CLAIM_NR = "claim_nr"
constant string COLUMN_VESSEL_NR = "vessel_nr"
constant string COLUMN_VOYAGE_NR = "voyage_nr"
constant string COLUMN_CHART_NR = "chart_nr"
constant string COLUMN_CP_ID = "cal_cerp_id"
constant string COLUMN_CLAIM_TYPE = "claim_type"
constant string COLUMN_LUMPSUM = "lumpsum"

long il_bunker_visible
long il_lumpsum_visible
long il_time_visible

u_dddw_search iuo_dddw_search_responsible
n_messagebox inv_messagebox
end variables

forward prototypes
public function integer wf_show_hide_dw (string claim_type)
public subroutine wf_enabled_buttons (string status)
public function boolean wf_afc_new ()
public function integer wf_afc_validate_claim ()
public subroutine wf_afc_scroll ()
public subroutine wf_afc_recieved_filter (integer row)
public subroutine wf_afc_update_freight_claims (integer charter, integer vessel, string voyage, integer claim, decimal quantity)
public subroutine wf_afc_update_bol (integer chart, string voyage, integer vessel, integer claim, decimal bol)
public subroutine wf_dem_scroll ()
public subroutine wf_dem_des_tabs (boolean open_close)
public subroutine wf_frt_tabs (boolean open_close)
public subroutine wf_afc_tabs (boolean open_close)
public subroutine wf_afc_new_bol (integer vessel, string voyage, integer charter)
public subroutine wf_part_amount (integer row)
public subroutine wf_set_pcn_order (ref s_pcn_order lstr[], integer vessel, string voyage)
public subroutine wf_set_allowed (integer row)
public subroutine wf_protect_receivable ()
public function integer wf_validate_claims ()
public function integer wf_frt_with_calc (s_select_voyage_charterer lstr_calc_data)
public subroutine wf_claim_base_tabs (boolean open_close)
public subroutine wf_afc_del_array ()
private function integer wf_new_claim (string claim_type)
public subroutine wf_dem_rate_tabs ()
public subroutine wf_afc_add_lump_filter (integer row)
public subroutine documentation ()
public function integer wf_enableactions (boolean ab_enabled)
public subroutine _lockcurrcode ()
public function integer wf_datawindow_modified (string claim_type)
public function integer wf_datawindow_modified ()
public function decimal wf_get_comm_percent (long ai_vessel_nr, string as_voyage_nr, long al_broker_nr)
public function integer wf_getkeydata (ref s_vessel_voyage_chart_claim astr_currentdata)
public function boolean wf_allow_linkcalculation ()
public subroutine wf_new_dem_des ()
public subroutine wf_new_deviation ()
public subroutine wf_new_heating ()
public subroutine wf_new_freight ()
public subroutine wf_get_claim_email ()
public subroutine wf_misc_contract (integer ai_vessel_nr, string as_voyage_nr, ref s_claim_base_data astr_claim_base_data)
public function integer wf_check_lumpbrocom (integer ai_chartnr, integer ai_vesselnr, string as_voyagenr, integer ai_claimnr)
public function long wf_get_expect_receive_percent (string as_claimtype)
private function integer wf_layout_misc_objects (string as_claim_type)
public subroutine wf_new_misc (string as_claim_type)
private function boolean of_isexclusivenull (any la_a, any la_b)
public function integer wf_get_misc_options (string as_claim_type, ref long al_bunker, ref long al_lumpsum, ref long al_ctime)
public function integer wf_validate_misc ()
public subroutine wf_filtermisctype ()
public function boolean wf_ismiscclaims (string as_type)
public subroutine wf_enablemisctype ()
public function string wf_checkclaimcommsent ()
end prototypes

event ue_afc_update;integer li_claim_nr = 0, li_chart_nr, li_afc_counter, li_rows
string ls_voyage_nr, ls_text, ls_voyage_notes, ls_update_voyage_notes, ls_rollback
long ll_row
boolean lb_new_claim = FALSE
decimal {2} freight_balance = 0,freight_balance_part = 0, ld_amount_usd, ld_amount
decimal {2} ld_sum_bol, ld_x, ld_i
uo_auto_commission uo_auto_comm
Double ldo_cp_id_comm
n_claimcurrencyadjust lnv_claimcurrencyadjust
string ls_curr_code, ls_claim_type
long ll_cerp_id

IF wf_afc_validate_claim() = -1 THEN Return 0

dw_afc_recieved.SetFilter("")
dw_afc_recieved.Filter()

dw_add_lumpsums_afc.SetFilter("")
dw_add_lumpsums_afc.Filter()

ls_voyage_nr = dw_claim_base.GetItemString(1,"voyage_nr")
li_chart_nr = dw_claim_base.GetItemNumber(1,"chart_nr")
ls_curr_code = dw_claim_base.GetItemString(1,COLUMN_CURRENCY_CODE)
ls_claim_type = dw_claim_base.GetItemString(1,COLUMN_CLAIM_TYPE)
ll_cerp_id = dw_claim_base.GetItemNumber(1, COLUMN_CP_ID)

//get broker claim_email
wf_get_claim_email()
//end 

IF dw_claim_base.GetItemStatus(1,0,PRIMARY!) = New! OR  dw_claim_base.GetItemStatus(1,0,PRIMARY!) = NewModified! THEN
	SELECT MAX(CLAIM_NR)
		INTO :li_claim_nr
		FROM CLAIMS
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr
		AND CHART_NR = :li_chart_nr
		USING SQLCA;
	COMMIT USING SQLCA;
	
	IF IsNull(li_claim_nr) THEN
		li_claim_nr = 1
	ELSE
		li_claim_nr = li_claim_nr + 1
	END IF
	lb_new_claim = TRUE

	/* UPDATE STATEMENTS IF NEW CLAIM */

	dw_claim_base.SetItem(1,"claim_nr",li_claim_nr)
		
	li_rows = dw_afc.RowCount()
	FOR li_afc_counter = 1 TO  li_rows			
		dw_afc.SetItem(li_afc_counter,"freight_advanced_claim_nr",li_claim_nr)
		IF NOT dw_afc.GetItemNumber(li_afc_counter,"freight_advanced_cal_cerp_id") > 0 THEN	
			dw_afc.SetItem(li_afc_counter,"freight_advanced_cal_cerp_id",1)
		END IF
		ld_sum_bol += dw_afc.GetItemDecimal(li_afc_counter,"freight_advanced_afc_bol_quantity")
	NEXT
	dw_add_lumpsums_afc.SetItem(1,"claim_nr",li_claim_nr)
	
	
	IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
		IF dw_afc.Update(TRUE, FALSE) = 1 THEN		
			IF  dw_add_lumpsums_afc.Update(TRUE, FALSE) = 1 THEN 
				uo_afc.SetRedraw(FALSE)		
				FOR li_afc_counter = 1 TO  li_rows		
					freight_balance +=  uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr,li_afc_counter)
				NEXT
				uo_afc.SetRedraw(TRUE)	
				ld_amount = freight_balance
				dw_claim_base.SetItem(1,"claim_amount",ld_amount)
				lnv_claimcurrencyadjust.of_getamountusd( ii_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_amount, ld_amount_usd)
				dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
				IF dw_afc_recieved.Update(TRUE, FALSE) = 1 THEN				
					dw_claim_base.ResetUpdate()
					dw_afc.ResetUpdate()
					dw_add_lumpsums_afc.ResetUpdate()
					wf_afc_update_freight_claims(li_chart_nr, ii_vessel_nr,ls_voyage_nr,li_claim_nr,ld_sum_bol)
					dw_afc_recieved.ResetUpdate()
					COMMIT;					
					IF SQLCA.SQLCode = 0 THEN		
						freight_balance = 0
						FOR li_afc_counter = 1 TO  li_rows			
							freight_balance_part = uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr,li_afc_counter)
							freight_balance += freight_balance_part
							dw_afc.SetItem(li_afc_counter,"freight_advanced_afc_freight_net",freight_balance_part)
						NEXT	
						uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr,dw_afc.GetRow())
						dw_afc.Update()
						ld_amount = freight_balance
						dw_claim_base.SetItem(1,"claim_amount",ld_amount)
						lnv_claimcurrencyadjust.of_getamountusd(ii_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_amount, ld_amount_usd)
						dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
						dw_claim_base.Update()		
						COMMIT;
						uo_auto_comm.of_generate(ii_vessel_nr,ls_voyage_nr,li_chart_nr,li_claim_nr,"AFC FRT","NEW",ldo_cp_id_comm)
						
					        wf_enabled_buttons("UPDATE")						
					END IF	
				ELSE
					ROLLBACK;
				END IF				
			ELSE
					ROLLBACK;
			END IF
		ELSE
			ROLLBACK;
		END IF
	ELSE
		ROLLBACK;
	END IF			
	TriggerEvent("ue_retrieve")	
	ll_row = dw_list_claims.Find("claim_nr="+string(li_claim_nr)+" and voyage_nr='"+ls_voyage_nr+"'",1,dw_list_claims.RowCount())
	dw_list_claims.SelectRow(ll_row,TRUE)
	dw_list_claims.ScrollToRow(ll_row)
	uo_balance.of_claimbalance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)

ELSE
	/* UPDATE STATEMENTS IF MODIFIED CLAIM */

	li_claim_nr = dw_claim_base.GetItemNumber(1,"claim_nr")

	li_rows = dw_afc.RowCount()
				
			IF dw_afc_recieved.Update(TRUE, FALSE) = 1 THEN
				IF dw_afc.Update(TRUE, FALSE) = 1 THEN		
					uo_afc.SetRedraw(FALSE)		
					FOR li_afc_counter = 1 TO  li_rows
						freight_balance += uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr,li_afc_counter)
			   		 NEXT
					uo_afc.SetRedraw(TRUE)		
					ld_amount = freight_balance
					dw_claim_base.SetItem(1,"claim_amount",ld_amount)
					lnv_claimcurrencyadjust.of_getclaimamounts(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ld_amount, ld_amount_usd, false)
     				dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
					IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
						dw_claim_base.ResetUpdate()
						
												
						dw_afc.ResetUpdate()
						wf_afc_update_bol( li_chart_nr, ls_voyage_nr, ii_vessel_nr, li_claim_nr, ld_sum_bol)
						dw_afc_recieved.ResetUpdate()
						COMMIT;
						freight_balance = 0
						FOR li_afc_counter = 1 TO  li_rows
							ld_sum_bol += dw_afc.GetItemDecimal(li_afc_counter,"freight_advanced_afc_bol_quantity")
							freight_balance_part = uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr,li_afc_counter)
							freight_balance += freight_balance_part
							dw_afc.SetItem(li_afc_counter,"freight_advanced_afc_freight_net",freight_balance_part)	
			   			 NEXT
						 uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr,dw_afc.GetRow())	
						dw_afc.Update()
						
						// Investigate if there was a change to the address commission %
						ld_x = dw_claim_base.GetItemDecimal(1,"claims_address_com")
						ld_i = id_adrs_comm
						If ld_i <> ld_x Then
							// We construct the text we want to insert
							ls_text=" ~r~nSystem Message: On voyage "+is_voyage_nr+" for vessel no = "+string(ii_vessel_nr) +&
								" and claim no = "+string(li_claim_nr)+" the address commission was changed from "+&
								+string(ld_i)+" to "+string(ld_x)+ " on the "+string(today())+" by "+string(uo_global.gos_userid)+"."
							//	We get the field voyage_notes
							SELECT VOYAGE_NOTES INTO :ls_voyage_notes  FROM VOYAGES WHERE VOYAGE_NR= :is_voyage_nr  AND VESSEL_NR= :ii_vessel_nr;
							If IsNull(ls_voyage_notes) Then ls_voyage_notes = ""

							//	We append our text about the change of voyagenumber to the text already written in the field
							ls_voyage_notes= ls_voyage_notes + ls_text
							ls_update_voyage_notes="UPDATE VOYAGES SET VOYAGE_NOTES = '"+ls_voyage_notes+"' WHERE VOYAGE_NR='"+ is_voyage_nr+"' AND VESSEL_NR="+string(ii_vessel_nr)
							EXECUTE IMMEDIATE: ls_update_voyage_notes using sqlca;
							if sqlca.sqlcode <> 0 then
								messagebox("Voyage note update error","The changed address commission has not been included in Voyage notes. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
								EXECUTE IMMEDIATE:ls_rollback using sqlca;
								return 0
							end if
							id_adrs_comm = ld_x 
						end if
						
						COMMIT;		
						uo_auto_comm.of_generate(ii_vessel_nr,ls_voyage_nr,li_chart_nr,li_claim_nr,"AFC FRT","OLD",ldo_cp_id_comm)
				ELSE
						ROLLBACK;
					END IF
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
	uo_balance.of_claimbalance(ii_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)
END IF
dw_add_lumpsums_afc.setfilter("afc_nr="+st_afc_count.Text)
dw_add_lumpsums_afc.filter( )
Return 1

end event

event ue_afc_delete;long ll_no_of_rows, xx, ll_claimid
integer li_vessel_nr, li_chart_nr, li_claim_nr, li_count_comm, li_response
string ls_voyage_nr, ls_claim_type, ls_invoice_nr, ls_errtext
Datetime ldt_date
n_claims_transaction lnv_claims_transaction

constant string METHOD_NAME = "ue_afc_delete()"

li_vessel_nr = dw_claim_base.GetItemNumber(1,"vessel_nr")
ls_voyage_nr = dw_claim_base.GetItemString(1,"voyage_nr")
li_chart_nr = dw_claim_base.GetItemNumber(1,"chart_nr")
li_claim_nr = dw_claim_base.GetItemNumber(1,"claim_nr")
ls_claim_type = dw_claim_base.GetItemstring(1, "claim_type")

if (ls_claim_type = "FRT") then
	SELECT Count(*)
	INTO :li_count_comm
	FROM COMMISSIONS, CLAIMS
	WHERE (CLAIMS.CHART_NR = COMMISSIONS.CHART_NR AND
	CLAIMS.VESSEL_NR = COMMISSIONS.VESSEL_NR AND
	CLAIMS.VOYAGE_NR = COMMISSIONS.VOYAGE_NR AND
	CLAIMS.CLAIM_NR = COMMISSIONS.CLAIM_NR) AND 
	COMMISSIONS.VESSEL_NR = :li_vessel_nr AND COMMISSIONS.VOYAGE_NR = :ls_voyage_nr
	AND COMMISSIONS.CHART_NR = :li_chart_nr  AND COMMISSIONS.CLAIM_NR = :li_claim_nr AND
	CLAIMS.CLAIM_TYPE = "FRT" AND (COMMISSIONS.COMM_SETTLED = 1 or COMMISSIONS.COMM_AUTO = "Manual");
	Commit;
	IF li_count_comm > 0 THEN
		MessageBox("Message","There exists commissions which are settled or created manually. Delete is not allowed !")
		Return
	else
		open(w_claims_com_frt)
		li_response = Message.DoubleParm
		if (li_response = 0) then
			RETURN
		end if
	end if
else
	SELECT Count(*)
	INTO :li_count_comm
	FROM COMMISSIONS
	WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr
			AND CHART_NR = :li_chart_nr  AND CLAIM_NR = :li_claim_nr ;
	Commit;
	IF li_count_comm > 0 THEN
		MessageBox("Message","There exists commissions. Delete is not allowed !")
		Return
	END IF
end if

if messagebox("Confirm delete of Claim!", "Please confirm delete of current selected Claim, which (If DEM/DES) will include delete of:" &
	+ "~r~n~r~n- Claim details~r~n- Claim Actions~r~n- Claim Transactions~r~n- Laytime Statements (Demurrage/Despatch Claims)" &
	+ "~r~n- (CMS if not transferred to file)", Question!, OKCancel!, 2) = 2 then return c#return.NoAction

// NO Commits, before end
DELETE FROM CLAIM_ACTION
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if

DELETE FROM CLAIM_TRANSACTION
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if

DELETE FROM FREIGHT_RECEIVED
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if
		
DELETE FROM FREIGHT_CLAIMS
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if

DELETE FROM FREIGHT_ADVANCED_RECIEVED
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if

DELETE FROM FREIGHT_ADVANCED_ADD_LUMPSUMS
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if

DELETE FROM FREIGHT_ADVANCED
      WHERE VESSEL_NR = :li_vessel_nr AND
		      VOYAGE_NR = :ls_voyage_nr AND
				CHART_NR  = :li_chart_nr  AND
				CLAIM_NR  = :li_claim_nr;
				
if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("SQL error", ls_errtext, information!)
	return
end if

//Delete adjustment reason
DELETE CLAIM_SENT
 WHERE CHART_NR = :li_chart_nr
	AND VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND CLAIM_NR = :li_claim_nr;

if sqlca.sqlcode = -1 then
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK USING SQLCA;
	_addmessage(this.classdefinition, METHOD_NAME, "Error deleting CLAIM_SENT.", ls_errtext)
	return c#return.Failure
end if

//Create credit Note
ls_invoice_nr = dw_claim_base.GetItemString(1,"invoice_nr")
ll_claimid = dw_claim_base.GetItemNumber(1,"claim_id")

lnv_claims_transaction = create n_claims_transaction
	
if ls_invoice_nr<>"" then
	if lnv_claims_transaction.of_credit_note(ll_claimid, ls_invoice_nr) = c#return.Failure then
		ls_errtext = sqlca.sqlerrtext
		ROLLBACK;
		_addmessage(this.classdefinition, METHOD_NAME, "Error deleting the claim transaction record(s) unable to complete process!", ls_errtext)
		destroy lnv_claims_transaction
		return c#return.Failure
	end if
end if


ll_no_of_rows = dw_afc_recieved.RowCount() 
FOR xx = 1 to ll_no_of_rows
	dw_afc_recieved.DeleteRow(xx)
NEXT
dw_afc_recieved.Reset()

ll_no_of_rows = dw_afc.RowCount() 
FOR xx = 1 to ll_no_of_rows
	dw_afc.DeleteRow(xx)
NEXT
dw_afc.Reset()

dw_claim_base.DeleteRow(1)

IF dw_freight_received.Update(TRUE, FALSE) = 1 THEN
	IF dw_add_lumpsums_afc.Update(TRUE, FALSE) = 1 THEN
		IF dw_freight_claim.Update(TRUE, FALSE) = 1 THEN
			IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
				dw_add_lumpsums_afc.resetupdate( )
				dw_claim_base.ResetUpdate()
				dw_freight_claim.ResetUpdate()
				dw_freight_received.ResetUpdate()
				COMMIT;
				IF SQLCA.SQLCode = 0 THEN 
					wf_enabled_buttons("DELETE")		
					uo_balance.of_setnull( )
				END IF
			ELSE
				ROLLBACK;
			END IF
		ELSE
			ROLLBACK;
		END IF
	ELSE
		ROLLBACK;
	END IF
ELSE
	ROLLBACK;
END IF

if isvalid(lnv_claims_transaction) then destroy lnv_claims_transaction

end event

event ue_reload(s_vessel_voyage_chart_claim astr_newdata);/********************************************************************
   ue_reload()
<DESC>   
	Implemented to be used when a charterer has changed in C/P data.  This event is
	called when vessel matches amended vessel attached to C/P.  The datawindow has to
	be re-retrieved with new data.
</DESC>
<RETURN>
n/a
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	s_vessel_voyage_chart_claim: astr_newdata
</ARGS>
<USAGE>
	business logic specific to C/P is left there.  Expected process is to obtain data from window
	using wf_getkeydata().  Manipulate according to implementation and then reload claims window
	if required.
</USAGE>
********************************************************************/
if astr_newdata.status = "VESSEL" or astr_newdata.status = "RELOAD" then
	this.dw_list_claims.setredraw(false)
	this.dw_list_claims.retrieve(astr_newdata.vessel_nr)
	this.dw_list_claims.event Clicked(0,0,astr_newdata.claim_nr, this.dw_list_claims.object)
	this.dw_list_claims.scrolltorow(astr_newdata.claim_nr)
	this.dw_list_claims.setredraw(true)
end if
end event

public function integer wf_show_hide_dw (string claim_type);/********************************************************************
	wf_show_hide_dw
	<DESC> 
	</DESC>
	<RETURN>	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>
		claim_type as string
	</ARGS>
	<USAGE> important variables - usually only used in Open-event scriptcode </USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		01/07/96		?     		LN    		First Version.
		19/08/14		CR3717		XSZ004		Remove script for show/hide "cb_broker" button
		18/02/16		CR4289		XSZ004		Remove Time field for HEA claim.
		27/09/16    CR4226      SSX014      Make the misc claim input configurable
	</HISTORY>
********************************************************************/
this.setredraw(false)

gb_base_claim.show()
dw_claim_base.show()
cb_office.show()
dw_list_claims.show()

choose case claim_type
	case "DEM", "DES"
		gb_freight_claim.hide()
		gb_freight_balance.hide()
		gb_dem_claim.show()
		gb_dem_rate.show()
		gb_dev_claim.hide()
		dw_freight_claim.hide()
		dw_add_lumpsums.hide()
		uo_frt_balance.hide()
		dw_hea_dev_claim.hide()
		dw_dem_des_claim.show()
		dw_dem_des_rates.show()
		cb_dem_des_new_rate.show()
		cb_dem_des_delete_rate.show()
		dw_claim_base. post setfocus()
		st_dem_count.show()
		st_dem_total.show()
		cb_scroll_prior_dem.show()
		cb_scroll_next_dem.show()
		cb_scroll_next.hide()
		cb_scroll_prior.hide()		
		st_afc_count.hide()
		st_afc_total.hide()
		dw_afc.hide()
		uo_afc.hide()
	case "FRT"
		gb_freight_claim.show()
		gb_freight_balance.show()
		gb_dem_claim.hide()
		gb_dem_rate.hide()
		gb_dev_claim.hide()
		cb_dem_des_new_rate.hide()
		cb_dem_des_delete_rate.hide()
		dw_hea_dev_claim.hide()
		dw_dem_des_claim.hide()
		dw_dem_des_rates.hide()
		dw_freight_claim.show()
		dw_add_lumpsums.show()
		uo_frt_balance.uf_set_empty()
		uo_frt_balance.show()
		dw_claim_base.setfocus()
		st_dem_count.hide()
		st_dem_total.hide()
		cb_scroll_prior_dem.hide()
		cb_scroll_next_dem.hide()
		cb_scroll_next.hide()
		cb_scroll_prior.hide()		
		st_afc_count.hide()
		st_afc_total.hide()
		dw_afc.hide()
		uo_afc.hide()
	case "AFCOLD"
		gb_freight_claim.show()
		gb_freight_balance.show()
		gb_dem_claim.hide()
		gb_dem_rate.hide()
		gb_dev_claim.hide()
		cb_dem_des_new_rate.hide()
		cb_dem_des_delete_rate.hide()
		dw_hea_dev_claim.hide()
		dw_dem_des_claim.hide()
		dw_dem_des_rates.hide()
		dw_freight_claim.hide()
		dw_add_lumpsums.hide()
		uo_frt_balance.hide()
		dw_claim_base.setfocus()
		cb_delete_afc_recieved.hide()
		cb_new_afc_recieved.hide()
		cb_afc_update_recieved.hide()
		dw_afc.show()
		dw_add_lumpsums_afc.hide()
		cb_scroll_next.show()
		cb_scroll_prior.show()		
		dw_afc_recieved.hide()
		st_afc_count.show()
		st_afc_total.show()
		uo_afc.uf_set_empty()
		uo_afc.show()
		cb_cancel.enabled = true
		dw_afc_recieved.setfilter("")
		dw_afc_recieved.filter()
		st_dem_count.hide()
		st_dem_total.hide()
		cb_scroll_prior_dem.hide()
		cb_scroll_next_dem.hide()
	case "AFC"
		gb_freight_claim.show()
		gb_freight_balance.show()
		gb_dem_claim.hide()
		gb_dem_rate.hide()
		gb_dev_claim.hide()
		cb_dem_des_new_rate.hide()
		cb_dem_des_delete_rate.hide()
		dw_hea_dev_claim.hide()
		dw_dem_des_claim.hide()
		dw_dem_des_rates.hide()
		dw_freight_claim.hide()
		dw_add_lumpsums.hide()
		dw_add_lumpsums_afc.hide()
		dw_afc_bol.show()
		uo_frt_balance.hide()
		uo_afc.hide()
		dw_claim_base.setfocus()
		st_dem_count.hide()
		st_dem_total.hide()
		cb_scroll_prior_dem.hide()
		cb_scroll_next_dem.hide()
	case else
		
		if il_lumpsum_visible = 1 and not (il_bunker_visible = 1 or il_time_visible = 1) then
			dw_hea_dev_claim.hide()
			gb_dev_claim.hide()
		else
			gb_dev_claim.show()
			dw_hea_dev_claim.show()
		end if
		
		gb_freight_claim.hide()
		gb_freight_balance.hide()
		gb_dem_claim.hide()
		gb_dem_rate.hide()
		
		cb_dem_des_new_rate.hide()
		cb_dem_des_delete_rate.hide()
		dw_dem_des_claim.hide()
		dw_dem_des_rates.hide()
		dw_freight_claim.hide()
		dw_add_lumpsums.hide()
		dw_add_lumpsums_afc.hide()
		uo_frt_balance.hide()
		
		dw_claim_base.setfocus()
		st_dem_count.hide()
		st_dem_total.hide()
		cb_scroll_prior_dem.hide()
		cb_scroll_next_dem.hide()
		cb_scroll_next.hide()
		cb_scroll_prior.hide()		
		st_afc_count.hide()
		st_afc_total.hide()
		dw_afc.hide()
		uo_afc.hide()
	
		wf_layout_misc_objects(claim_type)

end choose

this.setredraw(true)

return(0)
end function

public subroutine wf_enabled_buttons (string status);/********************************************************************
   wf_enabled_buttons
   <DESC> Controlling if buttons and datawindows are visible or enable </DESC>
   <RETURN> </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		status
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	19/06/2013 CR2877       WWA048    
   </HISTORY>
********************************************************************/

choose case status
	case "NEW"
		cb_new.enabled = false
		cb_delete.enabled = false
		cb_cancel.enabled = true
		uo_vesselselect.enabled = false
		dw_list_claims.enabled = false
		cb_print.enabled = false
	case "UPDATE"
		cb_new.enabled = true
		cb_delete.enabled = true
		cb_cancel.enabled = false		
		uo_vesselselect.enabled =  true
		dw_list_claims.enabled = true
		cb_print.enabled = true
		wf_afc_del_array()
	case "CANCEL"
		cb_new.enabled = true
		cb_cancel.enabled = false
		cb_update.enabled = false
		cb_print.enabled = true
		uo_vesselselect.enabled =  true
		dw_list_claims.enabled = true
		dw_list_claims.selectrow(0, false)
		dw_claim_base.reset()
		dw_dem_des_claim.hide()
		dw_dem_des_rates.hide()
		cb_dem_des_new_rate.hide()
		cb_dem_des_delete_rate.hide()
		dw_hea_dev_claim.reset()
		dw_hea_dev_claim.hide()
		dw_freight_claim.hide()
		dw_add_lumpsums.hide()
		dw_add_lumpsums_afc.hide()
		dw_freight_received.hide()
		cb_new_received.hide()
		cb_delete_received.hide()
		uo_frt_balance.hide()
		uo_afc.hide()
		dw_claim_base.hide()
		cb_office.hide()
		dw_afc_bol.reset()
		dw_afc_bol.hide()
		dw_afc.reset()
		dw_afc.hide()		
		dw_afc_recieved.reset()
		dw_afc_recieved.hide()
		cb_delete_afc_recieved.visible = false
		cb_new_afc_recieved.visible = false
		cb_afc_update_recieved.visible = false
		cb_scroll_next.hide()
		cb_scroll_prior.hide()
		st_afc_count.hide()
		st_afc_total.hide()
		dw_list_claims.show()
		uo_balance.of_setnull( )
		dw_claim_base.settaborder("claim_type", 0)
		dw_claim_base.modify("claim_type.background.mode = '1'")
	   dw_claim_base.modify("claim_type.background.color = '" + string(c#color.Transparent) + "'")
	   wf_afc_del_array()
		st_dem_count.hide()
		st_dem_total.hide()
		cb_scroll_prior_dem.hide()
		cb_scroll_next_dem.hide()
		cb_l_d_amount.hide()
		wf_dem_des_tabs(false)
		gb_base_claim.hide()
		gb_freight_claim.hide()
		gb_freight_balance.hide()
		gb_dem_claim.hide()
		gb_dem_rate.hide()
		gb_dev_claim.hide()
	case "DELETE"	
		w_claims.postevent("ue_retrieve")
		cb_cancel.enabled = false
		cb_update.enabled = false
		cb_delete.enabled = false
		cb_print.enabled = true
		dw_list_claims.enabled = true
		dw_list_claims.selectrow(0, false)
		dw_dem_des_claim.hide()
		dw_dem_des_rates.hide()
		cb_dem_des_new_rate.hide()
		cb_dem_des_delete_rate.hide()
		dw_freight_claim.hide()
		dw_add_lumpsums.hide()
		dw_add_lumpsums_afc.hide()
		dw_freight_received.hide()
		cb_new_received.hide()
		cb_delete_received.hide()
		dw_hea_dev_claim.hide()
		uo_frt_balance.hide()
		uo_afc.hide()
		dw_claim_base.hide()
		cb_office.hide()
		dw_claim_base.settaborder("claim_type", 0)
		dw_claim_base.modify("claim_type.background.mode = '1'")
	   dw_claim_base.modify("claim_type.background.color = '" + string(c#color.Transparent) + "'")
		dw_afc.hide()
		dw_afc_recieved.hide()
		dw_afc_bol.hide()
		cb_delete_afc_recieved.hide()
		cb_new_afc_recieved.hide()
		cb_afc_update_recieved.hide()
		cb_scroll_next.hide()
		cb_scroll_prior.hide()
		st_afc_count.hide()
		st_afc_total.hide()
		wf_afc_del_array()
		st_dem_count.hide()
		st_dem_total.hide()
		cb_scroll_prior_dem.hide()
		cb_scroll_next_dem.hide()
		cb_l_d_amount.hide()
		gb_base_claim.hide()
		gb_freight_claim.hide()
		gb_freight_balance.hide()
		gb_dem_claim.hide()
		gb_dem_rate.hide()
		gb_dev_claim.hide()
end choose

end subroutine

public function boolean wf_afc_new ();s_select_voyage_charterer lstr_parametre 
string ls_cp_text, ls_broker_sn, ls_office_sn
datetime ld_discharge_date, ld_notice_date, ld_timebar_date, ld_cp_date, ld_laycan_start, ld_laycan_end
integer li_notice_days, li_timebar_days, li_claim_nr, li_broker_nr, li_office_nr
decimal {3} bol_quantity
decimal {4} ld_broker_com,ld_address_com
decimal ls_exrate
string	ls_chart_sn, ls_chart_n_1, ls_chart_a_1, ls_chart_a_2, ls_chart_a_3, ls_chart_a_4, ls_chart_c

s_select_parm lstr_parm
lstr_parm.vessel_nr = ii_vessel_nr
lstr_parm.claim_type = "FRT"

OpenWithParm(w_select_voyage_charterer,lstr_parm)
lstr_parametre = message.PowerObjectParm
IF lstr_parametre.voyage_nr = "cancel" THEN Return FALSE
ib_calc_yes_no = lstr_parametre.calc_yes_no
	
IF ib_calc_yes_no THEN
	 wf_frt_with_calc(lstr_parametre)
	 Return FALSE
ELSE
/* Check if there i Created a  Freight Claim  */
/* for selected Charterer. (only one of these claims pr. charterer) */
cb_update.enabled = true

SELECT CLAIM_NR 
INTO :li_claim_nr
FROM CLAIMS
WHERE VESSEL_NR = :ii_vessel_nr
AND VOYAGE_NR = :lstr_parametre.voyage_nr
AND CHART_NR = :lstr_parametre.charter_nr
AND CLAIM_TYPE = "FRT"
USING SQLCA;

IF SQLCA.SQLCode <> 100 THEN
	MessageBox("Error","You can't create more than one Freight Claim for the same Charterer.")
	COMMIT USING SQLCA;
	Return FALSE
END IF

COMMIT USING SQLCA;

ii_vessel_nr = ii_vessel_nr
is_voyage_nr = lstr_parametre.voyage_nr
il_charter_nr = lstr_parametre.charter_nr

dw_list_claims.SelectRow(0,FALSE)
dw_claim_base.Reset()
dw_claim_base.InsertRow(0)
wf_enabled_buttons("NEW")
wf_show_hide_dw("AFC")

dw_claim_base.SetItem(1, "vessel_nr", ii_vessel_nr)
dw_claim_base.SetItem(1, "voyage_nr", lstr_parametre.voyage_nr)
dw_claim_base.SetItem(1, "chart_nr", lstr_parametre.charter_nr)
dw_claim_base.SetItem(1, "claim_type", "FRT")
dw_claim_base.setitem(1, "cal_cerp_id", lstr_parametre.cp_id)
dw_claim_base.setitem(1, "claim_responsible", uo_global.is_userid)

SELECT CHART_SN, 
       CHART_N_1, 
       ISNULL(RTRIM(LTRIM(CHART_A_1)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_2)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_3)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_4)), ''), 
       CHART_C
  INTO :ls_chart_sn, 
       :ls_chart_n_1, 
		 :ls_chart_a_1, 
		 :ls_chart_a_2, 
		 :ls_chart_a_3, 
		 :ls_chart_a_4, 
		 :ls_chart_c
  FROM CHART
 WHERE CHART_NR = :lstr_parametre.charter_nr;

dw_claim_base.setitem(1, "chart_chart_sn", ls_chart_sn)
dw_claim_base.setitem(1, "chart_chart_n_1", ls_chart_n_1)
dw_claim_base.setitem(1, "chart_chart_a_1", ls_chart_a_1)
dw_claim_base.setitem(1, "chart_chart_a_2", ls_chart_a_2)
dw_claim_base.setitem(1, "chart_chart_a_3", ls_chart_a_3)
dw_claim_base.setitem(1, "chart_chart_a_4", ls_chart_a_4)
dw_claim_base.setitem(1, "chart_chart_c", ls_chart_c)

SELECT dbo.FN_GET_POCDISCHARGEDATE(:ii_vessel_nr, :lstr_parametre.voyage_nr)
INTO :ld_discharge_date
FROM SYSTEM_OPTION
USING SQLCA;	

IF SQLCA.SQLCode = 100 THEN SetNull(ld_discharge_date)
COMMIT USING SQLCA;
dw_claim_base.SetItem(1,"discharge_date", date(ld_discharge_date))

SELECT CP_DATE, CP_TEXT, TIMEBAR_DAYS, TIMEBAR_DATE, NOTICE_DAYS, NOTICE_DATE, BROKER_NR, OFFICE_NR, LAYCAN_START, LAYCAN_END, BROKER_COM, ADDRESS_COM
	INTO :ld_cp_date, :ls_cp_text, :li_timebar_days, :ld_timebar_date, :li_notice_days, :ld_notice_date, :li_broker_nr, :li_office_nr, :ld_laycan_start, :ld_laycan_end, :ld_broker_com, :ld_address_com
	FROM CLAIMS
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :lstr_parametre.voyage_nr
	ORDER BY CLAIM_NR
	USING SQLCA;
 
IF SQLCA.SQLCode = 100 THEN 
	SetNull(ld_cp_date)
	SetNull(ld_timebar_date)
	SetNull(ld_notice_date)
	SetNull(li_timebar_days)
	SetNull(li_notice_days)
	SetNull(li_broker_nr)
	SetNull(li_office_nr)
	SetNull(ld_laycan_start)
	SetNull(ld_laycan_end)
	SetNull(ld_broker_com)
	SetNull(ld_address_com)
END IF
COMMIT USING SQLCA;
dw_claim_base.SetItem(1,"cp_date", date(ld_cp_date))
dw_claim_base.SetItem(1,"cp_text", ls_cp_text)
dw_claim_base.SetItem(1,"timebar_days", li_timebar_days)
dw_claim_base.SetItem(1,"timebar_date", date(ld_timebar_date))
dw_claim_base.SetItem(1,"notice_days", li_notice_days)
dw_claim_base.SetItem(1,"notice_date", date(ld_notice_date))
dw_claim_base.SetItem(1,"broker_nr", li_broker_nr)
dw_claim_base.SetItem(1,"claims_laycan_start", ld_laycan_start)
dw_claim_base.SetItem(1,"claims_laycan_end",  ld_laycan_end)
dw_claim_base.SetItem(1,"claims_broker_com", ld_broker_com)
dw_claim_base.SetItem(1,"claims_address_com",  ld_address_com)

IF NOT IsNull(li_broker_nr) THEN
	SELECT BROKER_SN
		INTO :ls_broker_sn
		FROM BROKERS
		WHERE BROKER_NR = :li_broker_nr
		USING SQLCA;
	COMMIT USING SQLCA;
	dw_claim_base.SetItem(1,"brokers_broker_sn", ls_broker_sn)
END IF
dw_claim_base.SetItem(1,"office_nr", li_office_nr)

IF NOT IsNull(li_office_nr) THEN
	SELECT OFFICE_SN
		INTO :ls_office_sn
		FROM OFFICES
		WHERE OFFICE_NR = :li_office_nr
	USING SQLCA;
	COMMIT USING SQLCA;
	dw_claim_base.SetItem(1,"offices_office_sn", ls_office_sn)
END IF

	SELECT SUM(BOL_QUANTITY)
		INTO :bol_quantity
		FROM BOL
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :lstr_parametre.voyage_nr
		AND CHART_NR = :lstr_parametre.charter_nr
		AND L_D = 1
		USING SQLCA;
	COMMIT USING SQLCA;
	IF IsNull(bol_quantity) THEN bol_quantity = 0 

RETURN TRUE
END IF
end function

public function integer wf_afc_validate_claim ();/********************************************************************
   wf_afc_validate_claim
   <DESC>	Validate AFC claims	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		01/12/17 CR4630        LHG008   Invalid characters in invoice text
   </HISTORY>
********************************************************************/

Integer li_rows,li_counter
string  ls_invoice_freetext

dw_claim_base.AcceptText()

/* Validating base datawindow */
IF Isnull(dw_claim_base.GetItemString(1,"claim_type")) THEN
	MessageBox("Error","You must choose a Claim Type!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

	
IF Isnull(dw_claim_base.GetItemDateTime(1,"cp_date")) THEN
	MessageBox("Error","You must specify a CP Date!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

IF Isnull(dw_claim_base.GetItemNumber(1,"timebar_days")) THEN
	MessageBox("Error","Timebar days not specified!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

IF IsNull(dw_claim_base.GetItemNumber(1,"broker_nr"))  THEN
		MessageBox("Error","You must select Broker! If none then select a dummy broker, for the reports.")
		dw_claim_base.SetFocus()
		Return(-1)
END IF

IF IsNull(dw_claim_base.GetItemNumber(1,"broker_nr")) AND &
	IsNull(dw_claim_base.GetItemNumber(1,"office_nr")) THEN
		MessageBox("Error","You must select Broker or Office!")
		dw_claim_base.SetFocus()
		Return(-1)
END IF

IF Isnull(dw_claim_base.GetItemString(1,"curr_code")) THEN
	MessageBox("Error","Currency code not specified!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

ls_invoice_freetext = dw_claim_base.getitemstring(1, "claims_ax_invoice_text")
if not isnull(ls_invoice_freetext) then
	if pos(ls_invoice_freetext, ";") > 0 or pos(ls_invoice_freetext, '；') > 0 &
	or pos(ls_invoice_freetext, '"') > 0 or pos(ls_invoice_freetext, '“') > 0 or pos(ls_invoice_freetext, '”') > 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_type_validation_error, "Semicolon and double quote are not allowed in the AX invoice text field.", this)
		dw_claim_base.setcolumn("claims_ax_invoice_text")
		dw_claim_base.setfocus()
		return(-1)
	end if
end if


dw_add_lumpsums_afc.Accepttext( )

dw_afc_recieved.AcceptText()
li_rows = dw_afc.RowCount()
FOR li_counter = 1 TO li_rows	
	dw_afc.AcceptText()	
		//
		// Check om der er angivet en rate 
		//
		IF Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws")) AND &
		    Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws_rate"))	 THEN
			IF IsNull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_per_mts")) THEN
				IF IsNull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_main_lumpsum")) THEN
					MessageBox("Error","You must enter~r~n WS and WS Rate~r~nor Per mt~r~n or Lumpsum on nr. " + String(li_counter))
					dw_afc.ScrollToRow(li_counter)
					st_afc_count.text = String(li_counter)
					dw_afc.SetFocus()
					Return(-1)
				END IF
			END IF
		END IF
		//
		// Check om der er angiver WS + WS rate 
		//
		IF Not  Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws")) AND &
		    Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws_rate"))	 THEN
				MessageBox("Error","You must enter both WS and WS Rate  on nr. " + String(li_counter))
				dw_afc.ScrollToRow(li_counter)
				st_afc_count.text = String(li_counter)
				dw_afc.SetFocus()
				Return(-1)
		END IF
		IF Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws")) AND &
		   NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws_rate"))	 THEN
				MessageBox("Error","You must enter both WS and WS Rate  on nr. " + String(li_counter))
				dw_afc.ScrollToRow(li_counter)
				st_afc_count.text = String(li_counter)
				dw_afc.SetFocus()
				Return(-1)
		END IF
		//
		// Check om der er angivet både WS og Per MT 
		//
		IF NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws")) OR &
		    NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_ws_rate"))	 THEN
			IF NOT IsNull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_per_mts")) THEN
				MessageBox("Error","You can't enter both WS and Per MT  on nr. " + String(li_counter))
				dw_afc.ScrollToRow(li_counter)
				st_afc_count.text = String(li_counter)
				dw_afc.SetFocus()
				Return(-1)
			END IF
		END IF
		//
		// Check om der er angivet min_1 and overage_1 
		//
		IF NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_min_1")) AND &
		    Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_overage_1"))	 THEN
			MessageBox("Error","You must fill in both MIN_1 and OVERAGE_1  on nr. " + String(li_counter))
			dw_afc.ScrollToRow(li_counter)
			st_afc_count.text = String(li_counter)
			dw_afc.SetFocus()
			Return(-1)
		END IF
		IF Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_min_1")) AND &
		    NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_overage_1"))	 THEN
			MessageBox("Error","You must fill in both MIN_1 and OVERAGE_1 on nr. " + String(li_counter))
			dw_afc.ScrollToRow(li_counter)
			dw_afc.SetFocus()
			Return(-1)
		END IF
		//
		// Check om der er angivet min_2 and overage_2 
		//
		IF NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_min_2")) AND &
		    Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_overage_2"))	 THEN
			MessageBox("Error","You must fill in both MIN_2 and OVERAGE_2  on nr. " + String(li_counter))
			dw_afc.ScrollToRow(li_counter)
			st_afc_count.text = String(li_counter)
			dw_afc.SetFocus()
			Return(-1)
		END IF
		IF Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_min_2")) AND &
		    NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_overage_2"))	 THEN
			MessageBox("Error","You must fill in both MIN_2 and OVERAGE_2  on nr. " + String(li_counter))
			dw_afc.ScrollToRow(li_counter)
			st_afc_count.text = String(li_counter)
			dw_afc.SetFocus()
			Return(-1)
		END IF
		//
		// Check om der er angivet min_2 and overage_2 uden at der er angivet min_1 and overage_1 
		//
		IF Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_min_1")) AND &
		    Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_overage_1")) AND &
		    (NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_min_2")) OR &
		      NOT Isnull(dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_overage_2")))	 THEN
			MessageBox("Error","You can't enter MIN_2 and OVERAGE_2 without entering MIN_1 and OVERAGE_1 on nr. " + String(li_counter))
			dw_afc.ScrollToRow(li_counter)
			st_afc_count.text = String(li_counter)
			dw_afc.SetFocus()
			Return(-1)
		END IF
NEXT	

Return(0)
end function

public subroutine wf_afc_scroll ();
dw_afc_recieved.Retrieve(dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_vessel_nr"), &
		                            dw_afc.GetItemString(dw_afc.GetRow(),"freight_advanced_voyage_nr"), &
					    dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_chart_nr"), &
					     dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_afc_nr"), &				   
				            dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_claim_nr"))
COMMIT USING SQLCA;

IF ibl_new THEN
	dw_add_lumpsums_afc.setfilter("afc_nr="+st_afc_count.Text)
	dw_add_lumpsums_afc.filter( )
ELSE
	dw_add_lumpsums_afc.Retrieve(dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_vessel_nr"), &
		                            dw_afc.GetItemString(dw_afc.GetRow(),"freight_advanced_voyage_nr"), &
					    dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_chart_nr"), &
					     dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_claim_nr"), &				   
				            dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_afc_nr"))
	COMMIT USING SQLCA;
END IF

 uo_afc.uf_calculate_balance(dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_vessel_nr"), &
		                      		 dw_afc.GetItemString(dw_afc.GetRow(),"freight_advanced_voyage_nr"), &
					         dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_chart_nr"), &					 		   
				                 dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_claim_nr"), &
 					         dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_afc_nr"))	
					   		
wf_afc_del_array()
end subroutine

public subroutine wf_afc_recieved_filter (integer row);		
dw_afc_recieved.SetFilter("afc_nr = "+String(row) )
dw_afc_recieved.Filter()
end subroutine

public subroutine wf_afc_update_freight_claims (integer charter, integer vessel, string voyage, integer claim, decimal quantity);INSERT INTO FREIGHT_CLAIMS (CHART_NR,VESSEL_NR,VOYAGE_NR,CLAIM_NR,BOL_LOAD_QUANTITY,LUMPSUM_COMMISSION)
	VALUES(:charter,:vessel,:voyage,:claim,:quantity,0);
	Commit;

end subroutine

public subroutine wf_afc_update_bol (integer chart, string voyage, integer vessel, integer claim, decimal bol);UPDATE FREIGHT_CLAIMS
SET BOL_LOAD_QUANTITY = bol
WHERE CHART_NR = :chart AND VOYAGE_NR = :voyage  AND VESSEL_NR = :vessel AND CLAIM_NR = :claim;
Commit;
end subroutine

public subroutine wf_dem_scroll ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : CLAIMS
  
 Object     : 
  
 Event	 :  
 Scope     : 

 ************************************************************************************

 Author    : Leith Noval
   
 Date       : {Creation date}

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
23/7-96             1.0                    LN           INITIAL
  
************************************************************************************/
Integer li_vessel, li_charter,li_row
String ls_voyage, ls_port,ls_purpose

/* Make filter for dem_des_rates, so dw_dem_des_rates shows data related to dw_dem_des_claim */

li_row = dw_dem_des_claim.GetRow()
li_vessel = dw_dem_des_claim.GetItemNumber(li_row,"vessel_nr")
ls_voyage = dw_dem_des_claim.GetItemString(li_row,"voyage_nr")
li_charter = dw_dem_des_claim.GetItemNumber(li_row,"chart_nr")		   
ls_port = dw_dem_des_claim.GetItemString(li_row,"port_code")
ls_purpose = dw_dem_des_claim.GetItemstring(li_row,"dem_des_purpose")


dw_dem_des_rates.SetFilter("vessel_nr = " + String(li_vessel) + " AND voyage_nr = '" +  ls_voyage + "' AND chart_nr = " + String(li_charter) + " AND port_code = '" +  ls_port + "'  AND dem_des_purpose = '" + ls_purpose + "'"  )
dw_dem_des_rates.Filter( )

/* Calculate part claim amount for the displayed port, if there is a laytime st. (settled = 1) and if the ib is TRUE */

IF ib_set_dem_part_amount AND dw_dem_des_claim.GetItemNumber(li_row,"dem_des_settled") = 1 THEN
	wf_part_amount(li_row)
END IF
end subroutine

public subroutine wf_dem_des_tabs (boolean open_close);
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  :  CLAIMS
  
 Object     : 
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    :  Leith Noval
   
 Date       : 

 Description : Sets the taborder for claim base fields to 0 if the parameter is FALSE, and to 10.... if TRUE.
		      FALSE means that there is automatic generated clacule data, so the user shall not be allowed to edit.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
 22/7-96                                   LN             Initial
************************************************************************************/

IF open_close THEN	
	dw_dem_des_claim.SetTabOrder("load_hourly_rate",10)
dw_dem_des_claim.Modify("load_hourly_rate.Background.Mode = '0'")
dw_dem_des_claim.Modify("load_hourly_rate.Background.Color = '16777215'")
	dw_dem_des_claim.SetTabOrder("load_daily_rate",30)
dw_dem_des_claim.Modify("load_daily_rate.Background.Mode = '0'")
dw_dem_des_claim.Modify("load_daily_rate.Background.Color = '16777215'")
	dw_dem_des_claim.SetTabOrder("load_laytime_allowed",50)
dw_dem_des_claim.Modify("load_laytime_allowed.Background.Mode = '0'")
dw_dem_des_claim.Modify("load_laytime_allowed.Background.Color = '16777215'")
	dw_dem_des_claim.SetTabOrder("disch_hourly_rate",20)
dw_dem_des_claim.Modify("disch_hourly_rate.Background.Mode = '0'")
dw_dem_des_claim.Modify("disch_hourly_rate.Background.Color = '16777215'")
	dw_dem_des_claim.SetTabOrder("disch_daily_rate",40)
dw_dem_des_claim.Modify("disch_daily_rate.Background.Mode = '0'")
dw_dem_des_claim.Modify("disch_daily_rate.Background.Color = '16777215'")
	dw_dem_des_claim.SetTabOrder("disch_laytime_allowed",60)
dw_dem_des_claim.Modify("disch_laytime_allowed.Background.Mode = '0'")
dw_dem_des_claim.Modify("disch_laytime_allowed.Background.Color = '31775128'")
	dw_dem_des_claim.SetTabOrder("terms_desc",70)
dw_dem_des_claim.Modify("terms_desc.Background.Mode = '0'")
dw_dem_des_claim.Modify("terms_desc.Background.Color = '16777215'")
	dw_dem_des_claim.SetTabOrder("com_on_dem",80)
dw_dem_des_claim.Modify("com_on_dem.Background.Mode = '0'")
dw_dem_des_claim.Modify("com_on_dem.Background.Color = '16777215'")
	dw_dem_des_rates.SetTabOrder("dem_rate_day",10)
dw_dem_des_rates.Modify("dem_rate_day.Background.Mode = '0'")
dw_dem_des_rates.Modify("dem_rate_day.Background.Color = '31775128'")
	dw_dem_des_rates.SetTabOrder("des_rate_day",20)
dw_dem_des_rates.Modify("des_rate_day.Background.Mode = '0'")
dw_dem_des_rates.Modify("des_rate_day.Background.Color = '31775128'")
	dw_dem_des_rates.SetTabOrder("rate_hours",30)
dw_dem_des_rates.Modify("rate_hours.Background.Mode = '0'")
dw_dem_des_rates.Modify("rate_hours.Background.Color = '31775128'")
	cb_dem_des_new_rate.Enabled = TRUE
	cb_dem_des_delete_rate.Enabled = TRUE 

ELSE
	dw_dem_des_claim.SetTabOrder("load_hourly_rate",0)
dw_dem_des_claim.Modify("load_hourly_rate.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("load_daily_rate",0)
dw_dem_des_claim.Modify("load_daily_rate.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("load_laytime_allowed",0)
dw_dem_des_claim.Modify("load_laytime_allowed.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("disch_hourly_rate",0)
dw_dem_des_claim.Modify("disch_hourly_rate.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("disch_daily_rate",0)
dw_dem_des_claim.Modify("disch_daily_rate.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("disch_laytime_allowed",0)
dw_dem_des_claim.Modify("disch_laytime_allowed.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("terms_desc",0)
dw_dem_des_claim.Modify("terms_desc.Background.Mode = '1'")
	dw_dem_des_claim.SetTabOrder("com_on_dem",0)
dw_dem_des_claim.Modify("com_on_dem.Background.Mode = '1'")
	dw_dem_des_rates.SetTabOrder("dem_rate_day",0)
dw_dem_des_rates.Modify("dem_rate_day.Background.Mode = '1'")
	dw_dem_des_rates.SetTabOrder("des_rate_day",0)
dw_dem_des_rates.Modify("des_rate_day.Background.Mode = '1'")
	dw_dem_des_rates.SetTabOrder("rate_hours",0)
dw_dem_des_rates.Modify("rate_hours.Background.Mode = '1'")
	cb_dem_des_new_rate.Enabled = FALSE
	cb_dem_des_delete_rate.Enabled = FALSE
END IF
end subroutine

public subroutine wf_frt_tabs (boolean open_close);IF open_close THEN
	dw_freight_claim.SetTabOrder("freight_ws",10)
 dw_freight_claim.Modify("freight_ws.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_ws.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_ws_rate",20)
 dw_freight_claim.Modify("freight_ws_rate.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_ws_rate.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_per_mts",30)
 dw_freight_claim.Modify("freight_per_mts.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_per_mts.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_main_lumpsum",35)
 dw_freight_claim.Modify("freight_main_lumpsum.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_main_lumpsum.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_min_1",60)
 dw_freight_claim.Modify("freight_min_1.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_min_1.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_min_2",70)
 dw_freight_claim.Modify("freight_min_2.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_min_2.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_overage_1",80)
 dw_freight_claim.Modify("freight_overage_1.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_overage_1.Background.Color = '16777215'")
	dw_freight_claim.SetTabOrder("freight_overage_2",90)
 dw_freight_claim.Modify("freight_overage_2.Background.Mode = '0'")
 dw_freight_claim.Modify("freight_overage_2.Background.Color = '16777215'")
wf_claim_base_tabs(TRUE)
ELSE
	dw_freight_claim.SetTabOrder("freight_ws",0)
dw_freight_claim.Modify("freight_ws.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_ws_rate",0)
 dw_freight_claim.Modify("freight_ws_rate.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_per_mts",0)
 dw_freight_claim.Modify("freight_per_mts.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_main_lumpsum",0)
 dw_freight_claim.Modify("freight_main_lumpsum.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_min_1",0)
 dw_freight_claim.Modify("freight_min_1.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_min_2",0)
 dw_freight_claim.Modify("freight_min_2.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_overage_1",0)
 dw_freight_claim.Modify("freight_overage_1.Background.Mode = '1'")
	dw_freight_claim.SetTabOrder("freight_overage_2",0)
 dw_freight_claim.Modify("freight_overage_2.Background.Mode = '1'")
wf_claim_base_tabs(FALSE)
END IF
end subroutine

public subroutine wf_afc_tabs (boolean open_close);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : 
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : 
   
 Date       : 

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  1/7-96					LN
************************************************************************************/


IF open_close THEN
	dw_afc.SetTabOrder("freight_advanced_afc_ws",10)
 dw_afc.Modify("freight_advanced_afc_ws.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_ws.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_ws_rate",20)
 dw_afc.Modify("freight_advanced_afc_ws_rate.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_ws_rate.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_per_mts",30)
 dw_afc.Modify("freight_advanced_afc_per_mts.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_per_mts.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_main_lumpsum",35)
 dw_afc.Modify("freight_advanced_afc_main_lumpsum.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_main_lumpsum.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_min_1",70)
 dw_afc.Modify("freight_advanced_afc_min_1.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_min_1.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_min_2",90)
 dw_afc.Modify("freight_advanced_afc_min_2.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_min_2.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_overage_1",80)
 dw_afc.Modify("freight_advanced_afc_overage_1.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_overage_1.Background.Color = '16777215'")
	dw_afc.SetTabOrder("freight_advanced_afc_overage_2",100)
 dw_afc.Modify("freight_advanced_afc_overage_2.Background.Mode = '0'")
 dw_afc.Modify("freight_advanced_afc_overage_2.Background.Color = '16777215'")
wf_claim_base_tabs(TRUE)
ELSE
	dw_afc.SetTabOrder("freight_advanced_afc_ws",0)
 dw_afc.Modify("freight_advanced_afc_ws.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_ws_rate",0)
 dw_afc.Modify("freight_advanced_afc_ws_rate.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_per_mts",0)
 dw_afc.Modify("freight_advanced_afc_per_mts.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_main_lumpsum",0)
 dw_afc.Modify("freight_advanced_afc_main_lumpsum.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_min_1",0)
 dw_afc.Modify("freight_advanced_afc_min_1.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_min_2",0)
 dw_afc.Modify("freight_advanced_afc_min_2.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_overage_1",0)
 dw_afc.Modify("freight_advanced_afc_overage_1.Background.Mode = '1'")
	dw_afc.SetTabOrder("freight_advanced_afc_overage_2",0)
 dw_afc.Modify("freight_advanced_afc_overage_2.Background.Mode = '1'")
wf_claim_base_tabs(FALSE)
END IF
end subroutine

public subroutine wf_afc_new_bol (integer vessel, string voyage, integer charter);String ls_grade,  ls_port, ls_layout
Integer li_bolnr, li_agent, li_pcn,li_counter,li_rows,li_new_row
Decimal {4}  ld_quantity
Boolean lb_found = FALSE

li_rows = dw_afc.RowCount()

 DECLARE bol_cursor CURSOR FOR  
  SELECT BOL.GRADE_NAME,   
         BOL.AGENT_NR,   
         BOL.PORT_CODE,   
         BOL.PCN,   
         BOL.LAYOUT,   
         BOL.BOL_NR,   
         BOL.BOL_QUANTITY  
    FROM BOL  
   WHERE ( BOL.VESSEL_NR = :vessel ) AND  
         ( BOL.VOYAGE_NR = :voyage ) AND  
         ( BOL.CHART_NR = :charter ) AND  
         ( BOL.L_D = 1 )   ;

OPEN bol_cursor;

FETCH bol_cursor INTO :ls_grade, :li_agent, :ls_port, :li_pcn, :ls_layout, :li_bolnr, :ld_quantity;

DO WHILE SQLCA.SQLCode = 0 
lb_found = FALSE	
	FOR li_counter = 1 TO li_rows
                   IF li_agent = dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_agent_nr") THEN
                    IF ls_port = dw_afc.GetItemString(li_counter,"freight_advanced_afc_port_code") THEN
		     IF li_pcn = dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_pcn") THEN
                      IF li_bolnr = dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_bol_nr") THEN
		       IF ls_layout = dw_afc.GetItemString(li_counter,"freight_advanced_afc_layout") THEN
		        IF ls_grade = dw_afc.GetItemString(li_counter,"freight_advanced_afc_grade_name") THEN
				lb_found = TRUE
			END IF
		       END IF
	              END IF
		     END IF
		    END IF
		   END IF
	NEXT
	IF lb_found = FALSE THEN	
		li_new_row = dw_afc.InsertRow(0)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_nr",li_new_row)
		dw_afc.SetItem(li_new_row,"freight_advanced_claim_nr",dw_afc.GetItemNumber(1,"freight_advanced_claim_nr"))
		dw_afc.SetItem(li_new_row,"freight_advanced_vessel_nr",vessel)
		dw_afc.SetItem(li_new_row,"freight_advanced_voyage_nr",voyage)
		dw_afc.SetItem(li_new_row,"freight_advanced_chart_nr",charter)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_agent_nr",li_agent)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_port_code",ls_port)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_pcn",li_pcn)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_bol_nr",li_bolnr)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_layout",ls_layout)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_grade_name",ls_grade)
		dw_afc.SetItem(li_new_row,"freight_advanced_afc_bol_quantity",ld_quantity)
	END IF

FETCH bol_cursor INTO :ls_grade, :li_agent, :ls_port, :li_pcn, :ls_layout, :li_bolnr, :ld_quantity;

LOOP

CLOSE bol_cursor;
		
li_counter = 1
DO WHILE li_counter <= li_rows
	dw_afc.ScrollToRow(li_counter)		      		     
	 ls_grade = dw_afc.GetItemString(li_counter,"freight_advanced_afc_grade_name")
	 li_agent =  dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_agent_nr")
	 ls_port = dw_afc.GetItemString(li_counter,"freight_advanced_afc_port_code")
	 li_pcn =  dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_pcn")
	 ls_layout = dw_afc.GetItemString(li_counter,"freight_advanced_afc_layout")
         li_bolnr = dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_bol_nr")

	SELECT BOL_QUANTITY
	INTO :ld_quantity 
	FROM BOL
	WHERE  (BOL.GRADE_NAME = :ls_grade) AND  
    	     (BOL.AGENT_NR = :li_agent ) AND
    	     (BOL.PORT_CODE = :ls_port) AND
       	     (BOL.PCN  = :li_pcn ) AND 
    	     (BOL.LAYOUT =  :ls_layout ) AND   
    	     (BOL.BOL_NR = :li_bolnr) AND
	     (BOL.VESSEL_NR = :vessel)  AND  
    	     (BOL.VOYAGE_NR = :voyage)  AND  
    	     (BOL.CHART_NR = :charter)  AND  
   	     (BOL.L_D = 1) ;

	IF SQLCA.SQLCode = 100 THEN
		IF MessageBox("No Match","The corresponding BOL does not exists in cargo anymore. ~r~n Do you want to delete it from this AFC ?",Exclamation!,YesNo!) = 1 THEN
						dw_afc.DeleteRow(li_counter)
						li_rows --
						li_counter --
						MessageBox("Deleted","The bol in AFC is deleted. Remember to UPDATE !")
		END IF	
	ELSEIF SQLCA.SQLCode = 0 AND  ld_quantity <>  dw_afc.GetItemDecimal(li_counter,"freight_advanced_afc_bol_quantity") THEN
			IF MessageBox("Bol Quantity","The corresponding BOL quantity is changed in cargo. ~r~n Do you want to change this AFC accordingly?",Exclamation!,YesNo!) = 1 THEN
						dw_afc.SetItem(li_counter,"freight_advanced_afc_bol_quantity",ld_quantity)
						MessageBox("Changed","The bol quantity in AFC is changed. Remember to UPDATE !")
							IF dw_claim_base.GetItemNumber(1,"claims_claim_in_log") = 1 THEN
								MessageBox("IMPORTANT WARNING","If updated the claim amount will change (bol quantity), but &
								the claim has been transferred to CMS prior to this. Please adjust (NOW, if updating) &
								manually in CMS, or if in RRIS make adjustment there.") 
							END IF
			END IF
	ELSEIF SQLCA.SQLCode = -1 THEN
		MessageBox("Error","There has been an error in quantity search. Please inform program manager."+ SQLCA.SQLErrText)
	END IF
	COMMIT USING SQLCA;
li_counter ++
LOOP

dw_afc.ScrollToRow(1)		
li_rows  = dw_afc.RowCount()
st_afc_count.Text = "1"
st_afc_total.Text = "of " + String(li_rows)    
dw_afc_recieved.Retrieve(vessel, voyage, charter,dw_afc.GetItemNumber(1,"freight_advanced_afc_nr"),dw_afc.GetItemNumber(1,"freight_advanced_claim_nr"))
COMMIT USING SQLCA;
end subroutine

public subroutine wf_part_amount (integer row);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : 
  
 Event	 :  {Open}

 Scope     : {Global/Local}

 ************************************************************************************

 Author    : {Your name}
   
 Date       : {Creation date}

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/7 -96					LN
11/12-96					RM		added COMMIT's  
************************************************************************************/

Integer li_vessel_nr, li_chart_nr, li_claim_nr,li_pc_nr
String ls_voyage_nr, ls_purpose, ls_port
s_calc_claim lstr_parm
uo_calc_dem_des_claims uo_calc_dem 
long ll_calcaioid

uo_calc_dem = CREATE uo_calc_dem_des_claims

ll_calcaioid = dw_dem_des_claim.GetItemNumber(row,"calcaioid")
li_vessel_nr = dw_dem_des_claim.GetItemNumber(row,"vessel_nr")
ls_voyage_nr = dw_dem_des_claim.GetItemString(row,"voyage_nr")
li_chart_nr = dw_dem_des_claim.GetItemNumber(row,"chart_nr")
li_claim_nr = dw_dem_des_claim.GetItemNumber(row,"claim_nr")
ls_port = dw_dem_des_claim.GetItemString(row,"port_code")
ls_purpose = dw_dem_des_claim.GetItemString(row,"dem_des_purpose")
ls_purpose = left(ls_purpose,1)

SELECT PC_NR
INTO :li_pc_nr
FROM VESSELS
WHERE VESSEL_NR = :li_vessel_nr
USING SQLCA;
COMMIT USING SQLCA;

IF (li_pc_nr = 3 OR li_pc_nr = 5) THEN
	lstr_parm = uo_calc_dem.uf_bulk_port_claim_amount(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr,ls_port,ls_purpose,ll_calcaioid)
ELSE
	lstr_parm = uo_calc_dem.uf_tank_port_claim_amount(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr,ls_port,ls_purpose,ll_calcaioid)		
	IF lstr_parm.claim_amount < 0 THEN lstr_parm.claim_amount = 0
END IF	
DESTROY uo_calc_dem

dw_dem_des_claim.SetItem(row,"part_amount",lstr_parm.claim_amount)
dw_dem_des_claim.SetItemStatus(row,"part_amount",PRIMARY!,NotModified!)
end subroutine

public subroutine wf_set_pcn_order (ref s_pcn_order lstr[], integer vessel, string voyage);String ls_port,ls_purpose
Integer li_counter = 1,li_pcn,li_agent
Datetime ldt_dato

 DECLARE poc_cur CURSOR FOR  
  SELECT POC.PCN,   
         POC.PORT_ARR_DT,   
         POC.PORT_CODE,   
         POC.PURPOSE_CODE,
	 POC.AGENT_NR  
    FROM POC  
   WHERE ( POC.VESSEL_NR = :vessel ) AND  
         ( POC.VOYAGE_NR = :voyage ) AND  
         (( POC.PURPOSE_CODE = "L" ) OR  
         ( POC.PURPOSE_CODE = "D" ) OR  
         ( POC.PURPOSE_CODE = "L/D" ))   
ORDER BY POC.PORT_ARR_DT ASC  ;

OPEN poc_cur;
FETCH poc_cur INTO :li_pcn, :ldt_dato, :ls_port, :ls_purpose,:li_agent;

DO WHILE SQLCA.SQLCode = 0
	lstr[li_counter].port = ls_port
	lstr[li_counter].pcn = li_pcn
	lstr[li_counter].purpose = ls_purpose
	lstr[li_counter].dato = ldt_dato
	lstr[li_counter].agent = li_agent
	li_counter++
	FETCH poc_cur INTO :li_pcn, :ldt_dato, :ls_port, :ls_purpose,:li_agent;
LOOP
CLOSE poc_cur;
COMMIT USING SQLCA;
end subroutine

public subroutine wf_set_allowed (integer row);decimal {3} ld_bol_quantity, ld_daily_rate, ld_hourly_rate
decimal {4} ld_laytime, ld_day

ld_hourly_rate = dw_dem_des_claim.GetItemNumber(row,"load_hourly_rate")
IF ld_hourly_rate > 0 THEN 
	ld_day = 	 ld_hourly_rate * 24		
	dw_dem_des_claim.SetItem(row,"load_daily_rate",ld_day)
END IF			
ld_daily_rate = dw_dem_des_claim.GetItemNumber(row,"load_daily_rate")
ld_bol_quantity = dw_dem_des_claim.GetItemNumber(row,"bol_load_quantity")
IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
IF ld_daily_rate > 0 THEN ld_laytime = (ld_bol_quantity / ld_daily_rate)*24			
IF ld_laytime > 0 THEN dw_dem_des_claim.SetItem(row,"load_laytime_allowed",ld_laytime)
	
ld_hourly_rate = dw_dem_des_claim.GetItemNumber(row,"disch_hourly_rate")
IF ld_hourly_rate > 0 THEN 
	ld_day = 	 ld_hourly_rate * 24		
	dw_dem_des_claim.SetItem(row,"disch_daily_rate",ld_day)	
END IF
ld_daily_rate = dw_dem_des_claim.GetItemNumber(row,"disch_daily_rate")
ld_bol_quantity = dw_dem_des_claim.GetItemNumber(row,"bol_load_quantity")
IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
IF ld_daily_rate > 0 THEN ld_laytime = (ld_bol_quantity / ld_daily_rate)*24		
IF ld_laytime > 0 THEN dw_dem_des_claim.SetItem(row,"disch_laytime_allowed",ld_laytime)

end subroutine

public subroutine wf_protect_receivable ();// This function is used to protect entering of freight receivable if user is
// authorized. If authorized the system will function as always.
// Created by: FR 15-08-02

string ls_userid
integer li_access

  SELECT USERS.ENTER_FRT_REC  
  INTO :li_access  
  FROM USERS  
  WHERE USERS.USERID = :uo_global.is_userid;
  COMMIT USING SQLCA;
	
if (li_access = 0) then
	dw_freight_received.enabled = false
	cb_new_received.enabled = false
	cb_delete_received.enabled = false
end if
	




// uo_global.is_userid
end subroutine

public function integer wf_validate_claims ();/********************************************************************
   wf_validate_claims
   <DESC>	Validate claims	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		01/12/17 CR4630        LHG008   Invalid characters in invoice text
   </HISTORY>
********************************************************************/

Integer 	li_counter, li_dem_rows
long		ll_row, ll_rows
date 		ldt_receivedate
string   ls_invoice_freetext
string   ls_claim_type

ls_claim_type = dw_claim_base.GetItemString(1,"claim_type")

dw_claim_base.AcceptText()

/* Validating base datawindow */
IF Isnull(ls_claim_type) THEN
	MessageBox("Error","You must choose a Claim Type!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

IF Isnull(dw_claim_base.GetItemDateTime(1,"cp_date")) THEN
	MessageBox("Error","You must specify a CP Date!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

IF Isnull(dw_claim_base.GetItemNumber(1,"timebar_days")) THEN
	MessageBox("Error","Timebar days not specified!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

/* implemented 1. december 2003. Manadatory to enter office */
IF	cb_office.Visible = TRUE THEN
	if IsNull(dw_claim_base.GetItemNumber(1,"office_nr")) THEN
		MessageBox("Error","You must select Office!")
		dw_claim_base.SetFocus()
		Return(-1)
	end if
END IF

IF IsNull(dw_claim_base.GetItemNumber(1,"broker_nr")) AND &
	IsNull(dw_claim_base.GetItemNumber(1,"office_nr")) THEN
		MessageBox("Error","You must select Broker or Office!")
		dw_claim_base.SetFocus()
		Return(-1)
END IF

IF Isnull(dw_claim_base.GetItemString(1,"curr_code")) THEN
	MessageBox("Error","Currency code not specified!")
	dw_claim_base.SetFocus()
	Return(-1)
END IF

ls_invoice_freetext = dw_claim_base.getitemstring(1, "claims_ax_invoice_text")
if not isnull(ls_invoice_freetext) then
	if pos(ls_invoice_freetext, ";") > 0 or pos(ls_invoice_freetext, '；') > 0 &
	or pos(ls_invoice_freetext, '"') > 0 or pos(ls_invoice_freetext, '“') > 0 or pos(ls_invoice_freetext, '”') > 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_type_validation_error, "Semicolon and double quote are not allowed in the AX invoice text field.", this)
		dw_claim_base.setcolumn("claims_ax_invoice_text")
		dw_claim_base.setfocus()
		return(-1)
	end if
end if

CHOOSE CASE ls_claim_type
	CASE "DEM", "DES"
		dw_dem_des_claim.AcceptText()
		dw_dem_des_rates.AcceptText()
		
		li_dem_rows = dw_dem_des_claim.RowCount()
		FOR li_counter = 1 TO li_dem_rows
		  IF dw_dem_des_claim.GetItemNumber(li_counter,"dem_des_settled") = 1 THEN
			IF LEFT(dw_dem_des_claim.GetItemString(li_counter,"dem_des_purpose"),1) = "L" THEN
				IF Isnull(dw_dem_des_claim.GetItemNumber(li_counter,"load_laytime_allowed")) THEN
					MessageBox("Error","Load laytime Allowed not specified in number " + String(li_counter)+ " !")
					dw_claim_base.SetFocus()
					Return(-1)
				END IF
			ELSEIF  LEFT(dw_dem_des_claim.GetItemString(li_counter,"dem_des_purpose"),1) = "D" THEN
				IF Isnull(dw_dem_des_claim.GetItemNumber(li_counter,"disch_laytime_allowed")) THEN
					MessageBox("Error","Disch laytime Allowed not specified in number " + String(li_counter)+ " !")
					dw_claim_base.SetFocus()
					Return(-1)
				END IF
			ELSE
				IF Isnull(dw_dem_des_claim.GetItemNumber(li_counter,"disch_laytime_allowed")) THEN
					MessageBox("Error","Laytime Allowed not specified in number " + String(li_counter) + " !")
					dw_claim_base.SetFocus()
					Return(-1)
				END IF
			END IF
		   END IF
		NEXT

		IF dw_dem_des_rates.GetItemNumber(dw_dem_des_rates.RowCount(),"rate_hours") <> 0 THEN
			MessageBox("Error","Latest Demurrage / Despatch hours must be 0!")
			dw_dem_des_rates.SetFocus()
			Return(-1)
		END IF
	CASE "FRT"
		dw_freight_claim.AcceptText()
		dw_freight_received.AcceptText()
		//
		// Check om der er angivet en rate 
		//
		IF Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws")) AND &
		    Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws_rate"))	 THEN
			IF IsNull(dw_freight_claim.GetItemNumber(1,"freight_per_mts")) THEN
				IF IsNull(dw_freight_claim.GetItemNumber(1,"freight_main_lumpsum")) THEN
					MessageBox("Error","You must enter~r~n WS and WS Rate~r~nor Per mt~r~n or Lumpsum")
					dw_freight_claim.SetFocus()
					Return(-1)
				END IF
			END IF
		END IF
		//
		// Check om der er angiver WS + WS rate 
		//
		IF Not  Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws")) AND &
		    Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws_rate"))	 THEN
				MessageBox("Error","You must enter both WS and WS Rate")
				dw_freight_claim.SetFocus()
				Return(-1)
		END IF
		IF Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws")) AND &
		   NOT Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws_rate"))	 THEN
				MessageBox("Error","You must enter both WS and WS Rate")
				dw_freight_claim.SetFocus()
				Return(-1)
		END IF
		//
		// Check om der er angivet både WS og Per MT 
		//
		IF NOT Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws")) OR &
		    NOT Isnull(dw_freight_claim.GetItemNumber(1,"freight_ws_rate"))	 THEN
			IF NOT IsNull(dw_freight_claim.GetItemNumber(1,"freight_per_mts")) THEN
				MessageBox("Error","You can't enter both WS and Per MT")
				dw_freight_claim.SetFocus()
				Return(-1)
			END IF
		END IF
		
		/* freight received */
		ll_rows = dw_freight_received.rowCount()
		for ll_row = 1 to ll_rows
			if isNull(dw_freight_received.getItemNumber(ll_row, "freight_received_local_curr")) &
			or isNull(dw_freight_received.getItemDatetime(ll_row, "freight_rec_date")) &
			or isNull(dw_freight_received.getItemString(ll_row, "trans_code")) then
				messagebox("Validation Error", "You must enter all four values in freight received")
				dw_freight_received.post setRow(ll_row)
				dw_freight_received.post SetFocus()
				Return(-1)
			end if

			/* Validate the Received date */
			choose case dw_freight_received.getitemstatus( ll_row, "freight_rec_date", primary!)
				case NewModified!, DataModified!
					ldt_receivedate = date(dw_freight_received.getItemDatetime(ll_row, "freight_rec_date"))
					if ldt_receivedate < relativeDate( today(), -10) &
					or ldt_receivedate > relativeDate( today(), 10) then
						MessageBox("Information", "The freight received date entered in row# "+string(ll_row) +" is more than +/- 10 days from today.~r~n~r~nIn case this is correct, ignore this message, otherwise please correct the date an press update again.")
					end if
			end choose
		next	

	CASE ELSE
		return wf_validate_misc()
END CHOOSE

Return(0)
end function

public function integer wf_frt_with_calc (s_select_voyage_charterer lstr_calc_data);s_claim_base_data lstr_claim_base_data
s_frt_data lstr_frt_data[25]
Integer li_nr_of_dataset, li_broker_nr, li_office_nr, li_claim_nr, li_counter, li_array_counter, li_add_lump, li_row
u_calc_nvo uo_calc_nvo
String ls_broker_sn, ls_office_sn
Datetime ld_discharge_date
decimal {3} bol_quantity
long ll_calcaioid, ll_cargoid
decimal ls_exrate
string	ls_chart_sn, ls_chart_n_1, ls_chart_a_1, ls_chart_a_2, ls_chart_a_3, ls_chart_a_4, ls_chart_c

uo_calc_nvo = CREATE u_calc_nvo

SELECT CLAIM_NR 
INTO :li_claim_nr
FROM CLAIMS
WHERE VESSEL_NR = :ii_vessel_nr
AND VOYAGE_NR = :lstr_calc_data.voyage_nr
AND CHART_NR = :lstr_calc_data.charter_nr
AND CLAIM_TYPE = "FRT"
USING SQLCA;

IF SQLCA.SQLCode <> 100 THEN
	MessageBox("Error","You can't create more than one freight-Claim for the same Charterer.~r~n~r~nSelect another Charterer!")
	DESTROY uo_calc_nvo 
	COMMIT USING SQLCA;
	Return(0)
END IF

SELECT CLAIM_NR
INTO :li_claim_nr
FROM CLAIMS
WHERE VESSEL_NR = :ii_vessel_nr
AND VOYAGE_NR = :lstr_calc_data.voyage_nr
AND CHART_NR = :lstr_calc_data.charter_nr
COMMIT;
li_claim_nr = li_claim_nr + 1

IF NOT uo_calc_nvo.uf_claim_base_data(ii_vessel_nr,lstr_calc_data.voyage_nr,lstr_calc_data.charter_nr,lstr_calc_data.cp_id,lstr_claim_base_data ) THEN
      	MessageBox("Error Claim base","The selected combination of cp nr, with vessel, voyage, charter ~r~n is not found in the calcule system !")
      	DESTROY uo_calc_nvo 
	COMMIT USING SQLCA;
      	Return (0)
END IF

li_nr_of_dataset = uo_calc_nvo.uf_frt_data(ii_vessel_nr,lstr_calc_data.voyage_nr,lstr_calc_data.charter_nr,lstr_calc_data.cp_id,lstr_frt_data )

IF li_nr_of_dataset = 0 THEN
      	MessageBox("Error Frt Data","The selected combination of cp nr, with vessel, voyage, charter ~r~n is not found in the calcule system !")
      	DESTROY uo_calc_nvo 
	COMMIT USING SQLCA;
      	Return (0)
ELSEIF  li_nr_of_dataset > 0 THEN
	/* set claim base data */
	
	dw_list_claims.SelectRow(0,FALSE)

	dw_claim_base.Reset()
	dw_claim_base.InsertRow(0)
	if lstr_claim_base_data.fixed_exrate_enabled = 1 then
		dw_claim_base.SetItem(1,"curr_code",lstr_claim_base_data.claim_curr)
		id_fixed_exrate = lstr_claim_base_data.fixed_exrate
	else
		dw_claim_base.SetItem(1,"curr_code",lstr_claim_base_data.frt_curr_code)
		id_fixed_exrate = 0
	end if
	
	if lstr_claim_base_data.set_ex_rate and &
		lstr_claim_base_data.frt_curr_code <> 'USD' then
		st_setexrate.visible = true
	else
		st_setexrate.visible = false
	end if

	dw_claim_base.SetItem(1, "vessel_nr", ii_vessel_nr)
	dw_claim_base.SetItem(1, "voyage_nr", lstr_calc_data.voyage_nr)
	dw_claim_base.SetItem(1, "chart_nr", lstr_calc_data.charter_nr)
	dw_claim_base.SetItem(1, "claim_type", "FRT")
	dw_claim_base.setitem(1, "cal_cerp_id", lstr_calc_data.cp_id)
	dw_claim_base.setitem(1, "claim_responsible", uo_global.is_userid)

	wf_enabled_buttons("NEW")

SELECT CHART_SN, 
       CHART_N_1, 
       ISNULL(RTRIM(LTRIM(CHART_A_1)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_2)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_3)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_4)), ''), 
       CHART_C
  INTO :ls_chart_sn, 
       :ls_chart_n_1, 
		 :ls_chart_a_1, 
		 :ls_chart_a_2, 
		 :ls_chart_a_3, 
		 :ls_chart_a_4, 
		 :ls_chart_c
  FROM CHART
 WHERE CHART_NR = :lstr_calc_data.charter_nr;

dw_claim_base.setitem(1, "chart_chart_sn", ls_chart_sn)
dw_claim_base.setitem(1, "chart_chart_n_1", ls_chart_n_1)
dw_claim_base.setitem(1, "chart_chart_a_1", ls_chart_a_1)
dw_claim_base.setitem(1, "chart_chart_a_2", ls_chart_a_2)
dw_claim_base.setitem(1, "chart_chart_a_3", ls_chart_a_3)
dw_claim_base.setitem(1, "chart_chart_a_4", ls_chart_a_4)
dw_claim_base.setitem(1, "chart_chart_c", ls_chart_c)

	SELECT dbo.FN_GET_POCDISCHARGEDATE(:ii_vessel_nr, :lstr_calc_data.voyage_nr)
	INTO :ld_discharge_date
	FROM SYSTEM_OPTION
	USING SQLCA;

	IF SQLCA.SQLCode = 100 THEN SetNull(ld_discharge_date)
	COMMIT USING SQLCA;
	dw_claim_base.SetItem(1,"discharge_date", date(ld_discharge_date))

	li_broker_nr = lstr_claim_base_data.broker_nr
	SELECT BROKER_SN
	INTO :ls_broker_sn
	FROM BROKERS
	WHERE BROKER_NR = :li_broker_nr
	USING SQLCA;
	COMMIT USING SQLCA;	
	dw_claim_base.SetItem(1,"cp_date", lstr_claim_base_data.cp_date)
	dw_claim_base.SetItem(1,"cp_text", lstr_claim_base_data.cp_text)
	dw_claim_base.SetItem(1,"timebar_days",  lstr_claim_base_data.timebar_days)
	dw_claim_base.SetItem(1,"notice_days",  lstr_claim_base_data.noticebar_days)
	dw_claim_base.SetItem(1,"claims_laycan_start",  lstr_claim_base_data.laycan_start)
	dw_claim_base.SetItem(1,"claims_laycan_end",   lstr_claim_base_data.laycan_end)
	dw_claim_base.SetItem(1,"claims_address_com",  lstr_claim_base_data.address_com)
	li_office_nr = lstr_claim_base_data.office_nr
	SELECT OFFICE_SN
	INTO :ls_office_sn
	FROM OFFICES
	WHERE OFFICE_NR = :li_office_nr
	USING SQLCA;
	COMMIT USING SQLCA;
	dw_claim_base.SetItem(1,"office_nr",  lstr_claim_base_data.office_nr)
	dw_claim_base.SetItem(1,"offices_office_sn",  ls_office_sn)

	ib_broker_set = FALSE
	/* Broker only set if one .If there are many brokers on CP then the clac. nvo shall not return a number > 0 */
	IF  li_broker_nr > 0 THEN
		dw_claim_base.SetItem(1,"claims_broker_com",  lstr_claim_base_data.broker_com)
		dw_claim_base.SetItem(1,"broker_nr",  li_broker_nr)
		dw_claim_base.SetItem(1,"brokers_broker_sn", ls_broker_sn)
		ib_broker_set = TRUE
	END IF
	wf_claim_base_tabs(FALSE)	
	
END IF	


FOR li_array_counter = 1 TO li_nr_of_dataset
	IF Not lstr_frt_data[li_array_counter].ws_pct > 0 THEN SetNull(lstr_frt_data[li_array_counter].ws_pct)
	IF Not lstr_frt_data[li_array_counter].ws_rate > 0 THEN SetNull(lstr_frt_data[li_array_counter].ws_rate)
	IF Not lstr_frt_data[li_array_counter].mts > 0 THEN SetNull(lstr_frt_data[li_array_counter].mts)
	IF Not lstr_frt_data[li_array_counter].bunker_escalation > 0 then setNull(lstr_frt_data[li_array_counter].bunker_escalation)
	IF Not lstr_frt_data[li_array_counter].min_1 > 0 THEN SetNull(lstr_frt_data[li_array_counter].min_1)
	IF Not lstr_frt_data[li_array_counter].min_2 > 0 THEN SetNull(lstr_frt_data[li_array_counter].min_2)
	IF Not lstr_frt_data[li_array_counter].over_1 >= 0 THEN SetNull(lstr_frt_data[li_array_counter].over_1)
	IF Not lstr_frt_data[li_array_counter].over_2 >= 0 THEN SetNull(lstr_frt_data[li_array_counter].over_2)
NEXT

IF li_nr_of_dataset = 1 OR lstr_calc_data.cp_multiple = 2 THEN
/* handle freight */
	wf_show_hide_dw("FRT")
	
	dw_freight_claim.Reset()
	dw_freight_claim.InsertRow(0)
	dw_freight_received.Reset()
	dw_freight_claim.SetItem(1,"cal_cerp_id", lstr_calc_data.cp_id)
	dw_freight_claim.SetItem(1,"vessel_nr",ii_vessel_nr)
	dw_freight_claim.SetItem(1,"voyage_nr", lstr_calc_data.voyage_nr)
	dw_freight_claim.SetItem(1,"chart_nr",  lstr_calc_data.charter_nr)
	
	//M5-6 Added by LGX001 on 14/02/2012.
	if lstr_frt_data[1].freight_type = 4 then
		dw_freight_claim.modify("freight_reload.visible = '1'")
		dw_freight_claim.settaborder("freight_reload", 200)
	else
		dw_freight_claim.modify("freight_reload.visible = '0'")
		dw_freight_claim.settaborder("freight_reload", 0)
	end if
	
	IF IsNull(lstr_frt_data[1].lumpsum) THEN lstr_frt_data[1].lumpsum = 0
	dw_freight_claim.SetItem(1,"freight_ws",lstr_frt_data[1].ws_pct)
	if id_fixed_exrate > 0 then
		dw_freight_claim.SetItem(1,"freight_ws_rate",lstr_frt_data[1].ws_rate * id_fixed_exrate / 100)
		if lstr_frt_data[1].bunker_escalation <> 0 then
			dw_freight_claim.SetItem(1,"freight_per_mts",(lstr_frt_data[1].mts + lstr_frt_data[1].bunker_escalation) * id_fixed_exrate / 100)
		else
			dw_freight_claim.SetItem(1,"freight_per_mts",lstr_frt_data[1].mts * id_fixed_exrate / 100)
		end if
		dw_freight_claim.SetItem(1,"freight_main_lumpsum",lstr_frt_data[1].lumpsum * id_fixed_exrate / 100)	
	else
		dw_freight_claim.SetItem(1,"freight_ws_rate",lstr_frt_data[1].ws_rate)
		if lstr_frt_data[1].bunker_escalation <> 0 then
			dw_freight_claim.SetItem(1,"freight_per_mts",lstr_frt_data[1].mts + lstr_frt_data[1].bunker_escalation)
		else
			dw_freight_claim.SetItem(1,"freight_per_mts",lstr_frt_data[1].mts)
		end if
		dw_freight_claim.SetItem(1,"freight_main_lumpsum",lstr_frt_data[1].lumpsum )	
	end if
	dw_add_lumpsums.reset( )
	FOR li_add_lump = 1 to upperbound(lstr_frt_data[1].addit_lump)
		IF IsNull(lstr_frt_data[1].addit_lump[li_add_lump]) THEN lstr_frt_data[1].addit_lump[li_add_lump] = 0
		IF IsNull(lstr_frt_data[1].add_lump_comment[li_add_lump]) THEN lstr_frt_data[1].add_lump_comment[li_add_lump] = ""
		if lstr_frt_data[1].addit_lump[li_add_lump] <> 0 then
			dw_add_lumpsums.ScrollToRow(dw_add_lumpsums.insertrow(0)) 
			dw_add_lumpsums.SetItem(li_add_lump,"vessel_nr",ii_vessel_nr)
			dw_add_lumpsums.SetItem(li_add_lump,"voyage_nr", lstr_calc_data.voyage_nr)
			dw_add_lumpsums.SetItem(li_add_lump,"chart_nr",  lstr_calc_data.charter_nr)
			dw_add_lumpsums.SetItem(li_add_lump,"claim_nr",  li_claim_nr)
			if id_fixed_exrate > 0 then
				dw_add_lumpsums.SetItem(li_add_lump,"add_lumpsums",lstr_frt_data[1].addit_lump[li_add_lump] * id_fixed_exrate / 100)
			else
				dw_add_lumpsums.SetItem(li_add_lump,"add_lumpsums",lstr_frt_data[1].addit_lump[li_add_lump])
			end if
			dw_add_lumpsums.SetItem(li_add_lump,"comment",lstr_frt_data[1].add_lump_comment[li_add_lump])
			IF lstr_frt_data[1].adr_com_lump[li_add_lump] THEN 
				dw_add_lumpsums.SetItem(li_add_lump,"adr_comm",1)
			ELSE
				dw_add_lumpsums.SetItem(li_add_lump,"adr_comm",0)
			END IF
			IF lstr_frt_data[1].bro_com_lump[li_add_lump] THEN 
				dw_add_lumpsums.SetItem(li_add_lump,"bro_comm",1)
			ELSE
				dw_add_lumpsums.SetItem(li_add_lump,"bro_comm",0)
			END IF	
		end if
	NEXT
	
	dw_freight_claim.SetItem(1,"freight_min_1",lstr_frt_data[1].min_1)
	dw_freight_claim.SetItem(1,"freight_min_2",lstr_frt_data[1].min_2)
	dw_freight_claim.SetItem(1,"freight_overage_1",lstr_frt_data[1].over_1)
	dw_freight_claim.SetItem(1,"freight_overage_2",lstr_frt_data[1].over_2)
	wf_frt_tabs(FALSE)	     
	
	/* Select the right bol quantity */
		
		SELECT ISNull(SUM(BOL_QUANTITY),0)
		INTO :bol_quantity
		FROM BOL
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :lstr_calc_data.voyage_nr
		AND CHART_NR = :lstr_calc_data.charter_nr
		AND L_D = 1
//		Because If 2 CP with same charter, we must collect bol quantity from all
//		cp's, we dont use cp_id. Leith 3/3-98.
//		AND CAL_CERP_ID =  :lstr_calc_data.cp_id
		USING SQLCA;
		COMMIT USING SQLCA;
		dw_freight_claim.SetItem(1,"bol_load_quantity",bol_quantity)

ELSEIF li_nr_of_dataset > 1 THEN
	
	/* Open dw for afc, set tabs = 0, and insert data from lstr_frt_data */
	
	wf_show_hide_dw("AFCOLD")
	dw_afc.Reset()
	dw_afc_recieved.Reset()
	dw_add_lumpsums_afc.Reset( )
	
  FOR li_counter = 1 TO li_nr_of_dataset	
	dw_afc.InsertRow(0)
	ll_calcaioid = lstr_frt_data[li_counter].calcaioid
	dw_afc.SetItem(li_counter,"freight_advanced_vessel_nr",ii_vessel_nr)
	dw_afc.SetItem(li_counter,"freight_advanced_cal_cerp_id", lstr_calc_data.cp_id)
	dw_afc.SetItem(li_counter,"freight_advanced_voyage_nr", lstr_calc_data.voyage_nr)
	dw_afc.SetItem(li_counter,"freight_advanced_chart_nr",  lstr_calc_data.charter_nr)
	dw_afc.SetItem(li_counter,"freight_advanced_afc_ws",lstr_frt_data[li_counter].ws_pct)
	IF IsNull(lstr_frt_data[li_counter].lumpsum) THEN lstr_frt_data[li_counter].lumpsum = 0
	if id_fixed_exrate > 0 then
		dw_afc.SetItem(li_counter,"freight_advanced_afc_ws_rate",lstr_frt_data[li_counter].ws_rate * id_fixed_exrate /100)
		if lstr_frt_data[li_counter].bunker_escalation <> 0 then
			dw_afc.SetItem(li_counter,"freight_advanced_afc_per_mts",(lstr_frt_data[li_counter].mts + lstr_frt_data[li_counter].bunker_escalation)  * id_fixed_exrate /100)
		else
			dw_afc.SetItem(li_counter,"freight_advanced_afc_per_mts",lstr_frt_data[li_counter].mts * id_fixed_exrate /100)
		end if
		dw_afc.SetItem(li_counter,"freight_advanced_afc_main_lumpsum",lstr_frt_data[li_counter].lumpsum * id_fixed_exrate /100)
		dw_freight_claim.SetItem(1,"freight_main_lumpsum",lstr_frt_data[li_counter].lumpsum * id_fixed_exrate /100)	
	else
		dw_afc.SetItem(li_counter,"freight_advanced_afc_ws_rate",lstr_frt_data[li_counter].ws_rate)
		if lstr_frt_data[li_counter].bunker_escalation <> 0 then
			dw_afc.SetItem(li_counter,"freight_advanced_afc_per_mts",lstr_frt_data[li_counter].mts + lstr_frt_data[li_counter].bunker_escalation)
		else
			dw_afc.SetItem(li_counter,"freight_advanced_afc_per_mts",lstr_frt_data[li_counter].mts)
		end if
		dw_afc.SetItem(li_counter,"freight_advanced_afc_main_lumpsum",lstr_frt_data[li_counter].lumpsum)
		dw_freight_claim.SetItem(1,"freight_main_lumpsum",lstr_frt_data[li_counter].lumpsum )	
	end if
	dw_afc.SetItem(li_counter,"freight_advanced_afc_agent_nr",1)
	dw_afc.SetItem(li_counter,"freight_advanced_cal_caio_id",ll_calcaioid)
	FOR li_add_lump = 1 to upperbound(lstr_frt_data[li_counter].addit_lump)
		IF IsNull(lstr_frt_data[li_counter].addit_lump[li_add_lump]) THEN lstr_frt_data[li_counter].addit_lump[li_add_lump] = 0
		IF IsNull(lstr_frt_data[li_counter].add_lump_comment[li_add_lump]) THEN lstr_frt_data[li_counter].add_lump_comment[li_add_lump] = ""
		if lstr_frt_data[li_counter].addit_lump[li_add_lump] <> 0 then
			li_row = dw_add_lumpsums_afc.insertrow(0)
			dw_add_lumpsums_afc.SetItem(li_row,"vessel_nr",ii_vessel_nr)
			dw_add_lumpsums_afc.SetItem(li_row,"voyage_nr", lstr_calc_data.voyage_nr)
			dw_add_lumpsums_afc.SetItem(li_row,"chart_nr",  lstr_calc_data.charter_nr)
			dw_add_lumpsums_afc.SetItem(li_row,"claim_nr",  li_claim_nr)
			dw_add_lumpsums_afc.SetItem(li_row,"afc_nr",li_counter)
			if id_fixed_exrate > 0 then
				dw_add_lumpsums_afc.SetItem(li_row,"add_lumpsums",lstr_frt_data[li_counter].addit_lump[li_add_lump] * id_fixed_exrate /100)
			else
				dw_add_lumpsums_afc.SetItem(li_row,"add_lumpsums",lstr_frt_data[li_counter].addit_lump[li_add_lump])
			end if
			dw_add_lumpsums_afc.SetItem(li_row,"comment",lstr_frt_data[li_counter].add_lump_comment[li_add_lump])
			IF lstr_frt_data[li_counter].adr_com_lump[li_add_lump] THEN 
				dw_add_lumpsums_afc.SetItem(li_row,"adr_comm",1)
			ELSE
				dw_add_lumpsums_afc.SetItem(li_row,"adr_comm",0)
			END IF
			IF lstr_frt_data[li_counter].bro_com_lump[li_add_lump] THEN 
				dw_add_lumpsums_afc.SetItem(li_row,"bro_comm",1)
			ELSE
				dw_add_lumpsums_afc.SetItem(li_row,"bro_comm",0)
			END IF	
		end if
	NEXT

	dw_afc.SetItem(li_counter,"freight_advanced_afc_min_1",lstr_frt_data[li_counter].min_1)
	dw_afc.SetItem(li_counter,"freight_advanced_afc_min_2",lstr_frt_data[li_counter].min_2)
	dw_afc.SetItem(li_counter,"freight_advanced_afc_overage_1",lstr_frt_data[li_counter].over_1)
	dw_afc.SetItem(li_counter,"freight_advanced_afc_overage_2",lstr_frt_data[li_counter].over_2)
	dw_afc.SetItem(li_counter,"freight_advanced_afc_port_code","          ")
	dw_afc.SetItem(li_counter,"freight_advanced_afc_nr",li_counter)
	
		/* Select the right bol quantity, where vessel, voyage,charter and grade name match.
	            WARNING If there is to identical grade names, that is to identical calc.cargos then the bol for 
		    these will be double and there for the frt. claim amount wrong !!! */
/////////////////////////////////////////////////////////	
	SELECT DISTINCT CAL_CARG_ID
	INTO :ll_cargoid
	FROM CAL_CAIO	
	WHERE CAL_CAIO_ID = :ll_calcaioid
	USING SQLCA;
	
	IF SQLCA.SQLCode <>  0 THEN 
		MessageBox("Error","Cargo id from calculation not found !!")
		dw_afc.Reset()
		DESTROY uo_calc_nvo 
		COMMIT USING SQLCA;
		Return (-1)
	END IF
	COMMIT USING SQLCA;	
	
	SELECT IsNull(sum(BOL.BOL_QUANTITY),0)  
    		INTO :bol_quantity  
    		FROM BOL,   
         		CD  
  		 WHERE ( CD.VESSEL_NR = BOL.VESSEL_NR ) and  
         	( CD.VOYAGE_NR = BOL.VOYAGE_NR ) and  
         	( CD.PORT_CODE = BOL.PORT_CODE ) and  
         	( CD.PCN = BOL.PCN ) and  
         	( CD.CAL_CERP_ID = BOL.CAL_CERP_ID ) and  
         	( CD.CHART_NR = BOL.CHART_NR ) and  
         	( CD.AGENT_NR = BOL.AGENT_NR ) and  
			( CD.GRADE_NAME = BOL.GRADE_NAME ) and  
         	( CD.LAYOUT = BOL.LAYOUT ) and  
         	( ( BOL.L_D = 1 ) AND  
         	( CD.CAL_CAIO_ID in (SELECT CAL_CAIO_ID FROM CAL_CAIO WHERE CAL_CARG_ID = :ll_cargoid) ) )   
		USING SQLCA;

	IF SQLCA.SQLCode =  -1 THEN 
		MessageBox("Error","Cargo BillOfLading not found !!")
		dw_afc.Reset()
		DESTROY uo_calc_nvo 
		COMMIT USING SQLCA;
		Return (-1)
	END IF
	COMMIT USING SQLCA;	
	
	dw_afc.SetItem(li_counter,"freight_advanced_afc_bol_quantity",bol_quantity)
  NEXT
  wf_afc_tabs(FALSE)	
//MessageBox("Warning","If there are identical Grade Names, then the bol quantity are double for those, and &
//			therefore the claim amount wrong. If this is the case you should NOT update this claim.") 

dw_afc.Modify("sum_recieved='0'")     
dw_afc.ScrollToRow(1)
dw_afc.TriggerEvent(Retrieveend!)

dw_add_lumpsums_afc.setfilter( "afc_nr = 1")
dw_add_lumpsums_afc.filter( )

END IF

cb_update.enabled = true

DESTROY uo_calc_nvo 
return(0)
end function

public subroutine wf_claim_base_tabs (boolean open_close);/********************************************************************
	wf_claim_base_tabs
	<DESC> 
		Sets the taborder for claim base fields to 0 if the parameter is FALSE, and to 10.... if TRUE.
		FALSE means that there is automatic generated clacule data, so the user shall not be allowed to edit.
	</DESC>
	<RETURN>	</RETURN>
	<ACCESS> public </ACCESS>
	<ARGS>
		open_close as boolean
	</ARGS>
	<USAGE> important variables - usually only used in Open-event scriptcode </USAGE>
	<HISTORY>
		Date      	CR-Ref		Author		Comments
		01/07/96		?     		LN    		First Version.
		19/08/14		CR3717		XSZ004		Remove textfield script for "broker" disabled/enabled  
	</HISTORY>
********************************************************************/

IF open_close THEN
	dw_claim_base.SetTabOrder("claims_laycan_start",20)
	dw_claim_base.Modify("claims_laycan_start.Background.Mode = '0'")
	dw_claim_base.Modify("claims_laycan_start.Background.Color = '16777215'")
	dw_claim_base.SetTabOrder("claims_laycan_end",30)
	dw_claim_base.Modify("claims_laycan_end.Background.Mode = '0'")
	dw_claim_base.Modify("claims_laycan_end.Background.Color = '16777215'")
	
	dw_claim_base.SetTabOrder("cp_date",40)
	dw_claim_base.Modify("cp_date.Background.Mode = '0'")
	dw_claim_base.Modify("cp_date.Background.Color = '31775128'")
	dw_claim_base.SetTabOrder("cp_text",50)
	dw_claim_base.Modify("cp_text.Background.Mode = '0'")
	dw_claim_base.Modify("cp_text.Background.Color = '16777215'")
	
	dw_claim_base.SetTabOrder("timebar_days",60)
	dw_claim_base.Modify("timebar_days.Background.Mode = '0'")
	dw_claim_base.Modify("timebar_days.Background.Color = '31775128'")
	dw_claim_base.SetTabOrder("notice_days",70)
	
	dw_claim_base.Modify("notice_days.Background.Mode = '0'")
	dw_claim_base.Modify("notice_days.Background.Color = '16777215'")

	dw_claim_base.SetTabOrder("offices_office_sn",125)
	dw_claim_base.Modify("offices_office_sn.Background.Mode = '0'")
	dw_claim_base.Modify("offices_office_sn.Background.Color = '31775128'")
	cb_office.Visible = TRUE

	//Only users with Finance profile can change addr.comm. for FRT and DEM from what is given in calculations
	choose case dw_claim_base.getItemString(1,"claim_type") 
		case "DEM", "FRT"
			if uo_global.ii_user_profile <> 3 then 
				dw_claim_base.SetTabOrder("claims_address_com",0)
				dw_claim_base.Modify("claims_address_com.Background.Mode = '1'")
				dw_claim_base.Modify("claims_address_com.Background.Color = '31775128'")
			else
				dw_claim_base.SetTabOrder("claims_address_com",130)
				dw_claim_base.Modify("claims_address_com.Background.Mode = '0'")
				dw_claim_base.Modify("claims_address_com.Background.Color = '16777215'")
			end if
		case else
			dw_claim_base.SetTabOrder("claims_address_com",130)
			dw_claim_base.Modify("claims_address_com.Background.Mode = '0'")
			dw_claim_base.Modify("claims_address_com.Background.Color = '16777215'")
	end choose	
	
	dw_claim_base.SetTabOrder("curr_code",140)
	dw_claim_base.Modify("curr_code.Background.Mode = '0'")
	dw_claim_base.Modify("curr_code.Background.Color = '31775128'")
ELSE
	dw_claim_base.SetTabOrder("claims_laycan_start",0)
	dw_claim_base.Modify("claims_laycan_start.Background.Mode = '1'")
	dw_claim_base.SetTabOrder("claims_laycan_end",0)
	dw_claim_base.Modify("claims_laycan_end.Background.Mode = '1'")
	
	dw_claim_base.SetTabOrder("cp_date",0)
	dw_claim_base.Modify("cp_date.Background.Mode = '1'")
	dw_claim_base.SetTabOrder("cp_text",0)
	dw_claim_base.Modify("cp_text.Background.Mode = '1'")
	
	dw_claim_base.SetTabOrder("timebar_days",0)
	dw_claim_base.Modify("timebar_days.Background.Mode = '1'")
	dw_claim_base.SetTabOrder("notice_days",0)
	dw_claim_base.Modify("notice_days.Background.Mode = '1'")
	
	dw_claim_base.SetTabOrder("offices_office_sn",0)
	dw_claim_base.Modify("offices_office_sn.Background.Mode = '1'")
	cb_office.Visible = FALSE
	
	dw_claim_base.SetTabOrder("curr_code",0)
	dw_claim_base.Modify("curr_code.Background.Mode = '1'")	
END IF


end subroutine

public subroutine wf_afc_del_array ();Long ll_upper, xx

ll_upper = UpperBound(del_freight_rec)

FOR xx = 1 TO ll_upper
	 IF del_freight_rec[xx].data_to_del = 1 THEN 
		del_freight_rec[xx].data_to_del = 0
	 ELSE
		xx = ll_upper
	END IF
NEXT
end subroutine

private function integer wf_new_claim (string claim_type);/********************************************************************
   wf_new_claim
   <DESC></DESC>
   <RETURN> int </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		string
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		01-01-96		1.0   		RM    		Initial
		17-07-96          		LN				changed to Calc. system and to handle dem. per port.
		11-12-96		3.0			RM    		added COMMITS
		11-12-96		3.0			RM    		DESTROY uo_layt_ports, DESTROY uo_calc_nvo  
		17-01-97		      		LN    		Added dw_dem_des_claim.SetItem(1,"dem_des_settled",2) se comment.
		29-04-13		CR3153		LHG008		Take CP date/Laycan/Office data automatically from the fixture for type Deviation, Heating and Misc.
		20-05-13		CR3096		LGH001		Set the claim email field from system table broker - broker email when creating DEM claim and change broker nr
		14-04-16		CR4251		HHX010		When creating a new claim for a TC out voyage , the laycan and cp date come from the TC out contract.
		03-08-16		CR4219		LHG008		Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111).
		20-12-16		CR4420		XSZ004		Disable responsible field when new claim.
		10-04-17		CR4564		HHX010		When creating a new claim for a TC out voyage, the laycan should be 00-00-00 00:00 - 00-00-00 00:00.
		04/09/17		CR4176		LHG008		Users can change miscellaneous claim types in specific circumstances
   </HISTORY>
********************************************************************/

String   ls_cp_text, ls_broker_sn, ls_office_sn, ls_port_code,ls_dw_purpose, ls_claim_email
Datetime ld_discharge_date, ld_notice_date, ld_timebar_date, ld_cp_date, ld_laycan_start, ld_laycan_end
Integer  li_notice_days, li_timebar_days, li_claim_nr, li_broker_nr, li_office_nr, li_dem_des_set,li_dem_counter
Integer  li_dem_row_count,li_port_counter,li_dem_rows,li_counter,li_pcn,li_upper, li_null
Decimal  {3}bol_quantity
dec      ld_percent
Long     ll_calcaioid, ll_row
boolean  lb_found_cp_data
string   ls_chart_sn, ls_chart_n_1, ls_chart_a_1, ls_chart_a_2, ls_chart_a_3, ls_chart_a_4, ls_chart_c
string   ls_claim_type

u_calc_nvo     uo_calc_nvo
s_pcn_order    lstr_pcn_order[]
s_dem_des_data lstr_dem_des_data[]

s_claim_base_data  lstr_claim_base_data
uo_find_layt_ports uo_layt_ports

s_select_voyage_charterer lstr_parametre 

ls_claim_type = claim_type

setnull(li_null)
setnull(lstr_claim_base_data.laycan_start)
setnull(lstr_claim_base_data.laycan_end)

uo_calc_nvo = CREATE u_calc_nvo
uo_layt_ports = CREATE uo_find_layt_ports

/* Let user select voyage,charter and if more than one cp, cp_nr. */
s_select_parm lstr_parm
lstr_parm.vessel_nr = ii_vessel_nr
if claim_type = "**MISC**" then
	lstr_parm.claim_type = "MISC"
else
	lstr_parm.claim_type = claim_type
end if
OpenWithParm(w_select_voyage_charterer,lstr_parm)
lstr_parametre = message.PowerObjectParm

if claim_type = "**MISC**" then
	claim_type = "MISC"
end if

choose case claim_type
	case 'FRT', 'DEM', 'DES', 'HEA', 'DEV'
		dw_claim_base.SetTabOrder("claim_type", 0)
		dw_claim_base.modify("claim_type.background.mode = '1'")
		dw_claim_base.SetTabOrder("claim_amount",0)
		dw_claim_base.modify("claim_amount.background.mode = '1'")
end choose

/* Test if returned voyage as "cancel", and stop if it is. */
IF lstr_parametre.voyage_nr = "cancel" THEN 
	DESTROY uo_calc_nvo
	DESTROY uo_layt_ports
	Return 0
END IF

ib_calc_yes_no = lstr_parametre.calc_yes_no
ii_cerp_id = lstr_parametre.cp_id

cb_update.enabled = true

/* If there is a calc. on this frt. then call function for handling this, and stop script.
If not then proceed with user input. */ 
IF ib_calc_yes_no AND claim_type = "FRT" THEN
	wf_frt_with_calc(lstr_parametre)
	DESTROY uo_calc_nvo
	DESTROY uo_layt_ports
	Return 1
END IF

/* Check if there i Created a  Freight Claim  
   for selected Charterer. (only one of these claims pr. charterer). */

CHOOSE CASE claim_type
	CASE  "FRT"
		SELECT CLAIM_NR 
		INTO :li_claim_nr
		FROM CLAIMS
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :lstr_parametre.voyage_nr
		AND CHART_NR = :lstr_parametre.charter_nr
		AND CLAIM_TYPE = :claim_type;

		IF SQLCA.SQLCode <> 100 THEN
			MessageBox("Error","You can't create more than one "+claim_type+"-Claim for the same Charterer.~r~n~r~nSelect another Charterer!")
			DESTROY uo_calc_nvo
			DESTROY uo_layt_ports
			COMMIT USING SQLCA;
			Return -1
		END IF
	CASE "DEM"
	/* If ib_calc_yes_no is true that means that there is a calc. and therefore a cp nr. Call the calc. NVO
	 and get the cp data  for dw claim base. The NVO function stores the data in the lstr_claim_base
        _data which is a parameter with reference. The NVO itself returns true if the data is found, and false if not. */

 	   IF ib_calc_yes_no THEN
			IF NOT uo_calc_nvo.uf_claim_base_data(ii_vessel_nr,lstr_parametre.voyage_nr,lstr_parametre.charter_nr,ii_cerp_id,lstr_claim_base_data ) THEN
			     	MessageBox("Error Claim base","The selected combination of cp nr, with vessel, voyage, charter ~r~n is not found in the calcule system !")
				DESTROY uo_calc_nvo
				DESTROY uo_layt_ports
		      Return -1
			END IF
			li_dem_des_set = uo_calc_nvo.uf_dem_des_data(ii_vessel_nr,lstr_parametre.voyage_nr,lstr_parametre.charter_nr,ii_cerp_id,lstr_dem_des_data )
			IF li_dem_des_set < 1 THEN
			    	MessageBox("Error Dem/des","The selected combination of cp nr, with vessel, voyage, charter ~r~n is not found in the calcule system !")
				DESTROY uo_calc_nvo
				DESTROY uo_layt_ports
		      Return -1
			END IF
		END IF
	CASE ELSE
		lb_found_cp_data = uo_calc_nvo.uf_claim_base_data(ii_vessel_nr,lstr_parametre.voyage_nr,lstr_parametre.charter_nr,ii_cerp_id,lstr_claim_base_data )
		if lstr_parametre.voyage_type = 2 then
			wf_misc_contract(ii_vessel_nr, lstr_parametre.voyage_nr, lstr_claim_base_data)
		end if
END CHOOSE

wf_get_misc_options(claim_type, il_bunker_visible, il_lumpsum_visible, il_time_visible)

dw_list_claims.SelectRow(0,FALSE)
wf_enabled_buttons("NEW")
wf_show_hide_dw(claim_type)
dw_claim_base.Reset()
dw_claim_base.InsertRow(0)
dw_claim_base.modify("claim_type.tooltip.enabled = '0' ")

wf_filtermisctype()

if lstr_claim_base_data.fixed_exrate_enabled = 1 then
	dw_claim_base.SetItem(1,COLUMN_CURRENCY_CODE,lstr_claim_base_data.claim_curr)
	id_fixed_exrate = lstr_claim_base_data.fixed_exrate
else
	if claim_type = 'DEM' then
		dw_claim_base.SetItem(1,COLUMN_CURRENCY_CODE,lstr_claim_base_data.dem_curr_code)
		if lstr_claim_base_data.set_ex_rate and &
			lstr_claim_base_data.dem_curr_code <> 'USD' then
			st_setexrate.visible = true
		else
			st_setexrate.visible = false
		end if
	else
		dw_claim_base.SetItem(1,COLUMN_CURRENCY_CODE,lstr_claim_base_data.frt_curr_code)
		if lstr_claim_base_data.set_ex_rate and &
			lstr_claim_base_data.frt_curr_code <> 'USD' then
			st_setexrate.visible = true
		else
			st_setexrate.visible = false
		end if
	end if
	id_fixed_exrate = 0
end if

dw_claim_base.SetItem(1, COLUMN_VESSEL_NR, ii_vessel_nr)
dw_claim_base.SetItem(1, COLUMN_VOYAGE_NR, lstr_parametre.voyage_nr)
dw_claim_base.SetItem(1, COLUMN_CHART_NR, lstr_parametre.charter_nr)
dw_claim_base.setitem(1, COLUMN_CP_ID, lstr_parametre.cp_id)
dw_claim_base.setitem(1, "claim_responsible", uo_global.is_userid)

if ls_claim_type <> "**MISC**" then
	dw_claim_base.setitem(1, COLUMN_CLAIM_TYPE, ls_claim_type)
end if

CHOOSE CASE claim_type
	CASE "DEM", "DES"
/* If there is no calc data, then this is an "old" voyage and the user should be able to input data.*/
		IF NOT ib_calc_yes_no THEN
			dw_dem_des_claim.Reset()
			dw_dem_des_claim.InsertRow(0)			
			dw_dem_des_claim.SetItem(1,"vessel_nr",ii_vessel_nr)
			dw_dem_des_claim.SetItem(1,"voyage_nr", lstr_parametre.voyage_nr)
			dw_dem_des_claim.SetItem(1,"chart_nr", lstr_parametre.charter_nr)
			dw_dem_des_claim.SetItem(1,"dem_des_purpose","X")
			dw_dem_des_claim.SetItem(1,"dem_des_settled",2)
			dw_dem_des_claim.SetItem(1,COLUMN_CP_ID,1)
			dw_dem_des_claim.SetItem(1,"port_code", "          ") /* MUST BE 10 BLANKS  !!!! */
			
			dw_dem_des_rates.Reset()
			dw_dem_des_rates.InsertRow(0)
			dw_dem_des_rates.SetItem(1,"rate_number",1)
			dw_dem_des_rates.SetItem(1,"vessel_nr",ii_vessel_nr)
			dw_dem_des_rates.SetItem(1,"voyage_nr", lstr_parametre.voyage_nr)
			dw_dem_des_rates.SetItem(1,"chart_nr", lstr_parametre.charter_nr)
			dw_dem_des_rates.SetItem(1,"dem_des_purpose","X")
			dw_dem_des_rates.SetItem(1,"port_code", "          ") /* MUST BE 10 BLANKS  !!!! */

			wf_dem_des_tabs(TRUE)	
		ELSE /* calc_yes_no is TRUE*/
/* Prevent the user from editing calc. data on this claim and reset for new data */
			SetPointer(HourGlass!)
			wf_dem_des_tabs(FALSE)	
			dw_dem_des_claim.Reset()	
			dw_dem_des_rates.Reset()
/*Check for identical ports, with same purpose. Set L or D to L1,L2 and D1,D2 etc. according to how many there are. */

			Integer li_count_1, li_count_2, li_port_count

			li_upper = UpperBound(lstr_dem_des_data)

			FOR li_count_1= 1 TO li_upper
				IF   lstr_dem_des_data[li_count_1].purpose = "L" OR  lstr_dem_des_data[li_count_1].purpose = "D" THEN
					lstr_dem_des_data[li_count_1].purpose += "1"
					li_port_count = 1
					FOR li_count_2 = (li_count_1 + 1) TO li_upper
						IF lstr_dem_des_data[li_count_1].ports =  lstr_dem_des_data[li_count_2].ports AND &
							LEFT( lstr_dem_des_data[li_count_1].purpose,1) =  lstr_dem_des_data[li_count_2].purpose THEN
				                         li_port_count++
							lstr_dem_des_data[li_count_2].purpose += String(li_port_count)
						END IF
					NEXT
				END IF
		   NEXT

/* Set dem/des from calc. data*/
			FOR li_dem_counter = 1 TO li_dem_des_set
				dw_dem_des_claim.InsertRow(0)
				dw_dem_des_rates.InsertRow(0)
				dw_dem_des_claim.SetItem( li_dem_counter,"vessel_nr",ii_vessel_nr)
				dw_dem_des_claim.SetItem( li_dem_counter,"voyage_nr", lstr_parametre.voyage_nr)
				dw_dem_des_claim.SetItem( li_dem_counter,"chart_nr", lstr_parametre.charter_nr)
				dw_dem_des_claim.SetItem( li_dem_counter,COLUMN_CP_ID, lstr_parametre.cp_id)
				dw_dem_des_claim.SetItem( li_dem_counter,"calcaioid", lstr_dem_des_data[li_dem_counter].calcaioid)
				dw_dem_des_claim.SetItem( li_dem_counter,"terms_desc", lstr_dem_des_data[li_dem_counter].terms)

				dw_dem_des_claim.SetItem(li_dem_counter,"dem_des_settled",0)
				IF LEFT(lstr_dem_des_data[li_dem_counter].purpose,1) = "D" and isnumber(mid(lstr_dem_des_data[li_dem_counter].purpose, 2, 1)) THEN
					dw_dem_des_claim.SetItem( li_dem_counter,"disch_laytime_allowed", 0)
					IF  lstr_dem_des_data[li_dem_counter].hour_rate > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"disch_hourly_rate", lstr_dem_des_data[li_dem_counter].hour_rate)
					END IF	
					IF  lstr_dem_des_data[li_dem_counter].daily_rate > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"disch_daily_rate", lstr_dem_des_data[li_dem_counter].daily_rate)
					END IF
					IF  lstr_dem_des_data[li_dem_counter].laytime_allowed > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"disch_laytime_allowed", lstr_dem_des_data[li_dem_counter].laytime_allowed)	
					END IF
				ELSE
					dw_dem_des_claim.SetItem( li_dem_counter,"load_laytime_allowed", 0)	
					IF  lstr_dem_des_data[li_dem_counter].hour_rate > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"load_hourly_rate", lstr_dem_des_data[li_dem_counter].hour_rate)				
					END IF
					IF  lstr_dem_des_data[li_dem_counter].daily_rate > 0 THEN
						dw_dem_des_claim.SetItem( li_dem_counter,"load_daily_rate", lstr_dem_des_data[li_dem_counter].daily_rate)	
					END IF	
					IF  lstr_dem_des_data[li_dem_counter].laytime_allowed > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"load_laytime_allowed", lstr_dem_des_data[li_dem_counter].laytime_allowed)
					END IF
				END IF
				
/* THESE 4 LINES (UNDERNEATH) MUST BE ERASED WHEN THE FIELD "DISCH_LAYTIME_ALLOWED"
 HAS BEEN DONE OPTIONAL. THEY ARE ONLY FOR TEST PURPOSE */			

				IF li_dem_des_set = 1 THEN
					dw_dem_des_claim.SetItem( li_dem_counter,"calcaioid", li_null)
					dw_dem_des_claim.SetItem( li_dem_counter,"port_code", "          ") /* MUST BE 10 BLANKS  !!!! */
					dw_dem_des_rates.SetItem( li_dem_counter,"port_code", "          ") /* MUST BE 10 BLANKS  !!!! */
					dw_dem_des_claim.SetItem( li_dem_counter,"dem_des_purpose", "X")
					dw_dem_des_rates.SetItem( li_dem_counter,"dem_des_purpose", "X")

					// This line is set by Leith 17/1-96 to make print of laytime possible, because
					// laytime statement checks for Settled <> 0.						
					dw_dem_des_claim.SetItem(1,"dem_des_settled",2)
					
					IF  lstr_dem_des_data[li_dem_counter].disch_hour_rate > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"disch_hourly_rate", lstr_dem_des_data[li_dem_counter].disch_hour_rate)
					END IF	
					IF  lstr_dem_des_data[li_dem_counter].disch_daily_rate > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"disch_daily_rate", lstr_dem_des_data[li_dem_counter].disch_daily_rate)
					END IF
					IF  lstr_dem_des_data[li_dem_counter].disch_allowed > 0 THEN 
						dw_dem_des_claim.SetItem( li_dem_counter,"disch_laytime_allowed", lstr_dem_des_data[li_dem_counter].disch_allowed)	
					END IF
				ELSE
					dw_dem_des_claim.SetItem( li_dem_counter,"port_code", lstr_dem_des_data[li_dem_counter].ports)
					dw_dem_des_rates.SetItem( li_dem_counter,"port_code", lstr_dem_des_data[li_dem_counter].ports)
					dw_dem_des_rates.SetItem( li_dem_counter,"dem_des_purpose",  lstr_dem_des_data[li_dem_counter].purpose)
					dw_dem_des_claim.SetItem( li_dem_counter,"dem_des_purpose", lstr_dem_des_data[li_dem_counter].purpose)
				END IF
					
/* Set dem/des rates from calc. data*/
				dw_dem_des_rates.SetItem( li_dem_counter,"rate_number",1)
				dw_dem_des_rates.SetItem( li_dem_counter,"vessel_nr",ii_vessel_nr)
				dw_dem_des_rates.SetItem( li_dem_counter,"voyage_nr", lstr_parametre.voyage_nr)
				dw_dem_des_rates.SetItem( li_dem_counter,"chart_nr", lstr_parametre.charter_nr)
				if id_fixed_exrate > 0 then
					dw_dem_des_rates.SetItem( li_dem_counter,"dem_rate_day", lstr_dem_des_data[li_dem_counter].dem_rate * id_fixed_exrate / 100 )
					dw_dem_des_rates.SetItem( li_dem_counter,"des_rate_day", lstr_dem_des_data[li_dem_counter].des_rate * id_fixed_exrate / 100)
				else
					dw_dem_des_rates.SetItem( li_dem_counter,"dem_rate_day", lstr_dem_des_data[li_dem_counter].dem_rate)
					dw_dem_des_rates.SetItem( li_dem_counter,"des_rate_day", lstr_dem_des_data[li_dem_counter].des_rate)
				end if
				dw_dem_des_rates.SetItem( li_dem_counter,"rate_hours", lstr_dem_des_data[li_dem_counter].hours)
			NEXT			
		END IF

	/* If there is more than one set, then there is laytime on each port, and so the settled(dw_dem_des) has to
	    be set according to laytime statements present. If laytime then dem_des_settled = 1 */

	   uo_layt_ports.uf_layt_ports(ii_vessel_nr, lstr_parametre.voyage_nr, lstr_parametre.charter_nr,istr_port_array)
		
		FOR li_port_counter = 1 TO 50					
			li_dem_row_count = dw_dem_des_claim.RowCount()
			FOR li_dem_counter = 1 TO li_dem_row_count
				IF dw_dem_des_claim.GetItemString(li_dem_row_count,"port_code") = istr_port_array.ports[li_port_counter] THEN
					dw_dem_des_claim.SetItem(li_dem_row_count,"dem_des_settled",1)
				END IF
			NEXT
		NEXT	
				
		dw_dem_des_claim.ScrollToRow(1)
		dw_dem_des_rates.ScrollToRow(1)
		wf_dem_scroll()
		dw_dem_des_claim.PostEvent(retrieveend!)
		SetPointer(Arrow!)
	CASE "FRT"
		dw_freight_claim.Reset()
		dw_freight_claim.InsertRow(0)
		dw_add_lumpsums.reset()
		dw_freight_received.Reset()
		dw_freight_claim.SetItem(1,"vessel_nr",ii_vessel_nr)
		dw_freight_claim.SetItem(1,"voyage_nr", lstr_parametre.voyage_nr)
		dw_freight_claim.SetItem(1,"chart_nr", lstr_parametre.charter_nr)
		dw_freight_claim.SetItem(1,COLUMN_CP_ID,1)
	CASE ELSE
		wf_claim_base_tabs(TRUE)
			
		if claim_type = "MISC" then
			dw_claim_base.SetTabOrder("claim_type",1)
			dw_claim_base.modify("claim_type.background.mode = '0'")
			dw_claim_base.modify("claim_type.background.color = '" + string(c#color.MT_MAERSK) + "'")
			dw_claim_base.SetColumn("claim_type")
		else
			dw_claim_base.SetItem(1,"claim_type", claim_type)
		end if
		
		dw_hea_dev_claim.Reset()
		ll_row = dw_hea_dev_claim.InsertRow(0)
		dw_hea_dev_claim.SetItem(1,"vessel_nr",ii_vessel_nr)
		dw_hea_dev_claim.SetItem(1,"voyage_nr",lstr_parametre.voyage_nr)
		dw_hea_dev_claim.SetItem(1,"chart_nr",lstr_parametre.charter_nr)
END CHOOSE

SELECT CHART_SN, 
       CHART_N_1, 
       ISNULL(RTRIM(LTRIM(CHART_A_1)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_2)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_3)), ''), 
       ISNULL(RTRIM(LTRIM(CHART_A_4)), ''), 
       CHART_C
  INTO :ls_chart_sn, 
       :ls_chart_n_1, 
		 :ls_chart_a_1, 
		 :ls_chart_a_2, 
		 :ls_chart_a_3, 
		 :ls_chart_a_4, 
		 :ls_chart_c
  FROM CHART
 WHERE CHART_NR = :lstr_parametre.charter_nr;

dw_claim_base.setitem(1, "chart_chart_sn", ls_chart_sn)
dw_claim_base.setitem(1, "chart_chart_n_1", ls_chart_n_1)
dw_claim_base.setitem(1, "chart_chart_a_1", ls_chart_a_1)
dw_claim_base.setitem(1, "chart_chart_a_2", ls_chart_a_2)
dw_claim_base.setitem(1, "chart_chart_a_3", ls_chart_a_3)
dw_claim_base.setitem(1, "chart_chart_a_4", ls_chart_a_4)
dw_claim_base.setitem(1, "chart_chart_c", ls_chart_c)

SELECT dbo.FN_GET_POCDISCHARGEDATE(:ii_vessel_nr, :lstr_parametre.voyage_nr)
INTO :ld_discharge_date
FROM SYSTEM_OPTION
USING SQLCA;

IF SQLCA.SQLCode = 100 THEN SetNull(ld_discharge_date)

dw_claim_base.SetItem(1,"discharge_date", date(ld_discharge_date))


/* If there is no data from the calculation system (ib_calc_yes_no = FALSE) then insert default data in claim base, and
   set taborders  so that the user is allowed to enter data. If there is no calc.data it is an "old" voyage made before
   the calculation system was implemented.  ------  Else if there is calc.data (ib_calc_yes_no = TRUE) keep taborders = 0, and 
   insert the recieved data from the calc.system which is stored in lstr_claim_base_data */

if not ib_calc_yes_no and not lb_found_cp_data then

	wf_claim_base_tabs(TRUE)	    

	SELECT TOP 1 CP_DATE, CP_TEXT, TIMEBAR_DAYS, TIMEBAR_DATE, NOTICE_DAYS, NOTICE_DATE, BROKER_NR, OFFICE_NR, LAYCAN_START, LAYCAN_END
		INTO :ld_cp_date, :ls_cp_text, :li_timebar_days, :ld_timebar_date, :li_notice_days, :ld_notice_date, :li_broker_nr, :li_office_nr, :ld_laycan_start, :ld_laycan_end
		FROM CLAIMS
       	WHERE VESSEL_NR = :ii_vessel_nr
   		AND VOYAGE_NR = :lstr_parametre.voyage_nr
		AND CLAIM_TYPE IN ("FRT", "DEM")
		ORDER BY CLAIM_NR
		USING SQLCA;
 
	if SQLCA.SQLcode = 100 then
		commit using sqlca;
		SELECT TOP 1 CP_DATE, CP_TEXT, TIMEBAR_DAYS, TIMEBAR_DATE, NOTICE_DAYS, NOTICE_DATE, BROKER_NR, OFFICE_NR, LAYCAN_START, LAYCAN_END
			INTO :ld_cp_date, :ls_cp_text, :li_timebar_days, :ld_timebar_date, :li_notice_days, :ld_notice_date, :li_broker_nr, :li_office_nr, :ld_laycan_start, :ld_laycan_end
			FROM CLAIMS
				WHERE VESSEL_NR = :ii_vessel_nr
				AND VOYAGE_NR = :lstr_parametre.voyage_nr
			AND CLAIM_TYPE NOT IN  ("FRT", "DEM")
			ORDER BY CLAIM_NR
			USING SQLCA;
	end if
		
	IF SQLCA.SQLCode = 100 THEN 
		SetNull(ld_cp_date)
		SetNull(ld_timebar_date)
		SetNull(ld_notice_date)
		SetNull(li_timebar_days)
		SetNull(li_notice_days)
		SetNull(li_broker_nr)
		SetNull(li_office_nr)
		SetNull(ld_laycan_start)
		SetNull(ld_laycan_end)
	END IF

	if ld_laycan_start = datetime("1900-01-01") then setnull(ld_laycan_start)
	if ld_laycan_end = datetime("1900-01-01") then setnull(ld_laycan_end)
	dw_claim_base.SetItem(1,"cp_date", date(ld_cp_date))
	dw_claim_base.SetItem(1,"cp_text", ls_cp_text)
	dw_claim_base.SetItem(1,"timebar_days", li_timebar_days)
	dw_claim_base.SetItem(1,"timebar_date", date(ld_timebar_date))
	dw_claim_base.SetItem(1,"notice_days", li_notice_days)
	dw_claim_base.SetItem(1,"notice_date", date(ld_notice_date))
	dw_claim_base.SetItem(1,"broker_nr", li_broker_nr)
	dw_claim_base.SetItem(1,"claims_laycan_start", ld_laycan_start)
	dw_claim_base.SetItem(1,"claims_laycan_end",  ld_laycan_end)
	dw_claim_base.SetItem(1,"office_nr", li_office_nr)
	IF NOT IsNull(li_broker_nr) THEN
		SELECT BROKER_SN, BROKER_EMAIL
		INTO :ls_broker_sn, :ls_claim_email
		FROM BROKERS
	       	WHERE BROKER_NR = :li_broker_nr
		USING SQLCA;
		
		dw_claim_base.SetItem(1,"brokers_broker_sn", ls_broker_sn)
		if claim_type = "DEM" then
			if isnull(ls_claim_email) or trim(ls_claim_email) = "" then ls_claim_email = "no email address found in Brokers system table"
			dw_claim_base.setitem(1, "claims_claim_email", ls_claim_email)
		end if		
		ld_percent = wf_get_comm_percent(ii_vessel_nr, lstr_parametre.voyage_nr, li_broker_nr)
		dw_claim_base.setitem(1, "claims_broker_com", ld_percent)
	END IF
	
	IF NOT IsNull(li_office_nr) THEN
		SELECT OFFICE_SN
		INTO :ls_office_sn
		FROM OFFICES
		WHERE OFFICE_NR = :li_office_nr
		USING SQLCA;

		dw_claim_base.SetItem(1,"offices_office_sn", ls_office_sn)
	END IF
	 
else   /* There are calc.data, because calc_yes_no are TRUE or lb_found_cp_data are true */
	li_broker_nr = lstr_claim_base_data.broker_nr
	SELECT BROKER_SN, BROKER_EMAIL
	INTO :ls_broker_sn, :ls_claim_email
	FROM BROKERS
	WHERE BROKER_NR = :li_broker_nr
	USING SQLCA;
	
	ld_percent = wf_get_comm_percent(ii_vessel_nr, lstr_parametre.voyage_nr, li_broker_nr)

	li_office_nr = lstr_claim_base_data.office_nr
	SELECT OFFICE_SN
	INTO :ls_office_sn
	FROM OFFICES
	WHERE OFFICE_NR = :li_office_nr
	USING SQLCA;
	
	if lstr_claim_base_data.laycan_start = datetime("1900-01-01") then setnull(lstr_claim_base_data.laycan_start)
	if lstr_claim_base_data.laycan_end = datetime("1900-01-01") then setnull(lstr_claim_base_data.laycan_end)
	
	dw_claim_base.SetItem(1,"cp_date", lstr_claim_base_data.cp_date)
	dw_claim_base.SetItem(1,"cp_text", lstr_claim_base_data.cp_text)
	dw_claim_base.SetItem(1,"timebar_days",  lstr_claim_base_data.timebar_days)
	dw_claim_base.SetItem(1,"notice_days",  lstr_claim_base_data.noticebar_days)
	dw_claim_base.SetItem(1,"claims_laycan_start",  lstr_claim_base_data.laycan_start)
	dw_claim_base.SetItem(1,"claims_laycan_end",   lstr_claim_base_data.laycan_end)
	dw_claim_base.SetItem(1,"claims_address_com",  lstr_claim_base_data.address_com)
	dw_claim_base.SetItem(1,"office_nr",  lstr_claim_base_data.office_nr)
	dw_claim_base.SetItem(1,"offices_office_sn",  ls_office_sn)
	dw_claim_base.setitem(1, "notice_date", relativedate(date(ld_discharge_date), lstr_claim_base_data.noticebar_days))
	dw_claim_base.setitem(1, "timebar_date", relativedate(date(ld_discharge_date), lstr_claim_base_data.timebar_days))
	
/* Broker only set if one .If there are many brokers on CP then the clac. nvo shall not return a number > 0 */
	IF  li_broker_nr > 0 THEN
		dw_claim_base.SetItem(1,"claims_broker_com",  lstr_claim_base_data.broker_com)
		dw_claim_base.SetItem(1,"broker_nr",  li_broker_nr)
		dw_claim_base.SetItem(1,"brokers_broker_sn", ls_broker_sn)
		dw_claim_base.setitem(1, "claims_broker_com", ld_percent)
		if claim_type = "DEM" then
			if isnull(ls_claim_email) or trim(ls_claim_email) = "" then ls_claim_email = "no email address found in Brokers system table"
			dw_claim_base.setitem(1, "claims_claim_email", ls_claim_email)
		end if
		ib_broker_set = TRUE
	END IF
	
	if not (claim_type = "FRT" or claim_type = "DEM" or claim_type = "DES") then
		wf_claim_base_tabs(true)
	else
		wf_claim_base_tabs(false)
	end if
end if

li_dem_rows = dw_dem_des_claim.RowCount()

IF li_dem_rows = 1 THEN
	IF claim_type = "FRT" THEN		
		SELECT SUM(BOL_QUANTITY)
		INTO :bol_quantity
		FROM BOL
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :lstr_parametre.voyage_nr
		AND CHART_NR = :lstr_parametre.charter_nr
		AND CAL_CERP_ID = :lstr_parametre.cp_id
		AND L_D = 1
		USING SQLCA;

		IF IsNull(bol_quantity) THEN bol_quantity = 0 
		dw_freight_claim.SetItem(1,"bol_load_quantity",bol_quantity)
	ELSEIF claim_type = "DEM" THEN		
/* Only bol_quantity from those ports where there are Layt.St. When a new Layt.St. is generated 
   the claim is updated with bol_q, claim amount .This is done in Module LAYTIME. */
		SELECT SUM(BOL_QUANTITY)
		INTO :bol_quantity
		FROM BOL, LAYTIME_STATEMENTS
		WHERE BOL.VESSEL_NR = :ii_vessel_nr
		AND BOL.VOYAGE_NR = :lstr_parametre.voyage_nr
		AND BOL.CHART_NR = :lstr_parametre.charter_nr
		AND BOL.CAL_CERP_ID = :lstr_parametre.cp_id
		AND BOL.L_D = 1
		AND ( BOL.PCN = LAYTIME_STATEMENTS.PCN ) AND  
		        ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
       			( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
         		( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
         		( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR )
		USING SQLCA;

		IF IsNull(bol_quantity) THEN bol_quantity = 0 
		IF bol_quantity > 0 THEN dw_dem_des_claim.SetItem(li_counter,"dem_des_settled",1)
		dw_dem_des_claim.SetItem(1,"bol_load_quantity",bol_quantity)
	END IF
ELSEIF li_dem_rows > 1 THEN

	FOR li_counter = 1 TO li_dem_rows
	   ll_calcaioid = dw_dem_des_claim.GetItemNumber(li_counter,"calcaioid")
	   ls_dw_purpose = dw_dem_des_claim.GetItemString(li_counter,"dem_des_purpose")
	   SELECT PCN
	   INTO :li_pcn
	   FROM CD
	   WHERE CAL_CAIO_ID = :ll_calcaioid;
		IF ls_dw_purpose = "L" AND  SQLCA.SQLCode = 0 THEN	
			SELECT IsNull(SUM(BOL_QUANTITY),0)
			INTO :bol_quantity
			FROM BOL, LAYTIME_STATEMENTS
			WHERE BOL.VESSEL_NR = :ii_vessel_nr
			AND BOL.VOYAGE_NR = :lstr_parametre.voyage_nr
			AND BOL.CHART_NR = :lstr_parametre.charter_nr
			AND BOL.CAL_CERP_ID = :lstr_parametre.cp_id
			AND BOL.L_D = 1
			AND BOL.PORT_CODE = :ls_port_code
			AND BOL.PCN = :li_pcn
			AND ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
      				( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
      				( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
       				( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR )
			USING SQLCA;

			dw_dem_des_claim.SetItem(li_counter,"bol_load_quantity",bol_quantity)
		
	    ELSEIF ls_dw_purpose = "D"  AND  SQLCA.SQLCode = 0 THEN
		
			SELECT IsNull(SUM(BOL_QUANTITY),0)
			INTO :bol_quantity
			FROM BOL, LAYTIME_STATEMENTS
			WHERE BOL.VESSEL_NR = :ii_vessel_nr
			AND BOL.VOYAGE_NR = :lstr_parametre.voyage_nr
			AND BOL.CHART_NR = :lstr_parametre.charter_nr
			AND BOL.CAL_CERP_ID = :lstr_parametre.cp_id
			AND BOL.L_D = 0
			AND BOL.PORT_CODE = :ls_port_code
			AND BOL.PCN = :li_pcn
			AND ( BOL.PORT_CODE = LAYTIME_STATEMENTS.PORT_CODE ) AND  
      				( BOL.VESSEL_NR = LAYTIME_STATEMENTS.VESSEL_NR ) AND  
      				( BOL.VOYAGE_NR = LAYTIME_STATEMENTS.VOYAGE_NR ) AND  
       				( BOL.CHART_NR = LAYTIME_STATEMENTS.CHART_NR )
			USING SQLCA;

			dw_dem_des_claim.SetItem(li_counter,"bol_load_quantity",bol_quantity)
		END IF
		
	NEXT
END IF

IF claim_type = "DEM" AND ib_calc_yes_no THEN
	FOR li_counter = 1 TO li_dem_des_set
		wf_set_allowed(li_counter)
	NEXT
	
	if li_dem_des_set = 1 and dw_dem_des_claim.getitemstatus(1, "load_laytime_allowed", Primary!) = DataModified! and lstr_dem_des_data[1].d_other_allowed > 0 then
		dw_dem_des_claim.setitem(1, "load_laytime_allowed", dw_dem_des_claim.getitemdecimal(1, "load_laytime_allowed") + lstr_dem_des_data[1].d_other_allowed)
	end if
END IF

DESTROY uo_calc_nvo 
DESTROY uo_layt_ports


return 1

end function

public subroutine wf_dem_rate_tabs ();dw_dem_des_rates.SetTabOrder("dem_rate_day",10)
dw_dem_des_rates.Modify("dem_rate_day.Background.Mode = '0'")
dw_dem_des_rates.Modify("dem_rate_day.Background.Color = '15527148'")
dw_dem_des_rates.SetTabOrder("des_rate_day",20)
dw_dem_des_rates.Modify("des_rate_day.Background.Mode = '0'")
dw_dem_des_rates.Modify("des_rate_day.Background.Color = '15527148'")
dw_dem_des_rates.SetTabOrder("rate_hours",30)
dw_dem_des_rates.Modify("rate_hours.Background.Mode = '0'")
dw_dem_des_rates.Modify("rate_hours.Background.Color = '15527148'")
cb_dem_des_new_rate.Enabled = TRUE
cb_dem_des_delete_rate.Enabled = TRUE 

//lock dw_dem_des_rates when only one row (CR1224)
IF dw_dem_des_rates.rowcount( ) = 1 then
	dw_dem_des_rates.Modify("dem_rate_day.Protect='1'")
	dw_dem_des_rates.Modify("des_rate_day.Protect='1'")
	dw_dem_des_rates.Modify("rate_hours.Protect='1'")
else
	dw_dem_des_rates.Object.dem_rate_day.Background.Color='31775128'
	dw_dem_des_rates.Object.des_rate_day.Background.Color='31775128'
	dw_dem_des_rates.Object.rate_hours.Background.Color='31775128'
	dw_dem_des_rates.Modify("dem_rate_day.Protect='0'")
	dw_dem_des_rates.Modify("des_rate_day.Protect='0'")
	dw_dem_des_rates.Modify("rate_hours.Protect='0'")
end if
			
return
end subroutine

public subroutine wf_afc_add_lump_filter (integer row);dw_add_lumpsums_afc.SetFilter("afc_nr = "+String(row) )
dw_add_lumpsums_afc.Filter()
end subroutine

public subroutine documentation ();/********************************************************************
ObjectName: w_claims
<OBJECT>	Claims window, requires a refactor as soon as possible.</OBJECT>
<USAGE>	Used to generate new claims among other things	</USAGE>
<ALSO>	other Objects	</ALSO>
<HISTORY>
	Date    		CR-Ref	Author	Comments
	09/11/10		2191  	JSU   	Be able to create freight cliams with multi additional lumpsums when freight cliams is not the first claims
	17/01/11		2244  	AGL   	Added actions attachment process.  Makes use of 4 instance variables that need to be current at all times.
	        		    		      	It is not possible to create new attachments on a new claim that has not been created.
	23/02/11		2294  	AGL   	Added new user object u_claimbalance,  This replaces old object uo_claim_balance.  This new version 
	        		      	      	Calculates amounts for both local and usd currencies.  Uses n_currencycalc object.
	14/03/11		1549  	JSU   	Multi currencies
	31/03/11		2329  	JSU   	Bug fix
	31/03/11		2315  	JSU   	Bug fix
	21-11-11		2625  	CONASW	Changed office selection DW (to get active offices only)
	29/12/11		M5-2  	JMC   	Add discharge date to the structure s_vessel_voyage_chart_claim
	03/01/12		M5-2  	JMC   	Add ax invoice nr to the structure s_vessel_voyage_chart_claim
	09/01/12		M5-2  	JMC   	Create credit note, when claim is deleted.
	21/02/12		M5-6  	LGX001	1.add reload checkedbox to  reload bol quantity when calculation cagro freight type is Wordscale(WS:4)
	        		      	      	2.recalculation the broker commission when needed 
	30/03/12		M5-2  	JMC   	Disable creation of credit note when claim is deleted and AX invoice number is empty
	02/04/12		D-CALC	AGL027	Added new function wf_getkeydata() & event ue_reload() to assist C/P update
	        		      	      	when claim window is still open.
	18/04/12		M5-6  	JMC   	Add restriction on address commission that was deleted
	14/09/12		2934  	LGX001	Add ax_invoice_text field to claims
	29/10/12		2949  	LGX001	Add claim percentage field to claims
	31/10/12		2912  	LHC010	Add function wf_allow_linkcalcuation,if data has been modified but the update failed 
	        		    		      	or did not pass the validation the calculation window will not open.
	26/11/12		2828  	LGX001	1.it should be possible to deselect all brokers in the broker selection popup that shows up
	        		      	      	  when clicking the "?" button next to the broker name
	        		      	      	2.When no broker commission is being calculated, the claim should neither show a broker nor any commission.
	        		      	      	3.When changing a broker commission in a CP, the percentage should be changed too
	21/01/13		2877  	WWA048	Adjust the UI.
	29/04-13		CR3153	LHG008	Take CP date/Laycan/Office data automatically from the fixture for type Deviation, Heating and Misc.
	20/05-13		CR3096	LGX001	Set the claim email field from system table broker - broker email when creating DEM claim and changing broker nr
	11/06/13		CR2877	ZSW001	1. Add tooltip to charterer field; 2. when creating claims, set the cp id to claims.
	03/06/14		CR3525	KSH092	change Lumpsum length for large enough to show up to “99,999,999.99”
	16/06/14		CR3536	KSH092	the broker email address is update when claims update
	20/06/14		CR3700	LHG008	Delete CLAIM_SENT when deleting claims
	19/08/14		CR3717	XSZ004	1.Copy the 1st broker from CP window when creating claim
	        		      	      	2.Remove the button which open "select broker" window
	        		      	      	3.Disabled the "broker" textfield
	24/09/14		CR3721	CCY018	Press the Enter key will execute to select a vessel, instead of execute the default keyboard focus button
	29/09/15		CR3778	LHG008   Add Transaction C in Actions/Transactions window for FRT claims.
	18/02/16		CR4289	XSZ004	Remove Time field for HEA claim.
	20/04/16    CR2428   SSX014   Change demurrage currency
	15/06/16		CR4263	XSZ004	Fix a bug.
	03/08/16		CR4219	LHG008	Accuracy and improvement in DEM and DEV claims handling(CHO)(REF_CR4111).
	09/17/16    CR4226   SSX014   Make Bunker/Time/Lumpsum input configurable
	21/10/16		CR3320	AGL027	Voyage Master Transaction handling
	20/12/16		CR4420	XSZ004	Add responsible field. 
	10/03/17		CR4572	XSZ004	Drop-down list search-as-type case insensitive.
	10/04/17		CR4564	HHX010	When creating a new claim for a TC out voyage, the laycan should be 00-00-00 00:00 - 00-00-00 00:00.
	04/09/17		CR4176	LHG008	Users can change miscellaneous claim types in specific circumstances
	01/12/17		CR4630	LHG008	Invalid characters in invoice text
	</HISTORY>    
********************************************************************/

end subroutine

public function integer wf_enableactions (boolean ab_enabled);uo_att_actions.enabled = ab_enabled
//cb_new_action.enabled = ab_enabled
//cb_update_action.enabled = ab_enabled
//cb_delete_action.enabled = ab_enabled
//cb_cancel_action.enabled = ab_enabled
return c#return.Success
end function

public subroutine _lockcurrcode ();string ls_voyage_nr
long ll_charter_nr, ll_claim_nr
integer li_comm, li_transaction
boolean lbl_comm, lbl_trans

if dw_claim_base.rowcount() = 1 then
	ls_voyage_nr = dw_claim_base.getitemstring(1,"voyage_nr")
	ll_charter_nr = dw_claim_base.getitemnumber(1,"chart_nr")
	ll_claim_nr = dw_claim_base.getitemnumber(1,"claim_nr")	
	if dw_claim_base.getitemstring(1,"claim_type") <> "FRT"  and dw_claim_base.getitemstring(1,"claim_type") <> "DEM" then
		//check if there is commission already settled.
		SELECT COUNT(*)
		INTO :li_comm
		FROM COMMISSIONS 
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr
		AND CHART_NR = :ll_charter_nr
		AND CLAIM_NR = :ll_claim_nr
		AND COMM_SETTLED = 1;
		if sqlca.sqlcode = 0 then
			commit;
		else
			rollback;
		end if
		if li_comm > 0 then
			lbl_comm = true
		else
			lbl_comm = false		
		end if
		
		//check if there is any transactions(none address commission).
		SELECT COUNT(*)
		INTO :li_transaction
		FROM CLAIM_TRANSACTION 
		WHERE VESSEL_NR = :ii_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr
		AND CHART_NR = :ll_charter_nr
		AND CLAIM_NR = :ll_claim_nr
		AND C_TRANS_CODE <> "C";
		if sqlca.sqlcode = 0 then
			commit;
		else
			rollback;
		end if
		if li_transaction > 0 then
			lbl_trans = true
		else
			lbl_trans = false	
		end if	
		
		// lock/unlock currency code
		if lbl_trans or lbl_comm then
			dw_claim_base.SetTabOrder("curr_code",0)
			dw_claim_base.Modify("curr_code.Background.Mode = '1'")	
		else
			dw_claim_base.SetTabOrder("curr_code",140)
			dw_claim_base.Modify("curr_code.Background.Mode = '0'")	
		end if
	end if	
end if





end subroutine

public function integer wf_datawindow_modified (string claim_type);/********************************************************************
   wf_datawindow_modified
   <DESC>	Verify and save data	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.NoAction, don't need save	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		claim_type
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	11/01/2012   M5-2         ZSW001       Modified
   </HISTORY>
********************************************************************/

integer	li_return

CONSTANT string is_CONFIRMMESSAGE = "Data has been changed, but not saved.~r~n~r~nWould you like to save data ?"

choose case claim_type
	case "DEM", "DES"
		if dw_claim_base.accepttext() < 0 then return c#return.Failure
		if dw_dem_des_claim.accepttext() < 0 then return c#return.Failure
		if dw_dem_des_rates.accepttext() < 0 then return c#return.Failure
		
		if dw_claim_base.modifiedcount() > 0 or dw_dem_des_claim.modifiedcount() > 0 or dw_dem_des_rates.modifiedcount() > 0 then
			li_return = messagebox("Attempting to change DEM/DES Claim", is_CONFIRMMESSAGE, question!, yesno!, 1)
		end if
	case "FRT"
		if dw_claim_base.accepttext() < 0 then return c#return.Failure
		if dw_freight_claim.accepttext() < 0 then return c#return.Failure
		if dw_freight_received.accepttext() < 0 then return c#return.Failure
		
		if dw_claim_base.modifiedcount() > 0 or dw_freight_claim.modifiedcount() > 0 or &
			dw_freight_received.modifiedcount() > 0 or dw_freight_received.deletedcount() > 0 then
			li_return = messagebox("Attempting to change FRT Claim", is_CONFIRMMESSAGE, question!, yesno!, 1)
		end if
	case else
		if dw_claim_base.accepttext() < 0 then return c#return.Failure
		if dw_hea_dev_claim.accepttext() < 0 then return c#return.Failure
		
		if dw_claim_base.modifiedcount() > 0 or dw_hea_dev_claim.modifiedcount() > 0 then
			li_return = messagebox("Attempting to change DEV / HEA / MISC Claim", is_CONFIRMMESSAGE, question!, yesno!, 1)
		end if
end choose

if li_return = 2 then return c#return.NoAction

if li_return = 1 then
	if w_claims.event ue_update(0, 0) <= 0 then return c#return.Failure
end if

// next save actions
if uo_att_actions.dw_file_listing.accepttext() <> -1 then
	if uo_att_actions.dw_file_listing.modifiedcount() + uo_att_actions.dw_file_listing.deletedcount() > 0 then
		li_return = messagebox("Data Not Saved", "Actions modified but not saved~r~n~r~n Would you like to save data ?", question!, yesno!, 1)
		if li_return = 1 then
			if cb_update_action.event clicked() = c#return.Failure then 
				return c#return.Failure
			end if
		elseif li_return = 2 then
			return c#return.NoAction
		end if
	end if
end if

return c#return.Success

end function

public function integer wf_datawindow_modified ();/********************************************************************
   wf_datawindow_modified
   <DESC>	Verify and save data	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.NoAction, don't need save	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	12/01/2012   M5-2         ZSW001       First Version
   </HISTORY>
********************************************************************/

integer	li_return

CONSTANT string is_CONFIRMMESSAGE = "If you don't save pending changes on this claim before you print it, you might risk creating a wrong invoice. Do you want to continue and save the changes?"

dw_claim_base.accepttext()
uo_att_actions.dw_file_listing.accepttext()
dw_dem_des_rates.accepttext()
dw_hea_dev_claim.accepttext()
dw_freight_claim.accepttext()
dw_dem_des_claim.accepttext()
dw_freight_received.accepttext()

if dw_claim_base.modifiedcount() + &
	uo_att_actions.dw_file_listing.modifiedcount() + uo_att_actions.dw_file_listing.deletedcount() + &
	dw_dem_des_rates.modifiedcount() + &
	dw_hea_dev_claim.modifiedcount() + &
	dw_freight_claim.modifiedcount() + &
	dw_dem_des_claim.modifiedcount() + &
	dw_freight_received.modifiedcount() + dw_freight_received.deletedcount() > 0 then
	li_return = messagebox("Data Not Saved", is_CONFIRMMESSAGE, question!, yesno!)
end if

if li_return = 2 then return c#return.NoAction

if li_return = 1 then
	w_claims.triggerevent("ue_update")
	cb_update_action.event clicked()
end if

return c#return.Success

end function

public function decimal wf_get_comm_percent (long ai_vessel_nr, string as_voyage_nr, long al_broker_nr);/********************************************************************
   wf_get_comm_percent
   <DESC>	Get the commision percent of the broker	</DESC>
   <RETURN>	decimal </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		as_voyage_nr
		al_broker_nr
   </ARGS>
   <USAGE>	Suggest to use in the wf_new_claim function of the window.	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	23/02/2012   M5-6         ZSW001       First Version
   </HISTORY>
********************************************************************/

dec	ld_percent

SELECT CAL_COMM.CAL_COMM_PERCENT
  INTO :ld_percent
  FROM VOYAGES, CAL_CARG, CAL_COMM
 WHERE VOYAGES.CAL_CALC_ID  = CAL_CARG.CAL_CALC_ID AND
		 CAL_CARG.CAL_CERP_ID = CAL_COMM.CAL_CERP_ID AND
		 VOYAGES.VESSEL_NR    = :ai_vessel_nr AND
		 VOYAGES.VOYAGE_NR    = :as_voyage_nr AND
		 CAL_COMM.BROKER_NR   = :al_broker_nr;

return ld_percent

end function

public function integer wf_getkeydata (ref s_vessel_voyage_chart_claim astr_currentdata);/********************************************************************
   wf_getkeydata()
<DESC>   
	Implemented to be used when a charterer has changed in C/P data.  This function 
	gets the important data from the selected claim.
</DESC>
<RETURN>
	c#return.Success
	c#return.NoAction
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	s_vessel_voyage_chart_claim: astr_newdata
</ARGS>
<USAGE>
	business logic specific to C/P is left in cp object.  Expected process is to obtain data from window
	then manipulate according to implementation and then reload claims window using event ue_reload()
	if needed.
</USAGE>
********************************************************************/

long ll_getselectedrow

ll_getselectedrow = this.dw_list_claims.getselectedrow(0)

if ll_getselectedrow > 0 then
	astr_currentdata.vessel_nr = this.dw_list_claims.getitemnumber(ll_getselectedrow, "vessel_nr")
	astr_currentdata.voyage_nr  = this.dw_list_claims.getitemstring(ll_getselectedrow, "voyage_nr")
	astr_currentdata.chart_nr = this.dw_list_claims.getitemnumber(ll_getselectedrow, "chart_nr")
	astr_currentdata.claim_nr = ll_getselectedrow
	astr_currentdata.status = "OPEN"
	return c#return.Success	
else
	return c#return.NoAction	
end if

end function

public function boolean wf_allow_linkcalculation ();/********************************************************************
   wf_allow_linkcalculation
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
		When user use menu or shortcut key F9/F10 to link to Calculation, this will popup a message and 
		ask user to save the modified data first. In this case:
		1.)if user chooses Yes, and data is saved successfully, the calculation window will open
		2.)if user chooses Yes, but data saving is failed, it will popup whatever message it needs for user, and the calculation window will not open.
		3.)if user chooses No, data will not be saved, calculation window will open.	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31-10-2012 CR2912       LHC010        First Version
   </HISTORY>
********************************************************************/
s_vessel_voyage_chart_claim lstr_olddata
integer li_return

if not dw_list_claims.Enabled then
	li_return = wf_datawindow_modified(dw_claim_base.getitemstring(dw_claim_base.getrow(), "claim_type"))
	if li_return = c#return.failure then
		_ib_updatefailure = true
	elseif li_return = c#return.Noaction then
		_ib_updatefailure = false
		cb_cancel.triggerevent( "clicked" )
	elseif li_return = c#return.Success then
		_ib_updatefailure = false		
	end if
elseif wf_getkeydata(lstr_olddata) = c#return.Success then
	lstr_olddata.status = "VESSEL"
	this.event ue_reload(lstr_olddata)
end if
	
return not _ib_updatefailure
end function

public subroutine wf_new_dem_des ();/********************************************************************
   wf_new_dem_des
   <DESC>	New a Demurrage Claim	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	30/01/2013 CR2877       WWA048        First Version
	20/06/2016 CR4362		HHX010		Expected Receive % should match with the one defined in Claim Types system tables 	
   </HISTORY>
********************************************************************/

datetime	ld_dato
long		ll_ndays,ll_tdays
integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

li_return = wf_new_claim("DEM")
if li_return <= 0 then return		//M5-6 Added by ZSW001 on 23/02/2012.

cb_update.Default = TRUE
cb_unlock.enabled = false

IF dw_claim_base.RowCount() > 0 THEN
	ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
	ll_ndays = dw_claim_base.GetItemNumber(1,"notice_days")
	ll_tdays = dw_claim_base.GetItemNumber(1,"timebar_days")
	dw_claim_base.SetItem(1,"notice_date",RelativeDate(Date(ld_dato),ll_ndays))			
	dw_claim_base.SetItem(1,"timebar_date",RelativeDate(Date(ld_dato),ll_tdays))
	dw_claim_base.SetItem(1,"claims_expect_receive_pct", wf_get_expect_receive_percent('DEM'))
	uo_att_actions.dw_file_listing.reset()
END IF

wf_enableactions(false)

end subroutine

public subroutine wf_new_deviation ();/********************************************************************
   wf_new_deviation
   <DESC>	New a Deviation Claim	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	30/01/2013 CR2877       WWA048        First Version
   </HISTORY>
********************************************************************/

integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

wf_new_claim("DEV")
uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_update.Default = TRUE

cb_unlock.enabled = false

end subroutine

public subroutine wf_new_heating ();/********************************************************************
   wf_new_heating
   <DESC>	New a Heating Claim	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	30/01/2013 CR2877       WWA048        First Version
   </HISTORY>
********************************************************************/

integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

wf_new_claim("HEA")
uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_update.Default = TRUE

cb_unlock.enabled = false

end subroutine

public subroutine wf_new_freight ();/********************************************************************
   wf_new_freight
   <DESC>	New a Freight Claim	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30/01/2013 CR2877       WWA048             First Version
   </HISTORY>
********************************************************************/

datetime	ld_dato
long 		ll_ndays,ll_tdays
integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

li_return = wf_new_claim("FRT")
if li_return <= 0 then return

uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_update.Default = TRUE
cb_unlock.enabled = false

IF dw_claim_base.RowCount() > 0 THEN
	ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
	ll_ndays = dw_claim_base.GetItemNumber(1,"notice_days")
	ll_tdays = dw_claim_base.GetItemNumber(1,"timebar_days")
	dw_claim_base.SetItem(1,"notice_date",RelativeDate(Date(ld_dato),ll_ndays))			
	dw_claim_base.SetItem(1,"timebar_date",RelativeDate(Date(ld_dato),ll_tdays))
END IF

ibl_new = true

end subroutine

public subroutine wf_get_claim_email ();/********************************************************************
   wf_get_claim_email()
   <DESC>	the broker email address is update when claims update
   <RETURN>	
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	ue_update.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		16/06/14	CR3348        KSH092   First Version
   </HISTORY>
********************************************************************/

String  ls_claim_email,ls_claim_email_broker
Integer li_nr,li_row

li_row = dw_claim_base.GetRow()
if li_row < 1 then return
ls_claim_email = dw_claim_base.GetItemString(li_row,'claims_claim_email')

if isnull(ls_claim_email) or trim(ls_claim_email) = "" or ls_claim_email = "no email address found in Brokers system table" then
   li_nr = dw_claim_base.getitemnumber(li_row, "broker_nr")
	if not IsNull(li_nr) THEN
		SELECT  BROKER_EMAIL 
		INTO  :ls_claim_email_broker 
		FROM BROKERS 
		WHERE BROKER_NR = :li_nr;
		
		if IsNull(ls_claim_email_broker) or Trim(ls_claim_email_broker) = '' then
			ls_claim_email_broker = 'no email address found in Brokers system table'
		end if
		dw_claim_base.setitem(li_row, "claims_claim_email", ls_claim_email_broker)
	END IF	
end if
	
		

end subroutine

public subroutine wf_misc_contract (integer ai_vessel_nr, string as_voyage_nr, ref s_claim_base_data astr_claim_base_data);/********************************************************************
   wf_misc_contract
   <DESC> get all the possible information (C/P Date , Office, etc.) from the TC contract </DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		as_voyage_nr
		astr_claim_base_data
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		14/04/16 CR4251        HHX010   First Version
   </HISTORY>
********************************************************************/

string ls_port_code,ls_voyage_nr
long ll_pcn,ll_contract_id
datetime ldt_port_arrival_datetime
mt_n_datastore  lds_contract_detail
n_voyage lnv_voyage
dec ldec_utc_difference

lnv_voyage = create n_voyage
ls_voyage_nr = lnv_voyage.of_get_fullvoyagenr(as_voyage_nr)
destroy lnv_voyage

SELECT TOP 1 ISNULL(LT_TO_UTC_DIFFERENCE, 0)
INTO :ldec_utc_difference
FROM POC, VOYAGES
WHERE POC.VESSEL_NR = VOYAGES.VESSEL_NR 
AND POC.VOYAGE_NR = VOYAGES.VOYAGE_NR 
AND POC.PURPOSE_CODE = 'DEL' 
AND VOYAGES.FULL_VOYAGE_NR <= :ls_voyage_nr
AND VOYAGES.VESSEL_NR = :ai_vessel_nr 
ORDER BY VOYAGES.FULL_VOYAGE_NR DESC, POC.PORT_ARR_DT DESC;
	
if isnull(ldec_utc_difference) then ldec_utc_difference = 0

SELECT PORT_CODE,PCN
INTO :ls_port_code, :ll_pcn
FROM CARGO 
WHERE VESSEL_NR = :ai_vessel_nr AND
	VOYAGE_NR = :as_voyage_nr;

/* Select this port of calls arrival date */
SELECT PORT_ARR_DT
INTO :ldt_port_arrival_datetime
FROM POC
WHERE 	VESSEL_NR = :ai_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :ls_port_code AND
		PCN = :ll_pcn;

SELECT NTC_TC_CONTRACT.CONTRACT_ID
INTO :ll_contract_id
FROM NTC_TC_CONTRACT,   
		NTC_TC_PERIOD  
WHERE  NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID AND  
		NTC_TC_CONTRACT.VESSEL_NR = :ai_vessel_nr AND  
		NTC_TC_CONTRACT.TC_HIRE_IN = 0 AND  
		NTC_TC_PERIOD.PERIODE_START <= DATEADD(mi, :ldec_utc_difference * 60, :ldt_port_arrival_datetime) AND   
		NTC_TC_PERIOD.PERIODE_END > DATEADD(mi, :ldec_utc_difference * 60, :ldt_port_arrival_datetime);    

if ll_contract_id > 0 then
	lds_contract_detail = create mt_n_datastore
	lds_contract_detail.dataobject = 'd_tc_contract'
	lds_contract_detail.settransobject(sqlca)
	lds_contract_detail.retrieve(ll_contract_id)
	if lds_contract_detail.rowcount() > 0 then
		astr_claim_base_data.cp_date = lds_contract_detail.object.cp_date[1]
		astr_claim_base_data.cp_text = lds_contract_detail.object.cp_text[1]
		astr_claim_base_data.office_nr = lds_contract_detail.object.office_nr[1]	
		astr_claim_base_data.frt_curr_code =  lds_contract_detail.object.curr_code[1]
	else
		setnull(astr_claim_base_data.cp_date)
	end if
	destroy lds_contract_detail
else	
	setnull(astr_claim_base_data.cp_date)
end if



end subroutine

public function integer wf_check_lumpbrocom (integer ai_chartnr, integer ai_vesselnr, string as_voyagenr, integer ai_claimnr);/********************************************************************
   wf_check_lumpbrocom
   <DESC> Check if need to calculate lumpsum broker commission.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.NoAction, don't need save	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_chartnr
		ai_vesselnr
		as_voyagenr
		ai_claimnr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		15/06/16		CR3117		XSZ004		First Version.
   </HISTORY>
********************************************************************/

decimal{2} ld_ori_lumpsum, ld_cur_lumpsum
long ll_cal_cerpid
int  li_ret, li_count

li_ret = c#return.failure

if dw_claim_base.rowcount() > 0 then
	
	ll_cal_cerpid  = dw_claim_base.getitemnumber(1, "cal_cerp_id")
	
	SELECT COUNT(*) INTO: li_count 
	  FROM CAL_COMM, BROKERS 
	 WHERE CAL_COMM.BROKER_NR = BROKERS.BROKER_NR AND BROKERS.BROKER_POOL_MANAGER = 0 AND CAL_COMM.CAL_CERP_ID = :ll_cal_cerpid;
	 
	 if li_count > 0 then
		
		SELECT ISNULL(SUM(ADD_LUMPSUMS), 0) INTO :ld_ori_lumpsum     
		  FROM FREIGHT_CLAIM_ADD_LUMPSUMS  
		 WHERE ( CHART_NR = :ai_chartnr ) AND ( VESSEL_NR = :ai_vesselnr ) AND  
			  	 ( VOYAGE_NR = :as_voyagenr ) AND ( CLAIM_NR = :ai_claimnr ) AND 
		       FREIGHT_CLAIM_ADD_LUMPSUMS.BRO_COMM = 1; 
			
		ld_cur_lumpsum = dw_add_lumpsums.object.compute_brolumpsum[1]
		
		if ld_ori_lumpsum <> ld_cur_lumpsum then
			li_ret = c#return.success
		end if
	 end if
else
	li_ret = c#return.success
end if

return li_ret
end function

public function long wf_get_expect_receive_percent (string as_claimtype);/********************************************************************
   wf_get_expect_receive_percent
   <DESC> get "Expect Receive %" value </DESC>
   <RETURN> long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_claimtype
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		20/06/16 CR4362        HHX010   First Version
   </HISTORY>
********************************************************************/
long ll_expect_receive_pct

SELECT EXPECT_RECEIVE_PCT INTO :ll_expect_receive_pct 
FROM CLAIM_TYPES
WHERE CLAIM_TYPE = :as_claimtype;

if isnull(ll_expect_receive_pct) then
	if as_claimtype = 'DEM' then
		ll_expect_receive_pct = 95
	else
		ll_expect_receive_pct = 100
	end if
end if

return ll_expect_receive_pct
end function

private function integer wf_layout_misc_objects (string as_claim_type);long ll_flags[], ll_flagCount, ll_i, ll_gaps[], ll_groupCount, ll_count, ll_objectCount, ll_j
string ls_groups[], ls_objects[], ls_empty[]
mt_n_stringfunctions lnv_strfun
long ll_y, ll_totalHeight, ll_invisibleHeight
string ls_modify, ls_modifyResult
mt_n_datastore lds_temp

lds_temp = create mt_n_datastore
lds_temp.DataObject = "d_sq_ff_hea_dev_claim"

ll_flags[1] = il_bunker_visible
ll_flags[2] = il_time_visible
ll_flags[3] = il_lumpsum_visible
//ll_flags[4] = 1
ll_flagCount = UpperBound(ll_flags)

// y = 4
ls_groups[1]  = "hfo_ton_t,hfo_ton,t_3,hfo_price,t_7"
ls_groups[1] += ",do_ton_t,do_ton,t_4,do_price,t_8"
ls_groups[1] += ",t_1,go_ton,t_5,go_price,t_9"
ls_groups[1] += ",t_12,lshfo_ton,t_13,lshfo_price,t_14"
// y = 324
ls_groups[2]  = "t_2,hea_dev_hours,t_6,hea_dev_price_pr_day,t_10"
// y = 400
ls_groups[3]  = "t_15,lumpsum"
// y = 488
// ls_groups[4]  = "t_11,hea_dev_amount"  // the amount should always be invisible
ll_groupCount = UpperBound(ls_groups)

ll_gaps[1] = 0
for ll_i = 1 to ll_groupCount
	ls_objects[] = ls_empty[]
	lnv_strfun.of_parsetoarray(ls_groups[ll_i], ",", ls_objects[])
	ll_gaps[ll_i + 1] = long(lds_temp.describe(ls_objects[1] + ".y"))
next
ll_gaps[UpperBound(ll_gaps) + 1] = 80

for ll_i = ll_groupCount + 1 to 2 step -1
	ll_gaps[ll_i] = ll_gaps[ll_i] - ll_gaps[ll_i - 1]
next

if ll_flagCount > ll_groupCount then
	ll_count = ll_groupCount
else
	ll_count = ll_flagCount
end if

ll_totalHeight = ll_gaps[2]
ll_invisibleHeight = 0
for ll_i = 1 to ll_count
	
	ls_objects[] = ls_empty[]
	lnv_strfun.of_parsetoarray(ls_groups[ll_i], ",", ls_objects[])
	
	ll_objectCount = UpperBound(ls_objects[])
	
	for ll_j = 1 to ll_objectCount
		if ll_flags[ll_i] = 1 then
			ls_modify = ls_objects[ll_j] + ".visible=1"
		else
			ls_modify = ls_objects[ll_j] + ".visible=0"
		end if
		ls_modifyResult = dw_hea_dev_claim.modify(ls_modify)
	next
	
	if ll_flags[ll_i] = 1 then
		ll_totalHeight += ll_gaps[ll_i + 2]
	else
		ll_invisibleHeight += ll_gaps[ll_i + 2]
	end if
	
	if ll_flags[ll_i] = 1 then
		for ll_j = 1 to ll_objectCount
			ll_y = long( lds_temp.describe(ls_objects[ll_j] + ".y") )
			ll_y -= ll_invisibleHeight
			ls_modify = ls_objects[ll_j] + ".y=" + string(ll_y)
			ls_modifyResult = dw_hea_dev_claim.modify(ls_modify)
		next
	end if
next

ls_modifyResult = dw_hea_dev_claim.modify("datawindow.detail.height=" + string(ll_totalHeight + 4 + 16))

dw_hea_dev_claim.height = ll_totalHeight + 4 + 16
gb_dev_claim.height     = ll_totalHeight + 64 + 8 + 16 + 4

if il_lumpsum_visible = 1 and not (il_bunker_visible = 1 or il_time_visible = 1) then
	ls_modifyResult = dw_hea_dev_claim.modify("lumpsum.Background.Mode=0")
	ls_modifyResult = dw_hea_dev_claim.modify("lumpsum.Background.Color=" + string(c#color.MT_MAERSK))
else
	ls_modifyResult = dw_hea_dev_claim.modify("lumpsum.Background.Mode=0")
	ls_modifyResult = dw_hea_dev_claim.modify("lumpsum.Background.Color=" + string(c#color.White))
end if

if il_lumpsum_visible = 1 and not ( il_bunker_visible = 1 or il_time_visible = 1 ) then
	dw_claim_base.SetTabOrder("claim_amount", 900)
	dw_claim_base.modify("claim_amount.background.mode = '0'")
	dw_claim_base.modify("claim_amount.background.color = '" + string(c#color.MT_MAERSK) + "'")
else
	dw_claim_base.SetTabOrder("claim_amount", 0)
	dw_claim_base.modify("claim_amount.background.mode = '1'")
end if

destroy lds_temp
return 1

end function

public subroutine wf_new_misc (string as_claim_type);/********************************************************************
   wf_new_misc
   <DESC>	New a Misc Claim	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date       CR-Ref       Author        Comments
		30/01/2013 CR2877       WWA048        First Version
		05/09/2016 CR4226       SSX014
		04/09/17   CR4176       LHG008        Users can change miscellaneous claim types in specific circumstances
   </HISTORY>
********************************************************************/

integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

dw_hea_dev_claim.reset()

wf_new_claim(as_claim_type)
uo_att_actions.dw_file_listing.reset()

wf_enableactions(false)
cb_unlock.enabled = false
cb_update.Default = TRUE

end subroutine

private function boolean of_isexclusivenull (any la_a, any la_b);if isnull(la_a) and isnull(la_b) then
	return false
end if

if not isnull(la_a) and not isnull(la_b) then
	return false
end if

return true

end function

public function integer wf_get_misc_options (string as_claim_type, ref long al_bunker, ref long al_lumpsum, ref long al_ctime);
SELECT BUNKER_VISIBLE, LUMPSUM_VISIBLE, TIME_VISIBLE
	INTO :al_bunker, :al_lumpsum, :al_ctime
FROM CLAIM_TYPES
WHERE CLAIM_TYPES.CLAIM_TYPE = :as_claim_type;

IF SQLCA.SQLCode = 0 then
	return c#return.Success
end if

return c#return.Failure

end function

public function integer wf_validate_misc ();/********************************************************************
   wf_validate_misc
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		12/10/16 CR4226        SSX014   First Version
		13/09/17 CR4176        LHG008   Users can change miscellaneous claim types in specific circumstances
   </HISTORY>
********************************************************************/

string ls_group[], ls_objects_tocheck, ls_objectarray[]
mt_n_stringfunctions lnv_string
long ll_i
string ls_message, ls_claim_type
n_messagebox lnv_msgbox

// check if claim type is change and the claim/brocker commissions has been sent to AX
ls_claim_type = dw_claim_base.getitemstring(1, COLUMN_CLAIM_TYPE)
if ls_claim_type <> dw_claim_base.getitemstring(1, COLUMN_CLAIM_TYPE, Primary!, true) then
	ls_message = wf_checkclaimcommsent()
	if len(ls_message) > 0 then
		lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
				"You cannot change the claim type, because " + ls_message, this)
		return -1	
	end if
end if

if dw_hea_dev_claim.AcceptText() < 0 then return -1	

// only lumpsum is selected
if il_lumpsum_visible = 1 and not (il_bunker_visible = 1 or il_time_visible = 1) then
	if isnull(dw_claim_base.GetItemNumber(1,"claim_amount")) then
		lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
			"You must type a claim amount.", this)
		dw_claim_base.setcolumn("claim_amount")
		dw_claim_base.SetFocus()
		Return(-1)
	else
		return 1
	end if
end if

ls_group[1] = "hfo_ton,hfo_price,do_ton,do_price,go_ton,go_price,lshfo_ton,lshfo_price,"
ls_group[2] = "hea_dev_hours,hea_dev_price_pr_day,"
ls_group[3] = "lumpsum,"

ls_objects_tocheck = ""
if il_bunker_visible = 1 then
	ls_objects_tocheck += ls_group[1]
end if
if il_time_visible = 1 then
	ls_objects_tocheck += ls_group[2]
end if
if il_lumpsum_visible = 1 then
	ls_objects_tocheck += ls_group[3]
end if
ls_objects_tocheck = left(ls_objects_tocheck, len(ls_objects_tocheck) - 1)

lnv_string.of_parsetoarray(ls_objects_tocheck,",",ls_objectarray[])
for ll_i = 1 to UpperBound(ls_objectarray)
	if not isnull(dw_hea_dev_claim.getitemnumber(1, ls_objectarray[ll_i])) then
		exit
	end if
next
if ll_i > UpperBound(ls_objectarray) then
	if il_lumpsum_visible = 1 then
		ls_message = "You must type unit and unit cost or lumpsum amount in the Breakdown box."
	else
		ls_message = "You must type unit and unit cost in the Breakdown box."
	end if
	lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, ls_message, this)
	dw_hea_dev_claim.SetFocus()
	Return(-1)
end if

//
// Check om en af de mulige kombinationer er indtastet
//
if il_bunker_visible = 1 then
	IF of_isexclusivenull(dw_hea_dev_claim.GetItemNumber(1,"hfo_ton"), dw_hea_dev_claim.GetItemNumber(1,"hfo_price")) OR &
		of_isexclusivenull(dw_hea_dev_claim.GetItemNumber(1,"do_ton"), dw_hea_dev_claim.GetItemNumber(1,"do_price")) OR &
		of_isexclusivenull(dw_hea_dev_claim.GetItemNumber(1,"go_ton"), dw_hea_dev_claim.GetItemNumber(1,"go_price")) OR &
		of_isexclusivenull(dw_hea_dev_claim.GetItemNumber(1,"lshfo_ton"), dw_hea_dev_claim.GetItemNumber(1,"lshfo_price")) THEN
		lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
			"You must type unit and unit cost in the Breakdown box.", this)
		dw_hea_dev_claim.SetFocus()
		Return(-1)
	END IF
end if

if il_time_visible = 1 then
	if of_isexclusivenull(dw_hea_dev_claim.GetItemNumber(1,"hea_dev_hours"), dw_hea_dev_claim.GetItemNumber(1,"hea_dev_price_pr_day")) then
		lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
			"You must type unit and unit cost in the Breakdown box.", this)
		dw_hea_dev_claim.SetFocus()
		return -1
	end if
end if

return 1

end function

public subroutine wf_filtermisctype ();/********************************************************************
   wf_filtermisctype
   <DESC>	Filter out the incompatible claim types	</DESC>
   <RETURN>	(None) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		04/09/17 CR4176        LHG008   First Version
   </HISTORY>
********************************************************************/

datawindowchild ldwc_misctype
decimal ld_value
string ls_filter, ls_type
constant string ls_CONNECTOR = " and "

if dw_claim_base.getchild(COLUMN_CLAIM_TYPE, ldwc_misctype) = 1 then
	if dw_hea_dev_claim.rowcount() > 0 and dw_hea_dev_claim.accepttext() = 1 then
		if il_bunker_visible = 1 then
			if not(isnull(dw_hea_dev_claim.getitemnumber(1, "hfo_ton")) and isnull(dw_hea_dev_claim.getitemnumber(1, "hfo_price")) and &
				isnull(dw_hea_dev_claim.getitemnumber(1, "do_ton")) and isnull(dw_hea_dev_claim.getitemnumber(1, "do_price")) and &
				isnull(dw_hea_dev_claim.getitemnumber(1, "go_ton")) and isnull(dw_hea_dev_claim.getitemnumber(1, "go_price")) and &
				isnull(dw_hea_dev_claim.getitemnumber(1, "lshfo_ton")) and isnull(dw_hea_dev_claim.getitemnumber(1, "lshfo_price"))) then
				ls_filter += ls_CONNECTOR + "bunker_visible = 1"
			end if
		end if
		
		if il_lumpsum_visible = 1 then
			if not isnull(dw_hea_dev_claim.getitemnumber(1, "lumpsum")) then
				ls_filter += ls_CONNECTOR + "lumpsum_visible = 1"
			end if
		end if
		
		if il_time_visible = 1 then
			if not(isnull(dw_hea_dev_claim.getitemnumber(1, "hea_dev_hours")) and isnull(dw_hea_dev_claim.getitemnumber(1, "hea_dev_price_pr_day"))) then
				ls_filter += ls_CONNECTOR + "time_visible = 1"
			end if
		end if
	end if
	if dw_claim_base.getrow() > 0 then
		ls_type = dw_claim_base.getitemstring(dw_claim_base.getrow(), 'claim_type')
		if trim(ls_type) <> '' or not isnull(ls_type) then
		   ls_filter += ls_CONNECTOR + "(activate = 1 or claim_type = '"+ls_type+"')"
		else
		   ls_filter += ls_CONNECTOR + "activate = 1 "
		end if
	else
		ls_filter += ls_CONNECTOR + "activate = 1 "
	end if
	if len(ls_filter) > 0 then ls_filter = mid(ls_filter, len(ls_CONNECTOR))
	
	ldwc_misctype.setfilter(ls_filter)
	ldwc_misctype.filter()
	
	dw_claim_base.setcolumn("claim_type")
end if
end subroutine

public function boolean wf_ismiscclaims (string as_type);/********************************************************************
   wf_ismiscclaims
   <DESC>	Check the claim whether is a miscellaneous claim or not	</DESC>
   <RETURN>	boolean:
            <LI> true: miscellaneous claim
            <LI> false: not miscellaneous claim	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_type
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/09/17 CR4176        LHG008   First Version
   </HISTORY>
********************************************************************/

integer li_misc_claim

select MISC_CLAIM
  into :li_misc_claim
  from CLAIM_TYPES
 where CLAIM_TYPE = :as_type;

if li_misc_claim = 1 then
	return true
else
	return false
end if
end function

public subroutine wf_enablemisctype ();/********************************************************************
   wf_enablemisctype
   <DESC>	If it is a misc claims, enable the type field in specific circumstances	</DESC>
   <RETURN>	(none) </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		04/09/17 CR4176        LHG008   First Version
   </HISTORY>
********************************************************************/

string  ls_claim_type, ls_tooltip

dw_claim_base.SetTabOrder("claim_type", 0)
dw_claim_base.modify("claim_type.tooltip.enabled = '0' claim_type.tooltip.delay.initial = '1000'")
dw_claim_base.modify("claim_type.background.mode = '1'")
dw_claim_base.modify("claim_type.background.color = '" + string(c#color.MT_FORMDETAIL_BG) + "'")

ls_claim_type = dw_claim_base.getitemstring(1, "claim_type")

//Enable if the type is misc claims and the claim/commissions has not been sent to AX and has not been locked
if wf_ismiscclaims(ls_claim_type) then
	ls_tooltip = wf_checkclaimcommsent()
	if len(ls_tooltip) > 0 then
		dw_claim_base.modify("claim_type.tooltip.enabled = '1' claim_type.tooltip.tip = 'You cannot change the claim type, because " + ls_tooltip + "'")
		return
	end if
	
	dw_claim_base.SetTabOrder("claim_type", 9)
	dw_claim_base.modify("claim_type.background.mode = '0'")
	dw_claim_base.modify("claim_type.background.color = '" + string(c#color.MT_MAERSK) + "'")
end if
end subroutine

public function string wf_checkclaimcommsent ();/********************************************************************
   wf_checkclaimcommsent
   <DESC>	Check whether the claim has been send to AX/broker commission has been settled or not.	</DESC>
   <RETURN>	string:
            <LI> '', not sent/settled
            <LI> length > 0, sent/settled	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	call by function wf_enablemisctype() and wf_validate_misc() 	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		13/09/17 CR4176        LHG008   First Version
   </HISTORY>
********************************************************************/

string  ls_voyage_nr
long    ll_vessel_nr, ll_chart_nr
integer li_claim_nr, li_claim_sent, li_comm_settled

if dw_claim_base.rowcount() = 0 then return ''

ll_vessel_nr = dw_claim_base.getitemnumber(1, "vessel_nr")
ls_voyage_nr = dw_claim_base.getitemstring(1, "voyage_nr")
ll_chart_nr = dw_claim_base.getitemnumber(1, "chart_nr")
li_claim_nr = dw_claim_base.getitemnumber(1, "claim_nr")

select COUNT(1)
  into :li_claim_sent
  from CLAIM_SENT
 where CHART_NR = :ll_chart_nr
	and VESSEL_NR = :ll_vessel_nr
	and VOYAGE_NR = :ls_voyage_nr
	and CLAIM_NR = :li_claim_nr;

if li_claim_sent = 0 then
	select count(COMM_SETTLED)
	  into :li_comm_settled
	  from COMMISSIONS
	 where CHART_NR = :ll_chart_nr
		and VESSEL_NR = :ll_vessel_nr
		and VOYAGE_NR = :ls_voyage_nr
		and CLAIM_NR = :li_claim_nr
		and COMM_SETTLED = 1;
end if

if li_claim_sent > 0 or li_comm_settled > 0 then return "either claim data has been sent to AX or broker commission has been settled."

end function

event ue_update;integer li_claim_nr = 0, li_chart_nr,li_dem_counter, li_dem_rows, li_lump
string ls_voyage_nr, ls_claim_type, ls_text, ls_voyage_notes, ls_copy, ls_update_voyage_notes, &
       ls_old_claimtype, ls_rollback = "rollback transaction"
long ll_no_of_rows=0, xx, ll_row, ll_businessunit
boolean lb_new_claim = FALSE, lb_update_ok = FALSE, lb_new_amount = FALSE
decimal {2} freight_balance,  ld_amount_usd, ld_amount, ld_amount_claim, ld_amount_claim_usd
decimal {2} ld_old_adr_comm, ld_add_comm
uo_calc_dem_des_claims uo_calc_dem
uo_auto_commission uo_auto_comm
s_calc_claim lstr_parm
integer li_pc_nr, li_number_of_dem_ports
Double ldo_cp_id_comm
u_addr_commission lnv_calc_adrcomm
string	ls_old_created_by, ls_cur_net_freight
n_claimcurrencyadjust lnv_claimcurrencyadjust
integer li_vessel_nr
long ll_cerp_id
string ls_curr_code

IF wf_validate_claims() = -1 THEN Return 0

ld_old_adr_comm = dw_claim_base.GetItemDecimal(1,"claims_address_com", Primary!, true)
ls_old_created_by = dw_claim_base.GetItemString(1,"claims_created_by", Primary!, true)
ls_voyage_nr = dw_claim_base.GetItemString(1,"voyage_nr")
li_chart_nr = dw_claim_base.GetItemNumber(1,"chart_nr")
li_vessel_nr = dw_claim_base.GetItemNumber(1,"vessel_nr")
ls_curr_code = dw_claim_base.GetItemString(1,COLUMN_CURRENCY_CODE)
ls_claim_type = dw_claim_base.GetItemString(1,COLUMN_CLAIM_TYPE)
ll_cerp_id = dw_claim_base.GetItemNumber(1,COLUMN_CP_ID)

//get broker claim_email
wf_get_claim_email()
//end 

IF dw_claim_base.GetItemStatus(1,0,PRIMARY!) = New! OR  dw_claim_base.GetItemStatus(1,0,PRIMARY!) = NewModified! THEN
	SELECT MAX(CLAIM_NR)
		INTO :li_claim_nr
		FROM CLAIMS
		WHERE VESSEL_NR = :li_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr;

	COMMIT USING SQLCA;
	
	IF IsNull(li_claim_nr) THEN
		li_claim_nr = 1
	ELSE
		li_claim_nr = li_claim_nr + 1
	END IF

	// file attachments actions needs the instance variables to be up to date.
	il_charter_nr = li_chart_nr	
	ii_claim_nr = li_claim_nr
	is_voyage_nr =  ls_voyage_nr
	lb_new_claim = TRUE

	/* UPDATE STATEMENTS IF NEW CLAIM */
	dw_claim_base.SetItem(1,"claim_nr",li_claim_nr)
	
	CHOOSE CASE dw_claim_base.GetItemString(1,"claim_type")
		CASE "DEM", "DES"
			li_number_of_dem_ports = dw_dem_des_claim.RowCount()
			li_dem_rows = dw_dem_des_claim.RowCount()
			FOR li_dem_counter = 1 TO li_dem_rows 
				dw_dem_des_claim.SetItem(li_dem_counter,"claim_nr",li_claim_nr)
			NEXT
			dw_dem_des_rates.SetItem(1,"claim_nr",li_claim_nr)
			IF lb_new_claim THEN
				dw_dem_des_rates.SetFilter("")
				dw_dem_des_rates.Filter()	
				ll_no_of_rows = dw_dem_des_rates.RowCount()
				IF ll_no_of_rows > 1 THEN
					FOR xx = 2 TO ll_no_of_rows 
						dw_dem_des_rates.SetItem(xx,"claim_nr",li_claim_nr)
					NEXT
				END IF
			END IF
			IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
				IF dw_dem_des_claim.Update(TRUE, FALSE) = 1 THEN
					IF dw_dem_des_rates.Update(TRUE, FALSE) = 1 THEN
						dw_claim_base.ResetUpdate()
						dw_dem_des_claim.ResetUpdate()
						dw_dem_des_rates.ResetUpdate()
						COMMIT USING SQLCA;
						IF SQLCA.SQLCode = 0 THEN	
							SELECT PC_NR
								INTO :li_pc_nr
								FROM VESSELS
								WHERE VESSEL_NR = :li_vessel_nr;
							COMMIT USING SQLCA;	
							uo_calc_dem = CREATE uo_calc_dem_des_claims
							IF (li_pc_nr = 3 OR li_pc_nr = 5) THEN
								IF li_number_of_dem_ports < 2 THEN	
									lstr_parm = uo_calc_dem.uf_get_bulk_amount(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)
								ELSE
									lstr_parm = uo_calc_dem.uf_get_bulk_amount_ports(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)
								END IF
							ELSE
								IF  li_number_of_dem_ports < 2 THEN	
									lstr_parm = uo_calc_dem.uf_get_tank_amount(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)
								ELSE
									lstr_parm = uo_calc_dem.uf_get_tank_amount_ports(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)			
								END IF
							END IF	
							DESTROY uo_calc_dem
							ld_amount = lstr_parm.claim_amount
							dw_claim_base.SetItem(1,"claim_amount", ld_amount)
							lnv_claimcurrencyadjust.of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_amount, ld_amount_usd)
							dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
							dw_claim_base.Update()
							COMMIT;
							wf_enabled_buttons("UPDATE")
						END IF
					ELSE
						ROLLBACK;
					END IF
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
		wf_dem_scroll()
		CASE "FRT"
			IF lb_new_claim THEN
				ll_no_of_rows = dw_freight_received.RowCount()
				IF ll_no_of_rows > 1 THEN
					FOR xx = 2 TO ll_no_of_rows 
						dw_freight_received.SetItem(xx,"claim_nr",li_claim_nr)
					NEXT
				END IF
			END IF
			dw_freight_claim.SetItem(1,"claim_nr",li_claim_nr)
			for li_lump = 1 to dw_add_lumpsums.rowcount()
				dw_add_lumpsums.SetItem(li_lump,"claim_nr",li_claim_nr)	
			next
			dw_freight_received.SetItem(1,"claim_nr",li_claim_nr)
			IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
				IF dw_freight_claim.Update(TRUE, FALSE) = 1 THEN
					IF  dw_add_lumpsums.Update(TRUE, FALSE) = 1 THEN
						
						//M5-6  Added by LGX001 on 15/02/2012.
						uo_frt_balance.uf_set_bol_quantity_reload(false, false)
						
						freight_balance = uo_frt_balance.uf_calculate_balance(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)	
						ld_amount = freight_balance						
						dw_claim_base.SetItem(1,"claim_amount", ld_amount)
						lnv_claimcurrencyadjust.of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_amount, ld_amount_usd)
						dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
						IF dw_freight_received.Update(TRUE, FALSE) = 1 THEN
							dw_claim_base.ResetUpdate()
							dw_freight_claim.ResetUpdate()
							dw_add_lumpsums.ResetUpdate()
							dw_freight_received.ResetUpdate()
							COMMIT;
	
							IF SQLCA.SQLCode = 0 THEN
								freight_balance = uo_frt_balance.uf_calculate_balance(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)			
								ld_amount = freight_balance
								dw_claim_base.SetItem(1,"claim_amount", ld_amount)
								lnv_claimcurrencyadjust.of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_amount, ld_amount_usd)
								dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
								dw_claim_base.Update()
							End if
								COMMIT;
								uo_auto_comm.of_generate(li_vessel_nr,ls_voyage_nr,li_chart_nr,li_claim_nr,"FRT","NEW",ldo_cp_id_comm)
								wf_enabled_buttons("UPDATE")
						ELSE
							ROLLBACK;
						END IF
					else
						ROLLBACK;
					END IF
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF

		CASE ELSE
			dw_hea_dev_claim.SetItem(1,"claim_nr",li_claim_nr)
			IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
				IF dw_hea_dev_claim.Update(TRUE, FALSE) = 1 THEN
					dw_claim_base.ResetUpdate()
					dw_hea_dev_claim.ResetUpdate()
					COMMIT;
					dw_claim_base.SetTabOrder("claim_type",0)
					dw_claim_base.modify("claim_type.background.mode = '1'")
					IF SQLCA.SQLCode = 0 THEN 
						ld_amount = dw_hea_dev_claim.GetItemNumber(1,"hea_dev_amount")
						dw_claim_base.SetItem(1,"claim_amount", ld_amount)
						if lnv_claimcurrencyadjust.of_getamountusd(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_amount , ld_amount_usd) = c#return.Failure then
							_addmessage( this.classdefinition, "ue_update", "Error updating the claims, please try again!", SQLCA.SQLErrText)
							dw_claim_base.reselectrow(1)
							return 0
						end if
						dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
						dw_claim_base.Update()
						COMMIT;
						ld_add_comm = uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ls_claim_type, "NEW",ldo_cp_id_comm)
						If ld_add_comm <> -1 Then
							dw_claim_base.SetItem(1,"claims_address_com",ld_add_comm)
							dw_claim_base.SetItem(1,"claims_cp_id_comm",ldo_cp_id_comm)
							dw_claim_base.Update()
							COMMIT;						
						End if
						
						wf_enabled_buttons("UPDATE")
					END IF
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
	END CHOOSE

	TriggerEvent("ue_retrieve")
	ll_row = dw_list_claims.Find("claim_nr="+string(li_claim_nr)+" and voyage_nr='"+ls_voyage_nr+"'",1,dw_list_claims.RowCount())
	dw_list_claims.SelectRow(ll_row,TRUE)
	dw_list_claims.ScrollToRow(ll_row)
	/* START - Updates address commission */
	lnv_calc_adrcomm = create u_addr_commission
	if lnv_calc_adrcomm.of_add_com(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr) = -1 then
		rollback;
	else
		commit;
	end if
	destroy lnv_calc_adrcomm
	/* END - Updates address commission */
ELSE /* UPDATE STATEMENTS IF MODIFIED CLAIM */
	li_claim_nr = dw_claim_base.GetItemNumber(1,"claim_nr")
	ld_amount_claim     = dw_claim_base.getitemdecimal(1, "claim_amount", Primary!, true)
	ld_amount_claim_usd = dw_claim_base.getitemdecimal(1, "claim_amount_usd", Primary!, true)
	if isnull(ld_amount_claim) then ld_amount_claim = 0 
	if isnull(ld_amount_claim_usd) then ld_amount_claim_usd = 0 
	CHOOSE CASE dw_claim_base.GetItemString(1,"claim_type")
		CASE "DEM", "DES"
			li_number_of_dem_ports = dw_dem_des_claim.RowCount()
			IF dw_dem_des_rates.Update(TRUE, FALSE) = 1 THEN
				IF dw_dem_des_claim.Update(TRUE, FALSE) = 1 THEN
					SELECT PC_NR
						INTO :li_pc_nr
						FROM VESSELS
						WHERE VESSEL_NR = :li_vessel_nr;
					uo_calc_dem = CREATE uo_calc_dem_des_claims
					IF (li_pc_nr = 3 OR li_pc_nr = 5) THEN
						IF li_number_of_dem_ports < 2 THEN	
							lstr_parm = uo_calc_dem.uf_get_bulk_amount(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)
						ELSE
							lstr_parm = uo_calc_dem.uf_get_bulk_amount_ports(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)
						END IF
					ELSE
						IF  li_number_of_dem_ports < 2 THEN	
							lstr_parm = uo_calc_dem.uf_get_tank_amount(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)
						ELSE
							lstr_parm = uo_calc_dem.uf_get_tank_amount_ports(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr)			
						END IF	
					END IF
					DESTROY uo_calc_dem
					ld_amount = lstr_parm.claim_amount
					
					//M5-6 Modified by LGX001 on 20/02/2012.
					if isnull(ld_amount) then ld_amount = 0
					if abs(ld_amount_claim - ld_amount) > 0.1 then 	ib_claim_amount_changed = true
					
					dw_claim_base.SetItem(1, "claim_amount", ld_amount)
					lnv_claimcurrencyadjust.of_getclaimamounts(li_vessel_nr, ls_voyage_nr, li_chart_nr,li_claim_nr, ld_amount, ld_amount_usd, false)
					if isnull(ld_amount_usd) then ld_amount_usd = 0 
					if abs(ld_amount_claim_usd - ld_amount_usd) > 0.1 then ib_claim_amount_usd_changed = true
					dw_claim_base.SetItem(1,"claim_amount_usd", ld_amount_usd)
					
					
					IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
						dw_claim_base.ResetUpdate()						
						dw_dem_des_claim.ResetUpdate()
						dw_dem_des_rates.ResetUpdate()
						COMMIT;
						
						//M5-6 Modified by LGX001 on 20/02/2012. 
						if ib_claim_amount_changed then
							ib_claim_amount_changed = false
							uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, "DEM", "OLD",ldo_cp_id_comm)
						else
							if ib_claim_amount_usd_changed then
								ib_claim_amount_usd_changed = false
								uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, "DEM", "OLD",ldo_cp_id_comm, true)
							end if
						end if
						
					ELSE
						ROLLBACK;
					END IF
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
			
		CASE "FRT"
			IF dw_freight_received.Update(TRUE, FALSE) = 1 THEN
				IF dw_freight_claim.Update(TRUE, FALSE) = 1 THEN 
					
					if wf_check_lumpbrocom(li_chart_nr, li_vessel_nr, ls_voyage_nr, li_claim_nr) = c#return.success then
						ib_claim_amount_changed = true
					end if
					
					IF dw_add_lumpsums.Update(TRUE, FALSE) = 1 THEN
						
						//M5-6 Added by LGX001 on 15/02/2012.
						uo_frt_balance.uf_set_bol_quantity_reload(false, false)
						
						freight_balance = uo_frt_balance.uf_calculate_balance(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)
						ls_cur_net_freight = uo_frt_balance.st_net_freight.text
						
						ld_amount = freight_balance
					 	dw_claim_base.SetItem(1,"claim_amount",ld_amount)
						lnv_claimcurrencyadjust.of_getclaimamounts(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ld_amount, ld_amount_usd, false)
						dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
						IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
							dw_claim_base.ResetUpdate()
							dw_freight_claim.ResetUpdate()
							dw_add_lumpsums.ResetUpdate()
							dw_freight_received.ResetUpdate()
							COMMIT;
	
							IF SQLCA.SQLCode = 0 THEN
								uo_frt_balance.uf_set_bol_quantity_reload(false, false)
								freight_balance = uo_frt_balance.uf_calculate_balance(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)	
								ld_amount = freight_balance
								
								//M5-6 Modified by LGX001 on 20/02/2012.
								if isnull(ld_amount) then ld_amount = 0 
								dw_claim_base.SetItem(1, "claim_amount", ld_amount)										
							
								lnv_claimcurrencyadjust.of_getclaimamounts(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ld_amount, ld_amount_usd, false)
								dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
								if isnull(ld_amount_usd) then ld_amount_usd = 0
								dw_claim_base.Update()
							End if
							commit;						
							
							//M5-6 Modified by LGX001 on 20/02/2012. 
							if is_ori_net_freight <> ls_cur_net_freight or ib_claim_amount_changed then
								ib_claim_amount_changed = false
								is_ori_net_freight = ls_cur_net_freight
								uo_auto_comm.of_generate(li_vessel_nr,ls_voyage_nr,li_chart_nr,li_claim_nr,"FRT","OLD",ldo_cp_id_comm)
							end if
							
							
							// Investigate if there was a change to the address commission %
							If ld_old_adr_comm <> dw_claim_base.GetItemDecimal(1,"claims_address_com") Then
								// We construct the text we want to insert
								ls_text=" ~r~n~r~nSystem Message: On voyage "+is_voyage_nr+" for vessel no = "+string(li_vessel_nr) +&
									" and claim no = "+string(li_claim_nr)+" the address commission was changed from "+&
									+string(ld_old_adr_comm)+" to "+string(dw_claim_base.GetItemDecimal(1,"claims_address_com"))+ " on the "+string(today())+" by "+string(uo_global.gos_userid)+ "."
								//	We get the field voyage_notes
								SELECT VOYAGE_NOTES INTO :ls_voyage_notes  FROM VOYAGES WHERE VOYAGE_NR= :is_voyage_nr  AND VESSEL_NR= :li_vessel_nr;
								If IsNull(ls_voyage_notes) Then ls_voyage_notes = ""
	
								//	We append our text about the change of voyagenumber to the text already written in the field
								ls_voyage_notes= ls_voyage_notes + ls_text
								ls_update_voyage_notes="UPDATE VOYAGES SET VOYAGE_NOTES = '"+ls_voyage_notes+"' WHERE VOYAGE_NR='"+ is_voyage_nr+"' AND VESSEL_NR="+string(li_vessel_nr)
								EXECUTE IMMEDIATE: ls_update_voyage_notes using sqlca;
								if sqlca.sqlcode <> 0 then
									messagebox("Voyage note update error","The changed address commission has not been included in Voyage notes. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
									EXECUTE IMMEDIATE:ls_rollback using sqlca;
									return 0
								end if
								id_adrs_comm = dw_claim_base.GetItemDecimal(1,"claims_address_com") 
							end if
							// Investigate if there was a change to created by
							if ls_old_created_by <> dw_claim_base.GetItemString(1,"claims_created_by") Then
								// We construct the text we want to insert
								ls_text=" ~r~n~r~nSystem Message: On voyage "+is_voyage_nr+" for vessel no = "+string(li_vessel_nr) +&
									" and claim no = "+string(li_claim_nr)+" the created by was changed from "+&
									+ls_old_created_by+" to "+dw_claim_base.GetItemString(1,"claims_created_by")+ " on the "+string(today())+" by "+string(uo_global.gos_userid)+ "."
								//	We get the field voyage_notes
								SELECT VOYAGE_NOTES INTO :ls_voyage_notes  FROM VOYAGES WHERE VOYAGE_NR= :is_voyage_nr  AND VESSEL_NR= :li_vessel_nr;
								If IsNull(ls_voyage_notes) Then ls_voyage_notes = ""
								//	We append our text about the change of voyagenumber to the text already written in the field
								ls_voyage_notes= ls_voyage_notes + ls_text
								ls_update_voyage_notes="UPDATE VOYAGES SET VOYAGE_NOTES = '"+ls_voyage_notes+"' WHERE VOYAGE_NR='"+ is_voyage_nr+"' AND VESSEL_NR="+string(li_vessel_nr)
								EXECUTE IMMEDIATE: ls_update_voyage_notes using sqlca;
								if sqlca.sqlcode <> 0 then
									messagebox("Voyage note update error","The changed address commission has not been included in Voyage notes. The Error was :~r~nSQLCODE = " + string(sqlca.sqlcode) + "~r~nSQLERRTEXT = " + sqlca.sqlerrtext)
									EXECUTE IMMEDIATE:ls_rollback using sqlca;
									return 0
								end if
							end if
							
						ELSE
							ROLLBACK;
						END IF
					else
						ROLLBACK;
					END IF
				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
		CASE ELSE
			IF dw_hea_dev_claim.Update(TRUE, FALSE) = 1 THEN
				ld_amount = dw_hea_dev_claim.GetItemNumber(1,"hea_dev_amount")
				
				//M5-6 Modified by LGX001 on 20/02/2012. 
				if isnull(ld_amount) then ld_amount = 0
				if abs(ld_amount_claim - ld_amount) > 0.1 then ib_claim_amount_changed = true
				
				dw_claim_base.SetItem(1, "claim_amount", ld_amount)
				lnv_claimcurrencyadjust.of_setcurrcode(dw_claim_base.GetItemString(1,"curr_code"))
				if lnv_claimcurrencyadjust.of_getclaimamounts(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ld_amount, ld_amount_usd, false) = c#return.Failure then
					_addmessage( this.classdefinition, "ue_update", "Error updating the claims, please try again!", SQLCA.SQLErrText)
					dw_claim_base.reselectrow(1)
					return 0
				end if
				if isnull(ld_amount_usd) then ld_amount_usd = 0
				if abs(ld_amount_claim_usd - ld_amount_usd) > 0.1 then ib_claim_amount_usd_changed = true
				dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
				
				ls_old_claimtype = dw_claim_base.getitemstring(1, COLUMN_CLAIM_TYPE, Primary!, true)
				
				IF dw_claim_base.Update(TRUE, FALSE) = 1 THEN
					dw_claim_base.ResetUpdate()

					dw_hea_dev_claim.ResetUpdate()
					COMMIT;
					
					if ls_old_claimtype <> ls_claim_type then
						ll_row = dw_list_claims.find("vessel_nr=" + string(li_vessel_nr) + " and voyage_nr='" + ls_voyage_nr + "'" &
															+ " and claim_nr=" + string(li_claim_nr), 1, dw_list_claims.rowcount())
						if ll_row > 0 then dw_list_claims.setitem(ll_row, COLUMN_CLAIM_TYPE, ls_claim_type)
					end if
					
					If uo_auto_comm.of_check_exist(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr) Then
						ldo_cp_id_comm = dw_claim_base.GetItemNumber(1, "claims_cp_id_comm")
						if ib_claim_amount_changed or ls_old_claimtype <> ls_claim_type then
							ib_claim_amount_changed = false
							ld_add_comm = uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ls_claim_type, "OLD", ldo_cp_id_comm)
						else
							if ib_claim_amount_usd_changed then
								ib_claim_amount_usd_changed = false
								ld_add_comm = uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ls_claim_type, "OLD", ldo_cp_id_comm, true)
							end if
						end if
					Else
						if ib_claim_amount_changed or ls_old_claimtype <> ls_claim_type then
							ib_claim_amount_changed = false
							ld_add_comm = uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ls_claim_type, "NEW", ldo_cp_id_comm)
							if ld_add_comm <> -1 then
								dw_claim_base.SetItem(1,"claims_address_com",ld_add_comm)
							end if
						else
							if ib_claim_amount_usd_changed then
								ib_claim_amount_usd_changed = false
								ld_add_comm = uo_auto_comm.of_generate(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr, ls_claim_type, "NEW", ldo_cp_id_comm, true)
							end if
						end if
						dw_claim_base.Update()
						COMMIT;
					End if

				ELSE
					ROLLBACK;
				END IF
			ELSE
				ROLLBACK;
			END IF
	END CHOOSE
	/* START - Updates address commission */
	lnv_calc_adrcomm = create u_addr_commission
	lnv_calc_adrcomm.of_setcurrcode(dw_claim_base.GetItemString(1,"curr_code"))
	if lnv_calc_adrcomm.of_add_com(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr) = -1 then
		rollback;
	else
		commit;
	end if
	destroy lnv_calc_adrcomm
	/* END - Updates address commission */
	
END IF

//get balance  both NEW and Update
uo_balance.of_claimbalance(li_vessel_nr, ls_voyage_nr, li_chart_nr, li_claim_nr)

// CR2949
if dw_claim_base.GetItemString(1,"claim_type") = "DEM" then
	dw_claim_base.modify("claim_percentage.protect = '1'")
	dw_claim_base.modify("claim_percentage.background.color='15527148'")
	if dw_claim_base.getitemdecimal(1, "claim_amount") < 0 then
		SELECT BU_ID INTO :ll_businessunit FROM USERS WHERE USERID = :uo_global.is_userid;
		if isnull(ll_businessunit) then ll_businessunit = 0
		//users and Demurrage /superusers/administrators
		if (uo_global.ii_access_level = 1 and ll_businessunit = 11) or uo_global.ii_access_level = 2 or uo_global.ii_access_level = 3 then
			dw_claim_base.modify("claim_percentage.protect = '0'")
			dw_claim_base.modify("claim_percentage.background.color='"+string(rgb(255,255,255))+"'")
		end if
	end if
end if

if dw_list_claims.getselectedrow(0) > 0 then
	dw_list_claims.event Clicked(0, 0, dw_list_claims.getselectedrow(0), dw_list_claims.object)
end if

Return 1
end event

event ue_delete;call super::ue_delete;/********************************************************************
  event ue_delete( /*unsignedlong wparam*/, /*long lparam */)
   <DESC>   Organises all dependent claim records</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS></ARGS>
   <USAGE>  How to use this function.</USAGE>
<HISTORY> 
   Date	   CR-Ref	 Author	Comments
  15/12/10  2215     AGL		Add deletion of claim action files.
  09/01/12  M5-2     JMC		Create credit note, when claim is deleted.
  20/06/14  CR3700   LHG008	Delete CLAIM_SENT when deleting claims
  09/11/15	CR3778   LHG008	Add Transaction C in Actions/Transactions window for FRT claims.
</HISTORY>    
********************************************************************/

long ll_no_of_rows, ll_numberofactions, ll_row, ll_recordcount, ll_claimid
integer li_vessel_nr, li_chart_nr, li_claim_nr, li_response=0
string ls_voyage_nr, ls_claim_type, ls_attachtablename, ls_invoice_nr, ls_errtext
Datetime ldt_date
n_service_manager 	lnv_serviceMgr
n_fileattach_service 	lnv_attachmentservice
DWItemStatus ldwstat_row
n_claims_transaction lnv_claims_transaction

constant string METHOD_NAME = "ue_delete()"

li_vessel_nr = dw_claim_base.GetItemNumber(1,"vessel_nr")
ls_voyage_nr = dw_claim_base.GetItemString(1,"voyage_nr")
li_chart_nr = dw_claim_base.GetItemNumber(1,"chart_nr")
li_claim_nr = dw_claim_base.GetItemNumber(1,"claim_nr")
ls_claim_type = dw_claim_base.GetItemstring(1, "claim_type")

SELECT COUNT(*)  
    INTO :ll_recordcount  
    FROM CLAIM_TRANSACTION  
   WHERE CHART_NR = :li_chart_nr  AND  
         VESSEL_NR = :li_vessel_nr  AND  
         VOYAGE_NR = :ls_voyage_nr  AND  
         CLAIM_NR = :li_claim_nr  AND
         C_TRANS_CODE <> "C" ;

if ll_recordcount > 0 then
	_addmessage( this.classdefinition, METHOD_NAME, "The Claim cannot be deleted because there are registered transactions.", "user info message - registered transactions exist")
	return c#return.NoAction
end if

SELECT COUNT(*)  
    INTO :ll_recordcount  
    FROM FREIGHT_RECEIVED  
   WHERE CHART_NR = :li_chart_nr  AND  
         VESSEL_NR = :li_vessel_nr  AND  
         VOYAGE_NR = :ls_voyage_nr  AND  
         CLAIM_NR = :li_claim_nr   AND
         TRANS_CODE <> 'C';

if ll_recordcount > 0 then
	_addmessage( this.classdefinition, METHOD_NAME, "The Claim cannot be deleted because there are registered transactions in freight received.", "user info message - regisitered transactions exist")
	return c#return.NoAction
end if

SELECT Count(*)
	INTO :ll_recordcount
	FROM COMMISSIONS, CLAIMS
	WHERE CLAIMS.CHART_NR = COMMISSIONS.CHART_NR AND
		CLAIMS.VESSEL_NR = COMMISSIONS.VESSEL_NR AND
		CLAIMS.VOYAGE_NR = COMMISSIONS.VOYAGE_NR AND
		CLAIMS.CLAIM_NR = COMMISSIONS.CLAIM_NR AND 
		COMMISSIONS.VESSEL_NR = :li_vessel_nr AND 
		COMMISSIONS.VOYAGE_NR = :ls_voyage_nr AND 
		COMMISSIONS.CHART_NR = :li_chart_nr AND 
		COMMISSIONS.CLAIM_NR = :li_claim_nr AND
		(COMMISSIONS.COMM_SETTLED = 1 or COMMISSIONS.COMM_AUTO = "Manual");

if ll_recordcount > 0 then
	_addmessage( this.classdefinition, METHOD_NAME, "Commissions exist which are settled or created manually. Deletion is not allowed !", "user info message - commisions exist")
	return c#return.NoAction
end if

if messagebox("Confirm delete of Claim!", "Please confirm delete of current selected Claim, which (If DEM/DES) will include delete of:" &
	+ "~r~n~r~n- Claim details~r~n- Claim Actions~r~n- Claim Transactions~r~n- Laytime Statements (Demurrage/Despatch Claims)" &
	+ "~r~n- (CMS if not transferred to file)", Question!, OKCancel!, 2) = 2 then return c#return.NoAction

open(w_claims_com_frt)
li_response = Message.DoubleParm
if (li_response = 0) then
	return c#return.NoAction
end if

/* use current dataobject in attachment object to search files  */
ll_numberofactions = uo_att_actions.dw_file_listing.rowcount( )
if ll_numberofactions>0 then
	lnv_serviceMgr.of_loadservice( lnv_attachmentService, "n_fileattach_service" )
	lnv_attachmentservice.of_activate()
	ls_attachtablename = uo_att_actions.dw_file_listing.Object.DataWindow.Table.UpdateTable + "_FILES"	
	for ll_row = 1 to ll_numberofactions
		/* ignore if New! or newModified! as no FILES database entries */
		ldwstat_row = uo_att_actions.dw_file_listing.getitemstatus( ll_row, 0, Primary!)
		if ldwstat_row=notModified! or ldwstat_row=dataModified!  then
			if lnv_attachmentService.of_deleteblob(ls_attachtablename, uo_att_actions.dw_file_listing.getitemnumber(ll_row,"file_id"),false) = 0 then
				ROLLBACK USING SQLCA;
				lnv_attachmentservice.of_rollback( )
				_addmessage( this.classdefinition, METHOD_NAME, "error, unable to delete action attachments for this claim" , "n/a")
				destroy lnv_attachmentservice
				return c#return.Failure
			end if
		end if
	next
end if

DELETE 
	FROM CLAIM_ACTION
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND CHART_NR = :li_chart_nr
	AND CLAIM_NR = :li_claim_nr 
	USING SQLCA;
	
if SQLCA.SQLCode = -1 then
	ls_errtext = SQLCA.SQLErrText
	ROLLBACK USING SQLCA;
	lnv_attachmentservice.of_rollback( )
	_addmessage( this.classdefinition, METHOD_NAME, "Error deleting the claim action record(s) unable to complete process!", ls_errtext)
	return c#return.Failure
end if

DELETE 
	FROM CLAIM_TRANSACTION
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND CHART_NR = :li_chart_nr
	AND CLAIM_NR = :li_claim_nr 
	USING SQLCA;
	
if SQLCA.SQLCode = -1 then
	ls_errtext = SQLCA.SQLErrText
	ROLLBACK USING SQLCA;
	lnv_attachmentservice.of_rollback( )
	_addmessage( this.classdefinition, METHOD_NAME, "Error deleting the claim transaction record(s) unable to complete process!", ls_errtext)
	return c#return.Failure
end if

//Delete adjustment reason
DELETE CLAIM_SENT
 WHERE CHART_NR = :li_chart_nr
	AND VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr
	AND CLAIM_NR = :li_claim_nr;

if SQLCA.SQLCode = -1 then
	ls_errtext = SQLCA.SQLErrText
	ROLLBACK USING SQLCA;
	lnv_attachmentservice.of_rollback( )
	_addmessage(this.classdefinition, METHOD_NAME, "Error deleting CLAIM_SENT.", ls_errtext)
	return c#return.Failure
end if

//Create credit Note
ls_invoice_nr = dw_claim_base.GetItemString(1,"invoice_nr")
ll_claimid = dw_claim_base.GetItemNumber(1,"claim_id")

lnv_claims_transaction = create n_claims_transaction

if ls_invoice_nr<>""  then
	if lnv_claims_transaction.of_credit_note(ll_claimid, ls_invoice_nr) = c#return.Failure then
		ls_errtext = SQLCA.SQLErrText
		ROLLBACK USING SQLCA;
		lnv_attachmentservice.of_rollback( )
		_addmessage( this.classdefinition, METHOD_NAME, "Error deleting the claim transaction record(s) unable to complete process!", ls_errtext)
		destroy lnv_claims_transaction
		return c#return.Failure
	end if
end if

CHOOSE CASE dw_claim_base.GetItemString(1,"claim_type")
	CASE "DEM", "DES"
	/* If there is more than one dem/des claim dont delete the laytime, because the layt.st. is shared among the claims 
	    on the samme vessel,voyage,charter */
	   SELECT COUNT(*)
			INTO :ll_recordcount
			FROM CLAIMS
			WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr AND CHART_NR = :li_chart_nr AND 
				CLAIM_TYPE = "DEM"
			USING SQLCA;
			
		if ll_recordcount < 2 then
			DELETE FROM GROUP_DEDUCTIONS
				WHERE VESSEL_NR = :li_vessel_nr
					AND VOYAGE_NR = :ls_voyage_nr
					AND CHART_NR = :li_chart_nr;
					
			if SQLCA.SQLCode = -1 then
				ls_errtext = SQLCA.SQLErrText
				ROLLBACK USING SQLCA;
				lnv_attachmentservice.of_rollback( )
			   _addmessage( this.classdefinition, METHOD_NAME, "Error deleting the group deduction record(s) unable to complete process!", ls_errtext)
				destroy lnv_claims_transaction
				return c#return.Failure
			end if

			DELETE FROM LAY_DEDUCTIONS
				WHERE VESSEL_NR = :li_vessel_nr
				AND VOYAGE_NR = :ls_voyage_nr
				AND CHART_NR = :li_chart_nr 
				USING SQLCA;
				
			if SQLCA.SQLCode = -1 then
				ls_errtext = SQLCA.SQLErrText
				ROLLBACK USING SQLCA;
				lnv_attachmentservice.of_rollback( )
				_addmessage( this.classdefinition, METHOD_NAME, "Error deleting the laycan deduction record(s) unable to complete process!", ls_errtext)
				destroy lnv_claims_transaction
				return c#return.Failure
			end if

			DELETE FROM LAYTIME_STATEMENTS
				WHERE VESSEL_NR = :li_vessel_nr
				AND VOYAGE_NR = :ls_voyage_nr
				AND CHART_NR = :li_chart_nr 
				USING SQLCA;
			if SQLCA.SQLCode = -1 then
				ls_errtext = SQLCA.SQLErrText
				ROLLBACK USING SQLCA;
				lnv_attachmentservice.of_rollback( )
				_addmessage( this.classdefinition, METHOD_NAME, "Error deleting the laytime statement record(s) unable to complete process!", ls_errtext)
				destroy lnv_claims_transaction
				return c#return.Failure
			end if
		end if
		dw_dem_des_rates.SetRedraw(FALSE)
		dw_dem_des_claim.SetRedraw(FALSE)
		dw_dem_des_rates.SetFilter("")
		dw_dem_des_rates.Filter()
		ll_no_of_rows = dw_dem_des_rates.RowCount() 
		for ll_row = ll_no_of_rows to 1 step -1
			dw_dem_des_rates.DeleteRow(ll_row)
		next
		ll_no_of_rows = dw_dem_des_claim.RowCount() 	
		for ll_row = ll_no_of_rows to 1 step -1
			dw_dem_des_claim.DeleteRow(ll_row)
		next
		dw_dem_des_rates.SetRedraw(TRUE)
		dw_dem_des_claim.SetRedraw(TRUE)

		dw_claim_base.DeleteRow(1)

		if dw_dem_des_rates.update(TRUE, FALSE) = 1 then
			if dw_dem_des_claim.update(TRUE, FALSE) = 1 then
				if dw_claim_base.update(TRUE, FALSE) = 1 then
					dw_claim_base.ResetUpdate()
					dw_dem_des_claim.ResetUpdate()
					dw_dem_des_rates.ResetUpdate()
					COMMIT USING SQLCA;
					
					/* update attachment transaction also */
					if ll_numberofactions>0 then
						lnv_attachmentservice.of_commit( )
						lnv_attachmentservice.of_deactivate()					
					end if	
					uo_att_actions.dw_file_listing.reset()
					
					if SQLCA.SQLCode = 0 then
						wf_enabled_buttons("DELETE")		
						uo_balance.of_setnull( )
					end if
				else
					ROLLBACK USING SQLCA;
					lnv_attachmentservice.of_rollback( )
				end if
			else
				ROLLBACK USING SQLCA;
				lnv_attachmentservice.of_rollback( )
			end if
		else
			ROLLBACK USING SQLCA;
			lnv_attachmentservice.of_rollback( )
		end if
	CASE "FRT"
		ll_no_of_rows = dw_freight_received.RowCount() 
		for ll_row = 1 to ll_no_of_rows
			dw_freight_received.DeleteRow(1) 
		next
		dw_freight_claim.DeleteRow(1)
		dw_claim_base.DeleteRow(1)
		ll_no_of_rows = dw_add_lumpsums.RowCount() 
		for ll_row = 1 to ll_no_of_rows
			dw_add_lumpsums.DeleteRow(1)
		next
		if dw_freight_received.update(TRUE, FALSE) = 1 then
			if dw_add_lumpsums.update(TRUE, FALSE) = 1 then
				if dw_freight_claim.update(TRUE, FALSE) = 1 then
					if dw_claim_base.update(TRUE, FALSE) = 1 then
						dw_add_lumpsums.ResetUpdate()
						dw_claim_base.ResetUpdate()
						dw_freight_claim.ResetUpdate()
						dw_freight_received.ResetUpdate()
						COMMIT USING SQLCA;
						
						/* update attachment transaction also */
						if ll_numberofactions>0 then
							lnv_attachmentservice.of_commit( )
							lnv_attachmentservice.of_deactivate()					
						end if							
						uo_att_actions.dw_file_listing.reset()
						
						if SQLCA.SQLCode = 0 then
							wf_enabled_buttons("DELETE")		
							uo_balance.of_setnull( )
						end if
					else
						ROLLBACK USING SQLCA;
						lnv_attachmentservice.of_rollback( )
					end if
				else
					ROLLBACK USING SQLCA;
					lnv_attachmentservice.of_rollback( )
				end if
			end if
		else
			ROLLBACK USING SQLCA;
			lnv_attachmentservice.of_rollback( )
		end if
	CASE ELSE
		dw_hea_dev_claim.DeleteRow(1)
		dw_claim_base.DeleteRow(1)
		if dw_hea_dev_claim.update(TRUE, FALSE) = 1 then
			if dw_claim_base.update(TRUE, FALSE) = 1 then
				dw_claim_base.ResetUpdate()
				dw_hea_dev_claim.ResetUpdate()
				COMMIT USING SQLCA;
				
				/* update attachment transaction also */
				if ll_numberofactions>0 then
					lnv_attachmentservice.of_commit( )
					lnv_attachmentservice.of_deactivate()					
				end if	
				uo_att_actions.dw_file_listing.reset()
				
				if SQLCA.SQLCode = 0 then
					wf_enabled_buttons("DELETE")		
					uo_balance.of_setnull( )
				end if
			else
				ROLLBACK USING SQLCA;
				lnv_attachmentservice.of_rollback( )
			end if
		else
			ROLLBACK USING SQLCA;
			lnv_attachmentservice.of_rollback( )
		end if
END CHOOSE

if isvalid(lnv_attachmentservice) then destroy lnv_attachmentservice
if isvalid(lnv_claims_transaction) then destroy lnv_claims_transaction

return
end event

event ue_retrieve;call super::ue_retrieve;long ll_rc, xx,ll_claim_no,ll_chart_no, ll_vessel_nr,ll_test_afc
String ls_voyage_no

ll_rc = dw_list_claims.Retrieve(ii_vessel_nr)
COMMIT USING SQLCA;
IF ll_rc = 0 THEN
	dw_dem_des_claim.Hide()
	dw_dem_des_rates.Hide()
	dw_freight_claim.Hide()
	dw_freight_received.Hide()
	uo_frt_balance.Hide()
	dw_hea_dev_claim.Hide()
	dw_claim_base.Hide()
	cb_delete_afc_recieved.Hide()
	cb_new_afc_recieved.Hide()
	cb_scroll_next.Hide()
	cb_scroll_prior.Hide()
	dw_afc.Hide()
	dw_add_lumpsums_afc.hide( )
	dw_afc_bol.Hide()
	dw_afc_recieved.Hide()
	st_afc_count.Hide()
	st_afc_total.Hide()
	uo_afc.Hide()
	cb_office.Hide()
	cb_delete_received.Hide()
	cb_new_received.Hide()
	cb_afc_update_recieved.Hide()
	cb_dem_des_new_rate.Hide()
	cb_dem_des_delete_rate.Hide()
	cb_update.Enabled = FALSE
	cb_delete.Enabled = FALSE
END IF
dw_list_claims.ScrollToRow(ll_rc)
cb_new.enabled = true

ll_vessel_nr = ii_vessel_nr

FOR xx = 1 TO ll_rc
	IF dw_list_claims.GetItemString(xx,"claim_type") = "FRT" THEN
		ls_voyage_no = dw_list_claims.GetItemString(xx,"voyage_nr")
		ll_chart_no = dw_list_claims.GetItemNumber(xx,"chart_nr")
		ll_claim_no = dw_list_claims.GetItemNumber(xx,"claim_nr")
		SELECT VESSEL_NR
		INTO :ll_test_afc
		FROM FREIGHT_ADVANCED
		WHERE :ll_vessel_nr = VESSEL_NR AND :ls_voyage_no = VOYAGE_NR AND :ll_chart_no = CHART_NR &
			   AND :ll_claim_no = CLAIM_NR AND AFC_NR = 1;
		IF SQLCA.SQLCode = 0 THEN dw_list_claims.SetItem(xx,"curr_code","AFC")
		COMMIT USING SQLCA;
	END IF
NEXT
end event

event open;call super::open;n_service_manager  lnv_servicemgr
n_dw_style_service lnv_style
datawindowchild    ldwc

this.Move(5,5)

dw_list_claims.SetTransObject(SQLCA)
dw_claim_base.SetTransObject(SQLCA)

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_autoadjustdddwwidth(dw_claim_base)

iuo_dddw_search_responsible = create u_dddw_search
iuo_dddw_search_responsible.of_register(dw_claim_base, "claim_responsible", "fullname", true, true, true)
dw_claim_base.of_registerdddw("claim_responsible", "users_deleted = 0 and user_profile = 2 and group_name <> 'external_apm'")

dw_dem_des_claim.SetTransObject(SQLCA)
dw_dem_des_rates.SetTransObject(SQLCA)
dw_freight_claim.SetTransObject(SQLCA)
dw_add_lumpsums.SetTransObject(SQLCA)
dw_add_lumpsums_afc.SetTransObject(SQLCA)

dw_freight_received.SetTransObject(SQLCA)
dw_hea_dev_claim.SetTransObject(SQLCA)
dw_afc_bol.SetTransObject(SQLCA)
dw_afc.SetTransObject(SQLCA)
dw_afc_recieved.SetTransObject(SQLCA)
dw_freight_received.SetRowFocusIndicator(p_dot,10,15)
dw_dem_des_rates.SetRowFocusIndicator(p_dot,10,15)

uo_att_actions.of_init( "", 0,0,0)

uo_vesselselect.of_registerwindow( w_claims )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

uo_att_actions.dw_file_listing.modify("description.width = 2260")

end event

on w_claims.create
int iCurrent
call super::create
this.gb_dem_rate=create gb_dem_rate
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
this.cb_delete=create cb_delete
this.cb_print=create cb_print
this.cb_afc=create cb_afc
this.cb_deviation=create cb_deviation
this.cb_heating=create cb_heating
this.cb_freight=create cb_freight
this.cb_misc=create cb_misc
this.cb_demurrage=create cb_demurrage
this.cb_refresh_claim=create cb_refresh_claim
this.cb_delete_received=create cb_delete_received
this.cb_new_received=create cb_new_received
this.cb_close_bulk=create cb_close_bulk
this.uo_balance=create uo_balance
this.cb_unlock=create cb_unlock
this.cb_new=create cb_new
this.st_1=create st_1
this.dw_add_lumpsums=create dw_add_lumpsums
this.cb_scroll_prior_dem=create cb_scroll_prior_dem
this.st_dem_count=create st_dem_count
this.st_dem_total=create st_dem_total
this.cb_scroll_next_dem=create cb_scroll_next_dem
this.cb_l_d_amount=create cb_l_d_amount
this.cb_afc_update_recieved=create cb_afc_update_recieved
this.cb_dem_des_new_rate=create cb_dem_des_new_rate
this.cb_dem_des_delete_rate=create cb_dem_des_delete_rate
this.cb_broker=create cb_broker
this.dw_claim_base=create dw_claim_base
this.gb_base_claim=create gb_base_claim
this.cb_delete_action=create cb_delete_action
this.cb_new_action=create cb_new_action
this.cb_update_action=create cb_update_action
this.cb_cancel_action=create cb_cancel_action
this.cb_delete_afc_recieved=create cb_delete_afc_recieved
this.cb_new_afc_recieved=create cb_new_afc_recieved
this.cb_scroll_prior=create cb_scroll_prior
this.st_afc_count=create st_afc_count
this.st_afc_total=create st_afc_total
this.dw_add_lumpsums_afc=create dw_add_lumpsums_afc
this.dw_afc_bol=create dw_afc_bol
this.dw_afc_recieved=create dw_afc_recieved
this.dw_bulk_amounts=create dw_bulk_amounts
this.dw_dem_des_rates=create dw_dem_des_rates
this.dw_list_claims=create dw_list_claims
this.cb_scroll_next=create cb_scroll_next
this.dw_freight_received=create dw_freight_received
this.p_dot=create p_dot
this.cb_office=create cb_office
this.dw_freight_claim=create dw_freight_claim
this.dw_dem_des_claim=create dw_dem_des_claim
this.dw_afc=create dw_afc
this.uo_frt_balance=create uo_frt_balance
this.gb_freight_balance=create gb_freight_balance
this.uo_afc=create uo_afc
this.gb_dem_claim=create gb_dem_claim
this.dw_hea_dev_claim=create dw_hea_dev_claim
this.gb_freight_claim=create gb_freight_claim
this.gb_dev_claim=create gb_dev_claim
this.uo_att_actions=create uo_att_actions
this.st_setexrate=create st_setexrate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_dem_rate
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.cb_afc
this.Control[iCurrent+7]=this.cb_deviation
this.Control[iCurrent+8]=this.cb_heating
this.Control[iCurrent+9]=this.cb_freight
this.Control[iCurrent+10]=this.cb_misc
this.Control[iCurrent+11]=this.cb_demurrage
this.Control[iCurrent+12]=this.cb_refresh_claim
this.Control[iCurrent+13]=this.cb_delete_received
this.Control[iCurrent+14]=this.cb_new_received
this.Control[iCurrent+15]=this.cb_close_bulk
this.Control[iCurrent+16]=this.uo_balance
this.Control[iCurrent+17]=this.cb_unlock
this.Control[iCurrent+18]=this.cb_new
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.dw_add_lumpsums
this.Control[iCurrent+21]=this.cb_scroll_prior_dem
this.Control[iCurrent+22]=this.st_dem_count
this.Control[iCurrent+23]=this.st_dem_total
this.Control[iCurrent+24]=this.cb_scroll_next_dem
this.Control[iCurrent+25]=this.cb_l_d_amount
this.Control[iCurrent+26]=this.cb_afc_update_recieved
this.Control[iCurrent+27]=this.cb_dem_des_new_rate
this.Control[iCurrent+28]=this.cb_dem_des_delete_rate
this.Control[iCurrent+29]=this.cb_broker
this.Control[iCurrent+30]=this.dw_claim_base
this.Control[iCurrent+31]=this.gb_base_claim
this.Control[iCurrent+32]=this.cb_delete_action
this.Control[iCurrent+33]=this.cb_new_action
this.Control[iCurrent+34]=this.cb_update_action
this.Control[iCurrent+35]=this.cb_cancel_action
this.Control[iCurrent+36]=this.cb_delete_afc_recieved
this.Control[iCurrent+37]=this.cb_new_afc_recieved
this.Control[iCurrent+38]=this.cb_scroll_prior
this.Control[iCurrent+39]=this.st_afc_count
this.Control[iCurrent+40]=this.st_afc_total
this.Control[iCurrent+41]=this.dw_add_lumpsums_afc
this.Control[iCurrent+42]=this.dw_afc_bol
this.Control[iCurrent+43]=this.dw_afc_recieved
this.Control[iCurrent+44]=this.dw_bulk_amounts
this.Control[iCurrent+45]=this.dw_dem_des_rates
this.Control[iCurrent+46]=this.dw_list_claims
this.Control[iCurrent+47]=this.cb_scroll_next
this.Control[iCurrent+48]=this.dw_freight_received
this.Control[iCurrent+49]=this.p_dot
this.Control[iCurrent+50]=this.cb_office
this.Control[iCurrent+51]=this.dw_freight_claim
this.Control[iCurrent+52]=this.dw_dem_des_claim
this.Control[iCurrent+53]=this.dw_afc
this.Control[iCurrent+54]=this.uo_frt_balance
this.Control[iCurrent+55]=this.gb_freight_balance
this.Control[iCurrent+56]=this.uo_afc
this.Control[iCurrent+57]=this.gb_dem_claim
this.Control[iCurrent+58]=this.dw_hea_dev_claim
this.Control[iCurrent+59]=this.gb_freight_claim
this.Control[iCurrent+60]=this.gb_dev_claim
this.Control[iCurrent+61]=this.uo_att_actions
this.Control[iCurrent+62]=this.st_setexrate
end on

on w_claims.destroy
call super::destroy
destroy(this.gb_dem_rate)
destroy(this.cb_update)
destroy(this.cb_cancel)
destroy(this.cb_delete)
destroy(this.cb_print)
destroy(this.cb_afc)
destroy(this.cb_deviation)
destroy(this.cb_heating)
destroy(this.cb_freight)
destroy(this.cb_misc)
destroy(this.cb_demurrage)
destroy(this.cb_refresh_claim)
destroy(this.cb_delete_received)
destroy(this.cb_new_received)
destroy(this.cb_close_bulk)
destroy(this.uo_balance)
destroy(this.cb_unlock)
destroy(this.cb_new)
destroy(this.st_1)
destroy(this.dw_add_lumpsums)
destroy(this.cb_scroll_prior_dem)
destroy(this.st_dem_count)
destroy(this.st_dem_total)
destroy(this.cb_scroll_next_dem)
destroy(this.cb_l_d_amount)
destroy(this.cb_afc_update_recieved)
destroy(this.cb_dem_des_new_rate)
destroy(this.cb_dem_des_delete_rate)
destroy(this.cb_broker)
destroy(this.dw_claim_base)
destroy(this.gb_base_claim)
destroy(this.cb_delete_action)
destroy(this.cb_new_action)
destroy(this.cb_update_action)
destroy(this.cb_cancel_action)
destroy(this.cb_delete_afc_recieved)
destroy(this.cb_new_afc_recieved)
destroy(this.cb_scroll_prior)
destroy(this.st_afc_count)
destroy(this.st_afc_total)
destroy(this.dw_add_lumpsums_afc)
destroy(this.dw_afc_bol)
destroy(this.dw_afc_recieved)
destroy(this.dw_bulk_amounts)
destroy(this.dw_dem_des_rates)
destroy(this.dw_list_claims)
destroy(this.cb_scroll_next)
destroy(this.dw_freight_received)
destroy(this.p_dot)
destroy(this.cb_office)
destroy(this.dw_freight_claim)
destroy(this.dw_dem_des_claim)
destroy(this.dw_afc)
destroy(this.uo_frt_balance)
destroy(this.gb_freight_balance)
destroy(this.uo_afc)
destroy(this.gb_dem_claim)
destroy(this.dw_hea_dev_claim)
destroy(this.gb_freight_claim)
destroy(this.gb_dev_claim)
destroy(this.uo_att_actions)
destroy(this.st_setexrate)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_list_claims, "vessel_nr", "voyage_nr", True)

_lockcurrcode( )

n_service_manager 	 lnv_servicemgr
n_dw_style_service 	 lnv_style

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

lnv_style.of_dwlistformater(dw_list_claims, false)

uo_vesselselect.gb_1.height = 199
uo_vesselselect.gb_1.backcolor = c#color.mt_listheader_bg
uo_vesselselect.gb_1.textcolor = c#color.mt_listheader_text
uo_vesselselect.st_criteria.backcolor = c#color.mt_listheader_bg
uo_vesselselect.st_criteria.textcolor = c#color.mt_listheader_text
uo_vesselselect.dw_vessel.object.datawindow.color = c#color.mt_listheader_bg

end event

event closequery;call super::closequery;if il_last_row > 0 and il_last_row <= dw_list_claims.rowCount() then
	if wf_datawindow_modified(dw_list_claims.GetItemString(il_last_row,"claim_type")) = c#return.failure then
		return 1
	end if
end if
end event

event ue_vesselselection;call super::ue_vesselselection;IF il_last_row > 0 THEN
	wf_datawindow_modified(dw_list_claims.GetItemString(il_last_row,"claim_type"))
END IF
il_last_row = 0

postevent("ue_retrieve")
uo_att_actions.enabled = false
uo_att_actions.dw_file_listing.reset()
dw_list_claims.Show()
dw_claim_base.Hide()
cb_office.Hide()
dw_dem_des_claim.Hide()
dw_dem_des_rates.Hide()
cb_dem_des_new_rate.Hide()
cb_dem_des_delete_rate.Hide()
dw_freight_claim.Hide()
dw_freight_received.Hide()
cb_new_received.Hide()
cb_delete_received.Hide()
uo_frt_balance.Hide()
dw_hea_dev_claim.Hide()
dw_afc.Hide()
dw_add_lumpsums.hide( )
dw_add_lumpsums_afc.hide( )
dw_afc_recieved.Hide()
dw_afc_bol.Hide()
uo_afc.Hide()
cb_delete_afc_recieved.Hide()
cb_new_afc_recieved.Hide()
st_afc_count.Hide()
st_afc_total.Hide()
cb_scroll_next.Hide()
cb_scroll_prior.Hide()
cb_afc_update_recieved.Hide()
cb_scroll_next_dem.Hide()
cb_scroll_prior_dem.Hide()
cb_l_d_amount.Hide()
st_dem_count.Hide()
st_dem_total.Hide()
gb_base_claim.hide()
gb_freight_claim.hide()
gb_freight_balance.hide()
gb_dem_claim.hide()
gb_dem_rate.hide()
gb_dev_claim.hide()
uo_balance.of_setnull( )

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
   	24/09/14 CR3721       CCY018        	press the Enter key will execute to select a vessel, instead of execute the default keyboard focus button
   </HISTORY>
********************************************************************/

graphicobject	lgo_foucs
if key = keyenter! then
	lgo_foucs = getfocus()
	if lgo_foucs.classname() = 'dw_vessel' then
		ib_ignoredefaultbutton = true
		send(handle(lgo_foucs),256,9,0)
	end if
end if

return  c#return.Success
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_claims
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_claims
integer x = 18
integer taborder = 10
long backcolor = 553648127
end type

type gb_dem_rate from mt_u_groupbox within w_claims
boolean visible = false
integer x = 3136
integer y = 840
integer width = 1216
integer height = 352
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = ""
end type

type cb_update from commandbutton within w_claims
integer x = 3314
integer y = 1468
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
boolean enabled = false
string text = "&Update"
boolean default = true
end type

event clicked;n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.rowcount() <= 0 then return	

// possibly when a new claim the actions may be disabled.
wf_enableactions(true)

uo_att_actions.dw_file_listing.accepttext( )
lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
lnv_actionrules.of_registerrulestring("description", true, "description")
if lnv_actionrules.of_validate(uo_att_actions.dw_file_listing, true) = c#return.Failure then return c#return.Failure

IF dw_afc.Visible THEN 
	parent.TriggerEvent("ue_afc_update")
ELSE	
	parent.TriggerEvent("ue_update")
END IF

if uo_att_actions.dw_file_listing.modifiedcount( ) +  uo_att_actions.dw_file_listing.deletedcount( )>0 then
	uo_att_actions.of_setargs(is_voyage_nr, long(ii_vessel_nr), long(ii_claim_nr), il_charter_nr)
	uo_att_actions.of_updateattach( )
end if
wf_filtermisctype()
end event

type cb_cancel from commandbutton within w_claims
integer x = 4009
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 250
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Cancel"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

wf_claim_base_tabs(FALSE)
wf_enabled_buttons("CANCEL")
uo_att_actions.dw_file_listing.Reset()
cb_update.Default = TRUE
this.Default = FALSE
//if dw_claim_base.getselectedrow(0) > 0 then
wf_enableactions(true)
// end if

end event

type cb_delete from commandbutton within w_claims
integer x = 3662
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 240
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_locked

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.rowcount() <= 0 then return			//M5-6 Added by ZSW001 on 23/02/2012

ll_locked = dw_claim_base.GetItemNumber(1,"locked")

if ll_locked = 1 then
	MessageBox( "Error", "The selected claim cannot be deleted, because it is locked. Please contact Finance to get the claim unlocked.")
	return 
end if

IF dw_afc.Visible THEN
	parent.TriggerEvent("ue_afc_delete")
ELSE
	parent.TriggerEvent("ue_delete")
END IF

cb_update.Default = TRUE

this.Default = FALSE
wf_enableactions(true)
end event

type cb_print from commandbutton within w_claims
integer x = 727
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 210
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;long ll_row, ll_trans_id
s_vessel_voyage_chart_claim lstr_parm
n_voyage	lnv_voyage
string ls_waitingtime

ll_row = dw_list_claims.getselectedRow(0)
if ll_row < 1 then
	MessageBox("Information", "Please select a Claim before printing.")
	return
end if

if wf_datawindow_modified() <> c#return.Success then return	//M5-2 Added by ZSW001 on 11/01/2012.

IF ll_row > 0 THEN
	lstr_parm.vessel_nr  = ii_vessel_nr
	lstr_parm.voyage_nr  = dw_list_claims.GetItemString(ll_row,"voyage_nr")
	lstr_parm.chart_nr   = dw_list_claims.GetItemNumber(ll_row,"chart_nr")
	lstr_parm.claim_nr   = dw_list_claims.GetItemNumber(ll_row,"claim_nr")
	lstr_parm.claim_type = dw_list_claims.GetItemString(ll_row,"claim_type")
	lstr_parm.discharge_date = dw_claim_base.getitemdatetime( 1, "discharge_date")
	lstr_parm.ax_invoice_nr = dw_claim_base.getitemstring( 1, "invoice_nr")
	lstr_parm.send_to_ax_locked = dw_claim_base.getitemnumber( 1, "locked")
	lstr_parm.claim_id = dw_claim_base.getitemnumber( 1, "claim_id")
	lstr_parm.cp_date = dw_claim_base.getitemdatetime( 1, "cp_date")
	lstr_parm.cal_cerp_id = dw_claim_base.getitemnumber(1, "cal_cerp_id")
	
	if dw_claim_base.getitemnumber(1, "claims_ax_invoice_text_flag") = 1 then
		lstr_parm.ax_invoice_text = dw_claim_base.getitemstring(1, "claims_ax_invoice_text")
	else
		setnull(lstr_parm.ax_invoice_text)
	end if	
	
	
	lnv_voyage = create n_voyage
	lstr_parm.s_vessel_ref_nr = f_get_vsl_ref(ii_vessel_nr)
	if lnv_voyage.of_get_outstanding_voymaster_trans_count( lstr_parm.s_vessel_ref_nr, lstr_parm.voyage_nr, ls_waitingtime, ll_trans_id) > 0 then
		lstr_parm.i_voyage_locked = 1
	else 
		lstr_parm.i_voyage_locked = 0
	end if
	destroy lnv_voyage
	
	choose case lstr_parm.claim_type
		case "DEM", "DES"
			lstr_parm.claim_title = 'Print Demurrage'
			OpenWithParm(w_print_support_documents_dem, lstr_parm)
		case "FRT"
			// Der findes ingen separat udskrivning af freight claims......
			lstr_parm.claim_title = 'Print Freight'
			OpenWithParm(w_print_support_documents, lstr_parm)
		case "HEA"
			lstr_parm.claim_title = "Print Heating"
			OpenWithParm(w_print_support_documents, lstr_parm)
		case "DEV"
			lstr_parm.claim_title = "Print Deviation"
			OpenWithParm(w_print_support_documents, lstr_parm)
		case else			
			lstr_parm.claim_title = "Print Miscellaneous"
			OpenWithParm(w_print_support_documents, lstr_parm)
	end choose
	
end if

cb_update.default = true
this.default = false

dw_list_claims.event clicked(0, 0, ll_row, dw_list_claims.object.voyage_nr)

end event

type cb_afc from commandbutton within w_claims
boolean visible = false
integer x = 1499
integer y = 2352
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New AFC"
end type

event clicked;datetime ld_dato
long ll_ndays,ll_tdays
integer	li_return

date	ld_cal_notice, ld_cal_timebar, ld_cur_notice, ld_cur_timebar

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

IF wf_afc_new()  THEN
	IF dw_afc_bol.Retrieve(ii_vessel_nr, is_voyage_nr, il_charter_nr) > 0 THEN 		
		cb_afc.Visible = FALSE		
	ELSE
		MessageBox("Message","There is no Bill Of Ladings on this vessel/voyage/charter.")
		wf_enabled_buttons("CANCEL")
		dw_afc.Hide()		
		dw_add_lumpsums_afc.hide( )
	END IF
	COMMIT USING SQLCA;
END IF
	
IF dw_claim_base.RowCount() > 0 THEN
	ld_dato  = dw_claim_base.GetItemDateTime(1,"discharge_date")
	ll_ndays = dw_claim_base.GetItemNumber(1,"notice_days")
	ll_tdays = dw_claim_base.GetItemNumber(1,"timebar_days")
	
	//M5-6 Begin added by ZSW001 on 27/02/2012
	ld_cal_notice  = relativedate(date(ld_dato), ll_ndays)
	ld_cal_timebar = relativedate(date(ld_dato), ll_tdays)
	
	ld_cur_notice  = date(dw_claim_base.getitemdatetime(1, "notice_date"))
	ld_cur_timebar = date(dw_claim_base.getitemdatetime(1, "timebar_date"))
	
	if isnull(ld_cal_notice) or isnull(ld_cur_notice) or ld_cal_notice <> ld_cur_notice then
		dw_claim_base.setitem(1, "notice_date", ld_cal_notice)
	end if
	
	if isnull(ld_cal_timebar) or isnull(ld_cur_timebar) or ld_cal_timebar <> ld_cur_timebar then
		dw_claim_base.setitem(1, "timebar_date", ld_cal_timebar)
	end if
	//M5-6 End added by ZSW001 on 27/02/2012
END IF

ibl_new = true
end event

type cb_deviation from commandbutton within w_claims
boolean visible = false
integer x = 1042
integer y = 2372
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "D&eviation"
end type

event clicked;integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

wf_new_claim("DEV")
uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_update.Default = TRUE

cb_unlock.enabled = false
this.Default = FALSE

end event

type cb_heating from commandbutton within w_claims
boolean visible = false
integer x = 1367
integer y = 2372
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Heating"
end type

event clicked;integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

wf_new_claim("HEA")
uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_update.Default = TRUE

cb_unlock.enabled = false
this.Default = FALSE

end event

type cb_freight from commandbutton within w_claims
boolean visible = false
integer x = 1691
integer y = 2372
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Freight"
end type

event clicked;datetime ld_dato
long ll_ndays,ll_tdays
integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

li_return = wf_new_claim("FRT")
if li_return <= 0 then return

uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_update.Default = TRUE
cb_unlock.enabled = false
this.Default = FALSE

IF dw_claim_base.RowCount() > 0 THEN
	ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
	ll_ndays = dw_claim_base.GetItemNumber(1,"notice_days")
	ll_tdays = dw_claim_base.GetItemNumber(1,"timebar_days")
	dw_claim_base.SetItem(1,"notice_date",RelativeDate(Date(ld_dato),ll_ndays))			
	dw_claim_base.SetItem(1,"timebar_date",RelativeDate(Date(ld_dato),ll_tdays))
END IF

ibl_new = true
end event

type cb_misc from commandbutton within w_claims
boolean visible = false
integer x = 2016
integer y = 2372
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Misc."
end type

event clicked;integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

wf_new_claim("MISC")
uo_att_actions.dw_file_listing.reset()
wf_enableactions(false)
cb_unlock.enabled = false
cb_update.Default = TRUE
this.Default = FALSE

end event

type cb_demurrage from commandbutton within w_claims
boolean visible = false
integer x = 718
integer y = 2372
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Dem / Des"
end type

event clicked;datetime	ld_dato
long		ll_ndays,ll_tdays
integer	li_return

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_claim_base.visible = true and dw_claim_base.rowcount()>0 then
	li_return = wf_datawindow_modified(dw_claim_base.GetItemString(1,"claim_type"))
	if li_return = c#return.Failure then return
end if

li_return = wf_new_claim("DEM")
if li_return <= 0 then return		//M5-6 Added by ZSW001 on 23/02/2012.

cb_update.Default = TRUE
cb_unlock.enabled = false
this.Default = FALSE

IF dw_claim_base.RowCount() > 0 THEN
	ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
	ll_ndays = dw_claim_base.GetItemNumber(1,"notice_days")
	ll_tdays = dw_claim_base.GetItemNumber(1,"timebar_days")
	dw_claim_base.SetItem(1,"notice_date",RelativeDate(Date(ld_dato),ll_ndays))			
	dw_claim_base.SetItem(1,"timebar_date",RelativeDate(Date(ld_dato),ll_tdays))
	dw_claim_base.SetItem(1,"claims_expect_receive_pct", wf_get_expect_receive_percent('DEM'))
	uo_att_actions.dw_file_listing.reset()
END IF
wf_enableactions(false)

end event

type cb_refresh_claim from commandbutton within w_claims
integer x = 1074
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 220
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;/* This function is used to refresh a claim with data from calculation.
	Only valid for Freight and demurrage claims , and only valid for 
	reversible demurrage and normal freight claims				 	*/
	
boolean lb_rc
long    ll_rows, ll_row, ll_cal_cerpID, ll_return
integer li_vessel, li_chart, li_rc, li_add_lump, li_claim
string  ls_voyage, ls_claimtype
integer li_null; setNull(li_null)
decimal{3} ld_bol_quantity = 0

s_frt_data        lstr_frt[25]
u_calc_nvo        lnv_calc_data
s_dem_des_data    lstr_dem[]
s_claim_base_data lstr_base

ll_row = dw_list_claims.getSelectedRow(0)

if ll_row < 1 then return

/* Now ready to update claims */
li_vessel = dw_list_claims.getItemNumber(ll_row, "vessel_nr")
ls_voyage = dw_list_claims.getItemString(ll_row, "voyage_nr")
li_chart = dw_list_claims.getItemNumber(ll_row, "chart_nr")
ls_claimtype = dw_list_claims.getItemString(ll_row, "claim_type")
li_claim = dw_list_claims.getItemNumber(ll_row, "claim_nr")
ii_claim_nr = li_claim

/* get cal cerp id  from demurrage or freight */
choose case ls_claimtype
	case "FRT"
		ll_cal_cerpID = dw_freight_claim.getItemNumber(1, "cal_cerp_id")
	case "DEM"
		ll_cal_cerpID = dw_dem_des_claim.getItemNumber(1, "cal_cerp_id")
	case else
		return
end choose

ll_rows = dw_list_claims.rowcount()
IF il_last_row > 0 AND il_last_row <= ll_rows and dw_claim_base.rowcount() > 0 THEN
	ll_return = wf_datawindow_modified(dw_list_claims.GetItemString(il_last_row, "claim_type"))
	if ll_return = c#return.failure or ll_return = c#return.NoAction then return
END IF

lnv_calc_data = create u_calc_nvo

/* Get and set Base Claim data */
lb_rc = lnv_calc_data.uf_claim_base_data( li_vessel, ls_voyage, li_chart, ll_cal_cerpID , lstr_base)

if not lb_rc then
	MessageBox("Refresh failed", "Refresh function failed when trying to retrieve base claim data")
	destroy lnv_calc_data
	return
end if

if lstr_base.fixed_exrate_enabled = 1 then
	id_fixed_exrate = lstr_base.fixed_exrate
else
	id_fixed_exrate = 0
end if
	
dw_claim_base.setItem(1, "claims_laycan_start", lstr_base.laycan_start )
dw_claim_base.setItem(1, "claims_laycan_end", lstr_base.laycan_end )
dw_claim_base.setItem(1, "broker_nr", lstr_base.broker_nr )	         //M5-6 Commented by ZSW001 on 24/02/2012
dw_claim_base.setItem(1, "claims_broker_com", lstr_base.broker_com ) //M5-6 Commented by ZSW001 on 24/02/2012
dw_claim_base.setItem(1, "claims_address_com", lstr_base.address_com )
dw_claim_base.setItem(1, "cp_date", lstr_base.cp_date )
dw_claim_base.setItem(1, "cp_text", lstr_base.cp_text )
dw_claim_base.setItem(1, "office_nr", lstr_base.office_nr )

choose case ls_claimtype
	case "FRT"
	 	li_rc = lnv_calc_data.uf_frt_data( li_vessel, ls_voyage, li_chart, ll_cal_cerpID , lstr_frt)
		if li_rc <> 1 then
			MessageBox("Refresh failed", "Refresh function failed when trying to retrieve freight claim data")
			destroy lnv_calc_data
			return
		end if

		IF Not lstr_frt[1].ws_pct > 0 THEN SetNull(lstr_frt[1].ws_pct)
		IF Not lstr_frt[1].ws_rate > 0 THEN SetNull(lstr_frt[1].ws_rate)
		IF Not lstr_frt[1].mts > 0 THEN SetNull(lstr_frt[1].mts)
		IF Not lstr_frt[1].min_1 > 0 THEN SetNull(lstr_frt[1].min_1)
		IF Not lstr_frt[1].min_2 > 0 THEN SetNull(lstr_frt[1].min_2)
		IF Not lstr_frt[1].over_1 >= 0 THEN SetNull(lstr_frt[1].over_1)
		IF Not lstr_frt[1].over_2 >= 0 THEN SetNull(lstr_frt[1].over_2)
		IF IsNull(lstr_frt[1].lumpsum) THEN lstr_frt[1].lumpsum = 0
		
		//M5-6 Added by LGX001 on 27/02/2012.
		if dw_freight_claim.getitemnumber(1, "freight_reload") = 1 then
			ld_bol_quantity = uo_frt_balance.uf_get_max_bol_quantity_departure(li_vessel, ls_voyage, li_chart)
		else
			ld_bol_quantity = uo_frt_balance.uf_get_bol_quantity(li_vessel, ls_voyage, li_chart)
		end if
		if isnull(ld_bol_quantity) then ld_bol_quantity = 0
		dw_freight_claim.setitem(1, "bol_load_quantity", ld_bol_quantity)
		
		dw_freight_claim.SetItem(1,"freight_ws",lstr_frt[1].ws_pct)
		if id_fixed_exrate > 0 then
			dw_freight_claim.SetItem(1,"freight_ws_rate",lstr_frt[1].ws_rate * id_fixed_exrate / 100)
			if lstr_frt[1].bunker_escalation <> 0 then
				dw_freight_claim.SetItem(1,"freight_per_mts",(lstr_frt[1].mts + lstr_frt[1].bunker_escalation)* id_fixed_exrate / 100)
			else
				dw_freight_claim.SetItem(1,"freight_per_mts",lstr_frt[1].mts * id_fixed_exrate / 100)
			end if
			dw_freight_claim.SetItem(1,"freight_main_lumpsum",lstr_frt[1].lumpsum * id_fixed_exrate / 100)
		else
			dw_freight_claim.SetItem(1,"freight_ws_rate",lstr_frt[1].ws_rate)
			if lstr_frt[1].bunker_escalation <> 0 then
				dw_freight_claim.SetItem(1,"freight_per_mts",lstr_frt[1].mts + lstr_frt[1].bunker_escalation)
			else
				dw_freight_claim.SetItem(1,"freight_per_mts",lstr_frt[1].mts)
			end if
			dw_freight_claim.SetItem(1,"freight_main_lumpsum",lstr_frt[1].lumpsum )
		end if
		for li_add_lump = 1 to dw_add_lumpsums.rowcount( ) 
			dw_add_lumpsums.deleterow(1)
			li_add_lump --
		next
		for li_add_lump = 1 to upperbound(lstr_frt[1].addit_lump)
			IF IsNull(lstr_frt[1].addit_lump[li_add_lump]) THEN lstr_frt[1].addit_lump[li_add_lump] = 0
			IF IsNull(lstr_frt[1].add_lump_comment[li_add_lump]) THEN lstr_frt[1].add_lump_comment[li_add_lump] = ""
			if lstr_frt[1].addit_lump[li_add_lump] <> 0 then
				dw_add_lumpsums.ScrollToRow(dw_add_lumpsums.insertrow(0)) 
				dw_add_lumpsums.SetItem(li_add_lump,"vessel_nr",li_vessel)
				dw_add_lumpsums.SetItem(li_add_lump,"voyage_nr",ls_voyage)
				dw_add_lumpsums.SetItem(li_add_lump,"chart_nr",li_chart)
				dw_add_lumpsums.SetItem(li_add_lump,"claim_nr",li_claim)
				if id_fixed_exrate > 0 then
					dw_add_lumpsums.SetItem(li_add_lump,"add_lumpsums",lstr_frt[1].addit_lump[li_add_lump] * id_fixed_exrate / 100)
				else
					dw_add_lumpsums.SetItem(li_add_lump,"add_lumpsums",lstr_frt[1].addit_lump[li_add_lump])
				end if
				dw_add_lumpsums.SetItem(li_add_lump,"comment",lstr_frt[1].add_lump_comment[li_add_lump])
				IF lstr_frt[1].adr_com_lump[li_add_lump] THEN 
					dw_add_lumpsums.SetItem(li_add_lump,"adr_comm",1)
				ELSE
					dw_add_lumpsums.SetItem(li_add_lump,"adr_comm",0)
				END IF
				IF lstr_frt[1].bro_com_lump[li_add_lump] THEN 
					dw_add_lumpsums.SetItem(li_add_lump,"bro_comm",1)
				ELSE
					dw_add_lumpsums.SetItem(li_add_lump,"bro_comm",0)
				END IF	
			end if
		next
		dw_freight_claim.SetItem(1,"freight_min_1",lstr_frt[1].min_1)
		dw_freight_claim.SetItem(1,"freight_min_2",lstr_frt[1].min_2)
		dw_freight_claim.SetItem(1,"freight_overage_1",lstr_frt[1].over_1)
		dw_freight_claim.SetItem(1,"freight_overage_2",lstr_frt[1].over_2)
	case "DEM"
		li_rc = lnv_calc_data.uf_dem_des_data( li_vessel, ls_voyage, li_chart, ll_cal_cerpID , lstr_dem)
		if li_rc <> 1 then
			MessageBox("Refresh failed", "Refresh function failed when trying to retrieve demurrage claim data")
			destroy lnv_calc_data
			return
		end if
		
//			dw_dem_des_claim.SetItem( 1,"load_laytime_allowed", 0)	
		IF  lstr_dem[1].hour_rate > 0 THEN 
			dw_dem_des_claim.SetItem( 1,"load_hourly_rate", lstr_dem[1].hour_rate)				
			dw_dem_des_claim.event itemchanged(1, dw_dem_des_claim.object.load_hourly_rate,string( lstr_dem[1].hour_rate))
		END IF
		IF  lstr_dem[1].daily_rate > 0 THEN
			dw_dem_des_claim.SetItem( 1,"load_daily_rate", lstr_dem[1].daily_rate)	
			dw_dem_des_claim.SetItem( 1,"load_hourly_rate", li_null)				
			dw_dem_des_claim.event itemchanged(1, dw_dem_des_claim.object.load_daily_rate,string( lstr_dem[1].daily_rate))
		END IF	
		IF  lstr_dem[1].laytime_allowed > 0 THEN 
			dw_dem_des_claim.SetItem( 1,"load_laytime_allowed", lstr_dem[1].laytime_allowed)
			dw_dem_des_claim.SetItem( 1,"load_hourly_rate", li_null)				
			dw_dem_des_claim.SetItem( 1,"load_daily_rate", li_null)	
			dw_dem_des_claim.event itemchanged(1, dw_dem_des_claim.object.load_laytime_allowed,string( lstr_dem[1].laytime_allowed))
		END IF
		
		if dw_dem_des_claim.getitemstatus(1, "load_laytime_allowed", Primary!) = DataModified! and lstr_dem[1].d_other_allowed > 0 then
			dw_dem_des_claim.setitem(1, "load_laytime_allowed", dw_dem_des_claim.getitemdecimal(1, "load_laytime_allowed") + lstr_dem[1].d_other_allowed)
		end if
		
//			dw_dem_des_claim.SetItem( 1,"disch_laytime_allowed", 0)	
		IF  lstr_dem[1].disch_hour_rate > 0 THEN 
			dw_dem_des_claim.SetItem( 1,"disch_hourly_rate", lstr_dem[1].disch_hour_rate)
			dw_dem_des_claim.event itemchanged(1, dw_dem_des_claim.object.disch_hourly_rate,string( lstr_dem[1].disch_hour_rate))
		END IF	
		IF  lstr_dem[1].disch_daily_rate > 0 THEN 
			dw_dem_des_claim.SetItem( 1,"disch_daily_rate", lstr_dem[1].disch_daily_rate)
			dw_dem_des_claim.SetItem( 1,"disch_hourly_rate", li_null)				
			dw_dem_des_claim.event itemchanged(1, dw_dem_des_claim.object.disch_daily_rate,string( lstr_dem[1].disch_daily_rate))
		END IF
		IF  lstr_dem[1].disch_allowed > 0 THEN 
			dw_dem_des_claim.SetItem( 1,"disch_laytime_allowed", lstr_dem[1].disch_allowed)	
			dw_dem_des_claim.SetItem( 1,"disch_hourly_rate", li_null)				
			dw_dem_des_claim.SetItem( 1,"disch_daily_rate", li_null)	
			dw_dem_des_claim.event itemchanged(1, dw_dem_des_claim.object.disch_laytime_allowed,string( lstr_dem[1].disch_allowed))
		END IF
		dw_dem_des_claim.SetItem( 1,"calcaioid", li_null)
		dw_dem_des_claim.SetItem( 1,"port_code", "          ") /* MUST BE 10 BLANKS  !!!! */
		dw_dem_des_rates.SetItem( 1,"port_code", "          ") /* MUST BE 10 BLANKS  !!!! */
		dw_dem_des_claim.SetItem( 1,"dem_des_purpose", "X")
		dw_dem_des_rates.SetItem( 1,"dem_des_purpose", "X")

		// This line is set by Leith 17/1-96 to make print of laytime possible, because
		// laytime statement checks for Settled <> 0.						
		dw_dem_des_claim.SetItem(1,"dem_des_settled",2)

		/* Set dem/des rates from calc. data*/
		if dw_dem_des_rates.rowCount() = 1 then
			if id_fixed_exrate > 0 then
				dw_dem_des_rates.SetItem( 1,"dem_rate_day", lstr_dem[1].dem_rate * id_fixed_exrate / 100)
				dw_dem_des_rates.SetItem( 1,"des_rate_day", lstr_dem[1].des_rate * id_fixed_exrate / 100)
			else
				dw_dem_des_rates.SetItem( 1,"dem_rate_day", lstr_dem[1].dem_rate)
				dw_dem_des_rates.SetItem( 1,"des_rate_day", lstr_dem[1].des_rate)
			end if
			dw_dem_des_rates.SetItem( 1,"rate_hours", lstr_dem[1].hours)
			//dw_dem_des_claim.postevent(retrieveend!)
		else
			MessageBox("Information", "There is more than one demurrage rate updated, hence they will not be refreshed from the calculation. Please update them manually, if required.")
		end if

			//		// if more than one rate - delete the rest
			//		ll_rows = dw_dem_des_rates.rowCount()
			//		ll_rows -= 1
			//		for ll_row = 1 to ll_rows
			//			dw_dem_des_rates.deleterow(2)
			//		next
end choose
destroy lnv_calc_data

cb_update.postevent(clicked!)
cb_update.post setfocus()
return

end event

type cb_delete_received from commandbutton within w_claims
boolean visible = false
integer x = 2683
integer y = 1908
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Recd"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_freight_received.GetRow()
IF ll_row > 0 THEN
	dw_freight_received.DeleteRow(ll_row)
END IF

cb_update.Default = TRUE
this.Default = FALSE
end event

type cb_new_received from commandbutton within w_claims
boolean visible = false
integer x = 2359
integer y = 1908
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Recd"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_freight_received.InsertRow(0)
dw_freight_received.SetItem(ll_row,"vessel_nr",dw_freight_claim.GetItemNumber(1,"vessel_nr"))
dw_freight_received.SetItem(ll_row,"voyage_nr",dw_freight_claim.GetItemString(1,"voyage_nr"))
dw_freight_received.SetItem(ll_row,"chart_nr",dw_freight_claim.GetItemNumber(1,"chart_nr"))
dw_freight_received.SetItem(ll_row,"claim_nr",dw_freight_claim.GetItemNumber(1,"claim_nr"))
dw_freight_received.SetItem(ll_row,"freight_rec_date",date(string(today())))
dw_freight_received.SetFocus()
dw_freight_received.ScrollToRow(ll_row)
dw_freight_received.SetColumn(1)
cb_update.Default = TRUE
this.Default = FALSE
end event

type cb_close_bulk from commandbutton within w_claims
boolean visible = false
integer x = 2295
integer y = 1692
integer width = 283
integer height = 76
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
boolean cancel = true
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

dw_bulk_amounts.Reset()
dw_bulk_amounts.Hide()
this.hide()
end event

type uo_balance from u_claimbalance within w_claims
integer x = 37
integer y = 2316
integer height = 140
boolean bringtotop = true
end type

on uo_balance.destroy
call u_claimbalance::destroy
end on

type cb_unlock from commandbutton within w_claims
integer x = 1422
integer y = 1468
integer width = 343
integer height = 100
integer taborder = 230
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Un&lock"
end type

event clicked;string	ls_invoice_nr, ls_voyage_nr, ls_errtext, ls_comment
long		ll_row, ll_chart_nr, ll_claim_nr, ll_vessel_nr
datetime	ldt_action_date

ll_row = dw_list_claims.getselectedrow(0)
if ll_row <= 0 then return

if wf_datawindow_modified() <> c#return.Success then return	//M5-2 Added by ZSW001 on 11/01/2012.

ls_invoice_nr = f_get_string("Enter AX Invoice Number", 32, "A", "", false)
if isnull(ls_invoice_nr) then return

ll_chart_nr  = dw_list_claims.getitemnumber(ll_row, "chart_nr")
ll_vessel_nr = dw_list_claims.getitemnumber(ll_row, "vessel_nr")
ls_voyage_nr = dw_list_claims.getitemstring(ll_row, "voyage_nr")
ll_claim_nr  = dw_list_claims.getitemnumber(ll_row, "claim_nr")

UPDATE CLAIMS
   SET INVOICE_NR = :ls_invoice_nr,
	    LOCKED = 0
 WHERE CHART_NR  = :ll_chart_nr  AND
       VESSEL_NR = :ll_vessel_nr AND
		 VOYAGE_NR = :ls_voyage_nr AND
		 CLAIM_NR  = :ll_claim_nr;

if sqlca.sqlcode <> 0 then
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messagebox("Update Error", ls_errtext, stopsign!)
	return
end if

ldt_action_date = datetime(today(), now())
ls_comment = "Invoice number " + ls_invoice_nr + " entered manually."

INSERT INTO CLAIM_ACTION(CHART_NR, VESSEL_NR, VOYAGE_NR, CLAIM_NR, C_ACTION_DATE, C_ACTION_COMMENT, C_ACTION_ASSIGNED_TO)
     VALUES (:ll_chart_nr, :ll_vessel_nr, :ls_voyage_nr, :ll_claim_nr, :ldt_action_date, :ls_comment, :uo_global.is_userid);

if sqlca.sqlcode <> 0 then
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messagebox("Update Error", ls_errtext, stopsign!)
	return
end if

commit;

this.enabled = false

dw_list_claims.event clicked(0, 0, ll_row, dw_list_claims.object.voyage_nr)

end event

type cb_new from u_cb_option within w_claims
event ue_commandex ( string as_text,  string as_tag )
integer x = 2967
integer y = 1468
integer taborder = 190
boolean bringtotop = true
boolean enabled = false
string text = "&New >>"
end type

event ue_commandex(string as_text, string as_tag);choose case as_tag
	case 'FRT'
		wf_new_freight()
	case 'DEM'
		wf_new_dem_des()
	case 'DEV'
		wf_new_deviation()
	case 'HEA'
		wf_new_heating()
	case else
		wf_new_misc(as_tag)
end choose

end event

event constructor;call super::constructor;mt_n_datastore lds_temp
long ll_row, ll_rowCount
string ls_itemTitle, ls_claimType
long ll_parent = 0, ll_index = 0
long ll_prevgroup = 0, ll_group

lds_temp = create mt_n_datastore
lds_temp.DataObject = "d_sq_gr_claimtypes_menuitem"
lds_temp.SetTransObject(SQLCA)
lds_temp.Retrieve()

ll_rowCount = lds_temp.RowCount()

for ll_row = 1 to ll_rowCount
	ls_claimType = lds_temp.GetItemString(ll_row, "claim_type")
	ls_itemTitle = lds_temp.GetItemString(ll_row, "claim_desc") &
		+ "~t" + lds_temp.GetItemString(ll_row, "incomerecharge")
	if ll_parent = 0 &
		and lds_temp.GetItemNumber(ll_row, "show_as_primary") = 0 then
		ll_parent = of_addmenuitem(ll_parent, "Misc")
	end if
	ll_group = lds_temp.GetItemNumber(ll_row, "group_order")
	if ll_prevgroup <> 0 and ll_group <> ll_prevgroup then
		//ll_index = of_addmenuitem(ll_parent, "-")
	end if
	ll_prevgroup = ll_group
	ll_index = of_addmenuitem(ll_parent, ls_itemTitle, ls_claimType)
next

//ll_index = of_addmenuitem(ll_parent, "-")
ll_index = of_addmenuitem(ll_parent, "Misc", "**MISC**")

end event

type st_1 from u_topbar_background within w_claims
end type

type dw_add_lumpsums from datawindow within w_claims
boolean visible = false
integer x = 2203
integer y = 740
integer width = 1225
integer height = 416
integer taborder = 260
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_add_lumpsums"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type cb_scroll_prior_dem from commandbutton within w_claims
boolean visible = false
integer x = 3246
integer y = 700
integer width = 73
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;Integer li_rows

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

IF Not st_dem_count.Text = "1" THEN
	dw_dem_des_claim.ScrollPriorRow()
	 li_rows =  Integer(st_dem_count.Text)
	 li_rows --
	st_dem_count.Text = String(li_rows)
END IF
	
wf_dem_scroll()
end event

type st_dem_count from statictext within w_claims
boolean visible = false
integer x = 3323
integer y = 708
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_dem_total from statictext within w_claims
boolean visible = false
integer x = 3465
integer y = 708
integer width = 192
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_scroll_next_dem from commandbutton within w_claims
boolean visible = false
integer x = 3662
integer y = 700
integer width = 73
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

on clicked;Integer li_rows

IF Not st_dem_count.Text = String(dw_dem_des_claim.RowCount()) THEN
	dw_dem_des_claim.ScrollNextRow()
	 li_rows =  Integer(st_dem_count.Text)
	 li_rows ++
	st_dem_count.Text = String(li_rows)
END IF

wf_dem_Scroll()
end on

type cb_l_d_amount from commandbutton within w_claims
boolean visible = false
integer x = 3739
integer y = 700
integer width = 466
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "L/D Dem/Des"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

uo_calc_dem_des_claims uo_bulk
uo_bulk = CREATE uo_calc_dem_des_claims
s_calc_claim lstr_amounts 

 lstr_amounts = uo_bulk.uf_get_bulk_amount(ii_vessel_nr,is_voyage_nr,il_charter_nr, &
			             dw_dem_des_claim.GetItemNumber(1,"claim_nr"))

dw_bulk_amounts.Show()
cb_close_bulk.Show()

dw_bulk_amounts.InsertRow(0)
dw_bulk_amounts.SetItem(1,"load_des",lstr_amounts.load_des)
dw_bulk_amounts.SetItem(1,"load_dem",lstr_amounts.load_dem)
dw_bulk_amounts.SetItem(1,"disch_des",lstr_amounts.disch_des)
dw_bulk_amounts.SetItem(1,"disch_dem",lstr_amounts.disch_dem)

DESTROY uo_bulk
end event

type cb_afc_update_recieved from commandbutton within w_claims
boolean visible = false
integer x = 3310
integer y = 1204
integer width = 343
integer height = 84
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update Recd"
end type

event clicked;Decimal {2} ld_afc_recieved, freight_balance, ld_rec, ld_exrate, ld_del_rec, ld_del_rate, ld_amount_usd, ld_del_rec_usd
String ls_rec, ls_voyage, ls_curr_code
Integer li_claim, li_vessel, li_charter,li_afcrows,li_counter
Datetime ld_date, ld_del_date
n_claimcurrencyadjust lnv_claimcurrencyadjust

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF


IF dw_afc_recieved.Update(TRUE, FALSE) = 1 THEN	
	dw_afc_recieved.ResetUpdate()
	COMMIT USING SQLCA;
	li_afcrows = dw_afc.RowCount()
	uo_afc.SetRedraw(FALSE)
	FOR li_counter = 1 TO li_afcrows
		freight_balance += uo_afc.uf_calculate_balance(dw_afc.GetItemNumber(li_counter,"freight_advanced_vessel_nr"), &
		                		 dw_afc.GetItemString(li_counter,"freight_advanced_voyage_nr"), &
					         dw_afc.GetItemNumber(li_counter,"freight_advanced_chart_nr"), &					 		   
				                 dw_afc.GetItemNumber(li_counter,"freight_advanced_claim_nr"), &
 					         dw_afc.GetItemNumber(li_counter,"freight_advanced_afc_nr"))
	NEXT
	dw_claim_base.SetItem(1,"claim_amount",freight_balance)
	lnv_claimcurrencyadjust.of_getclaimamounts( dw_afc.GetItemNumber(1,"freight_advanced_vessel_nr"), &
		                		 dw_afc.GetItemString(1,"freight_advanced_voyage_nr"), &
					         dw_afc.GetItemNumber(1,"freight_advanced_chart_nr"), &					 		   
				                 dw_afc.GetItemNumber(1,"freight_advanced_claim_nr"), &
									  freight_balance, &
									  ld_amount_usd, false)
	dw_claim_base.SetItem(1,"claim_amount_usd",ld_amount_usd)
	dw_claim_base.Update()
	COMMIT;
	uo_afc.SetRedraw(TRUE)
	 uo_afc.uf_calculate_balance(dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_vessel_nr"), &
		                		 dw_afc.GetItemString(dw_afc.GetRow(),"freight_advanced_voyage_nr"), &
					         dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_chart_nr"), &					 		   
				                 dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_claim_nr"), &
 					         dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_afc_nr"))
	
				uo_balance.of_claimbalance( dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_vessel_nr"), &
									 dw_afc.GetItemString(dw_afc.GetRow(),"freight_advanced_voyage_nr"), &
									 dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_chart_nr"), &
									  dw_afc.GetItemNumber(dw_afc.GetRow(),"freight_advanced_claim_nr"))
			
			

			SELECT SUM(AFC_RECIEVED)
			INTO :ld_afc_recieved
			FROM FREIGHT_ADVANCED_RECIEVED
			WHERE VESSEL_NR = :ii_vessel_nr
			AND VOYAGE_NR = :is_voyage_nr
			AND CHART_NR = :il_charter_nr
			USING SQLCA;
			COMMIT USING SQLCA;
			ls_rec = "sum_recieved.text = " + "'" + String(ld_afc_recieved) + "'" 
			dw_afc.Modify(ls_rec)

ELSE
			ROLLBACK;
END IF
dw_afc_recieved.SetTabOrder(1,0)
dw_afc_recieved.SetTabOrder(2,0)
dw_afc_recieved.SetTabOrder(3,0)
dw_afc_recieved.SelectRow(0,FALSE)
end event

type cb_dem_des_new_rate from commandbutton within w_claims
boolean visible = false
integer x = 3657
integer y = 1204
integer width = 343
integer height = 84
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New Rate"
end type

event clicked;long ll_row

dw_dem_des_rates.Modify("dem_rate_day.Protect='0'")
dw_dem_des_rates.Modify("des_rate_day.Protect='0'")
dw_dem_des_rates.Modify("rate_hours.Protect='0'")
dw_dem_des_rates.Object.dem_rate_day.Background.Color='31775128'
dw_dem_des_rates.Object.des_rate_day.Background.Color='31775128'
dw_dem_des_rates.Object.rate_hours.Background.Color='31775128'

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_dem_des_rates.InsertRow(0)
dw_dem_des_rates.SetItem(ll_row,"vessel_nr",dw_dem_des_rates.GetItemNumber(1,"vessel_nr"))
dw_dem_des_rates.SetItem(ll_row,"voyage_nr",dw_dem_des_rates.GetItemString(1,"voyage_nr"))
dw_dem_des_rates.SetItem(ll_row,"chart_nr",dw_dem_des_rates.GetItemNumber(1,"chart_nr"))
dw_dem_des_rates.SetItem(ll_row,"claim_nr",dw_dem_des_rates.GetItemNumber(1,"claim_nr"))
dw_dem_des_rates.SetItem(ll_row,"port_code",dw_dem_des_rates.GetItemString(1,"port_code"))
dw_dem_des_rates.SetItem(ll_row,"dem_des_purpose",dw_dem_des_rates.GetItemString(1,"dem_des_purpose"))
dw_dem_des_rates.SetItem(ll_row,"rate_number",ll_row)
dw_dem_des_rates.SetFocus()
dw_dem_des_rates.ScrollToRow(ll_row)
dw_dem_des_rates.SetColumn(1)

cb_update.Default = TRUE
this.Default = FALSE
end event

type cb_dem_des_delete_rate from commandbutton within w_claims
boolean visible = false
integer x = 4005
integer y = 1204
integer width = 343
integer height = 84
integer taborder = 180
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Rate"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if dw_dem_des_rates.rowCount() = 1 then 
	dw_dem_des_rates.setItem(1, "rate_number", 1)
	cb_update.Default = TRUE
	this.Default = FALSE
	return   //there shall always be at least one rate
end if

ll_row = dw_dem_des_rates.GetRow()
IF ll_row > 0 THEN
	dw_dem_des_rates.DeleteRow(ll_row)
END IF

dw_dem_des_rates.setSort("rate_number A")
dw_dem_des_rates.Sort()
for ll_row = 1 to dw_dem_des_rates.rowCount()
	dw_dem_des_rates.setItem(ll_row, "rate_number", ll_row)
next	

cb_update.Default = TRUE
this.Default = FALSE


IF dw_dem_des_rates.rowcount( ) = 1 then
	dw_dem_des_rates.Modify("dem_rate_day.Protect='1'")
	dw_dem_des_rates.Modify("des_rate_day.Protect='1'")
	dw_dem_des_rates.Modify("rate_hours.Protect='1'")
	dw_dem_des_rates.Object.dem_rate_day.Background.Color='15527148'
	dw_dem_des_rates.Object.des_rate_day.Background.Color='15527148'
	dw_dem_des_rates.Object.rate_hours.Background.Color='15527148'
	dw_dem_des_rates.setitem(1, "rate_hours", 0)
end if
end event

type cb_broker from commandbutton within w_claims
boolean visible = false
integer x = 1403
integer y = 828
integer width = 82
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;string ls_broker_sn, ls_null
long	ll_calcID, ll_cerpID, ll_chartnr, ll_broker_nr, ll_null
dec	ld_comm_percent, ld_null

setnull(ld_null)
setnull(ll_null)
setnull(ls_null)
SELECT CAL_CALC_ID INTO :ll_calcID FROM VOYAGES WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :is_voyage_nr ;
COMMIT;

if ll_calcID < 2 then   //no allocation to calculation - select from all brokers
	ls_broker_sn = f_select_from_list("dw_active_broker_list",2,"Shortname",3,"Fullname",2,"Select Broker",false)
	if not isnull(ls_broker_sn) then
		dw_claim_base.setTaborder( "brokers_broker_sn", 12 )
		dw_claim_base.SetColumn("brokers_broker_sn")
		dw_claim_base.SetText(ls_broker_sn)
		dw_claim_base.AcceptText()
		dw_claim_base.setTaborder( "brokers_broker_sn", 0 )
		dw_claim_base.SetFocus()
	end if	
else
	ll_broker_nr = dw_claim_base.getitemnumber(1, "broker_nr")
	if isnull(ll_broker_nr) then ll_broker_nr = 0
	if dw_claim_base.getitemnumber(1, "broker_commission") = 0  and dw_claim_base.getitemnumber(1, "broker_commission") = 0 and &
		dw_claim_base.getitemnumber(1, "pool_manager_commission") = 0 and ll_broker_nr = 0 then
		messagebox("Notice","No broker can be selected since no broker commission is being calcuated")
		return
	end if	
	
	ll_chartnr = dw_claim_base.getItemNumber(1, "chart_nr")
	SELECT TOP 1 CAL_CARG.CAL_CERP_ID 
		INTO :ll_cerpID 
		FROM CAL_CARG, CAL_CERP 
		WHERE CAL_CARG.CAL_CERP_ID = CAL_CERP.CAL_CERP_ID
		AND CAL_CARG.CAL_CALC_ID = :ll_calcid 
		AND CAL_CERP.CHART_NR = :ll_chartnr 
		ORDER BY CAL_CARG_TOTAL_UNITS DESC  ;
	COMMIT;	
	//M5-6 Begin modified by ZSW001 on 17/02/2012
	openwithparm(w_select_cp_broker, string(ll_cerpid) + "," + string(ll_broker_nr))
	ll_broker_nr = message.doubleparm
	if isnull(ll_broker_nr) then return 	// cancel by user
	if ll_broker_nr = 0 then 					// no broker selected
		setnull(ls_broker_sn)
		dw_claim_base.setitem(1, "broker_nr", ll_null)
		dw_claim_base.setitem(1, "claims_broker_com", ld_null)
		dw_claim_base.setitem(1, "brokers_broker_sn", ls_broker_sn)
		dw_claim_base.setitem(1, "claims_claim_email", ls_null)
		dw_claim_base.setfocus()
		return
	end if
	
	SELECT BROKERS.BROKER_SN, 
	       CAL_COMM.CAL_COMM_PERCENT
	  INTO :ls_broker_sn, 
	       :ld_comm_percent
	  FROM CAL_COMM, BROKERS
	 WHERE CAL_COMM.BROKER_NR = BROKERS.BROKER_NR AND
	       CAL_COMM.CAL_CERP_ID = :ll_cerpID AND
			 BROKERS.BROKER_NR = :ll_broker_nr;
	
	dw_claim_base.setitem(1, "claims_broker_com", ld_comm_percent)
	//M5-6 End modified by ZSW001 on 17/02/2012
		
	dw_claim_base.setTabOrder( "brokers_broker_sn", 12 )
	dw_claim_base.SetColumn("brokers_broker_sn")
	dw_claim_base.SetText(ls_broker_sn)
	dw_claim_base.AcceptText()
	dw_claim_base.setTabOrder( "brokers_broker_sn", 0 )
	dw_claim_base.SetFocus()
end if

end event

type dw_claim_base from uo_datawindow within w_claims
event ue_accepttext ( )
boolean visible = false
integer x = 759
integer y = 272
integer width = 1335
integer height = 1116
integer taborder = 30
string dataobject = "d_sq_ff_claim_base"
boolean border = false
end type

event ue_accepttext();if ib_dw_has_focus = false then
   this.setcolumn("claim_responsible")
end if
end event

event itemchanged;call super::itemchanged;string ls_sn, ls_claim_email
integer li_nr
datetime ld_dato
long ll_days,ll_ndays,ll_tdays
// key columns of claims
long ll_vessel_nr, ll_chart_nr, ll_cp_id
string ls_voyage_nr, ls_claim_type, ls_username
decimal ldc_null

if dwo.name <> "claim_responsible" then AcceptText()

CHOOSE CASE dwo.Name
	CASE "discharge_date"
		ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
		ll_ndays = dw_claim_base.GetItemNumber(1,"notice_days")
		ll_tdays = dw_claim_base.GetItemNumber(1,"timebar_days")
		dw_claim_base.SetItem(1,"notice_date",RelativeDate(Date(ld_dato),ll_ndays))			
		dw_claim_base.SetItem(1,"timebar_date",RelativeDate(Date(ld_dato),ll_tdays))
	CASE "notice_days"
		ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
		ll_days = Integer(GetText())	
		dw_claim_base.SetItem(1,"notice_date",RelativeDate(Date(ld_dato),ll_days))
	CASE "timebar_days"
		ld_dato = dw_claim_base.GetItemDateTime(1,"discharge_date")
		ll_days = Integer(GetText())		
		dw_claim_base.SetItem(1,"timebar_date",RelativeDate(Date(ld_dato),ll_days))
	CASE "brokers_broker_sn"
		ls_sn = dw_claim_base.GetItemString(1,"brokers_broker_sn")
		IF IsNull(ls_sn) THEN
			SetNull(li_nr)
			setnull(ls_claim_email)
			dw_claim_base.SetItem(1,"broker_nr",li_nr)
			dw_claim_base.setitem(1, "claims_claim_email", ls_claim_email)
		ELSE
		   SELECT BROKER_NR, BROKER_EMAIL INTO :li_nr, :ls_claim_email FROM BROKERS WHERE BROKER_SN = :ls_sn USING SQLCA;
			COMMIT USING SQLCA;
			dw_claim_base.setitem(1, "broker_nr", li_nr)
//			if this.getitemstring(1, "claim_type") = "DEM" then
				if isnull(ls_claim_email) or trim(ls_claim_email) = "" then ls_claim_email = "no email address found in Brokers system table"
				dw_claim_base.setitem(1, "claims_claim_email", ls_claim_email)
//			end if
		END IF	
	CASE "offices_office_sn"
		ls_sn = dw_claim_base.GetItemString(1,"offices_office_sn")
		IF IsNull(ls_sn) THEN
			SetNull(li_nr)
			dw_claim_base.SetItem(1,"office_nr",li_nr)
		ELSE
		   	SELECT OFFICE_NR INTO :li_nr FROM OFFICES WHERE OFFICE_SN = :ls_sn USING SQLCA;
			COMMIT USING SQLCA;
			dw_claim_base.SetItem(1,"office_nr",li_nr)
		END IF
	CASE "claim_amount"
		IF dw_claim_base.GetItemNumber(1,"claims_claim_in_log") = 1 THEN
			MessageBox("IMPORTANT WARNING","If updated the claim amount will change, but " + &
					"the claim has been transferred to CMS prior to this. If you update, " + &
					"please adjust (NOW) manually in CMS, or if in RRIS make adjustment there.") 
		END IF
		
		if il_lumpsum_visible = 1 and not ( il_bunker_visible = 1 or il_time_visible = 1 ) then
			ls_claim_type = dw_claim_base.GetItemString(row, COLUMN_CLAIM_TYPE)
			if not (ls_claim_type = 'FRT' or ls_claim_type = 'DEM') then
				if dw_hea_dev_claim.getrow() > 0 then
					dw_hea_dev_claim.setitem(1, COLUMN_LUMPSUM, dec(data))
					wf_filtermisctype()
				end if
			end if
		end if
		
	case COLUMN_CURRENCY_CODE
		ll_vessel_nr = dw_claim_base.GetItemNumber(row, COLUMN_VESSEL_NR)
		ls_voyage_nr = dw_claim_base.GetItemString(row, COLUMN_VOYAGE_NR)
		ll_chart_nr = dw_claim_base.GetItemNumber(row, COLUMN_CHART_NR)
		ll_cp_id = dw_claim_base.GetItemNumber(row, COLUMN_CP_ID)
		ls_claim_type = dw_claim_base.GetItemString(row, COLUMN_CLAIM_TYPE)
		
		s_claim_base_data lstr_claim_base_data
		u_calc_nvo uo_calc_nvo
		uo_calc_nvo = create u_calc_nvo
		if uo_calc_nvo.uf_cargo_base_data(ll_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_cp_id, lstr_claim_base_data ) then
			if ls_claim_type = "DEM" then
				if lstr_claim_base_data.set_ex_rate &
					and lstr_claim_base_data.dem_curr_code = data &
					and lstr_claim_base_data.dem_curr_code <> 'USD' then
					st_setexrate.visible = true
				else
					st_setexrate.visible = false
				end if
			else
				if lstr_claim_base_data.set_ex_rate &
					and lstr_claim_base_data.frt_curr_code = data &
					and lstr_claim_base_data.frt_curr_code <> 'USD' then
					st_setexrate.visible = true
				else
					st_setexrate.visible = false
				end if
			end if
		end if
		destroy uo_calc_nvo
		
	CASE "claim_responsible"
		
		if iuo_dddw_search_responsible.uf_itemchanged() = 1 then
			return 2
		else
			this.accepttext()
			ls_username = this.describe("Evaluate('lookupdisplay(claim_responsible)', 1)")
			this.setitem(row, "claims_created_by", ls_username)
		end if	
		
	CASE "claim_type"
		wf_get_misc_options(data, il_bunker_visible, il_lumpsum_visible, il_time_visible)
		wf_show_hide_dw(data)
		
		if dw_hea_dev_claim.rowcount() > 0 then
			setnull(ldc_null)
			if il_bunker_visible <> 1 then
				dw_hea_dev_claim.setitem(1, "hfo_ton", ldc_null)
				dw_hea_dev_claim.setitem(1, "hfo_price", ldc_null)
				dw_hea_dev_claim.setitem(1, "do_ton", ldc_null)
				dw_hea_dev_claim.setitem(1, "do_price", ldc_null)
				dw_hea_dev_claim.setitem(1, "go_ton", ldc_null)
				dw_hea_dev_claim.setitem(1, "go_price", ldc_null)
				dw_hea_dev_claim.setitem(1, "lshfo_ton", ldc_null)
				dw_hea_dev_claim.setitem(1, "lshfo_price", ldc_null)
			end if
			
			if il_lumpsum_visible <> 1 then
				dw_hea_dev_claim.setitem(1, COLUMN_LUMPSUM, ldc_null)
			elseif il_lumpsum_visible = 1 and not ( il_bunker_visible = 1 or il_time_visible = 1 ) then
				this.setitem(1, "claim_amount", dw_hea_dev_claim.getitemnumber(1, COLUMN_LUMPSUM))
			end if
			
			if il_time_visible <> 1 then
				dw_hea_dev_claim.setitem(1, "hea_dev_hours", ldc_null)
				dw_hea_dev_claim.setitem(1, "hea_dev_price_pr_day", ldc_null)
			end if
		end if
END CHOOSE

end event

event retrieveend;call super::retrieveend;
dw_claim_base.SetTabOrder("claims_expect_receive_date",300)
end event

event constructor;call super::constructor;// Sets the address commission button to visible if user has administrator status

//If uo_global.ii_access_level = 3 Then dw_claim_base.object.b_address.Visible = 1
end event

event buttonclicked;call super::buttonclicked;// Get original address commission value
id_adrs_comm = dw_claim_base.GetItemDecimal(dw_claim_base.GetRow(),"claims_address_com")

// Unlock the address commission field.
//If dw_claim_base.GetItemString(dw_claim_base.GetRow(),"claim_type") = "FRT" Then 
//Else
//	MessageBox("Information","This functionality is only available for freight claims")
//End if
end event

event editchanged;call super::editchanged;if dwo.name = "claim_responsible" then	
	iuo_dddw_search_responsible.uf_editchanged()
end if
end event

event itemerror;call super::itemerror;if dwo.name = "claim_responsible" then 
	return 3
end if
end event

event losefocus;call super::losefocus;ib_dw_has_focus = false

if this.getcolumnname( ) = "claim_responsible" then
	this.event post ue_accepttext( )
end if
end event

event getfocus;call super::getfocus;ib_dw_has_focus = true

end event

type gb_base_claim from mt_u_groupbox within w_claims
boolean visible = false
integer x = 722
integer y = 224
integer width = 1408
integer height = 1212
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = ""
end type

type cb_delete_action from commandbutton within w_claims
integer x = 3662
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 300
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Action"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if uo_att_actions.enabled = false then return 

uo_att_actions.of_deleteimage( )


end event

type cb_new_action from commandbutton within w_claims
integer x = 2967
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 280
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New Action"
end type

event clicked;long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

// ll_row = dw_claim_action.InsertRow(0)

if dw_list_claims.getselectedrow( 0 ) = 0 then return 

if uo_att_actions.enabled = false then return 

ll_row = uo_att_actions.dw_file_listing.InsertRow(0)

IF ll_row > 0 THEN
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id", ii_vessel_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id_str", is_voyage_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id_int", il_charter_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id2", ii_claim_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_date", today())
	// TODO: remove this
	// uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_type", "new")
	uo_att_actions.dw_file_listing.SelectRow(0,FALSE)
	uo_att_actions.dw_file_listing.SetRow(ll_row)
	uo_att_actions.dw_file_listing.ScrollToRow(ll_row)
//	dw_claim_action.SelectRow(ll_row,TRUE)
	uo_att_actions.dw_file_listing.SetColumn("c_action_date")
	uo_att_actions.dw_file_listing.SetFocus()
//	cb_cancel_action.Enabled = TRUE
//	cb_delete_action.Enabled = FALSE
	// cb_new_action.Enabled = FALSE
//	cb_update_action.Enabled = TRUE
	cb_update_action.Default = TRUE
END IF
end event

type cb_update_action from commandbutton within w_claims
integer x = 3314
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 290
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update Action"
end type

event clicked;n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

if uo_global.ii_access_level = -1 then
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

if uo_att_actions.enabled = false then return 

uo_att_actions.dw_file_listing.accepttext( )

lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
lnv_actionrules.of_registerrulestring("description", true, "description")
if lnv_actionrules.of_validate(uo_att_actions.dw_file_listing, true) = c#return.Failure then return c#return.Failure
uo_att_actions.of_setargs(is_voyage_nr, long(ii_vessel_nr), long(ii_claim_nr), il_charter_nr)
uo_att_actions.of_updateattach()
cb_update_action.Default = false
end event

type cb_cancel_action from commandbutton within w_claims
integer x = 4009
integer y = 2324
integer width = 343
integer height = 100
integer taborder = 310
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel Action"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if uo_att_actions.enabled = false then return 

//cb_cancel_action.Enabled = FALSE
//cb_new_action.Enabled = TRUE
uo_att_actions.of_init( is_voyage_nr , long(ii_vessel_nr) ,long(ii_claim_nr), il_charter_nr)
//dw_claim_action.Retrieve(ii_vessel_nr,is_voyage_nr,ii_chart_nr,ii_claim_nr)
COMMIT USING SQLCA;
//dw_claim_action.SelectRow(0,FALSE)

// TODO: cancel all changes since last update
end event

type cb_delete_afc_recieved from commandbutton within w_claims
boolean visible = false
integer x = 2688
integer y = 1908
integer width = 320
integer height = 72
integer taborder = 330
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Recd"
end type

event clicked;long ll_row, ll_rowcounttest, ll_new_del, xx = 1 , ll_upper

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_upper = UpperBound(del_freight_rec)

ll_row = dw_afc_recieved.GetRow()
IF ll_row > 0 THEN
	FOR xx = 1TO ll_upper
		 IF del_freight_rec[xx].data_to_del = 0 THEN
			ll_new_del = xx
			xx = ll_upper
		END IF
	NEXT
	del_freight_rec[ll_new_del].data_to_del = 1
	del_freight_rec[ll_new_del].received = dw_afc_recieved.GetItemDecimal(ll_row,"afc_recieved")
	del_freight_rec[ll_new_del].rec_date = dw_afc_recieved.GetItemDateTime(ll_row,"afc_recieved_date")
	del_freight_rec[ll_new_del].received_local_curr = dw_afc_recieved.GetItemDecimal(ll_row,"afc_received_local_curr")
	dw_afc_recieved.DeleteRow(ll_row)
END IF

end event

type cb_new_afc_recieved from commandbutton within w_claims
boolean visible = false
integer x = 2363
integer y = 1908
integer width = 320
integer height = 72
integer taborder = 320
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Recd"
end type

event clicked;long ll_row,ll_afc_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_afc_row = dw_afc.GetRow()
ll_row = dw_afc_recieved.InsertRow(0)

dw_afc_recieved.SelectRow(dw_afc_recieved.GetRow(),TRUE)
dw_afc_recieved.SetItem(ll_row,"vessel_nr",dw_afc.GetItemNumber(ll_afc_row,"freight_advanced_vessel_nr"))
dw_afc_recieved.SetItem(ll_row,"voyage_nr",dw_afc.GetItemString(ll_afc_row,"freight_advanced_voyage_nr"))
dw_afc_recieved.SetItem(ll_row,"chart_nr",dw_afc.GetItemNumber(ll_afc_row,"freight_advanced_chart_nr"))
dw_afc_recieved.SetItem(ll_row,"claim_nr",dw_afc.GetItemNumber(ll_afc_row,"freight_advanced_claim_nr"))
dw_afc_recieved.SetItem(ll_row,"afc_nr",dw_afc.GetItemNumber(ll_afc_row,"freight_advanced_afc_nr"))
dw_afc_recieved.SetItem(ll_row,"afc_recieved_date",date(string(today())))
dw_afc_recieved.SelectRow(0,FALSE)
dw_afc_recieved.SetFocus()
dw_afc_recieved.ScrollToRow(ll_row)
dw_afc_recieved.SelectRow(ll_row,TRUE)
dw_afc_recieved.SetColumn(1)

end event

type cb_scroll_prior from commandbutton within w_claims
boolean visible = false
integer x = 2555
integer y = 1308
integer width = 73
integer height = 80
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;Integer li_rows

IF Not st_afc_count.Text = "1" THEN
	dw_afc.ScrollPriorRow()
	 li_rows =  Integer(st_afc_count.Text)
	 li_rows --
	st_afc_count.Text = String(li_rows)
END IF
	
wf_afc_scroll()
end event

type st_afc_count from statictext within w_claims
boolean visible = false
integer x = 2633
integer y = 1316
integer width = 64
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_afc_total from statictext within w_claims
boolean visible = false
integer x = 2702
integer y = 1316
integer width = 142
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_add_lumpsums_afc from datawindow within w_claims
boolean visible = false
integer x = 2683
integer y = 1600
integer width = 1019
integer height = 224
string title = "none"
string dataobject = "d_sq_tb_add_lumpsums_afc"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

type dw_afc_bol from datawindow within w_claims
boolean visible = false
integer x = 1847
integer y = 1712
integer width = 1810
integer height = 624
string dataobject = "dw_afc_bol"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event retrieveend;Integer li_rows, li_counter,li_vessel_nr,li_claim_nr
String ls_voyage_nr

li_rows = dw_afc_bol.RowCount()
dw_afc.Height = 545
dw_afc.Show()  

li_vessel_nr = dw_afc_bol.GetItemNumber(1,"bol_vessel_nr")
ls_voyage_nr = dw_afc_bol.GetItemString(1,"bol_voyage_nr")

SELECT MAX(CLAIM_NR)
		INTO :li_claim_nr
		FROM CLAIMS
		WHERE VESSEL_NR = :li_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr
		USING SQLCA;
COMMIT USING SQLCA;

IF IsNull(li_claim_nr) THEN
	li_claim_nr = 1
ELSE
	li_claim_nr = li_claim_nr + 1
END IF

For li_counter = 1  TO li_rows
	dw_afc.InsertRow(0)
	dw_afc.SetItem(li_counter,"freight_advanced_vessel_nr",dw_afc_bol.GetItemNumber(li_counter,"bol_vessel_nr"))
	dw_afc.SetItem(li_counter,"freight_advanced_chart_nr",dw_afc_bol.GetItemNumber(li_counter,"bol_chart_nr"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_nr",li_counter)
	dw_afc.SetItem(li_counter,"freight_advanced_voyage_nr",dw_afc_bol.GetItemString(li_counter,"bol_voyage_nr"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_agent_nr",dw_afc_bol.GetItemNumber(li_counter,"bol_agent_nr"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_port_code",dw_afc_bol.GetItemString(li_counter,"bol_port_code"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_pcn",dw_afc_bol.GetItemNumber(li_counter,"bol_pcn"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_layout",dw_afc_bol.GetItemString(li_counter,"bol_layout"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_grade_name",dw_afc_bol.GetItemString(li_counter,"bol_grade_name"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_bol_nr",dw_afc_bol.GetItemNumber(li_counter,"bol_bol_nr"))
	dw_afc.SetItem(li_counter,"freight_advanced_afc_bol_quantity",dw_afc_bol.GetItemDecimal(li_counter,"bol_bol_quantity"))
	dw_afc.SetItem(li_counter,"freight_advanced_claim_nr",li_claim_nr)
Next
dw_afc_recieved.Show()
cb_delete_afc_recieved.Visible = TRUE
cb_new_afc_recieved.Visible = TRUE

end event

event clicked;Integer li_rowno

li_rowno = dw_afc_bol.GetClickedRow()
IF li_rowno > 0 THEN
	dw_afc_bol.SelectRow(0,FALSE)
	dw_afc_bol.SelectRow(li_rowno,TRUE)
	dw_afc.ScrollToRow(li_rowno)
	wf_afc_recieved_filter(li_rowno)
	wf_afc_add_Lump_filter(li_rowno)
END IF

end event

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

type dw_afc_recieved from datawindow within w_claims
boolean visible = false
integer x = 1582
integer y = 1584
integer width = 1440
integer height = 272
string dataobject = "dw_afc_recieved"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

on clicked;Integer li_rowno

li_rowno = dw_afc_recieved.GetClickedRow()
IF li_rowno > 0 THEN
	dw_afc_recieved.SelectRow(0,FALSE)
	dw_afc_recieved.SelectRow(li_rowno,TRUE)
	dw_afc_recieved.ScrollToRow(li_rowno)
END IF

end on

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

event itemchanged;decimal{2} ld_amount_usd, ld_amount
n_claimcurrencyadjust lnv_claimcurrencyadjust
integer li_vessel_nr
string ls_voyage_nr
integer li_chart_nr
string ls_claim_type
long ll_cerp_id
string ll_curr_code

this.accepttext()

if row > 0 then
	choose case  dwo.name
		case "afc_received_local_curr", "afc_recieved_date"
			li_vessel_nr =dw_claim_base.GetItemNumber(1,"vessel_nr")
			ls_voyage_nr = dw_claim_base.GetItemString(1,"voyage_nr")
			li_chart_nr = dw_claim_base.GetItemNumber(1,"chart_nr")
			ls_claim_type = dw_claim_base.GetItemString(1,COLUMN_CLAIM_TYPE)
			ll_cerp_id = dw_claim_base.GetItemNumber(1,COLUMN_CP_ID)
			ll_curr_code = dw_claim_base.GetItemString(1,COLUMN_CURRENCY_CODE)
			if  isnull(this.getitemdecimal(row,"afc_recieved")) or ll_curr_code = "USD" then
				ld_amount = this.getitemdecimal(row,"afc_received_local_curr")
				if lnv_claimcurrencyadjust.of_getamountusd( li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ll_curr_code, date(this.getitemdatetime(row,"afc_recieved_date")), ld_amount, ld_amount_usd) > 0 then
					this.setitem(row, "afc_recieved", ld_amount_usd)
				else
					_addmessage( this.classdefinition, "dw_claim_transaction.itemchanged()", "System error, probably because the system can not find the exchange rate for the specified date. Please try again.", "user notification of validation error")
					this.setitem(row, "afc_recieved_date", this.getitemdatetime(row, "afc_recieved_date", Primary!, true))
					return 2
				end if
			end if
	end choose
end if

end event

type dw_bulk_amounts from datawindow within w_claims
boolean visible = false
integer x = 859
integer y = 1712
integer width = 1701
integer height = 256
string dataobject = "dw_bulk_amounts"
boolean border = false
boolean livescroll = true
end type

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

type dw_dem_des_rates from uo_datawindow within w_claims
boolean visible = false
integer x = 3177
integer y = 888
integer width = 1143
integer height = 276
integer taborder = 150
boolean bringtotop = true
string dataobject = "d_sq_tb_dem_des_rates"
boolean vscrollbar = true
boolean border = false
end type

type dw_list_claims from u_datagrid within w_claims
integer x = 37
integer y = 240
integer width = 649
integer height = 2076
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_list_claims"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;integer li_test_afc, li_pc_nr, li_comm, li_locked 
decimal {2} freight_balance, ld_afc_recieved, ld_amount, ld_amount_usd, ld_amount_claim, ld_amount_claim_usd
decimal {3} ld_bol_load_quantity, ld_afc_bol_load_quantity, ld_bol_quantity, ld_daily_rate
long ll_rowno, ll_chart_no, ll_claim_no, ll_rows, ll_cp_nr, ll_businessunit
string ls_voyage_no, ls_claim_type,ls_rec, ls_curr_code
decimal {4} ld_laytime
Double ldo_cp_id_comm
s_calc_claim				lstr_parm
uo_auto_commission		uo_auto_comm
u_addr_commission			lnv_calc_adrcomm
uo_calc_dem_des_claims	uo_calc_dem
n_claimcurrencyadjust	lnv_claimcurrencyadjust
u_calc_nvo uo_calc_nvo
s_claim_base_data lstr_claim_base_data
s_dem_des_data		lstr_dem[]

ll_rows = dw_list_claims.RowCount()
if row > 0 then
	this.SelectRow(0, FALSE)
	this.SelectRow(row, TRUE)
end if

IF il_last_row > 0 AND il_last_row <= ll_rows and dw_claim_base.rowcount() > 0 THEN
	if wf_datawindow_modified(dw_list_claims.GetItemString(il_last_row,"claim_type")) = c#return.failure then
		_ib_updatefailure = true
		return
	end if
END IF

_ib_updatefailure = false

w_claims.SetRedraw(FALSE)

ll_rowno = row
IF ll_rowno > 0 THEN
	dw_list_claims.setrow(ll_rowno)
	dw_list_claims.SelectRow(0, FALSE)
	dw_list_claims.SelectRow(ll_rowno, TRUE)
	cb_l_d_amount.Hide()
	ls_voyage_no = dw_list_claims.GetItemString(ll_rowno,"voyage_nr")
	ll_chart_no = dw_list_claims.GetItemNumber(ll_rowno,"chart_nr")
	ll_claim_no = dw_list_claims.GetItemNumber(ll_rowno,"claim_nr")
	
	//Finance Profile
	if uo_global.ii_user_profile = 3 then
		SELECT LOCKED  INTO :li_locked FROM CLAIMS
		 WHERE CHART_NR   = :ll_chart_no  AND
		       VESSEL_NR  = :ii_vessel_nr AND
				 VOYAGE_NR  = :ls_voyage_no AND
				 CLAIM_NR   = :ll_claim_no;
		cb_unlock.enabled = (li_locked = 1)
	end if

	is_voyage_nr = ls_voyage_no
	il_charter_nr = ll_chart_no
	ii_claim_nr = int(ll_claim_no)
	ls_claim_type = dw_list_claims.GetItemString(ll_rowno,"claim_type")	
	
	dw_claim_base.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
	
	wf_enablemisctype()
	dw_claim_base.setcolumn("claim_responsible")
	
	ii_cerp_id = dw_claim_base.GetItemNumber(1, COLUMN_CP_ID)
	ls_curr_code = dw_claim_base.getitemstring(1, COLUMN_CURRENCY_CODE)
	
	uo_calc_nvo = CREATE u_calc_nvo
	if uo_calc_nvo.uf_cargo_base_data(ii_vessel_nr,is_voyage_nr,il_charter_nr,ii_cerp_id,lstr_claim_base_data ) then
		if ls_claim_type = "DEM" then
			if lstr_claim_base_data.set_ex_rate &
				and lstr_claim_base_data.dem_curr_code = ls_curr_code &
				and lstr_claim_base_data.dem_curr_code <> 'USD' then
				st_setexrate.visible = true
			else
				st_setexrate.visible = false
			end if
		else
			if lstr_claim_base_data.set_ex_rate &
				and lstr_claim_base_data.frt_curr_code = ls_curr_code &
				and lstr_claim_base_data.frt_curr_code <> 'USD' then
				st_setexrate.visible = true
			else
				st_setexrate.visible = false
			end if
		end if
	end if
	
	wf_claim_base_tabs(TRUE)

	if ls_claim_type = "FRT" or ls_claim_type = "AFC" then
		if ls_curr_code = "USD" then
			if ls_claim_type = "FRT" then
				dw_freight_received.settaborder("freight_received",0)
			else
				dw_afc_recieved.settaborder("afc_recieved",0)
			end if
		else
			if ls_claim_type = "FRT" then
				dw_freight_received.settaborder("freight_received",50)
			else
				dw_afc_recieved.settaborder("afc_recieved",30)
			end if
		end if
	end if
	
	IF ls_claim_type = "FRT" THEN
		
		wf_protect_receivable() // ADDED BY FR 15-08-02

		SELECT VESSEL_NR
		INTO :li_test_afc
		FROM FREIGHT_ADVANCED
		WHERE :ii_vessel_nr = VESSEL_NR AND :ls_voyage_no = VOYAGE_NR AND :ll_chart_no = CHART_NR &
				AND :ll_claim_no = CLAIM_NR AND AFC_NR = 1;
		IF SQLCA.SQLCode = 0 THEN ls_claim_type = "AFCOLD"
	
	END IF
	
	wf_get_misc_options(ls_claim_type, il_bunker_visible, il_lumpsum_visible, il_time_visible)
	wf_show_hide_dw(ls_claim_type)

	CHOOSE CASE ls_claim_type
		CASE "DEM", "DES"
			cb_refresh_claim.enabled = true
			dw_dem_des_rates.SetFilter("")
			dw_dem_des_rates.Filter( )
			dw_claim_base.SetTabOrder("claim_amount",0)
			dw_claim_base.modify("claim_amount.background.mode = '1'")
			dw_dem_des_claim.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
			
			dw_dem_des_rates.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
			
			IF dw_dem_des_claim.GetItemNumber(1,"cal_cerp_id") > 1 THEN
				ib_broker_set = TRUE
				wf_dem_des_tabs(FALSE)
				wf_dem_rate_tabs()			// allow user to add new demurrage rates CREQ # 311
				wf_claim_base_tabs(FALSE)
			ELSE
				wf_dem_des_tabs(TRUE)
				wf_claim_base_tabs(TRUE)			
			END IF
			
		   IF dw_dem_des_claim.GetItemNumber(1,"cal_cerp_id") > 1 THEN
				SELECT SUM(BOL_QUANTITY)
				INTO :ld_bol_load_quantity
				FROM BOL
				WHERE VESSEL_NR = :ii_vessel_nr
				AND VOYAGE_NR = :ls_voyage_no
				AND CHART_NR = :ll_chart_no
				AND L_D = 1;
				
			IF ld_bol_load_quantity <> dw_dem_des_claim.GetItemNumber(1,"bol_load_quantity") &
				OR IsNull(dw_dem_des_claim.GetItemNumber(1,"bol_load_quantity")) &
				OR IsNull(dw_claim_base.GetItemNumber(1,"claim_amount")) THEN
				dw_dem_des_claim.SetItem(1,"bol_load_quantity", ld_bol_load_quantity)
				
				ld_daily_rate = dw_dem_des_claim.GetItemNumber(1,"load_daily_rate")
				IF NOT IsNull(ld_daily_rate) THEN 
					ld_bol_quantity =  dw_dem_des_claim.GetItemNumber(1,"bol_load_quantity")
					IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
					ld_laytime = (ld_bol_quantity / ld_daily_rate)*24
					IF IsNull(ld_laytime) THEN
						 dw_dem_des_claim.SetItem(1,"load_laytime_allowed",0)
					ELSE
						 dw_dem_des_claim.SetItem(1,"load_laytime_allowed",ld_laytime)
					END IF
				END IF
				
				ld_daily_rate =  dw_dem_des_claim.GetItemNumber(1,"disch_daily_rate")
				IF NOT IsNull(ld_daily_rate) THEN 
					ld_bol_quantity =  dw_dem_des_claim.GetItemNumber(1,"bol_load_quantity")
					IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
					ld_laytime = (ld_bol_quantity / ld_daily_rate) * 24
					IF IsNull(ld_laytime) THEN
						 dw_dem_des_claim.SetItem(1,"disch_laytime_allowed",0)
					ELSE
					 	dw_dem_des_claim.SetItem(1,"disch_laytime_allowed",ld_laytime)
					END IF
				END IF
				
				if dw_dem_des_claim.getitemstatus(1, "load_laytime_allowed", Primary!) = DataModified! then
					if uo_calc_nvo.uf_dem_des_data(ii_vessel_nr, ls_voyage_no, ll_chart_no, ii_cerp_id, lstr_dem) = 1 then
						if lstr_dem[1].d_other_allowed > 0 then
							dw_dem_des_claim.setitem(1, "load_laytime_allowed", dw_dem_des_claim.getitemdecimal(1, "load_laytime_allowed") + lstr_dem[1].d_other_allowed)
						end if
					end if
				end if
				
				dw_dem_des_claim.Update()
				COMMIT USING SQLCA;
				
				SELECT PC_NR
					INTO :li_pc_nr
					FROM VESSELS
					WHERE VESSEL_NR = :ii_vessel_nr;
				
				uo_calc_dem = CREATE uo_calc_dem_des_claims
				IF li_pc_nr = 3 OR li_pc_nr = 5 THEN
					if dw_dem_des_claim.rowcount() < 2 then
						lstr_parm = uo_calc_dem.uf_get_bulk_amount(ii_vessel_nr, ls_voyage_no, ll_chart_no,ll_claim_no)
					else
						lstr_parm = uo_calc_dem.uf_get_bulk_amount_ports(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
					end if
				ELSE
					if dw_dem_des_claim.rowcount() < 2 then
						lstr_parm = uo_calc_dem.uf_get_tank_amount(ii_vessel_nr, ls_voyage_no, ll_chart_no,ll_claim_no)
					else
						lstr_parm = uo_calc_dem.uf_get_tank_amount_ports(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
					end if
				END IF	
				DESTROY uo_calc_dem
				
				ld_amount_claim = dw_claim_base.getitemdecimal(1, "claim_amount")
				ld_amount = lstr_parm.claim_amount
				if lstr_parm.return_code = 1 then 
				   if isnull(ld_amount_claim) then ld_amount_claim = 0
					if isnull(ld_amount) then ld_amount = 0
					if abs(ld_amount_claim - ld_amount) < 0.1 then
						dw_claim_base.SetItem(1, "claim_amount", ld_amount)					
					end if
				end if
				
				dw_claim_base.Update()
				COMMIT USING SQLCA;
				
				IF dw_claim_base.GetItemNumber(1,"claims_claim_in_log") = 1 THEN
					MessageBox("IMPORTANT WARNING","The claim amount has changed " + &
					"(bol quantity), but the claim has been transferred to CMS prior " + &
					" to this. Please adjust (NOW) manually in CMS, or if in RRIS make " + &
					"adjustment there.") 
				END IF
			END IF
		  END IF
		  
		  IF dw_dem_des_claim.GetItemNumber(1,"cal_cerp_id") > 1 THEN wf_dem_Scroll()
		 
		CASE "FRT"
			cb_refresh_claim.enabled = true
			dw_claim_base.SetTabOrder("claim_amount",0)
			dw_claim_base.modify("claim_amount.background.mode = '1'")	
			dw_freight_claim.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
			dw_add_lumpsums.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
			dw_freight_received.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)

			IF dw_freight_claim.GetItemNumber(1,"cal_cerp_id") > 1 THEN
				wf_frt_tabs(FALSE)
				wf_claim_base_tabs(FALSE)
			ELSE
				wf_frt_tabs(TRUE)
				wf_claim_base_tabs(TRUE)			
			END IF

			if uo_frt_balance.uf_get_calc_freight_type(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no) = 4 then  // Worldscale(4)
				dw_freight_claim.modify("freight_reload.visible = '1'")
				dw_freight_claim.settaborder("freight_reload", 200)
			else
				dw_freight_claim.modify("freight_reload.visible = '0'")
				dw_freight_claim.settaborder("freight_reload", 0)
			end if
			
			uo_frt_balance.uf_set_bol_quantity_reload(false, false)
			if dw_freight_claim.getitemnumber(1, "freight_reload") = 1 then
				ld_bol_load_quantity = uo_frt_balance.uf_get_max_bol_quantity_departure(ii_vessel_nr, ls_voyage_no, ll_chart_no)
			else
				ld_bol_load_quantity = uo_frt_balance.uf_get_bol_quantity(ii_vessel_nr, ls_voyage_no, ll_chart_no)
			end if
			
         if isnull(ld_bol_load_quantity) then ld_bol_load_quantity = 0
			IF ld_bol_load_quantity <> dw_freight_claim.GetItemNumber(1,"bol_load_quantity") &
				OR IsNull(dw_freight_claim.GetItemNumber(1,"bol_load_quantity")) &
				OR IsNull(dw_claim_base.GetItemNumber(1,"claim_amount")) THEN
				dw_freight_claim.SetItem(1,"bol_load_quantity", ld_bol_load_quantity)
			END IF
			
			freight_balance = uo_frt_balance.uf_calculate_balance(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)			
			ld_amount = freight_balance
			is_ori_net_freight = uo_frt_balance.st_net_freight.text
			
			ld_amount_claim = dw_claim_base.getitemdecimal(1, "claim_amount")
			if isnull(ld_amount_claim) then ld_amount_claim = 0
			if isnull(ld_amount) then ld_amount = 0
			if abs(ld_amount_claim - ld_amount) > 0.1 then
				ib_claim_amount_changed = true
				dw_claim_base.SetItem(1, "claim_amount", ld_amount)					
			end if
			
			lnv_claimcurrencyadjust.of_getclaimamounts(ii_vessel_nr, is_voyage_nr, ll_chart_no, ll_claim_no , ld_amount, ld_amount_usd, false)
			
			ld_amount_claim_usd = dw_claim_base.getitemdecimal(1, "claim_amount_usd")
			if isnull(ld_amount_claim_usd) then ld_amount_claim_usd = 0 
			if isnull(ld_amount_usd) then ld_amount_usd = 0
			if abs(ld_amount_claim_usd - ld_amount_usd) > 0.1 then
				ib_claim_amount_usd_changed = true
				dw_claim_base.SetItem(1, "claim_amount_usd", ld_amount_usd)
			end if
			
			if dw_claim_base.Update() = 1 and dw_freight_claim.update() = 1 then
				COMMIT;
			else
				ROLLBACK;
			end if
			
			if ib_claim_amount_changed then
				ib_claim_amount_changed = false
			   uo_auto_comm.of_generate(ii_vessel_nr, is_voyage_nr, ll_chart_no, ll_claim_no, "FRT", "NEW", ldo_cp_id_comm)
			else
				if ib_claim_amount_usd_changed then
					ib_claim_amount_usd_changed = false
					uo_auto_comm.of_generate(ii_vessel_nr, is_voyage_nr, ll_chart_no, ll_claim_no, "FRT", "NEW", ldo_cp_id_comm, true)
				end if
			end if
			
			lnv_calc_adrcomm = create u_addr_commission
			lnv_calc_adrcomm.of_setcurrcode(dw_claim_base.GetItemString(1,"curr_code"))
			if lnv_calc_adrcomm.of_add_com(ii_vessel_nr, is_voyage_nr, ll_chart_no, ll_claim_no) = -1 then
				rollback;
			else
				commit;
			end if
			destroy lnv_calc_adrcomm
	
		CASE "AFCOLD"			
			cb_refresh_claim.enabled = false
			w_claims.SetRedraw(TRUE)
			dw_claim_base.SetTabOrder("claim_amount",0)
			dw_claim_base.modify("claim_amount.background.mode = '1'")
			dw_afc.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
			
			dw_add_lumpsums_afc.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no,1)
			ibl_new = false
			
			dw_afc_recieved.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no,1, ll_claim_no)
			
			ll_cp_nr = dw_afc.GetItemNumber(1,"freight_advanced_cal_cerp_id")
			IF ll_cp_nr > 1 THEN
 				wf_afc_tabs(FALSE)
				wf_claim_base_tabs(FALSE)
			ELSE
				wf_afc_tabs(TRUE)
				wf_claim_base_tabs(TRUE)			
			END IF

			SELECT SUM(AFC_RECIEVED)
			INTO :ld_afc_recieved
			FROM FREIGHT_ADVANCED_RECIEVED
			WHERE VESSEL_NR = :ii_vessel_nr
			AND VOYAGE_NR = :ls_voyage_no
			AND CHART_NR = :ll_chart_no
                        AND CLAIM_NR = :ll_claim_no;

			IF ld_afc_recieved > 0 THEN
				ls_rec = "sum_recieved.text = " + "'" + String(ld_afc_recieved) + "'" 
				dw_afc.Modify(ls_rec)
			ELSE 
				dw_afc.Modify( "sum_recieved.text = '0'")
			END IF

			SELECT SUM(BOL_QUANTITY)
				INTO :ld_bol_load_quantity
				FROM BOL
				WHERE VESSEL_NR = :ii_vessel_nr
				AND VOYAGE_NR = :ls_voyage_no
				AND CHART_NR = :ll_chart_no
				AND CAL_CERP_ID = :ll_cp_nr
				AND L_D = 1;

			SELECT SUM(AFC_BOL_QUANTITY)
				INTO :ld_afc_bol_load_quantity
				FROM FREIGHT_ADVANCED
				WHERE VESSEL_NR = :ii_vessel_nr
				AND VOYAGE_NR = :ls_voyage_no
				AND CHART_NR = :ll_chart_no
				AND CAL_CERP_ID = :ll_cp_nr;

			IF ld_bol_load_quantity <> ld_afc_bol_load_quantity &
				OR IsNull(dw_claim_base.GetItemNumber(1,"claim_amount")) THEN
				MessageBox("Quantity difference","Bol load Quantity from BOL does not match Bol quantity from AFC !")
				IF ll_cp_nr = 1 THEN
					wf_afc_new_bol(ii_vessel_nr,ls_voyage_no,ll_chart_no)		
				ELSE
					MessageBox(" ","The AFC is created via a calcule, so if you want to get the ~r~n updated data &
								     for this claim, you have to first delete it, ~r~n and then recreate it.") 
				END IF
			END IF
			freight_balance = uo_afc.uf_calculate_balance(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no,1)		
			w_claims.SetRedraw(FALSE)
			
		CASE ELSE
			cb_refresh_claim.enabled = false
			
			if il_lumpsum_visible = 1 and not ( il_bunker_visible = 1 or il_time_visible = 1 ) then
				dw_claim_base.SetTabOrder("claim_amount", 900)
				dw_claim_base.modify("claim_amount.background.mode = '0'")
				dw_claim_base.modify("claim_amount.background.color = '" + string(c#color.MT_MAERSK) + "'")
			else
				dw_claim_base.SetTabOrder("claim_amount", 0)
				dw_claim_base.modify("claim_amount.background.mode = '1'")
			end if
			
			dw_hea_dev_claim.Retrieve(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)
			
			wf_filtermisctype()
	END CHOOSE
	
	uo_att_actions.enabled = true
	uo_att_actions.of_init(is_voyage_nr, long(ii_vessel_nr), long(ii_claim_nr), il_charter_nr)
	uo_balance.of_claimbalance(ii_vessel_nr, ls_voyage_no, ll_chart_no, ll_claim_no)	
	il_last_row = ll_rowno	
	
	// CR2949
	dw_claim_base.modify("claim_percentage.protect = '1'")
	dw_claim_base.modify("claim_percentage.background.color='15527148'")
	if dw_claim_base.getitemdecimal(1, "claim_amount")  < 0 and dw_claim_base.getitemstring(1, "claim_type") = "DEM" then
		SELECT BU_ID INTO :ll_businessunit FROM USERS WHERE USERID = :uo_global.is_userid;
		if isnull(ll_businessunit) then ll_businessunit = 0
		//users and Demurrage /superusers/administrators
		if (uo_global.ii_access_level = 1 and ll_businessunit = 11) or uo_global.ii_access_level = 2 or uo_global.ii_access_level = 3 then
			dw_claim_base.modify("claim_percentage.protect = '0'")
			dw_claim_base.modify("claim_percentage.background.color='"+string(rgb(255,255,255))+"'")
		end if
	end if
	
	_lockcurrcode()
END IF

w_claims.SetRedraw(TRUE)


end event

event getfocus;call super::getfocus;if rowcount() > 0 then
	cb_delete.enabled = true
	cb_update.enabled = true
end if
end event

type cb_scroll_next from commandbutton within w_claims
boolean visible = false
integer x = 2848
integer y = 1308
integer width = 73
integer height = 80
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;Integer li_rows

IF Not st_afc_count.Text = String(dw_afc.RowCount()) THEN
	dw_afc.ScrollNextRow()
	 li_rows =  Integer(st_afc_count.Text)
	 li_rows ++
	st_afc_count.Text = String(li_rows)
END IF

wf_afc_Scroll()
end event

type dw_freight_received from uo_datawindow within w_claims
boolean visible = false
integer x = 864
integer y = 1684
integer width = 2158
integer height = 272
integer taborder = 0
string dataobject = "dw_freight_received"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;decimal {2} ld_amount_usd, ld_amount
n_claimcurrencyadjust lnv_claimcurrencyadjust
integer li_vessel_nr
string ls_voyage_nr
integer li_chart_nr
string ls_claim_type
long ll_cerp_id
string ll_curr_code

this.accepttext()

if row > 0 then
	choose case  dwo.name
		case "freight_received_local_curr", "freight_rec_date"
			li_vessel_nr =dw_claim_base.GetItemNumber(1,"vessel_nr")
			ls_voyage_nr = dw_claim_base.GetItemString(1,"voyage_nr")
			li_chart_nr = dw_claim_base.GetItemNumber(1,"chart_nr")
			ls_claim_type = dw_claim_base.GetItemString(1,COLUMN_CLAIM_TYPE)
			ll_cerp_id = dw_claim_base.GetItemNumber(1,COLUMN_CP_ID)
			ll_curr_code = dw_claim_base.GetItemString(1,COLUMN_CURRENCY_CODE)
			if  isnull(this.getitemdecimal(row,"freight_received")) or ll_curr_code = "USD" then
				ld_amount = this.getitemdecimal(row,"freight_received_local_curr")
				if lnv_claimcurrencyadjust.of_getamountusd( li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ll_curr_code, date(this.getitemdatetime(row,"freight_rec_date")), ld_amount, ld_amount_usd) > 0 then
					this.setitem(row, "freight_received", ld_amount_usd)
				else
					_addmessage( this.classdefinition, "dw_claim_transaction.itemchanged()", "System error, probably because the system can not find the exchange rate for the specified date. Please try again.", "user notification of validation error")
					this.setitem(row, "freight_rec_date", this.getitemdatetime(row, "freight_rec_date", Primary!, true))
					return 2
				end if
			end if
	end choose
end if

end event

type p_dot from picture within w_claims
boolean visible = false
integer x = 3314
integer y = 880
integer width = 41
integer height = 36
boolean bringtotop = true
boolean originalsize = true
string picturename = "images\dot.bmp"
boolean focusrectangle = false
end type

type cb_office from commandbutton within w_claims
boolean visible = false
integer x = 1403
integer y = 744
integer width = 82
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "?"
end type

event clicked;string ls_office_sn

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ls_office_sn = f_select_from_list("dw_office_active_list",2,"Shortname",3,"Fullname",2,"Select office",false)
IF NOT IsNull(ls_office_sn) and ls_office_sn <> "" THEN
	dw_claim_base.SetColumn("offices_office_sn")
	dw_claim_base.SetText(ls_office_sn)
	dw_claim_base.AcceptText()
	dw_claim_base.SetFocus()
END IF



end event

type dw_freight_claim from uo_datawindow within w_claims
boolean visible = false
integer x = 2203
integer y = 272
integer width = 1225
integer height = 496
integer taborder = 100
string dataobject = "d_sq_ff_freight_claim"
boolean border = false
end type

event itemchanged;call super::itemchanged;long ll_vessel_nr, ll_chart_nr, ll_claims_nr, ll_freight_reload
string ls_voyage_nr
decimal{3} ld_bol_quantity
       
if row <= 0 then return
if dwo.name = 'freight_reload' then
	ll_freight_reload = long(data)
	ll_vessel_nr = this.getitemnumber(row, "vessel_nr")
	ls_voyage_nr = this.getitemstring(row, "voyage_nr")
	ll_chart_nr  = this.getitemnumber(row, "chart_nr")
	ll_claims_nr = this.getitemnumber(row, "claim_nr")
	if ll_freight_reload = 1 then
		uo_frt_balance.uf_set_bol_quantity_reload(true, true)
		ld_bol_quantity = uo_frt_balance.uf_get_max_bol_quantity_departure(ll_vessel_nr, ls_voyage_nr, ll_chart_nr)
	else
		uo_frt_balance.uf_set_bol_quantity_reload(true, false)
		ld_bol_quantity = uo_frt_balance.uf_get_bol_quantity(ll_vessel_nr, ls_voyage_nr, ll_chart_nr)
	end if
	if isnull(ld_bol_quantity) then ld_bol_quantity = 0
	this.setitem(row, "bol_load_quantity", ld_bol_quantity)
	if ll_claims_nr > 0 then
		uo_frt_balance.uf_calculate_balance(ll_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claims_nr)
	end if
end if
end event

type dw_dem_des_claim from uo_datawindow within w_claims
boolean visible = false
integer x = 2203
integer y = 272
integer width = 2112
integer height = 508
integer taborder = 60
string dataobject = "d_sq_ff_dem_des_claim"
boolean border = false
end type

on retrieveend;call uo_datawindow::retrieveend;Integer li_rows, li_pc_nr

li_rows  = dw_dem_des_claim.RowCount()
st_dem_count.Text = String(1)
st_dem_total.Text = "of " +  String(li_rows)
IF li_rows > 1 THEN
	ib_set_dem_part_amount = TRUE
	IF dw_dem_des_claim.GetItemNumber(dw_dem_des_claim.GetRow(),"dem_des_settled") = 1 THEN
		wf_part_amount(1)
	END IF
ELSE
	SELECT PC_NR
	INTO :li_pc_nr
	FROM VESSELS
	WHERE VESSEL_NR = :ii_vessel_nr
	USING SQLCA;
	COMMIT USING SQLCA;
	IF li_pc_nr = 3 Or li_pc_nr = 5 THEN
		cb_l_d_amount.Show()
	END IF
END IF
end on

event itemchanged;call super::itemchanged;decimal {3} ld_bol_quantity, ld_daily_rate, ld_hourly_rate
decimal {4} ld_laytime, ld_day

AcceptText()
CHOOSE CASE dwo.name
	CASE "load_hourly_rate"
		 ld_hourly_rate = GetItemNumber(1,"load_hourly_rate")
		 IF NOT IsNull(ld_hourly_rate) THEN 
			ld_day = 	 ld_hourly_rate * 24		
			IF IsNull(ld_day) THEN
				SetItem(1,"load_daily_rate",0)
			ELSE
				SetItem(1,"load_daily_rate",ld_day)
			END IF			
		END IF
		ld_daily_rate = GetItemNumber(1,"load_daily_rate")
		IF NOT IsNull(ld_daily_rate) THEN 
			ld_bol_quantity = GetItemNumber(1,"bol_load_quantity")
			IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
			
			ld_laytime = (ld_bol_quantity / ld_daily_rate)*24
			
			IF IsNull(ld_laytime) THEN
				SetItem(1,"load_laytime_allowed",0)
			ELSE
				SetItem(1,"load_laytime_allowed",ld_laytime)
			END IF
		END IF
	CASE "disch_hourly_rate"
		 ld_hourly_rate = GetItemNumber(1,"disch_hourly_rate")
		 IF NOT IsNull(ld_hourly_rate) THEN 
			ld_day = 	 ld_hourly_rate * 24		
			IF IsNull(ld_day) THEN
				SetItem(1,"disch_daily_rate",0)
			ELSE
				SetItem(1,"disch_daily_rate",ld_day)
			END IF			
		END IF
		ld_daily_rate = GetItemNumber(1,"disch_daily_rate")
		IF NOT IsNull(ld_daily_rate) THEN 
			ld_bol_quantity = GetItemNumber(1,"bol_load_quantity")
			IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
			
			ld_laytime = (ld_bol_quantity / ld_daily_rate)*24
			
			IF IsNull(ld_laytime) THEN
				SetItem(1,"disch_laytime_allowed",0)
			ELSE
				SetItem(1,"disch_laytime_allowed",ld_laytime)
			END IF
		ELSE
			SetNull(ld_laytime)
			SetItem(1,"disch_laytime_allowed",ld_laytime)
		END IF	
//	CASE "port_code"
//	CASE "dem_des_purpose"
				
END CHOOSE


CHOOSE CASE GetColumnName()
	CASE "load_daily_rate"
		ld_daily_rate = GetItemNumber(1,"load_daily_rate")
		IF NOT IsNull(ld_daily_rate) THEN 
			ld_bol_quantity = GetItemNumber(1,"bol_load_quantity")
			IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
			
			ld_laytime = (ld_bol_quantity / ld_daily_rate)*24
			
			IF IsNull(ld_laytime) THEN
				SetItem(1,"load_laytime_allowed",0)
			ELSE
				SetItem(1,"load_laytime_allowed",ld_laytime)
			END IF
		END IF

		 IF NOT IsNull(ld_daily_rate) THEN 
			ld_day = 	 ld_daily_rate / 24		
			IF IsNull(ld_day) THEN
				SetItem(1,"load_hourly_rate",0)
			ELSE
				SetItem(1,"load_hourly_rate",ld_day)
			END IF			
		END IF

	CASE "disch_daily_rate"
		ld_daily_rate = GetItemNumber(1,"disch_daily_rate")
		IF NOT IsNull(ld_daily_rate) THEN 
			ld_bol_quantity = GetItemNumber(1,"bol_load_quantity")
			IF IsNull(ld_bol_quantity) THEN ld_bol_quantity = 0
			
			ld_laytime = (ld_bol_quantity / ld_daily_rate)*24
			
			IF IsNull(ld_laytime) THEN
				SetItem(1,"disch_laytime_allowed",0)
			ELSE
				SetItem(1,"disch_laytime_allowed",ld_laytime)
			END IF
		ELSE
			SetNull(ld_laytime)
			SetItem(1,"disch_laytime_allowed",ld_laytime)
		END IF	
		 IF NOT IsNull(ld_daily_rate) THEN 
			ld_day = 	 ld_daily_rate / 24		
			IF IsNull(ld_day) THEN
				SetItem(1,"disch_hourly_rate",0)
			ELSE
				SetItem(1,"disch_hourly_rate",ld_day)
			END IF			
		END IF		
END CHOOSE


end event

type dw_afc from datawindow within w_claims
event ue_sum_recieved pbm_custom20
boolean visible = false
integer x = 2203
integer y = 272
integer width = 1225
integer height = 1116
integer taborder = 110
string dataobject = "d_sq_ff_afc"
boolean border = false
boolean livescroll = true
end type

on retrieveend;Integer li_rows
li_rows  = dw_afc.RowCount()
st_afc_count.Text = String(1)
st_afc_total.Text = "of " +  String(li_rows)
end on

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

type uo_frt_balance from uo_freight_balance within w_claims
boolean visible = false
integer x = 3538
integer y = 272
integer width = 777
integer height = 620
boolean border = false
end type

on uo_frt_balance.destroy
call uo_freight_balance::destroy
end on

type gb_freight_balance from mt_u_groupbox within w_claims
boolean visible = false
integer x = 3502
integer y = 224
integer width = 850
integer height = 728
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = ""
end type

type uo_afc from uo_afc_freight_balance within w_claims
boolean visible = false
integer x = 3538
integer y = 272
integer width = 777
integer height = 620
integer taborder = 340
boolean border = false
end type

on uo_afc.destroy
call uo_afc_freight_balance::destroy
end on

type gb_dem_claim from mt_u_groupbox within w_claims
boolean visible = false
integer x = 2167
integer y = 224
integer width = 2185
integer height = 604
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = ""
end type

type dw_hea_dev_claim from uo_datawindow within w_claims
boolean visible = false
integer x = 2203
integer y = 288
integer width = 1344
integer height = 528
integer taborder = 140
string dataobject = "d_sq_ff_hea_dev_claim"
boolean border = false
end type

event itemchanged;call super::itemchanged;wf_filtermisctype()
end event

event losefocus;call super::losefocus;of_set_column()
end event

event itemerror;call super::itemerror;return 3
end event

type gb_freight_claim from mt_u_groupbox within w_claims
boolean visible = false
integer x = 2167
integer y = 224
integer width = 1298
integer height = 1212
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = ""
end type

type gb_dev_claim from mt_u_groupbox within w_claims
boolean visible = false
integer x = 2167
integer y = 224
integer width = 1417
integer height = 620
integer weight = 400
string facename = "Tahoma"
long backcolor = 553648127
string text = "Breakdown"
end type

type uo_att_actions from u_fileattach within w_claims
event destroy ( )
integer x = 727
integer y = 1616
integer width = 3639
integer height = 788
integer taborder = 270
boolean enabled = false
string is_dataobjectname = "d_sq_tb_claim_action_files"
string is_counterlabel = "Actions:"
boolean ib_allow_dragdrop = true
integer ii_buttonmode = 0
boolean ib_enable_cancel_button = false
boolean ib_allownonattachrecs = true
end type

on uo_att_actions.destroy
call u_fileattach::destroy
end on

event ue_childmodified;call super::ue_childmodified;cb_update_action.default=true
end event

event ue_childclicked;call super::ue_childclicked;long ll_row, ll_data
datetime ldt_dummy

setnull(ldt_dummy)

if row > 0 then
//	if dw_file_listing.getitemstatus(row,0,PRIMARY!) = New! OR  dw_file_listing.getitemstatus(row,0,PRIMARY!) = NewModified! then
//		cb_delete_action.Enabled = false
//	else
//		cb_delete_action.Enabled = true
//	end if
	
	if dwo.name = "c_action_finished" then
//		cb_update_action.enabled = true
//		cb_cancel_action.enabled = true
		
		if  dw_file_listing.getitemnumber(row,"c_action_finished") = 0 or isnull(dw_file_listing.getitemnumber(row,"c_action_finished")) then
			dw_file_listing.setitem(row,"finished_date",today() )
			dw_file_listing.setitem(row,"finished_by",uo_global.is_userid)
		else
			dw_file_listing.setitem(row,"finished_date",ldt_dummy )
			dw_file_listing.setitem(row,"finished_by","")
		end if
	end if	

//	if dwo.name = "assigned_to"  then
//		cb_cancel_action.enabled = true
//	end if
	
end if
end event

event ue_dropfiles;call super::ue_dropfiles;long ll_row, ll_rows

//cb_cancel_action.enabled = true
//cb_delete_action.enabled = false
//cb_update_action.enabled = true
//cb_update_action.default = true
/* update escential columns if a new record */

/* update escential columns if a new record */
ll_row = uo_att_actions.dw_file_listing.getrow()
ll_rows = dw_file_listing.rowcount()



if ll_rows > 0 then
	for ll_row = ll_rows to 1 step -1
		if isnull(uo_att_actions.dw_file_listing.getitemdatetime(ll_row,"c_action_date")) then	
			uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_date", today())
		end if
		dw_file_listing.SetColumn("description")
	next
	dw_file_listing.setfocus( )
end if

end event

event ue_dropmails;call super::ue_dropmails;long ll_row
	// TODO: place in function
//cb_cancel_action.enabled = true
//cb_delete_action.enabled = false
//cb_update_action.enabled = true
//cb_update_action.default = true
/* update escential columns if a new record */

/* validate if new unsaved claim */
	ll_row = uo_att_actions.dw_file_listing.getrow()
	if ll_row<>0 then
		if isnull(uo_att_actions.dw_file_listing.getitemnumber(ll_row,"file_id")) then
			uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_date", today())
		end if
		dw_file_listing.SetColumn("description")
		dw_file_listing.setfocus( )
	end if

end event

type st_setexrate from statictext within w_claims
boolean visible = false
integer x = 727
integer y = 2400
integer width = 841
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
string text = "Ex rate to USD is set in the calculation"
boolean focusrectangle = false
end type

