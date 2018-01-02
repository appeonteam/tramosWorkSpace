$PBExportHeader$w_priority.srw
$PBExportComments$Maintain Change Request Severity
forward
global type w_priority from w_system_base
end type
end forward

global type w_priority from w_system_base
integer width = 1563
integer height = 1260
string title = "Severities"
end type
global w_priority w_priority

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_priority
   <OBJECT>		Maintain Severity	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI
	28/08/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_priority.create
call super::create
end on

on w_priority.destroy
call super::destroy
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"priority_desc", "priority_sort"}

wf_format_datawindow(dw_1, ls_mandatory_column)

end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_priority
end type

type cb_cancel from w_system_base`cb_cancel within w_priority
integer x = 1175
integer y = 1056
end type

type cb_refresh from w_system_base`cb_refresh within w_priority
integer x = 1870
integer y = 340
end type

type cb_delete from w_system_base`cb_delete within w_priority
integer x = 827
integer y = 1056
end type

event cb_delete::clicked;long ll_cont, ll_priority_id

ll_priority_id = dw_1.getitemnumber(dw_1.getrow(), "priority_id")
//Check dependence
if not isnull(ll_priority_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.PRIORITY_ID = :ll_priority_id
		AND CREQ_REQUEST.PRIORITY_ID IS NOT NULL;
		
	if ll_cont = 0 then
		SELECT COUNT(1) INTO :ll_cont
		  FROM CREQ_PROJECT
		 WHERE CREQ_PROJECT.PRIORITY_ID = :ll_priority_id
			AND CREQ_PROJECT.PRIORITY_ID IS NOT NULL;
	end if
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this severity.")
	return
end if

call super::clicked

end event

type cb_update from w_system_base`cb_update within w_priority
integer x = 480
integer y = 1056
end type

event cb_update::clicked;long 		ll_row
integer	li_count

for ll_row = 1 to dw_1.rowcount()
	if dw_1.getitemnumber(ll_row, "initial_priority") = 1 then
		li_count++
	end if
next

if li_count <> 1 then
	messagebox("Validation", "There must be one and only one priority marked as Initial")
	return c#return.Failure
end if

call super::clicked

return ancestorreturnvalue
end event

type cb_new from w_system_base`cb_new within w_priority
integer x = 133
integer y = 1056
end type

type dw_1 from w_system_base`dw_1 within w_priority
integer width = 1481
integer height = 1008
string dataobject = "d_sq_gr_priority"
end type

