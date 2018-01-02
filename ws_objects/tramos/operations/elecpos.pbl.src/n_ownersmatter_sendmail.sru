$PBExportHeader$n_ownersmatter_sendmail.sru
forward
global type n_ownersmatter_sendmail from mt_n_nonvisualobject
end type
end forward

global type n_ownersmatter_sendmail from mt_n_nonvisualobject
end type
global n_ownersmatter_sendmail n_ownersmatter_sendmail

type variables


end variables

forward prototypes
public function string of_get_emailsubject (long al_vesselnr, string as_voyagenr, string as_portcode)
public function string of_get_emailbody (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn)
public function integer of_send_email (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn)
public subroutine documentation ()
public function string of_get_emailfrom ()
public subroutine of_get_emailto (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn, ref string as_mailto_list[])
end prototypes

public function string of_get_emailsubject (long al_vesselnr, string as_voyagenr, string as_portcode);/********************************************************************
   of_get_emailsubject
   <OBJECT>		Get email subject	</OBJECT>
   <USAGE>		When send email			</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	30/12/2013	CR3085		WWG004		First Version
   </HISTORY>
********************************************************************/

string ls_subject, ls_vesselrefnr, ls_vesselname, ls_portname

SELECT VESSEL_REF_NR, VESSEL_NAME 
  INTO :ls_vesselrefnr, :ls_vesselname
  FROM VESSELS
 WHERE VESSEL_NR = :al_vesselnr;
 
SELECT PORT_N INTO :ls_portname FROM PORTS WHERE PORT_CODE = :as_portcode;
 
ls_subject	= "Port cancelled : " + ls_vesselrefnr + " " + ls_vesselname +  " - " + as_voyagenr + " - " + ls_portname

return ls_subject
end function

public function string of_get_emailbody (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn);/********************************************************************
   of_get_emailbody
   <OBJECT>		Get email body	</OBJECT>
   <USAGE>		When send email			</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	30/12/2013	CR3085		WWG004		First Version
   </HISTORY>
********************************************************************/

string	ls_body, ls_resp_psm, ls_agentdetail, ls_departname, ls_contact1, ls_contact2
long		ll_departmentid, ll_row

mt_n_datastore lds_department_list

lds_department_list = CREATE mt_n_datastore

ls_body = "Please find enclosed information from owners matters activities in the cancelled port:"

SELECT RESPONSIBLE_PSM, AGENT_DETAILS, OWNER_DEPARTMENT_ID
  INTO :ls_resp_psm, :ls_agentdetail, :ll_departmentid
  FROM OWNER_MATTERS_DEPARTMENT
 WHERE VESSEL_NR = :al_vesselnr
	AND VOYAGE_NR = :as_voyagenr
	AND PORT_CODE = :as_portcode
	AND PCN = :ai_pcn;

if not isnull(ls_resp_psm) then ls_body += "Responsible PSM:" + ls_resp_psm + '~r~n'
if not isnull(ls_agentdetail) then ls_body += "Agent Details" + "~r~n" + ls_agentdetail + '~r~n'

lds_department_list.dataobject = "d_sq_ff_department_list"
lds_department_list.settransobject(sqlca)
lds_department_list.retrieve(ll_departmentid)

if lds_department_list.rowcount() > 0 then
	for ll_row = 1 to lds_department_list.rowcount()
		ls_departname	= lds_department_list.getitemstring(ll_row, "department_name")
		ls_contact1		= lds_department_list.getitemstring(ll_row, "contact1")
		ls_contact2		= lds_department_list.getitemstring(ll_row, "contact2")
		
		if not isnull(ls_departname) then ls_body += ls_departname + ":"
		if not isnull(ls_contact1) then ls_body += ls_contact1
		if not isnull(ls_contact2) then ls_body += " " + ls_contact2 + '~r~n'
	next
end if

return ls_body
end function

public function integer of_send_email (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn);/********************************************************************
   of_sent_email
   <DESC>	Sent email</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>POC/POC_EST Delete button</USAGE>
   <HISTORY>
		Date      	CR-Ref   	Author		Comments
		19/12/2013	CR3085		WWG004		First Version
		09/06/2014	CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report.
		20/06/2014	CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report.
		22/07/2015	CR4116		LHG008		Due to SMTP server email size limitation, the entire email size cannot exceed 14MB; Fix bug for file database archiving
   </HISTORY>
********************************************************************/

string  ls_emailfrom, ls_subject, ls_temp_subject, ls_body, ls_errormessage, ls_filename, ls_emailto_list[]
long    ll_row, ll_bytes, ll_totalbytes, ll_file_id[], ll_find, ll_fileid
long    ll_filecount, ll_emailcount, ll_rowcount, ll_count
integer li_return, li_upper
string  ls_temp_body

