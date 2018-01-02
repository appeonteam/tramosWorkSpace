$PBExportHeader$w_select_gas_report.srw
$PBExportComments$Used for selecting a Gas report from a list.
forward
global type w_select_gas_report from mt_w_response
end type
type cb_help from commandbutton within w_select_gas_report
end type
type cb_select_report from commandbutton within w_select_gas_report
end type
type cb_close from commandbutton within w_select_gas_report
end type
type lb_report_name from listbox within w_select_gas_report
end type
end forward

global type w_select_gas_report from mt_w_response
integer x = 2002
integer y = 300
integer width = 1038
integer height = 1712
string title = "Select Report"
cb_help cb_help
cb_select_report cb_select_report
cb_close cb_close
lb_report_name lb_report_name
end type
global w_select_gas_report w_select_gas_report

type variables

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_select_gas_report
	
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
		17/09/14		CR3781		CCY018			The window title match with the text of a menu item
	</HISTORY>
********************************************************************/

end subroutine

on w_select_gas_report.create
int iCurrent
call super::create
this.cb_help=create cb_help
this.cb_select_report=create cb_select_report
this.cb_close=create cb_close
this.lb_report_name=create lb_report_name
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_help
this.Control[iCurrent+2]=this.cb_select_report
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.lb_report_name
end on

on w_select_gas_report.destroy
call super::destroy
destroy(this.cb_help)
destroy(this.cb_select_report)
destroy(this.cb_close)
destroy(this.lb_report_name)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_select_gas_report
end type

type cb_help from commandbutton within w_select_gas_report
integer x = 50
integer y = 1484
integer width = 910
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Help"
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
20-02-2001  1.0	TAU	Initial version. 
************************************************************************************/
String ls_name, ls_text

uo_help luo_help
luo_help = Create uo_help

ls_name = lb_report_name.SelectedItem()

If ls_name = "" Then
	ls_text = "Please select a report to see the corresponding help text"
	ls_name = "Attention"
Else
	ls_text = luo_help.of_help_text(ls_name)
End if

MessageBox(ls_name,ls_text,Information!,OK!)

Destroy luo_help
end event

type cb_select_report from commandbutton within w_select_gas_report
integer x = 544
integer y = 1360
integer width = 416
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select report"
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

w_reports_gv.cb_reset.TriggerEvent(Clicked!)
w_reports_gv.cb_create_report.Enabled = False
w_reports_gv.ib_retrieve = true
CloseWithReturn(Parent,lb_report_name.SelectedItem())

end event

type cb_close from commandbutton within w_select_gas_report
integer x = 50
integer y = 1360
integer width = 443
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancel"
end type

event clicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
16-08-2000  1.0	TAU	Initial version. 
************************************************************************************/
Close(Parent)
end event

type lb_report_name from listbox within w_select_gas_report
integer x = 55
integer y = 48
integer width = 910
integer height = 1256
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"Top Charterer","Top Broker","Vessel Fleettracking","Total Freight/Demurrage","COA Liftings/CVS","Liftings","Commissions","Vessel Port Visits","Port Rate/Grade/Temp","Active/Finished Voyages","Vessel Disbursement","Employment","Charteres Home Country Support","TC Hire","Idle Days","Country Port Visits","Vessel Rate/Grade/Temp","Port Disbursement","Grade Fleettracking","Charterer Demurrage Statistics","Broker Demurrage Statistics","Country Port Visits TC-out"}
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;/************************************************************************************
DATE			VER. 	NAME	DESCRIPTION
17-08-2000  1.0	TAU	Initial version. 
************************************************************************************/

w_reports_gv.cb_reset.TriggerEvent(Clicked!)
w_reports_gv.cb_create_report.Enabled = False
w_reports_gv.ib_retrieve = true
CloseWithReturn(Parent,lb_report_name.SelectedItem())
end event

