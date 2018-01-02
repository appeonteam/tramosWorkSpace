$PBExportHeader$w_commissions_tc.srw
$PBExportComments$This window is opened from the Commission window, and is showing commissions pr. vessel/voyage
forward
global type w_commissions_tc from w_vessel_response
end type
type cb_close from commandbutton within w_commissions_tc
end type
type dw_tc_contract from datawindow within w_commissions_tc
end type
type dw_tc_contract_list from datawindow within w_commissions_tc
end type
end forward

global type w_commissions_tc from w_vessel_response
integer width = 4631
integer height = 2476
string title = "Commissions by Vessel/TC Contract"
cb_close cb_close
dw_tc_contract dw_tc_contract
dw_tc_contract_list dw_tc_contract_list
end type
global w_commissions_tc w_commissions_tc

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_commissions_tc
	
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

on w_commissions_tc.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.dw_tc_contract=create dw_tc_contract
this.dw_tc_contract_list=create dw_tc_contract_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.dw_tc_contract
this.Control[iCurrent+3]=this.dw_tc_contract_list
end on

on w_commissions_tc.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.dw_tc_contract)
destroy(this.dw_tc_contract_list)
end on

event open;call super::open;move(0,100)
dw_tc_contract_list.settransobject(sqlca)
dw_tc_contract.settransobject(sqlca)

uo_vesselselect.of_registerwindow( w_commissions_tc )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

IF (uo_global.ib_rowsindicator) then
	dw_tc_contract_list.setrowfocusindicator(FOCUSRECT!)
//	dw_tc_contract.setrowfocusindicator(FOCUSRECT!)
end if
end event

event activate;If w_tramos_main.MenuName <> "m_tcmain" Then 
	w_tramos_main.ChangeMenu(m_tcmain)
End if


end event

event ue_retrieve;call super::ue_retrieve;dw_tc_contract_list.Post retrieve(ii_vessel_nr)
dw_tc_contract_list.Post setfocus()

end event

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve" )
end event

type uo_vesselselect from w_vessel_response`uo_vesselselect within w_commissions_tc
end type

type cb_close from commandbutton within w_commissions_tc
integer x = 4142
integer y = 28
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

type dw_tc_contract from datawindow within w_commissions_tc
integer x = 1371
integer y = 224
integer width = 3113
integer height = 2152
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_ntc_commission_contract"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;Integer li_broker

IF row > 0 AND IsValid(w_ntc_commission) THEN
	li_broker = this.getitemnumber(row,"broker_nr")
	IF li_broker > 0 THEN
		w_ntc_commission.il_broker_no = li_broker
		w_ntc_commission.retrieve_commission(this.getItemNumber(row, "payment_id"))
		Close (parent)
	END IF
END IF
end event

type dw_tc_contract_list from datawindow within w_commissions_tc
integer x = 5
integer y = 224
integer width = 1358
integer height = 2152
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_tc_contract_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
IF row > 0 THEN
	this.selectrow(0, false)
	this.selectrow(row, true)
	dw_tc_contract.Retrieve(this.getitemnumber(row,"contract_id"))
	commit;
END IF
end event

