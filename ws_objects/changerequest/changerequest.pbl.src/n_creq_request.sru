$PBExportHeader$n_creq_request.sru
forward
global type n_creq_request from mt_n_nonvisualobject
end type
end forward

global type n_creq_request from mt_n_nonvisualobject
end type
global n_creq_request n_creq_request

type prototypes
function ulong gettemppath(ulong nbufferlength, ref string lpbuffer) library "kernel32" alias for GetTempPathW
end prototypes

type variables
constant long il_QUEUED_STATUS = 14			//Queued
constant long il_BU_REVIEWED_STATUS = 32	//Business Reviewed
constant long li_ESTIMATED_STATUS = 2		//Estimated
constant long li_ASSIGNED_STATUS = 3		//Assigned
constant long il_BU_APPROVED_STATUS = 5 	//Business Approved
constant long il_RELEASED_STATUS = 6 		//Released
constant string is_IMPL_COL = 'impl_seq'
constant string is_PRIO_COL = 'bu_seq'

long il_initial_statusid  //initial status id
string is_initial_statusname //initial status name
integer ii_mailindex, ii_mailcount

s_parm_request istr_parm
mt_n_datastore ids_libraries

boolean ib_isusing, ib_printrequest
datetime ib_attupdatetime
string is_attfailedmsg
end variables

forward prototypes
public subroutine documentation ()
public function string of_find_libraryname (string as_objectname)
public function integer of_sendmail (string as_creator, string as_from, string as_to[], string as_subject, string as_body, string as_filespath[])
public function integer of_modify_seq (long al_requestid, string as_colname, long al_newseq)
private function integer _setsequence (mt_n_datastore ads_creqseq, long al_requestid, long al_status, boolean ab_addseq)
private function integer _setsequence (mt_n_datastore ads_creqseq, long al_requestid, long al_status, boolean ab_addseq, long al_newseq)
public function integer of_autosendmail (mt_u_datawindow adw_request)
public function integer of_filterstatus (mt_u_datawindow adw_request)
public function integer of_logdescriptionchange (ref mt_u_datawindow adw)
public function integer of_order_seq (mt_u_datawindow adw_creqdetail)
public function integer of_typecontrol (mt_u_datawindow adw_request)
public function integer of_update (ref mt_u_datawindow adw)
public function integer of_validate (ref mt_u_datawindow adw)
public function integer of_sendmail (string as_creator, string as_from, string as_to[], string as_subject, string as_body, blob abl_filecontent[], string as_filename[])
public function integer of_mailtosupport (long al_requestid, string as_email_address, boolean ab_fullmail)
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC>	Change request validation component	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	26-08-2011 	CR2438      JMY014             First Version
		23-08-2012 	CR2917		AGL027				 Remove complex logic filtering error CR's to top of queue
		01-21-2013 	CR2614      LHG008       		 Change validity rule, implementation/priority rank, Send email
		15/05/2013 	CR2690		LGX001				1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
																2.change "@maersk.com" 			 as C#EMAIL.DOMAIN 
		10/07/2013 	CR3254		LHG008				1. Call dw validator service
																2. Add function of_modify_seq() and overloaded function _setsequence() to fix bug for change impl./prio.
		23/08/2013 	CR3287      ZSW001            Remove the Prioritisation Rank and Implementation Rank from the auto-emails sent when CRs are set to 
		                                          statuses Business Reviewed or Queued.
		30/08/2013 	CR3147      ZSW001            In the report generated from the Change request module we should have "release date" included next to "release version". 
		                                          Equally we should have a "created date" next to the "Created by".
		04/11/2013 	CR3254      LHG008            valid the input 'Estiamated' content 	
		07/05/2014 	CR3689      LHG008            Update lds_creqseq in function _setsequence()
		11/06/2015 	CR4041      LHG008            Change logic in sending email to support team. Overloaded function of_sendmail()
		20/07/2015 	CR4116      LHG008            Due to SMTP server email size limitation, the entire email size cannot exceed 14MB
		04/03/2016 	CR4316		AGL027				Obtain email address of tramos users from database that has AD value stored inside it.
		05/09/2016 	CR3754		AGL027				Single Sign On modifications - support Become User feature

   </HISTORY>
********************************************************************/
end subroutine

public function string of_find_libraryname (string as_objectname);/********************************************************************
   of_find_libraryname
   <DESC>	Find library name for object	</DESC>
   <RETURN>	string: library name
            <LI> > '' ok
            <LI> = '' failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_objectname: name.type (eg. n_creq_request.srn)
   </ARGS>
   <USAGE>	Ref:w_modify_changerequest.wf_insert_taskobject()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		23/05/2013	CR2614	LHG008	First Version
		09/07/2013	CR3254	LHG008	Merge n_string_service into mt_n_stringfunctions
   </HISTORY>
********************************************************************/

long ll_count, ll_row, ll_rowcount, ll_find
string ls_objectname, ls_libraries, ls_libraryarray[], ls_entries, ls_libraryname
mt_n_stringfunctions lnv_string

//Exclude file type
ls_objectname = left(as_objectname, len(as_objectname) - 4)

if isnull(ls_objectname) or trim(ls_objectname) = '' then return ''

