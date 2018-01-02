$PBExportHeader$u_jump_bp.sru
$PBExportComments$Jump to Bunker Purchase
forward
global type u_jump_bp from nonvisualobject
end type
end forward

global type u_jump_bp from nonvisualobject
end type
global u_jump_bp u_jump_bp

type variables

end variables

forward prototypes
public subroutine of_open_bp (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn)
end prototypes

public subroutine of_open_bp (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn);long 		ll_found
string		ls_find

uo_global.setVessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_bunker_purchase) THEN
//	w_bunker_purchase.dw_vessel_dropdown.setfocus()
//	w_bunker_purchase.TriggerEvent(Open!)
	w_bunker_purchase.uo_vesselselect.of_setcurrentvessel(ai_vessel_nr)
ELSE
	OpenSheet(w_bunker_purchase,w_tramos_main,0,Original!)
END IF

w_bunker_purchase.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in disb_proc_list datawindow
ls_find = "voyage_nr = '" + as_voyage_nr +&
				"' and port_code = '" + as_portcode +&
				"' and pcn = " + string(ai_pcn)

ll_found = w_bunker_purchase.dw_bp_list.Find(ls_find, 1, w_bunker_purchase.dw_bp_list.RowCount( ))
//w_bunker_purchase.dw_bp_list.SetRow(ll_found)
//w_bunker_purchase.dw_bp_list.ScrollToRow(ll_found)
w_bunker_purchase.dw_bp_list.Event Clicked(0,0,ll_found, w_bunker_purchase.dw_bp_list.object)

w_bunker_purchase.SetRedraw(TRUE)
w_bunker_purchase.SetFocus()

Return


		
end subroutine

on u_jump_bp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_bp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

