$PBExportHeader$w_verify_change.srw
$PBExportComments$Utility window called from function f_datastore_spy. Visualize a datastore object.
forward
global type w_verify_change from mt_w_response
end type
type st_rowcount from mt_u_statictext within w_verify_change
end type
type cb_cancel from mt_u_commandbutton within w_verify_change
end type
type st_message from mt_u_statictext within w_verify_change
end type
type cb_ok from mt_u_commandbutton within w_verify_change
end type
type dw_spy from mt_u_datawindow within w_verify_change
end type
end forward

global type w_verify_change from mt_w_response
integer width = 3195
integer height = 1680
string title = "Verify Changes"
boolean controlmenu = false
long backcolor = 32304364
boolean ib_setdefaultbackgroundcolor = true
st_rowcount st_rowcount
cb_cancel cb_cancel
st_message st_message
cb_ok cb_ok
dw_spy dw_spy
end type
global w_verify_change w_verify_change

type variables
s_verify_rejected istr_parm  /* as_message, adw_rejected */
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_verify_change
   <OBJECT>		</OBJECT>
   <USAGE>		</USAGE>
   <ALSO>		</ALSO>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		03/06/14		CR3553		XSZ004		Adjustment window interface			
   </HISTORY>
********************************************************************/
end subroutine

event open;long ll_findrow

istr_parm = message.PowerObjectParm

dw_spy.dataObject = istr_parm.ads_rejected.dataObject

if dw_spy.dataObject = "d_import_notes_rejected" then
	dw_spy.border = true
	st_rowcount.visible = false
	dw_spy.borderstyle = StyleLowered!	
	dw_spy.modify("note.width = 2570")
	dw_spy.modify("note_t.width = 2570")
end if

dw_spy.modify("datawindow.readonly = yes")
dw_spy.modify("DataWindow.Detail.Height = 64")
dw_spy.modify("error_text.visible = 0")

istr_parm.ads_rejected.shareData(dw_spy)
st_message.text = istr_parm.as_message

dw_spy.setFilter(istr_parm.as_filter)
dw_spy.filter()


if not isnull(istr_parm.al_order_no) and istr_parm.al_order_no > 0 and istr_parm.as_columnname = "disb_invoice_nr" then
	ll_findrow = dw_spy.find("order_no = " + string(istr_parm.al_order_no), 1, dw_spy.rowcount())
	if ll_findrow > 0 then
		dw_spy.setitem(ll_findrow, "disb_invoice_nr", istr_parm.as_data)
	end if
end if

st_rowcount.text = string(dw_spy.rowcount()) + " row(s)"



end event

on w_verify_change.create
int iCurrent
call super::create
this.st_rowcount=create st_rowcount
this.cb_cancel=create cb_cancel
this.st_message=create st_message
this.cb_ok=create cb_ok
this.dw_spy=create dw_spy
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_rowcount
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_message
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.dw_spy
end on

on w_verify_change.destroy
call super::destroy
destroy(this.st_rowcount)
destroy(this.cb_cancel)
destroy(this.st_message)
destroy(this.cb_ok)
destroy(this.dw_spy)
end on

type st_rowcount from mt_u_statictext within w_verify_change
integer x = 37
integer y = 1472
integer width = 713
long backcolor = 553648127
string text = ""
end type

type cb_cancel from mt_u_commandbutton within w_verify_change
integer x = 2811
integer y = 1472
integer taborder = 20
string text = "&No"
end type

event clicked;call super::clicked;dw_spy.setFilter("")
dw_spy.filter()

dw_spy.ResetUpdate()
dw_spy.shareDataOff()

closewithreturn (parent, 0)
end event

type st_message from mt_u_statictext within w_verify_change
integer x = 37
integer y = 32
integer width = 3113
integer height = 56
long textcolor = 0
long backcolor = 553648127
string text = ""
end type

type cb_ok from mt_u_commandbutton within w_verify_change
integer x = 2464
integer y = 1472
integer taborder = 10
string text = "&Yes"
boolean default = true
end type

event clicked;long ll_rows, ll_row, ll_vessel_nr

/* Change records */
ll_rows = dw_spy.rowCount()

choose case istr_parm.as_columnname
	case "vessel_ref_nr"
		SELECT VESSEL_NR INTO :ll_vessel_nr FROM VESSELS WHERE VESSEL_REF_NR = :istr_parm.as_data;
		for ll_row = 1 to ll_rows
			dw_spy.setItem(ll_row, istr_parm.as_columnName, istr_parm.as_data)
			dw_spy.setItem(ll_row, "vessel_nr", ll_vessel_nr)
		next
	case "pcn"
		for ll_row = 1 to ll_rows
			dw_spy.setItem(ll_row, istr_parm.as_columnName, integer(istr_parm.as_data))
		next
	case else
		for ll_row = 1 to ll_rows
			dw_spy.setItem(ll_row, istr_parm.as_columnName, istr_parm.as_data)
		next
end choose

dw_spy.setFilter("")
dw_spy.filter()

dw_spy.ResetUpdate()
dw_spy.shareDataOff()

closewithreturn (parent, 1)
end event

type dw_spy from mt_u_datawindow within w_verify_change
integer x = 37
integer y = 96
integer width = 3118
integer height = 1356
string dataobject = "d_rejected_transactions"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

