$PBExportHeader$mt_u_dw_att.sru
forward
global type mt_u_dw_att from u_datagrid
end type
end forward

global type mt_u_dw_att from u_datagrid
event lbuttonup pbm_lbuttonup
event dwnrbuttonup pbm_dwnrbuttonup
end type
global mt_u_dw_att mt_u_dw_att

type variables
public:
constant long MAX_ARGS = 18

protected:
any ia_args[18]   // Please keep the number the same as MAX_ARGS and do not forget to change of_retrieve() when changing it
string is_argrefs[18]
string is_updatesallowed = "IUD"
boolean ib_multitableupdate = false
str_multiupdate    istr_multiupdate[]

// To determine if the row selection serivce is enabled or not
protected boolean __ib_rowselection = false

// The row selection service
protected n_rowselection inv_rowselection

private:
long     il_lasterrcode
string   is_lasterrtext

end variables

forward prototypes
public subroutine documentation ()
public function integer of_getargs (ref any aa_args[])
public function integer of_setargs (any aa_args[])
public function integer of_updatetables ()
protected function integer of_setdefaultvalue ()
protected function integer of_resetidentity ()
public function long of_getargtypes (ref str_retrievalarg as_retrievalarg[])
public function boolean of_typematch (ref any aa_args[])
private function boolean of_typematch (ref any aa_arg, string as_argtype)
public function long of_retrieve (any aa_args[])
public function long of_retrieve ()
public function integer of_addupdatetable (string as_tablename, string as_allcolumns, string as_keycolumns)
public function integer of_addupdatetable (string as_tablename, string as_keycolumns)
public function integer of_setmultitableupdate (boolean ab_switch)
public function long of_getlasterrcode ()
public function string of_getlasterrtext ()
public function integer of_addattachmenttable ()
public function integer of_setargrefs (string as_argrefs[])
public function integer of_getargrefs (ref string as_argrefs[])
public function long of_insertrow (ref str_requested_att lstr_att)
public function integer of_setrowselection (boolean ab_switch)
end prototypes

event lbuttonup;// forward the event to the row selection service
if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
	inv_rowselection.event ue_lbuttonup(flags, xpos, ypos)
end if

end event

event dwnrbuttonup;// forward the event to the row selection service
if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
	inv_rowselection.event ue_rbuttonup(xpos, ypos, row, dwo)
end if
end event

public subroutine documentation ();/********************************************************************
   mt_u_dw_att: 
	
	<OBJECT>
		object to be used with file attachment version 2.
	</OBJECT>
   <DESC>
		
	</DESC>
  	<USAGE>
		not plugged in yet, however when new request for attachment appears or we need to
		refactor/improve existing this is what we must use.
	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    		Author   		Comments
  	01/06/05 	?      		???				First Version
	25/03/16    CR3907      SSX014         Integrate row selection code from PFC
	06/10/16		CR3754		AGL027			Change logid references to userid to support SSO
********************************************************************/
end subroutine

public function integer of_getargs (ref any aa_args[]);aa_args [] = ia_args[]
return c#return.failure
end function

public function integer of_setargs (any aa_args[]);
long ll_upper
long ll_i

// check if the data types are matched with those declared in the dataobject
if not of_typematch(aa_args) then
	return c#return.failure
end if

ll_upper = Upperbound(aa_args)
if ll_upper > MAX_ARGS then
	ll_upper = MAX_ARGS
end if

for ll_i = 1 to ll_upper
	ia_args[ll_i] = aa_args[ll_i]
next

return c#return.success

end function

