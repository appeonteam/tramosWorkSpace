$PBExportHeader$n_matrix.sru
forward
global type n_matrix from nonvisualobject
end type
end forward

global type n_matrix from nonvisualobject
end type
global n_matrix n_matrix

type variables

OLEObject iole_Excel, iole_Workbook, iole_WorkSheet
Integer ii_Version
String is_Inspdate

Datastore ids_matrix
end variables

forward prototypes
private function integer of_populatedatastore (long al_inspid)
public function integer of_importmatrix (string as_excelfile, long al_inspid, string as_inspdate)
private function integer of_initexcel (string as_xlsfile)
end prototypes

private function integer of_populatedatastore (long al_inspid);
Integer li_rc, li_Version, li_Data, li_NewRow
String ls_xlsFile, ls_Path, ls_Data
Decimal ldec_Data

// Init OLE object and datastore
iole_WorkSheet = iole_Workbook.WorkSheets("VIMS")
ids_matrix = Create Datastore
ids_matrix.DataObject = "d_sq_tb_matrix"
ids_matrix.SetTransObject(SQLCA)

// Check for incomplete sheet
li_Data = Integer(iole_WorkSheet.Cells(17, 19).Value)
If li_Data > 0 then
	Messagebox("Import Error", "The matrix data is not complete or has errors. Please check if all data is entered properly.", Exclamation!)
	Return -1
End If

For li_rc = 2 to 16   // These rows hold data
	li_Data = Integer(iole_WorkSheet.Cells(li_rc, 1).Value)  // Rank
	If li_Data < 1500 then
		ls_Data = String(iole_WorkSheet.Cells(li_rc, 18).Value)  // Check for officer
		If ls_Data = "Yes" then 
			ls_Data = String(iole_WorkSheet.Cells(li_rc, 17).Value)  // Error check
			If ls_Data = "Yes" then
				Messagebox("Import Error", "The matrix data is not complete or has errors. Please check if all data is entered properly.", Exclamation!)
				Return -1
			End If
			li_NewRow = ids_matrix.InsertRow(0)
			If li_NewRow > 0 then
				ids_matrix.SetItem(li_NewRow, "Insp_ID", al_inspid)
				ids_matrix.SetItem(li_NewRow, "rank", li_Data)
				li_Data = Integer(iole_WorkSheet.Cells(li_rc, 2).Value)  // Nationality
				ids_matrix.SetItem(li_NewRow, "nationality", li_Data)
				ls_Data = String(iole_WorkSheet.Cells(li_rc, 3).Value)  // coc
				ids_matrix.SetItem(li_NewRow, "coc", ls_Data)
				li_Data = Integer(iole_WorkSheet.Cells(li_rc, 4).Value)  // Country
				ids_matrix.SetItem(li_NewRow, "country", li_Data)
				li_Data = Integer(iole_WorkSheet.Cells(li_rc, 5).Value)  // Admin
				ids_matrix.SetItem(li_NewRow, "accepted", li_Data)
				ls_Data = String(iole_WorkSheet.Cells(li_rc, 6).Value)  // Tanker Cert
				ids_matrix.SetItem(li_NewRow, "tanker_cert", ls_Data)
				li_Data = Integer(iole_WorkSheet.Cells(li_rc, 7).Value)  // STCW Para
				ids_matrix.SetItem(li_NewRow, "stcw_para", li_Data)
				ls_Data = String(iole_WorkSheet.Cells(li_rc, 8).Value)  // Radio
				ids_matrix.SetItem(li_NewRow, "radio", ls_Data)
				ldec_Data = Dec(iole_WorkSheet.Cells(li_rc, 9).Value)  // Operator
				ids_matrix.SetItem(li_NewRow, "operator", ldec_Data)
				ldec_Data = Dec(iole_WorkSheet.Cells(li_rc, 10).Value)  // Rank Experience
				ids_matrix.SetItem(li_NewRow, "rankexp", ldec_Data)
				ldec_Data = Dec(iole_WorkSheet.Cells(li_rc, 11).Value)  // This Tanker
				ids_matrix.SetItem(li_NewRow, "tanker", ldec_Data)			
				ldec_Data = Dec(iole_WorkSheet.Cells(li_rc, 12).Value)  // All Tankers
				ids_matrix.SetItem(li_NewRow, "alltanker", ldec_Data)						
				ldec_Data = Dec(iole_WorkSheet.Cells(li_rc, 13).Value)  // On Vessel
				ids_matrix.SetItem(li_NewRow, "onvsl", ldec_Data)
				ldec_Data = Dec(iole_WorkSheet.Cells(li_rc, 14).Value)  // OOW
				ids_matrix.SetItem(li_NewRow, "oow", ldec_Data)
				li_Data = Integer(iole_WorkSheet.Cells(li_rc, 15).Value)  // Eng Prof
				ids_matrix.SetItem(li_NewRow, "engprof", li_Data)			
				ids_matrix.SetItem(li_NewRow, "Serial", li_NewRow)						
			End If
		End If
	End If
