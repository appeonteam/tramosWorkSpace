$PBExportHeader$n_company_contacts_interface.sru
forward
global type n_company_contacts_interface from mt_n_interface_master
end type
end forward

global type n_company_contacts_interface from mt_n_interface_master
end type
global n_company_contacts_interface n_company_contacts_interface

type variables
private	long	ii_pcarray[]

private long	il_companyid
private	long	il_pcgroupid
end variables

forward prototypes
protected subroutine _setup ()
private function double _get_tcfreight_chart (string as_year, long al_chartid)
public function integer of_update ()
private function integer _validate ()
public function boolean of_updatespending ()
public function integer of_map_company (string as_link_table, long al_link_id)
public function long of_map_company_delete ()
public function integer of_check_company_link ()
private subroutine _get_freight_broker (string as_year, long al_brokerid, ref double al_freightcom, ref double al_demcom, ref double al_tccom)
public function integer of_insertrow (readonly string as_dsname)
public function integer of_deleterow (readonly string as_dsname, long al_row)
public function long of_retrieve_mapping ()
public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row)
public function long of_retrieve_company (s_company astr_company)
public function long of_retrieve (integer ai_pcgroupid)
private subroutine documentation ()
private subroutine _get_chart_overview (string as_year, long al_chartid, ref double al_freight, ref double al_dem)
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

_createdatastore( "companypicklist", "d_sq_tv_company_by_pcgroup", "")
_createdatastore( "companydetails", "d_sq_ff_company_detail", "")
_createdatastore( "contacts", "d_sq_ff_contact_detail", "")
_createdatastore( "linkdetail", "d_sq_tb_companies_linkdetail", "")
_createdatastore( "incomeoverview", "d_sq_tb_companies_income", "")
_createdatastore( "outstandingchart", "d_sq_tb_chart_outstanding", "")
_createdatastore( "outstandingbroker", "d_sq_tb_broker_outstanding", "")





end subroutine

private function double _get_tcfreight_chart (string as_year, long al_chartid);/********************************************************************
   _get_tcfreight_chart   
   <DESC> Calculates TC freight by charterer and year </DESC>
   <RETURN> 
		Total TC freight
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		as_year: Year - format yy
		al_chartid: charterer ID
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/
Long ll_ret
DateTime ldt_periodstart, ldt_periodend
decimal ld_tcfreight

Datastore lds_data

ldt_periodstart = datetime(date(2000+integer(as_year), 1,1))
ldt_periodend = datetime(date(2000+integer(as_year), 12,31),time(23,59,59))

lds_data = create datastore

lds_data.dataobject = "d_sq_tb_chart_tcfreight"

lds_data.settransobject(SQLCA)
ll_ret = lds_data.Retrieve(al_chartid, ldt_periodstart, ldt_periodend, ii_pcarray)

if ll_ret < 1 then
	destroy lds_data 
	return 0
else
	ld_tcfreight = lds_data.GetItemDecimal(1,"total_tc_freight")
	destroy lds_data 
	return ld_tcfreight
end if
end function

public function integer of_update ();/********************************************************************
of_update     
   <DESC> Updates data windows company and contacts </DESC>
   <RETURN> 
		c#return.success: Company retrieved with success
		c#return.failed: If error in retrieving
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_update"
long	ll_companyid, ll_row, ll_rows
string	ls_shortname, ls_name

istr_datastore[2].ds_data.setitem(1,"pcgroup_id",il_pcgroupid)
istr_datastore[2].ds_data.acceptText()

if _validate( ) =c#return.failure  then  return c#return.failure

if isnull( istr_datastore[2].ds_data.getitemnumber(1,"link_id")) then
	ls_shortname = istr_datastore[2].ds_data.getitemstring( 1, "shortname")	
	ls_name =  istr_datastore[2].ds_data.getitemstring( 1, "company")
end if
	
//update companies
if istr_datastore[2].ds_data.update() = 1 then
	ll_companyid = istr_datastore[2].ds_data.getitemnumber( 1, "companyid")
	
	//update contacts
	istr_datastore[3].ds_data.acceptText()
	ll_rows = istr_datastore[3].ds_data.rowcount()
	for ll_row = 1 to ll_rows
		if isnull(istr_datastore[3].ds_data.getitemnumber( ll_row, "companyid")) or istr_datastore[3].ds_data.getitemnumber( ll_row, "companyid") =0 then
			istr_datastore[3].ds_data.setitem( ll_row, "companyid",ll_companyid)
		end if
	next
		
	istr_datastore[3].ds_data.acceptText()
	
	if istr_datastore[3].ds_data.update() > 0 then
		commit;
	else
		rollback;
		_addmessage( this.classdefinition, METHOD_NAME, "Update Contacts failed!", "N/A")
		return c#return.failure
	end if
	
else
	rollback;
	_addmessage( this.classdefinition, METHOD_NAME, "Update Company failed!", "N/A")
	return c#return.failure
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
   <USAGE>	Use this to check if mandatory fields are not empty and verifies if shortname
	and name are unique
	</USAGE>
********************************************************************/
constant string METHOD_NAME = "_validate"
long	ll_row, ll_rows, ll_pcgroupid
string	ls_shortname, ls_company

