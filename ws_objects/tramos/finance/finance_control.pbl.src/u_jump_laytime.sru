$PBExportHeader$u_jump_laytime.sru
forward
global type u_jump_laytime from mt_n_nonvisualobject
end type
end forward

global type u_jump_laytime from mt_n_nonvisualobject autoinstantiate
end type

forward prototypes
public subroutine of_open_laytime (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr)
public subroutine documentation ()
end prototypes

public subroutine of_open_laytime (integer ai_vessel_nr, string as_voyage_nr, long al_chart_nr, long al_claim_nr);/********************************************************************
   of_open_laytime
   <DESC>	Description	</DESC>
   <RETURN>	(None)
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_vessel_nr : Vessel number
		as_voyage_nr : Voyage number
		al_chart_nr  : Charterer number
		al_claim_nr  : Claim number
   </ARGS>
   <USAGE>	Open the laytime window	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	06/08/2011   2411         ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_claim_type, ls_findexp
long		ll_row, ll_found

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

if isvalid(w_laytime) then
	w_laytime.uo_vesselselect.of_setcurrentvessel(ai_vessel_nr)
else
	opensheet(w_laytime, w_tramos_main, 0, original!)
end if

w_laytime.setredraw(false)

//To allow message queue to be emptied. otherwise we will not find anything as lot of the retrieve statements are posted
yield()

//Find, select and highlight record in claims_list datawindow
ls_findexp = "chart_nr = " + string(al_chart_nr) + " and vessel_nr = " + string(ai_vessel_nr) + &
             " and voyage_nr = '" + as_voyage_nr + "' and claim_nr = " + string(al_claim_nr)
				 
ll_found = w_laytime.dw_list_claims.find(ls_findexp, 1, w_laytime.dw_list_claims.rowcount())
if ll_found > 0 then
	w_laytime.dw_list_claims.setrow(ll_found)
	w_laytime.dw_list_claims.scrolltorow(ll_found)
	w_laytime.dw_list_claims.event clicked(0, 0, ll_found, w_laytime.dw_list_claims.object.voyage_nr)
end if

w_laytime.setredraw(true)

w_laytime.setfocus()

end subroutine

public subroutine documentation ();/********************************************************************
   u_jump_laytime
   <OBJECT>	Open or active laytime window	</OBJECT>
   <USAGE>	When double click dw_claims_settled datawindow	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date         CR-Ref       Author        Comments
   	06/08/2011   2411         ZSW001        First Version
   </HISTORY>
********************************************************************/

end subroutine

on u_jump_laytime.create
call super::create
end on

on u_jump_laytime.destroy
call super::destroy
end on

