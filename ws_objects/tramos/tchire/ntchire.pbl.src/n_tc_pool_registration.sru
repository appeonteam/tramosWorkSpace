$PBExportHeader$n_tc_pool_registration.sru
$PBExportComments$Covers pool registration
forward
global type n_tc_pool_registration from nonvisualobject
end type
end forward

global type n_tc_pool_registration from nonvisualobject
end type
global n_tc_pool_registration n_tc_pool_registration

type variables
// Datastores for pool registration
n_ds ids_pool_list /* Pool list */
n_ds ids_pool_vessel_list /* Vessel List */
n_ds ids_pool_member_list /* Pool member list */
n_ds ids_pool_detail /* Pool details */

/* Pool ID */
long il_pool_id
/* Vessel number */
integer ii_vessel_nr

end variables

forward prototypes
public function integer of_retrieve_pool_detail (long al_pool_id)
public function integer of_deletemember (ref string as_error_text, integer al_row)
public function long of_retrieve_pool_list ()
public function integer of_retrieve_vessels ()
public function integer of_destroydatastores ()
public function integer of_newpool ()
public function integer of_newvessel ()
public function integer of_retrieve_members ()
public subroutine of_setpoolid (long ai_poolid)
public subroutine of_setvesselnr (integer ai_vessel_nr)
public function integer of_share_pool_list (ref datawindow adw_pool)
public function integer of_share_on (ref datawindow adw_pool_list, ref datawindow adw_pool_vessel_list, ref datawindow adw_pool_member_list, ref datawindow adw_pool_detail)
public function integer of_validate_close ()
public function integer of_update ()
public function integer of_validate ()
public function integer of_newmember ()
public function integer of_createdatastores ()
public function integer of_deletevessel (ref string as_error_text, long al_row)
public function integer of_deletepool (ref string as_error_text)
end prototypes

public function integer of_retrieve_pool_detail (long al_pool_id);return ids_pool_detail.retrieve(al_pool_id)
end function

public function integer of_deletemember (ref string as_error_text, integer al_row);if ids_pool_member_list.deleterow(al_row) = 1 then
	if ids_pool_member_list.update() = 1 then
		COMMIT;
	else
		as_error_text = SQLCA.SQLErrText
		rollback;
		return -1
	end if
else
	as_error_text = "Entry has not been deleted. Please try again, or contact the system administrator, if the problem still occurs."
	return -1
end if


return 1
end function

public function long of_retrieve_pool_list ();return ids_pool_list.retrieve( uo_global.is_userid )
end function

public function integer of_retrieve_vessels ();return ids_pool_vessel_list.retrieve(il_pool_id)

end function

public function integer of_destroydatastores ();destroy ids_pool_list
destroy ids_pool_vessel_list
destroy ids_pool_member_list
destroy ids_pool_detail

return 1
end function

public function integer of_newpool ();ids_pool_vessel_list.reset()
ids_pool_member_list.reset()
ids_pool_detail.reset()
ids_pool_detail.insertrow(0)
setNull(il_pool_id)
return 1
end function

public function integer of_newvessel ();long ll_row

ll_row = ids_pool_vessel_list.insertRow(0)

/* Set default values - i.e. set the pool id for the new vessel*/
if ll_row > 0 then
	if not isNull(il_pool_id) then
		ids_pool_vessel_list.setItem(ll_row, "ntc_pool_vessels_pool_id", il_pool_id)
	end if
end if

SetNull(ii_vessel_nr) //prevents adding a new member before the vessel i updated to the database

return ll_row
end function

public function integer of_retrieve_members ();return ids_pool_member_list.retrieve(ii_vessel_nr)
end function

public subroutine of_setpoolid (long ai_poolid);il_pool_id = ai_poolid

Return
end subroutine

public subroutine of_setvesselnr (integer ai_vessel_nr);ii_vessel_nr = ai_vessel_nr

Return
end subroutine

public function integer of_share_pool_list (ref datawindow adw_pool);ids_pool_list.sharedata(adw_pool)
return 1
end function

public function integer of_share_on (ref datawindow adw_pool_list, ref datawindow adw_pool_vessel_list, ref datawindow adw_pool_member_list, ref datawindow adw_pool_detail);ids_pool_list.sharedata(adw_pool_list)
ids_pool_vessel_list.sharedata(adw_pool_vessel_list)
ids_pool_member_list.sharedata(adw_pool_member_list)
ids_pool_detail.sharedata(adw_pool_detail)
return 1
end function

