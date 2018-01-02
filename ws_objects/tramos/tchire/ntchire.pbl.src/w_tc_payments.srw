$PBExportHeader$w_tc_payments.srw
$PBExportComments$Shows Payments for a specified Vessel or Profit Center
forward
global type w_tc_payments from w_vessel_basewindow
end type
type st_3 from statictext within w_tc_payments
end type
type st_duedate from statictext within w_tc_payments
end type
type cbx_date_filter from checkbox within w_tc_payments
end type
type st_zero from statictext within w_tc_payments
end type
type cbx_hide_zero_rate from checkbox within w_tc_payments
end type
type cbx_paid from checkbox within w_tc_payments
end type
type cbx_partpaid from checkbox within w_tc_payments
end type
type cbx_final from checkbox within w_tc_payments
end type
type cbx_draft from checkbox within w_tc_payments
end type
type cbx_new from checkbox within w_tc_payments
end type
type cb_refresh from commandbutton within w_tc_payments
end type
type cb_saveas from commandbutton within w_tc_payments
end type
type cb_open from commandbutton within w_tc_payments
end type
type rb_receive from radiobutton within w_tc_payments
end type
type rb_hire from radiobutton within w_tc_payments
end type
type rb_all from radiobutton within w_tc_payments
end type
type cb_modify from commandbutton within w_tc_payments
end type
type dw_payments from u_datagrid within w_tc_payments
end type
type gb_filter_type from groupbox within w_tc_payments
end type
type gb_filter_status from groupbox within w_tc_payments
end type
type rb_history from radiobutton within w_tc_payments
end type
type rb_no_history from radiobutton within w_tc_payments
end type
type dw_finresp from datawindow within w_tc_payments
end type
type cb_unsettle from commandbutton within w_tc_payments
end type
type cb_settle from commandbutton within w_tc_payments
end type
type cb_setdraft from commandbutton within w_tc_payments
end type
type cb_lumpsum from commandbutton within w_tc_payments
end type
type cb_print from commandbutton within w_tc_payments
end type
type dw_profit_center from datawindow within w_tc_payments
end type
type dw_vessel_list from datawindow within w_tc_payments
end type
type gb_hs_setting from groupbox within w_tc_payments
end type
type gb_finresp from groupbox within w_tc_payments
end type
type gb_pc from groupbox within w_tc_payments
end type
type gb_vessel from groupbox within w_tc_payments
end type
type gb_hide_payments from groupbox within w_tc_payments
end type
type st_topbar_background from u_topbar_background within w_tc_payments
end type
type em_days from editmask within w_tc_payments
end type
type cb_translog from commandbutton within w_tc_payments
end type
type cb_setfinal from commandbutton within w_tc_payments
end type
type cbx_select_pc from checkbox within w_tc_payments
end type
type cbx_select_vessel from checkbox within w_tc_payments
end type
type cbx_select_fr from checkbox within w_tc_payments
end type
type cb_unlock from commandbutton within w_tc_payments
end type
end forward

global type w_tc_payments from w_vessel_basewindow
integer width = 4599
integer height = 2568
string title = "Payments"
boolean maxbox = false
boolean resizable = false
long backcolor = 67108864
string icon = "images\payments.ico"
boolean ib_setdefaultbackgroundcolor = true
event ue_alreadyopen ( long al_contractid )
st_3 st_3
st_duedate st_duedate
cbx_date_filter cbx_date_filter
st_zero st_zero
cbx_hide_zero_rate cbx_hide_zero_rate
cbx_paid cbx_paid
cbx_partpaid cbx_partpaid
cbx_final cbx_final
cbx_draft cbx_draft
cbx_new cbx_new
cb_refresh cb_refresh
cb_saveas cb_saveas
cb_open cb_open
rb_receive rb_receive
rb_hire rb_hire
rb_all rb_all
cb_modify cb_modify
dw_payments dw_payments
gb_filter_type gb_filter_type
gb_filter_status gb_filter_status
rb_history rb_history
rb_no_history rb_no_history
dw_finresp dw_finresp
cb_unsettle cb_unsettle
cb_settle cb_settle
cb_setdraft cb_setdraft
cb_lumpsum cb_lumpsum
cb_print cb_print
dw_profit_center dw_profit_center
dw_vessel_list dw_vessel_list
gb_hs_setting gb_hs_setting
gb_finresp gb_finresp
gb_pc gb_pc
gb_vessel gb_vessel
gb_hide_payments gb_hide_payments
st_topbar_background st_topbar_background
em_days em_days
cb_translog cb_translog
cb_setfinal cb_setfinal
cbx_select_pc cbx_select_pc
cbx_select_vessel cbx_select_vessel
cbx_select_fr cbx_select_fr
cb_unlock cb_unlock
end type
global w_tc_payments w_tc_payments

type variables
LONG	il_contract_ID

/* Used for search functionality on the Vessel tab page*/
integer ii_search_column
boolean ib_search_column_string

/* Variables for vessel dropdown */
//boolean ib_vessel_no_trig = FALSE
//boolean ib_vessel_name_trig = FALSE
//int ii_vessel_nr

/* retrieval argument for payments */
integer	ii_payment_status[5]
integer	ii_pcnr[]
integer	ii_vesselno[]
integer	ii_empty[]
string	is_finance_userid[], is_empty[]

integer ii_SETDRAFT = 1 // set draft
integer ii_UNSETTLE = 2 // unsettle 

n_dw_style_service   lnv_style
n_service_manager inv_servicemgr


end variables

forward prototypes
public function integer wf_statusfilter ()
public function integer wf_filtertypeandrate ()
private subroutine wf_checkstatementopen ()
public subroutine documentation ()
public subroutine wf_select_row (datawindow adw_filter, string as_column)
public subroutine wf_openinvoicetext (long al_row)
end prototypes

event ue_alreadyopen(long al_contractid);n_dw_style_service   lnv_style

il_contract_id = al_contractID

dw_payments.dataObject = "d_payments_contract"
dw_payments.settransobject(SQLCA)
inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_payments, false)

if dw_payments.retrieve(il_contract_ID, ii_payment_status) > 0 then
	dw_vessel_list.selectrow (0, false)
	dw_profit_center.selectrow (0, false)
	dw_payments.post setFocus()
	this.setFocus()
end if

return
end event

public function integer wf_statusfilter ();/********************************************************************
   wf_statusfilter
   <DESC>	This function filters the payment window according to user selection of status to show	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		06/05/15 CR3926        SSX014   The highlightened must be set to current
   </HISTORY>
********************************************************************/

if cbx_new.checked then 
	ii_payment_status[1] = 1
else
	setNull(ii_payment_status[1])
end if

if cbx_draft.checked then 
	ii_payment_status[2] = 2
else
	setNull(ii_payment_status[2])
end if

if cbx_final.checked then 
	ii_payment_status[3] = 3
else
	setNull(ii_payment_status[3])
end if

if cbx_partpaid.checked then 
	ii_payment_status[4] = 4
else
	setNull(ii_payment_status[4])
end if
	
if cbx_paid.checked then 
	ii_payment_status[5] = 5
else
	setNull(ii_payment_status[5])
end if

//M5-4 added by WWG004 on 05/01/2012. Change desc: fix historic bug, add if...then condition.
CHOOSE CASE dw_payments.dataObject
	CASE "d_payments_vessel"
		if upperbound(ii_vesselno) = 0 then return 1
		dw_payments.retrieve(ii_vesselno, ii_payment_status)
	CASE "d_payments_profitcenter"
		if upperbound(ii_pcnr) = 0 then return 1
		dw_payments.retrieve(ii_pcnr, ii_payment_status)
	CASE "d_payments_contract"
		dw_payments.retrieve(il_contract_id, ii_payment_status)
	CASE "d_payments_finance_responsible"
		if upperbound(is_finance_userid) = 0 then return 1
		dw_payments.retrieve(is_finance_userid, ii_payment_status)
