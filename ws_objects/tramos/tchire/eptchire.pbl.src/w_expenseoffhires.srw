$PBExportHeader$w_expenseoffhires.srw
$PBExportComments$Off-hires and expenses
forward
global type w_expenseoffhires from w_vessel_basewindow
end type
type dw_expenses from uo_datawindow within w_expenseoffhires
end type
type cb_tchire_close from commandbutton within w_expenseoffhires
end type
type dw_offhires_insert from uo_datawindow within w_expenseoffhires
end type
type rb_all from radiobutton within w_expenseoffhires
end type
type rb_setoff from radiobutton within w_expenseoffhires
end type
type rb_outstanding from radiobutton within w_expenseoffhires
end type
type cb_tchire_new from uo_securitybutton within w_expenseoffhires
end type
type cb_tchire_update from uo_securitybutton within w_expenseoffhires
end type
type cb_tchire_delete from uo_securitybutton within w_expenseoffhires
end type
type cb_tchire_refresh from uo_securitybutton within w_expenseoffhires
end type
type cb_tchire_setoffdate from uo_securitybutton within w_expenseoffhires
end type
type cb_1 from commandbutton within w_expenseoffhires
end type
end forward

global type w_expenseoffhires from w_vessel_basewindow
integer x = 27
integer y = 160
integer width = 2921
integer height = 1804
boolean minbox = false
boolean maxbox = false
boolean resizable = false
event ue_buttoms pbm_custom31
dw_expenses dw_expenses
cb_tchire_close cb_tchire_close
dw_offhires_insert dw_offhires_insert
rb_all rb_all
rb_setoff rb_setoff
rb_outstanding rb_outstanding
cb_tchire_new cb_tchire_new
cb_tchire_update cb_tchire_update
cb_tchire_delete cb_tchire_delete
cb_tchire_refresh cb_tchire_refresh
cb_tchire_setoffdate cb_tchire_setoffdate
cb_1 cb_1
end type
global w_expenseoffhires w_expenseoffhires

type variables
LONG vessel_nr
DATETIME cp_date
INT dw_focus 
BOOLEAN expense_new, offhire_new
INT expense_filter=1, offhire_list_filter=1, offhire_insert_filter=1
end variables

forward prototypes
public subroutine filter (integer lp_value)
public function integer checkupdate (ref datawindow dw)
end prototypes

event ue_buttoms;call super::ue_buttoms;Boolean lb_setvalue

CHOOSE CASE dw_focus
	CASE 1
      lb_setvalue = not expense_new
		cb_tchire_delete.Enabled = lb_setvalue
		cb_tchire_new.Enabled = lb_setvalue
		cb_tchire_refresh.Enabled = lb_setvalue
	CASE 2, 3
		lb_setvalue = not offhire_new
		cb_tchire_delete.Enabled = lb_setvalue
		cb_tchire_new.Enabled = lb_setvalue
		cb_tchire_refresh.Enabled = lb_setvalue
END CHOOSE


end event

public subroutine filter (integer lp_value);		IF lp_value = 1 THEN
			dw_expenses.SetFilter("")
			dw_offhires_insert.SetFilter("")
		ELSEIF lp_value = 2 THEN
			dw_expenses.SetFilter("NOT IsNull(Month(Date(expense_setoffdate)))")
			dw_offhires_insert.SetFilter("NOT IsNull(Month(Date(offhire_setoffdate)))")
		ELSEIF lp_value = 3 THEN
			dw_expenses.SetFilter("IsNull(Month(Date(expense_setoffdate)))")
			dw_offhires_insert.SetFilter("IsNull(Month(Date(offhire_setoffdate)))")
		END IF
		
		dw_expenses.Filter()
		expense_filter = lp_value
		dw_offhires_insert.Filter()
		offhire_insert_filter = lp_value
	


end subroutine

public function integer checkupdate (ref datawindow dw);DATETIME	idate, commence, complete
INT 		firstday, secondday
DATETIME	start, slut
DATE		setoffdate	
long		ll_row

