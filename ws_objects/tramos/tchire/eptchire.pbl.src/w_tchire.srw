$PBExportHeader$w_tchire.srw
$PBExportComments$T/C Hire main window
forward
global type w_tchire from w_vessel_basewindow
end type
type dw_tchire_list from uo_datawindow within w_tchire
end type
type dw_tchire_rates from uo_datawindow within w_tchire
end type
type cb_tchire_close from commandbutton within w_tchire
end type
type cb_tchire_expensesoffhires from commandbutton within w_tchire
end type
type cb_tchire_generatehirestatement from commandbutton within w_tchire
end type
type cb_1 from commandbutton within w_tchire
end type
type cb_2 from commandbutton within w_tchire
end type
type cb_3 from commandbutton within w_tchire
end type
type rb_monthly from radiobutton within w_tchire
end type
type rb_daily from radiobutton within w_tchire
end type
type cb_cont from commandbutton within w_tchire
end type
type st_1 from statictext within w_tchire
end type
type cb_tchire_update from uo_securitybutton within w_tchire
end type
type cb_tchire_new from uo_securitybutton within w_tchire
end type
type cb_tchire_delete from uo_securitybutton within w_tchire
end type
type cb_tchire_refresh from uo_securitybutton within w_tchire
end type
type cb_secondary_brokers from commandbutton within w_tchire
end type
type st_2 from statictext within w_tchire
end type
type dw_tchire_detail from uo_datawindow within w_tchire
end type
end forward

global type w_tchire from w_vessel_basewindow
integer width = 3246
integer height = 2688
string title = "Time-Charter Hires"
boolean resizable = false
dw_tchire_list dw_tchire_list
dw_tchire_rates dw_tchire_rates
cb_tchire_close cb_tchire_close
cb_tchire_expensesoffhires cb_tchire_expensesoffhires
cb_tchire_generatehirestatement cb_tchire_generatehirestatement
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
rb_monthly rb_monthly
rb_daily rb_daily
cb_cont cb_cont
st_1 st_1
cb_tchire_update cb_tchire_update
cb_tchire_new cb_tchire_new
cb_tchire_delete cb_tchire_delete
cb_tchire_refresh cb_tchire_refresh
cb_secondary_brokers cb_secondary_brokers
st_2 st_2
dw_tchire_detail dw_tchire_detail
end type
global w_tchire w_tchire

type variables
INT dw_focus
BOOLEAN ib_vessel_selected = FALSE
BOOLEAN tchire_insert
Integer ii_newtchire = 0
end variables

forward prototypes
public subroutine changerate (integer ip_rate)
public function boolean delete_tchire (long vessel_nr, datetime cp_date)
public subroutine documentation ()
end prototypes

public subroutine changerate (integer ip_rate);redraw_off(this)

/* Pete (me), took this out because rate types is on rate dw level, not up here */
//CHOOSE CASE ip_rate
//	CASE 0  // Month
//  		dw_tchire_rates.dwModify("hirerateperiod.text = 'Hire/month'")
//  		dw_tchire_rates.dwModify("hirerate_misc_text.text = 'Misc Exp/mth'")
//        CASE 1 // Day
//		dw_tchire_rates.dwModify("hirerateperiod.text = 'Hire/day'")
//		dw_tchire_rates.dwModify("hirerate_misc_text.text = 'Misc Exp/day'")
//END CHOOSE

// Setredraw(False)

//Long ll_count
//
//FOR ll_count = 1 TO dw_tchire_rates.RowCount()
//	dw_tchire_rates.SetItem(ll_count,"rateperday",ip_rate)
//
// 	IF dw_tchire_rates.GetItemNumber(ll_count, "offhire_allowance") = 9999 THEN
//		dw_tchire_rates.SetItem(ll_count, "offhire_allowance", 0)
//	END IF
//NEXT

// dw_tchire_rates.SetFocus()
// SetRedraw(TRUE)

redraw_on(this)
end subroutine

public function boolean delete_tchire (long vessel_nr, datetime cp_date);BOOLEAN ok
int li_count_tc_offservices
SELECT count(*)
INTO : li_count_tc_offservices
FROM TCHIREOFFHIRES
WHERE VESSEL_NR = :vessel_nr 
AND TCHIRE_CP_DATE = :cp_date;
IF  li_count_tc_offservices > 0 then
	messagebox("Off Services","Notice! You cannot delete this TC-Hire as there are Off Services on it!")
	ok = FALSE
	RETURN ok
end if


DELETE FROM TCHIRERATES 
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
IF SQLCA.SqlCode = 0 THEN
	DELETE FROM TCHIREOFFHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
	IF SQLCA.SqlCode = 0 THEN
		DELETE FROM TCHIREEXPENSES
		WHERE VESSEL_NR = :vessel_nr 
		AND TCHIRE_CP_DATE = :cp_date;
		IF SQLCA.SqlCode = 0 THEN
			DELETE FROM TCHIRES
			WHERE VESSEL_NR = :vessel_nr 
			AND TCHIRE_CP_DATE = :cp_date;
			IF SQLCA.SqlCode = 0 THEN
				COMMIT;
				ok = TRUE
			ELSE
				MessageBox("Error", "Error deleting from table TCHIRES - " +SQLCA.SQLErrText)
				ROLLBACK;
				ok = FALSE
			END IF
		ELSE
			MessageBox("Error", "Error deleting from table TCHIREEXPENSES - " +SQLCA.SQLErrText)
			ROLLBACK;
			ok = FALSE
		END IF
	ELSE
		MessageBox("Error", "Error deleting from table TCHIREOFFHIRES - " +SQLCA.SQLErrText)
		ROLLBACK;
		ok = FALSE
	END IF
ELSE
	MessageBox("Error", "Error deleting from table TCHIRERATES - " +SQLCA.SQLErrText)
	ROLLBACK;
	ok = FALSE
END IF
		
RETURN ok

end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_tchire
   <OBJECT> 	TC Hire window</OBJECT>
   <USAGE>  	</USAGE>
   <ALSO>   	other Objects	</ALSO>
<HISTORY> 
   Date	   CR-Ref	 Author	Comments  
  21-11-11	2625	CONASW	Changed office selection DW (to get active offices only)
</HISTORY>    
********************************************************************/
end subroutine

event open;call super::open;Move(5,5)
dw_tchire_detail.SetTransObject(SQLCA)
dw_tchire_rates.SetTransObject(SQLCA)
dw_tchire_list.SetTransObject(SQLCA)
redraw_off(this) // dw_tchire_detail.SetRedraw(FALSE)
dw_tchire_detail.InsertRow(0)
dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
redraw_on(this) // dw_tchire_detail.SetRedraw(TRUE)
dw_tchire_rates.InsertRow(0)

uo_vesselselect.of_registerwindow( w_tchire )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

if (uo_global.ib_rowsindicator) then
	dw_tchire_list.setrowfocusindicator(FOCUSRECT!)
end if



end event

event ue_retrieve;call super::ue_retrieve;   dw_tchire_list.Retrieve(ii_vessel_nr)
   cb_tchire_new.enabled = true

   IF dw_tchire_list.RowCount() = 0 THEN
	// dw_tchire_list.SetRedraw(FALSE) 
	// dw_tchire_detail.SetRedraw(FALSE)
	// dw_tchire_rates.SetRedraw(FALSE)
	dw_tchire_list.InsertRow(0)
	dw_tchire_detail.Reset()
	dw_tchire_detail.InsertRow(0)
	dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
	dw_tchire_rates.Reset()
	dw_tchire_rates.InsertRow(0)
	dw_tchire_list.Enabled = TRUE
	dw_tchire_detail.Enabled = FALSE
	dw_tchire_rates.Enabled = FALSE
	// dw_tchire_list.SetRedraw(TRUE)
	// dw_tchire_detail.SetRedraw(TRUE)
	dw_tchire_list.ScrollToRow(1)
	dw_tchire_list.SelectRow(0, FALSE)
	dw_tchire_list.SelectRow(1, TRUE)
	// dw_tchire_list.SetRedraw(TRUE)
  ELSE
	// dw_tchire_list.SetRedraw(FALSE)
	dw_tchire_list.Enabled = TRUE
	dw_tchire_detail.Enabled = TRUE
	dw_tchire_rates.Enabled = TRUE
	dw_tchire_list.ScrollToRow(1)
	dw_tchire_list.SelectRow(0, FALSE)
	dw_tchire_list.SelectRow(1, TRUE)
	// dw_tchire_list.SetRedraw(TRUE)
	PostEvent(dw_tchire_list, "ue_retrieve")
  END IF

