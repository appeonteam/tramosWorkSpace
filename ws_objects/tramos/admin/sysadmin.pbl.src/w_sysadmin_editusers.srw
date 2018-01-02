$PBExportHeader$w_sysadmin_editusers.srw
$PBExportComments$User/group main window
forward
global type w_sysadmin_editusers from mt_w_sheet
end type
type sle_search from singlelineedit within w_sysadmin_editusers
end type
type st_5 from statictext within w_sysadmin_editusers
end type
type mle_list from multilineedit within w_sysadmin_editusers
end type
type p_getusers from picture within w_sysadmin_editusers
end type
type cb_unsettled_disb from commandbutton within w_sysadmin_editusers
end type
type st_2 from statictext within w_sysadmin_editusers
end type
type gb_4 from groupbox within w_sysadmin_editusers
end type
type st_4 from statictext within w_sysadmin_editusers
end type
type sle_newid from singlelineedit within w_sysadmin_editusers
end type
type cb_changeuserid from commandbutton within w_sysadmin_editusers
end type
type cb_refresh from commandbutton within w_sysadmin_editusers
end type
type cb_resetpassword from commandbutton within w_sysadmin_editusers
end type
type st_3 from statictext within w_sysadmin_editusers
end type
type cb_cleanup from commandbutton within w_sysadmin_editusers
end type
type cb_saveas from commandbutton within w_sysadmin_editusers
end type
type cb_upd_version from commandbutton within w_sysadmin_editusers
end type
type st_1 from statictext within w_sysadmin_editusers
end type
type dw_tramos_version from datawindow within w_sysadmin_editusers
end type
type cb_unlock from commandbutton within w_sysadmin_editusers
end type
type cb_undelete from commandbutton within w_sysadmin_editusers
end type
type cbx_deleted from checkbox within w_sysadmin_editusers
end type
type cb_1 from commandbutton within w_sysadmin_editusers
end type
type cb_userdelete from commandbutton within w_sysadmin_editusers
end type
type cb_usermodify from commandbutton within w_sysadmin_editusers
end type
type cb_usercreate from commandbutton within w_sysadmin_editusers
end type
type dw_userlist from datawindow within w_sysadmin_editusers
end type
type gb_1 from groupbox within w_sysadmin_editusers
end type
type gb_2 from groupbox within w_sysadmin_editusers
end type
type gb_3 from groupbox within w_sysadmin_editusers
end type
end forward

global type w_sysadmin_editusers from mt_w_sheet
integer x = 361
integer y = 496
integer width = 4599
integer height = 2576
string title = "System Administration"
boolean maxbox = false
boolean resizable = false
long backcolor = 81324524
boolean ib_setdefaultbackgroundcolor = true
event ue_retrieve pbm_custom01
sle_search sle_search
st_5 st_5
mle_list mle_list
p_getusers p_getusers
cb_unsettled_disb cb_unsettled_disb
st_2 st_2
gb_4 gb_4
st_4 st_4
sle_newid sle_newid
cb_changeuserid cb_changeuserid
cb_refresh cb_refresh
cb_resetpassword cb_resetpassword
st_3 st_3
cb_cleanup cb_cleanup
cb_saveas cb_saveas
cb_upd_version cb_upd_version
st_1 st_1
dw_tramos_version dw_tramos_version
cb_unlock cb_unlock
cb_undelete cb_undelete
cbx_deleted cbx_deleted
cb_1 cb_1
cb_userdelete cb_userdelete
cb_usermodify cb_usermodify
cb_usercreate cb_usercreate
dw_userlist dw_userlist
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_sysadmin_editusers w_sysadmin_editusers

type variables
//Transaction SQLchangeuser

u_tran_changeuser SQLchangeuser
end variables

forward prototypes
public subroutine editsingleuser (long pl_row)
public subroutine wf_refreshonline ()
public subroutine documentation ()
private subroutine wf_gui ()
public subroutine wf_searchandselect ()
end prototypes

