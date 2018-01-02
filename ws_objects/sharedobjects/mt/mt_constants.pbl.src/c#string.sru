$PBExportHeader$c#string.sru
forward
global type c#string from nonvisualobject
end type
end forward

global type c#string from nonvisualobject
end type
global c#string c#string

type variables
constant string Empty = ""
constant string Tab = "~t"
constant string CR = "~r"
constant string LF = "~n"
constant string CRLF = "~r~n"
constant string Space = " "

end variables

on c#string.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#string.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

