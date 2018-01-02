$PBExportHeader$w_daily_running_costs.srw
$PBExportComments$This window handles a vessels daily running costs.
forward
global type w_daily_running_costs from w_vessel_basewindow
end type
type cb_cancel from commandbutton within w_daily_running_costs
end type
type cb_new from commandbutton within w_daily_running_costs
end type
type cb_close from commandbutton within w_daily_running_costs
end type
type cb_update from commandbutton within w_daily_running_costs
end type
type cb_delete from commandbutton within w_daily_running_costs
end type
type st_year from statictext within w_daily_running_costs
end type
type dw_1 from uo_datawindow within w_daily_running_costs
end type
type rb_budget from radiobutton within w_daily_running_costs
end type
type rb_jan from radiobutton within w_daily_running_costs
end type
type rb_feb from radiobutton within w_daily_running_costs
end type
type rb_mar from radiobutton within w_daily_running_costs
end type
type rb_apr from radiobutton within w_daily_running_costs
end type
type rb_may from radiobutton within w_daily_running_costs
end type
type rb_jun from radiobutton within w_daily_running_costs
end type
type rb_jul from radiobutton within w_daily_running_costs
end type
type rb_aug from radiobutton within w_daily_running_costs
end type
type rb_sep from radiobutton within w_daily_running_costs
end type
type rb_oct from radiobutton within w_daily_running_costs
end type
type rb_nov from radiobutton within w_daily_running_costs
end type
type rb_dec from radiobutton within w_daily_running_costs
end type
type st_1 from statictext within w_daily_running_costs
end type
type sle_year from singlelineedit within w_daily_running_costs
end type
type gb_1 from groupbox within w_daily_running_costs
end type
type rb_actual from radiobutton within w_daily_running_costs
end type
end forward

global type w_daily_running_costs from w_vessel_basewindow
integer width = 2496
integer height = 1804
string title = "Daily Running Costs"
string icon = "images\daily_running _costs.ico"
cb_cancel cb_cancel
cb_new cb_new
cb_close cb_close
cb_update cb_update
cb_delete cb_delete
st_year st_year
dw_1 dw_1
rb_budget rb_budget
rb_jan rb_jan
rb_feb rb_feb
rb_mar rb_mar
rb_apr rb_apr
rb_may rb_may
rb_jun rb_jun
rb_jul rb_jul
rb_aug rb_aug
rb_sep rb_sep
rb_oct rb_oct
rb_nov rb_nov
rb_dec rb_dec
st_1 st_1
sle_year sle_year
gb_1 gb_1
rb_actual rb_actual
end type
global w_daily_running_costs w_daily_running_costs

type variables


end variables

forward prototypes
public subroutine view_mode ()
public subroutine edit_mode ()
end prototypes

public subroutine view_mode ();/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : function view_mode
  
 Event	 :  n/a

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This function sets the buttons in the window the way they should be set when the user
			has gone into view_mode (viewing  data )

 Arguments : none

 Returns   : none

 Variables : none

 Other : 

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* enable year field */
sle_year.enabled = true
/* disenable update button */
cb_update.Enabled = FALSE
/* if there are rows in the dw then ... */
if dw_1.rowcount() > 0 then
	/* enable delete button */
	cb_delete.enabled = true
/* else if there are no rows in the dw then ... */
else
	/* disenable delete button */
	cb_delete.enabled = false
end if
/* enable new button */
cb_new.Enabled = TRUE
/* disenable cancel button */
cb_cancel.Enabled = FALSE
/* enable dropdown vessel dw */
uo_vesselselect.Enabled = TRUE
/* set new button as default */
cb_new.Default = TRUE
///* set focus to new button */
//cb_new.SetFocus()
/* enable all period radio buttons */
rb_budget.enabled  = true
rb_jan.enabled  = true
rb_feb.enabled  = true
rb_mar.enabled  = true
rb_apr.enabled  = true
rb_may.enabled  = true
rb_jun.enabled  = true
rb_jul.enabled  = true
rb_aug.enabled  = true
rb_sep.enabled  = true
rb_oct.enabled  = true
rb_nov.enabled  = true
rb_dec.enabled  = true
rb_actual.enabled  = true
end subroutine

