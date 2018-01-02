$PBExportHeader$n_error_service.sru
forward
global type n_error_service from mt_n_baseservice
end type
end forward

shared variables
integer si_outputtype = 1
string ss_outputname // if si_output_type: 2=filename, 3=dataobject
string ss_blockref // ie 'MON' '2015005' etc 
end variables

global type n_error_service from mt_n_baseservice
end type
global n_error_service n_error_service

type prototypes
end prototypes

type variables
private mt_n_datastore	ids_errorMessage
private boolean		ib_captureError = False
private boolean		ib_logMessages = False

constant integer iiOUTPUT_WINDOW = 1
constant integer iiOUTPUT_LOGFILE = 2
constant integer iiOUTPUT_DB = 4

end variables

forward prototypes
public function integer of_showmessages ()
public subroutine documentation ()
public subroutine of_capturemessages (boolean ab_enabled)
public function integer of_addmsg (readonly powerobject apo_classdef, string as_method, string as_message, string as_devmessage)
public function integer of_addmsg (readonly powerobject apo_classdef, string as_method, string as_message, string as_devmessage, integer ai_severity)
public function integer of_setoutput (integer ai_type, string as_outputname)
public function long of_getmessagecount ()
public function integer of_dblogging (boolean ab_dummy)
public function integer of_getoutputtype ()
public function integer of_setoutput (integer ai_type, string as_outputname, boolean ab_cleardata)
public function string of_getlogfilename ()
public function integer of_addmsg (readonly powerobject apo_classdef, string as_method, string as_message, string as_devmessage, integer ai_severity, string as_monitor_id)
public function integer of_updatemonitorrecord (string as_message, string as_monitor_id)
end prototypes

public function integer of_showmessages ();/********************************************************************
   of_showmessages( )
   <DESC>   outputs message(s) to either window/log file</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   n/a</ARGS>
   <USAGE>  Either called automatically if object inherits from base object _addmsg() or 
	manually if building a queue of messages to be shown.  
	If output type is window: Also tests if capture window is open.  If it is outputs to this.
	Useful for debugging purposes.  If capture window is not open, error message window (response!)
	opens stopping all further processes until it is closed.
	</USAGE>
********************************************************************/


long ll_row, il_logHandle, ll_retval
integer li_severity
string ls_message

	ll_row = ids_errormessage.rowCount()
	
	if ll_row < 1 then return c#return.failure
	
	if si_outputtype = iiOUTPUT_WINDOW then
		if isValid(w_capture_errormessage) then return c#return.success
		openwithparm(w_show_errorMessage, ids_errormessage)
	elseif si_outputtype = iiOUTPUT_LOGFILE then
		/* write to log file */
		il_logHandle = FileOpen(of_getlogfilename(), LineMode!, Write!, LockWrite!, Append!)
		for ll_row = 1 to  ids_errormessage.rowCount()
			ls_message = ids_errormessage.getitemstring( ll_row, "message")
			if filewriteex(il_logHandle,  string(datetime(today(), now()),"dd. mmm yyyy ") + ls_message) = -1 then
				return c#return.Failure
			end if
		next
		fileClose(il_logHandle)
	end if
	ids_errormessage.reset( )

return c#return.success
end function

