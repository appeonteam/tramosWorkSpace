$PBExportHeader$u_jump_worldscale.sru
forward
global type u_jump_worldscale from nonvisualobject
end type
end forward

global type u_jump_worldscale from nonvisualobject
end type
global u_jump_worldscale u_jump_worldscale

forward prototypes
public subroutine of_open_worldscale (string as_port_code_from, string as_port_code_to, integer ai_year)
end prototypes

public subroutine of_open_worldscale (string as_port_code_from, string as_port_code_to, integer ai_year);IF IsValid(w_calc_worldscale_edit) THEN
	w_calc_worldscale_edit.TriggerEvent(Open!)
ELSE
	Opensheet(w_calc_worldscale_edit,w_tramos_main,0,Original!)
END IF

w_calc_worldscale_edit.SetRedraw(FALSE)

w_calc_worldscale_edit.em_from_year.text = string(ai_year)
w_calc_worldscale_edit.em_to_year.text = string(ai_year)
w_calc_worldscale_edit.sle_port.text = as_port_code_from + as_port_code_to

w_calc_worldscale_edit.cb_filter.Triggerevent(Clicked!)

w_calc_worldscale_edit.setredraw(true)

end subroutine

on u_jump_worldscale.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_worldscale.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

