$PBExportHeader$w_print_request.srw
forward
global type w_print_request from mt_w_main
end type
type cb_1 from mt_u_commandbutton within w_print_request
end type
type st_2 from mt_u_statictext within w_print_request
end type
type st_1 from mt_u_statictext within w_print_request
end type
type sle_to from mt_u_singlelineedit within w_print_request
end type
type sle_from from mt_u_singlelineedit within w_print_request
end type
type dw_print from mt_u_datawindow within w_print_request
end type
type st_7 from u_topbar_background within w_print_request
end type
end forward

global type w_print_request from mt_w_main
integer width = 3767
integer height = 2544
string title = "Print Request"
boolean maxbox = false
boolean resizable = false
boolean ib_setdefaultbackgroundcolor = true
cb_1 cb_1
st_2 st_2
st_1 st_1
sle_to sle_to
sle_from sle_from
dw_print dw_print
st_7 st_7
end type
global w_print_request w_print_request

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_print_request
	
	<OBJECT>
	</OBJECT>
	<DESC>
	Print CR detail
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       CR-Ref			Author		Comments
     	15/08/2013 CR3306       WWA048      Add a new "Print Task" button in Task tab. Since the two dataobjects(d_print_request, d_sq_ff_print_request_task) 
														and(d_sq_ff_creq_att_detail, d_sq_ff_creq_att_list) have connections to each other, please be awared the changes in these objects.
		11/08/2014 CR3708   		AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_print_request.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_2=create st_2
this.st_1=create st_1
this.sle_to=create sle_to
this.sle_from=create sle_from
this.dw_print=create dw_print
this.st_7=create st_7
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_to
this.Control[iCurrent+5]=this.sle_from
this.Control[iCurrent+6]=this.dw_print
this.Control[iCurrent+7]=this.st_7
end on

on w_print_request.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_to)
destroy(this.sle_from)
destroy(this.dw_print)
destroy(this.st_7)
end on

event open;call super::open;string	ls_requestid, ls_msg, ls_task
long		ll_pos

ls_msg = message.stringparm
if isnumber(ls_msg) then
	ls_requestid = ls_msg
else
	ll_pos = pos(ls_msg, '~t')
	if ll_pos > 0 then
		ls_requestid = left(ls_msg, ll_pos - 1)
		dw_print.dataobject = mid(ls_msg, ll_pos + len('~t'))
	end if	
end if

dw_print.settransobject(sqlca)

sle_from.text 	= ls_requestid
sle_to.text 	= ls_requestid

dw_print.post retrieve(long(ls_requestid), long(ls_requestid))
sle_to.post setfocus()

this.title = title + " for #" + ls_requestid

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_print_request
end type

type cb_1 from mt_u_commandbutton within w_print_request
integer x = 3406
integer y = 16
integer taborder = 30
string text = "&Print"
boolean default = true
end type

event clicked;long 		ll_requestID_from, ll_requestID_to

ll_requestID_from = long(sle_from.text)
ll_requestID_to 	= long(sle_to.text)

if ll_requestID_from <> ll_requestID_to then
	dw_print.retrieve(ll_requestID_from, ll_requestID_to)
end if

dw_print.print()

end event

type st_2 from mt_u_statictext within w_print_request
integer x = 640
integer y = 32
integer width = 123
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "to #"
alignment alignment = right!
end type

type st_1 from mt_u_statictext within w_print_request
integer x = 18
integer y = 32
integer width = 366
integer height = 56
long textcolor = 16777215
long backcolor = 553648127
string text = "Print Request #"
alignment alignment = right!
end type

type sle_to from mt_u_singlelineedit within w_print_request
integer x = 786
integer y = 32
integer width = 229
integer height = 56
integer taborder = 20
long textcolor = 0
boolean border = false
end type

type sle_from from mt_u_singlelineedit within w_print_request
integer x = 407
integer y = 32
integer width = 229
integer height = 56
integer taborder = 10
long textcolor = 0
boolean border = false
end type

type dw_print from mt_u_datawindow within w_print_request
integer x = 41
integer y = 236
integer width = 3707
integer height = 2220
integer taborder = 10
string dataobject = "d_print_request"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
end type

type st_7 from u_topbar_background within w_print_request
integer width = 3785
end type

