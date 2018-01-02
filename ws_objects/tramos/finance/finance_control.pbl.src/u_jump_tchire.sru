$PBExportHeader$u_jump_tchire.sru
$PBExportComments$Jump to TC-Hire
forward
global type u_jump_tchire from nonvisualobject
end type
end forward

global type u_jump_tchire from nonvisualobject
end type
global u_jump_tchire u_jump_tchire

type variables

end variables

forward prototypes
public subroutine of_open_tchire (integer ai_vessel_nr, double ad_contract_id)
public subroutine of_highlight_contract (integer ai_vessel_nr, double ad_contract_id)
public subroutine documentation ()
end prototypes

public subroutine of_open_tchire (integer ai_vessel_nr, double ad_contract_id);uo_global.setvessel_nr(ai_vessel_nr)

if isvalid(w_tc_contract) then
	w_tc_contract.uo_vesselselect.of_setcurrentvessel(ai_vessel_nr)
else
	opensheet(w_tc_contract, w_tramos_main, 0, original!)
end if

post of_highlight_contract(ai_vessel_nr, ad_contract_id)

end subroutine

public subroutine of_highlight_contract (integer ai_vessel_nr, double ad_contract_id);/********************************************************************
   of_highlight_contract
   <DESC>	Find, select and highlight contract.	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr
		ad_contract_id
   </ARGS>
   <USAGE>	Suggest to use in the of_open_tchire() function	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	25/02/2014   CR3303       ZSW001       First Version
   </HISTORY>
********************************************************************/

long	ll_found

// Find, select and highlight record.
w_tc_contract.setredraw(false)

ll_found = w_tc_contract.dw_contract_list.find("contract_id = " + string(ad_contract_id), 1, w_tc_contract.dw_contract_list.rowcount())
if ll_found > 0 then
	w_tc_contract.inv_contract.of_setvesselnr(ai_vessel_nr)
	w_tc_contract.dw_contract_list.setrow(ll_found)
	w_tc_contract.dw_contract_list.scrolltorow(ll_found)
	w_tc_contract.dw_contract_list.event clicked(0, 0, ll_found, w_tc_contract.dw_contract_list.object)
end if

w_tc_contract.setredraw(true)
w_tc_contract.setfocus()

end subroutine

public subroutine documentation ();/********************************************************************
   u_jump_tchire
   <OBJECT>	Open TC hire window, then find, select and highlight 
	         contract in TC hire window	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	25/02/2014   CR3303       ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

on u_jump_tchire.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_tchire.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

