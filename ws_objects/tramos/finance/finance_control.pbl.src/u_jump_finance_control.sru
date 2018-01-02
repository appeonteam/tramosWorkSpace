$PBExportHeader$u_jump_finance_control.sru
forward
global type u_jump_finance_control from nonvisualobject
end type
end forward

global type u_jump_finance_control from nonvisualobject
end type
global u_jump_finance_control u_jump_finance_control

forward prototypes
public subroutine of_open_control (integer ai_vessel_nr, string as_voyage_nr)
end prototypes

public subroutine of_open_control (integer ai_vessel_nr, string as_voyage_nr);long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_fin_controlpanel) THEN
	//w_fin_controlpanel.TriggerEvent(Open!)
//	w_fin_controlpanel.dw_voyage.reset()
	w_fin_controlpanel.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_fin_controlpanel,w_tramos_main,0,Original!)
END IF

w_fin_controlpanel.SetRedraw(FALSE)
yield()

//w_fin_controlpanel.dw_vessel_dropdown.setItem(1, "vessel_nr", ai_vessel_nr)
//w_fin_controlpanel.dw_vessel_dropdown.Event itemChanged(1, w_fin_controlpanel.dw_vessel_dropdown.Object, string(ai_vessel_nr ))

//do while w_fin_controlpanel.dw_voyage.rowCount() < 1
//	// just waiting for data to be retrieved
//	yield()
//loop	

// Find, select and highlight record in claims_list datawindow
ll_found = w_fin_controlpanel.dw_voyage.Find(" voyage_nr = '" + as_voyage_nr+"'", 1, w_fin_controlpanel.dw_voyage.RowCount( ))
				
w_fin_controlpanel.dw_voyage.SetRow(ll_found)
w_fin_controlpanel.dw_voyage.ScrollToRow(ll_found)
w_fin_controlpanel.dw_voyage.Event Clicked(0,0, ll_found, w_fin_controlpanel.dw_voyage.Object) 

w_fin_controlpanel.SetRedraw(TRUE)
w_fin_controlpanel.SetFocus()

Return

end subroutine

on u_jump_finance_control.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_finance_control.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