end event

on w_tchire.create
int iCurrent
call super::create
this.dw_tchire_list=create dw_tchire_list
this.dw_tchire_rates=create dw_tchire_rates
this.cb_tchire_close=create cb_tchire_close
this.cb_tchire_expensesoffhires=create cb_tchire_expensesoffhires
this.cb_tchire_generatehirestatement=create cb_tchire_generatehirestatement
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.rb_monthly=create rb_monthly
this.rb_daily=create rb_daily
this.cb_cont=create cb_cont
this.st_1=create st_1
this.cb_tchire_update=create cb_tchire_update
this.cb_tchire_new=create cb_tchire_new
this.cb_tchire_delete=create cb_tchire_delete
this.cb_tchire_refresh=create cb_tchire_refresh
this.cb_secondary_brokers=create cb_secondary_brokers
this.st_2=create st_2
this.dw_tchire_detail=create dw_tchire_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_tchire_list
this.Control[iCurrent+2]=this.dw_tchire_rates
this.Control[iCurrent+3]=this.cb_tchire_close
this.Control[iCurrent+4]=this.cb_tchire_expensesoffhires
this.Control[iCurrent+5]=this.cb_tchire_generatehirestatement
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.rb_monthly
this.Control[iCurrent+10]=this.rb_daily
this.Control[iCurrent+11]=this.cb_cont
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.cb_tchire_update
this.Control[iCurrent+14]=this.cb_tchire_new
this.Control[iCurrent+15]=this.cb_tchire_delete
this.Control[iCurrent+16]=this.cb_tchire_refresh
this.Control[iCurrent+17]=this.cb_secondary_brokers
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.dw_tchire_detail
end on

on w_tchire.destroy
call super::destroy
destroy(this.dw_tchire_list)
destroy(this.dw_tchire_rates)
destroy(this.cb_tchire_close)
destroy(this.cb_tchire_expensesoffhires)
destroy(this.cb_tchire_generatehirestatement)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.rb_monthly)
destroy(this.rb_daily)
destroy(this.cb_cont)
destroy(this.st_1)
destroy(this.cb_tchire_update)
destroy(this.cb_tchire_new)
destroy(this.cb_tchire_delete)
destroy(this.cb_tchire_refresh)
destroy(this.cb_secondary_brokers)
destroy(this.st_2)
destroy(this.dw_tchire_detail)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(False)
end event

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve" )
end event

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_tchire
end type

type dw_tchire_list from uo_datawindow within w_tchire
event ue_retrieve pbm_custom09
integer x = 37
integer y = 232
integer width = 1166
integer height = 784
integer taborder = 60
string dataobject = "dw_tchire_listview"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_retrieve;
DATETIME cp_date
INT I, rc_detail, rc_rates

i = GetRow()

redraw_off(parent)
// dw_tchire_detail.SetRedraw(FALSE)

cp_date = dw_tchire_list.GetItemDateTime(i, "tchires_tchire_cp_date")
rc_detail = dw_tchire_detail.Retrieve(ii_vessel_nr, cp_date)
rc_rates = dw_tchire_rates.Retrieve(ii_vessel_nr, cp_date)
IF NOT rc_detail > 0 THEN /* Should not occur */
	dw_tchire_detail.InsertRow(0)
	dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
ELSE
	dw_tchire_detail.SetTabOrder("tchires_delivery_date", 0)
	dw_tchire_detail.triggerEvent("times")
	dw_tchire_detail.triggerEvent("redelivery")
END IF

IF NOT rc_rates > 0 THEN
	dw_tchire_rates.triggerEvent("ue_insert")
ELSE /* Show rate specifications */
	dw_tchire_rates.triggerEvent("ue_retrieve")
END IF

redraw_on(parent) // dw_tchire_detail.SetRedraw(TRUE)

end event

event getfocus;call super::getfocus;
IF ib_vessel_selected THEN
	dw_focus = 1

//	redraw_off(parent) 	// SetRedraw(FALSE)
	cb_tchire_update.Enabled = FALSE
	cb_tchire_new.Enabled = TRUE
	IF IsNull(GetItemNumber(GetRow(), "ownercharter")) THEN
		cb_tchire_refresh.Enabled = FALSE
		cb_tchire_expensesoffhires.Enabled = FALSE
		cb_tchire_delete.Enabled = FALSE
		cb_tchire_generatehirestatement.Enabled = FALSE
	ELSE
		cb_tchire_refresh.Enabled = TRUE
		cb_tchire_expensesoffhires.Enabled = TRUE
		cb_tchire_delete.Enabled = TRUE
		cb_tchire_generatehirestatement.Enabled = TRUE
	END IF

	cb_cont.Enabled = FALSE
	rb_monthly.enabled = false
   rb_daily.enabled = false

//	redraw_on(parent)  // SetRedraw(TRUE)
END IF

end event

event clicked;call super::clicked;
IF ib_vessel_selected THEN

	IF Row > 0 AND NOT  IsNull(GetItemNumber(1, "ownercharter")) THEN
		SelectRow(0, FALSE)	
		SelectRow(Row, TRUE)
		SetRow(Row)
		redraw_off(parent)  //		this.SetRedraw(FALSE)
		TriggerEvent("ue_retrieve")
		redraw_on(parent)
	END IF
END IF


end event

event itemerror;call super::itemerror;
Return 1
end event

type dw_tchire_rates from uo_datawindow within w_tchire
event ue_insert pbm_custom27
event ue_retrieve pbm_custom09
integer x = 37
integer y = 1032
integer width = 3031
integer height = 372
integer taborder = 130
string dataobject = "dw_tchire_tcperiod"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_insert;
INT rc

redraw_off(parent)  // dw_tchire_rates.SetRedraw(FALSE)
SetColumn(1)
rc = InsertRow(0)
DATETIME cp_date
cp_date = dw_tchire_list.GetItemDateTime(dw_tchire_list.GetRow(), "tchires_tchire_cp_date")

SetItem(rc, "vessel_nr", ii_vessel_nr)
SetItem(rc, "tchire_cp_date", cp_date)
SetItem(rc, "offhire_allowance", 0)

/* Day or month rate */
IF rb_daily.checked THEN /* Day rate */
       SetItem(rc, "rateperday", 1)
ELSE /* Month rate */
	SetItem(rc, "rateperday", 0)
END IF

/* Default commenced dates */	
DATETIME commencedate
IF RowCount() = 1 THEN
	SELECT DELIVERY_DATE INTO :commencedate FROM TCHIRES
		WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date;
	commencedate = DateTime(Date(commencedate), Time(Hour(Time(commencedate)),Minute(Time(commencedate)),0,0))
	SetItem(rc, "tc_period_start", commencedate)
ELSE
	SELECT Max(TC_PERIOD_END) INTO :commencedate FROM TCHIRERATES
		WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date;
	commencedate = DateTime(Date(commencedate), Time(Hour(Time(commencedate)),Minute(Time(commencedate)),0,0))
	SetItem(rc, "tc_period_start", commencedate)
END IF
SetRow(rc)

redraw_on(parent) // dw_tchire_rates.SetRedraw(TRUE)

end event

