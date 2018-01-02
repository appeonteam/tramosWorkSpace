$PBExportHeader$w_manual_create_tccommission.srw
forward
global type w_manual_create_tccommission from mt_w_response
end type
type cb_cancel from commandbutton within w_manual_create_tccommission
end type
type cb_ok from commandbutton within w_manual_create_tccommission
end type
type st_1 from statictext within w_manual_create_tccommission
end type
type dw_payments from datawindow within w_manual_create_tccommission
end type
end forward

global type w_manual_create_tccommission from mt_w_response
integer width = 2994
integer height = 2280
boolean titlebar = false
string title = ""
boolean controlmenu = false
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
dw_payments dw_payments
end type
global w_manual_create_tccommission w_manual_create_tccommission

type variables
s_manual_create_tccommission	istr_parm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_manual_create_tccommission
	
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
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_manual_create_tccommission.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.dw_payments=create dw_payments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_payments
end on

on w_manual_create_tccommission.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.dw_payments)
end on

event open;long	ll_broker_nr

istr_parm = message.powerObjectParm

dw_payments.setTransObject(SQLCA)
if dw_payments.retrieve(istr_parm.al_broker_nr) > 0 then
	dw_payments.selectrow(1,true)
	dw_payments.setfocus()
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_manual_create_tccommission
end type

type cb_cancel from commandbutton within w_manual_create_tccommission
integer x = 1573
integer y = 2144
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;setNull(istr_parm.al_paymentID)
closewithreturn(parent, istr_parm)
end event

type cb_ok from commandbutton within w_manual_create_tccommission
integer x = 992
integer y = 2144
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;long ll_row

ll_row = dw_payments.getRow()
if ll_row > 0 then
	istr_parm.al_contractID 		= dw_payments.getItemNumber(ll_row, "contract_id")
	istr_parm.al_paymentID 			= dw_payments.getItemNumber(ll_row, "payment_id")
	istr_parm.ai_tchire_in 			= dw_payments.getItemNumber(ll_row, "tc_hire_in")
	istr_parm.ai_setoff 				= dw_payments.getItemNumber(ll_row, "comm_set_off")
	istr_parm.adt_payment_settle	= dw_payments.getItemDatetime(ll_row, "settle_date")
else
	setNull(istr_parm.al_paymentID)
end if

closewithreturn(parent, istr_parm)
end event

type st_1 from statictext within w_manual_create_tccommission
integer x = 27
integer y = 32
integer width = 1481
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Payments with no TC Commission for selected Broker"
boolean focusrectangle = false
end type

type dw_payments from datawindow within w_manual_create_tccommission
integer x = 18
integer y = 116
integer width = 2935
integer height = 1992
integer taborder = 10
string title = "none"
string dataobject = "d_manual_create_tccommission"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
end if
end event

event doubleclicked;cb_ok.event clicked()
end event

