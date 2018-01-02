$PBExportHeader$w_user_groups.srw
forward
global type w_user_groups from mt_w_sheet
end type
type uo_search from u_searchbox within w_user_groups
end type
type cb_cancel from mt_u_commandbutton within w_user_groups
end type
type cb_update from mt_u_commandbutton within w_user_groups
end type
type cb_delete from mt_u_commandbutton within w_user_groups
end type
type cb_new from mt_u_commandbutton within w_user_groups
end type
type dw_group from u_datagrid within w_user_groups
end type
end forward

global type w_user_groups from mt_w_sheet
integer width = 1518
integer height = 1676
string title = "User Groups"
boolean minbox = false
boolean maxbox = false
boolean ib_setdefaultbackgroundcolor = true
uo_search uo_search
cb_cancel cb_cancel
cb_update cb_update
cb_delete cb_delete
cb_new cb_new
dw_group dw_group
end type
global w_user_groups w_user_groups

type variables
long il_groupid
string is_groupname
end variables

forward prototypes
public subroutine wf_gui ()
end prototypes

public subroutine wf_gui ();//Set GUI



IF uo_global.ii_user_profile = 4 THEN
	//DEVELOPER
	dw_group.Object.Datawindow.ReadOnly="yes"
	
	cb_new.enabled = false
	cb_delete.enabled = false
	cb_update.enabled = false
	cb_cancel.enabled = false
	
elseif uo_global.ii_user_profile = 5 THEN
	cb_new.enabled = true
	cb_delete.enabled = true
	cb_update.enabled = true
	cb_cancel.enabled = true
	
end if



end subroutine

on w_user_groups.create
int iCurrent
call super::create
this.uo_search=create uo_search
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_group=create dw_group
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_new
this.Control[iCurrent+6]=this.dw_group
end on

on w_user_groups.destroy
call super::destroy
destroy(this.uo_search)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_group)
end on

event open;call super::open;n_service_manager lnv_servicemgr
n_dw_style_service lnv_style
 
lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
 
lnv_style.of_dwlistformater(dw_group, false)
dw_group.retrieve()

uo_search.of_initialize(dw_group, "GROUP_ID+'#'+GROUP_NAME")
uo_search.sle_search.setfocus()
wf_gui()
end event

event closequery;call super::closequery;dw_group.accepttext()
If dw_group.deletedcount() + dw_group.modifiedcount() > 0 then
	If Messagebox("Updates Pending","Data is modified but not saved. Would you like to update the changes before closing?", Question!, YesNo!) = 2 then Return 1
	cb_update.event clicked()
End If
end event

type uo_search from u_searchbox within w_user_groups
integer x = 37
integer y = 16
integer width = 914
integer taborder = 10
end type

on uo_search.destroy
call u_searchbox::destroy
end on

type cb_cancel from mt_u_commandbutton within w_user_groups
integer x = 1097
integer y = 1440
integer taborder = 60
string text = "&Cancel"
end type

event clicked;call super::clicked;dw_group.retrieve()
cb_new.enabled = true
cb_new.default = true
cb_delete.enabled = cb_new.enabled
cb_update.enabled = cb_new.enabled
cb_cancel.enabled = cb_new.enabled
end event

type cb_update from mt_u_commandbutton within w_user_groups
integer x = 402
integer y = 1440
integer taborder = 40
string text = "&Update"
end type

event clicked;call super::clicked;long ll_rc, i, ll_find
string ls_search_condition
n_ds_useradmin lds_user
lds_user = create n_ds_useradmin
lds_user.dataobject =dw_group.dataobject
dw_group.accepttext()
for i = 1 to dw_group.rowcount()
	
	if isnull(dw_group.getitemnumber(i, "group_id")) or dw_group.getitemnumber(i, "group_id") = 0  then
		MessageBox("Validation Error", "Please set the group ID.")
		dw_group.selectrow(0,false)
		dw_group.selectrow(i,true)
		return
	end if
	
	if isnull(dw_group.getitemstring(i, "group_name")) or dw_group.getitemstring(i, "group_name")=''   then
		messagebox("Validation Error", "Please set the group name.")
		dw_group.selectrow(0,false)
		dw_group.selectrow(i,true)
		return
	end if
next
lds_user.settransobject(sqlca)
lds_user.retrieve()
ls_search_condition = "group_id = "+ string(il_groupid) 
ll_find = lds_user.find(ls_search_condition,1,lds_user.rowcount())

if ll_find > 0 then
	messagebox("Update Error","The group ID  you entered already exists. Update failed.")
	return -1
end if

ls_search_condition = "group_name = '"+ is_groupname +"'" 
ll_find = lds_user.find(ls_search_condition,1,lds_user.rowcount())
if ll_find > 0 then
	messagebox("Update Error","The group name  you entered already exists. Update failed.")
	return -1
end if

ll_rc = dw_group.update(true, false)
if ll_rc < 0 then
	rollback;
	messagebox("Update Error","User groups update failed.")
	return -1
end if
commit; 
dw_group.resetupdate()

cb_new.default = true 
cb_update.enabled = true
cb_cancel.enabled = true
cb_new.enabled = true
cb_delete.enabled = true

end event

type cb_delete from mt_u_commandbutton within w_user_groups
integer x = 750
integer y = 1440
integer taborder = 50
string text = "&Delete"
end type

event clicked;call super::clicked;Long ll_rc, ll_rowcount
int ll_groupid
if dw_group.getselectedrow(0) <= 0 then return
ll_groupid = dw_group.getitemnumber(dw_group.getselectedrow(0),'group_id')
If Messagebox("Deleting!","You are about to delete a User Groups.~r~nDo you wish to continue?", Question!, YesNo!, 2) = 2 Then Return
select count(1) 
into :ll_rowcount
from USERS
where USER_GROUP =:ll_groupid;
if ll_rowcount > 0 then
	messagebox("Delete","You cannot delete this user group, because it has been used.")
	return
end if

ll_rc = dw_group.deleterow(dw_group.getselectedrow(0))

if ll_rc > 0 then ll_rc = dw_group.update()
If ll_rc < 0 Then
	rollback;
	Messagebox("Update Error","Data is not updated. This could be due to the user group being used in other places in the system.")
	return
Else
	commit;
End IF
end event

type cb_new from mt_u_commandbutton within w_user_groups
integer x = 55
integer y = 1440
integer taborder = 30
string text = "&New"
end type

event clicked;call super::clicked;long ll_row
ll_row = dw_group.insertrow(0)
dw_group.selectrow(0,false)
dw_group.selectrow(ll_row,true)
dw_group.scrolltorow(ll_row)
dw_group.post setFocus()

cb_new.enabled = false
cb_delete.enabled = false
cb_update.enabled = true
cb_cancel.enabled = true
cb_update.default = true

end event

type dw_group from u_datagrid within w_user_groups
integer x = 37
integer y = 192
integer width = 1408
integer height = 1232
integer taborder = 20
string dataobject = "d_sp_gr_group"
boolean vscrollbar = true
boolean border = false
boolean ib_multiselect = true
end type

event editchanged;call super::editchanged;//
choose case dwo.name
	case "group_id"
		  il_groupid = long(data)
		  
	case "group_name"
		 is_groupname = data
end choose
end event

