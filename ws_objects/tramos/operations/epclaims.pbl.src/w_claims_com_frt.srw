$PBExportHeader$w_claims_com_frt.srw
forward
global type w_claims_com_frt from mt_w_response
end type
type cb_2 from commandbutton within w_claims_com_frt
end type
type cb_1 from commandbutton within w_claims_com_frt
end type
type st_1 from statictext within w_claims_com_frt
end type
type dw_freight_claims from datawindow within w_claims_com_frt
end type
end forward

global type w_claims_com_frt from mt_w_response
integer width = 3954
integer height = 1580
string title = "Freight Claims"
boolean controlmenu = false
cb_2 cb_2
cb_1 cb_1
st_1 st_1
dw_freight_claims dw_freight_claims
end type
global w_claims_com_frt w_claims_com_frt

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_claims_com_frt
	
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

on w_claims_com_frt.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_freight_claims=create dw_freight_claims
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_freight_claims
end on

on w_claims_com_frt.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_freight_claims)
end on

event open;integer li_vessel_nr, li_chart_nr, li_claim_nr
string ls_voyage_nr

dw_freight_claims.settransobject(SQLCA)

li_vessel_nr = w_claims.dw_claim_base.GetItemNumber(1,"vessel_nr")
ls_voyage_nr = w_claims.dw_claim_base.GetItemString(1,"voyage_nr")
li_chart_nr = w_claims.dw_claim_base.GetItemNumber(1,"chart_nr")
li_claim_nr = w_claims.dw_claim_base.GetItemNumber(1,"claim_nr")

dw_freight_claims.retrieve(li_chart_nr, li_vessel_nr, ls_voyage_nr, li_claim_nr)



end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_claims_com_frt
end type

type cb_2 from commandbutton within w_claims_com_frt
integer x = 3575
integer y = 1376
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;CloseWithReturn(Parent, 0)
end event

type cb_1 from commandbutton within w_claims_com_frt
integer x = 3209
integer y = 1376
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK &Delete"
end type

event clicked;integer li_rowcount, li_row, li_update, li_close

li_close = 1
li_rowcount = dw_freight_claims.rowcount()


FOR li_row = li_rowcount TO 1 step -1
	dw_freight_claims.deleterow(li_row)
NEXT

if (dw_freight_claims.update() = -1) then
	Messagebox("Update failed", "Update has failed. Please try again")
	li_close = 0
end if

CloseWithReturn(Parent, li_close)
end event

type st_1 from statictext within w_claims_com_frt
integer x = 37
integer y = 48
integer width = 1970
integer height = 120
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "If you continue, the following commissions will be automatically deleted. Press ~"OK Delete~" to accept deletion or ~"Cancel~" to continue without deleting."
boolean focusrectangle = false
end type

type dw_freight_claims from datawindow within w_claims_com_frt
integer x = 37
integer y = 224
integer width = 3881
integer height = 1124
string title = "none"
string dataobject = "dw_commission_list_frt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