public subroutine documentation ();/*  
/********************************************************************
   n_error_service
	
   <OBJECT> 
		Sends messages to window/log file
	</OBJECT>
   
	<DESC>
	</DESC>
   
	<USAGE>  
		Example from _addMsg() function in ancestor base object.
	
		n_service_manager 	lnv_serviceManager
		n_error_service		lnv_errService
		lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
		lnv_errService.of_addMsg(apo_classdef , as_methodname, as_message, as_devmessage )
		if ab_showmessage then lnv_errService.of_showmessages( )
		return c#return.success
		
		
		When output is set to a database table you need a table specifically setup.  Like example below:

		/*==============================================================*/
		/* Table: TRAMOS_ERROR_LOG                                      */
		/*==============================================================*/
		create table TRAMOS_ERROR_LOG (
			ID                   int                            identity,
			TYPE                 smallint                       null,
			CLASSNAME            varchar(100)                   null,
			METHOD               varchar(100)                   null,
			SEVERITY             bit                            not null,
			MESSAGE              varchar(250)                   null,
			DEVMESSAGE           varchar(250)                   null,
			ENTRY_TIME           timestamp                      null,
			constraint PK_TRAMOS_ERROR_LOG primary key (ID)
		)

		
	</USAGE>
	
   <ALSO>   
		n_service_manager, w_capture_error_message, w_show_errormessage,
		d_ex_tb_errormessages, d_ex_tb_user_errormessages


		Severity levels: 1 = Error, 2 = Warning and 3 = Information
		
		If capture window is open error messages are outputted here.  The w_capture_errormessage window
		is a normal window whereas the standard error window w_show_errormessage is a response window
		locking all processing until user closes window.
		
		Output: 1 = Window <default>, 2 = log to text file, 3 = Window & log to database, 4 = log to db
		
		
		Logging (historic info)
		=======
		
		If function of_setoutput() is called it is possible to switch the output from the
		normal window to a log file.
		
		Use alternative function in base component (mt_w_master, mt_n_nonvisual) _addLogMessage()
		to add to the log file.
		
		The logging process has optionally access to an ini file, useful for external server applications
		for example.  The settings available for this process include:
			
			[log]
			file="c:\SpecialClaimMonitor\SpecialClaimMonitor.log"
			level=4
			append=1
			postfix="day"
			
		file 		- 	the log itself can reside in any folder available
		level 	- 	all messages in system have a level of importance.  0 High, 4 Low.  If
						level in ini file is set to 0 no logging will occur, if set to 2 only messages
						set at 2 and below are shown.
		append	-	default append, if the code allows (use function of_clear_log()) this can control
						if the file is replaced or not.
		postfix	-	this allows a rename of the log file.  day appends the day number at the end
						of the file name, "dd" the day of the month, "mm" the month, "yy" the year.  Any combination
						used with the string() function is allowed.

		 Date   	Ref    	Author         	Comments
	  00/00/07 	?      	Name Here      	First Version
	  06/10/10 	?      	AGL027			  	Added/Updated documentation
	  06/05/11 	CR2274   AGL027		  		Added function to provide rowcount of errors
	  17/06/11 	?			AGL027				Applied new implementation of database logging
	  03/11/14				AGL027				Removed timestamp from user message in window.  Also removed window+db config
	  													as no implementation to log to db exists right now and we can apply smarter
														mechanism here if we want to log in all 3 places at once.
	  15/06/15	CR3419	AGL027				Log file autonaming based on date - make it easier to archive items			
     23/06/15  CR3783   SSX014            added monitor_id that links the application to the correct monitor record
	
	Improvements - When logging to db: Would be worthwhile testing the transaction just in case there is no connection
	</ALSO>

********************************************************************/
*/
end subroutine

public subroutine of_capturemessages (boolean ab_enabled);/********************************************************************
   of_capturemessages( /*boolean ab_enabled */)
   <DESC>   Currently unused </DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   ab_enabled: Not used
   </ARGS>
   <USAGE>  Created concerning the debug option.</USAGE>
********************************************************************/


choose case ab_enabled
	case TRUE
		if NOT isValid(w_capture_errorMessage) then
			openwithparm(w_capture_errorMessage, ids_errorMessage) 
		end if
	case FALSE 
		if isValid(w_capture_errorMessage) then
			close ( w_capture_errorMessage )
		end if
end choose
end subroutine

public function integer of_addmsg (readonly powerobject apo_classdef, string as_method, string as_message, string as_devmessage);/********************************************************************
   of_addmsg( /*readonly powerobject apo_classdef*/, /*string as_method*/, /*string as_message*/, /*string as_devmessage */)
   <DESC>   Used to add message received to datastore holder</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   apo_classdef: Object containing detailed info of calling object 
            as_method: name of calling function/procedure
				as_message: friendly message intended for user 
				as_dev_message: technical detail helpful for developer
				</ARGS>
   <USAGE>  This is the overridden function.  calls main with default severity level of 1
	</USAGE>
********************************************************************/


return of_addMsg(apo_classdef, as_method, as_message, as_devmessage, 1)
end function

