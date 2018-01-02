$PBExportHeader$u_bpdistance_base.sru
$PBExportComments$Base object for win-api specific distancetable interface
forward
global type u_bpdistance_base from mt_n_nonvisualobject
end type
end forward

type s_viapoint from structure
    string s_long
    string s_short
end type

shared variables
Integer si_bps_usage = -1
end variables

global type u_bpdistance_base from mt_n_nonvisualobject
end type
global u_bpdistance_base u_bpdistance_base

type variables
Protected String is_errortext  // Last error message
Protected String is_last_from_port, is_last_to_port  // last from and to port
Protected String is_bps_path // Path to BP distance table
Private Boolean ib_swapped // True if the route is swapped
Private Boolean ib_route_ok  // True if the route is OK
Private s_viapoint istr_viapoints[1 to 31] // Viapoint to fill name conversion array
end variables

forward prototypes
public function boolean uf_openbps ()
public subroutine uf_closebps ()
public function string uf_errortext ()
public function integer uf_distance (string as_from, string as_to)
public subroutine uf_abstract_error ()
protected subroutine uf_dllclose ()
protected function integer uf_dllgetdist (string as_from, string as_to)
public function boolean uf_dllgetswapflag ()
protected function boolean uf_dllopen ()
public function string uf_viapoint_long (integer ai_number)
public function string uf_getroute (boolean ab_return_as_code)
public subroutine uf_setpath (ref string as_path)
public function integer uf_dllgetroute (ref character ac_char[255])
end prototypes

public function boolean uf_openbps ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 

 Description : Opens the bp-distance DLL, and increments usage count if succes.

 Arguments : None

 Returns   : True if ok

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_result

If uf_dllopen() Then
	if si_bps_usage = -1 Then si_bps_usage = 0
	si_bps_usage ++

	lb_result = true
Else
	lb_result = false
End if

Return(lb_result)
end function

public subroutine uf_closebps ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Decrements usage count, and releases BP distance DLL when
 					usage count reaches 0.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


If si_bps_usage> 0 Then
	si_bps_usage --
	If si_bps_usage = 0 Then
		uf_dllclose()
	End if
End if
end subroutine

public function string uf_errortext ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns current errorstring (if any)

 Arguments : None

 Returns   : Error text as string  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(is_errortext)
end function

public function integer uf_distance (string as_from, string as_to);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 28-4-97

 Description : Returns BP distance between two points

 Arguments : From and TO point as string UNTAC coded

 Returns   : Distance  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Integer li_distance

// Check that usage count > 0 (= DLL is loaded) before calling
If si_bps_usage > 0 Then
	// Rememeber to and from port in instance Variables, and get 
	// distance from BP distance DLL
	is_last_from_port = as_from
	is_last_to_port = as_to
	li_distance = uf_DllGetDist(as_from, as_to)

	// Get swapped flags from BP distance DLL. The swapped flag is used 
	// get retrieving the route.
	ib_swapped = uf_DllGetSwapFlag()=true 
	If ib_swapped Then
		// Change errorcode if swapped (from port not found -> to port not found
		// and the other way around

		If li_distance = -4 Then 
			li_distance = -5 
		Elseif li_distance =-5 Then 
			li_distance =-4
		End if
	End if
Else
	li_distance = -6 
End if

if li_distance < 0 Then
		// If li_distance < 0, then some error has happend. Build the error string here
	
		CHOOSE CASE li_distance
			CASE -1
				is_errortext = "UNCTAD codes are iilegal"
			CASE -2
				// "Ports are the same" is not an error in our system 
				li_distance = 0
			CASE -3
				is_errortext = "BPSDISTS.DAT has not been opened"
			CASE -4
				is_errortext = "FROM port ("+as_from+") not found in distancetable"
			CASE -5
				is_errortext = "TO port ("+as_to+") not found in distancetable"
			CASE -6
				is_errortext = "Distance NVO not correctly loaded"
			CASE ELSE
				is_errortext = "Errorcode "+String(li_distance)
		END Choose
Else
	is_errortext = ""
End if

// Set instance OK flag if distance is valid
ib_route_ok = li_distance >= 0

Return(li_distance)


end function

public subroutine uf_abstract_error ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Displays abstract error box.

 Arguments : None

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


is_errortext = "Distance NVO not correctly loaded (abstract base function called)"
MessageBox("u_distance_base", is_errortext)
end subroutine

protected subroutine uf_dllclose ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Abstract function. This routine should be overrided in the descendant

 Arguments : 

 Returns   :   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


uf_abstract_error()
end subroutine

protected function integer uf_dllgetdist (string as_from, string as_to);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Abstract function. This routine should be overrided in the descendant

 Arguments : 

 Returns   :   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


uf_abstract_error()
Return 0
end function

public function boolean uf_dllgetswapflag ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Abstract function. This routine should be overrided in the descendant

 Arguments : 

 Returns   :   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


uf_abstract_error()
Return false
end function

protected function boolean uf_dllopen ();/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Abstract function. This routine should be overrided in the descendant

 Arguments : 

 Returns   :   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Return(False)
end function

