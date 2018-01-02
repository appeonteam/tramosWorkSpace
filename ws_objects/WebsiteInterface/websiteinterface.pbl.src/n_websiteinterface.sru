$PBExportHeader$n_websiteinterface.sru
$PBExportComments$Web site interface main object
forward
global type n_websiteinterface from mt_n_nonvisualobject
end type
end forward

global type n_websiteinterface from mt_n_nonvisualobject
end type
global n_websiteinterface n_websiteinterface

type variables
SoapConnection		isoap_conn 
SoapConnection		isoap_conn_copy
end variables

forward prototypes
private subroutine of_writemessage (string as_message)
private subroutine documentation ()
private function string of_getfileextension (string as_filename)
private function string of_getfilename (string as_filename)
private subroutine of_prepare_certificatesfilename (ref datawindowchild adw_certificates)
public subroutine of_getchilditems ()
public function long of_getrowscount (long al_pcgroup)
public function boolean of_check_returnmessage (integer ai_type, string as_message)
public subroutine of_savecertificates2 (datawindowchild adwc_certificates)
private function boolean of_instantiateservice (ref powerobject ap_proxy, string as_ptype, string as_endpoint, long al_pcgroup, ref integer ai_allsuccess)
private function boolean of_instantiateservice2 (ref powerobject ap_proxy, string as_ptype, string as_endpoint, long al_pcgroup, ref integer ai_allsuccess)
public function integer of_start (s_updateflags astr_tasks)
public function integer of_savecerts (datawindowchild adwc_certificates, string as_destination_path, ref integer ai_allsuccess, s_updateflags astr_tasks)
end prototypes

private subroutine of_writemessage (string as_message);
end subroutine

private subroutine documentation ();/********************************************************************
   ObjectName: Non visual object - Website Interface
   
	<OBJECT>
		- of_start is the main function of the application WebSiteInterface

	</OBJECT>
	
   <USAGE>
		It reads the Profit Center Group congurations, creates the Position (d_sq_tb_positions) 
		and Fleet (d_sq_cm_fleet)  XML files, and sends the information to the web server
	</USAGE>
   
	<ALSO> </ALSO>

<HISTORY> 
   Date	      CR-Ref	 Author	Comments
   00/03/10    CR1722	JMC112
	08/04/2013  CR3178   ZSW001   Update gb_allsuccessfull as false if any error occur.
	08/02/16		CR4298	AGL027	Add connection details into the code
</HISTORY>    
********************************************************************/

end subroutine

private function string of_getfileextension (string as_filename);/********************************************************************
   Get File Extension - Not used
	
   <DESC>		</DESC>
	
   <RETURN> String - file extension	</RETURN>
				
   <ACCESS>	Public	</ACCESS>
	
   <ARGS>	as_filename: file name	</ARGS>
	
   <USAGE>	Not used </USAGE>
********************************************************************/


integer ii_pos
char lc_letter
string ls_extension

for ii_pos = len(as_filename)  to 1 step -1
	lc_letter = mid(as_filename,ii_pos,1)
	if lc_letter="." then
		return ls_extension
	else
		ls_extension = lc_letter + ls_extension
	end if
	
next
if len(ls_extension)>4 then ls_extension = ".pdf"

return ls_extension
end function

private function string of_getfilename (string as_filename);
/********************************************************************
  Get File Name

   <DESC> Replaces the spaces on strig file name for "_"	</DESC>

   <RETURN>	String: File Name 	</RETURN>
 
 	<ACCESS>	Private	</ACCESS>

   <ARGS>	as_filenmame: File Name	</ARGS>
					
   <USAGE>	Is called from:
		- of_prepare_certificatesfilename - replaces the file name on the certificates datawindow
	</USAGE>
********************************************************************/

integer ii_pos
char lc_letter
string ls_filename_clean

for ii_pos = len(as_filename)  to 1 step -1
	lc_letter = mid(as_filename,ii_pos,1)
 CHOOSE CASE lc_letter
		case " ", "@", "$", "%", "&"
			ls_filename_clean = "_" + ls_filename_clean
		case else 
			ls_filename_clean = lc_letter + ls_filename_clean
		end choose
	
