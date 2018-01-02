$PBExportHeader$w_default_values_change_log.srw
$PBExportComments$Window for display changes made to default values used in transactions.
forward
global type w_default_values_change_log from mt_w_response
end type
type cb_ok from commandbutton within w_default_values_change_log
end type
type dw_log from datawindow within w_default_values_change_log
end type
end forward

global type w_default_values_change_log from mt_w_response
integer width = 3301
integer height = 2176
string title = "Changes made to Default Transaction Values"
cb_ok cb_ok
dw_log dw_log
end type
global w_default_values_change_log w_default_values_change_log

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_default_values_change_log
	
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

on w_default_values_change_log.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_log=create dw_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_log
end on

on w_default_values_change_log.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_log)
end on

event open;dw_log.setTransObject(SQLCA)
dw_log.POST retrieve()
end event

type cb_ok from commandbutton within w_default_values_change_log
integer x = 1467
integer y = 1972
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;close(parent)
end event

type dw_log from datawindow within w_default_values_change_log
integer x = 9
integer y = 16
integer width = 3255
integer height = 1928
integer taborder = 10
string title = "none"
string dataobject = "d_default_trans_values_change_log"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

