$PBExportHeader$n_get_maxvalue.sru
forward
global type n_get_maxvalue from mt_n_nonvisualobject
end type
end forward

global type n_get_maxvalue from mt_n_nonvisualobject
end type
global n_get_maxvalue n_get_maxvalue

forward prototypes
public subroutine documentation ()
public function long of_get_maxvalue (string as_type)
public function long of_get_maxvalue (string as_type, boolean ab_commit)
public function long of_assignidentity (datawindow adw_object, string as_colname, string as_type)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_get_maxvalue
   <OBJECT> Get the maximum value with procedure SP_GET_MAXVALUE</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Input the name for the type of maximum value, the type name is a user determine value </USAGE>
   <ALSO>   otherobjs</ALSO>
    Date        Ref       Author    Comments
    03/11/2013  CR3160    WWA048    First Version
	 07/02/2014  CR3700    SSX014    Add a function
********************************************************************/

end subroutine

public function long of_get_maxvalue (string as_type);/********************************************************************
   of_get_maxvalue
   <DESC> Get the maximum value with procedure SP_GET_MAXVALUE </DESC>
   <RETURN>	long:  
				<LI> ll_max_id, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_type: the name for the type of maximum value
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	11/03/2013 CR3160       WWA048        First Version
   </HISTORY>
********************************************************************/

return of_get_maxvalue(as_type, true )


end function

public function long of_get_maxvalue (string as_type, boolean ab_commit);/********************************************************************
   of_get_maxvalue
   <DESC> Get the maximum value with procedure SP_GET_MAXVALUE </DESC>
   <RETURN>	long:  
				<LI> ll_max_id, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_type: the name for the type of maximum value
		ab_commit: whether commit or rollback
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
      11/03/2013 CR3160       WWA048        First Version
      06/10/2014    ?         SSX014        Added a parameter
   </HISTORY>
********************************************************************/

long ll_max_id
long ll_rc

ll_rc = c#return.Failure

DECLARE GET_MAXVALUE PROCEDURE FOR
	SP_GET_MAXVALUE @type_name = :as_type, @max_id = 0 output;
EXECUTE GET_MAXVALUE;

if sqlca.sqlcode = 0 then
	FETCH GET_MAXVALUE INTO :ll_max_id;
	if sqlca.sqlcode = 0 then
		if ll_max_id >= 0 then 
			ll_rc = ll_max_id
		end if
	end if
end if
CLOSE GET_MAXVALUE;

if ab_commit then
	if ll_rc >= 0 then
		COMMIT;
	else
		ROLLBACK;
	end if
end if

return ll_rc

end function

public function long of_assignidentity (datawindow adw_object, string as_colname, string as_type);/********************************************************************
   of_AssignIdentity
   <DESC>   Assign identity numbers for all new modified rows </DESC>
   <RETURN> Success or failure </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_object: Datawindow
		as_colname: column to be set to maximum value
		as_type: a field value from table MAXVALUE
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date        CR-Ref    Author       Comments
   	10/06/14    CR3700    SSX014       First Version
   </HISTORY>
********************************************************************/

long ll_return, ll_row

if IsNull(adw_object) or not IsValid(adw_object) then
	return c#return.FAILURE
end if

if not IsNumber(adw_object.Describe(as_colname+".id")) then
	return c#return.FAILURE
end if

for ll_row = 1 to adw_object.RowCount()
	if adw_object.GetItemStatus(ll_row, 0, PRIMARY! ) = NewModified! then
		ll_return = this.of_get_maxvalue(as_type, false)
		if ll_return = -1 then
			return c#return.FAILURE
		end if
		adw_object.SetItem(ll_row, as_colname, ll_return)
	end if
next

return c#return.SUCCESS


end function

on n_get_maxvalue.create
call super::create
end on

on n_get_maxvalue.destroy
call super::destroy
end on

