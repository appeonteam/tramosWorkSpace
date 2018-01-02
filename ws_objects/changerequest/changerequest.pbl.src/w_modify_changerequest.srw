$PBExportHeader$w_modify_changerequest.srw
forward
global type w_modify_changerequest from mt_w_sheet
end type
type tab_request from tab within w_modify_changerequest
end type
type tabpage_details from userobject within tab_request
end type
type cb_cancel from mt_u_commandbutton within tabpage_details
end type
type dw_request from mt_u_datawindow within tabpage_details
end type
type cb_print from mt_u_commandbutton within tabpage_details
end type
type cb_email from mt_u_commandbutton within tabpage_details
end type
type uo_att from u_fileattach within tabpage_details
end type
type cb_update from mt_u_commandbutton within tabpage_details
end type
type tabpage_details from userobject within tab_request
cb_cancel cb_cancel
dw_request dw_request
cb_print cb_print
cb_email cb_email
uo_att uo_att
cb_update cb_update
end type
type tabpage_history from userobject within tab_request
end type
type dw_detail from u_datagrid within tabpage_history
end type
type dw_status from u_datagrid within tabpage_history
end type
type dw_history from u_datagrid within tabpage_history
end type
type tabpage_history from userobject within tab_request
dw_detail dw_detail
dw_status dw_status
dw_history dw_history
end type
type tabpage_task from userobject within tab_request
end type
type cb_mailsupport from mt_u_commandbutton within tabpage_task
end type
type cb_task_print from mt_u_commandbutton within tabpage_task
end type
type cb_canceltask from mt_u_commandbutton within tabpage_task
end type
type cb_import from mt_u_commandbutton within tabpage_task
end type
type uo_taskatt from u_fileattach within tabpage_task
end type
type dw_task from mt_u_datawindow within tabpage_task
end type
type cb_newtask from mt_u_commandbutton within tabpage_task
end type
type cb_updatetask from mt_u_commandbutton within tabpage_task
end type
type cb_deletetask from mt_u_commandbutton within tabpage_task
end type
type dw_devobject from u_datagrid within tabpage_task
end type
type gb_objects from mt_u_groupbox within tabpage_task
end type
type gb_taskdetails from mt_u_groupbox within tabpage_task
end type
type gb_attachments from mt_u_groupbox within tabpage_task
end type
type tabpage_task from userobject within tab_request
cb_mailsupport cb_mailsupport
cb_task_print cb_task_print
cb_canceltask cb_canceltask
cb_import cb_import
uo_taskatt uo_taskatt
dw_task dw_task
cb_newtask cb_newtask
cb_updatetask cb_updatetask
cb_deletetask cb_deletetask
dw_devobject dw_devobject
gb_objects gb_objects
gb_taskdetails gb_taskdetails
gb_attachments gb_attachments
end type
type tabpage_time_reg from userobject within tab_request
end type
type cb_canceltimereg from mt_u_commandbutton within tabpage_time_reg
end type
type cb_refresh from mt_u_commandbutton within tabpage_time_reg
end type
type cb_newtimereg from mt_u_commandbutton within tabpage_time_reg
end type
type cb_updatetimereg from mt_u_commandbutton within tabpage_time_reg
end type
type cb_deletetimereg from mt_u_commandbutton within tabpage_time_reg
end type
type dw_time_reg from u_datagrid within tabpage_time_reg
end type
type tabpage_time_reg from userobject within tab_request
cb_canceltimereg cb_canceltimereg
cb_refresh cb_refresh
cb_newtimereg cb_newtimereg
cb_updatetimereg cb_updatetimereg
cb_deletetimereg cb_deletetimereg
dw_time_reg dw_time_reg
end type
type tab_request from tab within w_modify_changerequest
tabpage_details tabpage_details
tabpage_history tabpage_history
tabpage_task tabpage_task
tabpage_time_reg tabpage_time_reg
end type
end forward

global type w_modify_changerequest from mt_w_sheet
integer x = 471
integer y = 48
integer width = 4562
integer height = 2544
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
event ue_taskinit ( )
tab_request tab_request
end type
global w_modify_changerequest w_modify_changerequest

type variables
long il_requestid
integer ii_ext_argument
blob	ibl_doc[]

string is_firstname
n_creq_request inv_request
boolean ib_isopened

constant string is_NEW = "new"
constant integer ii_DEV_DELIVERED = 8
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_updatespending ()
public function long wf_insert_taskobject (mt_n_datastore ads_saw_import, long al_row)
private subroutine _setpermission (string as_operation, mt_u_datawindow adw_request)
private subroutine _readonly (mt_u_datawindow adw_request, boolean ab_switch)
end prototypes

public subroutine documentation ();/********************************************************************
   w_modify_request
   <OBJECT>		Modify change request	</OBJECT>
   <USAGE>					</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	04-08-2011 2438         JMY014             First Version
		15-08-2011 2438         RJH022             add new column costsaving_id
		23-08-2012 2917			AGL027				 add additional permissions BU 23 (hardcoded!!)	
		09-01-2013 2614			LGH008				 Change GUI, add new tab Task and Time Registration,
																 add Priority Rank, Project, Send Email...
		06/06/2013 2614			AGL027				Modified validation on Hours column using dwvalidator			
		15/07/2013 CR3254			LHG008		  		1. New access rights; 2. Fix stuff related with Initial status
		15/08/2013 CR3306			WWA048		  		Add new "Print Task" button in Task tab
		11/06/2015 CR4041       LHG008            Change logic in sending email to support team
		05/09/2016 CR3754			AGL027				Single Sign On modifications - support Become User feature
   </HISTORY>
********************************************************************/
end subroutine

