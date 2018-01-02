$PBExportHeader$w_adjustment_reason.srw
forward
global type w_adjustment_reason from w_system_base
end type
type dw_2 from u_datagrid within w_adjustment_reason
end type
type cb_new_s from mt_u_commandbutton within w_adjustment_reason
end type
type cb_update_s from mt_u_commandbutton within w_adjustment_reason
end type
type cb_delete_s from mt_u_commandbutton within w_adjustment_reason
end type
type cb_cancel_s from mt_u_commandbutton within w_adjustment_reason
end type
type gb_type from mt_u_groupbox within w_adjustment_reason
end type
type gb_subtype from mt_u_groupbox within w_adjustment_reason
end type
end forward

global type w_adjustment_reason from w_system_base
integer width = 1673
integer height = 2052
string title = "Transaction Adjustment Reasons"
dw_2 dw_2
cb_new_s cb_new_s
cb_update_s cb_update_s
cb_delete_s cb_delete_s
cb_cancel_s cb_cancel_s
gb_type gb_type
gb_subtype gb_subtype
end type
global w_adjustment_reason w_adjustment_reason

type variables

end variables

forward prototypes
public subroutine documentation ()
public function integer wf_assignidentity ()
public function integer wf_statuschanged ()
protected function integer wf_checkdependency ()
protected function integer wf_checkdependency2 ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_adjustment_reason
   <OBJECT>	Maintain Claim Adjustment Reason </OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date            CR-Ref        Author        Comments
      06/09/14        CR3700        SSX014        Initial version
		10/15/14        CR3810        SSX014        Check dependence
   </HISTORY>
********************************************************************/


end subroutine

public function integer wf_assignidentity ();/**********************************************************************
   wf_AssignIdentity
   <DESC>	Assign identity numbers for all new rows for dw_2	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	None
   </ARGS>
   <USAGE>	This function is called when clicking Update button	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		02/07/14 CR3700        SSX014   First Version
   </HISTORY>
**********************************************************************/

long ll_return
n_get_maxvalue lnv_get_maxvalue

lnv_get_maxvalue = create n_get_maxvalue
ll_return = lnv_get_maxvalue.of_AssignIdentity(dw_2, "subtype_id", "CLAIM_ADJ_SUBTYPES")
destroy lnv_get_maxvalue

if ll_return = c#return.Failure then
	ROLLBACK;
	_addmessage(this.classdefinition, "Error", "Cannot get the maximum identity number.", "", true)
end if

return ll_return

end function

public function integer wf_statuschanged ();boolean lb_mastermodified
boolean lb_detailmodified
long ll_masterrow
long ll_detailrow

lb_mastermodified = (dw_1.ModifiedCount() + dw_1.DeletedCount()) > 0
lb_detailmodified = (dw_2.ModifiedCount() + dw_2.DeletedCount()) > 0

cb_update.Enabled = lb_mastermodified and not lb_detailmodified
cb_update_s.Enabled = not lb_mastermodified and lb_detailmodified

ll_masterrow = dw_1.getrow()
ll_detailrow = dw_2.getrow()

cb_delete.Enabled = not lb_detailmodified and (ll_masterrow > 0)
cb_delete_s.Enabled = not lb_mastermodified and (ll_detailrow > 0)

cb_cancel.Enabled = lb_mastermodified
cb_cancel_s.Enabled = lb_detailmodified

cb_new.Enabled = not lb_detailmodified
cb_new_s.Enabled = not lb_mastermodified and (ll_masterrow > 0)

return 1
end function

