$PBExportHeader$n_validate_poc.sru
forward
global type n_validate_poc from mt_n_nonvisualobject
end type
end forward

global type n_validate_poc from mt_n_nonvisualobject autoinstantiate
end type

forward prototypes
public function integer of_validate_current_poc (mt_n_datastore ads_store)
public function integer of_check_purpose (s_poc astr_poc)
public function integer of_exists_actpoc (s_poc astr_poc)
public function integer of_exists_actpoc (s_poc astr_poc, ref mt_n_datastore ads_act)
public function integer of_exists_estpoc (s_poc astr_poc)
public function integer of_exists_estpoc (s_poc astr_poc, ref mt_n_datastore ads_est)
public function integer of_exists_proceeding (s_poc astr_poc)
public function integer of_exists_voyage (s_poc astr_poc)
public function integer of_is_allocated (ref s_poc astr_poc)
public function integer of_is_finishedvoyage (s_poc astr_poc)
public function integer of_validate_date (s_poc astr_poc, datetime adt_date)
public function integer of_exists_proceeding (long al_vesselnr, string as_voyagenr, string as_portcode)
public function integer of_check_date_before (s_poc astr_poc, datetime adt_date)
public function integer of_check_date_after (s_poc astr_poc, datetime adt_date)
public subroutine documentation ()
public function integer of_iscancel_proceeding (s_poc astr_poc)
end prototypes