public function integer of_addmsg (readonly powerobject apo_classdef, string as_method, string as_message, string as_devmessage, integer ai_severity);/********************************************************************
   of_addmsg( /*readonly powerobject apo_classdef*/, /*string as_method*/, /*string as_message*/, /*string as_devmessage*/, /*integer ai_severity */)
   <DESC>   Used to add message received to datastore holder</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   apo_classdef: Object containing detailed info of calling object 
            as_method: name of calling function/procedure
				as_message: friendly message intended for user 
				as_dev_message: technical detail helpful for developer
				ai_severity: used in datawindow object to display icon
				</ARGS>
   <USAGE>  Adds message to datastore.  Outputted only when of_showMessages() is called
	</USAGE>
********************************************************************/

return of_addMsg(apo_classdef, as_method, as_message, as_devmessage, ai_severity, "")
end function

public function integer of_setoutput (integer ai_type, string as_outputname);/********************************************************************
  of_setoutput( /*integer ai_type*/, /*string as_outputname */)
   <DESC>   Used specifically to set the message service to file logging</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   ai_type			: 1=window, 2=log file, 3=window+db, 4=db
				as_outputname	: either the file name ie wmqtransaction.log or the dataobject name.
   </ARGS>
   <USAGE>  Once service is loaded, call this to switch the output to logging.
	Handy for server apps, but can be used elsewhere too.  
	
	This value is placed in a shared variable so this option needs only be called
	once (unless using the object for both window and file logging activities)
	
	Example
	=======

lnv_serviceManager.of_loadservice( lnv_errService , "n_error_service")
lnv_errService.of_setoutput(2, "timax")
lnv_errService.of_addMsg(lpo_empty, "", as_message, "", ai_loglevel)
lnv_errService.of_showmessages( )
	
	</USAGE>
********************************************************************/

si_outputtype = ai_type

/* ss_blockref is also the flag to determine if we use advanced log file naming convensions or not */

string ls_logfilename, ls_blockdata, ls_blockdetail, ls_newlogfilename
long ll_charpos, ll_startblockpos, ll_endblockpos
boolean lb_closedsegment = false

ll_startblockpos = pos(as_outputname,"[") + 1
if ll_startblockpos>1 and len(as_outputname)>ll_startblockpos then
	ll_endblockpos = lastpos(as_outputname,"]")
	if ll_endblockpos<>ll_startblockpos then
		ss_blockref = mid(as_outputname,ll_startblockpos, ll_endblockpos - ll_startblockpos)
		ss_outputname = as_outputname
	end if
end if	

if ss_blockref="" or isnull(ss_blockref) then
	ss_outputname = as_outputname
end if

return c#return.Success
end function

public function long of_getmessagecount ();return ids_errorMessage.rowcount()
end function

public function integer of_dblogging (boolean ab_dummy);return c#return.Success
end function

public function integer of_getoutputtype ();return si_outputtype
end function

public function integer of_setoutput (integer ai_type, string as_outputname, boolean ab_cleardata);/********************************************************************
  of_setoutput( /*integer ai_type*/, /*string as_outputname */)
   <DESC>   Used specifically to set the message service to file logging</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   ai_type			: 1=window, 2=log file, 3=window+db, 4=db
				as_outputname	: either the file name ie wmqtransaction.log or the dataobject name.
   </ARGS>
   <USAGE>  Once service is loaded, call this to switch the output to logging.
	Handy for server apps, but can be used elsewhere too.  
	
	This value is placed in a shared variable so this option needs only be called
	once (unless using the object for both window and file logging activities)
	
	This version of the function attempts to delete existing copy of file 
	before logging starts.
	
	</USAGE>
********************************************************************/

if ab_cleardata then filedelete(as_outputname)
return of_setoutput(ai_type, as_outputname)
end function

public function string of_getlogfilename ();string ls_logfilename, ls_blockdata, ls_outputname
long ll_startblockpos, ll_endblockpos
integer li_dayinyear
date ldt_filemodified,ldt_firstdayinyear
time lt_dummy
mt_n_filefunctions lnv_filefunc
mt_n_datefunctions lnv_datefunc


if si_outputtype <> 2 then return ""
if ss_blockref ="" then return ss_outputname	

ll_startblockpos = pos(ss_outputname,"[") + 1
ll_endblockpos = lastpos(ss_outputname,"]")


ldt_firstdayinyear = date(string(year(today())) + "/01/01")
li_dayinyear = daysafter(ldt_firstdayinyear, today())