public function integer of_updatetables ();/********************************************************************
   of_updatetables
   <DESC>	Update file tables	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Called in the funciton of_updateattach()	</USAGE>
   <HISTORY>
		Date       CR-Ref        Author   Comments
		11/06/2015 CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_index, ll_idxkey, ll_idxall, ll_col
long ll_upperbound, ll_upperkeycol, ll_upperallcol, ll_colcount
string ls_modify, ls_tblname, ls_colname, ls_dbname
mt_n_stringfunctions lnv_string

if not ib_multitableupdate then
	is_updatesallowed = 'IUD'
	of_setdefaultvalue()
	return this.update(true, false)
end if

ll_upperbound = upperbound(istr_multiupdate[])
// Don't forget to call of_addupdatetable() functions before calling this function
if ll_upperbound <= 0 then
	return c#return.Failure
end if

// Begin to update tables

// First:
// Delete the records that have references to the table of ATTACHEMENTS
// so that the related records of the table ATTACHMENTS can be deleted 
// as well

for ll_index = ll_upperbound to 1 step -1
	// Cleaning up
	ll_colcount = long (this.Object.DataWindow.Column.Count)
	for ll_col = 1 to ll_colcount
		ls_colname = "#" + string(ll_col)
		ls_modify = this.modify(ls_colname + ".update='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = this.modify(ls_colname + ".identity='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = this.modify(ls_colname + ".key='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next
	
	// Get the table name
	ls_tblname = istr_multiupdate[ll_index].tablename

	// ignore the table of ATTACHMENTS
	if ls_tblname = "ATTACHMENTS" then
		continue
	end if
	
	// Set the table to update	
	ls_tblname = lnv_string.of_replaceall(ls_tblname, "'", "~~'", false)
	ls_modify = this.modify("DataWindow.Table.UpdateTable='" + ls_tblname + "'" )
	if ls_modify <> "" then
		return c#return.Failure
	end if
	
	// Set update properties for all columns
	ll_upperallcol = upperbound( istr_multiupdate[ll_index].allcolumns[] )
	for ll_idxall = 1 to ll_upperallcol
		// Set the update property
		ls_colname = istr_multiupdate[ll_index].allcolumns[ll_idxall]
		ls_modify = this.modify(ls_colname + ".update='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		
		// Set the dbname property
		ls_dbname = istr_multiupdate[ll_index].alldbcolumns[ll_idxall]
		ls_dbname = lnv_string.of_replaceall(ls_dbname, "'", "~~'", false)
		ls_modify = this.modify(ls_colname + ".dbname='" + ls_dbname + "'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Set the key properties for the key columns
	ll_upperkeycol = upperbound( istr_multiupdate[ll_index].keycolumns[] )
	for ll_idxkey = 1 to ll_upperkeycol 
		ls_colname = istr_multiupdate[ll_index].keycolumns[ll_idxkey]
		ls_modify = this.modify(ls_colname + ".key='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next
	
	// Send SQLs to the database
	is_updatesallowed = 'D'
	if this.update(true, false) = -1 then
		return c#return.Failure
	end if
next

// Second:
// Update the table of ATTACHMENTS first and then insert and update the other tables
//

for ll_index = 1 to ll_upperbound
	// Cleaning up
	ll_colcount = long (this.Object.DataWindow.Column.Count)
	for ll_col = 1 to ll_colcount
		ls_colname = "#" + string(ll_col)
		ls_modify = this.modify(ls_colname + ".update='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = this.modify(ls_colname + ".identity='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		ls_modify = this.modify(ls_colname + ".key='no'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Get the table name
	ls_tblname = istr_multiupdate[ll_index].tablename
	
	// Set the table to update
	ls_tblname = lnv_string.of_replaceall(ls_tblname, "'", "~~'", false)
	ls_modify = this.modify("DataWindow.Table.UpdateTable='" + ls_tblname + "'" )
	if ls_modify <> "" then
		return c#return.Failure
	end if
	
	// Set the update properties for all columns
	ll_upperallcol = upperbound( istr_multiupdate[ll_index].allcolumns[] )
	for ll_idxall = 1 to ll_upperallcol
		// Set the update property
		ls_colname = istr_multiupdate[ll_index].allcolumns[ll_idxall]
		ls_modify = this.modify(ls_colname + ".update='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		
		// Set the dbname property
		ls_dbname = istr_multiupdate[ll_index].alldbcolumns[ll_idxall]
		ls_dbname = lnv_string.of_replaceall(ls_dbname, "'", "~~'", false)
		ls_modify = this.modify(ls_colname + ".dbname='" + ls_dbname + "'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
		
		// Set the identity property
		if ls_dbname = "ATTACHMENTS.FILE_ID" then
			ls_modify = this.modify(ls_colname + ".identity='yes'")
		else
			ls_modify = this.modify(ls_colname + ".identity='no'")
		end if
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Set the key properties for the key columns
	ll_upperkeycol = upperbound( istr_multiupdate[ll_index].keycolumns[] )
	for ll_idxkey = 1 to ll_upperkeycol 
		ls_colname = istr_multiupdate[ll_index].keycolumns[ll_idxkey]
		ls_modify = this.modify(ls_colname + ".key='yes'")
		if ls_modify <> "" then
			return c#return.Failure
		end if
	next

	// Send SQLs to the database
	if ls_tblname = "ATTACHMENTS" then 
		is_updatesallowed = 'IUD'
		of_setdefaultvalue()
		of_resetidentity()
	else
		is_updatesallowed = 'IU'
	end if
	if this.update(true, false) = -1 then
		return c#return.Failure
	end if
next

return c#return.Success
end function

protected function integer of_setdefaultvalue ();/********************************************************************
   of_setdefaultvalue
   <DESC>	Set the default values	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date        CR-Ref        Author   Comments
		11/06/2015  CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount
DWItemStatus le_rowstatus
long ll_col, ll_colcount
string ls_dbname

ll_colcount = long(this.Object.DataWindow.Column.Count)

// Primary buffer
ll_rowcount = this.rowcount()
for ll_row = 1 to ll_rowcount
	le_rowstatus = this.getitemstatus(ll_row, 0, primary!)
	if le_rowstatus = DataModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = this.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				this.setitem(ll_row, ll_col, sqlca.userid)
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				this.setitem(ll_row, ll_col, datetime(today(),now()))
			end if
		next
		
	elseif le_rowstatus = NewModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = this.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.CREATED_BY" then
				this.setitem(ll_row, ll_col, sqlca.userid)
			elseif ls_dbname = "ATTACHMENTS.CREATED_DATE" then
				this.setitem(ll_row, ll_col, datetime(today(),now()))
			elseif ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				this.setitem(ll_row, ll_col, sqlca.userid)
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				this.setitem(ll_row, ll_col, datetime(today(),now()))
			end if
		next
	end if
next

// Filter Buffer
ll_rowcount = this.filteredcount()
for ll_row = 1 to ll_rowcount
	le_rowstatus = this.getitemstatus(ll_row, 0, filter!)
	if le_rowstatus = DataModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = this.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				this.Object.Data.Filter.Current[ll_row, ll_col] = sqlca.userid
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				this.Object.Data.Filter.Current[ll_row, ll_col] =datetime(today(),now())
			end if
		next
	elseif le_rowstatus = NewModified! then
		for ll_col = 1 to ll_colcount
			ls_dbname = this.describe("#" + string(ll_col) + ".dbname")
			if ls_dbname = "ATTACHMENTS.CREATED_BY" then
				this.Object.Data.Filter.Current[ll_row, ll_col] = sqlca.userid
			elseif ls_dbname = "ATTACHMENTS.CREATED_DATE" then
				this.Object.Data.Filter.Current[ll_row, ll_col] = datetime(today(),now())
			elseif ls_dbname = "ATTACHMENTS.UPDATED_BY" then
				this.Object.Data.Filter.Current[ll_row, ll_col] = sqlca.userid
			elseif ls_dbname = "ATTACHMENTS.UPDATED_DATE" then
				this.Object.Data.Filter.Current[ll_row, ll_col] = datetime(today(),now())
			end if
		next
	end if
next

return c#return.Success

end function

protected function integer of_resetidentity ();/********************************************************************
   of_resetidentity
   <DESC>	Make PB refetch the identity after the failure of the last update	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.NoAction: 0, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date        CR-Ref        Author   Comments
		11/06/2015  CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_rowcount
long ll_col, ll_colcnt
string ls_identity
string ls_colname
dwitemstatus le_status
long ll_null

ll_colcnt = long (this.Object.DataWindow.Column.Count)

for ll_col = 1 to ll_colcnt
	ls_colname = "#" + string(ll_col)
	ls_identity = this.describe(ls_colname + ".identity")
	if ls_identity = "yes" then
		exit
	end if
next

if ll_col > ll_colcnt then
	return c#return.NoAction
end if

setnull(ll_null)

ll_rowcount = this.rowcount()
for ll_row = 1 to ll_rowcount
	le_status = this.getitemstatus(ll_row,0,primary!)
	if le_status = newmodified! then
		this.setitem(ll_row, ll_col, ll_null)
		this.setitemstatus(ll_row, ll_col, primary!, notmodified!)
	end if
next

return c#return.Success

end function

public function long of_getargtypes (ref str_retrievalarg as_retrievalarg[]);string ls_arguments
string ls_argarray[], ls_pairarray[], ls_empty[]
mt_n_stringfunctions lnv_string
long ll_i, ll_upper, ll_j

ls_arguments = this.Describe("DataWindow.Table.Arguments")
lnv_string.of_parsetoarray(ls_arguments, "~n", ls_argarray)

ll_upper = upperbound(ls_argarray)
ll_j = 0
for ll_i = 1 to ll_upper
	lnv_string.of_parsetoarray(ls_argarray[ll_i], "~t", ls_pairarray)
	if upperbound(ls_pairarray) = 2 then
		ll_j ++
		as_retrievalarg[ll_j].is_name = ls_pairarray[1]
		as_retrievalarg[ll_j].is_type = ls_pairarray[2]
		ls_pairarray = ls_empty
	end if
next

return ll_j

end function

public function boolean of_typematch (ref any aa_args[]);
str_retrievalarg lstr_args[]
long ll_cnt, ll_i
string ls_argtype, ls_argelementtype
long ll_upper, ll_k
any la_subarray[]

ll_cnt = of_getargtypes(lstr_args[])
for ll_i = 1 to ll_cnt
	ls_argtype = lstr_args[ll_i].is_type
	choose case ls_argtype
		case "string", "number", "decimal", "time", "date", "datetime"
			if not of_typematch(aa_args[ll_i], ls_argtype) then
				exit
			end if
		case else
			if right(ls_argtype, 4) = "list" then
				ls_argelementtype = left(ls_argtype, len(ls_argtype) - 4)
				choose case ls_argelementtype
					case "string", "number", "decimal", "time", "date", "datetime"
						try
							la_subarray[] = aa_args[ll_i]
							ll_upper = upperbound(la_subarray)
							for ll_k = 1 to ll_upper
								if not of_typematch(la_subarray[ll_k], ls_argelementtype) then
									exit
								end if
							next
							if ll_k <= ll_upper then exit
							aa_args[ll_i] = la_subarray[]
						catch (throwable ex)
							exit
						end try
					case else
						exit
				end choose
			end if
	end choose
next

if ll_i <= ll_cnt then
	MessageBox("Error", "Type is mismatched(" + lstr_args[ll_i].is_name + ", " + lstr_args[ll_i].is_type + ").", stopsign!, ok!)
	return false
end if

return true
end function

private function boolean of_typematch (ref any aa_arg, string as_argtype);string ls_classname
decimal ldc_null
time lt_null
date ld_null
long ll_null  // number
datetime ldt_null
string ls_null
long ll_pos
string ls_temp1, ls_temp2

setnull(ldc_null)
setnull(lt_null)
setnull(ld_null)
setnull(ll_null)
setnull(ldt_null)
setnull(ls_null)

choose case as_argtype
	case "string"
		if not isnull(aa_arg) then
			aa_arg = string(aa_arg)
		else
			aa_arg = ls_null
		end if
	case "number", "decimal"
		if not isnull(aa_arg) then
			if not isnumber(string(aa_arg)) then
				return false
			end if
		else
			if as_argtype = "decimal" then
				aa_arg = ldc_null
			else
				aa_arg = ll_null
			end if
		end if
	case "time"
		if not isnull(aa_arg) then
			if not istime(string(aa_arg)) then
				return false
			end if
			if classname(aa_arg) <> "time" then
				aa_arg = time(string(aa_arg))
			end if
		else
			aa_arg = lt_null
		end if
	case "date"
		if not isnull(aa_arg) then
			if not isdate(string(aa_arg)) then
				return false
			end if
			if classname(aa_arg) <> "date" then
				aa_arg = date(string(aa_arg))
			end if
		else
			aa_arg = ld_null
		end if
	case "datetime"
		if not isnull(aa_arg) then
			ls_classname = classname(aa_arg)
			// don't know why powerbuilder does not provide isdatetime function
			if ls_classname <> 'datetime' then
				// convert to datetime
				ls_temp1 = string(aa_arg)
				
				if isdate(ls_temp1) then
					aa_arg = datetime(date(ls_temp1))
				else
					ll_pos = lastpos(ls_temp1, " ")
					if ll_pos > 0 then
						ls_temp2 = mid(ls_temp1, ll_pos)
						ls_temp1 = mid(ls_temp1, 1, ll_pos)
					else
						ls_temp2 = "00:00:00.000"
					end if
					
					if isdate(ls_temp1) and istime(ls_temp2) then
						aa_arg = datetime(date(ls_temp1), time(ls_temp2))
					else
						return false
					end if
				end if
			end if
		else
			aa_arg = ldt_null
		end if
	case else
		return false
end choose

return true
end function

public function long of_retrieve (any aa_args[]);
if of_setargs(aa_args[]) <> c#return.success then
	return c#return.failure
end if

return of_retrieve()


end function

public function long of_retrieve ();
return retrieve(ia_args[1],ia_args[2],ia_args[3],ia_args[4],ia_args[5],ia_args[6],ia_args[7],ia_args[8],ia_args[9],ia_args[10], &
	ia_args[11],ia_args[12],ia_args[13],ia_args[14],ia_args[15],ia_args[16],ia_args[17],ia_args[18])
end function

public function integer of_addupdatetable (string as_tablename, string as_allcolumns, string as_keycolumns);/********************************************************************
   of_addupdatetable
   <DESC>	Add a table to be updated	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename
		as_allcolumns
		as_keycolumns
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/07/15 CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_index, ll_index2
long ll_upperbound, ll_upperbound2
string ls_allcolumns[]
string ls_keycolumns[]
string ls_alldbcolumns[]
mt_n_stringfunctions lnv_string
string ls_type, ls_dbname
long ll_tblpos

// Validate parameters
if IsNull(as_tablename) or IsNull(as_allcolumns) or IsNull(as_keycolumns) then
	return c#return.Failure
end if
if as_tablename = "" or as_allcolumns = "" or as_keycolumns = "" then
	return c#return.Failure
end if

// Check if the table has already been in the array
ll_upperbound = upperbound(istr_multiupdate[])
for ll_index = 1 to ll_upperbound
	if istr_multiupdate[ll_index].tablename = as_tablename then
		return -1
	end if
next

lnv_string.of_parsetoArray(as_keycolumns,",",ls_keycolumns[])
lnv_string.of_parsetoArray(as_allcolumns,",",ls_allcolumns[])

// Ignore the head and tail space characters
ll_upperbound = upperbound (ls_keycolumns[])
for ll_index = 1 to ll_upperbound
	ls_keycolumns[ll_index] = trim(ls_keycolumns[ll_index])
next
ll_upperbound = upperbound (ls_allcolumns[])
for ll_index = 1 to ll_upperbound
	ls_allcolumns[ll_index] = trim(ls_allcolumns[ll_index])
next

// Check if the key columns are valid
ll_upperbound = upperbound (ls_keycolumns[])
for ll_index = 1 to ll_upperbound
	ll_upperbound2 = upperbound (ls_allcolumns[])
	for ll_index2 = 1 to ll_upperbound2
		if ls_keycolumns[ll_index] = ls_allcolumns[ll_index2] then
			exit
		end if
	next
	if ll_index2 > ll_upperbound2 then
		return c#return.Failure
	end if
next

// Check if they all are columns
ll_upperbound = upperbound (ls_allcolumns[])
for ll_index = 1 to ll_upperbound
	ls_type = this.describe( ls_allcolumns[ll_index] + ".type" )
	if not (ls_type = "column") then
		return c#return.Failure
	end if
next

// Find all database column names
ll_upperbound = upperbound (ls_allcolumns[])
for ll_index = 1 to ll_upperbound
	ls_dbname = this.describe( ls_allcolumns[ll_index] + ".dbname" )
	if ls_dbname = "?" or ls_dbname="!" or ls_dbname = "" then
		return c#return.Failure
	end if
	ll_tblpos = pos(ls_dbname, ".")
	if ll_tblpos > 0 then
		ls_dbname = as_tablename + right(ls_dbname, len(ls_dbname) - ll_tblpos + 1)
	else
		ls_dbname = as_tablename + "." + ls_dbname
	end if
	ls_alldbcolumns[ll_index] = ls_dbname
next

// Add to the array
ll_upperbound = upperbound(istr_multiupdate[]) + 1
istr_multiupdate[ll_upperbound].tablename = as_tablename
istr_multiupdate[ll_upperbound].keycolumns[] = ls_keycolumns[]
istr_multiupdate[ll_upperbound].allcolumns[] = ls_allcolumns[]
istr_multiupdate[ll_upperbound].alldbcolumns[] = ls_alldbcolumns[]

return c#return.Success

end function

public function integer of_addupdatetable (string as_tablename, string as_keycolumns);/********************************************************************
   of_addupdatetable
   <DESC>	Add an update table	</DESC>
   <RETURN>	long:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_tablename
		as_keycolumns : a string delimited by commas
   </ARGS>
   <USAGE>	Called after of_init()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		03/07/15 CR3907        SSX014   First Version
   </HISTORY>
********************************************************************/

