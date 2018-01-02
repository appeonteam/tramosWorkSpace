$PBExportHeader$w_msps_interface.srw
forward
global type w_msps_interface from mt_w_sheet
end type
type lb_files from listbox within w_msps_interface
end type
type sle_exp from singlelineedit within w_msps_interface
end type
type st_exp from statictext within w_msps_interface
end type
type sle_expired from singlelineedit within w_msps_interface
end type
type st_expired from statictext within w_msps_interface
end type
type sle_receiver from singlelineedit within w_msps_interface
end type
type sle_sender from singlelineedit within w_msps_interface
end type
type st_receiver from statictext within w_msps_interface
end type
type st_sender from statictext within w_msps_interface
end type
type st_dirlog from statictext within w_msps_interface
end type
type sle_log from singlelineedit within w_msps_interface
end type
type gb_ini from groupbox within w_msps_interface
end type
type ids_tank_list from mt_n_datastore within w_msps_interface
end type
type ids_cargo_discharge from mt_n_datastore within w_msps_interface
end type
type ids_cargo_load from mt_n_datastore within w_msps_interface
end type
type ids_terminal_discharge from mt_n_datastore within w_msps_interface
end type
type ids_terminal_load from mt_n_datastore within w_msps_interface
end type
type ids_drift from mt_n_datastore within w_msps_interface
end type
type ids_departure_canal from mt_n_datastore within w_msps_interface
end type
type ids_departure_discharge from mt_n_datastore within w_msps_interface
end type
type ids_departure_load from mt_n_datastore within w_msps_interface
end type
type ids_arrival from mt_n_datastore within w_msps_interface
end type
type ids_heating from mt_n_datastore within w_msps_interface
end type
type ids_noon from mt_n_datastore within w_msps_interface
end type
type ids_report from mt_n_datastore within w_msps_interface
end type
end forward

global type w_msps_interface from mt_w_sheet
boolean visible = false
integer width = 1362
integer height = 604
string title = "MSPS Interface Console"
boolean minbox = false
boolean maxbox = false
lb_files lb_files
sle_exp sle_exp
st_exp st_exp
sle_expired sle_expired
st_expired st_expired
sle_receiver sle_receiver
sle_sender sle_sender
st_receiver st_receiver
st_sender st_sender
st_dirlog st_dirlog
sle_log sle_log
gb_ini gb_ini
ids_tank_list ids_tank_list
ids_cargo_discharge ids_cargo_discharge
ids_cargo_load ids_cargo_load
ids_terminal_discharge ids_terminal_discharge
ids_terminal_load ids_terminal_load
ids_drift ids_drift
ids_departure_canal ids_departure_canal
ids_departure_discharge ids_departure_discharge
ids_departure_load ids_departure_load
ids_arrival ids_arrival
ids_heating ids_heating
ids_noon ids_noon
ids_report ids_report
end type
global w_msps_interface w_msps_interface

type variables
pbdom_document i_pbdom_doc
pbdom_builder  i_pbdom_builder

mt_n_stringfunctions	inv_stringfunctions	//Commend line parameters resolving object
n_msps_interface 		inv_msps_interface	//MSPS interface component

string 	is_route_stack[]
string 	is_route_path
integer	ii_interval, ii_expired
string	is_sender, is_receiver												//Email info

s_command_line istr_command_line

constant string 	is_SPECIALSTRING_N = "+-+n"
constant string	is_SPECIALSTRING_R = "+-+r"

//----------------------Business logic constant variables----------------------
constant string 	is_SPLIT_SIGN = "~t"					//Separation sign for leaf value
constant string	is_FORMAT_DATE_TIME = "yyyy-mm-dd hh:mm:ss" //Date time
constant integer	ii_COLUMNS_TERMINAL = 40			//Terminal column count
constant integer	ii_COLUMNS_TANK_LIST = 3			//Noon tank list column count
constant integer	ii_COLUMNS_CARGO_LOAD = 30			//Cargo loading column count
constant integer	ii_COLUMNS_CARGO_DISCHARGE = 28	//Cargo discharging clolumn count

//----------------------Mail info constant variables----------------------
constant string	is_MAIL_CHECKSUM = "<CHECKSUM=~"${CHECKSUM}~">~r~n${PACKAGE}"

constant string	is_MAIL_PACKAGE		=	"<PACKAGE>~r~n" + &
														"~t<NUMBER>${NUMBER}</NUMBER>~r~n" + &
														"~t<FROM>TRAMOS</FROM>~r~n" + &
														"~t<TO>MSPS</TO>~r~n" + &
														"~t<SENT_DATE_UTC>${SENT_DATE_UTC}</SENT_DATE_UTC>~r~n" + &
														"~t<CONFIRMATIONS>~r~n" + &
														"~t~t${CONFIRMATIONS}~r~n" + &
														"~t</CONFIRMATIONS>~r~n" + &
														"</PACKAGE>"

constant string	is_MAIL_CONFIRMATION =	"<CONFIRMATION>~r~n" + &
								 						"~t~t~t<VESSEL_IMO>${VESSEL_IMO}</VESSEL_IMO>~r~n" + &
								 						"~t~t~t<REPORT_NO>${REPORT_NO}</REPORT_NO>~r~n" + &
							    						"~t~t~t<REVISION_NO>${REVISION_NO}</REVISION_NO>~r~n" + &
								 						"~t~t~t<REPORT_DATE_UTC>${REPORT_DATE_UTC}</REPORT_DATE_UTC>~r~n" + &
								 						"~t~t</CONFIRMATION>"


//----------------------Log constant variables----------------------------------
constant string	is_LOG_INTERFACE_START 		  = "----------------------MSPS interface to TRAMOS started----------------------"
constant string	is_LOG_INTERFACE_END	 		  = "----------------------MSPS interface to TRAMOS ended------------------------"
constant string	is_LOG_INITIALIZATION_SUCCESS= "Initialize parameters from command line: succeed"
constant string	is_LOG_INITIALIZATION_FAILURE= "Initialize parameters from command line: failed"
constant string	is_LOG_CONNECTION_SUCCESS 	  = "Connect to database: succeed"
constant string	is_LOG_CONNECTION_FAILURE 	  = "Connect to database: failed"
constant string	is_LOG_CREATE_DATASTORE 	  = "Creating datastore error occured"
constant string	is_LOG_REJECT_SUCCESS 		  = "Rejecting and moving XML file: succeed"
constant string	is_LOG_REJECT_FAILURE 		  = "Rejecting and moving XML file: failed"
constant string	is_LOG_DELETE_SUCCESS 		  = "Delete XML file: succeed"
constant string	is_LOG_DELETE_FAILUER 		  = "Delete XML file: failed"
constant string	is_LOG_TRAMOS_UPDATE_SUCCESS = "All sub reports updated: succeed"
constant string	is_LOG_TRAMOS_UPDATE_FAILURE = "One or more sub reports updated: failed"
constant string	is_LOG_TRAMOS_SAVE_SUCCESS   = "Saving XML file data to TRAMOS: succeed"
constant string	is_LOG_TRAMOS_SAVE_FAILURE   = "Saving XML file data to TRAMOS: failed. Error message:${1}"
constant string	is_LOG_TRAMOS_IMPORT_SUCCESS = "Importing to TRAMOS: succeed"
constant string	is_LOG_TRAMOS_IMPORT_FAILURE = "Importing ${0} to TRAMOS: failed, failed code is:${1}"
constant string	is_LOG_VOYAGE_NO				  = "Voyage No. is not find  in TRAMOS"
constant string	is_LOG_EMAIL_SUCCESS 	  	  = "Send email to MSPS department: succeed"
constant string	is_LOG_EMAIL_FAILURE 	     = "Send email to MSPS department: failed"
constant string	is_DIRXML_SUCCESS 		     = "Check in XML files from physical disk: succeeded"
constant string	is_DIRXML_FAILURE 		     = "Check in XML files from physical disk: failed"
constant string	is_FILE_CHECKSUM             = "Validating the file ${FILE} checksum error occured, process terminated"
constant string	is_FILE_MOVING_SUCCESS		  = "Moving failed XML file: ${FILE} succeed"
constant string	is_FILE_MOVING_FAILURE		  = "Moving failed XML file: ${FILE} failed"
constant string	is_LOG_FILE_LIST             = "There is no any file found, process terminated"

constant string	is_SUFFIX = "XML"

//Message type
constant string is_ARRIVAL = "arrival"
constant string is_CANAL = "canal"
constant string is_FWODRIFT = "fwo/drift"
constant string is_LOAD = "loading"
constant string is_DISCHARGE = "discharging"
constant string is_HEATING = "heating"
constant string is_NOON = "noon"

boolean	ib_rul_generatenotdefined
end variables

forward prototypes
public function integer wf_set_route_stack (string as_node)
public function string wf_get_route ()
public function integer wf_initialize_parameters ()
public subroutine documentation ()
public function s_mspsdata wf_set_leaf_to_string (string as_route, string as_node_name, string as_leaf_value, s_mspsdata astr_mspsdata)
public function string wf_replace_confirmation (s_mspsdata astr_mspsdata, string as_mail_confirmation)
public function s_mspsdata wf_get_mapping_key (s_mspsdata astr_mspsdata)
public function integer wf_check_expired_days (s_mspsdata astr_mspsdata)
public function string wf_replace_package (string as_confirmation, string as_mail_package)
public subroutine wf_set_mapping_key (s_mspsdata astr_mspsdata, ref mt_n_datastore ads_mspsdata)
public function integer wf_set_updatable (string as_route, string as_node_name, string as_leaf_value, ref s_mspsdata astr_mspsdata)
public function datetime wf_get_departure_datetime (mt_n_datastore ads_message, mt_n_datastore ads_terminal)
public function datetime wf_get_berthing_datetime (mt_n_datastore ads_message)
public function datetime wf_get_arrival_datetime (mt_n_datastore ads_message)
public function integer wf_get_archiving_key (ref s_mspsdata astr_mspsdata, string as_report_table_name, integer ai_load_or_discharge)
public function integer wf_set_archiving (s_mspsdata astr_mspsdata, string as_report_table_name, ref mt_n_datastore ads_mspsdata)
public function integer wf_get_file_list (s_command_line astr_command_line, ref string as_files[])
public function integer wf_set_transfer (string as_filename)
public function integer wf_reject_xml (s_mspsdata astr_mspsdata)
public function integer wf_move_xml (string as_src, string as_des)
public function integer wf_save_tramos (s_mspsdata astr_mspsdata)
public function integer wf_import_tramos (ref s_mspsdata astr_mspsdata)
public function integer wf_connect_database ()
public subroutine wf_disconnect_database ()
public function integer wf_set_route_stack (ref string as_route, string as_note)
public function integer wf_set_leaf (pbdom_object ao_node, ref s_mspsdata astr_mspsdata, string as_node_name)
public function integer wf_eliminate_stack (integer as_start)
public function integer wf_check_change_flag (s_mspsdata astr_mspsdata, string as_report_table_name, string as_changed_flag)
public function integer wf_generate_alerts (s_mspsdata astr_mspsdata, string as_msgtype_array[])
end prototypes

