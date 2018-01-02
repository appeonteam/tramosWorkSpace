$PBExportHeader$w_login.srw
$PBExportComments$General login window
forward
global type w_login from mt_w_response
end type
type cb_options from commandbutton within w_login
end type
type cb_cancel from commandbutton within w_login
end type
type cb_login from commandbutton within w_login
end type
type dw_login from datawindow within w_login
end type
type rb_test from radiobutton within w_login
end type
type rb_develop from radiobutton within w_login
end type
type rb_preproduction from radiobutton within w_login
end type
type rb_prodbackup from radiobutton within w_login
end type
type rb_prod from radiobutton within w_login
end type
end forward

global type w_login from mt_w_response
integer x = 672
integer y = 264
integer width = 2752
integer height = 1676
string title = "Tramos Login"
long backcolor = 81324524
boolean ib_enablef1help = false
cb_options cb_options
cb_cancel cb_cancel
cb_login cb_login
dw_login dw_login
rb_test rb_test
rb_develop rb_develop
rb_preproduction rb_preproduction
rb_prodbackup rb_prodbackup
rb_prod rb_prod
end type
global w_login w_login

type prototypes

end prototypes

type variables
integer ii_attempts
s_login is_login
string is_currentfolder


end variables

forward prototypes
private function integer wf_load_systemvars (ref string as_servername, ref string as_database, ref string as_dbms)
private function integer wf_opentramosonline ()
private function string wf_simpleencrypt (string as_text)
private function string wf_hex (integer ai_value)
private function integer wf_getwebuserflag ()
public subroutine documentation ()
public subroutine wf_options ()
end prototypes

private function integer wf_load_systemvars (ref string as_servername, ref string as_database, ref string as_dbms);
/********************************************************************
   wf_load_systemvars( /*ref string as_servername*/, /*ref string as_database*/, /*ref string as_dbms */)
   <DESC>   Standard process to load global system vars to be used against the transaction object</DESC>
   <RETURN> Integer:
            <LI> 1, X ok
            <LI> -1, X failed (never fails!)</RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS>   as_servername: sets the server name depending on the windows controls
            as_database: sets the database name up depending on the windows controls
				as_dms: no condition</ARGS>
   <USAGE>  Currently called by the click event of st_forgotpw and cb_login</USAGE>
********************************************************************/

string ls_servername, ls_database

if rb_prod.checked then
	as_servername = c#connectivity.PRODUCTIONSERVER
	as_database = c#connectivity.PRODUCTIONDB
elseif rb_prodbackup.checked then
	as_servername = c#connectivity.STANDBYSERVER
	as_database = c#connectivity.PRODUCTIONDB
elseif rb_preproduction.checked then
	as_servername = c#connectivity.TESTSERVER
	as_database = c#connectivity.PRETRAMOSDB
elseif rb_test.checked then
	as_servername = c#connectivity.TESTSERVER
	as_database = c#connectivity.TESTDB
else
	dw_login.accepttext( )
	
	ls_servername = dw_login.getitemstring(1, "server_name")
	ls_database = dw_login.getitemstring(1, "db_name")
	
	as_servername = ls_servername
	as_database = ls_database
end if

as_dbms = "SYC"

return 1
end function

private function integer wf_opentramosonline ();/********************************************************************
   wf_opentramosonline( )
   <DESC>   Small function to open a browser instance and load the url 
				with querystring</DESC>
   <RETURN> Integer:
            code returned from shellexecute </RETURN>
   <ACCESS> Private</ACCESS>
   <ARGS> </ARGS>
   <USAGE>  How to use this function.</USAGE>
********************************************************************/
string ls_open, ls_url, ls_parm, ls_dir, ls_qrystrparm, ls_encrypted, ls_newcode, ls_decrypted
integer li_pos

messagebox("Info", "You have only web access to Tramos On-Line.  We are redirecting you now.")
// redirect user to web application		
ls_open = "open"
ls_url = "http://tramos/login.aspx"
setNull(ls_parm)
setNull(ls_dir)

