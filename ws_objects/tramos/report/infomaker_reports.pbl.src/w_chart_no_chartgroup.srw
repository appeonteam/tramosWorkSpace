$PBExportHeader$w_chart_no_chartgroup.srw
$PBExportComments$Charterers NOT members of Charterer Group
forward
global type w_chart_no_chartgroup from mt_w_main
end type
type cb_2 from commandbutton within w_chart_no_chartgroup
end type
type cb_1 from commandbutton within w_chart_no_chartgroup
end type
type st_1 from statictext within w_chart_no_chartgroup
end type
type dw_chart_chartgrp_freight from datawindow within w_chart_no_chartgroup
end type
end forward

global type w_chart_no_chartgroup from mt_w_main
integer width = 2226
integer height = 2100
string title = "Charterers Not Members of Group"
boolean maxbox = false
boolean resizable = false
cb_2 cb_2
cb_1 cb_1
st_1 st_1
dw_chart_chartgrp_freight dw_chart_chartgrp_freight
end type
global w_chart_no_chartgroup w_chart_no_chartgroup

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_chart_no_chartgroup
	
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
		29/08/14		CR3781		CCY018		The window title match with the text of a menu item
	</HISTORY>
********************************************************************/
end subroutine

on w_chart_no_chartgroup.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_chart_chartgrp_freight=create dw_chart_chartgrp_freight
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_chart_chartgrp_freight
end on

on w_chart_no_chartgroup.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_chart_chartgrp_freight)
end on

event open;dw_chart_chartgrp_freight.settransobject(SQLCA)
dw_chart_chartgrp_freight.retrieve()
end event

type st_hidemenubar from mt_w_main`st_hidemenubar within w_chart_no_chartgroup
end type

type cb_2 from commandbutton within w_chart_no_chartgroup
integer x = 1486
integer y = 1912
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
boolean default = true
end type

event clicked;dw_chart_chartgrp_freight.print()
end event

type cb_1 from commandbutton within w_chart_no_chartgroup
integer x = 1856
integer y = 1912
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
boolean cancel = true
end type

event clicked;closewithreturn(parent,"")

end event

type st_1 from statictext within w_chart_no_chartgroup
integer x = 37
integer y = 12
integer width = 1810
integer height = 128
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charterers with Freight or used as Charterer in TC-out and not member of Charterer Group"
boolean focusrectangle = false
end type

type dw_chart_chartgrp_freight from datawindow within w_chart_no_chartgroup
integer x = 37
integer y = 164
integer width = 2167
integer height = 1708
integer taborder = 10
string title = "none"
string dataobject = "d_chart_no_chartgroup_report"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row >0) then
	this.selectrow(0,false)
	this.selectrow(row, true)
end if


end event

