$PBExportHeader$w_rg_choose.srw
forward
global type w_rg_choose from mt_w_response
end type
type cb_1 from mt_u_commandbutton within w_rg_choose
end type
type dw_choose from datawindow within w_rg_choose
end type
end forward

global type w_rg_choose from mt_w_response
integer width = 1518
integer height = 1220
cb_1 cb_1
dw_choose dw_choose
end type
global w_rg_choose w_rg_choose

type variables
long	 					ii_id[]
s_report_generator 	is_rg
string						is_name[]
integer					li_count
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_rg_choose
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/

end subroutine

on w_rg_choose.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_choose=create dw_choose
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_choose
end on

on w_rg_choose.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.dw_choose)
end on

event open;int		li_i, li_j

is_rg = message.powerobjectparm

if is_rg.number = 1 then
	dw_choose.dataobject = "d_rg_printheader"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve( )
elseif is_rg.number = 2 then
	dw_choose.dataobject = "d_rg_status"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve()
elseif is_rg.number = 3 then
	dw_choose.dataobject = "d_rg_cargotype"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve( )
elseif is_rg.number = 4 then
	dw_choose.dataobject = "d_rg_trade"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve(is_rg.pcgroup)
elseif is_rg.number = 5 or is_rg.number = 6 or is_rg.number = 7 or is_rg.number = 8 then
	dw_choose.dataobject = "d_rg_user"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve(is_rg.pcgroup)
elseif is_rg.number = 9 then
	dw_choose.dataobject = "d_rg_vessel"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve(is_rg.pcgroup)
elseif is_rg.number = 11 then
	dw_choose.dataobject = "d_rg_grade"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve(is_rg.pcgroup)
elseif is_rg.number = 13 or is_rg.number = 14 then
	dw_choose.dataobject = "d_rg_area"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve()
elseif is_rg.number = 15 or is_rg.number = 16 then
	dw_choose.dataobject = "d_rg_port"
	dw_choose.settransobject(SQLCA)
	dw_choose.retrieve( )
end if

if is_rg.number = 15 or is_rg.number = 16 then
	if upperbound(is_rg.name) <> 0 then
		for li_i = 1 to upperbound(is_rg.name)
			for li_j = 1 to dw_choose.rowcount( )
				if dw_choose.getitemstring(li_j,"port_code") = is_rg.name[li_i] then
					dw_choose.selectrow(li_j,true)
					li_count++
					is_name[li_count] = is_rg.name[li_i]
				end if			
			next
		next
	end if
else
	if upperbound(is_rg.id) <> 0 then
		for li_i = 1 to upperbound(is_rg.id)
			for li_j = 1 to dw_choose.rowcount( )
				if dw_choose.getitemnumber(li_j,"id") = is_rg.id[li_i] then
					dw_choose.selectrow(li_j,true)
					li_count++
					ii_id[li_count] =is_rg.id[li_i]
				end if			
			next
		next
	end if
end if

	
				
end event

event close;is_rg.id = ii_id
closewithreturn(this,is_rg)

end event

type cb_1 from mt_u_commandbutton within w_rg_choose
integer x = 1143
integer y = 1012
integer taborder = 20
string text = "Choose"
end type

event clicked;call super::clicked;is_rg.id = ii_id
is_rg.name = is_name
closewithreturn(parent,is_rg)

end event

type dw_choose from datawindow within w_rg_choose
integer x = 14
integer y = 88
integer width = 1477
integer height = 896
integer taborder = 10
string title = "none"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_empty[]
integer li_x

if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
	else
		this.selectrow(row,true)
	end if
	ii_id = li_empty
	for li_x = 1 to this.rowCount()
		if this.isselected(li_x) then
			li_count ++
			if is_rg.number = 15 or is_rg.number = 16 then
				is_name[li_count] = this.getItemString(li_x, "port_code")
			else
				ii_id[li_count] = this.getItemNumber(li_x, "id")
			end if
		end if 
	next
end if


end event

