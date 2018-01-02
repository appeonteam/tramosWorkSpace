$PBExportHeader$c#return.sru
forward
global type c#return from nonvisualobject
end type
end forward

global type c#return from nonvisualobject
end type
global c#return c#return

type variables
//return values
constant integer Success = 1
constant integer Failure = -1
constant integer NoAction = 0

//linkage values
constant integer PreventAction = 1
constant integer ContinueAction = 0

end variables

on c#return.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#return.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

