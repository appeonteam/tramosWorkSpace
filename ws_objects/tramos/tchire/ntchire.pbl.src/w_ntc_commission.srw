$PBExportHeader$w_ntc_commission.srw
$PBExportComments$T/C Hire Commission main window
forward
global type w_ntc_commission from mt_w_sheet
end type
type st_poolmanager from statictext within w_ntc_commission
end type
type cb_modify_voyage from commandbutton within w_ntc_commission
end type
type cb_new from commandbutton within w_ntc_commission
end type
type rb_2 from radiobutton within w_ntc_commission
end type
type rb_1 from radiobutton within w_ntc_commission
end type
type rb_all from radiobutton within w_ntc_commission
end type
type cb_commission_vv from commandbutton within w_ntc_commission
end type
type cb_settle from uo_securitybutton within w_ntc_commission
end type
type cb_credit from uo_securitybutton within w_ntc_commission
end type
type st_1 from statictext within w_ntc_commission
end type
type sle_1 from singlelineedit within w_ntc_commission
end type
type cb_search_broker from commandbutton within w_ntc_commission
end type
type cb_show_unsettled from commandbutton within w_ntc_commission
end type
type dw_tc_commission from uo_datawindow within w_ntc_commission
end type
type dw_search_broker from uo_datawindow within w_ntc_commission
end type
type gb_1 from groupbox within w_ntc_commission
end type
end forward

global type w_ntc_commission from mt_w_sheet
integer width = 3653
integer height = 2592
string title = "T/C Commission"
long backcolor = 80269524
string icon = "images\commission.ico"
st_poolmanager st_poolmanager
cb_modify_voyage cb_modify_voyage
cb_new cb_new
rb_2 rb_2
rb_1 rb_1
rb_all rb_all
cb_commission_vv cb_commission_vv
cb_settle cb_settle
cb_credit cb_credit
st_1 st_1
sle_1 sle_1
cb_search_broker cb_search_broker
cb_show_unsettled cb_show_unsettled
dw_tc_commission dw_tc_commission
dw_search_broker dw_search_broker
gb_1 gb_1
end type
global w_ntc_commission w_ntc_commission

type variables
Long 		il_broker_no
String 	is_filter
Integer	ii_poolmanager
end variables

forward prototypes
public subroutine of_set_broker_no (long al_broker_no)
public subroutine of_setfilter ()
public subroutine retrieve_commission (long al_paymentid)
public subroutine documentation ()
public function integer wf_check_balance (s_transaction_input astr_trans_input)
public function decimal wf_getexrateusd (long al_payment_id)
public function integer _set_permission (datawindow pd_list, long row)
end prototypes

public subroutine of_set_broker_no (long al_broker_no);il_broker_no = al_broker_no
end subroutine

public subroutine of_setfilter ();/// nothing to do here
return


end subroutine

public subroutine retrieve_commission (long al_paymentid);string ls_searchstring
long ll_found

redraw_off(this)

// Check cbx_showsettled to find out, whether the user also wants settled commissions, and retrieve data

dw_tc_commission.retrieve(il_broker_no, uo_global.is_userid )
commit;

st_poolmanager.visible = False

If il_Broker_no > 0 Then

	// And update sle_1.text (broker_name) with selected broker

	If dw_search_broker.retrieve ( "", il_broker_no ) > 0 Then
		sle_1.Text = dw_search_broker.GetItemString ( 1, "BROKER_SN")
		ii_poolmanager = dw_search_broker.GetItemnumber( 1, "broker_pool_manager") 
		if ii_poolmanager = 1 then
	 		st_poolmanager.visible = True 
		end if
		
		/* localize record, only if vessel nr given */
		if al_paymentid > 0 then
			ls_searchstring = "payment_id="+string(al_paymentid )
			ll_found = dw_tc_commission.find(ls_searchstring, 1,9999999)
			if ll_found > 0 then
				dw_tc_commission.Event Clicked(0,0, ll_found, dw_tc_commission.Object)
				dw_tc_commission.scrollToRow(ll_found)
			else
				dw_tc_commission.Event Clicked(0,0, 1, dw_tc_commission.Object)
				dw_tc_commission.scrollToRow(1)
			end if
		end if

	End if
