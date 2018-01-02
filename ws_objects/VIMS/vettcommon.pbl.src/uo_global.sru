$PBExportHeader$uo_global.sru
forward
global type uo_global from nonvisualobject
end type
end forward

global type uo_global from nonvisualobject autoinstantiate
end type

type prototypes

//FUNCTION boolean CryptStringToBinary (string pszString, ulong cchString, ulong dwFlags, Ref blob pbBinary, Ref ulong pcbBinary, Ref ulong pdwSkip, Ref ulong pdwFlags ) LIBRARY "crypt32.dll" ALIAS FOR "CryptStringToBinaryA;Ansi"
Function boolean CryptStringToBinary (string pszString, ulong cchString, ulong dwFlags, Ref blob pbBinary, Ref ulong pcbBinary, Ref ulong pdwSkip, Ref ulong pdwFlags ) Library "crypt32.dll" Alias For "CryptStringToBinaryW"
end prototypes

type variables

PrivateWrite String is_EmailFooter = "[ This email was generated automatically by the Vetting and Inspection Management System (VIMS). Please do not reply to this email. If you believe this email was sent in error, please contact maropsmt@maersk.com for further assistance. ]"

Constant String is_ProductionDB = "PROD_TRAMOS"
Constant String is_ProductionServer = "ASEPROD"


end variables

forward prototypes
public subroutine of_updatelastedit (long al_inspid)
public subroutine of_addinsphist (long al_inspid, integer ai_htype, string as_info)
public function integer of_notifymanagement (long al_inspid, integer ai_mode, ref string as_users)
public subroutine of_launchwiki (string as_wikipage)
public subroutine of_checksiredue ()
public function string of_sendsirenotice (string as_vslname, datetime adt_lastsire, datetime adt_nextdue, string as_resp, boolean ab_tomanager)
public subroutine of_sendmail2tech (long al_inspid)
public subroutine of_addsysmsg (integer ai_msgtype, string as_id, string as_ver, string as_info, long al_inspid, string as_time)
public subroutine of_processcommpackage (string as_package)
public function string of_sendmail2vessel (string as_vesselemail, string as_subject, string as_attpath)
public function integer of_sendrejectionnotice (long al_rejectid)
private function string _getvesselinitialcomments (long ai_itemid)
public function string of_sendvbismail (long al_inspid, integer ai_amount)
public function string of_checkautomailemail (string as_vslemail)
public subroutine of_sendinspreminder (string as_vslname, string as_vslemail, string as_superdept, string as_superemail, string as_imname, date adt_inspdate, integer ai_interval, integer ai_togo, long al_inspid)
public function blob of_decodebase64 (string as_base64)
public subroutine of_logemail (string as_recipients, string as_subject, string as_body)
public function integer of_sendredflagportsemail ()
public function integer of_checkmireobs (long al_inspid)
end prototypes

public subroutine of_updatelastedit (long al_inspid);// This function updates the last edited date of an inspection
// And gives an error if failed

DateTime ldt_Now

ldt_Now = DateTime(Today(), Now())

Update VETT_INSP Set LASTEDIT = :ldt_Now Where INSP_ID = :al_InspID;

If SQLCA.SQLCode <> 0 then
	Rollback;
	Return
End If

Commit;
end subroutine

public subroutine of_addinsphist (long al_inspid, integer ai_htype, string as_info);//Function to add item to Insp history

DateTime ldt_Now   

ldt_Now = DateTime(Today(), Now())

If Len(as_Info) > 1000 then as_Info = Left(as_Info, 997) + "..."

Insert Into VETT_INSPHIST (INSP_ID,	HDATE, HTYPE, USER_ID, DEPT_ID, INFO) Values (:al_InspID, :ldt_Now, :ai_HType, :g_Obj.UserID , :g_Obj.DeptID, :as_Info);

If SQLCA.SQLCode = 0 then
	Commit;
Else
	Rollback;
End If
end subroutine

public function integer of_notifymanagement (long al_inspid, integer ai_mode, ref string as_users);// This function sends an email all users belonging to 'management' departments 
// and those users selected for management notification
// and to vetting super, tech super and vessel itself

// The email is sent only if the inspection meets the criteria for management notification
// or if force parameter is applied (Mode=2)

// Parameters:
// al_InspID - The inspection ID
// ai_Mode - 0 = Normal: Check criteria and send email if criteria match
//           1 = Check only: Check return 1 if insp meets criteria. No email sent.
//           2 = Force/Manual: Send email irrespective of criteria
// as_Users - String to return list of users that email was sent to

// Return value
// 0  = No emails sent
// x  = Number of recipients sent to
// -1 = Error

Integer li_IMID, li_Obs, li_HighRisk, li_Mgmt, li_IObs, li_IHighRisk
String ls_Model, ls_Users, ls_Port, ls_Emails, ls_Sub
Boolean lb_Match
Datastore lds_Users
mt_n_outgoingmail lnvo_Mail

// First get inspection model settings
Select VETT_INSPMODEL.IM_ID, NOTIFY_MGMT, OBSLIMIT, HIGHRISKLIMIT, VETT_INSPMODEL.NAME
Into :li_IMID, :li_Mgmt, :li_Obs, :li_HighRisk, :ls_Model
from VETT_INSPMODEL Inner Join VETT_INSP On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID 
Where INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then
	Rollback;
	Return -1
End If
Commit;

// If no need to report to managment and not forcing, then exit
If li_Mgmt = 0 and ai_Mode < 2 then Return 0

// Get number of 'No' observations
Select Count(ITEM_ID) Into :li_IObs
from VETT_ITEM Where ANS=1 and INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then 
	Rollback;
	Return -1
End If
Commit;

// Get number of inspection high risk items
Select Count(ITEM_ID) Into :li_IHighRisk
from VETT_ITEM Where ANS=1 and RISK=2 and INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then 
	Rollback;
	Return -1
End If
Commit;

// If count in acceptable limit, then exit
If li_IObs <= li_Obs and li_IHighRisk <= li_HighRisk Then
    If ai_Mode < 2 then Return 0	  // If not forced, then return
	 lb_Match = False  // Set criteria not matched
Else
	lb_Match = True
End If

// If checking only then return positive
If ai_Mode = 1 then Return 1

/* ----- Prepare email to management ----- */

DateTime ldt_Date
String ls_Vessel, ls_Comp, ls_Body, ls_Err, ls_Super, ls_Tech, ls_VslEmail

// Get list of management users to email to...
lds_Users = Create Datastore
lds_Users.Dataobject = "d_sq_tb_mgmt"
lds_Users.SetTransObject(SQLCA)
lds_Users.Retrieve()

// Get vessel name/number, Email, Insp Date and company name, Port
Select TOP 1 VESSEL_REF_NR + ' - ' + VESSEL_NAME, VESSEL_EMAIL,INSPDATE, VETT_COMP.NAME, PORT_N, VETT_RESP, TECH_SUPER
Into :ls_Vessel, :ls_VslEmail, :ldt_Date, :ls_Comp, :ls_Port, :ls_Super, :ls_Tech
From VESSELS Inner Join VETT_INSP On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO
Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_INSP.COMP_ID
Inner Join PORTS On VETT_INSP.PORT = PORTS.PORT_CODE
Where (VESSELS.VESSEL_ACTIVE = 1) and (VETT_OFFICEID is not Null) and (VETT_TYPE is not null) and (INSP_ID = :al_InspID);
If SQLCA.SQLCode<>0 then 
	Rollback;
	Return -1
End If
Commit;

