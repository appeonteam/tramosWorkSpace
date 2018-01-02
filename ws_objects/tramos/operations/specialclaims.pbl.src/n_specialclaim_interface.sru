$PBExportHeader$n_specialclaim_interface.sru
$PBExportComments$Main interface tregarding special claim maintainance
forward
global type n_specialclaim_interface from mt_n_interface_master
end type
end forward

global type n_specialclaim_interface from mt_n_interface_master
end type
global n_specialclaim_interface n_specialclaim_interface

type variables
private n_attachment _inv_att[]
private long	_il_new_file_id 


end variables

forward prototypes
protected subroutine _setup ()
public function long of_retrieve ()
public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row)
public function integer of_insertrow (readonly string as_dsname)
public function integer of_deleterow (readonly string as_dsname, long al_row)
public function integer of_update ()
public function integer of_itemchanged (ref mt_u_datawindow adw_data, readonly long al_row, readonly dwobject adwo_object, readonly string as_data)
public function integer of_printinvoice (long al_row)
private function integer _updateattachments ()
public function integer of_openattachment (long al_row)
private function integer _deleteattachment (long al_row)
private function integer _validate ()
private function integer _validateaction ()
private function integer _validateattachment ()
private function integer _validatebase ()
private function integer _validatetransaction ()
private function integer _setforeignkey ()
public subroutine documentation ()
public subroutine _clearattachments ()
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

_createdatastore( "claimpicklist", "d_sq_tb_specialclaim_list", "")
_createdatastore( "claimbase", "d_sq_tb_specialclaim_base", "")
_createdatastore( "claimaction", "d_sq_tb_specialclaim_action", "")
_createdatastore( "claimtransaction", "d_sq_tb_specialclaim_transaction", "")
_createdatastore( "claimattachment", "d_sq_tb_specialclaim_file_list", "")

_setdetail( "claimpicklist", "claimbase", {"special_claim_id"})
_setdetail( "claimpicklist", "claimaction", {"special_claim_id"})
_setdetail( "claimpicklist", "claimtransaction", {"special_claim_id"})
_setdetail( "claimpicklist", "claimattachment", {"special_claim_id"})




end subroutine

public function long of_retrieve ();/********************************************************************
   of_retrieve
   <DESC> Retrieves the first dataset</DESC>
   <RETURN> LOng:
            <LI> # of row retrieved</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> (none) </ARGS>
   <USAGE>  This function is an overload of the interface function generic code, since
	we do not have time to finalize the generic code. The first dataset is the master
	claim list
	</USAGE>
********************************************************************/
return istr_datastore[1].ds_data.retrieve()



end function

public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row);/********************************************************************
   of_rowFocusChanged
   <DESC>  This function is called to retrieve all the detail datasets belonging to
	the passed master dataset</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_master_dsname: Master dataset name
            al_row: Pointer to selected row in master dataset</ARGS>
   <USAGE> </USAGE>
********************************************************************/
long ll_specialClaimID

if al_row < 1 then return c#return.noaction

if as_master_dsname = "claimpicklist" then
	ll_specialClaimID = istr_datastore[1].ds_data.getItemNumber(al_row, "special_claim_id")
	
	istr_datastore[2].ds_data.retrieve(ll_specialClaimID)
	istr_datastore[3].ds_data.retrieve(ll_specialClaimID)
	istr_datastore[4].ds_data.retrieve(ll_specialClaimID)
	istr_datastore[5].ds_data.retrieve(ll_specialClaimID)
	_clearattachments( )
end if

return c#return.success
end function

public function integer of_insertrow (readonly string as_dsname);/********************************************************************
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

choose case as_dsName
	case "claimbase", "claimpicklist"
		istr_datastore[2].ds_data.Reset()
		istr_datastore[3].ds_data.Reset()
		istr_datastore[4].ds_data.Reset()
		istr_datastore[5].ds_data.Reset()
		_clearattachments( )
		ll_row = istr_datastore[2].ds_data.insertRow(0)
		if ll_row < 1 then
			_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Special Claim", "")
			return c#return.failure
		end if
		istr_datastore[2].ds_data.setItem( ll_row, "responsible_person", uo_global.is_userid )
	case "claimaction"
		ll_row = istr_datastore[3].ds_data.insertRow(0)
		if ll_row < 1 then
			_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Special Claim Action", "")
			return c#return.failure
		end if
		istr_datastore[3].ds_data.setItem( ll_row, "user_action", 1 )
		istr_datastore[3].ds_data.setItem( ll_row, "action_date", datetime(today(), now()) )
		istr_datastore[3].ds_data.setItem( ll_row, "created_by", uo_global.is_userid )
		istr_datastore[3].ds_data.setItem( ll_row, "finished", 0 )
	case "claimtransaction"
		if (uo_global.ii_user_profile = 3) &
		or (uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2)  then
			// ok to insert
		else
			_addmessage( this.classdefinition, METHOD_NAME, "As you are not a finance or operations superuser, you are not allowed to enter transactions ", "It is decided by operations that only Users with Finance profile and operations superusers can enter transactions"  )
			return c#return.noaction
		end if
		ll_row = istr_datastore[4].ds_data.insertRow(0)
		if ll_row < 1 then
			_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Special Claim Transaction", "")
			return c#return.failure
		end if
		istr_datastore[4].ds_data.setItem( ll_row, "transaction_date", datetime(today(), now()) )
		istr_datastore[4].ds_data.setItem( ll_row, "created_by", uo_global.is_userid )
		istr_datastore[4].ds_data.setItem( ll_row, "curr_code", "USD" )
		istr_datastore[4].ds_data.setItem( ll_row, "ex_rate_claim_curr", 100 )
		istr_datastore[4].ds_data.setItem( ll_row, "transaction_code", "R" )
	case "claimattachment"
		/* get file details from diaologue control */
		if GetFileOpenName("Select Document", ls_docpath, ls_docname) <1 then return c#return.failure
		ll_row = istr_datastore[5].ds_data.insertRow(0)
		if ll_row < 1 then
			_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Special Claim Attachment", "")
			return c#return.failure
		end if
		_il_new_file_id --
		/* save data directly into blob */
		ll_filehandle = fileopen(ls_docpath, streammode!,Read!)
		ll_att_index = upperBound(_inv_att) +1
		ll_file_size = filereadex(ll_filehandle, lbl_filedata)
		fileclose(ll_filehandle)
		if ll_file_size <= 0 then
			MessageBox("Info", "Error loading selected file: please check if the file is empty.")
			return c#return.failure
		end if

		_inv_att[ll_att_index].ibl_image = lbl_filedata
		_inv_att[ll_att_index].il_file_id = _il_new_file_id
		_inv_att[ll_att_index].is_method = "new"
		_inv_att[ll_att_index].il_file_size = ll_file_size
		
		istr_datastore[5].ds_data.setitem(ll_row,"file_updated_date", now())
		istr_datastore[5].ds_data.setitem(ll_row,"last_edited_by", uo_global.is_userid)
		istr_datastore[5].ds_data.setitem(ll_row,"insert_index", _il_new_file_id)
		istr_datastore[5].ds_data.setitem(ll_row, "description", ls_docname)
		istr_datastore[5].ds_data.setitem(ll_row, "file_name", ls_docname)
