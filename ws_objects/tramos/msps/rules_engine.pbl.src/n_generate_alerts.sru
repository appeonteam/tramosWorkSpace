$PBExportHeader$n_generate_alerts.sru
$PBExportComments$Generate alerts for rules engines
forward
global type n_generate_alerts from mt_n_nonvisualobject
end type
end forward

global type n_generate_alerts from mt_n_nonvisualobject autoinstantiate
end type

type variables
s_alerts istr_alerts
mt_n_datastore ids_rulessetup			//Basic rules
mt_n_datastore ids_rulesconfig		//Rules engine configration
mt_n_datastore ids_rulesalerts		//Generation Alerts
mt_n_datastore ids_rulesseverity		//Severity
mt_n_datastore ids_msps					//Rules engine source data
mt_n_datastore	ids_operations			//Rules engine target data

integer	ii_notdefined_severityid
integer	ii_missing_severityid
integer	ii_acceptable_severityid

long		il_calcid
integer	ii_voyagetype
string	is_voyagetypename
integer	ii_rulesenabled
string	is_reporttype
boolean	ib_generatenotdefined
string	is_voyagenr
boolean	ib_voyagenotexists
integer	il_pcn
string	il_portcode




end variables

forward prototypes
private function integer _init_alerts ()
private function long _find_severityid (string as_column)
private function integer _add_alerts ()
private function integer _get_nextport ()
private function integer _check_rulesdefined (long al_row)
private function string _getitem (mt_n_datastore ads_source, string as_colname)
private function string _getthanstring (string as_unit, string as_compsymbol)
public function integer _apply_rules (long al_row)
private function string _getitem (mt_n_datastore ads_source, string as_colname, ref decimal adc_values)
public subroutine documentation ()
private function integer _check_messagemissing (long al_row)
private function integer _check_proceedmissing (long al_row)
public function boolean _build_alertmsg (string as_col1or2, long al_row, long al_findrow, ref string as_alertmsg)
public function integer of_generate_alerts (long al_vesselimo, long al_reportid, long al_revisionno, string as_msgtype, boolean ab_generatenotdefined)
private function integer _notexist_voyage (long al_row)
private function integer _apply_voyagetype (long al_row)
end prototypes

private function integer _init_alerts ();/********************************************************************
   _init_alerts
   <DESC>Init data</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2013 CR3240            LHC010        First Version
   </HISTORY>
********************************************************************/

//Rules setup
ids_rulessetup.retrieve(istr_alerts.msg_type)

if ids_rulessetup.rowcount() <= 0 then return c#return.noaction

//Severity
ids_rulesseverity.retrieve( )

if ids_rulesseverity.rowcount() <= 0 then return c#return.noaction

ii_notdefined_severityid = _find_severityid("severity_notdefined")
ii_missing_severityid	 = _find_severityid("severity_missing")
ii_acceptable_severityid = _find_severityid("severity_acceptable")

//Retrieve message data
ids_msps.retrieve(istr_alerts.vessel_imo, istr_alerts.report_id, istr_alerts.revision_no, istr_alerts.msg_type)

if ids_msps.rowcount() <> 1 then return c#return.Failure

istr_alerts.vessel_nr = ids_msps.getitemnumber(1, "vessel_nr")
istr_alerts.voyage_nr = ids_msps.getitemstring(1, "voyage_no")
istr_alerts.port_code = ids_msps.getitemstring(1, "port_code")
istr_alerts.pcn		 = ids_msps.getitemnumber(1, "pcn")
istr_alerts.next_port_code = ids_msps.getitemstring(1, "next_port_code")
il_pcn = istr_alerts.pcn
il_portcode = istr_alerts.port_code

if _get_nextport() = c#return.success and not isnull(istr_alerts.port_code) then
	ids_operations.retrieve(istr_alerts.vessel_nr, istr_alerts.voyage_nr, istr_alerts.port_code, istr_alerts.pcn)
end if

