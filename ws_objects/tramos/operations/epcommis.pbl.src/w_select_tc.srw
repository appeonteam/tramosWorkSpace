$PBExportHeader$w_select_tc.srw
$PBExportComments$Window to create commissions for TC-hire
forward
global type w_select_tc from w_vessel_response
end type
type cb_ok from commandbutton within w_select_tc
end type
type cb_cancel from commandbutton within w_select_tc
end type
type st_1 from statictext within w_select_tc
end type
type sle_invoice from singlelineedit within w_select_tc
end type
type st_2 from statictext within w_select_tc
end type
type sle_amount from singlelineedit within w_select_tc
end type
type uo_freight from uo_freight_balance within w_select_tc
end type
type cbx_settle_via_batch from checkbox within w_select_tc
end type
type gb_1 from groupbox within w_select_tc
end type
type gb_2 from groupbox within w_select_tc
end type
type dw_tc_list from uo_datawindow within w_select_tc
end type
end forward

global type w_select_tc from w_vessel_response
integer width = 1646
integer height = 1468
string title = "Create commission"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
sle_invoice sle_invoice
st_2 st_2
sle_amount sle_amount
uo_freight uo_freight
cbx_settle_via_batch cbx_settle_via_batch
gb_1 gb_1
gb_2 gb_2
dw_tc_list dw_tc_list
end type
global w_select_tc w_select_tc

type variables
s_create_commission is_create_commission
Long il_broker_nr
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
	w_select_tc
	
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

il_broker_nr = message.Doubleparm

// Set SQLCA, and "reset" s_create_commission

is_create_commission.s_invoice = "Martin"

dw_tc_list.ib_auto = True
dw_tc_list.SetTransObject ( SQLCA )

uo_vesselselect.of_registerwindow( w_select_tc )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
end event

on w_select_tc.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.sle_invoice=create sle_invoice
this.st_2=create st_2
this.sle_amount=create sle_amount
this.uo_freight=create uo_freight
this.cbx_settle_via_batch=create cbx_settle_via_batch
this.gb_1=create gb_1
this.gb_2=create gb_2
this.dw_tc_list=create dw_tc_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_invoice
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_amount
this.Control[iCurrent+7]=this.uo_freight
this.Control[iCurrent+8]=this.cbx_settle_via_batch
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.dw_tc_list
end on

on w_select_tc.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.sle_invoice)
destroy(this.st_2)
destroy(this.sle_amount)
destroy(this.uo_freight)
destroy(this.cbx_settle_via_batch)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.dw_tc_list)
end on

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve")
end event

event ue_retrieve;call super::ue_retrieve;Long ll_No_Claims

ll_No_Claims = dw_tc_list.retrieve ( ii_vessel_nr,il_broker_nr )

// *************************** FILTER ******************************
string ls_filter
ls_filter = "broker1="+string(il_broker_nr)+" OR "+ "broker2="+string(il_broker_nr)
dw_tc_list.SetFilter(ls_filter)
dw_tc_list.Filter()
// **********************************************************************

If ll_no_Claims > 0 Then
	// If no. of claims is > 0, then select the lastest

	dw_tc_list.ScrollToRow(ll_No_Claims)
	dw_tc_list.SelectRow(0,False)
	dw_tc_list.SelectRow(ll_No_Claims,True)
	dw_tc_list.TriggerEvent(Clicked!)
	dw_tc_list.Setfocus()
Else
	// otherwise disable sle_amount, sle_invoice and cb_ok

	disableedit ( sle_amount )
	disableedit ( sle_invoice )

	cb_ok.enabled = False
End if  



end event

