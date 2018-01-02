$PBExportHeader$n_dw_sort_service.sru
forward
global type n_dw_sort_service from mt_n_baseservice
end type
type str_sortdefinition from structure within n_dw_sort_service
end type
end forward

type str_sortdefinition from structure
	string		column_name
	boolean		sort_order
end type

global type n_dw_sort_service from mt_n_baseservice
end type
global n_dw_sort_service n_dw_sort_service

type variables
string 	is_sortcolumn
string 	is_sortorder
boolean	ib_sortbygroup,ib_newstandard
constant string	is_defaultheadersuffix = "_t"
constant string	is_defaultgroupsuffix = "_h"


end variables

forward prototypes
private function boolean of_isclientvalid (ref powerobject apo)
public subroutine documentation ()
public function integer of_headersort (ref powerobject apo, long al_row, readonly dwobject adwo_object)
public function integer of_advancedheadersort (powerobject apo, long al_row, dwobject adwo_columnheader)
private function boolean _generategroupsort (mt_u_datawindow adw_sort, ref string as_groupsort)
public function integer of_headersort (ref powerobject apo, long al_row, readonly dwobject adwo_object, string as_sortprefix, boolean abl_setselectrow)
public function integer of_advancedheadersort (powerobject apo, long al_row, dwobject adwo_columnheader, string as_sortprefix, boolean abl_setselectrow)
public function integer of_headersort (ref powerobject apo, long al_row, readonly dwobject adwo_object, ref boolean abl_setselectrow)
public function integer of_advancedheadersort (powerobject apo, long al_row, dwobject adwo_columnheader, ref boolean abl_setselectrow)
end prototypes

private function boolean of_isclientvalid (ref powerobject apo);choose case apo.typeOf()
	case 	datawindow!, datastore!, datawindowchild!
		return True
	case else
		return False
end choose

		
end function

public subroutine documentation ();/********************************************************************
   n_dw_sort_service: Object Short Description
	
	<OBJECT>
		sort column functionality for users.  allow user also to sort by multiple columns by applying additonal function when user depresses CTRL key.
	</OBJECT>
	
   <DESC>
		Event Description
	</DESC>
  	
	<USAGE>
		Implemented to work with the mt_u_datawindow ancestor object.  When using a datawindow container object on surface of a form/user object/tab check the 
		following properties:
		
		ib_columnsort 			- enable this to set the process to work.
		ib_multicolumnsort 	- enable this property to allow the user to sort with multiple columns.
		is_sortprefix 			- used to maintain fixed top level column sorting (not tested)
		
		2 functions may be used - standard original function of_headersort() and an new advanced function of_advancedheadersort() used
		to allow multiple column sorting and also to allow group header switching.
		
		on the dataobject itself text controls inside the main header control events.  if text object has suffix '_t' normal sorting is
		made on column with same prefix.  Any text objects having suffix '_h' are expecting multiple header groups for each occurance
		
		Simple sorting without groupings
		================================
		within the mt_u_datawindow container normal cases set the ib_columntitlesort & ib_multicolumnsort properties to enabled.
		for every column you want to enable sorting on name the header with the following rule:  they ,ust have the same name as the column + suffix '_t'
		so eg. 'vessel_nr_t', 'vesseltype_t', 'fileid_t' etc
		It is possible to add a prefix to the sort string if it is fixed.  This only works with this option.
		
		Simple Group Control
		====================
		create as many header groups as you need.  It is better to use only header type text controls and not mix with normal text _t
		controls.
		for each header group create a computed field.  name it compute_header_01, compute_header_02 etc.
		inside each expression reference the column name you want to sort with.	ie compute_header_01 expression might be 'vessel_nr'
		make sure within the dataobject the sort string matches. ie: 'vessel_nr A voyage_nr A' etc
		lastly add text controls for each group and name them using the following rule:  they must be the same name as the column + suffix "_h"
		so for example the first could be: 'vessel_nr_h'
		
	</USAGE>
   
	<ALSO>
		TODO: Apply header group functionality also.	
	</ALSO>
		Date    		Ref   	    Author   	    Comments
		00/00/07		?      	    Name Here	First Version
		13/09/11		2574  	AGL      	    multi sort mechanism
		14/10/24		      	     KSH092    	add function of_headersort( /*ref powerobject apo*/, /*long al_row*/, /*readonly dwobject adwo_object*/, /*ref boolean abl_setselectrow */)
		25/11/15		CR4161	XSZ004    	Fix a bug.
		06/04/17     CR4557   EPE080       changed dddw\ddlb\codetable column to sort by the displayed values
	<LIMITATIONS>  
		Need to validate quick implementation of fixed column sorting.
	</LIMITATIONS>  	  