if trim( istr_datastore[2].ds_data.getitemstring( 1, "shortname")) = "" or &
	isnull( istr_datastore[2].ds_data.getitemstring( 1, "shortname")) or &
	trim( istr_datastore[2].ds_data.getitemstring( 1, "company")) = "" or  &
	isnull( istr_datastore[2].ds_data.getitemstring( 1, "company")) or &
	isnull( istr_datastore[2].ds_data.getitemnumber( 1, "typeid"))  or  &
	isnull( istr_datastore[2].ds_data.getitemnumber( 1, "countryid")) then
	
	_addMessage( this.classdefinition, METHOD_NAME, "Mandatory fields are not filled in.", "")
	return  c#return.failure
end if

ll_pcgroupid = istr_datastore[2].ds_data.getitemnumber( 1, "pcgroup_id")

//If collumn shortname changed!
choose case istr_datastore[2].ds_data.getItemStatus(1, "shortname", primary!)
	case newModified!, dataModified!
		ls_shortname =  istr_datastore[2].ds_data.getitemstring( 1, "shortname")			
		//Check if shortname and name are unique
		SELECT COUNT(*)
		INTO :ll_rows
		FROM PF_COMPANY
		WHERE SHORTNAME = :ls_shortname AND PCGROUP_ID = :ll_pcgroupid  ;
		
		if ll_rows>0 then
			_addMessage( this.classdefinition, METHOD_NAME, "Short Name already exists. Please change it.", "")
			return  c#return.failure
		end if		
end choose

//If collumn name changed!		
choose case istr_datastore[2].ds_data.getItemStatus(1, "company", primary!)
	case newModified!, dataModified!
		ls_company =  istr_datastore[2].ds_data.getitemstring( 1, "company")
		
		SELECT COUNT(*)
		INTO :ll_rows
		FROM PF_COMPANY
		WHERE COMPANY = :ls_company AND PCGROUP_ID = :ll_pcgroupid  ;
		if ll_rows>0 then
			_addMessage( this.classdefinition, METHOD_NAME, "Company Name already exists. Please change it.", "")
			return  c#return.failure
		end if		
end choose
		

ll_rows = istr_datastore[3].ds_data.rowcount()

for ll_row=1 to ll_rows
	if isnull( istr_datastore[3].ds_data.getitemstring( ll_row, "fullname")) or trim( istr_datastore[3].ds_data.getitemstring( ll_row, "fullname")) = "" then
		_addMessage( this.classdefinition, METHOD_NAME, "Please enter the contact full name.", "")
		return  c#return.failure
	end if
next


ll_rows = istr_datastore[3].ds_data.filteredcount()

for ll_row=1 to ll_rows
	if isnull( istr_datastore[3].ds_data.getitemstring( ll_row, "fullname",Filter!, false)) or trim( istr_datastore[3].ds_data.getitemstring( ll_row, "fullname",Filter!, false	)) = "" then
		_addMessage( this.classdefinition, METHOD_NAME, "Please enter the contact full name. (Be aware that filtering is on)", "")
		return  c#return.failure
	end if
next



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

constant string METHOD_NAME = "of_updatesPending"

long		ll_dsIndex
long		ll_modCounter=0

for ll_dsIndex = 2 to 3
	ll_modCounter += istr_datastore[ll_dsIndex].ds_data.modifiedCount()
	ll_modCounter += istr_datastore[ll_dsIndex].ds_data.deletedCount()
next

if ll_modCounter > 0 then
	return true
else
	return false
end if
end function