End if

redraw_on(this)

_set_permission(dw_tc_commission, dw_tc_commission.getselectedrow(0))
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_ntc_commission
   <OBJECT> TC hire commissions	</OBJECT>
   <USAGE> Settle TC hire commissions
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
   xx/xx/xx	??	??	First Version
   01/02/11	CR2264	JMC112	Change of window inheritance, apply interface standards,
													create CODA transactions, Pool comm. are read-only.
  30/01/12	CR2421	JMC112	Disable transactions. Only CODA Pool Commissions should be generated.
  10/04/12	CR2421	JMC112	Activate transactions for broker commission	
  19/04/13	CR3202	WWA048	If the payment status is not Paid, a message will popup when settling the TC-commission.
  24/01/14	CR3202	ZSW001	Add function wf_getexrateusd().
  27/07/16  CR4307   SSX014   Add function _set_permission().
</HISTORY>    
********************************************************************/

end subroutine

public function integer wf_check_balance (s_transaction_input astr_trans_input);/********************************************************************
   wf_check_balance
   <DESC> If the payment status is not Paid, a message will popup when settling the TC-commission. </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_trans_input
   </ARGS>
   <USAGE> Trigger this function when clicking Settle in TC-commission. </USAGE>
   <HISTORY>
   	Date       	CR-Ref    Author       Comments
   	19/04/2013 	CR3202    WWA048       First Version
   </HISTORY>
********************************************************************/

long ll_count

SELECT COUNT(*)
  INTO :ll_count
  FROM NTC_PAYMENT
 WHERE NTC_PAYMENT.PAYMENT_ID = :astr_trans_input.payment_id AND
		 NTC_PAYMENT.PAYMENT_STATUS < 5;

if ll_count > 0 then
	if MessageBox("Warning", "The corresponding hire is not yet settled. Do you wish to continue anyway?", question!, yesNo!, 2) = 2 then
		return c#return.Failure
	end if
end if

return c#return.Success
end function

public function decimal wf_getexrateusd (long al_payment_id);/********************************************************************
   wf_getexrateusd
   <DESC>	Get the exrate for special payment.	</DESC>
   <RETURN>	decimal	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_payment_id
   </ARGS>
   <USAGE>	Suggest to use in the event of 'Settle' button	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	23/01/2014   CR3202       ZSW001       First Version
   </HISTORY>
********************************************************************/

string	ls_curr_code
dec{6}	ld_payment_exrate, ld_exrate_dkk, ld_exrate_usd

SELECT NTC_TC_CONTRACT.CURR_CODE
  INTO :ls_curr_code
  FROM NTC_PAYMENT, NTC_TC_CONTRACT
 WHERE NTC_PAYMENT.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID AND
       NTC_PAYMENT.PAYMENT_ID = :al_payment_id;

if ls_curr_code = "USD" then
	ld_payment_exrate = 100
else
	  SELECT TOP 1 EXRATE_DKK
	    INTO :ld_exrate_dkk
	    FROM NTC_EXCHANGE_RATE
	   WHERE CURR_CODE = :ls_curr_code
	ORDER BY RATE_DATE DESC;

	  SELECT TOP 1 EXRATE_DKK
	    INTO :ld_exrate_usd
	    FROM NTC_EXCHANGE_RATE
	   WHERE CURR_CODE = 'USD'
	ORDER BY RATE_DATE DESC;

	ld_payment_exrate = ld_exrate_dkk * 100 / ld_exrate_usd
end if

return ld_payment_exrate

end function

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

if isvalid(pd_list) and not isnull(pd_list) then
	if row <= 0 then row = pd_list.GetSelectedRow(0)
