$PBExportHeader$w_print_hirestatement.srw
$PBExportComments$Hire statement
forward
global type w_print_hirestatement from w_print_basewindow
end type
type st_2 from statictext within w_print_hirestatement
end type
type cb_1 from commandbutton within w_print_hirestatement
end type
type cb_2 from commandbutton within w_print_hirestatement
end type
type cb_3 from commandbutton within w_print_hirestatement
end type
type cbx_final from checkbox within w_print_hirestatement
end type
type gb_1 from groupbox within w_print_hirestatement
end type
type sle_status from singlelineedit within w_print_hirestatement
end type
type st_3 from statictext within w_print_hirestatement
end type
type gb_2 from groupbox within w_print_hirestatement
end type
type dw_hirestartdate from datawindow within w_print_hirestatement
end type
type dw_hireenddate from datawindow within w_print_hirestatement
end type
end forward

global type w_print_hirestatement from w_print_basewindow
integer width = 4585
integer height = 2444
st_2 st_2
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
cbx_final cbx_final
gb_1 gb_1
sle_status sle_status
st_3 st_3
gb_2 gb_2
dw_hirestartdate dw_hirestartdate
dw_hireenddate dw_hireenddate
end type
global w_print_hirestatement w_print_hirestatement

type variables
LONG vessel_nr
DATETIME cp_date
BOOLEAN print_hirestatement, nolettergenerated

/* 1 = wordperfect output */
/* 2 = preview */
// INT what_to_generate=0
Int ii_stype
BOOLEAN generate_letter=FALSE

BOOLEAN generation_on=FALSE

DATETIME startdate, enddate, id_calc_enddate
INT 		outfile
STRING currency_code, vessel_name, profitcenter_name
LONG broker_no

S_HIRE_STATEMENT charters_payment[]
LONG 		tchire_no=0
LONG                   no_of_periods
DATETIME	delivery_date
STRING                help_text
INT 		tc_offhire_allowance, return_code, no, i
LONG		row_no, row_get
STRING	charter_fullname, charter_shortname
STRING	time_text, setoff_text
BOOLEAN	local_time, rateperday 
DECIMAL{2} tc_rate_per_day, tc_rate_per_day_org, charter=0, apm=0, mellem=0
DECIMAL {2} avg_hire
DECIMAL {4} hours, tc_days, hours_allowed, hours_notallowed
DATETIME	redelivery_date
DATETIME	tc_periode_start, tc_periode_end, setoffdate
S_HIRE_MONTH_AND_DAYS monthanddays[]
INT nodaysinmonth
LONG charter_no=0, owner_no=0
String is_addmellem



end variables

forward prototypes
public subroutine calculate_statement (integer pi_statementtype)
public subroutine filewrite_checknull (ref string ps_text)
public subroutine statement_header ()
public subroutine statement_main ()
public subroutine statement_payments ()
public subroutine writedate (datetime pd_enddate)
public subroutine writeoffhire (string ps_text)
public subroutine selectprint (string ps_dwname)
public subroutine statustext (string text)
public subroutine writedata (string ps_text, string ps_section, string ps_setoff, double pd_charter_amount, double pd_apm_amount, string ps_mellem)
end prototypes

public subroutine calculate_statement (integer pi_statementtype);
integer li_month, li_year

ii_stype = pi_statementtype

SetNull(no)
charter=0
apm=0
mellem=0

/* Help text */
IF ii_stype=1 THEN
	help_text = "Generating hire statement."
ELSEIF ii_stype = 2 THEN
	help_text = "Preparing hire statement preview."
END IF

IF generate_letter AND ii_stype = 1 THEN
	help_text = "Generating hire statement and letter."
END IF	

SELECT DELIVERY_DATE
	INTO :delivery_date   
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

SELECT MAX(TC_PERIOD_END)  
	INTO :redelivery_date  
   FROM TCHIRERATES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

/* Daily rate or monthly rate ? */
SELECT RATEPERDAY 
	INTO :rateperday
	FROM TCHIRERATES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

/* Get period for hire statement */
startdate = delivery_date
/* If final hire then set enddate to delivery datetime */
IF cbx_final.checked THEN 
	enddate = redelivery_date
	id_calc_enddate = enddate
ELSE
	enddate = dw_hireenddate.GetItemDatetime(1,1)
	li_year = year(date(enddate))
	li_month = month(date(enddate)) + 1
	IF li_month = 13 THEN
		li_month = 1
		li_year ++
	END IF

	id_calc_enddate = DateTime(date(li_year, li_month, 1) )	

	IF daysafter(date(enddate),date(Id_calc_enddate))>0 THEN id_calc_enddate = enddate
END IF

// **************************************************
//                  GENEATE HEADER
// **************************************************

generation_on = TRUE
SetPointer(HourGlass!)
Statustext(help_text)
dw_print.SetRedraw(FALSE)

SELECT BROKER_NR
	INTO	:broker_no
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

statement_header()
statement_payments()
statement_Main()
end subroutine

public subroutine filewrite_checknull (ref string ps_text);
IF isNull(ps_text) THEN
    FileWrite(Outfile," ")
ELSE
    FileWrite(OutFile,ps_text)
END IF	
end subroutine

public subroutine statement_header ();LONG 	 voyage_no=0
STRING	ls_charter_fullname, ls_charter_shortname, ls_owner_fullname, ls_owner_shortname
STRING	ls_time_text
BOOLEAN	lb_local_time 
DATETIME	ldt_delivery_date
INT 		li_i
SetNull(charter_no)
SetNull(owner_no)

SELECT DELIVERY_DATE   
	INTO :ldt_delivery_date   
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

SELECT VOYAGE_NR,
		 CHART_NR,
		 TCOWNER_NR,
		 CURR_CODE,
		 BROKER_NR,
		 LOCAL_TIME
	INTO	:voyage_no,
			:charter_no,
		   :owner_no,
			:currency_code,
			:broker_no,
			:local_time
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

IF ii_stype = 1 THEN /* WordPerfect */
	OutFile = FileOpen ("C:\TRAMOS\WP\FINHIRE.TXT", LineMode!, write!, LockReadWrite!, Replace!)
END IF

IF Charter_no = 0 OR IsNull(Charter_no) THEN
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(outfile, " ")                       // No Charter
	END IF
ELSE
	IF NOT IsNull(charter_no) THEN	
		SELECT CHART_N_1  
			INTO :charter_fullname  
 	 	  	FROM CHART
  		 	WHERE CHART_NR = :charter_no;
		COMMIT;
		IF ii_stype = 1 THEN /* WordPerfect */
			FileWrite(outfile, charter_fullname)
		END IF
		IF ii_stype = 2 THEN /* Preview */
			dw_print.Modify("charter_name.text = '"+charter_fullname+"'")
		END IF
	ELSE
		SELECT TCOWNER_N_1  
			INTO :ls_owner_fullname  
 	 	  	FROM TCOWNERS
  			WHERE TCOWNER_NR = :owner_no;
		COMMIT;
		IF ii_stype = 1 THEN /* WordPerfect */
			FileWrite(outfile, ls_owner_fullname)
		END IF
		IF ii_stype = 2 THEN /* Preview */
			dw_print.Modify("charter_name.text = '"+ls_owner_fullname+"'")
		END IF
	END IF
END IF	

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(OutFile, string(today(),"dd mmmm, yyyy"))
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("date.text = '"+string(today(),"dd mmmm, yyyy")+"'")  
END IF

SELECT PC_NAME 
   INTO :profitcenter_name  
   FROM VESSELS, PROFIT_C  
   WHERE ( PROFIT_C.PC_NR = VESSELS.PC_NR ) 
	AND ( VESSELS.VESSEL_NR = :vessel_nr )   ;
