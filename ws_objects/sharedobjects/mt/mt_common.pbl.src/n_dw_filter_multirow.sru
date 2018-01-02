$PBExportHeader$n_dw_filter_multirow.sru
forward
global type n_dw_filter_multirow from mt_n_nonvisualobject
end type
end forward

global type n_dw_filter_multirow from mt_n_nonvisualobject
end type
global n_dw_filter_multirow n_dw_filter_multirow

type variables
private :
s_filter_multirow		_istr_multirow   	//Save registration information of s_filter_multirow
string 					_is_filter			//Filter condition
boolean 					_ib_isnull			//Whether to include a null item
constant string 		_is_NULL = "null" 


end variables

forward prototypes
public function string of_getfilter ()
public subroutine of_register (s_filter_multirow astr_multirow)
protected subroutine __generatefilter ()
protected subroutine __filtercascade ()
protected function boolean __getincludenull ()
private function string _getitemvalue (long al_row)
public subroutine documentation ()
public subroutine of_dofilter ()
public function integer of_getfiltertoarray (ref integer ai_array[])
public function integer of_getfiltertoarray (ref string as_array[])
end prototypes

public function string of_getfilter ();/********************************************************************
   of_getfilter
   <DESC>	Get report filter condition </DESC>
   <RETURN>	string: report filter condition</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17-08-2011 ?            LHC010        		 First Version
   </HISTORY>
********************************************************************/
string ls_filter

if len(_is_filter) > 0 then 
	ls_filter = _istr_multirow.report_column_name + _is_filter
	//if current filter DW include_null = true then add "isnull" to filter condition.
	if _ib_isnull then ls_filter = "(isnull(" + _istr_multirow.report_column_name + ") or " + ls_filter + ")"
else
	//if current filter DW include_null = true then add "isnull" to filter condition.
	if _ib_isnull then ls_filter = "isnull(" + _istr_multirow.report_column_name + ")"
end if

return ls_filter
end function

public subroutine of_register (s_filter_multirow astr_multirow);/********************************************************************
   of_register
   <DESC>	Save registration information	</DESC>
   <RETURN>	(None):	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_multirow
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17-08-2011 ?            LHC010        		 First Version
   </HISTORY>
********************************************************************/

_istr_multirow = astr_multirow
end subroutine

protected subroutine __generatefilter ();/********************************************************************
   __generatefilter
   <DESC>	Generate the filter condition </DESC>
   <RETURN>	(none)	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-08-2011 2438         JMY014             First Version
   </HISTORY>
********************************************************************/
long		ll_found
string	ls_value
string	ls_filter

_ib_isnull = false

ll_found = _istr_multirow.self_dw.getselectedrow(0)

do while ll_found > 0
	ls_value = _getitemvalue(ll_found)
	
	//if get item value is null and filter DW include_null = true, then allow adding "isnull" to filter condition  
	if ls_value = _is_NULL and _istr_multirow.include_null then _ib_isnull = true
	
	if len(ls_value) > 0 and ls_value <> _is_NULL then ls_filter += ls_value + ","
	
	ll_found = _istr_multirow.self_dw.getselectedrow(ll_found)
loop

//Cut off the last comma
if lastpos(ls_filter, ",") > 0 then	
	ls_filter = left(ls_filter, len(ls_filter) - 1)
	ls_filter = " in (" + ls_filter + ")"
end if

_is_filter = ls_filter
end subroutine

protected subroutine __filtercascade ();/********************************************************************
   __filtercascade
   <DESC>	Filter the content in the cascading datawindow </DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-08-2011 2438         JMY014             First Version
   </HISTORY>
********************************************************************/
constant string ls_FILTERALL = "1 = 2" //Filter out all data in the next-level cascading datawindow
string   ls_filter, ls_colname
integer	li_index,  li_detailcount
u_datagrid	ldw_multirow

if len(_is_filter) > 0 then //Filter next cascade datawindow filter
	ls_filter = _is_filter
else
	ls_filter =  ls_FILTERALL //Filter out all next cascade datawindow fitler
end if

li_detailcount = upperbound(_istr_multirow.cascade_dw)

for li_index = 1 to li_detailcount
	ldw_multirow = _istr_multirow.cascade_dw[li_index]
	
	//Generate filter condition
	if ls_filter <> ls_FILTERALL then ls_filter = _istr_multirow.cascade_column_name[li_index] + ls_filter
	
	//If subclass include_null = true and all are deselected, add "isnull" to filter condition
	if isvalid(ldw_multirow.inv_filter_multirow) then
		if ldw_multirow.inv_filter_multirow.__getincludenull() and ls_filter <> ls_FILTERALL then 
			ls_filter = " isnull(" + _istr_multirow.cascade_column_name[li_index] + ") or " + ls_filter
		end if
	end if
	
	ldw_multirow.setfilter(ls_filter)
	ldw_multirow.setredraw(false)
	ldw_multirow.filter()
	//Subclass of the recursive call
	if isvalid(ldw_multirow.inv_filter_multirow) then
		ldw_multirow.inv_filter_multirow.__generatefilter()
		ldw_multirow.inv_filter_multirow.__filtercascade()
	end if
	ldw_multirow.setredraw(true)
