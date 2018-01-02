$PBExportHeader$u_sle.sru
forward
global type u_sle from singlelineedit
end type
end forward

global type u_sle from singlelineedit
integer width = 457
integer height = 132
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
event ue_change pbm_enchange
event ue_changed ( string as_text )
event ue_char pbm_char
end type
global u_sle u_sle

type variables
public:
string prompttext = ""
boolean prompt = false
long normaltextcolor = rgb(0,0,0)
long prompttextcolor = 8421504
private:
boolean ib_reset = false
boolean ib_settingtext = false
string is_char
end variables

forward prototypes
private function integer _initprompt ()
public function integer of_settext (string as_text)
public function string of_gettext ()
end prototypes

event ue_change;
string ls_text

if ib_settingtext then return

ls_text = this.text
if prompt then
	if ls_text = "" then
		this.post _initprompt()
	end if
end if

this.event ue_changed(ls_text)

end event

event ue_char;if prompt then
	if ib_reset then
		this.textcolor = normaltextcolor
		ib_reset = false
		of_settext("")
	end if
end if

end event

private function integer _initprompt ();
of_settext(prompttext)
this.textcolor = prompttextcolor
ib_reset = true
return 1
end function

public function integer of_settext (string as_text);
ib_settingtext = true
this.text = as_text

if as_text <> prompttext then
	this.selecttext(len(as_text)+1,0)
else
	this.selecttext(1,0)
end if
ib_settingtext = false

return 1
end function

public function string of_gettext ();if prompt then
	if ib_reset then
		return ""
	end if
end if
return this.text
end function

on u_sle.create
end on

on u_sle.destroy
end on

event getfocus;if prompt then
	if this.text = "" then
		_initprompt()
	end if
end if


end event

event losefocus;if prompt then
	if this.text = "" then
		_initprompt()
	end if
end if

end event

event constructor;if prompt then
	_initprompt()
end if

end event

