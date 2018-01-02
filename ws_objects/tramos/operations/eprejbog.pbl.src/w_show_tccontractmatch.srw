$PBExportHeader$w_show_tccontractmatch.srw
forward
global type w_show_tccontractmatch from mt_w_response
end type
type cb_ok from mt_u_commandbutton within w_show_tccontractmatch
end type
type st_1 from mt_u_statictext within w_show_tccontractmatch
end type
type dw_1 from u_ntchire_dw within w_show_tccontractmatch
end type
type st_6 from mt_u_statictext within w_show_tccontractmatch
end type
type st_7 from mt_u_statictext within w_show_tccontractmatch
end type
type st_8 from mt_u_statictext within w_show_tccontractmatch
end type
type st_9 from mt_u_statictext within w_show_tccontractmatch
end type
type cb_cancel from mt_u_commandbutton within w_show_tccontractmatch
end type
type dw_bunker from mt_u_datawindow within w_show_tccontractmatch
end type
end forward

global type w_show_tccontractmatch from mt_w_response
integer width = 2761
integer height = 1740
string title = "Transfer Off-Hire to TC Hire"
boolean ib_setdefaultbackgroundcolor = true
event type integer ue_set_defaulttransfer ( )
event type integer ue_cancel ( )
cb_ok cb_ok
st_1 st_1
dw_1 dw_1
st_6 st_6
st_7 st_7
st_8 st_8
st_9 st_9
cb_cancel cb_cancel
dw_bunker dw_bunker
end type
global w_show_tccontractmatch w_show_tccontractmatch

type variables
mt_n_datastore ids_data
s_tc_trans_fuel istr_fuel
s_tc_trans_fuel istr_fuel_original
blob iblob_original_state

// save selection for fifo
integer ii_fifo_lshfo_sel = 0
integer ii_fifo_do_sel = 0
integer ii_fifo_go_sel = 0
integer ii_fifo_hfo_sel = 0
end variables

forward prototypes
private function integer _validate_paymentstatus (long al_contract_id)
public subroutine documentation ()
public function integer _init_bunker_options ()
public function boolean _has_tcout_transfer ()
public function boolean _has_tcin_transfer ()
public function integer _enable_bunker_option (string as_type, boolean ab_switch, boolean ab_has_tcin_transfer, boolean ab_has_tcout_transfer)
private function integer _restore_state (boolean ab_hastcin, boolean ab_hastcout)
public function integer _save_state (long al_tc, boolean ab_hastcin, boolean ab_hastcout)
end prototypes

event type integer ue_set_defaulttransfer();/********************************************************************
   ue_set_defaulttransfer
   <DESC>Set transfer option based on related TC contracts (either IN or OUT) statement status.
	      If at least one open payment (New or Draft) exists, transfer option is set as default "Yes", otherwise it is set as "No". 
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       	 Author             Comments
   	2012-05-10 M5-12            RJH022        First Version
		10/11/2015 CR3133           SSX014        Remember transfer flags
   </HISTORY>
********************************************************************/

long ll_count_contract, ll_contract_id, ll_contract, ll_count_payment
long ll_tc_hire_in

if istr_fuel.transfer_saved = 0 then
	
	ll_count_contract = dw_1.rowcount( )
	for ll_contract = 1 to ll_count_contract
		ll_contract_id = dw_1.getitemnumber(ll_contract, "contract_id")
		
		SELECT count(*)  
		INTO :ll_count_payment  
		FROM NTC_PAYMENT  
		WHERE (NTC_PAYMENT.CONTRACT_ID = :ll_contract_id ) AND  
				(NTC_PAYMENT.PAYMENT_STATUS <= 2 ) ;
		  
		if ll_count_payment > 0 then
			dw_1.setitem(ll_contract, "transfer", 1)
		else
			dw_1.setitem(ll_contract, "transfer", 0)
		end if
	next
	
else
	// restore to the last selection
	ll_count_contract = dw_1.rowcount( )
	for ll_contract = 1 to ll_count_contract
		ll_tc_hire_in = dw_1.getitemnumber(ll_contract, "ntc_tc_contract_tc_hire_in")
		if ll_tc_hire_in = 1 then
			dw_1.setitem(ll_contract, "transfer", istr_fuel.tcin_transfer)
		else
			dw_1.setitem(ll_contract, "transfer", istr_fuel.tcout_transfer)
		end if
	next

end if

return c#return.Success
end event

event type integer ue_cancel();dw_1.sharedataoff()
ids_data.setfullstate(iblob_original_state)
ids_data.settransobject(SQLCA)
istr_fuel = istr_fuel_original

ids_data.sharedata(dw_1)
event ue_set_defaulttransfer()
_init_bunker_options()

return 1

end event

private function integer _validate_paymentstatus (long al_contract_id);/********************************************************************
   _validate_paymentstatus
   <DESC>Check if related TC contracts (either IN or OUT) have statement with status New or Draft. </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_contract_id
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	 Author             Comments
   	2012-05-08 M5-12            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count

if isNull(al_contract_id) then return c#return.Failure

SELECT count(*)  
INTO :ll_count  
FROM NTC_PAYMENT  
WHERE ( NTC_PAYMENT.CONTRACT_ID = :al_contract_id ) AND  
        ( NTC_PAYMENT.PAYMENT_STATUS <= 2 ) ;
		  
if isnull(ll_count) then ll_count = 0

if ll_count <= 0 then
	messagebox("Validation", "It is not possible to transfer the Off-Hire to the TC contract, " +&
										"because there is no payment with status New or Draft." +&
										"Please contact Finance for assistance with unsettling or unlocking the final hire statement.") 
	return c#return.Failure
end if	

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   w_show_tccontractmatch
   <OBJECT></OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref       		Author             Comments
   	2012-06-14 M5-12            	RJH022             inherit from mt_w_response
		11/11/2015 CR3133             SSX014             new layout and logic
   </HISTORY>
********************************************************************/


end subroutine