next

return ls_filename_clean

end function

private subroutine of_prepare_certificatesfilename (ref datawindowchild adw_certificates);/********************************************************************
	Prepare Certificates File Name
	
   <DESC>	
		- Changes File Name: Vessel Name + Certificate file name
		- Uses function of_getfilename to replace the spaces to "_"
	</DESC>
   
	<RETURN>	</RETURN>
   <ACCESS>	Private	</ACCESS>
	
   <ARGS>	adw_certificates: Certificates data window	</ARGS>
	
   <USAGE>
		This function is used to change the file name on the datawindow certificates
	</USAGE>
********************************************************************/

long ll_row 
string ls_vesselname, ls_filename, ls_filename_final

for ll_row=1 to adw_certificates.rowcount( )
	ls_vesselname = adw_certificates.getitemstring( ll_row, "vessel_name")
	ls_filename = adw_certificates.getitemstring( ll_row, "file_name")
	ls_filename_final = ls_vesselname  + " " + ls_filename
	ls_filename_final = of_getfilename( ls_filename_final)
	adw_certificates.setitem( ll_row, "file_name_final",ls_filename_final)
next

end subroutine

public subroutine of_getchilditems ();
end subroutine

public function long of_getrowscount (long al_pcgroup);datastore	 ldw_fleetdetails

ldw_fleetdetails = Create datastore
ldw_fleetdetails.dataobject = "d_sq_tb_fleetdetails"
ldw_fleetdetails.settransobject(SQLCA)
ldw_fleetdetails.retrieve(al_pcgroup)

return ldw_fleetdetails.rowcount( )

end function

public function boolean of_check_returnmessage (integer ai_type, string as_message);
if ai_type = 1 then
	//Positions Message
	if Match(as_message, "positions xml parse finished;") = False then return False
	//if Match(as_message, "positions item count check finished;") = False then return False
	if Match(as_message, "positions timestamp check finished;") = False then return False
	if Match(as_message, "position items update finished;") = False then return False
	if Match(as_message, "Data Push Task List items update finished;") = False then return False
	if Match(as_message, "Tramos Logs list items update finished;") = False then return False
	
	return True
elseif ai_type = 2 then
	//Fleet Message
	if Match(as_message, "fleets xml parse finished;") = False then return False
	//if Match(as_message, "fleets item count check finished;") = False then return False
	//if Match(as_message, "fleets timestamp check finished;") = False then return False
	if Match(as_message, "newbuildings item count check finished;") = False then return False
	if Match(as_message, "Fleets item update finished;") = False then return False
	//if Match(as_message, "certificates item count check finished;") = False then return False
	if Match(as_message, "Fleet Certificates item update finished;") = False then return False
	if Match(as_message, "Fleets Tanks item update finished;") = False then return False
	if Match(as_message, "Special Features item update finished;") = False then return False
	if Match(as_message, "Data Push Task List item update finished;") = False then return False
	if Match(as_message, "Tramos Logs List items update finished;") = False then return False
	
	return True
else
	return False
end if
	

end function

public subroutine of_savecertificates2 (datawindowchild adwc_certificates);
end subroutine

private function boolean of_instantiateservice (ref powerobject ap_proxy, string as_ptype, string as_endpoint, long al_pcgroup, ref integer ai_allsuccess);
/********************************************************************
  Instantiate Service

   <DESC> Creates and validates the connection to the proxy service	</DESC>

   <RETURN>	Boolean:
            <LI> True ok
            <LI> False failed
	</RETURN>
 
 	<ACCESS>	Private 	</ACCESS>

   <ARGS>
		ap_proxy: Local proxy service object (s_webproxy.pbl - ws_tramosservice)
		as_ptype: Name of the local proxy service, used only for error tracking
	</ARGS>
					
   <USAGE>	Connection used to execute the web services		</USAGE>
********************************************************************/

integer li_rc, ll_return
string ls_Msg, ls_string