event ue_retrieve;// ue_retrieve - retrieve user data and selectrow 1

dw_userlist.retrieve ()

if cbx_deleted.checked = FALSE then
	dw_userlist.setFilter("users_deleted = 0")
	dw_userlist.filter()
	dw_userlist.setSort("userid")
	dw_userlist.Sort()
end if

dw_tramos_version.retrieve()
commit using sqlchangeuser;



end event

public subroutine editsingleuser (long pl_row);// editsingleuser script - this script opens w_edit_single_user for either creation or modification

s_userdata ls_userdata
Long ll_row
 
ls_userdata.userno = pl_Row
ls_userdata.userlist = dw_userlist
ll_Row = dw_userlist.GetRow ()
ls_userdata.SQLchangeuser = SQLchangeuser

wf_refreshonline( )

OpenWithParm(w_sysadmin_edit_single_user, ls_userdata)

if message.doubleparm = 0 then
	
	SetRedraw( False )
	dw_userlist.retrieve()
	post wf_refreshonline( )
	
	
	If ll_Row > 0 Then
		dw_userlist.SelectRow ( 0, False )
		dw_userlist.ScrollToRow ( ll_Row )  
		dw_userlist.SelectRow ( ll_Row, True )
	end if
	
	SetRedraw( True )
	
	dw_userlist.Setfocus()
else
	close(this)
end if	
end subroutine

public subroutine wf_refreshonline ();/* Refresh online indicator*/
n_ds lds_data
string ls_userid
long ll_rows, ll_row, ll_found

ll_rows = dw_userlist.rowcount ()

/* mark users that are online */
lds_data = create n_ds
lds_data.dataObject = "d_sq_tb_active_users"
lds_data.setTransObject(SQLCA)
lds_data.retrieve()

for ll_row = 1 to ll_rows
	ls_userid = dw_userlist.getItemString(ll_row, "userid")
	ll_found = lds_data.find("name='"+ls_userid+"'", 1, 99999)
	if ll_found > 0 then 
		dw_userlist.setItem(ll_row, "useronline", 1)
	else
		dw_userlist.setItem(ll_row, "useronline", 0)
	end if	
next

destroy lds_data

return
end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_sysadmin_editusers - List of users
   <OBJECT> List of users 	</OBJECT>
   <USAGE> 
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
   00/00/00		First Version
   06/06/11	CR2460	JMC112	Change window hierarchy and add disable login window
	07/09/11 CR2575	CONASW	Added Profile column to DW, user search text box and added
										role assignment to change userid function
	04/10/11 CR2589	CONASW	Tramos version to be of format xx.xx.x	
	20/10/11	CR1573	RJH022 	add users group for not visited sysusers
	24/07/12 CR2456	CONASW	Prevent deletion of users who are VIMS Management users
	28/08/14	CR3781	CCY018	The window title match with the text of a menu item
	06/10/16	CR3754	AGL027	Single Sign On modification
</HISTORY>    
********************************************************************/
end subroutine

private subroutine wf_gui ();//Set GUI



IF uo_global.ii_user_profile = 4 THEN
	//DEVELOPER
	dw_userlist.Object.Datawindow.ReadOnly="yes"
	
	cb_usercreate.enabled = false
	cb_usermodify.enabled = false
	cb_userdelete.enabled = false
	cb_undelete.enabled = false
	cb_unlock.enabled = false
	cb_resetpassword.enabled = false
	
	
elseif uo_global.ii_user_profile = 5 THEN
	//SUPPORT
	
	//delete calculations - not visible
	cb_cleanup.visible = false
	st_3.visible = false
	gb_2.visible = false
	
	//unsettle disbursements not visible
	cb_unsettled_disb.visible = false
	st_2.visible = false
	gb_4.visible = false
	
	//not visible - change user id
	gb_3.visible = false
	st_4.visible = false
	sle_newid.visible = false
	cb_changeuserid.visible = false
	
	//tramos version disabled
	dw_tramos_version.enabled = false
	cb_upd_version.visible = false
	