ls_encrypted = wf_simpleencrypt(uo_global.is_userid +';'+ uo_global.is_password)
ls_qrystrparm = "?j1=" + ls_encrypted
return shellExecute(handle(this), ls_open, ls_url + ls_qrystrparm, ls_parm, ls_dir, 1)
			
end function

private function string wf_simpleencrypt (string as_text);
/********************************************************************
   wf_simpleencrypt( /*string as_text */)
   <DESC>   Used specifically to encode userid and password passed to 
				Tramos Online</DESC>
   <RETURN> String:
            The encrypted code</RETURN>
   <ACCESS> Public/Protected/Private</ACCESS>
   <ARGS>   as_text: The string to encrypt
            </ARGS>
   <USAGE>  Simple usage.  </USAGE>
********************************************************************/


Integer li_Pos, li_Loop, li_Array[]
Long ll_Checksum
String ls_Hex, ls_Code


For li_Loop = 1 to len(as_text)
	li_Pos ++
	li_Array[li_Pos] = AscA(Mid(as_text, li_Loop, 1))
Next

ll_Checksum = 0
For li_Loop = 1 to li_Pos
	ll_Checksum += li_Array[li_Loop] * li_Loop
Next
ll_Checksum = mod(ll_Checksum, 65536)
li_Pos ++
li_Array[li_Pos] = Int(ll_Checksum/256)
li_Pos ++
li_Array[li_Pos] = Mod(ll_Checksum, 256)

// Invert bytes
For li_Loop = 1 to li_Pos
	li_Array[li_Loop] = 255 - li_Array[li_Loop]
Next

// Convert to Hex
ls_Code = ''
For li_Loop = 1 to li_Pos
	ls_Hex = wf_Hex(li_Array[li_Loop])
	if len(ls_Hex) = 1 then ls_Hex = '0' + ls_Hex
	ls_Code += ls_Hex
Next

// Convert to alphabets
li_Pos = Len(ls_Code)
For li_Loop = 1 to li_Pos
	ls_Hex = Mid(ls_Code, li_Loop, 1)
	If ls_Hex < 'A' then ls_Code = Replace(ls_Code, li_Loop, 1, CharA(AscA(ls_Hex) + 33))
Next

return lower(ls_code)
end function

private function string wf_hex (integer ai_value);String ls_Hex
Integer li_ASCII

Do
	li_ASCII= Mod(ai_Value, 16) + 48   // Get ASCII
	If li_ASCII > 57 then li_ASCII += 7  // Convert to Hex
	ls_Hex = CharA(li_ASCII) + ls_Hex  // Append
	ai_Value = Int(ai_Value / 16)  // Truncate to next digit
Loop Until ai_Value = 0

Return ls_Hex
end function

private function integer wf_getwebuserflag ();integer li_RetVal

select WEB_ACCESS_ONLY 
into :li_RetVal
from USERS 
where USERID=:uo_global.is_userid;
commit;

return li_RetVal
end function

public subroutine documentation ();/********************************************************************
	ObjectName: 
	<OBJECT>w_login</OBJECT>
	<DESC>Standard user login window for Tramos Application</DESC>
	<USAGE> </USAGE>
	<ALSO> </ALSO>
	<HISTORY>
		Date    		Ref   		Author		Comments
		17/01/11		?     		CONASW		Moved to MT framework
		17/01/11		CR2069		CONASW		Added LASTLOGIN column to USERS table and made changes 
														to populate the field after successful login
		08/06/11		CR2460		JMC112		Check if developer.ini file exists.
		01/08/11		CR2532		CONASW		Disable Production checkbox if running from test version
		07/09/11		CR2575		CONASW		Added message for locked users to click on reset password link
		04/10/11		CR2589		CONASW		Tramos version to be of format xx.xx.x
		17/10/11		CR1573		RJH022		Add  users group for not visited sysusers
		21/08/12		CR2572		AGL027		For test environment (USERS table PW_LAST_CHANGED set to null) 
														disable password reset after 30 days
		12/04/13		CR3213		AGL027		Fix issue with validation of application version number against 
														database version number
		22/04/13		CR3158		WWA048		Update the UI of login window.
		17/04/14		CR3240UAT	CCY018		change copyright year to current year.
		12/08/14		CR3708		AGL027		F1 help application coverage - disabled new ib_enablef1help property
		17/03/15		CR3987		AGL027		Remove hardcoded references of servers and use commandline parameters instead of app name to control pre-selections
		16/06/15		CR3694		XSZ004		Change password every 90 days instead of 30 days.
		29/03/16		CR4316		AGL027		Verify user email address in AD matches stored email address in Tramos
	</HISTORY>
********************************************************************/