if len(istr_alerts.voyage_nr) > 0 then
	//Rules configuration
	ids_rulesconfig.retrieve(istr_alerts.vessel_nr, istr_alerts.voyage_nr)

	SELECT DESCRIPTION, RUL_ENABLED, VOYAGES.VOYAGE_TYPE, isnull(CAL_CALC_ID, 0)
	  INTO :is_voyagetypename, :ii_rulesenabled, :ii_voyagetype, :il_calcid
	  FROM VOYAGES, VOYAGE_TYPE
	 WHERE VOYAGES.VOYAGE_TYPE = VOYAGE_TYPE.ID
		AND VESSEL_NR = :istr_alerts.vessel_nr
		AND VOYAGE_NR = :istr_alerts.voyage_nr;
end if

//Retrieve the all alerts for the message
ids_rulesalerts.retrieve(istr_alerts.vessel_imo, istr_alerts.report_id, istr_alerts.revision_no, istr_alerts.msg_type)

return c#return.Success
end function

private function long _find_severityid (string as_column);/********************************************************************
   _find_severityid
   <DESC> Find the severity ID</DESC>
   <RETURN>	long:
            <LI> c#return.Success, > 0 ok
            <LI> c#return.Failure, -1 failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_column: find column name
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2013 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

long	ll_severityid, ll_findrow

ll_findrow = ids_rulesseverity.find(as_column + " = 1" , 1, ids_rulesseverity.rowcount())

if ll_findrow > 0 then 
	ll_severityid = ids_rulesseverity.getitemnumber(ll_findrow, "severity_id")
else
	ll_severityid = c#return.Failure
end if

return ll_severityid
end function

private function integer _add_alerts ();/********************************************************************
   _add_alerts
   <DESC>Add or replace alerts base on rules defined for each type(ETA, Speed, HFO Port Stay...etc.)</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ids_rulesalerts
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2013 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

long	ll_find, ll_row, ll_rowcount

if isnull(istr_alerts.severity_id) or istr_alerts.severity_id <= 0 then return c#return.failure
	
if istr_alerts.severity_id = ii_notdefined_severityid and not ib_generatenotdefined then return c#return.failure

//if istr_alerts.severity_id = ii_acceptable_severityid then setnull(istr_alerts.alerts_msg)

ll_rowcount = ids_rulesalerts.rowcount()

ll_find = ids_rulesalerts.find("rul_id = " + string(istr_alerts.rul_id), 1, ll_rowcount + 1)

if ll_find = 0 then
	ll_row = ids_rulesalerts.insertrow(0)
else
	ll_row = ll_find
end if

if ll_row > 0 then
	ids_rulesalerts.setitem(ll_row, "rul_id", istr_alerts.rul_id)
	ids_rulesalerts.setitem(ll_row, "vessel_imo", istr_alerts.vessel_imo)
	ids_rulesalerts.setitem(ll_row, "report_id", istr_alerts.report_id)
	ids_rulesalerts.setitem(ll_row, "revision_no", istr_alerts.revision_no)
	ids_rulesalerts.setitem(ll_row, "msg_type", istr_alerts.msg_type)
	ids_rulesalerts.setitem(ll_row, "vessel_nr", istr_alerts.vessel_nr)
	ids_rulesalerts.setitem(ll_row, "voyage_nr", istr_alerts.voyage_nr)
	ids_rulesalerts.setitem(ll_row, "port_code", istr_alerts.port_code)
	ids_rulesalerts.setitem(ll_row, "pcn", istr_alerts.pcn)
	ids_rulesalerts.setitem(ll_row, "severity_id", istr_alerts.severity_id)
	ids_rulesalerts.setitem(ll_row, "alerts_msg", istr_alerts.alerts_msg)
	ids_rulesalerts.setitem(ll_row, "create_date", now())
end if

setnull(istr_alerts.severity_id)
setnull(istr_alerts.alerts_msg)

return c#return.success
end function

private function integer _get_nextport ();/********************************************************************
   _get_nextport
   <DESC>Get the next port successful if the Message's Next Port equals to Proceeding's Next Port, 
			otherwise it is failure</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	02-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

integer	li_portorder, li_pcn
string	ls_voyagenr, ls_nextport

if ids_msps.rowcount( ) = 1 then is_reporttype = lower(ids_msps.getitemstring(1, "report_type"))

setnull(is_voyagenr)

SELECT VOYAGE_NR 
  INTO :is_voyagenr 
  FROM VOYAGES 
 WHERE VESSEL_NR = :istr_alerts.vessel_nr
 	AND VOYAGE_NR = :istr_alerts.voyage_nr;

if isnull(is_voyagenr) or len(is_voyagenr) <= 0 then
	ib_voyagenotexists = true
	is_voyagenr = istr_alerts.voyage_nr
end if

//if report type is "sea" the next port is itself
if is_reporttype = "sea" then return c#return.success

//Get the port order according to current port.
SELECT PORT_ORDER
  INTO :li_portorder
  FROM PROCEED
 WHERE VESSEL_NR = :istr_alerts.vessel_nr
   AND VOYAGE_NR = :istr_alerts.voyage_nr
	AND PORT_CODE = :istr_alerts.port_code
	AND PCN = :istr_alerts.pcn
 USING SQLCA;

if not (SQLCA.SQLCode = 0 and SQLCA.sqlnrows = 1) then
	setnull(istr_alerts.port_code)
	setnull(istr_alerts.pcn)	
	return c#return.Failure
end if

//Get the voyage and next port according to current port.
SELECT VOYAGE_NR, 
		 PORT_CODE, 
		 PCN
  INTO :ls_voyagenr,
  		 :ls_nextport,
		 :li_pcn
  FROM PROCEED 
 WHERE VESSEL_NR = :istr_alerts.vessel_nr
	AND (VOYAGE_NR = :istr_alerts.voyage_nr
		  and PORT_ORDER > :li_portorder or VOYAGE_NR > :istr_alerts.voyage_nr)
   AND convert(int, left(VOYAGE_NR, 2)) < 90
	AND CANCEL = 0
ORDER BY VOYAGE_NR, PORT_ORDER ASC;

//Get the next port successful if the Message's Next Port equals to Proceeding's Next Port, otherwise it is failure
if len(ls_voyagenr) > 0 then 
	istr_alerts.voyage_nr = ls_voyagenr
	
	if ls_nextport = istr_alerts.next_port_code then
		istr_alerts.port_code = ls_nextport
		istr_alerts.pcn = li_pcn
	else
		setnull(istr_alerts.port_code)
		setnull(istr_alerts.pcn)
	end if

	return c#return.success
else
	setnull(istr_alerts.voyage_nr)
	setnull(istr_alerts.port_code)
	setnull(istr_alerts.pcn)

	return c#return.failure
end if
end function

private function integer _check_rulesdefined (long al_row);/********************************************************************
   _check_rulesdefined
   <DESC>Check if the rules defined</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	02-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

long ll_rulesid, ll_findconfig
string	ls_name

ll_rulesid = ids_rulessetup.getitemnumber(al_row, "rul_id")
istr_alerts.rul_id = ll_rulesid

ll_findconfig = ids_rulesconfig.find("rul_id = " + string(ll_rulesid), 1, ids_rulesconfig.rowcount() + 1)
	
//Rules are not defined
if ll_findconfig <= 0 then
	istr_alerts.severity_id = ii_notdefined_severityid
		
	//If severity does not exist then exit
	if istr_alerts.severity_id <= 0 then return c#return.Failure

	ls_name = ids_rulessetup.getitemstring(al_row, "rul_name")
	istr_alerts.alerts_msg = ls_name + " Rule: rules not defined."
	_add_alerts()
	
	return c#return.Failure
end if

return c#return.success
end function

private function string _getitem (mt_n_datastore ads_source, string as_colname);/********************************************************************
   _getitem
   <DESC>Get the value of an item for the specified row and column</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ads_source
		as_columnname
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

decimal		ldc_values

return _getitem(ads_source, as_colname, ldc_values)

end function

private function string _getthanstring (string as_unit, string as_compsymbol);/********************************************************************
   _getthanstring
   <DESC>Get the than string</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		as_unit
		as_compsymbol
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	06-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/
string	ls_than

choose case as_compsymbol
	case ">", ">="
		if as_unit = "days" then
			ls_than = "later than "
		else
			ls_than = "higher than expected "
		end if
	case "<", "<="
		if as_unit = "days" then
			ls_than = "earlier than "
		else
			ls_than = "lower than expected "
		end if
end choose

return ls_than
end function

public function integer _apply_rules (long al_row);/********************************************************************
   _apply_rules
   <DESC>Apply the rules and generate the alerts messages.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	02-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

long 		ll_rulesid, ll_findrow, ll_severityid
string	ls_relation, ls_alertmsg1, ls_alertmsg2
boolean	lb_1stpartrule, lb_2ndpartrule, lb_acceptable = true

if ids_msps.rowcount( ) <> 1 or ids_operations.rowcount( ) <> 1 or ids_rulesconfig.rowcount( ) <= 0 then return c#return.noaction

ll_rulesid = ids_rulessetup.getitemnumber(al_row, "rul_id")
istr_alerts.rul_id = ll_rulesid

ll_findrow = 0

do 
	ll_findrow = ids_rulesconfig.find("rul_id = " + string(ll_rulesid), ll_findrow + 1, ids_rulesconfig.rowcount() + 1)
	
	if ll_findrow > 0 then
		ll_severityid = ids_rulesconfig.getitemnumber(ll_findrow, "severity_id")
		ls_relation = lower(ids_rulesconfig.getitemstring(ll_findrow, "relation"))
		
		//Generate alert message for the 1st part of the pre-defined rules
		lb_1stpartrule = _build_alertmsg("1", al_row, ll_findrow, ls_alertmsg1)
		
		lb_2ndpartrule = true
		
		//If the relation is "AND", then generate alert message for the 2nd part of the defined rules
		if len(ls_relation) > 0 then lb_2ndpartrule = _build_alertmsg("2", al_row, ll_findrow, ls_alertmsg2)
		
		if lb_1stpartrule and lb_2ndpartrule then	
			istr_alerts.severity_id = ll_severityid
			istr_alerts.alerts_msg = ls_alertmsg1
			lb_acceptable = false
			if ls_relation = "and" then
				//If the 1st and 2nd part is generate, then alert message is 1st + 2nd part.	
				istr_alerts.alerts_msg = ls_alertmsg1 + " and " + ls_alertmsg2
			end if
			
			_add_alerts()
		end if
	end if
loop while ll_findrow > 0

//If no alert message generated, then generate acceptable alerts.
if lb_acceptable then
	istr_alerts.severity_id = ii_acceptable_severityid
	istr_alerts.alerts_msg = ids_rulessetup.getitemstring(al_row, "rul_sourcelabel") + " is acceptable."
	_add_alerts()
end if

return c#return.Success
end function

private function string _getitem (mt_n_datastore ads_source, string as_colname, ref decimal adc_values);/********************************************************************
   _getitem
   <DESC>Get the value of an item for the specified row and column</DESC>
   <RETURN>	string:
            <LI> 
            <LI> </RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ads_source
		as_columnname
		adc_values  return decimal values
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	03-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

string	ls_return
datetime	ldt_values
integer	li_colid

setnull(ls_return)
setnull(adc_values)

li_colid = integer(ads_source.describe(as_colname + ".ID"))

if ads_source.getrow() <= 0 or li_colid <= 0 then return ls_return

choose case left(ads_source.describe(as_colname + ".coltype"),4)
	case "char"
		ls_return = ads_source.getitemstring(1, li_colid)
	case "date"
		ldt_values = ads_source.getitemdatetime(1, li_colid)
		if not isnull(ldt_values) then 
			ls_return = string(ldt_values, "dd-mm-yyyy hh:mm")
			adc_values = f_datetime2long(ldt_values)
		end if
	case "deci", "long", "int", "numb", "real", "ulon"
		adc_values = ads_source.getitemdecimal(1, li_colid)
		
		//if the values is greater than zero, format the return's value.
		if adc_values > 0 then 
			ls_return = string(adc_values, "#########0.00##")
		elseif adc_values = 0 then
			ls_return = '0'
		end if
end choose

return ls_return

end function

public subroutine documentation ();/********************************************************************
   n_generate_alerts
   <OBJECT>Generate the alerts</OBJECT>
   <USAGE>
		1. Import MSPS messages in the MSPS Interface.
		2.	Update the information for vessel messages.
		3. Click the "Refresh Alerts" button in the Vessel Messages List windows.
	</USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	16-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

end subroutine

private function integer _check_messagemissing (long al_row);/********************************************************************
   _check_messagemissing
   <DESC>Data is missing in the message.</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30-12-2013 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

string	ls_sourcefield, ls_sourcelabel
integer	li_applyatsea, li_applyatport
string	ls_sourcedata, ls_name

if al_row <= 0 then return c#return.noaction

li_applyatsea = ids_rulessetup.getitemnumber(al_row, "rul_applyatsea")
li_applyatport = ids_rulessetup.getitemnumber(al_row, "rul_applyatport")
ls_name			= ids_rulessetup.getitemstring(al_row, "rul_name")			

//Next port is missing in the message.
if isnull(istr_alerts.next_port_code) or isnull(istr_alerts.voyage_nr) then
	ls_sourcelabel = ls_name + " Rule: Next Port"
	setnull(ls_sourcedata)
elseif li_applyatsea = 1 and is_reporttype = "sea" then //The rule does not apply for sea report
	istr_alerts.severity_id = ii_notdefined_severityid
	istr_alerts.alerts_msg = ls_name + " Rule: rules do not apply."
	_add_alerts()
	return c#return.Failure
elseif li_applyatport = 1 and is_reporttype = "port" then //The rule does not apply for port report
	istr_alerts.severity_id = ii_notdefined_severityid
	istr_alerts.alerts_msg = ls_name + " Rule: rules do not apply."
	_add_alerts()
	return c#return.Failure
else //Data is missing in the message.
	ls_sourcelabel = ids_rulessetup.getitemstring(al_row, "rul_sourcelabel")
	ls_sourcefield = lower(ids_rulessetup.getitemstring(al_row, "rul_sourcefield"))
	ls_sourcedata = _getitem(ids_msps, ls_sourcefield)
end if

if isnull(ls_sourcedata) then
	istr_alerts.severity_id = ii_missing_severityid
	istr_alerts.alerts_msg = ls_sourcelabel + " is missing in the message."
	
	_add_alerts()
	
	return c#return.Failure
end if

return c#return.Success
end function

private function integer _check_proceedmissing (long al_row);/********************************************************************
   _check_proceedmissing
   <DESC>Data is missing in Proceeding. </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	31-12-2013 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

integer	li_applyallocated, li_applyfirstload, li_applyviaport, li_colnum, li_return 
string	ls_targetlabel1, ls_targetfield1, ls_targetlabel2, ls_targetfield2
string	ls_targetdata, ls_sourcelabel, ls_relation, ls_name

if al_row <= 0 then return c#return.noaction

ls_sourcelabel = ids_rulessetup.getitemstring(al_row, "rul_sourcelabel")
ls_name			= ids_rulessetup.getitemstring(al_row, "rul_name")

//if isnull(istr_alerts.port_code) or (isnull(istr_alerts.pcn) and is_reporttype = "port") then
//	istr_alerts.severity_id = ii_missing_severityid
//	istr_alerts.alerts_msg = ls_name + " Rule: '" + istr_alerts.next_port_code + "' does not exist in Proceeding."
//	
//	_add_alerts()
//	
//	return c#return.Failure
//end if

li_applyallocated = ids_rulessetup.getitemnumber(al_row, "rul_applyallocated")

//checked voyage is allocated?
if li_applyallocated = 1 then 
	if ii_voyagetype <> 2 and (il_calcid <= 1 or isnull(il_calcid))then
		istr_alerts.severity_id = ii_missing_severityid
		istr_alerts.alerts_msg = ls_name + " Rule: voyage '" + trim(istr_alerts.voyage_nr) + "' is not allocated."
		
		_add_alerts()
		
		return c#return.Failure
	end if
end if

ls_targetfield1 = lower(ids_rulessetup.getitemstring(al_row, "rul_targetfield1"))
ls_targetdata = _getitem(ids_operations, ls_targetfield1)

li_applyfirstload = ids_rulessetup.getitemnumber(al_row, "rul_applyfirstload")
li_applyviaport   = ids_rulessetup.getitemnumber(al_row, "rul_applyviaport")

//Apply first load part for the cargo
if li_applyfirstload = 1 then 
	if isnull(ls_targetdata) then
		istr_alerts.severity_id = ii_notdefined_severityid
		istr_alerts.alerts_msg = ls_name + " Rule: rules do not apply."
		
		_add_alerts()
		
		return c#return.Failure	
	end if
elseif li_applyviaport = 0 and istr_alerts.pcn <= 0 then  //Rule not applie rule for Via point
		istr_alerts.severity_id = ii_notdefined_severityid
		istr_alerts.alerts_msg = ls_name + " Rule: rules do not apply for Via Points."
		
		_add_alerts()
		
		return c#return.Failure		
else//Target1 is missing in the proceeding
	ls_targetlabel1 = ids_rulessetup.getitemstring(al_row, "rul_targetlabel1")
	
	if isnull(ls_targetdata) then
		istr_alerts.severity_id = ii_missing_severityid
		istr_alerts.alerts_msg = ls_targetlabel1 + " is missing in proceeding."
		
		_add_alerts()
		
		return c#return.Failure	
	end if
	
	ls_targetlabel2 = ids_rulessetup.getitemstring(al_row, "rul_targetlabel2")
	ls_targetfield2 = lower(ids_rulessetup.getitemstring(al_row, "rul_targetfield2"))
	
	//Target2 is missing in the proceeding
	if len(ls_targetfield2) > 0 then
		ls_targetdata = _getitem(ids_operations, ls_targetfield1)
		
		if isnull(ls_targetdata) then
			istr_alerts.severity_id = ii_missing_severityid
			istr_alerts.alerts_msg = ls_targetlabel1 + " is missing in proceeding."
			
			_add_alerts()
			
			return c#return.Failure	
		end if
	end if
end if

return c#return.Success
end function

public function boolean _build_alertmsg (string as_col1or2, long al_row, long al_findrow, ref string as_alertmsg);/********************************************************************
   _build_alertmsg
   <DESC>Constitute the alerts message</DESC>
   <RETURN>	boolean:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_col1or2
		al_row
		al_findrow
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	02-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

long 		ll_convertvalue
string	ls_sourcelabel, ls_sourcefield, ls_sourcedata
string	ls_targetlabel, ls_targetfield, ls_targetdata, ls_compsymbol, ls_symbol, ls_than
string	ls_unit
constant string ls_SPACE = " "
integer	li_operatorsymbol
decimal	ldc_constants, ldc_source, ldc_target 
boolean	lb_result

ls_sourcefield  = ids_rulessetup.getitemstring(al_row, "rul_sourcefield")
ll_convertvalue = ids_rulessetup.getitemnumber(al_row, "rul_convertvalue")
ls_sourcedata	 = _getitem(ids_msps, ls_sourcefield, ldc_source)

ls_targetfield = ids_rulesconfig.getitemstring(al_findrow, "expected" + as_col1or2)
ls_targetdata  = _getitem(ids_operations, ls_targetfield, ldc_target)

ls_compsymbol  = ids_rulesconfig.getitemstring(al_findrow, "comp_symbol" + as_col1or2)
li_operatorsymbol = ids_rulesconfig.getitemnumber(al_findrow, "operator_symbol" + as_col1or2)
ldc_constants  = ids_rulesconfig.getitemdecimal(al_findrow, "constants" + as_col1or2)

//Compare result 		
choose case ls_compsymbol
	case ">"
		lb_result = (ldc_source > ldc_target + (li_operatorsymbol * ldc_constants * ll_convertvalue))
	case ">="
		lb_result = (ldc_source >= ldc_target + (li_operatorsymbol * ldc_constants * ll_convertvalue))
	case "<"
		lb_result = (ldc_source < ldc_target + (li_operatorsymbol * ldc_constants * ll_convertvalue))				
	case "<="
		lb_result = (ldc_source <= ldc_target + (li_operatorsymbol * ldc_constants * ll_convertvalue))
end choose

if lb_result then
	if li_operatorsymbol = 1 then ls_symbol = " + "
	if li_operatorsymbol = -1 then ls_symbol = " - "
				
	ls_unit = lower(ids_rulessetup.getitemstring(al_row, "rul_unit"))
	
	//Get the than string.
	ls_than = _getthanstring(ls_unit, ls_compsymbol)

	ls_sourcelabel = ids_rulessetup.getitemstring(al_row, "rul_sourcelabel")
	if ls_targetfield = ids_rulessetup.getitemstring(al_row, "rul_targetfield1") then
		ls_targetlabel = ids_rulessetup.getitemstring(al_row, "rul_targetlabel1")
	else
		ls_targetlabel = ids_rulessetup.getitemstring(al_row, "rul_targetlabel2")
	end if
	
	//Generate the alert string.
	as_alertmsg = ls_sourcelabel + ls_SPACE + ls_sourcedata + " is " + ls_than + ls_targetlabel + ls_SPACE + ls_targetdata + ls_symbol + ls_SPACE +  string(ldc_constants) + ls_SPACE + ls_unit
end if

return lb_result
end function

public function integer of_generate_alerts (long al_vesselimo, long al_reportid, long al_revisionno, string as_msgtype, boolean ab_generatenotdefined);/********************************************************************
   of_generate_alerts
   <DESC>Generate the alerts</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_alerts
   </ARGS>
   <USAGE>	
		1. Import MSPS messages in the MSPS Interface.
		2.	Update the information for vessel messages.
		3. Click the "Refresh Alerts" button in the Vessel Messages List windows.
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	26-12-2013 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

long	ll_row, ll_setupcount
integer	li_return

//Get the primary key
istr_alerts.vessel_imo 	= al_vesselimo
istr_alerts.report_id  	= al_reportid
istr_alerts.revision_no	= al_revisionno
istr_alerts.msg_type		= as_msgtype

ib_generatenotdefined = ab_generatenotdefined

//Init the data
if _init_alerts() <> c#return.success then return c#return.failure

ll_setupcount = ids_rulessetup.rowcount()

for ll_row = 1 to ll_setupcount
	//Check if the rules defined.
	if _check_rulesdefined(ll_row) <> c#return.success then continue
	
	//Check if the voyage does not exist
	if _notexist_voyage(ll_row) <> c#return.success then 
		exit
	end if
	
	//Check if rules should be applied for some voyage type.
	if _apply_voyagetype(ll_row) <> c#return.success then continue
		
	//Data is missing in the message.
	if _check_messagemissing(ll_row) <> c#return.success then continue
	
	//Data is missing in the proceeding.
	if _check_proceedmissing(ll_row) <> c#return.success then continue

	//Apply rules.
	_apply_rules(ll_row)
next

if ids_rulesalerts.update( ) = 1 then
	commit;
	li_return = c#return.success
else
	rollback;
	li_return = c#return.failure
end if

return li_return
end function

private function integer _notexist_voyage (long al_row);/********************************************************************
   _notexist_voyage
   <DESC>If voyage does not exist in Proceeding</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24-01-2014 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

string ls_temp

if ib_voyagenotexists then
	istr_alerts.severity_id = ii_missing_severityid
	
	if isnull(is_voyagenr) or len(is_voyagenr) <= 0 then 
		istr_alerts.alerts_msg = "Voyage number is missing in the message."
	else
		istr_alerts.alerts_msg = "Voyage '" + is_voyagenr + "' does not exist in Proceeding."
	end if
	
	_add_alerts()	
	
	return c#return.failure
end if

if isnull(il_pcn) then
	istr_alerts.severity_id = ii_missing_severityid

	if is_reporttype = "sea" then ls_temp = "Next "	

	if isnull(il_portcode) then
		istr_alerts.alerts_msg = ls_temp + "Port is missing in message."
	else
		istr_alerts.alerts_msg = ls_temp + "Port '" + il_portcode + "' does not match in Proceeding."
	end if

	_add_alerts()	
	
	return c#return.failure
end if

if isnull(istr_alerts.pcn) then
	istr_alerts.severity_id = ii_missing_severityid
	
	if isnull(istr_alerts.next_port_code) then
		istr_alerts.alerts_msg = "Next Port is missing in message."
	else
		istr_alerts.alerts_msg = "Next Port '" + istr_alerts.next_port_code + "' does not match in Proceeding."
	end if
	
	_add_alerts()
	
	return c#return.Failure
end if

return c#return.Success
end function

private function integer _apply_voyagetype (long al_row);/********************************************************************
   _apply_voyagetype
   <DESC>The rules only apply for the enabled voyage type</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		ai_voyagetype
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	30-12-2013 CR3240       LHC010        First Version
   </HISTORY>
********************************************************************/

