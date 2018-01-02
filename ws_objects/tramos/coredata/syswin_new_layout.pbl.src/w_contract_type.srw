$PBExportHeader$w_contract_type.srw
$PBExportComments$Contract Types
forward
global type w_contract_type from w_syswin_master
end type
end forward

global type w_contract_type from w_syswin_master
integer width = 1467
string title = "Contract Types"
end type
global w_contract_type w_contract_type

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

on w_contract_type.create
int iCurrent
call super::create
end on

on w_contract_type.destroy
call super::destroy
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"contract_type_id", "contract_type_name"}

wf_format_datawindow(dw_1, ls_mandatory_column)

uo_search.of_initialize(dw_1, "contract_type_name")
uo_search.sle_search.setfocus()

if uo_global.ii_access_level = c#usergroup.#ADMINISTRATOR and uo_global.ii_user_profile = 3 then
	cb_new.enabled = true
	cb_delete.enabled = (dw_1.rowcount() > 0)
else
	dw_1.object.datawindow.readonly = "Yes"
end if
end event

type cb_cancel from w_syswin_master`cb_cancel within w_contract_type
integer x = 1079
end type

type cb_refresh from w_syswin_master`cb_refresh within w_contract_type
end type

type cb_delete from w_syswin_master`cb_delete within w_contract_type
integer x = 731
end type

type cb_update from w_syswin_master`cb_update within w_contract_type
integer x = 384
end type

type cb_new from w_syswin_master`cb_new within w_contract_type
integer x = 37
end type

type dw_1 from w_syswin_master`dw_1 within w_contract_type
integer width = 1385
string dataobject = "d_sq_gr_contract_type_config"
end type

type uo_search from w_syswin_master`uo_search within w_contract_type
end type

type st_background from w_syswin_master`st_background within w_contract_type
end type