public subroutine edit_mode ();/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : function edit_mode
  
 Event	 :  n/a

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This function sets the buttons in the window the way they should be set when the user
			has gone into edit_mode (adding new data )

 Arguments : none

 Returns   : none

 Variables : none

 Other : 

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* set vessel dropdown dw as not enabled */
uo_vesselselect.Enabled = FALSE
/* enable cancel button */
cb_cancel.Enabled = TRUE
/* enable update button */
cb_update.Enabled = TRUE
/* disenable delete button */
cb_delete.Enabled = FALSE
/* disenable new button */
cb_new.Enabled = FALSE
/* disenable year field */
sle_year.Enabled = FALSE
/* set update button as default */
cb_update.Default = TRUE
/* disenable all radio buttons for periods */
rb_budget.enabled  = false
rb_jan.enabled  = false
rb_feb.enabled  = false
rb_mar.enabled  = false
rb_apr.enabled  = false
rb_may.enabled  = false
rb_jun.enabled  = false
rb_jul.enabled  = false
rb_aug.enabled  = false
rb_sep.enabled  = false
rb_oct.enabled  = false
rb_nov.enabled  = false
rb_dec.enabled  = false
rb_actual.enabled  = false
end subroutine

on ue_delete;call w_vessel_basewindow::ue_delete;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : window
  
 Event	 :  ue_delete

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event deletes the current row.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			pbt		Initial Version
  
*************************************************************************************************************************************************/

Long ll_row

/* if there are no rows in the dw, then return */
IF dw_1.RowCount() < 1 THEN return
/* get current row and if none selected return */
ll_row = dw_1.GetRow()
if ll_row < 1 then return
/* if the user respondes to the messagebox that they do not want to delete the row, then return */
IF messagebox("Delete","You are about to delete a Daily Running Cost!~r~n Are you sure?",Question!,Yesno!,2) = 2 then return
/* if current row is invalid, then return */
IF ll_row < 1 THEN Return
/* if deletetion of row is OK then ...*/
IF dw_1.DeleteRow(ll_row) = 1 THEN
	/* if update of dw is OK then ... */
	IF dw_1.Update() = 1 THEN
		/* commit the transaction */
		Commit;
	/* else if update of dw is NOT OK then ... */
	ELSE
		/* rollback transaction */
		RollBack;
	END IF
/* else if deletetion of row is NOT OK then ...*/
ELSE
	/* rollback deletion */
	Rollback;
END IF
/* call view_mode to set button etc. */
view_mode()

end on

event ue_retrieve;call super::ue_retrieve;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : window
  
 Event	 :  ue_retrieve

 Scope     : Local

 **************************************************************************************************************************************************
  
 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event retrieves the datawindow for the vessel, period and year.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01_03_96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/

long ll_row
int li_year, li_month
/* Get year from the single line edit */
li_year = Integer(sle_year.text)
/* if year has not been filled in then ... */
IF IsNull(sle_year.text) THEN 
	/* inform user of problem */
	messagebox("Notice","The year field is not correctly filled in!")
	/* return from event */
	Return
end if
/* Get which period it is by finding the checked radio button */
if rb_budget.checked then li_month = 0
if rb_jan.checked then li_month = 1
if rb_feb.checked then li_month = 2
if rb_mar.checked then li_month = 3
if rb_apr.checked then li_month = 4
if rb_may.checked then li_month = 5
if rb_jun.checked then li_month = 6
if rb_jul.checked then li_month = 7
if rb_aug.checked then li_month = 8
if rb_sep.checked then li_month = 9
if rb_oct.checked then li_month = 10
if rb_nov.checked then li_month = 11
if rb_dec.checked then li_month = 12
if rb_actual.checked then li_month = 13
/* retrieve datawindow for this vessel, year and period */
dw_1.Retrieve(ii_vessel_nr,li_year,li_month)	
/* see how many rows were retrieved */
ll_row = dw_1.RowCount()
/* if any rows were retrieved then ... */
IF ll_row > 0 THEN
	/* deselect all rows */
	dw_1.SelectRow(0,FALSE)
