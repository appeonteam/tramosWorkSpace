$PBExportHeader$u_jump_bp_list.sru
$PBExportComments$Jump to Bunker Purchase List
forward
global type u_jump_bp_list from nonvisualobject
end type
end forward

global type u_jump_bp_list from nonvisualobject
end type
global u_jump_bp_list u_jump_bp_list

type variables

end variables

forward prototypes
public subroutine of_open_bp_list (integer ai_vessel_nr)
end prototypes

public subroutine of_open_bp_list (integer ai_vessel_nr);uo_global.setVessel_nr(ai_vessel_nr)

IF IsValid(w_bunker_purchase_list) THEN
	w_bunker_purchase_list.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	OpenSheet(w_bunker_purchase_list,w_tramos_main,0,Original!)
END IF

w_bunker_purchase_list.SetRedraw(FALSE)

w_bunker_purchase_list.dw_bunker_purchase_list.ScrollToRow(w_bunker_purchase_list.dw_bunker_purchase_list.rowCount())

w_bunker_purchase_list.SetRedraw(TRUE)
w_bunker_purchase_list.SetFocus()

Return

	
end subroutine

on u_jump_bp_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_bp_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

