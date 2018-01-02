$PBExportHeader$w_vslschedule.srw
forward
global type w_vslschedule from window
end type
type cb_print from commandbutton within w_vslschedule
end type
type cb_close from commandbutton within w_vslschedule
end type
type dw_schedule from datawindow within w_vslschedule
end type
end forward

global type w_vslschedule from window
integer width = 5248
integer height = 2456
boolean titlebar = true
string title = "Vessel Schedule"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_print cb_print
cb_close cb_close
dw_schedule dw_schedule
end type
global w_vslschedule w_vslschedule

on w_vslschedule.create
this.cb_print=create cb_print
this.cb_close=create cb_close
this.dw_schedule=create dw_schedule
this.Control[]={this.cb_print,&
this.cb_close,&
this.dw_schedule}
end on

on w_vslschedule.destroy
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.dw_schedule)
end on

event open;
dw_schedule.SetTransobject(SQLCA)

//messagebox("",dw_schedule.Modify("Datawindow.Print.Preview='No'"))

dw_schedule.Retrieve(g_obj.Objid )


end event

type cb_print from commandbutton within w_vslschedule
integer x = 1463
integer y = 2240
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Print"
end type

event clicked;
dw_schedule.Print(False, True)
end event

type cb_close from commandbutton within w_vslschedule
integer x = 3273
integer y = 2240
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
end type

event clicked;
Close(Parent)
end event

type dw_schedule from datawindow within w_vslschedule
integer x = 18
integer y = 16
integer width = 5193
integer height = 2192
integer taborder = 10
string title = "none"
string dataobject = "d_sq_tb_vslpoc"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

