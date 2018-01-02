$PBExportHeader$n_inspio.sru
forward
global type n_inspio from nonvisualobject
end type
end forward

global type n_inspio from nonvisualobject autoinstantiate
end type

type prototypes

Private Subroutine GetSystemTime(Ref ustruct_systime lpsystemtime) LIBRARY "KERNEL32.DLL";
end prototypes

forward prototypes
private function integer of_populateitemserial (long al_inspid)
public subroutine of_appendexportchar (long al_inspid, integer ai_source)
public function integer of_attachfromfile (long al_attid, string as_file)
public function integer of_deleteitemdependents (long al_itemid)
public function integer of_postcomments (long al_inspid, string as_commentid)
public function integer of_autofillinsp (long al_inspid, long al_modelid)
public function integer of_importintomobile (string as_filename, integer ai_receiver, long al_imo, string as_temp, ref string as_result)
public function integer of_importintooffice (string as_path, string as_filename, string as_temp, ref integer ai_msgtype, ref string as_id, ref string as_ver, ref string as_info, ref boolean abool_new)
public function boolean of_createglobalid (long al_inspid)
public function long of_getitemidfromserial (long al_inspid, long al_serial)
public function long of_getsmidfromsmtype (long al_inspid, long al_smtypeid)
public function integer of_getattcount (long al_inspid, boolean ab_newonly, boolean ab_headeronly)
public function long of_gettotalattsize (long al_inspid, boolean ab_newonly, boolean ab_headeronly)
public function string of_deletevminspection (long al_inspid)
public function integer of_changeinspectionstatus (long al_inspid, integer ai_newstatus)
public function string of_exportinspection (long al_inspid, integer ai_source, string as_temppath, string as_path, byte ab_includeatt, string as_sender, byte ab_option)
public function boolean of_objexists (long al_objid)
end prototypes

private function integer of_populateitemserial (long al_inspid);// Function to populate empty serial numbers on items in an inspection
// based on the smallest ITEM_ID column.
//
// Returns 1 if successful, -1 if failed


Integer li_Code, li_Serial, li_Count
Datastore lds_Items

// Init datastore
lds_Items = Create Datastore
lds_Items.DataObject = "d_sq_tb_itemserial"
lds_Items.SetTransObject(SQLCA)
li_Code = lds_Items.Retrieve(al_InspID)

If li_Code < 0 then Return -1
 
If li_Code = 0 then Return 1   // No items in inspection

// Populate empty serials
For li_Count = 1 to li_Code
	li_Serial = lds_Items.GetItemNumber(li_Count, 'Serial')
	If IsNull(li_Serial) then lds_Items.SetItem(li_Count, 'Serial', lds_Items.GetItemNumber(li_Count, "calcserial"))
Next 

Return lds_Items.Update()


end function

public subroutine of_appendexportchar (long al_inspid, integer ai_source);// This function appends a character to the LASTEXPORT field of an inspection
// Return nothing (even if it fails)

String ls_Exp, ls_Char

Select LASTEXPORT into :ls_Exp From VETT_INSP Where INSP_ID = :al_InspID;

If SQLCA.SQLCode <> 0 then Return 

Commit;

If ai_Source = 0 then 
	ls_Char = 'O' 
ElseIf ai_Source = 1 then 
	ls_Char = 'V' 
Else 
	ls_Char = 'I'
End If

If IsNull(ls_Exp) then ls_Exp = ls_Char Else ls_Exp += ls_Char

Update VETT_INSP Set LASTEXPORT = :ls_Exp Where INSP_ID = :al_InspID;

If SQLCA.SQLCode <> 0 then Return

Commit;
end subroutine

public function integer of_attachfromfile (long al_attid, string as_file);// This function attaches to file in as_File into the row of table VETT_ATT with ATT_ID = al_Att_ID
// Returns 0 for success and -1 for error

Integer li_FileNum
Blob lblob_File
Long ll_FSize, ll_AttID
n_VimsAtt ln_Att

li_FileNum = Fileopen(as_File, StreamMode!)

If li_FileNum <0 then 
	FileDelete(as_File)
	f_Write2Log("FileOpen Error: " + String(li_FileNum))
	Return -1
End If

ll_FSize = FileReadEx(li_FileNum, lblob_File)

If ll_FSize < 1 then
	FileDelete(as_File)
	f_Write2Log("FileReadEx Error: " + String(ll_FSize))
	Return -1
End If

FileClose(li_FileNum)

ln_Att = Create n_VimsAtt

If ln_Att.of_Connect("") < 1 then 
	Destroy ln_Att
	FileDelete(as_File)
	Return -1	
End If

If ln_Att.of_AddAtt("VETT_ATT", al_AttID, lblob_File, ll_FSize) < 0 then
	ln_Att.of_Commit(False)
	FileDelete(as_File)
	f_Write2Log("of_AttachFromFile Success")
	Destroy ln_Att
	Return -1
End If

ln_Att.of_Commit(True)
Destroy ln_Att

FileDelete(as_File)

Return 0
end function

public function integer of_deleteitemdependents (long al_itemid);// This function deletes all comments and attachments to an item (but not the item itself)

Integer li_sqlcode

// Delete all attachments
Delete from VETT_ATT where ITEM_ID = :al_ItemID;
li_sqlcode = sqlca.sqlcode

// Delete all comment history
If li_sqlcode >= 0 then
	Delete from VETT_ITEMHIST where ITEM_ID = :al_ItemID;
	li_sqlcode = sqlca.sqlcode
End If

If li_sqlcode <> 0 then Return -1

Return 0
end function

public function integer of_postcomments (long al_inspid, string as_commentid);// This function posts comments from items in an inspection
// Returns 0 for success, -1 for failure

String ls_Comment
Integer li_Row, li_Count, li_NewRow
Long ll_TimeStamp
DateTime ldt_UTC
n_myDataStore lds_Hist, lds_Items
ustruct_systime lstruct_UTC

// Get items with comments
lds_Items = Create n_MyDataStore
lds_Items.DataObject = "d_sq_tb_itemcommentpost"
lds_Items.SetTransObject(SQLCA)
li_Count = lds_Items.Retrieve(al_InspID)

If li_Count < 0 then Return -1

If li_Count = 0 then Return 0   // No items with comments

lds_Hist = Create n_MyDatastore
lds_Hist.DataObject = "d_sq_tb_itemhist"
lds_Hist.SetTransObject(SQLCA)

For li_Row = 1 to li_Count
	// Get comment
	ls_Comment = Trim(lds_Items.GetItemString(li_Row, "VslComm"), True)
	
	If Not IsNull(ls_Comment) And (ls_Comment > "") then
	
		// Insert history item
		li_NewRow = lds_hist.InsertRow(0)
		If li_NewRow < 1 then Return -1
		
		// Get UTC and timestamp
		GetSystemTime(lstruct_UTC)
		ldt_UTC = DateTime(Date(lstruct_UTC.wyear, lstruct_UTC.wmonth, lstruct_UTC.wday), Time(lstruct_UTC.whour, lstruct_UTC.wMinute, 0))
		ll_TimeStamp = f_GetTimeStamp()
	
		// Check for unique TimeStamp
		If lds_Items.GetItemNumber(li_Row,"MaxTime") >= ll_TimeStamp Then ll_TimeStamp = lds_Items.GetItemNumber(li_Row,"MaxTime") + 1	
	
		// Populate history
		lds_hist.SetItem(li_NewRow, "Time_ID", ll_TimeStamp)
		lds_hist.SetItem(li_NewRow, "Item_ID", lds_Items.GetItemNumber(li_Row, "Item_ID"))
		lds_hist.SetItem(li_NewRow, "Status", 1)
		lds_hist.SetItem(li_NewRow, "Hist_Type", 0)
		lds_hist.SetItem(li_NewRow, "utc", ldt_UTC)
		lds_hist.SetItem(li_NewRow, "origin", as_CommentID)
		lds_hist.SetItem(li_NewRow, "Data", ls_Comment)
	End If
Next

If lds_Hist.Update( ) = 1 then
	For li_Row = 1 to li_Count
		SetNull(ls_Comment)
		lds_Items.SetItem(li_Row, "VslComm", ls_Comment)
	Next
	If lds_Items.Update( ) < 1 then Return -1
Else
	Return -1
End If
Return 0
end function

public function integer of_autofillinsp (long al_inspid, long al_modelid);
// This function fills up an empty inspection with all questions from the model

// Parameter:
// al_InspID - Inspection ID
// al_ModelID - Model ID

// Return Value:
// 0 - All okay
// -x - Error

Datastore lds_AutoFill
String ls_Data
Integer li_Ret, li_Loop, li_Risk
Long ll_ObjID

lds_AutoFill = Create Datastore

lds_AutoFill.DataObject = "d_sq_tb_autofill"
lds_AutoFill.SetTransObject(SQLCA)
li_Ret = lds_AutoFill.Retrieve(al_modelid)

If li_Ret < 1 then Return -1

SetNull(ls_Data)		
For li_Loop = 1 to li_Ret
	ll_ObjID = lds_AutoFill.GetItemNumber(li_Loop, "Obj_ID")
	li_Risk = lds_AutoFill.GetItemNumber(li_loop, "DefRisk")
	Insert Into VETT_ITEM(INSP_ID, OBJ_ID, ANS, DEF, REPORT, RISK, CLOSED, CLOSEDATE, INSPCOMM) Values (:al_inspid, :ll_ObjID, 0, 0, 0, :li_Risk, 1, '2000-01-01', :ls_Data);

	If SQLCA.SQLCode <> 0 then 
		Rollback;
		Return -1
	End If
Next

Commit;

Return 0
end function

public function integer of_importintomobile (string as_filename, integer ai_receiver, long al_imo, string as_temp, ref string as_result);Integer li_Temp, li_Count, li_Err, li_Source
String ls_Temp, ls_Sender, ls_GlobalID
Long ll_InspID, ll_Temp
n_myDataStore lds_Import, lds_Update
n_filepackage lnvo_pack
Boolean lb_Error, lb_Logging = True    // Enable logging only during debugging. Turn off before deployment

SetPointer(HourGlass!)

