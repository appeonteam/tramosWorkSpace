$PBExportHeader$w_tc_contract.srw
$PBExportComments$Main TC Hire window
forward
global type w_tc_contract from w_tc_sheet_ancestor
end type
type uo_vesselselect from u_vessel_selection within w_tc_contract
end type
type cb_dontusethis from mt_u_commandbutton within w_tc_contract
end type
type cb_refresh from mt_u_commandbutton within w_tc_contract
end type
type cb_delete from mt_u_commandbutton within w_tc_contract
end type
type cb_cancel from mt_u_commandbutton within w_tc_contract
end type
type cb_save from mt_u_commandbutton within w_tc_contract
end type
type cb_new from mt_u_commandbutton within w_tc_contract
end type
type cb_pay_test from mt_u_commandbutton within w_tc_contract
end type
type tab_tc from tab within w_tc_contract
end type
type tp_periods from userobject within tab_tc
end type
type dw_periods from u_ntchire_grid_dw within tp_periods
end type
type tp_periods from userobject within tab_tc
dw_periods dw_periods
end type
type tp_port_exp from userobject within tab_tc
end type
type st_2 from statictext within tp_port_exp
end type
type st_1 from statictext within tp_port_exp
end type
type rb_outstanding from radiobutton within tp_port_exp
end type
type rb_settled from radiobutton within tp_port_exp
end type
type rb_all from radiobutton within tp_port_exp
end type
type dw_port_exp from u_ntchire_grid_dw within tp_port_exp
end type
type gb_filter from groupbox within tp_port_exp
end type
type tp_port_exp from userobject within tab_tc
st_2 st_2
st_1 st_1
rb_outstanding rb_outstanding
rb_settled rb_settled
rb_all rb_all
dw_port_exp dw_port_exp
gb_filter gb_filter
end type
type tp_non_port_exp from userobject within tab_tc
end type
type rb_npe_unsettled from radiobutton within tp_non_port_exp
end type
type rb_npe_settled from radiobutton within tp_non_port_exp
end type
type rb_all_settled from radiobutton within tp_non_port_exp
end type
type rb_inc_exp from radiobutton within tp_non_port_exp
end type
type rb_income from radiobutton within tp_non_port_exp
end type
type rb_expense from radiobutton within tp_non_port_exp
end type
type dw_non_port_exp from u_ntchire_grid_dw within tp_non_port_exp
end type
type gb_filter_npe from groupbox within tp_non_port_exp
end type
type gb_filter_settled from groupbox within tp_non_port_exp
end type
type tp_non_port_exp from userobject within tab_tc
rb_npe_unsettled rb_npe_unsettled
rb_npe_settled rb_npe_settled
rb_all_settled rb_all_settled
rb_inc_exp rb_inc_exp
rb_income rb_income
rb_expense rb_expense
dw_non_port_exp dw_non_port_exp
gb_filter_npe gb_filter_npe
gb_filter_settled gb_filter_settled
end type
type tp_off_services from userobject within tab_tc
end type
type dw_off_services from u_ntchire_dw within tp_off_services
end type
type tp_off_services from userobject within tab_tc
dw_off_services dw_off_services
end type
type tabpage_uo_att from userobject within tab_tc
end type
type uo_tc_att from u_fileattach within tabpage_uo_att
end type
type tabpage_uo_att from userobject within tab_tc
uo_tc_att uo_tc_att
end type
type tab_tc from tab within w_tc_contract
tp_periods tp_periods
tp_port_exp tp_port_exp
tp_non_port_exp tp_non_port_exp
tp_off_services tp_off_services
tabpage_uo_att tabpage_uo_att
end type
type dw_contract_expenses from u_ntchire_grid_dw within w_tc_contract
end type
type dw_brokercomm from u_ntchire_grid_dw within w_tc_contract
end type
type dw_contract_list from u_ntchire_grid_dw within w_tc_contract
end type
type dw_contract from u_ntchire_dw within w_tc_contract
end type
type st_3 from u_topbar_background within w_tc_contract
end type
type dw_bankdetail from u_popupdw within w_tc_contract
end type
end forward

global type w_tc_contract from w_tc_sheet_ancestor
integer width = 4608
integer height = 2568
string title = "T/C Hire Contract"
boolean maxbox = false
boolean resizable = false
string icon = "images\tcmenu.ico"
boolean ib_setdefaultbackgroundcolor = true
event ue_actionlog ( )
event ue_cancel ( )
event ue_refresh ( )
event ue_bareboatmanagement ( )
event ue_rbuttondblclk pbm_rbuttondblclk
uo_vesselselect uo_vesselselect
cb_dontusethis cb_dontusethis
cb_refresh cb_refresh
cb_delete cb_delete
cb_cancel cb_cancel
cb_save cb_save
cb_new cb_new
cb_pay_test cb_pay_test
tab_tc tab_tc
dw_contract_expenses dw_contract_expenses
dw_brokercomm dw_brokercomm
dw_contract_list dw_contract_list
dw_contract dw_contract
st_3 st_3
dw_bankdetail dw_bankdetail
end type
global w_tc_contract w_tc_contract

type variables
/* Variables for Vessel DropDown */
boolean 			ib_vessel_no_trig = FALSE
boolean 			ib_vessel_name_trig = FALSE
string 			is_menustate  

/* TC Contract Non-visual */
n_tc_contract	inv_contract
n_service_manager inv_servicemgr
string is_vesselpc_statementtext 
long _ii_secret_counter = 0

end variables

forward prototypes
public function integer wf_npe_filter ()
public function integer wf_tabdatamodified ()
public function integer wf_datamodified ()
public subroutine wf_update_picklist ()
public subroutine wf_updatemenu (string as_status)
public subroutine document ()
public subroutine _set_permission (boolean abl_enable)
public function integer wf_deleteattachment ()
end prototypes

event ue_actionlog();long ll_contractID

ll_contractID = inv_contract.of_getContractID()
IF not isnull(ll_contractID) then
	openwithparm(w_action_log, ll_contractID)
end if
end event

event ue_cancel();long ll_row,ll_contract_id

if upper(is_menuState) = "NEW" then 
	inv_contract.of_resetAll()
	wf_updatemenu("vessel")
//	dw_contract_list.Post retrieve(li_vessel_nr)
	dw_contract_list.Post retrieve(inv_contract.of_getvesselnr( ) )
	dw_contract_list.Post setfocus()
elseif upper(is_menuState) = "NEWEXPENSE" then
	wf_updatemenu("contract")
	tab_tc.tp_non_port_exp.dw_non_port_exp.Post retrieve(inv_contract.of_getcontractid())
	tab_tc.tp_non_port_exp.dw_non_port_exp.Post setfocus()
elseif upper(is_menuState) = "NEWATTACH" then//NEWESTEXP
	wf_updatemenu("contract")
	tab_tc.tabpage_uo_att.uo_tc_att.of_cancelchanges()
	tab_tc.tabpage_uo_att.uo_tc_att.of_init()
	tab_tc.tabpage_uo_att.uo_tc_att.post setfocus()
end if
end event

event ue_refresh();/* This event is created so that other windows can POST a refresh of it */
cb_refresh.TriggerEvent(Clicked!)
end event

event ue_bareboatmanagement();dw_contract.accepttext()
if dw_contract.getItemNumber(1, "bareboat") = 1 and dw_contract.getItemNumber(1, "tc_hire_in") = 1 then 
	inv_contract.of_bareboatmanagement( )
end if

end event

event ue_rbuttondblclk;if keydown(keyAlt!) and keydown(keyShift!) and keydown(keyZ!) then
	_ii_secret_counter++
	if _ii_secret_counter = 10  then
		cb_dontusethis.visible = not cb_dontusethis.visible
		_ii_secret_counter = 0
	end if
end if
end event

public function integer wf_npe_filter ();STRING	ls_filter1, ls_filter2, ls_filter

tab_tc.tp_non_port_exp.dw_non_port_exp.accepttext( )

IF tab_tc.tp_non_port_exp.rb_expense.checked = true then
	ls_filter1 = "income = 0"
ELSEIF tab_tc.tp_non_port_exp.rb_income.checked = true then
	ls_filter1 = "income = 1"
ELSE
	ls_filter1 = ""
END IF

IF tab_tc.tp_non_port_exp.rb_npe_settled.checked = TRUE THEN
	ls_filter2 = "payment_status > 2" //i.e. status final (3), part-paid (4) or paid (5)
ELSEIF tab_tc.tp_non_port_exp.rb_npe_unsettled.checked = TRUE THEN
	ls_filter2 = "payment_status < 3" //i.e. status new (1) or draft (2)
ELSE 
	ls_filter2 = ""
END IF

IF ls_filter2 <> "" AND ls_filter1 <> "" THEN
	ls_filter = ls_filter1 + " AND " + ls_filter2
ELSEIF ls_filter1 = "" THEN
	ls_filter = ls_filter2
ELSE
	ls_filter = ls_filter1
END IF

tab_tc.tp_non_port_exp.dw_non_port_exp.setfilter(ls_filter)
tab_tc.tp_non_port_exp.dw_non_port_exp.filter()

return 1
end function

public function integer wf_tabdatamodified ();/* Checks if there are any data modified but not saved in the tab pages.
Only checks the tab pages Port Exp, Non-Port Exp and Off-Services (i.e. NOT Periods). Reason: 
When a new contract is created, a row is inserted in Periods, and the Periods tab page is
selected. This triggers a selectionchanging event, which triggers this function 
(wf_tabdatamodified) - which therefore will give an misleading result.
	
	returns  0 No unsaved data
				1 unsaved data 
*/

integer li_modify

//tab_tc.tp_periods.dw_periods.acceptText()
tab_tc.tp_port_exp.dw_port_exp.acceptText()
tab_tc.tp_non_port_exp.dw_non_port_exp.acceptText()
tab_tc.tp_off_services.dw_off_services.acceptText()
tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.accepttext()

li_modify = /*tab_tc.tp_periods.dw_periods.modifiedCount() +*/&
				/*tab_tc.tp_periods.dw_periods.deletedCount() +*/&
				tab_tc.tp_non_port_exp.dw_non_port_exp.modifiedcount() +&
				tab_tc.tp_non_port_exp.dw_non_port_exp.deletedcount() +&
				tab_tc.tp_port_exp.dw_port_exp.modifiedcount() +&
				tab_tc.tp_port_exp.dw_port_exp.deletedcount() +&
				tab_tc.tp_off_services.dw_off_services.modifiedcount() +&
				tab_tc.tp_off_services.dw_off_services.deletedcount() +&
				tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.modifiedcount() +&
				tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.deletedcount()

return li_modify
end function

public function integer wf_datamodified ();/* Checks if there are any data modified but not saved
	
	returns  0 No unsaved data
				1 unsaved data 
*/
integer li_contract_modify

dw_contract.acceptText()
dw_brokercomm.acceptText()
dw_contract_expenses.acceptText()
tab_tc.tp_periods.dw_periods.acceptText()
li_contract_modify = dw_contract.modifiedCount() +&
							dw_contract.deletedCount() +&
							dw_brokercomm.modifiedCount() +&
							dw_brokercomm.deletedCount() +&
							dw_contract_expenses.modifiedCount() +&
							dw_contract_expenses.deletedCount() +&
							tab_tc.tp_periods.dw_periods.modifiedCount() +&
							tab_tc.tp_periods.dw_periods.deletedCount() +&
							inv_contract.ids_bareboat_management.modifiedcount( ) +&
							inv_contract.ids_share_member.modifiedcount() +&
							inv_contract.ids_share_member.deletedcount( ) +&
							inv_contract.ids_bareboat_management.deletedcount( )

IF li_contract_modify <> 0 THEN
	dw_contract.setfocus()
	RETURN 1
END IF

return 0

end function

public subroutine wf_update_picklist ();long ll_row