TRY 
	//if al_pcgroup = 2 then
	//	isoap_conn.SetBasicAuthentication ("apmdmz", "ahn001", "India123") //temporary
	//else
	//	isoap_conn.SetBasicAuthentication ("apmdmz", "TramosAdmin", "Hello2World")
		isoap_conn.SetBasicAuthentication ("apmdmz", "traadm", "Poiuytrewq10")
	//end if

	//	isoap_conn.UseIntegratedWindowsAuthentication (True)		//old

	// li_rc = isoap_conn.CreateInstance(ap_proxy, as_ptype, "http://maersktankerstst.apmoller.net/crude")
	if as_endpoint="" then
		li_rc = isoap_conn.CreateInstance(ap_proxy, as_ptype) 
	else
	  	li_rc = isoap_conn.CreateInstance(ap_proxy, as_ptype, as_endpoint) 
	end if

	 CHOOSE CASE li_rc
		CASE 100
			ls_Msg = "Invalid proxy name - " + as_ptype
		CASE 101
			ls_Msg = "Failed to create proxy"
		CASE 0
			ls_Msg = ""
		CASE ELSE
			ls_Msg = "Unknown error (" + String(li_rc) + ")"
	END CHOOSE
	
	if li_rc <> 0 then _addmessage( this.classdefinition, "of_instantiateservice()", "<Warning - Instantiate : Invocation Error: " +  ls_Msg + ">", "warning")
	
isoap_conn.settimeout( 1000000)

CATCH (RuntimeError runtimeerror)
	li_rc = -1
	ai_allsuccess = c#return.Failure
	_addmessage( this.classdefinition, "of_instantiateservice()", "<Warning - Instantiate : Runtime Error" +  runtimeerror.text + ">", "warning")
END TRY
 
RETURN (li_rc = 0)

end function

private function boolean of_instantiateservice2 (ref powerobject ap_proxy, string as_ptype, string as_endpoint, long al_pcgroup, ref integer ai_allsuccess);/********************************************************************
  Instantiate Service

   <DESC> Creates and validates the connection to the proxy service	</DESC>

   <RETURN>	Boolean:
            <LI> True ok
            <LI> False failed
	</RETURN>
 
 	<ACCESS>	Private 	</ACCESS>

   <ARGS>
		ap_proxy: Local proxy service object (s_webproxy.pbl - ws_tramosservice)
		as_ptype: Name of the local proxy service, used only for error tracking
	</ARGS>
					
   <USAGE>	Connection used to execute the web services		</USAGE>
********************************************************************/

integer li_rc, ll_return
string ls_Msg, ls_string

TRY 
//	if al_pcgroup = 1 or al_pcgroup = 3 then
//	isoap_conn_copy.SetBasicAuthentication ("apmdmz", "TramosAdmin", "Hello2World")
	isoap_conn_copy.SetBasicAuthentication ("apmdmz", "traadm", "Poiuytrewq10")
//	else
//		isoap_conn_copy.UseIntegratedWindowsAuthentication (True)		
//	end if

	// li_rc = isoap_conn_copy.CreateInstance(ap_proxy, as_ptype, "http://maersktankerstst.apmoller.net/crude")
	if as_endpoint="" then
		li_rc = isoap_conn_copy.CreateInstance(ap_proxy, as_ptype) 
	else
	  	li_rc = isoap_conn_copy.CreateInstance(ap_proxy, as_ptype, as_endpoint) 
	end if

	 CHOOSE CASE li_rc
		CASE 100
			ls_Msg = "Invalid proxy name - " + as_ptype
		CASE 101
			ls_Msg = "Failed to create proxy"
		CASE 0
			ls_Msg = ""
		CASE ELSE
			ls_Msg = "Unknown error (" + String(li_rc) + ")"
	END CHOOSE
	
	if li_rc <> 0 then _addmessage( this.classdefinition, "of_instantiateservice2()", "<Warning - Instantiate2 : Invocation Error: " +  ls_Msg + ">", "warning")

	
isoap_conn_copy.settimeout( 6000000)

