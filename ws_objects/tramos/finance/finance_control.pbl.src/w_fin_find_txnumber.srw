$PBExportHeader$w_fin_find_txnumber.srw
forward
global type w_fin_find_txnumber from mt_w_response
end type
type cb_jump from commandbutton within w_fin_find_txnumber
end type
type cb_ok from commandbutton within w_fin_find_txnumber
end type
type dw_1 from datawindow within w_fin_find_txnumber
end type
end forward

global type w_fin_find_txnumber from mt_w_response
integer width = 3419
integer height = 700
string title = "Find TX number"
cb_jump cb_jump
cb_ok cb_ok
dw_1 dw_1
end type
global w_fin_find_txnumber w_fin_find_txnumber

type variables
datastore ids
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_fin_find_txnumber
	
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
     	11/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
	</HISTORY>
********************************************************************/
end subroutine

on w_fin_find_txnumber.create
int iCurrent
call super::create
this.cb_jump=create cb_jump
this.cb_ok=create cb_ok
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_jump
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_1
end on

on w_fin_find_txnumber.destroy
call super::destroy
destroy(this.cb_jump)
destroy(this.cb_ok)
destroy(this.dw_1)
end on

event open;ids = message.PowerObjectParm
ids.ShareData(dw_1)
end event

type cb_jump from commandbutton within w_fin_find_txnumber
integer x = 2811
integer y = 456
integer width = 585
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Jump to transaction log"
end type

event clicked;string 						ls_txnumber
long							ll_row
u_jump_transaction_log 	luo_jumptrans

ll_row = dw_1.getRow()

if ll_row < 1 then return

ls_txnumber = dw_1.getItemString(ll_row, "trans_log_main_a_f07_docnum")
if isnull(ls_txnumber) then return

luo_jumptrans = create u_jump_transaction_log
luo_jumptrans.of_open_translog(ls_txnumber)
destroy luo_jumptrans

close(parent)

end event

type cb_ok from commandbutton within w_fin_find_txnumber
integer x = 1527
integer y = 460
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&OK"
boolean default = true
end type

event clicked;close(parent)
end event

type dw_1 from datawindow within w_fin_find_txnumber
integer y = 4
integer width = 3397
integer height = 432
integer taborder = 10
string title = "none"
string dataobject = "d_fin_find_txnumber"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow(currentrow, true)
end if
end event

