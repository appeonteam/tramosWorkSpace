$PBExportHeader$w_port_of_call_bak.srw
$PBExportComments$Allows opertor to create, delete and modify ports of call.
forward
global type w_port_of_call_bak from w_vessel_basewindow
end type
type gb_nextopenposition from groupbox within w_port_of_call_bak
end type
type gb_2 from groupbox within w_port_of_call_bak
end type
type gb_4 from groupbox within w_port_of_call_bak
end type
type dw_proc_pcnc from u_datagrid within w_port_of_call_bak
end type
type cb_close from commandbutton within w_port_of_call_bak
end type
type cb_poc_list from commandbutton within w_port_of_call_bak
end type
type cb_refresh from commandbutton within w_port_of_call_bak
end type
type rb_all_voyages from radiobutton within w_port_of_call_bak
end type
type rb_only_this_year from radiobutton within w_port_of_call_bak
end type
type gb_1 from groupbox within w_port_of_call_bak
end type
type st_rows from statictext within w_port_of_call_bak
end type
type cb_finished from commandbutton within w_port_of_call_bak
end type
type tab_poc from tab within w_port_of_call_bak
end type
type tabpage_act from userobject within tab_poc
end type
type cb_dep_bunker from mt_u_commandbutton within tabpage_act
end type
type cb_change_tc from mt_u_commandbutton within tabpage_act
end type
type cb_newact from mt_u_commandbutton within tabpage_act
end type
type cb_updateact from mt_u_commandbutton within tabpage_act
end type
type cb_deleteactual from mt_u_commandbutton within tabpage_act
end type
type cb_cancel_actual from mt_u_commandbutton within tabpage_act
end type
type dw_port_of_call from mt_u_datawindow within tabpage_act
end type
type tabpage_act from userobject within tab_poc
cb_dep_bunker cb_dep_bunker
cb_change_tc cb_change_tc
cb_newact cb_newact
cb_updateact cb_updateact
cb_deleteactual cb_deleteactual
cb_cancel_actual cb_cancel_actual
dw_port_of_call dw_port_of_call
end type
type tabpage_est from userobject within tab_poc
end type
type cb_move_est_act from mt_u_commandbutton within tabpage_est
end type
type cb_newest from mt_u_commandbutton within tabpage_est
end type
type cb_updateest from mt_u_commandbutton within tabpage_est
end type
type cb_deleteest from mt_u_commandbutton within tabpage_est
end type
type cb_cancel_est from mt_u_commandbutton within tabpage_est
end type
type dw_port_of_call_est from mt_u_datawindow within tabpage_est
end type
type tabpage_est from userobject within tab_poc
cb_move_est_act cb_move_est_act
cb_newest cb_newest
cb_updateest cb_updateest
cb_deleteest cb_deleteest
cb_cancel_est cb_cancel_est
dw_port_of_call_est dw_port_of_call_est
end type
type tabpage_voy_text from userobject within tab_poc
end type
type dw_laycan_cp from mt_u_datawindow within tabpage_voy_text
end type
type cb_cancel_voyage_text from mt_u_commandbutton within tabpage_voy_text
end type
type cb_update_voyage_text from mt_u_commandbutton within tabpage_voy_text
end type
type dw_voyage_text from mt_u_datawindow within tabpage_voy_text
end type
type tabpage_voy_text from userobject within tab_poc
dw_laycan_cp dw_laycan_cp
cb_cancel_voyage_text cb_cancel_voyage_text
cb_update_voyage_text cb_update_voyage_text
dw_voyage_text dw_voyage_text
end type
type tabpage_att from userobject within tab_poc
end type
type uo_att from u_fileattach within tabpage_att
end type
type tabpage_att from userobject within tab_poc
uo_att uo_att
end type
type tabpage_vessel_text from userobject within tab_poc
end type
type uo_vesseldetail_att from u_fileattach within tabpage_vessel_text
end type
type cb_update_vessel_text from mt_u_commandbutton within tabpage_vessel_text
end type
type cb_cancel_vessel_text from mt_u_commandbutton within tabpage_vessel_text
end type
type dw_vessel_text from mt_u_datawindow within tabpage_vessel_text
end type
type gb_vesseldetail_att from groupbox within tabpage_vessel_text
end type
type tabpage_vessel_text from userobject within tab_poc
uo_vesseldetail_att uo_vesseldetail_att
cb_update_vessel_text cb_update_vessel_text
cb_cancel_vessel_text cb_cancel_vessel_text
dw_vessel_text dw_vessel_text
gb_vesseldetail_att gb_vesseldetail_att
end type
type tabpage_port_details from userobject within tab_poc
end type
type cb_cancel_port_details from mt_u_commandbutton within tabpage_port_details
end type
type cb_update_port_details from mt_u_commandbutton within tabpage_port_details
end type
type dw_port_details from mt_u_datawindow within tabpage_port_details
end type
type uo_port_att from u_fileattach within tabpage_port_details
end type
type gb_port_att from groupbox within tabpage_port_details
end type
type tabpage_port_details from userobject within tab_poc
cb_cancel_port_details cb_cancel_port_details
cb_update_port_details cb_update_port_details
dw_port_details dw_port_details
uo_port_att uo_port_att
gb_port_att gb_port_att
end type
type tabpage_owners_matters from userobject within tab_poc
end type
type dw_department_info from mt_u_datawindow within tabpage_owners_matters
end type
type st_contacts from statictext within tabpage_owners_matters
end type
type dw_department_list from mt_u_datawindow within tabpage_owners_matters
end type
type cb_cancel from commandbutton within tabpage_owners_matters
end type
type cb_print from commandbutton within tabpage_owners_matters
end type
type cb_update from commandbutton within tabpage_owners_matters
end type
type uo_attach from u_fileattach within tabpage_owners_matters
end type
type dw_print from datawindow within tabpage_owners_matters
end type
type gb_activites from groupbox within tabpage_owners_matters
end type
type tabpage_owners_matters from userobject within tab_poc
dw_department_info dw_department_info
st_contacts st_contacts
dw_department_list dw_department_list
cb_cancel cb_cancel
cb_print cb_print
cb_update cb_update
uo_attach uo_attach
dw_print dw_print
gb_activites gb_activites
end type
type tabpage_bunker_stock from userobject within tab_poc
end type
type cb_cancel_vessel_bunker_stock from mt_u_commandbutton within tabpage_bunker_stock
end type
type cb_update_vessel_bunker_stock from mt_u_commandbutton within tabpage_bunker_stock
end type
type dw_vessel_bunker_stock from mt_u_datawindow within tabpage_bunker_stock
end type
type tabpage_bunker_stock from userobject within tab_poc
cb_cancel_vessel_bunker_stock cb_cancel_vessel_bunker_stock
cb_update_vessel_bunker_stock cb_update_vessel_bunker_stock
dw_vessel_bunker_stock dw_vessel_bunker_stock
end type
type tab_poc from tab within w_port_of_call_bak
tabpage_act tabpage_act
tabpage_est tabpage_est
tabpage_voy_text tabpage_voy_text
tabpage_att tabpage_att
tabpage_vessel_text tabpage_vessel_text
tabpage_port_details tabpage_port_details
tabpage_owners_matters tabpage_owners_matters
tabpage_bunker_stock tabpage_bunker_stock
end type
type dw_vessel_next_open from mt_u_datawindow within w_port_of_call_bak
end type
type dw_voyage_next_open from mt_u_datawindow within w_port_of_call_bak
end type
type shl_bunker from statichyperlink within w_port_of_call_bak
end type
type st_responsible from statictext within w_port_of_call_bak
end type
type shl_1 from statichyperlink within w_port_of_call_bak
end type
type dw_task_list from mt_u_datawindow within w_port_of_call_bak
end type
type gb_5 from groupbox within w_port_of_call_bak
end type
type st_topbar_background from u_topbar_background within w_port_of_call_bak
end type
type rb_1 from radiobutton within w_port_of_call_bak
end type
type rb_2 from radiobutton within w_port_of_call_bak
end type
type st_date from statictext within w_port_of_call_bak
end type
type st_portarea from statictext within w_port_of_call_bak
end type
type dw_bol_in_poc from u_popupdw within w_port_of_call_bak
end type
type st_warning from statictext within w_port_of_call_bak
end type
type shl_ecovoy from statichyperlink within w_port_of_call_bak
end type
type dw_voyage_alert from u_popupdw within w_port_of_call_bak
end type
type ids_auto_est from mt_n_datastore within w_port_of_call_bak
end type
type ids_auto_act from mt_n_datastore within w_port_of_call_bak
end type
end forward

global type w_port_of_call_bak from w_vessel_basewindow
integer x = 471
integer y = 48
integer width = 4626
integer height = 2592
string title = "Port of Call"
boolean maxbox = false
long backcolor = 67108864
string icon = "images\POC.ICO"
boolean ib_setdefaultbackgroundcolor = true
gb_nextopenposition gb_nextopenposition
gb_2 gb_2
gb_4 gb_4
dw_proc_pcnc dw_proc_pcnc
cb_close cb_close
cb_poc_list cb_poc_list
cb_refresh cb_refresh
rb_all_voyages rb_all_voyages
rb_only_this_year rb_only_this_year
gb_1 gb_1
st_rows st_rows
cb_finished cb_finished
tab_poc tab_poc
dw_vessel_next_open dw_vessel_next_open
dw_voyage_next_open dw_voyage_next_open
shl_bunker shl_bunker
st_responsible st_responsible
shl_1 shl_1
dw_task_list dw_task_list
gb_5 gb_5
st_topbar_background st_topbar_background
rb_1 rb_1
rb_2 rb_2
st_date st_date
st_portarea st_portarea
dw_bol_in_poc dw_bol_in_poc
st_warning st_warning
shl_ecovoy shl_ecovoy
dw_voyage_alert dw_voyage_alert
ids_auto_est ids_auto_est
ids_auto_act ids_auto_act
end type
global w_port_of_call_bak w_port_of_call_bak

type prototypes
FUNCTION long ShellExecute (uint  ihwnd,string  lpszOp,string lpszFile,string  lpszParams, string  lpszDir,int  wShowCmd ) LIBRARY "Shell32.dll" ALIAS FOR "ShellExecuteA;ansi" 


end prototypes

type variables

CONSTANT string	is_FinishVoyage = "&Finish Voyage"
CONSTANT string	is_ActivateVoyage = "&Activate Voy."

integer	ii_pcnr		//managed by parent window

boolean 	ib_flagupdate 		//cancel button
boolean 	ib_refreshproceedinglist //indicates if Proceeding list needs to be refreshed
boolean	ib_readonlyaccess

string		is_previous_voyage

//CR2410 begin added by WWG004 on 15/05/2011.
long		il_modifiedrow
long		il_vessel_nr
//CR2410 end added.

//CR2408 Added by LGX001 on 02/06/2011.
mt_n_dddw_searchasyoutype inv_dddw_search

//CR2410 Begin added by ZSW001 on 15/07/2011
boolean	ib_doschedule		//true: enabled auto schedule and click yes button; false: disabled auto schedule or click no button;

CONSTANT integer ii_ACTUAL    = 1
CONSTANT integer ii_ESTIMATED = 2
//CR2410 End added by ZSW001 on 15/07/2011

//CR2319 (D3-2)  Added by LGX001 on 09/10/2011.  
boolean	ib_allowchangemenu = true

//CR2535 & 2536 Modified by ZSW001 on 21/10/2011
n_autoschedule		inv_autoschedule

boolean	ib_allowclose = true

boolean ib_new = false

string	is_rb = "Onlythisyear"

end variables

forward prototypes
public function boolean wf_port_code_ok (string as_purpose, long al_vessel_nr, string as_voyage_nr, string as_port_code)
public function integer wf_data_modified ()
public function string wf_replace_special_char (string as_string)
public subroutine wf_checktccontract ()
public function integer wf_connecttccontract (ref datawindow adw_poc)
public subroutine wf_check_bunker_tcout_delivery ()
public subroutine wf_check_bunker_tcout_redelivery ()
public subroutine documentation ()
private subroutine _set_permissions ()
private subroutine _set_interface (integer ai_est, integer ai_act)
public subroutine wf_initialize_tasklist (long al_vesselnr, string as_voyagenr)
public subroutine wf_refresh_task_list (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn, integer ai_estimated)
private subroutine wf_select_task_node (string as_portcode, integer al_pcn)
private function integer _send_finished_voyage_alert ()
private function integer _checkdatesbetweenports (long al_vessel_nr)
private function boolean _checkestpocbefore ()
public function integer wf_validate (integer ai_type)
public subroutine wf_goto_est_cargo (integer ai_poc_type)
private function integer __setstps_display (long al_row)
private function integer _generateestimates (integer ai_vesselnr, string as_voyagenr)
private function integer _checkpreviousvoyage (long al_vesselnr, string as_voyagenr, long al_voyage_type)
public subroutine wf_set_ownermatter (string as_voyagenr, string as_portcode, integer ai_pcn)
public subroutine wf_init_departments (long al_ownid)
public subroutine wf_insert_portdetailhistory (datastore ds_port_detail_history, string as_new, string as_old, string as_port_code, datetime adt_today, string as_type)
public function boolean wf_is_first_poc (integer ai_vessel_nr, datetime adt_arrival, string as_voyage)
public function integer wf_check_portbunker (ref mt_u_datawindow adw_poc, string as_bunker_type, decimal ad_arr_bunker, decimal ad_dept_bunker, string as_pre_voyage, string as_pre_port, string as_next_voyage, string as_next_port, ref string as_setcol, ref string as_message)
public function integer wf_check_portbunker (ref mt_u_datawindow adw_poc, ref string as_setcol, ref string as_message)
public subroutine wf_calculate_tce (integer ai_type)
public function boolean wf_check_bunker (integer ai_vessel_nr, string as_voyage_nr, ref string as_message)
public subroutine wf_insert_vesseldetailhistory (datastore ds_vessel_detail_history, string as_new, string as_old, long ad_vessel_nr, datetime adt_today, string as_type)
public subroutine wf_check_laytime (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn)
public function integer wf_update_timebar (long al_vessel_nr, string as_voyage_nr)
public subroutine wf_set_voyage_alert_status (string as_act_est, long al_row)
public subroutine wf_show_voyage_alert (long al_row)
public function integer wf_interim_jump_new_dev (long al_vessel_nr, string as_voyage_nr)
public function integer wf_check_firstlast_interim (string as_voyage_nr)
end prototypes

public function boolean wf_port_code_ok (string as_purpose, long al_vessel_nr, string as_voyage_nr, string as_port_code);
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_port_of_call
  
 Object     : window function
  
 Function	 : wf_port_code_ok

 Scope     : local

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 29-11-96

 Description : This function returns true or false if a port is defined on
			the caslculation in the same manner asked in the function 
			argument.

 Arguments : purpose,vessel_nr,voyage_nr,port_code

 Returns   : True if purpose is correct
				False if not

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE			VERSION 	NAME			DESCRIPTION
-------- 		------- 		----- 			-------------------------------------
29-11-96 	3.0			PBT			System 3 modification
03-07-09		19.03			RMO003 		Refined to also test for purpose, and not only if cargo port or not
************************************************************************************/

/* Declare local variables */
long ll_cal_calc_id, ll_cnt_1, ll_cnt_2

/* Get calc id for this vessel voyage */
select isnull(CAL_CALC_ID,1)
into :ll_cal_calc_id
from VOYAGES
where 	VESSEL_NR = :al_vessel_nr and
		VOYAGE_NR = :as_voyage_nr;
commit;
/* If vessel voyage is pre-system 3 then return (true) because it is not relevant */
if ll_cal_calc_id = 1 then return true

/* If there is no calculation on the voyage, then return false, as user cannot load or discharge */
if isnull(ll_cal_calc_id)  then return false

/* Choose case of testing (either, L, D, L/D */
CHOOSE CASE as_purpose
	CASE "L"
		/* Get how many times this port is loaded in calc */
		select count(IO.PORT_CODE)
		into :ll_cnt_1
		from CAL_CARG C, CAL_CAIO IO		
		where C.CAL_CALC_ID = :ll_cal_calc_id and
				C.CAL_CARG_ID = IO.CAL_CARG_ID and
				IO.PORT_CODE = :as_port_code and
				IO.PURPOSE_CODE = "L" and
				IO.CAL_CAIO_NUMBER_OF_UNITS > 0;
		commit;
		/* If load in calc, return true, else false */
		if ll_cnt_1 > 0 then 
			return true
		else 
			return false
		end if
	CASE "D"
		/* Get how many times this port is discharged in calc */
		select count(IO.PORT_CODE)
		into :ll_cnt_2
		from CAL_CARG C, CAL_CAIO IO		
		where C.CAL_CALC_ID = :ll_cal_calc_id and
				C.CAL_CARG_ID = IO.CAL_CARG_ID and
				IO.PORT_CODE = :as_port_code and
				IO.PURPOSE_CODE = "D" and
				IO.CAL_CAIO_NUMBER_OF_UNITS < 0;
		commit;
		/* If disch. in calc, return true, else false */
		if  ll_cnt_2 > 0 then 
			return true
		else 
			return false
		end if
	CASE "L/D"
		/* Get how many times this port is loaded in calc */
		select count(IO.PORT_CODE)
		into :ll_cnt_1
		from CAL_CARG C, CAL_CAIO IO		
		where C.CAL_CALC_ID = :ll_cal_calc_id and
				C.CAL_CARG_ID = IO.CAL_CARG_ID and
				IO.PORT_CODE = :as_port_code and
				IO.PURPOSE_CODE = "L" and
				IO.CAL_CAIO_NUMBER_OF_UNITS > 0;
		commit;
		/* Get how many times this port is discharged in calc */
		select count(IO.PORT_CODE)
		into :ll_cnt_2
		from CAL_CARG C, CAL_CAIO IO		
		where C.CAL_CALC_ID = :ll_cal_calc_id and
				C.CAL_CARG_ID = IO.CAL_CARG_ID and
				IO.PORT_CODE = :as_port_code and
				IO.PURPOSE_CODE = "D" and
				IO.CAL_CAIO_NUMBER_OF_UNITS < 0;
		commit;
		/* If both load and dish. in calc, return true, else false */
		if ll_cnt_1 > 0 and ll_cnt_2 > 0 then 
			return true
		else 
			return false
		end if
END CHOOSE

return true
end function

public function integer wf_data_modified ();
/* Checkes if any data in POC are modified and not
	saved when changing vessel, voyage, port, tabpage
	
	Returns -1 if any data modified and not saved
				1 if no data changed or changes shall be cancelled
*/

string	ls_message

this.tab_poc.tabpage_act.dw_port_of_call.acceptText()
IF this.tab_poc.tabpage_act.dw_port_of_call.ModifiedCount() > 0 THEN
	this.tab_poc.selectedtab = 1
	IF MessageBox("Data Not Saved", "Actual Port of Call data modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 THEN
		this.tab_poc.tabpage_act.cb_updateact.triggerEvent(Clicked!)
		ib_flagupdate = false
	ELSE
		ib_flagupdate=true
		ib_allowclose = true			//CR2535 & 2536 Added by ZSW001 on 17/11/2011
	END IF
END IF

this.tab_poc.tabpage_est.dw_port_of_call_est.acceptText()
IF this.tab_poc.tabpage_est.dw_port_of_call_est.ModifiedCount() > 0 THEN
	this.tab_poc.selectedtab = 2
	IF MessageBox("Data Not Saved", "Estimated Port of Call data modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 THEN
		this.tab_poc.tabpage_est.cb_updateest.triggerEvent(Clicked!)
		ib_flagupdate=false
	ELSE
		ib_flagupdate=true
		ib_allowclose = true			//CR2535 & 2536 Added by ZSW001 on 17/11/2011
	END IF
END IF

this.tab_poc.tabpage_voy_text.dw_voyage_text.acceptText()
IF this.tab_poc.tabpage_voy_text.dw_voyage_text.ModifiedCount() > 0 THEN
	this.tab_poc.selectedtab = 3
	IF MessageBox("Data Not Saved", "Voyage Comments modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 THEN
		this.tab_poc.tabpage_voy_text.cb_update_voyage_text.triggerEvent(Clicked!)
	END IF
END IF

this.tab_poc.tabpage_vessel_text.dw_vessel_text.acceptText()
IF this.tab_poc.tabpage_vessel_text.dw_vessel_text.ModifiedCount() > 0 THEN
	this.tab_poc.selectedtab = 5
	IF MessageBox("Data Not Saved", "Vessel Details modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 THEN
		this.tab_poc.tabpage_vessel_text.cb_update_vessel_text.triggerEvent(Clicked!)
	END IF
END IF

this.tab_poc.tabpage_port_details.dw_port_details.acceptText()

IF this.tab_poc.tabpage_port_details.dw_port_details.ModifiedCount() > 0  THEN
	this.tab_poc.selectedtab = 6
	IF MessageBox("Data Not Saved", "Port Details modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 THEN
		this.tab_poc.tabpage_port_details.cb_update_port_details.triggerEvent(Clicked!)
	END IF
END IF

this.tab_poc.tabpage_owners_matters.dw_department_info.acceptText()
this.tab_poc.tabpage_owners_matters.dw_department_list.acceptText()
if this.tab_poc.tabpage_owners_matters.dw_department_info.modifiedcount() > 0 or &
	this.tab_poc.tabpage_owners_matters.dw_department_list.modifiedcount() > 0 then
	if not ib_new then
		this.tab_poc.selectedtab = 7
		if messagebox("Data Not Saved", "Owners Matters modified, but not saved.~n~r~n~r" +&
					  "Would you like to update data before switching?", Question!, YesNo!, 1) = 1 then
			this.tab_poc.tabpage_owners_matters.cb_update.triggerevent(clicked!)
		else
			ib_allowclose = true
		end if
	end if
end if

this.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.acceptText()
IF this.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.ModifiedCount() > 0 THEN
	this.tab_poc.selectedtab = 8
	IF MessageBox("Data Not Saved", "Bunker Stock modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 THEN
		this.tab_poc.tabpage_bunker_stock.cb_update_vessel_bunker_stock.triggerEvent(Clicked!)
	END IF
END IF
Return 1
end function

public function string wf_replace_special_char (string as_string);
/* This function is changed to replace special characters instead of showing users where they are */

// This function checks whether VOYAGE_COMMENT contains ' or "
integer ll_length, ll_start

ll_length = len(as_string)

FOR ll_start=1  TO ll_length
//	if (asc(Mid(as_string,ll_start)) = 34 or asc(Mid(as_string,ll_start)) = 39 or asc(Mid(as_string,ll_start)) = 8211) then
//	messageBox(string(ll_start), asc(Mid(as_string,ll_start)))
	if (asc(Mid(as_string,ll_start)) > 256) then
//		MessageBox("","Yes")
		 as_string = replace(as_string, ll_start, 1, " ")
	end if
NEXT

return as_string

end function

public subroutine wf_checktccontract ();
/* This function checks if there is a TC Hire IN Contract present
	where hire = 0 (zero).
	If yes and the contract will run out within 60 days, tell the 
	that they have to enter a new redelivery date
*/
integer	li_days

SELECT DATEDIFF(DD, GETDATE(), MAX(PERIODE_END)) 
INTO :li_days
FROM NTC_TC_PERIOD
WHERE CONTRACT_ID = (SELECT MAX(C.CONTRACT_ID) 
									FROM NTC_TC_PERIOD P, NTC_TC_CONTRACT C 
									WHERE C.CONTRACT_ID = P.CONTRACT_ID
									AND C.TC_HIRE_IN = 1
									AND C.VESSEL_NR = :ii_vessel_nr
									AND P.PERIODE_END <  DATEADD(dd, 60,GETDATE())
									AND P.RATE = 0 );
if isNull(li_days) OR li_days < 0 OR li_days > 60 then
	st_warning.text = " "
else
	st_warning.text = "Be aware of that the TC-in Contract (Pool Vessel) will expire in "+string(li_days)+" days."
end if

if li_days > 0 and li_days < 6 then
	timer(0.333, w_port_of_call)
else
	timer(0, w_port_of_call)
end if



end subroutine

public function integer wf_connecttccontract (ref datawindow adw_poc);
integer 					li_vessel_nr, li_tcowner
long 						ll_contractID
string 					ls_voyage_nr, ls_purpose
datetime					ldt_contract_arrival_departure, ldt_calculated_arrival_departure
s_select_tc_contract 	lstr_parm
boolean					lb_contract_localtime

li_vessel_nr 		= adw_poc.getitemnumber(1,"vessel_nr")
ls_purpose 	 	= adw_poc.getitemstring(1,"purpose_code")
ls_voyage_nr 	= adw_poc.getitemstring(1,"voyage_nr")
ll_contractID = adw_poc.getitemNumber(1,"contract_id")

/* Check if this voyage/portcall shall be connected to a TC Contract or not */
if isNull(ll_contractID) then
	SELECT TCOWNER_NR INTO :li_tcowner FROM VESSELS WHERE VESSEL_NR = :li_vessel_nr;
	SELECT VOYAGE_TYPE INTO :lstr_parm.tc_hire_in FROM VOYAGES WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
	if lstr_parm.tc_hire_in = 2 then
		lstr_parm.tc_hire_in = 0
	else	
		lstr_parm.tc_hire_in = 1
	end if
	if (lstr_parm.tc_hire_in = 1 and not isNull(li_tcowner)) or (lstr_parm.tc_hire_in = 0) then   // delivery on a single voyage where there  
		lstr_parm.vessel_nr = li_vessel_nr																	 // is no TC-owner registred is equal to 
		lstr_parm.purpose = ls_purpose																	// delivery of new vessel from yard for "internal use"
		if lstr_parm.purpose = "DEL" then																	// and shall not be connected to a TC-Contract
			lstr_parm.arrival = true
		else
			lstr_parm.arrival = false
		end if
		openwithParm(w_confirm_arrival_departure, lstr_parm)												
		lstr_parm = message.powerobjectparm
		if isNull(lstr_parm.arrival_departure) then 
			MessageBox("Input Missing","Please enter Arrival or Departure date.")
			Return -1
		end if
		if isNull(lstr_parm.lt_to_utc_difference) then 
			MessageBox("Input Missing","Please enter time difference between LT and UTC.")
			Return -1
		end if
		openwithParm(w_select_tc_contract, lstr_parm)												
		ll_contractID = message.doubleparm
		if isNull(ll_contractID) then
			MessageBox("Input Missing","You have to select a TC contract when purpose is Delivery/Re-delivery.")
			Return -1
		else
			if ls_purpose = "DEL" then		/* Delivery update arrival date */
				SELECT DELIVERY, LOCAL_TIME INTO :ldt_contract_arrival_departure, :lb_contract_localtime FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_contractID;
				if lb_contract_localtime then   
					ldt_calculated_arrival_departure = lstr_parm.arrival_departure
				else
					ldt_calculated_arrival_departure = f_long2datetime(f_datetime2long(lstr_parm.arrival_departure) + (lstr_parm.lt_to_utc_difference * 3600))
				end if
				if ldt_calculated_arrival_departure <> ldt_contract_arrival_departure then
					MessageBox("Confirmation Failed", "Entered arrival date is not matching TC Contract Delivery.~r~n~r~nPlease correct TC Contract and try again.")
					return -1
				else
					adw_poc.setItem(1,"contract_id", ll_contractID )
					adw_poc.setItem(1,"port_arr_dt",  lstr_parm.arrival_departure )
					adw_poc.setItem(1,"lt_to_utc_difference", lstr_parm.lt_to_utc_difference )
				end if
			elseif ls_purpose = "RED" then   /* Re-delivery update departure date */
				SELECT max(PERIODE_END) INTO :ldt_contract_arrival_departure FROM NTC_TC_PERIOD WHERE CONTRACT_ID = :ll_contractID;
				SELECT LOCAL_TIME INTO :lb_contract_localtime FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_contractID;
				if lb_contract_localtime then   
					ldt_calculated_arrival_departure = lstr_parm.arrival_departure
				else
					ldt_calculated_arrival_departure = f_long2datetime(f_datetime2long(lstr_parm.arrival_departure) + (lstr_parm.lt_to_utc_difference * 3600))
				end if
				if ldt_calculated_arrival_departure <> ldt_contract_arrival_departure then
					MessageBox("Confirmation Failed", "Entered Departure date is not matching TC Contract Redelivery.~r~n~r~nPlease correct TC Contract and try again.")
					return -1
				else
					adw_poc.setItem(1,"contract_id", ll_contractID )
					adw_poc.setItem(1,"port_dept_dt",  lstr_parm.arrival_departure )
					adw_poc.setItem(1,"lt_to_utc_difference", lstr_parm.lt_to_utc_difference )
				end if
			end if
			
		end if
	end if
else
	/* If difference changed update arrival or departure date according to LT to UTC difference */
	if adw_poc.getItemStatus(1, "lt_to_utc_difference", primary!) = dataModified! then
		lstr_parm.lt_to_utc_difference = adw_poc.getItemNumber(1, "lt_to_utc_difference")
		if ls_purpose = "DEL" then		/* Update arrival date */
			SELECT DELIVERY, LOCAL_TIME INTO :ldt_contract_arrival_departure, :lb_contract_localtime FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_contractID;
			if not lb_contract_localtime then
				ldt_calculated_arrival_departure = f_long2datetime(f_datetime2long(ldt_contract_arrival_departure) - (lstr_parm.lt_to_utc_difference * 3600))
				adw_poc.setItem(1,"port_arr_dt",  ldt_calculated_arrival_departure )
			end if					
		elseif ls_purpose = "RED" then	/* Update departure date */
			SELECT max(PERIODE_END) INTO :ldt_contract_arrival_departure FROM NTC_TC_PERIOD WHERE CONTRACT_ID = :ll_contractID;
			SELECT LOCAL_TIME INTO :lb_contract_localtime FROM NTC_TC_CONTRACT WHERE CONTRACT_ID = :ll_contractID;
			if not lb_contract_localtime then
				ldt_calculated_arrival_departure = f_long2datetime(f_datetime2long(ldt_contract_arrival_departure) - (lstr_parm.lt_to_utc_difference * 3600))
				adw_poc.setItem(1,"port_dept_dt",  ldt_calculated_arrival_departure )
			end if					
		end if
	end if
end if

return 1
end function

public subroutine wf_check_bunker_tcout_delivery ();
/* This function makes a check for if bunker registrations are OK when a vessel goes on TC-OUT 

	if Delivery on TC-OUT the bunker arrival quantities must be the same af previous departure if any
	
	if single voyage and next POC is Delivery TC-out then bunker departure quantities must be the same as next arrival if any   
	
	Shows a warning if no match  */

decimal {4}		ld_hfo, ld_do, ld_go, ld_lshfo, ld_current_hfo, ld_current_do, ld_current_go, ld_current_lshfo 
datetime 		ldt_date
integer			li_vessel, li_current_voyage_type, li_voyage_type 
string				ls_current_purpose, ls_purpose

li_vessel = 						w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"vessel_nr") 
ls_current_purpose = 		w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"purpose_code")
li_current_voyage_type =	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"voyages_voyage_type")

if ls_current_purpose = "DEL" and li_current_voyage_type = 2 then
	/* Delivery for TC-OUT contract */
	ldt_date = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemDatetime(1,"port_arr_dt")
	 SELECT TOP 1 isNull(DEPT_HFO,0), isNull(DEPT_DO,0), isNull(DEPT_GO,0), isNull(DEPT_LSHFO,0), VOYAGES.VOYAGE_TYPE
		INTO :ld_hfo, :ld_do, :ld_go, :ld_lshfo, :li_voyage_type
		FROM POC,   
			PROCEED,   
			VOYAGES  
		WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR  and  
			PROCEED.VOYAGE_NR = POC.VOYAGE_NR  and  
			PROCEED.PORT_CODE = POC.PORT_CODE  and  
			PROCEED.PCN = POC.PCN  and  
			VOYAGES.VESSEL_NR = PROCEED.VESSEL_NR  and  
			VOYAGES.VOYAGE_NR = PROCEED.VOYAGE_NR  and  
			POC.PORT_ARR_DT <  :ldt_date and
			POC.VESSEL_NR = :li_vessel 
		ORDER BY POC.PORT_ARR_DT DESC  ;
	if sqlca.sqlcode = 100 then 
		rollback;
		return 	  // no previous port 
	end if
	if sqlca.sqlcode = -1 then
		rollback;
		MessageBox("Select Error", "Error selecting from previous Port of Call. (wf_check_tcout_delivery)")
		return
	end if
	commit;
	if li_voyage_type <> 2 then
		ld_current_hfo	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"arr_hfo")	
		if isNull(ld_current_hfo) then ld_current_hfo = 0
		ld_current_do	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"arr_do")	
		if isNull(ld_current_do) then ld_current_do = 0
		ld_current_go	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"arr_go")	
		if isNull(ld_current_go) then ld_current_go = 0
		ld_current_lshfo	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"arr_lshfo")	
		if isNull(ld_current_lshfo) then ld_current_lshfo = 0
		if (ld_current_hfo <> ld_hfo) or (ld_current_do <> ld_do) or (ld_current_go <> ld_go) or (ld_current_lshfo <> ld_lshfo) then
			MessageBox("Warning", "As this Port of Call is a Delivery on a TC Out Contract,~n~r"+&
							"the previous port departure bunker quantities must be the~n~r"+&
							"same as this ports arrival quantities.~n~r~n~r" +&
							"Previous port quantities are:~n~r" +&
							"HSFO~t= "+string(ld_hfo, "#,##0.0000")+"~n~r" +&
							"LSGO~t= "+string(ld_do, "#,##0.0000")+"~n~r" +&
							"HSGO~t= "+string(ld_go, "#,##0.0000")+"~n~r" +&
							"LSFO~t= "+string(ld_lshfo, "#,##0.0000"))
			return
		end if
	end if
elseif li_current_voyage_type <> 2 then
	/* Single voyage */
	ldt_date = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemDatetime(1,"port_arr_dt")
	 SELECT TOP 1 isNull(ARR_HFO,0), isNull(ARR_DO,0), isNull(ARR_GO,0), isNull(ARR_LSHFO,0), VOYAGES.VOYAGE_TYPE, POC.PURPOSE_CODE
		INTO :ld_hfo, :ld_do, :ld_go, :ld_lshfo, :li_voyage_type, :ls_purpose
		FROM POC,   
			PROCEED,   
			VOYAGES  
		WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR  and  
			PROCEED.VOYAGE_NR = POC.VOYAGE_NR  and  
			PROCEED.PORT_CODE = POC.PORT_CODE  and  
			PROCEED.PCN = POC.PCN  and  
			VOYAGES.VESSEL_NR = PROCEED.VESSEL_NR  and  
			VOYAGES.VOYAGE_NR = PROCEED.VOYAGE_NR  and  
			POC.PORT_ARR_DT >  :ldt_date and
			POC.VESSEL_NR = :li_vessel 
		ORDER BY POC.PORT_ARR_DT  ;
	if sqlca.sqlcode = 100 then 
		rollback;
		return 	  // no next port 
	end if
	if sqlca.sqlcode = -1 then
		rollback;
		MessageBox("Select Error", "Error selecting from next Port of Call. (wf_check_tcout_delivery)")
		return
	end if
	commit;
	if li_voyage_type = 2 and ls_purpose = "DEL" then
		ld_current_hfo	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_hfo")	
		if isNull(ld_current_hfo) then ld_current_hfo = 0
		ld_current_do	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_do")	
		if isNull(ld_current_do) then ld_current_do = 0
		ld_current_go	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_go")	
		if isNull(ld_current_go) then ld_current_go = 0
		ld_current_lshfo	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_lshfo")	
		if isNull(ld_current_lshfo) then ld_current_lshfo = 0
		if (ld_current_hfo <> ld_hfo) or (ld_current_do <> ld_do) or (ld_current_go <> ld_go) or (ld_current_lshfo <> ld_lshfo) then
			MessageBox("Warning", "As this Port of Call is right before Delivery on a TC Out Contract,~n~r"+&
							"this port departure bunker quantities must be the~n~r"+&
							"same as Delivery port arrival quantities. Please correct.~n~r~n~r" +&
							"Delivery port quantities are:~n~r" +&
							"HSFO~t= "+string(ld_hfo, "#,##0.0000")+"~n~r" +&
							"LSGO~t= "+string(ld_do, "#,##0.0000")+"~n~r" +&
							"HSGO~t= "+string(ld_go, "#,##0.0000")+"~n~r" +&
							"LSFO~t= "+string(ld_lshfo, "#,##0.0000"))
			return
		end if
	end if
end if

return 

end subroutine

public subroutine wf_check_bunker_tcout_redelivery ();
/* This function makes a check for if bunker registrations are OK when a vessel goes on TC-OUT 

	if Delivery on TC-OUT the bunker arrival quantities must be the same af previous departure if any
	
	if single voyage and next POC is Delivery TC-out then bunker departure quantities must be the same as next arrival if any   
	
	Shows a warning if no match  */

decimal {4}		ld_hfo, ld_do, ld_go, ld_lshfo, ld_current_hfo, ld_current_do, ld_current_go, ld_current_lshfo 
datetime 		ldt_date
integer			li_vessel, li_voyage_type, li_pcn 
string				ls_purpose, ls_voyage, ls_portcode

ls_purpose = 		w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"purpose_code")
li_voyage_type =	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"voyages_voyage_type")

if ls_purpose = "RED" and li_voyage_type = 2 then
	li_vessel = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"vessel_nr") 
	ls_voyage = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"voyage_nr") 
	ls_portcode = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"port_code") 
	li_pcn = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"pcn") 
	/* Redelivery for TC-OUT contract */
	SELECT sum(BP_DETAILS.LIFTED_HFO),   
			  sum(BP_DETAILS.LIFTED_DO),   
			  sum(BP_DETAILS.LIFTED_GO),   
			  sum(BP_DETAILS.LIFTED_LSHFO)
		INTO :ld_hfo, 
			:ld_do,
			:ld_go,
			:ld_lshfo
		FROM BP_DETAILS  
		WHERE BP_DETAILS.VESSEL_NR = :li_vessel 
		AND BP_DETAILS.VOYAGE_NR = :ls_voyage 
		AND BP_DETAILS.PORT_CODE = :ls_portcode 
		AND BP_DETAILS.PCN = :li_pcn 
		AND BP_DETAILS.BUY_SELL = 0 
		AND BP_DETAILS.OWNER_POOL_PURCHASE_OR_CHART = 2  ;
	commit;	
	ld_current_hfo	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_hfo")	
	if isNull(ld_current_hfo) then ld_current_hfo = 0
	ld_current_do	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_do")	
	if isNull(ld_current_do) then ld_current_do = 0
	ld_current_go	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_go")	
	if isNull(ld_current_go) then ld_current_go = 0
	ld_current_lshfo	=	w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"dept_lshfo")	
	if isNull(ld_current_lshfo) then ld_current_lshfo = 0
	if (ld_current_hfo <> ld_hfo) or (ld_current_do <> ld_do) or (ld_current_go <> ld_go) or (ld_current_lshfo <> ld_lshfo) then
		MessageBox("Warning", "As this Port of Call is a Redelivery on a TC Out Contract,~n~r"+&
						"the port departure bunker quantities must be the~n~r"+&
						"same as quantities bought from Charterer. Please correct.~n~r~n~r" +&
						"Bought quantities are:~n~r" +&
						"HSFO~t= "+string(ld_hfo, "#,##0.0000")+"~n~r" +&
						"LSGO~t= "+string(ld_do, "#,##0.0000")+"~n~r" +&
						"HSGO~t= "+string(ld_go, "#,##0.0000")+"~n~r" +&
						"LSFO~t= "+string(ld_lshfo, "#,##0.0000"))
	end if
