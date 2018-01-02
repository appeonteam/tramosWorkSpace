$PBExportHeader$w_commission.srw
$PBExportComments$Commission main window
forward
global type w_commission from mt_w_sheet
end type
type cbx_selecttc from checkbox within w_commission
end type
type cbx_showsettled from checkbox within w_commission
end type
type st_poolmanager from statictext within w_commission
end type
type cb_commission_vv from commandbutton within w_commission
end type
type dw_commission from uo_datawindow within w_commission
end type
type cb_delete from uo_securitybutton within w_commission
end type
type cb_credit from uo_securitybutton within w_commission
end type
type cb_new from uo_securitybutton within w_commission
end type
type dw_search_broker from uo_datawindow within w_commission
end type
type st_1 from statictext within w_commission
end type
type sle_1 from singlelineedit within w_commission
end type
type cb_search_broker from commandbutton within w_commission
end type
type cb_show_unsettled from commandbutton within w_commission
end type
type gb_1 from groupbox within w_commission
end type
type cb_settle from uo_securitybutton within w_commission
end type
type dw_tc_commission from uo_datawindow within w_commission
end type
end forward

global type w_commission from mt_w_sheet
integer width = 3625
integer height = 2592
string title = "Commission"
long backcolor = 81324524
string icon = "images\commission.ico"
cbx_selecttc cbx_selecttc
cbx_showsettled cbx_showsettled
st_poolmanager st_poolmanager
cb_commission_vv cb_commission_vv
dw_commission dw_commission
cb_delete cb_delete
cb_credit cb_credit
cb_new cb_new
dw_search_broker dw_search_broker
st_1 st_1
sle_1 sle_1
cb_search_broker cb_search_broker
cb_show_unsettled cb_show_unsettled
gb_1 gb_1
cb_settle cb_settle
dw_tc_commission dw_tc_commission
end type
global w_commission w_commission

type variables
Long il_broker_no
String is_filter, is_tcfilter
Integer	ii_poolmanager

end variables

forward prototypes
public subroutine retrieve_sub (ref datawindow pd_list)
public subroutine of_setfilter ()
public subroutine of_set_broker_no (long al_broker_no)
public function integer wf_check_balance (ref s_transaction_input astr_trans_input)
public subroutine retrieve_commission (long al_vessel_nr, string as_voyage_nr, string as_claimtype, integer ai_claim_nr, string as_invoice, decimal ad_amount)
public subroutine documentation ()
public function integer _set_permission (datawindow pd_list, long row)
end prototypes

public subroutine retrieve_sub (ref datawindow pd_list);
Long ll_mask, ll_count

pd_list.visible = true

If cbx_showsettled.checked  Then ll_mask = -1 Else ll_mask = 1

ll_count = pd_list.retrieve(il_broker_no,ll_mask, uo_global.is_userid )

// Enable/Disable buttons according to whether any data is found	

// Highlight selected row
      
If pd_list.GetRow () = 0 Then
	pd_list.SetRow ( 1 )  
	pd_list.SelectRow (0, False ) 
	pd_list.SelectRow (1, True )
End if

_set_permission(pd_list, pd_list.getSelectedRow(0))

end subroutine

public subroutine of_setfilter ();// nothing to do
return


end subroutine

public subroutine of_set_broker_no (long al_broker_no);il_broker_no = al_broker_no
end subroutine

public function integer wf_check_balance (ref s_transaction_input astr_trans_input);decimal {2}		ld_claim, ld_transaction, ld_balance
string			ls_message, ls_curr

SELECT ISNULL(CLAIM_AMOUNT,0), CURR_CODE
  INTO :ld_claim, :ls_curr
  FROM CLAIMS
 WHERE VESSEL_NR = :astr_trans_input.vessel_no
	AND VOYAGE_NR = :astr_trans_input.voyage_no
	AND CHART_NR = :astr_trans_input.charter_no
	AND CLAIM_NR = :astr_trans_input.claim_no ;

SELECT ISNULL(SUM(C_TRANS_AMOUNT),0)
  INTO :ld_transaction
  FROM CLAIM_TRANSACTION
 WHERE VESSEL_NR = :astr_trans_input.vessel_no
	AND VOYAGE_NR = :astr_trans_input.voyage_no
	AND CHART_NR = :astr_trans_input.charter_no
	AND CLAIM_NR = :astr_trans_input.claim_no ;

