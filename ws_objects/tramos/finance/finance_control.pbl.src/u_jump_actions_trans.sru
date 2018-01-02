$PBExportHeader$u_jump_actions_trans.sru
forward
global type u_jump_actions_trans from nonvisualobject
end type
end forward

global type u_jump_actions_trans from nonvisualobject
end type
global u_jump_actions_trans u_jump_actions_trans

forward prototypes
public subroutine of_open_actions_trans (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr)
end prototypes

public subroutine of_open_actions_trans (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr);long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_actions_transactions) THEN
	//w_actions_transactions.TriggerEvent(Open!)
	w_actions_transactions.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_actions_transactions,w_tramos_main,0,Original!)
END IF

w_actions_transactions.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in claims_list datawindow
ll_found = w_actions_transactions.dw_list_claims.Find(&
				" voyage_nr = '" + as_voyage_nr +&
				"' and claim_nr = " + string(al_claim_nr) +&
				" and chart_nr = " + string(al_chart_nr), &
				1, w_actions_transactions.dw_list_claims.RowCount( ))
				
w_actions_transactions.dw_list_claims.SetRow(ll_found)
w_actions_transactions.dw_list_claims.ScrollToRow(ll_found)
w_actions_transactions.dw_list_claims.Event Clicked(0,0, ll_found, w_actions_transactions.dw_list_claims.Object) 
// w_actions_transactions.dw_list_claims.TriggerEvent(Clicked!)

w_actions_transactions.SetRedraw(TRUE)
w_actions_transactions.SetFocus()

Return

end subroutine

on u_jump_actions_trans.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_actions_trans.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