end if



end subroutine

public subroutine wf_searchandselect ();// Searches the list for text

String ls_Text
Integer li_Found 

ls_Text = Trim(Upper(sle_Search.Text), True)

li_Found = dw_UserList.Find("(UserID like '" + ls_Text + "%') or (Upper(First_Name) like '" + ls_Text + "%') or (Upper(Last_Name) like '" + ls_Text + "%')", 1, dw_UserList.RowCount())

If li_Found > 0 then 
	dw_UserList.SelectRow(0, False)
	dw_UserList.SelectRow(li_Found, True)
	dw_UserList.ScrollToRow(li_Found)
End If


end subroutine

event open;string ls_sql

SQLchangeuser = CREATE u_tran_changeuser
SQLchangeuser.dbms          	= uo_global.is_dbms
SQLchangeuser.Database		= uo_global.is_database
SQLchangeuser.Servername 	= uo_global.is_servername
SQLchangeuser.UserID	 = uo_global.is_userid
SQLchangeuser.DBPass    = uo_global.is_password
SQLchangeuser.Logid        = SQLCA.logid
SQLchangeuser.LogPass   = uo_global.is_password
SQLchangeuser.Dbparm = uo_global.is_dbparm
CONNECT USING SQLchangeuser;	

IF SQLchangeuser.SQLCode <> 0 THEN 
	messagebox("DataBase Error","Could not attach to Database. ~r~r~nUnable to open systemadministration")
	Close( this )
End if

// Move window to 5,5, SetTransObject(SQLCA)  and retrieve datawindows
This.Move ( 5, 5 )

dw_userlist.SetTransObject(SQLChangeUser)
dw_tramos_version.SetTransObject(SQLChangeUser)

wf_gui()

PostEvent("ue_retrieve")
post wf_refreshonline( )

end event

event close;// Close event - Destroy SQLchangeuser

If IsValid(SQLChangeUser) Then
	DISCONNECT USING SQLChangeUser;
	DESTROY SQLchangeuser
End if

end event

on w_sysadmin_editusers.create
int iCurrent
call super::create
this.sle_search=create sle_search
this.st_5=create st_5
this.mle_list=create mle_list
this.p_getusers=create p_getusers
this.cb_unsettled_disb=create cb_unsettled_disb
this.st_2=create st_2
this.gb_4=create gb_4
this.st_4=create st_4
this.sle_newid=create sle_newid
this.cb_changeuserid=create cb_changeuserid
this.cb_refresh=create cb_refresh
this.cb_resetpassword=create cb_resetpassword
this.st_3=create st_3
this.cb_cleanup=create cb_cleanup
this.cb_saveas=create cb_saveas
this.cb_upd_version=create cb_upd_version
this.st_1=create st_1
this.dw_tramos_version=create dw_tramos_version
this.cb_unlock=create cb_unlock
this.cb_undelete=create cb_undelete
this.cbx_deleted=create cbx_deleted
this.cb_1=create cb_1
this.cb_userdelete=create cb_userdelete
this.cb_usermodify=create cb_usermodify
this.cb_usercreate=create cb_usercreate
this.dw_userlist=create dw_userlist
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_search
this.Control[iCurrent+2]=this.st_5
this.Control[iCurrent+3]=this.mle_list
this.Control[iCurrent+4]=this.p_getusers
this.Control[iCurrent+5]=this.cb_unsettled_disb
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_4
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.sle_newid
this.Control[iCurrent+10]=this.cb_changeuserid
this.Control[iCurrent+11]=this.cb_refresh
this.Control[iCurrent+12]=this.cb_resetpassword
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.cb_cleanup
this.Control[iCurrent+15]=this.cb_saveas
this.Control[iCurrent+16]=this.cb_upd_version
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.dw_tramos_version
this.Control[iCurrent+19]=this.cb_unlock
this.Control[iCurrent+20]=this.cb_undelete
this.Control[iCurrent+21]=this.cbx_deleted
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.cb_userdelete
this.Control[iCurrent+24]=this.cb_usermodify
this.Control[iCurrent+25]=this.cb_usercreate
this.Control[iCurrent+26]=this.dw_userlist
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
end on