public function integer wf_set_route_stack (string as_node);/********************************************************************
   wf_set_route_stack
   <DESC>	Reset the route value in the stack.	
				Route:	The node of XML data file but not leaf value, 
							it is recursion method traversing(reading) path.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		as_node
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/

choose case as_node
	case "HEADER", "NOON", "HEATING", "ARRIVAL", "LOADING", "DISCHARGING", "CANAL", "FWO_DRIFT"
		wf_eliminate_stack(2)
		//Deal with special exception of "ARRIVAL" lable that after the "HEATING" label
		if as_node = "ARRIVAL" then
			if is_route_stack[1] = "HEATING" then is_route_stack[1] = as_node
		else	
			is_route_stack[1] = as_node
		end if		
	case "TERMINALS"
		wf_eliminate_stack(3)
		is_route_stack[2] = as_node
	case "CARGO" 
		wf_eliminate_stack(3)
		is_route_stack[2] = as_node
	case "TANKS"
		wf_eliminate_stack(3)
		if is_route_stack[1] = "NOON" then	is_route_stack[2] = as_node
	case else
		return 0
end choose

return 1
end function

public function string wf_get_route ();/********************************************************************
   wf_get_route
   <DESC>	Get the traversal route for extracting leaves value	</DESC>
   <RETURN>	string: Route value	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Distinguish the leaves value for transfering to TRAMOS	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
string 	ls_route
integer	i, j

j = upperbound(is_route_stack)

for i = 1 to j
	if is_route_stack[i] <> "" then ls_route += is_route_stack[i] + "="
next

//Cut out the "=" word at the end of the route string
if len(ls_route) > 0 then ls_route = left(ls_route, len(ls_route) - 1)

return ls_route
end function

public function integer wf_initialize_parameters ();/********************************************************************
   wf_initialize_parameters
   <DESC>	Initialize the parameters from command line structure	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	09-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/

//Database transaction parameters
SQLCA.DBMS 			= "SYC Sybase System 10"
SQLCA.Database 	= istr_command_line.as_database
SQLCA.ServerName 	= istr_command_line.as_server
SQLCA.LogId 		= "adminServerApp"
SQLCA.LogPass 		= "LKJHGFdsa!##"
SQLCA.AutoCommit 	= False
SQLCA.Dbparm 		= "OJSyntax='PB', release = '15'" 
	
//Running parameters
sle_log.text = istr_command_line.as_folder_log
sle_exp.text = istr_command_line.as_folder_expired
is_sender = istr_command_line.as_sender
is_receiver = istr_command_line.as_receiver
sle_sender.text = is_sender
sle_receiver.text = is_receiver

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	MSPS Inteface procedure is splited into two parts:
	
				1. Parsing the data from XML data file to data sturcture(s_mspsdata)
				
					A. Get parameters from command line
					B. Get the data file into string array(w_msps_interface.wf_get_file_list().as_files) after checksum validataion for data transfering
					C. Validate if the file format is correct
					D. Extract data using PBDOM from XML data file into data structure
					
				2. Saving data from data structure into database
				
					A. Use importstring function to read the data string from data structure into datastore
					B. Check if the file is legal
					C. Check archiving status before saving into database
					D. Send email after data is saved into database successfully
				
				
				Here is an example of how the data extracted from XML data file:
				
					<LOADING> -------------------->>>>> Point A
						<CHANGED>0</CHANGED>
						<NEW>0</NEW>
						<VOYAGE_NO></VOYAGE_NO>
						...
						<TERMINALS> -------------------->>>>> Point B
							<TERMINAL> -------------------->>>>> Point C1
								<ID>4</ID>
								<NUMBER>5</NUMBER>
								<NAME>abc</NAME>
								...
							</TERMINAL>
							<TERMINAL> -------------------->>>>> Point C2
								<ID></ID>
								<NUMBER></NUMBER>
								<NAME></NAME>
								...
							</TERMINAL>
							...
						</TERMINALS>
						<SHIP_TO_SHIP_VESSEL_NAME></SHIP_TO_SHIP_VESSEL_NAME> -------------------->>>>> Point D
						...
					</LOADING>
				
				1.) When reaching node LOADING (point A), 
						The value of the stack will be:
							stack[1] = "LOADING"
							stack[2] = ""
						Based on the value of stack, the leaf values in this section will be stored in s_mspsdata.as_departure_load. 
						Each value will be separated by comma.
				
				2.) When reaching node TERMINALS (point B), in this section might contain multiple lines terminal data (point C1 and C2)
						The value of the stack will be:
							stack[1] = "LOADING"
							stack[2] = "TERMINALS"
						Based on the value of stack, the leaf values in this section will be stored in s_mspsdata.as_terminal_load. 
						Each value will be separated by comma. When in reach another terminal data (ex: point C2), it will separated by "~r~n".
						
				3.) When reaching SHIP_TO_SHIP_VESSEL_NAME (point D)
						The value of the stack will be reseted as:
							stack[1] = "LOADING"
							stack[2] = ""
						Based on the value of stack, the leaf values in this section will be stored in s_mspsdata.as_departure_load.
				
				

	</DESC>
   <RETURN>		</RETURN>
   <ACCESS> </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-12-2011 CR20         JMY014             First Version
   	25/07/2013 CR3238       LHG008             1. Show carriage return in "notes"
                                                 2. Messages with status "Active" and "New" should be archived, 
                                                    making sure that only the last revision of the message is active.
		20/10/2013 CR3340			LHG008				 Fix error in archive message.
		08/01/2014 CR3240			LHC010				 Generate alerts for noon message.
   </HISTORY>
********************************************************************/
end subroutine

public function s_mspsdata wf_set_leaf_to_string (string as_route, string as_node_name, string as_leaf_value, s_mspsdata astr_mspsdata);/********************************************************************
   wf_leaf_to_string
   <DESC>	Combined the value of leaves to string 	</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_leaf_value: Leaf value of XML file
   </ARGS>
   <USAGE>	Extract leaf value to special string variable in a structure	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	06-12-2011 	20           JMY014        First Version
		06-17-2013	CR3238		 LHC010			Add column vessel name
   </HISTORY>
********************************************************************/