END CHOOSE
//M5-4 added by WWG004 on 05/01/2012

if dw_payments.rowcount() > 0 then
	if dw_payments.getrow() = 1 then 
		dw_payments.event rowfocuschanged(1)
	else
		dw_payments.setRow(1)
	end if
	dw_payments.post setfocus()
end if

return 1
end function

public function integer wf_filtertypeandrate ();string 	ls_filter=""

/* If user is some kind of external no access to TC-in contracts */
if uo_global.ii_access_level < 1 then
	if len(ls_filter) = 0 then
		ls_filter = "tc_hire_in=0"
	else
		ls_filter = "and tc_hire_in=0"
	end if
end if

if rb_receive.checked then
	if len(ls_filter) = 0 then
		ls_filter = "ntc_payment_income = 1"
	else
		ls_filter += "and ntc_payment_income = 1"
	end if
end if

if rb_hire.checked then
	if len(ls_filter) = 0 then
		ls_filter = "ntc_payment_income = 0"
	else
		ls_filter += "and ntc_payment_income = 0"
	end if
end if

if cbx_hide_zero_rate.checked then
	if len(ls_filter) = 0 then
//		ls_filter = "(sum_detail_amount <> 0 or payment_balance <> 0)"
		ls_filter = "sum_detail_amount <> 0"
else
//		ls_filter += "and (sum_detail_amount <> 0 or payment_balance <> 0)"
		ls_filter += "and sum_detail_amount <> 0"
	end if
end if

if cbx_date_filter.checked then
	if len(ls_filter) = 0 then
		ls_filter = "daysafter( today(), est_due_date ) < "+em_days.text
	else
		ls_filter += "and daysafter( today(), est_due_date ) < "+em_days.text
	end if
end if
	
dw_payments.setFilter(ls_filter)
dw_payments.filter()

//M5-4 added by WWG004 on 18/01/2012. Change desc: fix historic bug.
if dw_payments.rowcount() > 0 then
	dw_payments.selectrow(0, false)
	dw_payments.selectrow(1, true)
end if

return 1
end function

private subroutine wf_checkstatementopen ();/* This function checks if there is a Hire statement open
	If it is related to the the same contract as selected payment here on the payment window
	the statement will be closed down */
long 	ll_row

if NOT isValid(w_hire_statement) then return

ll_row = dw_payments.getSelectedRow(0)
if ll_row < 1 then return

/* If payment contract is the same as statement contract, close statement window */
if dw_payments.getItemNumber(ll_row, "contract_id") = w_hire_statement.wf_getContractid() then
	close (w_hire_statement)
end if





	
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_tc_payments
   <OBJECT> Ancestor object uo_vessel no longer used for this window.</OBJECT>
   <DESC>   n/a</DESC>
   <USAGE>  Change UI </USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   		Ref    	Author        	Comments
   26/12-11    M5-4    	WWG004		  	Main work are change UI.
	06/02-12		M5-4		WWG004			Fix bug, add function wf_select_row
	05/04-12		M5-10		LGX001         Add unlock button and function/UI change
   12/03-13    CR3129 	ZSW001			Refresh button enabled status
	24/09-13		CR3349	LGX001			Only Finance users must be able to Settle and Un-Settle statements.
	01/04-15    CR2897   KSH092         Remove restriction in TC-Out so user is able to settle or unsettle a hire statement			
********************************************************************/

end subroutine

public subroutine wf_select_row (datawindow adw_filter, string as_column);/********************************************************************
   wf_select_row
   <DESC>	Get the selected rows and put the value to array, and 
				dw_payments datawindow will retrieve according the array.</DESC>
   <RETURN>	(None):	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_filter	Selected datawindow
		as_column	Get the value of selected datawindow's column
   </ARGS>
   <USAGE>	User click the filter datawindow or click the select all/deselect all will
				trigger this function.</USAGE>
   <HISTORY>
   	Date       	CR-Ref    Author       Comments
   	31/01/2012 	M5-1      WWG004       First Version
   </HISTORY>
********************************************************************/

long	ll_index, ll_rows, ll_row, ll_paymentrows

//Get selected rows.
ll_rows 	= adw_filter.rowCount()
ll_index = 1
FOR ll_row = 1 TO ll_rows
	if (adw_filter.isselected(ll_row)) then
		choose case as_column
			case "vessels_vessel_fin_resp"
				is_finance_userid[ll_index] = adw_filter.getitemstring(ll_row, as_column)
			case "pc_nr"
				ii_pcnr[ll_index] = adw_filter.getitemnumber(ll_row, as_column)
			case "vessel_nr"
				ii_vesselno[ll_index] = adw_filter.getitemnumber(ll_row, as_column)
		end choose
		ll_index ++
	end if
NEXT

//Retrieve payment datawindow.
if ll_index > 1 then
	choose case as_column
		case "vessels_vessel_fin_resp"
			ll_paymentrows = dw_payments.retrieve(is_finance_userid, ii_payment_status)
		case "pc_nr"
			ll_paymentrows = dw_payments.retrieve(ii_pcnr, ii_payment_status)
		case "vessel_nr"
			ll_paymentrows = dw_payments.retrieve(ii_vesselno, ii_payment_status)
	end choose
	
	if ll_paymentrows > 0 then
		wf_filtertypeandrate()
		dw_payments.post setfocus()
	end if
else 
	dw_payments.reset()
end if
end subroutine

public subroutine wf_openinvoicetext (long al_row);/********************************************************************
   wf_openinvoicetext
   <DESC>	This function open invoicetext window when click payment row button	</DESC>
   <RETURN>	integer:
            
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		12/10/16 CR4520       KSH092   open invoicetext window
   </HISTORY>
********************************************************************/
long ll_paymentid
string ls_invoicetext

ll_paymentid = dw_payments.getitemdecimal(al_row,'payment_id')
openwithparm(w_hirestatement_invoicetext,ll_paymentid)

ls_invoicetext = message.stringparm
dw_payments.setitem(al_row,'ntc_payment_ax_invoice_text',ls_invoicetext)
end subroutine

event open;call super::open;long	ll_findvesselrow
n_dw_style_service   lnv_style

il_contract_ID = message.doubleparm

this.move(0,0)

/* initialize the array */
ii_payment_status = {1,2,3,4}

//M5-4 added by WWG004 on 04/01/2012. Change desc: Format window controls.
dw_vessel_list.modify("datawindow.header.height = 0")
dw_vessel_list.modify("datawindow.detail.height = 64")
dw_profit_center.modify("datawindow.header.height = 0")
dw_profit_center.modify("datawindow.detail.height = 64")
dw_finresp.modify("vessels_vessel_fin_resp.height = 56")
dw_finresp.modify("username.height = 56")
dw_finresp.modify("datawindow.detail.height = 64")

inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_payments, false)
lnv_style.of_dwlistformater( dw_vessel_list, false)

//Rebuild datawindow.
dw_profit_center.settransobject(SQLCA)
dw_vessel_list.settransobject(SQLCA)
dw_finresp.settransobject(SQLCA)

dw_profit_center.retrieve(uo_global.is_userid)
dw_vessel_list.retrieve(uo_global.is_userid)
dw_finresp.retrieve()

