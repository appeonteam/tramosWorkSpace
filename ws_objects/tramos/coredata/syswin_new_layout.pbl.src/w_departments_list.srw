$PBExportHeader$w_departments_list.srw
forward
global type w_departments_list from w_system_base
end type
end forward

global type w_departments_list from w_system_base
integer width = 1664
string title = "Owners Matters Departments"
end type
global w_departments_list w_departments_list

forward prototypes
public subroutine documentation ()
public function integer wf_validate ()
private subroutine _set_permissions ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_departments_list
   <OBJECT>	Maintain config department	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
		Date         	CR-Ref		Author			Comments
		23/12/2013   	CR3085		WWG004			First Version
		09/06/2014		CR3085UAT	XSZ004			Fix bug based on 28.01.0 UAT defect report.
   </HISTORY>
********************************************************************/
end subroutine

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>	It should not be possible to change/delete any value 
	         that has been used in department	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Suggest using before updating	</USAGE>
   <HISTORY>
		Date      		CR-Ref		Author		Comments
		23/12/2013		CR3085		WWG004		First Version
		09/06/2014		CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report.
   </HISTORY>
********************************************************************/
long           ll_loop, ll_count, ll_found
string         ls_department_org, ls_department_new
mt_n_datastore lds_department

lds_department = create mt_n_datastore
lds_department.dataobject = "d_sq_gr_department"
lds_department.settransobject(sqlca)
ll_count = lds_department.retrieve()

for ll_loop = 1 to dw_1.rowcount()
	ls_department_org = dw_1.getitemstring(ll_loop, "department_name", Primary!, true)
	ls_department_new = dw_1.getitemstring(ll_loop, "department_name", Primary!, false)
	
	if ls_department_org <> ls_department_new then
		ll_found = lds_department.find("department_name = '" + ls_department_org + "'", 1, ll_count)
		
		if ll_found > 0 then
			messagebox("Information", "Department '" + ls_department_org + "' has been used, it cannot be modified or deleted.")
			destroy lds_department
			return c#return.failure
		end if
	end if
next

destroy lds_department
return c#return.success

end function

private subroutine _set_permissions ();/********************************************************************
   _set_permissions
   <DESC> Access control for Department configuration window </DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		26/05/2014		CR2648		XSZ004		First Version	      
   </HISTORY>
********************************************************************/

dw_1.modify("datawindow.readonly = 'Yes'")

if uo_global.ii_access_level = C#usergroup.#SUPERUSER or &
	uo_global.ii_access_level = C#usergroup.#ADMINISTRATOR then
	
	cb_new.enabled 	= true
	cb_update.enabled = true
	cb_delete.enabled = true
	cb_cancel.enabled = true
	dw_1.modify("datawindow.readonly = 'No'")
end if
end subroutine

on w_departments_list.create
call super::create
end on

on w_departments_list.destroy
call super::destroy
end on

event open;call super::open;string	ls_mandatory_column[]

ls_mandatory_column = {"department_name", "department_sort"}

wf_format_datawindow(dw_1, ls_mandatory_column)

_set_permissions()
end event

type cb_cancel from w_system_base`cb_cancel within w_departments_list
integer x = 1266
integer y = 832
boolean enabled = false
end type

event cb_cancel::clicked;long ll_row

ll_row = dw_1.getrow()

dw_1.reset()
dw_1.retrieve()

dw_1.setrow(ll_row)
dw_1.scrolltorow(ll_row)
dw_1.setfocus()
end event

type cb_refresh from w_system_base`cb_refresh within w_departments_list
integer x = 2304
integer y = 1520
end type

type cb_delete from w_system_base`cb_delete within w_departments_list
integer x = 914
integer y = 832
boolean enabled = false
end type

event cb_delete::clicked;string	ls_department
long		ll_row, ll_usedcount

dw_1.accepttext()
ll_row = dw_1.getrow()

if ll_row > 0 then
	ls_department = dw_1.getitemstring(ll_row, "department_name", primary!, true)
	
	SELECT COUNT(*) INTO :ll_usedcount
	  FROM DEPARTMENT
	 WHERE DEPARTMENT_NAME = :ls_department;
	 
	 if ll_usedcount > 0 then
		messagebox("Delete Error", "You cannot delete the department, because it has been used.")
	else
		if messagebox("Verify Delete", "Are you sure you want to delete this record?", Question!, YesNo!,2) = 1 then
			dw_1.deleterow(ll_row)
		end if	
	end if
end if

dw_1.setfocus()
end event

type cb_update from w_system_base`cb_update within w_departments_list
integer x = 562
integer y = 832
boolean enabled = false
boolean default = false
end type

event cb_update::clicked;string ls_errtext
long   ll_row

n_service_manager          lnv_svcmgr
n_dw_validation_service    lnv_rules

ll_row = dw_1.getrow()

if dw_1.accepttext() = -1 then return

lnv_svcmgr.of_loadservice(lnv_rules, "n_dw_validation_service")
lnv_rules.of_registerrulestring("department_name", true, "Department", true)
lnv_rules.of_registerrulenumber("department_sort", true, "Sort")

if lnv_rules.of_validate(dw_1, true) = c#return.Failure then return

if wf_validate() = c#return.failure then return

if dw_1.update() = 1 then
	COMMIT;
	dw_1.retrieve()
else
	ROLLBACK;
	ls_errtext = sqlca.sqlerrtext
	messagebox("Error", ls_errtext, stopsign!)
end if

dw_1.scrolltorow(ll_row)
dw_1.setfocus()
end event

type cb_new from w_system_base`cb_new within w_departments_list
integer x = 210
integer y = 832
boolean enabled = false
end type

type dw_1 from w_system_base`dw_1 within w_departments_list
integer width = 1573
integer height = 784
string dataobject = "d_sq_gr_department_config"
boolean vscrollbar = true
end type

