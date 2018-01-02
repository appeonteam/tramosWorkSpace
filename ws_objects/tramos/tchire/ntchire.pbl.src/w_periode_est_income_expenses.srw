$PBExportHeader$w_periode_est_income_expenses.srw
$PBExportComments$This window is linked to TC periods.
forward
global type w_periode_est_income_expenses from mt_w_response
end type
type cb_delete from commandbutton within w_periode_est_income_expenses
end type
type cb_insert from commandbutton within w_periode_est_income_expenses
end type
type cb_cancel from commandbutton within w_periode_est_income_expenses
end type
type cb_ok from commandbutton within w_periode_est_income_expenses
end type
type dw_exp from u_ntchire_grid_dw within w_periode_est_income_expenses
end type
type cb_1 from commandbutton within w_periode_est_income_expenses
end type
end forward

global type w_periode_est_income_expenses from mt_w_response
integer x = 800
integer y = 400
integer width = 3406
integer height = 1440
string title = "Estimated Expense/Income"
boolean ib_setdefaultbackgroundcolor = true
cb_delete cb_delete
cb_insert cb_insert
cb_cancel cb_cancel
cb_ok cb_ok
dw_exp dw_exp
cb_1 cb_1
end type
global w_periode_est_income_expenses w_periode_est_income_expenses

type variables
s_tc_periode_income	istr_parm // ll_periode_id, ld_income, ld_expenses

n_service_manager inv_servicemgr
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_validate ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_periode_est_income_expenses
	
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
		23/01/2015  CR3570      KSH092      Change UI
	</HISTORY>
********************************************************************/
end subroutine

public function integer wf_validate ();long ll_no_of_rows, ll_row

dw_exp.acceptText()
ll_no_of_rows = dw_exp.rowCount()

/* Simple validation */
if ll_no_of_rows > 0 then
	for ll_row = 1 to ll_no_of_rows
		if isnull(dw_exp.getItemNumber(ll_row, "exp_type_id")) or &
			isnull(dw_exp.getItemNumber(ll_row, "amount")) then
				MessageBox("Validation Error", "Please fill in all required fields in row: " +string(ll_row))
				dw_exp.scrollToRow(ll_row)
				dw_exp.POST setfocus()
				return -1
		end if
	next
end if
return 1
end function

on w_periode_est_income_expenses.create
int iCurrent
call super::create
this.cb_delete=create cb_delete
this.cb_insert=create cb_insert
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_exp=create dw_exp
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete
this.Control[iCurrent+2]=this.cb_insert
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.dw_exp
this.Control[iCurrent+6]=this.cb_1
end on

on w_periode_est_income_expenses.destroy
call super::destroy
destroy(this.cb_delete)
destroy(this.cb_insert)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_exp)
destroy(this.cb_1)
end on

event open;call super::open;n_dw_style_service   lnv_style

inv_servicemgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater( dw_exp, false)
istr_parm = message.powerObjectParm
istr_parm.ld_return = 1
dw_exp.setTransObject(SQLCA)
if dw_exp.retrieve(istr_parm.ll_periode_id) = 0 then
	dw_exp.insertRow(0)
	dw_exp.setItem(1, "tc_periode_id", istr_parm.ll_periode_id)
	dw_exp.setItem(1, "income", 0)
	dw_exp.setitemstatus(1,0,Primary!,NotModified!)
end if
dw_exp.setrowfocusindicator( focusRect!)
dw_exp.POST setfocus()
end event

event close;call super::close;long ll_no_of_rows

ll_no_of_rows = dw_exp.rowcount()
if ll_no_of_rows = 0 then
	istr_parm.ld_income = 0
	istr_parm.ld_expenses = 0
else
	istr_parm.ld_income = dw_exp.getItemNumber(1, "sum_inc")
	istr_parm.ld_expenses = dw_exp.getItemNumber(1, "sum_exp")
end if

closewithreturn(this,istr_parm)
end event