long ll_index
long ll_columncount
string ls_dbname
string ls_colname, ls_colid, ls_allcolumns
long ll_tablepos
string ls_tablename
long ll_k, ll_upper
mt_n_stringfunctions lnv_string
string ls_keycolumns[]

// Parse the string delimited by comma into an array
// and trim the leading and tail spaces for each item
lnv_string.of_parsetoarray(as_keycolumns, ',', ls_keycolumns[])
ll_upper = upperbound(ls_keycolumns[])
for ll_k = 1 to ll_upper
	ls_keycolumns[ll_k] = trim(ls_keycolumns[ll_k])
next

ll_columncount = long (this.Object.DataWindow.Column.Count)
for ll_index = 1 to ll_columncount
	ls_colid = "#" + string(ll_index)
	ls_dbname = this.describe( ls_colid + ".dbname")
	ls_colname = this.describe( ls_colid + ".name")
	ll_tablepos = pos(ls_dbname, ".")
	if ll_tablepos > 0 then
		ls_tablename = left(ls_dbname, ll_tablepos - 1)
	else
		ls_tablename = ""
	end if
	if ls_tablename = as_tablename then
		if ls_allcolumns  = "" then
			ls_allcolumns = ls_colname
		else
			ls_allcolumns += "," + ls_colname
		end if
	else
		for ll_k = 1 to upperbound(ls_keycolumns)
			if ls_colname = lower(ls_keycolumns[ll_k]) then
				if ls_allcolumns  = "" then
					ls_allcolumns = ls_colname
				else
					ls_allcolumns += "," + ls_colname
				end if
				exit
			end if
		next
	end if
