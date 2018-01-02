$PBExportHeader$w_msps_messages_list.srw
$PBExportComments$MSPS Messages list
forward
global type w_msps_messages_list from w_tramos_container_vessel
end type
type gb_severity from groupbox within w_msps_messages_list
end type
type dw_list from u_datagrid within w_msps_messages_list
end type
type cb_refresh from mt_u_commandbutton within w_msps_messages_list
end type
type cb_update from mt_u_commandbutton within w_msps_messages_list
end type
type cb_approve from mt_u_commandbutton within w_msps_messages_list
end type
type cb_reject from mt_u_commandbutton within w_msps_messages_list
end type
type cb_active from mt_u_commandbutton within w_msps_messages_list
end type
type cb_cancel from mt_u_commandbutton within w_msps_messages_list
end type
type st_background from u_topbar_background within w_msps_messages_list
end type
type cbx_showstatus from mt_u_checkbox within w_msps_messages_list
end type
type st_lastdays from mt_u_statictext within w_msps_messages_list
end type
type em_lastday from mt_u_editmask within w_msps_messages_list
end type
type dw_popup from u_popupdw within w_msps_messages_list
end type
type st_shiptoship from statictext within w_msps_messages_list
end type
type dw_detail from u_datagrid within w_msps_messages_list
end type
type tab_1 from tab within w_msps_messages_list
end type
type tabpage_terminal from userobject within tab_1
end type
type dw_terminal from mt_u_datawindow within tabpage_terminal
end type
type tabpage_terminal from userobject within tab_1
dw_terminal dw_terminal
end type
type tabpage_cargo from userobject within tab_1
end type
type dw_cargo from mt_u_datawindow within tabpage_cargo
end type
type tabpage_cargo from userobject within tab_1
dw_cargo dw_cargo
end type
type tabpage_tugs from userobject within tab_1
end type
type dw_tugs from mt_u_datawindow within tabpage_tugs
end type
type tabpage_tugs from userobject within tab_1
dw_tugs dw_tugs
end type
type tabpage_additional from userobject within tab_1
end type
type dw_additional from mt_u_datawindow within tabpage_additional
end type
type tabpage_additional from userobject within tab_1
dw_additional dw_additional
end type
type tab_1 from tab within w_msps_messages_list
tabpage_terminal tabpage_terminal
tabpage_cargo tabpage_cargo
tabpage_tugs tabpage_tugs
tabpage_additional tabpage_additional
end type
type dw_master from mt_u_datawindow within w_msps_messages_list
end type
type cb_sendemail from mt_u_commandbutton within w_msps_messages_list
end type
type dw_alerts from u_datagrid within w_msps_messages_list
end type
type dw_severity from u_datagrid within w_msps_messages_list
end type
type cbx_selectall from mt_u_checkbox within w_msps_messages_list
end type
type p_refreshalerts from picture within w_msps_messages_list
end type
end forward

global type w_msps_messages_list from w_tramos_container_vessel
integer x = 471
integer y = 48
integer width = 4891
integer height = 2592
string title = "Vessel Messages List"
boolean maxbox = false
boolean resizable = false
string icon = "images\vessel_messages _list.ico"
boolean ib_setdefaultbackgroundcolor = true
event ue_reject ( )
event type integer ue_approve ( )
event ue_activate ( )
event type integer ue_refreshalerts ( )
event ue_retrievedetail ( long al_row )
gb_severity gb_severity
dw_list dw_list
cb_refresh cb_refresh
cb_update cb_update
cb_approve cb_approve
cb_reject cb_reject
cb_active cb_active
cb_cancel cb_cancel
st_background st_background
cbx_showstatus cbx_showstatus
st_lastdays st_lastdays
em_lastday em_lastday
dw_popup dw_popup
st_shiptoship st_shiptoship
dw_detail dw_detail
tab_1 tab_1
dw_master dw_master
cb_sendemail cb_sendemail
dw_alerts dw_alerts
dw_severity dw_severity
cbx_selectall cbx_selectall
p_refreshalerts p_refreshalerts
end type
global w_msps_messages_list w_msps_messages_list

type variables
boolean 	ib_ignoredefaultbutton
integer	ii_vesselnr[] //vessel select dropdown list all vessel's NR
integer	ii_lastday	  //
long 		il_clickrow	  //clicked row the msps list 
//Message key
long		il_vesselimo
long		il_reportid
long		il_revisionno
string	is_messagetype, is_rejectreason, is_emailaddress[]
integer	ii_severity_notdefined //"not defined(<Not applied>)" severity id

datawindowchild idwc_vessel, idwc_chartagent

//Messagebox title
constant string is_VALIDATIONTITLE = "Validation"
end variables

forward prototypes
public subroutine documentation ()
public function integer wf_sent_email (string as_callfrom)
public function integer wf_validate (string as_msgtype)
public function integer wf_get_primarykey (ref s_poc astr_poc, mt_u_datawindow adw_msps_source, long al_row)
public subroutine wf_add_array (datetime adt_date, string as_label, ref datetime adt_targetdate[], ref string as_targetlabel[])
public subroutine wf_insertdata_dddw (string as_columnname, string as_label[], datetime adt_date[])
public function integer wf_exists_arrivalmessage (s_poc astr_poc, datetime adt_sentdate)
public function integer wf_get_emailaddress (ref string as_emailaddress[])
private subroutine _set_permissions (integer ai_msgstatus)
public function integer wf_match_liftedbunkers (string as_msgtype)
public subroutine wf_load_arrivaldate (string as_msgtype)
public subroutine wf_load_berthingdate (string as_msgtype)
public function integer wf_load_chartereragent (long al_row, boolean ab_setitemstatus)
public function integer wf_check_datamodified ()
public subroutine wf_load_departuredate (string as_msgtype)
public subroutine wf_load_vessel (long al_row, boolean ab_setitemstatus)
private subroutine _retrievemessage (long al_row)
public function integer wf_set_loadedcargo (boolean ab_setallrows)
public subroutine wf_filter ()
end prototypes

event ue_reject();/********************************************************************
   ue_reject
   <DESC>Rejected message</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>cb_reject.clicked event</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-03-2012 ?            LHC010             First Version
   	02/08/2013 CR3238       LHG008             Change wf_sent_email() function
   	08/04/2014 CR3599       LHG008             Local time issue
   </HISTORY>
********************************************************************/

string ls_return, ls_callfrom = "reject"
integer li_row

li_row = dw_master.getrow( )

if li_row <= 0 then return

if wf_get_emailaddress(is_emailaddress) = c#return.Failure then return

openwithparm(w_msps_rejectreason, ls_callfrom, this)

ls_return = message.stringparm