public function integer wf_updatespending ();/********************************************************************
   wf_updatespending
   <DESC>	Check whether data is modified or not	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Ref:event closequery()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		05-15-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

//Details
tab_request.tabpage_details.dw_request.accepttext()
tab_request.tabpage_details.uo_att.dw_file_listing.accepttext()
if tab_request.tabpage_details.dw_request.modifiedcount() + tab_request.tabpage_details.uo_att.dw_file_listing.modifiedcount() &
		+ tab_request.tabpage_details.uo_att.dw_file_listing.deletedcount() > 0 then
	tab_request.selecttab(tab_request.tabpage_details)
	if MessageBox("Change Request Updates Pending", "Details data has been changed, but not saved. ~r~rWould you like to save data?", question!, YesNo!, 1) = 1 then		
		if tab_request.tabpage_details.cb_update.event clicked() = c#return.Failure then
			return c#return.Failure
		end if
	end if
end if

//Task
if tab_request.tabpage_task.enabled then
	tab_request.tabpage_task.dw_task.accepttext()
	tab_request.tabpage_task.dw_devobject.accepttext()
	tab_request.tabpage_task.uo_taskatt.dw_file_listing.accepttext()
	if tab_request.tabpage_task.dw_task.modifiedcount() + tab_request.tabpage_task.dw_task.deletedcount() &
			+ tab_request.tabpage_task.dw_devobject.modifiedcount() + tab_request.tabpage_task.dw_devobject.deletedcount() &
			+ tab_request.tabpage_task.uo_taskatt.dw_file_listing.modifiedcount() + tab_request.tabpage_task.uo_taskatt.dw_file_listing.deletedcount() > 0 	 then
		tab_request.selecttab(tab_request.tabpage_task)
		if MessageBox("Change Request Updates Pending", "Task data has been changed, but not saved. ~r~n~r~nWould you like to save data?", question!, YesNo!, 1) = 1 then		
			if tab_request.tabpage_task.cb_updatetask.event clicked() = c#return.Failure then
				return c#return.Failure
			end if
		end if
	end if
end if

//Time Registration
if tab_request.tabpage_time_reg.enabled then
	tab_request.tabpage_time_reg.dw_time_reg.accepttext()
	if tab_request.tabpage_time_reg.dw_time_reg.modifiedcount() + tab_request.tabpage_time_reg.dw_time_reg.deletedcount() > 0 then
		tab_request.selecttab(tab_request.tabpage_time_reg)
		if MessageBox("Change Request Updates Pending", "Time Registration data has been changed, but not saved. ~r~n~r~nWould you like to save data?", question!, YesNo!, 1) = 1 then
			if tab_request.tabpage_time_reg.cb_updatetimereg.event clicked() = c#return.Failure then
				return c#return.Failure
			end if
		end if
	end if
end if

return c#return.Success
end function

public function long wf_insert_taskobject (mt_n_datastore ads_saw_import, long al_row);/********************************************************************
   wf_insert_taskobject
   <DESC>	Insert data into task object datawindow	</DESC>
   <RETURN>	long: row number of inserted	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_saw_import:
		al_row:
   </ARGS>
   <USAGE>	Ref:cb_import.clicked()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		05-23-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

u_datagrid dw_devobject
long ll_row, ll_action
string ls_action, ls_objectname, ls_libraryname

dw_devobject = tab_request.tabpage_task.dw_devobject

ll_row = dw_devobject.insertrow(0)

//Match action type
ls_action = lower(ads_saw_import.getitemstring(al_row, "action"))
if left(ls_action, 7) = "added" then
	ll_action = 1	//New
elseif left(ls_action, 10) = "checked in" then
	ll_action = 2	//Modified
elseif left(ls_action, 7) = "deleted" then
	ll_action = 3	//Deleted
else
	ll_action = 4	//Other
end if

ls_objectname = ads_saw_import.getitemstring(al_row, "objectname")

dw_devobject.setitem(ll_row, "request_id", il_requestid)
dw_devobject.setitem(ll_row, "actiontype", ll_action)
dw_devobject.setitem(ll_row, "objectname", ls_objectname)
dw_devobject.setitem(ll_row, "lastversion", ads_saw_import.getitemnumber(al_row, "lastversion"))
dw_devobject.setitem(ll_row, "comment", ads_saw_import.getitemstring(al_row, "comment"))

//Try to find library name and then set it into Library column
ls_libraryname = inv_request.of_find_libraryname(ls_objectname)
dw_devobject.setitem(ll_row, "library", ls_libraryname)

return ll_row
end function

private subroutine _setpermission (string as_operation, mt_u_datawindow adw_request);/********************************************************************
   _setpermission
   <DESC>Set access right for fields in detial tab</DESC>
   <RETURN>	(none):</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_operation: 'New' or else
		adw_request
   </ARGS>
   <USAGE>open window</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	15-04-2013 CR2614       LHC010        First Version
		09/07/2013 CR3254			LHG008		  New access rights
   </HISTORY>
********************************************************************/

string	ls_owner, ls_create_by
boolean	lb_dev_checked, lb_bso_checked

if adw_request.rowcount() <> 1 then return

//external_partners, external_apm
if uo_global.ii_access_level < 0 then
	_readonly(adw_request, true)
	return
end if

lb_dev_checked = inv_request.istr_parm.b_bu_dev
lb_bso_checked = inv_request.istr_parm.b_bu_bso

ls_owner			= adw_request.getitemstring(1, "owner")
ls_create_by	= adw_request.getitemstring(1, "created_by")

adw_request.settaborder("bu_id", 0)
adw_request.settaborder("owner", 0)
adw_request.settaborder("assigned_to", 0)
adw_request.settaborder("status_id", 0)
adw_request.settaborder("project_id", 0)
adw_request.settaborder("input_est_hrs_min", 0)
adw_request.settaborder("input_est_hrs_max", 0)
adw_request.settaborder("change_desc", 0)
adw_request.settaborder("solution_desc", 0)
adw_request.settaborder("release_version", 0)
adw_request.settaborder("user_doc_updated", 0)
adw_request.settaborder("rejection_desc", 0)

if as_operation = is_NEW then //new
	if lb_dev_checked or lb_bso_checked then
		adw_request.settaborder("bu_id", 40)
		adw_request.settaborder("owner", 50)
	end if
else //modify
	if lb_dev_checked or lb_bso_checked then
		adw_request.settaborder("bu_id", 40)
		adw_request.settaborder("owner", 50)
		adw_request.settaborder("status_id", 70)
		adw_request.settaborder("project_id", 80)
		adw_request.settaborder("rejection_desc", 150)
		if lb_dev_checked then
			adw_request.settaborder("assigned_to", 60)
			adw_request.settaborder("input_est_hrs_min", 100)
			adw_request.settaborder("input_est_hrs_max", 110)
			adw_request.settaborder("change_desc", 141)
			adw_request.settaborder("solution_desc", 142)
			adw_request.settaborder("release_version", 120)
		end if
		
		if lb_bso_checked then
			adw_request.settaborder("user_doc_updated", 130)
		end if
	elseif ls_owner = uo_global.is_userid or ls_create_by = uo_global.is_userid then
		adw_request.settaborder("owner", 50)
	end if
end if
end subroutine

private subroutine _readonly (mt_u_datawindow adw_request, boolean ab_switch);/********************************************************************
   _readonly
   <DESC></DESC>
   <RETURN>	None):
	</RETURN>
   <ACCESS>Private</ACCESS>
   <ARGS>
		adw_request
		ab_switch
   </ARGS>
   <USAGE>_setpermission</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-04-2013 CR2614       LHC010        First Version
   </HISTORY>
********************************************************************/

if ab_switch then
	adw_request.object.datawindow.readonly= 'Yes'	
else
	adw_request.object.datawindow.readonly= 'No'
end if
tab_request.tabpage_details.cb_update.enabled = not ab_switch
tab_request.tabpage_details.cb_cancel.enabled = not ab_switch
tab_request.tabpage_details.uo_att.event ue_readonly(ab_switch)

