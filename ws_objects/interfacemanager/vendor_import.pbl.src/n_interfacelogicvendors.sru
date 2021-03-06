﻿$PBExportHeader$n_interfacelogicvendors.sru
$PBExportComments$inherited from n_interfacelogic foud inside main interfacemanager library.  This object is responsible for parsing Vednor XML received from AX; updating Tramos vendor tables (AGENTS/BROKERS/CHART/TCOWNERS) and inserting events inside VENDOR_LOG table.
forward
global type n_interfacelogicvendors from n_interfacelogic
end type
end forward

global type n_interfacelogicvendors from n_interfacelogic
end type
global n_interfacelogicvendors n_interfacelogicvendors

type variables
string is_postfixtemp = ".txt"
private mt_n_datastore _ids_event_log
private mt_n_datastore _ids_vendors[]
end variables

forward prototypes
public function integer of_go (ref s_interface astr_interfaces[])
public subroutine documentation ()
private function integer _parse_vendor_xml (string as_workingfilepath, ref string as_statusmessage)
public function integer _register_vendors (string as_sourcedataobject)
public function integer _is_vendor_actively_used (s_vendor astr_vendor, string as_vendor_type, ref string as_additional_info)
private function string _get_last_word (string as_text, string as_delimiter)
private function integer _insert_event_into_vendor_log (string as_vendor_type, string as_additional_info, string as_event_type, s_vendor astr_vendor)
private function integer _modify_vendor_rows (ref mt_n_datastore ads_vendor, ref s_vendor astr_vendor)
end prototypes

public function integer of_go (ref s_interface astr_interfaces[]);/********************************************************************
   of_go()
   <DESC>	The main process</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>

   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date        CR-Ref   Author    	Comments
	20/04/2017	 	CR4603	AGL027		Intergrated into Interface Manager
   </HISTORY>
********************************************************************/

long 		ll_return
integer  li_fileindex
string	ls_errortext, ls_archivefilepath, ls_workingfilepath, ls_errorfilepath, ls_errorpath, ls_foundfilepath, ls_newfiles[]
string 	ls_filename = "", ls_statusmsg = "", ls_vendor_type
long ll_vendor_index, ll_update_vendors_flag, ll_update_log_flag
long ll_modified_counters[] = {0,0,0,0}, ll_source_index 



if of_outstandingfiles(astr_interfaces[1], "*.xml", ls_newfiles) = 0 then return c#return.NoAction

/* validate connection */
if sqlca.sqlcode <> 0 then
		of_writetolog("critical database error, unable to connect to database. sqlcode="+string(sqlca.sqlcode) + " sqlerrtext='" + sqlca.sqlerrtext + "'",ii_LOG_IMPORTANT)
	sqlca.of_rollback()
	sqlca.of_disconnect()
	return c#return.Failure
end if
sqlca.of_commit()

_ids_event_log = create mt_n_datastore
_ids_event_log.dataobject = "d_sq_gr_vendor_log"
_ids_event_log.settransobject(sqlca)

_register_vendors( "d_sq_gr_vendor_update_agents")
_register_vendors( "d_sq_gr_vendor_update_brokers")
_register_vendors( "d_sq_gr_vendor_update_chart")
_register_vendors( "d_sq_gr_vendor_update_tcowners")

li_fileindex = 1
of_writetolog("info, Tramos has received " + string(upperbound(ls_newfiles)) + " vendors." ,ii_LOG_NORMAL)
ls_errorpath = astr_interfaces[1].s_folderout
if right(astr_interfaces[1].s_folderout,1) <> "\" then
	ls_errorpath += "\"
