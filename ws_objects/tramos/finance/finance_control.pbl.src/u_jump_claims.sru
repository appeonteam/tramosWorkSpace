$PBExportHeader$u_jump_claims.sru
forward
global type u_jump_claims from nonvisualobject
end type
end forward

global type u_jump_claims from nonvisualobject
end type
global u_jump_claims u_jump_claims

forward prototypes
public subroutine of_open_claims (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr)
public subroutine of_createheatingclaim (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr)
public subroutine of_createdevclaim (integer ai_vessel_nr, string as_voyage_nr)
end prototypes

public subroutine of_open_claims (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr);long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_claims) THEN
	//w_claims.TriggerEvent(Open!)
	w_claims.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_claims,w_tramos_main,0,Original!)
END IF

w_claims.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in claims_list datawindow
ll_found = w_claims.dw_list_claims.Find(&
				" voyage_nr = '" + as_voyage_nr +&
				"' and claim_nr = " + string(al_claim_nr) +&
				" and chart_nr = " + string(al_chart_nr), &
				1, w_claims.dw_list_claims.RowCount( ))
if ll_found > 0 then				
	w_claims.dw_list_claims.SetRow(ll_found)
	w_claims.dw_list_claims.ScrollToRow(ll_found)
	w_claims.dw_list_claims.Event Clicked(0,0, ll_found, w_claims.dw_list_claims.Object) 
end if

w_claims.SetRedraw(TRUE)
w_claims.cb_update.enabled = true
w_claims.cb_delete.enabled = true
w_claims.SetFocus()

Return

end subroutine

public subroutine of_createheatingclaim (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr);/* This function is used when creating a heating claim from operations (cargo)  */

long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_claims) THEN
	//w_claims.TriggerEvent(Open!)
	w_claims.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_claims,w_tramos_main,0,Original!)
END IF

yield()  	//to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

w_claims.cb_heating.triggerEvent(Clicked!)

w_claims.cb_update.enabled = true
w_claims.cb_delete.enabled = true
w_claims.SetFocus()

Return

end subroutine

public subroutine of_createdevclaim (integer ai_vessel_nr, string as_voyage_nr);/********************************************************************
   of_createdevclaim
   <DESC> This function is used when creating a dev claim from operations (cargo) </DESC>
   <RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
		ai_vessel_nr,
		as_voyage_nr
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22/08/17 CR4221           HHX010        First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

if IsValid(w_claims) then
	w_claims.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
else
	Opensheet(w_claims,w_tramos_main,0,Original!)
end if

yield()  	//to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

w_claims.cb_deviation.triggerEvent(Clicked!)

w_claims.cb_update.enabled = true
w_claims.cb_delete.enabled = true
w_claims.SetFocus()

return

end subroutine

on u_jump_claims.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_claims.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