choose case as_route
	case "HEADER"
		astr_mspsdata.as_report += as_leaf_value + is_SPLIT_SIGN
		//Extract the primary key from XML file directly
		if as_node_name = "VESSEL_IMO" then astr_mspsdata.as_vessel_imo = as_leaf_value
		if as_node_name = "REPORT_ID" then astr_mspsdata.as_report_id = as_leaf_value
		if as_node_name = "REVISION_NO" then 
			astr_mspsdata.as_revision_no = as_leaf_value
			astr_mspsdata.as_primary_key = astr_mspsdata.as_vessel_imo + "~t" + astr_mspsdata.as_report_id + "~t" + astr_mspsdata.as_revision_no
		end if
		//Report type for archiving case
		if as_node_name = "REPORT_TYPE" then astr_mspsdata.as_report_type = as_leaf_value
		//Extract the sent date from XML file directly
		if as_node_name = "SENT_DATE_UTC" then astr_mspsdata.as_sent_date_utc = as_leaf_value
		//Extract the report date from XML file directly
		if as_node_name = "REPORT_DATE_UTC" then astr_mspsdata.as_report_date_utc = as_leaf_value
		//Extract the report No. from XML file directly
		if as_node_name = "REPORT_NO" then astr_mspsdata.as_report_no = as_leaf_value
		//Extract the vessel name from XML file directly
		if as_node_name = "VESSEL_NAME" then astr_mspsdata.as_vesselname = as_leaf_value
	case "HEATING"
		if as_node_name = "VOYAGE_NO" then astr_mspsdata.as_voyage_no = as_leaf_value
		wf_set_updatable("HEATING", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_heating += as_leaf_value + is_SPLIT_SIGN
	case "NOON"
		wf_set_updatable("NOON", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_noon += as_leaf_value + is_SPLIT_SIGN
	case "ARRIVAL"
		wf_set_updatable("ARRIVAL", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_arrival += as_leaf_value + is_SPLIT_SIGN
	case "LOADING"
		wf_set_updatable("LOADING", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_departure_load += as_leaf_value + is_SPLIT_SIGN
	case "DISCHARGING"
		wf_set_updatable("DISCHARGING", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_departure_discharge += as_leaf_value + is_SPLIT_SIGN
	case "CANAL"
		wf_set_updatable("CANAL", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_departure_canal += as_leaf_value + is_SPLIT_SIGN
	case "FWO_DRIFT"
		wf_set_updatable("FWO_DRIFT", as_node_name, as_leaf_value, astr_mspsdata)
		astr_mspsdata.as_drift += as_leaf_value + is_SPLIT_SIGN
	case "LOADING=TERMINALS"
		astr_mspsdata.ai_terminal_load_count ++
		//Dealing with multi rows
		if mod(astr_mspsdata.ai_terminal_load_count, ii_COLUMNS_TERMINAL) = 0 then
			if len(inv_stringfunctions.of_replace(astr_mspsdata.as_terminal_load, '~t', "")) = 0 then 
				astr_mspsdata.as_terminal_load = ""
			else
				astr_mspsdata.as_terminal_load += is_SPLIT_SIGN + as_leaf_value + is_SPLIT_SIGN + "1" + is_SPLIT_SIGN + astr_mspsdata.as_primary_key + "~r~n"
			end if
		else
			if astr_mspsdata.ai_terminal_load_count = 1 then
				astr_mspsdata.as_terminal_load += as_leaf_value
			elseif astr_mspsdata.ai_terminal_load_count > 1 and mod(astr_mspsdata.ai_terminal_load_count - 1, ii_COLUMNS_TERMINAL) = 0 then
				astr_mspsdata.as_terminal_load += as_leaf_value
			else
				astr_mspsdata.as_terminal_load += is_SPLIT_SIGN + as_leaf_value
			end if
		end if
	case "DISCHARGING=TERMINALS"
		astr_mspsdata.ai_terminal_discharge_count ++		
		//Dealing with multi rows
		if mod(astr_mspsdata.ai_terminal_discharge_count , ii_COLUMNS_TERMINAL) = 0 then
			if len(inv_stringfunctions.of_replace(astr_mspsdata.as_terminal_discharge, '~t', "")) = 0 then 
				astr_mspsdata.as_terminal_discharge = ""
			else
				astr_mspsdata.as_terminal_discharge += is_SPLIT_SIGN + as_leaf_value + is_SPLIT_SIGN + "0" + is_SPLIT_SIGN + astr_mspsdata.as_primary_key + "~r~n"
			end if
		else
			if astr_mspsdata.ai_terminal_discharge_count = 1 then
				astr_mspsdata.as_terminal_discharge += as_leaf_value
			elseif astr_mspsdata.ai_terminal_discharge_count > 1 and  mod(astr_mspsdata.ai_terminal_discharge_count - 1 , ii_COLUMNS_TERMINAL) = 0 then
				astr_mspsdata.as_terminal_discharge += as_leaf_value
			else
				astr_mspsdata.as_terminal_discharge += is_SPLIT_SIGN + as_leaf_value		
			end if
		end if
	case "LOADING=CARGO"
		astr_mspsdata.ai_cargo_count_load ++
		//Dealing with multi rows
		if mod(astr_mspsdata.ai_cargo_count_load, ii_COLUMNS_CARGO_LOAD) = 0 then
			if len(inv_stringfunctions.of_replace(astr_mspsdata.as_cargo_load, '~t', "")) = 0 then 
				astr_mspsdata.as_cargo_load = ""
			else
				astr_mspsdata.as_cargo_load += is_SPLIT_SIGN + as_leaf_value + is_SPLIT_SIGN + "1" + is_SPLIT_SIGN + astr_mspsdata.as_primary_key + "~r~n"
			end if
		else
			if astr_mspsdata.ai_cargo_count_load = 1 then
				astr_mspsdata.as_cargo_load += as_leaf_value
			elseif  ( astr_mspsdata.ai_cargo_count_load > 1 and mod(astr_mspsdata.ai_cargo_count_load - 1, ii_COLUMNS_CARGO_LOAD) = 0) then
				astr_mspsdata.as_cargo_load += as_leaf_value
			else
				astr_mspsdata.as_cargo_load += is_SPLIT_SIGN + as_leaf_value
			end if
		end if
	case "DISCHARGING=CARGO"
		astr_mspsdata.ai_cargo_count_discharge ++
		//Dealing with multi rows
		if mod(astr_mspsdata.ai_cargo_count_discharge, ii_COLUMNS_CARGO_DISCHARGE) = 0 then
			if len(inv_stringfunctions.of_replace(astr_mspsdata.as_cargo_discharge, '~t', "")) = 0 then 
				astr_mspsdata.as_cargo_discharge = ""
			else
				astr_mspsdata.as_cargo_discharge += is_SPLIT_SIGN + as_leaf_value + is_SPLIT_SIGN + "0" + is_SPLIT_SIGN + astr_mspsdata.as_primary_key + "~r~n"
			end if
		else
			if astr_mspsdata.ai_cargo_count_discharge = 1 then
				astr_mspsdata.as_cargo_discharge += as_leaf_value
			elseif astr_mspsdata.ai_cargo_count_discharge > 1 and mod(astr_mspsdata.ai_cargo_count_discharge - 1, ii_COLUMNS_CARGO_DISCHARGE) = 0 then
				astr_mspsdata.as_cargo_discharge += as_leaf_value
			else
				astr_mspsdata.as_cargo_discharge += is_SPLIT_SIGN + as_leaf_value
			end if
		end if
	case "NOON=TANKS"
		astr_mspsdata.ai_tank_list_count ++
		//Dealing with multi rows
		if mod(astr_mspsdata.ai_tank_list_count, ii_COLUMNS_TANK_LIST) = 0 then
			//No data in seemingly XML format file
			if len(inv_stringfunctions.of_replace(astr_mspsdata.as_tank_list, '~t', "")) = 0 then 
				astr_mspsdata.as_tank_list = ""
			else
				astr_mspsdata.as_tank_list += is_SPLIT_SIGN + as_leaf_value + is_SPLIT_SIGN + astr_mspsdata.as_primary_key + "~r~n"
			end if
		else
			if astr_mspsdata.ai_tank_list_count = 1 then
				astr_mspsdata.as_tank_list += as_leaf_value
			elseif astr_mspsdata.ai_tank_list_count > 1 and mod(astr_mspsdata.ai_tank_list_count - 1, ii_COLUMNS_TANK_LIST) = 0 then
				astr_mspsdata.as_tank_list += as_leaf_value
			else
				astr_mspsdata.as_tank_list += is_SPLIT_SIGN + as_leaf_value
			end if
		end if
end choose

return astr_mspsdata
end function

public function string wf_replace_confirmation (s_mspsdata astr_mspsdata, string as_mail_confirmation);/********************************************************************
   wf_replace_confirmation
   <DESC>	Replace label in confirmation section</DESC>
   <RETURN>	ls_mail_confirmation: Return the replaced string , if failed, 
				return blank string for no result to be appended
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/

as_mail_confirmation = inv_stringfunctions.of_replace(as_mail_confirmation, "${REPORT_DATE_UTC}", astr_mspsdata.as_report_date_utc)
as_mail_confirmation = inv_stringfunctions.of_replace(as_mail_confirmation, "${REPORT_NO}", astr_mspsdata.as_report_no)
as_mail_confirmation = inv_stringfunctions.of_replace(as_mail_confirmation, "${VESSEL_IMO}", astr_mspsdata.as_vessel_imo)
as_mail_confirmation = inv_stringfunctions.of_replace(as_mail_confirmation, "${REPORT_ID}", astr_mspsdata.as_report_id)
as_mail_confirmation = inv_stringfunctions.of_replace(as_mail_confirmation, "${REVISION_NO}", astr_mspsdata.as_revision_no)

return as_mail_confirmation
end function

public function s_mspsdata wf_get_mapping_key (s_mspsdata astr_mspsdata);/********************************************************************
   wf_get_mapping_key
   <DESC>	Get the mapping key from TRAMOS	</DESC>
   <RETURN>	str_tramos:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata: Reference info: voyage No. and vessel IMo No. for mapping key
   </ARGS>
   <USAGE>	For quick access to TRAMOS using SQL syntax directly	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
integer	li_vessel_nr
long		ll_vessel_imo
string	ls_voyage_nr, ls_voyage_nr_next

setnull(astr_mspsdata.ai_pcn)

//Get the VESSEL_NR by vessel IMO No.
ll_vessel_imo = long(astr_mspsdata.as_vessel_imo)
SELECT	max(VESSEL_NR)
INTO		:li_vessel_nr
FROM 		VESSELS
WHERE		IMO_NUMBER =:ll_vessel_imo;

//There is no this vessel IMO No. in tramos, it will be moved to rejection sub folder.
if li_vessel_nr >= 0 then
	astr_mspsdata.as_vessel_nr = string(li_vessel_nr)
else
	return astr_mspsdata
end if 

if astr_mspsdata.as_voyage_nr <> "" then
	SELECT	VOYAGE_NR
	INTO		:ls_voyage_nr
	FROM		PROCEED
	WHERE		VESSEL_NR = :li_vessel_nr And VOYAGE_NR = :astr_mspsdata.as_voyage_nr;
	if ls_voyage_nr = "" then
		setnull(astr_mspsdata.as_voyage_nr)
	else
		//Get PCN by vessel, voyage and port code.
		SELECT 	PCN
		INTO		:astr_mspsdata.ai_pcn
		FROM 		PROCEED 
		WHERE 	VESSEL_NR = :li_vessel_nr and VOYAGE_NR = :astr_mspsdata.as_voyage_nr and PORT_CODE = :astr_mspsdata.as_port_code;
		//If voyage No. dosn't exist in TRAMOS, clear voyage No. in structure
		if not (sqlca.sqlcode = 0) then
			if sqlca.sqlnrows = 0 then astr_mspsdata.as_port_code = ""
			if sqlca.sqlnrows <> 1 then setnull(astr_mspsdata.ai_pcn)
		end if		
	end if
end if

return astr_mspsdata
end function

public function integer wf_check_expired_days (s_mspsdata astr_mspsdata);/********************************************************************
   wf_check_expired_days
   <DESC>	Check sent date expiration	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata:XML file leaves value
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
datetime	ld_sent_date_utc, ld_datetime
mt_n_datefunctions lvo_date 

ld_sent_date_utc = datetime(astr_mspsdata.as_sent_date_utc)
ld_datetime = datetime(today(), now())
if lvo_date.of_getdaysbetween(ld_sent_date_utc, ld_datetime) > ii_expired then return c#return.Failure
return c#return.Success
end function

public function string wf_replace_package (string as_confirmation, string as_mail_package);/********************************************************************
   wf_replace_package
   <DESC>	Replace label in package section	</DESC>
   <RETURN>	ls_mail_package:Return the replaced string</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
datetime	ld_sent_date_utc

ld_sent_date_utc = datetime(today(), now())

as_mail_package = inv_stringfunctions.of_replace(as_mail_package, "${NUMBER}", "1")
as_mail_package = inv_stringfunctions.of_replace(as_mail_package, "${SENT_DATE_UTC}", string(ld_sent_date_utc, is_FORMAT_DATE_TIME))
as_mail_package = inv_stringfunctions.of_replace(as_mail_package, "${CONFIRMATIONS}", as_confirmation)

return as_mail_package
end function

public subroutine wf_set_mapping_key (s_mspsdata astr_mspsdata, ref mt_n_datastore ads_mspsdata);/********************************************************************
   wf_set_mapping_key
   <DESC>	Set mapping key to TRAMOS datastore	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		lstr_tramos: data structuer
		adlstr_tramos: TRAMOS datastore
   </ARGS>
   <USAGE>	Only for sub report, 
				e.g. noon, arrival, heating, load, discharge, canal, drift
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
ads_mspsdata.setitem( 1 ,"vessel_nr", integer(astr_mspsdata.as_vessel_nr))
ads_mspsdata.setitem( 1, "pcn", astr_mspsdata.ai_pcn)
end subroutine

public function integer wf_set_updatable (string as_route, string as_node_name, string as_leaf_value, ref s_mspsdata astr_mspsdata);/********************************************************************
   of_set_updatable
   <DESC>	Set the message section to be updatable	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_node_name: Node name
		as_leaf_value: Leaf value
		astr_mspsdata: TRAMOS structure
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-02-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
choose case as_route
	case "HEATING"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "HEATING", as_leaf_value) = c#return.Success then astr_mspsdata.ab_heating = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_heating = true
		end if
	case "NOON"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "NOON", as_leaf_value) = c#return.Success then astr_mspsdata.ab_noon = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_noon = true
		end if
	case "ARRIVAL"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "ARRIVAL", as_leaf_value) = c#return.Success then astr_mspsdata.ab_arrival = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_arrival = true
		end if
	case "LOADING"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "LOADING", as_leaf_value) = c#return.Success then astr_mspsdata.ab_departure_load = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_departure_load = true
		end if
	case "DISCHARGING"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "DISCHARGING", as_leaf_value) = c#return.Success then astr_mspsdata.ab_departure_discharge = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_departure_discharge = true
		end if
	case "CANAL"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "CANAL", as_leaf_value) = c#return.Success then astr_mspsdata.ab_departure_canal = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_departure_canal = true
		end if
	case "FWO_DRIFT"
		if as_node_name = "CHANGED" then
			if wf_check_change_flag(astr_mspsdata, "FWO_DRIFT", as_leaf_value) = c#return.Success then astr_mspsdata.ab_drift = true
		end if
		if as_node_name = "NEW" then
			if as_leaf_value = "1" then astr_mspsdata.ab_drift = true
		end if
end choose
return  c#return.Success
end function

public function datetime wf_get_departure_datetime (mt_n_datastore ads_message, mt_n_datastore ads_terminal);/********************************************************************
   wf_get_departure_datetime
   <DESC>	Get departure datetime from message	</DESC>
   <RETURN>	datetime:Latest datetime to be arrival datetime
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_message: Message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
mt_n_datefunctions	lnv_datefunctions
string					ls_dataobject
datetime					ldt_temp[]
integer					li_start, li_count, li_upperbound

ls_dataobject = ads_message.dataobject

choose case ls_dataobject
	case "d_sq_gr_canal"
		ldt_temp[1] = ads_message.getitemdatetime( 1, "anchored_aweigh_date_lt")
		ldt_temp[2] = ads_message.getitemdatetime( 1, "dropped_last_pilot_date_lt")
		ldt_temp[3] = ads_message.getitemdatetime( 1, "passage_commenced_date_lt")
	case "d_sq_gr_drift"
		ldt_temp[1] = ads_message.getitemdatetime( 1, "anchored_aweigh_date_lt")
		ldt_temp[2] = ads_message.getitemdatetime( 1, "stopped_drifting_date_lt")
		ldt_temp[3] = ads_message.getitemdatetime( 1, "passage_commenced_date_lt")
	case "d_sq_gr_load", "d_sq_gr_discharge"
		li_count = ads_terminal.rowcount( )
		for li_start = 1 to li_count
			li_upperbound = (li_start - 1) * 5 
			ldt_temp[1 + li_upperbound] = ads_terminal.getitemdatetime( li_start, "anchored_aweigh_date_lt")
			ldt_temp[2 + li_upperbound] = ads_terminal.getitemdatetime( li_start, "departed_berth_date_lt")
			ldt_temp[3 + li_upperbound] = ads_terminal.getitemdatetime( li_start, "dropped_last_pilot_date_lt")
			ldt_temp[4 + li_upperbound] = ads_terminal.getitemdatetime( li_start, "end_of_sea_passage_date_lt")
			ldt_temp[5 + li_upperbound] = ads_terminal.getitemdatetime( li_start, "ship_to_ship_date_lt") 
		next
end choose

return lnv_datefunctions.of_getlatestdate( ldt_temp )
end function

public function datetime wf_get_berthing_datetime (mt_n_datastore ads_message);/********************************************************************
   of_set_arrival_berthing_departure
   <DESC>	Get berthing datetime from message datawindow	</DESC>
   <RETURN>	datetime: Latest datetime to be berthing datetime	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_message: message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
mt_n_datefunctions	lnv_datefunctions
datetime					ldt_temp[]

ldt_temp[1] = ads_message.getitemdatetime(1, "all_fast_date_lt")
ldt_temp[2] = ads_message.getitemdatetime(1, "etb_all_fast_date_lt")

return lnv_datefunctions.of_getlatestdate( ldt_temp )
end function

public function datetime wf_get_arrival_datetime (mt_n_datastore ads_message);/********************************************************************
   of_set_arrival_berthing_departure
   <DESC>	Get arrival datetime from message datawindow	</DESC>
   <RETURN>	datetime: Earliest datetime to be arrival datetime	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_message: message datawindow
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-03-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
mt_n_datefunctions	lnv_datefunctions
string					ls_dataobject
datetime					ldt_temp[]

ls_dataobject = ads_message.dataobject

choose case ls_dataobject
	case "d_sq_gr_arrival"
		ldt_temp[1]  = ads_message.getitemdatetime( 1, "end_of_sea_passage_nor_lt") 
		ldt_temp[2]  = ads_message.getitemdatetime( 1, "anchored_nor_lt")
		ldt_temp[3]  = ads_message.getitemdatetime( 1, "anchored_aweigh_nor_lt")
		ldt_temp[4]  = ads_message.getitemdatetime( 1, "drifting_nor_lt")
		ldt_temp[5]  = ads_message.getitemdatetime( 1, "stopped_drifting_nor_lt")
		ldt_temp[6]  = ads_message.getitemdatetime( 1, "pilot_on_board_nor_lt")
		ldt_temp[7]  = ads_message.getitemdatetime( 1, "etb_all_fast_nor_lt")
		ldt_temp[8]  = ads_message.getitemdatetime( 1, "all_fast_nor_lt")
		ldt_temp[9]  = ads_message.getitemdatetime( 1, "anchored_date_lt")
		ldt_temp[10] = ads_message.getitemdatetime( 1, "drifting_date_lt")
		ldt_temp[11] = ads_message.getitemdatetime( 1, "end_of_sea_passage_date_lt") 
	case "d_sq_gr_canal", "d_sq_gr_drift"
		ldt_temp[1] = ads_message.getitemdatetime( 1, "anchored_date_lt")
		ldt_temp[2] = ads_message.getitemdatetime( 1, "drifting_date_lt")
		ldt_temp[3] = ads_message.getitemdatetime( 1, "end_of_sea_passage_date_lt") 		
end choose

return lnv_datefunctions.of_getearliestdate( ldt_temp )


end function

public function integer wf_get_archiving_key (ref s_mspsdata astr_mspsdata, string as_report_table_name, integer ai_load_or_discharge);/********************************************************************
   wf_get_archiving_key
   <DESC>	Get the max revision No. and report ID from the current report for archiving process	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata: XML file leaves value structure
		as_report_table_name: Report table name
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2011 CR20         JMY014             First Version
   	01/08/2013 CR3238       LHG008             Messages with status "Active" and "New" should be archived, 
                                        			 making sure that only the last revision of the message is active.
		04/09/2013 CR3238			LHC010				 Fix bug Canal message can't be archived.														  
   </HISTORY>
********************************************************************/

long 		ll_vessel_imo, ll_report_id, ll_revision_no, ll_revision_no_max, ll_report_id_max
string	ls_voyage_no, ls_sql

//Initialize the parameters
setnull(ll_revision_no_max)
setnull(ll_report_id_max)

//Get the primary key from structure
ll_vessel_imo  = long(astr_mspsdata.as_vessel_imo)
ll_report_id   = long(astr_mspsdata.as_report_id)
ll_revision_no = long(astr_mspsdata.as_revision_no)

choose case upper(as_report_table_name)
	case "MSPS_HEATING"
		ls_voyage_no = ids_heating.getitemstring(1, "voyage_no")
		//Get the max report ID and revision NO. from DB according to the same voyage NO.
		SELECT 	REPORT_ID, REVISION_NO
		INTO		:ll_report_id_max, :ll_revision_no_max
		FROM		MSPS_HEATING
		WHERE		MSPS_HEATING.VESSEL_IMO = :ll_vessel_imo And MSPS_HEATING.VOYAGE_NO = :ls_voyage_no AND (MSG_STATUS = 1 or MSG_STATUS = 6) //New and Active status
		USING		sqlca;
	case "MSPS_NOON"
		//Get max revision NO. from DB according to the report ID
		SELECT max(REVISION_NO)
		INTO   :ll_revision_no_max
		FROM   MSPS_NOON
		WHERE  MSPS_NOON.VESSEL_IMO = :ll_vessel_imo and MSPS_NOON.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "MSPS_ARRIVAL"
		//Get max revision NO. from DB according to the report ID
		SELECT max(REVISION_NO)
		INTO   :ll_revision_no_max
		FROM   MSPS_ARRIVAL
		WHERE  MSPS_ARRIVAL.VESSEL_IMO = :ll_vessel_imo and MSPS_ARRIVAL.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "MSPS_DEPARTURE"
		//Get max revision NO. from DB according to the report ID and load or discharge flag.
		SELECT max(REVISION_NO)
		INTO   :ll_revision_no_max
		FROM   MSPS_DEPARTURE
		WHERE  MSPS_DEPARTURE.VESSEL_IMO = :ll_vessel_imo and MSPS_DEPARTURE.REPORT_ID = :ll_report_id and MSPS_DEPARTURE.LOAD_OR_DISCHARGE = :ai_load_or_discharge
		USING  SQLCA;
	case "MSPS_FWO_DRIFT"
		//Get max revision NO. from DB according to the report ID
		SELECT max(REVISION_NO)
		INTO   :ll_revision_no_max
		FROM   MSPS_FWO_DRIFT
		WHERE  MSPS_FWO_DRIFT.VESSEL_IMO = :ll_vessel_imo and MSPS_FWO_DRIFT.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "MSPS_CANAL"
		//Get max revision NO. from DB according to the report ID
		SELECT max(REVISION_NO)
		INTO   :ll_revision_no_max
		FROM   MSPS_CANAL
		WHERE  MSPS_CANAL.VESSEL_IMO = :ll_vessel_imo and MSPS_CANAL.REPORT_ID = :ll_report_id
		USING  SQLCA;
end choose


if isnull(ll_revision_no_max) then ll_revision_no_max = 0

if isnull(ll_report_id_max) then ll_report_id_max = 0

if sqlca.sqlcode = -1 then  return c#return.Failure

//Get archiving key successfully
if sqlca.sqlcode = 0 then  
	astr_mspsdata.as_revision_no_max = string(ll_revision_no_max)
	astr_mspsdata.al_report_id_max = ll_report_id_max
end if

if sqlca.sqlcode = 100  then 
	astr_mspsdata.as_revision_no_max = "0"
	astr_mspsdata.al_report_id_max = 0
end if

return c#return.Success
end function

public function integer wf_set_archiving (s_mspsdata astr_mspsdata, string as_report_table_name, ref mt_n_datastore ads_mspsdata);/********************************************************************
   wf_set_archiving
   <DESC>	Archive the old version of tanker operation report at branch section	
				Compaired the max revision No. saved in TRAMOS for archiving process
				Dynamic SQL to update the sub report status to be archived
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		lstr_tramos:XML file data structure.
		as_report_table_name: Report table name
   </ARGS>
   <USAGE>	MSG_STATUS: 
								1: New
								2: Archive
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-12-2011 CR20         JMY014             First Version
   	01/08/2013 CR3238       LHG008             Messages with status "Active" and "New" should be archived, 
                                        			 making sure that only the last revision of the message is active.
		19/10/2013 CR3340			LHG008				 Fix error in archive message																  
   </HISTORY>
********************************************************************/

string 	ls_sql, ls_dataobject
boolean	lb_archive_heating

ls_dataobject = ads_mspsdata.dataobject

ads_mspsdata.setitem(1, "MSG_STATUS", 1)
//Current report version larger than historical report version, set histrical report to be archived in DB.
if ls_dataobject <> "d_sq_gr_heating" and astr_mspsdata.as_revision_no_max <> "0" and (long(astr_mspsdata.as_revision_no) > long(astr_mspsdata.as_revision_no_max)) then
	ls_sql = "Update " + as_report_table_name + " Set MSG_STATUS=2 " + &
				" Where REVISION_NO <=" + astr_mspsdata.as_revision_no_max + &
				" And VESSEL_IMO=" + astr_mspsdata.as_vessel_imo + &
				" And REPORT_ID=" + astr_mspsdata.as_report_id
				
	//Deal with load and discharge report
	if ls_dataobject = "d_sq_gr_load" then ls_sql +=  " And LOAD_OR_DISCHARGE =1 "
	if ls_dataobject = "d_sq_gr_discharge" then ls_sql += " And LOAD_OR_DISCHARGE =0 "
	
	//Only update report with "new" and active status 
	ls_sql += " And (MSG_STATUS=1 or MSG_STATUS=6) "
	execute immediate :ls_sql;
//Historical report record version larger than current report version,Set current report status to be archived.
elseif ls_dataobject <> "d_sq_gr_heating" and astr_mspsdata.as_revision_no_max <> "0" and (long(astr_mspsdata.as_revision_no) < long(astr_mspsdata.as_revision_no_max)) then 
	ads_mspsdata.setitem(1, "MSG_STATUS", 2)
//Deal with heating message
elseif ls_dataobject = "d_sq_gr_heating" then
	//Same report ID of heating message
	if string(astr_mspsdata.al_report_id_max) = astr_mspsdata.as_report_id then
		//Archive historical heating message that's revision NO. smaller than current revision NO.
		if astr_mspsdata.as_revision_no_max <> "0" and long(astr_mspsdata.as_revision_no_max) < long(astr_mspsdata.as_revision_no) then
			ls_sql = "Update " + as_report_table_name + " Set MSG_STATUS=2 " + &
					" Where VESSEL_IMO=" + astr_mspsdata.as_vessel_imo + &
					" And REPORT_ID =" + astr_mspsdata.as_report_id + &
					" And REVISION_NO =" + astr_mspsdata.as_revision_no_max + &
					" And VOYAGE_NO ='" + astr_mspsdata.as_voyage_no + "' AND (MSG_STATUS=1 or MSG_STATUS=6)"
		//Archive current heating message that's revision NO. larger than historical revision NO.
		elseif astr_mspsdata.as_revision_no_max <> "0" and long(astr_mspsdata.as_revision_no_max) > long(astr_mspsdata.as_revision_no) then
			ads_mspsdata.setitem(1, "MSG_STATUS", 2)
		end if
	//Archive historical heating message that's report ID smaller than current report ID
	elseif astr_mspsdata.al_report_id_max <> 0 and astr_mspsdata.al_report_id_max < long(astr_mspsdata.as_report_id) then
			ls_sql = "Update " + as_report_table_name + " Set MSG_STATUS=2 " + &
					" Where VESSEL_IMO=" + astr_mspsdata.as_vessel_imo + &
					" And REPORT_ID =" + string(astr_mspsdata.al_report_id_max) + &
					" And VOYAGE_NO ='" + astr_mspsdata.as_voyage_no + "' AND (MSG_STATUS=1 or MSG_STATUS=6)"
	//Archive current heating message that's report ID smaller than historical report ID
	elseif astr_mspsdata.al_report_id_max <> 0 and astr_mspsdata.al_report_id_max > long(astr_mspsdata.as_report_id) then
		ads_mspsdata.setitem(1, "MSG_STATUS", 2)
	end if
	if len(ls_sql) > 0 then	
		execute immediate :ls_sql;
	end if
end if

return c#return.Success
end function

public function integer wf_get_file_list (s_command_line astr_command_line, ref string as_files[]);/********************************************************************
   of_get_file_list
   <DESC>	Check in files into a string array from listbox control	
				NB:File option and folder option from command parameters could share the transfer process.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_command_line: Command line parameter structure
		as_files[]: Seemingly XML format file array.
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10-05-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
long 		li_start, li_count
string	ls_filename

//Single file
if astr_command_line.as_inputfile <> "" then
	//Check file sharing reading and checksum
	if inv_msps_interface.of_check_file(astr_command_line, astr_command_line.as_inputfile) = c#return.Failure then
		inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_CHECKSUM, "${FILE}", astr_command_line.as_inputfile))
		//Move file to failed folder
		if wf_move_xml(astr_command_line.as_inputfile, istr_command_line.as_folder_failed + "\" + ls_filename) = c#return.Failure then
			inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_FAILURE, "${FILE}", ls_filename))
		else
			inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_SUCCESS, "${FILE}", ls_filename))
		end if
	else
		//Keep the single file in the array
		as_files[1] = astr_command_line.as_inputfile
	end if
end if

//Multi files
if astr_command_line.as_inputfolder <> "" then
	//Check in files into listbox control from file system
	if lb_files.dirlist(astr_command_line.as_inputfolder + "\*." + is_SUFFIX, 1) then
		inv_msps_interface.of_write_log( is_DIRXML_SUCCESS)
	else
		inv_msps_interface.of_write_log( is_DIRXML_FAILURE)
		return c#return.Failure
	end if
	//Check in file(name) into string array from lixtbox control
	li_count = lb_files.totalitems()
	for li_start = 1 to li_count
		ls_filename = lb_files.text(li_start)
		//Check file sharing reading and checksum
		if inv_msps_interface.of_check_file(astr_command_line, astr_command_line.as_inputfolder + "\" + ls_filename) = c#return.Failure then
			inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_CHECKSUM, "${FILE}", ls_filename))
			//Move file to failed folder
			if wf_move_xml(astr_command_line.as_inputfolder + "\" + ls_filename, istr_command_line.as_folder_failed + "\" + ls_filename) = c#return.Failure then
				inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_FILE_MOVING_FAILURE, "${FILE}", ls_filename))
			else
				inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_FILE_MOVING_SUCCESS, "${FILE}", ls_filename))
			end if				
			continue
		//Save full path file name into string array
		else
			//Full path file name
			ls_filename = astr_command_line.as_inputfolder + "\" + ls_filename
			//Keep the file in the array exception on the same file for the previous single file
			if astr_command_line.as_inputfile <> "" then
				if as_files[1] <> ls_filename then as_files[upperbound(as_files) + 1] = ls_filename
			else
				as_files[upperbound(as_files) + 1] = ls_filename
			end if
		end if
	next
end if

if upperbound(as_files) = 0 then return c#return.Failure

return c#return.Success
end function

public function integer wf_set_transfer (string as_filename);/********************************************************************
   wf_set_transfer
   <DESC>	Assemble extracting and transfering seemingly XML format file data to TRAMOS	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_filename: Seemingly XML format data file
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	11-05-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
string	ls_mail_package, ls_mail_confirmation, ls_mail, ls_checksum, ls_mail_checksum
string	ls_filename
s_mspsdata	lstr_tramos
n_checksum	lnv_checksum


//Get the file name exclude the full path
ls_filename = mid(as_filename, lastpos(as_filename, "\") + len("\"))

lnv_checksum = create n_checksum

//Get the file name without path info
inv_msps_interface.of_write_log( as_filename + " would be transfered to TRAMOS.")

//Step 1. Reading the XML leaves value to string variables
try
	//XML data file format has been set up as UTF-8, so build the PBDOM doc object by file directly, or not by string:buildfromstring function
	i_pbdom_doc = i_pbdom_builder.buildfromfile(as_filename)
	//Extract leaves value to structure
	wf_set_leaf(i_pbdom_doc, lstr_tramos, "")
catch (throwable e1)
	//Write exception to log file, break the interface process directly.
	inv_msps_interface.of_write_log( "Build from file error: " + as_filename + " " + e1.getmessage())
	//Move file to failed folder
	if wf_move_xml(as_filename, istr_command_line.as_folder_failed + "\" + ls_filename) = c#return.Failure then
		inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_FAILURE, "${FILE}", as_filename))
	else
		inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_SUCCESS, "${FILE}", as_filename))
	end if
	return c#return.Failure
end try

//Step 2. Send mail process 
//Mail data creation
ls_mail_confirmation += wf_replace_confirmation(lstr_tramos, is_MAIL_CONFIRMATION)
//Email attachment data established.
ls_mail_package = wf_replace_package(ls_mail_confirmation, is_MAIL_PACKAGE)
//Generate the checksum to mail package
if lnv_checksum.of_generate_checksum(ls_mail_package, ls_checksum) = c#return.Success then
	inv_msps_interface.of_write_log( "Succeeded to generated the checksum No.")
	ls_mail_checksum = inv_stringfunctions.of_replace(is_MAIL_CHECKSUM, "${CHECKSUM}", ls_checksum)
	//Append package to checksum section, and create the mail attachment
	ls_mail = inv_stringfunctions.of_replace(ls_mail_checksum, "${PACKAGE}", ls_mail_package)
	//Send Email to MSPS user
	if inv_msps_interface.of_send_email(lstr_tramos, ls_mail, istr_command_line) = c#return.Success then
		inv_msps_interface.of_write_log( is_log_email_success)
	else
		inv_msps_interface.of_write_log( is_log_email_failure)
	end if
else
	inv_msps_interface.of_write_log( "Failed to generated the checksum No.")
end if

//Step 3. Transfer data to TRAMOS
//Get mapping key by primary key
lstr_tramos = wf_get_mapping_key(lstr_tramos)
//If the IMO No. is illegal, move the XML file rejected folder
if lstr_tramos.as_vessel_nr = "" then
	inv_msps_interface.of_write_log( "The vessel IMO No.: " + lstr_tramos.as_vessel_imo + " is not found in TRAMOS, the file:" + as_filename + " would be moved to rejected folder")
	//Move file, if rejected file exists, delete it, then move the file with same name again.
	if wf_move_xml(as_filename, istr_command_line.as_folder_rejected + "\" + ls_filename) = c#return.Failure then inv_msps_interface.of_write_log( "~tRejecting and moving file to sub folder error occured!")
	//Reject file and move file to rejected folder
	if wf_reject_xml(lstr_tramos)	= c#return.Success then
		inv_msps_interface.of_write_log(is_LOG_REJECT_SUCCESS)
	else
		inv_msps_interface.of_write_log(is_LOG_REJECT_FAILURE)
	end if
else
	//Check expired days of XML file,move the XML file to expried folder
	if wf_check_expired_days(lstr_tramos) = c#return.Failure then
		//Move file to expired folder
		if wf_move_xml(as_filename, istr_command_line.as_folder_expired + "\" + ls_filename) = c#return.Failure then
			inv_msps_interface.of_write_log( "Moving expired XML file: " + as_filename + " error occured. ")
		end if
		return c#return.Failure
	end if
	//Importing string values to datastore
	if wf_import_tramos(lstr_tramos) = c#return.Success then
		inv_msps_interface.of_write_log(is_LOG_TRAMOS_IMPORT_SUCCESS)
		//Saving XML data to database
		if wf_save_tramos(lstr_tramos) = c#return.Success then
			inv_msps_interface.of_write_log(is_LOG_TRAMOS_SAVE_SUCCESS)
			//If the succeeded folder provided, move file to the succeeded folder
			if (istr_command_line.as_folder_succeeded <> "") then
				//Move file to succeeded folder
				if wf_move_xml(as_filename, istr_command_line.as_folder_succeeded + "\" + ls_filename) = c#return.Failure then
					inv_msps_interface.of_write_log( "Moving succeeded XML file: " + as_filename + " error occured. ")
				end if
			else
				//Delete XML file, after saving the XML data to TRAMOS successfully
				if filedelete( as_filename ) then
					inv_msps_interface.of_write_log(is_LOG_DELETE_SUCCESS)
				else
					inv_msps_interface.of_write_log(is_LOG_DELETE_FAILUER)
				end if
			end if
		else
			//Wrote saving failed log
			inv_msps_interface.of_write_log(is_LOG_TRAMOS_SAVE_FAILURE)
			//Move XML file to failed folder.
			if wf_move_xml(as_filename, istr_command_line.as_folder_failed + "\" + ls_filename) = c#return.Failure then
				inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_FAILURE, "${FILE}", as_filename))
			else
				inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_SUCCESS, "${FILE}", as_filename))
			end if
		end if
	//Importing failed, moved the XML format data file to failed folder
	else
		//Move file to failed folder
		if wf_move_xml(as_filename, istr_command_line.as_folder_failed + "\" + ls_filename) = c#return.Failure then
			inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_FAILURE, "${FILE}", as_filename))
		else
			inv_msps_interface.of_write_log( inv_stringfunctions.of_replace(is_FILE_MOVING_SUCCESS, "${FILE}", as_filename))
		end if		
	end if
end if
return c#return.Success
end function

public function integer wf_reject_xml (s_mspsdata astr_mspsdata);/********************************************************************
   wf_reject_xml
   <DESC>	Reject the XML file to sub folder named "msps_rejected"	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata:	 Get the primary key from this structure
   </ARGS>
   <USAGE>	If the IMO No. dosn't exist, move the file to sub folder and 
				save successful info in database.
		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-12-2011 CR20         JMY014             First Version
		25/07/2013 CR3238       LHG008             Fix bug
   </HISTORY>
********************************************************************/

decimal	ld_report_id, ld_revision_no, ld_report_no
long		ll_vessel_imo
datetime ldt_today, ldt_sent_date_utc

//Write rejection info to database
ll_vessel_imo = long(astr_mspsdata.as_vessel_imo)
ld_report_id = dec(astr_mspsdata.as_report_id)
ld_report_no = dec(astr_mspsdata.as_report_no)
ld_revision_no = dec(astr_mspsdata.as_revision_no)
ldt_sent_date_utc = datetime(astr_mspsdata.as_sent_date_utc)
ldt_today = datetime(string(today(), is_FORMAT_DATE_TIME))

INSERT INTO MSPS_REJECTED(VESSEL_IMO, REPORT_ID, REVISION_NO, INSERT_DATE, SENT_DATE_UTC, REPORT_NO, VESSEL_NAME)
VALUES(:ll_vessel_imo, :ld_report_id, :ld_revision_no, :ldt_today, :ldt_sent_date_utc, :ld_report_no, :astr_mspsdata.as_vesselname);

commit using sqlca;

if sqlca.sqlcode <> 0 then	return c#return.Failure

return c#return.Success
end function

public function integer wf_move_xml (string as_src, string as_des);/********************************************************************
   wf_xml_move
   <DESC>	Move XML file from source folder to destination folder	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_src:Source folder and file full path name
		as_des:Destination folder and file full path name
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
if fileexists(as_des) then 
	if not filedelete(as_des) then return c#return.Failure
end if
if not filemove(as_src, as_des) = 1 then  return c#return.Failure

return c#return.Success

end function

public function integer wf_save_tramos (s_mspsdata astr_mspsdata);/********************************************************************
   wf_save_tramos
   <DESC>	Save data to TRAMOS	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		lstr_tramos
   </ARGS>
   <USAGE>	Using importstring() function of datawindow save data into TRAMOS automatically	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-12-2011 20           JMY014        First Version
		04-09-2013 CR3238			LHC010		  Fix bug Canal message can't be archived.
		08-01-2013 CR3240			LHC010		  Generate alerts.
   </HISTORY>
********************************************************************/
mt_n_datastore	lds_mspsdata[]		//Just for batch updating data to TRAMOS process
string 			ls_msgtype_array[]
integer			li_start, li_count

//Check update mark, if it is true, put it into updating datastore array and put message type into array ls_msgtype_array
lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_report
//When see report, copy the next port value to be current port.
if lower(trim(astr_mspsdata.as_report_type)) = "sea" then
	ids_report.setitem(1, "port_id", ids_report.getitemstring(1, "next_port_id"))
	ids_report.setitem(1, "port_code", ids_report.getitemstring(1, "next_port_code"))
	ids_report.setitem(1, "port_name", ids_report.getitemstring(1, "next_port_name"))
end if
//Noon
if astr_mspsdata.ab_noon then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_NOON", 0)
	wf_set_archiving(astr_mspsdata, "MSPS_NOON", ids_noon)
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_noon
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_tank_list
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_NOON
end if
//Heating
if astr_mspsdata.ab_heating then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_HEATING", 0)
	wf_set_archiving(astr_mspsdata, "MSPS_HEATING", ids_heating)
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_heating
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_HEATING
end if
//Arrival
if astr_mspsdata.ab_arrival then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_ARRIVAL", 0)
	wf_set_archiving(astr_mspsdata, "MSPS_ARRIVAL", ids_arrival)
	ids_arrival.setitem(1, "arrival_date", wf_get_arrival_datetime(ids_arrival))
	ids_arrival.setitem(1, "berth_date", wf_get_berthing_datetime(ids_arrival))
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_arrival
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_ARRIVAL
end if
//Load
if astr_mspsdata.ab_departure_load then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_DEPARTURE", 1)
	wf_set_archiving(astr_mspsdata, "MSPS_DEPARTURE", ids_departure_load)
	ids_departure_load.setitem(1, "departure_date", wf_get_departure_datetime(ids_departure_load, ids_terminal_load))
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_departure_load
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_terminal_load
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_cargo_load	
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_LOAD
end if
//Discharge
if astr_mspsdata.ab_departure_discharge then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_DEPARTURE", 0)
	wf_set_archiving(astr_mspsdata, "MSPS_DEPARTURE", ids_departure_discharge)
	ids_departure_discharge.setitem(1, "departure_date", wf_get_departure_datetime(ids_departure_discharge, ids_terminal_discharge))
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_departure_discharge
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_terminal_discharge
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_cargo_discharge
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_DISCHARGE
end if
//Canal
if astr_mspsdata.ab_departure_canal then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_CANAL", 0)
	wf_set_archiving(astr_mspsdata, "MSPS_CANAL", ids_departure_canal)
	ids_departure_canal.setitem(1, "arrival_date", wf_get_arrival_datetime(ids_departure_canal))
	//Terminal datawindow is useless.
	ids_departure_canal.setitem(1, "departure_date", wf_get_departure_datetime(ids_departure_canal, ids_terminal_discharge))
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_departure_canal
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_CANAL
end if
//Drift
if  astr_mspsdata.ab_drift then 
	//Executing Archiving process
	wf_get_archiving_key(astr_mspsdata, "MSPS_FWO_DRIFT", 0)
	wf_set_archiving(astr_mspsdata, "MSPS_FWO_DRIFT", ids_drift)
	ids_drift.setitem(1, "arrival_date", wf_get_arrival_datetime(ids_drift))
	//Terminal datawindow is useless.
	ids_drift.setitem(1, "departure_date", wf_get_departure_datetime(ids_drift, ids_terminal_discharge))
	lds_mspsdata[upperbound(lds_mspsdata) + 1] = ids_drift
	ls_msgtype_array[upperbound(ls_msgtype_array) + 1] = is_FWODRIFT
end if

//Saving to TRAMOS process
li_count = upperbound(lds_mspsdata)

for li_start = 1 to li_count
	if lds_mspsdata[li_start].update() <> 1 then
		inv_msps_interface.of_write_log(is_LOG_TRAMOS_UPDATE_FAILURE)
		rollback using sqlca;
		return c#return.Failure
	end if
next

inv_msps_interface.of_write_log(is_LOG_TRAMOS_UPDATE_SUCCESS)

commit using sqlca;

//Generate alerts
wf_generate_alerts(astr_mspsdata, ls_msgtype_array)

return c#return.Success

end function

public function integer wf_import_tramos (ref s_mspsdata astr_mspsdata);/********************************************************************
   wf_tramos_import
   <DESC>	Import string values to datawindow	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata: XML leaves string values structure
   </ARGS>
   <USAGE> The code is a mess, but the business logic is simple, 
				please read it carefully.	</USAGE>
   <HISTORY>
		Date			CR-Ref		Author		Comments
		12-12-2011	CR20			JMY014		First Version
		25/07/2013	CR3238		LHG008		Show carriage return in "notes"
   </HISTORY>
********************************************************************/
datetime ld_today
long		ll_return
string	ls_log_tramos_import_failure, ls_notes

ld_today = datetime(string(today(), is_FORMAT_DATE_TIME))
//Report
if astr_mspsdata.as_report <> "" then
	ids_report.reset()
	ll_return = ids_report.importstring( astr_mspsdata.as_report )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_report.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return c#return.Failure
	else
		//Get the port code, when see report, get from the next port.
		if lower(trim(astr_mspsdata.as_report_type)) = "sea" then
			astr_mspsdata.as_port_code = ids_report.getitemstring(1, "next_port_code")
		else
			astr_mspsdata.as_port_code = ids_report.getitemstring(1, "port_code")
		end if
		
		//Show carriage return
		ls_notes = ids_report.getitemstring(1, "notes")
		
		ls_notes = inv_stringfunctions.of_replace(ls_notes, is_SPECIALSTRING_R, "~r")
		ls_notes = inv_stringfunctions.of_replace(ls_notes, is_SPECIALSTRING_N, "~n")
		ids_report.setitem(1, "notes", ls_notes)
		
		ids_report.setitem(1, "create_date", ld_today )
	end if
end if
//Noon
ids_noon.reset()
if astr_mspsdata.ab_noon then
	ll_return = ids_noon.importstring( astr_mspsdata.as_noon + astr_mspsdata.as_primary_key )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_noon.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return c#return.Failure
	else
		ids_noon.setitem(1, "create_date", ld_today)
		//Tank list
		ids_tank_list.reset()
		if astr_mspsdata.as_tank_list <> "" then
			if ids_tank_list.importstring( astr_mspsdata.as_tank_list ) <= 0 then 
				ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_tank_list.classname())
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
				inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
				return c#return.Failure
			end if
		end if
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_noon.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_noon)
	end if
end if
//Heating
if astr_mspsdata.ab_heating then
	ids_heating.reset()
	ll_return = ids_heating.importstring( astr_mspsdata.as_heating + astr_mspsdata.as_primary_key )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_heating.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return c#return.Failure
	else
		ids_heating.setitem( 1, "create_date", ld_today )
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_heating.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_heating)
	end if
end if
//Arrival
if astr_mspsdata.ab_arrival then
	ids_arrival.reset()
	ll_return = ids_arrival.importstring( astr_mspsdata.as_arrival + astr_mspsdata.as_primary_key )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_arrival.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return c#return.Failure
	else
		ids_arrival.setitem( 1, "create_date", ld_today )
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_arrival.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_arrival)
	end if
end if
//Departure load,terminal and cargo
if astr_mspsdata.ab_departure_load then
	ids_departure_load.reset()
	ll_return = ids_departure_load.importstring(astr_mspsdata.as_departure_load + "1" + "~t" + astr_mspsdata.as_primary_key )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_departure_load.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return  c#return.Failure
	else
		ids_departure_load.setitem( 1, "create_date", ld_today )
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_departure_load.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_departure_load)
		ids_terminal_load.reset()
		if astr_mspsdata.as_terminal_load <> "" then
			ll_return = ids_terminal_load.importstring( astr_mspsdata.as_terminal_load )
			if ll_return <= 0 then
				ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_terminal_load.classname())
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
				inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
				return c#return.Failure
			end if
		end if
		ids_cargo_load.reset()
		if astr_mspsdata.as_cargo_load <> "" then
			ll_return = ids_cargo_load.importstring( astr_mspsdata.as_cargo_load )
			if ll_return <= 0 then
				ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_cargo_load.classname())
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
				inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
				return c#return.Failure
			end if
		end if
	end if