ld_balance = ld_claim - ld_transaction
if abs( ld_balance ) > 1 then
	if messagebox("Warning", "The corresponding claims is not yet settled. Do you wish to continue anyway?", question!, yesNo!, 2) = 2 then
		return -1
	end if
end if

return 1
end function

public subroutine retrieve_commission (long al_vessel_nr, string as_voyage_nr, string as_claimtype, integer ai_claim_nr, string as_invoice, decimal ad_amount);/************************************************************************************
Arthur Andersen PowerBuilder Development
Window  : w_commission
Function : retrieve_commission
Object     : 
Event	: 
Scope     : Local
************************************************************************************
Author    : Martin Israelsen
Date       : 1/1-96
Description : Retrieves commissions for a selected broker
Arguments : None
Returns   : None
Variables : None
Other	: None
*************************************************************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
01/01-96		1.0			MI			INITIAL VERSION
27/08-09		20.01			RMO003	Add localization of record after retrieve
01/02/11  	CR2264		JMC112	Set Pool comm. as read-only.
************************************************************************************/
string		ls_searchstring
long		ll_found


redraw_off(this)

// Check cbx_showsettled to find out, whether the user also wants settled commissions, and retrieve data

st_poolmanager.visible = False
if cbx_selecttc.checked then
	cb_new.visible = false
	cb_credit.visible = false
	cb_delete.visible = false
	cb_settle.visible = false
	dw_commission.visible = false
	retrieve_sub(dw_tc_commission)
Else
	cb_new.visible = true
	cb_credit.visible = true
	cb_delete.visible = true
	cb_settle.visible = true
	dw_tc_commission.visible = false
	retrieve_sub(dw_commission)
	dw_commission.Object.Datawindow.ReadOnly="no"
End if


If il_Broker_no > 0 Then

	// And update sle_1.text (broker_name) with selected broker

	If dw_search_broker.retrieve ( "", il_broker_no ) > 0 Then
		sle_1.Text = dw_search_broker.GetItemString ( 1, "BROKER_SN")
		ii_poolmanager = dw_search_broker.GetItemnumber( 1, "broker_pool_manager") 
		
		if ii_poolmanager = 1 then
	 		st_poolmanager.visible = True 
		end if
		
		/* localize record, only if vessel nr given */
		if al_vessel_nr > 0 then
			ls_searchstring = "commissions_vessel_nr="+string(al_vessel_nr)
			ls_searchstring += " and commissions_voyage_nr='"+as_voyage_nr+"'"
			ls_searchstring += " and commissions_claim_nr="+string(ai_claim_nr)
			ls_searchstring += " and claims_claim_type='"+as_claimtype+"'"
			ls_searchstring += " and commissions_invoice_nr='"+as_invoice+"'"
			ls_searchstring += " and commissions_comm_amount_local_curr="+string(ad_amount)
			ll_found = dw_commission.find(ls_searchstring, 1,9999999)
			if ll_found > 0 then
				dw_commission.Event Clicked(0,0, ll_found, dw_commission.Object)
				dw_commission.scrollToRow(ll_found)
			else
				dw_commission.Event Clicked(0,0, 1, dw_commission.Object)
				dw_commission.scrollToRow(1)
			end if
		end if
	End if
End if

redraw_on(this)
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_commission
   <OBJECT> Broker commissions	</OBJECT>
   <USAGE> Settle commissions
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	   CR-Ref	 Author	Comments
   xx/xx/xx	??	       ??	   First Version
   01/02/11	CR2264	JMC		Change of window inheritance, apply interface standards,
										create CODA transactions, post pool commissions
   04/02/11 CR2289  				Critical error fixed - settle a settled bro_comm, a new entry is created in transaction log.
   10/03/11	CR1549 	JMC		Read fix exchange rates
   30/01/12	CR2421 	JMC		Disable transactions. Only CODA Pool commission should be created.
   10/04/12	CR2421 	JMC		Enable CODA transactions for broker commission
   19/04/12	CR3202	WWA048	Change wording in the messagebox.
	22/07/16 CR4307   SSX014   Use Set Ex Rate
</HISTORY>    
********************************************************************/
end subroutine

public function integer _set_permission (datawindow pd_list, long row);/********************************************************************
   _set_permission
   <DESC>	
		 Only Finance advanced_users and Finance administrators should be able to
		 Create, Credit or Delete a commission (Commission window). 
		 Only users with Finance profile should be able to Settle a commission (Commission window). 
		 The same should be applied to TC Commissions for consistency.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		pd_list
		row
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		29/07/16 CR4307        Shawn   First Version
   </HISTORY>
********************************************************************/