IF dw.GetColumnName() = "offhire_setoffdate" THEN

	/* If setoffdate has been deleted, then return */
	if isnull(dw.gettext())or ( dw.gettext() = "" )  then return 0

	//setoffdate = Date(Left(dw.GetText(),10))
	// (7/12-1998 REM) Changed to
	dw.AcceptText()
	ll_row = dw.GetRow()
	IF ll_row > 0 THEN
		setoffdate = Date(dw.GetItemDateTime(ll_row, "offhire_setoffdate"))
	ELSE
		return 0
	END IF


	SetNull(start)
	SetNull(slut)	
	SetNull(firstday)

	SELECT PAYMENT_FIRSTDAY, PAYMENT_SECONDDAY
	INTO :firstday, :secondday
	FROM 	TCHIRES
	WHERE 	VESSEL_NR = :vessel_nr
	AND		TCHIRE_CP_DATE = :cp_date;

	IF IsNull(secondday) THEN
		secondday = firstday
	END IF
	
	SELECT MIN(TC_PERIOD_START), MAX(TC_PERIOD_END)
	INTO :start, :slut
	FROM TCHIRERATES WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;

	IF IsNull(firstday) AND IsNull(start) AND IsNull(slut) THEN
		Messagebox("T/C Hire rates missing!", "Payment day(s) and/or rate periods are missing for the T/C Hire.~r~rAs a result, the set-off date cannot be entered.") 
		dw_offhires_insert.SetColumn(1)
		dw_offhires_insert.SetTabOrder("expense_setoffdate",0)
	END IF

	IF day(setoffdate) <> firstday AND &
		day(setoffdate) <> secondday THEN 
		IF secondday = firstday THEN
			Messagebox("Invalid set-off date!", "The day for the set-off date must be one of the following payment day(s):~r~r"+String(firstday), StopSign!, OK!)
		ELSE
			Messagebox("Invalid set-off date!", "The day for the set-off date must be one of the following payment day(s):~r~r"+String(firstday)+" "+String(secondday), StopSign!, OK!)
		END IF
		Return 1
	ELSEIF DaysAfter(Date(start), setoffdate) < 0 OR &
			 DaysAfter(setoffdate, Date(slut)) < 0 THEN
		Messagebox("Invalid set-off date!", "The set-off date must be within the following rate period:~r~r"+String(start, "dd/mm-yy")+" - "+String(slut, "dd/mm-yy"), StopSign!, OK!)
//		dw_offhires_list.SetActionCode(1)
	END IF
END IF

IF dw.GetColumnName() = "start_datetime" THEN

	SELECT Min(TC_PERIOD_START), Max(TC_PERIOD_END)
	INTO :start, :slut
	FROM TCHIRERATES WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;

	//idate = DateTime(Date(Left(dw.GetText(),10)))
	// (7/12-1998 REM) Changed to
	dw.AcceptText()
	ll_row = dw.GetRow()
	IF ll_row > 0 THEN
		idate = dw.GetItemDateTime(ll_row, "start_datetime")
	END IF

	IF DaysAfter(Date(start), Date(idate)) < 0 OR &
		DaysAfter(Date(idate), Date(slut)) < 0 THEN
		Messagebox("Commenced date is out of range!", "Commenced date is not in the following rate period:~r~r"+String(start, "dd-mm-yy")+" - "+String(slut, "dd-mm-yy"), StopSign!, OK!)
		Return 1
	END IF

	complete = dw.GetItemDateTime(ll_row, "end_datetime")
	IF NOT IsNull(complete) THEN
		IF DaysAfter(Date(idate), Date(complete)) < 0 THEN
                        dw.SetItem(ll_row,"end_datetime",idate)
		END IF
	END IF
END IF

IF dw. GetColumnName() = "end_datetime" THEN
	SELECT Min(TC_PERIOD_START), Max(TC_PERIOD_END)
	INTO :start, :slut
	FROM TCHIRERATES WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;

	//idate = DateTime(Date(Left(dw.GetText(),10)))
	// (7/12-1998 REM) Changed to
	dw.AcceptText()
	ll_row = dw.GetRow()
	IF ll_row > 0 THEN
		idate = dw.GetItemDateTime(ll_row, "end_datetime")
	END IF
	
	IF DaysAfter(Date(start), Date(idate)) < 0 OR &
		DaysAfter(Date(idate), Date(slut)) < 0 THEN
		Messagebox("Completed date is out of range!", "Completed date is not in the following rate period:~r~r"+String(start, "dd-mm-yy")+" - "+String(slut, "dd-mm-yy"), StopSign!, OK!)
		Return 1
	END IF

	commence = dw.GetItemDateTime(ll_row, "start_datetime")
	IF NOT IsNull(commence) THEN
		IF DaysAfter(Date(commence), Date(idate)) < 0 THEN
			Messagebox("Completed date is invalid!", " 1Completed date must be after commenced date.", StopSign!, OK!)
			Return 1
		END IF
	END IF


	complete = dw.GetItemDateTime(ll_row, "end_datetime")