end if
//Departure discharge,terminal and cargo
if astr_mspsdata.ab_departure_discharge then
	ids_departure_discharge.reset()
	ll_return = ids_departure_discharge.importstring(astr_mspsdata.as_departure_discharge + "0" + "~t" + astr_mspsdata.as_primary_key )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_departure_discharge.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return  c#return.Failure
	else
		ids_departure_discharge.setitem( 1, "create_date", ld_today )
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_departure_discharge.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_departure_discharge)
		ids_terminal_discharge.reset()
		if astr_mspsdata.as_terminal_discharge <> "" then
			ll_return = ids_terminal_discharge.importstring( astr_mspsdata.as_terminal_discharge )
			if ll_return <= 0 then
				ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_terminal_discharge.classname())
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
				inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
				return c#return.Failure
			end if
		end if
		ids_cargo_discharge.reset()
		if astr_mspsdata.as_cargo_discharge <> "" then
			ll_return = ids_cargo_discharge.importstring( astr_mspsdata.as_cargo_discharge )
			if ll_return <= 0 then
				ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_cargo_discharge.classname())
				ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
				inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
				return c#return.Failure
			end if
		end if
	end if
end if
//Canal
if astr_mspsdata.ab_departure_canal then
	ids_departure_canal.reset()
	ll_return = ids_departure_canal.importstring( astr_mspsdata.as_departure_canal + astr_mspsdata.as_primary_key )
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_departure_canal.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return c#return.Failure
	else
		ids_departure_canal.setitem( 1, "create_date", ld_today )
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_departure_canal.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_departure_canal)
	end if