COMMIT;

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(outfile, profitcenter_name)
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("profitcenter.text = '"+profitcenter_name+"'")
END IF

IF cbx_final.Checked THEN
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite (Outfile, "- F I N A L  H I R E  S T A T E M E N T") 
	END IF
	IF ii_stype = 2 THEN /* Preview */
		dw_print.Modify("headtitle.text = '- F I N A L  H I R E  S T A T E M E N T'")
	END IF
ELSE
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite (Outfile, "- H I R E  S T A T E M E N T per. "+string(date(enddate),"dd mmmm, yyyy")) 
	END IF
	IF ii_stype = 2 THEN /* Preview */
		dw_print.Modify("headtitle.text = '- H I R E  S T A T E M E N T per. " + String(Date(enddate),"dd mmmm, yyyy") + "'")
	END IF
END IF

SELECT UPPER(VESSEL_NAME)
	INTO :vessel_name  
   FROM VESSELS
   WHERE VESSEL_NR = :vessel_nr ;
COMMIT;

/* Replace æ with Æ, ø with Ø, å with Å */
FOR i = 1 TO Len(vessel_name)
	CHOOSE CASE ASC(Mid(vessel_name, i, 1)) 
		CASE 230 /* æ */
			vessel_name = Left(vessel_name, i - 1)+Char(198)+Right(vessel_name, Len(vessel_name) - i) /* Æ */
		CASE 248 /* ø */
			vessel_name = Left(vessel_name, i - 1)+Char(216)+Right(vessel_name, Len(vessel_name) - i) /* Ø */
		CASE 229 /* å */
			vessel_name = Left(vessel_name, i - 1)+Char(197)+Right(vessel_name, Len(vessel_name) - i) /* Å */
	END CHOOSE
NEXT

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite (OutFile, "m.t. "+char(34)+vessel_name+char(34))
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("vessel.text = 'm.t. "+char(34)+vessel_name+char(34)+"'")
END IF

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite (OutFile, "Time Charter Party dated "+string(date(cp_date),"dd mmmm, yyyy"))
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("tcdated.text = 'Time Charter Party dated " + String(date(cp_date),"dd mmmm, yyyy") + "'")
END IF

IF local_time THEN
	time_text = "LT"
ELSE
	time_text= "UTC"
END IF

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(OutFile, String(Date(delivery_date),"dd.mm.yy")+" "+string(time(delivery_date),"hh.mm")+" "+time_text)
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("delivery.text = '"+String(Date(delivery_date),"dd.mm.yy")+" "+string(time(delivery_date),"hh.mm")+" "+time_text+"'")
END IF

SELECT max(TC_PERIOD_END)  
	INTO :redelivery_date  
	FROM TCHIRERATES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(OutFile, string(date(redelivery_date),"dd.mm.yy")+" "+string(time(redelivery_date),"hh.mm")+" "+time_text)
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("redelivery.text = '"+string(date(redelivery_date),"dd.mm.yy")+" "+string(time(redelivery_date),"hh.mm")+" "+time_text+"'")
END IF

SetNull(ls_charter_shortname)
SetNull(ls_owner_shortname)

IF NOT IsNull(charter_no) THEN
	SELECT CHART_SN  
		INTO :charter_shortname  
  	 	FROM CHART
  	 	WHERE CHART_NR = :charter_no   ;
	COMMIT;
ELSE
	SELECT TCOWNER_SN 
		INTO :ls_owner_shortname  
  	 	FROM TCOWNERS
  	 	WHERE TCOWNER_NR = :owner_no   ;
	COMMIT;
END IF

IF IsNull(ls_charter_shortname) AND IsNull(ls_owner_shortname) THEN
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(Outfile, " ")
	END IF
ELSE
	IF NOT IsNull(charter_shortname) THEN
		IF ii_stype = 1 THEN /* WordPerfect */
			FileWrite(Outfile, charter_shortname)
		END IF
		IF ii_stype = 2 THEN /* Preview */
			dw_print.Modify("charter.text = '"+charter_shortname+"'")
		END IF
	ELSE
		IF ii_stype = 1 THEN /* WordPerfect */
			FileWrite(Outfile, ls_owner_shortname)
		END IF
		IF ii_stype = 2 THEN /* Preview */
			dw_print.Modify("charter.text = '"+ls_owner_shortname+"'")
		END IF
	END IF
END IF

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(Outfile, "APM")
	FileWrite(OutFile, currency_code)
	FileWrite(OutFile, currency_code)
	FileClose(OutFile)
END IF
IF ii_stype = 2 THEN /* Preview */
	dw_print.Modify("charter_currency.text = '"+currency_code+"'")
	dw_print.Modify("apm_currency.text = '"+currency_code+"'")
END IF

dw_print.SetRedraw(TRUE)

end subroutine

public subroutine statement_main ();
string ls_tmp
Decimal {2} ld_charter_outstanding = 0,ld_apm_outstanding = 0

tc_rate_per_day_org = 0
nolettergenerated = FALSE

DECLARE tchire_periods CURSOR FOR  
	SELECT TC_RATE_PER_DAY,   
			TC_PERIOD_START, 
			TC_PERIOD_END, 
			OFFHIRE_ALLOWANCE
		FROM TCHIRERATES 
		WHERE VESSEL_NR = :vessel_nr 
		AND TCHIRE_CP_DATE = :cp_date;

OPEN tchire_periods;

FETCH tchire_periods
	INTO 	:tc_rate_per_day,
			:tc_periode_start,
			:tc_periode_end,
			:tc_offhire_allowance;

DO WHILE SQLCA.SQLCode = 0 
	/* If last period with specified interval */

	IF NOT DaysAfter(Date(id_calc_enddate), Date(tc_periode_end)) < 0 THEN

		WriteDate(id_calc_enddate)

		SQLCA.SQLCode = -1
		CONTINUE
	ELSE
		Writedate(tc_periode_end)
	End if

	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile, " ")
	END IF

	FETCH tchire_periods
		INTO 	:tc_rate_per_day,
				:tc_periode_start,
				:tc_periode_end,
				:tc_offhire_allowance;

	tc_rate_per_day_org = 0 

	help_text = help_text + "."
	statustext(help_text)
LOOP

CLOSE tchire_periods;
COMMIT;

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(OutFile, " ")
END IF

IF ii_stype = 2 THEN /* Preview */
	dw_print.GroupCalc()
END IF

dw_print.SetRedraw(TRUE)

// ********************************************************
// *********** LESS OFF HIRE ******************************
// ********************************************************

dw_print.SetRedraw(FALSE)

DECIMAL {2} bunker_price=0, diesel_price=0 
DECIMAL {3} bunker_ton=0, diesel_ton=0
DATETIME start_datetime, end_datetime
INT offhire_allowance, no_offhire_periods

hours=0

/************************************************/
/* Start Fetch offhire allowance into structure */
/************************************************/
S_HIRE_STATEMENT_OFFHIRE offhire_allow[]
STRING offhirerate
no_offhire_periods=0

DECLARE offhire_allow CURSOR FOR
	SELECT TC_PERIOD_START, 
			TC_PERIOD_END, 
			OFFHIRE_ALLOWANCE
		FROM TCHIRERATES
		WHERE VESSEL_NR = :vessel_nr 
		AND TCHIRE_CP_DATE = :cp_date
		ORDER BY TC_PERIOD_START;

OPEN offhire_allow;

DO
	no_offhire_periods ++
	FETCH offhire_allow INTO
	 	:offhire_allow[no_offhire_periods].startdate,
		:offhire_allow[no_offhire_periods].enddate,
		:offhire_allow[no_offhire_periods].allowance;

LOOP UNTIL SQLCA.SQLCode <> 0