// Check if models exist
Select Count(*) into :li_Temp from VETT_INSPMODEL;
If (SQLCA.SQLCode<0) or li_Temp = 0 then
	If lb_Logging then f_Write2Log("of_ImportIntoMobile > Fail: No Models found")
	Return -1
End If

Commit;  // Commit everything and start new trans

// Unpack files
li_Temp = lnvo_pack.UnPackfiles(as_FileName, as_Temp)
If li_Temp < 0 then 
	Messagebox("File Error", "Inspection package could not be unpacked.", Exclamation!)
	If lb_Logging then f_Write2Log("lnvo_pack.unpackfiles() Fail: " + String(li_Temp))
	Return li_Temp
End If

Boolean lbool_Replace

// First, check if package is an inspection
li_Temp = FileOpen (as_Temp + 'IN_ID.vdbxp', LineMode!, Read!, LockReadWrite!, Replace!, EncodingUTF8!)
If (li_Temp <= 0) then
	ls_Temp = "Could not verify Inspection ID File"
	lb_Error = True
	If lb_Logging then f_Write2Log("Opening in_id.vdbxp returned " + String(li_Temp))
Else
	FileReadEx(li_Temp, ls_Temp)
	If ls_Temp <> "Inspection Package" then
		ls_Temp = "Invalid Inspection Package"
		lb_Error = True
	End If
	If Not lb_Error then
		FileReadEx(li_Temp, ls_Temp)
		FileReadEx(li_Temp, ls_Temp)
		FileReadEx(li_Temp, ls_Temp)
		li_Source = Integer(Right(ls_Temp, 1))  // Source of inspection
		FileReadEx(li_Temp, ls_Temp)
		ls_Sender = Right(ls_Temp, Len(ls_Temp) - 8)
		If FileReadEx(li_Temp, ls_Temp)>0 then   // If file has replace att option
			lbool_Replace = Right(ls_Temp, 1) = "1"
		End If
		If li_Source = ai_Receiver then
			lb_Error = True
			ls_Temp = "This inspection was exported by a VIMS Mobile Client of the same type."
		End If
		If ls_Sender = "" then 
			lb_Error = True
			ls_Temp = "Could not verify sender's identity."
		End If
	End If
End If
FileClose(li_Temp)
FileDelete(as_Temp + 'IN_ID.vdbxp')

// Create the DataStore
lds_Import = Create n_myDatastore
lds_Update = Create n_myDatastore

// Import the Inspection Header
If Not lb_Error Then
	// Select correct DS based on export and then import (even though both are identical in structure, updated fields are different)
	If li_Source = 0 then lds_Import.DataObject = "d_sq_tb_inspio_header_officeexp" else lds_Import.DataObject = "d_sq_tb_inspio_header_mobileexp"
	li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'header.vdbxp')
	If li_Temp<>1 then 
		ls_Temp = "Inspection header import failed"
		lb_Error = True	
	End If
	If Not lb_Error then  
		
		// Correct string columns for XML bug
		f_restore_cr_after_xml_import(lds_Import, "remarks")
		f_restore_cr_after_xml_import(lds_Import, "summary")
		SetNull(ls_Temp)
		
		// Erase lastexport if from office
		If lds_Import.GetItemNumber(1, "Status") = 3 then lds_Import.SetItem(1, "LastExport", ls_Temp)
	End If
End If
FileDelete(as_Temp + 'header.vdbxp')

// Try to see if inspection already exists. If not, create
If Not lb_Error Then
	
	ls_GlobalID = lds_Import.GetItemString(1, "GlobalID")	
	// Try to find the inspection using GlobablID
	Select INSP_ID Into :ll_InspID From VETT_INSP Where GLOBALID = :ls_GlobalID;
	
	// If SQL error
	If SQLCA.SQLCode < 0 then
		lb_Error = True
		ls_Temp = "SQL failed trying to find inspection"
	End If
	
	If SQLCA.SQLCode <> 100 and Not lb_Error then  // If inspection was found
		ls_Temp = "Update"		// Set flag to update inspection
		If lbool_Replace then   // If inspection needs to be replaced
			ls_Temp = of_DeleteVMInspection(ll_InspID)   // Delete inspection
			If ls_Temp = "" then ls_Temp = "New" Else lb_Error = True
		End If
	Else
		If Not lb_Error then ls_Temp = "New"
	End If
	
	If lb_Logging then f_Write2Log("ls_Temp: " + ls_Temp)
	
	If ls_Temp = "New" then   // If not found
    	lds_Update.DataObject = "d_sq_tb_inspio_header_mobileimp"
		lds_Update.SetTransObject(SQLCA)
		lds_Update.Object.Data[1,1,1,25] = lds_Import.Object.Data[1,1,1,25]  // Transfer data
		If IsNull(lds_Update.GetItemString(1, "Port")) then lds_Update.SetItem(1, "Port", "") // Check for null Port
		ll_Temp = lds_Update.GetItemNumber(1, 'VesselIMO')
		
		// Check if DB Issue matches. Issue a warning if not...
		f_Config("DBVR", ls_Temp, 0)
		li_Temp = lds_Update.GetItemNumber(1, 'DBIssue')
		
		// Warning disabled because people think it is an error
		//If li_Temp > Integer(ls_Temp) then Messagebox("Import Warning", "The inspection was exported using DB Issue " + String(li_Temp) + ". This VIMS Mobile Installation is using DB issue " + ls_Temp + ".~n~nThere is a chance that the import might fail.")
		
		If ai_receiver = 2 then // If inspector, check if vessel exists
			Select VESSEL_NAME Into :ls_Temp From VESSELS Where IMO_NUMBER = :ll_Temp and VESSEL_ACTIVE>0;
			If SQLCA.SQLCode <> 0 then
				lb_Error = True
				ls_Temp = "Could not find vessel with IMO No. " + String(ll_Temp) + " in database."
			End If
		Else  // If vessel, check if IMO is not same
			If ll_Temp <> al_IMO then
				lb_Error = True
				ls_Temp = "The IMO number in the inspection (" + String(ll_Temp) + ") does not match this vessel's IMO Number (" + String(al_IMO) + ")"
			End If
		End If
		
		If Not lb_Error then 
			// Create Inspection
			If lds_Update.Update( ) < 1 then
				lb_Error = True
				ls_Temp = "The inspection header could not be created."
			Else
				
