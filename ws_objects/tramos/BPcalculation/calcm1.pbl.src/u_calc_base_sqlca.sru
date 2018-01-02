$PBExportHeader$u_calc_base_sqlca.sru
$PBExportComments$This object is serving as a base for all other calc-objects
forward
global type u_calc_base_sqlca from mt_u_visualobject_calc
end type
end forward

global type u_calc_base_sqlca from mt_u_visualobject_calc
integer width = 1906
integer height = 1036
long backcolor = 81324524
end type
global u_calc_base_sqlca u_calc_base_sqlca

type variables
u_calcutil_nvo iuo_calc_nvo   // This object is global for all calculation windows

end variables

forward prototypes
public subroutine uf_activate ()
public function integer uf_deactivate ()
private subroutine documentation ()
end prototypes

public subroutine uf_activate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Generic routine for bringing this windows to the top position. This
 					functionality is used on all the "pages" in the calculation window,
					eg. u_calc_summary, u_calc_cargoes etc.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

This.BringToTop=True

end subroutine

public function integer uf_deactivate ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Generic routine for "deactivating" this windows. This
 					functionality is used on all the "pages" in the calculation window,
					eg. u_calc_summary, u_calc_cargoes etc.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(1)
end function

private subroutine documentation ();/********************************************************************
   ObjectName: The ancestor for calculation: summary, cargo, internary, compact, result
   <OBJECT> 	Object Description	</OBJECT>
   <USAGE>  	Object Usage	</USAGE>
   <ALSO>   	other Objects	</ALSO>
<HISTORY> 
   Date	CR-Ref	 Author	Comments
  05/08/10	?	     JSU042   Start logging
</HISTORY>    
********************************************************************/
end subroutine

on u_calc_base_sqlca.create
call super::create
end on

on u_calc_base_sqlca.destroy
call super::destroy
end on