public function integer of_validate_current_poc (mt_n_datastore ads_store);/********************************************************************
   of_validate_current_poc
   <DESC> Validate the current arrival date is before departure date in POC </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ads_store
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-21 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
datetime ldt_port_arr_dt,ldt_port_dept_dt
long ll_count

ll_count = ads_store.rowcount()
if ll_count > 0 then
	ldt_port_arr_dt = ads_store.getitemdatetime(ll_count,'PORT_ARR_DT')
	ldt_port_dept_dt = ads_store.getitemdatetime(ll_count,'PORT_DEPT_DT')
	
	if isnull(ldt_port_dept_dt) then return c#return.Success
	if (ldt_port_arr_dt < ldt_port_dept_dt) then
		return c#return.Success
	else
		return c#return.Failure
	end if
end if

return c#return.Success
end function

public function integer of_check_purpose (s_poc astr_poc);/********************************************************************
   of_check_purpose
   <DESC> Validate the existence of Purpose is in Calculation</DESC>
   <RETURN>	
	 			<LI> c#return.Success  the voyage nr and purpose is existed
            <LI>  c#return.Failure the voyage nr and purpose is not existed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
Long ll_count 

if isnull(astr_poc.cal_calc_id) or +&
isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) then  return c#return.Failure

SELECT count(b.PURPOSE_CODE)
  INTO :ll_count
  FROM CAL_CALC a, CAL_ROUTE b, POC c
 WHERE a.CAL_CALC_ID = b.CAL_CALC_ID
   AND a.CAL_CALC_ID =:astr_poc.cal_calc_id
   AND b.PORT_CODE =:astr_poc.port_code
   AND (b.PURPOSE_CODE =c.PURPOSE_CODE OR b.PURPOSE_CODE ='L/D')
   AND c.VESSEL_NR =:astr_poc.vessel_nr
   AND c.VOYAGE_NR =:astr_poc.voyage_nr;

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if
 
end function

public function integer of_exists_actpoc (s_poc astr_poc);/********************************************************************
   of_exists_actpoc
   <DESC> Validate Vessel, Voyage, PCN and Port existence in Port of Call </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
		 
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count 

if isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) or +&
isnull(astr_poc.pcn) then  return c#return.Failure

SELECT count(PORT_CODE)
  INTO :ll_count
  FROM POC
 WHERE VESSEL_NR =:astr_poc.vessel_nr
   AND VOYAGE_NR =:astr_poc.voyage_nr
   AND PORT_CODE =:astr_poc.port_code
   AND PCN =:astr_poc.pcn;
 
if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_exists_actpoc (s_poc astr_poc, ref mt_n_datastore ads_act);/********************************************************************
   of_exists_actpoc
   <DESC> Validate Vessel, Voyage, PCN and Port existence in Port of Call </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
		ads_act
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count 

if isnull(astr_poc.port_code) or isnull(astr_poc.vessel_nr) or isnull(astr_poc.voyage_nr) or isnull(astr_poc.pcn) then  return c#return.Failure

ll_count = ads_act.retrieve(astr_poc.vessel_nr,astr_poc.voyage_nr,astr_poc.port_code,astr_poc.pcn)
if ll_count = 1 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_exists_estpoc (s_poc astr_poc);/********************************************************************
   of_exists_estpoc
   <DESC>Validate Vessel, Voyage, PCN and Port existence in estimate Port of Call</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count

if isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) or +&
isnull(astr_poc.pcn) then  return c#return.Failure

SELECT count(PORT_CODE)
  INTO :ll_count
  FROM POC_EST
 WHERE VESSEL_NR =:astr_poc.vessel_nr
   AND VOYAGE_NR =:astr_poc.voyage_nr
   AND PORT_CODE =:astr_poc.port_code
   AND PCN =:astr_poc.pcn;

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_exists_estpoc (s_poc astr_poc, ref mt_n_datastore ads_est);/********************************************************************
   of_exists_estpoc
   <DESC>Validate Vessel, Voyage, PCN and Port existence in estimate Port of Call</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
		ads_est
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count

if isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) or +&
isnull(astr_poc.pcn) then  return c#return.Failure

ll_count = ads_est.retrieve(astr_poc.vessel_nr,astr_poc.voyage_nr,astr_poc.port_code,astr_poc.pcn)
if ll_count = 1 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_exists_proceeding (s_poc astr_poc);/********************************************************************
   of_exists_proceeding
   <DESC>Validate Vessel, Voyage, PCN and Port existence in proceeding </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count

if isnull(astr_poc.port_code) or isnull(astr_poc.vessel_nr) or isnull(astr_poc.voyage_nr) or isnull(astr_poc.pcn) then  
	return c#return.Failure
end if

SELECT count(VOYAGE_NR)
  INTO :ll_count
  FROM PROCEED
 WHERE VOYAGE_NR =:astr_poc.voyage_nr
   AND VESSEL_NR =:astr_poc.vessel_nr
   AND PORT_CODE =:astr_poc.port_code
   AND PCN =:astr_poc.pcn;

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_exists_voyage (s_poc astr_poc);/********************************************************************
   of_exists_voyage
   <DESC> Validate vessel and voyage existence in the Voyage </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-07 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
integer li_count 

if isnull(astr_poc.vessel_nr) or isnull(astr_poc.voyage_nr) then  return c#return.Failure

SELECT count(VOYAGE_NR)
  INTO :li_count
  FROM VOYAGES
 WHERE VESSEL_NR =:astr_poc.vessel_nr
   AND VOYAGE_NR =:astr_poc.voyage_nr;
 
if li_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_is_allocated (ref s_poc astr_poc);/********************************************************************
   of_is_allocated
   <DESC> Validate the vessel and voyage is allocated to the calculation </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

if isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) then  return c#return.Failure

SELECT  CAL_CALC_ID
INTO :astr_poc.cal_calc_id
FROM VOYAGES
WHERE VESSEL_NR =:astr_poc.vessel_nr
AND VOYAGE_NR = :astr_poc.voyage_nr using sqlca;

if len(trim(astr_poc.voyage_nr)) = 7 then return c#return.Success

if astr_poc.cal_calc_id > 1 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_is_finishedvoyage (s_poc astr_poc);/********************************************************************
   of_is_finishedvoyage
   <DESC> Validate the voyage and vessel is Finished </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-08 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
integer li_count 

if isnull(astr_poc.vessel_nr) or isnull(astr_poc.voyage_nr) then  return c#return.Failure

SELECT VOYAGE_FINISHED
  INTO :li_count
  FROM VOYAGES
 WHERE VESSEL_NR =:astr_poc.vessel_nr
   AND VOYAGE_NR =:astr_poc.voyage_nr;
 
if li_count = 1 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_validate_date (s_poc astr_poc, datetime adt_date);/********************************************************************
   of_validate_date
   <DESC> Validate input time </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		adt_arrivaldate
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-20 CR20            RJH022        		First Version
   </HISTORY>
********************************************************************/
long ll_count_auto, ll_count
datetime ldt_proc_date

