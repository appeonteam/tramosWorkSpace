$PBExportHeader$w_marketchart.srw
forward
global type w_marketchart from window
end type
type cb_saveas from mt_u_commandbutton within w_marketchart
end type
type dw_marketchart_list from datawindow within w_marketchart
end type
type cb_draw from mt_u_commandbutton within w_marketchart
end type
type st_2 from statictext within w_marketchart
end type
type st_1 from statictext within w_marketchart
end type
type dw_enddate from datawindow within w_marketchart
end type
type dw_startdate from datawindow within w_marketchart
end type
type cb_2 from mt_u_commandbutton within w_marketchart
end type
type cb_1 from mt_u_commandbutton within w_marketchart
end type
type cb_delete from mt_u_commandbutton within w_marketchart
end type
type cb_save from mt_u_commandbutton within w_marketchart
end type
type cb_marketchart from mt_u_commandbutton within w_marketchart
end type
type st_7 from mt_u_statictext within w_marketchart
end type
type dw_profit_center from mt_u_datawindow within w_marketchart
end type
type dw_vesseltype from datawindow within w_marketchart
end type
type dw_marketchart from datawindow within w_marketchart
end type
type ln_1 from line within w_marketchart
end type
end forward

global type w_marketchart from window
integer width = 2693
integer height = 1284
boolean titlebar = true
string title = "Fixture Market Chart"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_saveas cb_saveas
dw_marketchart_list dw_marketchart_list
cb_draw cb_draw
st_2 st_2
st_1 st_1
dw_enddate dw_enddate
dw_startdate dw_startdate
cb_2 cb_2
cb_1 cb_1
cb_delete cb_delete
cb_save cb_save
cb_marketchart cb_marketchart
st_7 st_7
dw_profit_center dw_profit_center
dw_vesseltype dw_vesseltype
dw_marketchart dw_marketchart
ln_1 ln_1
end type
global w_marketchart w_marketchart

type variables
integer ii_profitcenter
end variables

on w_marketchart.create
this.cb_saveas=create cb_saveas
this.dw_marketchart_list=create dw_marketchart_list
this.cb_draw=create cb_draw
this.st_2=create st_2
this.st_1=create st_1
this.dw_enddate=create dw_enddate
this.dw_startdate=create dw_startdate
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_delete=create cb_delete
this.cb_save=create cb_save
this.cb_marketchart=create cb_marketchart
this.st_7=create st_7
this.dw_profit_center=create dw_profit_center
this.dw_vesseltype=create dw_vesseltype
this.dw_marketchart=create dw_marketchart
this.ln_1=create ln_1
this.Control[]={this.cb_saveas,&
this.dw_marketchart_list,&
this.cb_draw,&
this.st_2,&
this.st_1,&
this.dw_enddate,&
this.dw_startdate,&
this.cb_2,&
this.cb_1,&
this.cb_delete,&
this.cb_save,&
this.cb_marketchart,&
this.st_7,&
this.dw_profit_center,&
this.dw_vesseltype,&
this.dw_marketchart,&
this.ln_1}
end on

on w_marketchart.destroy
destroy(this.cb_saveas)
destroy(this.dw_marketchart_list)
destroy(this.cb_draw)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_enddate)
destroy(this.dw_startdate)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_delete)
destroy(this.cb_save)
destroy(this.cb_marketchart)
destroy(this.st_7)
destroy(this.dw_profit_center)
destroy(this.dw_vesseltype)
destroy(this.dw_marketchart)
destroy(this.ln_1)
end on

event open;datawindowchild	ldwc
 
dw_profit_center.settransobject(SQLCA)
dw_profit_center.retrieve(uo_global.is_userid)

dw_vesseltype.insertrow(0)
dw_vesseltype.getchild("cal_vest_type_id", ldwc)
ldwc.SetTransObject(SQLCA)
ldwc.retrieve()

//set initial date
dw_startdate.insertRow(0)
dw_enddate.insertRow(0)