//	MessageBox("dates: ", string(commence)+" " + string(complete))

	IF NOT IsNull(complete) THEN
		IF DaysAfter(Date(commence), Date(complete)) < 0 THEN
			Messagebox(" Commenced date is invalid!", "2 Commenced date must be before completed date.", StopSign!, OK!)
			Return 1
		END IF
	END IF

END IF

Return 0
end function

event open;call super::open;Move(5,5)

S_EXPENSES_OFFHIRES parameter
parameter = Message.PowerObjectParm
vessel_nr = parameter.vessel_nr
cp_date = parameter.cp_date

title = "Time-Charter Hire Expenses and Off-hires - Vessel "+String(vessel_nr)+" - C/P Date "+String(cp_date, "dd-mm-yy")

dw_expenses.SetTransObject(SQLCA)
dw_offhires_insert.SetTransObject(SQLCA)
// dw_offhires_list.SetTransObject(SQLCA)

/* Replace currency text in datawindow with t/c hire currency */
STRING currency
SELECT TCHIRES.CURR_CODE INTO :currency  
	FROM TCHIRES WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;
dw_expenses.Modify("currency.Text = '("+currency+"):'")
dw_offhires_insert.Modify("currency_1.Text = '"+currency+"'")
dw_offhires_insert.Modify("currency_2.Text = '"+currency+"'")
dw_offhires_insert.Modify("currency_3.Text = '"+currency+"'")

uo_vesselselect.of_registerwindow( w_expenseoffhires )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
end event

event ue_retrieve;call super::ue_retrieve;INT rc_exp, rc_off

rc_exp = dw_expenses.Retrieve(vessel_nr, cp_date)
rc_off = dw_offhires_insert.Retrieve(vessel_nr, cp_date)

IF NOT rc_exp > 0 THEN
	dw_expenses.InsertRow(0)
	dw_expenses.SetItem(dw_expenses.GetRow(), "vessel_nr", vessel_nr)
	dw_expenses.SetItem(dw_expenses.GetRow(), "tchire_cp_date", cp_date)
	dw_expenses.SetItem(dw_expenses.GetRow(), "expense_owners_acc", 0)
	expense_new = TRUE
	dw_expenses.SetFocus()
END IF

TriggerEvent("ue_buttoms")

end event

on w_expenseoffhires.create
int iCurrent
call super::create
this.dw_expenses=create dw_expenses
this.cb_tchire_close=create cb_tchire_close
this.dw_offhires_insert=create dw_offhires_insert
this.rb_all=create rb_all
this.rb_setoff=create rb_setoff
this.rb_outstanding=create rb_outstanding
this.cb_tchire_new=create cb_tchire_new
this.cb_tchire_update=create cb_tchire_update
this.cb_tchire_delete=create cb_tchire_delete
this.cb_tchire_refresh=create cb_tchire_refresh
this.cb_tchire_setoffdate=create cb_tchire_setoffdate
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_expenses
this.Control[iCurrent+2]=this.cb_tchire_close
this.Control[iCurrent+3]=this.dw_offhires_insert
this.Control[iCurrent+4]=this.rb_all
this.Control[iCurrent+5]=this.rb_setoff
this.Control[iCurrent+6]=this.rb_outstanding
this.Control[iCurrent+7]=this.cb_tchire_new
this.Control[iCurrent+8]=this.cb_tchire_update
this.Control[iCurrent+9]=this.cb_tchire_delete
this.Control[iCurrent+10]=this.cb_tchire_refresh
this.Control[iCurrent+11]=this.cb_tchire_setoffdate
this.Control[iCurrent+12]=this.cb_1
end on

