$PBExportHeader$n_sysadmin.sru
forward
global type n_sysadmin from mt_n_nonvisualobject
end type
end forward

global type n_sysadmin from mt_n_nonvisualobject
end type
global n_sysadmin n_sysadmin

forward prototypes
public function integer of_add_role (string as_userid, string as_role, boolean ab_default, ref transaction atr_transaction)
public function integer of_revoke_roles_access (string as_userid, ref transaction atr_transaction)
public function integer of_drop_user (string as_userid, ref transaction atr_transaction)
public subroutine documentation ()
public function integer of_isuseronline (string as_userid)
public function integer of_create_user (string as_userid, string as_fullname, ref transaction atr_transaction)
public function integer of_change_group (string as_userid, ref transaction atr_transaction)
end prototypes

public function integer of_add_role (string as_userid, string as_role, boolean ab_default, ref transaction atr_transaction);/********************************************************************
of_add_role
   <DESC> Add a user role and define default value </DESC>
   <RETURN> 
		c#return.success:		ok
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>
	as_userid: user id
	as_role: database role name (e.g. TRAMOSUSER, DEVELOPER, SUPPORT)
	ab_default: true if role is active by default
	atr_transaction: transaction (usually with autocommit = true)
   </ARGS>
   <USAGE>	Used to grant a specific role to a user
	</USAGE>
********************************************************************/

string	ls_dbline

ls_dbline = "grant role " + as_role + " to "+as_userid
EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;

if atr_transaction.SqlCode <> 0 then return c#return.failure

if ab_default = true then
	ls_dbline = "sp_modifylogin "+as_userid+", 'add default role', " + as_role
else
	ls_dbline = "sp_modifylogin " + as_userid + ", 'drop default role'," + as_role
end if

EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;

return c#return.success
end function

public function integer of_revoke_roles_access (string as_userid, ref transaction atr_transaction);/********************************************************************
of_revoke_roles_access
   <DESC> Revokes access to all the roles that the user has access to </DESC>
   <RETURN> 
		c#return.success:		ok
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>
	as_userid: user id
	atr_transaction: transaction (usually with autocommit = true)
   </ARGS>
   <USAGE>	Used to change clean all roles that user has access when user role changes
	</USAGE>
********************************************************************/
mt_n_datastore	lds_roles
long	ll_row, ll_rows
string	ls_role_revoke, ls_sql
integer	ll_return

ll_return = c#return.success

//Get list of all assigned roles and revoke access. Assures that a user has only one
lds_roles = create	mt_n_datastore
lds_roles.dataobject = "d_sq_tb_roles_user"
lds_roles.settransobject(atr_transaction)
ll_rows = lds_roles.retrieve(as_userid)
if ll_rows > 0 then
	for ll_row = 1 to ll_rows
		ls_role_revoke = lds_roles.getitemstring(ll_row, "role_name")
		ls_sql = "revoke role " + ls_role_revoke + " from " + as_userid
		EXECUTE IMMEDIATE :ls_sql USING atr_transaction;
		if atr_transaction.SqlCode <> 0 then
			ll_return = c#return.failure
			//Messagebox("Role", "Error revoking access for user " &
			//	+ sle_Userid.text + ".~r~rReason:~r"+is_userdata.SQLchangeuser.SqlErrText &
			//	+" "+String(is_userdata.SQLchangeuser.sqlCode), Information!, OK!)
		end if
	next
end if

destroy(lds_roles)

return ll_return
end function

public function integer of_drop_user (string as_userid, ref transaction atr_transaction);/********************************************************************
of_create_user
   <DESC> Drops user from database </DESC>
   <RETURN> 
		c#return.success:		ok
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>
	as_userid: user id
	atr_transaction: transaction (usually with autocommit = true)
   </ARGS>
   <USAGE>	Used to create drop a user in case user creation fails
	</USAGE>
********************************************************************/	

string	ls_dbline

ls_dbline = 'sp_dropuser '+as_userid+'"'
EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;
if atr_transaction.SqlCode <> 0 then
	return c#return.failure
end if

ls_dbline = 'sp_droplogin '+as_userid+'"'
EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;
if atr_transaction.SqlCode <> 0 then
	return c#return.failure
end if

return c#return.success



end function

public subroutine documentation ();/********************************************************************
   n_sysadmin: Non-Visual object to manage user database related tasks
   <OBJECT> Handles functions for creation of logins and users </OBJECT>
   <DESC>   
	
	</DESC>
   <USAGE>  w_sysadmin_edit_single_user</USAGE>
   <ALSO>  </ALSO>
   	Date   	Ref    		Author        Comments
  		09/06/11 CR2460     	JMC112        First Version
  		20/10/11	CR1573		RJH022		  add users group for not visited sysusers	
********************************************************************/
end subroutine

public function integer of_isuseronline (string as_userid);/********************************************************************
of_isuseronline
   <DESC> Checks if user is online </DESC>
   <RETURN> 
		c#return.success:		user is online
		c#return.failure:	user is offline
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>
	as_userid: user id
   </ARGS>
   <USAGE>	Used to check if user is online before changing user/group access
	</USAGE>
********************************************************************/
mt_n_datastore	lds_data
integer	li_res

lds_data = create mt_n_datastore
lds_data.dataObject = "d_sq_tb_active_users"
lds_data.setTransObject(SQLCA)
lds_data.setfilter("name='" + as_userid + "'")
lds_data.filter()

lds_data.retrieve()
if lds_data.rowcount() = 1 then
	li_res=c#return.success
else
	li_res =c#return.failure
end if

destroy lds_data

return li_res
end function

public function integer of_create_user (string as_userid, string as_fullname, ref transaction atr_transaction);/********************************************************************
of_create_user
   <DESC> Creates Login and database user </DESC>
   <RETURN> 
		c#return.success:		ok
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>
	as_userid: user id
	as_fullname: user full name
	as_groupname: group name in the tramos database
	atr_transaction: transaction (usually with autocommit = true)
   </ARGS>
   <USAGE>	Used to create a Tramos user
	</USAGE>
********************************************************************/		

constant string METHOD_NAME = "of_create_user"
string		ls_dbline 

ls_dbline = 'sp_addlogin '+as_userid+', Password1, @fullname = "'+as_fullname+'"'

EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;

if atr_transaction.SqlCode <> 0 Then return c#return.failure

ls_dbline = "sp_adduser "+as_userid+",  null, 'public' "

EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;

if atr_transaction.SqlCode <> 0 then
	//delete login
	ls_dbline = 'sp_droplogin '+as_userid+'"'
	EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;
	return c#return.failure
end if

return c#return.success
end function

public function integer of_change_group (string as_userid, ref transaction atr_transaction);/********************************************************************
of_change_group
   <DESC> Change user group in the TEST database </DESC>
   <RETURN> 
		c#return.success:		ok
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>
	as_userid: user id
	as_groupname: group name in the tramos database
	atr_transaction: transaction (usually with autocommit = true)
   </ARGS>
   <USAGE>	Used to change the database group that user belongs to
	</USAGE>
********************************************************************/

string	ls_dbline

ls_dbline = "sp_changegroup  'public',"+as_userid
EXECUTE IMMEDIATE :ls_dbline USING atr_transaction;

if atr_transaction.SqlCode <> 0 then return c#return.failure
		
return c#return.success
end function

on n_sysadmin.create
call super::create
end on

on n_sysadmin.destroy
call super::destroy
end on

