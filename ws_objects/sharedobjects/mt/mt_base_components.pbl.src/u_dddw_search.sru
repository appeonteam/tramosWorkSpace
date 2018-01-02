$PBExportHeader$u_dddw_search.sru
$PBExportComments$NVO for DDDW with search
forward
global type u_dddw_search from nonvisualobject
end type
type tpoint from structure within u_dddw_search
end type
type tmsg from structure within u_dddw_search
end type
type tmsg32 from structure within u_dddw_search
end type
end forward

type tpoint from structure
    integer x
    integer y
end type

type tmsg from structure
    unsignedinteger _hwnd
    unsignedinteger _message
    unsignedinteger _wparam
    long _lparam
    long _time
    tpoint _pt
end type

type tmsg32 from structure
	unsignedlong		_hwnd
	unsignedlong		_message
	long		_wparam
	long		_lparam
	long		_time
	long		_ptx
	long		_pty
end type

global type u_dddw_search from nonvisualobject
end type
global u_dddw_search u_dddw_search

type prototypes
FUNCTION Int PeekMessage(REF tmsg Msg, int HWnd, Int Filtermin, Int Filtermax, Int Removemsg) LIBRARY 'user.exe' alias for "PeekMessage;Ansi"
FUNCTION Long PeekMessageA(REF tmsg32 Msg, Long HWnd, Long Filtermin, Long Filtermax, Long Removemsg) LIBRARY 'user32.dll' alias for "PeekMessageA;Ansi"
end prototypes

type variables
Private mt_u_datawindow idw_datawindow
String is_field, is_dddw_field, is_searchtext
Private Boolean ib_firstupper, ib_forceeditchanged, ib_ignorecase, ib_notallowempty, _ib_dddwspecsflag, _ib_allowillegalvalue
Long il_lastrow
DatawindowChild idwc_child
private s_dddw_specs _istr_dddw_specs[]



end variables

forward prototypes
public subroutine uf_setup (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_firstupper)
public function boolean uf_editchanged ()
public function boolean uf_editchanged (boolean ab_remainlower)
public subroutine documentation ()
public function integer of_itemchanged (boolean ab_clearillegalvalue)
public function integer uf_itemchanged ()
public subroutine of_set_datawindow (datawindow adw_datawindow)
public subroutine of_register ()
public subroutine of_register (string as_field, string as_dddw_field)
public subroutine of_register (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_autosort)
public subroutine of_register (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_autosort, boolean ab_ignorecase)
public subroutine of_register (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_autosort, boolean ab_ignorecase, boolean ab_notallowempty)
public subroutine of_register (s_dddw_specs astr_dddw_specs)
private function integer _of_add_dddwspecs (s_dddw_specs astr_dddw_specs)
public function integer of_get_dddwspecs (string as_columnname)
public function integer of_get_dddwspecsindex (string as_columnname)
public function boolean of_get_dddwspecsflag ()
public subroutine of_set_dddwspecsflag (boolean ab_dddwhasspecs)
public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue)
public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue, boolean ab_notallowempty, boolean ab_ignorecase)
public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue, boolean ab_notallowempty)
public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue, boolean ab_notallowempty, boolean ab_ignorecase, boolean ab_autosort, boolean ab_sortbydesc)
end prototypes

public subroutine uf_setup (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_firstupper);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Initializes dddw_search rutines. Call this routine with the
 					datawindow given in ADW_DATAWINDOW. AS_FIELD must be the name of
					the column (datawindow drop-down) that this object should work
					on, while AS_DDDW_FIELD is the name of the datawindow child
					
					Set AB_FIRSTUPPER to true, if the search object should convert
					all letters after spaces to capitals, e.g. "search object" will
					be converted to "Search Object". Set this flag only if data is 
					stored in the database that way.

 					See the developers tips for futher information
 
 Arguments : ADW_DATAWINDOW as Datawindow
 				 AS_FIELD, AS_DDDW_FIELD as String
				 AB_FIRSTUPPER as boolean 

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
************************************************************************************/

// Store information in internal variables
idw_datawindow = adw_datawindow
is_dddw_field = as_dddw_field
is_field = as_field
ib_firstupper = ab_firstupper

