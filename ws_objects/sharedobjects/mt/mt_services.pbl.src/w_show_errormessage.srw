$PBExportHeader$w_show_errormessage.srw
forward
global type w_show_errormessage from mt_w_response
end type
type cb_exit from mt_u_commandbutton within w_show_errormessage
end type
type cb_sendmail from mt_u_commandbutton within w_show_errormessage
end type
type st_errcounter from mt_u_statictext within w_show_errormessage
end type
type cb_1 from commandbutton within w_show_errormessage
end type
type cb_detail from commandbutton within w_show_errormessage
end type
type dw_errormessage from mt_u_datawindow within w_show_errormessage
end type
end forward

global type w_show_errormessage from mt_w_response
integer width = 1367
integer height = 820
string title = "Tramos Message"
long backcolor = 32304364
cb_exit cb_exit
cb_sendmail cb_sendmail
st_errcounter st_errcounter
cb_1 cb_1
cb_detail cb_detail
dw_errormessage dw_errormessage
end type
global w_show_errormessage w_show_errormessage

type variables
mt_n_datastore 	ids_errorMessage
private integer				_ii_standardwidth
private integer				_ii_expanded = 1350   /* additional width used in expanded view */
string is_tempdir
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_show_errormessage
	
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
    	Date   	Ref    		Author   	Comments
  	06/05/2011 	?      		RMO/AGL		First Version
	06/05/2011 	CR2274    	AGL027		Added function to provide rowcount of errors
	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

on w_show_errormessage.create
int iCurrent
call super::create
this.cb_exit=create cb_exit
this.cb_sendmail=create cb_sendmail
this.st_errcounter=create st_errcounter
this.cb_1=create cb_1
this.cb_detail=create cb_detail
this.dw_errormessage=create dw_errormessage
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_exit
this.Control[iCurrent+2]=this.cb_sendmail
this.Control[iCurrent+3]=this.st_errcounter
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.cb_detail
this.Control[iCurrent+6]=this.dw_errormessage
end on

on w_show_errormessage.destroy
call super::destroy
destroy(this.cb_exit)
destroy(this.cb_sendmail)
destroy(this.st_errcounter)
destroy(this.cb_1)
destroy(this.cb_detail)
destroy(this.dw_errormessage)
end on

event open;call super::open;ids_errormessage = create mt_n_datastore
ids_errorMessage = message.PowerObjectParm

ids_errormessage.sharedata(dw_errormessage)
ids_errormessage.sharedata(dw_errormessage)

/* display message counter when there is more than 1 message stacked */
if ids_errormessage.rowcount()>1 then
	st_errcounter.text = "Issues:" + string(ids_errormessage.rowcount())
else
	st_errcounter.visible = false
end if
end event

event resize;call super::resize;dw_errormessage.width = This.width - 85
dw_errormessage.height = This.height - 400
cb_detail.y = newheight - (cb_detail.height + 20)
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_show_errormessage
end type

type cb_exit from mt_u_commandbutton within w_show_errormessage
boolean visible = false
integer x = 41
integer y = 612
integer width = 288
integer height = 108
integer taborder = 20
boolean enabled = false
string text = "E&xit"
end type

event clicked;call super::clicked;/********************************************************************
   cb_exit.clicked()
	
<DESC>   
	stop the application!
</DESC>
<RETURN>
	Integer:
		<LI> 1, Success
		<LI> -1, Failure
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	a: 
</ARGS>
<USAGE>
	

</USAGE>
********************************************************************/
halt close
end event

type cb_sendmail from mt_u_commandbutton within w_show_errormessage
boolean visible = false
integer x = 370
integer y = 612
integer width = 288
integer height = 108
integer taborder = 30
boolean enabled = false
string text = "Send Mail"
end type

event clicked;call super::clicked;/* WIP */