if ls_return = "sent" then
	dw_master.setitem( 1, "rejection_reason", is_rejectreason)
	dw_master.setitem( 1, "msg_status", c#msps.ii_REJECTED)
	dw_master.setitem( 1, "approve_date", now())
	dw_master.setitem( 1, "server_approve_date", f_getdbserverdatetime())
	dw_master.setitem( 1, "approve_by", uo_global.is_userid )
	dw_master.setitem( 1, "mail_status", c#msps.ii_SENDMAIL)
	wf_sent_email(ls_callfrom)
	cb_update.triggerevent(clicked!)
end if
end event

event type integer ue_approve();/********************************************************************
   ue_approve
   <DESC>	Approve message	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>cb_approve.clicked event</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-03-2012 CR20         LHC010             First Version
		26-05-2012 CR3238			LHC010             Fix if there is no email address then do not send email
		02/08/2013 CR3238       LHG008             1. Change wf_sent_email() function
		                                           2. For Heating message, only change the message status to Archived
		18/10/2013 CR3340       LHG008             Fix refresh when cargo windows is opened
		28/12/2013 CR3240       LHG008             Only refresh current row
		13/03/2014 CR3340       LHG008             Improve message
		08/04/2014 CR3599       LHG008             Local time issue
   </HISTORY>
********************************************************************/

long		ll_row
string 	ls_rejectionreason, ls_message
integer	li_return, li_messagestatus, li_mailstatus, li_null, li_orginal_messagestatus, li_appreturn
n_approve_vesselmsg	lnv_approve
n_service_manager lnv_service

ll_row = dw_list.getselectedrow(0)

if ll_row <= 0 then return c#return.NoAction

lnv_service.of_loadservice(lnv_approve, "n_approve_vesselmsg")

if is_messagetype = c#msps.is_HEATING then
	if Messagebox("Confirmation", "Are you sure to archive the Heating message?", question!, YesNo!, 1) <> 1 then
		return c#return.NoAction
	end if
else
	if wf_validate(is_messagetype) < 0 then return c#return.Failure
	
	if Messagebox("Warning", "You are about to approve the vessel's message, all the relevant data in ~r~n~r~n" +&
		"Operation will be overwritten by the data in the message, are you sure?", question!, YesNo!, 1) <> 1 then
		return c#return.NoAction
	end if
	
	setnull(li_null)
	
	li_orginal_messagestatus = dw_master.getitemnumber(1, "msg_status")
	
	if li_orginal_messagestatus = c#msps.ii_ACTIVE then
		dw_master.setitem(1, "mail_status", li_null)
		dw_master.setitemstatus(1, "mail_status", primary!, NotModified!)
	end if
	
	lnv_approve.of_set_message_type(is_messagetype)
end if

choose case is_messagetype
	case c#msps.is_NOON //Noon message
		li_appreturn = lnv_approve.of_approve_position(dw_master)
		
	case c#msps.is_ARRIVAL //Arrival message
		li_appreturn = lnv_approve.of_approve_arrival(dw_master)	
		
	case c#msps.is_LOAD, c#msps.is_DISCHARGE //Load message/Discharge message
		li_appreturn = lnv_approve.of_approve_departure(dw_master, tab_1.tabpage_cargo.dw_cargo)
		
	case c#msps.is_CANAL, c#msps.is_FWODRIFT //Canal message/FWO-Drift message
		li_appreturn = lnv_approve.of_approve_estpoc_to_actpoc(dw_master)
		
	case c#msps.is_HEATING //Heating message. For Heating message, only change the message status to Archived
		dw_master.setitem(1, "msg_status", c#msps.ii_ARCHIVE)
		dw_master.setitem(1, "approve_by", uo_global.is_userid)
		dw_master.setitem(1, "approve_date", datetime(today(), now()))
		dw_master.setitem(1, "server_approve_date", f_getdbserverdatetime())
		triggerevent("ue_update")
		return c#return.Success
end choose

if li_appreturn = c#return.NoAction then return c#return.NoAction

li_messagestatus = dw_master.getitemnumber(1, "msg_status")
li_mailstatus	  = lnv_approve.ii_sendmail_status

if li_mailstatus = c#msps.ii_SENDMAIL then
	ls_rejectionreason = dw_master.getitemstring(1, "rejection_reason")
	
	if isnull(ls_rejectionreason) then ls_rejectionreason = ""
	
	if li_messagestatus = c#msps.ii_APPROVED then
		ls_message = "Approval succeeds with notes below.~r~n~r~n" +  ls_rejectionreason + "~r~n~r~n" + &
						 "Do you want to inform the vessel and request a new report?"
						  
	elseif li_messagestatus = c#msps.ii_FAILED then
		ls_message = "Approval failed.~r~n~r~n" +  ls_rejectionreason + "~r~n~r~n" + &
						 "Do you want to inform the vessel and request a new report?"
	
	end if
	
	li_return = MessageBox("Approve Info", ls_message, Question!, YesNo!, 1)
	
	if li_return = 1 then
		dw_master.setitem(1, "mail_status", c#msps.ii_SENDMAIL)
	else
		dw_master.setitem(1, "mail_status", li_null)
	end if

	//sent email
	if li_return = 1 then 
		is_rejectreason = ls_rejectionreason
		if wf_sent_email("approve") = c#return.Failure then dw_master.setitem(1, "mail_status", li_null)
	end if
	
	triggerevent("ue_update")

elseif li_messagestatus = c#msps.ii_APPROVED and li_appreturn = c#return.Success then
	if li_orginal_messagestatus = c#msps.ii_ACTIVE then
		dw_master.setitemstatus(1, "mail_status", primary!, NotModified!)
	end if
	MessageBox("Approve Info", "The message is approved successfully.")
elseif li_messagestatus = c#msps.ii_ARCHIVE then
	if li_orginal_messagestatus = c#msps.ii_ACTIVE then
		dw_master.setitemstatus(1, "mail_status", primary!, NotModified!)
	end if
	MessageBox("Approve Info", "There are more than one charterer for this voyage. " +&
					"Heating claim cannot be generated. "  + & 
					"The message is archived now. Please manually update the data into TRAMOS.")
else
	MessageBox("Approve Info", "Approved message with exception.")
end if

if isvalid(w_port_of_call) and dw_master.getrow( ) > 0 then
	if dw_master.getitemnumber(1, "vessel_nr") = w_port_of_call.ii_vessel_nr then
		w_port_of_call.cb_refresh.post event clicked()
	end if
end if 

if (is_messagetype = c#msps.is_LOAD or is_messagetype = c#msps.is_DISCHARGE) and isvalid(w_cargo) and dw_master.getrow( ) > 0 then
	if dw_master.getitemnumber(1, "vessel_nr") = w_cargo.ii_vessel_nr then
		w_cargo.cb_refresh.post event clicked()
	end if
end if

post event ue_retrievedetail(ll_row)
return li_return
end event

event ue_activate();/********************************************************************
   ue_activate
   <DESC> reactivate/deactivate</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-03-2012 cr20         LHC010        First Version
		28-05-2012 CR3238			LHC010		  Arrival message should not be activated again when departure 
														  message of this port is approved . 
		08/04/2014 CR3599       LHG008        Local time issue
   </HISTORY>
********************************************************************/
integer	li_count, li_active, li_status, li_originalstatus, li_mailstatus
datetime ldt_sentdate
constant string ls_NOTREACTIVATE = "This message cannot be activated."
s_poc	lstr_poc

if dw_master.rowcount() <= 0 then return

if cb_active.text = "Deac&tivate" then
	//set the status from active to original status
	li_originalstatus = dw_master.getitemnumber(1, "original_status")
	li_status = li_originalstatus
else
	//get the vessel,voyage,port code,pcn
	wf_get_primarykey(lstr_poc, dw_master, 1)

	//set the status from failed/approved to active
	li_active = c#msps.ii_ACTIVE
	
	li_mailstatus = dw_master.getitemnumber(1, "mail_status")
	li_originalstatus = dw_master.getitemnumber(1, "msg_status")
	
	//if message is heating then no need port code check
	if is_messagetype = c#msps.is_HEATING then
		lstr_poc.port_code = ""
	end if

	if li_mailstatus = c#msps.ii_SENDMAIL and uo_global.ii_access_level = c#usergroup.#USER then
		MessageBox(is_VALIDATIONTITLE, "An email has been sent to the vessel to request a new report." + ls_NOTREACTIVATE)
		return
	end if
	
	SELECT count('x') 
	  INTO :li_count
     FROM MSPS_MSGLIST_VIEW 
    WHERE lower(MSG_TYPE) = :is_messagetype
		AND MSG_STATUS = :li_active
		AND VESSEL_NR = :lstr_poc.vessel_nr
		AND VOYAGE_NO = :lstr_poc.voyage_nr
		AND (PORT_CODE = :lstr_poc.port_code AND PCN = :lstr_poc.pcn OR :lstr_poc.port_code = "");
		
	if li_count > 0 then
		MessageBox(is_VALIDATIONTITLE, "There is already an active message existing at this port." + ls_NOTREACTIVATE)
		return 
	end if
	
	ldt_sentdate = dw_master.getitemdatetime(1, "sent_date_utc")

	//Arrival message should not be activated again when departure message is approved(same vessel, same voyage, same port).
	if is_messagetype = c#msps.is_ARRIVAL then
		SELECT count('x') 
		  INTO :li_count
		  FROM MSPS_MSGLIST_VIEW
		 WHERE lower(MSG_TYPE) in('loading', 'discharging', 'canal', 'fwo/drift')
			AND MSG_STATUS = 4 
			AND VESSEL_NR = :lstr_poc.vessel_nr
			AND VOYAGE_NO = :lstr_poc.voyage_nr
			AND (PORT_CODE = :lstr_poc.port_code AND PCN = :lstr_poc.pcn);
			//AND SENT_DATE_UTC > :ldt_sentdate;
		
		if li_count > 0 then
			messagebox(is_VALIDATIONTITLE, "Arrival message can not be activated as the departure message for this port has been approved.")
			return
		end if
	end if
	
	if uo_global.ii_access_level = c#usergroup.#SUPERUSER or uo_global.ii_access_level = c#usergroup.#USER then
	/*User should be able to active the last message, message with status 
	2:archived/3:rejected/4:approved/5:failed and no email is sent to the vessel can be active again*/
		SELECT count('x') 
		  INTO :li_count
		  FROM MSPS_MSGLIST_VIEW 
		 WHERE lower(MSG_TYPE) = :is_messagetype
			AND MSG_STATUS in(1, 2, 3, 4, 5) 
			AND VESSEL_NR = :lstr_poc.vessel_nr
			AND VOYAGE_NO = :lstr_poc.voyage_nr
			AND (PORT_CODE = :lstr_poc.port_code AND PCN = :lstr_poc.pcn OR :lstr_poc.port_code = "")
			AND SENT_DATE_UTC > :ldt_sentdate;
//	/*User should be able to active the last message, message with status 
//	4:approved/5:failed and no email is sent to the vessel can be active again*/		
//	elseif uo_global.ii_access_level = c#usergroup.#USER then
//		SELECT count('x') 
//		  INTO :li_count
//		  FROM MSPS_MSGLIST_VIEW 
//		 WHERE lower(MSG_TYPE) = :is_messagetype
//			AND MSG_STATUS in(1, 4, 5) 
//			AND VESSEL_NR = :lstr_poc.vessel_nr
//			AND VOYAGE_NO = :lstr_poc.voyage_nr
//			AND (PORT_CODE = :lstr_poc.port_code AND PCN = :lstr_poc.pcn OR :lstr_poc.port_code = "")
//			AND SENT_DATE_UTC > :ldt_sentdate;		
	end if
	
	if li_count > 0 then
		MessageBox(is_VALIDATIONTITLE, "Only the last failed/approved message can be activated. There are other messages after this message." + ls_NOTREACTIVATE)
		return 		
	end if
	li_status = c#msps.ii_ACTIVE
	dw_master.setitem(1, "original_status", li_originalstatus)
end if
dw_master.setitem(1, "msg_status", li_status)
dw_master.setitem(1, "approve_date", now())
dw_master.setitem(1, "server_approve_date", f_getdbserverdatetime())
dw_master.setitem(1, "approve_by", uo_global.is_userid )
cb_update.triggerevent(clicked!)

end event

event type integer ue_refreshalerts();/********************************************************************
   ue_refreshalerts
   <DESC>	Generate alerts	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, 1 ok
            <LI> c#return.Failure, -1 failed
				<LI> c#return.NoAction, 0 no action </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call in p_refreshalerts.clicked() and ue_update()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		08/01/2014	CR3240	LHG008	First Version
   </HISTORY>
********************************************************************/

long		ll_row, ll_vesselimo, ll_reportid, ll_revisionno
long		ll_severityid, ll_severitycolor
integer	li_severitylevel, li_return = c#return.NoAction
string	ls_messagetype
n_generate_alerts lnv_alerts

dw_master.accepttext( )
tab_1.tabpage_cargo.dw_cargo.accepttext( )

if dw_master.rowcount() <> 1 then return li_return

if dw_master.modifiedcount() + tab_1.tabpage_cargo.dw_cargo.modifiedcount() > 0 then
	messagebox("Data Not Saved", "Please update the data, before updating the alerts.")
	li_return = c#return.failure
else
	ll_row = dw_list.getselectedrow(0)
	ll_vesselimo = dw_list.getitemnumber(ll_row, "vessel_imo")
	ll_reportid = dw_list.getitemnumber(ll_row, "report_id")
	ll_revisionno = dw_list.getitemnumber(ll_row, "revision_no")
	ls_messagetype = lower(dw_list.getitemstring(ll_row, "msg_type"))
	
	li_return = lnv_alerts.of_generate_alerts(ll_vesselimo, ll_reportid, ll_revisionno, ls_messagetype, uo_global.ib_rul_generatenotdefined)
end if

if li_return = c#return.Success then
	setnull(ll_severityid)
	setnull(ll_severitycolor)
	setnull(li_severitylevel)
	
	SELECT SEVERITY_ID, SEVERITY_LEVEL, SEVERITY_COLOR
	  INTO :ll_severityid, :li_severitylevel, :ll_severitycolor
	  FROM RUL_SEVERITIES
	 WHERE SEVERITY_LEVEL = (SELECT MIN(SEVERITY_LEVEL)
										FROM RUL_ALERTS, RUL_SEVERITIES
									  WHERE RUL_ALERTS.SEVERITY_ID = RUL_SEVERITIES.SEVERITY_ID
										 AND VESSEL_IMO = :ll_vesselimo
										 AND REPORT_ID = :ll_reportid
										 AND REVISION_NO = :ll_revisionno
										 AND MSG_TYPE = :ls_messagetype);

	dw_list.setitem(ll_row, 'severity_id', ll_severityid)
	dw_list.setitem(ll_row, 'severity_level', li_severitylevel)
	dw_list.setitem(ll_row, 'severity_color', ll_severitycolor)
end if

return li_return
end event

event ue_retrievedetail(long al_row);/********************************************************************
   ue_retrievedetail
   <DESC>	Refresh detail	</DESC>
   <RETURN>	(None)
	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
				al_row
   </ARGS>
   <USAGE> ue_update(), ue_approve() </USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		15/01/2014	CR3240	LHG008	First Version
   </HISTORY>
********************************************************************/

integer	li_msgstatus
string	ls_messagetype
long		ll_vesselimo, ll_reportid, ll_revisionno

if al_row > 0 and al_row <= dw_list.rowcount() then
	this.setredraw(false)
	
	ls_messagetype = dw_list.getitemstring(al_row, "msg_type")
	ll_vesselimo = dw_list.getitemnumber(al_row, "vessel_imo")
	ll_reportid = dw_list.getitemnumber(al_row, "report_id")
	ll_revisionno = dw_list.getitemnumber(al_row, "revision_no")
	
	SELECT MSG_STATUS
	  INTO :li_msgstatus
	  FROM MSPS_MSGLIST_VIEW
	 WHERE VESSEL_IMO = :ll_vesselimo
	   AND REPORT_ID = :ll_reportid
	   AND REVISION_NO = :ll_revisionno
		AND MSG_TYPE = :ls_messagetype;
		
	dw_list.setitem(al_row, 'msg_status', li_msgstatus)
	
	_retrievemessage(al_row)
	
	this.post setredraw(true)
end if
end event

public subroutine documentation ();/********************************************************************
   w_msps_messages_list
   <OBJECT>		Display MSPS messages and approved/rejected message</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
		Date      	CR-Ref   	Author		Comments
		13-12-2011	cr20     	LHC010		First Version
		15-05-2013	2690     	LGX001		Change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
		11-06-2013	CR3238   	LHC010		Fix bug for UAT
		09-07-2013	CR3254   	LHC010		Replace n_string_service
		12-07-2013	CR3286   	LHC010		Add MSPS setup
		02/08/2013	CR3238   	LHG008		1. Add send email button
														2. For Heating message, only change the message status to Archived
		17/10/2013	CR3340   	LHG008		1. Canal/FWO message can be approved without approving Arrivals first
														2. Fix refresh when cargo windows is opened
		26/12/2013	CR3240   	LHG008		Generate alerts and display alerts in Noon messages
		18/02/2014	CR3240UAT	LHG008		Use picture object for "Refresh Alerts" button
		13/03/2014	CR3340UAT	LHG008		Improve message
		08/04/2014	CR3599   	LHG008		Local time issue
		10/04/2014	CR3573   	LHG008		Add the purpose validation for load and discharge message
		04/08/2014	CR3708   	AGL027		F1 help application coverage - change of ancestor
		12/09/14  	CR3773   	XSZ004		Change icon absolute path to reference path
		17/10/16		CR4224		CCY018		Remove w_cargo_input window
	</HISTORY>
********************************************************************/
end subroutine

public function integer wf_sent_email (string as_callfrom);/********************************************************************
   wf_sent_email
   <DESC>	Sent email</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_callfrom: "approve"/"reject"
   </ARGS>
   <USAGE>ue_approved event, ue_reject event, cb_sendemail.clicked event</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	06-03-2012 ?            LHC010             First Version
		24-05-2013 CR3238			LHC010             Fix if email-sending is failed then not show the email icon.
		18/10/2013 CR3340			LHG008				 The email changed be sent from Operator's email who approved the message
   </HISTORY>
********************************************************************/

string	ls_message, ls_errorMessage, ls_emailfrom, ls_subject = "Tramos alert"
string 	ls_reporttype, ls_reportno,  ls_reason, ls_rejectionreason 
integer	li_msgstatus, li_mailstatus
long		ll_row, ll_row_res
CONSTANT STRING ls_CRLF="~r~n"
mt_n_outgoingmail	lnv_mail

ll_row = dw_list.getselectedrow(0)

if ll_row <= 0 or dw_master.getrow() <= 0 then return c#return.NoAction

ls_emailfrom = uo_global.is_userid + C#EMAIL.DOMAIN

if lower(as_callfrom) = "approve" then
	//For other, emailaddress already got before call this funcion.
	if wf_get_emailaddress(is_emailaddress) = c#return.Failure then return c#return.Failure
end if

ls_rejectionreason = is_rejectreason
ls_reporttype = dw_list.getitemstring( ll_row, "report_type")
ls_reportno = string(dw_list.getitemnumber( ll_row, "report_no"))

if isnull(ls_rejectionreason) then ls_rejectionreason = ""
if isnull(ls_reporttype) then ls_reporttype = ""
if isnull(ls_reportno) then ls_reportno = ""

if lower(as_callfrom) = "approve" or lower(as_callfrom) = "reject" then
	//If no need send mail then return NoAction
	li_mailstatus = dw_master.getitemnumber( 1, "mail_status")
	if li_mailstatus <> c#msps.ii_SENDMAIL then return c#return.NoAction

	li_msgstatus = dw_master.getitemnumber( 1, "msg_status")
	//if not(li_msgstatus = c#msps.ii_NEW or li_msgstatus = c#msps.ii_REJECTED) then return c#return.NoAction
	
	choose case li_msgstatus
		case c#msps.ii_REJECTED
			ls_message = "This message is rejected on " + string(today(),"dd-mmm-yyyy hh:mm") + " by " + uo_global.is_userid + "." + ls_CRLF
			ls_reason  = "Reject reason: "
		case c#msps.ii_APPROVED
			ls_message = "The message has been modified, please amend in MSPS." + ls_CRLF
			ls_reason  = "Approved notes: "
		case c#msps.ii_FAILED
			ls_message = "The message has been approved with failure, please send the message again." + ls_CRLF
			ls_reason  = "Failed reason: "
	end choose
end if

ls_message += "Vessel IMO: " + string(il_vesselimo) + ls_CRLF + &
				 "Report No: " +  ls_reportno + ls_CRLF + &
				 "Revision No: " +  string(il_revisionno) + ls_CRLF + &
				 "Report Type: " +  ls_reporttype + ls_CRLF + &
				 ls_reason + ls_rejectionreason

lnv_mail = create mt_n_outgoingmail
	
//CREATE EMAIL
if lnv_mail.of_createmail(ls_emailfrom, is_emailaddress[1], ls_subject, ls_message, ls_errorMessage) = -1 then	
	Messagebox("Error", "Error when creating the email. "+ls_errorMessage)
	destroy (lnv_mail)
	return c#return.Failure
end if

if lnv_mail.of_setcreator(uo_global.is_userid, ls_errorMessage) = -1 then
	Messagebox("Error", "Error when creating the email in Set Creator. "+ls_errorMessage)
	destroy (lnv_mail)
	return c#return.Failure
end if

for ll_row = 2 to upperbound(is_emailaddress)
	//ADD EMAIL ADDRESS
	lnv_mail.of_addreceiver(is_emailaddress[ll_row], ls_errorMessage )
next

if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
	Messagebox("Error", "Error when sending the email. "+ls_errorMessage)
	destroy (lnv_mail)
	return c#return.Failure
end if

destroy (lnv_mail)

return c#return.Success
end function

public function integer wf_validate (string as_msgtype);/********************************************************************
   wf_validate
   <DESC>	Checked pcn,arrival,charterer/agent,lifted bunkers </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Approve	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-12-2011 cr20         LHC010        First Version
		26-05-2013 CR3238			LHC010		  Improve the message when voyage is empty.
		11-09-2013 CR3238			LHC010		  Add the purpose validation for load and discharge message
		17/10/2013 CR3340			LHC010		  Canal/FWO message can be approved without approving Arrivals first
		13/03/2014 CR3340			LHG008		  Improve message
		10/04/2014 CR3573			LHG008		  Add the purpose validation for load and discharge message
	</HISTORY>
********************************************************************/
integer	li_rowcount, li_findrow, li_chartagentrows, li_count
datetime ldt_arrival, ldt_sentdate
string ls_findexp, ls_chartagent, ls_purposecode
integer li_cargorowcount, li_row

constant string ls_NOTAPPROVED = "The message cannot be approved. ~r~n~r~n"
s_poc	lstr_poc
mt_u_datawindow 	ldw_cargo
n_validate_poc 	lnv_validatepoc

if dw_master.rowcount() <= 0 then return c#return.success

dw_master.accepttext()
tab_1.tabpage_cargo.dw_cargo.accepttext()

if dw_master.modifiedcount() + tab_1.tabpage_cargo.dw_cargo.modifiedcount() > 0 then
	if MessageBox("Data Not Saved", "MSPS messages data is modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before approving?", Question!, YesNo!, 1) = 1 then
		cb_update.triggerEvent(Clicked!)
	else
		cb_cancel.triggerevent(Clicked!)
	end if
end if

//get vessel,voyage,port code,pcn
wf_get_primarykey(lstr_poc, dw_master, 1)

//check voyage
if lnv_validatepoc.of_exists_voyage(lstr_poc) = c#return.Failure then
	if isnull(lstr_poc.voyage_nr) or len(lstr_poc.voyage_nr) <= 0 then
		Messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "When there is no voyage number.")
	else
		Messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "The voyage does not exist in Proceeding.")
	end if
	return c#return.Failure
end if

//check port	
if as_msgtype <> c#msps.is_HEATING and lnv_validatepoc.of_exists_proceeding(lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.port_code) <= 0 then
	if isnull(lstr_poc.port_code) or len(lstr_poc.port_code) <= 0 then
		Messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "The port is empty.")
	else
		Messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + 'The proceeding for "' + lstr_poc.port_code + '" does not exist in Proceeding picture.')
	end if
	return c#return.Failure
end if

//check pcn
if as_msgtype <> c#msps.is_HEATING and isnull(lstr_poc.pcn) then
	MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "Please select a PCN for the port.")
	dw_master.setcolumn("pcn")
	dw_master.setfocus()
	return c#return.Failure