string ls_column_settled, ls_column_amount

if isvalid(pd_list) and not isnull(pd_list) then
	choose case classname(pd_list)
		case "dw_commission"
			ls_column_settled = "COMMISSIONS_COMM_SETTLED"
			ls_column_amount = "COMMISSIONS_COMM_AMOUNT"
		case "dw_tc_commission"
			ls_column_settled = "TCCOMMISSION_TCCOMM_SETTLED"
			ls_column_amount = "TCCOMMISSION_TCCOMM_AMOUNT"
		case else
			return -1
	end choose
	
	if row <= 0 then row = pd_list.getSelectedRow(0)
end if

if uo_global.ii_user_profile = c#profile.FINANCE then
	if uo_global.ii_access_level = c#usergroup.#SUPERUSER or &
		uo_global.ii_access_level = c#usergroup.#ADMINISTRATOR then
		if isvalid(pd_list) and not isnull(pd_list) then
			if pd_list.RowCount() <= 0 or row <= 0 then
				cb_delete.enabled = false
				cb_credit.enabled = false
			else
				cb_delete.enabled = (pd_list.GetItemNumber( Row, ls_column_settled) = 0)
				cb_credit.enabled = ( (not pd_list.GetItemNumber( Row, ls_column_settled) = 0) and pd_list.GetItemNumber( Row, ls_column_amount) > 0)
			end if
		else
			cb_delete.enabled = false
			cb_credit.enabled = false
		end if
		cb_new.enabled = true
	else
		cb_delete.enabled = false
		cb_credit.enabled = false
		cb_new.enabled = false
	end if
	if isvalid(pd_list) and not isnull(pd_list) then
		if pd_list.RowCount() <= 0 or row <= 0 then
			cb_settle.enabled = false
		else
			cb_settle.enabled = (pd_list.GetItemNumber( Row, ls_column_settled) = 0)
		end if
	else
		cb_settle.enabled = false
	end if
else
	cb_delete.enabled = false
	cb_credit.enabled = false
	cb_new.enabled = false
	cb_settle.enabled = false
end if

return 0
end function

event open;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_commission
 Object     : 
 Event	 :  Open
 Scope     : Global/Local
 ************************************************************************************
 Author    : Martin Israelsen
 Date       : 1/1-96
 Description : Commissions main module
 Arguments : None
 Returns   : None
 Variables : None
 Other : None
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1-1-96		1.0 			MI		Initial version
  
************************************************************************************/


// Initialize SQLCA for datawindows

This.Move(5,5)

dw_commission.SetTransObject ( SQLCA )
dw_tc_commission.SetTransObject(SQLCA)
dw_search_broker.SetTransObject ( SQLCA )

post of_setfilter()

_set_permission(dw_commission, dw_commission.getSelectedRow(0))
end event

on w_commission.create
int iCurrent
call super::create
this.cbx_selecttc=create cbx_selecttc
this.cbx_showsettled=create cbx_showsettled
this.st_poolmanager=create st_poolmanager
this.cb_commission_vv=create cb_commission_vv
this.dw_commission=create dw_commission
this.cb_delete=create cb_delete
this.cb_credit=create cb_credit
this.cb_new=create cb_new
this.dw_search_broker=create dw_search_broker
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_search_broker=create cb_search_broker
this.cb_show_unsettled=create cb_show_unsettled
this.gb_1=create gb_1
this.cb_settle=create cb_settle
this.dw_tc_commission=create dw_tc_commission
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_selecttc
this.Control[iCurrent+2]=this.cbx_showsettled
this.Control[iCurrent+3]=this.st_poolmanager
this.Control[iCurrent+4]=this.cb_commission_vv
this.Control[iCurrent+5]=this.dw_commission
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_credit
this.Control[iCurrent+8]=this.cb_new
this.Control[iCurrent+9]=this.dw_search_broker
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.cb_search_broker
this.Control[iCurrent+13]=this.cb_show_unsettled
this.Control[iCurrent+14]=this.gb_1
this.Control[iCurrent+15]=this.cb_settle
this.Control[iCurrent+16]=this.dw_tc_commission
end on

on w_commission.destroy
call super::destroy
destroy(this.cbx_selecttc)
destroy(this.cbx_showsettled)
destroy(this.st_poolmanager)
destroy(this.cb_commission_vv)
destroy(this.dw_commission)
destroy(this.cb_delete)
destroy(this.cb_credit)
destroy(this.cb_new)
destroy(this.dw_search_broker)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_search_broker)
destroy(this.cb_show_unsettled)
destroy(this.gb_1)
destroy(this.cb_settle)
destroy(this.dw_tc_commission)
end on

