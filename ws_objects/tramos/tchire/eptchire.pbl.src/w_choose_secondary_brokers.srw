$PBExportHeader$w_choose_secondary_brokers.srw
$PBExportComments$This dw lets the user choose one or more secondary brokers for a T/C-Hire
forward
global type w_choose_secondary_brokers from mt_w_main
end type
type cb_new from commandbutton within w_choose_secondary_brokers
end type
type cb_close from commandbutton within w_choose_secondary_brokers
end type
type cb_update from commandbutton within w_choose_secondary_brokers
end type
type cb_delete from commandbutton within w_choose_secondary_brokers
end type
type dw_secondary_brokers from uo_datawindow within w_choose_secondary_brokers
end type
end forward

global type w_choose_secondary_brokers from mt_w_main
integer width = 1472
integer height = 1096
string title = "Secondary Brokers"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
cb_new cb_new
cb_close cb_close
cb_update cb_update
cb_delete cb_delete
dw_secondary_brokers dw_secondary_brokers
end type
global w_choose_secondary_brokers w_choose_secondary_brokers

type variables
s_secondary_brokers is_struct
end variables

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
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

on open;call window::open;is_struct = message.powerobjectparm

dw_secondary_brokers.settransobject(sqlca)

this.move(300,300)

dw_secondary_brokers.retrieve(is_struct.vessel_nr,is_struct.cp_date)

end on

on w_choose_secondary_brokers.create
int iCurrent
call super::create
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.dw_secondary_brokers=create dw_secondary_brokers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new
this.Control[iCurrent+2]=this.cb_close
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.dw_secondary_brokers
end on

on w_choose_secondary_brokers.destroy
call super::destroy
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.dw_secondary_brokers)
end on

type cb_new from commandbutton within w_choose_secondary_brokers
integer x = 1106
integer y = 16
integer width = 325
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New "
boolean default = true
end type

on clicked;long ll_row
dw_secondary_brokers.insertrow(0)
dw_secondary_brokers.scrolltorow(dw_secondary_brokers.rowcount())
ll_row = dw_secondary_brokers.rowcount()
dw_secondary_brokers.setitem(ll_row,"vessel_nr",is_struct.vessel_nr)
dw_secondary_brokers.setitem(ll_row,"tchire_cp_date",is_struct.cp_date)

end on

type cb_close from commandbutton within w_choose_secondary_brokers
integer x = 1106
integer y = 908
integer width = 325
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

on clicked;Close(Parent)
end on

type cb_update from commandbutton within w_choose_secondary_brokers
integer x = 1106
integer y = 248
integer width = 325
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Update"
end type

event clicked;long ll_row
Double ld_comm

dw_secondary_brokers.accepttext()
ll_row = dw_secondary_brokers.GetRow()
ld_comm = dw_secondary_brokers.GetItemNumber(ll_row, "broker_commission")

If ld_comm < 100 then
	dw_secondary_brokers.update()
Else
	Messagebox("Error","The commission has to be less than 100%")
End if

end event

type cb_delete from commandbutton within w_choose_secondary_brokers
integer x = 1106
integer y = 132
integer width = 325
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

on clicked;if dw_secondary_brokers.getrow() < 1 then return
If MessageBox("Delete Message","You are about to DELETE a Secondary Broker.~r~n~r~nAre you sure?",Question!,YesNo!,2) = 2 THEN Return
dw_secondary_brokers.deleterow(dw_secondary_brokers.getrow())
dw_secondary_brokers.update()
end on

type dw_secondary_brokers from uo_datawindow within w_choose_secondary_brokers
integer x = 18
integer y = 20
integer width = 1065
integer height = 964
integer taborder = 10
string dataobject = "d_secondary_brokers"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