//M5-4 added by WWG004 on 01/02/2012. Change desc:fix bug
ll_findvesselrow = dw_vessel_list.find("vessel_nr = " + string(uo_global.getvessel_nr()), 1, dw_vessel_list.rowcount())
if ll_findvesselrow > 0 then
	dw_vessel_list.selectrow(ll_findvesselrow, true)
	dw_vessel_list.scrolltorow(ll_findvesselrow)
end if
//M5-4 added end.

IF NOT IsNull(il_contract_ID) THEN //window has been opened with parm
	dw_payments.dataObject = "d_payments_contract"
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_payments.settransobject(SQLCA)
	if dw_payments.retrieve(il_contract_ID, ii_payment_status) > 0 then
		dw_payments.post setFocus()
	end if
ELSE
	dw_payments.setTransObject(SQLCA)
END IF
end event

on w_tc_payments.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_duedate=create st_duedate
this.cbx_date_filter=create cbx_date_filter
this.st_zero=create st_zero
this.cbx_hide_zero_rate=create cbx_hide_zero_rate
this.cbx_paid=create cbx_paid
this.cbx_partpaid=create cbx_partpaid
this.cbx_final=create cbx_final
this.cbx_draft=create cbx_draft
this.cbx_new=create cbx_new
this.cb_refresh=create cb_refresh
this.cb_saveas=create cb_saveas
this.cb_open=create cb_open
this.rb_receive=create rb_receive
this.rb_hire=create rb_hire
this.rb_all=create rb_all
this.cb_modify=create cb_modify
this.dw_payments=create dw_payments
this.gb_filter_type=create gb_filter_type
this.gb_filter_status=create gb_filter_status
this.rb_history=create rb_history
this.rb_no_history=create rb_no_history
this.dw_finresp=create dw_finresp
this.cb_unsettle=create cb_unsettle
this.cb_settle=create cb_settle
this.cb_setdraft=create cb_setdraft
this.cb_lumpsum=create cb_lumpsum
this.cb_print=create cb_print
this.dw_profit_center=create dw_profit_center
this.dw_vessel_list=create dw_vessel_list
this.gb_hs_setting=create gb_hs_setting
this.gb_finresp=create gb_finresp
this.gb_pc=create gb_pc
this.gb_vessel=create gb_vessel
this.gb_hide_payments=create gb_hide_payments
this.st_topbar_background=create st_topbar_background
this.em_days=create em_days
this.cb_translog=create cb_translog
this.cb_setfinal=create cb_setfinal
this.cbx_select_pc=create cbx_select_pc
this.cbx_select_vessel=create cbx_select_vessel
this.cbx_select_fr=create cbx_select_fr
this.cb_unlock=create cb_unlock
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_duedate
this.Control[iCurrent+3]=this.cbx_date_filter
this.Control[iCurrent+4]=this.st_zero
this.Control[iCurrent+5]=this.cbx_hide_zero_rate
this.Control[iCurrent+6]=this.cbx_paid
this.Control[iCurrent+7]=this.cbx_partpaid
this.Control[iCurrent+8]=this.cbx_final
this.Control[iCurrent+9]=this.cbx_draft
this.Control[iCurrent+10]=this.cbx_new
this.Control[iCurrent+11]=this.cb_refresh
this.Control[iCurrent+12]=this.cb_saveas
this.Control[iCurrent+13]=this.cb_open
this.Control[iCurrent+14]=this.rb_receive
this.Control[iCurrent+15]=this.rb_hire
this.Control[iCurrent+16]=this.rb_all
this.Control[iCurrent+17]=this.cb_modify
this.Control[iCurrent+18]=this.dw_payments
this.Control[iCurrent+19]=this.gb_filter_type
this.Control[iCurrent+20]=this.gb_filter_status
this.Control[iCurrent+21]=this.rb_history
this.Control[iCurrent+22]=this.rb_no_history
this.Control[iCurrent+23]=this.dw_finresp
this.Control[iCurrent+24]=this.cb_unsettle
this.Control[iCurrent+25]=this.cb_settle
this.Control[iCurrent+26]=this.cb_setdraft
this.Control[iCurrent+27]=this.cb_lumpsum
this.Control[iCurrent+28]=this.cb_print
this.Control[iCurrent+29]=this.dw_profit_center
this.Control[iCurrent+30]=this.dw_vessel_list
this.Control[iCurrent+31]=this.gb_hs_setting
this.Control[iCurrent+32]=this.gb_finresp
this.Control[iCurrent+33]=this.gb_pc
this.Control[iCurrent+34]=this.gb_vessel
this.Control[iCurrent+35]=this.gb_hide_payments
this.Control[iCurrent+36]=this.st_topbar_background
this.Control[iCurrent+37]=this.em_days
this.Control[iCurrent+38]=this.cb_translog
this.Control[iCurrent+39]=this.cb_setfinal
this.Control[iCurrent+40]=this.cbx_select_pc
this.Control[iCurrent+41]=this.cbx_select_vessel
this.Control[iCurrent+42]=this.cbx_select_fr
this.Control[iCurrent+43]=this.cb_unlock
end on

on w_tc_payments.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_duedate)
destroy(this.cbx_date_filter)
destroy(this.st_zero)
destroy(this.cbx_hide_zero_rate)
destroy(this.cbx_paid)
destroy(this.cbx_partpaid)
destroy(this.cbx_final)
destroy(this.cbx_draft)
destroy(this.cbx_new)
destroy(this.cb_refresh)
destroy(this.cb_saveas)
destroy(this.cb_open)
destroy(this.rb_receive)
destroy(this.rb_hire)
destroy(this.rb_all)
destroy(this.cb_modify)
destroy(this.dw_payments)
destroy(this.gb_filter_type)
destroy(this.gb_filter_status)
destroy(this.rb_history)
destroy(this.rb_no_history)
destroy(this.dw_finresp)
destroy(this.cb_unsettle)
destroy(this.cb_settle)
destroy(this.cb_setdraft)
destroy(this.cb_lumpsum)
destroy(this.cb_print)
destroy(this.dw_profit_center)
destroy(this.dw_vessel_list)
destroy(this.gb_hs_setting)
destroy(this.gb_finresp)
destroy(this.gb_pc)
destroy(this.gb_vessel)
destroy(this.gb_hide_payments)
destroy(this.st_topbar_background)
destroy(this.em_days)
destroy(this.cb_translog)
destroy(this.cb_setfinal)
destroy(this.cbx_select_pc)
destroy(this.cbx_select_vessel)
destroy(this.cbx_select_fr)
destroy(this.cb_unlock)
end on

event activate;If w_tramos_main.MenuName <> "m_tcmain" Then 
	w_tramos_main.ChangeMenu(m_tcmain)
End if


end event

event ue_vesselselection;call super::ue_vesselselection;IF dw_payments.dataObject <> "d_payments_vessel" THEN 
	/*used if the button is clicked as the first event after the window has been opened 
	(when	the window opens with a contract ID as a parameter, the dw_payments.dataobject
	is for obvious reasons d_payments_contract)*/ 
	dw_payments.dataObject = "d_payments_vessel"
	dw_payments.setTransObject(SQLCA)
END IF

ii_vesselno = ii_empty
ii_vesselno[1] = ii_vessel_nr
if dw_payments.retrieve(ii_vesselno, ii_payment_status) > 0 then
	//dw_payments.Event rowFocusChanged(1)
	wf_filtertypeandrate()
	dw_payments.post setfocus()
end if
dw_vessel_list.selectrow(0,false)

end event

event ue_refresh;call super::ue_refresh;/* This event is created so that other windows can POST a refresh of it */
cb_refresh.TriggerEvent(Clicked!)
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_tc_payments
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_tc_payments
boolean visible = false
integer taborder = 10
end type