ll_row = dw_contract_list.getSelectedRow(0)
if ll_row > 0 then
	dw_contract_list.setItem(ll_row, "contract_id", &
									dw_contract.getItemNumber(1, "contract_id"))
	dw_contract_list.setItem(ll_row, "cp_date", &
									dw_contract.getItemDateTime(1, "cp_date"))
	dw_contract_list.setItem(ll_row, "chart_n_1", &
									dw_contract.getItemString(1, "chart_n_1"))
	dw_contract_list.setItem(ll_row, "tcowner_n_1", &
									dw_contract.getItemString(1, "tcowner_n_1"))
	dw_contract_list.setItem(ll_row, "tc_hire_in", &
									dw_contract.getItemNumber(1, "tc_hire_in"))
	dw_contract_list.setItem(ll_row, "in_pool", &
									dw_contract.getItemNumber(1, "in_pool"))
	dw_contract_list.setItem(ll_row, "bareboat", &
									dw_contract.getItemNumber(1, "bareboat"))
	dw_contract_list.setItem(ll_row, "delivery", &
									dw_contract.getItemDatetime(1, "delivery"))
	dw_contract_list.sort()								
end if

return
end subroutine

public subroutine wf_updatemenu (string as_status);/* This function updates if menu items are available or not 
	as well as enables/disables window controls
	
	ab_status can have following values:
	
		windowOpen		= w_tc_contract opened 
		windowClose		= w_tc_contract not open	
		vessel				= vessel selected
		contract				= contract selected
		new					= new contract
		newexpense		= new non-port expense
		newestexp			= new ATTACHMENT
*/

if upper(w_tramos_main.menuname) = "M_TCMAIN" then
	is_menuState = as_status
	CHOOSE CASE upper(as_status)
		CASE "WINDOWOPEN"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = false
			m_tcmain.m_menutop2.m_save.enabled = false
			m_tcmain.m_menutop2.m_cancel.enabled = false
			m_tcmain.m_menutop2.m_delete.enabled = false
			/* Window buttons */
			cb_new.enabled = false
			cb_save.enabled = false
			cb_cancel.enabled = false
			cb_delete.enabled = false
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = false
			m_tcmain.m_menutop3.m_showfixturenote.enabled = false
			m_tcmain.m_menutop3.m_finish.enabled = false
			m_tcmain.m_menutop3.m_un-finish.enabled = false
			m_tcmain.m_menutop3.m_actionlog.enabled = false
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = false
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = false
			/* Visual Controls */
			uo_vesselselect.enabled = true
			dw_contract_list.enabled = false
			dw_contract.enabled = false
			dw_brokercomm.enabled = false
			dw_contract_expenses.enabled = false
			tab_tc.tp_periods.enabled = false
			tab_tc.tp_port_exp.enabled = false
			tab_tc.tp_non_port_exp.enabled = false
			tab_tc.tp_off_services.enabled = false
			tab_tc.tabpage_uo_att.enabled = false
		CASE "VESSEL"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = true
			m_tcmain.m_menutop2.m_save.enabled = false
			m_tcmain.m_menutop2.m_cancel.enabled = false
			m_tcmain.m_menutop2.m_delete.enabled = false
			/* Window buttons */
			cb_new.enabled = true
			cb_save.enabled = false
			cb_cancel.enabled = false
			cb_delete.enabled = false
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = false
			m_tcmain.m_menutop3.m_showfixturenote.enabled = false
			m_tcmain.m_menutop3.m_finish.enabled = false
			m_tcmain.m_menutop3.m_un-finish.enabled = false
			m_tcmain.m_menutop3.m_actionlog.enabled = false
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = false
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = false
			/* Visual Controls */
			uo_vesselselect.enabled = true
			dw_contract_list.enabled = true
			dw_contract.enabled = false
			dw_brokercomm.enabled = false
			dw_contract_expenses.enabled = false
			tab_tc.tp_periods.enabled = false
			tab_tc.tp_port_exp.enabled = false
			tab_tc.tp_non_port_exp.enabled = false
			tab_tc.tp_off_services.enabled = false
			tab_tc.tabpage_uo_att.enabled = false
		CASE "CONTRACT"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = true
			m_tcmain.m_menutop2.m_save.enabled = true
			m_tcmain.m_menutop2.m_cancel.enabled = false
			m_tcmain.m_menutop2.m_delete.enabled = true
			/* Window buttons */
			cb_new.enabled = true
			cb_save.enabled = true
			cb_cancel.enabled = false
			cb_delete.enabled = true
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = true
			m_tcmain.m_menutop3.m_showfixturenote.enabled = true
			m_tcmain.m_menutop3.m_finish.enabled = true
			m_tcmain.m_menutop3.m_un-finish.enabled = true
			m_tcmain.m_menutop3.m_actionlog.enabled = true
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = true
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = true
			
			/* Visual Controls */
			uo_vesselselect.enabled = true
			dw_contract_list.enabled = true
			dw_contract.enabled = true
			dw_brokercomm.enabled = true
			dw_contract_expenses.enabled = true
			tab_tc.tp_periods.enabled = true
			tab_tc.tp_port_exp.enabled = true
			tab_tc.tp_non_port_exp.enabled = true
			tab_tc.tp_off_services.enabled = true
			tab_tc.tabpage_uo_att.enabled = true
			/* give access for admin to change headowner */
			IF uo_global.ii_access_level = 3 THEN
				dw_contract.setTabOrder("tcowner_n_1", 75)
			END IF
	CASE "NEW"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = true
			m_tcmain.m_menutop2.m_save.enabled = true
			m_tcmain.m_menutop2.m_cancel.enabled = true
			m_tcmain.m_menutop2.m_delete.enabled = true
			/* Window buttons */
			cb_new.enabled = true
			cb_save.enabled = true
			cb_cancel.enabled = true
			cb_delete.enabled = true
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = false
			m_tcmain.m_menutop3.m_showfixturenote.enabled = false
			m_tcmain.m_menutop3.m_finish.enabled = false
			m_tcmain.m_menutop3.m_un-finish.enabled = false
			m_tcmain.m_menutop3.m_actionlog.enabled = false
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = false
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = false
			/* Visual Controls */
			uo_vesselselect.enabled = false
			dw_contract_list.enabled = false
			dw_contract.enabled = true
			dw_brokercomm.enabled = true
			dw_contract_expenses.enabled = true
			tab_tc.tp_periods.enabled = true
			tab_tc.tp_port_exp.enabled = false
			tab_tc.tp_non_port_exp.enabled = false
			tab_tc.tp_off_services.enabled = false
			tab_tc.tabpage_uo_att.enabled = false
			dw_contract.setfocus()
			/* remove access for admin to change headowner */
			dw_contract.setTabOrder("tcowner_n_1", 0)
	CASE "NEWEXPENSE"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = true
			m_tcmain.m_menutop2.m_save.enabled = true
			m_tcmain.m_menutop2.m_cancel.enabled = true
			m_tcmain.m_menutop2.m_delete.enabled = true
			/* Window buttons */
			cb_new.enabled = true
			cb_save.enabled = true
			cb_cancel.enabled = true
			cb_delete.enabled = true
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = false
			m_tcmain.m_menutop3.m_showfixturenote.enabled = false
			m_tcmain.m_menutop3.m_finish.enabled = false
			m_tcmain.m_menutop3.m_un-finish.enabled = false
			m_tcmain.m_menutop3.m_actionlog.enabled = false
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = false
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = false
			/* Visual Controls */
			uo_vesselselect.enabled = false
			dw_contract_list.enabled = false
			dw_contract.enabled = false
			dw_brokercomm.enabled = false
			dw_contract_expenses.enabled = false
			tab_tc.tp_periods.enabled = false
			tab_tc.tp_port_exp.enabled = false
			tab_tc.tp_non_port_exp.enabled = true
			tab_tc.tp_off_services.enabled = false
			tab_tc.tabpage_uo_att.enabled = false
			tab_tc.tp_non_port_exp.dw_non_port_exp.setfocus()
			
	CASE "NEWATTACH"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = true
			m_tcmain.m_menutop2.m_save.enabled = true
			m_tcmain.m_menutop2.m_cancel.enabled = true
			m_tcmain.m_menutop2.m_delete.enabled = true
			/* Window buttons */
			cb_new.enabled = true
			cb_save.enabled = true
			cb_cancel.enabled = true
			cb_delete.enabled = true
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = false
			m_tcmain.m_menutop3.m_showfixturenote.enabled = false
			m_tcmain.m_menutop3.m_finish.enabled = false
			m_tcmain.m_menutop3.m_un-finish.enabled = false
			m_tcmain.m_menutop3.m_actionlog.enabled = false
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = false
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = false
			/* Visual Controls */
			uo_vesselselect.enabled = false
			dw_contract_list.enabled = false
			dw_contract.enabled = false
			dw_brokercomm.enabled = false
			dw_contract_expenses.enabled = false
			tab_tc.tp_periods.enabled = false
			tab_tc.tp_port_exp.enabled = false
			tab_tc.tp_non_port_exp.enabled = false
			tab_tc.tp_off_services.enabled = false
			tab_tc.tabpage_uo_att.enabled = true
			tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.setfocus()
			idw_current = tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing
	CASE "WINDOWCLOSE"
			/* Edit */
			m_tcmain.m_menutop2.m_open.enabled = true
			m_tcmain.m_menutop2.m_new.enabled = false
			m_tcmain.m_menutop2.m_save.enabled = false
			m_tcmain.m_menutop2.m_cancel.enabled = false
			m_tcmain.m_menutop2.m_delete.enabled = false
			/* Window buttons */
			cb_new.enabled = false
			cb_save.enabled = false
			cb_cancel.enabled = false
			cb_delete.enabled = false
			/* Go */
			m_tcmain.m_menutop3.m_fixture.enabled = false
			m_tcmain.m_menutop3.m_showfixturenote.enabled = false
			m_tcmain.m_menutop3.m_finish.enabled = false
			m_tcmain.m_menutop3.m_un-finish.enabled = false
			m_tcmain.m_menutop3.m_actionlog.enabled = false
			m_tcmain.m_menutop3.m_sendtoweeklyfixture.enabled = false
			m_tcmain.m_menutop3.m_bareboatmanagement.enabled = false
	END CHOOSE
end if

end subroutine

public subroutine document ();/********************************************************************
   w_tc_contract
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		02-08-2011  2485  		LHC010		add bank account
		21-11-2011	2625  		CONASW		Changed office selection DW (to get active offices only)
		07-05-2012	M5-12 		LHC010		Check payment status exists New or Draft
		26-06-2012	2851  		LGX001		fixed bug
		25-02-2014	CR3303		ZSW001		Retrieve data result without post
		10-12-2014  CR3570		KSH092		Add tabpage Contract Attachments
		10-12-2014  CR3565		KSH092		Remove OPSA setup
		10-12-2014  CR3902		KSH092		Remove Bareboat management
		09/04/15  	CR3854		XSZ004		Recalculate Net amount after matching.				
   </HISTORY>
********************************************************************/

end subroutine

public subroutine _set_permission (boolean abl_enable);/********************************************************************
   _set_permissions
   <DESC>Access control for tabpages in this window.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		24/11/2014		CR3750		KSH092		First Version	      
   </HISTORY>
********************************************************************/

if abl_enable = true then
	tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.modify("Datawindow.ReadOnly = 'No'")


else
	tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.modify("Datawindow.ReadOnly = 'Yes'")
	
	
end if

end subroutine

public function integer wf_deleteattachment ();/********************************************************************
   wf_deleteattachment
   <DESC>delete attachment.</DESC>
   <RETURN>	(none)  
   <ACCESS> private </ACCESS>
   <ARGS>	
   </ARGS>
   <USAGE> n_tc_contract.of_deletecontract</USAGE>
   <HISTORY>
   	Date				CR-Ref		Author		Comments
  		23/01/2015		CR3750		KSH092		First Version	      
   </HISTORY>
********************************************************************/
int li_count,li_i,li_rc_attachment
n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
					 

tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.accepttext( )

li_count = tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.rowcount()
if li_count > 0 then
	for li_i = li_count to 1 step -1
		tab_tc.tabpage_uo_att.uo_tc_att.of_deleteimage(li_i, true)
	next
	lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
	lnv_actionrules.of_registerrulestring("description", true, "description")
	if lnv_actionrules.of_validate(tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing, true) = c#return.Failure then return -1
	
	li_rc_attachment = tab_tc.tabpage_uo_att.uo_tc_att.of_updateattach() 
	if li_rc_attachment < 0 then
		Rollback;
		Messagebox("Error message; "+ this.ClassName(), "Contract Attachments Update failed~r~nRC=" + String(li_rc_attachment))
		return -1
	else
		return 1
		
	end if
