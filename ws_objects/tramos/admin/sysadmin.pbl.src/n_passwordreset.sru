$PBExportHeader$n_passwordreset.sru
$PBExportComments$This component is for resetting the password from the user site
forward
global type n_passwordreset from nonvisualobject
end type
end forward

global type n_passwordreset from nonvisualobject
end type
global n_passwordreset n_passwordreset

type variables
transaction	itr_password
end variables

forward prototypes
private function string of_generatepassword ()
public function integer of_resetpassword (string as_userid)
public subroutine documentation ()
private function integer of_resetpassword (string as_userid, ref transaction atr_trans)
end prototypes

private function string of_generatepassword ();string 	ls_upper[26] = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"} 
string 	ls_lower[26] = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"} 
string		ls_number[21] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "(", ")", "+", "-", "*", "<", ">", "/", "[", "]"}

long 	ll_rows, ll_row
string	ls_pw=""

randomize (0)

// gererate password of 8 characters
for ll_row = 1 to 8
	choose case rand(3)
		case 1 
			//Uppercase letter
			ls_pw += ls_upper[rand(26)]
		case 2
			//Lowercase letter
			ls_pw += ls_lower[rand(26)]
		case 3
			//Number or Special Character
			ls_pw += ls_number[rand(21)]
	end choose	
next

RETURN ls_pw
end function

public function integer of_resetpassword (string as_userid);ulong			lul_dbhandle
boolean		lb_connected
transaction	ltr_trans

// Check if sqlca already connected
lul_dbhandle = sqlca.dbhandle()
if isNull(lul_dbhandle) or lul_dbhandle < 1 then
	lb_connected = FALSE
else
	lb_connected = TRUE
end if	

if lb_connected then
	// user SQLCA
	ltr_trans = create transaction
	ltr_trans.DBMS 			= SQLCA.DBMS
	ltr_trans.Database 		= SQLCA.Database
	ltr_trans.ServerName 	= SQLCA.ServerName
	ltr_trans.Dbparm 			= "OJSyntax='PB', release = '15', appname='TramosApp' , host='TramosApp' " 
	//Activate UTF8
	if uo_global.utf8flag <> "" then 
		//messagebox("Test Warning", "UTF8")
		ltr_trans.Dbparm 		= ltr_trans.Dbparm + ","+ uo_global.utf8flag 
	end if
	ltr_trans.Logid        		= "resetPassword"  //hardcoded - must exist in DB
	ltr_trans.userid       		= "resetPassword"  //hardcoded - must exist in DB
	ltr_trans.LogPass   		= "drowssaPteser"  //hardcoded
	ltr_trans.dbpass  			= "drowssaPteser"  //hardcoded
	ltr_trans.autocommit		= false
	
	CONNECT USING ltr_trans ;	
	if ltr_trans.sqlcode <> 0 then
		MessageBox("Reset Password", "Error connecting to database. Password can't be reset. Contact system administartor")
		return -1
	end if
	
	of_resetpassword( as_userid, ltr_trans )
	
	DISCONNECT USING ltr_trans;
else
	
	// user SQLCA
	SQLCA.DBMS 			= uo_global.is_dbms
	SQLCA.Database 		= uo_global.is_database
	SQLCA.ServerName 	= uo_global.is_servername
	SQLCA.Dbparm 		= "OJSyntax='PB', release = '15', appname='TramosApp' , host='TramosApp' " 
	//Activate UTF8
	if uo_global.utf8flag <> "" then 
		//messagebox("Test Warning", "UTF8")
		SQLCA.Dbparm 		= SQLCA.Dbparm + ","+ uo_global.utf8flag
	end if
	SQLCA.Logid        		= "resetPassword"  //hardcoded - must exist in DB
	SQLCA.userid       		= "resetPassword"  //hardcoded - must exist in DB
	SQLCA.LogPass   		= "drowssaPteser"  //hardcoded
	SQLCA.dbpass  		= "drowssaPteser"  //hardcoded
	SQLCA.autocommit	= false
	
	CONNECT USING SQLCA;	
	if SQLCA.sqlcode <> 0 then
		MessageBox("Reset Password", "Error connecting to database. Password can't be reset. Contact system administartor")
		return -1
	end if

	of_resetpassword( as_userid, SQLCA )

	DISCONNECT USING SQLCA;
end if

return 1
end function