public function string uf_viapoint_long (integer ai_number);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Converts a viapointcode into the full viapoint name

 Arguments : Viapoint code

 Returns   : Viapoint name  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


Return(istr_viapoints[ai_number].s_long)
end function

public function string uf_getroute (boolean ab_return_as_code);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Returns the route for distance already returned by uf_getdistance. If
 					ab_return_as_code is true then the route will be returned as Viapoint-
					codes, while false will return the viapoints as plaintext

 Arguments : ab_return_as_code as boolean

 Returns   : Viapointcodes as string or Viapoints as string

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

String ls_tmp
Char lstr_route[255], lstr_newstr[255]
Integer li_tmp, li_count

// If route is not valid, then return empty string "" as result. Otherwise
// call uf_dllgetroute to get the route as route-codes. li_tmp will contain
// the number of route points
ls_tmp = ""
If not ib_route_ok Then Return(ls_tmp)

li_tmp = uf_dllgetroute(lstr_route) 

// If the route is swapped (ib_swapped = true), then swap all elements
// in the returned routecode string
If ib_swapped Then
	For li_count = 1 To li_tmp
		lstr_newstr[li_count] = lstr_route[li_tmp - (li_count - 1)]
	Next
	
	For li_count = 1 To li_tmp
		lstr_route[li_count] = lstr_newstr[li_count]
	Next
End if
		
// If ab_return_as_code then exit now with the viapointcodes as string. Otherwise
// convert the viapoints into plain text, by using the route codes as look-up
// values into the istr_viapoints array
If ab_return_as_code Then
	Return lstr_route
Else
	For li_count = 1 To li_tmp
		If (li_count = li_tmp) And (li_tmp > 1) Then ls_tmp += " and "

		ls_tmp += istr_viapoints[Asc(lstr_route[li_count])].s_long
		If li_count < li_tmp - 1 then ls_tmp += ", "
	Next
End if

Return(ls_tmp)

end function

public subroutine uf_setpath (ref string as_path);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Sets the path for the BP distance table

 Arguments : as_path as string

 Returns   : None  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


is_bps_path = as_path
end subroutine

public function integer uf_dllgetroute (ref character ac_char[255]);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Abstract function. This routine should be overrided in the descendant

 Arguments : 

 Returns   :   

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/


uf_abstract_error()
Return 0
end function

event destructor;call super::destructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1996

 Description : Closes the BP distance DLL when usage count reaces 0

 Arguments : {description/none}

 Returns   : {description/none}  

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

If si_bps_usage > 0 Then
	si_bps_usage = 0 
	uf_dllclose()
End if
end event

event constructor;call super::constructor;/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Author    : MIS
   
 Date       : 1997

 Description : Contains initialization code for the bp_distance system. This routine 
 builds a list of portname & codes. The list is indexed by the route-string, returned 
 from the BP distance DLL. 

 SEP/OCT 1997: Formerly, the list started from 0, but this would give PB a problem, since
 char 0 also is used as string termination. Instead, the 32-bit DLL have been modified to
 return route-codes between 1 and 31. This change does not work with 16-bit, and for 
 16-bit the DllGetRoute should patch the routestring, so this also is in the range 1-31.

 Important: This change is not yet done for the 16-bit version

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

// Setup list of viapoints

istr_viapoints[1].s_long = "Cape Leeuwin" 
istr_viapoints[2].s_long = "Torres Strait"
istr_viapoints[3].s_long = "Cape Horn"
istr_viapoints[4].s_long = "Magellan Strait"
istr_viapoints[5].s_long = "Cape Pilar"
istr_viapoints[6].s_long = "Kiel Canal"
istr_viapoints[7].s_long = "Holtenau"
istr_viapoints[8].s_long = "Great Belt"
istr_viapoints[9].s_long = "Skaw"
istr_viapoints[10].s_long = "Port Said"
istr_viapoints[11].s_long = "Suez Canal"
istr_viapoints[12].s_long = "Ushant"
istr_viapoints[13].s_long = "Bishop Rock"
istr_viapoints[14].s_long = "Cape Wrath"
istr_viapoints[15].s_long = "Dover Strait"
istr_viapoints[16].s_long = "Gibraltar"
istr_viapoints[17].s_long = "Irish Sea"
istr_viapoints[18].s_long = "Longships"
istr_viapoints[19].s_long = "Corinth Canal East"
istr_viapoints[20].s_long = "Corinth Canal West"
istr_viapoints[21].s_long = "Lombok Strait"
istr_viapoints[22].s_long = "Sunda Strait"
istr_viapoints[23].s_long = "Fastnet Rock"
istr_viapoints[24].s_long = "Tuskar Rock"
istr_viapoints[25].s_long = "Christmas Island"
istr_viapoints[26].s_long = "Fiji Island"
istr_viapoints[27].s_long = "Panama Canal"
istr_viapoints[28].s_long = "Colon"
istr_viapoints[29].s_long = "Singapore Strait"
istr_viapoints[30].s_long = "Cape Finisterre"
istr_viapoints[31].s_long = "Cape Of Good Hope"
end event

on u_bpdistance_base.create
TriggerEvent( this, "constructor" )
end on

on u_bpdistance_base.destroy
TriggerEvent( this, "destructor" )
end on