CATCH (RuntimeError runtimeerror)
	li_rc = -1
	ai_allsuccess = c#return.Failure
	_addmessage( this.classdefinition, "of_instantiateservice2()", "<Warning - Instantiate2 :  Runtime Error" +  runtimeerror.text + ">", "warning")
END TRY
 
RETURN (li_rc = 0)

end function

public function integer of_start (s_updateflags astr_tasks);/********************************************************************
   of_start()
   <DESC>	Main function:
		- Reads Profit Center Group Configurations (web services and certificates folder path)
		- Connects to the web proxy (of_instantiateservice)
		- Prepares data (XML format) (uses of_prepare_certificatesfilename)
		- Call method UpdatePositions
		- Saves certificates in the web server (of_savecertificates)
		- Call method UpdateFleet
	</DESC>
	
   <RETURN>	</RETURN>
   <ACCESS>	Public	</ACCESS>
   <ARGS>	</ARGS>
	
   <USAGE>	This function is called from the application websiteinterface	</USAGE>
********************************************************************/

String 	ls_xml_positions, ls_xml_fleet
String 	ls_result, ls_pcgroupname,ls_pc_webservice_address, ls_filesfolder, ls_returnmsg
Integer	li_row, li_allsuccess = c#return.Success
Long		ll_countFleet, ll_pcgroup
Boolean	lb_success


ws_tramosservice lpx_service

datastore				ldw_positions, ldw_fleet
datastore				lds_websites
datawindowchild 	ldwc_cert, ldwc_fleetdetails

lds_websites = Create datastore
lds_websites.dataobject = "d_sq_tb_profitcentergroup"
lds_websites.settransobject(SQLCA)
lds_websites.retrieve( )

if lds_websites.rowcount( ) = 0 then return c#return.NoAction