event activate;If w_tramos_main.MenuName <> "m_tramosmain" Then 
	w_tramos_main.ChangeMenu(m_tramosmain)
End if

m_tramosmain.mf_setcalclink(False)
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_commission
end type

type cbx_selecttc from checkbox within w_commission
integer x = 1088
integer y = 252
integer width = 544
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "T/C-hire (read-only)"
end type

event clicked;retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used
end event

type cbx_showsettled from checkbox within w_commission
integer x = 1088
integer y = 356
integer width = 425
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Show settled"
boolean checked = true
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : cbx_showsettled
  
 Event	:  Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Selects between showing of unsettled or unsettled and settled commissions

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/

retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

end event

type st_poolmanager from statictext within w_commission
boolean visible = false
integer x = 1051
integer y = 128
integer width = 558
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Broker is pool manager."
boolean focusrectangle = false
end type

type cb_commission_vv from commandbutton within w_commission
integer x = 2542
integer y = 24
integer width = 1006
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "List C&ommissions by Vessel/Voyage"
end type

event clicked;open(w_commissions_vv)
end event

type dw_commission from uo_datawindow within w_commission
integer x = 23
integer y = 480
integer width = 3529
integer height = 1864
integer taborder = 60
string dataobject = "dw_commission_list"
boolean vscrollbar = true
end type

event itemchanged;call super::itemchanged;long	ll_calculationid, ll_chartid, ll_vesselnr, ll_rows
decimal	ld_rate, ld_fixrate
string	ls_currcode
n_exchangerate	lnv_exchangerate
mt_n_datastore 	lds_getfixrate
integer li_vessel_nr
string ls_voyage_nr
integer li_chart_nr
integer li_claim_nr
string ls_claim_type
long ll_cerp_id
n_claimcurrencyadjust lnv_claimcurrencyadjust

dw_commission.accepttext( )

if dwo.name = "commissions_comm_amount_local_curr" then
	ls_currcode = this.getitemstring( row, "claims_curr_code")
	if ls_currcode = "USD" then
		ld_rate = 100
	else
		
		li_vessel_nr = this.GetItemNumber(row, "commissions_vessel_nr")
		ls_voyage_nr = this.GetItemString(row, "commissions_voyage_nr")
		li_chart_nr = this.GetItemNumber(row, "commissions_chart_nr")
		li_claim_nr = this.GetItemNumber(row, "commissions_claim_nr")
		
		SELECT CAL_CERP_ID, CLAIM_TYPE
			INTO :ll_cerp_id, :ls_claim_type
		FROM CLAIMS
		WHERE VESSEL_NR = :li_vessel_nr
			AND VOYAGE_NR = :ls_voyage_nr
			AND CHART_NR = :li_chart_nr
			AND CLAIM_NR = :li_claim_nr;
	
		lnv_claimcurrencyadjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_currcode, ld_rate)
		
		if IsNull(ld_rate) then
			ld_rate = lnv_exchangerate.of_gettodaysusdrate( ls_currcode)
		end if
		
		if ld_rate <= 0 then
			ROLLBACK;
			this.post setItem(row, "commissions_comm_amount_local_curr", this.getItemNumber(row, "commissions_comm_amount_local_curr", primary!,true))
			Messagebox("Error","Is not possible to get the Exchange Rate for " + ls_currcode + " Currency. Please contact system administrator.")
			return
		end if
	end if

	this.setItem(row, "commissions_comm_amount", this.getitemnumber( row, "commissions_comm_amount_local_curr") * ld_rate/100)
end if

If dw_commission.update () = 1 Then
	COMMIT;
Else
	ROLLBACK;
	if dwo.name = "commissions_invoice_nr" then
		this.post setItem(row, "commissions_invoice_nr", this.getItemString(row, "commissions_invoice_nr", primary!,true))
	end if
End if
end event

event clicked;IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
	_set_permission(this, row)
END IF



end event

type cb_delete from uo_securitybutton within w_commission
integer x = 3223
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 100
boolean enabled = false
string text = "&Delete"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : cb_delete from uo_securitybutton
  
 Event	:  Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Delete - deletes a commission

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/
long	ll_row

dw_commission.accepttext( )
ll_row = dw_commission.getSelectedRow(0)
if ll_row < 1 then return

