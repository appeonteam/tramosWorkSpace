$PBExportHeader$w_sale_base.srw
$PBExportComments$Sales Base Window to be inherited from all windows in sales.
forward
global type w_sale_base from mt_w_sheet
end type
end forward

global type w_sale_base from mt_w_sheet
end type
global w_sale_base w_sale_base

on w_sale_base.create
call mt_w_sheet::create
end on

on w_sale_base.destroy
call mt_w_sheet::destroy
end on

