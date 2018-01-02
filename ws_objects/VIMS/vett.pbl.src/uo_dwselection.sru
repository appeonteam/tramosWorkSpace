$PBExportHeader$uo_dwselection.sru
forward
global type uo_dwselection from nonvisualobject
end type
end forward

global type uo_dwselection from nonvisualobject autoinstantiate
end type

forward prototypes
public function integer of_saveselection (ref datawindow adw_data, string as_idcol, boolean abool_stringid, ref string as_string)
public function integer of_restoreselection (ref datawindow adw_data, string as_idcol, boolean abool_stringid, string as_string)
end prototypes

public function integer of_saveselection (ref datawindow adw_data, string as_idcol, boolean abool_stringid, ref string as_string);// This function saves the selected rows in a datawindow into a string using the least possible characters

// Return 1 for success, -1 for error, 0 for no rows

// Parameters:
// adw_Data - The datawindow
// as_IDCol - The primary key column of the datawindow (this is saved in the string)
// abool_StringID - Indicates if 'as_IDCol' is a string ID (such as userid or so)
// as_String - The resulting string with all saved info

Integer li_Loop, li_Sel

as_String = ""

If adw_Data.RowCount() = 0 then Return 0

Try 
	
	// Count the number of selections
	For li_Loop = 1 to adw_Data.RowCount()
		If adw_Data.GetItemNumber(li_Loop, "Sel") = 1 then li_Sel ++
	Next
	
	If li_Sel > adw_Data.RowCount() / 2 then  // More selected than un-selected. So save unselected.
		as_String = "U;"
		li_Sel = 0
	Else  // Save selected
		as_String = "S;"
		li_Sel = 1
	End If
	
	// If string ID
	If abool_StringID Then
		For li_Loop = 1 to adw_Data.RowCount()
			If adw_Data.GetItemNumber(li_Loop, "Sel") = li_Sel then as_String += adw_Data.GetItemString(li_Loop, as_IDCol) + ";"
		Next
	Else
		For li_Loop = 1 to adw_Data.RowCount()
			If adw_Data.GetItemNumber(li_Loop, "Sel") = li_Sel then as_String += String(adw_Data.GetItemNumber(li_Loop, as_IDCol)) + ";"
		Next	
	End If
	
Catch (Exception ex)
	Messagebox("Error", "Exception caught in of_SaveSelection!")
	Return -1
End Try

Return 1
end function

public function integer of_restoreselection (ref datawindow adw_data, string as_idcol, boolean abool_stringid, string as_string);// This function restores the selected rows in a datawindow from a string

// Return 1 for success, -1 for error, 0 for no rows

// Parameters:
// adw_Data - The datawindow
// as_IDCol - The primary key column of the datawindow
// abool_StringID - Indicates if 'as_IDCol' is a string ID (such as userid or so)
// as_String - The source string with all saved info

Integer li_Loop, li_Sel
String ls_Mode

If adw_Data.RowCount() = 0 then Return 0

Try 
	
	ls_Mode = Left(as_String, 1)
	as_String = Right(as_String, Len(as_String) - 1)
	
	If ls_Mode = "U" then
		li_Sel = 1
	ElseIf ls_Mode = "S" then
		li_Sel = 0
	Else
		Return -1
	End If
	
	// Set all to same state
	For li_Loop = 1 to adw_Data.RowCount()
		adw_Data.SetItem(li_Loop, "Sel", li_Sel)
	Next
	
	If as_String = ";" then 
		adw_Data.SetRedraw(True)
		Return 1  // Nothing to select/deselect
	End If
	
	// If string ID
	If abool_StringID Then
		For li_Loop = 1 to adw_Data.RowCount()
			ls_Mode = ";" + adw_Data.GetItemString(li_Loop, as_IDCol) + ";"
			If Pos(as_String, ls_Mode) > 0 then adw_Data.SetItem(li_Loop, "Sel", 1 - li_Sel)
		Next
	Else
		For li_Loop = 1 to adw_Data.RowCount()
			ls_Mode = ";" + String(adw_Data.GetItemNumber(li_Loop, as_IDCol)) + ";"
			If Pos(as_String, ls_Mode) > 0 then adw_Data.SetItem(li_Loop, "Sel", 1 - li_Sel)
		Next	
	End If
	
Catch (Exception ex)
	Messagebox("Error", "Exception caught in of_RestoreSelection!")
	Return -1
End Try

adw_Data.SetRedraw(True)

Return 1
end function

on uo_dwselection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_dwselection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

