$PBExportHeader$u_sql_util.sru
$PBExportComments$Object for dynamic SQL changes
forward
global type u_sql_util from mt_n_nonvisualobject
end type
end forward

global type u_sql_util from mt_n_nonvisualobject
end type
global u_sql_util u_sql_util

type variables
Private Long il_start, il_end
end variables

forward prototypes
public function boolean uf_modify_insert (ref string as_data, string as_field, string as_value)
public function string uf_get_where (ref string as_sql, string as_field)
public function boolean uf_remove_where (ref string as_sql, string as_field)
public function boolean uf_modify_where (ref string as_sql, string as_field, string as_argument)
public function string uf_get_insert (ref string as_data, string as_field)
end prototypes

public function boolean uf_modify_insert (ref string as_data, string as_field, string as_value);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_sql_util

 Function : uf_modify_insert
  
 Event	 : 

 Scope     : Object Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 13-9-96

 Description : Modifies an INSERT statement, replaces as_field value with as_value in the ref string as_data

 Arguments : SQL string as_data, Field as_field, value as_value

 Returns   Boolean if found and exchanged

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_break_sw
Integer li_start, li_end, li_tmp, li_count, li_field_pos

as_field = Upper(as_field)
li_start = Pos(as_data, "(") + 1
If li_start = 0 Then Return(False) // Return error if no start parathes found

DO
	li_count ++

	li_end = Pos(as_data, ",", li_start)
	li_tmp = Pos(as_data, ")", li_start)

	If (li_tmp < li_end) Or (li_end = 0)  Then 
		li_end = li_tmp // Check for last 
		lb_break_sw = True
	End if

	If (Trim(Mid(as_data, li_start, li_end - li_start ) ) = as_field) And (li_field_pos = 0) Then
		li_field_pos = li_count
	End if

	li_start = li_end + 1

LOOP UNTIL lb_break_sw

If li_field_pos = 0 Then Return(false)    // Return error if Field name not found

// Now find the corrosponding value

li_start = Pos(as_data, "(", li_start) + 1
If li_start = 0 Then Return(false)
li_count = 0
lb_break_sw = false

DO
	li_count ++
	
	li_end = Pos(as_data, ",", li_start)

	li_tmp = Pos(as_data, "'", li_start) 
	If (li_tmp < li_end) And (li_tmp >0)  Then
		// Ups, we have a '     ' string, find last ', and calculate from there
				
		li_tmp = Pos(as_data, "'", li_tmp + 1)
		li_end = Pos(as_data, ",", li_tmp)
		li_tmp = Pos(as_data, ")", li_tmp)
	Else
		li_tmp = Pos(as_data, ")", li_start)
	End if

	If (li_tmp < li_end) Or (li_end = 0)  Then 
		li_end = li_tmp // Check for last 
		lb_break_sw = True
	End if

	If li_count = li_field_pos Then
		// This is our token, replace value

		as_data = Left(as_data, li_start - 1) + as_value + Mid(as_data, li_end)
		li_field_pos = 0
		Exit
	End if
	
	li_start = li_end + 1

LOOP UNTIL lb_break_sw

Return(li_field_pos = 0)

end function

public function string uf_get_where (ref string as_sql, string as_field);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_sql_util
  
 function : uf_get_where

 Event	 : 

 Scope     : Object Global

 ************************************************************************************

 Author    : MIS
   
 Date       : 

 Description : Returns the Where argument for the specified field, or blank if field not found
			NOTE: This version does not support strings
 Arguments : SQL as Ref String, as_field as string

 Returns   : {description/none}  

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
14-9-96		3			MI		Initial version - note this version does not support string arguments  
************************************************************************************/

Long li_start, li_end

as_field += " = "

li_start = Pos(as_sql, as_field )
If li_start < 1 Then Return("")

li_end = Pos(as_sql, ' ', li_start + Len(as_field) ) 
If li_end < 1 Then Return("")

li_start += len(as_field)
li_end -= li_start
Return(Mid(as_sql, li_start , li_end))


end function

public function boolean uf_remove_where (ref string as_sql, string as_field);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_sql_util
  
 function : uf_remove_where

 Event	 : 

 Scope     : Object Global

 ************************************************************************************

 Author    : MIS
   
 Date       : 

 Description : Removes the argument the specified field
			NOTE: This version does not support strings
 