next

end subroutine

protected function boolean __getincludenull ();/********************************************************************
   __getincludenull
   <DESC>	Description	</DESC>
   <RETURN>	boolean</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	18-08-2011 ?            LHC010        First Version
   </HISTORY>
********************************************************************/
return _istr_multirow.include_null
end function

private function string _getitemvalue (long al_row);/********************************************************************
   _getitemvalue
   <DESC>Get the item value automatically according to column name</DESC>
   <RETURN>	string:Value of item	or "null"</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE>	n/a </USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-08-2011 ?            JMY014        		 First Version
		17-08-2011 ?				LHC010				 Fix char value add quotation.
   </HISTORY>
********************************************************************/

string	ls_objtype, ls_coltype, ls_value, ls_colname
u_datagrid	ldw_self

ls_colname = _istr_multirow.self_column_name

ldw_self = _istr_multirow.self_dw

if al_row <= 0 or al_row > ldw_self.rowcount() then return ""
if isnull(ls_colname) or trim(ls_colname) = "" then return ""

ls_objtype = ldw_self.describe(ls_colname + ".type")
if lower(ls_objtype) <> "column" and lower(ls_objtype) <> "compute" then return ""

ls_coltype = ldw_self.describe(ls_colname + ".coltype")

choose case lower(left(ls_coltype, 5))
	case "char", "char("
		ls_value = "'" + ldw_self.getitemstring(al_row, ls_colname) + "'"
	case "int", "long", "ulong", left("number", 5), "real"
		ls_value = string(ldw_self.getitemnumber(al_row, ls_colname))
	case left("decimal", 5)
		ls_value = string(ldw_self.getitemdecimal(al_row, ls_colname))
	case "date"
		ls_value = string(ldw_self.getitemdate(al_row, ls_colname))
	case "time", "times"
		ls_value = string(ldw_self.getitemtime(al_row, ls_colname))
	case left("datetime", 5)
		ls_value = string(ldw_self.getitemdatetime(al_row, ls_colname))
end choose

//if include_null = true and get the item value is null, then return "null"
if _istr_multirow.include_null and (len(ls_value) <= 0 or isnull(ls_value)) then
	ls_value = _is_NULL
end if

return ls_value
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_dw_filter_multirow
   <OBJECT> Multi row filter for report and cascade datawindow </OBJECT>
   <DESC>   </DESC>
   <USAGE>  u_datagrid </USAGE>
   <ALSO>  s_filter_multirow  </ALSO>
    Date   Ref    Author        Comments
  18/08/11 ?      LHC010     	  First Version
  24/10/16	CR4501	HXH010	Add function of_getfiltertoarray()	
********************************************************************/

end subroutine

public subroutine of_dofilter ();//Generate filter condition
__generatefilter()

//Deal with casecade filter
__filtercascade()
end subroutine

public function integer of_getfiltertoarray (ref integer ai_array[]);/********************************************************************
   of_getfiltertoarray
   <DESC>	Get report filter condition </DESC>
   <RETURN>	string: report filter condition</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ref ai_array[]
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24/10/16		CR4501		HXH010		First Version
   </HISTORY>
********************************************************************/
string ls_temp_filter,	ls_filter
mt_n_stringfunctions lnv_str_func

ls_temp_filter = _is_filter 
ls_filter = lnv_str_func.of_get_token(ls_temp_filter, "(")
ls_filter = lnv_str_func.of_get_token(ls_temp_filter, ")")

lnv_str_func.of_parsetoarray(ls_filter, ",", ai_array)

return 1
end function

public function integer of_getfiltertoarray (ref string as_array[]);/********************************************************************
   of_getfiltertoarray
   <DESC>	Get report filter condition </DESC>
   <RETURN>	string: report filter condition</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ref as_array[]
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24/10/16		CR4501		HXH010		First Version
   </HISTORY>
********************************************************************/
string ls_temp_filter,	ls_filter
mt_n_stringfunctions lnv_str_func

ls_temp_filter = _is_filter
ls_filter = lnv_str_func.of_get_token(ls_temp_filter, "(")
ls_filter = lnv_str_func.of_get_token(ls_temp_filter, ")")

lnv_str_func.of_parsetoarray(ls_filter, ",", as_array)

return 1
end function

on n_dw_filter_multirow.create
call super::create
end on

on n_dw_filter_multirow.destroy
call super::destroy
end on