end if	
do while li_fileindex <= upperbound(ls_newfiles)
	of_writetolog("info, vendor source file " + ls_newfiles[li_fileindex] + " (" + string(li_fileindex) + " of " + string(upperbound(ls_newfiles)) + ")" ,ii_LOG_NORMAL )	
	ls_foundfilepath = astr_interfaces[1].s_folderlocation + ls_newfiles[li_fileindex]
	ls_workingfilepath = astr_interfaces[1].s_folderworking + ls_newfiles[li_fileindex]
	ls_archivefilepath = astr_interfaces[1].s_folderarchive + ls_newfiles[li_fileindex]
	// folder_out is used for this interface as the error folder.
	ls_errorfilepath = ls_errorpath + ls_newfiles[li_fileindex]
	// what about error path
	if of_filemove(ls_foundfilepath,ls_workingfilepath,"") = c#return.Success then
		/* TODO new block needed here */
		if _parse_vendor_xml(ls_workingfilepath, ls_statusmsg)=c#return.Success then
			// if successful in update we move the file to ARCHIVE
			if of_filemove(ls_workingfilepath,ls_archivefilepath, "") = c#return.Success then
				of_writetolog("info, moved file from working folder to archive ",ii_LOG_NORMAL)
			end if	
		else
			// otherwise we move it to ERROR
			if of_filemove(ls_workingfilepath,ls_errorfilepath, "") = c#return.Success then
				of_writetolog("error, unable to parse xml, moved file from working folder to archive ",ii_LOG_NORMAL)
				if of_sendmail( C#EMAIL.TRAMOSSUPPORT, gs_emailto, "TIM Error Alert - Issue reading vendor data from AX", "AX Source file located " + ls_errorfilepath + " generated by AX system could not be read by the Tramos interface manager.  Please follow-up.", ls_errortext) = c#return.Failure then
					of_writetolog("error, could not send email!",ii_LOG_NORMAL)
				else
					of_writetolog("info, sent email message to user " + gs_emailto,ii_LOG_NORMAL)
				end if					
			end if	
		end if
	end if
	li_fileindex ++
loop

/* now all files have been processed - we need to update and commit them to the db */
ll_vendor_index = 0
do until ll_vendor_index = 4
	ll_vendor_index ++
	ls_vendor_type = upper(_get_last_word(_ids_vendors[ll_vendor_index].dataobject,"_"))
	of_writetolog(string(_ids_vendors[ll_vendor_index].modifiedcount()) + " Vendors records modified inside " + ls_vendor_type, ii_LOG_NORMAL)
	if _ids_vendors[ll_vendor_index].modifiedcount() > 0 then
		ll_update_vendors_flag = _ids_vendors[ll_vendor_index].update( true, false )
		if ll_update_vendors_flag <> 1 then
			of_writetolog("error, cannot update " + ls_vendor_type + " code = " + string(ll_update_vendors_flag), ii_LOG_NORMAL)
			rollback using SQLCA;
			return c#return.Failure
		end if	
	end if
loop

/* now try and update the event log */
ll_update_log_flag = _ids_event_log.update(true,false)
if ll_update_log_flag = 1 then
	/* both the target data updates and the log has updated successfully */
	commit using SQLCA;		
else 
	of_writetolog("error, cannot update VENDOR_LOG; code = " + string(ll_update_vendors_flag), ii_LOG_NORMAL)
	rollback using SQLCA;
	return c#return.FAilure
end if

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   ObjectName: n_interfacelogicvendors
	
	<OBJECT>
		business logic handling vendor XML file processing
	</OBJECT>
  	<DESC>
		Event Description
	</DESC>
   <USAGE>
		Object Usage.
	</USAGE>
   <ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author	Comments
	28/04/2017		CR4603	AGL027	Phase I of II regarding improving the quality of master data inside Tramos and interfacing with AX.
												Starting with replacing BlockedVendor process that interfaces with soon to be obsolete RFMP group system
	05/05/2017		CR4603	AGL027	Fix some minor issues - set all email body content to html.
	19/05/2017		CR4603	AGL027	Resolve issue with error folder and file name to include '\'
********************************************************************/
end subroutine

private function integer _parse_vendor_xml (string as_workingfilepath, ref string as_statusmessage);/********************************************************************
_parse_vendor_xml( /*string as_workingfilepath*/, /*ref string as_statusmessage */)

<DESC>
	per XML file received, read selected elements and then pass out to modify method to set the data.
	no updates are managed here, they are controlled by the calling process of_go()
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success - if data is
		<LI> 0, X NoAction - if vendor is proven not to be found a mail is generated as notification before this value is returned
		<LI> -1, X Failed - if there is any problem reading the XML file we return false.
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_workingfilepath: XML file path and name
	as_statusmessage: error or success message that will be written to the log text file
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

//TODO - update of data not working with more than 1 file
//LOOP not working