********************************************************************/

end subroutine

public function integer of_headersort (ref powerobject apo, long al_row, readonly dwobject adwo_object);return of_headersort( apo, al_row, adwo_object, "",false)
end function

public function integer of_advancedheadersort (powerobject apo, long al_row, dwobject adwo_columnheader);return of_advancedheadersort( apo, al_row, adwo_columnheader, "",false )
end function

private function boolean _generategroupsort (mt_u_datawindow adw_sort, ref string as_groupsort);/********************************************************************
   _generategroupsort
   <DESC>	if group by exists,	use group by as first priority to sort the column</DESC>
   <RETURN>	boolean:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_sort: sort datawindow,
		as_groupsort: group sort string 
   </ARGS>
   <USAGE>	of_headersort	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	06-12-2011 ?               LHC010        	 First Version
   </HISTORY>
********************************************************************/
long  ll_grouppos, ll_pos1, ll_pos2
string ls_syntax, ls_groupstring = "group(level="
string ls_sortstring
boolean lb_return

ls_syntax = adw_sort.object.datawindow.syntax
//find first group
ll_grouppos = pos(ls_syntax, ls_groupstring, 1)

lb_return = ll_grouppos > 0

// Build the group by to sort string.
do while ll_grouppos > 0
	ll_pos1 = pos(ls_syntax, "by=(", ll_grouppos)
	ll_pos2 = pos(ls_syntax, ')', ll_pos1)

	ls_sortstring = mid(ls_syntax, ll_pos1 + 4, ll_pos2 - ll_pos1 - 4)
	ls_sortstring = trim(f_replaceall(ls_sortstring, '"', ''))
	ls_sortstring = f_replaceall(ls_sortstring, " ", " A,")
	
	if len(as_groupsort) > 0 then as_groupsort = as_groupsort + ","
	as_groupsort = as_groupsort + ls_sortstring + " A"
	//find next group
	ll_grouppos = pos(ls_syntax, ls_groupstring, ll_pos2)
loop

return lb_return
end function

public function integer of_headersort (ref powerobject apo, long al_row, readonly dwobject adwo_object, string as_sortprefix, boolean abl_setselectrow);/********************************************************************
   of_multiheadersort()
   <DESC>	
		Normal single column functionality, no different to previous version.	
	</DESC>
   <RETURN>
		Integer:
			<LI> 1, X ok
			<LI> -1, X failed
	</RETURN
    <ACCESS> Public </ACCESS>
   <ARGS>
		apo: needs to be of type mt_u_datawindow
		al_row: not used
		adwo_columnheader: The data object control reference
   </ARGS>
   <USAGE>	
		called by the MT framework directly inside the mt_u_datawindow object. Only accessed if boolean
		property is enabled.
	</USAGE>
   <HISTORY>
		Date           CR-Ref          Author           Comments
		06/04/17     CR4557        EPE080           change Drop-down lists  sorted by the displayed values
   </HISTORY>
********************************************************************/

string		ls_headername
string 	ls_colname, ls_edittype, ls_editcodetable
integer	li_suffixlen
integer	li_headerlen
string		ls_sortstring, ls_groupsort
long    	ll_rowid, ll_row, ll_selectedrow

mt_u_datawindow ldw

