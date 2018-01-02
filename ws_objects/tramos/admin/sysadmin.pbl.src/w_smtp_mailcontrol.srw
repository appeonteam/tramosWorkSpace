$PBExportHeader$w_smtp_mailcontrol.srw
forward
global type w_smtp_mailcontrol from mt_w_main
end type
type cb_delete_all from commandbutton within w_smtp_mailcontrol
end type
type cb_delete_sent from commandbutton within w_smtp_mailcontrol
end type
type cb_refresh from commandbutton within w_smtp_mailcontrol
end type
type cb_update from commandbutton within w_smtp_mailcontrol
end type
type st_1 from statictext within w_smtp_mailcontrol
end type
type dw_log from datawindow within w_smtp_mailcontrol
end type
type dw_mailcontrol from datawindow within w_smtp_mailcontrol
end type
type gb_1 from groupbox within w_smtp_mailcontrol
end type
type gb_2 from groupbox within w_smtp_mailcontrol
end type
end forward

global type w_smtp_mailcontrol from mt_w_main
integer width = 3703
integer height = 2664
string title = "SMTP Mail Service"
boolean maxbox = false
boolean resizable = false
event ue_postopen ( )
cb_delete_all cb_delete_all
cb_delete_sent cb_delete_sent
cb_refresh cb_refresh
cb_update cb_update
st_1 st_1
dw_log dw_log
dw_mailcontrol dw_mailcontrol
gb_1 gb_1
gb_2 gb_2
end type
global w_smtp_mailcontrol w_smtp_mailcontrol

forward prototypes
public subroutine documentation ()
end prototypes

event ue_postopen();dw_mailcontrol.retrieve()
dw_log.retrieve()
commit;
end event

public subroutine documentation ();/********************************************************************
   ObjectName: Object Short Description
	
	<OBJECT>
		Object Description
	</OBJECT>
   	<DESC>
		Event Description
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   		Ref    	Author   		Comments
  	27/07/12 	VESSELCOMM	AGL027			First Version in MT framework
	28/08/14		CR3781			CCY018			The window title match with the text of a menu item
********************************************************************/
end subroutine

on w_smtp_mailcontrol.create
int iCurrent
call super::create
this.cb_delete_all=create cb_delete_all
this.cb_delete_sent=create cb_delete_sent
this.cb_refresh=create cb_refresh
this.cb_update=create cb_update
this.st_1=create st_1
this.dw_log=create dw_log
this.dw_mailcontrol=create dw_mailcontrol
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete_all
this.Control[iCurrent+2]=this.cb_delete_sent
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.cb_update
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.dw_log
this.Control[iCurrent+7]=this.dw_mailcontrol
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_smtp_mailcontrol.destroy
call super::destroy
destroy(this.cb_delete_all)
destroy(this.cb_delete_sent)
destroy(this.cb_refresh)
destroy(this.cb_update)
destroy(this.st_1)
destroy(this.dw_log)
destroy(this.dw_mailcontrol)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;dw_mailcontrol.setTransObject(sqlca)
dw_log.setTransObject(sqlca)

/* Only Admin can modify and delete */
if uo_global.ii_access_level <> 3 then
	cb_update.enabled = false
	cb_delete_all.enabled = false
	cb_delete_sent.enabled = false
	dw_mailcontrol.Object.DataWindow.ReadOnly='Yes'
end if	

post event ue_postopen( )
end event

event closequery;dw_mailcontrol.accepttext( )
if (dw_mailcontrol.modifiedcount( ) + dw_mailcontrol.deletedcount( )) > 0 then
	if MessageBox("Warning", "SMTP Control parameters modified but not saved. Would you like to save?",question!,YesNo!,2) = 2 then
		return 0 //close window
	else
		return 1 //prevent close
	end if
end if	
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_smtp_mailcontrol
end type

type cb_delete_all from commandbutton within w_smtp_mailcontrol
integer x = 2894
integer y = 440
integer width = 421
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete All Mails"
end type

event clicked;/* Get confirmation from the user */
if messageBox("Delete Confirmation", "Are you sure you would like to delete all the mails even if they are not sent yet?", question!, YesNo!,2) = 2 then 
	return
end if

/* Make sure a new transaction it started */
commit;

