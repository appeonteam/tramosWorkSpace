$PBExportHeader$w_base.srw
$PBExportComments$The Base window for windows
forward
global type w_base from mt_w_response
end type
end forward

global type w_base from mt_w_response
integer x = 672
integer y = 264
integer width = 1961
integer height = 992
string title = "(Default Untitled)"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 80269524
event ue_retrieve pbm_custom01
event ue_global_change pbm_custom40
event ue_refresh pbm_custom41
end type
global w_base w_base

type prototypes
//get free system resources
Function uint Getfreesystemresources (uint resource) Library "user.exe"

end prototypes

type variables
Private Integer ii_redraw
end variables

forward prototypes
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine documentation ()
end prototypes

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
   w_base
	
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

event open;/************************************************************************************

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

on w_base.create
call super::create
end on

on w_base.destroy
call super::destroy
end on

