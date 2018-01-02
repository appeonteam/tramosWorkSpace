$PBExportHeader$mt_n_stringfunctions.sru
forward
global type mt_n_stringfunctions from mt_n_nonvisualobject
end type
end forward

global type mt_n_stringfunctions from mt_n_nonvisualobject autoinstantiate
end type

forward prototypes
public subroutine documentation ()
public function integer of_replaceinstring (ref string ls_string1, string ls_string2)
public function integer of_replacectrlchars (ref string as_string)
public function string of_replace (string as_text, string as_tofind, string as_replaceby)
public function string of_htmlencode (string as_text)
public function integer of_getcommandlineparm (string as_commandline, string as_identifier, ref string as_result, boolean ab_required)
public function long of_split (ref string as_array[], string as_string, string as_separator)
public function integer of_arraytostring (string as_source[], string as_delimiter, boolean ab_processempty, ref string as_ref_string)
public function integer of_arraytostring (string as_source[], string as_delimiter, ref string as_ref_string)
public function integer of_parsetoarray (string as_source, string as_delimiter, ref integer ai_array[])
public function integer of_parsetoarray (string as_source, string as_delimiter, ref string as_array[])
public function string of_replaceall (string as_replace_source, string as_replace_what, string as_replace_with, boolean ab_ignorecase)
public function string of_is_urloremailaddress (ref string as_data)
public function string of_get_token (ref string source, string separator)
public function string of_firstupper (string as_string)
end prototypes

public subroutine documentation ();/********************************************************************
   ObjectName: mt_n_generalfunctions
	
	<OBJECT>
		General Helper Functions
	</OBJECT>
   	<DESC>
		A place to store helpful functions that may not be contained in the standard pb environment
	</DESC>
   	<USAGE>
		Object Usage.
	</USAGE>
   	<ALSO>
		otherobjs
	</ALSO>
    	Date   	Ref 	   	Author   		Comments
  	00/00/07 	?      		AGL				First Version
	09/05-11		?				AGL				Added function to strip control chars out of string.  
	27/05-11						CONASW	 		Added HTML Encoding function and general Replace function
	07/07/14 	CR3708		AGL027			Replace tab ctrl-char with space inside of_replacectrlchars()
	17/10/14    		      KSH092			Added function of_is_urloremailaddress( /*string as_data */)
	03/06/16		CR4276		AGL027			Expand on command line parameter handling.
	27/10/16		CR4501		HHX010			Add function of_get_token.
	27/03/17		CR4572		XSZ004			Move function f_firstupper to this object.	
********************************************************************/
end subroutine

public function integer of_replaceinstring (ref string ls_string1, string ls_string2);/********************************************************************
   FunctionName
<DESC>   
	Description
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public/Protected/Private
</ACCESS>
<ARGS>   
	as_Arg1: Description
	as_Arg2: Description
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

long ll_startpos=1

/* remove all occurances of string */

ll_startpos = Pos(ls_string1, ls_string2, ll_startpos)
if ll_startpos > 0 then
	do while ll_startpos > 0
		 ls_string1 = Replace(ls_string1, ll_startpos, Len(ls_string2), "")
		 ll_startpos = Pos(ls_string1, ls_string2, ll_startpos)
	loop
	return c#return.Success	
else
	return c#return.Failure	
end if	




end function

public function integer of_replacectrlchars (ref string as_string);/********************************************************************
   of_replacectrlchars()
	
<DESC>   
	Used to filter/replace characters that may appear in string due to client application.
</DESC>
<RETURN>
	Integer:
		<LI> 1, X ok
		<LI> -1, X failed
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_string: String to be converted
</ARGS>
<USAGE>
	Replace original string with newly formatted.  This should be obsolete once utf-8 db is applied.
</USAGE>
********************************************************************/

integer li_charcode
string	ls_replacementchar=""
long ll_length, ll_start, ll_charcode
ll_length = len(as_string)