//	/* select last row */
//	dw_1.SelectRow(ll_row,TRUE)
	/* scroll to last row */
	dw_1.ScrollToRow(ll_row)
	/* set last row as current */
	dw_1.setrow(ll_row)
END IF
/* call view_mode function to set buttons etc. */
view_mode()
end event

event ue_insert;call super::ue_insert;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : window
  
 Event	 :  ue_insert

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event inserts a new row in the datawindow for the current period (as defined
			by the checked radio button). It sets the startdate to a default value.

 Arguments : none

 Returns   : none

 Variables : none

 Other : {other comments }

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Intial Version
  
*************************************************************************************************************************************************/

DateTime ldt_max_period_end
Date ld_temp
int li_month 
/* call edit_mode function to set buttons etc */
edit_mode()
/* deselect all rows in datawindow so none is highlighted */
dw_1.selectrow(0,false)
/* insert a new row in datawindow */
dw_1.InsertRow(0)
/* set vessel_nr in new row */
dw_1.SetItem(dw_1.RowCount(),"vessel_nr",ii_vessel_nr)
/* Find out which period has been chosen (radio buttons ) */
if rb_budget.checked then li_month = 0
if rb_jan.checked then li_month = 1
if rb_feb.checked then li_month = 2
if rb_mar.checked then li_month = 3
if rb_apr.checked then li_month = 4
if rb_may.checked then li_month = 5
if rb_jun.checked then li_month = 6
if rb_jul.checked then li_month = 7
if rb_aug.checked then li_month =8 
if rb_sep.checked then li_month = 9
if rb_oct.checked then li_month = 10
if rb_nov.checked then li_month = 11
if rb_dec.checked then li_month = 12
if rb_actual.checked then li_month = 13
/* set period in new row to chosen */
dw_1.SetItem(dw_1.RowCount(),"drc_month_key",li_month)
/* if this is not the first row for this period then ... */
IF dw_1.RowCount() > 1 THEN
	/* get largest end date for this vessel, year, period */
	SELECT max(PERIOD_END)
	INTO :ldt_max_period_end
	FROM DAILY_RUNNING_COSTS
	WHERE VESSEL_NR = :ii_vessel_nr and
			DRC_MONTH_KEY = :li_month;
	/* set new rows start date to date after largest end date for this ves, year and period */
	ld_temp = Date(ldt_max_period_end)
	ld_temp = RelativeDate(ld_temp,1)
	dw_1.SetItem(dw_1.RowCount(),"period_start",ld_temp)
/* if this is  the first row for this period then ... */
ELSE
	/* set new rows start date to today */
	dw_1.SetItem(dw_1.RowCount(),"period_start",Today())
END IF
/* scroll to the new row */
dw_1.scrolltorow(dw_1.rowcount())
/* set new row current */
dw_1.setrow(dw_1.rowcount())
/* set focus to datawindow */
dw_1.SetFocus()
/* If this is not the first row for this period, set column focus to period end */
IF dw_1.RowCount() > 1 THEN dw_1.SetColumn("period_end")
end event

on ue_update;call w_vessel_basewindow::ue_update;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : window
  
 Event	 :  ue_update

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event updates the datawindow.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* If update of row is OK then ... */
IF dw_1.Update() = 1 THEN
	/* commit the transaction */
	Commit;
	/* reselect row */
	dw_1.ReSelectRow(dw_1.RowCount())
	/* call view_mode function to set buttons etc */
	view_mode()
/* else if update of row is NOT OK then ... */
ELSE
	/* rollback the transaction */
	Rollback;
END IF
end on

event open;call super::open;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : window
  
 Event	 :  Open

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This window lets the user enter daily running costs for a vessel. The daily running costs
			are entered for a whole year each month. The user enters aproximations at the start
			of the year and as the year progresses, the data gets more and more accurate. The
			system keeps the data for each month, and therefore, the window has radio buttons
			for each period. The first period "start", if for the first time the user enters data. A
			column "DRC_MONTH_KEY" has been created in the table, and holds the period the 
			entry is for, 0 = start, 1 = january etc.

 Arguments : makes use of the global vessel_nr if one has been chosen.

 Returns   : none

 Variables : 

 Other : 

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* Place the window correctly */
this.Move(20,20)
/* Set datawindows tranaction object */
dw_1.SetTransObject(SQLCA)
/* Set the year field to current year */
sle_year.text = String(Year(Today()))
/* If a global vessel_nr is active then ... */