end if
//Drift
if astr_mspsdata.ab_drift then
	ids_drift.reset()
	ll_return = ids_drift.importstring( astr_mspsdata.as_drift + astr_mspsdata.as_primary_key ) 
	if ll_return <= 0 then
		ls_log_tramos_import_failure = is_LOG_TRAMOS_IMPORT_FAILURE
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${0}", ids_drift.classname())
		ls_log_tramos_import_failure = inv_stringfunctions.of_replace(ls_log_tramos_import_failure, "${1}", string(ll_return))
		inv_msps_interface.of_write_log( ls_log_tramos_import_failure)
		return c#return.Failure
	else
		ids_drift.setitem( 1, "create_date", ld_today )
		//Get and mapping key: VOYAGE_NR, PORT_CODE, PCN.
		astr_mspsdata.as_voyage_nr = ids_drift.getitemstring(1, "voyage_no")
		astr_mspsdata = wf_get_mapping_key(astr_mspsdata)
		wf_set_mapping_key(astr_mspsdata, ids_drift)
	end if
end if
return c#return.Success
end function

public function integer wf_connect_database ();/********************************************************************
   wf_connect_database
   <DESC>	Connect to database	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	06-12-2011 20           JMY014        First Version
   	09/01/2014 CR3240       LHG008        Init instance variables ib_rul_generatenotdefined
   </HISTORY>
********************************************************************/

