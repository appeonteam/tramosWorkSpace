$PBExportHeader$n_voyageatt_types.sru
$PBExportComments$Voyage Attachments - types configuration (Interface object)
forward
global type n_voyageatt_types from mt_n_interface_master
end type
end forward

global type n_voyageatt_types from mt_n_interface_master
end type
global n_voyageatt_types n_voyageatt_types

type variables
long	il_pcnr
end variables

forward prototypes
protected subroutine _setup ()
public function integer of_insertrow (readonly string as_dsname)
public function integer of_deleterow (readonly string as_dsname, long al_row)
public function integer of_update ()
public function integer of_retrieve (long as_pcnr)
public function boolean of_updatespending ()
public subroutine documentation ()
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

_createdatastore( "typeslist", "d_sq_tb_voyageatt_types", "")

end subroutine

public function integer of_insertrow (readonly string as_dsname);/********************************************************************
   of_insertRow
   <DESC> Inserts a row into the requsted dataset, and sets the initial values if any.
	</DESC>
   <RETURN> Integer:
            <LI> ll_rows: number of inserted rows
            <LI>  c#return.failure: failed</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   as_dsName: name of dataset where row has to be inserted</ARGS>
   <USAGE>  </USAGE>
********************************************************************/

constant string METHOD_NAME = "of_insertrow"

long	ll_rows

if as_dsname = "typeslist" then

	ll_rows = istr_datastore[1].ds_data.insertrow(0)
	if ll_rows < 1 then
		_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Contact", "")
		return c#return.failure
	end if
end if

istr_datastore[1].ds_data.setitem(ll_rows, "doc_type_active",1)
istr_datastore[1].ds_data.setitem(ll_rows, "pc_nr",il_pcnr)

return ll_rows
end function

public function integer of_deleterow (readonly string as_dsname, long al_row);/********************************************************************
of_deleterow 
   <DESC> Deletes a type from the type list, if type is not in used.
   </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		as_dsname: Data set name
		al_row: Row
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_deleterow"

long 	ll_doctypeid,ll_used

if as_dsname = "taskslist" then
	
	 ll_doctypeid=istr_datastore[1].ds_data.getitemnumber(al_row,"doc_type")
	if ll_doctypeid > 0 then
		SELECT TOP 1  DOC_TYPE
		INTO :ll_used
		FROM VOYAGE_DOCUMENT
		WHERE DOC_TYPE = :ll_doctypeid ;
		COMMIT USING SQLCA;
		
		if ll_used>0 then
			_addmessage( this.classdefinition, METHOD_NAME, "It is not possible to delete the attachment type because it is currently used!", "N/A")
			return c#return.failure
		end if
	end if
	 
	if istr_datastore[1].ds_data.deleterow( al_row) = -1 then
		_addmessage( this.classdefinition, METHOD_NAME, "Error deliting contact!", "N/A")
		return c#return.failure
	end if
end if

return c#return.success
end function

public function integer of_update ();
constant string METHOD_NAME = "of_update"
long ll_row, ll_rows

ll_rows =  istr_datastore[1].ds_data.rowcount()
for ll_row = 1 to ll_rows
	if trim( istr_datastore[1].ds_data.getitemstring( ll_row, "doc_type_desc")) = "" or &
		isnull( istr_datastore[1].ds_data.getitemstring( ll_row, "doc_type_desc")) then
		_addMessage( this.classdefinition, METHOD_NAME, "Type description is mandatory!", "")
		return  c#return.failure
	end if
next

//update companies
if istr_datastore[1].ds_data.update() = 1 then
	commit;	
else
	rollback;
	_addmessage( this.classdefinition, METHOD_NAME, "Update Type List failed!", "N/A")
	return c#return.failure
end if

return c#return.success



end function

public function integer of_retrieve (long as_pcnr);/********************************************************************
   of_retrieve
   <DESC> Retrieves the Task List</DESC>
   <RETURN> integer: failure or success</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> ling: profit center number </ARGS>
   <USAGE>
	</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_retrieve"

if istr_datastore[1].ds_data.retrieve(as_pcnr) = c#return.failure then
	_addmessage( this.classdefinition, METHOD_NAME, "Error retrieving Task list", "N/A")
	return c#return.failure
end if

il_pcnr = as_pcnr

return c#return.success

end function

public function boolean of_updatespending ();/********************************************************************
of_updatespending      
   <DESC> Checks if exists any outstanding updates  </DESC>
   <RETURN> 
		true: if exists outstanding updates
		false: if does not exist updates
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

long		ll_modCounter=0

ll_modCounter += istr_datastore[1].ds_data.modifiedCount()
ll_modCounter += istr_datastore[1].ds_data.deletedCount()
	
if ll_modCounter > 0 then
	return true
else
	return false
end if
end function

public subroutine documentation ();/********************************************************************
   n_voyageatt_types: a 'container' (non visual window) to encapsulate the 
	functionality provided by the implementation of the Types of Voyage Attachments handling, and 
	separate business logic from GUI.
   <OBJECT>	
		typeslist  	( istr_datastore[1].ds_data ) - d_sq_tb_voyageatt_types
	</OBJECT>
   
	<DESC> of_retrieve (al_pcnr)			- Retrieves the list of tasks by profit center
				of_insertrow (as_dsname)	- inserts requested row, and sets the default values
				of_update()						- updates istr_datastore[1]
				of_deleterow(as_dsname, al_row)		- deletes requested row		
	</DESC>
   <USAGE> w_voyageatt_types </USAGE>
   <ALSO>  </ALSO>
    	Date   		Ref    			Author		Comments
  	08/11/10		CR2182	JMC112		Initial Version
********************************************************************/

end subroutine

on n_voyageatt_types.create
call super::create
end on

on n_voyageatt_types.destroy
call super::destroy
end on