// Signal an error if datawindowchild is not found
If idw_datawindow.GetChild(is_field, idwc_child)<> 1 Then 
	Beep(1)
	MessageBox("System error", "Unable to get child "+is_field)
End if

end subroutine

public function boolean uf_editchanged ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles editchanged for connected dddw, by searching in the 
 					datawindow child for matching strings

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
04/09/14	CR3519		CCY018	Move to uf_editchanged( /*boolean ab_remainlower */)
  
************************************************************************************/

return uf_editchanged(true)
end function

public function boolean uf_editchanged (boolean ab_remainlower);/********************************************************************
   uf_editchanged
   <DESC></DESC>
   <RETURN>	boolean</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_remainlower:if sets the remaining letters in each word to lowercase
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date    		CR-Ref		Author         Comments
   	04/09/14		CR3519		CCY018         copy from uf_editchanged()
   	07/09/16		CR4501		LHG008         Ignore case sensitive
   	27/03/17		CR4572		XSZ004			Replace function f_firstupper with lnv_stringfunction.of_firstupper
   </HISTORY>
********************************************************************/

String ls_data, ls_search, ls_newchar, ls_findexpr
Long ll_row, ll_search_len
tmsg32 lstr_msg32

// Check for additional keypresses. Exit if any, so the user don't have to wait for
// the function to search through the DDDW, before he/she can type the next 
// character
If PeekMessageA(lstr_msg32, 0, 256, 256, 0) > 0 Then
	If ((lstr_msg32._wparam>=48) And (lstr_msg32._wparam<=90)) Or (lstr_msg32._wparam = 8) Or (lstr_msg32._wparam = 46) Then 
		Return false //Char's pending, return without processing
	End if
End if

// Check to see if current field is "our" field
If idw_datawindow.GetColumnName() = is_field Then
	
	// It was, get the dddw child and turn redraw off
	idw_datawindow.GetChild(is_field, idwc_child)
	idw_datawindow.uf_redraw_off()

	// Get the search-text
	ls_search = idw_datawindow.GetText()
	ll_search_len = len(ls_search)
	
	// And convert string to first-char upper (eg. "Search Object"), if this feature is turned on
	if ab_remainlower then
		If ib_firstupper then 
			mt_n_stringfunctions lnv_stringfunction
			ls_search = lnv_stringfunction.of_firstupper(ls_search)
		end if
	else
		if ib_firstupper then ls_search = upper(left(ls_search, 1)) + mid(ls_search, 2, ll_search_len - 1)
	end if
	
	// Start searching if text if different from last time we searched
	If (is_searchtext <> ls_search) And (ls_search<>"") Then
		
		// If our stringvalue is lesser than last, then search from the beginning,
		// otherwise search from lastposition (il_lastrow) to improve speed
		If ls_search < is_searchtext Then il_lastrow = 0
		
		if ib_ignorecase then
			ls_findexpr = "lower(left(" + is_dddw_field + "," + string(ll_search_len) + ")) = lower('" + ls_search + "')"
			ll_row = idwc_child.find(ls_findexpr, il_lastrow, idwc_child.rowcount())
		else
			// Search for the string from il_lastrow position
			ls_findexpr = "Left(" + is_dddw_field + "," + String(ll_search_len) + ") =  '" + ls_search + "'"
			ll_row = idwc_child.Find(ls_findexpr, il_lastrow, idwc_child.RowCount())
			
			if ib_firstupper = false then
				//If is not found, the left input text Ignore case sensitive
				if ll_row = 0 then
					ls_search = lower(left(ls_search, ll_search_len - 1)) + right(ls_search, 1)
					
					ls_findexpr = "lower(left(" + is_dddw_field + ", " + string(ll_search_len - 1) + ")) + " &
								 + "mid(" + is_dddw_field + ", " + string(ll_search_len) + ", 1) = '" + ls_search + "'"
					
					ll_row = idwc_child.find(ls_findexpr, 1, idwc_child.rowcount())
				end if
				
				//If is not found, the last input character Ignore case sensitive
				if ll_row = 0 then
					ls_newchar = right(ls_search, 1)
					if asc(ls_newchar) > 64 and asc(ls_newchar) < 91 then
						ls_newchar = lower(ls_newchar)
					else
						ls_newchar = upper(ls_newchar)
					end if
					ls_search = left(ls_search, ll_search_len - 1) + ls_newchar
					ls_findexpr = "left(" + is_dddw_field + "," + string(ll_search_len) + ") = '" + ls_search + "'"
					ll_row = idwc_child.find(ls_findexpr, 1, idwc_child.rowcount())
				end if
				
				//If is not found, all character Ignore case sensitive
				if ll_row = 0 then
					ls_findexpr = "lower(left(" + is_dddw_field + "," + string(ll_search_len) + ")) = lower('" + ls_search + "')"
					ll_row = idwc_child.find(ls_findexpr, 1, idwc_child.rowcount())
				end if
			end if
		end if
		
		// If row is found, then get data from child window, and put it in the editfield
		If ll_row > 0 Then
			ls_data = idwc_child.GetItemString(ll_row, is_dddw_field)
			
			idw_datawindow.Settext(ls_data)
			
			// Mark rest of text as selected, so it will automaticly be deleted
			// if the user types more charaters into the field
			idw_datawindow.SelectText(Len(ls_data) +1 , - (len(ls_data) - ll_search_len))

			// Set lastrow to current row, so the next search will start from this
			// row. This will reduce the time used for searching
			il_lastrow = ll_row
			
			//Reset current searchtext
			ls_search = left(ls_data, ll_search_len)
		End if
	Else
		// If searchstring is empty, then set lastrow to 0, so the next search will
		// start from the beginning
		If ls_search = "" Then il_lastrow = 0
	End if

	// Remember current searchtext
	is_searchtext = ls_search

	// and turn redraw back on
	idw_datawindow.uf_redraw_on()
