$PBExportHeader$w_mail_list.srw
$PBExportComments$This is the main mail window for mail between TRAMOS users.
forward
global type w_mail_list from window
end type
type cb_cc from commandbutton within w_mail_list
end type
type cb_send_all from commandbutton within w_mail_list
end type
type cb_close from commandbutton within w_mail_list
end type
type cb_send from commandbutton within w_mail_list
end type
type cb_reply from commandbutton within w_mail_list
end type
type cb_delete from commandbutton within w_mail_list
end type
type cb_new from commandbutton within w_mail_list
end type
type dw_mail_list from uo_datawindow within w_mail_list
end type
type dw_mail from uo_datawindow within w_mail_list
end type
type cb_print from commandbutton within w_mail_list
end type
type cb_cancel from commandbutton within w_mail_list
end type
type gb_frame from groupbox within w_mail_list
end type
end forward

global type w_mail_list from window
integer x = 672
integer y = 264
integer width = 2432
integer height = 2228
boolean titlebar = true
string title = "Tramos Mail"
boolean controlmenu = true
long backcolor = 81324524
string icon = "h:\tramos.dev\resource\mail.ico"
cb_cc cb_cc
cb_send_all cb_send_all
cb_close cb_close
cb_send cb_send
cb_reply cb_reply
cb_delete cb_delete
cb_new cb_new
dw_mail_list dw_mail_list
dw_mail dw_mail
cb_print cb_print
cb_cancel cb_cancel
gb_frame gb_frame
end type
global w_mail_list w_mail_list

type variables
str_progress parm

end variables

forward prototypes
public subroutine edit_mode ()
public subroutine view_mode ()
end prototypes

public subroutine edit_mode ();cb_new.visible = false
cb_delete.visible = false
cb_cc.visible = true
cb_reply.visible = false
cb_close.visible = false
cb_send.visible = true
cb_cancel.visible = true
dw_mail_list.enabled = false
dw_mail.SetTabOrder ("mail_to",1 )
dw_mail.SetTabOrder ("cc",2 )
dw_mail.modify("mail_message.edit.displayonly = No")
dw_mail.modify("mail_subject.edit.displayonly = No")
dw_mail.Modify("cc.Background.Color='16777215'")
dw_mail.Modify("mail_to.Background.Color='16776960'")
dw_mail.Modify("mail_from.Background.Color='80269524'")
dw_mail.Modify("mail_subject.Background.Color='16776960'")
dw_mail.Modify("mail_message.Background.Color='16776960'")
end subroutine

public subroutine view_mode ();cb_new.visible = true
cb_delete.visible = true
cb_cc.visible = false
cb_reply.visible = true
cb_close.visible = true
cb_send.visible = false
cb_cancel.visible = false
dw_mail_list.enabled = true
dw_mail.SetTabOrder ("mail_to",0 )
dw_mail.SetTabOrder ("cc",0 )
dw_mail.modify("mail_message.edit.displayonly = Yes")
dw_mail.modify("mail_subject.edit.displayonly = Yes")
dw_mail.Modify("cc.Background.Color='80269524'")
dw_mail.Modify("mail_to.Background.Color='80269524'")
dw_mail.Modify("mail_from.Background.Color='80269524'")
dw_mail.Modify("mail_subject.Background.Color='80269524'")
dw_mail.Modify("mail_message.Background.Color='80269524'")
end subroutine

event open;move(0,0)
string ls_userid
ls_userid = uo_global.getuserid()
dw_mail_list.settransobject(sqlca)
dw_mail.settransobject(sqlca)
dw_mail_list.retrieve(ls_userid)
dw_mail_list.sharedata(dw_mail)
dw_mail_list.scrolltorow(dw_mail_list.rowcount())
dw_mail.scrolltorow(dw_mail.rowcount())
dw_mail_list.setrowfocusindicator(Hand!)
view_mode()
end event

on w_mail_list.create
this.cb_cc=create cb_cc
this.cb_send_all=create cb_send_all
this.cb_close=create cb_close
this.cb_send=create cb_send
this.cb_reply=create cb_reply
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.dw_mail_list=create dw_mail_list
this.dw_mail=create dw_mail
this.cb_print=create cb_print
this.cb_cancel=create cb_cancel
this.gb_frame=create gb_frame
this.Control[]={this.cb_cc,&
this.cb_send_all,&
this.cb_close,&
this.cb_send,&
this.cb_reply,&
this.cb_delete,&
this.cb_new,&
this.dw_mail_list,&
this.dw_mail,&
this.cb_print,&
this.cb_cancel,&
this.gb_frame}
end on

