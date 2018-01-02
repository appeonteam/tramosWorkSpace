$PBExportHeader$w_actions_transactions.srw
$PBExportComments$Displays Actions and Transactions for one Claim
forward
global type w_actions_transactions from w_vessel_basewindow
end type
type dw_list_claims from u_datagrid within w_actions_transactions
end type
type dw_claim_transaction from u_datagrid within w_actions_transactions
end type
type dw_transaction_action_header from uo_datawindow within w_actions_transactions
end type
type cb_new_transaction from commandbutton within w_actions_transactions
end type
type cb_update_transaction from commandbutton within w_actions_transactions
end type
type cb_delete_transaction from commandbutton within w_actions_transactions
end type
type cb_cancel_transaction from commandbutton within w_actions_transactions
end type
type dw_transaction_action_comment from uo_datawindow within w_actions_transactions
end type
type sle_1 from mt_u_singlelineedit within w_actions_transactions
end type
type cb_new_action from commandbutton within w_actions_transactions
end type
type cb_update_action from commandbutton within w_actions_transactions
end type
type cb_cancel_action from commandbutton within w_actions_transactions
end type
type cb_delete_action from commandbutton within w_actions_transactions
end type
type uo_att_actions from u_fileattach within w_actions_transactions
end type
type uo_balance from u_claimbalance within w_actions_transactions
end type
type dw_freight_received from u_datagrid within w_actions_transactions
end type
type uo_frt_balance from uo_freight_balance within w_actions_transactions
end type
end forward

global type w_actions_transactions from w_vessel_basewindow
integer width = 4608
integer height = 2556
string title = "Actions / Transactions"
boolean maxbox = false
boolean resizable = false
long backcolor = 32304364
string icon = "images\transaction.ico"
event ue_refresh pbm_custom15
event ue_reload ( s_vessel_voyage_chart_claim astr_newdata )
dw_list_claims dw_list_claims
dw_claim_transaction dw_claim_transaction
dw_transaction_action_header dw_transaction_action_header
cb_new_transaction cb_new_transaction
cb_update_transaction cb_update_transaction
cb_delete_transaction cb_delete_transaction
cb_cancel_transaction cb_cancel_transaction
dw_transaction_action_comment dw_transaction_action_comment
sle_1 sle_1
cb_new_action cb_new_action
cb_update_action cb_update_action
cb_cancel_action cb_cancel_action
cb_delete_action cb_delete_action
uo_att_actions uo_att_actions
uo_balance uo_balance
dw_freight_received dw_freight_received
uo_frt_balance uo_frt_balance
end type
global w_actions_transactions w_actions_transactions

type variables
integer ii_chart_nr, ii_pcn, ii_claim_nr, ii_selectedvessel
string is_voyage_nr, is_port_code
boolean	ib_transreadonly, ib_setcurrentvessel, ib_retrievedetail = true
long	il_selectedrow

private boolean _ib_updatefailure

CONSTANT string is_FREIGHT = 'FRT'
CONSTANT string is_WRITE_OFF = 'W'
CONSTANT string is_ADJUSTMENTS = 'A'

constant string COLUMN_FREIGHT_RECEIVE_LOCAL_CURR = "freight_received_local_curr"
constant string COLUMN_TRANS_CODE = "trans_code"
constant string COLUMN_EXCHANGE_RATE = "exchange_rate"
constant string COLUMN_C_TRANS_AMOUNT = "c_trans_amount"
constant string COLUMN_C_TRANS_AMOUNT_USD = "c_trans_amount_usd"
constant string COLUMN_C_TRANS_CODE = "c_trans_code"
constant string TRANS_CODE_R = 'R'

constant string COLUMN_VESSEL_NR = "vessel_nr"
constant string COLUMN_VOYAGE_NR = "voyage_nr"
constant string COLUMN_CHART_NR = "chart_nr"
constant string COLUMN_CLAIM_TYPE = "claim_type"
constant string COLUMN_CERP_ID = "cal_cerp_id"
constant string COLUMN_CURR_CODE = "curr_code"
constant string COLUMN_FREIGHT_RECEIVED = "freight_received"

end variables

forward prototypes
public function integer wf_updatedatawindow ()
public subroutine documentation ()
private subroutine _set_permissions ()
private function integer _data_modified ()
public function integer wf_getkeydata (ref s_vessel_voyage_chart_claim astr_currentdata)
public function boolean wf_allow_linkcalculation ()
public function integer wf_setmandatorycolor (u_datagrid adw_gridwindow, string as_colname)
public function integer wf_settranscomments (long al_row, string as_claimtype)
public function integer wf_validatetransactions (long al_row)
public subroutine wf_set_claim_email ()
public function boolean wf_validateexchangerate ()
end prototypes

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
	using wf_getkeydata().  Manipulate according to implementation and then reload actions/transactions window
	if required.
</USAGE>
********************************************************************/
if astr_newdata.status = "VESSEL" or astr_newdata.status = "RELOAD" then
	this.dw_list_claims.setredraw(false)
	
	if _data_modified() =c#return.failure then
		_ib_updatefailure = true
		return
	else
		_ib_updatefailure = false
	end if
	
	this.triggerevent("ue_retrieve")
	this.dw_list_claims.event Clicked(0, 0, astr_newdata.claim_nr, this.dw_list_claims.object)
	this.dw_list_claims.scrolltorow(astr_newdata.claim_nr)
	this.dw_list_claims.setredraw(true)
end if
end event

public function integer wf_updatedatawindow ();string ls_claim_type
uo_auto_commission uo_auto_comm
double ldo_cp_id_comm



IF dw_transaction_action_header.GetItemStatus(1,0,PRIMARY!) = DataModified!  OR  dw_transaction_action_header.GetItemStatus(1,0,PRIMARY!) = NewModified! THEN
	wf_set_claim_email()
	IF dw_transaction_action_header.Update() = 1 THEN
		COMMIT;
		ls_claim_type = dw_transaction_action_header.GetItemString(1,"claims_claim_type")
		If ls_claim_type = "DEM" Then
			If uo_auto_comm.of_check_exist(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) Then
				uo_auto_comm.of_generate(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr, ls_claim_type, "OLD",ldo_cp_id_comm)
			Else
				uo_auto_comm.of_generate(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr, ls_claim_type, "NEW",ldo_cp_id_comm)
			End if
		End if		
	ELSE	
		ROLLBACK;
	END IF
END IF

return 1

end function

public subroutine documentation ();
/********************************************************************
   ObjectName: w_actions_transactions
	
   <OBJECT> Action/Transaction detail </OBJECT>
   <DESC> Window primarily used by Demurrage to log detail on transactions and actions to
	be completed</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   u_fileattach, w_vessel_basewindow</ALSO>
    Date   Ref    Author        Comments
  15/12/10 ????      AGL     Added documentation
  15/12/10 2215      AGL     Change actions list to include optional file attachments.  Possible to drag and drop
  items from outlook and explorer.
  16/12/10	2215	JMC	Code review and clean up
  10/01/11  2251  AGL   Fixed small bug issue with saving changes, not keeping the same claim id.
  11/01/11	2251	JMC	Users should be able to register transactions for all types of claims
  23/02/11   1549   JSU   Transactions amount_usd is calculated based on claims' currency code and the exrate for
  								the data entered. Also the claim amount in USD need to be recalculated everytime we update 
								the transactions.
  25/08/11	2567	AGL		Fixed decimal issue on transaction amount.
  30/10/12	2949	LGX001 	"show in VAS" that should only be shown on DEM claims
									and only be editable when DEM claim has negative balance (only accessible for Demurrage user or supperuser or administraistor).
  31/10/12	2912	LHC010	Added new function wf_getkeydata() & event ue_reload() to assist C/P update
  									when claim window is still open.
  									Add function wf_allow_linkcalcuation,if data has been modified but the update failed 
  									or did not pass the validation the calculation window will not open.
  21/11/12	2984	RJH022	Add three fields, and if the check box is ticked then according date field must be mandatory.
  24/07/12  3270  ZSW001   Change the style of status from drop down list box to drop down datawindow.
  26/05/14  3563  LHG008   Fixed update issue when jump to another claim in the list.
  10/06/14  3348  LHG008   Make the Codes R, W, A, B selectable for all the claim types in the Transaction table.
  11/06/14  3701  LHG008   User must only be able to create transactions and display who creates the transaction.
  18/06/14  3544  LHG008   Show all fields in the dw_transaction_action_header for all claims as for DEM claims(except "Show in VAS").
  23/06/14  3536  KSH092   the broker email address is update when action/transactions changed
  15/09/14  3810  LHG008   In the "Comments" of the Transaction table, user should be able to 
                           select an adjustment reason type and sub-type.
  18/09/15	CR3778	CCY018	Uses the last exchange rate to calculate USD amount.
  29/07/16  CR4307 SSX14      Use the Set Ex Rate in the calculation.
********************************************************************/

end subroutine

private subroutine _set_permissions ();
/********************************************************************
 _set_permissions 
   <DESC>	set permissions </DESC> 
   <RETURN> </RETURN>
   <ACCESS> Private	</ACCESS>
   <ARGS>	</ARGS>
   <USAGE>Set readonly permissions to external APM </USAGE>
********************************************************************/
integer li_access
integer li_vessel_nr
string  ls_voyage_nr
integer li_chart_nr
string  ls_claim_type
long    ll_cerp_id
string  ls_curr_code
long    ll_row
decimal ld_setexrate
n_claimcurrencyadjust lnv_claimcurrencyadjust
string  ls_modify
string  ls_expr_exrate_protected
string  ls_expr_rec_exrate_changeable
string  ls_expr_tr_exrate_changeable

