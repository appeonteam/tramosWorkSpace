$PBExportHeader$n_jump_proceeding.sru
$PBExportComments$Jump to Proceeding
forward
global type n_jump_proceeding from mt_n_nonvisualobject
end type
end forward

global type n_jump_proceeding from mt_n_nonvisualobject
end type
global n_jump_proceeding n_jump_proceeding

type variables

end variables

forward prototypes
public function integer of_openproceeding (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn)
public subroutine documentation ()
public function integer of_openproceeding (integer ai_vessel_nr, string as_voyage_nr)
end prototypes

public function integer of_openproceeding (integer ai_vessel_nr, string as_voyage_nr, string as_portcode, integer ai_pcn);/********************************************************************
   of_openproceeding()
	
<DESC>   
	Description
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	ai_vessel_nr		:
	as_voyage_nr	:
	as_portcode		:
	ai_pcn			:
</ARGS>
<USAGE>
	Right now only used with the port validator tool
</USAGE>
********************************************************************/

long		ll_found
dwobject	ldwo_dummy

uo_global.setVessel_nr(ai_vessel_nr)
uo_global.setVoyage_nr(as_voyage_nr)

if isvalid(w_proceeding_list) then
	if w_proceeding_list.dw_proceeding_list.enabled = false then
		_addmessage( this.classdefinition, "of_openproceeding()", "Can not jump to selected vessel/voyage due to the proceeding window being in edit mode.", "user warning")
		w_proceeding_list.setfocus()
		return c#return.Failure
	else	
		w_proceeding_list.setredraw(false)
		w_proceeding_list.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
	end if
else
	opensheet(w_proceeding_list,w_tramos_main,0,Original!)
	w_proceeding_list.setredraw(false)
end if

if ai_pcn <> 0 then
	choose case left(as_voyage_nr, 2) = left(string(year(today())),2)
		case true
			w_proceeding_list.rb_all_voyages.checked = false
			w_proceeding_list.rb_only_this_year.checked = true
		case false 
			w_proceeding_list.rb_all_voyages.checked = true
			w_proceeding_list.rb_only_this_year.checked = false
			w_proceeding_list.rb_all_voyages.event clicked()
	end choose
end if

yield()  /* to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			retrieve statements are posted */

/* find, select and highlight record in disb_proc_list datawindow */
ll_found = w_proceeding_list.dw_proceeding_list.find(&
				"voyage_nr = '" + as_voyage_nr +&
				"' and port_code = '" + as_portcode +&
				"' and pcn = " + string(ai_pcn), &
				1, w_proceeding_list.dw_proceeding_list.rowcount( ))
w_proceeding_list.dw_proceeding_list.setrow(ll_found)

if ll_found = 0 then
	w_proceeding_list.dw_proceeding_list.scrolltorow(w_proceeding_list.dw_proceeding_list.rowcount())
else
	w_proceeding_list.dw_proceeding_list.scrolltorow(ll_found)
end if

ldwo_dummy = w_proceeding_list.dw_proceeding_list.object.__get_attribute("voyage_nr", false)
w_proceeding_list.dw_proceeding_list.event clicked(0, 0, ll_found, ldwo_dummy)

w_proceeding_list.setredraw(TRUE)
w_proceeding_list.setfocus()

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: u_jump_proceeding
	
	<OBJECT>
		Object Description
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref		Author   		Comments
  	24/11/11 	D-CALC	AGL      		First Version
********************************************************************/
end subroutine

public function integer of_openproceeding (integer ai_vessel_nr, string as_voyage_nr);/********************************************************************
   of_openproceeding
   <DESC>  </DESC>
   <RETURN>	
		<LI> c#return.Success, X ok
		<LI> c#return.Failure, X failed	
	</RETURN>          	
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
   	Date    		CR-Ref		Author		Comments
   	03/12/14		CR3414		XSZ004		Fix a historical bug
   </HISTORY>
********************************************************************/
long		ll_found
dwobject	ldwo_dummy

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

if isvalid(w_proceeding_list) then
	w_proceeding_list.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	OpenSheet(w_proceeding_list,w_tramos_main,0,Original!)
END IF

choose case left(as_voyage_nr, 2) = left(string(year(today())),2)
	case true
		w_proceeding_list.rb_all_voyages.checked = false
		w_proceeding_list.rb_only_this_year.checked = true
	case false 
		w_proceeding_list.rb_all_voyages.checked = true
		w_proceeding_list.rb_only_this_year.checked = false
		w_proceeding_list.rb_all_voyages.event clicked()
end choose


w_proceeding_list.setredraw(false)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in disb_proc_list datawindow
ll_found = w_proceeding_list.dw_proceeding_list.Find("voyage_nr = '" + as_voyage_nr + "'" , 1, w_proceeding_list.dw_proceeding_list.rowcount( ))
w_proceeding_list.dw_proceeding_list.SetRow(ll_found)
if ll_found = 0 then
	w_proceeding_list.dw_proceeding_list.scrolltorow(w_proceeding_list.dw_proceeding_list.rowcount())
else
	w_proceeding_list.dw_proceeding_list.scrolltorow(ll_found)
end if

ldwo_dummy = w_proceeding_list.dw_proceeding_list.object.__get_attribute("voyage_nr", false)
w_proceeding_list.dw_proceeding_list.event clicked(0, 0, ll_found, ldwo_dummy)

// Find, select and highlight record in disb_agents_list datawindow
w_proceeding_list.setredraw(true)
w_proceeding_list.setfocus()

return c#return.Success

	
end function

on n_jump_proceeding.create
call super::create
end on

on n_jump_proceeding.destroy
call super::destroy
end on