end subroutine

on w_modify_changerequest.create
int iCurrent
call super::create
this.tab_request=create tab_request
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_request
end on

on w_modify_changerequest.destroy
call super::destroy
destroy(this.tab_request)
end on

event open;long 					ll_row, ll_found, ll_statusid
datawindowchild	ldwc
int 					li_bu_id
long ll_module_id, ll_submodule_id, ll_pre_requestid
string ls_operation
mt_u_datawindow ldw_request

if not ib_isopened then
	call super::open
end if

if not isvalid(inv_request) then
	inv_request = create n_creq_request
end if

inv_request.istr_parm = message.powerobjectparm

if isvalid(inv_request.istr_parm) then
	ls_operation = lower(inv_request.istr_parm.operation)
	if ls_operation = is_NEW then
		setnull(inv_request.istr_parm.request_id)
	end if
	ll_pre_requestid = il_requestid
	il_requestid = inv_request.istr_parm.request_id
	li_bu_id = inv_request.istr_parm.bu_id
	tab_request.tabpage_task.visible = inv_request.istr_parm.b_bu_dev
	tab_request.tabpage_time_reg.visible = inv_request.istr_parm.bu_controltimereg	
else
	close(this)
	messagebox("Error","Failed to open CR details window.")
	return
end if

ldw_request = tab_request.tabpage_details.dw_request
ldw_request.dataobject = "d_sq_ff_request"
ldw_request.settransobject(SQLCA)

if ls_operation = is_NEW then
	this.title = "Create New Request"
	
	tab_request.selecttab(tab_request.tabpage_details)
	
	ldw_request.retrieve(0)
	ll_row = ldw_request.insertrow(0)
	if ll_row < 1 then return
	
	/* Initial Values */
	ldw_request.setItem(ll_row, "create_date", today())
	ldw_request.setItem(ll_row, "created_by", SQLCA.userid)
	ldw_request.setItem(ll_row, "owner", SQLCA.userid)
	ldw_request.setItem(ll_row, "last_edit_date", today())
	ldw_request.setItem(ll_row, "last_edit_by", SQLCA.userid)
	ldw_request.setItem(ll_row, "status_id", inv_request.il_initial_statusid)
	ldw_request.setItem(ll_row, "bu_id", li_bu_id)
	
	/* Find and set initial Priority */
	ldw_request.getchild("priority_id", ldwc)
	ll_found = ldwc.find("initial_priority=1",1,999)
	if ll_found > 0 then 
		ldw_request.setItem(ll_row, "priority_id", ldwc.getitemnumber(ll_found, "priority_id"))
	end if
	
	tab_request.tabpage_details.uo_att.of_init(0)
	
	tab_request.tabpage_details.cb_email.enabled = false
	tab_request.tabpage_history.enabled = false
	tab_request.tabpage_task.enabled = false
	tab_request.tabpage_time_reg.enabled = false
else
	this.title = "Modify Request #"+string(il_requestid)
	
	ldw_request.retrieve(il_requestid)	
	tab_request.tabpage_details.uo_att.of_init(il_requestid)
	
	//Initial and retrieve history
	tab_request.tabpage_history.dw_history.settransobject(SQLCA)
	tab_request.tabpage_history.dw_status.settransobject(SQLCA)
	tab_request.tabpage_history.dw_detail.settransobject(SQLCA)
	
	if ib_isopened then
		tab_request.tabpage_history.dw_history.reset()
		tab_request.tabpage_history.dw_status.reset()
		tab_request.tabpage_history.dw_detail.reset()
	end if
	
	tab_request.tabpage_history.dw_status.retrieve(il_requestid)
	tab_request.tabpage_history.dw_history.retrieve(il_requestid)
	
	tab_request.tabpage_history.enabled = true
	tab_request.tabpage_details.cb_email.enabled = true
	
	/* Initial task */
	if tab_request.tabpage_task.visible and (isnull(ll_pre_requestid) or il_requestid <> ll_pre_requestid) then
		tab_request.tabpage_task.dw_task.settransobject(SQLCA)
		tab_request.tabpage_task.dw_task.retrieve(il_requestid)
		
		tab_request.tabpage_task.dw_devobject.settransobject(SQLCA)
		tab_request.tabpage_task.dw_devobject.retrieve(il_requestid)
		
		tab_request.tabpage_task.uo_taskatt.of_init(il_requestid)
		tab_request.tabpage_task.enabled = true
	end if
	
	/* Initial Time Registration */
	if tab_request.tabpage_time_reg.visible and (isnull(ll_pre_requestid) or il_requestid <> ll_pre_requestid) then
		tab_request.tabpage_time_reg.dw_time_reg.settransobject(SQLCA)
		tab_request.tabpage_time_reg.dw_time_reg.retrieve(il_requestid)
		
		tab_request.tabpage_time_reg.dw_time_reg.scrolltorow(tab_request.tabpage_time_reg.dw_time_reg.rowcount())
		tab_request.tabpage_time_reg.enabled = true
	end if
end if

inv_request.of_typecontrol(ldw_request)
inv_request.of_filterstatus(ldw_request)

//Filter out all inactive module or sub module
/* Initial Module */
ldw_request.getchild("module_id", ldwc)
ldwc.settransobject(SQLCA)
ll_module_id = ldw_request.getitemnumber(1, "module_id")
if ll_module_id > 0 then
	ldwc.setfilter("module_active=1 or module_id=" + string(ll_module_id))
else
	ldwc.setfilter("module_active=1")
end if
ldwc.filter()

/* Initial SUB-Module */
ldw_request.getchild("submodule_id", ldwc)
ldwc.settransobject(SQLCA)
ldwc.retrieve(ldw_request.getitemnumber(1, "module_id"), 1)

ll_submodule_id = ldw_request.getitemnumber(1, "submodule_id")
if ll_submodule_id > 0 then
	ldwc.setfilter("sub_module_active=1 or submodule_id=" + string(ll_submodule_id))
else
	ldwc.setfilter("sub_module_active=1")
end if
ldwc.filter()
ldwc.insertrow(1)

/* Initial Porject*/
ldw_request.getchild("project_id", ldwc)
ldwc.insertrow(1)

_setpermission(ls_operation, ldw_request)

ldw_request.post setFocus()

ldw_request.setitemstatus( 1, 0, primary!, notmodified!)

ib_isopened = true
end event

event closequery;call super::closequery;if inv_request.ib_isusing then return 1

if wf_updatespending() = c#return.Failure then
	return 1
end if

if isvalid(inv_request) then destroy inv_request
return 0

end event

event activate;call super::activate;if w_tramos_main.MenuName <> "m_creqmain" then
	w_tramos_main.ChangeMenu(m_creqmain)
	m_creqmain.mf_controlreport()
end if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_modify_changerequest
end type