end if

if uo_global.ii_user_profile = c#profile.FINANCE then
	if uo_global.ii_access_level = c#usergroup.#SUPERUSER or &
		uo_global.ii_access_level = c#usergroup.#ADMINISTRATOR then
		if isvalid(pd_list) and not isnull(pd_list) then
			if pd_list.RowCount() <= 0 then
				cb_credit.enabled = false
			else
				if row <= 0 then
					cb_credit.enabled = false
				else
					cb_credit.enabled = NOT isNull(pd_list.GetItemDatetime( Row, "settle_date") )
				end if
			end if
		else
			cb_credit.enabled = false
		end if
		cb_new.enabled = true
	else
		cb_credit.enabled = false
		cb_new.enabled = false
	end if
	if isvalid(pd_list) and not isnull(pd_list) then
		if pd_list.RowCount() <= 0 then
			cb_settle.enabled = false
		else
			if row <= 0 then
				cb_settle.enabled = false
			else
				cb_settle.enabled = IsNull(pd_list.GetItemDatetime( Row, "settle_date"))
			end if
		end if
	else
		cb_settle.enabled = false
	end if
else
	cb_credit.enabled = false
	cb_new.enabled = false
	cb_settle.enabled = false
end if

return 0
end function

event open;This.Move(0,0)

dw_tc_commission.SetTransObject(SQLCA)
dw_search_broker.SetTransObject ( SQLCA )

/* Only Administrator */
if uo_global.ii_access_level = 3 then
	cb_modify_voyage.visible = true
	cb_modify_voyage.enabled=true
else
	cb_modify_voyage.visible = false
	cb_modify_voyage.enabled=false
end if

this.of_setfilter()

_set_permission(dw_tc_commission, dw_tc_commission.getselectedrow(0))

end event

on w_ntc_commission.create
int iCurrent
call super::create
this.st_poolmanager=create st_poolmanager
this.cb_modify_voyage=create cb_modify_voyage
this.cb_new=create cb_new
this.rb_2=create rb_2
this.rb_1=create rb_1
this.rb_all=create rb_all
this.cb_commission_vv=create cb_commission_vv
this.cb_settle=create cb_settle
this.cb_credit=create cb_credit
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_search_broker=create cb_search_broker
this.cb_show_unsettled=create cb_show_unsettled
this.dw_tc_commission=create dw_tc_commission
this.dw_search_broker=create dw_search_broker
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_poolmanager
this.Control[iCurrent+2]=this.cb_modify_voyage
this.Control[iCurrent+3]=this.cb_new
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.cb_commission_vv
this.Control[iCurrent+8]=this.cb_settle
this.Control[iCurrent+9]=this.cb_credit
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_1
this.Control[iCurrent+12]=this.cb_search_broker
this.Control[iCurrent+13]=this.cb_show_unsettled
this.Control[iCurrent+14]=this.dw_tc_commission
this.Control[iCurrent+15]=this.dw_search_broker
this.Control[iCurrent+16]=this.gb_1
end on

on w_ntc_commission.destroy
call super::destroy
destroy(this.st_poolmanager)
destroy(this.cb_modify_voyage)
destroy(this.cb_new)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.rb_all)
destroy(this.cb_commission_vv)
destroy(this.cb_settle)
destroy(this.cb_credit)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_search_broker)
destroy(this.cb_show_unsettled)
destroy(this.dw_tc_commission)
destroy(this.dw_search_broker)
destroy(this.gb_1)
end on

event activate;If w_tramos_main.MenuName <> "m_tcmain" Then 
	w_tramos_main.ChangeMenu(m_tcmain)
End if
end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_ntc_commission
end type

type st_poolmanager from statictext within w_ntc_commission
boolean visible = false
integer x = 1051
integer y = 116
integer width = 558
integer height = 68
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