n_object_usage_log   use_log
n_service_manager    lnv_servicemgr
n_fileattach_service	lnv_attservice
mt_n_outgoingmail		lnv_mail
mt_n_datastore       lds_matter_doc
str_filecontent      lstr_attcontent[]

of_get_emailto(al_vesselnr, as_voyagenr, as_portcode, ai_pcn, ls_emailto_list)

if isnull(ls_emailto_list) or upperbound(ls_emailto_list) < 1 then
	return c#return.Failure
end if

ll_emailcount = 1

lds_matter_doc = CREATE mt_n_datastore

lds_matter_doc.dataobject = "d_sq_gr_ownermatter_doc"
lds_matter_doc.settransobject(sqlca)
ll_filecount = lds_matter_doc.retrieve(al_vesselnr, as_portcode, ai_pcn, long(as_voyagenr))

if ll_filecount > 0 then
	ll_file_id  = lds_matter_doc.object.file_id.primary
	
	lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")
	lnv_attservice.of_readfiles("OWNERS_MATTERS_DOCUMENT_FILES", ll_file_id, lstr_attcontent)
	
	for ll_count = 1 to upperbound(lstr_attcontent)
		ll_bytes = len(lstr_attcontent[ll_count].ibl_filecontent)
		
		//Check the file size is greater than the maximum size of the mail attachments
		if ll_bytes > c#email.il_ATT_MAXSIZE then
			if len(ls_temp_body) = 0 then	ls_temp_body = "The following attchment(s) cannot received because the file size is too large."
			
			ll_fileid = lstr_attcontent[ll_count].il_fileid
			ll_find = lds_matter_doc.find("file_id = " + string(ll_fileid), 1, ll_filecount)
			if ll_find > 0 then
				ls_filename = lds_matter_doc.getitemstring(ll_find, "file_name")
				lds_matter_doc.deleterow(ll_find)
				ll_filecount --
			end if
			ls_temp_body += '~r~n' + ls_filename
			lnv_attservice.of_delete("OWNERS_MATTERS_DOCUMENT_FILES", ll_fileid)
			continue
		end if
		
		ll_totalbytes = ll_totalbytes + ll_bytes
		if ll_totalbytes > c#email.il_ATT_MAXSIZE then
			ll_emailcount ++
			ll_totalbytes = ll_bytes
		end if
		
		lstr_attcontent[ll_count].is_comment = string(ll_emailcount)
	next
end if

ls_emailfrom    = of_get_emailfrom()
ls_temp_subject = of_get_emailsubject(al_vesselnr, as_voyagenr, as_portcode)
ls_body         = of_get_emailbody(al_vesselnr, as_voyagenr, as_portcode, ai_pcn)
ls_subject      = ls_temp_subject

for ll_row = 1 to ll_emailcount
	if ll_emailcount > 1 then ls_subject = ls_temp_subject + " email " + string(ll_row) + " of " + string(ll_emailcount)
	if len(ls_temp_body) > 0 and ll_row = ll_emailcount then ls_body += "~r~n~r~n" + ls_temp_body
	
	lnv_mail	= CREATE mt_n_outgoingmail
	if lnv_mail.of_createmail(ls_emailfrom, ls_emailto_list[1], ls_subject, ls_body, ls_errormessage) = -1 then	
		li_return = c#return.Failure
		exit
	end if
	
	if upperbound(ls_emailto_list) > 1 then
		for li_upper = 2 to upperbound(ls_emailto_list)
			li_return = lnv_mail.of_addreceiver(ls_emailto_list[li_upper], ls_errormessage)
			if li_return = c#return.Failure then exit
		next
		if li_return = c#return.Failure then exit
	end if
	
	if lnv_mail.of_setcreator(uo_global.is_userid, ls_errormessage) = -1 then
		li_return = c#return.Failure
		exit
	end if
	
	for ll_count = 1 to upperbound(lstr_attcontent)
		if long(lstr_attcontent[ll_count].is_comment) = ll_row then
			ll_fileid = lstr_attcontent[ll_count].il_fileid
			ll_bytes = len(lstr_attcontent[ll_count].ibl_filecontent)
			
			ll_find = lds_matter_doc.find("file_id = " + string(ll_fileid), 1, ll_filecount)
			if ll_find > 0 then ls_filename = lds_matter_doc.getitemstring(ll_find, "file_name")
			
			lnv_mail.of_addattachment(lstr_attcontent[ll_count].ibl_filecontent, ls_filename, ll_bytes, ls_errormessage)
			
			lnv_attservice.of_delete("OWNERS_MATTERS_DOCUMENT_FILES", ll_fileid)
		end if
	next
	
	if lnv_mail.of_sendmail(ls_errorMessage) <> -1 then
		destroy lnv_mail
		li_return = c#return.success
	else
		li_return = c#return.Failure
		exit
	end if
