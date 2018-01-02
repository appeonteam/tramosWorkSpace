$PBExportHeader$w_towage_rebate_reports.srw
$PBExportComments$Reports that shows all disbursement expenses for towage. Given a port and a year.
forward
global type w_towage_rebate_reports from window
end type
type st_1 from statictext within w_towage_rebate_reports
end type
type sle_year from singlelineedit within w_towage_rebate_reports
end type
type st_2 from statictext within w_towage_rebate_reports
end type
type st_portcode from statictext within w_towage_rebate_reports
end type
type cb_select_port from commandbutton within w_towage_rebate_reports
end type
type st_portname from statictext within w_towage_rebate_reports
end type
type cb_deselect_all from commandbutton within w_towage_rebate_reports
end type
type cb_select_all from commandbutton within w_towage_rebate_reports
end type
type cb_close from commandbutton within w_towage_rebate_reports
end type
type cb_saveas from commandbutton within w_towage_rebate_reports
end type
type cb_print from commandbutton within w_towage_rebate_reports
end type
type cb_retrieve from commandbutton within w_towage_rebate_reports
end type
type dw_report from datawindow within w_towage_rebate_reports
end type
type dw_voucher_list from datawindow within w_towage_rebate_reports
end type
end forward

global type w_towage_rebate_reports from window
integer width = 4197
integer height = 2568
boolean titlebar = true
string title = "Towage Rebate Report"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
st_1 st_1
sle_year sle_year
st_2 st_2
st_portcode st_portcode
cb_select_port cb_select_port
st_portname st_portname
cb_deselect_all cb_deselect_all
cb_select_all cb_select_all
cb_close cb_close
cb_saveas cb_saveas
cb_print cb_print
cb_retrieve cb_retrieve
dw_report dw_report
dw_voucher_list dw_voucher_list
end type
global w_towage_rebate_reports w_towage_rebate_reports

type variables
integer ii_voucherno[], ii_empty[]
end variables

forward prototypes
public subroutine wf_retrieve ()
public subroutine documentation ()
end prototypes

public subroutine wf_retrieve ();if upperbound(ii_voucherno) = 0 then return

dw_report.retrieve(ii_voucherno, st_portcode.text, long(sle_year.text), uo_global.is_userid )
end subroutine

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
   	01/09/14		CR3781		CCY018			The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on w_towage_rebate_reports.create
this.st_1=create st_1
this.sle_year=create sle_year
this.st_2=create st_2
this.st_portcode=create st_portcode
this.cb_select_port=create cb_select_port
this.st_portname=create st_portname
this.cb_deselect_all=create cb_deselect_all
this.cb_select_all=create cb_select_all
this.cb_close=create cb_close
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.dw_report=create dw_report
this.dw_voucher_list=create dw_voucher_list
this.Control[]={this.st_1,&
this.sle_year,&
this.st_2,&
this.st_portcode,&
this.cb_select_port,&
this.st_portname,&
this.cb_deselect_all,&
this.cb_select_all,&
this.cb_close,&
this.cb_saveas,&
this.cb_print,&
this.cb_retrieve,&
this.dw_report,&
this.dw_voucher_list}
end on

on w_towage_rebate_reports.destroy
destroy(this.st_1)
destroy(this.sle_year)
destroy(this.st_2)
destroy(this.st_portcode)
destroy(this.cb_select_port)
destroy(this.st_portname)
destroy(this.cb_deselect_all)
destroy(this.cb_select_all)
destroy(this.cb_close)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.dw_report)
destroy(this.dw_voucher_list)
end on

event open;this.move(0,0)
dw_voucher_list.setTransObject(SQLCA)
dw_report.setTransObject(SQLCA)
dw_voucher_list.POST retrieve()
sle_year.text = string(year(today()))

end event

type st_1 from statictext within w_towage_rebate_reports
integer x = 2807
integer y = 32
integer width = 1312
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Please be aware of that this report only shows vessels from Profitcenters that you have access to! "
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_towage_rebate_reports
integer x = 1577
integer y = 264
integer width = 187
integer height = 80
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;POST wf_retrieve()

end event

