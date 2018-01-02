$PBExportHeader$c#dwband.sru
forward
global type c#dwband from nonvisualobject
end type
end forward

global type c#dwband from nonvisualobject
end type
global c#dwband c#dwband

type variables
//data types
constant string Header = "header"
constant string Footer = "footer"
constant string Detail = "detail"
constant string Summary = "summary"
end variables

on c#dwband.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#dwband.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

