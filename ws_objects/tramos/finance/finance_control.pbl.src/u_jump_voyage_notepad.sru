$PBExportHeader$u_jump_voyage_notepad.sru
forward
global type u_jump_voyage_notepad from nonvisualobject
end type
end forward

global type u_jump_voyage_notepad from nonvisualobject
end type
global u_jump_voyage_notepad u_jump_voyage_notepad

forward prototypes
public subroutine of_open_voyage_notepad (integer ai_vessel_nr, string as_voyage_nr)
public subroutine documentation ()
end prototypes

public subroutine of_open_voyage_notepad (integer ai_vessel_nr, string as_voyage_nr);long ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_voyage_notepad) THEN
//	w_voyage_notepad.TriggerEvent(Open!)
	w_voyage_notepad.uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
ELSE
	Opensheet(w_voyage_notepad,w_tramos_main,0,Original!)
END IF

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

w_voyage_notepad.SetRedraw(FALSE)

// Find, select and highlight record in voyage_list datawindow
ll_found = w_voyage_notepad.dw_voyages.Find("voyage_nr = '" + as_voyage_nr + "'",1, w_voyage_notepad.dw_voyages.RowCount())

if ll_found = 0 then
	w_voyage_notepad.dw_voyages.scrolltorow(w_voyage_notepad.dw_voyages.rowcount())
else
	w_voyage_notepad.dw_voyages.SetRow(ll_found)
	w_voyage_notepad.dw_voyages.ScrollToRow(ll_found)
end if
w_voyage_notepad.dw_voyages.Event Clicked(0,0, ll_found, w_voyage_notepad.dw_voyages.Object) 

w_voyage_notepad.SetRedraw(TRUE)
w_voyage_notepad.SetFocus()

Return

end subroutine

public subroutine documentation ();/********************************************************************
   u_jump_voyage_notepad
   <OBJECT>		Jump to Voyage Notepad window	</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19/11/2012 CR2742       RJH022             Reform code
   </HISTORY>
********************************************************************/

end subroutine

on u_jump_voyage_notepad.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_voyage_notepad.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