if sqlca.dbhandle() = 0 then 
	connect using sqlca;
	if sqlca.sqlcode <> 0 then return c#return.Failure
end if
//Set transobjects to datastores
ids_report.settransobject(sqlca)
ids_arrival.settransobject(sqlca)
ids_noon.settransobject(sqlca)
ids_heating.settransobject(sqlca)
ids_departure_load.settransobject(sqlca)
ids_departure_discharge.settransobject(sqlca)
ids_departure_canal.settransobject(sqlca)
ids_drift.settransobject(sqlca)
ids_terminal_load.settransobject(sqlca)
ids_terminal_discharge.settransobject(sqlca)
ids_cargo_load.settransobject(sqlca)
ids_cargo_discharge.settransobject(sqlca)
ids_tank_list.settransobject(sqlca)
//Get the expired days from system option
SELECT	MSPS_EXPIRED, RUL_GENERATENOTDEFINED
INTO		:ii_expired, :ib_rul_generatenotdefined
FROM		SYSTEM_OPTION
WHERE		SYSTEM_OPTION_ID = 1
USING	sqlca;
sle_expired.text = string(ii_expired)

return c#return.Success

end function

public subroutine wf_disconnect_database ();/********************************************************************
   wf_database_disconnect
   <DESC>	Disconnect database and destroy the datastore object	</DESC>
   <RETURN>		</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	When close the window excute this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	22-12-2011 20           JMY014        First Version
   </HISTORY>
********************************************************************/
//Destroying the 13 datastores
destroy ids_report
destroy ids_noon
destroy ids_heating
destroy ids_arrival
destroy ids_departure_load
destroy ids_departure_discharge
destroy ids_departure_canal
destroy ids_drift
destroy ids_terminal_load
destroy ids_terminal_discharge
destroy ids_cargo_load
destroy ids_cargo_discharge
destroy ids_tank_list

