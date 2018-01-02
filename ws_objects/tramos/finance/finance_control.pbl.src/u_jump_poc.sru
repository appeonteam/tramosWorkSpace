$PBExportHeader$u_jump_poc.sru
$PBExportComments$Jump to Port of Call
forward
global type u_jump_poc from nonvisualobject
end type
end forward

global type u_jump_poc from nonvisualobject
end type
global u_jump_poc u_jump_poc

type variables

end variables

forward prototypes
public subroutine of_open_poc (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn)
public subroutine of_open_poc (integer ai_vessel_nr, string as_voyage_nr)
end prototypes

public subroutine of_open_poc (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn);long ll_found

uo_global.setVessel_nr(ai_vessel_nr)
uo_global.setVoyage_nr(as_voyage_nr)

IF IsValid(w_port_of_call) THEN
	//w_port_of_call.TriggerEvent(Open!)
	w_port_of_call.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	//CR2319 D3-2 Modified by LGX001 on 09/10/2011. 
	//OpenSheet(w_port_of_call,w_tramos_main,0,Original!)
	opensheetWithparm(w_port_of_call, 'OPEN-FROM-F3', w_tramos_main,0,Original!)
END IF

if ai_pcn <> 0 then
	choose case left(as_voyage_nr, 2) = right(string(year(today())),2)
		case true
			w_port_of_call.rb_all_voyages.checked = false
			w_port_of_call.rb_only_this_year.checked = true
		case false 
			w_port_of_call.rb_all_voyages.checked = true
			w_port_of_call.rb_only_this_year.checked = false
			w_port_of_call.rb_all_voyages.event clicked()
	end choose
end if

w_port_of_call.SetRedraw(FALSE)
 
yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in disb_proc_list datawindow
ll_found = w_port_of_call.dw_proc_pcnc.Find(&
				"proceed_voyage_nr = '" + as_voyage_nr +&
				"' and proceed_port_code = '" + as_portcode +&
				"' and proceed_pcn = " + string(ai_pcn), &
				1, w_port_of_call.dw_proc_pcnc.RowCount( ))
w_port_of_call.dw_proc_pcnc.SetRow(ll_found)
if ll_found = 0 then
	w_port_of_call.dw_proc_pcnc.ScrollToRow(w_port_of_call.dw_proc_pcnc.rowcount())
else
	w_port_of_call.dw_proc_pcnc.ScrollToRow(ll_found)
end if
w_port_of_call.dw_proc_pcnc.Event Clicked(0,0,ll_found,w_port_of_call.dw_proc_pcnc.Object)
// Find, select and highlight record in disb_agents_list datawindow

//CR2319 D3-2 Modified by LGX001 on 09/10/2011. 
if w_port_of_call.ib_allowchangemenu then
	w_port_of_call.SetFocus()
else
	w_port_of_call.ib_allowchangemenu = true
	w_port_of_call.event activate()
end if

w_port_of_call.SetRedraw(TRUE)


Return

	
end subroutine

public subroutine of_open_poc (integer ai_vessel_nr, string as_voyage_nr);long ll_found

uo_global.setVessel_nr(ai_vessel_nr)
uo_global.setVoyage_nr(as_voyage_nr)

IF IsValid(w_port_of_call) THEN
	//w_port_of_call.TriggerEvent(Open!)
	w_port_of_call.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	//CR2319 D3-2 Modified by LGX001 on 09/10/2011. 
	//OpenSheet(w_port_of_call,w_tramos_main,0,Original!)
	opensheetWithparm(w_port_of_call, 'OPEN-FROM-F3', w_tramos_main,0,Original!)
END IF

choose case left(as_voyage_nr, 2) = right(string(year(today())),2)
	case true
		w_port_of_call.rb_all_voyages.checked = false
		w_port_of_call.rb_only_this_year.checked = true
	case false 
		w_port_of_call.rb_all_voyages.checked = true
		w_port_of_call.rb_only_this_year.checked = false
		w_port_of_call.rb_all_voyages.event clicked()
end choose


w_port_of_call.SetRedraw(FALSE)

yield()       //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
 		     	//retrieve statements are posted

// Find, select and highlight record in disb_proc_list datawindow
ll_found = w_port_of_call.dw_proc_pcnc.Find("proceed_voyage_nr = '" + as_voyage_nr + "'" , 1, w_port_of_call.dw_proc_pcnc.RowCount( ))
w_port_of_call.dw_proc_pcnc.SetRow(ll_found)
if ll_found = 0 then
	w_port_of_call.dw_proc_pcnc.ScrollToRow(w_port_of_call.dw_proc_pcnc.rowcount())
else
	w_port_of_call.dw_proc_pcnc.ScrollToRow(ll_found)
end if
w_port_of_call.dw_proc_pcnc.Event Clicked(0,0,ll_found,w_port_of_call.dw_proc_pcnc.Object)
// Find, select and highlight record in disb_agents_list datawindow

//CR2319 D3-2 Modified by LGX001 on 09/10/2011. 
if w_port_of_call.ib_allowchangemenu then
	w_port_of_call.SetFocus()
else
	w_port_of_call.ib_allowchangemenu = true
	w_port_of_call.event activate()
end if

w_port_of_call.SetRedraw(TRUE)

Return

	
end subroutine

on u_jump_poc.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_poc.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