next

//Delete attachment
lds_matter_doc.rowsmove(1, lds_matter_doc.rowcount(), Primary!, lds_matter_doc, 1, Delete!)
lds_matter_doc.update()

use_log.uf_log_object("POC - Delete Port")

destroy lds_matter_doc
destroy lnv_mail

return li_return

end function

public subroutine documentation ();/********************************************************************
   n_ownersmatter_sendmail
   <OBJECT>		Send email UO	</OBJECT>
   <USAGE>		When delete a port			</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		30/12/2013	CR3085		WWG004		First Version
		09/06/2014	CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report.
		20/06/2014	CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report.
		22/07/2015	CR4116		LHG008		Due to SMTP server email size limitation, the entire email size cannot exceed 14MB
		30/03/2016	CR4316		AGL027		Obtain email address of finance responsible from database instead of using constant.
		
   </HISTORY>
********************************************************************/
end subroutine

public function string of_get_emailfrom ();/********************************************************************
   of_get_emailfrom
   <OBJECT>		Get email from address	</OBJECT>
   <USAGE>		When send email			</USAGE>
   <ALSO>					</ALSO>
   <HISTORY>
   	Date			CR-Ref		Author		Comments
   	30/12/2013	CR3085		WWG004		First Version
		30/03/2016	CR4316		AGL027		Use AD reference for email address instead of constant domain string
   </HISTORY>
********************************************************************/
string ls_emailaddress=""
mt_n_activedirectoryfunctions lnv_adfunc

ls_emailaddress = lnv_adfunc.of_get_email_by_userid_from_db(uo_global.is_userid)
if ls_emailaddress = "" then ls_emailaddress = uo_global.is_userid + c#email.DOMAIN
return ls_emailaddress

end function

public subroutine of_get_emailto (long al_vesselnr, string as_voyagenr, string as_portcode, integer ai_pcn, ref string as_mailto_list[]);/********************************************************************
   of_get_emailto
   <DESC>get the email address from offices PSM</DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
			al_vesselnr	     long
			as_voyagenr	     string
			as_portcode	     string
			ai_pcn		     integer
			as_mailto_list[] string
   </ARGS>
   <USAGE>	When sent a email.	</USAGE>
   <HISTORY>
		Date      	CR-Ref		Author		Comments
		20/12/2013	CR3085		WWG004		First Version
		20/06/2014	CR3085UAT	XSZ004		Fix bug based on 28.01.0 UAT defect report.
   </HISTORY>
********************************************************************/
string  ls_emailaddress, ls_office_psm, ls_resp_psm, ls_message, ls_office_emailto[]
integer li_officenr, li_upper

mt_n_outgoingmail    lnv_mail
mt_n_stringfunctions lnv_stringfunctions
mt_n_activedirectoryfunctions	lnv_adfunc

//Get responsbile PSM's email
SELECT RESPONSIBLE_PSM INTO :ls_resp_psm FROM OWNER_MATTERS_DEPARTMENT
 WHERE VESSEL_NR = :al_vesselnr AND VOYAGE_NR = :as_voyagenr
   AND PORT_CODE = :as_portcode AND PCN = :ai_pcn;

if len(trim(ls_resp_psm)) > 0 then
	
	SELECT OFFICE_NR INTO :li_officenr FROM USERS WHERE USERID = :ls_resp_psm;	
	
	ls_emailaddress = lnv_adfunc.of_get_email_by_userid_from_db(ls_resp_psm)
	if ls_emailaddress = "" then
		ls_emailaddress = ls_resp_psm + c#email.DOMAIN
	end if
	
	//Get responsible PSM's office's email
	if li_officenr > 0 or not isnull(string(li_officenr)) then
		
		SELECT EMAIL_ADR_PSM INTO :ls_office_psm FROM OFFICES WHERE OFFICE_NR = :li_officenr;
		
		if not isnull(ls_office_psm) then 		
			lnv_mail = CREATE mt_n_outgoingmail
			lnv_stringfunctions.of_parsetoarray(ls_office_psm, ";", ls_office_emailto)
			
			for li_upper = 1 to upperbound(ls_office_emailto)
				if lnv_mail.of_verifyreceiveraddress(ls_office_emailto[li_upper], ls_message) = c#return.Success then 
					ls_emailaddress += ';' + ls_office_emailto[li_upper]
				end if
			next		
		end if
	end if
	lnv_stringfunctions.of_parsetoarray(ls_emailaddress, ";", as_mailto_list)
end if

destroy lnv_mail
end subroutine

on n_ownersmatter_sendmail.create
call super::create
end on

on n_ownersmatter_sendmail.destroy
call super::destroy
end on

