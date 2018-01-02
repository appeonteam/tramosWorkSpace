$PBExportHeader$n_dirattrib.sru
forward
global type n_dirattrib from mt_n_nonvisualobject
end type
end forward

global type n_dirattrib from mt_n_nonvisualobject autoinstantiate
end type

type variables
// FileName is long file name where supported
String    is_FileName

// Last write Date and Time
Date    id_LastWriteDate
Time    it_LastWriteTime

// File size
Double    idb_FileSize

// Attributes
Boolean    ib_ReadOnly
Boolean    ib_Hidden
Boolean    ib_System
Boolean    ib_Subdirectory
Boolean    ib_Archive
Boolean    ib_Drive

// The following attributes are used ONLY by the Win32 version
// of the File Services
// AltFileName is the 8.3 name where long file names are supported
String    is_AltFileName

// Creation Date and Time
Date    id_CreationDate
Time    it_CreationTime

// Last access Date
Date    id_LastAccessDate

end variables

forward prototypes
public subroutine documentation ()
end prototypes

public subroutine documentation ();/********************************************************************
   n_object_name: n_dirattrib
	
	<OBJECT>
		
	</OBJECT>
   <DESC>
		container for file/folder related attributed.  Copy of PFC
	</DESC>
   <USAGE>
		used with object mt_n_filefunctions
	</USAGE>
   <ALSO>
		
	</ALSO>
    	Date   	Ref    	Author   		Comments
	01/06/15 	CR3419   AGL027			Created object.  Influenced by PFC.
	16/06/15		CR3907	AGL027
********************************************************************/
end subroutine

on n_dirattrib.create
call super::create
end on

on n_dirattrib.destroy
call super::destroy
end on