CHOOSE CASE upper(ss_blockref)
	CASE "DDD", "DD", "MM", "MMM", "YY", "YYYY", "YYYYMM", "YYYYMMM", "YYMM", "YYYYMMDD", "YYYY-MM-DD", "YY-MM-DD", "MMDD", "MM-DD", "HH", "DDDHH", "DDHH"    
		ls_blockdata = string(now(),ss_blockref)
	CASE "DOW"
		ls_blockdata = string( daynumber(today()) ,"00")
	CASE "EEE"	// day number in Year	
		ls_blockdata = string(li_dayinyear,"000")
	CASE "YYEEE" // Year + day number in Year
		ls_blockdata = string(now(), "YY") + string(li_dayinyear,"000")
	CASE ELSE
		ls_blockdata = "ERR"
END CHOOSE

ls_outputname = left(ss_outputname,ll_startblockpos - 2) + ls_blockdata + right(ss_outputname, len(ss_outputname) - ll_endblockpos)
lnv_filefunc.of_getlastwritedatetime( GetCurrentDirectory() + "\" +  ls_outputname, ldt_filemodified, lt_dummy)

if not isnull(ldt_filemodified) then  // file exists already
	CHOOSE CASE ss_blockref
		CASE "DDD", "DOW", "DDD", "DD", "HH", "DDDHH", "DDHH"  /* day of week + day of month*/
			if (ldt_filemodified <> today()) then
				// replace file!
				filedelete(ls_outputname)	
			end if	
		CASE "YYYYMMDD", "YYYY-MM-DD", "YY-MM-DD", "YYYYMM", "YYYYMMM", "YYMM", "YY", "YYYY", "YYEEE" /* year referencing */
			// we append to the existing file found. therefore nothing to do here.
			
		CASE "MM", "MMM", "MMDD", "MM-DD", "EEE"	/* month detail */
			if month(today()) = month(ldt_filemodified) and year(today()) <> year(ldt_filemodified) then
				// replace file!
				filedelete(ls_outputname)
			end if	
		CASE ELSE
	END CHOOSE
end if

return ls_outputname
end function

public function integer of_addmsg (readonly powerobject apo_classdef, string as_method, string as_message, string as_devmessage, integer ai_severity, string as_monitor_id);/********************************************************************
   of_addmsg( /*readonly powerobject apo_classdef*/, /*string as_method*/, /*string as_message*/, /*string as_devmessage*/, /*integer ai_severity */)
   <DESC>   Used to add message received to datastore holder</DESC>
   <RETURN> Integer:
            <LI> 1, X Success
            <LI> -1, X Failure</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>   apo_classdef: Object containing detailed info of calling object 
            as_method: name of calling function/procedure
				as_message: friendly message intended for user 
				as_dev_message: technical detail helpful for developer
				ai_severity: used in datawindow object to display icon
				as_monitor_id: used to link the record to the application
				</ARGS>
   <USAGE>  Adds message to datastore.  Outputted only when of_showMessages() is called
	</USAGE>
	<HISTORY>
		Date     CR-Ref        Author   Comments
		25/06/15 CR3783        SSX014   added the monitor_id parameter
   </HISTORY>
********************************************************************/

classdefinition	lcd_sentfrom
mt_n_datastore	lds_errorlog
long 					ll_row

string ls_parmtype="", ls_message=""

of_updatemonitorrecord(as_message, as_monitor_id)

if isvalid(apo_classdef) then ls_parmtype = apo_classdef.classname()

ll_row = ids_errormessage.insertRow(0)

if ll_row < 1 then return c#return.failure

if ls_parmtype="classdefinition" then 
	lcd_sentfrom	= apo_classdef
	ids_errormessage.setItem(ll_row, "classname", lcd_sentfrom.name )
	ids_errormessage.setItem(ll_row, "method", as_method )
	ids_errormessage.setItem(ll_row, "datatype", lcd_sentfrom.DataTypeOf )
	ids_errormessage.setItem(ll_row, "devmessage", string(now()) + " - " + as_devmessage )
end if
ids_errormessage.setItem(ll_row, "severity", ai_severity )
ls_message = as_message
if si_outputtype <> iiOUTPUT_WINDOW then
	ls_message = string(now()) + " - " + ls_message
end if	
ids_errormessage.setItem(ll_row, "message", ls_message )