public subroutine documentation ();/********************************************************************
   n_passwordReset: Object used to reset the users password
   <OBJECT> This object is used to reset the users password, unlock the user,
	generate a new password and generate a mail that will be sent to the requesting user
	including the new password. Password will only be valid once (has to be changed on first login)
	
	This object requires a DB userid that is assigned 'sso_role'
	( right now the userid = 'resetPassword' and password='drowssaPteser' )
	
	To use this object instantiate it and call the function of_resetPassword( /*string as_userid */)
	</OBJECT>
   <DESC> Event Description </DESC>
   <USAGE>  mt_n_mail - to generate the mail to the user </USAGE>

  Date   		Ref    		Author        Comments
  10/03/09 		#1536     RMO003     First Version
  15/05/13		2690		LGX001		1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
												2.change "@maersk.com" 			 as C#EMAIL.DOMAIN 
  29/03/16		CR4316	AGL027		Use db's AD reference for forgotten password email address 												
********************************************************************/

end subroutine

private function integer of_resetpassword (string as_userid, ref transaction atr_trans);string						ls_password, ls_sql, ls_errormessage, ls_useremail=""
long						ll_counter
mt_n_outgoingmail	lnv_mail
mt_n_activedirectoryfunctions lnv_adfunc




//Verify USERID
SELECT count(*)
	INTO :ll_counter
	FROM USERS
	WHERE USERID = :as_userid
	USING atr_trans;
if ll_counter	<> 1 then
	MessageBox("Reset Password", "Entered user ID does not exist. Please enter correct userID.")
	DISCONNECT USING atr_trans;
	return -1
end if

ls_password = of_generatepassword( )

// Enable auto Commit, needed for sp_xx procedures 
atr_trans.AutoCommit = TRUE

//set new password
ls_sql = 'sp_password "'+atr_trans.LogPass+'", "'+ls_password+'", '+as_userid
EXECUTE IMMEDIATE :ls_sql USING atr_trans;

if atr_trans.SqlCode <> 0 then
	Messagebox("Reset Password", "Password Change failed: "+ atr_trans.sqlerrtext )
	DISCONNECT USING atr_trans;
	return -1
end if
COMMIT USING atr_trans;

// Disable auto Commit, needed for sp_xx procedures 
atr_trans.AutoCommit = FALSE
COMMIT USING atr_trans;
// Set password last Changed variabel, and unlock user
UPDATE USERS
	SET PW_LAST_CHANGED = "1. january 2000",
	LOCKED = 0
	WHERE USERID = :as_userid
	USING atr_trans;

if atr_trans.SqlCode <> 0 then
	Messagebox("Reset Password", "Update of USERS table failed: "+ atr_trans.sqlerrtext )
	ROLLBACK USING atr_trans;
	DISCONNECT USING atr_trans;
	return -1
end if

COMMIT USING atr_trans;



lnv_mail = create mt_n_outgoingmail

ls_useremail = lnv_adfunc.of_get_email_by_userid_from_db( as_userid) 
if ls_useremail="" then
	ls_useremail = as_userid + C#EMAIL.DOMAIN
end if

if lnv_mail.of_createmail(C#EMAIL.TRAMOSSUPPORT, ls_useremail, "TRAMOS Password Changed", "Your TRAMOS password is now: "+ls_password+"~r~n~r~nThis e-mail is generated automatically, please do not reply.~r~nIf you have any questions regarding this e-mail, please contact " + C#EMAIL.TRAMOSSUPPORT + "." , ls_errorMessage ) = -1 then
	messageBox("Reset password", "Reset password failed. Message = "+ls_errorMessage)
	ROLLBACK USING atr_trans;
	destroy lnv_mail
	DISCONNECT USING atr_trans;
	return -1
end if

if lnv_mail.of_setCreator( as_userid, ls_errorMessage ) = -1 then
	messageBox("Reset password", "Reset password failed. Message = "+ls_errorMessage)
	ROLLBACK USING atr_trans;
	destroy lnv_mail
	DISCONNECT USING atr_trans;
	return -1
end if

if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
	messageBox("Reset password", "Reset password failed. Message = "+ls_errorMessage)
	ROLLBACK USING atr_trans;
	destroy lnv_mail
	DISCONNECT USING atr_trans;
	return -1
end if

COMMIT USING atr_trans;
	
destroy lnv_mail



end function

on n_passwordreset.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_passwordreset.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;itr_password = create transaction
end event

event destructor;destroy itr_password 
end event