end subroutine

public subroutine wf_options ();/********************************************************************
   wf_options
   <DESC> Control the visibility of additional options </DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date         CR-Ref       Author           Comments
   	22/04/2013   CR3158       WWA048           First Version
   </HISTORY>
********************************************************************/

boolean lb_visible

lb_visible = not (right(cb_options.text,2) = ">>")

rb_develop.visible = lb_visible
rb_preproduction.visible = lb_visible
rb_prod.visible = lb_visible
rb_prodbackup.visible = lb_visible
rb_test.visible = lb_visible

dw_login.object.server_name.visible = lb_visible
dw_login.object.db_name.visible = lb_visible
dw_login.object.server_name_t.visible = lb_visible
dw_login.object.db_name_t.visible = lb_visible

end subroutine

event open;/************************************************************************************
 Arthur Andersen PowerBuilder Development
 Window  : w_login
 Object     : 
 Event	 :  Open
 Scope     : Global
 ****************************************
 Author    	: Martin Israelsen
 Date       	: 01/01-96
 Description 	: General loginwindow
 Arguments 	: s_login as PowerObjectParm
 Returns   	: s_login
 Variables 	: None
 Other 		: 
*****************************************
Development Log 
DATE			VERSION 	NAME		DESCRIPTION
----------- 	------- 		----- 		-------------------------------------
01/01-96		1.0			MI			Initial version
25/08-96		3.0			MI			Changed to CTL3DV2 look
22/04-13		3158			WWA048	Update the UI of login window.
*********************************************/

long		ll_profile
string 	ls_db_name, ls_server_name, ls_version, ls_app
ulong		ll_rgn

dw_login.settransobject(sqlca)
dw_login.insertrow(0)

// Setup title, SQLCA defaults etc.
is_login = message.powerobjectparm
is_login.return_userid = ""
is_login.program_name = "Tramos"
is_currentfolder=GetCurrentDirectory()
			
Title = is_login.program_name + " Login"

ls_version = uo_global.GetProgramFullVersion()

dw_login.object.st_vertion.text = ls_version
dw_login.object.t_3.text = "©1995-" + string(year(today())) + " Maersk Tankers A/S"

dw_login.setitem(1, "user_id", uo_global.is_userid)
dw_login.setitem(1, "password", uo_global.is_password)


		
ii_attempts = 0

if upper(uo_global.is_servername) = c#connectivity.TESTSERVER then
	rb_prod.enabled = false
	rb_prodbackup.enabled = false
	choose case upper(uo_global.is_database)	
		case c#connectivity.TESTDB
			// radio Test Environment
			rb_test.checked = true
		case c#connectivity.PRETRAMOSDB
			// radio Pre-Production
			rb_preproduction.checked = true
		case else
			// Developer radio
			rb_develop.checked = true
	end choose
elseif upper(uo_global.is_servername)=c#connectivity.STANDBYSERVER then 		
	choose case upper(uo_global.is_database)
		case c#connectivity.PRODUCTIONDB
			// Standby radio
			rb_prodbackup.checked = true
		case else
			// Developer radio
			rb_develop.checked = true
	end choose				
elseif upper(uo_global.is_servername)=c#connectivity.PRODUCTIONSERVER or uo_global.is_servername="" then
	choose case upper(uo_global.is_database)
		case c#connectivity.PRODUCTIONDB, ""
			// Production radio
			rb_prod.checked = true
		case else
			// Developer radio
			rb_develop.checked = true
	end choose		
else
	// Developer radio
	rb_develop.checked = true
end if