protected function integer wf_checkdependency ();/********************************************************************
   wf_checkdependency
   <DESC>	Check dependency	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	wf_checkdependency()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/07/14 CR3700        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_id
long ll_sent_nr
string ls_type_desc, ls_types
long ll_row
long ll_cnt, ll_notupdateable

ll_cnt = dw_1.rowcount()
ls_types = ""
ll_notupdateable = 0
for ll_row = 1 to ll_cnt
	if dw_1.getitemstatus(ll_row, "type_desc", primary!) = DataModified! then
		ll_id = dw_1.getitemnumber(ll_row,"type_id")
		
		setnull(ll_sent_nr)
		SELECT TOP 1 SENT_NR 
		INTO :ll_sent_nr
		FROM CLAIM_SENT
		WHERE ADJ_TYPE_ID = :ll_id;		
		
		if not isnull(ll_sent_nr) and not isnull(ll_id) then
			ls_type_desc = dw_1.getitemstring(ll_row,"type_desc")
			if ls_types = "" then
				ls_types = ls_type_desc
			else
				ls_types = ls_types + "~r~n" + ls_type_desc
			end if
			ll_notupdateable ++
		end if
	end if
next

if ll_notupdateable > 0 then
	messagebox("Information", "The following description(s) of Reason Types cannot be modified because they have been used.~r~n"+ls_types)	
else
	return c#return.Success
end if

return c#return.Failure

end function

protected function integer wf_checkdependency2 ();/********************************************************************
   wf_checkdependency2
   <DESC>	Check dependency	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	wf_checkdependency2()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/07/14 CR3700        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_id, ll_subid
long ll_sent_nr
string ls_type_desc, ls_types
long ll_row
long ll_cnt, ll_notupdateable

ll_cnt = dw_2.rowcount()
ls_types = ""
ll_notupdateable = 0
for ll_row = 1 to ll_cnt
	if dw_2.getitemstatus(ll_row, "subtype_desc", primary!) = DataModified! then
		ll_id = dw_2.getitemnumber(ll_row,"type_id")
		ll_subid = dw_2.getitemnumber(ll_row,"subtype_id")
		
		setnull(ll_sent_nr)
		SELECT TOP 1 SENT_NR 
		INTO :ll_sent_nr
		FROM CLAIM_SENT
		WHERE ADJ_TYPE_ID = :ll_id
			AND ADJ_SUBTYPE_ID = :ll_subid;
		
		if not isnull(ll_sent_nr) and not isnull(ll_id) and not isnull(ll_subid) then
			ls_type_desc = dw_2.getitemstring(ll_row,"subtype_desc")
			if ls_types = "" then
				ls_types = ls_type_desc
			else
				ls_types = ls_types + "~r~n" + ls_type_desc
			end if
			ll_notupdateable ++
		end if
	end if
next

if ll_notupdateable > 0 then
	messagebox("Information", "The following description(s) of Reason Sub-Types cannot be modified because they have been used.~r~n"+ls_types)	
else
	return c#return.Success
end if

return c#return.Failure

end function

on w_adjustment_reason.create
int iCurrent
call super::create
this.dw_2=create dw_2
this.cb_new_s=create cb_new_s
this.cb_update_s=create cb_update_s
this.cb_delete_s=create cb_delete_s
this.cb_cancel_s=create cb_cancel_s
this.gb_type=create gb_type
this.gb_subtype=create gb_subtype
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_2
this.Control[iCurrent+2]=this.cb_new_s
this.Control[iCurrent+3]=this.cb_update_s
this.Control[iCurrent+4]=this.cb_delete_s
this.Control[iCurrent+5]=this.cb_cancel_s
this.Control[iCurrent+6]=this.gb_type
this.Control[iCurrent+7]=this.gb_subtype
end on

on w_adjustment_reason.destroy
call super::destroy
destroy(this.dw_2)
destroy(this.cb_new_s)
destroy(this.cb_update_s)
destroy(this.cb_delete_s)
destroy(this.cb_cancel_s)
destroy(this.gb_type)
destroy(this.gb_subtype)
end on

event open;call super::open;string ls_mandatory_column[]

s_system_base_parm lnv_duplicate[], lnv_subduplicate[]

ls_mandatory_column = {"type_desc", "type_order"}
wf_format_datawindow(dw_1, ls_mandatory_column)

lnv_duplicate[1].mandatorycol = "type_desc"
lnv_duplicate[1].duplicatecheck = true
lnv_duplicate[1].casesensitive = false
wf_format_datawindow(dw_1, lnv_duplicate)

ls_mandatory_column = {"subtype_desc", "subtype_order"}
wf_format_datawindow(dw_2, ls_mandatory_column)

lnv_subduplicate[1].mandatorycol = "subtype_desc"
lnv_subduplicate[1].duplicatecheck = true
lnv_subduplicate[1].casesensitive = false
wf_format_datawindow(dw_2, lnv_subduplicate)

dw_2.SetTransObject(sqlca)

// Enable and disable buttons
wf_statuschanged()


end event

event closequery;dw_1.accepttext()
if dw_1.modifiedcount()+dw_1.DeletedCount() > 0 then
	if messagebox("Updates Pending", "Reason Type has been changed but not saved. ~n~nWould you like to save it?", Question!, YesNo!, 1) = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if

dw_2.accepttext()
if dw_2.modifiedcount()+dw_2.DeletedCount() > 0 then
	if messagebox("Updates Pending", "Reason Sub-type has been changed but not saved. ~n~nWould you like to save it?", Question!, YesNo!, 1) = 1 then
		if cb_update_s.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if

if isvalid(inv_validation) then
	destroy inv_validation
end if

return 0

end event

event ue_predelete;call super::ue_predelete;long ll_currentrow, ll_row, ll_rows, ll_count=0, ll_type_id

// Check dependence
ll_rows = dw_1.rowcount()
ll_currentrow = dw_1.getrow()
if ll_currentrow <= 0 then return c#return.FAILURE
ll_type_id = dw_1.getitemnumber(ll_currentrow, "type_id")

if not isnull(ll_type_id) then
	SELECT COUNT(*) INTO :ll_count
	  FROM CLAIM_ADJ_SUBTYPES
	 WHERE CLAIM_ADJ_SUBTYPES.TYPE_ID = :ll_type_id;
end if

if ll_count > 0 then
	messagebox("Delete Error", "Please delete all sub-types under this type before deleting.")
	return c#return.FAILURE
end if

return c#return.SUCCESS

end event

event ue_preupdate;call super::ue_preupdate;/********************************************************************
   ue_preupdate
   <DESC>	Set identity	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	None
   </ARGS>
   <USAGE>	this will be called before ue_update	</USAGE>
   <HISTORY>
		Date        CR-Ref        Author   Comments
		02/07/14    CR3700        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_return
n_get_maxvalue lnv_get_maxvalue

if wf_checkdependency() = c#return.Failure then
	return c#return.Failure
end if

lnv_get_maxvalue = create n_get_maxvalue
ll_return = lnv_get_maxvalue.of_AssignIdentity(dw_1, "type_id", "CLAIM_ADJ_TYPES")
destroy lnv_get_maxvalue

if ll_return = c#return.Failure then
	ROLLBACK;
	_addmessage(this.classdefinition, "Error", "Cannot get the maximum identity number.", "", true)
end if

return ll_return

end event

event ue_delete;/********************************************************************
   ue_delete
   <DESC>	Delete the current row	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date		CR-Ref		Author	Comments
      07/11/14 CR3700      SSX014   First Version
   </HISTORY>
	
********************************************************************/

