$PBExportHeader$w_cleanup_failed_inserted_disbursements.srw
forward
global type w_cleanup_failed_inserted_disbursements from mt_w_response
end type
type cb_refresh from mt_u_commandbutton within w_cleanup_failed_inserted_disbursements
end type
type rb_between from radiobutton within w_cleanup_failed_inserted_disbursements
end type
type rb_equal from radiobutton within w_cleanup_failed_inserted_disbursements
end type
type rb_larger from radiobutton within w_cleanup_failed_inserted_disbursements
end type
type rb_less from radiobutton within w_cleanup_failed_inserted_disbursements
end type
type rb_all from radiobutton within w_cleanup_failed_inserted_disbursements
end type
type dp_to from datepicker within w_cleanup_failed_inserted_disbursements
end type
type dp_from from datepicker within w_cleanup_failed_inserted_disbursements
end type
type hpb_1 from mt_u_hprogressbar within w_cleanup_failed_inserted_disbursements
end type
type cb_delete from mt_u_commandbutton within w_cleanup_failed_inserted_disbursements
end type
type st_3 from statictext within w_cleanup_failed_inserted_disbursements
end type
type st_2 from statictext within w_cleanup_failed_inserted_disbursements
end type
type st_1 from statictext within w_cleanup_failed_inserted_disbursements
end type
type dw_rejected from mt_u_datawindow within w_cleanup_failed_inserted_disbursements
end type
type dw_expenses from mt_u_datawindow within w_cleanup_failed_inserted_disbursements
end type
type gb_1 from groupbox within w_cleanup_failed_inserted_disbursements
end type
end forward

global type w_cleanup_failed_inserted_disbursements from mt_w_response
integer width = 2985
integer height = 2424
string title = "Cleanup Imported Expenses"
cb_refresh cb_refresh
rb_between rb_between
rb_equal rb_equal
rb_larger rb_larger
rb_less rb_less
rb_all rb_all
dp_to dp_to
dp_from dp_from
hpb_1 hpb_1
cb_delete cb_delete
st_3 st_3
st_2 st_2
st_1 st_1
dw_rejected dw_rejected
dw_expenses dw_expenses
gb_1 gb_1
end type
global w_cleanup_failed_inserted_disbursements w_cleanup_failed_inserted_disbursements

forward prototypes
private subroutine wf_filter ()
public subroutine documentation ()
end prototypes

private subroutine wf_filter ();/* filters datawindows based on the cretaion date of the expenses */
string		ls_filter
datetime ldt_from, ldt_to

if rb_all.checked then
	ls_filter = ""
elseif rb_less.checked then
	ldt_from = datetime(dp_from.datevalue, time(0,0,0))
	ls_filter = "date(creation_date) < date('"+string(ldt_from, "dd mmmm yyyy")+"')"
elseif rb_equal.checked then
	ldt_from = datetime(dp_from.datevalue, time(0,0,0))
	ls_filter = "date(creation_date) = date('"+string(ldt_from, "dd mmmm yyyy")+"')"
elseif rb_larger.checked then
	ldt_from = datetime(dp_from.datevalue, time(0,0,0))
	ls_filter = "date(creation_date) > date('"+string(ldt_from, "dd mmmm yyyy")+"')"
elseif rb_between.checked then
	ldt_from = datetime(dp_from.datevalue, time(0,0,0))
	ldt_to =  datetime(dp_to.datevalue, time(0,0,0))
	ls_filter = "date(creation_date) >= date('"+string(ldt_from, "dd mmmm yyyy")+"') and date(creation_date) <= date('"+string(ldt_to, "dd mmmm yyyy")+"')"
	
end if

// creation_date < datetime('12 march 2010')
dw_expenses.setFilter(ls_filter)
dw_expenses.filter()

dw_rejected.setFilter(ls_filter)
dw_rejected.filter()

end subroutine

public subroutine documentation ();/*******************************************************************************************************
   ObjectName: w_clanup_failed_inserted_disbursements
   <OBJECT> </OBJECT>
   <DESC>   </DESC>
   <USAGE>  </USAGE>
   <ALSO>   </ALSO>
	<HISTORY>
		Date    		Ref   		Author		Comments
		06/07/15		CR4082		XSZ004		Add validation for delete expenses.	
	</HISTORY>
*********************************************************************************************************/
end subroutine

