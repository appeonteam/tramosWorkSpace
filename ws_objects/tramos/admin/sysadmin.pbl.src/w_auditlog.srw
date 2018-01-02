$PBExportHeader$w_auditlog.srw
$PBExportComments$Used to display table AUDITLOG which is a table logging external_partner transactions regarding claim transactions
forward
global type w_auditlog from window
end type
type st_rows from statictext within w_auditlog
end type
type st_4 from statictext within w_auditlog
end type
type st_3 from statictext within w_auditlog
end type
type dw_date from datawindow within w_auditlog
end type
type rb_all from radiobutton within w_auditlog
end type
type rb_date from radiobutton within w_auditlog
end type
type rb_vv from radiobutton within w_auditlog
end type
type st_2 from statictext within w_auditlog
end type
type st_1 from statictext within w_auditlog
end type
type sle_voyage from singlelineedit within w_auditlog
end type
type sle_vessel from singlelineedit within w_auditlog
end type
type cb_saveas from commandbutton within w_auditlog
end type
type cb_print from commandbutton within w_auditlog
end type
type cb_retrieve from commandbutton within w_auditlog
end type
type dw_auditlog from datawindow within w_auditlog
end type
type gb_2 from groupbox within w_auditlog
end type
end forward

global type w_auditlog from window
integer width = 4681
integer height = 2516
boolean titlebar = true
string title = "Audit Log"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
st_rows st_rows
st_4 st_4
st_3 st_3
dw_date dw_date
rb_all rb_all
rb_date rb_date
rb_vv rb_vv
st_2 st_2
st_1 st_1
sle_voyage sle_voyage
sle_vessel sle_vessel
cb_saveas cb_saveas
cb_print cb_print
cb_retrieve cb_retrieve
dw_auditlog dw_auditlog
gb_2 gb_2
end type
global w_auditlog w_auditlog

on w_auditlog.create
this.st_rows=create st_rows
this.st_4=create st_4
this.st_3=create st_3
this.dw_date=create dw_date
this.rb_all=create rb_all
this.rb_date=create rb_date
this.rb_vv=create rb_vv
this.st_2=create st_2
this.st_1=create st_1
this.sle_voyage=create sle_voyage
this.sle_vessel=create sle_vessel
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.dw_auditlog=create dw_auditlog
this.gb_2=create gb_2
this.Control[]={this.st_rows,&
this.st_4,&
this.st_3,&
this.dw_date,&
this.rb_all,&
this.rb_date,&
this.rb_vv,&
this.st_2,&
this.st_1,&
this.sle_voyage,&
this.sle_vessel,&
this.cb_saveas,&
this.cb_print,&
this.cb_retrieve,&
this.dw_auditlog,&
this.gb_2}
end on

on w_auditlog.destroy
destroy(this.st_rows)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_date)
destroy(this.rb_all)
destroy(this.rb_date)
destroy(this.rb_vv)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_voyage)
destroy(this.sle_vessel)
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.dw_auditlog)
destroy(this.gb_2)
end on

event open;dw_auditlog.SetTransObject(SQLCA)
dw_date.insertRow(0)
move(0,0)
end event

type st_rows from statictext within w_auditlog
integer x = 4201
integer y = 260
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "0"
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_auditlog
integer x = 3826
integer y = 268
integer width = 361
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "Rows retrieved:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_auditlog
integer x = 914
integer y = 220
integer width = 165
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "Date:"
boolean focusrectangle = false
end type

type dw_date from datawindow within w_auditlog
integer x = 1102
integer y = 200
integer width = 306
integer height = 88
integer taborder = 30
boolean enabled = false
string title = "none"
string dataobject = "d_date"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type rb_all from radiobutton within w_auditlog
integer x = 87
integer y = 236
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "All items"
end type

event clicked;sle_vessel.enabled =false
sle_voyage.enabled = false
dw_date.enabled = false

end event

type rb_date from radiobutton within w_auditlog
integer x = 87
integer y = 152
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = ">= Date"
end type

event clicked;sle_vessel.enabled = false
sle_voyage.enabled = false
dw_date.enabled = true
dw_date.post setfocus()
end event

