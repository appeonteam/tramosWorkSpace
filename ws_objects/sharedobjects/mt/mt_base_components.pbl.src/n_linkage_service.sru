$PBExportHeader$n_linkage_service.sru
$PBExportComments$Encapsulation of functions related to the linkage (master - detail relations)
forward
global type n_linkage_service from mt_n_baseservice
end type
end forward

global type n_linkage_service from mt_n_baseservice
end type
global n_linkage_service n_linkage_service

type variables

end variables

forward prototypes
private subroutine documentation ()
public function long of_finddetail (readonly string as_dsname, readonly long al_masterindex, ref str_interface_datastore astr_datasets[])
public function long of_findmaster (readonly string as_dsname, ref str_interface_datastore astr_datasets[])
public function integer of_getprocessorder (readonly string as_dsname, ref str_interface_datastore astr_datastore[], ref long al_ds_index[])
public function integer of_getprocessorder (ref str_interface_datastore astr_datastore[], ref long al_ds_index[])
public function integer of_getnextitem (readonly string as_dsname, ref str_interface_datastore astr_datastore[], ref long al_ds_index[])
end prototypes

private subroutine documentation ();/********************************************************************
   n_linkage_service: Encapsulation of master-detail related functionality
   <OBJECT> Object Description</OBJECT>
   <DESC>   Event Description</DESC>
   <USAGE>  Object Usage.</USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   Ref    Author        Comments
  00/00/07 ?      Name Here     First Version
********************************************************************/

end subroutine

public function long of_finddetail (readonly string as_dsname, readonly long al_masterindex, ref str_interface_datastore astr_datasets[]);/* Find the detail dataset given the master dataset index and the detail dataset name
and return index number */

constant string METHOD_NAME = "of_findDetail"

long 		ll_#ofDatasets, ll_index
boolean	lb_found = false

ll_#ofDatasets = upperBound(astr_datasets[al_masterindex].detail )

for ll_index = 1 to ll_#ofDatasets
	if astr_datasets[al_masterindex].detail[ll_index].ds_detail_name = as_dsName then 
		lb_found = true
		EXIT
	end if
next

if lb_found then 
	return ll_index
else
	return c#return.failure
end if
end function

public function long of_findmaster (readonly string as_dsname, ref str_interface_datastore astr_datasets[]);/* Find the master dataset and return index number */

constant string METHOD_NAME = "of_findMaster"

long 		ll_#ofDatasets, ll_index
boolean	lb_found = false

ll_#ofDatasets = upperBound(astr_datasets)

for ll_index = 1 to ll_#ofDatasets
	if astr_datasets[ll_index].ds_name = as_dsName then
		lb_found = true
		EXIT
	end if
next

if lb_found then 
	return ll_index
else
	return c#return.failure
end if

end function

public function integer of_getprocessorder (readonly string as_dsname, ref str_interface_datastore astr_datastore[], ref long al_ds_index[]);/********************************************************************
   of_getProcessOrder
   <DESC>   This function will run through the array of datasets and 
	return an array of index number in which order the datasets must
	be updated.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   as_ds_name: name of startpoint dataset if <empty> or null update all 
									datasets
	astr_datastore: Reference pointer to dataset
	al_ds_index : Reference to array of update order </ARGS>
********************************************************************/
constant string METHOD_NAME = "of_getProcessOrder"

long	ll_no_of_datasets, ll_ds_index
string	ls_string

ll_no_of_datasets = upperBound(astr_datastore)

ll_ds_index = 1
if as_dsname = "" then
	/* Find highest level (first level) */
	do while astr_datastore[ll_ds_index].master <> ""
		ll_ds_index ++
	loop
else
	/* Find dataset matching name given */
	do while astr_datastore[ll_ds_index].ds_name <> as_dsname
		ll_ds_index ++
	loop
end if	
	
//al_ds_index[upperbound(al_ds_index) +1]= ll_ds_index
of_getnextitem( astr_datastore[ll_ds_index].ds_name, astr_datastore, al_ds_index)

return c#return.success
end function

public function integer of_getprocessorder (ref str_interface_datastore astr_datastore[], ref long al_ds_index[]);constant string METHOD_NAME = "of_getProcessOrder"

return of_getProcessorder( "", astr_datastore, al_ds_index )


end function

public function integer of_getnextitem (readonly string as_dsname, ref str_interface_datastore astr_datastore[], ref long al_ds_index[]);constant string METHOD_NAME = "of_getNextItem"

long ll_dsindex, ll_datasets
long ll_rows, ll_row

ll_datasets = upperbound(astr_datastore)

/* get current item */
for ll_dsindex = 1 to ll_datasets
	if astr_datastore[ll_dsindex].ds_name = as_dsname then 
		al_ds_index[upperbound(al_ds_index) +1] = ll_dsindex
		EXIT
	end if
next

ll_rows =  upperBound(astr_datastore[ll_dsindex].detail)
for ll_row = 1 to ll_rows
	of_getNextItem(astr_datastore[ll_dsindex].detail[ll_row].ds_detail_name, astr_datastore[], al_ds_index[])
next

return 1


end function

on n_linkage_service.create
call super::create
end on

on n_linkage_service.destroy
call super::destroy
end on

