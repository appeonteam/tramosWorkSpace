$PBExportHeader$w_payment_invoice_nr.srw
$PBExportComments$This window is used when settling agent payments to get invoice number.
forward
global type w_payment_invoice_nr from mt_w_response
end type
type cb_1 from commandbutton within w_payment_invoice_nr
end type
type sle_invoice_nr from singlelineedit within w_payment_invoice_nr
end type
type st_1 from statictext within w_payment_invoice_nr
end type
end forward

global type w_payment_invoice_nr from mt_w_response
integer x = 914
integer y = 672
integer width = 1413
integer height = 856
string title = "Enter Invoice Number"
boolean controlmenu = false
long backcolor = 79741120
cb_1 cb_1
sle_invoice_nr sle_invoice_nr
st_1 st_1
end type
global w_payment_invoice_nr w_payment_invoice_nr

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_payment_invoice_nr
	
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

on w_payment_invoice_nr.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.sle_invoice_nr=create sle_invoice_nr
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_invoice_nr
this.Control[iCurrent+3]=this.st_1
end on

on w_payment_invoice_nr.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.sle_invoice_nr)
destroy(this.st_1)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_payment_invoice_nr
end type

type cb_1 from commandbutton within w_payment_invoice_nr
integer x = 389
integer y = 548
integer width = 562
integer height = 108
integer taborder = 2
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Transfer Payment"
boolean default = true
end type

event clicked;string ls_invoice_nr

ls_invoice_nr = sle_invoice_nr.text

IF LEN(ls_invoice_nr) = 0 THEN
	SetNull(ls_invoice_nr)
END IF

CloseWithReturn(parent, ls_invoice_nr)
end event

type sle_invoice_nr from singlelineedit within w_payment_invoice_nr
integer x = 82
integer y = 380
integer width = 1198
integer height = 92
integer taborder = 1
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16777215
boolean autohscroll = false
end type

type st_1 from statictext within w_payment_invoice_nr
integer x = 91
integer y = 96
integer width = 1193
integer height = 216
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "If you have an invoice number, please enter it in the field below. Otherwise the invoice number will be ~"Maerskdd/mm-yyyy~". Date is today."
boolean focusrectangle = false
end type