oleobject	lobj_xsd, lobj_xml, lole_domnodelist, lole_domcurnode				
string 		ls_nodevalue,ls_nodename, ls_emailstatusmessage="", ls_additional_info="", ls_mailbody, ls_main_address_node_name, ls_main_address_node_value, ls_mainaddress
integer 		li_return, li_title_spacer
long 			ll_contactlist_item, ll_elements_in_contacts, ll_selected_element, ll_vendor_index, ll_elements_in_main_address, ll_selected_main_address_element
boolean 		lb_valid_xml
s_vendor 	lstr_vendor, lstr_empty
constant integer li_SPACER=30


lobj_xml = create oleobject
li_return = lobj_xml.connecttonewobject("Msxml2.DOMDocument")

if li_return <> 0 then
	as_statusmessage = "Connection Error, Unable to connect to the OLE object.~r~n~r~nError code = '" + String(li_return) + "'"
	return c#return.Failure
end if

lobj_xml.Async = false
lobj_xml.ValidateonParse = true
 
lb_valid_xml = lobj_xml.load(as_workingfilepath)

if lobj_xml.parseerror.errorCode <> 0  then
	as_statusmessage = "Parse Error, " + string(lobj_xml.parseerror.reason)
	return c#return.Failure
end if

lole_domnodelist = lobj_xml.getElementsByTagName("ContactList")
lole_domcurnode = lole_domnodelist.nextNode

