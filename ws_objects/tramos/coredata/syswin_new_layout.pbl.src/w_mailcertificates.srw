$PBExportHeader$w_mailcertificates.srw
forward
global type w_mailcertificates from mt_w_sheet
end type
type tab_1 from tab within w_mailcertificates
end type
type tabpage_1 from userobject within tab_1
end type
type st_2 from statictext within tabpage_1
end type
type dw_vessel_certificates from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_2 st_2
dw_vessel_certificates dw_vessel_certificates
end type
type tabpage_2 from userobject within tab_1
end type
type uo_selectemailaddresses from u_selectemailaddresses within tabpage_2
end type
type tabpage_2 from userobject within tab_1
uo_selectemailaddresses uo_selectemailaddresses
end type
type tabpage_3 from userobject within tab_1
end type
type uo_emailpreview from u_email_preview within tabpage_3
end type
type tabpage_3 from userobject within tab_1
uo_emailpreview uo_emailpreview
end type
type tab_1 from tab within w_mailcertificates
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_sendemails from commandbutton within w_mailcertificates
end type
type cb_close from commandbutton within w_mailcertificates
end type
end forward

global type w_mailcertificates from mt_w_sheet
integer width = 2830
integer height = 2348
string title = "Mail Certificates"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
tab_1 tab_1
cb_sendemails cb_sendemails
cb_close cb_close
end type
global w_mailcertificates w_mailcertificates

type variables
long	il_vesselnr
long	il_pcgroup_id
long	il_officeid
string is_vesselname
string	is_pcname
s_email	istr_email
long	il_filesid[]


private n_service_manager _inv_serviceMgr

CONSTANT STRING CRLF="~r~n"
end variables

forward prototypes
public subroutine wf_refreshwindow ()
private subroutine wf_initialize_emailpreview ()
public subroutine documentation ()
end prototypes

public subroutine wf_refreshwindow ();/********************************************************************
   wf_refreshwindow( )
   <DESC> Initializes window </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Use this function to Initialize the window:
						files list, companies list, email preview 	</USAGE>
********************************************************************/

//initialize instantiate variables
SELECT VESSEL_NAME, PROFIT_C.PCGROUP_ID, PROFIT_C.PC_NAME
INTO :is_vesselname, :il_pcgroup_id, :is_pcname
FROM VESSELS, PROFIT_C
WHERE  VESSELS.PC_NR = PROFIT_C.PC_NR
	AND VESSEL_NR=:il_vesselnr
commit using SQLCA;
	
this.title = "Mail Certificates " + is_vesselname

//refresh certificates list
tab_1.tabpage_1.dw_vessel_certificates.settransobject(SQLCA)
if tab_1.tabpage_1.dw_vessel_certificates.retrieve(il_vesselnr) < 0 then
	MessageBox("Error","Invalid retrieval!")
	return
end if

//refresh Email addresses
if tab_1.tabpage_2.uo_selectemailaddresses.uf_init(il_pcgroup_id) = -1 then
	MessageBox("Warning", "No contacts found.")
end if

//Initializes email preview
wf_initialize_emailpreview( )

end subroutine

private subroutine wf_initialize_emailpreview ();/********************************************************************
   wf_initialize_emailpreview 
   <DESC> Initializes Tab Email Preview </DESC>
   <RETURN> 
   </RETURN>
   <ACCESS> Private  </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	Initializes email preview. Called from the window open event. 
	</USAGE>
********************************************************************/

long	ll_row, ll_rowarray, ll_officeid
string	ls_tmp, ls_emailtmp
string 	ls_emailarray[]
mt_n_datastore		lds_emailaddresses
		
//Email from

lds_emailaddresses = create mt_n_datastore
lds_emailaddresses.dataobject = "d_dddw_office_email_by_userprofile"
lds_emailaddresses.setTransObject(sqlca)

if lds_emailaddresses.retrieve(il_pcgroup_id, uo_global.getuserid()) = -1 then
	MessageBox("Error","Error retrieving office information!")
	return
end if

ll_rowarray = 1
for ll_row = 1 to lds_emailaddresses.rowcount( )
	if ls_emailtmp <>  lds_emailaddresses.getitemstring(ll_row, "email") then
		ls_emailtmp =  lds_emailaddresses.getitemstring(ll_row, "email")
		ls_emailarray[ll_rowarray] =ls_emailtmp
		ll_rowarray = ll_rowarray + 1
	end if
	 ll_officeid =  lds_emailaddresses.getitemnumber( ll_row, "office_nr")
	if ll_officeid = il_officeid then
		istr_email.emailfrom_selection_pos = ll_rowarray - 1
	end if
next
if ll_rowarray > 1 then
	istr_email.emailfrom = ls_emailarray
