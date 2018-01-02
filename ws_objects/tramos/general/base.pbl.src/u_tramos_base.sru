$PBExportHeader$u_tramos_base.sru
$PBExportComments$The base object for visual objects
forward
global type u_tramos_base from userobject
end type
end forward

global type u_tramos_base from userobject
integer width = 1582
integer height = 992
boolean border = true
long backcolor = 12632256
event ue_childmodified pbm_custom75
event ue_retrieve pbm_custom74
end type
global u_tramos_base u_tramos_base

type variables
Private integer ii_redraw
end variables

forward prototypes
public subroutine uf_resetflags ()
public function boolean uf_modified ()
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
end prototypes

on ue_childmodified;Parent.TriggerEvent("ue_childmodified")
end on

public subroutine uf_resetflags ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_tramos_base
  
 Event	 : 

 Function : uf_resetflags

 Scope     : 

 ************************************************************************************

 Author    : Jeannette Holland
   
 Date       : 01-07-96

 Description : Resets updateflags for all datawindows

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-07-96		1.0 			MI		Initial version
  
************************************************************************************/
Long li_count
Datawindow dw_tmp
u_tramos_base uo_base_tmp

FOR li_count = 1 TO UpperBound(control[])
	CHOOSE CASE control[li_count].TypeOf()
		CASE datawindow!
			dw_tmp = control[li_count]
			dw_tmp.resetUpdate()		
		CASE userobject!
			uo_base_tmp = control[li_count]
			uo_base_tmp.uf_resetflags()
	End CHOOSE
Next



end subroutine

public function boolean uf_modified ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_tramos_base
  
 Event	 : 

 Function  : uf_modified

 Scope     : 

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 16-07-96

 Description : Returns true if any datawindows (or userobjects) are changed (modified, deleted)

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
16-07-96		1.0 			MI		Initial version
  
************************************************************************************/


Long li_count
Datawindow dw_tmp
u_tramos_base uo_base_tmp

// Browse through all datawindows, and update with accepttext

FOR li_count = 1 TO UpperBound(control[])
	CHOOSE Case control[li_count].TypeOf()
		CASE datawindow!
			dw_tmp = control[li_count]
			If dw_tmp.modifiedCount() > 0 Then Return(True)
		CASE UserObject!
			uo_base_tmp = control[li_count]
			if uo_base_tmp.uf_modified() Then Return(True)
	End CHOOSE
Next

Return(False)
end function

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

on constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_tramos_base
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 15-07-96

 Description : Default visual userobject

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		Initial version
16-07-96		1.01			MI		Added uf_insert, uf_resetflags								  
************************************************************************************/

end on

on u_tramos_base.create
end on

on u_tramos_base.destroy
end on