//				Select Max(INSP_ID) Into :ll_InspID From VETT_INSP;
				ll_InspID = lds_Update.GetItemNumber(1, "Insp_ID")
				If (ll_InspID <= 0) or Isnull(ll_InspID) then 
					lb_Error = True
					ls_Temp = "Could not retrieve the inspection identity."
				End If
				
				// Create Summaries (if exists)
				If FileExists(as_Temp + 'summaries.vdbxp') and not lb_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_summaries"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.ImportFile(XML!, as_Temp + 'summaries.vdbxp')
					If li_Temp < 1 then
						lb_Error = True
						ls_Temp = "Could not import inspection summaries."
					Else
						f_restore_cr_after_xml_import(lds_Update, "sm_text")
						For li_Temp = 1 to lds_Update.RowCount( )
							lds_Update.SetItem(li_Temp, 'insp_id', ll_InspID)
						Next					
						If lds_Update.Update( )<1 then
							lb_Error = True
							ls_Temp = "Could not update inspection summaries."
						End If
					End If
					FileDelete(as_Temp + 'summaries.vdbxp')	
				End If			
				
				// Create Matrix (if exists)
				If FileExists(as_Temp + 'matrix.vdbxp') and not lb_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_matrix"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.ImportFile(XML!, as_Temp + 'matrix.vdbxp')
					If li_Temp < 1 then
						lb_Error = True
						ls_Temp = "Could not import officer matrix."
					Else
						For li_Temp = 1 to lds_Update.RowCount( )
							lds_Update.SetItem(li_Temp, 'insp_id', ll_InspID)
							lds_Update.SetItem(li_Temp, 'Serial', li_Temp)
						Next
						If lds_Update.Update( )<1 then
							lb_Error = True
							ls_Temp = "Could not update officer matrix."
						End If
					End If
					FileDelete(as_Temp + 'matrix.vdbxp')	
				End If						
				
				// Create Items
				If FileExists(as_Temp + 'items.vdbxp') and not lb_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_items"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.ImportFile(XML!, as_Temp + 'items.vdbxp')
					If li_Temp < 1 then
						lb_Error = True
						ls_Temp = "Could not import items."
					Else
						f_restore_cr_after_xml_import(lds_Update, "inspcomm")
						f_restore_cr_after_xml_import(lds_Update, "owncomm")
						f_restore_cr_after_xml_import(lds_Update, "followup")
						// If this is a non-MIRE insp, then insert a ghost item
						If lds_Update.Rowcount( )<50 then 
							Insert into VETT_ITEM(INSP_ID, ANS) Values (:ll_InspID, Null);
						End If						
						// Update InspID for all items
						For li_Temp = 1 to lds_Update.RowCount( )
							lds_Update.SetItem(li_Temp, 'insp_id', ll_InspID)
						Next
						// Try and update
						If lds_Update.Update( )<1 then
							lb_Error = True
							ls_Temp = "Could not update items."
						End If
					End If
					FileDelete(as_Temp + 'items.vdbxp')	
				End If						
				// Note: lds_Update now has Item_IDs inside and is used below for Item Comments & Attachments
				
				// Create Item Comments
				If FileExists(as_Temp + 'comments.vdbxp') and not lb_Error then
					lds_Import.DataObject = "d_sq_tb_inspio_itemcomments"
					lds_Import.SetTransObject(SQLCA)
					li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'comments.vdbxp')
					If li_Temp < 1 then
						lb_Error = True
						ls_Temp = "Could not import item comments."
					Else
						f_restore_cr_after_xml_import(lds_Import, "histdata")
						// Find and populate ItemID using lds_Update
						For li_Temp = 1 to lds_Import.RowCount( )
							ll_Temp = lds_Update.Find('serial = ' + String(lds_Import.GetItemNumber(li_Temp, 'serial')), 0, lds_Update.RowCount( ))
							If ll_Temp > 0 then 
								ll_Temp = lds_Update.GetItemNumber(ll_Temp, 'Item_ID')
								lds_Import.SetItem(li_Temp, 'item_id', ll_Temp)								
							Else
								lb_Error = True
								ls_Temp = "Item Comments could not be matched to items."
							End If
						Next
						If not lb_Error then
							If lds_Import.Update( )<1 then
								lb_Error = True
								ls_Temp = "Could not update item comments."
							End If
						End If
					End If
					FileDelete(as_Temp + 'comments.vdbxp')	
				End If						
				
				// Create Attachments
				If FileExists(as_Temp + 'attlist.vdbxp') and not lb_Error then
					lds_Import.DataObject = "d_sq_tb_inspio_att"
					lds_Import.SetTransObject(SQLCA)
					li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'attlist.vdbxp')
					If li_Temp < 1 then
						lb_Error = True
						ls_Temp = "Could not import attachment list."
					Else
						// If only dummy attachment is there, then remove it
						If li_Temp = 1 then
							If lds_Import.GetItemString(1, "FileName") = "Dummy_Attachment" and lds_Import.GetItemNumber(1, "FileSize") = 0 then lds_Import.DeleteRow(1)
						End If
						
						SetNull(ll_Temp)
						For li_Temp = 1 to lds_Import.RowCount( ) 
							lds_Import.SetItem(li_Temp, 'vett_att_insp_id', ll_InspID) // Set all InspID
							lds_Import.SetItem(li_Temp, 'VimsID', lds_Import.GetItemNumber(li_Temp, 'Att_ID')) // Transfer Att_ID to VimsID
							lds_Import.SetItem(li_Temp, 'Att_ID', ll_Temp)   // Must set all Att_ID to null to allow identity key refresh after calling Update()
						Next
						For li_Temp = 1 to lds_Import.RowCount( ) // Set all Item_ID
							If Not IsNull(lds_Import.GetItemNumber(li_Temp, 'Serial')) Then								
								ll_Temp = lds_Update.Find("Serial = " + String(lds_Import.GetItemNumber(li_Temp, 'Serial')), 1, lds_Update.RowCount())
								If ll_Temp > 0 then
									ll_Temp = lds_Update.GetItemNumber(ll_Temp, "Item_ID")
									lds_Import.SetItem(li_Temp, 'vett_att_item_id', ll_Temp)
								End If
							End If
						Next
						lds_Update.DataObject = "d_sq_tb_inspio_summaries"
						lds_Update.SetTransObject(SQLCA)
						lds_Update.Retrieve(ll_InspID)
						For li_Temp = 1 to lds_Import.RowCount( ) // Set all SM_ID
							If Not IsNull(lds_Import.GetItemNumber(li_Temp, 'SMType_ID')) Then								
								ll_Temp = lds_Update.Find("SMType_ID = " + String(lds_Import.GetItemNumber(li_Temp, 'SMType_ID')), 1, lds_Update.RowCount())
								If ll_Temp > 0 then
									ll_Temp = lds_Update.GetItemNumber(ll_Temp, "SM_ID")
									lds_Import.SetItem(li_Temp, 'vett_att_sm_id', ll_Temp)
								End If
							End If
						Next
						If lds_Import.Update( ) < 1 then
							lb_Error = True
							ls_Temp = "Attachments not updated."
						End If					
						If Not lb_Error then  // Attach the actual files
							For li_Temp = lds_Import.RowCount() to 1 Step -1
								ll_Temp = lds_Import.GetItemNumber(li_Temp, "Att_ID")
								ls_Temp = "Att" + String(lds_Import.GetItemNumber(li_Temp, "VimsID")) + ".vdbxp"
								If FileExists(as_Temp + ls_Temp) then
									If of_AttachFromFile(ll_Temp, as_Temp + ls_Temp)<0 then
										MessageBox("Attachment Error", "File attachment '" + lds_Import.GetItemString(li_Temp, "FileName") + "' could not be imported. This attachment will be removed.")
										lds_Import.DeleteRow(li_Temp)
									End If
									FileDelete(as_Temp + ls_Temp)
								Else
									lds_Import.DeleteRow(li_Temp)
								End If
								If li_Source > 0 then lds_Import.SetItem(li_Temp, "VimsID", 0)  // Very Imp. If importing from another VM, set VimsID to zero to allow for later VIMS sync
							Next
						End If
						lds_Import.Update( )
						FileDelete(as_Temp + 'attlist.vdbxp')	
					End If						
				End If
			End If
		End If
		
	ElseIf (ls_Temp = "Update") then  // If inspection already exists, synchronize all

		If li_Source > 0 then    // Reject if inspection is being updated by another VM
			lb_Error = True
			ls_Temp = "Existing inspection cannot be updated by an export from another VIMS Mobile installation."
		End If

		// Update Header
		If Not lb_Error then
			lds_Update.DataObject = "d_sq_tb_inspio_header_mobileimp"
			lds_Update.SetTransObject(SQLCA)
			lds_Update.Object.Data[1,1,1,25] = lds_Import.Object.Data[1,1,1,25]  // Transfer data
			li_Temp = lds_Update.SetItemStatus( 1, 0, Primary!, DataModified!)  // Set entire row
			li_Temp = lds_Update.SetItem( 1, "Insp_ID", ll_InspID)  // Set the insp ID
			li_Temp = lds_Update.SetItemStatus( 1, "Insp_ID", Primary!, NotModified!)		
			If IsNull(lds_Update.GetItemString(1, "Port")) then lds_Update.SetItem(1, "Port", "") // Check for null port
			For li_Temp = 1 to 25  // Set 1st 25 columns to modified
				lds_Update.SetItemStatus(1, li_Temp, Primary!, DataModified!)
			Next
			If lds_Update.Update() < 1 then  // update header
				lb_Error = True
				ls_Temp = "Could not update the inspection header"
			End If		
		End If
		
		// Replace Summaries (if exists)
		If FileExists(as_Temp + 'summaries.vdbxp') and not lb_Error then
			lds_Import.DataObject = "d_sq_tb_inspio_summaries"
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'summaries.vdbxp')
			If li_Temp < 1 then
				Messagebox("Warning", "Could not update the inspection summary section.")
			Else
				f_restore_cr_after_xml_import(lds_Import, "sm_text")  // XML Bug
				lds_Update.DataObject = "d_sq_tb_inspio_summaries"
				lds_Update.SetTransObject(SQLCA)
				li_Temp = lds_Update.Retrieve(ll_InspID)
				If li_Temp < 0 then	  // Error retrieving
					lb_Error = True
					ls_Temp = "Could not retrieve existing summaries."
				ElseIf li_Temp = 0 then   // If no summaries, create new ones
					lds_Import.SetTransObject(SQLCA)
					For li_Temp = 1 to lds_Import.RowCount()
						lds_Import.SetItem(li_Temp, "Insp_ID", ll_InspID)
					Next
					If lds_Import.Update( )<1 then
						lb_Error = True
						ls_Temp = "Could not update inspection summaries."
					End If					
				Else   //  Existing summaries
					For li_Temp = 1 to lds_Update.RowCount()  
						// If ID is matching (should be)
						If lds_Update.GetItemNumber(li_Temp, "smtype_id") = lds_Import.GetItemNumber(li_Temp, "smtype_id") then
							// If both in text are not null
							If Not (IsNull(lds_Update.GetItemString(li_Temp, "sm_text")) Or IsNull(lds_Import.GetItemString(li_Temp, "sm_text"))) Then
								If lds_Update.GetItemString(li_Temp, "sm_text") <> lds_Import.GetItemString(li_Temp, "sm_text") Then lds_Update.SetItem(li_Temp, "sm_text", lds_Import.GetItemString(li_Temp, "sm_text"))
							Else // One or both are null
								// If only 1 is null
								If Not (IsNull(lds_Update.GetItemString(li_Temp, "sm_text")) Or IsNull(lds_Import.GetItemString(li_Temp, "sm_text"))) Then lds_Update.SetItem(li_Temp, "sm_text", lds_Import.GetItemString(li_Temp, "sm_text"))
							End If
							// If stars in both are not null
							If Not (IsNull(lds_Update.GetItemNumber(li_Temp, "stars")) Or IsNull(lds_Import.GetItemNumber(li_Temp, "stars"))) Then
								If lds_Update.GetItemNumber(li_Temp, "stars") <> lds_Import.GetItemNumber(li_Temp, "stars") Then lds_Update.SetItem(li_Temp, "stars", lds_Import.GetItemNumber(li_Temp, "stars"))
							Else // One or both are null
								// If only 1 is null
								If Not (IsNull(lds_Update.GetItemNumber(li_Temp, "stars")) And IsNull(lds_Import.GetItemNumber(li_Temp, "stars"))) Then lds_Update.SetItem(li_Temp, "stars", lds_Import.GetItemNumber(li_Temp, "stars"))
							End If							
						End If
					Next
					If lds_Update.Update( )<1 then
						lb_Error = True
						ls_Temp = "Could not update inspection summaries."
					End If
				End If
			End If
			FileDelete(as_Temp + 'summaries.vdbxp')					
		End If			
		
		// Replace Matrix (if exists)
		If FileExists(as_Temp + 'matrix.vdbxp') and not lb_Error then
			lds_Import.DataObject = "d_sq_tb_inspio_matrix"
			lds_Import.SetTransObject(SQLCA)
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'matrix.vdbxp')
			If li_Temp < 1 then
				Messagebox("Warning", "Could not update the inspection matrix.")
			Else
				lds_Update.DataObject = "d_sq_tb_inspio_matrix"
				lds_Update.SetTransObject(SQLCA)
				li_Temp = lds_Update.Retrieve(ll_InspID)
				If li_Temp < 0 then	  // Error retrieving
					lb_Error = True
					ls_Temp = "Could not retrieve existing matrix."
				Else   // If no matrix, create new ones
					Do While lds_Update.Rowcount( ) > 0
						lds_Update.DeleteRow(1)
					Loop
					If lds_Update.Update( ) < 1 then
						lb_Error = True
						ls_Temp = "Could not clear existing matrix."
					End If
					For li_Temp = 1 to lds_Import.RowCount()
						lds_Import.SetItem(li_Temp, "Insp_ID", ll_InspID)
						lds_Import.SetItem(li_Temp, "Serial", li_Temp)						
					Next
					If Not lb_Error then
						If lds_Import.Update( )<1 then
							lb_Error = True
							ls_Temp = "Could not update inspection matrix."
						End If
					End If
				End If
			End If
			FileDelete(as_Temp + 'matrix.vdbxp')					
		End If			
		
		// Get Items and update them
		If FileExists(as_Temp + 'items.vdbxp') and not lb_Error then
			lds_Import.DataObject = "d_sq_tb_inspio_items"
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'items.vdbxp')
			If li_Temp < 1 then
				lb_Error = True
				ls_Temp = "Could not import items."
			Else
				f_restore_cr_after_xml_import(lds_Import, "inspcomm")  // XML Bug
				f_restore_cr_after_xml_import(lds_Import, "owncomm") 
				f_restore_cr_after_xml_import(lds_Import, "followup")
				lds_Update.DataObject = "d_sq_tb_inspio_items"
				lds_Update.SetTransobject(SQLCA)
				If lds_Update.Retrieve(ll_InspID) >= 0 then  // Get current items
					
					// Find items that have been deleted
					li_Count = 1
					Do While (li_Count <= lds_Update.RowCount()) and Not lb_Error
						li_Temp = lds_Import.Find("Serial = " + String(lds_Update.GetItemNumber(li_Count, "Serial")), 0, lds_Import.RowCount())
						If li_Temp = 0 then // If not found
							If of_DeleteItemDependents(lds_Update.GetItemNumber(li_Count, "Item_ID")) = 0 then
								lds_Update.DeleteRow(li_Count)
							Else // Could not delete dependents
								lb_Error = True
								ls_Temp = "Error deleting item dependents"
							End If
						ElseIf li_Temp < 0 then
							lb_Error = True
							ls_Temp = "Error in item serial search"
						Else
							li_Count ++
						End If
					Loop
					
					// Sync items
					If Not lb_Error Then
						For li_Count = 1 to lds_Update.RowCount()
							If lds_Update.GetItemNumber(li_Count, "Serial") = lds_Import.GetItemNumber(li_Count, "Serial") then
								For li_Temp = 1 to 18
									// Both are non-null
									If Not (IsNull(lds_Import.Object.Data[li_Count, li_Temp]) Or IsNull(lds_Update.Object.Data[li_Count, li_Temp])) then
										If lds_Import.Object.Data[li_Count, li_Temp] <> lds_Update.Object.Data[li_Count, li_Temp] then
											lds_Update.Object.Data[li_Count, li_Temp] = lds_Import.Object.Data[li_Count, li_Temp]
											lds_Update.SetItemStatus(li_Count, li_Temp, Primary!, DataModified!)										
										End If										
									Else
										// If either one is null
										If Not (IsNull(lds_Import.Object.Data[li_Count, li_Temp]) And IsNull(lds_Update.Object.Data[li_Count, li_Temp])) then
											lds_Update.Object.Data[li_Count, li_Temp] = lds_Import.Object.Data[li_Count, li_Temp]
											lds_Update.SetItemStatus(li_Count, li_Temp, Primary!, DataModified!)																														
										End If
									End If
								Next
							Else
								lb_Error = True
								ls_Temp = "Item serial number mismatch"							
							End If
						Next
					End If
					
					// Check and add any new items
					If Not lb_Error then
						li_Temp = lds_Update.Rowcount( ) + 1
						For li_Count = li_Temp to lds_Import.RowCount( )
							lds_Update.InsertRow(0)
							lds_Update.Object.Data[li_Count, 1, li_Count, 18] = lds_Import.Object.Data[li_Count, 1, li_Count, 18]
							lds_Update.SetItem(li_Count, "Insp_ID", ll_InspID)
						Next	
						If lds_Update.Update( ) < 1 then
							lb_Error = True
							ls_Temp = "Could not update new items"						
						End If
					End If
				Else
					lb_Error = True
					ls_Temp = "Could not retrieve existing items"
				End If				
			End If
			FileDelete(as_Temp + 'items.vdbxp')	
		End If						

        //Update Item Comments		
		If FileExists(as_Temp + 'comments.vdbxp') and not lb_Error then
			lds_Import.DataObject = "d_sq_tb_inspio_itemcomments"
			lds_Import.SetTransObject(SQLCA)
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'comments.vdbxp')
			If li_Temp < 1 then
				lb_Error = True
				ls_Temp = "Could not import item comments."
			Else
				f_restore_cr_after_xml_import(lds_Import, "histdata")  // XML Bug
				// Find and populate ItemID using lds_Update
				For li_Temp = 1 to lds_Import.RowCount( )
					ll_Temp = lds_Update.Find('Serial = ' + String(lds_Import.GetItemNumber(li_Temp, 'Serial')), 0, lds_Update.RowCount( ))
					If ll_Temp > 0 then 
						ll_Temp = lds_Update.GetItemNumber(ll_Temp, 'Item_ID')
						lds_Import.SetItem(li_Temp, 'Item_id', ll_Temp)
					Else
						lb_Error = True
						ls_Temp = "Item Comments could not be matched to items."
					End If
				Next
				// Retrieve existing comments
				If Not lb_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_itemcomments"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.Retrieve(ll_InspID)
					If li_Temp < 0 then
						lb_Error = True
						ls_Temp = "Existing Item Comments could not be retrieved."						
					End If
				End If
				// Mark existing comments as NotModified!
				If Not lb_Error then
					For li_Temp = 1 to lds_Import.Rowcount( )
						ll_Temp = lds_Import.GetItemNumber(li_Temp, "Item_ID")
						ll_Temp = lds_Import.GetItemNumber(li_Temp, "Time_ID")
						If lds_Update.Find("Time_ID = " + String(ll_Temp) + " And Item_ID = " + String(lds_Import.GetItemNumber(li_Temp, "Item_ID")), 1, lds_Update.RowCount()) > 0 then 
							lds_Import.SetItemStatus(li_Temp, 0, Primary!, NotModified!)
						End If
					Next
					If lds_Import.Update( ) < 1 then
						lb_Error = True
						ls_Temp = "Could not update item comments."
					End If
				End If
			End If			
			FileDelete(as_Temp + 'comments.vdbxp')
		End If							

		// Sync Attachments
		If FileExists(as_Temp + 'attlist.vdbxp') and not lb_Error then
			lds_Import.DataObject = "d_sq_tb_inspio_att"
			lds_Import.SetTransObject(SQLCA)
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'attlist.vdbxp')
			
			If li_Temp < 1 then
				lb_Error = True
				ls_Temp = "Could not import attachment list."
			End If
			
			// If only dummy attachment is there, then remove it
			If li_Temp = 1 then
				If lds_Import.GetItemString(1, "FileName") = "Dummy_Attachment" and lds_Import.GetItemNumber(1, "FileSize") = 0 then lds_Import.DeleteRow(1)
			End If
			
			If Not lb_Error then
											
				// Retrieve existing attachments
				lds_Update.DataObject = "d_sq_tb_inspio_att"
				lds_Update.SetTransObject(SQLCA)
				lds_Update.Retrieve(ll_InspID)
				
				// Synchronization
				Integer li_Found
				String ls_Filter
				For li_Temp = 1 to lds_Import.RowCount()
					li_Found = lds_Update.Find("vimsid=" + String(lds_Import.GetItemNumber(li_Temp, "Att_ID")), 1, lds_Update.RowCount())
					If li_Found>0 then  // Found by Att_ID
						lds_Update.SetItem(li_Found, "FileName", lds_Import.GetItemString(li_Temp, "FileName"))						
					Else  // If not found, try searching by filename & size (also make sure VIMSID is not set)
						ls_Filter = "VimsID=0 and FileName='" + String(lds_Import.GetItemString(li_Temp, "FileName")) + "' and FileSize=" + String(lds_Import.GetItemNumber(li_Temp, "FileSize"))
						If Not IsNull(lds_Import.GetItemNumber(li_Temp, "Serial")) then ls_Filter += " and Serial=" + String(lds_Import.GetItemNumber(li_Temp, "Serial"))
						If Not IsNull(lds_Import.GetItemNumber(li_Temp, "SmType_ID")) then ls_Filter += " and SmType_Id=" + String(lds_Import.GetItemNumber(li_Temp, "SMType_ID"))
						li_Found = lds_Update.Find(ls_Filter, 1, lds_Update.RowCount())
						If li_Found>0 then  // If found, save VIMS AttID
							If li_Source = 0 then lds_Update.SetItem(li_Found, "VimsID", lds_Import.GetItemNumber(li_Temp, "Att_ID"))
						Else  // If Item was not found (must be a new attachment), create new att only if file exists
							li_Found = lds_Update.InsertRow(0)
							If li_Found>0 then
								lds_Update.SetItem(li_Found, "vett_att_insp_id", ll_InspID)
								lds_Update.SetItem(li_Found, "FileName", lds_Import.GetItemString(li_Temp, "FileName"))
								lds_Update.SetItem(li_Found, "FileSize", lds_Import.GetItemNumber(li_Temp, "FileSize"))
								lds_Update.SetItem(li_Found, "VimsID", lds_Import.GetItemNumber(li_Temp, "Att_ID"))
								If Not IsNull(lds_Import.GetItemNumber(li_Temp, "Serial")) then lds_Update.SetItem(li_Found, "Vett_Att_Item_ID", of_GetItemIDFromSerial(ll_InspID, lds_Import.GetItemNumber(li_Temp, "Serial")))
								If Not IsNull(lds_Import.GetItemNumber(li_Temp, "SmType_ID")) then lds_Update.SetItem(li_Found, "Vett_Att_Sm_ID", of_GetsmIDFromSmType(ll_InspID, lds_Import.GetItemNumber(li_Temp, "SmType_ID")))
							End If							
						End If
					End If
				Next 
				
				// At this point all items in lds_Update should have the VIMS "AttID" in the "VimsID" column
				// If there are any without, they should be deleted.
				li_Temp = lds_Update.RowCount()
				Do While li_Temp>0
					If lds_Update.GetItemNumber(li_Temp, "VimsID") = 0 then lds_Update.DeleteRow(li_Temp)
					li_Temp --
				Loop
				
				// Now, we delete any attachments that are not present in the imported list (meaning they were deleted in VIMS)
				li_Temp = lds_Update.RowCount()
				Do While li_Temp > 0 
					ll_Temp = lds_Update.GetItemNumber(li_Temp, "VimsID")
					li_Found = lds_Import.Find("Att_ID = " + String(ll_Temp), 1, lds_Import.RowCount( ))
					If li_Found<1 then lds_Update.DeleteRow(li_Temp)
					li_Temp --
				Loop
				
				// Save lds_Update
				If lds_Update.Update() < 0 then
					ls_Temp = "Unable to save attachments meta-info"
					lb_Error = True
				End If
						
				// Import the physical files (if present)				
				For li_Temp = 1 to lds_Import.RowCount()						
					
					// Get sender's AttID and create file name
					ll_Temp = lds_Import.GetItemNumber(li_Temp, "Att_ID")					
					ls_Temp = "Att" + String(ll_Temp) + ".vdbxp"
					
					// Find local attachment with matching VimsID to import into
					li_Found = lds_Update.Find("VimsID=" + String(ll_Temp), 1, lds_Update.RowCount())
					
					// If local record exists and file exists, then import
					If li_Found > 0 and FileExists(as_Temp + ls_Temp) then
						ll_Temp = lds_Update.GetItemNumber(li_Found, "Att_ID")
						of_AttachFromFile(ll_Temp, as_Temp + ls_Temp)
					End If					
				Next				
			End If								
			
			FileDelete(as_Temp + 'attlist.vdbxp')  // delete att list
								
		End If		
		
	Else
		lb_Error = True
		ls_Temp = "SQL Failed: " + String(SQLCA.SQLCode)
	End If
