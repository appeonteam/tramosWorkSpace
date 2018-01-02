$PBExportHeader$n_jump_specialclaims.sru
forward
global type n_jump_specialclaims from mt_n_nonvisualobject
end type
end forward

global type n_jump_specialclaims from mt_n_nonvisualobject
end type
global n_jump_specialclaims n_jump_specialclaims

forward prototypes
public subroutine of_open_specialclaims (long al_special_claim_id)
public subroutine documentation ()
end prototypes

public subroutine of_open_specialclaims (long al_special_claim_id);/********************************************************************
   of_open_specialclaims
   <DESC>	</DESC>
   <RETURN></RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		al_special_claim_id
   </ARGS>
   <USAGE>Open special claim window</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03/06/16		CR4034            CCY018        First Version
   </HISTORY>
********************************************************************/

long ll_row, ll_found

if IsValid(w_specialclaim) then
else
	Opensheet(w_specialclaim, w_tramos_main, 0, Original!)
end if

w_specialclaim.setredraw(false)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Find, select and highlight record in special_list datawindow
ll_found = w_specialclaim.dw_picklist.find("special_claim_id = " + string(al_special_claim_id), 1, w_specialclaim.dw_picklist.rowcount( ))
if ll_found > 0 then				
	w_specialclaim.dw_picklist.setrow(ll_found)
	w_specialclaim.dw_picklist.scrolltorow(ll_found)
	w_specialclaim.dw_picklist.event clicked(0,0, ll_found, w_specialclaim.dw_picklist.object) 
end if

w_specialclaim.setredraw(true)
w_specialclaim.setfocus()


end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Description	</DESC>
   <RETURN></RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03/06/16 CR4034           CCY018        First Version
   </HISTORY>
********************************************************************/
end subroutine

on n_jump_specialclaims.create
call super::create
end on

on n_jump_specialclaims.destroy
call super::destroy
end on

