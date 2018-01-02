$PBExportHeader$w_profit_center_group.srw
$PBExportComments$Profit Centers Group
forward
global type w_profit_center_group from w_syswin_master
end type
end forward

global type w_profit_center_group from w_syswin_master
integer width = 4663
string title = "Profit Center Groups"
end type
global w_profit_center_group w_profit_center_group

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

on w_profit_center_group.create
int iCurrent
call super::create
end on

on w_profit_center_group.destroy
call super::destroy
end on

event open;call super::open;wf_format_datawindow(dw_1)

uo_search.of_initialize(dw_1, "pcgroup_name+'#'+pcgroup_desc")
uo_search.sle_search.setfocus()

if uo_global.ii_access_level > c#usergroup.#USER then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.RowCount() > 0)
else
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

event ue_predelete;call super::ue_predelete;long ll_row, ll_count, ll_pcgroup_id
pointer lp_oldpointer

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ll_pcgroup_id = dw_1.getitemnumber(ll_row, 'pcgroup_id')
	lp_oldpointer = setpointer(HourGlass!)
		
	SELECT COUNT(1) into :ll_count FROM OFFICES WHERE PCGROUP_ID = :ll_pcgroup_id;
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PROFIT_C WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_COMPANY WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_ARCHIVE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_BUNKERPLACE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_CARGO WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_CLEANINGTYPE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_COMMENT WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_FLATRATE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_STATUS_CONFIG WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_FIXTURE_TRADE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_NEXT_OPEN_PORTS_CONFIG WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_POSITION WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_POSITIONEMAIL WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM PF_REPORTGTEMPLATE WHERE PCGROUP_ID = :ll_pcgroup_id;
	end if
	
	setpointer(lp_oldpointer)
	
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the Profit Centers Group, because it has been used.")
		return c#return.Failure
	end if
end if

return c#return.Success


end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_profit_center_group
end type

type cb_cancel from w_syswin_master`cb_cancel within w_profit_center_group
integer x = 4274
end type

type cb_refresh from w_syswin_master`cb_refresh within w_profit_center_group
end type

type cb_delete from w_syswin_master`cb_delete within w_profit_center_group
integer x = 3927
end type

type cb_update from w_syswin_master`cb_update within w_profit_center_group
integer x = 3579
end type

type cb_new from w_syswin_master`cb_new within w_profit_center_group
integer x = 3232
end type

type dw_1 from w_syswin_master`dw_1 within w_profit_center_group
integer width = 4581
string dataobject = "dw_pcgroup_list"
end type

type uo_search from w_syswin_master`uo_search within w_profit_center_group
end type

type st_background from w_syswin_master`st_background within w_profit_center_group
integer width = 4777
end type

