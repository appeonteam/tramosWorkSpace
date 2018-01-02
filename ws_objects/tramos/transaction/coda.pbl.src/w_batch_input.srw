$PBExportHeader$w_batch_input.srw
$PBExportComments$When port expenses are settled via batch, the user have to enter Agent voucher no, DB2 control code and document date.
forward
global type w_batch_input from mt_w_response
end type
type dw_date from datawindow within w_batch_input
end type
type cb_cancel from commandbutton within w_batch_input
end type
type cb_ok from commandbutton within w_batch_input
end type
type sle_control_no from singlelineedit within w_batch_input
end type
type sle_voucher_no from singlelineedit within w_batch_input
end type
type st_4 from statictext within w_batch_input
end type
type st_3 from statictext within w_batch_input
end type
type st_2 from statictext within w_batch_input
end type
type st_1 from statictext within w_batch_input
end type
end forward

global type w_batch_input from mt_w_response
integer x = 1074
integer y = 484
integer width = 2290
integer height = 972
string title = "Batch User Input"
long backcolor = 79741120
dw_date dw_date
cb_cancel cb_cancel
cb_ok cb_ok
sle_control_no sle_control_no
sle_voucher_no sle_voucher_no
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_batch_input w_batch_input

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();
/********************************************************************
	w_batch_input
	
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

on w_batch_input.create
int iCurrent
call super::create
this.dw_date=create dw_date
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.sle_control_no=create sle_control_no
this.sle_voucher_no=create sle_voucher_no
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_date
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.sle_control_no
this.Control[iCurrent+5]=this.sle_voucher_no
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
end on

on w_batch_input.destroy
call super::destroy
destroy(this.dw_date)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.sle_control_no)
destroy(this.sle_voucher_no)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;dw_date.InsertRow(0)
end event

type dw_date from datawindow within w_batch_input
integer x = 1001
integer y = 504
integer width = 293
integer height = 76
integer taborder = 30
string dataobject = "d_date"
boolean livescroll = true
end type

type cb_cancel from commandbutton within w_batch_input
integer x = 1239
integer y = 696
integer width = 370
integer height = 108
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;s_batch_input lstr_batch_input

/* Return NULL to calling function */
setNull(lstr_batch_input.voucher_no)
setNull(lstr_batch_input.control_no)
setNull(lstr_batch_input.docdate)

CloseWithReturn( parent, lstr_batch_input)

end event

type cb_ok from commandbutton within w_batch_input
integer x = 649
integer y = 692
integer width = 370
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event clicked;s_batch_input lstr_batch_input

/* Valider Agent voucher no. */
IF IsNull(sle_voucher_no.text) OR (len(sle_voucher_no.text) < 1) THEN
	MessageBox("Validation error","Please entered a valid Agent Voucher No.")
	Return
END IF
	
/* Valider Control no. */
IF IsNull(sle_control_no.text) OR (len(sle_control_no.text) < 1) THEN
	MessageBox("Validation error","Please entered a valid DB2 Control No.")
	Return
END IF

/* Valider om den indtastede dato er en dato */
dw_date.AcceptText()
IF IsNull(dw_date.getItemDate(1,"date_value")) THEN
	MessageBox("Validation error","Entered document date is not a correct date")
	Return
END IF

/* Return entered values to calling function */
lstr_batch_input.voucher_no = sle_voucher_no.text
lstr_batch_input.control_no = sle_control_no.text
lstr_batch_input.docdate = dw_date.getItemDate(1,"date_value")

CloseWithReturn( parent, lstr_batch_input)

end event

type sle_control_no from singlelineedit within w_batch_input
integer x = 1001
integer y = 396
integer width = 631
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean autohscroll = false
end type

type sle_voucher_no from singlelineedit within w_batch_input
integer x = 1001
integer y = 284
integer width = 631
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean autohscroll = false
end type

type st_4 from statictext within w_batch_input
integer x = 407
integer y = 504
integer width = 549
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Document Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_batch_input
integer x = 347
integer y = 396
integer width = 608
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "DB2 Control No.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_batch_input
integer x = 402
integer y = 284
integer width = 553
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Agent Voucher No.:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_batch_input
integer x = 311
integer y = 64
integer width = 1573
integer height = 156
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 79741120
boolean enabled = false
string text = "Please enter information from front-page (Accounting -> MT):"
boolean focusrectangle = false
end type

