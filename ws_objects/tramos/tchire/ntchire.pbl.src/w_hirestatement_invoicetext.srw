$PBExportHeader$w_hirestatement_invoicetext.srw
forward
global type w_hirestatement_invoicetext from mt_w_response
end type
type dw_invoicetext from mt_u_datawindow within w_hirestatement_invoicetext
end type
type cb_update from mt_u_commandbutton within w_hirestatement_invoicetext
end type
type cb_cancel from mt_u_commandbutton within w_hirestatement_invoicetext
end type
end forward

global type w_hirestatement_invoicetext from mt_w_response
integer width = 3671
integer height = 312
string title = "Hire Statement AX Invoice Text"
dw_invoicetext dw_invoicetext
cb_update cb_update
cb_cancel cb_cancel
end type
global w_hirestatement_invoicetext w_hirestatement_invoicetext

type variables
long il_paymentid
string is_invoicetext
n_messagebox inv_messagebox
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_hirestatement_invoicetext
   <OBJECT>			</OBJECT>
   <USAGE>		Input invoice text			</USAGE>
   <ALSO>		w_tc_payments		</ALSO>
   <HISTORY>
		Date     CR-Ref         Author   Comments
		01/12/17 CR4630         LHG008   Invalid characters in invoice text
   </HISTORY>
********************************************************************/
end subroutine

on w_hirestatement_invoicetext.create
int iCurrent
call super::create
this.dw_invoicetext=create dw_invoicetext
this.cb_update=create cb_update
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_invoicetext
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.cb_cancel
end on

on w_hirestatement_invoicetext.destroy
call super::destroy
destroy(this.dw_invoicetext)
destroy(this.cb_update)
destroy(this.cb_cancel)
end on

event open;call super::open;
il_paymentid = message.Doubleparm
dw_invoicetext.settransobject(sqlca)

dw_invoicetext.retrieve(il_paymentid)
if dw_invoicetext.rowcount() < 1 then
	return
end if
is_invoicetext = dw_invoicetext.getitemstring(1,'ax_invoice_text')
if dw_invoicetext.getitemnumber(1,'payment_status') > 2 then
	cb_update.enabled = false
	cb_cancel.enabled = false
	dw_invoicetext.object.ax_invoice_text.edit.displayonly = 'Yes'
else
	dw_invoicetext.object.ax_invoice_text.edit.displayonly = 'No'
end if



end event

event closequery;call super::closequery;int li_net
dw_invoicetext.accepttext()

if dw_invoicetext.modifiedCount() > 0 then
	li_net = MessageBox("Data not saved", "You have modified Hire Statement AX Invoice Text.~r~n~r~nWould you like to save before continuing?",Exclamation!,YesNoCancel!,1)
	if li_net = 1 then
		if cb_update.event clicked() < 0 then
			return -1
		end if
	elseif li_net = 3 then
		return  -1
	else
		return 0
	end if
end if
return 0
end event

event close;call super::close;message.stringparm = is_invoicetext
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_hirestatement_invoicetext
end type

type dw_invoicetext from mt_u_datawindow within w_hirestatement_invoicetext
event ue_keyenter pbm_dwnprocessenter
integer x = 32
integer y = 16
integer width = 3596
integer height = 84
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_hirestatement_invoicetext"
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event ue_keyenter;//if this.getcolumn = 'ax_invoice_text' then
//	return 1
//end if
end event

event ue_dwkeypress;call super::ue_dwkeypress;//graphicobject	lgo_foucs
//if key = keyenter! then
//	lgo_foucs = getfocus()
////	if lgo_foucs.classname() = 'dw_invoicetext' then
//		send(handle(lgo_foucs),256,9,0)
////	end if
//end if
end event

type cb_update from mt_u_commandbutton within w_hirestatement_invoicetext
integer x = 2940
integer y = 116
integer taborder = 20
boolean bringtotop = true
string text = "&Update"
end type

event clicked;call super::clicked;string ls_text
long ll_rc

dw_invoicetext.accepttext()
ls_text = dw_invoicetext.getitemstring(1,'ax_invoice_text')
ls_text = trim(ls_text)

if not isnull(ls_text) then
	if pos(ls_text, ";") > 0 or pos(ls_text, '；') > 0 &
		or pos(ls_text, '"') > 0 or pos(ls_text, '“') > 0 or pos(ls_text, '”') > 0 then
		inv_messagebox.of_messagebox(inv_messagebox.is_type_validation_error, "Semicolon and double quote are not allowed in the AX invoice text field.", this)
		dw_invoicetext.setcolumn("ax_invoice_text")
		dw_invoicetext.setfocus()
		return -1
	end if
end if

dw_invoicetext.setitem(1,'ax_invoice_text',ls_text)

if dw_invoicetext.update() = 1 then
	commit;
	is_invoicetext = ls_text
else
	Rollback;
	Messagebox("Error message; "+ this.ClassName(), "Update failed")
	return -1
end if

return 1
end event

type cb_cancel from mt_u_commandbutton within w_hirestatement_invoicetext
integer x = 3287
integer y = 116
integer taborder = 30
boolean bringtotop = true
string text = "&Cancel"
end type

event clicked;call super::clicked;dw_invoicetext.retrieve(il_paymentid)

end event