end if

return 

end subroutine

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: w_port_of_call
   <OBJECT> The window containing the port of call detail</OBJECT>
   <DESC>  Here the user controls all things regarding the port of
	call</DESC>
   <USAGE>  Called from an icon on the menubar or a menubar option.  It is
	also available on a shortcut</USAGE>
   	<ALSO>   otherobjs
		AGL COMMENT 11/05/11: the validation here is very heavy & not strong.  
		Look into possibility of applying the dw validation service here instead.  Need agreement on
		standards in how validation should be implemented.
	</ALSO>
	<HISTORY>
		Date    		Ref      	Author   		Comments
		00/00/07		?        	Name Here		First Version
		06/09/10		1896     	AGL027   		Added new Attachments tab that runs at a 
												   		Voyage level.
		20/10/10		2168     	RMO003   		Added check for unsaved changes when window is closed		
		09/11/10		2161     	JMC112   		Delete close button and few interface changes
		10/11/10		2194     	JMC112   		Added Operator Responsible
		06/12/10		2186     	JMC112   		Complete refacturing + task list
		15/12/10		         	JMC112   		CR 2217, 2222, 2223
		03/01/11		2234     	JMC112   		do not notify demurrage for tc out voyages	
		10/01/11		2250     	JMC112   		code improvement in function _send_finished_voyage_alert( )
		06/04/11		2339     	AGL027   		Stopped the possibility of finishing an idle voyage.
		14/04/11		2381     	AGL027   		Applied accruals check to the finish voyage button.
		05/05/11		         	AGL027   		cr#2383, cr#2391 & cr#2392, cr#2340
		10/05/11		2410     	WWG004   		Operators can't move an estimate POC to an actual POC 
												   		if there are one or more estimate POC before this.
		12/05/11		2410     	WWG004   		Add a new feature of auto schedule calculation in POC.					
		20/05/11		2408     	LHC010   		Double-clicking related columns in POC List will open Port of Call
		24/05/11		2408     	LHC010   		operators can't new actual or move estimate to actual if voyage is set on subs.
		25/05/11		2414     	LHC010   		List the laycan and CP information on the Voyage Comments tab in POC
		03/06/11		2408     	LGX001   		Add the performing agent  (removed)
		22/06/11		2408     	LHC010   		Clicking the POC List button will bring POC List window to the upfront.
		29/06/11		2492     	JSU042   		add validation
		15/07/11		2410     	ZSW001   		add wf_validate function.
		09/08/11		2542     	JMC112   		Change Performance agent selection
		05/09/11		2508     	LGX001   		Estimated POC should not be moved to actual when arrival date is after departure date
		14/11/11		2535&2536	ZSW001   		Add auto schedule function
		08/03/12		FIN08    	AGL027   		Add functionality to generate estimated transactionn when user finishes a voyage.
		10/04/12		CR20     	LHC010   		Add vessel communication TFV flag
		19/06/12		CR#2831  	AGL027   		Removed obsolete code
		19/09/12		CR2914   	ZSW001   		When a voyage is finished in Tramos for the first time, don't sent the voyage estimation data to AX
		11/10/12		CR2719   	ZSW001   		Add LSHFO (instead of only HFO) to business logic around mandatory SLOP field on Actual port of calls.
		30/10/12		CR2888   	JMY014   		When updating the port comments, the last updated date and user ID should not changed.
		07/11/12		CR2926   	WWG004   		When change a vessel, the current vessel's comments can't update.
		22/11/12		CR2990   	RJH022   		Add a new tab page "Port Details" with one large free text field next to "Vessel Details" tab page
		24/11/12		CR2870   	ZSW001   		Modify the column's text color according to autoschedule or manually input.
		26/12/12		CR3075   	ZSW001   		It must not be possible to select another port call before mandatory fields have been updated
		13/03/13		CR3049   	LGX001   		It should not be possible to finish a voyage if the previous one does not exists
		15/05/13		CR2690   	LGX001   		1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
												   		2.change "@maersk.com" 			 as C#EMAIL.DOMAIN
		22/07/13		CR2516   	LGX001   		Tramos should not allow to save the data when we have a BUNKER mismatch.The error message should be given to the user, after clicking "Ok", the system should rollback the user's
											      		input, and set the focus on the field where he/she has typed in the mismatch.													
		16/09/13		CR3344   	AGL027   		Remove heavily used object logging on refresh click. Add new check on MVV open button
		09/06/14		CR3085UAT	XSZ004   		Fix bug based on 28.01.0 UAT defect report.
		03/07/14		CR3427   	CCY018   		Only one instance of the same system table window can be opened at the same time.
		04/09/14		CR3759   	KSH092   		Port Details add attachment
		04/09/14		CR3760   	KSH092   		Port Details text add internet or email link
		12/09/14		CR3773   	XSZ004   		Change icon absolute path to reference path
		26/11/14		CR3761		AZX004			Fix forget to enter the vessel number in the automated email.	
		27/11/14		CR3813		CCY018			Add Estimated Bunker on Arrival and Departure in Estimated POC
		31/12/14		CR3752		CCY018			Show TCE in POC or Estimated POC.
		26/03/15		CR3948		CCY018			Fix a bug.
		15/07/15		CR3923      KSH092			Add tabpage bunker stock and change vesseldetail,add vessel detail attachments
		20/07/15		CR3226		XSZ004			Change label for Bunkers Type.
		11/07/15		CR3375		XSZ004			Update discharge date of claims when finish voyage.
		30/09/15		CR4026      KSH092			Add Water Density column in Draft groupbox of Actual tabpage 
		29/02/16		CR3099		XSZ004			Add validations for idle days start and end dates when finish voyage. 
		20/10/16		CR4279		HHX010			Add function wf_update_timebar	
		27/03/17		CR4439		HHX010			The specific tasks for TC-out voyages will only appear in TC-out voyages. Otherwise it will appear in all voyage types.
															Add validations for tasks with “Finished” checkbox checked when click ''Finish Voyage'' .
		23/03/17		CR4414		CCY018			Add voyage alert
		22/08/17		CR4221		HHX010			Interim Port check
		24/11/17		CR4661		XSZ004			Change delete attachments access for Port Details and Vessel Details tab.
	</HISTORY>
*************************************************************************************************************************/

end subroutine

private subroutine _set_permissions ();
/********************************************************************
 _set_permissions 
   <DESC>	set permissions </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Private	</ACCESS>
   <ARGS>	</ARGS>
   <USAGE>Set different permissions to administrators and external APM </USAGE>
	<HISTORY>
			Date    			CR-Ref 		Author 			Comments		
			24/11/17			CR4661		XSZ004			Change delete attachments access for Port Details and Vessel Details tab.
	</HISTORY>
********************************************************************/
int 	 li_tab_index
/* Change TC Contract button and filter "Sort POC" is only visible for Administrators */
if uo_global.ii_access_level = 3 then
	w_port_of_call.tab_poc.tabpage_act.cb_change_tc.visible = true
	gb_2.visible = true
	rb_1.visible = true
	rb_2.visible = true
else 
	w_port_of_call.tab_poc.tabpage_act.cb_change_tc.visible = false
	gb_2.visible = false
	rb_1.visible = false
	rb_2.visible = false
end if
//setup the access rights of port detail's file attachment  and port detail control

if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
	w_port_of_call.tab_poc.tabpage_port_details.cb_update_port_details.enabled = true
	w_port_of_call.tab_poc.tabpage_port_details.cb_cancel_port_details.enabled = true
	
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.pb_new.enabled = true
	
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.modify("Datawindow.ReadOnly = 'No'")
	
	w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.object.ports_details.edit.displayonly = 'No'
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.object.description.edit.displayonly = 'No'
else
	w_port_of_call.tab_poc.tabpage_port_details.cb_update_port_details.enabled = false
	w_port_of_call.tab_poc.tabpage_port_details.cb_cancel_port_details.enabled = false
	
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.modify("Datawindow.ReadOnly = 'Yes'")
	
	w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.object.ports_details.edit.displayonly = 'Yes'
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.pb_new.enabled = false
	
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.object.description.edit.displayonly = 'Yes'
end if

//setup the access rights of vessel detail's file attachment  and vessel detail control

if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
	w_port_of_call.tab_poc.tabpage_vessel_text.cb_update_vessel_text.enabled = true
	w_port_of_call.tab_poc.tabpage_vessel_text.cb_cancel_vessel_text.enabled = true
	
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_new.enabled = true
	
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.modify("Datawindow.ReadOnly = 'No'")
	
	w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.object.details.edit.displayonly = 'No'
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.object.description.edit.displayonly = 'No'
else
	w_port_of_call.tab_poc.tabpage_vessel_text.cb_update_vessel_text.enabled = false
	w_port_of_call.tab_poc.tabpage_vessel_text.cb_cancel_vessel_text.enabled = false
	
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.modify("Datawindow.ReadOnly = 'Yes'")
	
	w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.object.details.edit.displayonly = 'Yes'
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_new.enabled = false
	
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.object.description.edit.displayonly = 'Yes'
end if

if ( uo_global.ii_access_level = C#usergroup.#ADMINISTRATOR or uo_global.ii_access_level = C#usergroup.#SUPERUSER ) &
	and uo_global.ii_user_profile < 3 then
	
 	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_delete.enabled = true
	tab_poc.tabpage_port_details.uo_port_att.pb_delete.enabled = true
else
	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_delete.enabled = false
	tab_poc.tabpage_port_details.uo_port_att.pb_delete.enabled = false
end if

/* setup the access rights of the file attachment control */
tab_poc.tabpage_att.uo_att.of_setaccesslevel( uo_global.ii_access_level)
tab_poc.tabpage_owners_matters.uo_attach.of_setaccesslevel( uo_global.ii_access_level)

ib_readonlyaccess = false

/* If external APM - read only access */
IF uo_global.ii_access_level = -1 THEN 
	ib_readonlyaccess = true
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Object.Datawindow.ReadOnly="yes"
	w_port_of_call.tab_poc.tabpage_act.cb_newact.visible = false
	w_port_of_call.tab_poc.tabpage_act.cb_updateact.visible = false
	w_port_of_call.tab_poc.tabpage_act.cb_deleteactual.visible = false
	w_port_of_call.tab_poc.tabpage_act.cb_cancel_actual.visible = false
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Object.p_refresh.visible = 0
		
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Object.Datawindow.ReadOnly="yes"
	w_port_of_call.tab_poc.tabpage_est.cb_move_est_act.visible = false
	w_port_of_call.tab_poc.tabpage_est.cb_newest.visible = false
	w_port_of_call.tab_poc.tabpage_est.cb_updateest.visible = false
	w_port_of_call.tab_poc.tabpage_est.cb_deleteest.visible = false
	w_port_of_call.tab_poc.tabpage_est.cb_cancel_est.visible = false
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Object.p_refresh.visible = 0
	
	w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.Object.Datawindow.ReadOnly="yes"
	w_port_of_call.tab_poc.tabpage_voy_text.cb_cancel_voyage_text.visible = false
	w_port_of_call.tab_poc.tabpage_voy_text.cb_update_voyage_text.visible = false
	
	w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.Object.Datawindow.ReadOnly="yes"
	w_port_of_call.tab_poc.tabpage_bunker_stock.cb_cancel_vessel_bunker_stock.visible = false
	w_port_of_call.tab_poc.tabpage_bunker_stock.cb_update_vessel_bunker_stock.visible = false
	
	dw_task_list.Object.Datawindow.ReadOnly="yes"
	
	w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.enabled = false
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.object.datawindow.readonly = 'yes'
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.object.datawindow.readonly = "yes"
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_update.visible = false
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_print.visible = false
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_cancel.visible = false
	
	cb_finished.visible = false
	
END IF

end subroutine

private subroutine _set_interface (integer ai_est, integer ai_act);/********************************************************************
 _set_interface
   <DESC>	set interface options as enabled/disabled </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Private	</ACCESS>
   <ARGS>	ai_est: number of rows of estimated POC
            	ai_act:  number of rows of Actual POC	</ARGS>
   <USAGE></USAGE>
********************************************************************/

boolean lb_isactive

if w_port_of_call.tab_poc.tabpage_act.enabled = false then
	w_port_of_call.tab_poc.tabpage_act.enabled = true
	w_port_of_call.tab_poc.tabpage_est.enabled = true
	w_port_of_call.tab_poc.tabpage_vessel_text.enabled = true
	w_port_of_call.tab_poc.tabpage_voy_text.enabled = true
	w_port_of_call.tab_poc.tabpage_att.enabled = true
end if

if ai_est > 0 then
	//Estimated POC created
	w_port_of_call.tab_poc.tabpage_est.cb_newest.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_move_est_act.enabled = true
	w_port_of_call.tab_poc.tabpage_est.cb_updateest.enabled = true
	w_port_of_call.tab_poc.tabpage_est.cb_deleteest.enabled = true
	w_port_of_call.tab_poc.tabpage_est.cb_cancel_est.enabled = true

	w_port_of_call.tab_poc.tabpage_act.cb_newact.enabled = false
	w_port_of_call.tab_poc.tabpage_act.cb_updateact.enabled = false
	w_port_of_call.tab_poc.tabpage_act.cb_deleteactual.enabled = false
	w_port_of_call.tab_poc.tabpage_act.cb_cancel_actual.enabled = false
elseif ai_act > 0 then
	//Actual POC created
	w_port_of_call.tab_poc.tabpage_act.cb_newact.enabled = false

	if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemnumber( 1, "voyages_voyage_finished") = 1 then
		lb_isactive = false
	else
		lb_isactive = true
	end if

	w_port_of_call.tab_poc.tabpage_act.cb_updateact.enabled = lb_isactive
	w_port_of_call.tab_poc.tabpage_act.cb_deleteactual.enabled = lb_isactive
	w_port_of_call.tab_poc.tabpage_act.cb_cancel_actual.enabled = lb_isactive
	
	w_port_of_call.tab_poc.tabpage_est.cb_newest.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_move_est_act.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_updateest.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_deleteest.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_cancel_est.enabled = false
else
	//POC not created
	w_port_of_call.tab_poc.tabpage_act.cb_newact.enabled =  true
	w_port_of_call.tab_poc.tabpage_est.cb_newest.enabled = true
	
	w_port_of_call.tab_poc.tabpage_act.cb_updateact.enabled = false
	w_port_of_call.tab_poc.tabpage_act.cb_deleteactual.enabled = false
	w_port_of_call.tab_poc.tabpage_act.cb_cancel_actual.enabled = false

	w_port_of_call.tab_poc.tabpage_est.cb_move_est_act.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_updateest.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_deleteest.enabled = false
	w_port_of_call.tab_poc.tabpage_est.cb_cancel_est.enabled = false
end if

//Set the interface of owners matters tabpage
if w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.rowcount() > 0 then
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_update.enabled 		 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_print.enabled  		 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_cancel.enabled 		 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.enabled 		 = true
	
	w_port_of_call.tab_poc.tabpage_owners_matters.visible 				 	 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_update.visible	 	 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_print.visible		 	 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.cb_cancel.visible 		 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.visible 		 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.gb_activites.visible 	 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.gb_activites.bringtotop = false
	w_port_of_call.tab_poc.tabpage_owners_matters.st_contacts.visible		 = true
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.visible = true
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.visible = true
else
	w_port_of_call.tab_poc.tabpage_owners_matters.visible = false
end if

end subroutine

public subroutine wf_initialize_tasklist (long al_vesselnr, string as_voyagenr);/********************************************************************
 wf_initialize_tasklist
   <DESC>Create a task list or the full voyage  </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Public 	</ACCESS>
   <ARGS>	al_vesselnr: Vessel number
            	as_voyagenr: Voyage number
	</ARGS>
   <USAGE>Copies the task list template to the voyage task list</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		27-03-17		CR4439		HHX010		The specific tasks for TC-out voyages will only appear in TC-out voyages. Otherwise it will appear in all voyage types.
   </HISTORY>	
********************************************************************/
if ib_readonlyaccess = true then return

INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
	( SELECT 
		POC.VESSEL_NR,   
			POC.VOYAGE_NR,   
		POC.PORT_CODE,   
		POC.PCN  ,
		POC_TASKS_CONFIG_PC.TASK_ID,
		POC_TASKS_CONFIG_PC.TASK_SORT
	FROM POC, POC_TASKS_CONFIG_PC, VOYAGES
	WHERE POC.VESSEL_NR = :al_vesselnr AND   POC.VOYAGE_NR = :as_voyagenr
		AND POC_TASKS_CONFIG_PC.PURPOSE_CODE = POC.PURPOSE_CODE
		AND	POC_TASKS_CONFIG_PC.PC_NR = :ii_pcnr 
		AND VOYAGES.VESSEL_NR = POC.VESSEL_NR
		AND VOYAGES.VOYAGE_NR = POC.VOYAGE_NR 
		AND ((VOYAGES.VOYAGE_TYPE <> 2 AND POC_TASKS_CONFIG_PC.TASK_USE_TCOUT = 0) OR (VOYAGES.VOYAGE_TYPE = 2))	
		);
	
if sqlca.sqlcode=-1 then
	rollback;
	MessageBox("Error", "Error in Initializing the task list.")
	return
end if


INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
	( SELECT 
		POC_EST.VESSEL_NR,   
   		POC_EST.VOYAGE_NR,   
		POC_EST.PORT_CODE,   
		POC_EST.PCN  ,
		POC_TASKS_CONFIG_PC.TASK_ID,
		POC_TASKS_CONFIG_PC.TASK_SORT
	FROM POC_EST, POC_TASKS_CONFIG_PC, VOYAGES
	WHERE POC_EST.VESSEL_NR = :al_vesselnr  AND   POC_EST.VOYAGE_NR = :as_voyagenr 
 		AND POC_TASKS_CONFIG_PC.PURPOSE_CODE = POC_EST.PURPOSE_CODE
		AND	POC_TASKS_CONFIG_PC.PC_NR = :ii_pcnr
		AND VOYAGES.VESSEL_NR = POC_EST.VESSEL_NR
		AND VOYAGES.VOYAGE_NR = POC_EST.VOYAGE_NR 
		AND ((VOYAGES.VOYAGE_TYPE <> 2 AND POC_TASKS_CONFIG_PC.TASK_USE_TCOUT = 0) OR (VOYAGES.VOYAGE_TYPE = 2))	
	);

if sqlca.sqlcode=-1 then
	rollback;
	MessageBox("Error", "Error in Initializing the task list.")
else
	commit;
end if


end subroutine

public subroutine wf_refresh_task_list (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn, integer ai_estimated);/********************************************************************
wf_refresh_task_list
   <DESC>Refresh task list for a specific port of call </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Public 	</ACCESS>
   <ARGS>	al_vesselnr: Vessel number
            	as_voyagenr: Voyage number
			as_portcode: Port Code
			ai_pcn: PCN number
			ai_estimated : it¡äs 1 if estimated
	</ARGS>
   <USAGE> Refresh task list when POC purpose changes</USAGE>
	<HISTORY>
		Date    		CR-Ref		Author		Comments
		27-03-17		CR4439		HHX010		The specific tasks for TC-out voyages will only appear in TC-out voyages. Otherwise it will appear in all voyage types.
   </HISTORY>	
********************************************************************/

//Delete tasks not done
DELETE 
FROM POC_TASK_LIST
WHERE VESSEL_NR = :al_vesselnr
	AND VOYAGE_NR = :as_voyagenr
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn
	AND TASK_NA<>1 AND TASK_DONE<>1;

if sqlca.sqlcode=-1 then
	rollback;
	MessageBox("Error", "Error in updating task list.")
	return
end if

//add new template
if ai_estimated = 0 then
	
	INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
		( SELECT 
			POC.VESSEL_NR,   
				POC.VOYAGE_NR,   
			POC.PORT_CODE,   
			POC.PCN  ,
			POC_TASKS_CONFIG_PC.TASK_ID,
			POC_TASKS_CONFIG_PC.TASK_SORT
		FROM POC, POC_TASKS_CONFIG_PC, VOYAGES
		WHERE POC.VESSEL_NR = :al_vesselnr 
			AND POC.VOYAGE_NR = :as_voyagenr
			AND POC.PCN = :ai_pcn 
			AND	POC.PORT_CODE = :as_portcode
			AND POC_TASKS_CONFIG_PC.PURPOSE_CODE = POC.PURPOSE_CODE
			AND	POC_TASKS_CONFIG_PC.PC_NR = :ii_pcnr 
			AND VOYAGES.VESSEL_NR = POC.VESSEL_NR
           	AND VOYAGES.VOYAGE_NR = POC.VOYAGE_NR 
			AND ((VOYAGES.VOYAGE_TYPE <> 2 AND POC_TASKS_CONFIG_PC.TASK_USE_TCOUT = 0) OR (VOYAGES.VOYAGE_TYPE = 2))		
			AND POC_TASKS_CONFIG_PC.TASK_ID NOT IN 
					(SELECT POC_TASK_LIST.TASK_ID 
						FROM POC_TASK_LIST
						WHERE POC_TASK_LIST.VESSEL_NR = :al_vesselnr
								AND POC_TASK_LIST.VOYAGE_NR = :as_voyagenr
								AND POC_TASK_LIST.PORT_CODE = :as_portcode
								AND POC_TASK_LIST.PCN = :ai_pcn)
			);
else
		
	INSERT INTO POC_TASK_LIST (VESSEL_NR, VOYAGE_NR, PORT_CODE, PCN, TASK_ID, TASK_SORT)
		( SELECT 
			POC_EST.VESSEL_NR,   
				POC_EST.VOYAGE_NR,   
			POC_EST.PORT_CODE,   
			POC_EST.PCN  ,
			POC_TASKS_CONFIG_PC.TASK_ID,
			POC_TASKS_CONFIG_PC.TASK_SORT
		FROM POC_EST, POC_TASKS_CONFIG_PC, VOYAGES
		WHERE POC_EST.VESSEL_NR = :al_vesselnr  
			AND   POC_EST.VOYAGE_NR = :as_voyagenr 
			AND  POC_EST.PCN = :ai_pcn 
			AND	POC_EST.PORT_CODE = :as_portcode
			AND POC_TASKS_CONFIG_PC.PURPOSE_CODE = POC_EST.PURPOSE_CODE
			AND	POC_TASKS_CONFIG_PC.PC_NR = :ii_pcnr
			AND VOYAGES.VESSEL_NR = POC_EST.VESSEL_NR
            	AND VOYAGES.VOYAGE_NR = POC_EST.VOYAGE_NR
			AND ((VOYAGES.VOYAGE_TYPE <> 2 AND POC_TASKS_CONFIG_PC.TASK_USE_TCOUT = 0) OR (VOYAGES.VOYAGE_TYPE = 2))		
			AND 	POC_TASKS_CONFIG_PC.TASK_ID NOT IN 
					(SELECT POC_TASK_LIST.TASK_ID 
						FROM POC_TASK_LIST
						WHERE POC_TASK_LIST.VESSEL_NR = :al_vesselnr
								AND POC_TASK_LIST.VOYAGE_NR = :as_voyagenr
								AND POC_TASK_LIST.PORT_CODE = :as_portcode
								AND POC_TASK_LIST.PCN = :ai_pcn)
			);
				
end if

if sqlca.sqlcode=-1 then
	rollback;
	MessageBox("Error", "Error in updating task list.")
else
	commit;
end if

dw_task_list.retrieve(al_vesselnr,as_voyagenr ) 

wf_select_task_node( as_portcode, ai_pcn )

end subroutine

private subroutine wf_select_task_node (string as_portcode, integer al_pcn);/********************************************************************
wf_select_task_node
   <DESC>Expands task list for the selected port of call  </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Public 	</ACCESS>
   <ARGS>as_portcode: Port Code
			al_pcn: PCN number
	</ARGS>
   <USAGE>When a POC is selected.</USAGE>
********************************************************************/
long	ll_row, ll_rows

ll_rows =  dw_task_list.rowcount( ) 

ll_row = dw_task_list.find("poc_task_list_pcn =" + string(al_pcn) + " and poc_task_list_port_code='" + as_portcode + "'",1,ll_rows )

if ll_row > 0  then
	dw_task_list.expand( ll_row, 1)
	dw_task_list.scrolltorow(ll_row)
end if



end subroutine

private function integer _send_finished_voyage_alert ();/********************************************************************
  _send_finished_voyage_alert
   <DESC> Sends alert by email to demurrage responsible about voyage that was finished</DESC>
   <RETURN> 
		 c#return.failure : email was not sent
		 c#return.success : email was sent
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		anv_mail: outgoing email object reference
   </ARGS>
   <USAGE>	
	Used the first time the user finishes a voyage
	</USAGE>
   <HISTORY>
   	Date			CR-Ref      Author   Comments
		23/05/12		CR2253 		ZSW001
   	26/11/14 	CR3761      AZX004   Fix forget to enter the vessel number in the automated email.
   </HISTORY>
********************************************************************/

string	ls_mail_subject, ls_mail_message, ls_errorMessage, ls_emailaddress[]
string	ls_vessel_name, ls_vessel_ref, ls_creator, ls_voyage_nr
long		ll_selected, ll_rownum, ll_count, ll_vessel_nr
mt_n_outgoingmail 	lnv_mail

mt_n_datastore		lds_demurrage_email

SELECT VESSEL_REF_NR, VESSEL_NAME
INTO :ls_vessel_ref,:ls_vessel_name
FROM VESSELS
WHERE VESSEL_NR = :ii_vessel_nr;

ll_selected = dw_proc_pcnc.getselectedrow(0)
if 0 < ll_selected and ll_selected <= dw_proc_pcnc.rowcount() then
	ll_vessel_nr = dw_proc_pcnc.getitemnumber(ll_selected, "proceed_vessel_nr")
	ls_voyage_nr = dw_proc_pcnc.getitemstring(ll_selected, "proceed_voyage_nr")
	
	lds_demurrage_email = create mt_n_datastore
	lds_demurrage_email.dataobject = "d_sq_gr_demurrage_email"
	lds_demurrage_email.settransobject(sqlca)
	if lds_demurrage_email.retrieve(ll_vessel_nr, ls_voyage_nr) > 0 then
		ls_emailaddress = lds_demurrage_email.object.offices_email_adr_demurrage.primary
	end if
	destroy lds_demurrage_email
end if

ll_count = upperbound(ls_emailaddress)
if ll_count <= 0 then return c#return.Failure

ls_creator = uo_global.is_userid

ls_mail_message = "Vessel: " + ls_vessel_name + " , Voyage: " + is_previous_voyage + " was finished by " + ls_creator

ls_mail_subject = "(auto message from Tramos)  Vessel: " + ls_vessel_ref + "  , Voyage: " + is_previous_voyage + " was finished by " + ls_creator

for ll_rownum = 1 to ll_count
	if not isnull(ls_emailaddress[ll_rownum]) and trim(ls_emailaddress[ll_rownum]) <> "" then
		lnv_mail = create mt_n_outgoingmail
		
		if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_emailaddress[ll_rownum] , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then	
			destroy lnv_mail
			return c#return.failure
		end if
			
		if lnv_mail.of_sendmail(ls_errorMessage) = -1 then
			destroy lnv_mail
			return c#return.failure
		end if
		
		destroy( lnv_mail)
	end if
next

return c#return.success

end function

private function integer _checkdatesbetweenports (long al_vessel_nr);/********************************************************************
  _checkdatesbetweenports()
	
<DESC>   
	checks port call against the next to see if any mismatch within the dates
</DESC>
<RETURN>
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failure
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	al_vessel_nr: Vessel reference already available
</ARGS>
<USAGE>
	Copied block from the complex validatation located on 'Update' button.  This is only called from the click
	event of 'Finish Voyage' button.  Therefore this is curently Stand-alone.  Recommendations includes
	optimizing the validation located in the click event of the update button and usage of the mt framework
	error service instead of messagebox(). (due to standards already used on this window regarding the
	messagebox())
</USAGE>
********************************************************************/

u_check_functions		lnv_check
string 					ls_message=""
long 						ll_vessel_nr
integer 					li_validdate
datetime					ldt_arrival, ldt_departure

ldt_arrival 	= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemdatetime(1,"port_arr_dt")
ldt_departure 	= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemdatetime(1,"port_dept_dt")

/* check poc dates  every time a port of call is saved we check an interval of +/- 60 days */
lnv_check = create u_check_functions
if isNull(ldt_departure) then
	li_validdate = lnv_check.uf_check_poc_arr_dates(al_vessel_nr,datetime(relativedate(date(ldt_arrival), -60)), datetime(relativedate(date(ldt_arrival), 60)), ls_message)
else
	li_validdate = lnv_check.uf_check_poc_arr_dates(al_vessel_nr,datetime(relativedate(date(ldt_arrival), -60)), datetime(relativedate(date(ldt_departure), 60)), ls_message)
end if
destroy lnv_check

if li_validdate=c#return.Failure then
	ls_message="Registration of Port of Call periods failed.~r~n"+ls_message+"~r~n~r~n"
	// _addmessage( this.classdefinition, "wf_checkdates()", "Error! " + ls_message + " It is critical you correct the error before finishing the voyage." , "user error message")
	messagebox("Error!", ls_message + "It is critical you correct the error before finishing the voyage.",StopSign!)
	return c#return.Failure
end if

return c#return.Success

end function

private function boolean _checkestpocbefore ();/***********************************************************************************************
   _checkestpocbefore
   <DESC>	When move an estimated POC to an actual POC this function will find if
				there are one or more estimated POC before current POC.	</DESC>
   <RETURN>	boolean:
				true: There is one or more estimated POC before current row.
				false:There isn't estimated POC before current row.	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	When move an estimated POC to actual POC, this function will work.	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	07/07/2011 CR2410       WWG004        First Version
   </HISTORY>
**************************************************************************************************/

long 		ll_selectedrow, ll_rowcount, ll_find_est
boolean	lb_return

ll_selectedrow  = dw_proc_pcnc.getselectedrow(0)
ll_rowcount = dw_proc_pcnc.rowcount()

if ll_selectedrow > 1 then
	ll_find_est = dw_proc_pcnc.find("compute_1 = 'Estimated'", ll_selectedrow - 1, 1)
end if

lb_return = (ll_find_est > 0)

return lb_return
end function

public function integer wf_validate (integer ai_type);/********************************************************************
   wf_validate
   <DESC>	check arrival date and departure date	</DESC>
   <RETURN>	integer:
            <LI> c#return.success, ok
            <LI> c#return.failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_type: ii_ACTUAL or ii_ESTIMATED
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
   	15/07/2011 CR2410       ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_columnprefix, ls_voyage_nr, ls_purpose
long		ll_count
boolean	lb_doschedule
datetime	ldt_orig_arr, ldt_prim_arr, ldt_orig_ber, ldt_prim_ber, ldt_orig_dep, ldt_prim_dep
datetime	ldt_min_est_arr_dt, ldt_max_arr_dt, ldt_max_dept_dt, ldt_previous_max_dt, ldt_proceed_dt

mt_u_datawindow	ldw_currentpoc

choose case ai_type
	case ii_ACTUAL
		ldw_currentpoc = tab_poc.tabpage_act.dw_port_of_call
		
		ls_voyage_nr = ldw_currentpoc.getitemstring(1, "voyage_nr")
		
		//Get min Estimated POC arrival date
		SELECT MIN(POC_EST.PORT_ARR_DT)
		  INTO :ldt_min_est_arr_dt
		  FROM POC_EST
		 WHERE (POC_EST.VESSEL_NR = :il_vessel_nr) AND
				 (POC_EST.VOYAGE_NR = :ls_voyage_nr);
	case ii_ESTIMATED
		ldw_currentpoc  = tab_poc.tabpage_est.dw_port_of_call_est
		ls_columnprefix = "poc_est_"
		
		ls_voyage_nr = ldw_currentpoc.getitemstring(1, ls_columnprefix + "voyage_nr")
		
		//Get max POC arrival date and max POC departure date
		SELECT MAX(POC.PORT_ARR_DT),
		       MAX(POC.PORT_DEPT_DT)
		  INTO :ldt_max_arr_dt,
		       :ldt_max_dept_dt
		  FROM POC
		 WHERE (POC.VESSEL_NR = :il_vessel_nr) AND
				 (POC.VOYAGE_NR = :ls_voyage_nr);
	case else
		return c#return.failure
end choose

if rb_1.checked then
	lb_doschedule = inv_autoschedule.of_cal_currentport(dw_proc_pcnc, ldw_currentpoc, ai_type)
	if isnull(lb_doschedule) then return c#return.failure
end if

ib_doschedule = lb_doschedule

ls_purpose 	 = ldw_currentpoc.getitemstring(1, ls_columnprefix + "purpose_code")

//get departure date, berthing date and arrival date
ldt_orig_dep = ldw_currentpoc.getitemdatetime(1, ls_columnprefix + "port_dept_dt", primary!, true)
ldt_prim_dep = ldw_currentpoc.getitemdatetime(1, ls_columnprefix + "port_dept_dt", primary!, false)

ldt_orig_ber = ldw_currentpoc.getitemdatetime(1, ls_columnprefix + "port_berthing_time", primary!, true)
ldt_prim_ber = ldw_currentpoc.getitemdatetime(1, ls_columnprefix + "port_berthing_time", primary!, false)

ldt_orig_arr = ldw_currentpoc.getitemdatetime(1, ls_columnprefix + "port_arr_dt", primary!, true)
ldt_prim_arr = ldw_currentpoc.getitemdatetime(1, ls_columnprefix + "port_arr_dt", primary!, false)

if not ib_doschedule then
	if not inv_autoschedule.ib_etd_manual then
		if ldw_currentpoc.getitemstatus(1, ls_columnprefix + "port_dept_dt", primary!) = datamodified! then
			if ldw_currentpoc.getitemstatus(1, 0, primary!) = newmodified! then
				setnull(ldt_orig_dep)
			end if
			ldw_currentpoc.setitem(1, ls_columnprefix + "port_dept_dt", ldt_orig_dep)
		end if
	end if
end if

//Get proceeding date
ldt_proceed_dt = dw_proc_pcnc.getitemdatetime(dw_proc_pcnc.getselectedrow(0), "proceed_proc_date")

//Insure ETA > ETA, ETB, ETD of Previous Port

SELECT COUNT(*)
  INTO :ll_count
  FROM POC_EST, PROCEED
 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
		 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
		 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
		 PROCEED.PCN = POC_EST.PCN AND
		 PROCEED.VESSEL_NR = :il_vessel_nr AND
		 Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND		//modified as Joana's suggestion
		(PROCEED.VOYAGE_NR = :ls_voyage_nr AND DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_proceed_dt) > 0 OR PROCEED.VOYAGE_NR < :ls_voyage_nr) AND
		 (DATEDIFF(Second, IsNull(IsNull(POC_EST.PORT_DEPT_DT, POC_EST.PORT_BERTHING_TIME), POC_EST.PORT_ARR_DT), :ldt_prim_arr) < 0);

if ll_count <= 0 then
	SELECT COUNT(*)
	  INTO :ll_count
	  FROM POC, PROCEED
	 WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
	       PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
	       PROCEED.PORT_CODE = POC.PORT_CODE AND
	       PROCEED.PCN = POC.PCN AND
	       PROCEED.VESSEL_NR = :il_vessel_nr AND
		  Convert(int, Left(PROCEED.VOYAGE_NR, 2)) < 90 AND	//modified as Joana's suggestion
		  (PROCEED.VOYAGE_NR = :ls_voyage_nr AND DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_proceed_dt) > 0 OR PROCEED.VOYAGE_NR < :ls_voyage_nr) AND
		  (DATEDIFF(Second, IsNull(IsNull(POC.PORT_DEPT_DT, POC.PORT_BERTHING_TIME), POC.PORT_ARR_DT), :ldt_prim_arr) < 0);
end if

if ll_count > 0 then
	messagebox("Validation", "There is already other port of call(s) registered at a time later than " + string(ldt_prim_arr) + ". Data is not updated.")
	ldw_currentpoc.post setfocus()
	return c#return.failure
end if

//Insure ETA < ETB < ETD
if not isnull(ldt_prim_ber) and ldt_prim_ber <= ldt_prim_arr then
	messagebox("Validation", "Berthing date must be after the arrival date.~r~nData is not updated.")
	ldw_currentpoc.post setfocus()
	return c#return.failure
end if

if not isnull(ldt_prim_dep) then
	if ldt_prim_dep <= ldt_prim_arr then
		messagebox("Validation", "Departure date must be after the arrival date.~r~nData is not updated.")
		ldw_currentpoc.post setfocus()
		return c#return.failure
	elseif not isnull(ldt_prim_ber) and ldt_prim_dep <= ldt_prim_ber then
		messagebox("Validation", "Departure date must be after the berthing date.~r~nData is not updated.")
		ldw_currentpoc.post setfocus()
		return c#return.failure
	end if
end if

//CR2535 & 2536 End added by ZSW001 on 01/11/2011

choose case ai_type
	case ii_ACTUAL
		//checks if arrival date is smaller than the last estimated arrival date
		if ldt_prim_arr > ldt_min_est_arr_dt and not lb_doschedule then
			messagebox("Validation", "The next estimated port of call has an arrival date earlier than~r~nthis arrival date. ~r~nData is not updated.")
			ldw_currentpoc.post setfocus()
			return c#return.failure
		end if
	case ii_ESTIMATED
		//checks arrival and departure date agains the last POC
		if ldt_prim_arr < ldt_max_arr_dt or ldt_prim_arr < ldt_max_dept_dt then
			messagebox("Validation", "There exists actual Port of Call after this estimated Port of Call. ~r~nData is not updated.")
			ldw_currentpoc.post setfocus()
			return c#return.failure
		end if
		
		if not ib_doschedule then
			//Checks POC dates against proceeding
			SELECT Count(POC_EST.VESSEL_NR)
			  INTO :ll_count
			  FROM POC_EST, PROCEED
			 WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
					 PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
					 PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
					 PROCEED.PCN = POC_EST.PCN AND
					 PROCEED.VESSEL_NR = :il_vessel_nr AND
					 PROCEED.VOYAGE_NR = :ls_voyage_nr AND
					(DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_proceed_dt) < 0 AND DATEDIFF(Second, POC_EST.PORT_ARR_DT, :ldt_prim_arr) > 0 OR
					  DATEDIFF(Second, PROCEED.PROC_DATE, :ldt_proceed_dt) > 0 AND DATEDIFF(Second, POC_EST.PORT_ARR_DT, :ldt_prim_arr) < 0);
			
			if ll_count > 0 then
				messagebox("Validation", "The arrival dates of the port calls must follow the sequence in Proceeding.~r~nData is not updated.")
				return c#return.failure
			end if
		end if
end choose

return c#return.success

end function

public subroutine wf_goto_est_cargo (integer ai_poc_type);/********************************************************************
   wf_goto_est_cargo
   <DESC> Open estimated cargo grades window </DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_poc_type: 0 Actual; 1 Estimated
   </ARGS>
   <USAGE> When click b_estcargo button </USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	01/09/2011   2531         ZSW001       First Version
   </HISTORY>
********************************************************************/

long	ll_row

s_poc_est_cargo	lstr_poc_est_cargo

/* set structure to send data to estimated cargo grades window */
ll_row = dw_proc_pcnc.getselectedrow(0)
if ll_row <= 0 then return

lstr_poc_est_cargo.sl_vessel_nr = ii_vessel_nr
lstr_poc_est_cargo.ss_voyage_nr = dw_proc_pcnc.getitemstring(ll_row, "proceed_voyage_nr")
lstr_poc_est_cargo.ss_port_code = dw_proc_pcnc.getitemstring(ll_row, "proceed_port_code")
lstr_poc_est_cargo.si_pcn       = dw_proc_pcnc.getitemnumber(ll_row, "proceed_pcn")
lstr_poc_est_cargo.si_poc_type  = ai_poc_type

/* open estimated cargo grades window with parameters */
openwithparm(w_choose_est_cargo, lstr_poc_est_cargo)

end subroutine

private function integer __setstps_display (long al_row);/********************************************************************
   __setstps_display
   <DESC>	keep the steaming time and portstay not changed by compute filed.	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, 1 ok
            <LI> c#return.Failure,  -1 failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE>	new est poc ,
	         cancel a poc ,
				changed est poc's ETA	
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       			Author             Comments
   	02/02/12   CR2535&CR2536           TTY004        First Version
   </HISTORY>
********************************************************************/
decimal{2} ldc_steamingtime, ldc_portstay

if al_row < 1 then return c#return.failure
ldc_steamingtime = this.tab_poc.tabpage_est.dw_port_of_call_est.getitemdecimal(al_row, 'compute_steamingtime')
ldc_portstay = this.tab_poc.tabpage_est.dw_port_of_call_est.getitemdecimal(al_row, 'compute_portstay')
this.tab_poc.tabpage_est.dw_port_of_call_est.setItem(1, 'poc_steamingtime', ldc_steamingtime)
this.tab_poc.tabpage_est.dw_port_of_call_est.setItem(1, 'poc_portstay', ldc_portstay)
this.tab_poc.tabpage_est.dw_port_of_call_est.setItemStatus(1, 'poc_steamingtime', primary!, notmodified!)
this.tab_poc.tabpage_est.dw_port_of_call_est.setItemStatus(1, 'poc_portstay', primary!, notmodified!)
return c#return.success
end function

private function integer _generateestimates (integer ai_vesselnr, string as_voyagenr);/********************************************************************
   _generateestimates( /*integer ai_vesselnr*/, /*string as_voyagenr */)
	