type st_3 from statictext within w_tc_payments
integer x = 3511
integer y = 240
integer width = 238
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "n days ="
alignment alignment = center!
boolean focusrectangle = false
end type

type st_duedate from statictext within w_tc_payments
integer x = 3511
integer y = 160
integer width = 645
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Where duedate > today + n day"
boolean focusrectangle = false
end type

type cbx_date_filter from checkbox within w_tc_payments
integer x = 3438
integer y = 160
integer width = 69
integer height = 56
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
end type

event clicked;wf_filterTypeAndRate()
end event

type st_zero from statictext within w_tc_payments
integer x = 3511
integer y = 80
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Where rate is zero"
boolean focusrectangle = false
end type

type cbx_hide_zero_rate from checkbox within w_tc_payments
integer x = 3438
integer y = 80
integer width = 69
integer height = 56
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
end type

event clicked;wf_filterTypeAndRate()
end event

type cbx_paid from checkbox within w_tc_payments
integer x = 2633
integer y = 160
integer width = 274
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Paid"
end type

event clicked;wf_statusFilter()
end event

type cbx_partpaid from checkbox within w_tc_payments
integer x = 2633
integer y = 80
integer width = 279
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Part Paid"
boolean checked = true
end type

event clicked;wf_statusFilter()
end event

type cbx_final from checkbox within w_tc_payments
integer x = 2414
integer y = 240
integer width = 215
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Final"
boolean checked = true
end type

event clicked;wf_statusFilter()
end event

type cbx_draft from checkbox within w_tc_payments
integer x = 2414
integer y = 160
integer width = 215
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Draft"
boolean checked = true
end type

event clicked;wf_statusFilter()
end event

type cbx_new from checkbox within w_tc_payments
integer x = 2414
integer y = 80
integer width = 215
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "New"
boolean checked = true
end type

event clicked;wf_statusFilter()
end event

type cb_refresh from commandbutton within w_tc_payments
integer x = 4210
integer y = 32
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;long 		ll_payments=0
long		ll_findrow, ll_found
long		ll_paymentID

dw_payments.setRedraw(false)

/* Get paymentid for current payment. Used in search after retrieve */
ll_findrow = dw_payments.getRow()
if ll_findrow > 0 then ll_paymentID = dw_payments.getItemNumber(ll_findrow, "payment_id")

/* Find out what datawindow is active, and refresh (retrieve) */
IF dw_payments.dataObject = "d_payments_vessel" THEN 
	/* Hvis vessel som argument */
	if upperbound(ii_vesselno) = 0 then return
 	ll_payments = dw_payments.retrieve(ii_vesselno, ii_payment_status)
	commit; 
elseif dw_payments.dataObject = "d_payments_profitcenter" THEN
	/* Hvis profitcenter som argument */
	if upperbound(ii_pcnr) = 0 then return
	ll_payments = dw_payments.retrieve(ii_pcnr, ii_payment_status)
	commit;
elseif dw_payments.dataObject = "d_payments_contract" THEN
	/* Hvis Contract som argument */
	ll_payments = dw_payments.retrieve(il_contract_ID, ii_payment_status)
	commit;
else
	/* somthing went wrong, return */
	dw_payments.setRedraw(true)
	return
end if

/* find and highlight row if any selected before, otherwise highlight the first row */
if ll_payments > 0 then	
	if ll_findrow > 0 then
		ll_found = dw_payments.find("payment_id="+string(ll_paymentID),1,dw_payments.rowCount())
	end if
	
	if ll_found = 0 then ll_found = 1 //set row = 1 if not found
		
	dw_payments.scrollToRow(ll_found)
	dw_payments.Event rowFocusChanged(ll_found)
	dw_payments.setRow(ll_found)
	dw_payments.post setfocus()		
end if

dw_payments.setRedraw(true)

end event

type cb_saveas from commandbutton within w_tc_payments
integer x = 4224
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 220
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save &As..."
end type

event clicked;dw_payments.saveas( )
end event

type cb_open from commandbutton within w_tc_payments
integer x = 3182
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 190
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Open"
end type

event clicked;LONG 				ll_payment_status
DATETIME			ldt_due_date
s_h_statement 	lstr_h_statement
long 				ll_row

ll_row = dw_payments.getRow()
if ll_row < 1 then return

lstr_h_statement.pc_nr = dw_payments.getitemnumber(ll_row, "vessels_pc_nr")
lstr_h_statement.payment_id = dw_payments.getItemNumber(ll_row, "payment_id")
lstr_h_statement.contract_id = dw_payments.getItemNumber(ll_row, "contract_id")
IF rb_history.checked = TRUE THEN
	lstr_h_statement.payment_id_low = 0
ELSE //show period data only, if the payment is not the last payment for the contract 
//	IF inv_tc_payment.of_ispaymentfinal(lstr_h_statement.payment_id, lstr_h_statement.contract_id) = 1 THEN 
//						/*last payment -> final hire -> must include history*/
//		lstr_h_statement.payment_id_low = 0
//	ELSE //the payment is not the last one - accept user's choice and show period data only
		lstr_h_statement.payment_id_low = lstr_h_statement.payment_id
//	END IF
END IF

//openwithparm(w_hire_statement, lstr_h_statement)
if isvalid(w_hire_statement) then close(w_hire_statement)
opensheetwithparm(w_hire_statement, lstr_h_statement, w_tramos_main, -1, Original!)
//IF message.doubleparm = 1 THEN //payment status has been changed - update DWs to reflect the change
//	if dw_payments.retrieve(lstr_h_statement.payment_id) > 0 then
//		dw_payments.event rowFocusChanged(1)
//	end if
//END IF

dw_payments.post setfocus()
end event

type rb_receive from radiobutton within w_tc_payments
integer x = 3008
integer y = 240
integer width = 361
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Receivables"
end type

event clicked;wf_filterTypeAndRate()

end event

type rb_hire from radiobutton within w_tc_payments
integer x = 3008
integer y = 160
integer width = 361
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Payables"
end type

event clicked;wf_filterTypeAndRate()
end event

type rb_all from radiobutton within w_tc_payments
integer x = 3008
integer y = 80
integer width = 361
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "All"
boolean checked = true
end type

event clicked;wf_filterTypeAndRate()

end event

type cb_modify from commandbutton within w_tc_payments
integer x = 3529
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Modify"
end type

event clicked;long 						ll_row
s_payment_expenses	lstr_payment_expenses

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_payments.getRow()
IF ll_row > 0 THEN
	lstr_payment_expenses.payment_id = dw_payments.getitemnumber(ll_row, "payment_id")
	lstr_payment_expenses.contract_id = dw_payments.getitemnumber(ll_row, "contract_id")
	OpenWithParm(w_payment_expenses, lstr_payment_expenses)
	dw_payments.post setFocus()
END IF
end event

type dw_payments from u_datagrid within w_tc_payments
event ue_keydown pbm_dwnkey
integer x = 37
integer y = 624
integer width = 4517
integer height = 1736
integer taborder = 230
string dataobject = "d_payments_vessel"
boolean vscrollbar = true
boolean border = false
string icon = "Form!"
end type

event ue_keydown;if key = KeySpaceBar! then 
	this.Event DoubleClicked(0,0, this.getRow(), this.object.payment_id)
end if
end event

event rowfocuschanged;integer	li_status, li_locked, li_tc_in, li_userprofile

