$PBExportHeader$n_vimsatt.sru
$PBExportComments$Use to control the file database.
forward
global type n_vimsatt from nonvisualobject
end type
end forward

global type n_vimsatt from nonvisualobject
end type
global n_vimsatt n_vimsatt

type variables

mt_n_transaction itr_FileDB
Boolean ib_Connected
end variables

forward prototypes
public function integer of_addatt (string as_table, long al_id, ref blob abl_att, long al_attsize)
public function integer of_deleteatt (string as_table, long al_id)
public function integer of_getatt (string as_table, long al_id, ref blob ablob_attdata)
public subroutine of_dumptrans ()
public subroutine of_commit (boolean ab_docommit)
public function long of_saveattachment (long al_attid, string as_fpath)
public function integer of_connect (string as_dbname)
end prototypes

public function integer of_addatt (string as_table, long al_id, ref blob abl_att, long al_attsize);// This function write a attachment to the FILES database.

Integer li_Tmp

If Not ib_Connected Then Return -1

Choose Case Upper(as_Table)
	Case "VETT_ATT"

		// Check if record already exists
		Select Count(ATT_ID) Into :li_Tmp from VETT_ATT Where ATT_ID = :al_ID Using itr_FileDB;
		Commit Using itr_FileDB;		
		If li_Tmp = 0 then  // If no record, create new one
			Insert Into VETT_ATT (ATT_ID, FILESIZE) Values (:al_ID, :al_AttSize) Using itr_FileDB;
			If itr_FileDB.SQLCode < 0 then 
				Rollback Using itr_FileDB;
				Return -1
			End If
		End If		
		// Save attachment
		UpdateBlob VETT_ATT Set ATTDATA = :abl_att Where ATT_ID = :al_ID Using itr_FileDB;
		
	Case "VETT_COMP"

		// Check if record already exists
		Select Count(COMP_ID) Into :li_Tmp from VETT_COMP Where COMP_ID = :al_ID Using itr_FileDB;
		Commit Using itr_FileDB;		
		If li_Tmp = 0 then  // If no record, create new one
			Insert Into VETT_COMP (COMP_ID, FILESIZE) Values (:al_ID, :al_AttSize) Using itr_FileDB;
			If itr_FileDB.SQLCode < 0 then 
				Rollback Using itr_FileDB;
				Return -1
			End If
		End If		
		// Save attachment
		UpdateBlob VETT_COMP Set ATTACH = :abl_att Where COMP_ID = :al_ID Using itr_FileDB;
		
	Case "VETT_OBJ"
		
		// Check if record already exists
		Select Count(OBJ_ID) Into :li_Tmp from VETT_OBJ Where OBJ_ID = :al_ID Using itr_FileDB;
		Commit Using itr_FileDB;		
		If li_Tmp = 0 then  // If no record, create new one
			Insert Into VETT_OBJ (OBJ_ID, FILESIZE) Values (:al_ID, :al_AttSize) Using itr_FileDB;
			If itr_FileDB.SQLCode < 0 then 
				Rollback Using itr_FileDB;
				Return -1
			End If
		End If		
		// Save attachment
		UpdateBlob VETT_OBJ Set ATT = :abl_att Where OBJ_ID = :al_ID Using itr_FileDB;
		
	Case Else
		Return -1
End Choose

// Do not commit or rollback yet. Commit/Rollback function will invoked by Caller.
// Return only the SQL Code.

Return itr_FileDB.SQLCode



end function

public function integer of_deleteatt (string as_table, long al_id);// This function deletes an attachment

If Not ib_Connected Then Return -1

Choose Case Upper(as_Table)
	Case "VETT_ATT"
		Delete from VETT_ATT Where ATT_ID = :al_ID Using itr_FileDB;
	Case "VETT_COMP"
		Delete from VETT_COMP Where COMP_ID = :al_ID Using itr_FileDB;		
	Case "VETT_OBJ"
		Delete from VETT_OBJ Where OBJ_ID = :al_ID Using itr_FileDB;
	Case Else
		Return -1
End Choose

// Do not commit or rollback yet. Commit/Rollback function will invoked by Caller.
// Return only the SQL Code.

Return itr_FileDB.SQLCode

end function

public function integer of_getatt (string as_table, long al_id, ref blob ablob_attdata);// This function retrieves the attachment

If Not ib_Connected Then Return -1

Choose Case as_Table
	Case "VETT_ATT"
		SelectBlob ATTDATA into :ablob_AttData From VETT_ATT Where ATT_ID = :al_ID Using itr_FileDB;
	Case "VETT_COMP"
		SelectBlob ATTACH into :ablob_AttData From VETT_COMP Where COMP_ID = :al_ID Using itr_FileDB;		
	Case "VETT_OBJ"
		SelectBlob ATT into :ablob_AttData From VETT_OBJ Where OBJ_ID = :al_ID Using itr_FileDB;		
	Case Else
		Return -1