integer li_applytcout, li_return
string  ls_name

li_return = c#return.success 

ls_name = ids_rulessetup.getitemstring(al_row, "rul_name")

//Voyage for next port is missing in proceeding
//if isnull(istr_alerts.voyage_nr) then 
//	istr_alerts.severity_id = ii_missing_severityid
//	istr_alerts.alerts_msg = ls_name + " Rule: voyage does not exist in Proceeding."
//	li_return = c#return.failure
//end if

if ii_voyagetype > 0 and ii_rulesenabled = 0 then
	istr_alerts.severity_id = ii_notdefined_severityid
	istr_alerts.alerts_msg = ls_name + " Rule: rules are not applied for " + is_voyagetypename + "."
	li_return = c#return.failure	
end if

if li_return = c#return.failure then _add_alerts()

if ii_voyagetype = 2 and li_return = c#return.success  then //Time Charter Out
	li_applytcout = ids_rulessetup.getitemnumber(al_row, "rul_applytcout")
	
	//TC out voyage is not applied
	if li_applytcout = 0 then
		istr_alerts.severity_id = ii_notdefined_severityid					
		istr_alerts.alerts_msg = ls_name + " Rule: rules are not applied for TC-out voyages."
		li_return = c#return.failure
		_add_alerts()
	end if
