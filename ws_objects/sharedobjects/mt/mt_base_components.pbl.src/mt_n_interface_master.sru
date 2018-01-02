$PBExportHeader$mt_n_interface_master.sru
forward
global type mt_n_interface_master from mt_n_nonvisualobject
end type
end forward

global type mt_n_interface_master from mt_n_nonvisualobject
end type
global mt_n_interface_master mt_n_interface_master

type variables
 str_interface_datastore	istr_datastore[]
protected n_service_manager		inv_serviceManager
end variables

forward prototypes
public function long of_retrieve ()
public function integer of_retrieve (readonly string as_dsname)
private subroutine documentation ()
public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row)
public function integer of_share (readonly string as_dsname, ref mt_u_datawindow adw)
private function long __finddataset (readonly string as_dsname)
protected subroutine _setup ()
protected function integer _setdetail (readonly string as_dsname, readonly string as_detail_dsname, readonly string as_arguments[])
protected function integer _createdatastore (readonly string as_dsname, readonly string as_dataobject, readonly string as_businessobject)
private function integer __setmaster (readonly string as_dsname, readonly string as_master_dsname)
private function integer __retrievedataset ()
private function long __retrievedataset (readonly string as_dsname)
public function integer of_deleterow (readonly string as_dsname, long al_row)
public function integer of_insertrow (readonly string as_dsname)
public function integer of_update ()
public function boolean of_updatespending ()
end prototypes

public function long of_retrieve ();/********************************************************************
   of_retrieve()
   <DESC> This function retrieves all dataset registred in dataset structure by
	handling it over to __retrieveDataset</DESC>
   <RETURN> Long:
            <LI> n, ok 
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS> (none)</ARGS>
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_retrieve"

if __retrieveDataset() = c#return.failure then
	_addMessage( this.classdefinition , &
				METHOD_NAME , &
				"Retrieval of dataset failed!", &
				"")
	// sqlca.of_rollback( )
	rollback using sqlca;
	return c#return.failure
end if

// sqlca.of_commit( )
commit using sqlca;
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

//if __retrieveDataset(as_dsName) = c#return.failure then
//	of_adderror( of_tostring( ) , &
//				METHOD_NAME , &
//				"Retrieval of dataset '"+as_dsname+"' failed!")
//	//sqlca.of_rollback( )
//	return c#return.failure
//end if

//sqlca.of_commit( )
return c#return.success
end function

private subroutine documentation (); /********************************************************************
   mt_n_interface_master: This is an ancester class that shall be used for any interface to
								   MT developed applications
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
	
    Date   	Ref    Author        Comments
  01/07/08 	?      RMO003     	Initial version
********************************************************************/
end subroutine

public function integer of_rowfocuschanged (readonly string as_master_dsname, readonly long al_row);constant string METHOD_NAME = "of_rowFocusChanged"

long		ll_dsIndex
long		ll_#ofdetail, ll_detail_index

ll_dsIndex = __findDataset(as_master_dsname)

if ll_dsIndex > 0 then
	/* Set current row in datastore to same as visual datawindow */
	istr_datastore[ll_dsIndex].ds_data.setRow(al_row)
	
	ll_#ofdetail = upperBound(istr_datastore[ll_dsIndex].detail)
	for ll_detail_index = 1 to ll_#ofdetail
		if of_retrieve(istr_datastore[ll_dsIndex].detail[ll_detail_index].ds_detail_name) = c#return.failure then
			// No need for adding error message here, as message is already added in of_retrieve()
			return c#return.failure
		end if
	next
	return c#return.success
else
	// No need for adding error message here, as message is already added in __findDataset
	return c#return.failure
end if	

end function

public function integer of_share (readonly string as_dsname, ref mt_u_datawindow adw);/********************************************************************
   of_share	
   <DESC> This function is called from the clinet when a client want's to share a
	dataset with a 'visual' datawindow control on a window.
	It also sets the name of the dataset and if the dataset has children (master - detail).
	These two properties are set in the datawindow control for use at 'client' site</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_dsName: 	The name of the dataset in the array
            		adw:				Reference to the datawindow control</ARGS>
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "of_share"

long		ll_dsIndex

ll_dsIndex = __findDataset(as_dsname) 

if  ll_dsIndex > 0 then
	/* set the datawindow control dataobject to the same as the dataset dataobject */
	adw.dataobject = istr_datastore[ll_dsIndex].dw_object
	if istr_datastore[ll_dsIndex].ds_data.sharedata(adw) = -1 then
