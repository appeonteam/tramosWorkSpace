$PBExportHeader$n_vouchers_parm_container.sru
forward
global type n_vouchers_parm_container from nonvisualobject
end type
end forward

global type n_vouchers_parm_container from nonvisualobject
end type
global n_vouchers_parm_container n_vouchers_parm_container

type variables
integer	ii_vouchers[]
end variables

on n_vouchers_parm_container.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_vouchers_parm_container.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