event ue_retrieve;call super::ue_retrieve;
/* Pete took this out because rateper?? is now on rate level, not on tchire level */
//redraw_off(parent) // SetRedraw(FALSE)
//
//IF GetItemNumber(GetRow(), "rateperday") = 1 THEN
//	rb_daily.checked = true
//        rb_daily.triggerevent(Clicked!)
//
//	dwModify("hirerateperiod.text = 'Hire/day:'")
//ELSE
//	rb_monthly.checked = true
//        rb_monthly.triggerevent(clicked!)
//
//	dwModify("hirerateperiod.text = 'Hire/month:'")
//END IF
//
//redraw_on(parent) // SetRedraw(TRUE)
//
end event

event getfocus;call super::getfocus;
CHOOSE CASE ii_newtchire
	CASE 1
		ii_newtchire ++
		cb_tchire_update.triggerevent(clicked!)

		if cb_tchire_new.enabled = false then 
			dw_tchire_detail.PostEvent(Clicked!)
       			ii_newtchire = 1	
       			Return
   		end if

		ii_newtchire = 0
	CASE 2
		Return
end choose

dw_focus  = 3
// redraw_off(parent) // SetRedraw(FALSE)
cb_tchire_update.Enabled = TRUE
cb_tchire_expensesoffhires.Enabled = FALSE
cb_tchire_generatehirestatement.Enabled = FALSE

IF GetItemStatus(GetRow(), 0, PRIMARY!) = NewModified! THEN
	cb_tchire_new.Enabled = FALSE
	cb_tchire_refresh.Enabled = FALSE
	cb_tchire_delete.Enabled = FALSE
ELSE
	cb_tchire_new.Enabled = TRUE
	cb_tchire_refresh.Enabled = TRUE
	cb_tchire_delete.Enabled = TRUE
END IF

// redraw_on(parent) // SetRedraw(TRUE)

end event

event updatestart;call super::updatestart;
IF GetItemStatus(GetRow(), 0, PRIMARY!) = NewModified! THEN
	LONG maxno
	SELECT Max(TC_PERIOD_NO) INTO :maxno
	FROM TCHIRERATES;
	IF IsNull(maxno) THEN 
		maxno = 1 
	END IF 
	SetItem(GetRow(), "tc_period_no", maxno)
END IF

end event

event itemchanged;call super::itemchanged;
DATETIME startdate, enddate, delivery, cp_date
DECIMAL {2} allowance

IF GetColumnName() = "tc_period_start" THEN
	cp_date = this.GetItemDateTime(this.GetRow(), "tchire_cp_date")	

//	startdate = DateTime(Date(Left(GetText(),10)), Time(Mid(GetText(),11,6)))
// Changed to
	this.AcceptText()
	startdate = this.GetItemDatetime(this.GetRow(), "tc_period_start")

	SELECT TCHIRES.DELIVERY_DATE
		INTO :delivery
		FROM TCHIRES
		WHERE TCHIRES.VESSEL_NR = :ii_vessel_nr
		AND 	TCHIRES.TCHIRE_CP_DATE = :cp_date;
	IF GetRow() = 1 THEN
		IF NOT DaysAfter(Date(startdate), Date(delivery)) = 0 OR &
			NOT Time(startdate) = Time(delivery) THEN
			Messagebox("Commenced date or time is invalid!", &
			"The first commenced date and time should match the delivery date and time~r~r" + &
			String(date(delivery), "dd-mm-yy")+" - "+String(Time(delivery), "hh:mm")+".", StopSign!)
			Return 1
		END IF
	END IF
END IF

IF GetColumnName() = "tc_period_end" THEN
//	enddate = 	DateTime(Date(Left(GetText(),10)))
// Changed to
	this.AcceptText()
	enddate = this.GetItemDateTime(this.GetRow(), "tc_period_end")

	startdate = this.GetItemDateTime(this.GetRow(), "tc_period_start")
	IF NOT DaysAfter(Date(startdate), Date(enddate)) > 0 THEN
		Messagebox("Completed date is invalid!", "The completed date should be after the commenced date~r~r" + &
		String(date(startdate), "dd-mm-yy")+".", StopSign!)
		Return 1
	END IF
END IF

IF GetColumnName() = "offhire_allowance" THEN
//	allowance = Dec(GetText())
// Changed to
	this.AcceptText()
	allowance = this.GetItemNumber(this.GetRow(), "offhire_allowance")
	
	IF NOT allowance = Truncate(allowance,0) THEN
		Messagebox("Whole number expected!", "Offhire allowance should be a whole number: 0-999", StopSign!, OK!)
		Return 1
	END IF
END IF

end event

event itemerror;call super::itemerror;
beep(1)
Return 1
end event

type cb_tchire_close from commandbutton within w_tchire
integer x = 2811
integer y = 1428
integer width = 256
integer height = 80
integer taborder = 140
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

type cb_tchire_expensesoffhires from commandbutton within w_tchire
integer x = 1925
integer y = 136
integer width = 553
integer height = 80
integer taborder = 150
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Expenses/Off-hires..."
end type

event clicked;S_EXPENSES_OFFHIRES parameter

parameter.vessel_nr = ii_vessel_nr

parameter.cp_date = dw_tchire_list.GetItemDateTime(dw_tchire_list.GetSelectedRow(0), "tchires_tchire_cp_date")

OpenSheetWithParm(w_expenseoffhires, parameter, w_tramos_main, gi_win_pos, Original!)

end event

type cb_tchire_generatehirestatement from commandbutton within w_tchire
integer x = 2510
integer y = 136
integer width = 553
integer height = 80
integer taborder = 160
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&T/C Hire Statements..."
end type

event clicked;S_EXPENSES_OFFHIRES parameter

parameter.vessel_nr =ii_vessel_nr

parameter.cp_date = dw_tchire_list.GetItemDateTime(dw_tchire_list.GetSelectedRow(0), "tchires_tchire_cp_date")

OpenWithParm(w_print_hirestatement, parameter)


end event

type cb_1 from commandbutton within w_tchire
integer x = 1545
integer y = 252
integer width = 73
integer height = 64
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "?"
end type

on clicked;STRING rc

rc = f_select_from_list ("dw_currency_list", 1, "Code", 2, "Number", 1, "Select currency",false)

IF NOT IsNull(rc) THEN
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "tchires_curr_code", rc)
END IF
end on

type cb_2 from commandbutton within w_tchire
integer x = 2002
integer y = 728
integer width = 69
integer height = 64
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "?"
end type

on clicked;STRING rc
LONG	rc_long
STRING shortname, fullname

rc = f_select_from_list("dw_broker_list", 2, "Short Name", 3, "Long Name", 1, "Select broker",false)

IF NOT IsNull(rc) THEN
	rc_long = Long(rc)
	SELECT BROKER_SN, BROKER_NAME INTO :shortname, :fullname
	FROM BROKERS WHERE BROKER_NR = :rc_long;
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "brokers_broker_sn", shortname)
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "brokers_broker_name", fullname)
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "tchires_broker_nr", rc_long)
END IF

end on

type cb_3 from commandbutton within w_tchire
integer x = 2002
integer y = 864
integer width = 69
integer height = 64
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "?"
end type

event clicked;STRING rc
LONG	rc_long
STRING shortname, fullname

rc = f_select_from_list("dw_office_active_list", 2, "Short Name", 3, "Long Name", 1, "Select office",false)

IF NOT IsNull(rc) THEN
	rc_long = Long(rc)
	SELECT OFFICE_SN, OFFICE_NAME INTO :shortname, :fullname
	FROM OFFICES WHERE OFFICE_NR = :rc_long;
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "offices_office_sn", shortname)
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "offices_office_name", fullname)
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "tchires_office_nr", rc_long)
END IF

end event

type rb_monthly from radiobutton within w_tchire
boolean visible = false
integer x = 1701
integer y = 924
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Monthly rate"
end type

on clicked;Changerate(0)

end on

type rb_daily from radiobutton within w_tchire
boolean visible = false
integer x = 1390
integer y = 924
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Daily rate"
end type

on clicked;ChangeRate(1)
end on

type cb_cont from commandbutton within w_tchire
integer x = 2098
integer y = 916
integer width = 398
integer height = 80
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cont&inued rate"
end type