Arguments : SQL as Ref String, as_field as string

 Returns   : True if ok

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
14-9-96		3			MI		Initial version - note this version does not support string arguments  
************************************************************************************/

Integer li_start, li_end

as_field += " = "

li_start = Pos(as_sql, as_field )
If li_start < 1 Then Return(false)

li_end = Pos(as_sql, " ", li_start + Len(as_field) ) 
If li_end < 1 Then Return(false)

If Pos(as_sql, "AND ", li_end) - li_end = 1 Then li_end += 4

as_sql = Left(as_sql, li_start -1 )+Mid(as_sql, li_end)
Return(True)


end function

public function boolean uf_modify_where (ref string as_sql, string as_field, string as_argument);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_sql_util
  
 Function : uf_modify_where

 Event	 : 

 Scope     : Object Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 13-9-96

 Description : Modifies the SQL script for the where caluse

 Arguments : SQL script as Ref String, 
		field (column) as string
		new argument as string

 Returns   : True if ok

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : This version does not work on strings

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
13-9-96		3			MI		This version does not work on strings  
************************************************************************************/

Integer li_start, li_end

as_field += " = "

li_start = Pos(as_sql, as_field )
If li_start < 1 Then Return(false)

li_end = Pos(as_sql, ' ', li_start +  Len(as_field)) 
If li_end < 1 Then Return(false)

as_sql = Left(as_sql, li_start - 1 ) + as_argument + Mid(as_sql, li_end)
Return(true)


end function

public function string uf_get_insert (ref string as_data, string as_field);/************************************************************************************

 Arthur Andersen PowerBuilder Development

 Window  : 
  
 Object     : u_sql_util

 Function : uf_get_insert
  
 Event	 : 

 Scope     : Object Global

 ************************************************************************************

 Author    : Martin Israelsen
   
 Date       : 13-9-96

 Description : Returns the insert value for as_field in the ref string as_data

 Arguments : SQL string as_data, Field as_field

 Returns     : String containing data otherwise blank

 Variables : {important variables - usually only used in Open-event scriptcode}

 Other : {other comments}

*************************************************************************************
Development Log 
DATE		VERSION 	NAME	DESCRIPTION
-------- 		------- 		----- 		-------------------------------------
  
************************************************************************************/

Boolean lb_break_sw
Integer li_start, li_end, li_tmp, li_count, li_field_pos

as_field = Upper(as_field)
li_start = Pos(as_data, "(") + 1
If li_start = 0 Then Return("") // Return error if no start parathes found

DO
	li_count ++

	li_end = Pos(as_data, ",", li_start)
	li_tmp = Pos(as_data, ")", li_start)

	If (li_tmp < li_end) Or (li_end = 0)  Then 
		li_end = li_tmp // Check for last 
		lb_break_sw = True
	End if

	If (Trim(Mid(as_data, li_start, li_end - li_start ) ) = as_field) And (li_field_pos = 0) Then
		li_field_pos = li_count
	End if

	li_start = li_end + 1

LOOP UNTIL lb_break_sw

If li_field_pos = 0 Then Return("")    // Return error if Field name not found

// Now find the corrosponding value

li_start = Pos(as_data, "(", li_start) + 1
If li_start = 0 Then Return("")
li_count = 0
lb_break_sw = false

DO
	li_count ++
	
	li_end = Pos(as_data, ",", li_start)

	li_tmp = Pos(as_data, "'", li_start) 
	If (li_tmp < li_end) And (li_tmp >0)  Then
		// Ups, we have a '     ' string, find last ', and calculate from there
				
		li_tmp = Pos(as_data, "'", li_tmp + 1)
		li_end = Pos(as_data, ",", li_tmp)
		li_tmp = Pos(as_data, ")", li_tmp)
	Else
		li_tmp = Pos(as_data, ")", li_start)
	End if

	If (li_tmp < li_end) Or (li_end = 0)  Then 
		li_end = li_tmp // Check for last 
		lb_break_sw = True
	End if

	If li_count = li_field_pos Then
		// This is our token, replace value
		
		Return(Mid(as_data, li_start , li_end - li_start))
	End if
	
	li_start = li_end + 1

LOOP UNTIL lb_break_sw

Return("")  // Return error 

end function

on u_sql_util.create
TriggerEvent( this, "constructor" )
end on

on u_sql_util.destroy
TriggerEvent( this, "destructor" )
end on