if currentrow > 0 then 
	this.selectrow(0, FALSE)
	this.selectrow(currentrow, TRUE)
	li_status = this.getItemNumber(currentrow, "status")
	li_locked = this.getItemNumber(currentrow, "ntc_payment_locked")
	li_tc_in  = this.getItemNumber(currentrow, "tc_hire_in")
	li_userprofile = uo_global.ii_user_profile 
	
	/* Settle Button */
	choose case li_status 
		case 3, 4
			// Finance profile
			if li_userprofile = 3 then 
				cb_settle.enabled = true 
			else 
				cb_settle.enabled = false
			end if
		case 5 
			if this.getItemNumber(currentrow, "payment_balance") <> 0 then
				if li_userprofile = 3 then 
					cb_settle.enabled = true 
				else 
					cb_settle.enabled = false
				end if
			else
				cb_settle.enabled = false
			end if
		case else 
			cb_settle.enabled = false
	end choose
		// Un-settle Button
	if this.getItemNumber(currentrow, "trans_to_coda") = 1 and (li_status = 4 or li_status = 5) then
		if li_userprofile = 3 then 
			cb_unsettle.enabled = true 
		else 
			cb_unsettle.enabled = false
		end if
	else
		cb_unsettle.enabled = false
	end if
	
	/* set Final Button */
	if li_status = 2 and this.getitemnumber(currentrow, 'ntc_payment_income') = 0 then
		cb_setfinal.enabled = true
	else
		cb_setfinal.enabled = false
	end if

	/* set Draft Button */
	if li_status = 3 then
		/* TC out & Operater */
		if li_tc_in = 0 and li_userprofile <> 2 then 
			cb_setdraft.enabled = false 
		else 
			cb_setdraft.enabled = true
		end if
	else
		cb_setdraft.enabled = false
	end if
	
	/* Lumpsum Button */
//	if li_status < 3  &
//	and this.getItemNumber(currentrow, "ntc_payment_income") = 0  &
	if li_status < 3  &
	and this.getItemNumber(currentrow, "payment_id") = this.getItemNumber(currentrow, "min_id") then
		cb_lumpsum.enabled = true
	else
		cb_lumpsum.enabled = false
	end if
	
	//M5-10 Added by LGX001 on 27/03/2012.desc: finance user & locked & TC out 
	if li_userprofile = 3 and li_locked = 1 and li_tc_in = 0 then 
		cb_unlock.enabled = true 
	else 
		cb_unlock.enabled = false
	end if
	
	parent.title = "Payments (ID="+string(this.getItemNumber(currentrow, "payment_id"))+")"
end if
end event

event doubleclicked;if row > 0 then
	cb_open.TriggerEvent(Clicked!)
end if
end event

event retrieveend;long ll_found

if rowcount < 1 then return

ll_found = this.find("status=1",1,rowcount)
if ll_found > 0 then
	this.scrollToRow(ll_found)
	this.event rowFocusChanged(ll_found)
	this.setRow(ll_found)
end if
end event

event clicked;call super::clicked;long   ll_found
string ls_object

// Get the object at the point clicked
ls_object = dw_payments.GetObjectAtPointer()

// Find the button and the row clicked
ll_found       = Pos(ls_object,"p_invoicetext")
if ll_found > 0 then

 	post wf_openinvoicetext(row)

end if
end event

type gb_filter_type from groupbox within w_tc_payments
integer x = 2971
integer y = 16
integer width = 398
integer height = 312
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Filter Type"
end type

type gb_filter_status from groupbox within w_tc_payments
integer x = 2377
integer y = 16
integer width = 558
integer height = 312
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Filter Status"
end type

type rb_history from radiobutton within w_tc_payments
integer x = 2414
integer y = 492
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "With history"
end type

event clicked;gb_tc_payment = true
end event

type rb_no_history from radiobutton within w_tc_payments
integer x = 2414
integer y = 412
integer width = 453
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Period data only"
boolean checked = true
end type

event clicked;gb_tc_payment = false
end event

type dw_finresp from datawindow within w_tc_payments
integer x = 73
integer y = 92
integer width = 809
integer height = 452
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_dddw_finance_responsible"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_index
long ll_row, ll_rows

//reset profitcenter array
is_finance_userid  = is_empty

IF dw_payments.dataObject <> "d_payments_finance_responsible" THEN 
	/*used when a vessel is selected the first time after the window has been opened 
	(when	the window opens with a contract ID as a parameter, the dw_payments.dataobject
	is for obvious reasons d_payments_contract)*/ 
	dw_payments.dataObject = "d_payments_finance_responsible"
	inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_payments.setTransObject(SQLCA)
	
	//M5-4 added by WWG004 on 12/01/2012. Change desc:clear other filter datawindow selected.
	dw_profit_center.selectrow(0, false)
	dw_vessel_list.selectrow(0, false)
END IF

if (row > 0) then
	this.selectrow(row, NOT this.isselected(row))
end if

wf_select_row(dw_finresp, 'vessels_vessel_fin_resp')

//ll_rows = this.rowCount()
//li_index = 1
//FOR ll_row = 1 TO ll_rows
//	if (dw_finresp.isselected(ll_row)) then
//		is_finance_userid[li_index] = dw_finresp.getitemstring(ll_row, "vessels_vessel_fin_resp")
//		li_index ++
//	end if
//NEXT
//
//if li_index > 1 then
//	if dw_payments.retrieve(is_finance_userid, ii_payment_status) > 0 then
//		//dw_payments.event rowFocusChanged(1)
//		wf_filtertypeandrate()
//		dw_payments.post setfocus()
//	end if
//else 
//	dw_payments.reset()
//end if

end event

event constructor;IF uo_global.ii_access_level < 1 THEN 
	this.Enabled = false
END IF
end event

type cb_unsettle from commandbutton within w_tc_payments
integer x = 754
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Un-Settle"
end type

event clicked;n_tc_settle_payment	lnv_settle
long						ll_paymentID, ll_contractID			
long						ll_row
string 					ls_fix_userid, ls_invoice_nr
integer					li_payment_status, li_payment_locked, li_tchire_in

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_payments.getRow()
if ll_row < 1 then return

wf_checkstatementopen( )

setPointer(hourglass!)

ll_paymentID 	= dw_payments.getItemNumber(ll_row, "payment_id")
ll_contractID	= dw_payments.getItemNumber(ll_row, "contract_id")

/* TC_HIRE_IN:0(TC OUT) / 1(TC IN) */
SELECT NTC_TC_CONTRACT.TC_HIRE_IN, NTC_PAYMENT.LOCKED, NTC_PAYMENT.INVOICE_NR INTO :li_tchire_in, :li_payment_locked, :ls_invoice_nr
FROM NTC_TC_CONTRACT, NTC_PAYMENT  
WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID
AND NTC_PAYMENT.PAYMENT_ID = :ll_paymentID;
if sqlca.sqlcode <> 0 then
	messagebox("Select error", "Error selecting Payment status")
	setPointer(arrow!)
	return
end if

if li_tchire_in = 0 and li_payment_locked = 1 then
	messagebox("Information", "Payment is locked. Please contact finance.")
	setPointer(arrow!)
	return
end if

if messagebox("Confirm Un-Settle", "Do you want to continue un-settling the payment?" , Question!, YesNo!, 1) = 1 then //yes
	lnv_settle = CREATE n_tc_settle_payment
	//tc in: unsettle subsequent final payments
	if li_tchire_in = 1 and li_payment_status = 3 then
		lnv_settle.of_unsettlepayment_final(ll_paymentID, ii_UNSETTLE)
	end if
	//unsettle current payment
	lnv_settle.of_unsettlePayment(ll_paymentID, ii_UNSETTLE)	
	destroy lnv_settle	
	COMMIT;	
	
	cb_refresh.TriggerEvent(clicked!)
	if isValid(w_tc_contract) then
		w_tc_contract.PostEvent("ue_refresh")
	end if
