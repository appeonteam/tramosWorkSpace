$PBExportHeader$w_weekly_report_data.srw
forward
global type w_weekly_report_data from mt_w_response
end type
type st_3 from statictext within w_weekly_report_data
end type
type st_2 from statictext within w_weekly_report_data
end type
type st_1 from statictext within w_weekly_report_data
end type
type dw_1 from datawindow within w_weekly_report_data
end type
type cb_2 from commandbutton within w_weekly_report_data
end type
type cb_1 from commandbutton within w_weekly_report_data
end type
end forward

global type w_weekly_report_data from mt_w_response
integer width = 4581
integer height = 1352
string title = "Data for Weekly Fixture Report"
st_3 st_3
st_2 st_2
st_1 st_1
dw_1 dw_1
cb_2 cb_2
cb_1 cb_1
end type
global w_weekly_report_data w_weekly_report_data

type variables
Decimal {0} id_link_id
long il_rows
integer ii_link_to_calc

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_weekly_report_data
	
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
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		25/08/2014	CR3708		CCY018		Modified event ue_getwindowname
		28/08/2014	CR3781		CCY018		The window title match with the text of a menu item	
	</HISTORY>
********************************************************************/
end subroutine

on w_weekly_report_data.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
end on

on w_weekly_report_data.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;Long ll_rows, ll_counter,ll_charter, ll_exists
String ls_charter

id_link_id = Message.DoubleParm

this.move(0,0)

dw_1.SetTransObject(SQLCA)

IF IsValid(m_tcmain) THEN 
	dw_1.Object.Data = m_tcmain.iuo_wf.ids_report_data.object.data
	ii_link_to_calc = 0
	this.title = "Send to Weekly Fixture"
end if
IF IsValid(m_calcmain) THEN 
	dw_1.Object.Data = m_calcmain.iuo_wf.ids_report_data.object.data
	ii_link_to_calc = 1
	this.title = "Send Calc to Weekly Fixture"
end if

il_rows = dw_1.RowCount()

If NOT(il_rows > 0) THEN
	MessageBox("Information","There are no data for reports ?!")
	cb_2.Enabled = FALSE
END IF	

FOR ll_counter = 1 TO il_rows
	ll_charter = dw_1.GetItemNumber(ll_counter,"chart_nr")
	SELECT CHART.CHART_N_1  
   INTO :ls_charter  
   FROM CHART  
   WHERE CHART.CHART_NR = :ll_charter   ;
	Commit;
	dw_1.SetItem(ll_counter,"chart_chart_n_1",ls_charter)
NEXT	

SELECT DISTINCT IDENTITY_NR
INTO :ll_exists
FROM POOL_WEEKLY_FIXTURE
WHERE POOL_WEEKLY_FIXTURE.LINK_ID = :id_link_id
AND POOL_WEEKLY_FIXTURE.LINK_TO_CALCULATION = :ii_link_to_calc;
Commit;
IF ll_exists > 0 THEN 
	st_1.Visible = TRUE
	st_3.text = "As Id.No: " + String(ll_exists)
	st_2.Visible = TRUE
END IF

end event

event ue_getwindowname;call super::ue_getwindowname;if isvalid(m_tcmain) then 
	as_windowname = this.classname( ) + "_tc"
elseif isvalid(m_calcmain) then 
	as_windowname = this.classname( ) + "_calc"
else
	as_windowname = this.classname( )
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_weekly_report_data
end type

type st_3 from statictext within w_weekly_report_data
integer x = 1189
integer y = 1152
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_2 from statictext within w_weekly_report_data
boolean visible = false
integer x = 14
integer y = 1152
integer width = 1147
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "This fixture has been reported before !"
boolean focusrectangle = false
end type

type st_1 from statictext within w_weekly_report_data
boolean visible = false
integer x = 1833
integer y = 1152
integer width = 1833
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "If you update the existing will be cancelled and a new will be created."
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_weekly_report_data
event ue_keydown pbm_dwnkey
integer y = 24
integer width = 4539
integer height = 1072
integer taborder = 10
string title = "none"
string dataobject = "d_weekly_report_data"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_keydown;long ll_null
string ls_null

if key = KeySpaceBar! then 
	choose case this.getColumnName()
		case "chart_chart_n_1" 
			this.Event DoubleClicked(0,0, this.getRow(), this.object.chart_chart_n_1)
	end choose
end if

	
end event

event doubleclicked;STRING 	ls_rc
LONG		ll_rc
STRING 	fullname

if row > 0 then
	CHOOSE CASE dwo.name
		CASE "chart_chart_n_1"
			if not isNull(this.getItemNumber(row, "chart_nr")) then return
			ls_rc = f_select_from_list("dw_charterer_list", 2, "Short Name", 3, "Long Name", 1, "Select charterer...", false)
			IF NOT IsNull(ls_rc) THEN
				ll_rc = Long(ls_rc)
				SELECT CHART_N_1 INTO :fullname
				FROM CHART WHERE CHART_NR = :ll_rc;
				this.SetItem(row, "chart_chart_n_1", fullname)
				this.SetItem(row, "chart_nr", ll_rc)
			END IF
	END CHOOSE
end if
end event

type cb_2 from commandbutton within w_weekly_report_data
integer x = 3680
integer y = 1136
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Update"
boolean default = true
end type

