$PBExportHeader$mt_n_filefunctions.sru
forward
global type mt_n_filefunctions from mt_n_nonvisualobject
end type
type os_filedatetime from structure within mt_n_filefunctions
end type
type os_systemtime from structure within mt_n_filefunctions
end type
type os_finddata from structure within mt_n_filefunctions
end type
end forward

type os_filedatetime from structure
	unsignedlong		ul_lowdatetime
	unsignedlong		ul_highdatetime
end type

type os_systemtime from structure
    unsignedinteger        ui_wyear
    unsignedinteger        ui_wmonth
    unsignedinteger        ui_wdayofweek
    unsignedinteger        ui_wday
    unsignedinteger        ui_whour
    unsignedinteger        ui_wminute
    unsignedinteger        ui_wsecond
    unsignedinteger        ui_wmilliseconds
end type

type os_finddata from structure
    unsignedlong        ul_fileattributes
    os_filedatetime        str_creationtime
    os_filedatetime        str_lastaccesstime
    os_filedatetime        str_lastwritetime
    unsignedlong        ul_filesizehigh
    unsignedlong        ul_filesizelow
    unsignedlong        ul_reserved0
    unsignedlong        ul_reserved1
    character        ch_filename[260]
    character        ch_alternatefilename[14]
end type

global type mt_n_filefunctions from mt_n_nonvisualobject autoinstantiate
end type

type prototypes


function boolean Wow64DisableWow64FsRedirection (ref long oldvalue) library "KERNEL32.DLL"
function boolean Wow64RevertWow64FsRedirection (ref long oldvalue) library "KERNEL32.DLL"

Function long FindFirstFileW (ref string filename, ref os_finddata findfiledata) library "KERNEL32.DLL"
Function boolean FindNextFileW (long handle, ref os_finddata findfiledata) library "KERNEL32.DLL"

//Function long FindFirstFileW (ref string filename, ref str_findfiledata findfiledata) library "KERNEL32.DLL"
//Function boolean FindNextFileW (long handle, ref str_findfiledata findfiledata) library "KERNEL32.DLL"
Function boolean FindClose (long handle) library "KERNEL32.DLL"
Function ulong GetDriveTypeA (string drive) library "KERNEL32.DLL"
function ulong GetTempPath(ulong nBufferLength, ref string lpBuffer) library "kernel32" alias for GetTempPathW	
function long CreateDirectoryA (ref string lpPathName, ulong lp) library "Kernel32.dll" 
function boolean RemoveDirectoryA( ref string path ) library "KERNEL32.DLL" 



Function boolean FileTimeToSystemTime(ref os_filedatetime lpFileTime, ref os_systemtime lpSystemTime) library "KERNEL32.DLL"
Function boolean FileTimeToLocalFileTime(ref os_filedatetime lpFileTime, ref os_filedatetime lpLocalFileTime) library "KERNEL32.DLL"


end prototypes

forward prototypes
public subroutine documentation ()
public function integer of_gettempfolder (ref string as_tempfolder)
public function integer of_removefolder (string as_foldertodelete)
public function string of_getfileextensionsegment (string as_filename)
protected function boolean of_includefile (string as_filename, long al_attribmask, unsignedlong aul_fileattrib)
public function integer of_getdrivetype (string as_drive)
public function long of_dirlist (string as_filespec, long al_filetype, ref n_dirattrib anv_dirlist[])
public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time)
public function boolean of_isvalidextension (string as_filename, string as_disallowedextensions[], string as_errormessage)
public function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime)
end prototypes

public subroutine documentation ();/********************************************************************
   mt_n_filefunctions: 
	
	<OBJECT>
		Useful functions related to file handling.  PB lacks native basic file handling 
		tools so this collection of functions should help.
		Calls to local external Win API functions
	</OBJECT>
   <DESC>
	</DESC>
   <USAGE>
		For file attachment refactor & server application log file naming.  
		3 structures are included within this object
	</USAGE>
   <ALSO>
		n_dirattrib
		mt_n_numericalfunctions	
	</ALSO>

    	Date   	Ref    	Author   		Comments

  	01/06/15 	CR3419   AGL027			Created object.  Influenced by PFC.
	16/06/15		CR3907	AGL027		
	03/06/16		CR4276	AGL027			Correct small issue in scope of parameter
	
********************************************************************/
end subroutine