on w_expenseoffhires.destroy
call super::destroy
destroy(this.dw_expenses)
destroy(this.cb_tchire_close)
destroy(this.dw_offhires_insert)
destroy(this.rb_all)
destroy(this.rb_setoff)
destroy(this.rb_outstanding)
destroy(this.cb_tchire_new)
destroy(this.cb_tchire_update)
destroy(this.cb_tchire_delete)
destroy(this.cb_tchire_refresh)
destroy(this.cb_tchire_setoffdate)
destroy(this.cb_1)
end on

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve" )
end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_expenseoffhires
end type

type dw_expenses from uo_datawindow within w_expenseoffhires
integer x = 18
integer y = 224
integer width = 2853
integer height = 576
integer taborder = 30
string dataobject = "dw_tchire_expense"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

on itemfocuschanged;call uo_datawindow::itemfocuschanged;// MessageBox("x","expense: "+GetColumnName() )
cb_tchire_setoffdate.enabled = (GetColumnName()="expense_setoffdate")
end on

event getfocus;call super::getfocus;dw_focus = 1

cb_1.text = "Print Expenses"
cb_1.enabled = true

parent.TriggerEvent("ue_buttoms")
TriggerEvent(ItemFocusChanged!)

// em_viewselect.TriggerEvent("setfilter")

end event

event itemchanged;call super::itemchanged;INT 		firstday, secondday
DATETIME	start, slut
DATE		setoffdate

IF GetColumnName() = "expense_setoffdate" THEN
	//setoffdate = Date(Left(GetText(),10))
	// (7/12-1998 REM) Changed to
	this.AcceptText()
	setoffdate = this.GetItemDate(row, "expense_setoffdate")

	SetNull(start)
	SetNull(slut)	
	SetNull(firstday)

	SELECT PAYMENT_FIRSTDAY, PAYMENT_SECONDDAY
	INTO  :firstday, :secondday
	FROM  TCHIRES
	WHERE VESSEL_NR = :vessel_nr
	AND	TCHIRE_CP_DATE = :cp_date;

	IF IsNull(secondday) THEN
		secondday = firstday
	END IF
	
	SELECT MIN(TC_PERIOD_START), MAX(TC_PERIOD_END)
	INTO  :start, :slut
	FROM  TCHIRERATES 
	WHERE VESSEL_NR = :vessel_nr 
	AND 	TCHIRE_CP_DATE = :cp_date;

	IF IsNull(firstday) AND IsNull(start) AND IsNull(slut) THEN
		Messagebox("T/C Hire rates missing!", "Payment day(s) and/or rate periods are missing for the T/C Hire.~r~rAs a result, the set-off date cannot be entered.") 
		dw_expenses.SetColumn(1)
		dw_expenses.SetTabOrder("expense_setoffdate",0)
	END IF

	IF day(setoffdate) <> firstday AND &
		day(setoffdate) <> secondday THEN 
		IF secondday = firstday THEN
			Messagebox("Invalid set-off date!", "The day for the set-off date must be one of the following payment day(s):~r~r"+String(firstday), StopSign!, OK!)
		ELSE
			Messagebox("Invalid set-off date!", "The day for the set-off date must be one of the following payment day(s):~r~r"+String(firstday)+" "+String(secondday), StopSign!, OK!)
		END IF
		
		Return 1
	ELSEIF DaysAfter(Date(start), setoffdate) < 0 OR &
			 DaysAfter(setoffdate, Date(slut)) < 0 THEN
		Messagebox("Invalid set-off date!", "The set-off date must be within the following rate period:~r~r"+String(start, "dd-mm-yy")+" - "+String(slut, "dd-mm-yy"), StopSign!, OK!)

		Return 1
	END IF
END IF

end event

event itemerror;call super::itemerror;Return 1

end event

type cb_tchire_close from commandbutton within w_expenseoffhires
integer x = 2638
integer y = 1584
integer width = 238
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

on clicked;Close(parent)

end on

type dw_offhires_insert from uo_datawindow within w_expenseoffhires
integer x = 18
integer y = 832
integer width = 2853
integer height = 736
integer taborder = 50
string dataobject = "dw_tchire_offhire_insert"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;call super::itemchanged;Return checkupdate(dw_offhires_insert)