for ll_start= 1  to ll_length
	li_charcode = asc(Mid(as_string,ll_start))
	if (li_charcode > 256) then
		choose case li_charcode
			case 8211 /* long dash */
				ls_replacementchar="-"
			case 9 /* horizontal TAB */
				ls_replacementchar=" "	
			case is > 256
				ls_replacementchar=" "
			case else 
				continue
		end choose
		as_string = replace(as_string, ll_start, 1, ls_replacementchar)
	end if
next

return c#return.Success
end function

public function string of_replace (string as_text, string as_tofind, string as_replaceby);/********************************************************************
   of_Replace
<DESC>   
	Replaces all occurrences of a string by another string within a given string
</DESC>
<RETURN>
	String: String with replaced characters
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_Text: String to search in
	as_ToFind: String to search for
	as_ReplaceBy: String to replace with
</ARGS>
<USAGE>
	Call function with the required parameters and get string back.
</USAGE>
********************************************************************/

long ll_Pos = 1

ll_Pos = Pos(as_Text, as_ToFind, ll_Pos)

Do While ll_Pos > 0
	as_Text = Replace(as_Text, ll_Pos, Len(as_ToFind), as_ReplaceBy)
	ll_Pos += Len(as_ReplaceBy)
	ll_Pos = Pos(as_Text, as_ToFind, ll_Pos)
Loop

Return as_Text



end function

public function string of_htmlencode (string as_text);/********************************************************************
   of_htmlencode
<DESC>   
	HTML Encodes a given string and returns it
</DESC>
<RETURN>
	String: The encoded string
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_Text: The string to be encoded
</ARGS>
<USAGE>
	Pass string to be encoded and get back encoded string. Original string is not modified.
</USAGE>
********************************************************************/

as_Text = of_replace(as_Text, "&", "&amp;")
as_Text = of_replace(as_Text, "<", "&lt;")
as_Text = of_replace(as_Text, ">", "&gt;")
as_Text = of_replace(as_Text, '"', "&quot;")
as_Text = of_replace(as_Text, CharA(13), "<br/>")
as_Text = of_replace(as_Text, CharA(10), "")

Return as_Text

end function

public function integer of_getcommandlineparm (string as_commandline, string as_identifier, ref string as_result, boolean ab_required);/********************************************************************
   of_getcommandlineparm()
	
<DESC>   
	get parm string result from commandline
</DESC>
<RETURN>
	String:
		<LI> result
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_commandline: the complete string received from the command line
	as_identifier: the parameter name including the / and the : ie  '/name:'
	ab_required: if set to True, function returns error to calling process if it can not find the identifier/value.
</ARGS>
<USAGE>
	From the application object, or a saved copy.  load the values in as necessary:
	
	<codesample>	
	commandline = "interfacemanager /server:scrbtradkesp002 /db:TEST_TRAMOS /debug:on"
	if of_getcommandlineparm(commandline,"/server:", gs_servername, true) = c#return.Failure then
		gs_servername = "error"
		lnv_errservice.of_addmsg( this.classdefinition, "interfacemanager.open()", "Missing server information", "")
	end if
	</codesample>
	
</USAGE>
********************************************************************/

integer li_pos, li_resultlength, li_nextparmpos

li_pos = pos(lower(as_commandline),as_identifier)

if li_pos > 0 then
	li_nextparmpos = pos(lower(as_commandline), " /", li_pos + len(as_identifier))
	if li_nextparmpos>0 then
		li_resultlength= li_nextparmpos - li_pos
		as_result = trim( mid(as_commandline,li_pos+len(as_identifier), li_resultlength - len(as_identifier)))	
	else 
		as_result = trim(mid(as_commandline,li_pos + len(as_identifier)))
	end if	
	// remove wrapper quotes/double quotes from string if they have been used
	if (left(as_result,1) = char(34) and right(as_result,1) = char(34)) or (left(as_result,1) = char(39) and right(as_result,1) = char(39)) then
		as_result = mid(as_result, 2, len(as_result) - 2)
	end if
	if as_result = "" then return c#return.Failure
else
	if ab_required then
		return c#return.Failure
	else
		return c#return.Noaction
	end if
end if	

return c#return.Success
end function

