$PBExportHeader$n_agency_appointment.sru
$PBExportComments$Used to merge with word template. Agency appiontment sent to Incape
forward
global type n_agency_appointment from nonvisualobject
end type
end forward

global type n_agency_appointment from nonvisualobject
end type
global n_agency_appointment n_agency_appointment

forward prototypes
public subroutine of_insert_field (string bookmark, string name, ref oleobject ole_object)
public subroutine of_print_appointment (long al_vessel, string as_voyage, string as_port, long al_pcn)
end prototypes

public subroutine of_insert_field (string bookmark, string name, ref oleobject ole_object);if isnull(name) then return

if (ole_object.activedocument.bookmarks.exists(bookmark)) then
	ole_object.selection.goto(TRUE,0,0, bookmark)
	ole_object.selection.typetext(name)
else
	messagebox("Document Error", "The document do not have the specified field " + char(34) + bookmark + char(34) + " The document will be created without the missing field.",Exclamation!)
end if
end subroutine

public subroutine of_print_appointment (long al_vessel, string as_voyage, string as_port, long al_pcn);SetPointer(Hourglass!)

datetime		ldt_eta, ldt_laycanStart, ldt_laycanEnd, ldt_cpDate
string		ls_profitcenter, ls_portname, ls_operator, ls_cargo, ls_cp
string		ls_previous_port, ls_next_port, ls_timebar, ls_vessel_ref_nr
string		ls_purpose_code, ls_purpose, ls_cargo_product, ls_charterer, ls_cpType
decimal		ld_cargo_qty
string 		ls_brokerName, ls_brokerAddr1, ls_brokerAddr2, ls_brokerAddr3, ls_brokerAddr4, ls_brokerCountry, ls_brokerPhone
OLEObject 	ole_object
boolean		lb_estimatedPort
long			ll_calcID, ll_cpID 
datastore	lds_cargo, lds_broker
long			ll_rows, ll_row

// Open word using OLE
ole_object = CREATE OLEObject

// Connect to word
if (ole_object.connecttonewobject("word.application")) = 0 then
	IF FileExists(uo_global.gs_template_path+"\agencyappointment.dot") THEN
		ole_object.documents.add(uo_global.gs_template_path+"\agencyappointment.dot")
	ELSE
		Messagebox("Wrong File Path in System Options","The file path for MS WORD Templates in 'System Options' the field 'File Path to MS Word templates' is not correct", StopSign!)
		Destroy ole_object
		Return	
	END IF
else
	Messagebox("OLE Error", "Unable to start an OLE server process!", Exclamation!)
	Destroy ole_object
	return
end if

// Profitcenter
SELECT P.PC_NAME, V.VESSEL_REF_NR
	INTO :ls_profitcenter, :ls_vessel_ref_nr
	FROM VESSELS V, PROFIT_C P
	WHERE V.PC_NR = P.PC_NR
	AND V.VESSEL_NR = :al_vessel;
COMMIT;

// Port Name
SELECT PORT_N
	INTO :ls_portname
	FROM PORTS
	WHERE PORT_CODE = :as_port;
COMMIT;

// ETA
SELECT PORT_ARR_DT, PURPOSE_CODE
	INTO :ldt_eta, :ls_purpose_code
	FROM POC_EST
	WHERE VESSEL_NR = :al_vessel
	AND VOYAGE_NR = :as_voyage
	AND PORT_CODE = :as_port
	AND PCN = :al_pcn;
IF sqlca.sqlCode = 0 then 
	lb_estimatedPort = true
	COMMIT;
else
SELECT PORT_ARR_DT, PURPOSE_CODE
		INTO :ldt_eta, :ls_purpose_code
		FROM POC
		WHERE VESSEL_NR = :al_vessel
		AND VOYAGE_NR = :as_voyage
		AND PORT_CODE = :as_port
		AND PCN = :al_pcn;
	if sqlca.sqlcode = 100 then
		setNull(ldt_eta)
		setNull(ls_purpose_code)
		COMMIT;
	end if
end if
COMMIT;

// Laycan
SELECT CAL_CALC_ID 
	INTO :ll_calcID
	FROM VOYAGES
	WHERE VESSEL_NR = :al_vessel
	AND VOYAGE_NR = :as_voyage;
COMMIT;

