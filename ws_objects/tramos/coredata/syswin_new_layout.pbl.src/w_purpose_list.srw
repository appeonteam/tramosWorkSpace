$PBExportHeader$w_purpose_list.srw
$PBExportComments$Purpose List
forward
global type w_purpose_list from w_syswin_master
end type
end forward

global type w_purpose_list from w_syswin_master
integer width = 1467
string title = "Purposes"
end type
global w_purpose_list w_purpose_list

forward prototypes
public subroutine documentation ()
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
   </HISTORY>
********************************************************************/
end subroutine

on w_purpose_list.create
int iCurrent
call super::create
end on

on w_purpose_list.destroy
call super::destroy
end on

event open;call super::open;s_system_base_parm lstr_parm[]

lstr_parm[1].mandatorycol = "purpose_code"
lstr_parm[1].duplicatecheck = true
lstr_parm[2].mandatorycol = "purpose_desc"
lstr_parm[2].duplicatecheck = false

wf_format_datawindow(dw_1, lstr_parm)

uo_search.of_initialize(dw_1, "purpose_code+'#'+purpose_desc")
uo_search.sle_search.setfocus()

if uo_global.ii_access_level > c#usergroup.#USER then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.rowcount() > 0)
else
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

event ue_predelete;call super::ue_predelete;long ll_row, ll_count
string ls_purpose_code
pointer lp_oldpointer

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ls_purpose_code = dw_1.getitemstring(ll_row, 'purpose_code')
	lp_oldpointer = setpointer(HourGlass!)
		
	SELECT COUNT(1) into :ll_count FROM BERTH_AVAIL_GRADE WHERE PURPOSE_CODE = :ls_purpose_code;
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM CAL_CAIO WHERE PURPOSE_CODE = :ls_purpose_code;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM POC WHERE PURPOSE_CODE = :ls_purpose_code;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM POC_EST WHERE PURPOSE_CODE = :ls_purpose_code;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM POC_TASKS_CONFIG_PC WHERE PURPOSE_CODE = :ls_purpose_code;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM VETT_INSP WHERE OPTYPE = :ls_purpose_code;
	end if
	
	setpointer(lp_oldpointer)
	
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the Charterer Group, because it has been used.")
		return c#return.Failure
	end if
end if

return c#return.Success


end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_purpose_list
end type

type cb_cancel from w_syswin_master`cb_cancel within w_purpose_list
integer x = 1079
end type

type cb_refresh from w_syswin_master`cb_refresh within w_purpose_list
end type

type cb_delete from w_syswin_master`cb_delete within w_purpose_list
integer x = 731
end type

type cb_update from w_syswin_master`cb_update within w_purpose_list
integer x = 384
end type

type cb_new from w_syswin_master`cb_new within w_purpose_list
integer x = 37
end type

type dw_1 from w_syswin_master`dw_1 within w_purpose_list
integer width = 1385
string dataobject = "dw_purpose_list"
end type

type uo_search from w_syswin_master`uo_search within w_purpose_list
end type

type st_background from w_syswin_master`st_background within w_purpose_list
end type