no_offhire_periods --

CLOSE offhire_allow;
COMMIT;

/**********************************************/
/* End Fetch offhire allowance into structure */
/**********************************************/
DECLARE less_hire CURSOR FOR
		SELECT START_DATETIME,
			 END_DATETIME,
			 BUNKER_TON,
			 BUNKER_PRICE,
			 DIESEL_TON,
			 DIESEL_PRICE,
			 HOURS,
			 OFFHIRE_SETOFFDATE
		FROM TCHIREOFFHIRES
		WHERE VESSEL_NR = :vessel_nr 
		AND TCHIRE_CP_DATE = :cp_date
		AND 	START_DATETIME <= :enddate 
		ORDER BY	START_DATETIME;

OPEN less_hire;
	
FETCH less_hire INTO :start_datetime,
	:end_datetime,
	:bunker_ton,
	:bunker_price,
	:diesel_ton,
	:diesel_price,
	:hours,
	:setoffdate; 

IF SQLCA.SQLCode = 0 THEN
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile, "Less Off-Hire:")
	END IF
END IF

DO WHILE SQLCA.SQLCode = 0

	IF NOT IsNull(setoffdate) THEN
		setoff_text = String(date(setoffdate),"dd.mmm.yy")
	ELSE
		setoff_text = ""
	END IF

	If IsNull(setoffdate) or (setoffdate<=enddate) then  // MI TEST

	Writedata( string(date(start_datetime),"dd.mmm.yy")+" - "+ &
			 string(date(end_datetime),"dd.mmm.yy"), "Less Off-Hire:", setoff_text, no, no, "" )

	/**********/
	/*  HOURS */
	/**********/
	avg_hire = avg_hire(start_datetime, end_datetime, vessel_nr, cp_date)
	IF rateperday THEN
		offhirerate = "/day"
	ELSE
		nodaysinmonth = daysinmonth(date(start_datetime))
		avg_hire = Round(avg_hire * nodaysinmonth, 0)
		offhirerate = "/"+String(nodaysinmonth)+"/day"
	END IF

	/* Find the corresponding rate periods and check for off-hire allowance */
	/* Allowance = 9999, i.e. continued allowance */
	hours_notallowed = 0
	hours_allowed = 0
	
	FOR i = 1 TO no_offhire_periods 
		IF DaysAfter(Date(offhire_allow[i].startdate), Date(start_datetime)) >= 0 AND &
		    DaysAfter(Date(start_datetime), Date(offhire_allow[i].enddate)) >= 0 THEN
			/* Found period, now check for allowance available */
			IF offhire_allow[i].allowance >= 0 AND &
				NOT Round(offhire_allow[i].allowance,0)	= 9999 THEN /* 9999 = continued allowance */ 
				/* If all hours are allowed */
				IF offhire_allow[i].allowance >= hours THEN
					offhire_allow[i].allowance -= hours
					hours_allowed = hours
					hours_notallowed = 0
				ELSE /* Split the hours */
					hours_allowed = offhire_allow[i].allowance
					hours_notallowed = hours - hours_allowed
					offhire_allow[i].allowance = 0
				END IF
			ELSEIF Round(offhire_allow[i].allowance,0) = 9999 AND i >= 2 THEN 
				/* 1. Period cannot be continued - Use previous period */ 
				/* If all hours are allowed */
				IF offhire_allow[i - 1].allowance >= hours THEN
					offhire_allow[i - 1].allowance -= hours
					hours_allowed = hours
					hours_notallowed = 0
				ELSE /* Split the hours */
					hours_allowed = offhire_allow[i - 1].allowance
					hours_notallowed = hours - hours_allowed
					offhire_allow[i - 1].allowance = 0
				END IF
			ELSE
				hours_notallowed = hours
				hours_allowed = 0
			END IF
		
                       Exit
		END IF
	NEXT
	/* Off-hire hours allowed */
	IF hours_allowed > 0 THEN /* Allowed */
		/* Translate hours into decimal part of days */
		hours_allowed = round(((int(hours_allowed)*60 + (hours_allowed - int(hours_allowed))*100) /1440),4)
		
		ls_tmp = "  "+string(hours_allowed,"#0.0000")+" Days at "+&
						currency_code+" "+string(avg_hire,"#,##0.00")+&
						offhirerate+" (Within allowance)"
		If ii_stype = 2 then ls_tmp = "   " + ls_tmp
		Writedata(ls_tmp,"Less Off-Hire:", "", no, no, "" )
		
	END IF
	/* Off-hire hours not-allowed */
	IF hours_notallowed > 0 THEN /* Not allowed */
		/* Translate hours into decimal part of days */
		hours_notallowed = round(((int(hours_notallowed)*60 + (hours_notallowed - int(hours_notallowed))*100) /1440),4)
		IF rateperday THEN
			mellem = avg_hire * hours_notallowed
		ELSE
			mellem = (avg_hire/nodaysinmonth) * hours_notallowed
		END IF

		if not isnull(setoffdate) then
			apm += mellem 
		else
			ld_apm_outstanding += mellem
		end if		
	
		WriteOffHire("  "+string(hours_notallowed,"#0.0000")+" Days at "+&
						currency_code+" "+string(avg_hire,"#,###")+&
						offhirerate)
	END IF

	/**********/
	/* BUNKER */
	/**********/

	IF bunker_ton > 0 THEN
		mellem = bunker_ton * bunker_price
	
		if not isnull(setoffdate) then
			apm += mellem 
		else
			ld_apm_outstanding += mellem
		end if		

		WriteOffhire( "  IFO "+string(bunker_ton,"#,###0.000")+" mts at "+&
				string(bunker_price,"#,##0.00"))
	END IF

	/**********/
	/* DIESEL */
	/**********/

	IF diesel_ton > 0 THEN
		mellem = diesel_ton * diesel_price

		if not isnull(setoffdate) then
			apm += mellem 
		else
			ld_apm_outstanding += mellem
		end if		

		WriteOffHire( "  MDO "+string(diesel_ton,"#,###0.000")+" mts at "+&
				string(diesel_price,"#,##0.00"))
	END IF

	/* Adjust charterers payment for off-hires */
	FOR i = 1 TO no_of_periods
		IF Date(charters_payment[i].payment_date) = Date(setoffdate) THEN
			IF IsNull(bunker_price) THEN bunker_price = 0 
			IF IsNull(diesel_price) THEN diesel_price = 0 
			If IsNull(bunker_ton) Then bunker_ton = 0
			If IsNull(diesel_ton) then Diesel_ton = 0

			IF rateperday THEN
				charters_payment[i].amount -= avg_hire * hours_notallowed + &
														bunker_ton * bunker_price + &
														diesel_ton * diesel_price	
			ELSE
				charters_payment[i].amount -= (avg_hire/nodaysinmonth) * hours_notallowed + &
														bunker_ton * bunker_price + &
														diesel_ton * diesel_price	
			END IF
		END IF
	NEXT
	IF ii_stype = 1 THEN /* WordPerfect */
	  	FileWrite(Outfile," ")
	END IF

	end if //MI TEST

	FETCH less_hire INTO :start_datetime,
		 :end_datetime,
		 :bunker_ton,
		 :bunker_price,
		 :diesel_ton,
		 :diesel_price,
		 :hours,
		 :setoffdate; 

	help_text = help_text + "."
	statustext( help_text )
LOOP
CLOSE less_hire;	
COMMIT;

IF ii_stype = 2 THEN /* Preview */
	dw_print.GroupCalc()
END IF
dw_print.SetRedraw(TRUE)

// ********************************************************
// *********** EXPENSES OWNERS ACCOUNT ********************
// ********************************************************

dw_print.SetRedraw(FALSE)

STRING description
mellem=0

