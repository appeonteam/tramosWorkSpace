$PBExportHeader$w_select_vouchers.srw
$PBExportComments$General voucher selection - returns array with voucher numbers
forward
global type w_select_vouchers from mt_w_response
end type
type cb_cancel from commandbutton within w_select_vouchers
end type
type cb_ok from commandbutton within w_select_vouchers
end type
type dw_vouchers from datawindow within w_select_vouchers
end type
end forward

global type w_select_vouchers from mt_w_response
integer width = 1678
integer height = 2648
string title = "Select Vouchers"
boolean controlmenu = false
event ue_postopen ( )
cb_cancel cb_cancel
cb_ok cb_ok
dw_vouchers dw_vouchers
end type
global w_select_vouchers w_select_vouchers

type variables
n_vouchers_parm_container inv_parm

end variables

forward prototypes
public subroutine documentation ()
end prototypes

event ue_postopen();long	ll_rows, ll_row, ll_found

dw_vouchers.retrieve()

ll_rows = upperbound(inv_parm.ii_vouchers)
if  ll_rows < 1 then return

/* Mark all vouchers that are marked */
for ll_row = 1 to ll_rows
	ll_found = dw_vouchers.find("voucher_nr="+string(inv_parm.ii_vouchers[ll_row]),1,9999)
	if ll_found > 0 then dw_vouchers.selectrow(ll_found, true)
next
end event

public subroutine documentation ();/********************************************************************
	w_select_vouchers
	
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
	</HISTORY>
********************************************************************/

end subroutine

on w_select_vouchers.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_vouchers=create dw_vouchers
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_vouchers
end on

on w_select_vouchers.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_vouchers)
end on

event open;inv_parm = create n_vouchers_parm_container
inv_parm	 = message.powerobjectparm

dw_vouchers.setTransObject(sqlca)
postevent( "ue_postopen")


end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_vouchers
end type

type cb_cancel from commandbutton within w_select_vouchers
integer x = 859
integer y = 2428
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;integer	li_empty[]

/* Reset array */
inv_parm.ii_vouchers = li_empty

closeWithReturn( parent, inv_parm )
end event

type cb_ok from commandbutton within w_select_vouchers
integer x = 457
integer y = 2428
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

event clicked;long		ll_found=0
integer	li_empty[]

/* Reset array */
inv_parm.ii_vouchers = li_empty

do   
	ll_found = dw_vouchers.getselectedrow( ll_found)
	if ll_found > 0 then 
		inv_parm.ii_vouchers[ upperbound(inv_parm.ii_vouchers) +1] = dw_vouchers.getItemNumber(ll_found, "voucher_nr")
	end if
loop while ll_found > 0

closeWithReturn( parent, inv_parm )
end event

type dw_vouchers from datawindow within w_select_vouchers
integer x = 9
integer y = 8
integer width = 1623
integer height = 2368
integer taborder = 10
string title = "none"
string dataobject = "d_sq_gp_select_vouchers"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if row > 0 then this.selectrow(row, not this.isselected(row))
end event

