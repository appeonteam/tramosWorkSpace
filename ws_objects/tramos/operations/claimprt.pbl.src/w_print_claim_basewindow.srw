$PBExportHeader$w_print_claim_basewindow.srw
$PBExportComments$Print base window claim invoices using OLE for Word
forward
global type w_print_claim_basewindow from mt_w_response
end type
type dw_claim_sent from mt_u_datawindow within w_print_claim_basewindow
end type
type cbx_print from checkbox within w_print_claim_basewindow
end type
type cbx_office from checkbox within w_print_claim_basewindow
end type
type cbx_alt_adress from checkbox within w_print_claim_basewindow
end type
type st_9 from statictext within w_print_claim_basewindow
end type
type st_7 from statictext within w_print_claim_basewindow
end type
type dw_brokers from u_datagrid within w_print_claim_basewindow
end type
type cbx_charterer from checkbox within w_print_claim_basewindow
end type
type cbx_broker from checkbox within w_print_claim_basewindow
end type
type cb_print from commandbutton within w_print_claim_basewindow
end type
type cb_close from commandbutton within w_print_claim_basewindow
end type
type dw_chart from u_datagrid within w_print_claim_basewindow
end type
type dw_duedate from mt_u_datawindow within w_print_claim_basewindow
end type
type st_charterer from mt_u_statictext within w_print_claim_basewindow
end type
type cbx_sendax from checkbox within w_print_claim_basewindow
end type
type dw_paymentcurr from u_datawindow_sqlca within w_print_claim_basewindow
end type
type p_infoax from picture within w_print_claim_basewindow
end type
type dw_info from u_popupdw within w_print_claim_basewindow
end type
end forward

global type w_print_claim_basewindow from mt_w_response
integer x = 27
integer y = 56
integer width = 2482
integer height = 1592
string title = "Print deviation / heating"
long backcolor = 79741120
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve pbm_custom01
event ue_print ( )
dw_claim_sent dw_claim_sent
cbx_print cbx_print
cbx_office cbx_office
cbx_alt_adress cbx_alt_adress
st_9 st_9
st_7 st_7
dw_brokers dw_brokers
cbx_charterer cbx_charterer
cbx_broker cbx_broker
cb_print cb_print
cb_close cb_close
dw_chart dw_chart
dw_duedate dw_duedate
st_charterer st_charterer
cbx_sendax cbx_sendax
dw_paymentcurr dw_paymentcurr
p_infoax p_infoax
dw_info dw_info
end type
global w_print_claim_basewindow w_print_claim_basewindow

type variables
s_vessel_voyage_chart_claim 	istr_parm
s_transaction_input    istr_transaction_input 

string 	is_amount_usd, is_amount_local //used on setting forwarding date
string	is_currcode
datetime	idt_cpdate
integer 	ii_broker_nr
integer  ii_office_nr
integer  ii_vessel_pc_nr
string   is_profitcenter_name
string is_templateprefix 
string is_bankaccount_curr   
string is_userfullname
string is_vesselname
string is_chartfullname
string is_invoice
string is_axfreetext
boolean	ib_issenttoax
string	is_restrict_curr, is_default_curr
long  	il_contract_id, il_last_rst_payment
end variables

forward prototypes
public subroutine wf_insert_field (string bookmark, string name, ref oleobject ole_object, ref oleobject ole_bookmark)
public subroutine documentation ()
public subroutine wf_print (integer ai_broker_charterer_office)
public subroutine wf_set_forwarding_date ()
public function integer wf_get_template (ref oleobject ole_object, ref oleobject ole_bookmark)
public subroutine wf_send_to_ax ()
public function long wf_get_invoice (decimal ad_payment_amount)
public function long wf_print_dem ()
public function long wf_print_dev_hea ()
public function long wf_print_freight ()
public function long wf_print_misc ()
public subroutine wf_enable_adj_reason (boolean ab_enable)
public function integer wf_fill_claim_sent ()
public subroutine wf_enable_duedate (boolean ab_enable)
public subroutine wf_set_duedate (string as_claimtype)
public subroutine wf_disble_print ()
public subroutine wf_disble_print (boolean ab_disbleprint)
public function integer wf_enable_paymentcurr ()
public function integer wf_set_sanctioninfo (decimal ad_invoice_amount)
public function decimal wf_get_rst_exrate (string as_payment_curr, date adate_exrate_date)
end prototypes

event ue_print();long		ll_return, ll_row, ll_chart_nr_printed
string	ls_errtext, ls_column

if cbx_sendax.checked = false and cbx_print.checked = false then
	messagebox("Warning", "Select one of the options 'Send invoice data to AX' and/or 'Print supporting documents'", stopsign!)
	return
end if

if dw_claim_sent.visible and cbx_sendax.checked and ib_issenttoax then
	ll_row = dw_claim_sent.getrow()
	if ll_row > 0 then
		if isnull(dw_claim_sent.getitemnumber(ll_row, "adj_type_id")) then
			ls_column = "adj_type_id"
		elseif isnull(dw_claim_sent.getitemnumber(ll_row, "adj_subtype_id")) then
			ls_column = "adj_subtype_id"
		end if
		
		if len(ls_column) > 0 then
			dw_claim_sent.setcolumn(ls_column)
			dw_claim_sent.post setfocus()
			messagebox("Validation error", "Please select an adjustment reason.")
			return
		end if
	end if
end if

if uo_global.gs_template_path = "" then
	messagebox("Missing File Path in System Options", "You have not inserted details in 'System Options' the field 'File Path to MS Word templates'", stopsign!)
	return
end if

if is_bankaccount_curr <> "" and is_currcode <> is_bankaccount_curr then
	if messagebox("Warning", "Bank Account currency (" + is_bankaccount_curr + ") is different from Claim currency (" + is_currcode + ").~n~nDo you want to continue? ", question!, yesno!) = 2 then
		return
	end if
end if

setpointer(hourglass!)

choose case istr_parm.claim_type
	case 'DEM','DES'
		ll_return = wf_print_dem()
	case 'HEA','DEV'
		ll_return = wf_print_dev_hea()
	case 'FRT'
		ll_return = wf_print_freight()
	case else
		ll_return = wf_print_misc()
end choose 

