$PBExportHeader$u_nvo_base.sru
$PBExportComments$The base object for NVO's
forward
global type u_nvo_base from nonvisualobject
end type
end forward

global type u_nvo_base from nonvisualobject
end type
global u_nvo_base u_nvo_base

on constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_nvo_base
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 18-7-96

 Description : Standard nvo object

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
19-7-96		1.0			MI		Initial version
  
************************************************************************************/

end on

on u_nvo_base.create
TriggerEvent( this, "constructor" )
end on

on u_nvo_base.destroy
TriggerEvent( this, "destructor" )
end on