lstr_vendor.s_source_ref = _get_last_word(as_workingfilepath,"\")

/* the XSD file allows the possibly that the XML contains more than one vendor */
for ll_contactlist_item = 0 to lole_domcurnode.childNodes.Length - 1
	
	lstr_vendor = lstr_empty
	
	ll_elements_in_contacts = lole_domcurnode.childNodes(ll_contactlist_item).childNodes.length - 1
	for ll_selected_element = 0 to ll_elements_in_contacts
		ls_nodename  = lole_domcurnode.childNodes(ll_contactlist_item).childNodes.Item(ll_selected_element).nodeName
		ls_nodevalue = lole_domcurnode.childNodes(ll_contactlist_item).childNodes.Item(ll_selected_element).text	
		
		CHOOSE CASE ls_nodename
			CASE 'Name1'
				lstr_vendor.s_n_1 = ls_nodevalue
			CASE 'SupplierCode'
				lstr_vendor.s_nom_acc_nr = ls_nodevalue
			CASE 'IsBlocked'	
				// possible value in XML might be 1 or 0; not true/false
				if lower(ls_nodevalue) = "true" then
					lstr_vendor.i_isblocked=1
				else 	
					lstr_vendor.i_isblocked=0
				end if
			CASE 'BlockedReason'
				lstr_vendor.s_blockedreason = ls_nodevalue
			CASE 'MainAddress'	
				ll_elements_in_main_address = lole_domcurnode.childNodes(ll_contactlist_item).childNodes(ll_selected_element).childNodes.length - 1
				for ll_selected_main_address_element = 0 to ll_elements_in_main_address
					ls_main_address_node_name  = lole_domcurnode.childNodes(ll_contactlist_item).childNodes(ll_selected_element).childNodes.Item(ll_selected_main_address_element).nodeName
					ls_main_address_node_value = lole_domcurnode.childNodes(ll_contactlist_item).childNodes(ll_selected_element).childNodes.Item(ll_selected_main_address_element).text	
					CHOOSE CASE ls_main_address_node_name
						CASE 'Line1'
							lstr_vendor.str_mainaddress.s_line1 = ls_main_address_node_value
						CASE 'Line2'
							lstr_vendor.str_mainaddress.s_line2 = ls_main_address_node_value
						CASE 'Line3'
							lstr_vendor.str_mainaddress.s_line3 = ls_main_address_node_value
						CASE 'Telephone'							
							lstr_vendor.str_mainaddress.s_telephone = ls_main_address_node_value
						CASE 'CityName'
							lstr_vendor.str_mainaddress.s_cityname = ls_main_address_node_value
						CASE 'Email'
							lstr_vendor.str_mainaddress.s_email = ls_main_address_node_value
						CASE 'CountryCode'
							lstr_vendor.str_mainaddress.s_countrycode = ls_main_address_node_value
					END CHOOSE		
				next
		END CHOOSE
	next
	
	lstr_vendor.dt_blocked_date = datetime(today(),now())

	for ll_vendor_index = 1 to upperbound(_ids_vendors)
		if _modify_vendor_rows(_ids_vendors[ll_vendor_index], lstr_vendor) = c#return.Failure then
			of_writetolog("error, unable to set data inside " + _get_last_word(_ids_vendors[ll_vendor_index].dataobject,"_") + " for vendor with 'Nom Acc Nr'=" + lstr_vendor.s_nom_acc_nr + ". " , ii_LOG_NORMAL)
		end if	
	next	
	
	/* does vendor exist already in Tramos? if it does not send email notification to user responsible for maintaining vendor data */
	if lstr_vendor.b_found = false then
		/* here we must log the vendor that has not been found into the VENDOR_LOG */
		
		ls_mainaddress = lstr_vendor.str_mainaddress.s_line1
		if not isnull(lstr_vendor.str_mainaddress.s_line2) then ls_mainaddress += "<br/>" + lstr_vendor.str_mainaddress.s_line2
		if not isnull(lstr_vendor.str_mainaddress.s_line3) then ls_mainaddress += "<br/>" + lstr_vendor.str_mainaddress.s_line3
		if not isnull(lstr_vendor.str_mainaddress.s_cityname) then ls_mainaddress += "<br/>" + lstr_vendor.str_mainaddress.s_cityname
		if not isnull(lstr_vendor.str_mainaddress.s_countrycode) then ls_mainaddress += "<br/>" + lstr_vendor.str_mainaddress.s_countrycode
		
		ls_mailbody = "<html><body>The following vendor(s) which had been modified in AX could not be found in Agents, Brokers, Charterers or TC Owners system tables.<br/><br/>" + &
			"<table width='100%'>" + &
			"<tr><td width='30%'>" + "Nominal account number:" + "</td><td width='70%'>" + lstr_vendor.s_nom_acc_nr + "</td></tr>" + &
			"<tr><td>" + "Name:" + "</td><td>" + lstr_vendor.s_n_1 + "</td></tr>" + &
			"<tr><td valign='top'>" + "Address:" + "</td><td>" + ls_mainaddress + "</td></tr>" + &
			"<tr><td>" + "Telephone:" + "</td><td>" + lstr_vendor.str_mainaddress.s_telephone + "</td></tr>" + &
			"<tr><td>" + "Email:" + "</td><td>" + lstr_vendor.str_mainaddress.s_email + "</body><html>" 			
		
		if of_sendmail(C#EMAIL.TRAMOSSUPPORT, gs_vendor_mailto, "TRAMOS - Vendor not found in system tables", ls_mailbody, ls_emailstatusmessage) = c#return.Success then
			ls_additional_info = "Vendor Name: " + lstr_vendor.s_n_1 + " not found inside Tramos.  Mail sent to " + gs_vendor_mailto   
			_insert_event_into_vendor_log("",ls_additional_info,"not_found",lstr_vendor)
			of_writetolog(lstr_vendor.s_nom_acc_nr + " not found inside Tramos.  email sent to " + gs_vendor_mailto,ii_LOG_NORMAL)			
		else
			ls_additional_info = "Vendor Name: " + lstr_vendor.s_n_1 + " not found inside Tramos.  Failed to send mail to " + gs_vendor_mailto   
			_insert_event_into_vendor_log("" ,ls_additional_info, "not_found",lstr_vendor)
			of_writetolog("error, unable to send email to " + gs_vendor_mailto + " informing them of vendor not existing inside Tramos. Vendor 'Nom Acc Nr'=" + lstr_vendor.s_nom_acc_nr, ii_LOG_NORMAL)			
		end if			
		// return c#return.NoAction
	end if
	of_writetolog("results, nom_acc_nr=" + lstr_vendor.s_nom_acc_nr + ";IsBlocked=" + string(lstr_vendor.i_isblocked) + ";Name1=" + lstr_vendor.s_n_1 ,ii_LOG_DEBUG)
next

return c#return.Success
end function

public function integer _register_vendors (string as_sourcedataobject);integer ll_vendor_index

ll_vendor_index = upperbound(_ids_vendors) + 1

_ids_vendors[ll_vendor_index] = create mt_n_datastore
_ids_vendors[ll_vendor_index].dataobject = as_sourcedataobject
_ids_vendors[ll_vendor_index].settransobject(sqlca)
_ids_vendors[ll_vendor_index].retrieve()

return c#return.Success
end function

public function integer _is_vendor_actively_used (s_vendor astr_vendor, string as_vendor_type, ref string as_additional_info);/********************************************************************
_is_vendor_actively_used( /*s_vendor astr_vendor*/, /*string as_vendor_type*/, /*ref string as_additional_info */)

<DESC>
	generate an email in the event that the vendor that has just been blocked
	exists in an active voyage/contract/vessel
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	astr_vendor 		: holds the nom_acc_nr, name and short_name of the vendor
	as_vendor_type		: uppercase string resembling the Tramos Vendor type AGENTS/BROKERS/CHART/TCOWNERS
	as_additional_info: contains info that will be saved in the database event table VENDOR_LOG
</ARGS>
<USAGE>
	called directly from modify vendor rows where we are modifying the blocked state from diabled to blocked.
	Code in this method inspired by the original BlockedVendors implementation.
</USAGE>
********************************************************************/

mt_n_datastore lds_results
long ll_rows, ll_row
string ls_subjecttext, ls_bodytext, ls_emailstatusmessage
boolean lb_used = false

lds_results = create mt_n_datastore


CHOOSE CASE as_vendor_type
	CASE "AGENTS"
		
		lds_results.dataobject='d_sq_gr_vendor_active_agent'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - Agent '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked Agent '"+ astr_vendor.s_tramos_n_1 +"' is used on below not finished voyages. You will not be able to settle/post transactions to AX<br/><br/><table width='75%'><tr><td width='33%'>Vessel (V)</td><td width='33%'>Voyage (T)</td><td width='33%'>Port Name (P)</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>" &
								+"<td>" + lds_results.getitemstring(ll_row, "voyage_nr") + "</td>" &
								+"<td>" + lds_results.getitemstring(ll_row, "port_n")+ "</td>"
				ls_bodytext += "</tr>"
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		
	CASE "BROKERS"
		// CHARTER PARTY
		lds_results.dataobject='d_sq_gr_vendor_active_broker_cp'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - Broker '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked Broker '"+ astr_vendor.s_tramos_n_1 +"' is used on below not finished voyages. You will not be able to settle/post transactions to AX<br/><br/><table width='50%'><tr><td width='50%'>Vessel (V)</td><td width='50%'>Voyage (T)</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>" &
								+ "<td>" + lds_results.getitemstring(ll_row, "voyage_nr") + "</td>"
				ls_bodytext += "</tr>"
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		// TC CONTRACT
		lds_results.dataobject='d_sq_gr_vendor_active_broker_tc'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - Broker '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked Broker '"+ astr_vendor.s_tramos_n_1 +"' is used on below not finished TC Contracts. You will not be able to settle/post transactions to AX<br/><br/><table width='50%'><tr><td width='50%'>Vessel (V)</td><td width='50%'>TC Contract #</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>" &
								+ "<td>" + string(lds_results.getitemnumber(ll_row, "contract_id"))+"</td>"
				ls_bodytext += "</tr>"				
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		
	CASE "CHART"
		// CHARTER PARTY
		lds_results.dataobject='d_sq_gr_vendor_active_chart_cp'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - Charterer '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked Charterer '"+ astr_vendor.s_tramos_n_1 +"' is used on below not finished voyages. You will not be able to settle/post transactions to AX<br/><br/><table width='50%'><tr><td width='50%'>Vessel (V)</td><td width='50%'>Voyage (T)</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>" &
								+ "<td>" + lds_results.getitemstring(ll_row, "voyage_nr") + "</td>"
				ls_bodytext += "</tr>"
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		// TC CONTRACT
		lds_results.dataobject='d_sq_gr_vendor_active_chart_tc'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - Charterer '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked Charterer '"+ astr_vendor.s_tramos_n_1 +"' is used on below not finished TC Contracts. You will not be able to settle/post transactions to AX<br/><br/><table width='50%'><tr><td width='50%'>Vessel (V)</td><td width='50%'>TC Contract #</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>" &
								+ "<td>" + string(lds_results.getitemnumber(ll_row, "contract_id"))+"</td>"
				ls_bodytext += "</tr>"	
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		
	CASE "TCOWNERS"
		// TC CONTRACT
		lds_results.dataobject='d_sq_gr_vendor_active_tcowner_tc'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - TC Owner '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked TC Owner '"+ astr_vendor.s_tramos_n_1 +"' is used on below not finished TC Contracts. You will not be able to settle/post transactions to AX<br/><br/><table width='50%'><tr><td width='50%'>Vessel (V)</td><td width='50%'>TC Contract #</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>" &
								+ "<td>" + string(lds_results.getitemnumber(ll_row, "contract_id"))+"</td>"
				ls_bodytext += "</tr>"	
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		// TC VESSEL
		lds_results.dataobject='d_sq_gr_vendor_active_tcowner_vessels'
		lds_results.setTransObject(SQLCA)
		ll_rows = lds_results.retrieve( astr_vendor.l_tramos_vendor_nr )
		if ll_rows > 0 then
			ls_subjecttext = "TRAMOS - TC Owner '"+ astr_vendor.s_tramos_n_1 +"' blocked by AX"
			ls_bodytext = "<html><body>The blocked TC Owner '"+ astr_vendor.s_tramos_n_1 +"' is used on below active Vessels. You will not be able to settle/post transactions to AX<br/><br/><table width='100%'><tr><td width='100%'>Vessel (V)</td></tr>"		
			for ll_row = 1 to ll_rows
				ls_bodytext += "<tr>"
				ls_bodytext += "<td>" + lds_results.getitemstring(ll_row, "ref_nr") + "</td>"
				ls_bodytext += "</tr>"	
			next
			ls_bodytext += "</table></body><html>"
			lb_used = true
		end if
		
END CHOOSE

if lb_used then
	if of_sendmail(C#EMAIL.TRAMOSSUPPORT, gs_vendor_mailto, ls_subjecttext, ls_bodytext, ls_emailstatusmessage) = c#return.Success then
		of_writetolog("warning, " + as_vendor_type + " with nom_acc_nr = " + astr_vendor.s_nom_acc_nr + ", name = " + astr_vendor.s_tramos_n_1 + " is actively used.  email sent to " + gs_vendor_mailto,ii_LOG_NORMAL)			
		as_additional_info += "; actively used warning email sent to " + gs_vendor_mailto
	end if
end if

destroy lds_results

return c#return.Success
end function

private function string _get_last_word (string as_text, string as_delimiter);/********************************************************************
_get_last_word( /*string as_text*/, /*string as_delimiter */)

<DESC>
	locate and return the last word in a string using delimiter passed. if string passed is 'd_sq_vendor_update_agents' and delimiter is '_' 
	the function will return 'agents'
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_text 			: string to search inside 
	as_delimiter 	: delimter to use 
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
integer li_pos
li_pos = lastpos(as_text,as_delimiter)
return mid(as_text, li_pos + 1)


end function

private function integer _insert_event_into_vendor_log (string as_vendor_type, string as_additional_info, string as_event_type, s_vendor astr_vendor);/********************************************************************
_insert_event_into_vendor_log() 

<DESC>
	
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_vendor_type 		: reference to the vendor we are processing
	as_additional_info 	: the content that will be placed in the free-form ADDITIONAL_INFO column
	as_event_type 			: right now we may have 'not found' or 'modified'
	astr_vendor 			: from the structure we obtain the nom_acc_nr and source_ref (file name).
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

long ll_newrow

ll_newrow=_ids_event_log.insertrow(0)

if ll_newrow = -1 then
	return c#return.Failure
else
	_ids_event_log.setitem(ll_newrow,"event_type",as_event_type)
	_ids_event_log.setitem(ll_newrow,"nom_acc_nr",astr_vendor.s_nom_acc_nr)
	_ids_event_log.setitem(ll_newrow,"source_ref",astr_vendor.s_source_ref)	
	_ids_event_log.setitem(ll_newrow,"target_ref",as_vendor_type)	
	_ids_event_log.setitem(ll_newrow,"additional_info",as_additional_info)		
end if
return c#return.Success
end function

private function integer _modify_vendor_rows (ref mt_n_datastore ads_vendor, ref s_vendor astr_vendor);/********************************************************************
_modify_vendor_rows( /*ref mt_n_datastore ads_vendor*/, /*ref s_vendor astr_vendor */)

