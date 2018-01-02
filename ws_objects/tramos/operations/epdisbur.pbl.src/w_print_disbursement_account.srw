$PBExportHeader$w_print_disbursement_account.srw
$PBExportComments$Prints disbursement accounts
forward
global type w_print_disbursement_account from mt_w_response
end type
type st_10 from statictext within w_print_disbursement_account
end type
type st_9 from statictext within w_print_disbursement_account
end type
type st_7 from statictext within w_print_disbursement_account
end type
type cb_settle from commandbutton within w_print_disbursement_account
end type
type dw_disbursement_info from mt_u_datawindow within w_print_disbursement_account
end type
type cb_cancel from commandbutton within w_print_disbursement_account
end type
type gb_1 from groupbox within w_print_disbursement_account
end type
end forward

global type w_print_disbursement_account from mt_w_response
integer x = 55
integer y = 84
integer width = 1673
integer height = 540
string title = "Settle Disbursements"
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
event ue_close pbm_custom64
st_10 st_10
st_9 st_9
st_7 st_7
cb_settle cb_settle
dw_disbursement_info dw_disbursement_info
cb_cancel cb_cancel
gb_1 gb_1
end type
global w_print_disbursement_account w_print_disbursement_account

type variables
s_w_print_disb_account istr_parm

end variables

forward prototypes
public subroutine wf_checkagent_charterowner ()
public function integer wf_check_exchange_rate ()
public subroutine documentation ()
end prototypes

public subroutine wf_checkagent_charterowner ();STRING ls_Agent_Sno, ls_Charterer_Sno, ls_Owner_Sno, ls_warning
LONG ll_paymentID

if istr_parm.dw_tc_exp.RowCount() > 0 then
	ll_paymentID = istr_parm.dw_tc_exp.getItemNumber(1, "payment_id")
end if

SELECT isNULL(AGENTS.NOM_ACC_NR," ")  
  INTO :ls_agent_Sno  
  FROM AGENTS  
  WHERE AGENTS.AGENT_NR = :istr_parm.agent_no ;
  
SELECT isNull(CHART.NOM_ACC_NR," "),  
       isNull(TCOWNERS.NOM_ACC_NR," ")
	INTO :ls_charterer_Sno,
		  :ls_Owner_Sno
    FROM CHART,   
         NTC_PAYMENT,   
         NTC_TC_CONTRACT,   
         TCOWNERS  
   WHERE ( NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID ) and  
         ( NTC_TC_CONTRACT.CHART_NR *= CHART.CHART_NR) and  
         ( TCOWNERS.TCOWNER_NR =* NTC_TC_CONTRACT.TCOWNER_NR) and  
         ( ( NTC_PAYMENT.PAYMENT_ID = :ll_paymentID ) )   ;

if (ls_Agent_Sno = ls_charterer_Sno) or (ls_Agent_Sno = ls_owner_Sno) then
	ls_warning = "Agent is the same as Charterer / Owner (S# equal)"
	dw_disbursement_info.setitem(1, "warning", ls_warning)
end if
  
  



end subroutine

public function integer wf_check_exchange_rate ();LONG ll_paymentID, ll_row, ll_rows
STRING ls_curr

IF istr_parm.dw_tc_exp.RowCount() > 0 THEN
	ll_paymentID = istr_parm.dw_tc_exp.getItemNumber(1, "payment_id")


SELECT NTC_TC_CONTRACT.CURR_CODE
	INTO :ls_curr
    FROM NTC_PAYMENT,   
         NTC_TC_CONTRACT
   WHERE ( NTC_TC_CONTRACT.CONTRACT_ID = NTC_PAYMENT.CONTRACT_ID ) AND
         ( ( NTC_PAYMENT.PAYMENT_ID = :ll_paymentID ) )
	COMMIT;

ll_rows = istr_parm.dw_tc_exp.RowCount()
FOR ll_row = 1 to ll_rows
	IF istr_parm.dw_tc_exp.getItemString(ll_row, "curr_code") <> ls_curr AND istr_parm.dw_tc_exp.getItemNumber(ll_row, "ex_rate_tc") = 100 THEN
		IF MessageBox("Warning","Row " + String(ll_row) + ": Contract Currency is " + ls_curr + " and Port Expense is : " + istr_parm.dw_tc_exp.getItemString(ll_row, "curr_code") + &
			" and you have entered 100 as ex. rate. Is this correct ?!", Question!,YesNo!,2) = 2 THEN
				RETURN -1		
		END IF
	END IF