end if

//No need to check Heating message
if as_msgtype = c#msps.is_HEATING then return c#return.NoAction

//check voyage is finished
if lnv_validatepoc.of_is_finishedvoyage(lstr_poc) = c#return.Success then
	Messagebox(is_VALIDATIONTITLE, "The voyage is finished, please activate the voyage before approving the message.")
	return c#return.Failure
end if

//check port	
if lnv_validatepoc.of_iscancel_proceeding(lstr_poc) = c#return.Success then
	Messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + 'The proceeding for "' + lstr_poc.port_code + '" is Cancel in Proceeding picture.')
	return c#return.Failure
end if

//check the existence of arrival message before the sent date
if as_msgtype = c#msps.is_LOAD  or as_msgtype = c#msps.is_DISCHARGE THEN
	ldt_sentdate = dw_master.getitemdatetime(1, "sent_date_utc")
	if wf_exists_arrivalmessage(lstr_poc, ldt_sentdate) = c#return.Success then
		Messagebox(is_VALIDATIONTITLE,ls_NOTAPPROVED + "There is an unapproved Arrival message before the departure message.")
		return c#return.Failure
	end if
end if

//check lifted bunkers
if wf_match_liftedbunkers(as_msgtype) = c#return.Failure then
	messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "The lifted bunkers do not match with Bunker Purchase.")
	return c#return.Failure
end if

choose case as_msgtype
	case c#msps.is_LOAD,c#msps.is_DISCHARGE
		//Add the purpose validation for load and discharge message.
		SELECT PURPOSE_CODE 
		 INTO: ls_purposecode 
		  FROM POC 			
		 WHERE VESSEL_NR = :lstr_poc.vessel_nr 
			AND VOYAGE_NR = :lstr_poc.voyage_nr 
			AND PORT_CODE = :lstr_poc.port_code 
			AND PCN = :lstr_poc.pcn;

		//if the port is not registered an actual POC then skip the validation
		if sqlca.sqlcode = 100 then ls_purposecode = ''
		if len(ls_purposecode) > 0 and not isnull(ls_purposecode) then
			if as_msgtype = c#msps.is_LOAD and (ls_purposecode <> "L" and ls_purposecode <> "L/D") then
				MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "The purpose of this port of call is not 'L' or 'L/D'.")
				return c#return.Failure
			end if
	
			if as_msgtype = c#msps.is_DISCHARGE and (ls_purposecode <> "D" and ls_purposecode <> "L/D") then
				MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "The purpose of this port of call is not 'D' or 'L/D'.")
				return c#return.Failure
			end if
		end if

		//check charterer/agent
		ldw_cargo = tab_1.tabpage_cargo.dw_cargo
		li_rowcount = ldw_cargo.rowcount()
		if li_rowcount > 0 then
			li_findrow = ldw_cargo.find("isnull(chart_nr)", 1, li_rowcount)
			if li_findrow > 0 then
				MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "Please select or new a Charterer/Agent for the cargo.")
				tab_1.selecttab(2)
				ldw_cargo.scrolltorow(li_findrow )
				ldw_cargo.setrow(li_findrow )
				ldw_cargo.setcolumn("charterer_agent")
				ldw_cargo.setfocus()
				return c#return.Failure
			end if
		end if
				
		li_chartagentrows = idwc_chartagent.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.port_code, lstr_poc.pcn)
		
		for li_row = 1 to li_rowcount
			ls_chartagent = ldw_cargo.getitemstring(li_row, "charterer_agent")
			ls_findexp = "chartagent ='" + ls_chartagent + "'"
			li_findrow = idwc_chartagent.find(ls_findexp, 1, li_chartagentrows)
			if li_findrow <= 0 then
				//clear charterer/agent data if dropdown not exists charterer/agent
				wf_load_chartereragent(1, false)
				
				wf_set_loadedcargo(true)
				
				MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "Please select or new a Charterer/Agent for the cargo again, because the Charterer/Agent has been deleted.")
				tab_1.selecttab(2)
				ldw_cargo.scrolltorow(li_row)
				ldw_cargo.setrow(li_row)
				ldw_cargo.setcolumn("charterer_agent")
				ldw_cargo.setfocus()
				return c#return.Failure
			end if
			
			//check loaded cargo
			if as_msgtype = c#msps.is_DISCHARGE then
				if isnull(ldw_cargo.getitemnumber(li_row, "load_cargo_detail_id")) then
					MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "Please select a Loaded Cargo.")
					tab_1.selecttab(2)
					ldw_cargo.scrolltorow(li_row)
					ldw_cargo.setrow(li_row)
					ldw_cargo.setcolumn("load_cargo_detail_id")
					ldw_cargo.setfocus()
					
					wf_set_loadedcargo(false)
					return c#return.Failure
				end if
			end if
		next
	case c#msps.is_ARRIVAL, c#msps.is_CANAL, c#msps.is_FWODRIFT, c#msps.is_NOON
		//check arrival date
		ldt_arrival = dw_master.getitemdatetime(1, "arrival_date")
		if isnull(ldt_arrival) then
			MessageBox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "Arrival Date cannot be empty.")
			dw_master.setcolumn("arrival_date")
			dw_master.setfocus()
			return c#return.Failure
		end if
end choose

SELECT COUNT(PURPOSE_CODE) INTO :li_count FROM PURPOSE WHERE PURPOSE_CODE = 'TFV';

if li_count <= 0 or isnull(li_count) then
	Messagebox(is_VALIDATIONTITLE, ls_NOTAPPROVED + "The purpose TFV does not exist.")
	return c#return.Failure
end if

return c#return.SUCCESS
end function

public function integer wf_get_primarykey (ref s_poc astr_poc, mt_u_datawindow adw_msps_source, long al_row);/********************************************************************
   wf_get_primarykey
   <DESC>	get the vessel,voyage,portcode and pcn	</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		adw_msps_source
		al_row
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	07-03-2012 CR20         LHC010        First Version
   </HISTORY>
********************************************************************/

if al_row <= 0 or not isvalid(adw_msps_source) then return c#return.Failure
if adw_msps_source.rowcount() <= 0  then return c#return.Failure

astr_poc.vessel_nr = adw_msps_source.getitemnumber(al_row, "vessel_nr" )
astr_poc.voyage_nr = adw_msps_source.getitemstring(al_row, "voyage_no")
astr_poc.port_code = adw_msps_source.getitemstring(al_row, "port_code")
astr_poc.pcn	    = adw_msps_source.getitemnumber(al_row, "pcn")

return c#return.Success

end function

public subroutine wf_add_array (datetime adt_date, string as_label, ref datetime adt_targetdate[], ref string as_targetlabel[]);/********************************************************************
   wf_add_array
   <DESC>Add data to array</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adt_date
		as_label
		adt_targetdate
		as_targetlabel
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-03-2012 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
integer li_upperbound

if not isnull(adt_date) then
	li_upperbound = upperbound(as_targetlabel) + 1
	as_targetlabel[li_upperbound] = as_label
	adt_targetdate[li_upperbound] = adt_date
end if

end subroutine

public subroutine wf_insertdata_dddw (string as_columnname, string as_label[], datetime adt_date[]);/********************************************************************
   wf_insertdata_dddw
   <DESC>	Insert data into arrival, berthing, departure date dropdown list</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_columnname
		as_label[]
		adt_date[]
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	07-03-2012 CR20         LHC010        First Version
   </HISTORY>
********************************************************************/
integer li_row, li_upperbound
datawindowchild ldwc_date

dw_master.getchild(as_columnname, ldwc_date)

for li_upperbound = 1 to upperbound(as_label)
	li_row = ldwc_date.insertrow( 0 )
	ldwc_date.setitem( li_row, "select_name", as_label[li_upperbound])
	ldwc_date.setitem( li_row, "date_value", adt_date[li_upperbound])
next
end subroutine

public function integer wf_exists_arrivalmessage (s_poc astr_poc, datetime adt_sentdate);/********************************************************************
   wf_exists_arrivalmessage
   <DESC>	It is not allowed to have an arrival message (status is 1:new or 6:active) 
				before the canal,fwo/drift,load,discharge messages to be approved.
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		astr_poc
		adt_sentdate: canal,fwo/drift,load,discharge messages
  </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-03-2012 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
integer li_count

SELECT COUNT('X')
  INTO :li_count
 FROM MSPS_ARRIVAL, MSPS_REPORT
WHERE MSPS_ARRIVAL.VESSEL_IMO = MSPS_REPORT.VESSEL_IMO
  AND MSPS_ARRIVAL.REPORT_ID  = MSPS_REPORT.REPORT_ID
  AND MSPS_ARRIVAL.REVISION_NO = MSPS_REPORT.REVISION_NO
  AND MSPS_ARRIVAL.MSG_STATUS IN(1, 6)
  AND MSPS_ARRIVAL.VESSEL_NR = :astr_poc.vessel_nr
  AND MSPS_ARRIVAL.VOYAGE_NO = :astr_poc.voyage_nr
  AND MSPS_REPORT.PORT_CODE = :astr_poc.port_code
  AND MSPS_ARRIVAL.PCN = :astr_poc.pcn
  AND MSPS_REPORT.SENT_DATE_UTC <= :adt_sentdate;

if li_count > 0 then
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer wf_get_emailaddress (ref string as_emailaddress[]);/********************************************************************
   wf_get_emailaddress
   <DESC>get the email address from vessel the same IMO</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_emailaddress[]
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-03-2012 CR20         LHC010        First Version
   	02/08/2013 CR3238       LHG008        Parameter change to string array
   </HISTORY>
********************************************************************/

string	ls_message, ls_errorMessage
string 	ls_emailaddress[], ls_invalidemails
long		ll_row, ll_rowcount, ll_row_res
integer	li_return
mt_n_datastore  lds_vesselemail
mt_n_outgoingmail	lnv_mail

li_return = c#return.Success
as_emailaddress = ls_emailaddress

lds_vesselemail = create mt_n_datastore
lds_vesselemail.dataobject = "d_dddw_msps_vessels"
lds_vesselemail.settransobject(sqlca)

ll_rowcount = lds_vesselemail.retrieve(il_vesselimo)

if ll_rowcount > 0 then
	lnv_mail = create mt_n_outgoingmail
	
	for ll_row=1 to ll_rowcount
		ls_emailaddress[ll_row] = lds_vesselemail.getitemstring(ll_row, "vessel_email")
		if not isnull(ls_emailaddress[ll_row]) then
			//check if is valid
			if lnv_mail.of_verifyreceiveraddress(ls_emailaddress[ll_row], ls_errorMessage) = 1 then
				ll_row_res = ll_row_res + 1
				as_emailaddress[ll_row_res] = ls_emailaddress[ll_row]
			else
				ls_invalidemails = ls_invalidemails + "; " + ls_emailaddress[ll_row]
			end if
		end if
	next
	
	if upperbound(as_emailaddress) <= 0 then
		Messagebox("Validation", "The email address is empty in System tables -> General -> Vessels, therefore the system cannot send the email to the vessel. Please update the email address and send the email.")
		li_return = c#return.Failure
	end if
else
	li_return = c#return.Failure
end if

destroy (lds_vesselemail)
destroy (lnv_mail)

return li_return
end function

private subroutine _set_permissions (integer ai_msgstatus);/********************************************************************
   _set_permissions
   <DESC>set access level</DESC>
   <RETURN>	(none):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		ai_msgstatus
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-12-2011 CR20         LHC010        First Version
		12-07-2013 CR3286			LHC010		  Add MSPS setup
   	31/07/2013 CR3238			LHG008        1. Add Send Email button; 
														  2. It should not be possible to Activate an archived heating message.
		27/12/2013 CR3240			LHG008        Add Refresh Alerts button
		18/02/2014 CR3240UAT		LHG008        Use picture object for "Refresh Alerts" button
   </HISTORY>
********************************************************************/

