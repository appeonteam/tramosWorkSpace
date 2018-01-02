$PBExportHeader$n_filepackage.sru
forward
global type n_filepackage from nonvisualobject
end type
end forward

global type n_filepackage from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer packfiles (string as_ftype, string as_path, string as_temp)
public function integer unpackfiles (string as_fullpath, string as_temp)
public function long updatetable (string as_file, string as_dataobj, ref hprogressbar ahpb_progress, string as_textcolumn)
end prototypes

public function integer packfiles (string as_ftype, string as_path, string as_temp);/*  

This function compresses and 'encrypts' all *.vdbxp files in a folder and
creates the file vims_xxx.vpkg in the specified folder
				
Parameters:

as_ftype     : Specify title of file (*) in vims_*.vpkg
as_Path      : The path to save the final package
as_Temp      : Folder containing all *.vdbxp files

Returns 0 on success and -x on failure

Requirements to use:
	 1) All vdbxp files must be ready in the temp folder
	 2) z.exe must be present in the current folder path (application folder)
*/


Blob lblob_File
Integer li_Temp
Byte lb_File[]
Long ll_FSize, ll_Count

f_Write2Log("n_FilePackage.PackFiles()")

// First, zip all *.vdbxp files in the folder
li_Temp = Run('z.exe -D -j -9 -q -m "' + as_Temp + 'Pkg.vtmp" "' + as_Temp + '*.vdbxp"', Minimized!)
If li_Temp < 1 then Return li_Temp

f_Write2Log('Running z.exe "' + as_Temp + 'Pkg.vtmp" "' + as_Temp + '*.vdbxp"')
	
// Read into blob	
ll_Count = 0
Do  // Wait 1 second to try to open (incase zip has not completed). Try up to 50 times (50 seconds)
	Sleep(1)
	li_Temp = FileOpen(as_Temp + 'Pkg.vtmp', StreamMode!, Read!, LockReadWrite!)
	ll_Count ++
Loop Until (ll_Count=50) or (li_Temp>0)
If li_Temp < 0 then Return li_Temp	  // Could not read file
ll_FSize = FileReadEx(li_Temp, lblob_File)
FileClose(li_Temp)
f_Write2Log("FileSize Returned: " + String(ll_FSize))
If ll_FSize<0 then Return ll_FSize  // Blob read error

// Invert alternate bytes
lb_File = GetByteArray(lblob_File)
ll_FSize = UpperBound(lb_File)
For ll_Count = 1 to ll_FSize Step 2
	lb_File[ll_Count] = 255 - lb_File[ll_Count]
Next
lblob_File = Blob(lb_File)

// Check destination path is valid
as_Path = Trim(as_Path, True)
If Right(as_Path,1) <> "\" then as_Path += "\"

// Save blob back into file
li_Temp = FileOpen(as_Path + 'Vims_' + as_ftype + '.vpkg', StreamMode!, Write!, LockReadWrite!, Replace!)
If li_Temp < 0 then Return li_Temp	
ll_FSize = FileWriteEx(li_Temp, lblob_File)
FileClose(li_Temp)
f_Write2Log("FileWriteEx Returned: " + String(ll_FSize))
If ll_FSize<0 then Return ll_FSize

// Delete original zip file
FileDelete(as_Temp + "Pkg.vtmp")

Return 0
end function

public function integer unpackfiles (string as_fullpath, string as_temp);/*

This function 'decrypts' and decompresses all *.vdbxp files to the specified folder

Parameters:

as_FullPath  : Specifies the full path & filename
as_Temp      : Folder to extract all *.vdbxp files to

Returns 0 on success and -x on failure

Requirements to use:
	 1) All vdbxp files must be ready in the temp folder
	 2) uz.exe must be present in the current folder path (application folder)

*/

Blob lblob_File
Integer li_Temp
Byte lb_File[]
Long ll_FSize, ll_Count
String ls_Temp

// Read package into blob	
li_Temp = FileOpen(as_FullPath, StreamMode!, Read!, LockReadWrite!)
If li_Temp < 0 then Return li_Temp	  // Could not read file
ll_FSize = FileReadEx(li_Temp, lblob_File)
FileClose(li_Temp)
If ll_FSize<0 then Return ll_FSize  // Blob read error

// Invert alternate bytes
lb_File = GetByteArray(lblob_File)
ll_FSize = UpperBound(lb_File)
For ll_Count = 1 to ll_FSize Step 2
	lb_File[ll_Count] = 255 - lb_File[ll_Count]
Next
lblob_File = Blob(lb_File)

// Save blob back into file
li_Temp = FileOpen(as_Temp + 'Pkg.vtmp', StreamMode!, Write!, LockReadWrite!, Replace!)
If li_Temp < 0 then Return li_Temp	
ll_FSize = FileWriteEx(li_Temp, lblob_File)
FileClose(li_Temp)
If ll_FSize<0 then Return ll_FSize