public function long of_split (ref string as_array[], string as_string, string as_separator);/********************************************************************
   of_split
<DESC>   
	created from global function f_split.  
</DESC>
<RETURN>
	Integer:
		<LI> number of items in array
</RETURN>
<ACCESS> 
	Public
</ACCESS>
<ARGS>   
	as_array: <reference> array set that is returned
	as_string: the string requiring the split
	as_seperator: the delimiter
</ARGS>
<USAGE>
	How to use this function.
</USAGE>
********************************************************************/

string   ls,sep  
long   i,lpos,p,ln  
sep=as_separator  
ls=as_string+sep  

i=1  
lpos=1  
ln=len(sep)  

p=pos(ls,sep,lpos)  
do   while   p>0  
as_array[i]=mid(ls,lpos,p - lpos)  
lpos=p+ln  
i++  
p=pos(ls,sep,lpos)  
loop  
return i - 1   
end function

public function integer of_arraytostring (string as_source[], string as_delimiter, boolean ab_processempty, ref string as_ref_string);/********************************************************************
   of_arraytostring
   <DESC>	Create a single string from an array of strings separated by
				the passed delimeter.	
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public/protected/private </ACCESS>
   <ARGS>
		as_source[]			The array of string to be moved into a single string.
		as_delimiter		The delimeter string.
		ab_processempty	Whether to process empty string as_source members.
		as_ref_string		The string to be filled with the array of strings,
								passed by reference.
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21-02-2013 ?            LHC010        First Version
   </HISTORY>
********************************************************************/

long		ll_Count, ll_ArrayUpBound

//Get the array size
ll_ArrayUpBound = UpperBound(as_source[])

//Check parameters
IF IsNull(as_delimiter) or (Not ll_ArrayUpBound>0) Then
	Return -1
End If

//Reset the Reference string
as_ref_string = ''

If Not ab_processempty Then
	For ll_Count = 1 to ll_ArrayUpBound
		// Do not include any entries that match an empty string 
		If as_source[ll_Count] <> '' Then
			If Len(as_ref_string) = 0 Then
				//Initialize string
				as_ref_string = as_source[ll_Count]
			else
				//Concatenate to string
				as_ref_string = as_ref_string + as_delimiter + as_source[ll_Count]
			End If
		End If
	Next 
Else
	For ll_Count = 1 to ll_ArrayUpBound
		// Include any entries that match an empty string 
		If ll_Count = 1 Then
			//Initialize string
			as_ref_string = as_source[ll_Count]
		else
			//Concatenate to string
			as_ref_string = as_ref_string + as_delimiter + as_source[ll_Count]
		End If
	Next 
End If
return 1

end function

public function integer of_arraytostring (string as_source[], string as_delimiter, ref string as_ref_string);/********************************************************************
   of_arraytostring
   <DESC>	Create a single string from an array of strings separated by
				the passed delimeter.
				Note: Function will not include on the single string any 
				array entries which match an empty string.	
	</DESC>
   <RETURN>	integer:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_source[]		The array of string to be moved into a single string.
		as_delimiter	The delimeter string.
		as_ref_string	The string to be filled with the array of strings,
							passed by reference.
   </ARGS>
   <USAGE>	How to use this function	</USAGE>
   <HISTORY>
   	Date       CR-Ref       Author             Comments
   	21-02-2013 ?            LHC010        First Version
   </HISTORY>
********************************************************************/

return of_arraytostring(as_source[], as_delimiter, FALSE, as_ref_string)

end function

public function integer of_parsetoarray (string as_source, string as_delimiter, ref integer ai_array[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ParseToArray
//
//	Access:  public
//
//	Arguments:
//	as_Source   The string to parse.
//	as_Delimiter   The delimeter string.
//	ai_array[]   The array to be filled with the parsed integer, passed by reference.
//
//	Returns:  long
//	The number of elements in the array.
//	If as_Source or as_Delimeter is NULL, function returns NULL.
//
//	Description:  Parse a string into array elements using a delimeter string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.02   Fixed problem when delimiter is last character of string.

//	   Ref array and return code gave incorrect results.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

long		ll_DelLen, ll_Pos, ll_Count, ll_Start, ll_Length
string 	ls_holder

//Check for NULL
IF IsNull(as_source) or IsNull(as_delimiter) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

//Check for at leat one entry
If Trim (as_source) = '' Then
	Return 0
End If

//Get the length of the delimeter
ll_DelLen = Len(as_Delimiter)

ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter))