on w_cleanup_failed_inserted_disbursements.create
int iCurrent
call super::create
this.cb_refresh=create cb_refresh
this.rb_between=create rb_between
this.rb_equal=create rb_equal
this.rb_larger=create rb_larger
this.rb_less=create rb_less
this.rb_all=create rb_all
this.dp_to=create dp_to
this.dp_from=create dp_from
this.hpb_1=create hpb_1
this.cb_delete=create cb_delete
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_rejected=create dw_rejected
this.dw_expenses=create dw_expenses
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_refresh
this.Control[iCurrent+2]=this.rb_between
this.Control[iCurrent+3]=this.rb_equal
this.Control[iCurrent+4]=this.rb_larger
this.Control[iCurrent+5]=this.rb_less
this.Control[iCurrent+6]=this.rb_all
this.Control[iCurrent+7]=this.dp_to
this.Control[iCurrent+8]=this.dp_from
this.Control[iCurrent+9]=this.hpb_1
this.Control[iCurrent+10]=this.cb_delete
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.dw_rejected
this.Control[iCurrent+15]=this.dw_expenses
this.Control[iCurrent+16]=this.gb_1
end on

on w_cleanup_failed_inserted_disbursements.destroy
call super::destroy
destroy(this.cb_refresh)
destroy(this.rb_between)
destroy(this.rb_equal)
destroy(this.rb_larger)
destroy(this.rb_less)
destroy(this.rb_all)
destroy(this.dp_to)
destroy(this.dp_from)
destroy(this.hpb_1)
destroy(this.cb_delete)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_rejected)
destroy(this.dw_expenses)
destroy(this.gb_1)
end on

event open;call super::open;dw_expenses.setTransObject(SQLCA)
dw_rejected.setTransObject(SQLCA)

dw_expenses.post retrieve()
dw_rejected.post retrieve()
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_cleanup_failed_inserted_disbursements
end type

type cb_refresh from mt_u_commandbutton within w_cleanup_failed_inserted_disbursements
integer x = 23
integer y = 2220
integer taborder = 70
string text = "&Refresh"
end type

event clicked;call super::clicked;rb_all.checked = true
rb_all.post TriggerEvent(Clicked!)
dw_expenses.post retrieve()
dw_rejected.post retrieve()
end event

type rb_between from radiobutton within w_cleanup_failed_inserted_disbursements
integer x = 78
integer y = 352
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Between"
end type

event clicked;dp_from.enabled = true
dp_to.enabled = true
dp_from.post setFocus()

post wf_filter()

end event

type rb_equal from radiobutton within w_cleanup_failed_inserted_disbursements
integer x = 78
integer y = 224
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Equal to"
end type

event clicked;dp_from.enabled = true
dp_to.enabled = false
dp_from.post setFocus()

post wf_filter()

end event

type rb_larger from radiobutton within w_cleanup_failed_inserted_disbursements
integer x = 78
integer y = 288
integer width = 357
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "L&arger than"
end type

event clicked;dp_from.enabled = true
dp_to.enabled = false
dp_from.post setFocus()

post wf_filter()

end event

type rb_less from radiobutton within w_cleanup_failed_inserted_disbursements
integer x = 78
integer y = 160
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Less than"
end type

event clicked;dp_from.enabled = true
dp_to.enabled = false
dp_from.post setFocus()

post wf_filter()

end event

type rb_all from radiobutton within w_cleanup_failed_inserted_disbursements
integer x = 78
integer y = 96
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Show All"
boolean checked = true
end type

event clicked;dp_from.enabled = false
dp_to.enabled = false

post wf_filter()


end event