// Subject 
ls_Sub = "VIMS - Management Review Notification (" + ls_Vessel + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Good-day,<br/><br/>This is a"
If ai_Mode = 0 then ls_Body += "n automatic" Else ls_Body += " manual"
ls_Body += " notification email from VIMS for the following inspection:<br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;' cellpadding='3'><tr><td>Vessel Number/Name:</td><td>" + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Inspection Type:</td><td>" + ls_Model + "</td></tr>"
ls_Body += "<tr><td>Inspection Date:</td><td>" + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Inspection Port:</td><td>" + ls_Port + "</td></tr>"
ls_Body += "<tr><td>Conducted By:</td><td>" + ls_Comp + "</td></tr>"
ls_Body += "<tr><td>Total Observations:</td><td>"
If lb_Match=True And li_IObs > li_Obs Then ls_Body += "<span style='color:red'>" + String(li_IObs) + "</span></td></tr>" Else ls_Body += String(li_IObs) + "</td></tr>"
ls_Body += "<tr><td>High Risk Observations:</td><td>" 
If lb_Match=True And li_IHighRisk > li_HighRisk Then ls_Body += "<span style='color:red'>" + String(li_IHighRisk) + "</span></td></tr>" Else ls_Body += String(li_IHighRisk) + "</td></tr>"
ls_Body += "</table><br/><br/>"

If lb_Match then 
	ls_Body += "This notification is being sent because the inspection did not meet allowed limits for observations and/or high risk observations. You may add your comments to each of the observations.<br/><br/><u>"
	ls_Body += ls_Model + " Notification Criteria<br/></u><br/>"
   ls_body += "<table style='font-family:Verdana;font-size:10pt;' cellpadding='3'><tr><td>Total Observations Limit:</td><td>" + String(li_Obs) + "</td></tr>"
	ls_Body += "<tr><td>Total High Risk Limit:</td><td>" + String(li_HighRisk) + "</td></tr></table>"
Else
	ls_Body += "You may open VIMS add your comments to each of the observations if necessary."
End If

// Add inspection observations
Datastore lds_Insp
mt_n_stringfunctions ln_Str
String ls_Temp
lds_Insp=Create DataStore
lds_Insp.DataObject="d_sq_tb_inspmgmtemail"
lds_Insp.SetTransObject(SQLCA)
If lds_Insp.Retrieve(al_InspID)>0 then
	ls_Body += "<br/><br/>The inspector's initial list of observations is stated below:<br/><br/>"
	ls_Body += "<div style='padding:10px;border:solid 1px gray'><table style='font-family:Verdana;font-size:8pt;' cellpadding='3'>"
	For li_Mgmt=1 to lds_Insp.RowCount()
		ls_Temp = ln_Str.of_HTMLEncode(lds_Insp.GetItemString(li_Mgmt,"QName"))
		If IsNull(ls_Temp) then ls_Temp = "" Else ls_Temp = " - " + ls_Temp
		ls_Body += "<tr valign='top'><td><b>" + lds_Insp.GetItemString(li_Mgmt,"QNumFull") + "</b>" + ls_Temp + "</td><td style='width:15%;text-align:right'>Risk:&nbsp;"
		ls_Temp = lds_Insp.GetItemString(li_Mgmt, "RiskName")
		Choose Case ls_Temp
			Case "Low"
				ls_Temp = "00AF00'>" + ls_Temp
			Case "Medium"
				ls_Temp = "CC5500'>" + ls_Temp
			Case "High"
				ls_Temp = "FF0000'>" + ls_Temp
		End Choose
		ls_Body += "<span style='color:#" + ls_Temp + "</span></td></tr>"
		ls_Body += "<tr><td colspan='2'><b>Inspector's Comments</b><br/>" + ln_Str.of_HTMLEncode(lds_Insp.GetItemString(li_Mgmt,"InspComm")) + "</td></tr>"
		ls_Body += "<tr><td colspan='2'><b>Vessel's Initial Comments</b><br/>" + ln_Str.of_HTMLEncode(_GetVesselInitialComments(lds_Insp.GetItemNumber(li_Mgmt,"Item_ID"))) + "</td></tr>"
		ls_Body += "<tr><td colspan='2'><br/><hr/></td></tr>"
	Next
	ls_Body += "</table></div>"
End If
Destroy lds_Insp

// Conclude email
ls_Body += "<br/><br/>Best Regards,<br/>VIMS"
ls_Body += "<br/><br/><small>" + is_EmailFooter + "</small></body></html>"

// Run loop and add emails of all management users
li_Obs = lds_Users.RowCount()
lnvo_Mail = Create mt_n_outgoingmail
For li_Mgmt = 1 to lds_Users.RowCount()
	If li_Mgmt=1 Then
		lnvo_Mail.of_Createmail("tramosmt@maersk.com", "VIMS", lds_Users.GetItemString(li_Mgmt, "UserEmail"),lds_Users.GetItemString(li_Mgmt, "FullName"), ls_Sub, ls_Body, ls_Err)
		lnvo_Mail.of_SetCreator("JAU010", ls_Err)	
	Else
		lnvo_Mail.of_AddReceiver(lds_Users.GetItemString(li_Mgmt, "UserEmail"), lds_Users.GetItemString(li_Mgmt, "FullName"), ls_Err)
	End If
	ls_Users += lds_Users.GetItemString(li_Mgmt, "FullName") + ", "
	ls_Emails += lds_Users.GetItemString(li_Mgmt, "UserEmail") + "; "
Next
// Add email of department of vetting super
If Not IsNull(ls_Super) then
	Select DEPTNAME, DEPTNOTE into :ls_Comp, :ls_Super From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Super;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Super, ls_Comp, ls_Err)
	ls_Users += ls_Comp + ", "
	ls_Emails += ls_Super + "; "
	li_Obs++
End If
// Add email of department of tech super
If Not IsNull(ls_Tech) then
	Select DEPTNAME, DEPTNOTE into :ls_Comp, :ls_Tech From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Tech;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Tech, ls_Comp, ls_Err)
	ls_Users += ls_Comp + ", "
	ls_Emails += ls_Tech + "; "	
	li_Obs++
End If
// Add Vessel email
If Not IsNull(ls_VslEmail) and ls_VslEmail>"" then
	ls_VslEmail = of_CheckAutomailEmail(ls_VslEmail)
	lnvo_Mail.of_AddReceiver(ls_VslEmail, ls_Vessel, ls_Err)
	ls_Users += ls_Vessel + ", "
   ls_Emails += ls_VslEmail + "; "	
	li_Obs++
End If

// Send email
If lnvo_Mail.of_SendMail(ls_Err) = 1 then 
		If Len(ls_Users)>0 then
			ls_Users = Left(ls_Users, Len(ls_Users) - 2)  // Remove last comma
			ls_Emails = Left(ls_Emails, Len(ls_Emails) - 2)  // Remove last comma
			as_Users = ls_Users   // Return users
			ls_Users = "Management Notifications sent to: " + ls_Users
		End If

		of_LogEmail(ls_Emails, ls_Sub, ls_Body)
		
		Update VETT_INSP Set MGMT_REVIEW = 1 Where INSP_ID = :al_InspID;
  		of_AddInspHist(al_InspID, 19, ls_Users)   	
  		Commit;
Else
	li_Obs=0
End If

Return li_Obs
end function

public subroutine of_launchwiki (string as_wikipage);// This function opens a wiki page in Internet explorer

Inet iinet_base

GetContextService("Internet", iinet_base)

iinet_base.HyperlinkToURL("http://team.apmoller.net/sites/Tramos/Wiki/" + as_WikiPage)

end subroutine

public subroutine of_checksiredue ();// This function goes thru all active vessels that are not 3P or T/C and checks
// their last SIRE date and next due date.

// If 1 month (or as per setting) since due date, an email is sent to the Super
// If 1.5 months (or as per setting) since due date, an email is sent to all managers of the super.

DataStore lds_OverDue
Integer li_Row, li_Super, li_Mng
String ls_Err

// Check if Email notification is enabled
f_Config("SREM", ls_Err, 0)
If ls_Err <> "1" Then Return

// Create main datastore
lds_OverDue = Create DataStore

// Get Super delay days
f_Config("SRSP", ls_Err, 0)
If ls_Err = "" then ls_Err = "30"
li_Super = Integer(ls_Err)

// Get manager delay days
f_Config("SRMG", ls_Err, 0)
If ls_Err = "" then ls_Err = "45"
li_Mng = Integer(ls_Err)

// Get all vessels and SIRE info
lds_OverDue.DataObject = "d_sq_tb_sireoverdue"
lds_OverDue.SetTransObject(sqlca)
ls_Err = ""

