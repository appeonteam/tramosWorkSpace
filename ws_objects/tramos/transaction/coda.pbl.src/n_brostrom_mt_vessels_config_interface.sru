$PBExportHeader$n_brostrom_mt_vessels_config_interface.sru
forward
global type n_brostrom_mt_vessels_config_interface from mt_n_interface_master
end type
end forward

global type n_brostrom_mt_vessels_config_interface from mt_n_interface_master autoinstantiate
end type

type variables
// datawindow idw_export
n_dw_validation_service 	_inv_validationrules
end variables

forward prototypes
protected subroutine _setup ()
public function integer of_insertrow (readonly string as_dsname)
public function integer of_deleterow (readonly string as_dsname, long al_row)
public function integer of_update (string as_dsname, ref long al_row, ref integer ai_column)
private function integer _validate (string as_dsname, ref long al_row, ref integer ai_column)
private subroutine documentation ()
end prototypes

protected subroutine _setup ();constant string METHOD_NAME = "_setup"
integer li_ruleid

_createdatastore( "config", "d_sq_tb_brostrom_mt_vessels", "")
_inv_validationrules = create n_dw_validation_service

li_ruleid = _inv_validationrules.of_registerrulenumber("vessel_nr", true, "vessel")
li_ruleid = _inv_validationrules.of_registerrulestring("coda_el3_crew", true, "Crew coda element 3")
li_ruleid = _inv_validationrules.of_registerrulestring("coda_el4_crew", true,  "Crew coda element 4")
li_ruleid = _inv_validationrules.of_registerrulestring("coda_el3_to", true, "T.O. coda element 3")
li_ruleid = _inv_validationrules.of_registerrulestring("coda_el4_to", true, "T.O. coda element 4")


end subroutine

public function integer of_insertrow (readonly string as_dsname);integer li_row=0
integer li_dsindex

for li_dsindex = 1 to upperbound(istr_datastore)
	if as_dsname = istr_datastore[li_dsindex].ds_name then
		li_row = 	istr_datastore[li_dsindex].ds_data.insertrow(0)
	end if
next
	
return li_row
end function

public function integer of_deleterow (readonly string as_dsname, long al_row);/********************************************************************
   of_deleteRow
   <DESC> Deletes the row requested by the user, after confirmation that it is OK
	Depending on where the delete is initiated from, there can be deleted many
	detail rows and a master.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public </ACCESS>
   <USAGE></USAGE>
********************************************************************/
constant string METHOD_NAME = "of_deleteRow"
long 	ll_row, ll_rows, ll_found 
long	ll_SpecialClaimID
string	ls_message

if al_row < 1 then return c#return.noaction

choose case as_dsName
	case "config"
		ls_message = "You are about to DELETE selected Brostrom/MT Vessel setup!~r~n~r~n" + &
				  			"Are you sure you want to continue?"
end choose
		
if MessageBox("Confirm Delete",ls_message ,Question!,YesNo!,2) = 2 THEN return -1