if isnull(adt_date) then  return c#return.Success

if isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) or +&
isnull(astr_poc.pcn) then  return c#return.Failure

// get current port PROC_DATE from PROCEED
SELECT PROC_DATE
  INTO :ldt_proc_date
  FROM PROCEED
 WHERE (PROCEED.VESSEL_NR =:astr_poc.vessel_nr)
   AND (PROCEED.PORT_CODE =:astr_poc.port_code)
   AND (PROCEED.VOYAGE_NR =:astr_poc.voyage_nr)
   AND (PROCEED.PCN =:astr_poc.pcn);


// the input date cannot be before current port's arrival/berthing/departure date or after previous port's arrival/berthing/departure date
SELECT count(PROCEED.VOYAGE_NR) 
INTO :ll_count
FROM PROCEED, (
SELECT VESSEL_NR,VOYAGE_NR,PORT_CODE,PCN,isnull(PORT_DEPT_DT,(CASE WHEN PORT_ARR_DT > isnull(PORT_BERTHING_TIME,'1900-01-01 00:01') THEN PORT_ARR_DT ELSE PORT_BERTHING_TIME END)) AS ETD 
FROM POC 
WHERE VESSEL_NR = :astr_poc.vessel_nr
UNION
SELECT VESSEL_NR,VOYAGE_NR,PORT_CODE,PCN,isnull(PORT_DEPT_DT,(CASE WHEN PORT_ARR_DT > isnull(PORT_BERTHING_TIME,'1900-01-01 00:01') THEN PORT_ARR_DT ELSE PORT_BERTHING_TIME END)) AS ETD
FROM POC_EST 
WHERE VESSEL_NR = :astr_poc.vessel_nr) POC
WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
      PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
      PROCEED.PORT_CODE = POC.PORT_CODE AND
      PROCEED.PCN = POC.PCN AND 
      PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
      POC.ETD > :adt_date AND
      ((SUBSTRING(PROCEED.VOYAGE_NR,1,2) < '90' AND PROCEED.VOYAGE_NR < :astr_poc.voyage_nr)
      OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE < :ldt_proc_date)); 
 
		
if uo_global.ib_pocautoschedule = false then
	//the input date cannot be after current port's arrival date or before previous port's arrival date
	SELECT count(PROCEED.VOYAGE_NR) 
	INTO :ll_count_auto
	FROM PROCEED, (
	SELECT VESSEL_NR,VOYAGE_NR,PORT_CODE,PCN,PORT_ARR_DT
	FROM POC 
	WHERE VESSEL_NR = :astr_poc.vessel_nr
	UNION
	SELECT VESSEL_NR,VOYAGE_NR,PORT_CODE,PCN, PORT_ARR_DT
	FROM POC_EST 
	WHERE VESSEL_NR = :astr_poc.vessel_nr) POC
	WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
		PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
		PROCEED.PORT_CODE = POC.PORT_CODE AND
		PROCEED.PCN = POC.PCN AND 
		PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
		POC.PORT_ARR_DT < :adt_date AND
		((SUBSTRING(PROCEED.VOYAGE_NR,1,2) < '90' AND PROCEED.VOYAGE_NR > :astr_poc.voyage_nr)
		OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE > :ldt_proc_date)) ;
	if ll_count_auto + ll_count > 0   then
		return c#return.Failure
	else
		return c#return.Success
	end if
else
	if ll_count > 0 then
		return c#return.Failure
	else
		return c#return.Success
	end if
