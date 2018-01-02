$PBExportHeader$mt_u_visualobject_calc.sru
$PBExportComments$replaces defunct objects u_tramos_base and u_base_sql
forward
global type mt_u_visualobject_calc from mt_u_visualobject
end type
end forward

global type mt_u_visualobject_calc from mt_u_visualobject
integer width = 1582
integer height = 992
string text = ""
event ue_childmodified pbm_custom75
event ue_retrieve pbm_custom74
end type
global mt_u_visualobject_calc mt_u_visualobject_calc

type variables
private integer ii_redraw
end variables

forward prototypes
public subroutine documentation ()
public function boolean uf_modified ()
public subroutine uf_redraw_off ()
public subroutine uf_redraw_on ()
public subroutine uf_resetflags ()
end prototypes

event ue_childmodified;Parent.TriggerEvent("ue_childmodified")
end event

public subroutine documentation ();/********************************************************************
   ObjectName: mt_u_visualobject_calc
	
	<OBJECT>
		Object Description
	</OBJECT>
   	<DESC>
		Contains functions previously located inside mt_u_visualobject_calc &
		u_base_sqlca.
	</DESC>
   	<USAGE>
		Calculation specific ancestor.
	</USAGE>
   	<ALSO>
		direct chilren include u_atobviac_calc_base_sqlca & u_calc_base_sqlca
	</ALSO>
    	Date   		Ref    	Author   		Comments
  		01/08/11 	D-CALC 	AGL027			First Version
********************************************************************/
end subroutine

public function boolean uf_modified ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : mt_u_visualobject_calc
  
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
mt_u_visualobject_calc uo_calc_tmp

// Browse through all datawindows, and update with accepttext

FOR li_count = 1 TO UpperBound(control[])
	CHOOSE Case control[li_count].TypeOf()
		CASE datawindow!
			dw_tmp = control[li_count]
			If dw_tmp.modifiedCount() > 0 Then Return(True)
		CASE UserObject!
			uo_calc_tmp = control[li_count]
			if uo_calc_tmp.uf_modified() Then Return(True)
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

public subroutine uf_resetflags ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : mt_u_visualobject_calc
  
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
mt_u_visualobject_calc uo_calc_tmp

FOR li_count = 1 TO UpperBound(control[])
	CHOOSE CASE control[li_count].TypeOf()
		CASE datawindow!
			dw_tmp = control[li_count]
			dw_tmp.resetUpdate()		
		CASE userobject!
			uo_calc_tmp = control[li_count]
			uo_calc_tmp.uf_resetflags()
	End CHOOSE
Next



end subroutine

on mt_u_visualobject_calc.create
call super::create
end on

on mt_u_visualobject_calc.destroy
call super::destroy
end on

