$PBExportHeader$w_maintain_base.srw
forward
global type w_maintain_base from w_system_base
end type
type dw_detail from u_datagrid within w_maintain_base
end type
end forward

global type w_maintain_base from w_system_base
integer width = 2350
integer height = 1904
dw_detail dw_detail
end type
global w_maintain_base w_maintain_base

type variables

private:
string _is_master_colname, _is_detail_colname
boolean _ib_registered
end variables

forward prototypes
public function integer wf_register (string as_master_colname, string as_detail_colname)
private function integer _getdetail ()
public subroutine documentation ()
end prototypes

public function integer wf_register (string as_master_colname, string as_detail_colname);/********************************************************************
   wf_register
   <DESC>	Register column for select and save data	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		as_master_colname: will save value to this column 
		as_detail_colname: will get value from this column 
   </ARGS>
   <USAGE>	call on open event	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01-02-2013 CR2614       LHG008        First Version
   </HISTORY>
********************************************************************/

string ls_coltype

//Check the master column type whether is string or not
ls_coltype = lower(left(dw_1.describe(as_master_colname + ".Coltype"), 4))
if ls_coltype <> 'char' then return c#return.Failure

//Check the detail column type whether is numeric or not
ls_coltype = lower(left(dw_detail.describe(as_detail_colname + ".Coltype"), 4))
if ls_coltype <> 'deci' and ls_coltype <> 'int' and ls_coltype <> 'long' &
		and ls_coltype <> 'numb' and ls_coltype <> 'real' and ls_coltype <> 'ulon' then 
	return c#return.Failure
end if

_is_master_colname = as_master_colname
_is_detail_colname = as_detail_colname

_ib_registered = true

return c#return.Success
end function

private function integer _getdetail ();/********************************************************************
   _getdetail()
   <DESC>	Get value from master datawindow and highlights	in detial datawindow</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>	dw_1.event rowfocuschanged(/*long currentrow */)	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01-03-2013 CR2614       LHG008        First Version
		07-09-2013 CR3254			LHC010		  Replace n_string_service		
   </HISTORY>
********************************************************************/

mt_n_stringfunctions lnv_string
string ls_value
integer li_array[]
long ll_row, ll_rowcount, ll_upper, ll_find

ll_rowcount = dw_detail.rowcount()
if not _ib_registered or ll_rowcount <= 0 then return c#return.NoAction

ll_row = dw_1.getrow()
if ll_row <= 0 then return c#return.NoAction

ls_value = dw_1.getitemstring(ll_row, _is_master_colname)
lnv_string.of_parsetoarray (ls_value, ',', li_array)

dw_detail.selectrow(0, false)

for ll_upper = 1 to upperbound(li_array)
	ll_find = dw_detail.find(_is_detail_colname + ' = ' + string(li_array[ll_upper]), 1, ll_rowcount)
	if ll_find > 0 then dw_detail.selectrow(ll_find, true)
next

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   w_maintain_base
   <OBJECT>	Base window of Maintain	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        First Version
		07-09-2013 CR3254			LHC010		  Replace n_string_service
		30/05/2014 CR3427			LHG008		  Modify event open()
   </HISTORY>
********************************************************************/
end subroutine

on w_maintain_base.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_maintain_base.destroy
call super::destroy
destroy(this.dw_detail)
end on

event open;this.triggerevent("ue_preopen")

wf_format_datawindow(dw_detail)
dw_detail.retrieve()

dw_1.settransobject(sqlca)
dw_1.post retrieve()
end event

type cb_cancel from w_system_base`cb_cancel within w_maintain_base
integer x = 1957
integer y = 1696
end type

event cb_cancel::clicked;dw_detail.retrieve()

call super::clicked
end event

type cb_refresh from w_system_base`cb_refresh within w_maintain_base
integer x = 2725
integer y = 208
end type

type cb_delete from w_system_base`cb_delete within w_maintain_base
integer x = 1609
integer y = 1696
end type

type cb_update from w_system_base`cb_update within w_maintain_base
integer x = 1262
integer y = 1696
end type

type cb_new from w_system_base`cb_new within w_maintain_base
integer x = 914
integer y = 1696
end type

type dw_1 from w_system_base`dw_1 within w_maintain_base
integer width = 1115
integer height = 1648
end type

event dw_1::rowfocuschanged;call super::rowfocuschanged;_getdetail()
end event

type dw_detail from u_datagrid within w_maintain_base
integer x = 1189
integer y = 32
integer width = 1115
integer height = 1648
integer taborder = 20
boolean bringtotop = true
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;string ls_value

if row > 0 then
	this.selectrow(row, not this.isselected(row))
	if _ib_registered then
		if this.of_get_selectedvalues(_is_detail_colname, ls_value, ',') <> c#return.Failure then
			dw_1.setitem(dw_1.getrow(), _is_master_colname, ls_value)
		end if
	end if
end if
end event

