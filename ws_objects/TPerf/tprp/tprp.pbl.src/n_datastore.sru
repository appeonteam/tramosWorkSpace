$PBExportHeader$n_datastore.sru
forward
global type n_datastore from datastore
end type
end forward

global type n_datastore from datastore
end type
global n_datastore n_datastore

type variables
long SQLErrorCode
string SQLErrorText
end variables

event dberror;SQLErrorCode=sqldbcode
SQLErrorText=sqlerrtext 

end event

on n_datastore.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_datastore.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

