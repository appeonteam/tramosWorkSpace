$PBExportHeader$mt_n_activedirectoryfunctions.sru
$PBExportComments$General email functions
forward
global type mt_n_activedirectoryfunctions from mt_n_nonvisualobject
end type
end forward

global type mt_n_activedirectoryfunctions from mt_n_nonvisualobject autoinstantiate
end type

forward prototypes
public subroutine documentation ()
public function string of_get_email_by_userid_from_db (string as_userid)
public function integer of_get_email_by_userid_from_ad (string as_userid, ref string as_emailaddress)
public function integer of_get_property_by_userid_from_ad (string as_userid, string as_property, ref string as_value)
private function integer _query_ad_with_userid (string as_userid, string as_property, string as_defaultreturnvalue, ref string as_result)
end prototypes

public subroutine documentation ();/********************************************************************
   mt_n_activedirectoryfunctions: 
	
	<OBJECT>

	</OBJECT>
   <DESC>
		Contains all interfaces that Tramos needs to query Active Directory using LDAP.
	</DESC>
  	<USAGE>
	  	Introduced to locate user email addresses, but can provide more info

=====================================================================
	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	29/02/16 	?      	???				First Version (called mt_n_emailfunctions)
	18/04/16		CR4316	AGL027			Renamed object and minor modifications
********************************************************************/
end subroutine

public function string of_get_email_by_userid_from_db (string as_userid);/* 
get the passed userid's email string value that is stored in the database
calling functions must test for value "" if no AD email value has been located.
*/
string ls_email

SELECT EMAIL INTO :ls_email 
FROM USERS WHERE USERID=:as_userid;

if isnull(ls_email) then
	return ""
else
	return ls_email
end if
end function

public function integer of_get_email_by_userid_from_ad (string as_userid, ref string as_emailaddress);long ll_retval
ll_retval = _query_ad_with_userid( as_userid, "mail", as_userid + C#EMAIL.DOMAIN, as_emailaddress)
/* different logic here from returning a standard property value, as the email property is key to validating other items.
potential return values:
- 'The (SAMAccountName= ) search filter is invalid.' 
*/
if pos(as_emailaddress,"@")=0 then
	ll_retval = c#return.Failure
end if	
return ll_retval
end function

public function integer of_get_property_by_userid_from_ad (string as_userid, string as_property, ref string as_value);return _query_ad_with_userid( as_userid, as_property, "", as_value)
end function

private function integer _query_ad_with_userid (string as_userid, string as_property, string as_defaultreturnvalue, ref string as_result);
/********************************************************************
_query_ad_with_userid( /*string as_userid*/, /*string as_property*/, /*string as_defaultreturnvalue*/, /*ref string as_result */)

<DESC>
	general purpuse function that connects to InterOp .net 4.0 DLL assembly
	and obtains property requested.  Small logic in applying what deafult value
	should be used is also passed in.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
		<LI> 0, X No Action
		<LI> -1, X Failed
</RETURN>
<ACCESS>
	Private
</ACCESS>
<ARGS>
	as_userid					:user id that should be located in the AD
	as_property					:AD property first element; i.e. 'sn'=surname, 'givenname'=first name, 'mail'=email address
	as_defaultreturnvalue	:default value to use if we have an exception.  either "" or perhaps the user id concatenated with domain.  
	as_result					:if able to query the ad we should obtain the property value requested, otherwise deafult return value is used.
</ARGS>
<USAGE>
native call to .net DLL
attempts to get userid from AD (CRB domain) if unable to locate it will return the userid passsed with constant domain
PROG ID = {FA2798A5-7C80-4F42-A648-23B5FF3F5FA5}
</USAGE>
********************************************************************/

long  ll_retconncode
string ls_value
oleobject ole_adtools

ole_adtools = create oleobject
ll_retconncode = ole_adtools.connecttonewobject ( "mtdotnet.adtools" )
if ll_retconncode <> 0 then
	as_result = as_defaultreturnvalue
	return c#return.Failure
end if	
as_result = ole_adtools.getPropertyFromAD (as_userid, as_property, C#EMAIL.LDAPADDRESS )
ole_adtools.DisconnectObject()
destroy ole_adtools

/* handle single exception for all properties if not finding userid in AD result by returning the default value. */
if mid(as_result,1,9)="Index was" then
	as_result = as_defaultreturnvalue
	return c#return.NoAction
end if

return c#return.Success
end function

on mt_n_activedirectoryfunctions.create
call super::create
end on

on mt_n_activedirectoryfunctions.destroy
call super::destroy
end on