DECLARE owners CURSOR FOR
		SELECT EXPENSE_DESCRIPTION, EXPENSE_AMOUNT, EXPENSE_SETOFFDATE
		FROM TCHIREEXPENSES
		WHERE EXPENSE_OWNERS_ACC = 1
		AND VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date
		ORDER BY EXPENSE_SETOFFDATE ASC, EXPENSE_DESCRIPTION ASC;

OPEN owners;

FETCH owners INTO :description, :mellem, :setoffdate;

IF SQLCA.SQLCode = 0 THEN
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile, "Plus expenses for Owners Account:")
	END IF
END IF
	
DO WHILE SQLCA.SQLCode =0

	// apm += mellem flyttet ned

	IF NOT IsNull(setoffdate) THEN
		setoff_text = String(date(setoffdate),"dd.mmm.yy")
		apm += mellem 
	ELSE
		setoff_text = ""
		ld_apm_outstanding += mellem
	END IF

	Writedata(description, "Plus expenses for Owners Account:", setoff_text, &
		no, mellem, "~t~t"+string(mellem,"#,##0.00")) 

	If ii_stype = 2 then 	FileWrite(Outfile," ")

	/* Adjust charterers payment for expense */
	FOR i = 1 TO no_of_periods
		IF Date(charters_payment[i].payment_date) = Date(setoffdate) THEN
			charters_payment[i].amount -= mellem	
		END IF
	NEXT

	FETCH owners INTO :description, :mellem, :setoffdate;

	help_text = help_text + "."
	statustext( help_text )
LOOP
CLOSE owners;
COMMIT;

IF ii_stype = 2 THEN /* Preview */
	dw_print.GroupCalc()
END IF
dw_print.SetRedraw(TRUE)

// ********************************************************
// ********** EXPENSES CHARTERERS ACCOUNT *****************
// ********************************************************

dw_print.SetRedraw(FALSE)
mellem=0
DECLARE charters CURSOR FOR
		SELECT EXPENSE_DESCRIPTION, EXPENSE_AMOUNT, EXPENSE_SETOFFDATE
		FROM TCHIREEXPENSES
		WHERE EXPENSE_OWNERS_ACC = 0
		AND VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date
		ORDER BY EXPENSE_SETOFFDATE ASC, EXPENSE_DESCRIPTION ASC;
OPEN charters;
FETCH charters INTO :description, :mellem, :setoffdate;
IF SQLCA.SQLCode = 0 THEN
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile, "Less expenses for Charterers Account:")
	END IF
END IF
DO WHILE SQLCA.SQLCode = 0

	IF NOT IsNull(setoffdate) THEN
		setoff_text = String(date(setoffdate),"dd.mmm.yy")
		charter += mellem
	ELSE
		setoff_text = ""
		ld_charter_outstanding += mellem
	END IF

//	If (not IsNull(setoffdate) and (setoffdate=enddate)) or (cbx_final.checked)  then  // MI TEST

	Writedata(description, "Less expenses for Charterers Account:",  setoff_text, & 
		mellem, no,  "~t"+string(mellem,"#,##0.00") )

	IF ii_stype = 1 THEN FileWrite(Outfile," ")

	/* Adjust charterers payment for expense */
	FOR i = 1 TO no_of_periods
		IF Date(charters_payment[i].payment_date) = Date(setoffdate) THEN
			charters_payment[i].amount += mellem
		END IF
	NEXT

//	end if // MI TEST 

	FETCH charters INTO :description, :mellem, :setoffdate;
	help_text = help_text + "."
	statustext(help_text)	
LOOP
CLOSE charters;
COMMIT;

IF ii_stype = 2 THEN /* Preview */
	dw_print.GroupCalc()
END IF
dw_print.SetRedraw(TRUE)

// ********************************************************
// *********** LESS CHARTERERS PAYMENT ********************
// ********************************************************
dw_print.SetRedraw(FALSE)
IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(OutFile,"Less Charterers Payments:")
END IF

FOR i = 1 TO no_of_periods 
	IF NOT IsNull(charters_payment[i].payment_date) THEN
		/* Calculation Exception handler! - Eliminate round errors! */
		IF i = no_of_periods AND charter - apm - charters_payment[no_of_periods].amount < 0.5 THEN
			charters_payment[no_of_periods].amount += charter - apm - charters_payment[no_of_periods].amount
		END IF 

		if charters_payment[i].amount > 0 then

			apm += Charters_payment[i].amount

			Writedata(String(charters_payment[i].payment_date, "dd.mmm.yy"), &
				 "Less Charterers Payments:", "", no, charters_payment[i].amount, &
				"~t"+	String(charters_payment[i].amount,"#,##0.00"))			
		end if
	END IF
NEXT

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(OutFile," ")
END IF

IF ii_stype = 2 THEN /* Preview */
	dw_print.GroupCalc()
END IF
dw_print.SetRedraw(TRUE)

// ********************************************************
// ******************* BALANCE ****************************
// ********************************************************

dw_print.SetRedraw(FALSE)

help_text = help_text + "."
statustext( help_text )

IF ii_stype = 1 THEN /* WordPerfect */
	filewrite(outfile,"~t"+string(charter,"#,##0.00")+"~t"+string(apm,"#,##0.00"))
END IF

IF ii_stype = 2 THEN /* Preview */
	dw_print.modify("charter_total.text = '"+string( charter, "#,##0.00#" ) + "'")
	dw_print.modify("apm_total.text = '"+string( apm, "#,##0.00" ) + "'" )

	If cbx_final.checked then 
		dw_print.modify("outstanding.text = 'Outstanding'") 
		dw_print.modify("charter_outstanding.text = '"+string(ld_apm_outstanding,"#,##0.00#")+"'")
		dw_print.modify("apm_outstanding.text = '"+string(ld_charter_outstanding,"#,##0.00#")+"'")
	else
		dw_print.modify("outstanding.text = ''")
		dw_print.modify("charter_outstanding.text = ''")
		dw_print.modify("apm_outstanding.text = ''")
	end if

	dw_print.Modify("favour.text = ''")
	dw_print.Modify("non_favour.text = ''")
	dw_print.Modify("balance_who.text = '")
END IF 

charter += ld_apm_outstanding
apm += ld_charter_outstanding
mellem = charter - apm 


IF Round(mellem,2) < 0 THEN /* In favour of APM */
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile,"Balance in favour of APM~t"+string((mellem * -1),"#,##0.00"))
		FileWrite(OutFile," ")
		FileWrite(OutFile,"~t"+string(apm,"#,##0.00")+"~t"+string(apm,"#,##0.00"))
		FileWrite(OutFile," ")
		FileWrite(OutFile," ")
		FileWrite(OutFile,"Please remit above amount to:")
	END IF
	IF ii_stype = 2 THEN /* Preview */
		dw_print.Modify("balance_who.text = 'Balance in favour of APM'")
		dw_print.Modify("favour.text = '"+string((mellem * -1),"#,##0.00")+"'")
		dw_print.Modify("charter_balance.text = '"+string(apm,"#,##0.00")+"'")
		dw_print.Modify("apm_balance.text = '"+string(apm,"#,##0.00")+"'")
	END IF
ELSEIF Round(mellem,2) > 0 THEN /* In favour of chaterers or owners */
	STRING hwo 
	IF NOT IsNull(charter_no) THEN
		hwo = "Charter"
	ELSE
		hwo = "Owner"
	END IF
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile,"Balance in favour of "+hwo+"~t~t"+string(mellem,"#,##0.00"))
		FileWrite(OutFile," ")
		FileWrite(OutFile,"~t"+string(charter, "#,###.00")+"~t"+string(charter,"#,###.00"))
	END IF
	IF ii_stype = 2 THEN /* Preview */
		dw_print.Modify("balance_who.text = 'Balance in favour of "+hwo+"'")
		dw_print.Modify("non_favour.text = '"+string(mellem,"#,##0.00")+"'")
		dw_print.Modify("charter_balance.text = '"+string(charter,"#,##0.00")+"'")
		dw_print.Modify("apm_balance.text = '"+string(charter,"#,##0.00")+"'")
	END IF