//		of_adderror( of_tostring( ) , METHOD_NAME , "Share for dataset '"+as_dsName+"' failed!")
		return c#return.failure
	end if
	adw.is_dsName = as_dsName
	if upperBound(istr_datastore[ll_dsIndex].detail) > 0 then adw.ib_hasChildren = true
	return c#return.success	
else
	//no need to add error message as message already handled by __findDataset
	return c#return.failure	
end if
end function

private function long __finddataset (readonly string as_dsname);/********************************************************************
   __findDataset	
   <DESC> This function finds the dataset in the array of datasets. If the name is
	not found it returns an error.</DESC>
   <RETURN> Long:
            <LI> n, if OK return the array index number
            <LI> -1, failed - name not found </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   as_dsName: 	The name of the dataset in the array
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "__findDataset"

long		ll_dsIndex, ll_#ofDatasets
boolean	lb_found=false

ll_#ofDatasets = upperbound(istr_datastore)

/* Find the dataset */
for ll_dsIndex = 1 to ll_#ofDatasets
	if istr_datastore[ll_dsIndex].ds_name = as_dsName then 
		lb_found = true
		EXIT
	end if
next

if lb_found then 
	return ll_dsIndex
else
//	of_adderror( of_tostring( ) , METHOD_NAME, "Dataset '"+as_dsName+"' not found") 
	return c#return.failure
end if
end function

protected subroutine _setup ();/********************************************************************
   _setup( )
   <DESC>   This function is made for holding all the datastore/dataset creations
	at when the object is instantiated</DESC>
   <RETURN>(None)</RETURN>
   <ACCESS>Private</ACCESS>
   <ARGS>(None)</ARGS>
   <USAGE></USAGE>
********************************************************************/
constant string METHOD_NAME = "_setup"




end subroutine

protected function integer _setdetail (readonly string as_dsname, readonly string as_detail_dsname, readonly string as_arguments[]);/********************************************************************
   _setDetail
   <DESC> If a dataset is part of a master-detail chain, this function sets the detail (child) 
	dataset that the master is connected to, and the column names of the retrival 
	arguments to be used.
	At the end it calls the function that sets the master for given child</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Protected</ACCESS>
   <ARGS>   as_dsName: Master dataset name
            		as_detail_dsName: Child dataset name
				as_arguments[]: Array of column names used as retrival arguments	</ARGS>
   <USAGE>  Please ensure that all dataset are created before calling this function</USAGE>
********************************************************************/
constant string METHOD_NAME = "__setDetail"

long		ll_dsIndex, ll_detailIndex
long 		ll_#ofArguments, ll_argIndex

ll_dsIndex = __findDataset(as_dsName)

if ll_dsIndex > 0 then
	ll_detailIndex = upperbound( istr_datastore[ll_dsIndex].detail) +1
	istr_datastore[ll_dsIndex].detail[ll_detailIndex].ds_detail_name = as_detail_dsname
	ll_#ofArguments = upperbound(as_arguments)
		for ll_argIndex = 1 to ll_#ofArguments
			istr_datastore[ll_dsIndex].detail[ll_detailIndex].ds_detail_argument[ll_argIndex] = as_arguments[ll_argIndex]
		next
	__setMaster(as_detail_dsName, as_dsName)
	return c#return.success
else
	// No need for adding error message here, as message is already added in __findDataset
	return c#return.failure
end if

end function

protected function integer _createdatastore (readonly string as_dsname, readonly string as_dataobject, readonly string as_businessobject);/********************************************************************
   _createDatastore
   <DESC> This function is for setup of the dataset array in the 'interface'.
	The function is called for every sindle dataset that has to be created.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Protected</ACCESS>
   <ARGS> 	as_dsName: 	The name of the dataset. Dataset shall always be referenced 
									by this name
            		as_dataObject:	Datawindow object used for this dataset
		as_businessobject:	Classname of business object if any	</ARGS>
   <USAGE> This function will typically be called form the _setup() function, to set all the 
	initial values for this interface.</USAGE>
********************************************************************/
constant string METHOD_NAME = "_createDatastore"

