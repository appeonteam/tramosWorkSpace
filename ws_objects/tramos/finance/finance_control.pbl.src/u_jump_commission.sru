$PBExportHeader$u_jump_commission.sru
forward
global type u_jump_commission from nonvisualobject
end type
end forward

global type u_jump_commission from nonvisualobject
end type
global u_jump_commission u_jump_commission

forward prototypes
public subroutine of_open_commission (long al_broker_nr, integer ai_vessel_nr, string as_voyage_nr, string as_claimtype, long al_claim_nr, string as_invoice, decimal ad_amount)
public subroutine of_open_tc_commission (long al_broker_nr, long al_paymentid)
end prototypes

public subroutine of_open_commission (long al_broker_nr, integer ai_vessel_nr, string as_voyage_nr, string as_claimtype, long al_claim_nr, string as_invoice, decimal ad_amount);long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_commission) THEN
	w_commission.TriggerEvent(Open!)
ELSE
	Opensheet(w_commission,w_tramos_main,0,Original!)
END IF

w_commission.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

w_commission.cbx_selecttc.checked = false
w_commission.of_set_broker_no(al_broker_nr)
w_commission.retrieve_commission(ai_vessel_nr, as_voyage_nr, as_claimtype, al_claim_nr, as_invoice, ad_amount )

w_commission.dw_commission.setfocus()

w_commission.SetRedraw(TRUE)
w_commission.setfocus()

Return

end subroutine

public subroutine of_open_tc_commission (long al_broker_nr, long al_paymentid);long ll_row, ll_found

// uo_global.setvessel_nr(ai_vessel_nr)
// uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_ntc_commission) THEN
	w_ntc_commission.TriggerEvent(Open!)
ELSE
	Opensheet(w_ntc_commission,w_tramos_main,0,Original!)
END IF

w_ntc_commission.SetRedraw(FALSE)

//w_ntc_commission.cbx_selecttc.checked = true

w_ntc_commission.of_set_broker_no(al_broker_nr)
w_ntc_commission.retrieve_commission(al_paymentid)


w_ntc_commission.dw_tc_commission.setfocus()

w_ntc_commission.SetRedraw(TRUE)
w_ntc_commission.setfocus()

Return

end subroutine

on u_jump_commission.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_commission.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

