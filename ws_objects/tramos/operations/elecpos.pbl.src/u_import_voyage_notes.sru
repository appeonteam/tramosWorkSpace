$PBExportHeader$u_import_voyage_notes.sru
$PBExportComments$Object including functionality to import, validate and update imported voyage notes
forward
global type u_import_voyage_notes from nonvisualobject
end type
end forward

global type u_import_voyage_notes from nonvisualobject
end type
global u_import_voyage_notes u_import_voyage_notes

type variables
datastore ids_voyage_notes
datastore ids_rejected
datastore ids_update_notes
datastore ids_vessel


end variables

forward prototypes
public function integer of_import_notes ()
public function integer of_validate ()
public function integer of_update ()
public function integer of_clear_datastore ()
public function integer of_setshareon (ref datawindow adw_accepted, ref datawindow adw_rejected)
public function integer of_move_row (ref long al_row_no, ref long al_total_rows)
public function integer of_check_voyage (ref long ll_row_no)
public function integer of_rejected_modified (long al_row, string as_columnname, string as_data)
private subroutine of_voyagenumberchange ()
end prototypes

public function integer of_import_notes ();// This function imports voyage notes into a instance datastore from a tab delimited file,
// specified by the user.

Integer li_return
Integer li_import_result

String ls_null
SetNull(ls_null)

// Clear the data store if previous rows exist?
IF (ids_voyage_notes.RowCount() > 0) OR (ids_rejected.RowCount() > 0) THEN
	IF MessageBox("Warning","There are loaded transactions. Do you want to import a new file ?", Question!,YesNo!) = 1 THEN 
		of_clear_datastore()
	ELSE
		Return 0
	END IF
END IF

ids_vessel = create datastore
ids_vessel.dataObject = "d_sq_tb_find_vessel_nr"
ids_vessel.setTransObject( sqlca )
ids_vessel.retrieve( )

/* Work around for importing file with dialog   */
string docname, named
integer value

value = GetFileOpenName("Select File to Import",  &
	+ docname, named, "TXT",  &
	+ "Text Files (*.TXT),*.TXT")
/* End of work around  */

IF value = 1 THEN 
	li_import_result = ids_rejected.ImportFile(docname)
	ids_rejected.Filter()
END IF

Choose Case li_import_result
	Case 0
		MessageBox("Error","The importfile has to many rows !")
	case -1
		MessageBox("Error","The importfile has no transactions !")
	Case -2
		MessageBox("Error","The importfile specified is empty !")
	case -3
		MessageBox("Error","The argument for the importfile is invalid !")
	case -4
		MessageBox("Error","The input is invalid !")
	case -5
		MessageBox("Error","The importfile could not be opened !")
	case -6
		MessageBox("Error","The importfile could not be closed !")
	case -7
		MessageBox("Error","There has been errors reading the text !")
	case -8
		MessageBox("Error","The importfile is not a textfile !")
	case -9
		MessageBox("Error","The import has been canceled !")
End Choose

IF li_import_result < 1 THEN
	Return -1
Else
	of_voyageNumberChange( )
	ids_voyage_notes.Sort()
	li_return = of_validate()
	IF li_return = -1 THEN Return -1
END IF

Return 1
end function

public function integer of_validate ();
// Find out how many rows to validate. Validation will always be from ids_rejected
long ll_rejected_rows
ll_rejected_rows = ids_rejected.RowCount()

// Return if no rows to validate
IF ll_rejected_rows < 1 THEN 
	Return 1
END IF

// ALSO RETURN IF THERE ARE NO ROWS TO PROCESS
IF (ll_rejected_rows = 0) THEN 
	Return 1
END IF

// Open Progress Window 
open(w_voyage_notes_progress)

// Loop through all transactions
long ll_counter
FOR ll_counter = 1 TO ll_rejected_rows 

	// Check if vessel/voyage OK. If OK move to validated transactions 
	IF (of_check_voyage(ll_counter) = 1) THEN
		of_move_row(ll_counter, ll_rejected_rows)
	END IF
	
	/* Update progress window */
	IF (IsValid(w_voyage_notes_progress)) AND (ll_rejected_rows > 0) THEN
		w_voyage_notes_progress.uo_progress_bar.uf_Set_Position( &
			ll_counter * 100 / ll_rejected_rows &
			)
	END IF
NEXT

IF IsValid(w_voyage_notes_progress) THEN 
	//Close progress window
	close(w_voyage_notes_progress) 
