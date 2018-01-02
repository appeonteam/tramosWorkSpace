$PBExportHeader$w_show_dualports.srw
$PBExportComments$Inherited from w_show_ports
forward
global type w_show_dualports from w_show_ports
end type
end forward

global type w_show_dualports from w_show_ports
integer width = 4014
integer height = 2256
end type
global w_show_dualports w_show_dualports

on w_show_dualports.create
call super::create
end on

on w_show_dualports.destroy
call super::destroy
end on

type cb_saveas from w_show_ports`cb_saveas within w_show_dualports
integer x = 2491
integer y = 2032
string facename = "Tahoma"
end type

type cb_print from w_show_ports`cb_print within w_show_dualports
integer x = 2011
integer y = 2032
string facename = "Tahoma"
end type

type cb_ok from w_show_ports`cb_ok within w_show_dualports
integer x = 1531
integer y = 2032
string facename = "Tahoma"
end type

type dw_showport from w_show_ports`dw_showport within w_show_dualports
integer width = 4000
integer height = 1988
string dataobject = "d_sq_tb_show_dualports"
end type