string  ls_expr_exrate_background
string  ls_expr_rec_exrate_background
string  ls_expr_tr_exrate_background

ib_transreadonly = false

ls_expr_exrate_protected = COLUMN_EXCHANGE_RATE + ".protect=1"
ls_expr_rec_exrate_changeable = COLUMN_EXCHANGE_RATE + ".protect=~"0~tif(" + COLUMN_TRANS_CODE + "='" + TRANS_CODE_R + "', 0, 1)~""
ls_expr_tr_exrate_changeable = COLUMN_EXCHANGE_RATE + ".protect=~"0~tif(" + COLUMN_C_TRANS_CODE + "='" + TRANS_CODE_R + "', 0, 1)~""

ls_expr_exrate_background = COLUMN_EXCHANGE_RATE + ".background.color=" + string(c#color.White)
ls_expr_rec_exrate_background = COLUMN_EXCHANGE_RATE + ".background.color=~"" + string(c#color.White) + "~tif(" + COLUMN_TRANS_CODE + "='" + TRANS_CODE_R + "', " + string(c#color.MT_MAERSK) + ", " + string(c#color.White) + ")~""
ls_expr_tr_exrate_background = COLUMN_EXCHANGE_RATE + ".background.color=~"" + string(c#color.White) + "~tif(" + COLUMN_C_TRANS_CODE + "='" + TRANS_CODE_R + "', " + string(c#color.MT_MAERSK) + ", " + string(c#color.White) + ")~""

if uo_global.ii_access_level = -1 then
	
	//datawindows Object.Datawindow.ReadOnly="Yes"
	dw_transaction_action_header.Object.Datawindow.ReadOnly="Yes"
	dw_freight_received.object.datawindow.readonly="yes"
	dw_claim_transaction.Object.Datawindow.ReadOnly="Yes"
	dw_transaction_action_comment.Object.Datawindow.ReadOnly="Yes"
	uo_att_actions.of_setaccesslevel( uo_global.ii_access_level)
	
	//buttons Visible=false
	cb_new_transaction.visible = false
	cb_update_transaction.visible = false
	cb_cancel_transaction.visible = false
	
	cb_new_action.visible = false
	cb_update_action.visible = false
	cb_delete_action.visible = false
	cb_cancel_action.visible = false
	
	ib_transreadonly = true
	
	dw_freight_received.modify ( ls_expr_exrate_protected )
	dw_claim_transaction.modify( ls_expr_exrate_protected )
	dw_freight_received.modify ( ls_expr_exrate_background )
	dw_claim_transaction.modify( ls_expr_exrate_background )
else
	// This function is used to protect entering of demurrage if user is not
	// authorized. If authorized the system will function as always.
	// Created by: FR 30-08-02

	SELECT USERS.ENTER_FRT_REC  
  	INTO :li_access  
 	FROM USERS  
  	WHERE USERS.USERID = :uo_global.is_userid;
  	COMMIT USING SQLCA;
	
	if (li_access = 0) then
		dw_freight_received.enabled = false
		dw_claim_transaction.enabled = false
		cb_new_transaction.enabled = false
		cb_update_transaction.enabled = false
		cb_cancel_transaction.enabled = false
		ib_transreadonly = true
		
		dw_freight_received.modify ( ls_expr_exrate_protected )
		dw_claim_transaction.modify( ls_expr_exrate_protected )
		dw_freight_received.modify ( ls_expr_exrate_background )
		dw_claim_transaction.modify( ls_expr_exrate_background )
	else
		
		if uo_global.ii_user_profile = c#profile.FINANCE then
			
			ll_row = dw_list_claims.getrow()
			if ll_row <= 0 then return
			
			li_vessel_nr = dw_list_claims.getitemnumber(ll_row, COLUMN_VESSEL_NR)
			ls_voyage_nr = dw_list_claims.getitemstring(ll_row, COLUMN_VOYAGE_NR)
			li_chart_nr = dw_list_claims.getitemnumber(ll_row, COLUMN_CHART_NR)
			ls_claim_type = dw_list_claims.getitemstring(ll_row, COLUMN_CLAIM_TYPE)
			ll_cerp_id = dw_list_claims.getitemnumber(ll_row, COLUMN_CERP_ID)
			ls_curr_code = dw_list_claims.getitemstring(ll_row, COLUMN_CURR_CODE)
			
			setnull(ld_setexrate)
			lnv_claimcurrencyadjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_setexrate)
			if not isnull(ld_setexrate) then
				ls_modify = dw_freight_received.modify ( ls_expr_rec_exrate_changeable )
				ls_modify = dw_claim_transaction.modify( ls_expr_tr_exrate_changeable )	
				ls_modify = dw_freight_received.modify ( ls_expr_rec_exrate_background )
				ls_modify = dw_claim_transaction.modify( ls_expr_tr_exrate_background )
			else
				dw_freight_received.modify ( ls_expr_exrate_protected )
				dw_claim_transaction.modify( ls_expr_exrate_protected )
				dw_freight_received.modify ( ls_expr_exrate_background )
				dw_claim_transaction.modify( ls_expr_exrate_background )
			end if
		
		else
			
			dw_freight_received.modify ( ls_expr_exrate_protected )
			dw_claim_transaction.modify( ls_expr_exrate_protected )
			dw_freight_received.modify ( ls_expr_exrate_background )
			dw_claim_transaction.modify( ls_expr_exrate_background )
		end if
		
	end if
end if




end subroutine

private function integer _data_modified ();string	ls_message
integer	li_return

if uo_global.ii_access_level = -1 then  return c#return.success
	
if uo_att_actions.dw_file_listing.accepttext( ) = -1 then
	return  c#return.failure
end if
if uo_att_actions.dw_file_listing.modifiedcount( ) + uo_att_actions.dw_file_listing.deletedcount( ) > 0  then
	ls_message = "~n~r Actions"
end if

if dw_claim_transaction.accepttext( ) = -1 or dw_freight_received.accepttext() = -1 then
	return  c#return.failure
end if
if dw_claim_transaction.modifiedcount( ) + dw_claim_transaction.deletedcount( ) + dw_freight_received.modifiedcount() + dw_freight_received.deletedcount() > 0 then
	ls_message = "~n~r Transactions"
end if

if ls_message <> "" then
	ls_message = "Data modified but not saved: " + ls_message + "~n~r~n~r Do you like to save data ?"
	li_return = messageBox("Data Not Saved", ls_message, Question!, YesNo!, 1)

	if li_return = 2 then return c#return.NoAction

	if li_return = 1 then
		if cb_update_transaction.event clicked() = c#return.Failure then return c#return.Failure
		if cb_update_action.event clicked() = c#return.Failure  then return c#return.Failure 
	end if		
end if

return  c#return.success

end function

public function integer wf_getkeydata (ref s_vessel_voyage_chart_claim astr_currentdata);/********************************************************************
   wf_getkeydata()
<DESC>   
	Implemented to be used when a charterer has changed in C/P data.  This function 
	gets the important data from the selected action/transaction.
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
	then manipulate according to implementation and then reload action/transaction window using event ue_reload()
	if needed.
</USAGE>
********************************************************************/
long ll_row

ll_row = dw_list_claims.getselectedrow(0)

if ll_row > 0 then
	astr_currentdata.vessel_nr = dw_list_claims.getitemnumber(ll_row, "vessel_nr")
	astr_currentdata.voyage_nr  = dw_list_claims.getitemstring(ll_row, "voyage_nr")
	astr_currentdata.chart_nr = dw_list_claims.getitemnumber(ll_row, "chart_nr")
	astr_currentdata.claim_nr = ll_row
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

if wf_getkeydata(lstr_olddata) = c#return.Success then
	lstr_olddata.status = "VESSEL"
	this.event ue_reload(lstr_olddata)
end if
	
return not _ib_updatefailure
end function

public function integer wf_setmandatorycolor (u_datagrid adw_gridwindow, string as_colname);/********************************************************************
   wf_setmandatorycolor
   <DESC>	Set mandatory background color for newly insert rows	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_gridwindow
		as_colname
   </ARGS>
   <USAGE>	call by window open event	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		09/06/14 CR3701        LHG008   First Version
   </HISTORY>
********************************************************************/

