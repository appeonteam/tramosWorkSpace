$PBExportHeader$w_transaction_spy.srw
forward
global type w_transaction_spy from w_master_spy
end type
end forward

global type w_transaction_spy from w_master_spy
string title = "Transaction Preview"
boolean ib_setdefaultbackgroundcolor = false
end type
global w_transaction_spy w_transaction_spy

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01/09/14	CR3781		CCY018				The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_transaction_spy.create
call super::create
end on

on w_transaction_spy.destroy
call super::destroy
end on

type st_hidemenubar from w_master_spy`st_hidemenubar within w_transaction_spy
end type

type cbx_sql from w_master_spy`cbx_sql within w_transaction_spy
end type

type cb_clear from w_master_spy`cb_clear within w_transaction_spy
end type

type cbx_insert from w_master_spy`cbx_insert within w_transaction_spy
end type

type cbx_update from w_master_spy`cbx_update within w_transaction_spy
end type

type cbx_delete from w_master_spy`cbx_delete within w_transaction_spy
end type

type cbx_select from w_master_spy`cbx_select within w_transaction_spy
end type

type dw_sql from w_master_spy`dw_sql within w_transaction_spy
string dataobject = "d_ex_tb_sqlsyntax_transaction"
end type

type gb_filters from w_master_spy`gb_filters within w_transaction_spy
end type

