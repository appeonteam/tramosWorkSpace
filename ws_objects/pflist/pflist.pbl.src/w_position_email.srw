$PBExportHeader$w_position_email.srw
forward
global type w_position_email from mt_w_response
end type
type cb_cancel from mt_u_commandbutton within w_position_email
end type
type cb_update from mt_u_commandbutton within w_position_email
end type
type dw_position_email from datawindow within w_position_email
end type
end forward

global type w_position_email from mt_w_response
integer width = 2542
integer height = 2036
string title = "Set Email Details"
cb_cancel cb_cancel
cb_update cb_update
dw_position_email dw_position_email
end type
global w_position_email w_position_email

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_position_email
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	12/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		23/12/2016	CR4387		KSH092		Add email type (IMO or Public Email)
	</HISTORY>
********************************************************************/
end subroutine

on w_position_email.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_update=create cb_update
this.dw_position_email=create dw_position_email
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_update
this.Control[iCurrent+3]=this.dw_position_email
end on

on w_position_email.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_update)
destroy(this.dw_position_email)
end on

event closequery;dw_position_email.accepttext()
if dw_position_email.modifiedcount() > 0 then
	if MessageBox("Confirmation", "Data Changed but not saved. Close anyway?", question!, YesNo!,2) = 2 then
		dw_position_email.POST setFocus()
		return 1
	end if
end if
end event

event open;int			li_pcgroup
long		ll_row
s_companyemailtype s_emailtype

s_emailtype = message.powerobjectparm
dw_position_email.setTransObject(SQLCA)
ll_row = dw_position_email.retrieve( s_emailtype.li_pcgroup, s_emailtype.li_emailtype )

/* If no configuration there, create a new record, and set the PC Group number */
if ll_row = 0 then
	ll_row = dw_position_email.insertrow(0)
	dw_position_email.setItem(ll_row, "pcgroup_id", s_emailtype.li_pcgroup )
	dw_position_email.setitem(ll_row,'email_type', s_emailtype.li_emailtype )
end if
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_position_email
end type

type cb_cancel from mt_u_commandbutton within w_position_email
integer x = 2103
integer y = 1824
integer width = 402
integer height = 112
integer taborder = 30
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;
CloseWithReturn(parent,0)
end event

type cb_update from mt_u_commandbutton within w_position_email
integer x = 1701
integer y = 1824
integer width = 402
integer height = 112
integer taborder = 20
string facename = "Arial"
string text = "&Update"
end type

event clicked;if  dw_position_email.rowcount( ) <> 0 then
	dw_position_email.acceptText()
	if isNull(dw_position_email.getItemString(1, "emailfrom")) &
	or dw_position_email.getItemString(1, "emailfrom") = "" &
	or isNull(dw_position_email.getItemString(1, "subject")) &
	or dw_position_email.getItemString(1, "subject") = "" then
		MessageBox("Validation Error", "As a minimum you have to enter From address and Subject")
		return 
	end if
	if dw_position_email.update() = 1 then
		commit;
		CloseWithReturn(parent,1)
	else
		rollback;
		MessageBox("Update Error", "Error updating position email information.")
		return -1
	end if
end if
end event

type dw_position_email from datawindow within w_position_email
integer x = 23
integer y = 16
integer width = 2482
integer height = 1788
integer taborder = 10
string title = "none"
string dataobject = "d_position_email"
boolean border = false
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