on clicked;IF NOT dw_tchire_rates.GetRow() = 1 THEN
	dw_tchire_rates.SetItem(dw_tchire_rates.GetRow(), "offhire_allowance", 9999)
	dw_tchire_rates.SetFocus()	
ELSE
	Messagebox("Cannot continue allowance!", &
	"You cannot set the first rate period to have continued off-hire allowance.", &
	StopSign!, OK!)
	dw_tchire_rates.SetFocus()	
END IF
end on

type st_1 from statictext within w_tchire
boolean visible = false
integer x = 1221
integer y = 928
integer width = 146
integer height = 48
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "Rate:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_tchire_update from uo_securitybutton within w_tchire
boolean visible = false
integer x = 2542
integer y = 1428
integer width = 256
integer height = 80
integer taborder = 40
boolean enabled = false
string text = "&Update"
end type

event clicked;call super::clicked;
CHOOSE CASE dw_focus
	CASE 0,1,2 
		If IsNull(dw_tchire_detail.GetItemString(dw_tchire_detail.GetRow(),"brokers_broker_sn")) Then
			MessageBox("Error", "No broker selected")
			Return
		End if 		
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// This code is for managing TCCommissions set of dates used by VAS. Leith

		If dw_tchire_detail.AcceptText() = -1 THEN Return		

		String ls_shortname,ls_fullname
		Integer li_number,li_new_payment_day,li_answer,li_payment_day_two,li_tccom_count,li_day_diff
		Datetime cp_date,ldt_com_dt,ldt_upd_dt
		Integer setofftotal, rc,li_payment_day,li_payment_day_one,li_temp_diff,li_upper,li_index
		s_update_tccomm lstr_upd1,lstr_upd2
		
		cp_date = dw_tchire_detail.GetItemDateTime(dw_tchire_detail.GetRow(), "tchires_tchire_cp_date")

		// If there is no cp date all selects will fail
		IF NOT (IsNull(cp_date) OR Day(Date(cp_date))=0) THEN 

			/* Get first day and check for a second */		
			SELECT IsNull(PAYMENT_FIRSTDAY,0) INTO :li_payment_day
			FROM TCHIRES 
			WHERE VESSEL_NR = :ii_vessel_nr
			AND TCHIRE_CP_DATE = :cp_date;
			COMMIT;		

			SELECT IsNull(PAYMENT_SECONDDAY,0) INTO :li_payment_day_two
			FROM TCHIRES 
			WHERE VESSEL_NR = :ii_vessel_nr
			AND TCHIRE_CP_DATE = :cp_date;
			COMMIT;
			
			li_payment_day_one = li_payment_day
			li_new_payment_day = dw_tchire_detail.GetItemNumber(dw_tchire_detail.GetRow(),"tchires_payment_firstday") 
		
			// Is there a new payment day ?
			If li_payment_day <> li_new_payment_day THEN
			
			   // Is there a second payment day, then search only for commissions with set off day < 16
			    IF li_payment_day_two > 0 THEN 
				 SELECT count(*)
			  	 INTO :li_tccom_count
			  	 FROM TCCOMMISSION
			  	 WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND Datepart(DAY,TCCOMM_SET_OFF_DT) < 16;
			  	 COMMIT;
				 ELSE 
				 SELECT count(*)
			  	 INTO :li_tccom_count
			  	 FROM TCCOMMISSION
			  	 WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND  Datepart(DAY,TCCOMM_SET_OFF_DT) > 0;
			  	 COMMIT;
			    END IF

			    // Are there any tccomm. to handle ?
			    IF li_tccom_count > 0 THEN

				// Do user want to update tccomm ? If not dont allow change.
				 li_answer = MessageBox("New First Payment Day","Do you wish to update commissions with new payment dates ?",Question!, YesNo!)
					
				 IF li_answer = 1 THEN
					// Find the diff. in days between old and new day.
					 li_day_diff = li_new_payment_day - li_payment_day
			
					// If there are a second day only update day < 16 in tccomm. set off. dates.
				         IF li_payment_day_two > 0 THEN	
			
						 UPDATE  TCCOMMISSION
			  			 SET TCCOMM_SET_OFF_DT = DateAdd(day, :li_day_diff,TCCOMM_SET_OFF_DT)
			  			 WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND Datepart(DAY,TCCOMM_SET_OFF_DT) < 16;
			  		         IF SQLCA.SQLCode = 0 THEN
							COMMIT;
						 ELSE
							ROLLBACK;
							MessageBox("Error updating","Failed to update TCCOMMISSIONS.Old payment day is reinserted.")
							dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(),"tchires_payment_firstday",li_payment_day)
					 		Return
						  END IF	
					  ELSE
						// We must ensure that we update to a valid date. Not to 31/2-97 !!
						
							transaction sqlcom
							uo_global.defaulttransactionobject(sqlcom)
							connect using sqlcom;
						
							li_index = 1
							
							DECLARE com_cur CURSOR FOR  
 							SELECT TCCOMMISSION.TCCOMM_SET_OFF_DT  
 							FROM TCCOMMISSION  
							WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date 
							USING sqlcom;

							OPEN com_cur ;

							FETCH com_cur INTO :ldt_com_dt;

							DO WHILE sqlcom.SQLCode = 0
								
								// Find valid date 
								IF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day)) THEN
									ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),li_new_payment_day))							
								ELSEIF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day - 1)) THEN										
									ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),(li_new_payment_day - 1)))	
								ELSEIF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day - 2)) THEN						
									ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),(li_new_payment_day - 2)))	
								ELSEIF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day - 3)) THEN	
									ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),(li_new_payment_day - 3)))	
								END IF
								
								lstr_upd1.com_dt[li_index] = ldt_com_dt								
								lstr_upd1.upd_dt[li_index] = ldt_upd_dt	
								li_index ++	

							FETCH com_cur INTO :ldt_com_dt;
							LOOP
							CLOSE com_cur;
							disconnect using sqlcom;
							destroy sqlcom;

							li_upper = UpperBound(lstr_upd1.upd_dt)
							IF li_upper > 0 THEN
								li_index = 1
								DO WHILE li_index <= li_upper
									ldt_upd_dt = lstr_upd1.upd_dt[li_index]
									ldt_com_dt = lstr_upd1.com_dt[li_index]
									UPDATE  TCCOMMISSION
					  				SET TCCOMM_SET_OFF_DT = :ldt_upd_dt
					  				WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND
										      TCCOMM_SET_OFF_DT = :ldt_com_dt ;
				  					IF SQLCA.SQLCode = 0 THEN
										COMMIT;
									ELSE
										ROLLBACK;
										MessageBox("Error updating","Failed to update TCCOMMISSIONS.Only partial update !")
									END IF	
									li_index ++
								LOOP
							END IF
					   END IF	
				ELSE
					MessageBox("No update","Old payment day is reinserted.")
					dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(),"tchires_payment_firstday",li_payment_day)
					Return
				END IF
                           END IF
			END IF
		
		/* Get second day */
		
			// Same princips as above but more simple.
			li_payment_day = li_payment_day_two
			
			li_new_payment_day = dw_tchire_detail.GetItemNumber(dw_tchire_detail.GetRow(),"tchires_payment_secondday") 
		
			If li_payment_day <> li_new_payment_day  THEN

				//Validate			
				IF li_new_payment_day < 16 AND li_new_payment_day <> 0 THEN
					MessageBox("Error","Secondday must be greater than 15. Old payment day is reinserted." )
					dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(),"tchires_payment_secondday",li_payment_day)
					Return
				END IF				

				IF li_payment_day_one > 15 THEN
					MessageBox("Error","Firstday must be less than 16 (if secondday exists). Old payment day is reinserted." )
					dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(),"tchires_payment_secondday",li_payment_day)
					Return
				END IF						

				 SELECT count(*)
			  	 INTO :li_tccom_count
			  	 FROM TCCOMMISSION
			  	 WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND Datepart(DAY,TCCOMM_SET_OFF_DT) > 15;
			  	 COMMIT;
							 
				IF li_tccom_count > 0 THEN

					//Validate
					IF IsNull(li_new_payment_day) Or li_new_payment_day = 0 THEN
						IF li_payment_day > 0 THEN
							MessageBox("Error","You cant drop secondday because there is tccommissions. Old payment day is reinserted." )
							dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(),"tchires_payment_secondday",li_payment_day)
							Return
						END IF
					END IF

					li_answer = MessageBox("New Second Payment Day","Do you wish to update commissions with new payment dates ?",Question!, YesNo!)
					
					IF li_answer = 1 THEN					      
					
						 // We must ensure that we update to a valid date. Not to 31/2-97 !!
					 
						transaction sqlcom2
						uo_global.defaulttransactionobject(sqlcom2)
						connect using sqlcom2;

						li_index = 1
					
						DECLARE com_cur2 CURSOR FOR  
 						SELECT TCCOMMISSION.TCCOMM_SET_OFF_DT  
 						FROM TCCOMMISSION  
						WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND Datepart(DAY,TCCOMM_SET_OFF_DT) > 15
						USING sqlcom2;

						OPEN com_cur2 ;

						FETCH com_cur2 INTO :ldt_com_dt;

						DO WHILE sqlcom2.SQLCode = 0
							IF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day)) THEN
								ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),li_new_payment_day))							
							ELSEIF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day - 1)) THEN										
								ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),(li_new_payment_day - 1)))	
							ELSEIF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day - 2)) THEN						
								ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),(li_new_payment_day - 2)))	
							ELSEIF IsDate(String(Year(Date(ldt_com_dt)))+"/"+string(Month(Date(ldt_com_dt)))+"/"+string(li_new_payment_day - 3)) THEN	
								ldt_upd_dt = DateTime(Date(Year(Date(ldt_com_dt)),Month(Date(ldt_com_dt)),(li_new_payment_day - 3)))	
							END IF

							lstr_upd2.com_dt[li_index] = ldt_com_dt								
							lstr_upd2.upd_dt[li_index] = ldt_upd_dt		
							li_index ++	
							
						FETCH com_cur INTO :ldt_com_dt;
						LOOP
						CLOSE com_cur2;
						disconnect using sqlcom2;
						destroy sqlcom2;					
	
						li_upper = UpperBound(lstr_upd2.upd_dt)
						IF li_upper > 0 THEN
							li_index = 1
							DO WHILE li_index <= li_upper
								ldt_upd_dt = lstr_upd2.upd_dt[li_index]
								ldt_com_dt = lstr_upd2.com_dt[li_index]
								UPDATE  TCCOMMISSION
					  			SET TCCOMM_SET_OFF_DT = :ldt_upd_dt
					  			WHERE VESSEL_NR = :ii_vessel_nr AND TCHIRE_CP_DATE = :cp_date AND
									      TCCOMM_SET_OFF_DT = :ldt_com_dt ;
				  				IF SQLCA.SQLCode = 0 THEN
									COMMIT;
								ELSE
									ROLLBACK;
									MessageBox("Error updating","Failed to update TCCOMMISSIONS.Only partial update !")
								END IF	
								li_index ++
							LOOP
						END IF
					ELSE
						MessageBox("No update","You choosed No. Old payment day is reinserted.")
						dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(),"tchires_payment_secondday",li_payment_day)
					 	Return
					END IF
				END IF
			END IF
		END IF
		// Here ends the code for managing TCCommissions.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		IF dw_tchire_detail.Update() = 1 THEN

			COMMIT;
			Redraw_off(parent) // dw_tchire_list.SetRedraw(FALSE)
			dw_tchire_list.Retrieve(ii_vessel_nr)
	
			cp_date = dw_tchire_detail.GetItemDateTime(dw_tchire_detail.GetRow(), "tchires_tchire_cp_date")
			LONG rownr
			rownr = dw_tchire_list.find("tchires_tchire_cp_date=datetime('"+String(cp_date)+"')", 1, dw_tchire_list.RowCount())
			dw_tchire_list.SelectRow(rownr, TRUE)	
			dw_tchire_list.SetRow(rownr)
			redraw_on(parent) // dw_tchire_list.SetRedraw(TRUE)
			OpenWithParm(w_updated, 0, w_tramos_main)

			/* Disable fields */
			dw_tchire_detail.SetTabOrder("tchires_delivery_date", 0)

			/* Enable bottoms */
			cb_tchire_expensesoffhires.Enabled = TRUE
			cb_tchire_generatehirestatement.Enabled = TRUE

			/* If new t/c hire then prepare to insert rates */
			IF tchire_insert THEN /* See UPDATESTART event */
				dw_tchire_rates.Reset()
				dw_tchire_rates.TriggerEvent("ue_insert")
			END IF

			dw_tchire_rates.Enabled = TRUE

			If ii_newtchire=0 then

				IF dw_focus = 1 THEN
					dw_tchire_list.SetFocus()
				ELSE
				        dw_tchire_detail.SetFocus()
				END IF
			End if
			
			cb_tchire_new.enabled = true
			cb_tchire_delete.enabled = true
			cb_tchire_refresh.enabled = true
			cb_tchire_update.enabled = true
		ELSE
			ROLLBACK;
			MessageBox("Error","Update did not occur!")

			If ii_newtchire=0 then
				IF dw_focus = 1 THEN
					dw_tchire_list.SetFocus()
				ELSE
					dw_tchire_detail.SetFocus()
				END IF
			end if
		END IF
	CASE 3 /* Focus on the datawindow dw_tchire_rates */
		BOOLEAN periods_ok=TRUE
		INT i
		DATETIME startdate, enddate

		/* Check that periods are without spaces */
		IF dw_tchire_rates.RowCount() > 1 THEN
			FOR i = 2 TO dw_tchire_rates.RowCount()
				IF dw_tchire_rates.GetRow() = i THEN
					IF dw_tchire_rates.GetColumnName() = "tc_period_start" THEN
						startdate = DateTime(Date(Left(dw_tchire_rates.GetText(),10)), Time(Mid(dw_tchire_rates.GetText(),11,6)))
					ELSE
						startdate = dw_tchire_rates.GetItemDateTime(i, "tc_period_start")
					END IF
					enddate = dw_tchire_rates.GetItemDateTime(i - 1, "tc_period_end") 	
				ELSEIF dw_tchire_rates.GetRow() = i - 1 THEN
					IF dw_tchire_rates.GetColumnName() = "tc_period_end" THEN
						enddate = DateTime(Date(Left(dw_tchire_rates.GetText(),10)),Time(Mid(dw_tchire_rates.GetText(),11,6)))
					ELSE
						enddate = dw_tchire_rates.GetItemDateTime(dw_tchire_rates.GetRow(), "tc_period_end")
					END IF
				startdate = dw_tchire_rates.GetItemDateTime(i, "tc_period_start")
			ELSE
				startdate = dw_tchire_rates.GetItemDateTime(i, "tc_period_start")
				enddate = dw_tchire_rates.GetItemDateTime(i - 1, "tc_period_end") 	
			END IF
			IF NOT DaysAfter(Date(startdate), Date(enddate)) = 0 OR &
				NOT Time(startdate) = Time(enddate) THEN
				Messagebox("Spaces exist in rate periods!", &
				"Space exists between the following commenced and completed dates and times:~r~r"+String(date(enddate), &
				"dd-mm-yy")+"-"+String(Time(enddate), "hh:mm")+" - "+String(date(startdate), "dd-mm-yy")+ &
				"-"+String(Time(startdate), "hh:mm")+"~r~rThe update did not succeed.", StopSign!)
				periods_ok = FALSE
			END IF
		NEXT
	END IF
	/*-----------------validation from check module inserted 19/12-97-----------------------*/
	u_check_functions lu_check
	string				ls_result
	integer				li_last
	
	lu_check = create u_check_functions


	IF periods_ok THEN
		IF dw_tchire_rates.Update() = 1 THEN
			COMMIT;
			OpenWithParm(w_updated, 0, w_tramos_main)
			dw_tchire_detail.PostEvent("redelivery")
			dw_tchire_rates.SetFocus()
			////////////
			ls_result=lu_check.uf_check_tcperiods(ii_vessel_nr)
			if len(ls_result) > 1 then
				messagebox("Notice",ls_result+"~r~n"+"Please correct!")
			end if 
			destroy lu_check
			///////////
		ELSE
			ROLLBACK;
			MessageBox("Error","Update did not occur!")
			dw_tchire_rates.SetFocus()
		END IF
	END IF

