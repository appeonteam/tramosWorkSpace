$PBExportHeader$u_jump_offservice.sru
forward
global type u_jump_offservice from nonvisualobject
end type
end forward

global type u_jump_offservice from nonvisualobject
end type
global u_jump_offservice u_jump_offservice

forward prototypes
public subroutine of_open_offservice (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, datetime adt_startdate)
end prototypes

public subroutine of_open_offservice (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, datetime adt_startdate);long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_off_services) THEN
	//w_off_services.TriggerEvent(Open!)
	w_off_services.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_off_services,w_tramos_main,0,Original!)
END IF
w_off_services.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in claims_list datawindow
ll_found = w_off_services.dw_off_services.Find(&
				" voyage_nr = '" + as_voyage_nr +&
				"' and port_code = '" + as_port_code +&
				"' and off_start = datetime('" + string(adt_startdate) + "')", &
				1, w_off_services.dw_off_services.RowCount( ))
				
w_off_services.dw_off_services.SetRow(ll_found)
w_off_services.dw_off_services.ScrollToRow(ll_found)
w_off_services.dw_off_services.Event Clicked(0,0, ll_found, w_off_services.dw_off_services.Object) 


w_off_services.SetRedraw(TRUE)
w_off_services.SetFocus()

Return

end subroutine

on u_jump_offservice.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_offservice.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

