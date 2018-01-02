$PBExportHeader$n_approve_cargo.sru
forward
global type n_approve_cargo from mt_n_nonvisualobject
end type
end forward

global type n_approve_cargo from mt_n_nonvisualobject
end type
global n_approve_cargo n_approve_cargo

type variables
integer ii_sendmail_status

mt_n_datastore ids_msps_groupbycargo // msps cargo message group by grade,layout,charterer,agent
mt_n_datastore ids_bol, ids_cargo, ids_cd_att //the data from tramos
mt_n_datastore ids_original_bol //backup the data from tramos
n_validate_poc ino_validation 


end variables

forward prototypes
public function integer of_exists_manual_cargo (s_poc astr_poc, string as_purpose)
public function integer of_update_cargo (mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_msps_cargo, ref s_poc astr_poc, string as_purpose)
public function integer of_set_status (ref mt_u_datawindow adw_msps_departure, integer ai_status, string as_reason)
public subroutine documentation ()
private subroutine _replace_cargoid (long al_origicargoid, long al_newcargoid, s_cargo astr_cargo)
private function integer _get_gradegroup (ref s_cargo astr_cargo)
private function integer _replace_bolnr (integer ai_ld)
private function long _get_calcaioid (s_poc astr_poc, long al_cerp_id, string as_purpose)
public function integer of_approve_bol (ref mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_msps_bol, integer ai_ld, s_poc astr_poc)
public function integer of_approve_cargo (mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_msps_cargo, integer ai_loadordisch)
private function integer _set_bol (s_poc astr_poc, s_cargo astr_cargo, long al_row, long ai_ld, long al_cargoid, string as_mspscargoid, integer ai_nor)
private function integer _set_cargo (s_poc astr_poc, s_cargo astr_cargo, long al_row, string as_purpose)
public function integer of_delete_cargo (s_poc astr_poc, string as_purpose)
public function integer of_exists_loadcargo (s_poc astr_poc, ref s_cargo astr_msps_cargo)
public function integer of_jump_new_heating_claim (s_poc astr_poc, long al_cerpid, decimal adc_temp_diff)
public function integer of_exists_dischcargo (s_poc astr_poc)
end prototypes

public function integer of_exists_manual_cargo (s_poc astr_poc, string as_purpose);/********************************************************************
   of_exists_manual_cargo
   <DESC>Check if vessel, voyage and port for the cargo are manually created </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		as_purpose
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-02-28 20            RJH022        First Version
   </HISTORY>
********************************************************************/
long ll_count

SELECT count(CD.CARGO_DETAIL_ID)
INTO :ll_count
FROM CD
WHERE  VESSEL_NR =:astr_poc.vessel_nr
AND VOYAGE_NR =:astr_poc.voyage_nr
AND PORT_CODE =:astr_poc.port_code
AND PCN =:astr_poc.pcn
AND L_D = :as_purpose
AND MSPS_TFV = 0 ;

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_update_cargo (mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_msps_cargo, ref s_poc astr_poc, string as_purpose);/********************************************************************
   of_update_cargo
   <DESC> Update the cargo from msps to tramos	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_departure: departure message
		adw_msps_cargo: msps cargo message
		astr_poc: poc imformation
		as_purpose: L or D 
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-03-20 CR20         RJH022             First Version
   	2013-05-29 CR3238       LHC010             Improve the message for discharge cargo validation
   </HISTORY>
********************************************************************/

string ls_reason, ls_reason_detail, ls_findstr
long ll_rowcount, ll_row, ll_insertrow, ll_find, ll_mspscount, ll_loadcargoid

s_cargo lstr_cargo

ls_reason = adw_msps_departure.getitemstring(1, 'rejection_reason') 

//MSPS cargo group by grade,layout
ll_rowcount = ids_msps_groupbycargo.rowcount() //this datastore maybe grouped by layout/grade

ll_mspscount = adw_msps_cargo.rowcount() //the same message with msps

