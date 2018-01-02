$PBExportHeader$w_grade_group.srw
$PBExportComments$Grade Groups
forward
global type w_grade_group from w_syswin_master
end type
end forward

global type w_grade_group from w_syswin_master
integer width = 1467
string title = "Grade Groups"
end type
global w_grade_group w_grade_group

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
   </HISTORY>
********************************************************************/
end subroutine

on w_grade_group.create
int iCurrent
call super::create
end on

on w_grade_group.destroy
call super::destroy
end on

event open;call super::open;s_system_base_parm lstr_parm[]

lstr_parm[1].mandatorycol = "grade_group"
lstr_parm[1].duplicatecheck = true

wf_format_datawindow(dw_1, lstr_parm)

uo_search.of_initialize(dw_1, "grade_group")
uo_search.sle_search.setfocus()

if uo_global.ii_access_level > c#usergroup.#USER then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.RowCount() > 0)
else
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

event ue_predelete;call super::ue_predelete;long ll_row, ll_count
string ls_grade_group

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ls_grade_group = dw_1.getitemstring(ll_row, 'grade_group')
	SELECT COUNT(1) into :ll_count FROM GRADES WHERE GRADE_GROUP = :ls_grade_group;
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the Grade Group, because it has been used.")
		return c#return.Failure
	end if
end if

return c#return.Success


end event

type cb_cancel from w_syswin_master`cb_cancel within w_grade_group
integer x = 1079
end type

type cb_refresh from w_syswin_master`cb_refresh within w_grade_group
end type

type cb_delete from w_syswin_master`cb_delete within w_grade_group
integer x = 731
end type

type cb_update from w_syswin_master`cb_update within w_grade_group
integer x = 384
end type

type cb_new from w_syswin_master`cb_new within w_grade_group
integer x = 37
end type

type dw_1 from w_syswin_master`dw_1 within w_grade_group
integer width = 1385
string dataobject = "dw_grade_groups"
end type

type uo_search from w_syswin_master`uo_search within w_grade_group
end type

type st_background from w_syswin_master`st_background within w_grade_group
end type