public function integer of_map_company (string as_link_table, long al_link_id);/********************************************************************
of_map_company   
   <DESC> Maps the company to a selected system company (BROKER or CHART) </DESC>
   <RETURN> 
		c#return.success: If successfull
		c#return.failed: If error in retrieving
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		as_link_table: name of the table (BROKER or CHART)
		al_link_id: Company ID (from BROKER or CHART table)
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

long	ll_res

istr_datastore[2].ds_data.setitem(1,"link_table",as_link_table)
istr_datastore[2].ds_data.setitem(1,"link_id",al_link_id)

istr_datastore[2].ds_data.accepttext()

ll_res =of_retrieve_mapping( )

return  ll_res

 
end function

public function long of_map_company_delete ();/********************************************************************
of_map_company_delete    
   <DESC> Deletes the company mapping </DESC>
   <RETURN> 
		c#return.success: If successfull
		c#return.failed: If error in retrieving
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

long	ll_res, ll_null
string	ls_null

if messageBox("Confirm Delete", "Do you want to delete the company map?", Question!, YesNo!, 2) = 2 then return 0

setnull(ll_null)
setnull(ls_null)

istr_datastore[2].ds_data.setitem(1,"link_table",ls_null)
istr_datastore[2].ds_data.setitem(1,"link_id",ll_null)

istr_datastore[2].ds_data.accepttext()

istr_datastore[4].ds_data.Reset()
istr_datastore[5].ds_data.Reset()
istr_datastore[6].ds_data.Reset()
istr_datastore[7].ds_data.Reset()

return 0

end function

public function integer of_check_company_link ();/********************************************************************
   f_check_company_link 
   <DESC> Checks if company exists in tramos (BROKERS, CHARTERES, OWNERS, AGENTS)</DESC>
   <RETURN> 
		number of items	
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		as_company:	company name (can be shortname or name)
   </ARGS>
   <USAGE>
	</USAGE>
********************************************************************/

mt_n_datastore		ldts_link
long	ll_items
string	ls_shortname, ls_companyname

ls_shortname= istr_datastore[2].ds_data.getitemstring( 1, "shortname")
ls_companyname =  istr_datastore[2].ds_data.getitemstring( 1, "company")

ldts_link = create mt_n_datastore

ldts_link.dataobject = "d_sq_tb_companies_link"

ldts_link.settransobject(sqlca)

//Search by short and company name
ll_items = ldts_link.retrieve(UPPER(ls_shortname), UPPER( mid(ls_companyname,1,10)))

destroy ldts_link

return ll_items
end function