/* validate sort column request */
if not of_isclientvalid( apo ) then return c#return.noAction

ldw = create mt_u_datawindow
ldw = apo

if isnull(adwo_object) or not isvalid(adwo_object) then
	return c#return.Failure
end if 

if adwo_object.Name = 'datawindow' then return c#return.noAction
if adwo_object.Band <> "header" then return c#return.noAction

ls_headername = adwo_object.Name
li_headerlen = len(ls_headername)
li_suffixlen = len(is_defaultheadersuffix)

/* extract the columname from the header label (by taking out the header suffix). */
if right(ls_headername, li_suffixlen) <> is_defaultheadersuffix then 
	// Cannot determine the column name from the header.	
	li_suffixlen = len(is_defaultgroupsuffix)	
	if right(ls_headername, li_suffixlen) <> is_defaultgroupsuffix then 
		return c#return.failure
	else
		/* we have group headers to manage, send to the supporting function */
		return of_advancedheadersort( apo, al_row, adwo_object, as_sortprefix,abl_setselectrow )
	end if
	
end if 	
ls_colname = Left (ls_headername, li_headerlen - li_suffixlen)

if IsNull(ls_colname) or Len(Trim(ls_colname))=0 then 
	return c#return.failure
end if

/* Check the previous sort click. */
if trim(upper(is_sortcolumn)) = trim(upper(ls_colname)) then
	/* second sort click on the same column, reverse sort order. */
	if trim(upper(is_sortorder)) = "A" then
		is_sortorder = "D"
	else
		is_sortorder = "A"
	end if 
else
	/* clicked on a different column. */
	is_sortcolumn = trim(upper(ls_colname))
	is_sortorder = " A" 
end if

/* build the sort string & perform sort */
/*dddw ddlb edit style order by display value*/
ls_edittype = lower(ldw.Describe(is_sortcolumn + ".Edit.Style"))
ls_editcodetable = lower(ldw.Describe(is_sortcolumn + ".Edit.Codetable"))
if ls_edittype = 'dddw' or ls_edittype = 'ddlb' or (ls_edittype = 'edit' and ls_editcodetable = 'yes') then
	ls_sortstring = "LookUpDisplay(" + is_sortcolumn + ") " + is_sortorder + " "
else
	ls_sortstring = is_sortcolumn + " " + is_sortorder + " "
end if

if ib_sortbygroup then
	/*if exists group by, use group by as first priority to sort the column */
	if _generategroupsort(ldw,ls_groupsort) then
		ls_sortstring = ls_groupsort + "," + ls_sortstring	
	end if
end if

ll_rowid = ldw.GetRowIdFromRow(ldw.getrow())
ll_selectedrow = ldw.getselectedrow(0)

ldw.setsort(ls_sortstring)
ldw.sort()
ldw.groupcalc()

if ib_newstandard = true then
	ll_row = ldw.GetRowFromRowId(ll_rowid)
	if ll_row > 0 then
		ldw.scrolltorow(ll_row)
	end if
else
	if (abl_setselectrow = true and ll_selectedrow > 0)  then
		ll_row = ldw.GetRowFromRowId(ll_rowid)
		if ll_row > 0 then
			ldw.setredraw(false)
			ldw.selectrow(0, false)
			ldw.scrolltorow(ll_row)
			ldw.selectrow(ll_row, true)
			ldw.setredraw(true)
		end if
	end if	
end if
return c#return.success

end function

public function integer of_advancedheadersort (powerobject apo, long al_row, dwobject adwo_columnheader, string as_sortprefix, boolean abl_setselectrow);/********************************************************************
   of_multiheadersort()
   <DESC>	Description	</DESC>
   <RETURN>
		Integer:
			<LI> 1, X ok
			<LI> -1, X failed
	</RETURN
    <ACCESS> Public </ACCESS>
   <ARGS>
		apo: needs to be of type mt_u_datawindow
		al_row: not used
		adwo_columnheader: The data object control reference
   </ARGS>
   <USAGE>	
		Designed to be called from the framework when the user depresses the CTRL button.
		Not restricted to this CTRL key, but untested elsewhere. 
		In the case of the mt_u_datawindow object only accessed when:
			* boolean properties ib_columntitlesort & ib_multicolumnsort are enabled
			* if the datawindow object has group headers that need to be processed.
	</USAGE>
   <HISTORY>
		Date           CR-Ref          Author           Comments
		06/04/17     CR4557        EPE080           changed dddw\ddlb\codetable column to sort by the displayed values
   </HISTORY>
********************************************************************/

