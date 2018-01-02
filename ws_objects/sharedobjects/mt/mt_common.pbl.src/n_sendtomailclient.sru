$PBExportHeader$n_sendtomailclient.sru
$PBExportComments$send to mail client
forward
global type n_sendtomailclient from mt_n_nonvisualobject
end type
end forward

global type n_sendtomailclient from mt_n_nonvisualobject autoinstantiate
end type

type prototypes
PRIVATE FUNCTION long ShellExecute (uint  ihwnd,string  lpszOp,string lpszFile,string  lpszParams, string  lpszDir,int  wShowCmd ) LIBRARY "Shell32.dll" ALIAS FOR "ShellExecuteW" 
PRIVATE FUNCTION long UrlEscape(string url, ref string escaped, ref ulong length, ulong flags) LIBRARY "Shlwapi.dll" ALIAS FOR "UrlEscapeW" 

end prototypes

forward prototypes
public subroutine documentation ()
public function integer of_sendmailbyoutlook (string as_subject, string as_mailto)
public function integer of_mailto (string as_subject, string as_mailto)
end prototypes

public subroutine documentation ();/********************************************************************
   n_sendtomailclient
   <OBJECT>Send to mail client</OBJECT>
   <USAGE>	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-08-2013 CR3238       LHC010        First Version
      04/11/14   CR3760       SSX014        Open the default mail client registered in the windows system
   </HISTORY>
********************************************************************/

end subroutine

public function integer of_sendmailbyoutlook (string as_subject, string as_mailto);/********************************************************************
   of_sendmailbyoutlook
   <DESC> sent mail to outlook </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_subject
		as_mailto
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-08-2013 CR3238       LHC010        First Version
      04/11/14   CR3760       SSX014        Open the default mail client registered in the windows system
   </HISTORY>
********************************************************************/

return of_mailto(as_subject, as_mailto)

end function

public function integer of_mailto (string as_subject, string as_mailto);/********************************************************************
   of_mailto
   <DESC> sent mail </DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_subject  : the subject of an email
		as_mailto   : an email address
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author       Comments
      04/11/14   CR3760       SSX014       Open the default mail client
                                           registered in the windows system
   </HISTORY>
********************************************************************/

int li_return
uint li_hwin
string ls_parm
string ls_dir
string ls_address
long hinst
string ls_escaped
ulong ll_length
long ll_rc

constant long SW_SHOW = 5
constant long URL_ESCAPE_SEGMENT_ONLY = 8192 // 0x00002000
constant long E_POINTER = -2147467261 // 0x80004003
constant long S_OK = 0

// Encoding the subject
ll_length = len(as_subject)
if ll_length > 0 then
	ll_length *= 3
	ls_escaped = space(ll_length)
	ll_rc = UrlEscape(as_subject, ls_escaped, ll_length, URL_ESCAPE_SEGMENT_ONLY)
	do while ll_rc = E_POINTER
		ll_length *= 2
		ls_escaped = space(ll_length)
		ll_rc = UrlEscape(as_subject, ls_escaped, ll_length, URL_ESCAPE_SEGMENT_ONLY)
	loop
	if ll_rc <> S_OK then
		ls_escaped = ''
	end if
else
	ls_escaped = ''
end if

// Open default email client
setnull(li_hwin)
setnull(ls_parm)
setnull(ls_dir)
ls_address = "mailto:" + as_mailto + "?subject=" + ls_escaped
hinst = ShellExecute(li_hwin, "open", ls_address, ls_parm, ls_dir, SW_SHOW)

if hinst > 32 then
	return c#return.Success
else
	return c#return.Failure
end if

end function

on n_sendtomailclient.create
call super::create
end on

on n_sendtomailclient.destroy
call super::destroy
end on