If lds_OverDue.Retrieve( )>0 then 
	SetPointer(HourGlass!)
	
	// First, reset flags of any SIREs that are less than super days overdue
	For li_Row = 1 to lds_OverDue.RowCount()  
		If lds_OverDue.GetItemNumber(li_Row, "OverDue") < li_Super and lds_OverDue.GetItemNumber(li_Row, "SireDueStatus") > 0 Then lds_OverDue.SetItem(li_Row, "SireDueStatus", 0)
	Next	
	lds_OverDue.Update()
	
	Commit;

	// Find and email all SIREs that are overdue by "super" or more days and are not emailed yet
	lds_OverDue.SetFilter("OverDue>=" + String(li_Super) + " and OverDue<" + String(li_Mng) + " and SireDueStatus=0")
	lds_OverDue.Filter()	
	For li_Row = 1 to lds_OverDue.RowCount()
		ls_Err += of_SendSIRENotice(lds_OverDue.GetItemString(li_Row, "VslName"),lds_OverDue.GetItemDateTime(li_Row, "LastSire"),lds_OverDue.GetItemDateTime(li_Row, "SireDue"),lds_OverDue.GetItemString(li_Row, "Resp"), False)
		lds_OverDue.SetItem(li_row, "SireDueStatus", 1)
	Next
	lds_OverDue.Update()
	
	Commit;
	
	// Find and email all SIREs that are overdue by "Mng" or more days and are not emailed to managers yet
	lds_OverDue.SetFilter("OverDue>=" + String(li_Mng) + " and SireDueStatus<2")
	lds_OverDue.Filter()
	For li_Row = 1 to lds_OverDue.RowCount()
		ls_Err += of_SendSIRENotice(lds_OverDue.GetItemString(li_Row, "VslName"),lds_OverDue.GetItemDateTime(li_Row, "LastSire"),lds_OverDue.GetItemDateTime(li_Row, "SireDue"),lds_OverDue.GetItemString(li_Row, "Resp"), True)
		lds_OverDue.SetItem(li_row, "SireDueStatus", 2)
	Next
	lds_OverDue.Update()
	
End If

Commit;

Destroy lds_OverDue

end subroutine

public function string of_sendsirenotice (string as_vslname, datetime adt_lastsire, datetime adt_nextdue, string as_resp, boolean ab_tomanager);
String ls_Mail, ls_Temp
mt_n_outgoingmail lnvo_Mail
Integer li_OverDue
lnvo_Mail = Create mt_n_outgoingmail

li_OverDue = DaysAfter(Date(adt_LastSire), Today())

// Create email text
ls_Mail = "<html><body style='font-family:Verdana;font-size:10pt;'>Greetings,<br/><br/>This is an automatic notification email from VIMS for the following:<br/><br/>"
ls_Mail += "Notification - <b>" + String(li_OverDue/30, "0.0") + "</b> months have elapsed since the last SIRE.<br/><br/><table style='font-family:Verdana;font-size:10pt;'>"
ls_Mail += "<tr><td>Vessel Number/Name</td><td> : " + as_VslName
ls_Mail += "</td></tr><tr><td>Last SIRE Date</td><td> : " + String(adt_lastsire, "dd MMM yyyy")
ls_Mail += "</td></tr><tr><td>Next SIRE Due</td><td> : " + String(adt_NextDue, "dd MMM yyyy")
ls_Mail += "</td></tr></table><br/><br/>"
If ab_ToManager = False Then ls_Mail += "Please send your manager an update with primary and secondary plans for having the vessel inspected as soon as possible.<br/><br/>"
ls_Mail += "Best Regards,<br/>VIMS System Admin<br/><br/><small>"
ls_Mail += is_EmailFooter + "</small></body></html>"

String ls_Email, ls_DeptEmail, ls_Sub

ls_Sub = "VIMS - SIRE Due Notification (" + as_VslName + ")"

// Send mails
Do

	// Get Dept email
	Select EMAIL,DEPTNOTE Into :ls_Email,:ls_DeptEmail From USERS Inner Join VETT_DEPT On VETT_DEPT.DEPT_ID=USERS.VETT_DEPT Where USERID=:as_Resp;
	Commit;
	
	If IsNull(ls_Email) Then ls_Email = as_Resp + "@maersk.com"  // If email is null, use UserID as email
	
	If lnvo_Mail.of_CreateMail( "tramosmt@maersk.com", ls_Email, ls_Sub , ls_Mail, ls_Temp) = 1 then	
		lnvo_Mail.of_SetCreator("JAU010", ls_Temp)
	  If Pos(ls_DeptEmail, "@")>0 Then	lnvo_Mail.of_AddReceiver(ls_DeptEmail, ls_Temp)
		If lnvo_Mail.of_SendMail(ls_Temp)=-1 then Return ls_Temp
		of_LogEmail(ls_Email + "; " + ls_DeptEmail, ls_Sub, ls_Mail)
	Else
		Return ls_Temp
	End If	
	If ab_ToManager = True Then
		Select VETT_MANAGER Into :as_Resp From USERS Where USERID = :as_Resp;
		If SQLCA.SQLCode<>0 then SetNull(as_Resp)
		Commit;
	Else
		SetNull(as_Resp)
	End If
	lnvo_Mail.of_Reset()
Loop Until IsNull(as_Resp)

Destroy lnvo_Mail

Return ""
end function

public subroutine of_sendmail2tech (long al_inspid);
// This function send a notification email to the technical responsible for an inspection

mt_n_outgoingmail lnvo_Mail
String ls_Body, ls_Email, ls_Err, ls_Vessel, ls_Model, ls_Comp, ls_Sub
Integer li_Review, li_NoTech
DateTime ldt_Date

// Get vessel name/number and tech super & dept email
Select TOP 1 VESSEL_REF_NR + ' - ' + VESSEL_NAME, DEPTNOTE, TECH_REVIEW into :ls_Vessel, :ls_Email, :li_Review
from VESSELS Inner Join VETT_INSP On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO
Inner Join USERS On USERS.USERID=TECH_SUPER
Inner Join VETT_DEPT On VETT_DEPT.DEPT_ID=USERS.VETT_DEPT

Where (VESSELS.VESSEL_ACTIVE = 1) and (VETT_OFFICEID is not Null) and (VETT_TYPE is not null) and (INSP_ID = :al_InspID);

If SQLCA.SQLCode<>0 then	
	Rollback;	
	Return
End If

Commit;

// Check if email already sent today
Select TECHEMAILSENT into :ldt_Date from VETT_INSP Where INSP_ID = :al_InspID;
Commit;
If Not IsNull(ldt_Date) Then
	If Date(ldt_Date) = Today() then Return
End If

// Get Insp Data
Select VETT_INSPMODEL.NAME, INSPDATE, VETT_COMP.NAME, NOTECHREVIEW
Into :ls_Model, :ldt_Date, :ls_Comp, :li_NoTech From VETT_INSP
Inner Join VETT_INSPMODEL On VETT_INSPMODEL.IM_ID = VETT_INSP.IM_ID
Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_INSP.COMP_ID
Where VETT_INSP.INSP_ID = :al_InspID;

// If no review required, then exit
If li_NoTech = 1 then Return

// Subject
ls_Sub = "Notification for Inspection Review (" + ls_Vessel + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Greetings,<br/><br/>This is a notification email from VIMS for the review of following inspection.<br/><br/>"
ls_Body += "CAPs have been raised for observations where applicable. For other observations and the Inspection Summary (incl. photo attachments) you are kindly requested to provide your additional comments for the appropriate observations in VIMS.<br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;'><tr><td>Vessel Number/Name</td><td> : " + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Inspection Type</td><td> : " + ls_Model + "</td></tr>"
ls_Body += "<tr><td>Inspection Date</td><td> : " + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Conducted By</td><td> : " + ls_Comp + "</td></tr></table><br/><br/>"
ls_Body += "Best Regards,<br/>VIMS System Admin<br/><br/><hr/><small>"
ls_Body += guo_Global.is_Emailfooter + "</small></body></html>"