private subroutine _get_freight_broker (string as_year, long al_brokerid, ref double al_freightcom, ref double al_demcom, ref double al_tccom);/********************************************************************
   _get_freight_broker  
   <DESC> Calculates freight, demurrage and tc comission by broker and year </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		as_year: Year - format yy
		al_brokerid: Broker ID
		al_freightcom: Freight Comission
		al_demcom: Demurrage comission
		al_tccom: TC comission
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

Long ll_ret
decimal ld_freight

Datastore lds_data
lds_data = create datastore
lds_data.dataobject = "d_sq_tb_broker_overview"
lds_data.settransobject(SQLCA)
ll_ret = lds_data.Retrieve(as_year, al_brokerid,ii_pcarray )
if ll_ret > 0 then
	al_freightcom = lds_data.GetItemDecimal(1,"commfrt")
	al_demcom = lds_data.GetItemDecimal(1,"commdem")
	al_tccom = lds_data.GetItemDecimal(1,"commtc")
end if
destroy lds_data 

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

constant string METHOD_NAME = "of_insert"

long	ll_rows, ll_companyid

if as_dsname = "companydetails" then
	
	istr_datastore[2].ds_data.Reset()
	istr_datastore[3].ds_data.Reset()
	istr_datastore[4].ds_data.Reset()
	istr_datastore[5].ds_data.Reset()
	istr_datastore[6].ds_data.Reset()
	istr_datastore[7].ds_data.Reset()
	
	ll_rows = istr_datastore[2].ds_data.insertrow(0)
	if ll_rows < 1 then
		_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Company", "")
		return c#return.failure
	end if
	
	istr_datastore[2].ds_data.setitem( ll_rows, "pcgroup_id", il_pcgroupid)

elseif as_dsname = "contacts" then


	ll_rows = istr_datastore[3].ds_data.insertrow(0)
	if ll_rows < 1 then
		_addMessage( this.classdefinition, METHOD_NAME, "Error creating new Contact", "")
		return c#return.failure
	end if
	il_companyid = istr_datastore[2].ds_data.getitemnumber(1,"companyid")

	istr_datastore[3].ds_data.setitem( ll_rows, "maillist", 0)
	istr_datastore[3].ds_data.setitem( ll_rows, "companyid", il_companyid)
	istr_datastore[3].ds_data.setitem( ll_rows, "deactivated",0)
	
end if

return ll_rows
	
end function

public function integer of_deleterow (readonly string as_dsname, long al_row);/********************************************************************
of_deleterow 
   <DESC> Deletes a company and contacts, after user confirmation.
	An active contact used in the Postions List cannot be deleted. </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Public   </ACCESS>
   <ARGS>
		as_dsname: Data set name
		al_row: Row of the contact to be deleted
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_deleterow"
long	ll_rows, ll_row, ll_rowselected, ll_rc
string	ls_warning
boolean	lb_maillistfound

if as_dsname ="companydetails" then
	
	//delete company
	ll_rowselected =  istr_datastore[2].ds_data.getrow()
	if ll_rowselected < 1 then 	return -1
	
	if MessageBox("Warning", "Do you want to delete contact '" +   istr_datastore[2].ds_data.getitemstring( ll_rowselected,"company")  + "' ?"  ,Question!, YesNo! ) = 2 then return  c#return.failure
	
	ll_rows = istr_datastore[3].ds_data.rowcount()
	lb_maillistfound = false
	for ll_row=ll_rows  to 1 step -1
		 if istr_datastore[3].ds_data.getitemnumber(ll_row,"maillist") = 1 and istr_datastore[3].ds_data.getitemnumber(ll_row,"deactivated") = 0 then
			lb_maillistfound = true
			exit
		end if
		istr_datastore[3].ds_data.deleterow( ll_row) 
	next
	if lb_maillistfound = true then
		_addMessage( this.classdefinition, METHOD_NAME, "Is not possible to delete Company, because contacts are being used in the Position List.", "n/a")	
		rollback;
		return c#return.failure
	end if

	if istr_datastore[3].ds_data.update() <> 1 then
		_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Contacts!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
		rollback;
		return c#return.failure
	end if
	
	istr_datastore[2].ds_data.deleterow(ll_rowselected)
	
	if istr_datastore[2].ds_data.update() <> 1 then
		_addmessage( this.classdefinition, METHOD_NAME, "Error deleting Company!", "SQLCode ="+string(sqlca.SQLCode)+"~r~nSQLErrText="+sqlca.sqlerrtext )
		rollback;
		return c#return.failure
	end if
	
	commit;
		

elseif as_dsname = "contacts" then
	if  istr_datastore[3].ds_data.getitemnumber( al_row,"maillist") = 1 then
		_addmessage( this.classdefinition, METHOD_NAME, "Is not possible to delete a contact, because is used in the Position List!", "N/A")
		return c#return.failure
	end if
	
	if MessageBox("Warning", "Do you want to delete contact '" + istr_datastore[3].ds_data.getitemstring( al_row,"fullname")  + "' ?",Question!, YesNo! ) = 2 then return c#return.failure
	
	if istr_datastore[3].ds_data.deleterow( al_row) = -1 then
		_addmessage( this.classdefinition, METHOD_NAME, "Error deliting contact!", "N/A")
		return c#return.failure
	end if
end if

return c#return.success
end function

public function long of_retrieve_mapping ();/********************************************************************
  of_retrieve_mapping( )   
   <DESC> Retrieves the data sets related with mapping information </DESC>
   <RETURN> 
		c#return.success: If successfull
		c#return.failed: If error in retrieving
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

constant string METHOD_NAME = "_retrieve_link"

long	ll_year1, ll_year2, ll_row
string	ls_year1, ls_year2
long ll_linkid, ll_pcgroupid, ll_rows
string ls_linktable
double ld_freight, ld_dem, ld_tccom
mt_n_datastore	lds_profitcenter
long	ll_emptyarray[]

istr_datastore[4].ds_data.Reset()
istr_datastore[5].ds_data.Reset()
istr_datastore[6].ds_data.Reset()
istr_datastore[7].ds_data.Reset()

ll_linkid = istr_datastore[2].ds_data.getitemnumber(1, "link_id")
ls_linktable = istr_datastore[2].ds_data.getitemstring(1, "link_table")
ll_pcgroupid = istr_datastore[2].ds_data.getitemnumber(1, "pcgroup_id")

if isnull(ll_linkid)  or isnull(ls_linktable) or ll_linkid=0 then
	return c#return.success
end if

istr_datastore[4].ds_data.retrieve(ll_linkid, ls_linktable)

//retrieve outstanding
if ls_linktable = "CHART" or ls_linktable = "BROKER" then
	if ll_pcgroupid <> il_pcgroupid or ii_pcarray = ll_emptyarray  then
		
		//Find PC array
		lds_profitcenter = create mt_n_datastore
		lds_profitcenter.dataobject = "d_profit_center_by_group"
		lds_profitcenter.settransobject( SQLCA)
		lds_profitcenter.retrieve(ll_pcgroupid)
		commit;
		
		ll_rows = lds_profitcenter.rowcount()
		ii_pcarray = ll_emptyarray
		
		for ll_row = 1 to ll_rows
			ii_pcarray[ll_row] =  lds_profitcenter.getitemnumber( ll_row, "pc_nr")
		next
		destroy (lds_profitcenter)
		il_pcgroupid = ll_pcgroupid
	end if

	if ls_linktable = "CHART" then
		istr_datastore[6].ds_data.retrieve(ii_pcarray, ll_linkid)
	elseif ls_linktable = "BROKER" then
		istr_datastore[7].ds_data.retrieve(ii_pcarray, ll_linkid)
	end if

	//retrieve income
	ll_row = istr_datastore[5].ds_data.insertrow(0)
	if ll_row < 1 then
		_addMessage( this.classdefinition, METHOD_NAME, "Error retrieving link", "")
		return c#return.failure
	end if
	
	
	ll_year2 = year(today())
	ll_year1 =  ll_year2 - 1
	ls_year1 = mid(string(ll_year1),3,2)
	ls_year2 = mid(string(ll_year2),3,2)
	
	istr_datastore[5].ds_data.setitem(1,	"Type", ls_linktable)
	if ls_linktable = "CHART" then
		
		_get_chart_overview(ls_year1, ll_linkid, ld_freight, ld_dem)
		istr_datastore[5].ds_data.setitem(1, "freight1", ld_freight)
		istr_datastore[5].ds_data.setitem(1, "demurrage1", ld_dem)
			
		ld_freight =0
		ld_dem=0
		 
		 _get_chart_overview(ls_year2, ll_linkid, ld_freight, ld_dem)
		 istr_datastore[5].ds_data.setitem(1, "freight2", ld_freight)
		istr_datastore[5].ds_data.setitem(1, "demurrage2", ld_dem)
		
		istr_datastore[5].ds_data.setitem(1, "tc1", _get_tcfreight_chart(ls_year1, ll_linkid))
		istr_datastore[5].ds_data.setitem(1, "tc2", _get_tcfreight_chart(ls_year2, ll_linkid))
	
	elseif ls_linktable = "BROKER" then
		
		_get_freight_broker(ls_year1, ll_linkid, ld_freight, ld_dem, ld_tccom)
		
		istr_datastore[5].ds_data.setitem(1, "freight1", ld_freight)
		istr_datastore[5].ds_data.setitem(1, "demurrage1", ld_dem)
		istr_datastore[5].ds_data.setitem(1, "tc1", ld_tccom)
		
		 ld_freight =0
		 ld_dem=0
		 ld_tccom=0
		_get_freight_broker(ls_year2, ll_linkid, ld_freight, ld_dem, ld_tccom)
		
		istr_datastore[5].ds_data.setitem(1, "freight2", ld_freight)
		istr_datastore[5].ds_data.setitem(1, "demurrage2", ld_dem)
		istr_datastore[5].ds_data.setitem(1, "tc2", ld_tccom)
		
	end if
end if

return c#return.success
end function

public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row);/********************************************************************
   of_rowFocusChanged
   <DESC>  This function is called to retrieve all the detail datasets belonging to
	the passed master dataset</DESC>
   <RETURN> Integer:
            <LI> c#return.success, X ok
            <LI> c#return.noaction, X no action</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_master_dsname: Master dataset name
            al_row: Pointer to selected row in master dataset</ARGS>
   <USAGE> </USAGE>
********************************************************************/
long ll_companyid