End if

Return true
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date    		CR-Ref		Author         Comments
		04/09/14		CR3519		CCY018         Overloaded function uf_editchanged(boolean)
		07/09/16		CR4501		LHG008         Ignore case sensitive
		10/03/17		CR4572		XSZ004			Drop-down list search-as-type case insensitive.
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_itemchanged (boolean ab_clearillegalvalue);/********************************************************************
   of_itemchanged 
   <DESC>	Handles itemchanged for dddw, by clearing the contents in the 
				edit-field, if it contains an illegal value	</DESC>
   <RETURN>	integer: the data in the field
            <LI> In the dddw list: 0
            <LI> Does not in the dddw list: 1	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_clearillegalvalue: true, If data does not in the dddw list, clear the edit-field
   </ARGS>
   <USAGE>	Call by datawindow event itemchanged()	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author  Comments
		??/??/96		?     		MIS     First Version
		07/09/16		CR4501		LHG008  Ignore case sensitive
		27/03/17		CR4572		XSZ004  Apply latest standard for dddw.	
   </HISTORY>
********************************************************************/

string ls_field, ls_text
long ll_row

// Get column name from datawindow, and start processing if it's "our" field
ls_field = idw_datawindow.getcolumnname()
if ls_field = is_field then
	
	ls_text = idw_datawindow.gettext()
	if len(ls_text) > 0 or ib_notallowempty then
		//To Handle click datawindow child header issue
		idw_datawindow.settext(ls_text)
		
		// Get datawindow child and rowno
		idw_datawindow.getchild(is_field, idwc_child)
		ll_row = idwc_child.getselectedrow(0)
		
		// If row no. is zero (item not found), then set the value to NULL. This will
		// clear the edit-field, when the user leaves the field with invalid values in it
		if ((ll_row = 0) and not _ib_allowillegalvalue) or (trim(ls_text) = "" and _ib_allowillegalvalue and ib_notallowempty ) then
			if ab_clearillegalvalue and not _ib_allowillegalvalue then idw_datawindow.settext('')
				return 1
		end if
	end if
end if

return 0

end function

public function integer uf_itemchanged ();return of_itemchanged(false)
end function

