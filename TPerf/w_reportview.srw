HA$PBExportHeader$w_reportview.srw
forward
global type w_reportview from window
end type
type cb_close from commandbutton within w_reportview
end type
type dw_rep from datawindow within w_reportview
end type
end forward

global type w_reportview from window
integer width = 3479
integer height = 1904
boolean titlebar = true
string title = "Report Details"
boolean controlmenu = true
long backcolor = 67108864
string icon = "Menu5!"
boolean center = true
cb_close cb_close
dw_rep dw_rep
end type
global w_reportview w_reportview

event open;
dw_rep.settransobject( SQLCA)

dw_rep.retrieve( g_parameters.voyageid )

dw_rep.setfilter( 'Rep_ID = ' + string(g_parameters.reportid ))
dw_rep.filter( )
end event

on w_reportview.create
this.cb_close=create cb_close
this.dw_rep=create dw_rep
this.Control[]={this.cb_close,&
this.dw_rep}
end on

on w_reportview.destroy
destroy(this.cb_close)
destroy(this.dw_rep)
end on

type cb_close from commandbutton within w_reportview
integer x = 1445
integer y = 1696
integer width = 622
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

event clicked;

close(parent)
end event

type dw_rep from datawindow within w_reportview
integer x = 18
integer y = 16
integer width = 3419
integer height = 1648
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_reportdetailwithalerts"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