else
	return 1
end if
end function

on w_tc_contract.create
int iCurrent
call super::create
this.uo_vesselselect=create uo_vesselselect
this.cb_dontusethis=create cb_dontusethis
this.cb_refresh=create cb_refresh
this.cb_delete=create cb_delete
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
this.cb_new=create cb_new
this.cb_pay_test=create cb_pay_test
this.tab_tc=create tab_tc
this.dw_contract_expenses=create dw_contract_expenses
this.dw_brokercomm=create dw_brokercomm
this.dw_contract_list=create dw_contract_list
this.dw_contract=create dw_contract
this.st_3=create st_3
this.dw_bankdetail=create dw_bankdetail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_vesselselect
this.Control[iCurrent+2]=this.cb_dontusethis
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.cb_delete
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_save
this.Control[iCurrent+7]=this.cb_new
this.Control[iCurrent+8]=this.cb_pay_test
this.Control[iCurrent+9]=this.tab_tc
this.Control[iCurrent+10]=this.dw_contract_expenses
this.Control[iCurrent+11]=this.dw_brokercomm
this.Control[iCurrent+12]=this.dw_contract_list
this.Control[iCurrent+13]=this.dw_contract
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.dw_bankdetail
end on

on w_tc_contract.destroy
call super::destroy
destroy(this.uo_vesselselect)
destroy(this.cb_dontusethis)
destroy(this.cb_refresh)
destroy(this.cb_delete)
destroy(this.cb_cancel)
destroy(this.cb_save)
destroy(this.cb_new)
destroy(this.cb_pay_test)
destroy(this.tab_tc)
destroy(this.dw_contract_expenses)
destroy(this.dw_brokercomm)
destroy(this.dw_contract_list)
destroy(this.dw_contract)
destroy(this.st_3)
destroy(this.dw_bankdetail)
end on

event open;call super::open;Integer li_profile
n_dw_style_service   lnv_style

dw_contract_list.SetTransObject(SQLCA)
tab_tc.tp_port_exp.dw_port_exp.SetTransObject(SQLCA)
tab_tc.tp_non_port_exp.dw_non_port_exp.SetTransObject(SQLCA)
tab_tc.tp_off_services.dw_off_services.SetTransObject(SQLCA)

uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.of_registerwindow(w_tc_contract)
uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( tab_tc.tp_port_exp.dw_port_exp, false)
lnv_style.of_dwlistformater( tab_tc.tp_non_port_exp.dw_non_port_exp, false)
lnv_style.of_dwformformater( tab_tc.tp_off_services.dw_off_services)


lnv_style.of_dwlistformater( dw_contract_list, false)
lnv_style.of_dwformformater( dw_contract)
lnv_style.of_registercolumn("cp_date", true)
lnv_style.of_registercolumn("curr_code", true)
lnv_style.of_registercolumn("office_name", true)
lnv_style.of_registercolumn("statement_logo_text", true)
lnv_style.of_registercolumn("delivery", true)
//lnv_style.of_registercolumn("payment", true)
lnv_style.of_dwlistformater( dw_contract_expenses, false)
lnv_style.of_dwlistformater( dw_brokercomm, false)


lnv_style.of_dwlistformater( tab_tc.tp_periods.dw_periods, false)

IF uo_global.ii_user_profile  <> 3 and uo_global.ii_access_level <> 3 then
	dw_contract.object.opsa_setup.protect = 1
	tab_tc.tp_non_port_exp.dw_non_port_exp.object.use_in_vas.protect = 1
	tab_tc.tp_off_services.dw_off_services.object.use_in_vas.protect = 1
END IF

//Contract Attachment

tab_tc.tabpage_uo_att.uo_tc_att.of_init()
tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.modify("description.width = 3046")


tab_tc.tabpage_uo_att.uo_tc_att.of_addupdatetable("ATTACHMENTS","file_id")
tab_tc.tabpage_uo_att.uo_tc_att.of_addupdatetable("NTC_TC_ACTION","contract_id,file_id,assigned_to,action_finished,action_due_date,action_date","contract_id,file_id")
tab_tc.tabpage_uo_att.uo_tc_att.visible = true
tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.ib_columntitlesort = true
tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.ib_multicolumnsort = true
tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.ib_setselectrow = true

IF uo_global.ii_access_level = -1 THEN 
	_set_permission(false)
else
	_set_permission(true)
end if
uo_vesselselect.of_registerdw( dw_contract_list )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

inv_contract = CREATE n_tc_contract

inv_contract.of_sharedatastores(dw_contract, dw_brokercomm, &
											dw_contract_expenses, &
											tab_tc.tp_periods.dw_periods, &
											tab_tc.tp_non_port_exp.dw_non_port_exp )
											
dw_contract_list.SetRowFocusIndicator(FocusRect!)

wf_updatemenu("windowOpen")





end event

event activate;If w_tramos_main.MenuName <> "m_tcmain" Then 
	w_tramos_main.ChangeMenu(m_tcmain)
End if

wf_updateMenu(is_menuState)
uo_vesselselect.of_setshowtext( )

m_tcmain.mf_setlink(dw_contract, "vessel_nr", True)


end event

event close;call super::close;//if upper(w_tramos_main.menuname) = "M_TCMAIN" then
//	m_tcmain.m_menutop2.m_close.Event Clicked()
//end if
dw_contract.shareDataOff() 
dw_brokercomm.shareDataOff()
dw_contract_expenses.shareDataOff()
tab_tc.tp_periods.dw_periods.shareDataOff()


destroy inv_contract 
end event

event closequery;call super::closequery;n_dw_validation_service 	lnv_actionrules
if wf_datamodified() > 0 then 
	if MessageBox("Data not saved", "There are unsaved changes in the contract or on the Periods tab.~n~r~n~r" &
						 +"Do you want to save the data and continue?", Question!, YesNo!, 1) = 1 then
		if inv_contract.of_validate() = -1 then
			return 1
		end if
		if inv_contract.of_update() = 1 then

			if tab_tc.TRIGGER EVENT selectionchanging(tab_tc.selectedtab, tab_tc.selectedtab) = 1 then
				return 1
			end if
		end if
	else
		if tab_tc.TRIGGER EVENT selectionchanging(tab_tc.selectedtab, tab_tc.selectedtab) = 1 then
			return 1
		end if
		wf_updatemenu("windowClose")
		return 0 //allow window to close
	end if
else
	if tab_tc.TRIGGER EVENT selectionchanging(tab_tc.selectedtab, tab_tc.selectedtab) = 1 then
	 	return 1
	end if

end if

wf_updatemenu("windowClose")
return 0 //allow window to close
end event

event doubleclicked;call super::doubleclicked;//cb_dontusethis.visible = not cb_dontusethis.visible
end event

event ue_eventroute;call super::ue_eventroute;n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
int                        li_rc_attachment
if as_event = 'ue_cancel' then
	this.event ue_cancel()
else
	
	if idw_current.dataobject = 'd_sq_ff_ntc_tc_action_files' then
		choose case as_event
			case 'ue_insertrow'
				wf_updateMenu("newattach")
				w_tc_contract.tab_tc.tabpage_uo_att.uo_tc_att.event ue_insertrow()
			case 'ue_deleterow'
				w_tc_contract.tab_tc.tabpage_uo_att.uo_tc_att.event ue_delete()
			case 'ue_update'
				w_tc_contract.tab_tc.tabpage_uo_att.uo_tc_att.event ue_update()
				wf_updateMenu("contract")
	
		end choose
	else
		idw_current.triggerevent(as_event)
	end if
end if


end event

type uo_vesselselect from u_vessel_selection within w_tc_contract
integer x = 23
integer taborder = 10
end type

on uo_vesselselect.destroy
call u_vessel_selection::destroy
end on

type cb_dontusethis from mt_u_commandbutton within w_tc_contract
boolean visible = false
integer x = 3877
integer y = 32
integer taborder = 20
string text = "Don~'t use this"
end type

event clicked;/* This button becomes visible when doubleclick on window background
	Is used to open New TC Conversion Window */

open (w_delme_convert_contract)
end event

type cb_refresh from mt_u_commandbutton within w_tc_contract
integer x = 4224
integer y = 32
integer taborder = 30
string text = "&Refresh"
end type

event clicked;long ll_row

ll_row = dw_contract_list.getRow()

if ll_row < 1 then return

if upper(is_menuState) = "NEW" then 
	if wf_datamodified() > 0 then
		if MessageBox("Data not saved", "There are unsaved changes in the contract or on the Periods tab.~n~r~n~r" &
						 +"Do you want to save the data and continue?", Question!, YesNo!, 1) = 1 then
			IF inv_contract.of_update() = 1 then 
				wf_update_picklist()
				wf_updateMenu("contract")
			ELSE //update failed
				dw_contract.setredraw(true)
				RETURN
			END IF //update()=1
		end if //Messagebox
	end if //wf_datamodified > 0
	inv_contract.of_resetAll()
	wf_updatemenu("vessel")
	dw_contract_list.Post retrieve(inv_contract.of_getvesselnr( ) )
	dw_contract_list.Post setfocus()
else
	dw_contract_list.Event Clicked(0,0,ll_row, dw_contract_list.object)
end if

end event

type cb_delete from mt_u_commandbutton within w_tc_contract
integer x = 3881
integer y = 2372
integer taborder = 130
string text = "&Delete"
end type

event clicked;string ls_vesselrefno

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ls_vesselrefno = uo_vesselselect.dw_vessel.getitemstring(1,'vessel_ref_nr')
if isnull(ls_vesselrefno) or trim(ls_vesselrefno) = '' then
	return
end if

if upper(w_tramos_main.menuname) = "M_TCMAIN" then
	m_tcmain.m_menutop2.m_delete.Event Clicked()
end if


/* Refresh statement window if open, and same contract */
if isValid(w_hire_statement) then
	if inv_contract.of_getcontractid( ) = w_hire_statement.wf_getContractID() then
		w_hire_statement.postevent("ue_refresh")
	end if
end if

end event

type cb_cancel from mt_u_commandbutton within w_tc_contract
integer x = 4229
integer y = 2372
integer taborder = 140
string text = "&Cancel"
end type

event clicked;IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if upper(w_tramos_main.menuname) = "M_TCMAIN" then
	m_tcmain.m_menutop2.m_cancel.Event Clicked()
end if
end event

type cb_save from mt_u_commandbutton within w_tc_contract
integer x = 3534
integer y = 2372
integer taborder = 120
string text = "Sa&ve"
end type

event clicked;
IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if upper(w_tramos_main.menuname) = "M_TCMAIN" then
		m_tcmain.m_menutop2.m_save.Event Clicked()
end if

if isValid(w_tc_payments) then
	w_tc_payments.PostEvent("ue_refresh")
end if

/* Refresh statement window if open, and same contract */
if isValid(w_hire_statement) then
	if inv_contract.of_getcontractid( ) = w_hire_statement.wf_getContractID() then
		w_hire_statement.postevent("ue_refresh")
	end if
end if

end event

type cb_new from mt_u_commandbutton within w_tc_contract
integer x = 3186
integer y = 2372
integer taborder = 110
string text = "&New"
end type

event clicked;string ls_vesselrefno

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF
ls_vesselrefno = uo_vesselselect.dw_vessel.getitemstring(1,'vessel_ref_nr')
if isnull(ls_vesselrefno) or trim(ls_vesselrefno) = '' then
	return
end if

if upper(w_tramos_main.menuname) = "M_TCMAIN" then
	m_tcmain.m_menutop2.m_new.Event Clicked()
end if

end event

type cb_pay_test from mt_u_commandbutton within w_tc_contract
integer x = 37
integer y = 2372
integer width = 306
integer taborder = 100
string text = "&Payments"
end type

event clicked;if wf_datamodified() > 0 then 
	if MessageBox("Data not saved!", "TC Contract data has been modified, but not saved!~n~r~n~r" &
					 +"Would you like to update before switching?", Question!, YesNo!, 1) = 1 then
		IF inv_contract.of_update() <> 1 then 
			RETURN
		END IF //update()=1
		/* Refresh statement window if open, and same contract */
		if isValid(w_hire_statement) then
			if inv_contract.of_getcontractid( ) = w_hire_statement.wf_getContractID() then
				w_hire_statement.postevent("ue_refresh")
			end if
		end if
	end if //Messagebox
