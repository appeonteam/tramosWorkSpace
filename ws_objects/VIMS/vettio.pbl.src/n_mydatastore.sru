$PBExportHeader$n_mydatastore.sru
forward
global type n_mydatastore from datastore
end type
end forward

global type n_mydatastore from datastore
end type
global n_mydatastore n_mydatastore

on n_mydatastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_mydatastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;
MessageBox(string(sqldbcode), sqlerrtext)
end event

event sqlpreview;
//Messagebox("SQL", sqlsyntax)
//f_Write2Log(sqlsyntax)
end event

