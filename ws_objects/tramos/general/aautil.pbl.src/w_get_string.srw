$PBExportHeader$w_get_string.srw
$PBExportComments$Opened by f_get_string function.  Prompts user for a string value and returns string to a calling window.
forward
global type w_get_string from mt_w_response
end type
type sle_str from singlelineedit within w_get_string
end type
type cb_cancel from commandbutton within w_get_string
end type
type cb_ok from commandbutton within w_get_string
end type
end forward

global type w_get_string from mt_w_response
integer x = 677
integer y = 268
integer width = 896
integer height = 432
boolean controlmenu = false
long backcolor = 81324524
sle_str sle_str
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_get_string w_get_string

type variables
int ii_max_len
str_parms istr_parm
end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   w_get_string
	
	<OBJECT>

	</OBJECT>
   	<DESC>
		
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	05/08/14 	CR3708   AGL027			F1 help application coverage - corrected ancestor
********************************************************************/
end subroutine

event open;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_get_string.open
//
// Purpose:  W_GET_STRING prompts the user for a string.  The public function
//				 f_get_string "opens" window w_get_string.  Function f_get_string
//				 passes the character case, the maximum length the
//				 prompted string should be, and the window title.  The window
//				 and single line edit text field will resize themselves
//				 based on the maximum length passed from f_get_string.
// 		
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
/////////////////////////////////////////////////////////////////////////

string  ls_char_case
window  lw_father
integer li_x, li_y, li_max_width

// get parms from message object
istr_parm = message.powerobjectparm
ls_char_case = istr_parm.string_arg[2]

if ls_char_case     = "U" then 
	sle_str.textcase = upper!
elseif ls_char_case = "L" then 
	sle_str.textcase = Lower!
elseif ls_char_case = "A" then
	sle_str.textcase = AnyCase!
end if

// Get maximum length the string variable should be and set the limit
// attribute on the single line edit.

ii_max_len    = istr_parm.integer_arg[1]
sle_str.limit = ii_max_len

//  Display the current value
sle_str.text = istr_parm.string_arg[3]

// Get the window title from the parameters

this.title    = istr_parm.string_arg[1]
li_max_width  = ii_max_len

// Determine if the window needs to be resized based on the maximum
// length passed from function f_get_string

if len(this.title) > li_max_width then li_max_width = len(this.title)

if li_max_width    > 25 then
	this.width    = li_max_width * 40
	sle_str.width = this.width - 2*sle_str.x
	cb_cancel.x   = sle_str.width + sle_str.x - cb_cancel.width
end if

lw_father = parentwindow(this)

// Center the window on it's parent
li_x = lw_father.x + (lw_father.width - this.width)/2
if li_x < 10 then li_x = 10  // make sure it's on the screen
li_y = lw_father.y + (lw_father.height - this.height)/2
if li_y < 10 then li_y = 10     // make sure it's on the screen

move(this, li_x, li_y)


setfocus(sle_str)

selecttext ( sle_str, 1, len(sle_str.text))
end event

on w_get_string.create
int iCurrent
call super::create
this.sle_str=create sle_str
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_str
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_ok
end on

on w_get_string.destroy
call super::destroy
destroy(this.sle_str)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

type st_hidemenubar from mt_w_response`st_hidemenubar within w_get_string
end type

type sle_str from singlelineedit within w_get_string
integer x = 73
integer y = 64
integer width = 731
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "  "
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_get_string
integer x = 549
integer y = 188
integer width = 247
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
boolean cancel = true
end type

on clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_get_string.cb_cancel
//
// Purpose:  This event will pass a null value back to
//				 function f_get_string.
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
/////////////////////////////////////////////////////////////////////////

string ls_nul

setnull    (ls_nul)
closewithreturn(parent,ls_nul)
end on

type cb_ok from commandbutton within w_get_string
integer x = 69
integer y = 188
integer width = 247
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
boolean default = true
end type

event clicked;/////////////////////////////////////////////////////////////////////////
//
// Event	 :  w_get_string.cb_ok
//
// Purpose:  This event will first check to ensure the user has entered
//				 a string value in the single line edit box, pass the string
//				 back to public function f_get_string.
// 		
// Log:
// 
// DATE		NAME				REVISION
//------		-------------------------------------------------------------
// Powersoft Corporation	INITIAL VERSION
//
/////////////////////////////////////////////////////////////////////////
if istr_parm.boolean_ismandatory then
	if isnull(sle_str.text) = true or (len(trim(sle_str.text)) = 0) then
		messagebox(parent.title, "Entry is required")
		return
	end if
end if

closewithreturn(parent, sle_str.text)
end event