if al_row < 1 then return c#return.noaction

if as_master_dsname = "companypicklist" then
	ll_companyid = istr_datastore[1].ds_data.getItemNumber(al_row, "companyid")

	//retrieve company
	 istr_datastore[2].ds_data.retrieve(ll_companyid)
	
	//retrieve contacts
	istr_datastore[3].ds_data.retrieve(ll_companyid)
	
end if

return c#return.success
end function

public function long of_retrieve_company (s_company astr_company);/********************************************************************
   of_retrieve_company
   <DESC> Retrieves the company and contacts </DESC>
   <RETURN> 
		ll_rows: Should be equal 1 (row inserted or row retrieved)
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		astr_company: structure with company details
   </ARGS>
   <USAGE>	
	Used from w_company_contacts_overview (where pick list does not exist)
	</USAGE>
********************************************************************/

long	ll_rows

il_companyid = astr_company.companyid
il_pcgroupid = astr_company.pcgroup

if il_companyid<1 then
	ll_rows = of_insertrow("companydetails")
else

	istr_datastore[2].ds_data.Reset()
	istr_datastore[3].ds_data.Reset()

	//retrieve company
	ll_rows =  istr_datastore[2].ds_data.retrieve(il_companyid)
	
	//retrieve contacts
	istr_datastore[3].ds_data.retrieve(il_companyid)
	
