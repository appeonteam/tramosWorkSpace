$PBExportHeader$u_base_filterdw.sru
$PBExportComments$u_filterdw
forward
global type u_base_filterdw from mt_u_datawindow
end type
end forward

global type u_base_filterdw from mt_u_datawindow
boolean border = false
event ue_dwndropdown pbm_dwndropdown
event ue_dwdropdown pbm_dwndropdown
end type
global u_base_filterdw u_base_filterdw

type variables
string is_port_type //either a load or discharge port
string is_filter_field
mt_n_dddw_searchasyoutype inv_dddw_search

end variables

event ue_dwdropdown;datawindowchild ldwc

this.getchild(this.Describe("#1.Name"), ldwc)

if ldwc.rowcount()=0 then
	
	u_base_filterbox  luo_filter
	luo_filter = parent
	ldwc.retrieve( luo_filter.ii_pcgroup )
	
	if lower(this.is_port_type)="discharge" then 
		ldwc.setfilter("type_LD=2")
		ldwc.filter()
	elseif lower(this.is_port_type)="load" then 
		ldwc.setfilter("type_LD=1")
		ldwc.filter()
	end if

end if
end event

on u_base_filterdw.create
call super::create
end on

on u_base_filterdw.destroy
call super::destroy
end on

event constructor;call super::constructor;datawindowchild ldwc

this.settransobject(SQLCA)
this.getchild(this.Describe("#1.Name"), ldwc)
ldwc.settransobject(SQLCA)
end event

event doubleclicked;call super::doubleclicked;long ll_null
string ls_null
setnull(ll_null)
setnull(ls_null)
integer li_index

this.SelectRow(0, FALSE)
this.SetItem(1,1,ll_null)

// u_filterbox  luo_filter
// luo_filter = parent
this.event itemchanged( 0, dwo, ls_null)

end event

event itemchanged;call super::itemchanged;u_base_filterbox  luo_filter
luo_filter = parent
luo_filter.of_setfilter(data, integer(this.tag))	
end event

