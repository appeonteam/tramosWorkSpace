$PBExportHeader$n_vessel.sru
$PBExportComments$Tool for different vessel requests
forward
global type n_vessel from nonvisualobject
end type
end forward

global type n_vessel from nonvisualobject
end type
global n_vessel n_vessel

forward prototypes
public function boolean of_apmcph_vessel (integer ai_vessel, string as_voyage)
public function boolean of_apmcph_vessel (integer ai_vessel, datetime adt_date)
end prototypes

public function boolean of_apmcph_vessel (integer ai_vessel, string as_voyage);/* This function returns if vessel is an APM Copenhagen Owned vessel when this voyage is performed

	If a vessel is a copenhagen owned vessel is checked by investigating if first port arrival date
	is inside a TC-IN contract or not. TC in contract = not APM CPH, NO TC in contract = APM CPH 
	
	Return TRUE if vessel is APM Copenhagen Owned  */
datetime		ldt_min_arrival
long			ll_counter

/* First find min. port arrival date for voyage */
SELECT min(PORT_ARR_DT)
	INTO :ldt_min_arrival
	FROM POC
	WHERE VESSEL_NR = :ai_vessel
	AND VOYAGE_NR = :as_voyage;
if sqlca.sqlcode <> 0 then
	commit;
	MessageBox("Information", "No port arrival date found for this voyage. Off Service bunker will not be posted to CODA~r~n~r~n" &
					+ "Object: n_bunker_posting_control, Function: of_apmcph_vessel()")
	Return false
end if
commit;

return of_apmcph_vessel( ai_vessel, ldt_min_arrival )

end function

public function boolean of_apmcph_vessel (integer ai_vessel, datetime adt_date);/* This function returns if vessel is an APM Copenhagen Owned vessel when at a given date

	If a vessel is a copenhagen owned vessel is checked by investigating if first port arrival date
	is inside a TC-IN contract or not. TC in contract = not APM CPH, NO TC in contract = APM CPH 
	
	Return TRUE if vessel is APM Copenhagen Owned  */
long			ll_counter

/* Find out if there is a TC IN Contract covering arrival date. If not vessel is an APM CPH owned vessel */
SELECT count(*)  
	INTO :ll_counter
	FROM NTC_TC_CONTRACT,   
		NTC_TC_PERIOD  
	WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID  
	AND NTC_TC_PERIOD.PERIODE_START <= :adt_date
	AND NTC_TC_PERIOD.PERIODE_END > :adt_date
	AND NTC_TC_CONTRACT.VESSEL_NR = :ai_vessel
	AND NTC_TC_CONTRACT.TC_HIRE_IN = 1 ;
commit;

if ll_counter > 0 then 
	return false
else
	return true
end if


end function

on n_vessel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_vessel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

