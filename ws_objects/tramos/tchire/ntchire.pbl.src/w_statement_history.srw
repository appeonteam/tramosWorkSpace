$PBExportHeader$w_statement_history.srw
forward
global type w_statement_history from window
end type
type dw_statement_history from mt_u_datawindow within w_statement_history
end type
end forward

global type w_statement_history from window
integer width = 3694
integer height = 1836
boolean titlebar = true
string title = "Statement History"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_statement_history dw_statement_history
end type
global w_statement_history w_statement_history

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: w_statement_history
   <OBJECT> </OBJECT>
   <DESC>   Display statement history.</DESC>
   <USAGE>  Display statement history. </USAGE>
   <ALSO>   otherobjs</ALSO>
    Date   		Ref    Author        Comments
   05/01-12   M5-4    WWG004			First version.
********************************************************************/
end subroutine

on w_statement_history.create
this.dw_statement_history=create dw_statement_history
this.Control[]={this.dw_statement_history}
end on

on w_statement_history.destroy
destroy(this.dw_statement_history)
end on

event open;long ll_paymentid

this.move(0, 0)

ll_paymentid = message.doubleparm

dw_statement_history.settransobject(sqlca)

dw_statement_history.retrieve(ll_paymentid)

this.title = "Statement History (Payment ID=" + string(ll_paymentid) + ")"

dw_statement_history.object.datawindow.readonly = "Yes"

end event

type dw_statement_history from mt_u_datawindow within w_statement_history
integer x = 37
integer y = 32
integer width = 3621
integer height = 1696
integer taborder = 10
string dataobject = "d_sq_gr_statement_history"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean ib_columntitlesort = true
boolean ib_multicolumnsort = false
end type

event rowfocuschanged;call super::rowfocuschanged;this.selectrow(0, false)
this.selectrow(currentrow, true)
end event

event clicked;call super::clicked;if row <= 0 then return 1
end event