End If

Destroy lds_Import
Destroy lds_Update

If ls_GlobalID > "" then
	as_Result = "INSP" + ls_GlobalID   // pass back GlobalID to calling proc
Else
	as_Result = "INSP" + String(al_IMO)   // pass back IMO to calling proc
End If

Run('cmd /Q /C del "' + as_Temp + '*.vdbxp"')

If lb_Error then
	Rollback;
   f_Write2Log("of_ImportIntoMobile > " + ls_Temp)
	Messagebox("Import Failed", "Inspection import failed.~n~n" + ls_Temp, Exclamation!)
	as_Result += ";" + ls_Temp + " (" + as_FileName + ")!"   // pass error back to calling proc (exclamation is very important)
	FileMove(as_FileName, as_FileName + ".rejected")	
	Return -1
Else
	Commit;
    f_Write2Log("of_ImportIntoMobile Successful: " + as_FileName)
	as_Result += ";Received from " + ls_Sender
	If li_Source = 0 then as_Result += " (Office)"
	If li_Source = 2 then as_Result += " (Inspector)"   // No need for li_Source=1
	FileDelete(as_FileName)
	
	// Delete any attachments that have no physical attachments
	Delete from VETT_ATT Where ATTDATA is Null;
	Commit;
	
End If

Return 0
end function