end choose

return ll_row

end function

public function integer of_deleterow (readonly string as_dsname, long al_row);/********************************************************************
   of_deleteRow
   <DESC> Deletes the roe requested by the user, after confirmation that it is OK
	Depending on where the delete is initiated from, there can be deleted many
	detail rows and a master.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   as_dsName: dataset name from where the delete is initiated
            		al_row: Rownumber to delete in dataset</ARGS>
   <USAGE>  .</USAGE>
********************************************************************/
constant string METHOD_NAME = "of_deleteRow"
long 	ll_row, ll_rows, ll_found 
long	ll_SpecialClaimID
string	ls_message

if al_row < 1 then return c#return.noaction

choose case as_dsName
	case "claimpicklist", "claimbase" 
		ls_message = "You are about to DELETE selected Claim and All attached information!~r~n~r~n" + &
				  			"Are you sure you want to continue?"
	case "claimaction"
		ls_message = "You are about to DELETE selected Claim Action!~r~n~r~n" + &
				  			"Are you sure you want to continue?"
	case "claimtransaction"
		ls_message = "You are about to DELETE selected Claim Transaction!~r~n~r~n" + &
				  			"Are you sure you want to continue?"
	case "claimattachment"
		ls_message = "You are about to DELETE selected Claim Attachment!~r~n~r~n" + &
				  			"Are you sure you want to continue?"
end choose
		
if MessageBox("Confirm Delete",ls_message ,Question!,YesNo!,2) = 2 THEN return -1