/* must have transaction object already assigned.  If not process will fail */
if si_outputtype = iiOUTPUT_DB then
	lds_errorlog = create mt_n_datastore
	lds_errorlog.dataobject = ss_outputname
	lds_errorlog.settransobject( SQLCA )
	ll_row = lds_errorlog.insertRow(0)

	lds_errorlog.setItem(ll_row, "type", 1 )
	lds_errorlog.setItem(ll_row, "classname", lcd_sentfrom.name )
	lds_errorlog.setItem(ll_row, "method", as_method )
	lds_errorlog.setItem(ll_row, "severity", ai_severity )
	lds_errorlog.setItem(ll_row, "message", as_message )
	lds_errorlog.setItem(ll_row, "devmessage", as_devmessage )
	
	if lds_errorlog.update() = 1 then
		commit;
		destroy lds_errorlog
	else
		rollback;
		destroy lds_errorlog		
		return c#return.failure
	end if
	
end if

return c#return.success
end function

public function integer of_updatemonitorrecord (string as_message, string as_monitor_id);/********************************************************************
   of_updatemonitorrecord
   <DESC>	Description	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success: 1, ok
            <LI> c#return.Failure: -1, failed
				<LI> c#return.NoAction
	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		as_message    : the error message
		as_monitor_id : the appliction monitor id
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		25/06/15 CR3783        SSX014   Update the monitor record
   </HISTORY>
********************************************************************/

string ls_keywords
string ls_keywordarr[]
mt_n_stringfunctions lnv_string
string ls_keywordsmatched[], ls_lastkeywords
long ll_i, ll_upper, ll_matched
string ls_messagelower
string ls_keywordlower
datetime ldt_now
mt_n_datefunctions lnv_datefun
long ll_errcode
string ls_errmsg

// if no monitor id, do nothing
if isnull(as_monitor_id) or len(as_monitor_id) = 0 then
	return c#return.NoAction
end if

// get keywords
if SQLCA.DBHandle() <> 0 then

	setnull(ls_keywords)
	SELECT KEYWORDS INTO :ls_keywords
	FROM APPMONITORCONFIG
	WHERE MONITOR_ID = :as_monitor_id AND ENABLED = 1;

	if SQLCA.sqlcode = -1 then
		return c#return.Failure
	elseif SQLCA.sqlcode = 100 then
		// if no enabled monitor record, do nothing
		return c#return.NoAction
	end if
	
else
	return c#return.NoAction
end if

// check if there are any keywords matched with the message
if isnull(ls_keywords) or len(ls_keywords) = 0 then
	ll_matched = 1
	ls_keywordsmatched[1] = "<Empty>"
else

	// split the keywords into an array
	lnv_string.of_parsetoarray(ls_keywords, ",", ls_keywordarr[])
	
	// check if any keyword in the error message
	ll_upper = upperbound(ls_keywordarr)
	ls_messagelower = lower(as_message)
	ll_matched = 0
	for ll_i = 1 to ll_upper
		ls_keywordlower = lower(ls_keywordarr[ll_i])
		if pos(ls_messagelower, ls_keywordlower) > 0 then
			ll_matched ++
			ls_keywordsmatched[ll_matched] = ls_keywordarr[ll_i]
		end if
	next

end if

// if there is any keyword in the error message
if ll_matched > 0 then
	ls_lastkeywords = ls_keywordsmatched[ll_matched]
	
	// update the last updated date, keyword item and the last keyword date
	UPDATE APPMONITORCONFIG 
		SET LASTKEYWORDDATE = GETDATE(),
			 LASTKEYWORD = :ls_lastkeywords,
			 LASTUPDATED = GETDATE()
	WHERE MONITOR_ID = :as_monitor_id AND ENABLED = 1;
else
	// update the last updated date
	UPDATE APPMONITORCONFIG
		SET LASTUPDATED = GETDATE()
	WHERE MONITOR_ID = :as_monitor_id AND ENABLED = 1;
end if

// commit work
if SQLCA.SQLCode = -1 then
	SQLCA.of_rollback()
	return c#return.Failure
else
	SQLCA.of_commit()
end if

return c#return.Success

end function

on n_error_service.create
call super::create
end on

on n_error_service.destroy
call super::destroy
end on

event constructor;call super::constructor; #Pooled = TRUE
 
ids_errorMessage = create mt_n_datastore
ids_errorMessage.dataObject = "d_ex_tb_errorMessages"


end event

event destructor;call super::destructor;destroy ids_errormessage
end event

