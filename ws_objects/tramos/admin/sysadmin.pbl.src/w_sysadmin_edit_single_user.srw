$PBExportHeader$w_sysadmin_edit_single_user.srw
$PBExportComments$Edit a single user - this window gets called from editusers
forward
global type w_sysadmin_edit_single_user from mt_w_response
end type
type st_warning from statictext within w_sysadmin_edit_single_user
end type
type cb_clearpw from mt_u_commandbutton within w_sysadmin_edit_single_user
end type
type cb_ok from mt_u_commandbutton within w_sysadmin_edit_single_user
end type
type st_tperf from mt_u_statictext within w_sysadmin_edit_single_user
end type
type ddlb_tperf_access from mt_u_dropdownlistbox within w_sysadmin_edit_single_user
end type
type cbx_onlyweb from mt_u_checkbox within w_sysadmin_edit_single_user
end type
type st_8 from statictext within w_sysadmin_edit_single_user
end type
type dw_office from datawindow within w_sysadmin_edit_single_user
end type
type cb_unselectall from commandbutton within w_sysadmin_edit_single_user
end type
type cb_selectall from commandbutton within w_sysadmin_edit_single_user
end type
type dw_bu from datawindow within w_sysadmin_edit_single_user
end type
type st_7 from statictext within w_sysadmin_edit_single_user
end type
type cbx_sc from checkbox within w_sysadmin_edit_single_user
end type
type st_6 from statictext within w_sysadmin_edit_single_user
end type
type ddlb_profile from dropdownlistbox within w_sysadmin_edit_single_user
end type
type cbx_enter_frt_rec from checkbox within w_sysadmin_edit_single_user
end type
type cbx_salesperson from uo_cbx_base within w_sysadmin_edit_single_user
end type
type dw_groups from datawindow within w_sysadmin_edit_single_user
end type
type st_4 from statictext within w_sysadmin_edit_single_user
end type
type dw_profitcenterlist from datawindow within w_sysadmin_edit_single_user
end type
type sle_lastname from singlelineedit within w_sysadmin_edit_single_user
end type
type sle_firstname from singlelineedit within w_sysadmin_edit_single_user
end type
type sle_userid from singlelineedit within w_sysadmin_edit_single_user
end type
type st_5 from statictext within w_sysadmin_edit_single_user
end type
type st_3 from statictext within w_sysadmin_edit_single_user
end type
type st_2 from statictext within w_sysadmin_edit_single_user
end type
type st_1 from statictext within w_sysadmin_edit_single_user
end type
type st_emailtitle from statictext within w_sysadmin_edit_single_user
end type
type st_email from statictext within w_sysadmin_edit_single_user
end type
type cb_possess from mt_u_commandbutton within w_sysadmin_edit_single_user
end type
end forward

global type w_sysadmin_edit_single_user from mt_w_response
integer x = 608
integer y = 504
integer width = 2496
integer height = 2376
string title = "Create user"
long backcolor = 81324524
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve pbm_custom21
st_warning st_warning
cb_clearpw cb_clearpw
cb_ok cb_ok
st_tperf st_tperf
ddlb_tperf_access ddlb_tperf_access
cbx_onlyweb cbx_onlyweb
st_8 st_8
dw_office dw_office
cb_unselectall cb_unselectall
cb_selectall cb_selectall
dw_bu dw_bu
st_7 st_7
cbx_sc cbx_sc
st_6 st_6
ddlb_profile ddlb_profile
cbx_enter_frt_rec cbx_enter_frt_rec
cbx_salesperson cbx_salesperson
dw_groups dw_groups
st_4 st_4
dw_profitcenterlist dw_profitcenterlist
sle_lastname sle_lastname
sle_firstname sle_firstname
sle_userid sle_userid
st_5 st_5
st_3 st_3
st_2 st_2
st_1 st_1
st_emailtitle st_emailtitle
st_email st_email
cb_possess cb_possess
end type
global w_sysadmin_edit_single_user w_sysadmin_edit_single_user

type prototypes
Function Long Sleep (ulong millsecond) library "Kernel32.dll"
end prototypes

type variables
s_userdata is_userdata
n_ds	ids_users_profitcenter
n_sysadmin	inv_sysadmin
Integer ii_Tperf_Access = 1

long	il_profile_original, il_groupaccess_original
string	is_groupaccess_original

boolean	ib_profitcenter			//When change user's profit centers, it will be set to true
mt_n_datastore ids_uservessels

end variables

forward prototypes
public function integer wf_general_validation ()
public function integer wf_refresh_office ()
private function integer wf_createfailed (string as_userid)
public subroutine documentation ()
public function integer wf_edit_database_user ()
public function integer wf_rollback_databasechanges (boolean ab_newuser)
public function integer wf_setuservessels ()
public function string wf_getuservessels ()
public function integer wf_set_userdata (integer as_groupid)
public function integer wf_set_roles_profile (string as_userid, string as_role, long as_groupid, boolean ab_newuser)
public function integer wf_becomeuser ()
end prototypes

event ue_retrieve;long ll_count, ll_bu_id, ll_found

setredraw (false)

dw_profitcenterlist.settransobject(sqlca)
dw_groups.settransobject(sqlca)
dw_bu.settransobject(sqlca)
dw_profitcenterlist.retrieve()
dw_bu.retrieve()
dw_groups.retrieve()
//Added by RJH022 on 2011-10-29. Change desc: fix history bug.
ddlb_profile.selectitem(0)

ddlb_tperf_access.selectitem(ii_tperf_access)