end event

event getfocus;call super::getfocus;dw_focus = 2

cb_1.text = "Print Off-hires"
cb_1.enabled = true

parent.TriggerEvent("ue_buttoms")
TriggerEvent(ItemFocusChanged!)

// em_viewselect.TriggerEvent("setfilter")


end event

event itemerror;call super::itemerror;Return 1

end event

on itemfocuschanged;call uo_datawindow::itemfocuschanged;// MessageBox("offhires", GetColumnName() )
cb_tchire_setoffdate.enabled = (GetColumnName()="offhire_setoffdate")

end on

type rb_all from radiobutton within w_expenseoffhires
integer x = 37
integer y = 1584
integer width = 183
integer height = 80
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "All"
boolean checked = true
end type

on clicked;Filter(1)
end on

type rb_setoff from radiobutton within w_expenseoffhires
integer x = 219
integer y = 1584
integer width = 247
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Setoff"
end type

on clicked;Filter(2)

end on

type rb_outstanding from radiobutton within w_expenseoffhires
integer x = 475
integer y = 1584
integer width = 398
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Outstanding"
end type

on clicked;Filter(3)
end on

type cb_tchire_new from uo_securitybutton within w_expenseoffhires
boolean visible = false
integer x = 1285
integer y = 1584
integer width = 238
integer height = 80
integer taborder = 40
string text = "&New"
boolean default = true
end type

event clicked;call super::clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_expense_offhires
  
 Object     : cb_tchire_new
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : MI
   
 Date       : 01-01-96

 Description : Creates a new entry for of hire expenses

 Arguments : none

 Returns   : none

 Variables : none

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-01-96	2.0			MI		Initial Verson
  22-02-96	2.11			PBT		Function modified so that the user cannot create off services in this
								module, but is forced to do so in the off-services module.
  
*************************************************************************************************************************************************/

INT rc
CHOOSE CASE dw_focus
	CASE 1
		dw_expenses.SetRedraw(FALSE)
		dw_expenses.SetColumn(1)
		rc = dw_expenses.InsertRow(0)
		dw_expenses.ScrollToRow(rc)
		dw_expenses.SetItem(dw_expenses.GetRow(), "vessel_nr", vessel_nr)
		dw_expenses.SetItem(dw_expenses.GetRow(), "tchire_cp_date", cp_date)
		dw_expenses.SetItem(dw_expenses.GetRow(), "expense_owners_acc", 0)
		dw_expenses.SetItem(dw_expenses.GetRow(), "vas_expense", 0)
		dw_expenses.SetRedraw(TRUE)
		dw_expenses.SetFocus()
		cb_tchire_new.default = false
		cb_tchire_update.default = true
		expense_new = TRUE
	/* datawindow off-services */
	CASE 2, 3
		/* give message to user that off services must be created in off-services module */
		messagebox("Off Services","Notice! Off Services must be created in the Off Services module" + &
			" and will be copied to the TC-Hire if requested!")
END CHOOSE

parent.PostEvent("ue_buttoms")

end event

type cb_tchire_update from uo_securitybutton within w_expenseoffhires
boolean visible = false
integer x = 1541
integer y = 1584
integer width = 238
integer height = 80
integer taborder = 60
string text = "&Update"
end type

on clicked;call uo_securitybutton::clicked;
CHOOSE CASE dw_focus
	CASE 1
		IF dw_expenses.Update()  = 1 THEN
			COMMIT;
			OpenWithParm(w_updated, 0, w_tramos_main)
			expense_new = FALSE
			dw_expenses.SetFocus()
			cb_tchire_update.default = false
			cb_tchire_new.default = true	
		ELSE
			ROLLBACK;
			MessageBox("Error","Update did not occur!")
			dw_expenses.SetFocus()
		END IF
	CASE 2
		IF dw_offhires_insert.Update()  = 1 THEN
			COMMIT;
			OpenWithParm(w_updated, 0, w_tramos_main)
			offhire_new = FALSE
			dw_offhires_insert.SetFocus()
			cb_tchire_update.default = false
			cb_tchire_new.default = true	
		ELSE
			ROLLBACK;
			MessageBox("Error","Update did not occur!")
			dw_offhires_insert.SetFocus()
		END IF