public function integer of_validate_close ();/* --------------------------
Validates on close that all pools has vessels and all vessels has members 
This validation has been made as a functionality outside the "normal" validation (of_validate)
to give the user more flexibility when managing pools.

Revision Log
03-02-26 Klaus Mygind
*/

DATASTORE lds_pools, lds_vessels
STRING ls_pools, ls_vessels
LONG ll_counter

/*------------------ 
Check that all pools has at least one vessel attached
If not, notify the user which pool(s) do not have a vessel attached
-------------------*/
lds_pools = create datastore
lds_pools.dataobject = "d_pools_wo_vessels"
lds_pools.settransobject(SQLCA)

if lds_pools.retrieve() > 0 then
	for ll_counter = 1 to lds_pools.rowcount()
		ls_pools += lds_pools.getitemstring(ll_counter,"pool_name") + "~r"
	next
	messagebox("Validation Error", "One or more pools do not have a vessel attached." +&
					"~r~rPlease attach at least one vessel to the following pool(s):~r~r" +&
					ls_pools)
	destroy lds_pools
	return -1
else //lds_pools is empty, i.e. no pools exist without a vessel
	destroy lds_pools
end if

/*-------------------
Check that all vessels have at least one vessel attached 
If not, notify the user which vessel(s) (including related pool) do not have a member
-------------------*/
lds_vessels = create datastore
lds_vessels.dataobject = "d_vessels_wo_members"
lds_vessels.settransobject(SQLCA)

if lds_vessels.retrieve() > 0 then
	for ll_counter = 1 to lds_vessels.rowcount()
		ls_vessels += "Vessel # " + string(lds_vessels.getitemNumber(ll_counter,"vessel_nr"))&
							+ " (Pool: " + lds_vessels.getitemstring(ll_counter,"pool_name") + ")~r"
	next
	MessageBox("Validation Error", "One or more vessels do not have a member attached.~r~r" +&
					"Please attach at least one member to the following vessel(s) (see related pool "+&
					"in the paranthesis):~r~r" + ls_vessels)
	destroy lds_vessels
	return -1
else // lds_vessels is empty, i.e. no vessels exist without a member attached
	destroy lds_vessels
end if


return 1
end function

public function integer of_update ();/* Updates all datastores*/

long ll_rows, ll_row_no

/* Validation before update */
if of_validate() = -1 then return -1

/* Set pool ID */
if ids_pool_detail.update(true, false) = 1 then
	of_setpoolID(ids_pool_detail.getItemNumber(1, "pool_id"))
else
	rollback;
	Return -1
end if


/* If new Pool set Pool ID in subtable Pool Vessel */
if ids_pool_detail.getitemstatus(1,0,primary!) = NewModified! then
	ll_rows = ids_pool_vessel_list.RowCount()
	for ll_row_no = 1 to ll_rows
		ids_pool_vessel_list.setItem(ll_row_no, "NTC_POOL_VESSELS_POOL_VESSEL_ID", il_pool_id)
	next
end if

/* Reset flags and commit */

if ids_pool_vessel_list.update(true, false) = 1 then
		if ids_pool_member_list.update(true, false) = 1 then
			ids_pool_detail.ResetUpdate()
			ids_pool_vessel_list.ResetUpdate()
			ids_pool_member_list.ResetUpdate()
			COMMIT;
		else
			ROLLBACK;
			return -1
		end if
	else
		ROLLBACK;
		return -1
end if

/* Set Vessel ID */
ll_row_no = ids_pool_vessel_list.getrow()
if ll_row_no > 0 then 
	ii_vessel_nr = ids_pool_vessel_list.getitemnumber(ll_row_no,"vessel_nr")
else 
	setNull(ii_vessel_nr)
end if

return 1
end function

public function integer of_validate ();/**************************************************************************************
Author:			Klaus Mygind
Date:				2003-02-26
Description:	Validates the data from Pool Registration Window before updates are 
					committed to the database.
					
					Checks for:	Mandatory fields
									Uniqueness of Pool Name
									Start date before end date
									A vessel has only one entry in the pool
									The vessel is only attached to one pool at a time
									The sum of member pct for any vessel is 100
***************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
2003-02-26		1.0			KMY			INITIAL VERSION
***************************************************************************************/

string ls_poolname, ls_vessel_name, ls_member_sn, ls_member_ln, ls_find
datetime ldt_startdt, ldt_enddt, ldt_end_result, ldt_start_result
long ll_poolid, ll_vessel_nr, ll_member_pct, ll_counter, ll_rowcount, ll_result, ll_pool_vessel_id, ll_pct_sum