END CHOOSE

end event

type cb_tchire_new from uo_securitybutton within w_tchire
boolean visible = false
integer x = 1714
integer y = 1428
integer width = 256
integer height = 80
integer taborder = 30
boolean enabled = false
string text = "&New"
boolean default = true
end type

event clicked;call super::clicked;
Long test, ll_row

test = dw_focus

CHOOSE CASE dw_focus
	CASE 0,1,2 /* T/C Hire */
		OpenWithParm(w_select_voyage_charter_owner, ii_vessel_nr)
		INT i
		s_select_voyage_chartererowner istr_parametre
		istr_parametre = Message.PowerObjectParm
		/* If not cancel */
		IF istr_parametre.voyage_nr <> "cancel" THEN
			dw_tchire_detail.Enabled  = TRUE
			redraw_off(parent) // dw_tchire_detail.SetRedraw(FALSE)
			dw_tchire_detail.Reset()		
			ll_row = dw_tchire_detail.InsertRow(0)
			/* Sets default value for bare boat to 0. */
			dw_tchire_detail.SetItem(ll_row, "tchires_bare_boat", 0)
			dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
			i = dw_tchire_detail.GetRow()
//			dw_tchire_detail.SetItem(i, "tchires_voyage_nr", istr_parametre.voyage_nr)
			STRING fullname, shortname
			LONG no
			SetNull(no)		
			/* Hire in */
			IF IsNull(istr_parametre.charter_nr) THEN
				dw_tchire_detail.SetItem(i, "tchires_tchire_in", 1)
				dw_tchire_detail.SetItem(i, "tchires_chart_nr", no)
				dw_tchire_detail.SetItem(i, "tchires_tcowner_nr", istr_parametre.owner_nr)
				SELECT TCOWNER_SN, TCOWNER_N_1 INTO :shortname, :fullname 
					FROM TCOWNERS
					WHERE TCOWNER_NR = :istr_parametre.owner_nr;
				dw_tchire_detail.SetItem(i, "tcowners_tcowner_sn", shortname)
				dw_tchire_detail.SetItem(i, "tcowners_tcowner_n_1", fullname)
			ELSEIF IsNull(istr_parametre.owner_nr) THEN /* Hire out */
				dw_tchire_detail.SetItem(i, "tchires_tchire_in", 0)
				dw_tchire_detail.SetItem(i, "tchires_tcowner_nr", no)
				dw_tchire_detail.SetItem(i, "tchires_chart_nr", istr_parametre.charter_nr)
				SELECT CHART_SN, CHART_N_1 INTO :shortname, :fullname 
					FROM CHART
					WHERE CHART_NR = :istr_parametre.charter_nr;
				dw_tchire_detail.SetItem(i, "chart_chart_sn", shortname)
				dw_tchire_detail.SetItem(i, "chart_chart_n_1", fullname)
			END IF

			/* Insert statements */
			dw_tchire_detail.SetColumn("tchires_curr_code")
			dw_tchire_detail.SetItem(i, "tchires_voy_vessel_nr", ii_vessel_nr)
			dw_tchire_detail.SetItem(i, "tchires_vessel_nr", ii_vessel_nr)
			dw_tchire_detail.Modify("dw_tchire_detail.text = 'N/A'")
			dw_tchire_detail.SetItem(i, "tchires_local_time", 0)

			/* Default currency */
			dw_tchire_detail.SetItem(i, "tchires_curr_code", "USD")

			/* Default dates */
			DATE dum_date
			dum_date = Date(0,1,1)
			SetNull(no)
			dw_tchire_detail.SetItem(i, "tchires_delivery_date", DateTime(Date(Year(Today()), Month(Today()), Day(Today())), Time(0,0,0,0)))
			dw_tchire_detail.SetItem(i, "tchires_tchire_cp_date", DateTime(Date(Year(Today()), Month(Today()), Day(Today())), Time(0,0,0,0)))
			dw_tchire_detail.SetItem(i, "tchires_payment_firstday", 1)
			dw_tchire_detail.SetItem(i, "tchires_payment_secondday", no)
			dw_tchire_detail.SetItem(i, "tchire_firstday_time", DateTime(dum_date, Time(0,0,0,0)))
			dw_tchire_detail.SetItem(i, "tchire_secondday_time", DateTime(dum_date, Time(0,0,0,0)))
			dw_tchire_detail.SetItem(i, "compute_0021", 00)
			dw_tchire_detail.SetItem(i, "compute_0022", 00)
			dw_tchire_detail.SetItem(i, "compute_0023", 00)
			dw_tchire_detail.SetItem(i, "compute_0024", 00)

			redraw_on(parent) //dw_tchire_detail.SetRedraw(TRUE)
			dw_tchire_detail.SetFocus()

			/* Enabled fields */
			dw_tchire_detail.SetTabOrder("tchires_delivery_date", 25)
			redraw_off(parent) // dw_tchire_rates.SetRedraw(FALSE)
			dw_tchire_rates.Enabled = FALSE
			dw_tchire_rates.Reset()
			dw_tchire_rates.InsertRow(0)

			rb_daily.checked = true
			rb_daily.triggerevent(Clicked!)

			cb_tchire_new.enabled = false
			cb_tchire_update.default = true
			cb_tchire_delete.enabled = false
			cb_tchire_refresh.enabled = false
			dw_tchire_rates.enabled = true
			ii_newtchire = 1

			redraw_on(Parent) // dw_tchire_rates.SetRedraw(TRUE)
                 end if

	CASE 3 /* Rates */
		dw_tchire_rates.TriggerEvent("ue_insert")
		dw_tchire_rates.SetFocus()