<DESC>   
	When triggered generates an estimated transaction for current voyage & vessel and
	sends to AX.  If a problem occurs, animationtime email should be sent to a designated user!
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok transaction generated ok, or email of failure sent ok
		<LI> -1, Failure - transaction failed and email generation failed.
</RETURN>
<ACCESS> 
	Private
</ACCESS>
<ARGS>   
	ai_vesselnr: Vessel Number
	as_voyagenr: Voyage Number
</ARGS>
<USAGE>
	Called from a button
</USAGE>
********************************************************************/
string	ls_mail_subject, ls_mail_message, ls_errorMessage
string	ls_vessel_name, ls_finresp, ls_vessel_ref, ls_creator
integer li_retval
s_axestimatesvars lstr_app
n_axestimationcontrol	lnv_est
mt_n_outgoingmail 	lnv_mail

lnv_est = create n_axestimationcontrol
lstr_app.b_client = true
lstr_app.i_clientvesselnr = ai_vesselnr
lstr_app.s_clientvoyagenr = as_voyagenr
lstr_app.s_infomessage = "Successfully generated estimated transaction for finished voyage and sent onto AX."
li_retval = lnv_est.of_start(lstr_app)
destroy lnv_est

if li_retval=c#return.Failure then
	/* obtains vessel data */
	SELECT VESSEL_REF_NR, VESSEL_NAME, VESSEL_DEM_ANALYST
	INTO :ls_vessel_ref, :ls_vessel_name,  :ls_finresp 
	FROM VESSELS
	WHERE VESSEL_NR = :ii_vessel_nr
	commit;
	
	/* TODO: hard coded user name until req. specs are defined */
	ls_finresp="AGL027"

	ls_creator = uo_global.is_userid
	ls_mail_message = "Vessel: " + ls_vessel_name + " , Voyage: " + is_previous_voyage + ", Update of voyage estimates failed!"
	ls_mail_subject = "(auto message from Tramos)  Vessel: " + ls_vessel_ref + "  , Voyage: " + is_previous_voyage + " finished by " + ls_creator + ".  Voyage estimates for this voyage need to be re-sent from Tramos manually through the Finance Control Panel."
	
	if lstr_app.s_returnmessage<>"" then
		ls_mail_subject += " (" + lstr_app.s_returnmessage + ")"
	end if
	
	ls_finresp += C#EMAIL.DOMAIN
	
	lnv_mail = create mt_n_outgoingmail
	if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_finresp , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then	
		destroy (lnv_mail)
		return c#return.failure
	end if
	if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
		destroy( lnv_mail)
		return c#return.failure
	end if
	destroy( lnv_mail)
else
	/* nothing to do! */
end if	

return c#return.Success
end function

private function integer _checkpreviousvoyage (long al_vesselnr, string as_voyagenr, long al_voyage_type);/******************************************************************** 
 _checkpreviousvoyage
   <DESC> check the previous voyage exists or not when to finish a voyage </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_vesselnr
		as_voyagenr
		al_voyage_type
   </ARGS>
   <USAGE> 	A vessel can have voyages starting with XX001 and XX500 (hired by pool), or XX001-XX and XX500-XX (hired out)
				Validation:
					1. The first voyage of the year has to be XX001, XX001-01, XX500 or XX500-01
					2. A voyage number is not valid. Ex: XX000, XX500-00, XX001-00.
					3.	A voyage cannot be finished if its previous voyage does not exist.
					
				</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	14/03/2013 CR3049         LGX001        First Version
	26/03/2015	CR3948		CCY018		Fix a bug.				
   </HISTORY>
********************************************************************/

string ls_previous_voyage_nr, ls_voyage_sn, ls_errormessage
boolean lb_success

ls_voyage_sn = trim(mid(as_voyagenr, 3, 5))

lb_success = true

//First voyage of a year
if ls_voyage_sn = "50001" or ls_voyage_sn = "500"  or ls_voyage_sn = "001" or ls_voyage_sn = "00101" then return c#return.Success

if al_voyage_type = 2 then
	//xx000-xx or xxxxx-00
	if left(ls_voyage_sn, 3) = "000" or right(ls_voyage_sn, 2) = "00"  then lb_success = false
else
	//xx000
	if left(ls_voyage_sn, 3) = "000" then lb_success = false
end if
if not lb_success then
	messagebox("Validation", as_voyagenr + " is an invalid voyage number" + ".")
	return c#return.failure
end if

// get previous voyage
SELECT MAX(VOYAGE_NR)
INTO :ls_previous_voyage_nr
FROM VOYAGES
WHERE VOYAGES.VESSEL_NR = :al_vesselnr
AND	LEFT(VOYAGES.VOYAGE_NR, 2) = LEFT(:as_voyagenr, 2)
AND   VOYAGES.VOYAGE_NR < :as_voyagenr;

if isnull(ls_previous_voyage_nr) then ls_previous_voyage_nr = ""

lb_success = true
if ls_previous_voyage_nr = "" then
	lb_success = false
	ls_errormessage = "The voyage cannot be finished because the previous voyage does not exist."
else
	if len(ls_previous_voyage_nr)  = len(as_voyagenr) then
		if  long(as_voyagenr) - long(ls_previous_voyage_nr) <> 1 then 
			if al_voyage_type = 2 and right(as_voyagenr, 2) = "01" and long(left(as_voyagenr, 5)) - long(left(ls_previous_voyage_nr, 5)) = 1 then
			else
				lb_success = false		
			end if
		end if
	elseif len(ls_previous_voyage_nr) <> len(as_voyagenr) then
		if al_voyage_type = 2 then
			//ls_previous_voyage_nr 13002 / as_voyagenr 13003-01
			if not (long(left(as_voyagenr, 5)) - long(ls_previous_voyage_nr) = 1 and right(as_voyagenr, 2) = "01") then lb_success = false
		else
			//ls_previous_voyage_nr 13002-09 / as_voyagenr 13003
			if not (long(as_voyagenr) - long(left(ls_previous_voyage_nr, 5)) = 1) then lb_success = false
		end if		
	end if
	if not lb_success then
		if al_voyage_type = 2 then
			if right(as_voyagenr, 2) = "01" then
				ls_previous_voyage_nr = ""
			else
				ls_previous_voyage_nr = string(long(as_voyagenr) - 1, "00000-00")		
			end if
		else
			ls_previous_voyage_nr = string(long(as_voyagenr) - 1, "00000")
		end if
		
		if ls_previous_voyage_nr <> "" then ls_previous_voyage_nr = ls_previous_voyage_nr + " "
		ls_errormessage = "The voyage cannot be finished because the previous voyage " + ls_previous_voyage_nr + "does not exist. "
	end if
end if
 
if not lb_success then
	messagebox("Validation", ls_errormessage)
	return c#return.Failure
end if

return c#return.Success
end function

public subroutine wf_set_ownermatter (string as_voyagenr, string as_portcode, integer ai_pcn);/********************************************************************
   wf_set_ownermatter
   <OBJECT>		When new poc or poc est					</OBJECT>
   <USAGE>		Insert ownermatter tabpage data		</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		09/01/2014		CR3085		WWG004		First Version
   </HISTORY>
********************************************************************/

string ls_agentdetail, ls_departmentname
long   ll_insertrow_info, ll_insertrow_list, ll_department_count, ll_getrow

mt_u_datawindow ldw_department_info, ldw_department_list
mt_n_datastore  lds_department_config

lds_department_config = create mt_n_datastore
lds_department_config.dataobject = "d_sq_gr_department_config"

lds_department_config.settransobject(sqlca)
lds_department_config.retrieve()

lds_department_config.setfilter("enabled = 1")
lds_department_config.filter()

ldw_department_info	= w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info
ldw_department_list	= w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list

//Get the default AGENT_DETAIL
SELECT PROFIT_C.DEFAULT_AGENT_DETAILS
  INTO :ls_agentdetail
  FROM PROFIT_C, VESSELS  
 WHERE VESSELS.PC_NR = PROFIT_C.PC_NR 
   AND VESSELS.VESSEL_NR = :ii_vessel_nr
   AND PROFIT_C.USE_DEFAULT_AGENTDETAILS_COMMENT = 1;

//Set department info data
ll_insertrow_info = ldw_department_info.insertrow(0)

ldw_department_info.setitem(ll_insertrow_info, "vessel_nr", ii_vessel_nr)
ldw_department_info.setitem(ll_insertrow_info, "voyage_nr", as_voyagenr)
ldw_department_info.setitem(ll_insertrow_info, "port_code", as_portcode)
ldw_department_info.setitem(ll_insertrow_info, "pcn", ai_pcn)
ldw_department_info.setitem(ll_insertrow_info, "urgent_delivery", 0)
ldw_department_info.setitem(ll_insertrow_info, "responsible_psm", '')
ldw_department_info.setitem(ll_insertrow_info, "same_agent", 0)
ldw_department_info.setitem(ll_insertrow_info, "agent_details", ls_agentdetail)
ldw_department_info.setitem(ll_insertrow_info, "data_changed", 0)

//Set department list data
ll_department_count = lds_department_config.rowcount()
for ll_getrow = 1 to ll_department_count
	ls_departmentname = lds_department_config.getitemstring(ll_getrow, "department_name")
	
	ll_insertrow_list = ldw_department_list.insertrow(0)
	ldw_department_list.setitem(ll_insertrow_list, "department_name", ls_departmentname)
	ldw_department_list.setitem(ll_insertrow_list, "enabled", 0)
	ldw_department_list.setitem(ll_insertrow_list, "contact1", '')
	ldw_department_list.setitem(ll_insertrow_list, "contact2", '')
	ldw_department_list.setitem(ll_insertrow_list, "pallets", 0)
	ldw_department_list.setitem(ll_insertrow_list, "weight", 0)
	ldw_department_list.setitem(ll_insertrow_list, "update_date", now())
	ldw_department_list.setitem(ll_insertrow_list, "update_by", uo_global.is_userid)
next

w_port_of_call.tab_poc.tabpage_owners_matters.visible = true
w_port_of_call.tab_poc.tabpage_owners_matters.cb_update.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.cb_print.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.cb_cancel.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.gb_activites.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.st_contacts.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.visible = false
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.visible = false

end subroutine

public subroutine wf_init_departments (long al_ownid);/********************************************************************
   wf_init_departments
   <OBJECT>	Init department	</OBJECT>
   <USAGE>	Retrieve POC		</USAGE>
   <ALSO>				</ALSO>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		07/01/2014		CR3085		WWG004		First Version
   </HISTORY>
********************************************************************/

long   ll_getrow, ll_rowcount, ll_find, ll_insertrow
string ls_department

mt_u_datawindow ldw_matter_list
mt_n_datastore  lds_department_config, lds_department

lds_department_config = create mt_n_datastore
lds_department_config.dataobject = "d_sq_gr_department_config"
lds_department_config.settransobject(sqlca)
lds_department_config.retrieve()

lds_department_config.setfilter("enabled = 1")
lds_department_config.filter()

lds_department = create mt_n_datastore
lds_department.dataobject = "d_sq_gr_ownermatter"
lds_department.settransobject(sqlca)
lds_department.retrieve(al_ownid)

ll_rowcount = lds_department_config.rowcount()

ldw_matter_list = w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list

for ll_getrow = 1 to ll_rowcount
	ls_department	= lds_department_config.getitemstring(ll_getrow, "department_name")
	ll_find = lds_department.find("department_name = '" + ls_department + "'", 1, lds_department.rowcount())
	if ll_find > 0 then
		//the department exist
		continue
	else
		//the department not exist(New department), then insert a row.
		ll_insertrow = lds_department.insertrow(0)
				
		lds_department.setitem(ll_insertrow, "owner_department_id", al_ownid)
		lds_department.setitem(ll_insertrow, "department_name", ls_department)
		lds_department.setitem(ll_insertrow, "update_date", now())
		lds_department.setitem(ll_insertrow, "update_by", uo_global.is_userid)
	end if
next

if lds_department.update() = 1 then
	commit using sqlca;
end if

ldw_matter_list.retrieve(al_ownid)
end subroutine

public subroutine wf_insert_portdetailhistory (datastore ds_port_detail_history, string as_new, string as_old, string as_port_code, datetime adt_today, string as_type);	/********************************************************************
   wf_insert_portdetailhistory()
   <DESC>	When update attachment,insert change history	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	cb_update_port_details.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/09/14	CR3758        KSH092   First Version
   </HISTORY>
********************************************************************/
int li_row
	
li_row = ds_port_detail_history.insertrow(0)
if isnull(as_new) then as_new = ''
if isnull(as_old) then as_old = ''
ds_port_detail_history.setitem(li_row,'port_code',as_port_code)
if as_type = 'details' then
	ds_port_detail_history.setitem(li_row,'description','Port detail changed. See text below.')
	ds_port_detail_history.setitem(li_row,'detail_new',as_new)
	ds_port_detail_history.setitem(li_row,'detail_old',as_old)
elseif as_type = 'delete' then
	ds_port_detail_history.setitem(li_row,'description','Delete attachment: ' + as_new)
end if

	
ds_port_detail_history.setitem(li_row,'updated_date',adt_today)
ds_port_detail_history.setitem(li_row,'updated_by',uo_global.gos_userid)
end subroutine

public function boolean wf_is_first_poc (integer ai_vessel_nr, datetime adt_arrival, string as_voyage);/********************************************************************
   wf_is_first_poc
   <DESC>
		Finds out if a port of call is the first port of call for a specific vessel.
   </DESC>
   <RETURN>boolean:</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		adt_arrival
		as_voyage
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10/12/14 CR3813            CCY018        First Version
   </HISTORY>
********************************************************************/

/* Declare variables */
integer 	li_number_of_rows
string		ls_found_voyage

/* Count port of calls for the vessel */
SELECT COUNT(PCN) 
	INTO :li_number_of_rows
	FROM 
	(
		SELECT POC.PCN FROM POC
			WHERE POC.VESSEL_NR = :ai_vessel_nr
			AND POC.PORT_ARR_DT < :adt_arrival
		UNION ALL
		SELECT PCN FROM POC_EST
		WHERE POC_EST.VESSEL_NR = :ai_vessel_nr
		AND POC_EST.PORT_ARR_DT < :adt_arrival
	) A;

if li_number_of_rows > 0 then
	/* This is not the first POC for this vessel */
	return false
else
	/* It could be the first portcall, if the vessel is delivered on a TC-IN contract
		and then goes directly on TC-OUT, there will be two portcalls with the same
		dates, and therefore we need to find out if there are more than one portcall with this date */
	SELECT COUNT(PCN) 
		INTO :li_number_of_rows
		FROM
		(
			SELECT POC.PCN FROM POC
				WHERE POC.VESSEL_NR = :ai_vessel_nr
				AND POC.PORT_ARR_DT < :adt_arrival
				AND POC.VOYAGE_NR <> :as_voyage
			UNION ALL
			SELECT PCN FROM POC_EST
				WHERE POC_EST.VESSEL_NR = :ai_vessel_nr
				AND POC_EST.PORT_ARR_DT < :adt_arrival
				AND  POC_EST.VOYAGE_NR <> :as_voyage
		) A;
	choose case li_number_of_rows
		case 0     // this is the first port
			return true
		case 1	// this is an update to first port or create of a new port with same arrival date					
			SELECT VOYAGE_NR
				INTO :ls_found_voyage
				FROM
			(
				SELECT VOYAGE_NR FROM POC
					WHERE POC.VESSEL_NR = :ai_vessel_nr
					AND POC.PORT_ARR_DT < :adt_arrival
					AND POC.VOYAGE_NR <> :as_voyage
				UNION ALL
				SELECT VOYAGE_NR FROM POC_EST
					WHERE POC_EST.VESSEL_NR = :ai_vessel_nr
					AND POC_EST.PORT_ARR_DT < :adt_arrival
					AND  POC_EST.VOYAGE_NR <> :as_voyage
			) A;
			if len(trim(as_voyage)) = len(trim(ls_found_voyage)) then
				MessageBox("Validation Error", "You can't have a more than one portcall with the same arrival dates on same voyage type")
				return true
			elseif len(trim(as_voyage)) = 5  then
				/* der are two rows, and this one is the first */
				return true
			else
				return false
			end if
		case else
			MessageBox("Validation Error", "There can't be more than 2 portcalls with the same arrival date")
			return true
	end choose	
end if
end function

public function integer wf_check_portbunker (ref mt_u_datawindow adw_poc, string as_bunker_type, decimal ad_arr_bunker, decimal ad_dept_bunker, string as_pre_voyage, string as_pre_port, string as_next_voyage, string as_next_port, ref string as_setcol, ref string as_message);/********************************************************************
   wf_check_portbunker
   <DESC>check bunker data when updatting est poc in w_port_of_call	
	copy from u_check_functions.of_check_portbunker
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_poc
		as_bunker_type
		ad_arr_bunker
		ad_dept_bunker
		as_pre_voyage
		as_pre_port
		as_next_voyage
		as_next_port
		as_setcol
		as_message
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10/12/14 CR3813        CCY018        First Version
   </HISTORY>
********************************************************************/

decimal {4}		ld_curr_arrival, ld_curr_departure, ld_curr_ordered
decimal {4}		ld_org_departure
integer 			li_vesselnr
string ls_arr_col, ls_dept_col, ls_order_col, ls_portcode, ls_voyagenr

if adw_poc.rowcount() < 1 then return c#return.Success

ls_portcode = adw_poc.getitemstring(1, "poc_est_port_code")

ls_arr_col  = "poc_est_arr_"  + as_bunker_type
ls_order_col = "ordered_" + as_bunker_type
ls_dept_col = "poc_est_dept_" + as_bunker_type

ls_voyagenr       = adw_poc.getitemstring(1, "poc_est_voyage_nr")
ls_portcode			= adw_poc.getitemstring(1, "poc_est_port_code")

ld_curr_arrival   = adw_poc.getitemdecimal(1, ls_arr_col)
ld_curr_ordered		= adw_poc.getitemdecimal(1, ls_order_col)
ld_curr_departure	= adw_poc.getitemdecimal(1, ls_dept_col)

if isnull(ld_curr_arrival)   then ld_curr_arrival = 0
if isnull(ld_curr_ordered)    then ld_curr_ordered = 0
if isnull(ld_curr_departure) then ld_curr_departure = 0

ld_org_departure = adw_poc.getitemdecimal(1, ls_dept_col, primary!, true)
if isnull(ld_org_departure) then ld_org_departure = 0
if (ld_curr_arrival + ld_curr_ordered) < ld_curr_departure then
	as_setcol = ls_arr_col
	if ld_curr_departure <> ld_org_departure then
		as_setcol = ls_dept_col
	end if 	
	 as_message = "Arrival + Ordered bunker in port '" + ls_portcode + "' is lower than the departure."
	 return c#return.Failure
end if

// Previous port departure bunker data 
if (len(as_pre_voyage) > 0) and (ad_dept_bunker < ld_curr_arrival) then
	as_setcol = ls_arr_col
	if as_pre_voyage = ls_voyagenr then
		as_message = "Arrival bunker in port '" + ls_portcode + "' is higher than the departure from previous port '" + as_pre_port + "'."
	else
		as_message = "Arrival bunker in port '" + ls_portcode + "' is higher than last departure from previous voyage."
	end if
	
	return c#return.Failure
	
// Next port arrival bunker data 	
elseif (len(as_next_voyage) > 0 )and (ad_arr_bunker > ld_curr_departure) then
	as_setcol = ls_dept_col
	if as_next_voyage = ls_voyagenr then
		as_message = "Departure bunker in port '" + ls_portcode + "' is lower than the arrival from next port '" + as_next_port + "'."
	else
		as_message = "Departure bunker in port '" + ls_portcode + "' is lower than first arrival from next voyage."
	end if
	
	return c#return.Failure
end if	

return c#return.Success
end function

public function integer wf_check_portbunker (ref mt_u_datawindow adw_poc, ref string as_setcol, ref string as_message);/********************************************************************
   wf_check_portbunker
   <DESC> check bunker data when updatting act poc in w_port_of_call	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_poc
		as_setcol
		as_message
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10/12/14 CR3813        CCY018        First Version
   </HISTORY>
********************************************************************/
integer 			li_vesselnr
string 			ls_pre_voyage, ls_next_voyage, ls_pre_port, ls_next_port, ls_portcode, ls_voyagenr
datetime 		ldt_arrival_date
decimal {4} 	ld_arr_hfo, ld_arr_do, ld_arr_go, ld_arr_lshfo
decimal {4} 	ld_dept_hfo, ld_dept_do, ld_dept_go, ld_dept_lshfo

if adw_poc.rowcount() < 1 then return c#return.Success

li_vesselnr = adw_poc.getitemnumber(1, "poc_est_vessel_nr")
ls_voyagenr = adw_poc.getitemstring(1, "poc_est_voyage_nr")
ls_portcode = adw_poc.getitemstring(1, "poc_est_port_code")
ldt_arrival_date = adw_poc.getitemdatetime(1, "poc_est_port_arr_dt", primary!, true)

//Get previous port bunker data 
SELECT TOP 1 DEPT_HFO, DEPT_DO, DEPT_GO, DEPT_LSHFO, VOYAGE_NR, PORT_CODE
INTO  :ld_dept_hfo, :ld_dept_do, :ld_dept_go, :ld_dept_lshfo, :ls_pre_voyage, :ls_pre_port
FROM
(
	SELECT isnull(POC.DEPT_HFO,0) AS DEPT_HFO,
		isnull(POC.DEPT_DO,0) AS DEPT_DO,
		isnull(POC.DEPT_GO,0) AS DEPT_GO,
		isnull(POC.DEPT_LSHFO,0) AS DEPT_LSHFO,
		POC.VOYAGE_NR,
		POC.PORT_CODE,
		POC.PORT_ARR_DT	
	FROM  POC 
	WHERE POC.VESSEL_NR = :li_vesselnr 
	AND POC.VOYAGE_NR   <= :ls_voyagenr
	AND POC.PORT_ARR_DT = (SELECT MAX(POC.PORT_ARR_DT)
									FROM POC
									WHERE POC.VESSEL_NR = :li_vesselnr AND
											POC.VOYAGE_NR <= :ls_voyagenr AND
											DATEDIFF(Second, POC.PORT_ARR_DT, :ldt_arrival_date) > 0)
	UNION ALL
	SELECT isnull(POC_EST.DEPT_HFO,0),
		isnull(POC_EST.DEPT_DO,0),
		isnull(POC_EST.DEPT_GO,0),
		isnull(POC_EST.DEPT_LSHFO,0),
		POC_EST.VOYAGE_NR,
		POC_EST.PORT_CODE,
		POC_EST.PORT_ARR_DT	
	FROM  POC_EST 
	WHERE POC_EST.VESSEL_NR = :li_vesselnr 
	AND POC_EST.VOYAGE_NR   <= :ls_voyagenr
	AND POC_EST.PORT_ARR_DT = (SELECT MAX(POC_EST.PORT_ARR_DT)
									FROM POC_EST
									WHERE POC_EST.VESSEL_NR = :li_vesselnr AND
											POC_EST.VOYAGE_NR <= :ls_voyagenr AND
											DATEDIFF(Second, POC_EST.PORT_ARR_DT, :ldt_arrival_date) > 0)
	) A ORDER BY A.PORT_ARR_DT DESC;
											
if sqlca.sqlcode < 0 then
	as_message = "Select bunker data error: " + sqlca.sqlerrtext
	return c#return.Failure
end if
	
	//Get next port bunker data 
SELECT TOP 1 ARR_HFO, ARR_DO, ARR_GO, ARR_LSHFO, VOYAGE_NR, PORT_CODE
INTO  :ld_arr_hfo, :ld_arr_do, :ld_arr_go, :ld_arr_lshfo, :ls_next_voyage, :ls_next_port	  
FROM
(
	SELECT isnull( POC.ARR_HFO,0) AS ARR_HFO,
		isnull(POC.ARR_DO,0) AS ARR_DO,
		isnull(POC.ARR_GO,0) AS ARR_GO,
		isnull(POC.ARR_LSHFO,0) AS ARR_LSHFO,
		POC.VOYAGE_NR,
		POC.PORT_CODE,
		POC.PORT_ARR_DT
	FROM  POC 
	WHERE POC.VESSEL_NR = :li_vesselnr 
	AND POC.VOYAGE_NR  >= :ls_voyagenr
	AND POC.PORT_ARR_DT = (SELECT MIN(POC.PORT_ARR_DT)
									FROM POC
									WHERE POC.VESSEL_NR = :li_vesselnr AND
											POC.VOYAGE_NR >= :ls_voyagenr AND
											DATEDIFF(Second, POC.PORT_ARR_DT, :ldt_arrival_date) < 0)
	UNION ALL
	SELECT isnull( POC_EST.ARR_HFO,0),
		isnull(POC_EST.ARR_DO,0),
		isnull(POC_EST.ARR_GO,0),
		isnull(POC_EST.ARR_LSHFO,0),
		POC_EST.VOYAGE_NR,
		POC_EST.PORT_CODE,
		POC_EST.PORT_ARR_DT
	FROM  POC_EST 
	WHERE POC_EST.VESSEL_NR = :li_vesselnr 
	AND POC_EST.VOYAGE_NR  >= :ls_voyagenr
	AND POC_EST.PORT_ARR_DT = (SELECT MIN(POC_EST.PORT_ARR_DT)
									FROM POC_EST
									WHERE POC_EST.VESSEL_NR = :li_vesselnr AND
											POC_EST.VOYAGE_NR >= :ls_voyagenr AND
											DATEDIFF(Second, POC_EST.PORT_ARR_DT, :ldt_arrival_date) < 0)
	) A ORDER BY PORT_ARR_DT ASC;
											
if sqlca.sqlcode < 0 then
	as_message = "Select bunker data error: " + sqlca.sqlerrtext
	return c#return.Failure
end if

if wf_check_portbunker(adw_poc, "HFO", ld_arr_hfo, ld_dept_hfo, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port, as_setcol, as_message) = c#return.Failure then return c#return.Failure
if wf_check_portbunker(adw_poc, "DO",  ld_arr_do,  ld_dept_do, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port,  as_setcol, as_message) = c#return.Failure then return c#return.Failure
if wf_check_portbunker(adw_poc, "GO", 	ld_arr_go, 	ld_dept_go, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port,  as_setcol, as_message) = c#return.Failure then return c#return.Failure
if wf_check_portbunker(adw_poc, "LSHFO", ld_arr_lshfo, ld_dept_lshfo, ls_pre_voyage, ls_pre_port, ls_next_voyage, ls_next_port, as_setcol, as_message) = c#return.Failure then return c#return.Failure

return c#return.Success


end function

public subroutine wf_calculate_tce (integer ai_type);/********************************************************************
   wf_calculate_tce
   <DESC></DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		adw_poc
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29/12/14 CR3752            CCY018        First Version
   </HISTORY>
********************************************************************/

integer li_vessel_nr
long ll_count_tce, ll_calc_id
string ls_voyage_nr
decimal{2} ld_fixture_pr_day, ld_est_act_pr_day, ld_pre_fixture_pr_day, ld_profit_tce_pr_day
integer li_rtn
mt_u_datawindow ldw_poc
pointer lp_oldpointer

if ai_type = 0 then
	ldw_poc = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call
else
	ldw_poc = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est
end if

if ldw_poc.rowcount() < 1 then return

if ai_type = 0 then
	li_vessel_nr = ldw_poc.getitemnumber(1, "vessel_nr")
	ls_voyage_nr = ldw_poc.getitemstring(1, "voyage_nr")
else
	li_vessel_nr = ldw_poc.getitemnumber(1, "poc_est_vessel_nr")
	ls_voyage_nr = ldw_poc.getitemstring(1, "poc_est_voyage_nr")
end if

SELECT CAL_CALC_ID INTO :ll_calc_id FROM VOYAGES WHERE VESSEL_NR = :li_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
if isnull(ll_calc_id) or ll_calc_id <= 1 then
	messagebox("Information", "This voyage is not allocated to a calculation!")		
	return
end if

lp_oldpointer = setpointer(HourGlass!)

mt_n_datastore lds_calcports
lds_calcports = create mt_n_datastore
lds_calcports.dataobject = "d_sp_tb_get_poc_tce"
lds_calcports.settrans(sqlca)
li_rtn = lds_calcports.retrieve(li_vessel_nr, ls_voyage_nr,0,ld_fixture_pr_day, ld_est_act_pr_day)
if li_rtn > 0 then
	ld_pre_fixture_pr_day = ldw_poc.getitemdecimal( 1, "fixture_profit_margin_pr_day")
	if isnull(ld_pre_fixture_pr_day) then ld_pre_fixture_pr_day = 0
	
	ld_fixture_pr_day = lds_calcports.getitemdecimal( 1, "fixture_pr_day")
	ld_est_act_pr_day = lds_calcports.getitemdecimal( 1, "est_act_pr_day")
	
	ldw_poc.setitem(1, "est_act_profit_margin_pr_day", ld_est_act_pr_day)
	ldw_poc.setitemstatus(1, "est_act_profit_margin_pr_day", Primary!, NotModified! )
	if ld_pre_fixture_pr_day <> ld_fixture_pr_day then
		ldw_poc.setitem(1, "fixture_profit_margin_pr_day", ld_fixture_pr_day)
		ldw_poc.setitemstatus(1, "fixture_profit_margin_pr_day", Primary!, NotModified! )
	end if
	
	SELECT ISNULL(TCE_PR_DAY_IN_POC, 0) INTO :ld_profit_tce_pr_day
	FROM PROFIT_C, VESSELS
	WHERE VESSELS.PC_NR = PROFIT_C.PC_NR
	AND VESSELS.VESSEL_NR = :li_vessel_nr;
	
	ldw_poc.setitem(1, "profit_c_tce_pr_day_in_poc", ld_profit_tce_pr_day)
	ldw_poc.setitemstatus(1, "profit_c_tce_pr_day_in_poc", Primary!, NotModified! )
end if

destroy lds_calcports

setpointer(lp_oldpointer)


end subroutine

public function boolean wf_check_bunker (integer ai_vessel_nr, string as_voyage_nr, ref string as_message);/********************************************************************
   wf_check_bunker_est( /*integer ai_vessel_nr*/, /*string as_voyage_nr*/, /*ref string as_message */)
   <DESC>	Check if the registration of bunker (gas, diesel, fuel, lshfo) is logic,
 						this means that we check if a vessel has more bunker loaded when it
						arrives to a port than it had when if left the last port.
				copy from u_check_functions.uf_check_bunker
	</DESC>
   <RETURN></RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		ai_vessel_nr
		as_voyage_nr
		as_message
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/01/15 	CR3813        CCY018        First Version
   </HISTORY>
********************************************************************/

decimal {4} 	ld_arrival_fuel, ld_departure_fuel, ld_arrival_diesel, ld_departure_diesel, ld_arrival_gas, ld_departure_gas, ld_arrival_lshfo, ld_departure_lshfo 
decimal {4}	ld_lifted_fuel, ld_lifted_diesel, ld_lifted_gas, ld_last_hfo , ld_last_do , ld_last_go, ld_lifted_lshfo, ld_last_lshfofo, ld_last_lshfo
decimal{4}	ld_pre_dept_hfo, ld_pre_dept_do, ld_pre_dept_go, ld_pre_dept_lshfo, ld_first_arr_hfo, ld_first_arr_do, ld_first_arr_go, ld_first_arr_lshfo
integer 		li_number_of_poc, li_row, li_act_est
string ls_last_voyage, ls_portcode, ls_pre_portcode, ls_first_portcode
datastore lds_poc

lds_poc = create datastore 
lds_poc.dataobject = "d_sp_tb_poc_check_bunker"
lds_poc.settransobject( sqlca)
li_number_of_poc = lds_poc.retrieve(ai_vessel_nr, as_voyage_nr)

if li_number_of_poc = 0 then 
	destroy lds_poc
	return true
end if

for li_row = 1 to li_number_of_poc
	ld_arrival_fuel = lds_poc.getitemnumber( li_row, "arr_hfo")
	ld_arrival_diesel = lds_poc.getitemnumber( li_row, "arr_do")
	ld_arrival_gas = lds_poc.getitemnumber( li_row, "arr_go")
	ld_arrival_lshfo = lds_poc.getitemnumber( li_row, "arr_lshfo")
	ld_departure_fuel = lds_poc.getitemnumber( li_row, "dept_hfo")
	ld_departure_diesel = lds_poc.getitemnumber( li_row, "dept_do")
	ld_departure_gas = lds_poc.getitemnumber( li_row, "dept_go")
	ld_departure_lshfo = lds_poc.getitemnumber( li_row, "dept_lshfo")
	ld_lifted_fuel = lds_poc.getitemnumber( li_row, "lift_hfo")
	ld_lifted_diesel = lds_poc.getitemnumber( li_row, "lift_do")
	ld_lifted_gas = lds_poc.getitemnumber( li_row, "lift_go")
	ld_lifted_lshfo = lds_poc.getitemnumber( li_row, "lift_lshfo")
	ls_portcode = lds_poc.getitemstring(li_row, "port_code")
	li_act_est = lds_poc.getitemnumber( li_row, "act_est")
	
	if li_row = 1 then
		ld_first_arr_hfo = ld_arrival_fuel
		ld_first_arr_do = ld_first_arr_do
		ld_first_arr_go = ld_arrival_gas
		ld_first_arr_lshfo = ld_arrival_lshfo
		ls_first_portcode = ls_portcode
	end if
	
	if li_row > 1 then
		if ld_pre_dept_hfo < ld_arrival_fuel or ld_pre_dept_do < ld_arrival_diesel or ld_pre_dept_go < ld_arrival_gas or ld_pre_dept_lshfo < ld_arrival_lshfo then
			as_message = "Arrival bunker in port '" + ls_portcode + "' is higher than the departure from previous port '" + ls_pre_portcode + "'."
			destroy lds_poc
			return false
		end if
	end if
	
	if ld_arrival_fuel + ld_lifted_fuel < ld_departure_fuel or ld_arrival_diesel + ld_lifted_diesel < ld_departure_diesel &
		or ld_arrival_gas + ld_lifted_gas < ld_departure_gas or ld_arrival_lshfo + ld_lifted_lshfo < ld_departure_lshfo then
		if li_act_est = 1 then
			as_message = "Arrival + Lifted bunker in port '" + ls_portcode + "' is lower than the departure."
		else
			as_message = "Arrival + Ordered bunker in port '" + ls_portcode + "' is lower than the departure."
		end if
		
		destroy lds_poc
		return false
	end if
	
	ld_pre_dept_hfo = ld_departure_fuel
	ld_pre_dept_do = ld_departure_diesel
	ld_pre_dept_go = ld_departure_gas
	ld_pre_dept_lshfo = ld_departure_lshfo
	ls_pre_portcode = ls_portcode
next

// Make check against last departure on previous voyage
SELECT MAX(VOYAGE_NR)
INTO :ls_last_voyage
FROM VOYAGES
WHERE VOYAGES.VESSEL_NR = :ai_vessel_nr 
	AND VOYAGES.VOYAGE_NR < :as_voyage_nr;


if len(ls_last_voyage) > 0 then
	SELECT TOP 1 ISNULL(DEPT_HFO,0), ISNULL(DEPT_DO,0), ISNULL(DEPT_GO,0), ISNULL(DEPT_LSHFO,0)
	INTO :ld_last_hfo , :ld_last_do , :ld_last_go, :ld_last_lshfo
	FROM
	(
	SELECT POC.PORT_ARR_DT, isnull(POC.DEPT_HFO,0) DEPT_HFO, isnull(POC.DEPT_DO,0) DEPT_DO, isnull(POC.DEPT_GO,0) DEPT_GO, isnull(POC.DEPT_LSHFO,0) DEPT_LSHFO
	FROM POC
	WHERE POC.VESSEL_NR = :ai_vessel_nr AND
				POC.VOYAGE_NR = :ls_last_voyage  AND
				POC.PORT_ARR_DT =  (SELECT MAX(POC.PORT_ARR_DT)
								  				 FROM POC
								   				WHERE POC.VESSEL_NR = :ai_vessel_nr 
								         		AND POC.VOYAGE_NR = :ls_last_voyage)
	UNION ALL
	SELECT POC_EST.PORT_ARR_DT, isnull(POC_EST.DEPT_HFO,0), isnull(POC_EST.DEPT_DO,0), isnull(POC_EST.DEPT_GO,0), isnull(POC_EST.DEPT_LSHFO,0)
	FROM POC_EST
	WHERE POC_EST.VESSEL_NR = :ai_vessel_nr AND
				POC_EST.VOYAGE_NR = :ls_last_voyage  AND
				POC_EST.PORT_ARR_DT = (SELECT MAX(POC_EST.PORT_ARR_DT)
														FROM POC_EST
														WHERE POC_EST.VESSEL_NR = :ai_vessel_nr 
														AND POC_EST.VOYAGE_NR = :ls_last_voyage)
	) A ORDER BY A.PORT_ARR_DT DESC;
			
	if ld_last_hfo < ld_first_arr_hfo or ld_last_do <  ld_first_arr_do  &
	or ld_last_go	< ld_first_arr_go or ld_last_lshfo <  ld_first_arr_lshfo then 
		as_message = "Arrival bunker in port '" + ls_first_portcode + "' is higher than last departure previous voyage."
		destroy lds_poc
		return false						
	end if
								