on w_sysadmin_editusers.destroy
call super::destroy
destroy(this.sle_search)
destroy(this.st_5)
destroy(this.mle_list)
destroy(this.p_getusers)
destroy(this.cb_unsettled_disb)
destroy(this.st_2)
destroy(this.gb_4)
destroy(this.st_4)
destroy(this.sle_newid)
destroy(this.cb_changeuserid)
destroy(this.cb_refresh)
destroy(this.cb_resetpassword)
destroy(this.st_3)
destroy(this.cb_cleanup)
destroy(this.cb_saveas)
destroy(this.cb_upd_version)
destroy(this.st_1)
destroy(this.dw_tramos_version)
destroy(this.cb_unlock)
destroy(this.cb_undelete)
destroy(this.cbx_deleted)
destroy(this.cb_1)
destroy(this.cb_userdelete)
destroy(this.cb_usermodify)
destroy(this.cb_usercreate)
destroy(this.dw_userlist)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_sysadmin_editusers
end type

type sle_search from singlelineedit within w_sysadmin_editusers
event ue_keyup pbm_keyup
integer x = 4114
integer y = 1024
integer width = 434
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_keyup;// Search for user typed

Post wf_SearchAndSelect()
end event

type st_5 from statictext within w_sysadmin_editusers
integer x = 4114
integer y = 960
integer width = 439
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search ID or Name:"
boolean focusrectangle = false
end type

type mle_list from multilineedit within w_sysadmin_editusers
boolean visible = false
integer x = 1522
integer y = 684
integer width = 1934
integer height = 612
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type p_getusers from picture within w_sysadmin_editusers
integer x = 4480
integer y = 808
integer width = 82
integer height = 72
string picturename = "images\notes.gif"
boolean focusrectangle = false
string powertiptext = "Copy Users ID"
end type

event clicked;/* Copies the users ID in a format that can be paste to an email. Includes all the active users */

long 	ll_row, ll_rows

ll_rows =  dw_userlist.rowcount( )
for ll_row = 1 to ll_rows
	if dw_userlist.getitemnumber( ll_row, "users_deleted") = 0 then 
		mle_list.text = mle_list.text  + dw_userlist.getitemstring( ll_row, "userid") + "; "
	end if
next

mle_list.selecttext(1,len(mle_list.text))
mle_list.copy( )

messagebox("Copy users","Users copied to clipboard.")
end event

type cb_unsettled_disb from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 1776
integer width = 288
integer height = 80
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Sh&ow"
end type

event clicked;open(w_cleanup_failed_inserted_disbursements)
end event

type st_2 from statictext within w_sysadmin_editusers
integer x = 4110
integer y = 1616
integer width = 439
integer height = 160
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Un-settled Imported Disbursements"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_4 from groupbox within w_sysadmin_editusers
integer x = 4096
integer y = 1588
integer width = 466
integer height = 284
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type st_4 from statictext within w_sysadmin_editusers
integer x = 4128
integer y = 1900
integer width = 411
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Change User ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_newid from singlelineedit within w_sysadmin_editusers
integer x = 4123
integer y = 1964
integer width = 407
integer height = 84
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type cb_changeuserid from commandbutton within w_sysadmin_editusers
integer x = 4183
integer y = 2060
integer width = 288
integer height = 80
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "C&hange"
end type

event clicked;long	ll_row, ll_returnrows, ll_found, ll_count, ll_user_group
string	ls_olduserid, ls_newuserid
n_ds_useradmin lds_datastore
n_sysadmin lnv_sysadmin
transaction mytrans
Integer li_profile