on w_mail_list.destroy
destroy(this.cb_cc)
destroy(this.cb_send_all)
destroy(this.cb_close)
destroy(this.cb_send)
destroy(this.cb_reply)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.dw_mail_list)
destroy(this.dw_mail)
destroy(this.cb_print)
destroy(this.cb_cancel)
destroy(this.gb_frame)
end on

type cb_cc from commandbutton within w_mail_list
integer x = 1426
integer y = 672
integer width = 82
integer height = 80
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&?"
end type

event clicked;string ls_userid, ls_cc
ls_userid = f_select_from_list("d_sq_tb_dddw_users",1,"User Id",2,"Name",1,"Select User",true)
IF IsNull(ls_userid) THEN
	dw_mail.setfocus()
	Return
ELSE
	ls_cc = dw_mail.getitemstring(dw_mail.rowcount(),"cc")
	if isnull(ls_cc) or ( len(ls_cc) < 1) then
		dw_mail.SetItem(dw_mail.Rowcount(),"cc", ls_userid)
	else
		dw_mail.SetItem(dw_mail.Rowcount(),"cc",ls_cc + ", " + ls_userid)
	end if
END IF
end event

type cb_send_all from commandbutton within w_mail_list
boolean visible = false
integer x = 329
integer y = 672
integer width = 347
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send to &All"
end type

on clicked;parm.title = "Mail"
parm.cancel_window = w_monthly_reports
parm.cancel_event = "none"
string ls_message, ls_subject, ls_from, ls_to, ls_temp
datetime ldt_now
long ll_row, ll_counter
int li_read

dw_mail.accepttext()
ll_row = dw_mail.rowcount()
ls_message = dw_mail.getitemstring(ll_row,"mail_message")
ls_from = dw_mail.getitemstring(ll_row,"mail_from")
ls_subject = dw_mail.getitemstring(ll_row,"mail_subject")
ldt_now = datetime(today(),now())
 DECLARE users_cursor CURSOR FOR  
  SELECT USERS.USERID  
    FROM USERS  
   WHERE USERS.DELETED = 0   ;
OPEN users_cursor;
FETCH users_cursor INTO :ls_to;
DO WHILE sqlca.sqlcode = 0
if ls_to = ls_from then 
	ls_temp = ls_subject
	ls_subject = "{Sent To All} " + ls_subject
	li_read = 1
else
	ls_temp = ls_subject
	li_read = 0
end if
  INSERT INTO MAIL  ( 	MAIL_DATE,   	MAIL_MESSAGE,   	MAIL_TO,   	MAIL_FROM,   MAIL_SUBJECT,   	MAIL_READ )  
  VALUES ( 			:ldt_now,		:ls_message,		:ls_to,		:ls_from,		:ls_subject,		:li_read )  ;
FETCH users_cursor INTO :ls_to;
LOOP
CLOSE users_cursor;
OpenWithParm(w_progress_no_cancel, parm)
FOR ll_counter=1 TO 10
 w_progress_no_cancel.wf_progress(ll_counter/10,"Sending Mail")
NEXT
Close(w_progress_no_cancel)
this.visible = false
dw_mail_list.retrieve(uo_global.getuserid())
view_mode()
ll_row = dw_mail_list.rowcount()
if ll_row > 1 then
	dw_mail.scrolltorow(ll_row)
	dw_mail_list.scrolltorow(ll_row)
end if
end on

type cb_close from commandbutton within w_mail_list
integer x = 1957
integer y = 512
integer width = 402
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

on clicked;close(parent)
end on

type cb_send from commandbutton within w_mail_list
boolean visible = false
integer x = 18
integer y = 512
integer width = 407
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Send"
end type

on clicked;parm.title = "Mail"
parm.cancel_window = parent
parm.cancel_event = "none"
long ll_row,ll_counter
string ls_cc, ls_message, ls_subject, ls_from, ls_to
datetime ldt_now

dw_mail.accepttext()
ls_cc = dw_mail.getitemstring(dw_mail.rowcount(),"cc")
ll_row = dw_mail.rowcount()
if dw_mail.getitemstring(ll_row,"mail_to") = dw_mail.getitemstring(ll_row,"mail_from") then
	messagebox("Mail Error","You cannot send mail to yourself!")
	return
end if
if dw_mail_list.update() = 1 then
	commit;
	OpenWithParm(w_progress_no_cancel, parm)
	FOR ll_counter=1 TO 100
		 w_progress_no_cancel.wf_progress(ll_counter/100,"Sending Mail")
	NEXT
	Close(w_progress_no_cancel)
else
	rollback;