if ll_calcID > 1 then
	SELECT C1.CAL_CARG_LAYCAN_START,   
      		C1.CAL_CARG_LAYCAN_END  
    		INTO :ldt_laycanStart, 
			 :ldt_laycanEnd   
		FROM CAL_CARG C1
		WHERE C1.CAL_CARG_LAYCAN_START = (SELECT MIN(C2.CAL_CARG_LAYCAN_START)
																FROM CAL_CARG C2
																WHERE C2.CAL_CALC_ID = :ll_calcID 
																AND C2.CAL_CARG_LAYCAN_START IS NOT NULL);
	COMMIT;
else
	setNull(ldt_laycanStart)
	setNull(ldt_laycanEnd)
end if																

// Purpose
if isNull(ls_purpose_code) then
	ls_purpose = "unknown"
else
	SELECT PURPOSE_DESC  
		INTO :ls_purpose
		FROM PURPOSE
		WHERE PURPOSE_CODE = :ls_purpose_code ;
	if sqlca.sqlcode <> 0 then
		ls_purpose = "unknown"
	end if
	COMMIT;	
end if

// Cargo
lds_cargo = create datastore
lds_cargo.dataObject = "d_sq_tb_agency_appointment_cargo"
lds_cargo.setTransObject(sqlca)

if ll_calcID > 1 then
	ll_rows = lds_cargo.retrieve(ll_calcID)
	lds_cargo.setFilter("port_code='"+as_port+"'")
	lds_cargo.filter()
	ll_rows = lds_cargo.rowCount()
	for ll_row = 1 to ll_rows
		if ll_cpid <> lds_cargo.getItemNumber(ll_row, "cerp_id") then
			ll_cpid = lds_cargo.getItemNumber(ll_row, "cerp_id")
			ldt_cpDate = lds_cargo.getItemDatetime(ll_row, "cal_cerp_date")
			choose case lds_cargo.getItemNumber(ll_row, "contract_type")
				case 1
					ls_cpType = "SPOT"
				case 2
					ls_cpType = "COA Fixed rate"
				case 3
					ls_cpType = "CVS Fixed rate"
				case 4
					ls_cpType = "TC in"
				case 5
					ls_cpType = "TC out"
				case 6
					ls_cpType = "BB"
				case 7
					ls_cpType = "COA Market rate"
				case 8
					ls_cpType = "CVS Market rate"
			end  choose 
			
			if len(ls_cp) > 1 then
				ls_cp += ", "
				ls_cargo += ", "
				ls_charterer += ", "
				ls_timebar += ", "
			end if
			ls_cp += string(ldt_cpDate, "dd.mm.yy / ") + ls_cpType + " / [place]"
			ls_cargo += "[please enter product] " +string(abs(lds_cargo.getItemNumber(ll_row, "number_of_units")),"#,##0 ton")
			ls_charterer += lds_cargo.getItemString(ll_row, "chart_n_1")
			ls_timebar += string(lds_cargo.getItemNumber(ll_row, "timebar_days"), "#,##0")
		end if			
	next
else
	ls_cargo = "N/A"
	setNull(ldt_cpDate)
	ls_charterer = "N/A"
	ls_timebar = "N/A"
end if
destroy lds_cargo 

//Previous port
SELECT TOP 1 RTRIM(PORTS.PORT_CODE) + " " +PORTS.PORT_N 
	INTO :ls_previous_port
	FROM POC_EST, PORTS
	WHERE PORTS.PORT_CODE = POC_EST.PORT_CODE
	AND POC_EST.VESSEL_NR = :al_vessel
	AND POC_EST.PORT_ARR_DT < :ldt_eta
	ORDER BY POC_EST.PORT_ARR_DT DESC;
COMMIT;
if len(ls_previous_port) < 4 then
	SELECT  TOP 1 RTRIM(PORTS.PORT_CODE) + " " +PORTS.PORT_N 
		INTO :ls_previous_port
		FROM POC, PORTS
		WHERE PORTS.PORT_CODE = POC.PORT_CODE
		AND POC.VESSEL_NR = :al_vessel
		AND POC.PORT_ARR_DT < :ldt_eta
		ORDER BY POC.PORT_ARR_DT DESC;
	COMMIT;
end if	
if len(ls_previous_port) < 4 then
	ls_previous_port = "unknown"
end if

