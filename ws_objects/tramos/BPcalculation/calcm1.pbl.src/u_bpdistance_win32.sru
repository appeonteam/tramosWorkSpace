$PBExportHeader$u_bpdistance_win32.sru
$PBExportComments$distancetable routines for Win32 (95 + NT)
forward
global type u_bpdistance_win32 from u_bpdistance_base
end type
end forward

shared variables

end variables

global type u_bpdistance_win32 from u_bpdistance_base
end type
global u_bpdistance_win32 u_bpdistance_win32

type prototypes
Function Int DllOpenBpsTable(String Path) library 'BPSDISTS.DLL' alias for "DllOpenBpsTable;Ansi"
Function Int DllGetDist(Ref String fromport, Ref String toport) library 'BPSDISTS.DLL' alias for "DllGetDist;Ansi"
Subroutine DllCloseBpsTable() library 'BPSDISTS.DLL'
Function Int DllGetSwapFlag() library 'BPSDISTS.DLL'
Function String DllGetRoutePB() library 'BPSDISTS.DLL' alias for "DllGetRoutePB;Ansi"
Function Int DllGetNumRoutePoints() library 'BPSDISTS.DLL'
end prototypes

forward prototypes
protected subroutine uf_dllclose ()
public function integer uf_dllgetdist (string as_from, string as_to)
protected function boolean uf_dllgetswapflag ()
protected function integer uf_dllgetroute (ref character ac_char[])
protected function boolean uf_dllopen ()
end prototypes

protected subroutine uf_dllclose ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : CLoses the DLL

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

DllCloseBpsTable()

end subroutine

public function integer uf_dllgetdist (string as_from, string as_to);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the distance from the 32-bit DLL

 Arguments : From port, to port as string

 Returns   : Distance as integer

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(dllgetDist(as_from,as_to))

end function

protected function boolean uf_dllgetswapflag ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the swapflag from the 32-bit DLL

 Arguments : None

 Returns   : True if swapped

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Return(dllgetswapflag()=1)
end function

protected function integer uf_dllgetroute (ref character ac_char[]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the route from the 32-bit DLL

 Arguments : None

 Returns   : viapoints as string

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

ac_char = DllGetRoutePB()
Return DllGetNumRoutePoints()

end function

protected function boolean uf_dllopen ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Opens the 16-bit DLL.

 Arguments : None

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/
string ls_path
Integer li_errorcode
long ll_startPosition

ls_path = uo_global.gs_bp_path
/* Replace %USERNAME% with users userid if in string */
ll_startPosition = pos(Upper(ls_path), upper("%USERNAME%"))
if ll_startPosition > 0 then ls_path = replace(ls_path, ll_startPosition, 10, uo_global.getWindowsuserid( ))

li_errorcode = DllOpenBpsTable(ls_path)

If li_errorcode <> 1 Then
	CHOOSE CASE li_errorcode 
		CASE -1
			is_errortext = "Table allready open"
		CASE -2
			is_errortext = "Path to long"
		CASE -3
			is_errortext = "Unable to find tablefile"
		CASE -4
			is_errortext= "Table is corrupt"
		CASE ELSE
			is_errortext = "Unknown error ("+String(li_errorcode)+")"
	END CHOOSE

	Return(False)
End if

Return(true)
end function

on u_bpdistance_win32.create
call super::create
end on

on u_bpdistance_win32.destroy
call super::destroy
end on