if adw_gridwindow.modify(as_colname + ".background.mode = '0' " + as_colname + ".background.color = '" &
		+ string(c#color.Transparent) + "~tif(isrownew(), " + string(c#color.MT_MAERSK) +", " + string(c#color.Transparent) + ")'") = '' then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer wf_settranscomments (long al_row, string as_claimtype);/********************************************************************
   wf_settranscomments
   <DESC>	Set transaction comments to the update column when trans code or comment is changed	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_claimtype: Claims Type: is_FREIGHT or other.
   </ARGS>
   <USAGE>	dw_freight_received.itemchanged(), dw_claim_transaction.itemchanged()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		09/06/14 CR3348        LHG008   First Version
		15/09/14 CR3810        LHG008   In the "Comments" of the Transaction table, user should be able to 
		                                select an adjustment reason type and sub-type.
   </HISTORY>
********************************************************************/

string	ls_comment_col, ls_code_col, ls_null 
string	ls_trans_code, ls_reason_type
integer	li_reason_type_id
long		ll_find

datawindowchild	ldwc_reason
u_datagrid			ldw_transaction

if al_row > 0 then
	choose case as_claimtype
		case is_FREIGHT
			ldw_transaction = dw_freight_received
			ls_code_col = "trans_code"
			ls_comment_col = 'freight_comments'
		case else
			ldw_transaction = dw_claim_transaction
			ls_code_col = "c_trans_code"
			ls_comment_col = 'c_trans_comment'
	end choose
	
	setnull(ls_null)
	
	if ldw_transaction.getcolumnname() = ls_code_col then
		//If change code, clear the comment
		ldw_transaction.setitem(al_row, "write_off_reasons", ls_null)
		ldw_transaction.setitem(al_row, "trans_reason_type", ls_null)
		ldw_transaction.setitem(al_row, "trans_reason_subtype", ls_null)
		ldw_transaction.setitem(al_row, ls_comment_col, ls_null)
		
		if ldw_transaction.getchild("trans_reason_subtype", ldwc_reason) > 0 then
			ldwc_reason.setfilter("1=2")
			ldwc_reason.filter()
		end if
	else
		ls_trans_code = ldw_transaction.getitemstring(al_row, ls_code_col)
		choose case ls_trans_code
			case is_WRITE_OFF
				ldw_transaction.setitem(al_row, ls_comment_col, ldw_transaction.getitemstring(al_row, "write_off_reasons"))
			case is_ADJUSTMENTS
				if ldw_transaction.getcolumnname() = "trans_reason_type" then
					ldw_transaction.setitem(al_row, ls_comment_col, ls_null)
					ldw_transaction.setitem(al_row, "trans_reason_subtype", ls_null)
					
					ls_reason_type = ldw_transaction.getitemstring(al_row, "trans_reason_type")
					if ldw_transaction.getchild("trans_reason_type", ldwc_reason) > 0 then
						ll_find = ldwc_reason.find("type_desc = '" + ls_reason_type + "'", 1, ldwc_reason.rowcount())
						if ll_find > 0 then
							li_reason_type_id = ldwc_reason.getitemnumber(ll_find, "type_id")
						end if
					end if
					
					if ldw_transaction.getchild("trans_reason_subtype", ldwc_reason) > 0 then
						if isnull(li_reason_type_id) then
							ldwc_reason.setfilter("1=2")
						else
							ldwc_reason.setfilter("type_id = " + string(li_reason_type_id))
						end if
						ldwc_reason.filter()
					end if
				elseif ldw_transaction.getcolumnname() = "trans_reason_subtype" then
					ls_reason_type = ldw_transaction.getitemstring(al_row, "trans_reason_type")
					ldw_transaction.setitem(al_row, ls_comment_col, ls_reason_type)
				end if
			case else
				//
		end choose
	end if
	
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer wf_validatetransactions (long al_row);/********************************************************************
   wf_validatetransactions()
   <DESC>	Validation script for validating user entries in transaction data	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	cb_update_transaction.event clicked( )	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		10/06/14 CR3348        LHG008   First Version
		15/09/14 CR3810        LHG008   In the "Comments" of the Transaction table, user should be able to 
		                                select an adjustment reason type and sub-type.
		05/08/16 CR4307        SSX014	  Add validation for exchange rate
   </HISTORY>
********************************************************************/

long			ll_row
string		ls_col_trans_date, ls_colname, ls_claimtype, ls_message, ls_trans_code
integer		li_column, li_pos
date			ldt_trans_date
string      ls_protect
long        ll_pos_t
mt_n_stringfunctions lnv_string
decimal     ldc_exrate

n_service_manager				lnv_svcmgr
n_dw_validation_service 	lnv_transrules
u_datagrid						ldw_transaction

constant string METHOD_NAME = "wf_validatetransactions()"

if al_row <= 0 then return c#return.Success

lnv_svcmgr.of_loadservice(lnv_transrules, "n_dw_validation_service")

ls_claimtype = dw_list_claims.getitemstring(al_row, "claim_type")
if ls_claimtype = is_FREIGHT then
	/* handle all columns that user can modify */
	lnv_transrules.of_registerruledatetime("freight_rec_date", true, "transaction date")
	lnv_transrules.of_registerrulestring("trans_code", true, "transaction code")  
//	lnv_transrules.of_registerrulestring("trans_reason_subtype", true, "comments(adjustment reason sub-type)")
	lnv_transrules.of_registerrulestring("freight_comments", true, "comments")
	lnv_transrules.of_registerruledecimal("freight_received_local_curr", true, "transaction amount") 
	
	ls_col_trans_date = "freight_rec_date"
	ldw_transaction = dw_freight_received
else
	/* handle all columns that user can modify */
	lnv_transrules.of_registerruledatetime("c_trans_val_date", true, "transaction date")
	lnv_transrules.of_registerrulestring("c_trans_code", true, "transaction code")  
	lnv_transrules.of_registerrulestring("c_trans_comment", true, "comments")
	lnv_transrules.of_registerruledecimal("c_trans_amount", true, "transaction amount") 
	
	ls_col_trans_date = "c_trans_val_date"
	ldw_transaction = dw_claim_transaction
end if

if lnv_transrules.of_validate(ldw_transaction, ls_message, ll_row, li_column) = c#return.Failure then
	//Directed to column and row where the error occured.
	ls_colname = ldw_transaction.describe("#" + string(li_column) + ".name")
	if ls_colname = "freight_comments" or ls_colname = "c_trans_comment" then
		if ls_colname = "freight_comments" then
			ls_trans_code = ldw_transaction.getitemstring(ll_row, "trans_code")
		else
			ls_trans_code = ldw_transaction.getitemstring(ll_row, "c_trans_code")
		end if
		
		if ls_trans_code = is_WRITE_OFF then
			ls_colname = "write_off_reasons"
		elseif ls_trans_code = is_ADJUSTMENTS then
			li_pos = pos(ls_message, "comments ")
			if isnull(ldw_transaction.getitemstring(ll_row, "trans_reason_type")) then
				ls_colname = "trans_reason_type"
				if li_pos > 0 then
					ls_message = replace(ls_message, li_pos + len("comments"), 1, "(adjustment reason type) ")
				end if
			else
				ls_colname = "trans_reason_subtype"
				if li_pos > 0 then
					ls_message = replace(ls_message, li_pos + len("comments"), 1, "(adjustment reason sub-type) ")
				end if
			end if
		else
			//
		end if
	end if
	
	_addmessage(this.classdefinition, METHOD_NAME, ls_message, "user notification of validation error using validation service n_dw_validation_service")
	
	ldw_transaction.setrow(ll_row)
	ldw_transaction.scrolltorow(ll_row)
	ldw_transaction.post setcolumn(ls_colname)
	ldw_transaction.post setfocus()
	return c#return.Failure
end if

//Validate transaction date
ll_row = 0
do
	ll_row = ldw_transaction.getnextmodified(ll_row, primary!)
	if ll_row > 0 then
		ldt_trans_date = date(ldw_transaction.getitemdatetime(ll_row, ls_col_trans_date))
		if ldt_trans_date < relativedate(today(), -10) or ldt_trans_date > relativedate(today(), 10) then
			if messagebox("Transaction date warning", "The transaction date entered in row# " + string(ll_row) + &
						  " is more than +/- 10 days from today.~r~n~r~nDo you want to continue?", question!, yesno!, 2) = 2 then
				
				ldw_transaction.setrow(ll_row)
				ldw_transaction.scrolltorow(ll_row)
				ldw_transaction.post setcolumn(ls_col_trans_date)
				ldw_transaction.post setfocus()
				return c#return.Failure
			end if
		end if
	end if
loop while ll_row > 0

// validate exchange rate
ll_row = ldw_transaction.getnextmodified(0, primary!)
do while ll_row > 0
	ls_protect = ldw_transaction.describe(COLUMN_EXCHANGE_RATE + ".protect")
	if ls_protect = "1" then
		ll_row = ldw_transaction.getnextmodified(ll_row, primary!)
		continue
	else
		ll_pos_t = Pos(ls_protect, "~t")
		if ll_pos_t > 0 then
			ls_protect = Mid(ls_protect, ll_pos_t + 1, Len(ls_protect) - ll_pos_t - 1)
			ls_protect = lnv_string.of_replaceall(ls_protect, "'", "~~~'", false)
			ls_protect = lnv_string.of_replaceall(ls_protect, "~"", "~~~"", false)
			ls_protect = ldw_transaction.describe("Evaluate('"+ ls_protect + "', " + string(ll_row) + ")")
			if ls_protect = "1" then
				ll_row = ldw_transaction.getnextmodified(ll_row, primary!)
				continue
			end if
		end if
		ldc_exrate = ldw_transaction.getitemnumber(ll_row, COLUMN_EXCHANGE_RATE)
		if isnull(ldc_exrate) or ldc_exrate <= 0 then
			_addmessage(this.classdefinition, METHOD_NAME, "The data inside Ex Rate must be greater than zero.", "user notification of validation error using validation service n_dw_validation_service")
			ldw_transaction.SetColumn(COLUMN_EXCHANGE_RATE)
			ldw_transaction.SetRow(ll_row)
			return c#return.Failure
		end if
	end if
	ll_row = ldw_transaction.getnextmodified(ll_row, primary!)
loop

return c#return.Success

end function

public subroutine wf_set_claim_email ();string ls_claim_email,ls_claim_email_broker
long li_nr
//GET Broker email address from Brokers,CR3536
   ls_claim_email = dw_transaction_action_header.GetItemString(dw_transaction_action_header.getrow(),'claims_claim_email')
   if isnull(ls_claim_email) or trim(ls_claim_email) = "" or ls_claim_email = "no email address found in Brokers system table" then
      li_nr = dw_transaction_action_header.getitemnumber(dw_transaction_action_header.getrow(),"brokers_broker_nr")
	
	   if not IsNull(li_nr) THEN
		   SELECT BROKER_EMAIL 
		   INTO  :ls_claim_email_broker 
		   FROM BROKERS 
		   WHERE BROKER_NR = :li_nr ;
		   if IsNull(ls_claim_email_broker) or Trim(ls_claim_email_broker)= '' then
			   ls_claim_email_broker = 'no email address found in Brokers system table'
		   end if
		   dw_transaction_action_header.setitem(dw_transaction_action_header.getrow(), "claims_claim_email", ls_claim_email_broker)
	   end if	
   end if
	if dw_transaction_action_header.update() = 1 then
		commit;
	else
		rollback;
	end if
end subroutine

public function boolean wf_validateexchangerate ();return false

end function

event ue_retrieve;call super::ue_retrieve;long ll_rc

setredraw(false)
ib_retrievedetail = false

dw_transaction_action_header.Reset()
uo_att_actions.dw_file_listing.Reset()
dw_freight_received.reset()
dw_claim_transaction.Reset()

is_voyage_nr = ""
ii_chart_nr = 0
ii_claim_nr = 0
uo_att_actions.enabled = false

ll_rc = dw_list_claims.Retrieve(ii_vessel_nr)
dw_list_claims.ScrollToRow(ll_rc)

ib_retrievedetail = true
setredraw(true)
end event

event open;call super::open;
/********************************************************************
   w_actions_transactions.open()
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
n_service_manager		lnv_serviceMgr
n_dw_style_service   lnv_style
datawindowchild		ldwc_subtype

this.Move(5,5)

dw_list_claims.SetTransObject(SQLCA)
dw_transaction_action_header.SetTransObject(SQLCA)
dw_transaction_action_comment.settransobject(SQLCA)
dw_freight_received.settransobject(sqlca)
dw_claim_transaction.SetTransObject(SQLCA)

dw_transaction_action_header.sharedata(dw_transaction_action_comment)

uo_vesselselect.of_registerwindow( w_actions_transactions )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
ii_vessel_nr = uo_global.getvessel_nr( )

IF (uo_global.ib_rowsindicator) then
	dw_list_claims.setrowfocusindicator(FOCUSRECT!)
end if

_set_permissions()

uo_att_actions.of_init( "",0,0,0)
uo_att_actions.st_attachmentcounter.visible = false
uo_att_actions.enabled = false

lnv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwformformater(dw_transaction_action_header)
lnv_style.of_dwformformater(dw_transaction_action_comment)
lnv_style.of_dwlistformater(dw_list_claims,false)
lnv_style.of_dwlistformater(dw_freight_received,false)
lnv_style.of_dwlistformater(dw_claim_transaction,false)
lnv_style.of_dwlistformater(uo_att_actions.dw_file_listing,false)

dw_freight_received.setrowfocusindicator(off!)
dw_claim_transaction.setrowfocusindicator(off!)

wf_setmandatorycolor(dw_freight_received, "freight_rec_date")
wf_setmandatorycolor(dw_freight_received, "trans_code")
wf_setmandatorycolor(dw_freight_received, "freight_comments")
wf_setmandatorycolor(dw_freight_received, "write_off_reasons")
wf_setmandatorycolor(dw_freight_received, "freight_received_local_curr")
wf_setmandatorycolor(dw_freight_received, "trans_reason_type")
wf_setmandatorycolor(dw_freight_received, "trans_reason_subtype")

wf_setmandatorycolor(dw_claim_transaction, "c_trans_val_date")
wf_setmandatorycolor(dw_claim_transaction, "c_trans_code")
wf_setmandatorycolor(dw_claim_transaction, "c_trans_comment")
wf_setmandatorycolor(dw_claim_transaction, "write_off_reasons")
wf_setmandatorycolor(dw_claim_transaction, "c_trans_amount")
wf_setmandatorycolor(dw_claim_transaction, "trans_reason_type")
wf_setmandatorycolor(dw_claim_transaction, "trans_reason_subtype")

//Jing: need to be removed when the new layout uo_vesselselect  is ready
uo_vesselselect.backcolor=c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor=c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor=c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor=c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor=c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.Object.DataWindow.Color=string(c#color.MT_LISTHEADER_BG)
end event

on w_actions_transactions.create
int iCurrent
call super::create
this.dw_list_claims=create dw_list_claims
this.dw_claim_transaction=create dw_claim_transaction
this.dw_transaction_action_header=create dw_transaction_action_header
this.cb_new_transaction=create cb_new_transaction
this.cb_update_transaction=create cb_update_transaction
this.cb_delete_transaction=create cb_delete_transaction
this.cb_cancel_transaction=create cb_cancel_transaction
this.dw_transaction_action_comment=create dw_transaction_action_comment
this.sle_1=create sle_1
this.cb_new_action=create cb_new_action
this.cb_update_action=create cb_update_action
this.cb_cancel_action=create cb_cancel_action
this.cb_delete_action=create cb_delete_action
this.uo_att_actions=create uo_att_actions
this.uo_balance=create uo_balance
this.dw_freight_received=create dw_freight_received
this.uo_frt_balance=create uo_frt_balance
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_list_claims
this.Control[iCurrent+2]=this.dw_claim_transaction
this.Control[iCurrent+3]=this.dw_transaction_action_header
this.Control[iCurrent+4]=this.cb_new_transaction
this.Control[iCurrent+5]=this.cb_update_transaction
this.Control[iCurrent+6]=this.cb_delete_transaction
this.Control[iCurrent+7]=this.cb_cancel_transaction
this.Control[iCurrent+8]=this.dw_transaction_action_comment
this.Control[iCurrent+9]=this.sle_1
this.Control[iCurrent+10]=this.cb_new_action
this.Control[iCurrent+11]=this.cb_update_action
this.Control[iCurrent+12]=this.cb_cancel_action
this.Control[iCurrent+13]=this.cb_delete_action
this.Control[iCurrent+14]=this.uo_att_actions
this.Control[iCurrent+15]=this.uo_balance
this.Control[iCurrent+16]=this.dw_freight_received
this.Control[iCurrent+17]=this.uo_frt_balance
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_list_claims, "vessel_nr", "voyage_nr", True)
end event

on w_actions_transactions.destroy
call super::destroy
destroy(this.dw_list_claims)
destroy(this.dw_claim_transaction)
destroy(this.dw_transaction_action_header)
destroy(this.cb_new_transaction)
destroy(this.cb_update_transaction)
destroy(this.cb_delete_transaction)
destroy(this.cb_cancel_transaction)
destroy(this.dw_transaction_action_comment)
destroy(this.sle_1)
destroy(this.cb_new_action)
destroy(this.cb_update_action)
destroy(this.cb_cancel_action)
destroy(this.cb_delete_action)
destroy(this.uo_att_actions)
destroy(this.uo_balance)
destroy(this.dw_freight_received)
destroy(this.uo_frt_balance)
end on

event ue_vesselselection;call super::ue_vesselselection;if _ib_updatefailure then return

if _data_modified() = c#return.failure then
	_ib_updatefailure = true
	ii_vessel_nr = ii_selectedvessel
	if uo_vesselselect.enabled = true then
		uo_vesselselect.of_setcurrentvessel( ii_selectedvessel)
		ii_vessel_nr = ii_selectedvessel
		uo_vesselselect.enabled = false
	end if
	return
else
	_ib_updatefailure = false
end if

if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	messagebox("Error", "Vessel accept error.")
	return
end if

uo_balance.of_setnull()
ii_selectedvessel = ii_vessel_nr
postevent("ue_retrieve")
end event

event closequery;call super::closequery;if _data_modified() =c#return.failure then
	_ib_updatefailure = true
	return 1 
end if

_ib_updatefailure = false
return 0

end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_actions_transactions
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_actions_transactions
integer taborder = 10
end type

type dw_list_claims from u_datagrid within w_actions_transactions
integer x = 37
integer y = 240
integer width = 649
integer height = 2056
integer taborder = 20
string dataobject = "dw_list_claims"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;long		ll_row, ll_businessunit
string	ls_claimtype, ls_curr_code

if currentrow < 1 or ib_retrievedetail = false then return

setpointer(hourglass!)
this.setredraw(false)

_ib_updatefailure = false

uo_att_actions.enabled = true 

il_selectedrow = currentrow

ll_row = currentrow

selectrow(0, false)
setrow(ll_row)
selectrow(ll_row, true)

is_voyage_nr = getitemstring(ll_row,"voyage_nr")
ii_chart_nr = getitemnumber(ll_row,"chart_nr")
ii_claim_nr = getitemnumber(ll_row,"claim_nr")
ls_claimtype = getitemstring(ll_row,"claim_type")

dw_transaction_action_header.retrieve(ii_vessel_nr,is_voyage_nr, ii_chart_nr,ii_claim_nr)

dw_freight_received.retrieve(ii_vessel_nr,is_voyage_nr, ii_chart_nr,ii_claim_nr)
dw_claim_transaction.retrieve(ii_vessel_nr,is_voyage_nr, ii_chart_nr,ii_claim_nr)

uo_att_actions.of_clearimages( ) 
uo_att_actions.of_init(is_voyage_nr, long(ii_vessel_nr), long(ii_claim_nr), ii_chart_nr )

SELECT CURR_CODE
  INTO :ls_curr_code
  FROM CLAIMS
 WHERE VESSEL_NR = :ii_vessel_nr
   AND VOYAGE_NR = :is_voyage_nr
   AND CHART_NR = :ii_chart_nr
   AND CLAIM_NR = :ii_claim_nr;

dw_claim_transaction.settaborder("c_trans_amount_usd",0)
dw_freight_received.settaborder("freight_received", 0)

//CR2949
uo_balance.of_claimbalance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr)
dw_transaction_action_header.modify("claims_show_in_vas.visible = '0'")
if ls_claimtype = "DEM" then
	dw_transaction_action_header.modify("claims_show_in_vas.visible = '1'")
	dw_transaction_action_header.modify("claims_show_in_vas.protect = '1'")
	if dec(uo_balance.st_balance_usd.text) < 0 then
		SELECT BU_ID INTO :ll_businessunit FROM USERS WHERE USERID = :uo_global.is_userid;
		// business unit - demurrage
		if isnull(ll_businessunit) then ll_businessunit = 0
		//users and Demurrage /superusers/administrators
		if (uo_global.ii_access_level = 1 and ll_businessunit = 11) or uo_global.ii_access_level = 2 or uo_global.ii_access_level = 3 then
			dw_transaction_action_header.modify("claims_show_in_vas.protect = '0'")
		end if				
	end if
end if

dw_freight_received.visible = (ls_claimtype = is_FREIGHT)
dw_claim_transaction.visible = not dw_freight_received.visible

uo_vesselselect.enabled = true

_set_permissions()
this.setredraw(true)
setpointer(arrow!)
end event

event rowfocuschanging;call super::rowfocuschanging;if _data_modified() = c#return.failure then
	_ib_updatefailure = true
	return 1
end if

_ib_updatefailure = false
return 0
end event

event clicked;call super::clicked;if row > 0 and row = getrow() then
	if event rowfocuschanging(row, row) = 0 then
		this.event rowfocuschanged(row)
	end if
end if
end event

type dw_claim_transaction from u_datagrid within w_actions_transactions
integer x = 718
integer y = 576
integer width = 2738
integer height = 784
integer taborder = 40
string dataobject = "dw_claim_transaction"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;decimal {2} ld_a_usd, ld_exrate, ld_a
n_claimcurrencyadjust lnv_claimcurrencyadjust
string ls_curr_code, ls_claim_type
long ll_cerp_id
decimal ld_setexrate
string ls_trans_code

this.AcceptText()

if dwo.name = COLUMN_C_TRANS_AMOUNT or &
	dwo.name = COLUMN_C_TRANS_CODE then
	SELECT CURR_CODE, CAL_CERP_ID, CLAIM_TYPE
	INTO :ls_curr_code, :ll_cerp_id, :ls_claim_type
	FROM CLAIMS
	WHERE VESSEL_NR = :ii_vessel_nr
	AND VOYAGE_NR = :is_voyage_nr
	AND CHART_NR = :ii_chart_nr
	AND CLAIM_NR = :ii_claim_nr;
	if sqlca.sqlcode <> 0 then
		_addmessage( this.classdefinition, "cb_new_transaction.click()", "No currency code specified.", "user notification of validation error")
	end if
end if

CHOOSE CASE dwo.name
	CASE COLUMN_C_TRANS_AMOUNT
			ld_a = getitemnumber(row, COLUMN_C_TRANS_AMOUNT)
			if ls_curr_code = "USD" then
				setitem(row, COLUMN_C_TRANS_AMOUNT_USD, ld_a)
			elseif ls_curr_code <> "USD" or isnull(this.getitemdecimal(row,COLUMN_C_TRANS_AMOUNT_USD)) then
				ld_setexrate = getitemdecimal(row, COLUMN_EXCHANGE_RATE)
				ls_trans_code = getitemstring(row, COLUMN_C_TRANS_CODE)
				
				if isnull(ld_setexrate) and ls_trans_code = TRANS_CODE_R then
					lnv_claimcurrencyadjust.of_getsetexrate(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_setexrate)
				end if
				
				if not isnull(ld_setexrate) then
					ld_a_usd = ld_a * ld_setexrate / 100.0
					SetItem(row, COLUMN_C_TRANS_AMOUNT_USD, ld_a_usd)
					setitem(row, COLUMN_EXCHANGE_RATE, ld_setexrate)
				else
					if lnv_claimcurrencyadjust.of_getamountusd(ls_claim_type, ls_curr_code, ld_a, ld_a_usd) >= 0 then
						SetItem(row, COLUMN_C_TRANS_AMOUNT_USD, ld_a_usd)
					else
						_addmessage(this.classdefinition, "dw_claim_transaction.itemchanged()", "System error, probably because the system can not find the exchange rate for the specified date. Please try again.", "user notification of validation error")
						return 2
					end if
				end if
			end if
	case COLUMN_C_TRANS_CODE, "c_trans_comment", "write_off_reasons", "trans_reason_type", "trans_reason_subtype"
		wf_settranscomments(row, "OTHER")
		if dwo.name = COLUMN_C_TRANS_CODE then
			setnull(ld_setexrate)
			if data = TRANS_CODE_R then
				lnv_claimcurrencyadjust.of_getsetexrate(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_setexrate)
			end if
			setitem(row, COLUMN_EXCHANGE_RATE, ld_setexrate)
			ld_a = getitemnumber(row, COLUMN_C_TRANS_AMOUNT)
			if not isnull(ld_setexrate) then
				ld_a_usd = ld_a * ld_setexrate / 100.0
				SetItem(row, COLUMN_C_TRANS_AMOUNT_USD, ld_a_usd)
			else
				if lnv_claimcurrencyadjust.of_getamountusd(ls_claim_type, ls_curr_code, ld_a, ld_a_usd) >= 0 then
					SetItem(row, COLUMN_C_TRANS_AMOUNT_USD, ld_a_usd)
				else
					_addmessage(this.classdefinition, "dw_claim_transaction.itemchanged()", "System error, probably because the system can not find the exchange rate for the specified date. Please try again.", "user notification of validation error")
					return 2
				end if
			end if
		end if
	case COLUMN_EXCHANGE_RATE
		ld_setexrate = dec(data)
		ld_a = getitemnumber(row, COLUMN_C_TRANS_AMOUNT)
		ld_a_usd = ld_a * ld_setexrate / 100.0
		SetItem(row, COLUMN_C_TRANS_AMOUNT_USD, ld_a_usd)
END CHOOSE

end event

event rowfocuschanged;call super::rowfocuschanged;integer	li_reason_type_id
long		ll_find
datawindowchild ldwc_reason

if currentrow > 0 then
	if this.getitemstatus(currentrow, 0, Primary!) = new! or this.getitemstatus(currentrow, 0, Primary!) = newmodified! then
		selectrow(0, false)
		selectrow(currentrow, true)
		
		if this.getchild("trans_reason_type", ldwc_reason) > 0 then
			ll_find = ldwc_reason.find("type_desc = '" + this.getitemstring(currentrow, "trans_reason_type") + "'", 1, ldwc_reason.rowcount())
			if ll_find > 0 then
				li_reason_type_id = ldwc_reason.getitemnumber(ll_find, "type_id")
			end if
		end if
		
		if this.getchild("trans_reason_subtype", ldwc_reason) > 0 then
			if isnull(li_reason_type_id) then
				ldwc_reason.setfilter("1=2")
			else
				ldwc_reason.setfilter("type_id = " + string(li_reason_type_id))
			end if
			ldwc_reason.filter()
		end if
	end if
end if
end event

type dw_transaction_action_header from uo_datawindow within w_actions_transactions
event ue_refreshclaimstatuslist ( )
integer x = 718
integer y = 252
integer width = 3845
integer height = 304
integer taborder = 30
string dataobject = "dw_transaction_action_header"
boolean border = false
end type

event ue_refreshclaimstatuslist();datawindowchild	ldwc_child

this.getchild("claims_status", ldwc_child)
ldwc_child.settransobject(sqlca)
ldwc_child.retrieve()

end event

event retrieveend;call super::retrieveend;long ll_expect_receive_pct
string ls_claimtype

IF this.RowCount() > 0 THEN
	IF IsNull(this.GetitemDecimal(1, "claims_expect_receive_pct")) THEN
		//this.Setitem(1,"claims_expect_receive_pct",100)
		ls_claimtype = this.getitemstring(1, 'claims_claim_type')
		SELECT EXPECT_RECEIVE_PCT INTO :ll_expect_receive_pct 
		FROM CLAIM_TYPES
		WHERE CLAIM_TYPE = :ls_claimtype;
		
		if isnull(ll_expect_receive_pct) then
			if ls_claimtype = 'DEM' then
				ll_expect_receive_pct = 95
			else
				ll_expect_receive_pct = 100
			end if
		end if
		this.Setitem(1, "claims_expect_receive_pct", ll_expect_receive_pct)
	END IF
END IF





end event

event itemchanged;datetime ldt_original, ldt_claim_date
string   ls_claim_email, ls_original, ls_email_wrong
integer  li_confirmed,li_nr
String   ls_claim_email_broker
mt_n_outgoingmail	lnv_mail

choose case dwo.name
	case "claims_claim_sent"
		if data = "1" then			
			ldt_claim_date = this.getitemdatetime(row, "claims_claim_sent_date")
			if isnull(ldt_claim_date) then
				dw_transaction_action_header.setitem(row, "claims_claim_sent_date", today())
			end if
		end if
	case "claims_claim_sent_date"
		ldt_original = this.getitemdatetime(row, "claims_claim_sent_date", primary!, true)
		li_confirmed = this.getitemnumber(row, "claims_claim_sent")
		if li_confirmed = 1 and isnull(data) then
			messagebox("Validation Error", "Claim Sent Date must be filled out when Claim Sent option is ticked.")
			this.post setitem(row, "claims_claim_sent_date", ldt_original)
			return 2
		end if
	case "claims_broker_confirmed"
		ldt_claim_date = this.getitemdatetime(row, "claims_broker_confirmed_date")
		if data = "1" and isnull(ldt_claim_date) then
			dw_transaction_action_header.setitem(row, "claims_broker_confirmed_date", today())
		end if
	case "claims_broker_confirmed_date"
		ldt_original = this.getitemdatetime(row, "claims_broker_confirmed_date", primary!, true)
		li_confirmed = this.getitemnumber(row, "claims_broker_confirmed")
		if li_confirmed = 1 and isnull(data) then
			messagebox("Validation Error", "Broker Confirmed Date must be filled out when Broker Confirmed option is ticked.")
			this.post setitem(row, "claims_broker_confirmed_date", ldt_original)
			return 2
		end if
	case "claims_charterer_confirmed"
		ldt_claim_date = this.getitemdatetime(row, "claims_charterer_confirmed_date")
		if data = "1" and isnull(ldt_claim_date) then
			dw_transaction_action_header.setitem(row, "claims_charterer_confirmed_date", today())
		end if
	case "claims_charterer_confirmed_date"
		ldt_original = this.getitemdatetime(row, "claims_charterer_confirmed_date", primary!, true)
		li_confirmed = this.getitemnumber(row, "claims_charterer_confirmed")
		if li_confirmed = 1 and isnull(data) then
			messagebox("Validation Error", "Charterer Confirmed Date must be filled out when Charterer Confirmed option is ticked.")
			this.post setitem(row, "claims_charterer_confirmed_date", ldt_original)
			return 2
		end if
	case "claims_status"			//set the date when setting the status
		dw_transaction_action_header.setitem(row, "claims_status_date",today())
	case "claims_claim_email"	//Validation for claim email address
		ls_claim_email = data
		ls_original = this.getItemString(row, "claims_claim_email", primary!, true)
		if ls_claim_email <> "" and not isnull(ls_claim_email) then
			lnv_mail = create mt_n_outgoingmail
			if  lnv_mail.of_verifyreceiveraddress(ls_claim_email,ls_email_wrong) = -1 then
				messagebox("Validation Error", ls_email_wrong)
				this.setitem(row, "claims_claim_email", ls_original )
				destroy lnv_mail	
				return 2
			end if		
			destroy lnv_mail	
		end if
	case "claims_status_date"	//valication for status_date
		ldt_original = this.getItemDatetime(row, "claims_status_date", primary!, true)
		if dw_transaction_action_header.getitemstring(row, "claims_status") <> "No Response" and isnull(dw_transaction_action_header.getitemdatetime(row, "claims_status_date")) then
			messagebox("Validation","The Status Date can not be empty. Please input again")
			this.setitem(row, "claims_status_date", ldt_original )
			return 2
		end if
end choose

post wf_updatedatawindow()


end event

event losefocus;call super::losefocus;this.accepttext()

end event

event constructor;call super::constructor;datawindowchild	ldwc_child

this.getchild("claims_status", ldwc_child)
ldwc_child.modify("status_desc.width = " + this.describe("claims_status.width"))

end event

type cb_new_transaction from commandbutton within w_actions_transactions
integer x = 2427
integer y = 1376
integer width = 343
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "New Trans."
end type

event clicked;long 	  ll_row, ll_seq
decimal ld_exrate
string  ls_curr_code, ls_claimtype
n_get_maxvalue	lnv_get_maxvalue

if ii_vessel_nr = 0 or is_voyage_nr = "" then return

ll_row = dw_list_claims.getselectedrow(0)
if ll_row <= 0 then return

ls_claimtype = dw_list_claims.getitemstring(ll_row, "claim_type")
if ls_claimtype = is_FREIGHT then
	lnv_get_maxvalue = create n_get_maxvalue
	ll_seq = lnv_get_maxvalue.of_get_maxvalue("FREIGHT_RECEIVED")
	destroy lnv_get_maxvalue
	
	if ll_seq < 0 then
		_addmessage(this.classdefinition, "cb_new_transaction.click()", "Error get sequence number from table FREIGHT_RECEIVED.", "Database error")
		return
	end if

	ll_row = dw_freight_received.insertrow(0)
	dw_freight_received.setitem(ll_row, "vessel_nr", ii_vessel_nr)
	dw_freight_received.setitem(ll_row, "voyage_nr", is_voyage_nr)
	dw_freight_received.setitem(ll_row, "chart_nr", ii_chart_nr)
	dw_freight_received.setitem(ll_row, "claim_nr", ii_claim_nr)
	dw_freight_received.setitem(ll_row, "freight_rec_date", date(string(today())))
	dw_freight_received.setitem(ll_row, "freight_created_by", uo_global.is_userid)
	dw_freight_received.setitem(ll_row, "freight_seq", ll_seq)
	
	dw_freight_received.scrolltorow(ll_row)
	dw_freight_received.setrow(ll_row)
	dw_freight_received.selectrow(0, false)
	dw_freight_received.selectrow(ll_row, true)
	
	dw_freight_received.setcolumn("freight_rec_date")
	dw_freight_received.setfocus()
	cb_update_transaction.default = true
else
	lnv_get_maxvalue = create n_get_maxvalue
	ll_seq = lnv_get_maxvalue.of_get_maxvalue("CLAIM_TRANSACTION")
	destroy lnv_get_maxvalue
	
	if ll_seq < 0 then
		_addmessage(this.classdefinition, "cb_new_transaction.click()", "Error get sequence number from table CLAIM_TRANSACTION.", "Database error")
		return
	end if
	
	ll_row = dw_claim_transaction.InsertRow(0)
	dw_claim_transaction.SetItem(ll_row, "vessel_nr", ii_vessel_nr)
	dw_claim_transaction.SetItem(ll_row, "voyage_nr", is_voyage_nr)
	dw_claim_transaction.SetItem(ll_row, "chart_nr", ii_chart_nr)
	dw_claim_transaction.SetItem(ll_row, "claim_nr", ii_claim_nr)
	dw_claim_transaction.SetItem(ll_row, "c_trans_val_date", date(string(today())))
	dw_claim_transaction.SetItem(ll_row, "c_trans_created_by", uo_global.is_userid)
	dw_claim_transaction.SetItem(ll_row, "c_trans_seq", ll_seq)
	
	SELECT CURR_CODE
	  INTO :ls_curr_code
	  FROM CLAIMS
	 WHERE VESSEL_NR = :ii_vessel_nr
	   AND VOYAGE_NR = :is_voyage_nr
	   AND CHART_NR = :ii_chart_nr
	   AND CLAIM_NR = :ii_claim_nr;
	
	if sqlca.sqlcode <> 0 then
		_addmessage(this.classdefinition, "cb_new_transaction.click()", "No currency code specified.", "user notification of validation error")
	end if
	
	dw_claim_transaction.selectRow(0, false)
	dw_claim_transaction.selectRow(ll_row, true)
	dw_claim_transaction.setRow(ll_row)
	dw_claim_transaction.scrollToRow(ll_row)
	dw_claim_transaction.setColumn("c_trans_val_date")
	dw_claim_transaction.setFocus()
	cb_update_transaction.default = true
end if

end event

type cb_update_transaction from commandbutton within w_actions_transactions
integer x = 2775
integer y = 1376
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
string text = "Update Trans."
end type

event clicked;string		ls_claimtype
integer		li_ruleid
double		ldo_cp
long			ll_row
decimal{2}  ld_amount, ld_amount_usd

u_datagrid						ldw_transaction
u_addr_commission 			lnv_calc_adrcomm
uo_auto_commission			lnv_calc_brokercomm   /* autoinstantiated */
n_service_manager				lnv_svcmgr
n_error_service				lnv_errservice
n_claimcurrencyadjust		lnv_claimcurrencyadjust

//CR3536 when update Trans ,update Claim Email Address
wf_set_claim_email()


CONSTANT string is_METHOD_NAME = "cb_update_transaction.clicked()"

if ii_vessel_nr = 0 or is_voyage_nr = "" then return c#return.failure

ll_row = dw_list_claims.getselectedrow(0)
if ll_row <= 0 then return c#return.NoAction

if dw_claim_transaction.accepttext( ) = -1 or dw_freight_received.accepttext() = -1 then
	return c#return.failure
end if

if dw_claim_transaction.modifiedcount( ) + dw_claim_transaction.deletedcount( ) + dw_freight_received.modifiedcount() + dw_freight_received.deletedcount() = 0 then
	return c#return.NoAction
end if

if wf_validatetransactions(ll_row) = c#return.Failure then
	return c#return.Failure
end if

ls_claimtype = dw_list_claims.getitemstring(ll_row, "claim_type")
if ls_claimtype = is_FREIGHT then
	ldw_transaction = dw_freight_received
else
	ldw_transaction = dw_claim_transaction
end if

if ldw_transaction.update(true, false) = 1 then
	
	if ls_claimtype = is_FREIGHT then
		uo_frt_balance.uf_set_bol_quantity_reload(false, false)
		ld_amount = uo_frt_balance.uf_calculate_balance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr)
		
		/* calculate CLAIM_AMOUNT_USD */
		lnv_claimcurrencyadjust.of_getclaimamounts(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr, ld_amount, ld_amount_usd, false)
		
		UPDATE CLAIMS
			SET CLAIM_AMOUNT = :ld_amount, 
			    CLAIM_AMOUNT_USD = :ld_amount_usd
		 WHERE VESSEL_NR = :ii_vessel_nr AND
				 VOYAGE_NR = :is_voyage_nr AND 
				 CHART_NR  = :ii_chart_nr AND
				 CLAIM_NR  = :ii_claim_nr;
	else
		/* calculate CLAIM_AMOUNT_USD */
		lnv_claimcurrencyadjust.of_getclaimamounts(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr, ld_amount, ld_amount_usd, true)
		
		UPDATE CLAIMS
			SET CLAIM_AMOUNT_USD = :ld_amount_usd
		 WHERE VESSEL_NR = :ii_vessel_nr AND
				 VOYAGE_NR = :is_voyage_nr AND
				 CHART_NR  = :ii_chart_nr AND
				 CLAIM_NR  = :ii_claim_nr;
	end if
	
	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		_addmessage(this.classdefinition, is_METHOD_NAME, "Calculating the claim amount in USD is wrong. Please go to the claim picture and update the claim.", "user notification of validation error")
		return c#return.Failure
	end if
	
	/* Address Commission */
	lnv_calc_adrcomm = create u_addr_commission
	if lnv_calc_adrcomm.of_add_com(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr) = -1 then
		ROLLBACK;
		destroy lnv_calc_adrcomm
		return c#return.Failure
	else
		COMMIT;
		ldw_transaction.resetupdate()
	end if
	destroy lnv_calc_adrcomm
	
	ldw_transaction.retrieve(ii_vessel_nr,is_voyage_nr, ii_chart_nr,ii_claim_nr)
	
	/* Broker Commission */
	ls_claimtype = dw_list_claims.getitemstring(ll_row, "claim_type")
	ldo_cp = dw_list_claims.getitemnumber(ll_row, "cp_id_comm")
	if lnv_calc_brokercomm.of_generate(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr, ls_claimtype, "OLD", ldo_cp) = -1 then
		ROLLBACK;
		//return c#return.Failure
	else
		COMMIT;
	end if
	
	cb_update_transaction.default = false
	uo_balance.of_claimbalance(ii_vessel_nr, is_voyage_nr, ii_chart_nr, ii_claim_nr)
	uo_vesselselect.enabled = true
else
	ROLLBACK;
	lnv_svcmgr.of_loadservice(lnv_errservice , "n_error_service")
	lnv_errservice.of_showmessages()
	return c#return.Failure
end if

return c#return.Success
end event

type cb_delete_transaction from commandbutton within w_actions_transactions
boolean visible = false
integer x = 2080
integer y = 1376
integer width = 343
integer height = 100
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Trans."
end type

event clicked;string	ls_claimtype
long		ll_row

datawindow	ldw_transaction

if ii_vessel_nr = 0 or is_voyage_nr = "" then return

ll_row = dw_list_claims.getselectedrow(0)
if ll_row <= 0 then return

ls_claimtype = dw_list_claims.getitemstring(ll_row, "claim_type")
if ls_claimtype = is_FREIGHT then
	ldw_transaction = dw_freight_received
else
	ldw_transaction = dw_claim_transaction
end if

ll_row = ldw_transaction.getselectedrow(0)
if ll_row > 0 then
	ldw_transaction.deleterow(ll_row)
	cb_update_transaction.default = true
end if

end event

type cb_cancel_transaction from commandbutton within w_actions_transactions
integer x = 3122
integer y = 1376
integer width = 347
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel Trans."
end type

event clicked;string	ls_claimtype
long		ll_row

datawindow	ldw_transaction

if ii_vessel_nr = 0 or is_voyage_nr = "" then return

ll_row = dw_list_claims.getselectedrow(0)
if ll_row <= 0 then return

ls_claimtype = dw_list_claims.getitemstring(ll_row, "claim_type")
if ls_claimtype = is_FREIGHT then
	ldw_transaction = dw_freight_received
else
	ldw_transaction = dw_claim_transaction
end if

ldw_transaction.retrieve(ii_vessel_nr,is_voyage_nr,ii_chart_nr,ii_claim_nr)
ldw_transaction.selectrow(0, false)
uo_vesselselect.enabled = true

end event

type dw_transaction_action_comment from uo_datawindow within w_actions_transactions
integer x = 3493
integer y = 576
integer width = 1070
integer height = 1872
integer taborder = 90
boolean bringtotop = true
string dataobject = "dw_transaction_action_comment"
boolean border = false
boolean livescroll = false
end type

event losefocus;call super::losefocus;this.accepttext()
wf_updatedatawindow()
end event

type sle_1 from mt_u_singlelineedit within w_actions_transactions
integer width = 4599
integer height = 216
long backcolor = 22628899
string text = ""
boolean border = false
end type

type cb_new_action from commandbutton within w_actions_transactions
integer x = 2062
integer y = 2356
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
string text = "New Action"
end type

event clicked;
/********************************************************************

   <DESC>  Add the selected row from datawindow, but not the database!</DESC>
   <RETURN> </RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS></ARGS>
   <USAGE></USAGE>
********************************************************************/

long ll_row

if ii_vessel_nr = 0 or is_voyage_nr = "" then return

if dw_list_claims.getselectedrow( 0 ) = 0 then return

ll_row = uo_att_actions.dw_file_listing.InsertRow(0)

IF ll_row > 0 THEN
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id", ii_vessel_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id_str", is_voyage_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id_int", ii_chart_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"id2", ii_claim_nr)
	uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_date", today())
	uo_att_actions.dw_file_listing.SelectRow(0,FALSE)
	uo_att_actions.dw_file_listing.SetRow(ll_row)
	uo_att_actions.dw_file_listing.ScrollToRow(ll_row)
	uo_att_actions.dw_file_listing.SetColumn("description")
	uo_att_actions.dw_file_listing.SetFocus()
	cb_update_action.Default = TRUE
END IF

end event

type cb_update_action from commandbutton within w_actions_transactions
integer x = 2409
integer y = 2356
integer width = 361
integer height = 100
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Update Action"
end type

event clicked;
/********************************************************************
   
	<DESC>   Updates all amended rows in actions datawindow to the database!  Including the files</DESC>
   <RETURN> </RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS></ARGS>
   <USAGE> </USAGE>
********************************************************************/

if ii_vessel_nr = 0 or is_voyage_nr = "" then return

long	ll_row, ll_rowstatus
string ls_data
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
constant string METHOD_NAME = "clicked()"
//CR3536 when update action ,update Claim Email Address
wf_set_claim_email()

uo_att_actions.dw_file_listing.accepttext( )
lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
lnv_actionrules.of_registerrulestring("description", true, "description")
if lnv_actionrules.of_validate(uo_att_actions.dw_file_listing, true) = c#return.Failure then return c#return.Failure
uo_att_actions.of_updateattach()
cb_update_action.Default = FALSE
uo_vesselselect.enabled = true
end event

type cb_cancel_action from commandbutton within w_actions_transactions
integer x = 3122
integer y = 2356
integer width = 347
integer height = 100
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel Action"
end type

event clicked;
/********************************************************************
	
   <DESC>   Cancels any updates made</DESC>
   <RETURN></RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS></ARGS>
   <USAGE> </USAGE>
********************************************************************/
if ii_vessel_nr = 0 or is_voyage_nr = "" then return

uo_att_actions.of_init( is_voyage_nr , long(ii_vessel_nr) ,long(ii_claim_nr), ii_chart_nr)
uo_vesselselect.enabled = true
end event

type cb_delete_action from commandbutton within w_actions_transactions
integer x = 2775
integer y = 2356
integer width = 343
integer height = 100
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Delete Action"
end type

event clicked;
/********************************************************************

   <DESC>   Deletes the selected row from datawindow, but not the database!</DESC>
   <RETURN></RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS></ARGS>
   <USAGE> </USAGE>
********************************************************************/
if ii_vessel_nr = 0 or is_voyage_nr = "" then return

uo_att_actions.of_deleteimage( )
cb_update_action.Default = TRUE

end event

type uo_att_actions from u_fileattach within w_actions_transactions
integer x = 718
integer y = 1516
integer width = 2757
integer height = 932
integer taborder = 100
string is_dataobjectname = "d_sq_tb_claim_action_files"
string is_counterlabel = "Actions:"
boolean ib_allow_dragdrop = true
integer ii_buttonmode = 0
boolean ib_enable_update_button = true
boolean ib_allownonattachrecs = true
end type

on uo_att_actions.destroy
call u_fileattach::destroy
end on

event ue_childclicked;call super::ue_childclicked;long ll_row, ll_data
datetime ldt_dummy

setnull(ldt_dummy)

if row > 0 then
	
	if dwo.name = "c_action_finished" then
		
		if  dw_file_listing.getitemnumber(row,"c_action_finished") = 0 or isnull(dw_file_listing.getitemnumber(row,"c_action_finished")) then
			dw_file_listing.setitem(row,"finished_date",today() )
			dw_file_listing.setitem(row,"finished_by",uo_global.is_userid)
		else
			dw_file_listing.setitem(row,"finished_date",ldt_dummy )
			dw_file_listing.setitem(row,"finished_by","")
		end if
	end if	
	
end if
end event

event ue_dropfiles;call super::ue_dropfiles;long ll_row, ll_rows

/* update escential columns if a new record */
ll_row = uo_att_actions.dw_file_listing.getrow()
ll_rows = dw_file_listing.rowcount()

if ll_rows > 0 then
	for ll_row = ll_rows to 1 step -1
		// if isnull(uo_att_actions.dw_file_listing.getitemnumber(ll_row,"file_id")) then
		if isnull(uo_att_actions.dw_file_listing.getitemdatetime(ll_row,"c_action_date")) then	
			uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_date", today())
		end if
		dw_file_listing.SetColumn("description")
	next
	dw_file_listing.setfocus( )
end if
end event

event ue_dropmails;call super::ue_dropmails;long ll_row

/* update escential columns if a new record */
ll_row = uo_att_actions.dw_file_listing.getrow()
if ll_row<>0 then
	if isnull(uo_att_actions.dw_file_listing.getitemnumber(ll_row,"file_id")) then
		uo_att_actions.dw_file_listing.SetItem(ll_row,"c_action_date", today())
	end if
	dw_file_listing.SetColumn("description")
	dw_file_listing.setfocus( )
end if

end event

event ue_childmodified;call super::ue_childmodified;cb_update_action.default=true

end event

type uo_balance from u_claimbalance within w_actions_transactions
integer x = 23
integer y = 2316
boolean bringtotop = true
end type

on uo_balance.destroy
call u_claimbalance::destroy
end on

type dw_freight_received from u_datagrid within w_actions_transactions
integer x = 718
integer y = 576
integer width = 2738
integer height = 784
integer taborder = 50
boolean bringtotop = true
string title = ""
string dataobject = "dw_freight_received"
boolean vscrollbar = true
boolean border = false
end type

event itemchanged;call super::itemchanged;string		ls_curr_code, ls_errmsg
long			ll_row
decimal{2}	ld_amount_usd, ld_amount, ld_received
date			ld_recdate
integer     li_vessel_nr
string      ls_voyage_nr
integer     li_chart_nr
string      ls_claim_type
long        ll_cerp_id
decimal     ld_setexrate
string      ls_trans_code

n_claimcurrencyadjust	lnv_claimcurrencyadjust

if dwo.name = COLUMN_FREIGHT_RECEIVE_LOCAL_CURR or &
	dwo.name = COLUMN_TRANS_CODE then
	
	ll_row = dw_list_claims.getrow()
	if row <= 0 or ll_row <= 0 then return 0

	li_vessel_nr = dw_list_claims.getitemnumber(ll_row, COLUMN_VESSEL_NR)
	ls_voyage_nr = dw_list_claims.getitemstring(ll_row, COLUMN_VOYAGE_NR)
	li_chart_nr = dw_list_claims.getitemnumber(ll_row, COLUMN_CHART_NR)
	ls_claim_type = dw_list_claims.getitemstring(ll_row, COLUMN_CLAIM_TYPE)
	ll_cerp_id = dw_list_claims.getitemnumber(ll_row, COLUMN_CERP_ID)
	ls_curr_code = dw_list_claims.getitemstring(ll_row, COLUMN_CURR_CODE)
end if

this.accepttext()

choose case dwo.name
	case COLUMN_FREIGHT_RECEIVE_LOCAL_CURR
		ld_amount = this.getitemdecimal(row, COLUMN_FREIGHT_RECEIVE_LOCAL_CURR)
		ld_received = this.getitemdecimal(row, COLUMN_FREIGHT_RECEIVED)
	
		if ls_curr_code = "USD" then
			this.setitem(row, COLUMN_FREIGHT_RECEIVED, ld_amount)
		elseif isnull(ld_received) or ls_curr_code <> "USD" then
			ld_setexrate = getitemdecimal(row, COLUMN_EXCHANGE_RATE)
			ls_trans_code = getitemstring(row, COLUMN_TRANS_CODE)
			
			if isnull(ld_setexrate) and ls_trans_code = TRANS_CODE_R then
				lnv_claimcurrencyadjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_setexrate)
			end if
			
			if not isnull(ld_setexrate) then
				ld_amount_usd = ld_amount * ld_setexrate / 100.0
				this.setitem(row, COLUMN_FREIGHT_RECEIVED, ld_amount_usd)
				this.setitem(row, COLUMN_EXCHANGE_RATE, ld_setexrate)
			else
				if lnv_claimcurrencyadjust.of_getamountusd(ls_claim_type, ls_curr_code, ld_amount, ld_amount_usd) >= 0 then
					this.setitem(row, COLUMN_FREIGHT_RECEIVED, ld_amount_usd)
				else
					ls_errmsg = "System error, probably because the system can not find the exchange rate for the specified date. Please try again."
					_addmessage(this.classdefinition, "dw_freight_received.itemchanged()", ls_errmsg, "user notification of validation error")
					return 2
				end if
			end if
		end if
	case COLUMN_TRANS_CODE, "freight_comments", "write_off_reasons", "trans_reason_type", "trans_reason_subtype"
		wf_settranscomments(row, is_FREIGHT)
		if dwo.name = COLUMN_TRANS_CODE then
			setnull(ld_setexrate)
			if data = TRANS_CODE_R then
				lnv_claimcurrencyadjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_curr_code, ld_setexrate)
			end if
			setitem(row, COLUMN_EXCHANGE_RATE, ld_setexrate)
			ld_amount = this.getitemdecimal(row, COLUMN_FREIGHT_RECEIVE_LOCAL_CURR)
			if not isnull(ld_setexrate) then
				ld_amount_usd = ld_amount * ld_setexrate / 100.0
				this.setitem(row, COLUMN_FREIGHT_RECEIVED, ld_amount_usd)
			else
				if lnv_claimcurrencyadjust.of_getamountusd(ls_claim_type, ls_curr_code, ld_amount, ld_amount_usd) >= 0 then
					this.setitem(row, COLUMN_FREIGHT_RECEIVED, ld_amount_usd)
				else
					ls_errmsg = "System error, probably because the system can not find the exchange rate for the specified date. Please try again."
					_addmessage(this.classdefinition, "dw_freight_received.itemchanged()", ls_errmsg, "user notification of validation error")
					return 2
				end if
			end if
		end if
	case COLUMN_EXCHANGE_RATE
		ld_setexrate = dec(data)
		ld_amount = this.getitemdecimal(row, COLUMN_FREIGHT_RECEIVE_LOCAL_CURR)
		ld_amount_usd = ld_amount * ld_setexrate / 100.0
		this.setitem(row, COLUMN_FREIGHT_RECEIVED, ld_amount_usd)