/* First check - Mandatory fields */
// Mandatory fields continued - Pool Name
ls_poolname = ids_pool_detail.getitemstring(1,"pool_name")
if IsNull(ls_poolname) then 
	messagebox("Validation Error", "Pool name is mandatory")
	return -1
end if
// Mandatory fields continued - Vessel information
ll_rowcount = ids_pool_vessel_list.rowcount() 
for ll_counter = 1 to ll_rowcount
	ll_vessel_nr = ids_pool_vessel_list.getitemnumber(ll_counter,"vessel_nr")
	ls_vessel_name = ids_pool_vessel_list.getitemstring(ll_counter,"vessel_name")
	ldt_startdt = ids_pool_vessel_list.getitemDateTime(ll_counter,"vessel_start_dt")
	if IsNull(ls_vessel_name) or IsNull(ll_vessel_nr) or IsNull(ldt_startdt) then
		messagebox("Validation Error", "Please fill out all necessary information in Pool Vessel list")
		return -1
	end if
next
// Mandatory fields continued - Member information
ll_rowcount = ids_pool_member_list.rowcount() 
for ll_counter = 1 to ll_rowcount
	ls_member_sn = ids_pool_member_list.getitemString(ll_counter,"tcowner_sn")
	ls_member_ln = ids_pool_member_list.getitemString(ll_counter,"tcowner_ln")
	ll_member_pct = ids_pool_member_list.getitemNumber(ll_counter,"tcowner_pct")
	if IsNull(ls_member_sn) or IsNull(ls_member_ln) or IsNull(ll_member_pct) then
		messagebox("Validation Error", "Please fill out all necessary information in Vessel Member list!" +&
					  "~r~rAll fields in Member list are mandatory.~r~rChanges have not been updated to the database")
		return -1
	end if
next
/* End of Check of Mandatory Fields*/

/* Second check - Pool name must be unique */
ll_poolid = ids_pool_detail.getitemnumber(1,"pool_id")

if ids_pool_detail.getitemstatus(1,0,primary!) = newmodified! &
	or ids_pool_detail.getitemstatus(1,0,primary!) = DataModified! then //check that a pool with the same name does not exist
		ls_find = "pool_name = '" + ls_poolname + "' and pool_id <> " + string(ll_poolid)
		if ids_pool_list.find(ls_find,1,ids_pool_list.rowcount()) > 0 then
			Messagebox("Validation Error", "The pool name must be unique - a pool with the same name already exist. ~r~rChanges have not been updated to the database")
		return - 1
		end if
end if
/* End of unique pool name check */

/* Third check - Start date is before end date for the vessel*/
ll_rowcount = ids_pool_vessel_list.rowcount() 
for ll_counter = 1 to ll_rowcount
	if not IsNull(ids_pool_vessel_list.getitemDateTime(ll_counter,"vessel_end_dt")) then
			if ids_pool_vessel_list.getitemDateTime(ll_counter,"vessel_start_dt") > &
				ids_pool_vessel_list.getitemDateTime(ll_counter,"vessel_end_dt") then
				MessageBox("Validation Error", "Start date must be before end date for all vessels. " + &
							  "~r~rPlease correct the vessel in row no. " + string(ll_counter) + "!" + &
							  "~r~rChanges have not been updated to the database")
				return -1
			end if
	end if
next
/* End of start date < end date check */

/* Fourth check - The vessel has only entry in the pool */

ll_rowcount = ids_pool_vessel_list.rowcount() 
FOR ll_counter = 1 to ll_rowcount - 1
	ll_vessel_nr=ids_pool_vessel_list.getitemnumber(ll_counter, "vessel_nr")
	ls_find = "vessel_nr = " + string(ll_vessel_nr)
		if ids_pool_vessel_list.find(ls_find,ll_counter + 1,ids_pool_vessel_list.rowcount()) > 0 then
			Messagebox("Validation Error", "The vessel in row no. " + string(ll_counter) + &
			" already has an entry in the pool.~r~rA vessel can only appear once in the pool.")
			return - 1
		end if
NEXT
/* End of vessel only appears one time in the pool check */


