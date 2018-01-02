$PBExportHeader$u_drag_drop_boxes_office_operator.sru
$PBExportComments$w_vas_report_office_or_operator
forward
global type u_drag_drop_boxes_office_operator from u_drag_drop_boxes
end type
end forward

global type u_drag_drop_boxes_office_operator from u_drag_drop_boxes
integer width = 1838
end type
global u_drag_drop_boxes_office_operator u_drag_drop_boxes_office_operator

forward prototypes
public function integer uf_sort ()
end prototypes

public function integer uf_sort ();dw_left.sort()
dw_right.sort()
return 1
end function

on u_drag_drop_boxes_office_operator.create
call super::create
end on

on u_drag_drop_boxes_office_operator.destroy
call super::destroy
end on

type cb_msl from u_drag_drop_boxes`cb_msl within u_drag_drop_boxes_office_operator
integer x = 837
end type

type cb_mal from u_drag_drop_boxes`cb_mal within u_drag_drop_boxes_office_operator
integer x = 837
end type

type cb_msr from u_drag_drop_boxes`cb_msr within u_drag_drop_boxes_office_operator
integer x = 837
end type

type cb_mar from u_drag_drop_boxes`cb_mar within u_drag_drop_boxes_office_operator
integer x = 837
end type

type dw_left from u_drag_drop_boxes`dw_left within u_drag_drop_boxes_office_operator
integer width = 777
end type

type dw_right from u_drag_drop_boxes`dw_right within u_drag_drop_boxes_office_operator
integer x = 1019
integer width = 777
end type

type gb_1 from u_drag_drop_boxes`gb_1 within u_drag_drop_boxes_office_operator
integer width = 1824
end type

