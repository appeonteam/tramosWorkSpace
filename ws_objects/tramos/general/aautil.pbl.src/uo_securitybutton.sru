$PBExportHeader$uo_securitybutton.sru
$PBExportComments$Default commandbutton w/ acces level
forward
global type uo_securitybutton from commandbutton
end type
end forward

global type uo_securitybutton from commandbutton
integer width = 210
integer height = 76
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "none"
event paint pbm_enable
event ue_setlevel pbm_custom70
end type
global uo_securitybutton uo_securitybutton

type variables
integer ii_access_demand = 1
integer ii_access_level
end variables

on paint;If (enabled) and (ii_access_level < ii_access_demand) Then
	Enabled = False
end if

end on

on ue_setlevel;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_securitybutton
  
 Event	 : ue_setlevel

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : Changes the demand level for this button.

 Arguments : ii_access_demand as Longparm

 Returns   : None

 Variables :   

 Other : This event is called by set_security_level, but can also be set individually

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/

ii_access_demand = Message.LongParm
if ii_access_level < ii_access_demand then enabled = false else enabled = true
end on

event constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : uo_securitybutton
  
 Event	 : Constructor

 Scope     : Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 1/1-96

 Description : The uo_securitybutton is a general control for buttons, which needs to be disabled/enabled relative
	to the users acces level. All securitybuttons in one window can be set using set_security_level.

 Arguments :None

 Returns   : None

 Variables :  ii_acces_level (the users level), and ii_acces_demand (what level this button demands)

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/


ii_access_level = uo_global.ii_access_level
if ii_access_level = -2 then ii_access_level = 1 //external_partner = user
if ii_access_level < ii_access_demand then enabled = false else enabled = true

end event

on uo_securitybutton.create
end on

on uo_securitybutton.destroy
end on