else
	if tab_tc.TRIGGER EVENT selectionchanging(tab_tc.selectedtab, tab_tc.selectedtab) = 1 then
		return
	end if
end if //wf_datamodified > 0

IF dw_contract_list.getselectedrow(0) > 0 THEN
	if isValid(w_tc_payments) then
		w_tc_payments.post event ue_alreadyOpen(dw_contract_list.getitemnumber(dw_contract_list.getselectedrow(0),"contract_id"))
	else
		OpenSheetWithParm(w_tc_payments, dw_contract_list.getitemnumber(dw_contract_list.getselectedrow(0),&
								"contract_id"), w_tramos_main, 7, Original!)
	end if							
ELSE
	MessageBox("Please select a contract!", "No contract has been selected", StopSign!)
END IF
end event

type tab_tc from tab within w_tc_contract
integer x = 41
integer y = 1328
integer width = 4530
integer height = 1040
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_periods tp_periods
tp_port_exp tp_port_exp
tp_non_port_exp tp_non_port_exp
tp_off_services tp_off_services
tabpage_uo_att tabpage_uo_att
end type

on tab_tc.create
this.tp_periods=create tp_periods
this.tp_port_exp=create tp_port_exp
this.tp_non_port_exp=create tp_non_port_exp
this.tp_off_services=create tp_off_services
this.tabpage_uo_att=create tabpage_uo_att
this.Control[]={this.tp_periods,&
this.tp_port_exp,&
this.tp_non_port_exp,&
this.tp_off_services,&
this.tabpage_uo_att}
end on

on tab_tc.destroy
destroy(this.tp_periods)
destroy(this.tp_port_exp)
destroy(this.tp_non_port_exp)
destroy(this.tp_off_services)
destroy(this.tabpage_uo_att)
end on

event selectionchanging;/*----------------------------------------------------------------
Checks whether data has been modified in the oldindex tab page.
Updates or ignores changes according to user respond.
----------------------------------------------------------------*/

n_tc_nonportexp 	lnv_npe

IF wf_tabdatamodified() = 0 THEN RETURN 0

IF MessageBox("Data not saved", "There are unsaved changes on the Expenses, Off-Hire or Attachments tabs.~r~n"+&
				"Do you want to save data and continue?", Question!, YesNo!, 1) = 1 THEN
	CHOOSE CASE oldindex
		CASE 1 //Periods tab page
			this.tp_periods.dw_periods.acceptText()
			IF inv_contract.of_update() = 1 THEN 
				wf_update_picklist()
				wf_updateMenu("contract")
				return 0
			ELSE //Update() <>1 (i.e. failed) - prevent tab page change
				return 1
			END IF
			RETURN
		CASE 2 //Port Expenses tab page
			THIS.tp_port_exp.dw_port_exp.acceptText()
			IF THIS.tp_port_exp.dw_port_exp.modifiedcount() > 0 THEN
				THIS.tp_port_exp.dw_port_exp.TriggerEvent("ue_update")
				IF THIS.tp_port_exp.dw_port_exp.modifiedcount() > 0 THEN
					return 1
				ELSE
					return 0
				END IF
			END IF//modifiedcount<>0
			RETURN
		CASE 3 //Non-Port Expenses tab page
			lnv_npe = CREATE n_tc_nonportexp
			IF lnv_npe.of_update(this.tp_non_port_exp.dw_non_port_exp, &
										inv_contract.of_getcontractid()) = 1 THEN
				DESTROY lnv_npe
				return 0
			ELSE //update failed - prevent tab page change
				DESTROY lnv_npe
				return 1
			END IF
		CASE 4 //Off Services tab page
			THIS.tp_off_services.dw_off_services.acceptText()
			IF THIS.tp_off_services.dw_off_services.modifiedcount() > 0 THEN
				IF THIS.tp_off_services.dw_off_services.UPDATE() = 1 THEN
					COMMIT;
					return 0
				ELSE //update failed - notify and prevent tab page change
					MessageBox("Update Error", "The database was not able to update.~r~n"+&
									"Please try again, or contact the System Administrator if the "+&
									"problem recurs.", StopSign!)
					ROLLBACK;
					return 1
				END IF //Update()=1
			END IF//modifiedcount<>0
			RETURN

		CASE 5 //Contract Attachments tab page
			
				if w_tc_contract.tab_tc.tabpage_uo_att.uo_tc_att.event ue_update() = c#return.Failure then 
					return 1
				end if

	END CHOOSE
ELSE /*User responds 'No' to update. Reset the datawindow of the tab page if tabpage changing*/
	IF newindex = oldindex then return
	CHOOSE CASE oldindex
		CASE 1 //Periods tab page
		CASE 2 //Port Expenses tab page
			tab_tc.tp_port_exp.dw_port_exp.reset()
			RETURN
		CASE 3 //Non-Port Expenses tab page
			tab_tc.tp_non_port_exp.dw_non_port_exp.reset()
			RETURN
		CASE 4 //Off Services tab page
			tab_tc.tp_off_services.dw_off_services.reset()
			RETURN

		case 5 //Contract Attachments tab page
			tab_tc.tabpage_uo_att.uo_tc_att.of_cancelchanges()
			RETURN
	END CHOOSE
END IF //Messagebox

end event

event selectionchanged;/*---------------------------------
Checks whether the tab page has data in its datawindow.

If not, data gets retrieved (happens the first time the tab is selected, and/or the first time
the tab is selected after datawindow.reset(), which happens if the user changes the tab and
responds 'No' to saving data).

If the datawindow does have data, simply return.
---------------------------------*/
long ll_contractid

ll_contractid = inv_contract.of_getcontractid()
/*Command buttons management (CBM)*/
IF newindex = 2 OR newindex = 4 THEN
	cb_new.enabled = FALSE
	cb_delete.enabled = FALSE
END IF

IF newindex = 1 OR newindex = 3 OR newindex = 5 THEN
	cb_new.enabled = TRUE
	cb_delete.enabled = TRUE
END IF
/*End of CBM*/

CHOOSE CASE newindex
	CASE 1 //Periods
		if oldindex <> newindex then
			this.tp_periods.dw_periods.setfocus()
		end if
	CASE 2 //Port Expenses
		if oldindex <> newindex then
			this.tp_port_exp.dw_port_exp.setfocus()
		end if
		IF THIS.tp_port_exp.dw_port_exp.rowcount() = 0 THEN 
			THIS.tp_port_exp.dw_port_exp.retrieve(ll_contractid)
			RETURN
		ELSE
			RETURN
		END IF
	CASE 3 //Non-Port Expenses
		if oldindex <> newindex then
			this.tp_non_port_exp.dw_non_port_exp.setfocus()
		end if
		IF THIS.tp_non_port_exp.dw_non_port_exp.rowcount() = 0 THEN
			THIS.tp_non_port_exp.dw_non_port_exp.retrieve(ll_contractid)
			RETURN
		ELSE
			RETURN
		END IF
	CASE 4 //Off Services
		if oldindex <> newindex then
			this.tp_off_services.dw_off_services.setfocus()
		end if
		IF THIS.tp_off_services.dw_off_services.rowcount() = 0 THEN
			THIS.tp_off_services.dw_off_services.retrieve(ll_contractid)
			RETURN
		ELSE
			RETURN
		END IF
	CASE 5 //Contract Attachments tab page
		if oldindex <> newindex then
			this.tabpage_uo_att.uo_tc_att.dw_file_listing.setfocus()
			idw_current.border = false
			idw_current = this.tabpage_uo_att.uo_tc_att.dw_file_listing
			idw_current.border = true
//			idw_current.dataobject = this.tabpage_uo_att.uo_tc_att.dw_file_listing.dataobject
			this.tabpage_uo_att.uo_tc_att.dw_file_listing.border = true
		end if
		if this.tabpage_uo_att.uo_tc_att.dw_file_listing.rowcount() = 0 then
			this.tabpage_uo_att.uo_tc_att.of_init()
		end if


END CHOOSE
end event

event getfocus;string ls_vesselrefno

ls_vesselrefno = uo_vesselselect.dw_vessel.getitemstring(1,'vessel_ref_nr')
if isnull(ls_vesselrefno) or trim(ls_vesselrefno) = '' then
	return
end if
if idw_current.object = dw_contract.object or idw_current.object = dw_brokercomm.object or idw_current.object = dw_contract_list.object or idw_current.object = dw_contract_expenses.object then
	choose case  selectedtab  
		case 5
			this.tabpage_uo_att.uo_tc_att.dw_file_listing.setfocus()
			idw_current.border = false
			idw_current = this.tabpage_uo_att.uo_tc_att.dw_file_listing
			idw_current.border = true
			this.tabpage_uo_att.uo_tc_att.dw_file_listing.border = true
		case 4
			this.tp_off_services.dw_off_services.post setfocus()
		case 3
			this.tp_non_port_exp.dw_non_port_exp.post setfocus()
		case 2
			this.tp_port_exp.dw_port_exp.post setfocus()
		case 1
			this.tp_periods.dw_periods.setfocus()
	end choose
end if
end event

type tp_periods from userobject within tab_tc
integer x = 18
integer y = 100
integer width = 4494
integer height = 924
long backcolor = 67108864
string text = "Periods"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_periods dw_periods
end type

on tp_periods.create
this.dw_periods=create dw_periods
this.Control[]={this.dw_periods}
end on

on tp_periods.destroy
destroy(this.dw_periods)
end on

type dw_periods from u_ntchire_grid_dw within tp_periods
event ue_fixture ( )
event ue_finish ( )
event ue_unfinish ( )
integer y = 12
integer width = 4480
integer height = 896
integer taborder = 30
string dataobject = "d_tc_periode"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_fixture();if wf_datamodified() = 1 then
	MessageBox("Information", "Please save Contract before fixture")
else
	inv_contract.of_fixture()
end if
end event

event ue_finish();inv_contract.of_finishPeriod(this.getRow())
end event

event ue_unfinish();// as called function just revert the finish indicator
inv_contract.of_finishPeriod(this.getRow()) 
end event

event ue_insertrow;
this.acceptText()
this.scrollToRow(inv_contract.of_newPeriod())
this. POST setFocus()

end event

event ue_update;call super::ue_update;

if wf_dataModified() = 0 then return

if inv_contract.of_update() = 1 then 
	wf_update_picklist()
	wf_updateMenu("contract")
	dw_contract_list.setRow(dw_contract_list.getSelectedRow(0))
end if

end event

event itemchanged;call super::itemchanged;datetime ldt_date

if row > 0 then
	choose case dwo.Name
		case "periode_end"
			ldt_date = datetime(data)
			if this.rowcount() >= row+1 then
				this.setItem(row+1, "periode_start", ldt_date)
			end if
		case "tcout_voyage_nr"
		
			if inv_contract.of_modifyvoyagenumber( row,data )= -1 then return 2	
	end choose
end if
end event

event ue_deleterow;call super::ue_deleterow;inv_contract.of_deletePeriod(this.getRow()) 

end event

event doubleclicked;call super::doubleclicked;s_tc_periode_income	lstr_parm

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "est_income", "est_expenses"
			CHOOSE CASE this.getItemStatus(row, 0, primary!)
				CASE dataModified!, notModified!
					lstr_parm.ll_periode_id = this.getItemNumber(row, "tc_periode_id")
					openwithparm(w_periode_est_income_expenses, lstr_parm)
					lstr_parm = message.PowerObjectParm
					if lstr_parm.ld_return = 1 then
						if not isnull(lstr_parm.ld_income) then
							
								this.setItem(row, "est_income", lstr_parm.ld_income)
								this.setitemstatus(row,"est_income",Primary!,NotModified!)
							
						end if
						if not isnull(lstr_parm.ld_expenses) then
							
								this.setItem(row, "est_expenses", lstr_parm.ld_expenses)
								this.setitemstatus(row,"est_expenses",Primary!,NotModified!)
							
						end if
					end if
				CASE ELSE
					MessageBox("Information", "You have to save TC Contract and Periods before entering estimates")
			END CHOOSE
	END CHOOSE
