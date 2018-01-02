$PBExportHeader$w_disb_last_payment.srw
$PBExportComments$This window lets the user enter the last payment when settling an agent.
forward
global type w_disb_last_payment from mt_w_response
end type
type cb_cancel from commandbutton within w_disb_last_payment
end type
type cb_update from commandbutton within w_disb_last_payment
end type
type dw_disb_payments from uo_datawindow within w_disb_last_payment
end type
end forward

global type w_disb_last_payment from mt_w_response
integer x = 672
integer y = 264
integer width = 1769
integer height = 472
string title = "Last Payment"
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
cb_cancel cb_cancel
cb_update cb_update
dw_disb_payments dw_disb_payments
end type
global w_disb_last_payment w_disb_last_payment

type variables
s_disbursement lstr_disb
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_validate ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_disb_last_payment
   <OBJECT> Last Payment window</OBJECT>
   <DESC>  </DESC>
   <USAGE> </USAGE>
   <ALSO>  </ALSO>
	<HISTORY>
		Date    		Ref    	Author		Comments
		28/04/15		CR3854	XSZ004		Adjust UI.
	<HISTORY>
********************************************************************/
end subroutine

public function integer wf_validate ();/********************************************************************
   wf_validate
   <DESC>	Validate the payment	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed         
   </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>  When new a payment  </USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		28/04/15		CR3854		XSZ004		First version.
   </HISTORY>
********************************************************************/

integer li_return
string  ls_message, ls_column_name

dw_disb_payments.accepttext()

if isnull(dw_disb_payments.getitemdatetime(1, "payment_date")) then
	ls_message      = "Please enter payment date."
	ls_column_name  = "payment_date"
elseif isnull(dw_disb_payments.getitemnumber(1, "payment_amount")) then
	ls_message      = "Please enter payment amount."
	ls_column_name  = "payment_amount"
elseif isnull(dw_disb_payments.getitemnumber(1, "disb_payments_payment_type")) then
	ls_message      = "Please select payment type."
	ls_column_name  = "disb_payments_payment_type"
end if

if ls_message <> "" then
	messagebox("Validation Error", ls_message)
	li_return = c#return.failure
	dw_disb_payments.setcolumn(ls_column_name)
	dw_disb_payments.setfocus()
else
	li_return = c#return.success
end if

return li_return
end function

event open;lstr_disb = Message.PowerObjectParm


dw_disb_payments.SetTransObject(SQLCA)
dw_disb_payments.InsertRow(0)
dw_disb_payments.SetItem(1,"payment_Date",RelativeDate ( Today(), 1 ))
dw_disb_payments.SetItem(1,"payment_amount",lstr_disb.last_payment)

dw_disb_payments.SetItem(1,"vessel_nr",lstr_disb.vessel_nr)
dw_disb_payments.SetItem(1,"voyage_nr",lstr_disb.voyage_nr)
dw_disb_payments.SetItem(1,"port_code",lstr_disb.port_code)
dw_disb_payments.SetItem(1,"pcn",lstr_disb.pcn)
dw_disb_payments.SetItem(1,"agent_nr",lstr_disb.agent_nr)

if lstr_disb.is_batch then
	dw_disb_payments.SetItem(1,"payment_desc","Notice - automatic batch payment, not printed!")
	dw_disb_payments.SetItem(1,"disb_payments_payment_print_date",today())
end if

dw_disb_payments.SetFocus()
dw_disb_payments.SetColumn("disb_payments_payment_type")

end event

on w_disb_last_payment.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_disb_payments=create dw_disb_payments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.dw_disb_payments
end on

on w_disb_last_payment.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_disb_payments)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_disb_last_payment
end type

type cb_cancel from commandbutton within w_disb_last_payment
integer x = 1385
integer y = 276
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event clicked;string   ls_payment_desc
integer  li_payment_type
decimal  ld_payment_amount
datetime ldt_payment_date

setnull(ls_payment_desc)
setnull(ldt_payment_date)
setnull(li_payment_type)
setnull(ld_payment_amount)

dw_disb_payments.setitem(1, "payment_date", ldt_payment_date)
dw_disb_payments.setitem(1, "payment_amount", ld_payment_amount)
dw_disb_payments.setitem(1, "payment_desc", ls_payment_desc)
dw_disb_payments.setitem(1, "disb_payments_payment_type", li_payment_type)
end event

type cb_update from commandbutton within w_disb_last_payment
integer x = 1038
integer y = 276
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
boolean default = true
end type

event clicked;int li_next_payment_counter

if wf_validate() = c#return.failure then
	return
end if

SELECT max(PAYMENT_COUNTER) INTO :li_next_payment_counter
FROM   DISB_PAYMENTS
WHERE  VESSEL_NR = :lstr_disb.vessel_nr AND VOYAGE_NR = :lstr_disb.voyage_nr AND
       PORT_CODE = :lstr_disb.port_code AND PCN = :lstr_disb.pcn AND
       AGENT_NR = :lstr_disb.agent_nr;

IF IsNull( li_next_payment_counter) THEN 
	dw_disb_payments.SetItem(1,"payment_counter",1)
	lstr_disb.payment_counter = 1
ELSE
	dw_disb_payments.SetItem(1,"payment_counter",li_next_payment_counter + 1)
	lstr_disb.payment_counter = li_next_payment_counter + 1
END IF


IF dw_disb_payments.Update() = 1 THEN
	Commit;
	CloseWithReturn(Parent, 1)

ELSE
	Rollback;
	CloseWithReturn(Parent, -1)
END IF
end event

type dw_disb_payments from uo_datawindow within w_disb_last_payment
integer y = 32
integer width = 1755
integer height = 272
integer taborder = 10
string dataobject = "dw_disb_payments"
boolean border = false
end type