end if

destroy lds_poc
return true
end function

public subroutine wf_insert_vesseldetailhistory (datastore ds_vessel_detail_history, string as_new, string as_old, long ad_vessel_nr, datetime adt_today, string as_type);/********************************************************************
  wf_insert_vesseldetailhistory()
   <DESC>	When update attachment,insert change history	</DESC>
   <RETURN>	integer:
           
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	cb_update_vessel_text.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		09-07-2015	CR3923        KSH092   First Version
   </HISTORY>
********************************************************************/
int li_row
	
li_row = ds_vessel_detail_history.insertrow(0)
if isnull(as_new) then as_new = ''
if isnull(as_old) then as_old = ''
ds_vessel_detail_history.setitem(li_row,'vessel_nr',ad_vessel_nr)
if as_type = 'details' then
	ds_vessel_detail_history.setitem(li_row,'description','Vessel detail changed. See text below.')
	ds_vessel_detail_history.setitem(li_row,'detail_new',as_new)
	ds_vessel_detail_history.setitem(li_row,'detail_old',as_old)
elseif as_type = 'delete' then
	ds_vessel_detail_history.setitem(li_row,'description','Delete attachment: ' + as_new)
end if

	
ds_vessel_detail_history.setitem(li_row,'updated_date',adt_today)
ds_vessel_detail_history.setitem(li_row,'updated_by',uo_global.gos_userid)
end subroutine

public subroutine wf_check_laytime (long al_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn);/********************************************************************
   wf_check_laytime
   <DESC></DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		al_vessel_nr,
		as_voyage_nr,
		as_port_code,
		ai_pcn
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	09/08/16 CR4111            HHX010        First Version
   </HISTORY>
********************************************************************/
long ll_i
integer li_chart_nr, li_claim_nr
n_calc_demurrage lnv_calc_demurrage
mt_n_datastore lds_temp

lds_temp = create mt_n_datastore
lds_temp.dataobject = 'd_sq_gr_laytime_statements'
lds_temp.settransobject(sqlca)
lds_temp.retrieve(al_vessel_nr,as_voyage_nr,as_port_code,ai_pcn)
 
/* Group deduction */
DELETE FROM GROUP_DEDUCTIONS 
WHERE VESSEL_NR = :al_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :as_port_code AND
		PCN = :ai_pcn ;
/* Laytime deduction */
DELETE FROM LAY_DEDUCTIONS 
WHERE VESSEL_NR = :al_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :as_port_code AND
		PCN = :ai_pcn ;
/* Laytime Statements */
DELETE FROM LAYTIME_STATEMENTS 
WHERE VESSEL_NR = :al_vessel_nr AND
		VOYAGE_NR = :as_voyage_nr AND
		PORT_CODE = :as_port_code AND
		PCN = :ai_pcn ;
 
for ll_i = 1 to lds_temp.rowcount()
	li_chart_nr = lds_temp.object.chart_nr[ll_i]
	SELECT CLAIM_NR  INTO :li_claim_nr 
	FROM DEM_DES_CLAIMS 
	WHERE VESSEL_NR = :al_vessel_nr  AND 
			 VOYAGE_NR = :as_voyage_nr AND 
			 CHART_NR = :li_chart_nr; 	 
	lnv_calc_demurrage.of_recalc_demurrage(al_vessel_nr, as_voyage_nr, as_port_code, li_chart_nr, li_claim_nr)  
next

destroy lds_temp  
end subroutine

public function integer wf_update_timebar (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   wf_update_timebar
   <DESC></DESC>
   <RETURN>
		c#return.failure : -1
		c#return.success : 1
   <ACCESS> </ACCESS>
   <ARGS>
		al_vessel_nr,
		as_voyage_nr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20/10/16 CR4279            HHX010        First Version
   </HISTORY>
********************************************************************/
date ldt_discharge_date

setnull(ldt_discharge_date)
				
SELECT dbo.FN_GET_POCDISCHARGEDATE(:al_vessel_nr, :as_voyage_nr)
INTO :ldt_discharge_date
FROM SYSTEM_OPTION
USING SQLCA;
	
UPDATE CLAIMS
SET    DISCHARGE_DATE = :ldt_discharge_date, TIMEBAR_DATE = DATEADD(dd, TIMEBAR_DAYS, :ldt_discharge_date),
		 NOTICE_DATE    = DATEADD(dd, NOTICE_DAYS, :ldt_discharge_date)
WHERE  VESSEL_NR = :al_vessel_nr AND VOYAGE_NR = :as_voyage_nr;

if sqlca.sqlcode <> 0 then
	rollback;
	return c#return.failure
end if
commit;

return c#return.success
end function

public subroutine wf_set_voyage_alert_status (string as_act_est, long al_row);/********************************************************************
   wf_set_voyage_alert_status
   <DESC>		</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
		as_act_est
		al_row
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

string ls_portcode
datetime ldt_arr_date, ldt_berth_date, ldt_dept_date

if isnull(al_row) or al_row < 1 then return

ls_portcode = dw_proc_pcnc.getitemstring(al_row, "proceed_port_code")

if as_act_est = "ACT" then
	ldt_arr_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_port_arr_dt")
	ldt_berth_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_port_berthing_time")
	ldt_dept_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_port_dept_dt")
else
	ldt_arr_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_est_port_arr_dt")
	ldt_berth_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_est_port_berthing_time")
	ldt_dept_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_est_port_dept_dt")
end if

if dw_voyage_alert.retrieve(ls_portcode, ldt_arr_date, ldt_berth_date, ldt_dept_date) > 0 then
	dw_proc_pcnc.setitem(al_row, "voyage_alert", 1)
else
	dw_proc_pcnc.setitem(al_row, "voyage_alert", 0)
end if



end subroutine

public subroutine wf_show_voyage_alert (long al_row);/********************************************************************
   wf_show_voyage_alert
   <DESC>	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS>  </ACCESS>
   <ARGS>
		al_row
		xpos
		ypos
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27/03/17		CR4414		CCY018		First Version
   </HISTORY>
********************************************************************/

string ls_port_code
long ll_row, ll_rowheight, ll_dwheight, ll_maxheight, ll_winheight
datetime ldt_arr_date, ldt_est_arr_date, ldt_berth_date, ldt_est_berth_date, ldt_dept_date, ldt_est_dept_date

ls_port_code = dw_proc_pcnc.getitemstring(al_row, "proceed_port_code")
ldt_arr_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_port_arr_dt")
ldt_est_arr_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_est_port_arr_dt")
ldt_berth_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_port_berthing_time")
ldt_est_berth_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_est_port_berthing_time")
ldt_dept_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_port_dept_dt")
ldt_est_dept_date = dw_proc_pcnc.getitemdatetime(al_row, "poc_est_port_dept_dt")
if isnull(ldt_arr_date) then ldt_arr_date = ldt_est_arr_date
if isnull(ldt_berth_date) then ldt_berth_date = ldt_est_berth_date
if isnull(ldt_dept_date) then ldt_dept_date = ldt_est_dept_date

dw_voyage_alert.reset()
if dw_voyage_alert.retrieve(ls_port_code, ldt_arr_date, ldt_berth_date, ldt_dept_date) < 1 then
	dw_voyage_alert.visible = false
	return
end if

ll_dwheight = 84
ll_winheight = this.workspaceheight()
//set dw height
for ll_row = 1 to dw_voyage_alert.rowcount()
	ll_rowheight = long(dw_voyage_alert.describe("evaluate('rowheight()', " + string(ll_row) + " )"))
	if ll_dwheight + ll_rowheight < ll_winheight then
		if ll_row <= 4 then ll_dwheight += ll_rowheight
	end if
	
	if ll_rowheight > ll_maxheight then ll_maxheight = ll_rowheight
next

if ll_maxheight > ll_dwheight then ll_dwheight = ll_maxheight
if ll_dwheight > ll_winheight then ll_dwheight = ll_winheight
if dw_voyage_alert.y  + ll_dwheight > ll_winheight then dw_voyage_alert.y  = ll_winheight - ll_dwheight
dw_voyage_alert.height = ll_dwheight
dw_voyage_alert.width = 2322

dw_voyage_alert.visible = true
dw_voyage_alert.setfocus()

end subroutine

public function integer wf_interim_jump_new_dev (long al_vessel_nr, string as_voyage_nr);/********************************************************************
   wf_interim_jump_new_dev
   <DESC></DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		al_vessel_nr,
		as_voyage_nr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/08/17		CR4221		HHX010		First Version
   </HISTORY>
********************************************************************/
long ll_count, ll_return 
string ls_text
u_jump_claims luo_jump_claims

ll_return = 2

SELECT count(*) into :ll_count
FROM CAL_EXPANDED_ITINERARY, CAL_CAIO , POC, VOYAGES
WHERE CAL_EXPANDED_ITINERARY.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID 
	AND CAL_EXPANDED_ITINERARY.MERGED_PORT_CODE = CAL_CAIO.PORT_CODE
	AND CAL_EXPANDED_ITINERARY.ITINERARY_NO = CAL_CAIO.CAL_CAIO_ITINERARY_NUMBER
	AND CAL_EXPANDED_ITINERARY.CAL_CALC_ID = VOYAGES.CAL_CALC_ID 
	AND CAL_EXPANDED_ITINERARY.MERGED_PORT_CODE = POC.PORT_CODE 
	AND CAL_EXPANDED_ITINERARY.MERGED_PURPOSE_CODE = POC.PURPOSE_CODE 
	AND CAL_EXPANDED_ITINERARY.PCN = POC.PCN 
	AND POC.VESSEL_NR = VOYAGES.VESSEL_NR
	AND POC.VOYAGE_NR = VOYAGES.VOYAGE_NR
	AND POC.VESSEL_NR = :al_vessel_nr
	AND POC.VOYAGE_NR = :as_voyage_nr
	AND CAL_CAIO.CAL_CAIO_INTERIM_PORT = 1;
	
if ll_count >= 1 then 
	ls_text = 'You have used an interim port.~r~n~r~nDo you want to create a Deviation claim now?'

	ll_return =  messagebox('Question', ls_text, Question!, YesNoCancel!, 1) 
	if ll_return = 1 then 
		luo_jump_claims = CREATE u_jump_claims
		luo_jump_claims.of_createDevClaim(al_vessel_nr, as_voyage_nr) 
		DESTROY luo_jump_claims
	end if
end if

return ll_return
end function

public function integer wf_check_firstlast_interim (string as_voyage_nr);/********************************************************************
   wf_check_firstlast_interim
   <DESC></DESC>
   <RETURN>integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		as_voyage_nr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	26/09/16 CR4221           HHX010        First Version
   </HISTORY>
********************************************************************/
datastore lds_port
long ll_loop, ll_portcount, li_interim_port
string ls_purpose, ls_errtext
n_messagebox lnv_msgbox

ls_errtext = "You cannot finish the voyage, when an interim port is first or last port."

lds_port = create datastore
lds_port.dataobject = dw_proc_pcnc.dataobject
lds_port.settransobject(sqlca)

dw_proc_pcnc.rowscopy(1, dw_proc_pcnc.rowcount(), Primary!, lds_port, 1,  Primary!)

lds_port.setfilter("proceed_voyage_nr = '" + as_voyage_nr + "'")
lds_port.filter()

ll_portcount = lds_port.rowcount()
for  ll_loop = 1 to ll_portcount
	ls_purpose = lds_port.object.compute_purpose[ll_loop]
	li_interim_port = lds_port.object.interim_port[ll_loop]
	if ls_purpose = 'L' then
		if li_interim_port = 1 then
		   lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_GENERAL_ERROR, ls_errtext, this, 'Finish Voyage')
		   destroy lds_port
		   return c#return.Failure 
		else
			exit
		end if
	end if
next 

for  ll_loop = ll_portcount to 1 step -1
	ls_purpose = lds_port.object.compute_purpose[ll_loop]
	li_interim_port = lds_port.object.interim_port[ll_loop]
	if ls_purpose = 'D' then
		if li_interim_port = 1 then
		   lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_GENERAL_ERROR, ls_errtext, this, 'Finish Voyage')
		   destroy lds_port
		   return c#return.Failure
		else
			exit
		end if
	end if
next 

destroy lds_port
return c#return.Success



end function

event ue_delete;call super::ue_delete;
/********************************************************************
   w_port_of_call.ue_delete
   <DESC>	Delete Estimated or Actual POC </DESC>
   <RETURN>	</RETURN>
   <ACCESS>	Public</ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	Use this event to delete a POC	</USAGE>
********************************************************************/

int 			li_vessel_nr, li_pcn, li_count
long			ll_rows, ll_ownermatter_count
boolean		lb_doschedule, lb_success
string 		ls_voyage_nr, ls_port_code, ls_msg
Datetime 	ldt_arr_dt
datetime 	ldt_null;setNull(ldt_null)
n_bunker_posting_control	lnv_bunkerControl
n_ownersmatter_sendmail		lnv_own_sendemail

lnv_own_sendemail = CREATE n_ownersmatter_sendmail

ll_rows = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.RowCount()


if ll_rows > 0 then
	//***************
	//delete Actual POC
	//***************
	
	//CR2510 Modified by LGX001 on 05/09/2011. 
	li_vessel_nr =  w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemNumber(1,"vessel_nr") 
	
	ls_voyage_nr = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemString(1,"voyage_nr")
	ls_port_code = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemString(1,"port_code")
	li_pcn = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemNumber(1,"pcn")
	SELECT count(*) INTO :ll_ownermatter_count
	  FROM OWNER_MATTERS_DEPARTMENT 
	 WHERE VESSEL_NR = :li_vessel_nr 
		AND VOYAGE_NR = :ls_voyage_nr
		AND PORT_CODE = :ls_port_code
		AND PCN = :li_pcn
		AND (RESPONSIBLE_PSM <> '' AND RESPONSIBLE_PSM <> NULL);

	if ll_ownermatter_count > 0 then
		ls_msg = "This will also delete the information stored on the Owners Matters tab page.~r~n"
	else
		ls_msg = ''
	end if	
	
	SELECT count(*) INTO :li_count
	FROM CARGO
	WHERE VESSEL_NR = :li_vessel_nr AND
			VOYAGE_NR = :ls_voyage_nr AND
			PORT_CODE = :ls_port_code AND
			PCN       = :li_pcn;
	Commit;
	IF (li_count > 0) THEN
		MessageBox("Delete","You cannot delete this Port Of Call as there exists a Cargo.")
		return
	END IF	
	
	SELECT count(*) INTO :li_count
	FROM BP_DETAILS, 
         NTC_PAYMENT  
	WHERE NTC_PAYMENT.PAYMENT_ID = BP_DETAILS.PAYMENT_ID AND
			BP_DETAILS.VESSEL_NR = :li_vessel_nr AND
			BP_DETAILS.VOYAGE_NR = :ls_voyage_nr AND
			BP_DETAILS.PORT_CODE = :ls_port_code AND
			BP_DETAILS.PCN       = :li_pcn AND 
			NTC_PAYMENT.PAYMENT_STATUS > 2;
	Commit;
	IF (li_count > 0) THEN
		MessageBox("Delete","You cannot delete this Port Of Call as there exist Bunker Purchases that are attached to Payments.")
		return
	END IF
	
	SELECT count(*) INTO :li_count
	FROM BP_DETAILS 
	WHERE BP_DETAILS.VESSEL_NR = :li_vessel_nr AND
			BP_DETAILS.VOYAGE_NR = :ls_voyage_nr AND
			BP_DETAILS.PORT_CODE = :ls_port_code AND
			BP_DETAILS.PCN       = :li_pcn ;
	Commit;
	IF (li_count > 0) THEN
		MessageBox("Delete","You cannot delete this Port Of Call as there exist Bunker Purchases.")
		return
	END IF

	IF MessageBox("Delete","You are about to DELETE a Port Of Call.~r~n" + ls_msg + &
								  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN return

	SELECT count(*) INTO :li_count
	FROM LAYTIME_STATEMENTS 
	WHERE LAYTIME_STATEMENTS.VESSEL_NR = :li_vessel_nr AND
			LAYTIME_STATEMENTS.VOYAGE_NR = :ls_voyage_nr AND
			LAYTIME_STATEMENTS.PORT_CODE = :ls_port_code AND
			LAYTIME_STATEMENTS.PCN = :li_pcn ;
	Commit;
	IF (li_count > 0) THEN
		IF MessageBox("Delete","Entered laytime will be lost.~r~n~r~n" + &
								  "Do you want to continue?", Exclamation!, YesNo!, 2) = 2 THEN return
								  
		wf_check_laytime(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	END IF

	/* Additional Non Cargo Agents */
	DELETE FROM TRA_NCAG
	WHERE VESSEL_NR = :li_vessel_nr AND
			VOYAGE_NR = :ls_voyage_nr AND
			PORT_CODE = :ls_port_code AND
			PCN       = :li_pcn;

	//Delete tasks
	DELETE 
	FROM POC_TASK_LIST
	WHERE VESSEL_NR = :li_vessel_nr
		AND VOYAGE_NR = :ls_voyage_nr
		AND PORT_CODE = :ls_port_code
		AND PCN = :li_pcn;
	
	if ib_new = false then
		//Send email of owner attach
		lnv_own_sendemail.of_send_email(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
		destroy lnv_own_sendemail
		
		//Delete table OWNER_MATTERS_DEPARTMENT
			DELETE
			 FROM OWNER_MATTERS_DEPARTMENT
			WHERE VESSEL_NR = :li_vessel_nr
			  AND VOYAGE_NR = :ls_voyage_nr
			  AND PORT_CODE = :ls_port_code
			  AND PCN = :li_pcn;
	else
		w_port_of_call.tab_poc.tabpage_owners_matters.enabled = true
		w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.reset()
		w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.reset()	
	end if
	
	//CR2535 & 2536 Begin added by ZSW001 on 29/10/2011
	if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.DeleteRow(0) = 1 then
		if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Update() = 1 then
			lb_success = true
			if dw_proc_pcnc.find("compute_1 = 'Estimated'", dw_proc_pcnc.getselectedrow(0) + 1, dw_proc_pcnc.rowcount() + 1) > 0 then
				lb_doschedule = inv_autoschedule.of_checkautoschedule()
				if lb_doschedule then
					lb_success = inv_autoschedule.of_calculateschedule(dw_proc_pcnc, tab_poc.tabpage_act.dw_port_of_call, ii_ACTUAL, rb_only_this_year.checked)
				end if
			end if
			if lb_success then
				dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_port_arr_dt", ldt_null)
				dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_port_arr_dt", ldt_null )
				dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_purpose_code", "")
				dw_proc_pcnc.accepttext( )
				dw_proc_pcnc.groupCalc()
				
				Commit;
				
				w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.reset()
				lnv_bunkerControl = create n_bunker_posting_control
				lnv_bunkerControl.of_portofcall_deleted( li_vessel_nr, ls_voyage_nr )
				destroy lnv_bunkerControl
				
				w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.of_init(ls_port_code, ii_vessel_nr, long(ls_voyage_nr), li_pcn)
			end if
		end if
	end if
	
	if not lb_success then
		rollback;
		messageBox("Error", "Delete failed.")
		return
	end if
	//CR2535 & 2536 End added by ZSW001 on 29/10/2011
else 
	
	ll_rows = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.RowCount()
	if ll_rows > 0 then
		//******************
		//delete Estimated POC
		//******************
	
		//CR2510 Modified by LGX001 on 05/09/2011.
		li_vessel_nr = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.GetItemNumber(1,"poc_est_vessel_nr") 
		ls_voyage_nr = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.GetItemString(1,"poc_est_voyage_nr")
		ls_port_code = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.GetItemString(1,"poc_est_port_code")
		li_pcn		 = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.GetItemNumber(1,"poc_est_pcn")
		
		SELECT count(*) INTO :li_count
		FROM BP_DETAILS 
		WHERE BP_DETAILS.VESSEL_NR = :li_vessel_nr AND
				BP_DETAILS.VOYAGE_NR = :ls_voyage_nr AND
				BP_DETAILS.PORT_CODE = :ls_port_code AND
				BP_DETAILS.PCN       = :li_pcn ;
		
		if li_count > 0 then
			messagebox("Delete","You cannot delete this Estimated Port Of Call as there exist Bunker Purchases.")
			return
		end if
		
		SELECT count(*) INTO :ll_ownermatter_count
		  FROM OWNER_MATTERS_DEPARTMENT 
		 WHERE VESSEL_NR = :li_vessel_nr 
			AND VOYAGE_NR = :ls_voyage_nr
			AND PORT_CODE = :ls_port_code
			AND PCN = :li_pcn
			AND (RESPONSIBLE_PSM <> '' AND RESPONSIBLE_PSM <> NULL);
			
			if ll_ownermatter_count > 0 then
				ls_msg = "This will also delete the information stored on the Owners Matters tab page.~r~n"
			else
				ls_msg = ''
			end if
		IF MessageBox("Delete", "You are about to DELETE an Estimated Port Of Call.~r~n" + ls_msg +&
						  "Are you sure you want to continue?", Question!, YesNo!, 2) = 2 THEN return
	
			//Delete tasks
			DELETE 
			FROM POC_TASK_LIST
			WHERE VESSEL_NR = :li_vessel_nr
				AND VOYAGE_NR = :ls_voyage_nr
				AND PORT_CODE = :ls_port_code
				AND PCN = :li_pcn;
		
		if ib_new = false then
			//Send email of owner attach
			lnv_own_sendemail.of_send_email(li_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
			destroy lnv_own_sendemail
					
			//Delete table OWNER_MATTERS_DEPARTMENT
			DELETE
			 FROM OWNER_MATTERS_DEPARTMENT
			WHERE VESSEL_NR = :li_vessel_nr
			  AND VOYAGE_NR = :ls_voyage_nr
			  AND PORT_CODE = :ls_port_code
			  AND PCN = :li_pcn;
		else
			w_port_of_call.tab_poc.tabpage_owners_matters.enabled = true
			w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.reset()
			w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.reset()
		end if
		
		//CR2535 & 2536 Begin added by ZSW001 on 29/10/2011
		if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.DeleteRow(0) = 1 then
			if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Update() = 1 then
				lb_success = true
				if dw_proc_pcnc.find("compute_1 = 'Estimated'", dw_proc_pcnc.getselectedrow(0) + 1, dw_proc_pcnc.rowcount() + 1) > 0 then
					lb_doschedule = inv_autoschedule.of_checkautoschedule()
					if lb_doschedule then
						lb_success = inv_autoschedule.of_calculateschedule(dw_proc_pcnc, tab_poc.tabpage_est.dw_port_of_call_est, ii_ESTIMATED, rb_only_this_year.checked)
					end if
				end if
				if lb_success then
					dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_port_arr_dt", ldt_null)
					dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_port_arr_dt", ldt_null )
					dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_purpose_code", "")
					dw_proc_pcnc.accepttext( )
					dw_proc_pcnc.groupCalc()
					commit;
					w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.reset()
					
					w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.of_init(ls_port_code, ii_vessel_nr, long(ls_voyage_nr), li_pcn)
				end if
			end if
		end if
		
		if not lb_success then
			rollback;
			messageBox("Error","Delete failed.")
			return
		end if
		//CR2535 & 2536 End added by ZSW001 on 29/10/2011
	else 
		//Nothing to delete
		return
	end if
end if

_set_interface( 0, 0)

dw_task_list.retrieve(li_vessel_nr,ls_voyage_nr )

//CR2535 & 2536 Modified by ZSW001 on 29/10/2011
cb_refresh.event clicked()

end event

event ue_retrieve;call super::ue_retrieve;
/********************************************************************
   w_port_of_call.ue_retrieve
   <DESC>	Retrieve Data: proceeding list, POC details, Voyage and vessel details </DESC>
   <RETURN>	</RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS>	</ARGS>
   <USAGE>Complete window retrieve	</USAGE>
********************************************************************/

string ls_voyage_nr, ls_port_code, ls_purpose, ls_find_str
int li_pcn,li_selectedrow,li_row_cp,li_row_laycan

long 			li_row, ll_rows, ll_found, ll_rows_est, ll_tasks, ll_cal_calc_id, ll_owner_id
decimal{4}	ld_ord_hfo, ld_ord_do, ld_ord_go, ld_ord_lshfo
boolean		lb_reset

this.setredraw(false)

if ib_refreshproceedinglist = TRUE then

	lb_reset = false
	ib_refreshproceedinglist = FALSE	
	w_port_of_call.dw_vessel_next_open.reset( )
	w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.reset()
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.reset()
	w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.reset()

	//If vessel is not selected
	if ii_vessel_nr<1 then
		lb_reset = true
	else
		//Retrieve Proceeding List
		if rb_all_voyages.checked then
			ll_rows = dw_proc_pcnc.Retrieve(ii_vessel_nr, '', 1)
		else
			ll_rows = dw_proc_pcnc.Retrieve(ii_vessel_nr, right(string(today(),"yyyy"), 2), 1)
		end if
		IF ll_rows < 1 THEN  lb_reset = true
	end if
	
	if lb_reset = true then
		//POC related reset
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Reset()
		w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Reset()
		//Voyage related reset
		w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.Reset()
		w_port_of_call.dw_voyage_next_open.reset()
		dw_task_list.reset()
		
		is_previous_voyage = ""
		
		dw_proc_pcnc.reset()
		tab_poc.tabpage_owners_matters.dw_department_info.reset()
		tab_poc.tabpage_owners_matters.dw_department_list.reset()
		
		w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.reset()
		w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.reset()
		w_port_of_call.tab_poc.tabpage_vessel_text.gb_vesseldetail_att.visible = false
		w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.visible = false
		w_port_of_call.tab_poc.tabpage_port_details.gb_port_att.visible = false
		w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.visible = false
		tab_poc.tabpage_att.uo_att.visible = false
		dw_proc_pcnc.setredraw(TRUE)
		_set_interface(-1,-1)
		st_rows.text =" Row(s)"
		this.setredraw(true)
		Return	
	end if
	
	dw_vessel_next_open.retrieve(ii_vessel_nr)
	
end if

//SELECT ROW
IF uo_global.GetParm() = 1 THEN
	ls_voyage_nr 	= uo_global.GetVoyage_nr()
	ls_port_code 	= uo_global.GetPort_Code()
	li_pcn       	= uo_global.Getpcn()
	
	ls_find_str = 	"proceed_voyage_nr = '" + ls_voyage_nr + &	
							"' and proceed_port_code = '" + ls_port_code + "'" + &
							" and proceed_pcn = " + string(li_pcn)
	
	li_row = dw_proc_pcnc.find(ls_find_str, 1, dw_proc_pcnc.RowCount())
	dw_proc_pcnc.SelectRow(0, FALSE)
	dw_proc_pcnc.SelectRow(li_row, TRUE)
	dw_proc_pcnc.SetRow(li_row)	
	dw_proc_pcnc.ScrollToRow(li_row)
	uo_global.SetParm(0)
else
	if il_modifiedrow > dw_proc_pcnc.rowcount() then
		il_modifiedrow = 0
	end if
	
	if il_modifiedrow > 0 then
		li_row = il_modifiedrow
	else
		li_row	= dw_proc_pcnc.RowCount()
		ll_found	= dw_proc_pcnc.find("NOT isNull(poc_port_arr_dt)", dw_proc_pcnc.RowCount(), 0)
		if ll_found > 0 then //= last actual row
			li_row = ll_found
		end if
	end if
	//Added by TTY004 on 07/02/12.fixed a historic bug.
	if li_row <= 0 then
		this.setredraw(true)
		return
	end if 
	dw_proc_pcnc.SelectRow(0, FALSE)
	dw_proc_pcnc.SelectRow(li_row, TRUE)
	dw_proc_pcnc.SetRow(li_row)	
	dw_proc_pcnc.ScrollToRow(li_row)
	
	ls_voyage_nr = dw_proc_pcnc.GetItemString(li_row, "proceed_voyage_nr")
	ls_port_code = dw_proc_pcnc.GetItemString(li_row, "proceed_port_code")
	li_pcn = dw_proc_pcnc.GetItemNumber(li_row, "proceed_pcn")		
end if

w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.Retrieve(ls_port_code)
if w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.rowcount() > 0 then
   w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.of_init()
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.of_addupdatetable("ATTACHMENTS","file_id")
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.of_addupdatetable("PORTS_ACTION","port_code,file_id","port_code,file_id")
   w_port_of_call.tab_poc.tabpage_port_details.gb_port_att.visible = true
	w_port_of_call.tab_poc.tabpage_port_details.uo_port_att.visible = true
	
	tab_poc.tabpage_port_details.uo_port_att.pb_new.visible = true
	tab_poc.tabpage_port_details.uo_port_att.pb_delete.visible = true
   tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.ib_columntitlesort = true
	tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.ib_multicolumnsort = true
   tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.ib_setselectrow = true
	
   
end if

w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.Retrieve(ii_vessel_nr)
if w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.rowcount() > 0 then
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.of_init()
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.of_addupdatetable("ATTACHMENTS","file_id")
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.of_addupdatetable("VESSELS_ACTION","vessel_nr,file_id","vessel_nr,file_id")
	w_port_of_call.tab_poc.tabpage_vessel_text.gb_vesseldetail_att.visible = true
	w_port_of_call.tab_poc.tabpage_vessel_text.uo_vesseldetail_att.visible = true
	
	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_new.visible = true
	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_delete.visible = true
	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.ib_columntitlesort = true
	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.ib_multicolumnsort = true
	tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.ib_setselectrow = true
	

end if

w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.retrieve(ii_vessel_nr)

//Added by TTY004 on 07/02/12.fixed a historic bug.
if li_row <= 0 then
	this.setredraw(true)
	return
end if 
tab_poc.tabpage_att.uo_att.visible = true

//RETRIVE VOYAGE RELATED
if ls_voyage_nr <> is_previous_voyage then
	w_port_of_call.dw_voyage_next_open.retrieve(ii_vessel_nr, ls_voyage_nr)
	w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.Retrieve(ii_vessel_nr, ls_voyage_nr)
	w_port_of_call.tab_poc.tabpage_att.uo_att.of_init( ls_voyage_nr, ii_vessel_nr )
	ll_tasks = dw_task_list.retrieve( ii_vessel_nr, ls_voyage_nr)
	if ll_tasks = 0 and  dw_proc_pcnc.GetItemNumber(li_row, "voyages_voyage_finished")	=0 then 
		wf_initialize_tasklist( ii_vessel_nr, ls_voyage_nr)
		dw_task_list.retrieve( ii_vessel_nr, ls_voyage_nr)
	end if
	is_previous_voyage = ls_voyage_nr
else
	dw_task_list.collapseall( )
end if

//CR2414 begin added by LHC010 on 25-05-2011
//re-retrieve laycan and cp use cal_calc_id
li_selectedrow = dw_proc_pcnc.getselectedrow(0)
if li_selectedrow > 0 then
	ll_cal_calc_id = dw_proc_pcnc.getitemnumber(li_selectedrow, "cal_calc_id")

	w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.reset( )
	
	li_row_cp = w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.retrieve(ll_cal_calc_id, ls_port_code)
	if (li_row_cp <= 0 or isnull(li_row_cp)) and (ls_port_code = 'L' or ls_port_code = 'L/D') then
		w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.insertrow(0)				
	end if
	
	li_row_laycan = w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.getitemnumber(1, "rowcnt")
	if li_row_laycan > 1 then
		w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.modify("b_left.enabled = 'no'")
		w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.modify("b_right.enabled = 'yes'")
	else
		w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.modify("b_left.enabled = 'no'")
		w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.modify("b_right.enabled = 'no'")			
	end if
end if
//CR2414 end added

//expand port node
wf_select_task_node(ls_port_code, li_pcn)

//RETRIVE POC RELATED
ll_rows =  w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Retrieve(ii_vessel_nr,ls_voyage_Nr,ls_port_code,li_pcn) 
ll_rows_est = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Retrieve(ii_vessel_nr,ls_voyage_Nr,ls_port_code,li_pcn,uo_global.is_userid)
if ll_rows_est > 0 then//Added by TTY004 on 02/02/12. Change desc:do not need to recalculate ST and PS
	__setstps_display(ll_rows_est)
end if

if ll_rows > 0 or ll_rows_est > 0 then
	//Bunker orders
	SELECT sum(ORDERED_HFO), sum(ORDERED_DO), sum(ORDERED_GO), sum(ORDERED_LSHFO)
		INTO :ld_ord_hfo, :ld_ord_do, :ld_ord_go, :ld_ord_lshfo
		FROM  BP_DETAILS
		WHERE VESSEL_NR = :ii_vessel_nr  AND  
			VOYAGE_NR = :ls_voyage_nr  AND  
			PORT_CODE = :ls_port_code AND  
			PCN = :li_pcn   
		GROUP BY   PORT_CODE, VESSEL_NR, VOYAGE_NR, PCN;
end if
	
if ll_rows > 0 then
	w_port_of_call.tab_poc.SelectTab(1)

	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItem(1, "bp_ordered_hfo", ld_ord_hfo)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItem(1, "bp_ordered_do", ld_ord_do)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItem(1, "bp_ordered_go", ld_ord_go)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItem(1, "bp_ordered_lshfo", ld_ord_lshfo)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItemStatus(1, 0, primary!, notmodified!)
	cb_finished.enabled = true
	if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"voyages_voyage_finished") = 1 then
		cb_finished.text = is_activatevoyage
	else
		cb_finished.text = is_finishvoyage
	end if
elseif ll_rows_est > 0 then 
	w_port_of_call.tab_poc.SelectTab(2)
	cb_finished.text = is_finishvoyage
	
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.setItem(1, "ordered_hfo", ld_ord_hfo)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.setItem(1, "ordered_do", ld_ord_do)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.setItem(1, "ordered_go", ld_ord_go)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.setItem(1, "ordered_lshfo", ld_ord_lshfo)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.setItemStatus(1, 0, primary!, notmodified!)
else
	w_port_of_call.tab_poc.SelectTab(2)
	cb_finished.text = is_finishvoyage
end if

tab_poc.tabpage_owners_matters.dw_department_info.reset()
tab_poc.tabpage_owners_matters.dw_department_list.reset()

//Retrieve OWNER_MATTERS_DOCUMENT
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
w_port_of_call.tab_poc.tabpage_owners_matters.uo_attach.of_init(ls_port_code, ii_vessel_nr, long(ls_voyage_nr), li_pcn)

if this.tab_poc.tabpage_owners_matters.dw_department_info.rowcount() > 0 then
	ll_owner_id = tab_poc.tabpage_owners_matters.dw_department_info.getitemnumber(1, "owner_department_id")
	wf_init_departments(ll_owner_id)
end if

dw_proc_pcnc.setredraw(TRUE)

st_rows.text = string(dw_proc_pcnc.rowcount()) + " Row(s)"

_set_interface(ll_rows_est, ll_rows)

dw_proc_pcnc.SetFocus()

this.setredraw(true)

is_rb = "Onlythisyear"
end event

event ue_insert;call super::ue_insert;
/********************************************************************
   w_port_of_call.ue_insert()
   <DESC>	Insert an actual or estimated POC		</DESC>
   <RETURN></RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS>	</ARGS>
   <USAGE>	Used to create a new POC </USAGE>
********************************************************************/

string ls_voyage_nr
string ls_port_code, ls_agentdetail
int li_pcn,li_dummy_vessel,li_voyage_finished
double ld_ordered_hfo, ld_ordered_do, ld_ordered_go, ld_ordered_lshfo
long ll_row
boolean lb_slop_mandatory

ll_row = dw_proc_pcnc.getselectedrow(0)

ib_new = true

if ll_row<1 then return

if w_port_of_call.tab_poc.SelectedTab = 1 then
	//*******************
	//Insert new Actual POC
	//*******************
	ls_voyage_nr = dw_proc_pcnc.GetItemString(ll_row,"proceed_voyage_nr")
	ls_port_code = dw_proc_pcnc.GetItemString(ll_row,"proceed_port_code")
	li_pcn = dw_proc_pcnc.GetItemNumber(ll_row,"proceed_pcn")
	
	// If any est for this actual, then disallow actual.
	SELECT POC_EST.VESSEL_NR  
		INTO :li_dummy_vessel  
		FROM POC_EST  
		WHERE ( POC_EST.VESSEL_NR = :ii_vessel_nr ) AND  
				( POC_EST.VOYAGE_NR = :ls_voyage_nr ) AND  
				( POC_EST.PORT_CODE = :ls_port_code ) AND  
				( POC_EST.PCN = :li_pcn ) ;
	IF sqlca.sqlcode = 0 THEN
		MessageBox("Validation","There exists an estimated Port of Call. Please delete or transfer to actual.")
		Commit;
		Return
	END IF
	
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.InsertRow(0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"vessel_nr",ii_vessel_nr)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"voyage_nr",ls_voyage_nr)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"port_code",ls_port_code)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"pcn",li_pcn)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"lt_to_utc_difference",0)
	 
	SELECT P.POC_SLOP_MANDATORY  
		INTO :lb_slop_mandatory  
		FROM PROFIT_C P, VESSELS V  
		WHERE V.PC_NR = P.PC_NR
		AND V.VESSEL_NR = :ii_vessel_nr ;

	IF lb_slop_mandatory then w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"poc_slop_mandatory",1)
	
	SELECT sum(ORDERED_HFO), sum(ORDERED_DO), sum(ORDERED_GO), sum(ORDERED_LSHFO)
		INTO :ld_ordered_hfo, :ld_ordered_do, :ld_ordered_go, :ld_ordered_lshfo
		FROM BP_DETAILS
		WHERE VESSEL_NR = :ii_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr AND
				PORT_CODE = :ls_port_code AND
				PCN = :li_pcn;
	IF SQLCA.SQLCODE = 0 THEN
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"bp_ordered_hfo",ld_ordered_hfo)
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"bp_ordered_do",ld_ordered_do)
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"bp_ordered_go",ld_ordered_go)
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"bp_ordered_lshfo",ld_ordered_lshfo)
	END IF
	
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"disch",1)
	
	//CR2562 Begin added by ZSW001 on 22/05/2012: Remove default values in Tugs fields
	/*
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"tugs_in",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"tugs_out",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"tugs_shifting",0)
	*/
	//CR2562 End added by ZSW001 on 22/05/2012
	
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"lift_hfo",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"lift_do",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"lift_go",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"lift_lshfo",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItem(1,"port_off",0)
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetFocus()

	w_port_of_call.tab_poc.tabpage_act.cb_updateact.Default = TRUE
	
	_set_interface(0, 1)
	
	//CR2535 & 2536 Modified by ZSW001 on 26/10/2011
	inv_autoschedule.of_new_poc(dw_proc_pcnc, tab_poc.tabpage_act.dw_port_of_call, ii_ACTUAL)
	wf_set_ownermatter(ls_voyage_nr, ls_port_code, li_pcn)
