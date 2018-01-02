$PBExportHeader$mt_n_datefunctions.sru
forward
global type mt_n_datefunctions from mt_n_nonvisualobject
end type
end forward

global type mt_n_datefunctions from mt_n_nonvisualobject autoinstantiate
end type

forward prototypes
public function integer of_lastdayofmonth (date ad_source)
public function boolean of_isleapyear (date ad_source)
public function boolean of_isvalid (date ad_source)
public function long of_wholemonthsafter (date ad_start, date ad_end)
public function integer of_monthsafter (date ad_start, date ad_end)
public function boolean of_isvalid (datetime adtm_source)
public function long of_secondsafter (datetime adtm_start, datetime adtm_end)
public function date of_lastdateinmonth (date ad_source)
public function date of_firstdateinmonth (date ad_source)
public function string of_getmonthname (date ad_source, boolean ab_shortmonth)
public function decimal of_getdaysbetween (datetime adt_start, datetime adt_end)
public function datetime of_relativedatetime (datetime adt_start, long al_seconds)
public function datetime of_getearliestdate (datetime adt_source[])
public function datetime of_getlatestdate (datetime adt_source[])
public function date of_relativemonth (date ad_start, long al_months)
public function string of_get_nice_time_format (long al_seconds, boolean ab_longformat)
public subroutine documentation ()
end prototypes

public function integer of_lastdayofmonth (date ad_source);//////////////////////////////////////////////////////////////////////////////
//	Function:  		of_LastDayOfMonth
//
//	Access:  		public
//
//	Arguments: 
//	ad_source 		Date to test.
//
//	Returns:  		Integer
//						The last day # of the month passed.
//						
//	Description:  	Given a date, will determine the last day of the month.
//
//////////////////////////////////////////////////////////////////////////////

integer li_year, li_month, li_day
integer li_daysinmonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

li_year = Year(ad_source)
li_month = Month(ad_source)

If li_month = 2 and of_isleapyear(date(li_year, 01, 01)) Then
	li_day = 29
Else
	li_day = li_daysinmonth[li_month]
end If

Return (li_day)

end function

public function boolean of_isleapyear (date ad_source);int li_year
boolean lb_null
SetNull(lb_null)

//Check parameters
If IsNull(ad_source) Then
	Return lb_null
End If

//Get the year using the string function instead of Year()
li_year = year(ad_source)

If (Mod(li_year,4) = 0 And Mod(li_year,100) <> 0) Or Mod(li_year,400) = 0 Then
	Return True
End If

Return False


end function

public function boolean of_isvalid (date ad_source);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_IsValid
//
//	Access:  		public
//
//	Arguments:
//	ad_source 			Date to test.
//
//	Returns:  		boolean
//						True if argument contains a valid date.
//						If any argument's value is NULL, function returns False.
//						If any argument's value is Invalid, function returns False.
//
//	Description:  	Given a date, will determine if the Date is valid.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.04 Enhanced for more complete checking.
//	6.0.01 Remove invalid date comparison
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

integer 	li_year
integer	li_month
integer	li_day

// Initialize test values.
li_year = Year(ad_source)
li_month = Month(ad_source)
li_day = Day(ad_source)

// Check for nulls.
If IsNull(ad_source) Or IsNull(li_year) or IsNull(li_month) or IsNull(li_day) Then
	Return False
End If

// Check for invalid values.
If	li_year <= 0 or li_month <= 0 or li_day <= 0 Then
	Return False
End If

// Passed all testing.
Return True

end function

public function long of_wholemonthsafter (date ad_start, date ad_end);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_WholeMonthsAfter
//
//	Access:  		public
//
//	Arguments:
//	ad_start			Starting date.
//	ad_end			Ending date.
//
//	Returns:  		Long
//						Number of whole months between the two dates.
//						If the end date is prior the start date, function returns
//						a negative number of months.
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function returns NULL.
//
//	Description:	Given two dates, returns the number of whole months 
// 					between the two.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

date 		ld_temp
integer 	li_month
integer	li_mult

//Check parameters
If IsNull(ad_start) or IsNull(ad_end) or &
	Not of_IsValid(ad_start) or Not of_IsValid(ad_end) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

If ad_start > ad_end Then
	ld_temp = ad_start
	ad_start = ad_end
	ad_end = ld_temp
	li_mult = -1
else
	li_mult = 1
End If

li_month = (year(ad_end) - year(ad_start) ) * 12
li_month = li_month + month(ad_end) - month(ad_start)

If day(ad_start) > day(ad_end) Then 
	li_month --
End If

