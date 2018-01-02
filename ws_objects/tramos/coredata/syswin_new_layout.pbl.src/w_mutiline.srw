$PBExportHeader$w_mutiline.srw
forward
global type w_mutiline from window
end type
type mle_text from multilineedit within w_mutiline
end type
end forward

global type w_mutiline from window
boolean visible = false
integer width = 4101
integer height = 588
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
mle_text mle_text
end type
global w_mutiline w_mutiline

on w_mutiline.create
this.mle_text=create mle_text
this.Control[]={this.mle_text}
end on

on w_mutiline.destroy
destroy(this.mle_text)
end on

event open;integer li_len, li_count, li_index
string ls_newstr
s_multiline lstr_multiline

lstr_multiline = message.powerobjectparm

mle_text.text = lstr_multiline.text
mle_text.width = lstr_multiline.width

li_count = mle_text.linecount()
li_len = 0

for li_index = 1 to li_count
	mle_text.selecttext(mle_text.position() + li_len, 0)
	if li_index > 1 then ls_newstr += "~r~n"
	ls_newstr += mle_text.textline()
	li_len = mle_text.linelength()
next

closewithreturn(this, ls_newstr)
end event

type mle_text from multilineedit within w_mutiline
integer y = 60
integer width = 4000
integer height = 400
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