// Create and send email
lnvo_Mail = Create mt_n_outgoingmail
If lnvo_Mail.of_CreateMail( "tramosmt@maersk.com", ls_Email, ls_Sub, ls_Body, ls_Err) < 1 then Return
lnvo_Mail.of_SetCreator("JAU010", ls_Err)
If lnvo_Mail.of_SendMail(ls_Err) < 1 then Return

of_LogEmail(ls_Email, ls_Sub, ls_Body)

// If previously not reviewed, then set status as 'Notification Sent'
If li_Review = 0 then 
	Update VETT_INSP Set TECH_REVIEW = 10 Where INSP_ID = :al_InspID;	
	Commit;
End If

// Update date last sent date
Update VETT_INSP Set TECHEMAILSENT = GetDate() Where INSP_ID = :al_InspID;
Commit;

end subroutine

public subroutine of_addsysmsg (integer ai_msgtype, string as_id, string as_ver, string as_info, long al_inspid, string as_time);
DateTime ldt_Time

ldt_Time = DateTime(Today(), Now())

If as_Time > "" then ldt_Time = DateTime(Date(Left(as_Time, 10)), Time(Right(as_Time, 8)))

If ldt_Time < DateTime(date("2000-01-01")) then ldt_Time = DateTime(Today(), Now())

// Get rid of double digits (if present) in version
If Len(as_Ver) = 8 then as_Ver = String(Integer(Left(as_Ver,2))) + "." + String(Integer(Mid(as_Ver,4,2))) + "." + String(Integer(Right(as_Ver,2)))

If al_InspID = 0 then SetNull(al_InspID)

Insert Into VETT_SYSMSG (MSGTIME, MSGTYPE, MOBID, MOBVER, EXTRA, INSP_ID) Values (:ldt_Time, :ai_msgtype, :as_id, :as_ver, :as_info, :al_InspID);

If SQLCA.SQLCode = 0 then
	Commit;
Else	
	Rollback;
End If

end subroutine

public subroutine of_processcommpackage (string as_package);// This function processes incoming communication packages from VIMS Mobile and updates the relevant vessel's data


Integer li_File, li_Check, li_Loop, li_PkgVer = 0
String ls_Data, ls_ID = "", ls_Ver = "", ls_DBVer = "", ls_Msg = "", ls_Time = ""

// Check Filesize
If FileLength64(as_package) > 1024 then   // invalid file
	FileDelete(as_Package)
	Return	
End If

// Open file
li_File = FileOpen(as_package, TextMode!, Read!, LockReadWrite!, Replace!, EncodingUTF8!)
If (li_File <= 0) then  // if cannot open
	FileDelete(as_Package)
	Return
End If

// Read, close and delete file
FileReadEx(li_File, ls_Data)
FileClose(li_File)
FileDelete(as_Package)

// Verify checksum first
For li_Loop = 1 to Len(ls_Data) - 1
	li_Check += AscA(Mid(ls_data,li_Loop,1))
Next
If Mod(li_Check,256) <> AscA(Right(ls_Data, 1)) then
	of_AddSysMsg(9, "", "", "Comm Package Checksum failed: " + as_package, 0, "")
	// Return  - Temporary disabled checksum fail return on 17/12/2013
End If

ls_Data = Left(ls_Data, Len(ls_Data)-1)  // Get rid of checksum character
li_Loop = 6   // Bypass 5 header chars

Char lc_Char

Try

	// Get version number ID (or sender ID)
	lc_Char = CharA(255 - AscA(Mid(ls_data,li_Loop,1)))
	Do While lc_Char<>";" and li_Loop<=Len(ls_Data)
		ls_ID += String(lc_Char)
		li_Loop ++
		lc_Char = CharA(255 - AscA(Mid(ls_data,li_Loop,1)))
	Loop	
		
	li_Loop ++	
	
	If (Len(ls_Id) = 3) and (Left(ls_ID, 1) = "V") then  // If info is commpkg version number
		
		li_PkgVer = Integer(Right(ls_ID, 2)) // Extract version and reset ID
		ls_ID = ""
		
		// Get sender ID
		lc_Char = CharA(255 - AscA(Mid(ls_data,li_Loop,1)))
		Do While lc_Char<>";" and li_Loop<=Len(ls_Data)
			ls_ID += String(lc_Char)
			li_Loop ++
			lc_Char = CharA(255 - AscA(Mid(ls_data,li_Loop,1)))
		Loop	
			
		li_Loop ++	
		
	End If
		
	// Get VM Version
	Do While CharA(255 - AscA(Mid(ls_data,li_Loop,1)))<>";" and li_Loop<=Len(ls_Data)
		ls_Ver += String(CharA(255 - AscA(Mid(ls_data,li_Loop,1))))
		li_Loop ++
	Loop	
	
	li_Loop ++	
	
	// Get DB Issue number
	Do While CharA(255 - AscA(Mid(ls_data,li_Loop,1)))<>";" and li_Loop<=Len(ls_Data)
		ls_DBVer += String(CharA(255 - AscA(Mid(ls_data,li_Loop,1))))
		li_Loop ++
	Loop	
	
	li_Loop ++	
			
	// Get message
	Do While CharA(255 - AscA(Mid(ls_data,li_Loop,1)))<>";" and li_Loop<=Len(ls_Data)
		ls_Msg += String(CharA(255 - AscA(Mid(ls_data,li_Loop,1))))
		li_Loop ++
	Loop	
	
	li_Loop ++
	
	If li_PkgVer > 0 then   // If version 1 or later
		// Get time
		Do While CharA(255 - AscA(Mid(ls_data,li_Loop,1)))<>";" and li_Loop<=Len(ls_Data)
			ls_Time += String(CharA(255 - AscA(Mid(ls_data,li_Loop,1))))
			li_Loop ++
		Loop			
	End If
		
	// Update version info for vessel
	f_UpdateVMVersion(Mid(ls_ID, 5, 7), ls_Ver, Integer(ls_DBVer))
	
	// Get rid of double digits in version
	ls_Ver = String(Integer(Left(ls_Ver,2))) + "." + String(Integer(Mid(ls_Ver,4,2))) + "." + String(Integer(Right(ls_Ver,2)))

	Long al_InspID

	If left(ls_ID, 4) = "INSP" then  // If this is a Insp acknowledgement
		
		ls_ID = Right(ls_ID, Len(ls_ID) - 4)  // Get global ID
		
		Select INSP_ID into :al_InspID from VETT_INSP Where GLOBALID = :ls_ID;			 // Get Insp ID using globalid
		If SQLCA.SQLCode <> 0 then 
			Rollback;
			al_InspID = 0
		Else
			Commit;
		End If
		
		If Right(ls_Msg, 1) <> "!" then  // No error
			
			of_AddSysMsg(11, Left(ls_ID, 7), ls_ver, ls_Msg, al_InspID, ls_Time)  // Add system message
		
			Update VETT_INSP Set EXPFLAG = 3 Where INSP_ID = :al_InspID and EXPFLAG > 1;  // Update flag on inspection
			Update VETT_ATT Set IMPORTED = 3 Where INSP_ID = :al_InspID and IMPORTED = 2;  //  Update flags on attachments
			
			If SQLCA.SQLCode = 0 then 
				Commit;
			Else
				Rollback;
			End If		
			
		Else   // error msg present
			
			of_AddSysMsg(12, Left(ls_ID, 7), ls_ver, ls_Msg, al_InspID, ls_Time)
			
			If SQLCA.SQLCode = 0 then 
				Commit;
			Else
				Rollback;
			End If			
		End If
		
	ElseIf Left(ls_ID, 4) = "PING" then   // this is a ping response
		
		of_AddSysMsg(8, Mid(ls_ID, 5, 7), ls_ver, "Ping response received from vessel", 0, ls_Time)
		
	ElseIf Left(ls_Id, 4) = "DBST" then   // DB Issue update status
		
		of_AddSysMsg(3, Mid(ls_ID, 5, 7), ls_ver, ls_Msg, 0, ls_Time)
		
	ElseIf Left(ls_Id, 4) = "ERRR" then  // System error occurred
		
		of_AddSysMsg(14, Mid(ls_ID, 5, 7), ls_ver, ls_Msg, 0, ls_Time)
		
	Else   // header is invalid
		
		of_AddSysMsg(9, Mid(ls_ID, 5, 7), ls_ver, "Invalid Comm Package header", 0, ls_Time)
		
	End If
		
