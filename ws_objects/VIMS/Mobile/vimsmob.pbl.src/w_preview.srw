$PBExportHeader$w_preview.srw
forward
global type w_preview from window
end type
type st_text from statictext within w_preview
end type
type st_msg from statictext within w_preview
end type
type dw_rep from datawindow within w_preview
end type
type cb_print from commandbutton within w_preview
end type
type cb_close from commandbutton within w_preview
end type
end forward

global type w_preview from window
integer width = 3813
integer height = 2516
boolean titlebar = true
string title = "Report Preview"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "J:\TramosWS\VIMS\images\Vims\Preview.ico"
string pointer = "HourGlass!"
boolean center = true
st_text st_text
st_msg st_msg
dw_rep dw_rep
cb_print cb_print
cb_close cb_close
end type
global w_preview w_preview

forward prototypes
public subroutine wf_showreport ()
end prototypes

public subroutine wf_showreport ();
st_text.Visible = False
st_msg.Visible = False
cb_print.Enabled = True
cb_close.Enabled = True
This.Pointer = "Arrow!"
end subroutine

on w_preview.create
this.st_text=create st_text
this.st_msg=create st_msg
this.dw_rep=create dw_rep
this.cb_print=create cb_print
this.cb_close=create cb_close
this.Control[]={this.st_text,&
this.st_msg,&
this.dw_rep,&
this.cb_print,&
this.cb_close}
end on

on w_preview.destroy
destroy(this.st_text)
destroy(this.st_msg)
destroy(this.dw_rep)
destroy(this.cb_print)
destroy(this.cb_close)
end on

event resize;Integer li_x

dw_Rep.Width = newwidth - dw_rep.x * 2

li_x = newheight - dw_rep.x * 3 - cb_Close.Height
If li_x < 400 then li_x = 400

dw_rep.Height = li_x

cb_Close.y = dw_rep.y * 2 + li_x
cb_Print.y = cb_Close.y 

li_x = newwidth / 3 - (cb_Close.Width / 2)

if li_x < dw_rep.x then li_x = dw_rep.x

cb_Print.x = li_x

li_x = newwidth * 2 / 3 - (cb_Close.Width / 2)

if li_x < cb_Print.x + cb_print.width then li_x = cb_Print.x + cb_print.width

cb_Close.x = li_x

st_msg.width = newwidth
st_msg.height = newheight

end event

event closequery;
If cb_close.Enabled then return 0 else return 1
end event

event close;
f_Write2Log("w_Preview Close")
FileDelete("Trend.bmp")

Run('cmd /Q /C Del /Q "' + g_Obj.Tempfolder + '\*.jpg"', Minimized!)
end event

event open;
f_Write2Log("w_Preview Open")
end event

event key;
If Key = KeyF1! then ShowHelp ("vmhelp.chm", Topic!, 1900)
end event

type st_text from statictext within w_preview
integer x = 1445
integer y = 704
integer width = 878
integer height = 176
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 8421504
long backcolor = 67108864
string text = "Generating Report. Please wait..."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_msg from statictext within w_preview
integer width = 1390
integer height = 336
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "HourGlass!"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_rep from datawindow within w_preview
integer x = 18
integer y = 16
integer width = 2267
integer height = 832
integer taborder = 10
string title = "none"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_print from commandbutton within w_preview
integer x = 713
integer y = 912
integer width = 494
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Print"
end type

event clicked;
f_Write2Log("w_Preview > cb_Print")
dw_Rep.Print(True, True)
end event

type cb_close from commandbutton within w_preview
integer x = 1518
integer y = 912
integer width = 494
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean enabled = false
string text = "Close"
end type

event clicked;
Close(Parent)


end event