public function integer of_importintooffice (string as_path, string as_filename, string as_temp, ref integer ai_msgtype, ref string as_id, ref string as_ver, ref string as_info, ref boolean abool_new);/* This function imports an inspection package into VIMS

Parameters:

as_Path			: The path of incoming vpkg file
as_FileName		: The name of the inspection package file
as_Temp			: The path of the temporary folder (used for unpacking the file)
ai_MsgType		: The message type returned to the calling procedure
as_id			: Returns the identity of the sender of the inspection package (either IMO number or UserID)
as_ver			: Returns the full version of the VIMS Mobile client that exported this inspection package
as_info			: Returns a message for including in the System Messages

The function returns an negative number if it fails or returns the Inspection ID for success.

*/

// Declare variables
Integer li_Temp, li_Count, li_SQLRet, li_Source, li_CAPCount = 0
String ls_Temp, ls_Sender, ls_ShortName, ls_DBName
Long ll_InspID, ll_Temp
n_MyDataStore lds_Import, lds_Update
n_filepackage lnvo_pack
n_fileattach_service lFAS
Boolean lbool_Error, lbool_AllCAP = False

SetPointer(HourGlass!)
abool_New = False

// Get current DB name
lFAS = create n_fileattach_service
ls_DBName = lFAS.of_getfiledbname()
f_Write2Log("Setting File DB: " + ls_DBName)
Destroy lFAS

// Unpack files from the inspection package
li_Temp = lnvo_pack.UnPackfiles(as_Path + as_FileName, as_Temp)
If li_Temp < 0 then
	ai_MsgType = 13
	as_Info = "Could not unpack " + as_FileName
	Return li_Temp
End If

// First, check if the file is actually an inspection and then process the ID file
If FileExists(as_Temp + 'in_id.vdbxp') then
	li_Temp = FileOpen (as_Temp + 'in_id.vdbxp', LineMode!, Read!, LockReadWrite!, Replace!, EncodingUTF8!)
	If (li_Temp <= 0) then  // Unable to read ID file
		ls_Temp = "Could not verify Inspection ID File"
		lbool_Error = True
	Else
		FileReadEx(li_Temp, ls_Temp)
		If ls_Temp <> "Inspection Package" then   // Verify Inspection package
			ls_Temp = "Invalid Inspection Package"
			lbool_Error = True
		End If
		FileReadEx(li_Temp, ls_Temp)
		FileReadEx(li_Temp, ls_Temp)
		FileReadEx(li_Temp, ls_Temp)
		li_Source = Integer(Right(ls_Temp, 1))  // Source of inspection
		FileReadEx(li_Temp, ls_Temp)
		ls_Sender = Right(ls_Temp, Len(ls_Temp) - 8)
		If ls_Sender = "" then 
			lbool_Error = True
			ls_Temp = "Could not verify sender's identity."
		End If		
		If li_Source = 0 then   // If exported by VIMS itself
			lbool_Error = True
			ls_Temp = "This inspection was exported by VIMS Office and not a VIMS Mobile Client."
		End If
		as_id = ls_Sender
	End If
	FileClose(li_Temp)
	FileDelete(as_Temp + 'in_id.vdbxp')  // Delete the ID file
Else
	lbool_Error = True
	ls_Temp = "Inspection ID file not found in package"
End If

// Create the DataStores
lds_Import = Create n_MyDatastore
lds_Update = Create n_MyDatastore

// Import the Inspection Header
If Not lbool_Error Then	
	lds_Import.DataObject = "d_sq_tb_inspio_header_mobileexp"
	li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'header.vdbxp')
	If li_Temp<>1 then // Should import only 1 row
		ls_Temp = "Inspection header import failed"
		lbool_Error = True	
	End If
	f_restore_cr_after_xml_import(lds_Import, "remarks")  // Workaround for XML Bug
	f_restore_cr_after_xml_import(lds_Import, "summary") 
End If
FileDelete(as_Temp + 'header.vdbxp')