uo_vesselselect.of_registerwindow( w_daily_running_costs )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()

/* call view_mode function to set buttons etc */
view_mode()

end event

on w_daily_running_costs.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_new=create cb_new
this.cb_close=create cb_close
this.cb_update=create cb_update
this.cb_delete=create cb_delete
this.st_year=create st_year
this.dw_1=create dw_1
this.rb_budget=create rb_budget
this.rb_jan=create rb_jan
this.rb_feb=create rb_feb
this.rb_mar=create rb_mar
this.rb_apr=create rb_apr
this.rb_may=create rb_may
this.rb_jun=create rb_jun
this.rb_jul=create rb_jul
this.rb_aug=create rb_aug
this.rb_sep=create rb_sep
this.rb_oct=create rb_oct
this.rb_nov=create rb_nov
this.rb_dec=create rb_dec
this.st_1=create st_1
this.sle_year=create sle_year
this.gb_1=create gb_1
this.rb_actual=create rb_actual
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_new
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_delete
this.Control[iCurrent+6]=this.st_year
this.Control[iCurrent+7]=this.dw_1
this.Control[iCurrent+8]=this.rb_budget
this.Control[iCurrent+9]=this.rb_jan
this.Control[iCurrent+10]=this.rb_feb
this.Control[iCurrent+11]=this.rb_mar
this.Control[iCurrent+12]=this.rb_apr
this.Control[iCurrent+13]=this.rb_may
this.Control[iCurrent+14]=this.rb_jun
this.Control[iCurrent+15]=this.rb_jul
this.Control[iCurrent+16]=this.rb_aug
this.Control[iCurrent+17]=this.rb_sep
this.Control[iCurrent+18]=this.rb_oct
this.Control[iCurrent+19]=this.rb_nov
this.Control[iCurrent+20]=this.rb_dec
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.sle_year
this.Control[iCurrent+23]=this.gb_1
this.Control[iCurrent+24]=this.rb_actual
end on

on w_daily_running_costs.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_new)
destroy(this.cb_close)
destroy(this.cb_update)
destroy(this.cb_delete)
destroy(this.st_year)
destroy(this.dw_1)
destroy(this.rb_budget)
destroy(this.rb_jan)
destroy(this.rb_feb)
destroy(this.rb_mar)
destroy(this.rb_apr)
destroy(this.rb_may)
destroy(this.rb_jun)
destroy(this.rb_jul)
destroy(this.rb_aug)
destroy(this.rb_sep)
destroy(this.rb_oct)
destroy(this.rb_nov)
destroy(this.rb_dec)
destroy(this.st_1)
destroy(this.sle_year)
destroy(this.gb_1)
destroy(this.rb_actual)
end on

event activate;call super::activate;m_tramosmain.mf_setcalclink(False)
end event

event ue_vesselselection;call super::ue_vesselselection;postevent( "ue_retrieve" )
end event

type st_hidemenubar from w_vessel_basewindow`st_hidemenubar within w_daily_running_costs
end type

type uo_vesselselect from w_vessel_basewindow`uo_vesselselect within w_daily_running_costs
end type

type cb_cancel from commandbutton within w_daily_running_costs
integer x = 617
integer y = 1540
integer width = 325
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "C&ancel"
boolean cancel = true
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : cb_cancel
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event deletes the new row inserted and sets buttons etc.

 Arguments : none

 Returns   : none

 Variables : 

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* delete the new row */
dw_1.DeleteRow(dw_1.RowCount())
/* call view_mode function to set buttons etc. */
view_mode()
end on