end if
end event

event ue_keydown;call super::ue_keydown;if key = KeySpaceBar! and &
	(this.getColumnName() = "est_income" OR this.getColumnName() = "est_expenses") then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.est_income)
end if
end event

event itemerror;call super::itemerror;if dwo.name = "tcout_voyage_nr" then
	return 1
end if
end event

type tp_port_exp from userobject within tab_tc
integer x = 18
integer y = 100
integer width = 4494
integer height = 924
long backcolor = 67108864
string text = "Port Expenses"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_2 st_2
st_1 st_1
rb_outstanding rb_outstanding
rb_settled rb_settled
rb_all rb_all
dw_port_exp dw_port_exp
gb_filter gb_filter
end type

on tp_port_exp.create
this.st_2=create st_2
this.st_1=create st_1
this.rb_outstanding=create rb_outstanding
this.rb_settled=create rb_settled
this.rb_all=create rb_all
this.dw_port_exp=create dw_port_exp
this.gb_filter=create gb_filter
this.Control[]={this.st_2,&
this.st_1,&
this.rb_outstanding,&
this.rb_settled,&
this.rb_all,&
this.dw_port_exp,&
this.gb_filter}
end on

on tp_port_exp.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_outstanding)
destroy(this.rb_settled)
destroy(this.rb_all)
destroy(this.dw_port_exp)
destroy(this.gb_filter)
end on

type st_2 from statictext within tp_port_exp
integer x = 928
integer y = 860
integer width = 1618
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "A Port Expense can be matched by double-clicking the entry on the list."
boolean focusrectangle = false
end type

type st_1 from statictext within tp_port_exp
integer x = 928
integer y = 800
integer width = 2350
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Entries in green are ~"matched~" Port Expenses and do not appear on period or final hire statements."
boolean focusrectangle = false
end type

type rb_outstanding from radiobutton within tp_port_exp
integer x = 489
integer y = 840
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outstanding"
end type

event clicked;dw_port_exp.setfilter("payment_status <= 2")
dw_port_exp.filter()
end event

type rb_settled from radiobutton within tp_port_exp
integer x = 215
integer y = 840
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Settled"
end type

event clicked;dw_port_exp.setfilter("payment_status > 2")
dw_port_exp.filter()
end event

type rb_all from radiobutton within tp_port_exp
integer x = 46
integer y = 840
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
boolean checked = true
end type

event clicked;dw_port_exp.setfilter("")
dw_port_exp.filter()
end event

type dw_port_exp from u_ntchire_grid_dw within tp_port_exp
integer y = 12
integer width = 4480
integer height = 768
integer taborder = 40
string dataobject = "d_tc_port_expenses"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;/*-----------------------------------------------------
Opens a window to match expenses with the same amount (and currency) for the same contract.
If the double-clicked entry is already matched, an error message appears.

Matched expenses will not be included on period and hyre statements, and will be shown
on the list with a different color
-------------------------------------------------------*/

integer  li_findrow, li_counter, li_payment_status_id
long     ll_match_exp_id, ll_current_paymentid, ll_match_paymentid, ll_temp_paymentid
boolean  lb_success = true
datetime ldt_due_date
string   ls_payment_status, ls_message, ls_sql

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

s_port_exp_match lstr_parms

if row > 0 then
	
	ll_match_exp_id        = dw_port_exp.getitemnumber(row, "match_port_exp_id")	
	ll_current_paymentid   = dw_port_exp.getitemnumber(row, "payment_id")
	li_payment_status_id   = dw_port_exp.getitemnumber(row, "payment_status")
	lstr_parms.contract_id = dw_port_exp.getitemnumber(row, "contract_id")	
	
	if isnull(ll_match_exp_id) and li_payment_status_id < 3 then
		
		/* the entry is not "final" settled (status<3) or is last payment 
			and does not have a matched Port Exp already*/
			
		lstr_parms.amount      = dw_port_exp.getitemnumber(row, "exp_amount")
		lstr_parms.curr_code   = dw_port_exp.getitemstring(row, "curr_code")		
		lstr_parms.port_exp_id = dw_port_exp.getitemnumber(row, "port_exp_id")
		
		openwithparm(w_tc_port_exp_match, lstr_parms)
		
		ll_match_exp_id = message.doubleparm
		
		tab_tc.trigger event selectionchanged(2, 2) //to get Windows Buttons settings
		
		if not IsNull(ll_match_exp_id) and ll_match_exp_id <> 0 then //a matched Port Exp has been returned
			
			li_findrow = dw_port_exp.find("port_exp_id = " + string(ll_match_exp_id), 0, dw_port_exp.rowcount())
			
			dw_port_exp.setitem(row, "match_port_exp_id", ll_match_exp_id)
			dw_port_exp.setitem(li_findrow, "match_port_exp_id", lstr_parms.port_exp_id)
			
			if dw_port_exp.update() = 1 then
				
				ll_match_paymentid = dw_port_exp.getitemnumber(li_findrow, "payment_id")
				
				if ll_match_paymentid <> ll_current_paymentid then
					
					ll_temp_paymentid = ll_current_paymentid
					li_counter        = 2
					
					//Update payment balance.
					do while li_counter > 0
					
						ls_sql = "sp_paymentBalance " + string(ll_temp_paymentid)
						
						EXECUTE IMMEDIATE :ls_sql;
						
						if sqlca.sqlcode <> 0 then
							lb_success = false
							exit
						end if
						
						li_counter --
						ll_temp_paymentid = ll_match_paymentid
					loop
				end if
				
				if lb_success then 
					commit;
					
					if ll_match_paymentid <> ll_current_paymentid then
						if isValid(w_tc_payments) then
							w_tc_payments.PostEvent("ue_refresh")
						end if
					end if
				else
					rollback;
					
					messagebox("Update error", "Update payment balance failed.")
					tab_tc.trigger event selectionchanged(2, 2) //to get Windows Buttons settings
				end if
			else
				ROLLBACK;
				
				MessageBox("Update error", "An error occured while updating the database.~r~n" + &
				"Please try again, or contact the System Administrator, if the problems recurs.")		
				
				tab_tc.trigger event selectionchanged(2, 2) //to get Windows Buttons settings		
			end if		
		end if
		
	elseif li_payment_status_id >= 3 and ISNULL(ll_match_exp_id) then
		
		SELECT EST_DUE_DATE INTO :ldt_due_date FROM NTC_PAYMENT WHERE PAYMENT_ID = :ll_current_paymentid;
		
		choose case li_payment_status_id
			case 3
				ls_payment_status = "Final"
			case 4
				ls_payment_status = "Part Paid"
			case 5
				ls_payment_status = "Paid"
		end choose 
		
		ls_message = "You cannot match the port expenses, because it is included in a hire statement in status " &
		             + ls_payment_status + ".~nHire statement ID: " + string(ll_current_paymentid) + " and due date: " &
		             + string(ldt_due_date, "dd-mm-yy") + ". ~n~nContact Operations to set the hire statement to Draft."
		
		MessageBox("Validation Error", ls_message)
		
		tab_tc.trigger event selectionchanged(2, 2) //to get Windows Buttons settings	
		return	
		
	else
		ls_message = "The Port Expense is already matched with another entry."
		MessageBox("Validation Error", ls_message)
		
		tab_tc.trigger event selectionchanged(2, 2) //to get Windows Buttons settings
		return
	end if
end if
end event

event ue_update();call super::ue_update;STRING 			ls_curr
INTEGER			li_contractid
LONG				ll_rows, ll_row, ll_update

THIS.ACCEPTTEXT()

IF THIS.modifiedcount() > 0 THEN
	ll_update = 1
	li_contractid = inv_contract.of_getcontractid()

	SELECT CURR_CODE
	INTO :ls_curr
	FROM NTC_TC_CONTRACT
	WHERE CONTRACT_ID = :li_contractid
	COMMIT;

	ll_rows = THIS.rowcount()

	FOR ll_row = 1 to ll_rows 
		IF THIS.getitemstatus(ll_row,0,Primary!) <> NotModified! THEN 
			IF THIS.getitemstring(ll_row,"curr_code") <> ls_curr AND THIS.getitemnumber(ll_row,"ex_rate_tc") = 100 THEN
				IF MessageBox("Warning","Row " + String(ll_row) + ": Contract Currency is " + ls_curr + " and Port Expense is : " + THIS.getitemstring(ll_row,"curr_code") + &
				" and you have entered 100 as ex. rate. Is this correct ?!", Question!,YesNo!,2) = 2 THEN
					ll_update = 0		
				END IF
			END IF
		END IF
	NEXT

	IF ll_update = 1 THEN
		IF THIS.UPDATE() = 1 THEN
			COMMIT;
		ELSE
			MessageBox("Update Error", "The database was not able to update.~r~n"+&
							"Please try again, or contact the System Administrator if the problem recurs.",&
							StopSign!)
			ROLLBACK;
		END IF
	END IF
END IF
end event

type gb_filter from groupbox within tp_port_exp
integer x = 14
integer y = 788
integer width = 869
integer height = 140
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter"
end type

type tp_non_port_exp from userobject within tab_tc
integer x = 18
integer y = 100
integer width = 4494
integer height = 924
long backcolor = 67108864
string text = "Non-Port Expenses"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
rb_npe_unsettled rb_npe_unsettled
rb_npe_settled rb_npe_settled
rb_all_settled rb_all_settled
rb_inc_exp rb_inc_exp
rb_income rb_income
rb_expense rb_expense
dw_non_port_exp dw_non_port_exp
gb_filter_npe gb_filter_npe
gb_filter_settled gb_filter_settled
end type

on tp_non_port_exp.create
this.rb_npe_unsettled=create rb_npe_unsettled
this.rb_npe_settled=create rb_npe_settled
this.rb_all_settled=create rb_all_settled
this.rb_inc_exp=create rb_inc_exp
this.rb_income=create rb_income
this.rb_expense=create rb_expense
this.dw_non_port_exp=create dw_non_port_exp
this.gb_filter_npe=create gb_filter_npe
this.gb_filter_settled=create gb_filter_settled
this.Control[]={this.rb_npe_unsettled,&
this.rb_npe_settled,&
this.rb_all_settled,&
this.rb_inc_exp,&
this.rb_income,&
this.rb_expense,&
this.dw_non_port_exp,&
this.gb_filter_npe,&
this.gb_filter_settled}
end on

on tp_non_port_exp.destroy
destroy(this.rb_npe_unsettled)
destroy(this.rb_npe_settled)
destroy(this.rb_all_settled)
destroy(this.rb_inc_exp)
destroy(this.rb_income)
destroy(this.rb_expense)
destroy(this.dw_non_port_exp)
destroy(this.gb_filter_npe)
destroy(this.gb_filter_settled)
end on

type rb_npe_unsettled from radiobutton within tp_non_port_exp
integer x = 1417
integer y = 840
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Outstanding"
end type

event clicked;wf_npe_filter()
end event

type rb_npe_settled from radiobutton within tp_non_port_exp
integer x = 1143
integer y = 840
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Settled"
end type

event clicked;wf_npe_filter()
end event

type rb_all_settled from radiobutton within tp_non_port_exp
integer x = 969
integer y = 840
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
boolean checked = true
end type

event clicked;wf_npe_filter()
end event

type rb_inc_exp from radiobutton within tp_non_port_exp
integer x = 46
integer y = 840
integer width = 174
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
boolean checked = true
end type

event clicked;wf_npe_filter()
end event

type rb_income from radiobutton within tp_non_port_exp
integer x = 512
integer y = 840
integer width = 288
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Income"
end type

event clicked;wf_npe_filter()
end event

type rb_expense from radiobutton within tp_non_port_exp
integer x = 219
integer y = 840
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Expense"
end type

event clicked;wf_npe_filter()
end event

type dw_non_port_exp from u_ntchire_grid_dw within tp_non_port_exp
integer y = 12
integer width = 4480
integer height = 752
integer taborder = 40
string dataobject = "d_tc_non_port_expenses"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_insertrow;call super::ue_insertrow;n_tc_nonportexp	lnv_npe