public function integer of_gettempfolder (ref string as_tempfolder);long ll_bufferlength = 256

constant string METHOD_NAME = "of_gettempfolder()"
as_tempfolder = SPACE(ll_bufferLength)
if GetTempPath(ll_bufferLength, as_tempfolder) = 0 then
	 _addmessage( this.classdefinition, METHOD_NAME, "There is no temp path defined.  Unable to use attachment functions", "can not locate temp/tmp environment variables on this PC.")
	 return c#return.Failure
else
	as_tempfolder = trim(as_tempfolder)
	return c#return.Success
end if

end function

public function integer of_removefolder (string as_foldertodelete);/* only deletes a single folder at a time.  Extra method required to do this recursive task */
RemoveDirectoryA(as_foldertodelete)
return c#return.Success
end function

public function string of_getfileextensionsegment (string as_filename);return lower(right(as_filename,3))
end function

protected function boolean of_includefile (string as_filename, long al_attribmask, unsignedlong aul_fileattrib);//////////////////////////////////////////////////////////////////////////////
//    Protected Function:  of_IncludeFile
//    Arguments:        as_FileName                The name of the file.
//                        al_AttribMask            The bit string that determines which files to include.
//                        aul_FileAttrib            The attribute bits for the file.
//    Returns:            Boolean - True if the file should be included, False if not.
//    Description:    Determine whether a file should be included by the of_DirList function.
//                        This is based on the attributes of the desired files and the file's attributes.
//////////////////////////////////////////////////////////////////////////////
//    Rev. History:    Version
//                        5.0           Initial version
//                        5.0.02        Fixed problem with NTFS file systems using different value for FILE_ATTRIBUTE_NORMAL
//                        8.0            Change to include files in compressed directories
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
boolean                lb_ReadWrite
mt_n_numericalfunctions    lnv_Numeric

// Never include the "[.]" directory entry
If as_FileName = "." Then Return False

// If the mask is > 32768, then read/write files should be excluded
If al_AttribMask >=32768 Then
    al_AttribMask = al_AttribMask - 32768
    lb_ReadWrite = False
Else
    lb_ReadWrite = True
End if

// If the type is > 16384, then a list of drives should be included
If al_AttribMask >= 16384 Then al_AttribMask = al_AttribMask - 16384

// Include the file if lb_ReadWrite is true and the file is a read-write or
// read-only file (with or without the archive bit set)
// NTFS File Systems set Read/Write Files (FILE_ATTRIBUTE_NORMAL) = 128
If (lb_ReadWrite And (aul_FileAttrib = 0 Or &
                                 aul_FileAttrib = 1 Or &
                                aul_FileAttrib = 32 Or &
                                aul_FileAttrib = 33 Or &
                                aul_FileAttrib = 128)) Then Return True

//  Look for compressed files
If (lb_ReadWrite And (aul_FileAttrib = 0 + 2048 Or &
                                 aul_FileAttrib = 1 + 2048 Or &
                                aul_FileAttrib = 32 + 2048 Or &
                                aul_FileAttrib = 33 + 2048 Or &
                                aul_FileAttrib = 128 + 2048 )) Then Return True
                                
// Or include it if its attributes match the mask passed in (use bitwise AND).
If lnv_Numeric.of_BitwiseAnd(aul_FileAttrib, al_AttribMask) > 0 Then Return True

Return False
end function

public function integer of_getdrivetype (string as_drive);//////////////////////////////////////////////////////////////////////////////
//    Public Function:  of_GetDriveType
//    Arguments:        as_Drive                    The letter of the drive to be checked.
//    Returns:            Integer
//                        The type of the drive:
//                        2 - floppy drive,
//                        3 - hard drive,
//                        4 - network drive,
//                        5 - cdrom drive,
//                        6 - ramdisk,
//                        any other value is the result of an error.
//    Description:    Determine the type of a drive.
//////////////////////////////////////////////////////////////////////////////
//    Rev. History:    Version
//                        5.0   Initial version
//                        5.0.03    Changed Uint variables to Ulong for NT4.0 compatibility
//                     5.0.03    Changed argument datatype to string from char to fix polymorphism problem
//                                    with literals passed in.
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
ulong lul_drivetype
string ls_drive

ls_drive = Upper(Left(as_drive,1)) + ":\"