//Only one entry was found
if ll_Pos = 0 then
	ai_array[1] = integer(as_source)
	return 1
end if

//More than one entry was found - loop to get all of them
ll_Count = 0
ll_Start = 1
Do While ll_Pos > 0
	
	//Set current entry
	ll_Length = ll_Pos - ll_Start
	ls_holder = Mid (as_source, ll_start, ll_length)

	// Update array and counter
	ll_Count ++
	ai_array[ll_Count] = integer(ls_holder)
	
	//Set the new starting position
	ll_Start = ll_Pos + ll_DelLen

	ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter), ll_Start)
Loop

//Set last entry
ls_holder = Mid (as_source, ll_start, Len (as_source))

// Update array and counter if necessary
if Len (ls_holder) > 0 then
	ll_count++
	ai_array[ll_Count] = integer(ls_holder)
end if

//Return the number of entries found
Return ll_Count

end function

public function integer of_parsetoarray (string as_source, string as_delimiter, ref string as_array[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ParseToArray
//
//	Access:  public
//
//	Arguments:
//	as_Source   The string to parse.
//	as_Delimiter   The delimeter string.
//	as_Array[]   The array to be filled with the parsed strings, passed by reference.
//
//	Returns:  long
//	The number of elements in the array.
//	If as_Source or as_Delimeter is NULL, function returns NULL.
//
//	Description:  Parse a string into array elements using a delimeter string.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//	5.0.02   Fixed problem when delimiter is last character of string.

//	   Ref array and return code gave incorrect results.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

long		ll_DelLen, ll_Pos, ll_Count, ll_Start, ll_Length
string 	ls_holder

//Check for NULL
IF IsNull(as_source) or IsNull(as_delimiter) Then
	long ll_null
	SetNull(ll_null)
	Return ll_null
End If

//Check for at leat one entry
If Trim (as_source) = '' Then
	Return 0
End If

//Get the length of the delimeter
ll_DelLen = Len(as_Delimiter)

ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter))

//Only one entry was found
if ll_Pos = 0 then
	as_Array[1] = as_source
	return 1
end if

//More than one entry was found - loop to get all of them
ll_Count = 0
ll_Start = 1
Do While ll_Pos > 0
	
	//Set current entry
	ll_Length = ll_Pos - ll_Start
	ls_holder = Mid (as_source, ll_start, ll_length)

	// Update array and counter
	ll_Count ++
	as_Array[ll_Count] = ls_holder
	
	//Set the new starting position
	ll_Start = ll_Pos + ll_DelLen

	ll_Pos =  Pos(Upper(as_source), Upper(as_Delimiter), ll_Start)
Loop

//Set last entry
ls_holder = Mid (as_source, ll_start, Len (as_source))

// Update array and counter if necessary
if Len (ls_holder) > 0 then
	ll_count++
	as_Array[ll_Count] = ls_holder
end if

//Return the number of entries found
Return ll_Count

end function

public function string of_replaceall (string as_replace_source, string as_replace_what, string as_replace_with, boolean ab_ignorecase);/********************************************************************
   of_replaceAll
   <DESC> Replace all ocureance of string as_replace_what with as_replace_with 
				in string as_replace_source</DESC>
   <RETURN> String: New string with replaced values</RETURN>
   <ACCESS> Public</ACCESS>
   <ARGS>	as_replace_source: String to be modified
            		as_replace_what: What shall be replaced
				as_replace_with: replaced with this string
				ab_ignoreCase: if case should be ignored</ARGS>
   <USAGE> </USAGE>
********************************************************************/
string ls_tmpSource
long ll_findLen, ll_replaceLen, ll_pos

//validate parameters
if IsNull(as_replace_source ) or &
	IsNull(as_replace_what ) or &
	IsNull(as_replace_with ) then
	
	SetNull(ls_tmpSource)
	return ls_tmpSource