/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
if inv_contract.of_validate_paymentstatus( ) = c#return.failure then return

lnv_npe = CREATE n_tc_nonportexp

/*First check that the contract is fixtured*/
//IF IsNull(dw_contract.getitemdatetime(1,"fix_date")) THEN
//	MessageBox("Operation Not Allowed!", "The contract must be fixtured before a "+&
//					"Non Port Expense can be attached!", StopSign!)
//	RETURN
//ELSE
	IF lnv_npe.of_insertrow(this) = 1 THEN
		this.setItem(this.getRow( ), "tc_hire_in", inv_contract.of_getTCINorTCOUT())
		wf_updateMenu("newExpense")
		this.POST setFocus()
		this.POST setColumn("income")
		RETURN
	ELSE
		MessageBox("Insert Error!", "A problem occured when attempting to insert a row.~r~n~r~n"+&
						"Please try again, or contact the System Administrator, if the problem "+&
						"recurs.", StopSign!)
	END IF
//END IF
end event

event ue_deleterow;call super::ue_deleterow;n_tc_nonportexp	lnv_npe

/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
if this.getrow() > 0 then
	if inv_contract.of_validate_paymentstatus( ) = c#return.failure then return

	lnv_npe = CREATE n_tc_nonportexp
	
	lnv_npe.of_deleterow(this, this.getrow())
	
	DESTROY lnv_npe
end if



end event

event ue_update;call super::ue_update;n_tc_nonportexp 	lnv_tc_npe

/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
this.accepttext()
if this.modifiedcount() > 0 then
	if	inv_contract.of_validate_paymentstatus( ) = c#return.failure then return
end if

lnv_tc_npe = CREATE n_tc_nonportexp

IF lnv_tc_npe.of_update(this, inv_contract.of_getcontractid()) = 1 THEN
		/*updates the datawindow - uses the contract ID for attaching expenses to payment.
		Error messages are handled in in the function.*/
	wf_updateMenu("Contract") /*allows the user to select other datawindow and change tab page*/
END IF

DESTROY lnv_tc_npe
RETURN
	

end event

event ue_keydown;call super::ue_keydown;if key = KeySpaceBar! then 
	choose case this.getColumnName()
		case "curr_code" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.curr_code)
		case "type_desc" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.type_desc)
	end choose
end if
end event

event doubleclicked;call super::doubleclicked;STRING 	ls_curr_code, ls_type_desc
LONG		ll_exp_id, ll_final

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

IF row <= 0 THEN RETURN

IF (THIS.getitemnumber(row,"trans_to_coda") = 0 OR &
	IsNull(THIS.getitemnumber(row,"trans_to_coda"))) THEN //status not settled
	CHOOSE CASE dwo.name
		CASE "curr_code"
			ls_curr_code = f_select_from_list("dw_currency_list", 1, &
														"Code", 3, "Description", 1, &
														"Select currency...", false)
			IF NOT IsNull(ls_curr_code) THEN
				this.SetItem(row, "curr_code", ls_curr_code)
			END IF
		CASE "type_desc"
			ll_exp_id = LONG(f_select_from_list("d_non_port_expense_types", 2, &
															"Description", 3, "Final Hire", 1, &
															"Select Non-Port Expense Type...", false))
			IF NOT IsNull(ll_exp_id) THEN
				SELECT TYPE_DESC, FINAL_HIRE INTO :ls_type_desc, :ll_final
				FROM NTC_EXP_TYPE WHERE EXP_TYPE_ID = :ll_exp_id;
				THIS.SetItem(row, "type_desc", ls_type_desc)
				/* AutoHeight off/on workaround PB bug*/
				this.Object.type_desc.Height.AutoSize='No'
				THIS.SetItem(row, "exp_type_id", ll_exp_id)
				this.Object.type_desc.Height.AutoSize='Yes'
				THIS.SetItem(row, "final_hire", ll_final)
				this.scrollToRow(row)
				this.post setColumn("type_desc")
				this.post setFocus()
			END IF
	END CHOOSE
END IF
end event

event itemchanged;call super::itemchanged;long	ll_non_port_id
s_non_port_broker_comm 	lstr_parm
decimal {2}   ld_amount


if row < 1 then return

choose case dwo.name
	case "income"
		if data = "1" and this.getItemNumber(row, "tc_hire_in") = 1 then
			/* TC Hire IN and Income - not applicable - reset broker and address commission */
			this.setItem(row, "address_commission_pct", 0)
			this.setItem(row, "address_commission", 0)
			this.setItem(row, "set_off_broker_comm_pct", 0)
			this.setItem(row, "set_off_broker_comm", 0)
			this.setItem(row, "count_broker_comm", 0)			
			ll_non_port_id = this.getItemNumber(row, "non_port_id")
			DELETE FROM NTC_NON_PORT_EXP_BROKER_COMM WHERE NON_PORT_ID = :ll_non_port_id;
		end if
		if data = "0" and this.getItemNumber(row, "tc_hire_in") = 0 then
			/* TC Hire OUT and Expense - not applicable - reset broker and address commission */
			this.setItem(row, "address_commission_pct", 0)
			this.setItem(row, "address_commission", 0)
			this.setItem(row, "set_off_broker_comm_pct", 0)
			this.setItem(row, "set_off_broker_comm", 0)
			this.setItem(row, "count_broker_comm", 0)			
			ll_non_port_id = this.getItemNumber(row, "non_port_id")
			DELETE FROM NTC_NON_PORT_EXP_BROKER_COMM WHERE NON_PORT_ID = :ll_non_port_id;
		end if
	case "tc_hire_in"
		if data = "1" and this.getItemNumber(row, "income") = 1 then
			/* TC Hire IN and Income - not applicable - reset broker and address commission */
			this.setItem(row, "address_commission_pct", 0)
			this.setItem(row, "address_commission", 0)
			this.setItem(row, "set_off_broker_comm_pct", 0)
			this.setItem(row, "set_off_broker_comm", 0)
			this.setItem(row, "count_broker_comm", 0)			
			ll_non_port_id = this.getItemNumber(row, "non_port_id")
			DELETE FROM NTC_NON_PORT_EXP_BROKER_COMM WHERE NON_PORT_ID = :ll_non_port_id;
		end if
		if data = "0" and this.getItemNumber(row, "income") = 0 then
			/* TC Hire OUT and Expense - not applicable - reset broker and address commission */
			this.setItem(row, "address_commission_pct", 0)
			this.setItem(row, "address_commission", 0)
			this.setItem(row, "set_off_broker_comm_pct", 0)
			this.setItem(row, "set_off_broker_comm", 0)
			this.setItem(row, "count_broker_comm", 0)			
			ll_non_port_id = this.getItemNumber(row, "non_port_id")
			DELETE FROM NTC_NON_PORT_EXP_BROKER_COMM WHERE NON_PORT_ID = :ll_non_port_id;
		end if
	case "count_broker_comm"
		lstr_parm.non_port_id = this.getItemNumber(row, "non_port_id")
		lstr_parm.payment_id = this.getItemNumber(row, "payment_id")
		if this.getItemNumber(row, "trans_to_coda") = 1 then
			lstr_parm.trans_to_coda = true
		else
			lstr_parm.trans_to_coda = false
		end if
		openwithparm(w_non_port_broker_comm, lstr_parm)
		lstr_parm = message.powerobjectparm
		if isNull(lstr_parm.broker_pct) then
			this.setItem(row, "set_off_broker_comm_pct", 0)
			this.setItem(row, "set_off_broker_comm", 0)
			this.setItem(row, "count_broker_comm", 0)			
			this.POST setItem(row, "count_broker_comm", 0)
			this.POST acceptText()
		elseif lstr_parm.broker_pct= -1 then
			return 2
		else
			if lstr_parm.broker_pct <> this.getitemdecimal(row,'set_off_broker_comm_pct') then
				ld_amount = this.getItemDecimal(row, "amount")
				ld_amount = ld_amount *  lstr_parm.broker_pct / 100
				this.setItem(row, "set_off_broker_comm_pct",  lstr_parm.broker_pct)
				this.setItem(row, "set_off_broker_comm",  ld_amount)
				this.POST setItem(row, "count_broker_comm", 1)
				this.POST Accepttext()
			end if
		end if
end choose		
end event

type gb_filter_npe from groupbox within tp_non_port_exp
integer x = 14
integer y = 788
integer width = 818
integer height = 136
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter - Expense/Income"
end type

type gb_filter_settled from groupbox within tp_non_port_exp
integer x = 905
integer y = 788
integer width = 919
integer height = 140
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter - Settled Status"
end type

type tp_off_services from userobject within tab_tc
integer x = 18
integer y = 100
integer width = 4494
integer height = 924
long backcolor = 67108864
string text = "Off-Hire"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_off_services dw_off_services
end type

on tp_off_services.create
this.dw_off_services=create dw_off_services
this.Control[]={this.dw_off_services}
end on

on tp_off_services.destroy
destroy(this.dw_off_services)
end on

type dw_off_services from u_ntchire_dw within tp_off_services
integer x = 5
integer y = 12
integer width = 4480
integer height = 904
integer taborder = 40
string dataobject = "d_tc_off_service"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_update();call super::ue_update;THIS.ACCEPTTEXT()

IF THIS.modifiedcount() > 0 THEN
	IF THIS.UPDATE() = 1 THEN
		COMMIT;
		/* Recalc payment balances */
		n_tc_payment	lnv_payment
		lnv_payment = create n_tc_payment
		lnv_payment.of_recalcPaymentBalance(inv_contract.of_getcontractid())
		destroy lnv_payment
	ELSE
		MessageBox("Update Error", "The database was not able to update.~r~n"+&
						"Please try again, or contact the System Administrator if the problem recurs.",&
						StopSign!)
		ROLLBACK;
	END IF
END IF
end event

type tabpage_uo_att from userobject within tab_tc
integer x = 18
integer y = 100
integer width = 4494
integer height = 924
long backcolor = 67108864
string text = "Contract Attachments"
long picturemaskcolor = 536870912
uo_tc_att uo_tc_att
end type

on tabpage_uo_att.create
this.uo_tc_att=create uo_tc_att
this.Control[]={this.uo_tc_att}
end on

on tabpage_uo_att.destroy
destroy(this.uo_tc_att)
end on

type uo_tc_att from u_fileattach within tabpage_uo_att
event ue_delete ( )
event type long ue_update ( )
event ue_insertrow ( )
integer y = 8
integer width = 4498
integer height = 928
integer taborder = 40
string is_dataobjectname = "d_sq_ff_ntc_tc_action_files"
string is_counterlabel = "Rows:"
boolean ib_allow_dragdrop = true
integer ii_buttonmode = 0
boolean ib_enable_cancel_button = false
boolean ib_allownonattachrecs = true
boolean ib_multitableupdate = true
string is_modulename = "ntc_tc_action"
end type

event ue_delete();long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if uo_tc_att.enabled = false then return 

uo_tc_att.of_deleteimage( )
end event

event type long ue_update();n_service_manager 			lnv_svcmgr
n_dw_validation_service 	lnv_actionrules
long li_rc_attachment


if uo_global.ii_access_level = -1 then
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	return c#return.Failure
end if

//if uo_tc_att.enabled = false then c#return.Failure

uo_tc_att.dw_file_listing.accepttext( )

lnv_svcmgr.of_loadservice( lnv_actionrules, "n_dw_validation_service")
lnv_actionrules.of_registerrulestring("description", true, "description")
if lnv_actionrules.of_validate(uo_tc_att.dw_file_listing, true) = c#return.Failure then return c#return.Failure

li_rc_attachment = uo_tc_att.of_updateattach()
if li_rc_attachment < 0 then
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Contract Attachments Update failed~r~nRC=" + String(li_rc_attachment))
	return c#return.Failure
else
	commit;
	return c#return.Success
end if


end event

event ue_insertrow();long ll_row

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

// ll_row = dw_claim_action.InsertRow(0)

if dw_contract.getrow() = 0 then return 

if uo_tc_att.enabled = false then return 

ll_row = uo_tc_att.dw_file_listing.InsertRow(0)

