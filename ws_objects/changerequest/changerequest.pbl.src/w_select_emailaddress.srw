$PBExportHeader$w_select_emailaddress.srw
$PBExportComments$Select email address from table USERS
forward
global type w_select_emailaddress from mt_w_response
end type
type uo_searchbox from u_creq_search within w_select_emailaddress
end type
type cb_ok from mt_u_commandbutton within w_select_emailaddress
end type
type dw_user from mt_u_datawindow within w_select_emailaddress
end type
end forward

global type w_select_emailaddress from mt_w_response
integer width = 1179
integer height = 1708
string title = "Select Email Address"
boolean ib_setdefaultbackgroundcolor = true
uo_searchbox uo_searchbox
cb_ok cb_ok
dw_user dw_user
end type
global w_select_emailaddress w_select_emailaddress

type variables
constant string is_EMAILDELIMITER = "; "
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_select_emailaddress
   <OBJECT>		Select Email Address	</OBJECT>
   <USAGE>	REF: u_creq_email.cb_address.clicked()	</USAGE>
   <ALSO>	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        First Version
		15/05/2013 2690			LGX001		change "@maersk.com" 			 as C#EMAIL.DOMAIN 
		07-09-2013 CR3254			LHC010		  Replace n_string_service
		04/03/2016	CR4316		AGL027		Obtain email address of users from database instead of using constant.
   </HISTORY>
********************************************************************/
end subroutine

on w_select_emailaddress.create
int iCurrent
call super::create
this.uo_searchbox=create uo_searchbox
this.cb_ok=create cb_ok
this.dw_user=create dw_user
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_searchbox
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_user
end on

on w_select_emailaddress.destroy
call super::destroy
destroy(this.uo_searchbox)
destroy(this.cb_ok)
destroy(this.dw_user)
end on

event open;call super::open;n_service_manager		lnv_servicemgr
n_dw_style_service	lnv_style
mt_n_stringfunctions lnv_string
string ls_emailaddress, ls_addressarray[]
long ll_rowcount, ll_i, ll_find

lnv_servicemgr.of_loadservice(lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(dw_user, false)

dw_user.settransobject(sqlca)
dw_user.retrieve()

// Initialize search box
uo_searchbox.of_initialize(dw_user, "search_col")
uo_searchbox.sle_search.post setfocus()

uo_searchbox.of_setoriginalfilter("is_selected = 1")

ls_emailaddress = message.stringparm

if ls_emailaddress > '' then
	ll_rowcount = dw_user.rowcount()
	if ll_rowcount < 1 then return
	
	lnv_string.of_parsetoarray(ls_emailaddress, is_EMAILDELIMITER, ls_addressarray)
	
	dw_user.selectrow(0, false)
	//Highlight original slected email adderss
	for ll_i = 1 to upperbound(ls_addressarray)
		ll_find = dw_user.find("email = '" + ls_addressarray[ll_i] + "'", 1, ll_rowcount)
		if ll_find > 0 then
			dw_user.selectrow(ll_find, true)
			dw_user.setitem(ll_find, 'is_selected', 1)
		end if
	next
	dw_user.sort()
end if

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_emailaddress
end type

type uo_searchbox from u_creq_search within w_select_emailaddress
integer x = 37
integer y = 16
integer width = 1097
integer taborder = 70
end type

on uo_searchbox.destroy
call u_creq_search::destroy
end on

type cb_ok from mt_u_commandbutton within w_select_emailaddress
integer x = 791
integer y = 1504
integer taborder = 50
string text = "&OK"
boolean default = true
end type

event clicked;call super::clicked;string ls_emails

dw_user.of_get_selectedvalues('email', ls_emails, is_EMAILDELIMITER)

if ls_emails > '' then
	ls_emails = ls_emails + is_EMAILDELIMITER
else
	ls_emails = 'clear'
end if

closewithreturn(parent, ls_emails)
end event

type dw_user from mt_u_datawindow within w_select_emailaddress
integer x = 37
integer y = 192
integer width = 1097
integer height = 1296
integer taborder = 30
string dataobject = "d_sq_gr_selectuser"
boolean vscrollbar = true
boolean border = false
end type

event clicked;call super::clicked;if row <=0 then return

this.setrow(row)

if this.isselected(row) then
	this.selectrow(row, false)
	this.setitem(row, 'is_selected', 0)
else	
	this.selectrow(row, true)
	this.setitem(row, 'is_selected', 1)
end if

end event