If MessageBox ( "Warning", "You are deleting an unsettled entry, continue ?", Exclamation!, YesNo! ) = 1 Then

	If cbx_selecttc.checked then
		dw_tc_commission.DeleteRow(0)
		If dw_tc_commission.Update() = 1 Then
			COMMIT;
		Else
			ROLLBACK;
		End if
	Else
		dw_commission.DeleteRow ( 0 )
		If dw_commission.update() = 1 Then
			COMMIT;
		Else
			ROLLBACK;
		End if 

	End if

	retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

End if
end event

type cb_credit from uo_securitybutton within w_commission
integer x = 2871
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 90
boolean enabled = false
string text = "C&redit"
end type

event clicked;call super::clicked;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_commission
 Object     : cb_credit from uo_securitybutton
 Event	:  Clicked
 Scope     : Local
 ************************************************************************************
 Author    : Martin Israelsen
 Date       : 1/1-96
 Description : Creates a credit-commission from the last selected commission
 Arguments : None
 Returns   : None
 Variables : None
Other	: None
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
************************************************************************************/

Double ld_amount, ld_amount_local
Integer li_vessel_no,li_chart_No
String ls_voyage_no,ls_invoice
Long ll_claim_no,ll_broker_no, ll_row 
DateTime ld_cp_date

ll_row =dw_commission.getSelectedRow(0)
if ll_row < 1 then return

// Ask the user, whether he really wants this

If MessageBox("Confirm", "You are about to create a credit-commission, continue ?", Question!, YesNo!) <> 1 Then
	ll_Row = 0   
End if

If ll_row > 0 Then

	// allright, create a credit-commission, with exactly the same data, except for the amout, which
	// will be minus amount.

	if cbx_selecttc.checked then
		li_vessel_no = dw_tc_commission.GetItemNumber(ll_row,"TCCOMMISSION_VESSEL_NR")
		ll_broker_no = dw_tc_commission.GetItemNumber(ll_row,"TCCOMMISSION_BROKER_NR")
		ld_cp_date = dw_tc_commission.GetItemDateTime(ll_row,"TCCOMMISSION_TCHIRE_CP_DATE")
		ls_invoice = dw_tc_commission.GetItemString(ll_row,"TCCOMMISSION_TCINVOICE_NR") + " CR"
		ld_amount = - dw_tc_commission.GetItemNumber(ll_row,"TCCOMMISSION_TCCOMM_AMOUNT")

		ll_row = dw_tc_commission.insertRow ( 0 )
		dw_tc_commission.ScrollToRow ( ll_Row )

		dw_tc_commission.SetItem(ll_row,"TCCOMMISSION_VESSEL_NR",li_vessel_no)
		dw_tc_commission.SetItem(ll_row,"TCCOMMISSION_BROKER_NR",ll_broker_no)
		dw_tc_commission.SetItem(ll_row,"TCCOMMISSION_TCHIRE_CP_DATE",ld_cp_date)
		dw_tc_commission.SetItem(ll_row,"TCCOMMISSION_TCINVOICE_NR",ls_invoice)
		dw_tc_commission.SetItem(ll_row,"TCCOMMISSION_TCCOMM_AMOUNT",ld_amount)
		dw_tc_commission.SetItem(ll_row,"TCCOMMISSION_TCCOMM_SETTLED",0)
	

		If dw_tc_commission.update() = 1 Then
			COMMIT;
		Else
			ROLLBACK;
		End if 
	Else
		li_vessel_no = dw_commission.GetItemNumber( ll_row,  "COMMISSIONS_VESSEL_NR" )
		ls_voyage_no = dw_commission.GetItemString( ll_row,  "COMMISSIONS_VOYAGE_NR" )
		li_chart_no = dw_commission.GetItemNumber( ll_row,  "COMMISSIONS_CHART_NR" )
		ll_claim_no = dw_commission.GetItemNumber( ll_row,  "COMMISSIONS_CLAIM_NR" )
		ll_broker_no = dw_commission.GetItemNumber( ll_row,  "COMMISSIONS_BROKER_NR" )
		ls_invoice =   "CR "+ dw_commission.GetItemString( ll_row,  "COMMISSIONS_INVOICE_NR" ) 
		ld_amount = - dw_commission.GetItemNumber( ll_row,  "COMMISSIONS_COMM_AMOUNT" )
		ld_amount_local = - dw_commission.GetItemNumber( ll_row,  "COMMISSIONS_COMM_AMOUNT_LOCAL_CURR" )

		ll_row = dw_commission.insertRow ( 0 )
		dw_commission.ScrollToRow ( ll_Row )

		dw_commission.SetItem( ll_Row, "COMMISSIONS_VESSEL_NR", li_vessel_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_VOYAGE_NR",ls_voyage_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_CHART_NR",li_chart_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_CLAIM_NR", ll_claim_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_BROKER_NR", ll_Broker_No )
		dw_commission.Setitem( ll_Row, "COMMISSIONS_INVOICE_NR", ls_invoice)
		dw_commission.SetItem( ll_Row, "COMMISSIONS_COMM_AMOUNT", ld_amount )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_COMM_AMOUNT_LOCAL_CURR", ld_amount_local )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_COMM_SETTLED", 0 )

		If dw_commission.update() = 1 Then
			COMMIT;
		Else
			ROLLBACK;
		End if 
	End if