if ll_return = c#return.Success then
	ll_row = dw_chart.getselectedrow(0)
	if ll_row > 0 then
	ll_chart_nr_printed = dw_chart.getitemnumber(ll_row, "chart_chart_nr")
		//Remember the last printed charterer.
		UPDATE CLAIMS
			SET CHART_NR_PRINTED = :ll_chart_nr_printed
		 WHERE CHART_NR  = :istr_parm.chart_nr
			AND VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND CLAIM_NR  = :istr_parm.claim_nr;
		
		if sqlca.sqlcode <> 0 then
			ls_errtext = sqlca.sqlerrtext
			ROLLBACK;
			messagebox("Error", ls_errtext, stopsign!)
		else
			COMMIT;
		end if
	end if
	
	if cbx_sendax.checked and dw_paymentcurr.visible then
		if dw_paymentcurr.update() = 1 then
			if not isnull(il_contract_id) and il_contract_id > 1 then
				update NTC_TC_CONTRACT
					set LAST_RESTRICTED_PAYMENT = :il_last_rst_payment,
						 RESTRICT_CURR = :is_restrict_curr,
						 RST_DEFAULT_CURR = :is_default_curr
				 where CONTRACT_ID = :il_contract_id;
				 
				 if sqlca.sqlcode <> 0 then
					ROLLBACK;
					messagebox("Warning", "Send data to AX successful, but update sanction info failed.", Exclamation!)
				else
					COMMIT;
				end if
			else
				COMMIT;
			end if
		else
			ROLLBACK;
			messagebox("Warning", "Send data to AX successful, but update sanction info failed.", Exclamation!)
		end if
	end if
	
	close(this)
else
	ROLLBACK;
end if

end event

public subroutine wf_insert_field (string bookmark, string name, ref oleobject ole_object, ref oleobject ole_bookmark);If isnull(name) or len(name) <= 0 then return

If (ole_object.activedocument.bookmarks.exists(bookmark)) then
	ole_Bookmark = ole_Object.ActiveDocument.Bookmarks.Item(Bookmark)
	ole_Bookmark.Range.Text = Name
Else
	messagebox("Document Error", "The document do not have the specified field " + char(34) + bookmark + char(34) + " The document will be created without the missing field.",Exclamation!)
End if
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_print_claim_basewindow
   <OBJECT> Print heating and deviation and freight and misc and laytime_statement claims.	</OBJECT>
   <USAGE>
	       w_print_support_documents
			 w_print_support_documents_dem
	</USAGE>
   <ALSO>		</ALSO>
<HISTORY> 
	Date    		CR-Ref		Author	Comments
	01/08/11		CR2485   	LHC010	First Version 
	09/01/12		M5-2     	JMC112	rename cbx_1 and cbx_2 to cbx_print and cbx_sendax
										      implemented business logic behind cbx_sendax
										      added function wf_send_to_ax
	19/06/12		CR2820   	ZSW001	Remove MODIFIED field from CLAIMS table.
	14/09/12		CR2934   	LGX001	Add ax_invoice_text to transaction
	31/10/12		CR3009   	LGX001	Ax_invoice_text should be printed in support document also
	04/01/13		CR2918   	ZSW001	When supporting documents are printed after AX invoice has been received, 
												the invoice number should be referenced at the top of the supporting documents
	10/01/13		CR2877   	WWA048	Add a datawindow show a list of all available Charterers(taken from what has been updated in C/P)
	11/06/13		CR2877   	ZSW001	At first print, the primary charterer should be highlighted by default. At following prints, 
	                           	   the last used charterer should be highlighted. In the claim screen should show the last selected charterer in print.
	13/06/14		CR3700   	LHG008	If resend invoice data to AX, force user to select an anadjustment reason and save sent amount, adjustment reason...
	11/08/14		CR3708   	AGL027	F1 help application coverage - corrected ancestor
	28/09/14		CR2655   	LHG008	Fix bug for calculate amount usd
	04/11/14		CR3717UAT	XSZ004	Fix a bug.
	10/12/14		CR3216		XSZ004	Change the word "deductable" to "deductible"
	18/03/16		CR4243		LHC010	Add due date sent to AX
	19/09/16		CR2212		LHG008	Sanctions restrictions
	12/10/16		CR3320		AGL027	Voyage Master Transactions Handling	
	10/11/16		CR3320		AGL027	Modify popup message
</HISTORY>    
********************************************************************/

end subroutine

public subroutine wf_print (integer ai_broker_charterer_office);/********************************************************************
   wf_print
   <DESC>	Description	</DESC>
   <RETURN>	(None):
            <LI> n/a
            </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ai_broker_charterer_office
   </ARGS>
   <USAGE>	use ue_print	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28-07-2011 2485         LHC010        		First Version
   </HISTORY>
********************************************************************/
end subroutine

public subroutine wf_set_forwarding_date ();datetime ldt_forwarding_date
integer li_response

SELECT CLAIMS.FORWARDING_DATE
	INTO :ldt_forwarding_date
	FROM CLAIMS
	WHERE ( CLAIMS.CHART_NR = :istr_parm.chart_nr ) AND
	( CLAIMS.VESSEL_NR = :istr_parm.vessel_nr ) AND
	( CLAIMS.VOYAGE_NR = :istr_parm.voyage_nr ) AND
	( CLAIMS.CLAIM_NR  = :istr_parm.claim_nr);
	
if isnull(ldt_forwarding_date) then
	li_response = messagebox("Set forwarding date", "The current claim is not having a forwarding date. ~n~r" + &
		"Do you want to set the forwarding date?", exclamation!, yesno!, 1)
	
	if (li_response = 1) then
		ldt_forwarding_date = datetime(today())
		UPDATE CLAIMS
			SET FORWARDING_DATE = :ldt_forwarding_date
			WHERE ( CLAIMS.CHART_NR = :istr_parm.chart_nr ) AND
			( CLAIMS.VESSEL_NR = :istr_parm.vessel_nr ) AND
			( CLAIMS.VOYAGE_NR = :istr_parm.voyage_nr ) AND
			( CLAIMS.CLAIM_NR  = :istr_parm.claim_nr );
		if (sqlca.sqlcode <> 0) then
			ROLLBACK;
			messagebox("Error", "An error has occured inserting forwarding date.")
			return
		else
			COMMIT;
		end if
	end if
end if

end subroutine

public function integer wf_get_template (ref oleobject ole_object, ref oleobject ole_bookmark);/********************************************************************
   wf_get_template
   <DESC>	get template name and profitcenter info	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ole_object
		ole_bookmark	
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	26-08-2011 CR2485       LHC010        First Version
		14-12-2011 M5-2         LGX001        get support document  template according to claim type 
   </HISTORY>
********************************************************************/
string ls_filepath,	ls_templatedot

ole_object = CREATE OLEObject
// Connect to word
if (ole_object.connecttonewobject("word.application")) = 0 then
	ole_Bookmark = Create OleObject
	ole_Bookmark.ConnectTonewObject("word.application.bookmark")	
	
	choose case  istr_parm.claim_type
		case 'DEM','DES'
			ls_templatedot = 'demurrage_letter_charterer.dot'
		case 'FRT'
			ls_templatedot = 'freight_invoice.dot'
		case else
			ls_templatedot = 'misc_invoice.dot'
	end choose	
   ls_filepath = uo_global.gs_template_path + "\" + ls_templatedot
	if istr_parm.claim_type = 'DEM' or istr_parm.claim_type = 'DES' then
		ls_filepath = uo_global.gs_template_path + "\" +is_templateprefix +'.dot'
	end if
	if fileExists(ls_filepath) then
		ole_object.documents.add(ls_filepath)
	else
		Messagebox("Wrong File Path in System Options","The file path for MS WORD Templates in 'System Options' the field 'File Path to MS Word templates' is not correct", StopSign!)
		destroy ole_object
		return c#return.failure	
	end if