public subroutine of_set_datawindow (datawindow adw_datawindow);/********************************************************************
   of_set_datawindow
   <DESC> Set relation datawindow for this object </DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_datawindow
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		21/02/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

idw_datawindow = adw_datawindow
end subroutine

public subroutine of_register ();/********************************************************************
   of_register
   <DESC> Set stanadard for current datawindow's dddw column </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_columncount, li_index, li_cnt
string ls_columnname, ls_columntype, ls_dddw_columnname

li_index = 1
li_columncount = integer(idw_datawindow.describe("datawindow.column.count"))

for li_cnt = 1 to li_columncount
	
	ls_columnname = idw_datawindow.describe("#" + string(li_cnt) + ".name")
	ls_columntype = idw_datawindow.describe(ls_columnname + ".edit.style")
	
	if ls_columntype = "dddw" then
		ls_dddw_columnname = idw_datawindow.describe(ls_columnname + ".dddw.displaycolumn")
		this.of_register(ls_columnname, ls_dddw_columnname)
	end if
next
end subroutine

public subroutine of_register (string as_field, string as_dddw_field);/********************************************************************
   of_register
   <DESC> Set stanadard for current dddw column</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_field
		as_dddw_field
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

this.of_register(as_field, as_dddw_field, false)
end subroutine

public subroutine of_register (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_autosort);of_register(adw_datawindow, as_field, as_dddw_field, ab_autosort, true, false)

end subroutine

public subroutine of_register (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_autosort, boolean ab_ignorecase);of_register(adw_datawindow, as_field, as_dddw_field, ab_autosort, ab_ignorecase, false)
end subroutine

public subroutine of_register (ref datawindow adw_datawindow, string as_field, string as_dddw_field, boolean ab_autosort, boolean ab_ignorecase, boolean ab_notallowempty);this.of_set_datawindow(adw_datawindow)

this.of_register( as_field, as_dddw_field, false, ab_notallowempty, ab_ignorecase, ab_autosort, false)

end subroutine

public subroutine of_register (s_dddw_specs astr_dddw_specs);/************************************************************************************
 of_register
 
 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Initializes dddw_search rutines. Call this routine with the
 					datawindow given in ADW_DATAWINDOW. AS_FIELD must be the name of
					the column (datawindow drop-down) that this object should work
					on, while AS_DDDW_FIELD is the name of the datawindow child
					
					if ab_autosort = true, atuo sort the drop-down list and ignore case sensitive.
					
					if ab_ignorecase = true, ignore case sensitive when search dddw data
					
					if ab_notallowempty = true, the field cannot be empty/null
					
 					See the developers tips for futher information
 
 Arguments : ADW_DATAWINDOW as Datawindow
 				 AS_FIELD, AS_DDDW_FIELD as String
				 ab_autosort as boolean
				 ab_ignorecase as boolean
				 ab_notallowempty as boolean
				 
 Returns   : None

*************************************************************************************
Development Log 
DATE    		VERSION		NAME           DESCRIPTION
--------		-------		------         -------------------------------------
07/09/16		CR4501		LHG008         Ignore case sensitive
23/03/17		CR4572		XSZ004			Apply latest standard for dddw.
************************************************************************************/

string ls_sort

// Store information in internal variables

is_dddw_field = astr_dddw_specs.s_dddw_columnname
is_field      = astr_dddw_specs.s_columnname
ib_firstupper = false //Obsoleting
ib_ignorecase = astr_dddw_specs.b_ignorecase
ib_notallowempty      = astr_dddw_specs.b_notallowempty
_ib_allowillegalvalue = astr_dddw_specs.b_allowillegalvalue

_of_add_dddwspecs(astr_dddw_specs)

// Signal an error if datawindowchild is not found
If idw_datawindow.GetChild(is_field, idwc_child)<> 1 Then 
	Beep(1)
	MessageBox("System error", "Unable to get child "+is_field)
	return
End if

if astr_dddw_specs.b_autosort then
	ls_sort = idwc_child.describe("datawindow.table.sort")
	if len(ls_sort) = 0 or ls_sort = '?' then
		ls_sort = ''
	end if
	
	if astr_dddw_specs.b_sortbydesc then
		ls_sort += " lower(" + is_dddw_field + ") D, " + is_dddw_field + " D"	
	else
		ls_sort += " lower(" + is_dddw_field + ") A, " + is_dddw_field + " A"
	end if
	
	idwc_child.setsort(ls_sort)
	idwc_child.sort()
end if
end subroutine