<DESC>
	as specific vendor data is passed we search it to see if it matches the supplier code (nom_acc_nr) found
	within the XML source.
	
	If it is found we set the vendor found flag to true. This is important because if all 4 vendor tables are searched
	and we do not find the supplier code we need to inform the user that this supplier is not inside Tramos.
	
	Also if found we drill down to the isBlocked element.  If this is different in any way to the BLOCKED column in the vendor
	table inside Tramos we modify the values required.  
	
	Lastly we run some checks to make sure the vendor we are blocking is not used on an active voyage by calling _is_vendor_actively_used()
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success - vendor was located
		<LI> 0, X NoAction - no vendor found
		<LI> -1, X Failed - we had an error searching the data-set
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	ads_vendor - specific vendor datastore (AGENTS/BROKERS/CHART/TCOWNERS)
	astr_vendor - structure containing the SupplierCode (nom_acc_nr) and other details
</ARGS>
<USAGE>
</USAGE>
********************************************************************/
integer li_original_blocked_state
long ll_found, ll_end
string ls_vendor_type,ls_search_criteria, ls_vendor_sn, ls_additional_info
boolean lb_none_found = true
//boolean lb_vendor_checked_for_activity = false

ls_vendor_type = upper(_get_last_word(ads_vendor.dataobject,"_"))
ls_search_criteria = "nom_acc_nr='" + astr_vendor.s_nom_acc_nr + "'"