// Get new userid, if none return
ls_newuserid = trim(sle_newid.text, true)
if Len(ls_newuserid) < 2 then
	MessageBox("Validation Error", "Please specify a new User ID")
	return
end if

// Get old userid, group and profile if none return
ll_row = dw_userlist.getselectedrow(0)
if ll_row < 1 then return
ls_olduserid = dw_userlist.getitemstring(ll_row, "userid")
ll_user_group = dw_userlist.getitemnumber(ll_row, "user_group")
li_profile = dw_userlist.getitemnumber(ll_row, "users_user_profile")

// Check if user is online
wf_refreshonline( )
if dw_userlist.getitemnumber(ll_row,"useronline")=1 then
	messagebox("Error", "You cannot change the User ID while the user is online.", Exclamation!)
	return
end if

SELECT COUNT(*) INTO :ll_count FROM USERS WHERE USERID = :ls_newuserid;
COMMIT;

if ll_count <> 0 then
	MessageBox("Validation Error", "New User ID already exists. Please try with another ID.")
	return
end if
	
// Ask user for confirmation
if MessageBox("Confirmation", "Are you sure that you would like to change User ID:~n~r~n~r" &
	+"'"+ls_olduserid+"' to '"+ls_newuserid+"'",Question!, YesNo!,2) = 2 then return

setPointer(hourglass!)

/* workaround PB bugfix */
mytrans = create transaction
mytrans.DBMS 			= sqlchangeuser.DBMS
mytrans.Database 		= sqlchangeuser.Database
mytrans.LogPAss 		= sqlchangeuser.LogPass
mytrans.ServerName	= sqlchangeuser.ServerName
mytrans.LogId			= sqlchangeuser.LogId
mytrans.AutoCommit	= true
mytrans.DBParm		= sqlchangeuser.DBParm
connect using mytrans;

//Change userid through stored procedure
//lds_datastore = create n_ds
lds_datastore = create n_ds_useradmin
lds_datastore.dataobject = "d_sp_change_userid"
lds_datastore.setTransObject(mytrans)

ll_returnrows = lds_datastore.retrieve(ls_olduserid, ls_newuserid)

if ll_returnrows <> 1 then 
	rollback using mytrans ;
	MessageBox("Error", "User ID change failed (1)")
	setPointer(arrow!)
	disconnect using mytrans;
	destroy mytrans;
	return
end if

if lds_datastore.getItemString(1, "return_string") <> "OK" then
	rollback using mytrans ;
	MessageBox("Error", "User ID change failed (2)")
	setPointer(arrow!)
	disconnect using mytrans;
	destroy mytrans;
	return
end if

// Set roles and group for new user - CR 2575
String ls_Role = "TRAMOSUSER"
lnv_sysadmin = Create n_sysadmin

if li_Profile = 4 then ls_role ="DEVELOPER"
if li_Profile = 5 then ls_role ="SUPPORT"
if lnv_sysadmin.of_add_role(ls_newuserid, ls_role, true, mytrans) = c#return.failure then
	rollback using mytrans ;
	MessageBox("Error", "User ID change failed. Could not assign role " + ls_role + ".")
	setPointer(arrow!)
	disconnect using mytrans;
	destroy mytrans;
	destroy lnv_sysadmin
	return	
end if

// if administrator and profile is Finance or Support then assign sso_role
if ll_user_group =c#usergroup.#ADMINISTRATOR and (li_Profile=3 or li_Profile = 5) then
	if lnv_sysadmin.of_add_role(ls_newuserid, "sso_role", false,  mytrans) = c#return.failure then
		MessageBox("Error", "User ID change failed. Could not assign sso_role.")
		setPointer(arrow!)
		disconnect using mytrans;
		destroy mytrans;
		destroy lnv_sysadmin
		return
	end if
	//Only Finance Admin have access to change user id
	if li_profile = 3 then
		if lnv_sysadmin.of_add_role(ls_newuserid, "replication_role", false, mytrans)	= c#return.failure then
			MessageBox("Error", "User ID change failed. Could not assign replication_role.")
			setPointer(arrow!)
			disconnect using mytrans;
			destroy mytrans;
			destroy lnv_sysadmin
			return
		end if    
	end if
