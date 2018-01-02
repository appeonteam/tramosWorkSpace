$PBExportHeader$n_ntchire_ds.sru
$PBExportComments$Datastore ancestor
forward
global type n_ntchire_ds from datastore
end type
end forward

global type n_ntchire_ds from datastore
end type
global n_ntchire_ds n_ntchire_ds

on n_ntchire_ds.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ntchire_ds.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;//////////////////////////////////////////////////////////////////////////////
//	Event:			dberror
//	Description:	Display messagebox that a database error has occurred.
// 					If appropriate delay displaying the database error until the appropriate
// 					Rollback has been performed.
//////////////////////////////////////////////////////////////////////////////
string	ls_message

// The error message.
ls_message = "A database error has occurred.~r~n~r~n~r~n" + &
	"Database error code:  " + String (sqldbcode) + "~r~n~r~n" + &
	"Database error message:~r~n" + sqlerrtext

// Set the error attributes.
//il_sqldbcode = sqldbcode
//is_sqlerrtext = sqlerrtext
//is_sqlsyntax = sqlsyntax
//idwb_buffer = buffer
//il_row = row
//is_errormsg = ls_message
//ipo_inerror = this

MessageBox("Database Error", ls_message)

return 1
end event

