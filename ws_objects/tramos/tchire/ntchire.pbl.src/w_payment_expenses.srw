$PBExportHeader$w_payment_expenses.srw
$PBExportComments$Window for showing expenses (Port/Non-Port/Off-Service) for a specified payment
forward
global type w_payment_expenses from mt_w_response
end type
type dw_bunker_on_delivery from datawindow within w_payment_expenses
end type
type st_bunker from statictext within w_payment_expenses
end type
type cb_minmax from commandbutton within w_payment_expenses
end type
type cb_next from commandbutton within w_payment_expenses
end type
type cb_last from commandbutton within w_payment_expenses
end type
type cb_current from commandbutton within w_payment_expenses
end type
type cb_previous from commandbutton within w_payment_expenses
end type
type cb_close from commandbutton within w_payment_expenses
end type
type st_payment_detail from statictext within w_payment_expenses
end type
type st_move_expl from statictext within w_payment_expenses
end type
type st_off_service from statictext within w_payment_expenses
end type
type st_port_exp from statictext within w_payment_expenses
end type
type st_non_port_exp from statictext within w_payment_expenses
end type
type st_filter_expl from statictext within w_payment_expenses
end type
type cbx_past from checkbox within w_payment_expenses
end type
type cbx_future from checkbox within w_payment_expenses
end type
type st_brown_exp from statictext within w_payment_expenses
end type
type st_brown from statictext within w_payment_expenses
end type
type st_dark_red_exp from statictext within w_payment_expenses
end type
type st_black_exp from statictext within w_payment_expenses
end type
type st_blue_exp from statictext within w_payment_expenses
end type
type st_red_exp from statictext within w_payment_expenses
end type
type st_green_exp from statictext within w_payment_expenses
end type
type st_dark_red from statictext within w_payment_expenses
end type
type st_black from statictext within w_payment_expenses
end type
type st_blue from statictext within w_payment_expenses
end type
type st_red from statictext within w_payment_expenses
end type
type st_green from statictext within w_payment_expenses
end type
type st_legend from statictext within w_payment_expenses
end type
type dw_payment from datawindow within w_payment_expenses
end type
type dw_off_service from datawindow within w_payment_expenses
end type
type dw_non_port_exp from datawindow within w_payment_expenses
end type
type dw_port_exp from datawindow within w_payment_expenses
end type
type gb_filter from groupbox within w_payment_expenses
end type
type r_1 from rectangle within w_payment_expenses
end type
end forward

global type w_payment_expenses from mt_w_response
integer width = 4677
integer height = 2948
string title = "Payment details..."
boolean controlmenu = false
long backcolor = 80269524
dw_bunker_on_delivery dw_bunker_on_delivery
st_bunker st_bunker
cb_minmax cb_minmax
cb_next cb_next
cb_last cb_last
cb_current cb_current
cb_previous cb_previous
cb_close cb_close
st_payment_detail st_payment_detail
st_move_expl st_move_expl
st_off_service st_off_service
st_port_exp st_port_exp
st_non_port_exp st_non_port_exp
st_filter_expl st_filter_expl
cbx_past cbx_past
cbx_future cbx_future
st_brown_exp st_brown_exp
st_brown st_brown
st_dark_red_exp st_dark_red_exp
st_black_exp st_black_exp
st_blue_exp st_blue_exp
st_red_exp st_red_exp
st_green_exp st_green_exp
st_dark_red st_dark_red
st_black st_black
st_blue st_blue
st_red st_red
st_green st_green
st_legend st_legend
dw_payment dw_payment
dw_off_service dw_off_service
dw_non_port_exp dw_non_port_exp
dw_port_exp dw_port_exp
gb_filter gb_filter
r_1 r_1
end type
global w_payment_expenses w_payment_expenses

type variables
datawindow				idw_current
long						il_payment_id, il_contract_id
s_payment_expenses 	istr_parameters
n_tc_payment			inv_tc_payment

end variables

forward prototypes
public subroutine wf_filterexpenses ()
public subroutine wf_moveexpense (string as_action, datawindow adw)
public subroutine documentation ()
end prototypes

