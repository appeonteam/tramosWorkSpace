$PBExportHeader$mt_n_dddw_includecurrentvalue.sru
forward
global type mt_n_dddw_includecurrentvalue from mt_n_nonvisualobject
end type
end forward

global type mt_n_dddw_includecurrentvalue from mt_n_nonvisualobject autoinstantiate
end type

type variables
private:
datawindow	_idw_requestor[]
string		_is_colname[]
string		_is_filterexp[]
long			_ii_dddwcount

end variables

forward prototypes
public subroutine documentation ()
public subroutine of_includecurrentvalue (datawindow adw_requestor)
public function integer of_registerdddw (datawindow adw_requestor, string as_colname, string as_filterexp)
protected function string __generatefilterexp (integer as_index)
protected function integer __isregistered (datawindow as_requestor, string as_colname)
end prototypes

public subroutine documentation ();/********************************************************************
   mt_n_dddw_includecurrentvalue
   <OBJECT>
		The object is use to show the current data in dropdown even the data cannot be use now.
		The object is autoinstantiated.
	</OBJECT>
   <USAGE>
		1. Declare the object as an instance variable.
		2. In the open event call the of_registerdddw function to register dropdown datawindow.
		3. In the datawindow retrievestart event, set datawindow redraw off.
		4. In the datawindow retrieveend event, call the of_includecurrentvalue function and set datawindow redraw on.
	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	21/02/2014 CR3240AUT    LHG008        First Version
   </HISTORY>
********************************************************************/
end subroutine

public subroutine of_includecurrentvalue (datawindow adw_requestor);/********************************************************************
   of_includecurrentvalue
   <DESC>	Hide all the not-matched rows except the value equal to current value.	</DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_requestor:	master datawindow
   </ARGS>
   <USAGE>	Call in datawindow retrieveend event.
				ref: w_vessel.tab_1.tabpage_1.dw_1.event retrieveend()
					  mt_u_datawindow.event retrieveend()
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		20/02/2014	CR3240UAT	LHG008	First Version
   </HISTORY>
********************************************************************/

string	ls_filterexp
integer	li_index

datawindowchild	ldwc_child

for li_index = 1 to _ii_dddwcount
	if adw_requestor <> _idw_requestor[li_index] then continue
	
	if _idw_requestor[li_index].getchild(_is_colname[li_index], ldwc_child) <> 1 then continue
	
	//Reset data
	ldwc_child.setfilter('')
	ldwc_child.filter()
	
	if ldwc_child.rowcount() > 0 then
		//Generate filtering expression that it will include the current value of all the rows in the master datawindow.
		ls_filterexp = __generatefilterexp(li_index)
		
		ldwc_child.setfilter(ls_filterexp)
		ldwc_child.filter()
	end if
next
end subroutine

public function integer of_registerdddw (datawindow adw_requestor, string as_colname, string as_filterexp);/********************************************************************
   of_registerdddw
   <DESC>	The function is used to register dropdown datawindow	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_requestor:	master datawindow
		as_colname:		master datawindow column name for the dddw.
		as_filterexp:	a string whose value is a boolean expression that you want to use as the filter criterion.  
							The expression will find the data which you want to show in the dropdown.
   </ARGS>
   <USAGE>	Call in window open event.	
				ref: w_vessel.event open()
					  mt_u_datawindow.of_registerdddw()
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		21/02/2014	CR3240UAT	LHG008	First Version
   </HISTORY>
********************************************************************/

datawindowchild	ldwc_child

// Check requirements.
if isnull(as_colname) or trim(as_colname) = '' then return c#return.Failure
if adw_requestor.describe(as_colname + ".edit.style") <> "dddw" then return c#return.Failure

//If the dropdown datawindow already registered then return success
if __isregistered(adw_requestor, as_colname) > 0 then return c#return.Success

if adw_requestor.getchild(as_colname, ldwc_child) = 1 then
	//Check if provided expression is correct.
	if ldwc_child.find(as_filterexp, 1, 1) < 0 then
		beep(1)
		messagebox("Register dddw failed", "Expression is not valid.~n~n" + adw_requestor.classname() + "." + as_colname)
		return c#return.Failure
	end if
	
	_ii_dddwcount = upperbound(_idw_requestor) + 1
	
	_idw_requestor[_ii_dddwcount] = adw_requestor
	_is_colname[_ii_dddwcount] = as_colname
	_is_filterexp[_ii_dddwcount] = as_filterexp
	
	return c#return.Success
end if

return c#return.Failure
end function

protected function string __generatefilterexp (integer as_index);/********************************************************************
   __generatefilterexp
   <DESC>	Generate filtering expression	</DESC>
   <RETURN>	string:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
		as_index
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		25/02/2014	CR3240UAT	LHG008	First Version
   </HISTORY>
********************************************************************/

string	ls_dddw_datacolumn, ls_coltype, ls_value, ls_filterexp
long		ll_row

//Get data column name
ls_dddw_datacolumn = _idw_requestor[as_index].describe(_is_colname[as_index] + ".dddw.datacolumn")

ls_coltype = lower(left(_idw_requestor[as_index].describe(_is_colname[as_index] + ".coltype"), 5))

//Generate filtering expression for the current value of all the rows.
for ll_row = 1 to _idw_requestor[as_index].rowcount()
	choose case ls_coltype
		case 'char('
			ls_value = _idw_requestor[as_index].getitemstring(ll_row, _is_colname[as_index])
			if not isnull(ls_value) and len(trim(ls_value)) > 0 then ls_filterexp += " or " + ls_dddw_datacolumn + " = '" + ls_value + "'"
		case 'numbe', 'real', 'long', 'ulong', 'int'
			ls_value = string(_idw_requestor[as_index].getitemnumber(ll_row, _is_colname[as_index]))
			if not isnull(ls_value) then ls_filterexp += " or " + ls_dddw_datacolumn + " = '" + ls_value
		case else
			ls_filterexp += ''
	end choose
next

ls_filterexp = '(' + _is_filterexp[as_index] + ')' + ls_filterexp

return ls_filterexp
end function

protected function integer __isregistered (datawindow as_requestor, string as_colname);/********************************************************************
   __isregistered
   <DESC>	Check whether it is registered or not	</DESC>
   <RETURN>	integer:
            <LI> 0,	not registered
            <LI> >0,	have registered, return the index
	</RETURN>
   <ACCESS> protected </ACCESS>
   <ARGS>
		as_requestor:
		as_colname:
   </ARGS>
   <USAGE>	Call in of_registerdddw(), of_includecurrentvalue()	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author	Comments
		20/02/2014	CR3240UAT	LHG008	First Version
   </HISTORY>
********************************************************************/

integer li_index

for li_index = 1 to _ii_dddwcount
	if _idw_requestor[li_index] = as_requestor and _is_colname[li_index] = as_colname then
		return li_index
	end if
next

return 0
end function

on mt_n_dddw_includecurrentvalue.create
call super::create
end on

on mt_n_dddw_includecurrentvalue.destroy
call super::destroy
end on

