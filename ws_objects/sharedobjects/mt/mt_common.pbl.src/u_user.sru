$PBExportHeader$u_user.sru
forward
global type u_user from mt_u_visualobject
end type
type dw_user from mt_u_datawindow within u_user
end type
end forward

global type u_user from mt_u_visualobject
integer width = 773
integer height = 72
long backcolor = 553648127
dw_user dw_user
end type
global u_user u_user

type variables
private string is_userid
datawindowchild idwc
mt_n_dddw_searchasyoutype inv_dddw_search
end variables

forward prototypes
public subroutine documentation ()
public function integer of_getuser ()
public function string of_getuserid ()
public function long of_getuserprofile ()
public subroutine of_setuserid (string as_userid)
end prototypes

public subroutine documentation ();/********************************************************************
   u_user
   <OBJECT>System user selection</OBJECT>
   <USAGE></USAGE>
   <ALSO></ALSO>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	08-06-2011 	2406          JMY014     		First Version
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_getuser ();/********************************************************************
   uf_getuser
   <DESC>	Get user list	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call this function from parent window</USAGE>
   <HISTORY>
   	Date       		CR-Ref       		Author             	Comments
   	23-05-2011 		CR2406           JMY014        		First Version
   </HISTORY>
********************************************************************/

long 		ll_row
long 		ll_user_profile
window 	lw_parent

dw_user.getchild("userid", idwc)
idwc.settransobject(sqlca)
idwc.retrieve()

ll_row = idwc.find("userid = '" + is_userid + "'", 0, idwc.rowcount())
if ll_row <= 0 then return c#return.Failure
ll_user_profile = idwc.getitemnumber(ll_row, "user_profile")
dw_user.setitem(1, "user_profile", ll_user_profile)
ll_row = idwc.insertrow(1)
idwc.setitem(ll_row, "user_profile", ll_user_profile)
idwc.selectrow(0, false)

return c#return.Success

end function

public function string of_getuserid ();/********************************************************************
   uf_getuserid
   <DESC>	Get current user id	</DESC>
   <RETURN>	string:The current user id</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Call directly from parent object	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       Author             Comments
   	08-06-2011  2406          JMY014            First Version
   </HISTORY>
********************************************************************/
return dw_user.getitemstring(1, "userid")
end function

public function long of_getuserprofile ();/********************************************************************
   uf_getuserprofile
   <DESC>	Get current user profile	</DESC>
   <RETURN>	long:The user profile</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       	CR-Ref       	Author             Comments
   	08-06-2011 	2406           JMY014          First Version
   </HISTORY>
********************************************************************/
return dw_user.getitemnumber(1, "user_profile")
end function

public subroutine of_setuserid (string as_userid);/********************************************************************
   of_setuserid
   <DESC>	Setup the userid	</DESC>
   <RETURN>	(None)	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_userid: user id
   </ARGS>
   <USAGE>	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	17-08-2011 2438         JMY014             First Version
   </HISTORY>
********************************************************************/
is_userid = as_userid
end subroutine

on u_user.create
int iCurrent
call super::create
this.dw_user=create dw_user
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_user
end on

on u_user.destroy
call super::destroy
destroy(this.dw_user)
end on

type dw_user from mt_u_datawindow within u_user
integer width = 759
integer height = 64
integer taborder = 10
string dataobject = "d_ex_ff_users"
boolean border = false
boolean livescroll = false
end type

event itemchanged;call super::itemchanged;long		ll_row
long		ll_user_profile
string		ls_userid

window	lw_parent

lw_parent = parent.getparent()
ls_userid = data
if (isnull(ls_userid)) then
	//Added by JMY014 on 21-06-2011. Change desc: Get all vessels for the current login user.
	lw_parent.dynamic event ue_userchanged(ls_userid, 0)
elseif(ls_userid = is_userid) then
	//Added by JMY014 on 21-06-2011. Change desc: Current login user is selected, my vessels should be filtered.
	lw_parent.dynamic event ue_userchanged(is_userid, 0)
else
	//Added by JMY014 on 21-06-2011. Change desc: If the selected user is not the login user, get the user's profile
	ll_row = idwc.find("userid = '" + ls_userid + "'", 1, idwc.rowcount())
	if (ll_row <= 0) then return
	ll_user_profile = idwc.getitemnumber(ll_row, "user_profile")
	this.setitem(1, "user_profile", ll_user_profile)
	lw_parent.dynamic event ue_userchanged(ls_userid, ll_user_profile)
end if

end event

event editchanged;call super::editchanged;inv_dddw_search.event mt_editchanged(row, dwo, data, dw_user)
end event

event losefocus;call super::losefocus;this.accepttext( )
end event