END IF

Return 1
end function

public function integer of_update ();long 			ll_updateable_rows, ll_counter
integer 		li_vessel_nr
string 		ls_voyage_nr, ls_vessel_ref_nr
string 		ls_start_text, ls_end_text
string 		ls_old_voyage_note, ls_new_voyage_note, ls_voyage_note

// Find out how many rows to update. Update will always be from ids_accepted
ll_updateable_rows = ids_voyage_notes.RowCount()

// Return if no rows to update
IF ll_updateable_rows < 1 THEN Return 1

// Open Progress Window 
open(w_voyage_notes_progress)
IF IsValid(w_voyage_notes_progress) THEN w_voyage_notes_progress.st_text.text = "Updating Voyage Notes"

// Initialize text strings
ls_start_text = "~r~nImport " + string(today(), "DD/MM-YYYY") + ": "
ls_end_text = "~r~n"

//Activate UTF8
//execute immediate "set char_convert off";	
FOR ll_counter = 1 TO ll_updateable_rows // Loop through all transactions
	ls_vessel_ref_nr = ids_voyage_notes.GetItemString(ll_counter, "vessel_nr")
	li_vessel_nr = ids_vessel.getItemNumber( ids_vessel.find( "vessel_ref_nr='"+ls_vessel_ref_nr+"'", 1, 999999) , "vessel_nr")
	ls_voyage_nr = ids_voyage_notes.GetItemString(ll_counter, "voyage_nr")
	ls_new_voyage_note = ids_voyage_notes.GetItemString(ll_counter, "note")
	IF IsNull(ls_new_voyage_note) THEN ls_new_voyage_note = ""
	
	IF ids_update_notes.Retrieve(li_vessel_nr, ls_voyage_nr) <> 1 THEN
		//Activate UTF8
		//execute immediate "set char_convert on";	
		ROLLBACK;
		return -1
	END IF
	
	ls_old_voyage_note = ids_update_notes.GetItemString(1, "voyage_notes")
	IF IsNull(ls_old_voyage_note) THEN ls_old_voyage_note = ""
	ls_voyage_note = ls_old_voyage_note + ls_start_text + ls_new_voyage_note + ls_end_text
	ids_update_notes.SetItem(1, "voyage_notes", ls_voyage_note)
	IF ids_update_notes.Update() <> 1 THEN
		//Activate UTF8
		//execute immediate "set char_convert on";	
		ROLLBACK;
		Return -1
	END IF
	
	/* Update progress window */
	IF IsValid(w_voyage_notes_progress) THEN
		w_voyage_notes_progress.uo_progress_bar.uf_Set_Position(ll_counter * 100 / ll_updateable_rows)
	END IF
NEXT

IF IsValid(w_voyage_notes_progress) THEN close(w_voyage_notes_progress) //Close progress window

COMMIT;
//Activate UTF8
//execute immediate "set char_convert on";	

Return 1
end function

public function integer of_clear_datastore ();ids_voyage_notes.Reset()
ids_rejected.Reset()

Return 1
end function

public function integer of_setshareon (ref datawindow adw_accepted, ref datawindow adw_rejected);ids_voyage_notes.ShareData(adw_accepted)
ids_rejected.ShareData(adw_rejected)

Return 1
end function

public function integer of_move_row (ref long al_row_no, ref long al_total_rows);long ll_row

// move validated rows
ll_row = ids_voyage_notes.InsertRow(0)
ids_voyage_notes.Object.Data[ll_row,1,ll_row,3] = ids_rejected.Object.Data[al_row_no,1,al_row_no,3]
ids_rejected.DeleteRow(al_row_no)
al_row_no --
al_total_rows --

Return 1
end function

public function integer of_check_voyage (ref long ll_row_no);string ls_vessel_ref_nr
ls_vessel_ref_nr = ids_rejected.GetItemString(ll_row_no, "vessel_nr")

string ls_voyage_nr
ls_voyage_nr = ids_rejected.GetItemString(ll_row_no, "voyage_nr")



// validate vessel_nr against db vessels
integer li_vessel_nr
SELECT VESSEL_NR
	INTO :li_vessel_nr
	FROM VESSELS
	WHERE VESSEL_REF_NR = :ls_vessel_ref_nr ;

IF SQLCA.SQLCode = 100 THEN  /* Vessel not found */
	ids_rejected.SetItem(ll_row_no, "error_text", "Invalid Vessel ref number")
	COMMIT;
	return -1
