$PBExportHeader$w_vessel_resp.srw
$PBExportComments$This window shows responisble operators/finance people per vessel.
forward
global type w_vessel_resp from window
end type
type cbx_apmowned from checkbox within w_vessel_resp
end type
type cbx_rate from checkbox within w_vessel_resp
end type
type cbx_tcin from checkbox within w_vessel_resp
end type
type cbx_active from checkbox within w_vessel_resp
end type
type rb_vessel_creation from radiobutton within w_vessel_resp
end type
type cb_saveas from commandbutton within w_vessel_resp
end type
type dw_finresp from datawindow within w_vessel_resp
end type
type dw_profit_center from datawindow within w_vessel_resp
end type
type rb_fin_history from radiobutton within w_vessel_resp
end type
type cb_2 from commandbutton within w_vessel_resp
end type
type rb_operator from radiobutton within w_vessel_resp
end type
type rb_fin_resp from radiobutton within w_vessel_resp
end type
type dw_vessel from datawindow within w_vessel_resp
end type
type gb_2 from groupbox within w_vessel_resp
end type
type gb_1 from groupbox within w_vessel_resp
end type
type gb_3 from groupbox within w_vessel_resp
end type
end forward

global type w_vessel_resp from window
integer width = 3643
integer height = 2536
boolean titlebar = true
string title = "Vessel Responsibility"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
cbx_apmowned cbx_apmowned
cbx_rate cbx_rate
cbx_tcin cbx_tcin
cbx_active cbx_active
rb_vessel_creation rb_vessel_creation
cb_saveas cb_saveas
dw_finresp dw_finresp
dw_profit_center dw_profit_center
rb_fin_history rb_fin_history
cb_2 cb_2
rb_operator rb_operator
rb_fin_resp rb_fin_resp
dw_vessel dw_vessel
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_vessel_resp w_vessel_resp

forward prototypes
public subroutine of_filter ()
public subroutine documentation ()
end prototypes

public subroutine of_filter ();long ll_row, ll_rows
string ls_filter, ls_pcfilter, ls_respfilter

/* Profitcenter filter */
ll_rows = dw_profit_center.rowcount()
FOR ll_row=1 TO ll_rows
	if (dw_profit_center.isselected(ll_row)) then
		if (len(ls_pcfilter)=0) then
			ls_pcfilter = " (" + string(dw_profit_center.getitemnumber(ll_row, "pc_nr"))
		else
			ls_pcfilter += ", " + string(dw_profit_center.getitemnumber(ll_row, "pc_nr"))
		end if
	end if
NEXT
if (len(ls_pcfilter)>0) then
	ls_pcfilter += " )"
end if
if (len(ls_pcfilter)>0) then
	ls_pcfilter = " vessels_pc_nr in " + ls_pcfilter
end if
 
/* Finans responsible filter */
ll_rows = dw_finresp.rowcount()
FOR ll_row=1 TO ll_rows
	if (dw_finresp.isselected(ll_row)) then
		if (len(ls_respfilter)=0) then
			ls_respfilter = " ('" + dw_finresp.getitemstring(ll_row, "fin_resp")+"'"
		else
			ls_respfilter += ", '" + dw_finresp.getitemstring(ll_row, "fin_resp")+"'"
		end if
	end if
NEXT
if (len(ls_respfilter)>0) then
	ls_respfilter += " )"
end if
if (len(ls_respfilter)>0) then
	ls_respfilter = " vessels_vessel_fin_resp in " + ls_respfilter
end if

/* merge filters */
if (len(ls_pcfilter)>0) and (len(ls_respfilter)>0) then
	ls_filter = ls_pcfilter + " and " + ls_respfilter
elseif (len(ls_pcfilter)>0) then
	ls_filter = ls_pcfilter
elseif (len(ls_respfilter)>0) then
	ls_filter = ls_respfilter
else
	ls_filter = ""
end if

/* vessel active filter*/
if len(ls_filter) > 0 and cbx_active.checked then
	ls_filter = ls_filter + " and vessel_active=1"
elseif cbx_active.checked then
	 ls_filter="vessel_active=1"
end if

/* TC-IN vessel filter - only valid for finance responsible report*/
if dw_vessel.dataobject = "d_vessel_fin_resp" then
	if len(ls_filter) > 0 and cbx_tcin.checked then
		ls_filter = ls_filter + " and tc_hire_in=1"
	elseif cbx_tcin.checked then
		 ls_filter="tc_hire_in=1"
	end if
