$PBExportHeader$w_fin_debt_report.srw
$PBExportComments$This report is the nearly same as Outstanding Amount. The difference is that this excludes Profitcenter Handytankers, and TC-out outstanding amounts where LR 2, Exmar or Tankers International are rigistred as Charterer
forward
global type w_fin_debt_report from mt_w_sheet
end type
type st_1 from statictext within w_fin_debt_report
end type
type cb_retrieve from commandbutton within w_fin_debt_report
end type
type dw_date from datawindow within w_fin_debt_report
end type
type cb_print from commandbutton within w_fin_debt_report
end type
type cb_1 from commandbutton within w_fin_debt_report
end type
type cb_saveas from commandbutton within w_fin_debt_report
end type
type st_row from statictext within w_fin_debt_report
end type
type dw_fin_out_amount from datawindow within w_fin_debt_report
end type
end forward

global type w_fin_debt_report from mt_w_sheet
integer width = 4539
integer height = 2344
string title = "Finance Debt Report"
boolean maxbox = false
boolean resizable = false
boolean center = false
st_1 st_1
cb_retrieve cb_retrieve
dw_date dw_date
cb_print cb_print
cb_1 cb_1
cb_saveas cb_saveas
st_row st_row
dw_fin_out_amount dw_fin_out_amount
end type
global w_fin_debt_report w_fin_debt_report

type variables
u_jump_claims iuo_jump_claims
u_jump_actions_trans iuo_jump_actions_trans
end variables

forward prototypes
public subroutine wf_gotoclaims ()
public subroutine documentation ()
end prototypes

public subroutine wf_gotoclaims ();string ls_voyage_nr, ls_claim_type
integer li_vessel_nr
long ll_chart_nr, ll_claim_nr

li_vessel_nr 	= dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(), "claims_vessel_nr")
ls_voyage_nr 	= dw_fin_out_amount.getitemstring(dw_fin_out_amount.getrow(), "claims_voyage_nr")
ll_chart_nr	 	= dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(), "claims_chart_nr")
ll_claim_nr	 	= dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(), "claims_claim_nr")
ls_claim_type	= dw_fin_out_amount.getitemstring(dw_fin_out_amount.getrow(), "claims_claim_type")

if (ls_claim_type = 'FRT') then
	iuo_jump_claims.of_open_claims(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)
else
	iuo_jump_actions_trans.of_open_actions_trans(li_vessel_nr, ls_voyage_nr, ll_chart_nr, ll_claim_nr)
end if
end subroutine

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_fin_debt_report.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_retrieve=create cb_retrieve
this.dw_date=create dw_date
this.cb_print=create cb_print
this.cb_1=create cb_1
this.cb_saveas=create cb_saveas
this.st_row=create st_row
this.dw_fin_out_amount=create dw_fin_out_amount
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_retrieve
this.Control[iCurrent+3]=this.dw_date
this.Control[iCurrent+4]=this.cb_print
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_saveas
this.Control[iCurrent+7]=this.st_row
this.Control[iCurrent+8]=this.dw_fin_out_amount
end on

on w_fin_debt_report.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_retrieve)
destroy(this.dw_date)
destroy(this.cb_print)
destroy(this.cb_1)
destroy(this.cb_saveas)
destroy(this.st_row)
destroy(this.dw_fin_out_amount)
end on

event open;call super::open;dw_fin_out_amount.settransobject(SQLCA)
dw_fin_out_amount.setrowfocusindicator(FOCUSRECT!)

dw_date.InsertRow(0)
dw_date.setItem(1, "date_value", today())
dw_date.POST setFocus()

iuo_jump_claims = CREATE u_jump_claims
iuo_jump_actions_trans = CREATE u_jump_actions_trans

end event

event close;destroy iuo_jump_claims
destroy iuo_jump_actions_trans

end event

type st_1 from statictext within w_fin_debt_report
integer x = 37
integer y = 28
integer width = 2638
integer height = 124
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "This report is nearly the same as Outstanding Amount. The difference is that this excludes Profitcenter Handytankers, and TC-out outstanding amounts where LR 2, Exmar or Tankers International are registred as Charterer."
boolean focusrectangle = false
end type

type cb_retrieve from commandbutton within w_fin_debt_report
integer x = 3026
integer y = 2080
integer width = 343
integer height = 100
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Retrieve"
boolean default = true
end type

event clicked;st_row.text = "Rows: " + string(dw_fin_out_amount.retrieve(datetime(dw_date.getItemDate(1, "date_value"))))

end event

type dw_date from datawindow within w_fin_debt_report
integer x = 9
integer y = 2080
integer width = 315
integer height = 100
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_print from commandbutton within w_fin_debt_report
integer x = 3401
integer y = 2080
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Print"
end type

event clicked;dw_fin_out_amount.Object.DataWindow.Print.orientation = 1
dw_fin_out_amount.print()
end event

type cb_1 from commandbutton within w_fin_debt_report
integer x = 4151
integer y = 2080
integer width = 343
integer height = 100
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_saveas from commandbutton within w_fin_debt_report
integer x = 3776
integer y = 2080
integer width = 343
integer height = 100
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Save As..."
end type

event clicked;dw_fin_out_amount.saveas()

end event

type st_row from statictext within w_fin_debt_report
integer x = 4055
integer y = 1972
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_fin_out_amount from datawindow within w_fin_debt_report
integer x = 9
integer y = 200
integer width = 4485
integer height = 1736
integer taborder = 20
string title = "none"
string dataobject = "d_fin_out_amount_no_pool"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort

If (Row > 0) And (row <> GetSelectedRow(row - 1)) Then 
	SelectRow(0,false)
	SetRow(row)
	SelectRow(row,True)
End if

if dwo.type = "text" then
	ls_sort = dwo.Tag

	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
	
end if
end event

event doubleclicked;if (row > 0) then
	IF NOT(dw_fin_out_amount.getitemstring(dw_fin_out_amount.getrow(), "claims_claim_type")="TC-OUT") THEN
		wf_gotoclaims()
		
	ELSE
		OpenSheetWithParm(w_tc_payments, dw_fin_out_amount.getitemnumber(dw_fin_out_amount.getrow(),&
							"contract_id"), w_tramos_main, 7, Original!)
	END IF
end if
end event

