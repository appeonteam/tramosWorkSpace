$PBExportHeader$mt_w_response_calc.srw
$PBExportComments$Standard object for calculation module response windows
forward
global type mt_w_response_calc from mt_w_response
end type
end forward

global type mt_w_response_calc from mt_w_response
string icon = "images\CALC.ICO"
event ue_closeitem pbm_custom54
event ue_global_change pbm_custom40
event ue_refresh pbm_custom41
event ue_retrieve pbm_custom01
event ue_ballastvoyageitem pbm_custom64
event ue_consumptionitem pbm_custom60
event ue_copyitem pbm_custom63
event ue_cpitem pbm_custom55
event ue_datachanged pbm_custom58
event ue_deleteitem pbm_custom61
event ue_fixtureitem pbm_custom56
event ue_moveitem pbm_custom62
event ue_newitem pbm_custom51
event ue_openitem pbm_custom52
event ue_printitem pbm_custom59
event ue_saveasitem pbm_custom53
event ue_saveitem pbm_custom50
event ue_statusitem pbm_custom57
event ue_unlockcalculationitem pbm_custom66
event ue_wizarditem pbm_custom65
end type
global mt_w_response_calc mt_w_response_calc

type variables
Private Integer ii_redraw
end variables

forward prototypes
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine documentation ()
end prototypes

event ue_closeitem;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Handles the UE_CLOSEITEM send from the mainmenu, by closing the 
 					window

 Arguments : None

 Returns   : None

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Close(This)
end event

public subroutine uf_redraw_off ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 

 Function  : uf_redraw_off

 Object     : 
  
 Event	 :  

 Scope     : Object

 ************************************************************************************

 Author    : Martin "Far" Israelsen
   
 Date       : 30/7-96

 Description : Enables nested redraw on/off commands, which otherwise is a problem
		in powerbuilder. This function turns redraw off

 Arguments : none

 Returns   : none

 Variables :  None

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/
ii_redraw++

this.Setredraw(false)


end subroutine

public subroutine uf_redraw_on ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 

 Function : uf_redraw_on
  
 Object     : 
  
 Event	 :  

 Scope     : Object

 ************************************************************************************

 Author    : Martin "Far" Israelsen
   
 Date       : 30/7-96

 Description : Enables nested redraw on/off commands, which otherwise is a problem
		in powerbuilder. This function turns redraw on

 Arguments : none

 Returns   : none

 Variables :  None

 Other : Will display an error messagebox if nested value is out-of-sync

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
1/1-96		1.0			MI		Initial version
  
************************************************************************************/


If ii_redraw > 0 Then 
   ii_redraw --
Else
	MessageBox("Warning", "redraw setting below zero")
End if

If ii_redraw = 0 Then
	this.Setredraw(true)
End if
end subroutine

public subroutine documentation ();/********************************************************************
   mt_w_response_calc
	
	<OBJECT>

	</OBJECT>
   <DESC>
		Standard object for calculation module response windows
	</DESC>
  	<USAGE>

	</USAGE>
  	<ALSO>
		
	</ALSO>
	<HISTORY>
		Date    		Ref   	Author		Comments
		06/08/14		CR3708	AGL027		F1 help application coverage - new ancestor based on 'mt_w_sheet_calc'
		12/09/14		CR3773	XSZ004		Change icon absolute path to reference path
	</HISTORY>
*****************************************************************/
end subroutine

on mt_w_response_calc.create
call super::create
end on

on mt_w_response_calc.destroy
call super::destroy
end on

event open;call super::open;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : w_base
  
 Object     : 
  
 Event	 : Open

 Scope     : Local/Global

 ************************************************************************************

 Author    : Martin israelsen
   
 Date       : 01-07-96

 Description : {Short description}

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		Initial version
15-07-96		1.0			MI		Added This.Move(0,0)
								Default ue_retrieve event  
20-8-96		1.0			MI		Added 3D look and auto-centering of response windows
25-8-96		1.0			MI		Added check for low GDI memory
************************************************************************************/
if This.WindowType = Response! then 
	f_center_window(this)
Else
	This.Move(0,0)
End if
end event

event activate;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : Martin Israelsen
   
 Date       : 15-07-96

 Description : Default activate event for all calculation windows. Shifts the menu
 					to the calculation menu

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		Initial version
25-07-96					MI		Added Close(This) on ue_closeitem event  
************************************************************************************/

// Check if the current menu is the calculation menu, if not shift to the
// calculation menu
If w_tramos_main.MenuName <> "m_calcmain" Then w_tramos_main.ChangeMenu(m_calcmain)

end event

type st_hidemenubar from mt_w_response`st_hidemenubar within mt_w_response_calc
end type

