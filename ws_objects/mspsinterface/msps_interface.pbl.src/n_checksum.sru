$PBExportHeader$n_checksum.sru
forward
global type n_checksum from mt_n_nonvisualobject
end type
end forward

global type n_checksum from mt_n_nonvisualobject
end type
global n_checksum n_checksum

type variables
oleobject iole_checksum
end variables

forward prototypes
public function integer of_validate_checksum (string as_filecontent, string as_checksum)
public subroutine documentation ()
public function integer of_generate_checksum (string as_filecontent, ref string as_checksum)
end prototypes

public function integer of_validate_checksum (string as_filecontent, string as_checksum);/********************************************************************
   of_validate_checksum
   <DESC>Generate the checksum and validate checksum</DESC>
   <RETURN>	
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_info     	file content
		as_checksum 	checksum code
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref          Author             Comments
   	2012-01-10 CR20            RJH022             First Version
   </HISTORY>
********************************************************************/

string ls_checksum
int li_return
 
li_return = iole_checksum.connecttonewobject("CheckSum.HexCrc32")

if li_return<> 0 then
	destroy iole_checksum
	return  c#return.Failure
end if
ls_checksum = iole_checksum.GetHexCrc32(as_filecontent)

if ls_checksum <> as_checksum then 
	destroy iole_checksum
	return  c#return.Failure
end if

return c#return.Success
end function

public subroutine documentation ();/********************************************************************
   constructor
   <DESC> Generate the checksum code for a file or string </DESC>
   <RETURN>	long:
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
   </ARGS>
   <USAGE> 1. Register checksum.dll with regsvr32
	        2. create an ole object and connect oleobject
			  3. call the checksum.GetHexCrc32 function
	</USAGE>
   <HISTORY>
   	Date       CR-Ref       	Author             Comments
   	2012-01-10 CR20            RJH022        First Version
   </HISTORY>
********************************************************************/
end subroutine

public function integer of_generate_checksum (string as_filecontent, ref string as_checksum);/********************************************************************
   of_generate_checksum
   <DESC>Generate the checksum </DESC>
   <RETURN>	
            <LI> c#return.Success, X ok
            <LI> c#return.Failure, X failed	</RETURN>
   <ACCESS> public </ACCESS>
   <ARGS>
		as_info     	file content
		as_checksum 	checksum code
   </ARGS>
   <USAGE></USAGE>
   <HISTORY>
   	Date       CR-Ref          Author             Comments
   	2012-01-10 CR20            RJH022             First Version
   </HISTORY>
********************************************************************/

int li_return
 
li_return = iole_checksum.connecttonewobject("CheckSum.HexCrc32")

if li_return<> 0 then
	destroy iole_checksum
	return  c#return.Failure
end if
as_checksum = iole_checksum.GetHexCrc32(as_filecontent)

if as_checksum = '' then 
	destroy iole_checksum
	return  c#return.Failure
end if

return c#return.Success
end function

on n_checksum.create
call super::create
end on

on n_checksum.destroy
call super::destroy
end on

event constructor;call super::constructor;iole_checksum = create oleobject
end event