end if

setPointer(arrow!)

end event

type cb_settle from commandbutton within w_tc_payments
integer x = 1102
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 130
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "S&ettle"
end type

event clicked;integer					li_chartnr, li_tcownernr, li_tchire_in
n_tc_settle_payment	lnv_settle
long						ll_paymentID, ll_contractID			
long						ll_row
string						ls_fix_userid
integer					li_payment_status, li_payment_locked
u_charterer				lnv_chart
u_tcowner				lnv_tcowner

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_payments.getRow()
if ll_row < 1 then return

wf_checkstatementopen( )

setPointer(hourglass!)
ll_paymentID 	= dw_payments.getItemNumber(ll_row, "payment_id")
ll_contractID	= dw_payments.getItemNumber(ll_row, "contract_id")

/* Check if contract fixtured. If not return */
SELECT isnull(NTC_TC_CONTRACT.FIXTURE_USER_ID, "0"), CHART_NR, TCOWNER_NR, TC_HIRE_IN, NTC_PAYMENT.LOCKED  
   INTO :ls_fix_userid, :li_chartnr, :li_tcownernr, :li_tchire_in, :li_payment_locked  
   FROM NTC_TC_CONTRACT, NTC_PAYMENT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID
	AND NTC_PAYMENT.PAYMENT_ID = :ll_paymentID;

if ls_fix_userid = "0" then
	MessageBox("Print Error", "You can't settle payments on a contract that is not fixtured!")
	setPointer(arrow!)
	return
end if

if li_tchire_in = 0 and li_payment_locked = 1 then
	messagebox("Information", "Payment is locked. Please contact finance.")
	return
end if

/* Check it owner or charterer is blocked by AX */
if li_tchire_in = 1 then
	lnv_tcowner = create u_tcowner
	lnv_tcowner.of_gettcowner( li_tcownernr )
	if lnv_tcowner.of_blocked( ) then
		MessageBox("Error", "TC Owner is Blocked by AX and cannot be settled",StopSign!)
		destroy lnv_tcowner
		return
	end if
	destroy lnv_tcowner

else
	lnv_chart = create u_charterer
	lnv_chart.of_getcharterer( li_chartnr )
	if lnv_chart.of_blocked( ) then
		MessageBox("Error", "Charterer is Blocked by AX and cannot be settled",StopSign!)
		destroy lnv_chart
		return
	end if
	destroy lnv_chart
end if

lnv_settle = CREATE n_tc_settle_payment
lnv_settle.of_settlePayment(ll_paymentID)
destroy lnv_settle
cb_refresh.TriggerEvent(clicked!)
if isValid(w_tc_contract) then
	w_tc_contract.PostEvent("ue_refresh")
end if

setPointer(arrow!)

end event

type cb_setdraft from commandbutton within w_tc_payments
integer x = 1449
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 140
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Set &Draft"
end type

event clicked;integer					li_tchire_in, li_payment_locked
long						ll_paymentID, ll_contractID
long						ll_row
integer              li_payment_status


n_tc_settle_payment	lnv_settle
 
IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation", "As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_payments.getRow()
if ll_row < 1 then return

wf_checkstatementopen( )

ll_paymentID 	= dw_payments.getItemNumber(ll_row, "payment_id")
ll_contractID	= dw_payments.getItemNumber(ll_row, "contract_id")

/* TC_HIRE_IN:0(TC OUT) / 1(TC IN) */
SELECT NTC_TC_CONTRACT.TC_HIRE_IN, NTC_PAYMENT.LOCKED  INTO :li_tchire_in, :li_payment_locked
FROM NTC_TC_CONTRACT, NTC_PAYMENT  
WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID
AND NTC_PAYMENT.PAYMENT_ID = :ll_paymentID;

/* TC in:
   	If not "administrator" then check if person is finans profile. If not return 
		TC-IN only finance profile can change status from final to draft	
		If not return 
	TC out:
	   if payment is locked then return
		only operator profile can change status from final to draft
*/
	
/* tc out */	
if li_tchire_in = 0 then
	if li_payment_locked = 1 then
		messagebox("Information", "Payment is locked. Please contact finance.")
		return
	end if
elseif uo_global.ii_access_level <> 3 and uo_global.ii_user_profile <> 3 then   
		messagebox("Information", "Only Finance profile can change payment status")
		return	
end if

if MessageBox("Change payment status...", "Transaction will be reversed when changing Payment status from" +&
		"<Final> to <Draft>. ~r~nWould you like to proceed?", Question!,	YesNo!, 2) = 1 then //yes
	
	//M5-4 Modified by LGX001 on 12/01/2012.	
	if dw_payments.getItemNumber(ll_row, "trans_to_coda") = 1 then //unsettle payment
	/* Check if previous payment is settled */
	   SELECT MAX(PAYMENT_STATUS)		     
		INTO :li_payment_status
		FROM NTC_PAYMENT
		WHERE PAYMENT_ID > :ll_paymentID
		AND	CONTRACT_ID = :ll_contractID;
		if sqlca.sqlcode < 0 then
			messagebox("Select error", "Error selecting Payment status")
			return
		end if
			
		lnv_settle = CREATE n_tc_settle_payment
		//tc in: unsettle subsequent final payments
		if li_tchire_in = 1 and li_payment_status = 3 then
			lnv_settle.of_unsettlepayment_final(ll_paymentID, ii_UNSETTLE)
		end if
		//unsettle current payment
		lnv_settle.of_unsettlePayment(ll_paymentID, ii_SETDRAFT)		
		destroy lnv_settle
		
		COMMIT;
		
	else //only update the status
		UPDATE NTC_PAYMENT  
		SET PAYMENT_STATUS = 2
		WHERE NTC_PAYMENT.PAYMENT_ID = :ll_paymentID ;
		if sqlca.sqlCode = 0 then
			commit;
		else
			rollback;
			messagebox("Update error", "Error updating payment status")
		end if
	end if
	
	if isValid(w_tc_payments) then
		w_tc_payments.cb_refresh.triggerevent(clicked!) 
	end if
end if

end event

type cb_lumpsum from commandbutton within w_tc_payments
integer x = 2144
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Lumpsum"
end type

event clicked;n_tc_settle_payment	lnv_settle
string					ls_fix_userid
long						ll_row
long 						ll_paymentID

IF uo_global.ii_access_level = -1 THEN 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	Return
END IF

ll_row = dw_payments.getRow()
if ll_row < 1 then 
	return
END IF	

wf_checkstatementopen( )

ll_paymentID = dw_payments.getItemNumber(ll_row, "payment_id")

/* Check if contract fixtured. If not return */
SELECT isnull(NTC_TC_CONTRACT.FIXTURE_USER_ID, "0")  
   INTO :ls_fix_userid  
   FROM NTC_TC_CONTRACT, NTC_PAYMENT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID
	AND NTC_PAYMENT.PAYMENT_ID = :ll_paymentID;

if ls_fix_userid = "0" then
	MessageBox("Print Error", "You can't settle payments on a contract that is not fixtured!")
	return
end if

/* If not "administrator" then check if person is finans profile. If not return */
IF uo_global.ii_access_level <> 3 THEN 
	if uo_global.ii_user_profile <> 3 then   
		MessageBox("Information", "Only Finans profile can settle payments")
		return
	end if
END IF

lnv_settle = CREATE n_tc_settle_payment
if  dw_payments.getItemNumber(ll_row, "ntc_payment_income") = 0 then
	lnv_settle.of_lumpsumPayment(ll_paymentID)
else
	lnv_settle.of_lumpsumReceivable(ll_paymentID)
