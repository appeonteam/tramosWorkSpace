$PBExportHeader$w_calc_cp_data.srw
$PBExportComments$Details for certeparti
forward
global type w_calc_cp_data from mt_w_response_calc
end type
type dw_cp_charterer from u_datagrid within w_calc_cp_data
end type
type cb_charterer_delete from mt_u_commandbutton within w_calc_cp_data
end type
type cb_charterer_new from mt_u_commandbutton within w_calc_cp_data
end type
type cb_detach from mt_u_commandbutton within w_calc_cp_data
end type
type cb_select from mt_u_commandbutton within w_calc_cp_data
end type
type cb_calc_cp_refresh from mt_u_commandbutton within w_calc_cp_data
end type
type cb_calc_cp_delete from mt_u_commandbutton within w_calc_cp_data
end type
type cb_new from mt_u_commandbutton within w_calc_cp_data
end type
type dw_profit_c_no_lb from u_datawindow_sqlca within w_calc_cp_data
end type
type st_2 from uo_st_base within w_calc_cp_data
end type
type st_1 from u_topbar_background within w_calc_cp_data
end type
type cb_office from commandbutton within w_calc_cp_data
end type
type dw_calc_cp_data from u_datawindow_sqlca within w_calc_cp_data
end type
type cb_wiew_terms from uo_cb_base within w_calc_cp_data
end type
type cb_new_term from uo_cb_base within w_calc_cp_data
end type
type cb_refresh from uo_cb_base within w_calc_cp_data
end type
type dw_calc_std_short_text from u_datawindow_sqlca within w_calc_cp_data
end type
type gb_3 from uo_gb_base within w_calc_cp_data
end type
type gb_cp_terms from uo_gb_base within w_calc_cp_data
end type
type dw_calc_broker_data from u_datawindow_sqlca within w_calc_cp_data
end type
type cb_insert_row from uo_cb_base within w_calc_cp_data
end type
type cb_delete from uo_cb_base within w_calc_cp_data
end type
type gb_brokers from uo_gb_base within w_calc_cp_data
end type
type cb_ok from uo_cb_base within w_calc_cp_data
end type
type gb_charterers from uo_gb_base within w_calc_cp_data
end type
type uo_att from u_fileattach within w_calc_cp_data
end type
type gb_attachments from groupbox within w_calc_cp_data
end type
type dw_calc_cp_list from u_datagrid within w_calc_cp_data
end type
end forward

global type w_calc_cp_data from mt_w_response_calc
integer x = 50
integer y = 84
integer width = 4603
integer height = 2340
string title = "C/P"
string icon = "images\cp.ICO"
boolean ib_setdefaultbackgroundcolor = true
dw_cp_charterer dw_cp_charterer
cb_charterer_delete cb_charterer_delete
cb_charterer_new cb_charterer_new
cb_detach cb_detach
cb_select cb_select
cb_calc_cp_refresh cb_calc_cp_refresh
cb_calc_cp_delete cb_calc_cp_delete
cb_new cb_new
dw_profit_c_no_lb dw_profit_c_no_lb
st_2 st_2
st_1 st_1
cb_office cb_office
dw_calc_cp_data dw_calc_cp_data
cb_wiew_terms cb_wiew_terms
cb_new_term cb_new_term
cb_refresh cb_refresh
dw_calc_std_short_text dw_calc_std_short_text
gb_3 gb_3
gb_cp_terms gb_cp_terms
dw_calc_broker_data dw_calc_broker_data
cb_insert_row cb_insert_row
cb_delete cb_delete
gb_brokers gb_brokers
cb_ok cb_ok
gb_charterers gb_charterers
uo_att uo_att
gb_attachments gb_attachments
dw_calc_cp_list dw_calc_cp_list
end type
global w_calc_cp_data w_calc_cp_data

type variables
public long il_cpno
public boolean ib_status
Private u_dddw_search iuo_dddw_search_broker
Private u_dddw_search iuo_dddw_search_charterer
Private u_dddw_search iuo_dddw_search_city
Private w_fileattachment iw_fileattachment
Private u_atobviac_calculation iuo_calculation

Private u_dddw_search inv_dddw_search_chart_primary
Private u_dddw_search inv_dddw_search_chart_secondary

boolean ib_new

CONSTANT STRING is_NEW     = "NEW"
CONSTANT STRING is_UPDATE  = "UPDATE"
CONSTANT STRING is_CANCEL  = "CANCEL"
CONSTANT STRING is_INITIAL = "INITIAL"

n_messagebox inv_messagebox




end variables

forward prototypes
public function boolean wf_save ()
public subroutine documentation ()
public subroutine wf_enabled_button (string as_status)
public function integer wf_validation_charterer ()
public function boolean wf_deletefiles ()
private subroutine wf_rollback (string as_message)
public function integer wf_validate ()
end prototypes

public function boolean wf_save ();
/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_cp_data
  
 Object     : wf_save
  
 ************************************************************************************
 Author    :Teit Aunt 
   
 Date       : 31-7-96

 Description : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
------------------------------------------------------------------------------------
7-8-96		1.1			TA		Correcting erors
1-8-96		1.1			TA		description not null
31-7-96		1.0 			TA		Initial version
************************************************************************************/
// Cp id is taken from dw_calc_cp_data and inserted into broker

Long ll_cal_cerp_id, ll_rows, ll_count
DateTime ldt_cerp_date
Long li_noticebar_days, li_timebar_days
String ls_description, ls_error_string
boolean lb_descrip, lb_return
long	ll_rc, ll_profit

dw_calc_broker_data.AcceptText()
dw_calc_cp_data.AcceptText()

// There has to be something in the description field on cp_data
string ls_descrip
long ll_cpRowNum
ll_cpRowNum = dw_calc_cp_data.GetRow()
ls_descrip = dw_calc_cp_data.GetItemString(ll_cpRowNum, "cal_cerp_description")
If Not f_validstring(ls_descrip) Then
	ls_error_string = "There has to be a value in the C/P text field !"
	lb_descrip = TRUE
End If

// There has to be a contract type
long ll_contract
ll_contract  = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_contract_type")
If (IsNull(ll_contract) Or (ll_contract <= 0)) And Not (lb_descrip) Then
	ls_error_string = "There has to be a value in the contract type field"
	lb_descrip = TRUE
End If

// There has to be defined a time bar
long ll_timebar
ll_timebar  = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_timebar_days")
If (IsNull(ll_timebar) Or (ll_timebar <= 0)) And Not (lb_descrip) Then
	ls_error_string = "There has to be a value in the time bar field !"
	lb_descrip = TRUE
End If

// Validating the addrs. comm field
long ll_add
ll_add = dw_calc_cp_data.GetItemNumber(ll_cpRowNum,"cal_cerp_add_comm")
If (ll_add < 0 Or ll_add > 100) And Not (lb_descrip) Then
	ls_error_string = "The address commission is not valid"
	lb_descrip = TRUE
End If

// There has to be somthing in the charterer field
long ll_chart
ll_chart = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "chart_nr")
If (IsNull(ll_chart) Or (ll_chart <= 0)) And Not (lb_descrip) Then
	ls_error_string = "There has to be a value in the charterer field !"
	lb_descrip = TRUE
End If

// There has to be somthing in the office field
long ll_office_nr
ll_office_nr = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_cal_cerp_office_nr")
If (IsNull(ll_office_nr) Or (ll_office_nr <= 0)) Then
	ls_error_string = "There has to be a value in the office field !"
	lb_descrip = TRUE
End If

// There has to be selected a broker and a % entered
Integer li_broker, li_commission
Long ll_rnum, ll_no_of_rows
// Look to see if there is any rows in broker data
ll_no_of_rows = dw_calc_broker_data.RowCount()
If (ll_no_of_rows = 0) And Not (lb_descrip) Then
	ls_error_string = "There has to be a broker and a commission !"
	lb_descrip = TRUE
End If
If ll_no_of_rows > 0 Then
	ll_rnum = dw_calc_broker_data.GetRow()
	li_broker = dw_calc_broker_data.GetItemNumber(ll_rnum,"cal_comm_broker_nr")
	If (IsNull(li_broker) Or (li_broker = 0 )) And Not (lb_descrip) Then
		ls_error_string = "There has to be a broker !"
		lb_descrip = TRUE
	End If
End If

// Check for duplicate brokers - CONASW (22Sep09)
If Not lb_descrip then
	For ll_Rows = 1 to dw_calc_broker_data.Rowcount( ) - 1
		If dw_calc_broker_data.Find("cal_comm_broker_nr = " + String(dw_calc_broker_data.GetItemNumber(ll_Rows, "cal_comm_broker_nr")), ll_Rows + 1, dw_calc_broker_data.RowCount() + 1) > 0 then
			lb_descrip = True
			ls_error_string = "A broker is duplicated!"
		End If
	Next
End If

// Validating the commission field
long ll_comm_pcnt
ll_comm_pcnt = dw_calc_broker_data.GetItemNumber(ll_cpRowNum,"cal_comm_cal_comm_percent")
If (ll_comm_pcnt < 0 Or ll_comm_pcnt > 100) And Not (lb_descrip) Then
	ls_error_string = "The broker commission is not valid !"
	lb_descrip = TRUE
End If

If ll_no_of_rows > 0 Then 
	li_commission = dw_calc_broker_data.GetItemNumber(dw_calc_broker_data.GetRow(),"cal_comm_cal_comm_percent")
	If (IsNull(li_commission)) And Not (lb_descrip) Then
		ls_error_string = "There has to be a commission (%) !"
		lb_descrip = TRUE
	End If
End If