long ll_dsIndex

ll_dsIndex = upperbound( istr_datastore ) +1

istr_datastore[ll_dsIndex].ds_name = as_dsName
istr_datastore[ll_dsIndex].dw_object = as_dataObject
istr_datastore[ll_dsIndex].business_service[upperbound(istr_datastore[ll_dsIndex].business_service) +1] = as_businessobject
istr_datastore[ll_dsIndex].ds_data = create mt_n_datastore
istr_datastore[ll_dsIndex].ds_data.dataobject = istr_datastore[ll_dsIndex].dw_object
if istr_datastore[ll_dsIndex].ds_data.setTransObject(sqlca) <> 1 then
//	of_adderror( of_tostring( ) , METHOD_NAME, "Error setting transaction object for Dataset '"+as_dsName+"'") 
	return c#return.failure
end if

return c#return.success
end function

private function integer __setmaster (readonly string as_dsname, readonly string as_master_dsname);constant string METHOD_NAME = "__setMaster"

long	ll_dsIndex

ll_dsIndex = __findDataset(as_dsname)

if ll_dsIndex > 0 then
	istr_datastore[ll_dsIndex].master = as_master_dsname
	return c#return.success
else
	// No need for adding error message here, as message is already added in __findDataset
	return c#return.failure
end if	

end function

private function integer __retrievedataset ();/********************************************************************
   __retrieveDataset()
   <DESC> This function retrieves all dataset registred in dataset structure.
	Finds all the top level (no master) and sends the retrieval to the other
	retrieve function with a dataset name.</DESC>
   <RETURN> Long:
            <LI> n, ok 
            <LI> -1, X failed</RETURN>
   <ACCESS> Privat</ACCESS>
   <ARGS> (none)</ARGS>
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "__retrieveDataset"

long ll_#ofDatasets, ll_dsIndex

ll_#ofDatasets = upperBound(istr_datastore)

for ll_dsIndex = 1 to ll_#ofDatasets
	if istr_datastore[ll_dsIndex].master = "" or isNull(istr_datastore[ll_dsIndex].master) then
		if __retrieveDataset( istr_datastore[ll_dsIndex].ds_name) = c#return.failure then
			return c#return.failure
		end if
	end if
next

return c#return.success
end function

private function long __retrievedataset (readonly string as_dsname);/********************************************************************
   __retrieveDataset()
   <DESC> This function retrieves the dataset given by name and all its children, if any.</DESC>
   <RETURN> Long:
            <LI> n, ok 
            <LI> -1, X failed</RETURN>
   <ACCESS> Privat</ACCESS>
   <ARGS>  as_dsName:  Dataset name to retrieve</ARGS>
   <USAGE> </USAGE>
********************************************************************/
constant string METHOD_NAME = "__retrieveDataset"

long 	ll_ds_index[]
long	ll_masterIndex, ll_detailIndex
long	ll_retrieveIndex, ll_#ofRetrievals
long	ll_#ofArguments, ll_argIndex
long	ll_mrow
any	la_retrievalArgument[9], la_empty[9]
string	ls_argument_column
mt_n_datastore lds_working
 
n_linkage_service	lnv_linkage
inv_servicemanager.of_loadService( lnv_linkage, "n_linkage_service")

lnv_linkage.of_getprocessorder( as_dsname, istr_datastore[], ll_ds_index[])

ll_#ofRetrievals = upperBound(ll_ds_index)

for ll_retrieveIndex = 1 to ll_#ofRetrievals
	if istr_datastore[ll_ds_index[ll_retrieveIndex]].master = "" then
		/* If dataset is highest level, no retrieval arguments, just retrieve
		     this has to be refactored to handle retrieval arguments at highest level*/
		if istr_datastore[ll_ds_index[ll_retrieveIndex]].ds_data.retrieve() < 0 then