if rb_develop.checked then
	// Populate server and database text boxes
	dw_login.setitem(1, "db_name", uo_global.is_database)
	dw_login.setitem(1, "server_name", uo_global.is_servername)		
end if	

/* If the userid is one of the developers, default to the test tatabase environment */
if fileexists("c:\developer.ini") then
	rb_preproduction.checked = TRUE
	
	if profileString("c:\developer.ini","login","loginid", "") <> "" then
		uo_global.is_userid = profileString("c:\developer.ini","login","loginid", "")
		dw_login.setitem(1, "user_id", uo_global.is_userid)
	end if
	
	dw_login.setitem(1, "password", profileString("c:\developer.ini","login","password", ""))
	dw_login.setitem(1, "db_name", profileString("c:\developer.ini","login","database", uo_global.is_database))
	dw_login.setitem(1, "server_name", profileString("c:\developer.ini","login","servername", uo_global.is_servername))
	
	if profileString("c:\developer.ini","login","database","") <> "" and profileString("c:\developer.ini","login","servername", "") <> "" then rb_develop.checked = true
	
	/* If the user holds the shift-key down, the application will not login automatically */
	if not keyDown(keyShift!) then cb_login.postevent(clicked!)
end if

/* set focus */
if trim(uo_global.is_userid)="" then
	// do nothing
elseif trim(uo_global.is_password)="" then
	dw_login.setcolumn("password")                  
end if
end event

on w_login.create
int iCurrent
call super::create
this.cb_options=create cb_options
this.cb_cancel=create cb_cancel
this.cb_login=create cb_login
this.dw_login=create dw_login
this.rb_test=create rb_test
this.rb_develop=create rb_develop
this.rb_preproduction=create rb_preproduction
this.rb_prodbackup=create rb_prodbackup
this.rb_prod=create rb_prod
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_options
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_login
this.Control[iCurrent+4]=this.dw_login
this.Control[iCurrent+5]=this.rb_test
this.Control[iCurrent+6]=this.rb_develop
this.Control[iCurrent+7]=this.rb_preproduction
this.Control[iCurrent+8]=this.rb_prodbackup
this.Control[iCurrent+9]=this.rb_prod
end on

on w_login.destroy
call super::destroy
destroy(this.cb_options)
destroy(this.cb_cancel)
destroy(this.cb_login)
destroy(this.dw_login)
destroy(this.rb_test)
destroy(this.rb_develop)
destroy(this.rb_preproduction)
destroy(this.rb_prodbackup)
destroy(this.rb_prod)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_login
end type

type cb_options from commandbutton within w_login
integer x = 795
integer y = 1064
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Options >>"
end type

event clicked;If right(this.text,2) = ">>" then
	this.text = "&Options <<"
else
	this.text = "&Options >>"
end if

wf_options()
end event

type cb_cancel from commandbutton within w_login
integer x = 448
integer y = 1064
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;// Cb_cancel.Clicked! -> close window and return
CloseWithReturn (parent, is_Login)
end event

type cb_login from commandbutton within w_login
integer x = 101
integer y = 1064
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Login"
boolean default = true
end type

event clicked;/********************************************************************
   <DESC>   </DESC>
   <RETURN>	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>  </ARGS>
   <USAGE> </USAGE>
	<HISTORY> 
		Date    		CR-Ref		Author		Comments
		01/09/10		CR2115		Joana 		Carvalho	Delete table USERPATH_DELME
		25/04/13		CR3158		WWA048		Update the UI of login window.
		08/10/14		CR2831		SSX014		Only test users are allowed to login when releasing
		16/06/15		CR3694		XSZ004		Change password every 90 days instead of 30 days.
	</HISTORY>   
********************************************************************/

Integer  li_pc_nr,li_security, li_locked
integer  li_current_version, li_this_version
String   ls_sql, ls_userid, ls_psw, ls_new_password, ls_email, ls_email_ad
String   ls_groupname, ls_newversion, ls_current_version, ls_this_version, ls_clienttype
boolean  lb_deleted
decimal  ldec_downtime
long     ll_releaseid
datetime ldt_pw_changed, ldt_dummy
datetime ldt_begintime, ldt_endtime