If Not lbool_Error Then
	
	// Get the VIMS Mobile version and DB issue and update the client information
	If Not lbool_Error Then
		ls_Temp = lds_Import.GetItemString(1, "MobileVer")
		li_Temp = lds_Import.GetItemNumber(1, "DBIssue")
		as_ver = ls_Temp
		f_UpdateVMVersion(ls_Sender, ls_Temp, li_Temp)
	End If
	
	// Try to find an existing inspection with the same GlobablID
	ls_Temp = lds_Import.GetItemString(1, "GlobalID")	
	Select INSP_ID Into :ll_InspID From VETT_INSP Where GLOBALID = :ls_Temp;	
	li_SQLRet = SQLCA.SQLCode
	If li_SQLRet < 0 then
		lbool_Error = True
		ls_Temp = "SQL for GlobalID search failed"
	End If
	
	If li_SQLRet = 100 then   // If no existing inspection found
   	lds_Update.DataObject = "d_sq_tb_inspio_header_officeimp"
		lds_Update.SetTransObject(SQLCA)
		lds_Update.Object.Data[1,1,1,25] = lds_Import.Object.Data[1,1,1,25]  // Transfer data
		lds_Update.SetItem(1, 'Expires', f_AddMonths(lds_Update.GetItemDateTime(1, 'InspDate'), 12)) // Set Expires date
		If li_Source = 1 then lds_Update.SetItem(1, 'ExpFlag', 3)   // Set green flag status if from vessel
		If IsNull(lds_Update.GetItemString(1, "Port")) then lds_Update.SetItem(1, "Port", "") // Check for null port
		
		// Check if vessel exists
		ll_Temp = lds_Update.GetItemNumber(1, 'VesselIMO')
		Select Max(VETT_RESP), Max(VSLFLAG) Into :ls_Temp, :li_Temp From VESSELS Where (IMO_NUMBER = :ll_Temp) And (VESSEL_ACTIVE = 1) And (VETT_TYPE is Not Null) And (VSLFLAG is Not Null);
		If SQLCA.SQLCode <> 0 then
			lbool_Error = True
			ls_Temp = "Could not find vessel in database. Vessel with IMO " + String(ll_Temp) + " may be inactive, without a flag or without a vetting type."
		End If
		If Not lbool_Error Then
			// Check and assing a responsible person for inspection
			If IsNull(ls_Temp) or ls_Temp = "" then
				lbool_Error = True
				ls_Temp = "Could not assign a responsible person for this inspection  (IMO: " + String(ll_Temp) + ")."
			Else
				lds_Update.SetItem(1, "Resp", ls_Temp)
				lds_Update.SetItem(1, "VslFlag", li_Temp)
				lds_Update.SetItem(1, "CurDept", 1)
			End If
		End If
		
		If Not lbool_Error then   // If no error so far

			// Create Inspection
			If lds_Update.Update( ) < 1 then
				lbool_Error = True
				ls_Temp = "The inspection header could not be created."
			Else
				
				ll_InspID = lds_Update.GetItemNumber(1, "Insp_ID")   // Get back Inspection ID
				If ll_InspID <= 0 then 
					lbool_Error = True
					ls_Temp = "Could not retrieve the inspection identity."
				End If
				
				// Check Inspection model and set All CAPs flag if required
				li_Temp = lds_Update.GetItemNumber(1, "IM_ID")
				Select SHORTNAME into :ls_ShortName from VETT_INSPMODEL Where IM_ID = :li_Temp;
				If ls_ShortName = "PSC" then lbool_AllCAP = True
				
				// Create Summaries (if exists)
				If FileExists(as_Temp + 'summaries.vdbxp') and not lbool_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_summaries"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.ImportFile(XML!, as_Temp + 'summaries.vdbxp')
					If li_Temp < 1 then
						lbool_Error = True
						ls_Temp = "Could not import inspection summaries."
					Else
						f_restore_cr_after_xml_import(lds_Update, "sm_text")  // XML Bug
						For li_Temp = 1 to lds_Update.RowCount( )
							lds_Update.SetItem(li_Temp, 'insp_id', ll_InspID)
						Next					
						If lds_Update.Update( )<1 then
							lbool_Error = True
							ls_Temp = "Could not update inspection summaries."
						End If
					End If
					FileDelete(as_Temp + 'summaries.vdbxp')	
				End If			
				
				// Create Matrix (if exists)
				If FileExists(as_Temp + 'matrix.vdbxp') and not lbool_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_matrix"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.ImportFile(XML!, as_Temp + 'matrix.vdbxp')
					If li_Temp < 1 then
						lbool_Error = True
						ls_Temp = "Could not import officer matrix."
					Else
						For li_Temp = 1 to lds_Update.RowCount( )
							lds_Update.SetItem(li_Temp, 'insp_id', ll_InspID)
							lds_Update.SetItem(li_Temp, 'Serial', li_Temp)							
						Next
						If lds_Update.Update( )<1 then
							lbool_Error = True
							ls_Temp = "Could not update officer matrix."
						End If
					End If
					FileDelete(as_Temp + 'matrix.vdbxp')	
				End If						
				
				// Create Items
				If FileExists(as_Temp + 'items.vdbxp') and not lbool_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_items"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.ImportFile(XML!, as_Temp + 'items.vdbxp')
					If li_Temp < 1 then
						lbool_Error = True
						ls_Temp = "Could not import items."
					Else
						f_restore_cr_after_xml_import(lds_Update, "inspcomm")  // XML Bug
						f_restore_cr_after_xml_import(lds_Update, "owncomm")
						f_restore_cr_after_xml_import(lds_Update, "followup")
						// If this is a non-MIRE insp, then insert a ghost item						
						If lds_Update.Rowcount( )<30 then 
							Insert into VETT_ITEM(INSP_ID, ANS) Values (:ll_InspID, Null);
						End If
						// Loop thru all items and set InspID and CAP status
						For li_Temp = 1 to lds_Update.RowCount( )
							If lbool_AllCAP then lds_Update.SetItem(li_Temp, 'Is_CAP', 1)  // Set Obs as CAP if all obs must be CAPs
							li_CAPCount += lds_Update.GetItemNumber(li_Temp, 'Is_CAP')  // Count number of CAPS in inspection							
							lds_Update.SetItem(li_Temp, 'insp_id', ll_InspID)	// Set Insp_ID for all items							
						Next
						// Loop thru all items backward and delete any items that are invalid
						For li_Temp = lds_Update.RowCount() to 1 Step -1
							If Not IsNull(lds_Update.GetItemNumber(li_Temp, "Obj_ID")) Then
								If Not of_ObjExists(lds_Update.GetItemNumber(li_Temp, "Obj_ID")) Then lds_Update.DeleteRow(li_Temp)
							End If
						Next
						// Update items
						If lds_Update.Update( )<1 then
							lbool_Error = True
							ls_Temp = "Could not update items."
						End If
					End If
					FileDelete(as_Temp + 'items.vdbxp')	
				End If						
				// Important Note: lds_Update now has Item_IDs inside and is used below
				
				// If any CAPs were found, flag inspection for export to ShipNet
				If li_CapCount > 0 then
					Update VETT_INSP Set CAPEXPFLAG = 1 Where INSP_ID = :ll_InspID;
				End If
				
				// Create Item Comments
				If FileExists(as_Temp + 'comments.vdbxp') and not lbool_Error then
					lds_Import.DataObject = "d_sq_tb_inspio_itemcomments"
					lds_Import.SetTransObject(SQLCA)
					li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'comments.vdbxp')
					If li_Temp < 1 then
						lbool_Error = True
						ls_Temp = "Could not import item comments."
					Else
						f_restore_cr_after_xml_import(lds_Import, "histdata")  // XML Bug
						// Find and populate ItemID using lds_Update
						For li_Temp = lds_Import.RowCount( ) to 1 Step -1
							ll_Temp = lds_Update.Find('serial = ' + String(lds_Import.GetItemNumber(li_Temp, 'serial')), 0, lds_Update.RowCount( ))
							If ll_Temp > 0 then 
								ll_Temp = lds_Update.GetItemNumber(ll_Temp, 'Item_ID')
								lds_Import.SetItem(li_Temp, 'item_id', ll_Temp)
							Else	// If no such item, delete comment
								lds_Import.DeleteRow(li_Temp)
							End If
						Next						
						If not lbool_Error then
							If lds_Import.Update( )<1 then
								lbool_Error = True
								ls_Temp = "Could not update item comments."
							End If
						End If
					End If
					FileDelete(as_Temp + 'comments.vdbxp')	
				End If
						
				// Create Attachments
				If FileExists(as_Temp + 'attlist.vdbxp') and not lbool_Error then
					lds_Import.DataObject = "d_sq_tb_inspio_att"
					lds_Import.SetTransObject(SQLCA)
					li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'attlist.vdbxp')
					f_Write2Log("Attachments in list: " + string(li_Temp))
					If li_Temp < 1 then
						lbool_Error = True
						ls_Temp = "Could not import attachment list."
					Else						
						// If only dummy attachment is there, then remove it
						If li_Temp = 1 then
							If lds_Import.GetItemString(1, "FileName") = "Dummy_Attachment" and lds_Import.GetItemNumber(1, "FileSize") = 0 then lds_Import.DeleteRow(1)
						End If						
						SetNull(ll_Temp)
						For li_Temp = 1 to lds_Import.RowCount( )  
							lds_Import.SetItem(li_Temp, 'vett_att_insp_id', ll_InspID)	 // Set all InspID						
							lds_Import.SetItem(li_Temp, 'Imported', 3)     // Set Sync status to Green  (0=Red, 1=Yellow, 2=Blue, 3=Green)
							lds_Import.SetItem(li_Temp, 'VimsID', lds_Import.GetItemNumber(li_Temp, 'Att_ID'))  // Transfer Att_ID to VimsID (used later to form filenames)
							lds_Import.SetItem(li_Temp, 'Att_ID', ll_Temp)   // Set Att_ID to null so it is refreshed on calling Update()
							lds_Import.SetItem(li_Temp, 'DB_Name', ls_DBName) // Set correct file database
							lds_Import.SetItemStatus(li_Temp, 'Att_ID', Primary!, NotModified!) // Set status as not modified
							f_Write2Log("Processing File " + lds_Import.GetItemString(li_Temp, 'FileName'))
						Next
						For li_Temp = 1 to lds_Import.RowCount( ) // Set all Item_ID
							If Not IsNull(lds_Import.GetItemNumber(li_Temp, 'Serial')) Then
								ll_Temp = lds_Update.Find("Serial = " + String(lds_Import.GetItemNumber(li_Temp, 'Serial')), 1, lds_Update.RowCount())
								If ll_Temp > 0 then
									ll_Temp = lds_Update.GetItemNumber(ll_Temp, "Item_ID")
									lds_Import.SetItem(li_Temp, 'vett_att_item_id', ll_Temp)
									f_Write2Log("Setting ItemID on " + lds_Import.GetItemString(li_Temp, 'FileName'))
								End If								
							End If
						Next
						lds_Update.DataObject = "d_sq_tb_inspio_summaries"
						lds_Update.SetTransObject(SQLCA)
						lds_Update.Retrieve(ll_InspID)
						For li_Temp = 1 to lds_Import.RowCount( ) // Set all SM_ID
							If Not IsNull(lds_Import.GetItemNumber(li_Temp, 'SMType_ID')) Then								
								ll_Temp = lds_Update.Find("SMType_ID = " + String(lds_Import.GetItemNumber(li_Temp, 'SMType_ID')), 1, lds_Update.RowCount())
								If ll_Temp > 0 then
									ll_Temp = lds_Update.GetItemNumber(ll_Temp, "SM_ID")
									lds_Import.SetItem(li_Temp, 'vett_att_sm_id', ll_Temp)
									f_Write2Log("Setting SM_ID on " + lds_Import.GetItemString(li_Temp, 'FileName'))
								End If
							End If
						Next
						If lds_Import.Update( ) < 1 then
							lbool_Error = True
							ls_Temp = "Attachments not updated."
						End If					
						If Not lbool_Error then  // Attach the actual files
							For li_Temp = lds_Import.RowCount() to 1 Step -1
								ll_Temp = lds_Import.GetItemNumber(li_Temp, "Att_ID")
								ls_Temp = "Att" + String(lds_Import.GetItemNumber(li_Temp, "VimsID")) + ".vdbxp"
								f_Write2Log("Attempting " + ls_Temp)
								If of_AttachFromFile(ll_Temp, as_Temp + ls_Temp)<0 then
									// Remove attachment if AttachFromFile failed
									lds_Import.DeleteRow(li_Temp)
								End If
								FileDelete(as_Temp + ls_Temp)
							Next
						End If
						lds_Import.Update( )
						FileDelete(as_Temp + 'attlist.vdbxp')	
					End If						
				End If
				
				If Not lbool_Error then 
					ls_Temp = "New inspection received"
					abool_New = True
				End If
				
			End If
		End If		
	ElseIf li_SQLRet = 0 then  // If inspection already exists

		// Get Items and then Update Comments
		lds_Update.DataObject = "d_sq_tb_inspio_items"
		lds_Update.SetTransObject(SQLCA)
		If lds_Update.Retrieve(ll_InspID)<0 then
			lbool_Error = True
			ls_Temp = "Could not re-retrieve items."
		End If
		
		If FileExists(as_Temp + 'comments.vdbxp') and not lbool_Error then
			lds_Import.DataObject = "d_sq_tb_inspio_itemcomments"
			lds_Import.SetTransObject(SQLCA)
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'comments.vdbxp')
			If li_Temp < 1 then
				lbool_Error = True
				ls_Temp = "Could not import item comments."
			Else
				f_restore_cr_after_xml_import(lds_Import, "histdata")  // XML Bug
				// Find and populate ItemID using lds_Update
				For li_Temp = 1 to lds_Import.RowCount( )
					ll_Temp = lds_Update.Find('Serial = ' + String(lds_Import.GetItemNumber(li_Temp, 'Serial')), 0, lds_Update.RowCount( ))
					If ll_Temp > 0 then 
						ll_Temp = lds_Update.GetItemNumber(ll_Temp, 'Item_ID')
						lds_Import.SetItem(li_Temp, 'Item_id', ll_Temp)
					Else		
						lds_Import.SetItemStatus(li_Temp, 0, Primary!, NotModified!)  // Item was deleted by Vetting office
					End If
				Next
				// Retrieve existing comments
				If Not lbool_Error then
					lds_Update.DataObject = "d_sq_tb_inspio_itemcomments"
					lds_Update.SetTransObject(SQLCA)
					li_Temp = lds_Update.Retrieve(ll_InspID)
					If li_Temp < 0 then
						lbool_Error = True
						ls_Temp = "Existing Item Comments could not be retrieved."						
					End If
				End If
				// Set status of existing comments to 'Not modified'
				If not lbool_Error then
					For li_Temp = 1 to lds_Import.Rowcount( )
						ll_Temp = lds_Import.GetItemNumber(li_Temp, "Time_ID")
						If lds_Update.Find("Time_ID = " + String(ll_Temp) + " And Item_ID = " + String(lds_Import.GetItemNumber(li_Temp, "Item_ID")), 1, lds_Update.RowCount()) > 0 then 
							lds_Import.SetItemStatus(li_Temp, 0, Primary!, NotModified!)
						End If
					Next
					If lds_Import.Update( ) < 1 then
						lbool_Error = True
						ls_Temp = "Could not update item comments."
					End If
				End If
			End If			
		End If
		
		// If attachment list exists and from vessel, flag any attachments that are in sync or not in sync
		If FileExists(as_Temp + 'attlist.vdbxp') and not lbool_Error and li_Source = 1 then
			lds_Import.DataObject = "d_sq_tb_inspio_att"
			lds_Import.SetTransObject(SQLCA)
			li_Temp = lds_Import.ImportFile(XML!, as_Temp + 'attlist.vdbxp')
			If li_Temp > 0 then
				// If only dummy attachment is there, then remove it
				If li_Temp = 1 then
					If lds_Import.GetItemString(1, "FileName") = "Dummy_Attachment" and lds_Import.GetItemNumber(1, "FileSize") = 0 then lds_Import.DeleteRow(1)
				End If
				// Get existing attachments
				lds_Update.DataObject = lds_Import.DataObject
				lds_Update.SetTransObject(SQLCA)
				lds_Update.Retrieve(ll_InspID)
				
				For li_Temp = 1 to lds_Update.RowCount()
					// try to find each attachment in import list by AttID
					ll_Temp = lds_Import.Find("VimsID = " + String(lds_Update.GetItemNumber(li_Temp, "Att_ID")), 1, lds_Import.RowCount() + 1)
					If ll_Temp <= 0 then // If not found, try by filename/size
						ll_Temp = lds_Import.Find("VimsID=0 and FileName='" + lds_Update.GetItemString(li_Temp, "FileName") + "' and FileSize=" + String(lds_Update.GetItemNumber(li_Temp, "FileSize")), 1, lds_Import.RowCount())						
					End If
					If ll_Temp <= 0 then  // If not found						
						If lds_Update.GetItemNumber(li_Temp, "Imported") < 1 or lds_Update.GetItemNumber(li_Temp, "Imported") > 2 then lds_Update.SetItem(li_Temp, "Imported", 1)
					Else // If found, mark it as synced (if not already)
						If lds_Update.GetItemNumber(li_Temp, "Imported") < 3 then lds_Update.SetItem(li_Temp, "Imported", 3)
					End If
					// Set DBName
					lds_Update.SetItem(li_Temp, "DB_Name", ls_DBName)
				Next
				lds_Update.Update()
			End If
		End If
		
		If Not lbool_Error then   // Update 'Last Export' field
			lds_Update.DataObject = "d_sq_tb_inspio_header_officeimp"
			lds_Update.SetTransObject(SQLCA)
			If lds_Update.Retrieve(ll_InspID)>0 then
				ls_Temp = lds_Update.GetItemString(1, "lastexport")
				If IsNull(ls_Temp) then ls_Temp = ""
				If li_Source = 1 then ls_Temp += "V" else ls_Temp += "I"
				lds_Update.SetItem(1, "lastexport", ls_Temp)
				lds_Update.Update()
			End If
		End If
		
		If Not lbool_Error then ls_Temp = "Inspection updated"
	Else
		lbool_Error = True
		ls_Temp = "SQL Failed: " + String(SQLCA.SQLCode) + " SQL: " + Sqlca.SQLErrtext
	End If
