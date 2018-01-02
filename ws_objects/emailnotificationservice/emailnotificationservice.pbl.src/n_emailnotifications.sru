$PBExportHeader$n_emailnotifications.sru
forward
global type n_emailnotifications from mt_n_nonvisualobject
end type
end forward

global type n_emailnotifications from mt_n_nonvisualobject
end type
global n_emailnotifications n_emailnotifications

type variables
mt_n_datastore 		ids_data 

constant integer iiLOGLEVEL_LOW = 3
constant integer iiLOGLEVEL_MEDIUM = 2
constant integer iiLOGLEVEL_HIGH = 1
constant integer iiLOGLEVEL_ALWAYS = 0
constant integer iiLOGFILE = 2
end variables

forward prototypes
public function integer of_task_duedate_monitor ()
public subroutine documentation ()
public function integer of_timebar_monitor ()
private function integer _getcustomername (long al_row, ref string al_customername)
public function integer of_claims_actions ()
public function integer of_expired_certificates (s_emailnotificationsettings astr_settings)
public function integer _send_email (ref mt_n_outgoingmail anv_mail, ref string as_receiver, string as_mail_subject, string as_mail_message, s_emailnotificationsettings astr_settings)
public function integer of_tccontract_expired ()
end prototypes

public function integer of_task_duedate_monitor ();/********************************************************************
   of_task_duedate_monitor( )
   <DESC> Runs through all duedate is expired, and sends a mail to
	the responsible person asssigned.
	Mail is generated if duedate is less then today + 7 days, and action is not finished.
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  </ARGS>
   <USAGE> </USAGE>
********************************************************************/
long						ll_#oftasks, ll_row
string 					ls_mail_subject, ls_mail_message, ls_receiver, ls_errorMessage
string					ls_customer, ls_user_id
mt_n_outgoingmail		lnv_mail
mt_n_activedirectoryfunctions	lnv_adfunc

constant string METHOD_NAME="of_task_duedate_monitor"

ids_data.dataobject = "d_sq_tb_task_duedate_monitor"
ids_data.setTransObject(SQLCA)

//find out if any claims have a timebar exceeded
ll_#oftasks = ids_data.retrieve()


if ll_#oftasks < 1 then 
	_addmessage(this.classdefinition, METHOD_NAME, "duedate monitor - Nothing to do", "")
	return c#return.noAction
end if

lnv_mail = create mt_n_outgoingmail

for ll_row = 1 to ll_#oftasks
	//get information to create mail
	//receiver
	ls_receiver = lnv_adfunc.of_get_email_by_userid_from_db(ids_data.getItemString(ll_row, "action_assigned_to"))
	
	_getcustomername( ll_row, ls_customer )

		
	//build mail message
	ls_mail_subject = "Claim Action duedate will expire on " + string(ids_data.getitemdatetime(ll_row, "action_due_date"),"dd. mmm yyyy") 			
	ls_mail_message = "Action details:"+char(13)+char(10)+ &	
							"Action Desc: " + string(ids_data.getitemString(ll_row, "action_description"))+char(13)+char(10)+&
							"Vessel Number: " + string(ids_data.getitemString(ll_row, "vessel_ref_nr"))+char(13)+char(10)+&
							"Vessel Name: " +ids_data.getitemstring(ll_row, "vessel_name")+char(13)+char(10)+&
							"Customer: " + ls_customer+char(13)+char(10)+&
							"Claim Short Desc: " + ids_data.getitemstring(ll_row, "special_claim_type")


	if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receiver , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then
		destroy lnv_mail
		return c#return.failure
	else
		ls_user_id = ids_data.getItemString(ll_row, "action_assigned_to")
		if lnv_mail.of_setcreator( ls_user_id, ls_errorMessage) = -1 then
			_addmessage(this.classdefinition, METHOD_NAME," Error when setting creator: "+ls_errorMessage,"")
			destroy lnv_mail
			return c#return.failure
		end if
		
		if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
			_addmessage(this.classdefinition, METHOD_NAME, "ERROR duedate monitor:" + ls_errorMessage, "")
			destroy lnv_mail
			return c#return.failure
		end if
	end if	
	lnv_mail.of_reset( )
next