public subroutine wf_filterexpenses ();IF cbx_past.checked = TRUE THEN
	IF cbx_future.checked = TRUE THEN
		dw_port_exp.retrieve(il_contract_id, 0, 9999999, il_payment_id)
		dw_non_port_exp.retrieve(il_contract_id, 0, 9999999, il_payment_id)
		dw_off_service.retrieve(il_contract_id, 0, 9999999, il_payment_id)
		dw_bunker_on_delivery.retrieve(il_contract_id, 0, 9999999, il_payment_id)
	ELSE
		dw_port_exp.retrieve(il_contract_id, 0, il_payment_id, il_payment_id)
		dw_non_port_exp.retrieve(il_contract_id, 0, il_payment_id, il_payment_id)
		dw_off_service.retrieve(il_contract_id, 0, il_payment_id, il_payment_id)
		dw_bunker_on_delivery.retrieve(il_contract_id, 0, il_payment_id, il_payment_id)
	END IF
ELSE //un-check of Past Payments
	IF cbx_future.checked = TRUE THEN
		dw_port_exp.retrieve(il_contract_id, il_payment_id, 9999999, il_payment_id)
		dw_non_port_exp.retrieve(il_contract_id, il_payment_id, 9999999, il_payment_id)
		dw_off_service.retrieve(il_contract_id, il_payment_id, 9999999, il_payment_id)
		dw_bunker_on_delivery.retrieve(il_contract_id, il_payment_id, 9999999, il_payment_id)
	ELSE
		dw_port_exp.retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)
		dw_non_port_exp.retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)
		dw_off_service.retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)
		dw_bunker_on_delivery.retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)
	END IF
END IF

end subroutine

public subroutine wf_moveexpense (string as_action, datawindow adw);long 				ll_row
long 				ll_payment_id, ll_new_payment_id, ll_paymentIDArray[]
long 				ll_old_rowID
string			ls_colName, ls_search
long				ll_found
n_tc_payment	lnv_payment
string ls_mySQL,ls_status
integer			li_status=0


if isNull(adw) then return 

//IF adw.dataObject <> "d_contract_bunker_on_delivery" THEN
//	IF adw.getitemnumber(adw.getrow(), "trans_to_coda") > 0 THEN
//		MessageBox("Operation not possible","You cannot transfer the selected item because the hire statement is in status [Final/Part-Paid/Paid]. ~n~r"+&
//							"Contact Operations to set the hire statement to Draft.",Information!)
//		RETURN
//	END IF
//ELSE 
//	IF adw.getitemnumber(adw.getrow(), "payment_status") > 2 THEN		
//	MessageBox("Operation not possible","You cannot transfer the selected item because the hire statement is in status [Final/Part-Paid/Paid].~n~r "&
//							+"Contact Operations to set the hire statement to Draft.",Information!)
//		RETURN
//	END IF
//END IF	
ll_row = adw.getSelectedRow(0)

IF ll_row < 1 THEN 
	MessageBox("Please Select A Row!", "You must select a row to perform this task!", StopSign!)
	RETURN
END IF

if ll_row > 0 then
	ll_old_rowID = adw.getItemNumber(ll_row, 1)
else
	setNull(ll_old_rowID)
end if


ll_payment_id = adw.getitemnumber(adw.getSelectedRow(0),"payment_id")
li_status = adw.getitemnumber(adw.getSelectedRow(0),'payment_status')
choose case li_status
	case 3
		ls_status =  'Final'
	case 4
		ls_status = 'Part-Paid'
	case 5
		ls_status = 'Paid'
end choose
if li_status > 2 then
	MessageBox("Validation","You cannot move the selected item from this hire statement, because it is in status " +ls_status + ". ~n~r~n~r"&
					+"Contact Finance to unsettle and Operations to set the hire statement to Draft.",Information!)
	Return
end if

CHOOSE CASE upper(as_action)
	CASE "PREVIOUS"
		
			ll_new_payment_id = inv_tc_payment.of_getPreviousUnpaid(il_contract_id, ll_payment_id)
		
	CASE "CURRENT"
		SELECT PAYMENT_STATUS 
		INTO :li_status
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID = :il_payment_id;
		if ll_payment_id = il_payment_id then
			return
		end if
		
		if li_status>2 then
			MessageBox("Validation","You cannot move the selected item to Current hire statement, because it is not in status New or Draft.~n~r~n~r"&
							+"Contact Finance to unsettle and Operations to set the hire statement to Draft.", Information!)
			return
		end if
		
		ll_new_payment_id = il_payment_id
	CASE "NEXT"
		
			ll_new_payment_id = inv_tc_payment.of_getNextUnpaid(il_contract_id, ll_payment_id)
		
	CASE "LAST"
		if adw.tag = "non_port_exp" then //only non-port expenses can be moved to last
			ll_new_payment_id = inv_tc_payment.of_getlastunpaid(il_contract_id,ll_payment_id)
		
		else
			ll_new_payment_id = il_payment_id
			MessageBox("Information", "Only Non-port Expenses can be moved to last payment in one step.")
			return
		end if
	CASE ELSE
		MessageBox("Error", "Function(wf_moveExpense) called with wrong parameters.")
		return