long ll_row
long ll_type_id

ll_row = dw_1.getrow()
if ll_row > 0 then
	if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
		dw_1.deleterow(ll_row)
	else
		if messagebox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!, 2) = 1 then
			ll_type_id = dw_1.getitemnumber(ll_row, "type_id")
			DELETE CLAIM_ADJ_SUBTYPES WHERE TYPE_ID = :ll_type_id;
			DELETE CLAIM_ADJ_TYPES WHERE TYPE_ID = :ll_type_id;
			if SQLCA.SQLCode = 0 then
				dw_1.rowsdiscard(ll_row,ll_row,primary!)
				COMMIT;
			else
				ROLLBACK;
			end if
		else
			return c#return.Failure
		end if
	end if
end if

if ll_row > dw_1.rowcount( ) then
	ll_row = dw_1.rowcount( )
end if
if ll_row > 0 then
	dw_1.scrolltorow(ll_row)
	dw_1.selectrow(ll_row,true)
end if

dw_1.Event rowfocuschanged(dw_1.getrow())

return c#return.Success

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_adjustment_reason
end type

type cb_cancel from w_system_base`cb_cancel within w_adjustment_reason
integer x = 1262
integer y = 752
integer taborder = 50
end type

event cb_cancel::clicked;long ll_row

ll_row = dw_1.getrow()

dw_1.setredraw(false)
dw_2.setredraw(false)
dw_1.retrieve()

if ll_row > 0 and ll_row < dw_1.rowcount() then
	dw_1.setrow(ll_row)
	dw_1.scrolltorow(ll_row)
end if
	
dw_1.setfocus()
dw_1.setredraw(true)
dw_2.setredraw(true)

// Enable and disable buttons
wf_statuschanged()


end event

type cb_refresh from w_system_base`cb_refresh within w_adjustment_reason
integer x = 1883
integer y = 416
integer taborder = 110
end type

