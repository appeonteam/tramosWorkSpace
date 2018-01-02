$PBExportHeader$w_get_percentage.srw
$PBExportComments$This window lets the user enter a % to be added to the expense when it is transfered to the TC-Hire module.
forward
global type w_get_percentage from mt_w_response
end type
type em_percentage from editmask within w_get_percentage
end type
type cb_cancel from commandbutton within w_get_percentage
end type
type cb_no_percentage from commandbutton within w_get_percentage
end type
type cb_accept_percentage from commandbutton within w_get_percentage
end type
type st_6 from statictext within w_get_percentage
end type
type st_5 from statictext within w_get_percentage
end type
type st_4 from statictext within w_get_percentage
end type
type st_3 from statictext within w_get_percentage
end type
type st_2 from statictext within w_get_percentage
end type
type st_1 from statictext within w_get_percentage
end type
type gb_1 from groupbox within w_get_percentage
end type
end forward

global type w_get_percentage from mt_w_response
integer x = 672
integer y = 264
integer width = 1696
integer height = 1012
string title = "TC-Hire"
boolean controlmenu = false
long backcolor = 81324524
em_percentage em_percentage
cb_cancel cb_cancel
cb_no_percentage cb_no_percentage
cb_accept_percentage cb_accept_percentage
st_6 st_6
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_get_percentage w_get_percentage

event open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_get_percentage
  
 Object     : window
  
 Event	 :  open

 Scope     : local

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 19-03-96

 Description : This window lets the user enter a percentage to be added
onto the disbursement amount to be transfered to the T/C Hire Module. The
window defaults to 2,5 % and the user can accept this percentage, enter
another percentage and accept that, choose no percentage, or cancel the
settling of the disbursements.

 Arguments : none

 Returns   : percentage or -1 if cancelled or error occours

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-03-96		2.17			PBT		Initial Version
  
************************************************************************************/
/* set edit field to default of 2,5 percent */
em_percentage.text = "2.5"
/* highlight the percentage field to let the user overwrite the default value */
em_percentage.setfocus()
end event

on w_get_percentage.create
int iCurrent
call super::create
this.em_percentage=create em_percentage
this.cb_cancel=create cb_cancel
this.cb_no_percentage=create cb_no_percentage
this.cb_accept_percentage=create cb_accept_percentage
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_percentage
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.cb_no_percentage
this.Control[iCurrent+4]=this.cb_accept_percentage
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.st_5
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.gb_1
end on

on w_get_percentage.destroy
call super::destroy
destroy(this.em_percentage)
destroy(this.cb_cancel)
destroy(this.cb_no_percentage)
destroy(this.cb_accept_percentage)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

type em_percentage from editmask within w_get_percentage
integer x = 585
integer y = 656
integer width = 494
integer height = 96
integer taborder = 1
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16776960
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.00"
end type

type cb_cancel from commandbutton within w_get_percentage
integer x = 1115
integer y = 800
integer width = 539
integer height = 92
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Disbursement"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_get_percentage
  
 Object     : cb_cancel
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 19-03-96

 Description : This function closes the window and returns -1.

 Arguments : none

 Returns   : -1

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-03-96		2.0			PBT		Initial Version
  
************************************************************************************/
/* close window with -1 as return value */
closewithreturn( parent , -1 )
Return
end event

type cb_no_percentage from commandbutton within w_get_percentage
integer x = 567
integer y = 800
integer width = 539
integer height = 92
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "No Percentage"
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_get_percentage
  
 Object     : cb_no_percentage
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 19-03-96

 Description : This function closes the window and returns the 0 as the 
percentage.

 Arguments : none

 Returns   : 0

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-03-96		2.0			PBT		Initial Version
  
************************************************************************************/
/* close window with percentage 0 as return value */
closewithreturn( parent , 0 )
Return
end event

type cb_accept_percentage from commandbutton within w_get_percentage
integer x = 18
integer y = 800
integer width = 539
integer height = 92
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Accept Percentage"
boolean default = true
end type

event clicked;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_get_percentage
  
 Object     : cb_accept_percentage
  
 Event	 :  clicked

 Scope     : local

 ************************************************************************************

 Author    : Peter Bendix-Toft
   
 Date       : 19-03-96

 Description : This function closes the window and returns the entered 
percentage.

 Arguments : none

 Returns   : percentage

 Variables : 

 Other : 

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-03-96		2.0			PBT		Initial Version
  
************************************************************************************/
/* close window with percentage as return value */
closewithreturn( parent , double(em_percentage.text) )
Return
end event

type st_6 from statictext within w_get_percentage
integer x = 146
integer y = 544
integer width = 1385
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "or cancel the settling of these disbursements"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_get_percentage
integer x = 146
integer y = 448
integer width = 1385
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "percent and accept that, choose no percent"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_get_percentage
integer x = 146
integer y = 352
integer width = 1385
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "You can accept the percent, add your own"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_get_percentage
integer x = 146
integer y = 256
integer width = 1408
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "IN in the TC-Hire module. The default is set to 2.5 %."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_get_percentage
integer x = 146
integer y = 160
integer width = 1385
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "amounts that are to be transfered to the TC-Hire"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_get_percentage
integer x = 146
integer y = 64
integer width = 1385
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
boolean enabled = false
string text = "You can here add a percantage to the disbursement"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_get_percentage
integer x = 41
integer y = 16
integer width = 1591
integer height = 624
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 81324524
end type