else
	Messagebox("OLE Error", "Unable to start an OLE server process!", Exclamation!)
	destroy ole_object
	return c#return.failure
end if

return c#return.success
end function

public subroutine wf_send_to_ax ();/********************************************************************
   Function: wf_send_to_ax
  <DESC>   </DESC>
  <Returns>  (none) </RETURN>
  <ARGS>
  </ARGS>
  <HISTORY>
        Date            CR-Ref      Author         Comments
        21/03/16        CR4243      LHC010         use due date instead discharge date. 
		
  </HISTORY>
********************************************************************/

long 		ll_row
datetime	ldt_duedate
mt_u_datawindow		ldw_claim_sent
n_claims_transaction lnv_claimtransaction

ll_row = dw_chart.getselectedrow(0)
if ll_row <= 0 then return

if dw_duedate.rowcount() > 0 then ldt_duedate = dw_duedate.getitemdatetime(dw_duedate.rowcount(), "due_date")

lnv_claimtransaction = create n_claims_transaction

istr_transaction_input.coda_or_cms = TRUE
istr_transaction_input.vessel_no = istr_parm.vessel_nr
istr_transaction_input.voyage_no = istr_parm.voyage_nr
istr_transaction_input.claim_no = istr_parm.claim_nr
istr_transaction_input.charter_no = dw_chart.getitemnumber(ll_row, "chart_chart_nr")
istr_transaction_input.currency_code = is_currcode
istr_transaction_input.payment_end = ldt_duedate//istr_parm.discharge_date
istr_transaction_input.ax_invoice_nr =istr_parm.ax_invoice_nr
istr_transaction_input.payment_id = istr_parm.claim_id
istr_transaction_input.tc_cp_date = istr_parm.cp_date
istr_transaction_input.ax_invoice_text = istr_parm.ax_invoice_text

//Log sent amount, adjustment reason...
choose case wf_fill_claim_sent()
	case c#return.Success
		ldw_claim_sent = dw_claim_sent
	case c#return.Failure
		return
	case else
		//continue
end choose

lnv_claimtransaction.of_send_data(istr_transaction_input, ldw_claim_sent)

destroy lnv_claimtransaction

end subroutine

public function long wf_get_invoice (decimal ad_payment_amount);/********************************************************************
   wf_get_invoice
   <DESC> to get the invoice N.O </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/12/2011 M5-2         LGX001             First Version
		19/06/2012 CR2820       ZSW001             Modified
   </HISTORY>
********************************************************************/

integer	li_locked
dec{2}	ld_payment_amount, ld_amount_diff, ld_address_diff, ld_cur_address_com, ld_ax_address_com

ld_payment_amount = ad_payment_amount

SELECT INVOICE_NR, 
       LOCKED, 
		 abs(:ld_payment_amount - CLAIM_AMOUNT_AX), 
		 ADDRESS_COM, 
		 ADDRESS_COM_AX
  INTO :is_invoice, 
       :li_locked, 
		 :ld_amount_diff, 
		 :ld_cur_address_com, 
		 :ld_ax_address_com
  FROM CLAIMS
 WHERE CHART_NR  = :istr_parm.chart_nr  AND
       VESSEL_NR = :istr_parm.vessel_nr AND
       VOYAGE_NR = :istr_parm.voyage_nr AND
       CLAIM_NR  = :istr_parm.claim_nr;

if sqlca.sqlcode <> 0 then return c#return.Failure

ld_address_diff = abs(ld_cur_address_com - ld_ax_address_com)

if li_locked = 1 or isnull(ld_amount_diff) or ld_amount_diff >= 0.01 or &
	isnull(ld_address_diff) and (not isnull(ld_cur_address_com) or not isnull(ld_ax_address_com)) or ld_address_diff >= 0.01 then
	is_invoice = "DRAFT"
end if

return c#return.Success

end function

public function long wf_print_dem ();/********************************************************************
   wf_print_dem
   <DESC>	Print supporting documents of AX invoice when claims type is DEM or DES	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/12/2011 M5-2         LGX001            First Version
		11/06/2013 CR2877       ZSW001            Add reutrn value
   </HISTORY>
********************************************************************/

return c#return.Success

end function

public function long wf_print_dev_hea ();/********************************************************************
   wf_print_dev_hea
   <DESC>	Print supporting documents of AX invoice when claims type is HEA or DEV	</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/12/2011 M5-2         LGX001            First Version
		11/06/2013 CR2877       ZSW001            Add reutrn value
   </HISTORY>
********************************************************************/

return c#return.Success

end function

public function long wf_print_freight ();/********************************************************************
   wf_print_freight
   <DESC>	Print supporting documents of AX invoice when claims type is FRT </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/12/2011 M5-2         LGX001            First Version
		11/06/2013 CR2877       ZSW001            Add reutrn value
   </HISTORY>
********************************************************************/

return c#return.Success

end function

public function long wf_print_misc ();/********************************************************************
   wf_print_misc
   <DESC>	Print supporting documents of AX invoice when miscellaneous </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23/12/2011 M5-2         LGX001            First Version
		11/06/2013 CR2877       ZSW001            Add reutrn value
   </HISTORY>
********************************************************************/

return c#return.Success

end function

public subroutine wf_enable_adj_reason (boolean ab_enable);/********************************************************************
   wf_enable_adj_reason
   <DESC>	enabled or disable adjustment reason	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_enable
   </ARGS>
   <USAGE>	cbx_sendax.event clicked(), window open()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		12/06/14 CR3700        LHG008   First Version
		25/03/15 CR4243		   LHC010	set claim sent datawindow to enabled
   </HISTORY>
********************************************************************/

string ls_backgroundcolor

dw_claim_sent.enabled = ab_enable

