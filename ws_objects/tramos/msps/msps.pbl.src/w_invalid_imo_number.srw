$PBExportHeader$w_invalid_imo_number.srw
$PBExportComments$Invalid IMO Number List
forward
global type w_invalid_imo_number from w_syswin_master
end type
end forward

global type w_invalid_imo_number from w_syswin_master
integer width = 2510
integer height = 1904
string title = "Invalid IMO Number List"
end type
global w_invalid_imo_number w_invalid_imo_number

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

on w_invalid_imo_number.create
int iCurrent
call super::create
end on

on w_invalid_imo_number.destroy
call super::destroy
end on

event open;call super::open;wf_format_datawindow(dw_1)

uo_search.of_initialize(dw_1, "if(isnull(vessel_name), '', vessel_name)+'#'+vessel_imo+'#'+report_id")
uo_search.sle_search.setfocus()

dw_1.object.datawindow.readonly = "Yes"
end event

type cb_cancel from w_syswin_master`cb_cancel within w_invalid_imo_number
boolean visible = false
end type

type cb_refresh from w_syswin_master`cb_refresh within w_invalid_imo_number
end type

type cb_delete from w_syswin_master`cb_delete within w_invalid_imo_number
boolean visible = false
end type

type cb_update from w_syswin_master`cb_update within w_invalid_imo_number
boolean visible = false
end type

type cb_new from w_syswin_master`cb_new within w_invalid_imo_number
boolean visible = false
end type

type dw_1 from w_syswin_master`dw_1 within w_invalid_imo_number
integer y = 240
integer width = 2427
integer height = 1552
string dataobject = "d_sq_gr_invalid_imo_list"
end type

type uo_search from w_syswin_master`uo_search within w_invalid_imo_number
end type

type st_background from w_syswin_master`st_background within w_invalid_imo_number
end type

