$PBExportHeader$u_base_sqlca.sru
$PBExportComments$SQLCA aware u_base
forward
global type u_base_sqlca from u_tramos_base
end type
end forward

global type u_base_sqlca from u_tramos_base
end type
global u_base_sqlca u_base_sqlca

on destructor;call u_tramos_base::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_base_sqlca
  
 Event	 : 

 Scope     : 

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 15-07-96

 Description : u_base_sqlca - standard visual object with update capabilities

 Arguments : {description/none}

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
15-07-96		1.0 			MI		Initial version
  
************************************************************************************/

end on

on u_base_sqlca.create
call u_tramos_base::create
end on

on u_base_sqlca.destroy
call u_tramos_base::destroy
end on