mt_n_stringfunctions lnv_strfunc
mt_n_activedirectoryfunctions	lnv_adfunc

dw_login.accepttext()

ldt_dummy = datetime(date("01-01-1900"))

ls_userid = dw_login.getitemstring(1, "user_id")
ls_psw = dw_login.getitemstring(1, "password")

if trim(ls_userid) = "" then
	messagebox("Logon", "User ID is missing.~n~nPlease enter the User ID and click OK to continue.")
	dw_login.setfocus()
	dw_login.setcolumn("user_id")
	return
elseif trim(ls_psw) = "" then
	messagebox("Logon", "Password is missing.~n~nPlease enter the password and click OK to continue.")
	dw_login.setfocus()
	dw_login.setcolumn("password")
	return
end if

If Upper(ls_userid) <> "SA" then ls_userid = Upper(ls_userid)

uo_global.is_userid = ls_userid
uo_global.is_password = ls_psw

if wf_load_systemVars(uo_global.is_servername, uo_global.is_database, uo_global.is_dbms)=-1 then return

/* use line below instead of one used to trace transaction process */
SQLCA.dbms       = uo_global.is_dbms
SQLCA.Database	  = uo_global.is_database
SQLCA.Servername = uo_global.is_servername
SQLCA.UserID	  = uo_global.is_userid
SQLCA.DBPass     = uo_global.is_password
SQLCA.Logid      = uo_global.is_userid
SQLCA.LogPass    = uo_global.is_password
SQLCA.Dbparm     = "OJSyntax='PB', release = '15'"  //release = 15 is to tell PB to use open client 15 instead of 12
																//denne parameter er tilføjet for at eliminere fejl angående ansi sql-92
																
//Activate UTF8
if uo_global.utf8flag <> "" then 
	SQLCA.Dbparm = SQLCA.Dbparm + "," + uo_global.utf8flag + ", Appname='TramosApp', host='TramosApp'"
end if
	
CONNECT USING SQLCA;	

If SQLCA.SQLCode <> 0 THEN 
	If ii_attempts < 4 Then
		beep(3) 
		messagebox("Database Error","Could not attach to Database. ~r~r~nAre you on the network, and have you typed userid and password correct ?"+ &
			"~r~n~r~nMessage: " + SQLCA.SQLErrText)
		ii_attempts ++
		dw_login.setcolumn("user_id")
	else
		// If more the 5 login attempts, the userid is locked
		// and must be reopened by sysadmin. Hereafter login is cancelled 
		// and window closed 
		SQLCA.UserID	= uo_global.gs_checkid
		SQLCA.DBPass	= uo_global.gs_checkpw
		SQLCA.Logid		= uo_global.gs_checkid
		SQLCA.LogPass	= uo_global.gs_checkpw
		
		CONNECT USING SQLCA;	
		UPDATE USERS SET LOCKED = 1, PW_LAST_CHANGED = "01-01-2000" WHERE USERID = :uo_global.is_userid USING SQLCA;
		COMMIT USING SQLCA;
		DISCONNECT USING SQLCA;
		messagebox("Database Error","Could not attach to Database. ~r~r~nYour user account will be locked and the application will close down! ~r~r~nPlease contact System Administrator to open account")
		closewithreturn ( parent, is_login )
	end if
	return
end if

// Check if user is marked deleted or locked. If Yes, disconnect the User, and return
SELECT DELETED, LOCKED, isnull(PW_LAST_CHANGED, "01-01-1900"), isnull(EMAIL, "") into :lb_deleted, :li_locked, :ldt_pw_changed, :ls_email  from USERS where USERID = :uo_global.is_userid;
if lb_deleted then
	messagebox("Access Denied", "Your user profile has been deleted. Please contact Service Desk to re-instate your profile.")
	ii_attempts ++
	dw_login.setcolumn("user_id")
	DISCONNECT USING SQLCA;
	return         
end if