ELSE /* Balance equals */
	IF ii_stype = 1 THEN /* WordPerfect */
		FileWrite(OutFile," ")
		FileWrite(OutFile," ")
		FileWrite(OutFile,"~t"+string(charter, "#,###.00")+"~t"+string(charter,"#,###.00"))
	END IF
	IF ii_stype = 2 THEN /* Preview */
		dw_print.Modify("balance_who.text = ' '")
		dw_print.Modify("charter_balance.text = '"+string(charter,"#,##0.00")+"'")
		dw_print.Modify("apm_balance.text = '"+string(charter,"#,##0.00")+"'")
	END IF
END IF

IF ii_stype = 1 THEN /* WordPerfect */
	FileClose(OutFile)
END IF

IF ii_stype = 2 THEN /* Preview */
	dw_print.GroupCalc()
END IF
dw_print.SetRedraw(TRUE)

// ********************************************************
// ******* GENERATE LETTER IF APM'S FAVOUR ****************
// ********************************************************

help_text = help_text + "."
statustext( help_text )

STRING bname1, badr1, badr2, badr3, badr4, bland

IF generate_letter THEN /* Letter */
	OutFile = FileOpen ("C:\TRAMOS\WP\FINFB.TXT", LineMode!, write!, LockReadWrite!, Replace!)
END IF

IF generate_letter THEN /* Letter */
	IF Round(mellem,2) < 0 THEN
		SELECT BROKER_NAME,BROKER_A_1, BROKER_A_2, BROKER_A_3,BROKER_A_4,BROKER_C  
		INTO :bname1,:badr1,:badr2,:badr3,:badr4,:bland
     		 FROM BROKERS WHERE BROKER_NR = :broker_no;

		FileWrite_checkNull(bname1)

		/* Required field */
		FileWrite (OutFile, string(today(),"dd mmmm, yyyy"))

		FileWrite_CheckNull(ProfitCenter_Name)
		FileWrite_CheckNull(badr1)
		FileWrite_CheckNull(Badr2)
		/* Required field */

		FileWrite_CheckNull(badr3)
		FileWrite_CheckNull(badr4)
		FileWrite_CheckNull(bland)

		FileWrite (OutFile, "m.t. "+CHAR(34)+vessel_name+CHAR(34))
		FileWrite (OutFile, String(Date(cp_date),"dd mmmm, yyyy"))
		FileWrite (Outfile, currency_code+" "+String((mellem * -1),"#,##0.00"))

	ELSE	
		FileWrite (Outfile, "~r~n")
		IF hwo="" THEN
			Messagebox("No letter generated!", "The hire statement equals.~r~rAs a result, no letter is generated.")
		ELSE
			Messagebox("No letter generated!", "The hire statement shows balance in favour of "+Lower(hwo)+". ~r~rAs a result, no letter is generated.")
		END IF
		nolettergenerated = TRUE
	END IF
END IF

help_text = help_text + "."
statustext( help_text )

IF generate_letter THEN /* Letter */
	FileClose(OutFile)
END IF

generation_on = FALSE
statustext( "Ready" )
SetPointer(Arrow!)
COMMIT;
end subroutine

public subroutine statement_payments ();
// ********************************************************************
// 					GENERATE PAYMENT PERIODS USING PAYMENT DAY(S)
// ********************************************************************

INT firstday, secondday
DATETIME firstday_time, secondday_time
SetNull(secondday)

SELECT PAYMENT_FIRSTDAY, PAYMENT_SECONDDAY, FIRSTDAY_TIME, SECONDDAY_TIME
	INTO :firstday, :secondday, :firstday_time, :secondday_time
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr AND TCHIRE_CP_DATE = :cp_date;

IF IsNull(firstday) OR IsNull(firstday_time) THEN
	Messagebox("Payment day or time invalid!", "The first payment day or time is invalid.~r~rPlease check the first payment day and time and re-try the operation.", StopSign!, OK!)
END IF

/* For each month in hire statement period, i.e. startdate to enddate */
/* Find payment dates and build CHARTERS_PAYMENT structure. */

/* If two payment days then double number of payment periods */
INT j, aar, maaned, prevday, reset_count
STRING firstdate, seconddate
BOOLEAN found

help_text = help_text + "."
statustext(help_text)

i=2
j=0
aar = Year(Date(startdate))
maaned = Month(Date(startdate))

/* Initialize array */
FOR reset_count = 1 TO 50
	SetNull(charters_payment[reset_count].payment_date)
	charters_payment[reset_count].amount = 0
NEXT

charters_payment[1].payment_date = delivery_date
charters_payment[1].amount = 0

DO
	IF firstday <= 28 THEN
		firstdate = String(aar)+"/"+String(maaned)+"/"+String(firstday) 
	ELSE
		found = FALSE
		prevday = 0		
		DO
			firstdate = String(aar)+"/"+String(maaned)+"/"+String(firstday - prevday) 
			IF IsDate(firstdate) THEN
				found = TRUE
			ELSE
				prevday += 1
			END IF		
		LOOP UNTIL found
	END IF

	/* Create and verify first payment dates */
	IF IsDate(firstdate) THEN
		IF DaysAfter(Date(startdate), Date(firstdate)) > 0 AND &
			NOT DaysAfter(Date(id_calc_enddate), Date(firstdate)) > 0 THEN
			charters_payment[i].payment_date =  DateTime(Date(firstdate), Time(firstday_time))
			charters_payment[i].amount = 0
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
			IF DaysAfter(Date(seconddate), Date(id_calc_enddate)) > 0 AND &
				DaysAfter(Date(startdate), Date(seconddate)) > 0 THEN
				charters_payment[i].payment_date = DateTime(Date(seconddate), Time(secondday_time))
				charters_payment[i].amount = 0
				i += 1
			END IF
		END IF
	END IF

	j += 1
	IF Mod(Month(Date(startdate)) + j, 13) = 0 THEN
		aar += 1
		maaned = 1
	ELSE
		maaned += 1
	END IF
LOOP UNTIL Date(firstdate) > Date(id_calc_enddate)

no_of_periods = i - 1

/* Set amounts for payment periods, i.e. rate * #days */
FOR i = 1 TO no_of_periods
	IF i = 1 AND no_of_periods > 1 THEN
		charters_payment[i].amount = &
			round(timedifference(delivery_date, charters_payment[i+1].payment_date)/1440 * &
			avg_hire(delivery_date, charters_payment[i+1].payment_date, vessel_nr, cp_date) ,2)
	ELSEIF i = no_of_periods THEN
		charters_payment[i].amount = &
			round(timedifference(charters_payment[i].payment_date, id_calc_enddate)/1440 * &
			avg_hire(charters_payment[i].payment_date, id_calc_enddate, vessel_nr, cp_date),2)
	ELSE
		charters_payment[i].amount = &
			round(timedifference(charters_payment[i].payment_date, &
				charters_payment[i+1].payment_date)/1440 * &
			avg_hire(charters_payment[i].payment_date, &
						charters_payment[i+1].payment_date, vessel_nr, cp_date) ,2)
	END IF
	help_text = help_text + "."
	statustext( help_text )
NEXT

// ********************************************************************
// 		 		GENERATE RATES, OFF-HIRES, EXPENSES AND BALANCE
// ********************************************************************