//modify user
if is_userdata.userno<>0 then

	title = "Modify user"
	//lock user id field
	sle_userid.enabled=false
	sle_userid.backcolor = 16777215
	
	//in case user is online, then profile and group access cannot be changed
	if is_userdata.userlist.getitemnumber (  is_userdata.userno, "useronline") = 1 then
		st_warning.visible = true
		ddlb_profile.enabled = false
		dw_groups.enabled = false
	end if
	
	setfocus(sle_firstname)   
	
	sle_userid.text = is_userdata.userlist.getitemstring (  is_userdata.userno, "userid")
	sle_firstname.text = is_userdata.userlist.getitemstring (  is_userdata.userno, "first_name")
	sle_lastname.text = is_userdata.userlist.getitemstring (  is_userdata.userno, "last_name")
	st_email.text = is_userdata.userlist.getitemstring (  is_userdata.userno, "email")
	cbx_salesperson.checked = is_userdata.userlist.getitemnumber( is_userdata.userno, "users_sales_person") = 1 
	
	ids_users_profitcenter.retrieve(is_userdata.userlist.getitemstring (  is_userdata.userno, "userid"))
	// added by fr 15-08-02
	cbx_enter_frt_rec.checked = is_userdata.userlist.getitemnumber( is_userdata.userno, "users_enter_frt_rec") = 1 
	ii_tperf_access = is_userdata.userlist.getitemnumber( is_userdata.userno, "users_tperf_access") + 1
	ddlb_tperf_access.selectitem(ii_tperf_access)
	cbx_onlyweb.checked = is_userdata.userlist.getitemnumber( is_userdata.userno, "web_access_only") = 1
	cbx_sc.checked = is_userdata.userlist.getitemstring( is_userdata.userno, "users_sc") = "yes"
	
	ddlb_profile.selectitem(is_userdata.userlist.getitemnumber( is_userdata.userno, "users_user_profile" ))
	
	il_profile_original = is_userdata.userlist.getitemnumber( is_userdata.userno, "users_user_profile" )
	
	ll_bu_id = is_userdata.userlist.getitemnumber (  is_userdata.userno, "users_bu_id")
	
	//select group access
	for ll_count=1 to dw_groups.rowcount() 
		if dw_groups.getitemnumber(ll_count, "group_id") = is_userdata.userlist.getitemnumber(is_userdata.userno,"user_group") then
			dw_groups.scrolltorow (ll_count)
			dw_groups.selectrow (ll_count, true)
			dw_groups.setrow(ll_count)
			if dw_groups.getitemnumber(ll_count, "group_id")=c#usergroup.#EXTERNAL_APM then
				cbx_onlyweb.visible=true
			end if
			il_groupaccess_original = dw_groups.getitemnumber(ll_count, "group_id") 
			exit
		end if
	next
	
	//select profit centers
	dw_profitcenterlist.selectrow ( 0, false )
	for ll_count=1 to ids_users_profitcenter.rowcount()
		ll_found = dw_profitcenterlist.find("pc_nr="+string(ids_users_profitcenter.getitemnumber(ll_count, "pc_nr")), 1, 99999)
		if ll_found > 0 then
			dw_profitcenterlist.selectrow ( ll_found, true )
			dw_profitcenterlist.setitem(ll_found, "primary_profitcenter", ids_users_profitcenter.getitemnumber(ll_count, "primary_profitcenter"))
		end if
	next
	
	//select bussiness unit
	for ll_count=1 to dw_bu.rowcount()
		if dw_bu.getitemnumber(ll_count, "bu_id") = ll_bu_id then
			dw_bu.selectrow ( 0, false )
			dw_bu.selectrow ( ll_count, true )
			dw_bu.setrow ( ll_count )
			dw_bu.scrolltorow ( ll_count )
			exit
		end if
	next
	
	wf_refresh_office()
		
end if

setredraw( true )
end event

public function integer wf_general_validation ();// Check that userid, name, groupaccess, business unit and profitcenter is setup

long ll_row, ll_#ofPrimary=0, ll_counter = 0

// Userid
if sle_userid.text="" then
	MessageBox("Error", "Please enter user ID" )
	SetFocus(sle_userid)
	return -1
end if

// Firstname
if sle_firstName.text = "" then
	MessageBox("Error", "Please enter firstname" )
	SetFocus(sle_Firstname)
	return -1
end if

// Lastname
if sle_lastname.text = "" then
	MessageBox("Error", "Please enter lastname")
	SetFocus(sle_lastname)
	return -1
end if

// Fullname
if len(sle_firstname.text + " " + sle_lastname.text) > 30 then
	Messagebox("Validation error", "User Fullname (firstname + lastname) is more than 30 characters. Please abbreviate the names." )
	SetFocus(sle_Firstname)
	return -1
end if             

// Profile
if ddlb_profile.text = "" or isNull(ddlb_profile.text)  then
	MessageBox("Error", "Please select profile")
	SetFocus(ddlb_profile)
	return -1
end if

