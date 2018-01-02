$PBExportHeader$u_jump_disbursement.sru
forward
global type u_jump_disbursement from nonvisualobject
end type
end forward

global type u_jump_disbursement from nonvisualobject
end type
global u_jump_disbursement u_jump_disbursement

forward prototypes
public function boolean of_checkdisbursement_windows ()
public subroutine of_open_disbursement (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn, string as_agent_sn)
public subroutine of_open_disbursement (integer ai_vessel_nr, string as_voyage_nr)
end prototypes

public function boolean of_checkdisbursement_windows ();Boolean lb_open = FALSE

IF 	IsValid(w_disb_last_payment) OR &
	Isvalid(w_disb_new_expense) OR &
	ISValid(w_disb_print_agent_balance) OR &
	IsValid(w_disb_print_disb_account) OR &
	IsValid(w_disb_print_payment) OR &
	IsValid(w_disb_print_port_expenses) OR &
	IsValid(w_disb_tc_exp_ex_rate) OR &
	IsValid(w_get_percentage) OR &
	IsValid(w_print_disbursement_account) THEN
	
	MessageBox("Request","One or more disbursement related windows are open." + & 
								"In order not to disrupt ongoing work, please finish your work or close these windows, " + &
								"except the main disbursement window.")
	lb_open = TRUE

END IF

Return lb_open
end function

public subroutine of_open_disbursement (integer ai_vessel_nr, string as_voyage_nr, string as_port_code, integer ai_pcn, string as_agent_sn);/********************************************************************
   of_open_disbursement
   <DESC>  </DESC>
   <RETURN>
		string
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
		as_port_code
		ai_pcn
		as_agent_sn
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		30/06/15		CR4100		XSZ004		Fix a bug.
   </HISTORY>
********************************************************************/

string ls_voyage_nr, ls_port_code, ls_agent_sn
integer li_pcn
long ll_row, ll_found

IF of_CheckDisbursement_windows() THEN Return

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_disbursements) THEN
	w_disbursements.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_disbursements,w_tramos_main,0,Original!)
END IF

w_disbursements.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Get attributes for searching record 
ls_voyage_nr = as_voyage_nr
ls_port_code = as_port_code
li_pcn = ai_pcn
ls_agent_sn = as_agent_sn

w_disbursements.ib_retrieve_detail = true

// Find, select and highlight record in disb_proc_list datawindow
ll_found = w_disbursements.dw_disb_proc_list.Find(&
				"proceed_voyage_nr = '" + ls_voyage_nr +&
				"' and proceed_port_code = '" + ls_port_code +&
				"' and proceed_pcn = " + string(li_pcn), &
				1, w_disbursements.dw_disb_proc_list.RowCount( ))
w_disbursements.dw_disb_proc_list.SetRow(ll_found)
w_disbursements.dw_disb_proc_list.ScrollToRow(ll_found)
w_disbursements.dw_disb_proc_list.TriggerEvent(Clicked!)

// Find, select and highlight record in disb_agents_list datawindow
ll_found = w_disbursements.dw_disb_agents_list.Find(&
				"agents_agent_sn = '" + ls_agent_sn + "'", &
				1, w_disbursements.dw_disb_agents_list.RowCount( ))
			
w_disbursements.dw_disb_agents_list.SetRow(ll_found)
w_disbursements.dw_disb_agents_list.ScrollToRow(ll_found)

w_disbursements.dw_disb_agents_list.TriggerEvent(Clicked!)

w_disbursements.SetRedraw(TRUE)
w_disbursements.SetFocus()

Return

	
end subroutine

public subroutine of_open_disbursement (integer ai_vessel_nr, string as_voyage_nr);/********************************************************************
   of_open_disbursement
   <DESC>  </DESC>
   <RETURN>
		string
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_vessel_nr
		as_voyage_nr
   </ARGS>
   <USAGE>       
	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		30/06/15		CR4100		XSZ004		Fix a bug.
   </HISTORY>
********************************************************************/

string ls_voyage_nr
long ll_row, ll_found

IF of_CheckDisbursement_windows() THEN Return

uo_global.setvessel_nr(ai_vessel_nr)
uo_global.setvoyage_nr(as_voyage_nr)

IF IsValid(w_disbursements) THEN
	w_disbursements.uo_vesselselect.of_setcurrentvessel( ai_vessel_nr )
ELSE
	Opensheet(w_disbursements,w_tramos_main,0,Original!)
END IF

w_disbursements.SetRedraw(FALSE)

yield()  //to allow message queue to be emptied. otherwise we will not find anything as lot of the 
			//retrieve statements are posted

// Get attributes for searching record 
ls_voyage_nr = as_voyage_nr

// Find, select and highlight record in disb_proc_list datawindow
ll_found = w_disbursements.dw_disb_proc_list.Find(&
				"proceed_voyage_nr = '" + ls_voyage_nr+"'" , &
				1, w_disbursements.dw_disb_proc_list.RowCount( ))

w_disbursements.ib_retrieve_detail = true				
				
w_disbursements.dw_disb_proc_list.SetRow(ll_found)
w_disbursements.dw_disb_proc_list.ScrollToRow(ll_found)

w_disbursements.dw_disb_proc_list.TriggerEvent(Clicked!)

w_disbursements.SetRedraw(TRUE)
w_disbursements.SetFocus()

Return

	
end subroutine

on u_jump_disbursement.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_jump_disbursement.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