IF ii_stype = 1 THEN /* WordPerfect */
	OutFile = FileOpen ("C:\TRAMOS\WP\FINHIRE.IMP", LineMode!, write!, LockReadWrite!, Replace!)
END IF

// ********************************************************************
// ************** HIRE PERIODS ****************************************
// ********************************************************************

dw_print.SetRedraw(FALSE)

IF ii_stype = 1 THEN /* WordPerfect */
	FileWrite(Outfile, " ")
	FileWrite(Outfile, "Hire Period:")
END IF

end subroutine

public subroutine writedate (datetime pd_enddate);
String ls_tmp,ls_add1,ls_add2

ls_tmp = string(date(tc_periode_start),"dd.mmm.yy")+" "+string(time(tc_periode_start),"hhmm")+" - "+&
		string(date(pd_enddate),"dd.mmm.yy")+" "+string(time(pd_enddate),"hhmm")

WriteData(ls_tmp,"Hire Period:", "", no, no, "")	

IF rateperday THEN
	tc_days = round((timedifference ( tc_periode_start, pd_enddate ))/1440,4)

	mellem = round(tc_days * tc_rate_per_day,2)
	charter += mellem

	ls_tmp = string(tc_days,"#0.####")+" Days at "+Trim(currency_code)+" "+ &
			string(tc_rate_per_day,"#,##0.00")+"/Day"

	WriteData(ls_tmp, "Hire Period:", "",  mellem, no, "~t"+string(mellem,"#,##0.00") )
else
	months_and_days(tc_periode_start, pd_enddate, monthanddays[])
			
	FOR i = 1 TO 3 
		IF NOT tc_rate_per_day_org = 0 THEN
			tc_rate_per_day = tc_rate_per_day_org
		END IF

		IF NOT IsNull(monthanddays[i].count) AND NOT monthanddays[i].count = 0 THEN
			IF monthanddays[i].dayormonth = TRUE THEN /* Use day rates */
				IF i = 1 THEN /* First month */
					tc_rate_per_day_org = tc_rate_per_day
					nodaysinmonth = daysinmonth(date(tc_periode_start))

//					IF Month(Date(tc_periode_start)) = 12 THEN /* If december */
//						nodaysinmonth = DaysAfter(Date(90, Month(Date(tc_periode_start)), 1), Date(91, 1, 1))
//					ELSE
//						nodaysinmonth = DaysAfter(Date(Year(Date(tc_periode_start)), Month(Date(tc_periode_start)), 1), Date(Year(Date(tc_periode_start)), Month(Date(tc_periode_start)) + 1, 1))
//					END IF	

				ELSEIF i = 2 AND IsNull(monthanddays[3].count) OR i = 3 THEN /* Last month */
					tc_rate_per_day_org = tc_rate_per_day
					nodaysinmonth = daysinmonth(date(pd_enddate))

//				IF Month(Date(pd_enddate)) = 12 THEN /* If december */
//						nodaysinmonth = DaysAfter(Date(90, Month(Date(pd_enddate)), 1), Date(91, 1, 1))
//					ELSE
//						nodaysinmonth = DaysAfter(Date(Year(Date(pd_enddate)), Month(Date(pd_enddate)), 1), Date(Year(Date(pd_enddate)), Month(Date(pd_enddate)) + 1, 1))
//					END IF
				END IF
			END IF

			IF monthanddays[i].dayormonth = TRUE THEN /* Daily rates */
				mellem = round(monthanddays[i].count * tc_rate_per_day / nodaysinmonth,2)
			ELSE
				mellem = round(monthanddays[i].count * tc_rate_per_day,2)
			END IF	
	
			charter += mellem

			If monthanddays[i].dayormonth = TRUE Then
	                	ls_add1 = " Days at "
				ls_add2 = "/"+String(nodaysinmonth)+"/Day"	
			Else
			 	ls_add1 = " Months at "
				ls_add2 = " per calender month"
			End if		

			ls_tmp = string(monthanddays[i].count,"#0.####") + ls_add1 + & 
					Trim(currency_code)+" "+ &
					string(tc_rate_per_day,"#,##0.00")+ ls_add2

			WriteData(ls_tmp,"Hire Period:", "", mellem, no, "~t" + String(mellem,"#,##0.00") )

		END IF
	NEXT
END IF

end subroutine

public subroutine writeoffhire (string ps_text);
If ii_stype = 2 Then ps_text = "   " +ps_text
		
Writedata(ps_text, "Less Off-Hire:", "",  no, mellem,  "~t~t"+string(mellem,"#,##0.00"))
end subroutine

public subroutine selectprint (string ps_dwname);
IF dw_print.dataobject <> ps_dwname THEN
   dw_print.dataobject = ps_dwname
   dw_print.SetTransObject(SQLCA)
END IF

dw_print.reset()	
end subroutine

public subroutine statustext (string text);
sle_status.text = text

If sle_status.visible = false then
   sle_status.visible = true
end if


end subroutine

public subroutine writedata (string ps_text, string ps_section, string ps_setoff, double pd_charter_amount, double pd_apm_amount, string ps_mellem);
CHOOSE CASE ii_stype
	CASE 1 // Wordperfect
		If ps_mellem <> "" then ps_text += ps_mellem
		FileWrite(OutFile, ps_text)
	CASE 2 // Preview
		row_get = dw_print.InsertRow(0)
		dw_print.SetItem(row_get, "section", ps_section)
		dw_print.SetItem(row_get, "text", ps_text)
//		dw_print.SetItem(row_get, "text", Left(ps_text,20) +"  " + string ( charter ) + "  " + string ( apM ))
		dw_print.Setitem(row_get, "setoff_date", ps_setoff)
		dw_print.SetItem(row_get, "charter_amount", pd_charter_amount)
		dw_print.SetItem(row_get, "apm_amount", pd_apm_amount)
END CHOOSE



end subroutine

event open;call super::open;
dw_hirestartdate.InsertRow(0)
dw_hireenddate.InsertRow(0)

cb_print.enabled = false
ii_startup = 1

BOOLEAN tchirein
DATETIME delivery, redelivery , tempdt
S_EXPENSES_OFFHIRES parameter
parameter = Message.PowerObjectParm
vessel_nr = parameter.vessel_nr
cp_date = parameter.cp_date

SELECT TCHIRE_IN 
	INTO 	:tchirein
	FROM 	TCHIRES 
	WHERE VESSEL_NR = :vessel_nr 
	AND 	TCHIRE_CP_DATE = :cp_date;
COMMIT;

Title = "Time-Charter Hire Statements - Vessel "+String(vessel_nr)+" - C/P Date "+String(cp_date, "dd-mm-yy")

/* Set start date, i.e. equal delivery date for the tchire */
SELECT DELIVERY_DATE 
	INTO :delivery 
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

dw_hirestartdate.SetItem(1,1, delivery)

SELECT MAX(TC_PERIOD_END) 
	INTO :redelivery 
	FROM TCHIRERATES  
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

IF IsNull(redelivery) THEN
	Messagebox("Redelivery date missing!", "The redelivery date is missing.~r~rUpdate the T/C Hire rates and re-try.", StopSign!)
	Close(this)
	Return
ELSE
	/* If today is before redelivery */
	IF daysAfter(Today(), Date(redelivery)) > 0 THEN
		tempdt = Datetime( Today(), Time("23:59:59"))
		dw_hireenddate.SetItem(1,1, tempdt)
	ELSE
		dw_hireenddate.SetItem(1,1, redelivery)
		cbx_final.Checked = TRUE
		cbx_final.Enabled = TRUE
	END IF	
END IF

dw_print.Modify("datawindow.Print.Margin.Left=380")

end event

