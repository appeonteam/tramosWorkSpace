$PBExportHeader$w_offservice_bunker_calculation.srw
$PBExportComments$Shows on which bunker purchase the calculation is based
forward
global type w_offservice_bunker_calculation from mt_w_response
end type
type cb_print from commandbutton within w_offservice_bunker_calculation
end type
type cb_ok from commandbutton within w_offservice_bunker_calculation
end type
type dw_report from datawindow within w_offservice_bunker_calculation
end type
end forward

global type w_offservice_bunker_calculation from mt_w_response
integer width = 3141
integer height = 1692
string title = "Off-Hire Bunker Calculation"
cb_print cb_print
cb_ok cb_ok
dw_report dw_report
end type
global w_offservice_bunker_calculation w_offservice_bunker_calculation

type variables
n_voyage_offservice_bunker_consumption		inv_offservice
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_offservice_bunker_calculation
	
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

on w_offservice_bunker_calculation.create
int iCurrent
call super::create
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_print
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.dw_report
end on

on w_offservice_bunker_calculation.destroy
call super::destroy
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_report)
end on

event open;long	ll_ops_offserviceID

ll_ops_offserviceID = message.doubleparm

inv_offservice = create n_voyage_offservice_bunker_consumption
inv_offservice.POST of_showcalculation(  ll_ops_offserviceID, dw_report )






end event

event close;destroy inv_offservice
end event

type st_hidemenubar from mt_w_response`st_hidemenubar within w_offservice_bunker_calculation
end type

type cb_print from commandbutton within w_offservice_bunker_calculation
integer x = 2368
integer y = 1472
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

event clicked;dw_report.print()
end event

type cb_ok from commandbutton within w_offservice_bunker_calculation
integer x = 2743
integer y = 1472
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close (parent)
end event

type dw_report from datawindow within w_offservice_bunker_calculation
integer width = 3127
integer height = 1416
integer taborder = 10
string title = "none"
string dataobject = "d_ex_tb_offservice_calculation"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