elseif w_port_of_call.tab_poc.SelectedTab = 2 then
	
	//*********************
	//Insert new Estimated POC
	//*********************
	ls_voyage_nr = dw_proc_pcnc.GetItemString(ll_row,"proceed_voyage_nr")
	ls_port_code = dw_proc_pcnc.GetItemString(ll_row,"proceed_port_code")
	li_pcn = dw_proc_pcnc.GetItemNumber(ll_row,"proceed_pcn")

	// If any act for this poc, then disallowe estimated.
	SELECT POC.VESSEL_NR  
   	INTO :li_dummy_vessel  
   	FROM POC  
   	WHERE ( POC.VESSEL_NR = :ii_vessel_nr ) AND  
         ( POC.VOYAGE_NR = :ls_voyage_nr ) AND  
         ( POC.PORT_CODE = :ls_port_code ) AND  
         ( POC.PCN = :li_pcn ) ;
	IF sqlca.sqlcode = 0 THEN
		MessageBox("Validation","There exists an actual Port of Call. New estimated Port of Call is not allowed.")
		Commit;
		Return
	END IF
	
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.InsertRow(0)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"poc_est_vessel_nr",ii_vessel_nr)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"poc_est_voyage_nr",ls_voyage_nr)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"poc_est_port_code",ls_port_code)
	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"poc_est_pcn",li_pcn)
	
	SELECT P.POC_SLOP_MANDATORY  
	INTO :lb_slop_mandatory  
	FROM PROFIT_C P, VESSELS V  
	WHERE V.PC_NR = P.PC_NR
	AND V.VESSEL_NR = :ii_vessel_nr ;

	IF lb_slop_mandatory then w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"poc_slop_mandatory",1)
	
	SELECT sum(ORDERED_HFO), sum(ORDERED_DO), sum(ORDERED_GO), sum(ORDERED_LSHFO)
		INTO :ld_ordered_hfo, :ld_ordered_do, :ld_ordered_go, :ld_ordered_lshfo
		FROM BP_DETAILS
		WHERE VESSEL_NR = :ii_vessel_nr AND
				VOYAGE_NR = :ls_voyage_nr AND
				PORT_CODE = :ls_port_code AND
				PCN = :li_pcn;
	IF SQLCA.SQLCODE = 0 THEN
		w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"ordered_hfo",ld_ordered_hfo)
		w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"ordered_do",ld_ordered_do)
		w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"ordered_go",ld_ordered_go)
		w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetItem(1,"ordered_lshfo",ld_ordered_lshfo)
	END IF

	w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetFocus()
	w_port_of_call.tab_poc.tabpage_est.cb_updateest.Default = TRUE

	_set_interface(1, 0)
		
	//CR2535 & 2536 Modified by ZSW001 on 29/10/2011
	inv_autoschedule.of_new_poc(dw_proc_pcnc, tab_poc.tabpage_est.dw_port_of_call_est, ii_ESTIMATED)
	__setstps_display(1)//Added by TTY004 on 02/02/12. Change desc:get original ST and PS
	wf_set_ownermatter(ls_voyage_nr, ls_port_code, li_pcn)	
else
	//Nothing to insert
	dw_proc_pcnc.setfocus( )
	return
end if

end event

event open;call super::open;
/********************************************************************
   w_port_of_call.open()
   <DESC>	Event window open	</DESC>
   <RETURN> </RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS></ARGS>
   <USAGE>	
	SetTransObject(SQLCA)
	Set permissions
	Initialize uo_vesselselect
	Interface objects formating
</USAGE>
********************************************************************/

n_service_manager 	lnv_SM
n_dw_Style_Service  	lnv_dwStyle
datawindowchild		ldw_psm

//CR2319 D3-2 Added by LGX001 on 09/10/2011.  
if message.stringparm = 'OPEN-FROM-F3' then ib_allowchangemenu = false

w_port_of_call.Move(0,0)

dw_proc_pcnc.SetTrans(SQLCA)
dw_vessel_next_open.setTransObject(SQLCA)
dw_voyage_next_open.setTransObject(SQLCA)
w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetTransObject(SQLCA)

w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.SetTransObject(SQLCA)
w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.SetTransObject(SQLCA)
//CR2408 added by LHC010 on 25-05-2011. Change desc: cr2414 show laycan and cp
w_port_of_call.tab_poc.tabpage_voy_text.dw_laycan_cp.SetTransObject(SQLCA)
w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.SetTransObject(SQLCA)
w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.settransobject(sqlca)
w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.SetTransObject(SQLCA)
dw_task_list.SetTransObject(SQLCA)
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.settransobject(sqlca)
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.settransobject(sqlca)

tab_poc.tabpage_owners_matters.dw_department_info.getchild('responsible_psm', ldw_psm)
ldw_psm.settransobject(sqlca)	
ldw_psm.retrieve(uo_global.is_userid)
tab_poc.tabpage_owners_matters.dw_department_info.of_registerdddw("responsible_psm", "users_locked = 0 and users_deleted = 0")
//ports detail attachment
tab_poc.tabpage_port_details.uo_port_att.of_init()
tab_poc.tabpage_port_details.uo_port_att.pb_new.visible = false
tab_poc.tabpage_port_details.uo_port_att.pb_delete.visible = false
tab_poc.tabpage_port_details.dw_port_details.is_hyperlinkshortcut = "ports_details"

//vessels detail attachment
tab_poc.tabpage_vessel_text.uo_vesseldetail_att.of_init()
tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_new.visible = false
tab_poc.tabpage_vessel_text.uo_vesseldetail_att.pb_delete.visible = false
tab_poc.tabpage_vessel_text.dw_vessel_text.is_hyperlinkshortcut = "details"


dw_proc_pcnc.setrowfocusindicator(FOCUSRECT!)

_set_permissions()

uo_vesselselect.of_registerwindow( w_port_of_call )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
ii_vessel_nr = uo_global.getvessel_nr( )

//Formats interface objects
tab_poc.tabpage_att.uo_att.of_setresizablecolumns( true )

tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.modify("description.width = 2200")
tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.modify("description.width = 2200")

lnv_SM.of_loadservice( lnv_dwStyle, "n_dw_style_service")

lnv_dwStyle.of_dwlistformater(dw_proc_pcnc, false)
lnv_dwStyle.of_dwlistformater(dw_task_list)
lnv_dwStyle.of_autoadjustdddwwidth( w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est)
lnv_dwStyle.of_autoadjustdddwwidth( w_port_of_call.tab_poc.tabpage_act.dw_port_of_call)

//CR2531 Begin added by ZSW001 on 02/09/2011
uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

dw_task_list.object.datawindow.detail.color = string(c#color.MT_FORM_BG)
dw_task_list.object.datawindow.color = string(c#color.MT_FORM_BG)
//CR2531 End added by ZSW001 on 02/09/2011

//Forwarts datawindow
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.object.datawindow.color = string(c#color.MT_FORM_BG)
w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.object.datawindow.color = string(c#color.MT_FORM_BG)

inv_autoschedule = create n_autoschedule

end event

on w_port_of_call_bak.create
int iCurrent
call super::create
this.gb_nextopenposition=create gb_nextopenposition
this.gb_2=create gb_2
this.gb_4=create gb_4
this.dw_proc_pcnc=create dw_proc_pcnc
this.cb_close=create cb_close
this.cb_poc_list=create cb_poc_list
this.cb_refresh=create cb_refresh
this.rb_all_voyages=create rb_all_voyages
this.rb_only_this_year=create rb_only_this_year
this.gb_1=create gb_1
this.st_rows=create st_rows
this.cb_finished=create cb_finished
this.tab_poc=create tab_poc
this.dw_vessel_next_open=create dw_vessel_next_open
this.dw_voyage_next_open=create dw_voyage_next_open
this.shl_bunker=create shl_bunker
this.st_responsible=create st_responsible
this.shl_1=create shl_1
this.dw_task_list=create dw_task_list
this.gb_5=create gb_5
this.st_topbar_background=create st_topbar_background
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_date=create st_date
this.st_portarea=create st_portarea
this.dw_bol_in_poc=create dw_bol_in_poc
this.st_warning=create st_warning
this.shl_ecovoy=create shl_ecovoy
this.dw_voyage_alert=create dw_voyage_alert
this.ids_auto_est=create ids_auto_est
this.ids_auto_act=create ids_auto_act
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_nextopenposition
this.Control[iCurrent+2]=this.gb_2
this.Control[iCurrent+3]=this.gb_4
this.Control[iCurrent+4]=this.dw_proc_pcnc
this.Control[iCurrent+5]=this.cb_close
this.Control[iCurrent+6]=this.cb_poc_list
this.Control[iCurrent+7]=this.cb_refresh
this.Control[iCurrent+8]=this.rb_all_voyages
this.Control[iCurrent+9]=this.rb_only_this_year
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.st_rows
this.Control[iCurrent+12]=this.cb_finished
this.Control[iCurrent+13]=this.tab_poc
this.Control[iCurrent+14]=this.dw_vessel_next_open
this.Control[iCurrent+15]=this.dw_voyage_next_open
this.Control[iCurrent+16]=this.shl_bunker
this.Control[iCurrent+17]=this.st_responsible
this.Control[iCurrent+18]=this.shl_1
this.Control[iCurrent+19]=this.dw_task_list
this.Control[iCurrent+20]=this.gb_5
this.Control[iCurrent+21]=this.st_topbar_background
this.Control[iCurrent+22]=this.rb_1
this.Control[iCurrent+23]=this.rb_2
this.Control[iCurrent+24]=this.st_date
this.Control[iCurrent+25]=this.st_portarea
this.Control[iCurrent+26]=this.dw_bol_in_poc
this.Control[iCurrent+27]=this.st_warning
this.Control[iCurrent+28]=this.shl_ecovoy
this.Control[iCurrent+29]=this.dw_voyage_alert
end on

on w_port_of_call_bak.destroy
call super::destroy
destroy(this.gb_nextopenposition)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.dw_proc_pcnc)
destroy(this.cb_close)
destroy(this.cb_poc_list)
destroy(this.cb_refresh)
destroy(this.rb_all_voyages)
destroy(this.rb_only_this_year)
destroy(this.gb_1)
destroy(this.st_rows)
destroy(this.cb_finished)
destroy(this.tab_poc)
destroy(this.dw_vessel_next_open)
destroy(this.dw_voyage_next_open)
destroy(this.shl_bunker)
destroy(this.st_responsible)
destroy(this.shl_1)
destroy(this.dw_task_list)
destroy(this.gb_5)
destroy(this.st_topbar_background)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_date)
destroy(this.st_portarea)
destroy(this.dw_bol_in_poc)
destroy(this.st_warning)
destroy(this.shl_ecovoy)
destroy(this.dw_voyage_alert)
destroy(this.ids_auto_est)
destroy(this.ids_auto_act)
end on

event activate;if ib_allowchangemenu then
	If w_tramos_main.MenuName <> "m_tramosmain" Then
		w_tramos_main.ChangeMenu(m_tramosmain)
	end if
end if

if isvalid(m_tramosmain) then
	m_tramosmain.mf_setcalclink(dw_proc_pcnc, "proceed_vessel_nr", "proceed_voyage_nr", True)
end if
	
uo_vesselselect.of_setshowtext( )




end event

event timer;call super::timer;
st_warning.visible = not st_warning.visible 
end event

event ue_vesselselection;call super::ue_vesselselection;/********************************************************************
   w_port_of_call.ue_vesselselection
   <DESC>	Vessel selection changed		</DESC>
   <RETURN>	</RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS>	ai_vessel: Description
   </ARGS>
   <USAGE>
		- checks if data not saved - wf_data_modified()
		- selects vessel responsible
		- Checks TC Hire contract - wf_checktccontract()
		- Retrieves data - ue_retrieve
</USAGE>
********************************************************************/

string ls_responsible

//CR2535 & 2536 Modified by ZSW001 on 29/10/2011
inv_autoschedule.il_vessel_nr = ai_vessel

il_vessel_nr = ai_vessel
wf_data_modified()

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	messagebox("Error", "Vessel accept error.")
	return
end if
 
SELECT VESSEL_OPERATOR, PC_NR
INTO :ls_responsible, :ii_pcnr
FROM VESSELS
WHERE VESSEL_NR = :ai_vessel;
COMMIT USING SQLCA; 

st_responsible.text = "Responsible Operator: " + ls_responsible

ib_refreshproceedinglist = true 

POST wf_checktccontract()

is_previous_voyage = ""

/*Begin modified by Henry Chen on 20-05-2011 CR2408*/
if uo_global.getparm() = 1 then
	if left(uo_global.getvoyage_nr(),2) <> right(string(today(),"yyyy"),2) then
		rb_all_voyages.checked = true
		rb_only_this_year.checked = false
		rb_all_voyages.event clicked( )
		return
	end if
end if
/*End modified by Henry Chen on 20-05-2011*/

//CR2410 added by WWG004 on 03/06/2011.
//When changed a POC and update, refresh the datawindow, tramos auto scroll to the modify row.
il_modifiedrow = 0

postevent("ue_retrieve")
end event

event closequery;call super::closequery;
/* Call function to verify if all changes are saved, before closing the window */
wf_data_modified( )

//CR2535 & 2536 Added by ZSW001 on 17/11/2011
if not ib_allowclose then return 1

end event

event close;call super::close;destroy inv_autoschedule

end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_port_of_call_bak
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_port_of_call_bak
integer x = 23
integer taborder = 10
end type

type gb_nextopenposition from groupbox within w_port_of_call_bak
integer x = 2185
integer width = 1650
integer height = 208
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Next Open Position"
end type

type gb_2 from groupbox within w_port_of_call_bak
integer x = 1769
integer width = 384
integer height = 208
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Sort POC"
end type

type gb_4 from groupbox within w_port_of_call_bak
integer x = 4210
integer y = 240
integer width = 343
integer height = 280
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Links"
end type

type dw_proc_pcnc from u_datagrid within w_port_of_call_bak
event ue_mousemove pbm_dwnmousemove
event ue_rbuttondown pbm_dwnrbuttondown
integer x = 37
integer y = 264
integer width = 4142
integer height = 516
integer taborder = 80
string dataobject = "dw_proc_pcnc"
boolean vscrollbar = true
boolean border = false
boolean ib_multicolumnsort = false
end type

event ue_rbuttondown;/********************************************************************
   ue_rbuttondown
   <DESC>	Show bill of lading tooltip datawindow	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
   <ACCESS> public </ACCESS>
   <ARGS>
		xpos: Mouse X position
		ypos: Mouse Y position
		row : Data row
		dwo : Datawindow object
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	20-10-2011 2427         JMY014        		 First Version
   </HISTORY>
********************************************************************/
String 	ls_voyage_nr, ls_port_code
integer	li_pcn, li_adjustpos=0

if row <= 0 then return

if dwo.name = "compute_purpose" and this.getitemnumber(row, "bol_number") > 0 then	
	ls_voyage_nr = this.getitemstring(row, "proceed_voyage_nr")
	ls_port_code = this.getitemstring(row, "proceed_port_code")
	li_pcn       = this.getitemnumber(row, "proceed_pcn")
	
	dw_bol_in_poc.x = xpos * 4
	dw_bol_in_poc.y = ypos * 4  + 250

	dw_bol_in_poc.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	
	dw_bol_in_poc.visible = true
	dw_bol_in_poc.setfocus()
elseif dwo.name = "p_voyagealert" then
	dw_voyage_alert.x = xpos * 4
	dw_voyage_alert.y = ypos * 4  + 250
	wf_show_voyage_alert(row)
end if

return c#return.Success
end event

event clicked;string 		ls_voyage_nr, ls_port_code
int 			li_pcn, li_bp_details, li_bol_number
Long 			ll_row
s_cargo		lstr_parm 
s_chart_comment_parm		lstr_parm_chart 

w_port_of_call.wf_data_modified()
if not ib_allowclose then
	ll_row = this.getselectedrow(0)
	if ll_row > 0 then this.post setrow(ll_row)
	return
end if

IF row < 1 THEN return

if row > this.rowCount() then return 

//open a small popup window to show BOL dates when clicking on purpose
if xpos<>0 and xpos<> 0 then
	ls_voyage_nr	= dw_proc_pcnc.getitemstring(row, "proceed_voyage_nr")
	ls_port_code	= dw_proc_pcnc.getitemstring(row, "proceed_port_code")
	li_pcn			= dw_proc_pcnc.getItemNumber(row, "proceed_pcn")
	//Show charterer comments
	if dwo.name = "p_charterercoments" then
		lstr_parm_chart.chart_nr = false
		lstr_parm_chart.reciD = dw_proc_pcnc.getItemNumber(row, "cal_calc_id")
		OpenWithParm (w_chart_comment_popup, lstr_parm_chart )
		return
	end if

end if

this.SelectRow(0,FALSE)
this.SelectRow(row,TRUE)

il_modifiedrow = row

w_port_of_call.postevent("ue_retrieve")

ib_new = false

end event

event constructor;if ib_enablesortindex and ib_columntitlesort then
	ib_enablesortindex = false
end if

if ib_multirow then
	inv_filter_multirow = create n_dw_filter_multirow
end if

end event

type cb_close from commandbutton within w_port_of_call_bak
boolean visible = false
integer x = 3675
integer y = 2336
integer width = 439
integer height = 100
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;Close(parent)
end on

type cb_poc_list from commandbutton within w_port_of_call_bak
integer x = 4210
integer y = 680
integer width = 343
integer height = 100
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&MVV"
end type

event clicked;n_object_usage_log lnv_uselog
/*Begin modified by Henry Chen on 20-05-2011*/
if isvalid(w_port_of_call_list) then
	if w_port_of_call_list.windowstate = minimized! then w_port_of_call_list.windowstate = normal!
	w_port_of_call_list.bringtotop = true
else
	lnv_uselog.uf_log_object("POC:Multiple Vessel View (MVV)")
	open(w_port_of_call_list)
end if
/*End modified by Henry Chen on 20-05-2011*/

end event

type cb_refresh from commandbutton within w_port_of_call_bak
integer x = 4210
integer y = 32
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;
/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

w_port_of_call.event ue_vesselselection( ii_vessel_nr )

il_modifiedrow = dw_proc_pcnc.getselectedrow(0)

end event

type rb_all_voyages from radiobutton within w_port_of_call_bak
integer x = 1307
integer y = 64
integer width = 402
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "All"
end type

event clicked;if is_rb <> "All" and ib_new = true then
	if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() > 0 then
		messagebox("Data Not Saved", "Actual Port Of Call data modified, but not saved.")
	elseif w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount() > 0 then
		messagebox("Data Not Saved", "Estimated Port Of Call data modified, but not saved.")
	end if
	
	this.checked = false
	rb_only_this_year.checked = true
	rb_only_this_year.setfocus()
else
	rb_1.triggerevent(clicked!)

	il_modifiedrow = 0
	
	ib_refreshproceedinglist = True
	w_port_of_call.triggerevent("ue_retrieve")
	
	is_rb = "All"
end if



end event

type rb_only_this_year from radiobutton within w_port_of_call_bak
integer x = 1307
integer y = 128
integer width = 402
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Only This Year"
boolean checked = true
end type

event clicked;if is_rb <> "Onlythisyear" and ib_new = true then
	if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() > 0 then
		messagebox("Data Not Saved", "Actual Port Of Call data modified, but not saved.")
	elseif w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount() > 0 then
		messagebox("Data Not Saved", "Estimated Port Of Call data modified, but not saved.")
	end if
	
	this.checked = false
	rb_all_voyages.checked = true
	rb_all_voyages.setfocus()
	
else

	rb_1.triggerevent(clicked!)
	
	ib_refreshproceedinglist =True
	
	il_modifiedrow = 0
	
	w_port_of_call.triggerevent("ue_retrieve")
	
	is_rb = "Onlythisyear"
end if
end event

type gb_1 from groupbox within w_port_of_call_bak
integer x = 1266
integer width = 471
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Show Voyages"
end type

type st_rows from statictext within w_port_of_call_bak
integer x = 3904
integer y = 796
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean enabled = false
string text = "Row(s)"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_port_of_call_bak
integer x = 4210
integer y = 572
integer width = 343
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Finish Voyage"
end type

event clicked;string   ls_voyage_nr,ls_returnstring,ls_result, ls_previous_voyage_nr, ls_bunkermessage
long     ll_vessel_nr, ll_count_dept_dates_not_set, ll_counter, ll_charter, ll_rowcount
Integer  li_voy_in_log, li_count, li_answer, li_return_value, li_counter
Integer  li_result, li_finished, li_voyage_type, li_bunker_on
Boolean  lb_result
Datetime ldt_poc_arr_test, ldt_finished_date, ldt_discharge_date
mt_n_datastore lds_pending_task
string ls_text
long ll_i
string ls_voyage_text, ls_portcode_text, ls_pcn_text, ls_portname_text, ls_description_text
string ls_voyage, ls_portcode, ls_pcn, ls_portname, ls_description
n_messagebox lnv_msgbox

u_tramos_nvo             uo_tram
transaction              sqlclaim
n_accrualslock           lnv_accruals
u_check_functions        lu_check
n_bunker_posting_control lnv_bunker_posting

constant integer li_IDLEVOYAGE = 7

if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.RowCount() <> 1 THEN
	if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount( ) > 0 then
		messagebox("Validation","There is at least one existing estimated Port of Call. The voyage cannot be finished.")
	else
		messagebox("Info","Please select a port of call with poc details to finish/activate voyage.")
	end if
	return
end if


lnv_accruals = create n_accrualslock
if lnv_accruals.of_islockedpc(ii_pcnr) then
	destroy lnv_accruals
	_addmessage( this.ClassDefinition, "clicked()", "Sorry It is not possible to finish the voyage as accruals are being processed at this time.", "Helper:If this not the case disable through system options")
	return
end if
destroy lnv_accruals

li_voyage_type = w_port_of_call. tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"voyages_voyage_type")
if li_voyage_type = li_IDLEVOYAGE then
	_addmessage( this.ClassDefinition, "clicked()", "It is not possible to finish an Idle Voyage!", "User Message")
	return
end if

/* Get Current Voyage number */
ll_vessel_nr = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemnumber(1,"vessel_nr")
ls_voyage_nr = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"voyage_nr")
ldt_finished_date = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemdatetime(1,"voyages_voyage_finished_date")
w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.AcceptText()

choose case this.text
		
	case is_finishvoyage
		//FINISH VOYAGE	
		IF w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemStatus(1,0,Primary!) = New! OR &
				w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemStatus(1,0,Primary!) = NewModified! OR &
				w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.GetItemStatus(1,0,Primary!) = DataModified! THEN
			MessageBox("Information","You must update your recent changes first before you can finish the voyage.")
	 		return
		END IF	
				
		/* Check if there are any estimated POC */
		SELECT count(*)  
			INTO :li_counter  
			FROM POC_EST  
			WHERE ( POC_EST.VESSEL_NR = :ii_vessel_nr ) AND  
					( POC_EST.VOYAGE_NR = :ls_voyage_nr ) ;
		IF li_counter > 0 THEN
			MessageBox("Validation","There is at least one existing estimated Port of Call. The voyage cannot be finished.")
			Commit;
			return
		END IF
		
		if _checkdatesbetweenports(ll_vessel_nr)=c#return.Failure then
			return		
		end if
		
		if _checkpreviousvoyage(ii_vessel_nr, ls_voyage_nr, li_voyage_type) = c#return.Failure then
			return
		end if
		
		/* Check if proceeds match itinerary */
		if f_AtoBviaC_used (ll_vessel_nr,ls_voyage_nr) then
			n_portvalidator lnv_validator
			lnv_validator = create n_portvalidator
			if lnv_validator.of_start( "POCFINISHVOYAGE", ll_vessel_nr, ls_voyage_nr, 3 ) = c#return.Failure then
				destroy lnv_validator
				return
			end if
			destroy lnv_validator
		else
			uo_tram = CREATE u_tramos_nvo 
			ls_returnstring = uo_tram.uf_check_proceed_itenerary(ll_vessel_nr,ls_voyage_nr, TRUE)
			DESTROY uo_tram;
			IF ls_returnstring <> "1" AND ls_returnstring <> "0" THEN
				IF ls_returnstring <> "-1" THEN
					MessageBox("Information","There are more ports in Itinerary. You cannot finish the voyage.") 
				END IF
				Return
			END IF
		end if
		
		if wf_check_firstlast_interim(ls_voyage_nr) = c#return.Failure then return 
		
		/* Count how many poc's have not had their dept date filled out on this voyage */
		select count(VESSEL_NR)
		into :ll_count_dept_dates_not_set
		from POC
		where 	VESSEL_NR = :ll_vessel_nr and
				VOYAGE_NR = :ls_voyage_nr and
				PORT_DEPT_DT = null;
		commit;
		
		/* Count how many ports are not filled out correctly with fuel start and end values */
		select count(VESSEL_NR)
		into :ll_counter
		from POC
		where	VESSEL_NR = :ll_vessel_nr and
				VOYAGE_NR = :ls_voyage_nr and
				((ARR_HFO <> NULL and
				DEPT_HFO = NULL) or
				(ARR_DO <> NULL and
				DEPT_DO = NULL) or
				(ARR_GO <> NULL and
				DEPT_GO = NULL) or
				(ARR_LSHFO <> NULL and
				DEPT_LSHFO = NULL));
		commit;
		/* If there are any not filled out fields that must be filled out, then ... */
		if ll_count_dept_dates_not_set > 0 or ll_counter > 0 then
			/* inform user */
			messagebox("Notice","There is one or more Port of Call for this Voyage that does" + &
								" not have its Departure date or Bunker values set. Please correct the problem " + &
								"and try again.")
			/* Return from event */
			return
		/* else */
		else
			/*-------------------------- Functions from the Check Module---------------------*/
			/* Check if there¡äs registered data in the offservice- and idle modules				*/
			/* Make a check to see if there¡äs demurrage claims, which don¡ät have a forwarding*/
			/* date, and where total days (purpose L,D,L/D) in POC is larger than the calculated */
			/* field in the calculation */
			
			
			/* Create object */
			lu_check = create u_check_functions
				
			setpointer(HourGlass!)
			
			//CR2516 :check bunker comsumption 
			if not lu_check.uf_check_bunker(ll_vessel_nr,ls_voyage_nr, ls_bunkermessage) then
				messagebox("Notice", "Mismatch in bunker registration.~r~n~r~n"+ls_bunkermessage+"~r~n~r~n" + "  You MUST correct the error !")
				destroy lu_check
				return
			end if	
			
			li_return_value = lu_check.of_check_idledays(ll_vessel_nr, ls_voyage_nr)
			
			if li_return_value = c#return.failure then
				return
			end if	
			
			li_return_value = lu_check.uf_check_purpose_idle(ll_vessel_nr, ls_voyage_nr)
			if li_return_value = 1 then
				ls_result = "There is not registered any data in the Idle Module.~r~n"
			end if
			
			
			li_return_value = lu_check.uf_check_purpose_offservice(ll_vessel_nr,ls_voyage_nr)
			if li_return_value = 1 then
				ls_result += "There is not registered any data in the Off Services Module.~r~n"
			end if
				
				
			li_result = lu_check.uf_is_tcvoyage(ll_vessel_nr, ls_voyage_nr)
			if li_result = 0 then
				/* uf_check_dem_claims is disabled from finish button on the 5/3-98 */
				/*ls_result += lu_check.uf_check_dem_claims(ll_vessel_nr,ls_voyage_nr)*/
				ls_result += lu_check.uf_check_estimated_claims(ll_vessel_nr,ls_voyage_nr)			
				lb_result = lu_check.uf_check_misc_income(ll_vessel_nr, ls_voyage_nr)
				if not lb_result then
					ls_result += "Miscellanous income <> 0 in the calculation.~r~n"
				end if
			end if
			
			destroy lu_check
			
			if len(ls_result) > 5 then
				li_answer =	messagebox("Notice",ls_result+"Do you want to continue to finish the current voyage?",Question!,YesNo!,2)
				if li_answer = 2 then
					return
				end if
		   end if
			
			/*---------------- End of Check Module functions---------------------------------- */

			/*-- Validate that all Off-Services registred for this voyage also have dates inside the voyage period */
			n_offservice	lnv_offservice
			lnv_offservice = create n_offservice
			if lnv_offservice.of_voyagefinishvalidate( ll_vessel_nr, ls_voyage_nr) < 0 then
				destroy lnv_offservice
				Return
			end if
			
			destroy lnv_offservice
			/*-- END Validate that all Off-Services registred for this voyage also have dates inside the voyage period */
			
			/*	“Finish” – when this check box is selected for a task, it should not be allowed to finish a voyage, unless the user has either selected "Done" or "NA" for that task in Port of Call*/
			lds_pending_task = create mt_n_datastore
			lds_pending_task.dataobject = 'd_sq_gr_poc_pending_task'
			lds_pending_task.settransobject( sqlca)
			ll_rowcount = lds_pending_task.retrieve(ll_vessel_nr, ls_voyage_nr)
			if ll_rowcount > 0 then
	
				ll_i = 1
				ls_voyage = lds_pending_task.object.voyage_nr[ll_i]
				ls_portcode = lds_pending_task.object.port_code[ll_i]
				ls_portname = lds_pending_task.object.port_n[ll_i] 
				ls_pcn = string(lds_pending_task.object.pcn[ll_i])
				ls_description = lds_pending_task.object.description[ll_i]
				
				ls_voyage_text = space(7) + "Voyage"+ space(4) + ls_voyage
				ls_portcode_text = space(2) + "Port Code" + space(4) + ls_portcode
				ls_portname_text = space(1) + "Port Name"+ space(4) + ls_portname
				ls_pcn_text = space(12) + "PCN" + space(4) + ls_pcn
				ls_description_text = "Task Name" + space(4) + ls_description
				ls_text ="You have pending task(s) that require being marked as “Done” or “NA” before you can finish the selected voyage.~r~n~r~n" 
				
				for ll_i = 2 to ll_rowcount
				    if ls_portcode + ls_pcn  <> lds_pending_task.object.port_code[ll_i] + string(lds_pending_task.object.pcn[ll_i]) then
						ls_text += ls_voyage_text + "~r~n" + ls_portcode_text + "~r~n" + ls_portname_text + "~r~n" + ls_pcn_text + "~r~n" + ls_description_text +"~r~n~r~n"
						ls_voyage = lds_pending_task.object.voyage_nr[ll_i]
						ls_portcode = lds_pending_task.object.port_code[ll_i]
						ls_portname = lds_pending_task.object.port_n[ll_i] 
						ls_pcn = string(lds_pending_task.object.pcn[ll_i])
						ls_description = lds_pending_task.object.description[ll_i]
						
						ls_voyage_text = space(7) + "Voyage"+ space(4) + ls_voyage
						ls_portcode_text = space(2) + "Port Code" + space(4) + ls_portcode
						ls_portname_text = space(1) + "Port Name"+ space(4) + ls_portname
						ls_pcn_text = space(12) + "PCN" + space(4) + ls_pcn
						ls_description_text = "Task Name" + space(4) + ls_description
					else
						ls_description_text += ", " + lds_pending_task.object.description[ll_i]
					end if
				next
				
				ls_text += ls_voyage_text + "~r~n" + ls_portcode_text + "~r~n" + ls_portname_text + "~r~n" + ls_pcn_text + "~r~n" + ls_description_text 
				
				lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_GENERAL_ERROR, ls_text, this, 'Finish Voyage')
			
				destroy lds_pending_task
				return 
			end if
			
			destroy lds_pending_task
			
			if wf_interim_jump_new_dev(ll_vessel_nr, ls_voyage_nr) = 3 then return 
			
			/*---------------- Generate CODA bunker transaction------------------------------- */
			/* according to change request #1072 all voyages prior to 2007 will be ignored  */
			if mid(ls_voyage_nr,1,2)  >= "07" and mid(ls_voyage_nr,1,1) <> "9" then 
				lnv_bunker_posting = create n_bunker_posting_control	
				if lnv_bunker_posting.of_finish_voyage( ll_vessel_nr, ls_voyage_nr ) = -1 then
					destroy lnv_bunker_posting
					return
				end if
				destroy lnv_bunker_posting
			else
				// Just set voyage to finished change request #1455
				UPDATE VOYAGES
				SET VOYAGE_FINISHED = 1
				WHERE VESSEL_NR = :ll_vessel_nr
				AND VOYAGE_NR = :ls_voyage_nr;
			end if
			
			/*---------------- END Generate CODA bunker transaction------------------------------- */
			
			/* Set finished state in detail so as to grey fields */
			w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setitem(1,"voyages_voyage_finished",1)
			
			w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.SetItemStatus(1,0,Primary!,NotModified!)
			
			/* Update next open this voyage with max. departure date */
			SELECT MAX(PORT_DEPT_DT) INTO :ldt_poc_arr_test
			FROM   POC
			WHERE  VESSEL_NR =:ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
				
			dw_voyage_next_open.setItem(1, "est_voyage_end", ldt_poc_arr_test)
			
			if dw_voyage_next_open.update() = 1 then
				
				setnull(ldt_discharge_date)
				
				SELECT CONVERT(DATE, MAX(PORT_DEPT_DT)) INTO :ldt_discharge_date 
				FROM   POC
				WHERE  VESSEL_NR = :ll_vessel_nr and VOYAGE_NR = :ls_voyage_nr and PURPOSE_CODE IN ("D", "L/D");
				
				if not isnull(ldt_discharge_date) then
					
					UPDATE CLAIMS
					SET    DISCHARGE_DATE = :ldt_discharge_date, TIMEBAR_DATE = DATEADD(dd, TIMEBAR_DAYS, :ldt_discharge_date),
					       NOTICE_DATE    = DATEADD(dd, NOTICE_DAYS, :ldt_discharge_date)
					WHERE  VESSEL_NR = :ll_vessel_nr and VOYAGE_NR = :ls_voyage_nr;
					
					if sqlca.sqlcode <> 0 then
						rollback;
						messageBox("Error", "Is not possible to Finish Voyage. Please contact system administrator.")
						return
					end if
					
				end if
				
				commit;
				
				this.text = is_activatevoyage
				
				//If is the first time the voyage is finished, then send an email to demurrage responsible
				if isnull(ldt_finished_date) and Long(mid(ls_voyage_nr,1,2)) >10  and Long(mid(ls_voyage_nr,1,2)) < 50 and len(ls_voyage_nr)<7  then
					if _send_finished_voyage_alert() = c#return.failure then		
						MessageBox("Send Email to Demurrage Analyst", "Sending of the email to demurrage analyst failed. Please make sure that demurrage analyst is informed about the finished voyage!")
					end if
				end if
				
				w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setitem(1,"voyages_voyage_finished_date", now())
				w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setitemstatus( 1,"voyages_voyage_finished_date",Primary!, NotModified!)
				
			else
				rollback;
				messageBox("Error", "Is not possible to Finish Voyage. Please contact system administrator.")
				return
			end if
			
		/* End if statement */
		end if
		
	case is_activatevoyage
		
		//ACTIVATE VOYAGE
		
		/* Update voyage table with new finished state */
		update 	VOYAGES
		set 		VOYAGE_FINISHED = 0
		where 	VOYAGE_NR = :ls_voyage_nr and
				VESSEL_NR = :ll_vessel_nr;
		commit;		
		/* Set finished state in detail so as to enable fields */
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setitem(1,"voyages_voyage_finished",0)
		w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.update()
		commit;
		/* Set button text */
		this.text = is_finishvoyage
		
		if dw_task_list.rowcount( )= 0 then
			wf_initialize_tasklist( ll_vessel_nr , ls_voyage_nr)
			dw_task_list.retrieve( ll_vessel_nr, ls_voyage_nr)
		end if
end choose

cb_refresh.triggerevent(clicked!)

_set_interface( 0, 1)

/* Refresh Bunker Window if open */
if isValid(w_bunker_purchase) then
	w_bunker_purchase.postevent("ue_refresh")
end if

end event

type tab_poc from tab within w_port_of_call_bak
event create ( )
event destroy ( )
integer x = 37
integer y = 800
integer width = 4517
integer height = 1680
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_act tabpage_act
tabpage_est tabpage_est
tabpage_voy_text tabpage_voy_text
tabpage_att tabpage_att
tabpage_vessel_text tabpage_vessel_text
tabpage_port_details tabpage_port_details
tabpage_owners_matters tabpage_owners_matters
tabpage_bunker_stock tabpage_bunker_stock
end type

on tab_poc.create
this.tabpage_act=create tabpage_act
this.tabpage_est=create tabpage_est
this.tabpage_voy_text=create tabpage_voy_text
this.tabpage_att=create tabpage_att
this.tabpage_vessel_text=create tabpage_vessel_text
this.tabpage_port_details=create tabpage_port_details
this.tabpage_owners_matters=create tabpage_owners_matters
this.tabpage_bunker_stock=create tabpage_bunker_stock
this.Control[]={this.tabpage_act,&
this.tabpage_est,&
this.tabpage_voy_text,&
this.tabpage_att,&
this.tabpage_vessel_text,&
this.tabpage_port_details,&
this.tabpage_owners_matters,&
this.tabpage_bunker_stock}
end on

on tab_poc.destroy
destroy(this.tabpage_act)
destroy(this.tabpage_est)
destroy(this.tabpage_voy_text)
destroy(this.tabpage_att)
destroy(this.tabpage_vessel_text)
destroy(this.tabpage_port_details)
destroy(this.tabpage_owners_matters)
destroy(this.tabpage_bunker_stock)
end on

event selectionchanged;long ll_row
string ls_responsible_psm

if newindex = 7 then
	ll_row = tab_poc.tabpage_owners_matters.dw_department_info.getrow()
	if ll_row > 0 then
		ls_responsible_psm = tab_poc.tabpage_owners_matters.dw_department_info.getitemstring(ll_row, "responsible_psm", primary!, true)
		if ls_responsible_psm = "" or isnull(ls_responsible_psm) then
			tab_poc.tabpage_owners_matters.uo_attach.enabled =false
		else
			tab_poc.tabpage_owners_matters.uo_attach.enabled = true
		end if
	end if
	tab_poc.width = 4517
	st_warning.visible = false
else
	tab_poc.width = 3383
	st_warning.visible = true
end if

end event

type tabpage_act from userobject within tab_poc
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Actual"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
cb_dep_bunker cb_dep_bunker
cb_change_tc cb_change_tc
cb_newact cb_newact
cb_updateact cb_updateact
cb_deleteactual cb_deleteactual
cb_cancel_actual cb_cancel_actual
dw_port_of_call dw_port_of_call
end type

on tabpage_act.create
this.cb_dep_bunker=create cb_dep_bunker
this.cb_change_tc=create cb_change_tc
this.cb_newact=create cb_newact
this.cb_updateact=create cb_updateact
this.cb_deleteactual=create cb_deleteactual
this.cb_cancel_actual=create cb_cancel_actual
this.dw_port_of_call=create dw_port_of_call
this.Control[]={this.cb_dep_bunker,&
this.cb_change_tc,&
this.cb_newact,&
this.cb_updateact,&
this.cb_deleteactual,&
this.cb_cancel_actual,&
this.dw_port_of_call}
end on

on tabpage_act.destroy
destroy(this.cb_dep_bunker)
destroy(this.cb_change_tc)
destroy(this.cb_newact)
destroy(this.cb_updateact)
destroy(this.cb_deleteactual)
destroy(this.cb_cancel_actual)
destroy(this.dw_port_of_call)
end on