_addmessage(this.classdefinition, METHOD_NAME, "task duedate - (emails sent=" + string(ll_#oftasks) + ")", "")

destroy lnv_mail	

return c#return.success
end function

public subroutine documentation ();/********************************************************************
ObjectName: n_specialclaimmonitor - used for sending a notification to the users about
					expired duedates on Claim timebar and claim actions duedates				
   <OBJECT> 
The function will run once a day in two steps
	1) Run through all claims that are not forwarded yet and where timebar date 
		is expired, and send a mail to the responsible user
	2) Run through all claims actions that are not finished, and where timebar date 
		is expired, and send a mail to the assigned user
	
	</OBJECT>

	<ALSO>
	
Date   		Ref   			Author        	Comments

specialclaimmonitor.exe
---------------------------------------------------------------------------------------
16/07-10    	CR#1543   	RMO003     	First Version
12/08-10    	CR#2099   	JMC112     	correct error send email (mising setcreator)
08/12/10			??				AGL027		chnaged the logging to file process
24/10/13			CR2690		LGX001		1.replaced @maersk.com with C#email.domain
													2.replaced TRAMOS_DONT_REPLY@maersk.com with C#email.TRAMOSSUPPORT(tramosMT@maersk.com)
---------------------------------------------------------------------------------------
emailnotificationservice.exe
---------------------------------------------------------------------------------------
10/02/16			CR4298		AGL027		Created new application	derived from specialclaimmonitor
07/03/16			CR4316		AGL027		Swapped domain constant for the email adress from AD saved in DB
14/06/16			CR4298		AGL027		Corrected an issue missed where mt_n_emailfunctions was renamed after deployed.
	</ALSO>
												
********************************************************************/

end subroutine

public function integer of_timebar_monitor ();/********************************************************************
   of_timebar_monitor
   <DESC> Runs through all claims where duedate is expired, and sends a mail to
	the responsible person asssigned.
	Mail is generated if timebar date is less then today + 7 days, and claim is not forwarded.
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  </ARGS>
   <USAGE> </USAGE>
********************************************************************/
long						ll_#ofclaims, ll_row
string 					ls_mail_subject, ls_mail_message, ls_receiver, ls_errorMessage
string					ls_customer, ls_user_id
mt_n_outgoingmail		lnv_mail
mt_n_activedirectoryfunctions	lnv_adfunc

constant string METHOD_NAME="of_timebar_monitor()"

ids_data.dataobject = "d_sq_tb_timebar_monitor"
ids_data.setTransObject(SQLCA)

//find out if any claims have a timebar exceeded
ll_#ofclaims = ids_data.retrieve()
if ll_#ofclaims < 1 then 
	_addmessage( this.classdefinition , METHOD_NAME, "timebar monitor - Nothing to do", "")
	return c#return.noAction
end if

lnv_mail = create mt_n_outgoingmail

for ll_row = 1 to ll_#ofclaims
	//get information to create mail
	//receiver
	ls_receiver = lnv_adfunc.of_get_email_by_userid_from_db(ids_data.getItemString(ll_row, "responsible_person"))
	_getcustomername( ll_row, ls_customer )
		
	//build mail message
	ls_mail_subject = "Claim timebar will expire on " + string(ids_data.getitemdatetime(ll_row, "timebar_date"),"dd. mmm yyyy") 			
	ls_mail_message = "Claim details:"+char(13)+char(10)+ &	
							"Vessel Number: " + string(ids_data.getitemString(ll_row, "vessel_ref_nr"))+char(13)+char(10)+&
							"Vessel Name: " +ids_data.getitemstring(ll_row, "vessel_name")+char(13)+char(10)+&
							"Customer: " + ls_customer+char(13)+char(10)+&
							"Short Desc: " + ids_data.getitemstring(ll_row, "special_claim_type")


	if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receiver , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then
		destroy lnv_mail
		return c#return.failure
	else
		ls_user_id = ids_data.getItemString(ll_row, "responsible_person")
		if lnv_mail.of_setcreator( ls_user_id, ls_errorMessage) = -1 then
			_addmessage( this.classdefinition , METHOD_NAME, "Error when setting creator: "+ls_errorMessage, "")
			destroy lnv_mail
			return c#return.failure
		end if
		
		if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
			_addmessage( this.classdefinition , METHOD_NAME, "ERROR timebar monitor:" + ls_errorMessage, "")
			destroy lnv_mail
			return c#return.failure
		end if
	end if
	lnv_mail.of_reset()
next
destroy lnv_mail	

_addmessage( this.classdefinition , METHOD_NAME, "timebar - (emails sent=" + string(ll_#ofclaims) + ")","")

return c#return.success






		
end function

private function integer _getcustomername (long al_row, ref string al_customername);/********************************************************************
   _getCustomerName
   <DESC> Checks the type of customer the claim is against, and finds the name.
	Name is returned as reference</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>   al_row: row number in datastore
            as_customerName: reference to namevariable</ARGS>
   <USAGE>  </USAGE>
********************************************************************/
constant string METHOD_NAME = "_getCustomerName "
long	ll_customerNr

choose case ids_data.getItemNumber(al_row, "debtor_creditor")
	case 1  //Charterer
		ll_customerNr = ids_data.getItemNumber(al_row, "chart_nr")
		SELECT CHART_N_1  
			INTO :al_customerName
			FROM CHART  
			WHERE CHART_NR = :ll_customerNr   ;
		if sqlca.sqlcode <> 0 then
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME , "Error reading Charterer name from DB", "n/a")
			return c#return.failure
		end if
	case 2, 3  //TC Owner, Head Owner
		ll_customerNr = ids_data.getItemNumber(al_row, "tcowner_nr")
		SELECT TCOWNER_N_1  
			INTO :al_customerName
			FROM TCOWNERS  
			WHERE TCOWNER_NR = :ll_customerNr   ;
		if sqlca.sqlcode <> 0 then
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME , "Error reading TC Owner name from DB", "n/a")
			return c#return.failure
		end if
	case 4  //Agent
		ll_customerNr = ids_data.getItemNumber(al_row, "agent_nr")
		SELECT AGENT_N_1  
			INTO :al_customerName
			FROM AGENTS  
			WHERE AGENT_NR = :ll_customerNr   ;
		if sqlca.sqlcode <> 0 then
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME , "Error reading Agent name from DB", "n/a")
			return c#return.failure
		end if
	case 5  //Broker
		ll_customerNr = ids_data.getItemNumber(al_row, "broker_nr")
		SELECT BROKER_NAME  
			INTO :al_customerName
			FROM BROKERS  
			WHERE BROKER_NR = :ll_customerNr   ;
		if sqlca.sqlcode <> 0 then
			rollback;
			_addmessage( this.classdefinition, METHOD_NAME , "Error reading Broker name from DB", "n/a")
			return c#return.failure
		end if
	case 6 //Third Party
		al_customername = ids_data.getItemString(al_row, "third_party_name")
end choose
commit;

return c#return.success
end function

public function integer of_claims_actions ();/********************************************************************
   of_claims_actions( )
   <DESC> Runs through all duedate is expired, and sends a mail to
	the responsible person asssigned.
	Mail is generated if duedate is less then doday + 7 days, and action is not finished.
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  </ARGS>
   <USAGE> </USAGE>
********************************************************************/

long						ll_#ofActions, ll_row
string 					ls_mail_subject, ls_mail_message, ls_receiver, ls_errorMessage
string					ls_user_id
mt_n_outgoingmail		lnv_mail
mt_n_activedirectoryfunctions	lnv_adfunc

constant string METHOD_NAME="of_claims_actions"

ids_data.dataobject = "d_sq_tb_claims_actions"
ids_data.setTransObject(SQLCA)

//find out if any claims have a timebar exceeded
ll_#ofActions = ids_data.retrieve()

if ll_#ofActions < 1 then 
	_addmessage(this.classdefinition, METHOD_NAME, "claim actions - Nothing to do", "")
	return c#return.noAction
end if

lnv_mail = create mt_n_outgoingmail

for ll_row = 1 to ll_#ofActions
	//get information to create mail
	//receiver
	ls_receiver = ids_data.getItemString(ll_row, "claim_action_c_action_assigned_to")
	if ls_receiver = "" then continue
	ls_receiver = lnv_adfunc.of_get_email_by_userid_from_db(ls_receiver)
		
	//build mail message
	ls_mail_subject = "Claim Action duedate will expire on " + string(ids_data.getitemdatetime(ll_row, "claim_action_c_action_due_date"),"dd. mmm yyyy") 			
	
	ls_mail_message = "Action details:"+char(13)+char(10)+ &	
							"Action Desc: " + string(ids_data.getitemString(ll_row, "claim_action_c_action_comment"))+char(13)+char(10)+&
							"Vessel Number: " + string(ids_data.getitemString(ll_row, "vessels_vessel_ref_nr"))+char(13)+char(10)+&
							"Vessel Name: " +ids_data.getitemstring(ll_row, "vessels_vessel_name")+char(13)+char(10)+&
							"Voyage: " + ids_data.getitemstring(ll_row, "claim_action_voyage_nr")+char(13)+char(10)+&
							"Claim Type: " +  ids_data.getitemstring(ll_row, "claims_claim_type")+char(13)+char(10)+&
							"Charterer: " +  ids_data.getitemstring(ll_row, "chart_chart_n_1") +char(13)+char(10)+&
							"Claim Type: " + ids_data.getitemstring(ll_row, "claims_claim_type")

	if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_receiver , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then
		destroy lnv_mail
		return c#return.failure
	else
		ls_user_id = ids_data.getItemString(ll_row, "claim_action_c_action_assigned_to")
		if lnv_mail.of_setcreator( ls_user_id, ls_errorMessage) = -1 then
			_addmessage(this.classdefinition, METHOD_NAME," Issue when setting creator: "+ls_errorMessage,"")
			destroy lnv_mail
			return c#return.failure
		end if
		
		if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
			_addmessage(this.classdefinition, METHOD_NAME, "Issue when sending mail duedate monitor: " + ls_errorMessage, "")
			destroy lnv_mail
			return c#return.failure
		end if
	end if	
	lnv_mail.of_reset( )
next

_addmessage(this.classdefinition, METHOD_NAME, "claim actions - (emails sent=" + string(ll_#ofActions) + ")", "")

destroy lnv_mail	

return c#return.success
end function

public function integer of_expired_certificates (s_emailnotificationsettings astr_settings);
/********************************************************************
of_getadvancedrpstateall( /*ref datawindow adw_primaryrp*/, /*datawindow adw_advancedrp */) 

<DESC>
	
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private/Public
</ACCESS>
<ARGS>
	as_docpath: file path and name
</ARGS>
<USAGE>
</USAGE>
********************************************************************/

mt_n_datastore		lds_expired_certificates
date					ldt_expireddate
mt_n_outgoingmail	lnv_mail
string	ls_mail_subject, ls_mail_message, ls_receiver, ls_vesselemail, ls_pc, ls_curr_pc
string	ls_curr_receiver, ls_vesselrefnr, ls_curr_vesselrefnr, ls_tmp_receiver, ls_user_id, ls_errorMessage
integer	ll_row
long		ll_#ofcertificates		

constant string METHOD_NAME="of_expired_certificates"

ldt_expireddate = RelativeDate ( today(), astr_settings.l_expired_certs_days )

lds_expired_certificates = create mt_n_datastore
lds_expired_certificates.dataobject = "d_sq_gr_expired_certificates"
lds_expired_certificates.setTransObject(SQLCA)
lds_expired_certificates.retrieve(ldt_expireddate)

ll_#ofcertificates =  lds_expired_certificates.rowcount( )
if  ll_#ofcertificates> 0 then
	 ls_receiver = lds_expired_certificates.getitemstring( 1, "offices_email_adr_charterer")
else 
	_addmessage(this.classdefinition, METHOD_NAME, "expired certificates - Nothing to do", "")
	return c#return.noAction
end if

lnv_mail = create mt_n_outgoingmail

ls_mail_subject = "TRAMOS Alert: Expired Vessels Certificates"

for ll_row = 1 to ll_#ofcertificates
	ls_curr_receiver = lds_expired_certificates.getitemstring( ll_row, "offices_email_adr_charterer")
	ls_curr_vesselrefnr = lds_expired_certificates.getitemstring(ll_row, "vessels_vessel_ref_nr")
	ls_curr_pc =  lds_expired_certificates.getitemstring(ll_row, "profit_c_pc_name")
	ls_vesselemail = lds_expired_certificates.getitemstring( ll_row, "vessels_vessel_email")
	if isnull(ls_vesselemail) then
		ls_vesselemail=""
	else
		ls_vesselemail = " (" + ls_vesselemail + ")"
	end if
	
	if ls_curr_receiver <> ls_receiver then
		_send_email( lnv_mail, ls_receiver, ls_mail_subject, ls_mail_message, astr_settings )
		ls_receiver = ls_curr_receiver
		ls_mail_message=""
	end if
	
	if ls_curr_vesselrefnr<> ls_vesselrefnr then
		if ls_curr_pc <> ls_pc then
			ls_mail_message = ls_mail_message + char(10)+ char(13) + ls_curr_pc + ":"
			ls_pc = ls_curr_pc
		end if
		ls_mail_message = ls_mail_message + char(10)+ char(13) +  ls_curr_vesselrefnr + " " +  lds_expired_certificates.getitemstring( ll_row, "vessels_vessel_name") +  ls_vesselemail  + char(13) 
		ls_vesselrefnr = ls_curr_vesselrefnr
	end if
	ls_mail_message =  ls_mail_message + "  - " + lds_expired_certificates.getitemstring( ll_row,"vessel_cert_description") + " (" +  lds_expired_certificates.getitemstring( ll_row, "vessel_cert_file_name") + ")" + " " +  lds_expired_certificates.getitemstring( ll_row, "vessel_cert_expired_date") + char(13)

next

if ls_mail_message<>"" then
	_send_email( lnv_mail, ls_receiver, ls_mail_subject, ls_mail_message, astr_settings)
end if
destroy lds_expired_certificates

_addmessage(this.classdefinition, METHOD_NAME, "expired certificates - (emails sent=" + string(ll_#ofcertificates) + ")", "")

return c#return.Success
end function

public function integer _send_email (ref mt_n_outgoingmail anv_mail, ref string as_receiver, string as_mail_subject, string as_mail_message, s_emailnotificationsettings astr_settings);/********************************************************************
of_send_email( /*ref mt_n_outgoingmail anv_mail*/, /*string as_receiver*/, /*string as_mail_subject*/, /*string as_mail_message */)
	
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
	as_docpath: file path and name
</ARGS>
<USAGE>
	Used by the Expired Certificates job, called directly from of_expired_certificates( /*s_emailnotificationsettings astr_settings */)
</USAGE>
********************************************************************/
string	ls_errorMessage
string	ls_receiver2
constant string METHOD_NAME="_send_email()"

if astr_settings.s_expired_certs_testemail1<>"" then 
	as_receiver = astr_settings.s_expired_certs_testemail1
end if	

if anv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, as_receiver , as_mail_subject , as_mail_message, ls_errorMessage) = c#return.Failure then	

	//	of_writelog("Error when creating the notification email. Reason: "+ls_errorMessage)
else
	if anv_mail.of_setcreator( C#EMAIL.TRAMOSSUPPORT, ls_errorMessage) = c#return.Failure then
		//	of_writelog("Error when setting creator of email to backup email address. Reason: "+ls_errorMessage)
	else
		if upper(as_receiver)= "CHACPH@HANDYTANKERS.COM" then
			if astr_settings.s_expired_certs_testemail2 <> "" then 
				ls_receiver2 = astr_settings.s_expired_certs_testemail2
			else 
				ls_receiver2 = "CPH.ADM@handytankers.com"
			end if
		  	anv_mail.of_addreceiver(ls_receiver2, as_mail_message )
		  	//ls_msgreceivers = ls_msgreceivers + ", CPH.ADM@handytankers.com"
		end if
		if anv_mail.of_sendmail( ls_errorMessage ) = c#return.Failure then
//			of_writelog("Error when sending the email. Reason: "+ls_errorMessage)
		end if
	end if
end if	
//of_writelog("A notification email with is sent to " + as_msgreceivers )
anv_mail.of_reset( )

return 1
end function

public function integer of_tccontract_expired ();/********************************************************************
   of_tccontract_expired
   <DESC> Runs through all TC Hire contract where expiring_days is expired, and sends a mail to
	the office's charterer,operater,claims.
	Mail is generated if period end + expiring_days = today.
	</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>  </ARGS>
   <USAGE> </USAGE>
********************************************************************/

long						ll_contracts, ll_contracts_id, ll_tcexprocount
int 						li_expiring_days, li_i, li_sumreceiver = 0, li_receiver
string 					ls_mail_subject, ls_mail_message, ls_receiver[], ls_errorMessage, ls_user_id
string					ls_rec_charterer, ls_rec_operater, ls_rec_claims, ls_ower
datastore 				ds_office_email 
mt_n_outgoingmail		lnv_mail
mt_n_activedirectoryfunctions lnv_adfunc

li_i = 1

constant string METHOD_NAME = "of_tccontract_expired"

ids_data.dataobject = 'd_sq_tb_tchire_contracts'
ids_data.settransobject(sqlca)

ll_tcexprocount = ids_data.retrieve()

if ll_tcexprocount < 1 then
	_addmessage(this.classdefinition, METHOD_NAME, "TC Hire contract expired - Nothing to do", "")
	return c#return.noAction
end if

ds_office_email = create datastore
ds_office_email.dataobject = "d_sq_tb_office_email"
ds_office_email.setTransObject(SQLCA)

lnv_mail = create mt_n_outgoingmail

for li_i = 1 to ll_tcexprocount
	
	ls_user_id = ids_data.getitemString(li_i, "ntc_tc_contract_fixture_user_id")
	if ls_user_id = "" or isnull(ls_user_id) then
		_addmessage( this.classdefinition, METHOD_NAME, "Error when creating the notification email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: no mail will be sent before the contract is fixed.", "")
		continue
	end if
	
	ll_contracts_id = ids_data.getitemnumber(li_i, "ntc_tc_contract_contract_id")
	
	//find out the recievers  
	if ds_office_email.retrieve(ids_data.getitemnumber( li_i, "office_nr")) < 1 then 
		_addmessage( this.classdefinition, METHOD_NAME, "No receiver!", "")
		continue
	end if
	
	//if receiver address wrong
	ls_rec_charterer = ds_office_email.getItemString(1, "email_adr_charterer")
	ls_rec_operater = ds_office_email.getItemString(1, "email_adr_operation")
	ls_rec_claims = ds_office_email.getItemString(1, "email_adr_claims")
	
	if (isnull(ls_rec_charterer) or trim(ls_rec_charterer) = '') and (isnull(ls_rec_operater) or trim(ls_rec_operater) = '') and (isnull(ls_rec_claims) or trim(ls_rec_claims) = '')  then
		_addmessage( this.classdefinition, METHOD_NAME, "No receiver!", "")
		continue
	end if
	
	if trim(ls_rec_charterer) <> '' and not isnull(ls_rec_charterer) then
		ls_receiver[1] = ls_rec_charterer
		li_sumreceiver = 1
	end if
	if trim(ls_rec_operater) <> '' and not isnull(ls_rec_operater) and ls_rec_operater <> ls_rec_charterer then
		ls_receiver[li_sumreceiver + 1] = ls_rec_operater
		li_sumreceiver = li_sumreceiver + 1
	end if
	if trim(ls_rec_claims) <> '' and not isnull(ls_rec_claims) and ls_rec_claims <> ls_rec_charterer and ls_rec_claims <> ls_rec_operater then
		ls_receiver[li_sumreceiver + 1] = ls_rec_claims
		li_sumreceiver = li_sumreceiver + 1
	end if
	
	//build mail message
	ls_ower = ids_data.getitemstring(li_i, "tcowners_tcowner_n_1")
	if isnull(ls_ower) then ls_ower = ""
	ls_mail_subject = "TRAMOS - The time charter period will expire in " + string(ids_data.getitemnumber(li_i, "ntc_tc_contract_expiring_days")) + " days"			
	ls_mail_message = "Contract detail:"+char(13)+char(10)+ &	
							"Vessel Number: " + ids_data.getitemstring(li_i, "vessels_vessel_ref_nr")+char(13)+char(10)+&
							"Vessel Name: " +ids_data.getitemstring(li_i, "vessels_vessel_name")+char(13)+char(10)+&
							"Contract ID: " + string(ll_contracts_id)+char(13)+char(10)+&
							"Charterer/Owner: " + ls_ower + char(13)+char(10)+&
							"C/P Date: " + string(ids_data.getitemdatetime(li_i,"ntc_tc_contract_tc_hire_cp_date"),'dd-mm-yy')

	if lnv_mail.of_createmail( C#EMAIL.TRAMOSSUPPORT, ls_receiver[1] , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then	
		continue
	else
		if lnv_mail.of_setcreator( ls_user_id, ls_errorMessage) = -1 then
			_addmessage( this.classdefinition, METHOD_NAME, "Error when creating the notification email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: "+ls_errorMessage, "")
			continue
		else
			
			for li_receiver = 2 to li_sumreceiver
				lnv_mail.of_addreceiver(ls_receiver[li_receiver], ls_errormessage)
			next
			
			if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
				_addmessage( this.classdefinition, METHOD_NAME, "Error when sending the email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: "+ls_errorMessage, "")				
				continue
			end if
		end if
	end if	
	_addmessage( this.classdefinition, METHOD_NAME, "A notification email with Contract ID: " + string(ll_contracts_id)+" is sent!", "")					
	lnv_mail.of_reset( )
next

destroy lnv_mail	
destroy ds_office_email

return c#return.success
end function

on n_emailnotifications.create
call super::create
end on

on n_emailnotifications.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_data = create mt_n_datastore

end event

event destructor;call super::destructor;destroy	ids_data
end event

