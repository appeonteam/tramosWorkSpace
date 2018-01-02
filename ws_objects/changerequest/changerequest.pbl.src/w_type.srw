$PBExportHeader$w_type.srw
$PBExportComments$Maintain Change Request Types
forward
global type w_type from w_maintain_base
end type
type cb_workflow from commandbutton within w_type
end type
end forward

global type w_type from w_maintain_base
integer width = 2405
integer height = 1872
string title = "Types"
event ue_refresh_initialstatus ( )
cb_workflow cb_workflow
end type
global w_type w_type

type variables
long il_initial_statusid
string is_initial_statusname
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_refresh_initialstatus;SELECT STATUS_ID, STATUS_DESCRIPTION 
  INTO :il_initial_statusid, :is_initial_statusname 
  FROM CREQ_STATUS 
 WHERE INITIAL_STATUS = 1;
end event

public subroutine documentation ();/********************************************************************
   w_type
   <OBJECT>		Maintain CREQ Types	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI, add status maintainance for change request type
   	15/07/2013 CR3254       LHG008        Fix stuff related with Initial status
	28/08/2014 CR3781	    CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_type.create
int iCurrent
call super::create
this.cb_workflow=create cb_workflow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_workflow
end on

on w_type.destroy
call super::destroy
destroy(this.cb_workflow)
end on

event open;call super::open;string ls_mandatory_column[]

ls_mandatory_column = {"type_desc", "type_sort"}

wf_format_datawindow(dw_1, ls_mandatory_column)

wf_register('type_accessstatus', 'status_id')

event ue_refresh_initialstatus()
end event

type st_hidemenubar from w_maintain_base`st_hidemenubar within w_type
end type

type cb_cancel from w_maintain_base`cb_cancel within w_type
integer x = 2016
integer y = 1664
integer taborder = 70
end type

type cb_refresh from w_maintain_base`cb_refresh within w_type
integer x = 1760
integer y = 340
integer taborder = 80
end type

type cb_delete from w_maintain_base`cb_delete within w_type
integer x = 1669
integer y = 1664
integer taborder = 60
end type

event cb_delete::clicked;long ll_row, ll_type_id, ll_cont

ll_row = dw_1.getrow()
ll_type_id = dw_1.getitemnumber(ll_row, 'type_id')
if not isnull(ll_type_id) then
	SELECT COUNT(1) INTO :ll_cont
	  FROM CREQ_REQUEST
	 WHERE CREQ_REQUEST.TYPE_ID = :ll_type_id
		AND CREQ_REQUEST.TYPE_ID IS NOT NULL;
end if

if ll_cont > 0 then
	messagebox("Delete Error", "It is not possible to delete as there are dependencies on this type.")
	return
end if

if messagebox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!,2) = 1 then
	DELETE CREQ_TYPE_STATUS
	 WHERE TYPE_ID = :ll_type_id;

	if sqlca.sqlcode <> 0 then
		ROLLBACK;
		messagebox("Update Error", "Update failure.")	
		dw_1.retrieve()
		return C#Return.Failure
	end if
	
 	dw_1.deleterow(ll_row)
	cb_update.event clicked( )
end if
end event

type cb_update from w_maintain_base`cb_update within w_type
integer x = 1321
integer y = 1664
integer taborder = 50
end type

event cb_update::clicked;long ll_row, ll_firsterrorrow
string ls_accessstatus, ls_initialstatus, ls_errorrow
constant string ls_DELIMITER = ","

ls_initialstatus = ls_DELIMITER + string(il_initial_statusid) + ls_DELIMITER

//Check initial status
for ll_row = dw_1.rowcount() to 1 step -1
	ls_accessstatus = dw_1.getitemstring(ll_row, 'type_accessstatus')
	if pos(ls_DELIMITER + ls_accessstatus + ls_DELIMITER, ls_initialstatus) > 0 then
		//do nothing
	else
		if ls_errorrow = '' then
			ls_errorrow = string(ll_row)
		else
			ls_errorrow = string(ll_row) + ',' + ls_errorrow
		end if
		ll_firsterrorrow = ll_row
	end if
next

dw_1.setfocus()
dw_1.setrow(ll_firsterrorrow)

if ls_errorrow <> '' then
	messagebox("Update Error", "Initial status '"+ is_initial_statusname + "' should be selected.(row " + ls_errorrow + ")")
	return C#Return.Success
end if

call super::clicked

return ancestorreturnvalue
end event

type cb_new from w_maintain_base`cb_new within w_type
integer x = 974
integer y = 1664
integer taborder = 40
end type

event cb_new::clicked;call super::clicked;long ll_find

ll_find = dw_detail.find("initial_status = 1", 1, dw_detail.rowcount())
if ll_find > 0 then
	dw_1.setitem(dw_1.getrow(), 'type_accessstatus', string(il_initial_statusid))
	dw_detail.selectrow(ll_find, true)
end if

end event

type dw_1 from w_maintain_base`dw_1 within w_type
integer width = 1390
integer height = 1616
string dataobject = "d_sq_gr_type"
end type

type dw_detail from w_maintain_base`dw_detail within w_type
integer x = 1463
integer width = 896
integer height = 1616
string dataobject = "d_sq_gr_status_select"
end type

event dw_detail::clicked;string ls_nextstatus
long ll_typeid, ll_statusid
long ll_row, ll_cont

if row > 0 then
	if this.isselected(row) then
		ll_row = dw_1.getrow()
		ll_typeid = dw_1.getitemnumber(ll_row, 'type_id')
		ll_statusid = this.getitemnumber(row, 'status_id')
		
		if this.getitemnumber(row, 'initial_status') = 1 then
			messagebox("Error", "Initial status '"+ is_initial_statusname + "' cannot be deselect.")
			return
		end if
		
		if not isnull(ll_typeid) then
			SELECT COUNT(1) INTO :ll_cont
			  FROM CREQ_REQUEST
			 WHERE TYPE_ID = :ll_typeid
				AND STATUS_ID = :ll_statusid;
		end if
		
		if ll_cont > 0 then
			messagebox("Delete Error", "It is not possible to deselect, because it has been used.")
			return
		end if
		
		SELECT NEXT_STATUS INTO :ls_nextstatus FROM CREQ_TYPE_STATUS WHERE TYPE_ID = :ll_typeid AND STATUS_ID = :ll_statusid;
		if trim(ls_nextstatus) > '' then
			if messagebox("Warning", "Do you really want to unselect this status and clear the work flow status?", Question!, YesNo!, 2) = 2 then
				return
			end if
		end if
	end if
end if

call super::clicked
end event

type cb_workflow from commandbutton within w_type
integer x = 37
integer y = 1664
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Work Flow"
end type

event clicked;opensheet(w_next_status, w_tramos_main, 0, Original!)
end event