END CHOOSE

IF ll_new_payment_id = -1 THEN 
	RETURN //Message Box is already given in the function
ELSE // succeeded - now update the datawindow
	adw.setitem(ll_row, "payment_id", ll_new_payment_id)
	IF adw.update() = 1 THEN
		COMMIT;
		dw_payment.POST groupcalc()
	ELSE //update of datastore did not succeed
		ROLLBACK;
		MessageBox("Update Error!", "The database was not able to update. ~r~n"+&
						"Please try again or contact your System Administrator.")
	END IF
END IF

/* Recalc payment balances */
if adw.dataObject = "d_contract_off_service" then
	/* Off-service moved */
	ll_paymentIDArray[1] = ll_payment_id
	ll_paymentIDArray[2] = ll_new_payment_id	
	lnv_payment = create n_tc_payment
	lnv_payment.of_offservicemodified( il_contract_id, ll_paymentIDArray)
	destroy lnv_payment
else
	/* Other moved */
	ls_mySQL = "sp_paymentBalance " + string(ll_payment_id)
	EXECUTE IMMEDIATE :ls_mySQL;
	ls_mySQL = "sp_paymentBalance " + string(ll_new_payment_id)
	EXECUTE IMMEDIATE :ls_mySQL;
	commit;
end if

//Re-retrieve datawindow
IF cbx_past.checked = TRUE THEN
	IF cbx_future.checked = TRUE THEN
		adw.retrieve(il_contract_id, 0, 9999999, il_payment_id)
	ELSE
		adw.retrieve(il_contract_id, 0, il_payment_id, il_payment_id)
	END IF
ELSE //un-check of Past Payments
	IF cbx_future.checked = TRUE THEN
		adw.retrieve(il_contract_id, il_payment_id, 9999999, il_payment_id)
	ELSE
		adw.retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)
	END IF
END IF

