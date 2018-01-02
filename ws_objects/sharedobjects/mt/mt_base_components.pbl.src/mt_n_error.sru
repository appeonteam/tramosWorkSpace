$PBExportHeader$mt_n_error.sru
forward
global type mt_n_error from error
end type
end forward

global type mt_n_error from error
end type
global mt_n_error mt_n_error

on mt_n_error.create
call super::create
TriggerEvent( this, "constructor" )
end on

on mt_n_error.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