end if
Destroy lnv_sysadmin

// ------------------------------------------- End CR 2575

// Final commit
commit using mytrans;

dw_userlist.setredraw(false)
parent.TriggerEvent("ue_retrieve")
wf_refreshonline( )
ll_found = dw_userlist.find("userid='"+ls_newuserid+"'",1, dw_userlist.rowcount( ))
if ll_found > 0 then
	dw_userlist.selectrow(0, false)
	dw_userlist.selectrow(ll_found, true)
	dw_userlist.scrollToRow(ll_found)
end if 

// Set users password as expired
Update USERS Set PW_LAST_CHANGED='2000-01-01' Where USERID=:ls_newuserid;
Commit;  // No need to check for errors

dw_userlist.setredraw(true)
setPointer(arrow!)

//Messagebox("Warning", "This feature is being repaired. Ask Database admin to setup new user id.")
Messagebox("Success", "The User ID change was successful!")

sle_newid.text = ""

disconnect using mytrans;
destroy mytrans;

end event

type cb_refresh from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 712
integer width = 288
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Re&fresh"
end type

event clicked;
Parent.PostEvent("ue_retrieve")
post wf_refreshonline( )

sle_Search.Text = ""
end event

type cb_resetpassword from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 520
integer width = 293
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Reset PW"
end type

event clicked;//  Resets password for this user to "password"

String 		ls_sql
datetime 	ldt
long			ll_row, ll_rc

if dw_userlist.RowCount() < 1 then return
ll_row = dw_userlist.getSelectedRow(0)
if ll_row < 1 then 
	MessageBox("Selection Error", "Please select a user before resetting pawwsord")
	return
end if

if sqlca.logid = dw_userlist.getItemString(ll_row, "userid") then
	MessageBox("Reset Password", "You are not allowed to reset your own password from here. Use change password function!")
	return 
end if
	
ll_rc =  MessageBox("Reset Password", "You are about to reset the password for user " &
						+ dw_userlist.getItemString(ll_row, "first_name") +" " & 
						+ dw_userlist.getItemString(ll_row, "last_name") + "~r~n~r~n" &
						+ "Would you like to send a mail to the user or change to default password?~r~n~r~n" &
						+ "Yes~tMail sent to user with randomly generated password~r~n" &
						+ "No ~tPassword changed to 'Password1'~r~n", Question!,YesNoCancel!,1)

choose case ll_rc
	case 1
		// Reset password and send mail to user
		n_passwordreset lnv_reset
		
		lnv_reset = create n_passwordreset
		lnv_reset.of_resetpassword( dw_userlist.getItemString(ll_row, "userid") )
		
		destroy lnv_reset
	case 2
		//Reset password to default password - nio mail sent to user
		
		// Enable auto Commit, needed for sp_xx procedures 
		SQLchangeuser.AutoCommit = TRUE
	
		ls_sql = 'sp_password "'+SQLchangeuser.dbpass+'", Password1, '+dw_userlist.getItemString(ll_row, "userid")
		EXECUTE IMMEDIATE :ls_sql USING SQLchangeuser;
	
		IF SQLchangeuser.SqlCode = 0 THEN
			Messagebox("Password changed", "Password was successfully changed to 'Password1'.")
			/* Set password last Changed variabel */
			ldt = datetime(date("01-01-2000"), now())
			dw_userlist.SetItem( ll_row, "USERS_PW_LAST_CHANGED", ldt )
			If dw_userlist.update() = 1 Then
				COMMIT USING SQLchangeuser;
			Else
				ROLLBACK USING SQLchangeuser;
			End if 
		ELSE // Failure - display messagebox
			Messagebox("Password not changed", "Password was not changed.~r~rRe-try the operation.~r~rReason:~r" + SQLCA.SqlErrText)
		END IF
		
		// Disable auto Commit, needed for sp_xx procedures 
		SQLchangeuser.AutoCommit = FALSE
	case 3
		// return user cancelled the change
		return
