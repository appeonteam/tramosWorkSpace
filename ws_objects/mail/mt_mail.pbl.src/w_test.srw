$PBExportHeader$w_test.srw
forward
global type w_test from window
end type
type cb_add from commandbutton within w_test
end type
type cb_send from commandbutton within w_test
end type
type dw_attachment from datawindow within w_test
end type
type dw_receiver from datawindow within w_test
end type
type dw_mail from datawindow within w_test
end type
end forward

global type w_test from window
integer width = 4027
integer height = 1904
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_add cb_add
cb_send cb_send
dw_attachment dw_attachment
dw_receiver dw_receiver
dw_mail dw_mail
end type
global w_test w_test

on w_test.create
this.cb_add=create cb_add
this.cb_send=create cb_send
this.dw_attachment=create dw_attachment
this.dw_receiver=create dw_receiver
this.dw_mail=create dw_mail
this.Control[]={this.cb_add,&
this.cb_send,&
this.dw_attachment,&
this.dw_receiver,&
this.dw_mail}
end on

on w_test.destroy
destroy(this.cb_add)
destroy(this.cb_send)
destroy(this.dw_attachment)
destroy(this.dw_receiver)
destroy(this.dw_mail)
end on

event open;// Profile TEST_TRAMOS
SQLCA.DBMS = "ASE Adaptive Server Enterprise"
SQLCA.Database = "TEST_TRAMOS"
SQLCA.LogPass = "" //needs a password
SQLCA.ServerName = "SCRBTRADKCPH101"
SQLCA.LogId = "" //needs a login name
SQLCA.AutoCommit = False
//SQLCA.DBParm = ""
//Activate UTF8
SQLCA.DBParm = "UTF8=1"

connect using sqlca;


dw_mail.setitem(1, "senderemail", C#EMAIL.TRAMOSSUPPORT)
dw_receiver.setitem(1, "receiveremail", "regin.mortensen" + C#EMAIL.DOMAIN)


end event

event close;disconnect using sqlca;

end event

type cb_add from commandbutton within w_test
integer x = 2967
integer y = 1196
integer width = 567
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Add Attachment..."
end type

event clicked;string ls_filepath, ls_filename
integer li_rtn, ll_row

li_rtn = GetFileOpenName("Select File", ls_filepath, ls_filename)

if li_rtn < 1 then return

ll_row = dw_attachment.insertrow(0)

if ll_row > 0 then
	dw_attachment.setItem( ll_row, "filepath", ls_filepath )
end if




end event

type cb_send from commandbutton within w_test
integer x = 133
integer y = 1620
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
end type

event clicked;mt_n_outgoingmail lnv_mail
string ls_message
long ll_rc, ll_rows, ll_row

lnv_mail = create mt_n_outgoingmail

if lnv_mail.of_verifyreceiveraddress( dw_receiver.object.receiveremail[1], ls_message ) = -1 then
	messageBox("Error", ls_message)
	return
end if

ll_rc = lnv_mail.of_createmail( dw_mail.object.senderemail[1], &
								dw_mail.object.sendername[1], &
								 dw_receiver.object.receiveremail[1], & 
								 dw_receiver.object.receivername[1], & 
								 dw_mail.object.subject[1], & 
								 dw_mail.object.body[1], &
								 ls_message)

if ll_rc < 1 then
	messageBox("Error", ls_message)
	return
end if

ll_rows = dw_attachment.rowCount()
for ll_row = 1 to ll_rows
	ll_rc = lnv_mail.of_addattachment( dw_attachment.object.filepath[ll_row] , ls_message )
	if ll_rc < 1 then
		messageBox("Error", ls_message)
		return
	end if		
next 

ll_rc = lnv_mail.of_sendmail( ls_message )
if ll_rc < 1 then
	messageBox("Error", ls_message)
	return
end if

destroy lnv_mail
end event

type dw_attachment from datawindow within w_test
integer x = 5
integer y = 1156
integer width = 2889
integer height = 400
integer taborder = 30
string title = "none"
string dataobject = "d_ex_tb_testattachment"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_receiver from datawindow within w_test
integer x = 14
integer y = 712
integer width = 2866
integer height = 400
integer taborder = 20
string title = "none"
string dataobject = "d_ex_tb_testreceiver"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_mail from datawindow within w_test
integer width = 2880
integer height = 688
integer taborder = 10
string title = "none"
string dataobject = "d_ex_tb_testmail"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