next

return of_addupdatetable(as_tablename, ls_allcolumns, as_keycolumns)


end function

public function integer of_setmultitableupdate (boolean ab_switch);
if not isnull(ab_switch) then
	ib_multitableupdate = ab_switch
	return c#return.Success
end if

return c#return.Failure

end function

public function long of_getlasterrcode ();return il_lasterrcode

end function

public function string of_getlasterrtext ();return is_lasterrtext

end function

public function integer of_addattachmenttable ();return of_addupdatetable("ATTACHMENTS", "file_id")
end function

public function integer of_setargrefs (string as_argrefs[]);/********************************************************************
of_setargrefs( /*ref str_requested_att astr_att*/) 

<DESC>
	called by the u_att.of_init() function.  loads the instance variable
	is_argrefs[]
</DESC>
<RETURN> 
	Integer:
		<LI> 1, c#return.Success
		<LI> -1, c#return.Failure
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	string as_argrefs[] - array of datawindow column control names that link
	to values passed in aa_args[]
</ARGS>
<USAGE>
	AGL 20150710
</USAGE>
********************************************************************/

long ll_upper
long ll_i


ll_upper = Upperbound(as_argrefs)
if ll_upper > MAX_ARGS then
	ll_upper = MAX_ARGS
end if

for ll_i = 1 to ll_upper
	is_argrefs[ll_i] = as_argrefs[ll_i]