end if

// get length of strings
ll_findLen = Len(as_replace_what)
ll_replaceLen = Len(as_replace_with)

if ab_ignoreCase then
	ls_tmpSource = Lower(as_replace_source)
	as_replace_what = Lower(as_replace_what)
else
	ls_tmpSource = as_replace_source
end if

// find first occurrence
ll_pos = pos(ls_tmpSource, as_replace_what)

do while ll_pos > 0
	// replace old with new
	as_replace_source = Replace(as_replace_source, ll_pos, ll_findLen, as_replace_with)

	if ab_ignoreCase then
		ls_tmpSource = Lower(as_replace_source)
	else
		ls_tmpSource = as_replace_source
	end if
  
	// find next occurrence
	ll_pos = pos(ls_tmpSource, as_replace_what, (ll_pos + ll_replaceLen))
loop

return as_replace_source
end function

public function string of_is_urloremailaddress (ref string as_data);/********************************************************************
   of_is_urloremailaddress()
   <DESC>	  open url or outlook	</DESC>
   <RETURN>	string:
            null          do nothing
				'url'         link open url
				'email'       link open outlook
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE>	of_open_urloremail	</USAGE>
   <HISTORY>
		Date     CR-Ref        Author   Comments
		16/09/14	CR3760        KSH092   First Version
   </HISTORY>
********************************************************************/

string ls_return
int li_len

setnull(ls_return)
li_len = 4

if len(trim(as_data)) = 0 or isnull(as_data) then return ls_return

if (left(as_data,li_len)='http' and pos(as_data,'://') > 0) or (left(as_data,li_len) = 'www.') then
	ls_return = 'url'
else
	if (not match(as_data,"[^A-Za-z0-9\.@_\-]") and  &
		(match(as_data,"[@+]") and & 
		match(as_data,"[/.+]"))) and not &
		(pos(as_data, ".") = 1 or &
		pos(as_data, ".", len(as_data)-1) = len(as_data) or &
		pos(as_data, "@") = 1 or & 
		pos(as_data, "@", len(as_data)-1) = len(as_data) or &
		pos(as_data,".@") > 0 or & 
		pos(as_data,"@.") >0 ) then
		ls_return = 'email'			
	else
		/* do nothing */
		
	end if    
end if
return ls_return
end function

public function string of_get_token (ref string source, string separator);// String Function of_GET_TOKEN (ref string Source, string Separator)

// The function Get_Token receive, as arguments, the string from which
// the token is to be stripped off, from the left, and the separator
// character.  If the separator character does not appear in the string,
// it returns the entire string.  Otherwise, it returns the token, not
// including the separator character.  In either case, the source string
// is truncated on the left, by the length of the token and separator
// character, if any.


int 		p
string 	ret

p = Pos(source, separator)	// Get the position of the separator

if p = 0 then					// if no separator, 
	ret = source				// return the whole source string and
	source = ""					// make the original source of zero length
else
	ret = Mid(source, 1, p - 1)	// otherwise, return just the token and
	source = Right(source, Len(source) - p)	// strip it & the separator
end if

return ret
end function

public function string of_firstupper (string as_string);/********************************************************************
   of_firstupper
   <DESC> </DESC>
   <RETURN>		</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		int
   </ARGS>
   <USAGE>	
	</USAGE>
   <HISTORY>
		Date    		CR-Ref		Author		Comments
		27/03/17		CR4572		XSZ004		Move function f_firstupper to this object.
   </HISTORY>
********************************************************************/

String ls_ch, ls_newstr
Integer li_count

For li_count = 1 To Len(as_string)
	if (li_count = 1) or ((li_count>1) And (Mid(as_string, li_count -1, 1) = " ")) Then
		ls_ch = Upper(Mid(as_string, li_count, 1))
	Else
		ls_ch = Lower(Mid(as_string, li_count, 1) )
	End if

	ls_newstr += ls_ch
Next

Return(ls_newstr)
end function

on mt_n_stringfunctions.create
call super::create
end on

on mt_n_stringfunctions.destroy
call super::destroy
end on

