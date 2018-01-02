$PBExportHeader$w_select_window.srw
$PBExportComments$In this window the user chooses the group of receivers (brokers/charterers)and what they will receive( chrismas card/calender). This window is used before making the file for labels.
forward
global type w_select_window from mt_w_main
end type
type cb_close from commandbutton within w_select_window
end type
type cb_execute from commandbutton within w_select_window
end type
type rb_calender from radiobutton within w_select_window
end type
type rb_xcard from radiobutton within w_select_window
end type
type rb_charters from radiobutton within w_select_window
end type
type rb_brokers from radiobutton within w_select_window
end type
type gb_type from groupbox within w_select_window
end type
type gb_group from groupbox within w_select_window
end type
end forward

global type w_select_window from mt_w_main
integer x = 672
integer y = 264
integer width = 1170
integer height = 948
string title = "Make File"
long backcolor = 12632256
boolean center = false
cb_close cb_close
cb_execute cb_execute
rb_calender rb_calender
rb_xcard rb_xcard
rb_charters rb_charters
rb_brokers rb_brokers
gb_type gb_type
gb_group gb_group
end type
global w_select_window w_select_window

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   documentation
   <DESC></DESC>
   <RETURN></RETURN>
   <ACCESS></ACCESS>
   <ARGS>
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref		Author			Comments
   	21/08/14 CR3708		CCY018		F1 help application coverage - modified ancestor.
	01/09/14	CR3781		CCY018		The window title match with the text of a menu item
   </HISTORY>
********************************************************************/
end subroutine

on open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_select_window
  
 Object     : 
  
 Event	 : clicked

 Scope     : button

 ************************************************************************************

 Author    : Bettina Olsen
   
 Date       : 07-02-97

 Description :	Checks what the user has chosen in the two group boxes
					Calls the f_save_as_file function

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE				VERSION 		NAME			DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
07-02-97			1.0			BHO			INITIAL VERSION
************************************************************************************/

end on

on w_select_window.create
int iCurrent
call super::create
this.cb_close=create cb_close
this.cb_execute=create cb_execute
this.rb_calender=create rb_calender
this.rb_xcard=create rb_xcard
this.rb_charters=create rb_charters
this.rb_brokers=create rb_brokers
this.gb_type=create gb_type
this.gb_group=create gb_group
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_close
this.Control[iCurrent+2]=this.cb_execute
this.Control[iCurrent+3]=this.rb_calender
this.Control[iCurrent+4]=this.rb_xcard
this.Control[iCurrent+5]=this.rb_charters
this.Control[iCurrent+6]=this.rb_brokers
this.Control[iCurrent+7]=this.gb_type
this.Control[iCurrent+8]=this.gb_group
end on

on w_select_window.destroy
call super::destroy
destroy(this.cb_close)
destroy(this.cb_execute)
destroy(this.rb_calender)
destroy(this.rb_xcard)
destroy(this.rb_charters)
destroy(this.rb_brokers)
destroy(this.gb_type)
destroy(this.gb_group)
end on

type st_hidemenubar from mt_w_main`st_hidemenubar within w_select_window
end type

type cb_close from commandbutton within w_select_window
integer x = 526
integer y = 704
integer width = 274
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Close"
end type

on clicked;/*Close the window*/

close(parent)

end on

type cb_execute from commandbutton within w_select_window
integer x = 242
integer y = 704
integer width = 274
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Execute"
end type

on clicked;/*Checks what the user has chosen in the two group boxes*/
/*Calls the f_save_as_file function*/

if rb_brokers.checked = true and rb_calender.checked= true then 
		f_save_as_file('d_brokers_clndr',"Contact Persons - Brokers - Calendars")

elseif rb_brokers.checked = true and rb_xcard.checked=true then
		f_save_as_file('d_brokers_xmas',"Contact Persons - Brokers - ChristmasCard")

elseif rb_charters.checked = true and rb_calender.checked=true then
		f_save_as_file('d_charter_clndr',"Contact Persons - Charters - Calendars")

elseif rb_charters.checked = true and rb_xcard.checked=true then
		f_save_as_file('d_charter_xmas',"Contact Persons - Charters - Christmascard")
else 
		messagebox("Notice"," A gift type has to be chosen!")
		return
end if

/*Close this window when the function is called*/
close(parent)
end on

type rb_calender from radiobutton within w_select_window
integer x = 160
integer y = 568
integer width = 306
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Calendar"
end type

type rb_xcard from radiobutton within w_select_window
integer x = 160
integer y = 480
integer width = 443
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Christmascards"
end type

type rb_charters from radiobutton within w_select_window
integer x = 165
integer y = 292
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Charterers"
end type

type rb_brokers from radiobutton within w_select_window
integer x = 165
integer y = 200
integer width = 407
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Brokers"
end type

type gb_type from groupbox within w_select_window
integer x = 82
integer y = 404
integer width = 933
integer height = 252
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Type"
end type

type gb_group from groupbox within w_select_window
integer x = 87
integer y = 124
integer width = 933
integer height = 256
integer taborder = 10
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Contact Persons"
end type