for li_row = 1 to lds_websites.rowcount( )
	ll_pcgroup = lds_websites.getitemnumber( li_row, "pcgroup_id")
	ls_pcgroupname = lds_websites.getitemstring( li_row, "pcgroup_name")
	ls_pc_webservice_address = lds_websites.getitemstring( li_row, "website_services")
	ls_filesfolder = lds_websites.getitemstring( li_row, "website_files_folder")

	if ls_pc_webservice_address = "" then
		_addmessage( this.classdefinition, "of_start()", "<Warning - service is not instantiated " + ls_pcgroupname + " - Empty - Check Profit Center Group Configurations>", "warning")
		continue
	end if
	isoap_conn = CREATE SoapConnection
	_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : Instantiate starts >", "info")
	if of_instantiateservice(lpx_service, "ws_tramosservice",ls_pc_webservice_address, ll_pcgroup, li_allsuccess) = False then continue 
	_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : Instantiate ends >", "info")	
	
	//POSITIONS LIST
	if astr_tasks.b_update_positions then
		ldw_positions = Create datastore
		ldw_positions.dataobject = "d_sq_tb_positions"
		ldw_positions.settransobject(SQLCA)
		ldw_positions.retrieve(ll_pcgroup)
		 
		if ldw_positions.rowcount( ) > 0 then
			
			ldw_positions.saveas( "tmp/" + ls_pcgroupname + "_Positions_" + string(now(), "h") + ".xml", XML!, false)
			ls_xml_positions = ldw_positions.object.datawindow.data.xml
			TRY
				_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdatePositions Starts >", "info")	
				ls_returnmsg = lpx_service.updateposition( ls_xml_positions)	
				_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdatePositions Ends >", "info")				
				lb_success = of_check_returnmessage( 1, ls_returnmsg)
				if lb_success =True then
					_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdatePositions() Successful >", "info")				
				else
					_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdatePositions() Return= " + ls_returnmsg + ">", "info")				
				end if
				
			CATCH (Throwable t1)
				li_allsuccess = c#return.Failure
				_addmessage( this.classdefinition, "of_start()", "<Warning - " + ls_pcgroupname + " : UpdatePositions() Invocation ERROR -- " +  t1.GetMessage() + ">", "warning")				
			END TRY
			ls_xml_positions = ""
		end if
	end if // astr_tasks.b_update_positions

	// FLEET LIST
	if astr_tasks.b_update_fleet_list then
		ll_countFleet = of_getRowsCount(ll_pcgroup)
		if ll_countFleet > 0 then
			ldw_fleet = Create datastore
			ldw_fleet.dataobject = "d_sq_cm_fleet"
			ldw_fleet.settransobject(SQLCA)
			ldw_fleet.retrieve(ll_pcgroup)
			ldw_fleet.accepttext( )
	
			ldw_fleet.getChild("dw_certificates", ldwc_cert)
			of_prepare_certificatesfilename(ldwc_cert)
			ldw_fleet.saveas( "tmp/" + ls_pcgroupname + "_Fleet_" + string(now(), "h") + ".xml", XML!, false)
			ls_xml_fleet = ldw_fleet.object.datawindow.data.xml
			
			TRY
				// CERTIFICATES 
				if astr_tasks.b_update_certificates then
					if ldwc_cert.rowcount( ) > 0 and ls_filesfolder<>"" then
						ldwc_cert.accepttext( )
						_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : Certificates Export Start.... >", "info")
						of_savecerts(ldwc_cert, ls_filesfolder, li_allsuccess, astr_tasks)
						_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : Certificates Export End.... >", "info")
					end if
				end if // astr_tasks.b_update_certificates
				_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdateFleet Starts >", "info")				
				ls_returnmsg = lpx_service.updatefleet(ls_xml_fleet)			
				_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdateFleet Ends >", "info")
				lb_success = of_check_returnmessage( 2, ls_returnmsg)
				if lb_success = true then
					_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdateFleet() Successful >", "info")	
				else
					_addmessage( this.classdefinition, "of_start()", "<Warning - " + ls_pcgroupname + " : UpdateFleet() Return= " + ls_returnmsg + ">", "warning")
				end if
				
			CATCH (Throwable t2)
				_addmessage( this.classdefinition, "of_start()", "<Warning - " + ls_pcgroupname + " : UpdateFleet() Invocation ERROR - " +  t2.GetMessage() + ">", "warning")
				lb_success = false
			END TRY
			
			if lb_success = false then
				TRY
					//second try
					ls_returnmsg = lpx_service.updatefleet(ls_xml_fleet)			
					lb_success = of_check_returnmessage( 2, ls_returnmsg)
					if lb_success = true then
						_addmessage( this.classdefinition, "of_start()", "<Info - " + ls_pcgroupname + " : UpdateFleet() Second try Successful >", "info")
					else
						_addmessage( this.classdefinition, "of_start()", "<Warning - " + ls_pcgroupname + " : UpdateFleet() Second try Return= " + ls_returnmsg + ">", "warning")						
					end if
				CATCH (Throwable t3)
					li_allsuccess = c#return.Failure
					_addmessage( this.classdefinition, "of_start()", "<Warning - " + ls_pcgroupname + " : UpdateFleet() Invocation ERROR - " +  t3.GetMessage() + ">", "warning")											
				END TRY
			
			end if
			ls_xml_fleet = ""
		end if
	end if  // astr_tasks.b_update_fleet_list
	DESTROY isoap_conn
	
next

return li_allsuccess


end function

public function integer of_savecerts (datawindowchild adwc_certificates, string as_destination_path, ref integer ai_allsuccess, s_updateflags astr_tasks);
long ll_row, ll_certificateid
blob	lbl_doc
long ll_filehandle, ll_size, ll_total
string ls_filepath_array[] , ls_filename, ls_filedesc

n_fileattach_service	lnv_attservice
n_service_manager		lnv_servicemgr

ws_copy					lpx_service_copy
ws_fieldinformation	lws_fieldinfo
ws_fieldinformation	lws_fields_array[]
ws_copyresult 			lws_copyresult_array[], lws_copyres1, lws_copyres2


byte		lbyte_filearray[], empty []
long		ll_byte, ll_copyres
long 		li_rtn

//filter the updated certificates (added a configuration, import all or just the updated)
if not astr_tasks.b_update_all_certificates then
	adwc_certificates.setfilter("vessel_cert_file_updated_date >= datetime('" + gs_updatedate + "')")
	adwc_certificates.filter()
