$PBExportHeader$n_sequence_service.sru
forward
global type n_sequence_service from mt_n_baseservice
end type
end forward

global type n_sequence_service from mt_n_baseservice
end type
global n_sequence_service n_sequence_service

forward prototypes
public function integer of_setsequence (ref powerobject apo_object, string as_colname, long al_row, long al_newseq)
public subroutine documentation ()
end prototypes

public function integer of_setsequence (ref powerobject apo_object, string as_colname, long al_row, long al_newseq);/********************************************************************
   of_setsequence()
   <DESC>	Set/adjust order for a column in Datawindow/datastore	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		apo_object: Datawidow/datastorer
		as_colname:  
		al_row	 :	Current row
		al_newseq : New order
   </ARGS>
   <USAGE>	Delete or edit a sequence numebr. Suggest starting from 1, and then sequence number will be uninterrupted order base on 1.
		For instance：Sequence number 1,2,3,4,5,6
			1) If 2 is changed to 5，then sequence number will be changed as：3->2, 4->3, 5->4, 2->5, remaining keeps unchanged.
			2) If 5 is changed to 2，then sequence number will be changed as：5->2, 2->3, 3->4, 4->5, remaining keeps unchanged.
			3) If 2 is changed to null，then sequence number will be changed as：2->null, 3->2, 4->3, 5->4, 6->5.
		Reference code：
			event: w_changerequest.dw_list.itemchanged()
			function: n_creq_request._setsequence()
	</USAGE>
	<LIMITATION>
		1.The minimum order can be set to 1 and the maximum can be set to the largest number of current order.
		2.Cannot use this function to add sequence number.Namely, cannot process the data if original value is null.
	</LIMITATION>
   <HISTORY>
   	Date       CR-Ref       Author            Comments
   	01-17-2013 2614   	   LHG008        		First Version
   	07/05/2014 CR3689       LHG008        		1. If rowcont = 1 do not return.
																2. Performance optimization.
   </HISTORY>
********************************************************************/

datawindow	ldw_current
datastore	lds_current
dwobject ldwo_object

long ll_seq[], ll_oldseq, ll_maxseq, ll_rowcount, ll_targetrow, ll_find
string ls_oldsort, ls_newsort
boolean lb_ascsort, lb_setredraw

//If object is not datawindow or datastore then return
choose case typeof(apo_object)
	case datawindow!		
		lb_setredraw = true
		ldw_current = apo_object
		ldwo_object = ldw_current.object.__get_attribute(as_colname, false)
	case datastore!
		lds_current = apo_object
		ldwo_object = lds_current.object.__get_attribute(as_colname, false)
	case else
		return c#return.Failure
end choose

ll_rowcount = apo_object.dynamic rowcount()

//If no rows then return
if ll_rowcount < 1 then return c#return.Success

if isnull(al_row) or al_row < 1 or al_row > ll_rowcount then return c#return.Failure

ll_oldseq = apo_object.dynamic getitemnumber(al_row, as_colname)
if isnull(ll_oldseq) then return c#return.Failure

if lb_setredraw then apo_object.dynamic setredraw(false)

//Check if the colulmn is sorted
ls_oldsort = upper(apo_object.dynamic describe("DataWindow.Table.Sort"))
ls_newsort = upper(as_colname + ' A')

if left(ls_oldsort, len(ls_newsort)) = ls_newsort then
	lb_ascsort = true
elseif left(ls_oldsort, len(as_colname + ' D')) = upper(as_colname + ' D') then
	lb_ascsort = false
else //If it is not sorted by this column then sort in ASC order
	apo_object.dynamic setitem(al_row, as_colname, ll_oldseq)
	apo_object.dynamic setsort(ls_newsort)
	apo_object.dynamic sort()
	lb_ascsort = true
	al_row = apo_object.dynamic find(as_colname + ' = ' + string(ll_oldseq), 1, ll_rowcount)
	
	//Reset to original sorting after finished
	apo_object.dynamic post setsort(ls_oldsort)
	apo_object.dynamic post sort()
end if

//Setredraw after finished
if lb_setredraw then apo_object.dynamic post setredraw(true)

//If less than 1 then set to 1, if larger than max sequence number then set to max sequence number
ll_maxseq = long(apo_object.dynamic describe("evaluate('max(" + as_colname + " for all)', 0)"))
if al_newseq <= 0 then
	al_newseq = 1
elseif al_newseq > ll_maxseq then
	al_newseq = ll_maxseq
end if

//Find and move this row to targetrow
if isnull(al_newseq) then
	ll_find = apo_object.dynamic find(as_colname + ' = ' + string(ll_maxseq), 1, ll_rowcount)
else
	ll_find = apo_object.dynamic find(as_colname + ' = ' + string(al_newseq), 1, ll_rowcount)
end if

if ll_find > 0 then
	if ( isnull(al_newseq) and lb_ascsort) or (al_newseq >= ll_oldseq and lb_ascsort ) or (al_newseq < ll_oldseq and not lb_ascsort) then
		ll_targetrow = ll_find + 1
	else
		ll_targetrow = ll_find
	end if
elseif ll_find = 0 then
	//No need to change other sequence number if new sequence number have not found.
	apo_object.dynamic setitem(al_row, as_colname, al_newseq)
	return c#return.Success
else
	return c#return.Failure
end if

//Save sequence numbers to array
if al_row <= ll_find then
	ll_seq = ldwo_object.primary[al_row, ll_find]
else
	ll_seq = ldwo_object.primary[ll_find, al_row]
end if

if apo_object.dynamic rowsmove(al_row, al_row, primary!, apo_object, ll_targetrow, primary!) <> 1 then return c#return.Failure

//Reset data
if al_row <= ll_find then
	ldwo_object.primary[al_row, ll_find] = ll_seq
else
	ldwo_object.primary[ll_find, al_row] = ll_seq
end if

if isnull(al_newseq) then
	apo_object.dynamic setitem(ll_find, as_colname, al_newseq)
end if

return c#return.Success

end function

public subroutine documentation ();/********************************************************************
   n_sequence_service
   <OBJECT>	 Process with sequence number	</OBJECT>
   <USAGE></USAGE>
   <ALSO>
		non visual user object - n_creq_request			
		use it on dw_list.itemchanged event in the w_changerequest
	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-17-2013 CR2614      	LHG008        		First Version
   	07/05/2014 CR3689       LHG008            Performance optimization
   </HISTORY>
********************************************************************/
end subroutine

on n_sequence_service.create
call super::create
end on

on n_sequence_service.destroy
call super::destroy
end on

