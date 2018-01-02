$PBExportHeader$w_project.srw
$PBExportComments$Maintain Change Request Projects
forward
global type w_project from w_system_base
end type
end forward

global type w_project from w_system_base
integer width = 1911
integer height = 1972
string title = "Projects"
long backcolor = 32304364
end type
global w_project w_project

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_project
   <OBJECT>		Maintain Projects	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI
	28/08/14	    CR3781	    CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_project.create
call super::create
end on

on w_project.destroy
call super::destroy
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"priority_id", "project_name"}

wf_format_datawindow(dw_1, ls_mandatory_column)
end event

type st_hidemenubar from w_system_base`st_hidemenubar within w_project
end type

type cb_cancel from w_system_base`cb_cancel within w_project
integer x = 1522
integer y = 1760
end type

type cb_refresh from w_system_base`cb_refresh within w_project
integer x = 2030
integer y = 320
end type

type cb_delete from w_system_base`cb_delete within w_project
integer x = 1175
integer y = 1760
end type

event cb_delete::clicked;long ll_cont, ll_project_id

ll_project_id = dw_1.getitemnumber(dw_1.getrow(), "project_id")
if not isnull(ll_project_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.PROJECT_ID = :ll_project_id
		AND CREQ_REQUEST.PROJECT_ID IS NOT NULL;
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this project.")
	return
end if

call super::clicked

end event

type cb_update from w_system_base`cb_update within w_project
integer x = 827
integer y = 1760
end type

event cb_update::clicked;long	ll_rows, ll_row, ll_projectid[], ll_priorityid[], ll_return

dw_1.acceptText()
ll_rows = dw_1.rowcount()
for ll_row = 1 to ll_rows
	if dw_1.getitemstatus(ll_row, "priority_id", primary!) = datamodified! then
		if not isNull(dw_1.getitemnumber(ll_row, "project_id")) then
			ll_projectid[upperBound(ll_projectid)+1] = dw_1.getitemnumber(ll_row, "project_id")
			ll_priorityid[upperBound(ll_priorityid)+1] = dw_1.getitemnumber(ll_row, "priority_id")
		end if
	end if
next

if super::event clicked() = c#return.Failure then return c#return.Failure

ll_rows = upperbound(ll_projectid)
for ll_row = 1 to ll_rows
	UPDATE CREQ_REQUEST
		SET CREQ_REQUEST.PRIORITY_ID = :ll_priorityid[ll_row]
	 WHERE CREQ_REQUEST.PROJECT_ID = :ll_projectid[ll_row];
	if sqlca.sqlcode = 0 then
		COMMIT;
	else
		MessageBox("Update Error", "Error updating priority.")
		ROLLBACK;
	end if
next

if isValid(w_changerequest) then
	w_changerequest.cb_refresh.post event clicked()
end if
	
end event

type cb_new from w_system_base`cb_new within w_project
integer x = 480
integer y = 1760
end type

type dw_1 from w_system_base`dw_1 within w_project
integer width = 1829
integer height = 1712
string dataobject = "d_sq_ff_project"
boolean ib_setdefaultbackgroundcolor = true
end type

event dw_1::rowfocuschanged;//
end event