//			of_adderror( of_tostring( ) , METHOD_NAME, "Error retrieving Dataset '"+istr_datastore[ll_ds_index[ll_retrieveIndex]].ds_name+"'") 
			return c#return.failure
		end if
	else
		/* Has master and needs to be retrieved with retrieval arguments */
		/* Find master dataset */
		ll_masterIndex = lnv_linkage.of_findMaster(istr_datastore[ll_ds_index[ll_retrieveIndex]].master, istr_datastore)
		/* Find dataset within master detail */
		ll_detailIndex = lnv_linkage.of_findDetail(istr_datastore[ll_ds_index[ll_retrieveIndex]].ds_name, ll_masterIndex, istr_datastore)
		/* Find the Arguments to retrieve current datastore */
		la_retrievalArgument = la_empty   //reset arguments
		ll_#ofArguments = upperBound(istr_datastore[ll_masterIndex].detail[ll_detailIndex].ds_detail_argument)
		for ll_argIndex = 1 to ll_#ofArguments
			ls_argument_column = istr_datastore[ll_masterIndex].detail[ll_detailIndex].ds_detail_argument[ll_argIndex]
			lds_working = istr_datastore[ll_masterIndex].ds_data
			if lds_working.rowcount( ) < 1 then EXIT
			choose case left(upper(lds_working.Describe(ls_argument_column+".ColType")),2)
				case "DA"  								//Datetime and date (date never used)
					la_retrievalArgument[ll_argIndex] = lds_working.getItemDatetime( lds_working.getRow(), ls_argument_column)
				case "DE"								//Decimal
					la_retrievalArgument[ll_argIndex] = lds_working.getItemDecimal( lds_working.getRow(), ls_argument_column)
				case "IN", "LO", "RE", "NU", "UL"	//Int, Long, Real, Number and ULong
					la_retrievalArgument[ll_argIndex] = lds_working.getItemNumber( lds_working.getRow(), ls_argument_column)
				case "TI"									//Time and Timestamp (timestamp never used)
					la_retrievalArgument[ll_argIndex] = lds_working.getItemTime( lds_working.getRow(), ls_argument_column)
				case "CH"								//Char 
					la_retrievalArgument[ll_argIndex] = lds_working.getItemString( lds_working.getRow(), ls_argument_column)
				case else
//					of_adderror( of_tostring( ) , METHOD_NAME, "Wrong or no data type found for retrieval argument") 
					return c#return.failure
			end choose	
		next	
		if istr_datastore[ll_ds_index[ll_retrieveIndex]].ds_data.retrieve(la_retrievalArgument[1],la_retrievalArgument[2],la_retrievalArgument[3],la_retrievalArgument[4],la_retrievalArgument[5],la_retrievalArgument[6],la_retrievalArgument[7],la_retrievalArgument[8],la_retrievalArgument[9]) < 0 then
//			of_adderror( of_tostring( ) , METHOD_NAME, "Error retrieving Dataset '"+istr_datastore[ll_ds_index[ll_retrieveIndex]].ds_name+"'") 
			return c#return.failure
		end if
	end if
next

return c#return.success
end function

public function integer of_deleterow (readonly string as_dsname, long al_row);


return c#return.success
end function

public function integer of_insertrow (readonly string as_dsname);




return c#return.success
end function

public function integer of_update ();/********************************************************************
   FunctionName
   <DESC>   Description</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/

constant string METHOD_NAME = "of_update"

//MessageBox("", "Final update has to te implemented, order has to be reversed when something has to be deleted!") 
//
//mt_n_baseservice	lnv_service
//
//if istr_datastore[1].business_service[1] = "" then
//	istr_datastore[1].ds_data.update()
//else
//	inv_servicemanager.of_loadService(lnv_service, istr_datastore[1].business_service[1])
//	if lnv_service.of_update(istr_datastore[1].ds_data) = c#return.failure then return c#return.failure
//end if

return c#return.success	
end function

public function boolean of_updatespending ();constant string METHOD_NAME = "of_updatesPending"

long		ll_dsIndex
long		ll_#ofDatasets
long		ll_modCounter=0

ll_#ofDatasets = upperBound(istr_datastore)

for ll_dsIndex = 1 to ll_#ofDatasets
	ll_modCounter += istr_datastore[ll_dsIndex].ds_data.modifiedCount()
	ll_modCounter += istr_datastore[ll_dsIndex].ds_data.deletedCount()
next

if ll_modCounter > 0 then
	return true
else
	return false
end if
end function

on mt_n_interface_master.create
call super::create
end on

on mt_n_interface_master.destroy
call super::destroy
end on

event constructor;call super::constructor;_setup( )
end event