end if

destroy (lds_emailaddresses)

// Subject
istr_email.subject = "(Auto Email) " + is_pcname + " > " + is_vesselname + " > vessel certificates"

//Message	
istr_email.message = "Kindly find the " + is_vesselname + " certificates in the attached PDF file(s)."+ CRLF+CRLF + "Best regards, " + CRLF + is_pcname

tab_1.tabpage_3.uo_emailpreview.uf_init(istr_email )
			


end subroutine

public subroutine documentation ();/********************************************************************
   ObjectName: w_mailcertificates - Send certificates by email
   <OBJECT> System Tables - General - Vessels - send certificates by email	</OBJECT>
   <USAGE> Files selection, contacts selection and email overview.
					public wf_refreshwindow  - Initializes window
					private wf_initialize_emailpreview - initializes tab Email Preview
					
					Objects structure:
						tabpage_1 - d_sq_tb_vessel_certificates
						tabpage_2 - u_selectemailaddresses
								w_contacts_overview
										u_company_detail
										u_contact_detail
						tabpage_3 - u_email_preview
   </USAGE>
   <ALSO>   	
   </ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
   17/06/10	CR1412	Joana Carvalho	First Version
	10/08/14 CR3753  SSX014 Support File Database Archiving
</HISTORY>    
********************************************************************/
end subroutine

on w_mailcertificates.create
int iCurrent
call super::create
this.tab_1=create tab_1
this.cb_sendemails=create cb_sendemails
this.cb_close=create cb_close
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.cb_sendemails
this.Control[iCurrent+3]=this.cb_close
end on

on w_mailcertificates.destroy
call super::destroy
destroy(this.tab_1)
destroy(this.cb_sendemails)
destroy(this.cb_close)
end on

event open;n_dw_style_service   lnv_style

il_vesselnr = message.doubleparm

/* setup datawindow formatter service */
_inv_serviceMgr.of_loadservice( lnv_style, "n_dw_style_service")
lnv_style.of_dwlistformater(tab_1.tabpage_1.dw_vessel_certificates)

SELECT OFFICE_NR
INTO :il_officeid
FROM USERS
WHERE USERID = :uo_global.is_userid
commit using SQLCA;


wf_refreshwindow()


end event