end if

return li_return



end function

on n_generate_alerts.create
call super::create
end on

on n_generate_alerts.destroy
call super::destroy
end on

event constructor;call super::constructor;//Rules engine system configuration
ids_rulessetup = create mt_n_datastore
ids_rulessetup.dataobject = "d_sq_gr_rules_setup"
ids_rulessetup.settransobject(sqlca)

//Severity 
ids_rulesseverity = create mt_n_datastore
ids_rulesseverity.dataobject = "d_sq_gr_rules_severity"
ids_rulesseverity.settransobject(sqlca)

//Rules configuration
ids_rulesconfig = create mt_n_datastore
ids_rulesconfig.dataobject = "d_sq_gr_rules_config"
ids_rulesconfig.settransobject(sqlca)

//Alerts message
ids_rulesalerts = create mt_n_datastore
ids_rulesalerts.dataobject = "d_sq_gr_rules_alerts"
ids_rulesalerts.settransobject(sqlca)

//Message data
ids_msps	= create mt_n_datastore
ids_msps.dataobject = "d_sq_gr_rules_engine_msps"
ids_msps.settransobject(sqlca)

//operations data
ids_operations = create mt_n_datastore
ids_operations.dataobject = "d_sq_gr_rules_engine_operations"
ids_operations.settrans(sqlca)







end event

event destructor;call super::destructor;destroy ids_rulessetup
destroy ids_rulesconfig
destroy ids_rulesalerts
destroy ids_rulesseverity
destroy ids_msps
destroy ids_operations

end event

