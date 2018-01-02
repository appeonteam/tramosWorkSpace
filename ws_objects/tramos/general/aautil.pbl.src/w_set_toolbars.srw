$PBExportHeader$w_set_toolbars.srw
$PBExportComments$Sets toolbars
forward
global type w_set_toolbars from window
end type
type rb_floating from radiobutton within w_set_toolbars
end type
type rb_bottom from radiobutton within w_set_toolbars
end type
type rb_right from radiobutton within w_set_toolbars
end type
type rb_top from radiobutton within w_set_toolbars
end type
type rb_left from radiobutton within w_set_toolbars
end type
type cbx_show_tips from checkbox within w_set_toolbars
end type
type cbx_showtext from checkbox within w_set_toolbars
end type
type cb_done from commandbutton within w_set_toolbars
end type
type cb_visible from commandbutton within w_set_toolbars
end type
type gb_1 from groupbox within w_set_toolbars
end type
end forward

global type w_set_toolbars from window
integer x = 1650
integer y = 620
integer width = 1211
integer height = 676
boolean titlebar = true
string title = "Customize Toolbars"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 81324524
boolean center = true
rb_floating rb_floating
rb_bottom rb_bottom
rb_right rb_right
rb_top rb_top
rb_left rb_left
cbx_show_tips cbx_show_tips
cbx_showtext cbx_showtext
cb_done cb_done
cb_visible cb_visible
gb_1 gb_1
end type
global w_set_toolbars w_set_toolbars

type variables
window iw_win_ref
application iapp_ref
end variables

on open;iw_win_ref = message.powerobjectparm

choose case iw_win_ref.toolbaralignment
	case alignatbottom! 
		rb_bottom.checked = True
	case alignatleft!
		rb_left.checked = true
	case alignatright!
		rb_right.checked = true
	case alignattop! 
		rb_top.checked = true
	case floating!
		rb_floating.checked = true
end choose

if iw_win_ref.toolbarvisible then
	cb_visible.text = "&Hide"
else
	cb_visible.text = "&Show"
end if

iapp_ref = getapplication()
cbx_showtext.checked = iapp_ref.toolbartext
cbx_show_tips.checked = iapp_ref.toolbartips
	
end on

on w_set_toolbars.create
this.rb_floating=create rb_floating
this.rb_bottom=create rb_bottom
this.rb_right=create rb_right
this.rb_top=create rb_top
this.rb_left=create rb_left
this.cbx_show_tips=create cbx_show_tips
this.cbx_showtext=create cbx_showtext
this.cb_done=create cb_done
this.cb_visible=create cb_visible
this.gb_1=create gb_1
this.Control[]={this.rb_floating,&
this.rb_bottom,&
this.rb_right,&
this.rb_top,&
this.rb_left,&
this.cbx_show_tips,&
this.cbx_showtext,&
this.cb_done,&
this.cb_visible,&
this.gb_1}
end on

on w_set_toolbars.destroy
destroy(this.rb_floating)
destroy(this.rb_bottom)
destroy(this.rb_right)
destroy(this.rb_top)
destroy(this.rb_left)
destroy(this.cbx_show_tips)
destroy(this.cbx_showtext)
destroy(this.cb_done)
destroy(this.cb_visible)
destroy(this.gb_1)
end on

type rb_floating from radiobutton within w_set_toolbars
integer x = 96
integer y = 432
integer width = 338
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Floating"
end type

on clicked;iw_win_ref.toolbaralignment = floating!
end on

type rb_bottom from radiobutton within w_set_toolbars
integer x = 96
integer y = 344
integer width = 311
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Bottom"
end type

on clicked;iw_win_ref.toolbaralignment = alignatbottom!
end on

type rb_right from radiobutton within w_set_toolbars
integer x = 96
integer y = 256
integer width = 256
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Right"
end type

on clicked;iw_win_ref.toolbaralignment = alignatright!
end on

type rb_top from radiobutton within w_set_toolbars
integer x = 96
integer y = 168
integer width = 210
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Top"
end type

on clicked;iw_win_ref.toolbaralignment = alignattop!
end on

type rb_left from radiobutton within w_set_toolbars
integer x = 96
integer y = 80
integer width = 210
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "&Left"
end type

on clicked;iw_win_ref.toolbaralignment = alignatleft!
end on

type cbx_show_tips from checkbox within w_set_toolbars
integer x = 544
integer y = 396
integer width = 613
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Show &Power Tips"
end type

on clicked;iapp_ref.toolbartips = this.checked
end on

type cbx_showtext from checkbox within w_set_toolbars
integer x = 544
integer y = 308
integer width = 443
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Show Te&xt"
end type

on clicked;iapp_ref.toolbartext = this.checked

end on

type cb_done from commandbutton within w_set_toolbars
integer x = 878
integer y = 176
integer width = 261
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Done"
boolean default = true
end type

on clicked;
Close (parent)
end on

type cb_visible from commandbutton within w_set_toolbars
integer x = 878
integer y = 32
integer width = 261
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Hide"
end type

on clicked;If this.text = "&Hide" then
	iw_win_ref.toolbarvisible = False
	this.text = "&Show"
else
	iw_win_ref.toolbarvisible = True
	this.text = "&Hide"
end if
end on

type gb_1 from groupbox within w_set_toolbars
integer x = 41
integer y = 8
integer width = 443
integer height = 528
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
string text = "Move"
end type