Catch (Exception li_Ex)
	of_AddSysMsg(6, "", "", "Exception in f_ProcessCommPackage(): " + li_Ex.Text, 0, "")
End Try

end subroutine

public function string of_sendmail2vessel (string as_vesselemail, string as_subject, string as_attpath);mt_n_outgoingmail lnvo_Mail
String ls_Temp

lnvo_Mail = Create mt_n_outgoingmail

If lnvo_Mail.of_createmail( "tramosmt@maersk.com", as_VesselEmail, as_Subject, "[ This email was generated automatically by the Vetting and Inspection Management System. If you are reading this mail, your Automail system is not correctly setup for VIMS communication. Do not reply to this mail. Open the VIMS Mobile Help file and see section Installation and Setup > Automail Setup. Please contact maropsmt@maersk.com for any further assistance, if required. ]", ls_Temp) = 1 then
  If lnvo_Mail.of_addattachment(as_AttPath, ls_Temp) < 1 then Return ls_Temp
Else
	Return ls_Temp
End If
If lnvo_Mail.of_SetCreator("JAU010", ls_Temp) = -1 then Return ls_Temp
If lnvo_Mail.of_VerifyReceiverAddress(as_VesselEmail, ls_Temp) = -1 then Return ls_Temp
If lnvo_Mail.of_SendMail(ls_Temp) < 1 then Return ls_Temp Else Return ""

end function

public function integer of_sendrejectionnotice (long al_rejectid);// This function sends and email to management users with details of a rejection

// Parameters:
// al_RejectID - The Rejection ID

// Return value - Number of emails sent, or -1 for fail


Datastore lds_Users
mt_n_outgoingmail lnvo_Mail

/* ----- Prepare email to management ----- */

DateTime ldt_Date
String ls_Vessel, ls_Comp, ls_Detail, ls_Reason, ls_Body, ls_Err, ls_By, ls_Super, ls_Tech, ls_VslEmail, ls_Sub, ls_Email
Integer li_Mgmt
Long ll_InspID

// Get list of users to email to...
lds_Users = Create Datastore
lds_Users.Dataobject = "d_sq_tb_mgmt"
lds_Users.SetTransObject(SQLCA)

// If no users to send to, then exit
If lds_Users.Retrieve() <=0 then 
	Destroy lds_Users
	Return 0
End If

// Get vessel name/number, Insp Date and company name
Select TOP 1 VESSEL_REF_NR + ' - ' + VESSEL_NAME, REJECTDATE, VETT_COMP.NAME, VETT_REJREASON.REASON, VETT_REJECT.DETAILS, INSP_ID, FIRST_NAME + ' ' + LAST_NAME, VETT_RESP, TECH_SUPER, VESSEL_EMAIL
Into :ls_Vessel, :ldt_Date, :ls_Comp, :ls_Reason, :ls_Detail, :ll_InspID, :ls_By, :ls_Super, :ls_Tech, :ls_VslEmail
From VESSELS Inner Join VETT_REJECT On VESSELS.IMO_NUMBER = VETT_REJECT.VESSELIMO
Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_REJECT.COMP_ID
Inner Join VETT_REJREASON On VETT_REJECT.RSNID=VETT_REJREASON.RSNID
Inner Join USERS On USERS.USERID=VETT_REJECT.USERID
Where (VESSELS.VESSEL_ACTIVE = 1) and (VETT_OFFICEID is not Null) and (VETT_TYPE is not null) and (REJECTID = :al_RejectID);
If SQLCA.SQLCode<>0 then 
	Rollback;
	Return -1
End If
Commit;

mt_n_stringfunctions ln_str

// Subject
ls_Sub = "VIMS - Vessel Rejection Notification (" + ls_Vessel + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Good-day,<br/><br/>This is an automatic notification email for a new vessel rejection:<br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;' cellpadding='3'><tr><td>Vessel:</td><td>" + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Rejection Date:</td><td>" + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Rejected By:</td><td>" + ls_Comp + "</td></tr>"
ls_Body += "<tr><td>Rejection Reason:</td><td>" + ls_Reason + "</td></tr>"
ls_Body += "<tr><td>Created By:</td><td>" + ls_By + "</td></tr>"
ls_Body += "<tr><td valign='top'>Details:</td><td>" + ln_str.of_HtmlEncode(ls_Detail) + "</td></tr>"

// If linked to inspection
If Not IsNull(ll_InspID) Then
	Select INSPDATE, NAME + ' ' + EDITION Into :ldt_Date, :ls_Comp
	From VETT_INSP Inner Join VETT_INSPMODEL On VETT_INSP.IM_ID=VETT_INSPMODEL.IM_ID
	Where INSP_ID=:ll_InspID;
	If SQLCA.SQLCode<>0 Then
		Rollback;
	Else
		Commit;
		ls_Body += "<tr><td>Linked Inspection:</td><td>" + ls_Comp + ", " + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
	End If
End If

ls_Body += "</table><br/><br/>Best Regards,<br/>VIMS"
ls_Body += "<br/><br/><small>" + is_EmailFooter + "</small></body></html>"

// Run loop and send email to all management users
lnvo_Mail = Create mt_n_outgoingmail
For li_Mgmt = 1 to lds_Users.RowCount()
	If li_Mgmt=1 Then
		lnvo_Mail.of_Createmail("tramosmt@maersk.com", "VIMS", lds_Users.GetItemString(li_Mgmt, "UserEmail"),lds_Users.GetItemString(li_Mgmt, "FullName"), ls_Sub, ls_Body, ls_Err)		
		lnvo_Mail.of_SetCreator("JAU010", ls_Err)	
	Else
		lnvo_Mail.of_AddReceiver(lds_Users.GetItemString(li_Mgmt, "UserEmail"), lds_Users.GetItemString(li_Mgmt, "FullName"), ls_Err)
	End If
	ls_Email += lds_Users.GetItemString(li_Mgmt, "UserEmail") + "; "
Next
// Add email of department of vetting super
If Not IsNull(ls_Super) then
	Select DEPTNAME, DEPTNOTE into :ls_Comp, :ls_Super From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Super;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Super, ls_Comp, ls_Err)
	ls_Email += ls_Super + "; "
End If
// Add email of department of tech super
If Not IsNull(ls_Tech) then
	Select DEPTNAME, DEPTNOTE into :ls_Comp, :ls_Tech From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Tech;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Tech, ls_Comp, ls_Err)
	ls_Email += ls_Tech + "; "	
End If
// Add Vessel email
If Not IsNull(ls_VslEmail) and ls_VslEmail>"" then	
	ls_VslEmail = of_CheckAutomailEmail(ls_VslEmail)
	lnvo_Mail.of_AddReceiver(ls_VslEmail, ls_Vessel, ls_Err)
	ls_Email += ls_VslEmail + "; "
End If

of_LogEmail(ls_Email, ls_Sub, ls_Body)

Return lnvo_Mail.of_SendMail(ls_Err)

end function

private function string _getvesselinitialcomments (long ai_itemid);
String ls_Comm 

Select Top 1 DATA Into :ls_Comm From VETT_ITEMHIST
Where ITEM_ID=:ai_ItemID and ORIGIN='Vessel' Order By TIME_ID;

Commit;

If IsNull(ls_Comm) Then ls_Comm=""

Return ls_Comm
end function

public function string of_sendvbismail (long al_inspid, integer ai_amount);// This function sends the VBIS email to vetting super tech super & vessel. 

// Parameters:
// al_InspID - The SIRE inspection ID
// ai_Amount - The USD Amount to include in the email

// Returns error string or empty string for success

String ls_Model, ls_Users, ls_Port, ls_Sub, ls_Email
mt_n_outgoingmail lnvo_Mail