End Choose

If itr_FileDB.SQLCode <> 0 then 
	Rollback Using itr_FileDB;
	Return -1 
Else 
	Commit Using itr_FileDB;
	If IsNull(ablob_AttData) Then Return -1 Else Return 1
End If
end function

public subroutine of_dumptrans ();// Use this function to dump the transaction log when copying large amount of attachments.

// Safeguard - Exit if database name doesn't end in FILES
If Right(itr_FileDB.Database , 5) <> "FILES" then Return

Transaction n_Dump

n_Dump = Create Transaction

n_Dump.Servername = itr_FileDB.ServerName
n_Dump.Database = itr_FileDB.Database
n_Dump.DBMS = itr_FileDB.DBMS
n_Dump.Autocommit = True
n_Dump.LogID = "sa"
n_Dump.LogPass = "Tr@mos09"

Connect Using n_Dump;

If n_Dump.SQLCode <> 0 then 
	Messagebox("Dump Trans Error", "Could not connect to the database.~n~n" + n_Dump.SQLErrtext, Exclamation!)
	Destroy n_Dump
	Return
End If

String ls_SQL 

//ls_SQL = "Commit Transaction"
//
//Execute Immediate :ls_SQL Using itr_FileDB;

ls_SQL = "Dump tran " + n_Dump.Database + " with truncate_only"

Execute Immediate :ls_SQL Using n_Dump;

If n_Dump.SQLCode <> 0 then 
	Messagebox("Dump Trans Error", "Could not dump transaction log.~n~n" + n_Dump.SQLErrText , Exclamation!)
	Rollback Using n_Dump;
Else
	Commit Using n_Dump;
End If

DisConnect Using n_Dump;

Destroy n_Dump
end subroutine

public subroutine of_commit (boolean ab_docommit);
// If not connected then return
// If connection is default then return (because commit/rollback is performed by calling funtion)
If Not ib_Connected then Return

If ab_DoCommit then
    Commit Using itr_FileDB;
Else
	  Rollback Using itr_FileDB;
End If
end subroutine

public function long of_saveattachment (long al_attid, string as_fpath);
/* This function saves an attachment to the disk

al_AttID: Attachment ID
as_FPath: Complete path and filename

Returns the number of bytes written (success) and -1 for failure
*/

Integer li_FileNum
Long ll_FSize
Blob lblob_File
String ls_DB = ""

SetPointer(HourGlass!)

Select DB_NAME Into :ls_DB From VETT_ATT Where ATT_ID=:al_AttID;
Commit;
If IsNull(ls_DB) Then ls_DB = "ERROR"

If of_Connect(ls_DB) < 1 then	Return -1

If of_GetAtt("VETT_ATT", al_AttID, lblob_File) < 1 then	Return -1

li_FileNum = Fileopen( as_FPath, StreamMode!, Write!, LockReadWrite!, Replace!)

If li_FileNum <0 then	Return -1

ll_FSize = FileWriteEx(li_FileNum, lblob_File)

If ll_FSize < 1 or IsNull(ll_FSize) then
	FileClose(li_FileNum)
	Return -1
End If

FileClose(li_FileNum)

Return ll_FSize
end function

public function integer of_connect (string as_dbname);// This function connects to the files database using its own transaction
// DBName is passed when we need to retrieve attachment for archived DBs

	
n_fileattach_service lFAS  // Added 16 Jul 2015
If as_DBName="" then lFAS = create n_fileattach_service

itr_FileDB = Create Transaction
itr_FileDB.DBMS = SQLCA.DBMS
itr_FileDB.ServerName = SQLCA.ServerName
If as_DBName="" then itr_FileDB.Database = lFAS.of_getfiledbname() else itr_FileDB.Database = as_DBName	
itr_FileDB.AutoCommit = False
itr_FileDB.DBParm = "Release='15',Host='VIMS',UTF8=1"
itr_FileDB.LogId = "DocAdmin"
itr_FileDB.LogPass= "xyDocAdmin12"

If as_DBName="" then destroy lFAS

Connect Using itr_FileDB;

If itr_FileDB.SQLCode < 0 then 
	ib_Connected = False
	f_Write2Log("n_vimsatt.of_Connect() failed. Err: " + itr_FileDB.SQLErrText)
	Return -1
Else 
	ib_Connected = True
	f_Write2Log("n_vimsatt.of_Connect() success; DB: " + itr_FileDB.Database)
	Return 1
End If
end function

on n_vimsatt.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_vimsatt.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;
If ib_Connected Then  // If connected using own transaction then disconnect
	Disconnect Using itr_FileDB;
End If
end event