END IF

IF SQLCA.SQLCode < 0 THEN /* Something went wrong in database select */
	ids_rejected.SetItem(ll_row_no, "error_text", "Database SELECT error. Contact system administrator")
	COMMIT;
	return -1
END IF



/* Validate vessel_nr against db voyages */
long ll_check_nr 
SELECT VESSEL_NR
	INTO :ll_check_nr
	FROM VOYAGES
	WHERE VESSEL_NR = :li_vessel_nr
	AND VOYAGE_NR = :ls_voyage_nr ;

IF SQLCA.SQLCode = 100 THEN  /* Vessel/voyage not found */
	ids_rejected.SetItem(ll_row_no, "error_text", "Invalid voyage number for this vessel")
	COMMIT;
	return -1
END IF

IF SQLCA.SQLCode = -1 THEN /* Something went wrong in database select */
	ids_rejected.SetItem(ll_row_no, "error_text", "Database SELECT error. Contact system administrator")
	COMMIT;
	Return -1
end if

COMMIT;


// VALIDATE THE REFERENCE NUMBER BEFORE USING IT 
// This validation check was first identified as being needed in 
// dw_rejected.rowfocuschanged(), but it has also 
// been copied out to the object function u_import_voyage_notes.of_check_voyage(), to check the error 
// BEFORE we get to this point. 
integer i_row_vessel_ref_number 
i_row_vessel_ref_number = ids_vessel.find( "vessel_ref_nr='"+ls_vessel_ref_nr+"'", 1, 999999)
if (i_row_vessel_ref_number <= 0) then
	// messagebox("TRAMOS", "Vessel Reference Number (" + string(i_row_vessel_ref_number) +") is not valid." )
	Return -1
end if 


Return 1



end function

public function integer of_rejected_modified (long al_row, string as_columnname, string as_data);/* if the user changes a field this function will change all other similar records */
string 				ls_filter
long					ll_rows, ll_row
s_verify_rejected	lstr_parm

ls_filter = "vessel_nr='"+ids_rejected.getItemString(al_row, "vessel_nr", primary!, true)+"'"
ls_filter += " and voyage_nr='"+ids_rejected.getItemString(al_row, "voyage_nr", primary!, true)+"'"

lstr_parm.as_message = "Please accept that following records are changed. Field="+as_columnName+" changed to="+as_data
lstr_parm.ads_rejected = ids_rejected
lstr_parm.as_filter = ls_filter
lstr_parm.as_columnName = as_columnName
lstr_parm.as_data = as_data
openwithparm(w_verify_change, lstr_parm)
if message.doubleParm = 0 then
	return -1
else
	return 1
end if

end function

private subroutine of_voyagenumberchange ();/* Run through all the imported rows and check the voyage number 
	Find out if voyage number is in old format, and has to be converted
	to "new" format 
	If before 2011 add one digit (ex. T1050->T10050) */

long 		ll_rows, ll_row
string		ls_voyage
integer	li_year

ll_rows = ids_rejected.rowCount()

for ll_row = 1 to ll_rows
	ls_voyage =  ids_rejected.getItemString(ll_row, "voyage_nr")
	ls_voyage = trim(ls_voyage)
	/* if voyage number length 4 or 6 old single or tc-out voyage, add digit */
	if len(ls_voyage) = 4 &
	or len(ls_voyage) = 6  then
		if left(ls_voyage, 1) = "9" then
			li_year = 1900 
		else 
			li_year = 2000
		end if
		li_year += integer(mid(ls_voyage, 1,2))
		if li_year < 2011 then
			ls_voyage = left(ls_voyage,2) +"0"+right(ls_voyage,len(ls_voyage) -2)
			 ids_rejected.setItem(ll_row, "voyage_nr", ls_voyage )
		end if
	end if	
next



end subroutine

on u_import_voyage_notes.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_import_voyage_notes.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_voyage_notes = CREATE datastore
ids_voyage_notes.DataObject = "d_import_notes"

ids_rejected = CREATE datastore
ids_rejected.DataObject = "d_import_notes_rejected"

ids_update_notes = CREATE datastore
ids_update_notes.DataObject = "d_update_notes"
ids_update_notes.SetTransObject(SQLCA)

end event

event destructor;DESTROY ids_voyage_notes
DESTROY ids_rejected
DESTROY ids_update_notes
DESTROY ids_vessel
end event