cb_update.enabled = false
cb_approve.enabled = false
cb_reject.enabled = false
cb_active.enabled = false
cb_cancel.enabled = false
cb_sendemail.enabled = false
p_refreshalerts.visible = false
dw_master.Modify("DataWindow.ReadOnly=Yes")
tab_1.tabpage_cargo.dw_cargo.modify("DataWindow.ReadOnly=Yes")
tab_1.tabpage_cargo.dw_cargo.modify("b_chartereragent.enabled=no")

if ai_msgstatus = c#msps.ii_ACTIVE then
	cb_active.text = "Deac&tivate"
else
	cb_active.text = "Ac&tivate"
end if

choose case is_messagetype
	case c#msps.is_NOON
		if not uo_global.ib_msps_noonbuttons then return
	case c#msps.is_HEATING
		if not uo_global.ib_msps_heatingbuttons then return
	case c#msps.is_ARRIVAL
		if not uo_global.ib_msps_arrivalbuttons then return
	case c#msps.is_CANAL
		if not uo_global.ib_msps_canalbuttons then return
	case c#msps.is_FWODRIFT
		if not uo_global.ib_msps_fwodriftbuttons then return
	case c#msps.is_LOAD
		if not uo_global.ib_msps_loadbuttons then return
	case c#msps.is_DISCHARGE
		if not uo_global.ib_msps_dischargebuttons then return
end choose

/* If user=Operations - read and write access*/
if uo_global.ii_user_profile = 2 then
	if ai_msgstatus <> 0 then cb_sendemail.enabled = true
	choose case ai_msgstatus
		case c#msps.ii_NEW, c#msps.ii_ACTIVE
			cb_update.enabled = true
			cb_approve.enabled = true
			if is_messagetype = c#msps.is_NOON then p_refreshalerts.visible = uo_global.ib_rul_generatealerts
			if ai_msgstatus = c#msps.ii_NEW then cb_reject.enabled = true
			cb_cancel.enabled = true
			if ai_msgstatus = c#msps.ii_ACTIVE then cb_active.enabled = true
			dw_master.Modify("DataWindow.ReadOnly=No")
			tab_1.tabpage_cargo.dw_cargo.modify("DataWindow.ReadOnly=No")
			tab_1.tabpage_cargo.dw_cargo.modify("b_chartereragent.enabled=yes")
		case c#msps.ii_ARCHIVE, c#msps.ii_REJECTED  //Archive, Rejected
			//It should not be possible to Activate an archived heating message.
			if uo_global.ii_access_level = c#usergroup.#SUPERUSER and is_messagetype <> c#msps.is_HEATING then
				cb_active.enabled = true
			end if
		case c#msps.ii_APPROVED //Approved
			cb_active.enabled = true
		case c#msps.ii_FAILED   //Failed
			cb_active.enabled = true
	end choose
end if



end subroutine

public function integer wf_match_liftedbunkers (string as_msgtype);/********************************************************************
   wf_match_liftedbunkers
   <DESC> Matching lifted bunkers</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		as_msgtype: message type
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	05-03-2012 CR20         LHC010        		 First Version
   </HISTORY>
********************************************************************/
decimal{4} ldc_lifthfo, ldc_liftdo, ldc_liftgo, ldc_liftlshfo
decimal{4} ldc_computehfo, ldc_computedo, ldc_computego, ldc_computelshfo
s_poc	lstr_poc

if dw_master.rowcount() <= 0 then return c#return.Failure