type cb_delete from w_system_base`cb_delete within w_adjustment_reason
integer x = 914
integer y = 752
end type

event cb_delete::clicked;call super::clicked;// Enable and disable buttons
wf_statuschanged()

end event

type cb_update from w_system_base`cb_update within w_adjustment_reason
integer x = 567
integer y = 752
end type

event cb_update::clicked;n_dw_column_definition lnv_ruledefinition[], inv_null

inv_servicemgr.of_loadservice(inv_validation, "n_dw_validation_service")

lnv_ruledefinition = inv_validation.inv_ruledefinition

// Exclude sub type column
inv_validation.inv_ruledefinition[4] = inv_null
inv_validation.inv_ruledefinition[5] = inv_null
inv_validation.inv_ruledefinition[6] = inv_null

dw_2.setredraw(false)
call super::clicked
dw_2.setredraw(true)

// Reset column
inv_validation.inv_ruledefinition = lnv_ruledefinition

// Enable and disable buttons
wf_statuschanged()

return ancestorreturnvalue

end event

type cb_new from w_system_base`cb_new within w_adjustment_reason
integer x = 219
integer y = 752
end type

event cb_new::clicked;call super::clicked;string ls_colorder
string ls_maxinum
long ll_max, ll_row

// Assume that the row is added to the end
ll_row = dw_1.RowCount()
if ll_row <= 0 then return

ls_colorder = "type_order"
ls_maxinum = dw_1.describe( "evaluate('max( type_order for all )', 0)" )
if isnumber(ls_maxinum) then
	ll_max = long(ls_maxinum) + 1
else
	ll_max = 1
end if

dw_1.SetItem(ll_row, ls_colorder, ll_max )

// Enable and disable buttons
wf_statuschanged()

end event

type dw_1 from w_system_base`dw_1 within w_adjustment_reason
integer x = 55
integer y = 96
integer width = 1554
integer height = 640
string dragicon = "images\DRAG.ICO"
string dataobject = "d_claim_adj_types"
boolean ib_enablesortindex = true
end type

event dw_1::dragdrop;call super::dragdrop;this.event rowfocuschanged(row)
end event

event dw_1::rowfocuschanging;call super::rowfocuschanging;if currentrow < 1 then return

dw_2.accepttext()
if dw_2.modifiedcount()+dw_2.DeletedCount() > 0 then
	if messagebox("Change Request Updates Pending", "Sub-type data changed but not saved. ~n~nWould you like to save data before switching?", Question!, YesNo!, 1) = 1 then
		if cb_update_s.event clicked() = C#Return.Failure then
			return 1
		end if
	end if