type cb_new from commandbutton within w_daily_running_costs
integer x = 1312
integer y = 1540
integer width = 325
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&New "
boolean default = true
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : cb_new
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This triggers the ue_insert for the window

 Arguments : none

 Returns   : none

 Variables : 

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* trigger event ue_insert for window */
parent.TriggerEvent("ue_insert")
end on

type cb_close from commandbutton within w_daily_running_costs
integer x = 2021
integer y = 1540
integer width = 325
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : cb_close
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event closes the window

 Arguments : none

 Returns   : none

 Variables : 

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* close window */
Close(Parent)
end on

type cb_update from commandbutton within w_daily_running_costs
string tag = "Update Data"
integer x = 1659
integer y = 1540
integer width = 325
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Update"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : cb_update
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event triggers the ue_update for the window

 Arguments : none

 Returns   : none

 Variables : 

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* trigger event ue_update for window */
parent.TriggerEvent("ue_update")

end on

type cb_delete from commandbutton within w_daily_running_costs
integer x = 960
integer y = 1540
integer width = 325
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : cb_delete
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event triggers the ue_delete for the window

 Arguments : none

 Returns   : none

 Variables : 

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* trigger event ue_delete of window */
parent.TriggerEvent("ue_delete")
end on

type st_year from statictext within w_daily_running_costs
integer x = 1001
integer y = 1224
integer width = 96
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "  "
boolean focusrectangle = false
end type

type dw_1 from uo_datawindow within w_daily_running_costs
integer x = 18
integer y = 236
integer width = 1746
integer height = 1208
integer taborder = 80
string dataobject = "dw_daily_running_costs"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;call super::clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : dw_1
  
 Event	 :  clicked

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event highlights the new clicked row.

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 	------- 	----- 	-------------------------------------------
  01-03-96	2.12		PBT		Initial Version
  10-09-97	5.0		BO			Remove obsolete functions in PB 5.0
*************************************************************************************************************************************************/
/* if window is in edit mode return */
IF cb_update.enabled then return
/* if clicked row is valid then ... */
IF row > 0 THEN
	/* deselect all rows */
	this.SelectRow(0,FALSE)
	/* select the clicked row */
	this.SelectRow(row,TRUE)
	/* set the clicked row as current */
	this.SetRow(row)
END IF
end event

type rb_budget from radiobutton within w_daily_running_costs
string tag = "Chooses Start for the chosen year"
integer x = 1829
integer y = 268
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Budget"
boolean checked = true
boolean automatic = false
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_start
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_jan from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 352
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "January"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_jan
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_feb from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 436
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Febuary"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_feb
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_mar from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 520
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "March"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_mar
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_apr from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 604
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "April"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_apr
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_may from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 688
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "May"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_may
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_jun from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 772
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "June"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_jun
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_jul from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 856
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "July"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_jul
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_aug from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 940
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "August"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_aug
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_sep from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 1024
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "September"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_sep
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_oct from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 1108
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "October"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_oct
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_nov from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 1192
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "November"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_nov
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type rb_dec from radiobutton within w_daily_running_costs
integer x = 1829
integer y = 1276
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "December"
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_dec
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

type st_1 from statictext within w_daily_running_costs
integer x = 1358
integer y = 92
integer width = 183
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Year :"
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_daily_running_costs
integer x = 1509
integer y = 92
integer width = 215
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean autohscroll = false
end type

on modified;parent.PostEvent("ue_retrieve")
end on

type gb_1 from groupbox within w_daily_running_costs
integer x = 1792
integer y = 204
integer width = 549
integer height = 1240
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Period"
end type

type rb_actual from radiobutton within w_daily_running_costs
string tag = "Chooses Start for the chosen year"
integer x = 1829
integer y = 1360
integer width = 366
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Actual"
boolean automatic = false
end type

on clicked;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_daily_running_costs
  
 Object     : rb_start
  
 Event	 :  clicked

 Scope     : local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 01-03-96

 Description : This event re-retrieves the datawindow for this period when the radio button is clicked

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  01-03-96	2.12			PBT		Initial Version
  
*************************************************************************************************************************************************/
/* postevent the ue_retrieve for the window */
parent.PostEvent("ue_retrieve")
end on