end if
ls_message = dw_mail.getitemstring(ll_row,"mail_message")
ls_from = dw_mail.getitemstring(ll_row,"mail_from")
ls_subject = dw_mail.getitemstring(ll_row,"mail_subject")
ldt_now = datetime(today(),now())
if ( ls_cc <> "" ) and not isnull(ls_cc) then
	dw_mail.accepttext()
	ll_row = dw_mail.rowcount()
	 DECLARE users_cursor CURSOR FOR  
	  SELECT USERS.USERID  
	    FROM USERS  
	   WHERE USERS.DELETED = 0   ;
	OPEN users_cursor;
	FETCH users_cursor INTO :ls_to;
	DO WHILE sqlca.sqlcode = 0
	if pos(ls_cc,ls_to) > 0 then
		  INSERT INTO MAIL  ( 	MAIL_DATE,   	MAIL_MESSAGE,   	MAIL_TO,   	MAIL_FROM,   MAIL_SUBJECT,   	MAIL_READ )  
		  VALUES ( 			:ldt_now,		:ls_message,		:ls_to,		:ls_from,		:ls_subject,		0 )  ;
	end if
	FETCH users_cursor INTO :ls_to;
	LOOP
	CLOSE users_cursor;
	this.visible = false
end if	

ls_to = dw_mail.getitemstring(ll_row,"mail_to")
if isnull(ls_cc) then ls_cc = " "
ls_subject = "{To : " + ls_to  +" cc : " +  ls_cc + "} " + ls_subject 
ls_to = ls_from
  INSERT INTO MAIL  ( 	MAIL_DATE,   	MAIL_MESSAGE,   	MAIL_TO,   	MAIL_FROM,   MAIL_SUBJECT,   	MAIL_READ )  
  VALUES ( 			:ldt_now,		:ls_message,		:ls_to,		:ls_from,		:ls_subject,		1 )  ;
commit;


dw_mail_list.retrieve(uo_global.getuserid())
view_mode()
ll_row = dw_mail_list.rowcount()
if ll_row > 1 then
	dw_mail.scrolltorow(ll_row)
	dw_mail_list.scrolltorow(ll_row)
end if
end on

type cb_reply from commandbutton within w_mail_list
integer x = 494
integer y = 512
integer width = 407
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Reply"
end type

on clicked;long ll_row
string ls_to,ls_subject
if dw_mail_list.rowcount() < 1 then return
edit_mode()
dw_mail.SetTabOrder ("mail_to",0 )
dw_mail.Modify("mail_to.Background.Color='12632256'")
ll_row = dw_mail.getrow()
ls_to = dw_mail.getitemstring(ll_row,"mail_from")
if left(dw_mail.getitemstring(ll_row,"mail_subject"),5) = "Re : " then
	ls_subject = dw_mail.getitemstring(ll_row,"mail_subject")
else
	ls_subject = "Re : " + left(dw_mail.getitemstring(ll_row,"mail_subject"),35)
end if
dw_mail.insertrow(0)
ll_row = dw_mail.rowcount()
dw_mail.scrolltorow(ll_row)
dw_mail.setitem(ll_row,"mail_date",now())
dw_mail.setitem(ll_row,"mail_from",uo_global.getuserid())
dw_mail.setitem(ll_row,"mail_to",ls_to)
dw_mail.setitem(ll_row,"mail_read",0)
dw_mail.setitem(ll_row,"mail_subject",ls_subject)
dw_mail.setfocus()
dw_mail.setcolumn("mail_message")
end on

type cb_delete from commandbutton within w_mail_list
integer x = 969
integer y = 512
integer width = 407
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Delete Mail"
end type

on clicked;long ll_row
if dw_mail_list.rowcount() < 1 then return
if messagebox("Delete","Delete this mail?",Question!,YesNo!,2) = 2 then return
dw_mail_list.deleterow(dw_mail_list.getrow())
if dw_mail_list.update() = 1 then
	commit;
	dw_mail.scrolltorow(dw_mail_list.getrow())
else
	rollback;
end if 
end on

type cb_new from commandbutton within w_mail_list
integer x = 18
integer y = 512
integer width = 407
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Mail"
end type

on clicked;long ll_row
edit_mode()
dw_mail.insertrow(0)
ll_row = dw_mail.rowcount()
dw_mail.scrolltorow(ll_row)
dw_mail.setitem(ll_row,"mail_date",now())
dw_mail.setitem(ll_row,"mail_from",uo_global.getuserid())
dw_mail.setitem(ll_row,"mail_read",0)
dw_mail.setfocus()

end on

