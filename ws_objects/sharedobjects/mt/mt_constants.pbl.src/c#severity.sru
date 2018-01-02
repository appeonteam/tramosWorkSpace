$PBExportHeader$c#severity.sru
forward
global type c#severity from nonvisualobject
end type
end forward

global type c#severity from nonvisualobject
end type
global c#severity c#severity

type variables
//window positions
constant integer MTInfo = 3
constant integer MTWarning = 2
constant integer MTError = 1

end variables

on c#severity.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#severity.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