IF ll_row > 0 THEN
	uo_tc_att.dw_file_listing.SetItem(ll_row,"contract_id", dw_contract.getitemnumber(dw_contract.getrow(),'contract_id'))

	uo_tc_att.dw_file_listing.SelectRow(0,FALSE)
	uo_tc_att.dw_file_listing.SelectRow(ll_row,true)
	uo_tc_att.dw_file_listing.SetRow(ll_row)
	uo_tc_att.dw_file_listing.ScrollToRow(ll_row)
   uo_tc_att.dw_file_listing.SetItem(ll_row,"action_date",today())
	uo_tc_att.dw_file_listing.SetItem(ll_row,'assigned_to',uo_global.gos_userid)
	uo_tc_att.dw_file_listing.SetColumn("action_date")
	uo_tc_att.dw_file_listing.SetFocus()
	
END IF
end event

on uo_tc_att.destroy
call u_fileattach::destroy
end on

event ue_retrievefilelist;// Overrided
long ll_contract_id
long li_row

li_row = dw_contract.getrow()
if li_row > 0 then
	ll_contract_id = dw_contract.GetItemNumber(li_row, "contract_id")
	return adw_file_listing.Retrieve(ll_contract_id)
end if

return c#return.Failure

end event

event ue_preupdateattach;call super::ue_preupdateattach;long ll_contract_id
long li_row,ll_count
int i


li_row = dw_contract.getrow()
if li_row > 0 then
	ll_contract_id = dw_contract.GetItemNumber(li_row, "contract_id")
	ll_count = uo_tc_att.dw_file_listing.rowcount()
	if ll_count > 0 then
		for i = 1 to ll_count
		  
			if uo_tc_att.dw_file_listing.GetItemStatus(i,0,PRIMARY!) = NewModified! then
			//			     
			 	uo_tc_att.dw_file_listing.setitem(i,'contract_id',ll_contract_id)
			//					 
			
			end if
		next
	end if
end if
return 1
end event

event ue_childclicked;call super::ue_childclicked;
if idw_current <> dw_file_listing then
	idw_current.border = false
	idw_current = dw_file_listing
	idw_current.border = true
end if


end event

event ue_dropmails;call super::ue_dropmails;long ll_row
wf_updateMenu("newattach")
ll_row = uo_tc_att.dw_file_listing.getrow()
if ll_row<>0 then
	if isnull(uo_tc_att.dw_file_listing.getitemnumber(ll_row,"file_id")) then
		uo_tc_att.dw_file_listing.SetItem(ll_row,"action_date", today())
	end if
	uo_tc_att.dw_file_listing.setitem(ll_row,'assigned_to',uo_global.gos_userid)
	dw_file_listing.SetColumn("description")
	dw_file_listing.setfocus( )
end if
end event

event ue_dropfiles;call super::ue_dropfiles;long ll_row, ll_rows
wf_updateMenu("newattach")
ll_row = uo_tc_att.dw_file_listing.getrow()
ll_rows = dw_file_listing.rowcount()
if ll_rows > 0 then
	for ll_row = ll_rows to 1 step -1
		if isnull(uo_tc_att.dw_file_listing.getitemdatetime(ll_row,"action_date")) then	
			uo_tc_att.dw_file_listing.SetItem(ll_row,"action_date", today())
		end if
		if isnull(uo_tc_att.dw_file_listing.getitemstring(ll_row,'assigned_to')) then
			uo_tc_att.dw_file_listing.setitem(ll_row,'assigned_to',uo_global.gos_userid)
		end if
		dw_file_listing.SetColumn("action_date")
	next
	dw_file_listing.setfocus( )
end if



end event

event constructor;IF uo_global.ii_access_level = -1 THEN 
   ib_allow_dragdrop = false
else
	ib_allow_dragdrop = true
end if
super::event constructor( )
end event

type dw_contract_expenses from u_ntchire_grid_dw within w_tc_contract
integer x = 3072
integer y = 1040
integer width = 1499
integer height = 272
integer taborder = 80
string dataobject = "d_tc_contract_expenses"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;STRING ls_rc
LONG	ll_rc
STRING ls_desc

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "type_desc"
			ls_rc = f_select_from_list("d_contract_expense_types", 2, "Description", 2, "Description", 1, "Select Expense Type", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT TYPE_DESC INTO :ls_desc
				FROM NTC_EXP_TYPE WHERE EXP_TYPE_ID = :ll_rc;
				this.SetItem(row, "type_desc", ls_desc)
				this.SetItem(row, "exp_type_id", ll_rc)
			END IF
	END CHOOSE
end if
end event

event ue_keydown;call super::ue_keydown;if key = KeySpaceBar! and this.getColumnName() = "type_desc" then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.type_desc)
end if
end event

event ue_update;call super::ue_update;this.acceptText()

if wf_dataModified() = 0 then return

if inv_contract.of_update() = 1 then 
	wf_update_picklist()
	wf_updateMenu("contract")
	dw_contract_list.setRow(dw_contract_list.getSelectedRow(0))
end if

end event

event ue_insertrow();call super::ue_insertrow;this.acceptText()
this.scrollToRow(inv_contract.of_newExpense())
this.POST setFocus()
this.POST setColumn("type_desc")
end event

event ue_deleterow;call super::ue_deleterow;/*M5-12 Added by LHC010 on 07-05-2012. Change desc: Check payment status exists New or Draft*/
if inv_contract.of_validate_paymentstatus( ) = c#return.failure then return

this.deleteRow(0)
end event

type dw_brokercomm from u_ntchire_grid_dw within w_tc_contract
integer x = 1394
integer y = 1040
integer width = 1646
integer height = 272
integer taborder = 70
string dataobject = "d_tc_brokercomm"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_keydown;call super::ue_keydown;if key = KeySpaceBar! and this.getColumnName() = "broker_name" then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.broker_name)
end if
end event

event doubleclicked;call super::doubleclicked;STRING rc
LONG	rc_long
STRING fullname

If uo_global.ii_access_level = -1 Then
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
End If

If row > 0 then
	CHOOSE CASE dwo.name
		CASE "broker_name"
			rc = f_select_from_list("dw_active_broker_list", 2, "Short Name", 3, "Long Name", 1, "Select broker", false)
			If Not IsNull(rc) Then
				rc_long = Long(rc)
				SELECT BROKER_NAME INTO :fullname
				FROM BROKERS WHERE BROKER_NR = :rc_long;
				
				// Check if broker is already in list
				If This.Find("broker_nr = " + String(rc_long), 0, This.RowCount()) > 0 then
					Messagebox("Broker Already Selected", "The selected broker is already present in the list!~n~nPlease select another broker.")
				Else // Otherwise set broker
					This.SetItem(row, "broker_name", fullname)
					This.SetItem(row, "broker_nr", rc_long)
				End If
			End If
	End Choose
End if
end event

event ue_update;call super::ue_update;this.acceptText()

if wf_dataModified() = 0 then return

if inv_contract.of_update() = 1 then 
	wf_update_picklist()
	wf_updateMenu("contract")
	dw_contract_list.setRow(dw_contract_list.getSelectedRow(0))
end if

end event

event ue_insertrow();call super::ue_insertrow;this.acceptText()
this.scrollToRow(inv_contract.of_newBroker())
this.POST setFocus()
this.POST setColumn("broker_name")
end event

event ue_deleterow();call super::ue_deleterow;inv_contract.of_deleteBroker(this.getRow())

end event

type dw_contract_list from u_ntchire_grid_dw within w_tc_contract
event ue_finish ( )
event ue_fixture ( )
event ue_unfinish ( )
event ue_fixturenote ( )
integer x = 41
integer y = 252
integer width = 1326
integer height = 1060
integer taborder = 40
string dataobject = "d_tc_contract_list"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_finish();inv_contract.of_finishTC()
end event

event ue_fixture();if wf_datamodified() = 1 then
	MessageBox("Information", "Please save Contract before fixture")
else
	inv_contract.of_fixture()
end if
end event

event ue_unfinish();inv_contract.of_unfinishTC()
end event

event ue_fixturenote();if not isnull(dw_contract.getItemString(1, "fixture_user_id")) then inv_contract.of_show_fixturenote()
end event

event ue_insertrow;long ll_row

IF upper(is_menuState) = "NEW" THEN RETURN

IF wf_datamodified() > 0 THEN 
	IF MessageBox("Data not saved!", "TC Contract data has been modified, but not saved!~n~r~n~r" &
					 +"Would you like to update before switching?", Question!, YesNo!, 1) = 1 then
		IF inv_contract.of_update() <> 1 THEN RETURN 
	END IF
END IF

IF inv_contract.of_newContract() = -1 THEN RETURN

ll_row = dw_contract_list.insertRow(0)
dw_contract_list.scrollToRow(ll_row)
dw_contract_list.selectRow(0, false)
dw_contract_list.selectRow(ll_row, true)
wf_updateMenu("new")
tab_tc.selecttab(1)
dw_contract.post setfocus()

end event

event ue_update;call super::ue_update;if wf_dataModified() = 0 then return

if inv_contract.of_update() = 1 then 
	wf_update_picklist()
	wf_updateMenu("contract")
	this.setRow(this.getSelectedRow(0))
end if
end event

event clicked;call super::clicked;long ll_contract_id

dw_contract.setredraw(false)
if row > 0 then
	if wf_datamodified() > 0 then
		if MessageBox("Data not saved", "There are unsaved changes in the contract or on the Periods tab.~n~r~n~r" &
						 +"Do you want to save the data and continue?", Question!, YesNo!, 1) = 1 then
			IF inv_contract.of_update() = 1 then 
				wf_update_picklist()
				wf_updateMenu("contract")
			ELSE //update failed
				dw_contract.setredraw(true)
				RETURN
			END IF //update()=1
		end if //Messagebox
	end if //wf_datamodified > 0
	//tab_tc.selecttab(1)
	if tab_tc.TRIGGER EVENT selectionchanging(tab_tc.selectedtab, tab_tc.selectedtab) = 1 then
		dw_contract.setredraw(true)
		return
	end if
	tab_tc.tp_port_exp.dw_port_exp.reset()
	tab_tc.tp_non_port_exp.dw_non_port_exp.reset()
	tab_tc.tp_off_services.dw_off_services.reset()
	tab_tc.POST EVENT selectionchanged(tab_tc.selectedtab, tab_tc.selectedtab)
	this.selectRow(0, false)
	this.selectRow(row, true)
	ll_contract_id = this.getItemNumber(row, "contract_id")
	parent.title = "TC Hire Contract (ID="+string(ll_contract_id)+")"
	inv_contract.of_setContractID(ll_contract_id)
	inv_contract.of_retrieve()
	if dw_contract.rowcount() > 0 then
		if isnull(dw_contract.getitemnumber(1,"pc_nr") ) then
			is_vesselpc_statementtext = dw_contract.getitemstring( 1, "statement_logo_text")
		else
			is_vesselpc_statementtext = ""
		end if
	end if
	
	tab_tc.tabpage_uo_att.uo_tc_att.of_cancelchanges()
	tab_tc.tabpage_uo_att.uo_tc_att.of_init()

	wf_updatemenu("contract")
	dw_contract.post setfocus()
end if
dw_contract.setredraw(true)
end event

event ue_deleterow;call super::ue_deleterow;

if inv_contract.of_deleteContract() = 1 then
	dw_contract_list.deleterow(dw_contract_list.getSelectedRow(0))

end if
end event

event ue_retrieve_vessel;call super::ue_retrieve_vessel;if wf_datamodified() > 0 then 
	if MessageBox("Data not saved!", "TC Contract data has been modified, but not saved!~n~r~n~r" &
					 +"Would you like to update before switching?", Question!, YesNo!, 1) = 1 then
		IF inv_contract.of_update() <> 1 then 
			uo_vesselselect.of_setPreviousVessel( )
			RETURN
		END IF //update()=1
	end if //Messagebox
end if
	
	inv_contract.of_setVesselNr(ai_vessel)
	wf_updatemenu("vessel")
	inv_contract.of_resetAll()
	/* If user is some kind of external no access to TC-in contracts */
	if uo_global.ii_access_level < 1 then
		dw_contract_list.setFilter("tc_hire_in=0")
	else
		dw_contract_list.setFilter("")
	end if
	dw_contract_list.filter()
	dw_contract_list.retrieve(ai_vessel)
	dw_contract_list.setfocus()
	tab_tc.selecttab(1)
