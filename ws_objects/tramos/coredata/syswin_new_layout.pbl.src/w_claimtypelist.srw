$PBExportHeader$w_claimtypelist.srw
forward
global type w_claimtypelist from w_syswin_master
end type
end forward

global type w_claimtypelist from w_syswin_master
integer width = 4608
integer height = 2568
string title = "Claim Types"
end type
global w_claimtypelist w_claimtypelist

forward prototypes
public subroutine documentation ()
public function integer wf_claimtype_used (string as_claimtype)
public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation)
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>		</DESC>
   <RETURN>(none)</RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref	Author             Comments
   	06/06/14	CR3427	CCY018			First Version
	28/08/14	CR3781	CCY018			The window title match with the text of a menu item
	14/09/16 CR4226   SSX014         Added Activate, Primary, Bunker, Time and Lumpsum columns
   </HISTORY>
********************************************************************/
end subroutine

public function integer wf_claimtype_used (string as_claimtype);/********************************************************************
   wf_claimtype_used
   <DESC>  </DESC>
   <RETURN> integer </RETURN>
   <ACCESS> public</ACCESS>
   <ARGS> string </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref	Author             Comments
	10/07/2016 		CR4362 		HHX010		First Version
   </HISTORY>
********************************************************************/
long ll_count

select count(1) into :ll_count 
from CLAIMS
where CLAIM_TYPE = :as_claimtype;

if ll_count > 0 then
	return c#return.Failure
else
	select count(1) into :ll_count 
	from CAL_CLMI
	where CLAIM_TYPE = :as_claimtype;
	if ll_count > 0 then
		return c#return.Failure
	end if
end if

return c#return.Success
end function

public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation);/********************************************************************
   wf_validate
   <DESC>	Datawindow validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_master
		anv_validation
   </ARGS>
   <USAGE> ref: cb_updadte.event clicked()	</USAGE>
   <HISTORY>
		Date     CR-Ref   Author   Comments
		30/05/14	CR3427   LHG008   First Version
		10/07/16		CR4362		HHX010	The messagebox should use the StopSign Icon
		07/09/16    CR4226      SSX014
   </HISTORY>
********************************************************************/

long ll_return, ll_errorrow
integer li_errorcolumn
string  ls_message
long ll_row, ll_rowCount
long ll_bunker, ll_time, ll_lumpsum
string ls_claim_type
n_messagebox lnv_msgbox

if isvalid(anv_validation) then
	ll_return = anv_validation.of_validate(adw_master, ls_message, ll_errorrow, li_errorcolumn)
	if ll_return = C#Return.Failure then
		adw_master.setfocus()
		adw_master.setrow(ll_errorrow)
		adw_master.setcolumn(li_errorcolumn)
		if adw_master.getcolumnname() = 'expect_receive_pct' then
			messagebox("Update Error", "You can only enter an expected receive % from 0-100.", StopSign!)
		else
			messagebox("Update Error", ls_message, StopSign!)	
		end if
		return C#Return.Failure
	end if
end if

// make sure at least one of Bunker, Time and Lumpsum is selected
ll_rowCount = adw_master.RowCount()
for ll_row = 1 to ll_rowCount
	ll_bunker = adw_master.GetItemNumber(ll_row, "bunker")
	ll_time = adw_master.GetItemNumber(ll_row, "ctime")
	ll_lumpsum = adw_master.GetItemNumber(ll_row, "lumpsum")
	ls_claim_type = adw_master.GetItemString(ll_row, "claim_type")
	if not (ls_claim_type = 'FRT' or ls_claim_type = 'DEM') then
		if not (ll_bunker = 1 or ll_time = 1 or ll_lumpsum = 1) then
			lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
				"You must select Bunker, Time or Lumpsum.", this)
			adw_master.setfocus()
			adw_master.setrow(ll_row)
			adw_master.selectrow(0, false)
			adw_master.selectrow(ll_row, true)
			return C#Return.Failure
		end if
	end if
next

return c#return.Success
end function

on w_claimtypelist.create
int iCurrent
call super::create
end on

on w_claimtypelist.destroy
call super::destroy
end on

event open;call super::open;s_system_base_parm lstr_parm[]

This.Move(0, 0)

