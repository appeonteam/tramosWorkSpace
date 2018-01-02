$PBExportHeader$n_bankaccount.sru
forward
global type n_bankaccount from mt_n_interface_master
end type
end forward

global type n_bankaccount from mt_n_interface_master
end type
global n_bankaccount n_bankaccount

forward prototypes
protected subroutine _setup ()
public function integer of_insertrow (readonly string as_dsname)
public function integer of_update ()
public function integer of_retrieve (readonly string as_dsname)
public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row)
public function integer of_deleterow (readonly string as_dsname, long al_row)
private function integer _validate ()
end prototypes

protected subroutine _setup ();/********************************************************************
   _setup( )
   <DESC>   This function is made for holding all the datastore/dataset creations
	when the object is instantiated</DESC>
   <RETURN>(None)</RETURN>
   <ACCESS>Private</ACCESS>
   <ARGS>(None)</ARGS>
   <USAGE></USAGE>
********************************************************************/
constant string METHOD_NAME = "_setup"

_createdatastore( "bankaccountlist", "d_sq_tb_bankaccountlist", "")

_createdatastore( "bankaccountdetail", "d_sq_ff_bankaccountdetail", "")


_setdetail( "bankaccountlist", "bankaccountdetail", {"bank_account_id"})
end subroutine

public function integer of_insertrow (readonly string as_dsname);
/********************************************************************
   of_insertRow
   <DESC> Inserts a row into the requsted dataset, and sets the initial values if any.
	When a new claim is created, the detail datasets are reset./DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   as_dsName: name of dataset where row has to be inserted</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_insertRow"
long		ll_row, ll_att_index
string		ls_docpath, ls_docname
long 		ll_filehandle, ll_file_size, ll_file_row
blob		lbl_filedata

istr_datastore[2].ds_data.Reset()
		
ll_row = istr_datastore[2].ds_data.insertRow(0)

if ll_row < 1 then
	_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Special Claim", "")
	return c#return.failure
end if
		
return ll_row

end function

public function integer of_update ();/********************************************************************
   of_update
   <DESC> Updates all the datasets except the master list.
	First validate all the datasets, and then updates them.
	If everything is ok, update master list dataset</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> (none) </ARGS>
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_update"

istr_datastore[2].ds_data.acceptText()

if _validate( ) =c#return.failure  then  return c#return.failure

if istr_datastore[2].ds_data.update(true, false) = -1 then
	rollback;
	_addmessage( this.classdefinition, METHOD_NAME, "Update failed!", "N/A")
	return c#return.failure
end if	

commit;
return c#return.success
end function

public function integer of_retrieve (readonly string as_dsname);/********************************************************************
   of_retrieve()
   <DESC> This function retrieves the given dataset and all its children  by
	handling it over to __retrieveDataset (as_dsName)</DESC>
   <RETURN> Long:
            <LI> n, ok 
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> (none)</ARGS>
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_retrieve"

//integer li_dsindex
//
//for li_dsindex = 1 to upperbound(istr_datastore)
//	if as_dsname = istr_datastore[li_dsindex].ds_name then
//		return istr_datastore[li_dsindex].ds_data.retrieve()
//	end if
//next

return -1
end function

public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row);constant string METHOD_NAME = "of_rowFocusChanged"

long ll_id

if al_row < 1 then return c#return.noaction

if as_master_dsname = "bankaccountlist" then
	ll_id = istr_datastore[1].ds_data.getItemNumber(al_row, "bank_account_id")

	//retrieve company
	 istr_datastore[2].ds_data.retrieve(ll_id)
	
end if

return c#return.success
end function

public function integer of_deleterow (readonly string as_dsname, long al_row);/********************************************************************
of_deleterow 

********************************************************************/

constant string METHOD_NAME = "of_deleterow"

long	ll_rows, ll_row, ll_rowselected, ll_rc
string	ls_warning
boolean	lb_maillistfound

if as_dsname ="bankaccountdetail" then

	ll_rowselected =  istr_datastore[2].ds_data.getrow()
	if ll_rowselected < 1 then 	return -1
	
	if MessageBox("Warning", "Do you want to delete bank account?"  ,Question!, YesNo! ) = 2 then return  c#return.failure
	
	istr_datastore[2].ds_data.deleterow(ll_rowselected)
	
	if istr_datastore[2].ds_data.update() <> 1 then
		_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Company!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
		rollback;
		return c#return.failure
	end if
	
	commit;
		
end if

return c#return.success
end function

private function integer _validate ();/********************************************************************
_validate 
   <DESC> Checks mandatory fields </DESC>
   <RETURN> 
		c#return.success:		ok
		c#return.failure:	one or more mandatory fields are empty
   </RETURN>
   <ACCESS> Private  </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>Checks if IBAN or Swift code, one of them is filled in.
	</USAGE>
********************************************************************/

if (trim( istr_datastore[2].ds_data.getitemstring( 1, "bank_account_swift")) = "" or &
	isnull( istr_datastore[2].ds_data.getitemstring( 1, "bank_account_swift"))) and &
	(trim( istr_datastore[2].ds_data.getitemstring( 1, "bank_account_iban")) = "" or &
	isnull( istr_datastore[2].ds_data.getitemstring( 1, "bank_account_iban")))  &
	 then
	_addMessage( this.classdefinition, "", "Data not saved: Swift code or IBAN is mandatory.", "")
	return  c#return.failure
end if

return c#return.success
end function

on n_bankaccount.create
call super::create
end on

on n_bankaccount.destroy
call super::destroy
end on

