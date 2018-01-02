$PBExportHeader$c#dwrowselect.sru
$PBExportComments$Datawindow row selection
forward
global type c#dwrowselect from nonvisualobject
end type
end forward

global type c#dwrowselect from nonvisualobject
end type
global c#dwrowselect c#dwrowselect

type variables
//row selection
constant integer Single = 1
constant integer Multiple = 2
constant integer Extended = 3
end variables

on c#dwrowselect.create
call super::create
TriggerEvent( this, "constructor" )
end on

on c#dwrowselect.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