end if

ll_total = adwc_certificates.rowcount( )
if ll_total = 0 then
	_addmessage( this.classdefinition, "of_savecerts()", "<Info - Certificates don't need to be updated>", "nothing to do")
	return 0
end if


//Instantiate Service
isoap_conn_copy = CREATE SoapConnection

//as_destination_path = "https://edit.handytankers.com/"
if of_instantiateservice2(lpx_service_copy, "ws_copy", as_destination_path + "_vti_bin/copy.asmx", 0, ai_allsuccess) = False then return -1 

lws_fieldinfo = create ws_fieldinformation
_addmessage( this.classdefinition, "of_savecerts()", "<Info - number of files = " + string(ll_total) + ">", "alert")

lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")

for ll_row = 1 to ll_total 
	ls_filepath_array[1] = ""
	//save each certificate
	ll_certificateid = adwc_certificates.getitemnumber( ll_row, "file_id")
	ls_filename = adwc_certificates.getitemstring( ll_row, "file_name_final")
	ls_filedesc =  adwc_certificates.getitemstring( ll_row, "description")
	
	ls_filepath_array[1] = as_destination_path + "Lists/Fleet Certificates/" +  ls_filename //of_getfilename(ls_filename)

	if lnv_attservice.of_readblob("VESSEL_CERT_FILES", ll_certificateid, lbl_doc) = c#return.Failure then
		_addmessage( this.classdefinition, "of_savecerts()", "<Warning - '" + ls_filename + "' file id = " + string(ll_certificateid) + " could not be found>", "warning")		
	end if	
	
	lbyte_filearray = empty
	lbyte_filearray = GetByteArray(lbl_doc)
	
	_addmessage( this.classdefinition, "of_savecerts()", "<Info - bloblen=" + string(len(lbl_doc)) + ">", "alert")
	

	//mandatory
	lws_fieldinfo.id = "1d22ea11-1e32-424e-89ab-9fedbadb6ce1"
	lws_fieldinfo.ws_type = 5
	//not mandatory
	lws_fieldinfo.internalname = "ID"
	lws_fieldinfo.value = string(ll_certificateid)
	//Array
	lws_fields_array = { lws_fieldinfo}
	
	TRY
		lws_copyres1 = create ws_copyresult
		lws_copyres2 = create ws_copyresult
		lws_copyresult_array ={lws_copyres1, lws_copyres2}
		_addmessage( this.classdefinition, "of_savecerts()", "<Info - Start (" + string(ll_row) + "/" + string(ll_total) + ") file number = " + string(ll_certificateid) + ">", "alert")
		ll_copyres = lpx_service_copy.copyintoitems( ls_filename, ls_filepath_array, lws_fields_array, lbyte_filearray, lws_copyresult_array)
		_addmessage( this.classdefinition, "of_savecerts()", "<Info - Finish " + string(ll_certificateid) + ">", "alert")		
		
	CATCH (RuntimeError runtimeerror)
		ai_allsuccess = c#return.Failure
		_addmessage( this.classdefinition, "of_savecerts()", "<Error - copyintoitems : Runtime Error" +  runtimeerror.text + ">", "alert")
	END TRY

	if ll_copyres = 0 then
		if not (isnull(lws_copyresult_array[1].errormessage)) then
			_addmessage( this.classdefinition, "of_savecerts()", "<Error - copy operation failed with Code: " + string(lws_copyresult_array[1].errorcode) +" code: "+  lws_copyresult_array[1].errormessage + ">", "alert")			
		end if
	end if

	if mod(ll_row,50)=0 then
		_addmessage( this.classdefinition, "of_savecerts()", "<Info - SENT ....... " + string(ll_row) + ">", "alert")			
	end if
next 
_addmessage( this.classdefinition, "of_savecerts()", "<Info - number of updated certificates " + string(ll_total) + ">", "alert")			

DESTROY isoap_conn_copy

return 1
end function

on n_websiteinterface.create
call super::create
end on

on n_websiteinterface.destroy
call super::destroy
end on