string						ls_headername
string 					ls_colname, ls_edittype, ls_editcodetable
string 					ls_express
integer					li_suffixlen
integer					li_headerlen
string						ls_sortstring
string						ls_groupheaderprefix = "compute_header_"
boolean 					lb_found = false
boolean					lb_groupheader = false, lb_changegroup
mt_u_datawindow  	ldw
string 					ls_seperator = " "
string 					ls_columnname
integer					li_increment=1
integer 					li_columnindex=0, li_charindex, li_colnameindex, li_sortorderindex, li_fixed, li_headerindex
str_sortdefinition		lstr_def[], lstr_dummydef[], lstr_tempdef[]
long              		    ll_rowid, ll_row, ll_selectedrow
mt_n_stringfunctions	lnv_strfunc

/* validation section */
if not of_isClientValid( apo ) then return c#return.noAction
ldw = create mt_u_datawindow
ldw = apo
if isnull(adwo_columnheader) or not IsValid(adwo_columnheader) then
	return c#return.Failure
end if
if adwo_columnheader.Name = 'datawindow' then Return c#return.noAction
if adwo_columnheader.Band <> "header" then Return c#return.noAction

ls_headername = adwo_columnheader.name
li_headerlen = len(ls_headername)
li_suffixlen = len(is_defaultheadersuffix)

if right(ls_headername, li_suffixlen) <> is_defaultheadersuffix then 
	li_suffixlen = len(is_defaultgroupsuffix)	
	if right(ls_headername, li_suffixlen) <> is_defaultgroupsuffix then 
		return c#return.failure
	else
		lb_groupheader = true
	end if
end if 	
ls_colname = left(ls_headername, li_headerlen - li_suffixlen)

if isnull(ls_colname) or len(trim(ls_colname)) = 0 then 
	return c#return.Failure
end if

/* next obtain current sort definition and load into array */
ls_sortstring = ldw.Describe("Datawindow.Table.sort")

ls_sortstring = trim(lnv_strfunc.of_replace( ls_sortstring, ",", " "))

li_columnindex=0
for li_charindex=0 to len(ls_sortstring )
	li_columnindex++
	ls_columnname=""
	for li_colnameindex = li_charindex + 1 to len(ls_sortstring)
		if mid(ls_sortstring,li_colnameindex,1) = ls_seperator and ls_columnname<>"" then
			//remove "LookUpDisplay()" in sort string		
			if pos(ls_columnname,"LookUpDisplay(") > 0 then
				ls_columnname = mid(ls_columnname,15,len(ls_columnname) - 15)
			end if
			lstr_def[li_columnindex].column_name=ls_columnname	
			li_charindex=li_colnameindex
			exit
		else
			ls_columnname+=mid(ls_sortstring,li_colnameindex,1)
		end if	
	next
	for li_sortorderindex = li_charindex to len(ls_sortstring)
		if mid(ls_sortstring,li_sortorderindex,1)<>ls_seperator then
			if upper(mid(ls_sortstring,li_sortorderindex,1))="A" then
				lstr_def[li_columnindex].sort_order=true
				li_charindex=li_sortorderindex
				exit
			else
				lstr_def[li_columnindex].sort_order=false
			end if
			li_charindex=li_sortorderindex
			exit
		end if
	next
next

