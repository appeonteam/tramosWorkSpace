$PBExportHeader$n_bunker_value_by_date.sru
$PBExportComments$Control object for generating report bunker consumption and stock value pr. given date
forward
global type n_bunker_value_by_date from nonvisualobject
end type
end forward

global type n_bunker_value_by_date from nonvisualobject
end type
global n_bunker_value_by_date n_bunker_value_by_date

type variables
datastore	ids_input, ids_result, ids_sharemember, ids_coda_upload

constant decimal{4} id_tonpermin_max = 0.04
constant decimal{4} id_tonpermin_min = 0.001
constant decimal{4} id_tonpermin_avg = 0.019
end variables

forward prototypes
public function integer of_getinputdata (ref blob ablb_inputds, ref string as_dataobject)
public function integer of_getresultdata (ref blob ablb_resultds, ref string as_dataobject)
public function integer of_calculate (datetime adt_report_date, ref hprogressbar ahpbar)
private function integer of_inport (long al_row, datetime adt_report_date)
private function integer of_atsea (long al_row, datetime adt_report_date)
public function integer of_atsea_samevoyage (long al_row, datetime adt_report_date)
public function integer of_atsea_differentvoyages (long al_row, datetime adt_report_date)
private function integer of_bothportsbefore (long al_row, datetime adt_report_date)
public function integer of_bothportsbefore_samevoyage (long al_row, datetime adt_report_date)
public function integer of_bothportsbefore_differentvoyages (long al_row, datetime adt_report_date)
public function integer of_getsharemember (ref blob ablb_sharememberds, ref string as_dataobject)
public function integer of_generatecodaupload (ref hprogressbar ahpb)
public function integer of_distributesharemember (datetime adt_report_date, ref hprogressbar ahpb)
public subroutine documentation ()
end prototypes

public function integer of_getinputdata (ref blob ablb_inputds, ref string as_dataobject);long ll_rc

ll_rc = ids_input.getfullstate( ablb_inputds )
if ll_rc < 1 then 
	return -1
end if

as_dataobject = ids_input.dataObject

return 1
end function

public function integer of_getresultdata (ref blob ablb_resultds, ref string as_dataobject);long ll_rc

ll_rc = ids_result.getfullstate( ablb_resultds )
if ll_rc < 1 then 
	return -1
end if

as_dataobject = ids_result.dataObject

return 1
end function

public function integer of_calculate (datetime adt_report_date, ref hprogressbar ahpbar);/*	Get calculation data through spored procedure, and calculate consumption and stock
	on basis on one of the scenarious
	
		1) vessel is in port at the given date
		2) vessel is between two ports at the given date
		3) given date is after last POC registred 
*/
long 		ll_rows, ll_row
string		ls_type, ls_sql

ids_result.reset()

ll_rows = ids_input.retrieve(adt_report_date)
commit;

/* This ll_rows statement because of PB giving an error when retrieving
	data through a temporary table in a stored procedure	*/
ll_rows = ids_input.rowCount()
if ll_rows < 1 then
	Messagebox("Information", "No vessel/voyage found for calculation.~r~n~r~n" &
					+ "(Object: n_bunker_value_by_date function: of_calculate())")
	return -1
end if

/* Set header text */
ids_result.Object.t_header.Text = "Bunker Consumption and Stock pr. "+string(adt_report_date, "dd. mmmm-yyyy hh:mm")

ahpbar.maxposition = ll_rows
for ll_row = 1 to ll_rows
//	if ll_row > 20 then    // this is used to stop the calculation
//		MessageBox("", "Husk at fjerne mig")
//		exit
//	end if

	ahpbar.position = ll_row
	
	ls_type = ids_input.getItemString(ll_row, "matchtype")
	choose case lower(ls_type)
		case "in port"
			if of_inport( ll_row, adt_report_date ) = -1 then
				MessageBox("Information", "Not able to calculate values 'in port' for vessel# " &
							+ string(ids_input.getItemNumber(ll_row, "vessel_ref_nr")) + " voyage# " &
							+ ids_input.getItemString(ll_row, "voyage_nr"))
				exit
			end if
		case "1st"
			/* check if there is a next row */
			if  ids_input.getItemString(ll_row +1, "matchtype") = "2nd" &
			and ids_input.getItemNumber(ll_row, "vessel_nr") = ids_input.getItemNumber(ll_row +1, "vessel_nr") then
				if ids_input.getItemDatetime(ll_row +1, "port_arr_dt") < adt_report_date then
					if of_bothportsbefore( ll_row, adt_report_date ) = 1 then
						ll_row ++
					else
						MessageBox("Information", "Not able to calculate values 'both ports before' for vessel# " &
									+ ids_input.getItemString(ll_row, "vessel_ref_nr") + " voyage# " &
									+ ids_input.getItemString(ll_row, "voyage_nr"))
						exit
					end if
				else
					if of_atsea( ll_row, adt_report_date ) = 1 then
						ll_row ++
					else
						MessageBox("Information", "Not able to calculate values 'at sea' for vessel# " &
									+ ids_input.getItemString(ll_row, "vessel_ref_nr") + " voyage# " &
									+ ids_input.getItemString(ll_row, "voyage_nr"))
						exit
					end if
				end if
			else
				MessageBox("Information", "There is a mismatch in input data. There must come a '2nd' row " &
							+ "after '1st' row for vessel# " &
							+ ids_input.getItemString(ll_row, "vessel_ref_nr") + " voyage# " &
							+ ids_input.getItemString(ll_row, "voyage_nr"))
				exit
			end if
		case else
			/* This must be an error as "2nd" row can't come before "1st" row */
			MessageBox("Information", "There is a mismatch in input data. '2nd' row can't come before " &
						+ "'1st' row for vessel# " &
						+ ids_input.getItemString(ll_row, "vessel_ref_nr") + " voyage# " &
						+ ids_input.getItemString(ll_row, "voyage_nr"))
			exit
	end choose
next	

return 1
end function

private function integer of_inport (long al_row, datetime adt_report_date);/* This function calculates the value and ton for each bunker type for
	a given date and where vessel is laying in the port at given date
	
	Calculation is based on following:
		- departure bunker value/ton on previous voyage
		- arrival bunker value current port
		- part of bunker used in current port until given date 
*/	
n_port_arrival_bunker_value 		lnv_arrival
n_port_departure_bunker_value	lnv_departure

integer		li_vessel, li_current_pcn, li_previous_pcn
string		ls_current_voyage, ls_previous_voyage, ls_current_portcode, ls_previous_portcode, ls_vessel_ref_nr, ls_pc_name
decimal{4}	ld_consumption_ton, ld_consumption_value, ld_consumed_atport, ld_defaultport
decimal{4}	ld_current_arrival_ton, ld_current_arrival_value
decimal{4}	ld_current_departure_ton, ld_current_departure_value 
decimal{4}	ld_additional_consumption_ton, ld_additional_consumption_value
decimal{4}	ld_additional_stock_ton, ld_additional_stock_value
decimal{4}	ld_previous_departure_ton, ld_previous_departure_value
decimal{4}	ld_voyage_loaded_ton, ld_voyage_loaded_value   //what is loaded prior to this portcall
decimal{4}	ld_current_port_loaded_ton, ld_current_port_loaded_value   //what is loaded in this portcall
decimal{4}	ld_previous_hfo, ld_previous_do, ld_previous_go, ld_previous_lshfo 
datetime		ldt_current_start, ldt_current_end
long			ll_port_minutes, ll_delta_minutes, ll_result_row
boolean		lb_no_previous_voyage = false

li_vessel 				= ids_input.getItemNumber(al_row, "vessel_nr")
ls_vessel_ref_nr		= ids_input.getItemString(al_row, "vessel_ref_nr")
ls_pc_name =  ids_input.getItemString(al_row, "pc_name")
ls_current_voyage 	= ids_input.getItemString(al_row, "voyage_nr")
ls_current_portcode 	= ids_input.getItemString(al_row, "port_code")
li_current_pcn 		= ids_input.getItemNumber(al_row, "pcn")
ldt_current_start 		= ids_input.getItemDatetime( al_row, "port_arr_dt" )
ldt_current_end 		= ids_input.getItemDatetime( al_row, "port_dept_dt" )

/* Get previous voyage last departure port */
SELECT TOP 1 VOYAGE_NR, PORT_CODE, PCN, ISNULL(DEPT_HFO,0), ISNULL(DEPT_DO,0), ISNULL(DEPT_GO,0), ISNULL(DEPT_LSHFO,0) 
INTO :ls_previous_voyage, :ls_previous_portcode, :li_previous_pcn, :ld_previous_hfo, :ld_previous_do, :ld_previous_go, :ld_previous_lshfo 
	FROM POC
	WHERE VESSEL_NR = :li_vessel
	AND VOYAGE_NR < :ls_current_voyage
	AND PORT_ARR_DT < :ldt_current_start
	ORDER BY PORT_ARR_DT DESC;
if sqlca.sqlcode <> 0 then
	lb_no_previous_voyage = true
end if
commit;

/* Calculate how much to deduct from consumption (from reportDate to DepartureDate) */
ll_port_minutes = (f_datetime2long(ldt_current_end) - f_datetime2long(ldt_current_start) ) / 60
ll_delta_minutes = (f_datetime2long(adt_report_date) - f_datetime2long(ldt_current_start) ) / 60

/* insert row in result */
ll_result_row = ids_result.insertRow(0)
ids_result.setItem(ll_result_row, "vessel", li_vessel)
ids_result.setItem(ll_result_row, "vessel_ref_nr", ls_vessel_ref_nr )
ids_result.setItem(ll_result_row, "pc_name", ls_pc_name )

ids_result.setItem(ll_result_row, "voyage", ls_current_voyage)
ids_result.setItem(ll_result_row, "last_dept_date", ids_input.getItemDatetime( al_row, "last_dept_dt" ))

lnv_arrival = create n_port_arrival_bunker_value 		
lnv_departure = create n_port_departure_bunker_value	