type cb_modify_voyage from commandbutton within w_ntc_commission
integer x = 23
integer y = 2368
integer width = 494
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Modify voyage #"
end type

event clicked;long										ll_row
String 									ls_voyage_nr

dw_tc_commission.acceptText()

ll_row = dw_tc_commission.getSelectedRow(0)
if ll_row < 1 then return

Open(w_change_comm_voyagenr)

ls_voyage_nr = Message.StringParm
IF ls_voyage_nr = "0" THEN Return 

dw_tc_commission.SetItem( ll_Row, "voyage_nr", ls_voyage_nr)

// Update, close and exit
IF dw_tc_commission.update() = 1 THEN
	COMMIT;
ELSE
	Messagebox("Error","Update of commissions failed. &
					~r Please note key data, and contact Database Administrator")
	ROLLBACK;
	Return 
END IF     	


end event

type cb_new from commandbutton within w_ntc_commission
integer x = 2898
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&New"
end type

event clicked;n_manual_tc_commission	lnv_tccomm
long							ll_broker_nr
long							ll_commID
long							ll_found

if dw_search_broker.rowCount() < 1 then return

setNull(ll_broker_nr)
ll_broker_nr = dw_search_broker.getItemNumber(1, "broker_nr")
if isNull(ll_broker_nr) then return 

lnv_tccomm = create n_manual_tc_commission
ll_commID = lnv_tccomm.of_createCommission(ll_broker_nr)
destroy lnv_tccomm

if ll_commID < 1 then return 

dw_tc_commission.retrieve(ll_broker_nr, uo_global.is_userid )

ll_found = dw_tc_commission.find("ntc_commission_ntc_comm_id="+string(ll_commID),1,99999)
if ll_found < 1 then return

dw_tc_commission.post setColumn("amount")
dw_tc_commission.post setFocus()
dw_tc_commission.post scrollToRow(ll_found)
dw_tc_commission.post selectRow(0, false)
dw_tc_commission.post selectRow(ll_found, true)




end event

type rb_2 from radiobutton within w_ntc_commission
integer x = 1650
integer y = 352
integer width = 274
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Settled"
end type

event clicked;dw_tc_commission.SetFilter("NOT(IsNull(settle_date))")
dw_tc_commission.Filter()
end event

type rb_1 from radiobutton within w_ntc_commission
integer x = 1321
integer y = 352
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Unsettled"
end type

event clicked;dw_tc_commission.SetFilter("IsNull(settle_date)")
dw_tc_commission.Filter()

end event

type rb_all from radiobutton within w_ntc_commission
integer x = 1088
integer y = 352
integer width = 187
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "All"
boolean checked = true
end type

event clicked;dw_tc_commission.SetFilter("")
dw_tc_commission.Filter()
end event

type cb_commission_vv from commandbutton within w_ntc_commission
integer x = 2583
integer y = 24
integer width = 1006
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "List C&ommissions by Vessel/TC Contract"
end type

event clicked;open(w_commissions_tc)
end event

type cb_settle from uo_securitybutton within w_ntc_commission
integer x = 2546
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 60
integer weight = 700
boolean enabled = false
string text = "&Settle ..."
end type

event clicked;call super::clicked;Integer 									li_trans_ok, li_settle_ok
long										ll_row, ll_commid
String 									ls_voyage_nr
decimal									ld_exrate_usd
u_broker									lnv_broker
u_transaction_commission_claim_coda 	lnv_trans_coda
s_transaction_input 					lstr_transaction_input 

dw_tc_commission.acceptText()

ll_row = dw_tc_commission.getSelectedRow(0)
if ll_row < 1 then return

if NOT isNull(dw_tc_commission.getItemDatetime( ll_Row, "settle_date")) then return

lstr_transaction_input.coda_or_cms = FALSE // This is a CMS transaction
lstr_transaction_input.vessel_no = dw_tc_commission.GetItemNumber(ll_Row,"vessel_nr")
lstr_transaction_input.broker_no = dw_tc_commission.GetItemNumber(ll_Row,"broker_nr")

lstr_transaction_input.payment_id = dw_tc_commission.getitemnumber(ll_row, "payment_id")

ld_exrate_usd = dw_tc_commission.getitemnumber(ll_row, "ntc_payment_ex_rate_usd")
if isnull(ld_exrate_usd) then ld_exrate_usd = wf_getexrateusd(lstr_transaction_input.payment_id)

lstr_transaction_input.amount_local = dw_tc_commission.GetItemNumber(ll_Row,"amount")
lstr_transaction_input.comm_amount = dw_tc_commission.GetItemNumber(ll_Row,"amount") * ld_exrate_usd/100

lstr_transaction_input.tc_cp_date = dw_tc_commission.GetItemDatetime(ll_Row,"cp_date")
lstr_transaction_input.disb_currency_code = dw_tc_commission.GetItemString(ll_Row,"curr_code")
lstr_transaction_input.ex_rate_to_dkk = ld_exrate_usd

lstr_transaction_input.voyage_no = dw_tc_commission.GetItemString(ll_Row,"voyage_nr")
lstr_transaction_input.payment_start = dw_tc_commission.GetItemDatetime(ll_Row,"period_start")
lstr_transaction_input.payment_end = dw_tc_commission.GetItemDatetime(ll_Row,"period_end")

ll_commid = dw_tc_commission.GetItemNumber(ll_Row,"ntc_commission_ntc_comm_id")
lstr_transaction_input.comm_inv_no = dw_tc_commission.GetItemString(ll_Row, "inv_nr")
if  ii_poolmanager = 1 and left(upper(lstr_transaction_input.comm_inv_no),13)  = "DO NOT SETTLE" then
	lstr_transaction_input.comm_inv_no = "TC Pool commission " + string(ll_commid)
	dw_tc_commission.SetItem( ll_row,  "inv_nr", lstr_transaction_input.comm_inv_no )		
end if

if wf_check_balance(lstr_transaction_input) = c#return.Failure then
	return
end if

/* Check if broker is blocked by AX */
lnv_broker = create u_broker
lnv_broker.of_getbroker( lstr_transaction_input.broker_no )
if lnv_broker.of_blocked( ) then
	MessageBox("Error", "Broker is Blocked by AX and cannot be settled",StopSign!)
	destroy lnv_broker
	return
end if
destroy lnv_broker

li_settle_ok = Messagebox("Settle account", "Are you sure you want to settle ~n~nInvoice#: " + lstr_transaction_input.comm_inv_no + "~nAmount: " & 
+ string(lstr_transaction_input.comm_amount, "#,###.00") + "~nPeriode: " + string(lstr_transaction_input.payment_start,"DD/MM-YY") + " - " + & 
string(lstr_transaction_input.payment_end,"DD/MM-YY"),Exclamation!, OKCancel!)

IF li_settle_ok = 1 THEN

	if isNull(lstr_transaction_input.voyage_no) or lstr_transaction_input.voyage_no = "" then
		OpenWithParm(w_enter_voyage,lstr_transaction_input.vessel_no)
		ls_voyage_nr = Message.StringParm
		IF ls_voyage_nr = "0" THEN Return 
		lstr_transaction_input.voyage_no = ls_voyage_nr
		dw_tc_commission.SetItem( ll_Row, "voyage_nr", ls_voyage_nr)
	end if
	
	commit;
	
	//if ii_poolmanager = 1 then
	
		//Create CODA transaction for pool or non pool
		lnv_trans_coda = CREATE u_transaction_commission_claim_coda //CODA
					
		lstr_transaction_input.coda_or_cms = TRUE // This is a CODA transaction
		
		li_trans_ok = lnv_trans_coda.of_generate_transaction(lstr_transaction_input) //Generate CODA transaction
		
		If li_trans_ok  <> 1 THEN
			rollback;
			Destroy lnv_trans_coda
			Destroy	n_ds
			MessageBox("Error","Transaction generation went wrong. No settle/update !")
			Return 
		End if
		
	//end if
	
	//Update With settle markings if trans is ok.
	dw_tc_commission.SetItem( ll_Row, "settle_date",Today () )
		
	// Update, close and exit
	IF dw_tc_commission.update() = 1 THEN
		commit;
	ELSE
		
		rollback;
		Destroy lnv_trans_coda
		Destroy	n_ds
		Messagebox("Error","Update of commissions settle, settle date and in_log failed. &
						~r Please note key data, and contact Database Administrator")
		Return 
	END IF     	
	
	Destroy lnv_trans_coda
	Destroy	n_ds
	
	retrieve_commission (0)  //dummy payment id
END IF
end event

type cb_credit from uo_securitybutton within w_ntc_commission
integer x = 3250
integer y = 2368
integer width = 343
integer height = 100
integer taborder = 80
string text = "C&redit"
end type

event clicked;call super::clicked;decimal 	ld_amount
String 	ls_invoice, ls_voyage_nr
Long  	ll_row, ll_null;setNull(ll_null) 
datetime	ldt_null;setNull(ldt_null)
integer	li_trans_ok
u_transaction_commission_claim_coda lnv_trans_coda
s_transaction_input						lstr_transaction_input 

ll_row =dw_tc_commission.getSelectedRow(0)

if ll_row < 1 then 
	MessageBox("Select Error", "Please select a TC Commission before Credit!")
	return
end if

If ll_row > 0 Then
	// allright, create a credit-commission, with exactly the same data, except for the amount, which
	// will be minus amount.
	ld_amount	= dw_tc_commission.getItemDecimal(ll_row, "amount") * -1
	ls_invoice	= dw_tc_commission.getItemString(ll_row, "inv_nr") + " CR"

	// Ask the user, whether he really wants this
	If MessageBox("Credit Account", "Are you sure you want to Credit ~n~nInvoice#: " + ls_invoice + "~nAmount: " & 
	+ string(ld_amount, "#,###.00") ,Exclamation!, OKCancel!,2) = 2 then return

	dw_tc_commission.RowsCopy(ll_row, ll_row, Primary!, dw_tc_commission , ll_row, Primary!)
	dw_tc_commission.RowsCopy(ll_row, ll_row, Primary!, dw_tc_commission , ll_row, Primary!)

	dw_tc_commission.setItem(ll_row, "amount", ld_amount)
	dw_tc_commission.setItem(ll_row, "inv_nr", ls_invoice)
	dw_tc_commission.setItem(ll_row, "ntc_commission_ntc_comm_id", ll_null)
	dw_tc_commission.setItem(ll_row, "settle_date", today())
	
	dw_tc_commission.setItem(ll_row +1, "inv_nr", "do not settle")
	dw_tc_commission.setItem(ll_row +1, "ntc_commission_ntc_comm_id", ll_null)
	dw_tc_commission.setItem(ll_row +1, "settle_date", ldt_null )
	
	lstr_transaction_input.coda_or_cms = FALSE // This is a CMS transaction
	lstr_transaction_input.vessel_no = dw_tc_commission.GetItemNumber(ll_Row,"vessel_nr")
	lstr_transaction_input.broker_no = dw_tc_commission.GetItemNumber(ll_Row,"broker_nr")
	lstr_transaction_input.comm_inv_no = dw_tc_commission.GetItemString(ll_Row, "inv_nr")
	
	lstr_transaction_input.amount_local = dw_tc_commission.GetItemNumber(ll_Row,"amount")
	lstr_transaction_input.comm_amount = dw_tc_commission.GetItemNumber(ll_Row,"amount") * dw_tc_commission.GetItemNumber(ll_Row,"ntc_payment_ex_rate_usd")/100 
		
	lstr_transaction_input.tc_cp_date = dw_tc_commission.GetItemDatetime(ll_Row,"cp_date")
	lstr_transaction_input.disb_currency_code = dw_tc_commission.GetItemString(ll_Row,"curr_code")
	lstr_transaction_input.voyage_no = dw_tc_commission.GetItemString(ll_Row,"voyage_nr")
	lstr_transaction_input.payment_start = dw_tc_commission.GetItemDatetime(ll_Row,"period_start")
	lstr_transaction_input.payment_end = dw_tc_commission.GetItemDatetime(ll_Row,"period_end")
	lstr_transaction_input.payment_id = dw_tc_commission.GetItemNumber(ll_Row,"payment_id")

	if isNull(lstr_transaction_input.voyage_no) or lstr_transaction_input.voyage_no = "" then
		OpenWithParm(w_enter_voyage,lstr_transaction_input.vessel_no)
		ls_voyage_nr = Message.StringParm
		IF ls_voyage_nr = "0" THEN Return 
		lstr_transaction_input.voyage_no = ls_voyage_nr
		dw_tc_commission.SetItem( ll_Row, "voyage_nr", ls_voyage_nr)
	end if
	
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
	dw_tc_commission.SetItem( ll_Row, "settle_date",Today () )
	
	If dw_tc_commission.update() = 1 Then
		commit;
	Else
		
		ROLLBACK;
		Destroy lnv_trans_coda
		Messagebox("Error","Update of commissions settle, settle date and in_log failed. &
					~r Please note key data, and contact Database Administrator") //this message was not
		return	
	End if 
end if

Destroy lnv_trans_coda
		
retrieve_commission (0)  //dummy payment id


end event

type st_1 from statictext within w_ntc_commission
integer x = 23
integer y = 32
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean enabled = false
string text = "Broker"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ntc_commission
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

event modified;Long ll_Count

// Retrieve from broker with the entered text. If found, then update with the selected broker

ll_count = dw_search_broker.retrieve (Upper(Text), 0 ) 
If ll_Count > 0 Then
	il_broker_no = dw_search_broker.GetItemNumber( 1, "BROKER_NR" )

	retrieve_commission (0)  //dummy payment id

End if

end event

type cb_search_broker from commandbutton within w_ntc_commission
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
    retrieve_commission (0)  //dummy payment id


End if


end event

type cb_show_unsettled from commandbutton within w_ntc_commission
integer x = 1042
integer y = 16
integer width = 507
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "? &Brokers/unsettled"
end type

event clicked;
// Open window with unsettled brokers, and return one if selected

Long ll_return
String ls_tmp

ls_tmp = "dw_new_tc_unsettled_brokers" 

OpenWithParm ( w_unsettled_brokers, ls_tmp )
ll_Return = Message.doubleParm

If Not (IsNull ( ll_Return ))  And ( ll_Return > 0 ) Then
	
	 il_broker_no = ll_return
   	
	retrieve_commission (0)  //dummy payment id

End if
end event

type dw_tc_commission from uo_datawindow within w_ntc_commission
integer x = 23
integer y = 480
integer width = 3566
integer height = 1864
integer taborder = 100
string dataobject = "d_ntc_commission"
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row > 0 THEN
	SelectRow(0,FALSE)
	SetRow(row)
	SelectRow(row,TRUE)
	_set_permission(this, row)
END IF

end event

event itemchanged;call super::itemchanged;AcceptText ( )

If update () = 1 Then
	COMMIT;
Else
	ROLLBACK;
End if
end event

type dw_search_broker from uo_datawindow within w_ntc_commission
integer x = 23
integer y = 112
integer width = 969
integer height = 336
integer taborder = 0
boolean enabled = false
string dataobject = "dw_brokers"
end type

type gb_1 from groupbox within w_ntc_commission
integer x = 1047
integer y = 300
integer width = 905
integer height = 144
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter"
end type