end if
 


end function

public function integer of_exists_proceeding (long al_vesselnr, string as_voyagenr, string as_portcode);/********************************************************************
   of_exists_proceeding
   <DESC>Validate Vessel, Voyage, PCN and Port existence in proceeding </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-17 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count

if isnull(as_portcode) or isnull(al_vesselnr) or isnull(as_voyagenr) then return c#return.Failure

SELECT count(VOYAGE_NR)
  INTO :ll_count
  FROM PROCEED
 WHERE VOYAGE_NR =:as_voyagenr
   AND VESSEL_NR =:al_vesselnr
   AND PORT_CODE =:as_portcode;

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_check_date_before (s_poc astr_poc, datetime adt_date);/********************************************************************
   of_check_estpoc_before_actpoc
   <DESC>	Vertical check the POC datetime		</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	astr_poc: POC structure
	adt_date: POC datetime
   </ARGS>
   <USAGE>	There should not be a datetime larger than current Act. POC arrival datetime	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
		2012-02-20 20           RJH022        		First Version
   	31-03-2012 20           JMY014        		Split the original function into vertical before validation and after validation
   </HISTORY>
********************************************************************/
long  ll_count
datetime ldt_proc_date

if isnull(adt_date) then  return c#return.Success

if isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) or +&
isnull(astr_poc.pcn) then  return c#return.Failure

// get current port PROC_DATE from PROCEED
SELECT PROC_DATE
  INTO :ldt_proc_date
  FROM PROCEED
 WHERE (PROCEED.VESSEL_NR =:astr_poc.vessel_nr)
   AND (PROCEED.PORT_CODE =:astr_poc.port_code)
   AND (PROCEED.VOYAGE_NR =:astr_poc.voyage_nr)
   AND (PROCEED.PCN =:astr_poc.pcn);


// the input date cannot be before current port's arrival/berthing/departure date or after previous port's arrival/berthing/departure date
SELECT count(PROCEED.VOYAGE_NR) 
INTO :ll_count
FROM PROCEED, (
SELECT VESSEL_NR,VOYAGE_NR,PORT_CODE,PCN,isnull(PORT_DEPT_DT,(CASE WHEN PORT_ARR_DT > isnull(PORT_BERTHING_TIME,'1900-01-01 00:01') THEN PORT_ARR_DT ELSE PORT_BERTHING_TIME END)) AS ETD 
FROM POC 
WHERE VESSEL_NR = :astr_poc.vessel_nr
UNION
SELECT VESSEL_NR,VOYAGE_NR,PORT_CODE,PCN,isnull(PORT_DEPT_DT,(CASE WHEN PORT_ARR_DT > isnull(PORT_BERTHING_TIME,'1900-01-01 00:01') THEN PORT_ARR_DT ELSE PORT_BERTHING_TIME END)) AS ETD
FROM POC_EST 
WHERE VESSEL_NR = :astr_poc.vessel_nr) POC
WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
      PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
      PROCEED.PORT_CODE = POC.PORT_CODE AND
      PROCEED.PCN = POC.PCN AND 
      PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
      POC.ETD >= :adt_date AND
      ((SUBSTRING(PROCEED.VOYAGE_NR,1,2) < '90' AND PROCEED.VOYAGE_NR < :astr_poc.voyage_nr)
      OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE < :ldt_proc_date)); 

if ll_count > 0   then
	return c#return.Failure
else
	return c#return.Success
end if

return c#return.Success
end function

public function integer of_check_date_after (s_poc astr_poc, datetime adt_date);/********************************************************************
   of_check_actpoc_after_estpoc
   <DESC>	Vertical check the POC datetime	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	astr_poc: POC structure
	adt_date: POC datetime
   </ARGS>
   <USAGE>	There should not be a POC datetime later than current Act. POC arrival datetime	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
		2012-02-20 20           RJH022        		First Version
   	31-03-2012 20           JMY014        		Split the original function into vertical before validation and after validation
		18-03-2012 20				JMY014				Added check the folloing Act. POC datetime check rule.
   </HISTORY>
********************************************************************/
long  ll_count
datetime ldt_proc_date