lstr_parm[1].mandatorycol = "claim_type"
lstr_parm[1].duplicatecheck = true
lstr_parm[2].mandatorycol = "claim_desc"
lstr_parm[3].mandatorycol = "nom_acc_nr"
wf_format_datawindow(dw_1, lstr_parm)

//// Initialize search box
uo_search.of_initialize(dw_1, "claim_type+'~'+claim_desc")
uo_search.sle_search.POST setfocus()

// Set access
If uo_global.ii_access_level < 3 and uo_global.ii_user_profile < 3 then
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_update.Enabled = False
	cb_Cancel.Enabled = False
	dw_1.object.datawindow.readonly = "Yes"
elseif uo_global.ii_access_level > c#usergroup.#USER then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.RowCount() > 0)
else
	dw_1.object.datawindow.readonly = "Yes"
End if
end event

event ue_preupdate;call super::ue_preupdate;long ll_count, ll_rowcount, ll_i
integer li_ret
string ls_claimtype, ls_claimtype_org
pointer lp_oldpointer

ll_rowcount = dw_1.rowcount()
if ll_rowcount = 0 then return C#Return.Failure

for ll_i = 1 to ll_rowcount
	if dw_1.getitemstatus(ll_i, 0, primary!) = DataModified! then
		ls_claimtype_org = dw_1.object.claim_type.original[ll_i]
		ls_claimtype = dw_1.object.claim_type[ll_i]
		
		if ls_claimtype_org <> ls_claimtype then
			lp_oldpointer = setpointer(HourGlass!)
			li_ret = wf_claimtype_used(ls_claimtype_org)
			setpointer(lp_oldpointer)
			if li_ret = c#return.Failure then exit
		end if
	end if
next

if li_ret = c#return.Failure then
	messagebox("Update Error", "You cannot update the claim type, because it has been used.", StopSign!)
	return c#return.Failure
end if

return C#Return.Success
end event

event ue_preopen;call super::ue_preopen;inv_validation = CREATE n_dw_validation_service
inv_validation.of_registerruledecimal("expect_receive_pct", false, 0, 100, "Expect Receive")
inv_validation.ib_ignoreinvisiblecolumn = true
end event

event ue_predelete;call super::ue_predelete;long ll_row
integer li_ret
string ls_claimtype
pointer lp_oldpointer

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus(ll_row, 0, primary!) = New! or dw_1.getitemstatus(ll_row, 0, primary!) = NewModified! then
else
	ls_claimtype = dw_1.object.claim_type.original[ll_row]
	
	lp_oldpointer = setpointer(HourGlass!)
	li_ret = wf_claimtype_used(ls_claimtype)
	setpointer(lp_oldpointer)
	
	if li_ret = c#return.Failure then
		messagebox("Delete Error", "You cannot delete the claim type, because it has been used.", StopSign!)
		dw_1.setfocus()
		return c#return.Failure
	end if
end if

return C#Return.Success
end event

event ue_add;call super::ue_add;if dw_1.getrow() > 0 then
	dw_1.setcolumn("claim_type")
end if
return C#Return.Success
end event

event closequery;string ls_msg
integer li_ret
ib_showmessage = false
dw_1.accepttext()
if dw_1.modifiedcount() + dw_1.deletedcount() > 0 then
	ls_msg = "You have modified Claim Types.~r~n~nWould you like to save before continuing?"
	li_ret = messagebox("Data not saved", ls_msg, Exclamation!, YesNoCancel!, 1) 
	if li_ret = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			return 1
		end if
	elseif li_ret = 3 then
		return 1
	end if
end if

if isvalid(inv_validation) then
	destroy inv_validation
end if

return 0
end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_claimtypelist
end type

type cb_cancel from w_syswin_master`cb_cancel within w_claimtypelist
integer x = 4219
integer y = 2376
integer taborder = 60
end type

type cb_refresh from w_syswin_master`cb_refresh within w_claimtypelist
integer taborder = 0
end type

type cb_delete from w_syswin_master`cb_delete within w_claimtypelist
integer x = 3872
integer y = 2376
integer taborder = 50
end type

type cb_update from w_syswin_master`cb_update within w_claimtypelist
integer x = 3525
integer y = 2376
integer taborder = 40
boolean default = false
end type

type cb_new from w_syswin_master`cb_new within w_claimtypelist
integer x = 3177
integer y = 2376
integer taborder = 30
end type

type dw_1 from w_syswin_master`dw_1 within w_claimtypelist
integer width = 4526
integer height = 2120
integer taborder = 20
string dataobject = "d_sq_gr_claimtypelist"
boolean hscrollbar = true
end type