type cb_dep_bunker from mt_u_commandbutton within tabpage_act
integer x = 18
integer y = 1452
integer width = 498
integer taborder = 30
string text = "Dept. &Bunker Value"
end type

event clicked;call super::clicked;
s_port_departure_values_parameter lstr_parm

If w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.RowCount() < 1 THEN Return

lstr_parm.vessel		= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getItemNumber(1,"vessel_nr")
lstr_parm.voyage		= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getItemString(1,"voyage_nr")
lstr_parm.portcode	= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getItemString(1,"port_code")
lstr_parm.pcn			= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getItemNumber(1,"pcn")

if isValid(w_bunker_departure_values) then close(w_bunker_departure_values)

OpenSheetWithParm(w_bunker_departure_values, lstr_parm, w_tramos_main )
end event

type cb_change_tc from mt_u_commandbutton within tabpage_act
integer x = 521
integer y = 1452
integer width = 526
integer taborder = 40
string text = "Change &TC Contract"
end type

event clicked;call super::clicked;
long ll_contractID, ll_null;setNull(ll_null)
string ls_purpose

if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() < 1 then return

ls_purpose 	 = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"purpose_code")

if ls_purpose <> "DEL" and ls_purpose <> "RED" then return

ll_contractID = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getItemNumber(1, "contract_id") //Store current contractID

w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItem(1, "contract_id", ll_null)  //Set contractID to NULL to ensure dialog box

if wf_connecttccontract( w_port_of_call.tab_poc.tabpage_act.dw_port_of_call) = -1 then
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setItem(1, "contract_id", ll_contractID)   //Set ContractID back to original
	w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.setitemstatus( 1, "contract_id",Primary!, NotModified!)
end if

end event

type cb_newact from mt_u_commandbutton within tabpage_act
integer x = 1929
integer y = 1452
integer taborder = 50
string text = "&New"
end type

event clicked;call super::clicked;//=======================================================================================================================
//   <HISTORY>
//   	Date       	CR-Ref       Author     Comments
//   	23/05/2011  CR2410      WWG004      Can't new an actual POC when there are at least one estimated poc before this. 
//		24/05/2011  CR2408		LHC010	   Can't new an actual POC when the voyage was on Subs.
//													
//   </HISTORY>
//=======================================================================================================================

integer	li_getrow, li_sel_row, li_find_est,li_voyage_on_subs
string	ls_status, ls_find_est, ls_voyage_nr

if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() = 1 then return
if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount() = 1 then return

if ii_vessel_nr = 0 then return

//CR2410, CR2408 begin added by WWG004 and LHC010 on 22/06/2011. change desc: can't new an actual POC.
li_getrow = dw_proc_pcnc.getselectedrow(0)

if li_getrow < 1 or isnull(li_getrow) then return

ls_find_est	= "compute_1 = 'Estimated'"
li_find_est	= dw_proc_pcnc.find(ls_find_est, 1, li_getrow - 1)

ls_voyage_nr = dw_proc_pcnc.getitemstring(li_getrow, "proceed_voyage_nr")

SELECT VOYAGE_ON_SUBS INTO :li_voyage_on_subs FROM VOYAGES WHERE VESSEL_NR = :ii_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;

if li_voyage_on_subs = 1 then
	messagebox("Warning", "You cannot create a new Actual POC when the voyage is set 'on Subs' in Proceeding.")
	return 
end if

if li_find_est > 0 and li_getrow > 1 then
	messagebox("Validation", "You cannot create a new Actual POC, because there is at least one Estimated POC before this.", Information!)
	return
end if
//CR2410, CR2408 end added by WWG004 and LHC010 on 22/06/2011.

w_port_of_call.TriggerEvent("ue_insert")

end event

type cb_updateact from mt_u_commandbutton within tabpage_act
integer x = 2277
integer y = 1452
integer taborder = 50
string text = "&Update"
end type

event clicked;call super::clicked;/*
- Accept text
- Clean comment field
- Check Mandatory fields and if SLOP is mandatory
- If purpose is DEL or RED check if is connect to a TC Hire contract
- Dates validation
- Check tc out delivery and redelivery
- Validation using the check module - bunker check
- Check changes in the purpose: If purpose changed (from L, D, L/D to something that is not L/D)  then check registered cargoes
- 
*/

/* Declare local variables */
u_check_functions		lu_check

integer	ll_vessel_nr, li_pcn, li_count
integer 	li_exists_DEL_or_RED, li_no_of_cargoes 
long		ll_rc, ll_contractID, ll_null, ll_getrow, ll_ownid
string	ls_purpose, ls_voyage_nr, ls_port_code, ls_original_purpose, ls_bunkermessage, ls_null, ls_tank
boolean	lb_result, lb_departure_modified, lb_refresh_tasklist, lb_success
datetime	ldt_arrival, ldt_departure, ldt_est_arr_dt
decimal{4} ldc_slopwater, ldc_slopoil
string ls_setcol

n_bunker_posting_control  lnv_bunkerControl
datawindowchild ldwc_purposelist

//CR2410 begin added by WWG004 on 31/05/2011
integer	li_autoscheduleupdated

mt_u_datawindow	ldw_poc, ldw_department_info, ldw_department_list
//CR2410 end added by WWG004 on 31/05/2011

setNull(ll_null)
setNull(ls_null)

ldw_poc					= w_port_of_call.tab_poc.tabpage_act.dw_port_of_call
ldw_department_info	= w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info
ldw_department_list	= w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list

if ldw_poc.rowcount() < 1 then return

//CR2535 & 2536 Added by ZSW001 on 17/11/2011
ib_allowclose = false

//Accepttext
if ldw_poc.accepttext() = -1 then
	ldw_poc.setfocus()
	return
end if

// CHECK - WHETHER COMMENTS CONTAINS ' OR " IF SO ASK TO CHANGE AND RETURN
if ldw_poc.getitemstatus(1, "comments", primary!) = dataModified! then
	ldw_poc.setitem(1, "comments", wf_replace_special_char(ldw_poc.getitemstring(1, "comments")))
end if

//Check Mandatory fields
IF IsNull(ldw_poc.GetItemDateTime(1,"port_arr_dt")) OR IsNull(ldw_poc.GetItemString(1,"purpose_code"))  THEN
	MessageBox("Input Missing","Arrival date and purpose must be filled out.")
	Return
END IF

//CR20 Modified by LHC010 on 10-04-2012. Change desc: 
// If Slop is mandatory and departure HFO or departure LSHFO(CR2719) are not zero, then SLOP is a mandatory field
if ldw_poc.getItemNumber(1, "poc_slop_mandatory") = 1 and (ldw_poc.getItemNumber(1, "dept_hfo") <> 0 or ldw_poc.getItemNumber(1, "dept_lshfo") <> 0) then
	ls_tank = ldw_poc.getitemstring(1, "tank_name")
	ldc_slopwater = ldw_poc.getItemNumber(1, "slop")
	ldc_slopoil = ldw_poc.getitemnumber( 1, "oil")
	
	if ls_tank = "" or isnull(ls_tank) or ldc_slopwater < 0 or isnull(ldc_slopwater) or ldc_slopoil < 0 or isnull(ldc_slopoil) then		
		MessageBox("Input Missing","SLOP field is mandatory. Please correct.")
		Return
	end if
end if

ll_vessel_nr = ldw_poc.getitemnumber(1,"vessel_nr")
ls_purpose 	 = ldw_poc.getitemstring(1,"purpose_code")
ls_voyage_nr = ldw_poc.getitemstring(1,"voyage_nr")
ls_port_code = ldw_poc.getitemstring(1,"port_code")
li_pcn = ldw_poc.getitemNumber(1,"pcn")
ll_contractID = ldw_poc.getitemNumber(1,"contract_id")

il_vessel_nr = ll_vessel_nr

/* If purpose is DEL or RED checks if this voyage/portcall shall be connected to a TC Contract or not */
if ls_purpose = "DEL" or ls_purpose = "RED" then
	if wf_connecttccontract( ldw_poc) = -1 then return
end if	

//------------------------------------------------------------------------------------------------------
// VALIDATION 1: Check arrival and departure dates: Arrival date >= Departure date
ldt_arrival 	= ldw_poc.getitemdatetime(1,"port_arr_dt")
ldt_departure 	= ldw_poc.getitemdatetime(1,"port_dept_dt")

//CR2410 Added by ZSW001 on 15/07/2011
if wf_validate(ii_ACTUAL) = c#return.failure then return

/* Check Bunker for delivery on TC-OUT Contract */
wf_check_bunker_tcout_delivery( )

/* Check Bunker for Redelivery on TC-OUT Contract */
wf_check_bunker_tcout_redelivery( )

/* Validation using the check module */
string ls_message
lu_check = create u_check_functions

if lu_check.uf_is_first_poc(ll_vessel_nr, ldt_arrival, ls_voyage_nr ) or dw_proc_pcnc.rowcount() = 1 then
	if ldw_poc.getitemnumber(1,"arr_hfo") > 0 or &
		ldw_poc.getitemnumber(1,"arr_do") > 0 or &
		ldw_poc.getitemnumber(1,"arr_go") > 0 or &
		ldw_poc.getitemnumber(1,"arr_lshfo") > 0  then
			ls_message="The first Port of Call for a vessel can not have HSFO, LSFO, LSGO and HSGO registered on the arrival.~r~n"

			if messagebox("Notice",ls_message + "~r~n Do You want to continue?",Question!,YesNo!,2) = 2 then
				ldw_poc.setfocus()
				destroy lu_check
				return
			end if
			
	end if
end if

ls_original_purpose =  ldw_poc.GetItemString(1,"purpose_code", PRIMARY!, TRUE)

//-------------------------------
//VALIDATION PURPOSE 1.A

ldw_poc.getchild("purpose_code", ldwc_purposelist)
if ldwc_purposelist.find("purpose_code='" + ls_purpose + "'",1,1000)=0 then

	messagebox("Validation Error - update failed","The Purpose Code you entered is not valid.  Resetting purpose to original code. Please use a code that is included in the dropdown list.")
	ldw_poc.post setItem(1,"purpose_code", ls_original_purpose)
	ldw_poc.post setcolumn("purpose_code")
	ldw_poc.post setfocus()
	
	return 
end if

//-------------------------------
//VALIDATION PURPOSE 1.B
/* If purpose changed (from L, D, L/D to something that is not L/D)  then check registered cargoes */

IF (ls_original_purpose = "L"  or ls_original_purpose = "D" or ls_original_purpose = "L/D")  and (ls_original_purpose <> ls_purpose ) and (ls_purpose <> "L/D") THEN 
	
	SELECT count(*)  
		INTO :li_no_of_cargoes  
		FROM CARGO  
		WHERE CARGO.VESSEL_NR = :ll_vessel_nr AND  
				CARGO.VOYAGE_NR = :ls_voyage_nr AND  
				CARGO.PORT_CODE = :ls_port_code AND  
				CARGO.PCN = :li_pcn   
	COMMIT;
	
	if li_no_of_cargoes > 0 then
		MessageBox("Validation Error", "You cannot change purpose for a port of call where cargo is registred.")
		
		ldw_poc.post setItem(1,"purpose_code", ls_original_purpose)
		ldw_poc.post setcolumn("purpose_code")
		ldw_poc.post setfocus()
		return 
	end if
	
end if

//-------------------------------
//VALIDATION PURPOSE 2
//Validates purposes L, D, L/D against calculation

If ls_purpose = "L" or ls_purpose = "D" or ls_purpose ="L/D" then
	if not wf_port_code_ok(ls_purpose,ll_vessel_nr,ls_voyage_nr,ls_port_code) then
		MessageBox("Validation Error", "Selected Purpose (" + ls_purpose + ") is not valid for this port of call.~n~r~n~rIn order to be able to use this purpose, goto the Calculation system and correct the cargo ports.")		
		
		//CR2517 Begin added by ZSW001 on 06/09/2011
		//ldw_poc.post setItem(1,"purpose_code", ls_null)
		ldw_poc.post setItem(1, "purpose_code", ls_original_purpose)
		ldw_poc.post setitemstatus(1, "purpose_code", primary!, notmodified!)
		//CR2517 End added by ZSW001 on 06/09/2011
		
		ldw_poc.post setcolumn("purpose_code")
		ldw_poc.post setfocus()
		return		//CR2410 Added by ZSW001 on 15/07/2011
	end if
end if

//-------------------------------
//VALIDATION PURPOSE 3
//If purpose changed from or to (DEL or RED and if exists bunker registration then is not possible to change purpose
If ls_original_purpose <> ls_purpose then
	if ls_purpose = "DEL" or ls_purpose = "RED" or  ls_original_purpose = "DEL" or ls_original_purpose = "RED" then
		SELECT COUNT(*)
				INTO :li_count
				FROM BP_DETAILS
				WHERE VESSEL_NR = :ll_vessel_nr
				AND VOYAGE_NR = :ls_voyage_nr
				AND PORT_CODE = :ls_port_code
				AND PCN = :li_pcn;
			if li_count > 0 then
				MessageBox("Warning", "It is not possible to change Purpose from/to Delivery/Redelivery when Bunker Purchase is registered.")
				ldw_poc.POST setItem(1, "purpose_code", ls_original_purpose)
				ldw_poc.post setItemStatus( 1, "purpose_code", Primary!, notModified!)
				ldw_poc.post setcolumn("purpose_code")
				ldw_poc.post setfocus()
				return 
			end if
	end if
end if

//If purpose old and new are not DEL and RED then contract_id = null
if ls_original_purpose <> "DEL" and ls_original_purpose <> "RED" and ls_purpose <> "DEL" and ls_purpose <> "RED" then
	if ldw_poc.getitemnumber(1, "contract_id") > 0 then ldw_poc.setItem(1, "contract_id", ll_null)
end if

//-------------------------------
//VALIDATION PURPOSE 4
// Check for duplicate DEL or RED on same voyage
IF ls_purpose = "DEL" OR ls_purpose = "RED" THEN
	SELECT COUNT(*)
		INTO :li_exists_DEL_or_RED
		FROM POC
		WHERE VESSEL_NR = :ll_vessel_nr AND
				SUBSTRING(VOYAGE_NR,1,5) = SUBSTRING(:ls_voyage_nr,1,5) AND
				PURPOSE_CODE = :ls_purpose AND (PORT_CODE <> :ls_port_code AND PCN <> :li_pcn);
	Commit;
	IF li_exists_DEL_or_RED > 0 THEN
		MessageBox("Error","It is not allowed to have two purposes " + ls_purpose + " on the same voyage.")
		Return
	END IF	
END IF

//CR2516: bunker mismatch then return
if lu_check.of_check_portbunker(ldw_poc, ls_setcol, ls_message) = c#return.Failure then
	messagebox("Notice", ls_message + "~r~n~r~n" + "You MUST correct the error !")
	if len(ls_setcol) > 0 then
		ldw_poc.setcolumn(ls_setcol)		
		setfocus(ldw_poc)
	end if
	destroy lu_check
	return
end if

//VALIDATION PURPOSE 5
/* purposes CHO */
if  ls_original_purpose = "CHO"  and ls_original_purpose <> ls_purpose  then
	SELECT count(*) INTO :li_count
	FROM LAYTIME_STATEMENTS 
	WHERE LAYTIME_STATEMENTS.VESSEL_NR = :ll_vessel_nr AND
			LAYTIME_STATEMENTS.VOYAGE_NR = :ls_voyage_nr AND
			LAYTIME_STATEMENTS.PORT_CODE = :ls_port_code AND
			LAYTIME_STATEMENTS.PCN = :li_pcn ;
	
	if li_count > 0 then
		if MessageBox("Modify Purpose","Entered laytime will be lost.~r~n~r~n" + &
								  "Do you want to continue?", Exclamation!, YesNo!, 2) = 2 then 
			ldw_poc.post setItem(1,"purpose_code", ls_original_purpose)
			ldw_poc.post setcolumn("purpose_code")
			ldw_poc.post setfocus()						  					  
	      	return 
		end if
		wf_check_laytime(ll_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)
	end if	
end if

//Checks if bunker values changed
if ldw_poc.getitemstatus(1,"dept_hfo", primary!) = dataModified!  &
	or ldw_poc.getitemstatus(1,"dept_do", primary!) = dataModified! &
	or	ldw_poc.getitemstatus(1,"dept_go", primary!) = dataModified! &
	or	ldw_poc.getitemstatus(1,"dept_lshfo", primary!) = dataModified! then
	
	lb_departure_modified = true
else
	lb_departure_modified = false
end if

//Updates time and user stamps
if ldw_poc.getitemstatus(1,"port_arr_dt", primary!) = dataModified!  &
	or ldw_poc.getitemstatus(1,"port_berthing_time", primary!) = dataModified! &
	or	ldw_poc.getitemstatus(1,"port_dept_dt", primary!) = dataModified! &
	or	ldw_poc.getitemstatus(1,"purpose_code", primary!) = dataModified! &
	or	ldw_poc.getitemstatus(1,"agents_agent_sn", primary!) = dataModified! then
	
		ldw_poc.setitem(1,"poc_local_dates_updated", now()  )
		ldw_poc.setitem(1,"poc_dates_updated_by",uo_global.is_userid)
end if

if ldw_poc.getitemstatus(1,"comments", primary!) = dataModified! then
	
	ldw_poc.setitem(1,"poc_comments_updated", now()  )
	ldw_poc.setitem(1,"poc_comments_updated_by", uo_global.is_userid )
end if

//If purpose changed, then refresh task list
if ldw_poc.getitemstatus(1,"purpose_code", primary!) = dataModified! &
	or ldw_poc.getitemstatus(1,"purpose_code", primary!) = New! then
	
	lb_refresh_tasklist = true 
end if

//CR2410 begin added by WWG004 on 31/05/2011. Change desc: Auto schedule calculate date.
il_modifiedrow = w_port_of_call.dw_proc_pcnc.getselectedrow(0)


//CR2535 & 2536 Begin added by ZSW001 on 29/10/2011
//li_autoscheduleupdated = _doautoschedule(ii_ACTUAL)

lb_success = true
if ib_doschedule then
	lb_success = inv_autoschedule.of_calculateschedule(dw_proc_pcnc, ldw_poc, ii_ACTUAL, rb_only_this_year.checked)
end if

if lb_success then
	//CR20 Added by LHC010 on 09-04-2012. Change desc: set MSPS_TFV zero
	if ldw_poc.modifiedcount( ) > 0 then
		ldw_poc.setitem( 1, "msps_tfv", 0)
	end if
	
	if ldw_poc.update() = 1 then
		if ldw_department_info.rowcount() > 0 then
			if ldw_department_info.update() = 1 then
				ll_ownid = ldw_department_info.getitemnumber(1, "owner_department_id")
				
				for ll_getrow = 1 to ldw_department_list.rowcount()
					ldw_department_list.setitem(ll_getrow, "owner_department_id", ll_ownid)
				next
				
				ldw_department_list.accepttext()
				
				if ldw_department_list.update() = 1 then
					commit;
					w_port_of_call.tab_poc.tabpage_owners_matters.enabled = true
					ib_new = false
				else
					rollback;
					messagebox("Update failed", "Error updating Actual POC!")
					return
				end if
			else	//Department info update failed
				rollback;
				messagebox("Update failed", "Error updating Actual POC!")
				return
			end if
		else	//Not exist department, commit POC
			commit;	
		end if
			
		openwithparm(w_updated, 0, w_tramos_main)
	else
		rollback;
		messagebox("Update failed", "Error updating Actual POC!")
		return
	end if
	
	 wf_update_timebar(ll_vessel_nr, ls_voyage_nr)
	
else
	messagebox("Update failed", "Error updating Actual POC!")
	return
end if
//CR2535 & 2536 End added by ZSW001 on 29/10/2011

//CR2535 & 2536 Added by ZSW001 on 17/11/2011
ib_allowclose = true

w_port_of_call.postevent("ue_retrieve")
w_port_of_call.cb_refresh.postevent("clicked")
				
//CR2410 end added by WWG004 on 31/05/2011.

_set_interface(0, 1)

if lb_refresh_tasklist = true then
	wf_refresh_task_list( ll_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn, 0)
end if

/* Checks if next voyage bunker consomption has to be reposted */
if lb_departure_modified then
	lnv_bunkerControl = create n_bunker_posting_control  	
	lnv_bunkerControl.of_portofcall_departure_modified( ll_vessel_nr , ls_voyage_nr )
	destroy lnv_bunkerControl
end if

setNull(ldt_est_arr_dt)
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_port_arr_dt", ldt_est_arr_dt)
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_port_arr_dt", ldt_arrival )
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_purpose_code", ls_purpose)
wf_set_voyage_alert_status("ACT", dw_proc_pcnc.getselectedrow(0))
dw_proc_pcnc.accepttext( )
dw_proc_pcnc.groupCalc()

ls_message = ""

/* check poc dates 
	every time a port of call is saved we check an interval of +/- 60 days */
if isNull(ldt_departure) then
	ll_rc =lu_check.uf_check_poc_arr_dates(ll_vessel_nr,datetime(relativedate(date(ldt_arrival), -60)), datetime(relativedate(date(ldt_arrival), 60)), ls_message)
else
	ll_rc =lu_check.uf_check_poc_arr_dates(ll_vessel_nr,datetime(relativedate(date(ldt_arrival), -60)), datetime(relativedate(date(ldt_departure), 60)), ls_message)
end if

if ll_rc < 0 then
	ls_message="Registration of Port of Call periods failed.~r~n"+ls_message+"~r~n~r~n"
end if

if lb_result=lu_check.uf_check_bunker(ll_vessel_nr,ls_voyage_nr, ls_bunkermessage) then
	ls_message+="Mismatch in bunker registration.~r~n~r~n"+ls_bunkermessage+"~r~n~r~n"
end if

if len(ls_message) > 0 then
	messagebox("Notice",ls_message + "You MUST correct the error !")
end if
	
/* destroy object */
destroy lu_check

dw_proc_pcnc.setfocus( )

end event

type cb_deleteactual from mt_u_commandbutton within tabpage_act
integer x = 2624
integer y = 1452
integer taborder = 40
string text = "&Delete"
end type

event clicked;call super::clicked;
if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() < 1 then return

w_port_of_call.TriggerEvent("ue_delete")

end event

type cb_cancel_actual from mt_u_commandbutton within tabpage_act
integer x = 2971
integer y = 1452
integer taborder = 30
string text = "C&ancel"
end type

event clicked;call super::clicked;/*
Reset Actual POC
Retrieves
*/

integer 	ll_rows_act, li_pcn, li_row
string	ls_voyage_nr, ls_port_code

if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() < 1 then return

w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Reset()

li_row = dw_proc_pcnc.getselectedrow( 0)
ls_voyage_nr = dw_proc_pcnc.GetItemString(li_row,"proceed_voyage_nr")
ls_port_code = dw_proc_pcnc.GetItemString(li_row,"proceed_port_code")
li_pcn = dw_proc_pcnc.GetItemNumber(li_row,"proceed_pcn")

ll_rows_act =  w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.Retrieve(ii_vessel_nr,ls_voyage_Nr,ls_port_code,li_pcn) 
	
_set_interface(0, ll_rows_act)

il_modifiedrow = 0

if ib_new = true then
	w_port_of_call.tab_poc.tabpage_owners_matters.enabled = true
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.reset()
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.reset()
	_set_interface(0, 0)
end if

ib_new = false
end event

type dw_port_of_call from mt_u_datawindow within tabpage_act
integer y = 12
integer width = 3328
integer height = 1428
integer taborder = 60
string dataobject = "dw_port_of_call"
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event clicked;call super::clicked;s_poc_non_cargo_agents ls_struct
long ll_row, ll_returnid
integer 		li_vessel, li_pcn
string			ls_voyage, ls_port, ls_performagent

u_jump_bp	lnv_jump

//CR2408 Added by LGX001 on 19/05/2011. 
long ll_found_row
datawindowchild          ldwc_performing_agent
s_poc_performing_agent   lstr_agent
//w_agentlist              lw_agentlist_performing
 
if row < 1 then return

choose case dwo.name 
	case "comments"
		
			IF this.Object.Datawindow.ReadOnly="yes" or  this.getItemNumber(row, "voyages_voyage_finished") <> 0 THEN 
				openwithparm(w_messageBox ,this.getItemString(row, "comments"))
			END IF
			
	case "b_lifted_details"
		
		IF this.GetItemStatus(1,0,PRIMARY!) <> NotModified! THEN 
			MessageBox("Information", "Port of Call data modified, but not updated.~r~n~r~nPlease update before accessing bunker details.") 
			Return
		end if
		
		ll_row = dw_proc_pcnc.getSelectedRow( ll_row )
		
		li_vessel = dw_proc_pcnc.getItemNumber(ll_row, "proceed_vessel_nr")
		ls_voyage = dw_proc_pcnc.getItemString(ll_row, "proceed_voyage_nr")
		ls_port = dw_proc_pcnc.getItemString(ll_row, "proceed_port_code")
		li_pcn = dw_proc_pcnc.getItemNumber(ll_row, "proceed_pcn")
		
		lnv_jump = create u_jump_bp
		lnv_jump.of_open_bp( li_vessel, ls_voyage, ls_port, li_pcn )
		destroy lnv_jump
			
	case "b_noncargoagent"

		/* If there is no non-cargo agent, inform user and exit */
		if isnull(w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.getitemstring(1,"agents_agent_sn")) then
			messagebox("Notice","You can only add more Non-Cargo agents if the first is filled out.")
			return
		end if

		/* Set structure to send data to non-cargo agents window */
		ll_row = dw_proc_pcnc.getselectedrow(0)
		ls_struct.si_vessel_nr = ii_vessel_nr
		ls_struct.ss_voyage_nr = dw_proc_pcnc.GetItemString(ll_row,"proceed_voyage_nr")
		ls_struct.ss_port_code = dw_proc_pcnc.GetItemString(ll_row,"proceed_port_code")
		ls_struct.si_pcn = dw_proc_pcnc.GetItemNumber(ll_row,"proceed_pcn")
		
		/* Open non-cargo agents window with parameters */
		openwithparm(w_choose_non_cargo_agents,ls_struct)
		
	 //CR2408 Added by LGX001 on 19/05/2011. Change desc: open the Agents window in POC to allow creating or editing Performing Agent 	
	 case 'p_act_performing_agent'  
		this.accepttext( )
		lstr_agent.l_agent_nr = this.getitemnumber(row, 'poc_performing_agent_nr') 
		if isnull(lstr_agent.l_agent_nr) or lstr_agent.l_agent_nr <= 0 then
			lstr_agent.l_agent_nr = 0
			lstr_agent.s_agent_short_name = ''
		end if
		this.getchild( 'agents_performing_agent_sn', ldwc_performing_agent)
		ldwc_performing_agent.settransobject( sqlca)	
		if lstr_agent.l_agent_nr > 0 then
			ll_found_row = ldwc_performing_agent.find("company_id ="  + string(lstr_agent.l_agent_nr), 1, ldwc_performing_agent.rowcount() )
			if ll_found_row  <= 0 then
				lstr_agent.l_agent_nr = 0
				lstr_agent.s_agent_short_name = ''
			else
				lstr_agent.s_agent_short_name = ldwc_performing_agent.getitemstring(ll_found_row, 'company_sn')
			end if
		end if
		
		if isvalid(w_performing_agent) then close(w_performing_agent)
		openwithparm(w_performing_agent, lstr_agent)
		
		ll_returnid =  message.doubleparm
		
		ldwc_performing_agent.retrieve( )
				
		if ll_returnid>0 then
			//select agent
			this.getchild( 'agents_performing_agent_sn', ldwc_performing_agent)
			ldwc_performing_agent.settransobject( sqlca)	
			ll_found_row = ldwc_performing_agent.find("company_id ="  + string(ll_returnid), 1, ldwc_performing_agent.rowcount() )
			if ll_found_row>0 then
				ls_performagent = ldwc_performing_agent.getitemstring(ll_found_row, 'company_sn')
				
				dw_port_of_call.setitem(1,"agents_performing_agent_sn",ls_performagent)
				dw_port_of_call.setitem(1,"poc_performing_agent_nr",ll_returnid)
			else
				messagebox("test", "not found")
			end if
		end if
	case "p_refresh"
		wf_calculate_tce(0)
end choose 

end event

event doubleclicked;call super::doubleclicked;
string ls_name
integer li_nr

IF uo_global.ii_access_level = -1 THEN return

if (row > 0) then
	
	CHOOSE CASE dw_port_of_call.getcolumnname()
		CASE "agents_agent_sn"
			ls_name = f_select_from_list("dw_agent_list",1,"Short Name",2,"Full Name",1,"Agent selection",false)
			IF IsNull(ls_name) THEN Return
			
			if ( ls_name = "" ) or Isnull(ls_name) then 
				setnull(li_nr)
				dw_port_of_call.SetItem(1,"poc_agent_nr",li_nr)
				return
			end if
	
			SELECT AGENT_NR
			INTO :li_nr
			FROM AGENTS
			WHERE AGENT_SN = :ls_name;
			commit;
			dw_port_of_call.SetItem(1,"poc_agent_nr",li_nr)
			dw_port_of_call.SetItem(1,"agents_agent_sn",ls_name)
			event itemchanged( row, dwo, ls_name)
	END CHOOSE

end if

end event

event itemchanged;call super::itemchanged;string 	ls_name, ls_voyage_nr, ls_port_code
string 	ls_original_purpose
int 		li_nr, li_pcn, li_no_of_cargoes, li_counter
long 		ll_vessel_nr
string	ls_null; setNull(ls_null)
int		li_null; setNull(li_null)
long		ll_contractID
integer	li_active

//CR2408 Added by LGX001 on 19/05/2011. Change desc: used to get performing agent nr 
long ll_performing_agent_nr
long ll_found_row, ll_count
datawindowchild    ldwc_performing_agent, ldwc_noncargo_agent

/* Case which field was modified */
CHOOSE CASE dwo.name 
	CASE "agents_agent_sn"
		ls_name = data
		if ( ls_name = "" ) or Isnull(ls_name) then 
			/* Check for non cargo agents */
			ll_vessel_nr = this.GetItemnumber(row,"vessel_nr")
			ls_voyage_nr = this.GetItemString(row,"voyage_nr")
			ls_port_code = this.GetItemString(row,"port_code")
			li_pcn = this.getItemNumber(row, "pcn")

			SELECT count(*) 
			INTO :li_counter
			FROM TRA_NCAG
			WHERE VESSEL_NR = :ll_vessel_nr AND
					VOYAGE_NR = :ls_voyage_nr AND
					PORT_CODE = :ls_port_code AND
					PCN       = :li_pcn;
			Commit;
			IF (li_counter > 0) THEN
				MessageBox("Delete","You cannot delete the 'Primary' Non-Cargo Agent, when there are more Agents.~r~n~r~nPlease press the <more> button and move/delete the additional agents.")
				this.setItem(row, "agents_agent_sn", this.getItemString(row, "agents_agent_sn", primary!, true))
				return 2
			ELSE
				setnull(li_nr)
				this.SetItem(row,"poc_agent_nr",li_nr)
				return 
			end if
		end if
		
		//CR2408 Added by LGX001 on 08/07/2011. Change desc:  when the user manually enters an agent that doesn't exist in the dddw
		this.getchild('agents_agent_sn', ldwc_noncargo_agent)
		ldwc_noncargo_agent.settransobject(sqlca)
		ll_count = ldwc_noncargo_agent.rowcount( )
		ll_found_row = ldwc_noncargo_agent.find("upper(agent_sn)  = '" + upper(ls_name) + "'",  1, ll_count)
		if ll_found_row  <= 0 then
			this.setitem(row, "agents_agent_sn", ls_null)
			this.SetItem(row,"poc_agent_nr",li_null)
			messagebox("Validation Error", "This non-cargo agent does not exist. Please select another agent.")
			return  2
		else
			li_nr = ldwc_noncargo_agent.getitemnumber(ll_found_row, 'agent_nr')
		end if
				
		if f_agent_active( li_nr) = false then 
			MessageBox("Validation Error", "Selected Agent is marked as inactive. Please select another Agent.")
			if this.getItemString(row, "agents_agent_sn", primary!, true) <>  this.getItemString(row, "agents_agent_sn", primary!, false) then
				this.setItem(row, "agents_agent_sn", this.getItemString(row, "agents_agent_sn", primary!, true) )
			else
				this.setItem(row, "agents_agent_sn", ls_null)
				this.SetItem(row,"poc_agent_nr",li_null)
			end if
			setColumn("agents_agent_sn")
			return 2
		end if
		dw_port_of_call.SetItem(row,"poc_agent_nr",li_nr)
 
  //CR2408 Added by LGX001 on 13/05/2011. Change desc: validate the performing agent
CASE "agents_performing_agent_sn"  
	ls_name = data
	if ( ls_name = "" ) or isnull(ls_name) then
	this.setitem(row, "poc_performing_agent_nr",li_null)
	return 
	end if
	this.getchild('agents_performing_agent_sn', ldwc_performing_agent)
	ldwc_performing_agent.settransobject(sqlca)
	ll_count = ldwc_performing_agent.rowcount( )
	ll_found_row = ldwc_performing_agent.find("upper(company_sn)  = '" + upper(ls_name) + "'",  1, ll_count)
	if ll_found_row  <= 0 then
	this.setitem(row, "poc_performing_agent_nr", li_null)
	this.setitem(row, "agents_performing_agent_sn", ls_null)
	messagebox("Validation Error", "This performing agent does not exist. Please select another agent.")
	return  2
	else
	ll_performing_agent_nr = ldwc_performing_agent.getitemnumber(ll_found_row, 'company_id')
	this.setitem(row, "poc_performing_agent_nr", ll_performing_agent_nr)
	end if

END CHOOSE

//CR2535 & 2536 Added by ZSW001 on 14/11/2011
if dwo.name = "port_arr_dt" or dwo.name = "port_berthing_time" or dwo.name = "port_dept_dt" or dwo.name = "purpose_code" then
	this.setitem(row, "autoschedule_status", 0)
	choose case dwo.name
		case "port_arr_dt"
			this.setitem(row, "auto_arr_status", 0)
		case "port_berthing_time"
			this.setitem(row, "auto_ber_status", 0)
		case "purpose_code"
			inv_autoschedule.of_set_portstay(this, ii_ACTUAL, false)
		case "port_dept_dt"
			this.setitem(row, "auto_dept_status", 0)
			inv_autoschedule.of_setetdmodified(true)
	end choose
end if

//CR20 Added by LHC010 on 09-04-2012. Change desc: The purpose TFV should not be used when users create or update POCs manually, 
//it should be only used when approving messages from vessels
if dwo.name = "purpose_code" then
	if upper(data) = "TFV" then
		messagebox("Validation Error", "The purpose 'TFV' should not be used.")
		return 1	
	end if
end if
end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, tab_poc.tabpage_act.dw_port_of_call)
end event

event buttonclicked;call super::buttonclicked;//CR2531 Begin added by ZSW001 on 01/09/2011
choose case dwo.name
	case "b_estcargo"
		wf_goto_est_cargo(0)		//0: Actual; 1: Estimated
	case else
		//None
end choose
//CR2531 End added by ZSW001 on 01/09/2011

end event

event retrieveend;call super::retrieveend;//CR2535 & 2536 Added by ZSW001 on 26/10/2011
inv_autoschedule.of_set_steamingtime(dw_proc_pcnc, this, ii_ACTUAL)
inv_autoschedule.of_set_portstay(this, ii_ACTUAL, false)
inv_autoschedule.of_setetdmodified(false)
ib_allowclose = true

end event

event itemerror;call super::itemerror;if dwo.name = "purpose_code" then
	return 1
end if

end event

event ue_dwkeypress;call super::ue_dwkeypress;string ls_null

if key = KeyDelete! or key = KeyBack! then
	setNull(ls_null)
	choose case this.getColumnName()
		case "poc_wd_code" 
			this.setitem(this.getrow(),'poc_wd_code',ls_null)
	end choose
end if
end event

type tabpage_est from userobject within tab_poc
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Estimated"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
cb_move_est_act cb_move_est_act
cb_newest cb_newest
cb_updateest cb_updateest
cb_deleteest cb_deleteest
cb_cancel_est cb_cancel_est
dw_port_of_call_est dw_port_of_call_est
end type

on tabpage_est.create
this.cb_move_est_act=create cb_move_est_act
this.cb_newest=create cb_newest
this.cb_updateest=create cb_updateest
this.cb_deleteest=create cb_deleteest
this.cb_cancel_est=create cb_cancel_est
this.dw_port_of_call_est=create dw_port_of_call_est
this.Control[]={this.cb_move_est_act,&
this.cb_newest,&
this.cb_updateest,&
this.cb_deleteest,&
this.cb_cancel_est,&
this.dw_port_of_call_est}
end on

on tabpage_est.destroy
destroy(this.cb_move_est_act)
destroy(this.cb_newest)
destroy(this.cb_updateest)
destroy(this.cb_deleteest)
destroy(this.cb_cancel_est)
destroy(this.dw_port_of_call_est)
end on

type cb_move_est_act from mt_u_commandbutton within tabpage_est
integer x = 18
integer y = 1452
integer width = 498
integer taborder = 30
string text = "&Move Est. to Act."
end type

event clicked;call super::clicked;//============================================================================
//   <HISTORY>
//   	Date       	CR-Ref      Author  Comments
//   	11/05/2011  CR2410      WWG004  Can't change an estimated POC to an Actual POC when there are one or more 
//												  Estimated POC at the previous.
//		24/05/2011  CR2408		LHC010  Can't move an estimated POC to an Actual POC when voyage is on subs
//    07/06/2011  CR2408      LGX001  Add the performing agent from Est to ACT
//    05/09/2011  CR2508      LGX001  Estimated POC should not be moved to actual when arrival date is after departure date
//	  27/11/2014  CR3813	  CCY018	 Move Estimated Bunker to actual
//   </HISTORY>
//============================================================================

Datetime ldt_arr, ldt_dept, ldt_berthing, ldt_null, ldt_local_dates_updated, ldt_comments_updated ;setNull(ldt_null)
String ls_purpose, ls_agent_sn, ls_comments,ls_voyage_nr,ls_port_code, ls_updatedby, ls_comments_updated_by, ls_cargo_list
Long ll_row,ll_agent_nr,ll_pcn,ll_vessel_nr, ll_autostatus, ll_arr_status, ll_ber_status, ll_dept_status
Decimal ld_ordered_hfo,ld_ordered_do,ld_ordered_go, ld_ordered_lshfo
boolean lb_slop_mandatory
long ll_null;setNull(ll_null)
decimal{4} ldc_freshwater, ldc_slopwater, ldc_oil 
string ls_tankname
decimal ld_arr_hfo, ld_arr_do, ld_arr_go, ld_arr_lshfo, ld_dept_hfo, ld_dept_do, ld_dept_go, ld_dept_lshfo
string ls_setcol

//CR2408 Added by LGX001 on 16/05/2011.   
long   ll_performing_agent_nr  
string ls_performing_agent_sn  

integer	li_voyage_on_subs, li_msps_tfv
mt_u_datawindow ldw_poc, ldw_poc_est
u_check_functions lu_check

ldw_poc_est = w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est
ldw_poc = w_port_of_call.tab_poc.tabpage_act.dw_port_of_call

ldw_poc_est.accepttext( )

if ldw_poc_est.rowcount( ) < 1 then return

ll_row = ldw_poc_est.GetRow()