type uo_vesselselect from w_vessel_response`uo_vesselselect within w_select_tc
integer x = 41
integer y = 52
end type

type cb_ok from commandbutton within w_select_tc
integer x = 1061
integer y = 1272
integer width = 238
integer height = 80
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
1/1-96		1.0	MI		Initial version
11-12-97		1.1	TA  	Invoice text takes the setoff date instead of todays date
************************************************************************************/

Long ll_Row
Integer li_count, li_index

if isNumber ( sle_amount.text ) Then
	// Is sle_amount contains a valid number, everything is ok, sendback data in s_create_commission
 
	ll_Row = dw_tc_List.GetRow ()

	is_create_commission.i_vessel_No = uo_global.GetVessel_Nr()
	setnull(is_create_commission.s_voyage_no)
//	is_create_commission.s_invoice = sle_invoice.text
	is_create_commission.d_amount = double ( sle_amount.text )
	is_create_commission.dt_cp_date = dw_tc_list.GetItemDateTime(ll_Row, "tchires_tchire_cp_date")

	SetNull(is_create_commission.l_claim_No)

   // Get set off date.
	S_EXPENSES_OFFHIRES parameter
	parameter.vessel_nr = is_create_commission.i_vessel_No
	parameter.cp_date = is_create_commission.dt_cp_date

	OpenWithParm(w_select_setoffdate,parameter)

	STRING setoffdate_s, ls_invoice_text
	DATETIME setoffdate
	
	// From w_select_setoffdate
	setoffdate_s = Message.StringParm
	
	// Insert setoffdate into invoice text field
	If cbx_settle_via_batch.checked then 
		li_index = 1
//		FOR li_count = 1 TO 3
//			ls_invoice_text += mid(setoffdate_s,li_index,2)
//			li_index += 3
//		NEXT
		ls_invoice_text = String(Date(setoffdate_s),"dd-mm-yy")
		sle_invoice.text = "BATCH" + ls_invoice_text
	End if
	// Check if invoice number OK
	IF len(sle_invoice.text) < 1 THEN
		MessageBox ( "Error" , "Please, enter invoice number" )
		return
	END IF
	
	is_create_commission.s_invoice = sle_invoice.text

	IF IsDate(setoffdate_s) THEN
		setoffdate = DateTime(Date(setoffdate_s), Time(0,0,0))
		is_create_commission.set_off_dt = setoffdate
	ELSE
		Messagebox("","You must choose a set off date. Click Ok again.")
		Return
	END IF

	CloseWithReturn(Parent, is_create_commission)
	Return

Else
	// Otherwise signal an error, and dont close this window

	MessageBox ( "Error" , "Amount error " )
End if
end event

type cb_cancel from commandbutton within w_select_tc
integer x = 1335
integer y = 1272
integer width = 238
integer height = 80
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

type st_1 from statictext within w_select_tc
integer x = 55
integer y = 1032
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

type sle_invoice from singlelineedit within w_select_tc
integer x = 238
integer y = 1016
integer width = 603
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

type st_2 from statictext within w_select_tc
integer x = 992
integer y = 1032
integer width = 247
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

type sle_amount from singlelineedit within w_select_tc
integer x = 1230
integer y = 1016
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

type uo_freight from uo_freight_balance within w_select_tc
boolean visible = false
integer x = 73
integer y = 384
integer width = 530
integer height = 512
integer taborder = 80
boolean enabled = false
end type

on uo_freight.destroy
call uo_freight_balance::destroy
end on

type cbx_settle_via_batch from checkbox within w_select_tc
integer x = 55
integer y = 1128
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

event clicked;/************************************************************************************

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
20/6-96                                    LN           day,month text addition  
************************************************************************************/
Integer li_month, li_day
String ls_batch_text

li_month = Month(Today())
li_day = Day(Today())
//ls_batch_text =  "25BATCH" + String(li_day) + "-" + String(li_month)

sle_invoice.enabled = not this.checked

//if this.checked then sle_invoice.text = ls_batch_text else sle_invoice.text = ""
//

end event

type gb_1 from groupbox within w_select_tc
integer x = 18
integer y = 16
integer width = 1591
integer height = 912
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

type gb_2 from groupbox within w_select_tc
integer x = 18
integer y = 936
integer width = 1591
integer height = 304
integer taborder = 90
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

type dw_tc_list from uo_datawindow within w_select_tc
integer x = 55
integer y = 284
integer width = 1518
integer height = 604
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_tc_list"
end type

on clicked;call uo_datawindow::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_tc from w_vessel_response
  
 Object     : dw_tc_list
  
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
Decimal {2} ld_freight

ll_Row = GetRow ()

If ll_Row > 0 Then

	// enable amount edit,  invoice edit and ok button

	enableedit ( sle_invoice )
	enableedit ( sle_amount )

	cb_ok.enabled = True


//	If GetItemString (ll_Row, "CLAIMS_CLAIM_TYPE") = "FRT" Then
//
//		// If its a freight claim, then calculate the amount from claims
//
//		ld_Freight  = uo_freight.uf_calculate_balance ( GetItemNumber (ll_Row, "CLAIMS_VESSEL_NR") , &
//        	                                                          GetItemString (ll_Row, "VOYAGE_NR"), & 
//	                                                                  GetItemNumber (ll_Row, "CLAIMS_CHART_NR"),  &
//        	                                                          GetItemNumber (ll_Row, "CLAIMS_CLAIM_NR") )
// 
//		sle_amount.text = String  ( (  uo_freight.uf_get_freight () *  &
//                                    GetItemNumber( ll_row, "FREIGHT_CLAIMS_FREIGHT_B_COM" )) / 100, "#,###.##" )
//
//	Else
//		// otherwise set amount to nothing
//
//		sle_amount.text = ""
//	End if
End if
end on

