$PBExportHeader$w_warehouse_errors.srw
$PBExportComments$Used to hamdle errors when recreating sales datawarehouse.
forward
global type w_warehouse_errors from Window
end type
type cb_print from commandbutton within w_warehouse_errors
end type
type cb_ok from commandbutton within w_warehouse_errors
end type
type dw_warehouse_errors from datawindow within w_warehouse_errors
end type
end forward

global type w_warehouse_errors from Window
int X=151
int Y=697
int Width=2757
int Height=1209
boolean TitleBar=true
string Title="Errors when creating datawarehouse"
long BackColor=12632256
boolean ControlMenu=true
event ue_recreate_warehouse pbm_custom01
cb_print cb_print
cb_ok cb_ok
dw_warehouse_errors dw_warehouse_errors
end type
global w_warehouse_errors w_warehouse_errors

event ue_recreate_warehouse;/*****************************************************************************************
09-12-97			5.0			JEH		uf_update_datawarehouse has been changed, so the funktion
												writes errors to this log window and does not stop, 
												unless system error is incurred. This event has therefor
												been changed, so it cheks on the rows written to the log
												instead of the return of funktion uf_update_datawarehouse.

*****************************************************************************************/

long ll_row
string ls_ret
u_datawarehouse uo_dw

uo_dw = create u_datawarehouse

uo_dw.uf_update_datawarehouse(dw_warehouse_errors)

if dw_warehouse_errors.RowCount() = 0 then
	ll_row = dw_warehouse_errors.InsertRow(0)
	dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse")
	dw_warehouse_errors.SetItem(ll_row,2,"The datawarehouse was updated correctly")
else
	ll_row = dw_warehouse_errors.InsertRow(0)
	dw_warehouse_errors.SetItem(1,1,"Update Datawarehouse")
	dw_warehouse_errors.SetItem(1,2,"The datawarehouse was NOT updated correctly!")
end if

//ls_ret = uo_dw.uf_update_datawarehouse(dw_warehouse_errors)
//if isnull(ls_ret) then
//	ll_row = dw_warehouse_errors.InsertRow(0)
//	dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse")
//	dw_warehouse_errors.SetItem(ll_row,2,"The datawarehouse was updated correctly")
//else
//	ll_row = dw_warehouse_errors.InsertRow(0)
//	dw_warehouse_errors.SetItem(ll_row,1,"Update Datawarehouse")
//	dw_warehouse_errors.SetItem(ll_row,2,"The datawarehouse was NOT updated correctly! - The error returned was: "  + ls_ret )
//end if
//
destroy uo_dw
end event

on open;TriggerEvent("ue_recreate_warehouse")
dw_warehouse_errors.GroupCalc()
end on

on w_warehouse_errors.create
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_warehouse_errors=create dw_warehouse_errors
this.Control[]={ this.cb_print,&
this.cb_ok,&
this.dw_warehouse_errors}
end on

on w_warehouse_errors.destroy
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_warehouse_errors)
end on

type cb_print from commandbutton within w_warehouse_errors
int X=407
int Y=997
int Width=247
int Height=109
int TabOrder=30
string Text="Print"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dw_warehouse_errors.Print()

end event

type cb_ok from commandbutton within w_warehouse_errors
int X=87
int Y=997
int Width=247
int Height=109
int TabOrder=20
string Text="OK"
int TextSize=-8
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;close(parent)
end on

type dw_warehouse_errors from datawindow within w_warehouse_errors
int X=33
int Y=29
int Width=2684
int Height=945
int TabOrder=10
string DataObject="d_warehouse_errors"
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