// Get Inspection Model
Select VETT_INSPMODEL.NAME + ' ' + EDITION Into :ls_Model
from VETT_INSPMODEL Inner Join VETT_INSP On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID 
Where INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then
	Rollback;
	Return "SQL Error"
End If
Commit;

DateTime ldt_Date
String ls_Vessel, ls_Comp, ls_Body, ls_Err, ls_Super, ls_Tech, ls_VslEmail

// Get vessel name/number, Email
Select TOP 1 VESSEL_REF_NR + ' - ' + VESSEL_NAME, VESSEL_EMAIL,INSPDATE, VETT_COMP.NAME, PORT_N, VETT_RESP, TECH_SUPER
Into :ls_Vessel, :ls_VslEmail, :ldt_Date, :ls_Comp, :ls_Port, :ls_Super, :ls_Tech
From VESSELS Inner Join VETT_INSP On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO
Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_INSP.COMP_ID
Inner Join PORTS On VETT_INSP.PORT = PORTS.PORT_CODE
Where (VESSELS.VESSEL_ACTIVE = 1) and (VETT_OFFICEID is not Null) and (VETT_TYPE is not null) and (INSP_ID = :al_InspID);
If SQLCA.SQLCode<>0 then 
	Rollback;
	Return "SQL Error"
End If
Commit;

/* ----- Prepare email ----- */

// Subject
ls_Sub = "VIMS - VBIS Payout Notification (" + ls_Vessel + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'><i>Dear Captain,<br/><br/>"
ls_Body += "Thank you to all on-board for their hard work and dedication to make this inspection a success.<br/><br/>"
ls_Body += "In accordance with the Vetting Bonus Incentive Scheme (VBIS) implemented by Maersk Tankers Technical Operations in 2012, you are eligible for pay-out of USD " + String(ai_Amount) + " from Master's Cash to Vessel Welfare Fund. Please await email from IOMFIN for authorizing this payout.<br/><br/>"
ls_Body += "Well done.<br/><br/><br/>"

ls_Body += "<u>Winner Inspection Criteria:</u><br/><br/>Total Observations Limit: 3*<br/><br/>"
ls_Body += "<span style='font-size:8pt;color:gray'>* Excluding non-scoring question 9.23</span><br/><br/>"

ls_Body += "<u>Inspection Details</u><br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:8pt;' cellpadding='3'><tr><td>Vessel Number/Name:</td><td>" + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Inspection Type:</td><td>" + ls_Model + "</td></tr>"
ls_Body += "<tr><td>Inspection Date:</td><td>" + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Inspection Port:</td><td>" + ls_Port + "</td></tr>"
ls_Body += "<tr><td>Conducted By:</td><td>" + ls_Comp + "</td></tr>"
ls_Body += "</table>"

// Add inspection observations
Datastore lds_Insp
mt_n_stringfunctions ln_Str
String ls_Temp
Integer li_Loop
lds_Insp=Create DataStore
lds_Insp.DataObject="d_sq_tb_inspmgmtemail"
lds_Insp.SetTransObject(SQLCA)
If lds_Insp.Retrieve(al_InspID)>0 then
	ls_Body += "<br/><br/>The Inspector's final list of observations is stated below. Non-scoring observations are marked in red font.<br/><br/></i>"
	ls_Body += "<div style='padding:10px;border:solid 1px gray;font-size:8pt'>"
	For li_Loop=1 to lds_Insp.RowCount()
		ls_Body += "<b>"

		ls_Temp = lds_Insp.GetItemString(li_Loop,"QNumFull")
		If ls_Temp="9.26" or ls_Temp="13.13" or ls_Temp="13.14" Then 
			ls_Body += "<span style='color:Red'>"
			ls_Body += ls_Temp
			ls_Body += "</span>"
		Else
			ls_Body += ls_Temp
		End If

		ls_Temp = ln_Str.of_HTMLEncode(lds_Insp.GetItemString(li_Loop,"QName"))
		If IsNull(ls_Temp) then ls_Temp = "" Else ls_Temp = " - " + ls_Temp
		ls_Body += "</b>" + ls_Temp

		ls_Body += "<br/><br/><b>Inspector's Comments</b><br/>" + ln_Str.of_HTMLEncode(lds_Insp.GetItemString(li_Loop, "InspComm"))
		ls_Body += "<br/><br/><b>Vessel's Initial Comments</b><br/>" + ln_Str.of_HTMLEncode(_GetVesselInitialComments(lds_Insp.GetItemNumber(li_Loop, "Item_ID")))
		ls_Body += "<br/><hr/>"
	Next
	ls_Body += "</div>"
End If
Destroy lds_Insp

// Conclude email
ls_Body += "<br/><br/>Best Regards,<br/>VIMS"
ls_Body += "<br/><br/><small>" + is_EmailFooter + "</small></body></html>"

// Add Vessel email
If Not IsNull(ls_VslEmail) and ls_VslEmail>"" then
	ls_VslEmail = of_CheckAutomailEmail(ls_VslEmail)
	lnvo_Mail = Create mt_n_outgoingmail
	lnvo_Mail.of_Createmail("tramosmt@maersk.com", "VIMS", ls_VslEmail, ls_Vessel, ls_Sub, ls_Body, ls_Err)
	lnvo_Mail.of_SetCreator("JAU010", ls_Err)		
	ls_Users = ls_Vessel + ", "
	ls_Email = ls_VslEmail + "; "
Else
	Return "No Vessel Email"
End If

// Add email of vetting super
If Not IsNull(ls_Super) then
	Select DEPTNAME, DEPTNOTE into :ls_Comp, :ls_Super From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Super;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Super, ls_Comp, ls_Err)
	ls_Users += ls_Comp + ", "
	ls_Email += ls_Super + "; "	
End If

// Add email of tech super
If Not IsNull(ls_Tech) then
	Select DEPTNAME, DEPTNOTE into :ls_Comp, :ls_Tech From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Tech;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Tech, ls_Comp, ls_Err)
	ls_Users += ls_Comp + ", "
	ls_Email += ls_Tech + "; "	
End If

// Add IOMFIN@maersk.com
lnvo_Mail.of_AddReceiver("IOMFIN@maersk.com","IOMFIN", ls_Err)
ls_Users += "IOMFIN"
ls_Email += "IOMFIN@maersk.com" + ";"	

// Send email
If lnvo_Mail.of_SendMail(ls_Err) = 1 then 
		If Len(ls_Users)>0 then	ls_Users = "VBIS Payout Email (USD " + String(ai_Amount) + ") sent to: " + ls_Users
		If ai_Amount > 750 Then ai_Amount = 2 Else ai_Amount = 1
		Update VETT_INSP Set VBIS = :ai_Amount Where INSP_ID = :al_InspID;
  		of_AddInspHist(al_InspID, 20, ls_Users)   			  
  		Commit;
		of_LogEmail(ls_Email, ls_Sub, ls_Body)
Else
	Destroy lnvo_Mail
	Return "SendMail() Failed: " + ls_Err
End If

Destroy lnvo_Mail

Return ""

end function

public function string of_checkautomailemail (string as_vslemail);// This function checks to see if the email begins with 'automail' and changes it to 'master'

// Ensure lower case
as_VslEmail = Trim(Lower(as_VslEmail), True) 

// For Brostrom vessels, change to master
If Left(as_VslEmail, 8) = "automail" Then as_VslEmail = "master" + Right(as_VslEmail, Len(as_VslEmail) - 8)

Return as_VslEmail

end function

public subroutine of_sendinspreminder (string as_vslname, string as_vslemail, string as_superdept, string as_superemail, string as_imname, date adt_inspdate, integer ai_interval, integer ai_togo, long al_inspid);// This function send a notification email to the technical responsible for an inspection
// Called by VettSvr app

mt_n_outgoingmail lnvo_Mail
String ls_Body, ls_Err, ls_Due, ls_Sub, ls_Email
Integer li_Review, li_NoTech
DateTime ldt_Date