private function integer _of_add_dddwspecs (s_dddw_specs astr_dddw_specs);/********************************************************************
   _of_add_dddwspecs
   <DESC> Add standard dddw items to array list </DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		int
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_index

li_index = of_get_dddwspecsindex(astr_dddw_specs.s_columnname)

if li_index < 1 then
	li_index = upperbound(_istr_dddw_specs) + 1
end if

_istr_dddw_specs[li_index] = astr_dddw_specs

return li_index
end function

public function integer of_get_dddwspecs (string as_columnname);/********************************************************************
   of_get_dddwspecs
   <DESC> Get standard dddw item from array list by column name </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_columnname
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_index, li_return

li_index = of_get_dddwspecsindex(as_columnname)

if li_index > 0 then
	
	is_searchtext = ""
	il_lastrow    = 0
	is_field      = _istr_dddw_specs[li_index].s_columnname
	is_dddw_field = _istr_dddw_specs[li_index].s_dddw_columnname
	ib_ignorecase = _istr_dddw_specs[li_index].b_ignorecase
	ib_notallowempty = _istr_dddw_specs[li_index].b_notallowempty
	_ib_allowillegalvalue = _istr_dddw_specs[li_index].b_allowillegalvalue

	li_return = c#return.success

	ib_firstupper = false 
else
	li_return = c#return.failure
end if

return li_return
end function

public function integer of_get_dddwspecsindex (string as_columnname);/********************************************************************
   of_get_dddwspecsindex
   <DESC> Get standard dddw item index from array list by column name </DESC>
   <RETURN> int </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_columnname
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

int li_index, li_count, li_cnt

li_index = 0
li_count = upperbound(_istr_dddw_specs)

for li_cnt = 1 to li_count
	if _istr_dddw_specs[li_cnt].s_columnname = as_columnname then
		li_index = li_cnt
		exit
	end if
next

return li_index
end function

public function boolean of_get_dddwspecsflag ();/********************************************************************
   of_get_dddwspecsflag
   <DESC> Get a flag for current dddw column </DESC>
   <RETURN> boolean </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

return _ib_dddwspecsflag
end function

public subroutine of_set_dddwspecsflag (boolean ab_dddwhasspecs);/********************************************************************
   of_set_dddwspecsflag
   <DESC> Set a flag for current dddw column </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_dddwhasspecs
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

_ib_dddwspecsflag = ab_dddwhasspecs
end subroutine

public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue);/********************************************************************
   of_register
   <DESC> Set stanadard for current dddw column </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_field
		as_dddw_field
		ab_autosort
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

of_register(as_field, as_dddw_field, ab_allowillegalvalue, false)

end subroutine

public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue, boolean ab_notallowempty, boolean ab_ignorecase);/********************************************************************
   of_register
   <DESC> Set stanadard for current dddw column </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_field
		as_dddw_field
		ab_autosort
		ab_ignorecase
		ab_notallowempty
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

of_register(as_field, as_dddw_field, ab_allowillegalvalue, ab_notallowempty, ab_ignorecase, true, false)

end subroutine

public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue, boolean ab_notallowempty);/********************************************************************
   of_register
   <DESC> Set specs for current dddw column </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_field
		as_dddw_field
		ab_autosort
		ab_ignorecase
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

of_register(as_field, as_dddw_field, ab_allowillegalvalue, ab_notallowempty, true)

end subroutine

public subroutine of_register (string as_field, string as_dddw_field, boolean ab_allowillegalvalue, boolean ab_notallowempty, boolean ab_ignorecase, boolean ab_autosort, boolean ab_sortbydesc);/********************************************************************
   of_register
   <DESC> Set stanadard for current dddw column </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_field
		as_dddw_field
		ab_autosort
		ab_ignorecase
		ab_notallowempty
		ab_allowillegalvalue
		ab_sortbydesc
   </ARGS>
   <USAGE>
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		17/03/17		CR4572		XSZ004		First Version
   </HISTORY>
********************************************************************/

s_dddw_specs lstr_dddw_specs

lstr_dddw_specs.s_dddw_columnname = as_dddw_field
lstr_dddw_specs.s_columnname = as_field 
lstr_dddw_specs.b_autosort   = ab_autosort
lstr_dddw_specs.b_ignorecase = ab_ignorecase
lstr_dddw_specs.b_notallowempty = ab_notallowempty
lstr_dddw_specs.b_allowillegalvalue = ab_allowillegalvalue
lstr_dddw_specs.b_sortbydesc = ab_sortbydesc

this.of_register(lstr_dddw_specs)

end subroutine

on u_dddw_search.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_dddw_search.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

