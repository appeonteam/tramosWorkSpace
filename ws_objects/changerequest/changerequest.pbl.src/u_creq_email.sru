$PBExportHeader$u_creq_email.sru
forward
global type u_creq_email from u_email_preview
end type
type cb_address from mt_u_commandbutton within u_creq_email
end type
end forward

global type u_creq_email from u_email_preview
integer width = 2715
integer height = 1868
cb_address cb_address
end type
global u_creq_email u_creq_email

type variables
s_email istr_email
end variables

forward prototypes
public function integer of_sendmail ()
public subroutine documentation ()
private function integer _get_emailto (ref string as_emailto[])
end prototypes

public function integer of_sendmail ();/********************************************************************
   of_sendmail
   <DESC>	send out email	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	w_request_email	</USAGE>
   <HISTORY>
		Date			CR-Ref	Author	Comments
		01-21-2013	CR2614	LHG008	First Version
   </HISTORY>
********************************************************************/

string ls_emailto[], ls_filespath[]
integer li_return
n_creq_request lnv_request

_get_emailto(ls_emailto)

lnv_request = create n_creq_request

li_return = lnv_request.of_sendmail(sqlca.userid, uf_get_emailfrom(), ls_emailto, uf_get_subject(), uf_get_message(), ls_filespath)

destroy lnv_request
return li_return
end function

public subroutine documentation ();/********************************************************************
   u_creq_email
   <OBJECT>		Send email	</OBJECT>
   <USAGE>		Sent email for change request  /USAGE>
   <ALSO>		n_creq_request, w_request_email	
					ancestor object is mt_mail::u_email_preview.
					difference with ancestor:
							1. Change GUI
							2. Select from popup window w_select_emailaddress for field "Mail to" 
							3. Add function _get_emailto()
							4. Add function of_sendmail()
	</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        	Comments
   	01-21-2013 CR2614       LHG008        	First Version
		13-07-2013 CR3254			LHC010		  	Replace n_string_service
		05/09/2016 CR3754			AGL027			Single Sign On modifications - support Become User feature
   </HISTORY>
********************************************************************/
end subroutine

private function integer _get_emailto (ref string as_emailto[]);mt_n_stringfunctions		lnv_string

return lnv_string.of_parsetoarray(mle_emailto.text, '; ', as_emailto)
end function

on u_creq_email.create
int iCurrent
call super::create
this.cb_address=create cb_address
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_address
end on

on u_creq_email.destroy
call super::destroy
destroy(this.cb_address)
end on

type st_message from u_email_preview`st_message within u_creq_email
integer x = 18
integer y = 464
integer width = 192
boolean enabled = false
alignment alignment = right!
end type

type st_attachments from u_email_preview`st_attachments within u_creq_email
boolean visible = false
integer x = 2816
integer y = 1552
end type

type st_emailsubject from u_email_preview`st_emailsubject within u_creq_email
integer x = 37
integer y = 368
integer width = 174
integer height = 48
boolean enabled = false
alignment alignment = right!
boolean disabledlook = false
end type

type st_emailto from u_email_preview`st_emailto within u_creq_email
integer x = 82
boolean enabled = false
alignment alignment = right!
boolean disabledlook = false
end type

type mle_message from u_email_preview`mle_message within u_creq_email
integer y = 536
integer height = 1320
integer taborder = 30
long backcolor = 16777215
string text = ""
end type

type mle_attachments from u_email_preview`mle_attachments within u_creq_email
boolean visible = false
integer y = 976
end type

type sle_emailsubject from u_email_preview`sle_emailsubject within u_creq_email
integer x = 233
integer y = 368
integer width = 2469
integer taborder = 20
long backcolor = 16777215
string text = ""
end type

type st_emailfrom from u_email_preview`st_emailfrom within u_creq_email
integer x = 37
boolean enabled = false
alignment alignment = right!
boolean disabledlook = false
end type

type mle_emailto from u_email_preview`mle_emailto within u_creq_email
integer x = 233
integer y = 112
integer width = 2359
integer height = 240
integer taborder = 0
long textcolor = 0
long backcolor = 553648127
string text = ""
end type

type ddlb_emailfrom from u_email_preview`ddlb_emailfrom within u_creq_email
integer x = 233
integer taborder = 0
long backcolor = 553648127
boolean enabled = false
boolean border = false
end type

type cb_address from mt_u_commandbutton within u_creq_email
integer x = 2610
integer y = 112
integer width = 91
integer height = 80
integer taborder = 10
boolean bringtotop = true
string text = "..."
end type

event clicked;call super::clicked;string ls_mailadderss

ls_mailadderss = mle_emailto.text

openwithparm(w_select_emailaddress, ls_mailadderss, w_request_email)

ls_mailadderss = message.stringparm

//Selected/unselected email adderss
if len(ls_mailadderss) > 0 then
	if ls_mailadderss = 'clear' then ls_mailadderss = ''
	mle_emailto.text = ls_mailadderss
end if
end event

