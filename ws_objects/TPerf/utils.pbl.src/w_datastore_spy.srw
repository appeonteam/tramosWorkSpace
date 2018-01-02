$PBExportHeader$w_datastore_spy.srw
$PBExportComments$Utility window called from function f_datastore_spy. Visualize a datastore object.
forward
global type w_datastore_spy from window
end type
type cb_4 from commandbutton within w_datastore_spy
end type
type cb_3 from commandbutton within w_datastore_spy
end type
type cb_2 from commandbutton within w_datastore_spy
end type
type cb_1 from commandbutton within w_datastore_spy
end type
type cb_print from commandbutton within w_datastore_spy
end type
type cb_ok from commandbutton within w_datastore_spy
end type
type dw_spy from datawindow within w_datastore_spy
end type
end forward

global type w_datastore_spy from window
integer width = 3013
integer height = 1876
boolean titlebar = true
string title = "Datastore Spy..."
windowtype windowtype = response!
long backcolor = 67108864
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
cb_print cb_print
cb_ok cb_ok
dw_spy dw_spy
end type
global w_datastore_spy w_datastore_spy

type variables
datastore	ids_data
end variables

event open;ids_data = CREATE datastore
ids_data = message.PowerObjectParm

dw_spy.dataObject = ids_data.dataObject
ids_data.shareData(dw_spy)


end event

on w_datastore_spy.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_print=create cb_print
this.cb_ok=create cb_ok
this.dw_spy=create dw_spy
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.cb_print,&
this.cb_ok,&
this.dw_spy}
end on

on w_datastore_spy.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_print)
destroy(this.cb_ok)
destroy(this.dw_spy)
end on

type cb_4 from commandbutton within w_datastore_spy
integer x = 2176
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "SaveAs"
end type

event clicked;dw_spy.saveas( )
end event

type cb_3 from commandbutton within w_datastore_spy
integer x = 1093
integer y = 1636
integer width = 361
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Column Status"
end type

event clicked;long ll_row

ll_row = dw_spy.getRow()

if ll_row < 1 then return

choose case dw_spy.getItemStatus( ll_row, dw_spy.getColumn(), primary!)
	case New!
		MessageBox("Column #"+string(dw_spy.getColumn()), "Status = New")
	case NewModified!
		MessageBox("Column #"+string(dw_spy.getColumn()), "Status = NewModified")
	case DataModified!
		MessageBox("Column #"+string(dw_spy.getColumn()), "Status = DataModified")
	case NotModified!
		MessageBox("Column #"+string(dw_spy.getColumn()), "Status = NotModified")
	case else
		MessageBox("Column #"+string(dw_spy.getColumn()), "Status = Error")
end choose		
end event

type cb_2 from commandbutton within w_datastore_spy
integer x = 1499
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Field Content"
end type

event clicked;string ls_colcount, ls_msg, ls_content
long ll_row, ll_col, ll_cols

ll_row = dw_spy.getRow()
if ll_row < 1 then return

ls_colcount = dw_spy.Object.DataWindow.Column.Count
ll_cols = long(ls_colcount)
if ll_cols < 1 then return

ls_msg = "Show field content by field number~r~n~r~n"
for ll_col = 1 to ll_cols
	choose case mid(dw_spy.describe("#"+string(ll_col)+".ColType"),1,4)
		case "char"
			ls_content = dw_spy.getItemString(ll_row, ll_col)
		case "date"
			ls_content =string(dw_spy.getItemdatetime(ll_row, ll_col))
		case else
			ls_content = string(dw_spy.getItemnumber(ll_row, ll_col))
	end choose
	if isNull(ls_content) then ls_content = "<NULL>"
	ls_msg +="Field # "+string(ll_col, "00")+" ("+dw_spy.Describe("#"+string(ll_col)+".dbName")+") = "+ls_content+"~r~n"
next

MessageBox("Content", ls_msg)
end event

type cb_1 from commandbutton within w_datastore_spy
integer x = 704
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Row Status"
end type

event clicked;long ll_row

ll_row = dw_spy.getRow()

if ll_row < 1 then return

choose case dw_spy.getItemStatus( ll_row, 0, primary!)
	case New!
		MessageBox("Row #"+string(ll_row), "Status = New")
	case NewModified!
		MessageBox("Row #"+string(ll_row), "Status = NewModified")
	case DataModified!
		MessageBox("Row #"+string(ll_row), "Status = DataModified")
	case NotModified!
		MessageBox("Row #"+string(ll_row), "Status = NotModified")
	case else
		MessageBox("Row #"+string(ll_row), "Status = Error")
end choose		
end event

type cb_print from commandbutton within w_datastore_spy
integer x = 2546
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;dw_spy.print()
end event

type cb_ok from commandbutton within w_datastore_spy
integer x = 32
integer y = 1636
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;dw_spy.shareDataOff()
closewithreturn ( parent, 0 )
end event

type dw_spy from datawindow within w_datastore_spy
integer x = 32
integer y = 124
integer width = 2921
integer height = 1468
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;if currentrow > 0 then
	this.selectrow(0, false)
	this.selectrow( currentrow , true)
end if
end event

