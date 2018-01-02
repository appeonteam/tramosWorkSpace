$PBExportHeader$w_modify_transfer_comment.srw
$PBExportComments$This window is used to modify payment transfer comments.
forward
global type w_modify_transfer_comment from mt_w_response
end type
type st_1 from statictext within w_modify_transfer_comment
end type
type cb_cancel from commandbutton within w_modify_transfer_comment
end type
type cb_ok from commandbutton within w_modify_transfer_comment
end type
type mle_comment from multilineedit within w_modify_transfer_comment
end type
type dw_payment from datawindow within w_modify_transfer_comment
end type
end forward

global type w_modify_transfer_comment from mt_w_response
integer width = 3387
integer height = 1480
string title = "Modify Transfer Comment"
st_1 st_1
cb_cancel cb_cancel
cb_ok cb_ok
mle_comment mle_comment
dw_payment dw_payment
end type
global w_modify_transfer_comment w_modify_transfer_comment

type variables
long		il_paymentID[3]
boolean	ib_from_previous=false, ib_to_next=false
end variables

forward prototypes
public function integer wf_retrieve ()
public subroutine documentation ()
end prototypes

public function integer wf_retrieve ();long 		ll_contractID
boolean	lb_first=false, lb_last=false

SELECT CONTRACT_ID
	INTO :ll_contractID
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID = :il_paymentID[2];
	
SELECT MAX(PAYMENT_ID)
	INTO :il_paymentID[1]
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID < :il_paymentID[2]
	AND CONTRACT_ID = :ll_contractID;
if SQLCA.SQLCode = 100 or isnull(il_paymentID[1]) then lb_first=true	

SELECT MIN(PAYMENT_ID)
	INTO :il_paymentID[3]
	FROM NTC_PAYMENT
	WHERE PAYMENT_ID > :il_paymentID[2]
	AND CONTRACT_ID = :ll_contractID;
if SQLCA.SQLCode = 100 or isnull(il_paymentID[3]) then lb_last=true	

dw_payment.retrieve(il_paymentID)
if lb_first then dw_payment.insertRow(1)
if lb_last then dw_payment.insertrow(0)

if dw_payment.rowcount() <> 3 then 
	MessageBox("Error", "Something went wrong when trying to retrieve data. contact System Administrator")
	return -1
end if

if dw_payment.getItemDecimal(2, "transfer_from_previous") <> 0 then
	mle_comment.text = dw_payment.getItemString(2, "transfer_comment_previous")
	ib_from_previous = true
	ib_to_next = false
elseif dw_payment.getItemDecimal(2, "transfer_to_next") <> 0 then
	mle_comment.text = dw_payment.getItemString(2, "transfer_comment_next")
	ib_from_previous = false
	ib_to_next = true
else
	mle_comment.text = ""
	ib_from_previous = false
	ib_to_next = false
end if

return 1
end function

public subroutine documentation ();/********************************************************************
	w_modify_transfer_comment
	
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

on w_modify_transfer_comment.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.mle_comment=create mle_comment
this.dw_payment=create dw_payment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.mle_comment
this.Control[iCurrent+5]=this.dw_payment
end on

on w_modify_transfer_comment.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.mle_comment)
destroy(this.dw_payment)
end on

event open;il_paymentID[2] = message.doubleParm

move(200,50)
dw_payment.setTransObject(SQLCA)
post wf_retrieve()
end event

type st_1 from statictext within w_modify_transfer_comment
integer x = 27
integer y = 896
integer width = 782
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Click on Comment and edit it below:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_modify_transfer_comment
integer x = 2299
integer y = 1160
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_ok from commandbutton within w_modify_transfer_comment
integer x = 2299
integer y = 1000
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
end type

event clicked;if ib_from_previous then
	dw_payment.setItem(1, "transfer_comment_next", mle_comment.text) 
	dw_payment.setItem(2, "transfer_comment_previous", mle_comment.text)
	dw_payment.accepttext()
end if

if ib_to_next then
	dw_payment.setItem(2, "transfer_comment_next", mle_comment.text) 
	dw_payment.setItem(3, "transfer_comment_previous", mle_comment.text)
	dw_payment.accepttext()
end if

if dw_payment.update() = 1 then
	commit;
	close(parent)
else
	MessageBox("Update Error", "Error while updating transfer comments")
	rollback;
end if
end event

type mle_comment from multilineedit within w_modify_transfer_comment
integer x = 27
integer y = 976
integer width = 2121
integer height = 344
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_payment from datawindow within w_modify_transfer_comment
integer x = 27
integer y = 28
integer width = 3328
integer height = 836
integer taborder = 10
string title = "none"
string dataobject = "d_modify_transfer_comment"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row < 1 then return

if dwo.name = "transfer_comment_previous" then
	if this.getItemDecimal(2, "transfer_from_previous") <> 0 then
		mle_comment.text = this.getItemString(2, "transfer_comment_previous")
		ib_from_previous = true
		ib_to_next = false
	else
		mle_comment.text = ""
		ib_from_previous = false
		ib_to_next = false
	end if
elseif dwo.name = "transfer_comment_next" then
	if this.getItemDecimal(2, "transfer_to_next") <> 0 then
		mle_comment.text = this.getItemString(2, "transfer_comment_next")
		ib_from_previous = false
		ib_to_next = true
	else
		mle_comment.text = ""
		ib_from_previous = false
		ib_to_next = false
	end if
end if

end event

