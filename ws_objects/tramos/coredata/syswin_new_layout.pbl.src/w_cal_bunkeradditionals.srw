$PBExportHeader$w_cal_bunkeradditionals.srw
forward
global type w_cal_bunkeradditionals from w_system_base
end type
end forward

global type w_cal_bunkeradditionals from w_system_base
integer width = 1609
integer height = 1220
string title = "Calculation Bunker Additionals"
boolean ib_update_after_del = true
end type
global w_cal_bunkeradditionals w_cal_bunkeradditionals

forward prototypes
private subroutine _set_permission ()
public subroutine documentation ()
public function integer wf_validate (u_datagrid adw_master, n_dw_validation_service anv_validation)
public function integer wf_check_bunkeradditionals (string ls_description)
end prototypes

private subroutine _set_permission ();/********************************************************************
   _set_permission
   <DESC>Access control for this window.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		02/06/16		CR4216		XSZ004		First Version	      
   </HISTORY>
********************************************************************/
	
dw_1.modify("datawindow.readonly = 'yes'")

cb_new.enabled    = false
cb_delete.enabled = false
cb_update.enabled = false
cb_cancel.enabled = false
	
if (uo_global.ii_access_level = c#usergroup.#SUPERUSER or uo_global.ii_access_level = c#usergroup.#ADMINiSTRATOR) and uo_global.ii_user_profile = 2 then
	dw_1.modify("datawindow.readonly = 'no'")
	cb_new.enabled    = true
	cb_delete.enabled = true
	cb_cancel.enabled = true
end if
		

		

end subroutine

public subroutine documentation ();/********************************************************************
   w_cal_bunkeradditionals
   <OBJECT>	Maintain config bunker additional </OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
		Date    			CR-Ref		Author		Comments
		21/06/16			CR4216		XSZ004		First Version
   </HISTORY>
********************************************************************/
end subroutine

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
		Date    		CR-Ref		Author		Comments
		21/06/16		CR4216		XSZ004		First version
   </HISTORY>
********************************************************************/

long    ll_errorrow, ll_row, ll_rowcount, ll_usecount, ll_findrow
integer li_ret, li_order
string  ls_message, ls_desc_new, ls_desc_old, ls_errorcolumn
boolean lb_newmodified

ll_rowcount = dw_1.rowcount()

for ll_row = 1 to ll_rowcount
	
	if dw_1.getitemstatus(ll_row, 0, primary!) = notmodified! or dw_1.getitemstatus(ll_row, 0, primary!) = new! then continue
	
	if dw_1.getitemstatus(ll_row, 0, primary!) = newmodified! then
		lb_newmodified = true
	else
		lb_newmodified = false
	end if
	
	ls_desc_old = dw_1.getitemstring(ll_row, "cal_description", primary!, true)
	ls_desc_new = dw_1.getitemstring(ll_row, "cal_description")
	li_order    = dw_1.getitemnumber(ll_row, "cal_order")
	
	if isnull(ls_desc_new) or trim(ls_desc_new) = "" then
			li_ret      = c#return.failure
			ll_errorrow = ll_row
			ls_message  = "The data inside Description cannot be empty. Please amend before updating."
			ls_errorcolumn = "cal_description"
			exit
	end if
	
	ll_findrow = dw_1.find("lower(cal_description) = '" + lower(ls_desc_new) + "' and getrow() <> " + string(ll_row), 1, ll_rowcount + 1)
	
	if ll_findrow < 1 then
		if lower(ls_desc_new) <> lower(ls_desc_old) or lb_newmodified then
			select count(CAL_DESCRIPTION) into :ll_findrow 
			  from CAL_BUNKERADDITIONALS 
			 where lower(CAL_DESCRIPTION) = lower(:ls_desc_new); 
		end if	 
	end if
	
	if ll_findrow > 0 then
		li_ret      = c#return.failure
		ll_errorrow = ll_row
		ls_message  = "The data inside Description cannot be duplicated. Please amend before updating."
		ls_errorcolumn = "cal_description"
		exit
	end if
	
	if ls_desc_new <> ls_desc_old then
			
			if wf_check_bunkeradditionals(ls_desc_old) = c#return.failure then
				li_ret      = c#return.failure
				ll_errorrow = ll_row
				ls_message  = "You cannot update the Description, because it has been used."
				ls_errorcolumn = "cal_description"
				exit
			end if
	end if
	
	if isnull(li_order) or li_order = 0 then
			li_ret      = c#return.failure
			ll_errorrow = ll_row
			ls_message  = "The data inside Order cannot be empty. Please amend before updating."
			ls_errorcolumn = "cal_order"
			exit
	end if
next

if li_ret = c#return.failure then
		adw_master.setfocus()
		adw_master.setrow(ll_errorrow)
		adw_master.setcolumn(ls_errorcolumn)
		messagebox("Update Error", ls_message, stopsign!)	
end if

return li_ret
end function

public function integer wf_check_bunkeradditionals (string ls_description);/********************************************************************
   wf_check_bunkeradditionals
   <DESC>	Datawindow validation	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ls_description
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/06/16		CR4216		XSZ004		First version
   </HISTORY>
********************************************************************/

long ll_usedcount
int  li_ret

SELECT COUNT(1) INTO :ll_usedcount
  FROM CAL_ADDBUNCONS
 WHERE lower(CAL_DESCRIPTION) = lower(:ls_description)
   AND ( ISNULL(HSFO_VALUE, 0) <> 0
	 OR	ISNULL(HSGO_VALUE, 0) <> 0
	 OR	ISNULL(LSGO_VALUE, 0) <> 0 
	 OR	ISNULL(LSFO_VALUE, 0) <> 0 );

if ll_usedcount > 0 then
	li_ret = c#return.failure
else
	li_ret = c#return.success
end if

return li_ret
end function

on w_cal_bunkeradditionals.create
call super::create
end on

on w_cal_bunkeradditionals.destroy
call super::destroy
end on

event closequery;int li_ret

ib_showmessage = false
dw_1.accepttext()

if dw_1.modifiedcount() + dw_1.deletedcount() > 0 then
	
	li_ret = messagebox("Data not saved", "You have modified Calculation Bunker Additionals.~r~n~nWould you like to save before continuing?", Exclamation!, YesNoCancel!, 1)
	
	if li_ret = 1 then
		if cb_update.event clicked() = C#Return.Failure then
			li_ret = c#return.PreventAction
		else
			li_ret = c#return.ContinueAction
		end if
		
	elseif li_ret = 2 then
		li_ret = c#return.ContinueAction
	elseif li_ret = 3 then
		li_ret = c#return.PreventAction
	end if
end if

if li_ret = c#return.ContinueAction then
	if isvalid(inv_validation) then
		destroy inv_validation
	end if
end if

return li_ret
end event

event ue_preopen;call super::ue_preopen;dw_1.setrowfocusindicator(FocusRect!)

 _set_permission()
 
end event

event ue_predelete;call super::ue_predelete;string ls_description
long   ll_row, ll_usedcount
int    li_ret

dw_1.accepttext()
ll_row = dw_1.getselectedrow(0)

li_ret = c#return.success

if ll_row > 0 then
	
	ls_description = dw_1.getitemstring(ll_row, "cal_description", primary!, true)
	 
	 if wf_check_bunkeradditionals(ls_description) = c#return.failure then
		messagebox("Delete Error", "You cannot delete the activity, because it has been used.", StopSign!)
		li_ret = c#return.failure
		dw_1.setfocus()
	end if
end if

return li_ret
end event

event ue_postupdate;call super::ue_postupdate;/********************************************************************
   ue_postupdate
   <DESC>Perform Post Update process. </DESC>
   <RETURN>	integer:
            <LI> c#return.Success,  ok
            <LI> c#return.Failure,  failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	 </USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
   	21/06/16		CR4216		XSZ004		First version
   </HISTORY>
********************************************************************/

long ll_row

dw_1.setredraw(false)

for ll_row = dw_1.rowcount() to 1 step -1
	if dw_1.getitemstatus(ll_row, 0, primary!) = new! then
		dw_1.rowsdiscard( ll_row, ll_row, primary!)
	end if
next

dw_1.setredraw(true)

cb_update.enabled = false

return C#Return.Success
end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_cal_bunkeradditionals
end type

type cb_cancel from w_system_base`cb_cancel within w_cal_bunkeradditionals
integer x = 1216
integer y = 1016
integer taborder = 60
end type

type cb_refresh from w_system_base`cb_refresh within w_cal_bunkeradditionals
integer taborder = 70
end type

type cb_delete from w_system_base`cb_delete within w_cal_bunkeradditionals
integer x = 869
integer y = 1016
integer taborder = 50
end type

type cb_update from w_system_base`cb_update within w_cal_bunkeradditionals
integer x = 521
integer y = 1016
integer taborder = 40
boolean default = false
end type

type cb_new from w_system_base`cb_new within w_cal_bunkeradditionals
integer x = 174
integer y = 1016
integer taborder = 30
end type

event cb_new::clicked;call super::clicked;dw_1.setitem(dw_1.getrow(), "cal_active", 1)
dw_1.setitemstatus(dw_1.getrow(), 0, primary!, notmodified!)
cb_update.enabled = true

end event

type dw_1 from w_system_base`dw_1 within w_cal_bunkeradditionals
integer width = 1518
integer height = 968
integer taborder = 20
string dataobject = "d_sq_gr_calbunkeradditionals"
boolean hscrollbar = true
boolean ib_columntitlesort = true
boolean ib_multicolumnsort = false
boolean ib_setselectrow = true
end type

event dw_1::itemfocuschanged;call super::itemfocuschanged;if dwo.name = "cal_order" then
	this.selecttext(1, 5)
end if
end event

event dw_1::editchanged;call super::editchanged;cb_update.enabled = true
end event

event dw_1::itemchanged;call super::itemchanged;cb_update.Enabled = true
end event

type uo_search from w_syswin_master`uo_search within w_cal_bunkeradditionals
end type

type st_background from w_syswin_master`st_background within w_cal_bunkeradditionals
boolean visible = false
integer height = 92
end type