next

return c#return.success

end function

public function integer of_getargrefs (ref string as_argrefs[]);/********************************************************************
of_getargrefs( /*ref str_requested_att astr_att*/) 

<DESC>
	Not sure this is currently used or not. Here for completeness.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, c#return.Success
		<LI> -1, c#return.Failure
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	string as_argrefs[] - array of datawindow column control names that link
	to values passed in aa_args[]
</ARGS>
<USAGE>
	AGL 20150710
</USAGE>
********************************************************************/


as_argrefs[] = is_argrefs[]
return c#return.failure
end function

public function long of_insertrow (ref str_requested_att lstr_att);/********************************************************************
of_insertrow( /*ref str_requested_att astr_att*/) 

<DESC>
	function inserts new row into datawindow, stores row id in structure &
	adds data to key (important) columns.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, c#return.Success
		<LI> -1, c#return.Failure
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
	str_requested_att astr_att - array of attachment details that links the 
	filesystem to the datawindow row
</ARGS>
<USAGE>
	AGL 20150710
</USAGE>
********************************************************************/

long ll_row
integer li_arg_index=1
			
ll_row = this.insertrow(0)			
lstr_att.l_row_id = this.getrowidfromrow(ll_row)


// TODO - should this be here or inside a function in u_att that can be overridden by a child?
if this.describe("description.type")<>"!" then &
	this.setitem(ll_row,"description",lstr_att.s_file_name)