event closequery;call super::closequery;IF generation_on THEN
	MessageBox("Info","You cannot close this window while the list/preview/generate function is active.") 
	Message.ReturnValue=1
END IF

end event

on w_print_hirestatement.create
int iCurrent
call super::create
this.st_2=create st_2
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cbx_final=create cbx_final
this.gb_1=create gb_1
this.sle_status=create sle_status
this.st_3=create st_3
this.gb_2=create gb_2
this.dw_hirestartdate=create dw_hirestartdate
this.dw_hireenddate=create dw_hireenddate
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.cbx_final
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.sle_status
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.dw_hirestartdate
this.Control[iCurrent+11]=this.dw_hireenddate
end on

on w_print_hirestatement.destroy
call super::destroy
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cbx_final)
destroy(this.gb_1)
destroy(this.sle_status)
destroy(this.st_3)
destroy(this.gb_2)
destroy(this.dw_hirestartdate)
destroy(this.dw_hireenddate)
end on

type cbx_save_size from w_print_basewindow`cbx_save_size within w_print_hirestatement
end type

type dw_print from w_print_basewindow`dw_print within w_print_hirestatement
integer taborder = 250
string dataobject = "d_hire_statement"
end type

type cb_fullpreview from w_print_basewindow`cb_fullpreview within w_print_hirestatement
integer taborder = 80
end type

type st_previewtext from w_print_basewindow`st_previewtext within w_print_hirestatement
end type

type em_zoom from w_print_basewindow`em_zoom within w_print_hirestatement
integer taborder = 200
end type

type cb_pageforward10 from w_print_basewindow`cb_pageforward10 within w_print_hirestatement
integer taborder = 240
end type

type cb_pageforward from w_print_basewindow`cb_pageforward within w_print_hirestatement
integer taborder = 230
end type

type cb_pageback from w_print_basewindow`cb_pageback within w_print_hirestatement
integer taborder = 220
end type

type cb_pageback10 from w_print_basewindow`cb_pageback10 within w_print_hirestatement
integer taborder = 210
end type

type st_percent from w_print_basewindow`st_percent within w_print_hirestatement
end type

type st_1 from w_print_basewindow`st_1 within w_print_hirestatement
end type

type st_misc_print_file from w_print_basewindow`st_misc_print_file within w_print_hirestatement
end type

type cbx_misc_print_to_file from w_print_basewindow`cbx_misc_print_to_file within w_print_hirestatement
integer taborder = 90
end type

type cbx_misc_collate_copies from w_print_basewindow`cbx_misc_collate_copies within w_print_hirestatement
integer taborder = 110
end type

type sle_misc_print_file from w_print_basewindow`sle_misc_print_file within w_print_hirestatement
integer taborder = 130
end type

type cb_misc_file from w_print_basewindow`cb_misc_file within w_print_hirestatement
integer taborder = 140
end type

type rb_range_pages from w_print_basewindow`rb_range_pages within w_print_hirestatement
end type

type rb_range_current from w_print_basewindow`rb_range_current within w_print_hirestatement
end type

type rb_range_all from w_print_basewindow`rb_range_all within w_print_hirestatement
end type

type cb_select_filecollate from w_print_basewindow`cb_select_filecollate within w_print_hirestatement
integer taborder = 70
end type

type cb_select_pages from w_print_basewindow`cb_select_pages within w_print_hirestatement
integer taborder = 60
end type

type cb_select_options from w_print_basewindow`cb_select_options within w_print_hirestatement
integer taborder = 50
end type

type st_range from w_print_basewindow`st_range within w_print_hirestatement
end type

type sle_range_range from w_print_basewindow`sle_range_range within w_print_hirestatement
integer taborder = 170
end type

type cb_options_printer from w_print_basewindow`cb_options_printer within w_print_hirestatement
integer taborder = 120
end type

type sle_options_no_copies from w_print_basewindow`sle_options_no_copies within w_print_hirestatement
integer taborder = 100
end type

type st_options_text from w_print_basewindow`st_options_text within w_print_hirestatement
end type

type st_options_2 from w_print_basewindow`st_options_2 within w_print_hirestatement
end type

type st_optins_1 from w_print_basewindow`st_optins_1 within w_print_hirestatement
end type

type cb_cancel from w_print_basewindow`cb_cancel within w_print_hirestatement
integer taborder = 190
end type

type cb_print from w_print_basewindow`cb_print within w_print_hirestatement
integer taborder = 180
end type

type gb_misc_print from w_print_basewindow`gb_misc_print within w_print_hirestatement
end type

type gb_range from w_print_basewindow`gb_range within w_print_hirestatement
end type

type gb_options from w_print_basewindow`gb_options within w_print_hirestatement
end type

