$PBExportHeader$w_select_claim.srw
$PBExportComments$Window to create commissions
forward
global type w_select_claim from w_vessel_response
end type
type dw_claim_list from uo_datawindow within w_select_claim
end type
type cb_ok from commandbutton within w_select_claim
end type
type cb_cancel from commandbutton within w_select_claim
end type
type st_1 from statictext within w_select_claim
end type
type sle_invoice from singlelineedit within w_select_claim
end type
type st_2 from statictext within w_select_claim
end type
type sle_amount from singlelineedit within w_select_claim
end type
type uo_freight from uo_freight_balance within w_select_claim
end type
type cbx_settle_via_batch from checkbox within w_select_claim
end type
type st_currency from statictext within w_select_claim
end type
type gb_1 from groupbox within w_select_claim
end type
type gb_2 from groupbox within w_select_claim
end type
end forward

global type w_select_claim from w_vessel_response
integer width = 1582
integer height = 1404
string title = "Create commission"
dw_claim_list dw_claim_list
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
sle_invoice sle_invoice
st_2 st_2
sle_amount sle_amount
uo_freight uo_freight
cbx_settle_via_batch cbx_settle_via_batch
st_currency st_currency
gb_1 gb_1
gb_2 gb_2
end type
global w_select_claim w_select_claim

type variables
s_create_commission is_create_commission
end variables

forward prototypes
public subroutine disableedit (ref singlelineedit acontrol)
public subroutine enableedit (ref singlelineedit acontrol)
public subroutine documentation ()
end prototypes

public subroutine disableedit (ref singlelineedit acontrol);acontrol.backcolor = RGB ( 0, 255, 255 )
acontrol.displayOnly = True
end subroutine

public subroutine enableedit (ref singlelineedit acontrol);acontrol.displayonly = False
acontrol.backColor = RGB ( 255, 255, 255 )
end subroutine