if this.describe("file_name.type")<>"!" then &
	this.setitem(ll_row,"file_name",lstr_att.s_file_name)
	
do 
	this.setitem(ll_row,is_argrefs[li_arg_index],ia_args[li_arg_index])								
	li_arg_index ++
loop until is_argrefs[li_arg_index]=""	

return ll_row
end function

public function integer of_setrowselection (boolean ab_switch);// Check arguments
if IsNull(ab_switch) then
	return -1
end if

if ab_switch then
	// Enable the service if it is not enabled
	if IsNull(inv_rowselection) or not IsValid(inv_rowselection) then
		inv_rowselection = create n_rowselection
		inv_rowselection.of_setrequestor(this)
		__ib_rowselection = true
	else
		return 0
	end if
else
	// Destroy the service if it is enabled
	if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
		destroy inv_rowselection
		__ib_rowselection = false
	else
		return 0
	end if
end if

// Return 1 if everything is ok
return 1

end function

on mt_u_dw_att.create
call super::create
end on

on mt_u_dw_att.destroy
call super::destroy
end on

event sqlpreview;call super::sqlpreview;// Only perform the requested SQL statements
if  (sqltype = PreviewSelect!) or &
	((sqltype = PreviewInsert!) and pos(is_updatesallowed,"I") > 0) or &
	((sqltype = PreviewUpdate!) and pos(is_updatesallowed,"U") > 0) or &
	((sqltype = PreviewDelete!) and pos(is_updatesallowed,"D") > 0) then
	// Do nothing
	// Allow continuing to execute the SQL statements
else
	return 2
end if

end event

event dberror;call super::dberror;
il_lasterrcode = sqldbcode
is_lasterrtext = sqlerrtext

return ancestorreturnvalue

end event

event clicked;call super::clicked;// forward the event to the row selection service
if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
	inv_rowselection.event ue_clicked(xpos, ypos, row, dwo)
end if

end event

event constructor;call super::constructor;// By default, you can check the box on descendant to enable or disable the service.
if __ib_rowselection then
	of_setrowselection(true)
	inv_rowselection.of_setstyle(inv_rowselection.EXTENDED)
end if

end event

event rowfocuschanged;call super::rowfocuschanged;// forward the event to the row selection service
if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
	inv_rowselection.event ue_rowfocuschanged(currentrow)
end if

end event

event rbuttondown;call super::rbuttondown;// forward the event to the row selection service
if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
	inv_rowselection.event ue_rbuttondown(xpos, ypos, row, dwo)
end if

end event

event ue_lbuttondown;call super::ue_lbuttondown;// forward the event to the row selection service
if IsValid(inv_rowselection) and not IsNull(inv_rowselection) then
	inv_rowselection.event ue_lbuttondown(flags, xpos, ypos)
end if

end event

