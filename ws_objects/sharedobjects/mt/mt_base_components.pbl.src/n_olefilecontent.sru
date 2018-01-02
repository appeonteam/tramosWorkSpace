$PBExportHeader$n_olefilecontent.sru
forward
global type n_olefilecontent from nonvisualobject
end type
end forward

global type n_olefilecontent from nonvisualobject
end type
global n_olefilecontent n_olefilecontent

type prototypes
Private Function Long SHGetSpecialFolderPath(Long hwndOwner, Ref String nFolder, Long ppidl, Boolean f_Create) Library "shell32" Alias For "SHGetSpecialFolderPathA;Ansi"
end prototypes

forward prototypes
private function string of_createtmpfolder ()
private function integer of_deletetmpfolder (string as_tmpfolder)
public function string of_getmydocumentspath ()
public function integer of_openblobinole (ref blob abl_filecontent, ref olecontrol aole_file, string as_filename)
end prototypes

private function string of_createtmpfolder ();/********************************************************************
   of_createfolder
   <DESC>     This function is to create a temp folder 						</DESC>
   <RETURN> String:	<LI> ls_tmpfoler, X ok<LI> -1, X failed				</RETURN>
   <ACCESS> Public																	</ACCESS>
   <ARGS>   																			</ARGS>
   <USAGE>  When user has no permission to create a folder in the application folder, 
				a temp folder(in MyDocs) is create to make the possibilities to save some files.
   </USAGE>
********************************************************************/
string			ls_appfolder, ls_tmpfoler
  
// Init app folders 
ls_appfolder = GetCurrentDirectory()
If Right(ls_appfolder, 1) <> "\" then ls_appfolder += "\"

// Create Tempfolder
randomize(9999)
//ls_tmpfoler = ls_appfolder + "Temp_" + uo_global.is_userid + "_" + String(Rand(9999)) + "\"
ls_tmpfoler = ls_appfolder + "Temp_" + String(Rand(9999)) + "\"

If CreateDirectory(ls_tmpfoler) < 1 then  // if temp directory fails
	randomize(999999)
	ls_tmpfoler = of_GetMydocumentsPath() + "Temp" + String(Rand(999999)) + "\"
	If CreateDirectory(ls_tmpfoler) < 1 then  // if temp directory fails
		Messagebox("Folder Error", "TRAMOS cannot create a temporary working folder.~n~nExport/Import may not work.", Exclamation!)
		ls_tmpfoler = ls_appfolder
		return "-1"
	End If
End If

Return Trim(ls_tmpfoler)
end function

private function integer of_deletetmpfolder (string as_tmpfolder);/********************************************************************
of_deletefolder( /*string as_tmpfolder */)
   <DESC>     This function is to delete a temp folder 						</DESC>
   <RETURN> Integer:	<LI> 1, X ok<LI> -1, X failed						</RETURN>
   <ACCESS> Public																	</ACCESS>
   <ARGS>    as_tmpfolder: the temp folder need to be deleted.			</ARGS>
   <USAGE>  When user has no permission to create a folder in the application folder, 
				a temp folder(in MyDocs) is create to make the possibilities to save some files, 
				we will have to delete the folder when the operation is finished.  
   </USAGE>
********************************************************************/
string			ls_appfolder

// Init app folders 
ls_appfolder = GetCurrentDirectory()
If Right(ls_appfolder, 1) <> "\" then ls_appfolder += "\"

// Delete temp folder and all files in it
If as_tmpfolder <> ls_appfolder then	Run('cmd /q /c rmdir /S /Q "' + as_tmpfolder + '"', Minimized!)

return 1
end function

public function string of_getmydocumentspath ();/********************************************************************
   of_getmydocumentspath( )
   <DESC>     This function is to create a temp folder in MyDocs			</DESC>
   <RETURN> String:	<LI> ls_Path, X ok<LI> -1, X failed				</RETURN>
   <ACCESS> Private																	</ACCESS>
   <ARGS>   																			</ARGS>
   <USAGE>  When user has no permission to create a folder in the application folder, 
				a temp folder(in MyDocs) is create to make the possibilities to save some files.
				called from of_createtmpfolder( )
   </USAGE>
********************************************************************/
String ls_Path
Long ll_Ret

ls_Path = Space(260)
ll_Ret = SHGetSpecialFolderPath(Handle(This), ls_Path, 5, False) 

ls_Path = Trim(ls_Path)

If Right(ls_Path,1) <> "\" then ls_Path += "\"

Return Trim(ls_Path)
end function

public function integer of_openblobinole (ref blob abl_filecontent, ref olecontrol aole_file, string as_filename);/********************************************************************
of_openblobinole(/*blob abl_filecontent */, /*olecontrol aole_file */, /*string as_filename */)
   <DESC>     This function is to open file content in a ole control			</DESC>
   <RETURN> Integer:	<LI> 1, X ok<LI> -1, X failed						</RETURN>
   <ACCESS> Public																	</ACCESS>
   <ARGS>    abl_filecontent: the blob variable to store the file content.		
				 aole_file: ole control to hold the file content.
				 as_filename: file name
   </ARGS>
   <USAGE>  This function is to open the file content which stored in a blob variable in a ole control  
   </USAGE>
********************************************************************/
string		ls_tmpfolder		
long		ll_filehandle

ls_tmpfolder = of_CreateTmpFolder()//create a tmp folder to save the file, prepare it to open the file with ole control
if ls_tmpfolder <> "-1" then
	ll_filehandle = fileopen(ls_tmpfolder+as_filename, streammode!, write!, lockwrite!, replace!)
	filewriteex(ll_filehandle, abl_filecontent)//write the file to the temp folder
	fileclose(ll_filehandle)
	if aole_file.insertfile(ls_tmpfolder+as_filename) = 0 then
		aole_file.activate(offsite!)//open the file
	else
		messagebox("Error","Error when opening the file")
	end if
	filedelete(ls_tmpfolder+as_filename)//delete the file
	of_DeleteTmpFolder(ls_tmpfolder)//delete the temp folder
	return 1
else
	return -1
end if


end function

on n_olefilecontent.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_olefilecontent.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