lul_drivetype = GetDriveTypeA(ls_drive)

return lul_drivetype
end function

public function long of_dirlist (string as_filespec, long al_filetype, ref n_dirattrib anv_dirlist[]);//////////////////////////////////////////////////////////////////////////////
//    Public Function:  of_DirList
//    Arguments:        as_FileSpec                The file spec. to list (including wildcards); an
//                                                    absolute path may be specified or it will
//                                                    be relative to the current working directory
//                        al_FileType                A number representing one or more types of files
//                                                    to include in the list, see PowerBuilder Help on
//                                                    the DirList listbox function for an explanation.
//                        anv_DirList[]            An array of n_cst_dirattrib structure whichl will contain
//                                                    the results, passed by reference.
//    Returns:            Long
//                        The number of elements in anv_DirList if successful, -1 if an error occurrs.
//    Description:    List the contents of a directory (Name, Date, Time, and Size).
//////////////////////////////////////////////////////////////////////////////
//    Rev. History:    Version
//                        5.0        Initial version
//                        5.0.03    Changed long variables to Ulong for NT4.0 compatibility
//                        7.0        Changed return datatype from int to long
//                                Changed li_Cnt, li_Entries from int to long
//                        8.0     Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
Boolean                    lb_Found
Char                        lc_Drive
long                        ll_Cnt, ll_Entries
Long                        ll_handle
Time                        lt_Time
os_finddata                lstr_FindData
n_dirattrib        lnv_Empty[]
mt_n_numericalfunctions        lnv_Numeric

// Empty the result array
anv_DirList = lnv_Empty

// List the entries in the directory
ll_handle = FindFirstFileW(as_FileSpec, lstr_FindData)
If ll_handle <= 0 Then Return -1
Do
    // Determine if this file should be included.
    If of_IncludeFile(String(lstr_FindData.ch_filename), al_FileType, lstr_FindData.ul_FileAttributes) Then
        
        // Add it to the array
        ll_Entries ++
        anv_DirList[ll_Entries].is_FileName = lstr_FindData.ch_filename
        anv_DirList[ll_Entries].is_AltFileName = lstr_FindData.ch_alternatefilename
        If Trim(anv_DirList[ll_Entries].is_AltFileName) = "" Then
            anv_DirList[ll_Entries].is_AltFileName = anv_DirList[ll_Entries].is_FileName
        End If
    
        // Set date and time
        of_ConvertFileDatetimeToPB(lstr_FindData.str_CreationTime, anv_DirList[ll_Entries].id_CreationDate, &
                                                    anv_DirList[ll_Entries].it_CreationTime)
        of_ConvertFileDatetimeToPB(lstr_FindData.str_LastAccessTime, anv_DirList[ll_Entries].id_LastAccessDate, lt_Time)
        of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, anv_DirList[ll_Entries].id_LastWriteDate, &
                                                    anv_DirList[ll_Entries].it_LastWriteTime)

        // Calculate file size
        anv_DirList[ll_Entries].idb_FileSize = (lstr_FindData.ul_FileSizeHigh * (2.0 ^ 32))  + lstr_FindData.ul_FileSizeLow
        
        // Set file attributes
        anv_DirList[ll_Entries].ib_ReadOnly = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 1)
        anv_DirList[ll_Entries].ib_Hidden = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 2)
        anv_DirList[ll_Entries].ib_System = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 3)
        anv_DirList[ll_Entries].ib_SubDirectory = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 5)
        anv_DirList[ll_Entries].ib_Archive = lnv_Numeric.of_getbit(lstr_FindData.ul_FileAttributes, 6)
        anv_DirList[ll_Entries].ib_Drive = False
        
        // Put brackets around subdirectories
        If anv_DirList[ll_Entries].ib_SubDirectory Then
            anv_DirList[ll_Entries].is_FileName = "[" + anv_DirList[ll_Entries].is_FileName + "]"
            anv_DirList[ll_Entries].is_AltFileName = "[" + anv_DirList[ll_Entries].is_AltFileName + "]"
        End If
    End If
    
    lb_Found = FindNextFileW(ll_handle, lstr_FindData)
Loop Until Not lb_Found

FindClose(ll_handle)

// Add the drives if desired.
// If the type is > 32768 this was to prevent read-write files from being included.
If al_FileType >=32768 Then al_FileType = al_FileType - 32768