type tab_request from tab within w_modify_changerequest
integer x = 37
integer y = 16
integer width = 4498
integer height = 2432
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_details tabpage_details
tabpage_history tabpage_history
tabpage_task tabpage_task
tabpage_time_reg tabpage_time_reg
end type

on tab_request.create
this.tabpage_details=create tabpage_details
this.tabpage_history=create tabpage_history
this.tabpage_task=create tabpage_task
this.tabpage_time_reg=create tabpage_time_reg
this.Control[]={this.tabpage_details,&
this.tabpage_history,&
this.tabpage_task,&
this.tabpage_time_reg}
end on

on tab_request.destroy
destroy(this.tabpage_details)
destroy(this.tabpage_history)
destroy(this.tabpage_task)
destroy(this.tabpage_time_reg)
end on

type tabpage_details from userobject within tab_request
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 4462
integer height = 2316
long backcolor = 67108864
string text = "Details"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_cancel cb_cancel
dw_request dw_request
cb_print cb_print
cb_email cb_email
uo_att uo_att
cb_update cb_update
end type

on tabpage_details.create
this.cb_cancel=create cb_cancel
this.dw_request=create dw_request
this.cb_print=create cb_print
this.cb_email=create cb_email
this.uo_att=create uo_att
this.cb_update=create cb_update
this.Control[]={this.cb_cancel,&
this.dw_request,&
this.cb_print,&
this.cb_email,&
this.uo_att,&
this.cb_update}
end on

on tabpage_details.destroy
destroy(this.cb_cancel)
destroy(this.dw_request)
destroy(this.cb_print)
destroy(this.cb_email)
destroy(this.uo_att)
destroy(this.cb_update)
end on

type cb_cancel from mt_u_commandbutton within tabpage_details
integer x = 4096
integer y = 2188
integer taborder = 80
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;message.powerobjectparm = inv_request.istr_parm
w_modify_changerequest.event open()
end event

type dw_request from mt_u_datawindow within tabpage_details
integer x = 23
integer y = 20
integer width = 4416
integer height = 2152
integer taborder = 20
string dataobject = "d_sq_ff_request"
boolean border = false
end type

event itemchanged;datawindowchild	ldwc
long					ll_null, ll_found, ll_statusid, ll_typeid, ll_inputest
string					ls_message, ls_type, ls_estunit

if row < 1 then return
choose case dwo.name
	case "module_id"
		if isnull(dwo.primary[row]) or string(dwo.primary[row]) <> data then
			setnull(ll_null)
			this.accepttext()
			this.setitem(row, "submodule_id", ll_null)
			this.getchild("submodule_id", ldwc)
			ldwc.settransobject(sqlca)
			ldwc.retrieve(this.getitemnumber(row, "module_id"), 1)
			ldwc.insertrow(1)
		end if
	case 'type_id'
		ll_typeid = long(data)
		//Check the availablity of initial status 
		SELECT count(1) INTO :ll_found FROM CREQ_TYPE_STATUS
		WHERE TYPE_ID = :ll_typeid AND STATUS_ID = :inv_request.il_initial_statusid;
		
		if ll_found = 0 then
			ll_typeid = this.getitemnumber(row, "type_id")
			if isnull(ll_typeid) then
				ls_type = ''
				ls_message = "Sorry not possible to select the Type due to default '" + inv_request.is_initial_statusname + "' status not being available."
			else
				ls_type = string(ll_typeid)
				ls_message = "Sorry not possible to switch to your selected Type due to default '" + inv_request.is_initial_statusname + "' status not being available."
			end if
			
			messagebox("Infomation", ls_message)
			this.settext(ls_type)
			return 2
		end if
		//Filter status
		inv_request.post of_filterstatus(dw_request)
		
	case "input_est_hrs_min"
		ls_estunit = this.object.est_hrs_min_t.Text
		ll_inputest = long(data)
		if data = '0'  then setnull(ll_inputest)
			
		choose case ls_estunit
			case "Estimated man-hrs"
				this.setitem(1, "est_hrs_min", ll_inputest)
			case "Estimated man-dys"
					this.setitem(1, "est_hrs_min", ll_inputest*8)
			case "Estimated man-wks"
					this.setitem(1, "est_hrs_min", ll_inputest*40)
			case "Estimated man-mths"
					this.setitem(1, "est_hrs_min", ll_inputest*160)
		end choose
	case "input_est_hrs_max"
		ls_estunit = this.object.est_hrs_min_t.Text
		ll_inputest =  long(data)
		if data = '0'  then setnull(ll_inputest)
		
		choose case ls_estunit
			case "Estimated man-hrs"
				this.setitem(1, "est_hrs_max", ll_inputest)
			case "Estimated man-dys"
					this.setitem(1, "est_hrs_max", ll_inputest*8)
			case "Estimated man-wks"
					this.setitem(1, "est_hrs_max", ll_inputest*40)		
			case "Estimated man-mths"
					this.setitem(1, "est_hrs_max", ll_inputest*160)			
		end choose		
end choose
end event

event doubleclicked;call super::doubleclicked;string 	ls_estunit
long 		ll_estminhours, ll_estmaxhours

if dwo.name = "est_hrs_min_t" then
	if this.accepttext() <> 1 then return
	
	ls_estunit = this.object.est_hrs_min_t.Text

	ll_estminhours = this.getitemnumber(1, "est_hrs_min")
	ll_estmaxhours = this.getitemnumber(1, "est_hrs_max")
	if ll_estminhours > 0 then
		this.modify("input_est_hrs_min.editmask.mask = '####,##0'")
	else
		this.modify("input_est_hrs_min.editmask.mask = '####,###'")
	end if
	if ll_estmaxhours > 0 then
		this.modify("input_est_hrs_max.editmask.mask = '####,##0'")
	else
		this.modify("input_est_hrs_max.editmask.mask = '####,###'")
	end if
	
	choose case ls_estunit
		case "Estimated man-hrs"
			this.setitem(1, "input_est_hrs_min", round(ll_estminhours/8,0))
			this.setitem(1, "input_est_hrs_max", round(ll_estmaxhours/8,0))
			this.object.est_hrs_min_t.Text = 'Estimated man-dys'
		case "Estimated man-dys"
			this.setitem(1, "input_est_hrs_min", round(ll_estminhours/40,0))
			this.setitem(1, "input_est_hrs_max", round(ll_estmaxhours/40,0))
			this.object.est_hrs_min_t.Text = 'Estimated man-wks'
		case "Estimated man-wks"
			this.setitem(1, "input_est_hrs_min", round(ll_estminhours/160,0))
			this.setitem(1, "input_est_hrs_max", round(ll_estmaxhours/160,0))
			this.object.est_hrs_min_t.Text = 'Estimated man-mths'
		case "Estimated man-mths"
			this.setitem(1, "input_est_hrs_min", ll_estminhours)
			this.setitem(1, "input_est_hrs_max", ll_estmaxhours)
			this.object.est_hrs_min_t.Text = 'Estimated man-hrs'
	end choose