choose case as_dsName
	case "claimpicklist", "claimbase" 
		commit;   //just to be sure to start a new transaction
		//first check if there are any transactions. then not allowed to delete unless finance profile
		ll_rows = istr_datastore[4].ds_data.rowCount()
		if ll_rows > 0 then
			if (uo_global.ii_user_profile = 3) &
			or (uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2)  then
				// ok to delete
			else
				_addmessage( this.classdefinition, METHOD_NAME, "As you are not a finance or operations superuser, you are not allowed to delete transactions ", "It is decided by operations that only Users with Finance profile and operations superusers can delete transactions"  )
				return c#return.noaction
			end if
		end if
		for ll_row = 1 to ll_rows 
			istr_datastore[4].ds_data.DeleteRow(1)
			if istr_datastore[4].ds_data.Update() <> 1 then
				_addmessage( this.classdefinition, METHOD_NAME, "Error deleting transaction!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
				rollback;
				return c#return.failure
			end if
		next
		//next delete all attached files
		ll_rows = istr_datastore[5].ds_data.rowCount()
		for ll_row = 1 to ll_rows 
			if _deleteattachment( 1 ) = c#return.failure then
				_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Attactment!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
				rollback;
				return c#return.failure
			end if		
				
			istr_datastore[5].ds_data.DeleteRow( 1 )
			if istr_datastore[5].ds_data.Update() <> 1 then
				_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Attactment!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
				rollback;
				return c#return.failure
			end if		
		next
		//delete actions is any
		ll_rows = istr_datastore[3].ds_data.rowCount()
		for ll_row = 1 to ll_rows 
			istr_datastore[3].ds_data.DeleteRow( 1 )
			if istr_datastore[3].ds_data.Update() <> 1 then
				_addmessage( this.classdefinition, METHOD_NAME, "Error deleting actions!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
				rollback;
				return c#return.failure
			end if
		next
		//delete baseclaim and remove from list
		ll_SpecialClaimID = istr_datastore[2].ds_data.getITemNUmber(1, "special_claim_id")
		istr_datastore[2].ds_data.DeleteRow(1)
		if istr_datastore[2].ds_data.Update() <> 1 then
			_addmessage( this.classdefinition, METHOD_NAME, "Error deleting actions!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
			rollback;
			return c#return.failure
		end if
		ll_found =istr_datastore[1].ds_data.find("special_claim_id="+string(ll_SpecialClaimID),1,999999)
		if ll_found > 0 then istr_datastore[1].ds_data.DeleteRow(ll_found)
		commit;
	case "claimaction"
		// Validate if action is a system action
		if istr_datastore[3].ds_data.getItemNumber(al_row, "user_action") = 0 then
			_addmessage( this.classdefinition, METHOD_NAME, "You are not allowed to delete a system action!", "n/a" )
			return c#return.failure
		end if
		// Validate if action is finished
		if istr_datastore[3].ds_data.getItemNumber(al_row, "finished") = 1 then
			_addmessage( this.classdefinition, METHOD_NAME, "You are not allowed to delete a finished action!", "n/a" )
			return c#return.failure
		end if
		
		istr_datastore[3].ds_data.DeleteRow(al_row)
		if istr_datastore[3].ds_data.Update() = 1 then
			commit;
		else
			_addmessage( this.classdefinition, METHOD_NAME, "Error deleting transaction!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
			rollback;
			return c#return.failure
		end if
	case "claimtransaction"
		if (uo_global.ii_user_profile = 3) &
		or (uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2)  then
			// ok to delete
		else
			_addmessage( this.classdefinition, METHOD_NAME, "As you are not a finance or operations superuser, you are not allowed to delete transactions ", "It is decided by operations that only Users with Finance profile and operations superusers can delete transactions"  )
			return c#return.noaction
		end if

		istr_datastore[4].ds_data.DeleteRow(al_row)
		if istr_datastore[4].ds_data.Update() = 1 then
			commit;
		else
			_addmessage( this.classdefinition, METHOD_NAME, "Error deleting transaction!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
			rollback;
			return c#return.failure
		end if
		
		//claim balance, has to be calculated
		if istr_datastore[2].ds_data.rowcount() > 0 then
			ll_SpecialClaimID = istr_datastore[2].ds_data.getitemnumber(1, "special_claim_id")
			ll_row = istr_datastore[1].ds_data.find("special_claim_id=" + string(ll_SpecialClaimID), 1,  istr_datastore[1].ds_data.rowcount())
			if ll_row > 0 then
				if istr_datastore[4].ds_data.rowcount() > 0 then
					istr_datastore[1].ds_data.setitem(ll_row, "claim_balance", istr_datastore[2].ds_data.getitemnumber(1, "amount") - istr_datastore[4].ds_data.getitemnumber(1, "total_amount"))
				else
					istr_datastore[1].ds_data.setitem(ll_row, "claim_balance", istr_datastore[2].ds_data.getitemnumber(1, "amount"))
				end if
				
				istr_datastore[1].ds_data.resetupdate()
			end if
		end if	
	case "claimattachment"
		if _deleteattachment( al_row ) = c#return.failure then
			_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Attactment!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
			rollback;
			return c#return.failure
		end if		
			
		istr_datastore[5].ds_data.DeleteRow(al_row)
		if istr_datastore[5].ds_data.Update() = 1 then
			commit;
		else
			_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Attactment!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
			rollback;
			return c#return.failure
		end if		
end choose

return c#return.success




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
long	ll_row
boolean 	lb_ClaimbaseNew=false 
datawindowchild	ldwc
long ll_vessel_nr,  ll_found, ll_customer_nr, ll_office_nr
string ls_columnNr, ls_columnName, ls_userid
string ls_null; setNull(ls_null)
string ls_currcode
decimal{2} ld_amount, ld_amount_usd
n_claimcurrencyadjust lnv_claimcurrencyadjust

// validates all datasets
if _validate() = c#return.failure then
	return c#return.failure
end if

// Claim Base Information
commit;     //start a new transaction
if istr_datastore[2].ds_data.getItemStatus(1, 0, primary!) = newmodified! then
	lb_ClaimbaseNew = true
end if

ls_currcode = istr_datastore[2].ds_data.getitemstring(1, "curr_code")
ld_amount = istr_datastore[2].ds_data.getitemnumber(1, "amount")
lnv_claimcurrencyadjust.of_getamountusd("SPEC", ls_currcode , ld_amount, ld_amount_usd)
istr_datastore[2].ds_data.setitem(1, "amount_usd", ld_amount_usd)

if istr_datastore[2].ds_data.update(true, false) = 1 then
	// set foreign key in detail datastores
	_setforeignkey( )
	if istr_datastore[3].ds_data.update(true, false) = 1 then
		if istr_datastore[4].ds_data.update(true, false) = 1 then
			if istr_datastore[5].ds_data.update(true, false) = 1 then
				if _updateAttachments( ) = c#return.success then
					commit;
					istr_datastore[2].ds_data.resetUpdate()
					istr_datastore[3].ds_data.resetUpdate()
					istr_datastore[4].ds_data.resetUpdate()
					istr_datastore[5].ds_data.resetUpdate()
					_clearattachments( )
				else
					rollback;
					_addmessage( this.classdefinition, METHOD_NAME, "Update og Special Claim Attachment BLOBS failed!", "N/A")
					return c#return.failure
				end if			
			else
				rollback;
				_addmessage( this.classdefinition, METHOD_NAME, "Update og Special Claim Attachment failed!", "N/A")
				return c#return.failure
			end if
		else
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME, "Update og Special Claim Transaction failed!", "N/A")
			return c#return.failure
		end if
	else
		rollback;
		_addmessage( this.classdefinition, METHOD_NAME, "Update og Special Claim Action failed!", "N/A")
		return c#return.failure
	end if
else
	rollback;
	_addmessage( this.classdefinition, METHOD_NAME, "Update og Special Claim Base Information failed!", "N/A")
	return c#return.failure
end if	

// if new baseclaim insert new row, otherwise just update list
if lb_ClaimbaseNew then
	ll_row =istr_datastore[1].ds_data.insertRow(0)
else
	ll_row = istr_datastore[1].ds_data.find("special_claim_id="+string(istr_datastore[2].ds_data.getItemNUmber(1, "special_claim_id")),1,999999)
end if

// Update picklist when update succeded
if ll_row > 0 then
	istr_datastore[1].ds_data.setitem(ll_Row, "special_claim_id", istr_datastore[2].ds_data.getItemNUmber(1, "special_claim_id"))
	// vessel and voyage	
	ll_vessel_nr = istr_datastore[2].ds_data.GetItemNumber(1,"vessel_nr")
	istr_datastore[2].ds_data.GetChild("vessel_nr", ldwc)
	ll_found = ldwc.find("vessel_nr="+string(ll_vessel_nr),1,999999)
	istr_datastore[1].ds_data.setitem(ll_Row, "vessel_ref_nr", ldwc.getItemString(ll_found, "vessel_ref_nr") )
	istr_datastore[1].ds_data.setitem(ll_Row, "vessel_name", ldwc.getItemString(ll_found, "vessel_name") )
	istr_datastore[1].ds_data.setitem(ll_Row, "voyage_nr", istr_datastore[2].ds_data.getItemString(1, "voyage_nr"))
	istr_datastore[1].ds_data.setitem(ll_Row, "income", istr_datastore[2].ds_data.getItemNumber(1, "income"))
	// customer
	istr_datastore[1].ds_data.setItem(ll_row , "chart_n_1", ls_null) 
	istr_datastore[1].ds_data.setItem(ll_row, "tcowner_n_1", ls_null) 
	istr_datastore[1].ds_data.setItem(ll_row, "agent_n_1", ls_null) 
	istr_datastore[1].ds_data.setItem(ll_row, "broker_name", ls_null) 
	istr_datastore[1].ds_data.setItem(ll_row, "third_party_name", ls_null) 
	choose case istr_datastore[2].ds_data.getItemNumber(1, "debtor_creditor")
		case 1
			ls_columnNr = "chart_nr"
			ls_columnName = "chart_n_1"
		case 2, 3
			ls_columnNr = "tcowner_nr"
			ls_columnName = "tcowner_n_1"
		case 4
			ls_columnNr = "agent_nr"
			ls_columnName = "agent_n_1"
		case 5
			ls_columnNr = "broker_nr"
			ls_columnName = "broker_name"
		case 6 
			setNull( ls_columnName )
	end choose
	if isNull(ls_columnName) then
		istr_datastore[1].ds_data.setitem(ll_Row, "third_party_name", istr_datastore[2].ds_data.getItemString(1, "third_party_name"))
	else
		ll_customer_nr = istr_datastore[2].ds_data.GetItemNumber(1, ls_columnNr )
		istr_datastore[2].ds_data.GetChild(ls_columnNr , ldwc)
		ll_found = ldwc.find( ls_columnNr+"="+string(ll_customer_nr),1,999999)
		istr_datastore[1].ds_data.setitem(ll_Row, ls_columnName , ldwc.getItemString(ll_found, ls_columnName) )
	end if
	istr_datastore[1].ds_data.setitem(ll_Row, "special_claim_type", istr_datastore[2].ds_data.getItemString(1, "special_claim_type"))
	istr_datastore[1].ds_data.setitem(ll_Row, "timebar_date", istr_datastore[2].ds_data.getItemDatetime(1, "timebar_date"))
	istr_datastore[1].ds_data.setitem(ll_Row, "forwarding_date", istr_datastore[2].ds_data.getItemDatetime(1, "forwarding_date"))
	istr_datastore[1].ds_data.setitem(ll_Row, "curr_code", istr_datastore[2].ds_data.getItemString(1, "curr_code"))
	istr_datastore[1].ds_data.setitem(ll_Row, "claim_amount", istr_datastore[2].ds_data.getItemNumber(1, "amount"))
	//responsible person
	ls_userid = istr_datastore[2].ds_data.GetItemString(1, "responsible_person" )
	istr_datastore[2].ds_data.GetChild("responsible_person" , ldwc)
	ll_found = ldwc.find( "userid='"+ls_userid+"'" ,1,999999)
	istr_datastore[1].ds_data.setitem(ll_Row, "responsible", ldwc.getItemString(ll_found, "first_last_name") )
	istr_datastore[1].ds_data.setitem(ll_Row, "responsible_person", ls_userid )
	//claim balance, has to be calculated
	if istr_datastore[4].ds_data.rowCount() > 0 then
		istr_datastore[1].ds_data.setitem(ll_Row, "claim_balance", istr_datastore[2].ds_data.getItemNumber(1, "amount") - istr_datastore[4].ds_data.getItemNumber(1, "total_amount"))
	else
		istr_datastore[1].ds_data.setitem(ll_Row, "claim_balance", istr_datastore[2].ds_data.getItemNumber(1, "amount"))
	end if
	//Office
	ll_office_nr  = istr_datastore[2].ds_data.GetItemNumber(1, "responsible_office" )
	istr_datastore[2].ds_data.GetChild("responsible_office" , ldwc)
	ll_found = ldwc.find( "office_nr="+string(ll_office_nr),1,999999)
	istr_datastore[1].ds_data.setitem(ll_Row, "responsible_office", ldwc.getItemString(ll_found, "office_sn") )
	istr_datastore[1].ds_data.setitem(ll_Row, "last_action", datetime(today(), now()))
	istr_datastore[1].ds_data.resetUpdate()

	//refresh actions, as the system actions are implemented at DB triggers
	istr_datastore[3].ds_data.retrieve(istr_datastore[2].ds_data.getItemNUmber(1, "special_claim_id"))
end if

return c#return.success
end function

public function integer of_itemchanged (ref mt_u_datawindow adw_data, readonly long al_row, readonly dwobject adwo_object, readonly string as_data);/********************************************************************
   of_itemChanged
   <DESC> Does the datamanupulation needed when the user is entering data.
	On the base claim level, it is like populating a voyage list when vessel is selected.
	Picking the customer from the C/P or TC Contract when opponent type is entered e.t.c.
	On the action level, update the date and by whom when an action is finished</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>   adw_data: Reference to datawindow where item was changed
            		al_row: Row number
				adwo_object. Reference to dwo
				as_data: content/value of data changed</ARGS>
   <USAGE>  pass the itenchanged event from the datawindow container to this</USAGE>
********************************************************************/
constant string METHOD_NAME = "of_itemChanged"
string					ls_null;setNull(ls_null)
long					ll_null; setNull(ll_null)
string 				ls_voyageNr
datetime 			ldt_null
datawindowchild	ldwc
long					ll_vesselNr, ll_customerNr
long					ll_year
string ls_currcode
decimal{2} ld_amount, ld_amount_usd
n_claimcurrencyadjust lnv_claimcurrencyadjust

choose case adw_data.is_dsName
	case "claimbase"
		choose case adwo_object.name
			case  "vessel_nr" 
				// if vessel number then refresh voyages list and reset 'customer selection'
				// but only thouse who can be entered by the system
				//reset voyages 
				adw_data.setItem(al_row, "voyage_nr", ls_null)
				if adw_data.getChild("voyage_nr", ldwc) = 1 then
					ldwc.settransobject(SQLCA)
					ldwc.retrieve(long(as_data))
				end if
				choose case adw_data.getItemNumber(al_row, "debtor_creditor") 
					case 1, 2, 3, 5
						adw_data.setItem(al_row, "debtor_creditor", ll_null )
						adw_data.setItem(al_row, "chart_nr", ll_null)
						adw_data.setItem(al_row, "tcowner_nr", ll_null)
						adw_data.setItem(al_row, "broker_nr", ll_null)
				end choose
			case  "voyage_nr" 
				// if voyage number then  reset 'customer selection'
				// but only thouse who can be entered by the system
				choose case adw_data.getItemNumber(al_row, "debtor_creditor") 
					case 1, 2, 3, 5
						adw_data.setItem(al_row, "debtor_creditor", ll_null )
						adw_data.setItem(al_row, "chart_nr", ll_null)
						adw_data.setItem(al_row, "tcowner_nr", ll_null)
						adw_data.setItem(al_row, "broker_nr", ll_null)
				end choose
			case "debtor_creditor"
				ll_vesselNr = adw_data.getItemNumber(al_row,"vessel_nr")
				if isnull( ll_vesselNr )  then  return c#return.noAction
				// if charterer, check if voyage selected. if yes, get charterer
				if long(as_data) = 1 then 
					ls_voyageNr = adw_data.getItemString(al_row,"voyage_nr")
					if isnull( ls_voyageNr ) then return c#return.noAction
					ll_customerNr = adw_data.getItemNumber(al_row, "chart_nr")
					if not isnull(ll_customerNr) then return c#return.noAction
					if len(trim(ls_voyageNr)) = 5 then
						// 'single voyage' , take from cargo/cp
						SELECT TOP 1 CAL_CERP.CHART_NR  
							INTO :ll_customerNr  
							FROM CAL_CARG,   
								CAL_CERP,   
								VOYAGES  
							WHERE CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID
							AND CAL_CARG.CAL_CALC_ID = VOYAGES.CAL_CALC_ID 
							AND VOYAGES.VESSEL_NR = :ll_vesselNr
							AND VOYAGES.VOYAGE_NR = :ls_voyageNr ;
						if sqlca.sqlcode = 0 then
							adw_data.setItem(al_row, "chart_nr", ll_customerNr)
						elseif sqlca.sqlcode = -1 then
							_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Charterer from the Cargo C/P" , sqlca.sqlerrtext )
						end if
						commit;
					else
						// 'tcout voyage' take from TC Contract
						if mid(ls_voyageNr,1,1) = "9" then
							ll_year = long( "19"+mid(ls_voyageNr,1,2) )
						else
							ll_year = long( "20"+mid(ls_voyageNr,1,2) )
						end if
						SELECT TOP 1 NTC_TC_CONTRACT.CHART_NR  
							INTO :ll_customerNr 
							FROM NTC_TC_CONTRACT,   
								NTC_TC_PERIOD  
							WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
							AND NTC_TC_CONTRACT.TC_HIRE_IN = 0
							AND NTC_TC_CONTRACT.VESSEL_NR = :ll_vesselNr
							AND year(NTC_TC_PERIOD.PERIODE_START) = :ll_year  ;
						if sqlca.sqlcode = 0 then
							adw_data.setItem(al_row, "chart_nr", ll_customerNr)
						elseif sqlca.sqlcode = -1 then
							_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Charterer from the TC Contract" , sqlca.sqlerrtext )
						end if
						commit;
					end if
				end if
				// if TC Owner
				if long(as_data) = 2 then 
					ls_voyageNr = adw_data.getItemString(al_row,"voyage_nr")
					if isnull( ls_voyageNr ) then return c#return.noAction
					if len(trim(ls_voyageNr)) = 5 then
						// 'single voyage' , take Head Owner from TC Contract
						if mid(ls_voyageNr,1,1) = "9" then
							ll_year = long( "19"+mid(ls_voyageNr,1,2) )
						else
							ll_year = long( "20"+mid(ls_voyageNr,1,2) )
						end if
						SELECT TOP 1 NTC_TC_CONTRACT.TCOWNER_NR  
							INTO :ll_customerNr 
							FROM NTC_TC_CONTRACT,   
								NTC_TC_PERIOD  
							WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
							AND NTC_TC_CONTRACT.TC_HIRE_IN = 1
							AND NTC_TC_CONTRACT.VESSEL_NR = :ll_vesselNr
							AND year(NTC_TC_PERIOD.PERIODE_START) = :ll_year  ;
						if sqlca.sqlcode = 0 then
							adw_data.setItem(al_row, "tcowner_nr", ll_customerNr)
						elseif sqlca.sqlcode = -1 then
							_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Contract Owner from the TC Contract" , sqlca.sqlerrtext )
						end if
						commit;
					else
						// 'tcout voyage' take Contract from TC Contract
						if mid(ls_voyageNr,1,1) = "9" then
							ll_year = long( "19"+mid(ls_voyageNr,1,2) )
						else
							ll_year = long( "20"+mid(ls_voyageNr,1,2) )
						end if
						SELECT TOP 1 NTC_TC_CONTRACT.CONTRACT_TCOWNER_NR  
							INTO :ll_customerNr 
							FROM NTC_TC_CONTRACT,   
								NTC_TC_PERIOD  
							WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
							AND NTC_TC_CONTRACT.TC_HIRE_IN = 0
							AND NTC_TC_CONTRACT.VESSEL_NR = :ll_vesselNr
							AND year(NTC_TC_PERIOD.PERIODE_START) = :ll_year  ;
						if sqlca.sqlcode = 0 then
							adw_data.setItem(al_row, "tcowner_nr", ll_customerNr)
						elseif sqlca.sqlcode = -1 then
							_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Contract Owner from the TC Contract" , sqlca.sqlerrtext )
						end if
						commit;
					end if
				end if
				// if HeadOwner
				if long(as_data) = 3 then 
					SELECT TOP 1 TCOWNER_NR  
						INTO :ll_customerNr 
						FROM VESSELS  
						WHERE VESSEL_NR = :ll_vesselNr  ;
					if sqlca.sqlcode = 0 then
						adw_data.setItem(al_row, "tcowner_nr", ll_customerNr)
					elseif sqlca.sqlcode = -1 then
						_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Contract Owner from the TC Contract" , sqlca.sqlerrtext )
					end if
					commit;
				end if							
				// if Broker, check if voyage selected. if yes, get broker
				if long(as_data) = 5 then 
					ls_voyageNr = adw_data.getItemString(al_row,"voyage_nr")
					if isnull( ls_voyageNr ) then return c#return.noAction
					ll_customerNr = adw_data.getItemNumber(al_row, "broker_nr")
					if not isnull(ll_customerNr) then return c#return.noAction
					if len(trim(ls_voyageNr)) = 5 then
						// 'single voyage' , take from cargo/cp
						SELECT TOP 1 CAL_COMM.BROKER_NR  
							INTO :ll_customerNr  
							FROM CAL_CARG,   
								CAL_CERP,
								CAL_COMM,
								BROKERS,
								VOYAGES
							WHERE CAL_COMM.CAL_CERP_ID = CAL_CERP.CAL_CERP_ID
							AND CAL_CERP.CAL_CERP_ID = CAL_CARG.CAL_CERP_ID
							AND CAL_CARG.CAL_CALC_ID = VOYAGES.CAL_CALC_ID
							AND CAL_COMM.BROKER_NR = BROKERS.BROKER_NR
							AND BROKERS.BROKER_POOL_MANAGER = 0
							AND VOYAGES.VESSEL_NR = :ll_vesselNr
							AND VOYAGES.VOYAGE_NR = :ls_voyageNr ;
						if sqlca.sqlcode = 0 then
							adw_data.setItem(al_row, "broker_nr", ll_customerNr)
						elseif sqlca.sqlcode = -1 then
							_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Broker from the Cargo C/P" , sqlca.sqlerrtext )
						end if
						commit;
					else
						// 'tcout voyage' take from TC Contract
						if mid(ls_voyageNr,1,1) = "9" then
							ll_year = long( "19"+mid(ls_voyageNr,1,2) )
						else
							ll_year = long( "20"+mid(ls_voyageNr,1,2) )
						end if
						SELECT TOP 1 NTC_CONT_BROKER_COMM.BROKER_NR  
							INTO :ll_customerNr 
							FROM NTC_TC_CONTRACT,   
								NTC_TC_PERIOD,
								NTC_CONT_BROKER_COMM,
								BROKERS
							WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
							AND NTC_CONT_BROKER_COMM.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID
							AND NTC_CONT_BROKER_COMM.BROKER_NR = BROKERS.BROKER_NR
							AND BROKERS.BROKER_POOL_MANAGER = 0
							AND NTC_TC_CONTRACT.TC_HIRE_IN = 0
							AND NTC_TC_CONTRACT.VESSEL_NR = :ll_vesselNr
							AND year(NTC_TC_PERIOD.PERIODE_START) = :ll_year  ;
						if sqlca.sqlcode = 0 then
							adw_data.setItem(al_row, "broker_nr", ll_customerNr)
						elseif sqlca.sqlcode = -1 then
							_addmessage( this.classdefinition , METHOD_NAME , "Error reading the Charterer from the TC Contract" , sqlca.sqlerrtext )
						end if
						commit;
					end if
				end if
		end choose
	case "claimaction"
		// If the datawindow is actions and the user has pressed the finished 
		// checkmark, the date and userid will be stored
		if adwo_object.name = "finished" then
			if as_data = "1" then
				adw_data.setItem(al_row, "finished_date", datetime(today(), now()))
				adw_data.setItem(al_row, "finished_by", uo_global.is_userid)
			else
				setNull(ls_null)
				setNull(ldt_null)
				adw_data.setItem(al_row, "finished_date", ldt_null )
				adw_data.setItem(al_row, "finished_by", ls_null )
			end if
		end if
	case "claimtransaction"
		if adwo_object.name = "amount" then
			ls_currcode = istr_datastore[2].ds_data.getitemstring(1, "curr_code")
			ld_amount = dec(as_data)
			lnv_claimcurrencyadjust.of_getamountusd("SPEC", ls_currcode , ld_amount, ld_amount_usd)
			adw_data.setitem(al_row, "amount_usd", ld_amount_usd)
		end if
end choose

return c#return.success
end function

public function integer of_printinvoice (long al_row);/********************************************************************
   of_printInvoice
   <DESC> Uses the n_specialclaim_invoice object to create an invoice using MS Word
	template </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   al_row: pointer to claim to print</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
n_specialclaim_invoice	lnv_invoice
long 	ll_claimID

if al_row < 1 then return c#return.noaction

lnv_invoice = create n_specialclaim_invoice
ll_claimID = istr_datastore[1].ds_data.getItemNumber(al_row, "special_claim_id")
if lnv_invoice.of_print( ll_claimID ) = c#return.failure then
	return c#return.failure
end if
destroy lnv_invoice

return c#return.success


end function

private function integer _updateattachments ();/********************************************************************
   _updateAttachment
   <DESC> Update the file attachment in the FILES database
	using the file attachment service</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS> (none)  </ARGS>
********************************************************************/
long 	ll_rows, ll_row, ll_found
long   ll_fileID
n_service_manager 		lnv_serviceManager
n_fileattach_service		lnv_FileAttService

ll_rows = upperbound(_inv_att)
if ll_rows = 0 then return c#return.success

lnv_serviceManager.of_loadservice( lnv_FileAttService , "n_fileattach_service")
lnv_FileAttService.of_activate( )
for ll_row = 1 to ll_rows
	choose case _inv_att[ll_row].is_method
		case "new"
			ll_found = istr_datastore[5].ds_data.find("insert_index="+string(_inv_att[ll_row].il_file_id),1,999999)
			if ll_found > 0 then
				ll_fileID = istr_datastore[5].ds_data.getItemNumber(ll_found, "file_id")
				if lnv_FileAttService.of_write( "SPECIAL_CLAIM_ATT_FILES", ll_fileID, _inv_att[ll_row].ibl_image, _inv_att[ll_row].il_file_size) = c#return.failure then
					return c#return.failure
				end if
			end if						
	end choose
next
lnv_FileAttService.of_deactivate()

return c#return.success
end function

public function integer of_openattachment (long al_row);/********************************************************************
   of_openAttachment 
   <DESC> Open the file attachment in the FILES database
	using the file attachment service.
	Attachment is opened in an OLE control in a separate hidden window</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   al_row: pointer to the attachment</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_openAttachment "

blob							lbl_filecontent
integer						li_blobrow = 1, li_dwrow = 1, li_att_index
boolean						lb_found=false
long 							ll_fileid
string							ls_fileName
n_olefilecontent			lnv_olefilecontent
pointer 						lpt_oldpointer
n_service_manager 		lnv_serviceManager
n_fileattach_service		lnv_fileAttService

lnv_serviceManager.of_loadservice( lnv_FileAttService , "n_fileattach_service")

ll_fileid = istr_datastore[5].ds_data.getItemNumber(al_row, "file_id")

if isnull(ll_fileid) then
	ll_fileid = istr_datastore[5].ds_data.getItemNumber(al_row, "insert_index")
end if

// lookup file in local array - if file is not saved yet
for li_att_index = 1 to upperbound(_inv_att)
	if _inv_att[li_att_index].of_get_file_id() = ll_fileid then
		lbl_filecontent = _inv_att[li_att_index].ibl_image		
		lb_found=true
		li_att_index = upperbound(_inv_att)
	end if
next

if not lb_found then
	lpt_oldPointer = setPointer(hourglass!)
	lnv_FileAttService.of_activate( )
	if lnv_fileAttService.of_Read("SPECIAL_CLAIM_ATT_FILES",ll_fileid, lbl_filecontent) <> 0 then
		_addmessage(this.classdefinition, METHOD_NAME,"There is no file attached.", 'Error loading lnv_fileAttService.of_Read("SPECIAL_CLAIM_ATT_FILES",ll_fileid, lbl_filecontent)')
	end if
	lnv_FileAttService.of_deactivate()

	setPointer(lpt_oldPointer)
end if

if isnull(lbl_filecontent) then
	return c#return.Failure
else
	ls_filename = istr_datastore[5].ds_data.getItemString(al_row, "file_name")
	if NOT isvalid(w_oledocument) then open(w_oledocument)
	lnv_olefilecontent = create n_olefilecontent
	lnv_olefilecontent.of_OpenBlobInOle( lbl_filecontent, w_oledocument.ole_document , ls_filename )
	destroy lnv_olefilecontent
end if


return c#return.success
end function

private function integer _deleteattachment (long al_row);/********************************************************************
   _deleteAttachment
   <DESC> Deletes the file attachment, from the FILES database
	using the file attachment service</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   al_row: Row number refrence to get the key</ARGS>
********************************************************************/
constant string METHOD_NAME = "_deleteAttachment "

integer						li_att_index
boolean						lb_found=false
long 							ll_fileid
n_olefilecontent			lnv_olefilecontent
pointer 						lpt_oldpointer
n_service_manager 		lnv_serviceManager
n_fileattach_service		lnv_fileAttService

lnv_serviceManager.of_loadservice( lnv_FileAttService , "n_fileattach_service")

ll_fileid = istr_datastore[5].ds_data.getItemNumber(al_row, "file_id")

if isnull(ll_fileid) then
	ll_fileid = istr_datastore[5].ds_data.getItemNumber(al_row, "insert_index")
end if

for li_att_index = 1 to upperbound(_inv_att)
	if _inv_att[li_att_index].of_get_file_id() = ll_fileid then
		setnull(_inv_att[li_att_index].ibl_image)		
		setnull(_inv_att[li_att_index].is_method)
		lb_found=true
		exit
	end if
next

if not lb_found then
	lpt_oldPointer = setPointer(hourglass!)
	lnv_FileAttService.of_activate( )
	if lnv_fileAttService.of_Delete("SPECIAL_CLAIM_ATT_FILES",ll_fileid) <> 0 then
		_addmessage(this.classdefinition, METHOD_NAME,"There is no file attached.", 'Error deleting lnv_fileAttService.of_Delete("SPECIAL_CLAIM_ATT_FILES",ll_fileid)')
	end if
	lnv_FileAttService.of_deactivate()
	setPointer(lpt_oldPointer)
end if

return c#return.success
end function

private function integer _validate ();/********************************************************************
   _validate
   <DESC> Checks if anything changed in the datasets, and if so sends the
	validation to the relevant function(s)
	The reason behind doing this split, is that then the validation later on
	can be moved to a 'business object'</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   (none) </ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "_validate"

// check if there is a row in the base claim information datastore
if istr_datastore[2].ds_data.rowCount() = 0  then
	_addmessage( this.classdefinition, METHOD_NAME , "Please press the insert button, to add a claim or select one claim from the list", "N/A")
	return c#return.failure
end if

// check if there is no data entered
if istr_datastore[2].ds_data.getItemStatus(1, 0, primary!) = new!  then
	_addmessage( this.classdefinition, METHOD_NAME , "Please enter base claim information before updating", "N/A")
	return c#return.failure
end if

// Claim Base Information
if istr_datastore[2].ds_data.modifiedCount() > 0 then
	if _validateBase( ) = c#return.failure then
		return c#return.failure
	end if
end if	
// Actions
if istr_datastore[3].ds_data.modifiedCount() > 0 then
	if _validateAction( ) = c#return.failure then 
		return c#return.failure
	end if
end if
//Transaction
if istr_datastore[4].ds_data.modifiedCount() > 0 then
	if _validateTransaction( ) = c#return.failure then 
		return c#return.failure
	end if
end if
//Attachments
if istr_datastore[5].ds_data.modifiedCount() > 0 then
	if _validateAttachment( ) = c#return.failure then 
		return c#return.failure
	end if
end if

return c#return.success
end function

private function integer _validateaction ();/********************************************************************
   _validateAction
   <DESC> Validates special claim user created actions, according to specification.
	Checks that mandatory fields are entered, and if no assignment to a user
	adds creator as 'owner' </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   (none) </ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "_validateAction"
long ll_row, ll_rows

istr_datastore[3].ds_data.acceptText()

ll_rows = istr_datastore[3].ds_data.rowCount()
for ll_row = 1 to ll_rows
	choose case istr_datastore[3].ds_data.getItemStatus(ll_row, 0, primary!)
		case newmodified!, datamodified!
			// only validate user actions
			if istr_datastore[3].ds_data.getItemNumber(ll_row , "user_action") = 0 then continue
			
			//Description
			if isNull(istr_datastore[3].ds_data.getItemString(ll_row , "description")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please enter Action Description on Action tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//Duedate
			if isNull(istr_datastore[3].ds_data.getItemDatetime(ll_row , "due_date")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please enter a Duedate on Action tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//Assigned to - default to logged on user if not entered 
			if isNull(istr_datastore[3].ds_data.getItemString(ll_row , "assigned_to")) then
				istr_datastore[3].ds_data.setItem( ll_row, "assigned_to", uo_global.is_userid )
			end if
		
		case else
			// only validate if something changed
			continue
	end choose
next

return c#return.success
end function

private function integer _validateattachment ();/********************************************************************
   _validateAttachment
   <DESC> No validation defined - manatory fields set by system</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   (none) </ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "_validateAttachment"
long ll_row, ll_rows

istr_datastore[5].ds_data.acceptText()

ll_rows = istr_datastore[5].ds_data.rowCount()
for ll_row = 1 to ll_rows
	choose case istr_datastore[5].ds_data.getItemStatus(ll_row, 0, primary!)
		case newmodified!, datamodified!
			// nothing to validate at this point
		case else
			// only validate if something changed
			continue
	end choose
next

return c#return.success
end function

private function integer _validatebase ();/********************************************************************
   _validateBase( )
   <DESC> Validates special claim base information, according to specification.
	Checks that mandatory fields are entered, and ensures that there is only
	one customer selected per claim</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   (none) </ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "_validateBase "
string 	ls_null; setNull(ls_null)
long 		ll_null; setNull(ll_null)

istr_datastore[2].ds_data.acceptText()

//vessel number
if isNull(istr_datastore[2].ds_data.getItemNumber(1, "vessel_nr")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please select a Vessel number on Base tabpage", "N/A")
	return c#return.failure
end if

//If one customer type selected delete the others
choose case istr_datastore[2].ds_data.getItemNumber(1, "debtor_creditor")
	case 1  //Charterer
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "tcowner_nr")) then istr_datastore[2].ds_data.setItem(1, "tcowner_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "agent_nr")) then istr_datastore[2].ds_data.setItem(1, "agent_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "broker_nr")) then istr_datastore[2].ds_data.setItem(1, "broker_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemString(1, "third_party_name")) then istr_datastore[2].ds_data.setItem(1, "third_party_name", ls_null) 
	case 2, 3  //TC Owner or HeadOwner
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "chart_nr")) then istr_datastore[2].ds_data.setItem(1, "chart_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "agent_nr")) then istr_datastore[2].ds_data.setItem(1, "agent_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "broker_nr")) then istr_datastore[2].ds_data.setItem(1, "broker_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemString(1, "third_party_name")) then istr_datastore[2].ds_data.setItem(1, "third_party_name", ls_null) 
	case 4  //Agent
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "chart_nr")) then istr_datastore[2].ds_data.setItem(1, "chart_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "tcowner_nr")) then istr_datastore[2].ds_data.setItem(1, "tcowner_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "broker_nr")) then istr_datastore[2].ds_data.setItem(1, "broker_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemString(1, "third_party_name")) then istr_datastore[2].ds_data.setItem(1, "third_party_name", ls_null) 
	case 5  //Broker
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "chart_nr")) then istr_datastore[2].ds_data.setItem(1, "chart_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "tcowner_nr")) then istr_datastore[2].ds_data.setItem(1, "tcowner_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "agent_nr")) then istr_datastore[2].ds_data.setItem(1, "agent_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemString(1, "third_party_name")) then istr_datastore[2].ds_data.setItem(1, "third_party_name", ls_null) 
	case 6  //Third Party
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "chart_nr")) then istr_datastore[2].ds_data.setItem(1, "chart_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "tcowner_nr")) then istr_datastore[2].ds_data.setItem(1, "tcowner_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "agent_nr")) then istr_datastore[2].ds_data.setItem(1, "agent_nr", ll_null) 
		if NOT isnull(istr_datastore[2].ds_data.getItemNumber(1, "broker_nr")) then istr_datastore[2].ds_data.setItem(1, "broker_nr", ll_null) 
end choose

//Claimant (customer)
if isNull(istr_datastore[2].ds_data.getItemNumber(1, "chart_nr")) &
and isNull(istr_datastore[2].ds_data.getItemNumber(1, "tcowner_nr")) & 
and isNull(istr_datastore[2].ds_data.getItemNumber(1, "agent_nr")) &
and isNull(istr_datastore[2].ds_data.getItemNumber(1, "broker_nr")) &
and isNull(istr_datastore[2].ds_data.getItemString(1, "third_party_name")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please select a Customer on Base tabpage", "N/A")
	return c#return.failure
end if

//Special Claim Type
if isNull(istr_datastore[2].ds_data.getItemString(1, "special_claim_type")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please enter a Short Description on Base tabpage", "N/A")
	return c#return.failure
end if

//Timebar
if istr_datastore[2].ds_data.getItemNumber(1, "income") = 1 then
	if isNull(istr_datastore[2].ds_data.getItemDatetime(1, "timebar_date")) then
		_addmessage( this.classdefinition, METHOD_NAME , "Please enter a Timebar date on Base tabpage", "Timebar date is mandatory, when claim is Receivable")
		return c#return.failure
	end if
end if

//Responsible Person
if isNull(istr_datastore[2].ds_data.getItemString(1, "responsible_person")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please select a Responsible Person on Base tabpage", "N/A")
	return c#return.failure
end if

//Responsible Office
if isNull(istr_datastore[2].ds_data.getItemNumber(1, "responsible_office")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please select a Responsible Office on Base tabpage", "N/A")
	return c#return.failure
end if

//Currency Code
if isNull(istr_datastore[2].ds_data.getItemString(1, "curr_code")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please select a Currency Code on Base tabpage", "N/A")
	return c#return.failure
end if

//Exchange Rate
//if isNull(istr_datastore[2].ds_data.getItemNumber(1, "ex_rate_usd")) then
//	_addmessage( this.classdefinition, METHOD_NAME , "Please enter an Exchange Rate on Base tabpage", "N/A")
//	return c#return.failure
//end if

//Amount
if isNull(istr_datastore[2].ds_data.getItemNumber(1, "amount")) then
	_addmessage( this.classdefinition, METHOD_NAME , "Please enter a Claim Amount on Base tabpage", "N/A")
	return c#return.failure
end if

return c#return.success
end function

private function integer _validatetransaction ();/********************************************************************
   _validateTransaction
   <DESC> Validates special claim transactions, according to specification.
	Checks that mandatory fields are entered, and if the user entering the transaction
	is authorized to enter it.
	Finance people can enter all types of transactions
	Opratations - Superusers only Adjustments and Write-off
	Normal users don't have access</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   (none) </ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "_validateTransaction"
long ll_row, ll_rows

istr_datastore[4].ds_data.acceptText()

ll_rows = istr_datastore[4].ds_data.rowCount()
for ll_row = 1 to ll_rows
	choose case istr_datastore[4].ds_data.getItemStatus(ll_row, 0, primary!)
		case newmodified!, datamodified!
			//Transaction date
			if isNull(istr_datastore[4].ds_data.getItemDatetime(ll_row , "transaction_date")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please enter Tansaction Date on Transaction tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//Description
			if isNull(istr_datastore[4].ds_data.getItemString(ll_row , "comment")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please enter Tansaction comment on Transaction tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//Currency Code
			if isNull(istr_datastore[4].ds_data.getItemString(ll_row , "curr_code")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please select a currency code on Transaction tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//Exchange Rate to Claim Currency
			if isNull(istr_datastore[4].ds_data.getItemNumber(ll_row , "ex_rate_claim_curr")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please enter a Exchange Rate on Transaction tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//amount
			if isNull(istr_datastore[4].ds_data.getItemNumber(ll_row , "amount")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please enter a Amount on Transaction tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			//Transaction Code
			if isNull(istr_datastore[4].ds_data.getItemString(ll_row , "transaction_code")) then
				_addmessage( this.classdefinition, METHOD_NAME , "Please select a transaction code on Transaction tabpage (line#"+string(ll_row)+")", "N/A")
				return c#return.failure
			end if
			
			// only finance profile and operator (superuser) have access to register transactions
			// therefore we only need to validate that a only finance profile can register
			// Receivables, Payables and Bank Charges
			// operations superusers can only register WriteOff and Adjustment
			if  (uo_global.ii_user_profile = 2 and uo_global.ii_access_level = 2)  then
				choose case istr_datastore[4].ds_data.getItemString(ll_row , "transaction_code")
					case "R", "P", "B"
						_addmessage( this.classdefinition, METHOD_NAME , "As an Operator, you are not allowed to register financial transactions (line#"+string(ll_row)+")", "Only finance profile users can register Receivables, Payables and Bank Charges")
						return c#return.failure
				end choose
			end if
		
		case else
			//no validation if nothing changed
			continue
		end choose
next

return c#return.success

end function

private function integer _setforeignkey ();/********************************************************************
   _setForeignKey
   <DESC> Sets the key reference in dte detail datasets</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <USAGE>  Part of the update process</USAGE>
********************************************************************/
constant string METHOD_NAME = "_setForeignKey"
long ll_row, ll_rows
long ll_claimID 

ll_claimID = istr_datastore[2].ds_data.getItemNumber(1, "special_claim_id")

//actions
ll_rows = istr_datastore[3].ds_data.rowCount()
for ll_row = 1 to ll_rows
	//set foreign key
	istr_datastore[3].ds_data.setItem(ll_row, "special_claim_id", ll_claimID )
next

//transactions
ll_rows = istr_datastore[4].ds_data.rowCount()
for ll_row = 1 to ll_rows
	//set foreign key
	istr_datastore[4].ds_data.setItem(ll_row, "special_claim_id", ll_claimID )
next

//attachments
ll_rows = istr_datastore[5].ds_data.rowCount()
for ll_row = 1 to ll_rows
	//set foreign key
	istr_datastore[5].ds_data.setItem(ll_row, "special_claim_id", ll_claimID )
next

return c#return.success
end function

public subroutine documentation ();/********************************************************************
   n_special_claim_interface: a 'container' (non visual window) to encapsulate the 
	functionality provided by the implementation of the special claim handling, and 
	separate business logic from GUI.
   <OBJECT> This object holds all datasets and business logic related to the special
	claims implementation. The datasets are in an array, and as follows:
	 	claimpicklist 	( istr_datastore[1].ds_data )
		claimbase  	( istr_datastore[2].ds_data )
		claimaction  	( istr_datastore[3].ds_data )
		claimtransaction  	( istr_datastore[4].ds_data )
		claimattachment  	( istr_datastore[5].ds_data ) </OBJECT>
   <DESC> 	of_retrieve			- retrieves all datasets if any connection uses the key from master
				of_insertrow		- inserts requested row, and sets the default values
				of_update			- validates all datasets, fill in keys and attachments
				of_deleterow		- deletes requested row, and all detail datasets if any
				of_printinvoice		- creates an invoice using MS Word
				of_rowfocuschanged - reretrieves all detail datasets if master changed
				of_itemchanged 	- handles business logic related to the visual presentation
				</DESC>
   <USAGE> Normally this object will need a window, with the number of datawindow
	objects that you need to visualize. In order to find the dataset names go to the 
	__setup function, and see the names.
	
	Instantiate the object in a window, and use the of_share function, to connect the 
	visual datawindow with the dataset</USAGE>
   <ALSO>  This object is using n_specialclaim_invoice for printing invoices</ALSO>
    	Date   		Ref    			Author		Comments
  	14/07/10		CR#1543	RMO003		Initial Version
	13/06/16		CR4034	CCY018		Add column amount_usd, remove exrate
********************************************************************/

end subroutine

public subroutine _clearattachments ();/********************************************************************
   _clearattachments
   <DESC>   Clears the attachments array </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS> (none)  </ARGS>
   <USAGE> .</USAGE>
********************************************************************/
n_attachment lnv_empty[]
_inv_att = lnv_empty


end subroutine

on n_specialclaim_interface.create
call super::create
end on

on n_specialclaim_interface.destroy
call super::destroy
end on

event destructor;call super::destructor;/********************************************************************
   event destructor
	<DESC>  Closes the hidden OLE document window is open</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> (None) </ARGS>
   <USAGE> </USAGE>
********************************************************************/
if isValid(w_oledocument) then 
	close(w_oledocument)
end if
end event