disconnect using sqlca;

end subroutine

public function integer wf_set_route_stack (ref string as_route, string as_note);/********************************************************************
   wf_set_route_stack
   <DESC>	Reset the route path for second level data in XML data file
	
				e.g TERMINALS(MSPS_DEPARTURE_TERMINAL) and LOADING(MSPS_DEPARTURE) section data in XML data
	
				Because the position of XML data section is not standard:
	
				The LOADING or DISCHARGING section data in XML file is first level data.
				The TERMINALS sections data in XML file is second level data.
				If we put the TERMINALS section data at the end of node LOADING or DISCHARGING, 
				After reading TERMINALS section data, we begin to read another first level data,
				We don't need to reset the route path.
				
				Since LOADING section data is splited into two parts by TERMINALS section data in XML file,
				we have to reset the route path of some leaf values under TERMINALS node that belong to LOADING section,
				after reading TERMINALS section data in XML data file. 
				The node SHIP_TO_SHIP_VESSEL_NAME is after TERMINALS section in LOADING section, we reset the route path according to it.
				
				The example process is
				
				1. When reading the beginning of LOADING section data, the route path is LOADING
				2. When reading TERMINALS section data, the route path is LOADING=TERMINAL
				3. After reading TERMINALS section data, the route path must be reset to be LOADING again according to the node SHIP_TO_SHIP_VESSEL_NAME
				
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_route
		as_note
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-06-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
//The node name of loading terminal end
if as_note = "SHIP_TO_SHIP_VESSEL_NAME" then
	if as_route = "LOADING=TERMINALS" then 
		wf_eliminate_stack(2)
		as_route = "LOADING"
	end if
end if

//The node name of discharging terminal end 
if as_note = "HOSES_NUMBER" then
	if as_route = "DISCHARGING=TERMINALS" then 
		wf_eliminate_stack(2)
		as_route = "DISCHARGING"
	end if
end if

//The node name of discharging cargo or loading cargo end 
if as_note = "NUMBER_OF_STOPPAGES" then
	if as_route = "LOADING=CARGO" then 
		wf_eliminate_stack(2)
		as_route = "LOADING"
	end if
	if as_route = "DISCHARGING=CARGO" then 
		wf_eliminate_stack(2)
		as_route = "DISCHARGING"
	end if
end if

return c#return.Success
end function

public function integer wf_set_leaf (pbdom_object ao_node, ref s_mspsdata astr_mspsdata, string as_node_name);/********************************************************************
   wf_set_leaf
   <DESC>	Extact leaves value from XML format file	</DESC>
   <RETURN>	str_tramos:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		ao_node
		astr_mspsdata
		as_node_name
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	10-01-2012 20           JMY014       	First Version
   	25/07/2013 CR3238       LHG008       	Show carriage return in "notes"
   </HISTORY>
********************************************************************/
string 			ls_route
PBDOM_OBJECT 	lo_node[]			//Object node

string	ls_orginal_objtype, ls_node_leaf_value
long 		ll_loop, ll_count_node

try	
	// Get the childs of the current node
	ao_node.getcontent(lo_node[])
	ls_orginal_objtype = ao_node.getobjectclassstring()
	
	ll_count_node = upperbound(lo_node[])
	// If it is a leaf label node then there will be no child
	if isnull(lo_node) then ll_count_node = 0
	
	//Get the route value
	ls_route = wf_get_route()
	//Reset the route value when reatching the "TERMINALS/CARGO" end
	wf_set_route_stack(ls_route, ao_node.getname())
	
	if ll_count_node = 0 then
		//The node has no value
		if ls_orginal_objtype = "pbdom_element" then
			astr_mspsdata = wf_set_leaf_to_string(ls_route, as_node_name, ao_node.gettext(), astr_mspsdata)
		//The node has value
		elseif ls_orginal_objtype = "pbdom_text"  then
			ls_node_leaf_value = ao_node.gettext()
			//Clear tab char
			ls_node_leaf_value = inv_stringfunctions.of_replace(ls_node_leaf_value, '~t', "")
			
			//Keep carriage return for notes
			if upper(as_node_name) = "NOTES" then
				ls_node_leaf_value = inv_stringfunctions.of_replace(ls_node_leaf_value, '~r', is_SPECIALSTRING_R)
				ls_node_leaf_value = inv_stringfunctions.of_replace(ls_node_leaf_value, '~n', is_SPECIALSTRING_N)
			else
				if match(ls_node_leaf_value,"^[A-Za-z0-9]") then
					ls_node_leaf_value = inv_stringfunctions.of_replace(ls_node_leaf_value, '~r', " ")
					ls_node_leaf_value = inv_stringfunctions.of_replace(ls_node_leaf_value, '~n', " ")
				end if
			end if
			
			//Check the end char with no ~n(new line) and ~r(Carriage return) char, then wrote it in to leaf string value.
			if len(ls_node_leaf_value) > 0 and pos(ls_node_leaf_value, "~n") = 0 and pos(ls_node_leaf_value, "~r") = 0 then
				astr_mspsdata = wf_set_leaf_to_string(ls_route, as_node_name, ls_node_leaf_value, astr_mspsdata)
			end if
		end if
	// If it is not a leaf label node, recursive calling the function itself.
	else
		//Set up the node route stack
		as_node_name = ao_node.getname()
		wf_set_route_stack(as_node_name)
		for ll_loop = 1 to ll_count_node
			wf_set_leaf( lo_node[ll_loop], astr_mspsdata, as_node_name)
		next
	end if
catch ( PBDOM_EXCEPTION my_exp )
	inv_msps_interface.of_write_log( "Failed to extract the XML data file.")
	halt close
end try

return c#return.Success
end function

public function integer wf_eliminate_stack (integer as_start);/********************************************************************
   wf_eliminate_stack
   <DESC>	Clear the stack array.	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_start: Array start
		as_route_stack[] :Stack array
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	15-05-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
integer li_start, li_count

//Eliminate the tail stack value
li_count = upperbound(is_route_stack)
if li_count < 1 then return  c#return.Failure
for li_start = as_start to li_count
	is_route_stack[li_start] = ""
next
return c#return.Success
end function

public function integer wf_check_change_flag (s_mspsdata astr_mspsdata, string as_report_table_name, string as_changed_flag);/********************************************************************
   of_check_change_flag
   <DESC>	Check the change flag for XML section to be updatable	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata:MSPS structure data
		as_report_table_name: Table name
		as_changed_flag: Current chagned flag
   </ARGS>
   <USAGE>		</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-09-2012 20           JMY014        First Version
   </HISTORY>
********************************************************************/
integer	li_changed_flag, li_load_or_discharge
long 		ll_vessel_imo, ll_report_id

if as_changed_flag = "0" then return c#return.Failure

//Get the primary key from structure
ll_vessel_imo  = long(astr_mspsdata.as_vessel_imo)
ll_report_id   = long(astr_mspsdata.as_report_id)

