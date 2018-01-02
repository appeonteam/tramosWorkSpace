$PBExportHeader$w_show_disb_exp.srw
forward
global type w_show_disb_exp from window
end type
type cb_print from commandbutton within w_show_disb_exp
end type
type cb_ok from commandbutton within w_show_disb_exp
end type
type dw_disb_exp from datawindow within w_show_disb_exp
end type
end forward

global type w_show_disb_exp from window
integer width = 2674
integer height = 2220
boolean titlebar = true
windowtype windowtype = child!
long backcolor = 67108864
boolean center = true
cb_print cb_print
cb_ok cb_ok
dw_disb_exp dw_disb_exp
end type
global w_show_disb_exp w_show_disb_exp

type variables
datastore ids_data
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_show_disb_exp
   <OBJECT> Shows the Disbursement expenses included in the TC Out VAS report </OBJECT>
   <DESC> </DESC>
   <USAGE></USAGE>
   <ALSO></ALSO>
Date			Ref    Author	Comments
11/07/11		2490	RMO		Splitted income and expenses.
  
********************************************************************/

end subroutine

event open;ids_data = CREATE datastore
ids_data = message.PowerObjectParm

dw_disb_exp.dataObject = ids_data.dataObject
ids_data.shareData(dw_disb_exp)

end event

on w_show_disb_exp.create
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_disb_exp=create dw_disb_exp
this.Control[]={this.cb_print,&
this.cb_ok,&
this.dw_disb_exp}
end on

on w_show_disb_exp.destroy
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_disb_exp)
end on

type cb_print from commandbutton within w_show_disb_exp
integer x = 1467
integer y = 1976
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_disb_exp.Print()
end event

type cb_ok from commandbutton within w_show_disb_exp
integer x = 823
integer y = 1976
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

type dw_disb_exp from datawindow within w_show_disb_exp
integer x = 14
integer y = 20
integer width = 2629
integer height = 1904
integer taborder = 10
string title = "none"
string dataobject = "d_vas_tc_disb"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