end if 

this.setitemstatus(1, "input_est_hrs_min", Primary!, NotModified!)
this.setitemstatus(1, "input_est_hrs_max", Primary!, NotModified!)
end event

event editchanged;call super::editchanged;long ll_input_est

setnull(ll_input_est)
choose case dwo.name
	case 'input_est_hrs_min'
		this.modify("input_est_hrs_min.editmask.mask = '####,###'")
		if data = '0' or data = '' then this.setitem(row,'est_hrs_min',ll_input_est)
	case 'input_est_hrs_max'
		this.modify("input_est_hrs_max.editmask.mask = '####,###'")
		if data = '0' or data = '' then this.setitem(row,'est_hrs_max',ll_input_est)
end choose

end event

type cb_print from mt_u_commandbutton within tabpage_details
integer x = 3749
integer y = 2188
integer taborder = 60
boolean bringtotop = true
string text = "&Print"
end type

event clicked;long		ll_row
string	ls_request_id

ll_row = dw_request.getrow()
if ll_row < 1 then return

dw_request.accepttext()
uo_att.dw_file_listing.accepttext()

if dw_request.modifiedcount() + uo_att.dw_file_listing.modifiedcount() + uo_att.dw_file_listing.deletedcount() > 0 then
	if MessageBox("Confirmation", "Data changed but not saved. Print anyway?", question!, YesNo!, 2) = 2 then
		return
	end if
end if

ls_request_id = string(dw_request.getitemnumber(ll_row, "request_id"))

opensheetwithparm(w_print_request, ls_request_id, parentwindow(), 0, original!)
dw_request.post setfocus()
end event

type cb_email from mt_u_commandbutton within tabpage_details
integer x = 3401
integer y = 2188
integer taborder = 50
boolean bringtotop = true
string text = "Send Email"
end type

event clicked;string ls_return
integer li_row

li_row = dw_request.getrow()

if li_row <= 0 or isnull(il_requestid) then return

openwithparm(w_request_email, dw_request, w_modify_changerequest)

end event

type uo_att from u_fileattach within tabpage_details
event destroy ( )
event ue_readonly ( boolean ab_readonly )
integer x = 1536
integer y = 1708
integer width = 2871
integer height = 448
integer taborder = 30
boolean bringtotop = true
string is_dataobjectname = "d_sq_tb_creq_file_listing"
string is_counterlabel = "Files:"
boolean ib_allow_dragdrop = true
end type

on uo_att.destroy
call u_fileattach::destroy
end on

event ue_readonly(boolean ab_readonly);/********************************************************************
   ue_readonly
   <DESC>	Set the uo_att to readonly	or editable</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_readonly: if true then set to readonly else editable
   </ARGS>
   <USAGE>	Window open	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		02-26-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

if ab_readonly  then
	uo_att.dw_file_listing.object.datawindow.readonly = 'Yes'
	uo_att.dw_file_listing.modify("t_updatefile.visible='1~t0'")
	uo_att.pb_new.enabled = false
	uo_att.pb_delete.enabled = false
	uo_att.pb_cancel.enabled = false
else
	uo_att.dw_file_listing.object.datawindow.readonly = 'no'
	uo_att.dw_file_listing.modify("t_updatefile.visible='1~t1'")
	uo_att.pb_new.enabled = true
	uo_att.pb_delete.enabled = true
	uo_att.pb_cancel.enabled = true
end if

end event

type cb_update from mt_u_commandbutton within tabpage_details
integer x = 3054
integer y = 2188
integer taborder = 40
string text = "&Update"
end type

event clicked;n_creq_request	 lnv_request
long ll_request_id

ll_request_id = inv_request.of_update(dw_request) 

if ll_request_id >= 1 then
	
	uo_att.of_setlongarg(ll_request_id)
	uo_att.of_updateattach()
	
	if inv_request.of_order_seq(dw_request) = c#return.Failure then
		messagebox("Error","Some problem with update of sequential numbers.")
	end if
	
	if isvalid(w_changerequest) then	
		w_changerequest.event ue_refresh_all_rows(il_requestid)
	end if
	
	inv_request.istr_parm.request_id = ll_request_id
	inv_request.istr_parm.operation = "modify"
	
	message.powerobjectparm = inv_request.istr_parm
	w_modify_changerequest.event open()
	return c#return.Success
end if

dw_request.post setfocus()
return c#return.Failure
end event

type tabpage_history from userobject within tab_request
integer x = 18
integer y = 100
integer width = 4462
integer height = 2316
long backcolor = 67108864
string text = "History"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_detail dw_detail
dw_status dw_status
dw_history dw_history
end type

on tabpage_history.create
this.dw_detail=create dw_detail
this.dw_status=create dw_status
this.dw_history=create dw_history
this.Control[]={this.dw_detail,&
this.dw_status,&
this.dw_history}
end on

on tabpage_history.destroy
destroy(this.dw_detail)
destroy(this.dw_status)
destroy(this.dw_history)
end on

event constructor;n_dw_style_service   lnv_style
n_service_manager		lnv_servicemgr

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_history, false)
lnv_style.of_dwlistformater(dw_status, false)

end event

type dw_detail from u_datagrid within tabpage_history
integer x = 32
integer y = 1016
integer width = 4389
integer height = 1152
integer taborder = 110
string dataobject = "d_history_log_detail"
boolean vscrollbar = true
boolean border = false
end type

type dw_status from u_datagrid within tabpage_history
integer x = 2610
integer y = 24
integer width = 1810
integer height = 960
integer taborder = 100
string dataobject = "d_status_log"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

event ue_clicked;call super::ue_clicked;if row > 0 then
	event rowfocuschanged(row)
end if
end event

type dw_history from u_datagrid within tabpage_history
integer x = 32
integer y = 24
integer width = 2542
integer height = 960
integer taborder = 90
string dataobject = "d_history_log"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
	dw_detail.retrieve(this.getitemnumber(currentrow, "log_id"))
end if
end event

type tabpage_task from userobject within tab_request
event create ( )
event destroy ( )
boolean visible = false
integer x = 18
integer y = 100
integer width = 4462
integer height = 2316
long backcolor = 67108864
string text = "Task"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_mailsupport cb_mailsupport
cb_task_print cb_task_print
cb_canceltask cb_canceltask
cb_import cb_import
uo_taskatt uo_taskatt
dw_task dw_task
cb_newtask cb_newtask
cb_updatetask cb_updatetask
cb_deletetask cb_deletetask
dw_devobject dw_devobject
gb_objects gb_objects
gb_taskdetails gb_taskdetails
gb_attachments gb_attachments
end type

on tabpage_task.create
this.cb_mailsupport=create cb_mailsupport
this.cb_task_print=create cb_task_print
this.cb_canceltask=create cb_canceltask
this.cb_import=create cb_import
this.uo_taskatt=create uo_taskatt
this.dw_task=create dw_task
this.cb_newtask=create cb_newtask
this.cb_updatetask=create cb_updatetask
this.cb_deletetask=create cb_deletetask
this.dw_devobject=create dw_devobject
this.gb_objects=create gb_objects
this.gb_taskdetails=create gb_taskdetails
this.gb_attachments=create gb_attachments
this.Control[]={this.cb_mailsupport,&
this.cb_task_print,&
this.cb_canceltask,&
this.cb_import,&
this.uo_taskatt,&
this.dw_task,&
this.cb_newtask,&
this.cb_updatetask,&
this.cb_deletetask,&
this.dw_devobject,&
this.gb_objects,&
this.gb_taskdetails,&
this.gb_attachments}
end on

on tabpage_task.destroy
destroy(this.cb_mailsupport)
destroy(this.cb_task_print)
destroy(this.cb_canceltask)
destroy(this.cb_import)
destroy(this.uo_taskatt)
destroy(this.dw_task)
destroy(this.cb_newtask)
destroy(this.cb_updatetask)
destroy(this.cb_deletetask)
destroy(this.dw_devobject)
destroy(this.gb_objects)
destroy(this.gb_taskdetails)
destroy(this.gb_attachments)
end on

event constructor;n_dw_style_service   lnv_style
n_service_manager		lnv_servicemgr
string 					ls_currentVersion

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_registercolumn('dev_status', true)
lnv_style.of_dwformformater(dw_task)

//lnv_style.of_registercolumn('library', true)
lnv_style.of_registercolumn('objectname', true)
lnv_style.of_registercolumn('lastversion', true)
lnv_style.of_registercolumn('actiontype', true)
lnv_style.of_dwlistformater(dw_devobject, false)

end event

type cb_mailsupport from mt_u_commandbutton within tabpage_task
integer x = 3054
integer y = 2188
integer taborder = 100
string text = "Send Email"
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>	send mail (CR specification and attachment) to support	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		15/06/15 CR4041        LHG008   First Version
   </HISTORY>
********************************************************************/