If  NOT(lb_descrip) Then
	If dw_calc_cp_data.Update(true, false)=1 Then
		ll_cal_cerp_id = dw_calc_cp_data.GetItemNumber(1,"cal_cerp_id")
		If IsNull(ll_cal_cerp_id) Or (ll_cal_cerp_id =0)  Then
			// Find just opdaterede CP-ID (this code will propably never be executed)
			ldt_cerp_date = dw_calc_cp_data.GetItemDateTime(1,"cal_cerp_date")
			li_noticebar_days = dw_calc_cp_data.GetItemNumber(1,"cal_cerp_noticebar_days")
			li_timebar_days = dw_calc_cp_data.GetItemNumber(1,"cal_cerp_timebar_days")
			ls_description = dw_calc_cp_data.GetItemString(1,"cal_cerp_description")
	
			SELECT CAL_CERP_ID
			INTO	 :ll_cal_cerp_id
			FROM CAL_CERP
			WHERE CAL_CERP_DATE = :ldt_cerp_date AND
				CAL_CERP_NOTICEBAR_DAYS = :li_noticebar_days AND
				CAL_CERP_TIMEBAR_DAYS = :li_timebar_days AND
				CAL_CERP_DESCRIPTION = :ls_description
			ORDER BY CAL_CERP_ID DESC;
		End if 

		// Updating the tables
		If ll_cal_cerp_id > 0 Then
			ll_rows = dw_calc_broker_data.RowCount()
			For ll_count = 1 To ll_rows 
				dw_calc_broker_data.SetItem(ll_count,"cal_cerp_id", ll_cal_cerp_id)
			Next

			If dw_calc_broker_data.Update(true,false) = 1 Then
				il_cpno = ll_cal_cerp_id
				lb_return =  true
			Else
				ROLLBACK;
				MessageBox("Error","Did not save !")
				lb_return = False
			End if
		End if
	Else
		ROLLBACK;
	End if
Else
	MessageBox("Error",ls_error_string)
	lb_return = False
End If

Return(lb_return)
end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_calc_cp_data
   <OBJECT> Main C/P window where user can provide Charter Party information and
	attach to the calculation.</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Opened from CP icon -> CP list </USAGE>
   <ALSO>
	</ALSO>
	<HISTORY>
		Date    		Ref   		Author		Comments
		29/10/10		CR2171   	AGL027		Added attachment object u_fileattach into window
		28/09/11		CR2500   	AGL027		Modified of_modifyoperations() call and also
														a loop to force a retreive on any relavent calculations.
		21-11-11		CR2625   	CONASW		Changed Office selection DW (to get active offices only)
		17/01/13		CR2877   	WWA048		Merge the C/P-list and C/P-data window, and added
														Charterer select datawindow into the window.
		11/06/13		CR2877   	ZSW001		Remove 'Claim Type' field from CP charterer list and add related validation.
		06/12/13		CR2877   	AGL027		Updated file attachment process
		12/12/13		CR2877UAT	ZSW001		Fixed system error in CP data
		22/05/14		CR3524   	AZX004		In the Charter of the drop-down selection in data window, increase the inactivation of Charter, but there is no choice.
		26/05/14		CR3709   	AZX004		Delete C/P.
		24/06/14		CR3421   	KSH092		Add a validation on profit center of vessel and CP when click button "select" 
		07/08/14		CR3708   	AGL027		F1 help application coverage - corrected ancestor
		12/09/14		CR3773   	XSZ004		Change icon absolute path to reference path
		14/05/15		CR3626   	LHG008		When type the first letters of an existing charterer, the dropdown list unfolds with the right charterer selected
		20/06/16		CR3893		XSZ004		Adjust validation.
		25/09/17		CR4725		EPE080	    Add C/P Speed
	</HISTORY>
********************************************************************/

end subroutine

public subroutine wf_enabled_button (string as_status);/********************************************************************
   wf_enabled_button
   <DESC>	Enabled or disabled button	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_status
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18/01/2013 CR2877       WWA048				 First Version
   </HISTORY>
********************************************************************/

long	ll_status, ll_cargo, ll_row, ll_count
dec	ld_cerp_id

choose case as_status
	case is_NEW
		ib_new = true
		cb_new.enabled = false
		cb_ok.enabled = true
		cb_calc_cp_delete.enabled = false
		cb_calc_cp_refresh.enabled = true
		cb_select.enabled = false
		cb_detach.enabled = false
	case is_UPDATE, is_CANCEL
		ib_new = false
		cb_new.enabled = true
		cb_ok.enabled = true
		if dw_calc_cp_list.rowcount() > 0 then
			cb_calc_cp_delete.enabled = true
			cb_select.enabled = true
		else
			cb_calc_cp_delete.enabled = false
			cb_select.enabled = false
		end if
		cb_calc_cp_refresh.enabled = true
		cb_detach.enabled = true
	case is_INITIAL
		ll_cargo = iuo_calculation.uf_get_cargo()
		ll_status = iuo_calculation.uf_get_status(ll_cargo)
		if ll_status > 3 then  
			cb_select.enabled = false
			cb_new.enabled = false
			cb_detach.enabled = false
			cb_calc_cp_delete.enabled = false
		else
			cb_new.enabled = true
			
			if dw_calc_cp_list.rowcount() > 0  then
				cb_select.enabled = true
			else
				cb_select.enabled = false
			end if
			
			ld_cerp_id = iuo_calculation.uf_get_cerp_id(ll_cargo)
			if isnull(ld_cerp_id) or il_cpno <> ld_cerp_id then
				cb_detach.enabled = false
			else
				cb_detach.enabled = true
			end if
			
			if dw_calc_cp_list.rowcount() > 0 then
				ll_row = dw_calc_cp_list.getselectedrow(0)
				if ll_row > 0 then
					ld_cerp_id = dw_calc_cp_list.getitemnumber(ll_row, "cal_cerp_cal_cerp_id")
				end if
			end if
			
			SELECT COUNT(CAL_CERP_ID)
			  INTO :ll_count
			  FROM CAL_CARG
			 WHERE (CAL_CERP_ID = :ld_cerp_id);
			
			if ll_count > 0 or cb_detach.enabled then 
				cb_calc_cp_delete.enabled = false
			else
				cb_calc_cp_delete.enabled = true
			end if
		end if
end choose
end subroutine

public function integer wf_validation_charterer ();/********************************************************************
   wf_validation_charterer
   <DESC> After primary charterer is changed or created, write it back to datawindow dw_calc_cp_data </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	26/02/2013 CR2877       WWA048        First Version
		07/06/2013 CR2877       ZSW001        Revision
   </HISTORY>
********************************************************************/

long		ll_claim_nr, ll_chart_count, ll_claims_count, ll_found, ll_loop, ll_cp_chart_nr
long		ll_primary_chart, ll_cp_id, ll_prev_chart_printed, ll_curr_chart_printed
string	ls_vessel_ref, ls_voyage_nr, ls_claim_type, ls_chart_n_1, ls_claimlist

mt_n_datastore					lds_claims
n_service_manager          lnv_svcmgr
n_dw_validation_service    lnv_rules

if dw_cp_charterer.modifiedcount() + dw_cp_charterer.deletedcount() <= 0 then return c#return.Success

ll_chart_count = dw_cp_charterer.rowcount()

ll_found = dw_cp_charterer.find("isprimary = 1", 1, ll_chart_count)
if ll_found > 0 then
	ll_primary_chart = dw_cp_charterer.getitemnumber(ll_found, "chart_nr")
else
	messagebox("Information", "Please select one Charterer as Primary Charterer.")
	return c#return.Failure
end if

//Check for null value and check if the charterer is unique
lnv_svcmgr.of_loadservice(lnv_rules, "n_dw_validation_service")
lnv_rules.of_registerrulestring("chart_nr_2", true, "Charterer Name", true)
if lnv_rules.of_validate(dw_cp_charterer, true) = c#return.Failure then return c#return.Failure

if dw_calc_cp_data.getitemstatus(1, 0, primary!) <> newmodified! then
	ll_cp_id = dw_calc_cp_data.getitemnumber(1, "cal_cerp_id")
	
	//It must not be possible to delete/modify any charterer that has been used for printing on any existing claim connected to this C/P - settled or unsettled.
	lds_claims = create mt_n_datastore
	lds_claims.dataobject = "d_sq_gr_cp_claims"
	lds_claims.settransobject(sqlca)
	ll_claims_count = lds_claims.retrieve(ll_cp_id)
		
	for ll_loop = 1 to ll_claims_count
		ll_curr_chart_printed = lds_claims.getitemnumber(ll_loop, "chart_nr_printed")
		ll_found = dw_cp_charterer.find("chart_nr = " + string(ll_curr_chart_printed), 1, ll_chart_count)
		if ll_found <= 0 then
			ls_vessel_ref = lds_claims.getitemstring(ll_loop, "vessel_ref_nr")
			ls_voyage_nr  = lds_claims.getitemstring(ll_loop, "voyage_nr")
			ll_claim_nr   = lds_claims.getitemnumber(ll_loop, "claim_nr")
			ls_claim_type = lds_claims.getitemstring(ll_loop, "claim_type")
			ls_chart_n_1  = lds_claims.getitemstring(ll_loop, "chart_n_1")
			
			if ll_curr_chart_printed <> ll_prev_chart_printed then
				if ls_claimlist <> "" then ls_claimlist += "~r~n"
				ls_claimlist += "The charterer '" + string(ls_chart_n_1) + "' cannot be deleted or modified " + &
				                "since it has been used for printing on the following claim(s) connected to this C/P.~r~n"
				ll_prev_chart_printed = ll_curr_chart_printed
			end if
			
			ls_claimlist += "Vessel = " + ls_vessel_ref + ", Voyage = '" + ls_voyage_nr + "', Claim NR = " + &
								 string(ll_claim_nr) + ", Claim Type = '" + ls_claim_type + "'~r~n"
		end if
	next
	
	destroy lds_claims
	
	if ls_claimlist <> "" then
		messagebox("Information", ls_claimlist)
		dw_cp_charterer.setfocus()
		return c#return.Failure
	end if
end if

ll_cp_chart_nr = dw_calc_cp_data.getitemnumber(1, "chart_nr")
if isnull(ll_cp_chart_nr) or ll_cp_chart_nr <> ll_primary_chart then
	dw_calc_cp_data.setitem(1, "chart_nr", ll_primary_chart)
end if

return c#return.Success

end function