end if

end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;// Retrieve relevant sub-types
if currentrow > 0 then
	dw_2.retrieve(dw_1.getitemnumber(currentrow, "type_id"))
	dw_2.selectrow(0,false)
	dw_2.selectrow(dw_2.getrow(),true)
end if
// Enable and disable buttons
wf_statuschanged()

end event

event dw_1::itemchanged;call super::itemchanged;// Enable and disable buttons
post wf_statuschanged()
end event

type dw_2 from u_datagrid within w_adjustment_reason
integer x = 55
integer y = 976
integer width = 1554
integer height = 832
integer taborder = 60
string dragicon = "images\DRAG.ICO"
boolean bringtotop = true
string dataobject = "d_claim_adj_subtypes"
boolean vscrollbar = true
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
boolean ib_enablesortindex = true
end type

event itemchanged;call super::itemchanged;// Enable and disable buttons
post wf_statuschanged()

end event

event rowfocuschanged;call super::rowfocuschanged;// Highlight the current row
this.selectrow(0,false)
this.selectrow(currentrow, true)
// Enable and disable buttons
wf_statuschanged()

end event

type cb_new_s from mt_u_commandbutton within w_adjustment_reason
integer x = 219
integer y = 1824
integer taborder = 70
boolean bringtotop = true
string text = "N&ew"
end type

event clicked;string ls_colorder
string ls_maxinum
long ll_max
long ll_row, ll_currentrow

ll_row = dw_2.insertrow(0)
if ll_row < 1 then return

ll_currentrow = dw_1.getrow()
if ll_currentrow <= 0 then return

dw_2.setitem(ll_row, "type_id", dw_1.getitemnumber(ll_currentrow, "type_id"))
dw_2.scrolltorow(ll_row)
dw_2.post setfocus()

ls_colorder = "subtype_order"
ls_maxinum = dw_2.describe( "evaluate('max( subtype_order for all )', 0)" )
if isnumber(ls_maxinum) then
	ll_max = long(ls_maxinum) + 1
else
	ll_max = 1
end if

dw_2.SetItem(ll_row, ls_colorder, ll_max )

// Enable and disable buttons
wf_statuschanged()

end event

type cb_update_s from mt_u_commandbutton within w_adjustment_reason
integer x = 567
integer y = 1824
integer taborder = 80
boolean bringtotop = true
string text = "U&pdate"
end type

event clicked;n_error_service 		lnv_error
n_service_manager 	lnv_SrvMgr
n_dw_column_definition lnv_ruledefinition[], inv_null
long ll_ret, ll_errorrow
integer li_errorcolumn
string  ls_message

inv_servicemgr.of_loadservice(inv_validation, "n_dw_validation_service")

lnv_ruledefinition = inv_validation.inv_ruledefinition

// Exclude main type column
inv_validation.inv_ruledefinition[1] = inv_null
inv_validation.inv_ruledefinition[2] = inv_null
inv_validation.inv_ruledefinition[3] = inv_null

dw_2.accepttext()
ll_ret = inv_validation.of_validate(dw_2, ls_message, ll_errorrow, li_errorcolumn)

// Reset column
inv_validation.inv_ruledefinition = lnv_ruledefinition

if ll_ret = C#Return.Failure then
	dw_2.setfocus()
	dw_2.setrow(ll_errorrow)
	dw_2.setcolumn(li_errorcolumn)
	messagebox("Update Error", ls_message)	
	return C#Return.Failure
end if

if wf_checkdependency2() = c#return.Failure then
	return c#return.Failure
end if

if wf_AssignIdentity() <> c#return.SUCCESS then
	return C#Return.Failure
end if

if dw_2.update() = 1 then
	COMMIT;
	ll_ret = C#Return.Success