type st_2 from statictext within w_towage_rebate_reports
integer x = 1257
integer y = 272
integer width = 293
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Year (yyyy):"
boolean focusrectangle = false
end type

type st_portcode from statictext within w_towage_rebate_reports
integer x = 1262
integer y = 24
integer width = 146
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_select_port from commandbutton within w_towage_rebate_reports
integer x = 1262
integer y = 112
integer width = 343
integer height = 68
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select Port"
end type

event clicked;string ls_portcode, ls_portname

ls_portcode =  f_select_from_list ( "dw_ports_list", 2, "Name", 1, "Code", 1, "Select", false ) 

if not isNull(ls_portcode) then
	SELECT PORT_N
		INTO :ls_portname
		FROM PORTS
		WHERE PORT_CODE = :ls_portcode;
	st_portname.text = ls_portname
	st_portcode.text = ls_portcode
	POST wf_retrieve()
end if


end event

type st_portname from statictext within w_towage_rebate_reports
integer x = 1413
integer y = 24
integer width = 603
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_deselect_all from commandbutton within w_towage_rebate_reports
integer x = 439
integer y = 544
integer width = 338
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Deselect All"
end type

event clicked;integer 	li_index
long 		ll_rows, ll_row
//reset voucher array
ii_voucherno = ii_empty

dw_voucher_list.selectrow(0, false)

dw_report.reset()

end event

type cb_select_all from commandbutton within w_towage_rebate_reports
integer x = 27
integer y = 544
integer width = 338
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Select All"
end type

event clicked;integer 	li_index
long 		ll_rows, ll_row
//reset vessel array
ii_voucherno = ii_empty

dw_voucher_list.selectrow(0, true)

ll_rows = dw_voucher_list.rowcount()

li_index = 1
FOR ll_row = 1 TO ll_rows
	if (dw_voucher_list.isselected(ll_row)) then
		ii_voucherno[li_index] = dw_voucher_list.getitemnumber(ll_row, "voucher_nr")
		li_index ++
	end if
NEXT

if li_index > 1 then
	wf_retrieve()		
else 
	dw_report.reset()
end if

end event

type cb_close from commandbutton within w_towage_rebate_reports
integer x = 2304
integer y = 464
integer width = 343
integer height = 100
integer taborder = 140
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;close(parent)
end event

type cb_saveas from commandbutton within w_towage_rebate_reports
integer x = 2304
integer y = 316
integer width = 343
integer height = 100
integer taborder = 130
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Save As..."
end type

event clicked;dw_report.saveAs()
end event

type cb_print from commandbutton within w_towage_rebate_reports
integer x = 2304
integer y = 168
integer width = 343
integer height = 100
integer taborder = 120
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

type cb_retrieve from commandbutton within w_towage_rebate_reports
integer x = 2304
integer y = 20
integer width = 343
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
end type

event clicked;if upperbound(ii_voucherno) > 0 then 
	wf_retrieve()
else 
	dw_report.reset()
end if

end event

type dw_report from datawindow within w_towage_rebate_reports
integer x = 14
integer y = 656
integer width = 4128
integer height = 1804
integer taborder = 150
string title = "none"
string dataobject = "d_sq_tb_towage_rebate_report"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if dwo.type = "text" then
	if dwo.Tag <> "" then
		this.setSort(dwo.Tag)
		this.Sort()
		this.groupcalc()
	end if
end if

end event

type dw_voucher_list from datawindow within w_towage_rebate_reports
integer x = 32
integer y = 24
integer width = 1211
integer height = 504
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_select_voucher"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;integer 	li_index
long 		ll_rows, ll_row
//reset voucher array
ii_voucherno = ii_empty

if (row > 0) then this.selectrow(row, NOT this.isselected(row))

ll_rows = dw_voucher_list.rowcount()

li_index = 1
FOR ll_row = 1 TO ll_rows
	if (dw_voucher_list.isselected(ll_row)) then
		ii_voucherno[li_index] = dw_voucher_list.getitemnumber(ll_row, "voucher_nr")
		li_index ++
	end if
NEXT

if li_index > 1 then
	wf_retrieve()		
else 
	dw_report.reset()
end if

end event

