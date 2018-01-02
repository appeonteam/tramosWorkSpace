$PBExportHeader$w_msps_rejectreason.srw
$PBExportComments$The window is imput rejection reason for the msps message
forward
global type w_msps_rejectreason from mt_w_master
end type
type st_header from statictext within w_msps_rejectreason
end type
type uo_emailpreview from u_email_preview within w_msps_rejectreason
end type
type cb_sendemails from mt_u_commandbutton within w_msps_rejectreason
end type
end forward

global type w_msps_rejectreason from mt_w_master
integer width = 2770
integer height = 2092
string title = "Rejection Reason"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_header st_header
uo_emailpreview uo_emailpreview
cb_sendemails cb_sendemails
end type
global w_msps_rejectreason w_msps_rejectreason

type variables
string 	is_return = "cancel"
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_msps_rejectreason
   <OBJECT>		Object Description	</OBJECT>
   <USAGE>		vessel messages	</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	12-04-2012 CR20         LHC010        First Version
		12-07-2012 CR20			LHC010		  fix bug no email address
		15-05-2013 CR2690			LGX001		Change "TramosMT@maersk.com" as C#EMAIL.TRAMOSSUPPORT
		10-06-2013 CR3238			LHG008		Disabled email from dorpdown.
   </HISTORY>
********************************************************************/
end subroutine

on w_msps_rejectreason.create
int iCurrent
call super::create
this.st_header=create st_header
this.uo_emailpreview=create uo_emailpreview
this.cb_sendemails=create cb_sendemails
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_header
this.Control[iCurrent+2]=this.uo_emailpreview
this.Control[iCurrent+3]=this.cb_sendemails
end on

on w_msps_rejectreason.destroy
call super::destroy
destroy(this.st_header)
destroy(this.uo_emailpreview)
destroy(this.cb_sendemails)
end on

event close;call super::close;closewithreturn(this, is_return)
end event

event open;call super::open;string ls_reporttype, ls_reportno, ls_callfrom
long	 ll_row
s_email	lstr_email

ls_callfrom = lower(message.stringparm)

if not isvalid(w_msps_messages_list) then
	close(this)
	return
end if

if ls_callfrom = "reject" then
	//Called from w_msps_messages_list.cb_reject event clicked()
	this.title = "Rejection Reason"
	uo_emailpreview.st_message.text = "Rejection Reason"
	lstr_email.emailfrom[1] = C#EMAIL.TRAMOSSUPPORT
end if

uo_emailpreview.st_message.width = 1000
uo_emailpreview.sle_emailsubject.enabled = false
uo_emailpreview.st_attachments.visible = false
uo_emailpreview.mle_attachments.visible = false
uo_emailpreview.ddlb_emailfrom.enabled = false

ll_row = w_msps_messages_list.dw_list.getrow()

lstr_email.emailto = w_msps_messages_list.is_emailaddress

if ll_row > 0 then
	ls_reporttype = w_msps_messages_list.dw_list.getitemstring( ll_row, "report_type")
	ls_reportno = string(w_msps_messages_list.dw_list.getitemnumber( ll_row, "report_no"))
	if isnull(ls_reporttype) then ls_reporttype = ""
	if isnull(ls_reportno) then ls_reportno = ""
end if

st_header.text = "Vessel IMO: " + string(w_msps_messages_list.il_vesselimo) + &
				 "      Report No: " +  ls_reportno + &
				 "      Revision No: " +  string(w_msps_messages_list.il_revisionno) + &
				 "      Report Type: " +  ls_reporttype 

//Subject
lstr_email.subject = "Tramos alert"

//Message	
lstr_email.message = ""
uo_emailpreview.uf_init(lstr_email)
end event

type st_header from statictext within w_msps_rejectreason
integer x = 55
integer y = 448
integer width = 2670
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
boolean focusrectangle = false
end type

type uo_emailpreview from u_email_preview within w_msps_rejectreason
integer x = 37
integer y = 16
integer width = 2706
integer height = 1868
integer taborder = 30
end type

on uo_emailpreview.destroy
call u_email_preview::destroy
end on

type cb_sendemails from mt_u_commandbutton within w_msps_rejectreason
integer x = 2400
integer y = 1888
integer taborder = 30
string text = "&Send Email"
end type

event clicked;call super::clicked;w_msps_messages_list.is_rejectreason = uo_emailpreview.uf_get_message( )

is_return = "sent"
closewithreturn(parent, is_return)

end event