ll_agent_nr =  ldw_poc_est.GetItemNumber(ll_row,"poc_est_agent_nr")
ll_pcn =  ldw_poc_est.GetItemNumber(ll_row,"poc_est_pcn")
ll_vessel_nr =  ldw_poc_est.GetItemNumber(ll_row,"poc_est_vessel_nr")
ls_voyage_nr =  ldw_poc_est.GetItemString(ll_row,"poc_est_voyage_nr")
ls_port_code =  ldw_poc_est.GetItemString(ll_row,"poc_est_port_code")
ldt_arr =  ldw_poc_est.GetItemDatetime(ll_row,"poc_est_port_arr_dt")
ldt_dept = ldw_poc_est.GetItemDatetime(ll_row,"poc_est_port_dept_dt")
ls_purpose = ldw_poc_est.GetItemString(ll_row,"poc_est_purpose_code")
ls_agent_sn = ldw_poc_est.GetItemString(ll_row,"agents_agent_sn")
ls_comments = ldw_poc_est.GetItemString(ll_row,"poc_est_comments")
ldt_berthing = ldw_poc_est.GetItemDatetime(ll_row,"poc_est_port_berthing_time")
ll_autostatus = ldw_poc_est.getitemnumber(ll_row, "autoschedule_status")		//CR2535 & 2536 Added by ZSW001 on 10/11/2011

ldt_local_dates_updated = ldw_poc_est.GetItemDatetime(ll_row,"poc_est_local_dates_updated")
ls_updatedby = ldw_poc_est.GetItemString(ll_row,"poc_est_dates_updated_by")
ldt_comments_updated = ldw_poc_est.GetItemDatetime(ll_row,"poc_est_comments_updated")
ls_comments_updated_by=ldw_poc_est.GetItemString(ll_row,"poc_est_comments_updated_by")

ll_arr_status  = ldw_poc_est.getitemnumber(ll_row, "auto_arr_status")
ll_ber_status  = ldw_poc_est.getitemnumber(ll_row, "auto_ber_status")
ll_dept_status = ldw_poc_est.getitemnumber(ll_row, "auto_dept_status")

//CR2408 Added by LGX001 on 16/05/2011.  
ll_performing_agent_nr = ldw_poc_est.getitemnumber(ll_row, "poc_est_performing_agent_nr")  
ls_performing_agent_sn = ldw_poc_est.getitemstring(ll_row, "agents_performing_agent_sn")

//CR20 Added by LHC010 on 10-04-2012. Change desc: 
ldc_freshwater  = ldw_poc_est.getitemnumber(ll_row, "fresh_water")
ldc_slopwater   = ldw_poc_est.getitemnumber(ll_row, "slop")
ldc_oil 			 = ldw_poc_est.getitemnumber(ll_row, "oil")
li_msps_tfv		 = ldw_poc_est.getitemnumber(ll_row, "msps_tfv")
ls_tankname		 = ldw_poc_est.getitemstring(ll_row, "tank_name")

ld_arr_hfo = ldw_poc_est.getitemdecimal(ll_row, "poc_est_arr_hfo")
ld_arr_do = ldw_poc_est.getitemdecimal(ll_row, "poc_est_arr_do")
ld_arr_go = ldw_poc_est.getitemdecimal(ll_row, "poc_est_arr_go")
ld_arr_lshfo = ldw_poc_est.getitemdecimal(ll_row, "poc_est_arr_lshfo")
ld_dept_hfo = ldw_poc_est.getitemdecimal(ll_row, "poc_est_dept_hfo")
ld_dept_do = ldw_poc_est.getitemdecimal(ll_row, "poc_est_dept_do")
ld_dept_go = ldw_poc_est.getitemdecimal(ll_row, "poc_est_dept_go")
ld_dept_lshfo = ldw_poc_est.getitemdecimal(ll_row, "poc_est_dept_lshfo")

//CR2508 Added by LGX001 on 05/09/2011. 
if isnull(ldt_arr) or isnull(ls_purpose) or ls_purpose = '' then
	messagebox('Input Missing', "Arrival date or purpose must be filled out.~r~nData is not moved.")
	return
elseif (not isnull(ldt_dept) and ldt_arr >= ldt_dept) then
	messagebox("Validation", "Arrival date must be before departure date.~r~nData is not moved.")
	return
end if

//CR2410 begin added by WWG004 on 07/06/2011.
if _checkestpocbefore() then
	messagebox("Validation", "You cannot move a POC from Estimated to Actual when there is one or more Estimated POC before this.")
	return
end if
//CR2410 end added by WWG004.

//CR2408 begin added by LHC010 on 24-05-2011.
SELECT VOYAGE_ON_SUBS INTO :li_voyage_on_subs FROM VOYAGES WHERE VESSEL_NR = :ll_vessel_nr AND VOYAGE_NR = :ls_voyage_nr;
if li_voyage_on_subs = 1 then
	messagebox("Warning", "You cannot move a POC from Estimated to Actual when the voyage is set 'on Subs' in Proceeding.")
	return 
end if
//CR2408 end added

dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_port_arr_dt", ldt_arr)
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_purpose_code", ls_purpose)
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_port_arr_dt", ldt_null)
dw_proc_pcnc.accepttext( )
dw_proc_pcnc.groupcalc( )

// Insert row in actual and set data
ldw_poc.InsertRow(0)
ldw_poc.SetItem(1,"vessel_nr",ll_vessel_nr)
ldw_poc.SetItem(1,"voyage_nr",ls_voyage_nr)
ldw_poc.SetItem(1,"port_code",ls_port_code)
ldw_poc.SetItem(1,"pcn",ll_pcn)
ldw_poc.SetItem(1,"poc_agent_nr",ll_agent_nr)
ldw_poc.SetItem(1,"agents_agent_sn",ls_agent_sn)
ldw_poc.SetItem(1,"port_arr_dt",ldt_arr)
ldw_poc.SetItem(1,"port_dept_dt",ldt_dept)	
ldw_poc.SetItem(1,"comments",ls_comments)
ldw_poc.SetItem(1,"purpose_code",ls_purpose)	
ldw_poc.SetItem(1,"port_berthing_time",ldt_berthing)	
ldw_poc.SetItem(1,"lt_to_utc_difference",0)
ldw_poc.SetItem(1,"poc_local_dates_updated",ldt_local_dates_updated)
ldw_poc.SetItem(1,"poc_dates_updated_by",ls_updatedby)

ldw_poc.setitem(1, "autoschedule_status", ll_autostatus)		//CR2535 & 2536 Added by ZSW001 on 10/11/2011
ldw_poc.SetItem(1,"poc_comments_updated",ldt_comments_updated)
ldw_poc.SetItem(1,"poc_comments_updated_by",ls_comments_updated_by)

ldw_poc.setitem(1, "auto_arr_status", ll_arr_status)
ldw_poc.setitem(1, "auto_ber_status", ll_ber_status)
ldw_poc.setitem(1, "auto_dept_status", ll_dept_status)

//CR2408 Added by LGX001 on 16/05/2011. Change desc: bring the performing agent value from Estimated to Actual in POC

ldw_poc.setitem(1, "poc_performing_agent_nr", ll_performing_agent_nr) 
ldw_poc.setitem(1, "agents_performing_agent_sn", ls_performing_agent_sn)

//CR20 Added by LHC010 on 10-04-2012. Change desc: 
ldc_freshwater  = ldw_poc_est.getitemnumber(ll_row, "fresh_water")
ldc_slopwater   = ldw_poc_est.getitemnumber(ll_row, "slop")
ldc_oil 			 = ldw_poc_est.getitemnumber(ll_row, "oil")
li_msps_tfv		 = ldw_poc_est.getitemnumber(ll_row, "msps_tfv")
ls_tankname		 = ldw_poc_est.getitemstring(ll_row, "tank_name")

ldw_poc.setitem(1, "fresh_water", ldc_freshwater)
ldw_poc.setitem(1, "slop", ldc_slopwater)
ldw_poc.setitem(1, "oil", ldc_oil)
ldw_poc.setitem(1, "msps_tfv", li_msps_tfv)
ldw_poc.setitem(1, "tank_name", ls_tankname)

ldw_poc.setitem(1, "arr_hfo", ld_arr_hfo)
ldw_poc.setitem(1, "arr_do", ld_arr_do)
ldw_poc.setitem(1, "arr_go", ld_arr_go)
ldw_poc.setitem(1, "arr_lshfo", ld_arr_lshfo)
ldw_poc.setitem(1, "dept_hfo", ld_dept_hfo)
ldw_poc.setitem(1, "dept_do", ld_dept_do)
ldw_poc.setitem(1, "dept_go", ld_dept_go)
ldw_poc.setitem(1, "dept_lshfo", ld_dept_lshfo)

//lb_move = TRUE  /* Check for data modified */

//sql
SELECT sum(ORDERED_HFO), sum(ORDERED_DO), sum(ORDERED_GO), sum(ORDERED_LSHFO)
INTO :ld_ordered_hfo, :ld_ordered_do, :ld_ordered_go, :ld_ordered_lshfo
FROM BP_DETAILS
WHERE VESSEL_NR = :ll_vessel_nr AND
		VOYAGE_NR = :ls_voyage_nr AND
		PORT_CODE = :ls_port_code AND
		PCN = :ll_pcn;
IF SQLCA.SQLCODE = 0 THEN
	ldw_poc.SetItem(1,"bp_ordered_hfo",ld_ordered_hfo)
	ldw_poc.SetItem(1,"bp_ordered_do",ld_ordered_do)
	ldw_poc.SetItem(1,"bp_ordered_go",ld_ordered_go)
	ldw_poc.SetItem(1,"bp_ordered_lshfo",ld_ordered_lshfo)
END IF
ldw_poc.SetItem(1,"disch",1)

//CR2562 Begin added by ZSW001 on 22/05/2012: Remove default values in Tugs fields
/*
ldw_poc.SetItem(1,"tugs_in",0)
ldw_poc.SetItem(1,"tugs_out",0)
ldw_poc.SetItem(1,"tugs_shifting",0)
*/
//CR2562 End added by ZSW001 on 22/05/2012

ldw_poc.SetItem(1,"lift_hfo",0)
ldw_poc.SetItem(1,"lift_do",0)
ldw_poc.SetItem(1,"lift_go",0)
ldw_poc.SetItem(1,"lift_lshfo",0)
ldw_poc.SetItem(1,"port_off",0)

w_port_of_call.tab_poc.Selecttab(1)
ldw_poc.SetFocus()

/* Check if this voyage/portcall shall be connected to a TC Contract or not */
if (ls_purpose = "DEL" or ls_purpose = "RED") then
	if wf_connecttccontract( w_port_of_call.tab_poc.tabpage_act.dw_port_of_call) = -1 then 
		ldw_poc_est.ReselectRow(1)
		ldw_poc.reset()
		cb_refresh.post event Clicked()
		return
	end if	
else
	 /* Reset connection to TC-contract. Only */
	ldw_poc.setItem(1,"contract_id", ll_null )  
end if	

/* Validation using the check module */
/* Create object */
string ls_message
lu_check = create u_check_functions

if lu_check.uf_is_first_poc(ll_vessel_nr, ldt_arr, ls_voyage_nr ) or dw_proc_pcnc.rowcount() = 1 then
	if ldw_poc.getitemnumber(1,"arr_hfo") > 0 or &
		ldw_poc.getitemnumber(1,"arr_do") > 0 or &
		ldw_poc.getitemnumber(1,"arr_go") > 0 or &
		ldw_poc.getitemnumber(1,"arr_lshfo") > 0  then
			ls_message="The first Port of Call for a vessel can not have HSFO, LSGO, HSGO and LSFO registered on the arrival.~r~n"
	end if
end if

//CR2516
if len(ls_message) > 0 then
	messagebox("Notice",ls_message + "  You must correct the error.")						
	ldw_poc.setfocus()
	destroy lu_check
	ldw_poc_est.ReselectRow(1)
	ldw_poc.reset()	
	cb_refresh.post event Clicked()
	return	
end if
/* end of validation using check module */

//CR2531 Begin added by ZSW001 on 01/09/2011
SELECT EST_CD_GRADE_LIST
  INTO :ls_cargo_list
  FROM POC_EST
 WHERE VESSEL_NR = :ll_vessel_nr AND
		 VOYAGE_NR = :ls_voyage_nr AND
		 PORT_CODE = :ls_port_code AND
		 PCN       = :ll_pcn;
//CR2531 End added by ZSW001 on 01/09/2011

ldw_poc_est.DeleteRow(ll_row)
if ldw_poc_est.Update() = 1 then
	if ldw_poc.Update() = 1 then
		//CR2531 Begin added by ZSW001 on 01/09/2011
		UPDATE POC
			SET EST_CD_GRADE_LIST = :ls_cargo_list
		 WHERE VESSEL_NR = :ll_vessel_nr AND
				 VOYAGE_NR = :ls_voyage_nr AND
				 PORT_CODE = :ls_port_code AND
				 PCN       = :ll_pcn;
		
		if SQLCA.SQLCode = 0 then
			COMMIT;
		else
			ROLLBACK;
			messagebox(string(SQLCA.SQLCode), SQLCA.SQLErrText, stopsign!)
			destroy lu_check
			return
		end if
		//CR2531 End added by ZSW001 on 01/09/2011
	else
		rollback;
		ldw_poc_est.ReselectRow(1)
		ldw_poc.reset()	
		cb_refresh.post event Clicked()
		destroy lu_check
		return
	end if
else
	rollback;
	ldw_poc_est.ReselectRow(1)
	ldw_poc.reset()	
	cb_refresh.post event Clicked()
	destroy lu_check
	return
end if

if lu_check.of_check_portbunker(ldw_poc, ls_setcol, ls_message) = c#return.Failure then
	messagebox("Notice", ls_message + "~r~n~r~n" + "You MUST correct the error !")
end if

/* destroy object */
destroy lu_check

/* set SLOP mandatory if required */
SELECT P.POC_SLOP_MANDATORY  
	INTO :lb_slop_mandatory  
	FROM PROFIT_C P, VESSELS V  
	WHERE V.PC_NR = P.PC_NR
	AND V.VESSEL_NR = :ll_vessel_nr ;
if lb_slop_mandatory then 
	ldw_poc.SetItem(1,"poc_slop_mandatory", 1)
	ldw_poc.ResetUpdate()
end if

w_port_of_call.tab_poc.tabpage_act.cb_updateact.Default = TRUE

_set_interface( 0, 1)
end event

type cb_newest from mt_u_commandbutton within tabpage_est
integer x = 1929
integer y = 1452
integer taborder = 50
string text = "&New"
end type

event clicked;call super::clicked;integer	li_getrow, li_find_act
string	ls_find_act

if w_port_of_call.tab_poc.tabpage_act.dw_port_of_call.rowcount() = 1 then return
if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount() = 1 then return

if ii_vessel_nr = 0 then return

//CR2410 begin added by WWG004 on 31/05/2011.
li_getrow = dw_proc_pcnc.getselectedrow(0)

if li_getrow < 1 or isnull(li_getrow) then 	return

ls_find_act	= "compute_1 = 'Actual'"
li_find_act	= dw_proc_pcnc.find(ls_find_act, li_getrow + 1, dw_proc_pcnc.rowcount())

if li_getrow > 0 and li_find_act > 0 then
	messagebox("Validation", "You cannot create a new Estimated POC, because there is at least one Actual POC after this.", Information!)
	return
end if
//CR2410 end added.

w_port_of_call.TriggerEvent("ue_insert")

end event

type cb_updateest from mt_u_commandbutton within tabpage_est
integer x = 2277
integer y = 1452
integer taborder = 50
string text = "&Update"
end type

event clicked;call super::clicked;/*
- Accept text
- Clean special charaters in the comments field
- Check mandatory fields
- Dates Validation
- Set time and user stamps
- Updates
- Updates interface (buttons)
- Set dates in the POC list
- Refreh task list
*/

integer	ll_vessel_nr, li_pcn
long		ll_ownid, ll_getrow
string	ls_voyage_nr, ls_port_code, ls_purpose, ls_null, ls_original_purpose
boolean	lb_updatetasklist, lb_success
datetime ldt_est_arr_dt, ldt_est_dpt_dt
decimal{4} ldc_slopwater, ldc_slopoil, ldec_slopwater, ldec_slopoil
string ls_message, ls_setcol, ls_bunkermessage, ls_tank

datawindowchild ldwc_purposelist

//CR2410 begin added by WWG004 on 31/05/2011.
integer	li_autoscheduleupdated

mt_u_datawindow	ldw_poc_est, ldw_department_info, ldw_department_list
//CR2410 end added

setNull(ls_null)

ldw_poc_est				= w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est
ldw_department_info	= w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info
ldw_department_list	= w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list

if ldw_poc_est.rowcount() < 1 then return

//CR2535 & 2536 Added by ZSW001 on 17/11/2011
ib_allowclose = false

if ldw_poc_est.accepttext() = -1 then
	ldw_poc_est.setfocus()
	return
end if
	
// CHECK - WHETHER COMMENTS CONTAINS ' OR " IF SO ASK TO CHANGE AND RETURN
if ldw_poc_est.getitemstatus(1, "poc_est_comments", primary!) = dataModified! then
	ldw_poc_est.setitem(1, "poc_est_comments", wf_replace_special_char(ldw_poc_est.getitemstring(1, "poc_est_comments")))
end if

//Check Mandatory fields
IF IsNull(ldw_poc_est.GetItemDateTime(1,"poc_est_port_arr_dt")) OR IsNull(ldw_poc_est.GetItemString(1,"poc_est_purpose_code"))  THEN
	MessageBox("Input Missing","Arrival date and purpose must be filled out for estimated Port of Call.")
	w_port_of_call.tab_poc.Selecttab(2)
	ldw_poc_est.SetFocus()
	if IsNull(ldw_poc_est.GetItemDateTime(1,"poc_est_port_arr_dt")) then ldw_poc_est.setcolumn("poc_est_port_arr_dt")
	if IsNull(ldw_poc_est.GetItemString(1,"poc_est_purpose_code")) then ldw_poc_est.setcolumn("poc_est_purpose_code")
	return
END IF

if ldw_poc_est.getItemNumber(1, "poc_slop_mandatory") = 1 and (ldw_poc_est.getItemNumber(1, "poc_est_dept_hfo") <> 0 or ldw_poc_est.getItemNumber(1, "poc_est_dept_lshfo") <> 0) then
	ls_tank = ldw_poc_est.getitemstring(1, "tank_name")
	ldec_slopwater = ldw_poc_est.getItemNumber(1, "slop")
	ldec_slopoil = ldw_poc_est.getitemnumber( 1, "oil")
	
	if ls_tank = "" or isnull(ls_tank) or ldec_slopwater < 0 or isnull(ldec_slopwater) or ldec_slopoil < 0 or isnull(ldec_slopoil) then		
		messagebox("Input Missing","SLOP field is mandatory. Please correct.")
		return
	end if
end if

ls_purpose = w_port_of_call. tab_poc.tabpage_est.dw_port_of_call_est.getitemstring(1,"poc_est_purpose_code")
ll_vessel_nr = w_port_of_call. tab_poc.tabpage_est.dw_port_of_call_est.getitemnumber(1,"poc_est_vessel_nr")
ls_voyage_nr = ldw_poc_est.getitemstring(1,"poc_est_voyage_nr")
ls_port_code = ldw_poc_est.getitemstring(1,"poc_est_port_code")
li_pcn = ldw_poc_est.getitemNumber(1,"poc_est_pcn")
ldt_est_arr_dt =  ldw_poc_est.GetItemDateTime(1,"poc_est_port_arr_dt")
ldt_est_dpt_dt =  ldw_poc_est.GetItemDateTime(1,"poc_est_port_dept_dt")

il_vessel_nr = ll_vessel_nr

//CR2410 Added by ZSW001 on 15/07/2011
if wf_validate(ii_ESTIMATED) = c#return.failure then return

//------------------------------- 
// VALIDATION PURPOSE
// check against dropdown list 

ldw_poc_est.getchild("poc_est_purpose_code", ldwc_purposelist)
if ldwc_purposelist.find("purpose_code='" + ls_purpose + "'",1,1000)=0 then
	messagebox("Validation Error - update failed","The Purpose Code you entered is not valid.  Resetting purpose to original code. Please use a code that is included in the dropdown list.")
	ldw_poc_est.post setItem(1,"poc_est_purpose_code", ls_null)
	ldw_poc_est.post setcolumn("poc_est_purpose_code")
	ldw_poc_est.post setfocus()
	return 
end if

//Validates purposes L, D, L/D against calculation
If ls_purpose = "L" or ls_purpose = "D" or ls_purpose ="L/D" then
	if not wf_port_code_ok(ls_purpose,ll_vessel_nr,ls_voyage_nr,ls_port_code) then
		MessageBox("Validation Error", "Selected Purpose (" + ls_purpose + ") is not valid for this port of call.~n~r~n~rIn order to be able to use this purpose, goto the Calculation system and correct the cargo ports.")		
		
		//CR2517 Begin added by ZSW001 on 06/09/2011
		//ldw_poc_est.post setItem(1,"poc_est_purpose_code", ls_null)
		ls_original_purpose = ldw_poc_est.getitemstring(1, "poc_est_purpose_code", primary!, true)
		ldw_poc_est.post setItem(1, "poc_est_purpose_code", ls_original_purpose)
		ldw_poc_est.post setitemstatus(1, "poc_est_purpose_code", primary!, notmodified!)
		//CR2517 End added by ZSW001 on 06/09/2011
		
		ldw_poc_est.post setcolumn("poc_est_purpose_code")
		ldw_poc_est.post setfocus()
		return
	end if
end if

if wf_is_first_poc(ll_vessel_nr, ldt_est_arr_dt, ls_voyage_nr ) or dw_proc_pcnc.rowcount() = 1 then
	if ldw_poc_est.getitemnumber(1,"poc_est_arr_hfo") > 0 or &
		ldw_poc_est.getitemnumber(1,"poc_est_arr_do") > 0 or &
		ldw_poc_est.getitemnumber(1,"poc_est_arr_go") > 0 or &
		ldw_poc_est.getitemnumber(1,"poc_est_arr_lshfo") > 0  then
		ls_message="The first Port of Call for a vessel can not have HSFO, LSFO, LSGO and HSGO registered on the arrival.~r~n"
		if messagebox("Notice",ls_message + "~r~n Do You want to continue?",Question!,YesNo!,2) = 2 then
			ldw_poc_est.setfocus()
			return
		end if
	end if
end if

if wf_check_portbunker(ldw_poc_est, ls_setcol, ls_message) = c#return.Failure then
	messagebox("Notice", ls_message + "~r~n~r~n" + "You MUST correct the error !")
	if len(ls_setcol) > 0 then
		ldw_poc_est.setcolumn(ls_setcol)		
		setfocus(ldw_poc_est)
	end if
	return
end if

//Set time and user stamps
if ldw_poc_est.getitemstatus(1,"poc_est_port_arr_dt", primary!) = dataModified!  &
	or ldw_poc_est.getitemstatus(1,"poc_est_port_berthing_time", primary!) = dataModified! &
	or	ldw_poc_est.getitemstatus(1,"poc_est_port_dept_dt", primary!) = dataModified! &
	or	ldw_poc_est.getitemstatus(1,"poc_est_purpose_code", primary!) = dataModified! &
	or	ldw_poc_est.getitemstatus(1,"agents_agent_sn", primary!) = dataModified! then
	
	ldw_poc_est.setitem(1,"poc_est_local_dates_updated", now()  )
	ldw_poc_est.setitem(1,"poc_est_dates_updated_by",uo_global.is_userid)
end if
	
if ldw_poc_est.getitemstatus(1,"poc_est_comments", primary!) = dataModified!  then
	ldw_poc_est.setitem(1,"poc_est_comments_updated", now()  )
	ldw_poc_est.setitem(1,"poc_est_comments_updated_by",uo_global.is_userid)
end if
	
if ldw_poc_est.getitemstatus(1,"poc_est_purpose_code", primary!) = dataModified! &
	or ldw_poc_est.getitemstatus(1,"poc_est_purpose_code", primary!) = New! then
	lb_updatetasklist = true
end if

//CR2410 begin added by WWG004 on 31/05/2011. Change desc: Auto schedule calculate date.

il_modifiedrow = w_port_of_call.dw_proc_pcnc.getselectedrow(0)

//CR2535 & 2536 Begin added by ZSW001 on 29/10/2011
//li_autoscheduleupdated = _doautoschedule(ii_ESTIMATED)

lb_success = true
if ib_doschedule then
	lb_success = inv_autoschedule.of_calculateschedule(dw_proc_pcnc, ldw_poc_est, ii_ESTIMATED, rb_only_this_year.checked)
end if

if lb_success then
	//CR20 Added by LHC010 on 09-04-2012. Change desc: set MSPS_TFV zero
	if ldw_poc_est.modifiedcount( ) > 0 then
		ldw_poc_est.setitem( 1, "msps_tfv", 0)
	end if
	
	if ldw_poc_est.update() = 1 then
		if ldw_department_info.rowcount() > 0 then
			if ldw_department_info.update() = 1 then
				ll_ownid = ldw_department_info.getitemnumber(1, "owner_department_id")
			
				for ll_getrow = 1 to ldw_department_list.rowcount()
					ldw_department_list.setitem(ll_getrow, "owner_department_id", ll_ownid)
				next
			
				ldw_department_list.accepttext()
			
				if ldw_department_list.update() = 1 then
					commit;
					w_port_of_call.tab_poc.tabpage_owners_matters.enabled = true
					ib_new = false
				else
					rollback;
					messagebox("Update failed", "Error updating Estimated POC!")
					return
				end if
			else
				rollback;
				messagebox("Update failed", "Error updating Estimated POC!")
				return
			end if
		else	//commit est POC
			commit;
		end if
		openwithparm(w_updated, 0, w_tramos_main)
	else	//Est POC not update success
		rollback;
		//Added by TTY004 on 06/02/12.
		if ldw_poc_est.of_showmessage( ) = c#return.noaction then
			messagebox("Update failed", "Error updating Estimated POC!")
		end if
		return
	end if
	 wf_update_timebar(ll_vessel_nr, ls_voyage_nr)
else
	rollback;
	//Added by TTY004 on 06/02/12
	if ldw_poc_est.of_showmessage( ) = c#return.noaction then
		messagebox("Update failed", "Error updating Estimated POC!")
	end if 
	return
end if
//CR2535 & 2536 End added by ZSW001 on 29/10/2011

//CR2535 & 2536 Added by ZSW001 on 17/11/2011
ib_allowclose = true

w_port_of_call.postevent("ue_retrieve")
w_port_of_call.cb_refresh.postevent("clicked")
//CR2410 end added.

//Refresh interface
_set_interface(1 , 0)
			
//Refresh task list if is a new POC or purpose code changed
if lb_updatetasklist = true then
	wf_refresh_task_list( ll_vessel_nr, ls_voyage_nr, ls_port_code,li_pcn, 1)
end if

if not wf_check_bunker(ll_vessel_nr, ls_voyage_nr, ls_bunkermessage) then
	ls_message = "Mismatch in bunker registration.~r~n~r~n" + ls_bunkermessage + "~r~n~r~n"
	messagebox("Notice", ls_message + "You MUST correct the error !")
end if

//add information in POC list
dw_proc_pcnc.setfocus( )
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_port_arr_dt", ldt_est_arr_dt)
dw_proc_pcnc.setItem(dw_proc_pcnc.getselectedrow(0), "poc_est_purpose_code", ls_purpose)
wf_set_voyage_alert_status("EST", dw_proc_pcnc.getselectedrow(0))
dw_proc_pcnc.accepttext( )
dw_proc_pcnc.groupCalc()

end event

type cb_deleteest from mt_u_commandbutton within tabpage_est
integer x = 2624
integer y = 1452
integer taborder = 40
string text = "&Delete"
end type

event clicked;call super::clicked;
if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount() < 1 then return

w_port_of_call.TriggerEvent("ue_delete")

end event

type cb_cancel_est from mt_u_commandbutton within tabpage_est
integer x = 2971
integer y = 1452
integer taborder = 30
string text = "C&ancel"
end type

event clicked;call super::clicked;
/*
Reset Estimated POC
Retrieves
*/

integer 	ll_rows_est, li_pcn, li_row
string	ls_voyage_nr, ls_port_code

if w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.rowcount() < 1 then return

w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Reset()

li_row = dw_proc_pcnc.getselectedrow( 0)
ls_voyage_nr = dw_proc_pcnc.GetItemString(li_row,"proceed_voyage_nr")
ls_port_code = dw_proc_pcnc.GetItemString(li_row,"proceed_port_code")
li_pcn = dw_proc_pcnc.GetItemNumber(li_row,"proceed_pcn")

ll_rows_est =  w_port_of_call.tab_poc.tabpage_est.dw_port_of_call_est.Retrieve(ii_vessel_nr,ls_voyage_Nr,ls_port_code,li_pcn,uo_global.is_userid) 
	
_set_interface( ll_rows_est, 0)
__setstps_display(1)
il_modifiedrow = 0

if ib_new = true then
	w_port_of_call.tab_poc.tabpage_owners_matters.enabled = true
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_info.reset()
	w_port_of_call.tab_poc.tabpage_owners_matters.dw_department_list.reset()
	_set_interface(0, 0)
end if

ib_new = false
end event

type dw_port_of_call_est from mt_u_datawindow within tabpage_est
integer x = 5
integer y = 16
integer width = 3328
integer height = 1436
integer taborder = 30
string dataobject = "d_port_of_call_est"
boolean border = false
borderstyle borderstyle = styleraised!
boolean ib_setdefaultbackgroundcolor = true
end type

event clicked;call super::clicked;//CR2408 Added by LGX001 on 19/05/2011. 
long ll_found_row, ll_returnid
s_poc_performing_agent     lstr_agent
datawindowchild            ldwc_performing_agent
string	ls_performagent
//w_agentlist                lw_agentlist_performing 
long ll_row
integer li_vessel, li_pcn
string ls_voyage, ls_port
u_jump_bp	lnv_jump

if row < 1 then return

If  dwo.Name = "poc_est_comments" Then
	if this.Object.Datawindow.ReadOnly="yes"   then 
		openwithparm(w_messageBox, this.getItemString(row, "poc_est_comments"))
	END IF
end if

//CR2408  Added by LGX001 on 13/05/2011. Change desc: open the Agents window in POC to allow creating or editing Performing Agent
if dwo.name = 'p_est_performing_agent'   then  
	this.accepttext( )
	lstr_agent.l_pcgroupid = 0
	lstr_agent.l_agent_nr  = this.getitemnumber(row, 'poc_est_performing_agent_nr') 
	if isnull(lstr_agent.l_agent_nr) or lstr_agent.l_agent_nr <= 0 then
		lstr_agent.l_agent_nr = 0
		lstr_agent.s_agent_short_name = ''
	end if
	this.getchild( 'agents_performing_agent_sn', ldwc_performing_agent)
	ldwc_performing_agent.settransobject(sqlca)
	if lstr_agent.l_agent_nr > 0 then
		ll_found_row = ldwc_performing_agent.find("company_id ="  + string(lstr_agent.l_agent_nr), 1, ldwc_performing_agent.rowcount() )
		if ll_found_row  <= 0 then
			lstr_agent.l_agent_nr = 0
			lstr_agent.s_agent_short_name = ''
		else
			lstr_agent.s_agent_short_name = ldwc_performing_agent.getitemstring(ll_found_row, 'company_sn')
		end if
	end if
	
	if isvalid(w_performing_agent) then close(w_performing_agent)
	openwithparm(w_performing_agent, lstr_agent)
	ll_returnid =  message.doubleparm
		
	ldwc_performing_agent.retrieve( )
			
	if ll_returnid>0 then
		//select agent
		this.getchild( 'agents_performing_agent_sn', ldwc_performing_agent)
		ldwc_performing_agent.settransobject( sqlca)	
		ll_found_row = ldwc_performing_agent.find("company_id ="  + string(ll_returnid), 1, ldwc_performing_agent.rowcount() )
		if ll_found_row>0 then
			ls_performagent = ldwc_performing_agent.getitemstring(ll_found_row, 'company_sn')
			
			dw_port_of_call_est.setitem(1,"agents_performing_agent_sn",ls_performagent)
			dw_port_of_call_est.setitem(1,"poc_est_performing_agent_nr",ll_returnid)
		end if
	end if
end if

if dwo.name = "b_lifted_details" then	
	if this.getitemstatus(1, 0, primary!) <> notmodified! then 
		messagebox("Information", "Estimated Port Of Call data modified, but not updated.~r~n~r~nPlease update before accessing bunker details.") 
		return
	end if
	
	ll_row = dw_proc_pcnc.getselectedrow( 0 )
	
	li_vessel = dw_proc_pcnc.getitemnumber(ll_row, "proceed_vessel_nr")
	ls_voyage = dw_proc_pcnc.getitemstring(ll_row, "proceed_voyage_nr")
	ls_port = dw_proc_pcnc.getitemstring(ll_row, "proceed_port_code")
	li_pcn = dw_proc_pcnc.getitemnumber(ll_row, "proceed_pcn")
	
	lnv_jump = create u_jump_bp
	lnv_jump.of_open_bp( li_vessel, ls_voyage, ls_port, li_pcn )
	destroy lnv_jump
end if

if 	dwo.name = "p_refresh" then
	wf_calculate_tce(1)
end if
end event

event itemchanged;call super::itemchanged;String ls_name, ls_null;setNull(ls_null)
Integer li_nr, li_null;setNull(li_null)
Integer li_active

 //CR2408 Added by LGX001 on 19/05/2011. Change desc: used to get performing agent nr 
long ll_performing_agent_nr
long ll_found_row, ll_count
datawindowchild  ldwc_performing_agent, ldwc_noncargo_agent

/* Accept text for port of call dw */
//dw_port_of_call_est.Accepttext()

/* Case which field was modified */
CHOOSE CASE dw_port_of_call_est.GetColumnName( ) 
	CASE "agents_agent_sn"
		ls_name = data
		if ( ls_name = "" ) or Isnull(ls_name) then 
			setnull(li_nr)
			dw_port_of_call_est.SetItem(1, "poc_est_agent_nr", li_nr)
			return
		end if
		
		//CR2408 Added by LGX001 on 08/07/2011. Change desc:  when the user manually enters an agent that doesn't exist in the dddw
		this.getchild('agents_agent_sn', ldwc_noncargo_agent)
		ldwc_noncargo_agent.settransobject(sqlca)
		ll_count = ldwc_noncargo_agent.rowcount( )
		ll_found_row = ldwc_noncargo_agent.find("upper(agent_sn)  = '" + upper(ls_name) + "'",  1, ll_count)
		if ll_found_row  <= 0 then
			this.setitem(row, "agents_agent_sn", ls_null)
			this.SetItem(row,"poc_est_agent_nr",li_null)
			messagebox("Validation Error", "This non-cargo agent does not exist. Please select another agent.")
			return  2
		else
			li_nr = ldwc_noncargo_agent.getitemnumber(ll_found_row, 'agent_nr')
		end if
		
		if f_agent_active( li_nr) = false then 
			MessageBox("Validation Error", "Selected Agent is marked as inactive. Please select another Agent.")
			if this.getItemString(row, "agents_agent_sn", primary!, true) <> ls_name then
				this.setItem(row, "agents_agent_sn", this.getItemString(row, "agents_agent_sn", primary!, true) )
			else
				this.setItem(row, "agents_agent_sn", ls_null)
				this.SetItem(row,"poc_est_agent_nr",li_null)
			end if
			setColumn("agents_agent_sn")
			return 2
		end if
		dw_port_of_call_est.SetItem(1,"poc_est_agent_nr",li_nr)
	
  //CR2408 Added by LGX001 on 13/05/2011. Change desc: validate the performing agent
  CASE "agents_performing_agent_sn"    	
	ls_name = data
	if (ls_name = "") or isnull(ls_name) then
		this.setitem(row, "poc_est_performing_agent_nr", li_null)
		return 
	end if
	this.getchild('agents_performing_agent_sn', ldwc_performing_agent)
	ldwc_performing_agent.settransobject(sqlca)
	ll_count = ldwc_performing_agent.rowcount( )
	ll_found_row = ldwc_performing_agent.find("upper(company_sn)  = '"   + upper(ls_name)   + "'", 1, ll_count)
	if ll_found_row  <= 0 then
		this.setitem(row, "poc_est_performing_agent_nr", li_null)
		this.setitem(row, "agents_performing_agent_sn", ls_null)
		messagebox("Validation Error", "This performing agent does not exist. Please select another agent.")
		return  2
	else
		ll_performing_agent_nr = ldwc_performing_agent.getitemnumber(ll_found_row, 'company_id')
		this.setitem(row, "poc_est_performing_agent_nr", ll_performing_agent_nr )
	end if
END CHOOSE

//CR2535 & 2536 Added by ZSW001 on 14/11/2011
if dwo.name = "poc_est_port_arr_dt" or dwo.name = "poc_est_port_berthing_time" or dwo.name = "poc_est_port_dept_dt" or dwo.name = "poc_est_purpose_code" then
	this.setitem(row, "autoschedule_status", 0)
	choose case dwo.name
		case "poc_est_port_arr_dt"
			this.setitem(row, "auto_arr_status", 0)
		case "poc_est_port_berthing_time"
			this.setitem(row, "auto_ber_status", 0)
		case "poc_est_purpose_code"
			inv_autoschedule.of_set_portstay(this, ii_ESTIMATED, false)
			//Added by TTY004 on 02/02/12.
			if isnull(this.getitemdecimal(row, 'poc_portstay')) then
				__setstps_display(1)
			end if
		case "poc_est_port_dept_dt"
			this.setitem(row, "auto_dept_status", 0)
			inv_autoschedule.of_setetdmodified(true)
	end choose
end if

//CR20 Added by LHC010 on 09-04-2012. Change desc: The purpose TFV should not be used when users create or update POCs manually, 
//it should be only used when approving messages from vessels
if dwo.name = "poc_est_purpose_code" then
	if upper(data) = "TFV" then
		messagebox("Validation Error", "The purpose 'TFV' should not be used.")
		return 1	
	end if
end if
end event

event doubleclicked;call super::doubleclicked;
string ls_name
integer li_nr

if this.Object.Datawindow.ReadOnly="yes" then return
	
if (row > 0) then
	
	CHOOSE CASE dw_port_of_call_est.getcolumnname()
		CASE "agents_agent_sn"
			ls_name = f_select_from_list("dw_agent_list",1,"Short Name",2,"Full Name",1,"Agent selection",false)
			IF IsNull(ls_name) THEN Return
			
			if ( ls_name = "" ) or Isnull(ls_name) then 
				setnull(li_nr)
				dw_port_of_call_est.SetItem(1,"poc_est_agent_nr",li_nr)
				return
			end if
	
			SELECT AGENT_NR
			INTO :li_nr
			FROM AGENTS
			WHERE AGENT_SN = :ls_name;
			commit;
			dw_port_of_call_est.SetItem(1,"poc_est_agent_nr",li_nr)
			dw_port_of_call_est.SetItem(1,"agents_agent_sn",ls_name)
			event itemchanged( row, dwo, ls_name)
	END CHOOSE

end if

end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, tab_poc.tabpage_est.dw_port_of_call_est)
end event