if not(as_msgtype = c#msps.is_CANAL or as_msgtype = c#msps.is_FWODRIFT or as_msgtype = c#msps.is_LOAD or as_msgtype = c#msps.is_DISCHARGE) then return c#return.NoAction
//get the vessel,voyage,port code,pcn
wf_get_primarykey(lstr_poc, dw_master, 1)

//get the oil information from port of call 
SELECT isnull(LIFT_HFO, 0), 	isnull(LIFT_DO, 0), 	isnull(LIFT_GO,0),	isnull(LIFT_LSHFO,0)
 INTO: ldc_lifthfo,	:ldc_liftdo, 	:ldc_liftgo,	:ldc_liftlshfo
  FROM POC
 WHERE VESSEL_NR = :lstr_poc.vessel_nr 
   AND VOYAGE_NR = :lstr_poc.voyage_nr
	AND PORT_CODE = :lstr_poc.port_code
	AND PCN		  = :lstr_poc.pcn;
	
//get the oil information from message	
ldc_computehfo   	= dw_master.getitemnumber( 1, "compute_hfo")
ldc_computedo 		= dw_master.getitemnumber( 1, "compute_do")
ldc_computego 		= dw_master.getitemnumber( 1, "compute_go")
ldc_computelshfo 	= dw_master.getitemnumber( 1, "compute_lshfo")

//Check the oil information from port of all and message are matched
if ldc_lifthfo <> ldc_computehfo or ldc_liftdo <> ldc_computedo &
	or ldc_liftgo <> ldc_computego or ldc_liftlshfo <> ldc_computelshfo then
	dw_master.modify("b_lifteddetails.visible=1 match_t.text='Not Match' match_t.width =224 match_t.color = " + string(c#color.Red))
	return c#return.Failure
else
	dw_master.modify("b_lifteddetails.visible=0 match_t.text='Match' match_t.width =133 match_t.color = " + string(c#color.Black))
	return c#return.Success
end if


end function

public subroutine wf_load_arrivaldate (string as_msgtype);/********************************************************************
   wf_load_arrivaldate
   <DESC>	load date into arrival dropdown list</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	24-02-2012 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
datetime ldt_tempnor[], ldt_arrivaldate[], ldt_nortendered, ldt_anchored, ldt_drifting, ldt_endofseapassage
string ls_label[]
mt_n_datefunctions lnv_datefunction

if dw_master.rowcount() <= 0 then return

if not (as_msgtype = c#msps.is_ARRIVAL or as_msgtype = c#msps.is_CANAL or as_msgtype = c#msps.is_FWODRIFT) then return

//set null to NOR tendered
setnull(ldt_nortendered)

choose case as_msgtype
	case c#msps.is_ARRIVAL //Arrival message
		ldt_tempnor[1] = dw_master.getitemdatetime( 1, "end_of_sea_passage_nor_lt") 
		ldt_tempnor[2] = dw_master.getitemdatetime( 1, "anchored_nor_lt")
		ldt_tempnor[3] = dw_master.getitemdatetime( 1, "anchored_aweigh_nor_lt")
		ldt_tempnor[4] = dw_master.getitemdatetime( 1, "drifting_nor_lt")
		ldt_tempnor[5] = dw_master.getitemdatetime( 1, "stopped_drifting_nor_lt")
		ldt_tempnor[6] = dw_master.getitemdatetime( 1, "pilot_on_board_nor_lt")
		ldt_tempnor[7] = dw_master.getitemdatetime( 1, "etb_all_fast_nor_lt")
		ldt_tempnor[8] = dw_master.getitemdatetime( 1, "all_fast_nor_lt")
		ldt_anchored = dw_master.getitemdatetime( 1, "anchored_date_lt")
		ldt_drifting = dw_master.getitemdatetime( 1, "drifting_date_lt")
		ldt_endofseapassage = dw_master.getitemdatetime( 1, "end_of_sea_passage_date_lt") 
	case c#msps.is_CANAL, c#msps.is_FWODRIFT //Canal and fwo-drift message
		ldt_anchored = dw_master.getitemdatetime( 1, "anchored_date_lt")
		ldt_drifting = dw_master.getitemdatetime( 1, "drifting_date_lt")
		ldt_endofseapassage = dw_master.getitemdatetime( 1, "end_of_sea_passage_date_lt") 		
end choose
		
//Get the earliest NOR tendered date.
ldt_nortendered = lnv_datefunction.of_getearliestdate( ldt_tempnor)
wf_add_array(ldt_nortendered, "NOR Tendered", ldt_arrivaldate, ls_label)

//Get the earliest anchored date.
wf_add_array(ldt_anchored, "Anchored", ldt_arrivaldate, ls_label)

//Get the earliest drifting date.
wf_add_array(ldt_drifting, "Drifting", ldt_arrivaldate, ls_label)

//Get the earliest end of sea passage date.
wf_add_array(ldt_endofseapassage, "End of Sea Passage", ldt_arrivaldate, ls_label)

//insert date into the arrival dropdown
wf_insertdata_dddw("arrival_date", ls_label, ldt_arrivaldate)


end subroutine

public subroutine wf_load_berthingdate (string as_msgtype);/********************************************************************
   wf_load_berthingdate
   <DESC>load date into berthing dropdown list	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_msgtype: message type
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-02-2012 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
datetime ldt_allfast, ldt_etb, ldt_berthingdate[]
string ls_label[]

if dw_master.rowcount() <= 0 then return

if as_msgtype <> c#msps.is_ARRIVAL then return

ldt_allfast = dw_master.getitemdatetime( 1, "all_fast_date_lt")
ldt_etb 		= dw_master.getitemdatetime( 1, "etb_all_fast_date_lt")

//Get the latest all fast date.
wf_add_array(ldt_allfast, "All Fast", ldt_berthingdate, ls_label)

//Get the latest all fast date.
wf_add_array(ldt_etb, "ETB", ldt_berthingdate, ls_label)

//insert date into the berthing dropdown
wf_insertdata_dddw("berth_date", ls_label, ldt_berthingdate)

end subroutine

public function integer wf_load_chartereragent (long al_row, boolean ab_setitemstatus);/********************************************************************
   wf_load_chartereragent
   <DESC> load charterer/agent into dropdown list</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		al_row:
		ab_setitemstatus :false =retrieve, true =itemchange event
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-03-2012 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
long ll_null
string ls_findexp, ls_chartagent
integer li_rowcount, li_cargorowcount, li_row, li_findrow
s_poc	lstr_poc

mt_u_datawindow ldw_cargo

if al_row <= 0 or isnull(al_row) then return c#return.Failure

ldw_cargo = tab_1.tabpage_cargo.dw_cargo

//get the vessel,voyage,port code,pcn
wf_get_primarykey(lstr_poc,dw_master,al_row)

if ab_setitemstatus then 
	li_rowcount = idwc_chartagent.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.port_code, lstr_poc.pcn)
else
	li_rowcount = idwc_chartagent.rowcount()
end if

li_cargorowcount = ldw_cargo.rowcount( )

setnull(ll_null)
for li_row = 1 to li_cargorowcount
	if li_rowcount > 0 then
		ls_chartagent = ldw_cargo.getitemstring(li_row, "charterer_agent")
		ls_findexp = "chartagent ='" + ls_chartagent + "'"
		li_findrow = idwc_chartagent.find(ls_findexp, 1, li_rowcount)
	end if
	
	if li_rowcount <= 0 or li_findrow <= 0 then
		ldw_cargo.setitem(li_row, "charterer_agent", "")
		ldw_cargo.setitem(li_row, "cal_cerp_id", ll_null)
		ldw_cargo.setitem(li_row, "chart_nr", ll_null)
		ldw_cargo.setitem(li_row, "agent_nr", ll_null)
		if not ab_setitemstatus then ldw_cargo.setitemstatus(li_row, 0, primary!, notmodified!)
	end if
next

return c#return.Success
end function

public function integer wf_check_datamodified ();/********************************************************************
   wf_check_datamodified
   <DESC>check whether the message data is modified </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	19-12-2011 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
dw_master.accepttext( )
tab_1.tabpage_cargo.dw_cargo.accepttext( )

if dw_master.modifiedcount( ) + tab_1.tabpage_cargo.dw_cargo.modifiedcount( ) > 0 then
	if MessageBox("Data Not Saved", "MSPS messages data modified, but not saved.~n~r~n~r" +&
						"Would you like to update data before switching?", Question!, YesNo!, 1) = 1 then
		cb_update.triggerEvent(Clicked!)
	else
		tab_1.tabpage_cargo.dw_cargo.reset( )
	end if
end if
return 1
end function

public subroutine wf_load_departuredate (string as_msgtype);/********************************************************************
   wf_load_departuredate
   <DESC>load date into departure dropdown list</DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	29-02-2012 cr20         LHC010        First Version
   </HISTORY>
********************************************************************/
datetime ldt_anchoraweight, 		 ldt_departurebeth,   			ldt_droppedlastpilot
datetime ldt_stopdrifting,	 		 ldt_commencedpassage,			ldt_shiptoship
datetime ldt_tempanchoraweight[], ldt_tempdeparturebeth[], 		ldt_tempdroppedlastpilot[]
datetime ldt_tempstopdrifting[],	 ldt_tempcommencedpassage[],	ldt_tempshiptoship[]
datetime ldt_departuredate[]
string 	ls_label[]
integer  i, li_rowcount
mt_u_datawindow ldw_terminal
mt_n_datefunctions lnv_datefunctions

if dw_master.rowcount() <= 0 then return

choose case as_msgtype
	case c#msps.is_Canal //Canal messages
		ldt_tempanchoraweight[1] 	 = dw_master.getitemdatetime( 1, "anchored_aweigh_date_lt")
		ldt_tempdroppedlastpilot[1] = dw_master.getitemdatetime( 1, "dropped_last_pilot_date_lt")
		ldt_tempcommencedpassage[1] = dw_master.getitemdatetime( 1, "passage_commenced_date_lt")
	case c#msps.is_FWODRIFT //FWO-Drift messages
		ldt_tempanchoraweight[1] 	 = dw_master.getitemdatetime( 1, "anchored_aweigh_date_lt")
		ldt_tempstopdrifting[1]  	 = dw_master.getitemdatetime( 1, "stopped_drifting_date_lt")
		ldt_tempcommencedpassage[1] = dw_master.getitemdatetime( 1, "passage_commenced_date_lt")
	case c#msps.is_LOAD, c#msps.is_DISCHARGE //loading or discharging messages
		ldw_terminal = tab_1.tabpage_terminal.dw_terminal
		li_rowcount = ldw_terminal.rowcount( )
		for i = 1 to li_rowcount
			ldt_tempanchoraweight[i] 	= ldw_terminal.getitemdatetime( i, "anchored_aweigh_date_lt")
			ldt_tempdeparturebeth[i]   = ldw_terminal.getitemdatetime( i, "departed_berth_date_lt")
			ldt_tempdroppedlastpilot[i]= ldw_terminal.getitemdatetime( i, "dropped_last_pilot_date_lt")
			ldt_tempshiptoship[i] 	 	= ldw_terminal.getitemdatetime( i, "ship_to_ship_date_lt") 
		next
end choose
		
//Get the lasted anchor aweight date.
ldt_anchoraweight = lnv_datefunctions.of_getlatestdate( ldt_tempanchoraweight )
wf_add_array(ldt_anchoraweight, "Anchor Aweight", ldt_departuredate, ls_label)

//Get the lasted departure beth date.
ldt_departurebeth = lnv_datefunctions.of_getlatestdate( ldt_tempdeparturebeth )
wf_add_array(ldt_departurebeth, "Departure Beth", ldt_departuredate, ls_label)

//Get the lasted dropped last pilot date.
ldt_droppedlastpilot = lnv_datefunctions.of_getlatestdate( ldt_tempdroppedlastpilot )
wf_add_array(ldt_droppedlastpilot, "Dropped Last Pilot", ldt_departuredate, ls_label)

//Get the lasted stopdrifting date.
ldt_stopdrifting = lnv_datefunctions.of_getlatestdate( ldt_tempstopdrifting )
wf_add_array(ldt_stopdrifting, "Stop Drifting", ldt_departuredate, ls_label)

//Get the lasted commenced passage date.
ldt_commencedpassage = lnv_datefunctions.of_getlatestdate( ldt_tempcommencedpassage )
wf_add_array(ldt_commencedpassage, "Passage Commenced", ldt_departuredate, ls_label)

//Get the lasted ship to ship date.
ldt_shiptoship = lnv_datefunctions.of_getlatestdate( ldt_tempshiptoship )
wf_add_array(ldt_shiptoship, "Ship to Ship", ldt_departuredate, ls_label)

//insert date into the departure dropdown
wf_insertdata_dddw("departure_date", ls_label, ldt_departuredate)


end subroutine

public subroutine wf_load_vessel (long al_row, boolean ab_setitemstatus);/********************************************************************
   wf_load_vessel
   <DESC>	dynamic refresh the dropdown list for vessels</DESC>
   <RETURN>	(none):
            </RETURN>
   <ACCESS> public</ACCESS>
   <ARGS>
		al_row		     : selected row
		ab_setitemstatus : false =retrieve, true =itemchange event
   </ARGS>
   <USAGE>	ue_retrieve, dw_master.itemchanged	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	13-12-2011 CR20         LHC010        First Version
   </HISTORY>
********************************************************************/
integer 	li_row, li_rowcount, li_pcn, li_originalpcn, li_findrow
string 	ls_expression
s_poc	lstr_poc
datawindowchild	ldwc_pcn

if dw_master.rowcount() <= 0 or al_row <= 0 or isnull(al_row) then return

wf_get_primarykey(lstr_poc, dw_master, 1)

li_originalpcn = dw_master.getitemnumber( 1, "pcn")

dw_master.getchild( "pcn", ldwc_pcn)
ldwc_pcn.settransobject(sqlca)
li_rowcount = ldwc_pcn.retrieve(lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.port_code)

if li_rowcount > 0 and not isnull(li_originalpcn) then
	li_findrow = ldwc_pcn.find( "pcn =" + string(li_originalpcn), 1, li_rowcount)
end if

if li_findrow <= 0 then 
	setnull(li_pcn)
else
	li_pcn = li_originalpcn
end if

dw_master.setitem( 1, "pcn", li_pcn)
if not ab_setitemstatus then dw_master.setitemstatus( 1, 0, primary!, notmodified!)

li_row = idwc_vessel.rowcount()

//if more than one vessel with the same IMO number, a warning message should be displayed
if li_row > 1 then
	ls_expression = "vessel_validation_t.text = 'Tramos has " + string(li_row) + &
		" vessels with the IMO number " + string(il_vesselimo) + ".'" + &
		" vessel_name.visible = 0 vessel_nr.visible=1"
else //The user does not need to select a vessel from the dddw
	ls_expression = "vessel_validation_t.text ='' vessel_name.visible=1 vessel_nr.visible=0"	
end if

//modified validation messages
dw_master.modify(ls_expression)


end subroutine

private subroutine _retrievemessage (long al_row);/********************************************************************
   _retrievemessage
   <DESC> when click the list or up/down arrow triggered </DESC>
   <RETURN>	(None):
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> private </ACCESS>
   <ARGS>
		al_row
   </ARGS>
   <USAGE>ue_retrieve and dw_list.rowfocuschanged</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	11-06-2013 CR3238       LHC010             First Version
   	02/08/2013 CR3238       LHG008             For Heating message, change "Approve" button to "Archive"
   	27/12/2013 CR3240       LHG008             For Noon message, display alerts
   	18/02/2014 CR3240UAT    LHG008             Use picture object for "Refresh Alerts" button
   </HISTORY>
********************************************************************/

long		ll_rowcount, ll_vesselnr
string	ls_dataobject, ls_expression, ls_shiptoshipvesselname, ls_voyagenr
constant string ls_SPACE = "    "
constant long ll_ADJUSTPOSITION_HORIZONTAL = 37
constant long ll_ADJUSTPOSITION_VERTICALLY = 32
integer	li_msgstatus, li_load_disch
n_service_manager 	lnv_servicemanager
n_dw_style_service	lnv_styleservice
mt_u_datawindow	ldw_cargo, ldw_terminal, ldw_additional, ldw_tugs
datawindowchild	ldwc_child

/* Call function to verify if all changes are saved, before changed row */
wf_check_datamodified()

ldw_cargo = tab_1.tabpage_cargo.dw_cargo
ldw_terminal = tab_1.tabpage_terminal.dw_terminal
ldw_additional = tab_1.tabpage_additional.dw_additional
ldw_tugs = tab_1.tabpage_tugs.dw_tugs

this.setredraw(false)
if al_row > 0 then
	dw_list.setrow(al_row)
	dw_list.selectrow(0, false)
	dw_list.selectrow(al_row, true)
	
	il_clickrow = al_row
	
	//set master dataobject
	is_messagetype = lower(dw_list.getitemstring(al_row, "msg_type"))
	if is_messagetype = c#msps.is_FWODRIFT then 
		ls_dataobject = "d_sq_ff_fwodrift_detail"
	elseif is_messagetype = c#msps.is_DISCHARGE then
		ls_dataobject = "d_sq_ff_load_disch_detail"
		li_load_disch = c#msps.ii_DISCHARGE	
	elseif is_messagetype = c#msps.is_LOAD then 
		ls_dataobject = "d_sq_ff_load_disch_detail"
		li_load_disch = c#msps.ii_LOAD
	else
		ls_dataobject = "d_sq_ff_" + is_messagetype + "_detail"
	end if
	
	dw_master.dataobject = ls_dataobject
	dw_master.settransobject(sqlca)
	
	p_refreshalerts.visible = false
	dw_alerts.visible = false
	dw_detail.visible = false
	tab_1.visible = false
	st_shiptoship.visible = false
	
	li_msgstatus = dw_list.getitemnumber(al_row, "msg_status")
	//register mandatory column	
	lnv_servicemanager.of_loadservice(lnv_styleservice , "n_dw_style_service")	
	if li_msgstatus = c#msps.ii_NEW or li_msgstatus = c#msps.ii_ACTIVE then // if status = NEW,
		lnv_styleservice.of_registercolumn("vessel_nr", true)
		lnv_styleservice.of_registercolumn("vessel_name", true)
		lnv_styleservice.of_registercolumn("voyage_no", true)
		lnv_styleservice.of_registercolumn("port_code", true)
		lnv_styleservice.of_registercolumn("pcn", true)
		lnv_styleservice.of_registercolumn("port_name", true)
		lnv_styleservice.of_registercolumn("arrival_date", true)
		lnv_styleservice.of_registercolumn("departure_date", true)
		if is_messagetype = c#msps.is_NOON then lnv_styleservice.of_registercolumn("arrival_date_1", true)
	end if	
	lnv_styleservice.of_dwformformater(dw_master)
	il_reportid = dw_list.getitemnumber(al_row, "report_id")
	il_revisionno = dw_list.getitemnumber(al_row, "revision_no")
	il_vesselimo = dw_list.getitemnumber(al_row, "vessel_imo")
	string ls_reportno, ls_reporttype
	
	ls_reporttype = dw_list.getitemstring(al_row, "report_type")
	ls_reportno = string(dw_list.getitemnumber(al_row, "report_no"))
	if isnull(ls_reporttype) then ls_reporttype = ""
	if isnull(ls_reportno) then ls_reportno = ""

	this.title = "Vessel Messages List (Vessel IMO: " + string(il_vesselimo) + ls_SPACE + &
				 "Report No: " +  ls_reportno + ls_SPACE + &
				 "Revision No: " +  string(il_revisionno) + ls_SPACE + &
				 "Report Type: " +  ls_reporttype + ")"
	
	dw_master.getchild("vessel_nr", idwc_vessel)
	idwc_vessel.settransobject(sqlca)
	idwc_vessel.retrieve(il_vesselimo)
		
	//retrieve messages detail
	ll_rowcount = dw_master.retrieve(il_reportid, il_revisionno, il_vesselimo, li_msgstatus, li_load_disch)
	cb_approve.text = "&Approve"
	
	//Adjust position and size of dw_detail when the message type is Noon or Heating.
	if is_messagetype = c#msps.is_NOON or is_messagetype = c#msps.is_HEATING then
		dw_detail.x = dw_master.x + long(dw_master.describe("gb_detail.x")) + ll_ADJUSTPOSITION_HORIZONTAL
		dw_detail.y = dw_master.y + long(dw_master.describe("gb_detail.y")) + ll_ADJUSTPOSITION_VERTICALLY * 2
		dw_detail.width = long(dw_master.describe("gb_detail.width")) - ll_ADJUSTPOSITION_HORIZONTAL * 2
		dw_detail.height = long(dw_master.describe("gb_detail.height")) - ll_ADJUSTPOSITION_VERTICALLY * 3
	end if
	
	choose case is_messagetype
		case c#msps.is_NOON
			dw_alerts.x = dw_master.x + long(dw_master.describe("gb_alerts.x")) + ll_ADJUSTPOSITION_HORIZONTAL
			dw_alerts.y = dw_master.y + long(dw_master.describe("gb_alerts.y")) + ll_ADJUSTPOSITION_VERTICALLY * 3
			dw_alerts.width = long(dw_master.describe("gb_alerts.width")) - ll_ADJUSTPOSITION_HORIZONTAL * 2
			dw_alerts.height = long(dw_master.describe("gb_alerts.height")) - ll_ADJUSTPOSITION_VERTICALLY * 4
			
			p_refreshalerts.x = dw_master.x + long(dw_master.describe("p_legendtooltip.x")) - p_refreshalerts.width - ll_ADJUSTPOSITION_HORIZONTAL / 2
			p_refreshalerts.y = dw_master.y + long(dw_master.describe("gb_alerts.y"))
			
			p_refreshalerts.visible = true
			dw_alerts.visible = true
			lnv_styleservice.of_dwformformater(dw_alerts)
			dw_alerts.settransobject(sqlca)
			dw_alerts.retrieve(il_vesselimo, il_reportid, il_revisionno, is_messagetype)

			dw_detail.dataobject = "d_sq_gr_noon_tanks" 
			dw_detail.visible = true
			lnv_styleservice.of_dwlistformater(dw_detail)
			dw_detail.settransobject(sqlca)
			dw_detail.retrieve(il_reportid, il_revisionno, il_vesselimo, li_load_disch)
		case c#msps.is_HEATING
			dw_detail.dataobject = "d_sq_gr_heating_consumption_total"		
			ls_voyagenr = dw_master.getitemstring( ll_rowcount, "voyage_no")
			dw_detail.settransobject(sqlca)
			lnv_styleservice.of_dwlistformater(dw_detail)
			dw_detail.retrieve(il_vesselimo, ls_voyagenr)
			dw_detail.visible = true
			cb_approve.text = "&Archive"
		case c#msps.is_LOAD, c#msps.is_DISCHARGE
			tab_1.visible = true
			
			//show ship to ship vessel name
			if ll_rowcount > 0 then ls_shiptoshipvesselname = dw_master.getitemstring(1, "ship_to_ship_vessel")
			if isnull(ls_shiptoshipvesselname) then ls_shiptoshipvesselname = ""
			st_shiptoship.text = "Ship to Ship Vessel Name " + ls_shiptoshipvesselname
			st_shiptoship.visible = true
			
			ldw_cargo.dataobject = "d_sq_ff_cargo_detail"
			ldw_cargo.settransobject(sqlca)
					
			lnv_styleservice.of_dwformformater(ldw_tugs)
			//register mandatory column if message status is 1:new 6:active 
			if li_msgstatus = c#msps.ii_NEW or li_msgstatus = c#msps.ii_ACTIVE then
				lnv_styleservice.of_registercolumn("charterer_agent", true)
				if is_messagetype = c#msps.is_DISCHARGE then lnv_styleservice.of_registercolumn("load_cargo_detail_id", true)
			end if

			lnv_styleservice.of_dwformformater(ldw_cargo)
			lnv_styleservice.of_dwformformater(ldw_terminal)
			lnv_styleservice.of_dwformformater(ldw_additional)
			
			ldw_additional.retrieve(il_reportid, il_revisionno, il_vesselimo, li_msgstatus, li_load_disch)
			ldw_tugs.retrieve(il_reportid, il_revisionno, il_vesselimo, li_msgstatus, li_load_disch)
			
			ldw_cargo.getchild("charterer_agent", idwc_chartagent)
			idwc_chartagent.settransobject(sqlca)
			
			//load charterer/agent data into dropdown list,  but the data is not allowed to update 
			wf_load_chartereragent(1, true)
			idwc_chartagent.modify("DataWindow.Header.Color=" + string(c#color.MT_LISTHEADER_BG))
			idwc_chartagent.modify("charterer_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT)) 
			idwc_chartagent.modify("agent_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT)) 
			idwc_chartagent.modify("cpdesc_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT))
			
			ll_rowcount = ldw_cargo.retrieve(il_reportid, il_revisionno, il_vesselimo, li_load_disch)
			
			//clear charterer/agent data if dropdown not exists charterer/agent
			wf_load_chartereragent(1, false)			
			
			//for discharge message with new/active status, show and set data for loaded cargo field
			if is_messagetype = c#msps.is_DISCHARGE and (li_msgstatus = c#msps.ii_NEW or li_msgstatus = c#msps.ii_ACTIVE) then
				ldw_cargo.getchild("load_cargo_detail_id", ldwc_child)
				ldwc_child.settransobject(sqlca)
				
				//load loaded cargo data into dropdown list
				if ll_rowcount > 0 then
					ll_vesselnr = dw_master.getitemnumber(1, "vessel_nr" )
					ls_voyagenr = dw_master.getitemstring(1, "voyage_no")
					
					ldwc_child.retrieve(ll_vesselnr, ls_voyagenr)
					
					//filter and set loaded cargo. This data is not allowed to save.
					wf_set_loadedcargo(true)
				end if
				
				ldwc_child.modify("DataWindow.Header.Color=" + string(c#color.MT_LISTHEADER_BG))
				ldwc_child.modify("port_code_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT)) 
				ldwc_child.modify("pcn_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT)) 
				ldwc_child.modify("layout_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT))
				ldwc_child.modify("ships_fig_t.color=" + string(C#COLOR.MT_LISTHEADER_TEXT))
				ldw_cargo.modify("load_cargo_detail_id_t.visible = '1' load_cargo_detail_id.visible = '1'")
			end if
			
			if ll_rowcount > 1 then
				ldw_cargo.modify("b_left.enabled = 'no' b_right.enabled = 'yes'")
			else
				ldw_cargo.modify("b_left.enabled = 'no' b_right.enabled = 'no'")
			end if
			
			ll_rowcount = ldw_terminal.retrieve(il_reportid, il_revisionno, il_vesselimo, li_load_disch)
			if ll_rowcount > 0 then
				dw_master.setitem(1, "number_of_nor", ldw_terminal.getitemnumber(1, "number_of_nor"))
				dw_master.setitemstatus(1, 0, Primary!, notmodified!)
				ldw_terminal.setsort("")
				ldw_terminal.sort()
			end if
			if ll_rowcount > 1 then
				ldw_terminal.modify("b_left.enabled = 'no' b_right.enabled = 'yes'")
			else
				ldw_terminal.modify("b_left.enabled = 'no' b_right.enabled = 'no'")
			end if
	end choose
		
	//load date data into arrival dropdown list
	wf_load_arrivaldate(is_messagetype)
	
	//load date data into berthing dropdown list
	wf_load_berthingdate(is_messagetype)
		
	//load date data into departure dropdown list
	wf_load_departuredate(is_messagetype)

	//load vessel data with same IMO into vessel dropdown list
	wf_load_vessel(al_row, false)	
	
	//lifted bunkers match
	wf_match_liftedbunkers(is_messagetype)
	
	//if message status is not new or active, set as background color
	if not(li_msgstatus = c#msps.ii_NEW or li_msgstatus = c#msps.ii_ACTIVE) then
		ls_expression += " vessel_nr.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
		ls_expression += " voyage_no.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
		ls_expression += " vessel_name.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
		ls_expression += " port_code.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
		ls_expression += " port_name.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)		
		ls_expression += " pcn.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
		choose case is_messagetype
			case c#msps.is_ARRIVAL
				ls_expression += " arrival_date.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
				ls_expression += " berth_date.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)				
			case c#msps.is_CANAL, c#msps.is_FWODRIFT
				ls_expression += " arrival_date.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)				
				ls_expression += " b_lifteddetails.enabled='No' departure_date.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
			case c#msps.is_LOAD, c#msps.is_DISCHARGE
				ls_expression += " b_lifteddetails.enabled='No' departure_date.Background.Color =" + string(c#color.MT_FORMDETAIL_BG)
				ldw_cargo.modify("b_chartereragent.enabled='No' charterer_agent.Background.Color =" + string(c#color.MT_FORMDETAIL_BG))
		end choose
	end if
	ls_expression += " approve_t.text = ~"Approved~tif(isNull(approve_by) or trim(approve_by) = '', 'Approved', lookupdisplay(msg_status))~""
	dw_master.modify(ls_expression)
end if

//setting permissions interface
if al_row > 0 then _set_permissions(li_msgstatus)
this.post setredraw(true)


end subroutine

public function integer wf_set_loadedcargo (boolean ab_setallrows);/********************************************************************
   wf_set_loadedcargo
   <DESC>	When approving discharge message, this function will filter and set loaded cargo id. 
				But this data will not be saved. It is only used to display and approve </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, ok
            <LI> c#return.Failure, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
				ab_setallrows: true, set data for all rows
									false, set data only for current row
   </ARGS>
   <USAGE>	when retrieve msps message or change Charterer/Agent.
				Called from: _retrievemessage()
								wf_validate()
								tab_1.tabpage_cargo.dw_cargo.itemchanged()
								tab_1.tabpage_cargo.dw_cargo.buttonclicked()
	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		23/08/2013	CR3238	LHG008	First Version
   </HISTORY>
********************************************************************/

long ll_cargo_id, ll_chart_nr, ll_cerp_id
string ls_grade_name, ls_layout
integer li_cargorowcount, li_row, li_rowstart, li_rowend
datawindowchild ldwc_child
mt_u_datawindow ldw_cargo

ldw_cargo = tab_1.tabpage_cargo.dw_cargo

ldw_cargo.getchild("load_cargo_detail_id", ldwc_child)

if ldwc_child.rowcount() + ldwc_child.filteredcount() <= 0 then return c#return.Failure

if ab_setallrows then //For all the rows
	li_rowstart = ldw_cargo.rowcount()
	li_rowend = 1
else //Only for current row	
	li_rowstart = ldw_cargo.getrow()
	li_rowend = li_rowstart
end if

for li_row = li_rowstart to li_rowend step -1
	ls_grade_name = ldw_cargo.getitemstring(li_row, "cargo_grade_name")
	ls_layout = ldw_cargo.getitemstring(li_row, "tanks")
	ll_chart_nr = ldw_cargo.getitemnumber(li_row, "chart_nr")
	ll_cerp_id = ldw_cargo.getitemnumber(li_row, "cal_cerp_id")
	
	if isnull(ls_grade_name) or trim(ls_grade_name) = '' or isnull(ls_layout) or trim(ls_layout) = '' &
			or isnull(ll_chart_nr) or isnull(ll_cerp_id) then
		ldwc_child.setfilter("1 = 2")
	else
		ldwc_child.setfilter("grade_name ='" + ls_grade_name + "' and layout ='" + ls_layout + "' and chart_nr =" + string(ll_chart_nr) + " and cal_cerp_id =" + string(ll_cerp_id))
	end if
	ldwc_child.filter()
	
	/*If there is only one row, then set data to the column. 
	  Otherwise, user need to select loaded cargo from dropdown list manuanlly*/
	if ldwc_child.rowcount() = 1 then
		ll_cargo_id = ldwc_child.getitemnumber(1, "cargo_detail_id")
	else
		setnull(ll_cargo_id)
	end if
	
	//Set loaded cargo id and this id will not be saved. 
	ldw_cargo.setitem(li_row, "load_cargo_detail_id", ll_cargo_id)
	ldw_cargo.setitemstatus(li_row, "load_cargo_detail_id", primary!, notmodified!)
next

return c#return.Success
end function

public subroutine wf_filter ();/********************************************************************
   wf_filter
   <DESC>	Filter the data of dw_list datawindow	</DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		13/01/2014	CR3240	LHG008	First Version
   </HISTORY>
********************************************************************/

long ll_rowcount, ll_findrow
long ll_reportid, ll_revisionno, ll_vesselimo
string ls_findexp, ls_msgtype, ls_filter

this.setredraw(false)

ll_rowcount = dw_list.rowcount()

if il_clickrow > 0 and ll_rowcount >= il_clickrow then
	ll_reportid = dw_list.getitemnumber( il_clickrow, "report_id")
	ll_revisionno = dw_list.getitemnumber( il_clickrow, "revision_no")
	ll_vesselimo = dw_list.getitemnumber( il_clickrow, "vessel_imo")
	ls_msgtype = dw_list.getitemstring( il_clickrow, "msg_type")
	//build find expression
	ls_findexp = "report_id = " + string(ll_reportid) + " and revision_no = " + string(ll_revisionno) + &
					 " and vessel_imo = " + string(ll_vesselimo) + " and msg_type ='" + ls_msgtype + "'"
end if

ls_filter = dw_severity.inv_filter_multirow.of_getfilter()
if len(ls_filter) > 0 then
	//If <noon...> is selecting then add "not defined" severity id in the filter expression
	if pos(ls_filter, 'isnull(severity_id)') > 0 then
		ls_filter += " or severity_id = " + string(ii_severity_notdefined)
	end if
else
	ls_filter = "1=2"
end if

dw_list.setfilter(ls_filter)
dw_list.filter()

ll_rowcount = dw_list.rowcount()
dw_list.groupcalc()

//Positioning the selected row
if ll_rowcount > 0 then
	if len(ls_findexp) > 0 then
		ll_findrow = dw_list.find(ls_findexp, 1, ll_rowcount)
	end if
	
	if ll_findrow <= 0 then
		ll_findrow = 1
		_retrievemessage(ll_findrow)
	end if
	
	//Highlight the row if the expected row is current row
	if ll_findrow = dw_list.getrow() then
		dw_list.selectrow(0, false)
		dw_list.selectrow(ll_findrow, true)
	else
		dw_list.setrow(ll_findrow)
		dw_list.scrolltorow(ll_findrow)
	end if
else //ll_rowcount <= 0
	dw_master.reset()
	tab_1.visible = false
	dw_detail.visible = false
	st_shiptoship.visible = false
	dw_alerts.visible = false
	p_refreshalerts.visible = false
	
	if il_clickrow > 0 then il_clickrow = 0
	
	_set_permissions(0)
end if

this.post setredraw(true)

end subroutine

on w_msps_messages_list.create
int iCurrent
call super::create
this.gb_severity=create gb_severity
this.dw_list=create dw_list
this.cb_refresh=create cb_refresh
this.cb_update=create cb_update
this.cb_approve=create cb_approve
this.cb_reject=create cb_reject
this.cb_active=create cb_active
this.cb_cancel=create cb_cancel
this.st_background=create st_background
this.cbx_showstatus=create cbx_showstatus
this.st_lastdays=create st_lastdays
this.em_lastday=create em_lastday
this.dw_popup=create dw_popup
this.st_shiptoship=create st_shiptoship
this.dw_detail=create dw_detail
this.tab_1=create tab_1
this.dw_master=create dw_master
this.cb_sendemail=create cb_sendemail
this.dw_alerts=create dw_alerts
this.dw_severity=create dw_severity
this.cbx_selectall=create cbx_selectall
this.p_refreshalerts=create p_refreshalerts
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_severity
this.Control[iCurrent+2]=this.dw_list
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.cb_approve
this.Control[iCurrent+6]=this.cb_reject
this.Control[iCurrent+7]=this.cb_active
this.Control[iCurrent+8]=this.cb_cancel
this.Control[iCurrent+9]=this.st_background
this.Control[iCurrent+10]=this.cbx_showstatus
this.Control[iCurrent+11]=this.st_lastdays
this.Control[iCurrent+12]=this.em_lastday
this.Control[iCurrent+13]=this.dw_popup
this.Control[iCurrent+14]=this.st_shiptoship
this.Control[iCurrent+15]=this.dw_detail
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.dw_master
this.Control[iCurrent+18]=this.cb_sendemail
this.Control[iCurrent+19]=this.dw_alerts
this.Control[iCurrent+20]=this.dw_severity
this.Control[iCurrent+21]=this.cbx_selectall
this.Control[iCurrent+22]=this.p_refreshalerts
end on

on w_msps_messages_list.destroy
call super::destroy
destroy(this.gb_severity)
destroy(this.dw_list)
destroy(this.cb_refresh)
destroy(this.cb_update)
destroy(this.cb_approve)
destroy(this.cb_reject)
destroy(this.cb_active)
destroy(this.cb_cancel)
destroy(this.st_background)
destroy(this.cbx_showstatus)
destroy(this.st_lastdays)
destroy(this.em_lastday)
destroy(this.dw_popup)
destroy(this.st_shiptoship)
destroy(this.dw_detail)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.cb_sendemail)
destroy(this.dw_alerts)
destroy(this.dw_severity)
destroy(this.cbx_selectall)
destroy(this.p_refreshalerts)
end on

event open;call super::open;//set trans
dw_list.settransobject(sqlca)

uo_vesselselect.of_registerwindow( w_msps_messages_list )
uo_vesselselect.of_setcurrentvessel( uo_global.getvessel_nr( ) )
uo_vesselselect.dw_vessel.setColumn( "vessel_nr" )
uo_vesselselect.dw_vessel.setfocus()
ii_vessel_nr = uo_global.getvessel_nr( )

uo_vesselselect.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.gb_1.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.st_criteria.backcolor = c#color.MT_LISTHEADER_BG
uo_vesselselect.st_criteria.textcolor = c#color.MT_LISTHEADER_TEXT
uo_vesselselect.dw_vessel.object.datawindow.color = string(c#color.MT_LISTHEADER_BG)

em_lastday.text = string(uo_global.ii_msps_days)

dw_severity.selectrow(0, cbx_selectall.checked)

if uo_global.getvessel_nr( ) = 0 then
	this.postevent("ue_vesselselection")
end if
end event

event ue_retrieve;call super::ue_retrieve;/********************************************************************
   ue_retrieve
   <DESC>Refresh data</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		wparam
		lparam
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-03-2012 cr20         LHC010        First Version
   	26/08/2013 CR3286       LHG008        Add MSPS setup
   </HISTORY>
********************************************************************/
long ll_rowcount, ll_findrow
long ll_reportid, ll_revisionno, ll_vesselimo
integer  li_upperbound, li_status[] //1 new 2 archive 3 rejected 4 approved 5 failed 6 active
string ls_findexp, ls_msgtype, ls_messagetype[]

this.setredraw(false)

st_shiptoship.visible = false

//Filter the message list by status 1:new and 6:active,
if cbx_showstatus.checked then
	li_status[1] = c#msps.ii_NEW
	li_status[2] = c#msps.ii_ACTIVE
else
	//Filter the message list by all status
	for li_upperbound = 1 to 6
		li_status[li_upperbound] = li_upperbound
	next
end if

ll_rowcount = dw_list.rowcount()

if il_clickrow > 0 and ll_rowcount >= il_clickrow then
	ll_reportid = dw_list.getitemnumber( il_clickrow, "report_id")
	ll_revisionno = dw_list.getitemnumber( il_clickrow, "revision_no")
	ll_vesselimo = dw_list.getitemnumber( il_clickrow, "vessel_imo")
	ls_msgtype = dw_list.getitemstring( il_clickrow, "msg_type")
	//build find expression
	ls_findexp = "report_id = " + string(ll_reportid) + " and revision_no = " + string(ll_revisionno) + &
					 " and vessel_imo = " + string(ll_vesselimo) + " and msg_type ='" + ls_msgtype + "'"
end if

if upperbound(ii_vesselnr) <= 0 then
	ii_vesselnr[1] = -1
end if

//MSPS list Noon reports
if uo_global.ib_msps_shownoon then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_NOON
end if

//MSPS list Heating reports
if uo_global.ib_msps_showheating then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_HEATING
end if

//MSPS list Arrival reports
if uo_global.ib_msps_showarrival then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_ARRIVAL
end if

//MSPS list Canal reports
if uo_global.ib_msps_showcanal then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_CANAL
end if

//MSPS list FWO/Drift reports
if uo_global.ib_msps_showfwodrift then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_FWODRIFT
end if

//MSPS list Load report
if uo_global.ib_msps_showload then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_LOAD
end if

//MSPS list Discharge reports
if uo_global.ib_msps_showdischarge then
	ls_messagetype[upperbound(ls_messagetype) + 1] = c#msps.is_DISCHARGE
end if

ll_rowcount = dw_list.retrieve(ii_vesselnr, li_status, ii_lastday, ls_messagetype)
dw_list.groupcalc( )

if ll_rowcount <= 0 and il_clickrow > 0 then il_clickrow = 0

//Positioning the selected row
if len(ls_findexp) > 0 and ll_rowcount > 0 then
	ll_findrow = dw_list.find( ls_findexp, 1, ll_rowcount)
	if ll_findrow <= 0 then ll_findrow = 1
end if

if ll_rowcount > 0 then
	dw_list.setrow(ll_findrow)
	dw_list.scrolltorow(ll_findrow)
	//If the find row and current row is same needed to trigger
	_retrievemessage(ll_findrow)
else
	dw_master.reset( )
	tab_1.visible = false
	dw_detail.visible = false
	dw_alerts.visible = false
	p_refreshalerts.visible = false
end if

if dw_list.rowcount() <= 0 then
	_set_permissions(0)
end if

this.post setredraw(true)

end event

event ue_vesselselection;call super::ue_vesselselection;string	ls_msgstring, ls_vesselsnr, ls_vessel_refnr
integer	li_upperbound, li_return, li_null[]
long		ll_vesselnr
mt_n_stringfunctions lnv_string

/* Call function to verify if all changes are saved, before changed row */
wf_check_datamodified()

ii_vesselnr = li_null

//get vessel_nr from the vessel dropdown list 
ls_vesselsnr = uo_vesselselect.of_get_vessels_nr( )

lnv_string.of_parsetoarray( ls_vesselsnr, ",", ii_vesselnr)

ii_lastday = integer(em_lastday.text)

ls_vessel_refnr = uo_vesselselect.dw_vessel.getitemstring(1, "vessel_ref_nr")
//if selection vessel 
if len(ls_vessel_refnr) > 0 then
	li_upperbound = 1
else
	li_upperbound = upperbound(ii_vesselnr)
end if

if li_upperbound > 0 then
	if li_upperbound > 30 then
		ls_msgstring = "More than 30 vessels are selected."
	elseif (li_upperbound > 10 and li_upperbound <= 30) and ii_lastday > 30 then
		ls_msgstring = "More than 10 vessels are selected for showing the messages in the last 30 days."
	else
		li_return = 1
	end if
	
	if li_return <= 0 then
		li_return = messagebox("Warning",ls_msgstring + &
			" The report generation would take longer than normal. Do you really want to proceed?", Information!, YesNo!, 2)
	end if
	
	if li_return = 1 then
		postevent("ue_retrieve")
	else
		st_shiptoship.visible = false
		tab_1.visible = false
		dw_list.reset( )
		dw_master.reset( )
		dw_detail.reset( )
		dw_alerts.reset( )
		dw_detail.visible = false
		dw_alerts.visible = false
		cb_update.enabled = false
		cb_approve.enabled = false
		cb_reject.enabled = false
		cb_active.enabled = false
		cb_cancel.enabled = false
		cb_sendemail.enabled = false
		p_refreshalerts.visible = false
	end if
else
	postevent("ue_retrieve") 
end if


end event

event closequery;call super::closequery;/* Call function to verify if all changes are saved, before closing the window */
wf_check_datamodified( )


end event

event key;call super::key;graphicobject	lgo_focus

//If the current input places the cursor in the vessel, ignoring the default button functions
if key = keyenter! then
	lgo_focus = getfocus()
	if lgo_focus.classname() = 'dw_vessel' then
		ib_ignoredefaultbutton = true
		send(handle(lgo_focus), 256, 9, 0)
	end if
end if

end event

event ue_update;call super::ue_update;/********************************************************************
   ue_update
   <DESC>Update message</DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		wparam
		lparam
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	08-03-2012 cr20         LHC010             First Version
   	28/12/2013 CR3240       LHG008             Generate alerts
   </HISTORY>
********************************************************************/
if dw_master.modifiedcount( ) + tab_1.tabpage_cargo.dw_cargo.modifiedcount( ) > 0 then
	//set the lasted update date and user
	dw_master.setitem(1, "last_update_date", now() )
	dw_master.setitem(1, "update_by",uo_global.is_userid)
	
	//update
	if dw_master.update() = 1 then
		if  tab_1.tabpage_cargo.dw_cargo.update() = 1 then
			commit;
			event ue_refreshalerts()
			this.event ue_retrievedetail(dw_list.getselectedrow(0))
		else
			rollback;
			messagebox("Update error","Update failed.")
		end if
	else
		rollback;
		messagebox("Update error","Update failed.")
	end if
end if
end event

type st_hidemenubar from w_tramos_container_vessel`st_hidemenubar within w_msps_messages_list
end type

type uo_vesselselect from w_tramos_container_vessel`uo_vesselselect within w_msps_messages_list
integer x = 23
integer taborder = 10
end type

event uo_vesselselect::ue_itemchanged;call super::ue_itemchanged;if isnull(vessel_nr) or vessel_nr = 0 then
	parent.triggerevent("ue_vesselselection")
end if
end event

type gb_severity from groupbox within w_msps_messages_list
integer x = 1262
integer width = 603
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 16777215
long backcolor = 5851683
string text = "Severity"
end type

type dw_list from u_datagrid within w_msps_messages_list
integer x = 37
integer y = 264
integer width = 1317
integer height = 2208
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_sq_gr_msg_list"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_columntitlesort = true
end type

event clicked;call super::clicked;if row > 0 then il_clickrow =  row

end event

event rowfocuschanged;call super::rowfocuschanged;_retrievemessage(currentrow)
	

end event

type cb_refresh from mt_u_commandbutton within w_msps_messages_list
integer x = 4503
integer y = 32
integer taborder = 40
boolean bringtotop = true
string text = "&Refresh"
end type

event clicked;call super::clicked;/* If the vessel number entered is wrong then exit event */
if uo_vesselselect.dw_vessel.accepttext() = -1 then
	uo_vesselselect.dw_vessel.post setfocus()
	return
end if

if ib_ignoredefaultbutton then
	ib_ignoredefaultbutton = false
	return
end if

parent.postevent("ue_vesselselection")

end event

type cb_update from mt_u_commandbutton within w_msps_messages_list
integer x = 2766
integer y = 2380
integer taborder = 100
boolean bringtotop = true
boolean enabled = false
string text = "&Update"
end type

event clicked;call super::clicked;parent.triggerevent("ue_update")
end event

type cb_approve from mt_u_commandbutton within w_msps_messages_list
integer x = 3113
integer y = 2380
integer taborder = 110
boolean bringtotop = true
boolean enabled = false
string text = "&Approve"
end type

event clicked;call super::clicked;parent.event ue_approve( )
end event

type cb_reject from mt_u_commandbutton within w_msps_messages_list
integer x = 3461
integer y = 2380
integer taborder = 120
boolean bringtotop = true
boolean enabled = false
string text = "Re&ject"
end type

event clicked;call super::clicked;parent.event ue_reject( )
end event

type cb_active from mt_u_commandbutton within w_msps_messages_list
integer x = 3808
integer y = 2380
integer taborder = 130
boolean bringtotop = true
boolean enabled = false
string text = "Ac&tivate"
end type

event clicked;call super::clicked;parent.event ue_activate( )
end event

type cb_cancel from mt_u_commandbutton within w_msps_messages_list
integer x = 4503
integer y = 2380
integer taborder = 140
boolean bringtotop = true
boolean enabled = false
string text = "&Cancel"
end type

event clicked;call super::clicked;integer	li_msgstatus, li_loadordisch
long  ll_row

ll_row = dw_list.getselectedrow( 0 )
parent.setredraw( false )
if ll_row > 0 then
	li_msgstatus = dw_list.getitemnumber( ll_row, "msg_status")
	
	if is_messagetype = c#msps.is_LOAD then li_loadordisch = c#msps.ii_LOAD
	if is_messagetype = c#msps.is_DISCHARGE then li_loadordisch = c#msps.ii_DISCHARGE
	
	idwc_vessel.retrieve( il_vesselimo )
	
	//retrieve messages detail
	dw_master.retrieve(il_reportid, il_revisionno, il_vesselimo, li_msgstatus, li_loadordisch)
	
	if is_messagetype = c#msps.is_LOAD or is_messagetype = c#msps.is_DISCHARGE then
		tab_1.tabpage_cargo.dw_cargo.retrieve(il_reportid, il_revisionno, il_vesselimo, li_loadordisch)		

		//load dropdown data the charterer/agent
		wf_load_chartereragent(1, false)
		
		wf_set_loadedcargo(true)
	end if
	
	//load dropdown data the vessel
	wf_load_vessel(ll_row, false)	
end if
parent.setredraw( true )
end event

type st_background from u_topbar_background within w_msps_messages_list
integer width = 6002
integer height = 232
end type

type cbx_showstatus from mt_u_checkbox within w_msps_messages_list
integer x = 1902
integer y = 32
integer width = 814
integer height = 64
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 553648127
string text = "Show only new/active messages"
boolean checked = true
end type

event clicked;call super::clicked;parent.postevent("ue_retrieve") 
end event

type st_lastdays from mt_u_statictext within w_msps_messages_list
integer x = 1902
integer y = 112
integer width = 933
boolean bringtotop = true
long textcolor = 16777215
long backcolor = 553648127
string text = "Show messages in the last               days"
end type

type em_lastday from mt_u_editmask within w_msps_messages_list
integer x = 2505
integer y = 112
integer width = 146
integer height = 56
integer taborder = 30
boolean bringtotop = true
string text = ""
boolean border = false
alignment alignment = center!
borderstyle borderstyle = stylebox!
string mask = "###"
end type

event modified;call super::modified;if integer(this.text) <> ii_lastday then
	parent.postevent("ue_vesselselection")
	ii_lastday = integer(this.text)
end if
	
end event

type dw_popup from u_popupdw within w_msps_messages_list
integer x = 3328
integer y = 352
integer width = 1385
integer height = 788
integer taborder = 70
string dataobject = "d_ex_ff_commentpopup"
boolean resizable = false
borderstyle borderstyle = styleraised!
boolean ib_footermessage = true
boolean ib_headermessage = true
end type

event constructor;call super::constructor;//this.settransobject( sqlca )
this.of_registerdw(dw_master)


end event

type st_shiptoship from statictext within w_msps_messages_list
integer x = 2976
integer y = 1280
integer width = 1851
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type dw_detail from u_datagrid within w_msps_messages_list
boolean visible = false
integer x = 1426
integer y = 1248
integer width = 2377
integer height = 560
integer taborder = 90
string dataobject = "d_sq_gr_heating_consumption_total"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
end type

event constructor;call super::constructor;this.settransobject( sqlca )
end event

type tab_1 from tab within w_msps_messages_list
boolean visible = false
integer x = 1390
integer y = 1264
integer width = 3456
integer height = 1100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 80269524
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_terminal tabpage_terminal
tabpage_cargo tabpage_cargo
tabpage_tugs tabpage_tugs
tabpage_additional tabpage_additional
end type

on tab_1.create
this.tabpage_terminal=create tabpage_terminal
this.tabpage_cargo=create tabpage_cargo
this.tabpage_tugs=create tabpage_tugs
this.tabpage_additional=create tabpage_additional
this.Control[]={this.tabpage_terminal,&
this.tabpage_cargo,&
this.tabpage_tugs,&
this.tabpage_additional}
end on

on tab_1.destroy
destroy(this.tabpage_terminal)
destroy(this.tabpage_cargo)
destroy(this.tabpage_tugs)
destroy(this.tabpage_additional)
end on

type tabpage_terminal from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 984
long backcolor = 80269524
string text = "SOF"
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
dw_terminal dw_terminal
end type

on tabpage_terminal.create
this.dw_terminal=create dw_terminal
this.Control[]={this.dw_terminal}
end on

on tabpage_terminal.destroy
destroy(this.dw_terminal)
end on

type dw_terminal from mt_u_datawindow within tabpage_terminal
integer y = 4
integer width = 3419
integer height = 980
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sq_ff_terminal_detail"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

event buttonclicked;call super::buttonclicked;integer	li_row_count
string	ls_dwoname

ls_dwoname = dwo.name

if ls_dwoname = 'b_left' or ls_dwoname = 'b_right' then
	this.modify( "b_right.enabled = 'yes'")
	this.modify( "b_left.enabled = 'yes'")
end if

if ls_dwoname = 'b_left' then
	if row > 1 then
		this.scrolltorow( row - 1 )
		this.setrow( row - 1 )
	end if

	if row - 1 = 1 then this.modify( "b_left.enabled = 'no'")
end if

if ls_dwoname = 'b_right' then
	li_row_count = this.rowcount()
	if row < li_row_count then
		this.scrolltorow( row + 1)
		this.setrow( row + 1)
	end if
	
	if li_row_count - row = 1 then this.modify( "b_right.enabled = 'no'")
end if
end event

event other;call super::other;if message.number = 522 then return 1
end event

type tabpage_cargo from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 984
long backcolor = 80269524
string text = "Cargo Detail"
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
dw_cargo dw_cargo
end type

on tabpage_cargo.create
this.dw_cargo=create dw_cargo
this.Control[]={this.dw_cargo}
end on

on tabpage_cargo.destroy
destroy(this.dw_cargo)
end on

type dw_cargo from mt_u_datawindow within tabpage_cargo
integer y = 4
integer width = 3401
integer height = 1072
integer taborder = 30
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event buttonclicked;call super::buttonclicked;integer	li_row_count, li_loadordischarge, li_findrow, li_rowcount
string	ls_dwoname, ls_chartagent
constant string ls_NOTCREATED = "Charterer/Agent cannot be created in Cargo."
s_cargo	lstr_cargo
s_poc	lstr_poc

n_validate_poc lnv_validatepoc

ls_dwoname = dwo.name

this.setredraw(false)
//scroll row 
if ls_dwoname = 'b_left' or ls_dwoname = 'b_right' then
	this.modify("b_right.enabled = 'yes'")
	this.modify("b_left.enabled = 'yes'")
	post wf_set_loadedcargo(false)
end if

if ls_dwoname = 'b_left' then
	if row > 1 then
		this.scrolltorow(row - 1 )
		this.setrow(row - 1 )
	end if

	if row - 1 = 1 then this.modify("b_left.enabled = 'no'")
end if

if ls_dwoname = 'b_right' then
	li_row_count = this.rowcount()
	if row < li_row_count then
		this.scrolltorow(row + 1)
		this.setrow(row + 1)
	end if
	
	if li_row_count - row = 1 then this.modify("b_right.enabled = 'no'")
end if

//Add charterer/agent into tramos
if ls_dwoname = "b_chartereragent" then
	//get the vessel,voyage,port code,pcn
	wf_get_primarykey(lstr_poc, dw_master, 1)
	
	if isnull(lstr_poc.pcn) then
		Messagebox(is_VALIDATIONTITLE, "Please select a PCN for the port.")
		return
	end if
	
	li_loadordischarge = dw_master.getitemnumber(1, "load_or_discharge")
		
	//check port existence in proceeding
	if lnv_validatepoc.of_exists_proceeding(lstr_poc) <= 0 then
		Messagebox(is_VALIDATIONTITLE, "The port does not exist in Proceeding, " + ls_NOTCREATED)
	else
		//check if voyage is allocated
		if lnv_validatepoc.of_is_allocated(lstr_poc) > 0 then
			//check if the port is actual in port of call
			if lnv_validatepoc.of_exists_actpoc(lstr_poc) > 0 then
				lstr_cargo.calc_id = lstr_poc.cal_calc_id
				lstr_cargo.vessel_nr = lstr_poc.vessel_nr
				lstr_cargo.voyage_nr = lstr_poc.voyage_nr
				lstr_cargo.port_code = lstr_poc.port_code
				lstr_cargo.pcn = lstr_poc.pcn
		
				if li_loadordischarge = c#msps.ii_LOAD then 
					lstr_cargo.cargo_in_out = true
				else
					lstr_cargo.cargo_in_out = false
				end if
				
				//open charterer/agent and add agent
//				openwithparm(w_cargo_input,lstr_cargo)
//				
//				lstr_cargo = message.powerobjectparm
				
				if lstr_cargo.agent_nr > 0 then 
					li_rowcount = idwc_chartagent.retrieve( lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.port_code, lstr_poc.pcn )
					if li_rowcount > 0 then
						li_findrow = idwc_chartagent.find("chart_nr = "  + string(lstr_cargo.chart_nr) + " and agent_nr =" + string(lstr_cargo.agent_nr), 1, li_rowcount)
						if li_findrow > 0 then
							ls_chartagent = idwc_chartagent.getitemstring( li_findrow, "chartagent")
							this.setitem( row, "charterer_agent", ls_chartagent)
							this.event itemchanged(row, this.object.charterer_agent, ls_chartagent)
						end if
					end if
				end if
			else
				Messagebox(is_VALIDATIONTITLE, "The port is not registered as an actual port of call in TRAMOS. " + ls_NOTCREATED)
			end if
		else
			Messagebox(is_VALIDATIONTITLE, "The voyage is not allocated to a calculation. " + ls_NOTCREATED)				
		end if
	end if
end if

this.post setredraw(true)
end event

event itemchanged;call super::itemchanged;integer li_agentnr, li_chartnr
long ll_calcerpid
string ls_data, ls_temp[]
mt_n_stringfunctions lnv_string

choose case dwo.name
	case "charterer_agent"
		ls_data = data
		lnv_string.of_parsetoarray( ls_data, "@", ls_temp)
		
		if upperbound(ls_temp) = 3 then
			ll_calcerpid = long(ls_temp[1])
			li_chartnr = integer(ls_temp[2])
			li_agentnr = integer(ls_temp[3])
			this.setitem( row, "cal_cerp_id", ll_calcerpid)
			this.setitem( row, "chart_nr", li_chartnr)
			this.setitem( row, "agent_nr", li_agentnr)
		end if
		wf_set_loadedcargo(false)
	case "load_cargo_detail_id"
		this.post setitemstatus(row, "load_cargo_detail_id", primary!, notmodified!)
	
end choose
end event

event constructor;call super::constructor;//this.settransobject( sqlca )
end event

event other;call super::other;if message.number = 522 then return 1
end event

type tabpage_tugs from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 984
long backcolor = 80269524
string text = "Tugs Detail"
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
dw_tugs dw_tugs
end type

on tabpage_tugs.create
this.dw_tugs=create dw_tugs
this.Control[]={this.dw_tugs}
end on

on tabpage_tugs.destroy
destroy(this.dw_tugs)
end on

type dw_tugs from mt_u_datawindow within tabpage_tugs
integer y = 4
integer width = 3419
integer height = 1072
integer taborder = 30
string dataobject = "d_sq_ff_tugs_detail"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

type tabpage_additional from userobject within tab_1
integer x = 18
integer y = 100
integer width = 3419
integer height = 984
long backcolor = 80269524
string text = "Additional Info"
long tabtextcolor = 33554432
long tabbackcolor = 80269524
long picturemaskcolor = 536870912
dw_additional dw_additional
end type

on tabpage_additional.create
this.dw_additional=create dw_additional
this.Control[]={this.dw_additional}
end on

on tabpage_additional.destroy
destroy(this.dw_additional)
end on

type dw_additional from mt_u_datawindow within tabpage_additional
integer y = 4
integer width = 3419
integer height = 1104
integer taborder = 50
string dataobject = "d_sq_ff_additional_detail"
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_setdefaultbackgroundcolor = true
end type

event constructor;call super::constructor;this.settransobject(sqlca)
end event

type dw_master from mt_u_datawindow within w_msps_messages_list
event ue_rbuttondown pbm_dwnrbuttondown
event ue_mousemove pbm_dwnmousemove
integer x = 1390
integer y = 248
integer width = 3456
integer height = 2112
integer taborder = 60
string dataobject = "d_sq_ff_heating_detail"
boolean border = false
boolean righttoleft = true
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
end type

event ue_rbuttondown;string ls_header, ls_comment, ls_objectname
integer	li_status, li_originalstatus 

ls_objectname = dwo.name
if ls_objectname = 'p_reason' or ls_objectname = "p_notes" or  ls_objectname = "p_legendtooltip"  then
	if ls_objectname = "p_legendtooltip" then //Alerts
		dw_popup.dataobject = "d_sq_ff_legendtooltip"
		dw_popup.settransobject(sqlca)
		dw_popup.retrieve()
		
		dw_popup.width = 677
		dw_popup.height = 432
	else //REJECTION REASON	
		dw_popup.dataobject = "d_ex_ff_commentpopup"
		dw_popup.insertrow(0)
		
		if ls_objectname = "p_reason" then
			li_status = this.getitemnumber( 1, "msg_status")
			li_originalstatus = this.getitemnumber( 1, "original_status")
			
			if li_originalstatus > 0 then li_status = li_originalstatus
			choose case li_status
				case c#msps.ii_REJECTED
					ls_header = 'Rejection Reason'
				case c#msps.ii_FAILED
					ls_header = 'Failed Reason'
				case c#msps.ii_APPROVED
					ls_header = 'Notes'
			end choose
			ls_comment = dw_master.getitemstring( 1, "rejection_reason")
		end if
		
		if ls_objectname = "p_notes" then 
			ls_header = "Notes"
			ls_comment = dw_master.getitemstring( 1, "notes")
		end if
		
		dw_popup.object.t_detail.text = ls_header
		dw_popup.setitem(1,"comment", ls_comment)
		
		dw_popup.width = 1385
		dw_popup.height = 787
	end if
	
	if (this.x + pointerx() + dw_popup.width) > parent.width then
		dw_popup.x = parent.width - dw_popup.width - 75
	else
		dw_popup.x = parent.pointerx()
	end if
	
	if (pointery() + dw_popup.height > this.y + this.height) then
		dw_popup.y =  this.y + this.height - dw_popup.height
	else
		dw_popup.y = parent.pointery()
	end if

	dw_popup.visible = true
	dw_popup.setfocus( )
end if
end event

event ue_mousemove;/********************************************************************
   event ue_mousemove( /*integer xpos*/, /*integer ypos*/, /*long row*/, /*dwobject dwo */)
   <DESC>   
		monitors the mouse pointer in regards to the popup
	</DESC>
   <RETURN> 
		Long
	</RETURN>
   <ACCESS> 
		Public
	</ACCESS>
   <ARGS>   
		standard powerbuilder arguments for this event
	</ARGS>
   <USAGE>  
	</USAGE>
********************************************************************/
if dw_popup.visible and dw_popup.ib_autoclose then
	if (xpos < dw_popup.x - this.x) or (ypos < dw_popup.y - this.y) then
		this.setfocus()
		dw_popup.visible = false
	end if
end if

end event

event itemchanged;call super::itemchanged;string ls_msgtype
integer li_null
long	ll_selectrow

if dwo.name = "vessel_nr" or dwo.name = 'pcn' then
	if is_messagetype <> c#msps.is_HEATING and dwo.name = 'vessel_nr' then
		post wf_load_vessel(row, true)		
//		setnull(li_null)
//		this.setitem(1, "PCN", li_null)
	end if
	if is_messagetype = c#msps.is_LOAD or is_messagetype = c#msps.is_DISCHARGE then
		this.accepttext( )
		//load charterer/agent data into dropdown list, but the data need to be updated 
		post wf_load_chartereragent(row, true)
	end if
end if
end event

event buttonclicked;call super::buttonclicked;s_poc	lstr_poc
u_jump_bp	lnv_jump

if dwo.name = "b_lifteddetails" then
	wf_get_primarykey(lstr_poc, dw_master, row)
	//open lifted bunkers
	lnv_jump = create u_jump_bp
	lnv_jump.of_open_bp( lstr_poc.vessel_nr, lstr_poc.voyage_nr, lstr_poc.port_code, lstr_poc.pcn )
	destroy lnv_jump
end if
end event

type cb_sendemail from mt_u_commandbutton within w_msps_messages_list
integer x = 4155
integer y = 2380
integer taborder = 140
boolean bringtotop = true
boolean enabled = false
string text = "&Send Email"
end type

event clicked;call super::clicked;/********************************************************************
   clicked
   <DESC>	Open the default mail client (outlook) to send mail	</DESC>
   <RETURN>	long </RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		26/08/2013	CR3238	LHG008	First Version
   </HISTORY>
********************************************************************/

string	ls_return, ls_subject, ls_emailto

mt_n_stringfunctions	lnv_string
n_sendtomailclient	lnv_mailclient

if dw_master.getrow( ) <= 0 then return

if wf_get_emailaddress(is_emailaddress) = c#return.Failure then return

ls_subject = "Tramos alert"

//If there are more than one email address, emailto will be seperated with "; "
lnv_string.of_arraytostring(is_emailaddress, '; ', ls_emailto)

return lnv_mailclient.of_sendmailbyoutlook(ls_subject, ls_emailto)
end event

type dw_alerts from u_datagrid within w_msps_messages_list
boolean visible = false
integer x = 1445
integer y = 1760
integer width = 1371
integer height = 432
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_sq_ff_alerts"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
boolean ib_multicolumnsort = false
boolean ib_setdefaultbackgroundcolor = true
end type

type dw_severity from u_datagrid within w_msps_messages_list
integer x = 1298
integer y = 64
integer width = 530
integer height = 112
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_sq_gr_ruleseverity_mspslist"
boolean vscrollbar = true
boolean border = false
boolean ib_multicolumnsort = false
boolean ib_multirow = true
end type

event clicked;call super::clicked;wf_filter()
end event

event constructor;call super::constructor;integer li_row, li_severity_id
s_filter_multirow lstr_module

this.retrieve( )

li_row = this.insertrow(0)

setnull(li_severity_id)
this.setitem(li_row, 'severity_id', li_severity_id)
this.setitem(li_row, 'severity_name', '<None...>')
this.setitem(li_row, 'severity_color', c#color.MT_LISTDETAIL_BG)

//Get severity id for "not defined" severity
SELECT SEVERITY_ID
  INTO :ii_severity_notdefined
  FROM RUL_SEVERITIES
 WHERE SEVERITY_NOTDEFINED = 1;

lstr_module.self_dw = dw_severity
lstr_module.self_column_name = 'severity_id'       // The column name is getitem column name.
lstr_module.report_column_name = 'severity_id'
lstr_module.include_null = true

this.inv_filter_multirow.of_register(lstr_module)
end event

type cbx_selectall from mt_u_checkbox within w_msps_messages_list
integer x = 1518
integer width = 329
integer height = 56
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
long textcolor = 16777215
long backcolor = 5851683
string text = "Deselect all"
boolean checked = true
end type

event clicked;call super::clicked;if this.checked then	
	this.text = "Deselect all"
else
	this.text = "Select all"
end if

//Change the filter selection status
dw_severity.selectrow(0, this.checked)

//Generate filter constation
dw_severity.inv_filter_multirow.of_dofilter()

wf_filter()
end event

event constructor;call super::constructor;this.backcolor = st_background.backcolor
end event

type p_refreshalerts from picture within w_msps_messages_list
boolean visible = false
integer x = 2651
integer y = 1680
integer width = 73
integer height = 64
boolean bringtotop = true
string pointer = "HyperLink!"
string picturename = "Update5!"
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string powertiptext = "Refresh Alerts"
end type

event clicked;if parent.event ue_refreshalerts() = c#return.Success then
	dw_alerts.retrieve(il_vesselimo, il_reportid, il_revisionno, is_messagetype)
end if
end event

