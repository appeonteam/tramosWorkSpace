$PBExportHeader$w_request_email.srw
$PBExportComments$The window is manual send email for change request
forward
global type w_request_email from mt_w_response
end type
type cb_send from mt_u_commandbutton within w_request_email
end type
type uo_emailpreview from u_creq_email within w_request_email
end type
end forward

global type w_request_email from mt_w_response
integer width = 2770
integer height = 2096
string title = "Send Mail"
boolean ib_setdefaultbackgroundcolor = true
cb_send cb_send
uo_emailpreview uo_emailpreview
end type
global w_request_email w_request_email

type variables
string 	is_return = "cancel"
constant string is_EMAILDELIMITER = "; "
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_request_email
	
	<OBJECT>
	</OBJECT>
	<DESC>
	Send email
	</DESC>
  	<USAGE>
	Change request send email
	</USAGE>
	<ALSO>
	w_modify_changerequest.cb_email
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	01-25-2013 	CR2614      LHG008      First Version
		15/05/2013	CR2690		LGX001		1.change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
														2.change "@maersk.com" 			 as C#EMAIL.DOMAIN 
		11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		04/03/2016	CR4316		AGL027		Obtain email address of users from database instead of using constant.
		05/09/2016 	CR3754		AGL027		Single Sign On modifications - support Become User feature
	</HISTORY>
********************************************************************/
end subroutine

on w_request_email.create
int iCurrent
call super::create
this.cb_send=create cb_send
this.uo_emailpreview=create uo_emailpreview
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_send
this.Control[iCurrent+2]=this.uo_emailpreview
end on

on w_request_email.destroy
call super::destroy
destroy(this.cb_send)
destroy(this.uo_emailpreview)
end on

event close;call super::close;closewithreturn(this, is_return)
end event

event open;call super::open;string ls_reporttype, ls_reportno, ls_status
long	 ll_row, ll_requestid
mt_u_datawindow	ldw_request
mt_n_activedirectoryfunctions	lnv_adfunc
s_email	lstr_email

ldw_request = message.powerobjectparm

if not isvalid(ldw_request) then
	close(this)
	return
end if

ll_row = ldw_request.getrow()

ll_requestid = ldw_request.getitemnumber(ll_row, 'request_id')

if isnull(ll_requestid) then
	messagebox('Send Email','Please save before create email')
	close(this)
	return
end if

this.title = 'Mail Change Request #' + string(ll_requestid)

/* Initial email */
ls_status = ldw_request.describe("Evaluate('LookUpDisplay(status_id)', " + string(ll_row) + ")")

lstr_email.subject = 'Tramos - CR' + string(ll_requestid) + " - Status: " + ls_status

lstr_email.emailfrom = {lnv_adfunc.of_get_email_by_userid_from_db(sqlca.logid)}
lstr_email.emailto = {lnv_adfunc.of_get_email_by_userid_from_db(ldw_request.getitemstring(ll_row, "owner")) + is_EMAILDELIMITER}

uo_emailpreview.uf_init(lstr_email)


end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_request_email
end type

type cb_send from mt_u_commandbutton within w_request_email
integer x = 2377
integer y = 1888
integer taborder = 70
string text = "&Send Email"
end type

event clicked;call super::clicked;if uo_emailpreview.of_sendmail() = c#return.Success then
	is_return = 'sent'
	parent.event close( )
else
	is_return = "failure"
end if
end event

type uo_emailpreview from u_creq_email within w_request_email
event destroy ( )
integer x = 18
integer y = 16
integer height = 1872
integer taborder = 20
end type

on uo_emailpreview.destroy
call u_creq_email::destroy
end on

