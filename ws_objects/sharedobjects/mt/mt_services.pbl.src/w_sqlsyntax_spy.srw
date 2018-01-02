$PBExportHeader$w_sqlsyntax_spy.srw
forward
global type w_sqlsyntax_spy from w_master_spy
end type
type st_1 from u_topbar_background within w_sqlsyntax_spy
end type
end forward

global type w_sqlsyntax_spy from w_master_spy
integer width = 3374
integer height = 1584
string title = "SQL Preview"
long backcolor = 32304364
st_1 st_1
end type
global w_sqlsyntax_spy w_sqlsyntax_spy

type variables
//u_spydetail iuo_detail[]
end variables

forward prototypes
public function integer of_createnewdetail ()
public subroutine documentation ()
end prototypes

public function integer of_createnewdetail ();//this.OpenUserObject(iuo_detail[upperbound(iuo_detail) + 1], "u_spydetail" , 20, 500 + upperbound(iuo_detail)*1000)


//ll_index= upperbound(iuo_detail) + 1
//
//iuo_detail[ll_index] = create u_spydetail
//
//iuo_detail[ll_index].x = 20
//iuo_detail[ll_index].y = 20

return 1




end function

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
   	01/09/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_sqlsyntax_spy.create
int iCurrent
call super::create
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_sqlsyntax_spy.destroy
call super::destroy
destroy(this.st_1)
end on

type cbx_sql from w_master_spy`cbx_sql within w_sqlsyntax_spy
integer x = 2619
integer y = 72
long textcolor = 16777215
long backcolor = 553648127
end type

type cb_clear from w_master_spy`cb_clear within w_sqlsyntax_spy
integer x = 32
integer y = 1340
integer textsize = -8
end type

type cbx_insert from w_master_spy`cbx_insert within w_sqlsyntax_spy
integer x = 1888
integer y = 84
integer width = 357
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "SQL Insert"
end type

type cbx_update from w_master_spy`cbx_update within w_sqlsyntax_spy
integer x = 1285
integer y = 84
integer width = 389
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "SQL Update"
end type

type cbx_delete from w_master_spy`cbx_delete within w_sqlsyntax_spy
integer x = 709
integer y = 84
integer width = 370
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "SQL Delete"
end type

type cbx_select from w_master_spy`cbx_select within w_sqlsyntax_spy
integer y = 84
integer width = 562
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "SQL Select"
end type

type dw_sql from w_master_spy`dw_sql within w_sqlsyntax_spy
integer y = 256
integer width = 3282
integer height = 1056
string dataobject = "d_ex_tb_sqlsyntax"
boolean resizable = true
boolean border = false
end type

event dw_sql::retrieverow;call super::retrieverow;messagebox("","i have been updated!")
end event

type gb_filters from w_master_spy`gb_filters within w_sqlsyntax_spy
integer y = 0
integer width = 2437
long textcolor = 16777215
long backcolor = 553648127
end type

type st_1 from u_topbar_background within w_sqlsyntax_spy
end type