END CHOOSE
end event

type cb_tchire_delete from uo_securitybutton within w_tchire
boolean visible = false
integer x = 1989
integer y = 1428
integer width = 256
integer height = 80
integer taborder = 20
boolean enabled = false
string text = "&Delete"
end type

event clicked;call super::clicked;
DATETIME cp_date
CHOOSE CASE dw_focus
	CASE 1
		IF MessageBox("Delete","You are about to DELETE the T/C Hire with ratesand expenses!~r~n" + &
						  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN RETURN

		cp_date = dw_tchire_list.GetItemDateTime(dw_tchire_list.GetRow(), "tchires_tchire_cp_date")
		IF delete_tchire(ii_vessel_nr, cp_date) THEN
			redraw_off(parent) // SetRedraw(FALSE)
	
			IF dw_tchire_list.RowCount() = 1 THEN
				dw_tchire_list.Reset()
				dw_tchire_list.InsertRow(0)
				dw_tchire_list.SelectRow(1,TRUE)
				dw_tchire_detail.Reset()
				dw_tchire_detail.InsertRow(0)
				dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
				dw_tchire_rates.Reset()
				dw_tchire_rates.InsertRow(0)
				dw_tchire_detail.Enabled = FALSE
				dw_tchire_rates.Enabled = FALSE
			ELSE
				dw_tchire_list.SetFocus()
				cb_tchire_refresh.TriggerEvent("clicked")
				dw_tchire_list.TriggerEvent("ue_retrieve")
				dw_tchire_list.SetRow(1)
				dw_tchire_list.SelectRow(1,TRUE)
				dw_tchire_list.SetFocus()
			END IF

			redraw_on(parent) // SetRedraw(TRUE)
		ELSE
			MessageBox("Error","Delete did not occur!")
			dw_tchire_list.SetFocus()
		END IF
	CASE 2
		IF MessageBox("Delete","You are about to DELETE the T/C Hire with rates and expenses!~r~n" + &
						  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN RETURN

		cp_date = dw_tchire_detail.GetItemDateTime(dw_tchire_detail.GetRow(), "tchires_tchire_cp_date")
		IF delete_tchire(ii_vessel_nr, cp_date) THEN
    			redraw_off(parent) // SetRedraw(FALSE)

			IF dw_tchire_list.RowCount() = 1 THEN
				dw_tchire_list.Reset()
				dw_tchire_list.InsertRow(0)
				dw_tchire_list.SelectRow(1,TRUE)
				dw_tchire_detail.Reset()
				dw_tchire_detail.InsertRow(0)
				dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
				dw_tchire_rates.Reset()
				dw_tchire_rates.InsertRow(0)
				dw_tchire_detail.Enabled = FALSE
				dw_tchire_rates.Enabled = FALSE
			ELSE
				dw_tchire_list.SetFocus()
				cb_tchire_refresh.TriggerEvent("clicked")
				dw_tchire_list.TriggerEvent("ue_retrieve")
				dw_tchire_list.SetRow(1)
				dw_tchire_list.SelectRow(1,TRUE)
				dw_tchire_list.SetFocus()
			END IF

			redraw_on(parent) // SetRedraw(TRUE)
		ELSE
			MessageBox("Error","Delete did not occur!")
			dw_tchire_detail.SetFocus()
		END IF
	CASE 3
		IF MessageBox("Delete","You are about to DELETE the T/C Hire rate!~r~n" + &
						  "Are you sure you want to continue?",Question!,YesNo!,2) = 2 THEN RETURN

		IF dw_tchire_rates.DeleteRow(0) = 1 THEN
			IF dw_tchire_rates.Update() = 1 THEN
				COMMIT;
				IF dw_tchire_rates.RowCount() = 0 THEN
					dw_tchire_rates.TriggerEvent("ue_insert")
				ELSE
					dw_tchire_rates.SetFocus()
				END IF
			ELSE
				ROLLBACK;
				MessageBox("Error","Delete did not occur!")
				dw_tchire_rates.SetFocus()
			END IF
		ELSE
			ROLLBACK;
			MessageBox("Error","Delete did not occur!")
			dw_tchire_rates.SetFocus()
		END IF
END CHOOSE

end event

type cb_tchire_refresh from uo_securitybutton within w_tchire
integer x = 2263
integer y = 1428
integer width = 256
integer height = 80
integer taborder = 10
boolean enabled = false
string text = "&Refresh"
end type

event clicked;call super::clicked;
DATETIME cp_date
INT rc, rownr

CHOOSE CASE dw_focus
	CASE 0
		// Vessel selection
	CASE 1
		redraw_off(parent) // dw_tchire_list.SetRedraw(FALSE)
		rownr = dw_tchire_list.GetRow()
		dw_tchire_list.Retrieve(ii_vessel_nr)
		dw_tchire_list.SetRow(rownr)
		dw_tchire_list.SelectRow(rownr, TRUE)
		redraw_on(Parent) // dw_tchire_list.SetRedraw(TRUE)
		dw_tchire_list.SetFocus()
	CASE 2
		IF dw_tchire_list.RowCount() > 0 THEN
			redraw_off(parent) // dw_tchire_detail.SetRedraw(FALSE)
			cp_date = dw_tchire_list.GetItemDateTime(dw_tchire_list.GetRow(), "tchires_tchire_cp_date")
			rc = dw_tchire_detail.Retrieve(ii_vessel_nr, cp_date)
			IF NOT rc > 0 THEN
				dw_tchire_detail.InsertRow(0) /* Should not occur */
				dw_tchire_detail.Modify("redelivery.text = 'N/A'") 
			ELSE
				dw_tchire_detail.PostEvent("times")
				dw_tchire_detail.PostEvent("redelivery")
			END IF
			redraw_on(parent)
		END IF
		dw_tchire_detail.SetFocus()
	CASE 3
		IF dw_tchire_rates.RowCount() > 0 THEN
			cp_date = dw_tchire_rates.GetItemDateTime(dw_tchire_rates.GetRow(), "tchire_cp_date")
			redraw_off(parent) // dw_tchire_rates.SetRedraw(FALSE)
			rownr = dw_tchire_rates.GetRow()
			dw_tchire_rates.Retrieve(ii_vessel_nr, cp_date)
			dw_tchire_rates.SetRow(rownr)
			redraw_on(parent) // dw_tchire_rates.SetRedraw(TRUE)
			dw_tchire_rates.SetFocus()
		END IF
END CHOOSE

end event

type cb_secondary_brokers from commandbutton within w_tchire
integer x = 1659
integer y = 792
integer width = 489
integer height = 64
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Secondry Brokers..."
end type

event clicked;/* Local variables */
s_secondary_brokers ls_struct
long ll_row

if dw_tchire_list.rowcount() < 1 then return
if dw_tchire_list.rowcount() = 1 and isnull(dw_tchire_list.getitemdatetime(1,"tchires_tchire_cp_date"))then return

ll_row = dw_tchire_detail.GetRow()

/* If there is no Primary Broker, inform user and exit */
if isnull(dw_tchire_detail.getitemstring(ll_row,"brokers_broker_sn")) then
	messagebox("Notice","You can only add Secondary Brokers if there is a Primary Broker!")
	return
end if

/* Set structure to send data to secondary brokers window */
ls_struct.vessel_nr = ii_vessel_nr
ls_struct.cp_date = dw_tchire_detail.GetItemdatetime(ll_row,"tchires_tchire_cp_date")

/* Open non-cargo agents window with parameters */
openwithparm(w_choose_secondary_brokers,ls_struct)

end event

type st_2 from statictext within w_tchire
integer x = 128
integer y = 1420
integer width = 1467
integer height = 156
boolean bringtotop = true
integer textsize = -28
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 65535
string text = "ONLY HISTORY"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_tchire_detail from uo_datawindow within w_tchire
event redelivery pbm_custom54
event times pbm_custom08
integer x = 1221
integer y = 232
integer width = 1842
integer height = 784
integer taborder = 70
boolean enabled = false
string dataobject = "dw_tchire"
borderstyle borderstyle = styleraised!
end type

event redelivery;
/* Redelivery date */
DATETIME redelivery, cp_date
cp_date = dw_tchire_list.GetItemDateTime(dw_tchire_list.GetRow(), "tchires_tchire_cp_date")
SELECT MAX(TC_PERIOD_END)  
	INTO :redelivery
	FROM TCHIRERATES 
	WHERE VESSEL_NR = :ii_vessel_nr
	AND TCHIRE_CP_DATE = :cp_date;
IF NOT IsNull(redelivery) THEN
	Modify("redelivery.text = '"+String(Date(redelivery), "dd-mm-yy")+"'") 
ELSE
	Modify("redelivery.text = 'N/A'") 
END IF	

end event

event times;call super::times;
Time firstday, secondday
LONG c1, c2, c3, c4
firstday = Time(GetItemDateTime(GetRow(), "tchire_firstday_time"))
secondday = Time(GetItemDateTime(GetRow(), "tchire_secondday_time"))
c1 = Hour(firstday)
c2 = Minute(firstday)
c3 = Hour(secondday)
c4 = Minute(secondday)

redraw_off(parent)  // SetRedraw(FALSE)

SetItem(GetRow(), "compute_0021", c1)
SetItem(GetRow(), "compute_0022", c2)
SetItem(GetRow(), "compute_0023", c3)
SetItem(GetRow(), "compute_0024", c4)

redraw_on(parent) // SetRedraw(TRUE) 

end event

event itemchanged;call super::itemchanged;
String ls_shortname,ls_fullname
Integer li_number


/* Check payment days */
IF ( GetColumnName() = "tchires_payment_firstday" OR &
     GetColumnName() = "tchires_payment_secondday" ) THEN
	INT payment_day
	payment_day = Integer(GetText())
	IF payment_day > 31 OR payment_day < 0 THEN
		Messagebox("Payment day out of range!","The payment day should be in the interval:~r~r0-31", StopSign!)
		Return 1
	END IF
END IF

/* Check for setoffdates to be changed */
IF ( GetColumnName() = "tchires_payment_firstday" OR &
     GetColumnName() = "tchires_payment_secondday" ) THEN
	DATETIME cp_date
	INT setofftotal, rc
	cp_date = GetItemDateTime(GetRow(), "tchires_tchire_cp_date")

	IF NOT (IsNull(cp_date) OR Day(Date(cp_date))=0) THEN 
		/* Get first day */
		IF GetColumnName() = "tchires_payment_firstday" THEN
			SELECT PAYMENT_FIRSTDAY INTO :payment_day
				FROM TCHIRES 
				WHERE VESSEL_NR = :ii_vessel_nr
				AND TCHIRE_CP_DATE = :cp_date;
		END IF

		/* Get second day */
		IF GetColumnName() = "tchires_payment_secondday" THEN
			SELECT IsNull(PAYMENT_SECONDDAY,0) INTO :payment_day
			FROM TCHIRES 
			WHERE VESSEL_NR = :ii_vessel_nr
			AND TCHIRE_CP_DATE = :cp_date;
		END IF

		//////////////////////////////////////////
		
		

		/////////////////////////////////////////

		/* Check for set-off dates */
		INT setoffcount
		SELECT COUNT(*) INTO :setoffcount FROM TCHIREOFFHIRES
			WHERE DATEPART(day, OFFHIRE_SETOFFDATE) = :payment_day
			AND   VESSEL_NR = :ii_vessel_nr
			AND	TCHIRE_CP_DATE = :cp_date;
		setofftotal += setoffcount
		SELECT COUNT(*) INTO :setoffcount FROM TCHIREEXPENSES
			WHERE DATEPART(day, EXPENSE_SETOFFDATE) = :payment_day
			AND   VESSEL_NR = :ii_vessel_nr
			AND	TCHIRE_CP_DATE = :cp_date;
		setofftotal += setoffcount

		IF NOT setofftotal = 0 THEN
			rc = Messagebox("Reset of set-off dates", String(setofftotal)+" expenses and/or off-hires exist(s) with set-off date as the current payment day.~r~rThese set-off dates are required to be reset when changing the payment day.~r~rWould you like to reset the set-off dates?", Question!, YesNo!)
			IF rc = 1 THEN
				UPDATE TCHIREOFFHIRES
				SET OFFHIRE_SETOFFDATE = NULL
				WHERE DATEPART(day, OFFHIRE_SETOFFDATE) = :payment_day
				AND 	VESSEL_NR = :ii_vessel_nr
				AND	TCHIRE_CP_DATE = :cp_date;
				IF SQLCA.SqlCode=0 THEN
					UPDATE TCHIREEXPENSES
					SET EXPENSE_SETOFFDATE = NULL
					WHERE DATEPART(day, EXPENSE_SETOFFDATE) = :payment_day
					AND 	VESSEL_NR = :ii_vessel_nr
					AND	TCHIRE_CP_DATE = :cp_date;
					IF SQLCA.SqlCode=0 THEN
						COMMIT;
						Messagebox("Set-off dates reset", "The set-off dates with the current payment day has been reset.")
					ELSE
						ROLLBACK;
						Messagebox("Set-off dates not reset", "The set-off dates with the current payment day has not been reset.~r~rThe payment day cannot be changed.")
						Return 1
					END IF	
				ELSE
					ROLLBACK;
					Messagebox("Set-off dates not reset", "The set-off dates with the current payment day has not been reset.~r~rThe payment day cannot be changed.")
					Return 1
				END IF	
			ELSE
				Return 1
			END IF
		END IF
	END IF	
END IF

IF (GetColumnName() = "brokers_broker_sn") AND f_broker_sn_lookup (GetText()) THEN
	ls_shortname = dw_tchire_detail.GetText()
	SELECT BROKER_NR, BROKER_NAME INTO :li_number, :ls_fullname
	FROM BROKERS WHERE BROKER_SN = :ls_shortname;
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "brokers_broker_sn", ls_shortname)
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "brokers_broker_name", ls_fullname)
	dw_tchire_detail.SetItem(dw_tchire_detail.GetRow(), "tchires_broker_nr", li_number)