End if

retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used



end event

type cb_new from uo_securitybutton within w_commission
integer x = 2519
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 80
string text = "&New"
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : cb_new from uo_securitybutton
  
 Event	:  Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : New - creates a new commission

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/

// Open w_select_claim for creation of a commission

s_create_commission ls_create_commission
Long  ll_Row

if dw_search_broker.rowcount( ) = 0  then return

if cbx_selecttc.checked then
	OpenWithParm(w_select_tc,il_broker_no)
	ls_create_commission = Message.PowerObjectParm
	
	// The commission is just returnes in an powerobject, now insert it into TC-commissions

	if ls_create_commission.i_vessel_no <> 0 Then
		ll_row = dw_tc_commission.InsertRow(0)
		dw_tc_commission.ScrollToRow(ll_row)

		dw_tc_commission.SetItem( ll_Row, "TCCOMMISSION_VESSEL_NR", ls_create_commission.i_vessel_no )
		dw_tc_commission.SetItem( ll_Row, "TCCOMMISSION_TCHIRE_CP_DATE", ls_create_commission.dt_cp_date )
		dw_tc_commission.SetItem( ll_Row, "TCCOMMISSION_TCCOMM_SET_OFF_DT", ls_create_commission.set_off_dt )
		dw_tc_commission.Setitem( ll_Row, "TCCOMMISSION_TCINVOICE_NR", ls_create_commission.s_invoice)
		dw_tc_commission.SetItem( ll_Row, "TCCOMMISSION_TCCOMM_AMOUNT", ls_create_commission.d_amount )
		dw_tc_commission.SetItem( ll_Row, "TCCOMMISSION_TCCOMM_SETTLED", 0 )
		dw_tc_commission.SetItem( ll_Row, "TCCOMMISSION_BROKER_NR", il_broker_no)

		If dw_tc_commission.update() = 1 Then
			COMMIT;
		Else
			ROLLBACK;
		End if 

		retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

	end if 
else
	Open(w_Select_Claim)

	ls_create_commission = Message.PowerObjectParm

	// The created commission is just returned in an powerobject, so now insert it into commissions.

	If ls_create_commission.i_vessel_no <> 0 Then

		ll_row = dw_commission.insertRow ( 0 )
		dw_commission.ScrollToRow ( ll_Row )
	
		dw_commission.SetItem( ll_Row, "COMMISSIONS_VESSEL_NR", ls_create_commission.i_vessel_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_VOYAGE_NR", ls_create_commission.s_voyage_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_CHART_NR", ls_create_commission.i_chart_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_CLAIM_NR", ls_create_commission.l_claim_no )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_BROKER_NR", il_Broker_No )
		dw_commission.Setitem( ll_Row, "COMMISSIONS_INVOICE_NR", ls_create_commission.s_invoice)
		dw_commission.SetItem( ll_Row, "COMMISSIONS_COMM_AMOUNT", ls_create_commission.d_amount )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_COMM_SETTLED", 0 )
		dw_commission.SetItem( ll_Row, "COMMISSIONS_comm_auto", "User def." )
		dw_commission.SetItem( ll_Row, "commissions_comm_amount_local_curr",  ls_create_commission.d_amount_local  )

		If dw_commission.update() = 1 Then
			COMMIT;
		Else
			ROLLBACK;
		End if 

		retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

	End if
End if


end event

type dw_search_broker from uo_datawindow within w_commission
integer x = 23
integer y = 112
integer width = 969
integer height = 336
integer taborder = 0
boolean enabled = false
string dataobject = "dw_brokers"
end type