end if	
destroy lnv_settle
cb_refresh.Event Clicked()
if isValid(w_tc_contract) then
	w_tc_contract.PostEvent("ue_refresh")
end if

end event

type cb_print from commandbutton within w_tc_payments
integer x = 3877
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 210
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print List"
end type

event clicked;//M5-4 modified by WWG004 on 10/01/2012. Change desc: Add a message to confirm print.
if messagebox("Information", "Do you really want to print a list of all currently displayed hire statements?", &
	Information!, YesNo!, 1) = 1 then
	dw_payments.print()
else
	return
end if
end event

type dw_profit_center from datawindow within w_tc_payments
integer x = 987
integer y = 92
integer width = 658
integer height = 452
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_index
long ll_row, ll_rows

//reset profitcenter array
ii_pcnr = ii_empty

IF dw_payments.dataObject <> "d_payments_profitcenter" THEN 
	/*used when a vessel is selected the first time after the window has been opened 
	(when	the window opens with a contract ID as a parameter, the dw_payments.dataobject
	is for obvious reasons d_payments_contract)*/ 
	dw_payments.dataObject = "d_payments_profitcenter"
	inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_payments.setTransObject(SQLCA)
	
	//M5-4 added by WWG004 on 12/01/2012. Change desc:clear other filter datawindow selected.
	dw_finresp.selectrow(0, false)
	dw_vessel_list.selectrow(0, false)
END IF

if (row > 0) then
	this.selectrow(row, NOT this.isselected(row))
end if

wf_select_row(dw_profit_center, 'pc_nr')

//ll_rows = this.rowCount()
//li_index = 1
//FOR ll_row = 1 TO ll_rows
//	if (dw_profit_center.isselected(ll_row)) then
//		ii_pcnr[li_index] = dw_profit_center.getitemnumber(ll_row, "pc_nr")
//		li_index ++
//	end if
//NEXT
//
//if li_index > 1 then
//	if dw_payments.retrieve(ii_pcnr, ii_payment_status) > 0 then
//		//dw_payments.event rowFocusChanged(1)
//		wf_filtertypeandrate()
//		dw_payments.post setfocus()
//	end if
//else 
//	dw_payments.reset()
//end if

end event

event constructor;IF uo_global.ii_access_level < 1 THEN 
	this.Enabled = false
END IF
end event

event rbuttondown;integer li_index
long ll_row, ll_rows

//reset profitcenter array
ii_pcnr = ii_empty

IF dw_payments.dataObject <> "d_payments_profitcenter" THEN 
	/*used when a vessel is selected the first time after the window has been opened 
	(when	the window opens with a contract ID as a parameter, the dw_payments.dataobject
	is for obvious reasons d_payments_contract)*/ 
	dw_payments.dataObject = "d_payments_profitcenter"
	dw_payments.setTransObject(SQLCA)
END IF

if (row > 0) then
	if dw_profit_center.isselected(1) then
		this.selectrow(0, FALSE)
	else
		this.selectrow(0, TRUE)
	end if		
end if

ll_rows = this.rowCount()
li_index = 1
FOR ll_row = 1 TO ll_rows
	if (dw_profit_center.isselected(ll_row)) then
		ii_pcnr[li_index] = dw_profit_center.getitemnumber(ll_row, "pc_nr")
		li_index ++
	end if
NEXT

if li_index > 1 then
	if dw_payments.retrieve(ii_pcnr, ii_payment_status) > 0 then
		//dw_payments.event rowFocusChanged(1)
		wf_filtertypeandrate()
		dw_payments.post setfocus()
	end if
else 
	dw_payments.reset()
end if

end event

type dw_vessel_list from datawindow within w_tc_payments
integer x = 1755
integer y = 92
integer width = 549
integer height = 452
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_sq_tb_vessels_with_tccontract"
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer li_index
long ll_row, ll_rows

//reset vessel array
ii_vesselno = ii_empty

IF dw_payments.dataObject <> "d_payments_vessel" THEN 
	/*used when a vessel is selected the first time after the window has been opened 
	(when	the window opens with a contract ID as a parameter, the dw_payments.dataobject
	is for obvious reasons d_payments_contract)*/ 
	dw_payments.dataObject = "d_payments_vessel"
	inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_payments.setTransObject(SQLCA)
	
	//M5-4 added by WWG004 on 12/01/2012. Change desc:clear other filter datawindow select
	dw_finresp.selectrow(0, false)
	dw_profit_center.selectrow(0, false)
END IF

if (row > 0) then
	this.selectrow(row, NOT this.isselected(row))
end if

wf_select_row(dw_vessel_list, 'vessel_nr')

//ll_rows = dw_vessel_list.rowcount()
//
//li_index = 1
//FOR ll_row = 1 TO ll_rows
//	if (dw_vessel_list.isselected(ll_row)) then
//		ii_vesselno[li_index] = dw_vessel_list.getitemnumber(ll_row, "vessel_nr")
//		li_index ++
//	end if
//NEXT
//
//if li_index > 1 then
//	if dw_payments.retrieve(ii_vesselno, ii_payment_status) > 0 then
//		//dw_payments.event rowFocusChanged(1)
//		wf_filtertypeandrate()
//		dw_payments.post setfocus()
//	end if
//else 
//	dw_payments.reset()
//end if

end event

event constructor;IF uo_global.ii_access_level < 1 THEN 
	this.Enabled = false
END IF
end event

type gb_hs_setting from groupbox within w_tc_payments
integer x = 2377
integer y = 348
integer width = 558
integer height = 228
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Hire Statement"
end type

type gb_finresp from groupbox within w_tc_payments
integer x = 37
integer y = 16
integer width = 882
integer height = 560
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Finance Responsible"
end type

type gb_pc from groupbox within w_tc_payments
integer x = 951
integer y = 16
integer width = 731
integer height = 560
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Profit Center"
end type

type gb_vessel from groupbox within w_tc_payments
integer x = 1719
integer y = 16
integer width = 622
integer height = 560
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Vessel"
end type

type gb_hide_payments from groupbox within w_tc_payments
integer x = 3406
integer y = 16
integer width = 768
integer height = 312
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 553648127
string text = "Hide Payments"
end type

type st_topbar_background from u_topbar_background within w_tc_payments
integer width = 4782
integer height = 600
end type

type em_days from editmask within w_tc_payments
integer x = 3749
integer y = 240
integer width = 110
integer height = 56
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "30"
boolean border = false
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

event modified;wf_filterTypeAndRate()
end event

type cb_translog from commandbutton within w_tc_payments
integer x = 2834
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 180
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Show &History"
end type

event clicked;long ll_getrow, ll_paymentid

ll_getrow = dw_payments.getrow()
if ll_getrow > 0 then
	ll_paymentid = dw_payments.getItemNumber(ll_getrow, "payment_id")
	opensheetwithparm(w_statement_history, ll_paymentid, w_tramos_main, -1, Original!)
end if
end event

type cb_setfinal from commandbutton within w_tc_payments
integer x = 1797
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Set &Final"
end type

event clicked;integer					li_tchire_in, li_check_status
long						ll_paymentID, ll_contractID			
long						ll_row
string						ls_fix_userid
integer					li_payment_status

if uo_global.ii_access_level = -1 then 
	MessageBox("Infomation","As an external user you do not have access to this functionality.")
	return
end if

ll_row = dw_payments.getRow()
if ll_row < 1 then return

wf_checkstatementopen( )

ll_paymentID 	= dw_payments.getItemNumber(ll_row, "payment_id")
ll_contractID	= dw_payments.getItemNumber(ll_row, "contract_id")

