$PBExportHeader$w_voyage_type.srw
$PBExportComments$voyage types
forward
global type w_voyage_type from w_syswin_master
end type
end forward

global type w_voyage_type from w_syswin_master
integer width = 1851
string title = "Voyage Types"
end type
global w_voyage_type w_voyage_type

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

on w_voyage_type.create
int iCurrent
call super::create
end on

on w_voyage_type.destroy
call super::destroy
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"description", "ax_code"}

wf_format_datawindow(dw_1, ls_mandatory_column)

uo_search.of_initialize(dw_1, "description + '#'+ ax_code")
uo_search.sle_search.setfocus()

cb_new.enabled = true
cb_delete.enabled = (dw_1.rowcount() > 0)
end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_voyage_type
end type

type cb_cancel from w_syswin_master`cb_cancel within w_voyage_type
integer x = 1458
end type

type cb_refresh from w_syswin_master`cb_refresh within w_voyage_type
end type

type cb_delete from w_syswin_master`cb_delete within w_voyage_type
integer x = 1111
end type

type cb_update from w_syswin_master`cb_update within w_voyage_type
integer x = 763
end type

type cb_new from w_syswin_master`cb_new within w_voyage_type
integer x = 416
end type

type dw_1 from w_syswin_master`dw_1 within w_voyage_type
integer width = 1765
string dataobject = "d_sq_gr_voyage_type"
end type

type uo_search from w_syswin_master`uo_search within w_voyage_type
end type

type st_background from w_syswin_master`st_background within w_voyage_type
end type