/* Verify email address is the one stored in the AD */
if lnv_adfunc.of_get_email_by_userid_from_ad(uo_global.is_userid, ls_email_ad) <> c#return.Failure then
	if ls_email<>ls_email_ad then
		UPDATE USERS SET EMAIL = :ls_email_ad WHERE USERID = :uo_global.is_userid;
		COMMIT;
	end if
end if	

if li_locked=1 then
	messagebox("Access Denied", "Your user profile is currently locked.~n~nPlease use the 'I forgot my password...' link to reset your password and unlock your user profile.~n~nA new password will be sent by email.")
	ii_attempts ++
	dw_login.setcolumn("user_id")
	DISCONNECT USING SQLCA;
	return   	
end if

// Check if there is a new verion that is being released
if uo_global.getnewversion(ldt_begintime, ldt_endtime, &
	ldec_downtime, ll_releaseid, ls_newversion ) then
	if not uo_global.istestuser(ll_releaseid) then
		DISCONNECT USING SQLCA;
		MessageBox( "Tramos", "Tramos is not available due to system update. The downtime is expected to be completed on " &
			+ string (ldt_endtime, "dd-mm-yy") + " at " + string(ldt_endtime, "hh:mm") + " CET.")
		return
	end if
end if

// Check if password is expired.
// Password must be changed once a month
if daysafter(date(ldt_pw_changed), today()) > 90 & 
	and uo_global.is_userid <> "sa" and ldt_dummy <> ldt_pw_changed then
	
	openwithparm(w_login_changepassword, uo_global.is_userid + "," + uo_global.is_password)
	ls_new_password = message.stringParm
	
	if ls_new_password <> "NULL" then
		uo_global.is_password = ls_new_password
		dw_login.setitem(1, "password", ls_new_password)
	else
		DISCONNECT USING SQLCA;
		return         
	end if
end if

// Check if user is running the latest version, otherwise give user a Message
// that he/she needs to update before continuing
ls_this_version = uo_global.getProgramVersion()	
SELECT CURRENT_VERSION INTO :ls_current_version FROM TRAMOS_VERSION;
COMMIT;

if lower(ls_current_version) <> "all" then   /* if version = 'All', no check at all */
	li_current_version = integer(lnv_strfunc.of_replace(ls_current_version, ".", ""))
	li_this_version = integer(lnv_strfunc.of_replace(ls_this_version, ".", ""))
	ls_clienttype = trim(left(uo_global.is_clienttype,50))
	
	if li_this_version < li_current_version then
		DISCONNECT USING SQLCA;
		MessageBox("Wrong version", "Current version of TRAMOS is " + ls_current_version +&
						"~r~r~nYour version of TRAMOS is " + ls_this_version +&
						"~r~r~nPlease upgrade to Current version and try again", StopSign!)
		CloseWithReturn ( parent, is_login )
		return
	end if
end if

UPDATE USERS SET TRAMOS_VERSION = :ls_this_version, LASTLOGINFROM = 0, LASTLOGIN=getdate(), CLIENT_LASTUSED=:ls_clienttype WHERE USERID = :uo_global.is_userid;
COMMIT;

// When loggin in to SQL-server, set uo_global data, and get grouplevel from SQL-server
uo_global.SetUserid(ls_userid)
uo_global.SetPassword(ls_psw)

//CR1573 Begin added by RJH022 on 2011-10-20
SELECT USERS.USER_GROUP,   
		 USERS_PROFITCENTER.PC_NR  
  INTO :li_security,
  		 :li_pc_nr
  FROM USERS,   
	    USERS_PROFITCENTER
 WHERE USERS_PROFITCENTER.USERID = USERS.USERID  
   AND USERS_PROFITCENTER.PRIMARY_PROFITCENTER = 1
   AND USERS.USERID = :ls_userid;  
commit;

if li_security = c#usergroup.#EXTERNAL_APM then
	// does user only have web access?
	if wf_getwebuserflag( )=1 then
		wf_opentramosonline()
		CloseWithReturn ( parent, is_login )
		Return		
	end if
	gb_external_apm = true
end if
//End added by RJH022 on 2011-10-20

If ls_userid = "sa" then li_security = c#usergroup.#ADMINISTRATOR
 