// Unzip all *.vdbxp files 
ls_Temp = Left(as_Temp, Len(as_Temp) - 1) // Remove last '\'
li_Temp = Run('uz.exe -qq -o "' + as_Temp + 'Pkg.vtmp" -d"' + ls_Temp + '"', Minimized!) 
If li_Temp < 1 then Return li_Temp
	
// Try to delete Pkg.vtmp (try 20 times at 1 sec interval)
ll_Count = 0
Do
	Sleep(1)
	ll_Count++
Loop Until (FileDelete(as_Temp + 'Pkg.vtmp')) or (ll_Count = 20)

Return 0
end function

public function long updatetable (string as_file, string as_dataobj, ref hprogressbar ahpb_progress, string as_textcolumn);/*
This function updates a table with new information from an XML File
It can handle addtion, modification and deletion of rows

Parameters:

as_File        : The XML file to import from
as_DataObj     : The Dataobject for the Datastore that imports and connects to the table
ahpb_progress  : Progress bar control reference. StepIt() function is called

Returns X for number of rows processed, 0 if file not found or -1 if it fails

Requirements to use:
  1) The first column in the dataobject MUST be the ID for the table (string or number)
  2) The dataobject MUST be sorted by the ID (ascending)
	
*/

Long li_Rows, li_Current, li_NumCol
n_myDatastore lds_Old, lds_New
Any la_Old, la_New

If FileExists(as_File) then
	
	// Init datastores
	lds_New = Create n_myDatastore
	lds_Old = Create n_myDatastore

	// Retrieve existing table
	lds_old.DataObject = as_dataobj
	lds_old.SetTransObject(SQLCA)
	li_Rows = lds_old.Retrieve()
	If li_Rows < 0 then Return li_Rows  // If error, return error
	
	// Import XML table
	lds_new.DataObject = as_dataobj
	lds_new.SetTransObject(SQLCA)
	li_Rows = lds_new.ImportFile(XML!, as_File)
	If li_Rows < 0 then Return li_Rows  // If error, return error
	
	// Correct carraige returns for XML bug
	If as_textcolumn > "" then f_restore_cr_after_xml_import(lds_new, as_textcolumn)	

	// Start comparision
	li_Current = 1
	li_NumCol = Integer(lds_old.Object.DataWindow.Column.Count)
	
	Do While (li_Current <= lds_new.RowCount()) or (li_Current <= lds_old.RowCount())
		
		If (li_Current <= lds_new.RowCount()) And (li_Current <= lds_old.RowCount()) then
			// Check ID match 
			la_New = lds_New.Object.Data[li_Current, 1]
			la_Old = lds_Old.Object.Data[li_Current, 1]
			If la_New = la_Old then
				// Compare and modify if different
				For li_Rows = 1 to li_NumCol // li_Rows iterates through the columns
					la_New = lds_New.Object.Data[li_Current, li_Rows]
					la_Old = lds_Old.Object.Data[li_Current, li_Rows]
					If Not (IsNull(la_New) or IsNull(la_Old)) then  // If both are not null then compare directly
						If (la_Old <> la_New) then // If modified, copy data
							lds_Old.Object.Data[li_Current, li_Rows] = lds_New.Object.Data[li_Current, li_Rows]
							lds_Old.SetItemStatus(li_Current, li_Rows, Primary!, DataModified!)
						End If
					Else  // If one or both are null
						If Not (IsNull(la_New) And IsNull(la_Old)) then  // If only one of them is null, then copy data
							lds_Old.Object.Data[li_Current, li_Rows] = lds_New.Object.Data[li_Current, li_Rows]
							lds_Old.SetItemStatus(li_Current, li_Rows, Primary!, DataModified!)							
						End If
					End If
				Next
			Else   // ID mismatch
				If la_New > la_Old then  // Item was deleted in new import
					lds_Old.DeleteRow(li_Current)
					li_Current --
				Else  // New item was inserted in new import
					lds_Old.InsertRow(li_Current)
					lds_Old.Object.Data[li_Current] = lds_New.Object.Data[li_Current]
				End If
			End If			
		ElseIf li_Current > lds_Old.Rowcount( ) then    // New items added
			li_Current = lds_Old.InsertRow(0)	
			lds_Old.Object.Data[li_Current] = lds_New.Object.Data[li_Current]
		Else  // Some items deleted
			lds_Old.DeleteRow(li_Current)
		End If
		// Update changes
		li_Rows = lds_Old.Update( )
		If li_Rows < 0 then
			Exit
		End If
		li_Current++
		ahpb_Progress.StepIt()
		Yield()
	Loop
	
	Destroy lds_New
	Destroy lds_Old
	
	If li_Rows < 0 then Return li_Rows
	
End If

Return 0
end function

on n_filepackage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_filepackage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