end choose

end event

event rowfocuschanged;call super::rowfocuschanged;integer	li_reason_type_id
long		ll_find
datawindowchild ldwc_reason

if currentrow > 0 then
	if this.getitemstatus(currentrow, 0, Primary!) = new! or this.getitemstatus(currentrow, 0, Primary!) = newmodified! then
		selectrow(0, false)
		selectrow(currentrow, true)
		
		if this.getchild("trans_reason_type", ldwc_reason) > 0 then
			ll_find = ldwc_reason.find("type_desc = '" + this.getitemstring(currentrow, "trans_reason_type") + "'", 1, ldwc_reason.rowcount())
			if ll_find > 0 then
				li_reason_type_id = ldwc_reason.getitemnumber(ll_find, "type_id")
			end if
		end if
		
		if this.getchild("trans_reason_subtype", ldwc_reason) > 0 then
			if isnull(li_reason_type_id) then
				ldwc_reason.setfilter("1=2")
			else
				ldwc_reason.setfilter("type_id = " + string(li_reason_type_id))
			end if
			ldwc_reason.filter()
		end if
	end if
end if
end event

type uo_frt_balance from uo_freight_balance within w_actions_transactions
boolean visible = false
integer x = 3483
integer y = 876
end type

on uo_frt_balance.destroy
call uo_freight_balance::destroy
end on

