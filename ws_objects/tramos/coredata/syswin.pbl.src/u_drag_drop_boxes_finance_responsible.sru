$PBExportHeader$u_drag_drop_boxes_finance_responsible.sru
$PBExportComments$Used to update Finance Responsible & Operator for several vessels
forward
global type u_drag_drop_boxes_finance_responsible from u_drag_drop_boxes
end type
end forward

global type u_drag_drop_boxes_finance_responsible from u_drag_drop_boxes
integer width = 3712
integer height = 1860
end type
global u_drag_drop_boxes_finance_responsible u_drag_drop_boxes_finance_responsible

on u_drag_drop_boxes_finance_responsible.create
call super::create
end on

on u_drag_drop_boxes_finance_responsible.destroy
call super::destroy
end on

type cb_msl from u_drag_drop_boxes`cb_msl within u_drag_drop_boxes_finance_responsible
integer x = 1769
integer y = 424
integer weight = 400
end type

type cb_mal from u_drag_drop_boxes`cb_mal within u_drag_drop_boxes_finance_responsible
integer x = 1769
integer y = 544
integer weight = 400
end type

type cb_msr from u_drag_drop_boxes`cb_msr within u_drag_drop_boxes_finance_responsible
integer x = 1769
integer y = 124
integer weight = 400
end type

type cb_mar from u_drag_drop_boxes`cb_mar within u_drag_drop_boxes_finance_responsible
integer x = 1769
integer y = 240
integer weight = 400
end type

type dw_left from u_drag_drop_boxes`dw_left within u_drag_drop_boxes_finance_responsible
integer x = 37
integer y = 64
integer width = 1701
integer height = 1744
string dataobject = "d_update_finance_responsible"
boolean border = false
end type

event dw_left::clicked;call super::clicked;string		ls_sort, ls_sort_temp

if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if 
	ls_sort_temp = dwo.Tag
	dwo.Tag = ls_sort 
	this.groupCalc()
end if
end event

type dw_right from u_drag_drop_boxes`dw_right within u_drag_drop_boxes_finance_responsible
integer x = 1943
integer y = 64
integer width = 1701
integer height = 1744
string dataobject = "d_update_finance_responsible"
boolean border = false
end type

event dw_right::clicked;call super::clicked;if dwo.type = "text" then
	this.setSort(dwo.Tag)
	this.Sort()
end if
end event

type gb_1 from u_drag_drop_boxes`gb_1 within u_drag_drop_boxes_finance_responsible
integer width = 3685
integer height = 1840
end type