Next

Return 1
end function

public function integer of_importmatrix (string as_excelfile, long al_inspid, string as_inspdate);
/*
This function imports the matrix from an excel sheet into the
VETT_MATRIX table and links it to an Inspection.

Parameters:
as_excelfile: The full path of the matrix excel file
al_inspid:  The inspection ID
as_inspdate: String holding the inspection date (to compare with the matrix date)

Return:
Returns 1 for success -x for failure

Four steps:

1 - Initialize Excel.Application object, open the matrix sheet and verify correct sheet
2 - Import matrix into temp datastore (lds_matrix) using the Excel.Application object
3 - If import is successful, delete any rows from VETT_MATRIX with same INSP_ID
4 - Update the temp datastore

*/

Integer li_Return

SetPointer(HourGlass!)

is_inspdate = as_inspdate

// Step 1
Try
	li_Return = of_initexcel(as_ExcelFile)
Catch (RuntimeError re1)
	MessageBox("Import Error", "An error occured while importing the matrix. Please check that you have opened the correct matrix excel file.~n~nFunction: of_initexcel()", Exclamation!)
	If IsValid(iole_Excel) then 
		iole_Excel.Quit
		Destroy iole_Excel
	End If
	Return -1
End Try

If li_Return < 1 then Return li_Return

// Step 2
Try
	li_Return = of_populatedatastore(al_inspid)
Catch (RuntimeError re2)
	MessageBox("Import Error", "An error occured while importing the matrix. Please check that you have opened the correct matrix excel file.~n~nFunction: of_populatedatastore()", Exclamation!)
	If IsValid(iole_Excel) then iole_Excel.Quit
	Return -1
End Try

iole_excel.Quit   // No need for excel anymore

If li_Return < 1 then Return li_Return

If Messagebox("Confirm Import", String(ids_matrix.RowCount()) + " officers were found. Continue to import the new matrix?", Question!, YesNo!) = 2 then Return 0

//Step 3
Delete From VETT_MATRIX Where INSP_ID = :al_inspid;

If SQLCA.SQLCode < 0 then
	Messagebox("DB Error", "Unable to delete previous matrix.~n~n" + SQLCA.SQLErrtext, Exclamation!)
	Rollback;
	Return -1
End If

// Do not commit the delete yet

// Step 4
If ids_matrix.Update() < 1 then
	Messagebox("DW Error", "Unable to update matrix data.", Exclamation!)
	Rollback;
	Return -1
End If

Commit;   // Everything committed here

Return 1
end function

private function integer of_initexcel (string as_xlsfile);Integer li_rc
Any ls_Data

iole_Excel = Create OLEObject

SetPointer(HourGlass!)

li_rc = iole_Excel.ConnectToNewObject("Excel.Application")
If li_rc < 0 Then 
	Destroy iole_Excel
	Messagebox("OLE Error", "Unable to instantiate Excel OLE Object.", Exclamation!)
	Return -1
End If

iole_Workbook = iole_Excel.Workbooks.Open(as_xlsFile)
iole_WorkSheet = iole_Workbook.WorkSheets("Matrix")

// Authenticate excel sheet
ls_Data = iole_WorkSheet.Cells(2,1).Value
If IsNull(ls_Data) then
	MessageBox("Import Error", "The selected excel file is not a VIMS compatible matrix file or is corrupt.", Exclamation!)
	Return -1
Else
	If Left(String(ls_Data),13) <> "VIMS_VERSION_" then 
		MessageBox("Import Error", "The selected excel file is not a VIMS compatible matrix file or is corrupt.", Exclamation!)
		Return -1		
	End If
End If

ii_Version = Integer(Right(ls_Data, 3))   // Version of excel sheet

If ii_Version < 4 then
	Messagebox("Outdated Version", "The matrix sheet you are using is an obsolete version. Please obtain the latest version of the Officers Matrix Excel sheet.", Exclamation!)
	Return -1
End if

ls_Data = String(Date(iole_WorkSheet.Cells(4,2).Value), "yyyyMMdd")

If ls_Data<>is_inspdate then
	If Messagebox("Date Mismatch", "The date specified in the excel matrix does not match the inspection date.~n~nDo you want to continue with the import?", Question!, YesNo!) = 2 then Return 0
End If

Return 1    //  all okay
end function

on n_matrix.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_matrix.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
Destroy ids_Matrix

Destroy iole_Worksheet
Destroy iole_Workbook
Destroy iole_Excel

end event