/* Check if contract fixtured. If not return */
SELECT isnull(NTC_TC_CONTRACT.FIXTURE_USER_ID, "0"),
		 NTC_TC_CONTRACT.TC_HIRE_IN
   INTO :ls_fix_userid,
		  :li_tchire_in
   FROM NTC_TC_CONTRACT, NTC_PAYMENT  
	WHERE NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID
	AND NTC_PAYMENT.PAYMENT_ID = :ll_paymentID;

if ls_fix_userid = "0" then
	MessageBox("Print Error", "You can't change payment status on a contract that is not fixtured!")
	return
end if

/* If not "administrator" then check if person is finans profile. If not return 
	TC-IN only finans profile can change status to final
	TC-OUT both finans and operator profile can change status to final
	If not return */
if uo_global.ii_access_level <> 3 then 
	if li_tchire_in = 1 and uo_global.ii_user_profile <> 3 then   
		MessageBox("Information", "Only Finans profile can change payment status")
		return
	elseif li_tchire_in = 0 and uo_global.ii_user_profile < 2 then   
		MessageBox("Information", "Only Operator or Finans profile can change payment status")
		return
	end if
end if

if MessageBox("Change payment status...", "Would you like to change Payment status from" +&
		"<Draft> to <Final>?~r~nUntil status is <Final>, payment can't " +&
		"be settled!", Question!,	YesNo!, 2) = 1 then
	/* Check if previous payment are final */
	
	UPDATE NTC_PAYMENT  
		SET PAYMENT_STATUS = 3
		WHERE NTC_PAYMENT.PAYMENT_ID = :ll_paymentID ;
	if sqlca.sqlCode = 0 then
		commit;
	else
		rollback;
		MessageBox("Update error", "Error updating payment status")
	end if
	if isValid(w_tc_payments) then
		w_tc_payments.cb_refresh.post event Clicked()
	end if
end if

end event

type cbx_select_pc from checkbox within w_tc_payments
integer x = 1321
integer y = 16
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Select all"
end type

event clicked;/********************************************************************
   w_tc_payments
   <OBJECT>		cbx_select_pc	</OBJECT>
   <USAGE>		click this can select all or deselect all</USAGE>
   <ALSO>		none			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01/02/2012 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/

if dw_payments.dataObject <> "d_payments_profitcenter" then
	dw_payments.dataObject = "d_payments_profitcenter"
	inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_payments.setTransObject(SQLCA)
	
	dw_finresp.selectrow(0, false)
	dw_vessel_list.selectrow(0, false)
	
	cbx_select_fr.checked 			= false
	cbx_select_fr.text 				= "Select all"
	cbx_select_fr.textcolor 		= c#color.White
	cbx_select_vessel.checked 		= false
	cbx_select_vessel.text 			= "Select all"
	cbx_select_vessel.textcolor	= c#color.White
end if

if this.checked then	
	this.text = "Deselect all"
else
	this.text = "Select all"
end if

dw_profit_center.selectrow(0, this.checked)

this.textcolor = c#color.White

wf_select_row(dw_profit_center, "pc_nr")
end event

type cbx_select_vessel from checkbox within w_tc_payments
integer x = 1979
integer y = 16
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Select all"
end type

event clicked;/********************************************************************
   w_tc_payments
   <OBJECT>		cbx_select_vessel	</OBJECT>
   <USAGE>		click this can select all or deselect all</USAGE>
   <ALSO>		none			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01/02/2012 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/

if dw_payments.dataObject <> "d_payments_vessel" then
	dw_payments.dataObject = "d_payments_vessel"
	inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_payments.setTransObject(SQLCA)
	
	dw_finresp.selectrow(0, false)
	dw_profit_center.selectrow(0, false)
	
	cbx_select_fr.checked 	= false
	cbx_select_fr.text 		= "Select all"
	cbx_select_fr.textcolor = c#color.White
	cbx_select_pc.checked 	= false
	cbx_select_pc.text 		= "Select all"
	cbx_select_pc.textcolor = c#color.White
end if

if this.checked then
	this.text = "Deselect all"
else
	this.text = "Select all"
end if

dw_vessel_list.selectrow(0, this.checked)

this.textcolor = c#color.White

wf_select_row(dw_vessel_list, "vessel_nr")
end event

type cbx_select_fr from checkbox within w_tc_payments
integer x = 558
integer y = 16
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Select all"
end type

event clicked;/********************************************************************
   w_tc_payments
   <OBJECT>		cbx_select_fr	</OBJECT>
   <USAGE>		click this can select all or deselect all</USAGE>
   <ALSO>		none			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	01/02/2012 M5-1         WWG004        First Version
   </HISTORY>
********************************************************************/
if dw_payments.dataObject <> "d_payments_finance_responsible" then
	dw_payments.dataObject = "d_payments_finance_responsible"
	dw_payments.settransobject(SQLCA)
	inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
	lnv_style.of_dwlistformater( dw_payments, false)
	dw_profit_center.selectrow(0, false)
	dw_vessel_list.selectrow(0, false)
	
	cbx_select_pc.checked 			= false
	cbx_select_pc.text 				= "Select all"
	cbx_select_pc.textcolor 		= c#color.White
	cbx_select_vessel.checked 		= false
	cbx_select_vessel.text 			= "Select all"
	cbx_select_vessel.textcolor	= c#color.White
end if

if this.checked then	
	this.text = "Deselect all"
else
	this.text = "Select all"
end if

dw_finresp.selectrow(0, this.checked)

this.textcolor = c#color.White

wf_select_row(dw_finresp, "vessels_vessel_fin_resp")
end event

type cb_unlock from commandbutton within w_tc_payments
integer x = 2487
integer y = 2376
integer width = 343
integer height = 100
integer taborder = 170
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "U&nlock"
end type

event clicked;string ls_invoice_nr, ls_errtext, ls_comment
long ll_payment_id, ll_row, ll_contract_id

ll_row = dw_payments.getrow()
if ll_row < 1 then return
ll_payment_id 	= dw_payments.getItemNumber(ll_row, "payment_id")
ls_invoice_nr = f_get_string("Enter AX Invoice Number", 32, "A", "", false)
if isnull(ls_invoice_nr) then return
ls_invoice_nr = trim(ls_invoice_nr)

UPDATE NTC_PAYMENT
SET INVOICE_NR = :ls_invoice_nr,
    LOCKED = 0
WHERE PAYMENT_ID = : ll_payment_id;
if sqlca.sqlcode <> 0 then
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messagebox("Update Error", ls_errtext, stopsign!)
	return
end if

//M5-4 Begin added by ZSW001 on 11/04/2012
if isnull(ls_invoice_nr) or ls_invoice_nr = "" then ls_invoice_nr = "Empty"
ll_contract_id = dw_payments.getitemnumber(ll_row, "contract_id")
ls_comment = "TC Payment (" + string(ll_payment_id) + ") unlocked manually by user with AX invoice number = " + ls_invoice_nr + "."

INSERT INTO NTC_TC_ACTION_LOG(USERID, CONTRACT_ID, ACTION_DATE, ACTION_COMMENT)
     VALUES (:uo_global.is_userid, :ll_contract_id, getdate(), :ls_comment);
if sqlca.sqlcode <> 0 then
	ls_errtext = sqlca.sqlerrtext
	rollback;
	messagebox("Update Error", ls_errtext, stopsign!)
	return
end if

COMMIT;
//M5-4 End added by ZSW001 on 11/04/2012

cb_refresh.triggerevent(clicked!)
if isvalid(w_tc_contract) then
	w_tc_contract.postevent("ue_refresh")
end if

setpointer(arrow!)

end event

