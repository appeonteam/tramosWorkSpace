$PBExportHeader$n_next_open_calculation.sru
forward
global type n_next_open_calculation from mt_n_nonvisualobject
end type
end forward

global type n_next_open_calculation from mt_n_nonvisualobject
end type
global n_next_open_calculation n_next_open_calculation

type variables
mt_n_datastore	ids_nextOpenConfig
mt_n_datastore	ids_nextOpenReport
mt_n_datastore	ids_tradeDistance
mt_n_datastore	ids_portCode
integer				ii_pcnr


end variables

forward prototypes
private subroutine documentation ()
public function string of_getportcode (string as_portcode)
public function integer of_vesseldeleted (long al_cal_clrk_id)
private function datetime of_calculate (string as_fromport, string as_toport, datetime adt_opendate, decimal ad_speed)
public function integer of_configchanged (long al_config_id, integer ai_pcgroup)
public function integer of_vesselchanged (long al_cal_clrk_id, integer ai_pcgroup)
end prototypes

private subroutine documentation ();/********************************************************************
   ObjectName: n_next_open_calculation
   <OBJECT> 
	This object is used to calculate the next open date for competitor vessels
	based on what is configured in the NEXT_OPEN_PORT_CONFIG and next open
	port entered for the vessel(last known state).
	The speed that is used to calculate the time the vessel has to sail the distance
	is taken from the competitor vessel "ballast" speed. The competitor vessel maintainance 
	now has a validation so that you are only allowed to enter one speed of each type. 
	If there is no speed given for a vessel, we use 14 knots
	The distances are handled lige this:
	First we look into the trades to find the distance. If not there we look into the
	AtoBviaC distance table. If not there eighter we set the open date to "1. january 2000"
	When looking up the distance in AtoBviaC distance table, the canals Suez and Panama will
	not be used</OBJECT>
   <DESC> 
	The object/functions can be trigegred by the following events:
	1) Next open configuration is changed (create LABEL, modify PORTbehind LABEL, delete LABEL
			of_configchanged( /*long al_config_id*/, /*integer ai_pc_nr */)
	2) Next open date and/or port on competitor vessel that has fixtures is modified or deleted
			of_vesselchanged( /*long al_cal_clrk_id*/, /*integer ai_pc_nr */)
			of_vesseldeleted( /*long al_cal_clrk_id */)
	3) Competitor vessel ballasted speed changed</DESC>
			of_vesselchanged( /*long al_cal_clrk_id*/, /*integer ai_pc_nr */)
			of_vesseldeleted( /*long al_cal_clrk_id */)
   <USAGE>  
	Uses following datawindow objects:
			d_sq_tb_next_open_port_config
			d_sq_tb_trade_distances
			d_dddw_tramos_port
			d_sq_tb_next_open_calc_by_config
			d_sq_tb_next_open_config_calc
			d_sq_tb_next_open_calc_by_vessel
</USAGE>
   <ALSO>   </ALSO>
    Date		Ref		Author        Comments
  24/06-09	#1637    RMO003     First Version
********************************************************************/

end subroutine

public function string of_getportcode (string as_portcode);/* This function is used to find the AtoBviaC portcode associated with the TRAMOS portcode
	before calling the AtoBviaC distance table for getting the distance between the ports */
long ll_found

if ids_portCode.rowCount() < 1 then ids_portcode.retrieve()
ll_found = ids_portCode.find("port_code='"+as_portcode+"'", 1, 999999)
if ll_found > 0 then
	return ids_portCode.getItemString(ll_found, "abc_portcode")
else
	return as_portcode
end if

end function

public function integer of_vesseldeleted (long al_cal_clrk_id);/********************************************************************
   of_vesselDeleted
   <DESC>
	This function is called from the Competitor vessel maintainance, when the Next Open
	Port or Next Open Date is deleted
	Deletes this vessels items in the Next Open Report
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> 
	Public</ACCESS>
   <ARGS>   
		al_cal_clrk_id: Competitor vessel id  
   </ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
DELETE
FROM PF_NEXT_OPEN_REPORT
where CAL_CLRK_ID = :al_cal_clrk_id;

if sqlca.SQLCode <> 0 then
	MessageBox("Delete Error", "Deleting from PF_NEXT_OPEN_REPORT failed!")
	rollback;
	return -1
end if

commit;

return 1


end function

private function datetime of_calculate (string as_fromport, string as_toport, datetime adt_opendate, decimal ad_speed);/********************************************************************
   of_calculate( /*string as_fromport*/, /*string as_toport*/, /*datetime adt_opendate*/, /*decimal ad_speed */)
   <DESC> This function </DESC>
   <RETURN> datetime: Returns the date the vessel will be open in the config area/port
					if the there is no distance available for this from and to ports, the 
					opendate returned = "1. january 1900" </RETURN>
   <ACCESS> Global Public</ACCESS>
   <ARGS>   as_fromport: Next open port code (entered on competitor vessel)
            		as_toport: The port where date has to be calculated to
				adt_opendate: Next open date (entered on competitor vessel)
				ad_speed: Speed used to calculate the date </ARGS>
   <USAGE>  </USAGE>