if not isvalid(ids_libraries) then
	//Initialize object list.
	ids_libraries = create mt_n_datastore
	ids_libraries.dataobject = "d_ex_gr_libraries"
	
	ls_libraries = getlibrarylist()
	lnv_string.of_parsetoarray(ls_libraries, ',', ls_libraryarray)
	for ll_count = 1 to upperbound(ls_libraryarray)
		ls_libraryname = ls_libraryarray[ll_count]
		ls_entries = librarydirectory(ls_libraryname, dirall!)
		
		ll_rowcount = ids_libraries.rowcount()
		ids_libraries.importstring(ls_entries)
		
		ls_libraryname = mid(ls_libraryname, lastpos(ls_libraryname, '\') + 1)
		for ll_row = ll_rowcount + 1 to ids_libraries.rowcount()
			ids_libraries.setitem(ll_row, 'objectlibrary', ls_libraryname)
		next
	next
end if

//Find library
ll_find = ids_libraries.find("objectname = '" + ls_objectname + "'", 1, ids_libraries.rowcount())
if ll_find > 0 then
	ls_libraryname = ids_libraries.getitemstring(ll_find, "objectlibrary")
	ls_libraryname = left(ls_libraryname, len(ls_libraryname) - 4) + ".pbl"
end if

return ls_libraryname
end function

public function integer of_sendmail (string as_creator, string as_from, string as_to[], string as_subject, string as_body, string as_filespath[]);/********************************************************************
   of_sentmail
   <DESC>	Send Email	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_creator: Email creator
		as_from: Email from
		as_to[]: Email sent to
		as_subject: Email subject
		as_body: Email body
   </ARGS>
   <USAGE>	ref: 	of_autosendmail(); u_creq_email.ue_sendmail()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		16/01/2013	CR2614	LHG008	First Version
		10/07/2013	CR3254	LHG008	Fix bug when file not exists
		08/06/2015 	CR4041	LHG008	Overloaded function
   </HISTORY>
********************************************************************/

integer li_index, li_fnum
long ll_bytes
blob lbl_filecontent[]
string ls_filename[]

for li_index = 1 to upperbound(as_filespath)
	if not fileexists(as_filespath[li_index]) then continue
	
	//Obtain blob
	li_fnum = fileopen(as_filespath[li_index], StreamMode!, Read!, Shared!)
	ll_bytes = filereadex(li_fnum, lbl_filecontent[li_index])
	fileclose(li_fnum)
	
	//Get file name
	ls_filename[li_index] = mid(as_filespath[li_index], lastpos(as_filespath[li_index], "\") + 1)
next

return of_sendmail(as_creator, as_from, as_to, as_subject, as_body, lbl_filecontent, ls_filename)

end function

public function integer of_modify_seq (long al_requestid, string as_colname, long al_newseq);/********************************************************************
   of_modify_seq
   <DESC>	Modify Implementation Rank and Priority Rank	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		al_requestid
		as_colname
		al_newseq
   </ARGS>
   <USAGE>	call in dw_list.itemchanged event in the w_changerequest	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		15/07/2013	CR3254	LHG008	First Version
		07/05/2014	CR3689	LHG008	Update lds_creqseq in function _setsequence()
   </HISTORY>
********************************************************************/

mt_n_datastore lds_creqseq
Integer li_return
string ls_error

if isnull(al_newseq) then return c#return.Failure

li_return = c#return.Success

// Initialize objects. It is used for setting order to implementation/priority column
lds_creqseq = create mt_n_datastore
lds_creqseq.dataobject = "d_sq_gr_creq_seq"
lds_creqseq.setTransObject(sqlca)

choose case as_colname 
	case is_IMPL_COL	//Implementation Rank
		li_return = _setsequence(lds_creqseq, al_requestid, il_QUEUED_STATUS, false, al_newseq)
	case is_PRIO_COL	//Priority Rank
		li_return = _setsequence(lds_creqseq, al_requestid, il_BU_REVIEWED_STATUS, false, al_newseq)
end choose

destroy lds_creqseq
return li_return

end function

private function integer _setsequence (mt_n_datastore ads_creqseq, long al_requestid, long al_status, boolean ab_addseq);/********************************************************************
   _setsequence( )
   <DESC>Retrieve and sort data then set sequence numbers </DESC>
   <RETURN> Integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		ads_creqseq:  The datastore is going to be processed
		al_requestid: Request id
		al_status: Current status
		ab_addseq: Whether add sequence numbers or not(if true then Set to Max sequence number + 1)
	</ARGS>
   <USAGE> Call by of_order_seq() </USAGE>
  <HISTORY>
   	Date       CR-Ref       Author             Comments
   	01-17-2013 CR2614      	LHG008        		First Version
   	15/07/2013 CR3254      	LHG008        		Overloaded function
   </HISTORY>
********************************************************************/

long ll_newseq

setnull(ll_newseq) //if ab_addseq = true then set to Max sequence number + 1, else clear sequence number
return _setsequence(ads_creqseq, al_requestid, al_status, ab_addseq, ll_newseq)
end function

private function integer _setsequence (mt_n_datastore ads_creqseq, long al_requestid, long al_status, boolean ab_addseq, long al_newseq);/********************************************************************
   _setsequence()
   <DESC>Retrieve and sort data then set sequence numbers </DESC>
   <RETURN> Integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Private </ACCESS>
   <ARGS>
		ads_creqseq:  The datastore is going to be processed
		al_requestid: Request id
		al_status: Current status
		ab_addseq: Whether add sequence numbers or not(if true then ignore al_newseq)
		al_newseq: new sequence number
	</ARGS>
   <USAGE> Call by _setsequence(), of_modify_seq() </USAGE>
  <HISTORY>
   	Date			CR-Ref		Author		Comments
   	15/07/2013	CR3254		LHG008		First Version
   	07/05/2014	CR3689		LHG008		Update datastore after set sequence numbers
   </HISTORY>
********************************************************************/

long ll_rowcount, ll_row, ll_newseq
string ls_sort, ls_colname
integer li_return
n_service_manager lnv_servicemgr
n_sequence_service lnv_seq

lnv_servicemgr.of_loadservice(lnv_seq, "n_sequence_service")

//Retrieve and sort data
ads_creqseq.retrieve(al_requestid, al_status)

if al_status = il_QUEUED_STATUS then
	ls_colname = is_IMPL_COL
	ls_sort = is_IMPL_COL + " A, request_id A"
else
	ls_colname = is_PRIO_COL
	ls_sort = is_PRIO_COL + " A, request_id A"
end if

ads_creqseq.setsort(ls_sort)
ads_creqseq.sort()

ll_rowcount = ads_creqseq.rowcount()
ll_row = ads_creqseq.find('request_id = ' + string(al_requestid), 1, ll_rowcount)

if ll_row > 0 then
	if ab_addseq then
		//Set to Max sequence number + 1
		ll_newseq = long(ads_creqseq.describe("evaluate('max(" + ls_colname + " for all)', 0)")) + 1
		ads_creqseq.setitem(ll_row, ls_colname, ll_newseq)
		li_return = c#return.Success
	else
		//Set to new sequence number or clear sequence number(if al_newseq is null)
		li_return = lnv_seq.of_setsequence(ads_creqseq, ls_colname, ll_row, al_newseq)
	end if
else
	li_return = c#return.Failure
end if

if li_return = c#return.Success then
	if ads_creqseq.Update() = 1 then
		COMMIT;
	else	//Failure
		ROLLBACK;
		li_return = c#return.Failure
	end if
end if

return li_return
end function

public function integer of_autosendmail (mt_u_datawindow adw_request);/********************************************************************
   of_autosendmail
   <DESC>	Send Email automatically when status changed	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		adw_request:
   </ARGS>
   <USAGE>	ref: of_update()	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-16-2013	CR2614	LHG008	First Version
		10/07/2013	CR3254	LHG008	Change logic in sending email to support team
		11/06/2015	CR4041	LHG008	Change logic in sending email to support team, Add attachments from CR to mail
		04/03/2016	CR4316	AGL027	Obtain email address of tramos users from db instead of static value.
   </HISTORY>
********************************************************************/

long ll_requestid, ll_statusid, ll_found
string ls_release_version, ls_owner, ls_email_address, ls_sendmail_status, ls_assigned_to, ls_type
string ls_from, ls_to, ls_subject, ls_body, ls_filespath[]
integer li_return = c#return.NoAction
boolean lb_fullmail, lb_mailtosupport
datawindowchild ldwc_status
mt_u_datawindow ldw_att
mt_n_activedirectoryfunctions	lnv_adfunc

constant string ls_DELIMITER = ","

ll_requestid = adw_request.getitemnumber(1, "request_id")
if isnull(ll_requestid) then
	return li_return
end if

ll_statusid = adw_request.getitemnumber(1, 'status_id')

//If CR assigned then Set dev_status to new
if ll_statusid = li_ASSIGNED_STATUS then
	if isnull(adw_request.getitemnumber(1, "dev_status")) then
		adw_request.setitem(1, "dev_status", 1)
		
		if isvalid(w_modify_changerequest) then
			w_modify_changerequest.tab_request.tabpage_task.dw_task.setitem(1, "dev_status", 1)
			w_modify_changerequest.tab_request.tabpage_task.dw_task.setitemstatus( 1, "dev_status", primary!, notmodified!)
		end if
	end if
end if

//If needed send email to support.
if isvalid(w_modify_changerequest) then
	ls_assigned_to = adw_request.getitemstring(1, 'assigned_to')
	
	//Get email address and send status
	SELECT EMAIL, SENDMAIL_STATUS
	  INTO :ls_email_address, :ls_sendmail_status
	  FROM CREQ_CONSULTANT
	 WHERE LOWER(NAME) = LOWER(:ls_assigned_to);
	
	if right(ls_sendmail_status, 1) <> ls_DELIMITER and not isnull(ls_sendmail_status) then ls_sendmail_status = ls_sendmail_status + ls_DELIMITER
	
	if len(trim(ls_email_address)) > 0 and len(trim(ls_sendmail_status)) > 0 and pos(ls_sendmail_status, string(ll_statusid) + ls_DELIMITER) > 0 then
		
		//If set assigned_to and status_id is the first seting in the CREQ_CONSULTANT.SENDMAIL_STATUS, then send full mail
		if (ls_assigned_to <> adw_request.getitemstring(1, 'assigned_to', primary!, true) or isnull(adw_request.getitemstring(1, 'assigned_to', primary!, true))) &
			and ll_statusid <> adw_request.getitemnumber(1, 'status_id', primary!, true) &
			and mid(ls_sendmail_status, 1, pos(ls_sendmail_status, ls_DELIMITER) - 1) = string(ll_statusid) then
			
			lb_fullmail = true
			lb_mailtosupport = true
		end if
		
		//If not send full mail, then only send modified entries
		if not lb_fullmail then
			if adw_request.getitemstatus(1, 0, primary!) = datamodified! then
				ib_printrequest = true
				lb_mailtosupport = true
			end if
			
			ib_attupdatetime = datetime(today(), now())
			ldw_att = w_modify_changerequest.tab_request.tabpage_details.uo_att.dw_file_listing
			
			for ll_found = 1 to ldw_att.rowcount()
				if ldw_att.getitemstatus(ll_found, "file_updated_date", primary!) = datamodified! &
					and ib_attupdatetime > ldw_att.getitemdatetime(ll_found, "file_updated_date") then
					ib_attupdatetime = ldw_att.getitemdatetime(ll_found, "file_updated_date")
					lb_mailtosupport = true
				end if
			next
		end if
		
		//Send mail after data have updated.
		if lb_mailtosupport then
			ib_isusing = true
			post of_mailtosupport(ll_requestid, ls_email_address, lb_fullmail)
		end if
	end if
end if

//Auto send mail to owner
if adw_request.getitemstatus(1, "status_id", primary!) = datamodified! then
	if ll_statusid = adw_request.getitemnumber(1, 'status_id', primary!, true) then return li_return
	
	choose case ll_statusid
		case il_BU_REVIEWED_STATUS
			if adw_request.getitemnumber(1, 'is_sentmail') = 1 then //already sent email
				return c#return.NoAction
			end if
		case il_BU_APPROVED_STATUS, il_RELEASED_STATUS //Including release number
			ls_release_version = adw_request.getitemstring(1, 'release_version')
			if isnull(ls_release_version) then ls_release_version = ''
			ls_subject = ', Release Version: ' + ls_release_version
			
		case else
			//
	end choose

	if adw_request.getchild('status_id', ldwc_status) = 1 then
		ll_found = ldwc_status.find('status_id = ' + string(ll_statusid), 1, ldwc_status.rowcount())
		if ll_found > 0 then
			if ldwc_status.getitemnumber(ll_found, 'is_auto_sentmail') = 1 then //check whether need sent email or not
				ls_owner = adw_request.getitemstring(1, "owner")
				ls_from = C#EMAIL.TRAMOSSUPPORT
				ls_to = lnv_adfunc.of_get_email_by_userid_from_db(ls_owner)
				ls_subject = "Tramos Change Request "+string(ll_requestid) &
								+ " - Status changed to " +string(ldwc_status.getitemstring(ll_found, "status_description")) + ls_subject
								
				ls_body = "Your above change request has been changed. Please see an excerpt of the description below:~r~n~r~n" &
								+ adw_request.getitemstring(1, "problem_desc")
				
				li_return = of_sendmail(ls_owner, ls_from, {ls_to}, ls_subject, ls_body, ls_filespath)
				if li_return = c#return.Success then
					adw_request.setitem(1, 'is_sentmail', 1)
				end if
			end if
		else //Not found
			li_return = c#return.NoAction
		end if
	else //Failed to get child datawindow
		 li_return = c#return.Failure
	end if
end if

return li_return
end function

public function integer of_filterstatus (mt_u_datawindow adw_request);/********************************************************************
   of_filterstatus
   <DESC>	Filter status	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		adw_request:
   </ARGS>
   <USAGE> call by below event:
		w_modify_changerequest.open()
		tab_request.tabpage_details.dw_request.itemchanged()
	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-10-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

datawindowchild ldwc_child
mt_n_datastore lds_typestatus
long ll_currentrow, ll_origtypeid, ll_typeid, ll_status, ll_findrow
string ls_nextstatus, ls_bu_accessstatus, ls_filter

if adw_request.getchild('status_id', ldwc_child) < 0 then return c#return.Failure

ll_currentrow = adw_request.getrow()
ll_typeid = adw_request.getitemnumber(ll_currentrow, 'type_id')
ll_status = adw_request.getitemnumber(ll_currentrow, 'status_id')

ll_origtypeid = adw_request.getitemnumber(ll_currentrow, 'type_id', primary!, true)
if ll_typeid <> ll_origtypeid and not isnull(ll_origtypeid) then
	ll_status = il_initial_statusid
	adw_request.setitem(ll_currentrow, 'status_id', il_initial_statusid)
end if

//Always include current status
ls_filter = 'status_id = ' + string(ll_status)

if lower(istr_parm.operation) <> 'new' then
	//Get the intersection of business access status and next access status
	ls_bu_accessstatus = istr_parm.bu_accessstatus
	lds_typestatus = istr_parm.ds_typestatus

	ll_findrow = lds_typestatus.find('type_id = ' + string(ll_typeid) + ' and status_id = ' + string(ll_status), 1, lds_typestatus.rowcount())
	if ll_findrow > 0 then
		ls_nextstatus = lds_typestatus.getitemstring(ll_findrow, 'next_status')
		
		if len(trim(ls_nextstatus)) > 0 and len(trim(ls_bu_accessstatus)) > 0 then
			ls_filter += ' or (status_id in(' + ls_bu_accessstatus + ') and status_id in(' + ls_nextstatus + '))'
		end if
	end if
end if

ldwc_child.setfilter(ls_filter)
ldwc_child.filter()

return c#return.Success

end function

public function integer of_logdescriptionchange (ref mt_u_datawindow adw);/* This function is used to log problem, change and solution descriptions
	as it is not possible to get TEXT field values in trigger */
datastore	lds_log
long			ll_row

if adw.rowcount() <> 0 then
	lds_log = CREATE datastore
	lds_log.dataObject = "d_table_history_log_detail"
	lds_log.settransobject(SQLCA)
	
	if adw.getitemstring(1, "problem_desc", primary!, true) <> adw.getitemstring(1, "problem_desc") then
		ll_row = lds_log.insertrow(0)
		if ll_row < 1 then
			messagebox("Insert Error", "Failure inserting 'problem description' row in function: n_creq_request.of_logDescriptionChange()")
			destroy lds_log
			return -1
		end if
		
		lds_log.setItem(ll_row, "userid", SQLCA.userid) 
		lds_log.setItem(ll_row, "request_id", adw.getitemnumber(1, "request_id")) 
		lds_log.setItem(ll_row, "log_date", today()) 
		lds_log.setItem(ll_row, "log_description", "Problem description changed. See text below.") 
		lds_log.setItem(ll_row, "changed_from", adw.getitemstring(1, "problem_desc", primary!, true)) 
		lds_log.setItem(ll_row, "changed_to", adw.getitemstring(1, "problem_desc")) 
	end if
	
	if adw.getitemstring(1, "change_desc", primary!, true) <> adw.getitemstring(1, "change_desc") then
		ll_row = lds_log.insertrow(0)
		if ll_row < 1 then
			messagebox("Insert Error", "Failure inserting 'change description' row in function: n_creq_request.of_logDescriptionChange()")
			destroy lds_log
			return -1
		end if
		
		lds_log.setItem(ll_row, "userid", SQLCA.userid) 
		lds_log.setItem(ll_row, "request_id", adw.getitemnumber(1, "request_id")) 
		lds_log.setItem(ll_row, "log_date", today()) 
		lds_log.setItem(ll_row, "log_description", "Change description changed. See text below.") 
		lds_log.setItem(ll_row, "changed_from", adw.getitemstring(1, "change_desc", primary!, true)) 
		lds_log.setItem(ll_row, "changed_to", adw.getitemstring(1, "change_desc")) 
	end if
		
	if adw.getitemstring(1, "solution_desc", primary!, true) <> adw.getitemstring(1, "solution_desc") then
		ll_row = lds_log.InsertRow(0)
		if ll_row < 1 then
			messagebox("Insert Error", "Failure inserting 'Solution description' row in function: n_creq_request.of_logDescriptionChange()")
			destroy lds_log
			return -1
		end if
		
		lds_log.setItem(ll_row, "userid", SQLCA.userid) 
		lds_log.setItem(ll_row, "request_id", adw.getitemnumber(1, "request_id")) 
		lds_log.setItem(ll_row, "log_date", today()) 
		lds_log.setItem(ll_row, "log_description", "Solution description changed. See text below.") 
		lds_log.setItem(ll_row, "changed_from", adw.getitemstring(1, "solution_desc", primary!, true)) 
		lds_log.setItem(ll_row, "changed_to", adw.getitemstring(1, "solution_desc")) 
	end if
	
	lds_log.accepttext()
	if lds_log.rowcount() > 0 then
		if lds_log.update() <> 1 then
			messagebox("Update Error", "Failure updating log in function: n_creq_request.of_logDescriptionChange()")
			destroy lds_log
			return -1
		end if
	end if

	destroy lds_log
end if
return 1
end function

public function integer of_order_seq (mt_u_datawindow adw_creqdetail);/********************************************************************
   of_order_seq( )
   <DESC>Set Implementation Rank and Priority Rank to work </DESC>
   <RETURN> Integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		adw_creqdetail
	</ARGS>
   <USAGE> This needs to be called the status change event in the modify window. 
				w_modify_changerequest::tab_request.tabpage_details.cb_update event clicked()
	</USAGE>
	<HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-28-2012 CR2614      	LHG008        		First Version
   	07/05/2014 CR3689      	LHG008        		Update lds_creqseq in function _setsequence()
   </HISTORY>
********************************************************************/

mt_n_datastore lds_creqseq
long ll_requestid, ll_statusid, ll_implseq, ll_buseq, ll_null
Integer li_return
string ls_error

setnull(ll_null)
li_return = c#return.Success

// Initialize objects. It is used for setting order to implementation/priority column
lds_creqseq = create mt_n_datastore
lds_creqseq.dataobject = "d_sq_gr_creq_seq"
lds_creqseq.setTransObject(sqlca)

ll_requestid = adw_creqdetail.getitemnumber(1, "request_id")
ll_statusid = adw_creqdetail.getitemnumber(1, "status_id") 
ll_implseq = adw_creqdetail.getitemnumber(1, is_IMPL_COL) 
ll_buseq = adw_creqdetail.getitemnumber(1, is_PRIO_COL) 

//Implementation Rank
if ll_statusid = il_QUEUED_STATUS and isnull(ll_implseq) then	
	// If status changes to 'Queued', set Implementation Rank to max + 1
	li_return = _setsequence(lds_creqseq, ll_requestid, il_QUEUED_STATUS, true)	
elseif ll_statusid <> il_QUEUED_STATUS and ll_implseq > 0 then
	// If the status is not 'Queued', clear value
	li_return = _setsequence(lds_creqseq, ll_requestid, il_QUEUED_STATUS, false)
end if

//Priority Rank
if li_return = c#return.Success then
	if ll_statusid = il_BU_REVIEWED_STATUS and isnull(ll_buseq) then	
		// If status changes to 'Business Reviewed',set Priority Rank to max + 1
		li_return = _setsequence(lds_creqseq, ll_requestid, il_BU_REVIEWED_STATUS, true)
	elseif ll_statusid <> il_BU_REVIEWED_STATUS and ll_buseq > 0 then	
		// If the status is not 'Business Reviewed', clear value
		li_return = _setsequence(lds_creqseq, ll_requestid, il_BU_REVIEWED_STATUS, false)
	end if
end if

destroy lds_creqseq
return li_return

end function

public function integer of_typecontrol (mt_u_datawindow adw_request);/********************************************************************
   of_typecontrol
   <DESC>	type filter and edit control </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
		adw_request:
   </ARGS>
   <USAGE>	call in w_modify_changerequest.open() event	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-16-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

datawindowchild ldwc_type
string ls_filter
long ll_typeid

if adw_request.getchild("type_id", ldwc_type) = 1 then
	//Filter type
	if isnull(istr_parm.bu_accesstypes) or trim(istr_parm.bu_accesstypes) = '' then istr_parm.bu_accesstypes = '0'
	
	ll_typeid = adw_request.getitemnumber(1, "type_id")
	if isnull(ll_typeid) then
		ls_filter = 'type_id in(' + istr_parm.bu_accesstypes + ')'
	else
		ls_filter = 'type_id in(' + istr_parm.bu_accesstypes + ',' + string(ll_typeid) + ')'
	end if
	
	ldwc_type.setfilter(ls_filter)
	ldwc_type.filter()
	
	//Edit control
	if lower(istr_parm.operation) = 'new' or istr_parm.bu_changetype = 1 then
		adw_request.settaborder("type_id", 10)
	else
		adw_request.settaborder("type_id", 0)
	end if
	return c#return.Success
else
	return c#return.Failure
end if
end function

public function integer of_update (ref mt_u_datawindow adw);string ls_docname
integer li_request_id

if of_validate(adw) = c#return.Success then	
	if of_logdescriptionchange(adw) = 1 then
		of_autosendmail(adw)
		if adw.update() = 1 then
			COMMIT;
			return adw.getitemnumber(1, "request_id")
		else
			ROLLBACK;
			messagebox("Update Error", "Error updating request. Object: n_creq_request, function: of:update()")
			return -1
		end if
	else
		ROLLBACK;
		return -1
	end if
else
	ROLLBACK;
	return -1
end if


end function

public function integer of_validate (ref mt_u_datawindow adw);/********************************************************************
   of_validate
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw:
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		  ?				?			?		First Version
		10/07/2013	CR3254	LHG008	Call dw validator service
		04/11/2013	CR3254	LHG008	Fix  valid input 'Estimated' value 
   </HISTORY>
********************************************************************/

datawindowchild	ldwc
long					ll_found, ll_rows, ll_statusid, ll_return,ll_estminhours, ll_estmaxhours
string					ls_null, ls_message
datetime				ldt_null, ldt_release_date
decimal				ld_costsaving_usd, ld_costsaving_fet
integer				li_errorcolumn
n_service_manager				lnv_servicemgr
n_dw_validation_service    lnv_validation

if adw.accepttext() = -1 then return c#return.Failure
if adw.rowcount() <> 0 and (adw.getitemstatus(1, 0, primary!) = newmodified! or adw.getitemstatus(1, 0, primary!) = datamodified!) then
	ll_statusid = adw.getitemnumber(1, "status_id")
	
	lnv_servicemgr.of_loadservice(lnv_validation, "n_dw_validation_service")
	
	lnv_validation.of_registerrulenumber("type_id", true, "Type")
	lnv_validation.of_registerrulenumber("module_id", true, "Module")
	lnv_validation.of_registerrulenumber("bu_id", true, "Business Unit")
	lnv_validation.of_registerrulenumber("priority_id", true, "Priority")
	lnv_validation.of_registerrulenumber("status_id", true, "Status")
	choose case ll_statusid
		case li_ASSIGNED_STATUS
			lnv_validation.of_registerrulestring("assigned_to", true, "Assigned To")
		case il_RELEASED_STATUS
			lnv_validation.of_registerrulestring("release_version", true, "Release Version")
			
			if adw.getitemstatus(1, "status_id", primary!) = datamodified! then
				SELECT TOP 1 getdate() INTO :ldt_release_date FROM CREQ_STATUS;
				adw.setitem(1, "release_date", ldt_release_date)
			end if
	end choose
	
	lnv_validation.of_registerrulestring("problem_desc", true, "Problem Description")
	
	//If rejected, then there must be a reason, date and user specified. if not reset date and user
	adw.getchild("status_id", ldwc)
	ll_found = ldwc.find("rejected_status=1", 1, 999)
	if ll_found > 0 then
		if ll_statusid = ldwc.getitemnumber(ll_found, "status_id") then
			lnv_validation.of_registerrulestring("rejection_desc", true, "Rejection Description")
			
			if isnull(adw.getitemdatetime(1, "rejection_date")) or &
				isnull(adw.getitemstring(1, "rejected_by")) then
					adw.setItem(1, "rejection_date", today())
					adw.setItem(1, "rejected_by", SQLCA.userid)
			end if
		else
			setnull(ls_null)
			setnull(ldt_null)
			adw.setItem(1, "rejection_date", ldt_null)
			adw.setItem(1, "rejected_by", ls_null)
		end if
	end if
	
	lnv_validation.of_registerrulestring("costsavings", true, "Value Description")
	
	//Call validator service
	ll_return = lnv_validation.of_validate(adw, ls_message, ll_rows, li_errorcolumn)
	if ll_return = c#return.Failure then
		messagebox("Validation Error", ls_message)
		adw.setfocus()
		adw.setrow(ll_rows)
		adw.setcolumn(li_errorcolumn)
		return c#return.Failure
	end if
	
	//Validate if the current module selected is active
	adw.getchild("module_id", ldwc)
	ll_rows = ldwc.rowcount()
	if ll_rows > 0 then
		ll_found = ldwc.find("module_id=" + string(adw.getitemnumber(1, "module_id")), 1, ll_rows)
		if ll_found > 0 then
			if ldwc.getitemnumber(ll_found, "module_active") = 0 then
				messagebox("Validation Error", "The selected module is inactive. Please select another item.")
				adw.setfocus()
				adw.setcolumn("module_id")
				return c#return.Failure
			end if
		else
			messagebox("Validation Error", "Invalid module is selected.")
			adw.setfocus()
			adw.setcolumn("module_id")
			return c#return.Failure
		end if
	end if

	//Validate if the current sub module selected is active
	if not isnull(adw.getitemnumber(1, "submodule_id")) then
		adw.getchild("submodule_id", ldwc)
		ll_rows = ldwc.rowcount()
		if ll_rows > 0 then
			ll_found = ldwc.find("submodule_id=" + string(adw.getitemnumber(1, "submodule_id")), 1, ll_rows)
			if ll_found > 0 then
				if ldwc.getitemnumber(ll_found, "sub_module_active") = 0 then
					messagebox("Validation Error", "The selected sub-module is inactive. Please select another item.")
					adw.setfocus()
					adw.setcolumn("submodule_id")
					return c#return.Failure
				end if
			else
				messagebox("Validation Error", "Invalid sub module is selected.")
				adw.setfocus()
				adw.setcolumn("submodule_id")
				return c#return.Failure
			end if
		end if
	end if
	
	ll_estminhours = adw.getitemnumber(1, "est_hrs_min")
	ll_estmaxhours = adw.getitemnumber(1,"est_hrs_max")
	//Status is Estimated 
	if  istr_parm.b_bu_dev and ll_statusid = li_ESTIMATED_STATUS and (isnull(ll_estmaxhours) and isnull(ll_estminhours)) then
		messagebox("Validation Error", "Please set min/max man-hrs")
		adw.setfocus()
		adw.setcolumn("input_est_hrs_min")
		return c#return.Failure
	end if 
	
	if isnull(ll_estminhours) and (not isnull(ll_estmaxhours) and ll_estmaxhours > 0) then
		adw.setitem(1, 'est_hrs_min', ll_estmaxhours)
		ll_estminhours = ll_estmaxhours
	end if
	
	if  isnull(ll_estmaxhours) and (not isnull(ll_estminhours) and ll_estminhours > 0) then
		adw.setitem(1, 'est_hrs_max', ll_estminhours)
		ll_estmaxhours = ll_estminhours
	end if
	
	if  istr_parm.b_bu_dev and ll_estmaxhours < ll_estminhours then
		messagebox("Validation Error", "Max man-hrs must be greater than min man-hrs")
		adw.setfocus()
		adw.setcolumn("input_est_hrs_max")
		return c#return.Failure
	end if	

	//Status is Business Approved
	if ll_statusid = il_BU_APPROVED_STATUS then
		// Not allowed unless All documentation is done
		if adw.getitemnumber(1, "user_doc_updated") = 0 then
			messagebox("Validation Error", "You are not allowed to set status to Business Approved without having checked User Manual")
			adw.setfocus()
			adw.setcolumn("user_doc_updated")
			return c#return.Failure
		end if
	end if
	
	//Status is other than New, Rejected, Transferred, Duplicate or Solved
	if ll_statusid <> 1 and ll_statusid <> 7 and ll_statusid <> 10 and ll_statusid <> 11 and ll_statusid <> 31  then
		ld_costsaving_usd = adw.getitemnumber(1, "costsaving_usd")
		ld_costsaving_fet = adw.getitemnumber(1, "costsaving_fet")
		if isnull(ld_costsaving_usd) then ld_costsaving_usd = 0.0
		if isnull(ld_costsaving_fet) then ld_costsaving_fet = 0.0
		
		if ld_costsaving_usd = 0.0 and ld_costsaving_fet = 0.0 then
			messagebox("Validation Error", "Either USD or FET must be specified")
			adw.setfocus()
			adw.setcolumn("costsaving_usd")
			return c#return.Failure
		end if
	end if
	
	//Set Last Edited if any changes made. 
	adw.setItem(1, "last_edit_date", today())
	adw.setItem(1, "last_edit_by", SQLCA.userid)
end if

return c#return.Success
end function

public function integer of_sendmail (string as_creator, string as_from, string as_to[], string as_subject, string as_body, blob abl_filecontent[], string as_filename[]);/********************************************************************
   of_sendmail
   <DESC>	Send Email	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_creator: Email creator
		as_from: Email from
		as_to[]: Email sent to
		as_subject: Email subject
		as_body: Email body
		abl_filecontent[]
		as_filename[]
   </ARGS>
   <USAGE>	ref: 	of_autosendmail(); u_creq_email.ue_sendmail()	</USAGE>
   <HISTORY>
		Date        CR-Ref   Author   Comments
		08/06/2015	CR4041	LHG008	First Version
		20/07/2015	CR4116	LHG008	Due to SMTP server email size limitation, the entire email size cannot exceed 14MB
   </HISTORY>
********************************************************************/

mt_n_outgoingmail	lnv_mail
string ls_errormessage, ls_filename[]
integer li_index, li_return = c#return.Success
long ll_bytes, ll_totalbytes
blob lbl_filecontent[]

if upperbound(as_to) < 1 then
	messagebox("Error creating mail", "Please enter a receiver (mail to)")
	return c#return.Failure
end if

lnv_mail = create mt_n_outgoingmail

li_return = lnv_mail.of_createmail(as_from, as_to[1], as_subject, as_body, ls_errormessage)

//Set mail creator
if li_return = c#return.Success then
	li_return = lnv_mail.of_setcreator(as_creator, ls_errormessage)
end if

//Add mail address
if li_return = c#return.Success then
	for li_index = 2 to upperbound(as_to)
		li_return = lnv_mail.of_addreceiver(as_to[li_index], ls_errormessage)
		if li_return = c#return.Failure then exit
	next
end if

//Add attachment to mail
if li_return = c#return.Success then
	for li_index = 1 to upperbound(abl_filecontent)
		
		//Check file name and file content is valid
		ll_bytes = len(abl_filecontent[li_index])
		if isnull(abl_filecontent[li_index]) or ll_bytes = 0 or isnull(as_filename[li_index]) or len(as_filename[li_index]) = 0 then continue
		
		//Check the file size is greater than the maximum size of the mail attachments
		if ll_bytes > c#email.il_ATT_MAXSIZE then
			if len(is_attfailedmsg) = 0 then	is_attfailedmsg = "The following attchment(s) cannot received because the file size is too large."
			is_attfailedmsg += '~r~n' + as_filename[li_index]
			continue
		end if
		
		//Check the total file size is greater than the maximum size of the mail attachments
		ll_totalbytes += ll_bytes
		if ll_totalbytes > c#email.il_ATT_MAXSIZE then
			lbl_filecontent[upperbound(lbl_filecontent) + 1] = abl_filecontent[li_index]
			ls_filename[upperbound(ls_filename) + 1] = as_filename[li_index]
		else
			if lnv_mail.of_addattachment(abl_filecontent[li_index], as_filename[li_index], ll_bytes, ls_errormessage) = c#return.Failure then
				is_attfailedmsg = "An error occurred when attaching file " + as_filename[li_index] + ". Error message: " + ls_errormessage + "~r~n" + is_attfailedmsg
			end if
		end if
	next
	
	ii_mailindex ++
	ii_mailcount ++
	
	//Create new mail for the remaining attachment
	if upperbound(lbl_filecontent) > 0 then
		if of_sendmail(as_creator, as_from, as_to, as_subject, as_body, lbl_filecontent, ls_filename) = c#return.Failure then
			ii_mailindex = 0
			ii_mailcount = 0
			is_attfailedmsg = ''
			destroy lnv_mail
			return c#return.Failure
		end if
	end if
	
	if ii_mailcount > 1 then
		li_return = lnv_mail.of_setsubject(as_subject + " email " + string(ii_mailindex) + " of " + string(ii_mailcount), ls_errormessage)
	end if
	
	if ii_mailindex = ii_mailcount and len(is_attfailedmsg) > 0 then
		li_return = lnv_mail.of_setbody(as_body + '~r~n~r~n' + is_attfailedmsg, ls_errormessage)
		is_attfailedmsg = ''
	end if
	
	ii_mailindex --
	if ii_mailindex = 0 then ii_mailcount = 0
end if

//Send mail
if li_return = c#return.Success then
	li_return = lnv_mail.of_sendmail(ls_errormessage)
end if

if li_return = c#return.Failure then
	messagebox("Error sending mail", ls_errormessage)
end if

destroy lnv_mail
return li_return
end function

public function integer of_mailtosupport (long al_requestid, string as_email_address, boolean ab_fullmail);/********************************************************************
   of_mailtosupport
   <DESC> Send mail to support	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		adw_request:
   </ARGS>
   <USAGE>	Ref:of_autosendmail() </USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		23/05/2013	CR2614	LHG008	First Version
		09/07/2013	CR3254	LHG008	Get email adderss from CREQ_CONSULTANT
		10/06/2015	CR4041	LHG008	Add attachments from CR to mail
   </HISTORY>
********************************************************************/

string ls_from, ls_to[], ls_subject, ls_body, ls_type, ls_assigned_to
string ls_printer, ls_temppath, ls_filespath, ls_filename[]
integer li_return, li_fnum, li_index
long ll_bufferlength = 500, ll_bytes, ll_fileid, ll_rowcount, ll_row
blob lbl_filecontent[]

mt_n_datastore			lds_printrequest, lds_att
mt_n_stringfunctions	lnv_string
n_fileattach_service	lnv_attservice
n_service_manager		lnv_servicemgr

if isnull(al_requestid) or isnull(as_email_address) or trim(as_email_address) = '' then
	ib_isusing = false
	return c#return.Success
end if

//Attempt to print CR to pdf file.
lds_printrequest = create mt_n_datastore
lds_printrequest.dataobject = "d_print_request"
lds_printrequest.settransobject(sqlca)

if lds_printrequest.retrieve(al_requestid, al_requestid) <= 0 then
	ib_isusing = false
	return c#return.Failure
end if

if ab_fullmail or ib_printrequest then
	//This should really use the dedicated temp folder
	ls_temppath = space(ll_bufferlength)
	if gettemppath(ll_bufferLength, ls_temppath) = 0 then
		 messagebox("Warning creating mail", "There is no temp path defined. Unable to add attachment.")
	else
		//Set datawindow printer
		ls_printer = uo_global.is_pdfdriver
		lds_printrequest.object.datawindow.export.pdf.method = Distill!
		lds_printrequest.object.datawindow.printer = ls_printer
		lds_printrequest.object.datawindow.export.pdf.distill.custompostscript = "1"
		
		//Save CR to PDF
		ls_filespath = ls_temppath + "CR" + string(al_requestid) + " print.pdf"
		lds_printrequest.saveas(ls_filespath, pdf!, false)
		
		//Add pdf file to array
		if fileexists(ls_filespath) then
			//Obtain blob
			li_fnum = fileopen(ls_filespath, StreamMode!, Read!, Shared!)
			ll_bytes = filereadex(li_fnum, lbl_filecontent[1])
			fileclose(li_fnum)
			
			//Get file name
			ls_filename[1] = mid(ls_filespath, lastpos(ls_filespath, "\") + 1)
			
			filedelete(ls_filespath)
			
			if ib_printrequest then ib_printrequest = false
		else
			messagebox("Warning creating mail", "Print CR to pdf file is failed")
		end if
	end if
end if

//Add attachments from CR to mail
lds_att = create mt_n_datastore
lds_att.dataobject = "d_sq_tb_creq_file_listing"
lds_att.setTransObject(sqlca)
lds_att.retrieve(al_requestid)

if not ab_fullmail then
	lds_att.setfilter("file_updated_date >= datetime('" + string(ib_attupdatetime) + "')")
	lds_att.filter()
end if

//If attachments are found we add them to array
ll_rowcount = lds_att.rowcount()
if ll_rowcount > 0 then
	lnv_servicemgr.of_loadservice(lnv_attservice, "n_fileattach_service")
	
	for ll_row = 1 to ll_rowcount
		ll_fileid = lds_att.getitemnumber(ll_row, "file_id")
		li_index = upperbound(lbl_filecontent) + 1
		
		//Locate blob from within FILES data table
		lnv_attservice.of_readblob("CREQ_ATT_FILES", ll_fileid, lbl_filecontent[li_index])
		
		//Use the same index
		ls_filename[li_index] = lds_att.getitemstring(ll_row, "file_name")
	next
end if

ls_type = lds_printrequest.getitemstring(1, "creq_type_type_desc")
ls_assigned_to = lds_printrequest.getitemstring(1, 'creq_request_assigned_to')

ls_from = C#EMAIL.TRAMOSSUPPORT
lnv_string.of_parsetoarray(as_email_address, ';', ls_to)
ls_subject = ls_type + ": CR" + string(al_requestid) + " specification"

ls_body = "Please find detail in attachment."
if ab_fullmail then
	if not isnull(ls_assigned_to) then
		ls_body = "The change request has been assigned to " + ls_assigned_to + ". " + ls_body
	end if
else
	ls_body = "The change request has been changed. " + ls_body
end if

//Send email and attach the file from array
li_return = of_sendmail(sqlca.userid, ls_from, ls_to, ls_subject, ls_body, lbl_filecontent, ls_filename)

destroy lds_att
destroy lds_printrequest

ib_isusing = false
return li_return

end function

on n_creq_request.create
call super::create
end on

on n_creq_request.destroy
call super::destroy
end on

event destructor;call super::destructor;if isvalid(ids_libraries) then destroy ids_libraries
end event

event constructor;call super::constructor;SELECT STATUS_ID, STATUS_DESCRIPTION INTO :il_initial_statusid, :is_initial_statusname FROM CREQ_STATUS WHERE INITIAL_STATUS = 1;
end event