ELSEIF  (GetColumnName() = "brokers_broker_sn") AND Not(f_broker_sn_lookup (GetText())) THEN
	ls_shortname = dw_tchire_detail.GetText()
	MessageBox("Broker Search","'" + ls_shortname + "'" + " does not exist. Please use ?-button.")
	Return 1
END IF

end event

event itemerror;call super::itemerror;
String ls_column

ls_column =  GetColumnName() 

IF ls_column = "tchires_payment_firstday" THEN
	MessageBox("Error","Firstday must be greater than 0 and  less than 16 (if there is a secondday).")
ELSEIF  ls_column =  "tchires_payment_secondday" THEN
	MessageBox("Error","Secondday must be greater than 15 (or blank).Firstday must be less than 16 (if there is a secondday)." )
END IF

Return 1
end event

event getfocus;call super::getfocus;
dw_focus = 2

redraw_off(parent)  // SetRedraw(FALSE)

Boolean lb_setvalue
datetime cp_date
cp_date = GetItemDateTime(GetRow(), "tchires_tchire_cp_date")
lb_setvalue =  dw_tchire_list.find("tchires_tchire_cp_date=datetime('"+String(cp_date)+"')", 1, dw_tchire_list.RowCount()) > 0

cb_tchire_update.Enabled = TRUE
cb_tchire_refresh.Enabled = lb_setvalue
// cb_tchire_new.Enabled = TRUE
cb_tchire_delete.Enabled = lb_setvalue
cb_tchire_expensesoffhires.Enabled = lb_Setvalue
cb_tchire_generatehirestatement.Enabled = lb_setvalue

