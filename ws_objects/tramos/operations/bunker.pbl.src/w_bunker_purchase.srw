$PBExportHeader$w_bunker_purchase.srw
$PBExportComments$This window lists all proceedings, and lets the user create, modify or delete a bunker purchase for a proceeding. The user can create etc a bunker purchase for Fuel, diesel and gas oil.
forward
global type w_bunker_purchase from w_vessel_basewindow
end type
type dw_bp_list from uo_datawindow within w_bunker_purchase
end type
type cb_list from commandbutton within w_bunker_purchase
end type
type dw_bpd from datawindow within w_bunker_purchase
end type
type cb_1 from commandbutton within w_bunker_purchase
end type
type cb_delete from commandbutton within w_bunker_purchase
end type
type cb_update from commandbutton within w_bunker_purchase
end type
type cb_new from commandbutton within w_bunker_purchase
end type
type cb_test from commandbutton within w_bunker_purchase
end type
end forward

global type w_bunker_purchase from w_vessel_basewindow
integer x = 0
integer y = 0
integer width = 4494
integer height = 2568
string title = "Bunker Purchase"
boolean maxbox = false
string icon = "images\BP.ICO"
event ue_retrieve pbm_custom14
dw_bp_list dw_bp_list
cb_list cb_list
dw_bpd dw_bpd
cb_1 cb_1
cb_delete cb_delete
cb_update cb_update
cb_new cb_new
cb_test cb_test
end type
global w_bunker_purchase w_bunker_purchase

type prototypes
Function Integer SndPlaySound ( String filename, Integer flag ) Library "mmsystem.dll" alias for "SndPlaySound;Ansi"
end prototypes

type variables
n_bunker_purchase	inv_bp
string is_purpose
end variables

forward prototypes
private function integer _validate_paymentstatus (string as_type)
public subroutine documentation ()
end prototypes

event ue_retrieve;call super::ue_retrieve;dw_bp_list.Retrieve(ii_vessel_nr)
dw_bpd.reset( )
commit;
dw_bp_list.ScrollToRow(dw_bp_list.RowCount())

end event

private function integer _validate_paymentstatus (string as_type);/********************************************************************
   _validate_paymentstatus
   <DESC>Check if related TC contracts (either IN or OUT) have statement with status New or Draft.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_type:Delete/create
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	 Author             Comments
   	2012-05-09 M5-12            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count_payment
long ll_row
integer li_vessel, li_pcn
string ls_voyage, ls_port, ls_message

ll_row = dw_bp_list.getrow()
if ll_row <= 0 then return c#return.Failure
if is_purpose ="DEL" or is_purpose = "RED" then
	li_vessel =dw_bp_list.GetItemNumber (ll_row, "vessel_nr" )
	ls_voyage = dw_bp_list.GetItemString (ll_row, "voyage_nr" )
	ls_port = dw_bp_list.GetItemString (ll_row, "port_code" )
	li_pcn = dw_bp_list.GetItemNumber (ll_row, "pcn" )
	
	SELECT count(*)  
	INTO :ll_count_payment  
	FROM NTC_PAYMENT, POC 
	WHERE (NTC_PAYMENT.CONTRACT_ID = POC.CONTRACT_ID ) AND
			(POC.VESSEL_NR =:li_vessel) AND
			(POC.VOYAGE_NR =:ls_voyage) AND
			(POC.PORT_CODE =:ls_port) AND
			(POC.PCN =:li_pcn) AND
			(NTC_PAYMENT.PAYMENT_STATUS <= 2 );
	
	ls_message = "It is not possible to"+ as_type +"the bunker purchase of type Buy/Sell from/to Owner/Charterer," +&
				"because there is no payment with status New or Draft in the TC contract. " +&
				"Please contact Finance for assistance with unsettling or unlocking the final hire statement."
	
	if ll_count_payment = 0 then
		MessageBox("Validation", ls_message)
		return c#return.Failure
	end if
end if
return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   w_bunker_purchase
   <OBJECT></OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		2012-06-14	M5-12 		RJH022      If the Port purpose is DEL or RED,
														and there is no payment with status New or Draft in the TC contract, 
														it is not possible to create/change the bunker purchase of type
														Buy/Sell from/to Owner/Charterer.
		2012-11-05	CR2780		LHC010		if the statement carrying this bunker purchase detail is set to any of ‘Final’, ‘Part-paid’ or ‘Paid’, 
														the current data in the bunker purchase window for this delivery/redelivery port must be locked.
		12/09/14  	CR3773		XSZ004		Change icon absolute path to reference path																
   </HISTORY>
********************************************************************/


end subroutine

event open;call super::open;this.Move(0,0)

inv_bp = create n_bunker_purchase
inv_bp.of_sharedatastores( dw_bpd )

dw_bp_list.setTransObject(sqlca)

