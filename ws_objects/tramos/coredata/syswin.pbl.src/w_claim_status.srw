$PBExportHeader$w_claim_status.srw
forward
global type w_claim_status from w_system_base
end type
end forward

global type w_claim_status from w_system_base
integer width = 1563
integer height = 1280
string title = "Claim Statuses"
end type
global w_claim_status w_claim_status

forward prototypes
public subroutine documentation ()
public function integer wf_validate ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_claim_status
   <OBJECT>	Maintain Claims Status	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	24/07/2013   CR3270       ZSW001        First Version
	28/08/2014   CR3781		 CCY018		    The window title match with the text of a menu item
   </HISTORY>
********************************************************************/

end subroutine

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>	It should not be possible to change/delete any value 
	         that has been used in claims	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest using before updating	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	31/07/2013   CR3270       ZSW001       First Version
   </HISTORY>
********************************************************************/

long		ll_loop, ll_count, ll_found
string	ls_status, ls_error

mt_n_datastore		lds_claims

lds_claims = create mt_n_datastore
lds_claims.dataobject = "d_sq_gr_used_claim_status"
lds_claims.settransobject(sqlca)
ll_count = lds_claims.retrieve()

for ll_loop = 1 to ll_count
	ls_status = lds_claims.getitemstring(ll_loop, "status")
	
	ll_found = dw_1.find("status_desc = '" + ls_status + "'", 1, dw_1.rowcount())
	if ll_found <= 0 then
		if ls_error <> "" then ls_error += ", "
		ls_error += "'" + ls_status + "'"
	end if
next

destroy lds_claims

if ls_error = "" then
	return c#return.success
else
	messagebox("Information", "Status " + ls_error + " has been used. It cannot be modified or deleted.")
	return c#return.failure
end if

end function

on w_claim_status.create
call super::create
end on

on w_claim_status.destroy
call super::destroy
end on

event open;call super::open;string	ls_mandatory_column[]

ls_mandatory_column = {"status_desc", "status_sort"}

wf_format_datawindow(dw_1, ls_mandatory_column)

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_claim_status
end type

type cb_cancel from w_system_base`cb_cancel within w_claim_status
integer x = 1175
integer y = 1076
end type

type cb_refresh from w_system_base`cb_refresh within w_claim_status
end type

type cb_delete from w_system_base`cb_delete within w_claim_status
integer x = 827
integer y = 1076
end type

type cb_update from w_system_base`cb_update within w_claim_status
integer x = 480
integer y = 1076
end type

event cb_update::clicked;string	ls_errtext

n_service_manager          lnv_svcmgr
n_dw_validation_service    lnv_rules

if dw_1.accepttext() = -1 then return

//Check empty value and check if the Claim Status is unique
lnv_svcmgr.of_loadservice(lnv_rules, "n_dw_validation_service")
lnv_rules.of_registerrulestring("status_desc", true, "Description", true)
lnv_rules.of_registerrulenumber("status_sort", true, "Sort")

if lnv_rules.of_validate(dw_1, true) = c#return.Failure then return

if wf_validate() = c#return.failure then return

if dw_1.update() = 1 then
	COMMIT;
	if isvalid(w_actions_transactions) then
		w_actions_transactions.dw_transaction_action_header.event ue_refreshclaimstatuslist()
	end if
else
	ls_errtext = sqlca.sqlerrtext
	ROLLBACK;
	messagebox("Error", ls_errtext, stopsign!)
end if

end event

type cb_new from w_system_base`cb_new within w_claim_status
integer x = 133
integer y = 1076
end type

type dw_1 from w_system_base`dw_1 within w_claim_status
integer width = 1481
integer height = 1028
string dataobject = "d_sq_gr_claim_status"
end type

