$PBExportHeader$n_tc_exp_type.sru
$PBExportComments$TC Expense Type
forward
global type n_tc_exp_type from nonvisualobject
end type
end forward

global type n_tc_exp_type from nonvisualobject
end type
global n_tc_exp_type n_tc_exp_type

type variables
datastore ids_expense_type_list
datastore ids_expense_type_detail

end variables

forward prototypes
public function long of_retrieve_list ()
public function integer of_share_on (ref datawindow adw_list, ref datawindow adw_detail)
public function long of_retrieve_detail (long al_type_id)
public function integer of_insert_row ()
public function integer of_update (ref string as_error_text)
public function integer of_delete (ref string as_error_text)
public function integer of_validate (ref string as_error_text)
end prototypes

public function long of_retrieve_list ();return ids_expense_type_list.retrieve()
end function

public function integer of_share_on (ref datawindow adw_list, ref datawindow adw_detail);ids_expense_type_list.sharedata(adw_list)
ids_expense_type_detail.sharedata(adw_detail)
return 1
end function

public function long of_retrieve_detail (long al_type_id);return ids_expense_type_detail.retrieve(al_type_id)
end function

public function integer of_insert_row ();ids_expense_type_detail.reset()
return ids_expense_type_detail.insertrow(0)
end function

public function integer of_update (ref string as_error_text);if ids_expense_type_detail.update() = 1 then
	commit;
else
	as_error_text = "Error updating the database. " + SQLCA.SQLErrText + " Data has not been updated."
	rollback;
	return -1
end if

Return 1
end function

public function integer of_delete (ref string as_error_text);if ids_expense_type_detail.deleterow(0) = 1 then
	if ids_expense_type_detail.update() = 1 then
		commit;
	else
		as_error_text = SQLCA.SQLErrText
		rollback;
		return -1
	end if
else
	as_error_text = "Entry has not been deleted. Please try again."
	return -1
end if

Return 1
end function

public function integer of_validate (ref string as_error_text);string ls_desc, ls_find 
string ls_inel3inc, ls_inel4inc, ls_outel3inc, ls_outel4inc
string ls_inel3exp, ls_inel4exp, ls_outel3exp, ls_outel4exp
integer li_type
long ll_type_id


ls_desc = ids_expense_type_detail.getitemstring(1,"type_desc")
li_type = ids_expense_type_detail.getitemnumber(1,"non_port_exp")
ls_inel3inc = ids_expense_type_detail.getitemstring(1,"coda_el3_tcin_income")
ls_inel4inc = ids_expense_type_detail.getitemstring(1,"coda_el4_tcin_income")
ls_outel3inc = ids_expense_type_detail.getitemstring(1,"coda_el3_tcout_income")
ls_outel4inc = ids_expense_type_detail.getitemstring(1,"coda_el4_tcout_income")
ls_inel3exp = ids_expense_type_detail.getitemstring(1,"coda_el3_tcin_expense")
ls_inel4exp = ids_expense_type_detail.getitemstring(1,"coda_el4_tcin_expense")
ls_outel3exp = ids_expense_type_detail.getitemstring(1,"coda_el3_tcout_expense")
ls_outel4exp = ids_expense_type_detail.getitemstring(1,"coda_el4_tcout_expense")


/*Check for null values*/
if isnull(ls_desc) or isnull(li_type) then
	as_error_text = "Description is not entered"
	return -1
end if

if isnull(ls_inel3inc) or isnull(ls_inel4inc) or isnull(ls_outel3inc) or isnull(ls_outel4inc) or &
	isnull(ls_inel3exp) or isnull(ls_inel4exp) or isnull(ls_outel3exp) or isnull(ls_outel4exp) then
	as_error_text = "Please note that all fields are mandatory"
	return -1
end if
/*End of check for null values*/

/*Check of uniqueness of type description*/
choose case ids_expense_type_detail.getitemstatus(1,0,primary!)
	case newmodified! //check that an entry with same description and type does not exist
		ls_find = "type_desc = '" + ls_desc &
					+ "' and non_port_exp = " &
					+ string(li_type)
		if ids_expense_type_list.find(ls_find,1,ids_expense_type_list.rowcount()) > 0 then
			as_error_text = "An entry with the same description and type already exist."
			return - 1
		end if
	case DataModified! //check that an entry with same description and type does not exist (with different id)
		ll_type_id=ids_expense_type_detail.getitemnumber(1, "exp_type_id")
		ls_find = "type_desc = '" + ls_desc + "' and non_port_exp = " &
					+ string(li_type) + " and exp_type_id <> " + string(ll_type_id) 
										
		if ids_expense_type_list.find(ls_find,1,ids_expense_type_list.rowcount()) > 0 then
			as_error_text = "An entry with the same description and type already exist."
			return - 1
		end if
End choose
/*End of type description uniqueness test*/

/*If type is Contract Expense, uncheck Use of Final Hyre*/
IF (ids_expense_type_detail.getitemnumber(1,"non_port_exp")=0 &
	AND ids_expense_type_detail.getitemnumber(1,"final_hire")=1) THEN
	 	ids_expense_type_detail.setitem(1,"final_hire",0)
END IF
/*End of Contract Expense/Final Hyre check*/

return 1	
end function

on n_tc_exp_type.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tc_exp_type.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_expense_type_list = create datastore
ids_expense_type_list.dataobject = "d_expense_type_list"
ids_expense_type_list.settransobject(SQLCA)


ids_expense_type_detail = create datastore
ids_expense_type_detail.dataobject = "d_expense_type_detail"
ids_expense_type_detail.settransobject(SQLCA)
end event

event destructor;destroy ids_expense_type_list
destroy ids_expense_type_detail
end event

