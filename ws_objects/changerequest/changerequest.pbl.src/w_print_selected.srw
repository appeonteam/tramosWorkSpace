$PBExportHeader$w_print_selected.srw
forward
global type w_print_selected from mt_w_response
end type
type cb_print from mt_u_commandbutton within w_print_selected
end type
type st_1 from mt_u_statictext within w_print_selected
end type
type cb_cancel from mt_u_commandbutton within w_print_selected
end type
type hpb_1 from hprogressbar within w_print_selected
end type
end forward

global type w_print_selected from mt_w_response
integer width = 2345
integer height = 752
string title = "Print All Change Requests"
boolean ib_setdefaultbackgroundcolor = true
cb_print cb_print
st_1 st_1
cb_cancel cb_cancel
hpb_1 hpb_1
end type
global w_print_selected w_print_selected

type variables
boolean		ib_cancel=false
datastore	ids_printrequest
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_print_selected
   <OBJECT>		Print All Change Requests which are in the list	</OBJECT>
   <USAGE>		Object Usage			</USAGE>
   <ALSO>		Other Objects			</ALSO>
   <HISTORY>
   	Date       CR-Ref       Author        Comments
   	02-04-2013 CR2614       LHG008        Change GUI
	01/09/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_print_selected.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.hpb_1=create hpb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.hpb_1
end on

on w_print_selected.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.hpb_1)
end on

event open;st_1.text = "You have select to print all Change Requests = " + string(w_changerequest.dw_list.rowcount())

ids_printrequest = create datastore
ids_printrequest.dataobject = "d_print_request"
ids_printrequest.settransobject(sqlca)

hpb_1.maxposition = w_changerequest.dw_list.rowcount()
hpb_1.position = 0
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_print_selected
end type

type cb_print from mt_u_commandbutton within w_print_selected
integer x = 1618
integer y = 544
integer taborder = 10
string text = "&Print"
boolean default = true
end type

event clicked;long	ll_rows, ll_row
long	ll_requestid

this.enabled = false
this.default = false
cb_cancel.enabled = true
cb_cancel.default = true

ll_rows = w_changerequest.dw_list.rowcount()
for ll_row = 1 to ll_rows
	hpb_1.position = ll_row
	ll_requestid = w_changerequest.dw_list.getitemnumber(ll_row, "request_id")
	ids_printrequest.retrieve(ll_requestid, ll_requestid)
	yield()
	if ib_cancel then
		messagebox("Information", "Print was cancelled......")
		ib_cancel=false
		exit
	end if
	ids_printrequest.print()
next

cb_cancel.enabled = false
cb_cancel.default = false
this.enabled = true
this.default = true
end event

type st_1 from mt_u_statictext within w_print_selected
integer x = 46
integer y = 100
integer width = 2263
integer textsize = -10
integer weight = 700
string text = "Printing All Change Requests...."
alignment alignment = center!
end type

type cb_cancel from mt_u_commandbutton within w_print_selected
integer x = 1966
integer y = 544
integer taborder = 20
boolean enabled = false
string text = "&Cancel"
end type

event clicked;ib_cancel = true
end event

type hpb_1 from hprogressbar within w_print_selected
integer x = 37
integer y = 304
integer width = 2272
integer height = 76
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 1
boolean smoothscroll = true
end type