else
	ROLLBACK;
	lnv_SrvMgr.of_loadservice( lnv_error, "n_error_service")
	lnv_error.of_ShowMessages()
	ll_ret = C#Return.Failure
end if

// Enable and disable buttons
wf_statuschanged()

return ll_ret
end event

type cb_delete_s from mt_u_commandbutton within w_adjustment_reason
integer x = 914
integer y = 1824
integer taborder = 90
boolean bringtotop = true
string text = "De&lete"
end type

event clicked;/********************************************************************
   clicked
   <DESC>	Description	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		15/10/14 CR3810        Shawn    Check dependence
   </HISTORY>
********************************************************************/

long ll_currentrow, ll_row, ll_count=0, ll_subtype_id, ll_type_id
string ls_subtype_desc

ll_currentrow = dw_2.getrow()
// Make sure that the current row exists
if ll_currentrow <= 0 then return

// Check dependence
ll_type_id = dw_2.getitemnumber(ll_currentrow, "type_id")
ll_subtype_id = dw_2.getitemnumber(ll_currentrow, "subtype_id")
ls_subtype_desc = dw_2.getitemstring(ll_currentrow, "subtype_desc")
if not isnull(ll_subtype_id) and not isnull(ll_type_id) then
	SELECT COUNT(*) INTO :ll_count
	FROM CLAIM_SENT
	WHERE ADJ_TYPE_ID = :ll_type_id
		AND ADJ_SUBTYPE_ID=:ll_subtype_id;
	if ll_count <= 0 then
		SELECT COUNT(*) INTO :ll_count
		FROM FREIGHT_RECEIVED
		WHERE TRANS_REASON_SUBTYPE = :ls_subtype_desc
			AND TRANS_CODE = 'A';
		if ll_count <= 0 then
			SELECT COUNT(*) INTO :ll_count
			FROM CLAIM_TRANSACTION
			WHERE TRANS_REASON_SUBTYPE = :ls_subtype_desc
				AND C_TRANS_CODE = 'A';
		end if
	end if
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the selected adjustment sub-type, because it has been used.")
		return
	end if
end if

if MessageBox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!,2) = 1 then
	// Delete the current row
	DELETE CLAIM_ADJ_SUBTYPES
	WHERE TYPE_ID = :ll_type_id
		AND SUBTYPE_ID = :ll_subtype_id;
	if SQLCA.SQLCode = 0 then
		COMMIT;
		dw_2.rowsdiscard(ll_currentrow, ll_currentrow, primary!)
	else
		ROLLBACK;
	end if
	
	// Reselect the current row
	dw_2.selectrow(0,false)
	dw_2.selectrow(dw_2.getrow(),true)
	
	// Enable and disable buttons
	wf_statuschanged()
end if


end event

type cb_cancel_s from mt_u_commandbutton within w_adjustment_reason
integer x = 1262
integer y = 1824
integer taborder = 100
boolean bringtotop = true
string text = "Cancel"
end type

event clicked;long ll_row

ll_row = dw_2.getselectedrow(0)

dw_1.Event rowfocuschanged(dw_1.getrow())

if ll_row > 0 and ll_row <= dw_2.rowcount() then
	dw_2.setrow(ll_row)
	dw_2.scrolltorow(ll_row)
end if
	
dw_2.setfocus()

// Enable and disable buttons
wf_statuschanged()

end event

type gb_type from mt_u_groupbox within w_adjustment_reason
integer x = 18
integer y = 16
integer width = 1627
integer height = 864
integer taborder = 10
integer weight = 400
string facename = "Tahoma"
string text = "Reason Types"
end type

type gb_subtype from mt_u_groupbox within w_adjustment_reason
integer x = 18
integer y = 896
integer width = 1627
integer height = 1056
integer taborder = 60
integer weight = 400
string facename = "Tahoma"
string text = "Reason Sub-Types"
end type

