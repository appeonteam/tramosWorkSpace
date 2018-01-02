$PBExportHeader$u_unsettled_agents.sru
$PBExportComments$For Global Agent Import file
forward
global type u_unsettled_agents from nonvisualobject
end type
end forward

global type u_unsettled_agents from nonvisualobject
event ue_clicked ( ref long al_row )
end type
global u_unsettled_agents u_unsettled_agents

type variables
datastore ids_unsettled_agents
end variables

forward prototypes
public subroutine of_setfilter ()
public subroutine of_clearfilter ()
public function boolean of_checkdisbursement_windows ()
public subroutine of_setrequester (ref datawindow adw)
public subroutine of_retrievedata ()
public subroutine of_gotodisbursement ()
end prototypes

event ue_clicked;ids_unsettled_agents.SetRow(al_row)

end event

public subroutine of_setfilter ();ids_unsettled_agents.SetFilter("agents_import_file = 1")
ids_unsettled_agents.Filter()
end subroutine

public subroutine of_clearfilter ();ids_unsettled_agents.SetFilter("")
ids_unsettled_agents.Filter()
end subroutine

public function boolean of_checkdisbursement_windows ();Boolean lb_open = FALSE

IF IsValid(w_disb_last_payment) OR &
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

public subroutine of_setrequester (ref datawindow adw);ids_unsettled_agents.sharedata(adw)
return
end subroutine

public subroutine of_retrievedata ();ids_unsettled_agents.Retrieve()
Return
end subroutine

public subroutine of_gotodisbursement ();string ls_voyage_nr, ls_port_code, ls_agent_sn
integer li_pcn
long ll_row, ll_found

IF of_CheckDisbursement_windows() THEN Return

ll_row = ids_unsettled_agents.GetRow()
uo_global.SetVessel_nr(ids_unsettled_agents.GetItemNumber(ll_row,"disb_expenses_vessel_nr"))

IF IsValid(w_disbursements) THEN
	w_disbursements.TriggerEvent(Open!)
ELSE
	OpenSheet(w_disbursements,w_tramos_main,0,Original!)
END IF

w_disbursements.SetRedraw(FALSE)

// Get attributes for searching record 
ls_voyage_nr = ids_unsettled_agents.GetItemString(ll_row,"disb_expenses_voyage_nr")
ls_port_code = ids_unsettled_agents.GetItemString(ll_row,"disb_expenses_port_code")
li_pcn = ids_unsettled_agents.GetItemNumber(ll_row,"disb_expenses_pcn")
ls_agent_sn = ids_unsettled_agents.GetItemString(ll_row,"agents_agent_sn")
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

on u_unsettled_agents.create
TriggerEvent( this, "constructor" )
end on

on u_unsettled_agents.destroy
TriggerEvent( this, "destructor" )
end on

event constructor;ids_unsettled_agents = CREATE datastore
ids_unsettled_agents.DataObject = "d_unsettled_agents"
ids_unsettled_agents.SetTransObject(SQLCA)
end event

event destructor;IF IsValid(ids_unsettled_agents) THEN DESTROY ids_unsettled_agents
end event