string ls_assigned_to, ls_email_address

ls_assigned_to = tab_request.tabpage_details.dw_request.getitemstring(1, 'assigned_to')

if isnull(ls_assigned_to) then
	messagebox("Error", "Email cannot be sent, because no user is assigned to this CR.")
	return c#return.Failure
end if

//Get email address
SELECT EMAIL
  INTO :ls_email_address
  FROM CREQ_CONSULTANT
 WHERE LOWER(NAME) = LOWER(:ls_assigned_to);

if isnull(ls_email_address) or len(trim(ls_email_address)) <= 0 then
	messagebox("Error", "Email cannot be sent, because no email address defined for this user.")
	return c#return.Failure
end if

tab_request.tabpage_details.dw_request.accepttext()
tab_request.tabpage_details.uo_att.dw_file_listing.accepttext()
if tab_request.tabpage_details.dw_request.modifiedcount() + tab_request.tabpage_details.uo_att.dw_file_listing.modifiedcount() &
		+ tab_request.tabpage_details.uo_att.dw_file_listing.deletedcount() > 0 then
	
	if MessageBox("Confirmation", "Details data has been changed, but not saved. Send anyway?", question!, YesNo!, 2) = 2 then		
		return c#return.Failure
	end if
end if

return inv_request.of_mailtosupport(il_requestid, ls_email_address, true)
end event

type cb_task_print from mt_u_commandbutton within tabpage_task
integer x = 3401
integer y = 2188
integer taborder = 90
string text = "Print Task"
end type

event clicked;call super::clicked;long		ll_row
string	ls_request_id, ls_msg

ll_row = dw_task.getrow()
if ll_row < 1 then return

dw_task.accepttext()
uo_taskatt.dw_file_listing.accepttext()

if dw_task.modifiedcount() + uo_taskatt.dw_file_listing.modifiedcount() + uo_taskatt.dw_file_listing.deletedcount() > 0 then
	if MessageBox("Confirmation", "Data changed but not saved. Print anyway?", question!, YesNo!, 2) = 2 then
		return
	end if
end if

ls_request_id = string(dw_task.getitemnumber(ll_row, "request_id"))
ls_msg = ls_request_id + '~td_sq_ff_print_request_task'

opensheetwithparm(w_print_request, ls_msg, parentwindow(), 0, original!)
dw_task.post setfocus()
end event

type cb_canceltask from mt_u_commandbutton within tabpage_task
integer x = 4096
integer y = 2188
integer taborder = 80
string text = "&Cancel"
end type

event clicked;call super::clicked;dw_task.retrieve(il_requestid)
dw_devobject.retrieve(il_requestid)
uo_taskatt.of_init(il_requestid)

end event

type cb_import from mt_u_commandbutton within tabpage_task
integer x = 3369
integer y = 1452
integer taborder = 40
string text = "&Import"
end type

event clicked;call super::clicked;/* Work around for importing file with dialog   */
string ls_docname, ls_named, ls_pre_objectname, ls_objectname, ls_action
integer li_value, li_import_result
long ll_row, ll_rowcount, ll_insert_row

mt_n_datastore lds_saw_import, lds_libraries

lds_saw_import = create mt_n_datastore
lds_saw_import.dataobject = "d_ex_gr_saw_import"

li_value = getfileopenname("Select File to Import", ls_docname, ls_named, "CSV",&
								+ "CSV Files (*.CSV),*.CSV," &
								+ "Text Files (*.TXT),*.TXT," &
								+ "All Files (*.*), *.*")
	
if li_value = 1 then
	li_import_result = lds_saw_import.importfile(ls_docname, 2)
else
	return 0
end if

choose case li_import_result
	case 0
		messagebox("Error", "The importfile has to many rows.")
	case -1
		messagebox("Error", "The importfile has no transactions.")
	case -2
		messagebox("Error", "The importfile specified is empty.")
	case -3
		messagebox("Error", "The argument for the importfile is invalid.")
	case -4
		messagebox("Error", "The input is invalid.")
	case -5
		messagebox("Error", "The importfile could not be opened.")
	case -6
		messagebox("Error", "The importfile could not be closed.")
	case -7
		messagebox("Error", "There has been errors reading the text.")
	case -8
		messagebox("Error", "The importfile is not a textfile.")
	case -9
		messagebox("Error", "The import has been canceled.")
end choose

if li_import_result < 1 then
	return -1