//Create the CD from msps to tramos
for ll_row = 1 to ll_rowcount
	lstr_cargo.grade = ids_msps_groupbycargo.getitemstring(ll_row, 'cargo_grade_name')
	lstr_cargo.layout =ids_msps_groupbycargo.getitemstring(ll_row, 'tanks')
	lstr_cargo.ship_fig = ids_msps_groupbycargo.getitemnumber(ll_row, 'ship_figures')
	lstr_cargo.dye = ids_msps_groupbycargo.getitemnumber(ll_row, 'dye_added')
	lstr_cargo.mtbe = ids_msps_groupbycargo.getitemnumber(ll_row, 'mtbe_content')
	lstr_cargo.chart_nr = ids_msps_groupbycargo.getitemnumber(ll_row, 'chart_nr')
	lstr_cargo.agent_nr   = ids_msps_groupbycargo.getitemnumber(ll_row, 'agent_nr')
	lstr_cargo.cerp_id  = ids_msps_groupbycargo.getitemnumber(ll_row, 'cal_cerp_id')
	
	//get grade group
	_get_gradegroup(lstr_cargo)

	//Validate the cargo grade
	if (isnull(lstr_cargo.group) or lstr_cargo.group = '') then
		if (isnull(lstr_cargo.grade) or lstr_cargo.grade = '') then
			ls_reason += "~r~nCargo " + string(ll_row) + " is not created because the grade is empty."
		else
			ls_reason += "~r~nCargo " + string(ll_row) + " is not created because grade (" + lstr_cargo.grade + ") doesn't exist in TRAMOS."
		end if
		of_set_status(adw_msps_departure, c#msps.ii_SENDMAIL, ls_reason)		
		continue;
	end if
	
	//Validate layout, shipfig
	ls_reason_detail = ''
	if isnull(lstr_cargo.layout) or lstr_cargo.layout = '' then ls_reason_detail += "layout, "
	if isnull(lstr_cargo.ship_fig) then ls_reason_detail += "shipfig, "
	
	if len(ls_reason_detail) > 0 then
		ls_reason_detail = left(ls_reason_detail, len(ls_reason_detail) - len(", "))
		ls_reason += "~r~nCargo " + lstr_cargo.grade + " is not created because " + ls_reason_detail + " is empty."
		of_set_status(adw_msps_departure, c#msps.ii_SENDMAIL, ls_reason)
		continue;
	end if
	
	setnull(ll_loadcargoid)
	
	//validate if the discharge cargo exists loading cargo
	if as_purpose = "D" then
		ls_findstr = "chart_nr = " + string(lstr_cargo.chart_nr) + " and agent_nr = " + string(lstr_cargo.agent_nr) + &
						 " and cargo_grade_name = '" + lstr_cargo.grade + "' and tanks = '" + lstr_cargo.layout + "' and cal_cerp_id = " + string(lstr_cargo.cerp_id) 
		
		ll_find = adw_msps_cargo.find(ls_findstr, 1, ll_mspscount)
		
		if ll_find > 0 then 
			ll_loadcargoid = adw_msps_cargo.getitemnumber(ll_find, "load_cargo_detail_id")
		end if
		
		if ll_loadcargoid <= 0 or isnull(ll_loadcargoid) then 
			ls_reason += "~r~nCargo (Layout=" + lstr_cargo.layout + " and Grade=" + lstr_cargo.grade + ") is not discharged because the cargo has not been loaded yet."
			of_set_status(adw_msps_departure, c#msps.ii_APPROVED, ls_reason) 
			continue;
		else
			ll_find = ids_cargo.find("cargo_detail_id = " + string(ll_loadcargoid), 1 , ids_cargo.rowcount())
			if ll_find > 0 then lstr_cargo.ship_fig = ids_cargo.getitemnumber(ll_find, "ships_fig")
		end if
	end if
 
	ll_insertrow = ids_cargo.insertrow(0)
	//set cargo value
	if _set_cargo(astr_poc, lstr_cargo, ll_insertrow, as_purpose) = c#return.Failure then continue
	if as_purpose = "D" then ids_cargo.setitem(ll_insertrow, "load_cargo_detail_id", ll_loadcargoid)
next

//update cargo, BOLs, cargo detail attchement
if ids_bol.update() = 1 then
	if ids_cargo.update() = 1 then
		if ids_cd_att.update() = 1 then
			commit using sqlca;
		else
			rollback using sqlca;
			return c#return.Failure
		end if
	else
		rollback using sqlca;
		return c#return.Failure
	end if
else
	rollback using sqlca;
	return c#return.Failure
end if

return c#return.Success
 
end function

public function integer of_set_status (ref mt_u_datawindow adw_msps_departure, integer ai_status, string as_reason);/********************************************************************
   of_set_status
   <DESC></DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
	   adw_msps_departure
		ai_status
		as_reason
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-03-19 20           RJH022             First Version
   	29/07/2013 CR3238       LHG008             Improve rejection reason
   	08/04/2014 CR3599       LHG008             Local time issue
   </HISTORY>
********************************************************************/

//Set sending mail status to message
if as_reason <> "" then ii_sendmail_status = c#msps.ii_SENDMAIL
if left(as_reason, len("~r~n")) = "~r~n" then as_reason = mid(as_reason, len("~r~n") + 1)

adw_msps_departure.setitem(1, "rejection_reason", as_reason)
adw_msps_departure.setitem(1, "approve_by", uo_global.is_userid)
adw_msps_departure.setitem(1, "approve_date", now())
adw_msps_departure.setitem(1, "server_approve_date", f_getdbserverdatetime())

return c#return.Success

end function

public subroutine documentation ();/********************************************************************
   n_approve_cargo
   <OBJECT> 
		of_approve_cargo:
		1.1	Validate
				a.	If exist user created cargoes, a message will pop-up:
					"There are user created cargoes in Tramos. To approve the message, the user created cargoes 
					will be deleted, are you sure?"
					a)	No:  return
					b)	Yes: delete user created cargos and the related bols which is located in this cargo 
				b.	If exist discharge cargo when approving load cargo again, a message will pop-up:
					"You are about to approve a loading message which the discharge cargo has been already created. 
					If this loading message needs to be approved, then existed discharge cargo(es) and BOL(s) will 
					be deleted. Do you want to proceed?"
					a)	Yes: delete Load and discharge cargoes and BOLs, then approve load message
					b)	No: return
		1.2	When approving Load message, delete cargo(CD) and BOL of L and D
				When approving Discharge message, delete cargo and BOL of D( function of_delete_cargo)
		1.3	Update cargo(function of_update_cargo)
				a.	If layout/grade/ship-fig is empty or grade doesn't exist in TRAMOS, the cargo will not be created.
				b.	If approve discharge message, validate that the loaded cargo with the same layout/grade exists. 
					(function of_exists_loadcargo)
				c.	Create cargo from MSPS 
				d.	Update ship-fig with Load ship-fig if approve Discharge message 
				e.	Update table BOL and CD, then commit 
		1.4	Approve BOL (function of_apprvoe_bol)
		
		of_approve_bol:
		2.1	Loop msps BOL
				a.	Validate BOL key values: if terminal or quantity or No issued (only for L) or destination (only for L) 
					is empty, this BOL will not be created.
				b.	Find new cargo id according to BOL primary key (port_code/PCN/chart_nr/grade/layout/agent_nr/l_d)
				c.	Get msps cargo id
				d.	Find original BOL(TFV) according to msps_cargo_id
				e.	If exist BOL(user), copy it from the original BOL datastore; and copy original BOL(TFV), 
					only replace primary key (cargo_detail_id/agent_nr/chart_nr/layout/grade_name/grade_group) 
					(function _replace_cargoid)
				f.	If not exist BOL(user), create BOL(TFV) from msps; if this BOL(TFV) exists in original BOL datastore, 
					copy user manuanlly input values for rob/rate_type/temp_type/gear/safe_memo
		2.2	Organize rejected reason message
		2.3	Replace BOL NR(function _replace_bolnr)
		2.4	Update BOL, then commit	
	</OBJECT>
   <USAGE>	</USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	29/07/2013 CR3238       LHG008        Code refactor
		18/10/2013 CR3340			LHG008		  Create heating claims after message is approved
		08/04/2014 CR3599       LHG008		  Local time issue
   </HISTORY>
********************************************************************/
end subroutine

private subroutine _replace_cargoid (long al_origicargoid, long al_newcargoid, s_cargo astr_cargo);/********************************************************************
   _replace_cargoid
   <DESC>replace old cargo detail ID with new cargo detail ID</DESC>
   <RETURN>	integer:
            <LI> 
            <LI> none </RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_origicargoid
		al_newcargoid
		astr_cargo
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	14-08-13   CR3238          LHC010        First Version
   </HISTORY>
********************************************************************/

long ll_find = 1

ll_find = ids_bol.find("cargo_detail_id = " + string(al_origicargoid), ll_find, ids_bol.rowcount())
if ll_find > 0 then
	ids_bol.setitem(ll_find, "cargo_detail_id", al_newcargoid)
	ids_bol.setitem(ll_find, "agent_nr", astr_cargo.agent_nr)
	ids_bol.setitem(ll_find, "chart_nr", astr_cargo.chart_nr)
	ids_bol.setitem(ll_find, "layout", astr_cargo.layout)
	
	ids_bol.setitem(ll_find, "grade_name", astr_cargo.grade)
	ids_bol.setitem(ll_find, "grade_group", astr_cargo.group)
end if


end subroutine

private function integer _get_gradegroup (ref s_cargo astr_cargo);/********************************************************************
   _get_gradegroup
   <DESC>get grade group</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		astr_cargo
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-04-21 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

SELECT GRADES.GRADE_GROUP
INTO :astr_cargo.group
FROM GRADES, GROUPS
WHERE GRADES.GRADE_GROUP = GROUPS.GRADE_GROUP AND GRADES.GRADE_NAME =:astr_cargo.grade;

if sqlca.sqlcode <> 0 then setnull(astr_cargo.group)

return c#return.Success
end function

private function integer _replace_bolnr (integer ai_ld);/********************************************************************
   _replace_bolnr
   <DESC>The bols number start from 1 if the grade/layout/chart_nr/agent_nr are different, otherwise the bols number is a sequential number. </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-19 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long 		ll_row, ll_count
integer	li_bolnr
s_cargo lstr_cargo, lstr_oldcargo

ids_bol.setsort("grade_name, layout, chart_nr, agent_nr, bol_id ")
ids_bol.sort()
ll_count = ids_bol.rowcount()

for ll_row = 1 to ll_count
	lstr_cargo.grade 		= ids_bol.getitemstring(ll_row, "grade_name")
	lstr_cargo.layout 	= ids_bol.getitemstring(ll_row, "layout")
	lstr_cargo.chart_nr 	= ids_bol.getitemnumber(ll_row, "chart_nr")
	lstr_cargo.agent_nr  = ids_bol.getitemnumber(ll_row, "agent_nr")
		
	//compare layout/grade/chart/agent value
	if lstr_oldcargo.grade <> lstr_cargo.grade or lstr_oldcargo.layout <> lstr_cargo.layout or  &
	   lstr_oldcargo.chart_nr <> lstr_cargo.chart_nr or lstr_oldcargo.agent_nr <> lstr_cargo.agent_nr then
	   li_bolnr = 1
	end if
	ids_bol.setitem(ll_row, "bol_nr", li_bolnr)
	li_bolnr++
	lstr_oldcargo = lstr_cargo	
next

return c#return.Success
end function

private function long _get_calcaioid (s_poc astr_poc, long al_cerp_id, string as_purpose);/********************************************************************
   _get_calcaioid
   <DESC>get cal caio ID</DESC>
   <RETURN>	long: return cal caio ID
   <ACCESS> private </ACCESS>
   <ARGS>
		astr_poc
		al_cerp_id
		as_purpose
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-05-02 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

long ll_cal_calc_id, ll_cal_caio_id

SELECT CAL_CALC_ID
INTO :ll_cal_calc_id
FROM VOYAGES
WHERE VESSEL_NR = :astr_poc.vessel_nr AND	VOYAGE_NR = :astr_poc.voyage_nr;

setnull(ll_cal_caio_id)

//tc out voyage is not calculation ###
if len(trim(astr_poc.voyage_nr)) = 7 or ll_cal_calc_id <= 1 then 
	return ll_cal_caio_id
end if

if as_purpose ="L" then
	SELECT top 1 CAL_CAIO.CAL_CAIO_ID
	INTO :ll_cal_caio_id
	FROM CAL_CARG,CAL_CAIO, CAL_RATY  
	WHERE ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) AND 
			( CAL_RATY.CAL_RATY_ID = CAL_CAIO.CAL_RATY_ID ) AND  
			(CAL_CARG.CAL_CERP_ID = :al_cerp_id) AND   
			CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS > 0   AND 
			CAL_CAIO.PORT_CODE = :astr_poc.port_code AND
			CAL_CARG.CAL_CALC_ID = :ll_cal_calc_id
	ORDER BY CAL_CARG.CAL_CARG_DESCRIPTION ASC; 
else
	SELECT top 1 CAL_CAIO.CAL_CAIO_ID
	INTO :ll_cal_caio_id
	FROM CAL_CARG,CAL_CAIO, CAL_RATY  
	WHERE ( CAL_CARG.CAL_CARG_ID = CAL_CAIO.CAL_CARG_ID ) AND 
			( CAL_RATY.CAL_RATY_ID = CAL_CAIO.CAL_RATY_ID ) AND  
			(CAL_CARG.CAL_CERP_ID = :al_cerp_id) AND   
			CAL_CAIO.CAL_CAIO_NUMBER_OF_UNITS < 0   AND 
			CAL_CAIO.PORT_CODE = :astr_poc.port_code AND
			CAL_CARG.CAL_CALC_ID = :ll_cal_calc_id
	ORDER BY CAL_CARG.CAL_CARG_DESCRIPTION ASC; 
end if

return ll_cal_caio_id


end function

public function integer of_approve_bol (ref mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_msps_bol, integer ai_ld, s_poc astr_poc);/********************************************************************
   of_approve_bol
   <DESC> Approve Bill of Lading from msps to tramos </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_msps_departure
		adw_msps_bol
		ai_ld
		astr_poc
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref        Author             Comments
   	14/08/2013 CR3238        LHC010             First Version
		18/10/2013 CR3340			 LHG008				  Create heating claims after message is approved
   </HISTORY>
********************************************************************/

string ls_mspscargoid, ls_validate, ls_expression, ls_findstr, ls_findbolstr
string ls_reason, ls_reasondetail, ls_purpose, ls_manualbols
long ll_mspsbolcount, ll_row, ll_insertrow, ll_cargocount
long ll_finduserbol
long ll_origicargoid, ll_newcargoid, ll_findcargo, ll_findorigibol, ll_rob
integer li_nor, li_pcnr, li_ratetype, li_temptype, li_gear
dec{2} ldc_tempdiff
boolean lb_existuserbol
datetime ldt_safememo

s_cargo lstr_cargo

//Get berth, departure and arrival date from POC
SELECT PORT_BERTHING_TIME,   PORT_DEPT_DT,   PORT_ARR_DT
INTO :lstr_cargo.berthing, :lstr_cargo.departure, :lstr_cargo.arrival
FROM POC
WHERE VESSEL_NR=:astr_poc.vessel_nr AND VOYAGE_NR=:astr_poc.voyage_nr AND
	   PORT_CODE=:astr_poc.port_code AND PCN =:astr_poc.pcn;

//Get heating param from PROFIT center	
if astr_poc.vessel_nr > 0 then
	SELECT PROFIT_C.BOL_NOR_DATE_FROM_POC, NOTIFY_ON_TEMP_DIFF, PROFIT_C.PC_NR 
	INTO :li_nor, :ldc_tempdiff, :li_pcnr
	FROM VESSELS, PROFIT_C
	WHERE VESSELS.PC_NR = PROFIT_C.PC_NR AND VESSELS.VESSEL_NR = :astr_poc.vessel_nr;
else
	li_pcnr = uo_global.get_profitcenter_no( ) //Use default users pc
end if

if ai_ld = 1 then
	ls_purpose ="L"
else
	ls_purpose ="D"
end if

ll_mspsbolcount = adw_msps_bol.rowcount()
ll_cargocount   = ids_cargo.rowcount()

ids_bol.reset()

adw_msps_bol.setsort("numeric_layout, cargo_grade_name, ship_figures")
adw_msps_bol.sort()

//Approve BOL
for ll_row = 1 to ll_mspsbolcount
	lstr_cargo.grade = adw_msps_bol.getitemstring(ll_row, 'cargo_grade_name')
	if lstr_cargo.grade = '' then setnull(lstr_cargo.grade)
	
	_get_gradegroup(lstr_cargo)//Get grade group
	
	lstr_cargo.layout = adw_msps_bol.getitemstring(ll_row, 'tanks')
	if lstr_cargo.layout = '' then setnull(lstr_cargo.layout)
	
	//If the cargo grade or layout is null, continue
	if isnull(lstr_cargo.group) or isnull(lstr_cargo.grade) or isnull(lstr_cargo.layout) then continue
	
	//Validate if the discharge cargo exists loading cargo
	if ls_purpose = "D" then
		if of_exists_loadcargo(astr_poc, lstr_cargo) = c#return.Failure then continue
	end if
	
	lstr_cargo.terminal = adw_msps_bol.getitemstring(ll_row, 'terminal')
	if lstr_cargo.terminal = '' then setnull(lstr_cargo.terminal)
	
	lstr_cargo.bol_qty = adw_msps_bol.getitemdecimal(ll_row, 'bl_figures')
	lstr_cargo.destination = adw_msps_bol.getitemstring(ll_row, 'destination_name')
	if lstr_cargo.destination = '' then setnull(lstr_cargo.destination)
	lstr_cargo.issued = adw_msps_bol.getitemnumber(ll_row, 'no_of_originals_onboard')
	
	//If any of terminal/quantity/no issued/destination is empty, then continue
	ls_reasondetail = ''
	if isnull(lstr_cargo.terminal) then ls_reasondetail += "terminal, "
	if isnull(lstr_cargo.bol_qty) then ls_reasondetail += "quantity, "
	
	if ls_purpose = "L" then
		if isnull(lstr_cargo.issued) then ls_reasondetail += "No issued, "
		if isnull(lstr_cargo.destination) then ls_reasondetail += "destination, "
	end if
	
	if len(ls_reasondetail) > 0 then
		ls_reasondetail = left(ls_reasondetail, len(ls_reasondetail) - len(", "))
		ls_validate += "~r~nBOL " + string(ll_row) + " for Cargo " + lstr_cargo.grade + " is not created because the " + ls_reasondetail + " is missing in the message."
		continue
	end if

	lstr_cargo.chart_nr = adw_msps_bol.getitemnumber(ll_row, 'chart_nr')
	lstr_cargo.agent_nr = adw_msps_bol.getitemnumber(ll_row, 'agent_nr')
	lstr_cargo.cerp_id  = adw_msps_bol.getitemnumber(ll_row, 'cal_cerp_id')
	
	//Find new cargo ID in the new Cargo according to port_code,PCN,chart_nr,grade,layout,agent_nr, l_d
	ls_expression = " port_code = '" + astr_poc.port_code + "' and pcn = " + string(astr_poc.pcn) + &
					 	 " and layout = '" + lstr_cargo.layout + "' and grade_name = '" + lstr_cargo.grade + "'" + &
						 " and chart_nr = " + string(lstr_cargo.chart_nr) 
						 
	ls_findstr = ls_expression + " and agent_nr = " + string(lstr_cargo.agent_nr) + " and l_d = '" + ls_purpose + "'"
	ll_findcargo = ids_cargo.find(ls_findstr, 1, ll_cargocount)

	if ll_findcargo > 0 then
		ll_newcargoid = ids_cargo.getitemnumber(ll_findcargo, 'cargo_detail_id')
	else
		continue
	end if


	//Get msps cargo id
	ls_mspscargoid = adw_msps_bol.getitemstring(ll_row, 'cargo_id')	
	
	//Find original BOL according to msps_cargo_id  
	ll_findorigibol = ids_original_bol.find("msps_cargo_id = '" + ls_mspscargoid + "'", 1, ids_original_bol.rowcount())

	lb_existuserbol = false
	
	if ll_findorigibol > 0 then
		ll_origicargoid = ids_original_bol.getitemnumber(ll_findorigibol, "cargo_detail_id")

		//Copy BOL(user) from the original BOL
		do
			ls_findbolstr = "cargo_detail_id = " + string(ll_origicargoid) + &
						  " and msps_tfv = 1 and isnull(msps_cargo_id) and l_d = " + string(ai_ld)
			
			//Find BOL(user) according to original cargo id which BOL(user) is under
			ll_finduserbol = ids_original_bol.find(ls_findbolstr, 1, ids_original_bol.rowcount())
		 
			if ll_finduserbol > 0 then
				lb_existuserbol = true
				ids_original_bol.rowscopy(ll_finduserbol, ll_finduserbol, primary!, ids_bol, 1, primary!)
				
				_replace_cargoid(ll_origicargoid, ll_newcargoid, lstr_cargo)
				ids_original_bol.deleterow(ll_finduserbol)
			end if
		loop while ll_finduserbol > 0
	else
		ll_origicargoid = 0
	end if			
	
	//If BOL(user) exists, copy original BOL(tfv)
	if lb_existuserbol then 
		//Restore BOL(TFV) when BOL(user) existed in Tramos.
		ll_findorigibol = ids_original_bol.find("msps_cargo_id ='" + ls_mspscargoid  + "'", 1, ids_original_bol.rowcount())
		if ll_findorigibol > 0 then			
			ids_bol.Object.Data[ids_bol.rowcount() + 1] = ids_original_bol.Object.Data[ll_findorigibol]
	
			ll_origicargoid = ids_original_bol.getitemnumber(ll_findorigibol, "cargo_detail_id")
			
			if pos(ls_manualbols, lstr_cargo.grade) <= 0 and ls_manualbols <> ", " then ls_manualbols += ", " + lstr_cargo.grade
			
			_replace_cargoid(ll_origicargoid, ll_newcargoid, lstr_cargo)
		end if
	//If BOL(user) doesn't exist, create BOL(tfv) from msps	
	else 
		//Insert BOL from MSPS
		ll_insertrow = ids_bol.insertrow(0)
	
		lstr_cargo.temp = adw_msps_bol.getitemdecimal(ll_row, 'temperature')
		lstr_cargo.rate = adw_msps_bol.getitemdecimal(ll_row, 'rate')
		lstr_cargo.density = adw_msps_bol.getitemdecimal(ll_row, 'density_at_15_degrees')
		lstr_cargo.bl_date = adw_msps_bol.getitemdatetime(ll_row, 'bl_date_of_issue') 	
		
		//Set bol values
		_set_bol(astr_poc, lstr_cargo, ll_insertrow, ai_ld, ll_newcargoid, ls_mspscargoid, li_nor)
		
		//If Existing original BOL, copy user manuanlly input values for rob/rate_type/temp_type/gear/safe_memo
		if ll_findorigibol > 0 then
			ll_rob 		= ids_original_bol.getitemnumber(ll_findorigibol, "rob")
			li_ratetype = ids_original_bol.getitemnumber(ll_findorigibol, "rate_type")
			li_temptype = ids_original_bol.getitemnumber(ll_findorigibol, "temp_type")
			li_gear		= ids_original_bol.getitemnumber(ll_findorigibol, "gear")
			ldt_safememo = ids_original_bol.getitemdatetime(ll_findorigibol, "safe_memo")
			
			ids_original_bol.deleterow(ll_findorigibol)
			
			ids_bol.setitem(ll_insertrow, "rob", ll_rob)
			ids_bol.setitem(ll_insertrow, "rate_type", li_ratetype)
			ids_bol.setitem(ll_insertrow, "temp_type", li_temptype)
			ids_bol.setitem(ll_insertrow, "gear", li_gear)
			ids_bol.setitem(ll_insertrow, "safe_memo", ldt_safememo)
		end if
	end if
next

adw_msps_bol.setsort("")
adw_msps_bol.sort()

//Replace BOL number
_replace_bolnr(ai_ld)

//Organize approve notes
if len(ls_manualbols + ls_validate) > 0 then
	ls_reason = adw_msps_departure.getitemstring(1, 'rejection_reason')

	if len(ls_reason) > 0 then ls_reason += "~r~n"

	if len(ls_manualbols) > 0 then
		ls_manualbols = mid(ls_manualbols, 3, len(ls_manualbols) - 2)
		ls_reason += "Tramos has user created BOL(s) for Cargo (" + ls_manualbols + "). The system cannot update the BOL data automatically, please manually update BOL fields." 
	end if
	
	if len(ls_validate) > 0 then 
		if len(ls_manualbols) > 0 then 
			ls_reason += "~r~n" + ls_validate
		else
			ls_reason += ls_validate
		end if
	end if
	of_set_status(adw_msps_departure, c#msps.ii_SENDMAIL, ls_reason)
end if

//Update bols
if ids_bol.update() = 1 and adw_msps_departure.update() = 1 then
	commit using sqlca;
else
	rollback using sqlca;
	return c#return.Failure
end if
 
if ls_purpose = "D" then post of_jump_new_heating_claim(astr_poc, lstr_cargo.cerp_id, ldc_tempdiff)

return c#return.Success

end function

public function integer of_approve_cargo (mt_u_datawindow adw_msps_departure, mt_u_datawindow adw_msps_cargo, integer ai_loadordisch);/********************************************************************
   of_approve_cargo
   <DESC> approve for cargos </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS>public</ACCESS>
   <ARGS>
		adw_msps_departure: departure(load or discharge) message
		adw_msps_cargo: msps cargo message
		ai_loadordisch: 1, load; 0, discharge
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
		16/08/2013 CR3238       	LHG008             First Version
   </HISTORY>
********************************************************************/ 

long ll_reportid, ll_revision, ll_imo, li_return, ll_row
string ls_group, ls_loadordisch

s_poc lstr_poc
s_cargo lstr_cargo

//get POC primary key
lstr_poc.vessel_nr = adw_msps_departure.getitemnumber(1, "vessel_nr")
lstr_poc.voyage_nr = adw_msps_departure.getitemstring(1, "voyage_no")
lstr_poc.port_code = adw_msps_departure.getitemstring(1, "port_code")
lstr_poc.pcn = adw_msps_departure.getitemnumber(1, "pcn")

//get message primary key
ll_reportid = adw_msps_departure.getitemnumber(1, "report_id")
ll_imo = adw_msps_departure.getitemnumber(1, "vessel_imo")
ll_revision = adw_msps_departure.getitemnumber(1, "revision_no")

if ai_loadordisch = c#msps.ii_LOAD then //load
	ls_loadordisch = 'L'
else //discharge
	ls_loadordisch = 'D'
end if

if ids_msps_groupbycargo.retrieve(ll_reportid, ll_revision, ll_imo, ai_loadordisch) = 0 then return c#return.NoAction	

// A manually created cargo exists in tramos  
if of_exists_manual_cargo(lstr_poc, ls_loadordisch) = c#return.Success then
	li_return = messagebox('Cargo was created', "There are user created cargoes in Tramos. To approve the message, " + &
		 "the user created cargoes will be deleted, are you sure?", Question!, YesNo!, 2)                     
	if li_return = 2 then // select "no"
		return c#return.Success
	end if
end if

//Retrieve cargo, BOL from tramos
ids_bol.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr)
ids_original_bol.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr)
ids_cargo.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr)

//Exists discharge cargo
if ls_loadordisch = "L" then
	if of_exists_dischcargo(lstr_poc) = c#return.Success then
		li_return = messagebox("Exists Discharge Cargo", "You are about to approve a loading message which the discharge " + &
									  "cargo has been already created. If this loading message needs to be approved, " + &
									  "then existed discharge cargo(es) and BOL(s) will be deleted. Do you want to proceed? ", Question!, YesNo!, 2)
		if li_return = 2 then 
			return c#return.NoAction
		end if
	end if
end if

//Delete the cargo and BOLs						 
if of_delete_cargo(lstr_poc, ls_loadordisch) = c#return.Failure then return c#return.Failure

//update cargos
if of_update_cargo(adw_msps_departure, adw_msps_cargo, lstr_poc, ls_loadordisch) = c#return.Failure then
	return c#return.Failure
else
//update BOLS
	if of_approve_bol(adw_msps_departure, adw_msps_cargo, ai_loadordisch, lstr_poc) = c#return.Failure then return c#return.Failure
end if
 
return c#return.Success 
end function

private function integer _set_bol (s_poc astr_poc, s_cargo astr_cargo, long al_row, long ai_ld, long al_cargoid, string as_mspscargoid, integer ai_nor);/********************************************************************
   of_setbol
   <DESC> Set msps bol value into tramos</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		astr_poc
		astr_cargo
		al_row
		ai_ld
		al_cargoid
		as_mspscargoid
		ai_nor
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-04-10 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
ids_bol.setitem(al_row, "vessel_nr", astr_poc.vessel_nr)
ids_bol.setitem(al_row, "voyage_nr", astr_poc.voyage_nr)
ids_bol.setitem(al_row, "port_code", astr_poc.port_code)
ids_bol.setitem(al_row, "pcn", astr_poc.pcn)
ids_bol.setitem(al_row, "agent_nr", astr_cargo.agent_nr)
ids_bol.setitem(al_row, "chart_nr", astr_cargo.chart_nr)
ids_bol.setitem(al_row, "layout", astr_cargo.layout)

ids_bol.setitem(al_row, "grade_name", astr_cargo.grade)
ids_bol.setitem(al_row, "grade_group", astr_cargo.group)

ids_bol.setitem(al_row, "rate_type", 0)
ids_bol.setitem(al_row, "gear", 0)
ids_bol.setitem(al_row, "temp_type", 0)

ids_bol.setitem(al_row, "layout_bl", astr_cargo.layout)
ids_bol.setitem(al_row, "terminal", astr_cargo.terminal)
ids_bol.setitem(al_row, "cal_cerp_id", astr_cargo.cerp_id)

ids_bol.setitem(al_row, "all_fast_dt", astr_cargo.berthing)
ids_bol.setitem(al_row, "departure_dt", astr_cargo.departure)
ids_bol.setitem(al_row, "msps_cargo_id", as_mspscargoid) 

ids_bol.setitem(al_row, "bol_quantity", astr_cargo.bol_qty)
ids_bol.setitem(al_row, "cargo_detail_id", al_cargoid)

if ai_nor = 1 then
	ids_bol.setitem(al_row, "nor_dt", astr_cargo.arrival)
end if

if ai_ld = 1 then
	ids_bol.setitem(al_row, "nr_issued", astr_cargo.issued) 
	ids_bol.setitem(al_row, "destination", astr_cargo.destination) 
end if
ids_bol.setitem(al_row, "density", astr_cargo.density) 
ids_bol.setitem(al_row, "rate", astr_cargo.rate)

ids_bol.setitem(al_row, 'l_d', ai_ld)
ids_bol.setitem(al_row, 'cargo_temp', astr_cargo.temp)
if ai_ld = 1 then ids_bol.setitem(al_row, 'recieved', astr_cargo.bl_date)

return c#return.Success
end function

private function integer _set_cargo (s_poc astr_poc, s_cargo astr_cargo, long al_row, string as_purpose);/********************************************************************
   of_setcargo
   <DESC> Set cargo value</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		astr_poc
		astr_cargo
		al_row
		as_purpose
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-03-06 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/

ids_cargo.setitem(al_row, "vessel_nr", astr_poc.vessel_nr)
ids_cargo.setitem(al_row, "voyage_nr", astr_poc.voyage_nr)
ids_cargo.setitem(al_row, "port_code", astr_poc.port_code)
ids_cargo.setitem(al_row, "pcn", astr_poc.pcn)
ids_cargo.setitem(al_row, "agent_nr", astr_cargo.agent_nr)
ids_cargo.setitem(al_row, "chart_nr", astr_cargo.chart_nr)
ids_cargo.setitem(al_row, "layout", astr_cargo.layout)
ids_cargo.setitem(al_row, "grade_name", astr_cargo.grade)
ids_cargo.setitem(al_row, "ships_fig", astr_cargo.ship_fig)
ids_cargo.setitem(al_row, "surveyor_fig", astr_cargo.surv_fig)
ids_cargo.setitem(al_row, "grade_group", astr_cargo.group)
ids_cargo.setitem(al_row, "cal_cerp_id", astr_cargo.cerp_id)

if ids_cargo.setitem(al_row, 'cal_caio_id', _get_calcaioid(astr_poc, astr_cargo.cerp_id, as_purpose)) = -1 then return c#return.Failure
ids_cargo.setitem(al_row, "msps_tfv", 1)

if not isnull(astr_cargo.dye) then ids_cargo.setitem(al_row, 'cd_dye_marked', astr_cargo.dye)

ids_cargo.setitem(al_row, 'l_d', as_purpose)
 
if astr_cargo.mtbe >=0 then
	ids_cargo.setitem(al_row, 'cd_mtbe_etbe', astr_cargo.mtbe)
	ids_cargo.setitem(al_row, 'cd_mtbe_etbe_status', 1)
else
	ids_cargo.setitem(al_row, 'cd_mtbe_etbe_status', 0)
end if

return c#return.Success
end function

public function integer of_delete_cargo (s_poc astr_poc, string as_purpose);/********************************************************************
   of_delete_cargo 
   <DESC> Delete existing cargos and bols in tramos </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc:	poc imformation
		as_purpose:	L, load; D, discharge
   </ARGS>
   <USAGE> Called from of_approve_cargo()	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	16/08/2013 CR3238       LHG008        First version
   </HISTORY>
********************************************************************/

string	ls_cargoidlist, ls_expression
long		ll_row, ll_rowcount, ll_find, ll_upperbound, ll_cargoid[]

constant string ls_DELIMITER = ','

//Filter out the cargo with same port_code, pcn and purpose
ls_expression = "port_code = '" + astr_poc.port_code + "'" + " and pcn = " + string(astr_poc.pcn) + " and l_d = '" + as_purpose + "'"

ids_cargo.setfilter(ls_expression)
ids_cargo.filter()

ll_rowcount = ids_cargo.rowcount()
for ll_row = 1 to ll_rowcount
	//Get cargo_detail_id for Deleting BOL and CD attachment
	ll_upperbound ++
	ll_cargoid[ll_upperbound]= ids_cargo.getitemnumber(ll_row, "cargo_detail_id")
	ls_cargoidlist += ls_DELIMITER + string(ll_cargoid[ll_upperbound])
	
	//Delete discharging CD according to load_cargo_detail_id
	if as_purpose = "L" then
		
		ls_expression = "load_cargo_detail_id = " + string(ll_cargoid[ll_upperbound])
		
		do
			ll_find = ids_cargo.find(ls_expression, 1, ids_cargo.filteredcount(), filter!)
			if ll_find > 0 then
				ll_upperbound ++
				ll_cargoid[ll_upperbound] = ids_cargo.getitemnumber(ll_find, "cargo_detail_id", filter!, false)
				ls_cargoidlist += ls_DELIMITER + string(ll_cargoid[ll_upperbound])
				ids_cargo.rowsmove(ll_find, ll_find, filter!, ids_cargo, 1, delete!)
			end if
		loop while ll_find > 0
		
	end if
next

if ll_upperbound > 0 then
	//Delete BOLs
	ids_bol.setfilter("cargo_detail_id in (" + mid(ls_cargoidlist, len(ls_DELIMITER) + 1) + ")")
	ids_bol.filter()
	ids_bol.rowsmove(1, ids_bol.rowcount(), primary!, ids_bol, 1, delete!)
	
	//Delete CD attachment
	if ids_cd_att.retrieve(ll_cargoid) > 0 then ids_cd_att.rowsmove(1, ids_cd_att.rowcount(), primary!, ids_cd_att, 1, delete!)
end if

//Delete the cargo with same port_code, pcn and purpose
ids_cargo.rowsmove(1, ll_rowcount, primary!, ids_cargo, 1, delete!) 

//Reset filter
ids_cargo.setfilter("")
ids_cargo.filter()

return c#return.Success
end function

public function integer of_exists_loadcargo (s_poc astr_poc, ref s_cargo astr_msps_cargo); /********************************************************************
   of_exists_loadcargo
   <DESC> Check the existence of the loading cargo </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		astr_msps_cargo
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-02-28 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
long	ll_count

SELECT count(*)
INTO :ll_count
FROM CD 
WHERE CD.VESSEL_NR = :astr_poc.vessel_nr
AND CD.VOYAGE_NR = :astr_poc.voyage_nr
AND CD.LAYOUT = :astr_msps_cargo.layout
AND CD.GRADE_NAME = :astr_msps_cargo.grade
AND CD.L_D = "L";

if ll_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

public function integer of_jump_new_heating_claim (s_poc astr_poc, long al_cerpid, decimal adc_temp_diff);/********************************************************************
   of_jump_new_heating_claim
   <DESC> Create Heating Claims </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		astr_msps_cargo
		adc_temp_diff
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	2012-03-02 ?            RJH022        First Version
		2013-08-27 CR3238			LHC010		  Code review 
   </HISTORY>
********************************************************************/
double 	ld_min_loadtemp, ld_max_dischtemp
long 		ll_counter
boolean	lb_cargotemp

u_jump_claims luo_jump_claims

if ino_validation.of_is_allocated(astr_poc) = c#return.Failure then return c#return.Failure

//Get heating param from PROFIT center
SELECT VALIDATE_CARGO_TEMP 
INTO :lb_cargotemp 
FROM PROFIT_C, VESSELS
WHERE PROFIT_C.PC_NR = VESSELS.PC_NR AND VESSELS.VESSEL_NR = :astr_poc.vessel_nr;

if not lb_cargotemp then return c#return.NoAction
 
SELECT count(*)
INTO :ll_counter
FROM CLAIMS
WHERE VESSEL_NR = :astr_poc.vessel_nr
AND VOYAGE_NR = :astr_poc.voyage_nr
AND CHART_NR = :astr_poc.chart_nr
AND CLAIM_TYPE = "HEA";
 
if ll_counter > 0 then return c#return.Failure // Heating Claim already created

SELECT D.MAX_DISCH_TEMP, L.MIN_LOAD_TEMP
INTO :ld_max_dischtemp, :ld_min_loadtemp
FROM (SELECT MAX(CARGO_TEMP) AS MAX_DISCH_TEMP, BOL.GRADE_NAME, CAL_CERP_ID
        FROM BOL,GRADES,GROUPS
        WHERE VESSEL_NR = :astr_poc.vessel_nr AND BOL.GRADE_NAME = GRADES.GRADE_NAME AND BOL.GRADE_GROUP = GROUPS.GRADE_GROUP 
		  AND VOYAGE_NR = :astr_poc.voyage_nr   AND CAL_CERP_ID = :al_cerpid AND DIRTY_PRODUCT = 1 AND L_D = 0
        GROUP BY BOL.GRADE_NAME, CAL_CERP_ID) D,
     (SELECT MIN(CARGO_TEMP) AS MIN_LOAD_TEMP, BOL.GRADE_NAME, CAL_CERP_ID
        FROM BOL,GRADES,GROUPS
        WHERE VESSEL_NR = :astr_poc.vessel_nr AND BOL.GRADE_NAME = GRADES.GRADE_NAME AND BOL.GRADE_GROUP = GROUPS.GRADE_GROUP 
		  AND VOYAGE_NR = :astr_poc.voyage_nr   AND CAL_CERP_ID = :al_cerpid AND DIRTY_PRODUCT = 1 AND L_D = 1
        GROUP BY BOL.GRADE_NAME, CAL_CERP_ID) L
WHERE L.GRADE_NAME = D.GRADE_NAME AND L.CAL_CERP_ID = D.CAL_CERP_ID;

if IsNull(ld_min_loadtemp) or Isnull(ld_max_dischtemp) then
	return c#return.Failure//Do nothing !
else
	if ld_max_dischtemp - ld_min_loadtemp >= adc_temp_diff then
		if messagebox("Information", "The difference between the Load and Discharge Temperature is more~r~n" &
       		+"than specified allowance.~r~n~r~nLoad Temp.: ~t"+string(ld_min_loadtemp) &
      	 	+"~r~nDisch. Temp.: ~t"+string(ld_max_dischtemp) &
      	 	+"~r~nAllowance: ~t"+string(adc_temp_diff ) &
      	 	+"~r~n~r~nWould you like to jump to the Claims Module and create a Heating Claim now?",Question!,YesNo!,1) = 1 then
			luo_jump_claims = CREATE u_jump_claims
			luo_jump_claims.of_createHeatingClaim(astr_poc.vessel_nr, astr_poc.voyage_nr, astr_poc.chart_nr) 
			DESTROY luo_jump_claims
		end if
	end if
end if
 
return c#return.Success
end function

public function integer of_exists_dischcargo (s_poc astr_poc); /********************************************************************
   of_exists_dischcargo
   <DESC> Check the existence of the discharge cargo </DESC>
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
   	28-08-2013 CR3238          LHC010        		 First Version
   </HISTORY>
********************************************************************/

string	ls_expression, ls_cargoidlist
long		ll_row, ll_rowcount, ll_find, ll_cargoid

constant string ls_DELIMITER = ','

//Filter out the cargo with same port_code, pcn and purpose
ls_expression = "port_code = '" + astr_poc.port_code + "'" + " and pcn = " + string(astr_poc.pcn) + " and l_d = 'L'"

ll_rowcount = ids_cargo.rowcount()

do	
	ll_find = ids_cargo.find(ls_expression, ll_find + 1, ll_rowcount + 1)
	if ll_find > 0 then
		ll_cargoid = ids_cargo.getitemnumber(ll_find, "cargo_detail_id")
		ls_cargoidlist += ls_DELIMITER + string(ll_cargoid)
	end if
loop while ll_find > 0

if len(ls_cargoidlist) > 0 then
	ll_find = ids_cargo.find("load_cargo_detail_id in(" + mid(ls_cargoidlist, len(ls_DELIMITER) + 1) + ")", 1, ll_rowcount)
end if

if ll_find > 0 then 
	return c#return.Success
else
	return c#return.Failure
end if

end function

on n_approve_cargo.create
call super::create
end on

on n_approve_cargo.destroy
call super::destroy
end on

event constructor;call super::constructor;//MSPS cargo
ids_msps_groupbycargo = create mt_n_datastore
ids_msps_groupbycargo.dataobject='d_sq_gr_mspscargo'
ids_msps_groupbycargo.settransobject(sqlca)

//TRAMOS cargo
ids_cargo = create mt_n_datastore
ids_cargo.dataobject='d_sq_gr_cargo_detail'
ids_cargo.settransobject(sqlca)
 
//TRAMOS BOL
ids_bol = create mt_n_datastore
ids_bol.dataobject='d_sq_gr_bol_detail'
ids_bol.settransobject(sqlca)

//TRAMOS Original BOL
ids_original_bol = create mt_n_datastore
ids_original_bol.dataobject='d_sq_gr_bol_detail'
ids_original_bol.settransobject(sqlca)

//TRAMOS cargo attachment
ids_cd_att = create mt_n_datastore
ids_cd_att.dataobject='d_sq_gr_cd_att'
ids_cd_att.settransobject(sqlca)
 
end event

event destructor;call super::destructor;destroy ids_bol
destroy ids_cargo
destroy ids_msps_groupbycargo
destroy ids_original_bol
destroy ids_cd_att

end event