if ab_enable then
	dw_claim_sent.modify("datawindow.readonly = no")
	dw_claim_sent.modify("title_t.color = " + string(c#color.black))
	dw_claim_sent.modify("adj_type_id.background.mode = '0' adj_type_id.color = " + string(c#color.black) + " adj_type_id.background.color = " + string(c#color.MT_MAERSK))
	dw_claim_sent.modify("adj_subtype_id.background.mode = '0' adj_subtype_id.color = " + string(c#color.black) + " adj_subtype_id.background.color = " + string(c#color.MT_MAERSK))
else
	ls_backgroundcolor = dw_claim_sent.describe("datawindow.color")
	dw_claim_sent.modify("datawindow.readonly = yes")
	dw_claim_sent.modify("title_t.color = " + string(c#color.gray))
	dw_claim_sent.modify("adj_type_id.color = " + ls_backgroundcolor + " adj_type_id.background.color = " + string(c#color.transparent))
	dw_claim_sent.modify("adj_subtype_id.color = " + ls_backgroundcolor + " adj_subtype_id.background.color = " + string(c#color.transparent))
end if

end subroutine

public function integer wf_fill_claim_sent ();/********************************************************************
   wf_fill_claim_sent()
   <DESC>	Set all fields for dw_claim_sent except adjustment reason(Force user to select it when user resends invoice data to AX),
		then in the function wf_send_to_ax() will	call n_claims_transaction.of_send_data(istr_transaction_input, ldw_claim_sent) to save the data.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	
            <LI> c#return.NoAction: 0, noaction	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by wf_send_to_ax()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		13/06/14 CR3700        LHG008   First Version
		28/09/14 CR2655        LHG008   Fix bug for calculate amount usd
		16/01/17 CR4467        SSX014   Fix bug for calculate amount usd using SET EXRATE
   </HISTORY>
********************************************************************/

long			ll_row
decimal{4}	ld_amount_local, ld_amount_usd, ld_addr_com, ld_addr_com_usd
n_claimcurrencyadjust	lnv_claimcurrencyadjust
string ls_claim_type
long ll_cerp_id

dw_claim_sent.accepttext()

ll_row = dw_claim_sent.getrow()

if ll_row > 0 and (dw_claim_sent.getitemstatus(ll_row, 0, Primary!) = New! or dw_claim_sent.getitemstatus(ll_row, 0, Primary!) = NewModified!) then
	
	dw_claim_sent.setitem(ll_row, "chart_nr", istr_parm.chart_nr)
	dw_claim_sent.setitem(ll_row, "vessel_nr", istr_parm.vessel_nr)
	dw_claim_sent.setitem(ll_row, "voyage_nr", istr_parm.voyage_nr)
	dw_claim_sent.setitem(ll_row, "claim_nr", istr_parm.claim_nr)
	
	SELECT CLAIM_TYPE, CAL_CERP_ID
		INTO :ls_claim_type, :ll_cerp_id
	FROM CLAIMS
	WHERE VESSEL_NR = :istr_parm.vessel_nr
		AND VOYAGE_NR = :istr_parm.voyage_nr
		AND CHART_NR = :istr_parm.chart_nr
		AND CLAIM_NR = :istr_parm.claim_nr;
	
	ld_addr_com = istr_transaction_input.comm_amount
	ld_amount_local = istr_transaction_input.amount_local - ld_addr_com
	
	dw_claim_sent.setitem(ll_row, "sent_amount", ld_amount_local) //Amount - Address Commission.
	
	if lnv_claimcurrencyadjust.of_getamountusd(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, ls_claim_type, ll_cerp_id, is_currcode,  ld_amount_local, ld_amount_usd) < 0 then	
		messagebox("Error", "It is not possible to get exchange rate. Please contact system administrator.")
		return c#return.Failure
	end if
	
	dw_claim_sent.setitem(ll_row, "sent_amount_usd", ld_amount_usd)
	
	dw_claim_sent.setitem(ll_row, "deviation_amount", dec(dw_claim_sent.describe("evaluate('(sent_amount - sent_amount[-1])', " + string(ll_row) + ")")))
	dw_claim_sent.setitem(ll_row, "deviation_amount_usd", dec(dw_claim_sent.describe("evaluate('(sent_amount_usd - sent_amount_usd[-1])', " + string(ll_row) + ")")))
	
	if lnv_claimcurrencyadjust.of_getamountusd(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, ls_claim_type, ll_cerp_id, is_currcode,  ld_addr_com, ld_addr_com_usd) < 0 then	
		messagebox("Error", "It is not possible to get exchange rate. Please contact system administrator.")
		return c#return.Failure
	end if
	
	dw_claim_sent.setitem(ll_row, "address_com_usd", ld_addr_com_usd)
	
	dw_claim_sent.setitem(ll_row, "sent_by", uo_global.is_userid)
	dw_claim_sent.setitem(ll_row, "sent_date", today())
else
	return c#return.NoAction
end if

return c#return.Success
end function

public subroutine wf_enable_duedate (boolean ab_enable);/********************************************************************
   wf_enable_duedate
   <DESC>	enabled or disable due date	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ab_enable
   </ARGS>
   <USAGE>	cbx_sendax.event clicked() and window open </USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		18/03/16 CR4243        LHC010   First Version
   </HISTORY>
********************************************************************/

string ls_backgroundcolor

dw_duedate.enabled = ab_enable

if ab_enable then
	dw_duedate.modify("datawindow.readonly = no")
	dw_duedate.modify("due_date_t.color = " + string(c#color.black))
	dw_duedate.modify("due_date.background.mode = '0' due_date.color = " + string(c#color.black) + " due_date.background.color = " + string(c#color.MT_MAERSK))
else
	ls_backgroundcolor = dw_duedate.describe("datawindow.color")
	dw_duedate.modify("datawindow.readonly = yes")
	dw_duedate.modify("due_date_t.color = " + string(c#color.gray))
	dw_duedate.modify("due_date.color = " + string(c#color.gray) + " due_date.background.color = " + string(c#color.transparent))
end if

end subroutine

public subroutine wf_set_duedate (string as_claimtype);/********************************************************************
   wf_set_duedate
   <DESC>	Set due date	</DESC>
   <RETURN>	(None)
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_claimtype
   </ARGS>
   <USAGE>	window open </USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		18/03/16 CR3700        LHC010   First Version
   </HISTORY>
********************************************************************/

datetime ldt_duedate

setnull(ldt_duedate)

if as_claimtype = "FRT" then
	SELECT max(PORT_DEPT_DT) 
	  INTO :ldt_duedate  
	  FROM (SELECT PORT_DEPT_DT
			FROM POC
			WHERE VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND PURPOSE_CODE IN("D", "L/D")
			UNION ALL
			SELECT PORT_DEPT_DT
			FROM POC_EST
			WHERE VESSEL_NR = :istr_parm.vessel_nr
			AND VOYAGE_NR = :istr_parm.voyage_nr
			AND PURPOSE_CODE IN("D", "L/D")) AS POC;
	if not isnull(ldt_duedate) then
		if dw_duedate.rowcount() = 1 then dw_duedate.setitem(1, "due_date", ldt_duedate)
	end if
else
	ldt_duedate = datetime(today(), now())
	if dw_duedate.rowcount() = 1 then dw_duedate.setitem(1, "due_date", ldt_duedate)
end if
end subroutine

public subroutine wf_disble_print ();/********************************************************************
   wf_disble_print
   <DESC>	enabled or disable print button	</DESC>
   <RETURN>	None
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		
   </ARGS>
   <USAGE>	cbx_sendax.event clicked() and window open and cbx_broker.event clicked
   </USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		18/03/16 CR4243        LHC010   First Version
		19/09/16 CR2212        LHG008   Sanctions restrictions
   </HISTORY>
********************************************************************/

boolean 	lb_disbleprint
datetime 	ldt_duedate
long		ll_adjtypeid, ll_adjsubtypeid, ll_currentrow
string	ls_default_curr
decimal	ld_exrate

if cbx_sendax.checked then
	setnull(ldt_duedate)

	if dw_duedate.rowcount() = 1 then 
		ldt_duedate = dw_duedate.getitemdatetime(1, "due_date")
		lb_disbleprint = (isnull(ldt_duedate) or ldt_duedate = datetime("1900-01-01 00:00"))
	end if
	
	if dw_claim_sent.rowcount() > 0 and ib_issenttoax and not lb_disbleprint then
		setnull(ll_adjtypeid)
		setnull(ll_adjsubtypeid)
		ll_currentrow = dw_claim_sent.getrow()
		
		if ll_currentrow > 0 then
			ll_adjtypeid = dw_claim_sent.getitemnumber(ll_currentrow, "adj_type_id")
			ll_adjsubtypeid = dw_claim_sent.getitemnumber(ll_currentrow, "adj_subtype_id")
		end if
		
		lb_disbleprint = (isnull(ll_adjtypeid + ll_adjsubtypeid) or (ll_adjtypeid + ll_adjsubtypeid) = 0)
	end if	
end if

if not lb_disbleprint and dw_paymentcurr.visible then
	ls_default_curr = dw_paymentcurr.getitemstring(1, "payment_curr")
	ld_exrate = dw_paymentcurr.getitemdecimal(1, "exrate_invoice")
	if isnull(ls_default_curr) or ls_default_curr = '' or isnull(ld_exrate) or ld_exrate = 0 then lb_disbleprint = true
end if

wf_disble_print(lb_disbleprint)
end subroutine

public subroutine wf_disble_print (boolean ab_disbleprint);/********************************************************************
   wf_disble_print
   <DESC>	enabled or disable print button	</DESC>
   <RETURN>	None
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		disbleprint
   </ARGS>
   <USAGE>	wf_disble_print
   </USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		18/03/16 CR4243        LHC010   First Version
   </HISTORY>
********************************************************************/

end subroutine

public function integer wf_enable_paymentcurr ();/********************************************************************
   wf_enable_paymentcurr
   <DESC>	Check the claim whether is sanction	or not, if sanction then set the dw to visible, else invisible </DESC>
   <RETURN>	integer:
				<LI> c#return.NoAction: 0 NoAction
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	call by window open event	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		19/09/16 CR2212        LHG008   First Version
   </HISTORY>
********************************************************************/

string	ls_deverrmsg, ls_null
decimal	ld_exrate
date		ldate_exrate_date
datawindowchild ldwc_child

DECLARE SP_GET_RST_DEF_CURR PROCEDURE FOR
	SP_GET_RST_DEF_CURR	@chart_nr = :istr_parm.chart_nr,
								@vessel_nr = :istr_parm.vessel_nr, 
								@voyage_nr = :istr_parm.voyage_nr,
								@claim_nr = :istr_parm.claim_nr,
								@restrict_curr = :is_restrict_curr output, 
								@default_curr = :is_default_curr output,
								@contract_id = :il_contract_id output, 
								@last_rst_payment = :il_last_rst_payment output
	USING SQLCA;

EXECUTE SP_GET_RST_DEF_CURR;

if sqlca.sqlcode = -1 then
	ls_deverrmsg = sqlca.sqlerrtext
	CLOSE SP_GET_RST_DEF_CURR;
	_addmessage(this.classdefinition, "wf_enable_paymentcurr()", "Failed to get restriction info.", ls_deverrmsg)
	return c#return.Failure
end if

FETCH SP_GET_RST_DEF_CURR INTO :is_restrict_curr, :is_default_curr, :il_contract_id, :il_last_rst_payment;

CLOSE SP_GET_RST_DEF_CURR;

if len(is_restrict_curr) > 0 then
	dw_paymentcurr.settransobject(sqlca)
	if dw_paymentcurr.retrieve(istr_parm.chart_nr, istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.claim_nr) <= 0 then return c#return.NoAction
	
	dw_paymentcurr.getchild("payment_curr", ldwc_child)
	ldwc_child.setfilter("curr_code not in(" + is_restrict_curr + ")")
	ldwc_child.filter()
	
	setnull(ldate_exrate_date)
	dw_paymentcurr.setitem(1, "exrate_date", ldate_exrate_date)
	
	setnull(ls_null)
	dw_paymentcurr.setitem(1, "payment_curr", ls_null)
	
	if is_default_curr = '' then setnull(is_default_curr)
	if isnull(is_default_curr) then
		setnull(ld_exrate)
		dw_paymentcurr.setitem(1, "payment_curr", is_default_curr)
		dw_paymentcurr.setitem(1, "exrate_invoice", ld_exrate)
	else
		dw_paymentcurr.settext(is_default_curr)
		dw_paymentcurr.setcolumn("payment_curr")
	end if
	
	dw_paymentcurr.modify("exrate_invoice_t.text = 'Ex Rate from " + is_currcode + "'")
	dw_paymentcurr.visible = true
	return c#return.Success
end if

return c#return.NoAction
end function

public function integer wf_set_sanctioninfo (decimal ad_invoice_amount);/********************************************************************
   wf_set_sanctioninfo
   <DESC>	clac and set sanction info to istr_transaction_input	</DESC>
   <RETURN>	integer
            <LI> c#return.NoAction: 0, NoAction
            <LI> c#return.Success: 1, ok	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ad_invoice_amount
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		19/09/16 CR2212        LHG008   First Version
   </HISTORY>
********************************************************************/

string	ls_payment_curr
decimal	ld_exrate_invoice, ld_payment_amount
date		ldate_exrate_date

if not dw_paymentcurr.visible then return c#return.NoAction

ls_payment_curr = dw_paymentcurr.getitemstring(1, "payment_curr")
ld_exrate_invoice = dw_paymentcurr.getitemdecimal(1, "exrate_invoice")
ldate_exrate_date = dw_paymentcurr.getitemdate(1, "exrate_date")
ld_payment_amount = ad_invoice_amount * ld_exrate_invoice / 100

istr_transaction_input.s_sanction_currency = ls_payment_curr
istr_transaction_input.s_sanction_line_1 = "Exchange rate " + string(ld_exrate_invoice, "0.000000")
if not isnull(ldate_exrate_date) then istr_transaction_input.s_sanction_line_1 += " (" + string(ldate_exrate_date, "d mmm yyyy") + ")"
istr_transaction_input.s_sanction_line_2 = ls_payment_curr + " " + string(ld_payment_amount, "#,##0.00")

return c#return.Success
end function

public function decimal wf_get_rst_exrate (string as_payment_curr, date adate_exrate_date);/********************************************************************
   wf_get_rst_exrate
   <DESC>	Calculate exchange rate between invoice currency and payment currency	</DESC>
   <RETURN>	decimal:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_payment_curr
		adate_exrate_date
   </ARGS>
   <USAGE>	dw_paymentcurr.itemchanged()	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		11/10/16 CR2212        LHG008   First Version
   </HISTORY>
********************************************************************/

string	ls_METHOD_NAME = "wf_get_rst_exrate()"
decimal	ld_payment_exrate, ld_invoice_exrate, ld_exrate
n_claimcurrencyadjust	lnv_curradjust
s_cargo_base_data			lstr_cargo_data
n_exchangerate				lnv_exrate

if is_currcode = as_payment_curr then return 100.00

if lnv_curradjust.of_getsetexrate(istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, &
	istr_parm.claim_type, istr_parm.cal_cerp_id, is_currcode, ld_invoice_exrate) = c#return.Success then
	if ld_invoice_exrate > 0 then
		//Continue processing
	else
		ld_invoice_exrate = lnv_exrate.of_getexchangerate(is_currcode, "USD", adate_exrate_date, false)
	end if
else
	messagebox("Error", "Check fixed exchange rate failed.", StopSign!)
	return ld_exrate
end if

if ld_invoice_exrate > 0 then
	ld_payment_exrate = lnv_exrate.of_getexchangerate(as_payment_curr, "USD", adate_exrate_date, false)
end if

if ld_invoice_exrate > 0 and ld_payment_exrate > 0 then
	ld_exrate = ld_invoice_exrate / ld_payment_exrate * 100
else
	ld_invoice_exrate = lnv_exrate.of_getexchangerate(is_currcode, "DKK", adate_exrate_date, false)
	if ld_invoice_exrate > 0 then
		ld_payment_exrate = lnv_exrate.of_getexchangerate(as_payment_curr, "DKK", adate_exrate_date, false)
		if ld_payment_exrate > 0 then
			ld_exrate = ld_invoice_exrate / ld_payment_exrate * 100
		end if
	end if
end if

if isnull(ld_exrate) or ld_exrate <= 0 then
	ld_exrate = 0
end if

return ld_exrate
end function

event open;call super::open;long		ll_axtextflag, ll_row, ll_chart_nr_printed, ll_dwo_position_adjust
string	ls_claim_type, ls_fullname
constant long ll_HORIZONTAL_DISTANCE = 37
constant long ll_DWO_LEFT_POSITION = 4, ll_DWO_RIGHT_POSITION = 95

n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style

istr_parm = message.powerobjectparm

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_chart)
lnv_style.of_dwlistformater(dw_brokers)

dw_chart.width = this.width - ll_HORIZONTAL_DISTANCE * 3
ll_dwo_position_adjust = dw_chart.width - ll_DWO_LEFT_POSITION - ll_DWO_RIGHT_POSITION - long(dw_chart.describe("cal_chart_isprimary.width"))
dw_chart.modify("chart_chart_n_1.width = '" + string(ll_dwo_position_adjust) + "'")

dw_brokers.width = dw_chart.width
ll_dwo_position_adjust = dw_brokers.width - ll_DWO_LEFT_POSITION - ll_DWO_RIGHT_POSITION - long(dw_brokers.describe("cal_comm_cal_comm_percent.width"))
dw_brokers.modify("brokers_broker_name.width = '" + string(ll_dwo_position_adjust) + "'")

// get vessel name / pc  pc name  	 
SELECT VESSELS.VESSEL_NAME, 
       VESSELS.PC_NR, 
		 PROFIT_C.PC_NAME 
  INTO :is_vesselname,
       :ii_vessel_pc_nr,
		 :is_profitcenter_name 
  FROM VESSELS LEFT OUTER JOIN 
       PROFIT_C ON VESSELS.PC_NR = PROFIT_C.PC_NR 
 WHERE VESSELS.VESSEL_NR = :istr_parm.vessel_nr;
 
// get user full name  and business group  	 
SELECT (USERS.FIRST_NAME + ' '+ USERS.LAST_NAME) 
  INTO :is_userfullname  
  FROM USERS 
 WHERE USERS.USERID = :uo_global.is_userid; 	 

// get office / broker / CP date  and curr code  
SELECT OFFICE_NR,
       BROKER_NR,
       CP_DATE, 
		 CURR_CODE,
		 AX_INVOICE_TEXT_FLAG,
		 AX_INVOICE_TEXT,
		 CHART_NR_PRINTED
  INTO :ii_office_nr, 
       :ii_broker_nr,
		 :idt_cpdate,
		 :is_currcode,
		 :ll_axtextflag,
		 :is_axfreetext,
		 :ll_chart_nr_printed
  FROM CLAIMS
 WHERE VESSEL_NR = :istr_parm.vessel_nr 
   AND VOYAGE_NR = :istr_parm.voyage_nr
   AND CHART_NR  = :istr_parm.chart_nr
   AND CLAIM_NR  = :istr_parm.claim_nr;
COMMIT USING SQLCA;

if ll_axtextflag = 1 then
	if trim(is_axfreetext) = "" then setnull(is_axfreetext)	
else
	setnull(is_axfreetext)
end if

this.title = istr_parm.claim_title

dw_brokers.settransobject(sqlca)
dw_brokers.retrieve(istr_parm.cal_cerp_id, istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.chart_nr, istr_parm.claim_nr)
dw_chart.settransobject(sqlca)

if istr_parm.cal_cerp_id > 1 then
	dw_chart.retrieve(istr_parm.cal_cerp_id)	
else
	SELECT CHART_N_1 INTO :ls_fullname FROM CHART WHERE CHART_NR = :istr_parm.chart_nr;
	
	ll_row = dw_chart.insertrow(0)
	dw_chart.setitem(ll_row, "chart_chart_nr", istr_parm.chart_nr)
	dw_chart.setitem(ll_row, "chart_chart_n_1", ls_fullname)
	dw_chart.setitem(ll_row, "cal_chart_isprimary", 1)
end if

if istr_parm.send_to_ax_locked = 1 then
	cbx_sendax.enabled = false
else
	if istr_parm.i_voyage_locked = 1 then
		cbx_sendax.enabled = false
	else	
		p_infoax.visible=false
		cbx_sendax.enabled = true
	end if
end if

dw_claim_sent.settransobject(sqlca)
//Check if invoice data is sent to AX, force user to select an anadjustment reason.
if dw_claim_sent.retrieve(istr_parm.chart_nr, istr_parm.vessel_nr, istr_parm.voyage_nr, istr_parm.claim_nr) > 0 then
	cbx_sendax.text = "Resend invoice data to AX"
	p_infoax.x = p_infoax.x + 56
	ib_issenttoax = true
end if

if dw_claim_sent.visible then
	//Insert new row and scroll to the row(note: user cannot change row focus.)
	ll_row = dw_claim_sent.insertrow(0)
	dw_claim_sent.setrow(ll_row)
	dw_claim_sent.scrolltorow(ll_row)
	wf_enable_adj_reason(cbx_sendax.checked and ib_issenttoax)
end if

wf_enable_duedate(cbx_sendax.checked)

if isnull(ll_chart_nr_printed) then
	ll_row = dw_chart.find("cal_chart_isprimary = 1", 1, dw_chart.rowcount())
else
	ll_row = dw_chart.find("chart_chart_nr = " + string(ll_chart_nr_printed), 1, dw_chart.rowcount())
end if

if isnull(ll_row) or ll_row <= 0 then ll_row = 1
dw_chart.scrolltorow(ll_row)
dw_chart.selectrow(ll_row, true)

dw_duedate.retrieve(istr_parm.claim_id)

wf_set_duedate(istr_parm.claim_type)

lnv_style.of_dwformformater(dw_paymentcurr)
wf_enable_paymentcurr()

wf_disble_print()

end event

on closequery;IF cb_close.Enabled = FALSE THEN
	MessageBox("Info","You can't close this window while print function is active")
	Message.ReturnValue = 1
END IF
end on

on w_print_claim_basewindow.create
int iCurrent
call super::create
this.dw_claim_sent=create dw_claim_sent
this.cbx_print=create cbx_print
this.cbx_office=create cbx_office
this.cbx_alt_adress=create cbx_alt_adress
this.st_9=create st_9
this.st_7=create st_7
this.dw_brokers=create dw_brokers
this.cbx_charterer=create cbx_charterer
this.cbx_broker=create cbx_broker
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_chart=create dw_chart
this.dw_duedate=create dw_duedate
this.st_charterer=create st_charterer
this.cbx_sendax=create cbx_sendax
this.dw_paymentcurr=create dw_paymentcurr
this.p_infoax=create p_infoax
this.dw_info=create dw_info
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_claim_sent
this.Control[iCurrent+2]=this.cbx_print
this.Control[iCurrent+3]=this.cbx_office
this.Control[iCurrent+4]=this.cbx_alt_adress
this.Control[iCurrent+5]=this.st_9
this.Control[iCurrent+6]=this.st_7
this.Control[iCurrent+7]=this.dw_brokers
this.Control[iCurrent+8]=this.cbx_charterer
this.Control[iCurrent+9]=this.cbx_broker
this.Control[iCurrent+10]=this.cb_print
this.Control[iCurrent+11]=this.cb_close
this.Control[iCurrent+12]=this.dw_chart
this.Control[iCurrent+13]=this.dw_duedate
this.Control[iCurrent+14]=this.st_charterer
this.Control[iCurrent+15]=this.cbx_sendax
this.Control[iCurrent+16]=this.dw_paymentcurr
this.Control[iCurrent+17]=this.p_infoax
this.Control[iCurrent+18]=this.dw_info
end on

on w_print_claim_basewindow.destroy
call super::destroy
destroy(this.dw_claim_sent)
destroy(this.cbx_print)
destroy(this.cbx_office)
destroy(this.cbx_alt_adress)
destroy(this.st_9)
destroy(this.st_7)
destroy(this.dw_brokers)
destroy(this.cbx_charterer)
destroy(this.cbx_broker)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_chart)
destroy(this.dw_duedate)
destroy(this.st_charterer)
destroy(this.cbx_sendax)
destroy(this.dw_paymentcurr)
destroy(this.p_infoax)
destroy(this.dw_info)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_print_claim_basewindow
end type

type dw_claim_sent from mt_u_datawindow within w_print_claim_basewindow
event ue_vscroll pbm_vscroll
event ue_dwndropdown pbm_dwndropdown
integer x = 18
integer y = 464
integer width = 1371
integer height = 128
integer taborder = 20
string title = "Adjustment reason"
string dataobject = "d_sq_tb_claim_sent"
boolean border = false
boolean livescroll = false
boolean ib_setdefaultbackgroundcolor = true
end type

event ue_vscroll;return 1
end event

event ue_dwndropdown;/********************************************************************
   ue_dwndropdown
   <DESC>	if not have adjustment reason in dropdown, popup message	</DESC>
   <RETURN>	long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		07/07/14 CR3700        LHG008   First Version
   </HISTORY>
********************************************************************/

datawindowchild ldwc_child
long		ll_row
string	ls_colname

ll_row = this.getrow()
ls_colname = this.getcolumnname()

if ll_row <= 0 then return

if ls_colname = "adj_type_id" or (ls_colname = "adj_subtype_id" and not isnull(this.getitemnumber(ll_row, "adj_type_id"))) then
	if this.getchild(ls_colname, ldwc_child) = 1 then
		if ldwc_child.rowcount() = 0 then
			messagebox("Adjustment Reason Selection", "Tramos cannot find the adjustment reason you want. " &
				+ "Please update the adjustment reason master data in the Transaction Adjustment Reason system table.")
		end if
	end if
end if
end event

event itemchanged;call super::itemchanged;long	ll_null
datawindowchild ldwc_subtype

setnull(ll_null)
if dwo.name = "adj_type_id" then
	this.setitem(row, "adj_subtype_id", ll_null)
	this.getchild("adj_subtype_id", ldwc_subtype)
	ldwc_subtype.setfilter("type_id = " + data)
	ldwc_subtype.filter()
end if

post wf_disble_print()
end event

event rowfocuschanging;call super::rowfocuschanging;if newrow <> rowcount() then return 1
end event

event getfocus;call super::getfocus;this.setcolumn("adj_type_id")

end event

event ue_dwkeypress;call super::ue_dwkeypress;if keyflags = 1 then
	if key = keytab! and this.getcolumnname() = "adj_type_id" then setfocus(dw_duedate)
end if
end event

type cbx_print from checkbox within w_print_claim_basewindow
integer x = 32
integer y = 92
integer width = 805
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print supporting documents"
boolean checked = true
end type

event clicked;post wf_disble_print()
end event

type cbx_office from checkbox within w_print_claim_basewindow
integer x = 1115
integer y = 832
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Office"
end type

event clicked;post wf_disble_print()
end event

type cbx_alt_adress from checkbox within w_print_claim_basewindow
integer x = 32
integer y = 1396
integer width = 805
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Use alternative invoice adress"
end type

type st_9 from statictext within w_print_claim_basewindow
integer x = 32
integer y = 836
integer width = 453
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Print HEA or DEV invoice"
boolean focusrectangle = false
end type

type st_7 from statictext within w_print_claim_basewindow
integer x = 32
integer y = 948
integer width = 855
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Select deductible brokers commission"
boolean focusrectangle = false
end type

type dw_brokers from u_datagrid within w_print_claim_basewindow
integer x = 32
integer y = 1012
integer width = 2002
integer height = 352
integer taborder = 60
string dataobject = "d_commission_brokers"
boolean vscrollbar = true
boolean border = false
end type

event clicked;if (row > 0) then
	this.selectrow(row,not this.isselected(row))
end if


end event

type cbx_charterer from checkbox within w_print_claim_basewindow
integer x = 791
integer y = 832
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charterer"
boolean checked = true
end type

event clicked;post wf_disble_print()
end event

type cbx_broker from checkbox within w_print_claim_basewindow
integer x = 521
integer y = 832
integer width = 306
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Broker"
end type

event clicked;post wf_disble_print()
end event

type cb_print from commandbutton within w_print_claim_basewindow
integer x = 2066
integer y = 1220
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
boolean default = true
end type

event clicked;long		ll_row, ll_cal_chart_id
string	ls_errtext

ll_row = dw_chart.getrow()
if ll_row <= 0 then return

/* get charter full name */
is_chartfullname = dw_chart.getitemstring(ll_row, "chart_chart_n_1")

parent.event ue_print()

end event

type cb_close from commandbutton within w_print_claim_basewindow
integer x = 2066
integer y = 1344
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type dw_chart from u_datagrid within w_print_claim_basewindow
integer x = 32
integer y = 68
integer width = 2002
integer height = 360
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_sq_gr_print_charterer"
boolean vscrollbar = true
boolean border = false
end type

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
if currentrow > 0 then this.selectrow(currentrow, true)

end event

type dw_duedate from mt_u_datawindow within w_print_claim_basewindow
integer x = 1696
integer y = 504
integer width = 553
integer height = 64
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sq_ff_claims_duedate"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

event itemchanged;call super::itemchanged;post wf_disble_print()
end event

event losefocus;call super::losefocus;wf_disble_print()
end event

event editchanged;call super::editchanged;this.accepttext()
end event

type st_charterer from mt_u_statictext within w_print_claim_basewindow
integer x = 37
integer y = 4
integer width = 1189
integer height = 56
boolean enabled = false
string text = "Select Charterer full style for invoice address"
end type

type cbx_sendax from checkbox within w_print_claim_basewindow
integer x = 32
integer y = 16
integer width = 805
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Send invoice data to AX"
end type

event clicked;if dw_claim_sent.visible then wf_enable_adj_reason(cbx_sendax.checked and ib_issenttoax)
wf_enable_duedate(cbx_sendax.checked)

//if cbx_sendax.checked then wf_set_duedate(istr_parm.claim_type)

wf_disble_print()
end event

type dw_paymentcurr from u_datawindow_sqlca within w_print_claim_basewindow
boolean visible = false
integer x = 1573
integer y = 608
integer width = 750
integer height = 240
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_sq_ff_paymentcurr"
boolean border = false
boolean ib_autoaccept = true
end type

event itemchanged;call super::itemchanged;string	ls_payment_curr
decimal	ld_payment_exrate, ld_exrate
date		ldate_exrate_date
n_exchangerate lnv_exrate

if row > 0 and isvalid(dwo) then
	choose case dwo.name
		case "payment_curr", "exrate_date"
			if dwo.name = "payment_curr" then
				ls_payment_curr = data
				
				ldate_exrate_date = this.getitemdate(row, "exrate_date")
				if isnull(ldate_exrate_date) then
					ldate_exrate_date = today()
				end if
			else //dwo.name = "exrate_date"
				ldate_exrate_date = date(data)
				if isnull(ldate_exrate_date) then return 0
				
				ls_payment_curr = this.getitemstring(row, "payment_curr")
			end if
			
			if isnull(ls_payment_curr) or len(trim(ls_payment_curr)) = 0 then return 0
			
			ld_exrate = wf_get_rst_exrate(ls_payment_curr, ldate_exrate_date)
			if ld_exrate > 0 then
				//
			else
				setnull(ld_exrate)
				setnull(ldate_exrate_date)
			end if
			
			this.setitem(row, "exrate_invoice", ld_exrate)
			this.setitem(row, "exrate_date", ldate_exrate_date)
			
		case "exrate_invoice"
			setnull(ldate_exrate_date)
			this.setitem(row, "exrate_date", ldate_exrate_date)
			
	end choose
end if

post wf_disble_print()

return 0
end event

event constructor;call super::constructor;dw_paymentcurr.modify("payment_curr.background.mode = '0' payment_curr.color = " + string(c#color.black) + " payment_curr.background.color = " + string(c#color.MT_MAERSK))
dw_paymentcurr.modify("exrate_invoice.background.mode = '0' exrate_invoice.color = " + string(c#color.black) + " exrate_invoice.background.color = " + string(c#color.MT_MAERSK))

end event

type p_infoax from picture within w_print_claim_basewindow
event ue_mousemove pbm_mousemove
integer x = 155
integer y = 668
integer width = 73
integer height = 64
boolean bringtotop = true
boolean originalsize = true
string picturename = "images\information.png"
boolean focusrectangle = false
end type

event ue_mousemove;/********************************************************************
   event ue_mousemove( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
   <DESC>   
		monitors the mouse pointer in regards to the popup
	</DESC>
   <RETURN> 
		Long
	</RETURN>
   <ACCESS> 
		Public
	</ACCESS>
   <ARGS>   
		standard powerbuilder arguments for this event
	</ARGS>
   <USAGE>  
	</USAGE>
********************************************************************/


end event

event clicked;long ll_pointery
long ll_dwpopup_height 
long ll_parent_pointery
long ll_dwparentheight
string ls_infotext=''


dw_info.x = this.x + this.PointerX() 
if dw_info.rowcount()=0 then
	dw_info.insertrow(0)
	if istr_parm.i_voyage_locked=1 then
		ls_infotext = '* the AX success message for the pending voyage number change is missing.'
		if istr_parm.send_to_ax_locked=1 then
			ls_infotext += c#string.cr + '* the AX success message for the selected claim is missing.'		
		end if
	elseif istr_parm.send_to_ax_locked=1 then
		ls_infotext += '* the AX success message for the selected claim is missing.'		
	end if
	dw_info.setitem(1,"info",'You cannot (re)send invoice data to AX, because...' + c#string.cr + c#string.cr + ls_infotext)
	dw_info.height = long(dw_info.Describe("Evaluate('Rowheight()', 1)")) + 20
	dw_info.y = this.y + this.PointerY() - dw_info.height
end if
dw_info.visible = not dw_info.visible
end event

event losefocus;if dw_info.visible and dw_info.ib_autoclose then
//	if (xpos < this.x) or (ypos < this.y) then
		//this.setfocus()
		dw_info.visible = false
//	end if
end if
end event

type dw_info from u_popupdw within w_print_claim_basewindow
event ue_mousemove pbm_mousemove
integer x = 727
integer y = 644
integer width = 1006
integer height = 284
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string dataobject = "d_ex_ff_info_container_for_popupdw"
boolean vscrollbar = false
boolean resizable = false
borderstyle borderstyle = styleraised!
end type

