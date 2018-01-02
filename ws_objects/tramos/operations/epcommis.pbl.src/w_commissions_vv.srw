$PBExportHeader$w_commissions_vv.srw
$PBExportComments$This window is opened from the Commission window, and is showing commissions pr. vessel/voyage
forward
global type w_commissions_vv from w_vessel_response
end type
type dw_voyages from uo_datawindow within w_commissions_vv
end type
type dw_commissions from datawindow within w_commissions_vv
end type
type cb_close from commandbutton within w_commissions_vv
end type
end forward

global type w_commissions_vv from w_vessel_response
integer width = 3936
integer height = 1820
string title = "Commissions by Vessel/Voyage"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
dw_voyages dw_voyages
dw_commissions dw_commissions
cb_close cb_close
end type
global w_commissions_vv w_commissions_vv

on w_commissions_vv.create
int iCurrent
call super::create
this.dw_voyages=create dw_voyages
this.dw_commissions=create dw_commissions
this.cb_close=create cb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_voyages
this.Control[iCurrent+2]=this.dw_commissions
this.Control[iCurrent+3]=this.cb_close
end on

on w_commissions_vv.destroy
call super::destroy
destroy(this.dw_voyages)
destroy(this.dw_commissions)
destroy(this.cb_close)
end on

event open;call super::open;move(200,100)
dw_voyages.settransobject(sqlca)
dw_commissions.settransobject(sqlca)

uo_vesselselect.of_registerwindow( w_commissions_vv )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

IF (uo_global.ib_rowsindicator) then
	dw_voyages.setrowfocusindicator(FOCUSRECT!)
//	dw_commissions.setrowfocusindicator(FOCUSRECT!)
end if
end event

event ue_vesselselection;call super::ue_vesselselection;postevent("ue_retrieve")
end event

event ue_retrieve;call super::ue_retrieve;dw_commissions.Reset()
dw_voyages.retrieve(ii_vessel_nr)
dw_voyages.scrolltorow(dw_voyages.rowcount())

end event

type uo_vesselselect from w_vessel_response`uo_vesselselect within w_commissions_vv
end type

type dw_voyages from uo_datawindow within w_commissions_vv
integer x = 32
integer y = 228
integer width = 338
integer height = 1312
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_voyage_list_vv"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;if row > 0 then
	this.selectrow(0,false)
	this.selectrow(row,true)
	dw_commissions.retrieve(ii_vessel_nr,this.getitemstring(row,"voyage_nr"))
//	dw_commissions.setfocus()
end if
end event

type dw_commissions from datawindow within w_commissions_vv
integer x = 407
integer y = 228
integer width = 3493
integer height = 1312
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_commissions_vv"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;long 		ll_broker, ll_claimnr 
string		ls_voyage_nr, ls_claimtype, ls_invoice
decimal 	ld_amount

IF row > 0 AND IsValid(w_commission) THEN
	ll_broker = this.getitemnumber(row,"commissions_broker_nr")
	IF ll_broker > 0 THEN
		w_commission.il_broker_no = ll_broker
		/* get parameters to pass to commissins window.
			parameters are used to highlight the record */
		ls_voyage_nr = dw_voyages.getItemString(dw_voyages.getSelectedRow(0), "voyage_nr")
		ls_claimtype = dw_commissions.getItemString(row, "claims_claim_type")
		ll_claimnr = dw_commissions.getItemNumber(row, "commissions_claim_nr")
		ls_invoice = dw_commissions.getItemString(row, "commissions_invoice_nr")
		ld_amount = dw_commissions.getItemDecimal(row, "commissions_comm_amount_local_curr")
		w_commission.retrieve_commission(ii_vessel_nr,& 
										ls_voyage_nr, &
										ls_claimtype, &
										ll_claimnr, &
										ls_invoice, &
										ld_amount )
		Close (parent)
	END IF
END IF
end event

type cb_close from commandbutton within w_commissions_vv
integer x = 3561
integer y = 1608
integer width = 343
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
boolean default = true
end type

event clicked;close(parent)
end event