End If

Destroy lds_Import
Destroy lds_Update

// Delete files if not already deleted
FileDelete(as_Temp + "in_id.vdbxp")
FileDelete(as_Temp + "header.vdbxp")
FileDelete(as_Temp + "summaries.vdbxp")
FileDelete(as_Temp + "items.vdbxp")
FileDelete(as_Temp + "comments.vdbxp")
FileDelete(as_Temp + "matrix.vdbxp")
FileDelete(as_Temp + "att.vdbxp")
FileDelete(as_Temp + "attlist.vdbxp")
Run('cmd /Q /D /C del "' + as_Temp + '*.vdbxp"', Minimized!)  // del all attachments
			
If lbool_Error then
	Rollback;
	FileMove(as_path + as_FileName, as_path + as_FileName + ".Rejected")
	ai_MsgType = 1  // Insp Import failed
	as_info = ls_Temp
	Return -1
Else
	Commit;
	FileDelete(as_path + as_FileName)
	ai_MsgType = 7  // Insp Import success
	as_info = ls_Temp
	Return ll_InspID
End If
end function

public function boolean of_createglobalid (long al_inspid);// Function to check and create a global ID for an inspection

String ls_GlobalID
Date ld_Date
Long ll_IMO, ll_IM

// Get data from inspection
Select VESSELIMO, IM_ID, INSPDATE, GLOBALID Into :ll_IMO, :ll_IM, :ld_Date, :ls_GlobalID
From VETT_INSP Where INSP_ID = :al_InspID;

If SQLCA.SQLCode <> 0 then
	Rollback;
	Return False
End If

Commit;

// If GlobalID already exists
If Not IsNull(ls_GlobalID) and ls_GlobalID > "" then Return True
	
// Create GlobalID
ls_GlobalID = String(ll_IMO) + String(ld_Date, "YYMMDD") + String(ll_IM, '000') + String(Rand(999), "000")

// Save GlobalID
Update VETT_INSP Set GLOBALID = :ls_GlobalID Where INSP_ID = :al_InspID;
	
If SQLCA.SQLCode <> 0 then
	Rollback;
	Return False
End If
	
Commit;
	
Return True
end function

public function long of_getitemidfromserial (long al_inspid, long al_serial);// This function returns an ItemID based on the serial number of an Item.

Long ll_ID = 0

Select Item_ID Into :ll_ID From VETT_ITEM Where INSP_ID = :al_InspID and SERIAL = :al_Serial;
// Do not commit this statement as it happens in an outer transaction !

Return ll_ID
end function

public function long of_getsmidfromsmtype (long al_inspid, long al_smtypeid);// This function returns an Sm_ID based on the summary type of a Summary item.

Long ll_ID = 0

Select SM_ID Into :ll_ID From VETT_INSPSM Where INSP_ID = :al_InspID and SMTYPE_ID = :al_SmTypeID;
// Do not commit this statement as it happens in an outer transaction !

Return ll_ID
end function

public function integer of_getattcount (long al_inspid, boolean ab_newonly, boolean ab_headeronly);// This function returns the number of attachments in an inspection.
// If ab_NewOnly is true, only count of attachments with New flag are returned (Imported<2)
// If ab_HeaderOnly is true, only Header attachments are returned

Integer li_Count, li_Imp = 5

If ab_NewOnly then li_Imp = 2

If ab_HeaderOnly then
	Select Count(ATT_ID) Into :li_Count from VETT_ATT Where INSP_ID = :al_InspID and IMPORTED < :li_Imp and ITEM_ID Is Null and SM_ID is Null;
Else
	Select Count(ATT_ID) Into :li_Count from VETT_ATT Where INSP_ID = :al_InspID and IMPORTED < :li_Imp;	
End If

Commit;

Return li_Count
end function

public function long of_gettotalattsize (long al_inspid, boolean ab_newonly, boolean ab_headeronly);// This function returns the total size of attachments in an inspection.
// If ab_NewOnly is true, only size of attachments with New flag are returned (Imported<2)
// If ab_HeaderOnly is true, only size of header attachments are returned

Long li_Size
Integer li_Imp = 5

If ab_NewOnly then li_Imp = 2

If ab_HeaderOnly then
	Select Sum(FILESIZE) Into :li_Size from VETT_ATT Where INSP_ID = :al_InspID and IMPORTED < :li_Imp and ITEM_ID Is Null and SM_ID is Null;
Else
	Select Sum(FILESIZE) Into :li_Size from VETT_ATT Where INSP_ID = :al_InspID and IMPORTED < :li_Imp;	
End If

Commit;

If IsNull(li_Size) then li_Size = 0

Return li_Size
end function

public function string of_deletevminspection (long al_inspid);Integer li_SQLCode
// This function deletes an inspection in VIMS Mobile including all referencing child table rows
// Takes the inspection ID as argument and returns empty string if successful or error message if not

// Delete all attachments
Delete from VETT_ATT where INSP_ID = :al_InspID;
li_SQLCode = sqlca.sqlcode

// Delete all comment history
If li_SQLCode >= 0 then
	Delete from VETT_ITEMHIST where ITEM_ID in (Select ITEM_ID from VETT_ITEM Where INSP_ID = :al_InspID);
	li_SQLCode = sqlca.sqlcode
End If

// Delete all items
If li_SQLCode >= 0 then
	Delete from VETT_ITEM where INSP_ID = :al_InspID;
	li_SQLCode = sqlca.sqlcode
End If

// Delete all summaries
If li_SQLCode >= 0 then
	Delete from VETT_INSPSM where INSP_ID = :al_InspID;
	li_SQLCode = SQLCA.Sqlcode
End If

