$PBExportHeader$w_calc_saveas.srw
$PBExportComments$Calculation "save as" window
forward
global type w_calc_saveas from mt_w_response_calc
end type
type rb_calcule from uo_rb_base within w_calc_saveas
end type
type rb_template from uo_rb_base within w_calc_saveas
end type
type sle_description from uo_sle_base within w_calc_saveas
end type
type st_1 from statictext within w_calc_saveas
end type
type st_2 from statictext within w_calc_saveas
end type
type cb_cancel from uo_cb_base within w_calc_saveas
end type
type cb_save from uo_cb_base within w_calc_saveas
end type
end forward

global type w_calc_saveas from mt_w_response_calc
integer width = 1403
integer height = 444
string title = "Save As"
boolean controlmenu = false
long backcolor = 32304364
rb_calcule rb_calcule
rb_template rb_template
sle_description sle_description
st_1 st_1
st_2 st_2
cb_cancel cb_cancel
cb_save cb_save
end type
global w_calc_saveas w_calc_saveas

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
	w_calc_saveas
	
	<OBJECT>
	</OBJECT>
	<DESC>
	</DESC>
  	<USAGE>
	</USAGE>
	<ALSO>
	</ALSO>
	<HISTORY>
   	Date       	CR-Ref		Author		Comments
     	08/08/2014 	CR3708   	AGL027		F1 help application coverage - corrected ancestor
		28/08/2014	CR3781		CCY018		The window title match with the text of a menu item		
	</HISTORY>
********************************************************************/
end subroutine

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Receives the current calculation description into the
 					SLE_DESCRIPTION field

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Set the calculation description into SLE_DESCRIPTION
sle_description.text = Message.StringParm
// and select the whole text
sle_description.selecttext(1,Len(sle_description.text))
end event

on w_calc_saveas.create
int iCurrent
call super::create
this.rb_calcule=create rb_calcule
this.rb_template=create rb_template
this.sle_description=create sle_description
this.st_1=create st_1
this.st_2=create st_2
this.cb_cancel=create cb_cancel
this.cb_save=create cb_save
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_calcule
this.Control[iCurrent+2]=this.rb_template
this.Control[iCurrent+3]=this.sle_description
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_save
end on

on w_calc_saveas.destroy
call super::destroy
destroy(this.rb_calcule)
destroy(this.rb_template)
destroy(this.sle_description)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_cancel)
destroy(this.cb_save)
end on

type st_hidemenubar from mt_w_response_calc`st_hidemenubar within w_calc_saveas
end type

type rb_calcule from uo_rb_base within w_calc_saveas
integer x = 283
integer y = 148
integer width = 261
integer taborder = 2
long backcolor = 32304364
string text = "C&alcule"
boolean checked = true
end type

type rb_template from uo_rb_base within w_calc_saveas
integer x = 576
integer y = 148
integer width = 297
integer taborder = 3
long backcolor = 32304364
string text = "&Template"
end type

type sle_description from uo_sle_base within w_calc_saveas
integer x = 283
integer y = 40
integer width = 1079
integer height = 80
string text = "<enter description here>"
integer accelerator = 100
end type

type st_1 from statictext within w_calc_saveas
integer x = 27
integer y = 48
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "&Description"
boolean focusrectangle = false
end type

type st_2 from statictext within w_calc_saveas
integer x = 27
integer y = 152
integer width = 247
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 32304364
boolean enabled = false
string text = "Status"
boolean focusrectangle = false
end type

type cb_cancel from uo_cb_base within w_calc_saveas
integer x = 1019
integer y = 236
integer width = 343
integer height = 100
integer taborder = 5
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the W_CALC_SAVEAS without returning anything

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(Parent)
end event

type cb_save from uo_cb_base within w_calc_saveas
integer x = 658
integer y = 236
integer width = 343
integer height = 100
integer taborder = 4
string text = "&Save"
boolean default = true
end type

event clicked;call super::clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the W_CALC_SAVEAS, and returns description and calculationtype
 					in a LSTR_CALC_SAVEAS structure

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

s_calc_saveas lstr_calc_saveas 

lstr_calc_saveas.s_description=sle_description.text
If rb_calcule.checked then lstr_calc_saveas.i_calctype = 2 else lstr_calc_saveas.i_calctype = 1

CloseWithReturn(Parent,lstr_calc_saveas)
Return
end event