end if

/* TC-IN rate filter - only valid for finance responsible report*/
if dw_vessel.dataobject = "d_vessel_fin_resp" then
	if len(ls_filter) > 0 and cbx_rate.checked then
		ls_filter = ls_filter + " and rate <> 0"
	elseif cbx_rate.checked then
		 ls_filter="rate <> 0"
	end if
end if

/* APM Owned filter*/
if dw_vessel.dataobject = "d_vessel_fin_resp" then
	if len(ls_filter) > 0 and cbx_apmowned.checked then
		ls_filter = ls_filter + " and apm_owned_vessel=1"
	elseif cbx_apmowned.checked then
		 ls_filter="apm_owned_vessel=1"
	end if
end if
dw_vessel.setfilter(ls_filter)
dw_vessel.filter()
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
   	29/08/14		CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

event open;this.move(0,0)
this.width = 3634
this.height = 2800
dw_vessel.settransobject(SQLCA)
dw_vessel.retrieve(uo_global.is_userid)
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)
dw_finresp .settransobject(SQLCA)
dw_finresp.retrieve(uo_global.is_userid)
rb_fin_resp.POST setfocus()
end event

on w_vessel_resp.create
this.cbx_apmowned=create cbx_apmowned
this.cbx_rate=create cbx_rate
this.cbx_tcin=create cbx_tcin
this.cbx_active=create cbx_active
this.rb_vessel_creation=create rb_vessel_creation
this.cb_saveas=create cb_saveas
this.dw_finresp=create dw_finresp
this.dw_profit_center=create dw_profit_center
this.rb_fin_history=create rb_fin_history
this.cb_2=create cb_2
this.rb_operator=create rb_operator
this.rb_fin_resp=create rb_fin_resp
this.dw_vessel=create dw_vessel
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.Control[]={this.cbx_apmowned,&
this.cbx_rate,&
this.cbx_tcin,&
this.cbx_active,&
this.rb_vessel_creation,&
this.cb_saveas,&
this.dw_finresp,&
this.dw_profit_center,&
this.rb_fin_history,&
this.cb_2,&
this.rb_operator,&
this.rb_fin_resp,&
this.dw_vessel,&
this.gb_2,&
this.gb_1,&
this.gb_3}
end on

on w_vessel_resp.destroy
destroy(this.cbx_apmowned)
destroy(this.cbx_rate)
destroy(this.cbx_tcin)
destroy(this.cbx_active)
destroy(this.rb_vessel_creation)
destroy(this.cb_saveas)
destroy(this.dw_finresp)
destroy(this.dw_profit_center)
destroy(this.rb_fin_history)
destroy(this.cb_2)
destroy(this.rb_operator)
destroy(this.rb_fin_resp)
destroy(this.dw_vessel)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

type cbx_apmowned from checkbox within w_vessel_resp
integer x = 2853
integer y = 2012
integer width = 535
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "APM Owned"
end type

event clicked;of_filter( )
end event

type cbx_rate from checkbox within w_vessel_resp
integer x = 2853
integer y = 1940
integer width = 535
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "TC-IN Rate <> 0"
end type

event clicked;of_filter( )
end event

type cbx_tcin from checkbox within w_vessel_resp
integer x = 2853
integer y = 1868
integer width = 535
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Only TC-IN Vessels"
end type

event clicked;of_filter()
end event

type cbx_active from checkbox within w_vessel_resp
integer x = 2853
integer y = 1796
integer width = 544
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Only Active Vessels"
end type

event clicked;of_filter()
end event

type rb_vessel_creation from radiobutton within w_vessel_resp
integer x = 123
integer y = 2240
integer width = 457
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vessel Creation"
end type

event clicked;dw_vessel.dataobject = "d_vessel_created_whenwhom"
dw_vessel.settransobject(SQLCA)
dw_vessel.retrieve(uo_global.is_userid)
dw_profit_center.selectrow(0,false)
dw_finresp.selectrow(0, false)
cbx_active.checked = false
cbx_tcin.enabled = false
cbx_rate.enabled = false
cbx_rate.checked = false
cbx_apmowned.enabled = false
cbx_apmowned.checked = false