event dw_1::constructor;call super::constructor;//ib_newstandard = true
ib_setselectrow = true
end event

event dw_1::itemfocuschanged;call super::itemfocuschanged;if dwo.name='expect_receive_pct' then
	selecttext(1,15)
end if
end event

event dw_1::itemchanged;call super::itemchanged;string ls_colname
long ll_count = 0
string ls_claim_type
n_messagebox lnv_msgbox
ls_colname = dwo.name

choose case ls_colname
	case "bunker"
		if long(data) = 0 then
			ls_claim_type = this.GetItemString(row, "claim_type")
			
			SELECT COUNT(*) INTO :ll_count
			FROM HEA_DEV_CLAIMS
			INNER JOIN CLAIMS ON HEA_DEV_CLAIMS.VESSEL_NR = CLAIMS.VESSEL_NR
				AND HEA_DEV_CLAIMS.VOYAGE_NR = CLAIMS.VOYAGE_NR
				AND HEA_DEV_CLAIMS.CHART_NR = CLAIMS.CHART_NR
				AND HEA_DEV_CLAIMS.CLAIM_NR = CLAIMS.CLAIM_NR
			WHERE (ISNULL(HEA_DEV_CLAIMS.HFO_TON,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.HFO_PRICE,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.DO_TON,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.DO_PRICE,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.GO_TON,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.GO_PRICE,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.LSHFO_TON,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.LSHFO_PRICE,0) <> 0)
			AND CLAIM_TYPE = :ls_claim_type;
			
			if ll_count > 0 then
				lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
					"You cannot remove the Bunker option, because it has been used in at least one claim.", this)
				return 2
			end if
		end if
	case "ctime"
		if long(data) = 0 then
			ls_claim_type = this.GetItemString(row, "claim_type")
			
			SELECT COUNT(*) INTO :ll_count
			FROM HEA_DEV_CLAIMS
			INNER JOIN CLAIMS ON HEA_DEV_CLAIMS.VESSEL_NR = CLAIMS.VESSEL_NR
				AND HEA_DEV_CLAIMS.VOYAGE_NR = CLAIMS.VOYAGE_NR
				AND HEA_DEV_CLAIMS.CHART_NR = CLAIMS.CHART_NR
				AND HEA_DEV_CLAIMS.CLAIM_NR = CLAIMS.CLAIM_NR
			WHERE (ISNULL(HEA_DEV_CLAIMS.HEA_DEV_HOURS,0) <> 0
				 OR ISNULL(HEA_DEV_CLAIMS.HEA_DEV_PRICE_PR_DAY,0) <> 0)
			AND CLAIMS.CLAIM_TYPE = :ls_claim_type;
			
			if ll_count > 0 then
				lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
					"You cannot remove the Time option, because it has been used in at least one claim.", this)
				return 2
			end if
			
		end if
	case "lumpsum"
		if long(data) = 0 then
			ls_claim_type = this.GetItemString(row, "claim_type")
			
			SELECT COUNT(*) INTO :ll_count
			FROM HEA_DEV_CLAIMS
			INNER JOIN CLAIMS ON HEA_DEV_CLAIMS.VESSEL_NR = CLAIMS.VESSEL_NR
				AND HEA_DEV_CLAIMS.VOYAGE_NR = CLAIMS.VOYAGE_NR
				AND HEA_DEV_CLAIMS.CHART_NR = CLAIMS.CHART_NR
				AND HEA_DEV_CLAIMS.CLAIM_NR = CLAIMS.CLAIM_NR
			WHERE ISNULL(HEA_DEV_CLAIMS.LUMPSUM,0) <> 0
			AND CLAIMS.CLAIM_TYPE = :ls_claim_type;
			
			if ll_count > 0 then
				lnv_msgbox.of_messagebox(lnv_msgbox.is_TYPE_VALIDATION_ERROR, &
					"You cannot remove the Lumpsum option, because it has been used in at least one claim.", this)
				return 2
			end if
			
		end if
end choose


end event

type uo_search from w_syswin_master`uo_search within w_claimtypelist
integer taborder = 10
end type

type st_background from w_syswin_master`st_background within w_claimtypelist
integer width = 4777
end type