/* Fifth Check - The vessel is only attached to one pool at a time */
ll_rowcount = ids_pool_vessel_list.rowcount() 
for ll_counter = 1 to ll_rowcount
	ll_pool_vessel_id = ids_pool_vessel_list.getitemNumber(ll_counter, "NTC_POOL_VESSELS_POOL_VESSEL_ID")
	ldt_startdt = ids_pool_vessel_list.getitemDateTime(ll_counter, "vessel_start_dt")
	ldt_enddt = ids_pool_vessel_list.getitemDateTime(ll_counter, "vessel_end_dt")
	ll_vessel_nr = ids_pool_vessel_list.getitemNumber(ll_counter, "vessel_nr")
	if IsNull(ldt_enddt) then 	/*all other entries must have an end date, 
										and start date must be after any other end date*/
		SETNULL(ldt_start_result)
		SELECT START_DT into :ldt_start_result
		FROM NTC_POOL_VESSELS 
		WHERE VESSEL_NR = :ll_vessel_nr 
		AND :ll_pool_vessel_id <> POOL_VESSEL_ID
		AND END_DT IS NULL;
			if not IsNull(ldt_start_result) then
				Messagebox("Validation Error", "You have entered a vessel with no end date in row no. " &
							  + string(ll_counter) + ", but the vessel already has another entry in another pool " + &
							  "with no end date, starting on " + string(ldt_start_result) + &
							  "~r~rPlease type in an end date for the vessel in row no. " + string(ll_counter))
				return -1
			else /*all other entries for the vessel has end dates. 
				  Check that start date is after any end dates for the same vessel*/
				SETNULL(ldt_end_result)
				SELECT END_DT INTO :ldt_end_result
				FROM NTC_POOL_VESSELS
				WHERE VESSEL_NR = :ll_vessel_nr 
				AND :ll_pool_vessel_id <> POOL_VESSEL_ID
				AND END_DT > :ldt_startdt;
					if not IsNull(ldt_end_result) then
						Messagebox("Validation Error", "You have entered a vessel with no end date in row no. "&
						+ string(ll_counter) +", but an another entry for that vessel exist in another pool "+&
						"with an end date on "+ string(ldt_end_result) + "~r~rPlease correct the start date "+&
						"to be later than " + string(ldt_end_result))
						return -1
					end if
			end if //ll_result > 0
	else  /*IsNull(ldt_enddt) is false - i.e. the vessel has an end date attached. 
		Check that no entries exist, where new(start date)<end date AND new(end date)>start date*/
		SETNULL(ldt_end_result)
		SETNULL(ldt_start_result)
		SELECT START_DT, END_DT INTO :ldt_start_result, :ldt_end_result
		FROM NTC_POOL_VESSELS
		WHERE VESSEL_NR = :ll_vessel_nr 
		AND END_DT > :ldt_startdt
		AND START_DT < :ldt_enddt
		AND :ll_pool_vessel_id <> POOL_VESSEL_ID;
			if not (IsNull(ldt_start_result) and IsNull(ldt_end_result)) then
				MessageBox("Validation Error", "The period for the vessel in row no. " + string(ll_counter) + &
							  " collides with another period for the same vessel in another pool with start date " &
							  + string(ldt_start_result) + " and end date " + string(ldt_end_result) + &
							  ". ~r~rPlease correct the period in row " + string(ll_counter) + " accordingly.")
				return -1
			end if
		/*Check if an entry with no end date exist for the vessel. If this is this the case, 
		the start date of that entry must be after the new vessel's end date*/
		SETNULL(ldt_start_result)
		SELECT START_DT INTO :ldt_start_result
		FROM NTC_POOL_VESSELS
		WHERE VESSEL_NR = :ll_vessel_nr
		AND END_DT IS NULL
		AND START_DT <= :ldt_enddt
		AND :ll_pool_vessel_id <> POOL_VESSEL_ID;
			if not IsNull(ldt_start_result) then
				MessageBox("Validation Error", "The vessel in row no. " + string(ll_counter) + &
							  " has an an other pool entry with no end date, which starts before the end date, " + &
							  "you typed in.~r~n~rThe other entry with no end date starts on " + string(ldt_start_result) + &
							  ". The end date in row no. " + string(ll_counter) + " must be before this date.")
				return -1
			end if
	end if //IsNull(ldt_enddt)
next
/* End of vessel is attached to only one pool at a time check */

/* Sixth check - Sum of pct for members is 100 */
if ids_pool_member_list.rowcount() >0 then 
	ll_pct_sum = ids_pool_member_list.getitemnumber(1,"comp_sum_pct")
	if  ll_pct_sum <> 100 then
		messagebox("Validation Error", "The sum of pct for the members must equal 100. ~r~r Data has not been updated - please correct.")
	return - 1
	end if
end if
/* End of pct sum equals 100 */

/* Xth check - Vessel period must be equal to or a subset of a TC Contract period for the vessel */


return 1
end function

public function integer of_newmember ();long ll_row

/* Check that a vessel and a pool has been selected */
if isNull(ii_vessel_nr) or isNull(il_pool_id) then 
	MessageBox("Insert Error", "Can not add a new member without the vessel saved. Please save the changes made in the vessel list.")
	return -1