Return li_month * li_mult
end function

public function integer of_monthsafter (date ad_start, date ad_end);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_MonthsAfter
//
//	Access:  			public
//
//	Arguments:
//	ad_start			Starting date.
//	ad_end			Ending date.
//
//	Returns:  		Long
//						Number of months between the two dates.
//						If the end date is prior the start date, function returns -1
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function returns NULL.
//
//	Description:	Given two dates, returns the number of months between the two.
//////////////////////////////////////////////////////////////////////////////

integer	li_mult

//Check parameters
If IsNull(ad_start) or IsNull(ad_end) or &
	Not of_IsValid(ad_start) or Not of_IsValid(ad_end) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

If ad_start > ad_end Then
	Return -1
End If

Return (year(ad_end) - year(ad_start))*12 + month(ad_end) - month(ad_start) + month(ad_start)
 

end function

public function boolean of_isvalid (datetime adtm_source);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_IsValid
//
//	Access:  		public
//
//	Arguments:
//	adtm_source		DateTime to test.
//
//	Returns:  		boolean
//						True if argument is a valid datetime.
//						If any argument's value is NULL, function returns False.
//						If any argument's value is Invalid, function returns False.
//
//	Description:  	Given a datetime, will determine if the Datetime is valid.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

date 	ldt_value

//Check parameters
If IsNull(adtm_source) Then
	Return False
End If

//There is only need to test the Date portion of the DateTime.
//Can't tell if time is invalid because 12am is 00:00:00:000000
ldt_value = Date(adtm_source)

//Check for invalid date
If Not of_IsValid(ldt_value) Then
	Return False
End If

Return True

end function

public function long of_secondsafter (datetime adtm_start, datetime adtm_end);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_SecondsAfter
//
//	Access:  		public
//
//	Arguments:
//	adtm_start 		Beginning time.
//	adtm_end   		Ending time.
//
//	Returns:  		long
//						Number of whole seconds between two date times.
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function returns NULL.
//
//	Description:  	Given two datetimes, return the number of seconds between 
//						the two.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

long ll_total_seconds, ll_day_adjust
date ld_sdate, ld_edate
time lt_stime, lt_etime

//Check parameters
If IsNull(adtm_start) or IsNull(adtm_end) or &
	Not of_IsValid(adtm_start) or Not of_IsValid(adtm_end) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

ld_sdate = date(adtm_start)
ld_edate = date(adtm_end)

lt_stime = time(adtm_start)
lt_etime = time(adtm_end)

//Note: 86400 is number of seconds in a day.
If ld_sdate = ld_edate then 
	ll_total_seconds = secondsafter(	lt_stime,lt_etime)
Elseif ld_sdate < ld_edate Then
	ll_total_seconds = SecondsAfter(lt_stime,Time('23:59:59'))
	ll_day_adjust = DaysAfter(ld_sdate,ld_edate) -1
	If ll_day_adjust > 0 Then ll_total_seconds = ll_total_seconds + 86400 * ll_day_adjust
	ll_total_seconds = ll_total_seconds + SecondsAfter(Time('00:00:00'),lt_etime) +1
Else //end date < start date
	ll_total_seconds = SecondsAfter(lt_stime,Time('00:00:00'))
	ll_day_adjust = DaysAfter(ld_sdate,ld_edate) +1
	If ll_day_adjust < 0 Then ll_total_seconds = ll_total_seconds + 86400 * ll_day_adjust
	ll_total_seconds = ll_total_seconds + SecondsAfter(Time('23:59:59'),lt_etime) -1
end If

return ll_total_seconds

end function