if (dw_profit_center.rowcount( ) > 0) then
		dw_profit_center.selectrow(1,true)
		ii_profitcenter = dw_profit_center.getItemNumber(1, "pc_nr")
		if ii_profitcenter <> 0 then
			dw_marketchart.settransobject(SQLCA)
			dw_marketchart.retrieve(today(),ii_profitcenter)
		end if
		if SQLCA.SQLcode = 0 and dw_marketchart.rowcount( ) > 0 then
			cb_save.enabled = true
			cb_delete.enabled = true
		else 
			cb_save.enabled = false
			cb_delete.enabled = false
		end if
end if

end event

type cb_saveas from mt_u_commandbutton within w_marketchart
integer x = 2240
integer y = 16
integer width = 279
integer taborder = 60
string facename = "Arial"
boolean enabled = false
string text = "&Save As..."
end type

event clicked;dw_marketchart_list.saveas()

end event

type dw_marketchart_list from datawindow within w_marketchart
integer x = 741
integer y = 136
integer width = 1897
integer height = 400
integer taborder = 40
string title = "none"
string dataobject = "d_marketchart_list"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_draw from mt_u_commandbutton within w_marketchart
integer x = 1993
integer y = 16
integer width = 224
integer taborder = 50
string facename = "Arial"
string text = "&Draw"
end type

event clicked;call super::clicked;
datetime ldt_start_date, ldt_end_date

/*Validate Profitcenter */
if ii_profitcenter = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter")
	dw_profit_center.post setFocus()
	return
end if

/* Validate dates */
dw_startdate.accepttext()
dw_enddate.accepttext()
if isnull(dw_startdate.getItemDate(1, "date_value")) or &
	isNull(dw_enddate.getItemDate(1, "date_value")) then 
	MessageBox("Information", "Please enter both start- and enddate")
	return
end if
if dw_startdate.getItemDate(1, "date_value") >= &
	dw_enddate.getItemDate(1, "date_value") then 
	MessageBox("Information", "Startdate must be before enddate")
	return
end if

ldt_start_date = datetime(dw_startdate.getItemDate(1, "date_value"))
ldt_end_date = datetime(dw_enddate.getItemDate(1, "date_value"))

dw_marketchart_list.settransobject(SQLCA)
dw_marketchart_list.retrieve(ii_profitcenter, ldt_start_date, ldt_end_date)

if dw_marketchart_list.rowcount() > 0 then
	cb_saveas.enabled = true
else
	cb_saveas.enabled = false
end if

end event

type st_2 from statictext within w_marketchart
integer x = 1431
integer y = 32
integer width = 224
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "To date:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_marketchart
integer x = 768
integer y = 32
integer width = 283
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "From date:"
boolean focusrectangle = false
end type

type dw_enddate from datawindow within w_marketchart
integer x = 1655
integer y = 20
integer width = 302
integer height = 92
integer taborder = 30
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_startdate from datawindow within w_marketchart
integer x = 1070
integer y = 20
integer width = 302
integer height = 92
integer taborder = 20
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from mt_u_commandbutton within w_marketchart
integer x = 2286
integer y = 1056
integer width = 357
integer taborder = 130
string facename = "Arial"
string text = "&Daily Report"
end type

event clicked;call super::clicked;opensheet (w_daily_report, w_tramos_main, 3, Original!)
end event

type cb_1 from mt_u_commandbutton within w_marketchart
integer x = 2313
integer y = 588
integer width = 320
integer taborder = 80
string facename = "Arial"
string text = "&Add type"
end type

type cb_delete from mt_u_commandbutton within w_marketchart
integer x = 1536
integer y = 1056
integer width = 206
integer taborder = 110
string facename = "Arial"
boolean enabled = false
string text = "&Delete"
end type

event clicked;long	ll_row

ll_row = dw_marketchart.getRow()
if ll_row < 1 then return


if MessageBox("Confirmation", "Are you sure you you want to delete?", question!, YesNo!,2) = 1 then 
	if dw_marketchart.deleterow(ll_row) = 1 then
		dw_marketchart.update( )
		commit;	
		dw_marketchart.retrieve(today(),ii_profitcenter)
		return 1
	else
		MessageBox("Delete Error", "Error deleting.")
		return -1
	end if