type st_1 from statictext within w_commission
integer x = 23
integer y = 32
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Broker"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_commission
integer x = 210
integer y = 16
integer width = 681
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
end type

event modified;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : sle_1
  
 Event	:  Modified

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Selection of broker, from entered data

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/

Long ll_Count

// Retrieve from broker with the entered text. If found, then update with the selected broker

ll_count = dw_search_broker.retrieve (Upper(Text), 0 ) 
If ll_Count > 0 Then
	il_broker_no = dw_search_broker.GetItemNumber( 1, "BROKER_NR" )

	retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used


End if

end event

type cb_search_broker from commandbutton within w_commission
integer x = 901
integer y = 16
integer width = 91
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "?"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : cb_search_broker 
  
 Event	:  Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Clicked!

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/

// Open searchwindow for broker, and update commissions for that selected broker

Long ll_broker_no

ll_Broker_no = Integer( f_select_from_list ( "dw_broker_list", 2, "Shortname", 3, "Name",1, "Select" ,false ) )

If ll_broker_no <> 0 Then

    il_Broker_no = ll_Broker_no
   retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used


End if


end event

type cb_show_unsettled from commandbutton within w_commission
integer x = 1042
integer y = 16
integer width = 507
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "? &Brokers/unsettled"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : cb_show_unsettled 
  
 Event	:  Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Clicked!

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/

// Open window with unsettled brokers, and return one if selected

Long ll_return
String ls_tmp

if cbx_selecttc.checked then ls_tmp = "dw_tc_unsettled_brokers" else ls_tmp = "dw_unsettled_brokers"

OpenWithParm ( w_unsettled_brokers, ls_tmp )
ll_Return = Message.doubleParm

If Not (IsNull ( ll_Return ))  And ( ll_Return > 0 ) Then
	
	 il_broker_no = ll_return
	if cb_new.enabled then 	cb_settle.TriggerEvent(Clicked!) 
   	
	retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used

End if
end event

type gb_1 from groupbox within w_commission
integer x = 1042
integer y = 192
integer width = 613
integer height = 256
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

type cb_settle from uo_securitybutton within w_commission
integer x = 2167
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 70
boolean enabled = false
string text = "&Settle ..."
end type

event clicked;call super::clicked;Integer 									li_trans_ok, li_settle_ok
long										ll_row, ll_find, ll_commid
string										ls_find

s_transaction_input 					lstr_transaction_input 
u_broker									lnv_broker

u_transaction_commission_claim_coda lnv_trans_coda

dw_commission.acceptText()

ll_row = dw_commission.getSelectedRow(0)
if ll_row < 1 then return
if dw_commission.getItemNumber( ll_Row, "commissions_comm_settled") = 1 then return

lstr_transaction_input.coda_or_cms = FALSE // This is a CMS transaction
lstr_transaction_input.vessel_no = dw_commission.GetItemNumber(ll_Row,"commissions_vessel_nr")
lstr_transaction_input.voyage_no = dw_commission.GetItemString(ll_Row,"commissions_voyage_nr")
lstr_transaction_input.claim_no = dw_commission.GetItemNumber(ll_Row,"commissions_claim_nr")
lstr_transaction_input.charter_no = dw_commission.GetItemNumber(ll_Row,"commissions_chart_nr")
lstr_transaction_input.broker_no =dw_commission.GetItemNumber(ll_Row,"commissions_broker_nr")
lstr_transaction_input.comm_amount = dw_commission.GetItemNumber(ll_Row,"commissions_comm_amount")
lstr_transaction_input.amount_local = dw_commission.GetItemNumber(ll_Row,"commissions_comm_amount_local_curr")
lstr_transaction_input.disb_currency_code = dw_commission.GetItemString(ll_Row, "claims_curr_code")
if lstr_transaction_input.disb_currency_code = "USD" then
	lstr_transaction_input.amount_local  = lstr_transaction_input.comm_amount
end if


ll_commid = dw_commission.GetItemNumber(ll_Row,"commissions_comm_id")
lstr_transaction_input.comm_inv_no = dw_commission.GetItemString(ll_Row, "commissions_invoice_nr")
if  ii_poolmanager = 1 and left(upper(lstr_transaction_input.comm_inv_no),13)  = "DO NOT SETTLE" then
	lstr_transaction_input.comm_inv_no = "PoolComm" + string(ll_commid)
	dw_commission.SetItem( ll_row,  "commissions_invoice_nr", lstr_transaction_input.comm_inv_no )		