NEXT	

END IF

RETURN 1
end function

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: w_print_disbursement_account
   <OBJECT> Confirm or cancel settle expenses.</OBJECT>
   <DESC>  </DESC>
   <USAGE> </USAGE>
   <ALSO>   </ALSO>
	<HISTORY>
		Date    		CR-Ref		Author      Comments
		15/04/15  	CR3854		XSZ004		Remove the functionality of expenses transfer to TC-Hire when settle in disbursement.
	</HISTORY>
*********************************************************************************************************/
end subroutine

event open;int li_insertrow

istr_parm = message.PowerObjectParm

dw_disbursement_info.settransobject(sqlca)

li_insertrow = dw_disbursement_info.insertrow(0)

dw_disbursement_info.setitem(li_insertrow, "vessel_nr", istr_parm.vessel_ref_nr)
dw_disbursement_info.setitem(li_insertrow, "vessel_name", istr_parm.vessel_name)
dw_disbursement_info.setitem(li_insertrow, "voyage_nr", string(istr_parm.voyage_nr, "@@@@@-@@"))
dw_disbursement_info.setitem(li_insertrow, "port_code", istr_parm.port_code)
dw_disbursement_info.setitem(li_insertrow, "port_name", istr_parm.port_name)
dw_disbursement_info.setitem(li_insertrow, "pcn", string(istr_parm.pcn))
dw_disbursement_info.setitem(li_insertrow, "agent_name", istr_parm.agent_name)
dw_disbursement_info.modify("datawindow.readonly = yes")



end event

on w_print_disbursement_account.create
int iCurrent
call super::create
this.st_10=create st_10
this.st_9=create st_9
this.st_7=create st_7
this.cb_settle=create cb_settle
this.dw_disbursement_info=create dw_disbursement_info
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_10
this.Control[iCurrent+2]=this.st_9
this.Control[iCurrent+3]=this.st_7
this.Control[iCurrent+4]=this.cb_settle
this.Control[iCurrent+5]=this.dw_disbursement_info
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.gb_1
end on

on w_print_disbursement_account.destroy
call super::destroy
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_7)
destroy(this.cb_settle)
destroy(this.dw_disbursement_info)
destroy(this.cb_cancel)
destroy(this.gb_1)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_print_disbursement_account
end type

type st_10 from statictext within w_print_disbursement_account
boolean visible = false
integer x = 73
integer y = 1768
integer width = 2446
integer height = 512
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 79741120
boolean enabled = false
string text = "Remember to produce debit note in USD (cost in local currency * exch. rate (USD/local currency)) and forward debit note and original vouchers immediately to the Broker involved (who will subsequently follow-up with Charterer). A copy of the debit note and vouchers must be filed with the Disbursement Account, a second copy of debit note and vouchers must be filed in Charterers Account file in Maersk Tankers Finance, and a third copy of the debit note must be placed in ~"sagskonto~"- files in Maersk Tankers Finance. Thereafter update new claim in TRAMOS Claims picture (in local currency, exch. rate USD/local currency from Disbursement Account). Also remember to update T/C-hire picture in TRAMOS to match debit note in USD (since C/A automatically transferred to T/C-hire picture in local currency)."
boolean focusrectangle = false
end type

type st_9 from statictext within w_print_disbursement_account
boolean visible = false
integer x = 73
integer y = 1700
integer width = 869
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 79741120
boolean enabled = false
string text = "Expenses for Charterers Account:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_print_disbursement_account
boolean visible = false
integer x = 69
integer y = 1280
integer width = 791
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16711680
long backcolor = 79741120
boolean enabled = false
string text = "Expenses for Owners Account:"
boolean focusrectangle = false
end type

type cb_settle from commandbutton within w_print_disbursement_account
integer x = 942
integer y = 340
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Settle"
boolean default = true
end type

event clicked;CloseWithReturn(parent, 1)


end event

type dw_disbursement_info from mt_u_datawindow within w_print_disbursement_account
integer x = 50
integer y = 56
integer width = 1554
integer height = 256
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ex_ff_disbursement_info"
boolean border = false
borderstyle borderstyle = stylebox!
end type

type cb_cancel from commandbutton within w_print_disbursement_account
integer x = 1289
integer y = 340
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;CloseWithReturn(parent, 0)
end event

type gb_1 from groupbox within w_print_disbursement_account
integer x = 37
integer y = 8
integer width = 1595
integer height = 320
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "About to Settle "
end type