If ai_ToGo < 1 then ls_Due="<tr style='color:Red;'><td>Overdue By" Else ls_Due="<tr><td>Next Due In"

// Subject
ls_Sub = "Inspection Due Reminder - " + as_IMName + " (" + as_VslName + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Good Day Captain,<br/><br/>This is a reminder email from VIMS for an inspection due. No further reminders will be sent on the subject.<br/><br/><table style='font-family:Verdana;font-size:10pt;'>"
ls_Body += "<tr><td>Vessel Name:</td><td>" + as_VslName + "</td></tr>"
ls_Body += "<tr><td>Inspection Type:&nbsp;&nbsp;</td><td>" + as_IMName + "</td></tr>"
ls_Body += "<tr><td>Last Done:</td><td>" + String(adt_InspDate,"dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Interval:</td><td>" + String(ai_Interval) + " months</td></tr>"
ls_Body += ls_Due + ":</td><td>" + String(Abs(ai_ToGo)) + " days</td></tr></table>"
ls_Body += "<br/><br/>Best Regards,<br/>VIMS System Admin"
ls_Body += "<br/><br/><hr/>" + guo_Global.is_Emailfooter + "</body></html>"

// Create and send email
lnvo_Mail = Create mt_n_outgoingmail
ls_Email = of_CheckAutomailEmail(as_VslEmail)
If lnvo_Mail.of_createmail( "tramosmt@maersk.com", ls_Email, ls_Sub, ls_Body, ls_Err) < 1 then Return
If as_SuperEmail>"" then lnvo_Mail.of_AddReceiver(as_SuperEmail, as_SuperDept, ls_Err)		
lnvo_Mail.of_SetCreator("JAU010", ls_Err)
If lnvo_Mail.of_SendMail(ls_Err) < 1 then Return

Destroy lnvo_Mail

ls_Email += "; " + as_SuperEmail
of_LogEmail(ls_Email, ls_Sub, ls_Body)

// Update date last sent date
Update VETT_INSP Set REMINDER = GetDate() Where INSP_ID = :al_InspID;
Commit;

end subroutine

public function blob of_decodebase64 (string as_base64);// Decodes a Base64 string and returns a blob

Blob lblob_data
ULong lul_len, lul_buflen, lul_skip, lul_pflags
CONSTANT Ulong CRYPT_STRING_BASE64 = 1

lul_len = Len(as_Base64)
lul_buflen = lul_len
lblob_data = Blob(Space(lul_len))

CryptStringToBinary(as_Base64, lul_len, CRYPT_STRING_BASE64, lblob_data, lul_buflen, lul_skip, lul_pflags)

Return BlobMid(lblob_data, 1, lul_buflen)


end function

public subroutine of_logemail (string as_recipients, string as_subject, string as_body);// Function to log all outgoing emails from VIMS

as_Subject = Left(as_Subject, 100)
as_Recipients = Left(as_Recipients, 1000)

Insert Into VETT_MAILLOG(MAILSENT,SUBJECT,RECIPIENTS,BODY) Values(GetDate(),:as_Subject,:as_Recipients,:as_Body);

Commit;

// No need to check for errors
	
end subroutine

public function integer of_sendredflagportsemail ();// This functions sends out a reminder for all red flag ports that were last updated more than 12 months ago.
// Returns 1 on success, -1 on error, 0 if no email to send

Datastore lds_Ports
Integer li_Ports
String ls_Msg, ls_Sub, ls_Email, ls_Temp
mt_n_outgoingmail lnvo_Mail

lds_Ports = Create Datastore
lds_Ports.DataObject="d_sq_tb_redflagportrem"
lds_Ports.SetTransObject(SQLCA)

If lds_Ports.Retrieve()<0 Then Return -1
If lds_Ports.RowCount() = 0 Then Return 0

//If ii_LogMode=2 Then f_Log("Outdated Red Flag Ports: " + String(lds_Ports.RowCount()) + " found")
ls_Msg = "<html><body style='font-family:Verdana;font-size:10pt;'>Greetings,<br/><br/>The following Red Flag ports have notes that were updated more than a year ago.<br/><br/>"
ls_Msg += "Kindly update the Red Flag Notes for these ports as soon as possible.<br/><br/>"
ls_Msg += "<table style='font-family:Verdana;font-size:8pt;border-collapse:collapse;' border='1'><tr style='font-weight:bold'><td>Port Code&nbsp;</td><td>Port Name</td><td>Last Updated</td></tr>"
For li_Ports = 1 to lds_Ports.RowCount()
	ls_Msg += "<tr><td>" + Trim(lds_Ports.GetItemString(li_Ports, "Port_Code"),True)
	ls_Msg += "</td><td>" + lds_Ports.GetItemString(li_Ports, "Port_N")
	ls_Msg += "</td><td>" + String(lds_Ports.GetItemDateTime(li_Ports, "LastUpdate"),"dd MMM yyyy")
	ls_Msg += "</td></tr>"
Next
ls_Msg += "</table><br/><br/>Best Regards,<br/>VIMS System<br/><br/><small>"+ is_EmailFooter + "</small>"
ls_Msg += "</body></html>"

Destroy lds_Ports

lnvo_Mail = Create mt_n_outgoingmail

ls_Sub = "VIMS - Outdated Red Flag Ports"

// Get MAROPS Email
f_Config("MOPS", ls_Email, 0)
If ls_Email="" Then Return -1

If lnvo_Mail.of_CreateMail( "tramosmt@maersk.com", ls_Email, ls_Sub , ls_Msg, ls_Temp) = 1 then	
	lnvo_Mail.of_SetCreator("JAU010", ls_Temp)
	If lnvo_Mail.of_SendMail(ls_Temp)=-1 then 
		Return -1
	End If
	of_LogEmail(ls_Email, ls_Sub, ls_Msg)
	Return 1
Else
	Return -1
End If

end function

public function integer of_checkmireobs (long al_inspid);// This function sends an email all users belonging to 'management' departments 
// and those users selected for management notification and to vetting super, tech super and vessel itself

// The email is sent only if a MIRE inspection does not have the minimum number of observations

// Parameters:
// al_InspID - The inspection ID

// Return value
// 0  = No emails sent
// x  = Number of recipients sent to
// -1 = Error

Integer li_IMID, li_Obs, li_Mgmt, li_MinObs
String ls_Model, ls_Short, ls_Users, ls_Port, ls_Emails, ls_Sub
Datastore lds_Users
mt_n_outgoingmail lnvo_Mail

// First get inspection model settings
Select NAME+' '+EDITION,SHORTNAME Into :ls_Model,:ls_Short
from VETT_INSPMODEL Inner Join VETT_INSP On VETT_INSP.IM_ID = VETT_INSPMODEL.IM_ID 
Where INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then
	Rollback;
	Return -1
End If
Commit;

// If no need to report if not MIRE
If ls_Short<>"MIRE" then Return 0

// Get min obs setting
If f_Config("MMOC", ls_Sub, 0) = -1 then Return -1
If IsNumber(ls_Sub) then li_MinObs = Integer(ls_Sub) Else Return -1

// Get number of 'No' observations
Select Count(ITEM_ID) Into :li_Obs
from VETT_ITEM Where ANS=1 and INSP_ID = :al_InspID;

If SQLCA.SQLCode<>0 then 
	Rollback;
	Return -1
End If
Commit;

// If more than minobs then return
If li_Obs >= li_MinObs Then Return 0

/* ----- Prepare email to management ----- */

DateTime ldt_Date
String ls_Vessel, ls_Inspector, ls_Body, ls_Err, ls_Super, ls_Tech, ls_VslEmail

// Get list of management users to email to...
lds_Users = Create Datastore
lds_Users.Dataobject = "d_sq_tb_mgmt"
lds_Users.SetTransObject(SQLCA)
lds_Users.Retrieve()

// Get vessel name/number, Email, Insp Date and company name, Port
Select TOP 1 VESSEL_REF_NR + ' - ' + VESSEL_NAME, VESSEL_EMAIL,INSPDATE, INSP_FNAME+' '+INSP_LNAME INSPNAME, PORT_N, VETT_RESP, TECH_SUPER
Into :ls_Vessel, :ls_VslEmail, :ldt_Date, :ls_Inspector, :ls_Port, :ls_Super, :ls_Tech
From VESSELS Inner Join VETT_INSP On VESSELS.IMO_NUMBER = VETT_INSP.VESSELIMO
Inner Join VETT_COMP On VETT_COMP.COMP_ID = VETT_INSP.COMP_ID
Inner Join PORTS On VETT_INSP.PORT = PORTS.PORT_CODE
Where (VESSELS.VESSEL_ACTIVE = 1) and (VETT_OFFICEID is not Null) and (VETT_TYPE is not null) and (INSP_ID = :al_InspID);
If SQLCA.SQLCode<>0 then 
	Rollback;
	Return -1
End If
Commit;

// Subject 
ls_Sub = "VIMS - Management Review Notification for MIRE (" + ls_Vessel + ")"

// Create email body
ls_Body = "<html><body style='font-family:Verdana;font-size:10pt;'>Good-day,<br/><br/>This is a"
ls_Body += " notification email from VIMS for the following inspection:<br/><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;' cellpadding='3'><tr><td>Vessel Number/Name:</td><td>" + ls_Vessel + "</td></tr>"
ls_Body += "<tr><td>Inspection Type:</td><td>" + ls_Model + "</td></tr>"
ls_Body += "<tr><td>Inspection Date:</td><td>" + String(ldt_Date, "dd MMM yyyy") + "</td></tr>"
ls_Body += "<tr><td>Inspection Port:</td><td>" + ls_Port + "</td></tr>"
ls_Body += "<tr><td>Conducted By:</td><td>" + ls_Inspector + "</td></tr>"
ls_Body += "<tr><td>Total Observations:</td><td>" + String(li_Obs) + "</td></tr>"
ls_Body += "</table><br/><br/>This notification is being sent as the recent MIRE inspection has not met the minimum expected limit for observations reported. As a guideline to a thorough inspection, management expects that Fleet Safety/ Marine/ Technical Superintendents should be able to report no less than " + String(li_MinObs) + " observations per inspection. Any comments relating to the reason for low internal observation count should be directed to their respective Manager.<br/><br/>"
ls_Body += "<u>MIRE inspections Notification Criteria</u><br/>"
ls_body += "<table style='font-family:Verdana;font-size:10pt;' cellpadding='3'><tr><td>Total Observations Limit:</td><td>Less than " + String(li_MinObs) + "</td></tr>"
ls_Body += "<tr><td>Total High Risk Limit:</td><td><i>No limit set</i></td></tr></table>"

// Add inspection observations
Datastore lds_Insp
mt_n_stringfunctions ln_Str
String ls_Temp
lds_Insp=Create DataStore
lds_Insp.DataObject="d_sq_tb_inspmgmtemail"
lds_Insp.SetTransObject(SQLCA)
If lds_Insp.Retrieve(al_InspID)>0 then
	ls_Body += "<br/><br/>The inspector's observations are stated below:<br/><br/>"
	ls_Body += "<div style='padding:10px;border:solid 1px gray'><table style='font-family:Verdana;font-size:8pt;' cellpadding='3'>"
	For li_Mgmt=1 to lds_Insp.RowCount()
		ls_Temp = ln_Str.of_HTMLEncode(lds_Insp.GetItemString(li_Mgmt,"QName"))
		If IsNull(ls_Temp) then ls_Temp = "" Else ls_Temp = " - " + ls_Temp
		ls_Body += "<tr valign='top'><td><b>" + lds_Insp.GetItemString(li_Mgmt,"QNumFull") + "</b>" + ls_Temp + "</td><td style='width:15%;text-align:right'>Risk:&nbsp;"
		ls_Temp = lds_Insp.GetItemString(li_Mgmt, "RiskName")
		Choose Case ls_Temp
			Case "Low"
				ls_Temp = "00AF00'>" + ls_Temp
			Case "Medium"
				ls_Temp = "CC5500'>" + ls_Temp
			Case "High"
				ls_Temp = "FF0000'>" + ls_Temp
		End Choose
		ls_Body += "<span style='color:#" + ls_Temp + "</span></td></tr>"
		ls_Body += "<tr><td colspan='2'><b>Inspector's Comments</b><br/>" + ln_Str.of_HTMLEncode(lds_Insp.GetItemString(li_Mgmt,"InspComm")) + "</td></tr>"
		ls_Body += "<tr><td colspan='2'><b>Vessel's Initial Comments</b><br/>" + ln_Str.of_HTMLEncode(_GetVesselInitialComments(lds_Insp.GetItemNumber(li_Mgmt,"Item_ID"))) + "</td></tr>"
		ls_Body += "<tr><td colspan='2'><br/><hr/></td></tr>"
	Next
	ls_Body += "</table></div>"
End If
Destroy lds_Insp

// Conclude email
ls_Body += "<br/><br/>Best Regards,<br/>VIMS"
ls_Body += "<br/><br/><small>" + is_EmailFooter + "</small></body></html>"

// Run loop and add emails of all management users
li_Obs = lds_Users.RowCount()
lnvo_Mail = Create mt_n_outgoingmail
For li_Mgmt = 1 to lds_Users.RowCount()
	If li_Mgmt=1 Then
		lnvo_Mail.of_Createmail("tramosmt@maersk.com", "VIMS", lds_Users.GetItemString(li_Mgmt, "UserEmail"),lds_Users.GetItemString(li_Mgmt, "FullName"), ls_Sub, ls_Body, ls_Err)
		lnvo_Mail.of_SetCreator("JAU010", ls_Err)	
	Else
		lnvo_Mail.of_AddReceiver(lds_Users.GetItemString(li_Mgmt, "UserEmail"), lds_Users.GetItemString(li_Mgmt, "FullName"), ls_Err)
	End If
	ls_Users += lds_Users.GetItemString(li_Mgmt, "FullName") + ", "
	ls_Emails += lds_Users.GetItemString(li_Mgmt, "UserEmail") + "; "
Next
// Add email of department of vetting super
If Not IsNull(ls_Super) then
	Select DEPTNAME, DEPTNOTE into :ls_Temp, :ls_Super From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Super;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Super, ls_Temp, ls_Err)
	ls_Users += ls_Temp + ", "
	ls_Emails += ls_Super + "; "
	li_Obs++