//If Profile is Developer or Support, Group Access is set to Administrator
if ddlb_profile.text="Developer" or ddlb_profile.text="Support" then
	ll_row = dw_groups.find("group_id = "+string(c#usergroup.#ADMINISTRATOR),1,dw_groups.rowcount())
	dw_groups.selectrow(0, false)
	dw_groups.selectrow(ll_row, true)
	dw_groups.setrow(ll_row)
end if

// Group Access
if dw_groups.GetSelectedRow(0) < 1 then
	MessageBox("Error","No group specified")
	SetFocus(dw_groups)
	return -1
end if

//Business Unit
if dw_bu.GetSelectedRow(0) < 1 then
	MessageBox("Error","No business unit specified")
	SetFocus(dw_bu)
	return -1
end if

//Profit center List
if dw_profitCenterList.GetSelectedRow (0) < 1 then
	MessageBox("Error", "Please select profitcenter")
	SetFocus(dw_profitCenterList)
	return -1
end if

// Check for primary PC
ll_row = -1 
do while ll_Row <> 0
	ll_Row = dw_profitcenterlist.getSelectedrow( ll_Row )
	if ll_Row > 0 then
		if dw_profitcenterlist.getItemNumber(ll_row, "primary_profitcenter") = 1 then ll_#ofPrimary ++
	end if	
loop
if ll_#ofPrimary <> 1 then
	MessageBox( "Validation Error", "Please select one Profit Center as primary")
	return -1
end if

/* if checkbox web&vims access hidden, but still checked, uncheck it */
if cbx_onlyweb.visible=false and cbx_onlyweb.checked then cbx_onlyweb.checked=false

/* If Newuser, check if userid already exists */
if is_userdata.userno = 0 then
	SELECT count(*) 
		INTO :ll_counter
		FROM USERS 
		WHERE USERID = :sle_userid.text
		using sqlca;
	commit using sqlca;	
	if ll_counter > 0 then
		Messagebox("User already exists", "The userid already exists in the USERS table " &
			+"in the TRAMOS database.~r~rIf the user has no rights to the database, then " &
			+"delete the user and re-try the create operation.", Exclamation!, OK!)
		SetFocus(sle_userid)
		return -1
	end if
end if

return 1

end function

public function integer wf_refresh_office ();integer li_cc, li_i
datawindowchild ldwc
integer	ii_pc[]

//reset array
ii_pc[ ] = {0}

li_cc=1
for li_i = 1 to dw_profitCenterList.rowcount( )
	if dw_profitCenterList.isselected( li_i ) then
		ii_pc[li_cc]=dw_profitCenterList.getitemnumber( li_i, "pc_nr")
		li_cc=li_cc+1
	end if
next
if li_cc>1 then

if is_userdata.userno > 0 then
  dw_office.dataobject = "d_office_user_pc"
  dw_office.settransobject(SQLCA)
   dw_office.getchild("office_nr", LDWC)
   LDWC.settransobject(SQLCA)
   LDWC.retrieve( ii_pc )
	if LDWC.rowcount( )>0 then
  dw_office.retrieve( sle_userid.text  )
end if
else
	dw_office.dataobject = "d_office_default"
	 dw_office.settransobject(SQLCA)
   	dw_office.getchild("office_nr", LDWC)
   	LDWC.settransobject(SQLCA)
  	 LDWC.retrieve( ii_pc )
	if LDWC.rowcount( )>0 then
  	dw_office.retrieve( ii_pc )
	end if
end if
else
	//dw_office.enabled=false
end if

return 0
end function

private function integer wf_createfailed (string as_userid);/* Function used to cleanup if the creation of new user failes */

long	ll_found, ll_rows, ll_row
string ls_filter

ll_found = is_userdata.userlist.find("userid='"+as_userid+"'",1, is_userdata.userlist.rowCount())
if ll_found > 0 then
	is_userdata.userlist.deleteRow(ll_found)
end if

ls_filter = "userid='"+as_userid+"'"
ids_users_profitcenter.setFilter(ls_filter)
ids_users_profitcenter.filter()
ll_rows = ids_users_profitcenter.rowCount()
for ll_row = 1 to ll_rows
	ids_users_profitcenter.deleteRow(1)
next

return 1


end function

public subroutine documentation ();/********************************************************************
   ObjectName: w_sysadmin_edit_single_user - Edit user
   <OBJECT> Edit user window 	</OBJECT>
   <USAGE> Used for creating and edition of users
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	      CR-Ref	 Author	Comments
   00/00/??		               	First Version
   06/06/11		CR2460	JMC112	Change window hierarchy and add Support and Developer Profile
   05/07/11 	CR2406   JMY014  	1 Create a new user: Select all vessels the user has access to by default.
											2 Edit a exist user: Refer to selected profit center list, re-build vessel selection.															
	07/09/11    CR2575				Allow only one primary profit center selection	
	20/10/11		CR1573	RJH022	add users group  not visited sysusers
	19/03/11		CR2728	CONASW	Removed automatic selection of all profit centers when external_apm is selected.
	28/01/13		CR2614	LHG008	Rename "Steering committee member" to "Business Superuser"
	28/09/15		CR4165	AGL027	Hashing past passwords in table.
	06/05/16		CR4316	AGL027	Obtain AD email address when new user is created. Display it also in window
	06/10/16		CR3754	AGL027	Single Sign On modifications - add new Become User feature for support of test procedures
</HISTORY>       
********************************************************************/
end subroutine

public function integer wf_edit_database_user ();/********************************************************************
wf_edit_database_user
   <DESC>Holds the database operations (login, user, roles)
	</DESC>
   <RETURN> 
		c#return.success:	ok, user created or changed
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS>   </ARGS>
   <USAGE>	Used to manage changes that are database related. Autocommit shoud be True
	</USAGE>
********************************************************************/

constant string method_name = ""

string		ls_userid, ls_fullname, ls_role
long		ll_profile, ll_return, ll_groupid
boolean	lb_addrole, lb_newuser

ls_userid = sle_userid.text
ls_fullname = sle_firstname.text + " " + sle_lastname.text


ll_groupid = dw_groups.getitemnumber(dw_groups.getselectedrow(0), "group_id" ) 


ll_profile = ddlb_profile.finditem(ddlb_profile.text, 0)
choose case  ll_profile
	case 4
		ls_role = "DEVELOPER"
	case 5
		ls_role = "SUPPORT"
	case else
		ls_role = "TRAMOSUSER"
end choose

lb_addrole = false

if is_userdata.userno > 0 then lb_newuser = false else lb_newuser = true
	
	if lb_newuser = false then
		// User exists - modify group data 
		
		//Check if user is online
		if inv_sysadmin.of_isuseronline(ls_userid) = c#return.success then
			if il_profile_original <> ll_profile or il_groupaccess_original <> ll_groupid then
				messagebox("Modification error", "User is online. Is not possible to change user/group access.", exclamation!, ok!)
				return c#return.failure
			end if
		end if
		
		//Check if group access changed
		if il_groupaccess_original <> ll_groupid then
			ll_return = inv_sysadmin.of_change_group(ls_userid, is_userdata.sqlchangeuser )
			if ll_return =  c#return.failure then
				messagebox("Modification error", "Error modifing  user/group access for user " &
					+ ls_userid + ".~r~rReason:~r"+is_userdata.sqlchangeuser.sqlerrtext &
					+" "+string(is_userdata.sqlchangeuser.sqlcode), exclamation!, ok!)
				return c#return.failure
			end if
		end if
		
		//Check if profile changed
		if il_profile_original <> ll_profile or  il_groupaccess_original <> ll_groupid then
			ll_return = inv_sysadmin.of_revoke_roles_access(ls_userid, is_userdata.sqlchangeuser )
			if ll_return =  c#return.failure then
				//no problem
				//continue
			end if
			
			//Set new role
			lb_addrole = true
		end if
		
	else
		//NEW USER
		ll_return = inv_sysadmin.of_create_user( ls_userid, ls_fullname, is_userdata.sqlchangeuser)
		if ll_return = c#return.failure then
			messagebox("Creation error", "User Creation Failed! Error creating login account to user " &
				+ ls_userid + ".~r~rReason:~r"+is_userdata.sqlchangeuser.sqlerrtext &
				+" "+string(is_userdata.sqlchangeuser.sqlcode), exclamation!, ok!)
			return c#return.failure
		end if
		lb_addrole = true
	end if
	
	//Roles configuration
	if lb_addrole = true then
		ll_return = wf_set_roles_profile (ls_userid , ls_role, ll_groupid, lb_newuser )
		if ll_return = c#return.failure then return c#return.failure
	end if
	
	return c#return.success

end function

public function integer wf_rollback_databasechanges (boolean ab_newuser);/********************************************************************
wf_rollback_databasechanges
   <DESC>If user creation fails, then deletes user from database. 
				If user changes fails, then rollback user role and group.
	</DESC>
   <RETURN> 
		c#return.success:	ok, user created or changed
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS> ab_newuser: if true is a new user  </ARGS>
   <USAGE>	Used to rollback changes in case any database update fails
	</USAGE>
********************************************************************/

long	ll_return
string	ls_userid, ls_role

ls_userid = sle_userid.text

if ab_newuser = true then
	//drop login
	ll_return = inv_sysadmin.of_drop_user(ls_userid, is_userdata.sqlchangeuser)
	
else
	//roll back roles
	inv_sysadmin.of_revoke_roles_access(ls_userid, is_userdata.sqlchangeuser)
	
	inv_sysadmin.of_change_group(ls_userid, is_userdata.sqlchangeuser)
	
	
	choose case  il_profile_original
		case 4
			ls_role = "DEVELOPER"
		case 5
			ls_role = "SUPPORT"
		case else
			ls_role = "TRAMOSUSER"
	end choose
	
	ll_return = wf_set_roles_profile (ls_userid , ls_role, il_groupaccess_original, ab_newuser )
	
	if ll_return = c#return.failure then return c#return.failure
	
end if

return c#return.success

end function

public function integer wf_setuservessels ();/********************************************************************
   wf_setuservessels
   <DESC>	Saving all vessels that the user has access to	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by cb_ok button directly	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	23-06-2011 2406         JMY014        		 First Version
   </HISTORY>
********************************************************************/

ids_uservessels = create mt_n_datastore
ids_uservessels.dataobject = "d_sq_gr_user_vessels"
ids_uservessels.settransobject(is_userdata.SQLchangeuser)

if (is_userdata.userno = 0 and sle_userid.text <>"") then	
	ids_uservessels.insertrow(0)
	ids_uservessels.setitem(1, "userid", sle_userid.text)
	ids_uservessels.setitem(1, "vessel_list", wf_getuservessels())
elseif sle_userid.text <>"" then
	//When changing the current user profit center reset vessel filter status to "All Vessels"
	if ib_profitcenter then
		ids_uservessels.retrieve(sle_userid.text)
		ids_uservessels.setitem(1, "vessel_filter_status", 1)
		ids_uservessels.setitem(1, "vessel_list", wf_getuservessels())
	end if
else
	return c#return.Failure
end if

return c#return.Success
end function

public function string wf_getuservessels ();/********************************************************************
   wf_getuservessels
   <DESC>	Get all vessels that the current user has access to	</DESC>
   <RETURN>	string:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call by wf_setuservessels()	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	27-06-2011 2406         JMY014        		First Version
   </HISTORY>
********************************************************************/
string	ls_vessels
long		ll_row,ll_rows
integer	li_pcnr_array[]
mt_n_datastore lds_uservesselsselection

//Retrive all vessels that the user has access to
ll_rows = ids_users_profitcenter.rowcount()
for ll_row = 1 to ll_rows
	li_pcnr_array[ll_row] = ids_users_profitcenter.getitemnumber(ll_row,"pc_nr")
next
lds_uservesselsselection = create mt_n_datastore
lds_uservesselsselection.dataobject = "d_vessel_picklist"
lds_uservesselsselection.settransobject(sqlca)
ll_rows = lds_uservesselsselection.retrieve(li_pcnr_array[])
//Combining all vessel_nr into a string for saving
if isnull(ls_vessels) then ls_vessels = ""
for ll_row = 1 to ll_rows
	ls_vessels += String(lds_uservesselsselection.getitemnumber(ll_row, "vessel_nr")) + ","
next
ls_vessels = left(ls_vessels, len(ls_vessels) - len(","))

return ls_vessels
end function

public function integer wf_set_userdata (integer as_groupid);integer	li_tmp
long 		ll_row, ll_#ofPC, ll_PC, ll_found

// Set user information

// If new user insert new row()
If is_userdata.userno = 0 Then
	ll_row = is_userdata.userlist.insertrow (0 )
	/* By setting the date the user is forced to change the password when user info changed */
	// ChangeRequest #1462 - only when creating new user or when userid is reset
	is_userdata.userlist.SetItem( ll_Row, "USERS_PW_LAST_CHANGED", datetime(date("01-01-2000"), now()) )
	is_userdata.userlist.SetItem( ll_Row, "EMAIL", st_email.text )
Else
	ll_Row = is_userdata.userno
End if
is_userdata.userlist.ScrollToRow ( ll_Row )
is_userdata.userlist.SetItem( ll_Row, "USERID", sle_userid.text )
is_userdata.userlist.SetItem( ll_Row, "FIRST_NAME", sle_firstname.text )
is_userdata.userlist.SetItem( ll_Row, "LAST_NAME", sle_lastname.text )
is_userdata.userlist.SetItem( ll_Row, "USERS_DELETED", 0 )
is_userdata.userlist.SetItem( ll_Row, "USERS_LOCKED", 0 )
is_userdata.userlist.SetItem( ll_Row, "USER_GROUP", dw_groups.getitemnumber(dw_groups.getselectedrow(0), 'group_id'))
if dw_office.rowcount( ) > 0 then
	is_userdata.userlist.SetItem( ll_Row, "OFFICE_NR",   dw_office.getitemnumber(dw_office.getrow(),"office_nr")    )
else
	is_userdata.userlist.SetItem( ll_Row, "OFFICE_NR","NULL")
end if

/* Sales person */
If cbx_salesperson.checked then
	is_userdata.userlist.SetItem( ll_row, "users_sales_person", 1)  
else
	is_userdata.userlist.SetItem( ll_row, "users_sales_person", 0)  
end if
/* Steering Committee member */
If cbx_sc.checked then 
	is_userdata.userlist.SetItem( ll_row, "users_sc", "yes")  
else
	is_userdata.userlist.SetItem( ll_row, "users_sc", "no")  
end if	

/* Business Unit */
is_userdata.userlist.SetItem( ll_Row, "users_bu_id", &
									dw_bu.GetItemNumber( dw_bu.GetSelectedRow (0), "bu_id" ))

/* Register Freight Receive and Transactions */
If cbx_enter_frt_rec.checked then
	is_userdata.userlist.setitem(ll_row, "USERS_ENTER_FRT_REC", 1) 
else
	is_userdata.userlist.setitem(ll_row, "USERS_ENTER_FRT_REC", 0) 
end if	

/* User Profile */
is_userdata.userlist.setitem(ll_row, "USERS_USER_PROFILE",  ddlb_profile.findItem(ddlb_profile.text,0)) 

/* If external APM and userprofile Charterer or Finance, set it to operator */
if as_groupid = c#usergroup.#EXTERNAL_APM then 
	if  ddlb_profile.findItem(ddlb_profile.text,0) <> 2 then
		MessageBox("Information","As external APM is selected as user group, user profile will be set to 'Operator'") 
		is_userdata.userlist.setitem(ll_row, "USERS_USER_PROFILE", 2) 
	end if	
end if

/* TPERF settings */
If Not (as_groupid=c#usergroup.#USER or as_groupid=c#usergroup.#SUPERUSER or as_groupid=c#usergroup.#ADMINISTRATOR) and ii_TPerf_access > 1 then
		MessageBox("Validation Error", "No External users may have status as TPERF Superuser. Access removed!")			
		ddlb_tperf_access.SelectItem(1)
		ii_tperf_access = 1
End If
is_userdata.userlist.SetItem(ll_row, "USERS_TPERF_ACCESS", ii_Tperf_Access - 1)


/* Web Only settings */
if cbx_onlyweb.checked then 
	choose case as_groupid
		case c#usergroup.#EXTERNAL_APM
			is_userdata.userlist.setItem(ll_row, "WEB_ACCESS_ONLY", 1)
		case else
			MessageBox("Validation Error", "Excluding External users no one can have just web only access. Checkmark removed!")
			is_userdata.userlist.setItem(ll_row, "WEB_ACCESS_ONLY", 0)
			cbx_onlyweb.checked = false
	end choose
else
	is_userdata.userlist.setItem(ll_row, "WEB_ACCESS_ONLY", 0)
end if

/* if Administartor, finance profile update access to all profitcenters */
if as_groupid = c#usergroup.#ADMINISTRATOR &
or is_userdata.userlist.getItemNumber(ll_row, "USERS_USER_PROFILE") = 3 then		
	dw_profitcenterlist.selectrow(0, true)
end if

// Update profitcenter info
ll_#ofPC = dw_profitcenterlist.RowCount()
for ll_PC = 1 to ll_#ofPC
	if dw_profitcenterlist.isSelected(ll_PC) then
		// if selected find out if already there or not
		ll_found = ids_users_profitcenter.find("pc_nr="+string(dw_profitcenterlist.getItemNumber(ll_PC, "pc_nr")),1,99999)
		if ll_found > 0 then  	// if found update primary profitcenter
			ids_users_profitcenter.setItem(ll_found, "primary_profitcenter", dw_profitcenterlist.getItemNumber(ll_PC, "primary_profitcenter"))
		else						// if not found. Create new row
			ll_row = ids_users_profitcenter.insertRow(0)
			ids_users_profitcenter.setItem(ll_row, "userid", sle_userid.text)
			ids_users_profitcenter.setItem(ll_row, "pc_nr", dw_profitcenterlist.getItemNumber(ll_PC, "pc_nr"))
			ids_users_profitcenter.setItem(ll_row, "primary_profitcenter", dw_profitcenterlist.getItemNumber(ll_PC, "primary_profitcenter"))
			ib_profitcenter = true
		end if
	else
		// if not selected find out if it is already there. If so delete row
		ll_found = ids_users_profitcenter.find("pc_nr="+string(dw_profitcenterlist.getItemNumber(ll_PC, "pc_nr")),1,99999)
		if ll_found > 0 then  	// if found delete row
			ids_users_profitcenter.deleterow(ll_found)
			ib_profitcenter = true
		end if
	end if
next	

return 1
end function

public function integer wf_set_roles_profile (string as_userid, string as_role, long as_groupid, boolean ab_newuser);/********************************************************************
wf_set_roles_profile
   <DESC>Sets user roles depending on the profile and group access
	</DESC>
   <RETURN> 
		c#return.success:	ok
		c#return.failure:	failed
   </RETURN>
   <ACCESS> Public  </ACCESS>
   <ARGS> 
		as_userid: user id
		as_role: role name (database)
		ab_newuser: if true, then it is a new user
	</ARGS>
   <USAGE>	Used to set the correct roles after a user is created or if user changes profile.
	</USAGE>
********************************************************************/

long	ll_return
string	ls_profile

ll_return = inv_sysadmin.of_add_role(as_userid, as_role, true, is_userdata.sqlchangeuser)
if ll_return = c#return.failure then
	messagebox("Creation of user not successfully", "Error granting role " + as_role + " to user " &
		+ as_userid + ".~r~r"+is_userdata.sqlchangeuser.sqlerrtext +" " &
		+string(is_userdata.sqlchangeuser.sqlcode), exclamation!, ok!)
	
	//if is not possible to delete a user, then it can be a problem
	if ab_newuser = true then
		ll_return = inv_sysadmin.of_drop_user(as_userid, is_userdata.sqlchangeuser)
		if ll_return = c#return.failure then
			messagebox("Creation of user not successfully", "Please Contact System Administrator!", exclamation!, ok!)
		end if
	end if
	
	return c#return.failure
end if

/* Grant or revoke system role from/to superusers and administrators*/
ls_profile =  ddlb_profile.text // is_userdata.userlist.getItemNumber(ll_row, "USERS_USER_PROFILE") 
if as_groupid = c#usergroup.#ADMINISTRATOR  and (ls_profile = "Finance" or ls_profile = "Support") then
	
	ll_return = inv_sysadmin.of_add_role(as_userid, "sso_role", false,  is_userdata.sqlchangeuser)
	if ll_return = c#return.failure then
		messagebox("Role", "Error granting administrator role access for user " &
			+ as_userid + ".~r~rContact System Administrator.~r~rReason:~r"+is_userdata.sqlchangeuser.sqlerrtext &
			+" "+string(is_userdata.sqlchangeuser.sqlcode), exclamation!, ok!)
	end if
	
	//Only Finance Admin have access to change user id
	if ls_profile = "Finance" then
		ll_return = inv_sysadmin.of_add_role(as_userid, "replication_role", false,  is_userdata.sqlchangeuser)
		if ll_return = c#return.failure then
			messagebox("Role", "Error granting administrator role access for user " &
				+ as_userid + ".~r~rContact System Administrator.~r~rReason:~r"+is_userdata.sqlchangeuser.sqlerrtext &
				+" "+string(is_userdata.sqlchangeuser.sqlcode), exclamation!, ok!)
		end if
	end if
end if

return c#return.success

end function

public function integer wf_becomeuser ();/********************************************************************
wf_becomeuser

<DESC>
	This function is to support SSO, where user can only connect to db with own windows id. 
	Called from button click event, this function swaps the user.
</DESC>
<RETURN> 
	Integer:
		<LI> 1, X Success
</RETURN>
<ACCESS>
	Public
</ACCESS>
<ARGS>
</ARGS>
<USAGE>
	to be only used in TEST environment.  function also validates if no other window is open.
	Switches current users profile to another users.
</USAGE>
********************************************************************/

window lw_sheet, lw_parent
boolean lb_valid, lb_openwindows=false
integer li_security, li_pc_nr
integer li_dummy[]

lw_parent=Parentwindow( )
lw_sheet = lw_parent.GetFirstSheet()
lb_valid = IsValid (lw_sheet)

/* only apply when server is designated test.  Will not work for real server name */
if upper(uo_global.is_database) <> c#connectivity.PRODUCTIONDB then
	/* check if any windows outside of the user admin set are open, because they are not allowed to be if user wants to swap user */
	do
		if lb_valid and lw_sheet.classname() <> "w_sysadmin_edit_single_user" and lw_sheet.classname() <> "w_sysadmin_editusers"  then
			lb_openwindows = true
			lb_valid = false
		end if	
		lw_sheet = lw_parent.GetNextSheet(lw_sheet)	
		lb_valid = IsValid (lw_sheet)
	loop while lb_valid
	
	if isvalid(w_position_list) or isvalid(w_fixture_list) or isvalid(w_port_of_call_list) then
		lb_openwindows = true
	end if
	
	if lb_openwindows then
		messagebox("Open Windows","Cannot become selected user as other window(s) are currently open.  Close other window(s) and try again.",StopSign!)	
		return c#return.NoAction
	else 
		
		uo_global.setuserid(sle_userid.text)
		uo_global.is_userid = sle_userid.text
		SQLCA.UserID	  = sle_userid.text
		
		SELECT 	USERS.USER_GROUP,   
					USERS_PROFITCENTER.PC_NR  
  		INTO 		:li_security,
  		 			:li_pc_nr
  		FROM 		USERS,   
	    			USERS_PROFITCENTER
 		WHERE 	USERS_PROFITCENTER.USERID = USERS.USERID  
   				AND USERS_PROFITCENTER.PRIMARY_PROFITCENTER = 1
   				AND USERS.USERID = :sle_userid.text;  
		COMMIT;

		if not isnull(li_security) then
			uo_global.ii_access_level = li_security
			uo_global.set_profitcenter_no(li_pc_nr)    //Primary Profitcenter
			
			SELECT 	USER_PROFILE 
			INTO 		:uo_global.ii_user_profile
			FROM 		USERS
			WHERE 	USERID = :uo_global.is_userid;
			COMMIT;
			
			/* refresh the window title of main container */
			lw_parent.Title = "TRAMOS Database (" + SQLCA.Database + ") - Server (" + SQLCA.Servername + ") - User (" +uo_global.Getuserid()+")"
		end if
		
		w_share.triggerevent("ue_retrieve")
		uo_global.ii_vesselnumber = li_dummy[]
		/* clear global array of all users selected vessels */
		uo_global.ii_mvv_vesselnumber = li_dummy[]
		uo_global.ii_vc_vesselnumber = li_dummy[]
		uo_global.uf_load()
		
		messagebox("Information","Your profile has now been changed to " + sle_userid.text)
	end if
else 
	messagebox("Functionality Unavailable","Cannot become selected user inside environment that is production.",Exclamation!)	
	return c#return.NoAction
end if	
/* this parameter passed will also close the user admin list window */
closewithreturn(this,1)

return c#return.Success
end function

event open;
is_userdata = message.PowerObjectParm

ids_users_profitcenter = create n_ds
ids_users_profitcenter.dataObject = "d_sq_users_profitcenter"
ids_users_profitcenter.setTransObject(is_userdata.SQLchangeuser)
inv_sysadmin = create n_sysadmin

// Post ue_retrieve event
PostEvent("ue_retrieve")

end event

on w_sysadmin_edit_single_user.create
int iCurrent
call super::create
this.st_warning=create st_warning
this.cb_clearpw=create cb_clearpw
this.cb_ok=create cb_ok
this.st_tperf=create st_tperf
this.ddlb_tperf_access=create ddlb_tperf_access
this.cbx_onlyweb=create cbx_onlyweb
this.st_8=create st_8
this.dw_office=create dw_office
this.cb_unselectall=create cb_unselectall
this.cb_selectall=create cb_selectall
this.dw_bu=create dw_bu
this.st_7=create st_7
this.cbx_sc=create cbx_sc
this.st_6=create st_6
this.ddlb_profile=create ddlb_profile
this.cbx_enter_frt_rec=create cbx_enter_frt_rec
this.cbx_salesperson=create cbx_salesperson
this.dw_groups=create dw_groups
this.st_4=create st_4
this.dw_profitcenterlist=create dw_profitcenterlist
this.sle_lastname=create sle_lastname
this.sle_firstname=create sle_firstname
this.sle_userid=create sle_userid
this.st_5=create st_5
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.st_emailtitle=create st_emailtitle
this.st_email=create st_email
this.cb_possess=create cb_possess
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_warning
this.Control[iCurrent+2]=this.cb_clearpw
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_tperf
this.Control[iCurrent+5]=this.ddlb_tperf_access
this.Control[iCurrent+6]=this.cbx_onlyweb
this.Control[iCurrent+7]=this.st_8
this.Control[iCurrent+8]=this.dw_office
this.Control[iCurrent+9]=this.cb_unselectall
this.Control[iCurrent+10]=this.cb_selectall
this.Control[iCurrent+11]=this.dw_bu
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.cbx_sc
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.ddlb_profile
this.Control[iCurrent+16]=this.cbx_enter_frt_rec
this.Control[iCurrent+17]=this.cbx_salesperson
this.Control[iCurrent+18]=this.dw_groups
this.Control[iCurrent+19]=this.st_4
this.Control[iCurrent+20]=this.dw_profitcenterlist
this.Control[iCurrent+21]=this.sle_lastname
this.Control[iCurrent+22]=this.sle_firstname
this.Control[iCurrent+23]=this.sle_userid
this.Control[iCurrent+24]=this.st_5
this.Control[iCurrent+25]=this.st_3
this.Control[iCurrent+26]=this.st_2
this.Control[iCurrent+27]=this.st_1
this.Control[iCurrent+28]=this.st_emailtitle
this.Control[iCurrent+29]=this.st_email
this.Control[iCurrent+30]=this.cb_possess
end on

on w_sysadmin_edit_single_user.destroy
call super::destroy
destroy(this.st_warning)
destroy(this.cb_clearpw)
destroy(this.cb_ok)
destroy(this.st_tperf)
destroy(this.ddlb_tperf_access)
destroy(this.cbx_onlyweb)
destroy(this.st_8)
destroy(this.dw_office)
destroy(this.cb_unselectall)
destroy(this.cb_selectall)
destroy(this.dw_bu)
destroy(this.st_7)
destroy(this.cbx_sc)
destroy(this.st_6)
destroy(this.ddlb_profile)
destroy(this.cbx_enter_frt_rec)
destroy(this.cbx_salesperson)
destroy(this.dw_groups)
destroy(this.st_4)
destroy(this.dw_profitcenterlist)
destroy(this.sle_lastname)
destroy(this.sle_firstname)
destroy(this.sle_userid)
destroy(this.st_5)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.st_emailtitle)
destroy(this.st_email)
destroy(this.cb_possess)
end on

event close;call super::close;destroy (inv_sysadmin)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_sysadmin_edit_single_user
end type

type st_warning from statictext within w_sysadmin_edit_single_user
boolean visible = false
integer x = 1623
integer y = 1348
integer width = 768
integer height = 216
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
string text = "Warning: User is online! It is not possible to change profile and group access!"
boolean focusrectangle = false
end type

type cb_clearpw from mt_u_commandbutton within w_sysadmin_edit_single_user
integer x = 1829
integer y = 1952
integer width = 430
integer taborder = 110
string text = "&Reset Password"
end type

event clicked;call super::clicked;//n_passwordreset lnv_reset
//
//lnv_reset = create n_passwordreset
//
//lnv_reset.of_resetpassword( sle_userid.text )
//
//destroy lnv_reset
//
//  Resets password for this user to "password"

String 		ls_sql
datetime 	ldt
long			ll_rc

if sqlca.logid = sle_userid.text then
	MessageBox("Reset Password", "You are not allowed to reset your own password from here. Use change password function!")
	return 
end if
	
ll_rc =  MessageBox("Reset Password", "You are about to reset the password for user " &
						+ sle_firstname.text  +" " & 
						+ sle_lastname.text + "~r~n~r~n" &
						+ "Would you like to send a mail to the user or change to default password?~r~n~r~n" &
						+ "Yes~tMail sent to user with randomly generated password~r~n" &
						+ "No ~tPassword changed to 'Password1'~r~n", Question!,YesNoCancel!,1)

choose case ll_rc
	case 1
		// Reset password and send mail to user
		n_passwordreset lnv_reset
		
		lnv_reset = create n_passwordreset
		lnv_reset.of_resetpassword( sle_userid.text )
		
		destroy lnv_reset
	case 2
		//Reset password to default password - nio mail sent to user
		
		// Enable auto Commit, needed for sp_xx procedures 
		is_userdata.SQLchangeuser.AutoCommit = TRUE
	
		ls_sql = 'sp_password "'+is_userdata.SQLchangeuser.dbpass+'", Password1, '+sle_userid.text
		EXECUTE IMMEDIATE :ls_sql USING is_userdata.SQLchangeuser;

		IF is_userdata.SQLchangeuser.SqlCode = 0 THEN
			Messagebox("Password changed", "Password was successfully changed to 'Password1'.")
			/* Set password last Changed variabel */
			   UPDATE USERS 
				SET PW_LAST_CHANGED = "1. JANUARY 2000" 
				WHERE USERID = :sle_userid.text USING is_userdata.SQLchangeuser;
			
			If is_userdata.SQLchangeuser.SqlCode = 0 Then
				COMMIT USING is_userdata.SQLchangeuser;
			Else
				ROLLBACK USING is_userdata.SQLchangeuser;
			End if 
		ELSE // Failure - display messagebox
			Messagebox("Password not changed", "Password was not changed.~r~rRe-try the operation.~r~rReason:~r" + SQLCA.SqlErrText)
		END IF
		
		// Disable auto Commit, needed for sp_xx procedures 
		is_userdata.SQLchangeuser.AutoCommit = FALSE
	case 3
		// return user cancelled the change
		return
end choose

end event

type cb_ok from mt_u_commandbutton within w_sysadmin_edit_single_user
integer x = 1829
integer y = 2076
integer width = 430
integer taborder = 110
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;// Modify user or create user is user doesn't exists

// If is_userdata.userno = 0 this is a creation of a new user


constant string METHOD_NAME = ""

long		ll_return, ll_profile, ll_groupid
string	ls_role, ls_hashedpw
boolean	lb_addrole, lb_newuser
datetime ldt
n_cryptoapi lnv_crypto 

/* Do the general validation */
if wf_general_validation( ) = -1 then
	return
end if


ll_groupid =  dw_groups.getItemnumber(dw_groups.getselectedrow (0), "group_id" ) 
/* Set user detail information */
if wf_set_userdata(ll_groupid) = -1 then
	return
end if

lb_newuser = true

if is_userdata.userno>0 then lb_newuser = false

is_userdata.SQLchangeuser.Autocommit = True

/* Database changes */
if wf_edit_database_user() = c#return.failure then
	is_userdata.SQLchangeuser.Autocommit = False
	if lb_newuser = True then wf_createfailed(sle_userid.text)
	return
end if

// Disable auto Commit, after creation/update of DB User 
is_userdata.SQLchangeuser.Autocommit = False

//Saves data in table USERS and USERS_PROFIT_CENTER
If is_userdata.userlist.update(true, false) = 1 Then
	if ids_users_profitcenter.update(true, false) = 1 then
		is_userdata.userlist.resetupdate()
		ids_users_profitcenter.resetupdate()
		
		if lb_newuser = true then 
			lnv_crypto.iProviderType     = lnv_crypto.PROV_RSA_FULL
			lnv_crypto.iCryptoProvider   = lnv_crypto.of_GetDefaultProvider()
			lnv_crypto.iEncryptAlgorithm = lnv_crypto.CALG_RC4
			lnv_crypto.iHashAlgorithm    = lnv_crypto.CALG_MD5

			ls_hashedpw = lnv_crypto.of_gethashvalue("Password1")
			
			INSERT INTO PW_USED VALUES (:sle_userid.text, :ls_hashedpw, :ldt) USING is_userdata.SQLchangeuser;
		end if
	
		//Saving user vessels
		if (wf_setuservessels() = c#return.Success) then
			if ids_uservessels.update() <> 1 then 
				ROLLBACK USING is_userdata.SQLchangeuser;
			end if
		end if
		
		COMMIT USING is_userdata.SQLchangeuser;
		
		MessageBox("User creation or data modified","Data saved succesfully!")
		
		closewithreturn(parent,0)
		
	Else
		ROLLBACK USING is_userdata.SQLchangeuser;
		//tries to roll back database changes
		wf_rollback_databasechanges(lb_newuser)
		wf_createfailed(sle_userid.text)
		MessageBox("Error","Error updating Users Table. Contact Tramos System Administrator. ~n~n" +  is_userdata.SQLchangeuser.sqlerrtext )
	End if 
Else
	ROLLBACK USING is_userdata.SQLchangeuser;
	//tries to roll back database changes
	wf_rollback_databasechanges(lb_newuser)
	wf_createfailed(sle_userid.text)
	MessageBox("Error","Error updating Users Table. Contact Tramos System Administrator. ~n~n" +  is_userdata.SQLchangeuser.sqlerrtext )
End if 


end event

type st_tperf from mt_u_statictext within w_sysadmin_edit_single_user
integer x = 73
integer y = 576
integer width = 347
string text = "T-Perf Access:"
end type

type ddlb_tperf_access from mt_u_dropdownlistbox within w_sysadmin_edit_single_user
integer x = 425
integer y = 560
integer width = 421
integer height = 320
integer taborder = 60
string item[] = {"No Access","Regular User","Super User"}
end type

event selectionchanged;call super::selectionchanged;
ii_Tperf_Access = index
end event

type cbx_onlyweb from mt_u_checkbox within w_sysadmin_edit_single_user
boolean visible = false
integer x = 1627
integer y = 1136
integer width = 640
integer height = 64
integer taborder = 100
integer textsize = -8
string text = "&Web Access Only"
end type

type st_8 from statictext within w_sysadmin_edit_single_user
integer x = 78
integer y = 460
integer width = 279
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Office:"
boolean focusrectangle = false
end type

type dw_office from datawindow within w_sysadmin_edit_single_user
integer x = 421
integer y = 448
integer width = 439
integer height = 96
integer taborder = 50
string title = "none"
string dataobject = "d_office_user_pc"
boolean border = false
boolean livescroll = true
end type

type cb_unselectall from commandbutton within w_sysadmin_edit_single_user
integer x = 407
integer y = 2200
integer width = 343
integer height = 72
integer taborder = 160
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Deselect All"
end type

event clicked;long	ll_row, ll_rows

ll_rows = dw_profitcenterlist.rowCount()

for ll_row = 1 to ll_rows
	dw_profitcenterlist.selectRow(ll_row, FALSE)
	dw_profitcenterlist.setItem(ll_row, "primary_profitcenter", 0)
next

end event

type cb_selectall from commandbutton within w_sysadmin_edit_single_user
integer x = 69
integer y = 2200
integer width = 343
integer height = 72
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Select All"
end type

event clicked;long	ll_row, ll_rows

ll_rows = dw_profitcenterlist.rowCount()

for ll_row = 1 to ll_rows
	dw_profitcenterlist.selectRow(ll_row, TRUE)
next

end event

type dw_bu from datawindow within w_sysadmin_edit_single_user
integer x = 1778
integer y = 104
integer width = 622
integer height = 568
integer taborder = 110
string title = "none"
string dataobject = "d_dddw_businessunit"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;IF row > 0 THEN
	this.selectrow(0, FALSE)
	this.selectrow(row, TRUE)
END IF
end event

type st_7 from statictext within w_sysadmin_edit_single_user
integer x = 1783
integer y = 40
integer width = 315
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Business Unit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_sc from checkbox within w_sysadmin_edit_single_user
integer x = 1627
integer y = 1056
integer width = 713
integer height = 64
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "&Business Superuser"
end type

type st_6 from statictext within w_sysadmin_edit_single_user
integer x = 78
integer y = 348
integer width = 279
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Profile:"
boolean focusrectangle = false
end type

type ddlb_profile from dropdownlistbox within w_sysadmin_edit_single_user
integer x = 425
integer y = 344
integer width = 549
integer height = 416
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16776960
string text = "none"
boolean sorted = false
string item[] = {"Charterer","Operator","Finance","Developer","Support"}
borderstyle borderstyle = stylelowered!
end type

type cbx_enter_frt_rec from checkbox within w_sysadmin_edit_single_user
integer x = 1627
integer y = 976
integer width = 823
integer height = 64
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
string text = "Authorised for &Freight Receivable"
end type

type cbx_salesperson from uo_cbx_base within w_sysadmin_edit_single_user
integer x = 1627
integer y = 896
integer width = 402
integer height = 64
integer taborder = 70
long backcolor = 81324524
string text = "&Sales Person"
end type

type dw_groups from datawindow within w_sysadmin_edit_single_user
integer x = 1056
integer y = 104
integer width = 622
integer height = 568
integer taborder = 120
string dataobject = "dw_groups"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;
if row > 0 then
	this.selectrow(0, false)
	this.selectrow(row, true)
else 
	return
end if

if this.getitemnumber(row,"group_id")=c#usergroup.#EXTERNAL_APM then
	cbx_onlyweb.visible = true
else
	cbx_onlyweb.visible = false	
end if


end event

type st_4 from statictext within w_sysadmin_edit_single_user
integer x = 1056
integer y = 40
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "&Group Access:"
boolean focusrectangle = false
end type

type dw_profitcenterlist from datawindow within w_sysadmin_edit_single_user
integer x = 64
integer y = 892
integer width = 1499
integer height = 1292
integer taborder = 130
string dataobject = "d_profit_center_listall"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then
	if dwo.name = "primary_profitcenter" then
		return
	end if

	this.selectrow(row, not this.isselected(row))
	// if row not selected reset primary indicator
	if not this.isselected( row ) then this.setItem(row, "primary_profitcenter", 0)
	wf_refresh_office()
END IF
end event

event itemchanged;
if row > 0 then
	if dwo.name = "primary_profitcenter" then
		if data = "1" then 
			this.post selectrow(row, true)
			integer li_Rows
			For li_Rows = 1 to This.RowCount()
				If li_Rows<>row  and This.GetItemNumber(li_Rows, "primary_profitcenter") = 1 then This.SetItem(li_Rows, "primary_profitcenter", 0)
			Next
		end if
	end if
END IF
end event

type sle_lastname from singlelineedit within w_sysadmin_edit_single_user
integer x = 425
integer y = 248
integer width = 549
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_firstname from singlelineedit within w_sysadmin_edit_single_user
integer x = 425
integer y = 152
integer width = 549
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type sle_userid from singlelineedit within w_sysadmin_edit_single_user
integer x = 425
integer y = 56
integer width = 549
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 16776960
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;//IF IsValid(w_edit_ext_vessels) THEN Close(w_edit_ext_vessels)
//IF IsValid(w_edit_ext_vessels) THEN Close(w_edit_ext_vessels)

string ls_newuseremail, ls_value
mt_n_activedirectoryfunctions	lnv_adfunc

if this.text="" then
	st_email.text=""
	sle_firstname.text = ""
	sle_lastname.text = ""
	return
end if
if lnv_adfunc.of_get_email_by_userid_from_ad(this.text,ls_newuseremail) <> c#return.Failure then
	st_email.text = ls_newuseremail
	lnv_adfunc.of_get_property_by_userid_from_ad(this.text,"givenname",ls_value)
	if ls_value<>this.text then 
		sle_firstname.text = ls_value
	else 
		sle_firstname.text = ""
	end if
	lnv_adfunc.of_get_property_by_userid_from_ad(this.text,"sn",ls_value)
	if ls_value<>this.text then 
		sle_lastname.text = ls_value
	else
		sle_lastname.text = ""
	end if
else
	st_email.text = this.text + c#email.domain
	sle_firstname.text = ""
	sle_lastname.text = ""
end if	
end event

type st_5 from statictext within w_sysadmin_edit_single_user
integer x = 73
integer y = 808
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "&Profit Center:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_sysadmin_edit_single_user
integer x = 78
integer y = 256
integer width = 279
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "&Last Name:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_sysadmin_edit_single_user
integer x = 78
integer y = 160
integer width = 261
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "&First Name:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_sysadmin_edit_single_user
integer x = 78
integer y = 64
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "&User ID:"
boolean focusrectangle = false
end type

type st_emailtitle from statictext within w_sysadmin_edit_single_user
integer x = 73
integer y = 692
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean enabled = false
string text = "Email:"
boolean focusrectangle = false
end type

type st_email from statictext within w_sysadmin_edit_single_user
event ue_rbuttondblclk pbm_rbuttondblclk
integer x = 425
integer y = 692
integer width = 1966
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 81324524
boolean focusrectangle = false
end type

event ue_rbuttondblclk;::clipboard(st_email.text)
end event

event doubleclicked;long ll_textcolor
n_open_urloremail lnv_link
// copy to clipboard the email address and give a small indication by changing the font color temporarily.
ll_textcolor = this.textcolor
this.textcolor = RGB(0,0,255)
::clipboard(st_email.text)
sleep(500)
this.textcolor = ll_textcolor
lnv_link.of_openlink(this.text,'email')
end event

type cb_possess from mt_u_commandbutton within w_sysadmin_edit_single_user
integer x = 1824
integer y = 1824
integer width = 425
integer taborder = 110
boolean bringtotop = true
string text = "Become User"
end type

event clicked;call super::clicked;wf_becomeuser()
end event