public function boolean wf_deletefiles ();/********************************************************************
wf_deletefiles() 

<DESC>
	rewritten function to make use of u_fileattach code
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	n/a
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

long ll_rows, ll_row, ll_ret
boolean lb_batchdeletion=true, lb_ret

lb_ret = true
ll_rows = uo_att.dw_file_listing.rowcount()
for ll_row = ll_rows to 1 step -1
	ll_ret = uo_att.of_deleteimage(ll_row, lb_batchdeletion)
	if ll_ret <> c#return.success then lb_ret =false		
next 

return lb_ret

end function

private subroutine wf_rollback (string as_message);/***********************************************************************************
wf_rollback
<DESC>		Description	</DESC>
<RETURN>	(none)	</RETURN>
<ACCESS> private </ACCESS>
<ARGS>
	as_message
</ARGS>
<USAGE>	wf_rollback(as_message)	</USAGE>
<HISTORY>
	Date 	 	CR-Ref		Author	 	Comments
	2014-06-30 	CR3709 	 	Alber 	First Version
</HISTORY>
***********************************************************************************/

ROLLBACK USING SQLCA;
messagebox("Warning",as_message)
triggerevent("ue_retrieve")
	
end subroutine

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>	Validate cp data </DESC>
   <RETURN>	integer:
            <LI> c#return.Success
            <LI> c#return.Failure </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		20/06/16		CR3893		XSZ004		First version
		25/09/25     CR4725       EPE080       add C/P Speed validation
   </HISTORY>
********************************************************************/

datetime ldt_cerp_date
integer	li_broker, li_commission, li_ret
string 	ls_error_string, ls_descrip, ls_newmessage
long		ll_contract, ll_rnum, ll_no_of_rows, ll_timebar, ll_add, ll_chart, ll_office_nr, ll_comm_pcnt, ll_cprownum, ll_rows, ll_profit
dec		ld_speed


ll_cpRowNum = dw_calc_cp_data.GetRow()
ls_descrip = dw_calc_cp_data.GetItemString(ll_cpRowNum, "cal_cerp_description")

If Not f_validstring(ls_descrip) Then
	ls_error_string = "There has to be a value in the C/P text field !"
	li_ret = c#return.failure
End If

ll_contract  = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_contract_type")

If (IsNull(ll_contract) Or (ll_contract <= 0)) And li_ret <> c#return.failure Then
	ls_error_string = "There has to be a value in the contract type field"
	li_ret = c#return.failure
End If

ll_timebar  = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_timebar_days")

If (IsNull(ll_timebar) Or (ll_timebar <= 0)) And li_ret <> c#return.failure Then
	ls_error_string = "There has to be a value in the time bar field !"
	li_ret = c#return.failure
End If

ldt_cerp_date = dw_calc_cp_data.GetItemDatetime(ll_cpRowNum, "cal_cerp_date")

If IsNull(ldt_cerp_date) And li_ret <> c#return.failure Then
	ls_error_string = "There has to be a value in the C/P Date field!"
	li_ret = c#return.failure
End If

ll_add = dw_calc_cp_data.GetItemNumber(ll_cpRowNum,"cal_cerp_add_comm")

If (ll_add < 0 Or ll_add > 100) And li_ret <> c#return.failure Then
	ls_error_string = "The address commission is not valid"
	li_ret = c#return.failure
End If

ll_chart = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "chart_nr")

If (IsNull(ll_chart) Or (ll_chart <= 0)) And li_ret <> c#return.failure Then
	ls_error_string = "Please select a Primary Charterer."
	li_ret = c#return.failure
End If

ll_office_nr = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_cal_cerp_office_nr")

If (IsNull(ll_office_nr) Or (ll_office_nr <= 0)) and li_ret <> C#Return.Failure Then
	ls_error_string = "There has to be a value in the office field !"
	li_ret = c#return.failure
End If

ll_profit = dw_calc_cp_data.GetItemNumber(ll_cpRowNum, "cal_cerp_profit_center_no")

If (IsNull(ll_profit) Or (ll_profit <= 0)) and li_ret <> C#Return.Failure Then
	ls_error_string = "There has to be a value in the Profit Center field !"
	li_ret = c#return.failure
End If

ld_speed = dw_calc_cp_data.getitemnumber(ll_cpRowNum,"cal_cerp_speed")

if (isnull(ld_speed) or  ld_speed <= 0 or ld_speed > 99.99) and li_ret <> C#Return.Failure  then
	if isnull(ld_speed) then
		ls_error_string = 'You must enter a C/P Speed.'
	elseif ld_speed <= 0 or ld_speed > 99.99 then
		ls_error_string = 'You can only enter C/P Speed from 0.01 to 99.99.'
	end if
	ls_newmessage = 'yes'
	dw_calc_cp_data.setfocus()
	dw_calc_cp_data.setcolumn("cal_cerp_speed")
	li_ret = c#return.failure
end if
ll_no_of_rows = dw_calc_broker_data.RowCount()

If (ll_no_of_rows = 0) And li_ret <> c#return.failure Then
	ls_error_string = "There has to be a broker and a commission !"
	li_ret = c#return.failure
End If

if li_ret <> c#return.failure then
	If ll_no_of_rows > 0 Then
		for ll_rnum = 1 to ll_no_of_rows
			li_broker = dw_calc_broker_data.getitemnumber(ll_rnum, "cal_comm_broker_nr")
			if (isnull(li_broker) or (li_broker = 0 )) then
				ls_error_string = "There has to be a broker !"
				li_ret = c#return.failure
				dw_calc_broker_data.setrow(ll_rnum)
				dw_calc_broker_data.post setfocus()
				exit
			end if
		next
	end if
end if

If li_ret <> c#return.failure then
	For ll_Rows = 1 to dw_calc_broker_data.Rowcount( ) - 1
		If dw_calc_broker_data.Find("cal_comm_broker_nr = " + String(dw_calc_broker_data.GetItemNumber(ll_Rows, "cal_comm_broker_nr")), ll_Rows + 1, dw_calc_broker_data.RowCount() + 1) > 0 then
			li_ret = c#return.failure
			ls_error_string = "A broker is duplicated!"
		End If
	Next
End If

if li_ret <> c#return.failure then
	ll_comm_pcnt = dw_calc_broker_data.GetItemNumber(ll_cpRowNum,"cal_comm_cal_comm_percent")
	If (ll_comm_pcnt < 0 Or ll_comm_pcnt > 100) Then
		ls_error_string = "The broker commission is not valid !"
		li_ret = c#return.failure
	End If
end if

if li_ret <> c#return.failure then
	If ll_no_of_rows > 0 Then 
		li_commission = dw_calc_broker_data.GetItemNumber(dw_calc_broker_data.GetRow(),"cal_comm_cal_comm_percent")
		If (IsNull(li_commission)) Then
			ls_error_string = "There has to be a commission (%) !"
			li_ret = c#return.failure
		End If
	End If
end if

if li_ret = c#return.failure then
	if ls_newmessage = 'yes'  then 
		inv_messagebox.of_messagebox(inv_messagebox.is_TYPE_VALIDATION_ERROR, ls_error_string, this)
	else
		messagebox("Error", ls_error_string)
	end if
end if

return li_ret
end function

event ue_retrieve;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_calc_cp_data
 Object     : 
 Event	 :  ue_retrieve
 Scope     : local
 ************************************************************************************
 Author    :Teit Aunt 
 Date       : 2-8-96
 Description : Opens an existing record in the CP table or creates a new, empty row.
 					If it is an existing row it investigate wether a cargo or calculation
					the CP is attached to has been fixtured. If yes the CP is locked.

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
2-8-96		1.0 			TA		Initial version
  
************************************************************************************/
// Investigate wether there is a fixture on the cargo or calculation

ib_status = false
long 					ll_tmp, ll_nr, ll_rowsterms, ll_newbrokerrow
long					ll_vessel_id, ll_clarkson_id
integer 				li_profit_center
string 				ls_cargostatus, ls_sn, ls_vessel_name
datawindowchild 	dwc, ldwc_child

dw_calc_cp_data.getchild("cal_cerp_profit_center_no", dwc)
dwc.settransobject(sqlca)
dwc.retrieve(uo_global.is_userid)

