$PBExportHeader$mt_n_numericalfunctions.sru
forward
global type mt_n_numericalfunctions from mt_n_nonvisualobject
end type
end forward

global type mt_n_numericalfunctions from mt_n_nonvisualobject autoinstantiate
end type

forward prototypes
public subroutine documentation ()
public function boolean of_getbit (long al_decimal, unsignedinteger ai_bit)
public function long of_bitwiseand (long al_value1, long al_value2)
end prototypes

public subroutine documentation ();/********************************************************************
   n_object_name: mt_n_numericalfunctions
	
	<OBJECT>

	</OBJECT>
   <DESC>
		
	</DESC>
   	<USAGE>

	</USAGE>
   	<ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
  	01/06/15 	CR3419   AGL027			Created object.  Influenced by PFC.
	16/06/15		CR3907	AGL027			
********************************************************************/
end subroutine

public function boolean of_getbit (long al_decimal, unsignedinteger ai_bit);//////////////////////////////////////////////////////////////////////////////
//
//    Function:          of_GetBit
//
//    Access:             public
//
//    Arguments:
//    al_decimal        Decimal value whose on/off value needs to be determined (e.g. 47).
//    ai_bit            Position bit from right to left on the Decimal value.
//
//    Returns:         boolean
//                        True if the value is On.
//                        False if the value is Off.
//                        If any argument's value is NULL, function returns NULL.
//
//    Description:   Determines if the nth binary bit of a decimal number is 
//                        1 or 0.
//
//////////////////////////////////////////////////////////////////////////////
//
//    Revision History
//
//    Version
//    5.0   Initial version
// 5.0.03    Fixed problem when dealing with large numbers (>32k)
//                from "mod int" to "int mod"
//
//////////////////////////////////////////////////////////////////////////////
//
/*
* Open Source PowerBuilder Foundation Class Libraries
*
* Copyright (c) 2004-2005, All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted in accordance with the GNU Lesser General
* Public License Version 2.1, February 1999
*
* http://www.gnu.org/copyleft/lesser.html
*
* ====================================================================
*
* This software consists of voluntary contributions made by many
* individuals and was originally based on software copyright (c) 
* 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
* information on the Open Source PowerBuilder Foundation Class
* Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

Boolean lb_null

//Check parameters
If IsNull(al_decimal) or IsNull(ai_bit) then
    SetNull(lb_null)
    Return lb_null
End If

//Assumption ai_bit is the nth bit counting right to left with
//the leftmost bit being bit one.
//al_decimal is a binary number as a base 10 long.
If Int(Mod(al_decimal / (2 ^(ai_bit - 1)), 2)) > 0 Then
    Return True
End If

Return False
end function

public function long of_bitwiseand (long al_value1, long al_value2);//////////////////////////////////////////////////////////////////////////////
//
//    Function:          of_BitwiseAnd
//
//    Access:             public
//
//    Arguments:
//    al_Value1        The first value to be used in the operation. (e.g. 55)
//    al_Value2        The second value to be used in the operation. (e.g. 44)
//
//    Returns:         Long
//                        The result of the AND operation (e.g. 36)
//                        If either argument's value is NULL, function returns NULL.
//
//    Description:   Performs a bitwise AND operation (al_Value1 && al_Value2),
//                        which ANDs each bit of the values.
//                        (55 && 44) = 36
//
//////////////////////////////////////////////////////////////////////////////
//
//    Revision History
//
//    Version
//    5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
* Open Source PowerBuilder Foundation Class Libraries
*
* Copyright (c) 2004-2005, All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted in accordance with the GNU Lesser General
* Public License Version 2.1, February 1999
*
* http://www.gnu.org/copyleft/lesser.html
*
* ====================================================================
*
* This software consists of voluntary contributions made by many
* individuals and was originally based on software copyright (c) 
* 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
* information on the Open Source PowerBuilder Foundation Class
* Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

Integer        li_Cnt
Long            ll_Result
Boolean        lb_Value1[32], lb_Value2[32]

// Check for nulls
If IsNull(al_Value1) Or IsNull(al_Value2) Then
    SetNull(ll_Result)
    Return ll_Result
End If

// Get all bits for both values
For li_Cnt = 1 To 32
    lb_Value1[li_Cnt] = of_getbit(al_Value1, li_Cnt)
    lb_Value2[li_Cnt] = of_getbit(al_Value2, li_Cnt)
Next

// And them together
For li_Cnt = 1 To 32
    If lb_Value1[li_Cnt] And lb_Value2[li_Cnt] Then
        ll_Result = ll_Result + (2^(li_Cnt - 1))
    End If
Next

Return ll_Result
end function

on mt_n_numericalfunctions.create
call super::create
end on

on mt_n_numericalfunctions.destroy
call super::destroy
end on

