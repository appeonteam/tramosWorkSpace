$PBExportHeader$w_position_status.srw
forward
global type w_position_status from mt_w_sheet
end type
type cb_delete from mt_u_commandbutton within w_position_status
end type
type cb_new from mt_u_commandbutton within w_position_status
end type
type cb_update from mt_u_commandbutton within w_position_status
end type
type dw_p_status from mt_u_datawindow within w_position_status
end type
type dw_p_status_dropdown from mt_u_datawindow within w_position_status
end type
end forward

global type w_position_status from mt_w_sheet
integer width = 1783
integer height = 460
string title = "Edit Status"
cb_delete cb_delete
cb_new cb_new
cb_update cb_update
dw_p_status dw_p_status
dw_p_status_dropdown dw_p_status_dropdown
end type
global w_position_status w_position_status

type variables
int ii_status_id
end variables

on w_position_status.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_update=create cb_update
this.dw_p_status=create dw_p_status
this.dw_p_status_dropdown=create dw_p_status_dropdown
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.dw_p_status
this.Control[iCurrent+5]=this.dw_p_status_dropdown
end on

on w_position_status.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_update)
destroy(this.dw_p_status)
destroy(this.dw_p_status_dropdown)
end on

event open;string ls_status_name

ls_status_name = f_refreshdropdown(dw_p_status_dropdown,"name","name")

dw_p_status.InsertRow(0)

if ls_status_name = "--New--" or ls_status_name = "" or isnull(ls_status_name) then
	cb_new.Enabled = true
	cb_update.Enabled = false
	cb_delete.Enabled = false
else
	cb_new.Enabled = false
	cb_update.Enabled = false
	cb_delete.Enabled = true
end if


end event

type cb_delete from mt_u_commandbutton within w_position_status
integer x = 1381
integer y = 232
integer taborder = 30
string facename = "Arial"
string text = "&Delete"
end type

event clicked;long	ll_row
int li_statusid

ll_row = dw_p_status.getRow()
if ll_row < 1 then return

if MessageBox("Confirmation", "Are you sure you you want to delete the status?", question!, YesNo!,2) = 1 then 
	//delete subloadaeras
	li_statusid = dw_p_status.getitemnumber(ll_row,"statusid")
	if dw_p_status.deleterow(ll_row) = 1 then
		dw_p_status.update( )
		commit;	
		f_refreshdropdown(dw_p_status_dropdown,"name","name")
		dw_p_status.InsertRow(0)
		return 1
	else
		MessageBox("Delete Error", "Error deleting status.")
		return -1
	end if
end if

end event

type cb_new from mt_u_commandbutton within w_position_status
integer x = 1038
integer y = 232
integer taborder = 20
string facename = "Arial"
string text = "&New"
end type

event clicked;int 					li_row, li_row_number, li_count
string					ls_status_name

dw_p_status.settransobject(SQLCA)
if  dw_p_status.rowcount( ) <> 0 then
	dw_p_status.acceptText()
	ls_status_name = dw_p_status.getitemstring(dw_p_status.getrow( ),"name")
	SELECT COUNT(*)
	INTO :li_count
	FROM PF_STATUS
	WHERE NAME = :ls_status_name
	;
	if li_count < 1 then
		if dw_p_status.update() = 1 then
			commit;
			//refresh dropdown
			f_refreshdropdown(dw_p_status_dropdown,"name","name")
		else
			rollback;
			MessageBox("Update Error", "Error updating status.")
			return -1
		end if
	else
			MessageBox("Insert Error", "There is already a status, please specify another status name!")
			return -1
	end if
end if
end event

type cb_update from mt_u_commandbutton within w_position_status
integer x = 695
integer y = 232
integer taborder = 10
string facename = "Arial"
string text = "&Update"
end type

event clicked;datawindowchild	ldwc

if  dw_p_status.rowcount( ) <> 0 then
	dw_p_status.acceptText()
	if dw_p_status.update() = 1 then
		commit;
		f_refreshdropdown(dw_p_status_dropdown,"name","name")
	else
		rollback;
		MessageBox("Update Error", "Error updating position status.")
		return -1
	end if
end if
end event

type dw_p_status from mt_u_datawindow within w_position_status
integer x = 539
integer y = 16
integer width = 1184
integer height = 204
integer taborder = 20
string dataobject = "d_p_status"
end type

event itemchanged;string ls_status_name

ls_status_name = dw_p_status_dropdown.getitemstring(row,"name")

if ls_status_name = "--New--" or ls_status_name = "" or isnull(ls_status_name) then
	cb_new.Enabled = true
	cb_update.Enabled = false
	cb_delete.Enabled = false
else
	cb_new.Enabled = false
	cb_update.Enabled = true
	cb_delete.Enabled = true
end if
end event

type dw_p_status_dropdown from mt_u_datawindow within w_position_status
integer x = 14
integer y = 20
integer width = 512
integer height = 204
integer taborder = 10
string dataobject = "d_p_status_dropdown"
end type

event itemchanged;//string ls_status_name

//ls_status_name = dw_p_status_dropdown.getitemstring(row,"name")

ii_status_id =  integer(data)

if isnull(ii_status_id) then
	dw_p_status.reset( )
	dw_p_status_dropdown.reset( )
	dw_p_status.InsertRow(0)
	dw_p_status_dropdown.InsertRow(0)
else
	dw_p_status.settransobject(SQLCA)
	dw_p_status.retrieve(ii_status_id)	
end if

//if ls_status_name = "--New--" or ls_status_name = "" or isnull(ls_status_name) then
if isnull(ii_status_id) then
	cb_new.Enabled = true
	cb_update.Enabled = false
	cb_delete.Enabled = false
else
	cb_new.Enabled = false
	cb_update.Enabled = false
	cb_delete.Enabled = true
end if
end event