end event

type dw_contract from u_ntchire_dw within w_tc_contract
event ue_fixture ( )
event ue_finish ( )
event ue_unfinish ( )
event ue_fixturenote ( )
event ue_rbuttondown pbm_dwnrbuttondown
event ue_mousemove pbm_dwnmousemove
integer x = 1394
integer y = 252
integer width = 3177
integer height = 784
integer taborder = 60
string dataobject = "d_tc_contract"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_fixture();if wf_datamodified() = 1 then
	MessageBox("Information", "Please save Contract before fixture")
else
	inv_contract.of_fixture()
end if
end event

event ue_finish();inv_contract.of_finishTC()
end event

event ue_unfinish();inv_contract.of_unfinishTC()
end event

event ue_fixturenote();if not isnull(dw_contract.getItemString(1, "fixture_user_id")) then inv_contract.of_show_fixturenote()
end event

event ue_rbuttondown;//CR2485 Added by LHC010 on 01-08-2011.
if dwo.name = "p_bank_detail" then
	
	dw_bankdetail.retrieve( this.getitemnumber(row,"bank_account_id"),uo_global.getvessel_nr() )
	
	if (this.x + pointerx() + dw_bankdetail.width) > parent.width then
		dw_bankdetail.x = parent.width - dw_bankdetail.width - 120
	else
		dw_bankdetail.x = parent.pointerx()
	end if
	
	if (pointery() + dw_bankdetail.height > this.y + this.height) then
		dw_bankdetail.y =  this.y + this.height - dw_bankdetail.height - 20
	else
		dw_bankdetail.y = parent.pointery()
	end if
	
	dw_bankdetail.visible = true
	dw_bankdetail.setfocus( )
end if

end event

event ue_mousemove;/********************************************************************
   w_tc_contract
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	02-08-2011 2485         LHC010        		user has possibility to show bank detail with a popup dw 
																when mousepointer goes outside range, hide the datawindow.
   </HISTORY>
********************************************************************/

if dw_bankdetail.visible and dw_bankdetail.ib_autoclose then
	if (xpos < dw_bankdetail.x - this.x) or (ypos < dw_bankdetail.y - this.y) then
		this.setfocus()
		dw_bankdetail.visible = false
	end if
end if

end event

event ue_insertrow;long ll_row

if upper(is_menuState) = "NEW" then return

IF wf_datamodified() > 0 THEN 
	IF MessageBox("Data not saved!", "TC Contract data has been modified, but not saved!~n~r~n~r" &
					 +"Would you like to update before switching?", Question!, YesNo!, 1) = 1 then
		IF inv_contract.of_update() <> 1 THEN RETURN 
	END IF
END IF

if inv_contract.of_newContract() = -1 then return
ll_row = dw_contract_list.insertRow(0)
dw_contract_list.scrollToRow(ll_row)
dw_contract_list.selectRow(0, false)
dw_contract_list.selectRow(ll_row, true)
tab_tc.tabpage_uo_att.uo_tc_att.dw_file_listing.reset()
wf_updateMenu("new")
tab_tc.selecttab(1)
dw_contract.post setfocus()
end event

event ue_keydown;call super::ue_keydown;long ll_null
string ls_null

if key = KeySpaceBar! then 
	choose case this.getColumnName()
		case "curr_code" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.curr_code)
		case "chart_n_1" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.chart_n_1)
		case "tcowner_n_1" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.tcowner_n_1)
		case "tcowners2_tcowner_n_1" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.tcowners2_tcowner_n_1)
		case "office_name" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.office_name)
		case "share_member" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.share_member)
	end choose
end if

if key = KeyDelete! then
	setNull(ll_null)
	setNull(ls_null)
	choose case this.getColumnName()
		case "chart_n_1" 
			this.setItem(this.getRow(), "chart_n_1", ls_null)
			this.setItem(this.getRow(), "chart_nr", ll_null)
		case "tcowners2_tcowner_n_1" 
			this.setItem(this.getRow(), "tcowners2_tcowner_n_1", ls_null)
			this.setItem(this.getRow(), "contract_tcowner_nr", ll_null)
		case "office_name" 
			this.setItem(this.getRow(), "office_name", ls_null)
			this.setItem(this.getRow(), "office_nr", ll_null)
	end choose
end if
	
end event

event doubleclicked;call super::doubleclicked;STRING 	ls_rc
LONG		ll_rc, ll_vessel_nr, ll_vessel_owner
STRING 	ls_fullname, ls_account
integer	li_share_members, li_share_members_org

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "curr_code"
			if this.getItemNumber(row, "payment_status") > 2 then return
			ls_rc = f_select_from_list("dw_currency_list", 1, "Code", 2, "Description", 1, "Select currency...", false)
			IF NOT IsNull(ls_rc) THEN
				this.SetItem(row, "curr_code", ls_rc)
			END IF
		CASE "chart_n_1"
			if this.getItemNumber(row, "tc_hire_in") = 1 then return
			if not isNull(this.getItemString(row, "fixture_user_id")) then return
			ls_rc = f_select_from_list("dw_active_charterer_list", 2, "Short Name", 3, "Long Name", 1, "Select charterer...", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT CHART_N_1, NOM_ACC_NR INTO :ls_fullname, :ls_account
					FROM CHART WHERE CHART_NR = :ll_rc;
				this.SetItem(row, "chart_n_1", ls_fullname)
				this.SetItem(row, "chart_nr", ll_rc)
				this.setItem(row, "chart_nom_acc_nr", ls_account)
			END IF
		CASE "tcowner_n_1"
			IF (uo_global.ii_access_level = 3) &
			OR (uo_global.ii_access_level = 2 and uo_global.ii_user_profile = 3 ) THEN 
				//only admin and Finance Profile Superuser can change this
				ls_rc = f_select_from_list("dw_active_tcowner_list", 2, "Short Name", 3, "Long Name", 1, "Select Headowner...", false)
				IF NOT IsNull(ls_rc) THEN
					ll_rc = Long(ls_rc)
					ll_vessel_nr = this.getItemNumber(row, "vessel_nr")
					SELECT TCOWNER_NR INTO :ll_vessel_owner
						FROM VESSELS WHERE VESSEL_NR = :ll_vessel_nr;
					if ll_rc <> ll_vessel_owner then MessageBox("Information", "TC Owner registred for vessel is different from selected Owner")
					SELECT TCOWNER_N_1, NOM_ACC_NR INTO :ls_fullname, :ls_account
						FROM TCOWNERS WHERE TCOWNER_NR = :ll_rc;
					this.SetItem(row, "tcowner_n_1", ls_fullname)
					this.SetItem(row, "tcowner_nr", ll_rc)
					this.setItem(row, "tcowners_nom_acc_nr", ls_account)
				END IF
			END IF
		CASE "tcowners2_tcowner_n_1"
			if this.getItemNumber(row, "tc_hire_in") = 1 then return
			if not isNull(this.getItemString(row, "fixture_user_id")) then return
			ls_rc = f_select_from_list("dw_active_tcowner_list", 2, "Short Name", 3, "Long Name", 1, "Select TC Owner...", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT TCOWNER_N_1, NOM_ACC_NR INTO :ls_fullname, :ls_account
					FROM TCOWNERS WHERE TCOWNER_NR = :ll_rc;
				this.SetItem(row, "tcowners2_tcowner_n_1", ls_fullname)
				this.SetItem(row, "contract_tcowner_nr", ll_rc)
				this.setItem(row, "tcowners2_nom_acc_nr_1", ls_account)
			END IF
		CASE "office_name"
			ls_rc = f_select_from_list("dw_office_active_list", 2, "Short Name", 3, "Long Name", 1, "Select office...", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT OFFICE_NAME INTO :ls_fullname
					FROM OFFICES WHERE OFFICE_NR = :ll_rc;
				this.SetItem(row, "office_name", ls_fullname)
				this.SetItem(row, "office_nr", ll_rc)
			END IF
		CASE "share_member"
			li_share_members = inv_contract.of_shareMembers()
			if not isnull(li_share_members) then
				this.setItem(row, "share_member", li_share_members)
				this.setitemstatus(row,"share_member",Primary!,NotModified!)
			end if
	END CHOOSE
end if
end event

event ue_update;call super::ue_update;this.acceptText()

if wf_dataModified() = 0 then return

if inv_contract.of_update() = 1 then 
	wf_update_picklist()
	wf_UpdateMenu("contract")
	dw_contract_list.setRow(dw_contract_list.getSelectedRow(0))
end if
end event

event itemchanged;call super::itemchanged;long 		ll_null, ll_getrow, ll_vesselnr
string 	ls_null, ls_statementlogotext
integer	li_statementlogo, li_pcnr
datawindowchild ldwc_pcnr

if row > 0 then
	choose case dwo.Name
		case "tc_hire_in"
			setNull(ll_null); setNull(ls_null)
			if integer(data) = 1 then /* TC Hire IN */
				this.setitem(row, "chart_n_1", ls_null)
				this.setitem(row, "chart_nr", ll_null)
				this.setitem(row, "contract_tcowner_nr", ll_null)
				this.setitem(row, "tcowners2_tcowner_n_1", ll_null)
				this.setitem(row, "opsa_setup", 0)
			end if
			
			if data = "1" then
				if this.getItemNumber(row, "bareboat") = 1 then
					inv_contract.of_bareboatmanagement( )
				end if
				
			end if
		CASE "bareboat"
			if data = "1" then
				if this.getItemNumber(row, "tc_hire_in") = 1 then
					inv_contract.of_bareboatmanagement( )
				end if
			end if
		
		case "delivery"
			this.acceptText()
			tab_tc.tp_periods.dw_periods.setItem(1, "periode_start", this.getItemDatetime(row, "delivery"))
		case "payment_type"
			if integer(data) = 1 or integer(data) = 3 then
				this.setitem(row, "monthly_rate", 0)
			end if
			if integer(data) = 3 then
				this.setitem(row, "payment", 0)
			end if
		case "pcnrlogo"
			this.getchild("pcnrlogo",ldwc_pcnr)
			ll_getrow = ldwc_pcnr.getrow( )
			li_pcnr = ldwc_pcnr.getitemnumber(ll_getrow,"pc_nr")
			li_statementlogo = ldwc_pcnr.getitemnumber(ll_getrow,"statement_logo")
			this.setitem( row, "pc_nr", li_pcnr)
			this.setitem( row, "statement_logo", li_statementlogo)
			if li_statementlogo = 1 or li_statementlogo = 3 then
				ls_statementlogotext = ldwc_pcnr.getitemstring(ll_getrow,"statement_logo_text")
			end if
			if isnull(li_pcnr) then ls_statementlogotext = is_vesselpc_statementtext
			this.setitem( row, "statement_logo_text", ls_statementlogotext)
		case "statement_logo_text"
			is_vesselpc_statementtext = data
	end choose
end if
end event

event ue_deleterow;call super::ue_deleterow;

if inv_contract.of_deleteContract() = 1 then
	dw_contract_list.deleterow(dw_contract_list.getSelectedRow(0))
end if
end event

event constructor;call super::constructor;datawindowchild ldwc_bankaccount
integer	li_null, li_insertrow 

//CR2485 Added by LHC010 on 29-07-2011. Change desc: add Default
setnull( li_null )

dw_contract.getchild( "bank_account_id", ldwc_bankaccount )
ldwc_bankaccount.settransobject( sqlca )
ldwc_bankaccount.retrieve( )
ldwc_bankaccount.insertrow(1)
ldwc_bankaccount.setitem( 1, "bank_account_id", li_null)
ldwc_bankaccount.setitem( 1, "bank_account_desc", "Default" )

end event

type st_3 from u_topbar_background within w_tc_contract
integer x = 5
integer width = 4626
integer height = 232
end type

type dw_bankdetail from u_popupdw within w_tc_contract
integer x = 37
integer y = 1408
integer width = 1367
integer height = 508
integer taborder = 50
string dataobject = "d_sq_ff_bankdetail"
boolean vscrollbar = false
integer ii_maxheight = 492
end type

event constructor;call super::constructor;this.settransobject( sqlca )
this.of_registerdw(dw_contract)
end event