type rb_vv from radiobutton within w_auditlog
integer x = 87
integer y = 76
integer width = 558
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "Vessel and/or voyage"
boolean checked = true
end type

event clicked;sle_vessel.enabled = true
sle_voyage.enabled = true
dw_date.enabled = false
sle_vessel.post setfocus()
end event

type st_2 from statictext within w_auditlog
integer x = 1399
integer y = 100
integer width = 187
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "Voyage:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_auditlog
integer x = 914
integer y = 100
integer width = 183
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "Vessel:"
boolean focusrectangle = false
end type

type sle_voyage from singlelineedit within w_auditlog
integer x = 1600
integer y = 92
integer width = 261
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
borderstyle borderstyle = stylelowered!
end type

type sle_vessel from singlelineedit within w_auditlog
integer x = 1102
integer y = 92
integer width = 251
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type cb_saveas from commandbutton within w_auditlog
integer x = 2990
integer y = 232
integer width = 338
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&SaveAs..."
end type

event clicked;dw_auditlog.SaveAs()
end event

type cb_print from commandbutton within w_auditlog
integer x = 2578
integer y = 232
integer width = 338
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Print"
end type

event clicked;dw_auditlog.Print()
end event

type cb_retrieve from commandbutton within w_auditlog
integer x = 2176
integer y = 232
integer width = 338
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retrieve"
boolean default = true
end type

event clicked;integer	li_vessel
string		ls_voyage
long		ll_rows
datetime	ldt_date

dw_auditlog.setRedraw(false)
dw_auditlog.dataobject=""
dw_auditlog.dataobject="d_auditlog"
dw_auditlog.setTransobject( sqlca )

if rb_vv.checked then
	SELECT VESSEL_NR INTO :li_vessel FROM VESSELS WHERE VESSEL_REF_NR = :sle_vessel.text;
	//li_vessel = integer(sle_vessel.text)
	if li_vessel < 1 then 
		Messagebox("Information", "Please enter a Vessel number before retrieve")
		sle_vessel.post setfocus()
		dw_auditlog.setRedraw(true)
		return
	end if
	
	ls_voyage = sle_voyage.text
	if right(ls_voyage,1)  <> "%" then ls_voyage += "%"
	
	dw_auditlog.object.datawindow.table.select = &
		dw_auditlog.Object.DataWindow.Table.SQLSelect +&
		" and AUDITLOG.VESSEL_NR = "+string(li_vessel)+"  AND  AUDITLOG.VOYAGE_NR like '"+ls_voyage+"'"    
elseif rb_date.checked then
	dw_date.accepttext( )
	ldt_date = datetime(dw_date.getItemDate(1, "date_value"))
	if isnull(ldt_date) then
		Messagebox("Information", "Please enter a date before retrieve")
		dw_date.post setfocus()
		dw_auditlog.setRedraw(true)
		return
	end if
	dw_auditlog.object.datawindow.table.select = &
		dw_auditlog.Object.DataWindow.Table.SQLSelect +&
		" and AUDITLOG.TRANS_DATE >= '"+string(ldt_date, "dd mmmm yyyy hh:mm")+"'" 
end if

ll_rows = dw_auditlog.retrieve( uo_global.is_userid )

if ll_rows < 1 then 
	Messagebox("Information", "No rows match criteria! Please try again")
	cb_retrieve.default = true
	st_rows.text = "0"
else
	st_rows.text = string(ll_rows, "#,##0")
	dw_auditlog.post setfocus()
end if
 dw_auditlog.setRedraw(true)

end event

type dw_auditlog from datawindow within w_auditlog
integer x = 5
integer y = 344
integer width = 4581
integer height = 2020
integer taborder = 40
string title = "none"
string dataobject = "d_auditlog"
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
	//ls_type = dwo.type+" / "+dwo.name
	//MessageBox("Type + navn",ls_type)
	//MessageBox("getClickedCloumn",this.getClickedColumn())
	
	
end if

end event

type gb_2 from groupbox within w_auditlog
integer x = 14
integer y = 12
integer width = 2085
integer height = 316
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 41943040
long backcolor = 74481808
string text = "Select report and enter criteria"
end type