/* Calculate HFO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "HFO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_hfo
end if

/* Get lifted bunker on current voyage, lifted before current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.LIFTED_HFO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND POC.PORT_ARR_DT < :ldt_current_start;
commit;

/* Get lifted bunker current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.LIFTED_HFO),0) 
	INTO :ld_current_port_loaded_value, :ld_current_port_loaded_ton  
	FROM BP_DETAILS   
	WHERE BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND BP_DETAILS.PORT_CODE = :ls_current_portcode
	AND BP_DETAILS.PCN = :li_current_pcn;
commit;

/* Get arrival and departure figures for current port */
lnv_arrival.of_calculate( "HFO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_arrival_value )
ld_current_arrival_ton = ids_input.getItemDecimal(al_row, "arr_hfo")

if ids_input.getItemNumber(al_row, "arr_hfo")<>0 and  ids_input.getItemNumber(al_row, "dept_hfo") = 0  then
	//Which is the consumption at Port for the Vessel?
	SELECT CAL_CONS_FO
	INTO :ld_defaultport
	FROM CAL_CONS
	WHERE CAL_CONS_TYPE = 4 AND VESSEL_NR =:li_vessel ;
	commit;

	if ld_defaultport = 0 then ld_defaultport = 4
	
	ld_consumed_atport = (ll_delta_minutes/60/24) * ld_defaultport
	
	ld_current_departure_ton = ld_current_arrival_ton + ld_current_port_loaded_ton - ld_consumed_atport
	ld_current_departure_value =  ( ld_current_departure_ton - ld_current_port_loaded_ton) * ld_current_arrival_value/ld_current_arrival_ton  + ld_current_port_loaded_value

else
	lnv_departure.of_calculate( "HFO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_departure_value )
	ld_current_departure_ton = ids_input.getItemDecimal(al_row, "dept_hfo")
end if

if ld_current_departure_value = 0 and ld_current_departure_ton = ld_current_arrival_ton then
	ld_current_departure_value = ld_current_arrival_value
end if

/* Consumption addition */
ld_additional_consumption_ton = ((ld_current_arrival_ton - (ld_current_departure_ton - ld_current_port_loaded_ton) ) / ll_port_minutes) * ll_delta_minutes
ld_additional_consumption_value = ((ld_current_arrival_value - (ld_current_departure_value  - ld_current_port_loaded_value) ) / ll_port_minutes) * ll_delta_minutes

ld_consumption_ton = ld_previous_departure_ton + (ld_voyage_loaded_ton - ld_current_arrival_ton) + ld_additional_consumption_ton
ld_consumption_value = ld_previous_departure_value + (ld_voyage_loaded_value - ld_current_arrival_value ) + ld_additional_consumption_value


/* Stock addition */
ld_additional_stock_ton =  ld_current_port_loaded_ton - ld_additional_consumption_ton
ld_additional_stock_value =  ld_current_port_loaded_value  - ld_additional_consumption_value

ids_result.setItem(ll_result_row, "hfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "hfo_stock_ton", ld_current_arrival_ton + ld_additional_stock_ton)
ids_result.setItem(ll_result_row, "hfo_stock_value", ld_current_arrival_value + ld_additional_stock_value )

/* Calculate DO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "DO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_do
end if

/* Get lifted bunker on current voyage, lifted before current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.LIFTED_DO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND POC.PORT_ARR_DT < :ldt_current_start;
commit;

/* Get lifted bunker current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.LIFTED_DO),0) 
	INTO :ld_current_port_loaded_value, :ld_current_port_loaded_ton  
	FROM BP_DETAILS   
	WHERE BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND BP_DETAILS.PORT_CODE = :ls_current_portcode
	AND BP_DETAILS.PCN = :li_current_pcn;
commit;

/* Get arrival and departure figures for current port */
lnv_arrival.of_calculate( "DO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_arrival_value )
ld_current_arrival_ton = ids_input.getItemDecimal(al_row, "arr_do")

if ids_input.getItemNumber(al_row, "arr_do")<>0 and  ids_input.getItemNumber(al_row, "dept_do") = 0  then
	//Which is the consumption at Port for the Vessel?
	ld_defaultport= 0
	SELECT CAL_CONS_DO
	INTO :ld_defaultport
	FROM CAL_CONS
	WHERE CAL_CONS_TYPE = 4 AND VESSEL_NR =:li_vessel ;
	commit;
		
	ld_consumed_atport = (ll_delta_minutes/60/24) * ld_defaultport
	
	ld_current_departure_ton = ld_current_arrival_ton + ld_current_port_loaded_ton - ld_consumed_atport
	ld_current_departure_value =  ( ld_current_departure_ton - ld_current_port_loaded_ton) * ld_current_arrival_value/ld_current_arrival_ton  + ld_current_port_loaded_value

else
	lnv_departure.of_calculate( "DO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_departure_value )
	ld_current_departure_ton = ids_input.getItemDecimal(al_row, "dept_do")
end if


if ld_current_departure_value = 0 and ld_current_departure_ton = ld_current_arrival_ton then
	ld_current_departure_value = ld_current_arrival_value
end if

/* Consumption addition */
ld_additional_consumption_ton = ((ld_current_arrival_ton - (ld_current_departure_ton - ld_current_port_loaded_ton) ) / ll_port_minutes) * ll_delta_minutes
ld_additional_consumption_value = ((ld_current_arrival_value - (ld_current_departure_value  - ld_current_port_loaded_value) ) / ll_port_minutes) * ll_delta_minutes

ld_consumption_ton = ld_previous_departure_ton + (ld_voyage_loaded_ton - ld_current_arrival_ton) + ld_additional_consumption_ton
ld_consumption_value = ld_previous_departure_value + (ld_voyage_loaded_value - ld_current_arrival_value ) + ld_additional_consumption_value

/* Stock addition */
ld_additional_stock_ton =ld_current_port_loaded_ton - ld_additional_consumption_ton
ld_additional_stock_value = ld_current_port_loaded_value  - ld_additional_consumption_value

ids_result.setItem(ll_result_row, "do_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "do_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "do_stock_ton", ld_current_arrival_ton + ld_additional_stock_ton)
ids_result.setItem(ll_result_row, "do_stock_value", ld_current_arrival_value + ld_additional_stock_value )

/* Calculate GO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "GO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_go
end if

/* Get lifted bunker on current voyage, lifted before current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.LIFTED_GO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND POC.PORT_ARR_DT < :ldt_current_start;
commit;

/* Get lifted bunker current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.LIFTED_GO),0) 
	INTO :ld_current_port_loaded_value, :ld_current_port_loaded_ton  
	FROM BP_DETAILS   
	WHERE BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND BP_DETAILS.PORT_CODE = :ls_current_portcode
	AND BP_DETAILS.PCN = :li_current_pcn;
commit;

/* Get arrival and departure figures for current port */
lnv_arrival.of_calculate( "GO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_arrival_value )
ld_current_arrival_ton = ids_input.getItemDecimal(al_row, "arr_go")


if ids_input.getItemNumber(al_row, "arr_go")<>0 and  ids_input.getItemNumber(al_row, "dept_go") = 0  then
	//Which is the consumption at Port for the Vessel?
	ld_defaultport=0
	SELECT CAL_CONS_MGO
	INTO :ld_defaultport
	FROM CAL_CONS
	WHERE CAL_CONS_TYPE = 4 AND VESSEL_NR =:li_vessel ;
	commit;

	ld_consumed_atport = (ll_delta_minutes/60/24) * ld_defaultport
	
	ld_current_departure_ton = ld_current_arrival_ton + ld_current_port_loaded_ton - ld_consumed_atport
	ld_current_departure_value =  ( ld_current_departure_ton - ld_current_port_loaded_ton) * ld_current_arrival_value/ld_current_arrival_ton  + ld_current_port_loaded_value
	
else
	lnv_departure.of_calculate( "GO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_departure_value )
	ld_current_departure_ton = ids_input.getItemDecimal(al_row, "dept_go")
end if


if ld_current_departure_value = 0 and ld_current_departure_ton = ld_current_arrival_ton then
	ld_current_departure_value = ld_current_arrival_value
end if

/* Consumption addition */
ld_additional_consumption_ton = ((ld_current_arrival_ton - (ld_current_departure_ton - ld_current_port_loaded_ton) ) / ll_port_minutes) * ll_delta_minutes
ld_additional_consumption_value = ((ld_current_arrival_value - (ld_current_departure_value  - ld_current_port_loaded_value) ) / ll_port_minutes) * ll_delta_minutes

ld_consumption_ton = ld_previous_departure_ton + (ld_voyage_loaded_ton - ld_current_arrival_ton) + ld_additional_consumption_ton
ld_consumption_value = ld_previous_departure_value + (ld_voyage_loaded_value - ld_current_arrival_value ) + ld_additional_consumption_value

/* Stock addition */
ld_additional_stock_ton =ld_current_port_loaded_ton - ld_additional_consumption_ton
ld_additional_stock_value = ld_current_port_loaded_value  - ld_additional_consumption_value

ids_result.setItem(ll_result_row, "go_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "go_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "go_stock_ton", ld_current_arrival_ton + ld_additional_stock_ton)
ids_result.setItem(ll_result_row, "go_stock_value", ld_current_arrival_value + ld_additional_stock_value )

/* Calculate LSHFO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "LSHFO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_lshfo
end if

/* Get lifted bunker on current voyage, lifted before current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.LIFTED_LSHFO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND POC.PORT_ARR_DT < :ldt_current_start;
commit;

/* Get lifted bunker current port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.LIFTED_LSHFO),0) 
	INTO :ld_current_port_loaded_value, :ld_current_port_loaded_ton  
	FROM BP_DETAILS   
	WHERE BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_current_voyage
	AND BP_DETAILS.PORT_CODE = :ls_current_portcode
	AND BP_DETAILS.PCN = :li_current_pcn;
commit;

/* Get arrival and departure figures for current port */
lnv_arrival.of_calculate( "LSHFO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_arrival_value )
ld_current_arrival_ton = ids_input.getItemDecimal(al_row, "arr_lshfo")

if ids_input.getItemNumber(al_row, "arr_lshfo")<>0 and  ids_input.getItemNumber(al_row, "dept_lshfo") = 0  then
	
	ld_current_departure_ton = ld_current_arrival_ton
	ld_current_departure_value = ld_current_arrival_value

else
	lnv_departure.of_calculate( "LSHFO", li_vessel , ls_current_voyage , ls_current_portcode , li_current_pcn , ld_current_departure_value )
	ld_current_departure_ton = ids_input.getItemDecimal(al_row, "dept_lshfo")
end if

if ld_current_departure_value = 0 and ld_current_departure_ton = ld_current_arrival_ton then
	ld_current_departure_value = ld_current_arrival_value
end if

/* Consumption addition */
ld_additional_consumption_ton = ((ld_current_arrival_ton - (ld_current_departure_ton - ld_current_port_loaded_ton) ) / ll_port_minutes) * ll_delta_minutes
ld_additional_consumption_value = ((ld_current_arrival_value - (ld_current_departure_value  - ld_current_port_loaded_value) ) / ll_port_minutes) * ll_delta_minutes

ld_consumption_ton = ld_previous_departure_ton + (ld_voyage_loaded_ton - ld_current_arrival_ton) + ld_additional_consumption_ton
ld_consumption_value = ld_previous_departure_value + (ld_voyage_loaded_value - ld_current_arrival_value ) + ld_additional_consumption_value

/* Stock addition */
ld_additional_stock_ton =ld_current_port_loaded_ton - ld_additional_consumption_ton
ld_additional_stock_value = ld_current_port_loaded_value  - ld_additional_consumption_value

ids_result.setItem(ll_result_row, "lshfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "lshfo_stock_ton", ld_current_arrival_ton + ld_additional_stock_ton)
ids_result.setItem(ll_result_row, "lshfo_stock_value", ld_current_arrival_value + ld_additional_stock_value )

destroy lnv_arrival
destroy lnv_departure

return 1
end function

private function integer of_atsea (long al_row, datetime adt_report_date);string			ls_first_voyage, ls_next_voyage

ls_first_voyage = ids_input.getItemString(al_row, "voyage_nr")
ls_next_voyage = ids_input.getItemString(al_row +1, "voyage_nr")

choose case ls_first_voyage = ls_next_voyage
	case true
		/* Both portcalls in same voyage */
		if of_atsea_samevoyage( al_row, adt_report_date ) = -1 then
			return -1
		end if
	case else
		/* Portcalls on defferent voyages */
		if of_atsea_differentvoyages( al_row, adt_report_date ) = -1 then
			return -1
		end if
end choose

return 1
end function

public function integer of_atsea_samevoyage (long al_row, datetime adt_report_date);/* This function calculates the value and ton for each bunker type for
	a given date and where vessel is at sea at given date, and
	where both port calls (before and after date) are on same
	voyage
	
	Calculation is based on following:
		- departure bunker value/ton on previous voyage
		- departure bunker value at port before date
		- part of bunker used from that port and until arrival in next port 
*/	
n_port_arrival_bunker_value 		lnv_arrival
n_port_departure_bunker_value	lnv_departure

integer		li_vessel, li_first_pcn, li_next_pcn, li_previous_pcn
string		ls_voyage, ls_previous_voyage, ls_vessel_ref_nr, ls_msg, ls_pc_name
string		ls_first_portcode, ls_next_portcode, ls_previous_portcode
decimal{4}	ld_consumption_ton, ld_consumption_value, ld_ton_per_minute
decimal{4}	ld_previous_departure_ton, ld_previous_departure_value
decimal{4}	ld_first_departure_ton, ld_first_departure_value 
decimal{4}	ld_next_arrival_ton, ld_next_arrival_value
decimal{4}	ld_additional_consumption_ton, ld_additional_consumption_value
decimal{4}	ld_additional_stock_ton, ld_additional_stock_value
decimal{4}	ld_voyage_loaded_ton, ld_voyage_loaded_value   //what is loaded prior to this portcall
decimal{4}	ld_previous_hfo, ld_previous_do, ld_previous_go, ld_previous_lshfo 
datetime		ldt_first_start, ldt_first_end,  ldt_next_start,  ldt_next_end
long			ll_atsea_minutes, ll_delta_minutes, ll_result_row
boolean		lb_no_previous_voyage = false

li_vessel 				= ids_input.getItemNumber(al_row, "vessel_nr")
ls_vessel_ref_nr 		= ids_input.getItemString(al_row, "vessel_ref_nr")
ls_pc_name = ids_input.getItemString(al_row, "pc_name")
ls_voyage 				= ids_input.getItemString(al_row, "voyage_nr")
ls_first_portcode 	= ids_input.getItemString(al_row, "port_code")
ls_next_portcode 		= ids_input.getItemString(al_row +1, "port_code")
li_first_pcn 			= ids_input.getItemNumber(al_row, "pcn")
li_next_pcn 			= ids_input.getItemNumber(al_row +1, "pcn")
ldt_first_start 		= ids_input.getItemDatetime( al_row, "port_arr_dt" )
ldt_next_start 		= ids_input.getItemDatetime( al_row +1, "port_arr_dt" )
ldt_first_end 			= ids_input.getItemDatetime( al_row, "port_dept_dt" )
ldt_next_end 			= ids_input.getItemDatetime( al_row +1, "port_dept_dt" )

/* Get previous voyage last departure port */
SELECT TOP 1 VOYAGE_NR, PORT_CODE, PCN, ISNULL(DEPT_HFO,0), ISNULL(DEPT_DO,0), ISNULL(DEPT_GO,0), ISNULL(DEPT_LSHFO,0) 
INTO :ls_previous_voyage, :ls_previous_portcode, :li_previous_pcn, :ld_previous_hfo, :ld_previous_do, :ld_previous_go, :ld_previous_lshfo 
	FROM POC
	WHERE VESSEL_NR = :li_vessel
	AND VOYAGE_NR < :ls_voyage
	AND PORT_ARR_DT < :ldt_first_start
	ORDER BY PORT_ARR_DT DESC;
if sqlca.sqlcode <> 0 then
	lb_no_previous_voyage = true
end if
commit;

/* Calculate how much to deduct from consumption (from reportDate to DepartureDate) */
ll_atsea_minutes = (f_datetime2long(ldt_next_start) - f_datetime2long(ldt_first_end) ) / 60
ll_delta_minutes = (f_datetime2long(adt_report_date) - f_datetime2long(ldt_first_end) ) / 60

/* insert row in result */
ll_result_row = ids_result.insertRow(0)
ids_result.setItem(ll_result_row, "vessel", li_vessel)
ids_result.setItem(ll_result_row, "vessel_ref_nr", ls_vessel_ref_nr )
ids_result.setItem(ll_result_row, "pc_name", ls_pc_name )
ids_result.setItem(ll_result_row, "voyage", ls_voyage)
ids_result.setItem(ll_result_row, "last_dept_date", ids_input.getItemDatetime( al_row, "last_dept_dt" ))

lnv_arrival = create n_port_arrival_bunker_value 		
lnv_departure = create n_port_departure_bunker_value	

/* Calculate HFO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "HFO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_hfo
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.LIFTED_HFO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT < :ldt_next_start;
commit;

/* Get departure figures for first port */
lnv_departure.of_calculate( "HFO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_hfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "HFO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_hfo")

if ld_next_arrival_ton = 0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_additional_consumption_ton =0
	ld_additional_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute =  id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute< id_tonpermin_min then 
			ls_msg=ls_msg + "hfo " 
			ld_ton_per_minute =  id_tonpermin_avg
		end if
	end if
	
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg
	
	/* Consumption */
	ld_additional_consumption_ton =ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_first_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value +ld_voyage_loaded_value - ld_first_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "hfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "hfo_stock_ton", ld_first_departure_ton - ld_additional_consumption_ton)
ids_result.setItem(ll_result_row, "hfo_stock_value", ld_first_departure_value - ld_additional_consumption_value )


/* Calculate DO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "DO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_do
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.LIFTED_DO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT < :ldt_next_start;
commit;

/* Get departure figures for first port */
lnv_departure.of_calculate( "DO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_do")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "DO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_do")

if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_additional_consumption_ton =0
	ld_additional_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	/* Consumption */
	ld_additional_consumption_ton =ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_first_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value +ld_voyage_loaded_value - ld_first_departure_value + ld_additional_consumption_value	
end if

ids_result.setItem(ll_result_row, "do_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "do_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "do_stock_ton", ld_first_departure_ton - ld_additional_consumption_ton)
ids_result.setItem(ll_result_row, "do_stock_value", ld_first_departure_value - ld_additional_consumption_value )


/* Calculate GO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "GO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_go
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.LIFTED_GO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT < :ldt_next_start;
commit;

/* Get departure figures for first port */
lnv_departure.of_calculate( "GO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_go")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "GO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_go")

if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_additional_consumption_ton =0
	ld_additional_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_first_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value +ld_voyage_loaded_value - ld_first_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "go_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "go_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "go_stock_ton", ld_first_departure_ton - ld_additional_consumption_ton)
ids_result.setItem(ll_result_row, "go_stock_value", ld_first_departure_value - ld_additional_consumption_value )


/* Calculate LSHFO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "LSHFO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_lshfo
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.LIFTED_LSHFO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT < :ldt_next_start;
commit;

/* Get departure figures for first port */
lnv_departure.of_calculate( "LSHFO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_lshfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "LSHFO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_lshfo")
if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_additional_consumption_ton =0
	ld_additional_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<id_tonpermin_min then 
			ls_msg=ls_msg + "lsfo " 
			ld_ton_per_minute = id_tonpermin_avg
		end if
	end if
	
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg
	
	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_first_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value +ld_voyage_loaded_value - ld_first_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "lshfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "lshfo_stock_ton", ld_first_departure_ton - ld_additional_consumption_ton)
ids_result.setItem(ll_result_row, "lshfo_stock_value", ld_first_departure_value - ld_additional_consumption_value )

//Display alert messages in the report
//if ls_msg<>"" then
	//ids_result.setItem(ll_result_row, "error_message","2) " + ls_msg )
//end if

destroy lnv_arrival
destroy lnv_departure

return 1
end function

public function integer of_atsea_differentvoyages (long al_row, datetime adt_report_date);/* This function calculates the value and ton for each bunker type for
	a given date and where vessel is at sea at given date, and
	where the port calls (before and after date) are on different
	voyages
	
	Calculation is based on following:
		- first voyage departure is equal voyage start
		- consumption and stock is equal to the part of bunker used from 
		   the first port departure and to given date 
*/	
n_port_arrival_bunker_value 		lnv_arrival
n_port_departure_bunker_value	lnv_departure

integer		li_vessel, li_first_pcn, li_next_pcn, li_previous_pcn
string		ls_first_voyage, ls_next_voyage, ls_vessel_ref_nr, ls_msg, ls_pc_name
string		ls_first_portcode, ls_next_portcode, ls_previous_portcode
decimal{4}	ld_consumption_ton, ld_consumption_value
decimal{4}	ld_first_departure_ton, ld_first_departure_value 
decimal{4}	ld_next_arrival_ton, ld_next_arrival_value, ld_ton_per_minute
datetime		ldt_first_start, ldt_first_end,  ldt_next_start,  ldt_next_end
long			ll_atsea_minutes, ll_delta_minutes, ll_result_row

li_vessel 				= ids_input.getItemNumber(al_row, "vessel_nr")
ls_vessel_ref_nr		= ids_input.getItemString(al_row, "vessel_ref_nr")
ls_pc_name = ids_input.getItemString(al_row, "pc_name")
ls_first_voyage 		= ids_input.getItemString(al_row, "voyage_nr")
ls_next_voyage 		= ids_input.getItemString(al_row +1, "voyage_nr")
ls_first_portcode 	= ids_input.getItemString(al_row, "port_code")
ls_next_portcode 		= ids_input.getItemString(al_row +1, "port_code")
li_first_pcn 			= ids_input.getItemNumber(al_row, "pcn")
li_next_pcn 			= ids_input.getItemNumber(al_row +1, "pcn")
ldt_first_start 		= ids_input.getItemDatetime( al_row, "port_arr_dt" )
ldt_next_start 		= ids_input.getItemDatetime( al_row +1, "port_arr_dt" )
ldt_first_end 			= ids_input.getItemDatetime( al_row, "port_dept_dt" )
ldt_next_end 			= ids_input.getItemDatetime( al_row +1, "port_dept_dt" )

/* Calculate how much to added to consumption (from DepartureDate to reportDate) */
ll_atsea_minutes = (f_datetime2long(ldt_next_start) - f_datetime2long(ldt_first_end) ) / 60
ll_delta_minutes = (f_datetime2long(adt_report_date) - f_datetime2long(ldt_first_end) ) / 60

/* insert row in result */
ll_result_row = ids_result.insertRow(0)
ids_result.setItem(ll_result_row, "vessel", li_vessel)
ids_result.setItem(ll_result_row, "vessel_ref_nr", ls_vessel_ref_nr)
ids_result.setItem(ll_result_row, "pc_name", ls_pc_name)
ids_result.setItem(ll_result_row, "voyage", ls_next_voyage)
ids_result.setItem(ll_result_row, "last_dept_date", ids_input.getItemDatetime( al_row, "last_dept_dt" ))

lnv_arrival = create n_port_arrival_bunker_value 		
lnv_departure = create n_port_departure_bunker_value	

/* Calculate HFO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "HFO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_hfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "HFO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_hfo")

if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<id_tonpermin_min then 
			ls_msg=ls_msg + "hfo " 
			ld_ton_per_minute =id_tonpermin_avg
		end if
	end if
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg

	/* Consumption */
	ld_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
end if

ids_result.setItem(ll_result_row, "hfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "hfo_stock_ton", ld_first_departure_ton - ld_consumption_ton)
ids_result.setItem(ll_result_row, "hfo_stock_value", ld_first_departure_value - ld_consumption_value )


/* Calculate DO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "DO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_do")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "DO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_do")

if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
		
	/* Consumption */
	ld_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
end if

ids_result.setItem(ll_result_row, "do_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "do_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "do_stock_ton", ld_first_departure_ton - ld_consumption_ton)
ids_result.setItem(ll_result_row, "do_stock_value", ld_first_departure_value - ld_consumption_value )


/* Calculate GO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "GO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_go")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "GO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_go")

if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
		
	/* Consumption */
	ld_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
end if

ids_result.setItem(ll_result_row, "go_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "go_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "go_stock_ton", ld_first_departure_ton - ld_consumption_ton)
ids_result.setItem(ll_result_row, "go_stock_value", ld_first_departure_value - ld_consumption_value )

/* Calculate LSHFO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "LSHFO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_lshfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "LSHFO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_lshfo")

if ld_next_arrival_ton =0  then
	ld_consumption_ton =0
	ld_consumption_value  =0
	ld_first_departure_ton =0
	ld_first_departure_value  =0
else
		
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<id_tonpermin_min then 
			ls_msg=ls_msg + "lsfo " 
			ld_ton_per_minute = id_tonpermin_avg
		end if
	end if
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg
		
	/* Consumption */
	ld_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_consumption_value = ((ld_first_departure_value - ld_next_arrival_value)/ ll_atsea_minutes) * ll_delta_minutes
end if

ids_result.setItem(ll_result_row, "lshfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "lshfo_stock_ton", ld_first_departure_ton - ld_consumption_ton)
ids_result.setItem(ll_result_row, "lshfo_stock_value", ld_first_departure_value - ld_consumption_value )

//Display alert messages in the report
//if ls_msg<>"" then
	//ids_result.setItem(ll_result_row, "error_message","1) " + ls_msg )
//end if

destroy lnv_arrival
destroy lnv_departure

return 1
end function

private function integer of_bothportsbefore (long al_row, datetime adt_report_date);string			ls_first_voyage, ls_next_voyage

ls_first_voyage = ids_input.getItemString(al_row, "voyage_nr")
ls_next_voyage = ids_input.getItemString(al_row +1, "voyage_nr")

choose case ls_first_voyage = ls_next_voyage
	case true
		/* Both portcalls in same voyage */
		if of_bothportsbefore_samevoyage( al_row, adt_report_date ) = -1 then
			return -1
		end if
	case else
		/* Portcalls on different voyages */
		if of_bothportsbefore_differentvoyages( al_row, adt_report_date ) = -1 then
			return -1
		end if
end choose

return 1
end function

public function integer of_bothportsbefore_samevoyage (long al_row, datetime adt_report_date);/* This function calculates the value and ton for each bunker type for
	a given date and where vessel is at sea at given date, and
	where both port calls are before given date, and voyage
	numbers are equal
	
	Calculation is based on following:
		- consumption between the two last ports	
		- use price from last known stock when extrapolate
		- departure bunker value/ton on 2nd portcall
*/	
n_port_arrival_bunker_value 		lnv_arrival
n_port_departure_bunker_value	lnv_departure
string	ls_msg

integer		li_vessel, li_first_pcn, li_next_pcn, li_previous_pcn
string		ls_voyage, ls_previous_voyage, ls_vessel_ref_nr, ls_pc_name
string		ls_first_portcode, ls_next_portcode, ls_previous_portcode
decimal{4}	ld_consumption_ton, ld_consumption_value
decimal{4}	ld_additional_consumption_ton, ld_additional_consumption_value
decimal{4}	ld_ton_per_minute, ld_price_per_ton
decimal{4}	ld_first_departure_ton, ld_first_departure_value 
decimal{4}	ld_next_departure_ton, ld_next_departure_value 
decimal{4}	ld_previous_departure_ton, ld_previous_departure_value 
decimal{4}	ld_next_arrival_ton, ld_next_arrival_value
decimal{4}	ld_voyage_loaded_value, ld_voyage_loaded_ton  
decimal{4}	ld_previous_hfo, ld_previous_do, ld_previous_go, ld_previous_lshfo  
decimal{4}	ld_voyage_loaded_value_est, ld_voyage_loaded_ton_est

datetime		ldt_first_start, ldt_first_end,  ldt_next_start,  ldt_next_end
long			ll_atsea_minutes, ll_delta_minutes, ll_result_row
boolean		lb_no_previous_voyage

li_vessel 				= ids_input.getItemNumber(al_row, "vessel_nr")
ls_vessel_ref_nr 		= ids_input.getItemString(al_row, "vessel_ref_nr")
ls_pc_name = ids_input.getItemString(al_row, "pc_name")
ls_voyage 				= ids_input.getItemString(al_row, "voyage_nr")
ls_first_portcode 	= ids_input.getItemString(al_row, "port_code")
ls_next_portcode 		= ids_input.getItemString(al_row +1, "port_code")
li_first_pcn 			= ids_input.getItemNumber(al_row, "pcn")
li_next_pcn 			= ids_input.getItemNumber(al_row +1, "pcn")
ldt_first_start 		= ids_input.getItemDatetime( al_row, "port_arr_dt" )
ldt_next_start 		= ids_input.getItemDatetime( al_row +1, "port_arr_dt" )
ldt_first_end 			= ids_input.getItemDatetime( al_row, "port_dept_dt" )
ldt_next_end 			= ids_input.getItemDatetime( al_row +1, "port_dept_dt" )

/* Get previous voyage last departure port */
SELECT TOP 1 VOYAGE_NR, PORT_CODE, PCN, ISNULL(DEPT_HFO,0), ISNULL(DEPT_DO,0), ISNULL(DEPT_GO,0), ISNULL(DEPT_LSHFO,0) 
INTO :ls_previous_voyage, :ls_previous_portcode, :li_previous_pcn, :ld_previous_hfo, :ld_previous_do, :ld_previous_go, :ld_previous_lshfo 
	FROM POC
	WHERE VESSEL_NR = :li_vessel
	AND VOYAGE_NR < :ls_voyage
	AND PORT_ARR_DT < :ldt_first_start
	ORDER BY PORT_ARR_DT DESC;
if sqlca.sqlcode <> 0 then
	lb_no_previous_voyage = true
end if
commit;

/* Calculate how much to added to consumption (from DepartureDate to reportDate) */
ll_atsea_minutes = (f_datetime2long(ldt_next_start) - f_datetime2long(ldt_first_end) ) / 60
ll_delta_minutes = (f_datetime2long(adt_report_date) - f_datetime2long(ldt_next_end) ) / 60

/* insert row in result */
ll_result_row = ids_result.insertRow(0)
ids_result.setItem(ll_result_row, "vessel", li_vessel)
ids_result.setItem(ll_result_row, "vessel_ref_nr", ls_vessel_ref_nr)
ids_result.setItem(ll_result_row, "pc_name", ls_pc_name)
ids_result.setItem(ll_result_row, "voyage", ls_voyage)
ids_result.setItem(ll_result_row, "last_dept_date", ids_input.getItemDatetime( al_row, "last_dept_dt" ))

if isnull(ll_atsea_minutes) then ll_atsea_minutes = 0

lnv_arrival = create n_port_arrival_bunker_value 		
lnv_departure = create n_port_departure_bunker_value	

/* Calculate HFO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "HFO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_hfo
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.LIFTED_HFO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT <= :adt_report_date;
commit;


//	Read from Estimated
SELECT isnull(SUM(BP_DETAILS.ORDERED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.ORDERED_HFO),0) 
	INTO :ld_voyage_loaded_value_est, :ld_voyage_loaded_ton_est
	FROM BP_DETAILS,   
		POC_EST
	WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
	AND BP_DETAILS.PCN = POC_EST.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND POC_EST.PORT_ARR_DT >= :ldt_next_start
	AND POC_EST.PORT_ARR_DT <= :adt_report_date;
commit;

ld_voyage_loaded_value = ld_voyage_loaded_value + ld_voyage_loaded_value_est
ld_voyage_loaded_ton = ld_voyage_loaded_ton + ld_voyage_loaded_ton_est

/* Get departure figures for first port */
lnv_departure.of_calculate( "HFO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_hfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "HFO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_hfo")

/* Get departure figures for next port */
lnv_departure.of_calculate( "HFO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_hfo")

if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
else

	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute =id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<id_tonpermin_min then 
			ls_msg=ls_msg + "hfo " 
			ld_ton_per_minute =id_tonpermin_avg
		end if
	end if
	
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg	
		
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if
	
	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_next_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value + ld_voyage_loaded_value - ld_next_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "hfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "hfo_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_stock_value", ld_next_departure_value - ld_additional_consumption_value )



/* Calculate DO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "DO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_do
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.LIFTED_DO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT <= :adt_report_date;
commit;


//	Read from Estimated

SELECT isnull(SUM(BP_DETAILS.ORDERED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.ORDERED_DO),0) 
	INTO :ld_voyage_loaded_value_est, :ld_voyage_loaded_ton_est
	FROM BP_DETAILS,   
		POC_EST
	WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
	AND BP_DETAILS.PCN = POC_EST.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND POC_EST.PORT_ARR_DT >= :ldt_next_start
	AND POC_EST.PORT_ARR_DT <= :adt_report_date;
commit;

ld_voyage_loaded_value = ld_voyage_loaded_value + ld_voyage_loaded_value_est
ld_voyage_loaded_ton = ld_voyage_loaded_ton + ld_voyage_loaded_ton_est

/* Get departure figures for first port */
lnv_departure.of_calculate( "DO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_do")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "DO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_do")

/* Get departure figures for next port */
lnv_departure.of_calculate( "DO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_do")

//ld_next_departure_ton=0 and ld_first_departure_ton=0
if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
	
else
	
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if

	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_next_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value + ld_voyage_loaded_value - ld_next_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "do_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "do_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "do_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "do_stock_value", ld_next_departure_value - ld_additional_consumption_value )


/* Calculate GO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "GO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_go
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.LIFTED_GO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT <= :adt_report_date;
commit;

//	Read from Estimated
SELECT isnull(SUM(BP_DETAILS.ORDERED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.ORDERED_GO),0) 
	INTO :ld_voyage_loaded_value_est, :ld_voyage_loaded_ton_est
	FROM BP_DETAILS,   
		POC_EST
	WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
	AND BP_DETAILS.PCN = POC_EST.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND POC_EST.PORT_ARR_DT >= :ldt_next_start
	AND POC_EST.PORT_ARR_DT <= :adt_report_date;
commit;

ld_voyage_loaded_value = ld_voyage_loaded_value + ld_voyage_loaded_value_est
ld_voyage_loaded_ton = ld_voyage_loaded_ton + ld_voyage_loaded_ton_est

/* Get departure figures for first port */
lnv_departure.of_calculate( "GO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_go")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "GO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_go")

/* Get departure figures for next port */
lnv_departure.of_calculate( "GO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_go")

if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
	
else
	
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if

	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_next_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value + ld_voyage_loaded_value - ld_next_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "go_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "go_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "go_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "go_stock_value", ld_next_departure_value - ld_additional_consumption_value )

/* Calculate LSHFO  ************************************** */
/* Departure ton and value previous voyage */
if lb_no_previous_voyage then
	ld_previous_departure_ton = 0
	ld_previous_departure_value = 0
else
	lnv_departure.of_calculate( "LSHFO", li_vessel , ls_previous_voyage , ls_previous_portcode , li_previous_pcn , ld_previous_departure_value )
	ld_previous_departure_ton = ld_previous_lshfo
end if

/* Get lifted bunker on current voyage, lifted before next port */
SELECT isnull(SUM(BP_DETAILS.LIFTED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.LIFTED_LSHFO),0) 
	INTO :ld_voyage_loaded_value, :ld_voyage_loaded_ton  
	FROM BP_DETAILS,   
		POC  
	WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
	AND BP_DETAILS.PCN = POC.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND BP_DETAILS.VOYAGE_NR = :ls_voyage
	AND POC.PORT_ARR_DT <= :adt_report_date;
commit;

//	Read from Estimated

SELECT isnull(SUM(BP_DETAILS.ORDERED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.ORDERED_LSHFO),0) 
	INTO :ld_voyage_loaded_value_est, :ld_voyage_loaded_ton_est
	FROM BP_DETAILS,   
		POC_EST
	WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
	AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
	AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
	AND BP_DETAILS.PCN = POC_EST.PCN	
	AND BP_DETAILS.VESSEL_NR = :li_vessel
	AND POC_EST.PORT_ARR_DT >= :ldt_next_start
	AND POC_EST.PORT_ARR_DT <= :adt_report_date;
commit;

ld_voyage_loaded_value = ld_voyage_loaded_value + ld_voyage_loaded_value_est
ld_voyage_loaded_ton = ld_voyage_loaded_ton + ld_voyage_loaded_ton_est

/* Get departure figures for first port */
lnv_departure.of_calculate( "LSHFO", li_vessel , ls_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_lshfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "LSHFO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_lshfo")

/* Get departure figures for next port */
lnv_departure.of_calculate( "LSHFO", li_vessel , ls_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_lshfo")

if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
	
else
	
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<id_tonpermin_min then 
			ls_msg=ls_msg + "lshfo " 
			ld_ton_per_minute =id_tonpermin_avg
		end if
	end if

	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg	
			
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if

	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = ld_previous_departure_ton + ld_voyage_loaded_ton - ld_next_departure_ton + ld_additional_consumption_ton
	ld_consumption_value = ld_previous_departure_value + ld_voyage_loaded_value - ld_next_departure_value + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "lshfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "lshfo_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_stock_value", ld_next_departure_value - ld_additional_consumption_value )

//Display alert messages in the report
//if ls_msg<>"" then
//	ids_result.setItem(ll_result_row, "error_message","4) " + ls_msg )
//end if

destroy lnv_arrival
destroy lnv_departure

return 1
end function

public function integer of_bothportsbefore_differentvoyages (long al_row, datetime adt_report_date);/* This function calculates the value and ton for each bunker type for
	a given date and where vessel is at sea at given date, and
	where both port calls are before given date, and where voyage
	numbers are different
	
	Calculation is based on following:
		- consumption between the two last ports	
		- use price from last known stock when extrapolate
		- departure bunker value/ton on 2nd portcall
*/	
n_port_arrival_bunker_value 		lnv_arrival
n_port_departure_bunker_value	lnv_departure
string	ls_msg

integer		li_vessel, li_first_pcn, li_next_pcn, li_previous_pcn
string		ls_first_voyage, ls_next_voyage, ls_vessel_ref_nr, ls_pc_name
string		ls_first_portcode, ls_next_portcode, ls_previous_portcode
decimal{4}	ld_consumption_ton, ld_consumption_value
decimal{4}	ld_additional_consumption_ton, ld_additional_consumption_value
decimal{4}	ld_ton_per_minute, ld_price_per_ton
decimal{4}	ld_first_departure_ton, ld_first_departure_value 
decimal{4}	ld_next_departure_ton, ld_next_departure_value 
decimal{4}	ld_next_arrival_ton, ld_next_arrival_value
decimal{4}	ld_next_loaded_ton, ld_next_loaded_value

decimal{4}	ld_next_loaded_value_est, ld_next_loaded_ton_est

datetime		ldt_first_start, ldt_first_end,  ldt_next_start,  ldt_next_end
long			ll_atsea_minutes, ll_delta_minutes, ll_result_row

li_vessel 				= ids_input.getItemNumber(al_row, "vessel_nr")
ls_vessel_ref_nr 		= ids_input.getItemString(al_row, "vessel_ref_nr")
ls_pc_name = ids_input.getItemString(al_row, "pc_name")
ls_first_voyage 		= ids_input.getItemString(al_row, "voyage_nr")
ls_next_voyage 		= ids_input.getItemString(al_row +1, "voyage_nr")
ls_first_portcode 	= ids_input.getItemString(al_row, "port_code")
ls_next_portcode 		= ids_input.getItemString(al_row +1, "port_code")
li_first_pcn 			= ids_input.getItemNumber(al_row, "pcn")
li_next_pcn 			= ids_input.getItemNumber(al_row +1, "pcn")
ldt_first_start 		= ids_input.getItemDatetime( al_row, "port_arr_dt" )
ldt_next_start 		= ids_input.getItemDatetime( al_row +1, "port_arr_dt" )
ldt_first_end 			= ids_input.getItemDatetime( al_row, "port_dept_dt" )
ldt_next_end 			= ids_input.getItemDatetime( al_row +1, "port_dept_dt" )

/* Calculate how much to added to consumption (from DepartureDate to reportDate) */
ll_atsea_minutes = (f_datetime2long(ldt_next_start) - f_datetime2long(ldt_first_end) ) / 60
ll_delta_minutes = (f_datetime2long(adt_report_date) - f_datetime2long(ldt_next_end) ) / 60

/* insert row in result */
ll_result_row = ids_result.insertRow(0)
ids_result.setItem(ll_result_row, "vessel", li_vessel)
ids_result.setItem(ll_result_row, "vessel_ref_nr", ls_vessel_ref_nr)
ids_result.setItem(ll_result_row, "pc_name", ls_pc_name)
ids_result.setItem(ll_result_row, "voyage", ls_next_voyage)
ids_result.setItem(ll_result_row, "last_dept_date", ids_input.getItemDatetime( al_row, "last_dept_dt" ))

if isnull(ll_atsea_minutes) then ll_atsea_minutes = 0

lnv_arrival = create n_port_arrival_bunker_value 		
lnv_departure = create n_port_departure_bunker_value	

/* Calculate HFO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "HFO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_hfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "HFO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_hfo")

/* Get departure figures for next port */
lnv_departure.of_calculate( "HFO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_hfo")
	
if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
else
	
	/* Get lifted bunker lifted in next port */
	SELECT isnull(SUM(BP_DETAILS.LIFTED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.LIFTED_HFO),0) 
		INTO :ld_next_loaded_value, :ld_next_loaded_ton  
		FROM BP_DETAILS,   
			POC  
		WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
		AND BP_DETAILS.PCN = POC.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC.PORT_ARR_DT >= :ldt_next_start
		AND POC.PORT_ARR_DT <= :adt_report_date;
	
	commit;
	
	//	Read from Estimated
	SELECT isnull(SUM(BP_DETAILS.ORDERED_HFO * BP_DETAILS.PRICE_HFO),0),  isnull(SUM(BP_DETAILS.ORDERED_HFO),0) 
		INTO :ld_next_loaded_value_est, :ld_next_loaded_ton_est
		FROM BP_DETAILS,   
			POC_EST
		WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
		AND BP_DETAILS.PCN = POC_EST.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC_EST.PORT_ARR_DT >= :ldt_next_start
		AND POC_EST.PORT_ARR_DT <= :adt_report_date;
	commit;
	
	ld_next_loaded_value = ld_next_loaded_value + ld_next_loaded_value_est
	ld_next_loaded_ton = ld_next_loaded_ton + ld_next_loaded_ton_est

	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute =id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<id_tonpermin_min then 
			ls_msg=ls_msg + "hfo " 
			ld_ton_per_minute =id_tonpermin_avg
		end if
	end if
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg	

	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if
	
	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = (ld_first_departure_ton + ld_next_loaded_ton - ld_next_departure_ton ) + ld_additional_consumption_ton
	ld_consumption_value = (ld_first_departure_value + ld_next_loaded_value - ld_next_departure_value) + ld_additional_consumption_value
	
end if

ids_result.setItem(ll_result_row, "hfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "hfo_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "hfo_stock_value", ld_next_departure_value - ld_additional_consumption_value )


/* Calculate DO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "DO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_do")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "DO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_do")

/* Get departure figures for next port */
lnv_departure.of_calculate( "DO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_do")

if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
else
	
	/* Get lifted bunker lifted in next port */
	SELECT isnull(SUM(BP_DETAILS.LIFTED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.LIFTED_DO),0) 
		INTO :ld_next_loaded_value, :ld_next_loaded_ton  
		FROM BP_DETAILS,   
			POC  
		WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
		AND BP_DETAILS.PCN = POC.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC.PORT_ARR_DT >= :ldt_next_start
		AND POC.PORT_ARR_DT <= :adt_report_date;
	
	commit;
	
	//	Read from Estimated
	SELECT isnull(SUM(BP_DETAILS.ORDERED_DO * BP_DETAILS.PRICE_DO),0),  isnull(SUM(BP_DETAILS.ORDERED_DO),0) 
		INTO :ld_next_loaded_value_est, :ld_next_loaded_ton_est
		FROM BP_DETAILS,   
			POC_EST
		WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
		AND BP_DETAILS.PCN = POC_EST.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC_EST.PORT_ARR_DT >= :ldt_next_start
		AND POC_EST.PORT_ARR_DT <= :adt_report_date;
	commit;
	
	ld_next_loaded_value = ld_next_loaded_value + ld_next_loaded_value_est
	ld_next_loaded_ton = ld_next_loaded_ton + ld_next_loaded_ton_est
	
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
//	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
//		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<0.001 then 
//			ls_msg=ls_msg + "do " 
//			ld_ton_per_minute = 0.01875
//		end if
//	end if
	
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if
	
	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = (ld_first_departure_ton + ld_next_loaded_ton - ld_next_departure_ton ) + ld_additional_consumption_ton
	ld_consumption_value = (ld_first_departure_value + ld_next_loaded_value - ld_next_departure_value) + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "do_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "do_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "do_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "do_stock_value", ld_next_departure_value - ld_additional_consumption_value )


/* Calculate GO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "GO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_go")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "GO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_go")
	
/* Get departure figures for next port */
lnv_departure.of_calculate( "GO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_go")
	
if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
else
	
	/* Get lifted bunker lifted in next port */
	SELECT isnull(SUM(BP_DETAILS.LIFTED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.LIFTED_GO),0) 
		INTO :ld_next_loaded_value, :ld_next_loaded_ton  
		FROM BP_DETAILS,   
			POC  
		WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
		AND BP_DETAILS.PCN = POC.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC.PORT_ARR_DT >= :ldt_next_start
		AND POC.PORT_ARR_DT <= :adt_report_date;
	
	commit;
	
	//	Read from Estimated
	SELECT isnull(SUM(BP_DETAILS.ORDERED_GO * BP_DETAILS.PRICE_GO),0),  isnull(SUM(BP_DETAILS.ORDERED_GO),0) 
		INTO :ld_next_loaded_value_est, :ld_next_loaded_ton_est
		FROM BP_DETAILS,   
			POC_EST
		WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
		AND BP_DETAILS.PCN = POC_EST.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC_EST.PORT_ARR_DT >= :ldt_next_start
		AND POC_EST.PORT_ARR_DT <= :adt_report_date;
	commit;
	
	ld_next_loaded_value = ld_next_loaded_value + ld_next_loaded_value_est
	ld_next_loaded_ton = ld_next_loaded_ton + ld_next_loaded_ton_est
	
	/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = 0
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
//	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
//		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute<0.001 then 
//			ls_msg=ls_msg + "go " 
//			ld_ton_per_minute = 0.01875
//		end if
//	end if
	
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if
	
	/* Consumption */
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = (ld_first_departure_ton + ld_next_loaded_ton - ld_next_departure_ton ) + ld_additional_consumption_ton
	ld_consumption_value = (ld_first_departure_value + ld_next_loaded_value - ld_next_departure_value) + ld_additional_consumption_value

end if

ids_result.setItem(ll_result_row, "go_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "go_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "go_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "go_stock_value", ld_next_departure_value - ld_additional_consumption_value )


/* Calculate LSHFO  ************************************** */
/* Get departure figures for first port */
lnv_departure.of_calculate( "LSHFO", li_vessel , ls_first_voyage , ls_first_portcode , li_first_pcn , ld_first_departure_value )
ld_first_departure_ton = ids_input.getItemDecimal(al_row, "dept_lshfo")

/* Get arrival figures for next port */
lnv_arrival.of_calculate( "LSHFO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_arrival_value )
ld_next_arrival_ton = ids_input.getItemDecimal(al_row +1, "arr_lshfo")
	
/* Get departure figures for next port */
lnv_departure.of_calculate( "LSHFO", li_vessel , ls_next_voyage , ls_next_portcode , li_next_pcn , ld_next_departure_value )
ld_next_departure_ton = ids_input.getItemDecimal(al_row +1, "dept_lshfo")

if ld_next_arrival_ton = 0 and ld_next_departure_ton=0 then
	ld_consumption_ton =0 
	ld_consumption_value =0
	ld_additional_consumption_ton=0
	ld_additional_consumption_value=0
	ld_next_departure_ton=0
	ld_next_departure_value=0
else

	SELECT isnull(SUM(BP_DETAILS.LIFTED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.LIFTED_LSHFO),0) 
		INTO :ld_next_loaded_value, :ld_next_loaded_ton  
		FROM BP_DETAILS,   
			POC  
		WHERE BP_DETAILS.VESSEL_NR = POC.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC.PORT_CODE 
		AND BP_DETAILS.PCN = POC.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC.PORT_ARR_DT >= :ldt_next_start
		AND POC.PORT_ARR_DT <= :adt_report_date;
	
	commit;
	
	//	Read from Estimated
	
	SELECT isnull(SUM(BP_DETAILS.ORDERED_LSHFO * BP_DETAILS.PRICE_LSHFO),0),  isnull(SUM(BP_DETAILS.ORDERED_LSHFO),0) 
		INTO :ld_next_loaded_value_est, :ld_next_loaded_ton_est
		FROM BP_DETAILS,   
			POC_EST
		WHERE BP_DETAILS.VESSEL_NR = POC_EST.VESSEL_NR
		AND BP_DETAILS.VOYAGE_NR = POC_EST.VOYAGE_NR
		AND BP_DETAILS.PORT_CODE = POC_EST.PORT_CODE 
		AND BP_DETAILS.PCN = POC_EST.PCN	
		AND BP_DETAILS.VESSEL_NR = :li_vessel
		AND POC_EST.PORT_ARR_DT >= :ldt_next_start
		AND POC_EST.PORT_ARR_DT <= :adt_report_date;
	commit;
	
	ld_next_loaded_value = ld_next_loaded_value + ld_next_loaded_value_est
	ld_next_loaded_ton = ld_next_loaded_ton + ld_next_loaded_ton_est
	
		/*Calculation ton_per_minute at sea*/
	if ll_atsea_minutes = 0 or  ld_first_departure_ton=0 then
		ld_ton_per_minute = id_tonpermin_avg
	else
		ld_ton_per_minute = (ld_first_departure_ton - ld_next_arrival_ton ) / ll_atsea_minutes
	end if
	
	if ld_first_departure_ton<>ld_next_arrival_ton and ld_first_departure_ton>0 then
		if ll_atsea_minutes/60 < 24 and ld_ton_per_minute< id_tonpermin_min then 
			ls_msg=ls_msg + "lsfho " 
			ld_ton_per_minute = id_tonpermin_avg
		end if
	end if
	
	if ld_ton_per_minute > id_tonpermin_max then ld_ton_per_minute = id_tonpermin_avg	
	
	/*Calculation Price per ton */
	if ld_next_departure_ton = 0 then
		ld_price_per_ton = ld_next_arrival_value / ld_next_arrival_ton
	else
		ld_price_per_ton = ld_next_departure_value / ld_next_departure_ton
	end if
	
	/* Consumption */	
	ld_additional_consumption_ton = ld_ton_per_minute * ll_delta_minutes
	ld_additional_consumption_value = ld_additional_consumption_ton * ld_price_per_ton
	
	ld_consumption_ton = (ld_first_departure_ton + ld_next_loaded_ton - ld_next_departure_ton ) + ld_additional_consumption_ton
	ld_consumption_value = (ld_first_departure_value + ld_next_loaded_value - ld_next_departure_value) + ld_additional_consumption_value
end if

ids_result.setItem(ll_result_row, "lshfo_consumption_ton", ld_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_consumption_value", ld_consumption_value )
ids_result.setItem(ll_result_row, "lshfo_stock_ton", ld_next_departure_ton  - ld_additional_consumption_ton )
ids_result.setItem(ll_result_row, "lshfo_stock_value", ld_next_departure_value - ld_additional_consumption_value )

//Display alert messages in the report
//if ls_msg<>"" then
	// ids_result.setItem(ll_result_row, "error_message","3) " + ls_msg )
//end if

destroy lnv_arrival
destroy lnv_departure

return 1
end function

public function integer of_getsharemember (ref blob ablb_sharememberds, ref string as_dataobject);long ll_rc

ll_rc = ids_sharemember.getfullstate( ablb_sharememberds )
if ll_rc < 1 then 
	return -1
end if

as_dataobject = ids_sharemember.dataObject

return 1
end function

public function integer of_generatecodaupload (ref hprogressbar ahpb);/* Denne funktion genererer upload til coda udfra både voyage consumption
	og sharemember rapporterne */
datastore	lds_trans_elements
long			ll_result_rows, ll_sharemember_rows, ll_row, ll_upload_row
decimal{4}	ld_amount, ld_temp_amount
string			ls_el3a, ls_el3b, ls_el4, ls_prefix_vessel, ls_prefix_voyage, ls_prefix_supplier, ls_apm_identifier
string			ls_filename, notinuse
long			ll_result

lds_trans_elements = create datastore
lds_trans_elements.dataObject = "d_default_values_maintenance"
lds_trans_elements.setTransObject(sqlca)
lds_trans_elements.retrieve( )
commit;

ll_result_rows 				= ids_result.rowcount( )
ll_sharemember_rows	= ids_sharemember.rowcount( )

if (ll_result_rows + ll_sharemember_rows) < 1 then 
	destroy lds_trans_elements 
	return -1 
end if
ahpb.maxposition = (ll_result_rows + ll_sharemember_rows)

ls_prefix_vessel	= lds_trans_elements.getItemString(1, "prefix_vessel")
ls_prefix_voyage	= lds_trans_elements.getItemString(1, "prefix_voyage")
ls_prefix_supplier	= lds_trans_elements.getItemString(1, "prefix_supplier_foreign")
ls_apm_identifier	= lds_trans_elements.getItemString(1, "apmcph_identifier")

/* Bunker Consumption */
ls_el3a	= lds_trans_elements.getItemString(1, "bunker_a_gl")
ls_el3b 	= lds_trans_elements.getItemString(1, "prepaid_expenses_gl")
ls_el4		= lds_trans_elements.getItemString(1, "bunker_a_acc")

for ll_row = 1 to ll_result_rows
	ahpb.position = ll_row
	/* First posting row */
	ld_temp_amount = ids_result.getItemDecimal(ll_row, "hfo_consumption_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount = ld_temp_amount
	ld_temp_amount = ids_result.getItemDecimal(ll_row, "do_consumption_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount += ld_temp_amount
	ld_temp_amount = ids_result.getItemDecimal(ll_row, "go_consumption_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount += ld_temp_amount
	ld_temp_amount = ids_result.getItemDecimal(ll_row, "lshfo_consumption_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount += ld_temp_amount
	ll_upload_row = ids_coda_upload.insertRow(0)
	ids_coda_upload.setItem(ll_upload_row, "amount", round(ld_amount,2) *-1)
	ids_coda_upload.setItem(ll_upload_row, "element2", "MT")
	ids_coda_upload.setItem(ll_upload_row, "element3", ls_el3a )
	ids_coda_upload.setItem(ll_upload_row, "element4", ls_el4 )
	ids_coda_upload.setItem(ll_upload_row, "element5", ls_prefix_vessel + ids_result.getItemString(ll_row, "vessel_ref_nr"))
	ids_coda_upload.setItem(ll_upload_row, "element6", ls_prefix_voyage + ids_result.getItemString(ll_row, "voyage"))
	ids_coda_upload.setItem(ll_upload_row, "description", "Calc. Bunker consumption" )
	/* Second posting row */
	ll_upload_row = ids_coda_upload.insertRow(0)
	ids_coda_upload.setItem(ll_upload_row, "amount", round(ld_amount,2))
	ids_coda_upload.setItem(ll_upload_row, "element2", "MT")
	ids_coda_upload.setItem(ll_upload_row, "element3", ls_el3b )
	ids_coda_upload.setItem(ll_upload_row, "element4", ls_el4 )
	ids_coda_upload.setItem(ll_upload_row, "element5", ls_prefix_vessel + ids_result.getItemString(ll_row, "vessel_ref_nr"))
	ids_coda_upload.setItem(ll_upload_row, "element6", ls_prefix_voyage + ids_result.getItemString(ll_row, "voyage"))
	ids_coda_upload.setItem(ll_upload_row, "description", "Calc. Bunker consumption" )
next

/* Sharemember Stock */
ls_el3b 	= lds_trans_elements.getItemString(1, "charterer_gl")

for ll_row = 1 to ll_sharemember_rows
	ahpb.position = ll_result_rows + ll_row
	/* Check if S# = apmcph or if blank. If so ignore upload */
	if ids_sharemember.getItemString(ll_row, "snumber") = ls_apm_identifier &
	or ids_sharemember.getItemString(ll_row, "snumber") = "" &
	or isnull(ids_sharemember.getItemString(ll_row, "snumber")) then continue
	
	/* First posting row */
	ld_temp_amount = ids_sharemember.getItemDecimal(ll_row, "hfo_stock_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount = ld_temp_amount
	ld_temp_amount = ids_sharemember.getItemDecimal(ll_row, "do_stock_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount += ld_temp_amount
	ld_temp_amount = ids_sharemember.getItemDecimal(ll_row, "go_stock_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount += ld_temp_amount
	ld_temp_amount = ids_sharemember.getItemDecimal(ll_row, "lshfo_stock_value")
	if isnull(ld_temp_amount) then ld_temp_amount = 0
	ld_amount += ld_temp_amount
	ll_upload_row = ids_coda_upload.insertRow(0)
	ids_coda_upload.setItem(ll_upload_row, "amount", round(ld_amount,2) *-1)
	ids_coda_upload.setItem(ll_upload_row, "element2", "MT")
	ids_coda_upload.setItem(ll_upload_row, "element3", ls_el3a )
	ids_coda_upload.setItem(ll_upload_row, "element4", ls_el4 )
	ids_coda_upload.setItem(ll_upload_row, "element5", ls_prefix_vessel + ids_sharemember.getItemString(ll_row, "vessel_ref_nr"))
	ids_coda_upload.setItem(ll_upload_row, "description", "Bunker, share member" )
	/* Second posting row */
	ll_upload_row = ids_coda_upload.insertRow(0)
	ids_coda_upload.setItem(ll_upload_row, "amount", round(ld_amount,2))
	ids_coda_upload.setItem(ll_upload_row, "element2", "MT")
	ids_coda_upload.setItem(ll_upload_row, "element3", ls_el3b )
	ids_coda_upload.setItem(ll_upload_row, "element4", ls_prefix_supplier + ids_sharemember.getItemString(ll_row, "snumber"))
	ids_coda_upload.setItem(ll_upload_row, "element5", ls_prefix_vessel + ids_sharemember.getItemString(ll_row, "vessel_ref_nr"))
	ids_coda_upload.setItem(ll_upload_row, "description", "Bunker, share member" )
next

if ids_coda_upload.rowCount() > 0 then
	/* Get Filename and Save File as an Excel-file with headerfields */
	ls_filename = "BunkerUpload"+string(today(),"ddmmyy") 
	ll_result = GetFileSaveName("Enter valid filename...", &
			ls_filename, notinuse, "XLS", &
			"Excel Files (*.XLS),*.XLS," + &
			" All Files (*.*), *.*")
	if ll_result <> 1 then
		MessageBox("Filename Error", "Wrong filename")
		return -1
	end if
	
	/* Save File as an Excel-file without headerfields */
	ll_result = ids_coda_upload.SaveAs(ls_filename, Excel!, TRUE)
	
	/* Inform the user about the file is created */
	if isnull(ll_result) or ll_result= -1 then
		MessageBox("Save Error", "An error occured while saving the file")
	else
		MessageBox("Information","The file was succesfully created!")
	end if
end if

destroy lds_trans_elements
return 1
end function

public function integer of_distributesharemember (datetime adt_report_date, ref hprogressbar ahpb);/* This function generates a sharemember report based on the first report ids_result
	The reports finds out if vessel is on a TC-IN contract med 0 i hyre, eller hvor der er
	registreret sharemembers.
	Fordeler stock mellem de registrerede parter */  
long ll_row_count, ll_row, ll_new_row, ll_vessel_nr, ll_row_count_sharemembers, ll_row_sharemembers
string ls_voyage_nr, ls_tcowner, ls_snr, ls_vessel_ref_nr, ls_pc_name
datetime ldt_arr_date
decimal ld_procent, ld_rate
n_ds lds_sharemembers
integer li_hire_in

lds_sharemembers = Create n_ds

lds_sharemembers.dataObject = "d_contract_sharemembers"
lds_sharemembers.setTransObject(SQLCA)

ids_sharemember.reset()

ll_row_count = ids_result.RowCount()

/* Set header text */
ids_sharemember.Object.t_header.Text = "Sharemember Bunker Stock pr. "+string(adt_report_date, "dd. mmmm-yyyy hh:mm")

ahpb.maxposition = ll_row_count
FOR ll_row = 1 TO ll_row_count
	ahpb.position = ll_row
	ll_vessel_nr 		= ids_result.GetItemNumber(ll_row, "vessel")
	ls_vessel_ref_nr	= ids_result.getItemString(ll_row, "vessel_ref_nr")
	ls_pc_name = ids_result.getItemString(ll_row, "pc_name")
	ls_voyage_nr 		= ids_result.GetItemString(ll_row, "voyage")
	ld_rate				= 0
	ls_tcowner			= "NO TC Contract"
	ls_snr				= ""
	li_hire_in			= 0
	
	SELECT min(PORT_ARR_DT) 
		INTO :ldt_arr_date 
		FROM POC 
		WHERE VESSEL_NR=:ll_vessel_nr 
		AND VOYAGE_NR=:ls_voyage_nr;
	COMMIT;
	
	SELECT isNull(NTC_TC_PERIOD.RATE,0), isNull(TCOWNERS.TCOWNER_N_1,""), TC_HIRE_IN, TCOWNERS.NOM_ACC_NR  
		INTO :ld_rate, :ls_tcowner, :li_hire_in, :ls_snr  
		FROM NTC_TC_CONTRACT, NTC_TC_PERIOD, TCOWNERS  
		WHERE NTC_TC_PERIOD.CONTRACT_ID = NTC_TC_CONTRACT.CONTRACT_ID 
		and TCOWNERS.TCOWNER_NR = NTC_TC_CONTRACT.TCOWNER_NR 
		and NTC_TC_CONTRACT.VESSEL_NR = :ll_vessel_nr 
		AND NTC_TC_CONTRACT.TC_HIRE_IN = 1 
		AND NTC_TC_PERIOD.PERIODE_START <= :ldt_arr_date 
		AND NTC_TC_PERIOD.PERIODE_END > :ldt_arr_date ;
	COMMIT;

	ll_row_count_sharemembers = lds_sharemembers.Retrieve(ll_vessel_nr, ldt_arr_date)
	COMMIT;
	
	/* TC-in, share members and rate > 0 -> fordel efter share pct */
	IF ll_row_count_sharemembers > 0 THEN
		IF lds_sharemembers.GetItemNumber(1, "ntc_tc_period_rate") > 0 THEN
			FOR ll_row_sharemembers = 1 TO ll_row_count_sharemembers
				ll_new_row = ids_sharemember.InsertRow(0)
				ld_procent = lds_sharemembers.GetItemNumber(ll_row_sharemembers, "ntc_share_member_percent_share")
				ids_sharemember.SetItem(ll_new_row,"vessel", ll_vessel_nr)
				ids_sharemember.SetItem(ll_new_row,"vessel_ref_nr", ls_vessel_ref_nr)
				ids_sharemember.SetItem(ll_new_row,"pc_name", ls_pc_name)
				ids_sharemember.SetItem(ll_new_row,"voyage", ls_voyage_nr) 
				ids_sharemember.SetItem(ll_new_row,"hfo_stock_ton",ids_result.GetItemNumber(ll_row, "hfo_stock_ton")*(ld_procent/100)) 
				ids_sharemember.SetItem(ll_new_row,"do_stock_ton",ids_result.GetItemNumber(ll_row, "do_stock_ton")*(ld_procent/100))  
				ids_sharemember.SetItem(ll_new_row,"go_stock_ton",ids_result.GetItemNumber(ll_row, "go_stock_ton")*(ld_procent/100)) 
				ids_sharemember.SetItem(ll_new_row,"lshfo_stock_ton",ids_result.GetItemNumber(ll_row, "lshfo_stock_ton")*(ld_procent/100)) 
				ids_sharemember.SetItem(ll_new_row,"hfo_stock_value",ids_result.GetItemNumber(ll_row, "hfo_stock_value")*(ld_procent/100))  
				ids_sharemember.SetItem(ll_new_row,"do_stock_value",ids_result.GetItemNumber(ll_row, "do_stock_value")*(ld_procent/100))  
				ids_sharemember.SetItem(ll_new_row,"go_stock_value",ids_result.GetItemNumber(ll_row, "go_stock_value")*(ld_procent/100))
				ids_sharemember.SetItem(ll_new_row,"lshfo_stock_value",ids_result.GetItemNumber(ll_row, "lshfo_stock_value")*(ld_procent/100))  
				ids_sharemember.SetItem(ll_new_row,"sharemember",lds_sharemembers.GetItemString(ll_row_sharemembers, "share_owner"))
				ids_sharemember.SetItem(ll_new_row,"snumber",lds_sharemembers.GetItemString(ll_row_sharemembers, "share_owner_snr"))
			NEXT
			CONTINUE
		END IF
	END IF
	
	/* TC-in, rate = 0 -> alt til owner */
	IF li_hire_in = 1 and ld_rate = 0 THEN
		ll_new_row = ids_sharemember.InsertRow(0)
		ids_sharemember.SetItem(ll_new_row,"vessel", ll_vessel_nr)
		ids_sharemember.SetItem(ll_new_row,"vessel_ref_nr", ls_vessel_ref_nr)
		ids_sharemember.SetItem(ll_new_row,"pc_name", ls_pc_name)
		ids_sharemember.SetItem(ll_new_row,"voyage", ls_voyage_nr) 
		ids_sharemember.SetItem(ll_new_row,"hfo_stock_ton",ids_result.GetItemNumber(ll_row, "hfo_stock_ton")) 
		ids_sharemember.SetItem(ll_new_row,"do_stock_ton",ids_result.GetItemNumber(ll_row, "do_stock_ton"))  
		ids_sharemember.SetItem(ll_new_row,"go_stock_ton",ids_result.GetItemNumber(ll_row, "go_stock_ton")) 
		ids_sharemember.SetItem(ll_new_row,"lshfo_stock_ton",ids_result.GetItemNumber(ll_row, "lshfo_stock_ton")) 
		ids_sharemember.SetItem(ll_new_row,"hfo_stock_value",ids_result.GetItemNumber(ll_row, "hfo_stock_value"))  
		ids_sharemember.SetItem(ll_new_row,"do_stock_value",ids_result.GetItemNumber(ll_row, "do_stock_value"))  
		ids_sharemember.SetItem(ll_new_row,"go_stock_value",ids_result.GetItemNumber(ll_row, "go_stock_value"))
		ids_sharemember.SetItem(ll_new_row,"lshfo_stock_value",ids_result.GetItemNumber(ll_row, "lshfo_stock_value"))  
		ids_sharemember.SetItem(ll_new_row,"sharemember",ls_tcowner)
		ids_sharemember.SetItem(ll_new_row,"snumber",ls_snr)
	ELSE
		/* TC-out or no share members and rate > 0 -> alt til "APM CPH" */
		ll_new_row = ids_sharemember.InsertRow(0)
		ids_sharemember.SetItem(ll_new_row,"vessel", ll_vessel_nr)
		ids_sharemember.SetItem(ll_new_row,"vessel_ref_nr", ls_vessel_ref_nr)
		ids_sharemember.SetItem(ll_new_row,"pc_name", ls_pc_name)
		ids_sharemember.SetItem(ll_new_row,"voyage", ls_voyage_nr) 
		ids_sharemember.SetItem(ll_new_row,"hfo_stock_ton",ids_result.GetItemNumber(ll_row, "hfo_stock_ton")) 
		ids_sharemember.SetItem(ll_new_row,"do_stock_ton",ids_result.GetItemNumber(ll_row, "do_stock_ton"))  
		ids_sharemember.SetItem(ll_new_row,"go_stock_ton",ids_result.GetItemNumber(ll_row, "go_stock_ton")) 
		ids_sharemember.SetItem(ll_new_row,"lshfo_stock_ton",ids_result.GetItemNumber(ll_row, "lshfo_stock_ton")) 
		ids_sharemember.SetItem(ll_new_row,"hfo_stock_value",ids_result.GetItemNumber(ll_row, "hfo_stock_value"))  
		ids_sharemember.SetItem(ll_new_row,"do_stock_value",ids_result.GetItemNumber(ll_row, "do_stock_value"))  
		ids_sharemember.SetItem(ll_new_row,"go_stock_value",ids_result.GetItemNumber(ll_row, "go_stock_value"))
		ids_sharemember.SetItem(ll_new_row,"lshfo_stock_value",ids_result.GetItemNumber(ll_row, "lshfo_stock_value"))  
		ids_sharemember.SetItem(ll_new_row,"sharemember","APM CPH")
		ids_sharemember.SetItem(ll_new_row,"snumber","")
	END IF
NEXT

ids_sharemember.Sort()
ids_sharemember.GroupCalc()

DESTROY lds_sharemembers

return 1
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_bunker_value_by_date
   <OBJECT> This object is used to create Bunker report Bunker consumption / Stock on given date </OBJECT>
   <DESC> </DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
Date   		Ref	Author	Comments
01/06/11 	?      	?     			First Version
13/09-11		2495	JMC112		Fix calculation, including bunker on estimated port of calls 
30/09-11		2495	JMC112		Fix calculation, at port without departure bunker figures solved
28/10-11		2495	JMC112		Fix calculation, Add default values
02/11-11		2632	JMC112		Add profit center name
********************************************************************/
end subroutine

event constructor;ids_input = create datastore
ids_input.dataObject = "d_sp_tb_bunker_value_by_date"
ids_input.setTransObject(sqlca)

ids_result = create datastore
ids_result.dataObject = "d_ex_tb_bunker_value_by_date_result"

ids_sharemember = create datastore
ids_sharemember.dataObject = "d_ex_tb_bunker_value_by_date_sharemember"

ids_coda_upload = create datastore
ids_coda_upload.dataObject = "d_ex_tb_bunker_stock_coda_upload"
end event

on n_bunker_value_by_date.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_bunker_value_by_date.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;destroy ids_input
destroy ids_result
destroy ids_sharemember
destroy ids_coda_upload

end event