type dp_to from datepicker within w_cleanup_failed_inserted_disbursements
integer x = 507
integer y = 288
integer width = 389
integer height = 88
integer taborder = 30
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
string customformat = "dd/mm-yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-07-29"), Time("14:52:15.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;post wf_filter()
end event

type dp_from from datepicker within w_cleanup_failed_inserted_disbursements
integer x = 507
integer y = 140
integer width = 389
integer height = 88
integer taborder = 20
boolean border = true
borderstyle borderstyle = stylelowered!
boolean enabled = false
string customformat = "dd/mm-yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2015-07-29"), Time("14:52:15.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;post wf_filter()
end event

type hpb_1 from mt_u_hprogressbar within w_cleanup_failed_inserted_disbursements
integer x = 795
integer y = 2236
integer width = 2153
unsignedinteger position = 1
end type

type cb_delete from mt_u_commandbutton within w_cleanup_failed_inserted_disbursements
integer x = 411
integer y = 2220
integer taborder = 60
string text = "&Delete"
end type

event clicked;call super::clicked;long   ll_expenseRows, ll_rejectedRows, ll_row, ll_progressBar, ll_port_exp_id
long   ll_cur_paymentid, ll_pre_paymentid, ll_array_paymentid[], ll_index
string ls_sql, ls_sort, ls_message
boolean lb_success = true


if MessageBox("Warning", "Are you 100% sure that you will delete the Imported Expenses?~r~n~r~n(Remember to ask Finance to Import the Expenses again)",Question!, YesNo!,2) = 2 then return

ls_sort = dw_expenses.describe("datawindow.table.sort")

dw_expenses.setfilter("compute_flag = 0")
dw_expenses.filter()

dw_expenses.setsort("ntc_port_exp_payment_id A")
dw_expenses.sort()

ll_expenseRows = dw_expenses.rowCount()
ll_rejectedRows = dw_rejected.rowCount()

hpb_1.maxPosition = ll_expenseRows + ll_rejectedRows

ll_index = 1

/* Delete all Imported transactions */
for ll_row = 1 to ll_expenseRows
	
	ll_progressBar ++
	hpb_1.position = ll_progressBar
	
	ll_port_exp_id = dw_expenses.getitemnumber(1, "disb_expenses_tc_port_exp_id")
	
	if ll_port_exp_id > 0 then
		if ls_sql = "" then
			ls_sql = string(ll_port_exp_id)
		else
			ls_sql += "," + string(ll_port_exp_id)
		end if
		
		ll_cur_paymentid = dw_expenses.getitemnumber(1, "ntc_port_exp_payment_id")
		
		if ll_cur_paymentid <> ll_pre_paymentid then
			ll_pre_paymentid = ll_cur_paymentid
			ll_array_paymentid[ll_index] = ll_cur_paymentid
			ll_index ++
		end if
	end if
	
	dw_expenses.deleteRow(1)
next

dw_expenses.setfilter("1 = 1")
dw_expenses.filter()

dw_expenses.setsort(ls_sort)
dw_expenses.sort()

/* Delete all Reejcted transactions */
for ll_row = 1 to ll_rejectedRows
	
	ll_progressBar ++
	hpb_1.position = ll_progressBar
	
	dw_rejected.deleteRow(1)
next

if dw_expenses.Update(True, False) = 1 then
	if dw_rejected.Update(True, False) = 1 then
		
		if ls_sql <> "" then
			
			ls_sql = "DELETE FROM NTC_PORT_EXP WHERE PORT_EXP_ID IN (" + ls_sql + ")"
		
			EXECUTE IMMEDIATE :ls_sql;
		
			if sqlca.sqlcode = 0 then
			
				for ll_index = 1 to upperbound(ll_array_paymentid)
				
					ll_cur_paymentid = ll_array_paymentid[ll_index]
				
					ls_sql = "sp_paymentBalance " + string(ll_cur_paymentid)
			
					EXECUTE IMMEDIATE :ls_sql;
				
					if sqlca.sqlcode <> 0 then
						lb_success = false
						ls_message = "update payment balance failed!"
						exit
					end if
				next	
			
			else
				lb_success = false
				ls_message = "Deleting Imported Expenses failed!"
			end if
		end if
	else
		lb_success = false
		ls_message = "Deleting Rejected Transactions failed!"
	end if
else
	lb_success = false
	ls_message = "Deleting Imported Expenses failed!"
end if

if lb_success then
	commit;
	
	dw_expenses.resetUpdate( )
	dw_rejected.resetUpdate( )
	
	if isValid(w_tc_payments) then
		w_tc_payments.PostEvent("ue_refresh")
	end if
	
	if isValid(w_tc_contract) then
		w_tc_contract.PostEvent("ue_refresh")
	end if

	if isValid(w_disbursements) then
		w_disbursements.dw_disb_proc_list.event Clicked(0, 0, w_disbursements.dw_disb_proc_list.getRow(), w_disbursements.dw_disb_proc_list.object)
	end if
	
	MessageBox("Information", "All Expenses Deleted Successfully!")
else
	rollback;
	
	messagebox("Error", ls_message)
	cb_refresh.event clicked( )
end if
end event

type st_3 from statictext within w_cleanup_failed_inserted_disbursements
integer x = 27
integer y = 1344
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rejected:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cleanup_failed_inserted_disbursements
integer x = 27
integer y = 480
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Accepted:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cleanup_failed_inserted_disbursements
integer x = 1198
integer y = 96
integer width = 1632
integer height = 304
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "This function MUST only be used by the TRAMOS Administrator if the Finance Department would like to delete the imported expenses. The number of accepted and Rejected Expenses must be the same as the total number of expenses in the Import file. If not you MUST NOT delete the expenses."
boolean focusrectangle = false
end type

type dw_rejected from mt_u_datawindow within w_cleanup_failed_inserted_disbursements
integer x = 23
integer y = 1404
integer width = 2921
integer height = 776
integer taborder = 50
string dataobject = "d_sq_tb_cleanup_rejected_transactions"
boolean vscrollbar = true
end type

type dw_expenses from mt_u_datawindow within w_cleanup_failed_inserted_disbursements
integer x = 23
integer y = 540
integer width = 2921
integer height = 776
integer taborder = 40
string dataobject = "d_sq_tb_cleanup_imported_expenses"
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_cleanup_failed_inserted_disbursements
integer x = 37
integer y = 24
integer width = 987
integer height = 428
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter"
end type