end if

ll_row = ids_pool_member_list.insertRow(0)

/* Set default values - i.e. vessel ID is set*/
if ll_row > 0 then
	if not isNull(ii_vessel_nr) then
		ids_pool_member_list.setItem(ll_row, "NTC_POOL_MEMBERS_POOL_VESSEL_ID", ii_vessel_nr)
		ids_pool_member_list.setItem(ll_row, "ntc_pool_members_apm_company", 0)
	end if
end if

return ll_row
end function

public function integer of_createdatastores ();ids_pool_list = create n_ds
ids_pool_list.dataobject = "d_tc_pool_list"
ids_pool_list.settransobject(SQLCA)

ids_pool_detail = create n_ds
ids_pool_detail.dataobject = "d_tc_pool_detail"
ids_pool_detail.settransobject(SQLCA)

ids_pool_vessel_list = create n_ds
ids_pool_vessel_list.dataobject = "d_tc_pool_vessel_list"
ids_pool_vessel_list.settransobject(SQLCA)


ids_pool_member_list = create n_ds
ids_pool_member_list.dataobject = "d_tc_pool_member_list"
ids_pool_member_list.settransobject(SQLCA)

return 1
end function

public function integer of_deletevessel (ref string as_error_text, long al_row);long ll_pool_vessel_id

if ids_pool_vessel_list.rowCount() < 1 then return 1
if al_row < 1 then return 1

/* confirm delete */
if messagebox("Confirm delete", "Are you sure you want to delete Vessel including Members?",question!, YesNo!,2) = 2 then
	return 1
end if

ll_pool_vessel_id = ids_pool_vessel_list.getItemNumber(al_row, "ntc_pool_vessels_pool_vessel_id")

if isNull(ll_pool_vessel_id) then return 1

/* Delete rows from members */
DELETE 
	FROM NTC_POOL_MEMBERS 
   WHERE NTC_POOL_MEMBERS.POOL_VESSEL_ID = :ll_pool_vessel_id ;

if SQLCA.SQLCode <> 0 then
	as_error_text = SQLCA.SQLErrText
	rollback;
	return -1
end if

/* Delete the row */
if ids_pool_vessel_list.deleterow(al_row) = 1 then
	if ids_pool_vessel_list.update() = 1 then
		COMMIT;
	else
		as_error_text = SQLCA.SQLErrText
		rollback;
		return -1
	end if
else
	as_error_text = "Entry has not been deleted. Please try again, or contact the system administrator, if the problem still occurs."
	ids_pool_vessel_list.retrieve()
	return -1
end if

Return 1


end function

public function integer of_deletepool (ref string as_error_text);long ll_pool_id

if ids_pool_detail.rowCount() <> 1 then return 1

/* confirm delete */
if messagebox("Confirm delete", "Are you sure you want to delete Pool including Vessels and Members?",question!, YesNo!,2) = 2 then
	return 1
end if

ll_pool_id = ids_pool_detail.getItemNumber(1, "pool_id")

if isNull(ll_pool_id) then return 1

/* Delete rows from members */
DELETE NTC_POOL_MEMBERS  
	FROM NTC_POOL_MEMBERS,   
        NTC_POOL_VESSELS  
   WHERE ( NTC_POOL_VESSELS.POOL_VESSEL_ID = NTC_POOL_MEMBERS.POOL_VESSEL_ID ) and  
         ( ( NTC_POOL_VESSELS.POOL_ID = :ll_pool_id )) ;

if SQLCA.SQLCode <> 0 then
	as_error_text = SQLCA.SQLErrText
	rollback;
	return -1
end if

/* Delete rows from vessels */
DELETE  
	FROM NTC_POOL_VESSELS  
   WHERE NTC_POOL_VESSELS.POOL_ID = :ll_pool_id ;

if SQLCA.SQLCode <> 0 then
	as_error_text = SQLCA.SQLErrText
	rollback;
	return -1
end if

/* Delete the row */
if ids_pool_detail.deleterow(0) = 1 then
	if ids_pool_detail.update() = 1 then
		COMMIT;
	else
		as_error_text = SQLCA.SQLErrText
		rollback;
		return -1
	end if
else
	as_error_text = "Entry has not been deleted. Please try again, or contact the system administrator, if the problem still occurs."
	return -1
end if

Return 1
end function

on n_tc_pool_registration.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tc_pool_registration.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;of_createdatastores()
setnull(ii_vessel_nr)
setnull(il_pool_id)
end event

event destructor;of_destroydatastores()
end event

