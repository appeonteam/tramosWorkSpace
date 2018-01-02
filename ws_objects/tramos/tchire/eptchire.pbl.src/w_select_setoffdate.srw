$PBExportHeader$w_select_setoffdate.srw
$PBExportComments$Select set-off date
forward
global type w_select_setoffdate from mt_w_response
end type
type dw_1 from datawindow within w_select_setoffdate
end type
type cb_cancel from commandbutton within w_select_setoffdate
end type
type cb_ok from commandbutton within w_select_setoffdate
end type
end forward

global type w_select_setoffdate from mt_w_response
integer x = 1079
integer y = 552
integer width = 882
integer height = 888
string title = "Select set-off date"
boolean controlmenu = false
long backcolor = 81324524
event ue_retrieve pbm_custom01
dw_1 dw_1
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_select_setoffdate w_select_setoffdate

type variables
LONG vessel_nr
DATETIME cp_date
end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_retrieve;// ********************************************************************
// 					GENERATE PAYMENT PERIODS USING PAYMENT DAY(S)
// ********************************************************************

S_HIRE_STATEMENT charters_payment[]

INT firstday, secondday, no_of_periods, li_row
DATETIME firstday_time, secondday_time, delivery_date, redelivery_date

//Boolean lb_test
String testdate

SetNull(secondday)

SELECT max(TC_PERIOD_END)  
	INTO :redelivery_date
	FROM TCHIRERATES  
	WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;
SELECT DELIVERY_DATE   
	INTO :delivery_date
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;

SELECT PAYMENT_FIRSTDAY, PAYMENT_SECONDDAY, FIRSTDAY_TIME, SECONDDAY_TIME
	INTO :firstday, :secondday, :firstday_time, :secondday_time
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;

IF IsNull(firstday) OR IsNull(firstday_time) Or (firstday = 0 ) THEN
	Messagebox("Payment day or time invalid!", "The first payment day or time is invalid.~r~rPlease check the first payment day and time and re-try the operation.", StopSign!, OK!)
	Return
END IF

If IsNull(redelivery_date)  Then
	Messagebox("Redelivery date invalid!", "The redelivery day or time is invalid.~r~rPlease check redelivery date and time and re-try the operation.", StopSign!, OK!)
        Return
End if

/* For each month in hire statement period, i.e. startdate to enddate */
/* Find payment dates and build CHARTERS_PAYMENT structure. */

/* If two payment days then double number of payment periods */
INT i, j, aar, maaned, prevday, reset_count
STRING firstdate, seconddate
BOOLEAN found

i=2
j=0
aar = Year(Date(delivery_date))
maaned = Month(Date(delivery_date))

/* Initialize array */
FOR reset_count = 1 TO 50
	SetNull(charters_payment[reset_count].payment_date)
NEXT

charters_payment[1].payment_date = delivery_date

DO
	IF firstday <= 28 THEN
		firstdate = String(aar)+"/"+String(maaned)+"/"+String(firstday) 
	ELSE
		found = FALSE
		prevday = 0		
		DO
			firstdate = String(aar)+"/"+String(maaned)+"/"+String(firstday - prevday) 
//			testdate = String(firstday - prevday)+ "/" + String(maaned) +"/" + String(aar)

			IF IsDate(firstdate) THEN
				found = TRUE
			ELSE
//				Lb_test =  IsDate(testdate)
				prevday += 1
			END IF		
		LOOP UNTIL found
	END IF

	/* Create and verify first payment dates */
	IF IsDate(firstdate) THEN
		IF DaysAfter(Date(delivery_date), Date(firstdate)) > 0 AND &
			NOT DaysAfter(Date(redelivery_date), Date(firstdate)) > 0 THEN
			charters_payment[i].payment_date =  DateTime(Date(firstdate), Time(firstday_time))
			i += 1
		END IF
	END IF

	/* Create and verify second payment dates if valid */
	IF NOT IsNull(secondday) THEN
		IF secondday <= 28 THEN
			seconddate = String(aar)+"/"+String(maaned)+"/"+String(secondday)
		ELSE
			found = FALSE
			prevday = 0		
			DO
			seconddate = String(aar)+"/"+String(maaned)+"/"+String(secondday - prevday)
				IF IsDate(seconddate) THEN
					found = TRUE
				ELSE
					prevday += 1
				END IF		
			LOOP UNTIL found
		END IF

		IF IsDate(seconddate) THEN
			IF DaysAfter(Date(seconddate), Date(redelivery_date)) > 0 AND &
				DaysAfter(Date(delivery_date), Date(seconddate)) > 0 THEN
				charters_payment[i].payment_date = DateTime(Date(seconddate), Time(secondday_time))
				i += 1
			END IF
		END IF
	END IF

	IF Mod(Month(Date(delivery_date)) + j, 12) = 0 THEN
		aar += 1
		maaned = 1
	ELSE
		maaned += 1
	END IF

	j += 1
	
LOOP UNTIL Date(firstdate) > Date(redelivery_date)

no_of_periods = i - 1
//lb_setoffdates.SetRedraw(FALSE)

FOR i = 1 TO no_of_periods
	li_row = dw_1.InsertRow(0)
	dw_1.SetItem(li_row,1,Date(charters_payment[i].payment_date))
NEXT

dw_1.SelectRow(0,False)

//lb_setoffdates.selectitem(1)
//lb_setoffdates.SetRedraw(TRUE)
//Setfocus(lb_Setoffdates)
end event

public subroutine documentation ();/********************************************************************
	w_select_setoffdate
	
	<OBJECT>
	</OBJECT>
	<DESC>
	This is not used, updated for completeness
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

on open;S_EXPENSES_OFFHIRES parameter
parameter = Message.PowerObjectParm
vessel_nr = parameter.vessel_nr
cp_date = parameter.cp_date

PostEvent("ue_retrieve")
end on

on w_select_setoffdate.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
end on

on w_select_setoffdate.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_setoffdate
end type

type dw_1 from datawindow within w_select_setoffdate
integer x = 69
integer y = 32
integer width = 366
integer height = 680
integer taborder = 1
string dataobject = "d_setoffs"
boolean vscrollbar = true
boolean livescroll = true
end type

event clicked;
IF row > 0 THEN
	SelectRow(0,FALSE)
	SelectRow(row,TRUE)
END IF
end event

type cb_cancel from commandbutton within w_select_setoffdate
integer x = 549
integer y = 640
integer width = 238
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

on clicked;CloseWithReturn(parent,"cancel")

end on

type cb_ok from commandbutton within w_select_setoffdate
integer x = 549
integer y = 544
integer width = 238
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;Date setoffdate

setoffdate = dw_1.GetItemDate(dw_1.GetRow(),1)

CloseWithReturn(parent, String(setoffdate))

end event

