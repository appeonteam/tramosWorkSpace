$PBExportHeader$n_exchangerate.sru
$PBExportComments$General functions/tools for currency related actions.  Used throughout Tramos
forward
global type n_exchangerate from mt_n_nonvisualobject
end type
end forward

global type n_exchangerate from mt_n_nonvisualobject autoinstantiate
end type

type variables

end variables

forward prototypes
public subroutine documentation ()
public function decimal of_getexchangerate (string as_fromcurr, string as_tocurr, date adate_rate)
public function decimal of_gettodaysdkkrate (string as_fromcurr)
public function decimal of_gettodaysusdrate (string as_fromcurr)
public function decimal of_getexchangerate (string as_fromcurr, string as_tocurr, date adate_rate, boolean ab_showmessage)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: n_currencycalc
	
   	<OBJECT> 
		Obtains exchange rate for given currency for either DKK or USD.
	</OBJECT>
   	<DESC>   
		TODO	
	</DESC>
   	<USAGE>
		Contains general functions that are used throughout Tramos
	</USAGE>
   	<ALSO>   
		otherobjs
	</ALSO>
	
    Date   		Ref    			Author 		Comments
  14/02/11 	CR2294      	AGL     		First Version
  17/02/11 	??				AGL	   		Spit from generator object & renamed.  Also overloaded function of_getexrate()
  24/02/11 	CR2294		AGL	   		Moved to common library	
  02/03/11	CR2294		AGL/RMO	Replaced of_getexrate() with new function with ability to make dkk rates too
  19/09/16	CR2212		LHG008	Overloaded function of_getexchangerate() to control error messagebox.
********************************************************************/

end subroutine

public function decimal of_getexchangerate (string as_fromcurr, string as_tocurr, date adate_rate);/********************************************************************
   of_getexchangerate( /*string as_fromcurr*/, /*string as_tocurr*/, /*date adate_rate */)
	
   <DESC>   Main exchange rate function.  Use this if you need a currency rate for a specified date.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  Pass the currency you are coverting from and the currency you are converting to (only applicable DKK & USD) 
	and the date required and the function will return the closest rate possible. 
	</USAGE>
********************************************************************/

boolean lb_showmessage = true

return of_getexchangerate(as_fromcurr, as_tocurr, adate_rate, lb_showmessage)
end function

public function decimal of_gettodaysdkkrate (string as_fromcurr);/********************************************************************
   of_gettodaysdkkrate( /*string as_fromcurr */)
	
   <DESC>   Obtain today's DKK currency exchange for the currency code passed in </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_Arg1: Description
            as_Arg2: Description</ARGS>
   <USAGE>  Simple function returning DKK rate
	</USAGE>
********************************************************************/
return of_getexchangerate(as_fromcurr, "DKK", today())
end function

public function decimal of_gettodaysusdrate (string as_fromcurr);/********************************************************************
   of_gettodaysusdrate( /*string as_fromcurr */)
	
   <DESC>   Obtain today's USD currency exchange for the currency code passed in </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_fromcurr: currency code</ARGS>
   <USAGE>  Simple function returning USD rate
	</USAGE>
*******************************************************************/
return of_getexchangerate(as_fromcurr, "USD", today())
end function

public function decimal of_getexchangerate (string as_fromcurr, string as_tocurr, date adate_rate, boolean ab_showmessage);/********************************************************************
   of_getexchangerate( /*string as_fromcurr*/, /*string as_tocurr*/, /*date adate_rate */ /*boolean ab_showmessage*/)
	
   <DESC>   Main exchange rate function.  Use this if you need a currency rate for a specified date.</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_fromcurr
            as_tocurr
				adate_rate
				ab_showmessage: set false if we do not show error message </ARGS>
   <USAGE>  Pass the currency you are coverting from and the currency you are converting to (only applicable DKK & USD) 
	and the date required and the function will return the closest rate possible. 
	</USAGE>
********************************************************************/

decimal {6} ld_exrate_usd, ld_exrate_dkk, ld_returnval

choose case as_tocurr
	case "DKK", "USD"
		// do nothing
		SELECT TOP 1 EXRATE_USD, EXRATE_DKK 
		into :ld_exrate_usd, :ld_exrate_dkk
		FROM NTC_EXCHANGE_RATE
		WHERE CURR_CODE = :as_fromcurr AND RATE_DATE <= :adate_rate
		ORDER BY RATE_DATE DESC;
		
		if isnull(ld_exrate_usd) or isnull(ld_exrate_dkk) then
			//TODO: this may need to be refined.
		//	ad_exrate_usd = -1
			_addmessage(this.classdefinition, "of_getexrate()","could not locate exchange rate passed", "critical error!", ab_showmessage)
		end if
		
		if as_tocurr = "DKK" then
			if ld_exrate_dkk = 0 then 
				ld_returnval = -1
			else
				ld_returnval = ld_exrate_dkk 
			end if
		else
			if ld_exrate_usd = 0 then 
				ld_returnval = -1
			else
				ld_returnval = ld_exrate_usd
			end if
		end if

	case else
		ld_returnval = -2
end choose

return ld_returnval

end function

on n_exchangerate.create
call super::create
end on

on n_exchangerate.destroy
call super::destroy
end on

