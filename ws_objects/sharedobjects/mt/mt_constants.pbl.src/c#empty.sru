$PBExportHeader$c#empty.sru
forward
global type c#empty from nonvisualobject
end type
end forward

global type c#empty from nonvisualobject
end type
global c#empty c#empty

type variables
constant string String = ""
constant long Long = 0
constant integer Integer = 0
constant decimal Decimal = 0.00
constant long Number = 0
constant date Date = 1900-01-01
end variables

on c#empty.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#empty.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