if lb_groupheader then
	/* group definition */
	lstr_tempdef[1].column_name = ls_colname
	for li_columnindex = 1 to upperbound( lstr_def )
		if lower(lstr_def[li_columnindex].column_name) <> lower(ls_colname) then 
			lstr_tempdef[li_columnindex+li_increment].column_name = lstr_def[li_columnindex].column_name
			lstr_tempdef[li_columnindex+li_increment].sort_order = lstr_def[li_columnindex].sort_order
		else
			li_increment=0
			if li_columnindex = 1 then
				lstr_tempdef[1].sort_order = not(lstr_def[1].sort_order)
				lb_changegroup=false
			else
				lstr_tempdef[1].sort_order = lstr_def[li_columnindex].sort_order
				lb_changegroup=true
			end if	
		end if
	next	
	lstr_def = lstr_dummydef
	lstr_def = lstr_tempdef
	lstr_tempdef = lstr_dummydef
	
	if lb_changegroup then
		for li_headerindex = 1 to upperbound(lstr_def) 
			ls_express = ls_groupheaderprefix + string(li_headerindex,"00") + ".Type"
			if ldw.describe(ls_express)="!" then exit
			ls_express = ls_groupheaderprefix + string(li_headerindex,"00") + ".Expression='string(" + lstr_def[li_headerindex].column_name + ")'"
			ldw.modify(ls_express)		
		next
	end if
	lb_found = true
else	
	/* search current column in existing sort definition */	
	for li_columnindex = 1 to upperbound( lstr_def )
		if lower(lstr_def[li_columnindex].column_name) = lower(ls_colname) then 
			lstr_def[li_columnindex].sort_order = not(lstr_def[li_columnindex].sort_order)
			lb_found = true
			exit
		end if
	next	
end if

if lb_found=false then
	li_columnindex = upperbound(lstr_def) + 1
	lstr_def[li_columnindex].column_name = ls_colname
	lstr_def[li_columnindex].sort_order = true
end if

/* built sort string */
ls_sortstring=""
for li_columnindex = 1 to upperbound(lstr_def)
	/* ddlb dddw column sort by display */
	ls_edittype = lower(ldw.Describe(lstr_def[li_columnindex].column_name + ".Edit.Style"))
	ls_editcodetable = lower(ldw.Describe(is_sortcolumn + ".Edit.Codetable"))
	if ls_edittype = 'dddw' or ls_edittype = 'ddlb' or (ls_edittype = 'edit' and ls_editcodetable = 'yes') then
		ls_sortstring += 'LookUpDisplay(' + lstr_def[li_columnindex].column_name + ") " 
	else
		ls_sortstring += lstr_def[li_columnindex].column_name
	end if
	
	if lstr_def[li_columnindex].sort_order then
		ls_sortstring += " A "
	else
		ls_sortstring += " D "
	end if
next

/* perform actual sort */
ll_rowid = ldw.GetRowIdFromRow(ldw.getrow())
ll_selectedrow = ldw.getselectedrow(0)

ldw.setsort(as_sortprefix + ls_sortstring)
ldw.sort()
ldw.groupcalc()


if abl_setselectrow = true and ll_selectedrow > 0 then
   ll_row = ldw.GetRowFromRowId(ll_rowid)
   if ll_row > 0 then
	   ldw.setredraw(false)
      ldw.selectrow(0, false)
      ldw.scrolltorow(ll_row)
      ldw.selectrow(ll_row, true)
	   ldw.setredraw(true)
	end if
end if	
return c#return.Success
end function

public function integer of_headersort (ref powerobject apo, long al_row, readonly dwobject adwo_object, ref boolean abl_setselectrow);return of_headersort( apo,al_row, adwo_object, "",abl_setselectrow)
end function

public function integer of_advancedheadersort (powerobject apo, long al_row, dwobject adwo_columnheader, ref boolean abl_setselectrow);return of_advancedheadersort( apo, al_row, adwo_columnheader, "",abl_setselectrow )
end function

on n_dw_sort_service.create
call super::create
end on

on n_dw_sort_service.destroy
call super::destroy
end on

event constructor;call super::constructor;this.#pooled=true

end event