uo_global.ii_access_level = li_security
uo_global.set_profitcenter_no(li_pc_nr)    //Primary Profitcenter

SELECT USER_PROFILE 
  INTO :uo_global.ii_user_profile
  FROM USERS
 WHERE USERID = :uo_global.is_userid;
COMMIT;

/* if administrator(3), external APM(-1) or finance profile(3), update access to all profitccenters */
if uo_global.ii_access_level = 3 &			
or uo_global.ii_access_level = -1 &		
or uo_global.ii_user_profile = 3 then		
	INSERT INTO USERS_PROFITCENTER (USERID, PC_NR)
		  SELECT :uo_global.is_userid,
		  			PC_NR 
		    FROM PROFIT_C 
		   WHERE PC_NR NOT IN (SELECT PC_NR 
									    FROM USERS_PROFITCENTER
									   WHERE USERID = :uo_global.is_userid);
	commit;								
end if

is_login.return_userid = ls_userid 

CloseWithReturn ( parent, is_login )

end event

type dw_login from datawindow within w_login
integer width = 2743
integer height = 1604
integer taborder = 10
string title = "none"
string dataobject = "d_ex_ff_login"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;if dwo.name = "st_forgotten" then
	string ls_userid
	
	n_passwordreset lnv_reset
	
	//Verify if user means the reset 
	if MessageBox("Reset Password", "Are you sure you will reset your TRAMOS password?", question!, yesno!,2) = 2 then return
	
	if wf_load_systemVars(uo_global.is_servername, uo_global.is_database, uo_global.is_dbms)=-1 then return
	
	lnv_reset = create n_passwordreset
	
	ls_userid = dw_login.getitemstring(1, "user_id")
	if lnv_reset.of_resetpassword(ls_userid) = 1 then 
		Messagebox("Reset Password", "Password is changed!~r~n~r~nYou will receive the new password by mail within the next few minutes.")
	end if
	
	destroy lnv_reset
end if




end event

type rb_test from radiobutton within w_login
boolean visible = false
integer x = 1458
integer y = 868
integer width = 512
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Test"
end type

event clicked;dw_login.modify("server_name.protect = 1")
dw_login.modify("db_name.protect = 1")

dw_login.modify("server_name.color = '" + string(c#color.DisabledText) + "'")
dw_login.modify("db_name.color = '" + string(c#color.DisabledText) + "'")

end event

type rb_develop from radiobutton within w_login
boolean visible = false
integer x = 1458
integer y = 948
integer width = 512
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Developer"
end type

event clicked;dw_login.modify("server_name.protect = 0")
dw_login.modify("db_name.protect = 0")

dw_login.modify("server_name.color = '" + string(c#color.Black) + "'")
dw_login.modify("db_name.color = '" + string(c#color.Black) + "'")

end event

type rb_preproduction from radiobutton within w_login
boolean visible = false
integer x = 1458
integer y = 788
integer width = 512
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Pre-Production"
end type

event clicked;dw_login.modify("server_name.protect = 1")
dw_login.modify("db_name.protect = 1")

dw_login.modify("server_name.color = '" + string(c#color.DisabledText) + "'")
dw_login.modify("db_name.color = '" + string(c#color.DisabledText) + "'")
end event

type rb_prodbackup from radiobutton within w_login
boolean visible = false
integer x = 1458
integer y = 708
integer width = 512
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Stand-by"
end type

event clicked;dw_login.modify("server_name.protect = 1")
dw_login.modify("db_name.protect = 1")

dw_login.modify("server_name.color = '" + string(c#color.DisabledText) + "'")
dw_login.modify("db_name.color = '" + string(c#color.DisabledText) + "'")

end event

type rb_prod from radiobutton within w_login
boolean visible = false
integer x = 1458
integer y = 628
integer width = 512
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 553648127
string text = "Production"
boolean checked = true
end type

event clicked;dw_login.modify("server_name.protect = 1")
dw_login.modify("db_name.protect = 1")

dw_login.modify("server_name.color = '" + string(c#color.DisabledText) + "'")
dw_login.modify("db_name.color = '" + string(c#color.DisabledText) + "'")

end event