public function integer _init_bunker_options ();n_voyage_offservice_bunker_consumption 	lnv_bunker
decimal {4} ld_proposed_price, ld_null
boolean lb_has_tcin_transfer, lb_has_tcout_transfer

setnull(ld_null)

/* Set amount values from structure into window */
dw_bunker.setitem(1, "sd_amount_hfo", istr_fuel.sd_amount_hfo)
dw_bunker.setitem(1, "sd_amount_do", istr_fuel.sd_amount_do)
dw_bunker.setitem(1, "sd_amount_go", istr_fuel.sd_amount_go)
dw_bunker.setitem(1, "sd_amount_lshfo", istr_fuel.sd_amount_lshfo)

/* If this is a tc in then ... */
IF istr_fuel.sb_tc_in then
	
	// create the offservice bunker consumption
	lnv_bunker = create n_voyage_offservice_bunker_consumption
	
	/* Set the prices for the fuels in the window to calculated price */
	if istr_fuel.sd_amount_hfo <> 0 then
		
		// initialize price proprosal 
		ld_proposed_price = 0
		
		// propose the price
		lnv_bunker.of_price_proposal( &
			"HFO", &
			istr_fuel.si_vessel_nr ,  &
			istr_fuel.ss_voyage_nr,  &
			istr_fuel.sdt_offservice_start, &
			istr_fuel.sd_hfo_start , &
			istr_fuel.sd_amount_hfo , &
			ld_proposed_price, &
			istr_fuel.sdt_offservice_end &
			)
		
		// get the proposed price 
		dw_bunker.setitem(1, "sd_fifo_hfo", ld_proposed_price)
		
	else
		dw_bunker.setitem(1, "sd_fifo_hfo", ld_null)
	end if
	
	if istr_fuel.sd_amount_do <> 0 then
		ld_proposed_price = 0
		lnv_bunker.of_price_proposal( &
			"DO", &
			istr_fuel.si_vessel_nr ,  &
			istr_fuel.ss_voyage_nr,  &
			istr_fuel.sdt_offservice_start, &
			istr_fuel.sd_do_start , &
			istr_fuel.sd_amount_do , &
			ld_proposed_price, &
			istr_fuel.sdt_offservice_end &
			)
		dw_bunker.setitem(1, "sd_fifo_do", ld_proposed_price)
	else
		dw_bunker.setitem(1, "sd_fifo_do", ld_null)
	end if
	
	if istr_fuel.sd_amount_go <> 0 then	
		ld_proposed_price = 0
		lnv_bunker.of_price_proposal( &
			"GO", &
			istr_fuel.si_vessel_nr ,  &
			istr_fuel.ss_voyage_nr,  &
			istr_fuel.sdt_offservice_start, &
			istr_fuel.sd_go_start , &
			istr_fuel.sd_amount_go , &
			ld_proposed_price, &
			istr_fuel.sdt_offservice_end &
			)
		dw_bunker.setitem(1, "sd_fifo_go", ld_proposed_price)
	else
		dw_bunker.setitem(1, "sd_fifo_go", ld_null)
	end if
	
	if istr_fuel.sd_amount_lshfo <> 0 then
		ld_proposed_price = 0
		lnv_bunker.of_price_proposal( &
			"LSHFO", &
			istr_fuel.si_vessel_nr ,  &
			istr_fuel.ss_voyage_nr,  &
			istr_fuel.sdt_offservice_start, &
			istr_fuel.sd_lshfo_start , &
			istr_fuel.sd_amount_lshfo , &
			ld_proposed_price, &
			istr_fuel.sdt_offservice_end &
			)
		dw_bunker.setitem(1, "sd_fifo_lshfo", ld_proposed_price)
	else
		dw_bunker.setitem(1, "sd_fifo_lshfo", ld_null)
	end if
	
	destroy lnv_bunker
	
/* else if this is a tc out then ... */
else
	/* Set the prices for the fuels in the window to 0 */
	dw_bunker.setitem(1, "sd_fifo_hfo", ld_null)
	dw_bunker.setitem(1, "sd_fifo_do", ld_null)
	dw_bunker.setitem(1, "sd_fifo_go", ld_null)
	dw_bunker.setitem(1, "sd_fifo_lshfo", ld_null)
end if

lb_has_tcin_transfer = _has_tcin_transfer()
lb_has_tcout_transfer = _has_tcout_transfer()

if lb_has_tcin_transfer and lb_has_tcout_transfer then
	if not (istr_fuel.hfo_sel_in = 1 and istr_fuel.hfo_sel_out = 1 ) and istr_fuel.sd_amount_hfo <> 0 then
		ii_fifo_hfo_sel = 1
	end if
	if not (istr_fuel.do_sel_in = 1 and istr_fuel.do_sel_out = 1 ) and istr_fuel.sd_amount_do <> 0 then
		ii_fifo_do_sel = 1
	end if
	if not (istr_fuel.go_sel_in = 1 and istr_fuel.go_sel_out = 1 ) and istr_fuel.sd_amount_go <> 0 then
		ii_fifo_go_sel = 1
	end if
	if not (istr_fuel.lshfo_sel_in = 1 and istr_fuel.lshfo_sel_out = 1 ) and istr_fuel.sd_amount_lshfo <> 0 then
		ii_fifo_lshfo_sel = 1
	end if
end if