public function date of_lastdateinmonth (date ad_source);/********************************************************************
   of_lastdayinmonth
<DESC>   
	Description
</DESC>
<RETURN>
	Date:
		<LI> Date requested
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	ad_source: The last day of the month passed.
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/
integer li_year, li_month, li_day
integer li_daysinmonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

li_year = Year(ad_source)
li_month = Month(ad_source)

If li_month = 2 and of_isleapyear(date(li_year, 01, 01)) Then
	li_day = 29
Else
	li_day = li_daysinmonth[li_month]
end If

Return Date (Year(ad_source), Month(ad_source), li_day)
end function

public function date of_firstdateinmonth (date ad_source);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_firstdateinmonth
//
//	Access:  		public
//
//	Arguments:
//	date	ad_source		Date to test.
//
//	Returns:  		date
//						The first date of the month passed.
//						If any argument's value is NULL, function returns NULL.
//						If any argument's value is Invalid, function 
//						returns 1900-01-01.
//
//	Description:  	Given a date, will determine the first day of the month.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//Check parameters
If IsNull(ad_source) Then
	date ldt_null
	SetNull(ldt_null)
	Return ldt_null
End If

//Check for invalid date
If Not of_IsValid(ad_source) Then
	Return ad_source
End If

// Date (Year, Month, Day)
Return Date (Year(ad_source), Month(ad_source), 1)

end function

public function string of_getmonthname (date ad_source, boolean ab_shortmonth);integer li_monthnum
string ls_monthname

li_monthnum = month(ad_source)
choose case li_monthnum
	case 1
		ls_monthname = "January"
	case 2
		ls_monthname = "February"
	case 3
		ls_monthname = "March"
	case 4
		ls_monthname = "April"
	case 5
		ls_monthname = "May"
	case 6
		ls_monthname = "June"
	case 7
		ls_monthname = "July"
	case 8
		ls_monthname = "August"
	case 9
		ls_monthname = "September"
	case 10
		ls_monthname = "October"
	case 11
		ls_monthname = "November"
	case 12
		ls_monthname = "December"
end choose

if ab_shortmonth then
	ls_monthname = left(ls_monthname,3)
end if

return ls_monthname
end function

public function decimal of_getdaysbetween (datetime adt_start, datetime adt_end);/********************************************************************
   of_getdaysbetween()
<DESC>   
	Copied from VAS ancestor, possible usage elsewhere in system
</DESC>
<RETURN>
	Decimal:
		<LI> number of days between the 2 dates in decimal representation
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	adt_start: start datetime
	adt_end: end datetime
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/


decimal ld_minutes

ld_minutes = (daysafter(date(adt_start),date(adt_end)) * 24 * 60)
ld_minutes = ld_minutes -       (hour( time(adt_start)) * 60) - minute(time(adt_start)) - (second(time(adt_start))/60)
ld_minutes = ld_minutes +       (hour( time(adt_end)) * 60) + minute(time(adt_end)) + (second(time(adt_end))/60)

return ld_minutes / 60 / 24
end function

public function datetime of_relativedatetime (datetime adt_start, long al_seconds);/********************************************************************
   of_relativedatetime
   <DESC>	Obtains the datetime that occurs a specified number of 
	         seconds after or before another datetime.	</DESC>
   <RETURN>	datetime:
            occurs n seconds after datetime if n is greater than 0. 
				Returns the datetime that occurs n seconds before 
				datetime if n is less than 0. If any argument's value 
				is null, returns null.	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_start : A value of type datetime
		ll_seconds: An long indicating a number of seconds
   </ARGS>
   <USAGE>	When calculating based on a datetime to another datetime	</USAGE>
   <HISTORY>
   	Date         CR-Ref            Author      Comments
   	11/11/2011   CR2535 & CR2536   ZSW001      First Version
   </HISTORY>
********************************************************************/

datetime	ldt_null

setnull(ldt_null)
if isnull(adt_start) or isnull(al_seconds) then return ldt_null

if al_seconds = 0 then return adt_start

return f_long2datetime(f_datetime2long(adt_start) + al_seconds)

end function

public function datetime of_getearliestdate (datetime adt_source[]);/********************************************************************
   of_getearliestdate
   <DESC>Get the earliest date from the date of the array, null should ignore </DESC>
   <RETURN>	datetime:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_source[] date array
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-03-2012 ?            LHC010        First Version
   </HISTORY>
********************************************************************/
integer li_upperbound,li_count
datetime ldt_return = datetime("2049-01-01")

li_count = upperbound(adt_source)

for li_upperbound = 1 to li_count
	if isnull(adt_source[li_upperbound]) then continue
	if ldt_return > adt_source[li_upperbound] then 
		ldt_return = adt_source[li_upperbound]
	end if
next

if ldt_return = datetime("2049-01-01") then
	setnull(ldt_return)
end if

return ldt_return
end function

public function datetime of_getlatestdate (datetime adt_source[]);/********************************************************************
   of_getlatestdate
   <DESC>Get the latest date from the date of the array, null should ignore </DESC>
   <RETURN>	datetime:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_source[] date array
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-03-2012 ?            LHC010        First Version
   </HISTORY>
********************************************************************/
integer li_upperbound,li_count
datetime ldt_return = datetime("1900-01-01")

li_count = upperbound(adt_source)

for li_upperbound = 1 to li_count
	if isnull(adt_source[li_upperbound]) then continue
	if ldt_return < adt_source[li_upperbound] then 
		ldt_return = adt_source[li_upperbound]
	end if
next

