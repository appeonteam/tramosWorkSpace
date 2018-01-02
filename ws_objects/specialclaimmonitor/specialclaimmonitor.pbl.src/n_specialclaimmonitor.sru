$PBExportHeader$n_specialclaimmonitor.sru
forward
global type n_specialclaimmonitor from mt_n_nonvisualobject
end type
end forward

global type n_specialclaimmonitor from mt_n_nonvisualobject
end type
global n_specialclaimmonitor n_specialclaimmonitor

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
long						ll_#ofActions, ll_row
string 					ls_mail_subject, ls_mail_message, ls_receiver, ls_errorMessage
string						ls_customer, ls_user_id
mt_n_outgoingmail	lnv_mail

constant string METHOD_NAME="of_task_duedate_monitor"

ids_data.dataobject = "d_task_duedate_monitor"
ids_data.setTransObject(SQLCA)

//find out if any claims have a timebar exceeded
ll_#ofActions = ids_data.retrieve()


if ll_#ofActions < 1 then 
	_addmessage(this.classdefinition, METHOD_NAME, "duedate monitor - Nothing to do", "")
	return c#return.noAction
end if

lnv_mail = create mt_n_outgoingmail

for ll_row = 1 to ll_#ofActions
	//get information to create mail
	//receiver
	ls_receiver = ids_data.getItemString(ll_row, "action_assigned_to")
	ls_receiver += C#EMAIL.DOMAIN
	
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

_addmessage(this.classdefinition, METHOD_NAME, "duedate monitor - (emails sent=" + string(ll_#ofActions) + ")", "")

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
	Uses an INI-file (specialclaimmonitor.ini) 
	The ini file looks like below:
	[database]
	dbms=SYC Sybase System 10
	database=PROD_TRAMOS
	servername=SCRBTRADKCPH001
	[login]
	uid=xx
	pwd=xxxxxxxxx
	
	</ALSO>

Date   		Ref   			Author        	Comments
16/07-10    	CR#1543   	RMO003     	First Version
12/08-10    	CR#2099   	JMC112     	correct error send email (mising setcreator)
08/12/10		??				AGL027		chnaged the logging to file process
24/10/13		CR2690		LGX001		1.replaced @maersk.com with C#email.domain
												2.replaced TRAMOS_DONT_REPLY@maersk.com with C#email.TRAMOSSUPPORT(tramosMT@maersk.com)
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
long						ll_#ofClaims, ll_row
string 					ls_mail_subject, ls_mail_message, ls_receiver, ls_errorMessage
string						ls_customer, ls_user_id
mt_n_outgoingmail	lnv_mail

constant string METHOD_NAME="of_timebar_monitor"

ids_data.dataobject = "d_timebar_monitor"
ids_data.setTransObject(SQLCA)

//find out if any claims have a timebar exceeded
ll_#ofClaims = ids_data.retrieve()
if ll_#ofClaims < 1 then 
	_addmessage( this.classdefinition , METHOD_NAME, "timebar monitor - Nothing to do", "")
	return c#return.noAction
end if

lnv_mail = create mt_n_outgoingmail

for ll_row = 1 to ll_#ofClaims
	//get information to create mail
	//receiver
	ls_receiver = ids_data.getItemString(ll_row, "responsible_person")
	ls_receiver += C#EMAIL.DOMAIN
	
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

_addmessage( this.classdefinition , METHOD_NAME, "timebar monitor - (emails sent=" + string(ll_#ofClaims) + ")","")

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
string						 ls_user_id
mt_n_outgoingmail	lnv_mail

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
	ls_receiver += C#EMAIL.DOMAIN
	
		
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

_addmessage(this.classdefinition, METHOD_NAME, "Claim Actions - (emails sent=" + string(ll_#ofActions) + ")", "")

destroy lnv_mail	

return c#return.success
end function

on n_specialclaimmonitor.create
call super::create
end on

on n_specialclaimmonitor.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_data = create mt_n_datastore

end event

event destructor;call super::destructor;destroy	ids_data
end event

