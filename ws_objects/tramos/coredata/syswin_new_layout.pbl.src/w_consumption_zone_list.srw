$PBExportHeader$w_consumption_zone_list.srw
$PBExportComments$Consumption Zone List
forward
global type w_consumption_zone_list from w_syswin_master
end type
end forward

global type w_consumption_zone_list from w_syswin_master
integer width = 1673
string title = "Consumption Zones"
end type
global w_consumption_zone_list w_consumption_zone_list

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
	12/08/14 CR3562	KSH092         	add column order
	28/08/14	CR3781	CCY018			The window title match with the text of a menu item	
   </HISTORY>
********************************************************************/
end subroutine

on w_consumption_zone_list.create
int iCurrent
call super::create
end on

on w_consumption_zone_list.destroy
call super::destroy
end on

event open;call super::open;s_system_base_parm lstr_parm[]

lstr_parm[1].mandatorycol = "zone_sn"
lstr_parm[1].duplicatecheck = true

wf_format_datawindow(dw_1, lstr_parm)

uo_search.of_initialize(dw_1, "compute_search")
uo_search.sle_search.setfocus()

if (uo_global.ii_access_level = c#usergroup.#ADMINISTRATOR and uo_global.ii_user_profile <= 3) or &
	(uo_global.ii_access_level = c#usergroup.#SUPERUSER and uo_global.ii_user_profile <= 2) then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.rowcount() > 0)
else
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

event ue_predelete;long ll_row, ll_count, ll_zone_id

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ll_zone_id = dw_1.getitemnumber(ll_row, 'zone_id')
	SELECT COUNT(1) into :ll_count FROM CAL_CONS WHERE ZONE_ID = :ll_zone_id;
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the zone, because it has been used.")
		return c#return.Failure
	else
		SELECT COUNT(*) into :ll_count FROM USERS WHERE DEFAULT_CONS_ZONE = :ll_zone_id;
		if ll_count > 0 then
		   messagebox("Delete Error", "You cannot delete the zone, because it has been used.")
		   return c#return.Failure
		end if
	end if
end if

return c#return.Success


end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_consumption_zone_list
end type

type cb_cancel from w_syswin_master`cb_cancel within w_consumption_zone_list
integer x = 1285
integer taborder = 60
end type

type cb_refresh from w_syswin_master`cb_refresh within w_consumption_zone_list
integer taborder = 0
end type

type cb_delete from w_syswin_master`cb_delete within w_consumption_zone_list
integer x = 937
integer taborder = 50
end type

type cb_update from w_syswin_master`cb_update within w_consumption_zone_list
integer x = 590
integer taborder = 40
end type

type cb_new from w_syswin_master`cb_new within w_consumption_zone_list
integer x = 242
integer taborder = 30
end type

event cb_new::clicked;call super::clicked;string ls_colorder
string ls_maxinum
long ll_max, ll_row

// Assume that the row is added to the end
ll_row = dw_1.RowCount()
if ll_row <= 0 then return

ls_colorder = "cons_order"
ls_maxinum = dw_1.describe( "evaluate('max( cons_order for all )', 0)" )
if isnumber(ls_maxinum) then
	ll_max = long(ls_maxinum) + 1
else
	ll_max = 1
end if

dw_1.SetItem(ll_row, ls_colorder, ll_max )
end event

type dw_1 from w_syswin_master`dw_1 within w_consumption_zone_list
integer width = 1591
integer taborder = 20
string dataobject = "d_sq_gr_cons_zone"
end type

type uo_search from w_syswin_master`uo_search within w_consumption_zone_list
integer taborder = 10
end type

type st_background from w_syswin_master`st_background within w_consumption_zone_list
end type