rb_daily.enabled = true
rb_monthly.enabled = true
cb_cont.enabled = true
dw_tchire_list.enabled  = true

redraw_on(parent) // SetRedraw(TRUE)

end event

event updatestart;call super::updatestart;LONG c1, c2, c3, c4

IF GetItemStatus(GetRow(), 0, Primary!) = NewModified! THEN
	tchire_insert = TRUE
ELSE
	tchire_insert = FALSE
END IF

IF GetColumnName() = "compute_0021" THEN
	c1 = Long(GetText())
ELSE
	c1 = GetItemNumber(GetRow(), "compute_0021")
END IF
IF GetColumnName() = "compute_0022" THEN
	c2 = Long(GetText())
ELSE
	c2 = GetItemNumber(GetRow(), "compute_0022")
END IF
IF GetColumnName() = "compute_0023" THEN
	c3 = Long(GetText())
ELSE
	c3 = GetItemNumber(GetRow(), "compute_0023")
END IF
IF GetColumnName() = "compute_0024" THEN
	c4 = Long(GetText())
ELSE
	c4 = GetItemNumber(GetRow(), "compute_0024")
END IF

SetItem(GetRow(), "tchire_firstday_time", DateTime(Date(1,1,1), Time(c1,c2,0)))
SetItem(GetRow(), "tchire_secondday_time", DateTime(Date(1,1,1), Time(c3,c4,0)))

STRING voyage_nr
LONG voy_vessel_nr, ll_vessel_nr
voyage_nr = GetItemString(GetRow(), "tchires_voyage_nr")
IF voyage_nr = "" OR IsNull(voyage_nr) THEN
	SetNull(voy_vessel_nr)
	SetItem(GetRow(), "tchires_voy_vessel_nr", voy_vessel_nr)
ELSE
	ll_vessel_nr = GetItemNumber(GetRow(), "tchires_vessel_nr")
	SetItem(GetRow(), "tchires_vessel_nr", ll_vessel_nr)
END IF

end event