end if

setNull( lstr_transaction_input.tc_cp_date )

if wf_check_balance(lstr_transaction_input ) = -1 then return

//fixed CR2289 on 4/02/2011
//This below section is to avoid the users from being able to settle the same invoice number several times 
ls_find = "commissions_vessel_nr="+string(lstr_transaction_input.vessel_no)
ls_find += " and commissions_voyage_nr='"+lstr_transaction_input.voyage_no+"'"
ls_find += " and commissions_claim_nr="+string(lstr_transaction_input.claim_no)
ls_find += " and commissions_chart_nr="+string(lstr_transaction_input.charter_no)
ls_find += " and commissions_broker_nr="+string(lstr_transaction_input.broker_no)
ls_find += " and commissions_invoice_nr='"+lstr_transaction_input.comm_inv_no+"'"
ll_find = dw_commission.find( ls_find, 1, dw_commission.rowcount())
if ll_find <> dw_commission.rowcount() then
	if ll_find = ll_row then
		ll_find = dw_commission.find( ls_find, ll_row +1, dw_commission.rowcount())
		if ll_find > 0 then
			MessageBox("Validation Error","Seems that you are trying to settle the same invoive number several times")
			return
		end if
	elseif ll_find > 0 then
		MessageBox("Validation Error","Seems that you are trying to settle the same invoive number several times")
		return
	end if
end if
// section ends here !!

/* Check if broker is blocked by AX */
lnv_broker = create u_broker
lnv_broker.of_getbroker( lstr_transaction_input.broker_no )
if lnv_broker.of_blocked( ) then
	MessageBox("Blocked", "Broker is Blocked by AX and cannot be settled",StopSign!)
	destroy lnv_broker
	return
end if
destroy lnv_broker

li_settle_ok = Messagebox("Settle account", "Are you sure you want to settle ~n~nInvoice#: " + lstr_transaction_input.comm_inv_no + "~nAmount: " & 
+ string(lstr_transaction_input.amount_local , "#,###.00") + " " + lstr_transaction_input.disb_currency_code ,Exclamation!, OKCancel!)

IF li_settle_ok = 2 THEN return

commit;


lnv_trans_coda = CREATE u_transaction_commission_claim_coda //CODA
	
lstr_transaction_input.coda_or_cms = TRUE // This is a CODA transaction
	
li_trans_ok = lnv_trans_coda.of_generate_transaction(lstr_transaction_input) //Generate CODA transaction

If li_trans_ok  <> 1 THEN
	rollback;
	Destroy lnv_trans_coda
	
	MessageBox("Error","Transaction generation went wrong. No settle/update !")
	Return 
End if

	
//Update With settle markings if trans is ok.
dw_commission.SetItem( ll_Row, "commissions_comm_settled_date",Today () )
dw_commission.SetItem( ll_Row, "commissions_comm_auto", "Locked")
dw_commission.SetItem( ll_row,  "commissions_comm_settled",1 )		
	
// Update, close and exit
IF dw_commission.update() = 1 THEN
	COMMIT;
ELSE
	ROLLBACK;
	Destroy lnv_trans_coda
	Messagebox("Error","Update of commissions settle, settle date and in_log failed. &
					~r Please note key data, and contact Database Administrator")
	Return 
END IF     	
	
Destroy lnv_trans_coda

retrieve_commission  (-1, "", "", 0, "", 0)   //dummy parameters not used


end event

type dw_tc_commission from uo_datawindow within w_commission
integer x = 37
integer y = 480
integer width = 2651
integer height = 1856
integer taborder = 50
string dataobject = "dw_tc_commission_list"
boolean vscrollbar = true
end type

event clicked;call super::clicked;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_commission
 Object     : dw_tc_commission
 Event	:  Clicked
 Scope     : Local
 ************************************************************************************
 Author    : Martin Israelsen
 Date       : 1/1-96
 Description : Update available buttons from current row
 Arguments : None
 Returns   : None
 Variables : None
Other	: None
*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/
IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)

	_set_permission(this, row)
     
END IF



end event

on itemchanged;call uo_datawindow::itemchanged;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_commission
  
 Object     : dw_tc_commission
  
 Event	:  Itemchanged

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Update current row

 Arguments : None

 Returns   : None

 Variables : None

Other	: None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		INITIAL VERSION
  
************************************************************************************/


AcceptText ( )

If update () = 1Then
	COMMIT;
Else
	ROLLBACK;
End if
end on

