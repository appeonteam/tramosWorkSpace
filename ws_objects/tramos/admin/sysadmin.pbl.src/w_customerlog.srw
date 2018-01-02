$PBExportHeader$w_customerlog.srw
$PBExportComments$Used to display table CUSTOMERLOG which is a table logging changes made to Agent, Broker, Charterer and TC Owner
forward
global type w_customerlog from window
end type
type cb_saveas from commandbutton within w_customerlog
end type
type cb_print from commandbutton within w_customerlog
end type
type cb_retrieve from commandbutton within w_customerlog
end type
type dw_auditlog from datawindow within w_customerlog
end type
end forward

global type w_customerlog from window
integer width = 3794
integer height = 2388
boolean titlebar = true
string title = "Customer Log"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
cb_saveas cb_saveas
cb_print cb_print
cb_retrieve cb_retrieve
dw_auditlog dw_auditlog
end type
global w_customerlog w_customerlog

on w_customerlog.create
this.cb_saveas=create cb_saveas
this.cb_print=create cb_print
this.cb_retrieve=create cb_retrieve
this.dw_auditlog=create dw_auditlog
this.Control[]={this.cb_saveas,&
this.cb_print,&
this.cb_retrieve,&
this.dw_auditlog}
end on

on w_customerlog.destroy
destroy(this.cb_saveas)
destroy(this.cb_print)
destroy(this.cb_retrieve)
destroy(this.dw_auditlog)
end on

event open;dw_auditlog.SetTransObject(SQLCA)
move(0,0)
end event

type cb_saveas from commandbutton within w_customerlog
integer x = 978
integer y = 80
integer width = 338
integer height = 96
integer taborder = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&SaveAs..."
end type

event clicked;dw_auditlog.SaveAs()
end event

type cb_print from commandbutton within w_customerlog
integer x = 558
integer y = 80
integer width = 338
integer height = 96
integer taborder = 50
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Print"
end type

event clicked;dw_auditlog.Print()
end event

type cb_retrieve from commandbutton within w_customerlog
integer x = 18
integer y = 80
integer width = 338
integer height = 96
integer taborder = 30
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Retrieve"
boolean default = true
end type

event clicked; dw_auditlog.retrieve()


end event

type dw_auditlog from datawindow within w_customerlog
integer x = 5
integer y = 260
integer width = 3726
integer height = 1968
integer taborder = 40
string title = "none"
string dataobject = "d_customerlog"
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