type dw_mail_list from uo_datawindow within w_mail_list
integer x = 18
integer y = 16
integer width = 2341
integer height = 480
integer taborder = 10
string dataobject = "dw_mail_list"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

on clicked;call uo_datawindow::clicked;// sets detail dw to the same row
if this.getclickedrow() > 0 then
	dw_mail.scrolltorow(this.getclickedrow())
	dw_mail.setrow(this.getclickedrow())
	if dw_mail_list.getitemnumber(this.getclickedrow(),"mail_read") = 0 then
		dw_mail_list.setitem(this.getclickedrow(),"mail_read",1)
		if dw_mail_list.update() = 1 then
			commit;
		else
			rollback;
		end if
	end if
	dw_mail.setfocus()
	dw_mail.setcolumn("mail_message")
end if
end on

type dw_mail from uo_datawindow within w_mail_list
event ue_keydown pbm_dwnkey
integer x = 73
integer y = 672
integer width = 2267
integer height = 1392
integer taborder = 60
string dataobject = "dw_mail"
boolean border = false
end type

event ue_keydown;/*******************************************************************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_mail_list
  
 Object     : dw_mail
  
 Event	 :  ue_keydown

 Scope     : Local

 **************************************************************************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 27-02-96

 Description : This event makes an invisible button visible if control + alt + A is pressed.

 Arguments : none

 Returns   : none

 Variables : none

 Other : none

************************************************************************************************************************************************
  Development Log 
  DATE     	VERSION 	NAME  	DESCRIPTION
  -------- 		------- 		----- 		-------------------------------------------
  27_02_96	2.11			PBT		Initial Version
  
*************************************************************************************************************************************************/
if keydown(keycontrol!) and keydown(keyalt!) and keydown(keya!) and cb_send.visible then
	cb_send_all.visible = true
	cb_send.visible = false
	cb_cc.visible = false


dw_mail.SetTabOrder ("cc",0 )
dw_mail.Modify("cc.Background.Color='12632256'")
end if

if keydown(keyenter!) or keydown(keyuparrow!) or keydown(keydownarrow!) then
//	this.setactioncode(1)
	return 1
elseif keydown(keytab!) and keydown(keyshift!) and this.getcolumnname() = "mail_to" then
//	this.setactioncode(1)
	return 1
elseif keydown(keytab!) and keydown(keyshift!) and this.getcolumnname() = "mail_subject" then
//	this.setactioncode(1)
	return 1
elseif keydown(keytab!) and not keydown(keyshift!) and this.getcolumnname() = "mail_message" then
//	this.setactioncode(1)
	return 1
end if
	
end event

type cb_print from commandbutton within w_mail_list
integer x = 1445
integer y = 512
integer width = 407
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "&Print"
end type

event clicked;string ls_tmp
long ll_row, ll_return, ll_printjobnr

ll_printjobnr = printopen("Tramos Mail")

If (ll_printjobnr<1) or IsNull(ll_printjobnr) Then
	MessageBox("System error", "Error printing mail", StopSign!)
	Return
End if

ll_row = dw_mail.getrow()
if ll_row < 1 then return

ll_return = print( ll_printjobnr, "~r~n~r~n")
ls_tmp = dw_mail.getitemstring(ll_row,"mail_to")
//ll_return = print( ll_printjobnr, "To : ")
ll_return = print( ll_printjobnr, "To : " + ls_tmp + "~r~n")
print( ll_printjobnr, "From : " + dw_mail.getitemstring(ll_row,"mail_from")  + "~r~n")
print( ll_printjobnr, "Subject : " + dw_mail.getitemstring(ll_row,"mail_subject")  + "~r~n")
print( ll_printjobnr, "Date : " + string(dw_mail.getitemdatetime(ll_row,"mail_date"),"dd-mmm-yyyy") + "~r~n" )
print( ll_printjobnr, f_block_text(dw_mail.getitemstring(ll_row,"mail_message") , 70 ) + "~r~n" + "~r~n")

printclose( ll_printjobnr)





end event

type cb_cancel from commandbutton within w_mail_list
boolean visible = false
integer x = 494
integer y = 512
integer width = 407
integer height = 76
integer taborder = 110
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

on clicked;long ll_row
view_mode()
ll_row = dw_mail_list.rowcount()
dw_mail.deleterow(ll_row)
ll_row = dw_mail_list.rowcount()
if ll_row > 0 then
	dw_mail.scrolltorow(ll_row)
	dw_mail_list.scrolltorow(ll_row)
end if
cb_send_all.visible = false
end on

type gb_frame from groupbox within w_mail_list
integer x = 18
integer y = 592
integer width = 2341
integer height = 1500
integer taborder = 120
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