/* External APM no access to buttons */
if uo_global.ii_access_level = -1 then
	cb_new.enabled = false
	cb_update.enabled = false
	cb_delete.enabled = false
end if

uo_vesselselect.of_registerwindow( w_bunker_purchase )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

IF (uo_global.ib_rowsindicator) then
	dw_bp_list.SetRowFocusIndicator(FocusRect!)
end if

end event

on w_bunker_purchase.create
int iCurrent
call super::create
this.dw_bp_list=create dw_bp_list
this.cb_list=create cb_list
this.dw_bpd=create dw_bpd
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.cb_update=create cb_update
this.cb_new=create cb_new
this.cb_test=create cb_test
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_bp_list
this.Control[iCurrent+2]=this.cb_list
this.Control[iCurrent+3]=this.dw_bpd
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.cb_update
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.cb_test
end on

on w_bunker_purchase.destroy
call super::destroy
destroy(this.dw_bp_list)
destroy(this.cb_list)
destroy(this.dw_bpd)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.cb_update)
destroy(this.cb_new)
destroy(this.cb_test)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(dw_bp_list , "vessel_nr", "voyage_nr", True)

end event

event closequery;call super::closequery;dw_bpd.acceptText()
if dw_bpd.ModifiedCount() + dw_bpd.deletedcount( ) > 0 then
	If MessageBox("Information", "You are about to close this window with data not saved. Would you like to update?",Question!,YesNo!,1) = 1 then
		return 1
	end if
end if
end event

event close;call super::close;if isvalid(inv_bp) then
	destroy inv_bp
end if
end event

event ue_refresh;call super::ue_refresh;string 	ls_voyage, ls_portcode, ls_searchstring
integer	li_pcn
long		ll_row, ll_found

ll_row = dw_bp_list.getselectedRow(0)
if ll_row > 0 then
	ls_voyage 	= dw_bp_list.getItemString(ll_row, "voyage_nr")
	ls_portcode 	= dw_bp_list.getItemString(ll_row, "port_code")
	li_pcn			= dw_bp_list.getItemNumber(ll_row, "pcn")
end if

dw_bp_list.Retrieve(ii_vessel_nr)
commit;
dw_bpd.reset( )

if ll_row < 1 then
	ll_found = dw_bp_list.RowCount()
else
	ls_searchstring = "voyage_nr='"+ls_voyage+"' and port_code = '"+ls_portcode+"' and pcn="+string(li_pcn)
	ll_found = dw_bp_list.find(ls_searchstring, 1, dw_bp_list.rowcount( ))
	if ll_found < 1 then
		ll_found = dw_bp_list.RowCount()
	end if
end if

dw_bp_list.ScrollToRow(ll_found)
dw_bp_list.post event clicked(0,0,ll_found,dw_bp_list.object)

end event

event doubleclicked;call super::doubleclicked;cb_test.visible = not cb_test.visible
end event

event ue_vesselselection;call super::ue_vesselselection;postevent("ue_retrieve")
end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_bunker_purchase
integer x = 27
end type

type dw_bp_list from uo_datawindow within w_bunker_purchase
integer x = 23
integer y = 220
integer width = 1211
integer height = 2220
integer taborder = 20
string dataobject = "d_bunker_purchase_select_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;integer	li_vessel, li_pcn, li_voyage_finished, li_paymentstatus
string		ls_voyage, ls_port
long	ll_currentrow

IF row < 1 THEN return

this.SelectRow(0,FALSE)
this.SelectRow(row,TRUE)
li_vessel =this.GetItemNumber ( row,"vessel_nr" )
ls_voyage = this.GetItemString ( row,"voyage_nr" )
ls_port = this.GetItemString ( row,"port_code" )
is_purpose = this.getitemstring(row, "purpose_code")
li_pcn = this.GetItemNumber ( row,"pcn" )
li_voyage_finished = this.getItemNumber(row, "voyage_finished")
 
inv_bp.of_retrieve(li_vessel,ls_voyage,ls_port,li_pcn )

ll_currentrow = dw_bpd.getrow( )

if ll_currentrow > 0 then
	li_paymentstatus = dw_bpd.getitemnumber( ll_currentrow, "payment_status")
end if

//Unable to modify or delete the bunker purchase if voyage is finished or payment status is 'Final','Part-paid' or 'Paid'
if li_voyage_finished = 1  or uo_global.ii_access_level = -1 or li_paymentstatus > 2 then
	cb_new.enabled = false
	cb_update.enabled = false
	cb_delete.enabled = false
else
	cb_new.enabled = true
	cb_update.enabled = true
	cb_delete.enabled = true
end if	

commit;

//Set_Buttons()

end event

type cb_list from commandbutton within w_bunker_purchase
integer x = 2638
integer y = 2340
integer width = 343
integer height = 100
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&List"
end type

event clicked;u_jump_bp_list		luo_jump_bp