/* Delete Attachments */
DELETE 
	FROM SMTP_ATTACHMENT ;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox("Delete Error", "Could not delete from table SMTP_ATTACHMENT~r~n~r~n" &
					+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
	return
end if

/* Delete Receivers */
DELETE 
	FROM SMTP_RECEIVER ;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox("Delete Error", "Could not delete from table SMTP_RECEIVER~r~n~r~n" &
					+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
	return
end if

/* Delete Mail */
DELETE  
	FROM SMTP_MAIL ;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox("Delete Error", "Could not delete from table SMTP_MAIL~r~n~r~n" &
					+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
	return
end if

/* Delete went well */
commit;


end event

type cb_delete_sent from commandbutton within w_smtp_mailcontrol
integer x = 2889
integer y = 576
integer width = 421
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Sent Mails"
end type

event clicked;/* Make sure a new transaction it started */
commit;

/* Delete Attachments */
DELETE SMTP_ATTACHMENT
	FROM SMTP_MAIL M, SMTP_ATTACHMENT A
	WHERE M.SMTP_MAIL_ID = A.SMTP_MAIL_ID
	AND M.MAIL_SENT IS NOT NULL;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox("Delete Error", "Could not delete from table SMTP_ATTACHMENT~r~n~r~n" &
					+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
	return
end if

/* Delete Receivers */
DELETE SMTP_RECEIVER
	FROM SMTP_MAIL M, SMTP_RECEIVER R
	WHERE M.SMTP_MAIL_ID = R.SMTP_MAIL_ID
	AND M.MAIL_SENT IS NOT NULL;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox("Delete Error", "Could not delete from table SMTP_RECEIVER~r~n~r~n" &
					+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
	return
end if

/* Delete Mail */
DELETE  
	FROM SMTP_MAIL
	WHERE MAIL_SENT IS NOT NULL;
if sqlca.sqlcode <> 0 then
	rollback;
	MessageBox("Delete Error", "Could not delete from table SMTP_MAIL~r~n~r~n" &
					+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
	return
end if

/* Delete went well */
commit;


end event

type cb_refresh from commandbutton within w_smtp_mailcontrol
integer x = 2062
integer y = 440
integer width = 421
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Refresh"
end type

event clicked;dw_mailcontrol.retrieve( )
dw_log.retrieve( )
commit;
end event

type cb_update from commandbutton within w_smtp_mailcontrol
integer x = 2062
integer y = 576
integer width = 421
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Update"
end type

event clicked;dw_mailcontrol.accepttext( )

if dw_mailcontrol.getItemNumber(1, "stop_service") = 1 then
	if messageBox("Warning", "Are you sure you would like to stop the SMTP Mail send service?",question!, yesno!,2) = 2 then
		return
	end if
end if

if dw_mailcontrol.update() = 1 then
	commit;
else
	rollback;
	MessageBox("Update Error", "Update of SMTP Control parameters failed!")
end if
end event

type st_1 from statictext within w_smtp_mailcontrol
integer x = 41
integer y = 728
integer width = 352
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mail sent log:"
boolean focusrectangle = false
end type

type dw_log from datawindow within w_smtp_mailcontrol
integer x = 32
integer y = 796
integer width = 3611
integer height = 1764
integer taborder = 20
string title = "none"
string dataobject = "d_sq_tb_mail_log_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;/********************************************************************
   dw_log.doubleclicked()
<DESC>   
	with ctrl key depressed, sets up mail sending process
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	as_Arg1: Description
	as_Arg2: Description
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

integer li_resp
long ll_mailid

if keydown(KeyControl!) then

	ll_mailid = this.getitemnumber(row,"smtp_mail_smtp_mail_id")
	if isnull(this.getitemdatetime(row,"smtp_mail_mail_sent")) then
		li_resp = MessageBox("Push mail id#" + string(ll_mailid) + " to test?", "Are you sure you want to send email?", Exclamation!, OKCancel!, 2)
		
		if li_resp = 1 then
	
			/* Make sure a new transaction is started */
			COMMIT;
			
			UPDATE SMTP_MAIL SET SENDER_NAME = "*test*" WHERE SMTP_MAIL_ID = :ll_mailid ;
			
			if sqlca.sqlcode <> 0 then
				ROLLBACK;
				MessageBox("Delete Error", "Could not update table SMTP_MAIL~r~n~r~n" &
								+ "SQLErrText ='"+sqlca.sqlerrtext+"'")
				return
			else
				COMMIT;
				messagebox("Outcome","Set to be processed by test smtp application!")
			end if
		else
			messagebox("Outcome","No action")	
		end if	
	end if
	
end if	
end event

type dw_mailcontrol from datawindow within w_smtp_mailcontrol
integer x = 64
integer y = 92
integer width = 1957
integer height = 580
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_mail_service_control"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_smtp_mailcontrol
integer x = 27
integer y = 28
integer width = 2496
integer height = 680
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "SMTP Mail Service Control"
end type

type gb_2 from groupbox within w_smtp_mailcontrol
integer x = 2830
integer y = 332
integer width = 549
integer height = 376
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cleanup mail table"
end type