event buttonclicked;call super::buttonclicked;//CR2531 Begin added by ZSW001 on 01/09/2011
choose case dwo.name
	case "b_estcargo"
		wf_goto_est_cargo(1)		//0: Actual; 1: Estimated
	case else
		//None
end choose
//CR2531 End added by ZSW001 on 01/09/2011

end event

event retrieveend;call super::retrieveend;//CR2535 & 2536 Added by ZSW001 on 26/10/2011
inv_autoschedule.of_set_steamingtime(dw_proc_pcnc, this, ii_ESTIMATED)
inv_autoschedule.of_set_portstay(this, ii_ESTIMATED, false)
inv_autoschedule.of_setetdmodified(false)
ib_allowclose = true

end event

event itemerror;call super::itemerror;//Added by LHC010 on 09-04-2012. Change desc: 
if dwo.name = "poc_est_purpose_code" then
	return 1
end if
end event

type tabpage_voy_text from userobject within tab_poc
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Voyage Comments"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
dw_laycan_cp dw_laycan_cp
cb_cancel_voyage_text cb_cancel_voyage_text
cb_update_voyage_text cb_update_voyage_text
dw_voyage_text dw_voyage_text
end type

on tabpage_voy_text.create
this.dw_laycan_cp=create dw_laycan_cp
this.cb_cancel_voyage_text=create cb_cancel_voyage_text
this.cb_update_voyage_text=create cb_update_voyage_text
this.dw_voyage_text=create dw_voyage_text
this.Control[]={this.dw_laycan_cp,&
this.cb_cancel_voyage_text,&
this.cb_update_voyage_text,&
this.dw_voyage_text}
end on

on tabpage_voy_text.destroy
destroy(this.dw_laycan_cp)
destroy(this.cb_cancel_voyage_text)
destroy(this.cb_update_voyage_text)
destroy(this.dw_voyage_text)
end on

type dw_laycan_cp from mt_u_datawindow within tabpage_voy_text
integer x = 2542
integer y = 16
integer width = 786
integer height = 1432
integer taborder = 60
string dataobject = "d_sq_ff_laycan_cp"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event buttonclicked;call super::buttonclicked;//CR2414 added by LHC010 on 26-05-2011.
integer	li_active_row,li_row_count,li_row
if dwo.name = 'b_left' then
	li_active_row = this.getitemnumber( row,"compute_groupsum")
	if li_active_row > 1 then
		li_row = this.find( "compute_groupsum = " + string(li_active_row - 1),1,this.rowcount())
		if li_row > 0 then
			this.scrolltorow( li_row )
			this.setrow( li_row )
		end if
		if li_active_row - 1 = 1 then
			this.modify( "b_left.enabled = 'no'")
			this.modify( "b_right.enabled = 'yes'")
		end if
	end if
end if

if dwo.name = 'b_right' then
	li_active_row = this.getitemnumber( row,"compute_groupsum")
	li_row_count = this.getitemnumber( row,"rowcnt")
	if li_active_row < li_row_count then
		li_row = this.find( "compute_groupsum = " + string(li_active_row + 1), 1,this.rowcount())
		if li_row > 0 then
			this.scrolltorow( li_row )
			this.setrow( li_row )
		end if
		if li_row_count - li_active_row = 1 then
			this.modify( "b_right.enabled = 'no'")
			this.modify( "b_left.enabled = 'yes'")
		end if
	end if	
end if
end event

type cb_cancel_voyage_text from mt_u_commandbutton within tabpage_voy_text
integer x = 2971
integer y = 1452
integer taborder = 50
string text = "C&ancel"
end type

event clicked;call super::clicked;
w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.ReselectRow(&
		w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.GetRow())
end event

type cb_update_voyage_text from mt_u_commandbutton within tabpage_voy_text
integer x = 2624
integer y = 1452
integer taborder = 60
string text = "&Update"
end type

event clicked;call super::clicked;
Integer li_vessel
String ls_voyage, ls_text

if w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.rowcount() < 1 then return

// CHECK - WHETHER COMMENTS CONTAINS ' OR " IF SO ASK TO CHANGE AND RETURN
// INSERTED BY FR 12-09-02 
w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.Accepttext()
w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.setitem(1, "voyage_comments", wf_replace_special_char(w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.getitemstring(1, "voyage_comments")))

w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.AcceptText()
ls_text = w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.GetItemString(1,"voyage_comments")
li_vessel = w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.GetItemNumber(1,"vessel_nr")
ls_voyage = left(w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.GetItemString(1,"voyage_nr"),5)

UPDATE VOYAGES  
SET VOYAGE_COMMENTS = :ls_text  
WHERE ( VOYAGES.VESSEL_NR = :li_vessel ) AND  
      ( SUBSTRING(VOYAGES.VOYAGE_NR,1,5) = :ls_voyage )  ;
IF SQLCA.SQLCode <> 0 THEN
	Rollback;
	Messagebox("Error","Failed to update voyage comment.")
ELSE
	Commit;
	w_port_of_call.tab_poc.tabpage_voy_text.dw_voyage_text.ResetUpdate()
END IF


end event

type dw_voyage_text from mt_u_datawindow within tabpage_voy_text
integer x = 5
integer y = 16
integer width = 2528
integer height = 1496
integer taborder = 130
string dataobject = "d_voyage_text"
boolean border = false
borderstyle borderstyle = styleraised!
boolean ib_setdefaultbackgroundcolor = true
end type

event clicked;
if row < 1 then return

if this.Object.Datawindow.ReadOnly="yes" then 
	openwithparm(w_messageBox, this.getItemString(row, "voyage_comments"))
END IF

end event

type tabpage_att from userobject within tab_poc
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Voyage Attachments"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
uo_att uo_att
end type

on tabpage_att.create
this.uo_att=create uo_att
this.Control[]={this.uo_att}
end on

on tabpage_att.destroy
destroy(this.uo_att)
end on

type uo_att from u_fileattach within tabpage_att
boolean visible = false
integer y = 16
integer width = 3328
integer height = 1488
integer taborder = 80
string is_dataobjectname = "d_sq_tv_voyage_file_listing"
string is_counterlabel = "attachments:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
end type

on uo_att.destroy
call u_fileattach::destroy
end on

type tabpage_vessel_text from userobject within tab_poc
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Vessel Details"
long tabtextcolor = 33554432
long tabbackcolor = 81324524
long picturemaskcolor = 536870912
string powertiptext = "Vessel Text Fields and Monthly Bunkers"
uo_vesseldetail_att uo_vesseldetail_att
cb_update_vessel_text cb_update_vessel_text
cb_cancel_vessel_text cb_cancel_vessel_text
dw_vessel_text dw_vessel_text
gb_vesseldetail_att gb_vesseldetail_att
end type

on tabpage_vessel_text.create
this.uo_vesseldetail_att=create uo_vesseldetail_att
this.cb_update_vessel_text=create cb_update_vessel_text
this.cb_cancel_vessel_text=create cb_cancel_vessel_text
this.dw_vessel_text=create dw_vessel_text
this.gb_vesseldetail_att=create gb_vesseldetail_att
this.Control[]={this.uo_vesseldetail_att,&
this.cb_update_vessel_text,&
this.cb_cancel_vessel_text,&
this.dw_vessel_text,&
this.gb_vesseldetail_att}
end on

on tabpage_vessel_text.destroy
destroy(this.uo_vesseldetail_att)
destroy(this.cb_update_vessel_text)
destroy(this.cb_cancel_vessel_text)
destroy(this.dw_vessel_text)
destroy(this.gb_vesseldetail_att)
end on

type uo_vesseldetail_att from u_fileattach within tabpage_vessel_text
boolean visible = false
integer x = 37
integer y = 892
integer width = 3282
integer height = 536
integer taborder = 20
string is_dataobjectname = "d_sq_ff_vessel_detail_files"
string is_counterlabel = "Files:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
boolean ib_autosave = true
boolean ib_multitableupdate = true
string is_modulename = "vessels_action"
end type

on uo_vesseldetail_att.destroy
call u_fileattach::destroy
end on

event constructor;if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
   ib_allow_dragdrop = true
else
	ib_allow_dragdrop = false
end if
super::event constructor( )
end event

event ue_postupdateattach;if  ai_returncode = c#return.SUCCESS then
	COMMIT;
else
	rollback;
end if

call super::ue_postupdateattach

end event

event ue_preupdateattach;call super::ue_preupdateattach;string ls_description
long li_row,ll_count,ll_vessel_nr
datetime ldt_today
int i
mt_n_datastore ds_vessel_detail_history

li_row = dw_vessel_text.getrow()
if li_row > 0 then
	ll_vessel_nr = dw_vessel_text.GetItemNumber(li_row, "vessel_nr")
	  ll_count = uo_vesseldetail_att.dw_file_listing.rowcount()
      if ll_count > 0 then
	      for i = 1 to ll_count
			  
			    if uo_vesseldetail_att.dw_file_listing.GetItemStatus(i,0,PRIMARY!) = NewModified! then
//			     
				    uo_vesseldetail_att.dw_file_listing.setitem(i,'vessel_nr',ll_vessel_nr)
//					 
				
			   end if
	      next
		end if
end if
//insert delete attachment log
ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add port detail history
ds_vessel_detail_history = create mt_n_datastore
ds_vessel_detail_history.dataobject = 'd_sq_gr_vessels_detail_history'
ds_vessel_detail_history.settransobject(sqlca)
ds_vessel_detail_history.reset()
if  tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.deletedcount( ) > 0 then
	 for i = 1 to tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.deletedcount( )
		ls_description = tab_poc.tabpage_vessel_text.uo_vesseldetail_att.dw_file_listing.getitemstring(i,'description',Delete!,True)
		wf_insert_vesseldetailhistory(ds_vessel_detail_history,ls_description,ls_description,ll_vessel_nr,ldt_today,'delete')
	 next
end if
if ds_vessel_detail_history.update() = 1 then
	
else
	rollback;
	return -1
end if
return 1
end event

event ue_retrievefilelist;// Overrided

long li_row,li_vessel_nr

li_row = dw_vessel_text.getrow()
if li_row > 0 then
	li_vessel_nr = dw_vessel_text.GetItemNumber(li_row, "vessel_nr")
	return adw_file_listing.Retrieve(li_vessel_nr)
end if

return c#return.Failure
end event

type cb_update_vessel_text from mt_u_commandbutton within tabpage_vessel_text
integer x = 2624
integer y = 1452
integer taborder = 30
string text = "&Update"
end type

event clicked;call super::clicked;int i
datetime ldt_today
string ls_new,ls_old
long ll_count,li_rc_attachment,ll_vessel_nr
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
mt_n_datastore ds_vessel_detail_history


if uo_global.ii_access_level = -1 then
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

if w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.rowcount() < 1 then return

w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.accepttext()
ll_vessel_nr = w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.getitemNumber(w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.getrow(),'vessel_nr')
ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add vessel detail history
ds_vessel_detail_history = create mt_n_datastore
ds_vessel_detail_history.dataobject = 'd_sq_gr_vessels_detail_history'
ds_vessel_detail_history.settransobject(sqlca)
ds_vessel_detail_history.reset()

if w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.modifiedcount( ) > 0 then
	ls_new = w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.getitemstring(w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.getrow(),'details')
	ls_old = w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.getitemstring(w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.getrow(),'details',Primary!,true)
	if isnull(ls_new) then ls_new = ''
	if isnull(ls_old) then ls_old = ''
	if ls_new <> ls_old then
	   wf_insert_vesseldetailhistory(ds_vessel_detail_history,ls_new,ls_old,ll_vessel_nr,ldt_today,'details')
	end if

end if

if w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.update() = 1 then
	if ds_vessel_detail_history.update() = 1 then
		uo_vesseldetail_att.dw_file_listing.accepttext( )
		if uo_vesseldetail_att.dw_file_listing.modifiedcount( )  > 0 or uo_vesseldetail_att.dw_file_listing.DeletedCount() > 0  then
			
			lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
			lnv_actionrules.of_registerrulestring("description", true, "description")
			if lnv_actionrules.of_validate(uo_vesseldetail_att.dw_file_listing, true) = c#return.Failure then return c#return.Failure
			
			li_rc_attachment = uo_vesseldetail_att.of_updateattach()
			if li_rc_attachment = 1 then
				commit;
			else
				rollback;
				messagebox("Error","Update of Vessel Details failed.")
			end if
		else
			commit;
		end if
	else
		rollback;
		messagebox("Error","Update of Vessel Details failed.")
	end if
else
	rollback;
	messagebox("Error","Update of Vessel Details failed.")
end if



destroy ds_vessel_detail_history


end event

type cb_cancel_vessel_text from mt_u_commandbutton within tabpage_vessel_text
integer x = 2971
integer y = 1452
integer taborder = 40
string text = "C&ancel"
end type

event clicked;call super::clicked;
w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.ReselectRow(&
		w_port_of_call.tab_poc.tabpage_vessel_text.dw_vessel_text.GetRow())
end event

type dw_vessel_text from mt_u_datawindow within tabpage_vessel_text
integer x = 5
integer y = 12
integer width = 3328
integer height = 804
integer taborder = 10
string dataobject = "d_sq_ff_vessel_detail"
boolean border = false
borderstyle borderstyle = styleraised!
boolean ib_setdefaultbackgroundcolor = true
end type

type gb_vesseldetail_att from groupbox within tabpage_vessel_text
boolean visible = false
integer x = 18
integer y = 828
integer width = 3314
integer height = 608
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Attachments"
end type

type tabpage_port_details from userobject within tab_poc
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Port Details"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_cancel_port_details cb_cancel_port_details
cb_update_port_details cb_update_port_details
dw_port_details dw_port_details
uo_port_att uo_port_att
gb_port_att gb_port_att
end type

on tabpage_port_details.create
this.cb_cancel_port_details=create cb_cancel_port_details
this.cb_update_port_details=create cb_update_port_details
this.dw_port_details=create dw_port_details
this.uo_port_att=create uo_port_att
this.gb_port_att=create gb_port_att
this.Control[]={this.cb_cancel_port_details,&
this.cb_update_port_details,&
this.dw_port_details,&
this.uo_port_att,&
this.gb_port_att}
end on

on tabpage_port_details.destroy
destroy(this.cb_cancel_port_details)
destroy(this.cb_update_port_details)
destroy(this.dw_port_details)
destroy(this.uo_port_att)
destroy(this.gb_port_att)
end on

type cb_cancel_port_details from mt_u_commandbutton within tabpage_port_details
integer x = 2971
integer y = 1452
integer taborder = 130
string text = "C&ancel"
end type

event clicked;call super::clicked;w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.ReselectRow(&
      w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.GetRow())
end event

type cb_update_port_details from mt_u_commandbutton within tabpage_port_details
integer x = 2624
integer y = 1452
integer taborder = 130
string text = "&Update"
end type

event clicked;call super::clicked;int i
datetime ldt_today
string ls_port_code,ls_new,ls_old
long ll_count,li_rc_attachment
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
datastore ds_port_detail_history


if uo_global.ii_access_level = -1 then
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

if w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.rowcount() < 1 then return

w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.accepttext()
ls_port_code = dw_proc_pcnc.getitemstring(dw_proc_pcnc.getrow(),'proceed_port_code')
ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add port detail history
ds_port_detail_history = create datastore
ds_port_detail_history.dataobject = 'd_sq_gr_ports_detail_history'
ds_port_detail_history.settransobject(sqlca)
ds_port_detail_history.reset()

if w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.modifiedcount( ) > 0 then
	ls_new = w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.getitemstring(w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.getrow(),'ports_details')
	ls_old = w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.getitemstring(w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.getrow(),'ports_details',Primary!,true)
	if isnull(ls_new) then ls_new = ''
	if isnull(ls_old) then ls_old = ''
	if ls_new <> ls_old then
	   wf_insert_portdetailhistory(ds_port_detail_history,ls_new,ls_old,ls_port_code,ldt_today,'details')
	end if

end if

if w_port_of_call.tab_poc.tabpage_port_details.dw_port_details.update() = 1 then
	if ds_port_detail_history.update() = 1 then
		uo_port_att.dw_file_listing.accepttext( )
		if uo_port_att.dw_file_listing.modifiedcount( )  > 0 or uo_port_att.dw_file_listing.DeletedCount() > 0  then
			
			lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
			lnv_actionrules.of_registerrulestring("description", true, "description")
			if lnv_actionrules.of_validate(uo_port_att.dw_file_listing, true) = c#return.Failure then return c#return.Failure
			
			li_rc_attachment = uo_port_att.of_updateattach()
			if li_rc_attachment = 1 then
				commit;
			else
				rollback;
				messagebox("Error","Update of Port Details failed.")
			end if
		else
			commit;
		end if
	else
		rollback;
		messagebox("Error","Update of Port Details failed.")
	end if
else
	rollback;
	messagebox("Error","Update of Port Details failed.")
end if



destroy ds_port_detail_history
end event

type dw_port_details from mt_u_datawindow within tabpage_port_details
integer x = 5
integer y = 12
integer width = 3328
integer height = 784
integer taborder = 50
string dataobject = "d_sq_ff_ports_details_poc"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

type uo_port_att from u_fileattach within tabpage_port_details
boolean visible = false
integer x = 37
integer y = 876
integer width = 3282
integer height = 552
integer taborder = 130
boolean bringtotop = true
string is_dataobjectname = "d_sq_tb_port_detail_files"
string is_counterlabel = "Files:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
boolean ib_autosave = true
boolean ib_multitableupdate = true
string is_modulename = "ports_action"
end type

on uo_port_att.destroy
call u_fileattach::destroy
end on

event ue_retrievefilelist;// Overrided
string ls_port_code
long li_row

li_row = dw_proc_pcnc.getrow()
if li_row > 0 then
	ls_port_code = dw_proc_pcnc.GetItemString(li_row, "proceed_port_code")
	return adw_file_listing.Retrieve(ls_port_code)
end if

return c#return.Failure
end event

event ue_preupdateattach;call super::ue_preupdateattach;string ls_port_code,ls_description
long li_row,ll_count
datetime ldt_today
int i
datastore ds_port_detail_history

li_row = dw_proc_pcnc.getrow()
if li_row > 0 then
	ls_port_code = dw_proc_pcnc.GetItemString(li_row, "proceed_port_code")
	  ll_count = uo_port_att.dw_file_listing.rowcount()
      if ll_count > 0 then
	      for i = 1 to ll_count
			  
			    if uo_port_att.dw_file_listing.GetItemStatus(i,0,PRIMARY!) = NewModified! then
//			     
				    uo_port_att.dw_file_listing.setitem(i,'port_code',ls_port_code)
//					 
				
			   end if
	      next
		end if
end if
//insert delete attachment log
ldt_today = datetime(string(today(),'yyyy-mm-dd hh:mm:ss'))

//add port detail history
ds_port_detail_history = create datastore
ds_port_detail_history.dataobject = 'd_sq_gr_ports_detail_history'
ds_port_detail_history.settransobject(sqlca)
ds_port_detail_history.reset()
if  tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.deletedcount( ) > 0 then
	 for i = 1 to tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.deletedcount( )
		ls_description = tab_poc.tabpage_port_details.uo_port_att.dw_file_listing.getitemstring(i,'description',Delete!,True)
		wf_insert_portdetailhistory(ds_port_detail_history,ls_description,ls_description,ls_port_code,ldt_today,'delete')
	 next
end if
if ds_port_detail_history.update() = 1 then
	
else
	rollback;
	return -1
end if
return 1
end event

event constructor;if (uo_global.ii_user_profile < 3) and (uo_global.ii_access_level >= C#usergroup.#USER) then	
   ib_allow_dragdrop = true
else
	ib_allow_dragdrop = false
end if
super::event constructor( )
end event

event ue_postupdateattach;// override

if  ai_returncode = c#return.SUCCESS then
	COMMIT;
else
	rollback;
end if

call super::ue_postupdateattach

end event

type gb_port_att from groupbox within tabpage_port_details
boolean visible = false
integer x = 18
integer y = 812
integer width = 3314
integer height = 624
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Attachments"
end type

type tabpage_owners_matters from userobject within tab_poc
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Owners Matters"
long picturemaskcolor = 536870912
dw_department_info dw_department_info
st_contacts st_contacts
dw_department_list dw_department_list
cb_cancel cb_cancel
cb_print cb_print
cb_update cb_update
uo_attach uo_attach
dw_print dw_print
gb_activites gb_activites
end type

on tabpage_owners_matters.create
this.dw_department_info=create dw_department_info
this.st_contacts=create st_contacts
this.dw_department_list=create dw_department_list
this.cb_cancel=create cb_cancel
this.cb_print=create cb_print
this.cb_update=create cb_update
this.uo_attach=create uo_attach
this.dw_print=create dw_print
this.gb_activites=create gb_activites
this.Control[]={this.dw_department_info,&
this.st_contacts,&
this.dw_department_list,&
this.cb_cancel,&
this.cb_print,&
this.cb_update,&
this.uo_attach,&
this.dw_print,&
this.gb_activites}
end on

on tabpage_owners_matters.destroy
destroy(this.dw_department_info)
destroy(this.st_contacts)
destroy(this.dw_department_list)
destroy(this.cb_cancel)
destroy(this.cb_print)
destroy(this.cb_update)
destroy(this.uo_attach)
destroy(this.dw_print)
destroy(this.gb_activites)
end on

type dw_department_info from mt_u_datawindow within tabpage_owners_matters
boolean visible = false
integer y = 12
integer width = 2075
integer height = 608
integer taborder = 60
string dataobject = "d_sq_ff_department_info"
boolean border = false
end type

event itemchanged;call super::itemchanged;string	ls_status, ls_null; setnull(ls_null)

datawindowchild ldwc_resp_psm

this.accepttext()

this.setitem(row, "data_changed", 1)

choose case dwo.name
	case "responsible_psm"
		this.getchild("responsible_psm", ldwc_resp_psm)
		ls_status = ldwc_resp_psm.getitemstring(ldwc_resp_psm.getrow(), "user_status")
		if ls_status = "InActivate" then
			messagebox("Validation Error", "Selected user is marked as inactive. Please select another user.")
			if this.getitemstring(row, "responsible_psm", primary!, true) <>  this.getitemstring(row, "responsible_psm", primary!, false) then
				this.setitem(row, "responsible_psm", this.getitemstring(row, "responsible_psm", primary!, true) )
			else
				this.setitem(row, "responsible_psm", ls_null)
			end if
			setcolumn("responsible_psm")
			return 2
		end if
end choose
end event

event losefocus;call super::losefocus;this.accepttext()
end event

type st_contacts from statictext within tabpage_owners_matters
boolean visible = false
integer x = 3621
integer y = 12
integer width = 251
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Contacts"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_department_list from mt_u_datawindow within tabpage_owners_matters
boolean visible = false
integer x = 2103
integer y = 76
integer width = 2322
integer height = 1328
integer taborder = 60
string dataobject = "d_sq_ff_department_list"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;long li_pallets

choose case dwo.name
	case "pallets"
		if data = '' then
			setnull(li_pallets)
			this.post setitem(row, "pallets", li_pallets)
		end if
	case "weight"
		if long(data) < 0 then
			this.post setitem(row, "weight", abs(long(data)))
		end if
end choose

dw_department_info.setitem(dw_department_info.getrow(), "data_changed", 1)
end event

event editchanged;call super::editchanged;long li_pallets

if dwo.name = "pallets" or dwo.name = "pallets_1" then
	if data = '' then
		setnull(li_pallets)
		this.setitem( row, "pallets", li_pallets)
		this.setcolumn("pallets")
	elseif data = '0' then
		this.setitem( row, "pallets", 0)
		this.setcolumn("pallets_1")
	elseif long(data) < 0 then
		this.setitem( row, "pallets", abs(long(data)))
	end if
end if
end event

event itemfocuschanged;call super::itemfocuschanged;if dwo.name = "pallets" or dwo.name = "pallets_1" or dwo.name = "weight" then
	this.selecttext(1, 12)
end if
end event

type cb_cancel from commandbutton within tabpage_owners_matters
integer x = 4119
integer y = 1452
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "C&ancel"
end type

event clicked;string	ls_voyage_nr, ls_port_code
integer	li_pcn, li_row
long		ll_owner_id

if dw_department_info.rowcount() < 1 and dw_department_list.rowcount() < 1 then return

li_row = dw_proc_pcnc.getselectedrow(0)

ls_voyage_nr = dw_proc_pcnc.getitemstring(li_row, "proceed_voyage_nr")
ls_port_code = dw_proc_pcnc.getitemstring(li_row, "proceed_port_code")
li_pcn 		 = dw_proc_pcnc.getitemnumber(li_row, "proceed_pcn")

dw_department_info.reset()
dw_department_list.reset()
//Retrieve OWNER_MATTERS_DOCUMENT
dw_department_info.retrieve(ii_vessel_nr, ls_voyage_nr, ls_port_code, li_pcn)

if dw_department_info.rowcount() > 0 then
	ll_owner_id = dw_department_info.getitemnumber(1, "owner_department_id")
	
	dw_department_list.retrieve(ll_owner_id)
end if

ib_allowclose = true

end event

type cb_print from commandbutton within tabpage_owners_matters
integer x = 3767
integer y = 1452
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;string	ls_voyagenr, ls_portcode
string	ls_next_portcode, ls_next_portname, ls_next_status
integer	li_pcn, li_getrow, li_isallnull, li_sumallnull
long		ll_owndpid
datetime	ldt_next_arrival

dw_department_info.accepttext()
dw_department_list.accepttext()

if dw_department_info.rowcount() < 1 and dw_department_list.rowcount() < 1 then return

if dw_department_info.modifiedcount() + dw_department_list.modifiedcount() > 0 then
	messagebox("Data Not Saved", "Owners Matters modified, but not saved.~n~r~n~r" + &
				  "Please update data before print.")
	return
end if

ls_voyagenr = dw_department_info.getitemstring(dw_department_info.getrow(), "voyage_nr")
ls_portcode = dw_department_info.getitemstring(dw_department_info.getrow(), "port_code")
li_pcn		= dw_department_info.getitemnumber(dw_department_info.getrow(), "pcn")
ll_owndpid	= dw_department_info.getitemnumber(dw_department_info.getrow(), "owner_department_id")

dw_print.settransobject(sqlca)
dw_print.retrieve(il_vessel_nr, ls_voyagenr, ls_portcode, li_pcn, ll_owndpid)

if dw_print.rowcount() <= 0 then dw_print.insertrow(0)

//Get next port's information, there is not next port if getrow is the last row
li_getrow = dw_proc_pcnc.getrow()
if li_getrow <> dw_proc_pcnc.rowcount() then
	ls_next_portcode	= dw_proc_pcnc.getitemstring(li_getrow + 1, "proceed_port_code")
	ls_next_portname	= dw_proc_pcnc.getitemstring(li_getrow + 1, "proc_text")
	ls_next_status		= dw_proc_pcnc.getitemstring(li_getrow + 1, "compute_1")
	
	if ls_next_status = "Estimated" then
		ldt_next_arrival = dw_proc_pcnc.getitemdatetime(li_getrow + 1, "poc_est_port_arr_dt")
	else
		ldt_next_arrival = dw_proc_pcnc.getitemdatetime(li_getrow + 1, "poc_port_arr_dt")
	end if

	//Set next port's information
	dw_print.object.t_portcode.text	= ls_next_portcode
	dw_print.object.t_portname.text	= ls_next_portname
	dw_print.object.t_status.text		= ls_next_status
	dw_print.object.t_arrival.text	= string(ldt_next_arrival, "dd-mm-yyyy hh:mm")
end if

dw_print.accepttext()

//Delete empty department
li_sumallnull = dw_print.getitemnumber(dw_print.rowcount(), "sum_allnull")
if li_sumallnull = 0 then	//All rows are empty
	for li_getrow = dw_print.rowcount() to 2 step -1
		li_isallnull = dw_print.getitemnumber(li_getrow, "is_allnull")
		if li_isallnull = 0 then dw_print.deleterow(li_getrow)
		dw_print.deleterow(li_getrow)
	next
	dw_print.modify("datawindow.detail.height = 0")
else	//Exist not null department.
	for li_getrow = dw_print.rowcount() to 1 step -1
		li_isallnull = dw_print.getitemnumber(li_getrow, "is_allnull")
		if li_isallnull = 0 then dw_print.deleterow(li_getrow)
	next
	dw_print.modify("contact1.height = 192")
	dw_print.modify("contact2.height = 192")
end if

dw_print.print()

end event

type cb_update from commandbutton within tabpage_owners_matters
integer x = 3419
integer y = 1452
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;string  ls_resp_psm
long    ll_file_count, ll_row
integer li_datachanged

dw_department_info.accepttext()
dw_department_list.accepttext()

if dw_department_info.rowcount() < 1 and dw_department_list.rowcount() < 1 then return

ib_allowclose = false

//Responsible PSM be mandatory 
if dw_department_info.rowcount() > 0 then
	ll_row = dw_department_info.getrow()
	ls_resp_psm		= dw_department_info.getitemstring(ll_row, "responsible_psm")
	li_datachanged = dw_department_info.getitemnumber(ll_row, "data_changed")
	ll_file_count	= uo_attach.of_get_attachment_count()
	if (ls_resp_psm = '' or isnull(ls_resp_psm)) and (li_datachanged = 1 or ll_file_count > 0) then
		messagebox("Validation Error", "Responsible PSM must be filled out.")
		dw_department_info.setcolumn("responsible_psm")
		dw_department_info.setfocus()
		return
	end if
end if

ib_allowclose = true

if dw_department_info.modifiedcount() > 0 or &
	dw_department_list.modifiedcount() > 0 then
	
	if dw_department_info.update() = 1 and dw_department_list.update() = 1 then
		if not tab_poc.tabpage_owners_matters.uo_attach.enabled then
			tab_poc.tabpage_owners_matters.uo_attach.enabled = true
		end if
		commit;
	else
		rollback;
	end if
end if
end event

type uo_attach from u_fileattach within tabpage_owners_matters
event ue_itemchange pbm_dwnitemchange
boolean visible = false
integer x = 18
integer y = 620
integer width = 2048
integer height = 944
integer taborder = 130
string is_dataobjectname = "d_sq_gr_ownermatter_doc"
string is_counterlabel = "Attachments:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
boolean ib_autosave = true
end type

on uo_attach.destroy
call u_fileattach::destroy
end on

type dw_print from datawindow within tabpage_owners_matters
boolean visible = false
integer x = 914
integer y = 1116
integer width = 366
integer height = 288
integer taborder = 120
string title = "none"
string dataobject = "d_sq_ff_ownermatter_print"
boolean border = false
boolean livescroll = true
end type

type gb_activites from groupbox within tabpage_owners_matters
boolean visible = false
integer x = 2085
integer y = 12
integer width = 2377
integer height = 1440
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Activities in Port"
end type

type tabpage_bunker_stock from userobject within tab_poc
integer x = 18
integer y = 100
integer width = 4480
integer height = 1564
long backcolor = 67108864
string text = "Bunker Stock"
long picturemaskcolor = 536870912
cb_cancel_vessel_bunker_stock cb_cancel_vessel_bunker_stock
cb_update_vessel_bunker_stock cb_update_vessel_bunker_stock
dw_vessel_bunker_stock dw_vessel_bunker_stock
end type

on tabpage_bunker_stock.create
this.cb_cancel_vessel_bunker_stock=create cb_cancel_vessel_bunker_stock
this.cb_update_vessel_bunker_stock=create cb_update_vessel_bunker_stock
this.dw_vessel_bunker_stock=create dw_vessel_bunker_stock
this.Control[]={this.cb_cancel_vessel_bunker_stock,&
this.cb_update_vessel_bunker_stock,&
this.dw_vessel_bunker_stock}
end on

on tabpage_bunker_stock.destroy
destroy(this.cb_cancel_vessel_bunker_stock)
destroy(this.cb_update_vessel_bunker_stock)
destroy(this.dw_vessel_bunker_stock)
end on

type cb_cancel_vessel_bunker_stock from mt_u_commandbutton within tabpage_bunker_stock
integer x = 2971
integer y = 1452
integer taborder = 30
string text = "C&ancel"
end type

event clicked;call super::clicked;
w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.ReselectRow(&
		w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.GetRow())
end event

type cb_update_vessel_bunker_stock from mt_u_commandbutton within tabpage_bunker_stock
integer x = 2624
integer y = 1452
integer taborder = 20
string text = "&Update"
end type

event clicked;call super::clicked;
IF w_port_of_call.tab_poc.tabpage_bunker_stock.dw_vessel_bunker_stock.Update() = 1 THEN
	Commit;
ELSE
	Rollback;
	MessageBox("Error","Update of Bunker Stock failed.")
END IF

end event

type dw_vessel_bunker_stock from mt_u_datawindow within tabpage_bunker_stock
integer y = 12
integer width = 2738
integer height = 380
integer taborder = 10
string dataobject = "d_sq_ff_vessel_bunker_stock"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;if dwo.name="stock_lastupdated" and keydown(KeyControl!) then
	this.setitem( row, "stock_lastupdated", datetime(string(today(),"dd/mm/yy hh:mm")) )
end if

end event

type dw_vessel_next_open from mt_u_datawindow within w_port_of_call_bak
integer x = 2194
integer y = 60
integer width = 1618
integer height = 52
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_vessel_next_open"
boolean border = false
end type

event losefocus;if ib_readonlyaccess = true then return
this.accepttext()
if this.update() = 1 then
	commit;
else
	rollback;
	MessageBox("Update Error", "Unable to store vessel next open position.")
end if
end event

type dw_voyage_next_open from mt_u_datawindow within w_port_of_call_bak
integer x = 2194
integer y = 124
integer width = 1618
integer height = 56
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_voyage_next_open"
boolean border = false
end type

event losefocus;if ib_readonlyaccess = true then return
this.accepttext()
if this.update() = 1 then
	commit;
else
	rollback;
	MessageBox("Update Error", "Unable to store voyage next open position.")
end if
end event

type shl_bunker from statichyperlink within w_port_of_call_bak
integer x = 4247
integer y = 372
integer width = 229
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "FPM&S"
boolean focusrectangle = false
string url = "http://MSWEB.apmoller.net"
end type

type st_responsible from statictext within w_port_of_call_bak
integer x = 3854
integer width = 325
integer height = 200
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Responsible Operator: "
alignment alignment = right!
boolean focusrectangle = false
end type

type shl_1 from statichyperlink within w_port_of_call_bak
integer x = 4247
integer y = 440
integer width = 233
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "&YourISS"
boolean focusrectangle = false
string url = "http://www.youriss.com"
end type

type dw_task_list from mt_u_datawindow within w_port_of_call_bak
integer x = 3479
integer y = 920
integer width = 1047
integer height = 1520
integer taborder = 130
string dataobject = "d_sq_tv_poc_task_list"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event losefocus;if ib_readonlyaccess = true then return

this.accepttext()
if this.update() = 1 then
	commit;
else
	rollback;
	MessageBox("Update Error", "Unable to update changes in the task list.")
end if
end event

event clicked;this.accepttext( )
if dwo.name ="poc_task_list_task_done" then
	dw_task_list.setitem(row, "poc_task_list_task_na", 0)
	if dw_task_list.getitemnumber(row,"poc_task_list_task_done" ) = 0 then
		dw_task_list.setitem(row, "poc_task_list_task_last_updated", now() )
		dw_task_list.setitem(row, "poc_task_list_task_updated_by", uo_global.is_userid)
	end if
elseif dwo.name ="poc_task_list_task_na" then
	dw_task_list.setitem(row, "poc_task_list_task_done", 0)
	if dw_task_list.getitemnumber(row,"poc_task_list_task_na" ) = 0 then
		dw_task_list.setitem(row, "poc_task_list_task_last_updated", now() )
		dw_task_list.setitem(row, "poc_task_list_task_updated_by", uo_global.is_userid)
	end if
else
	return
end if



end event

type gb_5 from groupbox within w_port_of_call_bak
integer x = 3447
integer y = 864
integer width = 1111
integer height = 1608
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
end type

type st_topbar_background from u_topbar_background within w_port_of_call_bak
integer width = 6002
integer height = 232
end type

type rb_1 from radiobutton within w_port_of_call_bak
integer x = 1810
integer y = 64
integer width = 306
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Proc.Date"
boolean checked = true
end type

event clicked;
dw_proc_pcnc.SetSort("SORT_YEAR_VOYAGE A,PROCEED_VOYAGE_NR A, PROCEED_PROC_DATE A")
dw_proc_pcnc.Sort()

/* Scroll to last Row */ 
dw_proc_pcnc.ScrollToRow(dw_proc_pcnc.RowCount())

rb_1.checked = true
end event

type rb_2 from radiobutton within w_port_of_call_bak
integer x = 1810
integer y = 128
integer width = 302
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Arr. Date"
end type

event clicked;
dw_proc_pcnc.SetSort("SORT_YEAR_VOYAGE A, PROCEED_VOYAGE_NR A, POC_PORT_ARR_DT A")
dw_proc_pcnc.Sort()

/* Scroll to last Row */ 
dw_proc_pcnc.ScrollToRow(dw_proc_pcnc.RowCount())

rb_2.checked = true

//CR2535 & 2536 Begin added by ZSW001 on 17/11/2011
if uo_global.ib_pocautoschedule then
	messagebox("Auto Schedule Off", "You are going to sort the port of calls by Arrival Date, and the auto schedule calculation will be turned off temporarily. To turn it on again, please select to sort the port of calls by Proceeding Date.")
end if
//CR2535 & 2536 End added by ZSW001 on 17/11/2011

end event

type st_date from statictext within w_port_of_call_bak
integer x = 2706
integer width = 151
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
boolean enabled = false
string text = "Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_portarea from statictext within w_port_of_call_bak
integer x = 3237
integer width = 270
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
boolean enabled = false
string text = "Port / Area"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_bol_in_poc from u_popupdw within w_port_of_call_bak
integer y = 624
integer width = 2542
integer height = 464
integer taborder = 60
string dataobject = "d_bol_in_poc"
boolean ib_autoclose = false
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

type st_warning from statictext within w_port_of_call_bak
integer x = 1106
integer y = 2360
integer width = 873
integer height = 108
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_ecovoy from statichyperlink within w_port_of_call_bak
integer x = 4247
integer y = 304
integer width = 229
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HyperLink!"
long textcolor = 16711680
long backcolor = 67108864
string text = "Eco&Voy"
boolean focusrectangle = false
string url = "http://ecovoyagetracker.apmoller.net/"
end type

type dw_voyage_alert from u_popupdw within w_port_of_call_bak
integer x = 695
integer y = 416
integer width = 2322
integer height = 468
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sq_ff_voyage_alert_poc"
boolean hscrollbar = true
boolean livescroll = true
borderstyle borderstyle = styleraised!
boolean ib_autoclose = false
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

event clicked;this.visible = false
dw_proc_pcnc.setfocus()
end event

type ids_auto_est from mt_n_datastore within w_port_of_call_bak descriptor "pb_nvo" = "true" 
event create ( )
event destroy ( )
end type

on ids_auto_est.create
call super::create
end on

on ids_auto_est.destroy
call super::destroy
end on

type ids_auto_act from mt_n_datastore within w_port_of_call_bak descriptor "pb_nvo" = "true" 
event create ( )
event destroy ( )
end type

on ids_auto_act.create
call super::create
end on

on ids_auto_act.destroy
call super::destroy
end on

