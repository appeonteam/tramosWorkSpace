$PBExportHeader$w_feedback.srw
forward
global type w_feedback from window
end type
type st_msg from statictext within w_feedback
end type
type sle_risk from singlelineedit within w_feedback
end type
type st_5 from statictext within w_feedback
end type
type sle_im from singlelineedit within w_feedback
end type
type st_4 from statictext within w_feedback
end type
type cb_cancel from commandbutton within w_feedback
end type
type cb_submit from commandbutton within w_feedback
end type
type st_3 from statictext within w_feedback
end type
type mle_q from multilineedit within w_feedback
end type
type st_2 from statictext within w_feedback
end type
type st_1 from statictext within w_feedback
end type
type mle_g from multilineedit within w_feedback
end type
type mle_user from multilineedit within w_feedback
end type
type gb_2 from groupbox within w_feedback
end type
end forward

global type w_feedback from window
integer width = 2729
integer height = 2544
boolean titlebar = true
string title = "Question Feedback"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_msg st_msg
sle_risk sle_risk
st_5 st_5
sle_im sle_im
st_4 st_4
cb_cancel cb_cancel
cb_submit cb_submit
st_3 st_3
mle_q mle_q
st_2 st_2
st_1 st_1
mle_g mle_g
mle_user mle_user
gb_2 gb_2
end type
global w_feedback w_feedback

on w_feedback.create
this.st_msg=create st_msg
this.sle_risk=create sle_risk
this.st_5=create st_5
this.sle_im=create sle_im
this.st_4=create st_4
this.cb_cancel=create cb_cancel
this.cb_submit=create cb_submit
this.st_3=create st_3
this.mle_q=create mle_q
this.st_2=create st_2
this.st_1=create st_1
this.mle_g=create mle_g
this.mle_user=create mle_user
this.gb_2=create gb_2
this.Control[]={this.st_msg,&
this.sle_risk,&
this.st_5,&
this.sle_im,&
this.st_4,&
this.cb_cancel,&
this.cb_submit,&
this.st_3,&
this.mle_q,&
this.st_2,&
this.st_1,&
this.mle_g,&
this.mle_user,&
this.gb_2}
end on

on w_feedback.destroy
destroy(this.st_msg)
destroy(this.sle_risk)
destroy(this.st_5)
destroy(this.sle_im)
destroy(this.st_4)
destroy(this.cb_cancel)
destroy(this.cb_submit)
destroy(this.st_3)
destroy(this.mle_q)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.mle_g)
destroy(this.mle_user)
destroy(this.gb_2)
end on

event open;
ustruct_feedback lData

lData = message.powerobjectparm

st_Msg.Text = "OCIMF and CDI are committed to continuously improving the vessel inspection questionnaires. As new best practices are identified, these will be included in updates of the documents. 'Question Feedback' allows VIMS users to submit their input from day-to-day use of the documents. VIMS users are encouraged to use this feature.~n~nFeedback will be sent to the Vetting Manager and subsequently compiled and presented to OCIMF && CDI at regular intervals."

sle_IM.Text = lData.InspModel
If IsNull(lData.RiskRating) then sle_Risk.Text = "None" else sle_Risk.Text = String(lData.RiskRating)
mle_Q.Text = lData.Qtext
mle_G.Text = lData.Guidance


end event

type st_msg from statictext within w_feedback
integer x = 73
integer y = 128
integer width = 2560
integer height = 352
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 8421376
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_risk from singlelineedit within w_feedback
integer x = 2359
integer y = 720
integer width = 274
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_feedback
integer x = 2359
integer y = 656
integer width = 270
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Risk Rating:"
boolean focusrectangle = false
end type

type sle_im from singlelineedit within w_feedback
integer x = 73
integer y = 560
integer width = 2560
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_feedback
integer x = 73
integer y = 496
integer width = 722
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inspection Model / Edition:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_feedback
integer x = 1737
integer y = 2320
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;
Close(Parent)
end event

type cb_submit from commandbutton within w_feedback
integer x = 658
integer y = 2320
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Submit"
end type

event clicked;String ls_Err, ls_Msg, ls_Admin, ls_User

mle_user.text=Trim(mle_user.text,true)

If mle_user.text ="" then
	MessageBox("Comments Required", "Please specify your comments!", Exclamation!)
	Return
End if

f_Config("ADEM", ls_Admin, 0)

If ls_Admin = "" then
	Messagebox("Admin Email Required", "Administrator email is not specified. Please ask the Vetting Administrator to specify the Administrator Email in Admin Settings.", Exclamation!)
	Return
End If

ls_User = g_Obj.UserID  // Incase select fails

Select FIRST_NAME + ' '+ LAST_NAME into :ls_User From USERS Where USERID=:g_Obj.UserID;

Commit;

mt_n_outgoingmail MailObj
mt_n_stringfunctions StrFunc
	
MailObj = Create mt_n_outgoingmail
	
// Prepare email message
ls_Msg = "<html><body style='font-family:Verdana;font-size:10pt;'>Good-day,<br/><br/><b>" + ls_User
ls_Msg += "</b> has submitted feedback for the following question from " + StrFunc.of_HtmlEncode(sle_IM.Text) + ":<br/><br/>"
ls_Msg += "<table style='font-family:Verdana;font-size:10pt;' border='1' width='80%'><tr valign='top'><td style='width:80%'><b>Question</b><br/>" + StrFunc.of_HtmlEncode(mle_q.text) + "<br/><br/></td><td align='center'><b>Risk Rating</b><br/>" + sle_Risk.Text + "</td></tr>"
ls_Msg += "<tr><td colspan='2'><b>Guidance Notes</b><br/>" + StrFunc.of_HtmlEncode(mle_g.text) + "<br/><br/></td></tr>"
ls_Msg += "<tr><td colspan='2'><b>User's Comments:</b><br/>" + StrFunc.of_HtmlEncode(mle_user.text) + "<br/><br/></td></tr></table><br/><br/>"
ls_Msg += "Regards,<br/>VIMS</body></html>"

MailObj.of_Createmail("tramosmt@maersk.com", "VIMS", ls_Admin, "", "VIMS - Question Feedback Submission", ls_Msg, ls_Err)
MailObj.of_SetCreator("JAU010", ls_Err)

If MailObj.of_SendMail(ls_Err) = 1 then
	guo_Global.of_LogEmail(ls_Admin, "VIMS - Question Feedback Submission", ls_Msg)
	Messagebox("Feedback Submitted", "Thank you! Your feedback has been submitted to " + ls_Admin + " successfully.")
	Destroy MailObj
	Close(Parent)	
Else
	Messagebox("Submission Failed", "Unable to send email.~r~rError: " + ls_Err)	
	Destroy MailObj
End If




end event

type st_3 from statictext within w_feedback
integer x = 73
integer y = 1520
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Your Comments:"
boolean focusrectangle = false
end type

type mle_q from multilineedit within w_feedback
integer x = 73
integer y = 720
integer width = 2249
integer height = 160
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 15793151
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_feedback
integer x = 73
integer y = 656
integer width = 722
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Question Number && Text:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_feedback
integer x = 73
integer y = 912
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
string text = "Guidance Notes:"
boolean focusrectangle = false
end type

type mle_g from multilineedit within w_feedback
integer x = 73
integer y = 976
integer width = 2560
integer height = 512
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 15793151
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type mle_user from multilineedit within w_feedback
integer x = 73
integer y = 1584
integer width = 2560
integer height = 656
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_feedback
integer x = 18
integer y = 16
integer width = 2670
integer height = 2272
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Question Feedback Form"
end type