event clicked;Long ll_identity_nr, ll_counter, ll_old_identity_nr
Datetime ldt_datetime
Decimal {0} ld_item_id

dw_1.Accepttext()

for ll_counter = 1 to il_rows
	if isnull(dw_1.getItemString(ll_counter, "cp_text")) or &
		isnull(dw_1.getItemNumber(ll_counter, "chart_nr")) then
		MessageBox("Warning","You must input a Cp Text and Charterer for all rows !")
		Return
	end if
next	
		
// If this is a calcule then check that commodity is filled out
IF dw_1.GetItemNumber(1,"commoditytestsum") > 0 THEN
	MessageBox("Warning","You must input a commodity for all rows !")
	Return
END IF
// Check that comment are filled out
IF dw_1.GetItemNumber(1,"commenttestsum") > 0 THEN
	MessageBox("Warning","You must input a comment for all rows !")
	Return
END IF

ldt_datetime = dw_1.GetItemDatetime(1,"reported_date")

// If exists the same link, then use the identity nr from existing
SELECT DISTINCT IsNull(IDENTITY_NR,0)
INTO :ll_old_identity_nr
FROM POOL_WEEKLY_FIXTURE
WHERE POOL_WEEKLY_FIXTURE.LINK_ID = :id_link_id 
AND POOL_WEEKLY_FIXTURE.LINK_TO_CALCULATION = :ii_link_to_calc;
Commit;	

IF ll_old_identity_nr > 0 THEN
	ll_identity_nr = ll_old_identity_nr
ELSE
	SELECT MAX(IDENTITY_NR)	
	INTO :ll_identity_nr
	FROM POOL_WEEKLY_FIXTURE;
	Commit;	
	ll_identity_nr ++
END IF

FOR ll_counter = 1 TO il_rows
	dw_1.SetItem(ll_counter,"pool_weekly_fixture_identity_nr",ll_identity_nr)
NEXT

// If exists old data for this link id...
IF ll_old_identity_nr > 0 THEN
	// Create a copy of latest with status new and with this link_id
	INSERT INTO POOL_WEEKLY_FIXTURE  
				( CHART_NR,   
				  VESSEL_NR,   
				  POOL_ID,   
				  LINK_ID,   
				  LINK_TO_CALCULATION,   
				  STATUS,   
				  REPORTED_DATE,   
				  CP_TEXT,   
				  COMMODITY,   
				  QUANTITY,   
				  FREIGHT_RATE,   
				  LOAD_PORTS,   
				  DISCHARGE_PORTS,   
				  DAYS_EWD,   
				  DAYS_IWD,   
				  TC_MONTH_EWD,   
				  TC_MONTH_IWD,   
				  TC_MONTH_INDEX100_IWD,   
				  COMMENT,   
				  IDENTITY_NR )  
		  SELECT POOL_WEEKLY_FIXTURE.CHART_NR,   
					POOL_WEEKLY_FIXTURE.VESSEL_NR,   
					POOL_WEEKLY_FIXTURE.POOL_ID,   
					POOL_WEEKLY_FIXTURE.LINK_ID,   
					POOL_WEEKLY_FIXTURE.LINK_TO_CALCULATION,   
					2,   
					:ldt_datetime,   
					POOL_WEEKLY_FIXTURE.CP_TEXT,   
					POOL_WEEKLY_FIXTURE.COMMODITY,   
					POOL_WEEKLY_FIXTURE.QUANTITY,   
					POOL_WEEKLY_FIXTURE.FREIGHT_RATE,   
					POOL_WEEKLY_FIXTURE.LOAD_PORTS,   
					POOL_WEEKLY_FIXTURE.DISCHARGE_PORTS,   
					POOL_WEEKLY_FIXTURE.DAYS_EWD * -1,   
					POOL_WEEKLY_FIXTURE.DAYS_IWD * -1,   
					POOL_WEEKLY_FIXTURE.TC_MONTH_EWD,   
					POOL_WEEKLY_FIXTURE.TC_MONTH_IWD,   
					POOL_WEEKLY_FIXTURE.TC_MONTH_INDEX100_IWD,   
					POOL_WEEKLY_FIXTURE.COMMENT,   
					POOL_WEEKLY_FIXTURE.IDENTITY_NR
			 FROM POOL_WEEKLY_FIXTURE
	WHERE POOL_WEEKLY_FIXTURE.ITEM_ID = 
			(SELECT Max(POOL_WEEKLY_FIXTURE.ITEM_ID) 
			 FROM  POOL_WEEKLY_FIXTURE
			 WHERE POOL_WEEKLY_FIXTURE.LINK_ID = :id_link_id AND 
					 POOL_WEEKLY_FIXTURE.LINK_TO_CALCULATION = :ii_link_to_calc AND
					 POOL_WEEKLY_FIXTURE.STATUS = 1);
END IF

IF dw_1.Update() = 1 THEN
	Commit;
	MessageBox("Information","Data has been saved with Identity # = "+string(ll_identity_nr))
	Close(Parent)
ELSE
	RollBack;
	MessageBox("Error","Error saving data. No data saved !")
END IF
end event

type cb_1 from commandbutton within w_weekly_report_data
integer x = 4110
integer y = 1136
integer width = 430
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel and Close"
end type

event clicked;Close(parent)
end event