choose case as_dsName
	case "config" 
		if (uo_global.ii_user_profile = 3) &
		or (uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2)  then
			// ok to delete
		else
			_addmessage( this.classdefinition, METHOD_NAME, "As you are not a finance or operations superuser, you are not allowed to delete configurations ", "It is decided by operations that only Users with Finance profile and operations superusers can delete Brostrom/MT configurations"  )
			return c#return.noaction
		end if

		istr_datastore[1].ds_data.DeleteRow(al_row)
		if istr_datastore[1].ds_data.Update() = 1 then
			commit;
		else
			_addmessage( this.classdefinition, METHOD_NAME, "Error deleting transaction!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
			rollback;
			return c#return.failure
		end if
end choose

return c#return.success

end function

public function integer of_update (string as_dsname, ref long al_row, ref integer ai_column);/********************************************************************
   of_update
   <DESC>   Business logic when updating data in window 
	w_brostrom_mt_vessels_config.</DESC>
   <RETURN> Integer:
            <LI> 1, X success
            <LI> -1, X failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>	as_dsname: datastore reference/name held in interface 
				al_row: used to hold the row where the error may have occurred
				ai_column: used to hold the column where the error may have occurred</ARGS>
   <USAGE> Directly from an update button on the window. </USAGE>
********************************************************************/
integer li_dsindex
long ll_found, ll_row
mt_n_datastore lds_iomsinvessel
string ls_rowstatus		

constant string METHOD_NAME = "of_update()"
if istr_datastore[1].ds_data.rowcount()=0 then return c#return.NoAction
if istr_datastore[1].ds_data.modifiedcount() = 0 then return c#return.NoAction

for li_dsindex = 1 to upperbound(istr_datastore)
	if as_dsname = istr_datastore[li_dsindex].ds_name then
		if as_dsname = "config" then
			/* validate */
			if _validate(as_dsname, al_row, ai_column) = c#return.Failure then 
				return c#return.Failure
			end if
			/* update with dwobject level error validation */
			if istr_datastore[li_dsindex].ds_data.update() = 1 then
				commit;	
			else
				rollback;
				// _addmessage( this.classdefinition, METHOD_NAME, "Update of Brostrom/MT vessel configuration failed!", "N/A")
				return c#return.failure
			end if				
		end if
	end if
next
	
return c#return.Success
end function

private function integer _validate (string as_dsname, ref long al_row, ref integer ai_column);/********************************************************************
   _validate( /*string as_dsname*/, /*long al_row*/, /*integer ai_column */)
	
   <DESC>checks against iom/sing vessels and calls mt datawindow validation</DESC>
   <RETURN> Integer:
            <LI> 1, Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>  as_dsname: datastore reference/name held in interface 
            al_row: used to hold the row where the error may have occurred
				ai_column: used to hold the column where the error may have occurred</ARGS>
   <USAGE>  Validation process called from of_update( /*string as_dsname*/, /*ref long al_row*/, /*ref integer ai_column */)
	 Initialisation of validation interface is located in the constructor of this object.</USAGE>
********************************************************************/


integer li_dsindex
long 	ll_row, ll_found
boolean lb_modified
mt_n_datastore	lds_iomsinvessel
constant string METHOD_NAME="of_validate()"

for li_dsindex = 1 to upperbound(istr_datastore)
	/* in this implementation there is only 1 ds */
	if as_dsname = istr_datastore[li_dsindex].ds_name then
		/* nb. tramos has already validated datawindow level error event */
		if as_dsname = "config" then
			/* next check duplicate within iom/singapore setup business rule exists where vessel can not be located in both tables.*/
			lds_iomsinvessel = create mt_n_datastore
			lds_iomsinvessel.dataobject = "d_iom_sin_vessels"
			lds_iomsinvessel.settransobject(sqlca)
			lds_iomsinvessel.retrieve()
			
			for ll_row = 1 to  istr_datastore[li_dsindex].ds_data.rowcount()
				choose case  istr_datastore[li_dsindex].ds_data.getitemstatus( ll_row, 0, Primary!)
					case NotModified!
						lb_modified = false
					case else 
						lb_modified = true
				end choose
				if lb_modified then
					ll_found = lds_iomsinvessel.find("iom_sin_vessels_vessel_nr=" + string(istr_datastore[li_dsindex].ds_data.getitemnumber(ll_row,"vessel_nr"))  ,1,100000)
					if ll_found>0 then 
						_addmessage( this.classdefinition, METHOD_NAME, "Error Duplicate! You can not have the same vessel in the IOM/Sing configuration!", "N/A")
						al_row = ll_row
						return c#return.Failure
					end if
				end if
			next
			
			/* lastly use dw validation service to check standard required values etc. */
			if _inv_validationrules.of_validate( istr_datastore[li_dsindex].ds_data, al_row, ai_column) = c#return.Failure then 
				return c#return.Failure
			end if
			
		end if
		
	end if
next

return c#return.Success
end function

private subroutine documentation ();/********************************************************************
   ObjectName: n_brostrom_mt_vessels_config_interface
   <OBJECT> Interface for window concerned with the configuration of Brostrom Maersk Tankers
	managed Vessels.  </OBJECT>
   <DESC>Inherited from the standard interface object, this is a simple implementation making use of the 
	mt validation service (not used as a service in this instance due to registration of columns on the
	constructor)</DESC>
   <USAGE>  Controls/manipulates/validates data behind the datawindow containers.</USAGE>
   <ALSO>   w_brostrom_mt_vessels_config, n_dw_validation_service</ALSO>
    Date   		Ref    			Author	Comments
  19/04/11 	CR#2323		AGL     	First Version
********************************************************************/

end subroutine

on n_brostrom_mt_vessels_config_interface.create
call super::create
end on

on n_brostrom_mt_vessels_config_interface.destroy
call super::destroy
end on