event closequery;call super::closequery;dw_exp.accepttext()

if dw_exp.modifiedCount() + dw_exp.deletedCount() > 0 then
	if MessageBox("Updates pending", "Data modified but not saved.~r~nWould you like to update changes?",Question!,YesNo!,1)=1 then
		if wf_validate( ) < 0 then
			return 1
		end if
		cb_ok.triggerevent( Clicked!)
			
	else
		dw_exp.reset()
		dw_exp.retrieve(istr_parm.ll_periode_id)
		istr_parm.ld_return = 1
	end if
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_periode_est_income_expenses
end type

type cb_delete from commandbutton within w_periode_est_income_expenses
integer x = 2693
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete"
end type

event clicked;dw_exp.deleteRow(0)

dw_exp.POST setColumn("income")
dw_exp.POST setfocus()
end event

type cb_insert from commandbutton within w_periode_est_income_expenses
integer x = 1989
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&New"
end type

event clicked;long ll_row

ll_row = dw_exp.getRow()

if ll_row > 0 then
	ll_row = dw_exp.insertRow(ll_row)
else
	ll_row = dw_exp.insertRow(0)
end if

dw_exp.setItem(ll_row, "tc_periode_id", istr_parm.ll_periode_id)
dw_exp.setItem(ll_row, "income", 0)
dw_exp.setItem(ll_row, "port_expense", 0)
dw_exp.scrollToRow(ll_row)
dw_exp.POST setColumn("income")
dw_exp.POST setfocus()
end event

type cb_cancel from commandbutton within w_periode_est_income_expenses
integer x = 3040
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
dw_exp.reset()
dw_exp.retrieve(istr_parm.ll_periode_id)
istr_parm.ld_return = 1

end event

type cb_ok from commandbutton within w_periode_est_income_expenses
integer x = 2341
integer y = 1232
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;

if wf_validate( ) < 0 then return

if dw_exp.Update() = 1 then
	commit;
	istr_parm.ld_return = 1
	return 1
else
	rollback;
	istr_parm.ld_return = 0
	MessageBox("Update Error", "Error updating estimates")
	dw_exp.POST setfocus()
	return -1
end if


end event

type dw_exp from u_ntchire_grid_dw within w_periode_est_income_expenses
integer x = 18
integer y = 16
integer width = 3355
integer height = 1192
integer taborder = 10
string dataobject = "d_tc_periode_est_income_expenses"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event doubleclicked;call super::doubleclicked;STRING ls_rc
LONG	ll_rc
STRING ls_desc

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "type_desc"
			ls_rc = f_select_from_list("d_non_port_expense_types", 2, "Description", 2, "Description", 1, "Select Expense Type", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT TYPE_DESC INTO :ls_desc
				FROM NTC_EXP_TYPE WHERE EXP_TYPE_ID = :ll_rc;
				this.SetItem(row, "type_desc", ls_desc)
				this.SetItem(row, "exp_type_id", ll_rc)
			END IF
	END CHOOSE
end if
end event

event ue_keydown;call super::ue_keydown;if key = KeySpaceBar! and this.getColumnName() = "type_desc" then
	this.Event DoubleClicked(0,0, this.getRow(), this.object.type_desc)
end if
end event

event itemchanged;call super::itemchanged;
// If this is a Extimated Disbursement expense then the Exp/Inc flag must be set to Exp.
if row < 1 then return 

CHOOSE CASE dwo.name
	CASE "port_expense"  
		if data = "1" and This.getItemNumber(row, "income") = 1 then
			MessageBox("Information","The Exp./Inc. flag for Port Expenses is automaticaly set/locked to Exp. !")
			This.SetItem(row, "income", 0)
		end if
END CHOOSE
end event

type cb_1 from commandbutton within w_periode_est_income_expenses
boolean visible = false
integer x = 2981
integer y = 1232
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "none"
end type

event clicked;closeWithReturn(parent, istr_parm)
end event

