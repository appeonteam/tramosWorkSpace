$PBExportHeader$w_bu_accesstype.srw
forward
global type w_bu_accesstype from mt_w_response
end type
type cb_ok from mt_u_commandbutton within w_bu_accesstype
end type
type dw_type from u_datagrid within w_bu_accesstype
end type
end forward

global type w_bu_accesstype from mt_w_response
integer width = 1161
integer height = 1328
string title = "Select BU Access Type"
boolean ib_setdefaultbackgroundcolor = true
cb_ok cb_ok
dw_type dw_type
end type
global w_bu_accesstype w_bu_accesstype

type variables
constant string is_DELIMITER = ","
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_bu_accesstype
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	09-07-2013 CR3254       LHC010        Replace n_string_service
   </HISTORY>
********************************************************************/

end subroutine

event open;call super::open;n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style
mt_n_stringfunctions	lnv_string
string ls_accesstype, ls_accesstypearray[]
long ll_rowcount, ll_count, ll_find

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_type, false)

dw_type.modify("datawindow.readonly=yes type_sort.visible=0")

dw_type.settransobject(sqlca)
dw_type.retrieve()

ls_accesstype = message.stringparm

if ls_accesstype > '' then
	ll_rowcount = dw_type.rowcount()
	if ll_rowcount < 1 then return
	
	lnv_string.of_parsetoarray(ls_accesstype, is_DELIMITER, ls_accesstypearray)
	
	dw_type.selectrow(0, false)
	//Highlight original slected type
	for ll_count = 1 to upperbound(ls_accesstypearray)
		ll_find = dw_type.find("type_id = " + ls_accesstypearray[ll_count], 1, ll_rowcount)
		if ll_find > 0 then
			dw_type.selectrow(ll_find, true)
		end if
	next
end if
end event

on w_bu_accesstype.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_type=create dw_type
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_type
end on

on w_bu_accesstype.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_type)
end on

event close;call super::close;string ls_accesstype

dw_type.of_get_selectedvalues("type_id", ls_accesstype, is_DELIMITER)

closewithreturn(this, ls_accesstype)
end event

type cb_ok from mt_u_commandbutton within w_bu_accesstype
integer x = 773
integer y = 1120
integer taborder = 20
string text = "OK"
end type

event clicked;call super::clicked;parent.event close( )
end event

type dw_type from u_datagrid within w_bu_accesstype
integer x = 37
integer y = 32
integer width = 1079
integer height = 1072
integer taborder = 10
string dataobject = "d_sq_gr_type"
boolean border = false
end type

event itemchanged;call super::itemchanged;if row > 0 then
	this.selectrow(row, not this.isselected(row))
end if
end event

event clicked;call super::clicked;if row <=0 then return

this.setrow(row)

if this.isselected(row) then
	this.selectrow(row, false)
	//this.setitem(row, 'is_selected', 0)
else
	this.selectrow(row, true)
	//this.setitem(row, 'is_selected', 1)
end if

end event