end if

end event

type cb_save from mt_u_commandbutton within w_marketchart
integer x = 1257
integer y = 1056
integer width = 270
integer taborder = 100
string facename = "Arial"
boolean enabled = false
string text = "&Save All"
end type

event clicked;call super::clicked;int			li_x
if  dw_marketchart.rowcount( ) <> 0 then
	dw_marketchart.acceptText()
	if dw_marketchart.update() = 1 then
		commit;
		dw_marketchart.retrieve(today(),ii_profitcenter)
	else
		rollback;
		MessageBox("Update Error", "Error updating.")
		return -1
	end if
end if
end event

type cb_marketchart from mt_u_commandbutton within w_marketchart
integer x = 1751
integer y = 1056
integer width = 521
integer taborder = 120
string facename = "Arial"
string text = "&Market Assessment"
end type

event clicked;call super::clicked;opensheet (w_marketassessment, w_tramos_main, 3, Original!)
end event

type st_7 from mt_u_statictext within w_marketchart
integer x = 9
integer width = 599
integer height = 56
integer weight = 700
string facename = "Arial"
string text = "Select Profit Center(s):"
end type

type dw_profit_center from mt_u_datawindow within w_marketchart
integer x = 14
integer y = 64
integer width = 699
integer height = 588
integer taborder = 10
string dataobject = "d_profit_center"
boolean vscrollbar = true
end type

event clicked;if row > 0 then
	selectrow(0, false)
	selectrow(row, true)	
	ii_profitcenter = this.getItemNumber(row, "pc_nr")
end if

if ii_profitcenter <> 0 then
	dw_marketchart.settransobject(SQLCA)
	dw_marketchart.retrieve(today(),ii_profitcenter)
end if

if SQLCA.SQLcode = 0 and dw_marketchart.rowcount( ) > 0 then
	cb_save.enabled = true
	cb_delete.enabled = true
else 
	cb_save.enabled = false
	cb_delete.enabled = false
end if





end event

type dw_vesseltype from datawindow within w_marketchart
integer x = 1541
integer y = 596
integer width = 763
integer height = 88
integer taborder = 70
string title = "none"
string dataobject = "d_vesseltype"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;int						li_row
datawindowchild	ldwc
string					ls_vesseltype_name

if ii_profitcenter = 0 then
	MessageBox("Validation Error", "Please select a Profitcenter.")
	dw_profit_center.post setFocus()
	return
else
	dw_vesseltype.getchild("cal_vest_type_id", ldwc)
	ls_vesseltype_name = ldwc.getitemstring(ldwc.getrow( ),"cal_vest_type_name")
	li_row = dw_marketchart.insertrow(0)
	dw_marketchart.setitem(li_row,"cal_vest_cal_vest_type_name", ls_vesseltype_name)
	dw_marketchart.setitem(li_row,"pf_marketchart_chartvalue", 0)
	dw_marketchart.setitem(li_row,"pf_marketchart_showdailyreport", 1)
	dw_marketchart.setitem(li_row,"pf_marketchart_cal_vest_type_id", long(data))
	dw_marketchart.setitem(li_row,"pf_marketchart_pc_nr", ii_profitcenter)
end if

dw_marketchart.accepttext( )
if dw_marketchart.rowcount( ) > 0 then
	cb_save.enabled = true
	cb_delete.enabled = true
else
	cb_save.enabled = false
	cb_delete.enabled = false
end if

end event

type dw_marketchart from datawindow within w_marketchart
integer x = 736
integer y = 696
integer width = 1906
integer height = 328
integer taborder = 90
string title = "none"
string dataobject = "d_marketchart"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 then
	selectrow(0, false)
	selectrow(currentrow, true)	
end if
end event

type ln_1 from line within w_marketchart
long linecolor = 33554432
integer linethickness = 4
integer beginx = 754
integer beginy = 564
integer endx = 2624
integer endy = 564
end type