else
	//Only insert PB objects and not include labeled/branched action.
	lds_saw_import.setfilter("((right(objectname, 4) like '.sr%') and left(action, 7) <> 'Labeled' and left(action, 8) <> 'Branched') or ((right(action, 4) like '.sr%') and left(action, 7) = 'Deleted')")
	lds_saw_import.filter()
	//Sort by name, last version, action
	lds_saw_import.setsort("objectname A, lastversion D, action A")
	lds_saw_import.sort()
	
	ll_rowcount = lds_saw_import.rowcount()
	if ll_rowcount > 0 then
		//Insert the first row
		ll_insert_row = wf_insert_taskobject(lds_saw_import, 1)
		ls_pre_objectname = lds_saw_import.getitemstring(1, "objectname")
		
		for ll_row = 2 to ll_rowcount
			ls_objectname = lds_saw_import.getitemstring(ll_row, "objectname")
			ls_action = lds_saw_import.getitemstring(ll_row, "action")
			if ls_objectname = ls_pre_objectname then //For same object, if action is added the set object action is new.
				if ls_action = 'Added' then
					dw_devobject.setitem(ll_insert_row, "actiontype", 1)
				end if
			else	//Insert the diffent object.
				ll_insert_row = wf_insert_taskobject(lds_saw_import, ll_row)
			end if
			ls_pre_objectname = ls_objectname
		next
		
	end if
end if

destroy lds_saw_import
return 0

end event

type uo_taskatt from u_fileattach within tabpage_task
event destroy ( )
integer x = 55
integer y = 1660
integer width = 4370
integer height = 496
integer taborder = 30
string is_dataobjectname = "d_sq_tb_creq_file_task"
string is_counterlabel = "Files:"
boolean ib_allow_dragdrop = true
end type

on uo_taskatt.destroy
call u_fileattach::destroy
end on

type dw_task from mt_u_datawindow within tabpage_task
integer x = 37
integer y = 76
integer width = 1737
integer height = 1488
integer taborder = 10
string dataobject = "d_sq_ff_creqtask"
boolean border = false
boolean livescroll = false
end type

event doubleclicked;call super::doubleclicked;if row <= 0 then return

if dwo.name =  "delivered_date" then
	dw_task.setitem(row, "delivered_date", today())
end if
end event

event itemchanged;call super::itemchanged;if row <= 0 then return

if dwo.name = "dev_status" then
	if integer(data) = ii_DEV_DELIVERED then
		this.setitem(1, 'delivered_date', today())
	end if
end if
end event

type cb_newtask from mt_u_commandbutton within tabpage_task
integer x = 3717
integer y = 1452
integer taborder = 50
string text = "&New"
end type

event clicked;call super::clicked;long ll_row, ll_found
datawindowchild ldwc
double ld_consid

if isnull(il_requestid) then return

if dw_task.rowcount() < 1 then
	ll_row = dw_task.insertrow(0)
	dw_task.setitem(ll_row, 'request_id', il_requestid)
	dw_task.setitemstatus(ll_row, 0, primary!, notmodified!)
end if

ll_row = dw_devobject.insertrow(0)
dw_devobject.scrolltorow(ll_row)
dw_devobject.setrow(ll_row)

dw_devobject.setitem(ll_row, "request_id", il_requestid)
dw_devobject.setitemstatus(ll_row, 0, primary!, notmodified!)

dw_devobject.post setfocus()
dw_devobject.post setcolumn("library")
end event

type cb_updatetask from mt_u_commandbutton within tabpage_task
integer x = 3749
integer y = 2188
integer taborder = 60
string text = "&Update"
end type

event clicked;call super::clicked;n_service_manager				lnv_servicemgr
n_dw_validation_service    lnv_validation
n_dw_column_definition		lnv_ruledefinition[]
long		ll_return, ll_errorrow
integer	li_errorcolumn, li_dev_status
string	ls_message

//dw_task validate
dw_task.accepttext()

lnv_servicemgr.of_loadservice(lnv_validation, "n_dw_validation_service")

lnv_validation.of_registerrulenumber("dev_status", true, "Dev. Status")
if dw_task.getitemnumber(1, 'dev_status') = ii_DEV_DELIVERED then
	lnv_validation.of_registerruledatetime("delivered_date", true, "Delivered Date")
end if

ll_return = lnv_validation.of_validate(dw_task, ls_message, ll_errorrow, li_errorcolumn)
if ll_return = c#return.Failure then
	dw_task.setfocus()
	dw_task.setrow(ll_errorrow)
	dw_task.setcolumn(li_errorcolumn)
	messagebox("Update Error", ls_message)	
	return c#return.Failure
end if

//dw_devobject validate
if dw_devobject.accepttext() = -1 then return c#return.Failure

//reset rule definition
lnv_validation.inv_ruledefinition = lnv_ruledefinition

//lnv_validation.of_registerrulestring("library", true, "Library")
lnv_validation.of_registerrulestring("objectname", true, "Object Name")
lnv_validation.of_registerrulenumber("lastversion", true, "Last Version")
lnv_validation.of_registerrulenumber("actiontype", true, "Action")

ll_return = lnv_validation.of_validate(dw_devobject, ls_message, ll_errorrow, li_errorcolumn)
if ll_return = c#return.Failure then
	dw_devobject.setfocus()
	dw_devobject.setrow(ll_errorrow)
	dw_devobject.setcolumn(li_errorcolumn)
	messagebox("Update Error", ls_message)	
	return c#return.Failure
end if

if dw_task.update() = 1 and dw_devobject.update() = 1 then
	COMMIT;
	uo_taskatt.of_updateattach()
	tab_request.tabpage_task.dw_devobject.retrieve(il_requestid)
	if isvalid(w_changerequest) then	
		w_changerequest.event ue_refresh_all_rows(il_requestid)
	end if

	return c#return.Success
else
	ROLLBACK;
	messagebox("Update Error", "Update failure.")	
	return c#return.Failure
end if
end event

type cb_deletetask from mt_u_commandbutton within tabpage_task
integer x = 4064
integer y = 1452
integer taborder = 70
string text = "&Delete"
end type

event clicked;call super::clicked;long ll_row

ll_row = dw_devobject.getrow()
if ll_row > 0 then
	if messagebox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!, 2) = 1 then
		dw_devobject.deleterow(ll_row)
	end if
end if
end event

type dw_devobject from u_datagrid within tabpage_task
integer x = 1847
integer y = 76
integer width = 2560
integer height = 1360
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_sq_gr_devobject"
boolean vscrollbar = true
boolean border = false
boolean ib_columntitlesort = true
end type

type gb_objects from mt_u_groupbox within tabpage_task
integer x = 1810
integer y = 12
integer width = 2633
integer height = 1568
integer taborder = 220
integer weight = 400
string facename = "Tahoma"
string text = "Modified Objects"
end type

type gb_taskdetails from mt_u_groupbox within tabpage_task
integer x = 18
integer y = 12
integer width = 1774
integer height = 1568
integer taborder = 220
integer weight = 400
string facename = "Tahoma"
string text = "Task Details"
end type