if ldt_return = datetime("1900-01-01") then
	setnull(ldt_return)
end if

return ldt_return
end function

public function date of_relativemonth (date ad_start, long al_months);/********************************************************************
   of_relativemonth
   <DESC>	Obtains the date that occurs a specified number of 
	         months after or before another date.	</DESC>
   <RETURN>	date:
            occurs n months after date if n is greater than 0. 
				Returns the date that occurs n months before 
				date if n is less than 0. If any argument's value 
				is null, returns null.	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ad_start : A value of type date
		al_months: A long indicating a number of months
   </ARGS>
   <USAGE>	When calculating based on a date to another date	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author       Comments
   	19/09/2012   CR2914       ZSW001       First Version
   </HISTORY>
********************************************************************/

date	ld_calc, ld_null
long	ll_year, ll_month, ll_day

setnull(ld_null)
if isnull(ad_start) or isnull(al_months) then return ld_null

ll_year  = year(ad_start)
ll_month = month(ad_start) + al_months
ll_day   = day(ad_start)

do while ll_month > 12
	ll_month -= 12
	ll_year  += 1
loop

do while ll_month <= 0
	ll_month += 12
	ll_year  -= 1
loop

ld_calc = date(ll_year, ll_month, ll_day)
do while (ll_year <> year(ld_calc) or ll_month <> month(ld_calc) or ll_day <> day(ld_calc)) and ll_day > 0
	ll_day -= 1
	ld_calc = date(ll_year, ll_month, ll_day)
loop

return ld_calc

end function

public function string of_get_nice_time_format (long al_seconds, boolean ab_longformat);/********************************************************************
of_get_nice_time_format( /*boolean ab_longformat*/, /*long al_seconds */) 

<DESC>
	formatter to return string
</DESC>
<RETURN> 
	String:
		<LI> Formatted time interval
</RETURN>
<ACCESS>
	Private/Public
</ACCESS>
<ARGS>
	al_seconds		:	unit is seconds, this is the amount we need to format nicely
	ab_longformat 	:	if true format might be: 
								1 hour 20 minutes and 10 seconds
								25 minutes and 1 second
								20 seconds
							if false format will be:
								00:25:01
</ARGS>
<USAGE>
	Simple formatter, should handle the processing.
	Could be expanded to include 
</USAGE>
********************************************************************/
long ll_hours, ll_minutes, ll_seconds
string ls_formatbuilder

ll_hours = truncate( al_seconds /3600 ,0 )
ll_minutes = truncate(mod(al_seconds, 3600) /60 , 0 )
ll_seconds = mod(al_seconds, 60)

if not ab_longformat then
	ls_formatbuilder = string(ll_hours,"00") + ':' + string(ll_minutes,"00") + ':' + string(ll_seconds,"00")
else
	choose case ll_hours
		case 1
			ls_formatbuilder += string(ll_hours) + " hour, "
		case is >1
			ls_formatbuilder += string(ll_hours) + " hours, "
	end choose
	choose case ll_minutes
		case 1
			ls_formatbuilder += string(ll_minutes) + " minute, "
		case is >1
			ls_formatbuilder += string(ll_minutes) + " minutes, "
	end choose
	if	len(ls_formatbuilder)>0 then
		ls_formatbuilder = left(ls_formatbuilder,len(ls_formatbuilder) - 2) + " "
	end if	
	choose case ll_seconds
		case 1
			if ll_minutes>0 or ll_hours>0 then
				ls_formatbuilder += "and 1 second"
			else
				ls_formatbuilder += "1 second"
			end if	
		case is >1
			if ll_minutes>0 or ll_hours>0 then
				ls_formatbuilder += "and " + string(ll_seconds) + " seconds"
			else
				ls_formatbuilder += string(ll_seconds) + " seconds"
			end if
	end choose
end if
return ls_formatbuilder
end function

public subroutine documentation ();/********************************************************************
   mt_n_datefunctions: 
	
	<OBJECT>
	</OBJECT>
   <DESC>
		Date related functions to be used across the system		
	</DESC>
  	<USAGE>
		AutoInstantiated non visual object - sample usage follows:
		
		mt_n_datefunctions lnv_datefunc
		as_waitingtime = lnv_datefunc.of_get_nice_time_format(ll_total_secs,true)	
	</USAGE>
   <ALSO>
				
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/14 	?      	???				First Version
	21/10/16		CR3320	AGL027			Added nice date formatter function
********************************************************************/
end subroutine

on mt_n_datefunctions.create
call super::create
end on

on mt_n_datefunctions.destroy
call super::destroy
end on