end if
return ll_rows

end function

public function long of_retrieve (integer ai_pcgroupid);/********************************************************************
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
il_pcgroupid = ai_pcgroupid
return istr_datastore[1].ds_data.retrieve(ai_pcgroupid)





end function

private subroutine documentation ();/********************************************************************
   n_company_contacts_interface: a 'container' (non visual window) to encapsulate the 
	functionality provided by the implementation of the chartering companies handling, and 
	separate business logic from GUI.
   <OBJECT> This object holds all datasets and business logic related to the chartering companies
	implementation. The datasets are in an array, and as follows:
	
		companypicklist 	( istr_datastore[1].ds_data ) - d_sq_tv_company_by_pcgroup
		companydetails  	( istr_datastore[2].ds_data ) - d_sq_ff_company_detail
		contacts  	( istr_datastore[3].ds_data ) - d_sq_ff_contact_detail
		linkdetail  	( istr_datastore[4].ds_data ) - d_sq_tb_companies_linkdetail
		incomeoverview  	( istr_datastore[5].ds_data ) - d_sq_tb_companies_income
		outstandingchart  	( istr_datastore[6].ds_data ) - d_sq_tb_chart_outstanding
		outstandingbroker  	( istr_datastore[7].ds_data ) - d_sq_tb_broker_outstanding
		
	</OBJECT>
   
	<DESC> of_retrieve (ai_pcgroupid)					- retrieves the list of companies by profit center group (used from w_companies)
				of_retrieve_company(astr_company)		- retrieves the company and contacts (used from w_contact_companies_overview)
				of_retrieve_mapping()						- retrieves the mapping details
				of_insertrow (as_dsname)		- inserts requested row, and sets the default values
				of_update()							- updates companies and contacts
				of_deleterow(as_dsname, al-row)		- deletes requested row, and all detail datasets if any
				of_rowfocuschanged (as_master_dsname, al_row) - reretrieves all detail datasets if master changed
				of_check_company_link()						- checks if company can be mapped
				of_map_company(as_link_table, al_link_id)	- Maps a company
				of_map_company_delete() 						- Deletes the mapping
				</DESC>
   <USAGE> Normally this object will need a window, with the number of datawindow
	objects that you need to visualize. In order to find the dataset names go to the 
	__setup function, and see the names.
	
	Instantiate the object in a window, and use the of_share function, to connect the 
	visual datawindow with the dataset</USAGE>
   <ALSO>  </ALSO>
    	Date   		Ref    			Author		Comments
  	21/10/10		CR1412	JMC112		Initial Version
********************************************************************/

end subroutine

private subroutine _get_chart_overview (string as_year, long al_chartid, ref double al_freight, ref double al_dem);/********************************************************************
   _get_chart_overview
   <DESC> Calculates freight and demurrage  by charterer and year </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		as_year: Year - format yy
		al_chartid: Broker ID
		al_freight: Freight Comission
		al_dem: Demurrage comission
		al_tc: TC comission
   </ARGS>
   <USAGE>	
	</USAGE>
********************************************************************/

Long ll_ret
decimal ld_freight

Datastore lds_data
lds_data = create datastore
lds_data.dataobject = "d_sq_tb_chart_overview"
lds_data.settransobject(SQLCA)
ll_ret = lds_data.Retrieve(as_year, ii_pcarray, al_chartid )
if ll_ret > 0 then
	al_freight = lds_data.GetItemDecimal(1,"total_freight")
	al_dem = lds_data.GetItemDecimal(1,"total_dem")
end if
destroy lds_data 

end subroutine

on n_company_contacts_interface.create
call super::create
end on

on n_company_contacts_interface.destroy
call super::destroy
end on

