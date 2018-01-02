$PBExportHeader$w_new_buildings.srw
forward
global type w_new_buildings from w_syswin_master
end type
end forward

global type w_new_buildings from w_syswin_master
integer width = 3337
string title = "Vessels New Buildings"
end type
global w_new_buildings w_new_buildings

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

on w_new_buildings.create
int iCurrent
call super::create
end on

on w_new_buildings.destroy
call super::destroy
end on

event open;call super::open;datawindowchild ldwc_child

wf_format_datawindow(dw_1)

// Init searchbox
uo_search.of_initialize(dw_1, "vessel_name")
uo_search.sle_search.setfocus()

dw_1.getchild("pc_nr", ldwc_child)
ldwc_child.settransobject(sqlca)
ldwc_child.retrieve(uo_global.is_userid)

if (uo_global.ii_access_level = c#usergroup.#USER and uo_global.ii_user_profile=1) or uo_global.ii_access_level > c#usergroup.#USER then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.rowcount() > 0)
	dw_1.object.datawindow.readonly = "No"
else
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_update.enabled = false
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_new_buildings
end type

type cb_cancel from w_syswin_master`cb_cancel within w_new_buildings
integer x = 2944
end type

type cb_refresh from w_syswin_master`cb_refresh within w_new_buildings
end type

type cb_delete from w_syswin_master`cb_delete within w_new_buildings
integer x = 2597
end type

type cb_update from w_syswin_master`cb_update within w_new_buildings
integer x = 2249
end type

type cb_new from w_syswin_master`cb_new within w_new_buildings
integer x = 1902
end type

type dw_1 from w_syswin_master`dw_1 within w_new_buildings
integer width = 3255
string dataobject = "d_sq_tb_newbuildings_list"
end type

type uo_search from w_syswin_master`uo_search within w_new_buildings
end type

type st_background from w_syswin_master`st_background within w_new_buildings
end type

