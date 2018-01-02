$PBExportHeader$w_show_failed_mailaddresses.srw
$PBExportComments$Shows the failed mail addresses then sending out the position lists. It will be possible to modify the addresses and save them back to the contact list
forward
global type w_show_failed_mailaddresses from mt_w_main
end type
type st_1 from statictext within w_show_failed_mailaddresses
end type
type cb_cancel from mt_u_commandbutton within w_show_failed_mailaddresses
end type
type cb_update from mt_u_commandbutton within w_show_failed_mailaddresses
end type
type dw_failed_emails from mt_u_datawindow within w_show_failed_mailaddresses
end type
end forward

global type w_show_failed_mailaddresses from mt_w_main
integer width = 3602
integer height = 1924
string title = "Wrong Email Addresses "
boolean maxbox = false
boolean resizable = false
st_1 st_1
cb_cancel cb_cancel
cb_update cb_update
dw_failed_emails dw_failed_emails
end type
global w_show_failed_mailaddresses w_show_failed_mailaddresses

type variables
mt_n_datastore	ids_failed
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
   </HISTORY>
********************************************************************/
end subroutine

event open;ids_failed = create mt_n_datastore

ids_failed = message.powerObjectParm
dw_failed_emails.dataobject = ids_failed.dataobject
ids_failed.sharedata(dw_failed_emails)
end event

on w_show_failed_mailaddresses.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_failed_emails=create dw_failed_emails
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_update
this.Control[iCurrent+4]=this.dw_failed_emails
end on

on w_show_failed_mailaddresses.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_failed_emails)
end on

type st_1 from statictext within w_show_failed_mailaddresses
integer x = 18
integer y = 60
integer width = 3557
integer height = 132
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Below is a list of mail addresses, that are not correct. If you like, you can correct them here and press update. Please be aware of that below addresses have NOT received the position list."
boolean focusrectangle = false
end type

type cb_cancel from mt_u_commandbutton within w_show_failed_mailaddresses
integer x = 1865
integer y = 1712
integer taborder = 30
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;close(parent)
end event

type cb_update from mt_u_commandbutton within w_show_failed_mailaddresses
integer x = 1358
integer y = 1712
integer taborder = 20
string text = "&Update"
boolean default = true
end type

event clicked;call super::clicked;long 	ll_rows, ll_row
long 	ll_id
string	ls_mailadr, ls_sql, ls_fieldname

dw_failed_emails.accepttext()
ll_rows = ids_failed.rowCount()

for ll_row = 1 to ll_rows
	ll_id = dw_failed_emails.getItemNumber(ll_row, "company_or_contact_id")
	ls_mailadr = dw_failed_emails.getItemString(ll_row, "mail_address")
	if dw_failed_emails.getItemNumber(ll_row, "company") = 1 then
		choose case dw_failed_emails.getItemString(ll_row, "address_type")
			case "pf_company_email"
				ls_fieldname = "EMAIL"
			case "pf_company_email2"
				ls_fieldname = "EMAIL2"
			case "pf_company_charteringemail"
				ls_fieldname = "CHARTERINGEMAIL"
			case "pf_company_operationemail"
				ls_fieldname = "OPERATIONEMAIL"
			case "pf_company_financeemail"
				ls_fieldname = "FINANCEEMAIL"
		end choose
		ls_sql = "UPDATE PF_COMPANY SET "+ls_fieldname+" = '"+ls_mailadr+"' WHERE COMPANYID="+STRING( ll_id )
		EXECUTE IMMEDIATE :ls_sql;
		if sqlca.sqlcode = 0 then
			COMMIT;
		else
			ROLLBACK;
			MessageBox("Update failed", "Update of Company Table failed. Please contact System Administrator")
		end if
	else
		UPDATE PF_COMPANYCONTACTS
			SET EMAIL = :ls_mailadr
			WHERE CONTACTSID = :ll_id ;
		if sqlca.sqlcode = 0 then
			COMMIT;
		else
			ROLLBACK;
			MessageBox("Update failed", "Update of Company Contact Table failed. Please contact System Administrator")
		end if
	end if
next

close(parent)
end event

type dw_failed_emails from mt_u_datawindow within w_show_failed_mailaddresses
integer y = 216
integer width = 3575
integer height = 1444
integer taborder = 10
string dataobject = "d_failed_emails"
boolean vscrollbar = true
end type