// Next port
SELECT TOP 1 RTRIM(PORTS.PORT_CODE) + " " +PORTS.PORT_N 
	INTO :ls_next_port
	FROM POC, PORTS
	WHERE PORTS.PORT_CODE = POC.PORT_CODE
	AND POC.VESSEL_NR = :al_vessel
	AND POC.PORT_ARR_DT > :ldt_eta
	ORDER BY POC.PORT_ARR_DT ASC;
COMMIT;
if len(ls_next_port) < 4 then
	SELECT TOP 1 RTRIM(PORTS.PORT_CODE) + " " + PORTS.PORT_N 
		INTO :ls_next_port
		FROM POC_EST, PORTS
		WHERE PORTS.PORT_CODE = POC_EST.PORT_CODE
		AND POC_EST.VESSEL_NR = :al_vessel
		AND POC_EST.PORT_ARR_DT > :ldt_eta
		ORDER BY POC_EST.PORT_ARR_DT ASC;
	COMMIT;
end if	
if len(ls_next_port) < 4 then
	ls_next_port = "unknown"
end if

// Operator
SELECT  ISNULL(FIRST_NAME, " ") + ISNULL(LAST_NAME, " ")
	INTO :ls_operator
	FROM USERS
	WHERE USERID = :uo_global.is_userid;
COMMIT;	

// Broker
lds_broker = create datastore
lds_broker.dataObject = "d_sq_tb_agency_appointment_broker"
lds_broker.setTransObject(sqlca)
ll_rows = lds_broker.retrieve( ll_calcID )

for ll_row = 1 to ll_rows
	ls_brokerName +=  "~t" + lds_broker.getItemString(ll_row, "broker_name")
	ls_brokerAddr1 +=  "~t" + lds_broker.getItemString(ll_row, "broker_a_1")
	ls_brokerAddr2 +=  "~t" + lds_broker.getItemString(ll_row, "broker_a_2")
	ls_brokerAddr3 +=  "~t" + lds_broker.getItemString(ll_row, "broker_a_3")
	ls_brokerAddr4 +=  "~t" + lds_broker.getItemString(ll_row, "broker_a_4")
	ls_brokerCountry +=  "~t" + lds_broker.getItemString(ll_row, "broker_c")
	ls_brokerPhone +=  "~t" + lds_broker.getItemString(ll_row, "broker_ph")
next

destroy lds_broker


of_insert_field("profitcenter", ls_profitcenter +" " , ole_object)
of_insert_field("vessel", ls_vessel_ref_nr, ole_object)
of_insert_field("voyage", as_voyage, ole_object)
of_insert_field("port", as_port+ " "+ls_portname , ole_object)
of_insert_field("pcn", string(al_pcn), ole_object)
if isNull(ldt_eta) then
	of_insert_field("eta", "unknown", ole_object)
else
	of_insert_field("eta", string(ldt_eta, "dd.mm.yy "), ole_object)
end if

if isNull(ldt_laycanStart) then
	of_insert_field("laycan", "unknown", ole_object)
else
	of_insert_field("laycan", string(ldt_laycanStart , "dd.mm.yy") + " - " + string(ldt_laycanEnd , "dd.mm.yy") , ole_object)
end if

of_insert_field("purpose", ls_purpose , ole_object)

choose case ls_purpose_code
	case "L", "D", "L/D"
		// nothing special to do
	case else
		ls_cargo = "N/A"
end choose
of_insert_field("cargo", ls_cargo , ole_object)
of_insert_field("charterer", ls_charterer , ole_object)
of_insert_field("cp", ls_cp , ole_object)
	
of_insert_field("previous_port", ls_previous_port , ole_object)
of_insert_field("next_port", ls_next_port , ole_object)
of_insert_field("timebar", ls_timebar , ole_object)

of_insert_field("operator", ls_operator , ole_object)

of_insert_field("brokername", ls_brokerName , ole_object)
of_insert_field("brokeraddr1", ls_brokerAddr1 , ole_object)
of_insert_field("brokeraddr2", ls_brokerAddr2 , ole_object)
of_insert_field("brokeraddr3", ls_brokerAddr3 , ole_object)
of_insert_field("brokeraddr4", ls_brokerAddr4 , ole_object)
of_insert_field("brokercountry", ls_brokerCountry , ole_object)
of_insert_field("brokerphone", ls_brokerPhone , ole_object)

ole_object.visible = true

Destroy ole_object

Return
end subroutine

on n_agency_appointment.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_agency_appointment.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