********************************************************************/
decimal {4} 	ld_distance
decimal {0}	ld_minutes
long			ll_found
string			ls_searchString
string			ls_AtoBviaCengineState

/* first try to find the distance in TRADE TABLE */
ls_searchString = "lportcode='"+as_fromport+"' and dportcode='"+as_toport+"'"
/* First lookup trade to find distance */
ll_found = ids_tradedistance.find(ls_searchString, 1, 999999)
if ll_found > 0 then
	ld_distance = ids_tradedistance.getItemNumber(ll_found, "distance")
else
	ls_searchString = "dportcode='"+as_fromport+"' and lportcode='"+as_toport+"'"
	/* Next lookup trade reverted route to find distance */
	ll_found = ids_tradedistance.find(ls_searchString, 1, 999999)
	if ll_found > 0 then
		ld_distance = ids_tradedistance.getItemNumber(ll_found, "distance")
	else
		/* if not found in trade try the AtoBviaC distance table */
		/* If not already active create instance */
		if NOT isValid(gnv_atobviac) then gnv_atobviac = create n_atobviac
		
		/* If not open open tables - can take several seconds */
		if NOT gnv_atobviac.of_getTableOpen( ) then
			open(w_startup_screen)
			gnv_AtoBviaC.of_OpenTable()
			close(w_startup_screen)
		end if
		
		ls_AtoBviaCengineState = gnv_atobviac.of_getenginestate( )
		gnv_AtoBviaC.of_resetToDefaultState()
		gnv_AtoBviaC.usePanamaCanal(FALSE)
		gnv_AtoBviaC.useSuezCanal(FALSE)
		as_fromport = of_getportcode( as_fromport )
		as_toport = of_getportcode( as_toport )
		ld_distance = gnv_AtoBviaC.of_getPortToPortDistance(as_fromport , as_toport)
		gnv_atobviac.of_setenginestate( ls_AtoBviaCengineState )
	end if
end if

ld_minutes = (ld_distance / ad_speed) * 60

if ld_minutes = 0 then 
	adt_opendate = datetime(date(1900,01,01))
else
	/* Calculate new date */
	SELECT DATEADD(MI, :ld_minutes, :adt_opendate)
		INTO :adt_opendate
		FROM TRAMOS_VERSION;
end if

return adt_opendate
end function

public function integer of_configchanged (long al_config_id, integer ai_pcgroup);/********************************************************************
   of_configChanged( /*long al_cal_clrk_id */)
   <DESC>
	This function is called from the Next Open Report configuration if a new "tracking"
	label is created or a portcode for an existing "tracking" label is changed.
	Runs through all the Competitor vessels with a Next Open Port and Date registred,
	and calculates the date when the vessel can be in the specified LABEL (config port)
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> 
	Public</ACCESS>
   <ARGS>   
		al_config_id: The configuration id number 
      	ai_pc_nr: Profitcenter</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
long					ll_rows, ll_row, ll_found, ll_cal_clrk_id
string					ls_fromport, ls_toport
datetime 			ldt_fromport_opendate, ldt_nextOpen
mt_n_datastore	lds_calc_vessels
decimal {2}			ld_speed

ids_nextopenreport.dataObject="d_sq_tb_next_open_calc_by_config"
ids_nextopenreport.setTransObject(SQLCA)
ids_nextopenreport.retrieve(al_config_id)

lds_calc_vessels = create mt_n_datastore
lds_calc_vessels.dataObject = "d_sq_tb_next_open_config_calc"
lds_calc_vessels.setTransObject(sqlca)
ll_rows = lds_calc_vessels.retrieve( ai_pcgroup )

SELECT PORT_CODE   
INTO :ls_toPort 
FROM PF_NEXT_OPEN_PORTS_CONFIG
WHERE NEXT_CONFIG_ID = :al_config_id   ;
if SQLCA.SQLCode <> 0 then
	messageBox("Select Error", "Error selection PortCode from PF_NEXT_OPEN_PORT_CONFIG")
	rollback;
	return -1
end if
commit;

ids_tradedistance.retrieve(ai_pcgroup)
for ll_row = 1 to ll_rows
	ls_fromPort = lds_calc_vessels.getItemString(ll_row, "next_open_port")
	ldt_fromport_opendate = lds_calc_vessels.getItemDatetime(ll_row, "next_open_date")
	ll_cal_clrk_id = lds_calc_vessels.getItemNumber(ll_row, "cal_clrk_id")

	/* Get ballasted speed for use in the calculation. If no speed use 14 knots */
	setNull(ld_speed)
	SELECT CAL_CONS_SPEED
	INTO :ld_speed 
	FROM CAL_CONS  
	WHERE CAL_CLRK_ID = :ll_cal_clrk_id 
	AND CAL_CONS_TYPE = 1 ;
	commit;
	if isNull(ld_speed) or ld_speed = 0 then ld_speed = 14
	
	ldt_nextOpen = of_calculate( ls_fromport, ls_toport, ldt_fromport_opendate, ld_speed )
	ll_found = ids_nextopenreport.find("cal_clrk_id="+string(ll_cal_clrk_id) + " and next_config_id="+string(al_config_Id),1,99999)
	if ll_found > 0 then
		ids_nextopenreport.setItem(ll_found, "open_date", ldt_nextOpen)
	else
		ll_found = ids_nextopenreport.insertRow(0)
		if ll_found > 0 then
			ids_nextopenreport.setItem(ll_found, "cal_clrk_id", ll_cal_clrk_id )
			ids_nextopenreport.setItem(ll_found, "next_config_id", al_config_Id )
			ids_nextopenreport.setItem(ll_found, "open_date", ldt_nextOpen )
		end if
	end if