End If
// Add email of department of tech super
If Not IsNull(ls_Tech) then
	Select DEPTNAME, DEPTNOTE into :ls_Temp, :ls_Tech From USERS Inner Join VETT_DEPT On USERS.VETT_DEPT=VETT_DEPT.DEPT_ID Where USERID=:ls_Tech;
	Commit;
	lnvo_Mail.of_AddReceiver(ls_Tech, ls_Temp, ls_Err)
	ls_Users += ls_Temp + ", "
	ls_Emails += ls_Tech + "; "	
	li_Obs++
End If
// Add Vessel email
If Not IsNull(ls_VslEmail) and ls_VslEmail>"" then
	ls_VslEmail = of_CheckAutomailEmail(ls_VslEmail)
	lnvo_Mail.of_AddReceiver(ls_VslEmail, ls_Vessel, ls_Err)
	ls_Users += ls_Vessel + ", "
   ls_Emails += ls_VslEmail + "; "	
	li_Obs++
End If

// Send email
If lnvo_Mail.of_SendMail(ls_Err) = 1 then 
		If Len(ls_Users)>0 then
			ls_Users = Left(ls_Users, Len(ls_Users) - 2)  // Remove last comma
			ls_Emails = Left(ls_Emails, Len(ls_Emails) - 2)  // Remove last comma
			ls_Users = "MIRE Management Notification sent to: " + ls_Users
		End If

		of_LogEmail(ls_Emails, ls_Sub, ls_Body)
		
		Update VETT_INSP Set MGMT_REVIEW = 1 Where INSP_ID = :al_InspID;
  		of_AddInspHist(al_InspID, 22, ls_Users)   	
  		Commit;
Else
	li_Obs=0
End If

Return li_Obs
end function

on uo_global.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_global.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