type cb_saveas from w_print_basewindow`cb_saveas within w_print_hirestatement
end type

type st_2 from statictext within w_print_hirestatement
integer x = 635
integer y = 804
integer width = 55
integer height = 64
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "-"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_print_hirestatement
integer x = 215
integer y = 1088
integer width = 695
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Pre&view hire statement"
end type

event clicked;
DATETIME redelivery, delivery

SELECT max(TC_PERIOD_END)  
	INTO :redelivery 
	FROM TCHIRERATES  
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

SELECT DELIVERY_DATE   
	INTO :delivery   
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

IF dw_hirestartdate.GetItemDatetime(1,1) > redelivery OR &
	delivery > dw_hireenddate.GetItemDatetime(1,1) THEN
	Messagebox("End date is invalid!", "The end date should be with-in the following period:~r~r"+String(delivery,"dd-mm-yy hh:mm")+" - "+String(redelivery,"dd-mm-yy hh:mm")+".", StopSign!)
ELSE
	SetRedraw(FALSE)
	SelectPrint("d_hire_statement")
	dw_print.Modify("datawindow.Print.Margin.Left=380")

	print_hirestatement = TRUE
	SetRedraw(TRUE)

	/* Set instance variable to 2 (see declaration) and call function */

	Calculate_statement(2)

	dw_print.GroupCalc()
	dw_print.TriggerEvent(retrieveend!)
	cb_print.Enabled = TRUE
END IF

sle_status.visible=false
COMMIT;
end event

type cb_2 from commandbutton within w_print_hirestatement
integer x = 219
integer y = 1200
integer width = 695
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generate hire statement"
end type

event clicked;
DATETIME redelivery, delivery

SELECT MAX(TC_PERIOD_END)  
	INTO :redelivery 
	FROM TCHIRERATES  
  	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

SELECT DELIVERY_DATE
	INTO :delivery   
	FROM TCHIRES
  	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

IF dw_hirestartdate.GetItemDatetime(1,1) > redelivery OR &
	delivery > dw_hireenddate.GetItemDatetime(1,1) THEN
	Messagebox("End date is invalid!", "The end date should be with-in the following period:~r~r"+String(delivery, "dd-mm-yy hh:mm")+" - "+String(redelivery, "dd-mm-yy hh:mm")+".", StopSign!)
ELSE
	INT rc
	generate_letter = FALSE
	rc = Messagebox("Hire letter", "Would you like to generate hire letter also?", Question!, YesNoCancel!)
	IF NOT rc = 3 THEN
		IF rc = 1 THEN
			generate_letter = TRUE
		ELSE
			generate_letter = FALSE
		END IF

		Calculate_statement(1)
	END IF

	/* Say that generate print is completed */
	IF NOT rc = 3 AND NOT nolettergenerated THEN
		IF rc = 1 THEN
			Messagebox("Hire statement and letter generated", "1. Switch to WordPerfect~r2. Activate the TRAMOS Merge Macro from the Macro menu~r3. Select Hire Statement and Letter~r4. Click OK to generate WordPerfect documents", Information!, OK!)
		ELSE
			Messagebox("Hire statement generated", "1. Switch to WordPerfect~r2. Activate the TRAMOS Merge Macro from the Macro menu~r3. Select Hire Statement and Letter~r4. Click OK to generate WordPerfect document", Information!, OK!)
		END IF
	END IF
END IF
generate_letter = FALSE

end event

type cb_3 from commandbutton within w_print_hirestatement
integer x = 219
integer y = 1312
integer width = 695
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&List off-hires and expenses"
end type

event clicked;
STRING expense_description, ls_help_text
DATETIME ldt_setoffdate, offhire_startdate, offhire_enddate
DECIMAL {2} expense_amount, offhire_bunker, offhire_diesel
INTEGER expense_account, cur_row, li_no
Decimal {4} offhire_hours
BOOLEAN tchirein

SetNull(li_no)

generation_on = FALSE
SetPointer(HourGlass!)
ls_help_text = "Listing off-hires and expenses."
statustext(ls_help_text)

SetRedraw(FALSE)

selectprint("d_expense_offhire_list")
print_hirestatement = FALSE

SELECT TCHIRE_IN 
	INTO :tchirein 
	FROM TCHIRES
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;
COMMIT;

IF tchirein THEN
	dw_print.Modify("headtitle.text = 'T/C Hire-in off-hires and expenses'")
	dw_print.Modify("headtitle2.text = 'Vessel "+String(vessel_nr)+" - C/P date "+String(cp_date, "dd-mm-yy")+"'")
ELSE
	dw_print.Modify("headtitle.text = 'T/C Hire-out off-hires and expenses'")
	dw_print.Modify("headtitle2.text = 'Vessel "+String(vessel_nr)+" - C/P date "+String(cp_date, "dd-mm-yy")+"'")
END IF
SetRedraw(TRUE)
 
/* Get off-hires and to put in datawindow dw_print */
DECLARE cur_offhires CURSOR FOR  
	SELECT START_DATETIME, END_DATETIME, BUNKER_TON * BUNKER_PRICE, 
			DIESEL_TON * DIESEL_PRICE, HOURS, OFFHIRE_SETOFFDATE
 	FROM TCHIREOFFHIRES 
	WHERE VESSEL_NR = :vessel_nr 
	AND TCHIRE_CP_DATE = :cp_date;

OPEN cur_offhires;
FETCH cur_offhires
	INTO 	:offhire_startdate,
			:offhire_enddate,
			:offhire_bunker,
			:offhire_diesel,
			:offhire_hours,
			:ldt_setoffdate ;

dw_print.SetRedraw(FALSE)
DO WHILE SQLCA.SQLCode = 0 
	cur_row = dw_print.InsertRow(0)
	dw_print.SetItem(cur_row, "expense", "Off-hires")
	dw_print.SetItem(cur_row, "tekst1", String(date(offhire_startdate), "dd-mm-yy")+" - "+String(date(offhire_enddate), "dd-mm-yy"))
	dw_print.SetItem(cur_row, "amount1", offhire_bunker)
	dw_print.SetItem(cur_row, "amount2", offhire_diesel)
	dw_print.SetItem(cur_row, "hours", offhire_hours)
	dw_print.SetItem(cur_row, "dato", ldt_setoffdate)
	dw_print.SetItem(cur_row, "account", li_no)
	dw_print.SetItem(cur_row, "amount_text1", "F.O.:")
	dw_print.SetItem(cur_row, "amount_text2", "D.O.:")
	dw_print.SetItem(cur_row, "hour_text", "Hours:")
	FETCH cur_offhires
		INTO 	:offhire_startdate,
				:offhire_enddate,
				:offhire_bunker,
				:offhire_diesel,
				:offhire_hours,
				:ldt_setoffdate;
	help_text = help_text + "."
	statustext(help_text)
LOOP

dw_print.Sort()
dw_print.Modify("hour_text.text = 'Hours'")
dw_print.SetRedraw(TRUE)
CLOSE cur_offhires;

/* Get expenses and to put in datawindow dw_print */
DECLARE cur_expenses CURSOR FOR  
	SELECT EXPENSE_AMOUNT, EXPENSE_DESCRIPTION, EXPENSE_OWNERS_ACC, EXPENSE_SETOFFDATE
		FROM TCHIREEXPENSES
	 	WHERE VESSEL_NR = :vessel_nr 
		AND TCHIRE_CP_DATE = :cp_date;

OPEN cur_expenses;
FETCH cur_expenses
	INTO 	:expense_amount,
			:expense_description,
			:expense_account,
			:ldt_setoffdate;

dw_print.SetRedraw(FALSE)
DO WHILE SQLCA.SQLCode = 0 
	cur_row = dw_print.InsertRow(0)
	dw_print.SetItem(cur_row, "expense", "Expenses")
	dw_print.SetItem(cur_row, "tekst1", expense_description)
	dw_print.SetItem(cur_row, "amount1", expense_amount)
	dw_print.SetItem(cur_row, "dato", ldt_setoffdate)
	dw_print.SetItem(cur_row, "account", expense_account)
	dw_print.SetItem(cur_row, "amount2", li_no)
	dw_print.SetItem(cur_row, "hours", li_no)
	dw_print.SetItem(cur_row, "amount_text1", "Amount:")
	dw_print.SetItem(cur_row, "amount_text2", "")
	dw_print.SetItem(cur_row, "hour_text", "")
	FETCH cur_expenses
		INTO 	:expense_amount,
				:expense_description,
				:expense_account,
				:ldt_setoffdate;

	help_text = help_text + "."
	statustext( help_text )
LOOP
CLOSE cur_expenses;

dw_print.Modify("hour_text.text = 'hours1'")
dw_print.Sort()
dw_print.GroupCalc()
dw_print.TriggerEvent(retrieveend!)
dw_print.SetRedraw(TRUE)

cb_print.Enabled = TRUE
generation_on = FALSE
SetPointer(Arrow!)
Statustext( "Ready" )

sle_status.visible = false


end event

type cbx_final from checkbox within w_print_hirestatement
integer x = 73
integer y = 912
integer width = 608
integer height = 80
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
string text = "&Final hire statement"
end type

event clicked;
DATETIME redelivery, tempdt

IF checked THEN
	SELECT MAX(TC_PERIOD_END)  
		INTO :redelivery 
	 	FROM TCHIRERATES
		WHERE VESSEL_NR = :vessel_nr 
		AND TCHIRE_CP_DATE = :cp_date;
	COMMIT;
	
	dw_hireenddate.SetItem(1,1, redelivery) 
ELSE
	tempdt = Datetime( Today(), time("23:59:59"))
	dw_hireenddate.SetItem(1,1, tempdt)
END IF
end event

type gb_1 from groupbox within w_print_hirestatement
integer x = 18
integer y = 720
integer width = 1097
integer height = 304
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
string text = "&T/C-hire:"
end type

type sle_status from singlelineedit within w_print_hirestatement
boolean visible = false
integer x = 1152
integer y = 1696
integer width = 1701
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean displayonly = true
end type

type st_3 from statictext within w_print_hirestatement
integer x = 55
integer y = 816
integer width = 219
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
boolean enabled = false
string text = "Period:"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_print_hirestatement
integer x = 18
integer y = 1024
integer width = 1097
integer height = 416
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 81324524
end type

type dw_hirestartdate from datawindow within w_print_hirestatement
integer x = 256
integer y = 804
integer width = 379
integer height = 88
integer taborder = 160
boolean bringtotop = true
string dataobject = "d_datetime"
boolean livescroll = true
end type

type dw_hireenddate from datawindow within w_print_hirestatement
integer x = 695
integer y = 804
integer width = 379
integer height = 88
integer taborder = 150
boolean bringtotop = true
string dataobject = "d_datetime"
boolean livescroll = true
end type