end choose

end event

type st_3 from statictext within w_sysadmin_editusers
integer x = 4105
integer y = 1380
integer width = 453
integer height = 104
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clean-up Deleted Calculations"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cleanup from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 1492
integer width = 288
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "C&lean-up"
end type

event clicked;open(w_cleanup_deleted_calculations)
end event

type cb_saveas from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 808
integer width = 297
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Save&As..."
end type

event clicked;dw_userlist.saveas()
end event

type cb_upd_version from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 2372
integer width = 288
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Upd&ate"
end type

event clicked;/* Validate version number
	Version number can be "All" or in format "xx.xx.x"
*/

string ls_version
integer li_position, li_length
boolean lb_version_OK = true

dw_tramos_version.AcceptText()
ls_version = trim(dw_tramos_version.getItemString(1, "current_version"),true)
li_length = len(ls_version)

if ls_version <> "All" then
	if len(ls_version)<>7 then
		lb_version_OK=false
	else
		if mid(ls_version,3,1)<>"." or mid(ls_version,6,1)<>"." then lb_version_OK=false
		if not isnumber(mid(ls_version,1,2)) or not isnumber(mid(ls_version,4,2)) or not isnumber(mid(ls_version,7,1)) then lb_version_OK=false
	end if	
else
	lb_version_OK = True
end if

if lb_version_OK then
	if dw_tramos_version.Update() = 1 then
		COMMIT USING SQLChangeUser;
	else		
		ROLLBACK USING SQLChangeUser;
	end if
else
	MessageBox("Error", "Version number must be specified as 'All' or in format 'xx.xx.x'")
end if
end event

type st_1 from statictext within w_sysadmin_editusers
integer x = 4110
integer y = 2184
integer width = 439
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Current TRAMOS Version"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_tramos_version from datawindow within w_sysadmin_editusers
integer x = 4137
integer y = 2288
integer width = 384
integer height = 76
integer taborder = 100
string title = "none"
string dataobject = "d_current_version"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_unlock from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 424
integer width = 288
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "u&nLock"
end type

event clicked;Long ll_Row

ll_Row = dw_userlist.GetRow ()
If ll_Row <> 0 Then
	dw_userlist.SetItem(ll_row,"USERS_LOCKED", 0)
	If dw_userlist.update() = 1 Then
		COMMIT USING SQLChangeUser;
	Else
		ROLLBACK USING SQLChangeUser;
	End if 
End if
this.enabled = FALSE
end event

type cb_undelete from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 328
integer width = 288
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&unDelete"
end type

event clicked;Long ll_Row

ll_Row = dw_userlist.GetRow ()
If ll_Row <> 0 Then
	dw_userlist.SetItem(ll_row,"USERS_DELETED", 0)
	If dw_userlist.update() = 1 Then
		COMMIT USING SQLChangeUser;
	Else
		ROLLBACK USING SQLChangeUser;
	End if 
End if
this.enabled = FALSE
end event

type cbx_deleted from checkbox within w_sysadmin_editusers
integer x = 4142
integer y = 1200
integer width = 407
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show deleted"
end type

event clicked;string ls_filter

if this.checked = TRUE then
	ls_filter = ""
	dw_userlist.setFilter(ls_filter)
	dw_userlist.filter()
	dw_userlist.setSort("userid")
	dw_userlist.Sort()
else
	ls_filter = "users_deleted = 0"
	dw_userlist.setFilter(ls_filter)
	dw_userlist.filter()
	dw_userlist.setSort("userid")
	dw_userlist.Sort()
end if

sle_Search.Text = ""
end event

type cb_1 from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 616
integer width = 288
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Help"
end type