//string ls_fname
//blob lblb_bitmap
//mt_n_outgoingmail	lnv_mail
//string ls_mailto, ls_receiver, ls_subject, is_emailtext, ls_errormessage, ls_tempdir
//n_screengrab inv_grab
//
//
//
//pointer ptr_oldpointer 
//ptr_oldpointer = setpointer(HourGlass!)
//inv_grab.of_gettempfoldername(ls_tempdir)
//
//ls_fname = ls_tempdir + "\tramoswindow.bmp"
//
///* AGL CR3167 TODO - when implementing final solution need a brighter way of validating
//window container */
//
//if isvalid(w_tramos_main) then
//	lblb_bitmap = inv_grab.of_windowcapture(w_tramos_main, False)
//else
//	lblb_bitmap = inv_grab.of_windowcapture(parentwindow( ), False)
//end if
//inv_grab.of_WriteBlob(ls_fname, lblb_bitmap)
//
//
//lnv_mail = create mt_n_outgoingmail
//ls_mailto = "AGL027"
//ls_receiver = ls_mailto + "@maersk.com"
//ls_subject = "error notification"
//is_emailtext = "There has been an error."
//ls_errormessage = "Error message text"
//if lnv_mail.of_createmail( "TRAMOS_DONT_REPLY@maersk.com", ls_receiver, ls_subject, is_emailtext, ls_errormessage) = -1 then
//	messagebox("error","1")
//	destroy lnv_mail
//	return c#return.failure
//else
//	if lnv_mail.of_setcreator( ls_mailto, ls_errorMessage) = -1 then
//			messagebox("error","2")
//		destroy lnv_mail
//		return c#return.failure
//	end if
//	
//	if lnv_mail.of_addattachment(ls_fname, ls_errorMessage)= -1 then
//	messagebox("error","3")
//		destroy lnv_mail
//		return c#return.failure
//	end if
//	if lnv_mail.of_sendmail( ls_errorMessage ) = -1 then
//	messagebox("error","4")
//		destroy lnv_mail
//		return c#return.failure
//	end if
//end if	
//lnv_mail.of_reset()
//destroy lnv_mail		
//
//filedelete(ls_fname)
//setpointer(ptr_oldpointer)



end event

type st_errcounter from mt_u_statictext within w_show_errormessage
integer x = 1403
integer y = 632
integer width = 334
long backcolor = 553648127
string text = "<empty>"
end type

type cb_1 from commandbutton within w_show_errormessage
integer x = 1029
integer y = 612
integer width = 288
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Close"
end type

event clicked;close(w_show_errormessage)
end event

type cb_detail from commandbutton within w_show_errormessage
integer x = 699
integer y = 612
integer width = 288
integer height = 108
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Detail >>"
end type

event clicked;if dw_errormessage.dataObject = "d_ex_tb_errorMessages" then
	w_show_errormessage.width -= _ii_expanded
//	cb_sendmail.visible=false
	dw_errormessage.dataObject = "d_ex_tb_user_errorMessages"
	ids_errormessage.sharedata( dw_errormessage )
	cb_detail.text = "Detail >>"
else
	
//	cb_sendmail.visible=true	
	w_show_errormessage.width += _ii_expanded
	dw_errormessage.dataObject = "d_ex_tb_errorMessages"
	ids_errormessage.sharedata( dw_errormessage )
	cb_detail.text = "Detail <<"
end if
end event

type dw_errormessage from mt_u_datawindow within w_show_errormessage
integer x = 37
integer y = 36
integer width = 1275
integer height = 576
integer taborder = 10
string dataobject = "d_ex_tb_user_errormessages"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;//n_service_manager  lnv_myMgr
//
//n_dw_Style_Service   lnv_style
//
//lnv_myMgr.of_loadservice( lnv_style, "n_dw_style_service")
//lnv_style.of_dwlistformater( dw_errormessage )


end event

event doubleclicked;call super::doubleclicked;if dwo.name="devmessage" or dwo.name="message" then
	::Clipboard(getitemstring(row,string(dwo.name)))
	messagebox("Info","Content added to clipboard")
end if
end event