next

if ids_nextopenreport.Update() <> 1 then
	MessageBox("Update Error", "Error updating next open report table")
	rollback;
else
	commit;
end if

return 1
end function

public function integer of_vesselchanged (long al_cal_clrk_id, integer ai_pcgroup);/********************************************************************
   of_vesselChanged
   <DESC>
	This function is called from the Competitor vessel maintainance, when the Next Open
	Port,  Next Open Date or speed for ballast consumption is modified.
	Runs through all the "tracking" areas LABEL, and calculates the date when the vessel 
	can be in the specified LABEL (config port)
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> 
	Public</ACCESS>
   <ARGS>   
		al_cal_clrk_id: Competitor vessel id  
      	ai_pcgroup: Profitcenter Group</ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
long			ll_rows, ll_row, ll_found
string			ls_fromport, ls_toport
datetime 	ldt_fromport_opendate, ldt_nextOpen
long			ll_configId
decimal {2}	ld_speed

ll_rows = ids_nextopenconfig.retrieve(ai_pcgroup)
if ll_rows < 1 then return 0  //Nothing to calculate

ids_nextopenreport.dataObject="d_sq_tb_next_open_calc_by_vessel"
ids_nextopenreport.setTransObject(SQLCA)
ids_nextopenreport.retrieve(al_cal_clrk_id)

SELECT NEXT_OPEN_PORT,   
	NEXT_OPEN_DATE  
INTO :ls_fromPort  ,   
	:ldt_fromport_opendate 
FROM CAL_CLAR  
WHERE CAL_CLRK_ID = :al_cal_clrk_id   ;
if SQLCA.SQLCode <> 0 then
	messageBox("Select Error", "Error selection Next Open Port/Date from CAL_CLAR")
	rollback;
	return -1
end if
commit;

/* Get ballasted speed for use in the calculation. If no speed use 14 knots */
setNull(ld_speed)
SELECT CAL_CONS_SPEED
INTO :ld_speed 
FROM CAL_CONS  
WHERE CAL_CLRK_ID = :al_cal_clrk_id 
AND CAL_CONS_TYPE = 1 ;
commit;
if isNull(ld_speed) or ld_speed = 0 then ld_speed = 14

ids_tradedistance.retrieve(ai_pcgroup)
for ll_row = 1 to ll_rows
	ls_toPort = ids_nextopenconfig.getItemString(ll_row, "port_code")
	ll_configId = ids_nextopenconfig.getItemNumber(ll_row, "next_config_id")
	ldt_nextOpen = of_calculate( ls_fromport, ls_toport, ldt_fromport_opendate, ld_speed )
	ll_found = ids_nextopenreport.find("cal_clrk_id="+string(al_cal_clrk_id) + " and next_config_id="+string(ll_configId),1,99999)
	if ll_found > 0 then
		ids_nextopenreport.setItem(ll_found, "open_date", ldt_nextOpen)
	else
		ll_found = ids_nextopenreport.insertRow(0)
		if ll_found > 0 then
			ids_nextopenreport.setItem(ll_found, "cal_clrk_id", al_cal_clrk_id )
			ids_nextopenreport.setItem(ll_found, "next_config_id", ll_configId )
			ids_nextopenreport.setItem(ll_found, "open_date", ldt_nextOpen )
		end if
	end if
next

if ids_nextopenreport.Update() <> 1 then
	MessageBox("Update Error", "Error updating next open report table")
	rollback;
else
	commit;
end if

return 1
end function

on n_next_open_calculation.create
call super::create
end on

on n_next_open_calculation.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_nextOpenConfig = create mt_n_datastore
ids_nextOpenConfig.dataObject="d_sq_tb_next_open_port_config"
ids_nextOpenConfig.setTransObject(SQLCA)

ids_nextopenreport = create mt_n_datastore

ids_tradedistance = create mt_n_datastore
ids_tradedistance.dataObject="d_sq_tb_trade_distances"
ids_tradedistance.setTransObject(SQLCA)

ids_portCode = create mt_n_datastore
ids_portCode.dataObject="d_dddw_tramos_port"
ids_portCode.setTransObject(SQLCA)


end event

event destructor;call super::destructor;if isValid(ids_nextOpenConfig) then  
	destroy ids_nextOpenConfig
end if

if isValid(ids_nextOpenReport) then  
	destroy ids_nextOpenReport
end if
	
if isValid(ids_tradeDistance) then  
	destroy ids_tradeDistance
end if

if isValid(ids_portCode) then  
	destroy ids_portCode
end if

end event

