$PBExportHeader$w_charterer_group.srw
$PBExportComments$Charterer Groups
forward
global type w_charterer_group from w_syswin_master
end type
end forward

global type w_charterer_group from w_syswin_master
integer width = 1463
string title = "Charterer Groups"
end type
global w_charterer_group w_charterer_group

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

on w_charterer_group.create
int iCurrent
call super::create
end on

on w_charterer_group.destroy
call super::destroy
end on

event open;call super::open;wf_format_datawindow(dw_1)

uo_search.of_initialize(dw_1, "ccs_chgp_name")
uo_search.sle_search.setfocus()

cb_new.enabled = true 
cb_delete.enabled = true
if uo_global.ii_access_level < c#usergroup.#ADMINISTRATOR and uo_global.ii_user_profile < 3 then
	cb_new.enabled = false
	cb_delete.enabled = false
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

event ue_predelete;long ll_row, ll_count, ll_ccs_chgp_pk

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ll_ccs_chgp_pk = dw_1.getitemnumber(ll_row, 'ccs_chgp_pk')
	SELECT COUNT(1) into :ll_count FROM CHART WHERE CCS_CHGP_PK = :ll_ccs_chgp_pk;
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the Charterer Group, because it has been used.")
		return c#return.Failure
	end if
end if

return c#return.Success


end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_charterer_group
end type

type cb_cancel from w_syswin_master`cb_cancel within w_charterer_group
integer x = 1074
end type

type cb_refresh from w_syswin_master`cb_refresh within w_charterer_group
end type

type cb_delete from w_syswin_master`cb_delete within w_charterer_group
integer x = 727
end type

type cb_update from w_syswin_master`cb_update within w_charterer_group
integer x = 379
end type

type cb_new from w_syswin_master`cb_new within w_charterer_group
integer x = 32
end type

type dw_1 from w_syswin_master`dw_1 within w_charterer_group
integer width = 1381
string dataobject = "d_chartgroup_list"
end type

type uo_search from w_syswin_master`uo_search within w_charterer_group
end type

type st_background from w_syswin_master`st_background within w_charterer_group
end type