//find the moved row and highlight
ls_colName = string(adw.Object.#1.Name)
ls_search = ls_colName + "=" + string(ll_old_rowID)
ll_found = adw.find(ls_search, 1, 99999999)
adw.selectrow(0, false)
if ll_found = 0 then ll_found = 1
adw.selectRow(ll_found, true)

adw.post setFocus()
return

end subroutine

public subroutine documentation ();/********************************************************************
	w_payment_expenses
	
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
		01/07/2015  CR4078      KSH092      Operation not allow,when the hire statement status in Final\Part-Paid\Paid
	</HISTORY>
********************************************************************/
end subroutine

on w_payment_expenses.create
int iCurrent
call super::create
this.dw_bunker_on_delivery=create dw_bunker_on_delivery
this.st_bunker=create st_bunker
this.cb_minmax=create cb_minmax
this.cb_next=create cb_next
this.cb_last=create cb_last
this.cb_current=create cb_current
this.cb_previous=create cb_previous
this.cb_close=create cb_close
this.st_payment_detail=create st_payment_detail
this.st_move_expl=create st_move_expl
this.st_off_service=create st_off_service
this.st_port_exp=create st_port_exp
this.st_non_port_exp=create st_non_port_exp
this.st_filter_expl=create st_filter_expl
this.cbx_past=create cbx_past
this.cbx_future=create cbx_future
this.st_brown_exp=create st_brown_exp
this.st_brown=create st_brown
this.st_dark_red_exp=create st_dark_red_exp
this.st_black_exp=create st_black_exp
this.st_blue_exp=create st_blue_exp
this.st_red_exp=create st_red_exp
this.st_green_exp=create st_green_exp
this.st_dark_red=create st_dark_red
this.st_black=create st_black
this.st_blue=create st_blue
this.st_red=create st_red
this.st_green=create st_green
this.st_legend=create st_legend
this.dw_payment=create dw_payment
this.dw_off_service=create dw_off_service
this.dw_non_port_exp=create dw_non_port_exp
this.dw_port_exp=create dw_port_exp
this.gb_filter=create gb_filter
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_bunker_on_delivery
this.Control[iCurrent+2]=this.st_bunker
this.Control[iCurrent+3]=this.cb_minmax
this.Control[iCurrent+4]=this.cb_next
this.Control[iCurrent+5]=this.cb_last
this.Control[iCurrent+6]=this.cb_current
this.Control[iCurrent+7]=this.cb_previous
this.Control[iCurrent+8]=this.cb_close
this.Control[iCurrent+9]=this.st_payment_detail
this.Control[iCurrent+10]=this.st_move_expl
this.Control[iCurrent+11]=this.st_off_service
this.Control[iCurrent+12]=this.st_port_exp
this.Control[iCurrent+13]=this.st_non_port_exp
this.Control[iCurrent+14]=this.st_filter_expl
this.Control[iCurrent+15]=this.cbx_past
this.Control[iCurrent+16]=this.cbx_future
this.Control[iCurrent+17]=this.st_brown_exp
this.Control[iCurrent+18]=this.st_brown
this.Control[iCurrent+19]=this.st_dark_red_exp
this.Control[iCurrent+20]=this.st_black_exp
this.Control[iCurrent+21]=this.st_blue_exp
this.Control[iCurrent+22]=this.st_red_exp
this.Control[iCurrent+23]=this.st_green_exp
this.Control[iCurrent+24]=this.st_dark_red
this.Control[iCurrent+25]=this.st_black
this.Control[iCurrent+26]=this.st_blue
this.Control[iCurrent+27]=this.st_red
this.Control[iCurrent+28]=this.st_green
this.Control[iCurrent+29]=this.st_legend
this.Control[iCurrent+30]=this.dw_payment
this.Control[iCurrent+31]=this.dw_off_service
this.Control[iCurrent+32]=this.dw_non_port_exp
this.Control[iCurrent+33]=this.dw_port_exp
this.Control[iCurrent+34]=this.gb_filter
this.Control[iCurrent+35]=this.r_1
end on

on w_payment_expenses.destroy
call super::destroy
destroy(this.dw_bunker_on_delivery)
destroy(this.st_bunker)
destroy(this.cb_minmax)
destroy(this.cb_next)
destroy(this.cb_last)
destroy(this.cb_current)
destroy(this.cb_previous)
destroy(this.cb_close)
destroy(this.st_payment_detail)
destroy(this.st_move_expl)
destroy(this.st_off_service)
destroy(this.st_port_exp)
destroy(this.st_non_port_exp)
destroy(this.st_filter_expl)
destroy(this.cbx_past)
destroy(this.cbx_future)
destroy(this.st_brown_exp)
destroy(this.st_brown)
destroy(this.st_dark_red_exp)
destroy(this.st_black_exp)
destroy(this.st_blue_exp)
destroy(this.st_red_exp)
destroy(this.st_green_exp)
destroy(this.st_dark_red)
destroy(this.st_black)
destroy(this.st_blue)
destroy(this.st_red)
destroy(this.st_green)
destroy(this.st_legend)
destroy(this.dw_payment)
destroy(this.dw_off_service)
destroy(this.dw_non_port_exp)
destroy(this.dw_port_exp)
destroy(this.gb_filter)
destroy(this.r_1)
end on

event open;/*------------------------------
Color code (RGB) table for expenses:
				Settled					Not Settled
Earlier		Dark Red (128,0,0)	Blue (0,0,255)
Current		Brown(128,128,0)		Black (0,0,0)
Future		Red(255,0,0)			Green (0,128,0)
------------------------------*/
DateTime		ldt_due_date
LONG			ll_payment_status

istr_parameters = Message.PowerObjectParm
move(0,0)

inv_tc_payment = CREATE n_tc_payment

il_payment_id = istr_parameters.payment_id
il_contract_id = istr_parameters.contract_id

dw_payment.settransobject(SQLCA)
dw_payment.retrieve(il_payment_id)

dw_non_port_exp.settransobject(SQLCA)
dw_non_port_exp.POST retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)

dw_port_exp.settransobject(SQLCA)
dw_port_exp.POST retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)

dw_off_service.settransobject(SQLCA)
dw_off_service.POST retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)

