HA$PBExportHeader$u_tchire_contract.sru
forward
global type u_tchire_contract from nonvisualobject
end type
end forward

global type u_tchire_contract from nonvisualobject
end type
global u_tchire_contract u_tchire_contract

forward prototypes
public function integer of_tchire_runout ()
end prototypes

public function integer of_tchire_runout ();long						ll_contracts, ll_contracts_id
int 						li_expiring_days, li_i, li_j
string 					ls_mail_subject, ls_mail_message, ls_receiver, ls_errorMessage, ls_user_id
datastore 				ds_tchire_contracts,ds_office_email 
mt_n_outgoingmail	lnv_mail

li_i = 1
li_j = 1

ds_tchire_contracts = create datastore
ds_tchire_contracts.dataobject = "d_tchire_contracts"
ds_tchire_contracts.setTransObject(SQLCA)

ds_office_email = create datastore
ds_office_email.dataobject = "d_sq_tb_office_email"
ds_office_email.setTransObject(SQLCA)

//find out the expering contract
ll_contracts = ds_tchire_contracts.retrieve()
if ll_contracts < 1 then return 1

lnv_mail = create mt_n_outgoingmail

for li_i = 1 to ds_tchire_contracts.rowcount( )
	ls_user_id = ds_tchire_contracts.getitemString(li_i, "ntc_tc_contract_fixture_user_id")
	if ls_user_id = "" or isnull(ls_user_id) then
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when creating the notification email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: no mail will be sent before the contract is fixed.")
		continue
	end if
	
	ll_contracts_id = ds_tchire_contracts.getitemnumber(li_i, "ntc_tc_contract_contract_id")
	
	//find out the recievers  
	if ds_office_email.retrieve(ds_tchire_contracts.getitemnumber( li_i, "office_nr")) < 1 then 
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " No receiver!")
		continue
	end if
	
	//if receiver address wrong
	ls_receiver = ds_office_email.getItemString(1, "email_adr_charterer")
	if pos(" ", ls_receiver,1)> 0 &
	or isnull( ls_receiver) or ls_receiver = "" then 
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + "The receiver email address is wrong: "+ls_receiver)
		continue
	end if
		
	//build mail message
	ls_mail_subject = "The time charter period will expire in " + string(ds_tchire_contracts.getitemnumber(li_i, "ntc_tc_contract_expiring_days")) + " days"			
	ls_mail_message = "Contract detail:"+char(13)+char(10)+ &	
							"Vessel Number: " + string(ds_tchire_contracts.getitemnumber(li_i, "vessels_vessel_nr"))+char(13)+char(10)+&
							"Vessel Name: " +ds_tchire_contracts.getitemstring(li_i, "vessels_vessel_name")+char(13)+char(10)+&
							"Contract ID: " + string(ll_contracts_id)+char(13)+char(10)+&
							"Charterer/Owner: " + ds_tchire_contracts.getitemstring(li_i, "tcowners_tcowner_n_1")

	if lnv_mail.of_createmail( C#EMAIL.TRAMOSSUPPORT, ls_receiver , ls_mail_subject , ls_mail_message, ls_errorMessage) = -1 then	
		fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when creating the notification email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: "+ls_errorMessage)
		continue
	else
		if lnv_mail.of_setcreator( ls_user_id, ls_errorMessage) = -1 then
			fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when creating the notification email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: "+ls_errorMessage)
			continue
		else
			if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
				fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " Error when sending the email for Contract ID: " + string(ll_contracts_id)+". "+char(13)+char(10)+"Reason: "+ls_errorMessage)
				continue
			end if
		end if
	end if	
	fileWrite(gl_logHandle, string(datetime(today(),now()), "dd-mmm-yyyy hh:mm") + " A notification email with Contract ID: " + string(ll_contracts_id)+" is sent!")
	lnv_mail.of_reset( )
next

destroy lnv_mail	
destroy ds_tchire_contracts
destroy ds_office_email

return 1
end function

on u_tchire_contract.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_tchire_contract.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

