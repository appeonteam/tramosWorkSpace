$PBExportHeader$w_commercial_segment.srw
$PBExportComments$Commercial Segment
forward
global type w_commercial_segment from w_syswin_master
end type
end forward

global type w_commercial_segment from w_syswin_master
integer width = 1710
string title = "Commercial Segments"
end type
global w_commercial_segment w_commercial_segment

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
	10/10/14	CR3781	CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_commercial_segment.create
int iCurrent
call super::create
end on

on w_commercial_segment.destroy
call super::destroy
end on

event open;call super::open;wf_format_datawindow(dw_1)

uo_search.of_initialize(dw_1, "comm_segment_name")
uo_search.sle_search.setfocus()

cb_new.enabled = true
cb_delete.enabled = (dw_1.rowcount() > 0)
end event

event ue_predelete;long ll_row, ll_count, ll_comm_segment_id
pointer lp_oldpointer

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.Failure

if dw_1.getitemstatus( ll_row, 0, primary!) = New! or dw_1.getitemstatus( ll_row, 0, primary!) = NewModified! then
else
	ll_comm_segment_id = dw_1.getitemnumber(ll_row, 'comm_segment_id')
	lp_oldpointer = setpointer(HourGlass!)
	
	SELECT COUNT(1) into :ll_count FROM CAL_CLAR WHERE COMM_SEGMENT_ID = :ll_comm_segment_id;
	if ll_count = 0 then
		SELECT COUNT(1) into :ll_count FROM VESSELS WHERE COMM_SEGMENT_ID = :ll_comm_segment_id;
	end if
	
	setpointer(lp_oldpointer)
	
	if ll_count > 0 then
		messagebox("Delete Error", "You cannot delete the Commercial Segment, because it has been used.")
		return c#return.Failure
	end if
end if

return c#return.Success


end event

type st_hidemenubar from w_syswin_master`st_hidemenubar within w_commercial_segment
end type

type cb_cancel from w_syswin_master`cb_cancel within w_commercial_segment
integer x = 1321
end type

type cb_refresh from w_syswin_master`cb_refresh within w_commercial_segment
end type

type cb_delete from w_syswin_master`cb_delete within w_commercial_segment
integer x = 974
integer width = 338
end type

type cb_update from w_syswin_master`cb_update within w_commercial_segment
integer x = 622
end type

type cb_new from w_syswin_master`cb_new within w_commercial_segment
integer x = 270
end type

type dw_1 from w_syswin_master`dw_1 within w_commercial_segment
integer width = 1627
string dataobject = "d_sq_gr_comm_segment_config"
end type

type uo_search from w_syswin_master`uo_search within w_commercial_segment
end type

type st_background from w_syswin_master`st_background within w_commercial_segment
end type

