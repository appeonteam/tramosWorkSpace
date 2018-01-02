$PBExportHeader$n_app.sru
forward
global type n_app from nonvisualobject
end type
end forward

global type n_app from nonvisualobject autoinstantiate
event ue_open ( )
end type

type variables
private:
string is_configfile = 'release_mgr.ini'
string is_loginsection = "login"
public:
constant long MT_FORMDETAIL_BG = rgb(236,236,236)
constant long MT_MAERSK = rgb(152,217,228)

end variables

forward prototypes
public function integer of_autocreateconfigfile ()
public function boolean of_autologin ()
public function boolean of_login (stru_authinfo s_authinfo, ref string errmsg)
public function boolean of_login (stru_authinfo s_authinfo)
public function integer of_loadloginfo (ref stru_loginfo s_loginfo)
public function integer of_saveloginfo (stru_loginfo s_loginfo)
end prototypes

event ue_open();
if of_autologin() then
	open (w_main)
end if

end event

public function integer of_autocreateconfigfile ();long ll_fileid

if not fileexists(is_configfile) then
	ll_fileid = FileOpen(is_configfile, TextMode!, Write!)
	if ll_fileid <> -1 then
		FileWrite (ll_fileid, "["+is_loginsection+"]" )
		FileClose (ll_fileid)
		return 1
	end if
end if

return -1

end function

public function boolean of_autologin ();
boolean lb_opendlg = false
stru_loginfo s_loginfo

of_autocreateconfigfile()
of_loadloginfo(s_loginfo)

if isnull(s_loginfo.s_authinfo.servername) or len(s_loginfo.s_authinfo.servername) = 0 or &
	isnull(s_loginfo.s_authinfo.database) or len(s_loginfo.s_authinfo.database) = 0 or &
	isnull(s_loginfo.s_authinfo.logid) or len(s_loginfo.s_authinfo.logid) = 0 or &
	isnull(s_loginfo.s_authinfo.pass) or len(s_loginfo.s_authinfo.pass) = 0 then
	lb_opendlg = true
else
	// Try to login
	if s_loginfo.s_loginoption.autologin then
		if not of_login(s_loginfo.s_authinfo) then
			lb_opendlg = true
		else
			return true
		end if
	else
		lb_opendlg = true
	end if
end if

if lb_opendlg then
	OpenWithParm (w_login, s_loginfo)
	return (message.doubleparm = 1)
end if

return false
end function

public function boolean of_login (stru_authinfo s_authinfo, ref string errmsg);
// Profile PROD_TRAMOS
SQLCA.DBMS = "ASE Adaptive Server Enterprise"
SQLCA.Database = s_authinfo.database
SQLCA.LogPass = s_authinfo.pass
SQLCA.ServerName = s_authinfo.servername
SQLCA.LogId = s_authinfo.logid
SQLCA.AutoCommit = False
SQLCA.DBParm = "utf8=1"

CONNECT;

errmsg = SQLCA.SQLErrText

return (SQLCA.SQLCode = 0)
end function

public function boolean of_login (stru_authinfo s_authinfo);
string ls_errmsg

return of_login(s_authinfo, ls_errmsg)
end function

public function integer of_loadloginfo (ref stru_loginfo s_loginfo);
n_string ln_string

s_loginfo.s_authinfo.servername = ProfileString ( is_configfile, is_loginsection, "servername", "" )
s_loginfo.s_authinfo.database = ProfileString ( is_configfile, is_loginsection, "database", "" )
s_loginfo.s_authinfo.logid = ProfileString ( is_configfile, is_loginsection, "logid", "" )
s_loginfo.s_authinfo.pass = ProfileString ( is_configfile, is_loginsection, "password", "" )
s_loginfo.s_loginoption.autologin = ln_string.of_boolean(ProfileString ( is_configfile, is_loginsection, "autologin", "N" ))
s_loginfo.s_loginoption.rememberpass = ln_string.of_boolean(ProfileString ( is_configfile, is_loginsection, "rememberpassword", "N" ))

return 1

end function

public function integer of_saveloginfo (stru_loginfo s_loginfo);
long ll_rc1, ll_rc2, ll_rc3, ll_rc4, ll_rc5, ll_rc6

ll_rc1 = SetProfileString ( is_configfile, is_loginsection, "servername", s_loginfo.s_authinfo.servername )
ll_rc2 = SetProfileString ( is_configfile, is_loginsection, "database", s_loginfo.s_authinfo.database )
ll_rc3 = SetProfileString ( is_configfile, is_loginsection, "logid", s_loginfo.s_authinfo.logid )
ll_rc4 = SetProfileString ( is_configfile, is_loginsection, "password", s_loginfo.s_authinfo.pass )
ll_rc5 = SetProfileString ( is_configfile, is_loginsection, "autologin", string(s_loginfo.s_loginoption.autologin) )
ll_rc6 = SetProfileString ( is_configfile, is_loginsection, "rememberpassword", string(s_loginfo.s_loginoption.rememberpass) )

if ll_rc1 <> 1 or ll_rc2 <> 1 or ll_rc3 <> 1 or ll_rc4 <> 1 or ll_rc5 <> 0 or ll_rc6 <> 0 then
	return -1
end if

return 1

end function

on n_app.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_app.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