public subroutine documentation ();/********************************************************************
	w_select_claim
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	   22/07/16     CR4307   SSX014   Use Set Ex Rate
	</HISTORY>
********************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_claim from w_vessel_response
  
 Object     : 
  
 Event	 :  Open

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Selects (or rather creates) commissions from claims

 Arguments : None

 Returns   : s_create_commission

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

// Set SQLCA, and "reset" s_create_commission

is_create_commission.s_invoice = "Martin"

dw_claim_list.ib_auto = True
dw_claim_list.SetTransObject ( SQLCA )

uo_vesselselect.of_registerwindow( w_select_claim)
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

is_create_commission.i_vessel_no = 0

end event

on w_select_claim.create
int iCurrent
call super::create
this.dw_claim_list=create dw_claim_list
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.sle_invoice=create sle_invoice
this.st_2=create st_2
this.sle_amount=create sle_amount
this.uo_freight=create uo_freight
this.cbx_settle_via_batch=create cbx_settle_via_batch
this.st_currency=create st_currency
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_claim_list
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_invoice
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_amount
this.Control[iCurrent+8]=this.uo_freight
this.Control[iCurrent+9]=this.cbx_settle_via_batch
this.Control[iCurrent+10]=this.st_currency
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_select_claim.destroy
call super::destroy
destroy(this.dw_claim_list)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.sle_invoice)
destroy(this.st_2)
destroy(this.sle_amount)
destroy(this.uo_freight)
destroy(this.cbx_settle_via_batch)
destroy(this.st_currency)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;long ll_no_claims 

ll_No_Claims = dw_claim_list.retrieve ( ii_Vessel_Nr )

If ll_no_Claims > 0 Then
	// If no. of claims is > 0, then select the lastest

	dw_claim_list.ScrollToRow(ll_No_Claims)
	dw_claim_list.SelectRow(0,False)
	dw_claim_list.SelectRow(ll_No_Claims,True)
	dw_claim_list.TriggerEvent(Clicked!)
	dw_claim_list.Setfocus()
Else
	// otherwise disable sle_amount, sle_invoice and cb_ok

	disableedit ( sle_amount )
	disableedit ( sle_invoice )

	cb_ok.enabled = False
End if  



end event

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve" )
end event

event close;call super::close;CloseWithReturn(this, is_create_commission)
end event

type st_hidemenubar from w_vessel_response`st_hidemenubar within w_select_claim
end type

type uo_vesselselect from w_vessel_response`uo_vesselselect within w_select_claim
integer x = 41
integer y = 48
end type

type dw_claim_list from uo_datawindow within w_select_claim
event ue_clicked pbm_custom01
integer x = 55
integer y = 348
integer width = 1445
integer height = 448
integer taborder = 30
string dataobject = "dw_claim_list"
boolean vscrollbar = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_claim from w_vessel_response
  
 Object     : dw_claim_list
  
 Event	 : Pushed!

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Set buttons etc. when claim is selected

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

Long ll_Row
Decimal {2} ld_freight,ld_tmp

ll_Row = GetRow ()

If ll_Row > 0 Then

	// enable amount edit,  invoice edit and ok button

	enableedit ( sle_invoice )
	enableedit ( sle_amount )
	st_currency.text = dw_claim_list.getitemstring(ll_Row, "claims_curr_code")
	
	cb_ok.enabled = True


	If GetItemString (ll_Row, "CLAIMS_CLAIM_TYPE") = "FRT" Then

		// If its a freight claim, then calculate the amount from claims

		ld_Freight  = uo_freight.uf_calculate_balance ( GetItemNumber (ll_Row, "CLAIMS_VESSEL_NR") , &
        	                                                          GetItemString (ll_Row, "VOYAGE_NR"), & 
	                                                                  GetItemNumber (ll_Row, "CLAIMS_CHART_NR"),  &
        	                                                          GetItemNumber (ll_Row, "CLAIMS_CLAIM_NR") )
		
		ld_tmp = GetItemNumber(ll_row, "claims_broker_com")
		If isNull(ld_tmp) Then ld_tmp = 0
		sle_amount.text = String  ( (  uo_freight.uf_get_freight () *  ld_tmp) / 100, "#,##0.00" )

	Else
		// otherwise set amount to nothing

		sle_amount.text = ""
	End if
End if
end event

type cb_ok from commandbutton within w_select_claim
integer x = 841
integer y = 1196
integer width = 343
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&OK"
boolean default = true
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_claim from w_vessel_response
  
 Object     : cb_ok
  
 Event	 : Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Ok button for this window. Sendback data in s_create_commission,  if data ok !

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

long ll_Row
decimal 	ld_rate
n_exchangerate	lnv_exchangerate
integer li_vessel_nr
string ls_voyage_nr
integer li_chart_nr
integer li_claim_nr
string ls_claim_type
long ll_cerp_id
string ls_currcode
n_claimcurrencyadjust lnv_claimcurrencyadjust

IF len(sle_invoice.text) < 1 THEN
	MessageBox ( "Error" , "Please, enter invoice number" )
	return
END IF

if isNumber ( sle_amount.text ) Then
	// Is sle_amount contains a valid number, everything is ok, sendback data in s_create_commission
 
	ll_Row = dw_Claim_List.GetRow ()

	is_create_commission.i_vessel_No = uo_global.GetVessel_Nr()
	is_create_commission.s_voyage_no = dw_claim_list.GetItemString ( ll_Row, "VOYAGE_NR" )
	is_create_commission.s_invoice = sle_invoice.text
	is_create_commission.d_amount_local = double ( sle_amount.text )

	is_create_commission.i_chart_No = dw_claim_list.GetItemNumber ( ll_Row, "claims_chart_nr" ) 
	is_create_commission.l_claim_No = dw_claim_list.GetItemNumber ( ll_Row, "claims_claim_nr" )
	is_create_commission.s_curr_code = dw_claim_list.GetItemString ( ll_Row, "claims_curr_code")
		
	if is_create_commission.s_curr_code = "USD" then
		is_create_commission.d_amount = is_create_commission.d_amount_local
	else
		
		li_vessel_nr = dw_claim_list.GetItemNumber(ll_row, "claims_vessel_nr")
		ls_voyage_nr = dw_claim_list.GetItemString ( ll_Row, "VOYAGE_NR" )
		li_chart_nr = dw_claim_list.GetItemNumber(ll_row, "claims_chart_nr")
		li_claim_nr = dw_claim_list.GetItemNumber(ll_row, "claims_claim_nr")
		ls_currcode = dw_claim_list.GetItemString ( ll_Row, "claims_curr_code")
		
		SELECT CAL_CERP_ID, CLAIM_TYPE
			INTO :ll_cerp_id, :ls_claim_type
		FROM CLAIMS
		WHERE VESSEL_NR = :li_vessel_nr
			AND VOYAGE_NR = :ls_voyage_nr
			AND CHART_NR = :li_chart_nr
			AND CLAIM_NR = :li_claim_nr;
			
		lnv_claimcurrencyadjust.of_getsetexrate(li_vessel_nr, ls_voyage_nr, li_chart_nr, ls_claim_type, ll_cerp_id, ls_currcode, ld_rate)
		
		if IsNull(ld_rate) then
			ld_rate = lnv_exchangerate.of_gettodaysusdrate( is_create_commission.s_curr_code )
		end if
		
		is_create_commission.d_amount = is_create_commission.d_amount_local * (ld_rate/100)

	end if

	CloseWithReturn(Parent, is_create_commission)
	Return

Else
	// Otherwise signal an error, and dont close this window

	MessageBox ( "Error" , "Amount error " )
End if
end event

type cb_cancel from commandbutton within w_select_claim
integer x = 1193
integer y = 1196
integer width = 343
integer height = 100
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_claim from w_vessel_response
  
 Object     : cb_cancel
  
 Event	 : Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Cancel control

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

// Set vessel_no in s_create_commission to 0 and return

is_create_commission.i_vessel_no = 0

CloseWithReturn ( Parent, is_create_commission)
Return
end event

type st_1 from statictext within w_select_claim
integer x = 55
integer y = 948
integer width = 183
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "&Invoice:"
boolean focusrectangle = false
end type

type sle_invoice from singlelineedit within w_select_claim
integer x = 233
integer y = 932
integer width = 617
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
boolean autohscroll = false
boolean displayonly = true
end type

type st_2 from statictext within w_select_claim
integer x = 850
integer y = 948
integer width = 265
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "&Amount:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_amount from singlelineedit within w_select_claim
integer x = 1083
integer y = 932
integer width = 293
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
boolean autohscroll = false
boolean displayonly = true
end type

type uo_freight from uo_freight_balance within w_select_claim
boolean visible = false
integer x = 73
integer y = 540
integer width = 530
integer height = 512
integer taborder = 80
boolean enabled = false
end type

on uo_freight.destroy
call uo_freight_balance::destroy
end on

type cbx_settle_via_batch from checkbox within w_select_claim
integer x = 55
integer y = 1044
integer width = 439
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Settle via batch"
end type

on clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_claim from w_vessel_response
  
 Object     : cbx_settle_via_batch
  
 Event	 : Clicked

 Scope     : Local

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Set invoice_nr to "25BATCH + day + month if batch is checked

 Arguments : None

 Returns   : None

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
20/6-96                                   LN            day,month text addition  
************************************************************************************/
Integer li_month, li_day
String ls_batch_text

li_month = Month(Today())
li_day = Day(Today())
ls_batch_text =  "25BATCH" + String(li_day) + "-" + String(li_month)

sle_invoice.enabled = not this.checked

if this.checked then sle_invoice.text = ls_batch_text else sle_invoice.text = ""
end on

type st_currency from statictext within w_select_claim
integer x = 1385
integer y = 948
integer width = 146
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_select_claim
integer x = 18
integer width = 1522
integer height = 836
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

type gb_2 from groupbox within w_select_claim
integer x = 18
integer y = 852
integer width = 1522
integer height = 304
integer taborder = 90
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