event clicked;string ls_test

SELECT name into :ls_test FROM syslogins;

messagebox("x", ls_test )


end event

type cb_userdelete from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 232
integer width = 288
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long ll_row
string ls_userid
integer li_mng, li_mngdep

ll_row = dw_userlist.GetRow ()

if ll_row <> 0 then

	ls_userid = dw_userlist.GetItemString(ll_row, "USERID")
	
	//Check if user is a VIMS Management user. If so, do not allow deletion
	SELECT VETT_MNG_NOTIFY, MGMT 
	INTO :li_mng, :li_mngdep
	FROM USERS INNER JOIN VETT_DEPT ON USERS.VETT_DEPT=VETT_DEPT.DEPT_ID
	WHERE USERID=:ls_userid USING SQLChangeUser;
	
	if li_mng=1 or li_mngdep=1 then
		messagebox("Cannot Delete User", "User '" + ls_userid + "' is a VIMS Management user and cannot be deleted. To delete this user, please contact the Vetting Dept to have user removed from Management Status.", Exclamation!)
		return
	end if

	if messagebox("Warning","You are about to delete user ~r~r~n"+ dw_userlist.GetItemString(ll_row, "First_Name")+" "+ &
       	dw_userlist.getitemstring(ll_row, "Last_name" )+"~r~r~n continue ?", Exclamation!, YesNo!) = 1 then
       
		dw_userlist.setitem(ll_row,"USERS_DELETED", 1)

	     if dw_userlist.update() = 1 then
			COMMIT USING SQLChangeUser;
		else
			ROLLBACK USING SQLChangeUser;
 		end if 
	end if
 end if
cb_undelete.Enabled = TRUE
//Parent.PostEvent("ue_retrieve")



end event

type cb_usermodify from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 136
integer width = 288
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Modify"
end type

on clicked;If dw_userlist.GetRow() > 0 Then EditSingleUser( dw_userlist.GetRow () )



end on

type cb_usercreate from commandbutton within w_sysadmin_editusers
integer x = 4187
integer y = 40
integer width = 288
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cr&eate"
end type

on clicked;EditSingleUser(0)
end on

type dw_userlist from datawindow within w_sysadmin_editusers
integer x = 18
integer y = 32
integer width = 4041
integer height = 2432
integer taborder = 10
string dragicon = "Rectangle!"
string dataobject = "dw_userlist"
boolean vscrollbar = true
string icon = "Rectangle!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 and uo_global.ii_user_profile <> 4 then
	this.selectrow(0, FALSE)
	this.selectrow(currentrow, TRUE)
	cb_usermodify.enabled = TRUE
	/* supervisors and below can't create or delete/undelete users */
	if uo_global.ii_access_level = 3 then
		if dw_userlist.getItemNumber(currentrow, "users_deleted") > 0 then
			cb_undelete.enabled = TRUE
			cb_userdelete.enabled = FALSE
		else
			cb_undelete.enabled = FALSE
			cb_userdelete.enabled = TRUE
		end if
	end if
	/* Unlock button */
	if dw_userlist.getItemNumber(currentrow, "users_locked") > 0 then
		cb_unlock.enabled = TRUE
	else
		cb_unlock.enabled = FALSE
	end if
else
	cb_undelete.enabled = FALSE
	cb_userdelete.enabled = FALSE
	cb_usermodify.enabled = FALSE
end if	
end event

event doubleclicked;if row > 0 and uo_global.ii_user_profile <> 4 then editsingleuser(row)
end event

event clicked;string ls_sort

if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort
end if

end event

type gb_1 from groupbox within w_sysadmin_editusers
integer x = 4096
integer y = 2156
integer width = 466
integer height = 308
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_2 from groupbox within w_sysadmin_editusers
integer x = 4096
integer y = 1352
integer width = 466
integer height = 236
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_sysadmin_editusers
integer x = 4096
integer y = 1872
integer width = 466
integer height = 284
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