type gb_attachments from mt_u_groupbox within tabpage_task
integer x = 18
integer y = 1596
integer width = 4425
integer height = 576
integer taborder = 70
integer weight = 400
string facename = "Tahoma"
string text = "Attachments"
end type

type tabpage_time_reg from userobject within tab_request
event create ( )
event destroy ( )
boolean visible = false
integer x = 18
integer y = 100
integer width = 4462
integer height = 2316
long backcolor = 67108864
string text = "Time Registration"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_canceltimereg cb_canceltimereg
cb_refresh cb_refresh
cb_newtimereg cb_newtimereg
cb_updatetimereg cb_updatetimereg
cb_deletetimereg cb_deletetimereg
dw_time_reg dw_time_reg
end type

on tabpage_time_reg.create
this.cb_canceltimereg=create cb_canceltimereg
this.cb_refresh=create cb_refresh
this.cb_newtimereg=create cb_newtimereg
this.cb_updatetimereg=create cb_updatetimereg
this.cb_deletetimereg=create cb_deletetimereg
this.dw_time_reg=create dw_time_reg
this.Control[]={this.cb_canceltimereg,&
this.cb_refresh,&
this.cb_newtimereg,&
this.cb_updatetimereg,&
this.cb_deletetimereg,&
this.dw_time_reg}
end on

on tabpage_time_reg.destroy
destroy(this.cb_canceltimereg)
destroy(this.cb_refresh)
destroy(this.cb_newtimereg)
destroy(this.cb_updatetimereg)
destroy(this.cb_deletetimereg)
destroy(this.dw_time_reg)
end on

event constructor;n_dw_style_service   lnv_style
n_service_manager		lnv_servicemgr

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_registercolumn('creq_time_used_consultant_id_1', true)
lnv_style.of_registercolumn('creq_time_used_work_date', true)
lnv_style.of_registercolumn('creq_time_used_hours', true)
//lnv_style.of_registercolumn('creq_time_used_task_id', true)
lnv_style.of_dwlistformater(dw_time_reg, false)

SELECT FIRST_NAME
  INTO :is_firstname
  FROM USERS
 WHERE USERID = :SQLCA.userid;

end event

type cb_canceltimereg from mt_u_commandbutton within tabpage_time_reg
integer x = 4096
integer y = 2188
integer taborder = 250
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;dw_time_reg.retrieve(il_requestid)
dw_time_reg.scrolltorow(dw_time_reg.rowcount())
end event

type cb_refresh from mt_u_commandbutton within tabpage_time_reg
boolean visible = false
integer x = 2706
integer y = 2188
integer taborder = 210
boolean bringtotop = true
string text = "&Refresh"
end type

event clicked;dw_time_reg.retrieve(il_requestid)
end event

type cb_newtimereg from mt_u_commandbutton within tabpage_time_reg
integer x = 3054
integer y = 2188
integer taborder = 220
boolean bringtotop = true
string text = "&New"
end type

event clicked;long ll_row, ll_found
datawindowchild ldwc_child
double ld_consid

ll_row = dw_time_reg.insertrow(0)
dw_time_reg.scrolltorow(ll_row)
dw_time_reg.setrow(ll_row)
dw_time_reg.post setfocus()

dw_time_reg.setitem(ll_row, "creq_time_used_work_date", today())
dw_time_reg.setitem(ll_row, "creq_time_used_request_id", il_requestid)

dw_time_reg.post setcolumn("creq_time_used_work_date")

dw_time_reg.getchild("creq_time_used_consultant_id_1", ldwc_child)
ll_found = ldwc_child.find("name like '"+is_firstname+"%'", 1, 9999)
if ll_found > 0 then
	dw_time_reg.post setcolumn("creq_time_used_hours")
	ld_consid = ldwc_child.getitemdecimal(ll_found, "consultant_id")
	dw_time_reg.setitem(ll_row, "creq_time_used_consultant_id_1", ld_consid)
else
	dw_time_reg.post setcolumn("creq_time_used_consultant_id_1")
end if


end event

type cb_updatetimereg from mt_u_commandbutton within tabpage_time_reg
integer x = 3401
integer y = 2188
integer taborder = 230
boolean bringtotop = true
string text = "&Update"
end type

event clicked;n_service_manager				lnv_servicemgr
n_dw_validation_service    lnv_validation
long		ll_return, ll_errorrow
integer	li_errorcolumn
string	ls_message

lnv_servicemgr.of_loadservice(lnv_validation, "n_dw_validation_service")
lnv_validation.of_registerrulenumber("creq_time_used_consultant_id_1", true, "Consultant")
lnv_validation.of_registerruledatetime("creq_time_used_work_date", true, "Work Date")
lnv_validation.of_registerruledecimal( "creq_time_used_hours", true, 0.0, 999.99, 0, "", "Hours")

//lnv_validation.of_registerrulenumber("creq_time_used_task_id", true, "Task")

if dw_time_reg.accepttext() = -1 then return c#return.Failure

ll_return = lnv_validation.of_validate(dw_time_reg, ls_message, ll_errorrow, li_errorcolumn)
if ll_return = c#return.Failure then
	dw_time_reg.setfocus()
	dw_time_reg.setrow(ll_errorrow)
	dw_time_reg.setcolumn(li_errorcolumn)
	messagebox("Update Error", ls_message)
	return c#return.Failure
end if

if dw_time_reg.modifiedcount() + dw_time_reg.deletedcount() > 0 then	
	if dw_time_reg.update() = 1 then
		COMMIT;
		tab_request.tabpage_time_reg.dw_time_reg.retrieve(il_requestid)
		tab_request.tabpage_details.dw_request.setitem(1, "actual_hours", dw_time_reg.getitemdecimal(1, "compute_actual_hours"))
		tab_request.tabpage_details.dw_request.setitemstatus(1, "actual_hours", primary!, notmodified!)
		return c#return.Success
	else
		ROLLBACK;
		messagebox("Update Error", "Update failure.")	
		return c#return.Failure
	end if
end if
end event

type cb_deletetimereg from mt_u_commandbutton within tabpage_time_reg
integer x = 3749
integer y = 2188
integer taborder = 240
boolean bringtotop = true
string text = "&Delete"
end type

event clicked;long ll_row

ll_row = dw_time_reg.getrow()
if ll_row > 0 then
	if MessageBox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!, 2) = 1 then
		dw_time_reg.deleterow(ll_row)
	end if
end if
end event

type dw_time_reg from u_datagrid within tabpage_time_reg
integer x = 37
integer y = 28
integer width = 4389
integer height = 2144
integer taborder = 200
string dataobject = "d_req_time_reg_used"
boolean vscrollbar = true
boolean border = false
end type

event editchanged;call super::editchanged;if dwo.name = "creq_time_used_hours" then
	if dec(data) < 0 then
		this.settext(string(abs(dec(data))))
	end if
end if
end event