_enable_bunker_option( "lshfo", not (istr_fuel.sd_amount_lshfo = 0 or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
	lb_has_tcin_transfer, lb_has_tcout_transfer )
_enable_bunker_option( "go", not (istr_fuel.sd_amount_go = 0 or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
	lb_has_tcin_transfer, lb_has_tcout_transfer )
_enable_bunker_option( "do", not (istr_fuel.sd_amount_do = 0  or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
	lb_has_tcin_transfer, lb_has_tcout_transfer )
_enable_bunker_option( "hfo", not (istr_fuel.sd_amount_hfo = 0  or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
	lb_has_tcin_transfer, lb_has_tcout_transfer )

return 1

end function

public function boolean _has_tcout_transfer ();string ls_findexpr
long ll_rowfound

ls_findexpr = "(ntc_tc_contract_tc_hire_in = 0 or isnull(ntc_tc_contract_tc_hire_in)) and transfer = 1"

ll_rowfound = ids_data.find(ls_findexpr, 1, ids_data.rowcount())

return (ll_rowfound > 0)

end function

public function boolean _has_tcin_transfer ();string ls_findexpr
long ll_rowfound

ls_findexpr = "(ntc_tc_contract_tc_hire_in = 1) and (transfer = 1)"

ll_rowfound = ids_data.find(ls_findexpr, 1, ids_data.rowcount())

return (ll_rowfound > 0)

end function

public function integer _enable_bunker_option (string as_type, boolean ab_switch, boolean ab_has_tcin_transfer, boolean ab_has_tcout_transfer);decimal ld_null
boolean lb_has_tcout_transfer, lb_has_tcin_transfer
string ls_modify

setnull(ld_null)
lb_has_tcin_transfer = ab_has_tcin_transfer
lb_has_tcout_transfer = ab_has_tcout_transfer

choose case as_type
	case "lshfo"
		
		dw_bunker.modify("sd_fifo_lshfo.protect=1")
		dw_bunker.modify("sd_fifo_lshfo.background.model=1")

		if ab_switch then
			if istr_fuel.lshfo_sel_in = 1 or istr_fuel.lshfo_sel_out = 1 then
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_lshfo_sel", ii_fifo_lshfo_sel)
				else
					dw_bunker.setitem(1, "sb_fifo_lshfo_sel", 0)
				end if
			else
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_lshfo_sel", 1)
				else
					dw_bunker.setitem(1, "sb_fifo_lshfo_sel", 0)
				end if
			end if
			if lb_has_tcin_transfer or lb_has_tcout_transfer then
				dw_bunker.modify("sb_fifo_lshfo_sel.protect=0")
			else
				dw_bunker.modify("sb_fifo_lshfo_sel.protect=1")
			end if
			
			if lb_has_tcin_transfer then
				dw_bunker.modify("sb_in_lshfo_sel.protect=0")
				dw_bunker.modify("sd_price_lshfo_in.protect='0~tif(sb_in_lshfo_sel=1,0,1)'")
				dw_bunker.modify("sd_price_lshfo_in.background.mode='0~tif(sb_in_lshfo_sel=1,0,1)' sd_price_lshfo_in.background.color=1073741824")
				dw_bunker.setitem(1, "sb_in_lshfo_sel", istr_fuel.lshfo_sel_in)
			else
				dw_bunker.modify("sb_in_lshfo_sel.protect=1")
				dw_bunker.modify("sd_price_lshfo_in.protect=1")
				dw_bunker.modify("sd_price_lshfo_in.background.mode=1")
				dw_bunker.setitem(1, "sb_in_lshfo_sel", 0)
			end if
			
			if lb_has_tcout_transfer then
				dw_bunker.modify("sb_out_lshfo_sel.protect=0")
				dw_bunker.modify("sd_price_lshfo_out.protect='0~tif(sb_out_lshfo_sel=1,0,1)'")
				dw_bunker.modify("sd_price_lshfo_out.background.mode='0~tif(sb_out_lshfo_sel=1,0,1)' sd_price_lshfo_out.background.color=1073741824")
				dw_bunker.setitem(1, "sb_out_lshfo_sel", istr_fuel.lshfo_sel_out)
			else
				dw_bunker.modify("sb_out_lshfo_sel.protect=1")
				dw_bunker.modify("sd_price_lshfo_out.protect=1")				
				dw_bunker.modify("sd_price_lshfo_out.background.mode=1")
				dw_bunker.setitem(1, "sb_out_lshfo_sel", 0)
			end if
			
			dw_bunker.setitem(1, "sd_price_lshfo_out", istr_fuel.sd_price_lshfo_out)
			dw_bunker.setitem(1, "sd_price_lshfo_in", istr_fuel.sd_price_lshfo)
		else
			dw_bunker.setitem(1, "sb_fifo_lshfo_sel", 0)
			dw_bunker.modify("sb_fifo_lshfo_sel.protect=1")
			
			dw_bunker.modify("sb_out_lshfo_sel.protect=1")
			dw_bunker.modify("sd_price_lshfo_out.protect=1")
			dw_bunker.modify("sd_price_lshfo_out.background.mode=1")
			
			dw_bunker.modify("sb_in_lshfo_sel.protect=1")
			dw_bunker.modify("sd_price_lshfo_in.protect=1")
			dw_bunker.modify("sd_price_lshfo_in.background.mode=1")
			
			dw_bunker.setitem(1, "sb_out_lshfo_sel", 0)
			dw_bunker.setitem(1, "sd_price_lshfo_out", ld_null)
			
			dw_bunker.setitem(1, "sb_in_lshfo_sel", 0)
			dw_bunker.setitem(1, "sd_price_lshfo_in", ld_null)
			
		end if
		
	case "do"
		
		dw_bunker.modify("sd_fifo_do.protect=1")
		dw_bunker.modify("sd_fifo_do.background.model=1")
			
		if ab_switch then
			if istr_fuel.do_sel_in = 1 or istr_fuel.do_sel_out = 1 then
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_do_sel", ii_fifo_do_sel)
				else
					dw_bunker.setitem(1, "sb_fifo_do_sel", 0)
				end if
			else
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_do_sel", 1)
				else
					dw_bunker.setitem(1, "sb_fifo_do_sel", 0)
				end if
			end if
			if lb_has_tcin_transfer or lb_has_tcout_transfer then
				dw_bunker.modify("sb_fifo_do_sel.protect=0")
			else
				dw_bunker.modify("sb_fifo_do_sel.protect=1")
			end if
			
			if lb_has_tcin_transfer then
				dw_bunker.modify("sb_in_do_sel.protect=0")
				dw_bunker.modify("sd_price_do_in.protect='0~tif(sb_in_do_sel=1,0,1)'")
				dw_bunker.modify("sd_price_do_in.background.mode='0~tif(sb_in_do_sel=1,0,1)' sd_price_do_in.background.color=1073741824")
				dw_bunker.setitem(1, "sb_in_do_sel", istr_fuel.do_sel_in)
			else
				dw_bunker.modify("sb_in_do_sel.protect=1")
				dw_bunker.modify("sd_price_do_in.protect=1")
				dw_bunker.modify("sd_price_do_in.background.mode=1")
				dw_bunker.setitem(1, "sb_in_do_sel", 0)
			end if

			if lb_has_tcout_transfer then
				dw_bunker.modify("sb_out_do_sel.protect=0")
				dw_bunker.modify("sd_price_do_out.protect='0~tif(sb_out_do_sel=1,0,1)'")		
				dw_bunker.modify("sd_price_do_out.background.mode='0~tif(sb_out_do_sel=1,0,1)' sd_price_do_out.background.color=1073741824")
				dw_bunker.setitem(1, "sb_out_do_sel", istr_fuel.do_sel_out)
			else
				dw_bunker.modify("sb_out_do_sel.protect=1")
				dw_bunker.modify("sd_price_do_out.protect=1")		
				dw_bunker.modify("sd_price_do_out.background.mode=1")
				dw_bunker.setitem(1, "sb_out_do_sel", 0)
			end if

			dw_bunker.setitem(1, "sd_price_do_out", istr_fuel.sd_price_do_out)
			dw_bunker.setitem(1, "sd_price_do_in", istr_fuel.sd_price_do)
			
		else
			dw_bunker.setitem(1, "sb_fifo_do_sel", 0)
			dw_bunker.modify("sb_fifo_do_sel.protect=1")

			dw_bunker.modify("sb_in_do_sel.protect=1")
			dw_bunker.modify("sd_price_do_in.protect=1")
			dw_bunker.modify("sd_price_do_in.background.mode=1")
			
			dw_bunker.modify("sb_out_do_sel.protect=1")
			dw_bunker.modify("sd_price_do_out.protect=1")
			dw_bunker.modify("sd_price_do_out.background.mode=1")
			
			dw_bunker.setitem(1, "sb_out_do_sel", 0)
			dw_bunker.setitem(1, "sd_price_do_out", ld_null)

			dw_bunker.setitem(1, "sb_in_do_sel", 0)
			dw_bunker.setitem(1, "sd_price_do_in", ld_null)
		end if
		
	case "go"

		dw_bunker.modify("sd_fifo_go.protect=1")
		dw_bunker.modify("sd_fifo_go.background.model=1")
	
		if ab_switch then
			if istr_fuel.go_sel_in = 1 or istr_fuel.go_sel_out = 1 then
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_go_sel", ii_fifo_go_sel)
				else
					dw_bunker.setitem(1, "sb_fifo_go_sel", 0)
				end if
			else
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_go_sel", 1)
				else
					dw_bunker.setitem(1, "sb_fifo_go_sel", 0)
				end if
			end if
			if lb_has_tcin_transfer or lb_has_tcout_transfer then
				dw_bunker.modify("sb_fifo_go_sel.protect=0")
			else
				dw_bunker.modify("sb_fifo_go_sel.protect=1")
			end if
			
			if lb_has_tcin_transfer then
				dw_bunker.modify("sb_in_go_sel.protect=0")
				dw_bunker.modify("sd_price_go_in.protect='0~tif(sb_in_go_sel=1,0,1)'")
				dw_bunker.modify("sd_price_go_in.background.mode='0~tif(sb_in_go_sel=1,0,1)' sd_price_go_in.background.color=1073741824")
				dw_bunker.setitem(1, "sb_in_go_sel", istr_fuel.go_sel_in)
			else
				dw_bunker.modify("sb_in_go_sel.protect=1")
				dw_bunker.modify("sd_price_go_in.protect=1")
				dw_bunker.modify("sd_price_go_in.background.mode=1")
				dw_bunker.setitem(1, "sb_in_go_sel", 0)
			end if
			
			if lb_has_tcout_transfer then
				dw_bunker.modify("sb_out_go_sel.protect=0")
				dw_bunker.modify("sd_price_go_out.protect='0~tif(sb_out_go_sel=1,0,1)'")
				dw_bunker.modify("sd_price_go_out.background.mode='0~tif(sb_out_go_sel=1,0,1)' sd_price_go_out.background.color=1073741824")
				dw_bunker.setitem(1, "sb_out_go_sel", istr_fuel.go_sel_out)
			else
				dw_bunker.modify("sb_out_go_sel.protect=1")
				dw_bunker.modify("sd_price_go_out.protect=1")		
				dw_bunker.modify("sd_price_go_out.background.mode=1")
				dw_bunker.setitem(1, "sb_out_go_sel", 0)
			end if
	
			dw_bunker.setitem(1, "sd_price_go_out", istr_fuel.sd_price_go_out)
			dw_bunker.setitem(1, "sd_price_go_in", istr_fuel.sd_price_go)
			
		else
			dw_bunker.setitem(1, "sb_fifo_go_sel", 0)
			dw_bunker.modify("sb_fifo_go_sel.protect=1")

			dw_bunker.modify("sb_in_go_sel.protect=1")
			dw_bunker.modify("sd_price_go_in.protect=1")
			dw_bunker.modify("sd_price_go_in.background.mode=1")
			
			dw_bunker.modify("sb_out_go_sel.protect=1")
			dw_bunker.modify("sd_price_go_out.protect=1")
			dw_bunker.modify("sd_price_go_out.background.mode=1")
			
			dw_bunker.setitem(1, "sb_out_go_sel", 0)
			dw_bunker.setitem(1, "sd_price_go_out", ld_null)
			
			dw_bunker.setitem(1, "sb_in_go_sel", 0)
			dw_bunker.setitem(1, "sd_price_go_in", ld_null)
		end if

	case "hfo"
		
		dw_bunker.modify("sd_fifo_hfo.protect=1")
		dw_bunker.modify("sd_fifo_hfo.background.mode=1")
		
		if ab_switch then
			if istr_fuel.hfo_sel_in = 1 or istr_fuel.hfo_sel_out = 1 then
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_hfo_sel", ii_fifo_hfo_sel)
				else
					dw_bunker.setitem(1, "sb_fifo_hfo_sel", 0)
				end if
			else
				if lb_has_tcin_transfer or lb_has_tcout_transfer then
					dw_bunker.setitem(1, "sb_fifo_hfo_sel", 1)
				else
					dw_bunker.setitem(1, "sb_fifo_hfo_sel", 0)
				end if
			end if
			if lb_has_tcin_transfer or lb_has_tcout_transfer then
				dw_bunker.modify("sb_fifo_hfo_sel.protect=0")
			else
				dw_bunker.modify("sb_fifo_hfo_sel.protect=1")
			end if
			
			if lb_has_tcin_transfer then
				dw_bunker.modify("sb_in_hfo_sel.protect=0")
				dw_bunker.modify("sd_price_hfo_in.protect='0~tif(sb_in_hfo_sel=1,0,1)'")
				dw_bunker.modify("sd_price_hfo_in.background.mode='0~tif(sb_in_hfo_sel=1,0,1)' sd_price_hfo_in.background.color=1073741824")
				dw_bunker.setitem(1, "sb_in_hfo_sel", istr_fuel.hfo_sel_in)
			else
				dw_bunker.modify("sb_in_hfo_sel.protect=1")
				dw_bunker.modify("sd_price_hfo_in.protect=1")
				dw_bunker.modify("sd_price_hfo_in.background.mode=1")
				dw_bunker.setitem(1, "sb_in_hfo_sel", 0)
			end if
			
			if lb_has_tcout_transfer then
				dw_bunker.modify("sb_out_hfo_sel.protect=0")
				dw_bunker.modify("sd_price_hfo_out.protect='0~tif(sb_out_hfo_sel=1,0,1)'")
				dw_bunker.modify("sd_price_hfo_out.background.mode='0~tif(sb_out_hfo_sel=1,0,1)' sd_price_hfo_out.background.color=1073741824")
				dw_bunker.setitem(1, "sb_out_hfo_sel", istr_fuel.hfo_sel_out)
			else
				dw_bunker.modify("sb_out_hfo_sel.protect=1")
				dw_bunker.modify("sd_price_hfo_out.protect=1")
				dw_bunker.modify("sd_price_hfo_out.background.mode=1")
				dw_bunker.setitem(1, "sb_out_hfo_sel", 0)
			end if

			dw_bunker.setitem(1, "sd_price_hfo_out", istr_fuel.sd_price_hfo_out)
			dw_bunker.setitem(1, "sd_price_hfo_in", istr_fuel.sd_price_hfo)
			
		else
			dw_bunker.setitem(1, "sb_fifo_hfo_sel", 0)
			dw_bunker.modify("sb_fifo_hfo_sel.protect=1")
			
			dw_bunker.modify("sb_in_hfo_sel.protect=1")
			dw_bunker.modify("sd_price_hfo_in.protect=1")
			dw_bunker.modify("sd_price_hfo_in.background.mode=1")
			
			dw_bunker.modify("sb_out_hfo_sel.protect=1")
			dw_bunker.modify("sd_price_hfo_out.protect=1")
			dw_bunker.modify("sd_price_hfo_out.background.mode=1")
			
			dw_bunker.setitem(1, "sb_out_hfo_sel", 0)
			dw_bunker.setitem(1, "sd_price_hfo_out", ld_null)
			
			dw_bunker.setitem(1, "sb_in_hfo_sel", 0)
			dw_bunker.setitem(1, "sd_price_hfo_in", ld_null)
		end if

	case else
		return -1
end choose

return 1
end function

private function integer _restore_state (boolean ab_hastcin, boolean ab_hastcout);if ab_hastcin and not ab_hastcout then
	if istr_fuel.lshfo_sel_in = 1 then
		ii_fifo_lshfo_sel = 0
	else
		ii_fifo_lshfo_sel = 1
	end if
	if istr_fuel.hfo_sel_in = 1 then
		ii_fifo_hfo_sel = 0
	else
		ii_fifo_hfo_sel = 1
	end if
	if istr_fuel.do_sel_in = 1 then
		ii_fifo_do_sel = 0
	else
		ii_fifo_do_sel = 1
	end if
	if istr_fuel.go_sel_in = 1 then
		ii_fifo_go_sel = 0
	else
		ii_fifo_go_sel = 1
	end if
elseif not ab_hastcin and ab_hastcout then
	if istr_fuel.lshfo_sel_out = 1 then
		ii_fifo_lshfo_sel = 0
	else
		ii_fifo_lshfo_sel = 1
	end if
	if istr_fuel.hfo_sel_out = 1 then
		ii_fifo_hfo_sel = 0
	else
		ii_fifo_hfo_sel = 1
	end if
	if istr_fuel.do_sel_out = 1 then
		ii_fifo_do_sel = 0
	else
		ii_fifo_do_sel = 1
	end if
	if istr_fuel.go_sel_out = 1 then
		ii_fifo_go_sel = 0
	else
		ii_fifo_go_sel = 1
	end if
elseif ab_hastcin and ab_hastcout then
	if istr_fuel.lshfo_sel_in = 1 and istr_fuel.lshfo_sel_out = 1 then
		ii_fifo_lshfo_sel = 0
	else
		ii_fifo_lshfo_sel = 1
	end if
	if istr_fuel.hfo_sel_in = 1 and istr_fuel.hfo_sel_out = 1 then
		ii_fifo_hfo_sel = 0
	else
		ii_fifo_hfo_sel = 1
	end if
	if istr_fuel.do_sel_in = 1 and istr_fuel.do_sel_out = 1 then
		ii_fifo_do_sel = 0
	else
		ii_fifo_do_sel = 1
	end if
	if istr_fuel.go_sel_in = 1 and istr_fuel.go_sel_out = 1 then
		ii_fifo_go_sel = 0
	else
		ii_fifo_go_sel = 1
	end if
else
	ii_fifo_lshfo_sel = 0
	ii_fifo_hfo_sel = 0
	ii_fifo_do_sel = 0
	ii_fifo_go_sel = 0
end if

return 1


end function

public function integer _save_state (long al_tc, boolean ab_hastcin, boolean ab_hastcout);dw_bunker.accepttext()


/* Set the structure to be returned to the actual TC-In prices in the fields */
istr_fuel.sd_price_hfo   = dw_bunker.getitemdecimal(1, "sd_price_hfo_in")
istr_fuel.sd_price_do    = dw_bunker.getitemdecimal(1, "sd_price_do_in")
istr_fuel.sd_price_go    = dw_bunker.getitemdecimal(1, "sd_price_go_in")
istr_fuel.sd_price_lshfo = dw_bunker.getitemdecimal(1, "sd_price_lshfo_in")
if al_tc = 1 or al_tc = 3 or ab_hastcin then
	istr_fuel.hfo_sel_in   = dw_bunker.getitemnumber(1, "sb_in_hfo_sel")
	istr_fuel.do_sel_in    = dw_bunker.getitemnumber(1, "sb_in_do_sel")
	istr_fuel.go_sel_in    = dw_bunker.getitemnumber(1, "sb_in_go_sel")
	istr_fuel.lshfo_sel_in = dw_bunker.getitemnumber(1, "sb_in_lshfo_sel")
end if

/* Set the structure to be returned to the actual TC-Out prices in the fields */
istr_fuel.sd_price_hfo_out   = dw_bunker.getitemdecimal(1, "sd_price_hfo_out")
istr_fuel.sd_price_do_out    = dw_bunker.getitemdecimal(1, "sd_price_do_out")
istr_fuel.sd_price_go_out    = dw_bunker.getitemdecimal(1, "sd_price_go_out")
istr_fuel.sd_price_lshfo_out = dw_bunker.getitemdecimal(1, "sd_price_lshfo_out")
if al_tc = 2 or al_tc = 3 or ab_hastcout then
	istr_fuel.hfo_sel_out   = dw_bunker.getitemnumber(1, "sb_out_hfo_sel")
	istr_fuel.do_sel_out    = dw_bunker.getitemnumber(1, "sb_out_do_sel")
	istr_fuel.go_sel_out    = dw_bunker.getitemnumber(1, "sb_out_go_sel")
	istr_fuel.lshfo_sel_out = dw_bunker.getitemnumber(1, "sb_out_lshfo_sel")
end if

ii_fifo_lshfo_sel = dw_bunker.getitemnumber(1, "sb_fifo_lshfo_sel")
ii_fifo_do_sel = dw_bunker.getitemnumber(1, "sb_fifo_do_sel")
ii_fifo_go_sel = dw_bunker.getitemnumber(1, "sb_fifo_go_sel")
ii_fifo_hfo_sel = dw_bunker.getitemnumber(1, "sb_fifo_hfo_sel")

return 1

end function

event open;call super::open;n_service_manager  lnv_servicemgr
n_dw_style_service lnv_style

lnv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_1, false)

istr_fuel = message.powerobjectparm
istr_fuel_original = istr_fuel

ids_data = istr_fuel.ids_tc_contracts
ids_data.getfullstate(iblob_original_state)

dw_bunker.InsertRow(0)

ids_data.sharedata(dw_1)
event ue_set_defaulttransfer()
_init_bunker_options()

istr_fuel.si_returncode = -1
/*
_save_state(3, _has_tcin_transfer(), _has_tcout_transfer())
// restore FIFO selections
_restore_state(_has_tcin_transfer(), _has_tcout_transfer())
*/
end event

on w_show_tccontractmatch.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.st_1=create st_1
this.dw_1=create dw_1
this.st_6=create st_6
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.cb_cancel=create cb_cancel
this.dw_bunker=create dw_bunker
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_1
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.st_9
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.dw_bunker
end on

on w_show_tccontractmatch.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.st_6)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.cb_cancel)
destroy(this.dw_bunker)
end on

event close;call super::close;closewithreturn(this, istr_fuel)

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_show_tccontractmatch
end type

type cb_ok from mt_u_commandbutton within w_show_tccontractmatch
integer x = 2025
integer y = 1528
integer taborder = 20
string text = "&OK"
end type

event clicked;dw_1.accepttext()
boolean lb_hastcin, lb_hastcout
long ll_row, ll_rowcount

lb_hastcin = _has_tcin_transfer()
lb_hastcout = _has_tcout_transfer()
_save_state(3, lb_hastcin, lb_hastcout)

if lb_hastcin or lb_hastcout then
	if istr_fuel.sd_amount_hfo <> 0 then
		if ii_fifo_hfo_sel = 0 and istr_fuel.hfo_sel_in = 0 and istr_fuel.hfo_sel_out = 0 then
			return
		end if
	end if
	
	if istr_fuel.sd_amount_do <> 0 then
		if ii_fifo_do_sel = 0 and istr_fuel.do_sel_in = 0 and istr_fuel.do_sel_out = 0 then
			return
		end if
	end if
	
	if istr_fuel.sd_amount_go <> 0 then
		if ii_fifo_go_sel = 0 and istr_fuel.go_sel_in = 0 and istr_fuel.go_sel_out = 0 then
			return
		end if
	end if
	
	if istr_fuel.sd_amount_lshfo <> 0 then
		if ii_fifo_lshfo_sel = 0 and istr_fuel.lshfo_sel_in = 0 and istr_fuel.lshfo_sel_out = 0 then
			return
		end if
	end if
end if

if ii_fifo_lshfo_sel = 1 then
	if istr_fuel.lshfo_sel_in = 0 then
		istr_fuel.sd_price_lshfo = dw_bunker.getitemdecimal(1, "sd_fifo_lshfo")
	end if
	if istr_fuel.lshfo_sel_out = 0 then
		istr_fuel.sd_price_lshfo_out = dw_bunker.getitemdecimal(1, "sd_fifo_lshfo")
	end if
end if

if ii_fifo_do_sel = 1 then
	if istr_fuel.do_sel_in = 0 then
		istr_fuel.sd_price_do = dw_bunker.getitemdecimal(1, "sd_fifo_do")
	end if
	if istr_fuel.do_sel_out = 0 then
		istr_fuel.sd_price_do_out = dw_bunker.getitemdecimal(1, "sd_fifo_do")
	end if
end if

if ii_fifo_go_sel = 1 then
	if istr_fuel.go_sel_in = 0 then
		istr_fuel.sd_price_go = dw_bunker.getitemdecimal(1, "sd_fifo_go")
	end if
	if istr_fuel.go_sel_out = 0 then
		istr_fuel.sd_price_go_out = dw_bunker.getitemdecimal(1, "sd_fifo_go")
	end if
end if

if ii_fifo_hfo_sel = 1 then
	if istr_fuel.hfo_sel_in = 0 then
		istr_fuel.sd_price_hfo = dw_bunker.getitemdecimal(1, "sd_fifo_hfo")
	end if
	if istr_fuel.hfo_sel_out = 0 then
		istr_fuel.sd_price_hfo_out = dw_bunker.getitemdecimal(1, "sd_fifo_hfo")
	end if
end if

if isnull(istr_fuel.sd_price_hfo) then istr_fuel.sd_price_hfo = 0
if isnull(istr_fuel.sd_price_do) then istr_fuel.sd_price_do = 0
if isnull(istr_fuel.sd_price_go) then istr_fuel.sd_price_go = 0
if isnull(istr_fuel.sd_price_lshfo) then istr_fuel.sd_price_lshfo = 0
if isnull(istr_fuel.sd_price_hfo_out) then istr_fuel.sd_price_hfo_out = 0
if isnull(istr_fuel.sd_price_do_out) then istr_fuel.sd_price_do_out = 0
if isnull(istr_fuel.sd_price_go_out) then istr_fuel.sd_price_go_out = 0
if isnull(istr_fuel.sd_price_lshfo_out) then istr_fuel.sd_price_lshfo_out = 0

istr_fuel.si_returncode = 1
close(parent)

end event

type st_1 from mt_u_statictext within w_show_tccontractmatch
integer x = 37
integer y = 32
integer width = 2679
integer height = 56
string text = "Select which TC contracts the Off-Hire should be transferred to and which prices to be used for the bunker consumption."
end type

type dw_1 from u_ntchire_dw within w_show_tccontractmatch
integer x = 37
integer y = 104
integer width = 2679
integer height = 524
integer taborder = 10
string dataobject = "d_find_tc_contract_for_periode"
boolean border = false
boolean ib_setdefaultbackgroundcolor = true
end type

event itemchanged;call super::itemchanged;//check the TC-Hire payments status new or draft
boolean lb_has_tcin_transfer, lb_has_tcout_transfer
long ll_tc_hire_in

if dwo.name ='transfer' then
	if data = '1' then
		if _validate_paymentstatus(getitemnumber(row, "contract_id")) = c#return.Failure then
			return 2
		end if
	end if

	ll_tc_hire_in = getitemnumber(row, "ntc_tc_contract_tc_hire_in")
	choose case ll_tc_hire_in
		case 1
			lb_has_tcin_transfer = (data = '1')
			lb_has_tcout_transfer = _has_tcout_transfer()
		case 0
			lb_has_tcin_transfer = _has_tcin_transfer()
			lb_has_tcout_transfer = (data = '1')
		case else
			return
	end choose

	_save_state(0, _has_tcin_transfer(), _has_tcout_transfer())
	// restore FIFO selections
	_restore_state(lb_has_tcin_transfer, lb_has_tcout_transfer)

	_enable_bunker_option( "lshfo", not (istr_fuel.sd_amount_lshfo = 0 or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
		lb_has_tcin_transfer, lb_has_tcout_transfer )
	_enable_bunker_option( "go", not (istr_fuel.sd_amount_go = 0 or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
		lb_has_tcin_transfer, lb_has_tcout_transfer )
	_enable_bunker_option( "do", not (istr_fuel.sd_amount_do = 0  or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
		lb_has_tcin_transfer, lb_has_tcout_transfer )
	_enable_bunker_option( "hfo", not (istr_fuel.sd_amount_hfo = 0  or (uo_global.ii_access_level = -1 or uo_global.ii_user_profile <> 2)),&
		lb_has_tcin_transfer, lb_has_tcout_transfer )
end if

end event

type st_6 from mt_u_statictext within w_show_tccontractmatch
integer x = 37
integer y = 1108
integer width = 343
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "FIFO"
end type

type st_7 from mt_u_statictext within w_show_tccontractmatch
integer x = 37
integer y = 1180
integer width = 2615
integer height = 128
boolean bringtotop = true
string text = "The FIFO (First In First Out) price is calculated automatically by Tramos based on the bunker purchases and consumptions entered."
end type

type st_8 from mt_u_statictext within w_show_tccontractmatch
integer x = 37
integer y = 1344
integer width = 379
integer height = 56
boolean bringtotop = true
integer weight = 700
string text = "TC-In/TC-Out"
end type

type st_9 from mt_u_statictext within w_show_tccontractmatch
integer x = 37
integer y = 1416
integer width = 2651
integer height = 88
boolean bringtotop = true
string text = "Select and type the prices required for the TC Hire contracts instead of using the automatically calculated FIFO price."
end type

type cb_cancel from mt_u_commandbutton within w_show_tccontractmatch
integer x = 2373
integer y = 1528
integer taborder = 60
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;call super::clicked;Parent.Event ue_cancel()


end event

type dw_bunker from mt_u_datawindow within w_show_tccontractmatch
integer x = 18
integer y = 632
integer width = 2706
integer height = 452
integer taborder = 20
string dataobject = "d_ex_bunker_off_services"
boolean border = false
end type

event itemchanged;call super::itemchanged;string ls_objname
boolean lb_has_tcin_transfer, lb_has_tcout_transfer
long ll_in_hfo_sel, ll_in_do_sel, ll_in_go_sel, ll_in_lshfo_sel
long ll_out_hfo_sel, ll_out_do_sel, ll_out_go_sel, ll_out_lshfo_sel

ls_objname = dwo.name
lb_has_tcin_transfer = _has_tcin_transfer()
lb_has_tcout_transfer = _has_tcout_transfer()

ll_in_hfo_sel = getitemnumber(row, "sb_in_hfo_sel")
ll_in_do_sel = getitemnumber(row, "sb_in_do_sel")
ll_in_go_sel = getitemnumber(row, "sb_in_go_sel")
ll_in_lshfo_sel = getitemnumber(row, "sb_in_lshfo_sel")

ll_out_hfo_sel = getitemnumber(row, "sb_out_hfo_sel")
ll_out_do_sel = getitemnumber(row, "sb_out_do_sel")
ll_out_go_sel = getitemnumber(row, "sb_out_go_sel")
ll_out_lshfo_sel = getitemnumber(row, "sb_out_lshfo_sel")

choose case ls_objname
	case "sb_fifo_hfo_sel"
		if data = '0' then
			if lb_has_tcin_transfer then setitem(row, "sb_in_hfo_sel", 1)
			if lb_has_tcout_transfer then setitem(row, "sb_out_hfo_sel", 1)
		else
			setitem(row, "sb_in_hfo_sel", 0)
			setitem(row, "sb_out_hfo_sel", 0)
		end if
	case "sb_fifo_do_sel"
		if data = '0' then
			if lb_has_tcin_transfer then setitem(row, "sb_in_do_sel", 1)
			if lb_has_tcout_transfer then setitem(row, "sb_out_do_sel", 1)
		else
			setitem(row, "sb_in_do_sel", 0)
			setitem(row, "sb_out_do_sel", 0)
		end if
	case "sb_fifo_go_sel"
		if data = '0' then
			if lb_has_tcin_transfer then setitem(row, "sb_in_go_sel", 1)
			if lb_has_tcout_transfer then setitem(row, "sb_out_go_sel", 1)
		else
			setitem(row, "sb_in_go_sel", 0)
			setitem(row, "sb_out_go_sel", 0)
		end if
	case "sb_fifo_lshfo_sel"
		if data = '0' then
			if lb_has_tcin_transfer then setitem(row, "sb_in_lshfo_sel", 1)
			if lb_has_tcout_transfer then setitem(row, "sb_out_lshfo_sel", 1)
		else
			setitem(row, "sb_in_lshfo_sel", 0)
			setitem(row, "sb_out_lshfo_sel", 0)
		end if
	case "sb_in_hfo_sel"
		if data = "1" then
			if not lb_has_tcout_transfer then
				setitem(row, "sb_fifo_hfo_sel", 0)
			elseif ll_out_hfo_sel = 1 then
				setitem(row, "sb_fifo_hfo_sel", 0)
			end if
			this.post setcolumn("sd_price_hfo_in")
		else
			setitem(row, "sb_fifo_hfo_sel", 1)
		end if
	case "sb_in_do_sel"
		if data = "1" then
			if not lb_has_tcout_transfer then
				setitem(row, "sb_fifo_do_sel", 0)
			elseif ll_out_do_sel = 1 then
				setitem(row, "sb_fifo_do_sel", 0)
			end if
			this.post setcolumn("sd_price_do_in")
		else
			setitem(row, "sb_fifo_do_sel", 1)
		end if
	case "sb_in_go_sel"
		if data = "1" then
			if not lb_has_tcout_transfer then
				setitem(row, "sb_fifo_go_sel", 0)
			elseif ll_out_go_sel = 1 then
				setitem(row, "sb_fifo_go_sel", 0)
			end if
			this.post setcolumn("sd_price_go_in")
		else
			setitem(row, "sb_fifo_go_sel", 1)
		end if
	case "sb_in_lshfo_sel"
		if data = "1" then 
			if not lb_has_tcout_transfer then
				setitem(row, "sb_fifo_lshfo_sel", 0)
			elseif ll_out_lshfo_sel = 1 then
				setitem(row, "sb_fifo_lshfo_sel", 0)
			end if
			this.post setcolumn("sd_price_lshfo_in")
		else
			setitem(row, "sb_fifo_lshfo_sel", 1)
		end if
	case "sb_out_hfo_sel"
		if data = "1" then
			if not lb_has_tcin_transfer then
				setitem(row, "sb_fifo_hfo_sel", 0)
			elseif ll_in_hfo_sel = 1 then
				setitem(row, "sb_fifo_hfo_sel", 0)
			end if
			this.post setcolumn("sd_price_hfo_out")
		else
			setitem(row, "sb_fifo_hfo_sel", 1)
		end if
	case "sb_out_do_sel"
		if data = "1" then
			if not lb_has_tcin_transfer then
				setitem(row, "sb_fifo_do_sel", 0)
			elseif ll_in_do_sel = 1 then
				setitem(row, "sb_fifo_do_sel", 0)
			end if
			this.post setcolumn("sd_price_do_out")
		else
			setitem(row, "sb_fifo_do_sel", 1)
		end if
	case "sb_out_go_sel"
		if data = "1" then
			if not lb_has_tcin_transfer then
				setitem(row, "sb_fifo_go_sel", 0)
			elseif ll_in_go_sel = 1 then
				setitem(row, "sb_fifo_go_sel", 0)
			end if
			this.post setcolumn("sd_price_go_out")
		else
			setitem(row, "sb_fifo_go_sel", 1)
		end if
	case "sb_out_lshfo_sel"
		if data = "1" then
			if not lb_has_tcin_transfer then
				setitem(row, "sb_fifo_lshfo_sel", 0)
			elseif ll_in_lshfo_sel = 1 then
				setitem(row, "sb_fifo_lshfo_sel", 0)
			end if
			this.post setcolumn("sd_price_lshfo_out")
		else
			setitem(row, "sb_fifo_lshfo_sel", 1)
		end if

end choose

end event

event itemfocuschanged;call super::itemfocuschanged;string ls_mask
ls_mask = dwo.editmask.mask

if ls_mask <> "!" and ls_mask <> "?" and ls_mask <> "" then
	this.selecttext(1, len(this.gettext())+10)
end if

end event