if il_cpno > 0 then
	SELECT COUNT(CAL_CARG_ID)
	INTO :ll_tmp
	FROM CAL_CARG
	WHERE (CAL_CERP_ID = :il_cpno) AND
		(CAL_CARG_STATUS > 3);

	dw_calc_broker_data.retrieve(il_cpno)
	dw_cp_charterer.retrieve(il_cpno)

	// Retrive data for the cp terms data window
	ll_rowsterms = dw_calc_cp_data.retrieve(il_cpno )
	if ll_rowsterms < 1 then
		messagebox("Database Error", "No C/P's retrieved.")
	else
		ll_nr = dw_calc_cp_data.getitemnumber(1, "cal_cerp_cal_cerp_office_nr") 
		if ll_nr > 0 then
			SELECT OFFICE_SN INTO :ls_sn FROM OFFICES WHERE OFFICE_NR = :ll_nr;
			dw_calc_cp_data.setitem(1, "offices_office_sn", ls_sn)
			dw_calc_cp_data.update()
			if dw_calc_cp_data.getitemnumber(1,'calc_count') > 0 then
			   dw_calc_cp_data.modify("cal_cerp_profit_center_no.background.color = '" + string(c#color.Transparent) + "'")
			else
				dw_calc_cp_data.modify("cal_cerp_profit_center_no.background.color = '" + string(c#color.MT_MAERSK) + "'")
			end if
		end if	
	end if
	uo_att.enabled = true
	uo_att.of_init(il_cpno)
	
else
	// Scroll to a new row at the end of the table from the new button) 
	dw_calc_cp_data.reset()
	dw_cp_charterer.reset()	
	dw_calc_broker_data.reset()
	
	dw_cp_charterer.getchild("chart_nr_1", ldwc_child)
	ldwc_child.setfilter("")
	ldwc_child.filter()
	
	dw_calc_cp_data.insertrow(0)
	dw_calc_cp_data.modify("cal_cerp_profit_center_no.background.color = '" + string(c#color.MT_MAERSK) + "'")
	dw_cp_charterer.insertrow(0)
	ll_newbrokerrow = dw_calc_broker_data.insertrow(0)
	dw_calc_broker_data.scrolltorow(ll_newbrokerrow)
	dw_calc_cp_data.setitem(1, "cal_cerp_contract_type", 1)
	dw_calc_cp_data.setitem(1, "cal_cerp_add_comm", 0)
	dw_calc_cp_data.setitem(1, "cal_cerp_rev_freight", 1)

	li_profit_center = uo_global.get_profitcenter_no()
	If (li_profit_center = 3 Or li_profit_center = 5) Then
		dw_calc_cp_data.SetItem(1, "cal_cerp_rev_dem", 0)
	Else
		dw_calc_cp_data.SetItem(1, "cal_cerp_rev_dem", 1)
	End If
	
	// Give the C/P a profitcenter no, First is the same of the vessel's Primary Profitcenter, 
	//Second is the users, when user create a new CP
	li_profit_center = iuo_calculation.of_get_profit_center()
	dw_calc_cp_data.setitem(1, "cal_cerp_profit_center_no", li_profit_center)
	dw_calc_broker_data.setfocus()

	/* make sure attachments can not be added seperately */
	uo_att.ib_enable_update_button = false
	uo_att.of_init(il_cpno)
	uo_att.enabled = false
End If

if ib_status = true then
	messagebox("Information", "This C/P is locked")
end if

dw_calc_std_short_text.retrieve()

/* If external user - readOnly */
if uo_global.ii_access_level = -1 then 
	dw_calc_std_short_text.object.datawindow.readonly = "yes"
	dw_calc_broker_data.object.datawindow.readonly = "yes"
	dw_cp_charterer.object.datawindow.readonly = "yes"
	dw_calc_cp_data.object.datawindow.readonly = "yes"
end if

/* If CP is used on fixed calculation, lock some of the fields */ 
if ll_tmp > 0 then 
	dw_calc_std_short_text.modify("datawindow.readonly = yes")
	cb_refresh.enabled = false
	cb_wiew_terms.enabled = false
	cb_new_term.enabled = false
	dw_calc_cp_data.settaborder("cal_cerp_rev_freight", 0)
	dw_calc_cp_data.settaborder("cal_cerp_rev_dem", 0)
	dw_calc_cp_data.settaborder("cal_cerp_term", 0)
else
	cb_refresh.enabled = true
	cb_wiew_terms.enabled = true
	cb_new_term.enabled = true
	dw_calc_cp_data.settaborder("cal_cerp_term", 110)
end if

end event

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_cp_data
  
 Object     : dw_calc_cp_data
  
 ************************************************************************************
 Author    : Teit Aunt
   
 Date       : 17-7-96

 Description : Opens a new row/CP
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
17-7-96		1.0			TA		Initial version  
************************************************************************************/
// Retrive data for broker data windows
long					ll_cerp_id, ll_row, ll_count, ll_vessel_id, ll_clarkson_id, ll_calc_id
integer 				li_cargo, li_profit_center
string 				ls_vessel_name
datawindowchild 	ldwc

n_service_manager 	 lnv_servicemgr
n_dw_style_service 	 lnv_style

f_center_window(this)

postevent("ue_retrieve")

iuo_calculation = message.powerobjectparm

dw_profit_c_no_lb.getchild("pc_nr", ldwc)
ldwc.settransobject(sqlca)
ldwc.retrieve(uo_global.is_userid)

dw_profit_c_no_lb.retrieve(uo_global.is_userid)

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")

lnv_style.of_registercolumn("cal_comm_broker_nr", true, false)
lnv_style.of_registercolumn("cal_comm_cal_comm_percent", true, false)
lnv_style.of_dwlistformater(dw_calc_broker_data, false)

lnv_style.of_registercolumn("chart_nr", true, false)
lnv_style.of_registercolumn("chart_nr_1", true, false)
lnv_style.of_dwlistformater(dw_cp_charterer, false)

lnv_style.of_registercolumn("chart_nr", true, false)
lnv_style.of_registercolumn("cal_cerp_description", true, false)
lnv_style.of_registercolumn("offices_office_sn", true, false)
lnv_style.of_registercolumn("cal_cerp_contract_type", true, false)
lnv_style.of_registercolumn("cal_cerp_profit_center_no", true, false)
lnv_style.of_registercolumn("cal_cerp_date", true, false)
lnv_style.of_registercolumn("cal_cerp_add_comm", true, false)
lnv_style.of_registercolumn("cal_cerp_timebar_days", true, false)
lnv_style.of_registercolumn("cal_cerp_speed", true, false)
lnv_style.of_dwformformater(dw_calc_cp_data)

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_calc_cp_list, false)

lnv_style.of_autoadjustdddwwidth(dw_profit_c_no_lb, "pc_nr")
lnv_style.of_autoadjustdddwwidth(dw_calc_cp_data, "cal_cerp_profit_center_no")

if isvalid(iuo_calculation) then
	li_cargo = iuo_calculation.uf_get_cargo() // Hent nuværende cargo som redigeres
	ll_cerp_id = iuo_calculation.uf_get_cerp_id(li_cargo)
	
	// If there if a cp on the cargo, use it to sort cp-list and to set profit center
	If ll_cerp_id > 0 Then 
		SELECT CAL_CERP_PROFIT_CENTER_NO
		  INTO :li_profit_center
		  FROM CAL_CERP
		 WHERE CAL_CERP_ID = :ll_cerp_id;
	else
		li_profit_center = iuo_calculation.of_get_profit_center()
	end if
	
	dw_profit_c_no_lb.reset()
	dw_profit_c_no_lb.insertrow(0)
	dw_profit_c_no_lb.setitem(1, "pc_nr", li_profit_center)
	
	dw_calc_cp_list.retrieve(li_profit_center)
	
	// Find the CP
	ll_count = dw_calc_cp_list.rowcount()
	ll_row = dw_calc_cp_list.find("cal_cerp_cal_cerp_id = " + string(ll_cerp_id), 0, ll_count)
	if ll_row > 0 then
		dw_calc_cp_list.selectrow(0, false)
		dw_calc_cp_list.selectrow(ll_row, true)
	else
		ll_row = 1
	end if
	
	dw_calc_cp_list.scrolltorow(ll_row)
	dw_calc_cp_list.setrow(ll_row)
else
	messagebox("Error", "Calculation not valid!")
	return
end if 

wf_enabled_button(is_INITIAL)
//dw_cp_charterer.of_registerdddw("chart_nr_1"," 1 = 1 ")


if uo_global.ii_access_level = -2 then
	dw_profit_c_no_lb.enabled = false
end if

uo_att.dw_file_listing.modify("description.width = 2064")
end event

event closequery;call super::closequery;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_cp-list
  
 Object     : 
  
 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 1-8-96

 Description : Ask if user wants to save data yes/no/cancel

*************************************************************************************
Development Log 
DATE			VERSION 		NAME	DESCRIPTION
---------------------------------------------------------
01-08-96		1.0 			TA		Initial version
01-11-10    CR2171     	AGL   Added condition to include check of attachments
28-09-11		CR2500		AGL	Pass new window array structure through to of_modifyoperations()
										if everything works ok and we commit changes loop through this to
										re-retreieve data from db.
************************************************************************************/
//Ask if user wants to save data yes/no/cancel 

boolean							 lb_updated = false
constant integer				 li_QUITWINDOW = 2
integer							 li_retval = 0, li_modified
constant integer				 li_DOCLOSE = 0
constant integer				 li_DONOTHING = 1
long 								 ll_openindex, ll_row, ll_chart_nr, ll_return
long                        ll_chart_primary, ll_cerp_id, ll_found, ll_modify, ll_count
datetime                    ldt_cp_date
u_modify_cp						 lnv_modifycp
w_atobviac_calc_calculation lw_opencalcs[]

dw_calc_cp_data.accepttext()
dw_calc_broker_data.accepttext()
dw_cp_charterer.accepttext()
uo_att.dw_file_listing.accepttext()

ll_modify = dw_calc_broker_data.modifiedcount() + dw_calc_broker_data.deletedcount() + &
            dw_calc_cp_data.modifiedcount() + dw_calc_cp_data.deletedcount() + &
				dw_cp_charterer.modifiedcount() + dw_cp_charterer.deletedcount()
if ll_modify > 0 then
	
	ll_return = messagebox("Warning", "Current data is unsaved, save before close ?", StopSign!, YesNoCancel!)
	if ll_return = 1 then
		//if primary charterer is changed or new then write to datawindow dw_calc_cp_data
		if wf_validation_charterer() = c#return.Failure then return 1
		
		if wf_validate() = c#return.Failure then return 1
		  
		lnv_modifycp = create u_modify_cp
		li_modified = lnv_modifycp.of_updatecp(dw_calc_broker_data, dw_cp_charterer, dw_calc_cp_data, il_cpno, "")
	elseif ll_return = 2 then
		li_modified = 0
	else
		li_modified = 3
	end if
	
	if li_modified = c#return.Success then
		lb_updated = true
	elseif li_modified = c#return.Noaction then 
		cb_ok.enabled = true
		li_retval = li_DOCLOSE
	elseif li_modified = li_QUITWINDOW then	
		li_retval = li_DOCLOSE
	else /* its an error or cancel! */
		cb_ok.enabled = true
		li_retval = li_DONOTHING
	end if			
	destroy lnv_modifycp
end if

if lb_updated then 
	closewithreturn(this,1)
else
	//Message.ReturnValue = li_retval
	return li_retval
end if

end event

on w_calc_cp_data.create
int iCurrent
call super::create
this.dw_cp_charterer=create dw_cp_charterer
this.cb_charterer_delete=create cb_charterer_delete
this.cb_charterer_new=create cb_charterer_new
this.cb_detach=create cb_detach
this.cb_select=create cb_select
this.cb_calc_cp_refresh=create cb_calc_cp_refresh
this.cb_calc_cp_delete=create cb_calc_cp_delete
this.cb_new=create cb_new
this.dw_profit_c_no_lb=create dw_profit_c_no_lb
this.st_2=create st_2
this.st_1=create st_1
this.cb_office=create cb_office
this.dw_calc_cp_data=create dw_calc_cp_data
this.cb_wiew_terms=create cb_wiew_terms
this.cb_new_term=create cb_new_term
this.cb_refresh=create cb_refresh
this.dw_calc_std_short_text=create dw_calc_std_short_text
this.gb_3=create gb_3
this.gb_cp_terms=create gb_cp_terms
this.dw_calc_broker_data=create dw_calc_broker_data
this.cb_insert_row=create cb_insert_row
this.cb_delete=create cb_delete
this.gb_brokers=create gb_brokers
this.cb_ok=create cb_ok
this.gb_charterers=create gb_charterers
this.uo_att=create uo_att
this.gb_attachments=create gb_attachments
this.dw_calc_cp_list=create dw_calc_cp_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cp_charterer
this.Control[iCurrent+2]=this.cb_charterer_delete
this.Control[iCurrent+3]=this.cb_charterer_new
this.Control[iCurrent+4]=this.cb_detach
this.Control[iCurrent+5]=this.cb_select
this.Control[iCurrent+6]=this.cb_calc_cp_refresh
this.Control[iCurrent+7]=this.cb_calc_cp_delete
this.Control[iCurrent+8]=this.cb_new
this.Control[iCurrent+9]=this.dw_profit_c_no_lb
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cb_office
this.Control[iCurrent+13]=this.dw_calc_cp_data
this.Control[iCurrent+14]=this.cb_wiew_terms
this.Control[iCurrent+15]=this.cb_new_term
this.Control[iCurrent+16]=this.cb_refresh
this.Control[iCurrent+17]=this.dw_calc_std_short_text
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_cp_terms
this.Control[iCurrent+20]=this.dw_calc_broker_data
this.Control[iCurrent+21]=this.cb_insert_row
this.Control[iCurrent+22]=this.cb_delete
this.Control[iCurrent+23]=this.gb_brokers
this.Control[iCurrent+24]=this.cb_ok
this.Control[iCurrent+25]=this.gb_charterers
this.Control[iCurrent+26]=this.uo_att
this.Control[iCurrent+27]=this.gb_attachments
this.Control[iCurrent+28]=this.dw_calc_cp_list
end on

on w_calc_cp_data.destroy
call super::destroy
destroy(this.dw_cp_charterer)
destroy(this.cb_charterer_delete)
destroy(this.cb_charterer_new)
destroy(this.cb_detach)
destroy(this.cb_select)
destroy(this.cb_calc_cp_refresh)
destroy(this.cb_calc_cp_delete)
destroy(this.cb_new)
destroy(this.dw_profit_c_no_lb)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_office)
destroy(this.dw_calc_cp_data)
destroy(this.cb_wiew_terms)
destroy(this.cb_new_term)
destroy(this.cb_refresh)
destroy(this.dw_calc_std_short_text)
destroy(this.gb_3)
destroy(this.gb_cp_terms)
destroy(this.dw_calc_broker_data)
destroy(this.cb_insert_row)
destroy(this.cb_delete)
destroy(this.gb_brokers)
destroy(this.cb_ok)
destroy(this.gb_charterers)
destroy(this.uo_att)
destroy(this.gb_attachments)
destroy(this.dw_calc_cp_list)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_cp_data
end type

type dw_cp_charterer from u_datagrid within w_calc_cp_data
event ue_refreshdddw ( )
integer x = 2889
integer y = 288
integer width = 1632
integer height = 388
integer taborder = 70
string title = ""
string dataobject = "d_sq_gr_charterer"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event ue_refreshdddw();/********************************************************************
   ue_refreshdddw
   <DESC>	Refresh the drop down datawindow	</DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	25/01/2013 CR2877       WWA048        		 First Version
   	14/05/2015 CR3626       LHG008        		 When type the first letters of an existing charterer, the dropdown list unfolds with the right charterer selected
   </HISTORY>
********************************************************************/

long	ll_found, ll_chart_nr, ll_chart_gp, i, ll_chart_tmp
String	ls_chart_cur, ls_filter

datawindowchild	ldwc_child

this.getchild("chart_nr_1", ldwc_child)

ll_found = this.find("isprimary = 1", 1, this.rowcount())
if ll_found > 0 then
	ll_chart_nr = this.getitemnumber(ll_found, "chart_nr")
	if not isnull(ll_chart_nr) then
		SELECT CCS_CHGP_PK INTO :ll_chart_gp FROM CHART WHERE CHART_NR = :ll_chart_nr;
		
		ls_chart_cur = ""
		ls_filter = ""
		for i=1 to this.rowcount( )
			ll_chart_tmp = this.getitemnumber(i, "chart_nr")
			if this.getitemdecimal(i, "isprimary") =1 or isnull(ll_chart_tmp)  then continue
			ls_chart_cur += String(ll_chart_tmp) + ", "
		next
		
		if len(ls_chart_cur) >3 then ls_chart_cur = left(ls_chart_cur, len(ls_chart_cur) -2 )
		if len(ls_chart_cur) >0 then ls_filter = " or chart_nr in (" + ls_chart_cur + ") "
		
		if not isnull(ll_chart_gp) then
			ls_filter = "ccs_chgp_pk = " + string(ll_chart_gp) + ls_filter
			ldwc_child.setfilter(ls_filter)
			ldwc_child.filter()
			ldwc_child.scrolltorow(ldwc_child.getselectedrow(0))
		end if
	end if
else
	ldwc_child.setfilter("")
	ldwc_child.filter()
	ldwc_child.scrolltorow(ldwc_child.getselectedrow(0))
end if

end event

event clicked;call super::clicked;long	ll_found

if row <=0 then return
choose case dwo.name
	case "chart_nr", "chart_nr_1"
		this.event ue_refreshdddw()
	case "isprimary"
		//Insure primary only one row
		if row > 0 then
			if this.getitemnumber(row, "isprimary") = 0 then
				ll_found = this.find("isprimary = 1", 1, this.rowcount())
				if ll_found > 0 then
					this.setitem(ll_found, "isprimary", 0)
					this.setitem(row, "isprimary", 1)
					this.setrow(row)
					this.event ue_refreshdddw()
				end if
			end if
		end if
end choose


end event

event constructor;call super::constructor;inv_dddw_search_chart_primary = CREATE u_dddw_search
inv_dddw_search_chart_primary.uf_setup(dw_cp_charterer, "chart_nr", "chart_n_1", true)

inv_dddw_search_chart_secondary = CREATE u_dddw_search
inv_dddw_search_chart_secondary.uf_setup(dw_cp_charterer, "chart_nr_1", "chart_n_1", true)

this.modify("chart_nr_1.width = '0~tlong(describe(~"chart_nr.width~"))' chart_nr_1.x = '0~tlong(describe(~"chart_nr.x~"))'")
this.modify("datawindow.processing = '0' chart_nr_1.visible = '1~t1 - isprimary' datawindow.processing = '1'")

end event

event editchanged;call super::editchanged;choose case dwo.name
	case "chart_nr"
		inv_dddw_search_chart_primary.uf_editchanged()
	case "chart_nr_1"
		inv_dddw_search_chart_secondary.uf_editchanged()
end choose

end event

event itemchanged;call super::itemchanged;long		ll_ori_chart, ll_cur_chart, ll_ori_gp, ll_cur_gp, ll_chart_nr
long		ll_found, ll_rows, ll_count, ll_null, ll_return, ll_ret
DataWindowChild ldwc_temp
string	ls_column, ls_temp


if row <= 0 then return

ls_column = dwo.name
choose case ls_column
	case "chart_nr", "chart_nr_1"
		ll_ret = this.getchild( dwo.name, ldwc_temp)  
		if ll_ret >0 then ll_found =ldwc_temp.find( " chart_nr =" + data + " ", 1, ldwc_temp.rowcount( ) )
		if ll_found >0 then 
			if ldwc_temp.getitemnumber(ll_found, "chart_active") <> 1 then
				ls_temp = ldwc_temp.getitemstring(ll_found, "chart_n_1")
				ls_temp = "Selected Charterer is marked as inactive. Please select another Charterer."
				messagebox("Validation", ls_temp)			
				post setcolumn("isprimary")
				post setcolumn(ls_column)
				return 2
			end if
		end if
		//When the Charterer is changing to another chart group charterer, then prompt messagebox
		ll_count = this.rowcount()
		if this.getitemnumber(row, "isprimary") = 1 then
			ll_found = this.find("(not isnull(chart_nr)) and isprimary = 0", 1, ll_count)
			if ll_found > 0 then
				ll_ori_chart = this.getitemnumber(row, "chart_nr")
				ll_cur_chart = long(data)
				
				SELECT CCS_CHGP_PK INTO :ll_ori_gp FROM CHART WHERE CHART_NR = :ll_ori_chart;
				SELECT CCS_CHGP_PK INTO :ll_cur_gp FROM CHART WHERE CHART_NR = :ll_cur_chart;
				
				if ll_ori_gp <> ll_cur_gp then
					ll_return = messagebox("Attempt to change Primary Charterer", "The Charterer Group for the Primary Charterer is changed. All the Non-Primary Charterers from the original Charterer Group will be cleared. Are you sure to change the Primary Charterer?", question!, yesno!, 2)
					if ll_return = 1 then
						setnull(ll_null)
						for ll_rows = 1 to ll_count
							if ll_rows <> row then
								this.post setitem(ll_rows, "chart_nr", ll_null)
							end if
						next
					else
						this.post setitem(row, "chart_nr", ll_ori_chart)
					end if
				end if
			end if
			//Refresh Charterer filter
			this.post event ue_refreshdddw()
		else
			ll_found = this.find("isprimary = 1", 1, ll_count)
			if ll_found <= 0 then this.post setitem(row, "isprimary", 1)
		end if
end choose

end event

event itemerror;call super::itemerror;return 1
end event

event retrieveend;this.event ue_refreshdddw()
this.setredraw(true)

if rowcount =0 then return


end event

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
if currentrow <=0 then return

this.selectrow(currentrow, true)

end event

event destructor;call super::destructor;destroy inv_dddw_search_chart_primary
destroy inv_dddw_search_chart_secondary

end event

event getfocus;call super::getfocus;cb_ok.default = false
cb_wiew_terms.default = false
cb_insert_row.default = false
cb_charterer_new.default = true

end event

type cb_charterer_delete from mt_u_commandbutton within w_calc_cp_data
integer x = 4206
integer y = 720
integer width = 347
integer taborder = 90
string text = "Delete"
end type

event clicked;call super::clicked;long  ll_row, ll_primary

if uo_global.ii_access_level = -1 then 
	messagebox("Information","As an external user you do not have access to this functionality.")
	return
end if

ll_row = dw_cp_charterer.getrow()
if ll_row > 0 then
	if dw_cp_charterer.getitemnumber(ll_row, "isprimary") = 0 then
		dw_cp_charterer.deleterow(ll_row)
		dw_cp_charterer.setfocus()
	else
		messagebox("Validation", "It is not allowed to delete the Primary Charterer.")
	end if
end if

end event

type cb_charterer_new from mt_u_commandbutton within w_calc_cp_data
integer x = 3858
integer y = 720
integer width = 347
integer taborder = 80
string text = "New"
end type

event clicked;call super::clicked;long	ll_row

if uo_global.ii_access_level = -1 then
	messagebox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

ll_row = dw_cp_charterer.insertrow(0)
dw_cp_charterer.setrow(ll_row)
dw_cp_charterer.scrolltorow(ll_row)
dw_cp_charterer.setfocus()

end event

type cb_detach from mt_u_commandbutton within w_calc_cp_data
integer x = 1719
integer y = 2144
integer taborder = 220
string text = "D&etach"
end type

event clicked;call super::clicked;integer li_current_cargo
long ll_null; setnull(ll_null)
integer li_resp

li_resp = messagebox("Remove C/P", "Are you sure you want to detach this C/P from the current calculation?", Question!,YesNo!, 2)

if li_resp = 1 then
	li_current_cargo = iuo_calculation.uf_get_cargo()
	iuo_calculation.uf_set_cerp_id( li_current_cargo, ll_null)
	close(parent)
end if

end event

type cb_select from mt_u_commandbutton within w_calc_cp_data
integer x = 1371
integer y = 2144
integer taborder = 210
string text = "&Select"
end type

event clicked;call super::clicked;long ll_cp_id, ll_row, ll_cargo_cp_id, ll_current_chart_nr, ll_chart_nr
Integer li_current_cargo, li_max, li_count
integer li_afc, li_currentafc, li_revdem, li_currentrevdem
Long ll_cp_pc, ll_vessel_pc, ll_vessel_id, ll_clarkson_id
string ls_pc_name

if uo_global.ii_access_level = -1 then 
	messagebox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

ll_row = dw_calc_cp_list.getselectedrow(0)
if ll_row > 0 then
	ll_cp_id = dw_calc_cp_list.getitemnumber(ll_row,"cal_cerp_cal_cerp_id")
end if

if isvalid(iuo_calculation) then
	// Check if other Cargoes on this calculation is using the same charterer as this cp.
	// We do it by looping through all C/P's, comparing the charterer number with our
	// charterer number. If a match is found (same charterer), display the warning and
	// exit the loop
	li_current_cargo = iuo_calculation.uf_get_cargo()
	li_max = iuo_calculation.uf_get_no_cargos()
	
	// Get the charterer ID for our entry
	SELECT CHART_NR, CAL_CERP_REV_FREIGHT, CAL_CERP_REV_DEM
	INTO :ll_current_chart_nr, :li_currentafc, :li_currentrevdem
	FROM CAL_CERP
	WHERE CAL_CERP_ID = :ll_cp_id;
	COMMIT;
	
	// Loop through cargoes, and compare C/P-charterer with our charterer.
	for li_count = 1 to li_max
		if li_count <> li_current_cargo Then
			ll_cargo_cp_id = iuo_calculation.uf_get_cerp_id(li_count)
			if not isnull(ll_cargo_cp_id) then
				SELECT CHART_NR, CAL_CERP_REV_FREIGHT, CAL_CERP_REV_DEM
				INTO :ll_chart_nr, :li_afc, :li_revdem
				FROM CAL_CERP
				WHERE CAL_CERP_ID = :ll_cargo_cp_id;
				commit;

				if ll_chart_nr = ll_current_chart_nr then
					if (li_afc <> li_currentafc or li_revdem <> li_currentrevdem) then
						messagebox("Warning", "This C/P is using the same charterer as another C/P, that is linked "+ &
						                      "to cargo number "+String(li_count)+" in the calculation.~r~n~r~n" + &
						                      "It must have the same reverse demurrage option and AFC setting as the other C/P existing.  Please amend so these options are the same or select a better suited C/P.", &
						           Exclamation!)
						return
					else
						// This cargo is using the same charterer, display warning.
						messagebox("Warning", "This C/P is using the same charterer as another C/P, that is linked "+ &
						                      "to cargo number "+String(li_count)+" in the calculation.~r~n~r~n" + &
						                      "As result, the freight claim in operations will be calculated as " + &
						                      "NON-AFC for this vessel, voyago, charter and with data from first CP and first cargo.", &
						           Exclamation!);
						// And exit the loop
						exit 	
					end if
				end if
			end if
		end if
	next
   //add validation profit center,CR3519
	
	 ll_cp_pc = dw_calc_cp_data.GetItemNumber(1,'cal_cerp_profit_center_no')
	 ll_vessel_id = iuo_calculation.uo_calc_summary.dw_calc_summary.getItemNumber(1, "cal_calc_vessel_id")
	 if ll_vessel_id > 0 then
		
	    Select PC_NR
       INTO :ll_vessel_pc
       FROM VESSELS
       WHERE VESSEL_NR = :ll_vessel_id;
		 
	 else
		
		 ll_clarkson_id = iuo_calculation.uo_calc_summary.dw_calc_summary.getItemNumber(1, "cal_clrk_id")
		 SELECT PC_NR
       INTO :ll_vessel_pc
       FROM CAL_CLAR
       WHERE CAL_CLRK_ID = :ll_clarkson_id;
		 
    end if
	 
	 if ll_vessel_pc <> ll_cp_pc then
		 SELECT PC_NAME
		 INTO :ls_pc_name
		 FROM PROFIT_C
		 WHERE PC_NR = :ll_vessel_pc;
		 Messagebox("Validation","The C/P's profit center must be the same as the vessel's profit center: "+ls_pc_name+".")
		 return
	 end if
	 
	//end validation
	iuo_calculation.uf_set_cerp_id(0,ll_cp_id)
	close(parent)
else
	messagebox("Error","Could not pass C/P to the calculation" )	
end if

end event

type cb_calc_cp_refresh from mt_u_commandbutton within w_calc_cp_data
integer x = 4224
integer y = 2144
integer taborder = 200
string text = "&Cancel"
end type

event clicked;call super::clicked;long	ll_row

datawindowchild ldwc_child

dw_cp_charterer.getchild("chart_nr_1", ldwc_child)
ldwc_child.setfilter("")
ldwc_child.filter()

ll_row = dw_calc_cp_list.getrow()
if ll_row > 0 then
	if il_cpno = 0 then
		il_cpno = dw_calc_cp_list.getitemnumber(ll_row, "cal_cerp_cal_cerp_id")
	end if
	parent.triggerevent("ue_retrieve")
else
	dw_calc_broker_data.reset()
	dw_cp_charterer.reset()
	dw_calc_cp_data.reset()
	uo_att.dw_file_listing.reset()
end if

wf_enabled_button(is_INITIAL)

end event

type cb_calc_cp_delete from mt_u_commandbutton within w_calc_cp_data
integer x = 3877
integer y = 2144
integer taborder = 190
string text = "&Delete"
end type

event clicked;call super::clicked;Integer li_test
long    ll_rownum, ll_nullvar, ll_row, ll_calc_count, ll_calc_count1, ll_ret
long    ll_cerp_id, ll_cargid1, ll_tmp, ll_temp, ll_calc_id

if uo_global.ii_access_level = -1 then 
	messagebox("Infomation", "As an external user you do not have access to this functionality.")
	return
end if

// Find the CP - no
ll_rownum = dw_calc_cp_list.getselectedrow(0)
if ll_rownum <= 0 then return

ll_cerp_id = dw_calc_cp_list.getitemnumber(ll_rownum, "cal_cerp_cal_cerp_id")

SELECT count(*) INTO :ll_calc_count1 
FROM (SELECT CAL_CALC_ID  
FROM CAL_CARG  
WHERE CAL_CERP_ID =  :ll_cerp_id  
GROUP BY CAL_CALC_ID) A;

if ll_calc_count1 > 1  then
	messagebox("Validation", "This C/P can not be deleted. It's being used by more than one calculation!")
	return
end if

SELECT count(*) INTO :ll_calc_count 
FROM (SELECT CAL_CALC_ID  
FROM CAL_CARG  
WHERE CAL_CERP_ID =  :ll_cerp_id AND CAL_CARG_STATUS > 3 
GROUP BY CAL_CALC_ID) A	;
	
if ll_calc_count > 0  then
	messagebox("Validation", "This C/P can not be deleted since the calculation attached to this C/P is fixtured.")
	return
end if

li_test = messagebox("Warning", "This will delete the selected C/P.~r~nDo you want to continue?", information!, YESNO!, 2)
if li_test = 2 then return
	
// Delete Starting-- Delete related broker 
dw_calc_broker_data.rowsmove(1, dw_calc_broker_data.rowcount(), Primary!, dw_calc_broker_data, 1, Delete!)	
ll_ret = dw_calc_broker_data.update()		
if ll_ret <> 1 then 
	wf_rollback("C/P remove operation did not complete, the related broker information deletion failed! ")
	return
end if

// Delete related charter
dw_cp_charterer.rowsmove(1, dw_cp_charterer.rowcount(), Primary!, dw_cp_charterer, 1, Delete!)	
ll_ret = dw_cp_charterer.update()		
if ll_ret <> 1 then 
	wf_rollback("CP remove operation did not complete, the related charterer information deletion failed! ")
	return
end if

// Delete the CP from cal_cerp_att table
if not wf_deletefiles() then
	wf_rollback("CP remove operation did not complete, the related attachment information  deletion failed! ")
	return
end if

// Update in the cargo table (over write the CP no with Null)
setnull(ll_nullvar)
UPDATE CAL_CARG SET CAL_CERP_ID = :ll_nullvar WHERE CAL_CERP_ID = :ll_cerp_id;
if sqlca.sqlcode < 0 then
	wf_rollback("Update related cargo information failure! ")
	return
end if

ll_row = dw_calc_cp_data.getrow()
if ll_row > 0 then dw_calc_cp_data.deleterow(ll_row)
ll_ret = dw_calc_cp_data.update()
if ll_ret <> 1 then 
	wf_rollback("C/P remove operation failure! ")
	return
end if
		

commit using sqlca;
				
dw_calc_cp_list.retrieve(dw_profit_c_no_lb.getitemnumber(1, "pc_nr"))
openwithparm(w_updated, 0)

parent.triggerevent("ue_retrieve")

end event

type cb_new from mt_u_commandbutton within w_calc_cp_data
integer x = 3182
integer y = 2144
integer taborder = 170
string text = "&New"
end type

event clicked;call super::clicked;if uo_global.ii_access_level = -1 then 
	messagebox("Infomation", "As an external user you do not have access to this functionality.")
	return
end if

wf_enabled_button(is_NEW)

il_cpno = 0

parent.triggerevent("ue_retrieve")

end event

type dw_profit_c_no_lb from u_datawindow_sqlca within w_calc_cp_data
integer x = 37
integer y = 96
integer width = 1061
integer height = 64
integer taborder = 10
string dataobject = "d_sq_ff_calc_profit_c_no_lb"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;integer li_profit_center

dw_profit_c_no_lb.accepttext()
li_profit_center = dw_profit_c_no_lb.getitemnumber(1,"pc_nr")
dw_calc_cp_list.retrieve(li_profit_center)

end event

type st_2 from uo_st_base within w_calc_cp_data
integer x = 37
integer y = 32
integer width = 430
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center:"
alignment alignment = left!
end type

type st_1 from u_topbar_background within w_calc_cp_data
integer width = 6999
end type

type cb_office from commandbutton within w_calc_cp_data
integer x = 3314
integer y = 988
integer width = 69
integer height = 76
integer taborder = 110
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "?"
end type

event clicked;string ls_office_sn
ls_office_sn = f_select_from_list("dw_office_active_list",2,"Shortname",3,"Fullname",2,"Select office",false)
IF NOT IsNull(ls_office_sn) THEN
	dw_calc_cp_data.SetColumn("offices_office_sn")
	dw_calc_cp_data.SetText(ls_office_sn)
	dw_calc_cp_data.AcceptText()
	dw_calc_cp_data.SetFocus()
END IF
end event

type dw_calc_cp_data from u_datawindow_sqlca within w_calc_cp_data
integer x = 1413
integer y = 916
integer width = 1984
integer height = 624
integer taborder = 100
string dataobject = "d_calc_cp_data"
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_newstandard = true
boolean ib_usectrl0 = true
boolean ib_editmaskselect = true
end type

event constructor;call super::constructor;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Create search as you type on the dddw for charterer and city 
				  on the datawindow


*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-9-96	1.0		TA		Initial version
1-12-96	2.0		MI		Search as you type
****************************************************************************/
DataWindowChild dwc_tmp

iuo_dddw_search_charterer = CREATE u_dddw_search
iuo_dddw_search_charterer.uf_setup(dw_calc_cp_data, "chart_nr", "chart_n_1", True)
iuo_dddw_search_city = CREATE u_dddw_search
iuo_dddw_search_city.uf_setup(dw_calc_cp_data, "cal_cerp_city", "port_n", True)

dw_calc_cp_data.GetChild("cal_cerp_city", dwc_tmp)

end event

event getfocus;call super::getfocus;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Set up the controlls on the window

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/

cb_wiew_terms.default = false
cb_insert_row.default = false
cb_charterer_new.default = false

end event

event destructor;call super::destructor;/****************************************************************************
Author		: Martin Isralsen
Date			: 1-12-96
Description	: Destroy search as you type function

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-12-96	1.0		MI		Initial version
****************************************************************************/
DESTROY iuo_dddw_search_charterer
DESTROY iuo_dddw_search_city
destroy iw_fileattachment
end event

event itemchanged;call super::itemchanged;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Reegister a changed character in the search as you type dddws

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
String ls_sn
Integer li_nr, li_null;setNull(li_null)

iuo_dddw_search_charterer.uf_itemchanged()
iuo_dddw_search_city.uf_itemchanged()

AcceptText()
CHOOSE CASE dwo.name
	CASE "offices_office_sn"
		ls_sn = dw_calc_cp_data.GetItemString(1,"offices_office_sn")
		IF IsNull(ls_sn) THEN
			SetNull(li_nr)
			dw_calc_cp_data.SetItem(1,"cal_cerp_cal_cerp_office_nr",li_nr)
		ELSE
			SELECT OFFICE_NR INTO :li_nr FROM OFFICES WHERE OFFICE_SN = :ls_sn USING SQLCA;
			COMMIT USING SQLCA;
			dw_calc_cp_data.SetItem(1,"cal_cerp_cal_cerp_office_nr",li_nr)
		END IF
	CASE "chart_nr"
		if f_chart_active( long(data)) = false then 
			MessageBox("Validation Error", "Selected Charterer is marked as inactive. Please select another Charterer")
			if this.getItemNumber(row, "chart_nr", primary!, true) <>  this.getItemNumber(row, "chart_nr", primary!, false) then
				this.setItem(row, "chart_nr", this.getItemNumber(row, "chart_nr", primary!, true) )
			else
				this.setItem(row, "chart_nr", li_null)
			end if
			setColumn("chart_nr")
			return 2
		end if
	CASE 'cal_cerp_speed' 
		if  dec(data) < 0 then
			this.setitem( row, string(dwo.name),abs(dec(data))) 
			return 2
		end if
END CHOOSE

end event

event editchanged;call super::editchanged;/****************************************************************************
Author		: Martin Isralsen
Date			: 1-12-96
Description	: Register that a character has been changed on the dddw with search
				  as you type function

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
1-12-96	1.0		MI		Initial version
25-9-17                EPE080  add convert negative number to positive number on cal_cerp_speed
****************************************************************************/
iuo_dddw_search_charterer.uf_editchanged()
iuo_dddw_search_city.uf_editchanged()


end event

event itemerror;call super::itemerror;return 1
end event

type cb_wiew_terms from uo_cb_base within w_calc_cp_data
integer x = 3867
integer y = 1472
integer width = 343
integer height = 100
integer taborder = 140
string pointer = "Help!"
string text = "&View"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_std_terms
  
 Object     :cb_wiew_terms
  
 ************************************************************************************

 Author    : Teit Aunt
   
 Date       :29-7-96

 Description : Opens the selected standard terms

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-7-96		1.0			TA		Initial version
31-7-96		1.1			TA		Run on lookup data window
  
************************************************************************************/
// Variables
Integer li_TermsNo
long ll_CurRow

ll_CurRow = dw_calc_std_short_text.GetRow()
If ll_CurRow > 0 Then
	li_TermsNo = dw_calc_std_short_text.GetItemNumber( ll_CurRow,"cal_ster_id")
End If

// Opens the selected term
OpenWithParm(w_calc_std_terms , li_TermsNo)

end event

type cb_new_term from uo_cb_base within w_calc_cp_data
integer x = 4215
integer y = 1472
integer width = 343
integer height = 100
integer taborder = 150
string pointer = "Help!"
string text = "Ne&w"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_std_terms
  
 Object     :cb_new_term
  
 ************************************************************************************

 Author    : Teit Aunt
   
 Date       :29-7-96

 Description : Opens the w_calc_std_terms window with an empty row

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
29-7-96		1.0			TA		Initial version
  
************************************************************************************/
// Opens an empty term row in the w_calc_std_terms window 

long ll_TermNo = 0

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

OpenWithParm(w_calc_std_terms,ll_TermNo )
end event

type cb_refresh from uo_cb_base within w_calc_cp_data
integer x = 3520
integer y = 1472
integer width = 343
integer height = 100
integer taborder = 130
string pointer = "Help!"
string text = "&Refresh"
end type

event clicked;call super::clicked;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Retrieve data into the terms list window

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
// Variables
long ll_rows

dw_calc_std_short_text.Retrieve()
COMMIT;

ll_rows = dw_calc_std_short_text.RowCount()
dw_calc_std_short_text.SelectRow(0,False)
dw_calc_std_short_text.SelectRow(ll_rows,True)
dw_calc_std_short_text.SetRow(ll_rows)
dw_calc_std_short_text.ScrollToRow(ll_rows)
end event

type dw_calc_std_short_text from u_datawindow_sqlca within w_calc_cp_data
integer x = 3497
integer y = 916
integer width = 1024
integer height = 512
integer taborder = 120
string dataobject = "d_calc_std_short_text"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event doubleclicked;call super::doubleclicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_calc_cp_data
  
 Object     : dw_calc_terms_short_text
  
 ************************************************************************************

 Author    :Teit Aunt 
   
 Date       : 1-8-96

 Description : Add the standard term to the C/P term 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
---------------------------------------------------------
1-8-96		1.0 			TA		Initial version
************************************************************************************/
// Variables

long ll_rowNum, ll_cpRowNum
string ls_stdText, ls_terms

// Only if the calculation status is working or below
If ib_Status = False Then
	dw_calc_cp_data.AcceptText()

	ll_rowNum = dw_calc_std_short_text.GetSelectedRow(0)
	ls_stdText = dw_calc_std_short_text.GetItemString(ll_rowNum,"cal_ster_text")

	ll_cpRowNum = dw_calc_cp_data.GetRow()
	ls_terms = dw_calc_cp_data.GetItemString(ll_cpRowNum,"cal_cerp_term")
	
	// Add the strings together 
	If Not IsNull(ls_terms) Then
		ls_terms = ls_terms + ls_stdText
	Else
		ls_terms = ls_stdText
	End If

	// Insert into data window 
	dw_calc_cp_data.SetItem(ll_cpRowNum,"cal_cerp_term",ls_terms)
End If
	
end event

event getfocus;call super::getfocus;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Set the controlls on the datawindow

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
ib_auto = true
cb_ok.default = false
cb_insert_row.default = false
cb_charterer_new.default = false
cb_wiew_terms.default = true
dw_calc_std_short_text.selectrow(1, true)
dw_calc_std_short_text.setrow(1)

end event

event losefocus;call super::losefocus;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Remove selection from the datawindow

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
SelectRow(0,FALSE)
end event

type gb_3 from uo_gb_base within w_calc_cp_data
integer x = 3461
integer y = 852
integer width = 1097
integer height = 604
integer taborder = 0
long backcolor = 67108864
string text = "Standard Terms"
end type

type gb_cp_terms from uo_gb_base within w_calc_cp_data
integer x = 1376
integer y = 852
integer width = 2053
integer height = 720
integer taborder = 0
long backcolor = 67108864
string text = "C/P Terms"
end type

type dw_calc_broker_data from u_datawindow_sqlca within w_calc_cp_data
integer x = 1413
integer y = 288
integer width = 1367
integer height = 388
integer taborder = 30
string title = ""
string dataobject = "d_calc_broker"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event getfocus;call super::getfocus;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: 

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/

ib_auto = true
cb_ok.default = false
cb_wiew_terms.default = false
cb_charterer_new.default = false
cb_insert_row.default = true


end event

event losefocus;call super::losefocus;selectrow(0, false)
end event

event itemchanged;call super::itemchanged;
iuo_dddw_search_broker.uf_Itemchanged()

choose case dwo.name
	CASE "cal_comm_broker_nr"
		if f_broker_active( long(data)) = false then 
			messagebox("Validation ", "Selected Broker is marked as inactive. Please select another Broker. ")
			post setcolumn("cal_comm_cal_comm_percent")
			post setcolumn("cal_comm_broker_nr")
			return 2
		end if
end choose
end event

event constructor;call super::constructor;/****************************************************************************
Author		: Martin Isralsen
Date			: December 1996
Description	: Gives the Broker dddw a search as you type function

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			MI 	Initial version
****************************************************************************/
iuo_dddw_search_broker = CREATE u_dddw_search
iuo_dddw_search_broker.uf_setup(dw_calc_broker_data, "cal_comm_broker_nr", "broker_name", True)

end event

event destructor;call super::destructor;/****************************************************************************
Author		: Martin Isralsen
Date			: December 1996
Description	: Destroy search as you type userobject

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			MI		Initial version
****************************************************************************/
DESTROY iuo_dddw_search_broker
end event

event editchanged;call super::editchanged;/****************************************************************************
Author		: Martin Isralsen
Date			: December 1996
Description	: Signal search as you type function that a new charcter has been 
				  entered.

Arguments	: 
Returns		: 
*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			MI		Initial version
****************************************************************************/
iuo_dddw_search_broker.uf_editchanged()
end event

event clicked;if row <= 0 then return 1

end event

event itemerror;call super::itemerror;return 1
end event

type cb_insert_row from uo_cb_base within w_calc_cp_data
integer x = 2121
integer y = 720
integer width = 347
integer height = 100
integer taborder = 40
string text = "New"
end type

event clicked;call super::clicked;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Insert a new row into the broker datawindow

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
// Variables
long ll_row_no

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

dw_calc_broker_data.InsertRow(0)

ll_row_no = dw_calc_broker_data.RowCount()
dw_calc_broker_data.ScrollToRow(ll_row_no)
dw_calc_broker_data.SetRow(ll_row_no)
end event

type cb_delete from uo_cb_base within w_calc_cp_data
integer x = 2469
integer y = 720
integer width = 347
integer height = 100
integer taborder = 50
string text = "Delete"
end type

event clicked;call super::clicked;/****************************************************************************
Author		: Teit Aunt
Date			: September 1996
Description	: Deletes a row from broker data window

*****************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-----------------------------------------------------------------------------
		1.0			TA		Initial version
****************************************************************************/
// Variables
long  ll_RowNum

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_RowNum = dw_calc_broker_data.GetRow()
dw_calc_broker_data.DeleteRow(ll_RowNum)
end event

type gb_brokers from uo_gb_base within w_calc_cp_data
integer x = 1376
integer y = 224
integer width = 1440
integer height = 484
integer taborder = 0
long backcolor = 67108864
string text = "C/P Brokers"
end type

type cb_ok from uo_cb_base within w_calc_cp_data
integer x = 3529
integer y = 2144
integer width = 343
integer height = 100
integer taborder = 180
string text = "&Update"
end type

event clicked;integer                      li_modified, li_return
u_modify_cp	                 lnv_modifycp
w_atobviac_calc_calculation  lw_opencalcs[]
string                       ls_error_string, ls_cp_date
long                         ll_rc, ll_openindex, ll_row, ll_chart_nr, ll_chart_nr_cp
long                         ll_cerp_id, ll_found, ll_modify, ll_profit_center

dw_calc_broker_data.acceptText()
dw_cp_charterer.accepttext()
dw_calc_cp_data.acceptText()

if dw_calc_cp_data.rowcount() <= 0 then return c#return.Failure

//if primary charterer is changed or new then write to datawindow dw_calc_cp_data

if wf_validation_charterer() = c#return.Failure then return c#return.Failure


ll_modify = dw_calc_broker_data.modifiedcount() + dw_calc_broker_data.deletedcount() + &
            dw_calc_cp_data.modifiedcount() + dw_calc_cp_data.deletedcount() + &
				dw_cp_charterer.modifiedcount() + dw_cp_charterer.deletedcount()
if ll_modify > 0 then
	
	if wf_validate() = c#return.Failure then return c#return.Failure
	
	lnv_modifycp = create u_modify_cp
	li_modified = lnv_modifycp.of_updatecp(dw_calc_broker_data, dw_cp_charterer, dw_calc_cp_data, il_cpno, "")
	destroy lnv_modifycp
	if li_modified = c#return.Success then
		uo_att.of_setlongarg(il_cpno)
	else
		cb_ok.enabled = true
		return c#return.Failure
	end if
end if

if ib_new then
	wf_enabled_button(is_UPDATE)
else
	wf_enabled_button(is_INITIAL)
end if

ll_profit_center = dw_calc_cp_data.getitemnumber(1, "cal_cerp_profit_center_no")
dw_profit_c_no_lb.setitem(1, "pc_nr", ll_profit_center)

ll_cerp_id = dw_calc_cp_data.getitemnumber(1, "cal_cerp_id")

parent.setredraw(false)
dw_calc_cp_list.retrieve(ll_profit_center)
ll_found = dw_calc_cp_list.find("cal_cerp_cal_cerp_id = " + string(ll_cerp_id), 1, dw_calc_cp_list.rowcount())
if ll_found > 0 then
	dw_calc_cp_list.scrolltorow(ll_found)
	dw_calc_cp_list.setrow(ll_found)
end if
parent.setredraw(true)

return c#return.Success

end event

type gb_charterers from uo_gb_base within w_calc_cp_data
integer x = 2853
integer y = 224
integer width = 1705
integer height = 484
integer taborder = 0
long backcolor = 67108864
string text = "C/P Charterers"
end type

type uo_att from u_fileattach within w_calc_cp_data
integer x = 1413
integer y = 1664
integer width = 3113
integer height = 424
integer taborder = 160
boolean bringtotop = true
string is_dataobjectname = "d_sq_tb_cal_cerp_files"
string is_counterlabel = "Attachments:"
boolean ib_allow_dragdrop = true
boolean ib_enable_cancel_button = false
boolean ib_autosave = true
end type

on uo_att.destroy
call u_fileattach::destroy
end on

type gb_attachments from groupbox within w_calc_cp_data
integer x = 1376
integer y = 1604
integer width = 3186
integer height = 508
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
string text = "Attachments"
end type

type dw_calc_cp_list from u_datagrid within w_calc_cp_data
integer x = 37
integer y = 240
integer width = 1307
integer height = 1988
integer taborder = 20
string dataobject = "d_calc_cp_list"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

event doubleclicked;call super::doubleclicked;If not cb_select.enabled then return

if row > 0 then
	if isvalid(iuo_calculation) then
		cb_select.triggerevent(clicked!)
	end if
end if

end event

event rowfocuschanged;call super::rowfocuschanged;datawindowchild	ldwc_child

if currentrow < 1 then return

this.selectrow(0, false)
this.selectrow(currentrow, true)

il_cpno = this.getitemnumber(currentrow, "cal_cerp_cal_cerp_id")
parent.triggerevent("ue_retrieve")

wf_enabled_button(is_INITIAL)

end event

event rowfocuschanging;call super::rowfocuschanging;long ll_modified, ll_return

dw_calc_broker_data.accepttext()
dw_cp_charterer.accepttext()
dw_calc_cp_data.accepttext()

ll_modified = dw_calc_broker_data.modifiedcount() + dw_calc_broker_data.deletedcount() + &
              dw_cp_charterer.modifiedcount() + dw_cp_charterer.deletedcount() + &
				  dw_calc_cp_data.modifiedcount() + dw_calc_cp_data.deletedcount()

if ll_modified > 0 then
	ll_return = messagebox("Save C/P data", "C/P data has been changed, but not saved. Would you like to save data?", question!, yesno!)
	if ll_return = 1 then
		if cb_ok.event clicked() = c#return.Success then
			return 0
		else
			return 1
		end if
	else
		wf_enabled_button(is_CANCEL)
		return 0
	end if
end if

return 0

end event

event retrieveend;call super::retrieveend;if rowcount > 0 then
	this.event rowfocuschanged(1)
else
	dw_calc_broker_data.reset()
	dw_cp_charterer.reset()
	dw_calc_cp_data.reset()
	uo_att.dw_file_listing.reset()
	wf_enabled_button(is_INITIAL)
end if

end event

event clicked;call super::clicked;long	ll_row

if isvalid(dwo) then
	if row <= 0 then
		if dwo.type = "text" then
			ll_row = this.getselectedrow(0)
			if ll_row > 0 then
				this.scrolltorow(ll_row)
				this.setrow(ll_row)
			end if
		end if
	
	end if
end if

end event