END CHOOSE

parent.TriggerEvent("ue_buttoms")

end on

type cb_tchire_delete from uo_securitybutton within w_expenseoffhires
boolean visible = false
integer x = 1797
integer y = 1584
integer width = 238
integer height = 80
integer taborder = 10
string text = "&Delete"
end type

event clicked;call super::clicked;CHOOSE CASE dw_focus
	CASE 1
		IF MessageBox("Delete","You are about to DELETE the T/C Hire expense!~r~n" + &
						  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN RETURN

		IF dw_expenses.DeleteRow(0) = 1 THEN
			IF dw_expenses.Update() = 1 THEN
				COMMIT;
				IF dw_expenses.RowCount() = 0 AND dw_expenses.FilteredCount() = 0 THEN
					TriggerEvent(cb_tchire_new, "clicked")
				END IF
			ELSE
				ROLLBACK;
				MessageBox("Error","Delete did not occur!")
				dw_expenses.SetFocus()
			END IF
		ELSE
			ROLLBACK;
			MessageBox("Error","Delete did not occur!")
			dw_expenses.SetFocus()
		END IF
	/* datawindow off-services */
	CASE 2
		/* give user message that TC-Hire off services must be delete from off-services module */
		messagebox("Off Services","Notice! You can only delete Off Services from the Off Services " + &
				"module!")
END CHOOSE

end event

type cb_tchire_refresh from uo_securitybutton within w_expenseoffhires
integer x = 2053
integer y = 1584
integer width = 238
integer height = 80
integer taborder = 80
string text = "&Refresh"
end type

on clicked;call uo_securitybutton::clicked;INT rc
CHOOSE CASE dw_focus
	CASE 1
		rc = dw_expenses.Retrieve(vessel_nr, cp_date)
		IF NOT rc > 0 AND dw_expenses.FilteredCount() = 0 THEN
			TriggerEvent(cb_tchire_new, "clicked")
		ELSE
			dw_expenses.SetFocus()
		END IF
	CASE 2
		rc = dw_offhires_insert.Retrieve(vessel_nr, cp_date)
		IF NOT rc > 0 AND dw_offhires_insert.FilteredCount() = 0 THEN
			TriggerEvent(cb_tchire_new, "clicked")
		ELSE
			dw_offhires_insert.SetFocus()
		END IF
END CHOOSE

end on

type cb_tchire_setoffdate from uo_securitybutton within w_expenseoffhires
boolean visible = false
integer x = 2309
integer y = 1584
integer width = 311
integer height = 80
integer taborder = 20
string text = "Set-off date"
end type

on clicked;call uo_securitybutton::clicked; S_EXPENSES_OFFHIRES parameter

parameter.vessel_nr 	= vessel_nr
parameter.cp_date 	= cp_date
OpenWithParm(w_select_setoffdate, parameter)

STRING setoffdate_s
DATETIME setoffdate

setoffdate_s = Message.StringParm

IF IsDate(setoffdate_s) THEN
	setoffdate = DateTime(Date(setoffdate_s), Time(0,0,0))
	CHOOSE CASE dw_focus
	CASE 1
		dw_expenses.SetItem(dw_expenses.GetRow(), "expense_setoffdate", setoffdate)
		dw_expenses.SetFocus()
	CASE 2
		dw_offhires_insert.SetItem(dw_offhires_insert.GetRow(), "offhire_setoffdate", setoffdate)
		dw_offhires_insert.SetFocus()
	END CHOOSE
END IF

end on

type cb_1 from commandbutton within w_expenseoffhires
integer x = 887
integer y = 1584
integer width = 375
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Print"
end type

event clicked;datastore lds_store

if (cb_1.text = "Print Off-hires") then
	lds_store = create datastore
	lds_store.dataobject = "dw_tchire_offhire_insert_print"
	lds_store.settransobject(SQLCA)
	dw_offhires_insert.ShareData(lds_store)
	lds_store.print()
	dw_offhires_insert.sharedataoff()
else
	lds_store = create datastore
	lds_store.dataobject = "dw_tchire_expense_print"
	lds_store.settransobject(SQLCA)
	dw_expenses.ShareData(lds_store)
	lds_store.print()
	dw_expenses.ShareDataoff()
end if


end event

