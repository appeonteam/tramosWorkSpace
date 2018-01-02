$PBExportHeader$w_writeoff.srw
forward
global type w_writeoff from w_system_base
end type
end forward

global type w_writeoff from w_system_base
string title = "Transaction Write-Off Reasons"
boolean ib_update_after_del = true
end type
global w_writeoff w_writeoff

forward prototypes
public subroutine documentation ()
public function integer wf_checkdependency (integer ai_action)
public function boolean wf_isreferenced (string as_description)
public function integer wf_statuschanged ()
end prototypes

public subroutine documentation ();/***************************************************
   w_writeoff
   <OBJECT>window</OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref      Author     Comments
   	09/06/14   CR3348      SSX014     Initial version
   </HISTORY>
****************************************************/

end subroutine

public function integer wf_checkdependency (integer ai_action);/********************************************************************
   wf_checkdependency
   <DESC>	Check dependency	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	   ai_action: integer, 0 - delete, 1 - update
   </ARGS>
   <USAGE>	wf_checkdependency()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/07/14 CR3348        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_seq
string ls_orig, ls_new
long ll_row, ll_cnt
string ls_reasons
long ll_notupdateable
DWItemStatus le_itemstatus

if ai_action = 0 then
	ll_row = dw_1.getrow()
	if ll_row <= 0 then return c#return.Failure
	le_itemstatus = dw_1.getitemstatus(ll_row, "reason_desc", primary!)
	if le_itemstatus = DataModified! or le_itemstatus = NotModified! then
		ls_orig = dw_1.getitemstring(ll_row,"reason_desc",primary!,true)
		if not isnull(ls_orig) then
			if wf_isreferenced(ls_orig) then
				messagebox("Delete Error", "You cannot delete the selected reason, because it has been used.")
				return c#return.Failure
			end if
		end if
	end if
else
	ll_cnt = dw_1.rowcount()
	ls_reasons = ""
	ll_notupdateable = 0
	for ll_row = 1 to ll_cnt
		
		if dw_1.getitemstatus(ll_row, "reason_desc", primary!) = DataModified! then
			ls_orig = dw_1.getitemstring(ll_row,"reason_desc",primary!,true)
			ls_new = dw_1.getitemstring(ll_row,"reason_desc")
			
			if not isnull(ls_orig) then
				if ls_orig <> ls_new and wf_isreferenced(ls_orig) then
					if ls_reasons = "" then
						ls_reasons = ls_new
					else
						ls_reasons = ls_reasons + "~r~n" + ls_new
					end if
					ll_notupdateable ++
				end if
			end if
		end if
	next
	
	if ll_notupdateable > 0 then
		messagebox("Information", "The following description(s) of Write-Off Reasons cannot be modified, because they have been used.~r~n"+ls_reasons)	
		return c#return.Failure
	end if
end if

return c#return.Success
end function

public function boolean wf_isreferenced (string as_description);/********************************************************************
   wf_isreferenced
   <DESC>	Description	</DESC>
   <RETURN>	boolean:
            <LI> true, the description has been used in the other tables
            <LI> false, the description has not been used in the other tables	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_description
   </ARGS>
   <USAGE>	wf_isreferenced	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		21/07/14 CR3348        Shawn    First Version
   </HISTORY>
********************************************************************/
long ll_seq

setnull(ll_seq)

SELECT TOP 1 FREIGHT_SEQ
INTO :ll_seq
FROM FREIGHT_RECEIVED
WHERE TRANS_CODE = 'W'
	 AND FREIGHT_RECEIVED.FREIGHT_COMMENTS = :as_description;

if isnull(ll_seq) then
	SELECT TOP 1 C_TRANS_SEQ
	INTO :ll_seq
	FROM CLAIM_TRANSACTION 
	WHERE C_TRANS_CODE = 'W'
		 AND CLAIM_TRANSACTION.C_TRANS_COMMENT = :as_description;
end if

return not isnull(ll_seq)
end function

public function integer wf_statuschanged ();boolean lb_modified
boolean lb_hasrow

lb_modified = (dw_1.deletedcount() > 0 or dw_1.modifiedcount() > 0)
lb_hasrow = (dw_1.getrow() > 0)

cb_new.enabled = true
cb_update.enabled = lb_modified
cb_delete.enabled = lb_hasrow
cb_cancel.enabled = lb_modified

return 1
end function

on w_writeoff.create
call super::create
end on

on w_writeoff.destroy
call super::destroy
end on

event open;call super::open;string	ls_mandatory_column[]
s_system_base_parm lnv_duplicate[]

ls_mandatory_column = {"reason_desc", "reason_order"}
lnv_duplicate[1].mandatorycol = "reason_desc"
lnv_duplicate[1].duplicatecheck = true
lnv_duplicate[1].casesensitive = false

wf_format_datawindow(dw_1, ls_mandatory_column)
wf_format_datawindow(dw_1, lnv_duplicate)

wf_statuschanged()

end event

event ue_preupdate;call super::ue_preupdate;/********************************************************************
   ue_preupdate
   <DESC>	Assign identity numbers for all new rows	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	This function is called when clicking Update button	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/07/14 CR3348        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_return
n_get_maxvalue lnv_get_maxvalue

if wf_checkdependency(1) = c#return.Failure then
	return c#return.Failure
end if

lnv_get_maxvalue = create n_get_maxvalue
ll_return = lnv_get_maxvalue.of_AssignIdentity(dw_1, "reason_id", "TRANS_REASONS")
destroy lnv_get_maxvalue

return ll_return


end event

event ue_predelete;call super::ue_predelete;return wf_checkdependency(0)

end event

event ue_update;call super::ue_update;wf_statuschanged()
return AncestorReturnValue
end event

type cb_cancel from w_system_base`cb_cancel within w_writeoff
end type

event cb_cancel::clicked;call super::clicked;wf_statuschanged()
end event

type cb_refresh from w_system_base`cb_refresh within w_writeoff
end type

type cb_delete from w_system_base`cb_delete within w_writeoff
end type

type cb_update from w_system_base`cb_update within w_writeoff
end type

type cb_new from w_system_base`cb_new within w_writeoff
end type

event cb_new::clicked;call super::clicked;string ls_colorder
string ls_maxinum
long ll_max, ll_row

// Assume that the row is added to the end
ll_row = dw_1.RowCount()
if ll_row <= 0 then return

ls_colorder = "reason_order"
ls_maxinum = dw_1.describe( "evaluate('max( reason_order for all )', 0)" )
if isnumber(ls_maxinum) then
	ll_max = long(ls_maxinum) + 1
else
	ll_max = 1
end if

dw_1.SetItem(ll_row, ls_colorder, ll_max )

wf_statuschanged()
end event

type dw_1 from w_system_base`dw_1 within w_writeoff
string dataobject = "d_trans_writeoff"
end type

event dw_1::itemchanged;call super::itemchanged;Post wf_statuschanged()
end event

