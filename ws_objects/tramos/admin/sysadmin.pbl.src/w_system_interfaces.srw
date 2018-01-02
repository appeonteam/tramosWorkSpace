$PBExportHeader$w_system_interfaces.srw
$PBExportComments$M5-1 Voyage master data - System Interfaces
forward
global type w_system_interfaces from mt_w_sheet
end type
type uo_search from u_searchbox within w_system_interfaces
end type
type cb_cancel from mt_u_commandbutton within w_system_interfaces
end type
type cb_update from mt_u_commandbutton within w_system_interfaces
end type
type cb_delete from mt_u_commandbutton within w_system_interfaces
end type
type cb_new from mt_u_commandbutton within w_system_interfaces
end type
type dw_interface from mt_u_datawindow within w_system_interfaces
end type
type st_topbar_background from u_topbar_background within w_system_interfaces
end type
end forward

global type w_system_interfaces from mt_w_sheet
integer width = 4599
integer height = 2328
string title = "System Interfaces"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
uo_search uo_search
cb_cancel cb_cancel
cb_update cb_update
cb_delete cb_delete
cb_new cb_new
dw_interface dw_interface
st_topbar_background st_topbar_background
end type
global w_system_interfaces w_system_interfaces

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_system_interfaces
   <OBJECT>		M5-1 Voyage master data - System Interfaces	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	05/12/2011 M5-1         LGX001        First Version
   </HISTORY>
********************************************************************/
end subroutine

on w_system_interfaces.create
int iCurrent
call super::create
this.uo_search=create uo_search
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_interface=create dw_interface
this.st_topbar_background=create st_topbar_background
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.dw_interface
this.Control[iCurrent+7]=this.st_topbar_background
end on

on w_system_interfaces.destroy
call super::destroy
destroy(this.uo_search)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_interface)
destroy(this.st_topbar_background)
end on

event open;call super::open;string	ls_columnlist

dw_interface.settransobject(sqlca)
dw_interface.retrieve()

ls_columnlist = "if(isnull(description), '', description) + '#' + if(isnull(filename_extension), '', filename_extension) + '#' + " + &
					 "if(isnull(folder_archive), '', folder_archive) + '#' + if(isnull(folder_location), '', folder_location) + '#' + " + &
					 "if(isnull(folder_out), '', folder_out) + '#' + if(isnull(folder_working), '', folder_working) + '#' + " + &
					 "if(isnull(interface_group), '', interface_group) + '#' + if(isnull(interface_name), '', interface_name) + '#' + " + &
					 "if(isnull(mq_queue_manager), '', mq_queue_manager) + '#' + if(isnull(mq_queue_name), '', mq_queue_name) + '#' + " + &
					 "if(isnull(source_table), '', source_table)"

uo_search.of_initialize(dw_interface, ls_columnlist)
uo_search.sle_search.setfocus()

uo_search.st_search.text = 'Search'
uo_search.sle_search.y = uo_search.sle_search.y +14
uo_search.sle_search.height = 56
uo_search.cb_clear.x = uo_search.cb_clear.x + 4
uo_search.cb_clear.y = uo_search.sle_search.y - 10
uo_search.cb_clear.height = 70

uo_search.sle_search.border = false
uo_search.backcolor = c#color.MT_LISTHEADER_BG
uo_search.st_search.backcolor = c#color.MT_LISTHEADER_BG
uo_search.st_search.textcolor = c#color.MT_LISTHEADER_TEXT

end event

event closequery;call super::closequery;dw_interface.accepttext()
if dw_interface.deletedcount() + dw_interface.modifiedcount() > 0 then
	if Messagebox("Updates Pending","Data is modified but not saved. Would you like to update the changes before closing?", Question!, YesNo!) = 2 then return 0
	return cb_update.event clicked()
end If
end event

type uo_search from u_searchbox within w_system_interfaces
integer x = 37
integer y = 16
integer width = 1207
integer taborder = 10
end type

on uo_search.destroy
call u_searchbox::destroy
end on

type cb_cancel from mt_u_commandbutton within w_system_interfaces
integer x = 4224
integer y = 2124
integer taborder = 60
string text = "&Cancel"
end type

event clicked;call super::clicked;dw_interface.retrieve()
dw_interface.filter()
cb_new.enabled = true
cb_new.default = true
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled

end event

type cb_update from mt_u_commandbutton within w_system_interfaces
integer x = 3529
integer y = 2124
integer taborder = 40
string text = "&Update"
end type

event clicked;call super::clicked;long ll_row, ll_rc 

dw_interface.accepttext()

ll_row = dw_interface.find("IsNull(interval) or interval = 0 ", 1, dw_interface.rowcount())
if ll_row > 0 then
	messagebox("Validation Error", "Interval cannot be ZERO or NULL")
	dw_interface.scrolltorow(ll_row)
	dw_interface.setrow(ll_row)
	dw_interface.setcolumn('interval')
	dw_interface.setfocus()
	return -1
end if	
ll_rc = dw_interface.update(true, false)
if ll_rc < 0 then
	rollback;
	messagebox("Update Error", "Failed to update System Interface.")
	return -1
end if
commit; 
dw_interface.resetupdate()
cb_new.default = true 
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true
return 0

end event

type cb_delete from mt_u_commandbutton within w_system_interfaces
integer x = 3877
integer y = 2124
integer taborder = 50
string text = "&Delete"
end type

event clicked;call super::clicked;long ll_rc, ll_rowcount, ll_row

ll_row = dw_interface.getrow()
if ll_row <= 0 then return
if messagebox("System Interfaces","You are about to delete an entry in the System Interfaces configuration.~r~nDo you want to continue?", Question!, YesNo!, 2) = 2 then return
ll_rc = dw_interface.deleterow(ll_row)
if ll_rc > 0 then ll_rc = dw_interface.update()
if ll_rc < 0 then
	rollback;
	messagebox("Delete Error", "Data is not deleted.")
else
	commit;
end if


end event

type cb_new from mt_u_commandbutton within w_system_interfaces
integer x = 3182
integer y = 2124
integer taborder = 30
string text = "&New"
end type

event clicked;call super::clicked;long	ll_row

ll_row = dw_interface.insertrow(0)
dw_interface.scrolltorow(ll_row)
dw_interface.post setfocus()

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true
cb_update.default = true

end event

type dw_interface from mt_u_datawindow within w_system_interfaces
integer x = 37
integer y = 240
integer width = 4517
integer height = 1856
integer taborder = 20
string dataobject = "d_sq_ff_interfaces"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
boolean ib_setdefaultbackgroundcolor = true
end type

event editchanged;call super::editchanged;long	ll_null

if row <= 0 then return

if dwo.name = "interval" then
	if pos(data, "-") > 0 then
		if data = "-" then
			this.post setitem(row, "interval", ll_null)
		else
			this.post setitem(row, "interval", abs(long(data)))
		end if
	end if
end if


end event

event losefocus;call super::losefocus;long	ll_row

this.accepttext()
ll_row = this.find("isnull(interval) or interval = 0", 1, this.rowcount())
if ll_row > 0 then
	this.scrolltorow(ll_row)
	this.setcolumn("interval")
	if parent.visible and getfocus() <> cb_cancel and getfocus() <> cb_update then
		messagebox("Validation Error", "Interval cannot be ZERO or NULL")
		this.setfocus()
	end if
end if

end event

event retrieveend;call super::retrieveend;dw_interface.setcolumn("interface_group")

end event

type st_topbar_background from u_topbar_background within w_system_interfaces
integer width = 9125
integer height = 208
end type