dw_bunker_on_delivery .settransobject(SQLCA)
dw_bunker_on_delivery .POST retrieve(il_contract_id, il_payment_id, il_payment_id, il_payment_id)

end event

event close;if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_payment_expenses
end type

type dw_bunker_on_delivery from datawindow within w_payment_expenses
string tag = "bunker"
integer x = 27
integer y = 2316
integer width = 2821
integer height = 516
integer taborder = 60
string title = " none"
string dataobject = "d_contract_bunker_on_delivery"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;IF currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
END IF
end event

event getfocus;string ls_color
long 		ll_row

idw_current = this
ll_row = this.getSelectedRow(0)
idw_current.selectrow(0, false)
if ll_row > 0 then
	this.selectrow(ll_row, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
ls_color = dw_payment.Object.Datawindow.Color
this.Object.DataWindow.Color='16777215'
dw_non_port_exp.Object.DataWindow.Color=ls_color
dw_off_service.Object.DataWindow.Color=ls_color
dw_port_exp.Object.DataWindow.Color=ls_color

end event

type st_bunker from statictext within w_payment_expenses
integer x = 27
integer y = 2248
integer width = 485
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Bunker on Delivery"
boolean focusrectangle = false
end type

type cb_minmax from commandbutton within w_payment_expenses
integer x = 4270
integer y = 1632
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Maximize"
end type

event clicked;if this.text = "&Maximize" then
	if isNull(idw_current) then return
	CHOOSE CASE idw_current.tag
		CASE "non_port_exp"
			st_non_port_exp.visible = 		true
			st_non_port_exp.y = 				468
			dw_non_port_exp.visible = 		true
			dw_non_port_exp.y = 			524
			dw_non_port_exp.height = 		2296
			st_port_exp.visible = 				false
			dw_port_exp.visible = 			false
			st_off_service.visible = 			false
			dw_off_service.visible = 			false
			st_bunker.visible = 				false
			dw_bunker_on_delivery.visible = false
			this.text = "&Minimize"
		CASE "port_exp"
			st_port_exp.visible = 				true
			st_port_exp.y = 					468
			dw_port_exp.visible = 			true
			dw_port_exp.y = 					524
			dw_port_exp.height = 			2296
			st_non_port_exp.visible =		false
			dw_non_port_exp.visible =		false
			st_off_service.visible =	 		false
			dw_off_service.visible = 			false
			st_bunker.visible = 				false
			dw_bunker_on_delivery.visible = false
			this.text = "&Minimize"
		CASE "off_service"
			st_off_service.visible = 			true
			st_off_service.y = 					468
			dw_off_service.visible = 			true
			dw_off_service.y = 				524
			dw_off_service.height = 			2296
			st_port_exp.visible = 				false
			dw_port_exp.visible = 			false
			st_non_port_exp.visible =	 	false
			dw_non_port_exp.visible = 		false
			st_bunker.visible = 				false
			dw_bunker_on_delivery.visible = false
			this.text = "&Minimize"
	
		CASE "bunker"
			st_bunker.visible = 				true
			st_bunker.y =	 					468
			dw_bunker_on_delivery .visible = true
			dw_bunker_on_delivery .y = 	524
			dw_bunker_on_delivery.height = 2296
			st_non_port_exp.visible =		false
			dw_non_port_exp.visible =		false
			st_off_service.visible = 			false
			dw_off_service.visible = 			false
			st_port_exp.visible = 				false
			dw_port_exp.visible = 			false
			this.text = "&Minimize"
	END CHOOSE
	idw_current.POST setFocus()
else
	st_non_port_exp.y = 468
	st_non_port_exp.visible = true
	dw_non_port_exp.y = 524
	dw_non_port_exp.height = 515
	dw_non_port_exp.visible = true
	st_port_exp.y = 1063
	st_port_exp.visible = true
	dw_port_exp.y = 1119
	dw_port_exp.height = 515
	dw_port_exp.visible = true
	st_off_service.y = 1654
	st_off_service.visible = true
	dw_off_service.y = 1710
	dw_off_service.height = 515
	dw_off_service.visible = true
	st_bunker.y = 2249
	st_bunker.visible = true
	dw_bunker_on_delivery.y = 2317
	dw_bunker_on_delivery.height = 515
	dw_bunker_on_delivery.visible = true
	this.text = "&Maximize"
end if
end event

type cb_next from commandbutton within w_payment_expenses
integer x = 4270
integer y = 2216
integer width = 343
integer height = 96
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Next"
end type

event clicked;wf_moveExpense("next", idw_current)

end event

type cb_last from commandbutton within w_payment_expenses
integer x = 4270
integer y = 2324
integer width = 343
integer height = 92
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Last"
end type

event clicked;wf_moveExpense("last", idw_current)

end event

type cb_current from commandbutton within w_payment_expenses
integer x = 4270
integer y = 2108
integer width = 343
integer height = 92
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Current"
end type

event clicked;wf_moveExpense("current", idw_current)

end event

type cb_previous from commandbutton within w_payment_expenses
integer x = 4270
integer y = 2000
integer width = 343
integer height = 92
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Previous"
end type

event clicked;wf_moveExpense("previous", idw_current)



end event

type cb_close from commandbutton within w_payment_expenses
integer x = 4270
integer y = 2696
integer width = 343
integer height = 92
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close (Esc)"
boolean cancel = true
end type

event clicked;close(parent)
end event

type st_payment_detail from statictext within w_payment_expenses
integer x = 27
integer width = 411
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Payment Details"
boolean focusrectangle = false
end type

type st_move_expl from statictext within w_payment_expenses
integer x = 4142
integer y = 1824
integer width = 457
integer height = 136
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long backcolor = 67108864
string text = "Move selected to another payment..."
boolean focusrectangle = false
end type

type st_off_service from statictext within w_payment_expenses
integer x = 27
integer y = 1656
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Off-Hire"
boolean focusrectangle = false
end type

type st_port_exp from statictext within w_payment_expenses
integer x = 27
integer y = 1064
integer width = 489
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Port Expenses"
boolean focusrectangle = false
end type

type st_non_port_exp from statictext within w_payment_expenses
integer x = 27
integer y = 468
integer width = 489
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Non-Port Expenses"
boolean focusrectangle = false
end type

type st_filter_expl from statictext within w_payment_expenses
integer x = 3922
integer y = 1296
integer width = 457
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long backcolor = 67108864
string text = "Show Current and..."
boolean focusrectangle = false
end type

type cbx_past from checkbox within w_payment_expenses
integer x = 3927
integer y = 1356
integer width = 498
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "&Earlier Payments"
end type

event clicked;wf_filterExpenses()

if not isNull(idw_current) then idw_current.POST setFocus()

end event

type cbx_future from checkbox within w_payment_expenses
integer x = 3927
integer y = 1436
integer width = 498
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "L&ater Payments"
end type

event clicked;wf_filterExpenses()

if not isNull(idw_current) then idw_current.POST setFocus()
end event

type st_brown_exp from statictext within w_payment_expenses
integer x = 4005
integer y = 888
integer width = 539
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 32896
long backcolor = 12639424
string text = "Current (Settled)"
boolean focusrectangle = false
end type

type st_brown from statictext within w_payment_expenses
integer x = 3749
integer y = 888
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 32896
long backcolor = 12639424
string text = "Brown"
boolean focusrectangle = false
end type

type st_dark_red_exp from statictext within w_payment_expenses
integer x = 4005
integer y = 776
integer width = 539
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 128
long backcolor = 12639424
string text = "Earlier (Settled)"
boolean focusrectangle = false
end type

type st_black_exp from statictext within w_payment_expenses
integer x = 4005
integer y = 832
integer width = 539
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 12639424
string text = "Current (Not Settled)"
boolean focusrectangle = false
end type

type st_blue_exp from statictext within w_payment_expenses
integer x = 4005
integer y = 720
integer width = 539
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16711680
long backcolor = 12639424
string text = "Earlier (Not Settled)"
boolean focusrectangle = false
end type

type st_red_exp from statictext within w_payment_expenses
integer x = 4005
integer y = 1000
integer width = 539
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 255
long backcolor = 12639424
string text = "Later (Settled)"
boolean focusrectangle = false
end type

type st_green_exp from statictext within w_payment_expenses
integer x = 4005
integer y = 944
integer width = 539
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 32768
long backcolor = 12639424
string text = "Later (Not Settled)"
boolean focusrectangle = false
end type

type st_dark_red from statictext within w_payment_expenses
integer x = 3744
integer y = 776
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 128
long backcolor = 12639424
string text = "Dark Red"
boolean focusrectangle = false
end type

type st_black from statictext within w_payment_expenses
integer x = 3744
integer y = 832
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 12639424
string text = "Black"
boolean focusrectangle = false
end type

type st_blue from statictext within w_payment_expenses
integer x = 3744
integer y = 720
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 16711680
long backcolor = 12639424
string text = "Blue"
boolean focusrectangle = false
end type

type st_red from statictext within w_payment_expenses
integer x = 3744
integer y = 1000
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 255
long backcolor = 12639424
string text = "Red"
boolean focusrectangle = false
end type

type st_green from statictext within w_payment_expenses
integer x = 3744
integer y = 944
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 32768
long backcolor = 12639424
string text = "Green"
boolean focusrectangle = false
end type

type st_legend from statictext within w_payment_expenses
integer x = 3826
integer y = 652
integer width = 613
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12639424
string text = "Expenses Color Legend"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_payment from datawindow within w_payment_expenses
integer x = 27
integer y = 56
integer width = 4635
integer height = 392
integer taborder = 10
string title = "none"
string dataobject = "d_payment_details"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;string ls_color

setNull(idw_current)
ls_color = dw_payment.Object.Datawindow.Color
dw_non_port_exp.Object.DataWindow.Color=ls_color
dw_port_exp.Object.DataWindow.Color=ls_color
dw_off_service.Object.DataWindow.Color=ls_color
dw_bunker_on_delivery.Object.DataWindow.Color=ls_color

end event

type dw_off_service from datawindow within w_payment_expenses
string tag = "off_service"
integer x = 27
integer y = 1712
integer width = 2199
integer height = 516
integer taborder = 50
string title = " none"
string dataobject = "d_contract_off_service"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;string ls_color
long 		ll_row

idw_current = this
ll_row = this.getSelectedRow(0)
this.selectrow(0, false)
if ll_row > 0 then
	this.selectrow(ll_row, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
ls_color = dw_payment.Object.Datawindow.Color
this.Object.DataWindow.Color='16777215'
dw_port_exp.Object.DataWindow.Color=ls_color
dw_non_port_exp.Object.DataWindow.Color=ls_color
dw_bunker_on_delivery.Object.DataWindow.Color=ls_color

end event

event rowfocuschanged;IF currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
END IF
end event

type dw_non_port_exp from datawindow within w_payment_expenses
string tag = "non_port_exp"
integer x = 27
integer y = 524
integer width = 3255
integer height = 516
integer taborder = 20
string title = "none"
string dataobject = "d_contract_non_port_exp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;string ls_color
long 		ll_row

idw_current = this
ll_row = this.getSelectedRow(0)
idw_current.selectrow(0, false)
if ll_row > 0 then
	this.selectrow(ll_row, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
ls_color = dw_payment.Object.Datawindow.Color
this.Object.DataWindow.Color='16777215'
dw_port_exp.Object.DataWindow.Color=ls_color
dw_off_service.Object.DataWindow.Color=ls_color
dw_bunker_on_delivery.Object.DataWindow.Color=ls_color


end event

event rowfocuschanged;IF currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
END IF
end event

type dw_port_exp from datawindow within w_payment_expenses
string tag = "port_exp"
integer x = 27
integer y = 1120
integer width = 2478
integer height = 516
integer taborder = 40
string title = "none"
string dataobject = "d_contract_port_exp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;string ls_color
long 		ll_row

idw_current = this
ll_row = this.getSelectedRow(0)
idw_current.selectrow(0, false)
if ll_row > 0 then
	this.selectrow(ll_row, true)
else
	if this.rowcount() > 0 then
		this.selectRow(1, true)
	end if
end if
ls_color = dw_payment.Object.Datawindow.Color
this.Object.DataWindow.Color='16777215'
dw_non_port_exp.Object.DataWindow.Color=ls_color
dw_off_service.Object.DataWindow.Color=ls_color
dw_bunker_on_delivery.Object.DataWindow.Color=ls_color

end event

event rowfocuschanged;IF currentrow > 0 then
	this.selectRow(0, false)
	this.selectRow(currentrow, true)
END IF
end event

type gb_filter from groupbox within w_payment_expenses
integer x = 3840
integer y = 1212
integer width = 773
integer height = 336
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Filter - Expenses"
end type

type r_1 from rectangle within w_payment_expenses
long linecolor = 12639424
long fillcolor = 12639424
integer x = 3685
integer y = 624
integer width = 928
integer height = 476
end type