type st_hidemenubar from mt_w_sheet`st_hidemenubar within w_mailcertificates
end type

type tab_1 from tab within w_mailcertificates
event create ( )
event destroy ( )
integer x = 23
integer y = 16
integer width = 2757
integer height = 2116
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

event selectionchanged;string	ls_tmp
string	ls_empty[]
long	ll_empty[]
long	ll_row, ll_row_res

if newindex = 2 then

	tab_1.tabpage_2.uo_selectemailaddresses.uo_searchbox.sle_search.POST setfocus()

elseif newindex = 3 then
		
	//Email To
	tab_1.tabpage_2.uo_selectemailaddresses.uf_getselectedemails(istr_email.emailto )

	//attachments
	ls_tmp = ""
	ll_row_res = 1
	istr_email.attachments = ls_empty
	il_filesid = ll_empty
	for ll_row = 1 to tab_1.tabpage_1.dw_vessel_certificates.rowcount( )
		if tab_1.tabpage_1.dw_vessel_certificates.getitemnumber(ll_row,"select_file" ) = 1 then
			istr_email.attachments[ll_row_res] = tab_1.tabpage_1.dw_vessel_certificates.getitemstring( ll_row, "file_name")
			il_filesid[ll_row_res] = tab_1.tabpage_1.dw_vessel_certificates.getitemnumber( ll_row, "file_id")
			ll_row_res = ll_row_res +1
		end if
	next

	tab_1.tabpage_3.uo_emailpreview.uf_refresh(istr_email )
	
end if

end event

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 2720
integer height = 2000
long backcolor = 67108864
string text = "1. Select Files"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_2 st_2
dw_vessel_certificates dw_vessel_certificates
end type

on tabpage_1.create
this.st_2=create st_2
this.dw_vessel_certificates=create dw_vessel_certificates
this.Control[]={this.st_2,&
this.dw_vessel_certificates}
end on

on tabpage_1.destroy
destroy(this.st_2)
destroy(this.dw_vessel_certificates)
end on

type st_2 from statictext within tabpage_1
integer x = 73
integer y = 2144
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "PREVIEW FILE"
boolean focusrectangle = false
end type

type dw_vessel_certificates from datawindow within tabpage_1
integer x = 41
integer y = 40
integer width = 1737
integer height = 1780
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_vessel_certificates"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row>0 then
	dw_vessel_certificates.selectRow(0,false)
	dw_vessel_certificates.selectRow(row,true)
end if
end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 100
integer width = 2720
integer height = 2000
long backcolor = 67108864
string text = "2. Select Email(s)"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_selectemailaddresses uo_selectemailaddresses
end type

on tabpage_2.create
this.uo_selectemailaddresses=create uo_selectemailaddresses
this.Control[]={this.uo_selectemailaddresses}
end on

on tabpage_2.destroy
destroy(this.uo_selectemailaddresses)
end on

type uo_selectemailaddresses from u_selectemailaddresses within tabpage_2
integer x = 32
integer y = 32
integer width = 2683
integer height = 1956
integer taborder = 20
end type

on uo_selectemailaddresses.destroy
call u_selectemailaddresses::destroy
end on

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 100
integer width = 2720
integer height = 2000
long backcolor = 67108864
string text = "Email Preview"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
uo_emailpreview uo_emailpreview
end type

on tabpage_3.create
this.uo_emailpreview=create uo_emailpreview
this.Control[]={this.uo_emailpreview}
end on

on tabpage_3.destroy
destroy(this.uo_emailpreview)
end on

type uo_emailpreview from u_email_preview within tabpage_3
integer y = 40
integer taborder = 40
end type

on uo_emailpreview.destroy
call u_email_preview::destroy
end on

type cb_sendemails from commandbutton within w_mailcertificates
integer x = 2418
integer y = 2144
integer width = 379
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Send Email(s)"
end type

event clicked;string	ls_emailfrom, ls_subject, ls_message, ls_errorMessage
long		ll_address, ll_attachment
longlong	ll_bytes = 0
blob		lbl_filecontent
mt_n_outgoingmail	lnv_mail
n_object_usage_log use_log

n_service_manager lnv_serviceMgr
n_fileattach_service	lnv_attachmentService

tab_1.selectedtab = 3

//validate if any file and contact is selected
ls_emailfrom = tab_1.tabpage_3.uo_emailpreview.uf_get_emailfrom()
if ls_emailfrom = "" then
	MessageBox("Error","'Email From' field is empty.")
	return
end if

if upperbound(il_filesid) = 0 then
	MessageBox("Error","'Please select a certificate.")
	tab_1.selectedtab = 1
	return
end if

if upperbound(istr_email.emailto) = 0 then
	MessageBox("Error","'Please select a contact (email address).")
	tab_1.selectedtab = 2
	return
end if

/*
emailfrom = uf_get_emailfrom
emailto = istr_email.emailto ---- array of email addresses (already validated)
subject = uf_get_subject
attachments --- il_filesid[] array of ids 
message = uf_get_message
*/

if MessageBox("Send Email", "Send email?", Question!, YesNo!) = 1 then
	lnv_mail = create mt_n_outgoingmail

	ll_address = 1
	//CREATE EMAIL
	ls_subject = tab_1.tabpage_3.uo_emailpreview.uf_get_subject( )
	ls_message = tab_1.tabpage_3.uo_emailpreview.uf_get_message( )
	
	if lnv_mail.of_createmail(ls_emailfrom,  istr_email.emailto[ll_address] , ls_subject , ls_message, ls_errorMessage) = -1 then	
		Messagebox("Error", "Error when creating the emaill. Reason: "+ls_errorMessage)
		destroy (lnv_mail)
		return
	end if
	
	if lnv_mail.of_setcreator( uo_global.is_userid,  ls_errorMessage) = -1 then
		Messagebox("Error", "Error when creating the emaill in Set Creator. Reason: "+ls_errorMessage)
		destroy (lnv_mail)
		return
	end if

	//ATTACHMENTS (...)

	lnv_serviceMgr.of_loadservice( lnv_attachmentService, "n_fileattach_service" )

	for ll_attachment = 1 to upperbound(il_filesid)
		if lnv_attachmentservice.of_readblob("VESSEL_CERT_FILES", il_filesid[ll_attachment], lbl_filecontent, ll_bytes ) = -1 then
			RETURN -1
		end if
		lnv_mail.of_addattachment(lbl_filecontent, istr_email.attachments[ll_attachment], ll_bytes, ls_errorMessage)
	next

	for ll_address = 2 to upperbound(istr_email.emailto)
		//ADD EMAIL ADDRESS
		lnv_mail.of_addreceiver( istr_email.emailto[ll_address], ls_errorMessage )
	next

	if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
		Messagebox("Error", "Error when sending the emai. Reason: "+ls_errorMessage)
		destroy (lnv_mail)
		return
	end if

	destroy (lnv_mail)
	
	MessageBox("Send Email", "Email successfully sent.")

	use_log.uf_log_object("Vessels - Certificates - " + this.text)
end if

end event

type cb_close from commandbutton within w_mailcertificates
boolean visible = false
integer x = 2043
integer y = 2144
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;close(Parent)

end event