choose case upper(as_report_table_name)
	case "CANAL"
		SELECT max(CHANGE_FLAG)
		INTO   :li_changed_flag
		FROM   MSPS_CANAL
		WHERE  MSPS_CANAL.VESSEL_IMO = :ll_vessel_imo and MSPS_CANAL.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "HEATING"
		SELECT max(CHANGE_FLAG)
		INTO   :li_changed_flag
		FROM   MSPS_HEATING
		WHERE  MSPS_HEATING.VESSEL_IMO = :ll_vessel_imo and MSPS_HEATING.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "NOON"
		SELECT max(CHANGE_FLAG)
		INTO   :li_changed_flag
		FROM   MSPS_NOON
		WHERE  MSPS_NOON.VESSEL_IMO = :ll_vessel_imo and MSPS_NOON.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "ARRIVAL"
		SELECT max(CHANGE_FLAG)
		INTO   :li_changed_flag
		FROM   MSPS_ARRIVAL
		WHERE  MSPS_ARRIVAL.VESSEL_IMO = :ll_vessel_imo and MSPS_ARRIVAL.REPORT_ID = :ll_report_id
		USING  SQLCA;
	case "DISCHARGING", "LOADING"
		if as_report_table_name = "LOADING" then li_load_or_discharge = 1
		if as_report_table_name = "DISCHARGING" then li_load_or_discharge = 0
		
		SELECT max(CHANGE_FLAG)
		INTO   :li_changed_flag
		FROM   MSPS_DEPARTURE
		WHERE  MSPS_DEPARTURE.VESSEL_IMO = :ll_vessel_imo and MSPS_DEPARTURE.REPORT_ID = :ll_report_id and MSPS_DEPARTURE.LOAD_OR_DISCHARGE = :li_load_or_discharge
		USING  SQLCA;
	case "FWO_DRIFT"
		SELECT max(CHANGE_FLAG)
		INTO   :li_changed_flag
		FROM   MSPS_FWO_DRIFT
		WHERE  MSPS_FWO_DRIFT.VESSEL_IMO = :ll_vessel_imo and MSPS_FWO_DRIFT.REPORT_ID = :ll_report_id
		USING  SQLCA;
end choose

if sqlca.sqlcode = -1 then  return c#return.Failure

//When existence changed flag version is smaller than current changed flag
if isnull(li_changed_flag) or li_changed_flag = 0 or li_changed_flag < integer(as_changed_flag) then return c#return.Success

return c#return.Failure
end function

public function integer wf_generate_alerts (s_mspsdata astr_mspsdata, string as_msgtype_array[]);/********************************************************************
   wf_generate_alerts
   <DESC>	Generate alerts	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_mspsdata:	XML file leaves value
		as_msgtype_array[]: Message type array
   </ARGS>
   <USAGE>	Call the function after msps data have saved successfully (ref: wf_save_tramos())	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		09/01/2014	CR3240	LHG008	First Version
   </HISTORY>
********************************************************************/

integer li_count
n_generate_alerts	lnv_alerts

for li_count = 1 to upperbound(as_msgtype_array)
	if lnv_alerts.of_generate_alerts(long(astr_mspsdata.as_vessel_imo), long(astr_mspsdata.as_report_id), long(astr_mspsdata.as_revision_no), as_msgtype_array[li_count], ib_rul_generatenotdefined) = c#return.success then
		inv_msps_interface.of_write_log("Suceeded in generating the alerts for " + as_msgtype_array[li_count] + " message.")
	else
		inv_msps_interface.of_write_log("Failed to generate the alerts for " + as_msgtype_array[li_count] + " message.")
	end if
next

return c#return.Success
end function

on w_msps_interface.create
int iCurrent
call super::create
this.lb_files=create lb_files
this.sle_exp=create sle_exp
this.st_exp=create st_exp
this.sle_expired=create sle_expired
this.st_expired=create st_expired
this.sle_receiver=create sle_receiver
this.sle_sender=create sle_sender
this.st_receiver=create st_receiver
this.st_sender=create st_sender
this.st_dirlog=create st_dirlog
this.sle_log=create sle_log
this.gb_ini=create gb_ini
this.ids_tank_list=create ids_tank_list
this.ids_cargo_discharge=create ids_cargo_discharge
this.ids_cargo_load=create ids_cargo_load
this.ids_terminal_discharge=create ids_terminal_discharge
this.ids_terminal_load=create ids_terminal_load
this.ids_drift=create ids_drift
this.ids_departure_canal=create ids_departure_canal
this.ids_departure_discharge=create ids_departure_discharge
this.ids_departure_load=create ids_departure_load
this.ids_arrival=create ids_arrival
this.ids_heating=create ids_heating
this.ids_noon=create ids_noon
this.ids_report=create ids_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_files
this.Control[iCurrent+2]=this.sle_exp
this.Control[iCurrent+3]=this.st_exp
this.Control[iCurrent+4]=this.sle_expired
this.Control[iCurrent+5]=this.st_expired
this.Control[iCurrent+6]=this.sle_receiver
this.Control[iCurrent+7]=this.sle_sender
this.Control[iCurrent+8]=this.st_receiver
this.Control[iCurrent+9]=this.st_sender
this.Control[iCurrent+10]=this.st_dirlog
this.Control[iCurrent+11]=this.sle_log
this.Control[iCurrent+12]=this.gb_ini
end on

on w_msps_interface.destroy
call super::destroy
destroy(this.lb_files)
destroy(this.sle_exp)
destroy(this.st_exp)
destroy(this.sle_expired)
destroy(this.st_expired)
destroy(this.sle_receiver)
destroy(this.sle_sender)
destroy(this.st_receiver)
destroy(this.st_sender)
destroy(this.st_dirlog)
destroy(this.sle_log)
destroy(this.gb_ini)
destroy(this.ids_tank_list)
destroy(this.ids_cargo_discharge)
destroy(this.ids_cargo_load)
destroy(this.ids_terminal_discharge)
destroy(this.ids_terminal_load)
destroy(this.ids_drift)
destroy(this.ids_departure_canal)
destroy(this.ids_departure_discharge)
destroy(this.ids_departure_load)
destroy(this.ids_arrival)
destroy(this.ids_heating)
destroy(this.ids_noon)
destroy(this.ids_report)
end on

event open;call super::open;string 	ls_files[]
long		li_start, li_count
string	ls_commandline	

//Register the log file service
inv_msps_interface = create n_msps_interface

//Initialize parameters from command line structure
ls_commandline = message.stringparm
if isnull(ls_commandline) or ls_commandline = "" then
	close(this)
	return
else
	//If any error occured close window and exist application
	if inv_msps_interface.of_get_parameters( istr_command_line, ls_commandline) = c#return.Failure then
		close(this)
		return
	end if
end if

i_pbdom_builder = create pbdom_builder

//Step 1. Start the transfering interface process
inv_msps_interface.of_write_log( is_LOG_INTERFACE_START)

//Step 2. Set working envrionment for running application
if not wf_initialize_parameters() = c#return.Success then 
	inv_msps_interface.of_write_log( is_LOG_INITIALIZATION_FAILURE)
else
	inv_msps_interface.of_write_log( is_LOG_INITIALIZATION_SUCCESS)
end if

//Step 3. Reading files from command line
if wf_get_file_list( istr_command_line, ls_files) = c#return.Failure then 
	inv_msps_interface.of_write_log( is_LOG_FILE_LIST)
	close(this)
	return
end if

//Step 4. Connect to database server
if wf_connect_database() = c#return.Success then
	inv_msps_interface.of_write_log( is_LOG_CONNECTION_SUCCESS)
else
	inv_msps_interface.of_write_log( is_LOG_CONNECTION_FAILURE)
	close(this)
	return
end if

//Step 5. Extract and transfer XML format file data to TRAMOS
li_count = upperbound(ls_files[])
for li_start = 1 to li_count
	if wf_set_transfer(ls_files[li_start]) = c#return.Failure then
		inv_msps_interface.of_write_log( "Extracting and transfering XML format file: " + ls_files[li_start] + "  to TRAMOS failed")
	end if
next

//Step 6. End the transfering interface process
inv_msps_interface.of_write_log( is_LOG_INTERFACE_END)

destroy inv_msps_interface

//Step 7. according to running mode for application termination
if istr_command_line.as_mode = "window" then	
	this.visible = true
else
	//Exit the application
	close(this)
	return
end if
end event

event close;call super::close;wf_disconnect_database()
end event

type lb_files from listbox within w_msps_interface
boolean visible = false
integer x = 1335
integer y = 16
integer width = 1061
integer height = 464
integer taborder = 10
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_exp from singlelineedit within w_msps_interface
integer x = 384
integer y = 144
integer width = 878
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_exp from statictext within w_msps_interface
integer x = 55
integer y = 144
integer width = 315
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Expired folder"
boolean focusrectangle = false
end type

type sle_expired from singlelineedit within w_msps_interface
integer x = 384
integer y = 64
integer width = 878
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_expired from statictext within w_msps_interface
integer x = 55
integer y = 64
integer width = 270
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Expired day"
boolean focusrectangle = false
end type

type sle_receiver from singlelineedit within w_msps_interface
integer x = 384
integer y = 384
integer width = 878
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_sender from singlelineedit within w_msps_interface
integer x = 384
integer y = 304
integer width = 878
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_receiver from statictext within w_msps_interface
integer x = 55
integer y = 384
integer width = 219
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Receiver"
boolean focusrectangle = false
end type

type st_sender from statictext within w_msps_interface
integer x = 55
integer y = 304
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sender"
boolean focusrectangle = false
end type

type st_dirlog from statictext within w_msps_interface
integer x = 55
integer y = 224
integer width = 242
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Log folder"
boolean focusrectangle = false
end type

type sle_log from singlelineedit within w_msps_interface
integer x = 384
integer y = 224
integer width = 878
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type gb_ini from groupbox within w_msps_interface
integer x = 18
integer width = 1280
integer height = 480
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parameters"
end type

type ids_tank_list from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_noon_tank"
end type

on ids_tank_list.create
call super::create
end on

on ids_tank_list.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_cargo_discharge from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_cargo_discharge"
end type

on ids_cargo_discharge.create
call super::create
end on

on ids_cargo_discharge.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_cargo_load from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_cargo_load"
end type

on ids_cargo_load.create
call super::create
end on

on ids_cargo_load.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_terminal_discharge from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_terminal"
end type

on ids_terminal_discharge.create
call super::create
end on

on ids_terminal_discharge.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_terminal_load from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_terminal"
end type

on ids_terminal_load.create
call super::create
end on

on ids_terminal_load.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_drift from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_drift"
end type

on ids_drift.create
call super::create
end on

on ids_drift.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_departure_canal from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_canal"
end type

on ids_departure_canal.create
call super::create
end on

on ids_departure_canal.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_departure_discharge from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_discharge"
end type

on ids_departure_discharge.create
call super::create
end on

on ids_departure_discharge.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_departure_load from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_load"
end type

on ids_departure_load.create
call super::create
end on

on ids_departure_load.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_arrival from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_arrival"
end type

on ids_arrival.create
call super::create
end on

on ids_arrival.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_heating from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_heating"
end type

on ids_heating.create
call super::create
end on

on ids_heating.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_noon from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_noon"
end type

on ids_noon.create
call super::create
end on

on ids_noon.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

type ids_report from mt_n_datastore within w_msps_interface descriptor "pb_nvo" = "true" 
string dataobject = "d_sq_gr_report"
end type

on ids_report.create
call super::create
end on

on ids_report.destroy
call super::destroy
end on

event dberror;inv_msps_interface.of_write_log(inv_stringfunctions.of_replace(is_LOG_TRAMOS_SAVE_FAILURE, "${1}", sqlerrtext))
return 1
end event