dw_finresp.enabled = false
dw_profit_center.enabled = false

end event

type cb_saveas from commandbutton within w_vessel_resp
integer x = 2930
integer y = 2232
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&SaveAs"
end type

event clicked;dw_vessel.saveas()
end event

type dw_finresp from datawindow within w_vessel_resp
integer x = 1755
integer y = 1876
integer width = 978
integer height = 536
integer taborder = 40
string title = "none"
string dataobject = "d_sq_tb_select_finance_responsible"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
		of_filter()
	else
		this.selectrow(row,true)
		of_filter()
	end if
end if
end event

type dw_profit_center from datawindow within w_vessel_resp
integer x = 809
integer y = 1876
integer width = 773
integer height = 536
integer taborder = 30
string title = "none"
string dataobject = "d_profit_center"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;if (row > 0) then
	if this.isselected(row) then
		this.selectrow(row,false)
		of_filter()
	else
		this.selectrow(row,true)
		of_filter()
	end if
end if
end event

type rb_fin_history from radiobutton within w_vessel_resp
integer x = 123
integer y = 2148
integer width = 430
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Finance History"
end type

event clicked;dw_vessel.dataobject = "d_finance_history"
dw_vessel.settransobject(SQLCA)
dw_vessel.retrieve(uo_global.is_userid)
dw_profit_center.selectrow(0,false)
dw_finresp.selectrow(0, false)
cbx_active.checked = false
cbx_tcin.enabled = false
cbx_rate.enabled = false
cbx_rate.checked = false
cbx_apmowned.enabled = false
cbx_apmowned.checked = false

dw_finresp.enabled = true
dw_profit_center.enabled = true

end event

type cb_2 from commandbutton within w_vessel_resp
integer x = 2930
integer y = 2116
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_vessel.print()
end event

type rb_operator from radiobutton within w_vessel_resp
integer x = 123
integer y = 2056
integer width = 325
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Operator"
end type

event clicked;dw_vessel.dataobject = "d_vessel_operator"
dw_vessel.settransobject(SQLCA)
dw_vessel.retrieve(uo_global.is_userid)
dw_profit_center.selectrow(0,false)
dw_finresp.selectrow(0, false)
cbx_active.checked = false
cbx_tcin.enabled = false
cbx_rate.enabled = false
cbx_rate.checked = false
cbx_apmowned.enabled = false
cbx_apmowned.checked = false

dw_finresp.enabled = true
dw_profit_center.enabled = true

end event

type rb_fin_resp from radiobutton within w_vessel_resp
integer x = 123
integer y = 1964
integer width = 293
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Finance"
end type

event clicked;dw_vessel.dataobject = "d_vessel_fin_resp"
dw_vessel.settransobject(SQLCA)
dw_vessel.retrieve(uo_global.is_userid)
dw_profit_center.selectrow(0,false)
dw_finresp.selectrow(0, false)
cbx_active.checked = false
cbx_tcin.enabled = true
cbx_tcin.checked = false
cbx_rate.enabled = true
cbx_rate.checked = false
cbx_apmowned.enabled = true
cbx_apmowned.checked = false

dw_finresp.enabled = true
dw_profit_center.enabled = true

end event

type dw_vessel from datawindow within w_vessel_resp
integer x = 37
integer y = 32
integer width = 3566
integer height = 1700
integer taborder = 10
string title = "none"
string dataobject = "d_vessel_fin_resp"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;string ls_sort
if dwo.type = "text" then
	ls_sort = dwo.Tag
	this.setSort(ls_sort)
	this.Sort()
	if right(ls_sort,1) = "A" then 
		ls_sort = replace(ls_sort, len(ls_sort),1, "D")
	else
		ls_sort = replace(ls_sort, len(ls_sort),1, "A")
	end if
	dwo.Tag = ls_sort

end if
end event

type gb_2 from groupbox within w_vessel_resp
integer x = 37
integer y = 1800
integer width = 663
integer height = 648
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Who is Responsible"
end type

type gb_1 from groupbox within w_vessel_resp
integer x = 759
integer y = 1800
integer width = 882
integer height = 648
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter Profit Center"
end type

type gb_3 from groupbox within w_vessel_resp
integer x = 1705
integer y = 1800
integer width = 1083
integer height = 648
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter Finance Responsible"
end type