if isnull(adt_date) then  return c#return.Success

if isnull(astr_poc.port_code) or +&
isnull(astr_poc.vessel_nr) or +&
isnull(astr_poc.voyage_nr) or +&
isnull(astr_poc.pcn) then  return c#return.Failure

// get current port PROC_DATE from PROCEED
SELECT PROC_DATE
  INTO :ldt_proc_date
  FROM PROCEED
 WHERE (PROCEED.VESSEL_NR =:astr_poc.vessel_nr)
   AND (PROCEED.PORT_CODE =:astr_poc.port_code)
   AND (PROCEED.VOYAGE_NR =:astr_poc.voyage_nr)
   AND (PROCEED.PCN =:astr_poc.pcn);

//Check the Act. POC datetime is legal or illegal
SELECT count(PROCEED.VOYAGE_NR) 
INTO :ll_count
FROM PROCEED, POC 
WHERE PROCEED.VESSEL_NR = POC.VESSEL_NR AND
		PROCEED.VOYAGE_NR = POC.VOYAGE_NR AND
		PROCEED.PORT_CODE = POC.PORT_CODE AND
		PROCEED.PCN = POC.PCN AND 
		PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
		POC.PORT_ARR_DT <= :adt_date AND
		((SUBSTRING(PROCEED.VOYAGE_NR,1,2) < '90' AND PROCEED.VOYAGE_NR > :astr_poc.voyage_nr)
		OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE > :ldt_proc_date)) ;

if ll_count > 0 then return c#return.Failure


if uo_global.ib_pocautoschedule = false then
	//the input date cannot be after current port's arrival date or before previous port's arrival date
	SELECT count(PROCEED.VOYAGE_NR) 
	INTO :ll_count
	FROM PROCEED, POC_EST 
	WHERE PROCEED.VESSEL_NR = POC_EST.VESSEL_NR AND
		PROCEED.VOYAGE_NR = POC_EST.VOYAGE_NR AND
		PROCEED.PORT_CODE = POC_EST.PORT_CODE AND
		PROCEED.PCN = POC_EST.PCN AND 
		PROCEED.VESSEL_NR = :astr_poc.vessel_nr AND
		POC_EST.PORT_ARR_DT <= :adt_date AND
		((SUBSTRING(PROCEED.VOYAGE_NR,1,2) < '90' AND PROCEED.VOYAGE_NR > :astr_poc.voyage_nr)
		OR (PROCEED.VOYAGE_NR = :astr_poc.voyage_nr AND PROCEED.PROC_DATE > :ldt_proc_date)) ;
	if ll_count > 0 then return c#return.Failure
end if

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   n_validate_poc
   <OBJECT>		????	</OBJECT>
   <USAGE>		n_approve_vesselmsg	</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	26-07-2013 CR3238       LHC010        First Version
   </HISTORY>
********************************************************************/

end subroutine

public function integer of_iscancel_proceeding (s_poc astr_poc);/********************************************************************
   of_iscancel_proceeding
   <DESC>Validate Port is cancel in proceeding </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
		2013-08-15 CR3238			   LHC010		  First Version
   </HISTORY>
********************************************************************/
long ll_count

if isnull(astr_poc.port_code) or isnull(astr_poc.vessel_nr) or isnull(astr_poc.voyage_nr) or isnull(astr_poc.pcn) then  
	return c#return.Failure
end if

SELECT count(VOYAGE_NR)
  INTO :ll_count
  FROM PROCEED
 WHERE VOYAGE_NR =:astr_poc.voyage_nr
   AND VESSEL_NR =:astr_poc.vessel_nr
   AND PORT_CODE =:astr_poc.port_code
   AND PCN =:astr_poc.pcn
	AND CANCEL = 1;

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

on n_validate_poc.create
call super::create
end on

on n_validate_poc.destroy
call super::destroy
end on

