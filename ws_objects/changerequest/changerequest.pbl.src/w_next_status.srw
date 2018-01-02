$PBExportHeader$w_next_status.srw
$PBExportComments$Maintain Change Request Work Flow
forward
global type w_next_status from w_maintain_base
end type
end forward

global type w_next_status from w_maintain_base
integer width = 2295
integer height = 1872
string title = "Work Flows"
end type
global w_next_status w_next_status

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_next_status
   <OBJECT>		Maintain Work Flow	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        First Version
	28/08/14		CR3781	    CCY018	     The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_next_status.create
call super::create
end on

on w_next_status.destroy
call super::destroy
end on

event open;call super::open;wf_format_datawindow(dw_1)

dw_detail.modify("type_desc.visible = 0 status_description_t.text = 'Work Flow'")

wf_register('next_status', 'status_id')
end event

type st_hidemenubar from w_maintain_base`st_hidemenubar within w_next_status
end type

type cb_cancel from w_maintain_base`cb_cancel within w_next_status
integer x = 1906
integer y = 1664
end type

type cb_refresh from w_maintain_base`cb_refresh within w_next_status
integer x = 2761
integer y = 1856
end type

type cb_delete from w_maintain_base`cb_delete within w_next_status
boolean visible = false
integer y = 1840
end type

type cb_update from w_maintain_base`cb_update within w_next_status
integer x = 1559
integer y = 1664
end type

type cb_new from w_maintain_base`cb_new within w_next_status
boolean visible = false
integer y = 1872
end type

type dw_1 from w_maintain_base`dw_1 within w_next_status
integer width = 1298
integer height = 1616
string dataobject = "d_sq_gr_typestatus"
end type

event dw_1::rowfocuschanged;string ls_filter
long ll_typeid, ll_statusid

ll_typeid = this.getitemnumber(currentrow, 'type_id')
ll_statusid = this.getitemnumber(currentrow, 'status_id')
ls_filter = 'type_id = ' + string(ll_typeid) + ' and status_id <> ' + string(ll_statusid)
dw_detail.setfilter(ls_filter)
dw_detail.filter()

call super::rowfocuschanged
end event

type dw_detail from w_maintain_base`dw_detail within w_next_status
integer x = 1371
integer width = 878
integer height = 1616
string dataobject = "d_sq_gr_typestatus"
end type

