$PBExportHeader$w_select_commission.srw
forward
global type w_select_commission from mt_w_response
end type
type st_1 from statictext within w_select_commission
end type
type cbx_broker from checkbox within w_select_commission
end type
type cbx_pool from checkbox within w_select_commission
end type
type cb_cancel from commandbutton within w_select_commission
end type
type cb_ok from commandbutton within w_select_commission
end type
end forward

global type w_select_commission from mt_w_response
integer width = 997
integer height = 708
string title = "Commission Type Selection"
boolean controlmenu = false
st_1 st_1
cbx_broker cbx_broker
cbx_pool cbx_pool
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_select_commission w_select_commission

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_select_commission
	
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

on w_select_commission.create
int iCurrent
call super::create
this.st_1=create st_1
this.cbx_broker=create cbx_broker
this.cbx_pool=create cbx_pool
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_broker
this.Control[iCurrent+3]=this.cbx_pool
this.Control[iCurrent+4]=this.cb_cancel
this.Control[iCurrent+5]=this.cb_ok
end on

on w_select_commission.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cbx_broker)
destroy(this.cbx_pool)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;//M5-6 Begin modified by ZSW001 on 15/02/2012
s_cp_id	lstr_cp_id

lstr_cp_id = message.powerobjectparm
//cbx_pool.enabled = not isnull(lstr_cp_id.pool)
cbx_broker.enabled = not isnull(lstr_cp_id.broker)

if not isnull(lstr_cp_id.pool) and lstr_cp_id.pool = 1 then
	cbx_pool.checked = true
end if

if not isnull(lstr_cp_id.broker) and lstr_cp_id.broker = 1 then
	cbx_broker.checked = true
end if
//M5-6 End modified by ZSW001 on 15/02/2012

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_commission
end type

type st_1 from statictext within w_select_commission
integer x = 96
integer y = 36
integer width = 814
integer height = 124
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Choose the commission(s) you want the system to calculate:"
boolean focusrectangle = false
end type

type cbx_broker from checkbox within w_select_commission
integer x = 146
integer y = 336
integer width = 727
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Calculate &Broker Commission"
end type

type cbx_pool from checkbox within w_select_commission
integer x = 146
integer y = 208
integer width = 727
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Calculate &Pool Commission"
end type

type cb_cancel from commandbutton within w_select_commission
integer x = 549
integer y = 476
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
07-06-2001  1.0	TAU	Initial version. 
************************************************************************************/
s_cp_id ls_cp_id

ls_cp_id.broker = -1
ls_cp_id.pool = -1

CloseWithReturn(w_select_commission, ls_cp_id)

end event

type cb_ok from commandbutton within w_select_commission
integer x = 82
integer y = 476
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
07-06-2001  1.0	TAU	Initial version. 
************************************************************************************/
s_cp_id ls_cp_id

If cbx_broker.checked = True Then
	ls_cp_id.broker = 1
Else
	ls_cp_id.broker = 0
End if

If cbx_pool.checked = True Then
	ls_cp_id.pool = 1
Else
	ls_cp_id.pool = 0
End if

CloseWithReturn(w_select_commission,ls_cp_id)

end event