// If the type is > 16384, then a list of drives should be included
If al_FileType >= 16384 Then
    For ll_Cnt = 0 To 25
        lc_Drive = Char(ll_Cnt + 97)
        If of_GetDriveType(lc_Drive) > 1 Then
            ll_Entries ++
            anv_DirList[ll_Entries].is_FileName = "[-" + lc_Drive + "-]"
            anv_DirList[ll_Entries].is_AltFileName = anv_DirList[ll_Entries].is_FileName
            anv_DirList[ll_Entries].ib_ReadOnly = False
            anv_DirList[ll_Entries].ib_Hidden = False
            anv_DirList[ll_Entries].ib_System = False
            anv_DirList[ll_Entries].ib_SubDirectory = False
            anv_DirList[ll_Entries].ib_Archive = False
            anv_DirList[ll_Entries].ib_Drive = True
        End if
    Next
End if

Return ll_Entries
end function

public function integer of_getlastwritedatetime (string as_filename, ref date ad_date, ref time at_time);//////////////////////////////////////////////////////////////////////////////
//    Public Function:  of_GetLastWriteDatetime
//    Arguments:        as_FileName            The name of the file for which you want its date
//                                                and time; an absolute path may be specified or it
//                                                will be relative to the current working directory
//                        ad_Date                The date the file was last modified, passed by reference.
//                        at_Time                The time the file was last modified, passed by reference.
//    Returns:            Integer
//                        1 if successful, -1 if an error occurrs.
//    Description:    Get the date and time a file was last modified.
//////////////////////////////////////////////////////////////////////////////
//    Rev. History:    Version
//                        5.0        Initial version
//                        5.0.03    Changed long variables to Ulong for NT4.0 compatibility
//                        8.0     Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
Long            ll_handle
os_finddata    lstr_FindData

// Get the file information
ll_handle = FindFirstFileW(as_FileName, lstr_FindData)
If ll_handle <= 0 Then Return -1
FindClose(ll_handle)

// Convert the date and time
Return of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, ad_Date, at_Time)


end function

public function boolean of_isvalidextension (string as_filename, string as_disallowedextensions[], string as_errormessage);string ls_ext
integer li_extensions

ls_ext = of_getfileextensionsegment(as_filename)

for li_extensions = 1 to upperbound(as_disallowedextensions)	
	if ls_ext = as_disallowedextensions[li_extensions] then
		if as_errormessage<>"" then
			populateerror(555,"dummy")	
			_addmessage( this.classdefinition, error.object + "::" + error.objectevent, as_errormessage, "extension not allowed to be saved as an attachment")
			return false
		end if
	end if
next 	
return true

end function

public function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime);//////////////////////////////////////////////////////////////////////////////
//    Protected Function:  of_ConvertFileDatetimeToPB
//    Arguments:        astr_FileTime        The os_filedatetime structure containing the system date/time for the file.
//                        ad_FileDate            The file date in PowerBuilder Date format    passed by reference.
//                        at_FileTime            The file time in PowerBuilder Time format    passed by reference.
//    Returns:            Integer
//                        1 if successful, -1 if an error occurrs.
//    Description:    Convert a sytem file type to PowerBuilder Date and Time.
//////////////////////////////////////////////////////////////////////////////
//    Rev. History:    Version
//                        5.0   Initial version
//                        5.0.03    Fixed - function would fail under some international date formats
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
String                ls_Time
os_filedatetime    lstr_LocalTime
os_systemtime        lstr_SystemTime

If Not FileTimeToLocalFileTime(astr_FileTime, lstr_LocalTime) Then Return -1

If Not FileTimeToSystemTime(lstr_LocalTime, lstr_SystemTime) Then Return -1

// works with all date formats
ad_FileDate = Date(lstr_SystemTime.ui_wyear, lstr_SystemTime.ui_WMonth, lstr_SystemTime.ui_WDay)

ls_Time = String(lstr_SystemTime.ui_wHour) + ":" + &
                String(lstr_SystemTime.ui_wMinute) + ":" + &
                String(lstr_SystemTime.ui_wSecond) + ":" + &
                String(lstr_SystemTime.ui_wMilliseconds)
at_FileTime = Time(ls_Time)

Return 1

end function

on mt_n_filefunctions.create
call super::create
end on

on mt_n_filefunctions.destroy
call super::destroy
end on