// Delete all matrix officers
If li_SQLCode >= 0 then
	Delete from VETT_MATRIX where INSP_ID = :al_InspID;
	li_SQLCode = SQLCA.Sqlcode
End If

// Delete Inspection
If li_SQLCode >= 0 then
	Delete from VETT_INSP where INSP_ID = :al_InspID;
	li_SQLCode = SQLCA.sqlcode
End If

If li_SQLCode = 0 then
	Commit;
	Return ""
Else   
	String ls_Temp
	ls_Temp = SQLCA.SQLErrText
	Rollback;
	Return ls_Temp
End If
end function

public function integer of_changeinspectionstatus (long al_inspid, integer ai_newstatus);
Update VETT_INSP Set STATUS = :ai_NewStatus WHERE INSP_ID = :al_InspID;

If SQLCA.SQLCode <> 0 then 
	// Messa__gebox("DB Error", "The status of the inspection could not be updated.", Exclamation!)
	Rollback;
	Return -1
End If

Commit;

Return 0


end function

public function string of_exportinspection (long al_inspid, integer ai_source, string as_temppath, string as_path, byte ab_includeatt, string as_sender, byte ab_option);Datastore lds_exp
String ls_Path, ls_Temp, ls_FileName
Integer li_Ret, li_Count, li_IDFile
n_filepackage lnvo_pack

/* 
This function exports an inspection with all its data into xml files and then zips it using the zip library 
This function can be called by both VIMS Office and VIMS Mobile 

Parameters:

al_InspID         : The Inspection ID
ai_Source         : Calling Application: 0 = VIMS Office, 1 = VM Vessel, 2 = VM Inspector
as_TempPath       : Path of Temp folder to handle temporary files
as_Path           : Path to finally create the inspection file package
ab_Includeatt     : 0 = No attachments, 1 = Header attachments only, 2 = All attachments
as_Sender         : String holding sender's indentity (IMO number for VIMS Vessel, otherwise UserID)
ab_option         : 0 = Export flagged att only, 1 = Replace Insp, 2 = Export all (as per ab_Includeatt)

Return Value:

Function returns a filename for success and a error message for failure

*/

f_Write2Log("Export Insp. ID: " + String(al_InspID) )

// First, check if all item serials are filled in
If of_PopulateItemSerial(al_InspID) < 0 then Return "of_PopulateItemSerial() failed."

// Append the export character. No need for error check here.
of_AppendExportChar(al_InspID, ai_Source)

// Create identity file (to store package header information)
li_IDFile = FileOpen (as_TempPath + 'IN_ID.vdbxp', LineMode!, Write!, LockReadWrite!, Replace!, EncodingUTF8!)
If (li_IDFile <= 0) then Return "Unable to create Inspection Identity File."

FileWriteEx(li_IDFile, "Inspection Package")   // Title
FileWriteEx(li_IDFile, "Created: " + String(Today(), "dd mmm yyyy"))  // Date of issue
FileWriteEx(li_IDFile, "InspID: " + String(al_InspID))  // InspID
FileWriteEx(li_IDFile, "Source: " + String(ai_Source))  // Source
FileWriteEx(li_IDFile, "Sender: " + String(as_Sender))  // Sender
FileWriteEx(li_IDFile, "Replace: " + String(ab_Option)) // Replace
If FileClose(li_IDFile) = -1 then Return "Unable to close Inspection Identity File"	

f_Write2Log("Success: IN_ID.vdbxp")

// Create the DataStore to handle exports
lds_exp = Create DataStore

// Export the Inspection Header
If ai_Source = 0 then lds_exp.DataObject = "d_sq_tb_inspio_header_officeexp" else lds_exp.DataObject = "d_sq_tb_inspio_header_mobileexp"
lds_exp.SetTransObject(SQLCA)
li_Ret = lds_exp.Retrieve(al_InspID)
If li_Ret<=0 then Return "Header Retrieve Failed"
li_Ret = lds_Exp.GetItemNumber(1, "Status")  // Check and modify the status of the inspection
ls_FileName = String(lds_Exp.GetItemNumber(1, "VesselIMO")) + "_" + String(lds_Exp.GetItemDateTime(1, "InspDate"), "YYMMDD") + "_" + Char(Integer(Rand(26) + 64))
If ai_Source = 0 then 
	lds_exp.SetItem(1, "Status", 3) 
Else 
	If li_Ret < (3 - ai_Source) then lds_Exp.SetItem(1, "Status", 3 - ai_Source)
End If
li_Ret = lds_exp.SaveAs(as_TempPath + 'header.vdbxp', XML!, False)
If li_Ret = -1 then Return "Header Save Failed"

f_Write2Log("Success: header.vdbxp")

// Export the Items
lds_exp.DataObject = "d_sq_tb_inspio_items"
lds_exp.SetTransObject(SQLCA)
li_Ret = lds_exp.Retrieve(al_InspID)
If li_Ret<0 then Return "Items Retrieve Failed"
If li_Ret>0 then li_Ret = lds_exp.SaveAs(as_TempPath + 'items.vdbxp', XML!, False)
If li_Ret = -1 then Return "Items Save Failed"
f_Write2Log("Success: items.vdbxp")

// Export the Summaries
lds_exp.DataObject = "d_sq_tb_inspio_summaries"
lds_exp.SetTransObject(SQLCA)
li_Ret = lds_exp.Retrieve(al_InspID)
If li_Ret<0 then Return "Summaries Retrieve Failed"
If li_Ret>0 then li_Ret = lds_exp.SaveAs(as_TempPath + 'summaries.vdbxp', XML!, False)
If li_Ret = -1 then Return "Summaries Save Failed"
f_Write2Log("Success: summaries.vdbxp")

// Export the Item Comments
lds_exp.DataObject = "d_sq_tb_inspio_itemcomments"
lds_exp.SetTransObject(SQLCA)
li_Ret = lds_exp.Retrieve(al_InspID)
If li_Ret<0 then Return "Item Comments Retrieve Failed"
If li_Ret>0 then 
	For li_Ret = 1 to lds_Exp.RowCount()   // Reset "un-exported" flag on items
		If lds_exp.GetItemNumber(li_Ret, "Hist_Type") = 1 then lds_exp.SetItem(li_Ret, "Hist_Type", 0)
	Next
	lds_exp.Update()
	li_Ret = lds_exp.SaveAs(as_TempPath + 'comments.vdbxp', XML!, False)
End If
If li_Ret = -1 then Return "Item Comments Save Failed"
f_Write2Log("Success: comments.vdbxp")

// Export the Matrix
lds_exp.DataObject = "d_sq_tb_inspio_matrix"
lds_exp.SetTransObject(SQLCA)
li_Ret = lds_exp.Retrieve(al_InspID)
If li_Ret<0 then Return "Matrix Retrieve Failed"
If li_Ret>0 then li_Ret = lds_exp.SaveAs(as_TempPath + 'matrix.vdbxp', XML!, False)
If li_Ret = -1 then Return "Matrix Save Failed"
f_Write2Log("Success: matrix.vdbxp")

// Get attachment list
lds_exp.DataObject = "d_sq_tb_inspio_att"
lds_exp.SetTransObject(SQLCA)
li_Ret = lds_exp.Retrieve(al_InspID)
If li_Ret<0 then 
	f_Write2Log("Failed: lds_Exp.Retrive()")
	Return "Attachment List Retrieve Failed"
End If

If lds_Exp.RowCount() = 0 then // If there are no attachments, insert dummy att for XML export
	lds_Exp.InsertRow(0)
	lds_Exp.SetItem(1, "FileName", "Dummy_Attachment")
	lds_Exp.SetItem(1, "FileSize", 0)
End If

// Save complete attachment list
li_Ret = lds_exp.SaveAs(as_TempPath + 'attlist.vdbxp', XML!, False)

// If dummy was added, remove it
If lds_Exp.GetItemString(1, "FileName") = "Dummy_Attachment" and lds_Exp.GetItemNumber(1, "FileSize") = 0 then lds_Exp.DeleteRow(1)

If ab_IncludeAtt > 0 then

	// If source is VIMS
	If ai_Source = 0 then
		If ab_IncludeAtt = 1 then  // If only header attachments
			lds_Exp.SetFilter("IsNull(Serial) and IsNull(SMType_ID)")
			lds_Exp.Filter()			
		End If
		If ab_option = 0 then   // If only flagged attachments
			lds_Exp.SetFilter("Imported<2")      // Imported: 0=Unknown, 1=Modified, 2=Sent, 3=Synced
			lds_Exp.Filter()			
		End If
	End If
	
	// Save the 'physical' attachments
	f_Write2Log("Physical Attachments: " + String(lds_Exp.RowCount()))
	
	n_vimsatt l_Att
	
	For li_Ret = 1 to lds_Exp.Rowcount()
		// Create filename		
		ls_Temp = "Att" + String(lds_Exp.GetItemNumber(li_Ret, 'Att_ID')) + ".vdbxp"
		// Extract from DB and save
		l_Att = create n_vimsatt
		If l_Att.of_SaveAttachment(lds_Exp.GetItemNumber(li_Ret, 'Att_ID'), as_TempPath + ls_Temp) < 0 then
			f_Write2Log("Failed: " + ls_Temp)
			Destroy l_Att
			Return "Failed to attach file '" + lds_Exp.GetItemString(li_Ret, "FileName") + "'"
		Else
			Destroy l_Att
			f_Write2Log("Success: " + ls_Temp)
		End If
	Next
End If

Destroy lds_exp

// Pack all files and return filename
If lnvo_pack.Packfiles(ls_FileName, as_Path, as_TempPath)<0 then 
	f_Write2Log("Failed: PackFiles()")
	Return "PackFiles() Failed"	
Else
	f_Write2Log("Success: " + ls_FileName + " returned")
	Return "vims_" + ls_FileName + ".vpkg"
End If

end function

public function boolean of_objexists (long al_objid);// This function checks if an object exists in the inspection model.
// DO NOT perform any commits/rollback here

Integer li_C

Select Count(*) Into :li_C from VETT_OBJ Where OBJ_ID=:al_ObjID;

If SQLCA.SQLCode=0 then
	If li_C=1 then Return True Else Return False
Else
	Return False
End If
end function

on n_inspio.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_inspio.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

