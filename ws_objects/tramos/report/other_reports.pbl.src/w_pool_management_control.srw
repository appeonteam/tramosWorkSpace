$PBExportHeader$w_pool_management_control.srw
$PBExportComments$This window shows Pool Management Fee where fee calculated from received amount differs from commission amount
forward
global type w_pool_management_control from w_sheet
end type
type st_2 from statictext within w_pool_management_control
end type
type st_1 from statictext within w_pool_management_control
end type
type em_year from editmask within w_pool_management_control
end type
type cb_saveas from commandbutton within w_pool_management_control
end type
type cb_print from commandbutton within w_pool_management_control
end type
type cb_retrieve from commandbutton within w_pool_management_control
end type
type dw_report from u_dw within w_pool_management_control
end type
end forward

global type w_pool_management_control from w_sheet
integer width = 3886
integer height = 2644
string title = "Pool Management Fee Control"
boolean maxbox = false
boolean resizable = false
st_2 st_2
st_1 st_1
em_year em_year
cb_saveas cb_saveas
cb_print cb_print
cb_retrieve cb_retrieve
dw_report dw_report
end type
global w_pool_management_control w_pool_management_control

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	28/08/14	CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;call super::open;dw_report.setTransObject(sqlca)
em_year.text = string(year(today()) -2000)
em_year.POST setFocus()

end event

on w_pool_management_control.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_1=create st_1
this.em_year=create em_year
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_year
this.Control[iCurrent+4]=this.cb_saveas
this.Control[iCurrent+5]=this.cb_print
this.Control[iCurrent+6]=this.cb_retrieve
this.Control[iCurrent+7]=this.dw_report
end on

on w_pool_management_control.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.dw_report)
end on

type st_2 from statictext within w_pool_management_control
integer x = 5
integer y = 24
integer width = 2958
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Report shows where Commissions calculated from  Receivables differs from Commission Amount in Commission"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pool_management_control
integer x = 59
integer y = 2452
integer width = 183
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year:"
boolean focusrectangle = false
end type

type em_year from editmask within w_pool_management_control
integer x = 247
integer y = 2444
integer width = 142
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "00"
end type

type cb_saveas from commandbutton within w_pool_management_control
integer x = 1536
integer y = 2436
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_report.saveas()
end event

type cb_print from commandbutton within w_pool_management_control
integer x = 1079
integer y = 2436
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

type cb_retrieve from commandbutton within w_pool_management_control
integer x = 622
integer y = 2436
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
boolean default = true
end type

event clicked;dw_report.retrieve(em_year.text)
dw_report.POST setFocus()

end event

type dw_report from u_dw within w_pool_management_control
integer y = 100
integer width = 3854
integer height = 2300
integer taborder = 10
string dataobject = "d_sq_tb_management_fee_control_report"
boolean minbox = true
boolean ib_isupdateable = false
boolean ib_rmbmenu = false
end type

event constructor;call super::constructor;of_setSort(true)
if isValid(inv_sort) then inv_sort.of_setColumnheader( true )

end event

