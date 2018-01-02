$PBExportHeader$w_consultant.srw
forward
global type w_consultant from w_system_base
end type
end forward

global type w_consultant from w_system_base
integer width = 2441
integer height = 1276
string title = "Consultants"
end type
global w_consultant w_consultant

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_consultant
   <OBJECT>		Maintain Consultants	</OBJECT>
   <USAGE>			</USAGE>
   <ALSO>			</ALSO>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		02-04-2013	CR2614		LHG008		Change GUI
		11/07/2013	CR3254		LHG008		Add new column Email
		28/08/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_consultant.create
call super::create
end on

on w_consultant.destroy
call super::destroy
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"name"}

wf_format_datawindow(dw_1, ls_mandatory_column)
end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_consultant
end type

type cb_cancel from w_system_base`cb_cancel within w_consultant
integer x = 2053
integer y = 1072
end type

type cb_refresh from w_system_base`cb_refresh within w_consultant
integer x = 2743
integer y = 272
end type

type cb_delete from w_system_base`cb_delete within w_consultant
integer x = 1705
integer y = 1072
end type

event cb_delete::clicked;long ll_cont
longlong ll_consultant_id

ll_consultant_id = dw_1.getitemnumber(dw_1.getrow(), "consultant_id")
if not isnull(ll_consultant_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_TIME_USED
	 WHERE CREQ_TIME_USED.CONSULTANT_ID = :ll_consultant_id
		AND CREQ_TIME_USED.CONSULTANT_ID IS NOT NULL;
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this consultant.")
	return
end if

call super::clicked

end event

type cb_update from w_system_base`cb_update within w_consultant
integer x = 1358
integer y = 1072
end type

type cb_new from w_system_base`cb_new within w_consultant
integer x = 1010
integer y = 1072
end type

type dw_1 from w_system_base`dw_1 within w_consultant
integer width = 2359
integer height = 1024
string dataobject = "d_sq_gr_consultant"
end type