luo_jump_bp = CREATE u_jump_bp_list
luo_jump_bp.of_open_bp_list(ii_vessel_nr)

DESTROY luo_jump_bp	


end event

type dw_bpd from datawindow within w_bunker_purchase
integer x = 1257
integer y = 20
integer width = 3182
integer height = 2280
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_bp_detail"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;IF uo_global.ii_access_level = -1 THEN 
	this.Object.Datawindow.ReadOnly="Yes"
END IF
end event

event itemchanged;decimal ld_tmp
dwItemStatus ldwi_status

choose case dwo.name
	case "ordered_hfo", "ordered_do", "ordered_go", "ordered_lshfo", "lifted_hfo", "lifted_do", "lifted_go", "lifted_lshfo"
		if this.getItemNumber(row, "buy_sell") = 1 then
			// Set automatic minus in lifted or ordered
			ld_tmp = dec(data)
			If ld_tmp > 0 Then 
				This.SetItem(row, string(dwo.name), - ld_tmp)
				Return 2
			End if
		end if

	case "owner_pool_purchase_or_chart"
		/*Added by RJH022 on 2012-05-09. Change desc: If the Port purpose is DEL or RED, 
		and there is no payment with status New or Draft in the TC contract, 
		it is not possible to create/change the bunker purchase of type Buy/Sell from/to Owner/Charterer.*/
		if (is_purpose ="DEL" or is_purpose = "RED") and data <> "1" then
			if _validate_paymentstatus("create") = c#return.Failure  then return 2
		end if
end choose

end event

type cb_1 from commandbutton within w_bunker_purchase
integer x = 4101
integer y = 2340
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;Close(parent)
end event

type cb_delete from commandbutton within w_bunker_purchase
integer x = 3735
integer y = 2340
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;long 		ll_delrow ,ll_row, ll_purchase_or_chart
integer	li_countBP
string ls_purpose
//f_show_transaction_count("BP before delete")

open(w_bunker_update_splash)
setPointer(Hourglass!)

ll_delrow = dw_bpd.getRow()
if ll_delrow <= 0 then return
/*Added by RJH022 on 2012-05-09. Change desc: If the Port purpose is DEL or RED, 
and there is no payment with status New or Draft in the TC contract, 
it is not possible to delete the bunker purchase of type Buy/Sell from/to Owner/Charterer.*/
ll_purchase_or_chart = dw_bpd.getitemnumber(ll_delrow, "owner_pool_purchase_or_chart")

if ll_purchase_or_chart <> 1 then
	if _validate_paymentstatus("delete") = c#return.Failure then
		if isValid(w_bunker_update_splash) then close(w_bunker_update_splash)
		return 
	end if
end if

if inv_bp.of_delete_order(ll_delrow) = 1 then
	if dw_bpd.rowCount() > 0 then
		li_countBP = 1
	else
		li_countBP = 0
	end if
	ll_row = dw_bp_list.getSelectedRow(0)
	if ll_row > 0 then
		dw_bp_list.setItem(ll_row, "count_bp", li_countBP)
	end if
end if	
/* set focus to dw_bunker_purchase */
dw_bpd.SetFocus()
dw_bpd.setColumn("supplier")

if isValid(w_bunker_update_splash) then
	close(w_bunker_update_splash)
end if
setPointer(Arrow!)

//f_show_transaction_count("BP after delete")

end event

type cb_update from commandbutton within w_bunker_purchase
integer x = 3369
integer y = 2340
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;integer	li_countBP
long		ll_row

open(w_bunker_update_splash)
setPointer(Hourglass!)
 
dw_bpd.accepttext( )
 
if inv_bp.of_update( ) = 1 then
	commit;
	if dw_bpd.rowCount() > 0 then
		li_countBP = 1
	else
		li_countBP = 0
	end if
	ll_row = dw_bp_list.getSelectedRow(0)
	if ll_row > 0 then
		dw_bp_list.setItem(ll_row, "count_bp", li_countBP)
	end if
else
	rollback;
end if	

if isValid(w_bunker_update_splash) then
	close(w_bunker_update_splash)
end if
setPointer(Arrow!)


end event

type cb_new from commandbutton within w_bunker_purchase
integer x = 3003
integer y = 2340
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;long	ll_row

if dw_bp_list.getSelectedRow(0) < 1 then
	MessageBox("Information", "Please select a Voyage/Port before creating a new order!")
	return
end if

ll_row = inv_bp.of_new_order( )

if ll_row = -1 then return

dw_bpd.ScrollToRow(ll_row)

/* set focus to dw_bunker_purchase */
dw_bpd.SetFocus()
dw_bpd.setColumn("supplier")

end event

type cb_test from commandbutton within w_bunker_purchase
boolean visible = false
integer x = 1806
integer y = 2340
integer width = 343
integer height = 100
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "TEST"
end type

event clicked;open (w_test_bunker_calculation)
end event