ll_end = ads_vendor.rowcount() + 1
ll_found = ads_vendor.find(ls_search_criteria,1,ll_end)


/* the Tramos data model allows more than one occurance of the same nom_acc_nr inside each table */
do while ll_found > 0
	lb_none_found = false
	ls_vendor_sn = ads_vendor.getitemstring(ll_found,"sn")
	astr_vendor.b_found = true
	
	/* phase I - the blocked status modification is controlling updates */
	li_original_blocked_state = ads_vendor.getitemnumber(ll_found,"blocked")
	if li_original_blocked_state <> astr_vendor.i_isblocked then
		/* 
		Blocking Business Logic follows -
		isBlocked=false; So if vendor is currently blocked, the vendor also is deactivated - only unblock the vendor.  Do not activate it.
		isBlocked=true; If vendor is currently unblocked and the vendor is also activated - block the vendor and also deactiviate it.
		*/		
		ls_additional_info = "SN=" + ls_vendor_sn + "; modified <blocked> flag from " + string(li_original_blocked_state) + " to " + string(astr_vendor.i_isblocked)
		ads_vendor.setitem(ll_found, "blocked", astr_vendor.i_isblocked)
		if not isnull(astr_vendor.s_blockedreason) then
			ads_vendor.setitem(ll_found, "blocked_note", astr_vendor.s_blockedreason)
		end if
		of_writetolog("info, " + astr_vendor.s_nom_acc_nr + " has been updated inside " + ls_vendor_type + " on record with short name " + ls_vendor_sn, ii_LOG_NORMAL)
		/* The following is only if update is to Block */
		if astr_vendor.i_isblocked = 1 then
			ads_vendor.setitem(ll_found, "blocked_date", astr_vendor.dt_blocked_date)
			if ads_vendor.getitemnumber(ll_found,"active") = 1 then
				ls_additional_info += "; <active> flag from 1 to 0"
				ads_vendor.setitem(ll_found, "active", 0)
			end if
			astr_vendor.s_tramos_n_1 = ads_vendor.getitemstring(ll_found,"n_1")
			astr_vendor.l_tramos_vendor_nr = ads_vendor.getitemnumber(ll_found,"nr")
			/* now verify if modification impacts active voyage data.  only call this method if vendor is to be blocked */
			_is_vendor_actively_used(astr_vendor, ls_vendor_type, ls_additional_info)
		end if
		/* here we log the activity of the modification to the VENDOR_LOG - only 1 email per vendor found is needed */
		_insert_event_into_vendor_log(ls_vendor_type, ls_additional_info, "modified", astr_vendor)
	end if
	/* manage possibility that if the last search is referencing the last row, we do not fall into an infinate loop */
	ll_found ++
	ll_found = ads_vendor.find( ls_search_criteria, ll_found, ll_end )
loop

if lb_none_found then
	return c#return.NoAction
elseif ll_found<0 then
	return c#return.Failure	
else
	return c#return.Success
end if	
end function

on n_interfacelogicvendors.create
call super::create
end on

on n_interfacelogicvendors.destroy
call super::destroy
end on

